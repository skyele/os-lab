
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
  80003a:	68 cd 2e 80 00       	push   $0x802ecd
  80003f:	e8 02 07 00 00       	call   800746 <cprintf>
	exit();
  800044:	e8 ed 05 00 00       	call   800636 <exit>
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
  800069:	e8 e7 17 00 00       	call   801855 <read>
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
  800080:	e8 66 0f 00 00       	call   800feb <memset>

		req->sock = sock;
  800085:	89 5d dc             	mov    %ebx,-0x24(%ebp)
	if (strncmp(request, "GET ", 4) != 0)
  800088:	83 c4 0c             	add    $0xc,%esp
  80008b:	6a 04                	push   $0x4
  80008d:	68 1c 2d 80 00       	push   $0x802d1c
  800092:	8d 85 dc fd ff ff    	lea    -0x224(%ebp),%eax
  800098:	50                   	push   %eax
  800099:	e8 d8 0e 00 00       	call   800f76 <strncmp>
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
  8000bc:	68 00 2d 80 00       	push   $0x802d00
  8000c1:	68 04 01 00 00       	push   $0x104
  8000c6:	68 0f 2d 80 00       	push   $0x802d0f
  8000cb:	e8 80 05 00 00       	call   800650 <_panic>
	url_len = request - url;
  8000d0:	8d bd e0 fd ff ff    	lea    -0x220(%ebp),%edi
  8000d6:	89 de                	mov    %ebx,%esi
  8000d8:	29 fe                	sub    %edi,%esi
	req->url = malloc(url_len + 1);
  8000da:	83 ec 0c             	sub    $0xc,%esp
  8000dd:	8d 46 01             	lea    0x1(%esi),%eax
  8000e0:	50                   	push   %eax
  8000e1:	e8 c5 21 00 00       	call   8022ab <malloc>
  8000e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
	memmove(req->url, url, url_len);
  8000e9:	83 c4 0c             	add    $0xc,%esp
  8000ec:	56                   	push   %esi
  8000ed:	57                   	push   %edi
  8000ee:	50                   	push   %eax
  8000ef:	e8 3f 0f 00 00       	call   801033 <memmove>
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
  80011f:	e8 87 21 00 00       	call   8022ab <malloc>
  800124:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	memmove(req->version, version, version_len);
  800127:	83 c4 0c             	add    $0xc,%esp
  80012a:	53                   	push   %ebx
  80012b:	56                   	push   %esi
  80012c:	50                   	push   %eax
  80012d:	e8 01 0f 00 00       	call   801033 <memmove>
	req->version[version_len] = '\0';
  800132:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800135:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
	panic("send_file not implemented");
  800139:	83 c4 0c             	add    $0xc,%esp
  80013c:	68 21 2d 80 00       	push   $0x802d21
  800141:	68 e2 00 00 00       	push   $0xe2
  800146:	68 0f 2d 80 00       	push   $0x802d0f
  80014b:	e8 00 05 00 00       	call   800650 <_panic>
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
  800178:	68 70 2d 80 00       	push   $0x802d70
  80017d:	68 00 02 00 00       	push   $0x200
  800182:	8d b5 dc fb ff ff    	lea    -0x424(%ebp),%esi
  800188:	56                   	push   %esi
  800189:	e8 c4 0c 00 00       	call   800e52 <snprintf>
	if (write(req->sock, buf, r) != r)
  80018e:	83 c4 1c             	add    $0x1c,%esp
  800191:	50                   	push   %eax
  800192:	56                   	push   %esi
  800193:	ff 75 dc             	pushl  -0x24(%ebp)
  800196:	e8 86 17 00 00       	call   801921 <write>
  80019b:	83 c4 10             	add    $0x10,%esp
	free(req->url);
  80019e:	83 ec 0c             	sub    $0xc,%esp
  8001a1:	ff 75 e0             	pushl  -0x20(%ebp)
  8001a4:	e8 56 20 00 00       	call   8021ff <free>
	free(req->version);
  8001a9:	83 c4 04             	add    $0x4,%esp
  8001ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001af:	e8 4b 20 00 00       	call   8021ff <free>

		// no keep alive
		break;
	}

	close(sock);
  8001b4:	89 1c 24             	mov    %ebx,(%esp)
  8001b7:	e8 5b 15 00 00       	call   801717 <close>
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
  8001d0:	c7 05 20 40 80 00 3b 	movl   $0x802d3b,0x804020
  8001d7:	2d 80 00 

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  8001da:	6a 06                	push   $0x6
  8001dc:	6a 01                	push   $0x1
  8001de:	6a 02                	push   $0x2
  8001e0:	e8 9e 1d 00 00       	call   801f83 <socket>
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
  8001f9:	e8 ed 0d 00 00       	call   800feb <memset>
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
  800228:	e8 c4 1c 00 00       	call   801ef1 <bind>
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
  80023a:	e8 21 1d 00 00       	call   801f60 <listen>
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	85 c0                	test   %eax,%eax
  800244:	78 2d                	js     800273 <umain+0xac>
		die("Failed to listen on server socket");

	cprintf("Waiting for http connections...\n");
  800246:	83 ec 0c             	sub    $0xc,%esp
  800249:	68 34 2e 80 00       	push   $0x802e34
  80024e:	e8 f3 04 00 00       	call   800746 <cprintf>
  800253:	83 c4 10             	add    $0x10,%esp

	while (1) {
		unsigned int clientlen = sizeof(client);
		// Wait for client connection
		if ((clientsock = accept(serversock,
  800256:	8d 7d c4             	lea    -0x3c(%ebp),%edi
  800259:	eb 35                	jmp    800290 <umain+0xc9>
		die("Failed to create socket");
  80025b:	b8 42 2d 80 00       	mov    $0x802d42,%eax
  800260:	e8 ce fd ff ff       	call   800033 <die>
  800265:	eb 87                	jmp    8001ee <umain+0x27>
		die("Failed to bind the server socket");
  800267:	b8 ec 2d 80 00       	mov    $0x802dec,%eax
  80026c:	e8 c2 fd ff ff       	call   800033 <die>
  800271:	eb c1                	jmp    800234 <umain+0x6d>
		die("Failed to listen on server socket");
  800273:	b8 10 2e 80 00       	mov    $0x802e10,%eax
  800278:	e8 b6 fd ff ff       	call   800033 <die>
  80027d:	eb c7                	jmp    800246 <umain+0x7f>
					 (struct sockaddr *) &client,
					 &clientlen)) < 0)
		{
			die("Failed to accept client connection");
  80027f:	b8 58 2e 80 00       	mov    $0x802e58,%eax
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
  8002a0:	e8 1d 1c 00 00       	call   801ec2 <accept>
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
  8005a7:	e8 ad 0c 00 00       	call   801259 <sys_getenvid>
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

	cprintf("in libmain.c call umain!\n");
  80060b:	83 ec 0c             	sub    $0xc,%esp
  80060e:	68 a2 2e 80 00       	push   $0x802ea2
  800613:	e8 2e 01 00 00       	call   800746 <cprintf>
	// call user main routine
	umain(argc, argv);
  800618:	83 c4 08             	add    $0x8,%esp
  80061b:	ff 75 0c             	pushl  0xc(%ebp)
  80061e:	ff 75 08             	pushl  0x8(%ebp)
  800621:	e8 a1 fb ff ff       	call   8001c7 <umain>

	// exit gracefully
	exit();
  800626:	e8 0b 00 00 00       	call   800636 <exit>
}
  80062b:	83 c4 10             	add    $0x10,%esp
  80062e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800631:	5b                   	pop    %ebx
  800632:	5e                   	pop    %esi
  800633:	5f                   	pop    %edi
  800634:	5d                   	pop    %ebp
  800635:	c3                   	ret    

00800636 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800636:	55                   	push   %ebp
  800637:	89 e5                	mov    %esp,%ebp
  800639:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80063c:	e8 03 11 00 00       	call   801744 <close_all>
	sys_env_destroy(0);
  800641:	83 ec 0c             	sub    $0xc,%esp
  800644:	6a 00                	push   $0x0
  800646:	e8 cd 0b 00 00       	call   801218 <sys_env_destroy>
}
  80064b:	83 c4 10             	add    $0x10,%esp
  80064e:	c9                   	leave  
  80064f:	c3                   	ret    

00800650 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800650:	55                   	push   %ebp
  800651:	89 e5                	mov    %esp,%ebp
  800653:	56                   	push   %esi
  800654:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800655:	a1 1c 50 80 00       	mov    0x80501c,%eax
  80065a:	8b 40 48             	mov    0x48(%eax),%eax
  80065d:	83 ec 04             	sub    $0x4,%esp
  800660:	68 f8 2e 80 00       	push   $0x802ef8
  800665:	50                   	push   %eax
  800666:	68 c6 2e 80 00       	push   $0x802ec6
  80066b:	e8 d6 00 00 00       	call   800746 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800670:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800673:	8b 35 20 40 80 00    	mov    0x804020,%esi
  800679:	e8 db 0b 00 00       	call   801259 <sys_getenvid>
  80067e:	83 c4 04             	add    $0x4,%esp
  800681:	ff 75 0c             	pushl  0xc(%ebp)
  800684:	ff 75 08             	pushl  0x8(%ebp)
  800687:	56                   	push   %esi
  800688:	50                   	push   %eax
  800689:	68 d4 2e 80 00       	push   $0x802ed4
  80068e:	e8 b3 00 00 00       	call   800746 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800693:	83 c4 18             	add    $0x18,%esp
  800696:	53                   	push   %ebx
  800697:	ff 75 10             	pushl  0x10(%ebp)
  80069a:	e8 56 00 00 00       	call   8006f5 <vcprintf>
	cprintf("\n");
  80069f:	c7 04 24 ba 2e 80 00 	movl   $0x802eba,(%esp)
  8006a6:	e8 9b 00 00 00       	call   800746 <cprintf>
  8006ab:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8006ae:	cc                   	int3   
  8006af:	eb fd                	jmp    8006ae <_panic+0x5e>

008006b1 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8006b1:	55                   	push   %ebp
  8006b2:	89 e5                	mov    %esp,%ebp
  8006b4:	53                   	push   %ebx
  8006b5:	83 ec 04             	sub    $0x4,%esp
  8006b8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8006bb:	8b 13                	mov    (%ebx),%edx
  8006bd:	8d 42 01             	lea    0x1(%edx),%eax
  8006c0:	89 03                	mov    %eax,(%ebx)
  8006c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8006c5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8006c9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006ce:	74 09                	je     8006d9 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8006d0:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8006d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006d7:	c9                   	leave  
  8006d8:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8006d9:	83 ec 08             	sub    $0x8,%esp
  8006dc:	68 ff 00 00 00       	push   $0xff
  8006e1:	8d 43 08             	lea    0x8(%ebx),%eax
  8006e4:	50                   	push   %eax
  8006e5:	e8 f1 0a 00 00       	call   8011db <sys_cputs>
		b->idx = 0;
  8006ea:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8006f0:	83 c4 10             	add    $0x10,%esp
  8006f3:	eb db                	jmp    8006d0 <putch+0x1f>

008006f5 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8006f5:	55                   	push   %ebp
  8006f6:	89 e5                	mov    %esp,%ebp
  8006f8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006fe:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800705:	00 00 00 
	b.cnt = 0;
  800708:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80070f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800712:	ff 75 0c             	pushl  0xc(%ebp)
  800715:	ff 75 08             	pushl  0x8(%ebp)
  800718:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80071e:	50                   	push   %eax
  80071f:	68 b1 06 80 00       	push   $0x8006b1
  800724:	e8 4a 01 00 00       	call   800873 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800729:	83 c4 08             	add    $0x8,%esp
  80072c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800732:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800738:	50                   	push   %eax
  800739:	e8 9d 0a 00 00       	call   8011db <sys_cputs>

	return b.cnt;
}
  80073e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800744:	c9                   	leave  
  800745:	c3                   	ret    

00800746 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800746:	55                   	push   %ebp
  800747:	89 e5                	mov    %esp,%ebp
  800749:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80074c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80074f:	50                   	push   %eax
  800750:	ff 75 08             	pushl  0x8(%ebp)
  800753:	e8 9d ff ff ff       	call   8006f5 <vcprintf>
	va_end(ap);

	return cnt;
}
  800758:	c9                   	leave  
  800759:	c3                   	ret    

0080075a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80075a:	55                   	push   %ebp
  80075b:	89 e5                	mov    %esp,%ebp
  80075d:	57                   	push   %edi
  80075e:	56                   	push   %esi
  80075f:	53                   	push   %ebx
  800760:	83 ec 1c             	sub    $0x1c,%esp
  800763:	89 c6                	mov    %eax,%esi
  800765:	89 d7                	mov    %edx,%edi
  800767:	8b 45 08             	mov    0x8(%ebp),%eax
  80076a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80076d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800770:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800773:	8b 45 10             	mov    0x10(%ebp),%eax
  800776:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800779:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80077d:	74 2c                	je     8007ab <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80077f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800782:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800789:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80078c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80078f:	39 c2                	cmp    %eax,%edx
  800791:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800794:	73 43                	jae    8007d9 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800796:	83 eb 01             	sub    $0x1,%ebx
  800799:	85 db                	test   %ebx,%ebx
  80079b:	7e 6c                	jle    800809 <printnum+0xaf>
				putch(padc, putdat);
  80079d:	83 ec 08             	sub    $0x8,%esp
  8007a0:	57                   	push   %edi
  8007a1:	ff 75 18             	pushl  0x18(%ebp)
  8007a4:	ff d6                	call   *%esi
  8007a6:	83 c4 10             	add    $0x10,%esp
  8007a9:	eb eb                	jmp    800796 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8007ab:	83 ec 0c             	sub    $0xc,%esp
  8007ae:	6a 20                	push   $0x20
  8007b0:	6a 00                	push   $0x0
  8007b2:	50                   	push   %eax
  8007b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007b6:	ff 75 e0             	pushl  -0x20(%ebp)
  8007b9:	89 fa                	mov    %edi,%edx
  8007bb:	89 f0                	mov    %esi,%eax
  8007bd:	e8 98 ff ff ff       	call   80075a <printnum>
		while (--width > 0)
  8007c2:	83 c4 20             	add    $0x20,%esp
  8007c5:	83 eb 01             	sub    $0x1,%ebx
  8007c8:	85 db                	test   %ebx,%ebx
  8007ca:	7e 65                	jle    800831 <printnum+0xd7>
			putch(padc, putdat);
  8007cc:	83 ec 08             	sub    $0x8,%esp
  8007cf:	57                   	push   %edi
  8007d0:	6a 20                	push   $0x20
  8007d2:	ff d6                	call   *%esi
  8007d4:	83 c4 10             	add    $0x10,%esp
  8007d7:	eb ec                	jmp    8007c5 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8007d9:	83 ec 0c             	sub    $0xc,%esp
  8007dc:	ff 75 18             	pushl  0x18(%ebp)
  8007df:	83 eb 01             	sub    $0x1,%ebx
  8007e2:	53                   	push   %ebx
  8007e3:	50                   	push   %eax
  8007e4:	83 ec 08             	sub    $0x8,%esp
  8007e7:	ff 75 dc             	pushl  -0x24(%ebp)
  8007ea:	ff 75 d8             	pushl  -0x28(%ebp)
  8007ed:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007f0:	ff 75 e0             	pushl  -0x20(%ebp)
  8007f3:	e8 a8 22 00 00       	call   802aa0 <__udivdi3>
  8007f8:	83 c4 18             	add    $0x18,%esp
  8007fb:	52                   	push   %edx
  8007fc:	50                   	push   %eax
  8007fd:	89 fa                	mov    %edi,%edx
  8007ff:	89 f0                	mov    %esi,%eax
  800801:	e8 54 ff ff ff       	call   80075a <printnum>
  800806:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800809:	83 ec 08             	sub    $0x8,%esp
  80080c:	57                   	push   %edi
  80080d:	83 ec 04             	sub    $0x4,%esp
  800810:	ff 75 dc             	pushl  -0x24(%ebp)
  800813:	ff 75 d8             	pushl  -0x28(%ebp)
  800816:	ff 75 e4             	pushl  -0x1c(%ebp)
  800819:	ff 75 e0             	pushl  -0x20(%ebp)
  80081c:	e8 8f 23 00 00       	call   802bb0 <__umoddi3>
  800821:	83 c4 14             	add    $0x14,%esp
  800824:	0f be 80 ff 2e 80 00 	movsbl 0x802eff(%eax),%eax
  80082b:	50                   	push   %eax
  80082c:	ff d6                	call   *%esi
  80082e:	83 c4 10             	add    $0x10,%esp
	}
}
  800831:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800834:	5b                   	pop    %ebx
  800835:	5e                   	pop    %esi
  800836:	5f                   	pop    %edi
  800837:	5d                   	pop    %ebp
  800838:	c3                   	ret    

00800839 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800839:	55                   	push   %ebp
  80083a:	89 e5                	mov    %esp,%ebp
  80083c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80083f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800843:	8b 10                	mov    (%eax),%edx
  800845:	3b 50 04             	cmp    0x4(%eax),%edx
  800848:	73 0a                	jae    800854 <sprintputch+0x1b>
		*b->buf++ = ch;
  80084a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80084d:	89 08                	mov    %ecx,(%eax)
  80084f:	8b 45 08             	mov    0x8(%ebp),%eax
  800852:	88 02                	mov    %al,(%edx)
}
  800854:	5d                   	pop    %ebp
  800855:	c3                   	ret    

00800856 <printfmt>:
{
  800856:	55                   	push   %ebp
  800857:	89 e5                	mov    %esp,%ebp
  800859:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80085c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80085f:	50                   	push   %eax
  800860:	ff 75 10             	pushl  0x10(%ebp)
  800863:	ff 75 0c             	pushl  0xc(%ebp)
  800866:	ff 75 08             	pushl  0x8(%ebp)
  800869:	e8 05 00 00 00       	call   800873 <vprintfmt>
}
  80086e:	83 c4 10             	add    $0x10,%esp
  800871:	c9                   	leave  
  800872:	c3                   	ret    

00800873 <vprintfmt>:
{
  800873:	55                   	push   %ebp
  800874:	89 e5                	mov    %esp,%ebp
  800876:	57                   	push   %edi
  800877:	56                   	push   %esi
  800878:	53                   	push   %ebx
  800879:	83 ec 3c             	sub    $0x3c,%esp
  80087c:	8b 75 08             	mov    0x8(%ebp),%esi
  80087f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800882:	8b 7d 10             	mov    0x10(%ebp),%edi
  800885:	e9 32 04 00 00       	jmp    800cbc <vprintfmt+0x449>
		padc = ' ';
  80088a:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80088e:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800895:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80089c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8008a3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008aa:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8008b1:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8008b6:	8d 47 01             	lea    0x1(%edi),%eax
  8008b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008bc:	0f b6 17             	movzbl (%edi),%edx
  8008bf:	8d 42 dd             	lea    -0x23(%edx),%eax
  8008c2:	3c 55                	cmp    $0x55,%al
  8008c4:	0f 87 12 05 00 00    	ja     800ddc <vprintfmt+0x569>
  8008ca:	0f b6 c0             	movzbl %al,%eax
  8008cd:	ff 24 85 e0 30 80 00 	jmp    *0x8030e0(,%eax,4)
  8008d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8008d7:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8008db:	eb d9                	jmp    8008b6 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8008dd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8008e0:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8008e4:	eb d0                	jmp    8008b6 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8008e6:	0f b6 d2             	movzbl %dl,%edx
  8008e9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8008ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f1:	89 75 08             	mov    %esi,0x8(%ebp)
  8008f4:	eb 03                	jmp    8008f9 <vprintfmt+0x86>
  8008f6:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8008f9:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8008fc:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800900:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800903:	8d 72 d0             	lea    -0x30(%edx),%esi
  800906:	83 fe 09             	cmp    $0x9,%esi
  800909:	76 eb                	jbe    8008f6 <vprintfmt+0x83>
  80090b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80090e:	8b 75 08             	mov    0x8(%ebp),%esi
  800911:	eb 14                	jmp    800927 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800913:	8b 45 14             	mov    0x14(%ebp),%eax
  800916:	8b 00                	mov    (%eax),%eax
  800918:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80091b:	8b 45 14             	mov    0x14(%ebp),%eax
  80091e:	8d 40 04             	lea    0x4(%eax),%eax
  800921:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800924:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800927:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80092b:	79 89                	jns    8008b6 <vprintfmt+0x43>
				width = precision, precision = -1;
  80092d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800930:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800933:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80093a:	e9 77 ff ff ff       	jmp    8008b6 <vprintfmt+0x43>
  80093f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800942:	85 c0                	test   %eax,%eax
  800944:	0f 48 c1             	cmovs  %ecx,%eax
  800947:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80094a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80094d:	e9 64 ff ff ff       	jmp    8008b6 <vprintfmt+0x43>
  800952:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800955:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80095c:	e9 55 ff ff ff       	jmp    8008b6 <vprintfmt+0x43>
			lflag++;
  800961:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800965:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800968:	e9 49 ff ff ff       	jmp    8008b6 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80096d:	8b 45 14             	mov    0x14(%ebp),%eax
  800970:	8d 78 04             	lea    0x4(%eax),%edi
  800973:	83 ec 08             	sub    $0x8,%esp
  800976:	53                   	push   %ebx
  800977:	ff 30                	pushl  (%eax)
  800979:	ff d6                	call   *%esi
			break;
  80097b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80097e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800981:	e9 33 03 00 00       	jmp    800cb9 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800986:	8b 45 14             	mov    0x14(%ebp),%eax
  800989:	8d 78 04             	lea    0x4(%eax),%edi
  80098c:	8b 00                	mov    (%eax),%eax
  80098e:	99                   	cltd   
  80098f:	31 d0                	xor    %edx,%eax
  800991:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800993:	83 f8 10             	cmp    $0x10,%eax
  800996:	7f 23                	jg     8009bb <vprintfmt+0x148>
  800998:	8b 14 85 40 32 80 00 	mov    0x803240(,%eax,4),%edx
  80099f:	85 d2                	test   %edx,%edx
  8009a1:	74 18                	je     8009bb <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8009a3:	52                   	push   %edx
  8009a4:	68 59 33 80 00       	push   $0x803359
  8009a9:	53                   	push   %ebx
  8009aa:	56                   	push   %esi
  8009ab:	e8 a6 fe ff ff       	call   800856 <printfmt>
  8009b0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8009b3:	89 7d 14             	mov    %edi,0x14(%ebp)
  8009b6:	e9 fe 02 00 00       	jmp    800cb9 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8009bb:	50                   	push   %eax
  8009bc:	68 17 2f 80 00       	push   $0x802f17
  8009c1:	53                   	push   %ebx
  8009c2:	56                   	push   %esi
  8009c3:	e8 8e fe ff ff       	call   800856 <printfmt>
  8009c8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8009cb:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8009ce:	e9 e6 02 00 00       	jmp    800cb9 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8009d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d6:	83 c0 04             	add    $0x4,%eax
  8009d9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8009dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009df:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8009e1:	85 c9                	test   %ecx,%ecx
  8009e3:	b8 10 2f 80 00       	mov    $0x802f10,%eax
  8009e8:	0f 45 c1             	cmovne %ecx,%eax
  8009eb:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8009ee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009f2:	7e 06                	jle    8009fa <vprintfmt+0x187>
  8009f4:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8009f8:	75 0d                	jne    800a07 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009fa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8009fd:	89 c7                	mov    %eax,%edi
  8009ff:	03 45 e0             	add    -0x20(%ebp),%eax
  800a02:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a05:	eb 53                	jmp    800a5a <vprintfmt+0x1e7>
  800a07:	83 ec 08             	sub    $0x8,%esp
  800a0a:	ff 75 d8             	pushl  -0x28(%ebp)
  800a0d:	50                   	push   %eax
  800a0e:	e8 71 04 00 00       	call   800e84 <strnlen>
  800a13:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800a16:	29 c1                	sub    %eax,%ecx
  800a18:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800a1b:	83 c4 10             	add    $0x10,%esp
  800a1e:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800a20:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800a24:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800a27:	eb 0f                	jmp    800a38 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800a29:	83 ec 08             	sub    $0x8,%esp
  800a2c:	53                   	push   %ebx
  800a2d:	ff 75 e0             	pushl  -0x20(%ebp)
  800a30:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800a32:	83 ef 01             	sub    $0x1,%edi
  800a35:	83 c4 10             	add    $0x10,%esp
  800a38:	85 ff                	test   %edi,%edi
  800a3a:	7f ed                	jg     800a29 <vprintfmt+0x1b6>
  800a3c:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800a3f:	85 c9                	test   %ecx,%ecx
  800a41:	b8 00 00 00 00       	mov    $0x0,%eax
  800a46:	0f 49 c1             	cmovns %ecx,%eax
  800a49:	29 c1                	sub    %eax,%ecx
  800a4b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800a4e:	eb aa                	jmp    8009fa <vprintfmt+0x187>
					putch(ch, putdat);
  800a50:	83 ec 08             	sub    $0x8,%esp
  800a53:	53                   	push   %ebx
  800a54:	52                   	push   %edx
  800a55:	ff d6                	call   *%esi
  800a57:	83 c4 10             	add    $0x10,%esp
  800a5a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800a5d:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a5f:	83 c7 01             	add    $0x1,%edi
  800a62:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a66:	0f be d0             	movsbl %al,%edx
  800a69:	85 d2                	test   %edx,%edx
  800a6b:	74 4b                	je     800ab8 <vprintfmt+0x245>
  800a6d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800a71:	78 06                	js     800a79 <vprintfmt+0x206>
  800a73:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800a77:	78 1e                	js     800a97 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800a79:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800a7d:	74 d1                	je     800a50 <vprintfmt+0x1dd>
  800a7f:	0f be c0             	movsbl %al,%eax
  800a82:	83 e8 20             	sub    $0x20,%eax
  800a85:	83 f8 5e             	cmp    $0x5e,%eax
  800a88:	76 c6                	jbe    800a50 <vprintfmt+0x1dd>
					putch('?', putdat);
  800a8a:	83 ec 08             	sub    $0x8,%esp
  800a8d:	53                   	push   %ebx
  800a8e:	6a 3f                	push   $0x3f
  800a90:	ff d6                	call   *%esi
  800a92:	83 c4 10             	add    $0x10,%esp
  800a95:	eb c3                	jmp    800a5a <vprintfmt+0x1e7>
  800a97:	89 cf                	mov    %ecx,%edi
  800a99:	eb 0e                	jmp    800aa9 <vprintfmt+0x236>
				putch(' ', putdat);
  800a9b:	83 ec 08             	sub    $0x8,%esp
  800a9e:	53                   	push   %ebx
  800a9f:	6a 20                	push   $0x20
  800aa1:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800aa3:	83 ef 01             	sub    $0x1,%edi
  800aa6:	83 c4 10             	add    $0x10,%esp
  800aa9:	85 ff                	test   %edi,%edi
  800aab:	7f ee                	jg     800a9b <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800aad:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800ab0:	89 45 14             	mov    %eax,0x14(%ebp)
  800ab3:	e9 01 02 00 00       	jmp    800cb9 <vprintfmt+0x446>
  800ab8:	89 cf                	mov    %ecx,%edi
  800aba:	eb ed                	jmp    800aa9 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800abc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800abf:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800ac6:	e9 eb fd ff ff       	jmp    8008b6 <vprintfmt+0x43>
	if (lflag >= 2)
  800acb:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800acf:	7f 21                	jg     800af2 <vprintfmt+0x27f>
	else if (lflag)
  800ad1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800ad5:	74 68                	je     800b3f <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800ad7:	8b 45 14             	mov    0x14(%ebp),%eax
  800ada:	8b 00                	mov    (%eax),%eax
  800adc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800adf:	89 c1                	mov    %eax,%ecx
  800ae1:	c1 f9 1f             	sar    $0x1f,%ecx
  800ae4:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800ae7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aea:	8d 40 04             	lea    0x4(%eax),%eax
  800aed:	89 45 14             	mov    %eax,0x14(%ebp)
  800af0:	eb 17                	jmp    800b09 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800af2:	8b 45 14             	mov    0x14(%ebp),%eax
  800af5:	8b 50 04             	mov    0x4(%eax),%edx
  800af8:	8b 00                	mov    (%eax),%eax
  800afa:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800afd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800b00:	8b 45 14             	mov    0x14(%ebp),%eax
  800b03:	8d 40 08             	lea    0x8(%eax),%eax
  800b06:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800b09:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800b0c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800b0f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b12:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800b15:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800b19:	78 3f                	js     800b5a <vprintfmt+0x2e7>
			base = 10;
  800b1b:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800b20:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800b24:	0f 84 71 01 00 00    	je     800c9b <vprintfmt+0x428>
				putch('+', putdat);
  800b2a:	83 ec 08             	sub    $0x8,%esp
  800b2d:	53                   	push   %ebx
  800b2e:	6a 2b                	push   $0x2b
  800b30:	ff d6                	call   *%esi
  800b32:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800b35:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b3a:	e9 5c 01 00 00       	jmp    800c9b <vprintfmt+0x428>
		return va_arg(*ap, int);
  800b3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b42:	8b 00                	mov    (%eax),%eax
  800b44:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800b47:	89 c1                	mov    %eax,%ecx
  800b49:	c1 f9 1f             	sar    $0x1f,%ecx
  800b4c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800b4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b52:	8d 40 04             	lea    0x4(%eax),%eax
  800b55:	89 45 14             	mov    %eax,0x14(%ebp)
  800b58:	eb af                	jmp    800b09 <vprintfmt+0x296>
				putch('-', putdat);
  800b5a:	83 ec 08             	sub    $0x8,%esp
  800b5d:	53                   	push   %ebx
  800b5e:	6a 2d                	push   $0x2d
  800b60:	ff d6                	call   *%esi
				num = -(long long) num;
  800b62:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800b65:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800b68:	f7 d8                	neg    %eax
  800b6a:	83 d2 00             	adc    $0x0,%edx
  800b6d:	f7 da                	neg    %edx
  800b6f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b72:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b75:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800b78:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b7d:	e9 19 01 00 00       	jmp    800c9b <vprintfmt+0x428>
	if (lflag >= 2)
  800b82:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800b86:	7f 29                	jg     800bb1 <vprintfmt+0x33e>
	else if (lflag)
  800b88:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800b8c:	74 44                	je     800bd2 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800b8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b91:	8b 00                	mov    (%eax),%eax
  800b93:	ba 00 00 00 00       	mov    $0x0,%edx
  800b98:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b9b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba1:	8d 40 04             	lea    0x4(%eax),%eax
  800ba4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800ba7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bac:	e9 ea 00 00 00       	jmp    800c9b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800bb1:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb4:	8b 50 04             	mov    0x4(%eax),%edx
  800bb7:	8b 00                	mov    (%eax),%eax
  800bb9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bbc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800bbf:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc2:	8d 40 08             	lea    0x8(%eax),%eax
  800bc5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800bc8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bcd:	e9 c9 00 00 00       	jmp    800c9b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800bd2:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd5:	8b 00                	mov    (%eax),%eax
  800bd7:	ba 00 00 00 00       	mov    $0x0,%edx
  800bdc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bdf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800be2:	8b 45 14             	mov    0x14(%ebp),%eax
  800be5:	8d 40 04             	lea    0x4(%eax),%eax
  800be8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800beb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bf0:	e9 a6 00 00 00       	jmp    800c9b <vprintfmt+0x428>
			putch('0', putdat);
  800bf5:	83 ec 08             	sub    $0x8,%esp
  800bf8:	53                   	push   %ebx
  800bf9:	6a 30                	push   $0x30
  800bfb:	ff d6                	call   *%esi
	if (lflag >= 2)
  800bfd:	83 c4 10             	add    $0x10,%esp
  800c00:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800c04:	7f 26                	jg     800c2c <vprintfmt+0x3b9>
	else if (lflag)
  800c06:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800c0a:	74 3e                	je     800c4a <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800c0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c0f:	8b 00                	mov    (%eax),%eax
  800c11:	ba 00 00 00 00       	mov    $0x0,%edx
  800c16:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c19:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c1f:	8d 40 04             	lea    0x4(%eax),%eax
  800c22:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800c25:	b8 08 00 00 00       	mov    $0x8,%eax
  800c2a:	eb 6f                	jmp    800c9b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800c2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c2f:	8b 50 04             	mov    0x4(%eax),%edx
  800c32:	8b 00                	mov    (%eax),%eax
  800c34:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c37:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c3a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c3d:	8d 40 08             	lea    0x8(%eax),%eax
  800c40:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800c43:	b8 08 00 00 00       	mov    $0x8,%eax
  800c48:	eb 51                	jmp    800c9b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800c4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4d:	8b 00                	mov    (%eax),%eax
  800c4f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c54:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c57:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c5a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c5d:	8d 40 04             	lea    0x4(%eax),%eax
  800c60:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800c63:	b8 08 00 00 00       	mov    $0x8,%eax
  800c68:	eb 31                	jmp    800c9b <vprintfmt+0x428>
			putch('0', putdat);
  800c6a:	83 ec 08             	sub    $0x8,%esp
  800c6d:	53                   	push   %ebx
  800c6e:	6a 30                	push   $0x30
  800c70:	ff d6                	call   *%esi
			putch('x', putdat);
  800c72:	83 c4 08             	add    $0x8,%esp
  800c75:	53                   	push   %ebx
  800c76:	6a 78                	push   $0x78
  800c78:	ff d6                	call   *%esi
			num = (unsigned long long)
  800c7a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c7d:	8b 00                	mov    (%eax),%eax
  800c7f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c84:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c87:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800c8a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800c8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c90:	8d 40 04             	lea    0x4(%eax),%eax
  800c93:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c96:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800c9b:	83 ec 0c             	sub    $0xc,%esp
  800c9e:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800ca2:	52                   	push   %edx
  800ca3:	ff 75 e0             	pushl  -0x20(%ebp)
  800ca6:	50                   	push   %eax
  800ca7:	ff 75 dc             	pushl  -0x24(%ebp)
  800caa:	ff 75 d8             	pushl  -0x28(%ebp)
  800cad:	89 da                	mov    %ebx,%edx
  800caf:	89 f0                	mov    %esi,%eax
  800cb1:	e8 a4 fa ff ff       	call   80075a <printnum>
			break;
  800cb6:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800cb9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cbc:	83 c7 01             	add    $0x1,%edi
  800cbf:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800cc3:	83 f8 25             	cmp    $0x25,%eax
  800cc6:	0f 84 be fb ff ff    	je     80088a <vprintfmt+0x17>
			if (ch == '\0')
  800ccc:	85 c0                	test   %eax,%eax
  800cce:	0f 84 28 01 00 00    	je     800dfc <vprintfmt+0x589>
			putch(ch, putdat);
  800cd4:	83 ec 08             	sub    $0x8,%esp
  800cd7:	53                   	push   %ebx
  800cd8:	50                   	push   %eax
  800cd9:	ff d6                	call   *%esi
  800cdb:	83 c4 10             	add    $0x10,%esp
  800cde:	eb dc                	jmp    800cbc <vprintfmt+0x449>
	if (lflag >= 2)
  800ce0:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800ce4:	7f 26                	jg     800d0c <vprintfmt+0x499>
	else if (lflag)
  800ce6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800cea:	74 41                	je     800d2d <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800cec:	8b 45 14             	mov    0x14(%ebp),%eax
  800cef:	8b 00                	mov    (%eax),%eax
  800cf1:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800cf9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800cfc:	8b 45 14             	mov    0x14(%ebp),%eax
  800cff:	8d 40 04             	lea    0x4(%eax),%eax
  800d02:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d05:	b8 10 00 00 00       	mov    $0x10,%eax
  800d0a:	eb 8f                	jmp    800c9b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800d0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d0f:	8b 50 04             	mov    0x4(%eax),%edx
  800d12:	8b 00                	mov    (%eax),%eax
  800d14:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d17:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1d:	8d 40 08             	lea    0x8(%eax),%eax
  800d20:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d23:	b8 10 00 00 00       	mov    $0x10,%eax
  800d28:	e9 6e ff ff ff       	jmp    800c9b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800d2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d30:	8b 00                	mov    (%eax),%eax
  800d32:	ba 00 00 00 00       	mov    $0x0,%edx
  800d37:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d3a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d40:	8d 40 04             	lea    0x4(%eax),%eax
  800d43:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d46:	b8 10 00 00 00       	mov    $0x10,%eax
  800d4b:	e9 4b ff ff ff       	jmp    800c9b <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800d50:	8b 45 14             	mov    0x14(%ebp),%eax
  800d53:	83 c0 04             	add    $0x4,%eax
  800d56:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d59:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5c:	8b 00                	mov    (%eax),%eax
  800d5e:	85 c0                	test   %eax,%eax
  800d60:	74 14                	je     800d76 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800d62:	8b 13                	mov    (%ebx),%edx
  800d64:	83 fa 7f             	cmp    $0x7f,%edx
  800d67:	7f 37                	jg     800da0 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800d69:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800d6b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d6e:	89 45 14             	mov    %eax,0x14(%ebp)
  800d71:	e9 43 ff ff ff       	jmp    800cb9 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800d76:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d7b:	bf 35 30 80 00       	mov    $0x803035,%edi
							putch(ch, putdat);
  800d80:	83 ec 08             	sub    $0x8,%esp
  800d83:	53                   	push   %ebx
  800d84:	50                   	push   %eax
  800d85:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800d87:	83 c7 01             	add    $0x1,%edi
  800d8a:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800d8e:	83 c4 10             	add    $0x10,%esp
  800d91:	85 c0                	test   %eax,%eax
  800d93:	75 eb                	jne    800d80 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800d95:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d98:	89 45 14             	mov    %eax,0x14(%ebp)
  800d9b:	e9 19 ff ff ff       	jmp    800cb9 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800da0:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800da2:	b8 0a 00 00 00       	mov    $0xa,%eax
  800da7:	bf 6d 30 80 00       	mov    $0x80306d,%edi
							putch(ch, putdat);
  800dac:	83 ec 08             	sub    $0x8,%esp
  800daf:	53                   	push   %ebx
  800db0:	50                   	push   %eax
  800db1:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800db3:	83 c7 01             	add    $0x1,%edi
  800db6:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800dba:	83 c4 10             	add    $0x10,%esp
  800dbd:	85 c0                	test   %eax,%eax
  800dbf:	75 eb                	jne    800dac <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800dc1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800dc4:	89 45 14             	mov    %eax,0x14(%ebp)
  800dc7:	e9 ed fe ff ff       	jmp    800cb9 <vprintfmt+0x446>
			putch(ch, putdat);
  800dcc:	83 ec 08             	sub    $0x8,%esp
  800dcf:	53                   	push   %ebx
  800dd0:	6a 25                	push   $0x25
  800dd2:	ff d6                	call   *%esi
			break;
  800dd4:	83 c4 10             	add    $0x10,%esp
  800dd7:	e9 dd fe ff ff       	jmp    800cb9 <vprintfmt+0x446>
			putch('%', putdat);
  800ddc:	83 ec 08             	sub    $0x8,%esp
  800ddf:	53                   	push   %ebx
  800de0:	6a 25                	push   $0x25
  800de2:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800de4:	83 c4 10             	add    $0x10,%esp
  800de7:	89 f8                	mov    %edi,%eax
  800de9:	eb 03                	jmp    800dee <vprintfmt+0x57b>
  800deb:	83 e8 01             	sub    $0x1,%eax
  800dee:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800df2:	75 f7                	jne    800deb <vprintfmt+0x578>
  800df4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800df7:	e9 bd fe ff ff       	jmp    800cb9 <vprintfmt+0x446>
}
  800dfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dff:	5b                   	pop    %ebx
  800e00:	5e                   	pop    %esi
  800e01:	5f                   	pop    %edi
  800e02:	5d                   	pop    %ebp
  800e03:	c3                   	ret    

00800e04 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	83 ec 18             	sub    $0x18,%esp
  800e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e13:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800e17:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800e1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e21:	85 c0                	test   %eax,%eax
  800e23:	74 26                	je     800e4b <vsnprintf+0x47>
  800e25:	85 d2                	test   %edx,%edx
  800e27:	7e 22                	jle    800e4b <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e29:	ff 75 14             	pushl  0x14(%ebp)
  800e2c:	ff 75 10             	pushl  0x10(%ebp)
  800e2f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e32:	50                   	push   %eax
  800e33:	68 39 08 80 00       	push   $0x800839
  800e38:	e8 36 fa ff ff       	call   800873 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800e3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e40:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e46:	83 c4 10             	add    $0x10,%esp
}
  800e49:	c9                   	leave  
  800e4a:	c3                   	ret    
		return -E_INVAL;
  800e4b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e50:	eb f7                	jmp    800e49 <vsnprintf+0x45>

00800e52 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e52:	55                   	push   %ebp
  800e53:	89 e5                	mov    %esp,%ebp
  800e55:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e58:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800e5b:	50                   	push   %eax
  800e5c:	ff 75 10             	pushl  0x10(%ebp)
  800e5f:	ff 75 0c             	pushl  0xc(%ebp)
  800e62:	ff 75 08             	pushl  0x8(%ebp)
  800e65:	e8 9a ff ff ff       	call   800e04 <vsnprintf>
	va_end(ap);

	return rc;
}
  800e6a:	c9                   	leave  
  800e6b:	c3                   	ret    

00800e6c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e6c:	55                   	push   %ebp
  800e6d:	89 e5                	mov    %esp,%ebp
  800e6f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800e72:	b8 00 00 00 00       	mov    $0x0,%eax
  800e77:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800e7b:	74 05                	je     800e82 <strlen+0x16>
		n++;
  800e7d:	83 c0 01             	add    $0x1,%eax
  800e80:	eb f5                	jmp    800e77 <strlen+0xb>
	return n;
}
  800e82:	5d                   	pop    %ebp
  800e83:	c3                   	ret    

00800e84 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e84:	55                   	push   %ebp
  800e85:	89 e5                	mov    %esp,%ebp
  800e87:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e8a:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e8d:	ba 00 00 00 00       	mov    $0x0,%edx
  800e92:	39 c2                	cmp    %eax,%edx
  800e94:	74 0d                	je     800ea3 <strnlen+0x1f>
  800e96:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800e9a:	74 05                	je     800ea1 <strnlen+0x1d>
		n++;
  800e9c:	83 c2 01             	add    $0x1,%edx
  800e9f:	eb f1                	jmp    800e92 <strnlen+0xe>
  800ea1:	89 d0                	mov    %edx,%eax
	return n;
}
  800ea3:	5d                   	pop    %ebp
  800ea4:	c3                   	ret    

00800ea5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	53                   	push   %ebx
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800eaf:	ba 00 00 00 00       	mov    $0x0,%edx
  800eb4:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800eb8:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800ebb:	83 c2 01             	add    $0x1,%edx
  800ebe:	84 c9                	test   %cl,%cl
  800ec0:	75 f2                	jne    800eb4 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800ec2:	5b                   	pop    %ebx
  800ec3:	5d                   	pop    %ebp
  800ec4:	c3                   	ret    

00800ec5 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ec5:	55                   	push   %ebp
  800ec6:	89 e5                	mov    %esp,%ebp
  800ec8:	53                   	push   %ebx
  800ec9:	83 ec 10             	sub    $0x10,%esp
  800ecc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800ecf:	53                   	push   %ebx
  800ed0:	e8 97 ff ff ff       	call   800e6c <strlen>
  800ed5:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800ed8:	ff 75 0c             	pushl  0xc(%ebp)
  800edb:	01 d8                	add    %ebx,%eax
  800edd:	50                   	push   %eax
  800ede:	e8 c2 ff ff ff       	call   800ea5 <strcpy>
	return dst;
}
  800ee3:	89 d8                	mov    %ebx,%eax
  800ee5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ee8:	c9                   	leave  
  800ee9:	c3                   	ret    

00800eea <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800eea:	55                   	push   %ebp
  800eeb:	89 e5                	mov    %esp,%ebp
  800eed:	56                   	push   %esi
  800eee:	53                   	push   %ebx
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef5:	89 c6                	mov    %eax,%esi
  800ef7:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800efa:	89 c2                	mov    %eax,%edx
  800efc:	39 f2                	cmp    %esi,%edx
  800efe:	74 11                	je     800f11 <strncpy+0x27>
		*dst++ = *src;
  800f00:	83 c2 01             	add    $0x1,%edx
  800f03:	0f b6 19             	movzbl (%ecx),%ebx
  800f06:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800f09:	80 fb 01             	cmp    $0x1,%bl
  800f0c:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800f0f:	eb eb                	jmp    800efc <strncpy+0x12>
	}
	return ret;
}
  800f11:	5b                   	pop    %ebx
  800f12:	5e                   	pop    %esi
  800f13:	5d                   	pop    %ebp
  800f14:	c3                   	ret    

00800f15 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
  800f18:	56                   	push   %esi
  800f19:	53                   	push   %ebx
  800f1a:	8b 75 08             	mov    0x8(%ebp),%esi
  800f1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f20:	8b 55 10             	mov    0x10(%ebp),%edx
  800f23:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800f25:	85 d2                	test   %edx,%edx
  800f27:	74 21                	je     800f4a <strlcpy+0x35>
  800f29:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800f2d:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800f2f:	39 c2                	cmp    %eax,%edx
  800f31:	74 14                	je     800f47 <strlcpy+0x32>
  800f33:	0f b6 19             	movzbl (%ecx),%ebx
  800f36:	84 db                	test   %bl,%bl
  800f38:	74 0b                	je     800f45 <strlcpy+0x30>
			*dst++ = *src++;
  800f3a:	83 c1 01             	add    $0x1,%ecx
  800f3d:	83 c2 01             	add    $0x1,%edx
  800f40:	88 5a ff             	mov    %bl,-0x1(%edx)
  800f43:	eb ea                	jmp    800f2f <strlcpy+0x1a>
  800f45:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800f47:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f4a:	29 f0                	sub    %esi,%eax
}
  800f4c:	5b                   	pop    %ebx
  800f4d:	5e                   	pop    %esi
  800f4e:	5d                   	pop    %ebp
  800f4f:	c3                   	ret    

00800f50 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
  800f53:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f56:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800f59:	0f b6 01             	movzbl (%ecx),%eax
  800f5c:	84 c0                	test   %al,%al
  800f5e:	74 0c                	je     800f6c <strcmp+0x1c>
  800f60:	3a 02                	cmp    (%edx),%al
  800f62:	75 08                	jne    800f6c <strcmp+0x1c>
		p++, q++;
  800f64:	83 c1 01             	add    $0x1,%ecx
  800f67:	83 c2 01             	add    $0x1,%edx
  800f6a:	eb ed                	jmp    800f59 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f6c:	0f b6 c0             	movzbl %al,%eax
  800f6f:	0f b6 12             	movzbl (%edx),%edx
  800f72:	29 d0                	sub    %edx,%eax
}
  800f74:	5d                   	pop    %ebp
  800f75:	c3                   	ret    

00800f76 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
  800f79:	53                   	push   %ebx
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f80:	89 c3                	mov    %eax,%ebx
  800f82:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800f85:	eb 06                	jmp    800f8d <strncmp+0x17>
		n--, p++, q++;
  800f87:	83 c0 01             	add    $0x1,%eax
  800f8a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800f8d:	39 d8                	cmp    %ebx,%eax
  800f8f:	74 16                	je     800fa7 <strncmp+0x31>
  800f91:	0f b6 08             	movzbl (%eax),%ecx
  800f94:	84 c9                	test   %cl,%cl
  800f96:	74 04                	je     800f9c <strncmp+0x26>
  800f98:	3a 0a                	cmp    (%edx),%cl
  800f9a:	74 eb                	je     800f87 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f9c:	0f b6 00             	movzbl (%eax),%eax
  800f9f:	0f b6 12             	movzbl (%edx),%edx
  800fa2:	29 d0                	sub    %edx,%eax
}
  800fa4:	5b                   	pop    %ebx
  800fa5:	5d                   	pop    %ebp
  800fa6:	c3                   	ret    
		return 0;
  800fa7:	b8 00 00 00 00       	mov    $0x0,%eax
  800fac:	eb f6                	jmp    800fa4 <strncmp+0x2e>

00800fae <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fae:	55                   	push   %ebp
  800faf:	89 e5                	mov    %esp,%ebp
  800fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800fb8:	0f b6 10             	movzbl (%eax),%edx
  800fbb:	84 d2                	test   %dl,%dl
  800fbd:	74 09                	je     800fc8 <strchr+0x1a>
		if (*s == c)
  800fbf:	38 ca                	cmp    %cl,%dl
  800fc1:	74 0a                	je     800fcd <strchr+0x1f>
	for (; *s; s++)
  800fc3:	83 c0 01             	add    $0x1,%eax
  800fc6:	eb f0                	jmp    800fb8 <strchr+0xa>
			return (char *) s;
	return 0;
  800fc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fcd:	5d                   	pop    %ebp
  800fce:	c3                   	ret    

00800fcf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fcf:	55                   	push   %ebp
  800fd0:	89 e5                	mov    %esp,%ebp
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800fd9:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800fdc:	38 ca                	cmp    %cl,%dl
  800fde:	74 09                	je     800fe9 <strfind+0x1a>
  800fe0:	84 d2                	test   %dl,%dl
  800fe2:	74 05                	je     800fe9 <strfind+0x1a>
	for (; *s; s++)
  800fe4:	83 c0 01             	add    $0x1,%eax
  800fe7:	eb f0                	jmp    800fd9 <strfind+0xa>
			break;
	return (char *) s;
}
  800fe9:	5d                   	pop    %ebp
  800fea:	c3                   	ret    

00800feb <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800feb:	55                   	push   %ebp
  800fec:	89 e5                	mov    %esp,%ebp
  800fee:	57                   	push   %edi
  800fef:	56                   	push   %esi
  800ff0:	53                   	push   %ebx
  800ff1:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ff4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ff7:	85 c9                	test   %ecx,%ecx
  800ff9:	74 31                	je     80102c <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ffb:	89 f8                	mov    %edi,%eax
  800ffd:	09 c8                	or     %ecx,%eax
  800fff:	a8 03                	test   $0x3,%al
  801001:	75 23                	jne    801026 <memset+0x3b>
		c &= 0xFF;
  801003:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801007:	89 d3                	mov    %edx,%ebx
  801009:	c1 e3 08             	shl    $0x8,%ebx
  80100c:	89 d0                	mov    %edx,%eax
  80100e:	c1 e0 18             	shl    $0x18,%eax
  801011:	89 d6                	mov    %edx,%esi
  801013:	c1 e6 10             	shl    $0x10,%esi
  801016:	09 f0                	or     %esi,%eax
  801018:	09 c2                	or     %eax,%edx
  80101a:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80101c:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80101f:	89 d0                	mov    %edx,%eax
  801021:	fc                   	cld    
  801022:	f3 ab                	rep stos %eax,%es:(%edi)
  801024:	eb 06                	jmp    80102c <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801026:	8b 45 0c             	mov    0xc(%ebp),%eax
  801029:	fc                   	cld    
  80102a:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80102c:	89 f8                	mov    %edi,%eax
  80102e:	5b                   	pop    %ebx
  80102f:	5e                   	pop    %esi
  801030:	5f                   	pop    %edi
  801031:	5d                   	pop    %ebp
  801032:	c3                   	ret    

00801033 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801033:	55                   	push   %ebp
  801034:	89 e5                	mov    %esp,%ebp
  801036:	57                   	push   %edi
  801037:	56                   	push   %esi
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80103e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801041:	39 c6                	cmp    %eax,%esi
  801043:	73 32                	jae    801077 <memmove+0x44>
  801045:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801048:	39 c2                	cmp    %eax,%edx
  80104a:	76 2b                	jbe    801077 <memmove+0x44>
		s += n;
		d += n;
  80104c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80104f:	89 fe                	mov    %edi,%esi
  801051:	09 ce                	or     %ecx,%esi
  801053:	09 d6                	or     %edx,%esi
  801055:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80105b:	75 0e                	jne    80106b <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80105d:	83 ef 04             	sub    $0x4,%edi
  801060:	8d 72 fc             	lea    -0x4(%edx),%esi
  801063:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801066:	fd                   	std    
  801067:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801069:	eb 09                	jmp    801074 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80106b:	83 ef 01             	sub    $0x1,%edi
  80106e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801071:	fd                   	std    
  801072:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801074:	fc                   	cld    
  801075:	eb 1a                	jmp    801091 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801077:	89 c2                	mov    %eax,%edx
  801079:	09 ca                	or     %ecx,%edx
  80107b:	09 f2                	or     %esi,%edx
  80107d:	f6 c2 03             	test   $0x3,%dl
  801080:	75 0a                	jne    80108c <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801082:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801085:	89 c7                	mov    %eax,%edi
  801087:	fc                   	cld    
  801088:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80108a:	eb 05                	jmp    801091 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  80108c:	89 c7                	mov    %eax,%edi
  80108e:	fc                   	cld    
  80108f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801091:	5e                   	pop    %esi
  801092:	5f                   	pop    %edi
  801093:	5d                   	pop    %ebp
  801094:	c3                   	ret    

00801095 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801095:	55                   	push   %ebp
  801096:	89 e5                	mov    %esp,%ebp
  801098:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  80109b:	ff 75 10             	pushl  0x10(%ebp)
  80109e:	ff 75 0c             	pushl  0xc(%ebp)
  8010a1:	ff 75 08             	pushl  0x8(%ebp)
  8010a4:	e8 8a ff ff ff       	call   801033 <memmove>
}
  8010a9:	c9                   	leave  
  8010aa:	c3                   	ret    

008010ab <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8010ab:	55                   	push   %ebp
  8010ac:	89 e5                	mov    %esp,%ebp
  8010ae:	56                   	push   %esi
  8010af:	53                   	push   %ebx
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b6:	89 c6                	mov    %eax,%esi
  8010b8:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8010bb:	39 f0                	cmp    %esi,%eax
  8010bd:	74 1c                	je     8010db <memcmp+0x30>
		if (*s1 != *s2)
  8010bf:	0f b6 08             	movzbl (%eax),%ecx
  8010c2:	0f b6 1a             	movzbl (%edx),%ebx
  8010c5:	38 d9                	cmp    %bl,%cl
  8010c7:	75 08                	jne    8010d1 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8010c9:	83 c0 01             	add    $0x1,%eax
  8010cc:	83 c2 01             	add    $0x1,%edx
  8010cf:	eb ea                	jmp    8010bb <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8010d1:	0f b6 c1             	movzbl %cl,%eax
  8010d4:	0f b6 db             	movzbl %bl,%ebx
  8010d7:	29 d8                	sub    %ebx,%eax
  8010d9:	eb 05                	jmp    8010e0 <memcmp+0x35>
	}

	return 0;
  8010db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010e0:	5b                   	pop    %ebx
  8010e1:	5e                   	pop    %esi
  8010e2:	5d                   	pop    %ebp
  8010e3:	c3                   	ret    

008010e4 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8010e4:	55                   	push   %ebp
  8010e5:	89 e5                	mov    %esp,%ebp
  8010e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8010ed:	89 c2                	mov    %eax,%edx
  8010ef:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8010f2:	39 d0                	cmp    %edx,%eax
  8010f4:	73 09                	jae    8010ff <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010f6:	38 08                	cmp    %cl,(%eax)
  8010f8:	74 05                	je     8010ff <memfind+0x1b>
	for (; s < ends; s++)
  8010fa:	83 c0 01             	add    $0x1,%eax
  8010fd:	eb f3                	jmp    8010f2 <memfind+0xe>
			break;
	return (void *) s;
}
  8010ff:	5d                   	pop    %ebp
  801100:	c3                   	ret    

00801101 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801101:	55                   	push   %ebp
  801102:	89 e5                	mov    %esp,%ebp
  801104:	57                   	push   %edi
  801105:	56                   	push   %esi
  801106:	53                   	push   %ebx
  801107:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80110a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80110d:	eb 03                	jmp    801112 <strtol+0x11>
		s++;
  80110f:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801112:	0f b6 01             	movzbl (%ecx),%eax
  801115:	3c 20                	cmp    $0x20,%al
  801117:	74 f6                	je     80110f <strtol+0xe>
  801119:	3c 09                	cmp    $0x9,%al
  80111b:	74 f2                	je     80110f <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  80111d:	3c 2b                	cmp    $0x2b,%al
  80111f:	74 2a                	je     80114b <strtol+0x4a>
	int neg = 0;
  801121:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801126:	3c 2d                	cmp    $0x2d,%al
  801128:	74 2b                	je     801155 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80112a:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801130:	75 0f                	jne    801141 <strtol+0x40>
  801132:	80 39 30             	cmpb   $0x30,(%ecx)
  801135:	74 28                	je     80115f <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801137:	85 db                	test   %ebx,%ebx
  801139:	b8 0a 00 00 00       	mov    $0xa,%eax
  80113e:	0f 44 d8             	cmove  %eax,%ebx
  801141:	b8 00 00 00 00       	mov    $0x0,%eax
  801146:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801149:	eb 50                	jmp    80119b <strtol+0x9a>
		s++;
  80114b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  80114e:	bf 00 00 00 00       	mov    $0x0,%edi
  801153:	eb d5                	jmp    80112a <strtol+0x29>
		s++, neg = 1;
  801155:	83 c1 01             	add    $0x1,%ecx
  801158:	bf 01 00 00 00       	mov    $0x1,%edi
  80115d:	eb cb                	jmp    80112a <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80115f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801163:	74 0e                	je     801173 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  801165:	85 db                	test   %ebx,%ebx
  801167:	75 d8                	jne    801141 <strtol+0x40>
		s++, base = 8;
  801169:	83 c1 01             	add    $0x1,%ecx
  80116c:	bb 08 00 00 00       	mov    $0x8,%ebx
  801171:	eb ce                	jmp    801141 <strtol+0x40>
		s += 2, base = 16;
  801173:	83 c1 02             	add    $0x2,%ecx
  801176:	bb 10 00 00 00       	mov    $0x10,%ebx
  80117b:	eb c4                	jmp    801141 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  80117d:	8d 72 9f             	lea    -0x61(%edx),%esi
  801180:	89 f3                	mov    %esi,%ebx
  801182:	80 fb 19             	cmp    $0x19,%bl
  801185:	77 29                	ja     8011b0 <strtol+0xaf>
			dig = *s - 'a' + 10;
  801187:	0f be d2             	movsbl %dl,%edx
  80118a:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  80118d:	3b 55 10             	cmp    0x10(%ebp),%edx
  801190:	7d 30                	jge    8011c2 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801192:	83 c1 01             	add    $0x1,%ecx
  801195:	0f af 45 10          	imul   0x10(%ebp),%eax
  801199:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  80119b:	0f b6 11             	movzbl (%ecx),%edx
  80119e:	8d 72 d0             	lea    -0x30(%edx),%esi
  8011a1:	89 f3                	mov    %esi,%ebx
  8011a3:	80 fb 09             	cmp    $0x9,%bl
  8011a6:	77 d5                	ja     80117d <strtol+0x7c>
			dig = *s - '0';
  8011a8:	0f be d2             	movsbl %dl,%edx
  8011ab:	83 ea 30             	sub    $0x30,%edx
  8011ae:	eb dd                	jmp    80118d <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  8011b0:	8d 72 bf             	lea    -0x41(%edx),%esi
  8011b3:	89 f3                	mov    %esi,%ebx
  8011b5:	80 fb 19             	cmp    $0x19,%bl
  8011b8:	77 08                	ja     8011c2 <strtol+0xc1>
			dig = *s - 'A' + 10;
  8011ba:	0f be d2             	movsbl %dl,%edx
  8011bd:	83 ea 37             	sub    $0x37,%edx
  8011c0:	eb cb                	jmp    80118d <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  8011c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011c6:	74 05                	je     8011cd <strtol+0xcc>
		*endptr = (char *) s;
  8011c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011cb:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8011cd:	89 c2                	mov    %eax,%edx
  8011cf:	f7 da                	neg    %edx
  8011d1:	85 ff                	test   %edi,%edi
  8011d3:	0f 45 c2             	cmovne %edx,%eax
}
  8011d6:	5b                   	pop    %ebx
  8011d7:	5e                   	pop    %esi
  8011d8:	5f                   	pop    %edi
  8011d9:	5d                   	pop    %ebp
  8011da:	c3                   	ret    

008011db <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
  8011de:	57                   	push   %edi
  8011df:	56                   	push   %esi
  8011e0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8011e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ec:	89 c3                	mov    %eax,%ebx
  8011ee:	89 c7                	mov    %eax,%edi
  8011f0:	89 c6                	mov    %eax,%esi
  8011f2:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8011f4:	5b                   	pop    %ebx
  8011f5:	5e                   	pop    %esi
  8011f6:	5f                   	pop    %edi
  8011f7:	5d                   	pop    %ebp
  8011f8:	c3                   	ret    

008011f9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8011f9:	55                   	push   %ebp
  8011fa:	89 e5                	mov    %esp,%ebp
  8011fc:	57                   	push   %edi
  8011fd:	56                   	push   %esi
  8011fe:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011ff:	ba 00 00 00 00       	mov    $0x0,%edx
  801204:	b8 01 00 00 00       	mov    $0x1,%eax
  801209:	89 d1                	mov    %edx,%ecx
  80120b:	89 d3                	mov    %edx,%ebx
  80120d:	89 d7                	mov    %edx,%edi
  80120f:	89 d6                	mov    %edx,%esi
  801211:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801213:	5b                   	pop    %ebx
  801214:	5e                   	pop    %esi
  801215:	5f                   	pop    %edi
  801216:	5d                   	pop    %ebp
  801217:	c3                   	ret    

00801218 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801218:	55                   	push   %ebp
  801219:	89 e5                	mov    %esp,%ebp
  80121b:	57                   	push   %edi
  80121c:	56                   	push   %esi
  80121d:	53                   	push   %ebx
  80121e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801221:	b9 00 00 00 00       	mov    $0x0,%ecx
  801226:	8b 55 08             	mov    0x8(%ebp),%edx
  801229:	b8 03 00 00 00       	mov    $0x3,%eax
  80122e:	89 cb                	mov    %ecx,%ebx
  801230:	89 cf                	mov    %ecx,%edi
  801232:	89 ce                	mov    %ecx,%esi
  801234:	cd 30                	int    $0x30
	if(check && ret > 0)
  801236:	85 c0                	test   %eax,%eax
  801238:	7f 08                	jg     801242 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80123a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80123d:	5b                   	pop    %ebx
  80123e:	5e                   	pop    %esi
  80123f:	5f                   	pop    %edi
  801240:	5d                   	pop    %ebp
  801241:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801242:	83 ec 0c             	sub    $0xc,%esp
  801245:	50                   	push   %eax
  801246:	6a 03                	push   $0x3
  801248:	68 84 32 80 00       	push   $0x803284
  80124d:	6a 43                	push   $0x43
  80124f:	68 a1 32 80 00       	push   $0x8032a1
  801254:	e8 f7 f3 ff ff       	call   800650 <_panic>

00801259 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801259:	55                   	push   %ebp
  80125a:	89 e5                	mov    %esp,%ebp
  80125c:	57                   	push   %edi
  80125d:	56                   	push   %esi
  80125e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80125f:	ba 00 00 00 00       	mov    $0x0,%edx
  801264:	b8 02 00 00 00       	mov    $0x2,%eax
  801269:	89 d1                	mov    %edx,%ecx
  80126b:	89 d3                	mov    %edx,%ebx
  80126d:	89 d7                	mov    %edx,%edi
  80126f:	89 d6                	mov    %edx,%esi
  801271:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801273:	5b                   	pop    %ebx
  801274:	5e                   	pop    %esi
  801275:	5f                   	pop    %edi
  801276:	5d                   	pop    %ebp
  801277:	c3                   	ret    

00801278 <sys_yield>:

void
sys_yield(void)
{
  801278:	55                   	push   %ebp
  801279:	89 e5                	mov    %esp,%ebp
  80127b:	57                   	push   %edi
  80127c:	56                   	push   %esi
  80127d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80127e:	ba 00 00 00 00       	mov    $0x0,%edx
  801283:	b8 0b 00 00 00       	mov    $0xb,%eax
  801288:	89 d1                	mov    %edx,%ecx
  80128a:	89 d3                	mov    %edx,%ebx
  80128c:	89 d7                	mov    %edx,%edi
  80128e:	89 d6                	mov    %edx,%esi
  801290:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801292:	5b                   	pop    %ebx
  801293:	5e                   	pop    %esi
  801294:	5f                   	pop    %edi
  801295:	5d                   	pop    %ebp
  801296:	c3                   	ret    

00801297 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801297:	55                   	push   %ebp
  801298:	89 e5                	mov    %esp,%ebp
  80129a:	57                   	push   %edi
  80129b:	56                   	push   %esi
  80129c:	53                   	push   %ebx
  80129d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012a0:	be 00 00 00 00       	mov    $0x0,%esi
  8012a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012ab:	b8 04 00 00 00       	mov    $0x4,%eax
  8012b0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012b3:	89 f7                	mov    %esi,%edi
  8012b5:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012b7:	85 c0                	test   %eax,%eax
  8012b9:	7f 08                	jg     8012c3 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8012bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012be:	5b                   	pop    %ebx
  8012bf:	5e                   	pop    %esi
  8012c0:	5f                   	pop    %edi
  8012c1:	5d                   	pop    %ebp
  8012c2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012c3:	83 ec 0c             	sub    $0xc,%esp
  8012c6:	50                   	push   %eax
  8012c7:	6a 04                	push   $0x4
  8012c9:	68 84 32 80 00       	push   $0x803284
  8012ce:	6a 43                	push   $0x43
  8012d0:	68 a1 32 80 00       	push   $0x8032a1
  8012d5:	e8 76 f3 ff ff       	call   800650 <_panic>

008012da <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8012da:	55                   	push   %ebp
  8012db:	89 e5                	mov    %esp,%ebp
  8012dd:	57                   	push   %edi
  8012de:	56                   	push   %esi
  8012df:	53                   	push   %ebx
  8012e0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012e9:	b8 05 00 00 00       	mov    $0x5,%eax
  8012ee:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012f1:	8b 7d 14             	mov    0x14(%ebp),%edi
  8012f4:	8b 75 18             	mov    0x18(%ebp),%esi
  8012f7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012f9:	85 c0                	test   %eax,%eax
  8012fb:	7f 08                	jg     801305 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8012fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801300:	5b                   	pop    %ebx
  801301:	5e                   	pop    %esi
  801302:	5f                   	pop    %edi
  801303:	5d                   	pop    %ebp
  801304:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801305:	83 ec 0c             	sub    $0xc,%esp
  801308:	50                   	push   %eax
  801309:	6a 05                	push   $0x5
  80130b:	68 84 32 80 00       	push   $0x803284
  801310:	6a 43                	push   $0x43
  801312:	68 a1 32 80 00       	push   $0x8032a1
  801317:	e8 34 f3 ff ff       	call   800650 <_panic>

0080131c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	57                   	push   %edi
  801320:	56                   	push   %esi
  801321:	53                   	push   %ebx
  801322:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801325:	bb 00 00 00 00       	mov    $0x0,%ebx
  80132a:	8b 55 08             	mov    0x8(%ebp),%edx
  80132d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801330:	b8 06 00 00 00       	mov    $0x6,%eax
  801335:	89 df                	mov    %ebx,%edi
  801337:	89 de                	mov    %ebx,%esi
  801339:	cd 30                	int    $0x30
	if(check && ret > 0)
  80133b:	85 c0                	test   %eax,%eax
  80133d:	7f 08                	jg     801347 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80133f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801342:	5b                   	pop    %ebx
  801343:	5e                   	pop    %esi
  801344:	5f                   	pop    %edi
  801345:	5d                   	pop    %ebp
  801346:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801347:	83 ec 0c             	sub    $0xc,%esp
  80134a:	50                   	push   %eax
  80134b:	6a 06                	push   $0x6
  80134d:	68 84 32 80 00       	push   $0x803284
  801352:	6a 43                	push   $0x43
  801354:	68 a1 32 80 00       	push   $0x8032a1
  801359:	e8 f2 f2 ff ff       	call   800650 <_panic>

0080135e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
  801361:	57                   	push   %edi
  801362:	56                   	push   %esi
  801363:	53                   	push   %ebx
  801364:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801367:	bb 00 00 00 00       	mov    $0x0,%ebx
  80136c:	8b 55 08             	mov    0x8(%ebp),%edx
  80136f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801372:	b8 08 00 00 00       	mov    $0x8,%eax
  801377:	89 df                	mov    %ebx,%edi
  801379:	89 de                	mov    %ebx,%esi
  80137b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80137d:	85 c0                	test   %eax,%eax
  80137f:	7f 08                	jg     801389 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801381:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801384:	5b                   	pop    %ebx
  801385:	5e                   	pop    %esi
  801386:	5f                   	pop    %edi
  801387:	5d                   	pop    %ebp
  801388:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801389:	83 ec 0c             	sub    $0xc,%esp
  80138c:	50                   	push   %eax
  80138d:	6a 08                	push   $0x8
  80138f:	68 84 32 80 00       	push   $0x803284
  801394:	6a 43                	push   $0x43
  801396:	68 a1 32 80 00       	push   $0x8032a1
  80139b:	e8 b0 f2 ff ff       	call   800650 <_panic>

008013a0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8013a0:	55                   	push   %ebp
  8013a1:	89 e5                	mov    %esp,%ebp
  8013a3:	57                   	push   %edi
  8013a4:	56                   	push   %esi
  8013a5:	53                   	push   %ebx
  8013a6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013a9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8013b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013b4:	b8 09 00 00 00       	mov    $0x9,%eax
  8013b9:	89 df                	mov    %ebx,%edi
  8013bb:	89 de                	mov    %ebx,%esi
  8013bd:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013bf:	85 c0                	test   %eax,%eax
  8013c1:	7f 08                	jg     8013cb <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8013c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013c6:	5b                   	pop    %ebx
  8013c7:	5e                   	pop    %esi
  8013c8:	5f                   	pop    %edi
  8013c9:	5d                   	pop    %ebp
  8013ca:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013cb:	83 ec 0c             	sub    $0xc,%esp
  8013ce:	50                   	push   %eax
  8013cf:	6a 09                	push   $0x9
  8013d1:	68 84 32 80 00       	push   $0x803284
  8013d6:	6a 43                	push   $0x43
  8013d8:	68 a1 32 80 00       	push   $0x8032a1
  8013dd:	e8 6e f2 ff ff       	call   800650 <_panic>

008013e2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8013e2:	55                   	push   %ebp
  8013e3:	89 e5                	mov    %esp,%ebp
  8013e5:	57                   	push   %edi
  8013e6:	56                   	push   %esi
  8013e7:	53                   	push   %ebx
  8013e8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013eb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8013f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013f6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8013fb:	89 df                	mov    %ebx,%edi
  8013fd:	89 de                	mov    %ebx,%esi
  8013ff:	cd 30                	int    $0x30
	if(check && ret > 0)
  801401:	85 c0                	test   %eax,%eax
  801403:	7f 08                	jg     80140d <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801405:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801408:	5b                   	pop    %ebx
  801409:	5e                   	pop    %esi
  80140a:	5f                   	pop    %edi
  80140b:	5d                   	pop    %ebp
  80140c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80140d:	83 ec 0c             	sub    $0xc,%esp
  801410:	50                   	push   %eax
  801411:	6a 0a                	push   $0xa
  801413:	68 84 32 80 00       	push   $0x803284
  801418:	6a 43                	push   $0x43
  80141a:	68 a1 32 80 00       	push   $0x8032a1
  80141f:	e8 2c f2 ff ff       	call   800650 <_panic>

00801424 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
  801427:	57                   	push   %edi
  801428:	56                   	push   %esi
  801429:	53                   	push   %ebx
	asm volatile("int %1\n"
  80142a:	8b 55 08             	mov    0x8(%ebp),%edx
  80142d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801430:	b8 0c 00 00 00       	mov    $0xc,%eax
  801435:	be 00 00 00 00       	mov    $0x0,%esi
  80143a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80143d:	8b 7d 14             	mov    0x14(%ebp),%edi
  801440:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801442:	5b                   	pop    %ebx
  801443:	5e                   	pop    %esi
  801444:	5f                   	pop    %edi
  801445:	5d                   	pop    %ebp
  801446:	c3                   	ret    

00801447 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	57                   	push   %edi
  80144b:	56                   	push   %esi
  80144c:	53                   	push   %ebx
  80144d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801450:	b9 00 00 00 00       	mov    $0x0,%ecx
  801455:	8b 55 08             	mov    0x8(%ebp),%edx
  801458:	b8 0d 00 00 00       	mov    $0xd,%eax
  80145d:	89 cb                	mov    %ecx,%ebx
  80145f:	89 cf                	mov    %ecx,%edi
  801461:	89 ce                	mov    %ecx,%esi
  801463:	cd 30                	int    $0x30
	if(check && ret > 0)
  801465:	85 c0                	test   %eax,%eax
  801467:	7f 08                	jg     801471 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801469:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80146c:	5b                   	pop    %ebx
  80146d:	5e                   	pop    %esi
  80146e:	5f                   	pop    %edi
  80146f:	5d                   	pop    %ebp
  801470:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801471:	83 ec 0c             	sub    $0xc,%esp
  801474:	50                   	push   %eax
  801475:	6a 0d                	push   $0xd
  801477:	68 84 32 80 00       	push   $0x803284
  80147c:	6a 43                	push   $0x43
  80147e:	68 a1 32 80 00       	push   $0x8032a1
  801483:	e8 c8 f1 ff ff       	call   800650 <_panic>

00801488 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801488:	55                   	push   %ebp
  801489:	89 e5                	mov    %esp,%ebp
  80148b:	57                   	push   %edi
  80148c:	56                   	push   %esi
  80148d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80148e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801493:	8b 55 08             	mov    0x8(%ebp),%edx
  801496:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801499:	b8 0e 00 00 00       	mov    $0xe,%eax
  80149e:	89 df                	mov    %ebx,%edi
  8014a0:	89 de                	mov    %ebx,%esi
  8014a2:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8014a4:	5b                   	pop    %ebx
  8014a5:	5e                   	pop    %esi
  8014a6:	5f                   	pop    %edi
  8014a7:	5d                   	pop    %ebp
  8014a8:	c3                   	ret    

008014a9 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8014a9:	55                   	push   %ebp
  8014aa:	89 e5                	mov    %esp,%ebp
  8014ac:	57                   	push   %edi
  8014ad:	56                   	push   %esi
  8014ae:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014af:	b9 00 00 00 00       	mov    $0x0,%ecx
  8014b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8014b7:	b8 0f 00 00 00       	mov    $0xf,%eax
  8014bc:	89 cb                	mov    %ecx,%ebx
  8014be:	89 cf                	mov    %ecx,%edi
  8014c0:	89 ce                	mov    %ecx,%esi
  8014c2:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8014c4:	5b                   	pop    %ebx
  8014c5:	5e                   	pop    %esi
  8014c6:	5f                   	pop    %edi
  8014c7:	5d                   	pop    %ebp
  8014c8:	c3                   	ret    

008014c9 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
  8014cc:	57                   	push   %edi
  8014cd:	56                   	push   %esi
  8014ce:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8014d4:	b8 10 00 00 00       	mov    $0x10,%eax
  8014d9:	89 d1                	mov    %edx,%ecx
  8014db:	89 d3                	mov    %edx,%ebx
  8014dd:	89 d7                	mov    %edx,%edi
  8014df:	89 d6                	mov    %edx,%esi
  8014e1:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8014e3:	5b                   	pop    %ebx
  8014e4:	5e                   	pop    %esi
  8014e5:	5f                   	pop    %edi
  8014e6:	5d                   	pop    %ebp
  8014e7:	c3                   	ret    

008014e8 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
  8014eb:	57                   	push   %edi
  8014ec:	56                   	push   %esi
  8014ed:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014ee:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014f9:	b8 11 00 00 00       	mov    $0x11,%eax
  8014fe:	89 df                	mov    %ebx,%edi
  801500:	89 de                	mov    %ebx,%esi
  801502:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801504:	5b                   	pop    %ebx
  801505:	5e                   	pop    %esi
  801506:	5f                   	pop    %edi
  801507:	5d                   	pop    %ebp
  801508:	c3                   	ret    

00801509 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801509:	55                   	push   %ebp
  80150a:	89 e5                	mov    %esp,%ebp
  80150c:	57                   	push   %edi
  80150d:	56                   	push   %esi
  80150e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80150f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801514:	8b 55 08             	mov    0x8(%ebp),%edx
  801517:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80151a:	b8 12 00 00 00       	mov    $0x12,%eax
  80151f:	89 df                	mov    %ebx,%edi
  801521:	89 de                	mov    %ebx,%esi
  801523:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801525:	5b                   	pop    %ebx
  801526:	5e                   	pop    %esi
  801527:	5f                   	pop    %edi
  801528:	5d                   	pop    %ebp
  801529:	c3                   	ret    

0080152a <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
  80152d:	57                   	push   %edi
  80152e:	56                   	push   %esi
  80152f:	53                   	push   %ebx
  801530:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801533:	bb 00 00 00 00       	mov    $0x0,%ebx
  801538:	8b 55 08             	mov    0x8(%ebp),%edx
  80153b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80153e:	b8 13 00 00 00       	mov    $0x13,%eax
  801543:	89 df                	mov    %ebx,%edi
  801545:	89 de                	mov    %ebx,%esi
  801547:	cd 30                	int    $0x30
	if(check && ret > 0)
  801549:	85 c0                	test   %eax,%eax
  80154b:	7f 08                	jg     801555 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80154d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801550:	5b                   	pop    %ebx
  801551:	5e                   	pop    %esi
  801552:	5f                   	pop    %edi
  801553:	5d                   	pop    %ebp
  801554:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801555:	83 ec 0c             	sub    $0xc,%esp
  801558:	50                   	push   %eax
  801559:	6a 13                	push   $0x13
  80155b:	68 84 32 80 00       	push   $0x803284
  801560:	6a 43                	push   $0x43
  801562:	68 a1 32 80 00       	push   $0x8032a1
  801567:	e8 e4 f0 ff ff       	call   800650 <_panic>

0080156c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80156c:	55                   	push   %ebp
  80156d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80156f:	8b 45 08             	mov    0x8(%ebp),%eax
  801572:	05 00 00 00 30       	add    $0x30000000,%eax
  801577:	c1 e8 0c             	shr    $0xc,%eax
}
  80157a:	5d                   	pop    %ebp
  80157b:	c3                   	ret    

0080157c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80157c:	55                   	push   %ebp
  80157d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80157f:	8b 45 08             	mov    0x8(%ebp),%eax
  801582:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801587:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80158c:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801591:	5d                   	pop    %ebp
  801592:	c3                   	ret    

00801593 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801593:	55                   	push   %ebp
  801594:	89 e5                	mov    %esp,%ebp
  801596:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80159b:	89 c2                	mov    %eax,%edx
  80159d:	c1 ea 16             	shr    $0x16,%edx
  8015a0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015a7:	f6 c2 01             	test   $0x1,%dl
  8015aa:	74 2d                	je     8015d9 <fd_alloc+0x46>
  8015ac:	89 c2                	mov    %eax,%edx
  8015ae:	c1 ea 0c             	shr    $0xc,%edx
  8015b1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015b8:	f6 c2 01             	test   $0x1,%dl
  8015bb:	74 1c                	je     8015d9 <fd_alloc+0x46>
  8015bd:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8015c2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8015c7:	75 d2                	jne    80159b <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8015c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8015d2:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8015d7:	eb 0a                	jmp    8015e3 <fd_alloc+0x50>
			*fd_store = fd;
  8015d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015dc:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015e3:	5d                   	pop    %ebp
  8015e4:	c3                   	ret    

008015e5 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8015e5:	55                   	push   %ebp
  8015e6:	89 e5                	mov    %esp,%ebp
  8015e8:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8015eb:	83 f8 1f             	cmp    $0x1f,%eax
  8015ee:	77 30                	ja     801620 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8015f0:	c1 e0 0c             	shl    $0xc,%eax
  8015f3:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8015f8:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8015fe:	f6 c2 01             	test   $0x1,%dl
  801601:	74 24                	je     801627 <fd_lookup+0x42>
  801603:	89 c2                	mov    %eax,%edx
  801605:	c1 ea 0c             	shr    $0xc,%edx
  801608:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80160f:	f6 c2 01             	test   $0x1,%dl
  801612:	74 1a                	je     80162e <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801614:	8b 55 0c             	mov    0xc(%ebp),%edx
  801617:	89 02                	mov    %eax,(%edx)
	return 0;
  801619:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80161e:	5d                   	pop    %ebp
  80161f:	c3                   	ret    
		return -E_INVAL;
  801620:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801625:	eb f7                	jmp    80161e <fd_lookup+0x39>
		return -E_INVAL;
  801627:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80162c:	eb f0                	jmp    80161e <fd_lookup+0x39>
  80162e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801633:	eb e9                	jmp    80161e <fd_lookup+0x39>

00801635 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
  801638:	83 ec 08             	sub    $0x8,%esp
  80163b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80163e:	ba 00 00 00 00       	mov    $0x0,%edx
  801643:	b8 24 40 80 00       	mov    $0x804024,%eax
		if (devtab[i]->dev_id == dev_id) {
  801648:	39 08                	cmp    %ecx,(%eax)
  80164a:	74 38                	je     801684 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80164c:	83 c2 01             	add    $0x1,%edx
  80164f:	8b 04 95 2c 33 80 00 	mov    0x80332c(,%edx,4),%eax
  801656:	85 c0                	test   %eax,%eax
  801658:	75 ee                	jne    801648 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80165a:	a1 1c 50 80 00       	mov    0x80501c,%eax
  80165f:	8b 40 48             	mov    0x48(%eax),%eax
  801662:	83 ec 04             	sub    $0x4,%esp
  801665:	51                   	push   %ecx
  801666:	50                   	push   %eax
  801667:	68 b0 32 80 00       	push   $0x8032b0
  80166c:	e8 d5 f0 ff ff       	call   800746 <cprintf>
	*dev = 0;
  801671:	8b 45 0c             	mov    0xc(%ebp),%eax
  801674:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80167a:	83 c4 10             	add    $0x10,%esp
  80167d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801682:	c9                   	leave  
  801683:	c3                   	ret    
			*dev = devtab[i];
  801684:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801687:	89 01                	mov    %eax,(%ecx)
			return 0;
  801689:	b8 00 00 00 00       	mov    $0x0,%eax
  80168e:	eb f2                	jmp    801682 <dev_lookup+0x4d>

00801690 <fd_close>:
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	57                   	push   %edi
  801694:	56                   	push   %esi
  801695:	53                   	push   %ebx
  801696:	83 ec 24             	sub    $0x24,%esp
  801699:	8b 75 08             	mov    0x8(%ebp),%esi
  80169c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80169f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016a2:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016a3:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8016a9:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016ac:	50                   	push   %eax
  8016ad:	e8 33 ff ff ff       	call   8015e5 <fd_lookup>
  8016b2:	89 c3                	mov    %eax,%ebx
  8016b4:	83 c4 10             	add    $0x10,%esp
  8016b7:	85 c0                	test   %eax,%eax
  8016b9:	78 05                	js     8016c0 <fd_close+0x30>
	    || fd != fd2)
  8016bb:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8016be:	74 16                	je     8016d6 <fd_close+0x46>
		return (must_exist ? r : 0);
  8016c0:	89 f8                	mov    %edi,%eax
  8016c2:	84 c0                	test   %al,%al
  8016c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c9:	0f 44 d8             	cmove  %eax,%ebx
}
  8016cc:	89 d8                	mov    %ebx,%eax
  8016ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016d1:	5b                   	pop    %ebx
  8016d2:	5e                   	pop    %esi
  8016d3:	5f                   	pop    %edi
  8016d4:	5d                   	pop    %ebp
  8016d5:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016d6:	83 ec 08             	sub    $0x8,%esp
  8016d9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8016dc:	50                   	push   %eax
  8016dd:	ff 36                	pushl  (%esi)
  8016df:	e8 51 ff ff ff       	call   801635 <dev_lookup>
  8016e4:	89 c3                	mov    %eax,%ebx
  8016e6:	83 c4 10             	add    $0x10,%esp
  8016e9:	85 c0                	test   %eax,%eax
  8016eb:	78 1a                	js     801707 <fd_close+0x77>
		if (dev->dev_close)
  8016ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016f0:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8016f3:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8016f8:	85 c0                	test   %eax,%eax
  8016fa:	74 0b                	je     801707 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8016fc:	83 ec 0c             	sub    $0xc,%esp
  8016ff:	56                   	push   %esi
  801700:	ff d0                	call   *%eax
  801702:	89 c3                	mov    %eax,%ebx
  801704:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801707:	83 ec 08             	sub    $0x8,%esp
  80170a:	56                   	push   %esi
  80170b:	6a 00                	push   $0x0
  80170d:	e8 0a fc ff ff       	call   80131c <sys_page_unmap>
	return r;
  801712:	83 c4 10             	add    $0x10,%esp
  801715:	eb b5                	jmp    8016cc <fd_close+0x3c>

00801717 <close>:

int
close(int fdnum)
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
  80171a:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80171d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801720:	50                   	push   %eax
  801721:	ff 75 08             	pushl  0x8(%ebp)
  801724:	e8 bc fe ff ff       	call   8015e5 <fd_lookup>
  801729:	83 c4 10             	add    $0x10,%esp
  80172c:	85 c0                	test   %eax,%eax
  80172e:	79 02                	jns    801732 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801730:	c9                   	leave  
  801731:	c3                   	ret    
		return fd_close(fd, 1);
  801732:	83 ec 08             	sub    $0x8,%esp
  801735:	6a 01                	push   $0x1
  801737:	ff 75 f4             	pushl  -0xc(%ebp)
  80173a:	e8 51 ff ff ff       	call   801690 <fd_close>
  80173f:	83 c4 10             	add    $0x10,%esp
  801742:	eb ec                	jmp    801730 <close+0x19>

00801744 <close_all>:

void
close_all(void)
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
  801747:	53                   	push   %ebx
  801748:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80174b:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801750:	83 ec 0c             	sub    $0xc,%esp
  801753:	53                   	push   %ebx
  801754:	e8 be ff ff ff       	call   801717 <close>
	for (i = 0; i < MAXFD; i++)
  801759:	83 c3 01             	add    $0x1,%ebx
  80175c:	83 c4 10             	add    $0x10,%esp
  80175f:	83 fb 20             	cmp    $0x20,%ebx
  801762:	75 ec                	jne    801750 <close_all+0xc>
}
  801764:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801767:	c9                   	leave  
  801768:	c3                   	ret    

00801769 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
  80176c:	57                   	push   %edi
  80176d:	56                   	push   %esi
  80176e:	53                   	push   %ebx
  80176f:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801772:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801775:	50                   	push   %eax
  801776:	ff 75 08             	pushl  0x8(%ebp)
  801779:	e8 67 fe ff ff       	call   8015e5 <fd_lookup>
  80177e:	89 c3                	mov    %eax,%ebx
  801780:	83 c4 10             	add    $0x10,%esp
  801783:	85 c0                	test   %eax,%eax
  801785:	0f 88 81 00 00 00    	js     80180c <dup+0xa3>
		return r;
	close(newfdnum);
  80178b:	83 ec 0c             	sub    $0xc,%esp
  80178e:	ff 75 0c             	pushl  0xc(%ebp)
  801791:	e8 81 ff ff ff       	call   801717 <close>

	newfd = INDEX2FD(newfdnum);
  801796:	8b 75 0c             	mov    0xc(%ebp),%esi
  801799:	c1 e6 0c             	shl    $0xc,%esi
  80179c:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8017a2:	83 c4 04             	add    $0x4,%esp
  8017a5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017a8:	e8 cf fd ff ff       	call   80157c <fd2data>
  8017ad:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8017af:	89 34 24             	mov    %esi,(%esp)
  8017b2:	e8 c5 fd ff ff       	call   80157c <fd2data>
  8017b7:	83 c4 10             	add    $0x10,%esp
  8017ba:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8017bc:	89 d8                	mov    %ebx,%eax
  8017be:	c1 e8 16             	shr    $0x16,%eax
  8017c1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017c8:	a8 01                	test   $0x1,%al
  8017ca:	74 11                	je     8017dd <dup+0x74>
  8017cc:	89 d8                	mov    %ebx,%eax
  8017ce:	c1 e8 0c             	shr    $0xc,%eax
  8017d1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8017d8:	f6 c2 01             	test   $0x1,%dl
  8017db:	75 39                	jne    801816 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017dd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8017e0:	89 d0                	mov    %edx,%eax
  8017e2:	c1 e8 0c             	shr    $0xc,%eax
  8017e5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017ec:	83 ec 0c             	sub    $0xc,%esp
  8017ef:	25 07 0e 00 00       	and    $0xe07,%eax
  8017f4:	50                   	push   %eax
  8017f5:	56                   	push   %esi
  8017f6:	6a 00                	push   $0x0
  8017f8:	52                   	push   %edx
  8017f9:	6a 00                	push   $0x0
  8017fb:	e8 da fa ff ff       	call   8012da <sys_page_map>
  801800:	89 c3                	mov    %eax,%ebx
  801802:	83 c4 20             	add    $0x20,%esp
  801805:	85 c0                	test   %eax,%eax
  801807:	78 31                	js     80183a <dup+0xd1>
		goto err;

	return newfdnum;
  801809:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80180c:	89 d8                	mov    %ebx,%eax
  80180e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801811:	5b                   	pop    %ebx
  801812:	5e                   	pop    %esi
  801813:	5f                   	pop    %edi
  801814:	5d                   	pop    %ebp
  801815:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801816:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80181d:	83 ec 0c             	sub    $0xc,%esp
  801820:	25 07 0e 00 00       	and    $0xe07,%eax
  801825:	50                   	push   %eax
  801826:	57                   	push   %edi
  801827:	6a 00                	push   $0x0
  801829:	53                   	push   %ebx
  80182a:	6a 00                	push   $0x0
  80182c:	e8 a9 fa ff ff       	call   8012da <sys_page_map>
  801831:	89 c3                	mov    %eax,%ebx
  801833:	83 c4 20             	add    $0x20,%esp
  801836:	85 c0                	test   %eax,%eax
  801838:	79 a3                	jns    8017dd <dup+0x74>
	sys_page_unmap(0, newfd);
  80183a:	83 ec 08             	sub    $0x8,%esp
  80183d:	56                   	push   %esi
  80183e:	6a 00                	push   $0x0
  801840:	e8 d7 fa ff ff       	call   80131c <sys_page_unmap>
	sys_page_unmap(0, nva);
  801845:	83 c4 08             	add    $0x8,%esp
  801848:	57                   	push   %edi
  801849:	6a 00                	push   $0x0
  80184b:	e8 cc fa ff ff       	call   80131c <sys_page_unmap>
	return r;
  801850:	83 c4 10             	add    $0x10,%esp
  801853:	eb b7                	jmp    80180c <dup+0xa3>

00801855 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
  801858:	53                   	push   %ebx
  801859:	83 ec 1c             	sub    $0x1c,%esp
  80185c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80185f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801862:	50                   	push   %eax
  801863:	53                   	push   %ebx
  801864:	e8 7c fd ff ff       	call   8015e5 <fd_lookup>
  801869:	83 c4 10             	add    $0x10,%esp
  80186c:	85 c0                	test   %eax,%eax
  80186e:	78 3f                	js     8018af <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801870:	83 ec 08             	sub    $0x8,%esp
  801873:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801876:	50                   	push   %eax
  801877:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80187a:	ff 30                	pushl  (%eax)
  80187c:	e8 b4 fd ff ff       	call   801635 <dev_lookup>
  801881:	83 c4 10             	add    $0x10,%esp
  801884:	85 c0                	test   %eax,%eax
  801886:	78 27                	js     8018af <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801888:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80188b:	8b 42 08             	mov    0x8(%edx),%eax
  80188e:	83 e0 03             	and    $0x3,%eax
  801891:	83 f8 01             	cmp    $0x1,%eax
  801894:	74 1e                	je     8018b4 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801896:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801899:	8b 40 08             	mov    0x8(%eax),%eax
  80189c:	85 c0                	test   %eax,%eax
  80189e:	74 35                	je     8018d5 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8018a0:	83 ec 04             	sub    $0x4,%esp
  8018a3:	ff 75 10             	pushl  0x10(%ebp)
  8018a6:	ff 75 0c             	pushl  0xc(%ebp)
  8018a9:	52                   	push   %edx
  8018aa:	ff d0                	call   *%eax
  8018ac:	83 c4 10             	add    $0x10,%esp
}
  8018af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8018b4:	a1 1c 50 80 00       	mov    0x80501c,%eax
  8018b9:	8b 40 48             	mov    0x48(%eax),%eax
  8018bc:	83 ec 04             	sub    $0x4,%esp
  8018bf:	53                   	push   %ebx
  8018c0:	50                   	push   %eax
  8018c1:	68 f1 32 80 00       	push   $0x8032f1
  8018c6:	e8 7b ee ff ff       	call   800746 <cprintf>
		return -E_INVAL;
  8018cb:	83 c4 10             	add    $0x10,%esp
  8018ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018d3:	eb da                	jmp    8018af <read+0x5a>
		return -E_NOT_SUPP;
  8018d5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018da:	eb d3                	jmp    8018af <read+0x5a>

008018dc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
  8018df:	57                   	push   %edi
  8018e0:	56                   	push   %esi
  8018e1:	53                   	push   %ebx
  8018e2:	83 ec 0c             	sub    $0xc,%esp
  8018e5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8018e8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018eb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018f0:	39 f3                	cmp    %esi,%ebx
  8018f2:	73 23                	jae    801917 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8018f4:	83 ec 04             	sub    $0x4,%esp
  8018f7:	89 f0                	mov    %esi,%eax
  8018f9:	29 d8                	sub    %ebx,%eax
  8018fb:	50                   	push   %eax
  8018fc:	89 d8                	mov    %ebx,%eax
  8018fe:	03 45 0c             	add    0xc(%ebp),%eax
  801901:	50                   	push   %eax
  801902:	57                   	push   %edi
  801903:	e8 4d ff ff ff       	call   801855 <read>
		if (m < 0)
  801908:	83 c4 10             	add    $0x10,%esp
  80190b:	85 c0                	test   %eax,%eax
  80190d:	78 06                	js     801915 <readn+0x39>
			return m;
		if (m == 0)
  80190f:	74 06                	je     801917 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801911:	01 c3                	add    %eax,%ebx
  801913:	eb db                	jmp    8018f0 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801915:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801917:	89 d8                	mov    %ebx,%eax
  801919:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80191c:	5b                   	pop    %ebx
  80191d:	5e                   	pop    %esi
  80191e:	5f                   	pop    %edi
  80191f:	5d                   	pop    %ebp
  801920:	c3                   	ret    

00801921 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
  801924:	53                   	push   %ebx
  801925:	83 ec 1c             	sub    $0x1c,%esp
  801928:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80192b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80192e:	50                   	push   %eax
  80192f:	53                   	push   %ebx
  801930:	e8 b0 fc ff ff       	call   8015e5 <fd_lookup>
  801935:	83 c4 10             	add    $0x10,%esp
  801938:	85 c0                	test   %eax,%eax
  80193a:	78 3a                	js     801976 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80193c:	83 ec 08             	sub    $0x8,%esp
  80193f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801942:	50                   	push   %eax
  801943:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801946:	ff 30                	pushl  (%eax)
  801948:	e8 e8 fc ff ff       	call   801635 <dev_lookup>
  80194d:	83 c4 10             	add    $0x10,%esp
  801950:	85 c0                	test   %eax,%eax
  801952:	78 22                	js     801976 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801954:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801957:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80195b:	74 1e                	je     80197b <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80195d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801960:	8b 52 0c             	mov    0xc(%edx),%edx
  801963:	85 d2                	test   %edx,%edx
  801965:	74 35                	je     80199c <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801967:	83 ec 04             	sub    $0x4,%esp
  80196a:	ff 75 10             	pushl  0x10(%ebp)
  80196d:	ff 75 0c             	pushl  0xc(%ebp)
  801970:	50                   	push   %eax
  801971:	ff d2                	call   *%edx
  801973:	83 c4 10             	add    $0x10,%esp
}
  801976:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801979:	c9                   	leave  
  80197a:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80197b:	a1 1c 50 80 00       	mov    0x80501c,%eax
  801980:	8b 40 48             	mov    0x48(%eax),%eax
  801983:	83 ec 04             	sub    $0x4,%esp
  801986:	53                   	push   %ebx
  801987:	50                   	push   %eax
  801988:	68 0d 33 80 00       	push   $0x80330d
  80198d:	e8 b4 ed ff ff       	call   800746 <cprintf>
		return -E_INVAL;
  801992:	83 c4 10             	add    $0x10,%esp
  801995:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80199a:	eb da                	jmp    801976 <write+0x55>
		return -E_NOT_SUPP;
  80199c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019a1:	eb d3                	jmp    801976 <write+0x55>

008019a3 <seek>:

int
seek(int fdnum, off_t offset)
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
  8019a6:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019ac:	50                   	push   %eax
  8019ad:	ff 75 08             	pushl  0x8(%ebp)
  8019b0:	e8 30 fc ff ff       	call   8015e5 <fd_lookup>
  8019b5:	83 c4 10             	add    $0x10,%esp
  8019b8:	85 c0                	test   %eax,%eax
  8019ba:	78 0e                	js     8019ca <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8019bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8019c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
  8019cf:	53                   	push   %ebx
  8019d0:	83 ec 1c             	sub    $0x1c,%esp
  8019d3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019d9:	50                   	push   %eax
  8019da:	53                   	push   %ebx
  8019db:	e8 05 fc ff ff       	call   8015e5 <fd_lookup>
  8019e0:	83 c4 10             	add    $0x10,%esp
  8019e3:	85 c0                	test   %eax,%eax
  8019e5:	78 37                	js     801a1e <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019e7:	83 ec 08             	sub    $0x8,%esp
  8019ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019ed:	50                   	push   %eax
  8019ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f1:	ff 30                	pushl  (%eax)
  8019f3:	e8 3d fc ff ff       	call   801635 <dev_lookup>
  8019f8:	83 c4 10             	add    $0x10,%esp
  8019fb:	85 c0                	test   %eax,%eax
  8019fd:	78 1f                	js     801a1e <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a02:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a06:	74 1b                	je     801a23 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801a08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a0b:	8b 52 18             	mov    0x18(%edx),%edx
  801a0e:	85 d2                	test   %edx,%edx
  801a10:	74 32                	je     801a44 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a12:	83 ec 08             	sub    $0x8,%esp
  801a15:	ff 75 0c             	pushl  0xc(%ebp)
  801a18:	50                   	push   %eax
  801a19:	ff d2                	call   *%edx
  801a1b:	83 c4 10             	add    $0x10,%esp
}
  801a1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a21:	c9                   	leave  
  801a22:	c3                   	ret    
			thisenv->env_id, fdnum);
  801a23:	a1 1c 50 80 00       	mov    0x80501c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a28:	8b 40 48             	mov    0x48(%eax),%eax
  801a2b:	83 ec 04             	sub    $0x4,%esp
  801a2e:	53                   	push   %ebx
  801a2f:	50                   	push   %eax
  801a30:	68 d0 32 80 00       	push   $0x8032d0
  801a35:	e8 0c ed ff ff       	call   800746 <cprintf>
		return -E_INVAL;
  801a3a:	83 c4 10             	add    $0x10,%esp
  801a3d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a42:	eb da                	jmp    801a1e <ftruncate+0x52>
		return -E_NOT_SUPP;
  801a44:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a49:	eb d3                	jmp    801a1e <ftruncate+0x52>

00801a4b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
  801a4e:	53                   	push   %ebx
  801a4f:	83 ec 1c             	sub    $0x1c,%esp
  801a52:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a55:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a58:	50                   	push   %eax
  801a59:	ff 75 08             	pushl  0x8(%ebp)
  801a5c:	e8 84 fb ff ff       	call   8015e5 <fd_lookup>
  801a61:	83 c4 10             	add    $0x10,%esp
  801a64:	85 c0                	test   %eax,%eax
  801a66:	78 4b                	js     801ab3 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a68:	83 ec 08             	sub    $0x8,%esp
  801a6b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a6e:	50                   	push   %eax
  801a6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a72:	ff 30                	pushl  (%eax)
  801a74:	e8 bc fb ff ff       	call   801635 <dev_lookup>
  801a79:	83 c4 10             	add    $0x10,%esp
  801a7c:	85 c0                	test   %eax,%eax
  801a7e:	78 33                	js     801ab3 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a83:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a87:	74 2f                	je     801ab8 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a89:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a8c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a93:	00 00 00 
	stat->st_isdir = 0;
  801a96:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a9d:	00 00 00 
	stat->st_dev = dev;
  801aa0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801aa6:	83 ec 08             	sub    $0x8,%esp
  801aa9:	53                   	push   %ebx
  801aaa:	ff 75 f0             	pushl  -0x10(%ebp)
  801aad:	ff 50 14             	call   *0x14(%eax)
  801ab0:	83 c4 10             	add    $0x10,%esp
}
  801ab3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ab6:	c9                   	leave  
  801ab7:	c3                   	ret    
		return -E_NOT_SUPP;
  801ab8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801abd:	eb f4                	jmp    801ab3 <fstat+0x68>

00801abf <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
  801ac2:	56                   	push   %esi
  801ac3:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801ac4:	83 ec 08             	sub    $0x8,%esp
  801ac7:	6a 00                	push   $0x0
  801ac9:	ff 75 08             	pushl  0x8(%ebp)
  801acc:	e8 22 02 00 00       	call   801cf3 <open>
  801ad1:	89 c3                	mov    %eax,%ebx
  801ad3:	83 c4 10             	add    $0x10,%esp
  801ad6:	85 c0                	test   %eax,%eax
  801ad8:	78 1b                	js     801af5 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801ada:	83 ec 08             	sub    $0x8,%esp
  801add:	ff 75 0c             	pushl  0xc(%ebp)
  801ae0:	50                   	push   %eax
  801ae1:	e8 65 ff ff ff       	call   801a4b <fstat>
  801ae6:	89 c6                	mov    %eax,%esi
	close(fd);
  801ae8:	89 1c 24             	mov    %ebx,(%esp)
  801aeb:	e8 27 fc ff ff       	call   801717 <close>
	return r;
  801af0:	83 c4 10             	add    $0x10,%esp
  801af3:	89 f3                	mov    %esi,%ebx
}
  801af5:	89 d8                	mov    %ebx,%eax
  801af7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801afa:	5b                   	pop    %ebx
  801afb:	5e                   	pop    %esi
  801afc:	5d                   	pop    %ebp
  801afd:	c3                   	ret    

00801afe <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
  801b01:	56                   	push   %esi
  801b02:	53                   	push   %ebx
  801b03:	89 c6                	mov    %eax,%esi
  801b05:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b07:	83 3d 10 50 80 00 00 	cmpl   $0x0,0x805010
  801b0e:	74 27                	je     801b37 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b10:	6a 07                	push   $0x7
  801b12:	68 00 60 80 00       	push   $0x806000
  801b17:	56                   	push   %esi
  801b18:	ff 35 10 50 80 00    	pushl  0x805010
  801b1e:	e8 a1 0e 00 00       	call   8029c4 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b23:	83 c4 0c             	add    $0xc,%esp
  801b26:	6a 00                	push   $0x0
  801b28:	53                   	push   %ebx
  801b29:	6a 00                	push   $0x0
  801b2b:	e8 2b 0e 00 00       	call   80295b <ipc_recv>
}
  801b30:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b33:	5b                   	pop    %ebx
  801b34:	5e                   	pop    %esi
  801b35:	5d                   	pop    %ebp
  801b36:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b37:	83 ec 0c             	sub    $0xc,%esp
  801b3a:	6a 01                	push   $0x1
  801b3c:	e8 db 0e 00 00       	call   802a1c <ipc_find_env>
  801b41:	a3 10 50 80 00       	mov    %eax,0x805010
  801b46:	83 c4 10             	add    $0x10,%esp
  801b49:	eb c5                	jmp    801b10 <fsipc+0x12>

00801b4b <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
  801b4e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b51:	8b 45 08             	mov    0x8(%ebp),%eax
  801b54:	8b 40 0c             	mov    0xc(%eax),%eax
  801b57:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5f:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b64:	ba 00 00 00 00       	mov    $0x0,%edx
  801b69:	b8 02 00 00 00       	mov    $0x2,%eax
  801b6e:	e8 8b ff ff ff       	call   801afe <fsipc>
}
  801b73:	c9                   	leave  
  801b74:	c3                   	ret    

00801b75 <devfile_flush>:
{
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
  801b78:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7e:	8b 40 0c             	mov    0xc(%eax),%eax
  801b81:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801b86:	ba 00 00 00 00       	mov    $0x0,%edx
  801b8b:	b8 06 00 00 00       	mov    $0x6,%eax
  801b90:	e8 69 ff ff ff       	call   801afe <fsipc>
}
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <devfile_stat>:
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
  801b9a:	53                   	push   %ebx
  801b9b:	83 ec 04             	sub    $0x4,%esp
  801b9e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba4:	8b 40 0c             	mov    0xc(%eax),%eax
  801ba7:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801bac:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb1:	b8 05 00 00 00       	mov    $0x5,%eax
  801bb6:	e8 43 ff ff ff       	call   801afe <fsipc>
  801bbb:	85 c0                	test   %eax,%eax
  801bbd:	78 2c                	js     801beb <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801bbf:	83 ec 08             	sub    $0x8,%esp
  801bc2:	68 00 60 80 00       	push   $0x806000
  801bc7:	53                   	push   %ebx
  801bc8:	e8 d8 f2 ff ff       	call   800ea5 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801bcd:	a1 80 60 80 00       	mov    0x806080,%eax
  801bd2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801bd8:	a1 84 60 80 00       	mov    0x806084,%eax
  801bdd:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801be3:	83 c4 10             	add    $0x10,%esp
  801be6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801beb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <devfile_write>:
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
  801bf3:	53                   	push   %ebx
  801bf4:	83 ec 08             	sub    $0x8,%esp
  801bf7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfd:	8b 40 0c             	mov    0xc(%eax),%eax
  801c00:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801c05:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801c0b:	53                   	push   %ebx
  801c0c:	ff 75 0c             	pushl  0xc(%ebp)
  801c0f:	68 08 60 80 00       	push   $0x806008
  801c14:	e8 7c f4 ff ff       	call   801095 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801c19:	ba 00 00 00 00       	mov    $0x0,%edx
  801c1e:	b8 04 00 00 00       	mov    $0x4,%eax
  801c23:	e8 d6 fe ff ff       	call   801afe <fsipc>
  801c28:	83 c4 10             	add    $0x10,%esp
  801c2b:	85 c0                	test   %eax,%eax
  801c2d:	78 0b                	js     801c3a <devfile_write+0x4a>
	assert(r <= n);
  801c2f:	39 d8                	cmp    %ebx,%eax
  801c31:	77 0c                	ja     801c3f <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801c33:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c38:	7f 1e                	jg     801c58 <devfile_write+0x68>
}
  801c3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c3d:	c9                   	leave  
  801c3e:	c3                   	ret    
	assert(r <= n);
  801c3f:	68 40 33 80 00       	push   $0x803340
  801c44:	68 47 33 80 00       	push   $0x803347
  801c49:	68 98 00 00 00       	push   $0x98
  801c4e:	68 5c 33 80 00       	push   $0x80335c
  801c53:	e8 f8 e9 ff ff       	call   800650 <_panic>
	assert(r <= PGSIZE);
  801c58:	68 67 33 80 00       	push   $0x803367
  801c5d:	68 47 33 80 00       	push   $0x803347
  801c62:	68 99 00 00 00       	push   $0x99
  801c67:	68 5c 33 80 00       	push   $0x80335c
  801c6c:	e8 df e9 ff ff       	call   800650 <_panic>

00801c71 <devfile_read>:
{
  801c71:	55                   	push   %ebp
  801c72:	89 e5                	mov    %esp,%ebp
  801c74:	56                   	push   %esi
  801c75:	53                   	push   %ebx
  801c76:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c79:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7c:	8b 40 0c             	mov    0xc(%eax),%eax
  801c7f:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801c84:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c8a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c8f:	b8 03 00 00 00       	mov    $0x3,%eax
  801c94:	e8 65 fe ff ff       	call   801afe <fsipc>
  801c99:	89 c3                	mov    %eax,%ebx
  801c9b:	85 c0                	test   %eax,%eax
  801c9d:	78 1f                	js     801cbe <devfile_read+0x4d>
	assert(r <= n);
  801c9f:	39 f0                	cmp    %esi,%eax
  801ca1:	77 24                	ja     801cc7 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801ca3:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ca8:	7f 33                	jg     801cdd <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801caa:	83 ec 04             	sub    $0x4,%esp
  801cad:	50                   	push   %eax
  801cae:	68 00 60 80 00       	push   $0x806000
  801cb3:	ff 75 0c             	pushl  0xc(%ebp)
  801cb6:	e8 78 f3 ff ff       	call   801033 <memmove>
	return r;
  801cbb:	83 c4 10             	add    $0x10,%esp
}
  801cbe:	89 d8                	mov    %ebx,%eax
  801cc0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cc3:	5b                   	pop    %ebx
  801cc4:	5e                   	pop    %esi
  801cc5:	5d                   	pop    %ebp
  801cc6:	c3                   	ret    
	assert(r <= n);
  801cc7:	68 40 33 80 00       	push   $0x803340
  801ccc:	68 47 33 80 00       	push   $0x803347
  801cd1:	6a 7c                	push   $0x7c
  801cd3:	68 5c 33 80 00       	push   $0x80335c
  801cd8:	e8 73 e9 ff ff       	call   800650 <_panic>
	assert(r <= PGSIZE);
  801cdd:	68 67 33 80 00       	push   $0x803367
  801ce2:	68 47 33 80 00       	push   $0x803347
  801ce7:	6a 7d                	push   $0x7d
  801ce9:	68 5c 33 80 00       	push   $0x80335c
  801cee:	e8 5d e9 ff ff       	call   800650 <_panic>

00801cf3 <open>:
{
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
  801cf6:	56                   	push   %esi
  801cf7:	53                   	push   %ebx
  801cf8:	83 ec 1c             	sub    $0x1c,%esp
  801cfb:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801cfe:	56                   	push   %esi
  801cff:	e8 68 f1 ff ff       	call   800e6c <strlen>
  801d04:	83 c4 10             	add    $0x10,%esp
  801d07:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d0c:	7f 6c                	jg     801d7a <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801d0e:	83 ec 0c             	sub    $0xc,%esp
  801d11:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d14:	50                   	push   %eax
  801d15:	e8 79 f8 ff ff       	call   801593 <fd_alloc>
  801d1a:	89 c3                	mov    %eax,%ebx
  801d1c:	83 c4 10             	add    $0x10,%esp
  801d1f:	85 c0                	test   %eax,%eax
  801d21:	78 3c                	js     801d5f <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801d23:	83 ec 08             	sub    $0x8,%esp
  801d26:	56                   	push   %esi
  801d27:	68 00 60 80 00       	push   $0x806000
  801d2c:	e8 74 f1 ff ff       	call   800ea5 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d34:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d3c:	b8 01 00 00 00       	mov    $0x1,%eax
  801d41:	e8 b8 fd ff ff       	call   801afe <fsipc>
  801d46:	89 c3                	mov    %eax,%ebx
  801d48:	83 c4 10             	add    $0x10,%esp
  801d4b:	85 c0                	test   %eax,%eax
  801d4d:	78 19                	js     801d68 <open+0x75>
	return fd2num(fd);
  801d4f:	83 ec 0c             	sub    $0xc,%esp
  801d52:	ff 75 f4             	pushl  -0xc(%ebp)
  801d55:	e8 12 f8 ff ff       	call   80156c <fd2num>
  801d5a:	89 c3                	mov    %eax,%ebx
  801d5c:	83 c4 10             	add    $0x10,%esp
}
  801d5f:	89 d8                	mov    %ebx,%eax
  801d61:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d64:	5b                   	pop    %ebx
  801d65:	5e                   	pop    %esi
  801d66:	5d                   	pop    %ebp
  801d67:	c3                   	ret    
		fd_close(fd, 0);
  801d68:	83 ec 08             	sub    $0x8,%esp
  801d6b:	6a 00                	push   $0x0
  801d6d:	ff 75 f4             	pushl  -0xc(%ebp)
  801d70:	e8 1b f9 ff ff       	call   801690 <fd_close>
		return r;
  801d75:	83 c4 10             	add    $0x10,%esp
  801d78:	eb e5                	jmp    801d5f <open+0x6c>
		return -E_BAD_PATH;
  801d7a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801d7f:	eb de                	jmp    801d5f <open+0x6c>

00801d81 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
  801d84:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d87:	ba 00 00 00 00       	mov    $0x0,%edx
  801d8c:	b8 08 00 00 00       	mov    $0x8,%eax
  801d91:	e8 68 fd ff ff       	call   801afe <fsipc>
}
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
  801d9b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801d9e:	68 73 33 80 00       	push   $0x803373
  801da3:	ff 75 0c             	pushl  0xc(%ebp)
  801da6:	e8 fa f0 ff ff       	call   800ea5 <strcpy>
	return 0;
}
  801dab:	b8 00 00 00 00       	mov    $0x0,%eax
  801db0:	c9                   	leave  
  801db1:	c3                   	ret    

00801db2 <devsock_close>:
{
  801db2:	55                   	push   %ebp
  801db3:	89 e5                	mov    %esp,%ebp
  801db5:	53                   	push   %ebx
  801db6:	83 ec 10             	sub    $0x10,%esp
  801db9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801dbc:	53                   	push   %ebx
  801dbd:	e8 95 0c 00 00       	call   802a57 <pageref>
  801dc2:	83 c4 10             	add    $0x10,%esp
		return 0;
  801dc5:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801dca:	83 f8 01             	cmp    $0x1,%eax
  801dcd:	74 07                	je     801dd6 <devsock_close+0x24>
}
  801dcf:	89 d0                	mov    %edx,%eax
  801dd1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dd4:	c9                   	leave  
  801dd5:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801dd6:	83 ec 0c             	sub    $0xc,%esp
  801dd9:	ff 73 0c             	pushl  0xc(%ebx)
  801ddc:	e8 b9 02 00 00       	call   80209a <nsipc_close>
  801de1:	89 c2                	mov    %eax,%edx
  801de3:	83 c4 10             	add    $0x10,%esp
  801de6:	eb e7                	jmp    801dcf <devsock_close+0x1d>

00801de8 <devsock_write>:
{
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
  801deb:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801dee:	6a 00                	push   $0x0
  801df0:	ff 75 10             	pushl  0x10(%ebp)
  801df3:	ff 75 0c             	pushl  0xc(%ebp)
  801df6:	8b 45 08             	mov    0x8(%ebp),%eax
  801df9:	ff 70 0c             	pushl  0xc(%eax)
  801dfc:	e8 76 03 00 00       	call   802177 <nsipc_send>
}
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    

00801e03 <devsock_read>:
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
  801e06:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e09:	6a 00                	push   $0x0
  801e0b:	ff 75 10             	pushl  0x10(%ebp)
  801e0e:	ff 75 0c             	pushl  0xc(%ebp)
  801e11:	8b 45 08             	mov    0x8(%ebp),%eax
  801e14:	ff 70 0c             	pushl  0xc(%eax)
  801e17:	e8 ef 02 00 00       	call   80210b <nsipc_recv>
}
  801e1c:	c9                   	leave  
  801e1d:	c3                   	ret    

00801e1e <fd2sockid>:
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
  801e21:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801e24:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e27:	52                   	push   %edx
  801e28:	50                   	push   %eax
  801e29:	e8 b7 f7 ff ff       	call   8015e5 <fd_lookup>
  801e2e:	83 c4 10             	add    $0x10,%esp
  801e31:	85 c0                	test   %eax,%eax
  801e33:	78 10                	js     801e45 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e38:	8b 0d 40 40 80 00    	mov    0x804040,%ecx
  801e3e:	39 08                	cmp    %ecx,(%eax)
  801e40:	75 05                	jne    801e47 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801e42:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801e45:	c9                   	leave  
  801e46:	c3                   	ret    
		return -E_NOT_SUPP;
  801e47:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e4c:	eb f7                	jmp    801e45 <fd2sockid+0x27>

00801e4e <alloc_sockfd>:
{
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
  801e51:	56                   	push   %esi
  801e52:	53                   	push   %ebx
  801e53:	83 ec 1c             	sub    $0x1c,%esp
  801e56:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801e58:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e5b:	50                   	push   %eax
  801e5c:	e8 32 f7 ff ff       	call   801593 <fd_alloc>
  801e61:	89 c3                	mov    %eax,%ebx
  801e63:	83 c4 10             	add    $0x10,%esp
  801e66:	85 c0                	test   %eax,%eax
  801e68:	78 43                	js     801ead <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801e6a:	83 ec 04             	sub    $0x4,%esp
  801e6d:	68 07 04 00 00       	push   $0x407
  801e72:	ff 75 f4             	pushl  -0xc(%ebp)
  801e75:	6a 00                	push   $0x0
  801e77:	e8 1b f4 ff ff       	call   801297 <sys_page_alloc>
  801e7c:	89 c3                	mov    %eax,%ebx
  801e7e:	83 c4 10             	add    $0x10,%esp
  801e81:	85 c0                	test   %eax,%eax
  801e83:	78 28                	js     801ead <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e88:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801e8e:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e93:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801e9a:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801e9d:	83 ec 0c             	sub    $0xc,%esp
  801ea0:	50                   	push   %eax
  801ea1:	e8 c6 f6 ff ff       	call   80156c <fd2num>
  801ea6:	89 c3                	mov    %eax,%ebx
  801ea8:	83 c4 10             	add    $0x10,%esp
  801eab:	eb 0c                	jmp    801eb9 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801ead:	83 ec 0c             	sub    $0xc,%esp
  801eb0:	56                   	push   %esi
  801eb1:	e8 e4 01 00 00       	call   80209a <nsipc_close>
		return r;
  801eb6:	83 c4 10             	add    $0x10,%esp
}
  801eb9:	89 d8                	mov    %ebx,%eax
  801ebb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ebe:	5b                   	pop    %ebx
  801ebf:	5e                   	pop    %esi
  801ec0:	5d                   	pop    %ebp
  801ec1:	c3                   	ret    

00801ec2 <accept>:
{
  801ec2:	55                   	push   %ebp
  801ec3:	89 e5                	mov    %esp,%ebp
  801ec5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecb:	e8 4e ff ff ff       	call   801e1e <fd2sockid>
  801ed0:	85 c0                	test   %eax,%eax
  801ed2:	78 1b                	js     801eef <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ed4:	83 ec 04             	sub    $0x4,%esp
  801ed7:	ff 75 10             	pushl  0x10(%ebp)
  801eda:	ff 75 0c             	pushl  0xc(%ebp)
  801edd:	50                   	push   %eax
  801ede:	e8 0e 01 00 00       	call   801ff1 <nsipc_accept>
  801ee3:	83 c4 10             	add    $0x10,%esp
  801ee6:	85 c0                	test   %eax,%eax
  801ee8:	78 05                	js     801eef <accept+0x2d>
	return alloc_sockfd(r);
  801eea:	e8 5f ff ff ff       	call   801e4e <alloc_sockfd>
}
  801eef:	c9                   	leave  
  801ef0:	c3                   	ret    

00801ef1 <bind>:
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
  801ef4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  801efa:	e8 1f ff ff ff       	call   801e1e <fd2sockid>
  801eff:	85 c0                	test   %eax,%eax
  801f01:	78 12                	js     801f15 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801f03:	83 ec 04             	sub    $0x4,%esp
  801f06:	ff 75 10             	pushl  0x10(%ebp)
  801f09:	ff 75 0c             	pushl  0xc(%ebp)
  801f0c:	50                   	push   %eax
  801f0d:	e8 31 01 00 00       	call   802043 <nsipc_bind>
  801f12:	83 c4 10             	add    $0x10,%esp
}
  801f15:	c9                   	leave  
  801f16:	c3                   	ret    

00801f17 <shutdown>:
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
  801f1a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f20:	e8 f9 fe ff ff       	call   801e1e <fd2sockid>
  801f25:	85 c0                	test   %eax,%eax
  801f27:	78 0f                	js     801f38 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801f29:	83 ec 08             	sub    $0x8,%esp
  801f2c:	ff 75 0c             	pushl  0xc(%ebp)
  801f2f:	50                   	push   %eax
  801f30:	e8 43 01 00 00       	call   802078 <nsipc_shutdown>
  801f35:	83 c4 10             	add    $0x10,%esp
}
  801f38:	c9                   	leave  
  801f39:	c3                   	ret    

00801f3a <connect>:
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
  801f3d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f40:	8b 45 08             	mov    0x8(%ebp),%eax
  801f43:	e8 d6 fe ff ff       	call   801e1e <fd2sockid>
  801f48:	85 c0                	test   %eax,%eax
  801f4a:	78 12                	js     801f5e <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801f4c:	83 ec 04             	sub    $0x4,%esp
  801f4f:	ff 75 10             	pushl  0x10(%ebp)
  801f52:	ff 75 0c             	pushl  0xc(%ebp)
  801f55:	50                   	push   %eax
  801f56:	e8 59 01 00 00       	call   8020b4 <nsipc_connect>
  801f5b:	83 c4 10             	add    $0x10,%esp
}
  801f5e:	c9                   	leave  
  801f5f:	c3                   	ret    

00801f60 <listen>:
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
  801f63:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f66:	8b 45 08             	mov    0x8(%ebp),%eax
  801f69:	e8 b0 fe ff ff       	call   801e1e <fd2sockid>
  801f6e:	85 c0                	test   %eax,%eax
  801f70:	78 0f                	js     801f81 <listen+0x21>
	return nsipc_listen(r, backlog);
  801f72:	83 ec 08             	sub    $0x8,%esp
  801f75:	ff 75 0c             	pushl  0xc(%ebp)
  801f78:	50                   	push   %eax
  801f79:	e8 6b 01 00 00       	call   8020e9 <nsipc_listen>
  801f7e:	83 c4 10             	add    $0x10,%esp
}
  801f81:	c9                   	leave  
  801f82:	c3                   	ret    

00801f83 <socket>:

int
socket(int domain, int type, int protocol)
{
  801f83:	55                   	push   %ebp
  801f84:	89 e5                	mov    %esp,%ebp
  801f86:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f89:	ff 75 10             	pushl  0x10(%ebp)
  801f8c:	ff 75 0c             	pushl  0xc(%ebp)
  801f8f:	ff 75 08             	pushl  0x8(%ebp)
  801f92:	e8 3e 02 00 00       	call   8021d5 <nsipc_socket>
  801f97:	83 c4 10             	add    $0x10,%esp
  801f9a:	85 c0                	test   %eax,%eax
  801f9c:	78 05                	js     801fa3 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801f9e:	e8 ab fe ff ff       	call   801e4e <alloc_sockfd>
}
  801fa3:	c9                   	leave  
  801fa4:	c3                   	ret    

00801fa5 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801fa5:	55                   	push   %ebp
  801fa6:	89 e5                	mov    %esp,%ebp
  801fa8:	53                   	push   %ebx
  801fa9:	83 ec 04             	sub    $0x4,%esp
  801fac:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801fae:	83 3d 14 50 80 00 00 	cmpl   $0x0,0x805014
  801fb5:	74 26                	je     801fdd <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801fb7:	6a 07                	push   $0x7
  801fb9:	68 00 70 80 00       	push   $0x807000
  801fbe:	53                   	push   %ebx
  801fbf:	ff 35 14 50 80 00    	pushl  0x805014
  801fc5:	e8 fa 09 00 00       	call   8029c4 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801fca:	83 c4 0c             	add    $0xc,%esp
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	e8 83 09 00 00       	call   80295b <ipc_recv>
}
  801fd8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fdb:	c9                   	leave  
  801fdc:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801fdd:	83 ec 0c             	sub    $0xc,%esp
  801fe0:	6a 02                	push   $0x2
  801fe2:	e8 35 0a 00 00       	call   802a1c <ipc_find_env>
  801fe7:	a3 14 50 80 00       	mov    %eax,0x805014
  801fec:	83 c4 10             	add    $0x10,%esp
  801fef:	eb c6                	jmp    801fb7 <nsipc+0x12>

00801ff1 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ff1:	55                   	push   %ebp
  801ff2:	89 e5                	mov    %esp,%ebp
  801ff4:	56                   	push   %esi
  801ff5:	53                   	push   %ebx
  801ff6:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffc:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802001:	8b 06                	mov    (%esi),%eax
  802003:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802008:	b8 01 00 00 00       	mov    $0x1,%eax
  80200d:	e8 93 ff ff ff       	call   801fa5 <nsipc>
  802012:	89 c3                	mov    %eax,%ebx
  802014:	85 c0                	test   %eax,%eax
  802016:	79 09                	jns    802021 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802018:	89 d8                	mov    %ebx,%eax
  80201a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80201d:	5b                   	pop    %ebx
  80201e:	5e                   	pop    %esi
  80201f:	5d                   	pop    %ebp
  802020:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802021:	83 ec 04             	sub    $0x4,%esp
  802024:	ff 35 10 70 80 00    	pushl  0x807010
  80202a:	68 00 70 80 00       	push   $0x807000
  80202f:	ff 75 0c             	pushl  0xc(%ebp)
  802032:	e8 fc ef ff ff       	call   801033 <memmove>
		*addrlen = ret->ret_addrlen;
  802037:	a1 10 70 80 00       	mov    0x807010,%eax
  80203c:	89 06                	mov    %eax,(%esi)
  80203e:	83 c4 10             	add    $0x10,%esp
	return r;
  802041:	eb d5                	jmp    802018 <nsipc_accept+0x27>

00802043 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802043:	55                   	push   %ebp
  802044:	89 e5                	mov    %esp,%ebp
  802046:	53                   	push   %ebx
  802047:	83 ec 08             	sub    $0x8,%esp
  80204a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80204d:	8b 45 08             	mov    0x8(%ebp),%eax
  802050:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802055:	53                   	push   %ebx
  802056:	ff 75 0c             	pushl  0xc(%ebp)
  802059:	68 04 70 80 00       	push   $0x807004
  80205e:	e8 d0 ef ff ff       	call   801033 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802063:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802069:	b8 02 00 00 00       	mov    $0x2,%eax
  80206e:	e8 32 ff ff ff       	call   801fa5 <nsipc>
}
  802073:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802076:	c9                   	leave  
  802077:	c3                   	ret    

00802078 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802078:	55                   	push   %ebp
  802079:	89 e5                	mov    %esp,%ebp
  80207b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80207e:	8b 45 08             	mov    0x8(%ebp),%eax
  802081:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802086:	8b 45 0c             	mov    0xc(%ebp),%eax
  802089:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80208e:	b8 03 00 00 00       	mov    $0x3,%eax
  802093:	e8 0d ff ff ff       	call   801fa5 <nsipc>
}
  802098:	c9                   	leave  
  802099:	c3                   	ret    

0080209a <nsipc_close>:

int
nsipc_close(int s)
{
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
  80209d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8020a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a3:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8020a8:	b8 04 00 00 00       	mov    $0x4,%eax
  8020ad:	e8 f3 fe ff ff       	call   801fa5 <nsipc>
}
  8020b2:	c9                   	leave  
  8020b3:	c3                   	ret    

008020b4 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020b4:	55                   	push   %ebp
  8020b5:	89 e5                	mov    %esp,%ebp
  8020b7:	53                   	push   %ebx
  8020b8:	83 ec 08             	sub    $0x8,%esp
  8020bb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8020be:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c1:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8020c6:	53                   	push   %ebx
  8020c7:	ff 75 0c             	pushl  0xc(%ebp)
  8020ca:	68 04 70 80 00       	push   $0x807004
  8020cf:	e8 5f ef ff ff       	call   801033 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8020d4:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8020da:	b8 05 00 00 00       	mov    $0x5,%eax
  8020df:	e8 c1 fe ff ff       	call   801fa5 <nsipc>
}
  8020e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020e7:	c9                   	leave  
  8020e8:	c3                   	ret    

008020e9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8020e9:	55                   	push   %ebp
  8020ea:	89 e5                	mov    %esp,%ebp
  8020ec:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8020f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020fa:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8020ff:	b8 06 00 00 00       	mov    $0x6,%eax
  802104:	e8 9c fe ff ff       	call   801fa5 <nsipc>
}
  802109:	c9                   	leave  
  80210a:	c3                   	ret    

0080210b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80210b:	55                   	push   %ebp
  80210c:	89 e5                	mov    %esp,%ebp
  80210e:	56                   	push   %esi
  80210f:	53                   	push   %ebx
  802110:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802113:	8b 45 08             	mov    0x8(%ebp),%eax
  802116:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80211b:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802121:	8b 45 14             	mov    0x14(%ebp),%eax
  802124:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802129:	b8 07 00 00 00       	mov    $0x7,%eax
  80212e:	e8 72 fe ff ff       	call   801fa5 <nsipc>
  802133:	89 c3                	mov    %eax,%ebx
  802135:	85 c0                	test   %eax,%eax
  802137:	78 1f                	js     802158 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802139:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80213e:	7f 21                	jg     802161 <nsipc_recv+0x56>
  802140:	39 c6                	cmp    %eax,%esi
  802142:	7c 1d                	jl     802161 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802144:	83 ec 04             	sub    $0x4,%esp
  802147:	50                   	push   %eax
  802148:	68 00 70 80 00       	push   $0x807000
  80214d:	ff 75 0c             	pushl  0xc(%ebp)
  802150:	e8 de ee ff ff       	call   801033 <memmove>
  802155:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802158:	89 d8                	mov    %ebx,%eax
  80215a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80215d:	5b                   	pop    %ebx
  80215e:	5e                   	pop    %esi
  80215f:	5d                   	pop    %ebp
  802160:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802161:	68 7f 33 80 00       	push   $0x80337f
  802166:	68 47 33 80 00       	push   $0x803347
  80216b:	6a 62                	push   $0x62
  80216d:	68 94 33 80 00       	push   $0x803394
  802172:	e8 d9 e4 ff ff       	call   800650 <_panic>

00802177 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802177:	55                   	push   %ebp
  802178:	89 e5                	mov    %esp,%ebp
  80217a:	53                   	push   %ebx
  80217b:	83 ec 04             	sub    $0x4,%esp
  80217e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802181:	8b 45 08             	mov    0x8(%ebp),%eax
  802184:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802189:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80218f:	7f 2e                	jg     8021bf <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802191:	83 ec 04             	sub    $0x4,%esp
  802194:	53                   	push   %ebx
  802195:	ff 75 0c             	pushl  0xc(%ebp)
  802198:	68 0c 70 80 00       	push   $0x80700c
  80219d:	e8 91 ee ff ff       	call   801033 <memmove>
	nsipcbuf.send.req_size = size;
  8021a2:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8021a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8021ab:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8021b0:	b8 08 00 00 00       	mov    $0x8,%eax
  8021b5:	e8 eb fd ff ff       	call   801fa5 <nsipc>
}
  8021ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021bd:	c9                   	leave  
  8021be:	c3                   	ret    
	assert(size < 1600);
  8021bf:	68 a0 33 80 00       	push   $0x8033a0
  8021c4:	68 47 33 80 00       	push   $0x803347
  8021c9:	6a 6d                	push   $0x6d
  8021cb:	68 94 33 80 00       	push   $0x803394
  8021d0:	e8 7b e4 ff ff       	call   800650 <_panic>

008021d5 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8021d5:	55                   	push   %ebp
  8021d6:	89 e5                	mov    %esp,%ebp
  8021d8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8021db:	8b 45 08             	mov    0x8(%ebp),%eax
  8021de:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8021e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e6:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8021eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8021ee:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8021f3:	b8 09 00 00 00       	mov    $0x9,%eax
  8021f8:	e8 a8 fd ff ff       	call   801fa5 <nsipc>
}
  8021fd:	c9                   	leave  
  8021fe:	c3                   	ret    

008021ff <free>:
	return v;
}

void
free(void *v)
{
  8021ff:	55                   	push   %ebp
  802200:	89 e5                	mov    %esp,%ebp
  802202:	53                   	push   %ebx
  802203:	83 ec 04             	sub    $0x4,%esp
  802206:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
  802209:	85 db                	test   %ebx,%ebx
  80220b:	0f 84 85 00 00 00    	je     802296 <free+0x97>
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  802211:	8d 83 00 00 00 f8    	lea    -0x8000000(%ebx),%eax
  802217:	3d ff ff ff 07       	cmp    $0x7ffffff,%eax
  80221c:	77 51                	ja     80226f <free+0x70>

	c = ROUNDDOWN(v, PGSIZE);
  80221e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  802224:	89 d8                	mov    %ebx,%eax
  802226:	c1 e8 0c             	shr    $0xc,%eax
  802229:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802230:	f6 c4 02             	test   $0x2,%ah
  802233:	74 50                	je     802285 <free+0x86>
		sys_page_unmap(0, c);
  802235:	83 ec 08             	sub    $0x8,%esp
  802238:	53                   	push   %ebx
  802239:	6a 00                	push   $0x0
  80223b:	e8 dc f0 ff ff       	call   80131c <sys_page_unmap>
		c += PGSIZE;
  802240:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		assert(mbegin <= c && c < mend);
  802246:	8d 83 00 00 00 f8    	lea    -0x8000000(%ebx),%eax
  80224c:	83 c4 10             	add    $0x10,%esp
  80224f:	3d ff ff ff 07       	cmp    $0x7ffffff,%eax
  802254:	76 ce                	jbe    802224 <free+0x25>
  802256:	68 e9 33 80 00       	push   $0x8033e9
  80225b:	68 47 33 80 00       	push   $0x803347
  802260:	68 81 00 00 00       	push   $0x81
  802265:	68 dc 33 80 00       	push   $0x8033dc
  80226a:	e8 e1 e3 ff ff       	call   800650 <_panic>
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  80226f:	68 ac 33 80 00       	push   $0x8033ac
  802274:	68 47 33 80 00       	push   $0x803347
  802279:	6a 7a                	push   $0x7a
  80227b:	68 dc 33 80 00       	push   $0x8033dc
  802280:	e8 cb e3 ff ff       	call   800650 <_panic>
	/*
	 * c is just a piece of this page, so dec the ref count
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
	if (--(*ref) == 0)
  802285:	8b 83 fc 0f 00 00    	mov    0xffc(%ebx),%eax
  80228b:	83 e8 01             	sub    $0x1,%eax
  80228e:	89 83 fc 0f 00 00    	mov    %eax,0xffc(%ebx)
  802294:	74 05                	je     80229b <free+0x9c>
		sys_page_unmap(0, c);
}
  802296:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802299:	c9                   	leave  
  80229a:	c3                   	ret    
		sys_page_unmap(0, c);
  80229b:	83 ec 08             	sub    $0x8,%esp
  80229e:	53                   	push   %ebx
  80229f:	6a 00                	push   $0x0
  8022a1:	e8 76 f0 ff ff       	call   80131c <sys_page_unmap>
  8022a6:	83 c4 10             	add    $0x10,%esp
  8022a9:	eb eb                	jmp    802296 <free+0x97>

008022ab <malloc>:
{
  8022ab:	55                   	push   %ebp
  8022ac:	89 e5                	mov    %esp,%ebp
  8022ae:	57                   	push   %edi
  8022af:	56                   	push   %esi
  8022b0:	53                   	push   %ebx
  8022b1:	83 ec 1c             	sub    $0x1c,%esp
	if (mptr == 0)
  8022b4:	a1 18 50 80 00       	mov    0x805018,%eax
  8022b9:	85 c0                	test   %eax,%eax
  8022bb:	74 74                	je     802331 <malloc+0x86>
	n = ROUNDUP(n, 4);
  8022bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022c0:	8d 51 03             	lea    0x3(%ecx),%edx
  8022c3:	83 e2 fc             	and    $0xfffffffc,%edx
  8022c6:	89 d6                	mov    %edx,%esi
  8022c8:	89 55 dc             	mov    %edx,-0x24(%ebp)
	if (n >= MAXMALLOC)
  8022cb:	81 fa ff ff 0f 00    	cmp    $0xfffff,%edx
  8022d1:	0f 87 55 01 00 00    	ja     80242c <malloc+0x181>
	if ((uintptr_t) mptr % PGSIZE){
  8022d7:	89 c1                	mov    %eax,%ecx
  8022d9:	a9 ff 0f 00 00       	test   $0xfff,%eax
  8022de:	74 30                	je     802310 <malloc+0x65>
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
  8022e0:	89 c3                	mov    %eax,%ebx
  8022e2:	c1 eb 0c             	shr    $0xc,%ebx
  8022e5:	8d 54 10 03          	lea    0x3(%eax,%edx,1),%edx
  8022e9:	c1 ea 0c             	shr    $0xc,%edx
  8022ec:	39 d3                	cmp    %edx,%ebx
  8022ee:	74 64                	je     802354 <malloc+0xa9>
		free(mptr);	/* drop reference to this page */
  8022f0:	83 ec 0c             	sub    $0xc,%esp
  8022f3:	50                   	push   %eax
  8022f4:	e8 06 ff ff ff       	call   8021ff <free>
		mptr = ROUNDDOWN(mptr + PGSIZE, PGSIZE);
  8022f9:	a1 18 50 80 00       	mov    0x805018,%eax
  8022fe:	05 00 10 00 00       	add    $0x1000,%eax
  802303:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802308:	a3 18 50 80 00       	mov    %eax,0x805018
  80230d:	83 c4 10             	add    $0x10,%esp
  802310:	8b 15 18 50 80 00    	mov    0x805018,%edx
{
  802316:	c7 45 d8 02 00 00 00 	movl   $0x2,-0x28(%ebp)
  80231d:	be 00 00 00 00       	mov    $0x0,%esi
		if (isfree(mptr, n + 4))
  802322:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802325:	8d 78 04             	lea    0x4(%eax),%edi
  802328:	c6 45 e3 01          	movb   $0x1,-0x1d(%ebp)
  80232c:	e9 86 00 00 00       	jmp    8023b7 <malloc+0x10c>
		mptr = mbegin;
  802331:	c7 05 18 50 80 00 00 	movl   $0x8000000,0x805018
  802338:	00 00 08 
	n = ROUNDUP(n, 4);
  80233b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80233e:	8d 51 03             	lea    0x3(%ecx),%edx
  802341:	83 e2 fc             	and    $0xfffffffc,%edx
  802344:	89 55 dc             	mov    %edx,-0x24(%ebp)
	if (n >= MAXMALLOC)
  802347:	81 fa ff ff 0f 00    	cmp    $0xfffff,%edx
  80234d:	76 c1                	jbe    802310 <malloc+0x65>
  80234f:	e9 fd 00 00 00       	jmp    802451 <malloc+0x1a6>
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
  802354:	81 c1 ff 0f 00 00    	add    $0xfff,%ecx
  80235a:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
			(*ref)++;
  802360:	83 41 fc 01          	addl   $0x1,-0x4(%ecx)
			mptr += n;
  802364:	89 f2                	mov    %esi,%edx
  802366:	01 c2                	add    %eax,%edx
  802368:	89 15 18 50 80 00    	mov    %edx,0x805018
			return v;
  80236e:	e9 de 00 00 00       	jmp    802451 <malloc+0x1a6>
	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  802373:	05 00 10 00 00       	add    $0x1000,%eax
  802378:	39 c8                	cmp    %ecx,%eax
  80237a:	73 66                	jae    8023e2 <malloc+0x137>
		if (va >= (uintptr_t) mend
  80237c:	3d ff ff ff 0f       	cmp    $0xfffffff,%eax
  802381:	77 22                	ja     8023a5 <malloc+0xfa>
		    || ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
  802383:	89 c3                	mov    %eax,%ebx
  802385:	c1 eb 16             	shr    $0x16,%ebx
  802388:	8b 1c 9d 00 d0 7b ef 	mov    -0x10843000(,%ebx,4),%ebx
  80238f:	f6 c3 01             	test   $0x1,%bl
  802392:	74 df                	je     802373 <malloc+0xc8>
  802394:	89 c3                	mov    %eax,%ebx
  802396:	c1 eb 0c             	shr    $0xc,%ebx
  802399:	8b 1c 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%ebx
  8023a0:	f6 c3 01             	test   $0x1,%bl
  8023a3:	74 ce                	je     802373 <malloc+0xc8>
  8023a5:	81 c2 00 10 00 00    	add    $0x1000,%edx
  8023ab:	0f b6 75 e3          	movzbl -0x1d(%ebp),%esi
		if (mptr == mend) {
  8023af:	81 fa 00 00 00 10    	cmp    $0x10000000,%edx
  8023b5:	74 0a                	je     8023c1 <malloc+0x116>
  8023b7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  8023ba:	89 d0                	mov    %edx,%eax
  8023bc:	8d 0c 17             	lea    (%edi,%edx,1),%ecx
  8023bf:	eb b7                	jmp    802378 <malloc+0xcd>
			mptr = mbegin;
  8023c1:	ba 00 00 00 08       	mov    $0x8000000,%edx
  8023c6:	be 01 00 00 00       	mov    $0x1,%esi
			if (++nwrap == 2)
  8023cb:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8023cf:	75 e6                	jne    8023b7 <malloc+0x10c>
  8023d1:	c7 05 18 50 80 00 00 	movl   $0x8000000,0x805018
  8023d8:	00 00 08 
				return 0;	/* out of address space */
  8023db:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e0:	eb 6f                	jmp    802451 <malloc+0x1a6>
  8023e2:	89 f0                	mov    %esi,%eax
  8023e4:	84 c0                	test   %al,%al
  8023e6:	74 08                	je     8023f0 <malloc+0x145>
  8023e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023eb:	a3 18 50 80 00       	mov    %eax,0x805018
	for (i = 0; i < n + 4; i += PGSIZE){
  8023f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8023f5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
  8023f8:	8d b3 00 10 00 00    	lea    0x1000(%ebx),%esi
  8023fe:	39 f7                	cmp    %esi,%edi
  802400:	76 57                	jbe    802459 <malloc+0x1ae>
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  802402:	83 ec 04             	sub    $0x4,%esp
  802405:	68 07 02 00 00       	push   $0x207
  80240a:	89 d8                	mov    %ebx,%eax
  80240c:	03 05 18 50 80 00    	add    0x805018,%eax
  802412:	50                   	push   %eax
  802413:	6a 00                	push   $0x0
  802415:	e8 7d ee ff ff       	call   801297 <sys_page_alloc>
  80241a:	83 c4 10             	add    $0x10,%esp
  80241d:	85 c0                	test   %eax,%eax
  80241f:	78 55                	js     802476 <malloc+0x1cb>
	for (i = 0; i < n + 4; i += PGSIZE){
  802421:	89 f3                	mov    %esi,%ebx
  802423:	eb d0                	jmp    8023f5 <malloc+0x14a>
			return 0;	/* out of physical memory */
  802425:	b8 00 00 00 00       	mov    $0x0,%eax
  80242a:	eb 25                	jmp    802451 <malloc+0x1a6>
		return 0;
  80242c:	b8 00 00 00 00       	mov    $0x0,%eax
  802431:	eb 1e                	jmp    802451 <malloc+0x1a6>
	ref = (uint32_t*) (mptr + i - 4);
  802433:	a1 18 50 80 00       	mov    0x805018,%eax
	*ref = 2;	/* reference for mptr, reference for returned block */
  802438:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80243b:	c7 84 08 fc 0f 00 00 	movl   $0x2,0xffc(%eax,%ecx,1)
  802442:	02 00 00 00 
	mptr += n;
  802446:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802449:	01 c2                	add    %eax,%edx
  80244b:	89 15 18 50 80 00    	mov    %edx,0x805018
}
  802451:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802454:	5b                   	pop    %ebx
  802455:	5e                   	pop    %esi
  802456:	5f                   	pop    %edi
  802457:	5d                   	pop    %ebp
  802458:	c3                   	ret    
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  802459:	83 ec 04             	sub    $0x4,%esp
  80245c:	6a 07                	push   $0x7
  80245e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802461:	03 05 18 50 80 00    	add    0x805018,%eax
  802467:	50                   	push   %eax
  802468:	6a 00                	push   $0x0
  80246a:	e8 28 ee ff ff       	call   801297 <sys_page_alloc>
  80246f:	83 c4 10             	add    $0x10,%esp
  802472:	85 c0                	test   %eax,%eax
  802474:	79 bd                	jns    802433 <malloc+0x188>
			for (; i >= 0; i -= PGSIZE)
  802476:	85 db                	test   %ebx,%ebx
  802478:	78 ab                	js     802425 <malloc+0x17a>
				sys_page_unmap(0, mptr + i);
  80247a:	83 ec 08             	sub    $0x8,%esp
  80247d:	89 d8                	mov    %ebx,%eax
  80247f:	03 05 18 50 80 00    	add    0x805018,%eax
  802485:	50                   	push   %eax
  802486:	6a 00                	push   $0x0
  802488:	e8 8f ee ff ff       	call   80131c <sys_page_unmap>
			for (; i >= 0; i -= PGSIZE)
  80248d:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
  802493:	83 c4 10             	add    $0x10,%esp
  802496:	eb de                	jmp    802476 <malloc+0x1cb>

00802498 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802498:	55                   	push   %ebp
  802499:	89 e5                	mov    %esp,%ebp
  80249b:	56                   	push   %esi
  80249c:	53                   	push   %ebx
  80249d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8024a0:	83 ec 0c             	sub    $0xc,%esp
  8024a3:	ff 75 08             	pushl  0x8(%ebp)
  8024a6:	e8 d1 f0 ff ff       	call   80157c <fd2data>
  8024ab:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8024ad:	83 c4 08             	add    $0x8,%esp
  8024b0:	68 01 34 80 00       	push   $0x803401
  8024b5:	53                   	push   %ebx
  8024b6:	e8 ea e9 ff ff       	call   800ea5 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8024bb:	8b 46 04             	mov    0x4(%esi),%eax
  8024be:	2b 06                	sub    (%esi),%eax
  8024c0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8024c6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8024cd:	00 00 00 
	stat->st_dev = &devpipe;
  8024d0:	c7 83 88 00 00 00 5c 	movl   $0x80405c,0x88(%ebx)
  8024d7:	40 80 00 
	return 0;
}
  8024da:	b8 00 00 00 00       	mov    $0x0,%eax
  8024df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024e2:	5b                   	pop    %ebx
  8024e3:	5e                   	pop    %esi
  8024e4:	5d                   	pop    %ebp
  8024e5:	c3                   	ret    

008024e6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8024e6:	55                   	push   %ebp
  8024e7:	89 e5                	mov    %esp,%ebp
  8024e9:	53                   	push   %ebx
  8024ea:	83 ec 0c             	sub    $0xc,%esp
  8024ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8024f0:	53                   	push   %ebx
  8024f1:	6a 00                	push   $0x0
  8024f3:	e8 24 ee ff ff       	call   80131c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8024f8:	89 1c 24             	mov    %ebx,(%esp)
  8024fb:	e8 7c f0 ff ff       	call   80157c <fd2data>
  802500:	83 c4 08             	add    $0x8,%esp
  802503:	50                   	push   %eax
  802504:	6a 00                	push   $0x0
  802506:	e8 11 ee ff ff       	call   80131c <sys_page_unmap>
}
  80250b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80250e:	c9                   	leave  
  80250f:	c3                   	ret    

00802510 <_pipeisclosed>:
{
  802510:	55                   	push   %ebp
  802511:	89 e5                	mov    %esp,%ebp
  802513:	57                   	push   %edi
  802514:	56                   	push   %esi
  802515:	53                   	push   %ebx
  802516:	83 ec 1c             	sub    $0x1c,%esp
  802519:	89 c7                	mov    %eax,%edi
  80251b:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80251d:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802522:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802525:	83 ec 0c             	sub    $0xc,%esp
  802528:	57                   	push   %edi
  802529:	e8 29 05 00 00       	call   802a57 <pageref>
  80252e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802531:	89 34 24             	mov    %esi,(%esp)
  802534:	e8 1e 05 00 00       	call   802a57 <pageref>
		nn = thisenv->env_runs;
  802539:	8b 15 1c 50 80 00    	mov    0x80501c,%edx
  80253f:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802542:	83 c4 10             	add    $0x10,%esp
  802545:	39 cb                	cmp    %ecx,%ebx
  802547:	74 1b                	je     802564 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802549:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80254c:	75 cf                	jne    80251d <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80254e:	8b 42 58             	mov    0x58(%edx),%eax
  802551:	6a 01                	push   $0x1
  802553:	50                   	push   %eax
  802554:	53                   	push   %ebx
  802555:	68 08 34 80 00       	push   $0x803408
  80255a:	e8 e7 e1 ff ff       	call   800746 <cprintf>
  80255f:	83 c4 10             	add    $0x10,%esp
  802562:	eb b9                	jmp    80251d <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802564:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802567:	0f 94 c0             	sete   %al
  80256a:	0f b6 c0             	movzbl %al,%eax
}
  80256d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802570:	5b                   	pop    %ebx
  802571:	5e                   	pop    %esi
  802572:	5f                   	pop    %edi
  802573:	5d                   	pop    %ebp
  802574:	c3                   	ret    

00802575 <devpipe_write>:
{
  802575:	55                   	push   %ebp
  802576:	89 e5                	mov    %esp,%ebp
  802578:	57                   	push   %edi
  802579:	56                   	push   %esi
  80257a:	53                   	push   %ebx
  80257b:	83 ec 28             	sub    $0x28,%esp
  80257e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802581:	56                   	push   %esi
  802582:	e8 f5 ef ff ff       	call   80157c <fd2data>
  802587:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802589:	83 c4 10             	add    $0x10,%esp
  80258c:	bf 00 00 00 00       	mov    $0x0,%edi
  802591:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802594:	74 4f                	je     8025e5 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802596:	8b 43 04             	mov    0x4(%ebx),%eax
  802599:	8b 0b                	mov    (%ebx),%ecx
  80259b:	8d 51 20             	lea    0x20(%ecx),%edx
  80259e:	39 d0                	cmp    %edx,%eax
  8025a0:	72 14                	jb     8025b6 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8025a2:	89 da                	mov    %ebx,%edx
  8025a4:	89 f0                	mov    %esi,%eax
  8025a6:	e8 65 ff ff ff       	call   802510 <_pipeisclosed>
  8025ab:	85 c0                	test   %eax,%eax
  8025ad:	75 3b                	jne    8025ea <devpipe_write+0x75>
			sys_yield();
  8025af:	e8 c4 ec ff ff       	call   801278 <sys_yield>
  8025b4:	eb e0                	jmp    802596 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8025b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025b9:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8025bd:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8025c0:	89 c2                	mov    %eax,%edx
  8025c2:	c1 fa 1f             	sar    $0x1f,%edx
  8025c5:	89 d1                	mov    %edx,%ecx
  8025c7:	c1 e9 1b             	shr    $0x1b,%ecx
  8025ca:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8025cd:	83 e2 1f             	and    $0x1f,%edx
  8025d0:	29 ca                	sub    %ecx,%edx
  8025d2:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8025d6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8025da:	83 c0 01             	add    $0x1,%eax
  8025dd:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8025e0:	83 c7 01             	add    $0x1,%edi
  8025e3:	eb ac                	jmp    802591 <devpipe_write+0x1c>
	return i;
  8025e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8025e8:	eb 05                	jmp    8025ef <devpipe_write+0x7a>
				return 0;
  8025ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025f2:	5b                   	pop    %ebx
  8025f3:	5e                   	pop    %esi
  8025f4:	5f                   	pop    %edi
  8025f5:	5d                   	pop    %ebp
  8025f6:	c3                   	ret    

008025f7 <devpipe_read>:
{
  8025f7:	55                   	push   %ebp
  8025f8:	89 e5                	mov    %esp,%ebp
  8025fa:	57                   	push   %edi
  8025fb:	56                   	push   %esi
  8025fc:	53                   	push   %ebx
  8025fd:	83 ec 18             	sub    $0x18,%esp
  802600:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802603:	57                   	push   %edi
  802604:	e8 73 ef ff ff       	call   80157c <fd2data>
  802609:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80260b:	83 c4 10             	add    $0x10,%esp
  80260e:	be 00 00 00 00       	mov    $0x0,%esi
  802613:	3b 75 10             	cmp    0x10(%ebp),%esi
  802616:	75 14                	jne    80262c <devpipe_read+0x35>
	return i;
  802618:	8b 45 10             	mov    0x10(%ebp),%eax
  80261b:	eb 02                	jmp    80261f <devpipe_read+0x28>
				return i;
  80261d:	89 f0                	mov    %esi,%eax
}
  80261f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802622:	5b                   	pop    %ebx
  802623:	5e                   	pop    %esi
  802624:	5f                   	pop    %edi
  802625:	5d                   	pop    %ebp
  802626:	c3                   	ret    
			sys_yield();
  802627:	e8 4c ec ff ff       	call   801278 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80262c:	8b 03                	mov    (%ebx),%eax
  80262e:	3b 43 04             	cmp    0x4(%ebx),%eax
  802631:	75 18                	jne    80264b <devpipe_read+0x54>
			if (i > 0)
  802633:	85 f6                	test   %esi,%esi
  802635:	75 e6                	jne    80261d <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802637:	89 da                	mov    %ebx,%edx
  802639:	89 f8                	mov    %edi,%eax
  80263b:	e8 d0 fe ff ff       	call   802510 <_pipeisclosed>
  802640:	85 c0                	test   %eax,%eax
  802642:	74 e3                	je     802627 <devpipe_read+0x30>
				return 0;
  802644:	b8 00 00 00 00       	mov    $0x0,%eax
  802649:	eb d4                	jmp    80261f <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80264b:	99                   	cltd   
  80264c:	c1 ea 1b             	shr    $0x1b,%edx
  80264f:	01 d0                	add    %edx,%eax
  802651:	83 e0 1f             	and    $0x1f,%eax
  802654:	29 d0                	sub    %edx,%eax
  802656:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80265b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80265e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802661:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802664:	83 c6 01             	add    $0x1,%esi
  802667:	eb aa                	jmp    802613 <devpipe_read+0x1c>

00802669 <pipe>:
{
  802669:	55                   	push   %ebp
  80266a:	89 e5                	mov    %esp,%ebp
  80266c:	56                   	push   %esi
  80266d:	53                   	push   %ebx
  80266e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802671:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802674:	50                   	push   %eax
  802675:	e8 19 ef ff ff       	call   801593 <fd_alloc>
  80267a:	89 c3                	mov    %eax,%ebx
  80267c:	83 c4 10             	add    $0x10,%esp
  80267f:	85 c0                	test   %eax,%eax
  802681:	0f 88 23 01 00 00    	js     8027aa <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802687:	83 ec 04             	sub    $0x4,%esp
  80268a:	68 07 04 00 00       	push   $0x407
  80268f:	ff 75 f4             	pushl  -0xc(%ebp)
  802692:	6a 00                	push   $0x0
  802694:	e8 fe eb ff ff       	call   801297 <sys_page_alloc>
  802699:	89 c3                	mov    %eax,%ebx
  80269b:	83 c4 10             	add    $0x10,%esp
  80269e:	85 c0                	test   %eax,%eax
  8026a0:	0f 88 04 01 00 00    	js     8027aa <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8026a6:	83 ec 0c             	sub    $0xc,%esp
  8026a9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8026ac:	50                   	push   %eax
  8026ad:	e8 e1 ee ff ff       	call   801593 <fd_alloc>
  8026b2:	89 c3                	mov    %eax,%ebx
  8026b4:	83 c4 10             	add    $0x10,%esp
  8026b7:	85 c0                	test   %eax,%eax
  8026b9:	0f 88 db 00 00 00    	js     80279a <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026bf:	83 ec 04             	sub    $0x4,%esp
  8026c2:	68 07 04 00 00       	push   $0x407
  8026c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8026ca:	6a 00                	push   $0x0
  8026cc:	e8 c6 eb ff ff       	call   801297 <sys_page_alloc>
  8026d1:	89 c3                	mov    %eax,%ebx
  8026d3:	83 c4 10             	add    $0x10,%esp
  8026d6:	85 c0                	test   %eax,%eax
  8026d8:	0f 88 bc 00 00 00    	js     80279a <pipe+0x131>
	va = fd2data(fd0);
  8026de:	83 ec 0c             	sub    $0xc,%esp
  8026e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8026e4:	e8 93 ee ff ff       	call   80157c <fd2data>
  8026e9:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026eb:	83 c4 0c             	add    $0xc,%esp
  8026ee:	68 07 04 00 00       	push   $0x407
  8026f3:	50                   	push   %eax
  8026f4:	6a 00                	push   $0x0
  8026f6:	e8 9c eb ff ff       	call   801297 <sys_page_alloc>
  8026fb:	89 c3                	mov    %eax,%ebx
  8026fd:	83 c4 10             	add    $0x10,%esp
  802700:	85 c0                	test   %eax,%eax
  802702:	0f 88 82 00 00 00    	js     80278a <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802708:	83 ec 0c             	sub    $0xc,%esp
  80270b:	ff 75 f0             	pushl  -0x10(%ebp)
  80270e:	e8 69 ee ff ff       	call   80157c <fd2data>
  802713:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80271a:	50                   	push   %eax
  80271b:	6a 00                	push   $0x0
  80271d:	56                   	push   %esi
  80271e:	6a 00                	push   $0x0
  802720:	e8 b5 eb ff ff       	call   8012da <sys_page_map>
  802725:	89 c3                	mov    %eax,%ebx
  802727:	83 c4 20             	add    $0x20,%esp
  80272a:	85 c0                	test   %eax,%eax
  80272c:	78 4e                	js     80277c <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80272e:	a1 5c 40 80 00       	mov    0x80405c,%eax
  802733:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802736:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802738:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80273b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802742:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802745:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802747:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802751:	83 ec 0c             	sub    $0xc,%esp
  802754:	ff 75 f4             	pushl  -0xc(%ebp)
  802757:	e8 10 ee ff ff       	call   80156c <fd2num>
  80275c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80275f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802761:	83 c4 04             	add    $0x4,%esp
  802764:	ff 75 f0             	pushl  -0x10(%ebp)
  802767:	e8 00 ee ff ff       	call   80156c <fd2num>
  80276c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80276f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802772:	83 c4 10             	add    $0x10,%esp
  802775:	bb 00 00 00 00       	mov    $0x0,%ebx
  80277a:	eb 2e                	jmp    8027aa <pipe+0x141>
	sys_page_unmap(0, va);
  80277c:	83 ec 08             	sub    $0x8,%esp
  80277f:	56                   	push   %esi
  802780:	6a 00                	push   $0x0
  802782:	e8 95 eb ff ff       	call   80131c <sys_page_unmap>
  802787:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80278a:	83 ec 08             	sub    $0x8,%esp
  80278d:	ff 75 f0             	pushl  -0x10(%ebp)
  802790:	6a 00                	push   $0x0
  802792:	e8 85 eb ff ff       	call   80131c <sys_page_unmap>
  802797:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80279a:	83 ec 08             	sub    $0x8,%esp
  80279d:	ff 75 f4             	pushl  -0xc(%ebp)
  8027a0:	6a 00                	push   $0x0
  8027a2:	e8 75 eb ff ff       	call   80131c <sys_page_unmap>
  8027a7:	83 c4 10             	add    $0x10,%esp
}
  8027aa:	89 d8                	mov    %ebx,%eax
  8027ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027af:	5b                   	pop    %ebx
  8027b0:	5e                   	pop    %esi
  8027b1:	5d                   	pop    %ebp
  8027b2:	c3                   	ret    

008027b3 <pipeisclosed>:
{
  8027b3:	55                   	push   %ebp
  8027b4:	89 e5                	mov    %esp,%ebp
  8027b6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027bc:	50                   	push   %eax
  8027bd:	ff 75 08             	pushl  0x8(%ebp)
  8027c0:	e8 20 ee ff ff       	call   8015e5 <fd_lookup>
  8027c5:	83 c4 10             	add    $0x10,%esp
  8027c8:	85 c0                	test   %eax,%eax
  8027ca:	78 18                	js     8027e4 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8027cc:	83 ec 0c             	sub    $0xc,%esp
  8027cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8027d2:	e8 a5 ed ff ff       	call   80157c <fd2data>
	return _pipeisclosed(fd, p);
  8027d7:	89 c2                	mov    %eax,%edx
  8027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dc:	e8 2f fd ff ff       	call   802510 <_pipeisclosed>
  8027e1:	83 c4 10             	add    $0x10,%esp
}
  8027e4:	c9                   	leave  
  8027e5:	c3                   	ret    

008027e6 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8027e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027eb:	c3                   	ret    

008027ec <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8027ec:	55                   	push   %ebp
  8027ed:	89 e5                	mov    %esp,%ebp
  8027ef:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8027f2:	68 20 34 80 00       	push   $0x803420
  8027f7:	ff 75 0c             	pushl  0xc(%ebp)
  8027fa:	e8 a6 e6 ff ff       	call   800ea5 <strcpy>
	return 0;
}
  8027ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802804:	c9                   	leave  
  802805:	c3                   	ret    

00802806 <devcons_write>:
{
  802806:	55                   	push   %ebp
  802807:	89 e5                	mov    %esp,%ebp
  802809:	57                   	push   %edi
  80280a:	56                   	push   %esi
  80280b:	53                   	push   %ebx
  80280c:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802812:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802817:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80281d:	3b 75 10             	cmp    0x10(%ebp),%esi
  802820:	73 31                	jae    802853 <devcons_write+0x4d>
		m = n - tot;
  802822:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802825:	29 f3                	sub    %esi,%ebx
  802827:	83 fb 7f             	cmp    $0x7f,%ebx
  80282a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80282f:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802832:	83 ec 04             	sub    $0x4,%esp
  802835:	53                   	push   %ebx
  802836:	89 f0                	mov    %esi,%eax
  802838:	03 45 0c             	add    0xc(%ebp),%eax
  80283b:	50                   	push   %eax
  80283c:	57                   	push   %edi
  80283d:	e8 f1 e7 ff ff       	call   801033 <memmove>
		sys_cputs(buf, m);
  802842:	83 c4 08             	add    $0x8,%esp
  802845:	53                   	push   %ebx
  802846:	57                   	push   %edi
  802847:	e8 8f e9 ff ff       	call   8011db <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80284c:	01 de                	add    %ebx,%esi
  80284e:	83 c4 10             	add    $0x10,%esp
  802851:	eb ca                	jmp    80281d <devcons_write+0x17>
}
  802853:	89 f0                	mov    %esi,%eax
  802855:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802858:	5b                   	pop    %ebx
  802859:	5e                   	pop    %esi
  80285a:	5f                   	pop    %edi
  80285b:	5d                   	pop    %ebp
  80285c:	c3                   	ret    

0080285d <devcons_read>:
{
  80285d:	55                   	push   %ebp
  80285e:	89 e5                	mov    %esp,%ebp
  802860:	83 ec 08             	sub    $0x8,%esp
  802863:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802868:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80286c:	74 21                	je     80288f <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80286e:	e8 86 e9 ff ff       	call   8011f9 <sys_cgetc>
  802873:	85 c0                	test   %eax,%eax
  802875:	75 07                	jne    80287e <devcons_read+0x21>
		sys_yield();
  802877:	e8 fc e9 ff ff       	call   801278 <sys_yield>
  80287c:	eb f0                	jmp    80286e <devcons_read+0x11>
	if (c < 0)
  80287e:	78 0f                	js     80288f <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802880:	83 f8 04             	cmp    $0x4,%eax
  802883:	74 0c                	je     802891 <devcons_read+0x34>
	*(char*)vbuf = c;
  802885:	8b 55 0c             	mov    0xc(%ebp),%edx
  802888:	88 02                	mov    %al,(%edx)
	return 1;
  80288a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80288f:	c9                   	leave  
  802890:	c3                   	ret    
		return 0;
  802891:	b8 00 00 00 00       	mov    $0x0,%eax
  802896:	eb f7                	jmp    80288f <devcons_read+0x32>

00802898 <cputchar>:
{
  802898:	55                   	push   %ebp
  802899:	89 e5                	mov    %esp,%ebp
  80289b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80289e:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a1:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8028a4:	6a 01                	push   $0x1
  8028a6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8028a9:	50                   	push   %eax
  8028aa:	e8 2c e9 ff ff       	call   8011db <sys_cputs>
}
  8028af:	83 c4 10             	add    $0x10,%esp
  8028b2:	c9                   	leave  
  8028b3:	c3                   	ret    

008028b4 <getchar>:
{
  8028b4:	55                   	push   %ebp
  8028b5:	89 e5                	mov    %esp,%ebp
  8028b7:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8028ba:	6a 01                	push   $0x1
  8028bc:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8028bf:	50                   	push   %eax
  8028c0:	6a 00                	push   $0x0
  8028c2:	e8 8e ef ff ff       	call   801855 <read>
	if (r < 0)
  8028c7:	83 c4 10             	add    $0x10,%esp
  8028ca:	85 c0                	test   %eax,%eax
  8028cc:	78 06                	js     8028d4 <getchar+0x20>
	if (r < 1)
  8028ce:	74 06                	je     8028d6 <getchar+0x22>
	return c;
  8028d0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8028d4:	c9                   	leave  
  8028d5:	c3                   	ret    
		return -E_EOF;
  8028d6:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8028db:	eb f7                	jmp    8028d4 <getchar+0x20>

008028dd <iscons>:
{
  8028dd:	55                   	push   %ebp
  8028de:	89 e5                	mov    %esp,%ebp
  8028e0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028e6:	50                   	push   %eax
  8028e7:	ff 75 08             	pushl  0x8(%ebp)
  8028ea:	e8 f6 ec ff ff       	call   8015e5 <fd_lookup>
  8028ef:	83 c4 10             	add    $0x10,%esp
  8028f2:	85 c0                	test   %eax,%eax
  8028f4:	78 11                	js     802907 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8028f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f9:	8b 15 78 40 80 00    	mov    0x804078,%edx
  8028ff:	39 10                	cmp    %edx,(%eax)
  802901:	0f 94 c0             	sete   %al
  802904:	0f b6 c0             	movzbl %al,%eax
}
  802907:	c9                   	leave  
  802908:	c3                   	ret    

00802909 <opencons>:
{
  802909:	55                   	push   %ebp
  80290a:	89 e5                	mov    %esp,%ebp
  80290c:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80290f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802912:	50                   	push   %eax
  802913:	e8 7b ec ff ff       	call   801593 <fd_alloc>
  802918:	83 c4 10             	add    $0x10,%esp
  80291b:	85 c0                	test   %eax,%eax
  80291d:	78 3a                	js     802959 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80291f:	83 ec 04             	sub    $0x4,%esp
  802922:	68 07 04 00 00       	push   $0x407
  802927:	ff 75 f4             	pushl  -0xc(%ebp)
  80292a:	6a 00                	push   $0x0
  80292c:	e8 66 e9 ff ff       	call   801297 <sys_page_alloc>
  802931:	83 c4 10             	add    $0x10,%esp
  802934:	85 c0                	test   %eax,%eax
  802936:	78 21                	js     802959 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802938:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293b:	8b 15 78 40 80 00    	mov    0x804078,%edx
  802941:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802946:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80294d:	83 ec 0c             	sub    $0xc,%esp
  802950:	50                   	push   %eax
  802951:	e8 16 ec ff ff       	call   80156c <fd2num>
  802956:	83 c4 10             	add    $0x10,%esp
}
  802959:	c9                   	leave  
  80295a:	c3                   	ret    

0080295b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80295b:	55                   	push   %ebp
  80295c:	89 e5                	mov    %esp,%ebp
  80295e:	56                   	push   %esi
  80295f:	53                   	push   %ebx
  802960:	8b 75 08             	mov    0x8(%ebp),%esi
  802963:	8b 45 0c             	mov    0xc(%ebp),%eax
  802966:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802969:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80296b:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802970:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802973:	83 ec 0c             	sub    $0xc,%esp
  802976:	50                   	push   %eax
  802977:	e8 cb ea ff ff       	call   801447 <sys_ipc_recv>
	if(ret < 0){
  80297c:	83 c4 10             	add    $0x10,%esp
  80297f:	85 c0                	test   %eax,%eax
  802981:	78 2b                	js     8029ae <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802983:	85 f6                	test   %esi,%esi
  802985:	74 0a                	je     802991 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  802987:	a1 1c 50 80 00       	mov    0x80501c,%eax
  80298c:	8b 40 74             	mov    0x74(%eax),%eax
  80298f:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802991:	85 db                	test   %ebx,%ebx
  802993:	74 0a                	je     80299f <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  802995:	a1 1c 50 80 00       	mov    0x80501c,%eax
  80299a:	8b 40 78             	mov    0x78(%eax),%eax
  80299d:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  80299f:	a1 1c 50 80 00       	mov    0x80501c,%eax
  8029a4:	8b 40 70             	mov    0x70(%eax),%eax
}
  8029a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8029aa:	5b                   	pop    %ebx
  8029ab:	5e                   	pop    %esi
  8029ac:	5d                   	pop    %ebp
  8029ad:	c3                   	ret    
		if(from_env_store)
  8029ae:	85 f6                	test   %esi,%esi
  8029b0:	74 06                	je     8029b8 <ipc_recv+0x5d>
			*from_env_store = 0;
  8029b2:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8029b8:	85 db                	test   %ebx,%ebx
  8029ba:	74 eb                	je     8029a7 <ipc_recv+0x4c>
			*perm_store = 0;
  8029bc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8029c2:	eb e3                	jmp    8029a7 <ipc_recv+0x4c>

008029c4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8029c4:	55                   	push   %ebp
  8029c5:	89 e5                	mov    %esp,%ebp
  8029c7:	57                   	push   %edi
  8029c8:	56                   	push   %esi
  8029c9:	53                   	push   %ebx
  8029ca:	83 ec 0c             	sub    $0xc,%esp
  8029cd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8029d0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8029d3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8029d6:	85 db                	test   %ebx,%ebx
  8029d8:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8029dd:	0f 44 d8             	cmove  %eax,%ebx
  8029e0:	eb 05                	jmp    8029e7 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8029e2:	e8 91 e8 ff ff       	call   801278 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8029e7:	ff 75 14             	pushl  0x14(%ebp)
  8029ea:	53                   	push   %ebx
  8029eb:	56                   	push   %esi
  8029ec:	57                   	push   %edi
  8029ed:	e8 32 ea ff ff       	call   801424 <sys_ipc_try_send>
  8029f2:	83 c4 10             	add    $0x10,%esp
  8029f5:	85 c0                	test   %eax,%eax
  8029f7:	74 1b                	je     802a14 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8029f9:	79 e7                	jns    8029e2 <ipc_send+0x1e>
  8029fb:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8029fe:	74 e2                	je     8029e2 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802a00:	83 ec 04             	sub    $0x4,%esp
  802a03:	68 2c 34 80 00       	push   $0x80342c
  802a08:	6a 48                	push   $0x48
  802a0a:	68 41 34 80 00       	push   $0x803441
  802a0f:	e8 3c dc ff ff       	call   800650 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802a14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a17:	5b                   	pop    %ebx
  802a18:	5e                   	pop    %esi
  802a19:	5f                   	pop    %edi
  802a1a:	5d                   	pop    %ebp
  802a1b:	c3                   	ret    

00802a1c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802a1c:	55                   	push   %ebp
  802a1d:	89 e5                	mov    %esp,%ebp
  802a1f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802a22:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802a27:	89 c2                	mov    %eax,%edx
  802a29:	c1 e2 07             	shl    $0x7,%edx
  802a2c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802a32:	8b 52 50             	mov    0x50(%edx),%edx
  802a35:	39 ca                	cmp    %ecx,%edx
  802a37:	74 11                	je     802a4a <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802a39:	83 c0 01             	add    $0x1,%eax
  802a3c:	3d 00 04 00 00       	cmp    $0x400,%eax
  802a41:	75 e4                	jne    802a27 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802a43:	b8 00 00 00 00       	mov    $0x0,%eax
  802a48:	eb 0b                	jmp    802a55 <ipc_find_env+0x39>
			return envs[i].env_id;
  802a4a:	c1 e0 07             	shl    $0x7,%eax
  802a4d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802a52:	8b 40 48             	mov    0x48(%eax),%eax
}
  802a55:	5d                   	pop    %ebp
  802a56:	c3                   	ret    

00802a57 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802a57:	55                   	push   %ebp
  802a58:	89 e5                	mov    %esp,%ebp
  802a5a:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802a5d:	89 d0                	mov    %edx,%eax
  802a5f:	c1 e8 16             	shr    $0x16,%eax
  802a62:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802a69:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802a6e:	f6 c1 01             	test   $0x1,%cl
  802a71:	74 1d                	je     802a90 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802a73:	c1 ea 0c             	shr    $0xc,%edx
  802a76:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802a7d:	f6 c2 01             	test   $0x1,%dl
  802a80:	74 0e                	je     802a90 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802a82:	c1 ea 0c             	shr    $0xc,%edx
  802a85:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802a8c:	ef 
  802a8d:	0f b7 c0             	movzwl %ax,%eax
}
  802a90:	5d                   	pop    %ebp
  802a91:	c3                   	ret    
  802a92:	66 90                	xchg   %ax,%ax
  802a94:	66 90                	xchg   %ax,%ax
  802a96:	66 90                	xchg   %ax,%ax
  802a98:	66 90                	xchg   %ax,%ax
  802a9a:	66 90                	xchg   %ax,%ax
  802a9c:	66 90                	xchg   %ax,%ax
  802a9e:	66 90                	xchg   %ax,%ax

00802aa0 <__udivdi3>:
  802aa0:	55                   	push   %ebp
  802aa1:	57                   	push   %edi
  802aa2:	56                   	push   %esi
  802aa3:	53                   	push   %ebx
  802aa4:	83 ec 1c             	sub    $0x1c,%esp
  802aa7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802aab:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802aaf:	8b 74 24 34          	mov    0x34(%esp),%esi
  802ab3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802ab7:	85 d2                	test   %edx,%edx
  802ab9:	75 4d                	jne    802b08 <__udivdi3+0x68>
  802abb:	39 f3                	cmp    %esi,%ebx
  802abd:	76 19                	jbe    802ad8 <__udivdi3+0x38>
  802abf:	31 ff                	xor    %edi,%edi
  802ac1:	89 e8                	mov    %ebp,%eax
  802ac3:	89 f2                	mov    %esi,%edx
  802ac5:	f7 f3                	div    %ebx
  802ac7:	89 fa                	mov    %edi,%edx
  802ac9:	83 c4 1c             	add    $0x1c,%esp
  802acc:	5b                   	pop    %ebx
  802acd:	5e                   	pop    %esi
  802ace:	5f                   	pop    %edi
  802acf:	5d                   	pop    %ebp
  802ad0:	c3                   	ret    
  802ad1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ad8:	89 d9                	mov    %ebx,%ecx
  802ada:	85 db                	test   %ebx,%ebx
  802adc:	75 0b                	jne    802ae9 <__udivdi3+0x49>
  802ade:	b8 01 00 00 00       	mov    $0x1,%eax
  802ae3:	31 d2                	xor    %edx,%edx
  802ae5:	f7 f3                	div    %ebx
  802ae7:	89 c1                	mov    %eax,%ecx
  802ae9:	31 d2                	xor    %edx,%edx
  802aeb:	89 f0                	mov    %esi,%eax
  802aed:	f7 f1                	div    %ecx
  802aef:	89 c6                	mov    %eax,%esi
  802af1:	89 e8                	mov    %ebp,%eax
  802af3:	89 f7                	mov    %esi,%edi
  802af5:	f7 f1                	div    %ecx
  802af7:	89 fa                	mov    %edi,%edx
  802af9:	83 c4 1c             	add    $0x1c,%esp
  802afc:	5b                   	pop    %ebx
  802afd:	5e                   	pop    %esi
  802afe:	5f                   	pop    %edi
  802aff:	5d                   	pop    %ebp
  802b00:	c3                   	ret    
  802b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b08:	39 f2                	cmp    %esi,%edx
  802b0a:	77 1c                	ja     802b28 <__udivdi3+0x88>
  802b0c:	0f bd fa             	bsr    %edx,%edi
  802b0f:	83 f7 1f             	xor    $0x1f,%edi
  802b12:	75 2c                	jne    802b40 <__udivdi3+0xa0>
  802b14:	39 f2                	cmp    %esi,%edx
  802b16:	72 06                	jb     802b1e <__udivdi3+0x7e>
  802b18:	31 c0                	xor    %eax,%eax
  802b1a:	39 eb                	cmp    %ebp,%ebx
  802b1c:	77 a9                	ja     802ac7 <__udivdi3+0x27>
  802b1e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b23:	eb a2                	jmp    802ac7 <__udivdi3+0x27>
  802b25:	8d 76 00             	lea    0x0(%esi),%esi
  802b28:	31 ff                	xor    %edi,%edi
  802b2a:	31 c0                	xor    %eax,%eax
  802b2c:	89 fa                	mov    %edi,%edx
  802b2e:	83 c4 1c             	add    $0x1c,%esp
  802b31:	5b                   	pop    %ebx
  802b32:	5e                   	pop    %esi
  802b33:	5f                   	pop    %edi
  802b34:	5d                   	pop    %ebp
  802b35:	c3                   	ret    
  802b36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b3d:	8d 76 00             	lea    0x0(%esi),%esi
  802b40:	89 f9                	mov    %edi,%ecx
  802b42:	b8 20 00 00 00       	mov    $0x20,%eax
  802b47:	29 f8                	sub    %edi,%eax
  802b49:	d3 e2                	shl    %cl,%edx
  802b4b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802b4f:	89 c1                	mov    %eax,%ecx
  802b51:	89 da                	mov    %ebx,%edx
  802b53:	d3 ea                	shr    %cl,%edx
  802b55:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b59:	09 d1                	or     %edx,%ecx
  802b5b:	89 f2                	mov    %esi,%edx
  802b5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b61:	89 f9                	mov    %edi,%ecx
  802b63:	d3 e3                	shl    %cl,%ebx
  802b65:	89 c1                	mov    %eax,%ecx
  802b67:	d3 ea                	shr    %cl,%edx
  802b69:	89 f9                	mov    %edi,%ecx
  802b6b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802b6f:	89 eb                	mov    %ebp,%ebx
  802b71:	d3 e6                	shl    %cl,%esi
  802b73:	89 c1                	mov    %eax,%ecx
  802b75:	d3 eb                	shr    %cl,%ebx
  802b77:	09 de                	or     %ebx,%esi
  802b79:	89 f0                	mov    %esi,%eax
  802b7b:	f7 74 24 08          	divl   0x8(%esp)
  802b7f:	89 d6                	mov    %edx,%esi
  802b81:	89 c3                	mov    %eax,%ebx
  802b83:	f7 64 24 0c          	mull   0xc(%esp)
  802b87:	39 d6                	cmp    %edx,%esi
  802b89:	72 15                	jb     802ba0 <__udivdi3+0x100>
  802b8b:	89 f9                	mov    %edi,%ecx
  802b8d:	d3 e5                	shl    %cl,%ebp
  802b8f:	39 c5                	cmp    %eax,%ebp
  802b91:	73 04                	jae    802b97 <__udivdi3+0xf7>
  802b93:	39 d6                	cmp    %edx,%esi
  802b95:	74 09                	je     802ba0 <__udivdi3+0x100>
  802b97:	89 d8                	mov    %ebx,%eax
  802b99:	31 ff                	xor    %edi,%edi
  802b9b:	e9 27 ff ff ff       	jmp    802ac7 <__udivdi3+0x27>
  802ba0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802ba3:	31 ff                	xor    %edi,%edi
  802ba5:	e9 1d ff ff ff       	jmp    802ac7 <__udivdi3+0x27>
  802baa:	66 90                	xchg   %ax,%ax
  802bac:	66 90                	xchg   %ax,%ax
  802bae:	66 90                	xchg   %ax,%ax

00802bb0 <__umoddi3>:
  802bb0:	55                   	push   %ebp
  802bb1:	57                   	push   %edi
  802bb2:	56                   	push   %esi
  802bb3:	53                   	push   %ebx
  802bb4:	83 ec 1c             	sub    $0x1c,%esp
  802bb7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802bbb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802bbf:	8b 74 24 30          	mov    0x30(%esp),%esi
  802bc3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802bc7:	89 da                	mov    %ebx,%edx
  802bc9:	85 c0                	test   %eax,%eax
  802bcb:	75 43                	jne    802c10 <__umoddi3+0x60>
  802bcd:	39 df                	cmp    %ebx,%edi
  802bcf:	76 17                	jbe    802be8 <__umoddi3+0x38>
  802bd1:	89 f0                	mov    %esi,%eax
  802bd3:	f7 f7                	div    %edi
  802bd5:	89 d0                	mov    %edx,%eax
  802bd7:	31 d2                	xor    %edx,%edx
  802bd9:	83 c4 1c             	add    $0x1c,%esp
  802bdc:	5b                   	pop    %ebx
  802bdd:	5e                   	pop    %esi
  802bde:	5f                   	pop    %edi
  802bdf:	5d                   	pop    %ebp
  802be0:	c3                   	ret    
  802be1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802be8:	89 fd                	mov    %edi,%ebp
  802bea:	85 ff                	test   %edi,%edi
  802bec:	75 0b                	jne    802bf9 <__umoddi3+0x49>
  802bee:	b8 01 00 00 00       	mov    $0x1,%eax
  802bf3:	31 d2                	xor    %edx,%edx
  802bf5:	f7 f7                	div    %edi
  802bf7:	89 c5                	mov    %eax,%ebp
  802bf9:	89 d8                	mov    %ebx,%eax
  802bfb:	31 d2                	xor    %edx,%edx
  802bfd:	f7 f5                	div    %ebp
  802bff:	89 f0                	mov    %esi,%eax
  802c01:	f7 f5                	div    %ebp
  802c03:	89 d0                	mov    %edx,%eax
  802c05:	eb d0                	jmp    802bd7 <__umoddi3+0x27>
  802c07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c0e:	66 90                	xchg   %ax,%ax
  802c10:	89 f1                	mov    %esi,%ecx
  802c12:	39 d8                	cmp    %ebx,%eax
  802c14:	76 0a                	jbe    802c20 <__umoddi3+0x70>
  802c16:	89 f0                	mov    %esi,%eax
  802c18:	83 c4 1c             	add    $0x1c,%esp
  802c1b:	5b                   	pop    %ebx
  802c1c:	5e                   	pop    %esi
  802c1d:	5f                   	pop    %edi
  802c1e:	5d                   	pop    %ebp
  802c1f:	c3                   	ret    
  802c20:	0f bd e8             	bsr    %eax,%ebp
  802c23:	83 f5 1f             	xor    $0x1f,%ebp
  802c26:	75 20                	jne    802c48 <__umoddi3+0x98>
  802c28:	39 d8                	cmp    %ebx,%eax
  802c2a:	0f 82 b0 00 00 00    	jb     802ce0 <__umoddi3+0x130>
  802c30:	39 f7                	cmp    %esi,%edi
  802c32:	0f 86 a8 00 00 00    	jbe    802ce0 <__umoddi3+0x130>
  802c38:	89 c8                	mov    %ecx,%eax
  802c3a:	83 c4 1c             	add    $0x1c,%esp
  802c3d:	5b                   	pop    %ebx
  802c3e:	5e                   	pop    %esi
  802c3f:	5f                   	pop    %edi
  802c40:	5d                   	pop    %ebp
  802c41:	c3                   	ret    
  802c42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802c48:	89 e9                	mov    %ebp,%ecx
  802c4a:	ba 20 00 00 00       	mov    $0x20,%edx
  802c4f:	29 ea                	sub    %ebp,%edx
  802c51:	d3 e0                	shl    %cl,%eax
  802c53:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c57:	89 d1                	mov    %edx,%ecx
  802c59:	89 f8                	mov    %edi,%eax
  802c5b:	d3 e8                	shr    %cl,%eax
  802c5d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802c61:	89 54 24 04          	mov    %edx,0x4(%esp)
  802c65:	8b 54 24 04          	mov    0x4(%esp),%edx
  802c69:	09 c1                	or     %eax,%ecx
  802c6b:	89 d8                	mov    %ebx,%eax
  802c6d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c71:	89 e9                	mov    %ebp,%ecx
  802c73:	d3 e7                	shl    %cl,%edi
  802c75:	89 d1                	mov    %edx,%ecx
  802c77:	d3 e8                	shr    %cl,%eax
  802c79:	89 e9                	mov    %ebp,%ecx
  802c7b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c7f:	d3 e3                	shl    %cl,%ebx
  802c81:	89 c7                	mov    %eax,%edi
  802c83:	89 d1                	mov    %edx,%ecx
  802c85:	89 f0                	mov    %esi,%eax
  802c87:	d3 e8                	shr    %cl,%eax
  802c89:	89 e9                	mov    %ebp,%ecx
  802c8b:	89 fa                	mov    %edi,%edx
  802c8d:	d3 e6                	shl    %cl,%esi
  802c8f:	09 d8                	or     %ebx,%eax
  802c91:	f7 74 24 08          	divl   0x8(%esp)
  802c95:	89 d1                	mov    %edx,%ecx
  802c97:	89 f3                	mov    %esi,%ebx
  802c99:	f7 64 24 0c          	mull   0xc(%esp)
  802c9d:	89 c6                	mov    %eax,%esi
  802c9f:	89 d7                	mov    %edx,%edi
  802ca1:	39 d1                	cmp    %edx,%ecx
  802ca3:	72 06                	jb     802cab <__umoddi3+0xfb>
  802ca5:	75 10                	jne    802cb7 <__umoddi3+0x107>
  802ca7:	39 c3                	cmp    %eax,%ebx
  802ca9:	73 0c                	jae    802cb7 <__umoddi3+0x107>
  802cab:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802caf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802cb3:	89 d7                	mov    %edx,%edi
  802cb5:	89 c6                	mov    %eax,%esi
  802cb7:	89 ca                	mov    %ecx,%edx
  802cb9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802cbe:	29 f3                	sub    %esi,%ebx
  802cc0:	19 fa                	sbb    %edi,%edx
  802cc2:	89 d0                	mov    %edx,%eax
  802cc4:	d3 e0                	shl    %cl,%eax
  802cc6:	89 e9                	mov    %ebp,%ecx
  802cc8:	d3 eb                	shr    %cl,%ebx
  802cca:	d3 ea                	shr    %cl,%edx
  802ccc:	09 d8                	or     %ebx,%eax
  802cce:	83 c4 1c             	add    $0x1c,%esp
  802cd1:	5b                   	pop    %ebx
  802cd2:	5e                   	pop    %esi
  802cd3:	5f                   	pop    %edi
  802cd4:	5d                   	pop    %ebp
  802cd5:	c3                   	ret    
  802cd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802cdd:	8d 76 00             	lea    0x0(%esi),%esi
  802ce0:	89 da                	mov    %ebx,%edx
  802ce2:	29 fe                	sub    %edi,%esi
  802ce4:	19 c2                	sbb    %eax,%edx
  802ce6:	89 f1                	mov    %esi,%ecx
  802ce8:	89 c8                	mov    %ecx,%eax
  802cea:	e9 4b ff ff ff       	jmp    802c3a <__umoddi3+0x8a>
