
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
  80003a:	68 5d 32 80 00       	push   $0x80325d
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
  800080:	68 ac 30 80 00       	push   $0x8030ac
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
  80009f:	e8 4a 1b 00 00       	call   801bee <write>
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
  8000db:	e8 42 1a 00 00       	call   801b22 <read>
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
  8000ff:	68 dc 2f 80 00       	push   $0x802fdc
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
  80012e:	68 c0 2f 80 00       	push   $0x802fc0
  800133:	68 22 01 00 00       	push   $0x122
  800138:	68 cf 2f 80 00       	push   $0x802fcf
  80013d:	e8 db 07 00 00       	call   80091d <_panic>
	url_len = request - url;
  800142:	89 df                	mov    %ebx,%edi
  800144:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
  80014a:	29 c7                	sub    %eax,%edi
	req->url = malloc(url_len + 1);
  80014c:	83 ec 0c             	sub    $0xc,%esp
  80014f:	8d 47 01             	lea    0x1(%edi),%eax
  800152:	50                   	push   %eax
  800153:	e8 20 24 00 00       	call   802578 <malloc>
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
  800197:	e8 dc 23 00 00       	call   802578 <malloc>
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
  8001b9:	e8 02 1e 00 00       	call   801fc0 <open>
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
  8001d2:	e8 41 1b 00 00       	call   801d18 <fstat>
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
  800221:	e8 be 17 00 00       	call   8019e4 <close>
  800226:	83 c4 10             	add    $0x10,%esp
	free(req->url);
  800229:	83 ec 0c             	sub    $0xc,%esp
  80022c:	ff 75 e0             	pushl  -0x20(%ebp)
  80022f:	e8 98 22 00 00       	call   8024cc <free>
	free(req->version);
  800234:	83 c4 04             	add    $0x4,%esp
  800237:	ff 75 e4             	pushl  -0x1c(%ebp)
  80023a:	e8 8d 22 00 00       	call   8024cc <free>

		// no keep alive
		break;
	}

	close(sock);
  80023f:	89 34 24             	mov    %esi,(%esp)
  800242:	e8 9d 17 00 00       	call   8019e4 <close>
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
  800279:	e8 70 19 00 00       	call   801bee <write>
  80027e:	83 c4 10             	add    $0x10,%esp
  800281:	39 85 c4 f6 ff ff    	cmp    %eax,-0x93c(%ebp)
  800287:	0f 85 3d 01 00 00    	jne    8003ca <handle_client+0x30a>
	r = snprintf(buf, 64, "Content-Length: %ld\r\n", (long)size);
  80028d:	ff b5 c0 f6 ff ff    	pushl  -0x940(%ebp)
  800293:	68 5e 30 80 00       	push   $0x80305e
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
  8002c2:	e8 27 19 00 00       	call   801bee <write>
	if ((r = send_size(req, file_size)) < 0)
  8002c7:	83 c4 10             	add    $0x10,%esp
  8002ca:	39 c3                	cmp    %eax,%ebx
  8002cc:	0f 85 4b ff ff ff    	jne    80021d <handle_client+0x15d>
	r = snprintf(buf, 128, "Content-Type: %s\r\n", type);
  8002d2:	68 f3 2f 80 00       	push   $0x802ff3
  8002d7:	68 fd 2f 80 00       	push   $0x802ffd
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
  800309:	e8 e0 18 00 00       	call   801bee <write>
	if ((r = send_content_type(req)) < 0)
  80030e:	83 c4 10             	add    $0x10,%esp
  800311:	39 c3                	cmp    %eax,%ebx
  800313:	0f 85 04 ff ff ff    	jne    80021d <handle_client+0x15d>
	int fin_len = strlen(fin);
  800319:	83 ec 0c             	sub    $0xc,%esp
  80031c:	68 71 30 80 00       	push   $0x803071
  800321:	e8 13 0e 00 00       	call   801139 <strlen>
  800326:	89 c3                	mov    %eax,%ebx
	if (write(req->sock, fin, fin_len) != fin_len)
  800328:	83 c4 0c             	add    $0xc,%esp
  80032b:	50                   	push   %eax
  80032c:	68 71 30 80 00       	push   $0x803071
  800331:	ff 75 dc             	pushl  -0x24(%ebp)
  800334:	e8 b5 18 00 00       	call   801bee <write>
	if ((r = send_header_fin(req)) < 0)
  800339:	83 c4 10             	add    $0x10,%esp
  80033c:	39 c3                	cmp    %eax,%ebx
  80033e:	0f 85 d9 fe ff ff    	jne    80021d <handle_client+0x15d>
  	if ((r = fstat(fd, &stat)) < 0)
  800344:	83 ec 08             	sub    $0x8,%esp
  800347:	8d 85 60 f7 ff ff    	lea    -0x8a0(%ebp),%eax
  80034d:	50                   	push   %eax
  80034e:	57                   	push   %edi
  80034f:	e8 c4 19 00 00       	call   801d18 <fstat>
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
  800380:	e8 24 18 00 00       	call   801ba9 <readn>
  800385:	83 c4 10             	add    $0x10,%esp
  800388:	3b 85 e0 f7 ff ff    	cmp    -0x820(%ebp),%eax
  80038e:	0f 85 8e 00 00 00    	jne    800422 <handle_client+0x362>
  	if ((r = write(req->sock, buf, stat.st_size)) != stat.st_size)
  800394:	83 ec 04             	sub    $0x4,%esp
  800397:	ff b5 e0 f7 ff ff    	pushl  -0x820(%ebp)
  80039d:	8d 85 ee f7 ff ff    	lea    -0x812(%ebp),%eax
  8003a3:	50                   	push   %eax
  8003a4:	ff 75 dc             	pushl  -0x24(%ebp)
  8003a7:	e8 42 18 00 00       	call   801bee <write>
  8003ac:	83 c4 10             	add    $0x10,%esp
  8003af:	3b 85 e0 f7 ff ff    	cmp    -0x820(%ebp),%eax
  8003b5:	0f 84 62 fe ff ff    	je     80021d <handle_client+0x15d>
    	die("not write all data");
  8003bb:	b8 4b 30 80 00       	mov    $0x80304b,%eax
  8003c0:	e8 6e fc ff ff       	call   800033 <die>
  8003c5:	e9 53 fe ff ff       	jmp    80021d <handle_client+0x15d>
		die("Failed to send bytes to client");
  8003ca:	b8 28 31 80 00       	mov    $0x803128,%eax
  8003cf:	e8 5f fc ff ff       	call   800033 <die>
  8003d4:	e9 b4 fe ff ff       	jmp    80028d <handle_client+0x1cd>
		panic("buffer too small!");
  8003d9:	83 ec 04             	sub    $0x4,%esp
  8003dc:	68 e1 2f 80 00       	push   $0x802fe1
  8003e1:	6a 67                	push   $0x67
  8003e3:	68 cf 2f 80 00       	push   $0x802fcf
  8003e8:	e8 30 05 00 00       	call   80091d <_panic>
		panic("buffer too small!");
  8003ed:	83 ec 04             	sub    $0x4,%esp
  8003f0:	68 e1 2f 80 00       	push   $0x802fe1
  8003f5:	68 83 00 00 00       	push   $0x83
  8003fa:	68 cf 2f 80 00       	push   $0x802fcf
  8003ff:	e8 19 05 00 00       	call   80091d <_panic>
  		die("fstat panic");
  800404:	b8 10 30 80 00       	mov    $0x803010,%eax
  800409:	e8 25 fc ff ff       	call   800033 <die>
  80040e:	e9 4c ff ff ff       	jmp    80035f <handle_client+0x29f>
    	die("fd's file size > 1518");
  800413:	b8 1c 30 80 00       	mov    $0x80301c,%eax
  800418:	e8 16 fc ff ff       	call   800033 <die>
  80041d:	e9 4d ff ff ff       	jmp    80036f <handle_client+0x2af>
    	die("just read partitial data");
  800422:	b8 32 30 80 00       	mov    $0x803032,%eax
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
  80044c:	c7 05 20 40 80 00 74 	movl   $0x803074,0x804020
  800453:	30 80 00 

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  800456:	6a 06                	push   $0x6
  800458:	6a 01                	push   $0x1
  80045a:	6a 02                	push   $0x2
  80045c:	e8 ef 1d 00 00       	call   802250 <socket>
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
  8004a4:	e8 15 1d 00 00       	call   8021be <bind>
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
  8004b6:	e8 72 1d 00 00       	call   80222d <listen>
  8004bb:	83 c4 10             	add    $0x10,%esp
  8004be:	85 c0                	test   %eax,%eax
  8004c0:	78 2d                	js     8004ef <umain+0xac>
		die("Failed to listen on server socket");

	cprintf("Waiting for http connections...\n");
  8004c2:	83 ec 0c             	sub    $0xc,%esp
  8004c5:	68 90 31 80 00       	push   $0x803190
  8004ca:	e8 44 05 00 00       	call   800a13 <cprintf>
  8004cf:	83 c4 10             	add    $0x10,%esp

	while (1) {
		unsigned int clientlen = sizeof(client);
		// Wait for client connection
		if ((clientsock = accept(serversock,
  8004d2:	8d 7d c4             	lea    -0x3c(%ebp),%edi
  8004d5:	eb 35                	jmp    80050c <umain+0xc9>
		die("Failed to create socket");
  8004d7:	b8 7b 30 80 00       	mov    $0x80307b,%eax
  8004dc:	e8 52 fb ff ff       	call   800033 <die>
  8004e1:	eb 87                	jmp    80046a <umain+0x27>
		die("Failed to bind the server socket");
  8004e3:	b8 48 31 80 00       	mov    $0x803148,%eax
  8004e8:	e8 46 fb ff ff       	call   800033 <die>
  8004ed:	eb c1                	jmp    8004b0 <umain+0x6d>
		die("Failed to listen on server socket");
  8004ef:	b8 6c 31 80 00       	mov    $0x80316c,%eax
  8004f4:	e8 3a fb ff ff       	call   800033 <die>
  8004f9:	eb c7                	jmp    8004c2 <umain+0x7f>
					 (struct sockaddr *) &client,
					 &clientlen)) < 0)
		{
			die("Failed to accept client connection");
  8004fb:	b8 b4 31 80 00       	mov    $0x8031b4,%eax
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
  80051c:	e8 6e 1c 00 00       	call   80218f <accept>
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
  800893:	68 fe 31 80 00       	push   $0x8031fe
  800898:	e8 76 01 00 00       	call   800a13 <cprintf>
	cprintf("before umain\n");
  80089d:	c7 04 24 1c 32 80 00 	movl   $0x80321c,(%esp)
  8008a4:	e8 6a 01 00 00       	call   800a13 <cprintf>
	// call user main routine
	umain(argc, argv);
  8008a9:	83 c4 08             	add    $0x8,%esp
  8008ac:	ff 75 0c             	pushl  0xc(%ebp)
  8008af:	ff 75 08             	pushl  0x8(%ebp)
  8008b2:	e8 8c fb ff ff       	call   800443 <umain>
	cprintf("after umain\n");
  8008b7:	c7 04 24 2a 32 80 00 	movl   $0x80322a,(%esp)
  8008be:	e8 50 01 00 00       	call   800a13 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8008c3:	a1 1c 50 80 00       	mov    0x80501c,%eax
  8008c8:	8b 40 48             	mov    0x48(%eax),%eax
  8008cb:	83 c4 08             	add    $0x8,%esp
  8008ce:	50                   	push   %eax
  8008cf:	68 37 32 80 00       	push   $0x803237
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
  8008f7:	68 64 32 80 00       	push   $0x803264
  8008fc:	50                   	push   %eax
  8008fd:	68 56 32 80 00       	push   $0x803256
  800902:	e8 0c 01 00 00       	call   800a13 <cprintf>
	close_all();
  800907:	e8 05 11 00 00       	call   801a11 <close_all>
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
  80092d:	68 90 32 80 00       	push   $0x803290
  800932:	50                   	push   %eax
  800933:	68 56 32 80 00       	push   $0x803256
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
  800956:	68 6c 32 80 00       	push   $0x80326c
  80095b:	e8 b3 00 00 00       	call   800a13 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800960:	83 c4 18             	add    $0x18,%esp
  800963:	53                   	push   %ebx
  800964:	ff 75 10             	pushl  0x10(%ebp)
  800967:	e8 56 00 00 00       	call   8009c2 <vcprintf>
	cprintf("\n");
  80096c:	c7 04 24 72 30 80 00 	movl   $0x803072,(%esp)
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
  800ac0:	e8 9b 22 00 00       	call   802d60 <__udivdi3>
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
  800ae9:	e8 82 23 00 00       	call   802e70 <__umoddi3>
  800aee:	83 c4 14             	add    $0x14,%esp
  800af1:	0f be 80 97 32 80 00 	movsbl 0x803297(%eax),%eax
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
  800b9a:	ff 24 85 80 34 80 00 	jmp    *0x803480(,%eax,4)
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
  800c65:	8b 14 85 e0 35 80 00 	mov    0x8035e0(,%eax,4),%edx
  800c6c:	85 d2                	test   %edx,%edx
  800c6e:	74 18                	je     800c88 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800c70:	52                   	push   %edx
  800c71:	68 fd 36 80 00       	push   $0x8036fd
  800c76:	53                   	push   %ebx
  800c77:	56                   	push   %esi
  800c78:	e8 a6 fe ff ff       	call   800b23 <printfmt>
  800c7d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800c80:	89 7d 14             	mov    %edi,0x14(%ebp)
  800c83:	e9 fe 02 00 00       	jmp    800f86 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800c88:	50                   	push   %eax
  800c89:	68 af 32 80 00       	push   $0x8032af
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
  800cb0:	b8 a8 32 80 00       	mov    $0x8032a8,%eax
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
  801048:	bf cd 33 80 00       	mov    $0x8033cd,%edi
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
  801074:	bf 05 34 80 00       	mov    $0x803405,%edi
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
  801515:	68 28 36 80 00       	push   $0x803628
  80151a:	6a 43                	push   $0x43
  80151c:	68 45 36 80 00       	push   $0x803645
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
  801596:	68 28 36 80 00       	push   $0x803628
  80159b:	6a 43                	push   $0x43
  80159d:	68 45 36 80 00       	push   $0x803645
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
  8015d8:	68 28 36 80 00       	push   $0x803628
  8015dd:	6a 43                	push   $0x43
  8015df:	68 45 36 80 00       	push   $0x803645
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
  80161a:	68 28 36 80 00       	push   $0x803628
  80161f:	6a 43                	push   $0x43
  801621:	68 45 36 80 00       	push   $0x803645
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
  80165c:	68 28 36 80 00       	push   $0x803628
  801661:	6a 43                	push   $0x43
  801663:	68 45 36 80 00       	push   $0x803645
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
  80169e:	68 28 36 80 00       	push   $0x803628
  8016a3:	6a 43                	push   $0x43
  8016a5:	68 45 36 80 00       	push   $0x803645
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
  8016e0:	68 28 36 80 00       	push   $0x803628
  8016e5:	6a 43                	push   $0x43
  8016e7:	68 45 36 80 00       	push   $0x803645
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
  801744:	68 28 36 80 00       	push   $0x803628
  801749:	6a 43                	push   $0x43
  80174b:	68 45 36 80 00       	push   $0x803645
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
  801828:	68 28 36 80 00       	push   $0x803628
  80182d:	6a 43                	push   $0x43
  80182f:	68 45 36 80 00       	push   $0x803645
  801834:	e8 e4 f0 ff ff       	call   80091d <_panic>

00801839 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80183c:	8b 45 08             	mov    0x8(%ebp),%eax
  80183f:	05 00 00 00 30       	add    $0x30000000,%eax
  801844:	c1 e8 0c             	shr    $0xc,%eax
}
  801847:	5d                   	pop    %ebp
  801848:	c3                   	ret    

00801849 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80184c:	8b 45 08             	mov    0x8(%ebp),%eax
  80184f:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801854:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801859:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80185e:	5d                   	pop    %ebp
  80185f:	c3                   	ret    

00801860 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
  801863:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801868:	89 c2                	mov    %eax,%edx
  80186a:	c1 ea 16             	shr    $0x16,%edx
  80186d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801874:	f6 c2 01             	test   $0x1,%dl
  801877:	74 2d                	je     8018a6 <fd_alloc+0x46>
  801879:	89 c2                	mov    %eax,%edx
  80187b:	c1 ea 0c             	shr    $0xc,%edx
  80187e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801885:	f6 c2 01             	test   $0x1,%dl
  801888:	74 1c                	je     8018a6 <fd_alloc+0x46>
  80188a:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80188f:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801894:	75 d2                	jne    801868 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801896:	8b 45 08             	mov    0x8(%ebp),%eax
  801899:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80189f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8018a4:	eb 0a                	jmp    8018b0 <fd_alloc+0x50>
			*fd_store = fd;
  8018a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018a9:	89 01                	mov    %eax,(%ecx)
			return 0;
  8018ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018b0:	5d                   	pop    %ebp
  8018b1:	c3                   	ret    

008018b2 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
  8018b5:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8018b8:	83 f8 1f             	cmp    $0x1f,%eax
  8018bb:	77 30                	ja     8018ed <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8018bd:	c1 e0 0c             	shl    $0xc,%eax
  8018c0:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8018c5:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8018cb:	f6 c2 01             	test   $0x1,%dl
  8018ce:	74 24                	je     8018f4 <fd_lookup+0x42>
  8018d0:	89 c2                	mov    %eax,%edx
  8018d2:	c1 ea 0c             	shr    $0xc,%edx
  8018d5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018dc:	f6 c2 01             	test   $0x1,%dl
  8018df:	74 1a                	je     8018fb <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8018e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e4:	89 02                	mov    %eax,(%edx)
	return 0;
  8018e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018eb:	5d                   	pop    %ebp
  8018ec:	c3                   	ret    
		return -E_INVAL;
  8018ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018f2:	eb f7                	jmp    8018eb <fd_lookup+0x39>
		return -E_INVAL;
  8018f4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018f9:	eb f0                	jmp    8018eb <fd_lookup+0x39>
  8018fb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801900:	eb e9                	jmp    8018eb <fd_lookup+0x39>

00801902 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
  801905:	83 ec 08             	sub    $0x8,%esp
  801908:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80190b:	ba 00 00 00 00       	mov    $0x0,%edx
  801910:	b8 24 40 80 00       	mov    $0x804024,%eax
		if (devtab[i]->dev_id == dev_id) {
  801915:	39 08                	cmp    %ecx,(%eax)
  801917:	74 38                	je     801951 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801919:	83 c2 01             	add    $0x1,%edx
  80191c:	8b 04 95 d0 36 80 00 	mov    0x8036d0(,%edx,4),%eax
  801923:	85 c0                	test   %eax,%eax
  801925:	75 ee                	jne    801915 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801927:	a1 1c 50 80 00       	mov    0x80501c,%eax
  80192c:	8b 40 48             	mov    0x48(%eax),%eax
  80192f:	83 ec 04             	sub    $0x4,%esp
  801932:	51                   	push   %ecx
  801933:	50                   	push   %eax
  801934:	68 54 36 80 00       	push   $0x803654
  801939:	e8 d5 f0 ff ff       	call   800a13 <cprintf>
	*dev = 0;
  80193e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801941:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801947:	83 c4 10             	add    $0x10,%esp
  80194a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80194f:	c9                   	leave  
  801950:	c3                   	ret    
			*dev = devtab[i];
  801951:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801954:	89 01                	mov    %eax,(%ecx)
			return 0;
  801956:	b8 00 00 00 00       	mov    $0x0,%eax
  80195b:	eb f2                	jmp    80194f <dev_lookup+0x4d>

0080195d <fd_close>:
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
  801960:	57                   	push   %edi
  801961:	56                   	push   %esi
  801962:	53                   	push   %ebx
  801963:	83 ec 24             	sub    $0x24,%esp
  801966:	8b 75 08             	mov    0x8(%ebp),%esi
  801969:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80196c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80196f:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801970:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801976:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801979:	50                   	push   %eax
  80197a:	e8 33 ff ff ff       	call   8018b2 <fd_lookup>
  80197f:	89 c3                	mov    %eax,%ebx
  801981:	83 c4 10             	add    $0x10,%esp
  801984:	85 c0                	test   %eax,%eax
  801986:	78 05                	js     80198d <fd_close+0x30>
	    || fd != fd2)
  801988:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80198b:	74 16                	je     8019a3 <fd_close+0x46>
		return (must_exist ? r : 0);
  80198d:	89 f8                	mov    %edi,%eax
  80198f:	84 c0                	test   %al,%al
  801991:	b8 00 00 00 00       	mov    $0x0,%eax
  801996:	0f 44 d8             	cmove  %eax,%ebx
}
  801999:	89 d8                	mov    %ebx,%eax
  80199b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80199e:	5b                   	pop    %ebx
  80199f:	5e                   	pop    %esi
  8019a0:	5f                   	pop    %edi
  8019a1:	5d                   	pop    %ebp
  8019a2:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8019a3:	83 ec 08             	sub    $0x8,%esp
  8019a6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8019a9:	50                   	push   %eax
  8019aa:	ff 36                	pushl  (%esi)
  8019ac:	e8 51 ff ff ff       	call   801902 <dev_lookup>
  8019b1:	89 c3                	mov    %eax,%ebx
  8019b3:	83 c4 10             	add    $0x10,%esp
  8019b6:	85 c0                	test   %eax,%eax
  8019b8:	78 1a                	js     8019d4 <fd_close+0x77>
		if (dev->dev_close)
  8019ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019bd:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8019c0:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8019c5:	85 c0                	test   %eax,%eax
  8019c7:	74 0b                	je     8019d4 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8019c9:	83 ec 0c             	sub    $0xc,%esp
  8019cc:	56                   	push   %esi
  8019cd:	ff d0                	call   *%eax
  8019cf:	89 c3                	mov    %eax,%ebx
  8019d1:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8019d4:	83 ec 08             	sub    $0x8,%esp
  8019d7:	56                   	push   %esi
  8019d8:	6a 00                	push   $0x0
  8019da:	e8 0a fc ff ff       	call   8015e9 <sys_page_unmap>
	return r;
  8019df:	83 c4 10             	add    $0x10,%esp
  8019e2:	eb b5                	jmp    801999 <fd_close+0x3c>

008019e4 <close>:

int
close(int fdnum)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
  8019e7:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019ed:	50                   	push   %eax
  8019ee:	ff 75 08             	pushl  0x8(%ebp)
  8019f1:	e8 bc fe ff ff       	call   8018b2 <fd_lookup>
  8019f6:	83 c4 10             	add    $0x10,%esp
  8019f9:	85 c0                	test   %eax,%eax
  8019fb:	79 02                	jns    8019ff <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    
		return fd_close(fd, 1);
  8019ff:	83 ec 08             	sub    $0x8,%esp
  801a02:	6a 01                	push   $0x1
  801a04:	ff 75 f4             	pushl  -0xc(%ebp)
  801a07:	e8 51 ff ff ff       	call   80195d <fd_close>
  801a0c:	83 c4 10             	add    $0x10,%esp
  801a0f:	eb ec                	jmp    8019fd <close+0x19>

00801a11 <close_all>:

void
close_all(void)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
  801a14:	53                   	push   %ebx
  801a15:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801a18:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801a1d:	83 ec 0c             	sub    $0xc,%esp
  801a20:	53                   	push   %ebx
  801a21:	e8 be ff ff ff       	call   8019e4 <close>
	for (i = 0; i < MAXFD; i++)
  801a26:	83 c3 01             	add    $0x1,%ebx
  801a29:	83 c4 10             	add    $0x10,%esp
  801a2c:	83 fb 20             	cmp    $0x20,%ebx
  801a2f:	75 ec                	jne    801a1d <close_all+0xc>
}
  801a31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a34:	c9                   	leave  
  801a35:	c3                   	ret    

00801a36 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
  801a39:	57                   	push   %edi
  801a3a:	56                   	push   %esi
  801a3b:	53                   	push   %ebx
  801a3c:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801a3f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801a42:	50                   	push   %eax
  801a43:	ff 75 08             	pushl  0x8(%ebp)
  801a46:	e8 67 fe ff ff       	call   8018b2 <fd_lookup>
  801a4b:	89 c3                	mov    %eax,%ebx
  801a4d:	83 c4 10             	add    $0x10,%esp
  801a50:	85 c0                	test   %eax,%eax
  801a52:	0f 88 81 00 00 00    	js     801ad9 <dup+0xa3>
		return r;
	close(newfdnum);
  801a58:	83 ec 0c             	sub    $0xc,%esp
  801a5b:	ff 75 0c             	pushl  0xc(%ebp)
  801a5e:	e8 81 ff ff ff       	call   8019e4 <close>

	newfd = INDEX2FD(newfdnum);
  801a63:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a66:	c1 e6 0c             	shl    $0xc,%esi
  801a69:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801a6f:	83 c4 04             	add    $0x4,%esp
  801a72:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a75:	e8 cf fd ff ff       	call   801849 <fd2data>
  801a7a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801a7c:	89 34 24             	mov    %esi,(%esp)
  801a7f:	e8 c5 fd ff ff       	call   801849 <fd2data>
  801a84:	83 c4 10             	add    $0x10,%esp
  801a87:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801a89:	89 d8                	mov    %ebx,%eax
  801a8b:	c1 e8 16             	shr    $0x16,%eax
  801a8e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a95:	a8 01                	test   $0x1,%al
  801a97:	74 11                	je     801aaa <dup+0x74>
  801a99:	89 d8                	mov    %ebx,%eax
  801a9b:	c1 e8 0c             	shr    $0xc,%eax
  801a9e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801aa5:	f6 c2 01             	test   $0x1,%dl
  801aa8:	75 39                	jne    801ae3 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801aaa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801aad:	89 d0                	mov    %edx,%eax
  801aaf:	c1 e8 0c             	shr    $0xc,%eax
  801ab2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801ab9:	83 ec 0c             	sub    $0xc,%esp
  801abc:	25 07 0e 00 00       	and    $0xe07,%eax
  801ac1:	50                   	push   %eax
  801ac2:	56                   	push   %esi
  801ac3:	6a 00                	push   $0x0
  801ac5:	52                   	push   %edx
  801ac6:	6a 00                	push   $0x0
  801ac8:	e8 da fa ff ff       	call   8015a7 <sys_page_map>
  801acd:	89 c3                	mov    %eax,%ebx
  801acf:	83 c4 20             	add    $0x20,%esp
  801ad2:	85 c0                	test   %eax,%eax
  801ad4:	78 31                	js     801b07 <dup+0xd1>
		goto err;

	return newfdnum;
  801ad6:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801ad9:	89 d8                	mov    %ebx,%eax
  801adb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ade:	5b                   	pop    %ebx
  801adf:	5e                   	pop    %esi
  801ae0:	5f                   	pop    %edi
  801ae1:	5d                   	pop    %ebp
  801ae2:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801ae3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801aea:	83 ec 0c             	sub    $0xc,%esp
  801aed:	25 07 0e 00 00       	and    $0xe07,%eax
  801af2:	50                   	push   %eax
  801af3:	57                   	push   %edi
  801af4:	6a 00                	push   $0x0
  801af6:	53                   	push   %ebx
  801af7:	6a 00                	push   $0x0
  801af9:	e8 a9 fa ff ff       	call   8015a7 <sys_page_map>
  801afe:	89 c3                	mov    %eax,%ebx
  801b00:	83 c4 20             	add    $0x20,%esp
  801b03:	85 c0                	test   %eax,%eax
  801b05:	79 a3                	jns    801aaa <dup+0x74>
	sys_page_unmap(0, newfd);
  801b07:	83 ec 08             	sub    $0x8,%esp
  801b0a:	56                   	push   %esi
  801b0b:	6a 00                	push   $0x0
  801b0d:	e8 d7 fa ff ff       	call   8015e9 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801b12:	83 c4 08             	add    $0x8,%esp
  801b15:	57                   	push   %edi
  801b16:	6a 00                	push   $0x0
  801b18:	e8 cc fa ff ff       	call   8015e9 <sys_page_unmap>
	return r;
  801b1d:	83 c4 10             	add    $0x10,%esp
  801b20:	eb b7                	jmp    801ad9 <dup+0xa3>

00801b22 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
  801b25:	53                   	push   %ebx
  801b26:	83 ec 1c             	sub    $0x1c,%esp
  801b29:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b2c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b2f:	50                   	push   %eax
  801b30:	53                   	push   %ebx
  801b31:	e8 7c fd ff ff       	call   8018b2 <fd_lookup>
  801b36:	83 c4 10             	add    $0x10,%esp
  801b39:	85 c0                	test   %eax,%eax
  801b3b:	78 3f                	js     801b7c <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b3d:	83 ec 08             	sub    $0x8,%esp
  801b40:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b43:	50                   	push   %eax
  801b44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b47:	ff 30                	pushl  (%eax)
  801b49:	e8 b4 fd ff ff       	call   801902 <dev_lookup>
  801b4e:	83 c4 10             	add    $0x10,%esp
  801b51:	85 c0                	test   %eax,%eax
  801b53:	78 27                	js     801b7c <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b55:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b58:	8b 42 08             	mov    0x8(%edx),%eax
  801b5b:	83 e0 03             	and    $0x3,%eax
  801b5e:	83 f8 01             	cmp    $0x1,%eax
  801b61:	74 1e                	je     801b81 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b66:	8b 40 08             	mov    0x8(%eax),%eax
  801b69:	85 c0                	test   %eax,%eax
  801b6b:	74 35                	je     801ba2 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801b6d:	83 ec 04             	sub    $0x4,%esp
  801b70:	ff 75 10             	pushl  0x10(%ebp)
  801b73:	ff 75 0c             	pushl  0xc(%ebp)
  801b76:	52                   	push   %edx
  801b77:	ff d0                	call   *%eax
  801b79:	83 c4 10             	add    $0x10,%esp
}
  801b7c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801b81:	a1 1c 50 80 00       	mov    0x80501c,%eax
  801b86:	8b 40 48             	mov    0x48(%eax),%eax
  801b89:	83 ec 04             	sub    $0x4,%esp
  801b8c:	53                   	push   %ebx
  801b8d:	50                   	push   %eax
  801b8e:	68 95 36 80 00       	push   $0x803695
  801b93:	e8 7b ee ff ff       	call   800a13 <cprintf>
		return -E_INVAL;
  801b98:	83 c4 10             	add    $0x10,%esp
  801b9b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ba0:	eb da                	jmp    801b7c <read+0x5a>
		return -E_NOT_SUPP;
  801ba2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ba7:	eb d3                	jmp    801b7c <read+0x5a>

00801ba9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
  801bac:	57                   	push   %edi
  801bad:	56                   	push   %esi
  801bae:	53                   	push   %ebx
  801baf:	83 ec 0c             	sub    $0xc,%esp
  801bb2:	8b 7d 08             	mov    0x8(%ebp),%edi
  801bb5:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801bb8:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bbd:	39 f3                	cmp    %esi,%ebx
  801bbf:	73 23                	jae    801be4 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801bc1:	83 ec 04             	sub    $0x4,%esp
  801bc4:	89 f0                	mov    %esi,%eax
  801bc6:	29 d8                	sub    %ebx,%eax
  801bc8:	50                   	push   %eax
  801bc9:	89 d8                	mov    %ebx,%eax
  801bcb:	03 45 0c             	add    0xc(%ebp),%eax
  801bce:	50                   	push   %eax
  801bcf:	57                   	push   %edi
  801bd0:	e8 4d ff ff ff       	call   801b22 <read>
		if (m < 0)
  801bd5:	83 c4 10             	add    $0x10,%esp
  801bd8:	85 c0                	test   %eax,%eax
  801bda:	78 06                	js     801be2 <readn+0x39>
			return m;
		if (m == 0)
  801bdc:	74 06                	je     801be4 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801bde:	01 c3                	add    %eax,%ebx
  801be0:	eb db                	jmp    801bbd <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801be2:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801be4:	89 d8                	mov    %ebx,%eax
  801be6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801be9:	5b                   	pop    %ebx
  801bea:	5e                   	pop    %esi
  801beb:	5f                   	pop    %edi
  801bec:	5d                   	pop    %ebp
  801bed:	c3                   	ret    

00801bee <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
  801bf1:	53                   	push   %ebx
  801bf2:	83 ec 1c             	sub    $0x1c,%esp
  801bf5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bf8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bfb:	50                   	push   %eax
  801bfc:	53                   	push   %ebx
  801bfd:	e8 b0 fc ff ff       	call   8018b2 <fd_lookup>
  801c02:	83 c4 10             	add    $0x10,%esp
  801c05:	85 c0                	test   %eax,%eax
  801c07:	78 3a                	js     801c43 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c09:	83 ec 08             	sub    $0x8,%esp
  801c0c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c0f:	50                   	push   %eax
  801c10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c13:	ff 30                	pushl  (%eax)
  801c15:	e8 e8 fc ff ff       	call   801902 <dev_lookup>
  801c1a:	83 c4 10             	add    $0x10,%esp
  801c1d:	85 c0                	test   %eax,%eax
  801c1f:	78 22                	js     801c43 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c24:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c28:	74 1e                	je     801c48 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801c2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c2d:	8b 52 0c             	mov    0xc(%edx),%edx
  801c30:	85 d2                	test   %edx,%edx
  801c32:	74 35                	je     801c69 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801c34:	83 ec 04             	sub    $0x4,%esp
  801c37:	ff 75 10             	pushl  0x10(%ebp)
  801c3a:	ff 75 0c             	pushl  0xc(%ebp)
  801c3d:	50                   	push   %eax
  801c3e:	ff d2                	call   *%edx
  801c40:	83 c4 10             	add    $0x10,%esp
}
  801c43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c46:	c9                   	leave  
  801c47:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801c48:	a1 1c 50 80 00       	mov    0x80501c,%eax
  801c4d:	8b 40 48             	mov    0x48(%eax),%eax
  801c50:	83 ec 04             	sub    $0x4,%esp
  801c53:	53                   	push   %ebx
  801c54:	50                   	push   %eax
  801c55:	68 b1 36 80 00       	push   $0x8036b1
  801c5a:	e8 b4 ed ff ff       	call   800a13 <cprintf>
		return -E_INVAL;
  801c5f:	83 c4 10             	add    $0x10,%esp
  801c62:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c67:	eb da                	jmp    801c43 <write+0x55>
		return -E_NOT_SUPP;
  801c69:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c6e:	eb d3                	jmp    801c43 <write+0x55>

00801c70 <seek>:

int
seek(int fdnum, off_t offset)
{
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
  801c73:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c76:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c79:	50                   	push   %eax
  801c7a:	ff 75 08             	pushl  0x8(%ebp)
  801c7d:	e8 30 fc ff ff       	call   8018b2 <fd_lookup>
  801c82:	83 c4 10             	add    $0x10,%esp
  801c85:	85 c0                	test   %eax,%eax
  801c87:	78 0e                	js     801c97 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801c89:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c8f:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801c92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
  801c9c:	53                   	push   %ebx
  801c9d:	83 ec 1c             	sub    $0x1c,%esp
  801ca0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ca3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ca6:	50                   	push   %eax
  801ca7:	53                   	push   %ebx
  801ca8:	e8 05 fc ff ff       	call   8018b2 <fd_lookup>
  801cad:	83 c4 10             	add    $0x10,%esp
  801cb0:	85 c0                	test   %eax,%eax
  801cb2:	78 37                	js     801ceb <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801cb4:	83 ec 08             	sub    $0x8,%esp
  801cb7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cba:	50                   	push   %eax
  801cbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cbe:	ff 30                	pushl  (%eax)
  801cc0:	e8 3d fc ff ff       	call   801902 <dev_lookup>
  801cc5:	83 c4 10             	add    $0x10,%esp
  801cc8:	85 c0                	test   %eax,%eax
  801cca:	78 1f                	js     801ceb <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ccc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ccf:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801cd3:	74 1b                	je     801cf0 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801cd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cd8:	8b 52 18             	mov    0x18(%edx),%edx
  801cdb:	85 d2                	test   %edx,%edx
  801cdd:	74 32                	je     801d11 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801cdf:	83 ec 08             	sub    $0x8,%esp
  801ce2:	ff 75 0c             	pushl  0xc(%ebp)
  801ce5:	50                   	push   %eax
  801ce6:	ff d2                	call   *%edx
  801ce8:	83 c4 10             	add    $0x10,%esp
}
  801ceb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cee:	c9                   	leave  
  801cef:	c3                   	ret    
			thisenv->env_id, fdnum);
  801cf0:	a1 1c 50 80 00       	mov    0x80501c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801cf5:	8b 40 48             	mov    0x48(%eax),%eax
  801cf8:	83 ec 04             	sub    $0x4,%esp
  801cfb:	53                   	push   %ebx
  801cfc:	50                   	push   %eax
  801cfd:	68 74 36 80 00       	push   $0x803674
  801d02:	e8 0c ed ff ff       	call   800a13 <cprintf>
		return -E_INVAL;
  801d07:	83 c4 10             	add    $0x10,%esp
  801d0a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d0f:	eb da                	jmp    801ceb <ftruncate+0x52>
		return -E_NOT_SUPP;
  801d11:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d16:	eb d3                	jmp    801ceb <ftruncate+0x52>

00801d18 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
  801d1b:	53                   	push   %ebx
  801d1c:	83 ec 1c             	sub    $0x1c,%esp
  801d1f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d22:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d25:	50                   	push   %eax
  801d26:	ff 75 08             	pushl  0x8(%ebp)
  801d29:	e8 84 fb ff ff       	call   8018b2 <fd_lookup>
  801d2e:	83 c4 10             	add    $0x10,%esp
  801d31:	85 c0                	test   %eax,%eax
  801d33:	78 4b                	js     801d80 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d35:	83 ec 08             	sub    $0x8,%esp
  801d38:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d3b:	50                   	push   %eax
  801d3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d3f:	ff 30                	pushl  (%eax)
  801d41:	e8 bc fb ff ff       	call   801902 <dev_lookup>
  801d46:	83 c4 10             	add    $0x10,%esp
  801d49:	85 c0                	test   %eax,%eax
  801d4b:	78 33                	js     801d80 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d50:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801d54:	74 2f                	je     801d85 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801d56:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801d59:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801d60:	00 00 00 
	stat->st_isdir = 0;
  801d63:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d6a:	00 00 00 
	stat->st_dev = dev;
  801d6d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801d73:	83 ec 08             	sub    $0x8,%esp
  801d76:	53                   	push   %ebx
  801d77:	ff 75 f0             	pushl  -0x10(%ebp)
  801d7a:	ff 50 14             	call   *0x14(%eax)
  801d7d:	83 c4 10             	add    $0x10,%esp
}
  801d80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    
		return -E_NOT_SUPP;
  801d85:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d8a:	eb f4                	jmp    801d80 <fstat+0x68>

00801d8c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
  801d8f:	56                   	push   %esi
  801d90:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801d91:	83 ec 08             	sub    $0x8,%esp
  801d94:	6a 00                	push   $0x0
  801d96:	ff 75 08             	pushl  0x8(%ebp)
  801d99:	e8 22 02 00 00       	call   801fc0 <open>
  801d9e:	89 c3                	mov    %eax,%ebx
  801da0:	83 c4 10             	add    $0x10,%esp
  801da3:	85 c0                	test   %eax,%eax
  801da5:	78 1b                	js     801dc2 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801da7:	83 ec 08             	sub    $0x8,%esp
  801daa:	ff 75 0c             	pushl  0xc(%ebp)
  801dad:	50                   	push   %eax
  801dae:	e8 65 ff ff ff       	call   801d18 <fstat>
  801db3:	89 c6                	mov    %eax,%esi
	close(fd);
  801db5:	89 1c 24             	mov    %ebx,(%esp)
  801db8:	e8 27 fc ff ff       	call   8019e4 <close>
	return r;
  801dbd:	83 c4 10             	add    $0x10,%esp
  801dc0:	89 f3                	mov    %esi,%ebx
}
  801dc2:	89 d8                	mov    %ebx,%eax
  801dc4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dc7:	5b                   	pop    %ebx
  801dc8:	5e                   	pop    %esi
  801dc9:	5d                   	pop    %ebp
  801dca:	c3                   	ret    

00801dcb <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
  801dce:	56                   	push   %esi
  801dcf:	53                   	push   %ebx
  801dd0:	89 c6                	mov    %eax,%esi
  801dd2:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801dd4:	83 3d 10 50 80 00 00 	cmpl   $0x0,0x805010
  801ddb:	74 27                	je     801e04 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ddd:	6a 07                	push   $0x7
  801ddf:	68 00 60 80 00       	push   $0x806000
  801de4:	56                   	push   %esi
  801de5:	ff 35 10 50 80 00    	pushl  0x805010
  801deb:	e8 a1 0e 00 00       	call   802c91 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801df0:	83 c4 0c             	add    $0xc,%esp
  801df3:	6a 00                	push   $0x0
  801df5:	53                   	push   %ebx
  801df6:	6a 00                	push   $0x0
  801df8:	e8 2b 0e 00 00       	call   802c28 <ipc_recv>
}
  801dfd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e00:	5b                   	pop    %ebx
  801e01:	5e                   	pop    %esi
  801e02:	5d                   	pop    %ebp
  801e03:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801e04:	83 ec 0c             	sub    $0xc,%esp
  801e07:	6a 01                	push   $0x1
  801e09:	e8 db 0e 00 00       	call   802ce9 <ipc_find_env>
  801e0e:	a3 10 50 80 00       	mov    %eax,0x805010
  801e13:	83 c4 10             	add    $0x10,%esp
  801e16:	eb c5                	jmp    801ddd <fsipc+0x12>

00801e18 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
  801e1b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e21:	8b 40 0c             	mov    0xc(%eax),%eax
  801e24:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801e29:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e2c:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801e31:	ba 00 00 00 00       	mov    $0x0,%edx
  801e36:	b8 02 00 00 00       	mov    $0x2,%eax
  801e3b:	e8 8b ff ff ff       	call   801dcb <fsipc>
}
  801e40:	c9                   	leave  
  801e41:	c3                   	ret    

00801e42 <devfile_flush>:
{
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
  801e45:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e48:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4b:	8b 40 0c             	mov    0xc(%eax),%eax
  801e4e:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801e53:	ba 00 00 00 00       	mov    $0x0,%edx
  801e58:	b8 06 00 00 00       	mov    $0x6,%eax
  801e5d:	e8 69 ff ff ff       	call   801dcb <fsipc>
}
  801e62:	c9                   	leave  
  801e63:	c3                   	ret    

00801e64 <devfile_stat>:
{
  801e64:	55                   	push   %ebp
  801e65:	89 e5                	mov    %esp,%ebp
  801e67:	53                   	push   %ebx
  801e68:	83 ec 04             	sub    $0x4,%esp
  801e6b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e71:	8b 40 0c             	mov    0xc(%eax),%eax
  801e74:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801e79:	ba 00 00 00 00       	mov    $0x0,%edx
  801e7e:	b8 05 00 00 00       	mov    $0x5,%eax
  801e83:	e8 43 ff ff ff       	call   801dcb <fsipc>
  801e88:	85 c0                	test   %eax,%eax
  801e8a:	78 2c                	js     801eb8 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801e8c:	83 ec 08             	sub    $0x8,%esp
  801e8f:	68 00 60 80 00       	push   $0x806000
  801e94:	53                   	push   %ebx
  801e95:	e8 d8 f2 ff ff       	call   801172 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801e9a:	a1 80 60 80 00       	mov    0x806080,%eax
  801e9f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801ea5:	a1 84 60 80 00       	mov    0x806084,%eax
  801eaa:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801eb0:	83 c4 10             	add    $0x10,%esp
  801eb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ebb:	c9                   	leave  
  801ebc:	c3                   	ret    

00801ebd <devfile_write>:
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
  801ec0:	53                   	push   %ebx
  801ec1:	83 ec 08             	sub    $0x8,%esp
  801ec4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eca:	8b 40 0c             	mov    0xc(%eax),%eax
  801ecd:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801ed2:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801ed8:	53                   	push   %ebx
  801ed9:	ff 75 0c             	pushl  0xc(%ebp)
  801edc:	68 08 60 80 00       	push   $0x806008
  801ee1:	e8 7c f4 ff ff       	call   801362 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801ee6:	ba 00 00 00 00       	mov    $0x0,%edx
  801eeb:	b8 04 00 00 00       	mov    $0x4,%eax
  801ef0:	e8 d6 fe ff ff       	call   801dcb <fsipc>
  801ef5:	83 c4 10             	add    $0x10,%esp
  801ef8:	85 c0                	test   %eax,%eax
  801efa:	78 0b                	js     801f07 <devfile_write+0x4a>
	assert(r <= n);
  801efc:	39 d8                	cmp    %ebx,%eax
  801efe:	77 0c                	ja     801f0c <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801f00:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f05:	7f 1e                	jg     801f25 <devfile_write+0x68>
}
  801f07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f0a:	c9                   	leave  
  801f0b:	c3                   	ret    
	assert(r <= n);
  801f0c:	68 e4 36 80 00       	push   $0x8036e4
  801f11:	68 eb 36 80 00       	push   $0x8036eb
  801f16:	68 98 00 00 00       	push   $0x98
  801f1b:	68 00 37 80 00       	push   $0x803700
  801f20:	e8 f8 e9 ff ff       	call   80091d <_panic>
	assert(r <= PGSIZE);
  801f25:	68 0b 37 80 00       	push   $0x80370b
  801f2a:	68 eb 36 80 00       	push   $0x8036eb
  801f2f:	68 99 00 00 00       	push   $0x99
  801f34:	68 00 37 80 00       	push   $0x803700
  801f39:	e8 df e9 ff ff       	call   80091d <_panic>

00801f3e <devfile_read>:
{
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
  801f41:	56                   	push   %esi
  801f42:	53                   	push   %ebx
  801f43:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801f46:	8b 45 08             	mov    0x8(%ebp),%eax
  801f49:	8b 40 0c             	mov    0xc(%eax),%eax
  801f4c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801f51:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801f57:	ba 00 00 00 00       	mov    $0x0,%edx
  801f5c:	b8 03 00 00 00       	mov    $0x3,%eax
  801f61:	e8 65 fe ff ff       	call   801dcb <fsipc>
  801f66:	89 c3                	mov    %eax,%ebx
  801f68:	85 c0                	test   %eax,%eax
  801f6a:	78 1f                	js     801f8b <devfile_read+0x4d>
	assert(r <= n);
  801f6c:	39 f0                	cmp    %esi,%eax
  801f6e:	77 24                	ja     801f94 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801f70:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f75:	7f 33                	jg     801faa <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801f77:	83 ec 04             	sub    $0x4,%esp
  801f7a:	50                   	push   %eax
  801f7b:	68 00 60 80 00       	push   $0x806000
  801f80:	ff 75 0c             	pushl  0xc(%ebp)
  801f83:	e8 78 f3 ff ff       	call   801300 <memmove>
	return r;
  801f88:	83 c4 10             	add    $0x10,%esp
}
  801f8b:	89 d8                	mov    %ebx,%eax
  801f8d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f90:	5b                   	pop    %ebx
  801f91:	5e                   	pop    %esi
  801f92:	5d                   	pop    %ebp
  801f93:	c3                   	ret    
	assert(r <= n);
  801f94:	68 e4 36 80 00       	push   $0x8036e4
  801f99:	68 eb 36 80 00       	push   $0x8036eb
  801f9e:	6a 7c                	push   $0x7c
  801fa0:	68 00 37 80 00       	push   $0x803700
  801fa5:	e8 73 e9 ff ff       	call   80091d <_panic>
	assert(r <= PGSIZE);
  801faa:	68 0b 37 80 00       	push   $0x80370b
  801faf:	68 eb 36 80 00       	push   $0x8036eb
  801fb4:	6a 7d                	push   $0x7d
  801fb6:	68 00 37 80 00       	push   $0x803700
  801fbb:	e8 5d e9 ff ff       	call   80091d <_panic>

00801fc0 <open>:
{
  801fc0:	55                   	push   %ebp
  801fc1:	89 e5                	mov    %esp,%ebp
  801fc3:	56                   	push   %esi
  801fc4:	53                   	push   %ebx
  801fc5:	83 ec 1c             	sub    $0x1c,%esp
  801fc8:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801fcb:	56                   	push   %esi
  801fcc:	e8 68 f1 ff ff       	call   801139 <strlen>
  801fd1:	83 c4 10             	add    $0x10,%esp
  801fd4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801fd9:	7f 6c                	jg     802047 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801fdb:	83 ec 0c             	sub    $0xc,%esp
  801fde:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fe1:	50                   	push   %eax
  801fe2:	e8 79 f8 ff ff       	call   801860 <fd_alloc>
  801fe7:	89 c3                	mov    %eax,%ebx
  801fe9:	83 c4 10             	add    $0x10,%esp
  801fec:	85 c0                	test   %eax,%eax
  801fee:	78 3c                	js     80202c <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801ff0:	83 ec 08             	sub    $0x8,%esp
  801ff3:	56                   	push   %esi
  801ff4:	68 00 60 80 00       	push   $0x806000
  801ff9:	e8 74 f1 ff ff       	call   801172 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801ffe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802001:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802006:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802009:	b8 01 00 00 00       	mov    $0x1,%eax
  80200e:	e8 b8 fd ff ff       	call   801dcb <fsipc>
  802013:	89 c3                	mov    %eax,%ebx
  802015:	83 c4 10             	add    $0x10,%esp
  802018:	85 c0                	test   %eax,%eax
  80201a:	78 19                	js     802035 <open+0x75>
	return fd2num(fd);
  80201c:	83 ec 0c             	sub    $0xc,%esp
  80201f:	ff 75 f4             	pushl  -0xc(%ebp)
  802022:	e8 12 f8 ff ff       	call   801839 <fd2num>
  802027:	89 c3                	mov    %eax,%ebx
  802029:	83 c4 10             	add    $0x10,%esp
}
  80202c:	89 d8                	mov    %ebx,%eax
  80202e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802031:	5b                   	pop    %ebx
  802032:	5e                   	pop    %esi
  802033:	5d                   	pop    %ebp
  802034:	c3                   	ret    
		fd_close(fd, 0);
  802035:	83 ec 08             	sub    $0x8,%esp
  802038:	6a 00                	push   $0x0
  80203a:	ff 75 f4             	pushl  -0xc(%ebp)
  80203d:	e8 1b f9 ff ff       	call   80195d <fd_close>
		return r;
  802042:	83 c4 10             	add    $0x10,%esp
  802045:	eb e5                	jmp    80202c <open+0x6c>
		return -E_BAD_PATH;
  802047:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80204c:	eb de                	jmp    80202c <open+0x6c>

0080204e <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80204e:	55                   	push   %ebp
  80204f:	89 e5                	mov    %esp,%ebp
  802051:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802054:	ba 00 00 00 00       	mov    $0x0,%edx
  802059:	b8 08 00 00 00       	mov    $0x8,%eax
  80205e:	e8 68 fd ff ff       	call   801dcb <fsipc>
}
  802063:	c9                   	leave  
  802064:	c3                   	ret    

00802065 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
  802068:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80206b:	68 17 37 80 00       	push   $0x803717
  802070:	ff 75 0c             	pushl  0xc(%ebp)
  802073:	e8 fa f0 ff ff       	call   801172 <strcpy>
	return 0;
}
  802078:	b8 00 00 00 00       	mov    $0x0,%eax
  80207d:	c9                   	leave  
  80207e:	c3                   	ret    

0080207f <devsock_close>:
{
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
  802082:	53                   	push   %ebx
  802083:	83 ec 10             	sub    $0x10,%esp
  802086:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  802089:	53                   	push   %ebx
  80208a:	e8 95 0c 00 00       	call   802d24 <pageref>
  80208f:	83 c4 10             	add    $0x10,%esp
		return 0;
  802092:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  802097:	83 f8 01             	cmp    $0x1,%eax
  80209a:	74 07                	je     8020a3 <devsock_close+0x24>
}
  80209c:	89 d0                	mov    %edx,%eax
  80209e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020a1:	c9                   	leave  
  8020a2:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8020a3:	83 ec 0c             	sub    $0xc,%esp
  8020a6:	ff 73 0c             	pushl  0xc(%ebx)
  8020a9:	e8 b9 02 00 00       	call   802367 <nsipc_close>
  8020ae:	89 c2                	mov    %eax,%edx
  8020b0:	83 c4 10             	add    $0x10,%esp
  8020b3:	eb e7                	jmp    80209c <devsock_close+0x1d>

008020b5 <devsock_write>:
{
  8020b5:	55                   	push   %ebp
  8020b6:	89 e5                	mov    %esp,%ebp
  8020b8:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8020bb:	6a 00                	push   $0x0
  8020bd:	ff 75 10             	pushl  0x10(%ebp)
  8020c0:	ff 75 0c             	pushl  0xc(%ebp)
  8020c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c6:	ff 70 0c             	pushl  0xc(%eax)
  8020c9:	e8 76 03 00 00       	call   802444 <nsipc_send>
}
  8020ce:	c9                   	leave  
  8020cf:	c3                   	ret    

008020d0 <devsock_read>:
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
  8020d3:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8020d6:	6a 00                	push   $0x0
  8020d8:	ff 75 10             	pushl  0x10(%ebp)
  8020db:	ff 75 0c             	pushl  0xc(%ebp)
  8020de:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e1:	ff 70 0c             	pushl  0xc(%eax)
  8020e4:	e8 ef 02 00 00       	call   8023d8 <nsipc_recv>
}
  8020e9:	c9                   	leave  
  8020ea:	c3                   	ret    

008020eb <fd2sockid>:
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
  8020ee:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8020f1:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8020f4:	52                   	push   %edx
  8020f5:	50                   	push   %eax
  8020f6:	e8 b7 f7 ff ff       	call   8018b2 <fd_lookup>
  8020fb:	83 c4 10             	add    $0x10,%esp
  8020fe:	85 c0                	test   %eax,%eax
  802100:	78 10                	js     802112 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802102:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802105:	8b 0d 40 40 80 00    	mov    0x804040,%ecx
  80210b:	39 08                	cmp    %ecx,(%eax)
  80210d:	75 05                	jne    802114 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80210f:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802112:	c9                   	leave  
  802113:	c3                   	ret    
		return -E_NOT_SUPP;
  802114:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802119:	eb f7                	jmp    802112 <fd2sockid+0x27>

0080211b <alloc_sockfd>:
{
  80211b:	55                   	push   %ebp
  80211c:	89 e5                	mov    %esp,%ebp
  80211e:	56                   	push   %esi
  80211f:	53                   	push   %ebx
  802120:	83 ec 1c             	sub    $0x1c,%esp
  802123:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802125:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802128:	50                   	push   %eax
  802129:	e8 32 f7 ff ff       	call   801860 <fd_alloc>
  80212e:	89 c3                	mov    %eax,%ebx
  802130:	83 c4 10             	add    $0x10,%esp
  802133:	85 c0                	test   %eax,%eax
  802135:	78 43                	js     80217a <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802137:	83 ec 04             	sub    $0x4,%esp
  80213a:	68 07 04 00 00       	push   $0x407
  80213f:	ff 75 f4             	pushl  -0xc(%ebp)
  802142:	6a 00                	push   $0x0
  802144:	e8 1b f4 ff ff       	call   801564 <sys_page_alloc>
  802149:	89 c3                	mov    %eax,%ebx
  80214b:	83 c4 10             	add    $0x10,%esp
  80214e:	85 c0                	test   %eax,%eax
  802150:	78 28                	js     80217a <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802152:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802155:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80215b:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80215d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802160:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802167:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80216a:	83 ec 0c             	sub    $0xc,%esp
  80216d:	50                   	push   %eax
  80216e:	e8 c6 f6 ff ff       	call   801839 <fd2num>
  802173:	89 c3                	mov    %eax,%ebx
  802175:	83 c4 10             	add    $0x10,%esp
  802178:	eb 0c                	jmp    802186 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80217a:	83 ec 0c             	sub    $0xc,%esp
  80217d:	56                   	push   %esi
  80217e:	e8 e4 01 00 00       	call   802367 <nsipc_close>
		return r;
  802183:	83 c4 10             	add    $0x10,%esp
}
  802186:	89 d8                	mov    %ebx,%eax
  802188:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80218b:	5b                   	pop    %ebx
  80218c:	5e                   	pop    %esi
  80218d:	5d                   	pop    %ebp
  80218e:	c3                   	ret    

0080218f <accept>:
{
  80218f:	55                   	push   %ebp
  802190:	89 e5                	mov    %esp,%ebp
  802192:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802195:	8b 45 08             	mov    0x8(%ebp),%eax
  802198:	e8 4e ff ff ff       	call   8020eb <fd2sockid>
  80219d:	85 c0                	test   %eax,%eax
  80219f:	78 1b                	js     8021bc <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8021a1:	83 ec 04             	sub    $0x4,%esp
  8021a4:	ff 75 10             	pushl  0x10(%ebp)
  8021a7:	ff 75 0c             	pushl  0xc(%ebp)
  8021aa:	50                   	push   %eax
  8021ab:	e8 0e 01 00 00       	call   8022be <nsipc_accept>
  8021b0:	83 c4 10             	add    $0x10,%esp
  8021b3:	85 c0                	test   %eax,%eax
  8021b5:	78 05                	js     8021bc <accept+0x2d>
	return alloc_sockfd(r);
  8021b7:	e8 5f ff ff ff       	call   80211b <alloc_sockfd>
}
  8021bc:	c9                   	leave  
  8021bd:	c3                   	ret    

008021be <bind>:
{
  8021be:	55                   	push   %ebp
  8021bf:	89 e5                	mov    %esp,%ebp
  8021c1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c7:	e8 1f ff ff ff       	call   8020eb <fd2sockid>
  8021cc:	85 c0                	test   %eax,%eax
  8021ce:	78 12                	js     8021e2 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8021d0:	83 ec 04             	sub    $0x4,%esp
  8021d3:	ff 75 10             	pushl  0x10(%ebp)
  8021d6:	ff 75 0c             	pushl  0xc(%ebp)
  8021d9:	50                   	push   %eax
  8021da:	e8 31 01 00 00       	call   802310 <nsipc_bind>
  8021df:	83 c4 10             	add    $0x10,%esp
}
  8021e2:	c9                   	leave  
  8021e3:	c3                   	ret    

008021e4 <shutdown>:
{
  8021e4:	55                   	push   %ebp
  8021e5:	89 e5                	mov    %esp,%ebp
  8021e7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ed:	e8 f9 fe ff ff       	call   8020eb <fd2sockid>
  8021f2:	85 c0                	test   %eax,%eax
  8021f4:	78 0f                	js     802205 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8021f6:	83 ec 08             	sub    $0x8,%esp
  8021f9:	ff 75 0c             	pushl  0xc(%ebp)
  8021fc:	50                   	push   %eax
  8021fd:	e8 43 01 00 00       	call   802345 <nsipc_shutdown>
  802202:	83 c4 10             	add    $0x10,%esp
}
  802205:	c9                   	leave  
  802206:	c3                   	ret    

00802207 <connect>:
{
  802207:	55                   	push   %ebp
  802208:	89 e5                	mov    %esp,%ebp
  80220a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80220d:	8b 45 08             	mov    0x8(%ebp),%eax
  802210:	e8 d6 fe ff ff       	call   8020eb <fd2sockid>
  802215:	85 c0                	test   %eax,%eax
  802217:	78 12                	js     80222b <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802219:	83 ec 04             	sub    $0x4,%esp
  80221c:	ff 75 10             	pushl  0x10(%ebp)
  80221f:	ff 75 0c             	pushl  0xc(%ebp)
  802222:	50                   	push   %eax
  802223:	e8 59 01 00 00       	call   802381 <nsipc_connect>
  802228:	83 c4 10             	add    $0x10,%esp
}
  80222b:	c9                   	leave  
  80222c:	c3                   	ret    

0080222d <listen>:
{
  80222d:	55                   	push   %ebp
  80222e:	89 e5                	mov    %esp,%ebp
  802230:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802233:	8b 45 08             	mov    0x8(%ebp),%eax
  802236:	e8 b0 fe ff ff       	call   8020eb <fd2sockid>
  80223b:	85 c0                	test   %eax,%eax
  80223d:	78 0f                	js     80224e <listen+0x21>
	return nsipc_listen(r, backlog);
  80223f:	83 ec 08             	sub    $0x8,%esp
  802242:	ff 75 0c             	pushl  0xc(%ebp)
  802245:	50                   	push   %eax
  802246:	e8 6b 01 00 00       	call   8023b6 <nsipc_listen>
  80224b:	83 c4 10             	add    $0x10,%esp
}
  80224e:	c9                   	leave  
  80224f:	c3                   	ret    

00802250 <socket>:

int
socket(int domain, int type, int protocol)
{
  802250:	55                   	push   %ebp
  802251:	89 e5                	mov    %esp,%ebp
  802253:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802256:	ff 75 10             	pushl  0x10(%ebp)
  802259:	ff 75 0c             	pushl  0xc(%ebp)
  80225c:	ff 75 08             	pushl  0x8(%ebp)
  80225f:	e8 3e 02 00 00       	call   8024a2 <nsipc_socket>
  802264:	83 c4 10             	add    $0x10,%esp
  802267:	85 c0                	test   %eax,%eax
  802269:	78 05                	js     802270 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80226b:	e8 ab fe ff ff       	call   80211b <alloc_sockfd>
}
  802270:	c9                   	leave  
  802271:	c3                   	ret    

00802272 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802272:	55                   	push   %ebp
  802273:	89 e5                	mov    %esp,%ebp
  802275:	53                   	push   %ebx
  802276:	83 ec 04             	sub    $0x4,%esp
  802279:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80227b:	83 3d 14 50 80 00 00 	cmpl   $0x0,0x805014
  802282:	74 26                	je     8022aa <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802284:	6a 07                	push   $0x7
  802286:	68 00 70 80 00       	push   $0x807000
  80228b:	53                   	push   %ebx
  80228c:	ff 35 14 50 80 00    	pushl  0x805014
  802292:	e8 fa 09 00 00       	call   802c91 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802297:	83 c4 0c             	add    $0xc,%esp
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	e8 83 09 00 00       	call   802c28 <ipc_recv>
}
  8022a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022a8:	c9                   	leave  
  8022a9:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8022aa:	83 ec 0c             	sub    $0xc,%esp
  8022ad:	6a 02                	push   $0x2
  8022af:	e8 35 0a 00 00       	call   802ce9 <ipc_find_env>
  8022b4:	a3 14 50 80 00       	mov    %eax,0x805014
  8022b9:	83 c4 10             	add    $0x10,%esp
  8022bc:	eb c6                	jmp    802284 <nsipc+0x12>

008022be <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8022be:	55                   	push   %ebp
  8022bf:	89 e5                	mov    %esp,%ebp
  8022c1:	56                   	push   %esi
  8022c2:	53                   	push   %ebx
  8022c3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8022c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8022ce:	8b 06                	mov    (%esi),%eax
  8022d0:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8022d5:	b8 01 00 00 00       	mov    $0x1,%eax
  8022da:	e8 93 ff ff ff       	call   802272 <nsipc>
  8022df:	89 c3                	mov    %eax,%ebx
  8022e1:	85 c0                	test   %eax,%eax
  8022e3:	79 09                	jns    8022ee <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8022e5:	89 d8                	mov    %ebx,%eax
  8022e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022ea:	5b                   	pop    %ebx
  8022eb:	5e                   	pop    %esi
  8022ec:	5d                   	pop    %ebp
  8022ed:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8022ee:	83 ec 04             	sub    $0x4,%esp
  8022f1:	ff 35 10 70 80 00    	pushl  0x807010
  8022f7:	68 00 70 80 00       	push   $0x807000
  8022fc:	ff 75 0c             	pushl  0xc(%ebp)
  8022ff:	e8 fc ef ff ff       	call   801300 <memmove>
		*addrlen = ret->ret_addrlen;
  802304:	a1 10 70 80 00       	mov    0x807010,%eax
  802309:	89 06                	mov    %eax,(%esi)
  80230b:	83 c4 10             	add    $0x10,%esp
	return r;
  80230e:	eb d5                	jmp    8022e5 <nsipc_accept+0x27>

00802310 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802310:	55                   	push   %ebp
  802311:	89 e5                	mov    %esp,%ebp
  802313:	53                   	push   %ebx
  802314:	83 ec 08             	sub    $0x8,%esp
  802317:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80231a:	8b 45 08             	mov    0x8(%ebp),%eax
  80231d:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802322:	53                   	push   %ebx
  802323:	ff 75 0c             	pushl  0xc(%ebp)
  802326:	68 04 70 80 00       	push   $0x807004
  80232b:	e8 d0 ef ff ff       	call   801300 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802330:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802336:	b8 02 00 00 00       	mov    $0x2,%eax
  80233b:	e8 32 ff ff ff       	call   802272 <nsipc>
}
  802340:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802343:	c9                   	leave  
  802344:	c3                   	ret    

00802345 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802345:	55                   	push   %ebp
  802346:	89 e5                	mov    %esp,%ebp
  802348:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80234b:	8b 45 08             	mov    0x8(%ebp),%eax
  80234e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802353:	8b 45 0c             	mov    0xc(%ebp),%eax
  802356:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80235b:	b8 03 00 00 00       	mov    $0x3,%eax
  802360:	e8 0d ff ff ff       	call   802272 <nsipc>
}
  802365:	c9                   	leave  
  802366:	c3                   	ret    

00802367 <nsipc_close>:

int
nsipc_close(int s)
{
  802367:	55                   	push   %ebp
  802368:	89 e5                	mov    %esp,%ebp
  80236a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80236d:	8b 45 08             	mov    0x8(%ebp),%eax
  802370:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802375:	b8 04 00 00 00       	mov    $0x4,%eax
  80237a:	e8 f3 fe ff ff       	call   802272 <nsipc>
}
  80237f:	c9                   	leave  
  802380:	c3                   	ret    

00802381 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802381:	55                   	push   %ebp
  802382:	89 e5                	mov    %esp,%ebp
  802384:	53                   	push   %ebx
  802385:	83 ec 08             	sub    $0x8,%esp
  802388:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80238b:	8b 45 08             	mov    0x8(%ebp),%eax
  80238e:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802393:	53                   	push   %ebx
  802394:	ff 75 0c             	pushl  0xc(%ebp)
  802397:	68 04 70 80 00       	push   $0x807004
  80239c:	e8 5f ef ff ff       	call   801300 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8023a1:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8023a7:	b8 05 00 00 00       	mov    $0x5,%eax
  8023ac:	e8 c1 fe ff ff       	call   802272 <nsipc>
}
  8023b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023b4:	c9                   	leave  
  8023b5:	c3                   	ret    

008023b6 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8023b6:	55                   	push   %ebp
  8023b7:	89 e5                	mov    %esp,%ebp
  8023b9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8023bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bf:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8023c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023c7:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8023cc:	b8 06 00 00 00       	mov    $0x6,%eax
  8023d1:	e8 9c fe ff ff       	call   802272 <nsipc>
}
  8023d6:	c9                   	leave  
  8023d7:	c3                   	ret    

008023d8 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8023d8:	55                   	push   %ebp
  8023d9:	89 e5                	mov    %esp,%ebp
  8023db:	56                   	push   %esi
  8023dc:	53                   	push   %ebx
  8023dd:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8023e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e3:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8023e8:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8023ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8023f1:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8023f6:	b8 07 00 00 00       	mov    $0x7,%eax
  8023fb:	e8 72 fe ff ff       	call   802272 <nsipc>
  802400:	89 c3                	mov    %eax,%ebx
  802402:	85 c0                	test   %eax,%eax
  802404:	78 1f                	js     802425 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802406:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80240b:	7f 21                	jg     80242e <nsipc_recv+0x56>
  80240d:	39 c6                	cmp    %eax,%esi
  80240f:	7c 1d                	jl     80242e <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802411:	83 ec 04             	sub    $0x4,%esp
  802414:	50                   	push   %eax
  802415:	68 00 70 80 00       	push   $0x807000
  80241a:	ff 75 0c             	pushl  0xc(%ebp)
  80241d:	e8 de ee ff ff       	call   801300 <memmove>
  802422:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802425:	89 d8                	mov    %ebx,%eax
  802427:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80242a:	5b                   	pop    %ebx
  80242b:	5e                   	pop    %esi
  80242c:	5d                   	pop    %ebp
  80242d:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80242e:	68 23 37 80 00       	push   $0x803723
  802433:	68 eb 36 80 00       	push   $0x8036eb
  802438:	6a 62                	push   $0x62
  80243a:	68 38 37 80 00       	push   $0x803738
  80243f:	e8 d9 e4 ff ff       	call   80091d <_panic>

00802444 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802444:	55                   	push   %ebp
  802445:	89 e5                	mov    %esp,%ebp
  802447:	53                   	push   %ebx
  802448:	83 ec 04             	sub    $0x4,%esp
  80244b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80244e:	8b 45 08             	mov    0x8(%ebp),%eax
  802451:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802456:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80245c:	7f 2e                	jg     80248c <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80245e:	83 ec 04             	sub    $0x4,%esp
  802461:	53                   	push   %ebx
  802462:	ff 75 0c             	pushl  0xc(%ebp)
  802465:	68 0c 70 80 00       	push   $0x80700c
  80246a:	e8 91 ee ff ff       	call   801300 <memmove>
	nsipcbuf.send.req_size = size;
  80246f:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802475:	8b 45 14             	mov    0x14(%ebp),%eax
  802478:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80247d:	b8 08 00 00 00       	mov    $0x8,%eax
  802482:	e8 eb fd ff ff       	call   802272 <nsipc>
}
  802487:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80248a:	c9                   	leave  
  80248b:	c3                   	ret    
	assert(size < 1600);
  80248c:	68 44 37 80 00       	push   $0x803744
  802491:	68 eb 36 80 00       	push   $0x8036eb
  802496:	6a 6d                	push   $0x6d
  802498:	68 38 37 80 00       	push   $0x803738
  80249d:	e8 7b e4 ff ff       	call   80091d <_panic>

008024a2 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8024a2:	55                   	push   %ebp
  8024a3:	89 e5                	mov    %esp,%ebp
  8024a5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8024a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ab:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8024b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024b3:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8024b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8024bb:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8024c0:	b8 09 00 00 00       	mov    $0x9,%eax
  8024c5:	e8 a8 fd ff ff       	call   802272 <nsipc>
}
  8024ca:	c9                   	leave  
  8024cb:	c3                   	ret    

008024cc <free>:
	return v;
}

void
free(void *v)
{
  8024cc:	55                   	push   %ebp
  8024cd:	89 e5                	mov    %esp,%ebp
  8024cf:	53                   	push   %ebx
  8024d0:	83 ec 04             	sub    $0x4,%esp
  8024d3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
  8024d6:	85 db                	test   %ebx,%ebx
  8024d8:	0f 84 85 00 00 00    	je     802563 <free+0x97>
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  8024de:	8d 83 00 00 00 f8    	lea    -0x8000000(%ebx),%eax
  8024e4:	3d ff ff ff 07       	cmp    $0x7ffffff,%eax
  8024e9:	77 51                	ja     80253c <free+0x70>

	c = ROUNDDOWN(v, PGSIZE);
  8024eb:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  8024f1:	89 d8                	mov    %ebx,%eax
  8024f3:	c1 e8 0c             	shr    $0xc,%eax
  8024f6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8024fd:	f6 c4 02             	test   $0x2,%ah
  802500:	74 50                	je     802552 <free+0x86>
		sys_page_unmap(0, c);
  802502:	83 ec 08             	sub    $0x8,%esp
  802505:	53                   	push   %ebx
  802506:	6a 00                	push   $0x0
  802508:	e8 dc f0 ff ff       	call   8015e9 <sys_page_unmap>
		c += PGSIZE;
  80250d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		assert(mbegin <= c && c < mend);
  802513:	8d 83 00 00 00 f8    	lea    -0x8000000(%ebx),%eax
  802519:	83 c4 10             	add    $0x10,%esp
  80251c:	3d ff ff ff 07       	cmp    $0x7ffffff,%eax
  802521:	76 ce                	jbe    8024f1 <free+0x25>
  802523:	68 8d 37 80 00       	push   $0x80378d
  802528:	68 eb 36 80 00       	push   $0x8036eb
  80252d:	68 81 00 00 00       	push   $0x81
  802532:	68 80 37 80 00       	push   $0x803780
  802537:	e8 e1 e3 ff ff       	call   80091d <_panic>
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  80253c:	68 50 37 80 00       	push   $0x803750
  802541:	68 eb 36 80 00       	push   $0x8036eb
  802546:	6a 7a                	push   $0x7a
  802548:	68 80 37 80 00       	push   $0x803780
  80254d:	e8 cb e3 ff ff       	call   80091d <_panic>
	/*
	 * c is just a piece of this page, so dec the ref count
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
	if (--(*ref) == 0)
  802552:	8b 83 fc 0f 00 00    	mov    0xffc(%ebx),%eax
  802558:	83 e8 01             	sub    $0x1,%eax
  80255b:	89 83 fc 0f 00 00    	mov    %eax,0xffc(%ebx)
  802561:	74 05                	je     802568 <free+0x9c>
		sys_page_unmap(0, c);
}
  802563:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802566:	c9                   	leave  
  802567:	c3                   	ret    
		sys_page_unmap(0, c);
  802568:	83 ec 08             	sub    $0x8,%esp
  80256b:	53                   	push   %ebx
  80256c:	6a 00                	push   $0x0
  80256e:	e8 76 f0 ff ff       	call   8015e9 <sys_page_unmap>
  802573:	83 c4 10             	add    $0x10,%esp
  802576:	eb eb                	jmp    802563 <free+0x97>

00802578 <malloc>:
{
  802578:	55                   	push   %ebp
  802579:	89 e5                	mov    %esp,%ebp
  80257b:	57                   	push   %edi
  80257c:	56                   	push   %esi
  80257d:	53                   	push   %ebx
  80257e:	83 ec 1c             	sub    $0x1c,%esp
	if (mptr == 0)
  802581:	a1 18 50 80 00       	mov    0x805018,%eax
  802586:	85 c0                	test   %eax,%eax
  802588:	74 74                	je     8025fe <malloc+0x86>
	n = ROUNDUP(n, 4);
  80258a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80258d:	8d 51 03             	lea    0x3(%ecx),%edx
  802590:	83 e2 fc             	and    $0xfffffffc,%edx
  802593:	89 d6                	mov    %edx,%esi
  802595:	89 55 dc             	mov    %edx,-0x24(%ebp)
	if (n >= MAXMALLOC)
  802598:	81 fa ff ff 0f 00    	cmp    $0xfffff,%edx
  80259e:	0f 87 55 01 00 00    	ja     8026f9 <malloc+0x181>
	if ((uintptr_t) mptr % PGSIZE){
  8025a4:	89 c1                	mov    %eax,%ecx
  8025a6:	a9 ff 0f 00 00       	test   $0xfff,%eax
  8025ab:	74 30                	je     8025dd <malloc+0x65>
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
  8025ad:	89 c3                	mov    %eax,%ebx
  8025af:	c1 eb 0c             	shr    $0xc,%ebx
  8025b2:	8d 54 10 03          	lea    0x3(%eax,%edx,1),%edx
  8025b6:	c1 ea 0c             	shr    $0xc,%edx
  8025b9:	39 d3                	cmp    %edx,%ebx
  8025bb:	74 64                	je     802621 <malloc+0xa9>
		free(mptr);	/* drop reference to this page */
  8025bd:	83 ec 0c             	sub    $0xc,%esp
  8025c0:	50                   	push   %eax
  8025c1:	e8 06 ff ff ff       	call   8024cc <free>
		mptr = ROUNDDOWN(mptr + PGSIZE, PGSIZE);
  8025c6:	a1 18 50 80 00       	mov    0x805018,%eax
  8025cb:	05 00 10 00 00       	add    $0x1000,%eax
  8025d0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8025d5:	a3 18 50 80 00       	mov    %eax,0x805018
  8025da:	83 c4 10             	add    $0x10,%esp
  8025dd:	8b 15 18 50 80 00    	mov    0x805018,%edx
{
  8025e3:	c7 45 d8 02 00 00 00 	movl   $0x2,-0x28(%ebp)
  8025ea:	be 00 00 00 00       	mov    $0x0,%esi
		if (isfree(mptr, n + 4))
  8025ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025f2:	8d 78 04             	lea    0x4(%eax),%edi
  8025f5:	c6 45 e3 01          	movb   $0x1,-0x1d(%ebp)
  8025f9:	e9 86 00 00 00       	jmp    802684 <malloc+0x10c>
		mptr = mbegin;
  8025fe:	c7 05 18 50 80 00 00 	movl   $0x8000000,0x805018
  802605:	00 00 08 
	n = ROUNDUP(n, 4);
  802608:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80260b:	8d 51 03             	lea    0x3(%ecx),%edx
  80260e:	83 e2 fc             	and    $0xfffffffc,%edx
  802611:	89 55 dc             	mov    %edx,-0x24(%ebp)
	if (n >= MAXMALLOC)
  802614:	81 fa ff ff 0f 00    	cmp    $0xfffff,%edx
  80261a:	76 c1                	jbe    8025dd <malloc+0x65>
  80261c:	e9 fd 00 00 00       	jmp    80271e <malloc+0x1a6>
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
  802621:	81 c1 ff 0f 00 00    	add    $0xfff,%ecx
  802627:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
			(*ref)++;
  80262d:	83 41 fc 01          	addl   $0x1,-0x4(%ecx)
			mptr += n;
  802631:	89 f2                	mov    %esi,%edx
  802633:	01 c2                	add    %eax,%edx
  802635:	89 15 18 50 80 00    	mov    %edx,0x805018
			return v;
  80263b:	e9 de 00 00 00       	jmp    80271e <malloc+0x1a6>
	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  802640:	05 00 10 00 00       	add    $0x1000,%eax
  802645:	39 c8                	cmp    %ecx,%eax
  802647:	73 66                	jae    8026af <malloc+0x137>
		if (va >= (uintptr_t) mend
  802649:	3d ff ff ff 0f       	cmp    $0xfffffff,%eax
  80264e:	77 22                	ja     802672 <malloc+0xfa>
		    || ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
  802650:	89 c3                	mov    %eax,%ebx
  802652:	c1 eb 16             	shr    $0x16,%ebx
  802655:	8b 1c 9d 00 d0 7b ef 	mov    -0x10843000(,%ebx,4),%ebx
  80265c:	f6 c3 01             	test   $0x1,%bl
  80265f:	74 df                	je     802640 <malloc+0xc8>
  802661:	89 c3                	mov    %eax,%ebx
  802663:	c1 eb 0c             	shr    $0xc,%ebx
  802666:	8b 1c 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%ebx
  80266d:	f6 c3 01             	test   $0x1,%bl
  802670:	74 ce                	je     802640 <malloc+0xc8>
  802672:	81 c2 00 10 00 00    	add    $0x1000,%edx
  802678:	0f b6 75 e3          	movzbl -0x1d(%ebp),%esi
		if (mptr == mend) {
  80267c:	81 fa 00 00 00 10    	cmp    $0x10000000,%edx
  802682:	74 0a                	je     80268e <malloc+0x116>
  802684:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  802687:	89 d0                	mov    %edx,%eax
  802689:	8d 0c 17             	lea    (%edi,%edx,1),%ecx
  80268c:	eb b7                	jmp    802645 <malloc+0xcd>
			mptr = mbegin;
  80268e:	ba 00 00 00 08       	mov    $0x8000000,%edx
  802693:	be 01 00 00 00       	mov    $0x1,%esi
			if (++nwrap == 2)
  802698:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80269c:	75 e6                	jne    802684 <malloc+0x10c>
  80269e:	c7 05 18 50 80 00 00 	movl   $0x8000000,0x805018
  8026a5:	00 00 08 
				return 0;	/* out of address space */
  8026a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ad:	eb 6f                	jmp    80271e <malloc+0x1a6>
  8026af:	89 f0                	mov    %esi,%eax
  8026b1:	84 c0                	test   %al,%al
  8026b3:	74 08                	je     8026bd <malloc+0x145>
  8026b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026b8:	a3 18 50 80 00       	mov    %eax,0x805018
	for (i = 0; i < n + 4; i += PGSIZE){
  8026bd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026c2:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
  8026c5:	8d b3 00 10 00 00    	lea    0x1000(%ebx),%esi
  8026cb:	39 f7                	cmp    %esi,%edi
  8026cd:	76 57                	jbe    802726 <malloc+0x1ae>
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  8026cf:	83 ec 04             	sub    $0x4,%esp
  8026d2:	68 07 02 00 00       	push   $0x207
  8026d7:	89 d8                	mov    %ebx,%eax
  8026d9:	03 05 18 50 80 00    	add    0x805018,%eax
  8026df:	50                   	push   %eax
  8026e0:	6a 00                	push   $0x0
  8026e2:	e8 7d ee ff ff       	call   801564 <sys_page_alloc>
  8026e7:	83 c4 10             	add    $0x10,%esp
  8026ea:	85 c0                	test   %eax,%eax
  8026ec:	78 55                	js     802743 <malloc+0x1cb>
	for (i = 0; i < n + 4; i += PGSIZE){
  8026ee:	89 f3                	mov    %esi,%ebx
  8026f0:	eb d0                	jmp    8026c2 <malloc+0x14a>
			return 0;	/* out of physical memory */
  8026f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f7:	eb 25                	jmp    80271e <malloc+0x1a6>
		return 0;
  8026f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8026fe:	eb 1e                	jmp    80271e <malloc+0x1a6>
	ref = (uint32_t*) (mptr + i - 4);
  802700:	a1 18 50 80 00       	mov    0x805018,%eax
	*ref = 2;	/* reference for mptr, reference for returned block */
  802705:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  802708:	c7 84 08 fc 0f 00 00 	movl   $0x2,0xffc(%eax,%ecx,1)
  80270f:	02 00 00 00 
	mptr += n;
  802713:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802716:	01 c2                	add    %eax,%edx
  802718:	89 15 18 50 80 00    	mov    %edx,0x805018
}
  80271e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802721:	5b                   	pop    %ebx
  802722:	5e                   	pop    %esi
  802723:	5f                   	pop    %edi
  802724:	5d                   	pop    %ebp
  802725:	c3                   	ret    
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  802726:	83 ec 04             	sub    $0x4,%esp
  802729:	6a 07                	push   $0x7
  80272b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80272e:	03 05 18 50 80 00    	add    0x805018,%eax
  802734:	50                   	push   %eax
  802735:	6a 00                	push   $0x0
  802737:	e8 28 ee ff ff       	call   801564 <sys_page_alloc>
  80273c:	83 c4 10             	add    $0x10,%esp
  80273f:	85 c0                	test   %eax,%eax
  802741:	79 bd                	jns    802700 <malloc+0x188>
			for (; i >= 0; i -= PGSIZE)
  802743:	85 db                	test   %ebx,%ebx
  802745:	78 ab                	js     8026f2 <malloc+0x17a>
				sys_page_unmap(0, mptr + i);
  802747:	83 ec 08             	sub    $0x8,%esp
  80274a:	89 d8                	mov    %ebx,%eax
  80274c:	03 05 18 50 80 00    	add    0x805018,%eax
  802752:	50                   	push   %eax
  802753:	6a 00                	push   $0x0
  802755:	e8 8f ee ff ff       	call   8015e9 <sys_page_unmap>
			for (; i >= 0; i -= PGSIZE)
  80275a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
  802760:	83 c4 10             	add    $0x10,%esp
  802763:	eb de                	jmp    802743 <malloc+0x1cb>

00802765 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802765:	55                   	push   %ebp
  802766:	89 e5                	mov    %esp,%ebp
  802768:	56                   	push   %esi
  802769:	53                   	push   %ebx
  80276a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80276d:	83 ec 0c             	sub    $0xc,%esp
  802770:	ff 75 08             	pushl  0x8(%ebp)
  802773:	e8 d1 f0 ff ff       	call   801849 <fd2data>
  802778:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80277a:	83 c4 08             	add    $0x8,%esp
  80277d:	68 a5 37 80 00       	push   $0x8037a5
  802782:	53                   	push   %ebx
  802783:	e8 ea e9 ff ff       	call   801172 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802788:	8b 46 04             	mov    0x4(%esi),%eax
  80278b:	2b 06                	sub    (%esi),%eax
  80278d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802793:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80279a:	00 00 00 
	stat->st_dev = &devpipe;
  80279d:	c7 83 88 00 00 00 5c 	movl   $0x80405c,0x88(%ebx)
  8027a4:	40 80 00 
	return 0;
}
  8027a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027af:	5b                   	pop    %ebx
  8027b0:	5e                   	pop    %esi
  8027b1:	5d                   	pop    %ebp
  8027b2:	c3                   	ret    

008027b3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8027b3:	55                   	push   %ebp
  8027b4:	89 e5                	mov    %esp,%ebp
  8027b6:	53                   	push   %ebx
  8027b7:	83 ec 0c             	sub    $0xc,%esp
  8027ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8027bd:	53                   	push   %ebx
  8027be:	6a 00                	push   $0x0
  8027c0:	e8 24 ee ff ff       	call   8015e9 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8027c5:	89 1c 24             	mov    %ebx,(%esp)
  8027c8:	e8 7c f0 ff ff       	call   801849 <fd2data>
  8027cd:	83 c4 08             	add    $0x8,%esp
  8027d0:	50                   	push   %eax
  8027d1:	6a 00                	push   $0x0
  8027d3:	e8 11 ee ff ff       	call   8015e9 <sys_page_unmap>
}
  8027d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027db:	c9                   	leave  
  8027dc:	c3                   	ret    

008027dd <_pipeisclosed>:
{
  8027dd:	55                   	push   %ebp
  8027de:	89 e5                	mov    %esp,%ebp
  8027e0:	57                   	push   %edi
  8027e1:	56                   	push   %esi
  8027e2:	53                   	push   %ebx
  8027e3:	83 ec 1c             	sub    $0x1c,%esp
  8027e6:	89 c7                	mov    %eax,%edi
  8027e8:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8027ea:	a1 1c 50 80 00       	mov    0x80501c,%eax
  8027ef:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8027f2:	83 ec 0c             	sub    $0xc,%esp
  8027f5:	57                   	push   %edi
  8027f6:	e8 29 05 00 00       	call   802d24 <pageref>
  8027fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8027fe:	89 34 24             	mov    %esi,(%esp)
  802801:	e8 1e 05 00 00       	call   802d24 <pageref>
		nn = thisenv->env_runs;
  802806:	8b 15 1c 50 80 00    	mov    0x80501c,%edx
  80280c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80280f:	83 c4 10             	add    $0x10,%esp
  802812:	39 cb                	cmp    %ecx,%ebx
  802814:	74 1b                	je     802831 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802816:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802819:	75 cf                	jne    8027ea <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80281b:	8b 42 58             	mov    0x58(%edx),%eax
  80281e:	6a 01                	push   $0x1
  802820:	50                   	push   %eax
  802821:	53                   	push   %ebx
  802822:	68 ac 37 80 00       	push   $0x8037ac
  802827:	e8 e7 e1 ff ff       	call   800a13 <cprintf>
  80282c:	83 c4 10             	add    $0x10,%esp
  80282f:	eb b9                	jmp    8027ea <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802831:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802834:	0f 94 c0             	sete   %al
  802837:	0f b6 c0             	movzbl %al,%eax
}
  80283a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80283d:	5b                   	pop    %ebx
  80283e:	5e                   	pop    %esi
  80283f:	5f                   	pop    %edi
  802840:	5d                   	pop    %ebp
  802841:	c3                   	ret    

00802842 <devpipe_write>:
{
  802842:	55                   	push   %ebp
  802843:	89 e5                	mov    %esp,%ebp
  802845:	57                   	push   %edi
  802846:	56                   	push   %esi
  802847:	53                   	push   %ebx
  802848:	83 ec 28             	sub    $0x28,%esp
  80284b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80284e:	56                   	push   %esi
  80284f:	e8 f5 ef ff ff       	call   801849 <fd2data>
  802854:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802856:	83 c4 10             	add    $0x10,%esp
  802859:	bf 00 00 00 00       	mov    $0x0,%edi
  80285e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802861:	74 4f                	je     8028b2 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802863:	8b 43 04             	mov    0x4(%ebx),%eax
  802866:	8b 0b                	mov    (%ebx),%ecx
  802868:	8d 51 20             	lea    0x20(%ecx),%edx
  80286b:	39 d0                	cmp    %edx,%eax
  80286d:	72 14                	jb     802883 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80286f:	89 da                	mov    %ebx,%edx
  802871:	89 f0                	mov    %esi,%eax
  802873:	e8 65 ff ff ff       	call   8027dd <_pipeisclosed>
  802878:	85 c0                	test   %eax,%eax
  80287a:	75 3b                	jne    8028b7 <devpipe_write+0x75>
			sys_yield();
  80287c:	e8 c4 ec ff ff       	call   801545 <sys_yield>
  802881:	eb e0                	jmp    802863 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802883:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802886:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80288a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80288d:	89 c2                	mov    %eax,%edx
  80288f:	c1 fa 1f             	sar    $0x1f,%edx
  802892:	89 d1                	mov    %edx,%ecx
  802894:	c1 e9 1b             	shr    $0x1b,%ecx
  802897:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80289a:	83 e2 1f             	and    $0x1f,%edx
  80289d:	29 ca                	sub    %ecx,%edx
  80289f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8028a3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8028a7:	83 c0 01             	add    $0x1,%eax
  8028aa:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8028ad:	83 c7 01             	add    $0x1,%edi
  8028b0:	eb ac                	jmp    80285e <devpipe_write+0x1c>
	return i;
  8028b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8028b5:	eb 05                	jmp    8028bc <devpipe_write+0x7a>
				return 0;
  8028b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028bf:	5b                   	pop    %ebx
  8028c0:	5e                   	pop    %esi
  8028c1:	5f                   	pop    %edi
  8028c2:	5d                   	pop    %ebp
  8028c3:	c3                   	ret    

008028c4 <devpipe_read>:
{
  8028c4:	55                   	push   %ebp
  8028c5:	89 e5                	mov    %esp,%ebp
  8028c7:	57                   	push   %edi
  8028c8:	56                   	push   %esi
  8028c9:	53                   	push   %ebx
  8028ca:	83 ec 18             	sub    $0x18,%esp
  8028cd:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8028d0:	57                   	push   %edi
  8028d1:	e8 73 ef ff ff       	call   801849 <fd2data>
  8028d6:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8028d8:	83 c4 10             	add    $0x10,%esp
  8028db:	be 00 00 00 00       	mov    $0x0,%esi
  8028e0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8028e3:	75 14                	jne    8028f9 <devpipe_read+0x35>
	return i;
  8028e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8028e8:	eb 02                	jmp    8028ec <devpipe_read+0x28>
				return i;
  8028ea:	89 f0                	mov    %esi,%eax
}
  8028ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028ef:	5b                   	pop    %ebx
  8028f0:	5e                   	pop    %esi
  8028f1:	5f                   	pop    %edi
  8028f2:	5d                   	pop    %ebp
  8028f3:	c3                   	ret    
			sys_yield();
  8028f4:	e8 4c ec ff ff       	call   801545 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8028f9:	8b 03                	mov    (%ebx),%eax
  8028fb:	3b 43 04             	cmp    0x4(%ebx),%eax
  8028fe:	75 18                	jne    802918 <devpipe_read+0x54>
			if (i > 0)
  802900:	85 f6                	test   %esi,%esi
  802902:	75 e6                	jne    8028ea <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802904:	89 da                	mov    %ebx,%edx
  802906:	89 f8                	mov    %edi,%eax
  802908:	e8 d0 fe ff ff       	call   8027dd <_pipeisclosed>
  80290d:	85 c0                	test   %eax,%eax
  80290f:	74 e3                	je     8028f4 <devpipe_read+0x30>
				return 0;
  802911:	b8 00 00 00 00       	mov    $0x0,%eax
  802916:	eb d4                	jmp    8028ec <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802918:	99                   	cltd   
  802919:	c1 ea 1b             	shr    $0x1b,%edx
  80291c:	01 d0                	add    %edx,%eax
  80291e:	83 e0 1f             	and    $0x1f,%eax
  802921:	29 d0                	sub    %edx,%eax
  802923:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802928:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80292b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80292e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802931:	83 c6 01             	add    $0x1,%esi
  802934:	eb aa                	jmp    8028e0 <devpipe_read+0x1c>

00802936 <pipe>:
{
  802936:	55                   	push   %ebp
  802937:	89 e5                	mov    %esp,%ebp
  802939:	56                   	push   %esi
  80293a:	53                   	push   %ebx
  80293b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80293e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802941:	50                   	push   %eax
  802942:	e8 19 ef ff ff       	call   801860 <fd_alloc>
  802947:	89 c3                	mov    %eax,%ebx
  802949:	83 c4 10             	add    $0x10,%esp
  80294c:	85 c0                	test   %eax,%eax
  80294e:	0f 88 23 01 00 00    	js     802a77 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802954:	83 ec 04             	sub    $0x4,%esp
  802957:	68 07 04 00 00       	push   $0x407
  80295c:	ff 75 f4             	pushl  -0xc(%ebp)
  80295f:	6a 00                	push   $0x0
  802961:	e8 fe eb ff ff       	call   801564 <sys_page_alloc>
  802966:	89 c3                	mov    %eax,%ebx
  802968:	83 c4 10             	add    $0x10,%esp
  80296b:	85 c0                	test   %eax,%eax
  80296d:	0f 88 04 01 00 00    	js     802a77 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802973:	83 ec 0c             	sub    $0xc,%esp
  802976:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802979:	50                   	push   %eax
  80297a:	e8 e1 ee ff ff       	call   801860 <fd_alloc>
  80297f:	89 c3                	mov    %eax,%ebx
  802981:	83 c4 10             	add    $0x10,%esp
  802984:	85 c0                	test   %eax,%eax
  802986:	0f 88 db 00 00 00    	js     802a67 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80298c:	83 ec 04             	sub    $0x4,%esp
  80298f:	68 07 04 00 00       	push   $0x407
  802994:	ff 75 f0             	pushl  -0x10(%ebp)
  802997:	6a 00                	push   $0x0
  802999:	e8 c6 eb ff ff       	call   801564 <sys_page_alloc>
  80299e:	89 c3                	mov    %eax,%ebx
  8029a0:	83 c4 10             	add    $0x10,%esp
  8029a3:	85 c0                	test   %eax,%eax
  8029a5:	0f 88 bc 00 00 00    	js     802a67 <pipe+0x131>
	va = fd2data(fd0);
  8029ab:	83 ec 0c             	sub    $0xc,%esp
  8029ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8029b1:	e8 93 ee ff ff       	call   801849 <fd2data>
  8029b6:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8029b8:	83 c4 0c             	add    $0xc,%esp
  8029bb:	68 07 04 00 00       	push   $0x407
  8029c0:	50                   	push   %eax
  8029c1:	6a 00                	push   $0x0
  8029c3:	e8 9c eb ff ff       	call   801564 <sys_page_alloc>
  8029c8:	89 c3                	mov    %eax,%ebx
  8029ca:	83 c4 10             	add    $0x10,%esp
  8029cd:	85 c0                	test   %eax,%eax
  8029cf:	0f 88 82 00 00 00    	js     802a57 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8029d5:	83 ec 0c             	sub    $0xc,%esp
  8029d8:	ff 75 f0             	pushl  -0x10(%ebp)
  8029db:	e8 69 ee ff ff       	call   801849 <fd2data>
  8029e0:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8029e7:	50                   	push   %eax
  8029e8:	6a 00                	push   $0x0
  8029ea:	56                   	push   %esi
  8029eb:	6a 00                	push   $0x0
  8029ed:	e8 b5 eb ff ff       	call   8015a7 <sys_page_map>
  8029f2:	89 c3                	mov    %eax,%ebx
  8029f4:	83 c4 20             	add    $0x20,%esp
  8029f7:	85 c0                	test   %eax,%eax
  8029f9:	78 4e                	js     802a49 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8029fb:	a1 5c 40 80 00       	mov    0x80405c,%eax
  802a00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a03:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802a05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a08:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802a0f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a12:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802a14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a17:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802a1e:	83 ec 0c             	sub    $0xc,%esp
  802a21:	ff 75 f4             	pushl  -0xc(%ebp)
  802a24:	e8 10 ee ff ff       	call   801839 <fd2num>
  802a29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802a2c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802a2e:	83 c4 04             	add    $0x4,%esp
  802a31:	ff 75 f0             	pushl  -0x10(%ebp)
  802a34:	e8 00 ee ff ff       	call   801839 <fd2num>
  802a39:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802a3c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802a3f:	83 c4 10             	add    $0x10,%esp
  802a42:	bb 00 00 00 00       	mov    $0x0,%ebx
  802a47:	eb 2e                	jmp    802a77 <pipe+0x141>
	sys_page_unmap(0, va);
  802a49:	83 ec 08             	sub    $0x8,%esp
  802a4c:	56                   	push   %esi
  802a4d:	6a 00                	push   $0x0
  802a4f:	e8 95 eb ff ff       	call   8015e9 <sys_page_unmap>
  802a54:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802a57:	83 ec 08             	sub    $0x8,%esp
  802a5a:	ff 75 f0             	pushl  -0x10(%ebp)
  802a5d:	6a 00                	push   $0x0
  802a5f:	e8 85 eb ff ff       	call   8015e9 <sys_page_unmap>
  802a64:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802a67:	83 ec 08             	sub    $0x8,%esp
  802a6a:	ff 75 f4             	pushl  -0xc(%ebp)
  802a6d:	6a 00                	push   $0x0
  802a6f:	e8 75 eb ff ff       	call   8015e9 <sys_page_unmap>
  802a74:	83 c4 10             	add    $0x10,%esp
}
  802a77:	89 d8                	mov    %ebx,%eax
  802a79:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a7c:	5b                   	pop    %ebx
  802a7d:	5e                   	pop    %esi
  802a7e:	5d                   	pop    %ebp
  802a7f:	c3                   	ret    

00802a80 <pipeisclosed>:
{
  802a80:	55                   	push   %ebp
  802a81:	89 e5                	mov    %esp,%ebp
  802a83:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a86:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a89:	50                   	push   %eax
  802a8a:	ff 75 08             	pushl  0x8(%ebp)
  802a8d:	e8 20 ee ff ff       	call   8018b2 <fd_lookup>
  802a92:	83 c4 10             	add    $0x10,%esp
  802a95:	85 c0                	test   %eax,%eax
  802a97:	78 18                	js     802ab1 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802a99:	83 ec 0c             	sub    $0xc,%esp
  802a9c:	ff 75 f4             	pushl  -0xc(%ebp)
  802a9f:	e8 a5 ed ff ff       	call   801849 <fd2data>
	return _pipeisclosed(fd, p);
  802aa4:	89 c2                	mov    %eax,%edx
  802aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa9:	e8 2f fd ff ff       	call   8027dd <_pipeisclosed>
  802aae:	83 c4 10             	add    $0x10,%esp
}
  802ab1:	c9                   	leave  
  802ab2:	c3                   	ret    

00802ab3 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802ab3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ab8:	c3                   	ret    

00802ab9 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802ab9:	55                   	push   %ebp
  802aba:	89 e5                	mov    %esp,%ebp
  802abc:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802abf:	68 c4 37 80 00       	push   $0x8037c4
  802ac4:	ff 75 0c             	pushl  0xc(%ebp)
  802ac7:	e8 a6 e6 ff ff       	call   801172 <strcpy>
	return 0;
}
  802acc:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad1:	c9                   	leave  
  802ad2:	c3                   	ret    

00802ad3 <devcons_write>:
{
  802ad3:	55                   	push   %ebp
  802ad4:	89 e5                	mov    %esp,%ebp
  802ad6:	57                   	push   %edi
  802ad7:	56                   	push   %esi
  802ad8:	53                   	push   %ebx
  802ad9:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802adf:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802ae4:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802aea:	3b 75 10             	cmp    0x10(%ebp),%esi
  802aed:	73 31                	jae    802b20 <devcons_write+0x4d>
		m = n - tot;
  802aef:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802af2:	29 f3                	sub    %esi,%ebx
  802af4:	83 fb 7f             	cmp    $0x7f,%ebx
  802af7:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802afc:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802aff:	83 ec 04             	sub    $0x4,%esp
  802b02:	53                   	push   %ebx
  802b03:	89 f0                	mov    %esi,%eax
  802b05:	03 45 0c             	add    0xc(%ebp),%eax
  802b08:	50                   	push   %eax
  802b09:	57                   	push   %edi
  802b0a:	e8 f1 e7 ff ff       	call   801300 <memmove>
		sys_cputs(buf, m);
  802b0f:	83 c4 08             	add    $0x8,%esp
  802b12:	53                   	push   %ebx
  802b13:	57                   	push   %edi
  802b14:	e8 8f e9 ff ff       	call   8014a8 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802b19:	01 de                	add    %ebx,%esi
  802b1b:	83 c4 10             	add    $0x10,%esp
  802b1e:	eb ca                	jmp    802aea <devcons_write+0x17>
}
  802b20:	89 f0                	mov    %esi,%eax
  802b22:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802b25:	5b                   	pop    %ebx
  802b26:	5e                   	pop    %esi
  802b27:	5f                   	pop    %edi
  802b28:	5d                   	pop    %ebp
  802b29:	c3                   	ret    

00802b2a <devcons_read>:
{
  802b2a:	55                   	push   %ebp
  802b2b:	89 e5                	mov    %esp,%ebp
  802b2d:	83 ec 08             	sub    $0x8,%esp
  802b30:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802b35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802b39:	74 21                	je     802b5c <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802b3b:	e8 86 e9 ff ff       	call   8014c6 <sys_cgetc>
  802b40:	85 c0                	test   %eax,%eax
  802b42:	75 07                	jne    802b4b <devcons_read+0x21>
		sys_yield();
  802b44:	e8 fc e9 ff ff       	call   801545 <sys_yield>
  802b49:	eb f0                	jmp    802b3b <devcons_read+0x11>
	if (c < 0)
  802b4b:	78 0f                	js     802b5c <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802b4d:	83 f8 04             	cmp    $0x4,%eax
  802b50:	74 0c                	je     802b5e <devcons_read+0x34>
	*(char*)vbuf = c;
  802b52:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b55:	88 02                	mov    %al,(%edx)
	return 1;
  802b57:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802b5c:	c9                   	leave  
  802b5d:	c3                   	ret    
		return 0;
  802b5e:	b8 00 00 00 00       	mov    $0x0,%eax
  802b63:	eb f7                	jmp    802b5c <devcons_read+0x32>

00802b65 <cputchar>:
{
  802b65:	55                   	push   %ebp
  802b66:	89 e5                	mov    %esp,%ebp
  802b68:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6e:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802b71:	6a 01                	push   $0x1
  802b73:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802b76:	50                   	push   %eax
  802b77:	e8 2c e9 ff ff       	call   8014a8 <sys_cputs>
}
  802b7c:	83 c4 10             	add    $0x10,%esp
  802b7f:	c9                   	leave  
  802b80:	c3                   	ret    

00802b81 <getchar>:
{
  802b81:	55                   	push   %ebp
  802b82:	89 e5                	mov    %esp,%ebp
  802b84:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802b87:	6a 01                	push   $0x1
  802b89:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802b8c:	50                   	push   %eax
  802b8d:	6a 00                	push   $0x0
  802b8f:	e8 8e ef ff ff       	call   801b22 <read>
	if (r < 0)
  802b94:	83 c4 10             	add    $0x10,%esp
  802b97:	85 c0                	test   %eax,%eax
  802b99:	78 06                	js     802ba1 <getchar+0x20>
	if (r < 1)
  802b9b:	74 06                	je     802ba3 <getchar+0x22>
	return c;
  802b9d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802ba1:	c9                   	leave  
  802ba2:	c3                   	ret    
		return -E_EOF;
  802ba3:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802ba8:	eb f7                	jmp    802ba1 <getchar+0x20>

00802baa <iscons>:
{
  802baa:	55                   	push   %ebp
  802bab:	89 e5                	mov    %esp,%ebp
  802bad:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802bb0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802bb3:	50                   	push   %eax
  802bb4:	ff 75 08             	pushl  0x8(%ebp)
  802bb7:	e8 f6 ec ff ff       	call   8018b2 <fd_lookup>
  802bbc:	83 c4 10             	add    $0x10,%esp
  802bbf:	85 c0                	test   %eax,%eax
  802bc1:	78 11                	js     802bd4 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc6:	8b 15 78 40 80 00    	mov    0x804078,%edx
  802bcc:	39 10                	cmp    %edx,(%eax)
  802bce:	0f 94 c0             	sete   %al
  802bd1:	0f b6 c0             	movzbl %al,%eax
}
  802bd4:	c9                   	leave  
  802bd5:	c3                   	ret    

00802bd6 <opencons>:
{
  802bd6:	55                   	push   %ebp
  802bd7:	89 e5                	mov    %esp,%ebp
  802bd9:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802bdc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802bdf:	50                   	push   %eax
  802be0:	e8 7b ec ff ff       	call   801860 <fd_alloc>
  802be5:	83 c4 10             	add    $0x10,%esp
  802be8:	85 c0                	test   %eax,%eax
  802bea:	78 3a                	js     802c26 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802bec:	83 ec 04             	sub    $0x4,%esp
  802bef:	68 07 04 00 00       	push   $0x407
  802bf4:	ff 75 f4             	pushl  -0xc(%ebp)
  802bf7:	6a 00                	push   $0x0
  802bf9:	e8 66 e9 ff ff       	call   801564 <sys_page_alloc>
  802bfe:	83 c4 10             	add    $0x10,%esp
  802c01:	85 c0                	test   %eax,%eax
  802c03:	78 21                	js     802c26 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c08:	8b 15 78 40 80 00    	mov    0x804078,%edx
  802c0e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c13:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802c1a:	83 ec 0c             	sub    $0xc,%esp
  802c1d:	50                   	push   %eax
  802c1e:	e8 16 ec ff ff       	call   801839 <fd2num>
  802c23:	83 c4 10             	add    $0x10,%esp
}
  802c26:	c9                   	leave  
  802c27:	c3                   	ret    

00802c28 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802c28:	55                   	push   %ebp
  802c29:	89 e5                	mov    %esp,%ebp
  802c2b:	56                   	push   %esi
  802c2c:	53                   	push   %ebx
  802c2d:	8b 75 08             	mov    0x8(%ebp),%esi
  802c30:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c33:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802c36:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802c38:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802c3d:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802c40:	83 ec 0c             	sub    $0xc,%esp
  802c43:	50                   	push   %eax
  802c44:	e8 cb ea ff ff       	call   801714 <sys_ipc_recv>
	if(ret < 0){
  802c49:	83 c4 10             	add    $0x10,%esp
  802c4c:	85 c0                	test   %eax,%eax
  802c4e:	78 2b                	js     802c7b <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802c50:	85 f6                	test   %esi,%esi
  802c52:	74 0a                	je     802c5e <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802c54:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802c59:	8b 40 74             	mov    0x74(%eax),%eax
  802c5c:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802c5e:	85 db                	test   %ebx,%ebx
  802c60:	74 0a                	je     802c6c <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802c62:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802c67:	8b 40 78             	mov    0x78(%eax),%eax
  802c6a:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802c6c:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802c71:	8b 40 70             	mov    0x70(%eax),%eax
}
  802c74:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802c77:	5b                   	pop    %ebx
  802c78:	5e                   	pop    %esi
  802c79:	5d                   	pop    %ebp
  802c7a:	c3                   	ret    
		if(from_env_store)
  802c7b:	85 f6                	test   %esi,%esi
  802c7d:	74 06                	je     802c85 <ipc_recv+0x5d>
			*from_env_store = 0;
  802c7f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802c85:	85 db                	test   %ebx,%ebx
  802c87:	74 eb                	je     802c74 <ipc_recv+0x4c>
			*perm_store = 0;
  802c89:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802c8f:	eb e3                	jmp    802c74 <ipc_recv+0x4c>

00802c91 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802c91:	55                   	push   %ebp
  802c92:	89 e5                	mov    %esp,%ebp
  802c94:	57                   	push   %edi
  802c95:	56                   	push   %esi
  802c96:	53                   	push   %ebx
  802c97:	83 ec 0c             	sub    $0xc,%esp
  802c9a:	8b 7d 08             	mov    0x8(%ebp),%edi
  802c9d:	8b 75 0c             	mov    0xc(%ebp),%esi
  802ca0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802ca3:	85 db                	test   %ebx,%ebx
  802ca5:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802caa:	0f 44 d8             	cmove  %eax,%ebx
  802cad:	eb 05                	jmp    802cb4 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802caf:	e8 91 e8 ff ff       	call   801545 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802cb4:	ff 75 14             	pushl  0x14(%ebp)
  802cb7:	53                   	push   %ebx
  802cb8:	56                   	push   %esi
  802cb9:	57                   	push   %edi
  802cba:	e8 32 ea ff ff       	call   8016f1 <sys_ipc_try_send>
  802cbf:	83 c4 10             	add    $0x10,%esp
  802cc2:	85 c0                	test   %eax,%eax
  802cc4:	74 1b                	je     802ce1 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802cc6:	79 e7                	jns    802caf <ipc_send+0x1e>
  802cc8:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802ccb:	74 e2                	je     802caf <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802ccd:	83 ec 04             	sub    $0x4,%esp
  802cd0:	68 d0 37 80 00       	push   $0x8037d0
  802cd5:	6a 46                	push   $0x46
  802cd7:	68 e5 37 80 00       	push   $0x8037e5
  802cdc:	e8 3c dc ff ff       	call   80091d <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802ce1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802ce4:	5b                   	pop    %ebx
  802ce5:	5e                   	pop    %esi
  802ce6:	5f                   	pop    %edi
  802ce7:	5d                   	pop    %ebp
  802ce8:	c3                   	ret    

00802ce9 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802ce9:	55                   	push   %ebp
  802cea:	89 e5                	mov    %esp,%ebp
  802cec:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802cef:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802cf4:	89 c2                	mov    %eax,%edx
  802cf6:	c1 e2 07             	shl    $0x7,%edx
  802cf9:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802cff:	8b 52 50             	mov    0x50(%edx),%edx
  802d02:	39 ca                	cmp    %ecx,%edx
  802d04:	74 11                	je     802d17 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802d06:	83 c0 01             	add    $0x1,%eax
  802d09:	3d 00 04 00 00       	cmp    $0x400,%eax
  802d0e:	75 e4                	jne    802cf4 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802d10:	b8 00 00 00 00       	mov    $0x0,%eax
  802d15:	eb 0b                	jmp    802d22 <ipc_find_env+0x39>
			return envs[i].env_id;
  802d17:	c1 e0 07             	shl    $0x7,%eax
  802d1a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802d1f:	8b 40 48             	mov    0x48(%eax),%eax
}
  802d22:	5d                   	pop    %ebp
  802d23:	c3                   	ret    

00802d24 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802d24:	55                   	push   %ebp
  802d25:	89 e5                	mov    %esp,%ebp
  802d27:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802d2a:	89 d0                	mov    %edx,%eax
  802d2c:	c1 e8 16             	shr    $0x16,%eax
  802d2f:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802d36:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802d3b:	f6 c1 01             	test   $0x1,%cl
  802d3e:	74 1d                	je     802d5d <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802d40:	c1 ea 0c             	shr    $0xc,%edx
  802d43:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802d4a:	f6 c2 01             	test   $0x1,%dl
  802d4d:	74 0e                	je     802d5d <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802d4f:	c1 ea 0c             	shr    $0xc,%edx
  802d52:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802d59:	ef 
  802d5a:	0f b7 c0             	movzwl %ax,%eax
}
  802d5d:	5d                   	pop    %ebp
  802d5e:	c3                   	ret    
  802d5f:	90                   	nop

00802d60 <__udivdi3>:
  802d60:	55                   	push   %ebp
  802d61:	57                   	push   %edi
  802d62:	56                   	push   %esi
  802d63:	53                   	push   %ebx
  802d64:	83 ec 1c             	sub    $0x1c,%esp
  802d67:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802d6b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802d6f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802d73:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802d77:	85 d2                	test   %edx,%edx
  802d79:	75 4d                	jne    802dc8 <__udivdi3+0x68>
  802d7b:	39 f3                	cmp    %esi,%ebx
  802d7d:	76 19                	jbe    802d98 <__udivdi3+0x38>
  802d7f:	31 ff                	xor    %edi,%edi
  802d81:	89 e8                	mov    %ebp,%eax
  802d83:	89 f2                	mov    %esi,%edx
  802d85:	f7 f3                	div    %ebx
  802d87:	89 fa                	mov    %edi,%edx
  802d89:	83 c4 1c             	add    $0x1c,%esp
  802d8c:	5b                   	pop    %ebx
  802d8d:	5e                   	pop    %esi
  802d8e:	5f                   	pop    %edi
  802d8f:	5d                   	pop    %ebp
  802d90:	c3                   	ret    
  802d91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802d98:	89 d9                	mov    %ebx,%ecx
  802d9a:	85 db                	test   %ebx,%ebx
  802d9c:	75 0b                	jne    802da9 <__udivdi3+0x49>
  802d9e:	b8 01 00 00 00       	mov    $0x1,%eax
  802da3:	31 d2                	xor    %edx,%edx
  802da5:	f7 f3                	div    %ebx
  802da7:	89 c1                	mov    %eax,%ecx
  802da9:	31 d2                	xor    %edx,%edx
  802dab:	89 f0                	mov    %esi,%eax
  802dad:	f7 f1                	div    %ecx
  802daf:	89 c6                	mov    %eax,%esi
  802db1:	89 e8                	mov    %ebp,%eax
  802db3:	89 f7                	mov    %esi,%edi
  802db5:	f7 f1                	div    %ecx
  802db7:	89 fa                	mov    %edi,%edx
  802db9:	83 c4 1c             	add    $0x1c,%esp
  802dbc:	5b                   	pop    %ebx
  802dbd:	5e                   	pop    %esi
  802dbe:	5f                   	pop    %edi
  802dbf:	5d                   	pop    %ebp
  802dc0:	c3                   	ret    
  802dc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802dc8:	39 f2                	cmp    %esi,%edx
  802dca:	77 1c                	ja     802de8 <__udivdi3+0x88>
  802dcc:	0f bd fa             	bsr    %edx,%edi
  802dcf:	83 f7 1f             	xor    $0x1f,%edi
  802dd2:	75 2c                	jne    802e00 <__udivdi3+0xa0>
  802dd4:	39 f2                	cmp    %esi,%edx
  802dd6:	72 06                	jb     802dde <__udivdi3+0x7e>
  802dd8:	31 c0                	xor    %eax,%eax
  802dda:	39 eb                	cmp    %ebp,%ebx
  802ddc:	77 a9                	ja     802d87 <__udivdi3+0x27>
  802dde:	b8 01 00 00 00       	mov    $0x1,%eax
  802de3:	eb a2                	jmp    802d87 <__udivdi3+0x27>
  802de5:	8d 76 00             	lea    0x0(%esi),%esi
  802de8:	31 ff                	xor    %edi,%edi
  802dea:	31 c0                	xor    %eax,%eax
  802dec:	89 fa                	mov    %edi,%edx
  802dee:	83 c4 1c             	add    $0x1c,%esp
  802df1:	5b                   	pop    %ebx
  802df2:	5e                   	pop    %esi
  802df3:	5f                   	pop    %edi
  802df4:	5d                   	pop    %ebp
  802df5:	c3                   	ret    
  802df6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802dfd:	8d 76 00             	lea    0x0(%esi),%esi
  802e00:	89 f9                	mov    %edi,%ecx
  802e02:	b8 20 00 00 00       	mov    $0x20,%eax
  802e07:	29 f8                	sub    %edi,%eax
  802e09:	d3 e2                	shl    %cl,%edx
  802e0b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802e0f:	89 c1                	mov    %eax,%ecx
  802e11:	89 da                	mov    %ebx,%edx
  802e13:	d3 ea                	shr    %cl,%edx
  802e15:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802e19:	09 d1                	or     %edx,%ecx
  802e1b:	89 f2                	mov    %esi,%edx
  802e1d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802e21:	89 f9                	mov    %edi,%ecx
  802e23:	d3 e3                	shl    %cl,%ebx
  802e25:	89 c1                	mov    %eax,%ecx
  802e27:	d3 ea                	shr    %cl,%edx
  802e29:	89 f9                	mov    %edi,%ecx
  802e2b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802e2f:	89 eb                	mov    %ebp,%ebx
  802e31:	d3 e6                	shl    %cl,%esi
  802e33:	89 c1                	mov    %eax,%ecx
  802e35:	d3 eb                	shr    %cl,%ebx
  802e37:	09 de                	or     %ebx,%esi
  802e39:	89 f0                	mov    %esi,%eax
  802e3b:	f7 74 24 08          	divl   0x8(%esp)
  802e3f:	89 d6                	mov    %edx,%esi
  802e41:	89 c3                	mov    %eax,%ebx
  802e43:	f7 64 24 0c          	mull   0xc(%esp)
  802e47:	39 d6                	cmp    %edx,%esi
  802e49:	72 15                	jb     802e60 <__udivdi3+0x100>
  802e4b:	89 f9                	mov    %edi,%ecx
  802e4d:	d3 e5                	shl    %cl,%ebp
  802e4f:	39 c5                	cmp    %eax,%ebp
  802e51:	73 04                	jae    802e57 <__udivdi3+0xf7>
  802e53:	39 d6                	cmp    %edx,%esi
  802e55:	74 09                	je     802e60 <__udivdi3+0x100>
  802e57:	89 d8                	mov    %ebx,%eax
  802e59:	31 ff                	xor    %edi,%edi
  802e5b:	e9 27 ff ff ff       	jmp    802d87 <__udivdi3+0x27>
  802e60:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802e63:	31 ff                	xor    %edi,%edi
  802e65:	e9 1d ff ff ff       	jmp    802d87 <__udivdi3+0x27>
  802e6a:	66 90                	xchg   %ax,%ax
  802e6c:	66 90                	xchg   %ax,%ax
  802e6e:	66 90                	xchg   %ax,%ax

00802e70 <__umoddi3>:
  802e70:	55                   	push   %ebp
  802e71:	57                   	push   %edi
  802e72:	56                   	push   %esi
  802e73:	53                   	push   %ebx
  802e74:	83 ec 1c             	sub    $0x1c,%esp
  802e77:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802e7b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802e7f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802e83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802e87:	89 da                	mov    %ebx,%edx
  802e89:	85 c0                	test   %eax,%eax
  802e8b:	75 43                	jne    802ed0 <__umoddi3+0x60>
  802e8d:	39 df                	cmp    %ebx,%edi
  802e8f:	76 17                	jbe    802ea8 <__umoddi3+0x38>
  802e91:	89 f0                	mov    %esi,%eax
  802e93:	f7 f7                	div    %edi
  802e95:	89 d0                	mov    %edx,%eax
  802e97:	31 d2                	xor    %edx,%edx
  802e99:	83 c4 1c             	add    $0x1c,%esp
  802e9c:	5b                   	pop    %ebx
  802e9d:	5e                   	pop    %esi
  802e9e:	5f                   	pop    %edi
  802e9f:	5d                   	pop    %ebp
  802ea0:	c3                   	ret    
  802ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ea8:	89 fd                	mov    %edi,%ebp
  802eaa:	85 ff                	test   %edi,%edi
  802eac:	75 0b                	jne    802eb9 <__umoddi3+0x49>
  802eae:	b8 01 00 00 00       	mov    $0x1,%eax
  802eb3:	31 d2                	xor    %edx,%edx
  802eb5:	f7 f7                	div    %edi
  802eb7:	89 c5                	mov    %eax,%ebp
  802eb9:	89 d8                	mov    %ebx,%eax
  802ebb:	31 d2                	xor    %edx,%edx
  802ebd:	f7 f5                	div    %ebp
  802ebf:	89 f0                	mov    %esi,%eax
  802ec1:	f7 f5                	div    %ebp
  802ec3:	89 d0                	mov    %edx,%eax
  802ec5:	eb d0                	jmp    802e97 <__umoddi3+0x27>
  802ec7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ece:	66 90                	xchg   %ax,%ax
  802ed0:	89 f1                	mov    %esi,%ecx
  802ed2:	39 d8                	cmp    %ebx,%eax
  802ed4:	76 0a                	jbe    802ee0 <__umoddi3+0x70>
  802ed6:	89 f0                	mov    %esi,%eax
  802ed8:	83 c4 1c             	add    $0x1c,%esp
  802edb:	5b                   	pop    %ebx
  802edc:	5e                   	pop    %esi
  802edd:	5f                   	pop    %edi
  802ede:	5d                   	pop    %ebp
  802edf:	c3                   	ret    
  802ee0:	0f bd e8             	bsr    %eax,%ebp
  802ee3:	83 f5 1f             	xor    $0x1f,%ebp
  802ee6:	75 20                	jne    802f08 <__umoddi3+0x98>
  802ee8:	39 d8                	cmp    %ebx,%eax
  802eea:	0f 82 b0 00 00 00    	jb     802fa0 <__umoddi3+0x130>
  802ef0:	39 f7                	cmp    %esi,%edi
  802ef2:	0f 86 a8 00 00 00    	jbe    802fa0 <__umoddi3+0x130>
  802ef8:	89 c8                	mov    %ecx,%eax
  802efa:	83 c4 1c             	add    $0x1c,%esp
  802efd:	5b                   	pop    %ebx
  802efe:	5e                   	pop    %esi
  802eff:	5f                   	pop    %edi
  802f00:	5d                   	pop    %ebp
  802f01:	c3                   	ret    
  802f02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802f08:	89 e9                	mov    %ebp,%ecx
  802f0a:	ba 20 00 00 00       	mov    $0x20,%edx
  802f0f:	29 ea                	sub    %ebp,%edx
  802f11:	d3 e0                	shl    %cl,%eax
  802f13:	89 44 24 08          	mov    %eax,0x8(%esp)
  802f17:	89 d1                	mov    %edx,%ecx
  802f19:	89 f8                	mov    %edi,%eax
  802f1b:	d3 e8                	shr    %cl,%eax
  802f1d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802f21:	89 54 24 04          	mov    %edx,0x4(%esp)
  802f25:	8b 54 24 04          	mov    0x4(%esp),%edx
  802f29:	09 c1                	or     %eax,%ecx
  802f2b:	89 d8                	mov    %ebx,%eax
  802f2d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802f31:	89 e9                	mov    %ebp,%ecx
  802f33:	d3 e7                	shl    %cl,%edi
  802f35:	89 d1                	mov    %edx,%ecx
  802f37:	d3 e8                	shr    %cl,%eax
  802f39:	89 e9                	mov    %ebp,%ecx
  802f3b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802f3f:	d3 e3                	shl    %cl,%ebx
  802f41:	89 c7                	mov    %eax,%edi
  802f43:	89 d1                	mov    %edx,%ecx
  802f45:	89 f0                	mov    %esi,%eax
  802f47:	d3 e8                	shr    %cl,%eax
  802f49:	89 e9                	mov    %ebp,%ecx
  802f4b:	89 fa                	mov    %edi,%edx
  802f4d:	d3 e6                	shl    %cl,%esi
  802f4f:	09 d8                	or     %ebx,%eax
  802f51:	f7 74 24 08          	divl   0x8(%esp)
  802f55:	89 d1                	mov    %edx,%ecx
  802f57:	89 f3                	mov    %esi,%ebx
  802f59:	f7 64 24 0c          	mull   0xc(%esp)
  802f5d:	89 c6                	mov    %eax,%esi
  802f5f:	89 d7                	mov    %edx,%edi
  802f61:	39 d1                	cmp    %edx,%ecx
  802f63:	72 06                	jb     802f6b <__umoddi3+0xfb>
  802f65:	75 10                	jne    802f77 <__umoddi3+0x107>
  802f67:	39 c3                	cmp    %eax,%ebx
  802f69:	73 0c                	jae    802f77 <__umoddi3+0x107>
  802f6b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802f6f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802f73:	89 d7                	mov    %edx,%edi
  802f75:	89 c6                	mov    %eax,%esi
  802f77:	89 ca                	mov    %ecx,%edx
  802f79:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802f7e:	29 f3                	sub    %esi,%ebx
  802f80:	19 fa                	sbb    %edi,%edx
  802f82:	89 d0                	mov    %edx,%eax
  802f84:	d3 e0                	shl    %cl,%eax
  802f86:	89 e9                	mov    %ebp,%ecx
  802f88:	d3 eb                	shr    %cl,%ebx
  802f8a:	d3 ea                	shr    %cl,%edx
  802f8c:	09 d8                	or     %ebx,%eax
  802f8e:	83 c4 1c             	add    $0x1c,%esp
  802f91:	5b                   	pop    %ebx
  802f92:	5e                   	pop    %esi
  802f93:	5f                   	pop    %edi
  802f94:	5d                   	pop    %ebp
  802f95:	c3                   	ret    
  802f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802f9d:	8d 76 00             	lea    0x0(%esi),%esi
  802fa0:	89 da                	mov    %ebx,%edx
  802fa2:	29 fe                	sub    %edi,%esi
  802fa4:	19 c2                	sbb    %eax,%edx
  802fa6:	89 f1                	mov    %esi,%ecx
  802fa8:	89 c8                	mov    %ecx,%eax
  802faa:	e9 4b ff ff ff       	jmp    802efa <__umoddi3+0x8a>
