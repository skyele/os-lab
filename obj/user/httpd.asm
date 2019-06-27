
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
  80003a:	68 ad 32 80 00       	push   $0x8032ad
  80003f:	e8 df 09 00 00       	call   800a23 <cprintf>
	exit();
  800044:	e8 b0 08 00 00       	call   8008f9 <exit>
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
  800080:	68 fc 30 80 00       	push   $0x8030fc
  800085:	68 00 02 00 00       	push   $0x200
  80008a:	8d bd e8 fd ff ff    	lea    -0x218(%ebp),%edi
  800090:	57                   	push   %edi
  800091:	e8 99 10 00 00       	call   80112f <snprintf>
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
  80009f:	e8 7a 1b 00 00       	call   801c1e <write>
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
  8000db:	e8 72 1a 00 00       	call   801b52 <read>
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
  8000f2:	e8 d1 11 00 00       	call   8012c8 <memset>

		req->sock = sock;
  8000f7:	89 75 dc             	mov    %esi,-0x24(%ebp)
	if (strncmp(request, "GET ", 4) != 0)
  8000fa:	83 c4 0c             	add    $0xc,%esp
  8000fd:	6a 04                	push   $0x4
  8000ff:	68 1c 30 80 00       	push   $0x80301c
  800104:	8d 85 dc fd ff ff    	lea    -0x224(%ebp),%eax
  80010a:	50                   	push   %eax
  80010b:	e8 43 11 00 00       	call   801253 <strncmp>
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
  80012e:	68 00 30 80 00       	push   $0x803000
  800133:	68 23 01 00 00       	push   $0x123
  800138:	68 0f 30 80 00       	push   $0x80300f
  80013d:	e8 eb 07 00 00       	call   80092d <_panic>
	url_len = request - url;
  800142:	89 df                	mov    %ebx,%edi
  800144:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
  80014a:	29 c7                	sub    %eax,%edi
	req->url = malloc(url_len + 1);
  80014c:	83 ec 0c             	sub    $0xc,%esp
  80014f:	8d 47 01             	lea    0x1(%edi),%eax
  800152:	50                   	push   %eax
  800153:	e8 50 24 00 00       	call   8025a8 <malloc>
  800158:	89 45 e0             	mov    %eax,-0x20(%ebp)
	memmove(req->url, url, url_len);
  80015b:	83 c4 0c             	add    $0xc,%esp
  80015e:	57                   	push   %edi
  80015f:	8d 8d e0 fd ff ff    	lea    -0x220(%ebp),%ecx
  800165:	51                   	push   %ecx
  800166:	50                   	push   %eax
  800167:	e8 a4 11 00 00       	call   801310 <memmove>
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
  800197:	e8 0c 24 00 00       	call   8025a8 <malloc>
  80019c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	memmove(req->version, version, version_len);
  80019f:	83 c4 0c             	add    $0xc,%esp
  8001a2:	57                   	push   %edi
  8001a3:	53                   	push   %ebx
  8001a4:	50                   	push   %eax
  8001a5:	e8 66 11 00 00       	call   801310 <memmove>
	req->version[version_len] = '\0';
  8001aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ad:	c6 04 38 00          	movb   $0x0,(%eax,%edi,1)
	fd = open(req->url, O_RDONLY);
  8001b1:	83 c4 08             	add    $0x8,%esp
  8001b4:	6a 00                	push   $0x0
  8001b6:	ff 75 e0             	pushl  -0x20(%ebp)
  8001b9:	e8 32 1e 00 00       	call   801ff0 <open>
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
  8001d2:	e8 71 1b 00 00       	call   801d48 <fstat>
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
  800221:	e8 ee 17 00 00       	call   801a14 <close>
  800226:	83 c4 10             	add    $0x10,%esp
	free(req->url);
  800229:	83 ec 0c             	sub    $0xc,%esp
  80022c:	ff 75 e0             	pushl  -0x20(%ebp)
  80022f:	e8 c8 22 00 00       	call   8024fc <free>
	free(req->version);
  800234:	83 c4 04             	add    $0x4,%esp
  800237:	ff 75 e4             	pushl  -0x1c(%ebp)
  80023a:	e8 bd 22 00 00       	call   8024fc <free>

		// no keep alive
		break;
	}

	close(sock);
  80023f:	89 34 24             	mov    %esi,(%esp)
  800242:	e8 cd 17 00 00       	call   801a14 <close>
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
  800264:	e8 e0 0e 00 00       	call   801149 <strlen>
	if (write(req->sock, h->header, len) != len) {
  800269:	83 c4 0c             	add    $0xc,%esp
  80026c:	89 85 c4 f6 ff ff    	mov    %eax,-0x93c(%ebp)
  800272:	50                   	push   %eax
  800273:	ff 73 04             	pushl  0x4(%ebx)
  800276:	ff 75 dc             	pushl  -0x24(%ebp)
  800279:	e8 a0 19 00 00       	call   801c1e <write>
  80027e:	83 c4 10             	add    $0x10,%esp
  800281:	39 85 c4 f6 ff ff    	cmp    %eax,-0x93c(%ebp)
  800287:	0f 85 4b 01 00 00    	jne    8003d8 <handle_client+0x318>
	r = snprintf(buf, 64, "Content-Length: %ld\r\n", (long)size);
  80028d:	ff b5 c0 f6 ff ff    	pushl  -0x940(%ebp)
  800293:	68 ae 30 80 00       	push   $0x8030ae
  800298:	6a 40                	push   $0x40
  80029a:	8d 85 ee f7 ff ff    	lea    -0x812(%ebp),%eax
  8002a0:	50                   	push   %eax
  8002a1:	e8 89 0e 00 00       	call   80112f <snprintf>
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
  8002c2:	e8 57 19 00 00       	call   801c1e <write>
	if ((r = send_size(req, file_size)) < 0)
  8002c7:	83 c4 10             	add    $0x10,%esp
  8002ca:	39 c3                	cmp    %eax,%ebx
  8002cc:	0f 85 4b ff ff ff    	jne    80021d <handle_client+0x15d>
	r = snprintf(buf, 128, "Content-Type: %s\r\n", type);
  8002d2:	68 33 30 80 00       	push   $0x803033
  8002d7:	68 3d 30 80 00       	push   $0x80303d
  8002dc:	68 80 00 00 00       	push   $0x80
  8002e1:	8d 85 ee f7 ff ff    	lea    -0x812(%ebp),%eax
  8002e7:	50                   	push   %eax
  8002e8:	e8 42 0e 00 00       	call   80112f <snprintf>
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
  800309:	e8 10 19 00 00       	call   801c1e <write>
	if ((r = send_content_type(req)) < 0)
  80030e:	83 c4 10             	add    $0x10,%esp
  800311:	39 c3                	cmp    %eax,%ebx
  800313:	0f 85 04 ff ff ff    	jne    80021d <handle_client+0x15d>
	int fin_len = strlen(fin);
  800319:	83 ec 0c             	sub    $0xc,%esp
  80031c:	68 c1 30 80 00       	push   $0x8030c1
  800321:	e8 23 0e 00 00       	call   801149 <strlen>
  800326:	89 c3                	mov    %eax,%ebx
	if (write(req->sock, fin, fin_len) != fin_len)
  800328:	83 c4 0c             	add    $0xc,%esp
  80032b:	50                   	push   %eax
  80032c:	68 c1 30 80 00       	push   $0x8030c1
  800331:	ff 75 dc             	pushl  -0x24(%ebp)
  800334:	e8 e5 18 00 00       	call   801c1e <write>
	if ((r = send_header_fin(req)) < 0)
  800339:	83 c4 10             	add    $0x10,%esp
  80033c:	39 c3                	cmp    %eax,%ebx
  80033e:	0f 85 d9 fe ff ff    	jne    80021d <handle_client+0x15d>
  	if ((r = fstat(fd, &stat)) < 0)
  800344:	83 ec 08             	sub    $0x8,%esp
  800347:	8d 85 60 f7 ff ff    	lea    -0x8a0(%ebp),%eax
  80034d:	50                   	push   %eax
  80034e:	57                   	push   %edi
  80034f:	e8 f4 19 00 00       	call   801d48 <fstat>
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
  800380:	e8 54 18 00 00       	call   801bd9 <readn>
  800385:	83 c4 10             	add    $0x10,%esp
  800388:	3b 85 e0 f7 ff ff    	cmp    -0x820(%ebp),%eax
  80038e:	0f 85 9c 00 00 00    	jne    800430 <handle_client+0x370>
	cprintf("the data is %s\n", buf);
  800394:	83 ec 08             	sub    $0x8,%esp
  800397:	8d 9d ee f7 ff ff    	lea    -0x812(%ebp),%ebx
  80039d:	53                   	push   %ebx
  80039e:	68 8b 30 80 00       	push   $0x80308b
  8003a3:	e8 7b 06 00 00       	call   800a23 <cprintf>
  	if ((r = write(req->sock, buf, stat.st_size)) != stat.st_size)
  8003a8:	83 c4 0c             	add    $0xc,%esp
  8003ab:	ff b5 e0 f7 ff ff    	pushl  -0x820(%ebp)
  8003b1:	53                   	push   %ebx
  8003b2:	ff 75 dc             	pushl  -0x24(%ebp)
  8003b5:	e8 64 18 00 00       	call   801c1e <write>
  8003ba:	83 c4 10             	add    $0x10,%esp
  8003bd:	3b 85 e0 f7 ff ff    	cmp    -0x820(%ebp),%eax
  8003c3:	0f 84 54 fe ff ff    	je     80021d <handle_client+0x15d>
    	die("not write all data");
  8003c9:	b8 9b 30 80 00       	mov    $0x80309b,%eax
  8003ce:	e8 60 fc ff ff       	call   800033 <die>
  8003d3:	e9 45 fe ff ff       	jmp    80021d <handle_client+0x15d>
		die("Failed to send bytes to client");
  8003d8:	b8 78 31 80 00       	mov    $0x803178,%eax
  8003dd:	e8 51 fc ff ff       	call   800033 <die>
  8003e2:	e9 a6 fe ff ff       	jmp    80028d <handle_client+0x1cd>
		panic("buffer too small!");
  8003e7:	83 ec 04             	sub    $0x4,%esp
  8003ea:	68 21 30 80 00       	push   $0x803021
  8003ef:	6a 68                	push   $0x68
  8003f1:	68 0f 30 80 00       	push   $0x80300f
  8003f6:	e8 32 05 00 00       	call   80092d <_panic>
		panic("buffer too small!");
  8003fb:	83 ec 04             	sub    $0x4,%esp
  8003fe:	68 21 30 80 00       	push   $0x803021
  800403:	68 84 00 00 00       	push   $0x84
  800408:	68 0f 30 80 00       	push   $0x80300f
  80040d:	e8 1b 05 00 00       	call   80092d <_panic>
  		die("fstat panic");
  800412:	b8 50 30 80 00       	mov    $0x803050,%eax
  800417:	e8 17 fc ff ff       	call   800033 <die>
  80041c:	e9 3e ff ff ff       	jmp    80035f <handle_client+0x29f>
    	die("fd's file size > 1518");
  800421:	b8 5c 30 80 00       	mov    $0x80305c,%eax
  800426:	e8 08 fc ff ff       	call   800033 <die>
  80042b:	e9 3f ff ff ff       	jmp    80036f <handle_client+0x2af>
    	die("just read partitial data");
  800430:	b8 72 30 80 00       	mov    $0x803072,%eax
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
  80045a:	c7 05 20 40 80 00 c4 	movl   $0x8030c4,0x804020
  800461:	30 80 00 

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  800464:	6a 06                	push   $0x6
  800466:	6a 01                	push   $0x1
  800468:	6a 02                	push   $0x2
  80046a:	e8 11 1e 00 00       	call   802280 <socket>
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
  800483:	e8 40 0e 00 00       	call   8012c8 <memset>
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
  8004b2:	e8 37 1d 00 00       	call   8021ee <bind>
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
  8004c4:	e8 94 1d 00 00       	call   80225d <listen>
  8004c9:	83 c4 10             	add    $0x10,%esp
  8004cc:	85 c0                	test   %eax,%eax
  8004ce:	78 2d                	js     8004fd <umain+0xac>
		die("Failed to listen on server socket");

	cprintf("Waiting for http connections...\n");
  8004d0:	83 ec 0c             	sub    $0xc,%esp
  8004d3:	68 e0 31 80 00       	push   $0x8031e0
  8004d8:	e8 46 05 00 00       	call   800a23 <cprintf>
  8004dd:	83 c4 10             	add    $0x10,%esp

	while (1) {
		unsigned int clientlen = sizeof(client);
		// Wait for client connection
		if ((clientsock = accept(serversock,
  8004e0:	8d 7d c4             	lea    -0x3c(%ebp),%edi
  8004e3:	eb 35                	jmp    80051a <umain+0xc9>
		die("Failed to create socket");
  8004e5:	b8 cb 30 80 00       	mov    $0x8030cb,%eax
  8004ea:	e8 44 fb ff ff       	call   800033 <die>
  8004ef:	eb 87                	jmp    800478 <umain+0x27>
		die("Failed to bind the server socket");
  8004f1:	b8 98 31 80 00       	mov    $0x803198,%eax
  8004f6:	e8 38 fb ff ff       	call   800033 <die>
  8004fb:	eb c1                	jmp    8004be <umain+0x6d>
		die("Failed to listen on server socket");
  8004fd:	b8 bc 31 80 00       	mov    $0x8031bc,%eax
  800502:	e8 2c fb ff ff       	call   800033 <die>
  800507:	eb c7                	jmp    8004d0 <umain+0x7f>
					 (struct sockaddr *) &client,
					 &clientlen)) < 0)
		{
			die("Failed to accept client connection");
  800509:	b8 04 32 80 00       	mov    $0x803204,%eax
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
  80052a:	e8 90 1c 00 00       	call   8021bf <accept>
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
  800831:	e8 00 0d 00 00       	call   801536 <sys_getenvid>
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
  800856:	74 23                	je     80087b <libmain+0x5d>
		if(envs[i].env_id == find)
  800858:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  80085e:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800864:	8b 49 48             	mov    0x48(%ecx),%ecx
  800867:	39 c1                	cmp    %eax,%ecx
  800869:	75 e2                	jne    80084d <libmain+0x2f>
  80086b:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  800871:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800877:	89 fe                	mov    %edi,%esi
  800879:	eb d2                	jmp    80084d <libmain+0x2f>
  80087b:	89 f0                	mov    %esi,%eax
  80087d:	84 c0                	test   %al,%al
  80087f:	74 06                	je     800887 <libmain+0x69>
  800881:	89 1d 1c 50 80 00    	mov    %ebx,0x80501c
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800887:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80088b:	7e 0a                	jle    800897 <libmain+0x79>
		binaryname = argv[0];
  80088d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800890:	8b 00                	mov    (%eax),%eax
  800892:	a3 20 40 80 00       	mov    %eax,0x804020

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  800897:	a1 1c 50 80 00       	mov    0x80501c,%eax
  80089c:	8b 40 48             	mov    0x48(%eax),%eax
  80089f:	83 ec 08             	sub    $0x8,%esp
  8008a2:	50                   	push   %eax
  8008a3:	68 4e 32 80 00       	push   $0x80324e
  8008a8:	e8 76 01 00 00       	call   800a23 <cprintf>
	cprintf("before umain\n");
  8008ad:	c7 04 24 6c 32 80 00 	movl   $0x80326c,(%esp)
  8008b4:	e8 6a 01 00 00       	call   800a23 <cprintf>
	// call user main routine
	umain(argc, argv);
  8008b9:	83 c4 08             	add    $0x8,%esp
  8008bc:	ff 75 0c             	pushl  0xc(%ebp)
  8008bf:	ff 75 08             	pushl  0x8(%ebp)
  8008c2:	e8 8a fb ff ff       	call   800451 <umain>
	cprintf("after umain\n");
  8008c7:	c7 04 24 7a 32 80 00 	movl   $0x80327a,(%esp)
  8008ce:	e8 50 01 00 00       	call   800a23 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8008d3:	a1 1c 50 80 00       	mov    0x80501c,%eax
  8008d8:	8b 40 48             	mov    0x48(%eax),%eax
  8008db:	83 c4 08             	add    $0x8,%esp
  8008de:	50                   	push   %eax
  8008df:	68 87 32 80 00       	push   $0x803287
  8008e4:	e8 3a 01 00 00       	call   800a23 <cprintf>
	// exit gracefully
	exit();
  8008e9:	e8 0b 00 00 00       	call   8008f9 <exit>
}
  8008ee:	83 c4 10             	add    $0x10,%esp
  8008f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008f4:	5b                   	pop    %ebx
  8008f5:	5e                   	pop    %esi
  8008f6:	5f                   	pop    %edi
  8008f7:	5d                   	pop    %ebp
  8008f8:	c3                   	ret    

008008f9 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8008f9:	55                   	push   %ebp
  8008fa:	89 e5                	mov    %esp,%ebp
  8008fc:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8008ff:	a1 1c 50 80 00       	mov    0x80501c,%eax
  800904:	8b 40 48             	mov    0x48(%eax),%eax
  800907:	68 b4 32 80 00       	push   $0x8032b4
  80090c:	50                   	push   %eax
  80090d:	68 a6 32 80 00       	push   $0x8032a6
  800912:	e8 0c 01 00 00       	call   800a23 <cprintf>
	close_all();
  800917:	e8 25 11 00 00       	call   801a41 <close_all>
	sys_env_destroy(0);
  80091c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800923:	e8 cd 0b 00 00       	call   8014f5 <sys_env_destroy>
}
  800928:	83 c4 10             	add    $0x10,%esp
  80092b:	c9                   	leave  
  80092c:	c3                   	ret    

0080092d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80092d:	55                   	push   %ebp
  80092e:	89 e5                	mov    %esp,%ebp
  800930:	56                   	push   %esi
  800931:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800932:	a1 1c 50 80 00       	mov    0x80501c,%eax
  800937:	8b 40 48             	mov    0x48(%eax),%eax
  80093a:	83 ec 04             	sub    $0x4,%esp
  80093d:	68 e0 32 80 00       	push   $0x8032e0
  800942:	50                   	push   %eax
  800943:	68 a6 32 80 00       	push   $0x8032a6
  800948:	e8 d6 00 00 00       	call   800a23 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80094d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800950:	8b 35 20 40 80 00    	mov    0x804020,%esi
  800956:	e8 db 0b 00 00       	call   801536 <sys_getenvid>
  80095b:	83 c4 04             	add    $0x4,%esp
  80095e:	ff 75 0c             	pushl  0xc(%ebp)
  800961:	ff 75 08             	pushl  0x8(%ebp)
  800964:	56                   	push   %esi
  800965:	50                   	push   %eax
  800966:	68 bc 32 80 00       	push   $0x8032bc
  80096b:	e8 b3 00 00 00       	call   800a23 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800970:	83 c4 18             	add    $0x18,%esp
  800973:	53                   	push   %ebx
  800974:	ff 75 10             	pushl  0x10(%ebp)
  800977:	e8 56 00 00 00       	call   8009d2 <vcprintf>
	cprintf("\n");
  80097c:	c7 04 24 c2 30 80 00 	movl   $0x8030c2,(%esp)
  800983:	e8 9b 00 00 00       	call   800a23 <cprintf>
  800988:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80098b:	cc                   	int3   
  80098c:	eb fd                	jmp    80098b <_panic+0x5e>

0080098e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80098e:	55                   	push   %ebp
  80098f:	89 e5                	mov    %esp,%ebp
  800991:	53                   	push   %ebx
  800992:	83 ec 04             	sub    $0x4,%esp
  800995:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800998:	8b 13                	mov    (%ebx),%edx
  80099a:	8d 42 01             	lea    0x1(%edx),%eax
  80099d:	89 03                	mov    %eax,(%ebx)
  80099f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009a2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8009a6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009ab:	74 09                	je     8009b6 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8009ad:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8009b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009b4:	c9                   	leave  
  8009b5:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8009b6:	83 ec 08             	sub    $0x8,%esp
  8009b9:	68 ff 00 00 00       	push   $0xff
  8009be:	8d 43 08             	lea    0x8(%ebx),%eax
  8009c1:	50                   	push   %eax
  8009c2:	e8 f1 0a 00 00       	call   8014b8 <sys_cputs>
		b->idx = 0;
  8009c7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8009cd:	83 c4 10             	add    $0x10,%esp
  8009d0:	eb db                	jmp    8009ad <putch+0x1f>

008009d2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009db:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009e2:	00 00 00 
	b.cnt = 0;
  8009e5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009ec:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8009ef:	ff 75 0c             	pushl  0xc(%ebp)
  8009f2:	ff 75 08             	pushl  0x8(%ebp)
  8009f5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009fb:	50                   	push   %eax
  8009fc:	68 8e 09 80 00       	push   $0x80098e
  800a01:	e8 4a 01 00 00       	call   800b50 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800a06:	83 c4 08             	add    $0x8,%esp
  800a09:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800a0f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800a15:	50                   	push   %eax
  800a16:	e8 9d 0a 00 00       	call   8014b8 <sys_cputs>

	return b.cnt;
}
  800a1b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800a21:	c9                   	leave  
  800a22:	c3                   	ret    

00800a23 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800a23:	55                   	push   %ebp
  800a24:	89 e5                	mov    %esp,%ebp
  800a26:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a29:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800a2c:	50                   	push   %eax
  800a2d:	ff 75 08             	pushl  0x8(%ebp)
  800a30:	e8 9d ff ff ff       	call   8009d2 <vcprintf>
	va_end(ap);

	return cnt;
}
  800a35:	c9                   	leave  
  800a36:	c3                   	ret    

00800a37 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
  800a3a:	57                   	push   %edi
  800a3b:	56                   	push   %esi
  800a3c:	53                   	push   %ebx
  800a3d:	83 ec 1c             	sub    $0x1c,%esp
  800a40:	89 c6                	mov    %eax,%esi
  800a42:	89 d7                	mov    %edx,%edi
  800a44:	8b 45 08             	mov    0x8(%ebp),%eax
  800a47:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a4a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a4d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800a50:	8b 45 10             	mov    0x10(%ebp),%eax
  800a53:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800a56:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800a5a:	74 2c                	je     800a88 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800a5c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a5f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800a66:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a69:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800a6c:	39 c2                	cmp    %eax,%edx
  800a6e:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800a71:	73 43                	jae    800ab6 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800a73:	83 eb 01             	sub    $0x1,%ebx
  800a76:	85 db                	test   %ebx,%ebx
  800a78:	7e 6c                	jle    800ae6 <printnum+0xaf>
				putch(padc, putdat);
  800a7a:	83 ec 08             	sub    $0x8,%esp
  800a7d:	57                   	push   %edi
  800a7e:	ff 75 18             	pushl  0x18(%ebp)
  800a81:	ff d6                	call   *%esi
  800a83:	83 c4 10             	add    $0x10,%esp
  800a86:	eb eb                	jmp    800a73 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800a88:	83 ec 0c             	sub    $0xc,%esp
  800a8b:	6a 20                	push   $0x20
  800a8d:	6a 00                	push   $0x0
  800a8f:	50                   	push   %eax
  800a90:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a93:	ff 75 e0             	pushl  -0x20(%ebp)
  800a96:	89 fa                	mov    %edi,%edx
  800a98:	89 f0                	mov    %esi,%eax
  800a9a:	e8 98 ff ff ff       	call   800a37 <printnum>
		while (--width > 0)
  800a9f:	83 c4 20             	add    $0x20,%esp
  800aa2:	83 eb 01             	sub    $0x1,%ebx
  800aa5:	85 db                	test   %ebx,%ebx
  800aa7:	7e 65                	jle    800b0e <printnum+0xd7>
			putch(padc, putdat);
  800aa9:	83 ec 08             	sub    $0x8,%esp
  800aac:	57                   	push   %edi
  800aad:	6a 20                	push   $0x20
  800aaf:	ff d6                	call   *%esi
  800ab1:	83 c4 10             	add    $0x10,%esp
  800ab4:	eb ec                	jmp    800aa2 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800ab6:	83 ec 0c             	sub    $0xc,%esp
  800ab9:	ff 75 18             	pushl  0x18(%ebp)
  800abc:	83 eb 01             	sub    $0x1,%ebx
  800abf:	53                   	push   %ebx
  800ac0:	50                   	push   %eax
  800ac1:	83 ec 08             	sub    $0x8,%esp
  800ac4:	ff 75 dc             	pushl  -0x24(%ebp)
  800ac7:	ff 75 d8             	pushl  -0x28(%ebp)
  800aca:	ff 75 e4             	pushl  -0x1c(%ebp)
  800acd:	ff 75 e0             	pushl  -0x20(%ebp)
  800ad0:	e8 cb 22 00 00       	call   802da0 <__udivdi3>
  800ad5:	83 c4 18             	add    $0x18,%esp
  800ad8:	52                   	push   %edx
  800ad9:	50                   	push   %eax
  800ada:	89 fa                	mov    %edi,%edx
  800adc:	89 f0                	mov    %esi,%eax
  800ade:	e8 54 ff ff ff       	call   800a37 <printnum>
  800ae3:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800ae6:	83 ec 08             	sub    $0x8,%esp
  800ae9:	57                   	push   %edi
  800aea:	83 ec 04             	sub    $0x4,%esp
  800aed:	ff 75 dc             	pushl  -0x24(%ebp)
  800af0:	ff 75 d8             	pushl  -0x28(%ebp)
  800af3:	ff 75 e4             	pushl  -0x1c(%ebp)
  800af6:	ff 75 e0             	pushl  -0x20(%ebp)
  800af9:	e8 b2 23 00 00       	call   802eb0 <__umoddi3>
  800afe:	83 c4 14             	add    $0x14,%esp
  800b01:	0f be 80 e7 32 80 00 	movsbl 0x8032e7(%eax),%eax
  800b08:	50                   	push   %eax
  800b09:	ff d6                	call   *%esi
  800b0b:	83 c4 10             	add    $0x10,%esp
	}
}
  800b0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b11:	5b                   	pop    %ebx
  800b12:	5e                   	pop    %esi
  800b13:	5f                   	pop    %edi
  800b14:	5d                   	pop    %ebp
  800b15:	c3                   	ret    

00800b16 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b16:	55                   	push   %ebp
  800b17:	89 e5                	mov    %esp,%ebp
  800b19:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800b1c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800b20:	8b 10                	mov    (%eax),%edx
  800b22:	3b 50 04             	cmp    0x4(%eax),%edx
  800b25:	73 0a                	jae    800b31 <sprintputch+0x1b>
		*b->buf++ = ch;
  800b27:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b2a:	89 08                	mov    %ecx,(%eax)
  800b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2f:	88 02                	mov    %al,(%edx)
}
  800b31:	5d                   	pop    %ebp
  800b32:	c3                   	ret    

00800b33 <printfmt>:
{
  800b33:	55                   	push   %ebp
  800b34:	89 e5                	mov    %esp,%ebp
  800b36:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800b39:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800b3c:	50                   	push   %eax
  800b3d:	ff 75 10             	pushl  0x10(%ebp)
  800b40:	ff 75 0c             	pushl  0xc(%ebp)
  800b43:	ff 75 08             	pushl  0x8(%ebp)
  800b46:	e8 05 00 00 00       	call   800b50 <vprintfmt>
}
  800b4b:	83 c4 10             	add    $0x10,%esp
  800b4e:	c9                   	leave  
  800b4f:	c3                   	ret    

00800b50 <vprintfmt>:
{
  800b50:	55                   	push   %ebp
  800b51:	89 e5                	mov    %esp,%ebp
  800b53:	57                   	push   %edi
  800b54:	56                   	push   %esi
  800b55:	53                   	push   %ebx
  800b56:	83 ec 3c             	sub    $0x3c,%esp
  800b59:	8b 75 08             	mov    0x8(%ebp),%esi
  800b5c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b5f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800b62:	e9 32 04 00 00       	jmp    800f99 <vprintfmt+0x449>
		padc = ' ';
  800b67:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800b6b:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800b72:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800b79:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800b80:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b87:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800b8e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800b93:	8d 47 01             	lea    0x1(%edi),%eax
  800b96:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b99:	0f b6 17             	movzbl (%edi),%edx
  800b9c:	8d 42 dd             	lea    -0x23(%edx),%eax
  800b9f:	3c 55                	cmp    $0x55,%al
  800ba1:	0f 87 12 05 00 00    	ja     8010b9 <vprintfmt+0x569>
  800ba7:	0f b6 c0             	movzbl %al,%eax
  800baa:	ff 24 85 c0 34 80 00 	jmp    *0x8034c0(,%eax,4)
  800bb1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800bb4:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800bb8:	eb d9                	jmp    800b93 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800bba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800bbd:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800bc1:	eb d0                	jmp    800b93 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800bc3:	0f b6 d2             	movzbl %dl,%edx
  800bc6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800bc9:	b8 00 00 00 00       	mov    $0x0,%eax
  800bce:	89 75 08             	mov    %esi,0x8(%ebp)
  800bd1:	eb 03                	jmp    800bd6 <vprintfmt+0x86>
  800bd3:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800bd6:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800bd9:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800bdd:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800be0:	8d 72 d0             	lea    -0x30(%edx),%esi
  800be3:	83 fe 09             	cmp    $0x9,%esi
  800be6:	76 eb                	jbe    800bd3 <vprintfmt+0x83>
  800be8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800beb:	8b 75 08             	mov    0x8(%ebp),%esi
  800bee:	eb 14                	jmp    800c04 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800bf0:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf3:	8b 00                	mov    (%eax),%eax
  800bf5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bf8:	8b 45 14             	mov    0x14(%ebp),%eax
  800bfb:	8d 40 04             	lea    0x4(%eax),%eax
  800bfe:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800c01:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800c04:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c08:	79 89                	jns    800b93 <vprintfmt+0x43>
				width = precision, precision = -1;
  800c0a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800c10:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800c17:	e9 77 ff ff ff       	jmp    800b93 <vprintfmt+0x43>
  800c1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c1f:	85 c0                	test   %eax,%eax
  800c21:	0f 48 c1             	cmovs  %ecx,%eax
  800c24:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800c27:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800c2a:	e9 64 ff ff ff       	jmp    800b93 <vprintfmt+0x43>
  800c2f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800c32:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800c39:	e9 55 ff ff ff       	jmp    800b93 <vprintfmt+0x43>
			lflag++;
  800c3e:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800c42:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800c45:	e9 49 ff ff ff       	jmp    800b93 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800c4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4d:	8d 78 04             	lea    0x4(%eax),%edi
  800c50:	83 ec 08             	sub    $0x8,%esp
  800c53:	53                   	push   %ebx
  800c54:	ff 30                	pushl  (%eax)
  800c56:	ff d6                	call   *%esi
			break;
  800c58:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800c5b:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800c5e:	e9 33 03 00 00       	jmp    800f96 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800c63:	8b 45 14             	mov    0x14(%ebp),%eax
  800c66:	8d 78 04             	lea    0x4(%eax),%edi
  800c69:	8b 00                	mov    (%eax),%eax
  800c6b:	99                   	cltd   
  800c6c:	31 d0                	xor    %edx,%eax
  800c6e:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800c70:	83 f8 11             	cmp    $0x11,%eax
  800c73:	7f 23                	jg     800c98 <vprintfmt+0x148>
  800c75:	8b 14 85 20 36 80 00 	mov    0x803620(,%eax,4),%edx
  800c7c:	85 d2                	test   %edx,%edx
  800c7e:	74 18                	je     800c98 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800c80:	52                   	push   %edx
  800c81:	68 3d 37 80 00       	push   $0x80373d
  800c86:	53                   	push   %ebx
  800c87:	56                   	push   %esi
  800c88:	e8 a6 fe ff ff       	call   800b33 <printfmt>
  800c8d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800c90:	89 7d 14             	mov    %edi,0x14(%ebp)
  800c93:	e9 fe 02 00 00       	jmp    800f96 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800c98:	50                   	push   %eax
  800c99:	68 ff 32 80 00       	push   $0x8032ff
  800c9e:	53                   	push   %ebx
  800c9f:	56                   	push   %esi
  800ca0:	e8 8e fe ff ff       	call   800b33 <printfmt>
  800ca5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800ca8:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800cab:	e9 e6 02 00 00       	jmp    800f96 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800cb0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb3:	83 c0 04             	add    $0x4,%eax
  800cb6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800cb9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cbc:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800cbe:	85 c9                	test   %ecx,%ecx
  800cc0:	b8 f8 32 80 00       	mov    $0x8032f8,%eax
  800cc5:	0f 45 c1             	cmovne %ecx,%eax
  800cc8:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800ccb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ccf:	7e 06                	jle    800cd7 <vprintfmt+0x187>
  800cd1:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800cd5:	75 0d                	jne    800ce4 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cd7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800cda:	89 c7                	mov    %eax,%edi
  800cdc:	03 45 e0             	add    -0x20(%ebp),%eax
  800cdf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800ce2:	eb 53                	jmp    800d37 <vprintfmt+0x1e7>
  800ce4:	83 ec 08             	sub    $0x8,%esp
  800ce7:	ff 75 d8             	pushl  -0x28(%ebp)
  800cea:	50                   	push   %eax
  800ceb:	e8 71 04 00 00       	call   801161 <strnlen>
  800cf0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800cf3:	29 c1                	sub    %eax,%ecx
  800cf5:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800cf8:	83 c4 10             	add    $0x10,%esp
  800cfb:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800cfd:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800d01:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800d04:	eb 0f                	jmp    800d15 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800d06:	83 ec 08             	sub    $0x8,%esp
  800d09:	53                   	push   %ebx
  800d0a:	ff 75 e0             	pushl  -0x20(%ebp)
  800d0d:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800d0f:	83 ef 01             	sub    $0x1,%edi
  800d12:	83 c4 10             	add    $0x10,%esp
  800d15:	85 ff                	test   %edi,%edi
  800d17:	7f ed                	jg     800d06 <vprintfmt+0x1b6>
  800d19:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800d1c:	85 c9                	test   %ecx,%ecx
  800d1e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d23:	0f 49 c1             	cmovns %ecx,%eax
  800d26:	29 c1                	sub    %eax,%ecx
  800d28:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800d2b:	eb aa                	jmp    800cd7 <vprintfmt+0x187>
					putch(ch, putdat);
  800d2d:	83 ec 08             	sub    $0x8,%esp
  800d30:	53                   	push   %ebx
  800d31:	52                   	push   %edx
  800d32:	ff d6                	call   *%esi
  800d34:	83 c4 10             	add    $0x10,%esp
  800d37:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800d3a:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d3c:	83 c7 01             	add    $0x1,%edi
  800d3f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800d43:	0f be d0             	movsbl %al,%edx
  800d46:	85 d2                	test   %edx,%edx
  800d48:	74 4b                	je     800d95 <vprintfmt+0x245>
  800d4a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800d4e:	78 06                	js     800d56 <vprintfmt+0x206>
  800d50:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800d54:	78 1e                	js     800d74 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800d56:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800d5a:	74 d1                	je     800d2d <vprintfmt+0x1dd>
  800d5c:	0f be c0             	movsbl %al,%eax
  800d5f:	83 e8 20             	sub    $0x20,%eax
  800d62:	83 f8 5e             	cmp    $0x5e,%eax
  800d65:	76 c6                	jbe    800d2d <vprintfmt+0x1dd>
					putch('?', putdat);
  800d67:	83 ec 08             	sub    $0x8,%esp
  800d6a:	53                   	push   %ebx
  800d6b:	6a 3f                	push   $0x3f
  800d6d:	ff d6                	call   *%esi
  800d6f:	83 c4 10             	add    $0x10,%esp
  800d72:	eb c3                	jmp    800d37 <vprintfmt+0x1e7>
  800d74:	89 cf                	mov    %ecx,%edi
  800d76:	eb 0e                	jmp    800d86 <vprintfmt+0x236>
				putch(' ', putdat);
  800d78:	83 ec 08             	sub    $0x8,%esp
  800d7b:	53                   	push   %ebx
  800d7c:	6a 20                	push   $0x20
  800d7e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800d80:	83 ef 01             	sub    $0x1,%edi
  800d83:	83 c4 10             	add    $0x10,%esp
  800d86:	85 ff                	test   %edi,%edi
  800d88:	7f ee                	jg     800d78 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800d8a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800d8d:	89 45 14             	mov    %eax,0x14(%ebp)
  800d90:	e9 01 02 00 00       	jmp    800f96 <vprintfmt+0x446>
  800d95:	89 cf                	mov    %ecx,%edi
  800d97:	eb ed                	jmp    800d86 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800d99:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800d9c:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800da3:	e9 eb fd ff ff       	jmp    800b93 <vprintfmt+0x43>
	if (lflag >= 2)
  800da8:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800dac:	7f 21                	jg     800dcf <vprintfmt+0x27f>
	else if (lflag)
  800dae:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800db2:	74 68                	je     800e1c <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800db4:	8b 45 14             	mov    0x14(%ebp),%eax
  800db7:	8b 00                	mov    (%eax),%eax
  800db9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800dbc:	89 c1                	mov    %eax,%ecx
  800dbe:	c1 f9 1f             	sar    $0x1f,%ecx
  800dc1:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800dc4:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc7:	8d 40 04             	lea    0x4(%eax),%eax
  800dca:	89 45 14             	mov    %eax,0x14(%ebp)
  800dcd:	eb 17                	jmp    800de6 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800dcf:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd2:	8b 50 04             	mov    0x4(%eax),%edx
  800dd5:	8b 00                	mov    (%eax),%eax
  800dd7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800dda:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800ddd:	8b 45 14             	mov    0x14(%ebp),%eax
  800de0:	8d 40 08             	lea    0x8(%eax),%eax
  800de3:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800de6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800de9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800dec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800def:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800df2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800df6:	78 3f                	js     800e37 <vprintfmt+0x2e7>
			base = 10;
  800df8:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800dfd:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800e01:	0f 84 71 01 00 00    	je     800f78 <vprintfmt+0x428>
				putch('+', putdat);
  800e07:	83 ec 08             	sub    $0x8,%esp
  800e0a:	53                   	push   %ebx
  800e0b:	6a 2b                	push   $0x2b
  800e0d:	ff d6                	call   *%esi
  800e0f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800e12:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e17:	e9 5c 01 00 00       	jmp    800f78 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800e1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e1f:	8b 00                	mov    (%eax),%eax
  800e21:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800e24:	89 c1                	mov    %eax,%ecx
  800e26:	c1 f9 1f             	sar    $0x1f,%ecx
  800e29:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800e2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e2f:	8d 40 04             	lea    0x4(%eax),%eax
  800e32:	89 45 14             	mov    %eax,0x14(%ebp)
  800e35:	eb af                	jmp    800de6 <vprintfmt+0x296>
				putch('-', putdat);
  800e37:	83 ec 08             	sub    $0x8,%esp
  800e3a:	53                   	push   %ebx
  800e3b:	6a 2d                	push   $0x2d
  800e3d:	ff d6                	call   *%esi
				num = -(long long) num;
  800e3f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e42:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800e45:	f7 d8                	neg    %eax
  800e47:	83 d2 00             	adc    $0x0,%edx
  800e4a:	f7 da                	neg    %edx
  800e4c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e4f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800e52:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800e55:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e5a:	e9 19 01 00 00       	jmp    800f78 <vprintfmt+0x428>
	if (lflag >= 2)
  800e5f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800e63:	7f 29                	jg     800e8e <vprintfmt+0x33e>
	else if (lflag)
  800e65:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800e69:	74 44                	je     800eaf <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800e6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800e6e:	8b 00                	mov    (%eax),%eax
  800e70:	ba 00 00 00 00       	mov    $0x0,%edx
  800e75:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e78:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800e7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800e7e:	8d 40 04             	lea    0x4(%eax),%eax
  800e81:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800e84:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e89:	e9 ea 00 00 00       	jmp    800f78 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800e8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e91:	8b 50 04             	mov    0x4(%eax),%edx
  800e94:	8b 00                	mov    (%eax),%eax
  800e96:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e99:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800e9c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9f:	8d 40 08             	lea    0x8(%eax),%eax
  800ea2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800ea5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eaa:	e9 c9 00 00 00       	jmp    800f78 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800eaf:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb2:	8b 00                	mov    (%eax),%eax
  800eb4:	ba 00 00 00 00       	mov    $0x0,%edx
  800eb9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ebc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ebf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec2:	8d 40 04             	lea    0x4(%eax),%eax
  800ec5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800ec8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ecd:	e9 a6 00 00 00       	jmp    800f78 <vprintfmt+0x428>
			putch('0', putdat);
  800ed2:	83 ec 08             	sub    $0x8,%esp
  800ed5:	53                   	push   %ebx
  800ed6:	6a 30                	push   $0x30
  800ed8:	ff d6                	call   *%esi
	if (lflag >= 2)
  800eda:	83 c4 10             	add    $0x10,%esp
  800edd:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800ee1:	7f 26                	jg     800f09 <vprintfmt+0x3b9>
	else if (lflag)
  800ee3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800ee7:	74 3e                	je     800f27 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800ee9:	8b 45 14             	mov    0x14(%ebp),%eax
  800eec:	8b 00                	mov    (%eax),%eax
  800eee:	ba 00 00 00 00       	mov    $0x0,%edx
  800ef3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ef6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ef9:	8b 45 14             	mov    0x14(%ebp),%eax
  800efc:	8d 40 04             	lea    0x4(%eax),%eax
  800eff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800f02:	b8 08 00 00 00       	mov    $0x8,%eax
  800f07:	eb 6f                	jmp    800f78 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800f09:	8b 45 14             	mov    0x14(%ebp),%eax
  800f0c:	8b 50 04             	mov    0x4(%eax),%edx
  800f0f:	8b 00                	mov    (%eax),%eax
  800f11:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f14:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f17:	8b 45 14             	mov    0x14(%ebp),%eax
  800f1a:	8d 40 08             	lea    0x8(%eax),%eax
  800f1d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800f20:	b8 08 00 00 00       	mov    $0x8,%eax
  800f25:	eb 51                	jmp    800f78 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800f27:	8b 45 14             	mov    0x14(%ebp),%eax
  800f2a:	8b 00                	mov    (%eax),%eax
  800f2c:	ba 00 00 00 00       	mov    $0x0,%edx
  800f31:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f34:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f37:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3a:	8d 40 04             	lea    0x4(%eax),%eax
  800f3d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800f40:	b8 08 00 00 00       	mov    $0x8,%eax
  800f45:	eb 31                	jmp    800f78 <vprintfmt+0x428>
			putch('0', putdat);
  800f47:	83 ec 08             	sub    $0x8,%esp
  800f4a:	53                   	push   %ebx
  800f4b:	6a 30                	push   $0x30
  800f4d:	ff d6                	call   *%esi
			putch('x', putdat);
  800f4f:	83 c4 08             	add    $0x8,%esp
  800f52:	53                   	push   %ebx
  800f53:	6a 78                	push   $0x78
  800f55:	ff d6                	call   *%esi
			num = (unsigned long long)
  800f57:	8b 45 14             	mov    0x14(%ebp),%eax
  800f5a:	8b 00                	mov    (%eax),%eax
  800f5c:	ba 00 00 00 00       	mov    $0x0,%edx
  800f61:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f64:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800f67:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800f6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6d:	8d 40 04             	lea    0x4(%eax),%eax
  800f70:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800f73:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800f78:	83 ec 0c             	sub    $0xc,%esp
  800f7b:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800f7f:	52                   	push   %edx
  800f80:	ff 75 e0             	pushl  -0x20(%ebp)
  800f83:	50                   	push   %eax
  800f84:	ff 75 dc             	pushl  -0x24(%ebp)
  800f87:	ff 75 d8             	pushl  -0x28(%ebp)
  800f8a:	89 da                	mov    %ebx,%edx
  800f8c:	89 f0                	mov    %esi,%eax
  800f8e:	e8 a4 fa ff ff       	call   800a37 <printnum>
			break;
  800f93:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800f96:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f99:	83 c7 01             	add    $0x1,%edi
  800f9c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800fa0:	83 f8 25             	cmp    $0x25,%eax
  800fa3:	0f 84 be fb ff ff    	je     800b67 <vprintfmt+0x17>
			if (ch == '\0')
  800fa9:	85 c0                	test   %eax,%eax
  800fab:	0f 84 28 01 00 00    	je     8010d9 <vprintfmt+0x589>
			putch(ch, putdat);
  800fb1:	83 ec 08             	sub    $0x8,%esp
  800fb4:	53                   	push   %ebx
  800fb5:	50                   	push   %eax
  800fb6:	ff d6                	call   *%esi
  800fb8:	83 c4 10             	add    $0x10,%esp
  800fbb:	eb dc                	jmp    800f99 <vprintfmt+0x449>
	if (lflag >= 2)
  800fbd:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800fc1:	7f 26                	jg     800fe9 <vprintfmt+0x499>
	else if (lflag)
  800fc3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800fc7:	74 41                	je     80100a <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800fc9:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcc:	8b 00                	mov    (%eax),%eax
  800fce:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800fd6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800fd9:	8b 45 14             	mov    0x14(%ebp),%eax
  800fdc:	8d 40 04             	lea    0x4(%eax),%eax
  800fdf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800fe2:	b8 10 00 00 00       	mov    $0x10,%eax
  800fe7:	eb 8f                	jmp    800f78 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800fe9:	8b 45 14             	mov    0x14(%ebp),%eax
  800fec:	8b 50 04             	mov    0x4(%eax),%edx
  800fef:	8b 00                	mov    (%eax),%eax
  800ff1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ff4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ff7:	8b 45 14             	mov    0x14(%ebp),%eax
  800ffa:	8d 40 08             	lea    0x8(%eax),%eax
  800ffd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801000:	b8 10 00 00 00       	mov    $0x10,%eax
  801005:	e9 6e ff ff ff       	jmp    800f78 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80100a:	8b 45 14             	mov    0x14(%ebp),%eax
  80100d:	8b 00                	mov    (%eax),%eax
  80100f:	ba 00 00 00 00       	mov    $0x0,%edx
  801014:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801017:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80101a:	8b 45 14             	mov    0x14(%ebp),%eax
  80101d:	8d 40 04             	lea    0x4(%eax),%eax
  801020:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801023:	b8 10 00 00 00       	mov    $0x10,%eax
  801028:	e9 4b ff ff ff       	jmp    800f78 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80102d:	8b 45 14             	mov    0x14(%ebp),%eax
  801030:	83 c0 04             	add    $0x4,%eax
  801033:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801036:	8b 45 14             	mov    0x14(%ebp),%eax
  801039:	8b 00                	mov    (%eax),%eax
  80103b:	85 c0                	test   %eax,%eax
  80103d:	74 14                	je     801053 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80103f:	8b 13                	mov    (%ebx),%edx
  801041:	83 fa 7f             	cmp    $0x7f,%edx
  801044:	7f 37                	jg     80107d <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  801046:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  801048:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80104b:	89 45 14             	mov    %eax,0x14(%ebp)
  80104e:	e9 43 ff ff ff       	jmp    800f96 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  801053:	b8 0a 00 00 00       	mov    $0xa,%eax
  801058:	bf 1d 34 80 00       	mov    $0x80341d,%edi
							putch(ch, putdat);
  80105d:	83 ec 08             	sub    $0x8,%esp
  801060:	53                   	push   %ebx
  801061:	50                   	push   %eax
  801062:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  801064:	83 c7 01             	add    $0x1,%edi
  801067:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80106b:	83 c4 10             	add    $0x10,%esp
  80106e:	85 c0                	test   %eax,%eax
  801070:	75 eb                	jne    80105d <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  801072:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801075:	89 45 14             	mov    %eax,0x14(%ebp)
  801078:	e9 19 ff ff ff       	jmp    800f96 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80107d:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80107f:	b8 0a 00 00 00       	mov    $0xa,%eax
  801084:	bf 55 34 80 00       	mov    $0x803455,%edi
							putch(ch, putdat);
  801089:	83 ec 08             	sub    $0x8,%esp
  80108c:	53                   	push   %ebx
  80108d:	50                   	push   %eax
  80108e:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  801090:	83 c7 01             	add    $0x1,%edi
  801093:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  801097:	83 c4 10             	add    $0x10,%esp
  80109a:	85 c0                	test   %eax,%eax
  80109c:	75 eb                	jne    801089 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80109e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8010a1:	89 45 14             	mov    %eax,0x14(%ebp)
  8010a4:	e9 ed fe ff ff       	jmp    800f96 <vprintfmt+0x446>
			putch(ch, putdat);
  8010a9:	83 ec 08             	sub    $0x8,%esp
  8010ac:	53                   	push   %ebx
  8010ad:	6a 25                	push   $0x25
  8010af:	ff d6                	call   *%esi
			break;
  8010b1:	83 c4 10             	add    $0x10,%esp
  8010b4:	e9 dd fe ff ff       	jmp    800f96 <vprintfmt+0x446>
			putch('%', putdat);
  8010b9:	83 ec 08             	sub    $0x8,%esp
  8010bc:	53                   	push   %ebx
  8010bd:	6a 25                	push   $0x25
  8010bf:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010c1:	83 c4 10             	add    $0x10,%esp
  8010c4:	89 f8                	mov    %edi,%eax
  8010c6:	eb 03                	jmp    8010cb <vprintfmt+0x57b>
  8010c8:	83 e8 01             	sub    $0x1,%eax
  8010cb:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8010cf:	75 f7                	jne    8010c8 <vprintfmt+0x578>
  8010d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8010d4:	e9 bd fe ff ff       	jmp    800f96 <vprintfmt+0x446>
}
  8010d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010dc:	5b                   	pop    %ebx
  8010dd:	5e                   	pop    %esi
  8010de:	5f                   	pop    %edi
  8010df:	5d                   	pop    %ebp
  8010e0:	c3                   	ret    

008010e1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010e1:	55                   	push   %ebp
  8010e2:	89 e5                	mov    %esp,%ebp
  8010e4:	83 ec 18             	sub    $0x18,%esp
  8010e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ea:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010f0:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8010f4:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8010f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010fe:	85 c0                	test   %eax,%eax
  801100:	74 26                	je     801128 <vsnprintf+0x47>
  801102:	85 d2                	test   %edx,%edx
  801104:	7e 22                	jle    801128 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801106:	ff 75 14             	pushl  0x14(%ebp)
  801109:	ff 75 10             	pushl  0x10(%ebp)
  80110c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80110f:	50                   	push   %eax
  801110:	68 16 0b 80 00       	push   $0x800b16
  801115:	e8 36 fa ff ff       	call   800b50 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80111a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80111d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801120:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801123:	83 c4 10             	add    $0x10,%esp
}
  801126:	c9                   	leave  
  801127:	c3                   	ret    
		return -E_INVAL;
  801128:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80112d:	eb f7                	jmp    801126 <vsnprintf+0x45>

0080112f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
  801132:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801135:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801138:	50                   	push   %eax
  801139:	ff 75 10             	pushl  0x10(%ebp)
  80113c:	ff 75 0c             	pushl  0xc(%ebp)
  80113f:	ff 75 08             	pushl  0x8(%ebp)
  801142:	e8 9a ff ff ff       	call   8010e1 <vsnprintf>
	va_end(ap);

	return rc;
}
  801147:	c9                   	leave  
  801148:	c3                   	ret    

00801149 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801149:	55                   	push   %ebp
  80114a:	89 e5                	mov    %esp,%ebp
  80114c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80114f:	b8 00 00 00 00       	mov    $0x0,%eax
  801154:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801158:	74 05                	je     80115f <strlen+0x16>
		n++;
  80115a:	83 c0 01             	add    $0x1,%eax
  80115d:	eb f5                	jmp    801154 <strlen+0xb>
	return n;
}
  80115f:	5d                   	pop    %ebp
  801160:	c3                   	ret    

00801161 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801161:	55                   	push   %ebp
  801162:	89 e5                	mov    %esp,%ebp
  801164:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80116a:	ba 00 00 00 00       	mov    $0x0,%edx
  80116f:	39 c2                	cmp    %eax,%edx
  801171:	74 0d                	je     801180 <strnlen+0x1f>
  801173:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  801177:	74 05                	je     80117e <strnlen+0x1d>
		n++;
  801179:	83 c2 01             	add    $0x1,%edx
  80117c:	eb f1                	jmp    80116f <strnlen+0xe>
  80117e:	89 d0                	mov    %edx,%eax
	return n;
}
  801180:	5d                   	pop    %ebp
  801181:	c3                   	ret    

00801182 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801182:	55                   	push   %ebp
  801183:	89 e5                	mov    %esp,%ebp
  801185:	53                   	push   %ebx
  801186:	8b 45 08             	mov    0x8(%ebp),%eax
  801189:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80118c:	ba 00 00 00 00       	mov    $0x0,%edx
  801191:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  801195:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  801198:	83 c2 01             	add    $0x1,%edx
  80119b:	84 c9                	test   %cl,%cl
  80119d:	75 f2                	jne    801191 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80119f:	5b                   	pop    %ebx
  8011a0:	5d                   	pop    %ebp
  8011a1:	c3                   	ret    

008011a2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8011a2:	55                   	push   %ebp
  8011a3:	89 e5                	mov    %esp,%ebp
  8011a5:	53                   	push   %ebx
  8011a6:	83 ec 10             	sub    $0x10,%esp
  8011a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8011ac:	53                   	push   %ebx
  8011ad:	e8 97 ff ff ff       	call   801149 <strlen>
  8011b2:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8011b5:	ff 75 0c             	pushl  0xc(%ebp)
  8011b8:	01 d8                	add    %ebx,%eax
  8011ba:	50                   	push   %eax
  8011bb:	e8 c2 ff ff ff       	call   801182 <strcpy>
	return dst;
}
  8011c0:	89 d8                	mov    %ebx,%eax
  8011c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011c5:	c9                   	leave  
  8011c6:	c3                   	ret    

008011c7 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8011c7:	55                   	push   %ebp
  8011c8:	89 e5                	mov    %esp,%ebp
  8011ca:	56                   	push   %esi
  8011cb:	53                   	push   %ebx
  8011cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011d2:	89 c6                	mov    %eax,%esi
  8011d4:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011d7:	89 c2                	mov    %eax,%edx
  8011d9:	39 f2                	cmp    %esi,%edx
  8011db:	74 11                	je     8011ee <strncpy+0x27>
		*dst++ = *src;
  8011dd:	83 c2 01             	add    $0x1,%edx
  8011e0:	0f b6 19             	movzbl (%ecx),%ebx
  8011e3:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8011e6:	80 fb 01             	cmp    $0x1,%bl
  8011e9:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8011ec:	eb eb                	jmp    8011d9 <strncpy+0x12>
	}
	return ret;
}
  8011ee:	5b                   	pop    %ebx
  8011ef:	5e                   	pop    %esi
  8011f0:	5d                   	pop    %ebp
  8011f1:	c3                   	ret    

008011f2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8011f2:	55                   	push   %ebp
  8011f3:	89 e5                	mov    %esp,%ebp
  8011f5:	56                   	push   %esi
  8011f6:	53                   	push   %ebx
  8011f7:	8b 75 08             	mov    0x8(%ebp),%esi
  8011fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011fd:	8b 55 10             	mov    0x10(%ebp),%edx
  801200:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801202:	85 d2                	test   %edx,%edx
  801204:	74 21                	je     801227 <strlcpy+0x35>
  801206:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80120a:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80120c:	39 c2                	cmp    %eax,%edx
  80120e:	74 14                	je     801224 <strlcpy+0x32>
  801210:	0f b6 19             	movzbl (%ecx),%ebx
  801213:	84 db                	test   %bl,%bl
  801215:	74 0b                	je     801222 <strlcpy+0x30>
			*dst++ = *src++;
  801217:	83 c1 01             	add    $0x1,%ecx
  80121a:	83 c2 01             	add    $0x1,%edx
  80121d:	88 5a ff             	mov    %bl,-0x1(%edx)
  801220:	eb ea                	jmp    80120c <strlcpy+0x1a>
  801222:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801224:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801227:	29 f0                	sub    %esi,%eax
}
  801229:	5b                   	pop    %ebx
  80122a:	5e                   	pop    %esi
  80122b:	5d                   	pop    %ebp
  80122c:	c3                   	ret    

0080122d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80122d:	55                   	push   %ebp
  80122e:	89 e5                	mov    %esp,%ebp
  801230:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801233:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801236:	0f b6 01             	movzbl (%ecx),%eax
  801239:	84 c0                	test   %al,%al
  80123b:	74 0c                	je     801249 <strcmp+0x1c>
  80123d:	3a 02                	cmp    (%edx),%al
  80123f:	75 08                	jne    801249 <strcmp+0x1c>
		p++, q++;
  801241:	83 c1 01             	add    $0x1,%ecx
  801244:	83 c2 01             	add    $0x1,%edx
  801247:	eb ed                	jmp    801236 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801249:	0f b6 c0             	movzbl %al,%eax
  80124c:	0f b6 12             	movzbl (%edx),%edx
  80124f:	29 d0                	sub    %edx,%eax
}
  801251:	5d                   	pop    %ebp
  801252:	c3                   	ret    

00801253 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801253:	55                   	push   %ebp
  801254:	89 e5                	mov    %esp,%ebp
  801256:	53                   	push   %ebx
  801257:	8b 45 08             	mov    0x8(%ebp),%eax
  80125a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80125d:	89 c3                	mov    %eax,%ebx
  80125f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801262:	eb 06                	jmp    80126a <strncmp+0x17>
		n--, p++, q++;
  801264:	83 c0 01             	add    $0x1,%eax
  801267:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80126a:	39 d8                	cmp    %ebx,%eax
  80126c:	74 16                	je     801284 <strncmp+0x31>
  80126e:	0f b6 08             	movzbl (%eax),%ecx
  801271:	84 c9                	test   %cl,%cl
  801273:	74 04                	je     801279 <strncmp+0x26>
  801275:	3a 0a                	cmp    (%edx),%cl
  801277:	74 eb                	je     801264 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801279:	0f b6 00             	movzbl (%eax),%eax
  80127c:	0f b6 12             	movzbl (%edx),%edx
  80127f:	29 d0                	sub    %edx,%eax
}
  801281:	5b                   	pop    %ebx
  801282:	5d                   	pop    %ebp
  801283:	c3                   	ret    
		return 0;
  801284:	b8 00 00 00 00       	mov    $0x0,%eax
  801289:	eb f6                	jmp    801281 <strncmp+0x2e>

0080128b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80128b:	55                   	push   %ebp
  80128c:	89 e5                	mov    %esp,%ebp
  80128e:	8b 45 08             	mov    0x8(%ebp),%eax
  801291:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801295:	0f b6 10             	movzbl (%eax),%edx
  801298:	84 d2                	test   %dl,%dl
  80129a:	74 09                	je     8012a5 <strchr+0x1a>
		if (*s == c)
  80129c:	38 ca                	cmp    %cl,%dl
  80129e:	74 0a                	je     8012aa <strchr+0x1f>
	for (; *s; s++)
  8012a0:	83 c0 01             	add    $0x1,%eax
  8012a3:	eb f0                	jmp    801295 <strchr+0xa>
			return (char *) s;
	return 0;
  8012a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012aa:	5d                   	pop    %ebp
  8012ab:	c3                   	ret    

008012ac <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
  8012af:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8012b6:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8012b9:	38 ca                	cmp    %cl,%dl
  8012bb:	74 09                	je     8012c6 <strfind+0x1a>
  8012bd:	84 d2                	test   %dl,%dl
  8012bf:	74 05                	je     8012c6 <strfind+0x1a>
	for (; *s; s++)
  8012c1:	83 c0 01             	add    $0x1,%eax
  8012c4:	eb f0                	jmp    8012b6 <strfind+0xa>
			break;
	return (char *) s;
}
  8012c6:	5d                   	pop    %ebp
  8012c7:	c3                   	ret    

008012c8 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012c8:	55                   	push   %ebp
  8012c9:	89 e5                	mov    %esp,%ebp
  8012cb:	57                   	push   %edi
  8012cc:	56                   	push   %esi
  8012cd:	53                   	push   %ebx
  8012ce:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012d1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8012d4:	85 c9                	test   %ecx,%ecx
  8012d6:	74 31                	je     801309 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8012d8:	89 f8                	mov    %edi,%eax
  8012da:	09 c8                	or     %ecx,%eax
  8012dc:	a8 03                	test   $0x3,%al
  8012de:	75 23                	jne    801303 <memset+0x3b>
		c &= 0xFF;
  8012e0:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8012e4:	89 d3                	mov    %edx,%ebx
  8012e6:	c1 e3 08             	shl    $0x8,%ebx
  8012e9:	89 d0                	mov    %edx,%eax
  8012eb:	c1 e0 18             	shl    $0x18,%eax
  8012ee:	89 d6                	mov    %edx,%esi
  8012f0:	c1 e6 10             	shl    $0x10,%esi
  8012f3:	09 f0                	or     %esi,%eax
  8012f5:	09 c2                	or     %eax,%edx
  8012f7:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8012f9:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8012fc:	89 d0                	mov    %edx,%eax
  8012fe:	fc                   	cld    
  8012ff:	f3 ab                	rep stos %eax,%es:(%edi)
  801301:	eb 06                	jmp    801309 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801303:	8b 45 0c             	mov    0xc(%ebp),%eax
  801306:	fc                   	cld    
  801307:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801309:	89 f8                	mov    %edi,%eax
  80130b:	5b                   	pop    %ebx
  80130c:	5e                   	pop    %esi
  80130d:	5f                   	pop    %edi
  80130e:	5d                   	pop    %ebp
  80130f:	c3                   	ret    

00801310 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801310:	55                   	push   %ebp
  801311:	89 e5                	mov    %esp,%ebp
  801313:	57                   	push   %edi
  801314:	56                   	push   %esi
  801315:	8b 45 08             	mov    0x8(%ebp),%eax
  801318:	8b 75 0c             	mov    0xc(%ebp),%esi
  80131b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80131e:	39 c6                	cmp    %eax,%esi
  801320:	73 32                	jae    801354 <memmove+0x44>
  801322:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801325:	39 c2                	cmp    %eax,%edx
  801327:	76 2b                	jbe    801354 <memmove+0x44>
		s += n;
		d += n;
  801329:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80132c:	89 fe                	mov    %edi,%esi
  80132e:	09 ce                	or     %ecx,%esi
  801330:	09 d6                	or     %edx,%esi
  801332:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801338:	75 0e                	jne    801348 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80133a:	83 ef 04             	sub    $0x4,%edi
  80133d:	8d 72 fc             	lea    -0x4(%edx),%esi
  801340:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801343:	fd                   	std    
  801344:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801346:	eb 09                	jmp    801351 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801348:	83 ef 01             	sub    $0x1,%edi
  80134b:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80134e:	fd                   	std    
  80134f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801351:	fc                   	cld    
  801352:	eb 1a                	jmp    80136e <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801354:	89 c2                	mov    %eax,%edx
  801356:	09 ca                	or     %ecx,%edx
  801358:	09 f2                	or     %esi,%edx
  80135a:	f6 c2 03             	test   $0x3,%dl
  80135d:	75 0a                	jne    801369 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80135f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801362:	89 c7                	mov    %eax,%edi
  801364:	fc                   	cld    
  801365:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801367:	eb 05                	jmp    80136e <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  801369:	89 c7                	mov    %eax,%edi
  80136b:	fc                   	cld    
  80136c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80136e:	5e                   	pop    %esi
  80136f:	5f                   	pop    %edi
  801370:	5d                   	pop    %ebp
  801371:	c3                   	ret    

00801372 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801372:	55                   	push   %ebp
  801373:	89 e5                	mov    %esp,%ebp
  801375:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801378:	ff 75 10             	pushl  0x10(%ebp)
  80137b:	ff 75 0c             	pushl  0xc(%ebp)
  80137e:	ff 75 08             	pushl  0x8(%ebp)
  801381:	e8 8a ff ff ff       	call   801310 <memmove>
}
  801386:	c9                   	leave  
  801387:	c3                   	ret    

00801388 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801388:	55                   	push   %ebp
  801389:	89 e5                	mov    %esp,%ebp
  80138b:	56                   	push   %esi
  80138c:	53                   	push   %ebx
  80138d:	8b 45 08             	mov    0x8(%ebp),%eax
  801390:	8b 55 0c             	mov    0xc(%ebp),%edx
  801393:	89 c6                	mov    %eax,%esi
  801395:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801398:	39 f0                	cmp    %esi,%eax
  80139a:	74 1c                	je     8013b8 <memcmp+0x30>
		if (*s1 != *s2)
  80139c:	0f b6 08             	movzbl (%eax),%ecx
  80139f:	0f b6 1a             	movzbl (%edx),%ebx
  8013a2:	38 d9                	cmp    %bl,%cl
  8013a4:	75 08                	jne    8013ae <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8013a6:	83 c0 01             	add    $0x1,%eax
  8013a9:	83 c2 01             	add    $0x1,%edx
  8013ac:	eb ea                	jmp    801398 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8013ae:	0f b6 c1             	movzbl %cl,%eax
  8013b1:	0f b6 db             	movzbl %bl,%ebx
  8013b4:	29 d8                	sub    %ebx,%eax
  8013b6:	eb 05                	jmp    8013bd <memcmp+0x35>
	}

	return 0;
  8013b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013bd:	5b                   	pop    %ebx
  8013be:	5e                   	pop    %esi
  8013bf:	5d                   	pop    %ebp
  8013c0:	c3                   	ret    

008013c1 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8013c1:	55                   	push   %ebp
  8013c2:	89 e5                	mov    %esp,%ebp
  8013c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8013ca:	89 c2                	mov    %eax,%edx
  8013cc:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8013cf:	39 d0                	cmp    %edx,%eax
  8013d1:	73 09                	jae    8013dc <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013d3:	38 08                	cmp    %cl,(%eax)
  8013d5:	74 05                	je     8013dc <memfind+0x1b>
	for (; s < ends; s++)
  8013d7:	83 c0 01             	add    $0x1,%eax
  8013da:	eb f3                	jmp    8013cf <memfind+0xe>
			break;
	return (void *) s;
}
  8013dc:	5d                   	pop    %ebp
  8013dd:	c3                   	ret    

008013de <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013de:	55                   	push   %ebp
  8013df:	89 e5                	mov    %esp,%ebp
  8013e1:	57                   	push   %edi
  8013e2:	56                   	push   %esi
  8013e3:	53                   	push   %ebx
  8013e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013ea:	eb 03                	jmp    8013ef <strtol+0x11>
		s++;
  8013ec:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8013ef:	0f b6 01             	movzbl (%ecx),%eax
  8013f2:	3c 20                	cmp    $0x20,%al
  8013f4:	74 f6                	je     8013ec <strtol+0xe>
  8013f6:	3c 09                	cmp    $0x9,%al
  8013f8:	74 f2                	je     8013ec <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8013fa:	3c 2b                	cmp    $0x2b,%al
  8013fc:	74 2a                	je     801428 <strtol+0x4a>
	int neg = 0;
  8013fe:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801403:	3c 2d                	cmp    $0x2d,%al
  801405:	74 2b                	je     801432 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801407:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  80140d:	75 0f                	jne    80141e <strtol+0x40>
  80140f:	80 39 30             	cmpb   $0x30,(%ecx)
  801412:	74 28                	je     80143c <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801414:	85 db                	test   %ebx,%ebx
  801416:	b8 0a 00 00 00       	mov    $0xa,%eax
  80141b:	0f 44 d8             	cmove  %eax,%ebx
  80141e:	b8 00 00 00 00       	mov    $0x0,%eax
  801423:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801426:	eb 50                	jmp    801478 <strtol+0x9a>
		s++;
  801428:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  80142b:	bf 00 00 00 00       	mov    $0x0,%edi
  801430:	eb d5                	jmp    801407 <strtol+0x29>
		s++, neg = 1;
  801432:	83 c1 01             	add    $0x1,%ecx
  801435:	bf 01 00 00 00       	mov    $0x1,%edi
  80143a:	eb cb                	jmp    801407 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80143c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801440:	74 0e                	je     801450 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  801442:	85 db                	test   %ebx,%ebx
  801444:	75 d8                	jne    80141e <strtol+0x40>
		s++, base = 8;
  801446:	83 c1 01             	add    $0x1,%ecx
  801449:	bb 08 00 00 00       	mov    $0x8,%ebx
  80144e:	eb ce                	jmp    80141e <strtol+0x40>
		s += 2, base = 16;
  801450:	83 c1 02             	add    $0x2,%ecx
  801453:	bb 10 00 00 00       	mov    $0x10,%ebx
  801458:	eb c4                	jmp    80141e <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  80145a:	8d 72 9f             	lea    -0x61(%edx),%esi
  80145d:	89 f3                	mov    %esi,%ebx
  80145f:	80 fb 19             	cmp    $0x19,%bl
  801462:	77 29                	ja     80148d <strtol+0xaf>
			dig = *s - 'a' + 10;
  801464:	0f be d2             	movsbl %dl,%edx
  801467:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  80146a:	3b 55 10             	cmp    0x10(%ebp),%edx
  80146d:	7d 30                	jge    80149f <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  80146f:	83 c1 01             	add    $0x1,%ecx
  801472:	0f af 45 10          	imul   0x10(%ebp),%eax
  801476:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801478:	0f b6 11             	movzbl (%ecx),%edx
  80147b:	8d 72 d0             	lea    -0x30(%edx),%esi
  80147e:	89 f3                	mov    %esi,%ebx
  801480:	80 fb 09             	cmp    $0x9,%bl
  801483:	77 d5                	ja     80145a <strtol+0x7c>
			dig = *s - '0';
  801485:	0f be d2             	movsbl %dl,%edx
  801488:	83 ea 30             	sub    $0x30,%edx
  80148b:	eb dd                	jmp    80146a <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  80148d:	8d 72 bf             	lea    -0x41(%edx),%esi
  801490:	89 f3                	mov    %esi,%ebx
  801492:	80 fb 19             	cmp    $0x19,%bl
  801495:	77 08                	ja     80149f <strtol+0xc1>
			dig = *s - 'A' + 10;
  801497:	0f be d2             	movsbl %dl,%edx
  80149a:	83 ea 37             	sub    $0x37,%edx
  80149d:	eb cb                	jmp    80146a <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  80149f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014a3:	74 05                	je     8014aa <strtol+0xcc>
		*endptr = (char *) s;
  8014a5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014a8:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8014aa:	89 c2                	mov    %eax,%edx
  8014ac:	f7 da                	neg    %edx
  8014ae:	85 ff                	test   %edi,%edi
  8014b0:	0f 45 c2             	cmovne %edx,%eax
}
  8014b3:	5b                   	pop    %ebx
  8014b4:	5e                   	pop    %esi
  8014b5:	5f                   	pop    %edi
  8014b6:	5d                   	pop    %ebp
  8014b7:	c3                   	ret    

008014b8 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8014b8:	55                   	push   %ebp
  8014b9:	89 e5                	mov    %esp,%ebp
  8014bb:	57                   	push   %edi
  8014bc:	56                   	push   %esi
  8014bd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014be:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8014c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014c9:	89 c3                	mov    %eax,%ebx
  8014cb:	89 c7                	mov    %eax,%edi
  8014cd:	89 c6                	mov    %eax,%esi
  8014cf:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8014d1:	5b                   	pop    %ebx
  8014d2:	5e                   	pop    %esi
  8014d3:	5f                   	pop    %edi
  8014d4:	5d                   	pop    %ebp
  8014d5:	c3                   	ret    

008014d6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8014d6:	55                   	push   %ebp
  8014d7:	89 e5                	mov    %esp,%ebp
  8014d9:	57                   	push   %edi
  8014da:	56                   	push   %esi
  8014db:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8014e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8014e6:	89 d1                	mov    %edx,%ecx
  8014e8:	89 d3                	mov    %edx,%ebx
  8014ea:	89 d7                	mov    %edx,%edi
  8014ec:	89 d6                	mov    %edx,%esi
  8014ee:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8014f0:	5b                   	pop    %ebx
  8014f1:	5e                   	pop    %esi
  8014f2:	5f                   	pop    %edi
  8014f3:	5d                   	pop    %ebp
  8014f4:	c3                   	ret    

008014f5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8014f5:	55                   	push   %ebp
  8014f6:	89 e5                	mov    %esp,%ebp
  8014f8:	57                   	push   %edi
  8014f9:	56                   	push   %esi
  8014fa:	53                   	push   %ebx
  8014fb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8014fe:	b9 00 00 00 00       	mov    $0x0,%ecx
  801503:	8b 55 08             	mov    0x8(%ebp),%edx
  801506:	b8 03 00 00 00       	mov    $0x3,%eax
  80150b:	89 cb                	mov    %ecx,%ebx
  80150d:	89 cf                	mov    %ecx,%edi
  80150f:	89 ce                	mov    %ecx,%esi
  801511:	cd 30                	int    $0x30
	if(check && ret > 0)
  801513:	85 c0                	test   %eax,%eax
  801515:	7f 08                	jg     80151f <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801517:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80151a:	5b                   	pop    %ebx
  80151b:	5e                   	pop    %esi
  80151c:	5f                   	pop    %edi
  80151d:	5d                   	pop    %ebp
  80151e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80151f:	83 ec 0c             	sub    $0xc,%esp
  801522:	50                   	push   %eax
  801523:	6a 03                	push   $0x3
  801525:	68 68 36 80 00       	push   $0x803668
  80152a:	6a 43                	push   $0x43
  80152c:	68 85 36 80 00       	push   $0x803685
  801531:	e8 f7 f3 ff ff       	call   80092d <_panic>

00801536 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801536:	55                   	push   %ebp
  801537:	89 e5                	mov    %esp,%ebp
  801539:	57                   	push   %edi
  80153a:	56                   	push   %esi
  80153b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80153c:	ba 00 00 00 00       	mov    $0x0,%edx
  801541:	b8 02 00 00 00       	mov    $0x2,%eax
  801546:	89 d1                	mov    %edx,%ecx
  801548:	89 d3                	mov    %edx,%ebx
  80154a:	89 d7                	mov    %edx,%edi
  80154c:	89 d6                	mov    %edx,%esi
  80154e:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801550:	5b                   	pop    %ebx
  801551:	5e                   	pop    %esi
  801552:	5f                   	pop    %edi
  801553:	5d                   	pop    %ebp
  801554:	c3                   	ret    

00801555 <sys_yield>:

void
sys_yield(void)
{
  801555:	55                   	push   %ebp
  801556:	89 e5                	mov    %esp,%ebp
  801558:	57                   	push   %edi
  801559:	56                   	push   %esi
  80155a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80155b:	ba 00 00 00 00       	mov    $0x0,%edx
  801560:	b8 0b 00 00 00       	mov    $0xb,%eax
  801565:	89 d1                	mov    %edx,%ecx
  801567:	89 d3                	mov    %edx,%ebx
  801569:	89 d7                	mov    %edx,%edi
  80156b:	89 d6                	mov    %edx,%esi
  80156d:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80156f:	5b                   	pop    %ebx
  801570:	5e                   	pop    %esi
  801571:	5f                   	pop    %edi
  801572:	5d                   	pop    %ebp
  801573:	c3                   	ret    

00801574 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
  801577:	57                   	push   %edi
  801578:	56                   	push   %esi
  801579:	53                   	push   %ebx
  80157a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80157d:	be 00 00 00 00       	mov    $0x0,%esi
  801582:	8b 55 08             	mov    0x8(%ebp),%edx
  801585:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801588:	b8 04 00 00 00       	mov    $0x4,%eax
  80158d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801590:	89 f7                	mov    %esi,%edi
  801592:	cd 30                	int    $0x30
	if(check && ret > 0)
  801594:	85 c0                	test   %eax,%eax
  801596:	7f 08                	jg     8015a0 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801598:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80159b:	5b                   	pop    %ebx
  80159c:	5e                   	pop    %esi
  80159d:	5f                   	pop    %edi
  80159e:	5d                   	pop    %ebp
  80159f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8015a0:	83 ec 0c             	sub    $0xc,%esp
  8015a3:	50                   	push   %eax
  8015a4:	6a 04                	push   $0x4
  8015a6:	68 68 36 80 00       	push   $0x803668
  8015ab:	6a 43                	push   $0x43
  8015ad:	68 85 36 80 00       	push   $0x803685
  8015b2:	e8 76 f3 ff ff       	call   80092d <_panic>

008015b7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8015b7:	55                   	push   %ebp
  8015b8:	89 e5                	mov    %esp,%ebp
  8015ba:	57                   	push   %edi
  8015bb:	56                   	push   %esi
  8015bc:	53                   	push   %ebx
  8015bd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8015c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8015c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015c6:	b8 05 00 00 00       	mov    $0x5,%eax
  8015cb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8015ce:	8b 7d 14             	mov    0x14(%ebp),%edi
  8015d1:	8b 75 18             	mov    0x18(%ebp),%esi
  8015d4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8015d6:	85 c0                	test   %eax,%eax
  8015d8:	7f 08                	jg     8015e2 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8015da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015dd:	5b                   	pop    %ebx
  8015de:	5e                   	pop    %esi
  8015df:	5f                   	pop    %edi
  8015e0:	5d                   	pop    %ebp
  8015e1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8015e2:	83 ec 0c             	sub    $0xc,%esp
  8015e5:	50                   	push   %eax
  8015e6:	6a 05                	push   $0x5
  8015e8:	68 68 36 80 00       	push   $0x803668
  8015ed:	6a 43                	push   $0x43
  8015ef:	68 85 36 80 00       	push   $0x803685
  8015f4:	e8 34 f3 ff ff       	call   80092d <_panic>

008015f9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
  8015fc:	57                   	push   %edi
  8015fd:	56                   	push   %esi
  8015fe:	53                   	push   %ebx
  8015ff:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801602:	bb 00 00 00 00       	mov    $0x0,%ebx
  801607:	8b 55 08             	mov    0x8(%ebp),%edx
  80160a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80160d:	b8 06 00 00 00       	mov    $0x6,%eax
  801612:	89 df                	mov    %ebx,%edi
  801614:	89 de                	mov    %ebx,%esi
  801616:	cd 30                	int    $0x30
	if(check && ret > 0)
  801618:	85 c0                	test   %eax,%eax
  80161a:	7f 08                	jg     801624 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80161c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80161f:	5b                   	pop    %ebx
  801620:	5e                   	pop    %esi
  801621:	5f                   	pop    %edi
  801622:	5d                   	pop    %ebp
  801623:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801624:	83 ec 0c             	sub    $0xc,%esp
  801627:	50                   	push   %eax
  801628:	6a 06                	push   $0x6
  80162a:	68 68 36 80 00       	push   $0x803668
  80162f:	6a 43                	push   $0x43
  801631:	68 85 36 80 00       	push   $0x803685
  801636:	e8 f2 f2 ff ff       	call   80092d <_panic>

0080163b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80163b:	55                   	push   %ebp
  80163c:	89 e5                	mov    %esp,%ebp
  80163e:	57                   	push   %edi
  80163f:	56                   	push   %esi
  801640:	53                   	push   %ebx
  801641:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801644:	bb 00 00 00 00       	mov    $0x0,%ebx
  801649:	8b 55 08             	mov    0x8(%ebp),%edx
  80164c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80164f:	b8 08 00 00 00       	mov    $0x8,%eax
  801654:	89 df                	mov    %ebx,%edi
  801656:	89 de                	mov    %ebx,%esi
  801658:	cd 30                	int    $0x30
	if(check && ret > 0)
  80165a:	85 c0                	test   %eax,%eax
  80165c:	7f 08                	jg     801666 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80165e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801661:	5b                   	pop    %ebx
  801662:	5e                   	pop    %esi
  801663:	5f                   	pop    %edi
  801664:	5d                   	pop    %ebp
  801665:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801666:	83 ec 0c             	sub    $0xc,%esp
  801669:	50                   	push   %eax
  80166a:	6a 08                	push   $0x8
  80166c:	68 68 36 80 00       	push   $0x803668
  801671:	6a 43                	push   $0x43
  801673:	68 85 36 80 00       	push   $0x803685
  801678:	e8 b0 f2 ff ff       	call   80092d <_panic>

0080167d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80167d:	55                   	push   %ebp
  80167e:	89 e5                	mov    %esp,%ebp
  801680:	57                   	push   %edi
  801681:	56                   	push   %esi
  801682:	53                   	push   %ebx
  801683:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801686:	bb 00 00 00 00       	mov    $0x0,%ebx
  80168b:	8b 55 08             	mov    0x8(%ebp),%edx
  80168e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801691:	b8 09 00 00 00       	mov    $0x9,%eax
  801696:	89 df                	mov    %ebx,%edi
  801698:	89 de                	mov    %ebx,%esi
  80169a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80169c:	85 c0                	test   %eax,%eax
  80169e:	7f 08                	jg     8016a8 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8016a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016a3:	5b                   	pop    %ebx
  8016a4:	5e                   	pop    %esi
  8016a5:	5f                   	pop    %edi
  8016a6:	5d                   	pop    %ebp
  8016a7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8016a8:	83 ec 0c             	sub    $0xc,%esp
  8016ab:	50                   	push   %eax
  8016ac:	6a 09                	push   $0x9
  8016ae:	68 68 36 80 00       	push   $0x803668
  8016b3:	6a 43                	push   $0x43
  8016b5:	68 85 36 80 00       	push   $0x803685
  8016ba:	e8 6e f2 ff ff       	call   80092d <_panic>

008016bf <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
  8016c2:	57                   	push   %edi
  8016c3:	56                   	push   %esi
  8016c4:	53                   	push   %ebx
  8016c5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8016c8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8016d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016d3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8016d8:	89 df                	mov    %ebx,%edi
  8016da:	89 de                	mov    %ebx,%esi
  8016dc:	cd 30                	int    $0x30
	if(check && ret > 0)
  8016de:	85 c0                	test   %eax,%eax
  8016e0:	7f 08                	jg     8016ea <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8016e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016e5:	5b                   	pop    %ebx
  8016e6:	5e                   	pop    %esi
  8016e7:	5f                   	pop    %edi
  8016e8:	5d                   	pop    %ebp
  8016e9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8016ea:	83 ec 0c             	sub    $0xc,%esp
  8016ed:	50                   	push   %eax
  8016ee:	6a 0a                	push   $0xa
  8016f0:	68 68 36 80 00       	push   $0x803668
  8016f5:	6a 43                	push   $0x43
  8016f7:	68 85 36 80 00       	push   $0x803685
  8016fc:	e8 2c f2 ff ff       	call   80092d <_panic>

00801701 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
  801704:	57                   	push   %edi
  801705:	56                   	push   %esi
  801706:	53                   	push   %ebx
	asm volatile("int %1\n"
  801707:	8b 55 08             	mov    0x8(%ebp),%edx
  80170a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80170d:	b8 0c 00 00 00       	mov    $0xc,%eax
  801712:	be 00 00 00 00       	mov    $0x0,%esi
  801717:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80171a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80171d:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80171f:	5b                   	pop    %ebx
  801720:	5e                   	pop    %esi
  801721:	5f                   	pop    %edi
  801722:	5d                   	pop    %ebp
  801723:	c3                   	ret    

00801724 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
  801727:	57                   	push   %edi
  801728:	56                   	push   %esi
  801729:	53                   	push   %ebx
  80172a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80172d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801732:	8b 55 08             	mov    0x8(%ebp),%edx
  801735:	b8 0d 00 00 00       	mov    $0xd,%eax
  80173a:	89 cb                	mov    %ecx,%ebx
  80173c:	89 cf                	mov    %ecx,%edi
  80173e:	89 ce                	mov    %ecx,%esi
  801740:	cd 30                	int    $0x30
	if(check && ret > 0)
  801742:	85 c0                	test   %eax,%eax
  801744:	7f 08                	jg     80174e <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801746:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801749:	5b                   	pop    %ebx
  80174a:	5e                   	pop    %esi
  80174b:	5f                   	pop    %edi
  80174c:	5d                   	pop    %ebp
  80174d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80174e:	83 ec 0c             	sub    $0xc,%esp
  801751:	50                   	push   %eax
  801752:	6a 0d                	push   $0xd
  801754:	68 68 36 80 00       	push   $0x803668
  801759:	6a 43                	push   $0x43
  80175b:	68 85 36 80 00       	push   $0x803685
  801760:	e8 c8 f1 ff ff       	call   80092d <_panic>

00801765 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
  801768:	57                   	push   %edi
  801769:	56                   	push   %esi
  80176a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80176b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801770:	8b 55 08             	mov    0x8(%ebp),%edx
  801773:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801776:	b8 0e 00 00 00       	mov    $0xe,%eax
  80177b:	89 df                	mov    %ebx,%edi
  80177d:	89 de                	mov    %ebx,%esi
  80177f:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801781:	5b                   	pop    %ebx
  801782:	5e                   	pop    %esi
  801783:	5f                   	pop    %edi
  801784:	5d                   	pop    %ebp
  801785:	c3                   	ret    

00801786 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
  801789:	57                   	push   %edi
  80178a:	56                   	push   %esi
  80178b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80178c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801791:	8b 55 08             	mov    0x8(%ebp),%edx
  801794:	b8 0f 00 00 00       	mov    $0xf,%eax
  801799:	89 cb                	mov    %ecx,%ebx
  80179b:	89 cf                	mov    %ecx,%edi
  80179d:	89 ce                	mov    %ecx,%esi
  80179f:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8017a1:	5b                   	pop    %ebx
  8017a2:	5e                   	pop    %esi
  8017a3:	5f                   	pop    %edi
  8017a4:	5d                   	pop    %ebp
  8017a5:	c3                   	ret    

008017a6 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
  8017a9:	57                   	push   %edi
  8017aa:	56                   	push   %esi
  8017ab:	53                   	push   %ebx
	asm volatile("int %1\n"
  8017ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b1:	b8 10 00 00 00       	mov    $0x10,%eax
  8017b6:	89 d1                	mov    %edx,%ecx
  8017b8:	89 d3                	mov    %edx,%ebx
  8017ba:	89 d7                	mov    %edx,%edi
  8017bc:	89 d6                	mov    %edx,%esi
  8017be:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8017c0:	5b                   	pop    %ebx
  8017c1:	5e                   	pop    %esi
  8017c2:	5f                   	pop    %edi
  8017c3:	5d                   	pop    %ebp
  8017c4:	c3                   	ret    

008017c5 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
  8017c8:	57                   	push   %edi
  8017c9:	56                   	push   %esi
  8017ca:	53                   	push   %ebx
	asm volatile("int %1\n"
  8017cb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8017d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017d6:	b8 11 00 00 00       	mov    $0x11,%eax
  8017db:	89 df                	mov    %ebx,%edi
  8017dd:	89 de                	mov    %ebx,%esi
  8017df:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8017e1:	5b                   	pop    %ebx
  8017e2:	5e                   	pop    %esi
  8017e3:	5f                   	pop    %edi
  8017e4:	5d                   	pop    %ebp
  8017e5:	c3                   	ret    

008017e6 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
  8017e9:	57                   	push   %edi
  8017ea:	56                   	push   %esi
  8017eb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8017ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8017f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017f7:	b8 12 00 00 00       	mov    $0x12,%eax
  8017fc:	89 df                	mov    %ebx,%edi
  8017fe:	89 de                	mov    %ebx,%esi
  801800:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801802:	5b                   	pop    %ebx
  801803:	5e                   	pop    %esi
  801804:	5f                   	pop    %edi
  801805:	5d                   	pop    %ebp
  801806:	c3                   	ret    

00801807 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
  80180a:	57                   	push   %edi
  80180b:	56                   	push   %esi
  80180c:	53                   	push   %ebx
  80180d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801810:	bb 00 00 00 00       	mov    $0x0,%ebx
  801815:	8b 55 08             	mov    0x8(%ebp),%edx
  801818:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80181b:	b8 13 00 00 00       	mov    $0x13,%eax
  801820:	89 df                	mov    %ebx,%edi
  801822:	89 de                	mov    %ebx,%esi
  801824:	cd 30                	int    $0x30
	if(check && ret > 0)
  801826:	85 c0                	test   %eax,%eax
  801828:	7f 08                	jg     801832 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80182a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80182d:	5b                   	pop    %ebx
  80182e:	5e                   	pop    %esi
  80182f:	5f                   	pop    %edi
  801830:	5d                   	pop    %ebp
  801831:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801832:	83 ec 0c             	sub    $0xc,%esp
  801835:	50                   	push   %eax
  801836:	6a 13                	push   $0x13
  801838:	68 68 36 80 00       	push   $0x803668
  80183d:	6a 43                	push   $0x43
  80183f:	68 85 36 80 00       	push   $0x803685
  801844:	e8 e4 f0 ff ff       	call   80092d <_panic>

00801849 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
  80184c:	57                   	push   %edi
  80184d:	56                   	push   %esi
  80184e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80184f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801854:	8b 55 08             	mov    0x8(%ebp),%edx
  801857:	b8 14 00 00 00       	mov    $0x14,%eax
  80185c:	89 cb                	mov    %ecx,%ebx
  80185e:	89 cf                	mov    %ecx,%edi
  801860:	89 ce                	mov    %ecx,%esi
  801862:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801864:	5b                   	pop    %ebx
  801865:	5e                   	pop    %esi
  801866:	5f                   	pop    %edi
  801867:	5d                   	pop    %ebp
  801868:	c3                   	ret    

00801869 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80186c:	8b 45 08             	mov    0x8(%ebp),%eax
  80186f:	05 00 00 00 30       	add    $0x30000000,%eax
  801874:	c1 e8 0c             	shr    $0xc,%eax
}
  801877:	5d                   	pop    %ebp
  801878:	c3                   	ret    

00801879 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80187c:	8b 45 08             	mov    0x8(%ebp),%eax
  80187f:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801884:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801889:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80188e:	5d                   	pop    %ebp
  80188f:	c3                   	ret    

00801890 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
  801893:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801898:	89 c2                	mov    %eax,%edx
  80189a:	c1 ea 16             	shr    $0x16,%edx
  80189d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8018a4:	f6 c2 01             	test   $0x1,%dl
  8018a7:	74 2d                	je     8018d6 <fd_alloc+0x46>
  8018a9:	89 c2                	mov    %eax,%edx
  8018ab:	c1 ea 0c             	shr    $0xc,%edx
  8018ae:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018b5:	f6 c2 01             	test   $0x1,%dl
  8018b8:	74 1c                	je     8018d6 <fd_alloc+0x46>
  8018ba:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8018bf:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8018c4:	75 d2                	jne    801898 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8018c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8018cf:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8018d4:	eb 0a                	jmp    8018e0 <fd_alloc+0x50>
			*fd_store = fd;
  8018d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018d9:	89 01                	mov    %eax,(%ecx)
			return 0;
  8018db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018e0:	5d                   	pop    %ebp
  8018e1:	c3                   	ret    

008018e2 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
  8018e5:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8018e8:	83 f8 1f             	cmp    $0x1f,%eax
  8018eb:	77 30                	ja     80191d <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8018ed:	c1 e0 0c             	shl    $0xc,%eax
  8018f0:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8018f5:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8018fb:	f6 c2 01             	test   $0x1,%dl
  8018fe:	74 24                	je     801924 <fd_lookup+0x42>
  801900:	89 c2                	mov    %eax,%edx
  801902:	c1 ea 0c             	shr    $0xc,%edx
  801905:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80190c:	f6 c2 01             	test   $0x1,%dl
  80190f:	74 1a                	je     80192b <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801911:	8b 55 0c             	mov    0xc(%ebp),%edx
  801914:	89 02                	mov    %eax,(%edx)
	return 0;
  801916:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80191b:	5d                   	pop    %ebp
  80191c:	c3                   	ret    
		return -E_INVAL;
  80191d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801922:	eb f7                	jmp    80191b <fd_lookup+0x39>
		return -E_INVAL;
  801924:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801929:	eb f0                	jmp    80191b <fd_lookup+0x39>
  80192b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801930:	eb e9                	jmp    80191b <fd_lookup+0x39>

00801932 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801932:	55                   	push   %ebp
  801933:	89 e5                	mov    %esp,%ebp
  801935:	83 ec 08             	sub    $0x8,%esp
  801938:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80193b:	ba 00 00 00 00       	mov    $0x0,%edx
  801940:	b8 24 40 80 00       	mov    $0x804024,%eax
		if (devtab[i]->dev_id == dev_id) {
  801945:	39 08                	cmp    %ecx,(%eax)
  801947:	74 38                	je     801981 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801949:	83 c2 01             	add    $0x1,%edx
  80194c:	8b 04 95 10 37 80 00 	mov    0x803710(,%edx,4),%eax
  801953:	85 c0                	test   %eax,%eax
  801955:	75 ee                	jne    801945 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801957:	a1 1c 50 80 00       	mov    0x80501c,%eax
  80195c:	8b 40 48             	mov    0x48(%eax),%eax
  80195f:	83 ec 04             	sub    $0x4,%esp
  801962:	51                   	push   %ecx
  801963:	50                   	push   %eax
  801964:	68 94 36 80 00       	push   $0x803694
  801969:	e8 b5 f0 ff ff       	call   800a23 <cprintf>
	*dev = 0;
  80196e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801971:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801977:	83 c4 10             	add    $0x10,%esp
  80197a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80197f:	c9                   	leave  
  801980:	c3                   	ret    
			*dev = devtab[i];
  801981:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801984:	89 01                	mov    %eax,(%ecx)
			return 0;
  801986:	b8 00 00 00 00       	mov    $0x0,%eax
  80198b:	eb f2                	jmp    80197f <dev_lookup+0x4d>

0080198d <fd_close>:
{
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
  801990:	57                   	push   %edi
  801991:	56                   	push   %esi
  801992:	53                   	push   %ebx
  801993:	83 ec 24             	sub    $0x24,%esp
  801996:	8b 75 08             	mov    0x8(%ebp),%esi
  801999:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80199c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80199f:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8019a0:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8019a6:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8019a9:	50                   	push   %eax
  8019aa:	e8 33 ff ff ff       	call   8018e2 <fd_lookup>
  8019af:	89 c3                	mov    %eax,%ebx
  8019b1:	83 c4 10             	add    $0x10,%esp
  8019b4:	85 c0                	test   %eax,%eax
  8019b6:	78 05                	js     8019bd <fd_close+0x30>
	    || fd != fd2)
  8019b8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8019bb:	74 16                	je     8019d3 <fd_close+0x46>
		return (must_exist ? r : 0);
  8019bd:	89 f8                	mov    %edi,%eax
  8019bf:	84 c0                	test   %al,%al
  8019c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c6:	0f 44 d8             	cmove  %eax,%ebx
}
  8019c9:	89 d8                	mov    %ebx,%eax
  8019cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019ce:	5b                   	pop    %ebx
  8019cf:	5e                   	pop    %esi
  8019d0:	5f                   	pop    %edi
  8019d1:	5d                   	pop    %ebp
  8019d2:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8019d3:	83 ec 08             	sub    $0x8,%esp
  8019d6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8019d9:	50                   	push   %eax
  8019da:	ff 36                	pushl  (%esi)
  8019dc:	e8 51 ff ff ff       	call   801932 <dev_lookup>
  8019e1:	89 c3                	mov    %eax,%ebx
  8019e3:	83 c4 10             	add    $0x10,%esp
  8019e6:	85 c0                	test   %eax,%eax
  8019e8:	78 1a                	js     801a04 <fd_close+0x77>
		if (dev->dev_close)
  8019ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019ed:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8019f0:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8019f5:	85 c0                	test   %eax,%eax
  8019f7:	74 0b                	je     801a04 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8019f9:	83 ec 0c             	sub    $0xc,%esp
  8019fc:	56                   	push   %esi
  8019fd:	ff d0                	call   *%eax
  8019ff:	89 c3                	mov    %eax,%ebx
  801a01:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801a04:	83 ec 08             	sub    $0x8,%esp
  801a07:	56                   	push   %esi
  801a08:	6a 00                	push   $0x0
  801a0a:	e8 ea fb ff ff       	call   8015f9 <sys_page_unmap>
	return r;
  801a0f:	83 c4 10             	add    $0x10,%esp
  801a12:	eb b5                	jmp    8019c9 <fd_close+0x3c>

00801a14 <close>:

int
close(int fdnum)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
  801a17:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a1a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a1d:	50                   	push   %eax
  801a1e:	ff 75 08             	pushl  0x8(%ebp)
  801a21:	e8 bc fe ff ff       	call   8018e2 <fd_lookup>
  801a26:	83 c4 10             	add    $0x10,%esp
  801a29:	85 c0                	test   %eax,%eax
  801a2b:	79 02                	jns    801a2f <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    
		return fd_close(fd, 1);
  801a2f:	83 ec 08             	sub    $0x8,%esp
  801a32:	6a 01                	push   $0x1
  801a34:	ff 75 f4             	pushl  -0xc(%ebp)
  801a37:	e8 51 ff ff ff       	call   80198d <fd_close>
  801a3c:	83 c4 10             	add    $0x10,%esp
  801a3f:	eb ec                	jmp    801a2d <close+0x19>

00801a41 <close_all>:

void
close_all(void)
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
  801a44:	53                   	push   %ebx
  801a45:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801a48:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801a4d:	83 ec 0c             	sub    $0xc,%esp
  801a50:	53                   	push   %ebx
  801a51:	e8 be ff ff ff       	call   801a14 <close>
	for (i = 0; i < MAXFD; i++)
  801a56:	83 c3 01             	add    $0x1,%ebx
  801a59:	83 c4 10             	add    $0x10,%esp
  801a5c:	83 fb 20             	cmp    $0x20,%ebx
  801a5f:	75 ec                	jne    801a4d <close_all+0xc>
}
  801a61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a64:	c9                   	leave  
  801a65:	c3                   	ret    

00801a66 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
  801a69:	57                   	push   %edi
  801a6a:	56                   	push   %esi
  801a6b:	53                   	push   %ebx
  801a6c:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801a6f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801a72:	50                   	push   %eax
  801a73:	ff 75 08             	pushl  0x8(%ebp)
  801a76:	e8 67 fe ff ff       	call   8018e2 <fd_lookup>
  801a7b:	89 c3                	mov    %eax,%ebx
  801a7d:	83 c4 10             	add    $0x10,%esp
  801a80:	85 c0                	test   %eax,%eax
  801a82:	0f 88 81 00 00 00    	js     801b09 <dup+0xa3>
		return r;
	close(newfdnum);
  801a88:	83 ec 0c             	sub    $0xc,%esp
  801a8b:	ff 75 0c             	pushl  0xc(%ebp)
  801a8e:	e8 81 ff ff ff       	call   801a14 <close>

	newfd = INDEX2FD(newfdnum);
  801a93:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a96:	c1 e6 0c             	shl    $0xc,%esi
  801a99:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801a9f:	83 c4 04             	add    $0x4,%esp
  801aa2:	ff 75 e4             	pushl  -0x1c(%ebp)
  801aa5:	e8 cf fd ff ff       	call   801879 <fd2data>
  801aaa:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801aac:	89 34 24             	mov    %esi,(%esp)
  801aaf:	e8 c5 fd ff ff       	call   801879 <fd2data>
  801ab4:	83 c4 10             	add    $0x10,%esp
  801ab7:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801ab9:	89 d8                	mov    %ebx,%eax
  801abb:	c1 e8 16             	shr    $0x16,%eax
  801abe:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801ac5:	a8 01                	test   $0x1,%al
  801ac7:	74 11                	je     801ada <dup+0x74>
  801ac9:	89 d8                	mov    %ebx,%eax
  801acb:	c1 e8 0c             	shr    $0xc,%eax
  801ace:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801ad5:	f6 c2 01             	test   $0x1,%dl
  801ad8:	75 39                	jne    801b13 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801ada:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801add:	89 d0                	mov    %edx,%eax
  801adf:	c1 e8 0c             	shr    $0xc,%eax
  801ae2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801ae9:	83 ec 0c             	sub    $0xc,%esp
  801aec:	25 07 0e 00 00       	and    $0xe07,%eax
  801af1:	50                   	push   %eax
  801af2:	56                   	push   %esi
  801af3:	6a 00                	push   $0x0
  801af5:	52                   	push   %edx
  801af6:	6a 00                	push   $0x0
  801af8:	e8 ba fa ff ff       	call   8015b7 <sys_page_map>
  801afd:	89 c3                	mov    %eax,%ebx
  801aff:	83 c4 20             	add    $0x20,%esp
  801b02:	85 c0                	test   %eax,%eax
  801b04:	78 31                	js     801b37 <dup+0xd1>
		goto err;

	return newfdnum;
  801b06:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801b09:	89 d8                	mov    %ebx,%eax
  801b0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b0e:	5b                   	pop    %ebx
  801b0f:	5e                   	pop    %esi
  801b10:	5f                   	pop    %edi
  801b11:	5d                   	pop    %ebp
  801b12:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801b13:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801b1a:	83 ec 0c             	sub    $0xc,%esp
  801b1d:	25 07 0e 00 00       	and    $0xe07,%eax
  801b22:	50                   	push   %eax
  801b23:	57                   	push   %edi
  801b24:	6a 00                	push   $0x0
  801b26:	53                   	push   %ebx
  801b27:	6a 00                	push   $0x0
  801b29:	e8 89 fa ff ff       	call   8015b7 <sys_page_map>
  801b2e:	89 c3                	mov    %eax,%ebx
  801b30:	83 c4 20             	add    $0x20,%esp
  801b33:	85 c0                	test   %eax,%eax
  801b35:	79 a3                	jns    801ada <dup+0x74>
	sys_page_unmap(0, newfd);
  801b37:	83 ec 08             	sub    $0x8,%esp
  801b3a:	56                   	push   %esi
  801b3b:	6a 00                	push   $0x0
  801b3d:	e8 b7 fa ff ff       	call   8015f9 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801b42:	83 c4 08             	add    $0x8,%esp
  801b45:	57                   	push   %edi
  801b46:	6a 00                	push   $0x0
  801b48:	e8 ac fa ff ff       	call   8015f9 <sys_page_unmap>
	return r;
  801b4d:	83 c4 10             	add    $0x10,%esp
  801b50:	eb b7                	jmp    801b09 <dup+0xa3>

00801b52 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
  801b55:	53                   	push   %ebx
  801b56:	83 ec 1c             	sub    $0x1c,%esp
  801b59:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b5c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b5f:	50                   	push   %eax
  801b60:	53                   	push   %ebx
  801b61:	e8 7c fd ff ff       	call   8018e2 <fd_lookup>
  801b66:	83 c4 10             	add    $0x10,%esp
  801b69:	85 c0                	test   %eax,%eax
  801b6b:	78 3f                	js     801bac <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b6d:	83 ec 08             	sub    $0x8,%esp
  801b70:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b73:	50                   	push   %eax
  801b74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b77:	ff 30                	pushl  (%eax)
  801b79:	e8 b4 fd ff ff       	call   801932 <dev_lookup>
  801b7e:	83 c4 10             	add    $0x10,%esp
  801b81:	85 c0                	test   %eax,%eax
  801b83:	78 27                	js     801bac <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b85:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b88:	8b 42 08             	mov    0x8(%edx),%eax
  801b8b:	83 e0 03             	and    $0x3,%eax
  801b8e:	83 f8 01             	cmp    $0x1,%eax
  801b91:	74 1e                	je     801bb1 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b96:	8b 40 08             	mov    0x8(%eax),%eax
  801b99:	85 c0                	test   %eax,%eax
  801b9b:	74 35                	je     801bd2 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801b9d:	83 ec 04             	sub    $0x4,%esp
  801ba0:	ff 75 10             	pushl  0x10(%ebp)
  801ba3:	ff 75 0c             	pushl  0xc(%ebp)
  801ba6:	52                   	push   %edx
  801ba7:	ff d0                	call   *%eax
  801ba9:	83 c4 10             	add    $0x10,%esp
}
  801bac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801bb1:	a1 1c 50 80 00       	mov    0x80501c,%eax
  801bb6:	8b 40 48             	mov    0x48(%eax),%eax
  801bb9:	83 ec 04             	sub    $0x4,%esp
  801bbc:	53                   	push   %ebx
  801bbd:	50                   	push   %eax
  801bbe:	68 d5 36 80 00       	push   $0x8036d5
  801bc3:	e8 5b ee ff ff       	call   800a23 <cprintf>
		return -E_INVAL;
  801bc8:	83 c4 10             	add    $0x10,%esp
  801bcb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bd0:	eb da                	jmp    801bac <read+0x5a>
		return -E_NOT_SUPP;
  801bd2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bd7:	eb d3                	jmp    801bac <read+0x5a>

00801bd9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
  801bdc:	57                   	push   %edi
  801bdd:	56                   	push   %esi
  801bde:	53                   	push   %ebx
  801bdf:	83 ec 0c             	sub    $0xc,%esp
  801be2:	8b 7d 08             	mov    0x8(%ebp),%edi
  801be5:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801be8:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bed:	39 f3                	cmp    %esi,%ebx
  801bef:	73 23                	jae    801c14 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801bf1:	83 ec 04             	sub    $0x4,%esp
  801bf4:	89 f0                	mov    %esi,%eax
  801bf6:	29 d8                	sub    %ebx,%eax
  801bf8:	50                   	push   %eax
  801bf9:	89 d8                	mov    %ebx,%eax
  801bfb:	03 45 0c             	add    0xc(%ebp),%eax
  801bfe:	50                   	push   %eax
  801bff:	57                   	push   %edi
  801c00:	e8 4d ff ff ff       	call   801b52 <read>
		if (m < 0)
  801c05:	83 c4 10             	add    $0x10,%esp
  801c08:	85 c0                	test   %eax,%eax
  801c0a:	78 06                	js     801c12 <readn+0x39>
			return m;
		if (m == 0)
  801c0c:	74 06                	je     801c14 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801c0e:	01 c3                	add    %eax,%ebx
  801c10:	eb db                	jmp    801bed <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801c12:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801c14:	89 d8                	mov    %ebx,%eax
  801c16:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c19:	5b                   	pop    %ebx
  801c1a:	5e                   	pop    %esi
  801c1b:	5f                   	pop    %edi
  801c1c:	5d                   	pop    %ebp
  801c1d:	c3                   	ret    

00801c1e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801c1e:	55                   	push   %ebp
  801c1f:	89 e5                	mov    %esp,%ebp
  801c21:	53                   	push   %ebx
  801c22:	83 ec 1c             	sub    $0x1c,%esp
  801c25:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c28:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c2b:	50                   	push   %eax
  801c2c:	53                   	push   %ebx
  801c2d:	e8 b0 fc ff ff       	call   8018e2 <fd_lookup>
  801c32:	83 c4 10             	add    $0x10,%esp
  801c35:	85 c0                	test   %eax,%eax
  801c37:	78 3a                	js     801c73 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c39:	83 ec 08             	sub    $0x8,%esp
  801c3c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c3f:	50                   	push   %eax
  801c40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c43:	ff 30                	pushl  (%eax)
  801c45:	e8 e8 fc ff ff       	call   801932 <dev_lookup>
  801c4a:	83 c4 10             	add    $0x10,%esp
  801c4d:	85 c0                	test   %eax,%eax
  801c4f:	78 22                	js     801c73 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c54:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c58:	74 1e                	je     801c78 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801c5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c5d:	8b 52 0c             	mov    0xc(%edx),%edx
  801c60:	85 d2                	test   %edx,%edx
  801c62:	74 35                	je     801c99 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801c64:	83 ec 04             	sub    $0x4,%esp
  801c67:	ff 75 10             	pushl  0x10(%ebp)
  801c6a:	ff 75 0c             	pushl  0xc(%ebp)
  801c6d:	50                   	push   %eax
  801c6e:	ff d2                	call   *%edx
  801c70:	83 c4 10             	add    $0x10,%esp
}
  801c73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801c78:	a1 1c 50 80 00       	mov    0x80501c,%eax
  801c7d:	8b 40 48             	mov    0x48(%eax),%eax
  801c80:	83 ec 04             	sub    $0x4,%esp
  801c83:	53                   	push   %ebx
  801c84:	50                   	push   %eax
  801c85:	68 f1 36 80 00       	push   $0x8036f1
  801c8a:	e8 94 ed ff ff       	call   800a23 <cprintf>
		return -E_INVAL;
  801c8f:	83 c4 10             	add    $0x10,%esp
  801c92:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c97:	eb da                	jmp    801c73 <write+0x55>
		return -E_NOT_SUPP;
  801c99:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c9e:	eb d3                	jmp    801c73 <write+0x55>

00801ca0 <seek>:

int
seek(int fdnum, off_t offset)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
  801ca3:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ca6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ca9:	50                   	push   %eax
  801caa:	ff 75 08             	pushl  0x8(%ebp)
  801cad:	e8 30 fc ff ff       	call   8018e2 <fd_lookup>
  801cb2:	83 c4 10             	add    $0x10,%esp
  801cb5:	85 c0                	test   %eax,%eax
  801cb7:	78 0e                	js     801cc7 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801cb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cbf:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801cc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cc7:	c9                   	leave  
  801cc8:	c3                   	ret    

00801cc9 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
  801ccc:	53                   	push   %ebx
  801ccd:	83 ec 1c             	sub    $0x1c,%esp
  801cd0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801cd3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cd6:	50                   	push   %eax
  801cd7:	53                   	push   %ebx
  801cd8:	e8 05 fc ff ff       	call   8018e2 <fd_lookup>
  801cdd:	83 c4 10             	add    $0x10,%esp
  801ce0:	85 c0                	test   %eax,%eax
  801ce2:	78 37                	js     801d1b <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ce4:	83 ec 08             	sub    $0x8,%esp
  801ce7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cea:	50                   	push   %eax
  801ceb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cee:	ff 30                	pushl  (%eax)
  801cf0:	e8 3d fc ff ff       	call   801932 <dev_lookup>
  801cf5:	83 c4 10             	add    $0x10,%esp
  801cf8:	85 c0                	test   %eax,%eax
  801cfa:	78 1f                	js     801d1b <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cff:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801d03:	74 1b                	je     801d20 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801d05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d08:	8b 52 18             	mov    0x18(%edx),%edx
  801d0b:	85 d2                	test   %edx,%edx
  801d0d:	74 32                	je     801d41 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801d0f:	83 ec 08             	sub    $0x8,%esp
  801d12:	ff 75 0c             	pushl  0xc(%ebp)
  801d15:	50                   	push   %eax
  801d16:	ff d2                	call   *%edx
  801d18:	83 c4 10             	add    $0x10,%esp
}
  801d1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d1e:	c9                   	leave  
  801d1f:	c3                   	ret    
			thisenv->env_id, fdnum);
  801d20:	a1 1c 50 80 00       	mov    0x80501c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801d25:	8b 40 48             	mov    0x48(%eax),%eax
  801d28:	83 ec 04             	sub    $0x4,%esp
  801d2b:	53                   	push   %ebx
  801d2c:	50                   	push   %eax
  801d2d:	68 b4 36 80 00       	push   $0x8036b4
  801d32:	e8 ec ec ff ff       	call   800a23 <cprintf>
		return -E_INVAL;
  801d37:	83 c4 10             	add    $0x10,%esp
  801d3a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d3f:	eb da                	jmp    801d1b <ftruncate+0x52>
		return -E_NOT_SUPP;
  801d41:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d46:	eb d3                	jmp    801d1b <ftruncate+0x52>

00801d48 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801d48:	55                   	push   %ebp
  801d49:	89 e5                	mov    %esp,%ebp
  801d4b:	53                   	push   %ebx
  801d4c:	83 ec 1c             	sub    $0x1c,%esp
  801d4f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d52:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d55:	50                   	push   %eax
  801d56:	ff 75 08             	pushl  0x8(%ebp)
  801d59:	e8 84 fb ff ff       	call   8018e2 <fd_lookup>
  801d5e:	83 c4 10             	add    $0x10,%esp
  801d61:	85 c0                	test   %eax,%eax
  801d63:	78 4b                	js     801db0 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d65:	83 ec 08             	sub    $0x8,%esp
  801d68:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d6b:	50                   	push   %eax
  801d6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d6f:	ff 30                	pushl  (%eax)
  801d71:	e8 bc fb ff ff       	call   801932 <dev_lookup>
  801d76:	83 c4 10             	add    $0x10,%esp
  801d79:	85 c0                	test   %eax,%eax
  801d7b:	78 33                	js     801db0 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d80:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801d84:	74 2f                	je     801db5 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801d86:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801d89:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801d90:	00 00 00 
	stat->st_isdir = 0;
  801d93:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d9a:	00 00 00 
	stat->st_dev = dev;
  801d9d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801da3:	83 ec 08             	sub    $0x8,%esp
  801da6:	53                   	push   %ebx
  801da7:	ff 75 f0             	pushl  -0x10(%ebp)
  801daa:	ff 50 14             	call   *0x14(%eax)
  801dad:	83 c4 10             	add    $0x10,%esp
}
  801db0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801db3:	c9                   	leave  
  801db4:	c3                   	ret    
		return -E_NOT_SUPP;
  801db5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801dba:	eb f4                	jmp    801db0 <fstat+0x68>

00801dbc <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801dbc:	55                   	push   %ebp
  801dbd:	89 e5                	mov    %esp,%ebp
  801dbf:	56                   	push   %esi
  801dc0:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801dc1:	83 ec 08             	sub    $0x8,%esp
  801dc4:	6a 00                	push   $0x0
  801dc6:	ff 75 08             	pushl  0x8(%ebp)
  801dc9:	e8 22 02 00 00       	call   801ff0 <open>
  801dce:	89 c3                	mov    %eax,%ebx
  801dd0:	83 c4 10             	add    $0x10,%esp
  801dd3:	85 c0                	test   %eax,%eax
  801dd5:	78 1b                	js     801df2 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801dd7:	83 ec 08             	sub    $0x8,%esp
  801dda:	ff 75 0c             	pushl  0xc(%ebp)
  801ddd:	50                   	push   %eax
  801dde:	e8 65 ff ff ff       	call   801d48 <fstat>
  801de3:	89 c6                	mov    %eax,%esi
	close(fd);
  801de5:	89 1c 24             	mov    %ebx,(%esp)
  801de8:	e8 27 fc ff ff       	call   801a14 <close>
	return r;
  801ded:	83 c4 10             	add    $0x10,%esp
  801df0:	89 f3                	mov    %esi,%ebx
}
  801df2:	89 d8                	mov    %ebx,%eax
  801df4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801df7:	5b                   	pop    %ebx
  801df8:	5e                   	pop    %esi
  801df9:	5d                   	pop    %ebp
  801dfa:	c3                   	ret    

00801dfb <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801dfb:	55                   	push   %ebp
  801dfc:	89 e5                	mov    %esp,%ebp
  801dfe:	56                   	push   %esi
  801dff:	53                   	push   %ebx
  801e00:	89 c6                	mov    %eax,%esi
  801e02:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801e04:	83 3d 10 50 80 00 00 	cmpl   $0x0,0x805010
  801e0b:	74 27                	je     801e34 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801e0d:	6a 07                	push   $0x7
  801e0f:	68 00 60 80 00       	push   $0x806000
  801e14:	56                   	push   %esi
  801e15:	ff 35 10 50 80 00    	pushl  0x805010
  801e1b:	e8 a1 0e 00 00       	call   802cc1 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801e20:	83 c4 0c             	add    $0xc,%esp
  801e23:	6a 00                	push   $0x0
  801e25:	53                   	push   %ebx
  801e26:	6a 00                	push   $0x0
  801e28:	e8 2b 0e 00 00       	call   802c58 <ipc_recv>
}
  801e2d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e30:	5b                   	pop    %ebx
  801e31:	5e                   	pop    %esi
  801e32:	5d                   	pop    %ebp
  801e33:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801e34:	83 ec 0c             	sub    $0xc,%esp
  801e37:	6a 01                	push   $0x1
  801e39:	e8 db 0e 00 00       	call   802d19 <ipc_find_env>
  801e3e:	a3 10 50 80 00       	mov    %eax,0x805010
  801e43:	83 c4 10             	add    $0x10,%esp
  801e46:	eb c5                	jmp    801e0d <fsipc+0x12>

00801e48 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801e48:	55                   	push   %ebp
  801e49:	89 e5                	mov    %esp,%ebp
  801e4b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e51:	8b 40 0c             	mov    0xc(%eax),%eax
  801e54:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801e59:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e5c:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801e61:	ba 00 00 00 00       	mov    $0x0,%edx
  801e66:	b8 02 00 00 00       	mov    $0x2,%eax
  801e6b:	e8 8b ff ff ff       	call   801dfb <fsipc>
}
  801e70:	c9                   	leave  
  801e71:	c3                   	ret    

00801e72 <devfile_flush>:
{
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
  801e75:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e78:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7b:	8b 40 0c             	mov    0xc(%eax),%eax
  801e7e:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801e83:	ba 00 00 00 00       	mov    $0x0,%edx
  801e88:	b8 06 00 00 00       	mov    $0x6,%eax
  801e8d:	e8 69 ff ff ff       	call   801dfb <fsipc>
}
  801e92:	c9                   	leave  
  801e93:	c3                   	ret    

00801e94 <devfile_stat>:
{
  801e94:	55                   	push   %ebp
  801e95:	89 e5                	mov    %esp,%ebp
  801e97:	53                   	push   %ebx
  801e98:	83 ec 04             	sub    $0x4,%esp
  801e9b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea1:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea4:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801ea9:	ba 00 00 00 00       	mov    $0x0,%edx
  801eae:	b8 05 00 00 00       	mov    $0x5,%eax
  801eb3:	e8 43 ff ff ff       	call   801dfb <fsipc>
  801eb8:	85 c0                	test   %eax,%eax
  801eba:	78 2c                	js     801ee8 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801ebc:	83 ec 08             	sub    $0x8,%esp
  801ebf:	68 00 60 80 00       	push   $0x806000
  801ec4:	53                   	push   %ebx
  801ec5:	e8 b8 f2 ff ff       	call   801182 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801eca:	a1 80 60 80 00       	mov    0x806080,%eax
  801ecf:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801ed5:	a1 84 60 80 00       	mov    0x806084,%eax
  801eda:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801ee0:	83 c4 10             	add    $0x10,%esp
  801ee3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eeb:	c9                   	leave  
  801eec:	c3                   	ret    

00801eed <devfile_write>:
{
  801eed:	55                   	push   %ebp
  801eee:	89 e5                	mov    %esp,%ebp
  801ef0:	53                   	push   %ebx
  801ef1:	83 ec 08             	sub    $0x8,%esp
  801ef4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  801efa:	8b 40 0c             	mov    0xc(%eax),%eax
  801efd:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801f02:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801f08:	53                   	push   %ebx
  801f09:	ff 75 0c             	pushl  0xc(%ebp)
  801f0c:	68 08 60 80 00       	push   $0x806008
  801f11:	e8 5c f4 ff ff       	call   801372 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801f16:	ba 00 00 00 00       	mov    $0x0,%edx
  801f1b:	b8 04 00 00 00       	mov    $0x4,%eax
  801f20:	e8 d6 fe ff ff       	call   801dfb <fsipc>
  801f25:	83 c4 10             	add    $0x10,%esp
  801f28:	85 c0                	test   %eax,%eax
  801f2a:	78 0b                	js     801f37 <devfile_write+0x4a>
	assert(r <= n);
  801f2c:	39 d8                	cmp    %ebx,%eax
  801f2e:	77 0c                	ja     801f3c <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801f30:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f35:	7f 1e                	jg     801f55 <devfile_write+0x68>
}
  801f37:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f3a:	c9                   	leave  
  801f3b:	c3                   	ret    
	assert(r <= n);
  801f3c:	68 24 37 80 00       	push   $0x803724
  801f41:	68 2b 37 80 00       	push   $0x80372b
  801f46:	68 98 00 00 00       	push   $0x98
  801f4b:	68 40 37 80 00       	push   $0x803740
  801f50:	e8 d8 e9 ff ff       	call   80092d <_panic>
	assert(r <= PGSIZE);
  801f55:	68 4b 37 80 00       	push   $0x80374b
  801f5a:	68 2b 37 80 00       	push   $0x80372b
  801f5f:	68 99 00 00 00       	push   $0x99
  801f64:	68 40 37 80 00       	push   $0x803740
  801f69:	e8 bf e9 ff ff       	call   80092d <_panic>

00801f6e <devfile_read>:
{
  801f6e:	55                   	push   %ebp
  801f6f:	89 e5                	mov    %esp,%ebp
  801f71:	56                   	push   %esi
  801f72:	53                   	push   %ebx
  801f73:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801f76:	8b 45 08             	mov    0x8(%ebp),%eax
  801f79:	8b 40 0c             	mov    0xc(%eax),%eax
  801f7c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801f81:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801f87:	ba 00 00 00 00       	mov    $0x0,%edx
  801f8c:	b8 03 00 00 00       	mov    $0x3,%eax
  801f91:	e8 65 fe ff ff       	call   801dfb <fsipc>
  801f96:	89 c3                	mov    %eax,%ebx
  801f98:	85 c0                	test   %eax,%eax
  801f9a:	78 1f                	js     801fbb <devfile_read+0x4d>
	assert(r <= n);
  801f9c:	39 f0                	cmp    %esi,%eax
  801f9e:	77 24                	ja     801fc4 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801fa0:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801fa5:	7f 33                	jg     801fda <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801fa7:	83 ec 04             	sub    $0x4,%esp
  801faa:	50                   	push   %eax
  801fab:	68 00 60 80 00       	push   $0x806000
  801fb0:	ff 75 0c             	pushl  0xc(%ebp)
  801fb3:	e8 58 f3 ff ff       	call   801310 <memmove>
	return r;
  801fb8:	83 c4 10             	add    $0x10,%esp
}
  801fbb:	89 d8                	mov    %ebx,%eax
  801fbd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fc0:	5b                   	pop    %ebx
  801fc1:	5e                   	pop    %esi
  801fc2:	5d                   	pop    %ebp
  801fc3:	c3                   	ret    
	assert(r <= n);
  801fc4:	68 24 37 80 00       	push   $0x803724
  801fc9:	68 2b 37 80 00       	push   $0x80372b
  801fce:	6a 7c                	push   $0x7c
  801fd0:	68 40 37 80 00       	push   $0x803740
  801fd5:	e8 53 e9 ff ff       	call   80092d <_panic>
	assert(r <= PGSIZE);
  801fda:	68 4b 37 80 00       	push   $0x80374b
  801fdf:	68 2b 37 80 00       	push   $0x80372b
  801fe4:	6a 7d                	push   $0x7d
  801fe6:	68 40 37 80 00       	push   $0x803740
  801feb:	e8 3d e9 ff ff       	call   80092d <_panic>

00801ff0 <open>:
{
  801ff0:	55                   	push   %ebp
  801ff1:	89 e5                	mov    %esp,%ebp
  801ff3:	56                   	push   %esi
  801ff4:	53                   	push   %ebx
  801ff5:	83 ec 1c             	sub    $0x1c,%esp
  801ff8:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801ffb:	56                   	push   %esi
  801ffc:	e8 48 f1 ff ff       	call   801149 <strlen>
  802001:	83 c4 10             	add    $0x10,%esp
  802004:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802009:	7f 6c                	jg     802077 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80200b:	83 ec 0c             	sub    $0xc,%esp
  80200e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802011:	50                   	push   %eax
  802012:	e8 79 f8 ff ff       	call   801890 <fd_alloc>
  802017:	89 c3                	mov    %eax,%ebx
  802019:	83 c4 10             	add    $0x10,%esp
  80201c:	85 c0                	test   %eax,%eax
  80201e:	78 3c                	js     80205c <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  802020:	83 ec 08             	sub    $0x8,%esp
  802023:	56                   	push   %esi
  802024:	68 00 60 80 00       	push   $0x806000
  802029:	e8 54 f1 ff ff       	call   801182 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80202e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802031:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802036:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802039:	b8 01 00 00 00       	mov    $0x1,%eax
  80203e:	e8 b8 fd ff ff       	call   801dfb <fsipc>
  802043:	89 c3                	mov    %eax,%ebx
  802045:	83 c4 10             	add    $0x10,%esp
  802048:	85 c0                	test   %eax,%eax
  80204a:	78 19                	js     802065 <open+0x75>
	return fd2num(fd);
  80204c:	83 ec 0c             	sub    $0xc,%esp
  80204f:	ff 75 f4             	pushl  -0xc(%ebp)
  802052:	e8 12 f8 ff ff       	call   801869 <fd2num>
  802057:	89 c3                	mov    %eax,%ebx
  802059:	83 c4 10             	add    $0x10,%esp
}
  80205c:	89 d8                	mov    %ebx,%eax
  80205e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802061:	5b                   	pop    %ebx
  802062:	5e                   	pop    %esi
  802063:	5d                   	pop    %ebp
  802064:	c3                   	ret    
		fd_close(fd, 0);
  802065:	83 ec 08             	sub    $0x8,%esp
  802068:	6a 00                	push   $0x0
  80206a:	ff 75 f4             	pushl  -0xc(%ebp)
  80206d:	e8 1b f9 ff ff       	call   80198d <fd_close>
		return r;
  802072:	83 c4 10             	add    $0x10,%esp
  802075:	eb e5                	jmp    80205c <open+0x6c>
		return -E_BAD_PATH;
  802077:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80207c:	eb de                	jmp    80205c <open+0x6c>

0080207e <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80207e:	55                   	push   %ebp
  80207f:	89 e5                	mov    %esp,%ebp
  802081:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802084:	ba 00 00 00 00       	mov    $0x0,%edx
  802089:	b8 08 00 00 00       	mov    $0x8,%eax
  80208e:	e8 68 fd ff ff       	call   801dfb <fsipc>
}
  802093:	c9                   	leave  
  802094:	c3                   	ret    

00802095 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802095:	55                   	push   %ebp
  802096:	89 e5                	mov    %esp,%ebp
  802098:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80209b:	68 57 37 80 00       	push   $0x803757
  8020a0:	ff 75 0c             	pushl  0xc(%ebp)
  8020a3:	e8 da f0 ff ff       	call   801182 <strcpy>
	return 0;
}
  8020a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ad:	c9                   	leave  
  8020ae:	c3                   	ret    

008020af <devsock_close>:
{
  8020af:	55                   	push   %ebp
  8020b0:	89 e5                	mov    %esp,%ebp
  8020b2:	53                   	push   %ebx
  8020b3:	83 ec 10             	sub    $0x10,%esp
  8020b6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8020b9:	53                   	push   %ebx
  8020ba:	e8 99 0c 00 00       	call   802d58 <pageref>
  8020bf:	83 c4 10             	add    $0x10,%esp
		return 0;
  8020c2:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8020c7:	83 f8 01             	cmp    $0x1,%eax
  8020ca:	74 07                	je     8020d3 <devsock_close+0x24>
}
  8020cc:	89 d0                	mov    %edx,%eax
  8020ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020d1:	c9                   	leave  
  8020d2:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8020d3:	83 ec 0c             	sub    $0xc,%esp
  8020d6:	ff 73 0c             	pushl  0xc(%ebx)
  8020d9:	e8 b9 02 00 00       	call   802397 <nsipc_close>
  8020de:	89 c2                	mov    %eax,%edx
  8020e0:	83 c4 10             	add    $0x10,%esp
  8020e3:	eb e7                	jmp    8020cc <devsock_close+0x1d>

008020e5 <devsock_write>:
{
  8020e5:	55                   	push   %ebp
  8020e6:	89 e5                	mov    %esp,%ebp
  8020e8:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8020eb:	6a 00                	push   $0x0
  8020ed:	ff 75 10             	pushl  0x10(%ebp)
  8020f0:	ff 75 0c             	pushl  0xc(%ebp)
  8020f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f6:	ff 70 0c             	pushl  0xc(%eax)
  8020f9:	e8 76 03 00 00       	call   802474 <nsipc_send>
}
  8020fe:	c9                   	leave  
  8020ff:	c3                   	ret    

00802100 <devsock_read>:
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
  802103:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802106:	6a 00                	push   $0x0
  802108:	ff 75 10             	pushl  0x10(%ebp)
  80210b:	ff 75 0c             	pushl  0xc(%ebp)
  80210e:	8b 45 08             	mov    0x8(%ebp),%eax
  802111:	ff 70 0c             	pushl  0xc(%eax)
  802114:	e8 ef 02 00 00       	call   802408 <nsipc_recv>
}
  802119:	c9                   	leave  
  80211a:	c3                   	ret    

0080211b <fd2sockid>:
{
  80211b:	55                   	push   %ebp
  80211c:	89 e5                	mov    %esp,%ebp
  80211e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802121:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802124:	52                   	push   %edx
  802125:	50                   	push   %eax
  802126:	e8 b7 f7 ff ff       	call   8018e2 <fd_lookup>
  80212b:	83 c4 10             	add    $0x10,%esp
  80212e:	85 c0                	test   %eax,%eax
  802130:	78 10                	js     802142 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802132:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802135:	8b 0d 40 40 80 00    	mov    0x804040,%ecx
  80213b:	39 08                	cmp    %ecx,(%eax)
  80213d:	75 05                	jne    802144 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80213f:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802142:	c9                   	leave  
  802143:	c3                   	ret    
		return -E_NOT_SUPP;
  802144:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802149:	eb f7                	jmp    802142 <fd2sockid+0x27>

0080214b <alloc_sockfd>:
{
  80214b:	55                   	push   %ebp
  80214c:	89 e5                	mov    %esp,%ebp
  80214e:	56                   	push   %esi
  80214f:	53                   	push   %ebx
  802150:	83 ec 1c             	sub    $0x1c,%esp
  802153:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802155:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802158:	50                   	push   %eax
  802159:	e8 32 f7 ff ff       	call   801890 <fd_alloc>
  80215e:	89 c3                	mov    %eax,%ebx
  802160:	83 c4 10             	add    $0x10,%esp
  802163:	85 c0                	test   %eax,%eax
  802165:	78 43                	js     8021aa <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802167:	83 ec 04             	sub    $0x4,%esp
  80216a:	68 07 04 00 00       	push   $0x407
  80216f:	ff 75 f4             	pushl  -0xc(%ebp)
  802172:	6a 00                	push   $0x0
  802174:	e8 fb f3 ff ff       	call   801574 <sys_page_alloc>
  802179:	89 c3                	mov    %eax,%ebx
  80217b:	83 c4 10             	add    $0x10,%esp
  80217e:	85 c0                	test   %eax,%eax
  802180:	78 28                	js     8021aa <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802182:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802185:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80218b:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80218d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802190:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802197:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80219a:	83 ec 0c             	sub    $0xc,%esp
  80219d:	50                   	push   %eax
  80219e:	e8 c6 f6 ff ff       	call   801869 <fd2num>
  8021a3:	89 c3                	mov    %eax,%ebx
  8021a5:	83 c4 10             	add    $0x10,%esp
  8021a8:	eb 0c                	jmp    8021b6 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8021aa:	83 ec 0c             	sub    $0xc,%esp
  8021ad:	56                   	push   %esi
  8021ae:	e8 e4 01 00 00       	call   802397 <nsipc_close>
		return r;
  8021b3:	83 c4 10             	add    $0x10,%esp
}
  8021b6:	89 d8                	mov    %ebx,%eax
  8021b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021bb:	5b                   	pop    %ebx
  8021bc:	5e                   	pop    %esi
  8021bd:	5d                   	pop    %ebp
  8021be:	c3                   	ret    

008021bf <accept>:
{
  8021bf:	55                   	push   %ebp
  8021c0:	89 e5                	mov    %esp,%ebp
  8021c2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c8:	e8 4e ff ff ff       	call   80211b <fd2sockid>
  8021cd:	85 c0                	test   %eax,%eax
  8021cf:	78 1b                	js     8021ec <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8021d1:	83 ec 04             	sub    $0x4,%esp
  8021d4:	ff 75 10             	pushl  0x10(%ebp)
  8021d7:	ff 75 0c             	pushl  0xc(%ebp)
  8021da:	50                   	push   %eax
  8021db:	e8 0e 01 00 00       	call   8022ee <nsipc_accept>
  8021e0:	83 c4 10             	add    $0x10,%esp
  8021e3:	85 c0                	test   %eax,%eax
  8021e5:	78 05                	js     8021ec <accept+0x2d>
	return alloc_sockfd(r);
  8021e7:	e8 5f ff ff ff       	call   80214b <alloc_sockfd>
}
  8021ec:	c9                   	leave  
  8021ed:	c3                   	ret    

008021ee <bind>:
{
  8021ee:	55                   	push   %ebp
  8021ef:	89 e5                	mov    %esp,%ebp
  8021f1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f7:	e8 1f ff ff ff       	call   80211b <fd2sockid>
  8021fc:	85 c0                	test   %eax,%eax
  8021fe:	78 12                	js     802212 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802200:	83 ec 04             	sub    $0x4,%esp
  802203:	ff 75 10             	pushl  0x10(%ebp)
  802206:	ff 75 0c             	pushl  0xc(%ebp)
  802209:	50                   	push   %eax
  80220a:	e8 31 01 00 00       	call   802340 <nsipc_bind>
  80220f:	83 c4 10             	add    $0x10,%esp
}
  802212:	c9                   	leave  
  802213:	c3                   	ret    

00802214 <shutdown>:
{
  802214:	55                   	push   %ebp
  802215:	89 e5                	mov    %esp,%ebp
  802217:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80221a:	8b 45 08             	mov    0x8(%ebp),%eax
  80221d:	e8 f9 fe ff ff       	call   80211b <fd2sockid>
  802222:	85 c0                	test   %eax,%eax
  802224:	78 0f                	js     802235 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802226:	83 ec 08             	sub    $0x8,%esp
  802229:	ff 75 0c             	pushl  0xc(%ebp)
  80222c:	50                   	push   %eax
  80222d:	e8 43 01 00 00       	call   802375 <nsipc_shutdown>
  802232:	83 c4 10             	add    $0x10,%esp
}
  802235:	c9                   	leave  
  802236:	c3                   	ret    

00802237 <connect>:
{
  802237:	55                   	push   %ebp
  802238:	89 e5                	mov    %esp,%ebp
  80223a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80223d:	8b 45 08             	mov    0x8(%ebp),%eax
  802240:	e8 d6 fe ff ff       	call   80211b <fd2sockid>
  802245:	85 c0                	test   %eax,%eax
  802247:	78 12                	js     80225b <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802249:	83 ec 04             	sub    $0x4,%esp
  80224c:	ff 75 10             	pushl  0x10(%ebp)
  80224f:	ff 75 0c             	pushl  0xc(%ebp)
  802252:	50                   	push   %eax
  802253:	e8 59 01 00 00       	call   8023b1 <nsipc_connect>
  802258:	83 c4 10             	add    $0x10,%esp
}
  80225b:	c9                   	leave  
  80225c:	c3                   	ret    

0080225d <listen>:
{
  80225d:	55                   	push   %ebp
  80225e:	89 e5                	mov    %esp,%ebp
  802260:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	e8 b0 fe ff ff       	call   80211b <fd2sockid>
  80226b:	85 c0                	test   %eax,%eax
  80226d:	78 0f                	js     80227e <listen+0x21>
	return nsipc_listen(r, backlog);
  80226f:	83 ec 08             	sub    $0x8,%esp
  802272:	ff 75 0c             	pushl  0xc(%ebp)
  802275:	50                   	push   %eax
  802276:	e8 6b 01 00 00       	call   8023e6 <nsipc_listen>
  80227b:	83 c4 10             	add    $0x10,%esp
}
  80227e:	c9                   	leave  
  80227f:	c3                   	ret    

00802280 <socket>:

int
socket(int domain, int type, int protocol)
{
  802280:	55                   	push   %ebp
  802281:	89 e5                	mov    %esp,%ebp
  802283:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802286:	ff 75 10             	pushl  0x10(%ebp)
  802289:	ff 75 0c             	pushl  0xc(%ebp)
  80228c:	ff 75 08             	pushl  0x8(%ebp)
  80228f:	e8 3e 02 00 00       	call   8024d2 <nsipc_socket>
  802294:	83 c4 10             	add    $0x10,%esp
  802297:	85 c0                	test   %eax,%eax
  802299:	78 05                	js     8022a0 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80229b:	e8 ab fe ff ff       	call   80214b <alloc_sockfd>
}
  8022a0:	c9                   	leave  
  8022a1:	c3                   	ret    

008022a2 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8022a2:	55                   	push   %ebp
  8022a3:	89 e5                	mov    %esp,%ebp
  8022a5:	53                   	push   %ebx
  8022a6:	83 ec 04             	sub    $0x4,%esp
  8022a9:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8022ab:	83 3d 14 50 80 00 00 	cmpl   $0x0,0x805014
  8022b2:	74 26                	je     8022da <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8022b4:	6a 07                	push   $0x7
  8022b6:	68 00 70 80 00       	push   $0x807000
  8022bb:	53                   	push   %ebx
  8022bc:	ff 35 14 50 80 00    	pushl  0x805014
  8022c2:	e8 fa 09 00 00       	call   802cc1 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8022c7:	83 c4 0c             	add    $0xc,%esp
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 00                	push   $0x0
  8022ce:	6a 00                	push   $0x0
  8022d0:	e8 83 09 00 00       	call   802c58 <ipc_recv>
}
  8022d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022d8:	c9                   	leave  
  8022d9:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8022da:	83 ec 0c             	sub    $0xc,%esp
  8022dd:	6a 02                	push   $0x2
  8022df:	e8 35 0a 00 00       	call   802d19 <ipc_find_env>
  8022e4:	a3 14 50 80 00       	mov    %eax,0x805014
  8022e9:	83 c4 10             	add    $0x10,%esp
  8022ec:	eb c6                	jmp    8022b4 <nsipc+0x12>

008022ee <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8022ee:	55                   	push   %ebp
  8022ef:	89 e5                	mov    %esp,%ebp
  8022f1:	56                   	push   %esi
  8022f2:	53                   	push   %ebx
  8022f3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8022f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8022fe:	8b 06                	mov    (%esi),%eax
  802300:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802305:	b8 01 00 00 00       	mov    $0x1,%eax
  80230a:	e8 93 ff ff ff       	call   8022a2 <nsipc>
  80230f:	89 c3                	mov    %eax,%ebx
  802311:	85 c0                	test   %eax,%eax
  802313:	79 09                	jns    80231e <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802315:	89 d8                	mov    %ebx,%eax
  802317:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80231a:	5b                   	pop    %ebx
  80231b:	5e                   	pop    %esi
  80231c:	5d                   	pop    %ebp
  80231d:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80231e:	83 ec 04             	sub    $0x4,%esp
  802321:	ff 35 10 70 80 00    	pushl  0x807010
  802327:	68 00 70 80 00       	push   $0x807000
  80232c:	ff 75 0c             	pushl  0xc(%ebp)
  80232f:	e8 dc ef ff ff       	call   801310 <memmove>
		*addrlen = ret->ret_addrlen;
  802334:	a1 10 70 80 00       	mov    0x807010,%eax
  802339:	89 06                	mov    %eax,(%esi)
  80233b:	83 c4 10             	add    $0x10,%esp
	return r;
  80233e:	eb d5                	jmp    802315 <nsipc_accept+0x27>

00802340 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802340:	55                   	push   %ebp
  802341:	89 e5                	mov    %esp,%ebp
  802343:	53                   	push   %ebx
  802344:	83 ec 08             	sub    $0x8,%esp
  802347:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80234a:	8b 45 08             	mov    0x8(%ebp),%eax
  80234d:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802352:	53                   	push   %ebx
  802353:	ff 75 0c             	pushl  0xc(%ebp)
  802356:	68 04 70 80 00       	push   $0x807004
  80235b:	e8 b0 ef ff ff       	call   801310 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802360:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802366:	b8 02 00 00 00       	mov    $0x2,%eax
  80236b:	e8 32 ff ff ff       	call   8022a2 <nsipc>
}
  802370:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802373:	c9                   	leave  
  802374:	c3                   	ret    

00802375 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802375:	55                   	push   %ebp
  802376:	89 e5                	mov    %esp,%ebp
  802378:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80237b:	8b 45 08             	mov    0x8(%ebp),%eax
  80237e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802383:	8b 45 0c             	mov    0xc(%ebp),%eax
  802386:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80238b:	b8 03 00 00 00       	mov    $0x3,%eax
  802390:	e8 0d ff ff ff       	call   8022a2 <nsipc>
}
  802395:	c9                   	leave  
  802396:	c3                   	ret    

00802397 <nsipc_close>:

int
nsipc_close(int s)
{
  802397:	55                   	push   %ebp
  802398:	89 e5                	mov    %esp,%ebp
  80239a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80239d:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a0:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8023a5:	b8 04 00 00 00       	mov    $0x4,%eax
  8023aa:	e8 f3 fe ff ff       	call   8022a2 <nsipc>
}
  8023af:	c9                   	leave  
  8023b0:	c3                   	ret    

008023b1 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8023b1:	55                   	push   %ebp
  8023b2:	89 e5                	mov    %esp,%ebp
  8023b4:	53                   	push   %ebx
  8023b5:	83 ec 08             	sub    $0x8,%esp
  8023b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8023bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023be:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8023c3:	53                   	push   %ebx
  8023c4:	ff 75 0c             	pushl  0xc(%ebp)
  8023c7:	68 04 70 80 00       	push   $0x807004
  8023cc:	e8 3f ef ff ff       	call   801310 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8023d1:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8023d7:	b8 05 00 00 00       	mov    $0x5,%eax
  8023dc:	e8 c1 fe ff ff       	call   8022a2 <nsipc>
}
  8023e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023e4:	c9                   	leave  
  8023e5:	c3                   	ret    

008023e6 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8023e6:	55                   	push   %ebp
  8023e7:	89 e5                	mov    %esp,%ebp
  8023e9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8023ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ef:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8023f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023f7:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8023fc:	b8 06 00 00 00       	mov    $0x6,%eax
  802401:	e8 9c fe ff ff       	call   8022a2 <nsipc>
}
  802406:	c9                   	leave  
  802407:	c3                   	ret    

00802408 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802408:	55                   	push   %ebp
  802409:	89 e5                	mov    %esp,%ebp
  80240b:	56                   	push   %esi
  80240c:	53                   	push   %ebx
  80240d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802410:	8b 45 08             	mov    0x8(%ebp),%eax
  802413:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802418:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80241e:	8b 45 14             	mov    0x14(%ebp),%eax
  802421:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802426:	b8 07 00 00 00       	mov    $0x7,%eax
  80242b:	e8 72 fe ff ff       	call   8022a2 <nsipc>
  802430:	89 c3                	mov    %eax,%ebx
  802432:	85 c0                	test   %eax,%eax
  802434:	78 1f                	js     802455 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802436:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80243b:	7f 21                	jg     80245e <nsipc_recv+0x56>
  80243d:	39 c6                	cmp    %eax,%esi
  80243f:	7c 1d                	jl     80245e <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802441:	83 ec 04             	sub    $0x4,%esp
  802444:	50                   	push   %eax
  802445:	68 00 70 80 00       	push   $0x807000
  80244a:	ff 75 0c             	pushl  0xc(%ebp)
  80244d:	e8 be ee ff ff       	call   801310 <memmove>
  802452:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802455:	89 d8                	mov    %ebx,%eax
  802457:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80245a:	5b                   	pop    %ebx
  80245b:	5e                   	pop    %esi
  80245c:	5d                   	pop    %ebp
  80245d:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80245e:	68 63 37 80 00       	push   $0x803763
  802463:	68 2b 37 80 00       	push   $0x80372b
  802468:	6a 62                	push   $0x62
  80246a:	68 78 37 80 00       	push   $0x803778
  80246f:	e8 b9 e4 ff ff       	call   80092d <_panic>

00802474 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802474:	55                   	push   %ebp
  802475:	89 e5                	mov    %esp,%ebp
  802477:	53                   	push   %ebx
  802478:	83 ec 04             	sub    $0x4,%esp
  80247b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80247e:	8b 45 08             	mov    0x8(%ebp),%eax
  802481:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802486:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80248c:	7f 2e                	jg     8024bc <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80248e:	83 ec 04             	sub    $0x4,%esp
  802491:	53                   	push   %ebx
  802492:	ff 75 0c             	pushl  0xc(%ebp)
  802495:	68 0c 70 80 00       	push   $0x80700c
  80249a:	e8 71 ee ff ff       	call   801310 <memmove>
	nsipcbuf.send.req_size = size;
  80249f:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8024a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8024a8:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8024ad:	b8 08 00 00 00       	mov    $0x8,%eax
  8024b2:	e8 eb fd ff ff       	call   8022a2 <nsipc>
}
  8024b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024ba:	c9                   	leave  
  8024bb:	c3                   	ret    
	assert(size < 1600);
  8024bc:	68 84 37 80 00       	push   $0x803784
  8024c1:	68 2b 37 80 00       	push   $0x80372b
  8024c6:	6a 6d                	push   $0x6d
  8024c8:	68 78 37 80 00       	push   $0x803778
  8024cd:	e8 5b e4 ff ff       	call   80092d <_panic>

008024d2 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8024d2:	55                   	push   %ebp
  8024d3:	89 e5                	mov    %esp,%ebp
  8024d5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8024d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024db:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8024e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024e3:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8024e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8024eb:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8024f0:	b8 09 00 00 00       	mov    $0x9,%eax
  8024f5:	e8 a8 fd ff ff       	call   8022a2 <nsipc>
}
  8024fa:	c9                   	leave  
  8024fb:	c3                   	ret    

008024fc <free>:
	return v;
}

void
free(void *v)
{
  8024fc:	55                   	push   %ebp
  8024fd:	89 e5                	mov    %esp,%ebp
  8024ff:	53                   	push   %ebx
  802500:	83 ec 04             	sub    $0x4,%esp
  802503:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
  802506:	85 db                	test   %ebx,%ebx
  802508:	0f 84 85 00 00 00    	je     802593 <free+0x97>
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  80250e:	8d 83 00 00 00 f8    	lea    -0x8000000(%ebx),%eax
  802514:	3d ff ff ff 07       	cmp    $0x7ffffff,%eax
  802519:	77 51                	ja     80256c <free+0x70>

	c = ROUNDDOWN(v, PGSIZE);
  80251b:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  802521:	89 d8                	mov    %ebx,%eax
  802523:	c1 e8 0c             	shr    $0xc,%eax
  802526:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80252d:	f6 c4 02             	test   $0x2,%ah
  802530:	74 50                	je     802582 <free+0x86>
		sys_page_unmap(0, c);
  802532:	83 ec 08             	sub    $0x8,%esp
  802535:	53                   	push   %ebx
  802536:	6a 00                	push   $0x0
  802538:	e8 bc f0 ff ff       	call   8015f9 <sys_page_unmap>
		c += PGSIZE;
  80253d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		assert(mbegin <= c && c < mend);
  802543:	8d 83 00 00 00 f8    	lea    -0x8000000(%ebx),%eax
  802549:	83 c4 10             	add    $0x10,%esp
  80254c:	3d ff ff ff 07       	cmp    $0x7ffffff,%eax
  802551:	76 ce                	jbe    802521 <free+0x25>
  802553:	68 cd 37 80 00       	push   $0x8037cd
  802558:	68 2b 37 80 00       	push   $0x80372b
  80255d:	68 81 00 00 00       	push   $0x81
  802562:	68 c0 37 80 00       	push   $0x8037c0
  802567:	e8 c1 e3 ff ff       	call   80092d <_panic>
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  80256c:	68 90 37 80 00       	push   $0x803790
  802571:	68 2b 37 80 00       	push   $0x80372b
  802576:	6a 7a                	push   $0x7a
  802578:	68 c0 37 80 00       	push   $0x8037c0
  80257d:	e8 ab e3 ff ff       	call   80092d <_panic>
	/*
	 * c is just a piece of this page, so dec the ref count
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
	if (--(*ref) == 0)
  802582:	8b 83 fc 0f 00 00    	mov    0xffc(%ebx),%eax
  802588:	83 e8 01             	sub    $0x1,%eax
  80258b:	89 83 fc 0f 00 00    	mov    %eax,0xffc(%ebx)
  802591:	74 05                	je     802598 <free+0x9c>
		sys_page_unmap(0, c);
}
  802593:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802596:	c9                   	leave  
  802597:	c3                   	ret    
		sys_page_unmap(0, c);
  802598:	83 ec 08             	sub    $0x8,%esp
  80259b:	53                   	push   %ebx
  80259c:	6a 00                	push   $0x0
  80259e:	e8 56 f0 ff ff       	call   8015f9 <sys_page_unmap>
  8025a3:	83 c4 10             	add    $0x10,%esp
  8025a6:	eb eb                	jmp    802593 <free+0x97>

008025a8 <malloc>:
{
  8025a8:	55                   	push   %ebp
  8025a9:	89 e5                	mov    %esp,%ebp
  8025ab:	57                   	push   %edi
  8025ac:	56                   	push   %esi
  8025ad:	53                   	push   %ebx
  8025ae:	83 ec 1c             	sub    $0x1c,%esp
	if (mptr == 0)
  8025b1:	a1 18 50 80 00       	mov    0x805018,%eax
  8025b6:	85 c0                	test   %eax,%eax
  8025b8:	74 74                	je     80262e <malloc+0x86>
	n = ROUNDUP(n, 4);
  8025ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025bd:	8d 51 03             	lea    0x3(%ecx),%edx
  8025c0:	83 e2 fc             	and    $0xfffffffc,%edx
  8025c3:	89 d6                	mov    %edx,%esi
  8025c5:	89 55 dc             	mov    %edx,-0x24(%ebp)
	if (n >= MAXMALLOC)
  8025c8:	81 fa ff ff 0f 00    	cmp    $0xfffff,%edx
  8025ce:	0f 87 55 01 00 00    	ja     802729 <malloc+0x181>
	if ((uintptr_t) mptr % PGSIZE){
  8025d4:	89 c1                	mov    %eax,%ecx
  8025d6:	a9 ff 0f 00 00       	test   $0xfff,%eax
  8025db:	74 30                	je     80260d <malloc+0x65>
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
  8025dd:	89 c3                	mov    %eax,%ebx
  8025df:	c1 eb 0c             	shr    $0xc,%ebx
  8025e2:	8d 54 10 03          	lea    0x3(%eax,%edx,1),%edx
  8025e6:	c1 ea 0c             	shr    $0xc,%edx
  8025e9:	39 d3                	cmp    %edx,%ebx
  8025eb:	74 64                	je     802651 <malloc+0xa9>
		free(mptr);	/* drop reference to this page */
  8025ed:	83 ec 0c             	sub    $0xc,%esp
  8025f0:	50                   	push   %eax
  8025f1:	e8 06 ff ff ff       	call   8024fc <free>
		mptr = ROUNDDOWN(mptr + PGSIZE, PGSIZE);
  8025f6:	a1 18 50 80 00       	mov    0x805018,%eax
  8025fb:	05 00 10 00 00       	add    $0x1000,%eax
  802600:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802605:	a3 18 50 80 00       	mov    %eax,0x805018
  80260a:	83 c4 10             	add    $0x10,%esp
  80260d:	8b 15 18 50 80 00    	mov    0x805018,%edx
{
  802613:	c7 45 d8 02 00 00 00 	movl   $0x2,-0x28(%ebp)
  80261a:	be 00 00 00 00       	mov    $0x0,%esi
		if (isfree(mptr, n + 4))
  80261f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802622:	8d 78 04             	lea    0x4(%eax),%edi
  802625:	c6 45 e3 01          	movb   $0x1,-0x1d(%ebp)
  802629:	e9 86 00 00 00       	jmp    8026b4 <malloc+0x10c>
		mptr = mbegin;
  80262e:	c7 05 18 50 80 00 00 	movl   $0x8000000,0x805018
  802635:	00 00 08 
	n = ROUNDUP(n, 4);
  802638:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80263b:	8d 51 03             	lea    0x3(%ecx),%edx
  80263e:	83 e2 fc             	and    $0xfffffffc,%edx
  802641:	89 55 dc             	mov    %edx,-0x24(%ebp)
	if (n >= MAXMALLOC)
  802644:	81 fa ff ff 0f 00    	cmp    $0xfffff,%edx
  80264a:	76 c1                	jbe    80260d <malloc+0x65>
  80264c:	e9 fd 00 00 00       	jmp    80274e <malloc+0x1a6>
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
  802651:	81 c1 ff 0f 00 00    	add    $0xfff,%ecx
  802657:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
			(*ref)++;
  80265d:	83 41 fc 01          	addl   $0x1,-0x4(%ecx)
			mptr += n;
  802661:	89 f2                	mov    %esi,%edx
  802663:	01 c2                	add    %eax,%edx
  802665:	89 15 18 50 80 00    	mov    %edx,0x805018
			return v;
  80266b:	e9 de 00 00 00       	jmp    80274e <malloc+0x1a6>
	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  802670:	05 00 10 00 00       	add    $0x1000,%eax
  802675:	39 c8                	cmp    %ecx,%eax
  802677:	73 66                	jae    8026df <malloc+0x137>
		if (va >= (uintptr_t) mend
  802679:	3d ff ff ff 0f       	cmp    $0xfffffff,%eax
  80267e:	77 22                	ja     8026a2 <malloc+0xfa>
		    || ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
  802680:	89 c3                	mov    %eax,%ebx
  802682:	c1 eb 16             	shr    $0x16,%ebx
  802685:	8b 1c 9d 00 d0 7b ef 	mov    -0x10843000(,%ebx,4),%ebx
  80268c:	f6 c3 01             	test   $0x1,%bl
  80268f:	74 df                	je     802670 <malloc+0xc8>
  802691:	89 c3                	mov    %eax,%ebx
  802693:	c1 eb 0c             	shr    $0xc,%ebx
  802696:	8b 1c 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%ebx
  80269d:	f6 c3 01             	test   $0x1,%bl
  8026a0:	74 ce                	je     802670 <malloc+0xc8>
  8026a2:	81 c2 00 10 00 00    	add    $0x1000,%edx
  8026a8:	0f b6 75 e3          	movzbl -0x1d(%ebp),%esi
		if (mptr == mend) {
  8026ac:	81 fa 00 00 00 10    	cmp    $0x10000000,%edx
  8026b2:	74 0a                	je     8026be <malloc+0x116>
  8026b4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  8026b7:	89 d0                	mov    %edx,%eax
  8026b9:	8d 0c 17             	lea    (%edi,%edx,1),%ecx
  8026bc:	eb b7                	jmp    802675 <malloc+0xcd>
			mptr = mbegin;
  8026be:	ba 00 00 00 08       	mov    $0x8000000,%edx
  8026c3:	be 01 00 00 00       	mov    $0x1,%esi
			if (++nwrap == 2)
  8026c8:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8026cc:	75 e6                	jne    8026b4 <malloc+0x10c>
  8026ce:	c7 05 18 50 80 00 00 	movl   $0x8000000,0x805018
  8026d5:	00 00 08 
				return 0;	/* out of address space */
  8026d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8026dd:	eb 6f                	jmp    80274e <malloc+0x1a6>
  8026df:	89 f0                	mov    %esi,%eax
  8026e1:	84 c0                	test   %al,%al
  8026e3:	74 08                	je     8026ed <malloc+0x145>
  8026e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e8:	a3 18 50 80 00       	mov    %eax,0x805018
	for (i = 0; i < n + 4; i += PGSIZE){
  8026ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026f2:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
  8026f5:	8d b3 00 10 00 00    	lea    0x1000(%ebx),%esi
  8026fb:	39 f7                	cmp    %esi,%edi
  8026fd:	76 57                	jbe    802756 <malloc+0x1ae>
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  8026ff:	83 ec 04             	sub    $0x4,%esp
  802702:	68 07 02 00 00       	push   $0x207
  802707:	89 d8                	mov    %ebx,%eax
  802709:	03 05 18 50 80 00    	add    0x805018,%eax
  80270f:	50                   	push   %eax
  802710:	6a 00                	push   $0x0
  802712:	e8 5d ee ff ff       	call   801574 <sys_page_alloc>
  802717:	83 c4 10             	add    $0x10,%esp
  80271a:	85 c0                	test   %eax,%eax
  80271c:	78 55                	js     802773 <malloc+0x1cb>
	for (i = 0; i < n + 4; i += PGSIZE){
  80271e:	89 f3                	mov    %esi,%ebx
  802720:	eb d0                	jmp    8026f2 <malloc+0x14a>
			return 0;	/* out of physical memory */
  802722:	b8 00 00 00 00       	mov    $0x0,%eax
  802727:	eb 25                	jmp    80274e <malloc+0x1a6>
		return 0;
  802729:	b8 00 00 00 00       	mov    $0x0,%eax
  80272e:	eb 1e                	jmp    80274e <malloc+0x1a6>
	ref = (uint32_t*) (mptr + i - 4);
  802730:	a1 18 50 80 00       	mov    0x805018,%eax
	*ref = 2;	/* reference for mptr, reference for returned block */
  802735:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  802738:	c7 84 08 fc 0f 00 00 	movl   $0x2,0xffc(%eax,%ecx,1)
  80273f:	02 00 00 00 
	mptr += n;
  802743:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802746:	01 c2                	add    %eax,%edx
  802748:	89 15 18 50 80 00    	mov    %edx,0x805018
}
  80274e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802751:	5b                   	pop    %ebx
  802752:	5e                   	pop    %esi
  802753:	5f                   	pop    %edi
  802754:	5d                   	pop    %ebp
  802755:	c3                   	ret    
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  802756:	83 ec 04             	sub    $0x4,%esp
  802759:	6a 07                	push   $0x7
  80275b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80275e:	03 05 18 50 80 00    	add    0x805018,%eax
  802764:	50                   	push   %eax
  802765:	6a 00                	push   $0x0
  802767:	e8 08 ee ff ff       	call   801574 <sys_page_alloc>
  80276c:	83 c4 10             	add    $0x10,%esp
  80276f:	85 c0                	test   %eax,%eax
  802771:	79 bd                	jns    802730 <malloc+0x188>
			for (; i >= 0; i -= PGSIZE)
  802773:	85 db                	test   %ebx,%ebx
  802775:	78 ab                	js     802722 <malloc+0x17a>
				sys_page_unmap(0, mptr + i);
  802777:	83 ec 08             	sub    $0x8,%esp
  80277a:	89 d8                	mov    %ebx,%eax
  80277c:	03 05 18 50 80 00    	add    0x805018,%eax
  802782:	50                   	push   %eax
  802783:	6a 00                	push   $0x0
  802785:	e8 6f ee ff ff       	call   8015f9 <sys_page_unmap>
			for (; i >= 0; i -= PGSIZE)
  80278a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
  802790:	83 c4 10             	add    $0x10,%esp
  802793:	eb de                	jmp    802773 <malloc+0x1cb>

00802795 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802795:	55                   	push   %ebp
  802796:	89 e5                	mov    %esp,%ebp
  802798:	56                   	push   %esi
  802799:	53                   	push   %ebx
  80279a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80279d:	83 ec 0c             	sub    $0xc,%esp
  8027a0:	ff 75 08             	pushl  0x8(%ebp)
  8027a3:	e8 d1 f0 ff ff       	call   801879 <fd2data>
  8027a8:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8027aa:	83 c4 08             	add    $0x8,%esp
  8027ad:	68 e5 37 80 00       	push   $0x8037e5
  8027b2:	53                   	push   %ebx
  8027b3:	e8 ca e9 ff ff       	call   801182 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8027b8:	8b 46 04             	mov    0x4(%esi),%eax
  8027bb:	2b 06                	sub    (%esi),%eax
  8027bd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8027c3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8027ca:	00 00 00 
	stat->st_dev = &devpipe;
  8027cd:	c7 83 88 00 00 00 5c 	movl   $0x80405c,0x88(%ebx)
  8027d4:	40 80 00 
	return 0;
}
  8027d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027df:	5b                   	pop    %ebx
  8027e0:	5e                   	pop    %esi
  8027e1:	5d                   	pop    %ebp
  8027e2:	c3                   	ret    

008027e3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8027e3:	55                   	push   %ebp
  8027e4:	89 e5                	mov    %esp,%ebp
  8027e6:	53                   	push   %ebx
  8027e7:	83 ec 0c             	sub    $0xc,%esp
  8027ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8027ed:	53                   	push   %ebx
  8027ee:	6a 00                	push   $0x0
  8027f0:	e8 04 ee ff ff       	call   8015f9 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8027f5:	89 1c 24             	mov    %ebx,(%esp)
  8027f8:	e8 7c f0 ff ff       	call   801879 <fd2data>
  8027fd:	83 c4 08             	add    $0x8,%esp
  802800:	50                   	push   %eax
  802801:	6a 00                	push   $0x0
  802803:	e8 f1 ed ff ff       	call   8015f9 <sys_page_unmap>
}
  802808:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80280b:	c9                   	leave  
  80280c:	c3                   	ret    

0080280d <_pipeisclosed>:
{
  80280d:	55                   	push   %ebp
  80280e:	89 e5                	mov    %esp,%ebp
  802810:	57                   	push   %edi
  802811:	56                   	push   %esi
  802812:	53                   	push   %ebx
  802813:	83 ec 1c             	sub    $0x1c,%esp
  802816:	89 c7                	mov    %eax,%edi
  802818:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80281a:	a1 1c 50 80 00       	mov    0x80501c,%eax
  80281f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802822:	83 ec 0c             	sub    $0xc,%esp
  802825:	57                   	push   %edi
  802826:	e8 2d 05 00 00       	call   802d58 <pageref>
  80282b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80282e:	89 34 24             	mov    %esi,(%esp)
  802831:	e8 22 05 00 00       	call   802d58 <pageref>
		nn = thisenv->env_runs;
  802836:	8b 15 1c 50 80 00    	mov    0x80501c,%edx
  80283c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80283f:	83 c4 10             	add    $0x10,%esp
  802842:	39 cb                	cmp    %ecx,%ebx
  802844:	74 1b                	je     802861 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802846:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802849:	75 cf                	jne    80281a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80284b:	8b 42 58             	mov    0x58(%edx),%eax
  80284e:	6a 01                	push   $0x1
  802850:	50                   	push   %eax
  802851:	53                   	push   %ebx
  802852:	68 ec 37 80 00       	push   $0x8037ec
  802857:	e8 c7 e1 ff ff       	call   800a23 <cprintf>
  80285c:	83 c4 10             	add    $0x10,%esp
  80285f:	eb b9                	jmp    80281a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802861:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802864:	0f 94 c0             	sete   %al
  802867:	0f b6 c0             	movzbl %al,%eax
}
  80286a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80286d:	5b                   	pop    %ebx
  80286e:	5e                   	pop    %esi
  80286f:	5f                   	pop    %edi
  802870:	5d                   	pop    %ebp
  802871:	c3                   	ret    

00802872 <devpipe_write>:
{
  802872:	55                   	push   %ebp
  802873:	89 e5                	mov    %esp,%ebp
  802875:	57                   	push   %edi
  802876:	56                   	push   %esi
  802877:	53                   	push   %ebx
  802878:	83 ec 28             	sub    $0x28,%esp
  80287b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80287e:	56                   	push   %esi
  80287f:	e8 f5 ef ff ff       	call   801879 <fd2data>
  802884:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802886:	83 c4 10             	add    $0x10,%esp
  802889:	bf 00 00 00 00       	mov    $0x0,%edi
  80288e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802891:	74 4f                	je     8028e2 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802893:	8b 43 04             	mov    0x4(%ebx),%eax
  802896:	8b 0b                	mov    (%ebx),%ecx
  802898:	8d 51 20             	lea    0x20(%ecx),%edx
  80289b:	39 d0                	cmp    %edx,%eax
  80289d:	72 14                	jb     8028b3 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80289f:	89 da                	mov    %ebx,%edx
  8028a1:	89 f0                	mov    %esi,%eax
  8028a3:	e8 65 ff ff ff       	call   80280d <_pipeisclosed>
  8028a8:	85 c0                	test   %eax,%eax
  8028aa:	75 3b                	jne    8028e7 <devpipe_write+0x75>
			sys_yield();
  8028ac:	e8 a4 ec ff ff       	call   801555 <sys_yield>
  8028b1:	eb e0                	jmp    802893 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8028b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8028b6:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8028ba:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8028bd:	89 c2                	mov    %eax,%edx
  8028bf:	c1 fa 1f             	sar    $0x1f,%edx
  8028c2:	89 d1                	mov    %edx,%ecx
  8028c4:	c1 e9 1b             	shr    $0x1b,%ecx
  8028c7:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8028ca:	83 e2 1f             	and    $0x1f,%edx
  8028cd:	29 ca                	sub    %ecx,%edx
  8028cf:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8028d3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8028d7:	83 c0 01             	add    $0x1,%eax
  8028da:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8028dd:	83 c7 01             	add    $0x1,%edi
  8028e0:	eb ac                	jmp    80288e <devpipe_write+0x1c>
	return i;
  8028e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8028e5:	eb 05                	jmp    8028ec <devpipe_write+0x7a>
				return 0;
  8028e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028ef:	5b                   	pop    %ebx
  8028f0:	5e                   	pop    %esi
  8028f1:	5f                   	pop    %edi
  8028f2:	5d                   	pop    %ebp
  8028f3:	c3                   	ret    

008028f4 <devpipe_read>:
{
  8028f4:	55                   	push   %ebp
  8028f5:	89 e5                	mov    %esp,%ebp
  8028f7:	57                   	push   %edi
  8028f8:	56                   	push   %esi
  8028f9:	53                   	push   %ebx
  8028fa:	83 ec 18             	sub    $0x18,%esp
  8028fd:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802900:	57                   	push   %edi
  802901:	e8 73 ef ff ff       	call   801879 <fd2data>
  802906:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802908:	83 c4 10             	add    $0x10,%esp
  80290b:	be 00 00 00 00       	mov    $0x0,%esi
  802910:	3b 75 10             	cmp    0x10(%ebp),%esi
  802913:	75 14                	jne    802929 <devpipe_read+0x35>
	return i;
  802915:	8b 45 10             	mov    0x10(%ebp),%eax
  802918:	eb 02                	jmp    80291c <devpipe_read+0x28>
				return i;
  80291a:	89 f0                	mov    %esi,%eax
}
  80291c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80291f:	5b                   	pop    %ebx
  802920:	5e                   	pop    %esi
  802921:	5f                   	pop    %edi
  802922:	5d                   	pop    %ebp
  802923:	c3                   	ret    
			sys_yield();
  802924:	e8 2c ec ff ff       	call   801555 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802929:	8b 03                	mov    (%ebx),%eax
  80292b:	3b 43 04             	cmp    0x4(%ebx),%eax
  80292e:	75 18                	jne    802948 <devpipe_read+0x54>
			if (i > 0)
  802930:	85 f6                	test   %esi,%esi
  802932:	75 e6                	jne    80291a <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802934:	89 da                	mov    %ebx,%edx
  802936:	89 f8                	mov    %edi,%eax
  802938:	e8 d0 fe ff ff       	call   80280d <_pipeisclosed>
  80293d:	85 c0                	test   %eax,%eax
  80293f:	74 e3                	je     802924 <devpipe_read+0x30>
				return 0;
  802941:	b8 00 00 00 00       	mov    $0x0,%eax
  802946:	eb d4                	jmp    80291c <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802948:	99                   	cltd   
  802949:	c1 ea 1b             	shr    $0x1b,%edx
  80294c:	01 d0                	add    %edx,%eax
  80294e:	83 e0 1f             	and    $0x1f,%eax
  802951:	29 d0                	sub    %edx,%eax
  802953:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802958:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80295b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80295e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802961:	83 c6 01             	add    $0x1,%esi
  802964:	eb aa                	jmp    802910 <devpipe_read+0x1c>

00802966 <pipe>:
{
  802966:	55                   	push   %ebp
  802967:	89 e5                	mov    %esp,%ebp
  802969:	56                   	push   %esi
  80296a:	53                   	push   %ebx
  80296b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80296e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802971:	50                   	push   %eax
  802972:	e8 19 ef ff ff       	call   801890 <fd_alloc>
  802977:	89 c3                	mov    %eax,%ebx
  802979:	83 c4 10             	add    $0x10,%esp
  80297c:	85 c0                	test   %eax,%eax
  80297e:	0f 88 23 01 00 00    	js     802aa7 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802984:	83 ec 04             	sub    $0x4,%esp
  802987:	68 07 04 00 00       	push   $0x407
  80298c:	ff 75 f4             	pushl  -0xc(%ebp)
  80298f:	6a 00                	push   $0x0
  802991:	e8 de eb ff ff       	call   801574 <sys_page_alloc>
  802996:	89 c3                	mov    %eax,%ebx
  802998:	83 c4 10             	add    $0x10,%esp
  80299b:	85 c0                	test   %eax,%eax
  80299d:	0f 88 04 01 00 00    	js     802aa7 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8029a3:	83 ec 0c             	sub    $0xc,%esp
  8029a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8029a9:	50                   	push   %eax
  8029aa:	e8 e1 ee ff ff       	call   801890 <fd_alloc>
  8029af:	89 c3                	mov    %eax,%ebx
  8029b1:	83 c4 10             	add    $0x10,%esp
  8029b4:	85 c0                	test   %eax,%eax
  8029b6:	0f 88 db 00 00 00    	js     802a97 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8029bc:	83 ec 04             	sub    $0x4,%esp
  8029bf:	68 07 04 00 00       	push   $0x407
  8029c4:	ff 75 f0             	pushl  -0x10(%ebp)
  8029c7:	6a 00                	push   $0x0
  8029c9:	e8 a6 eb ff ff       	call   801574 <sys_page_alloc>
  8029ce:	89 c3                	mov    %eax,%ebx
  8029d0:	83 c4 10             	add    $0x10,%esp
  8029d3:	85 c0                	test   %eax,%eax
  8029d5:	0f 88 bc 00 00 00    	js     802a97 <pipe+0x131>
	va = fd2data(fd0);
  8029db:	83 ec 0c             	sub    $0xc,%esp
  8029de:	ff 75 f4             	pushl  -0xc(%ebp)
  8029e1:	e8 93 ee ff ff       	call   801879 <fd2data>
  8029e6:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8029e8:	83 c4 0c             	add    $0xc,%esp
  8029eb:	68 07 04 00 00       	push   $0x407
  8029f0:	50                   	push   %eax
  8029f1:	6a 00                	push   $0x0
  8029f3:	e8 7c eb ff ff       	call   801574 <sys_page_alloc>
  8029f8:	89 c3                	mov    %eax,%ebx
  8029fa:	83 c4 10             	add    $0x10,%esp
  8029fd:	85 c0                	test   %eax,%eax
  8029ff:	0f 88 82 00 00 00    	js     802a87 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a05:	83 ec 0c             	sub    $0xc,%esp
  802a08:	ff 75 f0             	pushl  -0x10(%ebp)
  802a0b:	e8 69 ee ff ff       	call   801879 <fd2data>
  802a10:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802a17:	50                   	push   %eax
  802a18:	6a 00                	push   $0x0
  802a1a:	56                   	push   %esi
  802a1b:	6a 00                	push   $0x0
  802a1d:	e8 95 eb ff ff       	call   8015b7 <sys_page_map>
  802a22:	89 c3                	mov    %eax,%ebx
  802a24:	83 c4 20             	add    $0x20,%esp
  802a27:	85 c0                	test   %eax,%eax
  802a29:	78 4e                	js     802a79 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802a2b:	a1 5c 40 80 00       	mov    0x80405c,%eax
  802a30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a33:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802a35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a38:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802a3f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a42:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802a44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a47:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802a4e:	83 ec 0c             	sub    $0xc,%esp
  802a51:	ff 75 f4             	pushl  -0xc(%ebp)
  802a54:	e8 10 ee ff ff       	call   801869 <fd2num>
  802a59:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802a5c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802a5e:	83 c4 04             	add    $0x4,%esp
  802a61:	ff 75 f0             	pushl  -0x10(%ebp)
  802a64:	e8 00 ee ff ff       	call   801869 <fd2num>
  802a69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802a6c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802a6f:	83 c4 10             	add    $0x10,%esp
  802a72:	bb 00 00 00 00       	mov    $0x0,%ebx
  802a77:	eb 2e                	jmp    802aa7 <pipe+0x141>
	sys_page_unmap(0, va);
  802a79:	83 ec 08             	sub    $0x8,%esp
  802a7c:	56                   	push   %esi
  802a7d:	6a 00                	push   $0x0
  802a7f:	e8 75 eb ff ff       	call   8015f9 <sys_page_unmap>
  802a84:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802a87:	83 ec 08             	sub    $0x8,%esp
  802a8a:	ff 75 f0             	pushl  -0x10(%ebp)
  802a8d:	6a 00                	push   $0x0
  802a8f:	e8 65 eb ff ff       	call   8015f9 <sys_page_unmap>
  802a94:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802a97:	83 ec 08             	sub    $0x8,%esp
  802a9a:	ff 75 f4             	pushl  -0xc(%ebp)
  802a9d:	6a 00                	push   $0x0
  802a9f:	e8 55 eb ff ff       	call   8015f9 <sys_page_unmap>
  802aa4:	83 c4 10             	add    $0x10,%esp
}
  802aa7:	89 d8                	mov    %ebx,%eax
  802aa9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802aac:	5b                   	pop    %ebx
  802aad:	5e                   	pop    %esi
  802aae:	5d                   	pop    %ebp
  802aaf:	c3                   	ret    

00802ab0 <pipeisclosed>:
{
  802ab0:	55                   	push   %ebp
  802ab1:	89 e5                	mov    %esp,%ebp
  802ab3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ab6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ab9:	50                   	push   %eax
  802aba:	ff 75 08             	pushl  0x8(%ebp)
  802abd:	e8 20 ee ff ff       	call   8018e2 <fd_lookup>
  802ac2:	83 c4 10             	add    $0x10,%esp
  802ac5:	85 c0                	test   %eax,%eax
  802ac7:	78 18                	js     802ae1 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802ac9:	83 ec 0c             	sub    $0xc,%esp
  802acc:	ff 75 f4             	pushl  -0xc(%ebp)
  802acf:	e8 a5 ed ff ff       	call   801879 <fd2data>
	return _pipeisclosed(fd, p);
  802ad4:	89 c2                	mov    %eax,%edx
  802ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad9:	e8 2f fd ff ff       	call   80280d <_pipeisclosed>
  802ade:	83 c4 10             	add    $0x10,%esp
}
  802ae1:	c9                   	leave  
  802ae2:	c3                   	ret    

00802ae3 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802ae3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae8:	c3                   	ret    

00802ae9 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802ae9:	55                   	push   %ebp
  802aea:	89 e5                	mov    %esp,%ebp
  802aec:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802aef:	68 04 38 80 00       	push   $0x803804
  802af4:	ff 75 0c             	pushl  0xc(%ebp)
  802af7:	e8 86 e6 ff ff       	call   801182 <strcpy>
	return 0;
}
  802afc:	b8 00 00 00 00       	mov    $0x0,%eax
  802b01:	c9                   	leave  
  802b02:	c3                   	ret    

00802b03 <devcons_write>:
{
  802b03:	55                   	push   %ebp
  802b04:	89 e5                	mov    %esp,%ebp
  802b06:	57                   	push   %edi
  802b07:	56                   	push   %esi
  802b08:	53                   	push   %ebx
  802b09:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802b0f:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802b14:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802b1a:	3b 75 10             	cmp    0x10(%ebp),%esi
  802b1d:	73 31                	jae    802b50 <devcons_write+0x4d>
		m = n - tot;
  802b1f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802b22:	29 f3                	sub    %esi,%ebx
  802b24:	83 fb 7f             	cmp    $0x7f,%ebx
  802b27:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802b2c:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802b2f:	83 ec 04             	sub    $0x4,%esp
  802b32:	53                   	push   %ebx
  802b33:	89 f0                	mov    %esi,%eax
  802b35:	03 45 0c             	add    0xc(%ebp),%eax
  802b38:	50                   	push   %eax
  802b39:	57                   	push   %edi
  802b3a:	e8 d1 e7 ff ff       	call   801310 <memmove>
		sys_cputs(buf, m);
  802b3f:	83 c4 08             	add    $0x8,%esp
  802b42:	53                   	push   %ebx
  802b43:	57                   	push   %edi
  802b44:	e8 6f e9 ff ff       	call   8014b8 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802b49:	01 de                	add    %ebx,%esi
  802b4b:	83 c4 10             	add    $0x10,%esp
  802b4e:	eb ca                	jmp    802b1a <devcons_write+0x17>
}
  802b50:	89 f0                	mov    %esi,%eax
  802b52:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802b55:	5b                   	pop    %ebx
  802b56:	5e                   	pop    %esi
  802b57:	5f                   	pop    %edi
  802b58:	5d                   	pop    %ebp
  802b59:	c3                   	ret    

00802b5a <devcons_read>:
{
  802b5a:	55                   	push   %ebp
  802b5b:	89 e5                	mov    %esp,%ebp
  802b5d:	83 ec 08             	sub    $0x8,%esp
  802b60:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802b65:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802b69:	74 21                	je     802b8c <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802b6b:	e8 66 e9 ff ff       	call   8014d6 <sys_cgetc>
  802b70:	85 c0                	test   %eax,%eax
  802b72:	75 07                	jne    802b7b <devcons_read+0x21>
		sys_yield();
  802b74:	e8 dc e9 ff ff       	call   801555 <sys_yield>
  802b79:	eb f0                	jmp    802b6b <devcons_read+0x11>
	if (c < 0)
  802b7b:	78 0f                	js     802b8c <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802b7d:	83 f8 04             	cmp    $0x4,%eax
  802b80:	74 0c                	je     802b8e <devcons_read+0x34>
	*(char*)vbuf = c;
  802b82:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b85:	88 02                	mov    %al,(%edx)
	return 1;
  802b87:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802b8c:	c9                   	leave  
  802b8d:	c3                   	ret    
		return 0;
  802b8e:	b8 00 00 00 00       	mov    $0x0,%eax
  802b93:	eb f7                	jmp    802b8c <devcons_read+0x32>

00802b95 <cputchar>:
{
  802b95:	55                   	push   %ebp
  802b96:	89 e5                	mov    %esp,%ebp
  802b98:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9e:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802ba1:	6a 01                	push   $0x1
  802ba3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802ba6:	50                   	push   %eax
  802ba7:	e8 0c e9 ff ff       	call   8014b8 <sys_cputs>
}
  802bac:	83 c4 10             	add    $0x10,%esp
  802baf:	c9                   	leave  
  802bb0:	c3                   	ret    

00802bb1 <getchar>:
{
  802bb1:	55                   	push   %ebp
  802bb2:	89 e5                	mov    %esp,%ebp
  802bb4:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802bb7:	6a 01                	push   $0x1
  802bb9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802bbc:	50                   	push   %eax
  802bbd:	6a 00                	push   $0x0
  802bbf:	e8 8e ef ff ff       	call   801b52 <read>
	if (r < 0)
  802bc4:	83 c4 10             	add    $0x10,%esp
  802bc7:	85 c0                	test   %eax,%eax
  802bc9:	78 06                	js     802bd1 <getchar+0x20>
	if (r < 1)
  802bcb:	74 06                	je     802bd3 <getchar+0x22>
	return c;
  802bcd:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802bd1:	c9                   	leave  
  802bd2:	c3                   	ret    
		return -E_EOF;
  802bd3:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802bd8:	eb f7                	jmp    802bd1 <getchar+0x20>

00802bda <iscons>:
{
  802bda:	55                   	push   %ebp
  802bdb:	89 e5                	mov    %esp,%ebp
  802bdd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802be0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802be3:	50                   	push   %eax
  802be4:	ff 75 08             	pushl  0x8(%ebp)
  802be7:	e8 f6 ec ff ff       	call   8018e2 <fd_lookup>
  802bec:	83 c4 10             	add    $0x10,%esp
  802bef:	85 c0                	test   %eax,%eax
  802bf1:	78 11                	js     802c04 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf6:	8b 15 78 40 80 00    	mov    0x804078,%edx
  802bfc:	39 10                	cmp    %edx,(%eax)
  802bfe:	0f 94 c0             	sete   %al
  802c01:	0f b6 c0             	movzbl %al,%eax
}
  802c04:	c9                   	leave  
  802c05:	c3                   	ret    

00802c06 <opencons>:
{
  802c06:	55                   	push   %ebp
  802c07:	89 e5                	mov    %esp,%ebp
  802c09:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802c0c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802c0f:	50                   	push   %eax
  802c10:	e8 7b ec ff ff       	call   801890 <fd_alloc>
  802c15:	83 c4 10             	add    $0x10,%esp
  802c18:	85 c0                	test   %eax,%eax
  802c1a:	78 3a                	js     802c56 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802c1c:	83 ec 04             	sub    $0x4,%esp
  802c1f:	68 07 04 00 00       	push   $0x407
  802c24:	ff 75 f4             	pushl  -0xc(%ebp)
  802c27:	6a 00                	push   $0x0
  802c29:	e8 46 e9 ff ff       	call   801574 <sys_page_alloc>
  802c2e:	83 c4 10             	add    $0x10,%esp
  802c31:	85 c0                	test   %eax,%eax
  802c33:	78 21                	js     802c56 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c38:	8b 15 78 40 80 00    	mov    0x804078,%edx
  802c3e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c43:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802c4a:	83 ec 0c             	sub    $0xc,%esp
  802c4d:	50                   	push   %eax
  802c4e:	e8 16 ec ff ff       	call   801869 <fd2num>
  802c53:	83 c4 10             	add    $0x10,%esp
}
  802c56:	c9                   	leave  
  802c57:	c3                   	ret    

00802c58 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802c58:	55                   	push   %ebp
  802c59:	89 e5                	mov    %esp,%ebp
  802c5b:	56                   	push   %esi
  802c5c:	53                   	push   %ebx
  802c5d:	8b 75 08             	mov    0x8(%ebp),%esi
  802c60:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c63:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802c66:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802c68:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802c6d:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802c70:	83 ec 0c             	sub    $0xc,%esp
  802c73:	50                   	push   %eax
  802c74:	e8 ab ea ff ff       	call   801724 <sys_ipc_recv>
	if(ret < 0){
  802c79:	83 c4 10             	add    $0x10,%esp
  802c7c:	85 c0                	test   %eax,%eax
  802c7e:	78 2b                	js     802cab <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802c80:	85 f6                	test   %esi,%esi
  802c82:	74 0a                	je     802c8e <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802c84:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802c89:	8b 40 78             	mov    0x78(%eax),%eax
  802c8c:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802c8e:	85 db                	test   %ebx,%ebx
  802c90:	74 0a                	je     802c9c <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802c92:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802c97:	8b 40 7c             	mov    0x7c(%eax),%eax
  802c9a:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802c9c:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802ca1:	8b 40 74             	mov    0x74(%eax),%eax
}
  802ca4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802ca7:	5b                   	pop    %ebx
  802ca8:	5e                   	pop    %esi
  802ca9:	5d                   	pop    %ebp
  802caa:	c3                   	ret    
		if(from_env_store)
  802cab:	85 f6                	test   %esi,%esi
  802cad:	74 06                	je     802cb5 <ipc_recv+0x5d>
			*from_env_store = 0;
  802caf:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802cb5:	85 db                	test   %ebx,%ebx
  802cb7:	74 eb                	je     802ca4 <ipc_recv+0x4c>
			*perm_store = 0;
  802cb9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802cbf:	eb e3                	jmp    802ca4 <ipc_recv+0x4c>

00802cc1 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802cc1:	55                   	push   %ebp
  802cc2:	89 e5                	mov    %esp,%ebp
  802cc4:	57                   	push   %edi
  802cc5:	56                   	push   %esi
  802cc6:	53                   	push   %ebx
  802cc7:	83 ec 0c             	sub    $0xc,%esp
  802cca:	8b 7d 08             	mov    0x8(%ebp),%edi
  802ccd:	8b 75 0c             	mov    0xc(%ebp),%esi
  802cd0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802cd3:	85 db                	test   %ebx,%ebx
  802cd5:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802cda:	0f 44 d8             	cmove  %eax,%ebx
  802cdd:	eb 05                	jmp    802ce4 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802cdf:	e8 71 e8 ff ff       	call   801555 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802ce4:	ff 75 14             	pushl  0x14(%ebp)
  802ce7:	53                   	push   %ebx
  802ce8:	56                   	push   %esi
  802ce9:	57                   	push   %edi
  802cea:	e8 12 ea ff ff       	call   801701 <sys_ipc_try_send>
  802cef:	83 c4 10             	add    $0x10,%esp
  802cf2:	85 c0                	test   %eax,%eax
  802cf4:	74 1b                	je     802d11 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802cf6:	79 e7                	jns    802cdf <ipc_send+0x1e>
  802cf8:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802cfb:	74 e2                	je     802cdf <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802cfd:	83 ec 04             	sub    $0x4,%esp
  802d00:	68 10 38 80 00       	push   $0x803810
  802d05:	6a 46                	push   $0x46
  802d07:	68 25 38 80 00       	push   $0x803825
  802d0c:	e8 1c dc ff ff       	call   80092d <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802d11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d14:	5b                   	pop    %ebx
  802d15:	5e                   	pop    %esi
  802d16:	5f                   	pop    %edi
  802d17:	5d                   	pop    %ebp
  802d18:	c3                   	ret    

00802d19 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802d19:	55                   	push   %ebp
  802d1a:	89 e5                	mov    %esp,%ebp
  802d1c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802d1f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802d24:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802d2a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802d30:	8b 52 50             	mov    0x50(%edx),%edx
  802d33:	39 ca                	cmp    %ecx,%edx
  802d35:	74 11                	je     802d48 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802d37:	83 c0 01             	add    $0x1,%eax
  802d3a:	3d 00 04 00 00       	cmp    $0x400,%eax
  802d3f:	75 e3                	jne    802d24 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802d41:	b8 00 00 00 00       	mov    $0x0,%eax
  802d46:	eb 0e                	jmp    802d56 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802d48:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  802d4e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802d53:	8b 40 48             	mov    0x48(%eax),%eax
}
  802d56:	5d                   	pop    %ebp
  802d57:	c3                   	ret    

00802d58 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802d58:	55                   	push   %ebp
  802d59:	89 e5                	mov    %esp,%ebp
  802d5b:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802d5e:	89 d0                	mov    %edx,%eax
  802d60:	c1 e8 16             	shr    $0x16,%eax
  802d63:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802d6a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802d6f:	f6 c1 01             	test   $0x1,%cl
  802d72:	74 1d                	je     802d91 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802d74:	c1 ea 0c             	shr    $0xc,%edx
  802d77:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802d7e:	f6 c2 01             	test   $0x1,%dl
  802d81:	74 0e                	je     802d91 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802d83:	c1 ea 0c             	shr    $0xc,%edx
  802d86:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802d8d:	ef 
  802d8e:	0f b7 c0             	movzwl %ax,%eax
}
  802d91:	5d                   	pop    %ebp
  802d92:	c3                   	ret    
  802d93:	66 90                	xchg   %ax,%ax
  802d95:	66 90                	xchg   %ax,%ax
  802d97:	66 90                	xchg   %ax,%ax
  802d99:	66 90                	xchg   %ax,%ax
  802d9b:	66 90                	xchg   %ax,%ax
  802d9d:	66 90                	xchg   %ax,%ax
  802d9f:	90                   	nop

00802da0 <__udivdi3>:
  802da0:	55                   	push   %ebp
  802da1:	57                   	push   %edi
  802da2:	56                   	push   %esi
  802da3:	53                   	push   %ebx
  802da4:	83 ec 1c             	sub    $0x1c,%esp
  802da7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802dab:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802daf:	8b 74 24 34          	mov    0x34(%esp),%esi
  802db3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802db7:	85 d2                	test   %edx,%edx
  802db9:	75 4d                	jne    802e08 <__udivdi3+0x68>
  802dbb:	39 f3                	cmp    %esi,%ebx
  802dbd:	76 19                	jbe    802dd8 <__udivdi3+0x38>
  802dbf:	31 ff                	xor    %edi,%edi
  802dc1:	89 e8                	mov    %ebp,%eax
  802dc3:	89 f2                	mov    %esi,%edx
  802dc5:	f7 f3                	div    %ebx
  802dc7:	89 fa                	mov    %edi,%edx
  802dc9:	83 c4 1c             	add    $0x1c,%esp
  802dcc:	5b                   	pop    %ebx
  802dcd:	5e                   	pop    %esi
  802dce:	5f                   	pop    %edi
  802dcf:	5d                   	pop    %ebp
  802dd0:	c3                   	ret    
  802dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802dd8:	89 d9                	mov    %ebx,%ecx
  802dda:	85 db                	test   %ebx,%ebx
  802ddc:	75 0b                	jne    802de9 <__udivdi3+0x49>
  802dde:	b8 01 00 00 00       	mov    $0x1,%eax
  802de3:	31 d2                	xor    %edx,%edx
  802de5:	f7 f3                	div    %ebx
  802de7:	89 c1                	mov    %eax,%ecx
  802de9:	31 d2                	xor    %edx,%edx
  802deb:	89 f0                	mov    %esi,%eax
  802ded:	f7 f1                	div    %ecx
  802def:	89 c6                	mov    %eax,%esi
  802df1:	89 e8                	mov    %ebp,%eax
  802df3:	89 f7                	mov    %esi,%edi
  802df5:	f7 f1                	div    %ecx
  802df7:	89 fa                	mov    %edi,%edx
  802df9:	83 c4 1c             	add    $0x1c,%esp
  802dfc:	5b                   	pop    %ebx
  802dfd:	5e                   	pop    %esi
  802dfe:	5f                   	pop    %edi
  802dff:	5d                   	pop    %ebp
  802e00:	c3                   	ret    
  802e01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802e08:	39 f2                	cmp    %esi,%edx
  802e0a:	77 1c                	ja     802e28 <__udivdi3+0x88>
  802e0c:	0f bd fa             	bsr    %edx,%edi
  802e0f:	83 f7 1f             	xor    $0x1f,%edi
  802e12:	75 2c                	jne    802e40 <__udivdi3+0xa0>
  802e14:	39 f2                	cmp    %esi,%edx
  802e16:	72 06                	jb     802e1e <__udivdi3+0x7e>
  802e18:	31 c0                	xor    %eax,%eax
  802e1a:	39 eb                	cmp    %ebp,%ebx
  802e1c:	77 a9                	ja     802dc7 <__udivdi3+0x27>
  802e1e:	b8 01 00 00 00       	mov    $0x1,%eax
  802e23:	eb a2                	jmp    802dc7 <__udivdi3+0x27>
  802e25:	8d 76 00             	lea    0x0(%esi),%esi
  802e28:	31 ff                	xor    %edi,%edi
  802e2a:	31 c0                	xor    %eax,%eax
  802e2c:	89 fa                	mov    %edi,%edx
  802e2e:	83 c4 1c             	add    $0x1c,%esp
  802e31:	5b                   	pop    %ebx
  802e32:	5e                   	pop    %esi
  802e33:	5f                   	pop    %edi
  802e34:	5d                   	pop    %ebp
  802e35:	c3                   	ret    
  802e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802e3d:	8d 76 00             	lea    0x0(%esi),%esi
  802e40:	89 f9                	mov    %edi,%ecx
  802e42:	b8 20 00 00 00       	mov    $0x20,%eax
  802e47:	29 f8                	sub    %edi,%eax
  802e49:	d3 e2                	shl    %cl,%edx
  802e4b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802e4f:	89 c1                	mov    %eax,%ecx
  802e51:	89 da                	mov    %ebx,%edx
  802e53:	d3 ea                	shr    %cl,%edx
  802e55:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802e59:	09 d1                	or     %edx,%ecx
  802e5b:	89 f2                	mov    %esi,%edx
  802e5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802e61:	89 f9                	mov    %edi,%ecx
  802e63:	d3 e3                	shl    %cl,%ebx
  802e65:	89 c1                	mov    %eax,%ecx
  802e67:	d3 ea                	shr    %cl,%edx
  802e69:	89 f9                	mov    %edi,%ecx
  802e6b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802e6f:	89 eb                	mov    %ebp,%ebx
  802e71:	d3 e6                	shl    %cl,%esi
  802e73:	89 c1                	mov    %eax,%ecx
  802e75:	d3 eb                	shr    %cl,%ebx
  802e77:	09 de                	or     %ebx,%esi
  802e79:	89 f0                	mov    %esi,%eax
  802e7b:	f7 74 24 08          	divl   0x8(%esp)
  802e7f:	89 d6                	mov    %edx,%esi
  802e81:	89 c3                	mov    %eax,%ebx
  802e83:	f7 64 24 0c          	mull   0xc(%esp)
  802e87:	39 d6                	cmp    %edx,%esi
  802e89:	72 15                	jb     802ea0 <__udivdi3+0x100>
  802e8b:	89 f9                	mov    %edi,%ecx
  802e8d:	d3 e5                	shl    %cl,%ebp
  802e8f:	39 c5                	cmp    %eax,%ebp
  802e91:	73 04                	jae    802e97 <__udivdi3+0xf7>
  802e93:	39 d6                	cmp    %edx,%esi
  802e95:	74 09                	je     802ea0 <__udivdi3+0x100>
  802e97:	89 d8                	mov    %ebx,%eax
  802e99:	31 ff                	xor    %edi,%edi
  802e9b:	e9 27 ff ff ff       	jmp    802dc7 <__udivdi3+0x27>
  802ea0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802ea3:	31 ff                	xor    %edi,%edi
  802ea5:	e9 1d ff ff ff       	jmp    802dc7 <__udivdi3+0x27>
  802eaa:	66 90                	xchg   %ax,%ax
  802eac:	66 90                	xchg   %ax,%ax
  802eae:	66 90                	xchg   %ax,%ax

00802eb0 <__umoddi3>:
  802eb0:	55                   	push   %ebp
  802eb1:	57                   	push   %edi
  802eb2:	56                   	push   %esi
  802eb3:	53                   	push   %ebx
  802eb4:	83 ec 1c             	sub    $0x1c,%esp
  802eb7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802ebb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802ebf:	8b 74 24 30          	mov    0x30(%esp),%esi
  802ec3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802ec7:	89 da                	mov    %ebx,%edx
  802ec9:	85 c0                	test   %eax,%eax
  802ecb:	75 43                	jne    802f10 <__umoddi3+0x60>
  802ecd:	39 df                	cmp    %ebx,%edi
  802ecf:	76 17                	jbe    802ee8 <__umoddi3+0x38>
  802ed1:	89 f0                	mov    %esi,%eax
  802ed3:	f7 f7                	div    %edi
  802ed5:	89 d0                	mov    %edx,%eax
  802ed7:	31 d2                	xor    %edx,%edx
  802ed9:	83 c4 1c             	add    $0x1c,%esp
  802edc:	5b                   	pop    %ebx
  802edd:	5e                   	pop    %esi
  802ede:	5f                   	pop    %edi
  802edf:	5d                   	pop    %ebp
  802ee0:	c3                   	ret    
  802ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ee8:	89 fd                	mov    %edi,%ebp
  802eea:	85 ff                	test   %edi,%edi
  802eec:	75 0b                	jne    802ef9 <__umoddi3+0x49>
  802eee:	b8 01 00 00 00       	mov    $0x1,%eax
  802ef3:	31 d2                	xor    %edx,%edx
  802ef5:	f7 f7                	div    %edi
  802ef7:	89 c5                	mov    %eax,%ebp
  802ef9:	89 d8                	mov    %ebx,%eax
  802efb:	31 d2                	xor    %edx,%edx
  802efd:	f7 f5                	div    %ebp
  802eff:	89 f0                	mov    %esi,%eax
  802f01:	f7 f5                	div    %ebp
  802f03:	89 d0                	mov    %edx,%eax
  802f05:	eb d0                	jmp    802ed7 <__umoddi3+0x27>
  802f07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802f0e:	66 90                	xchg   %ax,%ax
  802f10:	89 f1                	mov    %esi,%ecx
  802f12:	39 d8                	cmp    %ebx,%eax
  802f14:	76 0a                	jbe    802f20 <__umoddi3+0x70>
  802f16:	89 f0                	mov    %esi,%eax
  802f18:	83 c4 1c             	add    $0x1c,%esp
  802f1b:	5b                   	pop    %ebx
  802f1c:	5e                   	pop    %esi
  802f1d:	5f                   	pop    %edi
  802f1e:	5d                   	pop    %ebp
  802f1f:	c3                   	ret    
  802f20:	0f bd e8             	bsr    %eax,%ebp
  802f23:	83 f5 1f             	xor    $0x1f,%ebp
  802f26:	75 20                	jne    802f48 <__umoddi3+0x98>
  802f28:	39 d8                	cmp    %ebx,%eax
  802f2a:	0f 82 b0 00 00 00    	jb     802fe0 <__umoddi3+0x130>
  802f30:	39 f7                	cmp    %esi,%edi
  802f32:	0f 86 a8 00 00 00    	jbe    802fe0 <__umoddi3+0x130>
  802f38:	89 c8                	mov    %ecx,%eax
  802f3a:	83 c4 1c             	add    $0x1c,%esp
  802f3d:	5b                   	pop    %ebx
  802f3e:	5e                   	pop    %esi
  802f3f:	5f                   	pop    %edi
  802f40:	5d                   	pop    %ebp
  802f41:	c3                   	ret    
  802f42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802f48:	89 e9                	mov    %ebp,%ecx
  802f4a:	ba 20 00 00 00       	mov    $0x20,%edx
  802f4f:	29 ea                	sub    %ebp,%edx
  802f51:	d3 e0                	shl    %cl,%eax
  802f53:	89 44 24 08          	mov    %eax,0x8(%esp)
  802f57:	89 d1                	mov    %edx,%ecx
  802f59:	89 f8                	mov    %edi,%eax
  802f5b:	d3 e8                	shr    %cl,%eax
  802f5d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802f61:	89 54 24 04          	mov    %edx,0x4(%esp)
  802f65:	8b 54 24 04          	mov    0x4(%esp),%edx
  802f69:	09 c1                	or     %eax,%ecx
  802f6b:	89 d8                	mov    %ebx,%eax
  802f6d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802f71:	89 e9                	mov    %ebp,%ecx
  802f73:	d3 e7                	shl    %cl,%edi
  802f75:	89 d1                	mov    %edx,%ecx
  802f77:	d3 e8                	shr    %cl,%eax
  802f79:	89 e9                	mov    %ebp,%ecx
  802f7b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802f7f:	d3 e3                	shl    %cl,%ebx
  802f81:	89 c7                	mov    %eax,%edi
  802f83:	89 d1                	mov    %edx,%ecx
  802f85:	89 f0                	mov    %esi,%eax
  802f87:	d3 e8                	shr    %cl,%eax
  802f89:	89 e9                	mov    %ebp,%ecx
  802f8b:	89 fa                	mov    %edi,%edx
  802f8d:	d3 e6                	shl    %cl,%esi
  802f8f:	09 d8                	or     %ebx,%eax
  802f91:	f7 74 24 08          	divl   0x8(%esp)
  802f95:	89 d1                	mov    %edx,%ecx
  802f97:	89 f3                	mov    %esi,%ebx
  802f99:	f7 64 24 0c          	mull   0xc(%esp)
  802f9d:	89 c6                	mov    %eax,%esi
  802f9f:	89 d7                	mov    %edx,%edi
  802fa1:	39 d1                	cmp    %edx,%ecx
  802fa3:	72 06                	jb     802fab <__umoddi3+0xfb>
  802fa5:	75 10                	jne    802fb7 <__umoddi3+0x107>
  802fa7:	39 c3                	cmp    %eax,%ebx
  802fa9:	73 0c                	jae    802fb7 <__umoddi3+0x107>
  802fab:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802faf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802fb3:	89 d7                	mov    %edx,%edi
  802fb5:	89 c6                	mov    %eax,%esi
  802fb7:	89 ca                	mov    %ecx,%edx
  802fb9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802fbe:	29 f3                	sub    %esi,%ebx
  802fc0:	19 fa                	sbb    %edi,%edx
  802fc2:	89 d0                	mov    %edx,%eax
  802fc4:	d3 e0                	shl    %cl,%eax
  802fc6:	89 e9                	mov    %ebp,%ecx
  802fc8:	d3 eb                	shr    %cl,%ebx
  802fca:	d3 ea                	shr    %cl,%edx
  802fcc:	09 d8                	or     %ebx,%eax
  802fce:	83 c4 1c             	add    $0x1c,%esp
  802fd1:	5b                   	pop    %ebx
  802fd2:	5e                   	pop    %esi
  802fd3:	5f                   	pop    %edi
  802fd4:	5d                   	pop    %ebp
  802fd5:	c3                   	ret    
  802fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802fdd:	8d 76 00             	lea    0x0(%esi),%esi
  802fe0:	89 da                	mov    %ebx,%edx
  802fe2:	29 fe                	sub    %edi,%esi
  802fe4:	19 c2                	sbb    %eax,%edx
  802fe6:	89 f1                	mov    %esi,%ecx
  802fe8:	89 c8                	mov    %ecx,%eax
  802fea:	e9 4b ff ff ff       	jmp    802f3a <__umoddi3+0x8a>
