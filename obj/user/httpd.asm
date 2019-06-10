
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
  80002c:	e8 df 07 00 00       	call   800810 <libmain>
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
  80003a:	68 7d 32 80 00       	push   $0x80327d
  80003f:	e8 cf 09 00 00       	call   800a13 <cprintf>
	exit();
  800044:	e8 a0 08 00 00       	call   8008e9 <exit>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <send_error>:
	return 0;
}

static int
send_error(struct http_request *req, int code)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	57                   	push   %edi
  800052:	56                   	push   %esi
  800053:	53                   	push   %ebx
  800054:	81 ec 0c 02 00 00    	sub    $0x20c,%esp
	char buf[512];
	int r;

	struct error_messages *e = errors;
  80005a:	b9 00 40 80 00       	mov    $0x804000,%ecx
	while (e->code != 0 && e->msg != 0) {
  80005f:	8b 19                	mov    (%ecx),%ebx
  800061:	85 db                	test   %ebx,%ebx
  800063:	74 54                	je     8000b9 <send_error+0x6b>
		if (e->code == code)
  800065:	83 79 04 00          	cmpl   $0x0,0x4(%ecx)
  800069:	74 09                	je     800074 <send_error+0x26>
  80006b:	39 d3                	cmp    %edx,%ebx
  80006d:	74 05                	je     800074 <send_error+0x26>
			break;
		e++;
  80006f:	83 c1 08             	add    $0x8,%ecx
  800072:	eb eb                	jmp    80005f <send_error+0x11>
  800074:	89 c6                	mov    %eax,%esi
	}

	if (e->code == 0)
		return -1;

	r = snprintf(buf, 512, "HTTP/" HTTP_VERSION" %d %s\r\n"
  800076:	8b 41 04             	mov    0x4(%ecx),%eax
  800079:	83 ec 04             	sub    $0x4,%esp
  80007c:	50                   	push   %eax
  80007d:	53                   	push   %ebx
  80007e:	50                   	push   %eax
  80007f:	53                   	push   %ebx
  800080:	68 cc 30 80 00       	push   $0x8030cc
  800085:	68 00 02 00 00       	push   $0x200
  80008a:	8d bd e8 fd ff ff    	lea    -0x218(%ebp),%edi
  800090:	57                   	push   %edi
  800091:	e8 89 10 00 00       	call   80111f <snprintf>
  800096:	89 c3                	mov    %eax,%ebx
			       "Content-type: text/html\r\n"
			       "\r\n"
			       "<html><body><p>%d - %s</p></body></html>\r\n",
			       e->code, e->msg, e->code, e->msg);

	if (write(req->sock, buf, r) != r)
  800098:	83 c4 1c             	add    $0x1c,%esp
  80009b:	50                   	push   %eax
  80009c:	57                   	push   %edi
  80009d:	ff 36                	pushl  (%esi)
  80009f:	e8 6a 1b 00 00       	call   801c0e <write>
  8000a4:	83 c4 10             	add    $0x10,%esp
  8000a7:	39 d8                	cmp    %ebx,%eax
  8000a9:	0f 95 c0             	setne  %al
  8000ac:	0f b6 c0             	movzbl %al,%eax
  8000af:	f7 d8                	neg    %eax
		return -1;

	return 0;
}
  8000b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000b4:	5b                   	pop    %ebx
  8000b5:	5e                   	pop    %esi
  8000b6:	5f                   	pop    %edi
  8000b7:	5d                   	pop    %ebp
  8000b8:	c3                   	ret    
		return -1;
  8000b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8000be:	eb f1                	jmp    8000b1 <send_error+0x63>

008000c0 <handle_client>:
	return r;
}

static void
handle_client(int sock)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	57                   	push   %edi
  8000c4:	56                   	push   %esi
  8000c5:	53                   	push   %ebx
  8000c6:	81 ec 40 09 00 00    	sub    $0x940,%esp
  8000cc:	89 c6                	mov    %eax,%esi
	struct http_request *req = &con_d;

	while (1)
	{
		// Receive message
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  8000ce:	68 00 02 00 00       	push   $0x200
  8000d3:	8d 85 dc fd ff ff    	lea    -0x224(%ebp),%eax
  8000d9:	50                   	push   %eax
  8000da:	56                   	push   %esi
  8000db:	e8 62 1a 00 00       	call   801b42 <read>
  8000e0:	83 c4 10             	add    $0x10,%esp
  8000e3:	85 c0                	test   %eax,%eax
  8000e5:	78 44                	js     80012b <handle_client+0x6b>
			panic("failed to read");

		memset(req, 0, sizeof(*req));
  8000e7:	83 ec 04             	sub    $0x4,%esp
  8000ea:	6a 0c                	push   $0xc
  8000ec:	6a 00                	push   $0x0
  8000ee:	8d 45 dc             	lea    -0x24(%ebp),%eax
  8000f1:	50                   	push   %eax
  8000f2:	e8 c1 11 00 00       	call   8012b8 <memset>

		req->sock = sock;
  8000f7:	89 75 dc             	mov    %esi,-0x24(%ebp)
	if (strncmp(request, "GET ", 4) != 0)
  8000fa:	83 c4 0c             	add    $0xc,%esp
  8000fd:	6a 04                	push   $0x4
  8000ff:	68 fc 2f 80 00       	push   $0x802ffc
  800104:	8d 85 dc fd ff ff    	lea    -0x224(%ebp),%eax
  80010a:	50                   	push   %eax
  80010b:	e8 33 11 00 00       	call   801243 <strncmp>
  800110:	83 c4 10             	add    $0x10,%esp
  800113:	85 c0                	test   %eax,%eax
  800115:	0f 85 16 03 00 00    	jne    800431 <handle_client+0x371>
	request += 4;
  80011b:	8d 9d e0 fd ff ff    	lea    -0x220(%ebp),%ebx
	while (*request && *request != ' ')
  800121:	f6 03 df             	testb  $0xdf,(%ebx)
  800124:	74 1c                	je     800142 <handle_client+0x82>
		request++;
  800126:	83 c3 01             	add    $0x1,%ebx
  800129:	eb f6                	jmp    800121 <handle_client+0x61>
			panic("failed to read");
  80012b:	83 ec 04             	sub    $0x4,%esp
  80012e:	68 e0 2f 80 00       	push   $0x802fe0
  800133:	68 22 01 00 00       	push   $0x122
  800138:	68 ef 2f 80 00       	push   $0x802fef
  80013d:	e8 db 07 00 00       	call   80091d <_panic>
	url_len = request - url;
  800142:	89 df                	mov    %ebx,%edi
  800144:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
  80014a:	29 c7                	sub    %eax,%edi
	req->url = malloc(url_len + 1);
  80014c:	83 ec 0c             	sub    $0xc,%esp
  80014f:	8d 47 01             	lea    0x1(%edi),%eax
  800152:	50                   	push   %eax
  800153:	e8 40 24 00 00       	call   802598 <malloc>
  800158:	89 45 e0             	mov    %eax,-0x20(%ebp)
	memmove(req->url, url, url_len);
  80015b:	83 c4 0c             	add    $0xc,%esp
  80015e:	57                   	push   %edi
  80015f:	8d 8d e0 fd ff ff    	lea    -0x220(%ebp),%ecx
  800165:	51                   	push   %ecx
  800166:	50                   	push   %eax
  800167:	e8 94 11 00 00       	call   801300 <memmove>
	req->url[url_len] = '\0';
  80016c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80016f:	c6 04 38 00          	movb   $0x0,(%eax,%edi,1)
	request++;
  800173:	83 c3 01             	add    $0x1,%ebx
  800176:	83 c4 10             	add    $0x10,%esp
  800179:	89 d8                	mov    %ebx,%eax
  80017b:	eb 03                	jmp    800180 <handle_client+0xc0>
		request++;
  80017d:	83 c0 01             	add    $0x1,%eax
	while (*request && *request != '\n')
  800180:	0f b6 10             	movzbl (%eax),%edx
  800183:	84 d2                	test   %dl,%dl
  800185:	74 05                	je     80018c <handle_client+0xcc>
  800187:	80 fa 0a             	cmp    $0xa,%dl
  80018a:	75 f1                	jne    80017d <handle_client+0xbd>
	version_len = request - version;
  80018c:	29 d8                	sub    %ebx,%eax
  80018e:	89 c7                	mov    %eax,%edi
	req->version = malloc(version_len + 1);
  800190:	83 ec 0c             	sub    $0xc,%esp
  800193:	8d 40 01             	lea    0x1(%eax),%eax
  800196:	50                   	push   %eax
  800197:	e8 fc 23 00 00       	call   802598 <malloc>
  80019c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	memmove(req->version, version, version_len);
  80019f:	83 c4 0c             	add    $0xc,%esp
  8001a2:	57                   	push   %edi
  8001a3:	53                   	push   %ebx
  8001a4:	50                   	push   %eax
  8001a5:	e8 56 11 00 00       	call   801300 <memmove>
	req->version[version_len] = '\0';
  8001aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ad:	c6 04 38 00          	movb   $0x0,(%eax,%edi,1)
	fd = open(req->url, O_RDONLY);
  8001b1:	83 c4 08             	add    $0x8,%esp
  8001b4:	6a 00                	push   $0x0
  8001b6:	ff 75 e0             	pushl  -0x20(%ebp)
  8001b9:	e8 22 1e 00 00       	call   801fe0 <open>
  8001be:	89 c7                	mov    %eax,%edi
	if(fd < 0){
  8001c0:	83 c4 10             	add    $0x10,%esp
  8001c3:	85 c0                	test   %eax,%eax
  8001c5:	78 49                	js     800210 <handle_client+0x150>
	if ((r = fstat(fd, &stat)) < 0)
  8001c7:	83 ec 08             	sub    $0x8,%esp
  8001ca:	8d 85 d4 f6 ff ff    	lea    -0x92c(%ebp),%eax
  8001d0:	50                   	push   %eax
  8001d1:	57                   	push   %edi
  8001d2:	e8 61 1b 00 00       	call   801d38 <fstat>
  8001d7:	83 c4 10             	add    $0x10,%esp
  8001da:	85 c0                	test   %eax,%eax
  8001dc:	78 3f                	js     80021d <handle_client+0x15d>
	if (stat.st_isdir) {
  8001de:	83 bd 58 f7 ff ff 00 	cmpl   $0x0,-0x8a8(%ebp)
  8001e5:	75 68                	jne    80024f <handle_client+0x18f>
	file_size = stat.st_size;
  8001e7:	8b 85 54 f7 ff ff    	mov    -0x8ac(%ebp),%eax
  8001ed:	89 85 c0 f6 ff ff    	mov    %eax,-0x940(%ebp)
	struct responce_header *h = headers;
  8001f3:	bb 10 40 80 00       	mov    $0x804010,%ebx
	while (h->code != 0 && h->header!= 0) {
  8001f8:	8b 03                	mov    (%ebx),%eax
  8001fa:	85 c0                	test   %eax,%eax
  8001fc:	74 1f                	je     80021d <handle_client+0x15d>
		if (h->code == code)
  8001fe:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
  800202:	74 5a                	je     80025e <handle_client+0x19e>
  800204:	3d c8 00 00 00       	cmp    $0xc8,%eax
  800209:	74 53                	je     80025e <handle_client+0x19e>
		h++;
  80020b:	83 c3 08             	add    $0x8,%ebx
  80020e:	eb e8                	jmp    8001f8 <handle_client+0x138>
		send_error(req, 404);
  800210:	ba 94 01 00 00       	mov    $0x194,%edx
  800215:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800218:	e8 31 fe ff ff       	call   80004e <send_error>
	close(fd);
  80021d:	83 ec 0c             	sub    $0xc,%esp
  800220:	57                   	push   %edi
  800221:	e8 de 17 00 00       	call   801a04 <close>
  800226:	83 c4 10             	add    $0x10,%esp
	free(req->url);
  800229:	83 ec 0c             	sub    $0xc,%esp
  80022c:	ff 75 e0             	pushl  -0x20(%ebp)
  80022f:	e8 b8 22 00 00       	call   8024ec <free>
	free(req->version);
  800234:	83 c4 04             	add    $0x4,%esp
  800237:	ff 75 e4             	pushl  -0x1c(%ebp)
  80023a:	e8 ad 22 00 00       	call   8024ec <free>

		// no keep alive
		break;
	}

	close(sock);
  80023f:	89 34 24             	mov    %esi,(%esp)
  800242:	e8 bd 17 00 00       	call   801a04 <close>
}
  800247:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80024a:	5b                   	pop    %ebx
  80024b:	5e                   	pop    %esi
  80024c:	5f                   	pop    %edi
  80024d:	5d                   	pop    %ebp
  80024e:	c3                   	ret    
    	send_error(req, 404);
  80024f:	ba 94 01 00 00       	mov    $0x194,%edx
  800254:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800257:	e8 f2 fd ff ff       	call   80004e <send_error>
  80025c:	eb bf                	jmp    80021d <handle_client+0x15d>
	int len = strlen(h->header);
  80025e:	83 ec 0c             	sub    $0xc,%esp
  800261:	ff 73 04             	pushl  0x4(%ebx)
  800264:	e8 d0 0e 00 00       	call   801139 <strlen>
	if (write(req->sock, h->header, len) != len) {
  800269:	83 c4 0c             	add    $0xc,%esp
  80026c:	89 85 c4 f6 ff ff    	mov    %eax,-0x93c(%ebp)
  800272:	50                   	push   %eax
  800273:	ff 73 04             	pushl  0x4(%ebx)
  800276:	ff 75 dc             	pushl  -0x24(%ebp)
  800279:	e8 90 19 00 00       	call   801c0e <write>
  80027e:	83 c4 10             	add    $0x10,%esp
  800281:	39 85 c4 f6 ff ff    	cmp    %eax,-0x93c(%ebp)
  800287:	0f 85 3d 01 00 00    	jne    8003ca <handle_client+0x30a>
	r = snprintf(buf, 64, "Content-Length: %ld\r\n", (long)size);
  80028d:	ff b5 c0 f6 ff ff    	pushl  -0x940(%ebp)
  800293:	68 7e 30 80 00       	push   $0x80307e
  800298:	6a 40                	push   $0x40
  80029a:	8d 85 ee f7 ff ff    	lea    -0x812(%ebp),%eax
  8002a0:	50                   	push   %eax
  8002a1:	e8 79 0e 00 00       	call   80111f <snprintf>
  8002a6:	89 c3                	mov    %eax,%ebx
	if (r > 63)
  8002a8:	83 c4 10             	add    $0x10,%esp
  8002ab:	83 f8 3f             	cmp    $0x3f,%eax
  8002ae:	0f 8f 25 01 00 00    	jg     8003d9 <handle_client+0x319>
	if (write(req->sock, buf, r) != r)
  8002b4:	83 ec 04             	sub    $0x4,%esp
  8002b7:	53                   	push   %ebx
  8002b8:	8d 85 ee f7 ff ff    	lea    -0x812(%ebp),%eax
  8002be:	50                   	push   %eax
  8002bf:	ff 75 dc             	pushl  -0x24(%ebp)
  8002c2:	e8 47 19 00 00       	call   801c0e <write>
	if ((r = send_size(req, file_size)) < 0)
  8002c7:	83 c4 10             	add    $0x10,%esp
  8002ca:	39 c3                	cmp    %eax,%ebx
  8002cc:	0f 85 4b ff ff ff    	jne    80021d <handle_client+0x15d>
	r = snprintf(buf, 128, "Content-Type: %s\r\n", type);
  8002d2:	68 13 30 80 00       	push   $0x803013
  8002d7:	68 1d 30 80 00       	push   $0x80301d
  8002dc:	68 80 00 00 00       	push   $0x80
  8002e1:	8d 85 ee f7 ff ff    	lea    -0x812(%ebp),%eax
  8002e7:	50                   	push   %eax
  8002e8:	e8 32 0e 00 00       	call   80111f <snprintf>
  8002ed:	89 c3                	mov    %eax,%ebx
	if (r > 127)
  8002ef:	83 c4 10             	add    $0x10,%esp
  8002f2:	83 f8 7f             	cmp    $0x7f,%eax
  8002f5:	0f 8f f2 00 00 00    	jg     8003ed <handle_client+0x32d>
	if (write(req->sock, buf, r) != r)
  8002fb:	83 ec 04             	sub    $0x4,%esp
  8002fe:	50                   	push   %eax
  8002ff:	8d 85 ee f7 ff ff    	lea    -0x812(%ebp),%eax
  800305:	50                   	push   %eax
  800306:	ff 75 dc             	pushl  -0x24(%ebp)
  800309:	e8 00 19 00 00       	call   801c0e <write>
	if ((r = send_content_type(req)) < 0)
  80030e:	83 c4 10             	add    $0x10,%esp
  800311:	39 c3                	cmp    %eax,%ebx
  800313:	0f 85 04 ff ff ff    	jne    80021d <handle_client+0x15d>
	int fin_len = strlen(fin);
  800319:	83 ec 0c             	sub    $0xc,%esp
  80031c:	68 91 30 80 00       	push   $0x803091
  800321:	e8 13 0e 00 00       	call   801139 <strlen>
  800326:	89 c3                	mov    %eax,%ebx
	if (write(req->sock, fin, fin_len) != fin_len)
  800328:	83 c4 0c             	add    $0xc,%esp
  80032b:	50                   	push   %eax
  80032c:	68 91 30 80 00       	push   $0x803091
  800331:	ff 75 dc             	pushl  -0x24(%ebp)
  800334:	e8 d5 18 00 00       	call   801c0e <write>
	if ((r = send_header_fin(req)) < 0)
  800339:	83 c4 10             	add    $0x10,%esp
  80033c:	39 c3                	cmp    %eax,%ebx
  80033e:	0f 85 d9 fe ff ff    	jne    80021d <handle_client+0x15d>
  	if ((r = fstat(fd, &stat)) < 0)
  800344:	83 ec 08             	sub    $0x8,%esp
  800347:	8d 85 60 f7 ff ff    	lea    -0x8a0(%ebp),%eax
  80034d:	50                   	push   %eax
  80034e:	57                   	push   %edi
  80034f:	e8 e4 19 00 00       	call   801d38 <fstat>
  800354:	83 c4 10             	add    $0x10,%esp
  800357:	85 c0                	test   %eax,%eax
  800359:	0f 88 a5 00 00 00    	js     800404 <handle_client+0x344>
  	if (stat.st_size > 1518)
  80035f:	81 bd e0 f7 ff ff ee 	cmpl   $0x5ee,-0x820(%ebp)
  800366:	05 00 00 
  800369:	0f 8f a4 00 00 00    	jg     800413 <handle_client+0x353>
  	if ((r = readn(fd, buf, stat.st_size)) != stat.st_size)
  80036f:	83 ec 04             	sub    $0x4,%esp
  800372:	ff b5 e0 f7 ff ff    	pushl  -0x820(%ebp)
  800378:	8d 85 ee f7 ff ff    	lea    -0x812(%ebp),%eax
  80037e:	50                   	push   %eax
  80037f:	57                   	push   %edi
  800380:	e8 44 18 00 00       	call   801bc9 <readn>
  800385:	83 c4 10             	add    $0x10,%esp
  800388:	3b 85 e0 f7 ff ff    	cmp    -0x820(%ebp),%eax
  80038e:	0f 85 8e 00 00 00    	jne    800422 <handle_client+0x362>
  	if ((r = write(req->sock, buf, stat.st_size)) != stat.st_size)
  800394:	83 ec 04             	sub    $0x4,%esp
  800397:	ff b5 e0 f7 ff ff    	pushl  -0x820(%ebp)
  80039d:	8d 85 ee f7 ff ff    	lea    -0x812(%ebp),%eax
  8003a3:	50                   	push   %eax
  8003a4:	ff 75 dc             	pushl  -0x24(%ebp)
  8003a7:	e8 62 18 00 00       	call   801c0e <write>
  8003ac:	83 c4 10             	add    $0x10,%esp
  8003af:	3b 85 e0 f7 ff ff    	cmp    -0x820(%ebp),%eax
  8003b5:	0f 84 62 fe ff ff    	je     80021d <handle_client+0x15d>
    	die("not write all data");
  8003bb:	b8 6b 30 80 00       	mov    $0x80306b,%eax
  8003c0:	e8 6e fc ff ff       	call   800033 <die>
  8003c5:	e9 53 fe ff ff       	jmp    80021d <handle_client+0x15d>
		die("Failed to send bytes to client");
  8003ca:	b8 48 31 80 00       	mov    $0x803148,%eax
  8003cf:	e8 5f fc ff ff       	call   800033 <die>
  8003d4:	e9 b4 fe ff ff       	jmp    80028d <handle_client+0x1cd>
		panic("buffer too small!");
  8003d9:	83 ec 04             	sub    $0x4,%esp
  8003dc:	68 01 30 80 00       	push   $0x803001
  8003e1:	6a 67                	push   $0x67
  8003e3:	68 ef 2f 80 00       	push   $0x802fef
  8003e8:	e8 30 05 00 00       	call   80091d <_panic>
		panic("buffer too small!");
  8003ed:	83 ec 04             	sub    $0x4,%esp
  8003f0:	68 01 30 80 00       	push   $0x803001
  8003f5:	68 83 00 00 00       	push   $0x83
  8003fa:	68 ef 2f 80 00       	push   $0x802fef
  8003ff:	e8 19 05 00 00       	call   80091d <_panic>
  		die("fstat panic");
  800404:	b8 30 30 80 00       	mov    $0x803030,%eax
  800409:	e8 25 fc ff ff       	call   800033 <die>
  80040e:	e9 4c ff ff ff       	jmp    80035f <handle_client+0x29f>
    	die("fd's file size > 1518");
  800413:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  800418:	e8 16 fc ff ff       	call   800033 <die>
  80041d:	e9 4d ff ff ff       	jmp    80036f <handle_client+0x2af>
    	die("just read partitial data");
  800422:	b8 52 30 80 00       	mov    $0x803052,%eax
  800427:	e8 07 fc ff ff       	call   800033 <die>
  80042c:	e9 63 ff ff ff       	jmp    800394 <handle_client+0x2d4>
			send_error(req, 400);
  800431:	ba 90 01 00 00       	mov    $0x190,%edx
  800436:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800439:	e8 10 fc ff ff       	call   80004e <send_error>
  80043e:	e9 e6 fd ff ff       	jmp    800229 <handle_client+0x169>

00800443 <umain>:

void
umain(int argc, char **argv)
{
  800443:	55                   	push   %ebp
  800444:	89 e5                	mov    %esp,%ebp
  800446:	57                   	push   %edi
  800447:	56                   	push   %esi
  800448:	53                   	push   %ebx
  800449:	83 ec 40             	sub    $0x40,%esp
	int serversock, clientsock;
	struct sockaddr_in server, client;

	binaryname = "jhttpd";
  80044c:	c7 05 20 40 80 00 94 	movl   $0x803094,0x804020
  800453:	30 80 00 

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  800456:	6a 06                	push   $0x6
  800458:	6a 01                	push   $0x1
  80045a:	6a 02                	push   $0x2
  80045c:	e8 0f 1e 00 00       	call   802270 <socket>
  800461:	89 c6                	mov    %eax,%esi
  800463:	83 c4 10             	add    $0x10,%esp
  800466:	85 c0                	test   %eax,%eax
  800468:	78 6d                	js     8004d7 <umain+0x94>
		die("Failed to create socket");

	// Construct the server sockaddr_in structure
	memset(&server, 0, sizeof(server));		// Clear struct
  80046a:	83 ec 04             	sub    $0x4,%esp
  80046d:	6a 10                	push   $0x10
  80046f:	6a 00                	push   $0x0
  800471:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  800474:	53                   	push   %ebx
  800475:	e8 3e 0e 00 00       	call   8012b8 <memset>
	server.sin_family = AF_INET;			// Internet/IP
  80047a:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	server.sin_addr.s_addr = htonl(INADDR_ANY);	// IP address
  80047e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800485:	e8 5c 01 00 00       	call   8005e6 <htonl>
  80048a:	89 45 dc             	mov    %eax,-0x24(%ebp)
	server.sin_port = htons(PORT);			// server port
  80048d:	c7 04 24 50 00 00 00 	movl   $0x50,(%esp)
  800494:	e8 33 01 00 00       	call   8005cc <htons>
  800499:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &server,
  80049d:	83 c4 0c             	add    $0xc,%esp
  8004a0:	6a 10                	push   $0x10
  8004a2:	53                   	push   %ebx
  8004a3:	56                   	push   %esi
  8004a4:	e8 35 1d 00 00       	call   8021de <bind>
  8004a9:	83 c4 10             	add    $0x10,%esp
  8004ac:	85 c0                	test   %eax,%eax
  8004ae:	78 33                	js     8004e3 <umain+0xa0>
	{
		die("Failed to bind the server socket");
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  8004b0:	83 ec 08             	sub    $0x8,%esp
  8004b3:	6a 05                	push   $0x5
  8004b5:	56                   	push   %esi
  8004b6:	e8 92 1d 00 00       	call   80224d <listen>
  8004bb:	83 c4 10             	add    $0x10,%esp
  8004be:	85 c0                	test   %eax,%eax
  8004c0:	78 2d                	js     8004ef <umain+0xac>
		die("Failed to listen on server socket");

	cprintf("Waiting for http connections...\n");
  8004c2:	83 ec 0c             	sub    $0xc,%esp
  8004c5:	68 b0 31 80 00       	push   $0x8031b0
  8004ca:	e8 44 05 00 00       	call   800a13 <cprintf>
  8004cf:	83 c4 10             	add    $0x10,%esp

	while (1) {
		unsigned int clientlen = sizeof(client);
		// Wait for client connection
		if ((clientsock = accept(serversock,
  8004d2:	8d 7d c4             	lea    -0x3c(%ebp),%edi
  8004d5:	eb 35                	jmp    80050c <umain+0xc9>
		die("Failed to create socket");
  8004d7:	b8 9b 30 80 00       	mov    $0x80309b,%eax
  8004dc:	e8 52 fb ff ff       	call   800033 <die>
  8004e1:	eb 87                	jmp    80046a <umain+0x27>
		die("Failed to bind the server socket");
  8004e3:	b8 68 31 80 00       	mov    $0x803168,%eax
  8004e8:	e8 46 fb ff ff       	call   800033 <die>
  8004ed:	eb c1                	jmp    8004b0 <umain+0x6d>
		die("Failed to listen on server socket");
  8004ef:	b8 8c 31 80 00       	mov    $0x80318c,%eax
  8004f4:	e8 3a fb ff ff       	call   800033 <die>
  8004f9:	eb c7                	jmp    8004c2 <umain+0x7f>
					 (struct sockaddr *) &client,
					 &clientlen)) < 0)
		{
			die("Failed to accept client connection");
  8004fb:	b8 d4 31 80 00       	mov    $0x8031d4,%eax
  800500:	e8 2e fb ff ff       	call   800033 <die>
		}
		handle_client(clientsock);
  800505:	89 d8                	mov    %ebx,%eax
  800507:	e8 b4 fb ff ff       	call   8000c0 <handle_client>
		unsigned int clientlen = sizeof(client);
  80050c:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
		if ((clientsock = accept(serversock,
  800513:	83 ec 04             	sub    $0x4,%esp
  800516:	57                   	push   %edi
  800517:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80051a:	50                   	push   %eax
  80051b:	56                   	push   %esi
  80051c:	e8 8e 1c 00 00       	call   8021af <accept>
  800521:	89 c3                	mov    %eax,%ebx
  800523:	83 c4 10             	add    $0x10,%esp
  800526:	85 c0                	test   %eax,%eax
  800528:	78 d1                	js     8004fb <umain+0xb8>
  80052a:	eb d9                	jmp    800505 <umain+0xc2>

0080052c <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  80052c:	55                   	push   %ebp
  80052d:	89 e5                	mov    %esp,%ebp
  80052f:	57                   	push   %edi
  800530:	56                   	push   %esi
  800531:	53                   	push   %ebx
  800532:	83 ec 18             	sub    $0x18,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  800535:	8b 45 08             	mov    0x8(%ebp),%eax
  800538:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  80053b:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  ap = (u8_t *)&s_addr;
  80053f:	8d 75 f0             	lea    -0x10(%ebp),%esi
  rp = str;
  800542:	bf 00 50 80 00       	mov    $0x805000,%edi
  800547:	eb 1a                	jmp    800563 <inet_ntoa+0x37>
  800549:	0f b6 db             	movzbl %bl,%ebx
  80054c:	01 fb                	add    %edi,%ebx
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  80054e:	8d 7b 01             	lea    0x1(%ebx),%edi
  800551:	c6 03 2e             	movb   $0x2e,(%ebx)
  800554:	83 c6 01             	add    $0x1,%esi
  for(n = 0; n < 4; n++) {
  800557:	80 45 df 01          	addb   $0x1,-0x21(%ebp)
  80055b:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  80055f:	3c 04                	cmp    $0x4,%al
  800561:	74 59                	je     8005bc <inet_ntoa+0x90>
  rp = str;
  800563:	ba 00 00 00 00       	mov    $0x0,%edx
      rem = *ap % (u8_t)10;
  800568:	0f b6 0e             	movzbl (%esi),%ecx
      *ap /= (u8_t)10;
  80056b:	0f b6 d9             	movzbl %cl,%ebx
  80056e:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
  800571:	8d 04 c3             	lea    (%ebx,%eax,8),%eax
  800574:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800577:	66 c1 e8 0b          	shr    $0xb,%ax
  80057b:	88 06                	mov    %al,(%esi)
      inv[i++] = '0' + rem;
  80057d:	8d 5a 01             	lea    0x1(%edx),%ebx
  800580:	0f b6 d2             	movzbl %dl,%edx
  800583:	89 55 e0             	mov    %edx,-0x20(%ebp)
      rem = *ap % (u8_t)10;
  800586:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800589:	01 c0                	add    %eax,%eax
  80058b:	89 ca                	mov    %ecx,%edx
  80058d:	29 c2                	sub    %eax,%edx
  80058f:	89 d0                	mov    %edx,%eax
      inv[i++] = '0' + rem;
  800591:	83 c0 30             	add    $0x30,%eax
  800594:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800597:	88 44 15 ed          	mov    %al,-0x13(%ebp,%edx,1)
  80059b:	89 da                	mov    %ebx,%edx
    } while(*ap);
  80059d:	80 f9 09             	cmp    $0x9,%cl
  8005a0:	77 c6                	ja     800568 <inet_ntoa+0x3c>
  8005a2:	89 fa                	mov    %edi,%edx
      inv[i++] = '0' + rem;
  8005a4:	89 d8                	mov    %ebx,%eax
    while(i--)
  8005a6:	83 e8 01             	sub    $0x1,%eax
  8005a9:	3c ff                	cmp    $0xff,%al
  8005ab:	74 9c                	je     800549 <inet_ntoa+0x1d>
      *rp++ = inv[i];
  8005ad:	0f b6 c8             	movzbl %al,%ecx
  8005b0:	0f b6 4c 0d ed       	movzbl -0x13(%ebp,%ecx,1),%ecx
  8005b5:	88 0a                	mov    %cl,(%edx)
  8005b7:	83 c2 01             	add    $0x1,%edx
  8005ba:	eb ea                	jmp    8005a6 <inet_ntoa+0x7a>
    ap++;
  }
  *--rp = 0;
  8005bc:	c6 03 00             	movb   $0x0,(%ebx)
  return str;
}
  8005bf:	b8 00 50 80 00       	mov    $0x805000,%eax
  8005c4:	83 c4 18             	add    $0x18,%esp
  8005c7:	5b                   	pop    %ebx
  8005c8:	5e                   	pop    %esi
  8005c9:	5f                   	pop    %edi
  8005ca:	5d                   	pop    %ebp
  8005cb:	c3                   	ret    

008005cc <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  8005cc:	55                   	push   %ebp
  8005cd:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8005cf:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8005d3:	66 c1 c0 08          	rol    $0x8,%ax
}
  8005d7:	5d                   	pop    %ebp
  8005d8:	c3                   	ret    

008005d9 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  8005d9:	55                   	push   %ebp
  8005da:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8005dc:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8005e0:	66 c1 c0 08          	rol    $0x8,%ax
  return htons(n);
}
  8005e4:	5d                   	pop    %ebp
  8005e5:	c3                   	ret    

008005e6 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8005e6:	55                   	push   %ebp
  8005e7:	89 e5                	mov    %esp,%ebp
  8005e9:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
  8005ec:	89 d0                	mov    %edx,%eax
  8005ee:	c1 e0 18             	shl    $0x18,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  8005f1:	89 d1                	mov    %edx,%ecx
  8005f3:	c1 e9 18             	shr    $0x18,%ecx
    ((n & 0xff0000UL) >> 8) |
  8005f6:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  8005f8:	89 d1                	mov    %edx,%ecx
  8005fa:	c1 e1 08             	shl    $0x8,%ecx
  8005fd:	81 e1 00 00 ff 00    	and    $0xff0000,%ecx
    ((n & 0xff0000UL) >> 8) |
  800603:	09 c8                	or     %ecx,%eax
  800605:	c1 ea 08             	shr    $0x8,%edx
  800608:	81 e2 00 ff 00 00    	and    $0xff00,%edx
  80060e:	09 d0                	or     %edx,%eax
}
  800610:	5d                   	pop    %ebp
  800611:	c3                   	ret    

00800612 <inet_aton>:
{
  800612:	55                   	push   %ebp
  800613:	89 e5                	mov    %esp,%ebp
  800615:	57                   	push   %edi
  800616:	56                   	push   %esi
  800617:	53                   	push   %ebx
  800618:	83 ec 2c             	sub    $0x2c,%esp
  80061b:	8b 45 08             	mov    0x8(%ebp),%eax
  c = *cp;
  80061e:	0f be 10             	movsbl (%eax),%edx
  u32_t *pp = parts;
  800621:	8d 75 d8             	lea    -0x28(%ebp),%esi
  800624:	89 75 cc             	mov    %esi,-0x34(%ebp)
  800627:	e9 a7 00 00 00       	jmp    8006d3 <inet_aton+0xc1>
      c = *++cp;
  80062c:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      if (c == 'x' || c == 'X') {
  800630:	89 d1                	mov    %edx,%ecx
  800632:	83 e1 df             	and    $0xffffffdf,%ecx
  800635:	80 f9 58             	cmp    $0x58,%cl
  800638:	74 10                	je     80064a <inet_aton+0x38>
      c = *++cp;
  80063a:	83 c0 01             	add    $0x1,%eax
  80063d:	0f be d2             	movsbl %dl,%edx
        base = 8;
  800640:	be 08 00 00 00       	mov    $0x8,%esi
  800645:	e9 a3 00 00 00       	jmp    8006ed <inet_aton+0xdb>
        c = *++cp;
  80064a:	0f be 50 02          	movsbl 0x2(%eax),%edx
  80064e:	8d 40 02             	lea    0x2(%eax),%eax
        base = 16;
  800651:	be 10 00 00 00       	mov    $0x10,%esi
  800656:	e9 92 00 00 00       	jmp    8006ed <inet_aton+0xdb>
      } else if (base == 16 && isxdigit(c)) {
  80065b:	83 fe 10             	cmp    $0x10,%esi
  80065e:	75 4d                	jne    8006ad <inet_aton+0x9b>
  800660:	8d 4f 9f             	lea    -0x61(%edi),%ecx
  800663:	88 4d d3             	mov    %cl,-0x2d(%ebp)
  800666:	89 d1                	mov    %edx,%ecx
  800668:	83 e1 df             	and    $0xffffffdf,%ecx
  80066b:	83 e9 41             	sub    $0x41,%ecx
  80066e:	80 f9 05             	cmp    $0x5,%cl
  800671:	77 3a                	ja     8006ad <inet_aton+0x9b>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  800673:	c1 e3 04             	shl    $0x4,%ebx
  800676:	83 c2 0a             	add    $0xa,%edx
  800679:	80 7d d3 1a          	cmpb   $0x1a,-0x2d(%ebp)
  80067d:	19 c9                	sbb    %ecx,%ecx
  80067f:	83 e1 20             	and    $0x20,%ecx
  800682:	83 c1 41             	add    $0x41,%ecx
  800685:	29 ca                	sub    %ecx,%edx
  800687:	09 d3                	or     %edx,%ebx
        c = *++cp;
  800689:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80068c:	0f be 57 01          	movsbl 0x1(%edi),%edx
  800690:	83 c0 01             	add    $0x1,%eax
  800693:	89 45 d4             	mov    %eax,-0x2c(%ebp)
      if (isdigit(c)) {
  800696:	89 d7                	mov    %edx,%edi
  800698:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80069b:	80 f9 09             	cmp    $0x9,%cl
  80069e:	77 bb                	ja     80065b <inet_aton+0x49>
        val = (val * base) + (int)(c - '0');
  8006a0:	0f af de             	imul   %esi,%ebx
  8006a3:	8d 5c 1a d0          	lea    -0x30(%edx,%ebx,1),%ebx
        c = *++cp;
  8006a7:	0f be 50 01          	movsbl 0x1(%eax),%edx
  8006ab:	eb e3                	jmp    800690 <inet_aton+0x7e>
    if (c == '.') {
  8006ad:	83 fa 2e             	cmp    $0x2e,%edx
  8006b0:	75 42                	jne    8006f4 <inet_aton+0xe2>
      if (pp >= parts + 3)
  8006b2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8006b5:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8006b8:	39 c6                	cmp    %eax,%esi
  8006ba:	0f 84 0e 01 00 00    	je     8007ce <inet_aton+0x1bc>
      *pp++ = val;
  8006c0:	83 c6 04             	add    $0x4,%esi
  8006c3:	89 75 cc             	mov    %esi,-0x34(%ebp)
  8006c6:	89 5e fc             	mov    %ebx,-0x4(%esi)
      c = *++cp;
  8006c9:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  8006cc:	8d 46 01             	lea    0x1(%esi),%eax
  8006cf:	0f be 56 01          	movsbl 0x1(%esi),%edx
    if (!isdigit(c))
  8006d3:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8006d6:	80 f9 09             	cmp    $0x9,%cl
  8006d9:	0f 87 e8 00 00 00    	ja     8007c7 <inet_aton+0x1b5>
    base = 10;
  8006df:	be 0a 00 00 00       	mov    $0xa,%esi
    if (c == '0') {
  8006e4:	83 fa 30             	cmp    $0x30,%edx
  8006e7:	0f 84 3f ff ff ff    	je     80062c <inet_aton+0x1a>
    base = 10;
  8006ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006f2:	eb 9f                	jmp    800693 <inet_aton+0x81>
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8006f4:	85 d2                	test   %edx,%edx
  8006f6:	74 26                	je     80071e <inet_aton+0x10c>
    return (0);
  8006f8:	b8 00 00 00 00       	mov    $0x0,%eax
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8006fd:	89 f9                	mov    %edi,%ecx
  8006ff:	80 f9 1f             	cmp    $0x1f,%cl
  800702:	0f 86 cb 00 00 00    	jbe    8007d3 <inet_aton+0x1c1>
  800708:	84 d2                	test   %dl,%dl
  80070a:	0f 88 c3 00 00 00    	js     8007d3 <inet_aton+0x1c1>
  800710:	83 fa 20             	cmp    $0x20,%edx
  800713:	74 09                	je     80071e <inet_aton+0x10c>
  800715:	83 fa 0c             	cmp    $0xc,%edx
  800718:	0f 85 b5 00 00 00    	jne    8007d3 <inet_aton+0x1c1>
  n = pp - parts + 1;
  80071e:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800721:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800724:	29 c6                	sub    %eax,%esi
  800726:	89 f0                	mov    %esi,%eax
  800728:	c1 f8 02             	sar    $0x2,%eax
  80072b:	83 c0 01             	add    $0x1,%eax
  switch (n) {
  80072e:	83 f8 02             	cmp    $0x2,%eax
  800731:	74 5e                	je     800791 <inet_aton+0x17f>
  800733:	7e 35                	jle    80076a <inet_aton+0x158>
  800735:	83 f8 03             	cmp    $0x3,%eax
  800738:	74 6e                	je     8007a8 <inet_aton+0x196>
  80073a:	83 f8 04             	cmp    $0x4,%eax
  80073d:	75 2f                	jne    80076e <inet_aton+0x15c>
      return (0);
  80073f:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xff)
  800744:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
  80074a:	0f 87 83 00 00 00    	ja     8007d3 <inet_aton+0x1c1>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  800750:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800753:	c1 e0 18             	shl    $0x18,%eax
  800756:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800759:	c1 e2 10             	shl    $0x10,%edx
  80075c:	09 d0                	or     %edx,%eax
  80075e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800761:	c1 e2 08             	shl    $0x8,%edx
  800764:	09 d0                	or     %edx,%eax
  800766:	09 c3                	or     %eax,%ebx
    break;
  800768:	eb 04                	jmp    80076e <inet_aton+0x15c>
  switch (n) {
  80076a:	85 c0                	test   %eax,%eax
  80076c:	74 65                	je     8007d3 <inet_aton+0x1c1>
  return (1);
  80076e:	b8 01 00 00 00       	mov    $0x1,%eax
  if (addr)
  800773:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800777:	74 5a                	je     8007d3 <inet_aton+0x1c1>
    addr->s_addr = htonl(val);
  800779:	83 ec 0c             	sub    $0xc,%esp
  80077c:	53                   	push   %ebx
  80077d:	e8 64 fe ff ff       	call   8005e6 <htonl>
  800782:	83 c4 10             	add    $0x10,%esp
  800785:	8b 75 0c             	mov    0xc(%ebp),%esi
  800788:	89 06                	mov    %eax,(%esi)
  return (1);
  80078a:	b8 01 00 00 00       	mov    $0x1,%eax
  80078f:	eb 42                	jmp    8007d3 <inet_aton+0x1c1>
      return (0);
  800791:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffffffUL)
  800796:	81 fb ff ff ff 00    	cmp    $0xffffff,%ebx
  80079c:	77 35                	ja     8007d3 <inet_aton+0x1c1>
    val |= parts[0] << 24;
  80079e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007a1:	c1 e0 18             	shl    $0x18,%eax
  8007a4:	09 c3                	or     %eax,%ebx
    break;
  8007a6:	eb c6                	jmp    80076e <inet_aton+0x15c>
      return (0);
  8007a8:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffff)
  8007ad:	81 fb ff ff 00 00    	cmp    $0xffff,%ebx
  8007b3:	77 1e                	ja     8007d3 <inet_aton+0x1c1>
    val |= (parts[0] << 24) | (parts[1] << 16);
  8007b5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007b8:	c1 e0 18             	shl    $0x18,%eax
  8007bb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8007be:	c1 e2 10             	shl    $0x10,%edx
  8007c1:	09 d0                	or     %edx,%eax
  8007c3:	09 c3                	or     %eax,%ebx
    break;
  8007c5:	eb a7                	jmp    80076e <inet_aton+0x15c>
      return (0);
  8007c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8007cc:	eb 05                	jmp    8007d3 <inet_aton+0x1c1>
        return (0);
  8007ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007d6:	5b                   	pop    %ebx
  8007d7:	5e                   	pop    %esi
  8007d8:	5f                   	pop    %edi
  8007d9:	5d                   	pop    %ebp
  8007da:	c3                   	ret    

008007db <inet_addr>:
{
  8007db:	55                   	push   %ebp
  8007dc:	89 e5                	mov    %esp,%ebp
  8007de:	83 ec 20             	sub    $0x20,%esp
  if (inet_aton(cp, &val)) {
  8007e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007e4:	50                   	push   %eax
  8007e5:	ff 75 08             	pushl  0x8(%ebp)
  8007e8:	e8 25 fe ff ff       	call   800612 <inet_aton>
  8007ed:	83 c4 10             	add    $0x10,%esp
    return (val.s_addr);
  8007f0:	85 c0                	test   %eax,%eax
  8007f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8007f7:	0f 45 45 f4          	cmovne -0xc(%ebp),%eax
}
  8007fb:	c9                   	leave  
  8007fc:	c3                   	ret    

008007fd <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  8007fd:	55                   	push   %ebp
  8007fe:	89 e5                	mov    %esp,%ebp
  800800:	83 ec 14             	sub    $0x14,%esp
  return htonl(n);
  800803:	ff 75 08             	pushl  0x8(%ebp)
  800806:	e8 db fd ff ff       	call   8005e6 <htonl>
  80080b:	83 c4 10             	add    $0x10,%esp
}
  80080e:	c9                   	leave  
  80080f:	c3                   	ret    

00800810 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800810:	55                   	push   %ebp
  800811:	89 e5                	mov    %esp,%ebp
  800813:	57                   	push   %edi
  800814:	56                   	push   %esi
  800815:	53                   	push   %ebx
  800816:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  800819:	c7 05 1c 50 80 00 00 	movl   $0x0,0x80501c
  800820:	00 00 00 
	envid_t find = sys_getenvid();
  800823:	e8 fe 0c 00 00       	call   801526 <sys_getenvid>
  800828:	8b 1d 1c 50 80 00    	mov    0x80501c,%ebx
  80082e:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800833:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  800838:	bf 01 00 00 00       	mov    $0x1,%edi
  80083d:	eb 0b                	jmp    80084a <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  80083f:	83 c2 01             	add    $0x1,%edx
  800842:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800848:	74 21                	je     80086b <libmain+0x5b>
		if(envs[i].env_id == find)
  80084a:	89 d1                	mov    %edx,%ecx
  80084c:	c1 e1 07             	shl    $0x7,%ecx
  80084f:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800855:	8b 49 48             	mov    0x48(%ecx),%ecx
  800858:	39 c1                	cmp    %eax,%ecx
  80085a:	75 e3                	jne    80083f <libmain+0x2f>
  80085c:	89 d3                	mov    %edx,%ebx
  80085e:	c1 e3 07             	shl    $0x7,%ebx
  800861:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800867:	89 fe                	mov    %edi,%esi
  800869:	eb d4                	jmp    80083f <libmain+0x2f>
  80086b:	89 f0                	mov    %esi,%eax
  80086d:	84 c0                	test   %al,%al
  80086f:	74 06                	je     800877 <libmain+0x67>
  800871:	89 1d 1c 50 80 00    	mov    %ebx,0x80501c
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800877:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80087b:	7e 0a                	jle    800887 <libmain+0x77>
		binaryname = argv[0];
  80087d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800880:	8b 00                	mov    (%eax),%eax
  800882:	a3 20 40 80 00       	mov    %eax,0x804020

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  800887:	a1 1c 50 80 00       	mov    0x80501c,%eax
  80088c:	8b 40 48             	mov    0x48(%eax),%eax
  80088f:	83 ec 08             	sub    $0x8,%esp
  800892:	50                   	push   %eax
  800893:	68 1e 32 80 00       	push   $0x80321e
  800898:	e8 76 01 00 00       	call   800a13 <cprintf>
	cprintf("before umain\n");
  80089d:	c7 04 24 3c 32 80 00 	movl   $0x80323c,(%esp)
  8008a4:	e8 6a 01 00 00       	call   800a13 <cprintf>
	// call user main routine
	umain(argc, argv);
  8008a9:	83 c4 08             	add    $0x8,%esp
  8008ac:	ff 75 0c             	pushl  0xc(%ebp)
  8008af:	ff 75 08             	pushl  0x8(%ebp)
  8008b2:	e8 8c fb ff ff       	call   800443 <umain>
	cprintf("after umain\n");
  8008b7:	c7 04 24 4a 32 80 00 	movl   $0x80324a,(%esp)
  8008be:	e8 50 01 00 00       	call   800a13 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8008c3:	a1 1c 50 80 00       	mov    0x80501c,%eax
  8008c8:	8b 40 48             	mov    0x48(%eax),%eax
  8008cb:	83 c4 08             	add    $0x8,%esp
  8008ce:	50                   	push   %eax
  8008cf:	68 57 32 80 00       	push   $0x803257
  8008d4:	e8 3a 01 00 00       	call   800a13 <cprintf>
	// exit gracefully
	exit();
  8008d9:	e8 0b 00 00 00       	call   8008e9 <exit>
}
  8008de:	83 c4 10             	add    $0x10,%esp
  8008e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008e4:	5b                   	pop    %ebx
  8008e5:	5e                   	pop    %esi
  8008e6:	5f                   	pop    %edi
  8008e7:	5d                   	pop    %ebp
  8008e8:	c3                   	ret    

008008e9 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8008e9:	55                   	push   %ebp
  8008ea:	89 e5                	mov    %esp,%ebp
  8008ec:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8008ef:	a1 1c 50 80 00       	mov    0x80501c,%eax
  8008f4:	8b 40 48             	mov    0x48(%eax),%eax
  8008f7:	68 84 32 80 00       	push   $0x803284
  8008fc:	50                   	push   %eax
  8008fd:	68 76 32 80 00       	push   $0x803276
  800902:	e8 0c 01 00 00       	call   800a13 <cprintf>
	close_all();
  800907:	e8 25 11 00 00       	call   801a31 <close_all>
	sys_env_destroy(0);
  80090c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800913:	e8 cd 0b 00 00       	call   8014e5 <sys_env_destroy>
}
  800918:	83 c4 10             	add    $0x10,%esp
  80091b:	c9                   	leave  
  80091c:	c3                   	ret    

0080091d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80091d:	55                   	push   %ebp
  80091e:	89 e5                	mov    %esp,%ebp
  800920:	56                   	push   %esi
  800921:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800922:	a1 1c 50 80 00       	mov    0x80501c,%eax
  800927:	8b 40 48             	mov    0x48(%eax),%eax
  80092a:	83 ec 04             	sub    $0x4,%esp
  80092d:	68 b0 32 80 00       	push   $0x8032b0
  800932:	50                   	push   %eax
  800933:	68 76 32 80 00       	push   $0x803276
  800938:	e8 d6 00 00 00       	call   800a13 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80093d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800940:	8b 35 20 40 80 00    	mov    0x804020,%esi
  800946:	e8 db 0b 00 00       	call   801526 <sys_getenvid>
  80094b:	83 c4 04             	add    $0x4,%esp
  80094e:	ff 75 0c             	pushl  0xc(%ebp)
  800951:	ff 75 08             	pushl  0x8(%ebp)
  800954:	56                   	push   %esi
  800955:	50                   	push   %eax
  800956:	68 8c 32 80 00       	push   $0x80328c
  80095b:	e8 b3 00 00 00       	call   800a13 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800960:	83 c4 18             	add    $0x18,%esp
  800963:	53                   	push   %ebx
  800964:	ff 75 10             	pushl  0x10(%ebp)
  800967:	e8 56 00 00 00       	call   8009c2 <vcprintf>
	cprintf("\n");
  80096c:	c7 04 24 92 30 80 00 	movl   $0x803092,(%esp)
  800973:	e8 9b 00 00 00       	call   800a13 <cprintf>
  800978:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80097b:	cc                   	int3   
  80097c:	eb fd                	jmp    80097b <_panic+0x5e>

0080097e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	53                   	push   %ebx
  800982:	83 ec 04             	sub    $0x4,%esp
  800985:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800988:	8b 13                	mov    (%ebx),%edx
  80098a:	8d 42 01             	lea    0x1(%edx),%eax
  80098d:	89 03                	mov    %eax,(%ebx)
  80098f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800992:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800996:	3d ff 00 00 00       	cmp    $0xff,%eax
  80099b:	74 09                	je     8009a6 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80099d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8009a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009a4:	c9                   	leave  
  8009a5:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8009a6:	83 ec 08             	sub    $0x8,%esp
  8009a9:	68 ff 00 00 00       	push   $0xff
  8009ae:	8d 43 08             	lea    0x8(%ebx),%eax
  8009b1:	50                   	push   %eax
  8009b2:	e8 f1 0a 00 00       	call   8014a8 <sys_cputs>
		b->idx = 0;
  8009b7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8009bd:	83 c4 10             	add    $0x10,%esp
  8009c0:	eb db                	jmp    80099d <putch+0x1f>

008009c2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009cb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009d2:	00 00 00 
	b.cnt = 0;
  8009d5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009dc:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8009df:	ff 75 0c             	pushl  0xc(%ebp)
  8009e2:	ff 75 08             	pushl  0x8(%ebp)
  8009e5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009eb:	50                   	push   %eax
  8009ec:	68 7e 09 80 00       	push   $0x80097e
  8009f1:	e8 4a 01 00 00       	call   800b40 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8009f6:	83 c4 08             	add    $0x8,%esp
  8009f9:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8009ff:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800a05:	50                   	push   %eax
  800a06:	e8 9d 0a 00 00       	call   8014a8 <sys_cputs>

	return b.cnt;
}
  800a0b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800a11:	c9                   	leave  
  800a12:	c3                   	ret    

00800a13 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800a13:	55                   	push   %ebp
  800a14:	89 e5                	mov    %esp,%ebp
  800a16:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a19:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800a1c:	50                   	push   %eax
  800a1d:	ff 75 08             	pushl  0x8(%ebp)
  800a20:	e8 9d ff ff ff       	call   8009c2 <vcprintf>
	va_end(ap);

	return cnt;
}
  800a25:	c9                   	leave  
  800a26:	c3                   	ret    

00800a27 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a27:	55                   	push   %ebp
  800a28:	89 e5                	mov    %esp,%ebp
  800a2a:	57                   	push   %edi
  800a2b:	56                   	push   %esi
  800a2c:	53                   	push   %ebx
  800a2d:	83 ec 1c             	sub    $0x1c,%esp
  800a30:	89 c6                	mov    %eax,%esi
  800a32:	89 d7                	mov    %edx,%edi
  800a34:	8b 45 08             	mov    0x8(%ebp),%eax
  800a37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a3a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a3d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800a40:	8b 45 10             	mov    0x10(%ebp),%eax
  800a43:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800a46:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800a4a:	74 2c                	je     800a78 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800a4c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a4f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800a56:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a59:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800a5c:	39 c2                	cmp    %eax,%edx
  800a5e:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800a61:	73 43                	jae    800aa6 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800a63:	83 eb 01             	sub    $0x1,%ebx
  800a66:	85 db                	test   %ebx,%ebx
  800a68:	7e 6c                	jle    800ad6 <printnum+0xaf>
				putch(padc, putdat);
  800a6a:	83 ec 08             	sub    $0x8,%esp
  800a6d:	57                   	push   %edi
  800a6e:	ff 75 18             	pushl  0x18(%ebp)
  800a71:	ff d6                	call   *%esi
  800a73:	83 c4 10             	add    $0x10,%esp
  800a76:	eb eb                	jmp    800a63 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800a78:	83 ec 0c             	sub    $0xc,%esp
  800a7b:	6a 20                	push   $0x20
  800a7d:	6a 00                	push   $0x0
  800a7f:	50                   	push   %eax
  800a80:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a83:	ff 75 e0             	pushl  -0x20(%ebp)
  800a86:	89 fa                	mov    %edi,%edx
  800a88:	89 f0                	mov    %esi,%eax
  800a8a:	e8 98 ff ff ff       	call   800a27 <printnum>
		while (--width > 0)
  800a8f:	83 c4 20             	add    $0x20,%esp
  800a92:	83 eb 01             	sub    $0x1,%ebx
  800a95:	85 db                	test   %ebx,%ebx
  800a97:	7e 65                	jle    800afe <printnum+0xd7>
			putch(padc, putdat);
  800a99:	83 ec 08             	sub    $0x8,%esp
  800a9c:	57                   	push   %edi
  800a9d:	6a 20                	push   $0x20
  800a9f:	ff d6                	call   *%esi
  800aa1:	83 c4 10             	add    $0x10,%esp
  800aa4:	eb ec                	jmp    800a92 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800aa6:	83 ec 0c             	sub    $0xc,%esp
  800aa9:	ff 75 18             	pushl  0x18(%ebp)
  800aac:	83 eb 01             	sub    $0x1,%ebx
  800aaf:	53                   	push   %ebx
  800ab0:	50                   	push   %eax
  800ab1:	83 ec 08             	sub    $0x8,%esp
  800ab4:	ff 75 dc             	pushl  -0x24(%ebp)
  800ab7:	ff 75 d8             	pushl  -0x28(%ebp)
  800aba:	ff 75 e4             	pushl  -0x1c(%ebp)
  800abd:	ff 75 e0             	pushl  -0x20(%ebp)
  800ac0:	e8 bb 22 00 00       	call   802d80 <__udivdi3>
  800ac5:	83 c4 18             	add    $0x18,%esp
  800ac8:	52                   	push   %edx
  800ac9:	50                   	push   %eax
  800aca:	89 fa                	mov    %edi,%edx
  800acc:	89 f0                	mov    %esi,%eax
  800ace:	e8 54 ff ff ff       	call   800a27 <printnum>
  800ad3:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800ad6:	83 ec 08             	sub    $0x8,%esp
  800ad9:	57                   	push   %edi
  800ada:	83 ec 04             	sub    $0x4,%esp
  800add:	ff 75 dc             	pushl  -0x24(%ebp)
  800ae0:	ff 75 d8             	pushl  -0x28(%ebp)
  800ae3:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ae6:	ff 75 e0             	pushl  -0x20(%ebp)
  800ae9:	e8 a2 23 00 00       	call   802e90 <__umoddi3>
  800aee:	83 c4 14             	add    $0x14,%esp
  800af1:	0f be 80 b7 32 80 00 	movsbl 0x8032b7(%eax),%eax
  800af8:	50                   	push   %eax
  800af9:	ff d6                	call   *%esi
  800afb:	83 c4 10             	add    $0x10,%esp
	}
}
  800afe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b01:	5b                   	pop    %ebx
  800b02:	5e                   	pop    %esi
  800b03:	5f                   	pop    %edi
  800b04:	5d                   	pop    %ebp
  800b05:	c3                   	ret    

00800b06 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
  800b09:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800b0c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800b10:	8b 10                	mov    (%eax),%edx
  800b12:	3b 50 04             	cmp    0x4(%eax),%edx
  800b15:	73 0a                	jae    800b21 <sprintputch+0x1b>
		*b->buf++ = ch;
  800b17:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b1a:	89 08                	mov    %ecx,(%eax)
  800b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1f:	88 02                	mov    %al,(%edx)
}
  800b21:	5d                   	pop    %ebp
  800b22:	c3                   	ret    

00800b23 <printfmt>:
{
  800b23:	55                   	push   %ebp
  800b24:	89 e5                	mov    %esp,%ebp
  800b26:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800b29:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800b2c:	50                   	push   %eax
  800b2d:	ff 75 10             	pushl  0x10(%ebp)
  800b30:	ff 75 0c             	pushl  0xc(%ebp)
  800b33:	ff 75 08             	pushl  0x8(%ebp)
  800b36:	e8 05 00 00 00       	call   800b40 <vprintfmt>
}
  800b3b:	83 c4 10             	add    $0x10,%esp
  800b3e:	c9                   	leave  
  800b3f:	c3                   	ret    

00800b40 <vprintfmt>:
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	57                   	push   %edi
  800b44:	56                   	push   %esi
  800b45:	53                   	push   %ebx
  800b46:	83 ec 3c             	sub    $0x3c,%esp
  800b49:	8b 75 08             	mov    0x8(%ebp),%esi
  800b4c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b4f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800b52:	e9 32 04 00 00       	jmp    800f89 <vprintfmt+0x449>
		padc = ' ';
  800b57:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800b5b:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800b62:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800b69:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800b70:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b77:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800b7e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800b83:	8d 47 01             	lea    0x1(%edi),%eax
  800b86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b89:	0f b6 17             	movzbl (%edi),%edx
  800b8c:	8d 42 dd             	lea    -0x23(%edx),%eax
  800b8f:	3c 55                	cmp    $0x55,%al
  800b91:	0f 87 12 05 00 00    	ja     8010a9 <vprintfmt+0x569>
  800b97:	0f b6 c0             	movzbl %al,%eax
  800b9a:	ff 24 85 a0 34 80 00 	jmp    *0x8034a0(,%eax,4)
  800ba1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800ba4:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800ba8:	eb d9                	jmp    800b83 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800baa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800bad:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800bb1:	eb d0                	jmp    800b83 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800bb3:	0f b6 d2             	movzbl %dl,%edx
  800bb6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800bb9:	b8 00 00 00 00       	mov    $0x0,%eax
  800bbe:	89 75 08             	mov    %esi,0x8(%ebp)
  800bc1:	eb 03                	jmp    800bc6 <vprintfmt+0x86>
  800bc3:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800bc6:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800bc9:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800bcd:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800bd0:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bd3:	83 fe 09             	cmp    $0x9,%esi
  800bd6:	76 eb                	jbe    800bc3 <vprintfmt+0x83>
  800bd8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bdb:	8b 75 08             	mov    0x8(%ebp),%esi
  800bde:	eb 14                	jmp    800bf4 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800be0:	8b 45 14             	mov    0x14(%ebp),%eax
  800be3:	8b 00                	mov    (%eax),%eax
  800be5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800be8:	8b 45 14             	mov    0x14(%ebp),%eax
  800beb:	8d 40 04             	lea    0x4(%eax),%eax
  800bee:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800bf1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800bf4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bf8:	79 89                	jns    800b83 <vprintfmt+0x43>
				width = precision, precision = -1;
  800bfa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800bfd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800c00:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800c07:	e9 77 ff ff ff       	jmp    800b83 <vprintfmt+0x43>
  800c0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c0f:	85 c0                	test   %eax,%eax
  800c11:	0f 48 c1             	cmovs  %ecx,%eax
  800c14:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800c17:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800c1a:	e9 64 ff ff ff       	jmp    800b83 <vprintfmt+0x43>
  800c1f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800c22:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800c29:	e9 55 ff ff ff       	jmp    800b83 <vprintfmt+0x43>
			lflag++;
  800c2e:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800c32:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800c35:	e9 49 ff ff ff       	jmp    800b83 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800c3a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c3d:	8d 78 04             	lea    0x4(%eax),%edi
  800c40:	83 ec 08             	sub    $0x8,%esp
  800c43:	53                   	push   %ebx
  800c44:	ff 30                	pushl  (%eax)
  800c46:	ff d6                	call   *%esi
			break;
  800c48:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800c4b:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800c4e:	e9 33 03 00 00       	jmp    800f86 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800c53:	8b 45 14             	mov    0x14(%ebp),%eax
  800c56:	8d 78 04             	lea    0x4(%eax),%edi
  800c59:	8b 00                	mov    (%eax),%eax
  800c5b:	99                   	cltd   
  800c5c:	31 d0                	xor    %edx,%eax
  800c5e:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800c60:	83 f8 11             	cmp    $0x11,%eax
  800c63:	7f 23                	jg     800c88 <vprintfmt+0x148>
  800c65:	8b 14 85 00 36 80 00 	mov    0x803600(,%eax,4),%edx
  800c6c:	85 d2                	test   %edx,%edx
  800c6e:	74 18                	je     800c88 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800c70:	52                   	push   %edx
  800c71:	68 1d 37 80 00       	push   $0x80371d
  800c76:	53                   	push   %ebx
  800c77:	56                   	push   %esi
  800c78:	e8 a6 fe ff ff       	call   800b23 <printfmt>
  800c7d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800c80:	89 7d 14             	mov    %edi,0x14(%ebp)
  800c83:	e9 fe 02 00 00       	jmp    800f86 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800c88:	50                   	push   %eax
  800c89:	68 cf 32 80 00       	push   $0x8032cf
  800c8e:	53                   	push   %ebx
  800c8f:	56                   	push   %esi
  800c90:	e8 8e fe ff ff       	call   800b23 <printfmt>
  800c95:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800c98:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800c9b:	e9 e6 02 00 00       	jmp    800f86 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800ca0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca3:	83 c0 04             	add    $0x4,%eax
  800ca6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800ca9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cac:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800cae:	85 c9                	test   %ecx,%ecx
  800cb0:	b8 c8 32 80 00       	mov    $0x8032c8,%eax
  800cb5:	0f 45 c1             	cmovne %ecx,%eax
  800cb8:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800cbb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800cbf:	7e 06                	jle    800cc7 <vprintfmt+0x187>
  800cc1:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800cc5:	75 0d                	jne    800cd4 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cc7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800cca:	89 c7                	mov    %eax,%edi
  800ccc:	03 45 e0             	add    -0x20(%ebp),%eax
  800ccf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800cd2:	eb 53                	jmp    800d27 <vprintfmt+0x1e7>
  800cd4:	83 ec 08             	sub    $0x8,%esp
  800cd7:	ff 75 d8             	pushl  -0x28(%ebp)
  800cda:	50                   	push   %eax
  800cdb:	e8 71 04 00 00       	call   801151 <strnlen>
  800ce0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800ce3:	29 c1                	sub    %eax,%ecx
  800ce5:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800ce8:	83 c4 10             	add    $0x10,%esp
  800ceb:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800ced:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800cf1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800cf4:	eb 0f                	jmp    800d05 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800cf6:	83 ec 08             	sub    $0x8,%esp
  800cf9:	53                   	push   %ebx
  800cfa:	ff 75 e0             	pushl  -0x20(%ebp)
  800cfd:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800cff:	83 ef 01             	sub    $0x1,%edi
  800d02:	83 c4 10             	add    $0x10,%esp
  800d05:	85 ff                	test   %edi,%edi
  800d07:	7f ed                	jg     800cf6 <vprintfmt+0x1b6>
  800d09:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800d0c:	85 c9                	test   %ecx,%ecx
  800d0e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d13:	0f 49 c1             	cmovns %ecx,%eax
  800d16:	29 c1                	sub    %eax,%ecx
  800d18:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800d1b:	eb aa                	jmp    800cc7 <vprintfmt+0x187>
					putch(ch, putdat);
  800d1d:	83 ec 08             	sub    $0x8,%esp
  800d20:	53                   	push   %ebx
  800d21:	52                   	push   %edx
  800d22:	ff d6                	call   *%esi
  800d24:	83 c4 10             	add    $0x10,%esp
  800d27:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800d2a:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d2c:	83 c7 01             	add    $0x1,%edi
  800d2f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800d33:	0f be d0             	movsbl %al,%edx
  800d36:	85 d2                	test   %edx,%edx
  800d38:	74 4b                	je     800d85 <vprintfmt+0x245>
  800d3a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800d3e:	78 06                	js     800d46 <vprintfmt+0x206>
  800d40:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800d44:	78 1e                	js     800d64 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800d46:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800d4a:	74 d1                	je     800d1d <vprintfmt+0x1dd>
  800d4c:	0f be c0             	movsbl %al,%eax
  800d4f:	83 e8 20             	sub    $0x20,%eax
  800d52:	83 f8 5e             	cmp    $0x5e,%eax
  800d55:	76 c6                	jbe    800d1d <vprintfmt+0x1dd>
					putch('?', putdat);
  800d57:	83 ec 08             	sub    $0x8,%esp
  800d5a:	53                   	push   %ebx
  800d5b:	6a 3f                	push   $0x3f
  800d5d:	ff d6                	call   *%esi
  800d5f:	83 c4 10             	add    $0x10,%esp
  800d62:	eb c3                	jmp    800d27 <vprintfmt+0x1e7>
  800d64:	89 cf                	mov    %ecx,%edi
  800d66:	eb 0e                	jmp    800d76 <vprintfmt+0x236>
				putch(' ', putdat);
  800d68:	83 ec 08             	sub    $0x8,%esp
  800d6b:	53                   	push   %ebx
  800d6c:	6a 20                	push   $0x20
  800d6e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800d70:	83 ef 01             	sub    $0x1,%edi
  800d73:	83 c4 10             	add    $0x10,%esp
  800d76:	85 ff                	test   %edi,%edi
  800d78:	7f ee                	jg     800d68 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800d7a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800d7d:	89 45 14             	mov    %eax,0x14(%ebp)
  800d80:	e9 01 02 00 00       	jmp    800f86 <vprintfmt+0x446>
  800d85:	89 cf                	mov    %ecx,%edi
  800d87:	eb ed                	jmp    800d76 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800d89:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800d8c:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800d93:	e9 eb fd ff ff       	jmp    800b83 <vprintfmt+0x43>
	if (lflag >= 2)
  800d98:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800d9c:	7f 21                	jg     800dbf <vprintfmt+0x27f>
	else if (lflag)
  800d9e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800da2:	74 68                	je     800e0c <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800da4:	8b 45 14             	mov    0x14(%ebp),%eax
  800da7:	8b 00                	mov    (%eax),%eax
  800da9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800dac:	89 c1                	mov    %eax,%ecx
  800dae:	c1 f9 1f             	sar    $0x1f,%ecx
  800db1:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800db4:	8b 45 14             	mov    0x14(%ebp),%eax
  800db7:	8d 40 04             	lea    0x4(%eax),%eax
  800dba:	89 45 14             	mov    %eax,0x14(%ebp)
  800dbd:	eb 17                	jmp    800dd6 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800dbf:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc2:	8b 50 04             	mov    0x4(%eax),%edx
  800dc5:	8b 00                	mov    (%eax),%eax
  800dc7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800dca:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800dcd:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd0:	8d 40 08             	lea    0x8(%eax),%eax
  800dd3:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800dd6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800dd9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800ddc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ddf:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800de2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800de6:	78 3f                	js     800e27 <vprintfmt+0x2e7>
			base = 10;
  800de8:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800ded:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800df1:	0f 84 71 01 00 00    	je     800f68 <vprintfmt+0x428>
				putch('+', putdat);
  800df7:	83 ec 08             	sub    $0x8,%esp
  800dfa:	53                   	push   %ebx
  800dfb:	6a 2b                	push   $0x2b
  800dfd:	ff d6                	call   *%esi
  800dff:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800e02:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e07:	e9 5c 01 00 00       	jmp    800f68 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800e0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e0f:	8b 00                	mov    (%eax),%eax
  800e11:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800e14:	89 c1                	mov    %eax,%ecx
  800e16:	c1 f9 1f             	sar    $0x1f,%ecx
  800e19:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800e1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e1f:	8d 40 04             	lea    0x4(%eax),%eax
  800e22:	89 45 14             	mov    %eax,0x14(%ebp)
  800e25:	eb af                	jmp    800dd6 <vprintfmt+0x296>
				putch('-', putdat);
  800e27:	83 ec 08             	sub    $0x8,%esp
  800e2a:	53                   	push   %ebx
  800e2b:	6a 2d                	push   $0x2d
  800e2d:	ff d6                	call   *%esi
				num = -(long long) num;
  800e2f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e32:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800e35:	f7 d8                	neg    %eax
  800e37:	83 d2 00             	adc    $0x0,%edx
  800e3a:	f7 da                	neg    %edx
  800e3c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e3f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800e42:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800e45:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e4a:	e9 19 01 00 00       	jmp    800f68 <vprintfmt+0x428>
	if (lflag >= 2)
  800e4f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800e53:	7f 29                	jg     800e7e <vprintfmt+0x33e>
	else if (lflag)
  800e55:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800e59:	74 44                	je     800e9f <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800e5b:	8b 45 14             	mov    0x14(%ebp),%eax
  800e5e:	8b 00                	mov    (%eax),%eax
  800e60:	ba 00 00 00 00       	mov    $0x0,%edx
  800e65:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e68:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800e6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800e6e:	8d 40 04             	lea    0x4(%eax),%eax
  800e71:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800e74:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e79:	e9 ea 00 00 00       	jmp    800f68 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800e7e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e81:	8b 50 04             	mov    0x4(%eax),%edx
  800e84:	8b 00                	mov    (%eax),%eax
  800e86:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e89:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800e8c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e8f:	8d 40 08             	lea    0x8(%eax),%eax
  800e92:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800e95:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e9a:	e9 c9 00 00 00       	jmp    800f68 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800e9f:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea2:	8b 00                	mov    (%eax),%eax
  800ea4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ea9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800eac:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800eaf:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb2:	8d 40 04             	lea    0x4(%eax),%eax
  800eb5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800eb8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ebd:	e9 a6 00 00 00       	jmp    800f68 <vprintfmt+0x428>
			putch('0', putdat);
  800ec2:	83 ec 08             	sub    $0x8,%esp
  800ec5:	53                   	push   %ebx
  800ec6:	6a 30                	push   $0x30
  800ec8:	ff d6                	call   *%esi
	if (lflag >= 2)
  800eca:	83 c4 10             	add    $0x10,%esp
  800ecd:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800ed1:	7f 26                	jg     800ef9 <vprintfmt+0x3b9>
	else if (lflag)
  800ed3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800ed7:	74 3e                	je     800f17 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800ed9:	8b 45 14             	mov    0x14(%ebp),%eax
  800edc:	8b 00                	mov    (%eax),%eax
  800ede:	ba 00 00 00 00       	mov    $0x0,%edx
  800ee3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ee6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ee9:	8b 45 14             	mov    0x14(%ebp),%eax
  800eec:	8d 40 04             	lea    0x4(%eax),%eax
  800eef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800ef2:	b8 08 00 00 00       	mov    $0x8,%eax
  800ef7:	eb 6f                	jmp    800f68 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800ef9:	8b 45 14             	mov    0x14(%ebp),%eax
  800efc:	8b 50 04             	mov    0x4(%eax),%edx
  800eff:	8b 00                	mov    (%eax),%eax
  800f01:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f04:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f07:	8b 45 14             	mov    0x14(%ebp),%eax
  800f0a:	8d 40 08             	lea    0x8(%eax),%eax
  800f0d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800f10:	b8 08 00 00 00       	mov    $0x8,%eax
  800f15:	eb 51                	jmp    800f68 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800f17:	8b 45 14             	mov    0x14(%ebp),%eax
  800f1a:	8b 00                	mov    (%eax),%eax
  800f1c:	ba 00 00 00 00       	mov    $0x0,%edx
  800f21:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f24:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f27:	8b 45 14             	mov    0x14(%ebp),%eax
  800f2a:	8d 40 04             	lea    0x4(%eax),%eax
  800f2d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800f30:	b8 08 00 00 00       	mov    $0x8,%eax
  800f35:	eb 31                	jmp    800f68 <vprintfmt+0x428>
			putch('0', putdat);
  800f37:	83 ec 08             	sub    $0x8,%esp
  800f3a:	53                   	push   %ebx
  800f3b:	6a 30                	push   $0x30
  800f3d:	ff d6                	call   *%esi
			putch('x', putdat);
  800f3f:	83 c4 08             	add    $0x8,%esp
  800f42:	53                   	push   %ebx
  800f43:	6a 78                	push   $0x78
  800f45:	ff d6                	call   *%esi
			num = (unsigned long long)
  800f47:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4a:	8b 00                	mov    (%eax),%eax
  800f4c:	ba 00 00 00 00       	mov    $0x0,%edx
  800f51:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f54:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800f57:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800f5a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f5d:	8d 40 04             	lea    0x4(%eax),%eax
  800f60:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800f63:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800f68:	83 ec 0c             	sub    $0xc,%esp
  800f6b:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800f6f:	52                   	push   %edx
  800f70:	ff 75 e0             	pushl  -0x20(%ebp)
  800f73:	50                   	push   %eax
  800f74:	ff 75 dc             	pushl  -0x24(%ebp)
  800f77:	ff 75 d8             	pushl  -0x28(%ebp)
  800f7a:	89 da                	mov    %ebx,%edx
  800f7c:	89 f0                	mov    %esi,%eax
  800f7e:	e8 a4 fa ff ff       	call   800a27 <printnum>
			break;
  800f83:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800f86:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f89:	83 c7 01             	add    $0x1,%edi
  800f8c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800f90:	83 f8 25             	cmp    $0x25,%eax
  800f93:	0f 84 be fb ff ff    	je     800b57 <vprintfmt+0x17>
			if (ch == '\0')
  800f99:	85 c0                	test   %eax,%eax
  800f9b:	0f 84 28 01 00 00    	je     8010c9 <vprintfmt+0x589>
			putch(ch, putdat);
  800fa1:	83 ec 08             	sub    $0x8,%esp
  800fa4:	53                   	push   %ebx
  800fa5:	50                   	push   %eax
  800fa6:	ff d6                	call   *%esi
  800fa8:	83 c4 10             	add    $0x10,%esp
  800fab:	eb dc                	jmp    800f89 <vprintfmt+0x449>
	if (lflag >= 2)
  800fad:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800fb1:	7f 26                	jg     800fd9 <vprintfmt+0x499>
	else if (lflag)
  800fb3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800fb7:	74 41                	je     800ffa <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800fb9:	8b 45 14             	mov    0x14(%ebp),%eax
  800fbc:	8b 00                	mov    (%eax),%eax
  800fbe:	ba 00 00 00 00       	mov    $0x0,%edx
  800fc3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800fc6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800fc9:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcc:	8d 40 04             	lea    0x4(%eax),%eax
  800fcf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800fd2:	b8 10 00 00 00       	mov    $0x10,%eax
  800fd7:	eb 8f                	jmp    800f68 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800fd9:	8b 45 14             	mov    0x14(%ebp),%eax
  800fdc:	8b 50 04             	mov    0x4(%eax),%edx
  800fdf:	8b 00                	mov    (%eax),%eax
  800fe1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800fe4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800fe7:	8b 45 14             	mov    0x14(%ebp),%eax
  800fea:	8d 40 08             	lea    0x8(%eax),%eax
  800fed:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ff0:	b8 10 00 00 00       	mov    $0x10,%eax
  800ff5:	e9 6e ff ff ff       	jmp    800f68 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800ffa:	8b 45 14             	mov    0x14(%ebp),%eax
  800ffd:	8b 00                	mov    (%eax),%eax
  800fff:	ba 00 00 00 00       	mov    $0x0,%edx
  801004:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801007:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80100a:	8b 45 14             	mov    0x14(%ebp),%eax
  80100d:	8d 40 04             	lea    0x4(%eax),%eax
  801010:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801013:	b8 10 00 00 00       	mov    $0x10,%eax
  801018:	e9 4b ff ff ff       	jmp    800f68 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80101d:	8b 45 14             	mov    0x14(%ebp),%eax
  801020:	83 c0 04             	add    $0x4,%eax
  801023:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801026:	8b 45 14             	mov    0x14(%ebp),%eax
  801029:	8b 00                	mov    (%eax),%eax
  80102b:	85 c0                	test   %eax,%eax
  80102d:	74 14                	je     801043 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80102f:	8b 13                	mov    (%ebx),%edx
  801031:	83 fa 7f             	cmp    $0x7f,%edx
  801034:	7f 37                	jg     80106d <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  801036:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  801038:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80103b:	89 45 14             	mov    %eax,0x14(%ebp)
  80103e:	e9 43 ff ff ff       	jmp    800f86 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  801043:	b8 0a 00 00 00       	mov    $0xa,%eax
  801048:	bf ed 33 80 00       	mov    $0x8033ed,%edi
							putch(ch, putdat);
  80104d:	83 ec 08             	sub    $0x8,%esp
  801050:	53                   	push   %ebx
  801051:	50                   	push   %eax
  801052:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  801054:	83 c7 01             	add    $0x1,%edi
  801057:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80105b:	83 c4 10             	add    $0x10,%esp
  80105e:	85 c0                	test   %eax,%eax
  801060:	75 eb                	jne    80104d <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  801062:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801065:	89 45 14             	mov    %eax,0x14(%ebp)
  801068:	e9 19 ff ff ff       	jmp    800f86 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80106d:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80106f:	b8 0a 00 00 00       	mov    $0xa,%eax
  801074:	bf 25 34 80 00       	mov    $0x803425,%edi
							putch(ch, putdat);
  801079:	83 ec 08             	sub    $0x8,%esp
  80107c:	53                   	push   %ebx
  80107d:	50                   	push   %eax
  80107e:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  801080:	83 c7 01             	add    $0x1,%edi
  801083:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  801087:	83 c4 10             	add    $0x10,%esp
  80108a:	85 c0                	test   %eax,%eax
  80108c:	75 eb                	jne    801079 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80108e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801091:	89 45 14             	mov    %eax,0x14(%ebp)
  801094:	e9 ed fe ff ff       	jmp    800f86 <vprintfmt+0x446>
			putch(ch, putdat);
  801099:	83 ec 08             	sub    $0x8,%esp
  80109c:	53                   	push   %ebx
  80109d:	6a 25                	push   $0x25
  80109f:	ff d6                	call   *%esi
			break;
  8010a1:	83 c4 10             	add    $0x10,%esp
  8010a4:	e9 dd fe ff ff       	jmp    800f86 <vprintfmt+0x446>
			putch('%', putdat);
  8010a9:	83 ec 08             	sub    $0x8,%esp
  8010ac:	53                   	push   %ebx
  8010ad:	6a 25                	push   $0x25
  8010af:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010b1:	83 c4 10             	add    $0x10,%esp
  8010b4:	89 f8                	mov    %edi,%eax
  8010b6:	eb 03                	jmp    8010bb <vprintfmt+0x57b>
  8010b8:	83 e8 01             	sub    $0x1,%eax
  8010bb:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8010bf:	75 f7                	jne    8010b8 <vprintfmt+0x578>
  8010c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8010c4:	e9 bd fe ff ff       	jmp    800f86 <vprintfmt+0x446>
}
  8010c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010cc:	5b                   	pop    %ebx
  8010cd:	5e                   	pop    %esi
  8010ce:	5f                   	pop    %edi
  8010cf:	5d                   	pop    %ebp
  8010d0:	c3                   	ret    

008010d1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010d1:	55                   	push   %ebp
  8010d2:	89 e5                	mov    %esp,%ebp
  8010d4:	83 ec 18             	sub    $0x18,%esp
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010e0:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8010e4:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8010e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010ee:	85 c0                	test   %eax,%eax
  8010f0:	74 26                	je     801118 <vsnprintf+0x47>
  8010f2:	85 d2                	test   %edx,%edx
  8010f4:	7e 22                	jle    801118 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010f6:	ff 75 14             	pushl  0x14(%ebp)
  8010f9:	ff 75 10             	pushl  0x10(%ebp)
  8010fc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010ff:	50                   	push   %eax
  801100:	68 06 0b 80 00       	push   $0x800b06
  801105:	e8 36 fa ff ff       	call   800b40 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80110a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80110d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801110:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801113:	83 c4 10             	add    $0x10,%esp
}
  801116:	c9                   	leave  
  801117:	c3                   	ret    
		return -E_INVAL;
  801118:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80111d:	eb f7                	jmp    801116 <vsnprintf+0x45>

0080111f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80111f:	55                   	push   %ebp
  801120:	89 e5                	mov    %esp,%ebp
  801122:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801125:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801128:	50                   	push   %eax
  801129:	ff 75 10             	pushl  0x10(%ebp)
  80112c:	ff 75 0c             	pushl  0xc(%ebp)
  80112f:	ff 75 08             	pushl  0x8(%ebp)
  801132:	e8 9a ff ff ff       	call   8010d1 <vsnprintf>
	va_end(ap);

	return rc;
}
  801137:	c9                   	leave  
  801138:	c3                   	ret    

00801139 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801139:	55                   	push   %ebp
  80113a:	89 e5                	mov    %esp,%ebp
  80113c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80113f:	b8 00 00 00 00       	mov    $0x0,%eax
  801144:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801148:	74 05                	je     80114f <strlen+0x16>
		n++;
  80114a:	83 c0 01             	add    $0x1,%eax
  80114d:	eb f5                	jmp    801144 <strlen+0xb>
	return n;
}
  80114f:	5d                   	pop    %ebp
  801150:	c3                   	ret    

00801151 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
  801154:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801157:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80115a:	ba 00 00 00 00       	mov    $0x0,%edx
  80115f:	39 c2                	cmp    %eax,%edx
  801161:	74 0d                	je     801170 <strnlen+0x1f>
  801163:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  801167:	74 05                	je     80116e <strnlen+0x1d>
		n++;
  801169:	83 c2 01             	add    $0x1,%edx
  80116c:	eb f1                	jmp    80115f <strnlen+0xe>
  80116e:	89 d0                	mov    %edx,%eax
	return n;
}
  801170:	5d                   	pop    %ebp
  801171:	c3                   	ret    

00801172 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801172:	55                   	push   %ebp
  801173:	89 e5                	mov    %esp,%ebp
  801175:	53                   	push   %ebx
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80117c:	ba 00 00 00 00       	mov    $0x0,%edx
  801181:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  801185:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  801188:	83 c2 01             	add    $0x1,%edx
  80118b:	84 c9                	test   %cl,%cl
  80118d:	75 f2                	jne    801181 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80118f:	5b                   	pop    %ebx
  801190:	5d                   	pop    %ebp
  801191:	c3                   	ret    

00801192 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801192:	55                   	push   %ebp
  801193:	89 e5                	mov    %esp,%ebp
  801195:	53                   	push   %ebx
  801196:	83 ec 10             	sub    $0x10,%esp
  801199:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80119c:	53                   	push   %ebx
  80119d:	e8 97 ff ff ff       	call   801139 <strlen>
  8011a2:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8011a5:	ff 75 0c             	pushl  0xc(%ebp)
  8011a8:	01 d8                	add    %ebx,%eax
  8011aa:	50                   	push   %eax
  8011ab:	e8 c2 ff ff ff       	call   801172 <strcpy>
	return dst;
}
  8011b0:	89 d8                	mov    %ebx,%eax
  8011b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011b5:	c9                   	leave  
  8011b6:	c3                   	ret    

008011b7 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8011b7:	55                   	push   %ebp
  8011b8:	89 e5                	mov    %esp,%ebp
  8011ba:	56                   	push   %esi
  8011bb:	53                   	push   %ebx
  8011bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c2:	89 c6                	mov    %eax,%esi
  8011c4:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011c7:	89 c2                	mov    %eax,%edx
  8011c9:	39 f2                	cmp    %esi,%edx
  8011cb:	74 11                	je     8011de <strncpy+0x27>
		*dst++ = *src;
  8011cd:	83 c2 01             	add    $0x1,%edx
  8011d0:	0f b6 19             	movzbl (%ecx),%ebx
  8011d3:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8011d6:	80 fb 01             	cmp    $0x1,%bl
  8011d9:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8011dc:	eb eb                	jmp    8011c9 <strncpy+0x12>
	}
	return ret;
}
  8011de:	5b                   	pop    %ebx
  8011df:	5e                   	pop    %esi
  8011e0:	5d                   	pop    %ebp
  8011e1:	c3                   	ret    

008011e2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8011e2:	55                   	push   %ebp
  8011e3:	89 e5                	mov    %esp,%ebp
  8011e5:	56                   	push   %esi
  8011e6:	53                   	push   %ebx
  8011e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8011ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ed:	8b 55 10             	mov    0x10(%ebp),%edx
  8011f0:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8011f2:	85 d2                	test   %edx,%edx
  8011f4:	74 21                	je     801217 <strlcpy+0x35>
  8011f6:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8011fa:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8011fc:	39 c2                	cmp    %eax,%edx
  8011fe:	74 14                	je     801214 <strlcpy+0x32>
  801200:	0f b6 19             	movzbl (%ecx),%ebx
  801203:	84 db                	test   %bl,%bl
  801205:	74 0b                	je     801212 <strlcpy+0x30>
			*dst++ = *src++;
  801207:	83 c1 01             	add    $0x1,%ecx
  80120a:	83 c2 01             	add    $0x1,%edx
  80120d:	88 5a ff             	mov    %bl,-0x1(%edx)
  801210:	eb ea                	jmp    8011fc <strlcpy+0x1a>
  801212:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801214:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801217:	29 f0                	sub    %esi,%eax
}
  801219:	5b                   	pop    %ebx
  80121a:	5e                   	pop    %esi
  80121b:	5d                   	pop    %ebp
  80121c:	c3                   	ret    

0080121d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80121d:	55                   	push   %ebp
  80121e:	89 e5                	mov    %esp,%ebp
  801220:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801223:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801226:	0f b6 01             	movzbl (%ecx),%eax
  801229:	84 c0                	test   %al,%al
  80122b:	74 0c                	je     801239 <strcmp+0x1c>
  80122d:	3a 02                	cmp    (%edx),%al
  80122f:	75 08                	jne    801239 <strcmp+0x1c>
		p++, q++;
  801231:	83 c1 01             	add    $0x1,%ecx
  801234:	83 c2 01             	add    $0x1,%edx
  801237:	eb ed                	jmp    801226 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801239:	0f b6 c0             	movzbl %al,%eax
  80123c:	0f b6 12             	movzbl (%edx),%edx
  80123f:	29 d0                	sub    %edx,%eax
}
  801241:	5d                   	pop    %ebp
  801242:	c3                   	ret    

00801243 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801243:	55                   	push   %ebp
  801244:	89 e5                	mov    %esp,%ebp
  801246:	53                   	push   %ebx
  801247:	8b 45 08             	mov    0x8(%ebp),%eax
  80124a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80124d:	89 c3                	mov    %eax,%ebx
  80124f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801252:	eb 06                	jmp    80125a <strncmp+0x17>
		n--, p++, q++;
  801254:	83 c0 01             	add    $0x1,%eax
  801257:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80125a:	39 d8                	cmp    %ebx,%eax
  80125c:	74 16                	je     801274 <strncmp+0x31>
  80125e:	0f b6 08             	movzbl (%eax),%ecx
  801261:	84 c9                	test   %cl,%cl
  801263:	74 04                	je     801269 <strncmp+0x26>
  801265:	3a 0a                	cmp    (%edx),%cl
  801267:	74 eb                	je     801254 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801269:	0f b6 00             	movzbl (%eax),%eax
  80126c:	0f b6 12             	movzbl (%edx),%edx
  80126f:	29 d0                	sub    %edx,%eax
}
  801271:	5b                   	pop    %ebx
  801272:	5d                   	pop    %ebp
  801273:	c3                   	ret    
		return 0;
  801274:	b8 00 00 00 00       	mov    $0x0,%eax
  801279:	eb f6                	jmp    801271 <strncmp+0x2e>

0080127b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80127b:	55                   	push   %ebp
  80127c:	89 e5                	mov    %esp,%ebp
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801285:	0f b6 10             	movzbl (%eax),%edx
  801288:	84 d2                	test   %dl,%dl
  80128a:	74 09                	je     801295 <strchr+0x1a>
		if (*s == c)
  80128c:	38 ca                	cmp    %cl,%dl
  80128e:	74 0a                	je     80129a <strchr+0x1f>
	for (; *s; s++)
  801290:	83 c0 01             	add    $0x1,%eax
  801293:	eb f0                	jmp    801285 <strchr+0xa>
			return (char *) s;
	return 0;
  801295:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80129a:	5d                   	pop    %ebp
  80129b:	c3                   	ret    

0080129c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8012a6:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8012a9:	38 ca                	cmp    %cl,%dl
  8012ab:	74 09                	je     8012b6 <strfind+0x1a>
  8012ad:	84 d2                	test   %dl,%dl
  8012af:	74 05                	je     8012b6 <strfind+0x1a>
	for (; *s; s++)
  8012b1:	83 c0 01             	add    $0x1,%eax
  8012b4:	eb f0                	jmp    8012a6 <strfind+0xa>
			break;
	return (char *) s;
}
  8012b6:	5d                   	pop    %ebp
  8012b7:	c3                   	ret    

008012b8 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012b8:	55                   	push   %ebp
  8012b9:	89 e5                	mov    %esp,%ebp
  8012bb:	57                   	push   %edi
  8012bc:	56                   	push   %esi
  8012bd:	53                   	push   %ebx
  8012be:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012c1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8012c4:	85 c9                	test   %ecx,%ecx
  8012c6:	74 31                	je     8012f9 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8012c8:	89 f8                	mov    %edi,%eax
  8012ca:	09 c8                	or     %ecx,%eax
  8012cc:	a8 03                	test   $0x3,%al
  8012ce:	75 23                	jne    8012f3 <memset+0x3b>
		c &= 0xFF;
  8012d0:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8012d4:	89 d3                	mov    %edx,%ebx
  8012d6:	c1 e3 08             	shl    $0x8,%ebx
  8012d9:	89 d0                	mov    %edx,%eax
  8012db:	c1 e0 18             	shl    $0x18,%eax
  8012de:	89 d6                	mov    %edx,%esi
  8012e0:	c1 e6 10             	shl    $0x10,%esi
  8012e3:	09 f0                	or     %esi,%eax
  8012e5:	09 c2                	or     %eax,%edx
  8012e7:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8012e9:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8012ec:	89 d0                	mov    %edx,%eax
  8012ee:	fc                   	cld    
  8012ef:	f3 ab                	rep stos %eax,%es:(%edi)
  8012f1:	eb 06                	jmp    8012f9 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8012f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f6:	fc                   	cld    
  8012f7:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8012f9:	89 f8                	mov    %edi,%eax
  8012fb:	5b                   	pop    %ebx
  8012fc:	5e                   	pop    %esi
  8012fd:	5f                   	pop    %edi
  8012fe:	5d                   	pop    %ebp
  8012ff:	c3                   	ret    

00801300 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801300:	55                   	push   %ebp
  801301:	89 e5                	mov    %esp,%ebp
  801303:	57                   	push   %edi
  801304:	56                   	push   %esi
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	8b 75 0c             	mov    0xc(%ebp),%esi
  80130b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80130e:	39 c6                	cmp    %eax,%esi
  801310:	73 32                	jae    801344 <memmove+0x44>
  801312:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801315:	39 c2                	cmp    %eax,%edx
  801317:	76 2b                	jbe    801344 <memmove+0x44>
		s += n;
		d += n;
  801319:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80131c:	89 fe                	mov    %edi,%esi
  80131e:	09 ce                	or     %ecx,%esi
  801320:	09 d6                	or     %edx,%esi
  801322:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801328:	75 0e                	jne    801338 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80132a:	83 ef 04             	sub    $0x4,%edi
  80132d:	8d 72 fc             	lea    -0x4(%edx),%esi
  801330:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801333:	fd                   	std    
  801334:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801336:	eb 09                	jmp    801341 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801338:	83 ef 01             	sub    $0x1,%edi
  80133b:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80133e:	fd                   	std    
  80133f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801341:	fc                   	cld    
  801342:	eb 1a                	jmp    80135e <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801344:	89 c2                	mov    %eax,%edx
  801346:	09 ca                	or     %ecx,%edx
  801348:	09 f2                	or     %esi,%edx
  80134a:	f6 c2 03             	test   $0x3,%dl
  80134d:	75 0a                	jne    801359 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80134f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801352:	89 c7                	mov    %eax,%edi
  801354:	fc                   	cld    
  801355:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801357:	eb 05                	jmp    80135e <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  801359:	89 c7                	mov    %eax,%edi
  80135b:	fc                   	cld    
  80135c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80135e:	5e                   	pop    %esi
  80135f:	5f                   	pop    %edi
  801360:	5d                   	pop    %ebp
  801361:	c3                   	ret    

00801362 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801362:	55                   	push   %ebp
  801363:	89 e5                	mov    %esp,%ebp
  801365:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801368:	ff 75 10             	pushl  0x10(%ebp)
  80136b:	ff 75 0c             	pushl  0xc(%ebp)
  80136e:	ff 75 08             	pushl  0x8(%ebp)
  801371:	e8 8a ff ff ff       	call   801300 <memmove>
}
  801376:	c9                   	leave  
  801377:	c3                   	ret    

00801378 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801378:	55                   	push   %ebp
  801379:	89 e5                	mov    %esp,%ebp
  80137b:	56                   	push   %esi
  80137c:	53                   	push   %ebx
  80137d:	8b 45 08             	mov    0x8(%ebp),%eax
  801380:	8b 55 0c             	mov    0xc(%ebp),%edx
  801383:	89 c6                	mov    %eax,%esi
  801385:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801388:	39 f0                	cmp    %esi,%eax
  80138a:	74 1c                	je     8013a8 <memcmp+0x30>
		if (*s1 != *s2)
  80138c:	0f b6 08             	movzbl (%eax),%ecx
  80138f:	0f b6 1a             	movzbl (%edx),%ebx
  801392:	38 d9                	cmp    %bl,%cl
  801394:	75 08                	jne    80139e <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801396:	83 c0 01             	add    $0x1,%eax
  801399:	83 c2 01             	add    $0x1,%edx
  80139c:	eb ea                	jmp    801388 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  80139e:	0f b6 c1             	movzbl %cl,%eax
  8013a1:	0f b6 db             	movzbl %bl,%ebx
  8013a4:	29 d8                	sub    %ebx,%eax
  8013a6:	eb 05                	jmp    8013ad <memcmp+0x35>
	}

	return 0;
  8013a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ad:	5b                   	pop    %ebx
  8013ae:	5e                   	pop    %esi
  8013af:	5d                   	pop    %ebp
  8013b0:	c3                   	ret    

008013b1 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8013b1:	55                   	push   %ebp
  8013b2:	89 e5                	mov    %esp,%ebp
  8013b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8013ba:	89 c2                	mov    %eax,%edx
  8013bc:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8013bf:	39 d0                	cmp    %edx,%eax
  8013c1:	73 09                	jae    8013cc <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013c3:	38 08                	cmp    %cl,(%eax)
  8013c5:	74 05                	je     8013cc <memfind+0x1b>
	for (; s < ends; s++)
  8013c7:	83 c0 01             	add    $0x1,%eax
  8013ca:	eb f3                	jmp    8013bf <memfind+0xe>
			break;
	return (void *) s;
}
  8013cc:	5d                   	pop    %ebp
  8013cd:	c3                   	ret    

008013ce <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013ce:	55                   	push   %ebp
  8013cf:	89 e5                	mov    %esp,%ebp
  8013d1:	57                   	push   %edi
  8013d2:	56                   	push   %esi
  8013d3:	53                   	push   %ebx
  8013d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013da:	eb 03                	jmp    8013df <strtol+0x11>
		s++;
  8013dc:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8013df:	0f b6 01             	movzbl (%ecx),%eax
  8013e2:	3c 20                	cmp    $0x20,%al
  8013e4:	74 f6                	je     8013dc <strtol+0xe>
  8013e6:	3c 09                	cmp    $0x9,%al
  8013e8:	74 f2                	je     8013dc <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8013ea:	3c 2b                	cmp    $0x2b,%al
  8013ec:	74 2a                	je     801418 <strtol+0x4a>
	int neg = 0;
  8013ee:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8013f3:	3c 2d                	cmp    $0x2d,%al
  8013f5:	74 2b                	je     801422 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013f7:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8013fd:	75 0f                	jne    80140e <strtol+0x40>
  8013ff:	80 39 30             	cmpb   $0x30,(%ecx)
  801402:	74 28                	je     80142c <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801404:	85 db                	test   %ebx,%ebx
  801406:	b8 0a 00 00 00       	mov    $0xa,%eax
  80140b:	0f 44 d8             	cmove  %eax,%ebx
  80140e:	b8 00 00 00 00       	mov    $0x0,%eax
  801413:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801416:	eb 50                	jmp    801468 <strtol+0x9a>
		s++;
  801418:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  80141b:	bf 00 00 00 00       	mov    $0x0,%edi
  801420:	eb d5                	jmp    8013f7 <strtol+0x29>
		s++, neg = 1;
  801422:	83 c1 01             	add    $0x1,%ecx
  801425:	bf 01 00 00 00       	mov    $0x1,%edi
  80142a:	eb cb                	jmp    8013f7 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80142c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801430:	74 0e                	je     801440 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  801432:	85 db                	test   %ebx,%ebx
  801434:	75 d8                	jne    80140e <strtol+0x40>
		s++, base = 8;
  801436:	83 c1 01             	add    $0x1,%ecx
  801439:	bb 08 00 00 00       	mov    $0x8,%ebx
  80143e:	eb ce                	jmp    80140e <strtol+0x40>
		s += 2, base = 16;
  801440:	83 c1 02             	add    $0x2,%ecx
  801443:	bb 10 00 00 00       	mov    $0x10,%ebx
  801448:	eb c4                	jmp    80140e <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  80144a:	8d 72 9f             	lea    -0x61(%edx),%esi
  80144d:	89 f3                	mov    %esi,%ebx
  80144f:	80 fb 19             	cmp    $0x19,%bl
  801452:	77 29                	ja     80147d <strtol+0xaf>
			dig = *s - 'a' + 10;
  801454:	0f be d2             	movsbl %dl,%edx
  801457:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  80145a:	3b 55 10             	cmp    0x10(%ebp),%edx
  80145d:	7d 30                	jge    80148f <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  80145f:	83 c1 01             	add    $0x1,%ecx
  801462:	0f af 45 10          	imul   0x10(%ebp),%eax
  801466:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801468:	0f b6 11             	movzbl (%ecx),%edx
  80146b:	8d 72 d0             	lea    -0x30(%edx),%esi
  80146e:	89 f3                	mov    %esi,%ebx
  801470:	80 fb 09             	cmp    $0x9,%bl
  801473:	77 d5                	ja     80144a <strtol+0x7c>
			dig = *s - '0';
  801475:	0f be d2             	movsbl %dl,%edx
  801478:	83 ea 30             	sub    $0x30,%edx
  80147b:	eb dd                	jmp    80145a <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  80147d:	8d 72 bf             	lea    -0x41(%edx),%esi
  801480:	89 f3                	mov    %esi,%ebx
  801482:	80 fb 19             	cmp    $0x19,%bl
  801485:	77 08                	ja     80148f <strtol+0xc1>
			dig = *s - 'A' + 10;
  801487:	0f be d2             	movsbl %dl,%edx
  80148a:	83 ea 37             	sub    $0x37,%edx
  80148d:	eb cb                	jmp    80145a <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  80148f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801493:	74 05                	je     80149a <strtol+0xcc>
		*endptr = (char *) s;
  801495:	8b 75 0c             	mov    0xc(%ebp),%esi
  801498:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  80149a:	89 c2                	mov    %eax,%edx
  80149c:	f7 da                	neg    %edx
  80149e:	85 ff                	test   %edi,%edi
  8014a0:	0f 45 c2             	cmovne %edx,%eax
}
  8014a3:	5b                   	pop    %ebx
  8014a4:	5e                   	pop    %esi
  8014a5:	5f                   	pop    %edi
  8014a6:	5d                   	pop    %ebp
  8014a7:	c3                   	ret    

008014a8 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8014a8:	55                   	push   %ebp
  8014a9:	89 e5                	mov    %esp,%ebp
  8014ab:	57                   	push   %edi
  8014ac:	56                   	push   %esi
  8014ad:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8014b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014b9:	89 c3                	mov    %eax,%ebx
  8014bb:	89 c7                	mov    %eax,%edi
  8014bd:	89 c6                	mov    %eax,%esi
  8014bf:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8014c1:	5b                   	pop    %ebx
  8014c2:	5e                   	pop    %esi
  8014c3:	5f                   	pop    %edi
  8014c4:	5d                   	pop    %ebp
  8014c5:	c3                   	ret    

008014c6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8014c6:	55                   	push   %ebp
  8014c7:	89 e5                	mov    %esp,%ebp
  8014c9:	57                   	push   %edi
  8014ca:	56                   	push   %esi
  8014cb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8014d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8014d6:	89 d1                	mov    %edx,%ecx
  8014d8:	89 d3                	mov    %edx,%ebx
  8014da:	89 d7                	mov    %edx,%edi
  8014dc:	89 d6                	mov    %edx,%esi
  8014de:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8014e0:	5b                   	pop    %ebx
  8014e1:	5e                   	pop    %esi
  8014e2:	5f                   	pop    %edi
  8014e3:	5d                   	pop    %ebp
  8014e4:	c3                   	ret    

008014e5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
  8014e8:	57                   	push   %edi
  8014e9:	56                   	push   %esi
  8014ea:	53                   	push   %ebx
  8014eb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8014ee:	b9 00 00 00 00       	mov    $0x0,%ecx
  8014f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f6:	b8 03 00 00 00       	mov    $0x3,%eax
  8014fb:	89 cb                	mov    %ecx,%ebx
  8014fd:	89 cf                	mov    %ecx,%edi
  8014ff:	89 ce                	mov    %ecx,%esi
  801501:	cd 30                	int    $0x30
	if(check && ret > 0)
  801503:	85 c0                	test   %eax,%eax
  801505:	7f 08                	jg     80150f <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801507:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80150a:	5b                   	pop    %ebx
  80150b:	5e                   	pop    %esi
  80150c:	5f                   	pop    %edi
  80150d:	5d                   	pop    %ebp
  80150e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80150f:	83 ec 0c             	sub    $0xc,%esp
  801512:	50                   	push   %eax
  801513:	6a 03                	push   $0x3
  801515:	68 48 36 80 00       	push   $0x803648
  80151a:	6a 43                	push   $0x43
  80151c:	68 65 36 80 00       	push   $0x803665
  801521:	e8 f7 f3 ff ff       	call   80091d <_panic>

00801526 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801526:	55                   	push   %ebp
  801527:	89 e5                	mov    %esp,%ebp
  801529:	57                   	push   %edi
  80152a:	56                   	push   %esi
  80152b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80152c:	ba 00 00 00 00       	mov    $0x0,%edx
  801531:	b8 02 00 00 00       	mov    $0x2,%eax
  801536:	89 d1                	mov    %edx,%ecx
  801538:	89 d3                	mov    %edx,%ebx
  80153a:	89 d7                	mov    %edx,%edi
  80153c:	89 d6                	mov    %edx,%esi
  80153e:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801540:	5b                   	pop    %ebx
  801541:	5e                   	pop    %esi
  801542:	5f                   	pop    %edi
  801543:	5d                   	pop    %ebp
  801544:	c3                   	ret    

00801545 <sys_yield>:

void
sys_yield(void)
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
  801548:	57                   	push   %edi
  801549:	56                   	push   %esi
  80154a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80154b:	ba 00 00 00 00       	mov    $0x0,%edx
  801550:	b8 0b 00 00 00       	mov    $0xb,%eax
  801555:	89 d1                	mov    %edx,%ecx
  801557:	89 d3                	mov    %edx,%ebx
  801559:	89 d7                	mov    %edx,%edi
  80155b:	89 d6                	mov    %edx,%esi
  80155d:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80155f:	5b                   	pop    %ebx
  801560:	5e                   	pop    %esi
  801561:	5f                   	pop    %edi
  801562:	5d                   	pop    %ebp
  801563:	c3                   	ret    

00801564 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
  801567:	57                   	push   %edi
  801568:	56                   	push   %esi
  801569:	53                   	push   %ebx
  80156a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80156d:	be 00 00 00 00       	mov    $0x0,%esi
  801572:	8b 55 08             	mov    0x8(%ebp),%edx
  801575:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801578:	b8 04 00 00 00       	mov    $0x4,%eax
  80157d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801580:	89 f7                	mov    %esi,%edi
  801582:	cd 30                	int    $0x30
	if(check && ret > 0)
  801584:	85 c0                	test   %eax,%eax
  801586:	7f 08                	jg     801590 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801588:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80158b:	5b                   	pop    %ebx
  80158c:	5e                   	pop    %esi
  80158d:	5f                   	pop    %edi
  80158e:	5d                   	pop    %ebp
  80158f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801590:	83 ec 0c             	sub    $0xc,%esp
  801593:	50                   	push   %eax
  801594:	6a 04                	push   $0x4
  801596:	68 48 36 80 00       	push   $0x803648
  80159b:	6a 43                	push   $0x43
  80159d:	68 65 36 80 00       	push   $0x803665
  8015a2:	e8 76 f3 ff ff       	call   80091d <_panic>

008015a7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8015a7:	55                   	push   %ebp
  8015a8:	89 e5                	mov    %esp,%ebp
  8015aa:	57                   	push   %edi
  8015ab:	56                   	push   %esi
  8015ac:	53                   	push   %ebx
  8015ad:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8015b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8015b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015b6:	b8 05 00 00 00       	mov    $0x5,%eax
  8015bb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8015be:	8b 7d 14             	mov    0x14(%ebp),%edi
  8015c1:	8b 75 18             	mov    0x18(%ebp),%esi
  8015c4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8015c6:	85 c0                	test   %eax,%eax
  8015c8:	7f 08                	jg     8015d2 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8015ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015cd:	5b                   	pop    %ebx
  8015ce:	5e                   	pop    %esi
  8015cf:	5f                   	pop    %edi
  8015d0:	5d                   	pop    %ebp
  8015d1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8015d2:	83 ec 0c             	sub    $0xc,%esp
  8015d5:	50                   	push   %eax
  8015d6:	6a 05                	push   $0x5
  8015d8:	68 48 36 80 00       	push   $0x803648
  8015dd:	6a 43                	push   $0x43
  8015df:	68 65 36 80 00       	push   $0x803665
  8015e4:	e8 34 f3 ff ff       	call   80091d <_panic>

008015e9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8015e9:	55                   	push   %ebp
  8015ea:	89 e5                	mov    %esp,%ebp
  8015ec:	57                   	push   %edi
  8015ed:	56                   	push   %esi
  8015ee:	53                   	push   %ebx
  8015ef:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8015f2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8015fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015fd:	b8 06 00 00 00       	mov    $0x6,%eax
  801602:	89 df                	mov    %ebx,%edi
  801604:	89 de                	mov    %ebx,%esi
  801606:	cd 30                	int    $0x30
	if(check && ret > 0)
  801608:	85 c0                	test   %eax,%eax
  80160a:	7f 08                	jg     801614 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80160c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80160f:	5b                   	pop    %ebx
  801610:	5e                   	pop    %esi
  801611:	5f                   	pop    %edi
  801612:	5d                   	pop    %ebp
  801613:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801614:	83 ec 0c             	sub    $0xc,%esp
  801617:	50                   	push   %eax
  801618:	6a 06                	push   $0x6
  80161a:	68 48 36 80 00       	push   $0x803648
  80161f:	6a 43                	push   $0x43
  801621:	68 65 36 80 00       	push   $0x803665
  801626:	e8 f2 f2 ff ff       	call   80091d <_panic>

0080162b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
  80162e:	57                   	push   %edi
  80162f:	56                   	push   %esi
  801630:	53                   	push   %ebx
  801631:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801634:	bb 00 00 00 00       	mov    $0x0,%ebx
  801639:	8b 55 08             	mov    0x8(%ebp),%edx
  80163c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80163f:	b8 08 00 00 00       	mov    $0x8,%eax
  801644:	89 df                	mov    %ebx,%edi
  801646:	89 de                	mov    %ebx,%esi
  801648:	cd 30                	int    $0x30
	if(check && ret > 0)
  80164a:	85 c0                	test   %eax,%eax
  80164c:	7f 08                	jg     801656 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80164e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801651:	5b                   	pop    %ebx
  801652:	5e                   	pop    %esi
  801653:	5f                   	pop    %edi
  801654:	5d                   	pop    %ebp
  801655:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801656:	83 ec 0c             	sub    $0xc,%esp
  801659:	50                   	push   %eax
  80165a:	6a 08                	push   $0x8
  80165c:	68 48 36 80 00       	push   $0x803648
  801661:	6a 43                	push   $0x43
  801663:	68 65 36 80 00       	push   $0x803665
  801668:	e8 b0 f2 ff ff       	call   80091d <_panic>

0080166d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
  801670:	57                   	push   %edi
  801671:	56                   	push   %esi
  801672:	53                   	push   %ebx
  801673:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801676:	bb 00 00 00 00       	mov    $0x0,%ebx
  80167b:	8b 55 08             	mov    0x8(%ebp),%edx
  80167e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801681:	b8 09 00 00 00       	mov    $0x9,%eax
  801686:	89 df                	mov    %ebx,%edi
  801688:	89 de                	mov    %ebx,%esi
  80168a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80168c:	85 c0                	test   %eax,%eax
  80168e:	7f 08                	jg     801698 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801690:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801693:	5b                   	pop    %ebx
  801694:	5e                   	pop    %esi
  801695:	5f                   	pop    %edi
  801696:	5d                   	pop    %ebp
  801697:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801698:	83 ec 0c             	sub    $0xc,%esp
  80169b:	50                   	push   %eax
  80169c:	6a 09                	push   $0x9
  80169e:	68 48 36 80 00       	push   $0x803648
  8016a3:	6a 43                	push   $0x43
  8016a5:	68 65 36 80 00       	push   $0x803665
  8016aa:	e8 6e f2 ff ff       	call   80091d <_panic>

008016af <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
  8016b2:	57                   	push   %edi
  8016b3:	56                   	push   %esi
  8016b4:	53                   	push   %ebx
  8016b5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8016b8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8016c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016c3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8016c8:	89 df                	mov    %ebx,%edi
  8016ca:	89 de                	mov    %ebx,%esi
  8016cc:	cd 30                	int    $0x30
	if(check && ret > 0)
  8016ce:	85 c0                	test   %eax,%eax
  8016d0:	7f 08                	jg     8016da <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8016d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016d5:	5b                   	pop    %ebx
  8016d6:	5e                   	pop    %esi
  8016d7:	5f                   	pop    %edi
  8016d8:	5d                   	pop    %ebp
  8016d9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8016da:	83 ec 0c             	sub    $0xc,%esp
  8016dd:	50                   	push   %eax
  8016de:	6a 0a                	push   $0xa
  8016e0:	68 48 36 80 00       	push   $0x803648
  8016e5:	6a 43                	push   $0x43
  8016e7:	68 65 36 80 00       	push   $0x803665
  8016ec:	e8 2c f2 ff ff       	call   80091d <_panic>

008016f1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
  8016f4:	57                   	push   %edi
  8016f5:	56                   	push   %esi
  8016f6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8016f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8016fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016fd:	b8 0c 00 00 00       	mov    $0xc,%eax
  801702:	be 00 00 00 00       	mov    $0x0,%esi
  801707:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80170a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80170d:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80170f:	5b                   	pop    %ebx
  801710:	5e                   	pop    %esi
  801711:	5f                   	pop    %edi
  801712:	5d                   	pop    %ebp
  801713:	c3                   	ret    

00801714 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
  801717:	57                   	push   %edi
  801718:	56                   	push   %esi
  801719:	53                   	push   %ebx
  80171a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80171d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801722:	8b 55 08             	mov    0x8(%ebp),%edx
  801725:	b8 0d 00 00 00       	mov    $0xd,%eax
  80172a:	89 cb                	mov    %ecx,%ebx
  80172c:	89 cf                	mov    %ecx,%edi
  80172e:	89 ce                	mov    %ecx,%esi
  801730:	cd 30                	int    $0x30
	if(check && ret > 0)
  801732:	85 c0                	test   %eax,%eax
  801734:	7f 08                	jg     80173e <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801736:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801739:	5b                   	pop    %ebx
  80173a:	5e                   	pop    %esi
  80173b:	5f                   	pop    %edi
  80173c:	5d                   	pop    %ebp
  80173d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80173e:	83 ec 0c             	sub    $0xc,%esp
  801741:	50                   	push   %eax
  801742:	6a 0d                	push   $0xd
  801744:	68 48 36 80 00       	push   $0x803648
  801749:	6a 43                	push   $0x43
  80174b:	68 65 36 80 00       	push   $0x803665
  801750:	e8 c8 f1 ff ff       	call   80091d <_panic>

00801755 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801755:	55                   	push   %ebp
  801756:	89 e5                	mov    %esp,%ebp
  801758:	57                   	push   %edi
  801759:	56                   	push   %esi
  80175a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80175b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801760:	8b 55 08             	mov    0x8(%ebp),%edx
  801763:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801766:	b8 0e 00 00 00       	mov    $0xe,%eax
  80176b:	89 df                	mov    %ebx,%edi
  80176d:	89 de                	mov    %ebx,%esi
  80176f:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801771:	5b                   	pop    %ebx
  801772:	5e                   	pop    %esi
  801773:	5f                   	pop    %edi
  801774:	5d                   	pop    %ebp
  801775:	c3                   	ret    

00801776 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
  801779:	57                   	push   %edi
  80177a:	56                   	push   %esi
  80177b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80177c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801781:	8b 55 08             	mov    0x8(%ebp),%edx
  801784:	b8 0f 00 00 00       	mov    $0xf,%eax
  801789:	89 cb                	mov    %ecx,%ebx
  80178b:	89 cf                	mov    %ecx,%edi
  80178d:	89 ce                	mov    %ecx,%esi
  80178f:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801791:	5b                   	pop    %ebx
  801792:	5e                   	pop    %esi
  801793:	5f                   	pop    %edi
  801794:	5d                   	pop    %ebp
  801795:	c3                   	ret    

00801796 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
  801799:	57                   	push   %edi
  80179a:	56                   	push   %esi
  80179b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80179c:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a1:	b8 10 00 00 00       	mov    $0x10,%eax
  8017a6:	89 d1                	mov    %edx,%ecx
  8017a8:	89 d3                	mov    %edx,%ebx
  8017aa:	89 d7                	mov    %edx,%edi
  8017ac:	89 d6                	mov    %edx,%esi
  8017ae:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8017b0:	5b                   	pop    %ebx
  8017b1:	5e                   	pop    %esi
  8017b2:	5f                   	pop    %edi
  8017b3:	5d                   	pop    %ebp
  8017b4:	c3                   	ret    

008017b5 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8017b5:	55                   	push   %ebp
  8017b6:	89 e5                	mov    %esp,%ebp
  8017b8:	57                   	push   %edi
  8017b9:	56                   	push   %esi
  8017ba:	53                   	push   %ebx
	asm volatile("int %1\n"
  8017bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8017c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017c6:	b8 11 00 00 00       	mov    $0x11,%eax
  8017cb:	89 df                	mov    %ebx,%edi
  8017cd:	89 de                	mov    %ebx,%esi
  8017cf:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8017d1:	5b                   	pop    %ebx
  8017d2:	5e                   	pop    %esi
  8017d3:	5f                   	pop    %edi
  8017d4:	5d                   	pop    %ebp
  8017d5:	c3                   	ret    

008017d6 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
  8017d9:	57                   	push   %edi
  8017da:	56                   	push   %esi
  8017db:	53                   	push   %ebx
	asm volatile("int %1\n"
  8017dc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8017e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017e7:	b8 12 00 00 00       	mov    $0x12,%eax
  8017ec:	89 df                	mov    %ebx,%edi
  8017ee:	89 de                	mov    %ebx,%esi
  8017f0:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8017f2:	5b                   	pop    %ebx
  8017f3:	5e                   	pop    %esi
  8017f4:	5f                   	pop    %edi
  8017f5:	5d                   	pop    %ebp
  8017f6:	c3                   	ret    

008017f7 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
  8017fa:	57                   	push   %edi
  8017fb:	56                   	push   %esi
  8017fc:	53                   	push   %ebx
  8017fd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801800:	bb 00 00 00 00       	mov    $0x0,%ebx
  801805:	8b 55 08             	mov    0x8(%ebp),%edx
  801808:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80180b:	b8 13 00 00 00       	mov    $0x13,%eax
  801810:	89 df                	mov    %ebx,%edi
  801812:	89 de                	mov    %ebx,%esi
  801814:	cd 30                	int    $0x30
	if(check && ret > 0)
  801816:	85 c0                	test   %eax,%eax
  801818:	7f 08                	jg     801822 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80181a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80181d:	5b                   	pop    %ebx
  80181e:	5e                   	pop    %esi
  80181f:	5f                   	pop    %edi
  801820:	5d                   	pop    %ebp
  801821:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801822:	83 ec 0c             	sub    $0xc,%esp
  801825:	50                   	push   %eax
  801826:	6a 13                	push   $0x13
  801828:	68 48 36 80 00       	push   $0x803648
  80182d:	6a 43                	push   $0x43
  80182f:	68 65 36 80 00       	push   $0x803665
  801834:	e8 e4 f0 ff ff       	call   80091d <_panic>

00801839 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
  80183c:	57                   	push   %edi
  80183d:	56                   	push   %esi
  80183e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80183f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801844:	8b 55 08             	mov    0x8(%ebp),%edx
  801847:	b8 14 00 00 00       	mov    $0x14,%eax
  80184c:	89 cb                	mov    %ecx,%ebx
  80184e:	89 cf                	mov    %ecx,%edi
  801850:	89 ce                	mov    %ecx,%esi
  801852:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801854:	5b                   	pop    %ebx
  801855:	5e                   	pop    %esi
  801856:	5f                   	pop    %edi
  801857:	5d                   	pop    %ebp
  801858:	c3                   	ret    

00801859 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80185c:	8b 45 08             	mov    0x8(%ebp),%eax
  80185f:	05 00 00 00 30       	add    $0x30000000,%eax
  801864:	c1 e8 0c             	shr    $0xc,%eax
}
  801867:	5d                   	pop    %ebp
  801868:	c3                   	ret    

00801869 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80186c:	8b 45 08             	mov    0x8(%ebp),%eax
  80186f:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801874:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801879:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80187e:	5d                   	pop    %ebp
  80187f:	c3                   	ret    

00801880 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
  801883:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801888:	89 c2                	mov    %eax,%edx
  80188a:	c1 ea 16             	shr    $0x16,%edx
  80188d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801894:	f6 c2 01             	test   $0x1,%dl
  801897:	74 2d                	je     8018c6 <fd_alloc+0x46>
  801899:	89 c2                	mov    %eax,%edx
  80189b:	c1 ea 0c             	shr    $0xc,%edx
  80189e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018a5:	f6 c2 01             	test   $0x1,%dl
  8018a8:	74 1c                	je     8018c6 <fd_alloc+0x46>
  8018aa:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8018af:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8018b4:	75 d2                	jne    801888 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8018b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8018bf:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8018c4:	eb 0a                	jmp    8018d0 <fd_alloc+0x50>
			*fd_store = fd;
  8018c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018c9:	89 01                	mov    %eax,(%ecx)
			return 0;
  8018cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018d0:	5d                   	pop    %ebp
  8018d1:	c3                   	ret    

008018d2 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
  8018d5:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8018d8:	83 f8 1f             	cmp    $0x1f,%eax
  8018db:	77 30                	ja     80190d <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8018dd:	c1 e0 0c             	shl    $0xc,%eax
  8018e0:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8018e5:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8018eb:	f6 c2 01             	test   $0x1,%dl
  8018ee:	74 24                	je     801914 <fd_lookup+0x42>
  8018f0:	89 c2                	mov    %eax,%edx
  8018f2:	c1 ea 0c             	shr    $0xc,%edx
  8018f5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018fc:	f6 c2 01             	test   $0x1,%dl
  8018ff:	74 1a                	je     80191b <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801901:	8b 55 0c             	mov    0xc(%ebp),%edx
  801904:	89 02                	mov    %eax,(%edx)
	return 0;
  801906:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80190b:	5d                   	pop    %ebp
  80190c:	c3                   	ret    
		return -E_INVAL;
  80190d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801912:	eb f7                	jmp    80190b <fd_lookup+0x39>
		return -E_INVAL;
  801914:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801919:	eb f0                	jmp    80190b <fd_lookup+0x39>
  80191b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801920:	eb e9                	jmp    80190b <fd_lookup+0x39>

00801922 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
  801925:	83 ec 08             	sub    $0x8,%esp
  801928:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80192b:	ba 00 00 00 00       	mov    $0x0,%edx
  801930:	b8 24 40 80 00       	mov    $0x804024,%eax
		if (devtab[i]->dev_id == dev_id) {
  801935:	39 08                	cmp    %ecx,(%eax)
  801937:	74 38                	je     801971 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801939:	83 c2 01             	add    $0x1,%edx
  80193c:	8b 04 95 f0 36 80 00 	mov    0x8036f0(,%edx,4),%eax
  801943:	85 c0                	test   %eax,%eax
  801945:	75 ee                	jne    801935 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801947:	a1 1c 50 80 00       	mov    0x80501c,%eax
  80194c:	8b 40 48             	mov    0x48(%eax),%eax
  80194f:	83 ec 04             	sub    $0x4,%esp
  801952:	51                   	push   %ecx
  801953:	50                   	push   %eax
  801954:	68 74 36 80 00       	push   $0x803674
  801959:	e8 b5 f0 ff ff       	call   800a13 <cprintf>
	*dev = 0;
  80195e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801961:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801967:	83 c4 10             	add    $0x10,%esp
  80196a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80196f:	c9                   	leave  
  801970:	c3                   	ret    
			*dev = devtab[i];
  801971:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801974:	89 01                	mov    %eax,(%ecx)
			return 0;
  801976:	b8 00 00 00 00       	mov    $0x0,%eax
  80197b:	eb f2                	jmp    80196f <dev_lookup+0x4d>

0080197d <fd_close>:
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
  801980:	57                   	push   %edi
  801981:	56                   	push   %esi
  801982:	53                   	push   %ebx
  801983:	83 ec 24             	sub    $0x24,%esp
  801986:	8b 75 08             	mov    0x8(%ebp),%esi
  801989:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80198c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80198f:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801990:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801996:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801999:	50                   	push   %eax
  80199a:	e8 33 ff ff ff       	call   8018d2 <fd_lookup>
  80199f:	89 c3                	mov    %eax,%ebx
  8019a1:	83 c4 10             	add    $0x10,%esp
  8019a4:	85 c0                	test   %eax,%eax
  8019a6:	78 05                	js     8019ad <fd_close+0x30>
	    || fd != fd2)
  8019a8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8019ab:	74 16                	je     8019c3 <fd_close+0x46>
		return (must_exist ? r : 0);
  8019ad:	89 f8                	mov    %edi,%eax
  8019af:	84 c0                	test   %al,%al
  8019b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b6:	0f 44 d8             	cmove  %eax,%ebx
}
  8019b9:	89 d8                	mov    %ebx,%eax
  8019bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019be:	5b                   	pop    %ebx
  8019bf:	5e                   	pop    %esi
  8019c0:	5f                   	pop    %edi
  8019c1:	5d                   	pop    %ebp
  8019c2:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8019c3:	83 ec 08             	sub    $0x8,%esp
  8019c6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8019c9:	50                   	push   %eax
  8019ca:	ff 36                	pushl  (%esi)
  8019cc:	e8 51 ff ff ff       	call   801922 <dev_lookup>
  8019d1:	89 c3                	mov    %eax,%ebx
  8019d3:	83 c4 10             	add    $0x10,%esp
  8019d6:	85 c0                	test   %eax,%eax
  8019d8:	78 1a                	js     8019f4 <fd_close+0x77>
		if (dev->dev_close)
  8019da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019dd:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8019e0:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8019e5:	85 c0                	test   %eax,%eax
  8019e7:	74 0b                	je     8019f4 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8019e9:	83 ec 0c             	sub    $0xc,%esp
  8019ec:	56                   	push   %esi
  8019ed:	ff d0                	call   *%eax
  8019ef:	89 c3                	mov    %eax,%ebx
  8019f1:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8019f4:	83 ec 08             	sub    $0x8,%esp
  8019f7:	56                   	push   %esi
  8019f8:	6a 00                	push   $0x0
  8019fa:	e8 ea fb ff ff       	call   8015e9 <sys_page_unmap>
	return r;
  8019ff:	83 c4 10             	add    $0x10,%esp
  801a02:	eb b5                	jmp    8019b9 <fd_close+0x3c>

00801a04 <close>:

int
close(int fdnum)
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
  801a07:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a0a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a0d:	50                   	push   %eax
  801a0e:	ff 75 08             	pushl  0x8(%ebp)
  801a11:	e8 bc fe ff ff       	call   8018d2 <fd_lookup>
  801a16:	83 c4 10             	add    $0x10,%esp
  801a19:	85 c0                	test   %eax,%eax
  801a1b:	79 02                	jns    801a1f <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    
		return fd_close(fd, 1);
  801a1f:	83 ec 08             	sub    $0x8,%esp
  801a22:	6a 01                	push   $0x1
  801a24:	ff 75 f4             	pushl  -0xc(%ebp)
  801a27:	e8 51 ff ff ff       	call   80197d <fd_close>
  801a2c:	83 c4 10             	add    $0x10,%esp
  801a2f:	eb ec                	jmp    801a1d <close+0x19>

00801a31 <close_all>:

void
close_all(void)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
  801a34:	53                   	push   %ebx
  801a35:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801a38:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801a3d:	83 ec 0c             	sub    $0xc,%esp
  801a40:	53                   	push   %ebx
  801a41:	e8 be ff ff ff       	call   801a04 <close>
	for (i = 0; i < MAXFD; i++)
  801a46:	83 c3 01             	add    $0x1,%ebx
  801a49:	83 c4 10             	add    $0x10,%esp
  801a4c:	83 fb 20             	cmp    $0x20,%ebx
  801a4f:	75 ec                	jne    801a3d <close_all+0xc>
}
  801a51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
  801a59:	57                   	push   %edi
  801a5a:	56                   	push   %esi
  801a5b:	53                   	push   %ebx
  801a5c:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801a5f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801a62:	50                   	push   %eax
  801a63:	ff 75 08             	pushl  0x8(%ebp)
  801a66:	e8 67 fe ff ff       	call   8018d2 <fd_lookup>
  801a6b:	89 c3                	mov    %eax,%ebx
  801a6d:	83 c4 10             	add    $0x10,%esp
  801a70:	85 c0                	test   %eax,%eax
  801a72:	0f 88 81 00 00 00    	js     801af9 <dup+0xa3>
		return r;
	close(newfdnum);
  801a78:	83 ec 0c             	sub    $0xc,%esp
  801a7b:	ff 75 0c             	pushl  0xc(%ebp)
  801a7e:	e8 81 ff ff ff       	call   801a04 <close>

	newfd = INDEX2FD(newfdnum);
  801a83:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a86:	c1 e6 0c             	shl    $0xc,%esi
  801a89:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801a8f:	83 c4 04             	add    $0x4,%esp
  801a92:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a95:	e8 cf fd ff ff       	call   801869 <fd2data>
  801a9a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801a9c:	89 34 24             	mov    %esi,(%esp)
  801a9f:	e8 c5 fd ff ff       	call   801869 <fd2data>
  801aa4:	83 c4 10             	add    $0x10,%esp
  801aa7:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801aa9:	89 d8                	mov    %ebx,%eax
  801aab:	c1 e8 16             	shr    $0x16,%eax
  801aae:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801ab5:	a8 01                	test   $0x1,%al
  801ab7:	74 11                	je     801aca <dup+0x74>
  801ab9:	89 d8                	mov    %ebx,%eax
  801abb:	c1 e8 0c             	shr    $0xc,%eax
  801abe:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801ac5:	f6 c2 01             	test   $0x1,%dl
  801ac8:	75 39                	jne    801b03 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801aca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801acd:	89 d0                	mov    %edx,%eax
  801acf:	c1 e8 0c             	shr    $0xc,%eax
  801ad2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801ad9:	83 ec 0c             	sub    $0xc,%esp
  801adc:	25 07 0e 00 00       	and    $0xe07,%eax
  801ae1:	50                   	push   %eax
  801ae2:	56                   	push   %esi
  801ae3:	6a 00                	push   $0x0
  801ae5:	52                   	push   %edx
  801ae6:	6a 00                	push   $0x0
  801ae8:	e8 ba fa ff ff       	call   8015a7 <sys_page_map>
  801aed:	89 c3                	mov    %eax,%ebx
  801aef:	83 c4 20             	add    $0x20,%esp
  801af2:	85 c0                	test   %eax,%eax
  801af4:	78 31                	js     801b27 <dup+0xd1>
		goto err;

	return newfdnum;
  801af6:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801af9:	89 d8                	mov    %ebx,%eax
  801afb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801afe:	5b                   	pop    %ebx
  801aff:	5e                   	pop    %esi
  801b00:	5f                   	pop    %edi
  801b01:	5d                   	pop    %ebp
  801b02:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801b03:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801b0a:	83 ec 0c             	sub    $0xc,%esp
  801b0d:	25 07 0e 00 00       	and    $0xe07,%eax
  801b12:	50                   	push   %eax
  801b13:	57                   	push   %edi
  801b14:	6a 00                	push   $0x0
  801b16:	53                   	push   %ebx
  801b17:	6a 00                	push   $0x0
  801b19:	e8 89 fa ff ff       	call   8015a7 <sys_page_map>
  801b1e:	89 c3                	mov    %eax,%ebx
  801b20:	83 c4 20             	add    $0x20,%esp
  801b23:	85 c0                	test   %eax,%eax
  801b25:	79 a3                	jns    801aca <dup+0x74>
	sys_page_unmap(0, newfd);
  801b27:	83 ec 08             	sub    $0x8,%esp
  801b2a:	56                   	push   %esi
  801b2b:	6a 00                	push   $0x0
  801b2d:	e8 b7 fa ff ff       	call   8015e9 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801b32:	83 c4 08             	add    $0x8,%esp
  801b35:	57                   	push   %edi
  801b36:	6a 00                	push   $0x0
  801b38:	e8 ac fa ff ff       	call   8015e9 <sys_page_unmap>
	return r;
  801b3d:	83 c4 10             	add    $0x10,%esp
  801b40:	eb b7                	jmp    801af9 <dup+0xa3>

00801b42 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
  801b45:	53                   	push   %ebx
  801b46:	83 ec 1c             	sub    $0x1c,%esp
  801b49:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b4c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b4f:	50                   	push   %eax
  801b50:	53                   	push   %ebx
  801b51:	e8 7c fd ff ff       	call   8018d2 <fd_lookup>
  801b56:	83 c4 10             	add    $0x10,%esp
  801b59:	85 c0                	test   %eax,%eax
  801b5b:	78 3f                	js     801b9c <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b5d:	83 ec 08             	sub    $0x8,%esp
  801b60:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b63:	50                   	push   %eax
  801b64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b67:	ff 30                	pushl  (%eax)
  801b69:	e8 b4 fd ff ff       	call   801922 <dev_lookup>
  801b6e:	83 c4 10             	add    $0x10,%esp
  801b71:	85 c0                	test   %eax,%eax
  801b73:	78 27                	js     801b9c <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b75:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b78:	8b 42 08             	mov    0x8(%edx),%eax
  801b7b:	83 e0 03             	and    $0x3,%eax
  801b7e:	83 f8 01             	cmp    $0x1,%eax
  801b81:	74 1e                	je     801ba1 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b86:	8b 40 08             	mov    0x8(%eax),%eax
  801b89:	85 c0                	test   %eax,%eax
  801b8b:	74 35                	je     801bc2 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801b8d:	83 ec 04             	sub    $0x4,%esp
  801b90:	ff 75 10             	pushl  0x10(%ebp)
  801b93:	ff 75 0c             	pushl  0xc(%ebp)
  801b96:	52                   	push   %edx
  801b97:	ff d0                	call   *%eax
  801b99:	83 c4 10             	add    $0x10,%esp
}
  801b9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801ba1:	a1 1c 50 80 00       	mov    0x80501c,%eax
  801ba6:	8b 40 48             	mov    0x48(%eax),%eax
  801ba9:	83 ec 04             	sub    $0x4,%esp
  801bac:	53                   	push   %ebx
  801bad:	50                   	push   %eax
  801bae:	68 b5 36 80 00       	push   $0x8036b5
  801bb3:	e8 5b ee ff ff       	call   800a13 <cprintf>
		return -E_INVAL;
  801bb8:	83 c4 10             	add    $0x10,%esp
  801bbb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bc0:	eb da                	jmp    801b9c <read+0x5a>
		return -E_NOT_SUPP;
  801bc2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bc7:	eb d3                	jmp    801b9c <read+0x5a>

00801bc9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
  801bcc:	57                   	push   %edi
  801bcd:	56                   	push   %esi
  801bce:	53                   	push   %ebx
  801bcf:	83 ec 0c             	sub    $0xc,%esp
  801bd2:	8b 7d 08             	mov    0x8(%ebp),%edi
  801bd5:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801bd8:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bdd:	39 f3                	cmp    %esi,%ebx
  801bdf:	73 23                	jae    801c04 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801be1:	83 ec 04             	sub    $0x4,%esp
  801be4:	89 f0                	mov    %esi,%eax
  801be6:	29 d8                	sub    %ebx,%eax
  801be8:	50                   	push   %eax
  801be9:	89 d8                	mov    %ebx,%eax
  801beb:	03 45 0c             	add    0xc(%ebp),%eax
  801bee:	50                   	push   %eax
  801bef:	57                   	push   %edi
  801bf0:	e8 4d ff ff ff       	call   801b42 <read>
		if (m < 0)
  801bf5:	83 c4 10             	add    $0x10,%esp
  801bf8:	85 c0                	test   %eax,%eax
  801bfa:	78 06                	js     801c02 <readn+0x39>
			return m;
		if (m == 0)
  801bfc:	74 06                	je     801c04 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801bfe:	01 c3                	add    %eax,%ebx
  801c00:	eb db                	jmp    801bdd <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801c02:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801c04:	89 d8                	mov    %ebx,%eax
  801c06:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c09:	5b                   	pop    %ebx
  801c0a:	5e                   	pop    %esi
  801c0b:	5f                   	pop    %edi
  801c0c:	5d                   	pop    %ebp
  801c0d:	c3                   	ret    

00801c0e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
  801c11:	53                   	push   %ebx
  801c12:	83 ec 1c             	sub    $0x1c,%esp
  801c15:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c18:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c1b:	50                   	push   %eax
  801c1c:	53                   	push   %ebx
  801c1d:	e8 b0 fc ff ff       	call   8018d2 <fd_lookup>
  801c22:	83 c4 10             	add    $0x10,%esp
  801c25:	85 c0                	test   %eax,%eax
  801c27:	78 3a                	js     801c63 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c29:	83 ec 08             	sub    $0x8,%esp
  801c2c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c2f:	50                   	push   %eax
  801c30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c33:	ff 30                	pushl  (%eax)
  801c35:	e8 e8 fc ff ff       	call   801922 <dev_lookup>
  801c3a:	83 c4 10             	add    $0x10,%esp
  801c3d:	85 c0                	test   %eax,%eax
  801c3f:	78 22                	js     801c63 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c44:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c48:	74 1e                	je     801c68 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801c4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c4d:	8b 52 0c             	mov    0xc(%edx),%edx
  801c50:	85 d2                	test   %edx,%edx
  801c52:	74 35                	je     801c89 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801c54:	83 ec 04             	sub    $0x4,%esp
  801c57:	ff 75 10             	pushl  0x10(%ebp)
  801c5a:	ff 75 0c             	pushl  0xc(%ebp)
  801c5d:	50                   	push   %eax
  801c5e:	ff d2                	call   *%edx
  801c60:	83 c4 10             	add    $0x10,%esp
}
  801c63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c66:	c9                   	leave  
  801c67:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801c68:	a1 1c 50 80 00       	mov    0x80501c,%eax
  801c6d:	8b 40 48             	mov    0x48(%eax),%eax
  801c70:	83 ec 04             	sub    $0x4,%esp
  801c73:	53                   	push   %ebx
  801c74:	50                   	push   %eax
  801c75:	68 d1 36 80 00       	push   $0x8036d1
  801c7a:	e8 94 ed ff ff       	call   800a13 <cprintf>
		return -E_INVAL;
  801c7f:	83 c4 10             	add    $0x10,%esp
  801c82:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c87:	eb da                	jmp    801c63 <write+0x55>
		return -E_NOT_SUPP;
  801c89:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c8e:	eb d3                	jmp    801c63 <write+0x55>

00801c90 <seek>:

int
seek(int fdnum, off_t offset)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c96:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c99:	50                   	push   %eax
  801c9a:	ff 75 08             	pushl  0x8(%ebp)
  801c9d:	e8 30 fc ff ff       	call   8018d2 <fd_lookup>
  801ca2:	83 c4 10             	add    $0x10,%esp
  801ca5:	85 c0                	test   %eax,%eax
  801ca7:	78 0e                	js     801cb7 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801ca9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801caf:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801cb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb7:	c9                   	leave  
  801cb8:	c3                   	ret    

00801cb9 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
  801cbc:	53                   	push   %ebx
  801cbd:	83 ec 1c             	sub    $0x1c,%esp
  801cc0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801cc3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cc6:	50                   	push   %eax
  801cc7:	53                   	push   %ebx
  801cc8:	e8 05 fc ff ff       	call   8018d2 <fd_lookup>
  801ccd:	83 c4 10             	add    $0x10,%esp
  801cd0:	85 c0                	test   %eax,%eax
  801cd2:	78 37                	js     801d0b <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801cd4:	83 ec 08             	sub    $0x8,%esp
  801cd7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cda:	50                   	push   %eax
  801cdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cde:	ff 30                	pushl  (%eax)
  801ce0:	e8 3d fc ff ff       	call   801922 <dev_lookup>
  801ce5:	83 c4 10             	add    $0x10,%esp
  801ce8:	85 c0                	test   %eax,%eax
  801cea:	78 1f                	js     801d0b <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801cec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cef:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801cf3:	74 1b                	je     801d10 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801cf5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cf8:	8b 52 18             	mov    0x18(%edx),%edx
  801cfb:	85 d2                	test   %edx,%edx
  801cfd:	74 32                	je     801d31 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801cff:	83 ec 08             	sub    $0x8,%esp
  801d02:	ff 75 0c             	pushl  0xc(%ebp)
  801d05:	50                   	push   %eax
  801d06:	ff d2                	call   *%edx
  801d08:	83 c4 10             	add    $0x10,%esp
}
  801d0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    
			thisenv->env_id, fdnum);
  801d10:	a1 1c 50 80 00       	mov    0x80501c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801d15:	8b 40 48             	mov    0x48(%eax),%eax
  801d18:	83 ec 04             	sub    $0x4,%esp
  801d1b:	53                   	push   %ebx
  801d1c:	50                   	push   %eax
  801d1d:	68 94 36 80 00       	push   $0x803694
  801d22:	e8 ec ec ff ff       	call   800a13 <cprintf>
		return -E_INVAL;
  801d27:	83 c4 10             	add    $0x10,%esp
  801d2a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d2f:	eb da                	jmp    801d0b <ftruncate+0x52>
		return -E_NOT_SUPP;
  801d31:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d36:	eb d3                	jmp    801d0b <ftruncate+0x52>

00801d38 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
  801d3b:	53                   	push   %ebx
  801d3c:	83 ec 1c             	sub    $0x1c,%esp
  801d3f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d42:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d45:	50                   	push   %eax
  801d46:	ff 75 08             	pushl  0x8(%ebp)
  801d49:	e8 84 fb ff ff       	call   8018d2 <fd_lookup>
  801d4e:	83 c4 10             	add    $0x10,%esp
  801d51:	85 c0                	test   %eax,%eax
  801d53:	78 4b                	js     801da0 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d55:	83 ec 08             	sub    $0x8,%esp
  801d58:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d5b:	50                   	push   %eax
  801d5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d5f:	ff 30                	pushl  (%eax)
  801d61:	e8 bc fb ff ff       	call   801922 <dev_lookup>
  801d66:	83 c4 10             	add    $0x10,%esp
  801d69:	85 c0                	test   %eax,%eax
  801d6b:	78 33                	js     801da0 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d70:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801d74:	74 2f                	je     801da5 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801d76:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801d79:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801d80:	00 00 00 
	stat->st_isdir = 0;
  801d83:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d8a:	00 00 00 
	stat->st_dev = dev;
  801d8d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801d93:	83 ec 08             	sub    $0x8,%esp
  801d96:	53                   	push   %ebx
  801d97:	ff 75 f0             	pushl  -0x10(%ebp)
  801d9a:	ff 50 14             	call   *0x14(%eax)
  801d9d:	83 c4 10             	add    $0x10,%esp
}
  801da0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    
		return -E_NOT_SUPP;
  801da5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801daa:	eb f4                	jmp    801da0 <fstat+0x68>

00801dac <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801dac:	55                   	push   %ebp
  801dad:	89 e5                	mov    %esp,%ebp
  801daf:	56                   	push   %esi
  801db0:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801db1:	83 ec 08             	sub    $0x8,%esp
  801db4:	6a 00                	push   $0x0
  801db6:	ff 75 08             	pushl  0x8(%ebp)
  801db9:	e8 22 02 00 00       	call   801fe0 <open>
  801dbe:	89 c3                	mov    %eax,%ebx
  801dc0:	83 c4 10             	add    $0x10,%esp
  801dc3:	85 c0                	test   %eax,%eax
  801dc5:	78 1b                	js     801de2 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801dc7:	83 ec 08             	sub    $0x8,%esp
  801dca:	ff 75 0c             	pushl  0xc(%ebp)
  801dcd:	50                   	push   %eax
  801dce:	e8 65 ff ff ff       	call   801d38 <fstat>
  801dd3:	89 c6                	mov    %eax,%esi
	close(fd);
  801dd5:	89 1c 24             	mov    %ebx,(%esp)
  801dd8:	e8 27 fc ff ff       	call   801a04 <close>
	return r;
  801ddd:	83 c4 10             	add    $0x10,%esp
  801de0:	89 f3                	mov    %esi,%ebx
}
  801de2:	89 d8                	mov    %ebx,%eax
  801de4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801de7:	5b                   	pop    %ebx
  801de8:	5e                   	pop    %esi
  801de9:	5d                   	pop    %ebp
  801dea:	c3                   	ret    

00801deb <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
  801dee:	56                   	push   %esi
  801def:	53                   	push   %ebx
  801df0:	89 c6                	mov    %eax,%esi
  801df2:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801df4:	83 3d 10 50 80 00 00 	cmpl   $0x0,0x805010
  801dfb:	74 27                	je     801e24 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801dfd:	6a 07                	push   $0x7
  801dff:	68 00 60 80 00       	push   $0x806000
  801e04:	56                   	push   %esi
  801e05:	ff 35 10 50 80 00    	pushl  0x805010
  801e0b:	e8 a1 0e 00 00       	call   802cb1 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801e10:	83 c4 0c             	add    $0xc,%esp
  801e13:	6a 00                	push   $0x0
  801e15:	53                   	push   %ebx
  801e16:	6a 00                	push   $0x0
  801e18:	e8 2b 0e 00 00       	call   802c48 <ipc_recv>
}
  801e1d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e20:	5b                   	pop    %ebx
  801e21:	5e                   	pop    %esi
  801e22:	5d                   	pop    %ebp
  801e23:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801e24:	83 ec 0c             	sub    $0xc,%esp
  801e27:	6a 01                	push   $0x1
  801e29:	e8 db 0e 00 00       	call   802d09 <ipc_find_env>
  801e2e:	a3 10 50 80 00       	mov    %eax,0x805010
  801e33:	83 c4 10             	add    $0x10,%esp
  801e36:	eb c5                	jmp    801dfd <fsipc+0x12>

00801e38 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
  801e3b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e41:	8b 40 0c             	mov    0xc(%eax),%eax
  801e44:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801e49:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e4c:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801e51:	ba 00 00 00 00       	mov    $0x0,%edx
  801e56:	b8 02 00 00 00       	mov    $0x2,%eax
  801e5b:	e8 8b ff ff ff       	call   801deb <fsipc>
}
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <devfile_flush>:
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
  801e65:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e68:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6b:	8b 40 0c             	mov    0xc(%eax),%eax
  801e6e:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801e73:	ba 00 00 00 00       	mov    $0x0,%edx
  801e78:	b8 06 00 00 00       	mov    $0x6,%eax
  801e7d:	e8 69 ff ff ff       	call   801deb <fsipc>
}
  801e82:	c9                   	leave  
  801e83:	c3                   	ret    

00801e84 <devfile_stat>:
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
  801e87:	53                   	push   %ebx
  801e88:	83 ec 04             	sub    $0x4,%esp
  801e8b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e91:	8b 40 0c             	mov    0xc(%eax),%eax
  801e94:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801e99:	ba 00 00 00 00       	mov    $0x0,%edx
  801e9e:	b8 05 00 00 00       	mov    $0x5,%eax
  801ea3:	e8 43 ff ff ff       	call   801deb <fsipc>
  801ea8:	85 c0                	test   %eax,%eax
  801eaa:	78 2c                	js     801ed8 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801eac:	83 ec 08             	sub    $0x8,%esp
  801eaf:	68 00 60 80 00       	push   $0x806000
  801eb4:	53                   	push   %ebx
  801eb5:	e8 b8 f2 ff ff       	call   801172 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801eba:	a1 80 60 80 00       	mov    0x806080,%eax
  801ebf:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801ec5:	a1 84 60 80 00       	mov    0x806084,%eax
  801eca:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801ed0:	83 c4 10             	add    $0x10,%esp
  801ed3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ed8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801edb:	c9                   	leave  
  801edc:	c3                   	ret    

00801edd <devfile_write>:
{
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
  801ee0:	53                   	push   %ebx
  801ee1:	83 ec 08             	sub    $0x8,%esp
  801ee4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eea:	8b 40 0c             	mov    0xc(%eax),%eax
  801eed:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801ef2:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801ef8:	53                   	push   %ebx
  801ef9:	ff 75 0c             	pushl  0xc(%ebp)
  801efc:	68 08 60 80 00       	push   $0x806008
  801f01:	e8 5c f4 ff ff       	call   801362 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801f06:	ba 00 00 00 00       	mov    $0x0,%edx
  801f0b:	b8 04 00 00 00       	mov    $0x4,%eax
  801f10:	e8 d6 fe ff ff       	call   801deb <fsipc>
  801f15:	83 c4 10             	add    $0x10,%esp
  801f18:	85 c0                	test   %eax,%eax
  801f1a:	78 0b                	js     801f27 <devfile_write+0x4a>
	assert(r <= n);
  801f1c:	39 d8                	cmp    %ebx,%eax
  801f1e:	77 0c                	ja     801f2c <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801f20:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f25:	7f 1e                	jg     801f45 <devfile_write+0x68>
}
  801f27:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f2a:	c9                   	leave  
  801f2b:	c3                   	ret    
	assert(r <= n);
  801f2c:	68 04 37 80 00       	push   $0x803704
  801f31:	68 0b 37 80 00       	push   $0x80370b
  801f36:	68 98 00 00 00       	push   $0x98
  801f3b:	68 20 37 80 00       	push   $0x803720
  801f40:	e8 d8 e9 ff ff       	call   80091d <_panic>
	assert(r <= PGSIZE);
  801f45:	68 2b 37 80 00       	push   $0x80372b
  801f4a:	68 0b 37 80 00       	push   $0x80370b
  801f4f:	68 99 00 00 00       	push   $0x99
  801f54:	68 20 37 80 00       	push   $0x803720
  801f59:	e8 bf e9 ff ff       	call   80091d <_panic>

00801f5e <devfile_read>:
{
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
  801f61:	56                   	push   %esi
  801f62:	53                   	push   %ebx
  801f63:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801f66:	8b 45 08             	mov    0x8(%ebp),%eax
  801f69:	8b 40 0c             	mov    0xc(%eax),%eax
  801f6c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801f71:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801f77:	ba 00 00 00 00       	mov    $0x0,%edx
  801f7c:	b8 03 00 00 00       	mov    $0x3,%eax
  801f81:	e8 65 fe ff ff       	call   801deb <fsipc>
  801f86:	89 c3                	mov    %eax,%ebx
  801f88:	85 c0                	test   %eax,%eax
  801f8a:	78 1f                	js     801fab <devfile_read+0x4d>
	assert(r <= n);
  801f8c:	39 f0                	cmp    %esi,%eax
  801f8e:	77 24                	ja     801fb4 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801f90:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f95:	7f 33                	jg     801fca <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801f97:	83 ec 04             	sub    $0x4,%esp
  801f9a:	50                   	push   %eax
  801f9b:	68 00 60 80 00       	push   $0x806000
  801fa0:	ff 75 0c             	pushl  0xc(%ebp)
  801fa3:	e8 58 f3 ff ff       	call   801300 <memmove>
	return r;
  801fa8:	83 c4 10             	add    $0x10,%esp
}
  801fab:	89 d8                	mov    %ebx,%eax
  801fad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fb0:	5b                   	pop    %ebx
  801fb1:	5e                   	pop    %esi
  801fb2:	5d                   	pop    %ebp
  801fb3:	c3                   	ret    
	assert(r <= n);
  801fb4:	68 04 37 80 00       	push   $0x803704
  801fb9:	68 0b 37 80 00       	push   $0x80370b
  801fbe:	6a 7c                	push   $0x7c
  801fc0:	68 20 37 80 00       	push   $0x803720
  801fc5:	e8 53 e9 ff ff       	call   80091d <_panic>
	assert(r <= PGSIZE);
  801fca:	68 2b 37 80 00       	push   $0x80372b
  801fcf:	68 0b 37 80 00       	push   $0x80370b
  801fd4:	6a 7d                	push   $0x7d
  801fd6:	68 20 37 80 00       	push   $0x803720
  801fdb:	e8 3d e9 ff ff       	call   80091d <_panic>

00801fe0 <open>:
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
  801fe3:	56                   	push   %esi
  801fe4:	53                   	push   %ebx
  801fe5:	83 ec 1c             	sub    $0x1c,%esp
  801fe8:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801feb:	56                   	push   %esi
  801fec:	e8 48 f1 ff ff       	call   801139 <strlen>
  801ff1:	83 c4 10             	add    $0x10,%esp
  801ff4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ff9:	7f 6c                	jg     802067 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801ffb:	83 ec 0c             	sub    $0xc,%esp
  801ffe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802001:	50                   	push   %eax
  802002:	e8 79 f8 ff ff       	call   801880 <fd_alloc>
  802007:	89 c3                	mov    %eax,%ebx
  802009:	83 c4 10             	add    $0x10,%esp
  80200c:	85 c0                	test   %eax,%eax
  80200e:	78 3c                	js     80204c <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  802010:	83 ec 08             	sub    $0x8,%esp
  802013:	56                   	push   %esi
  802014:	68 00 60 80 00       	push   $0x806000
  802019:	e8 54 f1 ff ff       	call   801172 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80201e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802021:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802026:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802029:	b8 01 00 00 00       	mov    $0x1,%eax
  80202e:	e8 b8 fd ff ff       	call   801deb <fsipc>
  802033:	89 c3                	mov    %eax,%ebx
  802035:	83 c4 10             	add    $0x10,%esp
  802038:	85 c0                	test   %eax,%eax
  80203a:	78 19                	js     802055 <open+0x75>
	return fd2num(fd);
  80203c:	83 ec 0c             	sub    $0xc,%esp
  80203f:	ff 75 f4             	pushl  -0xc(%ebp)
  802042:	e8 12 f8 ff ff       	call   801859 <fd2num>
  802047:	89 c3                	mov    %eax,%ebx
  802049:	83 c4 10             	add    $0x10,%esp
}
  80204c:	89 d8                	mov    %ebx,%eax
  80204e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802051:	5b                   	pop    %ebx
  802052:	5e                   	pop    %esi
  802053:	5d                   	pop    %ebp
  802054:	c3                   	ret    
		fd_close(fd, 0);
  802055:	83 ec 08             	sub    $0x8,%esp
  802058:	6a 00                	push   $0x0
  80205a:	ff 75 f4             	pushl  -0xc(%ebp)
  80205d:	e8 1b f9 ff ff       	call   80197d <fd_close>
		return r;
  802062:	83 c4 10             	add    $0x10,%esp
  802065:	eb e5                	jmp    80204c <open+0x6c>
		return -E_BAD_PATH;
  802067:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80206c:	eb de                	jmp    80204c <open+0x6c>

0080206e <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
  802071:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802074:	ba 00 00 00 00       	mov    $0x0,%edx
  802079:	b8 08 00 00 00       	mov    $0x8,%eax
  80207e:	e8 68 fd ff ff       	call   801deb <fsipc>
}
  802083:	c9                   	leave  
  802084:	c3                   	ret    

00802085 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802085:	55                   	push   %ebp
  802086:	89 e5                	mov    %esp,%ebp
  802088:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80208b:	68 37 37 80 00       	push   $0x803737
  802090:	ff 75 0c             	pushl  0xc(%ebp)
  802093:	e8 da f0 ff ff       	call   801172 <strcpy>
	return 0;
}
  802098:	b8 00 00 00 00       	mov    $0x0,%eax
  80209d:	c9                   	leave  
  80209e:	c3                   	ret    

0080209f <devsock_close>:
{
  80209f:	55                   	push   %ebp
  8020a0:	89 e5                	mov    %esp,%ebp
  8020a2:	53                   	push   %ebx
  8020a3:	83 ec 10             	sub    $0x10,%esp
  8020a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8020a9:	53                   	push   %ebx
  8020aa:	e8 95 0c 00 00       	call   802d44 <pageref>
  8020af:	83 c4 10             	add    $0x10,%esp
		return 0;
  8020b2:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8020b7:	83 f8 01             	cmp    $0x1,%eax
  8020ba:	74 07                	je     8020c3 <devsock_close+0x24>
}
  8020bc:	89 d0                	mov    %edx,%eax
  8020be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020c1:	c9                   	leave  
  8020c2:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8020c3:	83 ec 0c             	sub    $0xc,%esp
  8020c6:	ff 73 0c             	pushl  0xc(%ebx)
  8020c9:	e8 b9 02 00 00       	call   802387 <nsipc_close>
  8020ce:	89 c2                	mov    %eax,%edx
  8020d0:	83 c4 10             	add    $0x10,%esp
  8020d3:	eb e7                	jmp    8020bc <devsock_close+0x1d>

008020d5 <devsock_write>:
{
  8020d5:	55                   	push   %ebp
  8020d6:	89 e5                	mov    %esp,%ebp
  8020d8:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8020db:	6a 00                	push   $0x0
  8020dd:	ff 75 10             	pushl  0x10(%ebp)
  8020e0:	ff 75 0c             	pushl  0xc(%ebp)
  8020e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e6:	ff 70 0c             	pushl  0xc(%eax)
  8020e9:	e8 76 03 00 00       	call   802464 <nsipc_send>
}
  8020ee:	c9                   	leave  
  8020ef:	c3                   	ret    

008020f0 <devsock_read>:
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
  8020f3:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8020f6:	6a 00                	push   $0x0
  8020f8:	ff 75 10             	pushl  0x10(%ebp)
  8020fb:	ff 75 0c             	pushl  0xc(%ebp)
  8020fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802101:	ff 70 0c             	pushl  0xc(%eax)
  802104:	e8 ef 02 00 00       	call   8023f8 <nsipc_recv>
}
  802109:	c9                   	leave  
  80210a:	c3                   	ret    

0080210b <fd2sockid>:
{
  80210b:	55                   	push   %ebp
  80210c:	89 e5                	mov    %esp,%ebp
  80210e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802111:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802114:	52                   	push   %edx
  802115:	50                   	push   %eax
  802116:	e8 b7 f7 ff ff       	call   8018d2 <fd_lookup>
  80211b:	83 c4 10             	add    $0x10,%esp
  80211e:	85 c0                	test   %eax,%eax
  802120:	78 10                	js     802132 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802122:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802125:	8b 0d 40 40 80 00    	mov    0x804040,%ecx
  80212b:	39 08                	cmp    %ecx,(%eax)
  80212d:	75 05                	jne    802134 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80212f:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802132:	c9                   	leave  
  802133:	c3                   	ret    
		return -E_NOT_SUPP;
  802134:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802139:	eb f7                	jmp    802132 <fd2sockid+0x27>

0080213b <alloc_sockfd>:
{
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
  80213e:	56                   	push   %esi
  80213f:	53                   	push   %ebx
  802140:	83 ec 1c             	sub    $0x1c,%esp
  802143:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802145:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802148:	50                   	push   %eax
  802149:	e8 32 f7 ff ff       	call   801880 <fd_alloc>
  80214e:	89 c3                	mov    %eax,%ebx
  802150:	83 c4 10             	add    $0x10,%esp
  802153:	85 c0                	test   %eax,%eax
  802155:	78 43                	js     80219a <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802157:	83 ec 04             	sub    $0x4,%esp
  80215a:	68 07 04 00 00       	push   $0x407
  80215f:	ff 75 f4             	pushl  -0xc(%ebp)
  802162:	6a 00                	push   $0x0
  802164:	e8 fb f3 ff ff       	call   801564 <sys_page_alloc>
  802169:	89 c3                	mov    %eax,%ebx
  80216b:	83 c4 10             	add    $0x10,%esp
  80216e:	85 c0                	test   %eax,%eax
  802170:	78 28                	js     80219a <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802172:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802175:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80217b:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80217d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802180:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802187:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80218a:	83 ec 0c             	sub    $0xc,%esp
  80218d:	50                   	push   %eax
  80218e:	e8 c6 f6 ff ff       	call   801859 <fd2num>
  802193:	89 c3                	mov    %eax,%ebx
  802195:	83 c4 10             	add    $0x10,%esp
  802198:	eb 0c                	jmp    8021a6 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80219a:	83 ec 0c             	sub    $0xc,%esp
  80219d:	56                   	push   %esi
  80219e:	e8 e4 01 00 00       	call   802387 <nsipc_close>
		return r;
  8021a3:	83 c4 10             	add    $0x10,%esp
}
  8021a6:	89 d8                	mov    %ebx,%eax
  8021a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021ab:	5b                   	pop    %ebx
  8021ac:	5e                   	pop    %esi
  8021ad:	5d                   	pop    %ebp
  8021ae:	c3                   	ret    

008021af <accept>:
{
  8021af:	55                   	push   %ebp
  8021b0:	89 e5                	mov    %esp,%ebp
  8021b2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b8:	e8 4e ff ff ff       	call   80210b <fd2sockid>
  8021bd:	85 c0                	test   %eax,%eax
  8021bf:	78 1b                	js     8021dc <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8021c1:	83 ec 04             	sub    $0x4,%esp
  8021c4:	ff 75 10             	pushl  0x10(%ebp)
  8021c7:	ff 75 0c             	pushl  0xc(%ebp)
  8021ca:	50                   	push   %eax
  8021cb:	e8 0e 01 00 00       	call   8022de <nsipc_accept>
  8021d0:	83 c4 10             	add    $0x10,%esp
  8021d3:	85 c0                	test   %eax,%eax
  8021d5:	78 05                	js     8021dc <accept+0x2d>
	return alloc_sockfd(r);
  8021d7:	e8 5f ff ff ff       	call   80213b <alloc_sockfd>
}
  8021dc:	c9                   	leave  
  8021dd:	c3                   	ret    

008021de <bind>:
{
  8021de:	55                   	push   %ebp
  8021df:	89 e5                	mov    %esp,%ebp
  8021e1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e7:	e8 1f ff ff ff       	call   80210b <fd2sockid>
  8021ec:	85 c0                	test   %eax,%eax
  8021ee:	78 12                	js     802202 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8021f0:	83 ec 04             	sub    $0x4,%esp
  8021f3:	ff 75 10             	pushl  0x10(%ebp)
  8021f6:	ff 75 0c             	pushl  0xc(%ebp)
  8021f9:	50                   	push   %eax
  8021fa:	e8 31 01 00 00       	call   802330 <nsipc_bind>
  8021ff:	83 c4 10             	add    $0x10,%esp
}
  802202:	c9                   	leave  
  802203:	c3                   	ret    

00802204 <shutdown>:
{
  802204:	55                   	push   %ebp
  802205:	89 e5                	mov    %esp,%ebp
  802207:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80220a:	8b 45 08             	mov    0x8(%ebp),%eax
  80220d:	e8 f9 fe ff ff       	call   80210b <fd2sockid>
  802212:	85 c0                	test   %eax,%eax
  802214:	78 0f                	js     802225 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802216:	83 ec 08             	sub    $0x8,%esp
  802219:	ff 75 0c             	pushl  0xc(%ebp)
  80221c:	50                   	push   %eax
  80221d:	e8 43 01 00 00       	call   802365 <nsipc_shutdown>
  802222:	83 c4 10             	add    $0x10,%esp
}
  802225:	c9                   	leave  
  802226:	c3                   	ret    

00802227 <connect>:
{
  802227:	55                   	push   %ebp
  802228:	89 e5                	mov    %esp,%ebp
  80222a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80222d:	8b 45 08             	mov    0x8(%ebp),%eax
  802230:	e8 d6 fe ff ff       	call   80210b <fd2sockid>
  802235:	85 c0                	test   %eax,%eax
  802237:	78 12                	js     80224b <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802239:	83 ec 04             	sub    $0x4,%esp
  80223c:	ff 75 10             	pushl  0x10(%ebp)
  80223f:	ff 75 0c             	pushl  0xc(%ebp)
  802242:	50                   	push   %eax
  802243:	e8 59 01 00 00       	call   8023a1 <nsipc_connect>
  802248:	83 c4 10             	add    $0x10,%esp
}
  80224b:	c9                   	leave  
  80224c:	c3                   	ret    

0080224d <listen>:
{
  80224d:	55                   	push   %ebp
  80224e:	89 e5                	mov    %esp,%ebp
  802250:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802253:	8b 45 08             	mov    0x8(%ebp),%eax
  802256:	e8 b0 fe ff ff       	call   80210b <fd2sockid>
  80225b:	85 c0                	test   %eax,%eax
  80225d:	78 0f                	js     80226e <listen+0x21>
	return nsipc_listen(r, backlog);
  80225f:	83 ec 08             	sub    $0x8,%esp
  802262:	ff 75 0c             	pushl  0xc(%ebp)
  802265:	50                   	push   %eax
  802266:	e8 6b 01 00 00       	call   8023d6 <nsipc_listen>
  80226b:	83 c4 10             	add    $0x10,%esp
}
  80226e:	c9                   	leave  
  80226f:	c3                   	ret    

00802270 <socket>:

int
socket(int domain, int type, int protocol)
{
  802270:	55                   	push   %ebp
  802271:	89 e5                	mov    %esp,%ebp
  802273:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802276:	ff 75 10             	pushl  0x10(%ebp)
  802279:	ff 75 0c             	pushl  0xc(%ebp)
  80227c:	ff 75 08             	pushl  0x8(%ebp)
  80227f:	e8 3e 02 00 00       	call   8024c2 <nsipc_socket>
  802284:	83 c4 10             	add    $0x10,%esp
  802287:	85 c0                	test   %eax,%eax
  802289:	78 05                	js     802290 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80228b:	e8 ab fe ff ff       	call   80213b <alloc_sockfd>
}
  802290:	c9                   	leave  
  802291:	c3                   	ret    

00802292 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802292:	55                   	push   %ebp
  802293:	89 e5                	mov    %esp,%ebp
  802295:	53                   	push   %ebx
  802296:	83 ec 04             	sub    $0x4,%esp
  802299:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80229b:	83 3d 14 50 80 00 00 	cmpl   $0x0,0x805014
  8022a2:	74 26                	je     8022ca <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8022a4:	6a 07                	push   $0x7
  8022a6:	68 00 70 80 00       	push   $0x807000
  8022ab:	53                   	push   %ebx
  8022ac:	ff 35 14 50 80 00    	pushl  0x805014
  8022b2:	e8 fa 09 00 00       	call   802cb1 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8022b7:	83 c4 0c             	add    $0xc,%esp
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	e8 83 09 00 00       	call   802c48 <ipc_recv>
}
  8022c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022c8:	c9                   	leave  
  8022c9:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8022ca:	83 ec 0c             	sub    $0xc,%esp
  8022cd:	6a 02                	push   $0x2
  8022cf:	e8 35 0a 00 00       	call   802d09 <ipc_find_env>
  8022d4:	a3 14 50 80 00       	mov    %eax,0x805014
  8022d9:	83 c4 10             	add    $0x10,%esp
  8022dc:	eb c6                	jmp    8022a4 <nsipc+0x12>

008022de <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8022de:	55                   	push   %ebp
  8022df:	89 e5                	mov    %esp,%ebp
  8022e1:	56                   	push   %esi
  8022e2:	53                   	push   %ebx
  8022e3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8022e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8022ee:	8b 06                	mov    (%esi),%eax
  8022f0:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8022f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8022fa:	e8 93 ff ff ff       	call   802292 <nsipc>
  8022ff:	89 c3                	mov    %eax,%ebx
  802301:	85 c0                	test   %eax,%eax
  802303:	79 09                	jns    80230e <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802305:	89 d8                	mov    %ebx,%eax
  802307:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80230a:	5b                   	pop    %ebx
  80230b:	5e                   	pop    %esi
  80230c:	5d                   	pop    %ebp
  80230d:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80230e:	83 ec 04             	sub    $0x4,%esp
  802311:	ff 35 10 70 80 00    	pushl  0x807010
  802317:	68 00 70 80 00       	push   $0x807000
  80231c:	ff 75 0c             	pushl  0xc(%ebp)
  80231f:	e8 dc ef ff ff       	call   801300 <memmove>
		*addrlen = ret->ret_addrlen;
  802324:	a1 10 70 80 00       	mov    0x807010,%eax
  802329:	89 06                	mov    %eax,(%esi)
  80232b:	83 c4 10             	add    $0x10,%esp
	return r;
  80232e:	eb d5                	jmp    802305 <nsipc_accept+0x27>

00802330 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802330:	55                   	push   %ebp
  802331:	89 e5                	mov    %esp,%ebp
  802333:	53                   	push   %ebx
  802334:	83 ec 08             	sub    $0x8,%esp
  802337:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80233a:	8b 45 08             	mov    0x8(%ebp),%eax
  80233d:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802342:	53                   	push   %ebx
  802343:	ff 75 0c             	pushl  0xc(%ebp)
  802346:	68 04 70 80 00       	push   $0x807004
  80234b:	e8 b0 ef ff ff       	call   801300 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802350:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802356:	b8 02 00 00 00       	mov    $0x2,%eax
  80235b:	e8 32 ff ff ff       	call   802292 <nsipc>
}
  802360:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802363:	c9                   	leave  
  802364:	c3                   	ret    

00802365 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802365:	55                   	push   %ebp
  802366:	89 e5                	mov    %esp,%ebp
  802368:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80236b:	8b 45 08             	mov    0x8(%ebp),%eax
  80236e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802373:	8b 45 0c             	mov    0xc(%ebp),%eax
  802376:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80237b:	b8 03 00 00 00       	mov    $0x3,%eax
  802380:	e8 0d ff ff ff       	call   802292 <nsipc>
}
  802385:	c9                   	leave  
  802386:	c3                   	ret    

00802387 <nsipc_close>:

int
nsipc_close(int s)
{
  802387:	55                   	push   %ebp
  802388:	89 e5                	mov    %esp,%ebp
  80238a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80238d:	8b 45 08             	mov    0x8(%ebp),%eax
  802390:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802395:	b8 04 00 00 00       	mov    $0x4,%eax
  80239a:	e8 f3 fe ff ff       	call   802292 <nsipc>
}
  80239f:	c9                   	leave  
  8023a0:	c3                   	ret    

008023a1 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8023a1:	55                   	push   %ebp
  8023a2:	89 e5                	mov    %esp,%ebp
  8023a4:	53                   	push   %ebx
  8023a5:	83 ec 08             	sub    $0x8,%esp
  8023a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8023ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ae:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8023b3:	53                   	push   %ebx
  8023b4:	ff 75 0c             	pushl  0xc(%ebp)
  8023b7:	68 04 70 80 00       	push   $0x807004
  8023bc:	e8 3f ef ff ff       	call   801300 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8023c1:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8023c7:	b8 05 00 00 00       	mov    $0x5,%eax
  8023cc:	e8 c1 fe ff ff       	call   802292 <nsipc>
}
  8023d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023d4:	c9                   	leave  
  8023d5:	c3                   	ret    

008023d6 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8023d6:	55                   	push   %ebp
  8023d7:	89 e5                	mov    %esp,%ebp
  8023d9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8023dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023df:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8023e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023e7:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8023ec:	b8 06 00 00 00       	mov    $0x6,%eax
  8023f1:	e8 9c fe ff ff       	call   802292 <nsipc>
}
  8023f6:	c9                   	leave  
  8023f7:	c3                   	ret    

008023f8 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
  8023fb:	56                   	push   %esi
  8023fc:	53                   	push   %ebx
  8023fd:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802400:	8b 45 08             	mov    0x8(%ebp),%eax
  802403:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802408:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80240e:	8b 45 14             	mov    0x14(%ebp),%eax
  802411:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802416:	b8 07 00 00 00       	mov    $0x7,%eax
  80241b:	e8 72 fe ff ff       	call   802292 <nsipc>
  802420:	89 c3                	mov    %eax,%ebx
  802422:	85 c0                	test   %eax,%eax
  802424:	78 1f                	js     802445 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802426:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80242b:	7f 21                	jg     80244e <nsipc_recv+0x56>
  80242d:	39 c6                	cmp    %eax,%esi
  80242f:	7c 1d                	jl     80244e <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802431:	83 ec 04             	sub    $0x4,%esp
  802434:	50                   	push   %eax
  802435:	68 00 70 80 00       	push   $0x807000
  80243a:	ff 75 0c             	pushl  0xc(%ebp)
  80243d:	e8 be ee ff ff       	call   801300 <memmove>
  802442:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802445:	89 d8                	mov    %ebx,%eax
  802447:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80244a:	5b                   	pop    %ebx
  80244b:	5e                   	pop    %esi
  80244c:	5d                   	pop    %ebp
  80244d:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80244e:	68 43 37 80 00       	push   $0x803743
  802453:	68 0b 37 80 00       	push   $0x80370b
  802458:	6a 62                	push   $0x62
  80245a:	68 58 37 80 00       	push   $0x803758
  80245f:	e8 b9 e4 ff ff       	call   80091d <_panic>

00802464 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802464:	55                   	push   %ebp
  802465:	89 e5                	mov    %esp,%ebp
  802467:	53                   	push   %ebx
  802468:	83 ec 04             	sub    $0x4,%esp
  80246b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80246e:	8b 45 08             	mov    0x8(%ebp),%eax
  802471:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802476:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80247c:	7f 2e                	jg     8024ac <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80247e:	83 ec 04             	sub    $0x4,%esp
  802481:	53                   	push   %ebx
  802482:	ff 75 0c             	pushl  0xc(%ebp)
  802485:	68 0c 70 80 00       	push   $0x80700c
  80248a:	e8 71 ee ff ff       	call   801300 <memmove>
	nsipcbuf.send.req_size = size;
  80248f:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802495:	8b 45 14             	mov    0x14(%ebp),%eax
  802498:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80249d:	b8 08 00 00 00       	mov    $0x8,%eax
  8024a2:	e8 eb fd ff ff       	call   802292 <nsipc>
}
  8024a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024aa:	c9                   	leave  
  8024ab:	c3                   	ret    
	assert(size < 1600);
  8024ac:	68 64 37 80 00       	push   $0x803764
  8024b1:	68 0b 37 80 00       	push   $0x80370b
  8024b6:	6a 6d                	push   $0x6d
  8024b8:	68 58 37 80 00       	push   $0x803758
  8024bd:	e8 5b e4 ff ff       	call   80091d <_panic>

008024c2 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8024c2:	55                   	push   %ebp
  8024c3:	89 e5                	mov    %esp,%ebp
  8024c5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8024c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cb:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8024d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024d3:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8024d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8024db:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8024e0:	b8 09 00 00 00       	mov    $0x9,%eax
  8024e5:	e8 a8 fd ff ff       	call   802292 <nsipc>
}
  8024ea:	c9                   	leave  
  8024eb:	c3                   	ret    

008024ec <free>:
	return v;
}

void
free(void *v)
{
  8024ec:	55                   	push   %ebp
  8024ed:	89 e5                	mov    %esp,%ebp
  8024ef:	53                   	push   %ebx
  8024f0:	83 ec 04             	sub    $0x4,%esp
  8024f3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
  8024f6:	85 db                	test   %ebx,%ebx
  8024f8:	0f 84 85 00 00 00    	je     802583 <free+0x97>
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  8024fe:	8d 83 00 00 00 f8    	lea    -0x8000000(%ebx),%eax
  802504:	3d ff ff ff 07       	cmp    $0x7ffffff,%eax
  802509:	77 51                	ja     80255c <free+0x70>

	c = ROUNDDOWN(v, PGSIZE);
  80250b:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  802511:	89 d8                	mov    %ebx,%eax
  802513:	c1 e8 0c             	shr    $0xc,%eax
  802516:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80251d:	f6 c4 02             	test   $0x2,%ah
  802520:	74 50                	je     802572 <free+0x86>
		sys_page_unmap(0, c);
  802522:	83 ec 08             	sub    $0x8,%esp
  802525:	53                   	push   %ebx
  802526:	6a 00                	push   $0x0
  802528:	e8 bc f0 ff ff       	call   8015e9 <sys_page_unmap>
		c += PGSIZE;
  80252d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		assert(mbegin <= c && c < mend);
  802533:	8d 83 00 00 00 f8    	lea    -0x8000000(%ebx),%eax
  802539:	83 c4 10             	add    $0x10,%esp
  80253c:	3d ff ff ff 07       	cmp    $0x7ffffff,%eax
  802541:	76 ce                	jbe    802511 <free+0x25>
  802543:	68 ad 37 80 00       	push   $0x8037ad
  802548:	68 0b 37 80 00       	push   $0x80370b
  80254d:	68 81 00 00 00       	push   $0x81
  802552:	68 a0 37 80 00       	push   $0x8037a0
  802557:	e8 c1 e3 ff ff       	call   80091d <_panic>
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  80255c:	68 70 37 80 00       	push   $0x803770
  802561:	68 0b 37 80 00       	push   $0x80370b
  802566:	6a 7a                	push   $0x7a
  802568:	68 a0 37 80 00       	push   $0x8037a0
  80256d:	e8 ab e3 ff ff       	call   80091d <_panic>
	/*
	 * c is just a piece of this page, so dec the ref count
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
	if (--(*ref) == 0)
  802572:	8b 83 fc 0f 00 00    	mov    0xffc(%ebx),%eax
  802578:	83 e8 01             	sub    $0x1,%eax
  80257b:	89 83 fc 0f 00 00    	mov    %eax,0xffc(%ebx)
  802581:	74 05                	je     802588 <free+0x9c>
		sys_page_unmap(0, c);
}
  802583:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802586:	c9                   	leave  
  802587:	c3                   	ret    
		sys_page_unmap(0, c);
  802588:	83 ec 08             	sub    $0x8,%esp
  80258b:	53                   	push   %ebx
  80258c:	6a 00                	push   $0x0
  80258e:	e8 56 f0 ff ff       	call   8015e9 <sys_page_unmap>
  802593:	83 c4 10             	add    $0x10,%esp
  802596:	eb eb                	jmp    802583 <free+0x97>

00802598 <malloc>:
{
  802598:	55                   	push   %ebp
  802599:	89 e5                	mov    %esp,%ebp
  80259b:	57                   	push   %edi
  80259c:	56                   	push   %esi
  80259d:	53                   	push   %ebx
  80259e:	83 ec 1c             	sub    $0x1c,%esp
	if (mptr == 0)
  8025a1:	a1 18 50 80 00       	mov    0x805018,%eax
  8025a6:	85 c0                	test   %eax,%eax
  8025a8:	74 74                	je     80261e <malloc+0x86>
	n = ROUNDUP(n, 4);
  8025aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025ad:	8d 51 03             	lea    0x3(%ecx),%edx
  8025b0:	83 e2 fc             	and    $0xfffffffc,%edx
  8025b3:	89 d6                	mov    %edx,%esi
  8025b5:	89 55 dc             	mov    %edx,-0x24(%ebp)
	if (n >= MAXMALLOC)
  8025b8:	81 fa ff ff 0f 00    	cmp    $0xfffff,%edx
  8025be:	0f 87 55 01 00 00    	ja     802719 <malloc+0x181>
	if ((uintptr_t) mptr % PGSIZE){
  8025c4:	89 c1                	mov    %eax,%ecx
  8025c6:	a9 ff 0f 00 00       	test   $0xfff,%eax
  8025cb:	74 30                	je     8025fd <malloc+0x65>
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
  8025cd:	89 c3                	mov    %eax,%ebx
  8025cf:	c1 eb 0c             	shr    $0xc,%ebx
  8025d2:	8d 54 10 03          	lea    0x3(%eax,%edx,1),%edx
  8025d6:	c1 ea 0c             	shr    $0xc,%edx
  8025d9:	39 d3                	cmp    %edx,%ebx
  8025db:	74 64                	je     802641 <malloc+0xa9>
		free(mptr);	/* drop reference to this page */
  8025dd:	83 ec 0c             	sub    $0xc,%esp
  8025e0:	50                   	push   %eax
  8025e1:	e8 06 ff ff ff       	call   8024ec <free>
		mptr = ROUNDDOWN(mptr + PGSIZE, PGSIZE);
  8025e6:	a1 18 50 80 00       	mov    0x805018,%eax
  8025eb:	05 00 10 00 00       	add    $0x1000,%eax
  8025f0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8025f5:	a3 18 50 80 00       	mov    %eax,0x805018
  8025fa:	83 c4 10             	add    $0x10,%esp
  8025fd:	8b 15 18 50 80 00    	mov    0x805018,%edx
{
  802603:	c7 45 d8 02 00 00 00 	movl   $0x2,-0x28(%ebp)
  80260a:	be 00 00 00 00       	mov    $0x0,%esi
		if (isfree(mptr, n + 4))
  80260f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802612:	8d 78 04             	lea    0x4(%eax),%edi
  802615:	c6 45 e3 01          	movb   $0x1,-0x1d(%ebp)
  802619:	e9 86 00 00 00       	jmp    8026a4 <malloc+0x10c>
		mptr = mbegin;
  80261e:	c7 05 18 50 80 00 00 	movl   $0x8000000,0x805018
  802625:	00 00 08 
	n = ROUNDUP(n, 4);
  802628:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80262b:	8d 51 03             	lea    0x3(%ecx),%edx
  80262e:	83 e2 fc             	and    $0xfffffffc,%edx
  802631:	89 55 dc             	mov    %edx,-0x24(%ebp)
	if (n >= MAXMALLOC)
  802634:	81 fa ff ff 0f 00    	cmp    $0xfffff,%edx
  80263a:	76 c1                	jbe    8025fd <malloc+0x65>
  80263c:	e9 fd 00 00 00       	jmp    80273e <malloc+0x1a6>
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
  802641:	81 c1 ff 0f 00 00    	add    $0xfff,%ecx
  802647:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
			(*ref)++;
  80264d:	83 41 fc 01          	addl   $0x1,-0x4(%ecx)
			mptr += n;
  802651:	89 f2                	mov    %esi,%edx
  802653:	01 c2                	add    %eax,%edx
  802655:	89 15 18 50 80 00    	mov    %edx,0x805018
			return v;
  80265b:	e9 de 00 00 00       	jmp    80273e <malloc+0x1a6>
	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  802660:	05 00 10 00 00       	add    $0x1000,%eax
  802665:	39 c8                	cmp    %ecx,%eax
  802667:	73 66                	jae    8026cf <malloc+0x137>
		if (va >= (uintptr_t) mend
  802669:	3d ff ff ff 0f       	cmp    $0xfffffff,%eax
  80266e:	77 22                	ja     802692 <malloc+0xfa>
		    || ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
  802670:	89 c3                	mov    %eax,%ebx
  802672:	c1 eb 16             	shr    $0x16,%ebx
  802675:	8b 1c 9d 00 d0 7b ef 	mov    -0x10843000(,%ebx,4),%ebx
  80267c:	f6 c3 01             	test   $0x1,%bl
  80267f:	74 df                	je     802660 <malloc+0xc8>
  802681:	89 c3                	mov    %eax,%ebx
  802683:	c1 eb 0c             	shr    $0xc,%ebx
  802686:	8b 1c 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%ebx
  80268d:	f6 c3 01             	test   $0x1,%bl
  802690:	74 ce                	je     802660 <malloc+0xc8>
  802692:	81 c2 00 10 00 00    	add    $0x1000,%edx
  802698:	0f b6 75 e3          	movzbl -0x1d(%ebp),%esi
		if (mptr == mend) {
  80269c:	81 fa 00 00 00 10    	cmp    $0x10000000,%edx
  8026a2:	74 0a                	je     8026ae <malloc+0x116>
  8026a4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  8026a7:	89 d0                	mov    %edx,%eax
  8026a9:	8d 0c 17             	lea    (%edi,%edx,1),%ecx
  8026ac:	eb b7                	jmp    802665 <malloc+0xcd>
			mptr = mbegin;
  8026ae:	ba 00 00 00 08       	mov    $0x8000000,%edx
  8026b3:	be 01 00 00 00       	mov    $0x1,%esi
			if (++nwrap == 2)
  8026b8:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8026bc:	75 e6                	jne    8026a4 <malloc+0x10c>
  8026be:	c7 05 18 50 80 00 00 	movl   $0x8000000,0x805018
  8026c5:	00 00 08 
				return 0;	/* out of address space */
  8026c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8026cd:	eb 6f                	jmp    80273e <malloc+0x1a6>
  8026cf:	89 f0                	mov    %esi,%eax
  8026d1:	84 c0                	test   %al,%al
  8026d3:	74 08                	je     8026dd <malloc+0x145>
  8026d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026d8:	a3 18 50 80 00       	mov    %eax,0x805018
	for (i = 0; i < n + 4; i += PGSIZE){
  8026dd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026e2:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
  8026e5:	8d b3 00 10 00 00    	lea    0x1000(%ebx),%esi
  8026eb:	39 f7                	cmp    %esi,%edi
  8026ed:	76 57                	jbe    802746 <malloc+0x1ae>
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  8026ef:	83 ec 04             	sub    $0x4,%esp
  8026f2:	68 07 02 00 00       	push   $0x207
  8026f7:	89 d8                	mov    %ebx,%eax
  8026f9:	03 05 18 50 80 00    	add    0x805018,%eax
  8026ff:	50                   	push   %eax
  802700:	6a 00                	push   $0x0
  802702:	e8 5d ee ff ff       	call   801564 <sys_page_alloc>
  802707:	83 c4 10             	add    $0x10,%esp
  80270a:	85 c0                	test   %eax,%eax
  80270c:	78 55                	js     802763 <malloc+0x1cb>
	for (i = 0; i < n + 4; i += PGSIZE){
  80270e:	89 f3                	mov    %esi,%ebx
  802710:	eb d0                	jmp    8026e2 <malloc+0x14a>
			return 0;	/* out of physical memory */
  802712:	b8 00 00 00 00       	mov    $0x0,%eax
  802717:	eb 25                	jmp    80273e <malloc+0x1a6>
		return 0;
  802719:	b8 00 00 00 00       	mov    $0x0,%eax
  80271e:	eb 1e                	jmp    80273e <malloc+0x1a6>
	ref = (uint32_t*) (mptr + i - 4);
  802720:	a1 18 50 80 00       	mov    0x805018,%eax
	*ref = 2;	/* reference for mptr, reference for returned block */
  802725:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  802728:	c7 84 08 fc 0f 00 00 	movl   $0x2,0xffc(%eax,%ecx,1)
  80272f:	02 00 00 00 
	mptr += n;
  802733:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802736:	01 c2                	add    %eax,%edx
  802738:	89 15 18 50 80 00    	mov    %edx,0x805018
}
  80273e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802741:	5b                   	pop    %ebx
  802742:	5e                   	pop    %esi
  802743:	5f                   	pop    %edi
  802744:	5d                   	pop    %ebp
  802745:	c3                   	ret    
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  802746:	83 ec 04             	sub    $0x4,%esp
  802749:	6a 07                	push   $0x7
  80274b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80274e:	03 05 18 50 80 00    	add    0x805018,%eax
  802754:	50                   	push   %eax
  802755:	6a 00                	push   $0x0
  802757:	e8 08 ee ff ff       	call   801564 <sys_page_alloc>
  80275c:	83 c4 10             	add    $0x10,%esp
  80275f:	85 c0                	test   %eax,%eax
  802761:	79 bd                	jns    802720 <malloc+0x188>
			for (; i >= 0; i -= PGSIZE)
  802763:	85 db                	test   %ebx,%ebx
  802765:	78 ab                	js     802712 <malloc+0x17a>
				sys_page_unmap(0, mptr + i);
  802767:	83 ec 08             	sub    $0x8,%esp
  80276a:	89 d8                	mov    %ebx,%eax
  80276c:	03 05 18 50 80 00    	add    0x805018,%eax
  802772:	50                   	push   %eax
  802773:	6a 00                	push   $0x0
  802775:	e8 6f ee ff ff       	call   8015e9 <sys_page_unmap>
			for (; i >= 0; i -= PGSIZE)
  80277a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
  802780:	83 c4 10             	add    $0x10,%esp
  802783:	eb de                	jmp    802763 <malloc+0x1cb>

00802785 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802785:	55                   	push   %ebp
  802786:	89 e5                	mov    %esp,%ebp
  802788:	56                   	push   %esi
  802789:	53                   	push   %ebx
  80278a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80278d:	83 ec 0c             	sub    $0xc,%esp
  802790:	ff 75 08             	pushl  0x8(%ebp)
  802793:	e8 d1 f0 ff ff       	call   801869 <fd2data>
  802798:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80279a:	83 c4 08             	add    $0x8,%esp
  80279d:	68 c5 37 80 00       	push   $0x8037c5
  8027a2:	53                   	push   %ebx
  8027a3:	e8 ca e9 ff ff       	call   801172 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8027a8:	8b 46 04             	mov    0x4(%esi),%eax
  8027ab:	2b 06                	sub    (%esi),%eax
  8027ad:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8027b3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8027ba:	00 00 00 
	stat->st_dev = &devpipe;
  8027bd:	c7 83 88 00 00 00 5c 	movl   $0x80405c,0x88(%ebx)
  8027c4:	40 80 00 
	return 0;
}
  8027c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027cf:	5b                   	pop    %ebx
  8027d0:	5e                   	pop    %esi
  8027d1:	5d                   	pop    %ebp
  8027d2:	c3                   	ret    

008027d3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8027d3:	55                   	push   %ebp
  8027d4:	89 e5                	mov    %esp,%ebp
  8027d6:	53                   	push   %ebx
  8027d7:	83 ec 0c             	sub    $0xc,%esp
  8027da:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8027dd:	53                   	push   %ebx
  8027de:	6a 00                	push   $0x0
  8027e0:	e8 04 ee ff ff       	call   8015e9 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8027e5:	89 1c 24             	mov    %ebx,(%esp)
  8027e8:	e8 7c f0 ff ff       	call   801869 <fd2data>
  8027ed:	83 c4 08             	add    $0x8,%esp
  8027f0:	50                   	push   %eax
  8027f1:	6a 00                	push   $0x0
  8027f3:	e8 f1 ed ff ff       	call   8015e9 <sys_page_unmap>
}
  8027f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027fb:	c9                   	leave  
  8027fc:	c3                   	ret    

008027fd <_pipeisclosed>:
{
  8027fd:	55                   	push   %ebp
  8027fe:	89 e5                	mov    %esp,%ebp
  802800:	57                   	push   %edi
  802801:	56                   	push   %esi
  802802:	53                   	push   %ebx
  802803:	83 ec 1c             	sub    $0x1c,%esp
  802806:	89 c7                	mov    %eax,%edi
  802808:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80280a:	a1 1c 50 80 00       	mov    0x80501c,%eax
  80280f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802812:	83 ec 0c             	sub    $0xc,%esp
  802815:	57                   	push   %edi
  802816:	e8 29 05 00 00       	call   802d44 <pageref>
  80281b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80281e:	89 34 24             	mov    %esi,(%esp)
  802821:	e8 1e 05 00 00       	call   802d44 <pageref>
		nn = thisenv->env_runs;
  802826:	8b 15 1c 50 80 00    	mov    0x80501c,%edx
  80282c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80282f:	83 c4 10             	add    $0x10,%esp
  802832:	39 cb                	cmp    %ecx,%ebx
  802834:	74 1b                	je     802851 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802836:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802839:	75 cf                	jne    80280a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80283b:	8b 42 58             	mov    0x58(%edx),%eax
  80283e:	6a 01                	push   $0x1
  802840:	50                   	push   %eax
  802841:	53                   	push   %ebx
  802842:	68 cc 37 80 00       	push   $0x8037cc
  802847:	e8 c7 e1 ff ff       	call   800a13 <cprintf>
  80284c:	83 c4 10             	add    $0x10,%esp
  80284f:	eb b9                	jmp    80280a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802851:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802854:	0f 94 c0             	sete   %al
  802857:	0f b6 c0             	movzbl %al,%eax
}
  80285a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80285d:	5b                   	pop    %ebx
  80285e:	5e                   	pop    %esi
  80285f:	5f                   	pop    %edi
  802860:	5d                   	pop    %ebp
  802861:	c3                   	ret    

00802862 <devpipe_write>:
{
  802862:	55                   	push   %ebp
  802863:	89 e5                	mov    %esp,%ebp
  802865:	57                   	push   %edi
  802866:	56                   	push   %esi
  802867:	53                   	push   %ebx
  802868:	83 ec 28             	sub    $0x28,%esp
  80286b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80286e:	56                   	push   %esi
  80286f:	e8 f5 ef ff ff       	call   801869 <fd2data>
  802874:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802876:	83 c4 10             	add    $0x10,%esp
  802879:	bf 00 00 00 00       	mov    $0x0,%edi
  80287e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802881:	74 4f                	je     8028d2 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802883:	8b 43 04             	mov    0x4(%ebx),%eax
  802886:	8b 0b                	mov    (%ebx),%ecx
  802888:	8d 51 20             	lea    0x20(%ecx),%edx
  80288b:	39 d0                	cmp    %edx,%eax
  80288d:	72 14                	jb     8028a3 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80288f:	89 da                	mov    %ebx,%edx
  802891:	89 f0                	mov    %esi,%eax
  802893:	e8 65 ff ff ff       	call   8027fd <_pipeisclosed>
  802898:	85 c0                	test   %eax,%eax
  80289a:	75 3b                	jne    8028d7 <devpipe_write+0x75>
			sys_yield();
  80289c:	e8 a4 ec ff ff       	call   801545 <sys_yield>
  8028a1:	eb e0                	jmp    802883 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8028a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8028a6:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8028aa:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8028ad:	89 c2                	mov    %eax,%edx
  8028af:	c1 fa 1f             	sar    $0x1f,%edx
  8028b2:	89 d1                	mov    %edx,%ecx
  8028b4:	c1 e9 1b             	shr    $0x1b,%ecx
  8028b7:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8028ba:	83 e2 1f             	and    $0x1f,%edx
  8028bd:	29 ca                	sub    %ecx,%edx
  8028bf:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8028c3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8028c7:	83 c0 01             	add    $0x1,%eax
  8028ca:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8028cd:	83 c7 01             	add    $0x1,%edi
  8028d0:	eb ac                	jmp    80287e <devpipe_write+0x1c>
	return i;
  8028d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8028d5:	eb 05                	jmp    8028dc <devpipe_write+0x7a>
				return 0;
  8028d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028df:	5b                   	pop    %ebx
  8028e0:	5e                   	pop    %esi
  8028e1:	5f                   	pop    %edi
  8028e2:	5d                   	pop    %ebp
  8028e3:	c3                   	ret    

008028e4 <devpipe_read>:
{
  8028e4:	55                   	push   %ebp
  8028e5:	89 e5                	mov    %esp,%ebp
  8028e7:	57                   	push   %edi
  8028e8:	56                   	push   %esi
  8028e9:	53                   	push   %ebx
  8028ea:	83 ec 18             	sub    $0x18,%esp
  8028ed:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8028f0:	57                   	push   %edi
  8028f1:	e8 73 ef ff ff       	call   801869 <fd2data>
  8028f6:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8028f8:	83 c4 10             	add    $0x10,%esp
  8028fb:	be 00 00 00 00       	mov    $0x0,%esi
  802900:	3b 75 10             	cmp    0x10(%ebp),%esi
  802903:	75 14                	jne    802919 <devpipe_read+0x35>
	return i;
  802905:	8b 45 10             	mov    0x10(%ebp),%eax
  802908:	eb 02                	jmp    80290c <devpipe_read+0x28>
				return i;
  80290a:	89 f0                	mov    %esi,%eax
}
  80290c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80290f:	5b                   	pop    %ebx
  802910:	5e                   	pop    %esi
  802911:	5f                   	pop    %edi
  802912:	5d                   	pop    %ebp
  802913:	c3                   	ret    
			sys_yield();
  802914:	e8 2c ec ff ff       	call   801545 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802919:	8b 03                	mov    (%ebx),%eax
  80291b:	3b 43 04             	cmp    0x4(%ebx),%eax
  80291e:	75 18                	jne    802938 <devpipe_read+0x54>
			if (i > 0)
  802920:	85 f6                	test   %esi,%esi
  802922:	75 e6                	jne    80290a <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802924:	89 da                	mov    %ebx,%edx
  802926:	89 f8                	mov    %edi,%eax
  802928:	e8 d0 fe ff ff       	call   8027fd <_pipeisclosed>
  80292d:	85 c0                	test   %eax,%eax
  80292f:	74 e3                	je     802914 <devpipe_read+0x30>
				return 0;
  802931:	b8 00 00 00 00       	mov    $0x0,%eax
  802936:	eb d4                	jmp    80290c <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802938:	99                   	cltd   
  802939:	c1 ea 1b             	shr    $0x1b,%edx
  80293c:	01 d0                	add    %edx,%eax
  80293e:	83 e0 1f             	and    $0x1f,%eax
  802941:	29 d0                	sub    %edx,%eax
  802943:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802948:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80294b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80294e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802951:	83 c6 01             	add    $0x1,%esi
  802954:	eb aa                	jmp    802900 <devpipe_read+0x1c>

00802956 <pipe>:
{
  802956:	55                   	push   %ebp
  802957:	89 e5                	mov    %esp,%ebp
  802959:	56                   	push   %esi
  80295a:	53                   	push   %ebx
  80295b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80295e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802961:	50                   	push   %eax
  802962:	e8 19 ef ff ff       	call   801880 <fd_alloc>
  802967:	89 c3                	mov    %eax,%ebx
  802969:	83 c4 10             	add    $0x10,%esp
  80296c:	85 c0                	test   %eax,%eax
  80296e:	0f 88 23 01 00 00    	js     802a97 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802974:	83 ec 04             	sub    $0x4,%esp
  802977:	68 07 04 00 00       	push   $0x407
  80297c:	ff 75 f4             	pushl  -0xc(%ebp)
  80297f:	6a 00                	push   $0x0
  802981:	e8 de eb ff ff       	call   801564 <sys_page_alloc>
  802986:	89 c3                	mov    %eax,%ebx
  802988:	83 c4 10             	add    $0x10,%esp
  80298b:	85 c0                	test   %eax,%eax
  80298d:	0f 88 04 01 00 00    	js     802a97 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802993:	83 ec 0c             	sub    $0xc,%esp
  802996:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802999:	50                   	push   %eax
  80299a:	e8 e1 ee ff ff       	call   801880 <fd_alloc>
  80299f:	89 c3                	mov    %eax,%ebx
  8029a1:	83 c4 10             	add    $0x10,%esp
  8029a4:	85 c0                	test   %eax,%eax
  8029a6:	0f 88 db 00 00 00    	js     802a87 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8029ac:	83 ec 04             	sub    $0x4,%esp
  8029af:	68 07 04 00 00       	push   $0x407
  8029b4:	ff 75 f0             	pushl  -0x10(%ebp)
  8029b7:	6a 00                	push   $0x0
  8029b9:	e8 a6 eb ff ff       	call   801564 <sys_page_alloc>
  8029be:	89 c3                	mov    %eax,%ebx
  8029c0:	83 c4 10             	add    $0x10,%esp
  8029c3:	85 c0                	test   %eax,%eax
  8029c5:	0f 88 bc 00 00 00    	js     802a87 <pipe+0x131>
	va = fd2data(fd0);
  8029cb:	83 ec 0c             	sub    $0xc,%esp
  8029ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8029d1:	e8 93 ee ff ff       	call   801869 <fd2data>
  8029d6:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8029d8:	83 c4 0c             	add    $0xc,%esp
  8029db:	68 07 04 00 00       	push   $0x407
  8029e0:	50                   	push   %eax
  8029e1:	6a 00                	push   $0x0
  8029e3:	e8 7c eb ff ff       	call   801564 <sys_page_alloc>
  8029e8:	89 c3                	mov    %eax,%ebx
  8029ea:	83 c4 10             	add    $0x10,%esp
  8029ed:	85 c0                	test   %eax,%eax
  8029ef:	0f 88 82 00 00 00    	js     802a77 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8029f5:	83 ec 0c             	sub    $0xc,%esp
  8029f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8029fb:	e8 69 ee ff ff       	call   801869 <fd2data>
  802a00:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802a07:	50                   	push   %eax
  802a08:	6a 00                	push   $0x0
  802a0a:	56                   	push   %esi
  802a0b:	6a 00                	push   $0x0
  802a0d:	e8 95 eb ff ff       	call   8015a7 <sys_page_map>
  802a12:	89 c3                	mov    %eax,%ebx
  802a14:	83 c4 20             	add    $0x20,%esp
  802a17:	85 c0                	test   %eax,%eax
  802a19:	78 4e                	js     802a69 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802a1b:	a1 5c 40 80 00       	mov    0x80405c,%eax
  802a20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a23:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802a25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a28:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802a2f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a32:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802a34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a37:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802a3e:	83 ec 0c             	sub    $0xc,%esp
  802a41:	ff 75 f4             	pushl  -0xc(%ebp)
  802a44:	e8 10 ee ff ff       	call   801859 <fd2num>
  802a49:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802a4c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802a4e:	83 c4 04             	add    $0x4,%esp
  802a51:	ff 75 f0             	pushl  -0x10(%ebp)
  802a54:	e8 00 ee ff ff       	call   801859 <fd2num>
  802a59:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802a5c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802a5f:	83 c4 10             	add    $0x10,%esp
  802a62:	bb 00 00 00 00       	mov    $0x0,%ebx
  802a67:	eb 2e                	jmp    802a97 <pipe+0x141>
	sys_page_unmap(0, va);
  802a69:	83 ec 08             	sub    $0x8,%esp
  802a6c:	56                   	push   %esi
  802a6d:	6a 00                	push   $0x0
  802a6f:	e8 75 eb ff ff       	call   8015e9 <sys_page_unmap>
  802a74:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802a77:	83 ec 08             	sub    $0x8,%esp
  802a7a:	ff 75 f0             	pushl  -0x10(%ebp)
  802a7d:	6a 00                	push   $0x0
  802a7f:	e8 65 eb ff ff       	call   8015e9 <sys_page_unmap>
  802a84:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802a87:	83 ec 08             	sub    $0x8,%esp
  802a8a:	ff 75 f4             	pushl  -0xc(%ebp)
  802a8d:	6a 00                	push   $0x0
  802a8f:	e8 55 eb ff ff       	call   8015e9 <sys_page_unmap>
  802a94:	83 c4 10             	add    $0x10,%esp
}
  802a97:	89 d8                	mov    %ebx,%eax
  802a99:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a9c:	5b                   	pop    %ebx
  802a9d:	5e                   	pop    %esi
  802a9e:	5d                   	pop    %ebp
  802a9f:	c3                   	ret    

00802aa0 <pipeisclosed>:
{
  802aa0:	55                   	push   %ebp
  802aa1:	89 e5                	mov    %esp,%ebp
  802aa3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802aa6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802aa9:	50                   	push   %eax
  802aaa:	ff 75 08             	pushl  0x8(%ebp)
  802aad:	e8 20 ee ff ff       	call   8018d2 <fd_lookup>
  802ab2:	83 c4 10             	add    $0x10,%esp
  802ab5:	85 c0                	test   %eax,%eax
  802ab7:	78 18                	js     802ad1 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802ab9:	83 ec 0c             	sub    $0xc,%esp
  802abc:	ff 75 f4             	pushl  -0xc(%ebp)
  802abf:	e8 a5 ed ff ff       	call   801869 <fd2data>
	return _pipeisclosed(fd, p);
  802ac4:	89 c2                	mov    %eax,%edx
  802ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac9:	e8 2f fd ff ff       	call   8027fd <_pipeisclosed>
  802ace:	83 c4 10             	add    $0x10,%esp
}
  802ad1:	c9                   	leave  
  802ad2:	c3                   	ret    

00802ad3 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802ad3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad8:	c3                   	ret    

00802ad9 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802ad9:	55                   	push   %ebp
  802ada:	89 e5                	mov    %esp,%ebp
  802adc:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802adf:	68 e4 37 80 00       	push   $0x8037e4
  802ae4:	ff 75 0c             	pushl  0xc(%ebp)
  802ae7:	e8 86 e6 ff ff       	call   801172 <strcpy>
	return 0;
}
  802aec:	b8 00 00 00 00       	mov    $0x0,%eax
  802af1:	c9                   	leave  
  802af2:	c3                   	ret    

00802af3 <devcons_write>:
{
  802af3:	55                   	push   %ebp
  802af4:	89 e5                	mov    %esp,%ebp
  802af6:	57                   	push   %edi
  802af7:	56                   	push   %esi
  802af8:	53                   	push   %ebx
  802af9:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802aff:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802b04:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802b0a:	3b 75 10             	cmp    0x10(%ebp),%esi
  802b0d:	73 31                	jae    802b40 <devcons_write+0x4d>
		m = n - tot;
  802b0f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802b12:	29 f3                	sub    %esi,%ebx
  802b14:	83 fb 7f             	cmp    $0x7f,%ebx
  802b17:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802b1c:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802b1f:	83 ec 04             	sub    $0x4,%esp
  802b22:	53                   	push   %ebx
  802b23:	89 f0                	mov    %esi,%eax
  802b25:	03 45 0c             	add    0xc(%ebp),%eax
  802b28:	50                   	push   %eax
  802b29:	57                   	push   %edi
  802b2a:	e8 d1 e7 ff ff       	call   801300 <memmove>
		sys_cputs(buf, m);
  802b2f:	83 c4 08             	add    $0x8,%esp
  802b32:	53                   	push   %ebx
  802b33:	57                   	push   %edi
  802b34:	e8 6f e9 ff ff       	call   8014a8 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802b39:	01 de                	add    %ebx,%esi
  802b3b:	83 c4 10             	add    $0x10,%esp
  802b3e:	eb ca                	jmp    802b0a <devcons_write+0x17>
}
  802b40:	89 f0                	mov    %esi,%eax
  802b42:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802b45:	5b                   	pop    %ebx
  802b46:	5e                   	pop    %esi
  802b47:	5f                   	pop    %edi
  802b48:	5d                   	pop    %ebp
  802b49:	c3                   	ret    

00802b4a <devcons_read>:
{
  802b4a:	55                   	push   %ebp
  802b4b:	89 e5                	mov    %esp,%ebp
  802b4d:	83 ec 08             	sub    $0x8,%esp
  802b50:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802b55:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802b59:	74 21                	je     802b7c <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802b5b:	e8 66 e9 ff ff       	call   8014c6 <sys_cgetc>
  802b60:	85 c0                	test   %eax,%eax
  802b62:	75 07                	jne    802b6b <devcons_read+0x21>
		sys_yield();
  802b64:	e8 dc e9 ff ff       	call   801545 <sys_yield>
  802b69:	eb f0                	jmp    802b5b <devcons_read+0x11>
	if (c < 0)
  802b6b:	78 0f                	js     802b7c <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802b6d:	83 f8 04             	cmp    $0x4,%eax
  802b70:	74 0c                	je     802b7e <devcons_read+0x34>
	*(char*)vbuf = c;
  802b72:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b75:	88 02                	mov    %al,(%edx)
	return 1;
  802b77:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802b7c:	c9                   	leave  
  802b7d:	c3                   	ret    
		return 0;
  802b7e:	b8 00 00 00 00       	mov    $0x0,%eax
  802b83:	eb f7                	jmp    802b7c <devcons_read+0x32>

00802b85 <cputchar>:
{
  802b85:	55                   	push   %ebp
  802b86:	89 e5                	mov    %esp,%ebp
  802b88:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8e:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802b91:	6a 01                	push   $0x1
  802b93:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802b96:	50                   	push   %eax
  802b97:	e8 0c e9 ff ff       	call   8014a8 <sys_cputs>
}
  802b9c:	83 c4 10             	add    $0x10,%esp
  802b9f:	c9                   	leave  
  802ba0:	c3                   	ret    

00802ba1 <getchar>:
{
  802ba1:	55                   	push   %ebp
  802ba2:	89 e5                	mov    %esp,%ebp
  802ba4:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802ba7:	6a 01                	push   $0x1
  802ba9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802bac:	50                   	push   %eax
  802bad:	6a 00                	push   $0x0
  802baf:	e8 8e ef ff ff       	call   801b42 <read>
	if (r < 0)
  802bb4:	83 c4 10             	add    $0x10,%esp
  802bb7:	85 c0                	test   %eax,%eax
  802bb9:	78 06                	js     802bc1 <getchar+0x20>
	if (r < 1)
  802bbb:	74 06                	je     802bc3 <getchar+0x22>
	return c;
  802bbd:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802bc1:	c9                   	leave  
  802bc2:	c3                   	ret    
		return -E_EOF;
  802bc3:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802bc8:	eb f7                	jmp    802bc1 <getchar+0x20>

00802bca <iscons>:
{
  802bca:	55                   	push   %ebp
  802bcb:	89 e5                	mov    %esp,%ebp
  802bcd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802bd0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802bd3:	50                   	push   %eax
  802bd4:	ff 75 08             	pushl  0x8(%ebp)
  802bd7:	e8 f6 ec ff ff       	call   8018d2 <fd_lookup>
  802bdc:	83 c4 10             	add    $0x10,%esp
  802bdf:	85 c0                	test   %eax,%eax
  802be1:	78 11                	js     802bf4 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be6:	8b 15 78 40 80 00    	mov    0x804078,%edx
  802bec:	39 10                	cmp    %edx,(%eax)
  802bee:	0f 94 c0             	sete   %al
  802bf1:	0f b6 c0             	movzbl %al,%eax
}
  802bf4:	c9                   	leave  
  802bf5:	c3                   	ret    

00802bf6 <opencons>:
{
  802bf6:	55                   	push   %ebp
  802bf7:	89 e5                	mov    %esp,%ebp
  802bf9:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802bfc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802bff:	50                   	push   %eax
  802c00:	e8 7b ec ff ff       	call   801880 <fd_alloc>
  802c05:	83 c4 10             	add    $0x10,%esp
  802c08:	85 c0                	test   %eax,%eax
  802c0a:	78 3a                	js     802c46 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802c0c:	83 ec 04             	sub    $0x4,%esp
  802c0f:	68 07 04 00 00       	push   $0x407
  802c14:	ff 75 f4             	pushl  -0xc(%ebp)
  802c17:	6a 00                	push   $0x0
  802c19:	e8 46 e9 ff ff       	call   801564 <sys_page_alloc>
  802c1e:	83 c4 10             	add    $0x10,%esp
  802c21:	85 c0                	test   %eax,%eax
  802c23:	78 21                	js     802c46 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c28:	8b 15 78 40 80 00    	mov    0x804078,%edx
  802c2e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c33:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802c3a:	83 ec 0c             	sub    $0xc,%esp
  802c3d:	50                   	push   %eax
  802c3e:	e8 16 ec ff ff       	call   801859 <fd2num>
  802c43:	83 c4 10             	add    $0x10,%esp
}
  802c46:	c9                   	leave  
  802c47:	c3                   	ret    

00802c48 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802c48:	55                   	push   %ebp
  802c49:	89 e5                	mov    %esp,%ebp
  802c4b:	56                   	push   %esi
  802c4c:	53                   	push   %ebx
  802c4d:	8b 75 08             	mov    0x8(%ebp),%esi
  802c50:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c53:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802c56:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802c58:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802c5d:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802c60:	83 ec 0c             	sub    $0xc,%esp
  802c63:	50                   	push   %eax
  802c64:	e8 ab ea ff ff       	call   801714 <sys_ipc_recv>
	if(ret < 0){
  802c69:	83 c4 10             	add    $0x10,%esp
  802c6c:	85 c0                	test   %eax,%eax
  802c6e:	78 2b                	js     802c9b <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802c70:	85 f6                	test   %esi,%esi
  802c72:	74 0a                	je     802c7e <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802c74:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802c79:	8b 40 74             	mov    0x74(%eax),%eax
  802c7c:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802c7e:	85 db                	test   %ebx,%ebx
  802c80:	74 0a                	je     802c8c <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802c82:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802c87:	8b 40 78             	mov    0x78(%eax),%eax
  802c8a:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802c8c:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802c91:	8b 40 70             	mov    0x70(%eax),%eax
}
  802c94:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802c97:	5b                   	pop    %ebx
  802c98:	5e                   	pop    %esi
  802c99:	5d                   	pop    %ebp
  802c9a:	c3                   	ret    
		if(from_env_store)
  802c9b:	85 f6                	test   %esi,%esi
  802c9d:	74 06                	je     802ca5 <ipc_recv+0x5d>
			*from_env_store = 0;
  802c9f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802ca5:	85 db                	test   %ebx,%ebx
  802ca7:	74 eb                	je     802c94 <ipc_recv+0x4c>
			*perm_store = 0;
  802ca9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802caf:	eb e3                	jmp    802c94 <ipc_recv+0x4c>

00802cb1 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802cb1:	55                   	push   %ebp
  802cb2:	89 e5                	mov    %esp,%ebp
  802cb4:	57                   	push   %edi
  802cb5:	56                   	push   %esi
  802cb6:	53                   	push   %ebx
  802cb7:	83 ec 0c             	sub    $0xc,%esp
  802cba:	8b 7d 08             	mov    0x8(%ebp),%edi
  802cbd:	8b 75 0c             	mov    0xc(%ebp),%esi
  802cc0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802cc3:	85 db                	test   %ebx,%ebx
  802cc5:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802cca:	0f 44 d8             	cmove  %eax,%ebx
  802ccd:	eb 05                	jmp    802cd4 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802ccf:	e8 71 e8 ff ff       	call   801545 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802cd4:	ff 75 14             	pushl  0x14(%ebp)
  802cd7:	53                   	push   %ebx
  802cd8:	56                   	push   %esi
  802cd9:	57                   	push   %edi
  802cda:	e8 12 ea ff ff       	call   8016f1 <sys_ipc_try_send>
  802cdf:	83 c4 10             	add    $0x10,%esp
  802ce2:	85 c0                	test   %eax,%eax
  802ce4:	74 1b                	je     802d01 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802ce6:	79 e7                	jns    802ccf <ipc_send+0x1e>
  802ce8:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802ceb:	74 e2                	je     802ccf <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802ced:	83 ec 04             	sub    $0x4,%esp
  802cf0:	68 f0 37 80 00       	push   $0x8037f0
  802cf5:	6a 46                	push   $0x46
  802cf7:	68 05 38 80 00       	push   $0x803805
  802cfc:	e8 1c dc ff ff       	call   80091d <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802d01:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d04:	5b                   	pop    %ebx
  802d05:	5e                   	pop    %esi
  802d06:	5f                   	pop    %edi
  802d07:	5d                   	pop    %ebp
  802d08:	c3                   	ret    

00802d09 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802d09:	55                   	push   %ebp
  802d0a:	89 e5                	mov    %esp,%ebp
  802d0c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802d0f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802d14:	89 c2                	mov    %eax,%edx
  802d16:	c1 e2 07             	shl    $0x7,%edx
  802d19:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802d1f:	8b 52 50             	mov    0x50(%edx),%edx
  802d22:	39 ca                	cmp    %ecx,%edx
  802d24:	74 11                	je     802d37 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802d26:	83 c0 01             	add    $0x1,%eax
  802d29:	3d 00 04 00 00       	cmp    $0x400,%eax
  802d2e:	75 e4                	jne    802d14 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802d30:	b8 00 00 00 00       	mov    $0x0,%eax
  802d35:	eb 0b                	jmp    802d42 <ipc_find_env+0x39>
			return envs[i].env_id;
  802d37:	c1 e0 07             	shl    $0x7,%eax
  802d3a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802d3f:	8b 40 48             	mov    0x48(%eax),%eax
}
  802d42:	5d                   	pop    %ebp
  802d43:	c3                   	ret    

00802d44 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802d44:	55                   	push   %ebp
  802d45:	89 e5                	mov    %esp,%ebp
  802d47:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802d4a:	89 d0                	mov    %edx,%eax
  802d4c:	c1 e8 16             	shr    $0x16,%eax
  802d4f:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802d56:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802d5b:	f6 c1 01             	test   $0x1,%cl
  802d5e:	74 1d                	je     802d7d <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802d60:	c1 ea 0c             	shr    $0xc,%edx
  802d63:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802d6a:	f6 c2 01             	test   $0x1,%dl
  802d6d:	74 0e                	je     802d7d <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802d6f:	c1 ea 0c             	shr    $0xc,%edx
  802d72:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802d79:	ef 
  802d7a:	0f b7 c0             	movzwl %ax,%eax
}
  802d7d:	5d                   	pop    %ebp
  802d7e:	c3                   	ret    
  802d7f:	90                   	nop

00802d80 <__udivdi3>:
  802d80:	55                   	push   %ebp
  802d81:	57                   	push   %edi
  802d82:	56                   	push   %esi
  802d83:	53                   	push   %ebx
  802d84:	83 ec 1c             	sub    $0x1c,%esp
  802d87:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802d8b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802d8f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802d93:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802d97:	85 d2                	test   %edx,%edx
  802d99:	75 4d                	jne    802de8 <__udivdi3+0x68>
  802d9b:	39 f3                	cmp    %esi,%ebx
  802d9d:	76 19                	jbe    802db8 <__udivdi3+0x38>
  802d9f:	31 ff                	xor    %edi,%edi
  802da1:	89 e8                	mov    %ebp,%eax
  802da3:	89 f2                	mov    %esi,%edx
  802da5:	f7 f3                	div    %ebx
  802da7:	89 fa                	mov    %edi,%edx
  802da9:	83 c4 1c             	add    $0x1c,%esp
  802dac:	5b                   	pop    %ebx
  802dad:	5e                   	pop    %esi
  802dae:	5f                   	pop    %edi
  802daf:	5d                   	pop    %ebp
  802db0:	c3                   	ret    
  802db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802db8:	89 d9                	mov    %ebx,%ecx
  802dba:	85 db                	test   %ebx,%ebx
  802dbc:	75 0b                	jne    802dc9 <__udivdi3+0x49>
  802dbe:	b8 01 00 00 00       	mov    $0x1,%eax
  802dc3:	31 d2                	xor    %edx,%edx
  802dc5:	f7 f3                	div    %ebx
  802dc7:	89 c1                	mov    %eax,%ecx
  802dc9:	31 d2                	xor    %edx,%edx
  802dcb:	89 f0                	mov    %esi,%eax
  802dcd:	f7 f1                	div    %ecx
  802dcf:	89 c6                	mov    %eax,%esi
  802dd1:	89 e8                	mov    %ebp,%eax
  802dd3:	89 f7                	mov    %esi,%edi
  802dd5:	f7 f1                	div    %ecx
  802dd7:	89 fa                	mov    %edi,%edx
  802dd9:	83 c4 1c             	add    $0x1c,%esp
  802ddc:	5b                   	pop    %ebx
  802ddd:	5e                   	pop    %esi
  802dde:	5f                   	pop    %edi
  802ddf:	5d                   	pop    %ebp
  802de0:	c3                   	ret    
  802de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802de8:	39 f2                	cmp    %esi,%edx
  802dea:	77 1c                	ja     802e08 <__udivdi3+0x88>
  802dec:	0f bd fa             	bsr    %edx,%edi
  802def:	83 f7 1f             	xor    $0x1f,%edi
  802df2:	75 2c                	jne    802e20 <__udivdi3+0xa0>
  802df4:	39 f2                	cmp    %esi,%edx
  802df6:	72 06                	jb     802dfe <__udivdi3+0x7e>
  802df8:	31 c0                	xor    %eax,%eax
  802dfa:	39 eb                	cmp    %ebp,%ebx
  802dfc:	77 a9                	ja     802da7 <__udivdi3+0x27>
  802dfe:	b8 01 00 00 00       	mov    $0x1,%eax
  802e03:	eb a2                	jmp    802da7 <__udivdi3+0x27>
  802e05:	8d 76 00             	lea    0x0(%esi),%esi
  802e08:	31 ff                	xor    %edi,%edi
  802e0a:	31 c0                	xor    %eax,%eax
  802e0c:	89 fa                	mov    %edi,%edx
  802e0e:	83 c4 1c             	add    $0x1c,%esp
  802e11:	5b                   	pop    %ebx
  802e12:	5e                   	pop    %esi
  802e13:	5f                   	pop    %edi
  802e14:	5d                   	pop    %ebp
  802e15:	c3                   	ret    
  802e16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802e1d:	8d 76 00             	lea    0x0(%esi),%esi
  802e20:	89 f9                	mov    %edi,%ecx
  802e22:	b8 20 00 00 00       	mov    $0x20,%eax
  802e27:	29 f8                	sub    %edi,%eax
  802e29:	d3 e2                	shl    %cl,%edx
  802e2b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802e2f:	89 c1                	mov    %eax,%ecx
  802e31:	89 da                	mov    %ebx,%edx
  802e33:	d3 ea                	shr    %cl,%edx
  802e35:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802e39:	09 d1                	or     %edx,%ecx
  802e3b:	89 f2                	mov    %esi,%edx
  802e3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802e41:	89 f9                	mov    %edi,%ecx
  802e43:	d3 e3                	shl    %cl,%ebx
  802e45:	89 c1                	mov    %eax,%ecx
  802e47:	d3 ea                	shr    %cl,%edx
  802e49:	89 f9                	mov    %edi,%ecx
  802e4b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802e4f:	89 eb                	mov    %ebp,%ebx
  802e51:	d3 e6                	shl    %cl,%esi
  802e53:	89 c1                	mov    %eax,%ecx
  802e55:	d3 eb                	shr    %cl,%ebx
  802e57:	09 de                	or     %ebx,%esi
  802e59:	89 f0                	mov    %esi,%eax
  802e5b:	f7 74 24 08          	divl   0x8(%esp)
  802e5f:	89 d6                	mov    %edx,%esi
  802e61:	89 c3                	mov    %eax,%ebx
  802e63:	f7 64 24 0c          	mull   0xc(%esp)
  802e67:	39 d6                	cmp    %edx,%esi
  802e69:	72 15                	jb     802e80 <__udivdi3+0x100>
  802e6b:	89 f9                	mov    %edi,%ecx
  802e6d:	d3 e5                	shl    %cl,%ebp
  802e6f:	39 c5                	cmp    %eax,%ebp
  802e71:	73 04                	jae    802e77 <__udivdi3+0xf7>
  802e73:	39 d6                	cmp    %edx,%esi
  802e75:	74 09                	je     802e80 <__udivdi3+0x100>
  802e77:	89 d8                	mov    %ebx,%eax
  802e79:	31 ff                	xor    %edi,%edi
  802e7b:	e9 27 ff ff ff       	jmp    802da7 <__udivdi3+0x27>
  802e80:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802e83:	31 ff                	xor    %edi,%edi
  802e85:	e9 1d ff ff ff       	jmp    802da7 <__udivdi3+0x27>
  802e8a:	66 90                	xchg   %ax,%ax
  802e8c:	66 90                	xchg   %ax,%ax
  802e8e:	66 90                	xchg   %ax,%ax

00802e90 <__umoddi3>:
  802e90:	55                   	push   %ebp
  802e91:	57                   	push   %edi
  802e92:	56                   	push   %esi
  802e93:	53                   	push   %ebx
  802e94:	83 ec 1c             	sub    $0x1c,%esp
  802e97:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802e9b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802e9f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802ea3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802ea7:	89 da                	mov    %ebx,%edx
  802ea9:	85 c0                	test   %eax,%eax
  802eab:	75 43                	jne    802ef0 <__umoddi3+0x60>
  802ead:	39 df                	cmp    %ebx,%edi
  802eaf:	76 17                	jbe    802ec8 <__umoddi3+0x38>
  802eb1:	89 f0                	mov    %esi,%eax
  802eb3:	f7 f7                	div    %edi
  802eb5:	89 d0                	mov    %edx,%eax
  802eb7:	31 d2                	xor    %edx,%edx
  802eb9:	83 c4 1c             	add    $0x1c,%esp
  802ebc:	5b                   	pop    %ebx
  802ebd:	5e                   	pop    %esi
  802ebe:	5f                   	pop    %edi
  802ebf:	5d                   	pop    %ebp
  802ec0:	c3                   	ret    
  802ec1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ec8:	89 fd                	mov    %edi,%ebp
  802eca:	85 ff                	test   %edi,%edi
  802ecc:	75 0b                	jne    802ed9 <__umoddi3+0x49>
  802ece:	b8 01 00 00 00       	mov    $0x1,%eax
  802ed3:	31 d2                	xor    %edx,%edx
  802ed5:	f7 f7                	div    %edi
  802ed7:	89 c5                	mov    %eax,%ebp
  802ed9:	89 d8                	mov    %ebx,%eax
  802edb:	31 d2                	xor    %edx,%edx
  802edd:	f7 f5                	div    %ebp
  802edf:	89 f0                	mov    %esi,%eax
  802ee1:	f7 f5                	div    %ebp
  802ee3:	89 d0                	mov    %edx,%eax
  802ee5:	eb d0                	jmp    802eb7 <__umoddi3+0x27>
  802ee7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802eee:	66 90                	xchg   %ax,%ax
  802ef0:	89 f1                	mov    %esi,%ecx
  802ef2:	39 d8                	cmp    %ebx,%eax
  802ef4:	76 0a                	jbe    802f00 <__umoddi3+0x70>
  802ef6:	89 f0                	mov    %esi,%eax
  802ef8:	83 c4 1c             	add    $0x1c,%esp
  802efb:	5b                   	pop    %ebx
  802efc:	5e                   	pop    %esi
  802efd:	5f                   	pop    %edi
  802efe:	5d                   	pop    %ebp
  802eff:	c3                   	ret    
  802f00:	0f bd e8             	bsr    %eax,%ebp
  802f03:	83 f5 1f             	xor    $0x1f,%ebp
  802f06:	75 20                	jne    802f28 <__umoddi3+0x98>
  802f08:	39 d8                	cmp    %ebx,%eax
  802f0a:	0f 82 b0 00 00 00    	jb     802fc0 <__umoddi3+0x130>
  802f10:	39 f7                	cmp    %esi,%edi
  802f12:	0f 86 a8 00 00 00    	jbe    802fc0 <__umoddi3+0x130>
  802f18:	89 c8                	mov    %ecx,%eax
  802f1a:	83 c4 1c             	add    $0x1c,%esp
  802f1d:	5b                   	pop    %ebx
  802f1e:	5e                   	pop    %esi
  802f1f:	5f                   	pop    %edi
  802f20:	5d                   	pop    %ebp
  802f21:	c3                   	ret    
  802f22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802f28:	89 e9                	mov    %ebp,%ecx
  802f2a:	ba 20 00 00 00       	mov    $0x20,%edx
  802f2f:	29 ea                	sub    %ebp,%edx
  802f31:	d3 e0                	shl    %cl,%eax
  802f33:	89 44 24 08          	mov    %eax,0x8(%esp)
  802f37:	89 d1                	mov    %edx,%ecx
  802f39:	89 f8                	mov    %edi,%eax
  802f3b:	d3 e8                	shr    %cl,%eax
  802f3d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802f41:	89 54 24 04          	mov    %edx,0x4(%esp)
  802f45:	8b 54 24 04          	mov    0x4(%esp),%edx
  802f49:	09 c1                	or     %eax,%ecx
  802f4b:	89 d8                	mov    %ebx,%eax
  802f4d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802f51:	89 e9                	mov    %ebp,%ecx
  802f53:	d3 e7                	shl    %cl,%edi
  802f55:	89 d1                	mov    %edx,%ecx
  802f57:	d3 e8                	shr    %cl,%eax
  802f59:	89 e9                	mov    %ebp,%ecx
  802f5b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802f5f:	d3 e3                	shl    %cl,%ebx
  802f61:	89 c7                	mov    %eax,%edi
  802f63:	89 d1                	mov    %edx,%ecx
  802f65:	89 f0                	mov    %esi,%eax
  802f67:	d3 e8                	shr    %cl,%eax
  802f69:	89 e9                	mov    %ebp,%ecx
  802f6b:	89 fa                	mov    %edi,%edx
  802f6d:	d3 e6                	shl    %cl,%esi
  802f6f:	09 d8                	or     %ebx,%eax
  802f71:	f7 74 24 08          	divl   0x8(%esp)
  802f75:	89 d1                	mov    %edx,%ecx
  802f77:	89 f3                	mov    %esi,%ebx
  802f79:	f7 64 24 0c          	mull   0xc(%esp)
  802f7d:	89 c6                	mov    %eax,%esi
  802f7f:	89 d7                	mov    %edx,%edi
  802f81:	39 d1                	cmp    %edx,%ecx
  802f83:	72 06                	jb     802f8b <__umoddi3+0xfb>
  802f85:	75 10                	jne    802f97 <__umoddi3+0x107>
  802f87:	39 c3                	cmp    %eax,%ebx
  802f89:	73 0c                	jae    802f97 <__umoddi3+0x107>
  802f8b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802f8f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802f93:	89 d7                	mov    %edx,%edi
  802f95:	89 c6                	mov    %eax,%esi
  802f97:	89 ca                	mov    %ecx,%edx
  802f99:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802f9e:	29 f3                	sub    %esi,%ebx
  802fa0:	19 fa                	sbb    %edi,%edx
  802fa2:	89 d0                	mov    %edx,%eax
  802fa4:	d3 e0                	shl    %cl,%eax
  802fa6:	89 e9                	mov    %ebp,%ecx
  802fa8:	d3 eb                	shr    %cl,%ebx
  802faa:	d3 ea                	shr    %cl,%edx
  802fac:	09 d8                	or     %ebx,%eax
  802fae:	83 c4 1c             	add    $0x1c,%esp
  802fb1:	5b                   	pop    %ebx
  802fb2:	5e                   	pop    %esi
  802fb3:	5f                   	pop    %edi
  802fb4:	5d                   	pop    %ebp
  802fb5:	c3                   	ret    
  802fb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802fbd:	8d 76 00             	lea    0x0(%esi),%esi
  802fc0:	89 da                	mov    %ebx,%edx
  802fc2:	29 fe                	sub    %edi,%esi
  802fc4:	19 c2                	sbb    %eax,%edx
  802fc6:	89 f1                	mov    %esi,%ecx
  802fc8:	89 c8                	mov    %ecx,%eax
  802fca:	e9 4b ff ff ff       	jmp    802f1a <__umoddi3+0x8a>
