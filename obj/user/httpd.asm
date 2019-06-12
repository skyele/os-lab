
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
  80002c:	e8 ed 07 00 00       	call   80081e <libmain>
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
  80003a:	68 8d 32 80 00       	push   $0x80328d
  80003f:	e8 dd 09 00 00       	call   800a21 <cprintf>
	exit();
  800044:	e8 ae 08 00 00       	call   8008f7 <exit>
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
  800080:	68 dc 30 80 00       	push   $0x8030dc
  800085:	68 00 02 00 00       	push   $0x200
  80008a:	8d bd e8 fd ff ff    	lea    -0x218(%ebp),%edi
  800090:	57                   	push   %edi
  800091:	e8 97 10 00 00       	call   80112d <snprintf>
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
  80009f:	e8 78 1b 00 00       	call   801c1c <write>
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
  8000db:	e8 70 1a 00 00       	call   801b50 <read>
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
  8000f2:	e8 cf 11 00 00       	call   8012c6 <memset>

		req->sock = sock;
  8000f7:	89 75 dc             	mov    %esi,-0x24(%ebp)
	if (strncmp(request, "GET ", 4) != 0)
  8000fa:	83 c4 0c             	add    $0xc,%esp
  8000fd:	6a 04                	push   $0x4
  8000ff:	68 fc 2f 80 00       	push   $0x802ffc
  800104:	8d 85 dc fd ff ff    	lea    -0x224(%ebp),%eax
  80010a:	50                   	push   %eax
  80010b:	e8 41 11 00 00       	call   801251 <strncmp>
  800110:	83 c4 10             	add    $0x10,%esp
  800113:	85 c0                	test   %eax,%eax
  800115:	0f 85 24 03 00 00    	jne    80043f <handle_client+0x37f>
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
  800133:	68 23 01 00 00       	push   $0x123
  800138:	68 ef 2f 80 00       	push   $0x802fef
  80013d:	e8 e9 07 00 00       	call   80092b <_panic>
	url_len = request - url;
  800142:	89 df                	mov    %ebx,%edi
  800144:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
  80014a:	29 c7                	sub    %eax,%edi
	req->url = malloc(url_len + 1);
  80014c:	83 ec 0c             	sub    $0xc,%esp
  80014f:	8d 47 01             	lea    0x1(%edi),%eax
  800152:	50                   	push   %eax
  800153:	e8 4e 24 00 00       	call   8025a6 <malloc>
  800158:	89 45 e0             	mov    %eax,-0x20(%ebp)
	memmove(req->url, url, url_len);
  80015b:	83 c4 0c             	add    $0xc,%esp
  80015e:	57                   	push   %edi
  80015f:	8d 8d e0 fd ff ff    	lea    -0x220(%ebp),%ecx
  800165:	51                   	push   %ecx
  800166:	50                   	push   %eax
  800167:	e8 a2 11 00 00       	call   80130e <memmove>
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
  800197:	e8 0a 24 00 00       	call   8025a6 <malloc>
  80019c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	memmove(req->version, version, version_len);
  80019f:	83 c4 0c             	add    $0xc,%esp
  8001a2:	57                   	push   %edi
  8001a3:	53                   	push   %ebx
  8001a4:	50                   	push   %eax
  8001a5:	e8 64 11 00 00       	call   80130e <memmove>
	req->version[version_len] = '\0';
  8001aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ad:	c6 04 38 00          	movb   $0x0,(%eax,%edi,1)
	fd = open(req->url, O_RDONLY);
  8001b1:	83 c4 08             	add    $0x8,%esp
  8001b4:	6a 00                	push   $0x0
  8001b6:	ff 75 e0             	pushl  -0x20(%ebp)
  8001b9:	e8 30 1e 00 00       	call   801fee <open>
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
  8001d2:	e8 6f 1b 00 00       	call   801d46 <fstat>
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
  800221:	e8 ec 17 00 00       	call   801a12 <close>
  800226:	83 c4 10             	add    $0x10,%esp
	free(req->url);
  800229:	83 ec 0c             	sub    $0xc,%esp
  80022c:	ff 75 e0             	pushl  -0x20(%ebp)
  80022f:	e8 c6 22 00 00       	call   8024fa <free>
	free(req->version);
  800234:	83 c4 04             	add    $0x4,%esp
  800237:	ff 75 e4             	pushl  -0x1c(%ebp)
  80023a:	e8 bb 22 00 00       	call   8024fa <free>

		// no keep alive
		break;
	}

	close(sock);
  80023f:	89 34 24             	mov    %esi,(%esp)
  800242:	e8 cb 17 00 00       	call   801a12 <close>
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
  800264:	e8 de 0e 00 00       	call   801147 <strlen>
	if (write(req->sock, h->header, len) != len) {
  800269:	83 c4 0c             	add    $0xc,%esp
  80026c:	89 85 c4 f6 ff ff    	mov    %eax,-0x93c(%ebp)
  800272:	50                   	push   %eax
  800273:	ff 73 04             	pushl  0x4(%ebx)
  800276:	ff 75 dc             	pushl  -0x24(%ebp)
  800279:	e8 9e 19 00 00       	call   801c1c <write>
  80027e:	83 c4 10             	add    $0x10,%esp
  800281:	39 85 c4 f6 ff ff    	cmp    %eax,-0x93c(%ebp)
  800287:	0f 85 4b 01 00 00    	jne    8003d8 <handle_client+0x318>
	r = snprintf(buf, 64, "Content-Length: %ld\r\n", (long)size);
  80028d:	ff b5 c0 f6 ff ff    	pushl  -0x940(%ebp)
  800293:	68 8e 30 80 00       	push   $0x80308e
  800298:	6a 40                	push   $0x40
  80029a:	8d 85 ee f7 ff ff    	lea    -0x812(%ebp),%eax
  8002a0:	50                   	push   %eax
  8002a1:	e8 87 0e 00 00       	call   80112d <snprintf>
  8002a6:	89 c3                	mov    %eax,%ebx
	if (r > 63)
  8002a8:	83 c4 10             	add    $0x10,%esp
  8002ab:	83 f8 3f             	cmp    $0x3f,%eax
  8002ae:	0f 8f 33 01 00 00    	jg     8003e7 <handle_client+0x327>
	if (write(req->sock, buf, r) != r)
  8002b4:	83 ec 04             	sub    $0x4,%esp
  8002b7:	53                   	push   %ebx
  8002b8:	8d 85 ee f7 ff ff    	lea    -0x812(%ebp),%eax
  8002be:	50                   	push   %eax
  8002bf:	ff 75 dc             	pushl  -0x24(%ebp)
  8002c2:	e8 55 19 00 00       	call   801c1c <write>
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
  8002e8:	e8 40 0e 00 00       	call   80112d <snprintf>
  8002ed:	89 c3                	mov    %eax,%ebx
	if (r > 127)
  8002ef:	83 c4 10             	add    $0x10,%esp
  8002f2:	83 f8 7f             	cmp    $0x7f,%eax
  8002f5:	0f 8f 00 01 00 00    	jg     8003fb <handle_client+0x33b>
	if (write(req->sock, buf, r) != r)
  8002fb:	83 ec 04             	sub    $0x4,%esp
  8002fe:	50                   	push   %eax
  8002ff:	8d 85 ee f7 ff ff    	lea    -0x812(%ebp),%eax
  800305:	50                   	push   %eax
  800306:	ff 75 dc             	pushl  -0x24(%ebp)
  800309:	e8 0e 19 00 00       	call   801c1c <write>
	if ((r = send_content_type(req)) < 0)
  80030e:	83 c4 10             	add    $0x10,%esp
  800311:	39 c3                	cmp    %eax,%ebx
  800313:	0f 85 04 ff ff ff    	jne    80021d <handle_client+0x15d>
	int fin_len = strlen(fin);
  800319:	83 ec 0c             	sub    $0xc,%esp
  80031c:	68 a1 30 80 00       	push   $0x8030a1
  800321:	e8 21 0e 00 00       	call   801147 <strlen>
  800326:	89 c3                	mov    %eax,%ebx
	if (write(req->sock, fin, fin_len) != fin_len)
  800328:	83 c4 0c             	add    $0xc,%esp
  80032b:	50                   	push   %eax
  80032c:	68 a1 30 80 00       	push   $0x8030a1
  800331:	ff 75 dc             	pushl  -0x24(%ebp)
  800334:	e8 e3 18 00 00       	call   801c1c <write>
	if ((r = send_header_fin(req)) < 0)
  800339:	83 c4 10             	add    $0x10,%esp
  80033c:	39 c3                	cmp    %eax,%ebx
  80033e:	0f 85 d9 fe ff ff    	jne    80021d <handle_client+0x15d>
  	if ((r = fstat(fd, &stat)) < 0)
  800344:	83 ec 08             	sub    $0x8,%esp
  800347:	8d 85 60 f7 ff ff    	lea    -0x8a0(%ebp),%eax
  80034d:	50                   	push   %eax
  80034e:	57                   	push   %edi
  80034f:	e8 f2 19 00 00       	call   801d46 <fstat>
  800354:	83 c4 10             	add    $0x10,%esp
  800357:	85 c0                	test   %eax,%eax
  800359:	0f 88 b3 00 00 00    	js     800412 <handle_client+0x352>
  	if (stat.st_size > 1518)
  80035f:	81 bd e0 f7 ff ff ee 	cmpl   $0x5ee,-0x820(%ebp)
  800366:	05 00 00 
  800369:	0f 8f b2 00 00 00    	jg     800421 <handle_client+0x361>
  	if ((r = readn(fd, buf, stat.st_size)) != stat.st_size)
  80036f:	83 ec 04             	sub    $0x4,%esp
  800372:	ff b5 e0 f7 ff ff    	pushl  -0x820(%ebp)
  800378:	8d 85 ee f7 ff ff    	lea    -0x812(%ebp),%eax
  80037e:	50                   	push   %eax
  80037f:	57                   	push   %edi
  800380:	e8 52 18 00 00       	call   801bd7 <readn>
  800385:	83 c4 10             	add    $0x10,%esp
  800388:	3b 85 e0 f7 ff ff    	cmp    -0x820(%ebp),%eax
  80038e:	0f 85 9c 00 00 00    	jne    800430 <handle_client+0x370>
	cprintf("the data is %s\n", buf);
  800394:	83 ec 08             	sub    $0x8,%esp
  800397:	8d 9d ee f7 ff ff    	lea    -0x812(%ebp),%ebx
  80039d:	53                   	push   %ebx
  80039e:	68 6b 30 80 00       	push   $0x80306b
  8003a3:	e8 79 06 00 00       	call   800a21 <cprintf>
  	if ((r = write(req->sock, buf, stat.st_size)) != stat.st_size)
  8003a8:	83 c4 0c             	add    $0xc,%esp
  8003ab:	ff b5 e0 f7 ff ff    	pushl  -0x820(%ebp)
  8003b1:	53                   	push   %ebx
  8003b2:	ff 75 dc             	pushl  -0x24(%ebp)
  8003b5:	e8 62 18 00 00       	call   801c1c <write>
  8003ba:	83 c4 10             	add    $0x10,%esp
  8003bd:	3b 85 e0 f7 ff ff    	cmp    -0x820(%ebp),%eax
  8003c3:	0f 84 54 fe ff ff    	je     80021d <handle_client+0x15d>
    	die("not write all data");
  8003c9:	b8 7b 30 80 00       	mov    $0x80307b,%eax
  8003ce:	e8 60 fc ff ff       	call   800033 <die>
  8003d3:	e9 45 fe ff ff       	jmp    80021d <handle_client+0x15d>
		die("Failed to send bytes to client");
  8003d8:	b8 58 31 80 00       	mov    $0x803158,%eax
  8003dd:	e8 51 fc ff ff       	call   800033 <die>
  8003e2:	e9 a6 fe ff ff       	jmp    80028d <handle_client+0x1cd>
		panic("buffer too small!");
  8003e7:	83 ec 04             	sub    $0x4,%esp
  8003ea:	68 01 30 80 00       	push   $0x803001
  8003ef:	6a 68                	push   $0x68
  8003f1:	68 ef 2f 80 00       	push   $0x802fef
  8003f6:	e8 30 05 00 00       	call   80092b <_panic>
		panic("buffer too small!");
  8003fb:	83 ec 04             	sub    $0x4,%esp
  8003fe:	68 01 30 80 00       	push   $0x803001
  800403:	68 84 00 00 00       	push   $0x84
  800408:	68 ef 2f 80 00       	push   $0x802fef
  80040d:	e8 19 05 00 00       	call   80092b <_panic>
  		die("fstat panic");
  800412:	b8 30 30 80 00       	mov    $0x803030,%eax
  800417:	e8 17 fc ff ff       	call   800033 <die>
  80041c:	e9 3e ff ff ff       	jmp    80035f <handle_client+0x29f>
    	die("fd's file size > 1518");
  800421:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  800426:	e8 08 fc ff ff       	call   800033 <die>
  80042b:	e9 3f ff ff ff       	jmp    80036f <handle_client+0x2af>
    	die("just read partitial data");
  800430:	b8 52 30 80 00       	mov    $0x803052,%eax
  800435:	e8 f9 fb ff ff       	call   800033 <die>
  80043a:	e9 55 ff ff ff       	jmp    800394 <handle_client+0x2d4>
			send_error(req, 400);
  80043f:	ba 90 01 00 00       	mov    $0x190,%edx
  800444:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800447:	e8 02 fc ff ff       	call   80004e <send_error>
  80044c:	e9 d8 fd ff ff       	jmp    800229 <handle_client+0x169>

00800451 <umain>:

void
umain(int argc, char **argv)
{
  800451:	55                   	push   %ebp
  800452:	89 e5                	mov    %esp,%ebp
  800454:	57                   	push   %edi
  800455:	56                   	push   %esi
  800456:	53                   	push   %ebx
  800457:	83 ec 40             	sub    $0x40,%esp
	int serversock, clientsock;
	struct sockaddr_in server, client;

	binaryname = "jhttpd";
  80045a:	c7 05 20 40 80 00 a4 	movl   $0x8030a4,0x804020
  800461:	30 80 00 

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  800464:	6a 06                	push   $0x6
  800466:	6a 01                	push   $0x1
  800468:	6a 02                	push   $0x2
  80046a:	e8 0f 1e 00 00       	call   80227e <socket>
  80046f:	89 c6                	mov    %eax,%esi
  800471:	83 c4 10             	add    $0x10,%esp
  800474:	85 c0                	test   %eax,%eax
  800476:	78 6d                	js     8004e5 <umain+0x94>
		die("Failed to create socket");

	// Construct the server sockaddr_in structure
	memset(&server, 0, sizeof(server));		// Clear struct
  800478:	83 ec 04             	sub    $0x4,%esp
  80047b:	6a 10                	push   $0x10
  80047d:	6a 00                	push   $0x0
  80047f:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  800482:	53                   	push   %ebx
  800483:	e8 3e 0e 00 00       	call   8012c6 <memset>
	server.sin_family = AF_INET;			// Internet/IP
  800488:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	server.sin_addr.s_addr = htonl(INADDR_ANY);	// IP address
  80048c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800493:	e8 5c 01 00 00       	call   8005f4 <htonl>
  800498:	89 45 dc             	mov    %eax,-0x24(%ebp)
	server.sin_port = htons(PORT);			// server port
  80049b:	c7 04 24 50 00 00 00 	movl   $0x50,(%esp)
  8004a2:	e8 33 01 00 00       	call   8005da <htons>
  8004a7:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &server,
  8004ab:	83 c4 0c             	add    $0xc,%esp
  8004ae:	6a 10                	push   $0x10
  8004b0:	53                   	push   %ebx
  8004b1:	56                   	push   %esi
  8004b2:	e8 35 1d 00 00       	call   8021ec <bind>
  8004b7:	83 c4 10             	add    $0x10,%esp
  8004ba:	85 c0                	test   %eax,%eax
  8004bc:	78 33                	js     8004f1 <umain+0xa0>
	{
		die("Failed to bind the server socket");
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  8004be:	83 ec 08             	sub    $0x8,%esp
  8004c1:	6a 05                	push   $0x5
  8004c3:	56                   	push   %esi
  8004c4:	e8 92 1d 00 00       	call   80225b <listen>
  8004c9:	83 c4 10             	add    $0x10,%esp
  8004cc:	85 c0                	test   %eax,%eax
  8004ce:	78 2d                	js     8004fd <umain+0xac>
		die("Failed to listen on server socket");

	cprintf("Waiting for http connections...\n");
  8004d0:	83 ec 0c             	sub    $0xc,%esp
  8004d3:	68 c0 31 80 00       	push   $0x8031c0
  8004d8:	e8 44 05 00 00       	call   800a21 <cprintf>
  8004dd:	83 c4 10             	add    $0x10,%esp

	while (1) {
		unsigned int clientlen = sizeof(client);
		// Wait for client connection
		if ((clientsock = accept(serversock,
  8004e0:	8d 7d c4             	lea    -0x3c(%ebp),%edi
  8004e3:	eb 35                	jmp    80051a <umain+0xc9>
		die("Failed to create socket");
  8004e5:	b8 ab 30 80 00       	mov    $0x8030ab,%eax
  8004ea:	e8 44 fb ff ff       	call   800033 <die>
  8004ef:	eb 87                	jmp    800478 <umain+0x27>
		die("Failed to bind the server socket");
  8004f1:	b8 78 31 80 00       	mov    $0x803178,%eax
  8004f6:	e8 38 fb ff ff       	call   800033 <die>
  8004fb:	eb c1                	jmp    8004be <umain+0x6d>
		die("Failed to listen on server socket");
  8004fd:	b8 9c 31 80 00       	mov    $0x80319c,%eax
  800502:	e8 2c fb ff ff       	call   800033 <die>
  800507:	eb c7                	jmp    8004d0 <umain+0x7f>
					 (struct sockaddr *) &client,
					 &clientlen)) < 0)
		{
			die("Failed to accept client connection");
  800509:	b8 e4 31 80 00       	mov    $0x8031e4,%eax
  80050e:	e8 20 fb ff ff       	call   800033 <die>
		}
		handle_client(clientsock);
  800513:	89 d8                	mov    %ebx,%eax
  800515:	e8 a6 fb ff ff       	call   8000c0 <handle_client>
		unsigned int clientlen = sizeof(client);
  80051a:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
		if ((clientsock = accept(serversock,
  800521:	83 ec 04             	sub    $0x4,%esp
  800524:	57                   	push   %edi
  800525:	8d 45 c8             	lea    -0x38(%ebp),%eax
  800528:	50                   	push   %eax
  800529:	56                   	push   %esi
  80052a:	e8 8e 1c 00 00       	call   8021bd <accept>
  80052f:	89 c3                	mov    %eax,%ebx
  800531:	83 c4 10             	add    $0x10,%esp
  800534:	85 c0                	test   %eax,%eax
  800536:	78 d1                	js     800509 <umain+0xb8>
  800538:	eb d9                	jmp    800513 <umain+0xc2>

0080053a <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  80053a:	55                   	push   %ebp
  80053b:	89 e5                	mov    %esp,%ebp
  80053d:	57                   	push   %edi
  80053e:	56                   	push   %esi
  80053f:	53                   	push   %ebx
  800540:	83 ec 18             	sub    $0x18,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  800543:	8b 45 08             	mov    0x8(%ebp),%eax
  800546:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  800549:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  ap = (u8_t *)&s_addr;
  80054d:	8d 75 f0             	lea    -0x10(%ebp),%esi
  rp = str;
  800550:	bf 00 50 80 00       	mov    $0x805000,%edi
  800555:	eb 1a                	jmp    800571 <inet_ntoa+0x37>
  800557:	0f b6 db             	movzbl %bl,%ebx
  80055a:	01 fb                	add    %edi,%ebx
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  80055c:	8d 7b 01             	lea    0x1(%ebx),%edi
  80055f:	c6 03 2e             	movb   $0x2e,(%ebx)
  800562:	83 c6 01             	add    $0x1,%esi
  for(n = 0; n < 4; n++) {
  800565:	80 45 df 01          	addb   $0x1,-0x21(%ebp)
  800569:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  80056d:	3c 04                	cmp    $0x4,%al
  80056f:	74 59                	je     8005ca <inet_ntoa+0x90>
  rp = str;
  800571:	ba 00 00 00 00       	mov    $0x0,%edx
      rem = *ap % (u8_t)10;
  800576:	0f b6 0e             	movzbl (%esi),%ecx
      *ap /= (u8_t)10;
  800579:	0f b6 d9             	movzbl %cl,%ebx
  80057c:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
  80057f:	8d 04 c3             	lea    (%ebx,%eax,8),%eax
  800582:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800585:	66 c1 e8 0b          	shr    $0xb,%ax
  800589:	88 06                	mov    %al,(%esi)
      inv[i++] = '0' + rem;
  80058b:	8d 5a 01             	lea    0x1(%edx),%ebx
  80058e:	0f b6 d2             	movzbl %dl,%edx
  800591:	89 55 e0             	mov    %edx,-0x20(%ebp)
      rem = *ap % (u8_t)10;
  800594:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800597:	01 c0                	add    %eax,%eax
  800599:	89 ca                	mov    %ecx,%edx
  80059b:	29 c2                	sub    %eax,%edx
  80059d:	89 d0                	mov    %edx,%eax
      inv[i++] = '0' + rem;
  80059f:	83 c0 30             	add    $0x30,%eax
  8005a2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005a5:	88 44 15 ed          	mov    %al,-0x13(%ebp,%edx,1)
  8005a9:	89 da                	mov    %ebx,%edx
    } while(*ap);
  8005ab:	80 f9 09             	cmp    $0x9,%cl
  8005ae:	77 c6                	ja     800576 <inet_ntoa+0x3c>
  8005b0:	89 fa                	mov    %edi,%edx
      inv[i++] = '0' + rem;
  8005b2:	89 d8                	mov    %ebx,%eax
    while(i--)
  8005b4:	83 e8 01             	sub    $0x1,%eax
  8005b7:	3c ff                	cmp    $0xff,%al
  8005b9:	74 9c                	je     800557 <inet_ntoa+0x1d>
      *rp++ = inv[i];
  8005bb:	0f b6 c8             	movzbl %al,%ecx
  8005be:	0f b6 4c 0d ed       	movzbl -0x13(%ebp,%ecx,1),%ecx
  8005c3:	88 0a                	mov    %cl,(%edx)
  8005c5:	83 c2 01             	add    $0x1,%edx
  8005c8:	eb ea                	jmp    8005b4 <inet_ntoa+0x7a>
    ap++;
  }
  *--rp = 0;
  8005ca:	c6 03 00             	movb   $0x0,(%ebx)
  return str;
}
  8005cd:	b8 00 50 80 00       	mov    $0x805000,%eax
  8005d2:	83 c4 18             	add    $0x18,%esp
  8005d5:	5b                   	pop    %ebx
  8005d6:	5e                   	pop    %esi
  8005d7:	5f                   	pop    %edi
  8005d8:	5d                   	pop    %ebp
  8005d9:	c3                   	ret    

008005da <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  8005da:	55                   	push   %ebp
  8005db:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8005dd:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8005e1:	66 c1 c0 08          	rol    $0x8,%ax
}
  8005e5:	5d                   	pop    %ebp
  8005e6:	c3                   	ret    

008005e7 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  8005e7:	55                   	push   %ebp
  8005e8:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8005ea:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8005ee:	66 c1 c0 08          	rol    $0x8,%ax
  return htons(n);
}
  8005f2:	5d                   	pop    %ebp
  8005f3:	c3                   	ret    

008005f4 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8005f4:	55                   	push   %ebp
  8005f5:	89 e5                	mov    %esp,%ebp
  8005f7:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
  8005fa:	89 d0                	mov    %edx,%eax
  8005fc:	c1 e0 18             	shl    $0x18,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  8005ff:	89 d1                	mov    %edx,%ecx
  800601:	c1 e9 18             	shr    $0x18,%ecx
    ((n & 0xff0000UL) >> 8) |
  800604:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  800606:	89 d1                	mov    %edx,%ecx
  800608:	c1 e1 08             	shl    $0x8,%ecx
  80060b:	81 e1 00 00 ff 00    	and    $0xff0000,%ecx
    ((n & 0xff0000UL) >> 8) |
  800611:	09 c8                	or     %ecx,%eax
  800613:	c1 ea 08             	shr    $0x8,%edx
  800616:	81 e2 00 ff 00 00    	and    $0xff00,%edx
  80061c:	09 d0                	or     %edx,%eax
}
  80061e:	5d                   	pop    %ebp
  80061f:	c3                   	ret    

00800620 <inet_aton>:
{
  800620:	55                   	push   %ebp
  800621:	89 e5                	mov    %esp,%ebp
  800623:	57                   	push   %edi
  800624:	56                   	push   %esi
  800625:	53                   	push   %ebx
  800626:	83 ec 2c             	sub    $0x2c,%esp
  800629:	8b 45 08             	mov    0x8(%ebp),%eax
  c = *cp;
  80062c:	0f be 10             	movsbl (%eax),%edx
  u32_t *pp = parts;
  80062f:	8d 75 d8             	lea    -0x28(%ebp),%esi
  800632:	89 75 cc             	mov    %esi,-0x34(%ebp)
  800635:	e9 a7 00 00 00       	jmp    8006e1 <inet_aton+0xc1>
      c = *++cp;
  80063a:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      if (c == 'x' || c == 'X') {
  80063e:	89 d1                	mov    %edx,%ecx
  800640:	83 e1 df             	and    $0xffffffdf,%ecx
  800643:	80 f9 58             	cmp    $0x58,%cl
  800646:	74 10                	je     800658 <inet_aton+0x38>
      c = *++cp;
  800648:	83 c0 01             	add    $0x1,%eax
  80064b:	0f be d2             	movsbl %dl,%edx
        base = 8;
  80064e:	be 08 00 00 00       	mov    $0x8,%esi
  800653:	e9 a3 00 00 00       	jmp    8006fb <inet_aton+0xdb>
        c = *++cp;
  800658:	0f be 50 02          	movsbl 0x2(%eax),%edx
  80065c:	8d 40 02             	lea    0x2(%eax),%eax
        base = 16;
  80065f:	be 10 00 00 00       	mov    $0x10,%esi
  800664:	e9 92 00 00 00       	jmp    8006fb <inet_aton+0xdb>
      } else if (base == 16 && isxdigit(c)) {
  800669:	83 fe 10             	cmp    $0x10,%esi
  80066c:	75 4d                	jne    8006bb <inet_aton+0x9b>
  80066e:	8d 4f 9f             	lea    -0x61(%edi),%ecx
  800671:	88 4d d3             	mov    %cl,-0x2d(%ebp)
  800674:	89 d1                	mov    %edx,%ecx
  800676:	83 e1 df             	and    $0xffffffdf,%ecx
  800679:	83 e9 41             	sub    $0x41,%ecx
  80067c:	80 f9 05             	cmp    $0x5,%cl
  80067f:	77 3a                	ja     8006bb <inet_aton+0x9b>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  800681:	c1 e3 04             	shl    $0x4,%ebx
  800684:	83 c2 0a             	add    $0xa,%edx
  800687:	80 7d d3 1a          	cmpb   $0x1a,-0x2d(%ebp)
  80068b:	19 c9                	sbb    %ecx,%ecx
  80068d:	83 e1 20             	and    $0x20,%ecx
  800690:	83 c1 41             	add    $0x41,%ecx
  800693:	29 ca                	sub    %ecx,%edx
  800695:	09 d3                	or     %edx,%ebx
        c = *++cp;
  800697:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80069a:	0f be 57 01          	movsbl 0x1(%edi),%edx
  80069e:	83 c0 01             	add    $0x1,%eax
  8006a1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
      if (isdigit(c)) {
  8006a4:	89 d7                	mov    %edx,%edi
  8006a6:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8006a9:	80 f9 09             	cmp    $0x9,%cl
  8006ac:	77 bb                	ja     800669 <inet_aton+0x49>
        val = (val * base) + (int)(c - '0');
  8006ae:	0f af de             	imul   %esi,%ebx
  8006b1:	8d 5c 1a d0          	lea    -0x30(%edx,%ebx,1),%ebx
        c = *++cp;
  8006b5:	0f be 50 01          	movsbl 0x1(%eax),%edx
  8006b9:	eb e3                	jmp    80069e <inet_aton+0x7e>
    if (c == '.') {
  8006bb:	83 fa 2e             	cmp    $0x2e,%edx
  8006be:	75 42                	jne    800702 <inet_aton+0xe2>
      if (pp >= parts + 3)
  8006c0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8006c3:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8006c6:	39 c6                	cmp    %eax,%esi
  8006c8:	0f 84 0e 01 00 00    	je     8007dc <inet_aton+0x1bc>
      *pp++ = val;
  8006ce:	83 c6 04             	add    $0x4,%esi
  8006d1:	89 75 cc             	mov    %esi,-0x34(%ebp)
  8006d4:	89 5e fc             	mov    %ebx,-0x4(%esi)
      c = *++cp;
  8006d7:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  8006da:	8d 46 01             	lea    0x1(%esi),%eax
  8006dd:	0f be 56 01          	movsbl 0x1(%esi),%edx
    if (!isdigit(c))
  8006e1:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8006e4:	80 f9 09             	cmp    $0x9,%cl
  8006e7:	0f 87 e8 00 00 00    	ja     8007d5 <inet_aton+0x1b5>
    base = 10;
  8006ed:	be 0a 00 00 00       	mov    $0xa,%esi
    if (c == '0') {
  8006f2:	83 fa 30             	cmp    $0x30,%edx
  8006f5:	0f 84 3f ff ff ff    	je     80063a <inet_aton+0x1a>
    base = 10;
  8006fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800700:	eb 9f                	jmp    8006a1 <inet_aton+0x81>
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  800702:	85 d2                	test   %edx,%edx
  800704:	74 26                	je     80072c <inet_aton+0x10c>
    return (0);
  800706:	b8 00 00 00 00       	mov    $0x0,%eax
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  80070b:	89 f9                	mov    %edi,%ecx
  80070d:	80 f9 1f             	cmp    $0x1f,%cl
  800710:	0f 86 cb 00 00 00    	jbe    8007e1 <inet_aton+0x1c1>
  800716:	84 d2                	test   %dl,%dl
  800718:	0f 88 c3 00 00 00    	js     8007e1 <inet_aton+0x1c1>
  80071e:	83 fa 20             	cmp    $0x20,%edx
  800721:	74 09                	je     80072c <inet_aton+0x10c>
  800723:	83 fa 0c             	cmp    $0xc,%edx
  800726:	0f 85 b5 00 00 00    	jne    8007e1 <inet_aton+0x1c1>
  n = pp - parts + 1;
  80072c:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80072f:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800732:	29 c6                	sub    %eax,%esi
  800734:	89 f0                	mov    %esi,%eax
  800736:	c1 f8 02             	sar    $0x2,%eax
  800739:	83 c0 01             	add    $0x1,%eax
  switch (n) {
  80073c:	83 f8 02             	cmp    $0x2,%eax
  80073f:	74 5e                	je     80079f <inet_aton+0x17f>
  800741:	7e 35                	jle    800778 <inet_aton+0x158>
  800743:	83 f8 03             	cmp    $0x3,%eax
  800746:	74 6e                	je     8007b6 <inet_aton+0x196>
  800748:	83 f8 04             	cmp    $0x4,%eax
  80074b:	75 2f                	jne    80077c <inet_aton+0x15c>
      return (0);
  80074d:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xff)
  800752:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
  800758:	0f 87 83 00 00 00    	ja     8007e1 <inet_aton+0x1c1>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  80075e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800761:	c1 e0 18             	shl    $0x18,%eax
  800764:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800767:	c1 e2 10             	shl    $0x10,%edx
  80076a:	09 d0                	or     %edx,%eax
  80076c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80076f:	c1 e2 08             	shl    $0x8,%edx
  800772:	09 d0                	or     %edx,%eax
  800774:	09 c3                	or     %eax,%ebx
    break;
  800776:	eb 04                	jmp    80077c <inet_aton+0x15c>
  switch (n) {
  800778:	85 c0                	test   %eax,%eax
  80077a:	74 65                	je     8007e1 <inet_aton+0x1c1>
  return (1);
  80077c:	b8 01 00 00 00       	mov    $0x1,%eax
  if (addr)
  800781:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800785:	74 5a                	je     8007e1 <inet_aton+0x1c1>
    addr->s_addr = htonl(val);
  800787:	83 ec 0c             	sub    $0xc,%esp
  80078a:	53                   	push   %ebx
  80078b:	e8 64 fe ff ff       	call   8005f4 <htonl>
  800790:	83 c4 10             	add    $0x10,%esp
  800793:	8b 75 0c             	mov    0xc(%ebp),%esi
  800796:	89 06                	mov    %eax,(%esi)
  return (1);
  800798:	b8 01 00 00 00       	mov    $0x1,%eax
  80079d:	eb 42                	jmp    8007e1 <inet_aton+0x1c1>
      return (0);
  80079f:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffffffUL)
  8007a4:	81 fb ff ff ff 00    	cmp    $0xffffff,%ebx
  8007aa:	77 35                	ja     8007e1 <inet_aton+0x1c1>
    val |= parts[0] << 24;
  8007ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007af:	c1 e0 18             	shl    $0x18,%eax
  8007b2:	09 c3                	or     %eax,%ebx
    break;
  8007b4:	eb c6                	jmp    80077c <inet_aton+0x15c>
      return (0);
  8007b6:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffff)
  8007bb:	81 fb ff ff 00 00    	cmp    $0xffff,%ebx
  8007c1:	77 1e                	ja     8007e1 <inet_aton+0x1c1>
    val |= (parts[0] << 24) | (parts[1] << 16);
  8007c3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007c6:	c1 e0 18             	shl    $0x18,%eax
  8007c9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8007cc:	c1 e2 10             	shl    $0x10,%edx
  8007cf:	09 d0                	or     %edx,%eax
  8007d1:	09 c3                	or     %eax,%ebx
    break;
  8007d3:	eb a7                	jmp    80077c <inet_aton+0x15c>
      return (0);
  8007d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8007da:	eb 05                	jmp    8007e1 <inet_aton+0x1c1>
        return (0);
  8007dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007e4:	5b                   	pop    %ebx
  8007e5:	5e                   	pop    %esi
  8007e6:	5f                   	pop    %edi
  8007e7:	5d                   	pop    %ebp
  8007e8:	c3                   	ret    

008007e9 <inet_addr>:
{
  8007e9:	55                   	push   %ebp
  8007ea:	89 e5                	mov    %esp,%ebp
  8007ec:	83 ec 20             	sub    $0x20,%esp
  if (inet_aton(cp, &val)) {
  8007ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007f2:	50                   	push   %eax
  8007f3:	ff 75 08             	pushl  0x8(%ebp)
  8007f6:	e8 25 fe ff ff       	call   800620 <inet_aton>
  8007fb:	83 c4 10             	add    $0x10,%esp
    return (val.s_addr);
  8007fe:	85 c0                	test   %eax,%eax
  800800:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800805:	0f 45 45 f4          	cmovne -0xc(%ebp),%eax
}
  800809:	c9                   	leave  
  80080a:	c3                   	ret    

0080080b <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  80080b:	55                   	push   %ebp
  80080c:	89 e5                	mov    %esp,%ebp
  80080e:	83 ec 14             	sub    $0x14,%esp
  return htonl(n);
  800811:	ff 75 08             	pushl  0x8(%ebp)
  800814:	e8 db fd ff ff       	call   8005f4 <htonl>
  800819:	83 c4 10             	add    $0x10,%esp
}
  80081c:	c9                   	leave  
  80081d:	c3                   	ret    

0080081e <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  80081e:	55                   	push   %ebp
  80081f:	89 e5                	mov    %esp,%ebp
  800821:	57                   	push   %edi
  800822:	56                   	push   %esi
  800823:	53                   	push   %ebx
  800824:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  800827:	c7 05 1c 50 80 00 00 	movl   $0x0,0x80501c
  80082e:	00 00 00 
	envid_t find = sys_getenvid();
  800831:	e8 fe 0c 00 00       	call   801534 <sys_getenvid>
  800836:	8b 1d 1c 50 80 00    	mov    0x80501c,%ebx
  80083c:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800841:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  800846:	bf 01 00 00 00       	mov    $0x1,%edi
  80084b:	eb 0b                	jmp    800858 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  80084d:	83 c2 01             	add    $0x1,%edx
  800850:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800856:	74 21                	je     800879 <libmain+0x5b>
		if(envs[i].env_id == find)
  800858:	89 d1                	mov    %edx,%ecx
  80085a:	c1 e1 07             	shl    $0x7,%ecx
  80085d:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800863:	8b 49 48             	mov    0x48(%ecx),%ecx
  800866:	39 c1                	cmp    %eax,%ecx
  800868:	75 e3                	jne    80084d <libmain+0x2f>
  80086a:	89 d3                	mov    %edx,%ebx
  80086c:	c1 e3 07             	shl    $0x7,%ebx
  80086f:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800875:	89 fe                	mov    %edi,%esi
  800877:	eb d4                	jmp    80084d <libmain+0x2f>
  800879:	89 f0                	mov    %esi,%eax
  80087b:	84 c0                	test   %al,%al
  80087d:	74 06                	je     800885 <libmain+0x67>
  80087f:	89 1d 1c 50 80 00    	mov    %ebx,0x80501c
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800885:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800889:	7e 0a                	jle    800895 <libmain+0x77>
		binaryname = argv[0];
  80088b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80088e:	8b 00                	mov    (%eax),%eax
  800890:	a3 20 40 80 00       	mov    %eax,0x804020

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  800895:	a1 1c 50 80 00       	mov    0x80501c,%eax
  80089a:	8b 40 48             	mov    0x48(%eax),%eax
  80089d:	83 ec 08             	sub    $0x8,%esp
  8008a0:	50                   	push   %eax
  8008a1:	68 2e 32 80 00       	push   $0x80322e
  8008a6:	e8 76 01 00 00       	call   800a21 <cprintf>
	cprintf("before umain\n");
  8008ab:	c7 04 24 4c 32 80 00 	movl   $0x80324c,(%esp)
  8008b2:	e8 6a 01 00 00       	call   800a21 <cprintf>
	// call user main routine
	umain(argc, argv);
  8008b7:	83 c4 08             	add    $0x8,%esp
  8008ba:	ff 75 0c             	pushl  0xc(%ebp)
  8008bd:	ff 75 08             	pushl  0x8(%ebp)
  8008c0:	e8 8c fb ff ff       	call   800451 <umain>
	cprintf("after umain\n");
  8008c5:	c7 04 24 5a 32 80 00 	movl   $0x80325a,(%esp)
  8008cc:	e8 50 01 00 00       	call   800a21 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8008d1:	a1 1c 50 80 00       	mov    0x80501c,%eax
  8008d6:	8b 40 48             	mov    0x48(%eax),%eax
  8008d9:	83 c4 08             	add    $0x8,%esp
  8008dc:	50                   	push   %eax
  8008dd:	68 67 32 80 00       	push   $0x803267
  8008e2:	e8 3a 01 00 00       	call   800a21 <cprintf>
	// exit gracefully
	exit();
  8008e7:	e8 0b 00 00 00       	call   8008f7 <exit>
}
  8008ec:	83 c4 10             	add    $0x10,%esp
  8008ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008f2:	5b                   	pop    %ebx
  8008f3:	5e                   	pop    %esi
  8008f4:	5f                   	pop    %edi
  8008f5:	5d                   	pop    %ebp
  8008f6:	c3                   	ret    

008008f7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8008f7:	55                   	push   %ebp
  8008f8:	89 e5                	mov    %esp,%ebp
  8008fa:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8008fd:	a1 1c 50 80 00       	mov    0x80501c,%eax
  800902:	8b 40 48             	mov    0x48(%eax),%eax
  800905:	68 94 32 80 00       	push   $0x803294
  80090a:	50                   	push   %eax
  80090b:	68 86 32 80 00       	push   $0x803286
  800910:	e8 0c 01 00 00       	call   800a21 <cprintf>
	close_all();
  800915:	e8 25 11 00 00       	call   801a3f <close_all>
	sys_env_destroy(0);
  80091a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800921:	e8 cd 0b 00 00       	call   8014f3 <sys_env_destroy>
}
  800926:	83 c4 10             	add    $0x10,%esp
  800929:	c9                   	leave  
  80092a:	c3                   	ret    

0080092b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80092b:	55                   	push   %ebp
  80092c:	89 e5                	mov    %esp,%ebp
  80092e:	56                   	push   %esi
  80092f:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800930:	a1 1c 50 80 00       	mov    0x80501c,%eax
  800935:	8b 40 48             	mov    0x48(%eax),%eax
  800938:	83 ec 04             	sub    $0x4,%esp
  80093b:	68 c0 32 80 00       	push   $0x8032c0
  800940:	50                   	push   %eax
  800941:	68 86 32 80 00       	push   $0x803286
  800946:	e8 d6 00 00 00       	call   800a21 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80094b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80094e:	8b 35 20 40 80 00    	mov    0x804020,%esi
  800954:	e8 db 0b 00 00       	call   801534 <sys_getenvid>
  800959:	83 c4 04             	add    $0x4,%esp
  80095c:	ff 75 0c             	pushl  0xc(%ebp)
  80095f:	ff 75 08             	pushl  0x8(%ebp)
  800962:	56                   	push   %esi
  800963:	50                   	push   %eax
  800964:	68 9c 32 80 00       	push   $0x80329c
  800969:	e8 b3 00 00 00       	call   800a21 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80096e:	83 c4 18             	add    $0x18,%esp
  800971:	53                   	push   %ebx
  800972:	ff 75 10             	pushl  0x10(%ebp)
  800975:	e8 56 00 00 00       	call   8009d0 <vcprintf>
	cprintf("\n");
  80097a:	c7 04 24 a2 30 80 00 	movl   $0x8030a2,(%esp)
  800981:	e8 9b 00 00 00       	call   800a21 <cprintf>
  800986:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800989:	cc                   	int3   
  80098a:	eb fd                	jmp    800989 <_panic+0x5e>

0080098c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	53                   	push   %ebx
  800990:	83 ec 04             	sub    $0x4,%esp
  800993:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800996:	8b 13                	mov    (%ebx),%edx
  800998:	8d 42 01             	lea    0x1(%edx),%eax
  80099b:	89 03                	mov    %eax,(%ebx)
  80099d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009a0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8009a4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009a9:	74 09                	je     8009b4 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8009ab:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8009af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009b2:	c9                   	leave  
  8009b3:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8009b4:	83 ec 08             	sub    $0x8,%esp
  8009b7:	68 ff 00 00 00       	push   $0xff
  8009bc:	8d 43 08             	lea    0x8(%ebx),%eax
  8009bf:	50                   	push   %eax
  8009c0:	e8 f1 0a 00 00       	call   8014b6 <sys_cputs>
		b->idx = 0;
  8009c5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8009cb:	83 c4 10             	add    $0x10,%esp
  8009ce:	eb db                	jmp    8009ab <putch+0x1f>

008009d0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8009d0:	55                   	push   %ebp
  8009d1:	89 e5                	mov    %esp,%ebp
  8009d3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009d9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009e0:	00 00 00 
	b.cnt = 0;
  8009e3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009ea:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8009ed:	ff 75 0c             	pushl  0xc(%ebp)
  8009f0:	ff 75 08             	pushl  0x8(%ebp)
  8009f3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009f9:	50                   	push   %eax
  8009fa:	68 8c 09 80 00       	push   $0x80098c
  8009ff:	e8 4a 01 00 00       	call   800b4e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800a04:	83 c4 08             	add    $0x8,%esp
  800a07:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800a0d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800a13:	50                   	push   %eax
  800a14:	e8 9d 0a 00 00       	call   8014b6 <sys_cputs>

	return b.cnt;
}
  800a19:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800a1f:	c9                   	leave  
  800a20:	c3                   	ret    

00800a21 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800a21:	55                   	push   %ebp
  800a22:	89 e5                	mov    %esp,%ebp
  800a24:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a27:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800a2a:	50                   	push   %eax
  800a2b:	ff 75 08             	pushl  0x8(%ebp)
  800a2e:	e8 9d ff ff ff       	call   8009d0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800a33:	c9                   	leave  
  800a34:	c3                   	ret    

00800a35 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a35:	55                   	push   %ebp
  800a36:	89 e5                	mov    %esp,%ebp
  800a38:	57                   	push   %edi
  800a39:	56                   	push   %esi
  800a3a:	53                   	push   %ebx
  800a3b:	83 ec 1c             	sub    $0x1c,%esp
  800a3e:	89 c6                	mov    %eax,%esi
  800a40:	89 d7                	mov    %edx,%edi
  800a42:	8b 45 08             	mov    0x8(%ebp),%eax
  800a45:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a48:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a4b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800a4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a51:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800a54:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800a58:	74 2c                	je     800a86 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800a5a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a5d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800a64:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a67:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800a6a:	39 c2                	cmp    %eax,%edx
  800a6c:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800a6f:	73 43                	jae    800ab4 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800a71:	83 eb 01             	sub    $0x1,%ebx
  800a74:	85 db                	test   %ebx,%ebx
  800a76:	7e 6c                	jle    800ae4 <printnum+0xaf>
				putch(padc, putdat);
  800a78:	83 ec 08             	sub    $0x8,%esp
  800a7b:	57                   	push   %edi
  800a7c:	ff 75 18             	pushl  0x18(%ebp)
  800a7f:	ff d6                	call   *%esi
  800a81:	83 c4 10             	add    $0x10,%esp
  800a84:	eb eb                	jmp    800a71 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800a86:	83 ec 0c             	sub    $0xc,%esp
  800a89:	6a 20                	push   $0x20
  800a8b:	6a 00                	push   $0x0
  800a8d:	50                   	push   %eax
  800a8e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a91:	ff 75 e0             	pushl  -0x20(%ebp)
  800a94:	89 fa                	mov    %edi,%edx
  800a96:	89 f0                	mov    %esi,%eax
  800a98:	e8 98 ff ff ff       	call   800a35 <printnum>
		while (--width > 0)
  800a9d:	83 c4 20             	add    $0x20,%esp
  800aa0:	83 eb 01             	sub    $0x1,%ebx
  800aa3:	85 db                	test   %ebx,%ebx
  800aa5:	7e 65                	jle    800b0c <printnum+0xd7>
			putch(padc, putdat);
  800aa7:	83 ec 08             	sub    $0x8,%esp
  800aaa:	57                   	push   %edi
  800aab:	6a 20                	push   $0x20
  800aad:	ff d6                	call   *%esi
  800aaf:	83 c4 10             	add    $0x10,%esp
  800ab2:	eb ec                	jmp    800aa0 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800ab4:	83 ec 0c             	sub    $0xc,%esp
  800ab7:	ff 75 18             	pushl  0x18(%ebp)
  800aba:	83 eb 01             	sub    $0x1,%ebx
  800abd:	53                   	push   %ebx
  800abe:	50                   	push   %eax
  800abf:	83 ec 08             	sub    $0x8,%esp
  800ac2:	ff 75 dc             	pushl  -0x24(%ebp)
  800ac5:	ff 75 d8             	pushl  -0x28(%ebp)
  800ac8:	ff 75 e4             	pushl  -0x1c(%ebp)
  800acb:	ff 75 e0             	pushl  -0x20(%ebp)
  800ace:	e8 bd 22 00 00       	call   802d90 <__udivdi3>
  800ad3:	83 c4 18             	add    $0x18,%esp
  800ad6:	52                   	push   %edx
  800ad7:	50                   	push   %eax
  800ad8:	89 fa                	mov    %edi,%edx
  800ada:	89 f0                	mov    %esi,%eax
  800adc:	e8 54 ff ff ff       	call   800a35 <printnum>
  800ae1:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800ae4:	83 ec 08             	sub    $0x8,%esp
  800ae7:	57                   	push   %edi
  800ae8:	83 ec 04             	sub    $0x4,%esp
  800aeb:	ff 75 dc             	pushl  -0x24(%ebp)
  800aee:	ff 75 d8             	pushl  -0x28(%ebp)
  800af1:	ff 75 e4             	pushl  -0x1c(%ebp)
  800af4:	ff 75 e0             	pushl  -0x20(%ebp)
  800af7:	e8 a4 23 00 00       	call   802ea0 <__umoddi3>
  800afc:	83 c4 14             	add    $0x14,%esp
  800aff:	0f be 80 c7 32 80 00 	movsbl 0x8032c7(%eax),%eax
  800b06:	50                   	push   %eax
  800b07:	ff d6                	call   *%esi
  800b09:	83 c4 10             	add    $0x10,%esp
	}
}
  800b0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b0f:	5b                   	pop    %ebx
  800b10:	5e                   	pop    %esi
  800b11:	5f                   	pop    %edi
  800b12:	5d                   	pop    %ebp
  800b13:	c3                   	ret    

00800b14 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
  800b17:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800b1a:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800b1e:	8b 10                	mov    (%eax),%edx
  800b20:	3b 50 04             	cmp    0x4(%eax),%edx
  800b23:	73 0a                	jae    800b2f <sprintputch+0x1b>
		*b->buf++ = ch;
  800b25:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b28:	89 08                	mov    %ecx,(%eax)
  800b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2d:	88 02                	mov    %al,(%edx)
}
  800b2f:	5d                   	pop    %ebp
  800b30:	c3                   	ret    

00800b31 <printfmt>:
{
  800b31:	55                   	push   %ebp
  800b32:	89 e5                	mov    %esp,%ebp
  800b34:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800b37:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800b3a:	50                   	push   %eax
  800b3b:	ff 75 10             	pushl  0x10(%ebp)
  800b3e:	ff 75 0c             	pushl  0xc(%ebp)
  800b41:	ff 75 08             	pushl  0x8(%ebp)
  800b44:	e8 05 00 00 00       	call   800b4e <vprintfmt>
}
  800b49:	83 c4 10             	add    $0x10,%esp
  800b4c:	c9                   	leave  
  800b4d:	c3                   	ret    

00800b4e <vprintfmt>:
{
  800b4e:	55                   	push   %ebp
  800b4f:	89 e5                	mov    %esp,%ebp
  800b51:	57                   	push   %edi
  800b52:	56                   	push   %esi
  800b53:	53                   	push   %ebx
  800b54:	83 ec 3c             	sub    $0x3c,%esp
  800b57:	8b 75 08             	mov    0x8(%ebp),%esi
  800b5a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b5d:	8b 7d 10             	mov    0x10(%ebp),%edi
  800b60:	e9 32 04 00 00       	jmp    800f97 <vprintfmt+0x449>
		padc = ' ';
  800b65:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800b69:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800b70:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800b77:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800b7e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b85:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800b8c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800b91:	8d 47 01             	lea    0x1(%edi),%eax
  800b94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b97:	0f b6 17             	movzbl (%edi),%edx
  800b9a:	8d 42 dd             	lea    -0x23(%edx),%eax
  800b9d:	3c 55                	cmp    $0x55,%al
  800b9f:	0f 87 12 05 00 00    	ja     8010b7 <vprintfmt+0x569>
  800ba5:	0f b6 c0             	movzbl %al,%eax
  800ba8:	ff 24 85 a0 34 80 00 	jmp    *0x8034a0(,%eax,4)
  800baf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800bb2:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800bb6:	eb d9                	jmp    800b91 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800bb8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800bbb:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800bbf:	eb d0                	jmp    800b91 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800bc1:	0f b6 d2             	movzbl %dl,%edx
  800bc4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800bc7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bcc:	89 75 08             	mov    %esi,0x8(%ebp)
  800bcf:	eb 03                	jmp    800bd4 <vprintfmt+0x86>
  800bd1:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800bd4:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800bd7:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800bdb:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800bde:	8d 72 d0             	lea    -0x30(%edx),%esi
  800be1:	83 fe 09             	cmp    $0x9,%esi
  800be4:	76 eb                	jbe    800bd1 <vprintfmt+0x83>
  800be6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800be9:	8b 75 08             	mov    0x8(%ebp),%esi
  800bec:	eb 14                	jmp    800c02 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800bee:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf1:	8b 00                	mov    (%eax),%eax
  800bf3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bf6:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf9:	8d 40 04             	lea    0x4(%eax),%eax
  800bfc:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800bff:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800c02:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c06:	79 89                	jns    800b91 <vprintfmt+0x43>
				width = precision, precision = -1;
  800c08:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c0b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800c0e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800c15:	e9 77 ff ff ff       	jmp    800b91 <vprintfmt+0x43>
  800c1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c1d:	85 c0                	test   %eax,%eax
  800c1f:	0f 48 c1             	cmovs  %ecx,%eax
  800c22:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800c25:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800c28:	e9 64 ff ff ff       	jmp    800b91 <vprintfmt+0x43>
  800c2d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800c30:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800c37:	e9 55 ff ff ff       	jmp    800b91 <vprintfmt+0x43>
			lflag++;
  800c3c:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800c40:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800c43:	e9 49 ff ff ff       	jmp    800b91 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800c48:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4b:	8d 78 04             	lea    0x4(%eax),%edi
  800c4e:	83 ec 08             	sub    $0x8,%esp
  800c51:	53                   	push   %ebx
  800c52:	ff 30                	pushl  (%eax)
  800c54:	ff d6                	call   *%esi
			break;
  800c56:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800c59:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800c5c:	e9 33 03 00 00       	jmp    800f94 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800c61:	8b 45 14             	mov    0x14(%ebp),%eax
  800c64:	8d 78 04             	lea    0x4(%eax),%edi
  800c67:	8b 00                	mov    (%eax),%eax
  800c69:	99                   	cltd   
  800c6a:	31 d0                	xor    %edx,%eax
  800c6c:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800c6e:	83 f8 11             	cmp    $0x11,%eax
  800c71:	7f 23                	jg     800c96 <vprintfmt+0x148>
  800c73:	8b 14 85 00 36 80 00 	mov    0x803600(,%eax,4),%edx
  800c7a:	85 d2                	test   %edx,%edx
  800c7c:	74 18                	je     800c96 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800c7e:	52                   	push   %edx
  800c7f:	68 1d 37 80 00       	push   $0x80371d
  800c84:	53                   	push   %ebx
  800c85:	56                   	push   %esi
  800c86:	e8 a6 fe ff ff       	call   800b31 <printfmt>
  800c8b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800c8e:	89 7d 14             	mov    %edi,0x14(%ebp)
  800c91:	e9 fe 02 00 00       	jmp    800f94 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800c96:	50                   	push   %eax
  800c97:	68 df 32 80 00       	push   $0x8032df
  800c9c:	53                   	push   %ebx
  800c9d:	56                   	push   %esi
  800c9e:	e8 8e fe ff ff       	call   800b31 <printfmt>
  800ca3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800ca6:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800ca9:	e9 e6 02 00 00       	jmp    800f94 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800cae:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb1:	83 c0 04             	add    $0x4,%eax
  800cb4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800cb7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cba:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800cbc:	85 c9                	test   %ecx,%ecx
  800cbe:	b8 d8 32 80 00       	mov    $0x8032d8,%eax
  800cc3:	0f 45 c1             	cmovne %ecx,%eax
  800cc6:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800cc9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ccd:	7e 06                	jle    800cd5 <vprintfmt+0x187>
  800ccf:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800cd3:	75 0d                	jne    800ce2 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cd5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800cd8:	89 c7                	mov    %eax,%edi
  800cda:	03 45 e0             	add    -0x20(%ebp),%eax
  800cdd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800ce0:	eb 53                	jmp    800d35 <vprintfmt+0x1e7>
  800ce2:	83 ec 08             	sub    $0x8,%esp
  800ce5:	ff 75 d8             	pushl  -0x28(%ebp)
  800ce8:	50                   	push   %eax
  800ce9:	e8 71 04 00 00       	call   80115f <strnlen>
  800cee:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800cf1:	29 c1                	sub    %eax,%ecx
  800cf3:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800cf6:	83 c4 10             	add    $0x10,%esp
  800cf9:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800cfb:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800cff:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800d02:	eb 0f                	jmp    800d13 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800d04:	83 ec 08             	sub    $0x8,%esp
  800d07:	53                   	push   %ebx
  800d08:	ff 75 e0             	pushl  -0x20(%ebp)
  800d0b:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800d0d:	83 ef 01             	sub    $0x1,%edi
  800d10:	83 c4 10             	add    $0x10,%esp
  800d13:	85 ff                	test   %edi,%edi
  800d15:	7f ed                	jg     800d04 <vprintfmt+0x1b6>
  800d17:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800d1a:	85 c9                	test   %ecx,%ecx
  800d1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d21:	0f 49 c1             	cmovns %ecx,%eax
  800d24:	29 c1                	sub    %eax,%ecx
  800d26:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800d29:	eb aa                	jmp    800cd5 <vprintfmt+0x187>
					putch(ch, putdat);
  800d2b:	83 ec 08             	sub    $0x8,%esp
  800d2e:	53                   	push   %ebx
  800d2f:	52                   	push   %edx
  800d30:	ff d6                	call   *%esi
  800d32:	83 c4 10             	add    $0x10,%esp
  800d35:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800d38:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d3a:	83 c7 01             	add    $0x1,%edi
  800d3d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800d41:	0f be d0             	movsbl %al,%edx
  800d44:	85 d2                	test   %edx,%edx
  800d46:	74 4b                	je     800d93 <vprintfmt+0x245>
  800d48:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800d4c:	78 06                	js     800d54 <vprintfmt+0x206>
  800d4e:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800d52:	78 1e                	js     800d72 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800d54:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800d58:	74 d1                	je     800d2b <vprintfmt+0x1dd>
  800d5a:	0f be c0             	movsbl %al,%eax
  800d5d:	83 e8 20             	sub    $0x20,%eax
  800d60:	83 f8 5e             	cmp    $0x5e,%eax
  800d63:	76 c6                	jbe    800d2b <vprintfmt+0x1dd>
					putch('?', putdat);
  800d65:	83 ec 08             	sub    $0x8,%esp
  800d68:	53                   	push   %ebx
  800d69:	6a 3f                	push   $0x3f
  800d6b:	ff d6                	call   *%esi
  800d6d:	83 c4 10             	add    $0x10,%esp
  800d70:	eb c3                	jmp    800d35 <vprintfmt+0x1e7>
  800d72:	89 cf                	mov    %ecx,%edi
  800d74:	eb 0e                	jmp    800d84 <vprintfmt+0x236>
				putch(' ', putdat);
  800d76:	83 ec 08             	sub    $0x8,%esp
  800d79:	53                   	push   %ebx
  800d7a:	6a 20                	push   $0x20
  800d7c:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800d7e:	83 ef 01             	sub    $0x1,%edi
  800d81:	83 c4 10             	add    $0x10,%esp
  800d84:	85 ff                	test   %edi,%edi
  800d86:	7f ee                	jg     800d76 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800d88:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800d8b:	89 45 14             	mov    %eax,0x14(%ebp)
  800d8e:	e9 01 02 00 00       	jmp    800f94 <vprintfmt+0x446>
  800d93:	89 cf                	mov    %ecx,%edi
  800d95:	eb ed                	jmp    800d84 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800d97:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800d9a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800da1:	e9 eb fd ff ff       	jmp    800b91 <vprintfmt+0x43>
	if (lflag >= 2)
  800da6:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800daa:	7f 21                	jg     800dcd <vprintfmt+0x27f>
	else if (lflag)
  800dac:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800db0:	74 68                	je     800e1a <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800db2:	8b 45 14             	mov    0x14(%ebp),%eax
  800db5:	8b 00                	mov    (%eax),%eax
  800db7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800dba:	89 c1                	mov    %eax,%ecx
  800dbc:	c1 f9 1f             	sar    $0x1f,%ecx
  800dbf:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800dc2:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc5:	8d 40 04             	lea    0x4(%eax),%eax
  800dc8:	89 45 14             	mov    %eax,0x14(%ebp)
  800dcb:	eb 17                	jmp    800de4 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800dcd:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd0:	8b 50 04             	mov    0x4(%eax),%edx
  800dd3:	8b 00                	mov    (%eax),%eax
  800dd5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800dd8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800ddb:	8b 45 14             	mov    0x14(%ebp),%eax
  800dde:	8d 40 08             	lea    0x8(%eax),%eax
  800de1:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800de4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800de7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800dea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ded:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800df0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800df4:	78 3f                	js     800e35 <vprintfmt+0x2e7>
			base = 10;
  800df6:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800dfb:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800dff:	0f 84 71 01 00 00    	je     800f76 <vprintfmt+0x428>
				putch('+', putdat);
  800e05:	83 ec 08             	sub    $0x8,%esp
  800e08:	53                   	push   %ebx
  800e09:	6a 2b                	push   $0x2b
  800e0b:	ff d6                	call   *%esi
  800e0d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800e10:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e15:	e9 5c 01 00 00       	jmp    800f76 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800e1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e1d:	8b 00                	mov    (%eax),%eax
  800e1f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800e22:	89 c1                	mov    %eax,%ecx
  800e24:	c1 f9 1f             	sar    $0x1f,%ecx
  800e27:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800e2a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e2d:	8d 40 04             	lea    0x4(%eax),%eax
  800e30:	89 45 14             	mov    %eax,0x14(%ebp)
  800e33:	eb af                	jmp    800de4 <vprintfmt+0x296>
				putch('-', putdat);
  800e35:	83 ec 08             	sub    $0x8,%esp
  800e38:	53                   	push   %ebx
  800e39:	6a 2d                	push   $0x2d
  800e3b:	ff d6                	call   *%esi
				num = -(long long) num;
  800e3d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e40:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800e43:	f7 d8                	neg    %eax
  800e45:	83 d2 00             	adc    $0x0,%edx
  800e48:	f7 da                	neg    %edx
  800e4a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e4d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800e50:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800e53:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e58:	e9 19 01 00 00       	jmp    800f76 <vprintfmt+0x428>
	if (lflag >= 2)
  800e5d:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800e61:	7f 29                	jg     800e8c <vprintfmt+0x33e>
	else if (lflag)
  800e63:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800e67:	74 44                	je     800ead <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800e69:	8b 45 14             	mov    0x14(%ebp),%eax
  800e6c:	8b 00                	mov    (%eax),%eax
  800e6e:	ba 00 00 00 00       	mov    $0x0,%edx
  800e73:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e76:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800e79:	8b 45 14             	mov    0x14(%ebp),%eax
  800e7c:	8d 40 04             	lea    0x4(%eax),%eax
  800e7f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800e82:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e87:	e9 ea 00 00 00       	jmp    800f76 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800e8c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e8f:	8b 50 04             	mov    0x4(%eax),%edx
  800e92:	8b 00                	mov    (%eax),%eax
  800e94:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e97:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800e9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9d:	8d 40 08             	lea    0x8(%eax),%eax
  800ea0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800ea3:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ea8:	e9 c9 00 00 00       	jmp    800f76 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800ead:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb0:	8b 00                	mov    (%eax),%eax
  800eb2:	ba 00 00 00 00       	mov    $0x0,%edx
  800eb7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800eba:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ebd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec0:	8d 40 04             	lea    0x4(%eax),%eax
  800ec3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800ec6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ecb:	e9 a6 00 00 00       	jmp    800f76 <vprintfmt+0x428>
			putch('0', putdat);
  800ed0:	83 ec 08             	sub    $0x8,%esp
  800ed3:	53                   	push   %ebx
  800ed4:	6a 30                	push   $0x30
  800ed6:	ff d6                	call   *%esi
	if (lflag >= 2)
  800ed8:	83 c4 10             	add    $0x10,%esp
  800edb:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800edf:	7f 26                	jg     800f07 <vprintfmt+0x3b9>
	else if (lflag)
  800ee1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800ee5:	74 3e                	je     800f25 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800ee7:	8b 45 14             	mov    0x14(%ebp),%eax
  800eea:	8b 00                	mov    (%eax),%eax
  800eec:	ba 00 00 00 00       	mov    $0x0,%edx
  800ef1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ef4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ef7:	8b 45 14             	mov    0x14(%ebp),%eax
  800efa:	8d 40 04             	lea    0x4(%eax),%eax
  800efd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800f00:	b8 08 00 00 00       	mov    $0x8,%eax
  800f05:	eb 6f                	jmp    800f76 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800f07:	8b 45 14             	mov    0x14(%ebp),%eax
  800f0a:	8b 50 04             	mov    0x4(%eax),%edx
  800f0d:	8b 00                	mov    (%eax),%eax
  800f0f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f12:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f15:	8b 45 14             	mov    0x14(%ebp),%eax
  800f18:	8d 40 08             	lea    0x8(%eax),%eax
  800f1b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800f1e:	b8 08 00 00 00       	mov    $0x8,%eax
  800f23:	eb 51                	jmp    800f76 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800f25:	8b 45 14             	mov    0x14(%ebp),%eax
  800f28:	8b 00                	mov    (%eax),%eax
  800f2a:	ba 00 00 00 00       	mov    $0x0,%edx
  800f2f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f32:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f35:	8b 45 14             	mov    0x14(%ebp),%eax
  800f38:	8d 40 04             	lea    0x4(%eax),%eax
  800f3b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800f3e:	b8 08 00 00 00       	mov    $0x8,%eax
  800f43:	eb 31                	jmp    800f76 <vprintfmt+0x428>
			putch('0', putdat);
  800f45:	83 ec 08             	sub    $0x8,%esp
  800f48:	53                   	push   %ebx
  800f49:	6a 30                	push   $0x30
  800f4b:	ff d6                	call   *%esi
			putch('x', putdat);
  800f4d:	83 c4 08             	add    $0x8,%esp
  800f50:	53                   	push   %ebx
  800f51:	6a 78                	push   $0x78
  800f53:	ff d6                	call   *%esi
			num = (unsigned long long)
  800f55:	8b 45 14             	mov    0x14(%ebp),%eax
  800f58:	8b 00                	mov    (%eax),%eax
  800f5a:	ba 00 00 00 00       	mov    $0x0,%edx
  800f5f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f62:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800f65:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800f68:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6b:	8d 40 04             	lea    0x4(%eax),%eax
  800f6e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800f71:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800f76:	83 ec 0c             	sub    $0xc,%esp
  800f79:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800f7d:	52                   	push   %edx
  800f7e:	ff 75 e0             	pushl  -0x20(%ebp)
  800f81:	50                   	push   %eax
  800f82:	ff 75 dc             	pushl  -0x24(%ebp)
  800f85:	ff 75 d8             	pushl  -0x28(%ebp)
  800f88:	89 da                	mov    %ebx,%edx
  800f8a:	89 f0                	mov    %esi,%eax
  800f8c:	e8 a4 fa ff ff       	call   800a35 <printnum>
			break;
  800f91:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800f94:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f97:	83 c7 01             	add    $0x1,%edi
  800f9a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800f9e:	83 f8 25             	cmp    $0x25,%eax
  800fa1:	0f 84 be fb ff ff    	je     800b65 <vprintfmt+0x17>
			if (ch == '\0')
  800fa7:	85 c0                	test   %eax,%eax
  800fa9:	0f 84 28 01 00 00    	je     8010d7 <vprintfmt+0x589>
			putch(ch, putdat);
  800faf:	83 ec 08             	sub    $0x8,%esp
  800fb2:	53                   	push   %ebx
  800fb3:	50                   	push   %eax
  800fb4:	ff d6                	call   *%esi
  800fb6:	83 c4 10             	add    $0x10,%esp
  800fb9:	eb dc                	jmp    800f97 <vprintfmt+0x449>
	if (lflag >= 2)
  800fbb:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800fbf:	7f 26                	jg     800fe7 <vprintfmt+0x499>
	else if (lflag)
  800fc1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800fc5:	74 41                	je     801008 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800fc7:	8b 45 14             	mov    0x14(%ebp),%eax
  800fca:	8b 00                	mov    (%eax),%eax
  800fcc:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800fd4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800fd7:	8b 45 14             	mov    0x14(%ebp),%eax
  800fda:	8d 40 04             	lea    0x4(%eax),%eax
  800fdd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800fe0:	b8 10 00 00 00       	mov    $0x10,%eax
  800fe5:	eb 8f                	jmp    800f76 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800fe7:	8b 45 14             	mov    0x14(%ebp),%eax
  800fea:	8b 50 04             	mov    0x4(%eax),%edx
  800fed:	8b 00                	mov    (%eax),%eax
  800fef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ff2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ff5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff8:	8d 40 08             	lea    0x8(%eax),%eax
  800ffb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ffe:	b8 10 00 00 00       	mov    $0x10,%eax
  801003:	e9 6e ff ff ff       	jmp    800f76 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  801008:	8b 45 14             	mov    0x14(%ebp),%eax
  80100b:	8b 00                	mov    (%eax),%eax
  80100d:	ba 00 00 00 00       	mov    $0x0,%edx
  801012:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801015:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801018:	8b 45 14             	mov    0x14(%ebp),%eax
  80101b:	8d 40 04             	lea    0x4(%eax),%eax
  80101e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801021:	b8 10 00 00 00       	mov    $0x10,%eax
  801026:	e9 4b ff ff ff       	jmp    800f76 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80102b:	8b 45 14             	mov    0x14(%ebp),%eax
  80102e:	83 c0 04             	add    $0x4,%eax
  801031:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801034:	8b 45 14             	mov    0x14(%ebp),%eax
  801037:	8b 00                	mov    (%eax),%eax
  801039:	85 c0                	test   %eax,%eax
  80103b:	74 14                	je     801051 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80103d:	8b 13                	mov    (%ebx),%edx
  80103f:	83 fa 7f             	cmp    $0x7f,%edx
  801042:	7f 37                	jg     80107b <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  801044:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  801046:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801049:	89 45 14             	mov    %eax,0x14(%ebp)
  80104c:	e9 43 ff ff ff       	jmp    800f94 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  801051:	b8 0a 00 00 00       	mov    $0xa,%eax
  801056:	bf fd 33 80 00       	mov    $0x8033fd,%edi
							putch(ch, putdat);
  80105b:	83 ec 08             	sub    $0x8,%esp
  80105e:	53                   	push   %ebx
  80105f:	50                   	push   %eax
  801060:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  801062:	83 c7 01             	add    $0x1,%edi
  801065:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  801069:	83 c4 10             	add    $0x10,%esp
  80106c:	85 c0                	test   %eax,%eax
  80106e:	75 eb                	jne    80105b <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  801070:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801073:	89 45 14             	mov    %eax,0x14(%ebp)
  801076:	e9 19 ff ff ff       	jmp    800f94 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80107b:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80107d:	b8 0a 00 00 00       	mov    $0xa,%eax
  801082:	bf 35 34 80 00       	mov    $0x803435,%edi
							putch(ch, putdat);
  801087:	83 ec 08             	sub    $0x8,%esp
  80108a:	53                   	push   %ebx
  80108b:	50                   	push   %eax
  80108c:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80108e:	83 c7 01             	add    $0x1,%edi
  801091:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  801095:	83 c4 10             	add    $0x10,%esp
  801098:	85 c0                	test   %eax,%eax
  80109a:	75 eb                	jne    801087 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80109c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80109f:	89 45 14             	mov    %eax,0x14(%ebp)
  8010a2:	e9 ed fe ff ff       	jmp    800f94 <vprintfmt+0x446>
			putch(ch, putdat);
  8010a7:	83 ec 08             	sub    $0x8,%esp
  8010aa:	53                   	push   %ebx
  8010ab:	6a 25                	push   $0x25
  8010ad:	ff d6                	call   *%esi
			break;
  8010af:	83 c4 10             	add    $0x10,%esp
  8010b2:	e9 dd fe ff ff       	jmp    800f94 <vprintfmt+0x446>
			putch('%', putdat);
  8010b7:	83 ec 08             	sub    $0x8,%esp
  8010ba:	53                   	push   %ebx
  8010bb:	6a 25                	push   $0x25
  8010bd:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010bf:	83 c4 10             	add    $0x10,%esp
  8010c2:	89 f8                	mov    %edi,%eax
  8010c4:	eb 03                	jmp    8010c9 <vprintfmt+0x57b>
  8010c6:	83 e8 01             	sub    $0x1,%eax
  8010c9:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8010cd:	75 f7                	jne    8010c6 <vprintfmt+0x578>
  8010cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8010d2:	e9 bd fe ff ff       	jmp    800f94 <vprintfmt+0x446>
}
  8010d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010da:	5b                   	pop    %ebx
  8010db:	5e                   	pop    %esi
  8010dc:	5f                   	pop    %edi
  8010dd:	5d                   	pop    %ebp
  8010de:	c3                   	ret    

008010df <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010df:	55                   	push   %ebp
  8010e0:	89 e5                	mov    %esp,%ebp
  8010e2:	83 ec 18             	sub    $0x18,%esp
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e8:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010ee:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8010f2:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8010f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010fc:	85 c0                	test   %eax,%eax
  8010fe:	74 26                	je     801126 <vsnprintf+0x47>
  801100:	85 d2                	test   %edx,%edx
  801102:	7e 22                	jle    801126 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801104:	ff 75 14             	pushl  0x14(%ebp)
  801107:	ff 75 10             	pushl  0x10(%ebp)
  80110a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80110d:	50                   	push   %eax
  80110e:	68 14 0b 80 00       	push   $0x800b14
  801113:	e8 36 fa ff ff       	call   800b4e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801118:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80111b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80111e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801121:	83 c4 10             	add    $0x10,%esp
}
  801124:	c9                   	leave  
  801125:	c3                   	ret    
		return -E_INVAL;
  801126:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80112b:	eb f7                	jmp    801124 <vsnprintf+0x45>

0080112d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80112d:	55                   	push   %ebp
  80112e:	89 e5                	mov    %esp,%ebp
  801130:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801133:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801136:	50                   	push   %eax
  801137:	ff 75 10             	pushl  0x10(%ebp)
  80113a:	ff 75 0c             	pushl  0xc(%ebp)
  80113d:	ff 75 08             	pushl  0x8(%ebp)
  801140:	e8 9a ff ff ff       	call   8010df <vsnprintf>
	va_end(ap);

	return rc;
}
  801145:	c9                   	leave  
  801146:	c3                   	ret    

00801147 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801147:	55                   	push   %ebp
  801148:	89 e5                	mov    %esp,%ebp
  80114a:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80114d:	b8 00 00 00 00       	mov    $0x0,%eax
  801152:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801156:	74 05                	je     80115d <strlen+0x16>
		n++;
  801158:	83 c0 01             	add    $0x1,%eax
  80115b:	eb f5                	jmp    801152 <strlen+0xb>
	return n;
}
  80115d:	5d                   	pop    %ebp
  80115e:	c3                   	ret    

0080115f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80115f:	55                   	push   %ebp
  801160:	89 e5                	mov    %esp,%ebp
  801162:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801165:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801168:	ba 00 00 00 00       	mov    $0x0,%edx
  80116d:	39 c2                	cmp    %eax,%edx
  80116f:	74 0d                	je     80117e <strnlen+0x1f>
  801171:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  801175:	74 05                	je     80117c <strnlen+0x1d>
		n++;
  801177:	83 c2 01             	add    $0x1,%edx
  80117a:	eb f1                	jmp    80116d <strnlen+0xe>
  80117c:	89 d0                	mov    %edx,%eax
	return n;
}
  80117e:	5d                   	pop    %ebp
  80117f:	c3                   	ret    

00801180 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801180:	55                   	push   %ebp
  801181:	89 e5                	mov    %esp,%ebp
  801183:	53                   	push   %ebx
  801184:	8b 45 08             	mov    0x8(%ebp),%eax
  801187:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80118a:	ba 00 00 00 00       	mov    $0x0,%edx
  80118f:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  801193:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  801196:	83 c2 01             	add    $0x1,%edx
  801199:	84 c9                	test   %cl,%cl
  80119b:	75 f2                	jne    80118f <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80119d:	5b                   	pop    %ebx
  80119e:	5d                   	pop    %ebp
  80119f:	c3                   	ret    

008011a0 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8011a0:	55                   	push   %ebp
  8011a1:	89 e5                	mov    %esp,%ebp
  8011a3:	53                   	push   %ebx
  8011a4:	83 ec 10             	sub    $0x10,%esp
  8011a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8011aa:	53                   	push   %ebx
  8011ab:	e8 97 ff ff ff       	call   801147 <strlen>
  8011b0:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8011b3:	ff 75 0c             	pushl  0xc(%ebp)
  8011b6:	01 d8                	add    %ebx,%eax
  8011b8:	50                   	push   %eax
  8011b9:	e8 c2 ff ff ff       	call   801180 <strcpy>
	return dst;
}
  8011be:	89 d8                	mov    %ebx,%eax
  8011c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011c3:	c9                   	leave  
  8011c4:	c3                   	ret    

008011c5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8011c5:	55                   	push   %ebp
  8011c6:	89 e5                	mov    %esp,%ebp
  8011c8:	56                   	push   %esi
  8011c9:	53                   	push   %ebx
  8011ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011d0:	89 c6                	mov    %eax,%esi
  8011d2:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011d5:	89 c2                	mov    %eax,%edx
  8011d7:	39 f2                	cmp    %esi,%edx
  8011d9:	74 11                	je     8011ec <strncpy+0x27>
		*dst++ = *src;
  8011db:	83 c2 01             	add    $0x1,%edx
  8011de:	0f b6 19             	movzbl (%ecx),%ebx
  8011e1:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8011e4:	80 fb 01             	cmp    $0x1,%bl
  8011e7:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8011ea:	eb eb                	jmp    8011d7 <strncpy+0x12>
	}
	return ret;
}
  8011ec:	5b                   	pop    %ebx
  8011ed:	5e                   	pop    %esi
  8011ee:	5d                   	pop    %ebp
  8011ef:	c3                   	ret    

008011f0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8011f0:	55                   	push   %ebp
  8011f1:	89 e5                	mov    %esp,%ebp
  8011f3:	56                   	push   %esi
  8011f4:	53                   	push   %ebx
  8011f5:	8b 75 08             	mov    0x8(%ebp),%esi
  8011f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011fb:	8b 55 10             	mov    0x10(%ebp),%edx
  8011fe:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801200:	85 d2                	test   %edx,%edx
  801202:	74 21                	je     801225 <strlcpy+0x35>
  801204:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801208:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80120a:	39 c2                	cmp    %eax,%edx
  80120c:	74 14                	je     801222 <strlcpy+0x32>
  80120e:	0f b6 19             	movzbl (%ecx),%ebx
  801211:	84 db                	test   %bl,%bl
  801213:	74 0b                	je     801220 <strlcpy+0x30>
			*dst++ = *src++;
  801215:	83 c1 01             	add    $0x1,%ecx
  801218:	83 c2 01             	add    $0x1,%edx
  80121b:	88 5a ff             	mov    %bl,-0x1(%edx)
  80121e:	eb ea                	jmp    80120a <strlcpy+0x1a>
  801220:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801222:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801225:	29 f0                	sub    %esi,%eax
}
  801227:	5b                   	pop    %ebx
  801228:	5e                   	pop    %esi
  801229:	5d                   	pop    %ebp
  80122a:	c3                   	ret    

0080122b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80122b:	55                   	push   %ebp
  80122c:	89 e5                	mov    %esp,%ebp
  80122e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801231:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801234:	0f b6 01             	movzbl (%ecx),%eax
  801237:	84 c0                	test   %al,%al
  801239:	74 0c                	je     801247 <strcmp+0x1c>
  80123b:	3a 02                	cmp    (%edx),%al
  80123d:	75 08                	jne    801247 <strcmp+0x1c>
		p++, q++;
  80123f:	83 c1 01             	add    $0x1,%ecx
  801242:	83 c2 01             	add    $0x1,%edx
  801245:	eb ed                	jmp    801234 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801247:	0f b6 c0             	movzbl %al,%eax
  80124a:	0f b6 12             	movzbl (%edx),%edx
  80124d:	29 d0                	sub    %edx,%eax
}
  80124f:	5d                   	pop    %ebp
  801250:	c3                   	ret    

00801251 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801251:	55                   	push   %ebp
  801252:	89 e5                	mov    %esp,%ebp
  801254:	53                   	push   %ebx
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	8b 55 0c             	mov    0xc(%ebp),%edx
  80125b:	89 c3                	mov    %eax,%ebx
  80125d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801260:	eb 06                	jmp    801268 <strncmp+0x17>
		n--, p++, q++;
  801262:	83 c0 01             	add    $0x1,%eax
  801265:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801268:	39 d8                	cmp    %ebx,%eax
  80126a:	74 16                	je     801282 <strncmp+0x31>
  80126c:	0f b6 08             	movzbl (%eax),%ecx
  80126f:	84 c9                	test   %cl,%cl
  801271:	74 04                	je     801277 <strncmp+0x26>
  801273:	3a 0a                	cmp    (%edx),%cl
  801275:	74 eb                	je     801262 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801277:	0f b6 00             	movzbl (%eax),%eax
  80127a:	0f b6 12             	movzbl (%edx),%edx
  80127d:	29 d0                	sub    %edx,%eax
}
  80127f:	5b                   	pop    %ebx
  801280:	5d                   	pop    %ebp
  801281:	c3                   	ret    
		return 0;
  801282:	b8 00 00 00 00       	mov    $0x0,%eax
  801287:	eb f6                	jmp    80127f <strncmp+0x2e>

00801289 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801289:	55                   	push   %ebp
  80128a:	89 e5                	mov    %esp,%ebp
  80128c:	8b 45 08             	mov    0x8(%ebp),%eax
  80128f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801293:	0f b6 10             	movzbl (%eax),%edx
  801296:	84 d2                	test   %dl,%dl
  801298:	74 09                	je     8012a3 <strchr+0x1a>
		if (*s == c)
  80129a:	38 ca                	cmp    %cl,%dl
  80129c:	74 0a                	je     8012a8 <strchr+0x1f>
	for (; *s; s++)
  80129e:	83 c0 01             	add    $0x1,%eax
  8012a1:	eb f0                	jmp    801293 <strchr+0xa>
			return (char *) s;
	return 0;
  8012a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012a8:	5d                   	pop    %ebp
  8012a9:	c3                   	ret    

008012aa <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012aa:	55                   	push   %ebp
  8012ab:	89 e5                	mov    %esp,%ebp
  8012ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8012b4:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8012b7:	38 ca                	cmp    %cl,%dl
  8012b9:	74 09                	je     8012c4 <strfind+0x1a>
  8012bb:	84 d2                	test   %dl,%dl
  8012bd:	74 05                	je     8012c4 <strfind+0x1a>
	for (; *s; s++)
  8012bf:	83 c0 01             	add    $0x1,%eax
  8012c2:	eb f0                	jmp    8012b4 <strfind+0xa>
			break;
	return (char *) s;
}
  8012c4:	5d                   	pop    %ebp
  8012c5:	c3                   	ret    

008012c6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012c6:	55                   	push   %ebp
  8012c7:	89 e5                	mov    %esp,%ebp
  8012c9:	57                   	push   %edi
  8012ca:	56                   	push   %esi
  8012cb:	53                   	push   %ebx
  8012cc:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8012d2:	85 c9                	test   %ecx,%ecx
  8012d4:	74 31                	je     801307 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8012d6:	89 f8                	mov    %edi,%eax
  8012d8:	09 c8                	or     %ecx,%eax
  8012da:	a8 03                	test   $0x3,%al
  8012dc:	75 23                	jne    801301 <memset+0x3b>
		c &= 0xFF;
  8012de:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8012e2:	89 d3                	mov    %edx,%ebx
  8012e4:	c1 e3 08             	shl    $0x8,%ebx
  8012e7:	89 d0                	mov    %edx,%eax
  8012e9:	c1 e0 18             	shl    $0x18,%eax
  8012ec:	89 d6                	mov    %edx,%esi
  8012ee:	c1 e6 10             	shl    $0x10,%esi
  8012f1:	09 f0                	or     %esi,%eax
  8012f3:	09 c2                	or     %eax,%edx
  8012f5:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8012f7:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8012fa:	89 d0                	mov    %edx,%eax
  8012fc:	fc                   	cld    
  8012fd:	f3 ab                	rep stos %eax,%es:(%edi)
  8012ff:	eb 06                	jmp    801307 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801301:	8b 45 0c             	mov    0xc(%ebp),%eax
  801304:	fc                   	cld    
  801305:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801307:	89 f8                	mov    %edi,%eax
  801309:	5b                   	pop    %ebx
  80130a:	5e                   	pop    %esi
  80130b:	5f                   	pop    %edi
  80130c:	5d                   	pop    %ebp
  80130d:	c3                   	ret    

0080130e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80130e:	55                   	push   %ebp
  80130f:	89 e5                	mov    %esp,%ebp
  801311:	57                   	push   %edi
  801312:	56                   	push   %esi
  801313:	8b 45 08             	mov    0x8(%ebp),%eax
  801316:	8b 75 0c             	mov    0xc(%ebp),%esi
  801319:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80131c:	39 c6                	cmp    %eax,%esi
  80131e:	73 32                	jae    801352 <memmove+0x44>
  801320:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801323:	39 c2                	cmp    %eax,%edx
  801325:	76 2b                	jbe    801352 <memmove+0x44>
		s += n;
		d += n;
  801327:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80132a:	89 fe                	mov    %edi,%esi
  80132c:	09 ce                	or     %ecx,%esi
  80132e:	09 d6                	or     %edx,%esi
  801330:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801336:	75 0e                	jne    801346 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801338:	83 ef 04             	sub    $0x4,%edi
  80133b:	8d 72 fc             	lea    -0x4(%edx),%esi
  80133e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801341:	fd                   	std    
  801342:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801344:	eb 09                	jmp    80134f <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801346:	83 ef 01             	sub    $0x1,%edi
  801349:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80134c:	fd                   	std    
  80134d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80134f:	fc                   	cld    
  801350:	eb 1a                	jmp    80136c <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801352:	89 c2                	mov    %eax,%edx
  801354:	09 ca                	or     %ecx,%edx
  801356:	09 f2                	or     %esi,%edx
  801358:	f6 c2 03             	test   $0x3,%dl
  80135b:	75 0a                	jne    801367 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80135d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801360:	89 c7                	mov    %eax,%edi
  801362:	fc                   	cld    
  801363:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801365:	eb 05                	jmp    80136c <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  801367:	89 c7                	mov    %eax,%edi
  801369:	fc                   	cld    
  80136a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80136c:	5e                   	pop    %esi
  80136d:	5f                   	pop    %edi
  80136e:	5d                   	pop    %ebp
  80136f:	c3                   	ret    

00801370 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
  801373:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801376:	ff 75 10             	pushl  0x10(%ebp)
  801379:	ff 75 0c             	pushl  0xc(%ebp)
  80137c:	ff 75 08             	pushl  0x8(%ebp)
  80137f:	e8 8a ff ff ff       	call   80130e <memmove>
}
  801384:	c9                   	leave  
  801385:	c3                   	ret    

00801386 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
  801389:	56                   	push   %esi
  80138a:	53                   	push   %ebx
  80138b:	8b 45 08             	mov    0x8(%ebp),%eax
  80138e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801391:	89 c6                	mov    %eax,%esi
  801393:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801396:	39 f0                	cmp    %esi,%eax
  801398:	74 1c                	je     8013b6 <memcmp+0x30>
		if (*s1 != *s2)
  80139a:	0f b6 08             	movzbl (%eax),%ecx
  80139d:	0f b6 1a             	movzbl (%edx),%ebx
  8013a0:	38 d9                	cmp    %bl,%cl
  8013a2:	75 08                	jne    8013ac <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8013a4:	83 c0 01             	add    $0x1,%eax
  8013a7:	83 c2 01             	add    $0x1,%edx
  8013aa:	eb ea                	jmp    801396 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8013ac:	0f b6 c1             	movzbl %cl,%eax
  8013af:	0f b6 db             	movzbl %bl,%ebx
  8013b2:	29 d8                	sub    %ebx,%eax
  8013b4:	eb 05                	jmp    8013bb <memcmp+0x35>
	}

	return 0;
  8013b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013bb:	5b                   	pop    %ebx
  8013bc:	5e                   	pop    %esi
  8013bd:	5d                   	pop    %ebp
  8013be:	c3                   	ret    

008013bf <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8013bf:	55                   	push   %ebp
  8013c0:	89 e5                	mov    %esp,%ebp
  8013c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8013c8:	89 c2                	mov    %eax,%edx
  8013ca:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8013cd:	39 d0                	cmp    %edx,%eax
  8013cf:	73 09                	jae    8013da <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013d1:	38 08                	cmp    %cl,(%eax)
  8013d3:	74 05                	je     8013da <memfind+0x1b>
	for (; s < ends; s++)
  8013d5:	83 c0 01             	add    $0x1,%eax
  8013d8:	eb f3                	jmp    8013cd <memfind+0xe>
			break;
	return (void *) s;
}
  8013da:	5d                   	pop    %ebp
  8013db:	c3                   	ret    

008013dc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013dc:	55                   	push   %ebp
  8013dd:	89 e5                	mov    %esp,%ebp
  8013df:	57                   	push   %edi
  8013e0:	56                   	push   %esi
  8013e1:	53                   	push   %ebx
  8013e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013e5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013e8:	eb 03                	jmp    8013ed <strtol+0x11>
		s++;
  8013ea:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8013ed:	0f b6 01             	movzbl (%ecx),%eax
  8013f0:	3c 20                	cmp    $0x20,%al
  8013f2:	74 f6                	je     8013ea <strtol+0xe>
  8013f4:	3c 09                	cmp    $0x9,%al
  8013f6:	74 f2                	je     8013ea <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8013f8:	3c 2b                	cmp    $0x2b,%al
  8013fa:	74 2a                	je     801426 <strtol+0x4a>
	int neg = 0;
  8013fc:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801401:	3c 2d                	cmp    $0x2d,%al
  801403:	74 2b                	je     801430 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801405:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  80140b:	75 0f                	jne    80141c <strtol+0x40>
  80140d:	80 39 30             	cmpb   $0x30,(%ecx)
  801410:	74 28                	je     80143a <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801412:	85 db                	test   %ebx,%ebx
  801414:	b8 0a 00 00 00       	mov    $0xa,%eax
  801419:	0f 44 d8             	cmove  %eax,%ebx
  80141c:	b8 00 00 00 00       	mov    $0x0,%eax
  801421:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801424:	eb 50                	jmp    801476 <strtol+0x9a>
		s++;
  801426:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801429:	bf 00 00 00 00       	mov    $0x0,%edi
  80142e:	eb d5                	jmp    801405 <strtol+0x29>
		s++, neg = 1;
  801430:	83 c1 01             	add    $0x1,%ecx
  801433:	bf 01 00 00 00       	mov    $0x1,%edi
  801438:	eb cb                	jmp    801405 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80143a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80143e:	74 0e                	je     80144e <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  801440:	85 db                	test   %ebx,%ebx
  801442:	75 d8                	jne    80141c <strtol+0x40>
		s++, base = 8;
  801444:	83 c1 01             	add    $0x1,%ecx
  801447:	bb 08 00 00 00       	mov    $0x8,%ebx
  80144c:	eb ce                	jmp    80141c <strtol+0x40>
		s += 2, base = 16;
  80144e:	83 c1 02             	add    $0x2,%ecx
  801451:	bb 10 00 00 00       	mov    $0x10,%ebx
  801456:	eb c4                	jmp    80141c <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801458:	8d 72 9f             	lea    -0x61(%edx),%esi
  80145b:	89 f3                	mov    %esi,%ebx
  80145d:	80 fb 19             	cmp    $0x19,%bl
  801460:	77 29                	ja     80148b <strtol+0xaf>
			dig = *s - 'a' + 10;
  801462:	0f be d2             	movsbl %dl,%edx
  801465:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801468:	3b 55 10             	cmp    0x10(%ebp),%edx
  80146b:	7d 30                	jge    80149d <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  80146d:	83 c1 01             	add    $0x1,%ecx
  801470:	0f af 45 10          	imul   0x10(%ebp),%eax
  801474:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801476:	0f b6 11             	movzbl (%ecx),%edx
  801479:	8d 72 d0             	lea    -0x30(%edx),%esi
  80147c:	89 f3                	mov    %esi,%ebx
  80147e:	80 fb 09             	cmp    $0x9,%bl
  801481:	77 d5                	ja     801458 <strtol+0x7c>
			dig = *s - '0';
  801483:	0f be d2             	movsbl %dl,%edx
  801486:	83 ea 30             	sub    $0x30,%edx
  801489:	eb dd                	jmp    801468 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  80148b:	8d 72 bf             	lea    -0x41(%edx),%esi
  80148e:	89 f3                	mov    %esi,%ebx
  801490:	80 fb 19             	cmp    $0x19,%bl
  801493:	77 08                	ja     80149d <strtol+0xc1>
			dig = *s - 'A' + 10;
  801495:	0f be d2             	movsbl %dl,%edx
  801498:	83 ea 37             	sub    $0x37,%edx
  80149b:	eb cb                	jmp    801468 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  80149d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014a1:	74 05                	je     8014a8 <strtol+0xcc>
		*endptr = (char *) s;
  8014a3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014a6:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8014a8:	89 c2                	mov    %eax,%edx
  8014aa:	f7 da                	neg    %edx
  8014ac:	85 ff                	test   %edi,%edi
  8014ae:	0f 45 c2             	cmovne %edx,%eax
}
  8014b1:	5b                   	pop    %ebx
  8014b2:	5e                   	pop    %esi
  8014b3:	5f                   	pop    %edi
  8014b4:	5d                   	pop    %ebp
  8014b5:	c3                   	ret    

008014b6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8014b6:	55                   	push   %ebp
  8014b7:	89 e5                	mov    %esp,%ebp
  8014b9:	57                   	push   %edi
  8014ba:	56                   	push   %esi
  8014bb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8014c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014c7:	89 c3                	mov    %eax,%ebx
  8014c9:	89 c7                	mov    %eax,%edi
  8014cb:	89 c6                	mov    %eax,%esi
  8014cd:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8014cf:	5b                   	pop    %ebx
  8014d0:	5e                   	pop    %esi
  8014d1:	5f                   	pop    %edi
  8014d2:	5d                   	pop    %ebp
  8014d3:	c3                   	ret    

008014d4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8014d4:	55                   	push   %ebp
  8014d5:	89 e5                	mov    %esp,%ebp
  8014d7:	57                   	push   %edi
  8014d8:	56                   	push   %esi
  8014d9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014da:	ba 00 00 00 00       	mov    $0x0,%edx
  8014df:	b8 01 00 00 00       	mov    $0x1,%eax
  8014e4:	89 d1                	mov    %edx,%ecx
  8014e6:	89 d3                	mov    %edx,%ebx
  8014e8:	89 d7                	mov    %edx,%edi
  8014ea:	89 d6                	mov    %edx,%esi
  8014ec:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8014ee:	5b                   	pop    %ebx
  8014ef:	5e                   	pop    %esi
  8014f0:	5f                   	pop    %edi
  8014f1:	5d                   	pop    %ebp
  8014f2:	c3                   	ret    

008014f3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8014f3:	55                   	push   %ebp
  8014f4:	89 e5                	mov    %esp,%ebp
  8014f6:	57                   	push   %edi
  8014f7:	56                   	push   %esi
  8014f8:	53                   	push   %ebx
  8014f9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8014fc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801501:	8b 55 08             	mov    0x8(%ebp),%edx
  801504:	b8 03 00 00 00       	mov    $0x3,%eax
  801509:	89 cb                	mov    %ecx,%ebx
  80150b:	89 cf                	mov    %ecx,%edi
  80150d:	89 ce                	mov    %ecx,%esi
  80150f:	cd 30                	int    $0x30
	if(check && ret > 0)
  801511:	85 c0                	test   %eax,%eax
  801513:	7f 08                	jg     80151d <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801515:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801518:	5b                   	pop    %ebx
  801519:	5e                   	pop    %esi
  80151a:	5f                   	pop    %edi
  80151b:	5d                   	pop    %ebp
  80151c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80151d:	83 ec 0c             	sub    $0xc,%esp
  801520:	50                   	push   %eax
  801521:	6a 03                	push   $0x3
  801523:	68 48 36 80 00       	push   $0x803648
  801528:	6a 43                	push   $0x43
  80152a:	68 65 36 80 00       	push   $0x803665
  80152f:	e8 f7 f3 ff ff       	call   80092b <_panic>

00801534 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801534:	55                   	push   %ebp
  801535:	89 e5                	mov    %esp,%ebp
  801537:	57                   	push   %edi
  801538:	56                   	push   %esi
  801539:	53                   	push   %ebx
	asm volatile("int %1\n"
  80153a:	ba 00 00 00 00       	mov    $0x0,%edx
  80153f:	b8 02 00 00 00       	mov    $0x2,%eax
  801544:	89 d1                	mov    %edx,%ecx
  801546:	89 d3                	mov    %edx,%ebx
  801548:	89 d7                	mov    %edx,%edi
  80154a:	89 d6                	mov    %edx,%esi
  80154c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80154e:	5b                   	pop    %ebx
  80154f:	5e                   	pop    %esi
  801550:	5f                   	pop    %edi
  801551:	5d                   	pop    %ebp
  801552:	c3                   	ret    

00801553 <sys_yield>:

void
sys_yield(void)
{
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
  801556:	57                   	push   %edi
  801557:	56                   	push   %esi
  801558:	53                   	push   %ebx
	asm volatile("int %1\n"
  801559:	ba 00 00 00 00       	mov    $0x0,%edx
  80155e:	b8 0b 00 00 00       	mov    $0xb,%eax
  801563:	89 d1                	mov    %edx,%ecx
  801565:	89 d3                	mov    %edx,%ebx
  801567:	89 d7                	mov    %edx,%edi
  801569:	89 d6                	mov    %edx,%esi
  80156b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80156d:	5b                   	pop    %ebx
  80156e:	5e                   	pop    %esi
  80156f:	5f                   	pop    %edi
  801570:	5d                   	pop    %ebp
  801571:	c3                   	ret    

00801572 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801572:	55                   	push   %ebp
  801573:	89 e5                	mov    %esp,%ebp
  801575:	57                   	push   %edi
  801576:	56                   	push   %esi
  801577:	53                   	push   %ebx
  801578:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80157b:	be 00 00 00 00       	mov    $0x0,%esi
  801580:	8b 55 08             	mov    0x8(%ebp),%edx
  801583:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801586:	b8 04 00 00 00       	mov    $0x4,%eax
  80158b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80158e:	89 f7                	mov    %esi,%edi
  801590:	cd 30                	int    $0x30
	if(check && ret > 0)
  801592:	85 c0                	test   %eax,%eax
  801594:	7f 08                	jg     80159e <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801596:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801599:	5b                   	pop    %ebx
  80159a:	5e                   	pop    %esi
  80159b:	5f                   	pop    %edi
  80159c:	5d                   	pop    %ebp
  80159d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80159e:	83 ec 0c             	sub    $0xc,%esp
  8015a1:	50                   	push   %eax
  8015a2:	6a 04                	push   $0x4
  8015a4:	68 48 36 80 00       	push   $0x803648
  8015a9:	6a 43                	push   $0x43
  8015ab:	68 65 36 80 00       	push   $0x803665
  8015b0:	e8 76 f3 ff ff       	call   80092b <_panic>

008015b5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	57                   	push   %edi
  8015b9:	56                   	push   %esi
  8015ba:	53                   	push   %ebx
  8015bb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8015be:	8b 55 08             	mov    0x8(%ebp),%edx
  8015c1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015c4:	b8 05 00 00 00       	mov    $0x5,%eax
  8015c9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8015cc:	8b 7d 14             	mov    0x14(%ebp),%edi
  8015cf:	8b 75 18             	mov    0x18(%ebp),%esi
  8015d2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8015d4:	85 c0                	test   %eax,%eax
  8015d6:	7f 08                	jg     8015e0 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8015d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015db:	5b                   	pop    %ebx
  8015dc:	5e                   	pop    %esi
  8015dd:	5f                   	pop    %edi
  8015de:	5d                   	pop    %ebp
  8015df:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8015e0:	83 ec 0c             	sub    $0xc,%esp
  8015e3:	50                   	push   %eax
  8015e4:	6a 05                	push   $0x5
  8015e6:	68 48 36 80 00       	push   $0x803648
  8015eb:	6a 43                	push   $0x43
  8015ed:	68 65 36 80 00       	push   $0x803665
  8015f2:	e8 34 f3 ff ff       	call   80092b <_panic>

008015f7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	57                   	push   %edi
  8015fb:	56                   	push   %esi
  8015fc:	53                   	push   %ebx
  8015fd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801600:	bb 00 00 00 00       	mov    $0x0,%ebx
  801605:	8b 55 08             	mov    0x8(%ebp),%edx
  801608:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80160b:	b8 06 00 00 00       	mov    $0x6,%eax
  801610:	89 df                	mov    %ebx,%edi
  801612:	89 de                	mov    %ebx,%esi
  801614:	cd 30                	int    $0x30
	if(check && ret > 0)
  801616:	85 c0                	test   %eax,%eax
  801618:	7f 08                	jg     801622 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80161a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80161d:	5b                   	pop    %ebx
  80161e:	5e                   	pop    %esi
  80161f:	5f                   	pop    %edi
  801620:	5d                   	pop    %ebp
  801621:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801622:	83 ec 0c             	sub    $0xc,%esp
  801625:	50                   	push   %eax
  801626:	6a 06                	push   $0x6
  801628:	68 48 36 80 00       	push   $0x803648
  80162d:	6a 43                	push   $0x43
  80162f:	68 65 36 80 00       	push   $0x803665
  801634:	e8 f2 f2 ff ff       	call   80092b <_panic>

00801639 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
  80163c:	57                   	push   %edi
  80163d:	56                   	push   %esi
  80163e:	53                   	push   %ebx
  80163f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801642:	bb 00 00 00 00       	mov    $0x0,%ebx
  801647:	8b 55 08             	mov    0x8(%ebp),%edx
  80164a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80164d:	b8 08 00 00 00       	mov    $0x8,%eax
  801652:	89 df                	mov    %ebx,%edi
  801654:	89 de                	mov    %ebx,%esi
  801656:	cd 30                	int    $0x30
	if(check && ret > 0)
  801658:	85 c0                	test   %eax,%eax
  80165a:	7f 08                	jg     801664 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80165c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80165f:	5b                   	pop    %ebx
  801660:	5e                   	pop    %esi
  801661:	5f                   	pop    %edi
  801662:	5d                   	pop    %ebp
  801663:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801664:	83 ec 0c             	sub    $0xc,%esp
  801667:	50                   	push   %eax
  801668:	6a 08                	push   $0x8
  80166a:	68 48 36 80 00       	push   $0x803648
  80166f:	6a 43                	push   $0x43
  801671:	68 65 36 80 00       	push   $0x803665
  801676:	e8 b0 f2 ff ff       	call   80092b <_panic>

0080167b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
  80167e:	57                   	push   %edi
  80167f:	56                   	push   %esi
  801680:	53                   	push   %ebx
  801681:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801684:	bb 00 00 00 00       	mov    $0x0,%ebx
  801689:	8b 55 08             	mov    0x8(%ebp),%edx
  80168c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80168f:	b8 09 00 00 00       	mov    $0x9,%eax
  801694:	89 df                	mov    %ebx,%edi
  801696:	89 de                	mov    %ebx,%esi
  801698:	cd 30                	int    $0x30
	if(check && ret > 0)
  80169a:	85 c0                	test   %eax,%eax
  80169c:	7f 08                	jg     8016a6 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80169e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016a1:	5b                   	pop    %ebx
  8016a2:	5e                   	pop    %esi
  8016a3:	5f                   	pop    %edi
  8016a4:	5d                   	pop    %ebp
  8016a5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8016a6:	83 ec 0c             	sub    $0xc,%esp
  8016a9:	50                   	push   %eax
  8016aa:	6a 09                	push   $0x9
  8016ac:	68 48 36 80 00       	push   $0x803648
  8016b1:	6a 43                	push   $0x43
  8016b3:	68 65 36 80 00       	push   $0x803665
  8016b8:	e8 6e f2 ff ff       	call   80092b <_panic>

008016bd <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
  8016c0:	57                   	push   %edi
  8016c1:	56                   	push   %esi
  8016c2:	53                   	push   %ebx
  8016c3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8016c6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8016ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016d1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8016d6:	89 df                	mov    %ebx,%edi
  8016d8:	89 de                	mov    %ebx,%esi
  8016da:	cd 30                	int    $0x30
	if(check && ret > 0)
  8016dc:	85 c0                	test   %eax,%eax
  8016de:	7f 08                	jg     8016e8 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8016e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016e3:	5b                   	pop    %ebx
  8016e4:	5e                   	pop    %esi
  8016e5:	5f                   	pop    %edi
  8016e6:	5d                   	pop    %ebp
  8016e7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8016e8:	83 ec 0c             	sub    $0xc,%esp
  8016eb:	50                   	push   %eax
  8016ec:	6a 0a                	push   $0xa
  8016ee:	68 48 36 80 00       	push   $0x803648
  8016f3:	6a 43                	push   $0x43
  8016f5:	68 65 36 80 00       	push   $0x803665
  8016fa:	e8 2c f2 ff ff       	call   80092b <_panic>

008016ff <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8016ff:	55                   	push   %ebp
  801700:	89 e5                	mov    %esp,%ebp
  801702:	57                   	push   %edi
  801703:	56                   	push   %esi
  801704:	53                   	push   %ebx
	asm volatile("int %1\n"
  801705:	8b 55 08             	mov    0x8(%ebp),%edx
  801708:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80170b:	b8 0c 00 00 00       	mov    $0xc,%eax
  801710:	be 00 00 00 00       	mov    $0x0,%esi
  801715:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801718:	8b 7d 14             	mov    0x14(%ebp),%edi
  80171b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80171d:	5b                   	pop    %ebx
  80171e:	5e                   	pop    %esi
  80171f:	5f                   	pop    %edi
  801720:	5d                   	pop    %ebp
  801721:	c3                   	ret    

00801722 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
  801725:	57                   	push   %edi
  801726:	56                   	push   %esi
  801727:	53                   	push   %ebx
  801728:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80172b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801730:	8b 55 08             	mov    0x8(%ebp),%edx
  801733:	b8 0d 00 00 00       	mov    $0xd,%eax
  801738:	89 cb                	mov    %ecx,%ebx
  80173a:	89 cf                	mov    %ecx,%edi
  80173c:	89 ce                	mov    %ecx,%esi
  80173e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801740:	85 c0                	test   %eax,%eax
  801742:	7f 08                	jg     80174c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801744:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801747:	5b                   	pop    %ebx
  801748:	5e                   	pop    %esi
  801749:	5f                   	pop    %edi
  80174a:	5d                   	pop    %ebp
  80174b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80174c:	83 ec 0c             	sub    $0xc,%esp
  80174f:	50                   	push   %eax
  801750:	6a 0d                	push   $0xd
  801752:	68 48 36 80 00       	push   $0x803648
  801757:	6a 43                	push   $0x43
  801759:	68 65 36 80 00       	push   $0x803665
  80175e:	e8 c8 f1 ff ff       	call   80092b <_panic>

00801763 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
  801766:	57                   	push   %edi
  801767:	56                   	push   %esi
  801768:	53                   	push   %ebx
	asm volatile("int %1\n"
  801769:	bb 00 00 00 00       	mov    $0x0,%ebx
  80176e:	8b 55 08             	mov    0x8(%ebp),%edx
  801771:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801774:	b8 0e 00 00 00       	mov    $0xe,%eax
  801779:	89 df                	mov    %ebx,%edi
  80177b:	89 de                	mov    %ebx,%esi
  80177d:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80177f:	5b                   	pop    %ebx
  801780:	5e                   	pop    %esi
  801781:	5f                   	pop    %edi
  801782:	5d                   	pop    %ebp
  801783:	c3                   	ret    

00801784 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801784:	55                   	push   %ebp
  801785:	89 e5                	mov    %esp,%ebp
  801787:	57                   	push   %edi
  801788:	56                   	push   %esi
  801789:	53                   	push   %ebx
	asm volatile("int %1\n"
  80178a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80178f:	8b 55 08             	mov    0x8(%ebp),%edx
  801792:	b8 0f 00 00 00       	mov    $0xf,%eax
  801797:	89 cb                	mov    %ecx,%ebx
  801799:	89 cf                	mov    %ecx,%edi
  80179b:	89 ce                	mov    %ecx,%esi
  80179d:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80179f:	5b                   	pop    %ebx
  8017a0:	5e                   	pop    %esi
  8017a1:	5f                   	pop    %edi
  8017a2:	5d                   	pop    %ebp
  8017a3:	c3                   	ret    

008017a4 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	57                   	push   %edi
  8017a8:	56                   	push   %esi
  8017a9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8017aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8017af:	b8 10 00 00 00       	mov    $0x10,%eax
  8017b4:	89 d1                	mov    %edx,%ecx
  8017b6:	89 d3                	mov    %edx,%ebx
  8017b8:	89 d7                	mov    %edx,%edi
  8017ba:	89 d6                	mov    %edx,%esi
  8017bc:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8017be:	5b                   	pop    %ebx
  8017bf:	5e                   	pop    %esi
  8017c0:	5f                   	pop    %edi
  8017c1:	5d                   	pop    %ebp
  8017c2:	c3                   	ret    

008017c3 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
  8017c6:	57                   	push   %edi
  8017c7:	56                   	push   %esi
  8017c8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8017c9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8017d1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017d4:	b8 11 00 00 00       	mov    $0x11,%eax
  8017d9:	89 df                	mov    %ebx,%edi
  8017db:	89 de                	mov    %ebx,%esi
  8017dd:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8017df:	5b                   	pop    %ebx
  8017e0:	5e                   	pop    %esi
  8017e1:	5f                   	pop    %edi
  8017e2:	5d                   	pop    %ebp
  8017e3:	c3                   	ret    

008017e4 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
  8017e7:	57                   	push   %edi
  8017e8:	56                   	push   %esi
  8017e9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8017ea:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8017f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017f5:	b8 12 00 00 00       	mov    $0x12,%eax
  8017fa:	89 df                	mov    %ebx,%edi
  8017fc:	89 de                	mov    %ebx,%esi
  8017fe:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801800:	5b                   	pop    %ebx
  801801:	5e                   	pop    %esi
  801802:	5f                   	pop    %edi
  801803:	5d                   	pop    %ebp
  801804:	c3                   	ret    

00801805 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
  801808:	57                   	push   %edi
  801809:	56                   	push   %esi
  80180a:	53                   	push   %ebx
  80180b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80180e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801813:	8b 55 08             	mov    0x8(%ebp),%edx
  801816:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801819:	b8 13 00 00 00       	mov    $0x13,%eax
  80181e:	89 df                	mov    %ebx,%edi
  801820:	89 de                	mov    %ebx,%esi
  801822:	cd 30                	int    $0x30
	if(check && ret > 0)
  801824:	85 c0                	test   %eax,%eax
  801826:	7f 08                	jg     801830 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801828:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80182b:	5b                   	pop    %ebx
  80182c:	5e                   	pop    %esi
  80182d:	5f                   	pop    %edi
  80182e:	5d                   	pop    %ebp
  80182f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801830:	83 ec 0c             	sub    $0xc,%esp
  801833:	50                   	push   %eax
  801834:	6a 13                	push   $0x13
  801836:	68 48 36 80 00       	push   $0x803648
  80183b:	6a 43                	push   $0x43
  80183d:	68 65 36 80 00       	push   $0x803665
  801842:	e8 e4 f0 ff ff       	call   80092b <_panic>

00801847 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
  80184a:	57                   	push   %edi
  80184b:	56                   	push   %esi
  80184c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80184d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801852:	8b 55 08             	mov    0x8(%ebp),%edx
  801855:	b8 14 00 00 00       	mov    $0x14,%eax
  80185a:	89 cb                	mov    %ecx,%ebx
  80185c:	89 cf                	mov    %ecx,%edi
  80185e:	89 ce                	mov    %ecx,%esi
  801860:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801862:	5b                   	pop    %ebx
  801863:	5e                   	pop    %esi
  801864:	5f                   	pop    %edi
  801865:	5d                   	pop    %ebp
  801866:	c3                   	ret    

00801867 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80186a:	8b 45 08             	mov    0x8(%ebp),%eax
  80186d:	05 00 00 00 30       	add    $0x30000000,%eax
  801872:	c1 e8 0c             	shr    $0xc,%eax
}
  801875:	5d                   	pop    %ebp
  801876:	c3                   	ret    

00801877 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80187a:	8b 45 08             	mov    0x8(%ebp),%eax
  80187d:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801882:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801887:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80188c:	5d                   	pop    %ebp
  80188d:	c3                   	ret    

0080188e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
  801891:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801896:	89 c2                	mov    %eax,%edx
  801898:	c1 ea 16             	shr    $0x16,%edx
  80189b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8018a2:	f6 c2 01             	test   $0x1,%dl
  8018a5:	74 2d                	je     8018d4 <fd_alloc+0x46>
  8018a7:	89 c2                	mov    %eax,%edx
  8018a9:	c1 ea 0c             	shr    $0xc,%edx
  8018ac:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018b3:	f6 c2 01             	test   $0x1,%dl
  8018b6:	74 1c                	je     8018d4 <fd_alloc+0x46>
  8018b8:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8018bd:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8018c2:	75 d2                	jne    801896 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8018c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8018cd:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8018d2:	eb 0a                	jmp    8018de <fd_alloc+0x50>
			*fd_store = fd;
  8018d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018d7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8018d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018de:	5d                   	pop    %ebp
  8018df:	c3                   	ret    

008018e0 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8018e6:	83 f8 1f             	cmp    $0x1f,%eax
  8018e9:	77 30                	ja     80191b <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8018eb:	c1 e0 0c             	shl    $0xc,%eax
  8018ee:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8018f3:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8018f9:	f6 c2 01             	test   $0x1,%dl
  8018fc:	74 24                	je     801922 <fd_lookup+0x42>
  8018fe:	89 c2                	mov    %eax,%edx
  801900:	c1 ea 0c             	shr    $0xc,%edx
  801903:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80190a:	f6 c2 01             	test   $0x1,%dl
  80190d:	74 1a                	je     801929 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80190f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801912:	89 02                	mov    %eax,(%edx)
	return 0;
  801914:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801919:	5d                   	pop    %ebp
  80191a:	c3                   	ret    
		return -E_INVAL;
  80191b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801920:	eb f7                	jmp    801919 <fd_lookup+0x39>
		return -E_INVAL;
  801922:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801927:	eb f0                	jmp    801919 <fd_lookup+0x39>
  801929:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80192e:	eb e9                	jmp    801919 <fd_lookup+0x39>

00801930 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
  801933:	83 ec 08             	sub    $0x8,%esp
  801936:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801939:	ba 00 00 00 00       	mov    $0x0,%edx
  80193e:	b8 24 40 80 00       	mov    $0x804024,%eax
		if (devtab[i]->dev_id == dev_id) {
  801943:	39 08                	cmp    %ecx,(%eax)
  801945:	74 38                	je     80197f <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801947:	83 c2 01             	add    $0x1,%edx
  80194a:	8b 04 95 f0 36 80 00 	mov    0x8036f0(,%edx,4),%eax
  801951:	85 c0                	test   %eax,%eax
  801953:	75 ee                	jne    801943 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801955:	a1 1c 50 80 00       	mov    0x80501c,%eax
  80195a:	8b 40 48             	mov    0x48(%eax),%eax
  80195d:	83 ec 04             	sub    $0x4,%esp
  801960:	51                   	push   %ecx
  801961:	50                   	push   %eax
  801962:	68 74 36 80 00       	push   $0x803674
  801967:	e8 b5 f0 ff ff       	call   800a21 <cprintf>
	*dev = 0;
  80196c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801975:	83 c4 10             	add    $0x10,%esp
  801978:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    
			*dev = devtab[i];
  80197f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801982:	89 01                	mov    %eax,(%ecx)
			return 0;
  801984:	b8 00 00 00 00       	mov    $0x0,%eax
  801989:	eb f2                	jmp    80197d <dev_lookup+0x4d>

0080198b <fd_close>:
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
  80198e:	57                   	push   %edi
  80198f:	56                   	push   %esi
  801990:	53                   	push   %ebx
  801991:	83 ec 24             	sub    $0x24,%esp
  801994:	8b 75 08             	mov    0x8(%ebp),%esi
  801997:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80199a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80199d:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80199e:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8019a4:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8019a7:	50                   	push   %eax
  8019a8:	e8 33 ff ff ff       	call   8018e0 <fd_lookup>
  8019ad:	89 c3                	mov    %eax,%ebx
  8019af:	83 c4 10             	add    $0x10,%esp
  8019b2:	85 c0                	test   %eax,%eax
  8019b4:	78 05                	js     8019bb <fd_close+0x30>
	    || fd != fd2)
  8019b6:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8019b9:	74 16                	je     8019d1 <fd_close+0x46>
		return (must_exist ? r : 0);
  8019bb:	89 f8                	mov    %edi,%eax
  8019bd:	84 c0                	test   %al,%al
  8019bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c4:	0f 44 d8             	cmove  %eax,%ebx
}
  8019c7:	89 d8                	mov    %ebx,%eax
  8019c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019cc:	5b                   	pop    %ebx
  8019cd:	5e                   	pop    %esi
  8019ce:	5f                   	pop    %edi
  8019cf:	5d                   	pop    %ebp
  8019d0:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8019d1:	83 ec 08             	sub    $0x8,%esp
  8019d4:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8019d7:	50                   	push   %eax
  8019d8:	ff 36                	pushl  (%esi)
  8019da:	e8 51 ff ff ff       	call   801930 <dev_lookup>
  8019df:	89 c3                	mov    %eax,%ebx
  8019e1:	83 c4 10             	add    $0x10,%esp
  8019e4:	85 c0                	test   %eax,%eax
  8019e6:	78 1a                	js     801a02 <fd_close+0x77>
		if (dev->dev_close)
  8019e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019eb:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8019ee:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8019f3:	85 c0                	test   %eax,%eax
  8019f5:	74 0b                	je     801a02 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8019f7:	83 ec 0c             	sub    $0xc,%esp
  8019fa:	56                   	push   %esi
  8019fb:	ff d0                	call   *%eax
  8019fd:	89 c3                	mov    %eax,%ebx
  8019ff:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801a02:	83 ec 08             	sub    $0x8,%esp
  801a05:	56                   	push   %esi
  801a06:	6a 00                	push   $0x0
  801a08:	e8 ea fb ff ff       	call   8015f7 <sys_page_unmap>
	return r;
  801a0d:	83 c4 10             	add    $0x10,%esp
  801a10:	eb b5                	jmp    8019c7 <fd_close+0x3c>

00801a12 <close>:

int
close(int fdnum)
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
  801a15:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a18:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a1b:	50                   	push   %eax
  801a1c:	ff 75 08             	pushl  0x8(%ebp)
  801a1f:	e8 bc fe ff ff       	call   8018e0 <fd_lookup>
  801a24:	83 c4 10             	add    $0x10,%esp
  801a27:	85 c0                	test   %eax,%eax
  801a29:	79 02                	jns    801a2d <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801a2b:	c9                   	leave  
  801a2c:	c3                   	ret    
		return fd_close(fd, 1);
  801a2d:	83 ec 08             	sub    $0x8,%esp
  801a30:	6a 01                	push   $0x1
  801a32:	ff 75 f4             	pushl  -0xc(%ebp)
  801a35:	e8 51 ff ff ff       	call   80198b <fd_close>
  801a3a:	83 c4 10             	add    $0x10,%esp
  801a3d:	eb ec                	jmp    801a2b <close+0x19>

00801a3f <close_all>:

void
close_all(void)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
  801a42:	53                   	push   %ebx
  801a43:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801a46:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801a4b:	83 ec 0c             	sub    $0xc,%esp
  801a4e:	53                   	push   %ebx
  801a4f:	e8 be ff ff ff       	call   801a12 <close>
	for (i = 0; i < MAXFD; i++)
  801a54:	83 c3 01             	add    $0x1,%ebx
  801a57:	83 c4 10             	add    $0x10,%esp
  801a5a:	83 fb 20             	cmp    $0x20,%ebx
  801a5d:	75 ec                	jne    801a4b <close_all+0xc>
}
  801a5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    

00801a64 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
  801a67:	57                   	push   %edi
  801a68:	56                   	push   %esi
  801a69:	53                   	push   %ebx
  801a6a:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801a6d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801a70:	50                   	push   %eax
  801a71:	ff 75 08             	pushl  0x8(%ebp)
  801a74:	e8 67 fe ff ff       	call   8018e0 <fd_lookup>
  801a79:	89 c3                	mov    %eax,%ebx
  801a7b:	83 c4 10             	add    $0x10,%esp
  801a7e:	85 c0                	test   %eax,%eax
  801a80:	0f 88 81 00 00 00    	js     801b07 <dup+0xa3>
		return r;
	close(newfdnum);
  801a86:	83 ec 0c             	sub    $0xc,%esp
  801a89:	ff 75 0c             	pushl  0xc(%ebp)
  801a8c:	e8 81 ff ff ff       	call   801a12 <close>

	newfd = INDEX2FD(newfdnum);
  801a91:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a94:	c1 e6 0c             	shl    $0xc,%esi
  801a97:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801a9d:	83 c4 04             	add    $0x4,%esp
  801aa0:	ff 75 e4             	pushl  -0x1c(%ebp)
  801aa3:	e8 cf fd ff ff       	call   801877 <fd2data>
  801aa8:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801aaa:	89 34 24             	mov    %esi,(%esp)
  801aad:	e8 c5 fd ff ff       	call   801877 <fd2data>
  801ab2:	83 c4 10             	add    $0x10,%esp
  801ab5:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801ab7:	89 d8                	mov    %ebx,%eax
  801ab9:	c1 e8 16             	shr    $0x16,%eax
  801abc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801ac3:	a8 01                	test   $0x1,%al
  801ac5:	74 11                	je     801ad8 <dup+0x74>
  801ac7:	89 d8                	mov    %ebx,%eax
  801ac9:	c1 e8 0c             	shr    $0xc,%eax
  801acc:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801ad3:	f6 c2 01             	test   $0x1,%dl
  801ad6:	75 39                	jne    801b11 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801ad8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801adb:	89 d0                	mov    %edx,%eax
  801add:	c1 e8 0c             	shr    $0xc,%eax
  801ae0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801ae7:	83 ec 0c             	sub    $0xc,%esp
  801aea:	25 07 0e 00 00       	and    $0xe07,%eax
  801aef:	50                   	push   %eax
  801af0:	56                   	push   %esi
  801af1:	6a 00                	push   $0x0
  801af3:	52                   	push   %edx
  801af4:	6a 00                	push   $0x0
  801af6:	e8 ba fa ff ff       	call   8015b5 <sys_page_map>
  801afb:	89 c3                	mov    %eax,%ebx
  801afd:	83 c4 20             	add    $0x20,%esp
  801b00:	85 c0                	test   %eax,%eax
  801b02:	78 31                	js     801b35 <dup+0xd1>
		goto err;

	return newfdnum;
  801b04:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801b07:	89 d8                	mov    %ebx,%eax
  801b09:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b0c:	5b                   	pop    %ebx
  801b0d:	5e                   	pop    %esi
  801b0e:	5f                   	pop    %edi
  801b0f:	5d                   	pop    %ebp
  801b10:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801b11:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801b18:	83 ec 0c             	sub    $0xc,%esp
  801b1b:	25 07 0e 00 00       	and    $0xe07,%eax
  801b20:	50                   	push   %eax
  801b21:	57                   	push   %edi
  801b22:	6a 00                	push   $0x0
  801b24:	53                   	push   %ebx
  801b25:	6a 00                	push   $0x0
  801b27:	e8 89 fa ff ff       	call   8015b5 <sys_page_map>
  801b2c:	89 c3                	mov    %eax,%ebx
  801b2e:	83 c4 20             	add    $0x20,%esp
  801b31:	85 c0                	test   %eax,%eax
  801b33:	79 a3                	jns    801ad8 <dup+0x74>
	sys_page_unmap(0, newfd);
  801b35:	83 ec 08             	sub    $0x8,%esp
  801b38:	56                   	push   %esi
  801b39:	6a 00                	push   $0x0
  801b3b:	e8 b7 fa ff ff       	call   8015f7 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801b40:	83 c4 08             	add    $0x8,%esp
  801b43:	57                   	push   %edi
  801b44:	6a 00                	push   $0x0
  801b46:	e8 ac fa ff ff       	call   8015f7 <sys_page_unmap>
	return r;
  801b4b:	83 c4 10             	add    $0x10,%esp
  801b4e:	eb b7                	jmp    801b07 <dup+0xa3>

00801b50 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
  801b53:	53                   	push   %ebx
  801b54:	83 ec 1c             	sub    $0x1c,%esp
  801b57:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b5a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b5d:	50                   	push   %eax
  801b5e:	53                   	push   %ebx
  801b5f:	e8 7c fd ff ff       	call   8018e0 <fd_lookup>
  801b64:	83 c4 10             	add    $0x10,%esp
  801b67:	85 c0                	test   %eax,%eax
  801b69:	78 3f                	js     801baa <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b6b:	83 ec 08             	sub    $0x8,%esp
  801b6e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b71:	50                   	push   %eax
  801b72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b75:	ff 30                	pushl  (%eax)
  801b77:	e8 b4 fd ff ff       	call   801930 <dev_lookup>
  801b7c:	83 c4 10             	add    $0x10,%esp
  801b7f:	85 c0                	test   %eax,%eax
  801b81:	78 27                	js     801baa <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b83:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b86:	8b 42 08             	mov    0x8(%edx),%eax
  801b89:	83 e0 03             	and    $0x3,%eax
  801b8c:	83 f8 01             	cmp    $0x1,%eax
  801b8f:	74 1e                	je     801baf <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b94:	8b 40 08             	mov    0x8(%eax),%eax
  801b97:	85 c0                	test   %eax,%eax
  801b99:	74 35                	je     801bd0 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801b9b:	83 ec 04             	sub    $0x4,%esp
  801b9e:	ff 75 10             	pushl  0x10(%ebp)
  801ba1:	ff 75 0c             	pushl  0xc(%ebp)
  801ba4:	52                   	push   %edx
  801ba5:	ff d0                	call   *%eax
  801ba7:	83 c4 10             	add    $0x10,%esp
}
  801baa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801baf:	a1 1c 50 80 00       	mov    0x80501c,%eax
  801bb4:	8b 40 48             	mov    0x48(%eax),%eax
  801bb7:	83 ec 04             	sub    $0x4,%esp
  801bba:	53                   	push   %ebx
  801bbb:	50                   	push   %eax
  801bbc:	68 b5 36 80 00       	push   $0x8036b5
  801bc1:	e8 5b ee ff ff       	call   800a21 <cprintf>
		return -E_INVAL;
  801bc6:	83 c4 10             	add    $0x10,%esp
  801bc9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bce:	eb da                	jmp    801baa <read+0x5a>
		return -E_NOT_SUPP;
  801bd0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bd5:	eb d3                	jmp    801baa <read+0x5a>

00801bd7 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
  801bda:	57                   	push   %edi
  801bdb:	56                   	push   %esi
  801bdc:	53                   	push   %ebx
  801bdd:	83 ec 0c             	sub    $0xc,%esp
  801be0:	8b 7d 08             	mov    0x8(%ebp),%edi
  801be3:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801be6:	bb 00 00 00 00       	mov    $0x0,%ebx
  801beb:	39 f3                	cmp    %esi,%ebx
  801bed:	73 23                	jae    801c12 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801bef:	83 ec 04             	sub    $0x4,%esp
  801bf2:	89 f0                	mov    %esi,%eax
  801bf4:	29 d8                	sub    %ebx,%eax
  801bf6:	50                   	push   %eax
  801bf7:	89 d8                	mov    %ebx,%eax
  801bf9:	03 45 0c             	add    0xc(%ebp),%eax
  801bfc:	50                   	push   %eax
  801bfd:	57                   	push   %edi
  801bfe:	e8 4d ff ff ff       	call   801b50 <read>
		if (m < 0)
  801c03:	83 c4 10             	add    $0x10,%esp
  801c06:	85 c0                	test   %eax,%eax
  801c08:	78 06                	js     801c10 <readn+0x39>
			return m;
		if (m == 0)
  801c0a:	74 06                	je     801c12 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801c0c:	01 c3                	add    %eax,%ebx
  801c0e:	eb db                	jmp    801beb <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801c10:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801c12:	89 d8                	mov    %ebx,%eax
  801c14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c17:	5b                   	pop    %ebx
  801c18:	5e                   	pop    %esi
  801c19:	5f                   	pop    %edi
  801c1a:	5d                   	pop    %ebp
  801c1b:	c3                   	ret    

00801c1c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
  801c1f:	53                   	push   %ebx
  801c20:	83 ec 1c             	sub    $0x1c,%esp
  801c23:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c26:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c29:	50                   	push   %eax
  801c2a:	53                   	push   %ebx
  801c2b:	e8 b0 fc ff ff       	call   8018e0 <fd_lookup>
  801c30:	83 c4 10             	add    $0x10,%esp
  801c33:	85 c0                	test   %eax,%eax
  801c35:	78 3a                	js     801c71 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c37:	83 ec 08             	sub    $0x8,%esp
  801c3a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c3d:	50                   	push   %eax
  801c3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c41:	ff 30                	pushl  (%eax)
  801c43:	e8 e8 fc ff ff       	call   801930 <dev_lookup>
  801c48:	83 c4 10             	add    $0x10,%esp
  801c4b:	85 c0                	test   %eax,%eax
  801c4d:	78 22                	js     801c71 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c52:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c56:	74 1e                	je     801c76 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801c58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c5b:	8b 52 0c             	mov    0xc(%edx),%edx
  801c5e:	85 d2                	test   %edx,%edx
  801c60:	74 35                	je     801c97 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801c62:	83 ec 04             	sub    $0x4,%esp
  801c65:	ff 75 10             	pushl  0x10(%ebp)
  801c68:	ff 75 0c             	pushl  0xc(%ebp)
  801c6b:	50                   	push   %eax
  801c6c:	ff d2                	call   *%edx
  801c6e:	83 c4 10             	add    $0x10,%esp
}
  801c71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801c76:	a1 1c 50 80 00       	mov    0x80501c,%eax
  801c7b:	8b 40 48             	mov    0x48(%eax),%eax
  801c7e:	83 ec 04             	sub    $0x4,%esp
  801c81:	53                   	push   %ebx
  801c82:	50                   	push   %eax
  801c83:	68 d1 36 80 00       	push   $0x8036d1
  801c88:	e8 94 ed ff ff       	call   800a21 <cprintf>
		return -E_INVAL;
  801c8d:	83 c4 10             	add    $0x10,%esp
  801c90:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c95:	eb da                	jmp    801c71 <write+0x55>
		return -E_NOT_SUPP;
  801c97:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c9c:	eb d3                	jmp    801c71 <write+0x55>

00801c9e <seek>:

int
seek(int fdnum, off_t offset)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ca4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ca7:	50                   	push   %eax
  801ca8:	ff 75 08             	pushl  0x8(%ebp)
  801cab:	e8 30 fc ff ff       	call   8018e0 <fd_lookup>
  801cb0:	83 c4 10             	add    $0x10,%esp
  801cb3:	85 c0                	test   %eax,%eax
  801cb5:	78 0e                	js     801cc5 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801cb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cbd:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801cc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
  801cca:	53                   	push   %ebx
  801ccb:	83 ec 1c             	sub    $0x1c,%esp
  801cce:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801cd1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cd4:	50                   	push   %eax
  801cd5:	53                   	push   %ebx
  801cd6:	e8 05 fc ff ff       	call   8018e0 <fd_lookup>
  801cdb:	83 c4 10             	add    $0x10,%esp
  801cde:	85 c0                	test   %eax,%eax
  801ce0:	78 37                	js     801d19 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ce2:	83 ec 08             	sub    $0x8,%esp
  801ce5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ce8:	50                   	push   %eax
  801ce9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cec:	ff 30                	pushl  (%eax)
  801cee:	e8 3d fc ff ff       	call   801930 <dev_lookup>
  801cf3:	83 c4 10             	add    $0x10,%esp
  801cf6:	85 c0                	test   %eax,%eax
  801cf8:	78 1f                	js     801d19 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801cfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cfd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801d01:	74 1b                	je     801d1e <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801d03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d06:	8b 52 18             	mov    0x18(%edx),%edx
  801d09:	85 d2                	test   %edx,%edx
  801d0b:	74 32                	je     801d3f <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801d0d:	83 ec 08             	sub    $0x8,%esp
  801d10:	ff 75 0c             	pushl  0xc(%ebp)
  801d13:	50                   	push   %eax
  801d14:	ff d2                	call   *%edx
  801d16:	83 c4 10             	add    $0x10,%esp
}
  801d19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d1c:	c9                   	leave  
  801d1d:	c3                   	ret    
			thisenv->env_id, fdnum);
  801d1e:	a1 1c 50 80 00       	mov    0x80501c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801d23:	8b 40 48             	mov    0x48(%eax),%eax
  801d26:	83 ec 04             	sub    $0x4,%esp
  801d29:	53                   	push   %ebx
  801d2a:	50                   	push   %eax
  801d2b:	68 94 36 80 00       	push   $0x803694
  801d30:	e8 ec ec ff ff       	call   800a21 <cprintf>
		return -E_INVAL;
  801d35:	83 c4 10             	add    $0x10,%esp
  801d38:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d3d:	eb da                	jmp    801d19 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801d3f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d44:	eb d3                	jmp    801d19 <ftruncate+0x52>

00801d46 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
  801d49:	53                   	push   %ebx
  801d4a:	83 ec 1c             	sub    $0x1c,%esp
  801d4d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d50:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d53:	50                   	push   %eax
  801d54:	ff 75 08             	pushl  0x8(%ebp)
  801d57:	e8 84 fb ff ff       	call   8018e0 <fd_lookup>
  801d5c:	83 c4 10             	add    $0x10,%esp
  801d5f:	85 c0                	test   %eax,%eax
  801d61:	78 4b                	js     801dae <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d63:	83 ec 08             	sub    $0x8,%esp
  801d66:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d69:	50                   	push   %eax
  801d6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d6d:	ff 30                	pushl  (%eax)
  801d6f:	e8 bc fb ff ff       	call   801930 <dev_lookup>
  801d74:	83 c4 10             	add    $0x10,%esp
  801d77:	85 c0                	test   %eax,%eax
  801d79:	78 33                	js     801dae <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7e:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801d82:	74 2f                	je     801db3 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801d84:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801d87:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801d8e:	00 00 00 
	stat->st_isdir = 0;
  801d91:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d98:	00 00 00 
	stat->st_dev = dev;
  801d9b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801da1:	83 ec 08             	sub    $0x8,%esp
  801da4:	53                   	push   %ebx
  801da5:	ff 75 f0             	pushl  -0x10(%ebp)
  801da8:	ff 50 14             	call   *0x14(%eax)
  801dab:	83 c4 10             	add    $0x10,%esp
}
  801dae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801db1:	c9                   	leave  
  801db2:	c3                   	ret    
		return -E_NOT_SUPP;
  801db3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801db8:	eb f4                	jmp    801dae <fstat+0x68>

00801dba <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
  801dbd:	56                   	push   %esi
  801dbe:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801dbf:	83 ec 08             	sub    $0x8,%esp
  801dc2:	6a 00                	push   $0x0
  801dc4:	ff 75 08             	pushl  0x8(%ebp)
  801dc7:	e8 22 02 00 00       	call   801fee <open>
  801dcc:	89 c3                	mov    %eax,%ebx
  801dce:	83 c4 10             	add    $0x10,%esp
  801dd1:	85 c0                	test   %eax,%eax
  801dd3:	78 1b                	js     801df0 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801dd5:	83 ec 08             	sub    $0x8,%esp
  801dd8:	ff 75 0c             	pushl  0xc(%ebp)
  801ddb:	50                   	push   %eax
  801ddc:	e8 65 ff ff ff       	call   801d46 <fstat>
  801de1:	89 c6                	mov    %eax,%esi
	close(fd);
  801de3:	89 1c 24             	mov    %ebx,(%esp)
  801de6:	e8 27 fc ff ff       	call   801a12 <close>
	return r;
  801deb:	83 c4 10             	add    $0x10,%esp
  801dee:	89 f3                	mov    %esi,%ebx
}
  801df0:	89 d8                	mov    %ebx,%eax
  801df2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801df5:	5b                   	pop    %ebx
  801df6:	5e                   	pop    %esi
  801df7:	5d                   	pop    %ebp
  801df8:	c3                   	ret    

00801df9 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801df9:	55                   	push   %ebp
  801dfa:	89 e5                	mov    %esp,%ebp
  801dfc:	56                   	push   %esi
  801dfd:	53                   	push   %ebx
  801dfe:	89 c6                	mov    %eax,%esi
  801e00:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801e02:	83 3d 10 50 80 00 00 	cmpl   $0x0,0x805010
  801e09:	74 27                	je     801e32 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801e0b:	6a 07                	push   $0x7
  801e0d:	68 00 60 80 00       	push   $0x806000
  801e12:	56                   	push   %esi
  801e13:	ff 35 10 50 80 00    	pushl  0x805010
  801e19:	e8 a1 0e 00 00       	call   802cbf <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801e1e:	83 c4 0c             	add    $0xc,%esp
  801e21:	6a 00                	push   $0x0
  801e23:	53                   	push   %ebx
  801e24:	6a 00                	push   $0x0
  801e26:	e8 2b 0e 00 00       	call   802c56 <ipc_recv>
}
  801e2b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e2e:	5b                   	pop    %ebx
  801e2f:	5e                   	pop    %esi
  801e30:	5d                   	pop    %ebp
  801e31:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801e32:	83 ec 0c             	sub    $0xc,%esp
  801e35:	6a 01                	push   $0x1
  801e37:	e8 db 0e 00 00       	call   802d17 <ipc_find_env>
  801e3c:	a3 10 50 80 00       	mov    %eax,0x805010
  801e41:	83 c4 10             	add    $0x10,%esp
  801e44:	eb c5                	jmp    801e0b <fsipc+0x12>

00801e46 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
  801e49:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4f:	8b 40 0c             	mov    0xc(%eax),%eax
  801e52:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e5a:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801e5f:	ba 00 00 00 00       	mov    $0x0,%edx
  801e64:	b8 02 00 00 00       	mov    $0x2,%eax
  801e69:	e8 8b ff ff ff       	call   801df9 <fsipc>
}
  801e6e:	c9                   	leave  
  801e6f:	c3                   	ret    

00801e70 <devfile_flush>:
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
  801e73:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e76:	8b 45 08             	mov    0x8(%ebp),%eax
  801e79:	8b 40 0c             	mov    0xc(%eax),%eax
  801e7c:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801e81:	ba 00 00 00 00       	mov    $0x0,%edx
  801e86:	b8 06 00 00 00       	mov    $0x6,%eax
  801e8b:	e8 69 ff ff ff       	call   801df9 <fsipc>
}
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <devfile_stat>:
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
  801e95:	53                   	push   %ebx
  801e96:	83 ec 04             	sub    $0x4,%esp
  801e99:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9f:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea2:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801ea7:	ba 00 00 00 00       	mov    $0x0,%edx
  801eac:	b8 05 00 00 00       	mov    $0x5,%eax
  801eb1:	e8 43 ff ff ff       	call   801df9 <fsipc>
  801eb6:	85 c0                	test   %eax,%eax
  801eb8:	78 2c                	js     801ee6 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801eba:	83 ec 08             	sub    $0x8,%esp
  801ebd:	68 00 60 80 00       	push   $0x806000
  801ec2:	53                   	push   %ebx
  801ec3:	e8 b8 f2 ff ff       	call   801180 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801ec8:	a1 80 60 80 00       	mov    0x806080,%eax
  801ecd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801ed3:	a1 84 60 80 00       	mov    0x806084,%eax
  801ed8:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801ede:	83 c4 10             	add    $0x10,%esp
  801ee1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ee9:	c9                   	leave  
  801eea:	c3                   	ret    

00801eeb <devfile_write>:
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
  801eee:	53                   	push   %ebx
  801eef:	83 ec 08             	sub    $0x8,%esp
  801ef2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef8:	8b 40 0c             	mov    0xc(%eax),%eax
  801efb:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801f00:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801f06:	53                   	push   %ebx
  801f07:	ff 75 0c             	pushl  0xc(%ebp)
  801f0a:	68 08 60 80 00       	push   $0x806008
  801f0f:	e8 5c f4 ff ff       	call   801370 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801f14:	ba 00 00 00 00       	mov    $0x0,%edx
  801f19:	b8 04 00 00 00       	mov    $0x4,%eax
  801f1e:	e8 d6 fe ff ff       	call   801df9 <fsipc>
  801f23:	83 c4 10             	add    $0x10,%esp
  801f26:	85 c0                	test   %eax,%eax
  801f28:	78 0b                	js     801f35 <devfile_write+0x4a>
	assert(r <= n);
  801f2a:	39 d8                	cmp    %ebx,%eax
  801f2c:	77 0c                	ja     801f3a <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801f2e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f33:	7f 1e                	jg     801f53 <devfile_write+0x68>
}
  801f35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f38:	c9                   	leave  
  801f39:	c3                   	ret    
	assert(r <= n);
  801f3a:	68 04 37 80 00       	push   $0x803704
  801f3f:	68 0b 37 80 00       	push   $0x80370b
  801f44:	68 98 00 00 00       	push   $0x98
  801f49:	68 20 37 80 00       	push   $0x803720
  801f4e:	e8 d8 e9 ff ff       	call   80092b <_panic>
	assert(r <= PGSIZE);
  801f53:	68 2b 37 80 00       	push   $0x80372b
  801f58:	68 0b 37 80 00       	push   $0x80370b
  801f5d:	68 99 00 00 00       	push   $0x99
  801f62:	68 20 37 80 00       	push   $0x803720
  801f67:	e8 bf e9 ff ff       	call   80092b <_panic>

00801f6c <devfile_read>:
{
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
  801f6f:	56                   	push   %esi
  801f70:	53                   	push   %ebx
  801f71:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801f74:	8b 45 08             	mov    0x8(%ebp),%eax
  801f77:	8b 40 0c             	mov    0xc(%eax),%eax
  801f7a:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801f7f:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801f85:	ba 00 00 00 00       	mov    $0x0,%edx
  801f8a:	b8 03 00 00 00       	mov    $0x3,%eax
  801f8f:	e8 65 fe ff ff       	call   801df9 <fsipc>
  801f94:	89 c3                	mov    %eax,%ebx
  801f96:	85 c0                	test   %eax,%eax
  801f98:	78 1f                	js     801fb9 <devfile_read+0x4d>
	assert(r <= n);
  801f9a:	39 f0                	cmp    %esi,%eax
  801f9c:	77 24                	ja     801fc2 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801f9e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801fa3:	7f 33                	jg     801fd8 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801fa5:	83 ec 04             	sub    $0x4,%esp
  801fa8:	50                   	push   %eax
  801fa9:	68 00 60 80 00       	push   $0x806000
  801fae:	ff 75 0c             	pushl  0xc(%ebp)
  801fb1:	e8 58 f3 ff ff       	call   80130e <memmove>
	return r;
  801fb6:	83 c4 10             	add    $0x10,%esp
}
  801fb9:	89 d8                	mov    %ebx,%eax
  801fbb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fbe:	5b                   	pop    %ebx
  801fbf:	5e                   	pop    %esi
  801fc0:	5d                   	pop    %ebp
  801fc1:	c3                   	ret    
	assert(r <= n);
  801fc2:	68 04 37 80 00       	push   $0x803704
  801fc7:	68 0b 37 80 00       	push   $0x80370b
  801fcc:	6a 7c                	push   $0x7c
  801fce:	68 20 37 80 00       	push   $0x803720
  801fd3:	e8 53 e9 ff ff       	call   80092b <_panic>
	assert(r <= PGSIZE);
  801fd8:	68 2b 37 80 00       	push   $0x80372b
  801fdd:	68 0b 37 80 00       	push   $0x80370b
  801fe2:	6a 7d                	push   $0x7d
  801fe4:	68 20 37 80 00       	push   $0x803720
  801fe9:	e8 3d e9 ff ff       	call   80092b <_panic>

00801fee <open>:
{
  801fee:	55                   	push   %ebp
  801fef:	89 e5                	mov    %esp,%ebp
  801ff1:	56                   	push   %esi
  801ff2:	53                   	push   %ebx
  801ff3:	83 ec 1c             	sub    $0x1c,%esp
  801ff6:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801ff9:	56                   	push   %esi
  801ffa:	e8 48 f1 ff ff       	call   801147 <strlen>
  801fff:	83 c4 10             	add    $0x10,%esp
  802002:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802007:	7f 6c                	jg     802075 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  802009:	83 ec 0c             	sub    $0xc,%esp
  80200c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80200f:	50                   	push   %eax
  802010:	e8 79 f8 ff ff       	call   80188e <fd_alloc>
  802015:	89 c3                	mov    %eax,%ebx
  802017:	83 c4 10             	add    $0x10,%esp
  80201a:	85 c0                	test   %eax,%eax
  80201c:	78 3c                	js     80205a <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80201e:	83 ec 08             	sub    $0x8,%esp
  802021:	56                   	push   %esi
  802022:	68 00 60 80 00       	push   $0x806000
  802027:	e8 54 f1 ff ff       	call   801180 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80202c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80202f:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802034:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802037:	b8 01 00 00 00       	mov    $0x1,%eax
  80203c:	e8 b8 fd ff ff       	call   801df9 <fsipc>
  802041:	89 c3                	mov    %eax,%ebx
  802043:	83 c4 10             	add    $0x10,%esp
  802046:	85 c0                	test   %eax,%eax
  802048:	78 19                	js     802063 <open+0x75>
	return fd2num(fd);
  80204a:	83 ec 0c             	sub    $0xc,%esp
  80204d:	ff 75 f4             	pushl  -0xc(%ebp)
  802050:	e8 12 f8 ff ff       	call   801867 <fd2num>
  802055:	89 c3                	mov    %eax,%ebx
  802057:	83 c4 10             	add    $0x10,%esp
}
  80205a:	89 d8                	mov    %ebx,%eax
  80205c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80205f:	5b                   	pop    %ebx
  802060:	5e                   	pop    %esi
  802061:	5d                   	pop    %ebp
  802062:	c3                   	ret    
		fd_close(fd, 0);
  802063:	83 ec 08             	sub    $0x8,%esp
  802066:	6a 00                	push   $0x0
  802068:	ff 75 f4             	pushl  -0xc(%ebp)
  80206b:	e8 1b f9 ff ff       	call   80198b <fd_close>
		return r;
  802070:	83 c4 10             	add    $0x10,%esp
  802073:	eb e5                	jmp    80205a <open+0x6c>
		return -E_BAD_PATH;
  802075:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80207a:	eb de                	jmp    80205a <open+0x6c>

0080207c <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80207c:	55                   	push   %ebp
  80207d:	89 e5                	mov    %esp,%ebp
  80207f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802082:	ba 00 00 00 00       	mov    $0x0,%edx
  802087:	b8 08 00 00 00       	mov    $0x8,%eax
  80208c:	e8 68 fd ff ff       	call   801df9 <fsipc>
}
  802091:	c9                   	leave  
  802092:	c3                   	ret    

00802093 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802093:	55                   	push   %ebp
  802094:	89 e5                	mov    %esp,%ebp
  802096:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  802099:	68 37 37 80 00       	push   $0x803737
  80209e:	ff 75 0c             	pushl  0xc(%ebp)
  8020a1:	e8 da f0 ff ff       	call   801180 <strcpy>
	return 0;
}
  8020a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ab:	c9                   	leave  
  8020ac:	c3                   	ret    

008020ad <devsock_close>:
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
  8020b0:	53                   	push   %ebx
  8020b1:	83 ec 10             	sub    $0x10,%esp
  8020b4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8020b7:	53                   	push   %ebx
  8020b8:	e8 95 0c 00 00       	call   802d52 <pageref>
  8020bd:	83 c4 10             	add    $0x10,%esp
		return 0;
  8020c0:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8020c5:	83 f8 01             	cmp    $0x1,%eax
  8020c8:	74 07                	je     8020d1 <devsock_close+0x24>
}
  8020ca:	89 d0                	mov    %edx,%eax
  8020cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020cf:	c9                   	leave  
  8020d0:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8020d1:	83 ec 0c             	sub    $0xc,%esp
  8020d4:	ff 73 0c             	pushl  0xc(%ebx)
  8020d7:	e8 b9 02 00 00       	call   802395 <nsipc_close>
  8020dc:	89 c2                	mov    %eax,%edx
  8020de:	83 c4 10             	add    $0x10,%esp
  8020e1:	eb e7                	jmp    8020ca <devsock_close+0x1d>

008020e3 <devsock_write>:
{
  8020e3:	55                   	push   %ebp
  8020e4:	89 e5                	mov    %esp,%ebp
  8020e6:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8020e9:	6a 00                	push   $0x0
  8020eb:	ff 75 10             	pushl  0x10(%ebp)
  8020ee:	ff 75 0c             	pushl  0xc(%ebp)
  8020f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f4:	ff 70 0c             	pushl  0xc(%eax)
  8020f7:	e8 76 03 00 00       	call   802472 <nsipc_send>
}
  8020fc:	c9                   	leave  
  8020fd:	c3                   	ret    

008020fe <devsock_read>:
{
  8020fe:	55                   	push   %ebp
  8020ff:	89 e5                	mov    %esp,%ebp
  802101:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802104:	6a 00                	push   $0x0
  802106:	ff 75 10             	pushl  0x10(%ebp)
  802109:	ff 75 0c             	pushl  0xc(%ebp)
  80210c:	8b 45 08             	mov    0x8(%ebp),%eax
  80210f:	ff 70 0c             	pushl  0xc(%eax)
  802112:	e8 ef 02 00 00       	call   802406 <nsipc_recv>
}
  802117:	c9                   	leave  
  802118:	c3                   	ret    

00802119 <fd2sockid>:
{
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
  80211c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80211f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802122:	52                   	push   %edx
  802123:	50                   	push   %eax
  802124:	e8 b7 f7 ff ff       	call   8018e0 <fd_lookup>
  802129:	83 c4 10             	add    $0x10,%esp
  80212c:	85 c0                	test   %eax,%eax
  80212e:	78 10                	js     802140 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802130:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802133:	8b 0d 40 40 80 00    	mov    0x804040,%ecx
  802139:	39 08                	cmp    %ecx,(%eax)
  80213b:	75 05                	jne    802142 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80213d:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802140:	c9                   	leave  
  802141:	c3                   	ret    
		return -E_NOT_SUPP;
  802142:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802147:	eb f7                	jmp    802140 <fd2sockid+0x27>

00802149 <alloc_sockfd>:
{
  802149:	55                   	push   %ebp
  80214a:	89 e5                	mov    %esp,%ebp
  80214c:	56                   	push   %esi
  80214d:	53                   	push   %ebx
  80214e:	83 ec 1c             	sub    $0x1c,%esp
  802151:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802153:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802156:	50                   	push   %eax
  802157:	e8 32 f7 ff ff       	call   80188e <fd_alloc>
  80215c:	89 c3                	mov    %eax,%ebx
  80215e:	83 c4 10             	add    $0x10,%esp
  802161:	85 c0                	test   %eax,%eax
  802163:	78 43                	js     8021a8 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802165:	83 ec 04             	sub    $0x4,%esp
  802168:	68 07 04 00 00       	push   $0x407
  80216d:	ff 75 f4             	pushl  -0xc(%ebp)
  802170:	6a 00                	push   $0x0
  802172:	e8 fb f3 ff ff       	call   801572 <sys_page_alloc>
  802177:	89 c3                	mov    %eax,%ebx
  802179:	83 c4 10             	add    $0x10,%esp
  80217c:	85 c0                	test   %eax,%eax
  80217e:	78 28                	js     8021a8 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802180:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802183:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802189:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80218b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802195:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802198:	83 ec 0c             	sub    $0xc,%esp
  80219b:	50                   	push   %eax
  80219c:	e8 c6 f6 ff ff       	call   801867 <fd2num>
  8021a1:	89 c3                	mov    %eax,%ebx
  8021a3:	83 c4 10             	add    $0x10,%esp
  8021a6:	eb 0c                	jmp    8021b4 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8021a8:	83 ec 0c             	sub    $0xc,%esp
  8021ab:	56                   	push   %esi
  8021ac:	e8 e4 01 00 00       	call   802395 <nsipc_close>
		return r;
  8021b1:	83 c4 10             	add    $0x10,%esp
}
  8021b4:	89 d8                	mov    %ebx,%eax
  8021b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021b9:	5b                   	pop    %ebx
  8021ba:	5e                   	pop    %esi
  8021bb:	5d                   	pop    %ebp
  8021bc:	c3                   	ret    

008021bd <accept>:
{
  8021bd:	55                   	push   %ebp
  8021be:	89 e5                	mov    %esp,%ebp
  8021c0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c6:	e8 4e ff ff ff       	call   802119 <fd2sockid>
  8021cb:	85 c0                	test   %eax,%eax
  8021cd:	78 1b                	js     8021ea <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8021cf:	83 ec 04             	sub    $0x4,%esp
  8021d2:	ff 75 10             	pushl  0x10(%ebp)
  8021d5:	ff 75 0c             	pushl  0xc(%ebp)
  8021d8:	50                   	push   %eax
  8021d9:	e8 0e 01 00 00       	call   8022ec <nsipc_accept>
  8021de:	83 c4 10             	add    $0x10,%esp
  8021e1:	85 c0                	test   %eax,%eax
  8021e3:	78 05                	js     8021ea <accept+0x2d>
	return alloc_sockfd(r);
  8021e5:	e8 5f ff ff ff       	call   802149 <alloc_sockfd>
}
  8021ea:	c9                   	leave  
  8021eb:	c3                   	ret    

008021ec <bind>:
{
  8021ec:	55                   	push   %ebp
  8021ed:	89 e5                	mov    %esp,%ebp
  8021ef:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f5:	e8 1f ff ff ff       	call   802119 <fd2sockid>
  8021fa:	85 c0                	test   %eax,%eax
  8021fc:	78 12                	js     802210 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8021fe:	83 ec 04             	sub    $0x4,%esp
  802201:	ff 75 10             	pushl  0x10(%ebp)
  802204:	ff 75 0c             	pushl  0xc(%ebp)
  802207:	50                   	push   %eax
  802208:	e8 31 01 00 00       	call   80233e <nsipc_bind>
  80220d:	83 c4 10             	add    $0x10,%esp
}
  802210:	c9                   	leave  
  802211:	c3                   	ret    

00802212 <shutdown>:
{
  802212:	55                   	push   %ebp
  802213:	89 e5                	mov    %esp,%ebp
  802215:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802218:	8b 45 08             	mov    0x8(%ebp),%eax
  80221b:	e8 f9 fe ff ff       	call   802119 <fd2sockid>
  802220:	85 c0                	test   %eax,%eax
  802222:	78 0f                	js     802233 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802224:	83 ec 08             	sub    $0x8,%esp
  802227:	ff 75 0c             	pushl  0xc(%ebp)
  80222a:	50                   	push   %eax
  80222b:	e8 43 01 00 00       	call   802373 <nsipc_shutdown>
  802230:	83 c4 10             	add    $0x10,%esp
}
  802233:	c9                   	leave  
  802234:	c3                   	ret    

00802235 <connect>:
{
  802235:	55                   	push   %ebp
  802236:	89 e5                	mov    %esp,%ebp
  802238:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80223b:	8b 45 08             	mov    0x8(%ebp),%eax
  80223e:	e8 d6 fe ff ff       	call   802119 <fd2sockid>
  802243:	85 c0                	test   %eax,%eax
  802245:	78 12                	js     802259 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802247:	83 ec 04             	sub    $0x4,%esp
  80224a:	ff 75 10             	pushl  0x10(%ebp)
  80224d:	ff 75 0c             	pushl  0xc(%ebp)
  802250:	50                   	push   %eax
  802251:	e8 59 01 00 00       	call   8023af <nsipc_connect>
  802256:	83 c4 10             	add    $0x10,%esp
}
  802259:	c9                   	leave  
  80225a:	c3                   	ret    

0080225b <listen>:
{
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
  80225e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802261:	8b 45 08             	mov    0x8(%ebp),%eax
  802264:	e8 b0 fe ff ff       	call   802119 <fd2sockid>
  802269:	85 c0                	test   %eax,%eax
  80226b:	78 0f                	js     80227c <listen+0x21>
	return nsipc_listen(r, backlog);
  80226d:	83 ec 08             	sub    $0x8,%esp
  802270:	ff 75 0c             	pushl  0xc(%ebp)
  802273:	50                   	push   %eax
  802274:	e8 6b 01 00 00       	call   8023e4 <nsipc_listen>
  802279:	83 c4 10             	add    $0x10,%esp
}
  80227c:	c9                   	leave  
  80227d:	c3                   	ret    

0080227e <socket>:

int
socket(int domain, int type, int protocol)
{
  80227e:	55                   	push   %ebp
  80227f:	89 e5                	mov    %esp,%ebp
  802281:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802284:	ff 75 10             	pushl  0x10(%ebp)
  802287:	ff 75 0c             	pushl  0xc(%ebp)
  80228a:	ff 75 08             	pushl  0x8(%ebp)
  80228d:	e8 3e 02 00 00       	call   8024d0 <nsipc_socket>
  802292:	83 c4 10             	add    $0x10,%esp
  802295:	85 c0                	test   %eax,%eax
  802297:	78 05                	js     80229e <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802299:	e8 ab fe ff ff       	call   802149 <alloc_sockfd>
}
  80229e:	c9                   	leave  
  80229f:	c3                   	ret    

008022a0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8022a0:	55                   	push   %ebp
  8022a1:	89 e5                	mov    %esp,%ebp
  8022a3:	53                   	push   %ebx
  8022a4:	83 ec 04             	sub    $0x4,%esp
  8022a7:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8022a9:	83 3d 14 50 80 00 00 	cmpl   $0x0,0x805014
  8022b0:	74 26                	je     8022d8 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8022b2:	6a 07                	push   $0x7
  8022b4:	68 00 70 80 00       	push   $0x807000
  8022b9:	53                   	push   %ebx
  8022ba:	ff 35 14 50 80 00    	pushl  0x805014
  8022c0:	e8 fa 09 00 00       	call   802cbf <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8022c5:	83 c4 0c             	add    $0xc,%esp
  8022c8:	6a 00                	push   $0x0
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 00                	push   $0x0
  8022ce:	e8 83 09 00 00       	call   802c56 <ipc_recv>
}
  8022d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022d6:	c9                   	leave  
  8022d7:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8022d8:	83 ec 0c             	sub    $0xc,%esp
  8022db:	6a 02                	push   $0x2
  8022dd:	e8 35 0a 00 00       	call   802d17 <ipc_find_env>
  8022e2:	a3 14 50 80 00       	mov    %eax,0x805014
  8022e7:	83 c4 10             	add    $0x10,%esp
  8022ea:	eb c6                	jmp    8022b2 <nsipc+0x12>

008022ec <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8022ec:	55                   	push   %ebp
  8022ed:	89 e5                	mov    %esp,%ebp
  8022ef:	56                   	push   %esi
  8022f0:	53                   	push   %ebx
  8022f1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8022f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8022fc:	8b 06                	mov    (%esi),%eax
  8022fe:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802303:	b8 01 00 00 00       	mov    $0x1,%eax
  802308:	e8 93 ff ff ff       	call   8022a0 <nsipc>
  80230d:	89 c3                	mov    %eax,%ebx
  80230f:	85 c0                	test   %eax,%eax
  802311:	79 09                	jns    80231c <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802313:	89 d8                	mov    %ebx,%eax
  802315:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802318:	5b                   	pop    %ebx
  802319:	5e                   	pop    %esi
  80231a:	5d                   	pop    %ebp
  80231b:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80231c:	83 ec 04             	sub    $0x4,%esp
  80231f:	ff 35 10 70 80 00    	pushl  0x807010
  802325:	68 00 70 80 00       	push   $0x807000
  80232a:	ff 75 0c             	pushl  0xc(%ebp)
  80232d:	e8 dc ef ff ff       	call   80130e <memmove>
		*addrlen = ret->ret_addrlen;
  802332:	a1 10 70 80 00       	mov    0x807010,%eax
  802337:	89 06                	mov    %eax,(%esi)
  802339:	83 c4 10             	add    $0x10,%esp
	return r;
  80233c:	eb d5                	jmp    802313 <nsipc_accept+0x27>

0080233e <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80233e:	55                   	push   %ebp
  80233f:	89 e5                	mov    %esp,%ebp
  802341:	53                   	push   %ebx
  802342:	83 ec 08             	sub    $0x8,%esp
  802345:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802348:	8b 45 08             	mov    0x8(%ebp),%eax
  80234b:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802350:	53                   	push   %ebx
  802351:	ff 75 0c             	pushl  0xc(%ebp)
  802354:	68 04 70 80 00       	push   $0x807004
  802359:	e8 b0 ef ff ff       	call   80130e <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80235e:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802364:	b8 02 00 00 00       	mov    $0x2,%eax
  802369:	e8 32 ff ff ff       	call   8022a0 <nsipc>
}
  80236e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802371:	c9                   	leave  
  802372:	c3                   	ret    

00802373 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802373:	55                   	push   %ebp
  802374:	89 e5                	mov    %esp,%ebp
  802376:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802379:	8b 45 08             	mov    0x8(%ebp),%eax
  80237c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802381:	8b 45 0c             	mov    0xc(%ebp),%eax
  802384:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802389:	b8 03 00 00 00       	mov    $0x3,%eax
  80238e:	e8 0d ff ff ff       	call   8022a0 <nsipc>
}
  802393:	c9                   	leave  
  802394:	c3                   	ret    

00802395 <nsipc_close>:

int
nsipc_close(int s)
{
  802395:	55                   	push   %ebp
  802396:	89 e5                	mov    %esp,%ebp
  802398:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80239b:	8b 45 08             	mov    0x8(%ebp),%eax
  80239e:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8023a3:	b8 04 00 00 00       	mov    $0x4,%eax
  8023a8:	e8 f3 fe ff ff       	call   8022a0 <nsipc>
}
  8023ad:	c9                   	leave  
  8023ae:	c3                   	ret    

008023af <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8023af:	55                   	push   %ebp
  8023b0:	89 e5                	mov    %esp,%ebp
  8023b2:	53                   	push   %ebx
  8023b3:	83 ec 08             	sub    $0x8,%esp
  8023b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8023b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bc:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8023c1:	53                   	push   %ebx
  8023c2:	ff 75 0c             	pushl  0xc(%ebp)
  8023c5:	68 04 70 80 00       	push   $0x807004
  8023ca:	e8 3f ef ff ff       	call   80130e <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8023cf:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8023d5:	b8 05 00 00 00       	mov    $0x5,%eax
  8023da:	e8 c1 fe ff ff       	call   8022a0 <nsipc>
}
  8023df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023e2:	c9                   	leave  
  8023e3:	c3                   	ret    

008023e4 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8023e4:	55                   	push   %ebp
  8023e5:	89 e5                	mov    %esp,%ebp
  8023e7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8023ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ed:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8023f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023f5:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8023fa:	b8 06 00 00 00       	mov    $0x6,%eax
  8023ff:	e8 9c fe ff ff       	call   8022a0 <nsipc>
}
  802404:	c9                   	leave  
  802405:	c3                   	ret    

00802406 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802406:	55                   	push   %ebp
  802407:	89 e5                	mov    %esp,%ebp
  802409:	56                   	push   %esi
  80240a:	53                   	push   %ebx
  80240b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80240e:	8b 45 08             	mov    0x8(%ebp),%eax
  802411:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802416:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80241c:	8b 45 14             	mov    0x14(%ebp),%eax
  80241f:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802424:	b8 07 00 00 00       	mov    $0x7,%eax
  802429:	e8 72 fe ff ff       	call   8022a0 <nsipc>
  80242e:	89 c3                	mov    %eax,%ebx
  802430:	85 c0                	test   %eax,%eax
  802432:	78 1f                	js     802453 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802434:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802439:	7f 21                	jg     80245c <nsipc_recv+0x56>
  80243b:	39 c6                	cmp    %eax,%esi
  80243d:	7c 1d                	jl     80245c <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80243f:	83 ec 04             	sub    $0x4,%esp
  802442:	50                   	push   %eax
  802443:	68 00 70 80 00       	push   $0x807000
  802448:	ff 75 0c             	pushl  0xc(%ebp)
  80244b:	e8 be ee ff ff       	call   80130e <memmove>
  802450:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802453:	89 d8                	mov    %ebx,%eax
  802455:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802458:	5b                   	pop    %ebx
  802459:	5e                   	pop    %esi
  80245a:	5d                   	pop    %ebp
  80245b:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80245c:	68 43 37 80 00       	push   $0x803743
  802461:	68 0b 37 80 00       	push   $0x80370b
  802466:	6a 62                	push   $0x62
  802468:	68 58 37 80 00       	push   $0x803758
  80246d:	e8 b9 e4 ff ff       	call   80092b <_panic>

00802472 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802472:	55                   	push   %ebp
  802473:	89 e5                	mov    %esp,%ebp
  802475:	53                   	push   %ebx
  802476:	83 ec 04             	sub    $0x4,%esp
  802479:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80247c:	8b 45 08             	mov    0x8(%ebp),%eax
  80247f:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802484:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80248a:	7f 2e                	jg     8024ba <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80248c:	83 ec 04             	sub    $0x4,%esp
  80248f:	53                   	push   %ebx
  802490:	ff 75 0c             	pushl  0xc(%ebp)
  802493:	68 0c 70 80 00       	push   $0x80700c
  802498:	e8 71 ee ff ff       	call   80130e <memmove>
	nsipcbuf.send.req_size = size;
  80249d:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8024a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8024a6:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8024ab:	b8 08 00 00 00       	mov    $0x8,%eax
  8024b0:	e8 eb fd ff ff       	call   8022a0 <nsipc>
}
  8024b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024b8:	c9                   	leave  
  8024b9:	c3                   	ret    
	assert(size < 1600);
  8024ba:	68 64 37 80 00       	push   $0x803764
  8024bf:	68 0b 37 80 00       	push   $0x80370b
  8024c4:	6a 6d                	push   $0x6d
  8024c6:	68 58 37 80 00       	push   $0x803758
  8024cb:	e8 5b e4 ff ff       	call   80092b <_panic>

008024d0 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8024d0:	55                   	push   %ebp
  8024d1:	89 e5                	mov    %esp,%ebp
  8024d3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8024d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8024de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024e1:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8024e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8024e9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8024ee:	b8 09 00 00 00       	mov    $0x9,%eax
  8024f3:	e8 a8 fd ff ff       	call   8022a0 <nsipc>
}
  8024f8:	c9                   	leave  
  8024f9:	c3                   	ret    

008024fa <free>:
	return v;
}

void
free(void *v)
{
  8024fa:	55                   	push   %ebp
  8024fb:	89 e5                	mov    %esp,%ebp
  8024fd:	53                   	push   %ebx
  8024fe:	83 ec 04             	sub    $0x4,%esp
  802501:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
  802504:	85 db                	test   %ebx,%ebx
  802506:	0f 84 85 00 00 00    	je     802591 <free+0x97>
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  80250c:	8d 83 00 00 00 f8    	lea    -0x8000000(%ebx),%eax
  802512:	3d ff ff ff 07       	cmp    $0x7ffffff,%eax
  802517:	77 51                	ja     80256a <free+0x70>

	c = ROUNDDOWN(v, PGSIZE);
  802519:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  80251f:	89 d8                	mov    %ebx,%eax
  802521:	c1 e8 0c             	shr    $0xc,%eax
  802524:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80252b:	f6 c4 02             	test   $0x2,%ah
  80252e:	74 50                	je     802580 <free+0x86>
		sys_page_unmap(0, c);
  802530:	83 ec 08             	sub    $0x8,%esp
  802533:	53                   	push   %ebx
  802534:	6a 00                	push   $0x0
  802536:	e8 bc f0 ff ff       	call   8015f7 <sys_page_unmap>
		c += PGSIZE;
  80253b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		assert(mbegin <= c && c < mend);
  802541:	8d 83 00 00 00 f8    	lea    -0x8000000(%ebx),%eax
  802547:	83 c4 10             	add    $0x10,%esp
  80254a:	3d ff ff ff 07       	cmp    $0x7ffffff,%eax
  80254f:	76 ce                	jbe    80251f <free+0x25>
  802551:	68 ad 37 80 00       	push   $0x8037ad
  802556:	68 0b 37 80 00       	push   $0x80370b
  80255b:	68 81 00 00 00       	push   $0x81
  802560:	68 a0 37 80 00       	push   $0x8037a0
  802565:	e8 c1 e3 ff ff       	call   80092b <_panic>
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  80256a:	68 70 37 80 00       	push   $0x803770
  80256f:	68 0b 37 80 00       	push   $0x80370b
  802574:	6a 7a                	push   $0x7a
  802576:	68 a0 37 80 00       	push   $0x8037a0
  80257b:	e8 ab e3 ff ff       	call   80092b <_panic>
	/*
	 * c is just a piece of this page, so dec the ref count
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
	if (--(*ref) == 0)
  802580:	8b 83 fc 0f 00 00    	mov    0xffc(%ebx),%eax
  802586:	83 e8 01             	sub    $0x1,%eax
  802589:	89 83 fc 0f 00 00    	mov    %eax,0xffc(%ebx)
  80258f:	74 05                	je     802596 <free+0x9c>
		sys_page_unmap(0, c);
}
  802591:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802594:	c9                   	leave  
  802595:	c3                   	ret    
		sys_page_unmap(0, c);
  802596:	83 ec 08             	sub    $0x8,%esp
  802599:	53                   	push   %ebx
  80259a:	6a 00                	push   $0x0
  80259c:	e8 56 f0 ff ff       	call   8015f7 <sys_page_unmap>
  8025a1:	83 c4 10             	add    $0x10,%esp
  8025a4:	eb eb                	jmp    802591 <free+0x97>

008025a6 <malloc>:
{
  8025a6:	55                   	push   %ebp
  8025a7:	89 e5                	mov    %esp,%ebp
  8025a9:	57                   	push   %edi
  8025aa:	56                   	push   %esi
  8025ab:	53                   	push   %ebx
  8025ac:	83 ec 1c             	sub    $0x1c,%esp
	if (mptr == 0)
  8025af:	a1 18 50 80 00       	mov    0x805018,%eax
  8025b4:	85 c0                	test   %eax,%eax
  8025b6:	74 74                	je     80262c <malloc+0x86>
	n = ROUNDUP(n, 4);
  8025b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025bb:	8d 51 03             	lea    0x3(%ecx),%edx
  8025be:	83 e2 fc             	and    $0xfffffffc,%edx
  8025c1:	89 d6                	mov    %edx,%esi
  8025c3:	89 55 dc             	mov    %edx,-0x24(%ebp)
	if (n >= MAXMALLOC)
  8025c6:	81 fa ff ff 0f 00    	cmp    $0xfffff,%edx
  8025cc:	0f 87 55 01 00 00    	ja     802727 <malloc+0x181>
	if ((uintptr_t) mptr % PGSIZE){
  8025d2:	89 c1                	mov    %eax,%ecx
  8025d4:	a9 ff 0f 00 00       	test   $0xfff,%eax
  8025d9:	74 30                	je     80260b <malloc+0x65>
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
  8025db:	89 c3                	mov    %eax,%ebx
  8025dd:	c1 eb 0c             	shr    $0xc,%ebx
  8025e0:	8d 54 10 03          	lea    0x3(%eax,%edx,1),%edx
  8025e4:	c1 ea 0c             	shr    $0xc,%edx
  8025e7:	39 d3                	cmp    %edx,%ebx
  8025e9:	74 64                	je     80264f <malloc+0xa9>
		free(mptr);	/* drop reference to this page */
  8025eb:	83 ec 0c             	sub    $0xc,%esp
  8025ee:	50                   	push   %eax
  8025ef:	e8 06 ff ff ff       	call   8024fa <free>
		mptr = ROUNDDOWN(mptr + PGSIZE, PGSIZE);
  8025f4:	a1 18 50 80 00       	mov    0x805018,%eax
  8025f9:	05 00 10 00 00       	add    $0x1000,%eax
  8025fe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802603:	a3 18 50 80 00       	mov    %eax,0x805018
  802608:	83 c4 10             	add    $0x10,%esp
  80260b:	8b 15 18 50 80 00    	mov    0x805018,%edx
{
  802611:	c7 45 d8 02 00 00 00 	movl   $0x2,-0x28(%ebp)
  802618:	be 00 00 00 00       	mov    $0x0,%esi
		if (isfree(mptr, n + 4))
  80261d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802620:	8d 78 04             	lea    0x4(%eax),%edi
  802623:	c6 45 e3 01          	movb   $0x1,-0x1d(%ebp)
  802627:	e9 86 00 00 00       	jmp    8026b2 <malloc+0x10c>
		mptr = mbegin;
  80262c:	c7 05 18 50 80 00 00 	movl   $0x8000000,0x805018
  802633:	00 00 08 
	n = ROUNDUP(n, 4);
  802636:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802639:	8d 51 03             	lea    0x3(%ecx),%edx
  80263c:	83 e2 fc             	and    $0xfffffffc,%edx
  80263f:	89 55 dc             	mov    %edx,-0x24(%ebp)
	if (n >= MAXMALLOC)
  802642:	81 fa ff ff 0f 00    	cmp    $0xfffff,%edx
  802648:	76 c1                	jbe    80260b <malloc+0x65>
  80264a:	e9 fd 00 00 00       	jmp    80274c <malloc+0x1a6>
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
  80264f:	81 c1 ff 0f 00 00    	add    $0xfff,%ecx
  802655:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
			(*ref)++;
  80265b:	83 41 fc 01          	addl   $0x1,-0x4(%ecx)
			mptr += n;
  80265f:	89 f2                	mov    %esi,%edx
  802661:	01 c2                	add    %eax,%edx
  802663:	89 15 18 50 80 00    	mov    %edx,0x805018
			return v;
  802669:	e9 de 00 00 00       	jmp    80274c <malloc+0x1a6>
	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  80266e:	05 00 10 00 00       	add    $0x1000,%eax
  802673:	39 c8                	cmp    %ecx,%eax
  802675:	73 66                	jae    8026dd <malloc+0x137>
		if (va >= (uintptr_t) mend
  802677:	3d ff ff ff 0f       	cmp    $0xfffffff,%eax
  80267c:	77 22                	ja     8026a0 <malloc+0xfa>
		    || ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
  80267e:	89 c3                	mov    %eax,%ebx
  802680:	c1 eb 16             	shr    $0x16,%ebx
  802683:	8b 1c 9d 00 d0 7b ef 	mov    -0x10843000(,%ebx,4),%ebx
  80268a:	f6 c3 01             	test   $0x1,%bl
  80268d:	74 df                	je     80266e <malloc+0xc8>
  80268f:	89 c3                	mov    %eax,%ebx
  802691:	c1 eb 0c             	shr    $0xc,%ebx
  802694:	8b 1c 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%ebx
  80269b:	f6 c3 01             	test   $0x1,%bl
  80269e:	74 ce                	je     80266e <malloc+0xc8>
  8026a0:	81 c2 00 10 00 00    	add    $0x1000,%edx
  8026a6:	0f b6 75 e3          	movzbl -0x1d(%ebp),%esi
		if (mptr == mend) {
  8026aa:	81 fa 00 00 00 10    	cmp    $0x10000000,%edx
  8026b0:	74 0a                	je     8026bc <malloc+0x116>
  8026b2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  8026b5:	89 d0                	mov    %edx,%eax
  8026b7:	8d 0c 17             	lea    (%edi,%edx,1),%ecx
  8026ba:	eb b7                	jmp    802673 <malloc+0xcd>
			mptr = mbegin;
  8026bc:	ba 00 00 00 08       	mov    $0x8000000,%edx
  8026c1:	be 01 00 00 00       	mov    $0x1,%esi
			if (++nwrap == 2)
  8026c6:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8026ca:	75 e6                	jne    8026b2 <malloc+0x10c>
  8026cc:	c7 05 18 50 80 00 00 	movl   $0x8000000,0x805018
  8026d3:	00 00 08 
				return 0;	/* out of address space */
  8026d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8026db:	eb 6f                	jmp    80274c <malloc+0x1a6>
  8026dd:	89 f0                	mov    %esi,%eax
  8026df:	84 c0                	test   %al,%al
  8026e1:	74 08                	je     8026eb <malloc+0x145>
  8026e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e6:	a3 18 50 80 00       	mov    %eax,0x805018
	for (i = 0; i < n + 4; i += PGSIZE){
  8026eb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026f0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
  8026f3:	8d b3 00 10 00 00    	lea    0x1000(%ebx),%esi
  8026f9:	39 f7                	cmp    %esi,%edi
  8026fb:	76 57                	jbe    802754 <malloc+0x1ae>
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  8026fd:	83 ec 04             	sub    $0x4,%esp
  802700:	68 07 02 00 00       	push   $0x207
  802705:	89 d8                	mov    %ebx,%eax
  802707:	03 05 18 50 80 00    	add    0x805018,%eax
  80270d:	50                   	push   %eax
  80270e:	6a 00                	push   $0x0
  802710:	e8 5d ee ff ff       	call   801572 <sys_page_alloc>
  802715:	83 c4 10             	add    $0x10,%esp
  802718:	85 c0                	test   %eax,%eax
  80271a:	78 55                	js     802771 <malloc+0x1cb>
	for (i = 0; i < n + 4; i += PGSIZE){
  80271c:	89 f3                	mov    %esi,%ebx
  80271e:	eb d0                	jmp    8026f0 <malloc+0x14a>
			return 0;	/* out of physical memory */
  802720:	b8 00 00 00 00       	mov    $0x0,%eax
  802725:	eb 25                	jmp    80274c <malloc+0x1a6>
		return 0;
  802727:	b8 00 00 00 00       	mov    $0x0,%eax
  80272c:	eb 1e                	jmp    80274c <malloc+0x1a6>
	ref = (uint32_t*) (mptr + i - 4);
  80272e:	a1 18 50 80 00       	mov    0x805018,%eax
	*ref = 2;	/* reference for mptr, reference for returned block */
  802733:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  802736:	c7 84 08 fc 0f 00 00 	movl   $0x2,0xffc(%eax,%ecx,1)
  80273d:	02 00 00 00 
	mptr += n;
  802741:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802744:	01 c2                	add    %eax,%edx
  802746:	89 15 18 50 80 00    	mov    %edx,0x805018
}
  80274c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80274f:	5b                   	pop    %ebx
  802750:	5e                   	pop    %esi
  802751:	5f                   	pop    %edi
  802752:	5d                   	pop    %ebp
  802753:	c3                   	ret    
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  802754:	83 ec 04             	sub    $0x4,%esp
  802757:	6a 07                	push   $0x7
  802759:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80275c:	03 05 18 50 80 00    	add    0x805018,%eax
  802762:	50                   	push   %eax
  802763:	6a 00                	push   $0x0
  802765:	e8 08 ee ff ff       	call   801572 <sys_page_alloc>
  80276a:	83 c4 10             	add    $0x10,%esp
  80276d:	85 c0                	test   %eax,%eax
  80276f:	79 bd                	jns    80272e <malloc+0x188>
			for (; i >= 0; i -= PGSIZE)
  802771:	85 db                	test   %ebx,%ebx
  802773:	78 ab                	js     802720 <malloc+0x17a>
				sys_page_unmap(0, mptr + i);
  802775:	83 ec 08             	sub    $0x8,%esp
  802778:	89 d8                	mov    %ebx,%eax
  80277a:	03 05 18 50 80 00    	add    0x805018,%eax
  802780:	50                   	push   %eax
  802781:	6a 00                	push   $0x0
  802783:	e8 6f ee ff ff       	call   8015f7 <sys_page_unmap>
			for (; i >= 0; i -= PGSIZE)
  802788:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
  80278e:	83 c4 10             	add    $0x10,%esp
  802791:	eb de                	jmp    802771 <malloc+0x1cb>

00802793 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802793:	55                   	push   %ebp
  802794:	89 e5                	mov    %esp,%ebp
  802796:	56                   	push   %esi
  802797:	53                   	push   %ebx
  802798:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80279b:	83 ec 0c             	sub    $0xc,%esp
  80279e:	ff 75 08             	pushl  0x8(%ebp)
  8027a1:	e8 d1 f0 ff ff       	call   801877 <fd2data>
  8027a6:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8027a8:	83 c4 08             	add    $0x8,%esp
  8027ab:	68 c5 37 80 00       	push   $0x8037c5
  8027b0:	53                   	push   %ebx
  8027b1:	e8 ca e9 ff ff       	call   801180 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8027b6:	8b 46 04             	mov    0x4(%esi),%eax
  8027b9:	2b 06                	sub    (%esi),%eax
  8027bb:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8027c1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8027c8:	00 00 00 
	stat->st_dev = &devpipe;
  8027cb:	c7 83 88 00 00 00 5c 	movl   $0x80405c,0x88(%ebx)
  8027d2:	40 80 00 
	return 0;
}
  8027d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8027da:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027dd:	5b                   	pop    %ebx
  8027de:	5e                   	pop    %esi
  8027df:	5d                   	pop    %ebp
  8027e0:	c3                   	ret    

008027e1 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8027e1:	55                   	push   %ebp
  8027e2:	89 e5                	mov    %esp,%ebp
  8027e4:	53                   	push   %ebx
  8027e5:	83 ec 0c             	sub    $0xc,%esp
  8027e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8027eb:	53                   	push   %ebx
  8027ec:	6a 00                	push   $0x0
  8027ee:	e8 04 ee ff ff       	call   8015f7 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8027f3:	89 1c 24             	mov    %ebx,(%esp)
  8027f6:	e8 7c f0 ff ff       	call   801877 <fd2data>
  8027fb:	83 c4 08             	add    $0x8,%esp
  8027fe:	50                   	push   %eax
  8027ff:	6a 00                	push   $0x0
  802801:	e8 f1 ed ff ff       	call   8015f7 <sys_page_unmap>
}
  802806:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802809:	c9                   	leave  
  80280a:	c3                   	ret    

0080280b <_pipeisclosed>:
{
  80280b:	55                   	push   %ebp
  80280c:	89 e5                	mov    %esp,%ebp
  80280e:	57                   	push   %edi
  80280f:	56                   	push   %esi
  802810:	53                   	push   %ebx
  802811:	83 ec 1c             	sub    $0x1c,%esp
  802814:	89 c7                	mov    %eax,%edi
  802816:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802818:	a1 1c 50 80 00       	mov    0x80501c,%eax
  80281d:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802820:	83 ec 0c             	sub    $0xc,%esp
  802823:	57                   	push   %edi
  802824:	e8 29 05 00 00       	call   802d52 <pageref>
  802829:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80282c:	89 34 24             	mov    %esi,(%esp)
  80282f:	e8 1e 05 00 00       	call   802d52 <pageref>
		nn = thisenv->env_runs;
  802834:	8b 15 1c 50 80 00    	mov    0x80501c,%edx
  80283a:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80283d:	83 c4 10             	add    $0x10,%esp
  802840:	39 cb                	cmp    %ecx,%ebx
  802842:	74 1b                	je     80285f <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802844:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802847:	75 cf                	jne    802818 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802849:	8b 42 58             	mov    0x58(%edx),%eax
  80284c:	6a 01                	push   $0x1
  80284e:	50                   	push   %eax
  80284f:	53                   	push   %ebx
  802850:	68 cc 37 80 00       	push   $0x8037cc
  802855:	e8 c7 e1 ff ff       	call   800a21 <cprintf>
  80285a:	83 c4 10             	add    $0x10,%esp
  80285d:	eb b9                	jmp    802818 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80285f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802862:	0f 94 c0             	sete   %al
  802865:	0f b6 c0             	movzbl %al,%eax
}
  802868:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80286b:	5b                   	pop    %ebx
  80286c:	5e                   	pop    %esi
  80286d:	5f                   	pop    %edi
  80286e:	5d                   	pop    %ebp
  80286f:	c3                   	ret    

00802870 <devpipe_write>:
{
  802870:	55                   	push   %ebp
  802871:	89 e5                	mov    %esp,%ebp
  802873:	57                   	push   %edi
  802874:	56                   	push   %esi
  802875:	53                   	push   %ebx
  802876:	83 ec 28             	sub    $0x28,%esp
  802879:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80287c:	56                   	push   %esi
  80287d:	e8 f5 ef ff ff       	call   801877 <fd2data>
  802882:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802884:	83 c4 10             	add    $0x10,%esp
  802887:	bf 00 00 00 00       	mov    $0x0,%edi
  80288c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80288f:	74 4f                	je     8028e0 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802891:	8b 43 04             	mov    0x4(%ebx),%eax
  802894:	8b 0b                	mov    (%ebx),%ecx
  802896:	8d 51 20             	lea    0x20(%ecx),%edx
  802899:	39 d0                	cmp    %edx,%eax
  80289b:	72 14                	jb     8028b1 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80289d:	89 da                	mov    %ebx,%edx
  80289f:	89 f0                	mov    %esi,%eax
  8028a1:	e8 65 ff ff ff       	call   80280b <_pipeisclosed>
  8028a6:	85 c0                	test   %eax,%eax
  8028a8:	75 3b                	jne    8028e5 <devpipe_write+0x75>
			sys_yield();
  8028aa:	e8 a4 ec ff ff       	call   801553 <sys_yield>
  8028af:	eb e0                	jmp    802891 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8028b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8028b4:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8028b8:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8028bb:	89 c2                	mov    %eax,%edx
  8028bd:	c1 fa 1f             	sar    $0x1f,%edx
  8028c0:	89 d1                	mov    %edx,%ecx
  8028c2:	c1 e9 1b             	shr    $0x1b,%ecx
  8028c5:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8028c8:	83 e2 1f             	and    $0x1f,%edx
  8028cb:	29 ca                	sub    %ecx,%edx
  8028cd:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8028d1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8028d5:	83 c0 01             	add    $0x1,%eax
  8028d8:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8028db:	83 c7 01             	add    $0x1,%edi
  8028de:	eb ac                	jmp    80288c <devpipe_write+0x1c>
	return i;
  8028e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8028e3:	eb 05                	jmp    8028ea <devpipe_write+0x7a>
				return 0;
  8028e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028ed:	5b                   	pop    %ebx
  8028ee:	5e                   	pop    %esi
  8028ef:	5f                   	pop    %edi
  8028f0:	5d                   	pop    %ebp
  8028f1:	c3                   	ret    

008028f2 <devpipe_read>:
{
  8028f2:	55                   	push   %ebp
  8028f3:	89 e5                	mov    %esp,%ebp
  8028f5:	57                   	push   %edi
  8028f6:	56                   	push   %esi
  8028f7:	53                   	push   %ebx
  8028f8:	83 ec 18             	sub    $0x18,%esp
  8028fb:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8028fe:	57                   	push   %edi
  8028ff:	e8 73 ef ff ff       	call   801877 <fd2data>
  802904:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802906:	83 c4 10             	add    $0x10,%esp
  802909:	be 00 00 00 00       	mov    $0x0,%esi
  80290e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802911:	75 14                	jne    802927 <devpipe_read+0x35>
	return i;
  802913:	8b 45 10             	mov    0x10(%ebp),%eax
  802916:	eb 02                	jmp    80291a <devpipe_read+0x28>
				return i;
  802918:	89 f0                	mov    %esi,%eax
}
  80291a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80291d:	5b                   	pop    %ebx
  80291e:	5e                   	pop    %esi
  80291f:	5f                   	pop    %edi
  802920:	5d                   	pop    %ebp
  802921:	c3                   	ret    
			sys_yield();
  802922:	e8 2c ec ff ff       	call   801553 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802927:	8b 03                	mov    (%ebx),%eax
  802929:	3b 43 04             	cmp    0x4(%ebx),%eax
  80292c:	75 18                	jne    802946 <devpipe_read+0x54>
			if (i > 0)
  80292e:	85 f6                	test   %esi,%esi
  802930:	75 e6                	jne    802918 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802932:	89 da                	mov    %ebx,%edx
  802934:	89 f8                	mov    %edi,%eax
  802936:	e8 d0 fe ff ff       	call   80280b <_pipeisclosed>
  80293b:	85 c0                	test   %eax,%eax
  80293d:	74 e3                	je     802922 <devpipe_read+0x30>
				return 0;
  80293f:	b8 00 00 00 00       	mov    $0x0,%eax
  802944:	eb d4                	jmp    80291a <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802946:	99                   	cltd   
  802947:	c1 ea 1b             	shr    $0x1b,%edx
  80294a:	01 d0                	add    %edx,%eax
  80294c:	83 e0 1f             	and    $0x1f,%eax
  80294f:	29 d0                	sub    %edx,%eax
  802951:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802956:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802959:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80295c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80295f:	83 c6 01             	add    $0x1,%esi
  802962:	eb aa                	jmp    80290e <devpipe_read+0x1c>

00802964 <pipe>:
{
  802964:	55                   	push   %ebp
  802965:	89 e5                	mov    %esp,%ebp
  802967:	56                   	push   %esi
  802968:	53                   	push   %ebx
  802969:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80296c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80296f:	50                   	push   %eax
  802970:	e8 19 ef ff ff       	call   80188e <fd_alloc>
  802975:	89 c3                	mov    %eax,%ebx
  802977:	83 c4 10             	add    $0x10,%esp
  80297a:	85 c0                	test   %eax,%eax
  80297c:	0f 88 23 01 00 00    	js     802aa5 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802982:	83 ec 04             	sub    $0x4,%esp
  802985:	68 07 04 00 00       	push   $0x407
  80298a:	ff 75 f4             	pushl  -0xc(%ebp)
  80298d:	6a 00                	push   $0x0
  80298f:	e8 de eb ff ff       	call   801572 <sys_page_alloc>
  802994:	89 c3                	mov    %eax,%ebx
  802996:	83 c4 10             	add    $0x10,%esp
  802999:	85 c0                	test   %eax,%eax
  80299b:	0f 88 04 01 00 00    	js     802aa5 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8029a1:	83 ec 0c             	sub    $0xc,%esp
  8029a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8029a7:	50                   	push   %eax
  8029a8:	e8 e1 ee ff ff       	call   80188e <fd_alloc>
  8029ad:	89 c3                	mov    %eax,%ebx
  8029af:	83 c4 10             	add    $0x10,%esp
  8029b2:	85 c0                	test   %eax,%eax
  8029b4:	0f 88 db 00 00 00    	js     802a95 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8029ba:	83 ec 04             	sub    $0x4,%esp
  8029bd:	68 07 04 00 00       	push   $0x407
  8029c2:	ff 75 f0             	pushl  -0x10(%ebp)
  8029c5:	6a 00                	push   $0x0
  8029c7:	e8 a6 eb ff ff       	call   801572 <sys_page_alloc>
  8029cc:	89 c3                	mov    %eax,%ebx
  8029ce:	83 c4 10             	add    $0x10,%esp
  8029d1:	85 c0                	test   %eax,%eax
  8029d3:	0f 88 bc 00 00 00    	js     802a95 <pipe+0x131>
	va = fd2data(fd0);
  8029d9:	83 ec 0c             	sub    $0xc,%esp
  8029dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8029df:	e8 93 ee ff ff       	call   801877 <fd2data>
  8029e4:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8029e6:	83 c4 0c             	add    $0xc,%esp
  8029e9:	68 07 04 00 00       	push   $0x407
  8029ee:	50                   	push   %eax
  8029ef:	6a 00                	push   $0x0
  8029f1:	e8 7c eb ff ff       	call   801572 <sys_page_alloc>
  8029f6:	89 c3                	mov    %eax,%ebx
  8029f8:	83 c4 10             	add    $0x10,%esp
  8029fb:	85 c0                	test   %eax,%eax
  8029fd:	0f 88 82 00 00 00    	js     802a85 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a03:	83 ec 0c             	sub    $0xc,%esp
  802a06:	ff 75 f0             	pushl  -0x10(%ebp)
  802a09:	e8 69 ee ff ff       	call   801877 <fd2data>
  802a0e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802a15:	50                   	push   %eax
  802a16:	6a 00                	push   $0x0
  802a18:	56                   	push   %esi
  802a19:	6a 00                	push   $0x0
  802a1b:	e8 95 eb ff ff       	call   8015b5 <sys_page_map>
  802a20:	89 c3                	mov    %eax,%ebx
  802a22:	83 c4 20             	add    $0x20,%esp
  802a25:	85 c0                	test   %eax,%eax
  802a27:	78 4e                	js     802a77 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802a29:	a1 5c 40 80 00       	mov    0x80405c,%eax
  802a2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a31:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802a33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a36:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802a3d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a40:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a45:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802a4c:	83 ec 0c             	sub    $0xc,%esp
  802a4f:	ff 75 f4             	pushl  -0xc(%ebp)
  802a52:	e8 10 ee ff ff       	call   801867 <fd2num>
  802a57:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802a5a:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802a5c:	83 c4 04             	add    $0x4,%esp
  802a5f:	ff 75 f0             	pushl  -0x10(%ebp)
  802a62:	e8 00 ee ff ff       	call   801867 <fd2num>
  802a67:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802a6a:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802a6d:	83 c4 10             	add    $0x10,%esp
  802a70:	bb 00 00 00 00       	mov    $0x0,%ebx
  802a75:	eb 2e                	jmp    802aa5 <pipe+0x141>
	sys_page_unmap(0, va);
  802a77:	83 ec 08             	sub    $0x8,%esp
  802a7a:	56                   	push   %esi
  802a7b:	6a 00                	push   $0x0
  802a7d:	e8 75 eb ff ff       	call   8015f7 <sys_page_unmap>
  802a82:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802a85:	83 ec 08             	sub    $0x8,%esp
  802a88:	ff 75 f0             	pushl  -0x10(%ebp)
  802a8b:	6a 00                	push   $0x0
  802a8d:	e8 65 eb ff ff       	call   8015f7 <sys_page_unmap>
  802a92:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802a95:	83 ec 08             	sub    $0x8,%esp
  802a98:	ff 75 f4             	pushl  -0xc(%ebp)
  802a9b:	6a 00                	push   $0x0
  802a9d:	e8 55 eb ff ff       	call   8015f7 <sys_page_unmap>
  802aa2:	83 c4 10             	add    $0x10,%esp
}
  802aa5:	89 d8                	mov    %ebx,%eax
  802aa7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802aaa:	5b                   	pop    %ebx
  802aab:	5e                   	pop    %esi
  802aac:	5d                   	pop    %ebp
  802aad:	c3                   	ret    

00802aae <pipeisclosed>:
{
  802aae:	55                   	push   %ebp
  802aaf:	89 e5                	mov    %esp,%ebp
  802ab1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ab4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ab7:	50                   	push   %eax
  802ab8:	ff 75 08             	pushl  0x8(%ebp)
  802abb:	e8 20 ee ff ff       	call   8018e0 <fd_lookup>
  802ac0:	83 c4 10             	add    $0x10,%esp
  802ac3:	85 c0                	test   %eax,%eax
  802ac5:	78 18                	js     802adf <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802ac7:	83 ec 0c             	sub    $0xc,%esp
  802aca:	ff 75 f4             	pushl  -0xc(%ebp)
  802acd:	e8 a5 ed ff ff       	call   801877 <fd2data>
	return _pipeisclosed(fd, p);
  802ad2:	89 c2                	mov    %eax,%edx
  802ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad7:	e8 2f fd ff ff       	call   80280b <_pipeisclosed>
  802adc:	83 c4 10             	add    $0x10,%esp
}
  802adf:	c9                   	leave  
  802ae0:	c3                   	ret    

00802ae1 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802ae1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae6:	c3                   	ret    

00802ae7 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802ae7:	55                   	push   %ebp
  802ae8:	89 e5                	mov    %esp,%ebp
  802aea:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802aed:	68 e4 37 80 00       	push   $0x8037e4
  802af2:	ff 75 0c             	pushl  0xc(%ebp)
  802af5:	e8 86 e6 ff ff       	call   801180 <strcpy>
	return 0;
}
  802afa:	b8 00 00 00 00       	mov    $0x0,%eax
  802aff:	c9                   	leave  
  802b00:	c3                   	ret    

00802b01 <devcons_write>:
{
  802b01:	55                   	push   %ebp
  802b02:	89 e5                	mov    %esp,%ebp
  802b04:	57                   	push   %edi
  802b05:	56                   	push   %esi
  802b06:	53                   	push   %ebx
  802b07:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802b0d:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802b12:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802b18:	3b 75 10             	cmp    0x10(%ebp),%esi
  802b1b:	73 31                	jae    802b4e <devcons_write+0x4d>
		m = n - tot;
  802b1d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802b20:	29 f3                	sub    %esi,%ebx
  802b22:	83 fb 7f             	cmp    $0x7f,%ebx
  802b25:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802b2a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802b2d:	83 ec 04             	sub    $0x4,%esp
  802b30:	53                   	push   %ebx
  802b31:	89 f0                	mov    %esi,%eax
  802b33:	03 45 0c             	add    0xc(%ebp),%eax
  802b36:	50                   	push   %eax
  802b37:	57                   	push   %edi
  802b38:	e8 d1 e7 ff ff       	call   80130e <memmove>
		sys_cputs(buf, m);
  802b3d:	83 c4 08             	add    $0x8,%esp
  802b40:	53                   	push   %ebx
  802b41:	57                   	push   %edi
  802b42:	e8 6f e9 ff ff       	call   8014b6 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802b47:	01 de                	add    %ebx,%esi
  802b49:	83 c4 10             	add    $0x10,%esp
  802b4c:	eb ca                	jmp    802b18 <devcons_write+0x17>
}
  802b4e:	89 f0                	mov    %esi,%eax
  802b50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802b53:	5b                   	pop    %ebx
  802b54:	5e                   	pop    %esi
  802b55:	5f                   	pop    %edi
  802b56:	5d                   	pop    %ebp
  802b57:	c3                   	ret    

00802b58 <devcons_read>:
{
  802b58:	55                   	push   %ebp
  802b59:	89 e5                	mov    %esp,%ebp
  802b5b:	83 ec 08             	sub    $0x8,%esp
  802b5e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802b63:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802b67:	74 21                	je     802b8a <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802b69:	e8 66 e9 ff ff       	call   8014d4 <sys_cgetc>
  802b6e:	85 c0                	test   %eax,%eax
  802b70:	75 07                	jne    802b79 <devcons_read+0x21>
		sys_yield();
  802b72:	e8 dc e9 ff ff       	call   801553 <sys_yield>
  802b77:	eb f0                	jmp    802b69 <devcons_read+0x11>
	if (c < 0)
  802b79:	78 0f                	js     802b8a <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802b7b:	83 f8 04             	cmp    $0x4,%eax
  802b7e:	74 0c                	je     802b8c <devcons_read+0x34>
	*(char*)vbuf = c;
  802b80:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b83:	88 02                	mov    %al,(%edx)
	return 1;
  802b85:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802b8a:	c9                   	leave  
  802b8b:	c3                   	ret    
		return 0;
  802b8c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b91:	eb f7                	jmp    802b8a <devcons_read+0x32>

00802b93 <cputchar>:
{
  802b93:	55                   	push   %ebp
  802b94:	89 e5                	mov    %esp,%ebp
  802b96:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802b99:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9c:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802b9f:	6a 01                	push   $0x1
  802ba1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802ba4:	50                   	push   %eax
  802ba5:	e8 0c e9 ff ff       	call   8014b6 <sys_cputs>
}
  802baa:	83 c4 10             	add    $0x10,%esp
  802bad:	c9                   	leave  
  802bae:	c3                   	ret    

00802baf <getchar>:
{
  802baf:	55                   	push   %ebp
  802bb0:	89 e5                	mov    %esp,%ebp
  802bb2:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802bb5:	6a 01                	push   $0x1
  802bb7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802bba:	50                   	push   %eax
  802bbb:	6a 00                	push   $0x0
  802bbd:	e8 8e ef ff ff       	call   801b50 <read>
	if (r < 0)
  802bc2:	83 c4 10             	add    $0x10,%esp
  802bc5:	85 c0                	test   %eax,%eax
  802bc7:	78 06                	js     802bcf <getchar+0x20>
	if (r < 1)
  802bc9:	74 06                	je     802bd1 <getchar+0x22>
	return c;
  802bcb:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802bcf:	c9                   	leave  
  802bd0:	c3                   	ret    
		return -E_EOF;
  802bd1:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802bd6:	eb f7                	jmp    802bcf <getchar+0x20>

00802bd8 <iscons>:
{
  802bd8:	55                   	push   %ebp
  802bd9:	89 e5                	mov    %esp,%ebp
  802bdb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802bde:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802be1:	50                   	push   %eax
  802be2:	ff 75 08             	pushl  0x8(%ebp)
  802be5:	e8 f6 ec ff ff       	call   8018e0 <fd_lookup>
  802bea:	83 c4 10             	add    $0x10,%esp
  802bed:	85 c0                	test   %eax,%eax
  802bef:	78 11                	js     802c02 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf4:	8b 15 78 40 80 00    	mov    0x804078,%edx
  802bfa:	39 10                	cmp    %edx,(%eax)
  802bfc:	0f 94 c0             	sete   %al
  802bff:	0f b6 c0             	movzbl %al,%eax
}
  802c02:	c9                   	leave  
  802c03:	c3                   	ret    

00802c04 <opencons>:
{
  802c04:	55                   	push   %ebp
  802c05:	89 e5                	mov    %esp,%ebp
  802c07:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802c0a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802c0d:	50                   	push   %eax
  802c0e:	e8 7b ec ff ff       	call   80188e <fd_alloc>
  802c13:	83 c4 10             	add    $0x10,%esp
  802c16:	85 c0                	test   %eax,%eax
  802c18:	78 3a                	js     802c54 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802c1a:	83 ec 04             	sub    $0x4,%esp
  802c1d:	68 07 04 00 00       	push   $0x407
  802c22:	ff 75 f4             	pushl  -0xc(%ebp)
  802c25:	6a 00                	push   $0x0
  802c27:	e8 46 e9 ff ff       	call   801572 <sys_page_alloc>
  802c2c:	83 c4 10             	add    $0x10,%esp
  802c2f:	85 c0                	test   %eax,%eax
  802c31:	78 21                	js     802c54 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c36:	8b 15 78 40 80 00    	mov    0x804078,%edx
  802c3c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c41:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802c48:	83 ec 0c             	sub    $0xc,%esp
  802c4b:	50                   	push   %eax
  802c4c:	e8 16 ec ff ff       	call   801867 <fd2num>
  802c51:	83 c4 10             	add    $0x10,%esp
}
  802c54:	c9                   	leave  
  802c55:	c3                   	ret    

00802c56 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802c56:	55                   	push   %ebp
  802c57:	89 e5                	mov    %esp,%ebp
  802c59:	56                   	push   %esi
  802c5a:	53                   	push   %ebx
  802c5b:	8b 75 08             	mov    0x8(%ebp),%esi
  802c5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c61:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802c64:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802c66:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802c6b:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802c6e:	83 ec 0c             	sub    $0xc,%esp
  802c71:	50                   	push   %eax
  802c72:	e8 ab ea ff ff       	call   801722 <sys_ipc_recv>
	if(ret < 0){
  802c77:	83 c4 10             	add    $0x10,%esp
  802c7a:	85 c0                	test   %eax,%eax
  802c7c:	78 2b                	js     802ca9 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802c7e:	85 f6                	test   %esi,%esi
  802c80:	74 0a                	je     802c8c <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802c82:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802c87:	8b 40 74             	mov    0x74(%eax),%eax
  802c8a:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802c8c:	85 db                	test   %ebx,%ebx
  802c8e:	74 0a                	je     802c9a <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802c90:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802c95:	8b 40 78             	mov    0x78(%eax),%eax
  802c98:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802c9a:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802c9f:	8b 40 70             	mov    0x70(%eax),%eax
}
  802ca2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802ca5:	5b                   	pop    %ebx
  802ca6:	5e                   	pop    %esi
  802ca7:	5d                   	pop    %ebp
  802ca8:	c3                   	ret    
		if(from_env_store)
  802ca9:	85 f6                	test   %esi,%esi
  802cab:	74 06                	je     802cb3 <ipc_recv+0x5d>
			*from_env_store = 0;
  802cad:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802cb3:	85 db                	test   %ebx,%ebx
  802cb5:	74 eb                	je     802ca2 <ipc_recv+0x4c>
			*perm_store = 0;
  802cb7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802cbd:	eb e3                	jmp    802ca2 <ipc_recv+0x4c>

00802cbf <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802cbf:	55                   	push   %ebp
  802cc0:	89 e5                	mov    %esp,%ebp
  802cc2:	57                   	push   %edi
  802cc3:	56                   	push   %esi
  802cc4:	53                   	push   %ebx
  802cc5:	83 ec 0c             	sub    $0xc,%esp
  802cc8:	8b 7d 08             	mov    0x8(%ebp),%edi
  802ccb:	8b 75 0c             	mov    0xc(%ebp),%esi
  802cce:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802cd1:	85 db                	test   %ebx,%ebx
  802cd3:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802cd8:	0f 44 d8             	cmove  %eax,%ebx
  802cdb:	eb 05                	jmp    802ce2 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802cdd:	e8 71 e8 ff ff       	call   801553 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802ce2:	ff 75 14             	pushl  0x14(%ebp)
  802ce5:	53                   	push   %ebx
  802ce6:	56                   	push   %esi
  802ce7:	57                   	push   %edi
  802ce8:	e8 12 ea ff ff       	call   8016ff <sys_ipc_try_send>
  802ced:	83 c4 10             	add    $0x10,%esp
  802cf0:	85 c0                	test   %eax,%eax
  802cf2:	74 1b                	je     802d0f <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802cf4:	79 e7                	jns    802cdd <ipc_send+0x1e>
  802cf6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802cf9:	74 e2                	je     802cdd <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802cfb:	83 ec 04             	sub    $0x4,%esp
  802cfe:	68 f0 37 80 00       	push   $0x8037f0
  802d03:	6a 46                	push   $0x46
  802d05:	68 05 38 80 00       	push   $0x803805
  802d0a:	e8 1c dc ff ff       	call   80092b <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802d0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d12:	5b                   	pop    %ebx
  802d13:	5e                   	pop    %esi
  802d14:	5f                   	pop    %edi
  802d15:	5d                   	pop    %ebp
  802d16:	c3                   	ret    

00802d17 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802d17:	55                   	push   %ebp
  802d18:	89 e5                	mov    %esp,%ebp
  802d1a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802d1d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802d22:	89 c2                	mov    %eax,%edx
  802d24:	c1 e2 07             	shl    $0x7,%edx
  802d27:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802d2d:	8b 52 50             	mov    0x50(%edx),%edx
  802d30:	39 ca                	cmp    %ecx,%edx
  802d32:	74 11                	je     802d45 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802d34:	83 c0 01             	add    $0x1,%eax
  802d37:	3d 00 04 00 00       	cmp    $0x400,%eax
  802d3c:	75 e4                	jne    802d22 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802d3e:	b8 00 00 00 00       	mov    $0x0,%eax
  802d43:	eb 0b                	jmp    802d50 <ipc_find_env+0x39>
			return envs[i].env_id;
  802d45:	c1 e0 07             	shl    $0x7,%eax
  802d48:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802d4d:	8b 40 48             	mov    0x48(%eax),%eax
}
  802d50:	5d                   	pop    %ebp
  802d51:	c3                   	ret    

00802d52 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802d52:	55                   	push   %ebp
  802d53:	89 e5                	mov    %esp,%ebp
  802d55:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802d58:	89 d0                	mov    %edx,%eax
  802d5a:	c1 e8 16             	shr    $0x16,%eax
  802d5d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802d64:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802d69:	f6 c1 01             	test   $0x1,%cl
  802d6c:	74 1d                	je     802d8b <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802d6e:	c1 ea 0c             	shr    $0xc,%edx
  802d71:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802d78:	f6 c2 01             	test   $0x1,%dl
  802d7b:	74 0e                	je     802d8b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802d7d:	c1 ea 0c             	shr    $0xc,%edx
  802d80:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802d87:	ef 
  802d88:	0f b7 c0             	movzwl %ax,%eax
}
  802d8b:	5d                   	pop    %ebp
  802d8c:	c3                   	ret    
  802d8d:	66 90                	xchg   %ax,%ax
  802d8f:	90                   	nop

00802d90 <__udivdi3>:
  802d90:	55                   	push   %ebp
  802d91:	57                   	push   %edi
  802d92:	56                   	push   %esi
  802d93:	53                   	push   %ebx
  802d94:	83 ec 1c             	sub    $0x1c,%esp
  802d97:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802d9b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802d9f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802da3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802da7:	85 d2                	test   %edx,%edx
  802da9:	75 4d                	jne    802df8 <__udivdi3+0x68>
  802dab:	39 f3                	cmp    %esi,%ebx
  802dad:	76 19                	jbe    802dc8 <__udivdi3+0x38>
  802daf:	31 ff                	xor    %edi,%edi
  802db1:	89 e8                	mov    %ebp,%eax
  802db3:	89 f2                	mov    %esi,%edx
  802db5:	f7 f3                	div    %ebx
  802db7:	89 fa                	mov    %edi,%edx
  802db9:	83 c4 1c             	add    $0x1c,%esp
  802dbc:	5b                   	pop    %ebx
  802dbd:	5e                   	pop    %esi
  802dbe:	5f                   	pop    %edi
  802dbf:	5d                   	pop    %ebp
  802dc0:	c3                   	ret    
  802dc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802dc8:	89 d9                	mov    %ebx,%ecx
  802dca:	85 db                	test   %ebx,%ebx
  802dcc:	75 0b                	jne    802dd9 <__udivdi3+0x49>
  802dce:	b8 01 00 00 00       	mov    $0x1,%eax
  802dd3:	31 d2                	xor    %edx,%edx
  802dd5:	f7 f3                	div    %ebx
  802dd7:	89 c1                	mov    %eax,%ecx
  802dd9:	31 d2                	xor    %edx,%edx
  802ddb:	89 f0                	mov    %esi,%eax
  802ddd:	f7 f1                	div    %ecx
  802ddf:	89 c6                	mov    %eax,%esi
  802de1:	89 e8                	mov    %ebp,%eax
  802de3:	89 f7                	mov    %esi,%edi
  802de5:	f7 f1                	div    %ecx
  802de7:	89 fa                	mov    %edi,%edx
  802de9:	83 c4 1c             	add    $0x1c,%esp
  802dec:	5b                   	pop    %ebx
  802ded:	5e                   	pop    %esi
  802dee:	5f                   	pop    %edi
  802def:	5d                   	pop    %ebp
  802df0:	c3                   	ret    
  802df1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802df8:	39 f2                	cmp    %esi,%edx
  802dfa:	77 1c                	ja     802e18 <__udivdi3+0x88>
  802dfc:	0f bd fa             	bsr    %edx,%edi
  802dff:	83 f7 1f             	xor    $0x1f,%edi
  802e02:	75 2c                	jne    802e30 <__udivdi3+0xa0>
  802e04:	39 f2                	cmp    %esi,%edx
  802e06:	72 06                	jb     802e0e <__udivdi3+0x7e>
  802e08:	31 c0                	xor    %eax,%eax
  802e0a:	39 eb                	cmp    %ebp,%ebx
  802e0c:	77 a9                	ja     802db7 <__udivdi3+0x27>
  802e0e:	b8 01 00 00 00       	mov    $0x1,%eax
  802e13:	eb a2                	jmp    802db7 <__udivdi3+0x27>
  802e15:	8d 76 00             	lea    0x0(%esi),%esi
  802e18:	31 ff                	xor    %edi,%edi
  802e1a:	31 c0                	xor    %eax,%eax
  802e1c:	89 fa                	mov    %edi,%edx
  802e1e:	83 c4 1c             	add    $0x1c,%esp
  802e21:	5b                   	pop    %ebx
  802e22:	5e                   	pop    %esi
  802e23:	5f                   	pop    %edi
  802e24:	5d                   	pop    %ebp
  802e25:	c3                   	ret    
  802e26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802e2d:	8d 76 00             	lea    0x0(%esi),%esi
  802e30:	89 f9                	mov    %edi,%ecx
  802e32:	b8 20 00 00 00       	mov    $0x20,%eax
  802e37:	29 f8                	sub    %edi,%eax
  802e39:	d3 e2                	shl    %cl,%edx
  802e3b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802e3f:	89 c1                	mov    %eax,%ecx
  802e41:	89 da                	mov    %ebx,%edx
  802e43:	d3 ea                	shr    %cl,%edx
  802e45:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802e49:	09 d1                	or     %edx,%ecx
  802e4b:	89 f2                	mov    %esi,%edx
  802e4d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802e51:	89 f9                	mov    %edi,%ecx
  802e53:	d3 e3                	shl    %cl,%ebx
  802e55:	89 c1                	mov    %eax,%ecx
  802e57:	d3 ea                	shr    %cl,%edx
  802e59:	89 f9                	mov    %edi,%ecx
  802e5b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802e5f:	89 eb                	mov    %ebp,%ebx
  802e61:	d3 e6                	shl    %cl,%esi
  802e63:	89 c1                	mov    %eax,%ecx
  802e65:	d3 eb                	shr    %cl,%ebx
  802e67:	09 de                	or     %ebx,%esi
  802e69:	89 f0                	mov    %esi,%eax
  802e6b:	f7 74 24 08          	divl   0x8(%esp)
  802e6f:	89 d6                	mov    %edx,%esi
  802e71:	89 c3                	mov    %eax,%ebx
  802e73:	f7 64 24 0c          	mull   0xc(%esp)
  802e77:	39 d6                	cmp    %edx,%esi
  802e79:	72 15                	jb     802e90 <__udivdi3+0x100>
  802e7b:	89 f9                	mov    %edi,%ecx
  802e7d:	d3 e5                	shl    %cl,%ebp
  802e7f:	39 c5                	cmp    %eax,%ebp
  802e81:	73 04                	jae    802e87 <__udivdi3+0xf7>
  802e83:	39 d6                	cmp    %edx,%esi
  802e85:	74 09                	je     802e90 <__udivdi3+0x100>
  802e87:	89 d8                	mov    %ebx,%eax
  802e89:	31 ff                	xor    %edi,%edi
  802e8b:	e9 27 ff ff ff       	jmp    802db7 <__udivdi3+0x27>
  802e90:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802e93:	31 ff                	xor    %edi,%edi
  802e95:	e9 1d ff ff ff       	jmp    802db7 <__udivdi3+0x27>
  802e9a:	66 90                	xchg   %ax,%ax
  802e9c:	66 90                	xchg   %ax,%ax
  802e9e:	66 90                	xchg   %ax,%ax

00802ea0 <__umoddi3>:
  802ea0:	55                   	push   %ebp
  802ea1:	57                   	push   %edi
  802ea2:	56                   	push   %esi
  802ea3:	53                   	push   %ebx
  802ea4:	83 ec 1c             	sub    $0x1c,%esp
  802ea7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802eab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802eaf:	8b 74 24 30          	mov    0x30(%esp),%esi
  802eb3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802eb7:	89 da                	mov    %ebx,%edx
  802eb9:	85 c0                	test   %eax,%eax
  802ebb:	75 43                	jne    802f00 <__umoddi3+0x60>
  802ebd:	39 df                	cmp    %ebx,%edi
  802ebf:	76 17                	jbe    802ed8 <__umoddi3+0x38>
  802ec1:	89 f0                	mov    %esi,%eax
  802ec3:	f7 f7                	div    %edi
  802ec5:	89 d0                	mov    %edx,%eax
  802ec7:	31 d2                	xor    %edx,%edx
  802ec9:	83 c4 1c             	add    $0x1c,%esp
  802ecc:	5b                   	pop    %ebx
  802ecd:	5e                   	pop    %esi
  802ece:	5f                   	pop    %edi
  802ecf:	5d                   	pop    %ebp
  802ed0:	c3                   	ret    
  802ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ed8:	89 fd                	mov    %edi,%ebp
  802eda:	85 ff                	test   %edi,%edi
  802edc:	75 0b                	jne    802ee9 <__umoddi3+0x49>
  802ede:	b8 01 00 00 00       	mov    $0x1,%eax
  802ee3:	31 d2                	xor    %edx,%edx
  802ee5:	f7 f7                	div    %edi
  802ee7:	89 c5                	mov    %eax,%ebp
  802ee9:	89 d8                	mov    %ebx,%eax
  802eeb:	31 d2                	xor    %edx,%edx
  802eed:	f7 f5                	div    %ebp
  802eef:	89 f0                	mov    %esi,%eax
  802ef1:	f7 f5                	div    %ebp
  802ef3:	89 d0                	mov    %edx,%eax
  802ef5:	eb d0                	jmp    802ec7 <__umoddi3+0x27>
  802ef7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802efe:	66 90                	xchg   %ax,%ax
  802f00:	89 f1                	mov    %esi,%ecx
  802f02:	39 d8                	cmp    %ebx,%eax
  802f04:	76 0a                	jbe    802f10 <__umoddi3+0x70>
  802f06:	89 f0                	mov    %esi,%eax
  802f08:	83 c4 1c             	add    $0x1c,%esp
  802f0b:	5b                   	pop    %ebx
  802f0c:	5e                   	pop    %esi
  802f0d:	5f                   	pop    %edi
  802f0e:	5d                   	pop    %ebp
  802f0f:	c3                   	ret    
  802f10:	0f bd e8             	bsr    %eax,%ebp
  802f13:	83 f5 1f             	xor    $0x1f,%ebp
  802f16:	75 20                	jne    802f38 <__umoddi3+0x98>
  802f18:	39 d8                	cmp    %ebx,%eax
  802f1a:	0f 82 b0 00 00 00    	jb     802fd0 <__umoddi3+0x130>
  802f20:	39 f7                	cmp    %esi,%edi
  802f22:	0f 86 a8 00 00 00    	jbe    802fd0 <__umoddi3+0x130>
  802f28:	89 c8                	mov    %ecx,%eax
  802f2a:	83 c4 1c             	add    $0x1c,%esp
  802f2d:	5b                   	pop    %ebx
  802f2e:	5e                   	pop    %esi
  802f2f:	5f                   	pop    %edi
  802f30:	5d                   	pop    %ebp
  802f31:	c3                   	ret    
  802f32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802f38:	89 e9                	mov    %ebp,%ecx
  802f3a:	ba 20 00 00 00       	mov    $0x20,%edx
  802f3f:	29 ea                	sub    %ebp,%edx
  802f41:	d3 e0                	shl    %cl,%eax
  802f43:	89 44 24 08          	mov    %eax,0x8(%esp)
  802f47:	89 d1                	mov    %edx,%ecx
  802f49:	89 f8                	mov    %edi,%eax
  802f4b:	d3 e8                	shr    %cl,%eax
  802f4d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802f51:	89 54 24 04          	mov    %edx,0x4(%esp)
  802f55:	8b 54 24 04          	mov    0x4(%esp),%edx
  802f59:	09 c1                	or     %eax,%ecx
  802f5b:	89 d8                	mov    %ebx,%eax
  802f5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802f61:	89 e9                	mov    %ebp,%ecx
  802f63:	d3 e7                	shl    %cl,%edi
  802f65:	89 d1                	mov    %edx,%ecx
  802f67:	d3 e8                	shr    %cl,%eax
  802f69:	89 e9                	mov    %ebp,%ecx
  802f6b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802f6f:	d3 e3                	shl    %cl,%ebx
  802f71:	89 c7                	mov    %eax,%edi
  802f73:	89 d1                	mov    %edx,%ecx
  802f75:	89 f0                	mov    %esi,%eax
  802f77:	d3 e8                	shr    %cl,%eax
  802f79:	89 e9                	mov    %ebp,%ecx
  802f7b:	89 fa                	mov    %edi,%edx
  802f7d:	d3 e6                	shl    %cl,%esi
  802f7f:	09 d8                	or     %ebx,%eax
  802f81:	f7 74 24 08          	divl   0x8(%esp)
  802f85:	89 d1                	mov    %edx,%ecx
  802f87:	89 f3                	mov    %esi,%ebx
  802f89:	f7 64 24 0c          	mull   0xc(%esp)
  802f8d:	89 c6                	mov    %eax,%esi
  802f8f:	89 d7                	mov    %edx,%edi
  802f91:	39 d1                	cmp    %edx,%ecx
  802f93:	72 06                	jb     802f9b <__umoddi3+0xfb>
  802f95:	75 10                	jne    802fa7 <__umoddi3+0x107>
  802f97:	39 c3                	cmp    %eax,%ebx
  802f99:	73 0c                	jae    802fa7 <__umoddi3+0x107>
  802f9b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802f9f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802fa3:	89 d7                	mov    %edx,%edi
  802fa5:	89 c6                	mov    %eax,%esi
  802fa7:	89 ca                	mov    %ecx,%edx
  802fa9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802fae:	29 f3                	sub    %esi,%ebx
  802fb0:	19 fa                	sbb    %edi,%edx
  802fb2:	89 d0                	mov    %edx,%eax
  802fb4:	d3 e0                	shl    %cl,%eax
  802fb6:	89 e9                	mov    %ebp,%ecx
  802fb8:	d3 eb                	shr    %cl,%ebx
  802fba:	d3 ea                	shr    %cl,%edx
  802fbc:	09 d8                	or     %ebx,%eax
  802fbe:	83 c4 1c             	add    $0x1c,%esp
  802fc1:	5b                   	pop    %ebx
  802fc2:	5e                   	pop    %esi
  802fc3:	5f                   	pop    %edi
  802fc4:	5d                   	pop    %ebp
  802fc5:	c3                   	ret    
  802fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802fcd:	8d 76 00             	lea    0x0(%esi),%esi
  802fd0:	89 da                	mov    %ebx,%edx
  802fd2:	29 fe                	sub    %edi,%esi
  802fd4:	19 c2                	sbb    %eax,%edx
  802fd6:	89 f1                	mov    %esi,%ecx
  802fd8:	89 c8                	mov    %ecx,%eax
  802fda:	e9 4b ff ff ff       	jmp    802f2a <__umoddi3+0x8a>
