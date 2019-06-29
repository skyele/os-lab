
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
  80003a:	68 bf 31 80 00       	push   $0x8031bf
  80003f:	e8 4d 09 00 00       	call   800991 <cprintf>
	exit();
  800044:	e8 1e 08 00 00       	call   800867 <exit>
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
  800080:	68 5c 30 80 00       	push   $0x80305c
  800085:	68 00 02 00 00       	push   $0x200
  80008a:	8d bd e8 fd ff ff    	lea    -0x218(%ebp),%edi
  800090:	57                   	push   %edi
  800091:	e8 07 10 00 00       	call   80109d <snprintf>
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
  80009f:	e8 e8 1a 00 00       	call   801b8c <write>
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
  8000db:	e8 e0 19 00 00       	call   801ac0 <read>
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
  8000f2:	e8 3f 11 00 00       	call   801236 <memset>

		req->sock = sock;
  8000f7:	89 75 dc             	mov    %esi,-0x24(%ebp)
	if (strncmp(request, "GET ", 4) != 0)
  8000fa:	83 c4 0c             	add    $0xc,%esp
  8000fd:	6a 04                	push   $0x4
  8000ff:	68 7c 2f 80 00       	push   $0x802f7c
  800104:	8d 85 dc fd ff ff    	lea    -0x224(%ebp),%eax
  80010a:	50                   	push   %eax
  80010b:	e8 b1 10 00 00       	call   8011c1 <strncmp>
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
  80012e:	68 60 2f 80 00       	push   $0x802f60
  800133:	68 23 01 00 00       	push   $0x123
  800138:	68 6f 2f 80 00       	push   $0x802f6f
  80013d:	e8 59 07 00 00       	call   80089b <_panic>
	url_len = request - url;
  800142:	89 df                	mov    %ebx,%edi
  800144:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
  80014a:	29 c7                	sub    %eax,%edi
	req->url = malloc(url_len + 1);
  80014c:	83 ec 0c             	sub    $0xc,%esp
  80014f:	8d 47 01             	lea    0x1(%edi),%eax
  800152:	50                   	push   %eax
  800153:	e8 be 23 00 00       	call   802516 <malloc>
  800158:	89 45 e0             	mov    %eax,-0x20(%ebp)
	memmove(req->url, url, url_len);
  80015b:	83 c4 0c             	add    $0xc,%esp
  80015e:	57                   	push   %edi
  80015f:	8d 8d e0 fd ff ff    	lea    -0x220(%ebp),%ecx
  800165:	51                   	push   %ecx
  800166:	50                   	push   %eax
  800167:	e8 12 11 00 00       	call   80127e <memmove>
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
  800197:	e8 7a 23 00 00       	call   802516 <malloc>
  80019c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	memmove(req->version, version, version_len);
  80019f:	83 c4 0c             	add    $0xc,%esp
  8001a2:	57                   	push   %edi
  8001a3:	53                   	push   %ebx
  8001a4:	50                   	push   %eax
  8001a5:	e8 d4 10 00 00       	call   80127e <memmove>
	req->version[version_len] = '\0';
  8001aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ad:	c6 04 38 00          	movb   $0x0,(%eax,%edi,1)
	fd = open(req->url, O_RDONLY);
  8001b1:	83 c4 08             	add    $0x8,%esp
  8001b4:	6a 00                	push   $0x0
  8001b6:	ff 75 e0             	pushl  -0x20(%ebp)
  8001b9:	e8 a0 1d 00 00       	call   801f5e <open>
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
  8001d2:	e8 df 1a 00 00       	call   801cb6 <fstat>
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
  800221:	e8 5c 17 00 00       	call   801982 <close>
  800226:	83 c4 10             	add    $0x10,%esp
	free(req->url);
  800229:	83 ec 0c             	sub    $0xc,%esp
  80022c:	ff 75 e0             	pushl  -0x20(%ebp)
  80022f:	e8 36 22 00 00       	call   80246a <free>
	free(req->version);
  800234:	83 c4 04             	add    $0x4,%esp
  800237:	ff 75 e4             	pushl  -0x1c(%ebp)
  80023a:	e8 2b 22 00 00       	call   80246a <free>

		// no keep alive
		break;
	}

	close(sock);
  80023f:	89 34 24             	mov    %esi,(%esp)
  800242:	e8 3b 17 00 00       	call   801982 <close>
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
  800264:	e8 4e 0e 00 00       	call   8010b7 <strlen>
	if (write(req->sock, h->header, len) != len) {
  800269:	83 c4 0c             	add    $0xc,%esp
  80026c:	89 85 c4 f6 ff ff    	mov    %eax,-0x93c(%ebp)
  800272:	50                   	push   %eax
  800273:	ff 73 04             	pushl  0x4(%ebx)
  800276:	ff 75 dc             	pushl  -0x24(%ebp)
  800279:	e8 0e 19 00 00       	call   801b8c <write>
  80027e:	83 c4 10             	add    $0x10,%esp
  800281:	39 85 c4 f6 ff ff    	cmp    %eax,-0x93c(%ebp)
  800287:	0f 85 4b 01 00 00    	jne    8003d8 <handle_client+0x318>
	r = snprintf(buf, 64, "Content-Length: %ld\r\n", (long)size);
  80028d:	ff b5 c0 f6 ff ff    	pushl  -0x940(%ebp)
  800293:	68 0e 30 80 00       	push   $0x80300e
  800298:	6a 40                	push   $0x40
  80029a:	8d 85 ee f7 ff ff    	lea    -0x812(%ebp),%eax
  8002a0:	50                   	push   %eax
  8002a1:	e8 f7 0d 00 00       	call   80109d <snprintf>
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
  8002c2:	e8 c5 18 00 00       	call   801b8c <write>
	if ((r = send_size(req, file_size)) < 0)
  8002c7:	83 c4 10             	add    $0x10,%esp
  8002ca:	39 c3                	cmp    %eax,%ebx
  8002cc:	0f 85 4b ff ff ff    	jne    80021d <handle_client+0x15d>
	r = snprintf(buf, 128, "Content-Type: %s\r\n", type);
  8002d2:	68 93 2f 80 00       	push   $0x802f93
  8002d7:	68 9d 2f 80 00       	push   $0x802f9d
  8002dc:	68 80 00 00 00       	push   $0x80
  8002e1:	8d 85 ee f7 ff ff    	lea    -0x812(%ebp),%eax
  8002e7:	50                   	push   %eax
  8002e8:	e8 b0 0d 00 00       	call   80109d <snprintf>
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
  800309:	e8 7e 18 00 00       	call   801b8c <write>
	if ((r = send_content_type(req)) < 0)
  80030e:	83 c4 10             	add    $0x10,%esp
  800311:	39 c3                	cmp    %eax,%ebx
  800313:	0f 85 04 ff ff ff    	jne    80021d <handle_client+0x15d>
	int fin_len = strlen(fin);
  800319:	83 ec 0c             	sub    $0xc,%esp
  80031c:	68 21 30 80 00       	push   $0x803021
  800321:	e8 91 0d 00 00       	call   8010b7 <strlen>
  800326:	89 c3                	mov    %eax,%ebx
	if (write(req->sock, fin, fin_len) != fin_len)
  800328:	83 c4 0c             	add    $0xc,%esp
  80032b:	50                   	push   %eax
  80032c:	68 21 30 80 00       	push   $0x803021
  800331:	ff 75 dc             	pushl  -0x24(%ebp)
  800334:	e8 53 18 00 00       	call   801b8c <write>
	if ((r = send_header_fin(req)) < 0)
  800339:	83 c4 10             	add    $0x10,%esp
  80033c:	39 c3                	cmp    %eax,%ebx
  80033e:	0f 85 d9 fe ff ff    	jne    80021d <handle_client+0x15d>
  	if ((r = fstat(fd, &stat)) < 0)
  800344:	83 ec 08             	sub    $0x8,%esp
  800347:	8d 85 60 f7 ff ff    	lea    -0x8a0(%ebp),%eax
  80034d:	50                   	push   %eax
  80034e:	57                   	push   %edi
  80034f:	e8 62 19 00 00       	call   801cb6 <fstat>
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
  800380:	e8 c2 17 00 00       	call   801b47 <readn>
  800385:	83 c4 10             	add    $0x10,%esp
  800388:	3b 85 e0 f7 ff ff    	cmp    -0x820(%ebp),%eax
  80038e:	0f 85 9c 00 00 00    	jne    800430 <handle_client+0x370>
	cprintf("the data is %s\n", buf);
  800394:	83 ec 08             	sub    $0x8,%esp
  800397:	8d 9d ee f7 ff ff    	lea    -0x812(%ebp),%ebx
  80039d:	53                   	push   %ebx
  80039e:	68 eb 2f 80 00       	push   $0x802feb
  8003a3:	e8 e9 05 00 00       	call   800991 <cprintf>
  	if ((r = write(req->sock, buf, stat.st_size)) != stat.st_size)
  8003a8:	83 c4 0c             	add    $0xc,%esp
  8003ab:	ff b5 e0 f7 ff ff    	pushl  -0x820(%ebp)
  8003b1:	53                   	push   %ebx
  8003b2:	ff 75 dc             	pushl  -0x24(%ebp)
  8003b5:	e8 d2 17 00 00       	call   801b8c <write>
  8003ba:	83 c4 10             	add    $0x10,%esp
  8003bd:	3b 85 e0 f7 ff ff    	cmp    -0x820(%ebp),%eax
  8003c3:	0f 84 54 fe ff ff    	je     80021d <handle_client+0x15d>
    	die("not write all data");
  8003c9:	b8 fb 2f 80 00       	mov    $0x802ffb,%eax
  8003ce:	e8 60 fc ff ff       	call   800033 <die>
  8003d3:	e9 45 fe ff ff       	jmp    80021d <handle_client+0x15d>
		die("Failed to send bytes to client");
  8003d8:	b8 d8 30 80 00       	mov    $0x8030d8,%eax
  8003dd:	e8 51 fc ff ff       	call   800033 <die>
  8003e2:	e9 a6 fe ff ff       	jmp    80028d <handle_client+0x1cd>
		panic("buffer too small!");
  8003e7:	83 ec 04             	sub    $0x4,%esp
  8003ea:	68 81 2f 80 00       	push   $0x802f81
  8003ef:	6a 68                	push   $0x68
  8003f1:	68 6f 2f 80 00       	push   $0x802f6f
  8003f6:	e8 a0 04 00 00       	call   80089b <_panic>
		panic("buffer too small!");
  8003fb:	83 ec 04             	sub    $0x4,%esp
  8003fe:	68 81 2f 80 00       	push   $0x802f81
  800403:	68 84 00 00 00       	push   $0x84
  800408:	68 6f 2f 80 00       	push   $0x802f6f
  80040d:	e8 89 04 00 00       	call   80089b <_panic>
  		die("fstat panic");
  800412:	b8 b0 2f 80 00       	mov    $0x802fb0,%eax
  800417:	e8 17 fc ff ff       	call   800033 <die>
  80041c:	e9 3e ff ff ff       	jmp    80035f <handle_client+0x29f>
    	die("fd's file size > 1518");
  800421:	b8 bc 2f 80 00       	mov    $0x802fbc,%eax
  800426:	e8 08 fc ff ff       	call   800033 <die>
  80042b:	e9 3f ff ff ff       	jmp    80036f <handle_client+0x2af>
    	die("just read partitial data");
  800430:	b8 d2 2f 80 00       	mov    $0x802fd2,%eax
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
  80045a:	c7 05 20 40 80 00 24 	movl   $0x803024,0x804020
  800461:	30 80 00 

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  800464:	6a 06                	push   $0x6
  800466:	6a 01                	push   $0x1
  800468:	6a 02                	push   $0x2
  80046a:	e8 7f 1d 00 00       	call   8021ee <socket>
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
  800483:	e8 ae 0d 00 00       	call   801236 <memset>
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
  8004b2:	e8 a5 1c 00 00       	call   80215c <bind>
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
  8004c4:	e8 02 1d 00 00       	call   8021cb <listen>
  8004c9:	83 c4 10             	add    $0x10,%esp
  8004cc:	85 c0                	test   %eax,%eax
  8004ce:	78 2d                	js     8004fd <umain+0xac>
		die("Failed to listen on server socket");

	cprintf("Waiting for http connections...\n");
  8004d0:	83 ec 0c             	sub    $0xc,%esp
  8004d3:	68 40 31 80 00       	push   $0x803140
  8004d8:	e8 b4 04 00 00       	call   800991 <cprintf>
  8004dd:	83 c4 10             	add    $0x10,%esp

	while (1) {
		unsigned int clientlen = sizeof(client);
		// Wait for client connection
		if ((clientsock = accept(serversock,
  8004e0:	8d 7d c4             	lea    -0x3c(%ebp),%edi
  8004e3:	eb 35                	jmp    80051a <umain+0xc9>
		die("Failed to create socket");
  8004e5:	b8 2b 30 80 00       	mov    $0x80302b,%eax
  8004ea:	e8 44 fb ff ff       	call   800033 <die>
  8004ef:	eb 87                	jmp    800478 <umain+0x27>
		die("Failed to bind the server socket");
  8004f1:	b8 f8 30 80 00       	mov    $0x8030f8,%eax
  8004f6:	e8 38 fb ff ff       	call   800033 <die>
  8004fb:	eb c1                	jmp    8004be <umain+0x6d>
		die("Failed to listen on server socket");
  8004fd:	b8 1c 31 80 00       	mov    $0x80311c,%eax
  800502:	e8 2c fb ff ff       	call   800033 <die>
  800507:	eb c7                	jmp    8004d0 <umain+0x7f>
					 (struct sockaddr *) &client,
					 &clientlen)) < 0)
		{
			die("Failed to accept client connection");
  800509:	b8 64 31 80 00       	mov    $0x803164,%eax
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
  80052a:	e8 fe 1b 00 00       	call   80212d <accept>
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
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80081e:	55                   	push   %ebp
  80081f:	89 e5                	mov    %esp,%ebp
  800821:	56                   	push   %esi
  800822:	53                   	push   %ebx
  800823:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800826:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  800829:	e8 76 0c 00 00       	call   8014a4 <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  80082e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800833:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800839:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80083e:	a3 1c 50 80 00       	mov    %eax,0x80501c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800843:	85 db                	test   %ebx,%ebx
  800845:	7e 07                	jle    80084e <libmain+0x30>
		binaryname = argv[0];
  800847:	8b 06                	mov    (%esi),%eax
  800849:	a3 20 40 80 00       	mov    %eax,0x804020

	// call user main routine
	umain(argc, argv);
  80084e:	83 ec 08             	sub    $0x8,%esp
  800851:	56                   	push   %esi
  800852:	53                   	push   %ebx
  800853:	e8 f9 fb ff ff       	call   800451 <umain>

	// exit gracefully
	exit();
  800858:	e8 0a 00 00 00       	call   800867 <exit>
}
  80085d:	83 c4 10             	add    $0x10,%esp
  800860:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800863:	5b                   	pop    %ebx
  800864:	5e                   	pop    %esi
  800865:	5d                   	pop    %ebp
  800866:	c3                   	ret    

00800867 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800867:	55                   	push   %ebp
  800868:	89 e5                	mov    %esp,%ebp
  80086a:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80086d:	a1 1c 50 80 00       	mov    0x80501c,%eax
  800872:	8b 40 48             	mov    0x48(%eax),%eax
  800875:	68 c4 31 80 00       	push   $0x8031c4
  80087a:	50                   	push   %eax
  80087b:	68 b8 31 80 00       	push   $0x8031b8
  800880:	e8 0c 01 00 00       	call   800991 <cprintf>
	close_all();
  800885:	e8 25 11 00 00       	call   8019af <close_all>
	sys_env_destroy(0);
  80088a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800891:	e8 cd 0b 00 00       	call   801463 <sys_env_destroy>
}
  800896:	83 c4 10             	add    $0x10,%esp
  800899:	c9                   	leave  
  80089a:	c3                   	ret    

0080089b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80089b:	55                   	push   %ebp
  80089c:	89 e5                	mov    %esp,%ebp
  80089e:	56                   	push   %esi
  80089f:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8008a0:	a1 1c 50 80 00       	mov    0x80501c,%eax
  8008a5:	8b 40 48             	mov    0x48(%eax),%eax
  8008a8:	83 ec 04             	sub    $0x4,%esp
  8008ab:	68 f0 31 80 00       	push   $0x8031f0
  8008b0:	50                   	push   %eax
  8008b1:	68 b8 31 80 00       	push   $0x8031b8
  8008b6:	e8 d6 00 00 00       	call   800991 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8008bb:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8008be:	8b 35 20 40 80 00    	mov    0x804020,%esi
  8008c4:	e8 db 0b 00 00       	call   8014a4 <sys_getenvid>
  8008c9:	83 c4 04             	add    $0x4,%esp
  8008cc:	ff 75 0c             	pushl  0xc(%ebp)
  8008cf:	ff 75 08             	pushl  0x8(%ebp)
  8008d2:	56                   	push   %esi
  8008d3:	50                   	push   %eax
  8008d4:	68 cc 31 80 00       	push   $0x8031cc
  8008d9:	e8 b3 00 00 00       	call   800991 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8008de:	83 c4 18             	add    $0x18,%esp
  8008e1:	53                   	push   %ebx
  8008e2:	ff 75 10             	pushl  0x10(%ebp)
  8008e5:	e8 56 00 00 00       	call   800940 <vcprintf>
	cprintf("\n");
  8008ea:	c7 04 24 22 30 80 00 	movl   $0x803022,(%esp)
  8008f1:	e8 9b 00 00 00       	call   800991 <cprintf>
  8008f6:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8008f9:	cc                   	int3   
  8008fa:	eb fd                	jmp    8008f9 <_panic+0x5e>

008008fc <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
  8008ff:	53                   	push   %ebx
  800900:	83 ec 04             	sub    $0x4,%esp
  800903:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800906:	8b 13                	mov    (%ebx),%edx
  800908:	8d 42 01             	lea    0x1(%edx),%eax
  80090b:	89 03                	mov    %eax,(%ebx)
  80090d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800910:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800914:	3d ff 00 00 00       	cmp    $0xff,%eax
  800919:	74 09                	je     800924 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80091b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80091f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800922:	c9                   	leave  
  800923:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800924:	83 ec 08             	sub    $0x8,%esp
  800927:	68 ff 00 00 00       	push   $0xff
  80092c:	8d 43 08             	lea    0x8(%ebx),%eax
  80092f:	50                   	push   %eax
  800930:	e8 f1 0a 00 00       	call   801426 <sys_cputs>
		b->idx = 0;
  800935:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80093b:	83 c4 10             	add    $0x10,%esp
  80093e:	eb db                	jmp    80091b <putch+0x1f>

00800940 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800940:	55                   	push   %ebp
  800941:	89 e5                	mov    %esp,%ebp
  800943:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800949:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800950:	00 00 00 
	b.cnt = 0;
  800953:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80095a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80095d:	ff 75 0c             	pushl  0xc(%ebp)
  800960:	ff 75 08             	pushl  0x8(%ebp)
  800963:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800969:	50                   	push   %eax
  80096a:	68 fc 08 80 00       	push   $0x8008fc
  80096f:	e8 4a 01 00 00       	call   800abe <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800974:	83 c4 08             	add    $0x8,%esp
  800977:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80097d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800983:	50                   	push   %eax
  800984:	e8 9d 0a 00 00       	call   801426 <sys_cputs>

	return b.cnt;
}
  800989:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80098f:	c9                   	leave  
  800990:	c3                   	ret    

00800991 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800991:	55                   	push   %ebp
  800992:	89 e5                	mov    %esp,%ebp
  800994:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800997:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80099a:	50                   	push   %eax
  80099b:	ff 75 08             	pushl  0x8(%ebp)
  80099e:	e8 9d ff ff ff       	call   800940 <vcprintf>
	va_end(ap);

	return cnt;
}
  8009a3:	c9                   	leave  
  8009a4:	c3                   	ret    

008009a5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009a5:	55                   	push   %ebp
  8009a6:	89 e5                	mov    %esp,%ebp
  8009a8:	57                   	push   %edi
  8009a9:	56                   	push   %esi
  8009aa:	53                   	push   %ebx
  8009ab:	83 ec 1c             	sub    $0x1c,%esp
  8009ae:	89 c6                	mov    %eax,%esi
  8009b0:	89 d7                	mov    %edx,%edi
  8009b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8009bb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8009be:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c1:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8009c4:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8009c8:	74 2c                	je     8009f6 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8009ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009cd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8009d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009d7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8009da:	39 c2                	cmp    %eax,%edx
  8009dc:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8009df:	73 43                	jae    800a24 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8009e1:	83 eb 01             	sub    $0x1,%ebx
  8009e4:	85 db                	test   %ebx,%ebx
  8009e6:	7e 6c                	jle    800a54 <printnum+0xaf>
				putch(padc, putdat);
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	57                   	push   %edi
  8009ec:	ff 75 18             	pushl  0x18(%ebp)
  8009ef:	ff d6                	call   *%esi
  8009f1:	83 c4 10             	add    $0x10,%esp
  8009f4:	eb eb                	jmp    8009e1 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8009f6:	83 ec 0c             	sub    $0xc,%esp
  8009f9:	6a 20                	push   $0x20
  8009fb:	6a 00                	push   $0x0
  8009fd:	50                   	push   %eax
  8009fe:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a01:	ff 75 e0             	pushl  -0x20(%ebp)
  800a04:	89 fa                	mov    %edi,%edx
  800a06:	89 f0                	mov    %esi,%eax
  800a08:	e8 98 ff ff ff       	call   8009a5 <printnum>
		while (--width > 0)
  800a0d:	83 c4 20             	add    $0x20,%esp
  800a10:	83 eb 01             	sub    $0x1,%ebx
  800a13:	85 db                	test   %ebx,%ebx
  800a15:	7e 65                	jle    800a7c <printnum+0xd7>
			putch(padc, putdat);
  800a17:	83 ec 08             	sub    $0x8,%esp
  800a1a:	57                   	push   %edi
  800a1b:	6a 20                	push   $0x20
  800a1d:	ff d6                	call   *%esi
  800a1f:	83 c4 10             	add    $0x10,%esp
  800a22:	eb ec                	jmp    800a10 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800a24:	83 ec 0c             	sub    $0xc,%esp
  800a27:	ff 75 18             	pushl  0x18(%ebp)
  800a2a:	83 eb 01             	sub    $0x1,%ebx
  800a2d:	53                   	push   %ebx
  800a2e:	50                   	push   %eax
  800a2f:	83 ec 08             	sub    $0x8,%esp
  800a32:	ff 75 dc             	pushl  -0x24(%ebp)
  800a35:	ff 75 d8             	pushl  -0x28(%ebp)
  800a38:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a3b:	ff 75 e0             	pushl  -0x20(%ebp)
  800a3e:	e8 cd 22 00 00       	call   802d10 <__udivdi3>
  800a43:	83 c4 18             	add    $0x18,%esp
  800a46:	52                   	push   %edx
  800a47:	50                   	push   %eax
  800a48:	89 fa                	mov    %edi,%edx
  800a4a:	89 f0                	mov    %esi,%eax
  800a4c:	e8 54 ff ff ff       	call   8009a5 <printnum>
  800a51:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800a54:	83 ec 08             	sub    $0x8,%esp
  800a57:	57                   	push   %edi
  800a58:	83 ec 04             	sub    $0x4,%esp
  800a5b:	ff 75 dc             	pushl  -0x24(%ebp)
  800a5e:	ff 75 d8             	pushl  -0x28(%ebp)
  800a61:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a64:	ff 75 e0             	pushl  -0x20(%ebp)
  800a67:	e8 b4 23 00 00       	call   802e20 <__umoddi3>
  800a6c:	83 c4 14             	add    $0x14,%esp
  800a6f:	0f be 80 f7 31 80 00 	movsbl 0x8031f7(%eax),%eax
  800a76:	50                   	push   %eax
  800a77:	ff d6                	call   *%esi
  800a79:	83 c4 10             	add    $0x10,%esp
	}
}
  800a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a7f:	5b                   	pop    %ebx
  800a80:	5e                   	pop    %esi
  800a81:	5f                   	pop    %edi
  800a82:	5d                   	pop    %ebp
  800a83:	c3                   	ret    

00800a84 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a84:	55                   	push   %ebp
  800a85:	89 e5                	mov    %esp,%ebp
  800a87:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800a8a:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800a8e:	8b 10                	mov    (%eax),%edx
  800a90:	3b 50 04             	cmp    0x4(%eax),%edx
  800a93:	73 0a                	jae    800a9f <sprintputch+0x1b>
		*b->buf++ = ch;
  800a95:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a98:	89 08                	mov    %ecx,(%eax)
  800a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9d:	88 02                	mov    %al,(%edx)
}
  800a9f:	5d                   	pop    %ebp
  800aa0:	c3                   	ret    

00800aa1 <printfmt>:
{
  800aa1:	55                   	push   %ebp
  800aa2:	89 e5                	mov    %esp,%ebp
  800aa4:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800aa7:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800aaa:	50                   	push   %eax
  800aab:	ff 75 10             	pushl  0x10(%ebp)
  800aae:	ff 75 0c             	pushl  0xc(%ebp)
  800ab1:	ff 75 08             	pushl  0x8(%ebp)
  800ab4:	e8 05 00 00 00       	call   800abe <vprintfmt>
}
  800ab9:	83 c4 10             	add    $0x10,%esp
  800abc:	c9                   	leave  
  800abd:	c3                   	ret    

00800abe <vprintfmt>:
{
  800abe:	55                   	push   %ebp
  800abf:	89 e5                	mov    %esp,%ebp
  800ac1:	57                   	push   %edi
  800ac2:	56                   	push   %esi
  800ac3:	53                   	push   %ebx
  800ac4:	83 ec 3c             	sub    $0x3c,%esp
  800ac7:	8b 75 08             	mov    0x8(%ebp),%esi
  800aca:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800acd:	8b 7d 10             	mov    0x10(%ebp),%edi
  800ad0:	e9 32 04 00 00       	jmp    800f07 <vprintfmt+0x449>
		padc = ' ';
  800ad5:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800ad9:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800ae0:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800ae7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800aee:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800af5:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800afc:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800b01:	8d 47 01             	lea    0x1(%edi),%eax
  800b04:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b07:	0f b6 17             	movzbl (%edi),%edx
  800b0a:	8d 42 dd             	lea    -0x23(%edx),%eax
  800b0d:	3c 55                	cmp    $0x55,%al
  800b0f:	0f 87 12 05 00 00    	ja     801027 <vprintfmt+0x569>
  800b15:	0f b6 c0             	movzbl %al,%eax
  800b18:	ff 24 85 e0 33 80 00 	jmp    *0x8033e0(,%eax,4)
  800b1f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800b22:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800b26:	eb d9                	jmp    800b01 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800b28:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800b2b:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800b2f:	eb d0                	jmp    800b01 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800b31:	0f b6 d2             	movzbl %dl,%edx
  800b34:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800b37:	b8 00 00 00 00       	mov    $0x0,%eax
  800b3c:	89 75 08             	mov    %esi,0x8(%ebp)
  800b3f:	eb 03                	jmp    800b44 <vprintfmt+0x86>
  800b41:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800b44:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800b47:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800b4b:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800b4e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b51:	83 fe 09             	cmp    $0x9,%esi
  800b54:	76 eb                	jbe    800b41 <vprintfmt+0x83>
  800b56:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b59:	8b 75 08             	mov    0x8(%ebp),%esi
  800b5c:	eb 14                	jmp    800b72 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800b5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b61:	8b 00                	mov    (%eax),%eax
  800b63:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b66:	8b 45 14             	mov    0x14(%ebp),%eax
  800b69:	8d 40 04             	lea    0x4(%eax),%eax
  800b6c:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800b6f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800b72:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b76:	79 89                	jns    800b01 <vprintfmt+0x43>
				width = precision, precision = -1;
  800b78:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b7b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b7e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800b85:	e9 77 ff ff ff       	jmp    800b01 <vprintfmt+0x43>
  800b8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b8d:	85 c0                	test   %eax,%eax
  800b8f:	0f 48 c1             	cmovs  %ecx,%eax
  800b92:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800b95:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800b98:	e9 64 ff ff ff       	jmp    800b01 <vprintfmt+0x43>
  800b9d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800ba0:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800ba7:	e9 55 ff ff ff       	jmp    800b01 <vprintfmt+0x43>
			lflag++;
  800bac:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800bb0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800bb3:	e9 49 ff ff ff       	jmp    800b01 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800bb8:	8b 45 14             	mov    0x14(%ebp),%eax
  800bbb:	8d 78 04             	lea    0x4(%eax),%edi
  800bbe:	83 ec 08             	sub    $0x8,%esp
  800bc1:	53                   	push   %ebx
  800bc2:	ff 30                	pushl  (%eax)
  800bc4:	ff d6                	call   *%esi
			break;
  800bc6:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800bc9:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800bcc:	e9 33 03 00 00       	jmp    800f04 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800bd1:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd4:	8d 78 04             	lea    0x4(%eax),%edi
  800bd7:	8b 00                	mov    (%eax),%eax
  800bd9:	99                   	cltd   
  800bda:	31 d0                	xor    %edx,%eax
  800bdc:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800bde:	83 f8 11             	cmp    $0x11,%eax
  800be1:	7f 23                	jg     800c06 <vprintfmt+0x148>
  800be3:	8b 14 85 40 35 80 00 	mov    0x803540(,%eax,4),%edx
  800bea:	85 d2                	test   %edx,%edx
  800bec:	74 18                	je     800c06 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800bee:	52                   	push   %edx
  800bef:	68 5d 36 80 00       	push   $0x80365d
  800bf4:	53                   	push   %ebx
  800bf5:	56                   	push   %esi
  800bf6:	e8 a6 fe ff ff       	call   800aa1 <printfmt>
  800bfb:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800bfe:	89 7d 14             	mov    %edi,0x14(%ebp)
  800c01:	e9 fe 02 00 00       	jmp    800f04 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800c06:	50                   	push   %eax
  800c07:	68 0f 32 80 00       	push   $0x80320f
  800c0c:	53                   	push   %ebx
  800c0d:	56                   	push   %esi
  800c0e:	e8 8e fe ff ff       	call   800aa1 <printfmt>
  800c13:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800c16:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800c19:	e9 e6 02 00 00       	jmp    800f04 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800c1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c21:	83 c0 04             	add    $0x4,%eax
  800c24:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800c27:	8b 45 14             	mov    0x14(%ebp),%eax
  800c2a:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800c2c:	85 c9                	test   %ecx,%ecx
  800c2e:	b8 08 32 80 00       	mov    $0x803208,%eax
  800c33:	0f 45 c1             	cmovne %ecx,%eax
  800c36:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800c39:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c3d:	7e 06                	jle    800c45 <vprintfmt+0x187>
  800c3f:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800c43:	75 0d                	jne    800c52 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c45:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800c48:	89 c7                	mov    %eax,%edi
  800c4a:	03 45 e0             	add    -0x20(%ebp),%eax
  800c4d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800c50:	eb 53                	jmp    800ca5 <vprintfmt+0x1e7>
  800c52:	83 ec 08             	sub    $0x8,%esp
  800c55:	ff 75 d8             	pushl  -0x28(%ebp)
  800c58:	50                   	push   %eax
  800c59:	e8 71 04 00 00       	call   8010cf <strnlen>
  800c5e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800c61:	29 c1                	sub    %eax,%ecx
  800c63:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800c66:	83 c4 10             	add    $0x10,%esp
  800c69:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800c6b:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800c6f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800c72:	eb 0f                	jmp    800c83 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800c74:	83 ec 08             	sub    $0x8,%esp
  800c77:	53                   	push   %ebx
  800c78:	ff 75 e0             	pushl  -0x20(%ebp)
  800c7b:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800c7d:	83 ef 01             	sub    $0x1,%edi
  800c80:	83 c4 10             	add    $0x10,%esp
  800c83:	85 ff                	test   %edi,%edi
  800c85:	7f ed                	jg     800c74 <vprintfmt+0x1b6>
  800c87:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800c8a:	85 c9                	test   %ecx,%ecx
  800c8c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c91:	0f 49 c1             	cmovns %ecx,%eax
  800c94:	29 c1                	sub    %eax,%ecx
  800c96:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800c99:	eb aa                	jmp    800c45 <vprintfmt+0x187>
					putch(ch, putdat);
  800c9b:	83 ec 08             	sub    $0x8,%esp
  800c9e:	53                   	push   %ebx
  800c9f:	52                   	push   %edx
  800ca0:	ff d6                	call   *%esi
  800ca2:	83 c4 10             	add    $0x10,%esp
  800ca5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800ca8:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800caa:	83 c7 01             	add    $0x1,%edi
  800cad:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800cb1:	0f be d0             	movsbl %al,%edx
  800cb4:	85 d2                	test   %edx,%edx
  800cb6:	74 4b                	je     800d03 <vprintfmt+0x245>
  800cb8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800cbc:	78 06                	js     800cc4 <vprintfmt+0x206>
  800cbe:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800cc2:	78 1e                	js     800ce2 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800cc4:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800cc8:	74 d1                	je     800c9b <vprintfmt+0x1dd>
  800cca:	0f be c0             	movsbl %al,%eax
  800ccd:	83 e8 20             	sub    $0x20,%eax
  800cd0:	83 f8 5e             	cmp    $0x5e,%eax
  800cd3:	76 c6                	jbe    800c9b <vprintfmt+0x1dd>
					putch('?', putdat);
  800cd5:	83 ec 08             	sub    $0x8,%esp
  800cd8:	53                   	push   %ebx
  800cd9:	6a 3f                	push   $0x3f
  800cdb:	ff d6                	call   *%esi
  800cdd:	83 c4 10             	add    $0x10,%esp
  800ce0:	eb c3                	jmp    800ca5 <vprintfmt+0x1e7>
  800ce2:	89 cf                	mov    %ecx,%edi
  800ce4:	eb 0e                	jmp    800cf4 <vprintfmt+0x236>
				putch(' ', putdat);
  800ce6:	83 ec 08             	sub    $0x8,%esp
  800ce9:	53                   	push   %ebx
  800cea:	6a 20                	push   $0x20
  800cec:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800cee:	83 ef 01             	sub    $0x1,%edi
  800cf1:	83 c4 10             	add    $0x10,%esp
  800cf4:	85 ff                	test   %edi,%edi
  800cf6:	7f ee                	jg     800ce6 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800cf8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800cfb:	89 45 14             	mov    %eax,0x14(%ebp)
  800cfe:	e9 01 02 00 00       	jmp    800f04 <vprintfmt+0x446>
  800d03:	89 cf                	mov    %ecx,%edi
  800d05:	eb ed                	jmp    800cf4 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800d07:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800d0a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800d11:	e9 eb fd ff ff       	jmp    800b01 <vprintfmt+0x43>
	if (lflag >= 2)
  800d16:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800d1a:	7f 21                	jg     800d3d <vprintfmt+0x27f>
	else if (lflag)
  800d1c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800d20:	74 68                	je     800d8a <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800d22:	8b 45 14             	mov    0x14(%ebp),%eax
  800d25:	8b 00                	mov    (%eax),%eax
  800d27:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800d2a:	89 c1                	mov    %eax,%ecx
  800d2c:	c1 f9 1f             	sar    $0x1f,%ecx
  800d2f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800d32:	8b 45 14             	mov    0x14(%ebp),%eax
  800d35:	8d 40 04             	lea    0x4(%eax),%eax
  800d38:	89 45 14             	mov    %eax,0x14(%ebp)
  800d3b:	eb 17                	jmp    800d54 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800d3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d40:	8b 50 04             	mov    0x4(%eax),%edx
  800d43:	8b 00                	mov    (%eax),%eax
  800d45:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800d48:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800d4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d4e:	8d 40 08             	lea    0x8(%eax),%eax
  800d51:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800d54:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d57:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800d5a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d5d:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800d60:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800d64:	78 3f                	js     800da5 <vprintfmt+0x2e7>
			base = 10;
  800d66:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800d6b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800d6f:	0f 84 71 01 00 00    	je     800ee6 <vprintfmt+0x428>
				putch('+', putdat);
  800d75:	83 ec 08             	sub    $0x8,%esp
  800d78:	53                   	push   %ebx
  800d79:	6a 2b                	push   $0x2b
  800d7b:	ff d6                	call   *%esi
  800d7d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800d80:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d85:	e9 5c 01 00 00       	jmp    800ee6 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800d8a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d8d:	8b 00                	mov    (%eax),%eax
  800d8f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800d92:	89 c1                	mov    %eax,%ecx
  800d94:	c1 f9 1f             	sar    $0x1f,%ecx
  800d97:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800d9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d9d:	8d 40 04             	lea    0x4(%eax),%eax
  800da0:	89 45 14             	mov    %eax,0x14(%ebp)
  800da3:	eb af                	jmp    800d54 <vprintfmt+0x296>
				putch('-', putdat);
  800da5:	83 ec 08             	sub    $0x8,%esp
  800da8:	53                   	push   %ebx
  800da9:	6a 2d                	push   $0x2d
  800dab:	ff d6                	call   *%esi
				num = -(long long) num;
  800dad:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800db0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800db3:	f7 d8                	neg    %eax
  800db5:	83 d2 00             	adc    $0x0,%edx
  800db8:	f7 da                	neg    %edx
  800dba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800dbd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800dc0:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800dc3:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dc8:	e9 19 01 00 00       	jmp    800ee6 <vprintfmt+0x428>
	if (lflag >= 2)
  800dcd:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800dd1:	7f 29                	jg     800dfc <vprintfmt+0x33e>
	else if (lflag)
  800dd3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800dd7:	74 44                	je     800e1d <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800dd9:	8b 45 14             	mov    0x14(%ebp),%eax
  800ddc:	8b 00                	mov    (%eax),%eax
  800dde:	ba 00 00 00 00       	mov    $0x0,%edx
  800de3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800de6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800de9:	8b 45 14             	mov    0x14(%ebp),%eax
  800dec:	8d 40 04             	lea    0x4(%eax),%eax
  800def:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800df2:	b8 0a 00 00 00       	mov    $0xa,%eax
  800df7:	e9 ea 00 00 00       	jmp    800ee6 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800dfc:	8b 45 14             	mov    0x14(%ebp),%eax
  800dff:	8b 50 04             	mov    0x4(%eax),%edx
  800e02:	8b 00                	mov    (%eax),%eax
  800e04:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e07:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800e0a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e0d:	8d 40 08             	lea    0x8(%eax),%eax
  800e10:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800e13:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e18:	e9 c9 00 00 00       	jmp    800ee6 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800e1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e20:	8b 00                	mov    (%eax),%eax
  800e22:	ba 00 00 00 00       	mov    $0x0,%edx
  800e27:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e2a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800e2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e30:	8d 40 04             	lea    0x4(%eax),%eax
  800e33:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800e36:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e3b:	e9 a6 00 00 00       	jmp    800ee6 <vprintfmt+0x428>
			putch('0', putdat);
  800e40:	83 ec 08             	sub    $0x8,%esp
  800e43:	53                   	push   %ebx
  800e44:	6a 30                	push   $0x30
  800e46:	ff d6                	call   *%esi
	if (lflag >= 2)
  800e48:	83 c4 10             	add    $0x10,%esp
  800e4b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800e4f:	7f 26                	jg     800e77 <vprintfmt+0x3b9>
	else if (lflag)
  800e51:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800e55:	74 3e                	je     800e95 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800e57:	8b 45 14             	mov    0x14(%ebp),%eax
  800e5a:	8b 00                	mov    (%eax),%eax
  800e5c:	ba 00 00 00 00       	mov    $0x0,%edx
  800e61:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e64:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800e67:	8b 45 14             	mov    0x14(%ebp),%eax
  800e6a:	8d 40 04             	lea    0x4(%eax),%eax
  800e6d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800e70:	b8 08 00 00 00       	mov    $0x8,%eax
  800e75:	eb 6f                	jmp    800ee6 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800e77:	8b 45 14             	mov    0x14(%ebp),%eax
  800e7a:	8b 50 04             	mov    0x4(%eax),%edx
  800e7d:	8b 00                	mov    (%eax),%eax
  800e7f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e82:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800e85:	8b 45 14             	mov    0x14(%ebp),%eax
  800e88:	8d 40 08             	lea    0x8(%eax),%eax
  800e8b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800e8e:	b8 08 00 00 00       	mov    $0x8,%eax
  800e93:	eb 51                	jmp    800ee6 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800e95:	8b 45 14             	mov    0x14(%ebp),%eax
  800e98:	8b 00                	mov    (%eax),%eax
  800e9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800e9f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ea2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ea5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea8:	8d 40 04             	lea    0x4(%eax),%eax
  800eab:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800eae:	b8 08 00 00 00       	mov    $0x8,%eax
  800eb3:	eb 31                	jmp    800ee6 <vprintfmt+0x428>
			putch('0', putdat);
  800eb5:	83 ec 08             	sub    $0x8,%esp
  800eb8:	53                   	push   %ebx
  800eb9:	6a 30                	push   $0x30
  800ebb:	ff d6                	call   *%esi
			putch('x', putdat);
  800ebd:	83 c4 08             	add    $0x8,%esp
  800ec0:	53                   	push   %ebx
  800ec1:	6a 78                	push   $0x78
  800ec3:	ff d6                	call   *%esi
			num = (unsigned long long)
  800ec5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec8:	8b 00                	mov    (%eax),%eax
  800eca:	ba 00 00 00 00       	mov    $0x0,%edx
  800ecf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ed2:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800ed5:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800ed8:	8b 45 14             	mov    0x14(%ebp),%eax
  800edb:	8d 40 04             	lea    0x4(%eax),%eax
  800ede:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ee1:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800ee6:	83 ec 0c             	sub    $0xc,%esp
  800ee9:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800eed:	52                   	push   %edx
  800eee:	ff 75 e0             	pushl  -0x20(%ebp)
  800ef1:	50                   	push   %eax
  800ef2:	ff 75 dc             	pushl  -0x24(%ebp)
  800ef5:	ff 75 d8             	pushl  -0x28(%ebp)
  800ef8:	89 da                	mov    %ebx,%edx
  800efa:	89 f0                	mov    %esi,%eax
  800efc:	e8 a4 fa ff ff       	call   8009a5 <printnum>
			break;
  800f01:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800f04:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f07:	83 c7 01             	add    $0x1,%edi
  800f0a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800f0e:	83 f8 25             	cmp    $0x25,%eax
  800f11:	0f 84 be fb ff ff    	je     800ad5 <vprintfmt+0x17>
			if (ch == '\0')
  800f17:	85 c0                	test   %eax,%eax
  800f19:	0f 84 28 01 00 00    	je     801047 <vprintfmt+0x589>
			putch(ch, putdat);
  800f1f:	83 ec 08             	sub    $0x8,%esp
  800f22:	53                   	push   %ebx
  800f23:	50                   	push   %eax
  800f24:	ff d6                	call   *%esi
  800f26:	83 c4 10             	add    $0x10,%esp
  800f29:	eb dc                	jmp    800f07 <vprintfmt+0x449>
	if (lflag >= 2)
  800f2b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800f2f:	7f 26                	jg     800f57 <vprintfmt+0x499>
	else if (lflag)
  800f31:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800f35:	74 41                	je     800f78 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800f37:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3a:	8b 00                	mov    (%eax),%eax
  800f3c:	ba 00 00 00 00       	mov    $0x0,%edx
  800f41:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f44:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f47:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4a:	8d 40 04             	lea    0x4(%eax),%eax
  800f4d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800f50:	b8 10 00 00 00       	mov    $0x10,%eax
  800f55:	eb 8f                	jmp    800ee6 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800f57:	8b 45 14             	mov    0x14(%ebp),%eax
  800f5a:	8b 50 04             	mov    0x4(%eax),%edx
  800f5d:	8b 00                	mov    (%eax),%eax
  800f5f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f62:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f65:	8b 45 14             	mov    0x14(%ebp),%eax
  800f68:	8d 40 08             	lea    0x8(%eax),%eax
  800f6b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800f6e:	b8 10 00 00 00       	mov    $0x10,%eax
  800f73:	e9 6e ff ff ff       	jmp    800ee6 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800f78:	8b 45 14             	mov    0x14(%ebp),%eax
  800f7b:	8b 00                	mov    (%eax),%eax
  800f7d:	ba 00 00 00 00       	mov    $0x0,%edx
  800f82:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f85:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f88:	8b 45 14             	mov    0x14(%ebp),%eax
  800f8b:	8d 40 04             	lea    0x4(%eax),%eax
  800f8e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800f91:	b8 10 00 00 00       	mov    $0x10,%eax
  800f96:	e9 4b ff ff ff       	jmp    800ee6 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800f9b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f9e:	83 c0 04             	add    $0x4,%eax
  800fa1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800fa4:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa7:	8b 00                	mov    (%eax),%eax
  800fa9:	85 c0                	test   %eax,%eax
  800fab:	74 14                	je     800fc1 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800fad:	8b 13                	mov    (%ebx),%edx
  800faf:	83 fa 7f             	cmp    $0x7f,%edx
  800fb2:	7f 37                	jg     800feb <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800fb4:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800fb6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800fb9:	89 45 14             	mov    %eax,0x14(%ebp)
  800fbc:	e9 43 ff ff ff       	jmp    800f04 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800fc1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fc6:	bf 2d 33 80 00       	mov    $0x80332d,%edi
							putch(ch, putdat);
  800fcb:	83 ec 08             	sub    $0x8,%esp
  800fce:	53                   	push   %ebx
  800fcf:	50                   	push   %eax
  800fd0:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800fd2:	83 c7 01             	add    $0x1,%edi
  800fd5:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800fd9:	83 c4 10             	add    $0x10,%esp
  800fdc:	85 c0                	test   %eax,%eax
  800fde:	75 eb                	jne    800fcb <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800fe0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800fe3:	89 45 14             	mov    %eax,0x14(%ebp)
  800fe6:	e9 19 ff ff ff       	jmp    800f04 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800feb:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800fed:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ff2:	bf 65 33 80 00       	mov    $0x803365,%edi
							putch(ch, putdat);
  800ff7:	83 ec 08             	sub    $0x8,%esp
  800ffa:	53                   	push   %ebx
  800ffb:	50                   	push   %eax
  800ffc:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800ffe:	83 c7 01             	add    $0x1,%edi
  801001:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  801005:	83 c4 10             	add    $0x10,%esp
  801008:	85 c0                	test   %eax,%eax
  80100a:	75 eb                	jne    800ff7 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80100c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80100f:	89 45 14             	mov    %eax,0x14(%ebp)
  801012:	e9 ed fe ff ff       	jmp    800f04 <vprintfmt+0x446>
			putch(ch, putdat);
  801017:	83 ec 08             	sub    $0x8,%esp
  80101a:	53                   	push   %ebx
  80101b:	6a 25                	push   $0x25
  80101d:	ff d6                	call   *%esi
			break;
  80101f:	83 c4 10             	add    $0x10,%esp
  801022:	e9 dd fe ff ff       	jmp    800f04 <vprintfmt+0x446>
			putch('%', putdat);
  801027:	83 ec 08             	sub    $0x8,%esp
  80102a:	53                   	push   %ebx
  80102b:	6a 25                	push   $0x25
  80102d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80102f:	83 c4 10             	add    $0x10,%esp
  801032:	89 f8                	mov    %edi,%eax
  801034:	eb 03                	jmp    801039 <vprintfmt+0x57b>
  801036:	83 e8 01             	sub    $0x1,%eax
  801039:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80103d:	75 f7                	jne    801036 <vprintfmt+0x578>
  80103f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801042:	e9 bd fe ff ff       	jmp    800f04 <vprintfmt+0x446>
}
  801047:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80104a:	5b                   	pop    %ebx
  80104b:	5e                   	pop    %esi
  80104c:	5f                   	pop    %edi
  80104d:	5d                   	pop    %ebp
  80104e:	c3                   	ret    

0080104f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
  801052:	83 ec 18             	sub    $0x18,%esp
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80105b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80105e:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801062:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801065:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80106c:	85 c0                	test   %eax,%eax
  80106e:	74 26                	je     801096 <vsnprintf+0x47>
  801070:	85 d2                	test   %edx,%edx
  801072:	7e 22                	jle    801096 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801074:	ff 75 14             	pushl  0x14(%ebp)
  801077:	ff 75 10             	pushl  0x10(%ebp)
  80107a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80107d:	50                   	push   %eax
  80107e:	68 84 0a 80 00       	push   $0x800a84
  801083:	e8 36 fa ff ff       	call   800abe <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801088:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80108b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80108e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801091:	83 c4 10             	add    $0x10,%esp
}
  801094:	c9                   	leave  
  801095:	c3                   	ret    
		return -E_INVAL;
  801096:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80109b:	eb f7                	jmp    801094 <vsnprintf+0x45>

0080109d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80109d:	55                   	push   %ebp
  80109e:	89 e5                	mov    %esp,%ebp
  8010a0:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010a3:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8010a6:	50                   	push   %eax
  8010a7:	ff 75 10             	pushl  0x10(%ebp)
  8010aa:	ff 75 0c             	pushl  0xc(%ebp)
  8010ad:	ff 75 08             	pushl  0x8(%ebp)
  8010b0:	e8 9a ff ff ff       	call   80104f <vsnprintf>
	va_end(ap);

	return rc;
}
  8010b5:	c9                   	leave  
  8010b6:	c3                   	ret    

008010b7 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8010b7:	55                   	push   %ebp
  8010b8:	89 e5                	mov    %esp,%ebp
  8010ba:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8010bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8010c2:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8010c6:	74 05                	je     8010cd <strlen+0x16>
		n++;
  8010c8:	83 c0 01             	add    $0x1,%eax
  8010cb:	eb f5                	jmp    8010c2 <strlen+0xb>
	return n;
}
  8010cd:	5d                   	pop    %ebp
  8010ce:	c3                   	ret    

008010cf <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8010cf:	55                   	push   %ebp
  8010d0:	89 e5                	mov    %esp,%ebp
  8010d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010d5:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8010dd:	39 c2                	cmp    %eax,%edx
  8010df:	74 0d                	je     8010ee <strnlen+0x1f>
  8010e1:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8010e5:	74 05                	je     8010ec <strnlen+0x1d>
		n++;
  8010e7:	83 c2 01             	add    $0x1,%edx
  8010ea:	eb f1                	jmp    8010dd <strnlen+0xe>
  8010ec:	89 d0                	mov    %edx,%eax
	return n;
}
  8010ee:	5d                   	pop    %ebp
  8010ef:	c3                   	ret    

008010f0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
  8010f3:	53                   	push   %ebx
  8010f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8010fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8010ff:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  801103:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  801106:	83 c2 01             	add    $0x1,%edx
  801109:	84 c9                	test   %cl,%cl
  80110b:	75 f2                	jne    8010ff <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80110d:	5b                   	pop    %ebx
  80110e:	5d                   	pop    %ebp
  80110f:	c3                   	ret    

00801110 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
  801113:	53                   	push   %ebx
  801114:	83 ec 10             	sub    $0x10,%esp
  801117:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80111a:	53                   	push   %ebx
  80111b:	e8 97 ff ff ff       	call   8010b7 <strlen>
  801120:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801123:	ff 75 0c             	pushl  0xc(%ebp)
  801126:	01 d8                	add    %ebx,%eax
  801128:	50                   	push   %eax
  801129:	e8 c2 ff ff ff       	call   8010f0 <strcpy>
	return dst;
}
  80112e:	89 d8                	mov    %ebx,%eax
  801130:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801133:	c9                   	leave  
  801134:	c3                   	ret    

00801135 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801135:	55                   	push   %ebp
  801136:	89 e5                	mov    %esp,%ebp
  801138:	56                   	push   %esi
  801139:	53                   	push   %ebx
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
  80113d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801140:	89 c6                	mov    %eax,%esi
  801142:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801145:	89 c2                	mov    %eax,%edx
  801147:	39 f2                	cmp    %esi,%edx
  801149:	74 11                	je     80115c <strncpy+0x27>
		*dst++ = *src;
  80114b:	83 c2 01             	add    $0x1,%edx
  80114e:	0f b6 19             	movzbl (%ecx),%ebx
  801151:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801154:	80 fb 01             	cmp    $0x1,%bl
  801157:	83 d9 ff             	sbb    $0xffffffff,%ecx
  80115a:	eb eb                	jmp    801147 <strncpy+0x12>
	}
	return ret;
}
  80115c:	5b                   	pop    %ebx
  80115d:	5e                   	pop    %esi
  80115e:	5d                   	pop    %ebp
  80115f:	c3                   	ret    

00801160 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801160:	55                   	push   %ebp
  801161:	89 e5                	mov    %esp,%ebp
  801163:	56                   	push   %esi
  801164:	53                   	push   %ebx
  801165:	8b 75 08             	mov    0x8(%ebp),%esi
  801168:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80116b:	8b 55 10             	mov    0x10(%ebp),%edx
  80116e:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801170:	85 d2                	test   %edx,%edx
  801172:	74 21                	je     801195 <strlcpy+0x35>
  801174:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801178:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80117a:	39 c2                	cmp    %eax,%edx
  80117c:	74 14                	je     801192 <strlcpy+0x32>
  80117e:	0f b6 19             	movzbl (%ecx),%ebx
  801181:	84 db                	test   %bl,%bl
  801183:	74 0b                	je     801190 <strlcpy+0x30>
			*dst++ = *src++;
  801185:	83 c1 01             	add    $0x1,%ecx
  801188:	83 c2 01             	add    $0x1,%edx
  80118b:	88 5a ff             	mov    %bl,-0x1(%edx)
  80118e:	eb ea                	jmp    80117a <strlcpy+0x1a>
  801190:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801192:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801195:	29 f0                	sub    %esi,%eax
}
  801197:	5b                   	pop    %ebx
  801198:	5e                   	pop    %esi
  801199:	5d                   	pop    %ebp
  80119a:	c3                   	ret    

0080119b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80119b:	55                   	push   %ebp
  80119c:	89 e5                	mov    %esp,%ebp
  80119e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011a1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8011a4:	0f b6 01             	movzbl (%ecx),%eax
  8011a7:	84 c0                	test   %al,%al
  8011a9:	74 0c                	je     8011b7 <strcmp+0x1c>
  8011ab:	3a 02                	cmp    (%edx),%al
  8011ad:	75 08                	jne    8011b7 <strcmp+0x1c>
		p++, q++;
  8011af:	83 c1 01             	add    $0x1,%ecx
  8011b2:	83 c2 01             	add    $0x1,%edx
  8011b5:	eb ed                	jmp    8011a4 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011b7:	0f b6 c0             	movzbl %al,%eax
  8011ba:	0f b6 12             	movzbl (%edx),%edx
  8011bd:	29 d0                	sub    %edx,%eax
}
  8011bf:	5d                   	pop    %ebp
  8011c0:	c3                   	ret    

008011c1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011c1:	55                   	push   %ebp
  8011c2:	89 e5                	mov    %esp,%ebp
  8011c4:	53                   	push   %ebx
  8011c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011cb:	89 c3                	mov    %eax,%ebx
  8011cd:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8011d0:	eb 06                	jmp    8011d8 <strncmp+0x17>
		n--, p++, q++;
  8011d2:	83 c0 01             	add    $0x1,%eax
  8011d5:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8011d8:	39 d8                	cmp    %ebx,%eax
  8011da:	74 16                	je     8011f2 <strncmp+0x31>
  8011dc:	0f b6 08             	movzbl (%eax),%ecx
  8011df:	84 c9                	test   %cl,%cl
  8011e1:	74 04                	je     8011e7 <strncmp+0x26>
  8011e3:	3a 0a                	cmp    (%edx),%cl
  8011e5:	74 eb                	je     8011d2 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011e7:	0f b6 00             	movzbl (%eax),%eax
  8011ea:	0f b6 12             	movzbl (%edx),%edx
  8011ed:	29 d0                	sub    %edx,%eax
}
  8011ef:	5b                   	pop    %ebx
  8011f0:	5d                   	pop    %ebp
  8011f1:	c3                   	ret    
		return 0;
  8011f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8011f7:	eb f6                	jmp    8011ef <strncmp+0x2e>

008011f9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011f9:	55                   	push   %ebp
  8011fa:	89 e5                	mov    %esp,%ebp
  8011fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ff:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801203:	0f b6 10             	movzbl (%eax),%edx
  801206:	84 d2                	test   %dl,%dl
  801208:	74 09                	je     801213 <strchr+0x1a>
		if (*s == c)
  80120a:	38 ca                	cmp    %cl,%dl
  80120c:	74 0a                	je     801218 <strchr+0x1f>
	for (; *s; s++)
  80120e:	83 c0 01             	add    $0x1,%eax
  801211:	eb f0                	jmp    801203 <strchr+0xa>
			return (char *) s;
	return 0;
  801213:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801218:	5d                   	pop    %ebp
  801219:	c3                   	ret    

0080121a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80121a:	55                   	push   %ebp
  80121b:	89 e5                	mov    %esp,%ebp
  80121d:	8b 45 08             	mov    0x8(%ebp),%eax
  801220:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801224:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801227:	38 ca                	cmp    %cl,%dl
  801229:	74 09                	je     801234 <strfind+0x1a>
  80122b:	84 d2                	test   %dl,%dl
  80122d:	74 05                	je     801234 <strfind+0x1a>
	for (; *s; s++)
  80122f:	83 c0 01             	add    $0x1,%eax
  801232:	eb f0                	jmp    801224 <strfind+0xa>
			break;
	return (char *) s;
}
  801234:	5d                   	pop    %ebp
  801235:	c3                   	ret    

00801236 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801236:	55                   	push   %ebp
  801237:	89 e5                	mov    %esp,%ebp
  801239:	57                   	push   %edi
  80123a:	56                   	push   %esi
  80123b:	53                   	push   %ebx
  80123c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80123f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801242:	85 c9                	test   %ecx,%ecx
  801244:	74 31                	je     801277 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801246:	89 f8                	mov    %edi,%eax
  801248:	09 c8                	or     %ecx,%eax
  80124a:	a8 03                	test   $0x3,%al
  80124c:	75 23                	jne    801271 <memset+0x3b>
		c &= 0xFF;
  80124e:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801252:	89 d3                	mov    %edx,%ebx
  801254:	c1 e3 08             	shl    $0x8,%ebx
  801257:	89 d0                	mov    %edx,%eax
  801259:	c1 e0 18             	shl    $0x18,%eax
  80125c:	89 d6                	mov    %edx,%esi
  80125e:	c1 e6 10             	shl    $0x10,%esi
  801261:	09 f0                	or     %esi,%eax
  801263:	09 c2                	or     %eax,%edx
  801265:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801267:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80126a:	89 d0                	mov    %edx,%eax
  80126c:	fc                   	cld    
  80126d:	f3 ab                	rep stos %eax,%es:(%edi)
  80126f:	eb 06                	jmp    801277 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801271:	8b 45 0c             	mov    0xc(%ebp),%eax
  801274:	fc                   	cld    
  801275:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801277:	89 f8                	mov    %edi,%eax
  801279:	5b                   	pop    %ebx
  80127a:	5e                   	pop    %esi
  80127b:	5f                   	pop    %edi
  80127c:	5d                   	pop    %ebp
  80127d:	c3                   	ret    

0080127e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80127e:	55                   	push   %ebp
  80127f:	89 e5                	mov    %esp,%ebp
  801281:	57                   	push   %edi
  801282:	56                   	push   %esi
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	8b 75 0c             	mov    0xc(%ebp),%esi
  801289:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80128c:	39 c6                	cmp    %eax,%esi
  80128e:	73 32                	jae    8012c2 <memmove+0x44>
  801290:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801293:	39 c2                	cmp    %eax,%edx
  801295:	76 2b                	jbe    8012c2 <memmove+0x44>
		s += n;
		d += n;
  801297:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80129a:	89 fe                	mov    %edi,%esi
  80129c:	09 ce                	or     %ecx,%esi
  80129e:	09 d6                	or     %edx,%esi
  8012a0:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8012a6:	75 0e                	jne    8012b6 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8012a8:	83 ef 04             	sub    $0x4,%edi
  8012ab:	8d 72 fc             	lea    -0x4(%edx),%esi
  8012ae:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8012b1:	fd                   	std    
  8012b2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8012b4:	eb 09                	jmp    8012bf <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8012b6:	83 ef 01             	sub    $0x1,%edi
  8012b9:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8012bc:	fd                   	std    
  8012bd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8012bf:	fc                   	cld    
  8012c0:	eb 1a                	jmp    8012dc <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8012c2:	89 c2                	mov    %eax,%edx
  8012c4:	09 ca                	or     %ecx,%edx
  8012c6:	09 f2                	or     %esi,%edx
  8012c8:	f6 c2 03             	test   $0x3,%dl
  8012cb:	75 0a                	jne    8012d7 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8012cd:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8012d0:	89 c7                	mov    %eax,%edi
  8012d2:	fc                   	cld    
  8012d3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8012d5:	eb 05                	jmp    8012dc <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  8012d7:	89 c7                	mov    %eax,%edi
  8012d9:	fc                   	cld    
  8012da:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8012dc:	5e                   	pop    %esi
  8012dd:	5f                   	pop    %edi
  8012de:	5d                   	pop    %ebp
  8012df:	c3                   	ret    

008012e0 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
  8012e3:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8012e6:	ff 75 10             	pushl  0x10(%ebp)
  8012e9:	ff 75 0c             	pushl  0xc(%ebp)
  8012ec:	ff 75 08             	pushl  0x8(%ebp)
  8012ef:	e8 8a ff ff ff       	call   80127e <memmove>
}
  8012f4:	c9                   	leave  
  8012f5:	c3                   	ret    

008012f6 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8012f6:	55                   	push   %ebp
  8012f7:	89 e5                	mov    %esp,%ebp
  8012f9:	56                   	push   %esi
  8012fa:	53                   	push   %ebx
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801301:	89 c6                	mov    %eax,%esi
  801303:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801306:	39 f0                	cmp    %esi,%eax
  801308:	74 1c                	je     801326 <memcmp+0x30>
		if (*s1 != *s2)
  80130a:	0f b6 08             	movzbl (%eax),%ecx
  80130d:	0f b6 1a             	movzbl (%edx),%ebx
  801310:	38 d9                	cmp    %bl,%cl
  801312:	75 08                	jne    80131c <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801314:	83 c0 01             	add    $0x1,%eax
  801317:	83 c2 01             	add    $0x1,%edx
  80131a:	eb ea                	jmp    801306 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  80131c:	0f b6 c1             	movzbl %cl,%eax
  80131f:	0f b6 db             	movzbl %bl,%ebx
  801322:	29 d8                	sub    %ebx,%eax
  801324:	eb 05                	jmp    80132b <memcmp+0x35>
	}

	return 0;
  801326:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80132b:	5b                   	pop    %ebx
  80132c:	5e                   	pop    %esi
  80132d:	5d                   	pop    %ebp
  80132e:	c3                   	ret    

0080132f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80132f:	55                   	push   %ebp
  801330:	89 e5                	mov    %esp,%ebp
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
  801335:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801338:	89 c2                	mov    %eax,%edx
  80133a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80133d:	39 d0                	cmp    %edx,%eax
  80133f:	73 09                	jae    80134a <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801341:	38 08                	cmp    %cl,(%eax)
  801343:	74 05                	je     80134a <memfind+0x1b>
	for (; s < ends; s++)
  801345:	83 c0 01             	add    $0x1,%eax
  801348:	eb f3                	jmp    80133d <memfind+0xe>
			break;
	return (void *) s;
}
  80134a:	5d                   	pop    %ebp
  80134b:	c3                   	ret    

0080134c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
  80134f:	57                   	push   %edi
  801350:	56                   	push   %esi
  801351:	53                   	push   %ebx
  801352:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801355:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801358:	eb 03                	jmp    80135d <strtol+0x11>
		s++;
  80135a:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  80135d:	0f b6 01             	movzbl (%ecx),%eax
  801360:	3c 20                	cmp    $0x20,%al
  801362:	74 f6                	je     80135a <strtol+0xe>
  801364:	3c 09                	cmp    $0x9,%al
  801366:	74 f2                	je     80135a <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801368:	3c 2b                	cmp    $0x2b,%al
  80136a:	74 2a                	je     801396 <strtol+0x4a>
	int neg = 0;
  80136c:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801371:	3c 2d                	cmp    $0x2d,%al
  801373:	74 2b                	je     8013a0 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801375:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  80137b:	75 0f                	jne    80138c <strtol+0x40>
  80137d:	80 39 30             	cmpb   $0x30,(%ecx)
  801380:	74 28                	je     8013aa <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801382:	85 db                	test   %ebx,%ebx
  801384:	b8 0a 00 00 00       	mov    $0xa,%eax
  801389:	0f 44 d8             	cmove  %eax,%ebx
  80138c:	b8 00 00 00 00       	mov    $0x0,%eax
  801391:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801394:	eb 50                	jmp    8013e6 <strtol+0x9a>
		s++;
  801396:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801399:	bf 00 00 00 00       	mov    $0x0,%edi
  80139e:	eb d5                	jmp    801375 <strtol+0x29>
		s++, neg = 1;
  8013a0:	83 c1 01             	add    $0x1,%ecx
  8013a3:	bf 01 00 00 00       	mov    $0x1,%edi
  8013a8:	eb cb                	jmp    801375 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013aa:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8013ae:	74 0e                	je     8013be <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  8013b0:	85 db                	test   %ebx,%ebx
  8013b2:	75 d8                	jne    80138c <strtol+0x40>
		s++, base = 8;
  8013b4:	83 c1 01             	add    $0x1,%ecx
  8013b7:	bb 08 00 00 00       	mov    $0x8,%ebx
  8013bc:	eb ce                	jmp    80138c <strtol+0x40>
		s += 2, base = 16;
  8013be:	83 c1 02             	add    $0x2,%ecx
  8013c1:	bb 10 00 00 00       	mov    $0x10,%ebx
  8013c6:	eb c4                	jmp    80138c <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  8013c8:	8d 72 9f             	lea    -0x61(%edx),%esi
  8013cb:	89 f3                	mov    %esi,%ebx
  8013cd:	80 fb 19             	cmp    $0x19,%bl
  8013d0:	77 29                	ja     8013fb <strtol+0xaf>
			dig = *s - 'a' + 10;
  8013d2:	0f be d2             	movsbl %dl,%edx
  8013d5:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8013d8:	3b 55 10             	cmp    0x10(%ebp),%edx
  8013db:	7d 30                	jge    80140d <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  8013dd:	83 c1 01             	add    $0x1,%ecx
  8013e0:	0f af 45 10          	imul   0x10(%ebp),%eax
  8013e4:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8013e6:	0f b6 11             	movzbl (%ecx),%edx
  8013e9:	8d 72 d0             	lea    -0x30(%edx),%esi
  8013ec:	89 f3                	mov    %esi,%ebx
  8013ee:	80 fb 09             	cmp    $0x9,%bl
  8013f1:	77 d5                	ja     8013c8 <strtol+0x7c>
			dig = *s - '0';
  8013f3:	0f be d2             	movsbl %dl,%edx
  8013f6:	83 ea 30             	sub    $0x30,%edx
  8013f9:	eb dd                	jmp    8013d8 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  8013fb:	8d 72 bf             	lea    -0x41(%edx),%esi
  8013fe:	89 f3                	mov    %esi,%ebx
  801400:	80 fb 19             	cmp    $0x19,%bl
  801403:	77 08                	ja     80140d <strtol+0xc1>
			dig = *s - 'A' + 10;
  801405:	0f be d2             	movsbl %dl,%edx
  801408:	83 ea 37             	sub    $0x37,%edx
  80140b:	eb cb                	jmp    8013d8 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  80140d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801411:	74 05                	je     801418 <strtol+0xcc>
		*endptr = (char *) s;
  801413:	8b 75 0c             	mov    0xc(%ebp),%esi
  801416:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801418:	89 c2                	mov    %eax,%edx
  80141a:	f7 da                	neg    %edx
  80141c:	85 ff                	test   %edi,%edi
  80141e:	0f 45 c2             	cmovne %edx,%eax
}
  801421:	5b                   	pop    %ebx
  801422:	5e                   	pop    %esi
  801423:	5f                   	pop    %edi
  801424:	5d                   	pop    %ebp
  801425:	c3                   	ret    

00801426 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801426:	55                   	push   %ebp
  801427:	89 e5                	mov    %esp,%ebp
  801429:	57                   	push   %edi
  80142a:	56                   	push   %esi
  80142b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80142c:	b8 00 00 00 00       	mov    $0x0,%eax
  801431:	8b 55 08             	mov    0x8(%ebp),%edx
  801434:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801437:	89 c3                	mov    %eax,%ebx
  801439:	89 c7                	mov    %eax,%edi
  80143b:	89 c6                	mov    %eax,%esi
  80143d:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80143f:	5b                   	pop    %ebx
  801440:	5e                   	pop    %esi
  801441:	5f                   	pop    %edi
  801442:	5d                   	pop    %ebp
  801443:	c3                   	ret    

00801444 <sys_cgetc>:

int
sys_cgetc(void)
{
  801444:	55                   	push   %ebp
  801445:	89 e5                	mov    %esp,%ebp
  801447:	57                   	push   %edi
  801448:	56                   	push   %esi
  801449:	53                   	push   %ebx
	asm volatile("int %1\n"
  80144a:	ba 00 00 00 00       	mov    $0x0,%edx
  80144f:	b8 01 00 00 00       	mov    $0x1,%eax
  801454:	89 d1                	mov    %edx,%ecx
  801456:	89 d3                	mov    %edx,%ebx
  801458:	89 d7                	mov    %edx,%edi
  80145a:	89 d6                	mov    %edx,%esi
  80145c:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80145e:	5b                   	pop    %ebx
  80145f:	5e                   	pop    %esi
  801460:	5f                   	pop    %edi
  801461:	5d                   	pop    %ebp
  801462:	c3                   	ret    

00801463 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
  801466:	57                   	push   %edi
  801467:	56                   	push   %esi
  801468:	53                   	push   %ebx
  801469:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80146c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801471:	8b 55 08             	mov    0x8(%ebp),%edx
  801474:	b8 03 00 00 00       	mov    $0x3,%eax
  801479:	89 cb                	mov    %ecx,%ebx
  80147b:	89 cf                	mov    %ecx,%edi
  80147d:	89 ce                	mov    %ecx,%esi
  80147f:	cd 30                	int    $0x30
	if(check && ret > 0)
  801481:	85 c0                	test   %eax,%eax
  801483:	7f 08                	jg     80148d <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801485:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801488:	5b                   	pop    %ebx
  801489:	5e                   	pop    %esi
  80148a:	5f                   	pop    %edi
  80148b:	5d                   	pop    %ebp
  80148c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80148d:	83 ec 0c             	sub    $0xc,%esp
  801490:	50                   	push   %eax
  801491:	6a 03                	push   $0x3
  801493:	68 88 35 80 00       	push   $0x803588
  801498:	6a 43                	push   $0x43
  80149a:	68 a5 35 80 00       	push   $0x8035a5
  80149f:	e8 f7 f3 ff ff       	call   80089b <_panic>

008014a4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8014a4:	55                   	push   %ebp
  8014a5:	89 e5                	mov    %esp,%ebp
  8014a7:	57                   	push   %edi
  8014a8:	56                   	push   %esi
  8014a9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8014af:	b8 02 00 00 00       	mov    $0x2,%eax
  8014b4:	89 d1                	mov    %edx,%ecx
  8014b6:	89 d3                	mov    %edx,%ebx
  8014b8:	89 d7                	mov    %edx,%edi
  8014ba:	89 d6                	mov    %edx,%esi
  8014bc:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8014be:	5b                   	pop    %ebx
  8014bf:	5e                   	pop    %esi
  8014c0:	5f                   	pop    %edi
  8014c1:	5d                   	pop    %ebp
  8014c2:	c3                   	ret    

008014c3 <sys_yield>:

void
sys_yield(void)
{
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
  8014c6:	57                   	push   %edi
  8014c7:	56                   	push   %esi
  8014c8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ce:	b8 0b 00 00 00       	mov    $0xb,%eax
  8014d3:	89 d1                	mov    %edx,%ecx
  8014d5:	89 d3                	mov    %edx,%ebx
  8014d7:	89 d7                	mov    %edx,%edi
  8014d9:	89 d6                	mov    %edx,%esi
  8014db:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8014dd:	5b                   	pop    %ebx
  8014de:	5e                   	pop    %esi
  8014df:	5f                   	pop    %edi
  8014e0:	5d                   	pop    %ebp
  8014e1:	c3                   	ret    

008014e2 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8014e2:	55                   	push   %ebp
  8014e3:	89 e5                	mov    %esp,%ebp
  8014e5:	57                   	push   %edi
  8014e6:	56                   	push   %esi
  8014e7:	53                   	push   %ebx
  8014e8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8014eb:	be 00 00 00 00       	mov    $0x0,%esi
  8014f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014f6:	b8 04 00 00 00       	mov    $0x4,%eax
  8014fb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8014fe:	89 f7                	mov    %esi,%edi
  801500:	cd 30                	int    $0x30
	if(check && ret > 0)
  801502:	85 c0                	test   %eax,%eax
  801504:	7f 08                	jg     80150e <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801506:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801509:	5b                   	pop    %ebx
  80150a:	5e                   	pop    %esi
  80150b:	5f                   	pop    %edi
  80150c:	5d                   	pop    %ebp
  80150d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80150e:	83 ec 0c             	sub    $0xc,%esp
  801511:	50                   	push   %eax
  801512:	6a 04                	push   $0x4
  801514:	68 88 35 80 00       	push   $0x803588
  801519:	6a 43                	push   $0x43
  80151b:	68 a5 35 80 00       	push   $0x8035a5
  801520:	e8 76 f3 ff ff       	call   80089b <_panic>

00801525 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
  801528:	57                   	push   %edi
  801529:	56                   	push   %esi
  80152a:	53                   	push   %ebx
  80152b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80152e:	8b 55 08             	mov    0x8(%ebp),%edx
  801531:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801534:	b8 05 00 00 00       	mov    $0x5,%eax
  801539:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80153c:	8b 7d 14             	mov    0x14(%ebp),%edi
  80153f:	8b 75 18             	mov    0x18(%ebp),%esi
  801542:	cd 30                	int    $0x30
	if(check && ret > 0)
  801544:	85 c0                	test   %eax,%eax
  801546:	7f 08                	jg     801550 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801548:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80154b:	5b                   	pop    %ebx
  80154c:	5e                   	pop    %esi
  80154d:	5f                   	pop    %edi
  80154e:	5d                   	pop    %ebp
  80154f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801550:	83 ec 0c             	sub    $0xc,%esp
  801553:	50                   	push   %eax
  801554:	6a 05                	push   $0x5
  801556:	68 88 35 80 00       	push   $0x803588
  80155b:	6a 43                	push   $0x43
  80155d:	68 a5 35 80 00       	push   $0x8035a5
  801562:	e8 34 f3 ff ff       	call   80089b <_panic>

00801567 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801567:	55                   	push   %ebp
  801568:	89 e5                	mov    %esp,%ebp
  80156a:	57                   	push   %edi
  80156b:	56                   	push   %esi
  80156c:	53                   	push   %ebx
  80156d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801570:	bb 00 00 00 00       	mov    $0x0,%ebx
  801575:	8b 55 08             	mov    0x8(%ebp),%edx
  801578:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80157b:	b8 06 00 00 00       	mov    $0x6,%eax
  801580:	89 df                	mov    %ebx,%edi
  801582:	89 de                	mov    %ebx,%esi
  801584:	cd 30                	int    $0x30
	if(check && ret > 0)
  801586:	85 c0                	test   %eax,%eax
  801588:	7f 08                	jg     801592 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80158a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80158d:	5b                   	pop    %ebx
  80158e:	5e                   	pop    %esi
  80158f:	5f                   	pop    %edi
  801590:	5d                   	pop    %ebp
  801591:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801592:	83 ec 0c             	sub    $0xc,%esp
  801595:	50                   	push   %eax
  801596:	6a 06                	push   $0x6
  801598:	68 88 35 80 00       	push   $0x803588
  80159d:	6a 43                	push   $0x43
  80159f:	68 a5 35 80 00       	push   $0x8035a5
  8015a4:	e8 f2 f2 ff ff       	call   80089b <_panic>

008015a9 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
  8015ac:	57                   	push   %edi
  8015ad:	56                   	push   %esi
  8015ae:	53                   	push   %ebx
  8015af:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8015b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015bd:	b8 08 00 00 00       	mov    $0x8,%eax
  8015c2:	89 df                	mov    %ebx,%edi
  8015c4:	89 de                	mov    %ebx,%esi
  8015c6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8015c8:	85 c0                	test   %eax,%eax
  8015ca:	7f 08                	jg     8015d4 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8015cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015cf:	5b                   	pop    %ebx
  8015d0:	5e                   	pop    %esi
  8015d1:	5f                   	pop    %edi
  8015d2:	5d                   	pop    %ebp
  8015d3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8015d4:	83 ec 0c             	sub    $0xc,%esp
  8015d7:	50                   	push   %eax
  8015d8:	6a 08                	push   $0x8
  8015da:	68 88 35 80 00       	push   $0x803588
  8015df:	6a 43                	push   $0x43
  8015e1:	68 a5 35 80 00       	push   $0x8035a5
  8015e6:	e8 b0 f2 ff ff       	call   80089b <_panic>

008015eb <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8015eb:	55                   	push   %ebp
  8015ec:	89 e5                	mov    %esp,%ebp
  8015ee:	57                   	push   %edi
  8015ef:	56                   	push   %esi
  8015f0:	53                   	push   %ebx
  8015f1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8015f4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8015fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015ff:	b8 09 00 00 00       	mov    $0x9,%eax
  801604:	89 df                	mov    %ebx,%edi
  801606:	89 de                	mov    %ebx,%esi
  801608:	cd 30                	int    $0x30
	if(check && ret > 0)
  80160a:	85 c0                	test   %eax,%eax
  80160c:	7f 08                	jg     801616 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80160e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801611:	5b                   	pop    %ebx
  801612:	5e                   	pop    %esi
  801613:	5f                   	pop    %edi
  801614:	5d                   	pop    %ebp
  801615:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801616:	83 ec 0c             	sub    $0xc,%esp
  801619:	50                   	push   %eax
  80161a:	6a 09                	push   $0x9
  80161c:	68 88 35 80 00       	push   $0x803588
  801621:	6a 43                	push   $0x43
  801623:	68 a5 35 80 00       	push   $0x8035a5
  801628:	e8 6e f2 ff ff       	call   80089b <_panic>

0080162d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
  801630:	57                   	push   %edi
  801631:	56                   	push   %esi
  801632:	53                   	push   %ebx
  801633:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801636:	bb 00 00 00 00       	mov    $0x0,%ebx
  80163b:	8b 55 08             	mov    0x8(%ebp),%edx
  80163e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801641:	b8 0a 00 00 00       	mov    $0xa,%eax
  801646:	89 df                	mov    %ebx,%edi
  801648:	89 de                	mov    %ebx,%esi
  80164a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80164c:	85 c0                	test   %eax,%eax
  80164e:	7f 08                	jg     801658 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801650:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801653:	5b                   	pop    %ebx
  801654:	5e                   	pop    %esi
  801655:	5f                   	pop    %edi
  801656:	5d                   	pop    %ebp
  801657:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801658:	83 ec 0c             	sub    $0xc,%esp
  80165b:	50                   	push   %eax
  80165c:	6a 0a                	push   $0xa
  80165e:	68 88 35 80 00       	push   $0x803588
  801663:	6a 43                	push   $0x43
  801665:	68 a5 35 80 00       	push   $0x8035a5
  80166a:	e8 2c f2 ff ff       	call   80089b <_panic>

0080166f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
  801672:	57                   	push   %edi
  801673:	56                   	push   %esi
  801674:	53                   	push   %ebx
	asm volatile("int %1\n"
  801675:	8b 55 08             	mov    0x8(%ebp),%edx
  801678:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80167b:	b8 0c 00 00 00       	mov    $0xc,%eax
  801680:	be 00 00 00 00       	mov    $0x0,%esi
  801685:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801688:	8b 7d 14             	mov    0x14(%ebp),%edi
  80168b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80168d:	5b                   	pop    %ebx
  80168e:	5e                   	pop    %esi
  80168f:	5f                   	pop    %edi
  801690:	5d                   	pop    %ebp
  801691:	c3                   	ret    

00801692 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
  801695:	57                   	push   %edi
  801696:	56                   	push   %esi
  801697:	53                   	push   %ebx
  801698:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80169b:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8016a3:	b8 0d 00 00 00       	mov    $0xd,%eax
  8016a8:	89 cb                	mov    %ecx,%ebx
  8016aa:	89 cf                	mov    %ecx,%edi
  8016ac:	89 ce                	mov    %ecx,%esi
  8016ae:	cd 30                	int    $0x30
	if(check && ret > 0)
  8016b0:	85 c0                	test   %eax,%eax
  8016b2:	7f 08                	jg     8016bc <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8016b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016b7:	5b                   	pop    %ebx
  8016b8:	5e                   	pop    %esi
  8016b9:	5f                   	pop    %edi
  8016ba:	5d                   	pop    %ebp
  8016bb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8016bc:	83 ec 0c             	sub    $0xc,%esp
  8016bf:	50                   	push   %eax
  8016c0:	6a 0d                	push   $0xd
  8016c2:	68 88 35 80 00       	push   $0x803588
  8016c7:	6a 43                	push   $0x43
  8016c9:	68 a5 35 80 00       	push   $0x8035a5
  8016ce:	e8 c8 f1 ff ff       	call   80089b <_panic>

008016d3 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
  8016d6:	57                   	push   %edi
  8016d7:	56                   	push   %esi
  8016d8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8016d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016de:	8b 55 08             	mov    0x8(%ebp),%edx
  8016e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016e4:	b8 0e 00 00 00       	mov    $0xe,%eax
  8016e9:	89 df                	mov    %ebx,%edi
  8016eb:	89 de                	mov    %ebx,%esi
  8016ed:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8016ef:	5b                   	pop    %ebx
  8016f0:	5e                   	pop    %esi
  8016f1:	5f                   	pop    %edi
  8016f2:	5d                   	pop    %ebp
  8016f3:	c3                   	ret    

008016f4 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8016f4:	55                   	push   %ebp
  8016f5:	89 e5                	mov    %esp,%ebp
  8016f7:	57                   	push   %edi
  8016f8:	56                   	push   %esi
  8016f9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8016fa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016ff:	8b 55 08             	mov    0x8(%ebp),%edx
  801702:	b8 0f 00 00 00       	mov    $0xf,%eax
  801707:	89 cb                	mov    %ecx,%ebx
  801709:	89 cf                	mov    %ecx,%edi
  80170b:	89 ce                	mov    %ecx,%esi
  80170d:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80170f:	5b                   	pop    %ebx
  801710:	5e                   	pop    %esi
  801711:	5f                   	pop    %edi
  801712:	5d                   	pop    %ebp
  801713:	c3                   	ret    

00801714 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
  801717:	57                   	push   %edi
  801718:	56                   	push   %esi
  801719:	53                   	push   %ebx
	asm volatile("int %1\n"
  80171a:	ba 00 00 00 00       	mov    $0x0,%edx
  80171f:	b8 10 00 00 00       	mov    $0x10,%eax
  801724:	89 d1                	mov    %edx,%ecx
  801726:	89 d3                	mov    %edx,%ebx
  801728:	89 d7                	mov    %edx,%edi
  80172a:	89 d6                	mov    %edx,%esi
  80172c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80172e:	5b                   	pop    %ebx
  80172f:	5e                   	pop    %esi
  801730:	5f                   	pop    %edi
  801731:	5d                   	pop    %ebp
  801732:	c3                   	ret    

00801733 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
  801736:	57                   	push   %edi
  801737:	56                   	push   %esi
  801738:	53                   	push   %ebx
	asm volatile("int %1\n"
  801739:	bb 00 00 00 00       	mov    $0x0,%ebx
  80173e:	8b 55 08             	mov    0x8(%ebp),%edx
  801741:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801744:	b8 11 00 00 00       	mov    $0x11,%eax
  801749:	89 df                	mov    %ebx,%edi
  80174b:	89 de                	mov    %ebx,%esi
  80174d:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80174f:	5b                   	pop    %ebx
  801750:	5e                   	pop    %esi
  801751:	5f                   	pop    %edi
  801752:	5d                   	pop    %ebp
  801753:	c3                   	ret    

00801754 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
  801757:	57                   	push   %edi
  801758:	56                   	push   %esi
  801759:	53                   	push   %ebx
	asm volatile("int %1\n"
  80175a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80175f:	8b 55 08             	mov    0x8(%ebp),%edx
  801762:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801765:	b8 12 00 00 00       	mov    $0x12,%eax
  80176a:	89 df                	mov    %ebx,%edi
  80176c:	89 de                	mov    %ebx,%esi
  80176e:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801770:	5b                   	pop    %ebx
  801771:	5e                   	pop    %esi
  801772:	5f                   	pop    %edi
  801773:	5d                   	pop    %ebp
  801774:	c3                   	ret    

00801775 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
  801778:	57                   	push   %edi
  801779:	56                   	push   %esi
  80177a:	53                   	push   %ebx
  80177b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80177e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801783:	8b 55 08             	mov    0x8(%ebp),%edx
  801786:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801789:	b8 13 00 00 00       	mov    $0x13,%eax
  80178e:	89 df                	mov    %ebx,%edi
  801790:	89 de                	mov    %ebx,%esi
  801792:	cd 30                	int    $0x30
	if(check && ret > 0)
  801794:	85 c0                	test   %eax,%eax
  801796:	7f 08                	jg     8017a0 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801798:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80179b:	5b                   	pop    %ebx
  80179c:	5e                   	pop    %esi
  80179d:	5f                   	pop    %edi
  80179e:	5d                   	pop    %ebp
  80179f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8017a0:	83 ec 0c             	sub    $0xc,%esp
  8017a3:	50                   	push   %eax
  8017a4:	6a 13                	push   $0x13
  8017a6:	68 88 35 80 00       	push   $0x803588
  8017ab:	6a 43                	push   $0x43
  8017ad:	68 a5 35 80 00       	push   $0x8035a5
  8017b2:	e8 e4 f0 ff ff       	call   80089b <_panic>

008017b7 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
  8017ba:	57                   	push   %edi
  8017bb:	56                   	push   %esi
  8017bc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8017bd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8017c5:	b8 14 00 00 00       	mov    $0x14,%eax
  8017ca:	89 cb                	mov    %ecx,%ebx
  8017cc:	89 cf                	mov    %ecx,%edi
  8017ce:	89 ce                	mov    %ecx,%esi
  8017d0:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  8017d2:	5b                   	pop    %ebx
  8017d3:	5e                   	pop    %esi
  8017d4:	5f                   	pop    %edi
  8017d5:	5d                   	pop    %ebp
  8017d6:	c3                   	ret    

008017d7 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8017d7:	55                   	push   %ebp
  8017d8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017da:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dd:	05 00 00 00 30       	add    $0x30000000,%eax
  8017e2:	c1 e8 0c             	shr    $0xc,%eax
}
  8017e5:	5d                   	pop    %ebp
  8017e6:	c3                   	ret    

008017e7 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ed:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8017f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017f7:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8017fc:	5d                   	pop    %ebp
  8017fd:	c3                   	ret    

008017fe <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
  801801:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801806:	89 c2                	mov    %eax,%edx
  801808:	c1 ea 16             	shr    $0x16,%edx
  80180b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801812:	f6 c2 01             	test   $0x1,%dl
  801815:	74 2d                	je     801844 <fd_alloc+0x46>
  801817:	89 c2                	mov    %eax,%edx
  801819:	c1 ea 0c             	shr    $0xc,%edx
  80181c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801823:	f6 c2 01             	test   $0x1,%dl
  801826:	74 1c                	je     801844 <fd_alloc+0x46>
  801828:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80182d:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801832:	75 d2                	jne    801806 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801834:	8b 45 08             	mov    0x8(%ebp),%eax
  801837:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80183d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801842:	eb 0a                	jmp    80184e <fd_alloc+0x50>
			*fd_store = fd;
  801844:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801847:	89 01                	mov    %eax,(%ecx)
			return 0;
  801849:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80184e:	5d                   	pop    %ebp
  80184f:	c3                   	ret    

00801850 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801856:	83 f8 1f             	cmp    $0x1f,%eax
  801859:	77 30                	ja     80188b <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80185b:	c1 e0 0c             	shl    $0xc,%eax
  80185e:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801863:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801869:	f6 c2 01             	test   $0x1,%dl
  80186c:	74 24                	je     801892 <fd_lookup+0x42>
  80186e:	89 c2                	mov    %eax,%edx
  801870:	c1 ea 0c             	shr    $0xc,%edx
  801873:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80187a:	f6 c2 01             	test   $0x1,%dl
  80187d:	74 1a                	je     801899 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80187f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801882:	89 02                	mov    %eax,(%edx)
	return 0;
  801884:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801889:	5d                   	pop    %ebp
  80188a:	c3                   	ret    
		return -E_INVAL;
  80188b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801890:	eb f7                	jmp    801889 <fd_lookup+0x39>
		return -E_INVAL;
  801892:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801897:	eb f0                	jmp    801889 <fd_lookup+0x39>
  801899:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80189e:	eb e9                	jmp    801889 <fd_lookup+0x39>

008018a0 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
  8018a3:	83 ec 08             	sub    $0x8,%esp
  8018a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8018a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ae:	b8 24 40 80 00       	mov    $0x804024,%eax
		if (devtab[i]->dev_id == dev_id) {
  8018b3:	39 08                	cmp    %ecx,(%eax)
  8018b5:	74 38                	je     8018ef <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8018b7:	83 c2 01             	add    $0x1,%edx
  8018ba:	8b 04 95 30 36 80 00 	mov    0x803630(,%edx,4),%eax
  8018c1:	85 c0                	test   %eax,%eax
  8018c3:	75 ee                	jne    8018b3 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8018c5:	a1 1c 50 80 00       	mov    0x80501c,%eax
  8018ca:	8b 40 48             	mov    0x48(%eax),%eax
  8018cd:	83 ec 04             	sub    $0x4,%esp
  8018d0:	51                   	push   %ecx
  8018d1:	50                   	push   %eax
  8018d2:	68 b4 35 80 00       	push   $0x8035b4
  8018d7:	e8 b5 f0 ff ff       	call   800991 <cprintf>
	*dev = 0;
  8018dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8018e5:	83 c4 10             	add    $0x10,%esp
  8018e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8018ed:	c9                   	leave  
  8018ee:	c3                   	ret    
			*dev = devtab[i];
  8018ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018f2:	89 01                	mov    %eax,(%ecx)
			return 0;
  8018f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f9:	eb f2                	jmp    8018ed <dev_lookup+0x4d>

008018fb <fd_close>:
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
  8018fe:	57                   	push   %edi
  8018ff:	56                   	push   %esi
  801900:	53                   	push   %ebx
  801901:	83 ec 24             	sub    $0x24,%esp
  801904:	8b 75 08             	mov    0x8(%ebp),%esi
  801907:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80190a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80190d:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80190e:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801914:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801917:	50                   	push   %eax
  801918:	e8 33 ff ff ff       	call   801850 <fd_lookup>
  80191d:	89 c3                	mov    %eax,%ebx
  80191f:	83 c4 10             	add    $0x10,%esp
  801922:	85 c0                	test   %eax,%eax
  801924:	78 05                	js     80192b <fd_close+0x30>
	    || fd != fd2)
  801926:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801929:	74 16                	je     801941 <fd_close+0x46>
		return (must_exist ? r : 0);
  80192b:	89 f8                	mov    %edi,%eax
  80192d:	84 c0                	test   %al,%al
  80192f:	b8 00 00 00 00       	mov    $0x0,%eax
  801934:	0f 44 d8             	cmove  %eax,%ebx
}
  801937:	89 d8                	mov    %ebx,%eax
  801939:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80193c:	5b                   	pop    %ebx
  80193d:	5e                   	pop    %esi
  80193e:	5f                   	pop    %edi
  80193f:	5d                   	pop    %ebp
  801940:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801941:	83 ec 08             	sub    $0x8,%esp
  801944:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801947:	50                   	push   %eax
  801948:	ff 36                	pushl  (%esi)
  80194a:	e8 51 ff ff ff       	call   8018a0 <dev_lookup>
  80194f:	89 c3                	mov    %eax,%ebx
  801951:	83 c4 10             	add    $0x10,%esp
  801954:	85 c0                	test   %eax,%eax
  801956:	78 1a                	js     801972 <fd_close+0x77>
		if (dev->dev_close)
  801958:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80195b:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80195e:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801963:	85 c0                	test   %eax,%eax
  801965:	74 0b                	je     801972 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801967:	83 ec 0c             	sub    $0xc,%esp
  80196a:	56                   	push   %esi
  80196b:	ff d0                	call   *%eax
  80196d:	89 c3                	mov    %eax,%ebx
  80196f:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801972:	83 ec 08             	sub    $0x8,%esp
  801975:	56                   	push   %esi
  801976:	6a 00                	push   $0x0
  801978:	e8 ea fb ff ff       	call   801567 <sys_page_unmap>
	return r;
  80197d:	83 c4 10             	add    $0x10,%esp
  801980:	eb b5                	jmp    801937 <fd_close+0x3c>

00801982 <close>:

int
close(int fdnum)
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
  801985:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801988:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80198b:	50                   	push   %eax
  80198c:	ff 75 08             	pushl  0x8(%ebp)
  80198f:	e8 bc fe ff ff       	call   801850 <fd_lookup>
  801994:	83 c4 10             	add    $0x10,%esp
  801997:	85 c0                	test   %eax,%eax
  801999:	79 02                	jns    80199d <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80199b:	c9                   	leave  
  80199c:	c3                   	ret    
		return fd_close(fd, 1);
  80199d:	83 ec 08             	sub    $0x8,%esp
  8019a0:	6a 01                	push   $0x1
  8019a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8019a5:	e8 51 ff ff ff       	call   8018fb <fd_close>
  8019aa:	83 c4 10             	add    $0x10,%esp
  8019ad:	eb ec                	jmp    80199b <close+0x19>

008019af <close_all>:

void
close_all(void)
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
  8019b2:	53                   	push   %ebx
  8019b3:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8019b6:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8019bb:	83 ec 0c             	sub    $0xc,%esp
  8019be:	53                   	push   %ebx
  8019bf:	e8 be ff ff ff       	call   801982 <close>
	for (i = 0; i < MAXFD; i++)
  8019c4:	83 c3 01             	add    $0x1,%ebx
  8019c7:	83 c4 10             	add    $0x10,%esp
  8019ca:	83 fb 20             	cmp    $0x20,%ebx
  8019cd:	75 ec                	jne    8019bb <close_all+0xc>
}
  8019cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
  8019d7:	57                   	push   %edi
  8019d8:	56                   	push   %esi
  8019d9:	53                   	push   %ebx
  8019da:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8019dd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8019e0:	50                   	push   %eax
  8019e1:	ff 75 08             	pushl  0x8(%ebp)
  8019e4:	e8 67 fe ff ff       	call   801850 <fd_lookup>
  8019e9:	89 c3                	mov    %eax,%ebx
  8019eb:	83 c4 10             	add    $0x10,%esp
  8019ee:	85 c0                	test   %eax,%eax
  8019f0:	0f 88 81 00 00 00    	js     801a77 <dup+0xa3>
		return r;
	close(newfdnum);
  8019f6:	83 ec 0c             	sub    $0xc,%esp
  8019f9:	ff 75 0c             	pushl  0xc(%ebp)
  8019fc:	e8 81 ff ff ff       	call   801982 <close>

	newfd = INDEX2FD(newfdnum);
  801a01:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a04:	c1 e6 0c             	shl    $0xc,%esi
  801a07:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801a0d:	83 c4 04             	add    $0x4,%esp
  801a10:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a13:	e8 cf fd ff ff       	call   8017e7 <fd2data>
  801a18:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801a1a:	89 34 24             	mov    %esi,(%esp)
  801a1d:	e8 c5 fd ff ff       	call   8017e7 <fd2data>
  801a22:	83 c4 10             	add    $0x10,%esp
  801a25:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801a27:	89 d8                	mov    %ebx,%eax
  801a29:	c1 e8 16             	shr    $0x16,%eax
  801a2c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a33:	a8 01                	test   $0x1,%al
  801a35:	74 11                	je     801a48 <dup+0x74>
  801a37:	89 d8                	mov    %ebx,%eax
  801a39:	c1 e8 0c             	shr    $0xc,%eax
  801a3c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801a43:	f6 c2 01             	test   $0x1,%dl
  801a46:	75 39                	jne    801a81 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a48:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a4b:	89 d0                	mov    %edx,%eax
  801a4d:	c1 e8 0c             	shr    $0xc,%eax
  801a50:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a57:	83 ec 0c             	sub    $0xc,%esp
  801a5a:	25 07 0e 00 00       	and    $0xe07,%eax
  801a5f:	50                   	push   %eax
  801a60:	56                   	push   %esi
  801a61:	6a 00                	push   $0x0
  801a63:	52                   	push   %edx
  801a64:	6a 00                	push   $0x0
  801a66:	e8 ba fa ff ff       	call   801525 <sys_page_map>
  801a6b:	89 c3                	mov    %eax,%ebx
  801a6d:	83 c4 20             	add    $0x20,%esp
  801a70:	85 c0                	test   %eax,%eax
  801a72:	78 31                	js     801aa5 <dup+0xd1>
		goto err;

	return newfdnum;
  801a74:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801a77:	89 d8                	mov    %ebx,%eax
  801a79:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a7c:	5b                   	pop    %ebx
  801a7d:	5e                   	pop    %esi
  801a7e:	5f                   	pop    %edi
  801a7f:	5d                   	pop    %ebp
  801a80:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801a81:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a88:	83 ec 0c             	sub    $0xc,%esp
  801a8b:	25 07 0e 00 00       	and    $0xe07,%eax
  801a90:	50                   	push   %eax
  801a91:	57                   	push   %edi
  801a92:	6a 00                	push   $0x0
  801a94:	53                   	push   %ebx
  801a95:	6a 00                	push   $0x0
  801a97:	e8 89 fa ff ff       	call   801525 <sys_page_map>
  801a9c:	89 c3                	mov    %eax,%ebx
  801a9e:	83 c4 20             	add    $0x20,%esp
  801aa1:	85 c0                	test   %eax,%eax
  801aa3:	79 a3                	jns    801a48 <dup+0x74>
	sys_page_unmap(0, newfd);
  801aa5:	83 ec 08             	sub    $0x8,%esp
  801aa8:	56                   	push   %esi
  801aa9:	6a 00                	push   $0x0
  801aab:	e8 b7 fa ff ff       	call   801567 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801ab0:	83 c4 08             	add    $0x8,%esp
  801ab3:	57                   	push   %edi
  801ab4:	6a 00                	push   $0x0
  801ab6:	e8 ac fa ff ff       	call   801567 <sys_page_unmap>
	return r;
  801abb:	83 c4 10             	add    $0x10,%esp
  801abe:	eb b7                	jmp    801a77 <dup+0xa3>

00801ac0 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
  801ac3:	53                   	push   %ebx
  801ac4:	83 ec 1c             	sub    $0x1c,%esp
  801ac7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801aca:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801acd:	50                   	push   %eax
  801ace:	53                   	push   %ebx
  801acf:	e8 7c fd ff ff       	call   801850 <fd_lookup>
  801ad4:	83 c4 10             	add    $0x10,%esp
  801ad7:	85 c0                	test   %eax,%eax
  801ad9:	78 3f                	js     801b1a <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801adb:	83 ec 08             	sub    $0x8,%esp
  801ade:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ae1:	50                   	push   %eax
  801ae2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ae5:	ff 30                	pushl  (%eax)
  801ae7:	e8 b4 fd ff ff       	call   8018a0 <dev_lookup>
  801aec:	83 c4 10             	add    $0x10,%esp
  801aef:	85 c0                	test   %eax,%eax
  801af1:	78 27                	js     801b1a <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801af3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801af6:	8b 42 08             	mov    0x8(%edx),%eax
  801af9:	83 e0 03             	and    $0x3,%eax
  801afc:	83 f8 01             	cmp    $0x1,%eax
  801aff:	74 1e                	je     801b1f <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b04:	8b 40 08             	mov    0x8(%eax),%eax
  801b07:	85 c0                	test   %eax,%eax
  801b09:	74 35                	je     801b40 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801b0b:	83 ec 04             	sub    $0x4,%esp
  801b0e:	ff 75 10             	pushl  0x10(%ebp)
  801b11:	ff 75 0c             	pushl  0xc(%ebp)
  801b14:	52                   	push   %edx
  801b15:	ff d0                	call   *%eax
  801b17:	83 c4 10             	add    $0x10,%esp
}
  801b1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801b1f:	a1 1c 50 80 00       	mov    0x80501c,%eax
  801b24:	8b 40 48             	mov    0x48(%eax),%eax
  801b27:	83 ec 04             	sub    $0x4,%esp
  801b2a:	53                   	push   %ebx
  801b2b:	50                   	push   %eax
  801b2c:	68 f5 35 80 00       	push   $0x8035f5
  801b31:	e8 5b ee ff ff       	call   800991 <cprintf>
		return -E_INVAL;
  801b36:	83 c4 10             	add    $0x10,%esp
  801b39:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b3e:	eb da                	jmp    801b1a <read+0x5a>
		return -E_NOT_SUPP;
  801b40:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b45:	eb d3                	jmp    801b1a <read+0x5a>

00801b47 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801b47:	55                   	push   %ebp
  801b48:	89 e5                	mov    %esp,%ebp
  801b4a:	57                   	push   %edi
  801b4b:	56                   	push   %esi
  801b4c:	53                   	push   %ebx
  801b4d:	83 ec 0c             	sub    $0xc,%esp
  801b50:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b53:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b56:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b5b:	39 f3                	cmp    %esi,%ebx
  801b5d:	73 23                	jae    801b82 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b5f:	83 ec 04             	sub    $0x4,%esp
  801b62:	89 f0                	mov    %esi,%eax
  801b64:	29 d8                	sub    %ebx,%eax
  801b66:	50                   	push   %eax
  801b67:	89 d8                	mov    %ebx,%eax
  801b69:	03 45 0c             	add    0xc(%ebp),%eax
  801b6c:	50                   	push   %eax
  801b6d:	57                   	push   %edi
  801b6e:	e8 4d ff ff ff       	call   801ac0 <read>
		if (m < 0)
  801b73:	83 c4 10             	add    $0x10,%esp
  801b76:	85 c0                	test   %eax,%eax
  801b78:	78 06                	js     801b80 <readn+0x39>
			return m;
		if (m == 0)
  801b7a:	74 06                	je     801b82 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801b7c:	01 c3                	add    %eax,%ebx
  801b7e:	eb db                	jmp    801b5b <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b80:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801b82:	89 d8                	mov    %ebx,%eax
  801b84:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b87:	5b                   	pop    %ebx
  801b88:	5e                   	pop    %esi
  801b89:	5f                   	pop    %edi
  801b8a:	5d                   	pop    %ebp
  801b8b:	c3                   	ret    

00801b8c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
  801b8f:	53                   	push   %ebx
  801b90:	83 ec 1c             	sub    $0x1c,%esp
  801b93:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b96:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b99:	50                   	push   %eax
  801b9a:	53                   	push   %ebx
  801b9b:	e8 b0 fc ff ff       	call   801850 <fd_lookup>
  801ba0:	83 c4 10             	add    $0x10,%esp
  801ba3:	85 c0                	test   %eax,%eax
  801ba5:	78 3a                	js     801be1 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ba7:	83 ec 08             	sub    $0x8,%esp
  801baa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bad:	50                   	push   %eax
  801bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bb1:	ff 30                	pushl  (%eax)
  801bb3:	e8 e8 fc ff ff       	call   8018a0 <dev_lookup>
  801bb8:	83 c4 10             	add    $0x10,%esp
  801bbb:	85 c0                	test   %eax,%eax
  801bbd:	78 22                	js     801be1 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801bbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bc2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801bc6:	74 1e                	je     801be6 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801bc8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bcb:	8b 52 0c             	mov    0xc(%edx),%edx
  801bce:	85 d2                	test   %edx,%edx
  801bd0:	74 35                	je     801c07 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801bd2:	83 ec 04             	sub    $0x4,%esp
  801bd5:	ff 75 10             	pushl  0x10(%ebp)
  801bd8:	ff 75 0c             	pushl  0xc(%ebp)
  801bdb:	50                   	push   %eax
  801bdc:	ff d2                	call   *%edx
  801bde:	83 c4 10             	add    $0x10,%esp
}
  801be1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801be6:	a1 1c 50 80 00       	mov    0x80501c,%eax
  801beb:	8b 40 48             	mov    0x48(%eax),%eax
  801bee:	83 ec 04             	sub    $0x4,%esp
  801bf1:	53                   	push   %ebx
  801bf2:	50                   	push   %eax
  801bf3:	68 11 36 80 00       	push   $0x803611
  801bf8:	e8 94 ed ff ff       	call   800991 <cprintf>
		return -E_INVAL;
  801bfd:	83 c4 10             	add    $0x10,%esp
  801c00:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c05:	eb da                	jmp    801be1 <write+0x55>
		return -E_NOT_SUPP;
  801c07:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c0c:	eb d3                	jmp    801be1 <write+0x55>

00801c0e <seek>:

int
seek(int fdnum, off_t offset)
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
  801c11:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c14:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c17:	50                   	push   %eax
  801c18:	ff 75 08             	pushl  0x8(%ebp)
  801c1b:	e8 30 fc ff ff       	call   801850 <fd_lookup>
  801c20:	83 c4 10             	add    $0x10,%esp
  801c23:	85 c0                	test   %eax,%eax
  801c25:	78 0e                	js     801c35 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801c27:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2d:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801c30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    

00801c37 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
  801c3a:	53                   	push   %ebx
  801c3b:	83 ec 1c             	sub    $0x1c,%esp
  801c3e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c41:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c44:	50                   	push   %eax
  801c45:	53                   	push   %ebx
  801c46:	e8 05 fc ff ff       	call   801850 <fd_lookup>
  801c4b:	83 c4 10             	add    $0x10,%esp
  801c4e:	85 c0                	test   %eax,%eax
  801c50:	78 37                	js     801c89 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c52:	83 ec 08             	sub    $0x8,%esp
  801c55:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c58:	50                   	push   %eax
  801c59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c5c:	ff 30                	pushl  (%eax)
  801c5e:	e8 3d fc ff ff       	call   8018a0 <dev_lookup>
  801c63:	83 c4 10             	add    $0x10,%esp
  801c66:	85 c0                	test   %eax,%eax
  801c68:	78 1f                	js     801c89 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c6d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c71:	74 1b                	je     801c8e <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801c73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c76:	8b 52 18             	mov    0x18(%edx),%edx
  801c79:	85 d2                	test   %edx,%edx
  801c7b:	74 32                	je     801caf <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801c7d:	83 ec 08             	sub    $0x8,%esp
  801c80:	ff 75 0c             	pushl  0xc(%ebp)
  801c83:	50                   	push   %eax
  801c84:	ff d2                	call   *%edx
  801c86:	83 c4 10             	add    $0x10,%esp
}
  801c89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c8c:	c9                   	leave  
  801c8d:	c3                   	ret    
			thisenv->env_id, fdnum);
  801c8e:	a1 1c 50 80 00       	mov    0x80501c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801c93:	8b 40 48             	mov    0x48(%eax),%eax
  801c96:	83 ec 04             	sub    $0x4,%esp
  801c99:	53                   	push   %ebx
  801c9a:	50                   	push   %eax
  801c9b:	68 d4 35 80 00       	push   $0x8035d4
  801ca0:	e8 ec ec ff ff       	call   800991 <cprintf>
		return -E_INVAL;
  801ca5:	83 c4 10             	add    $0x10,%esp
  801ca8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801cad:	eb da                	jmp    801c89 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801caf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801cb4:	eb d3                	jmp    801c89 <ftruncate+0x52>

00801cb6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
  801cb9:	53                   	push   %ebx
  801cba:	83 ec 1c             	sub    $0x1c,%esp
  801cbd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801cc0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cc3:	50                   	push   %eax
  801cc4:	ff 75 08             	pushl  0x8(%ebp)
  801cc7:	e8 84 fb ff ff       	call   801850 <fd_lookup>
  801ccc:	83 c4 10             	add    $0x10,%esp
  801ccf:	85 c0                	test   %eax,%eax
  801cd1:	78 4b                	js     801d1e <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801cd3:	83 ec 08             	sub    $0x8,%esp
  801cd6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cd9:	50                   	push   %eax
  801cda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cdd:	ff 30                	pushl  (%eax)
  801cdf:	e8 bc fb ff ff       	call   8018a0 <dev_lookup>
  801ce4:	83 c4 10             	add    $0x10,%esp
  801ce7:	85 c0                	test   %eax,%eax
  801ce9:	78 33                	js     801d1e <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cee:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801cf2:	74 2f                	je     801d23 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801cf4:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801cf7:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801cfe:	00 00 00 
	stat->st_isdir = 0;
  801d01:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d08:	00 00 00 
	stat->st_dev = dev;
  801d0b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801d11:	83 ec 08             	sub    $0x8,%esp
  801d14:	53                   	push   %ebx
  801d15:	ff 75 f0             	pushl  -0x10(%ebp)
  801d18:	ff 50 14             	call   *0x14(%eax)
  801d1b:	83 c4 10             	add    $0x10,%esp
}
  801d1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d21:	c9                   	leave  
  801d22:	c3                   	ret    
		return -E_NOT_SUPP;
  801d23:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d28:	eb f4                	jmp    801d1e <fstat+0x68>

00801d2a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
  801d2d:	56                   	push   %esi
  801d2e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801d2f:	83 ec 08             	sub    $0x8,%esp
  801d32:	6a 00                	push   $0x0
  801d34:	ff 75 08             	pushl  0x8(%ebp)
  801d37:	e8 22 02 00 00       	call   801f5e <open>
  801d3c:	89 c3                	mov    %eax,%ebx
  801d3e:	83 c4 10             	add    $0x10,%esp
  801d41:	85 c0                	test   %eax,%eax
  801d43:	78 1b                	js     801d60 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801d45:	83 ec 08             	sub    $0x8,%esp
  801d48:	ff 75 0c             	pushl  0xc(%ebp)
  801d4b:	50                   	push   %eax
  801d4c:	e8 65 ff ff ff       	call   801cb6 <fstat>
  801d51:	89 c6                	mov    %eax,%esi
	close(fd);
  801d53:	89 1c 24             	mov    %ebx,(%esp)
  801d56:	e8 27 fc ff ff       	call   801982 <close>
	return r;
  801d5b:	83 c4 10             	add    $0x10,%esp
  801d5e:	89 f3                	mov    %esi,%ebx
}
  801d60:	89 d8                	mov    %ebx,%eax
  801d62:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d65:	5b                   	pop    %ebx
  801d66:	5e                   	pop    %esi
  801d67:	5d                   	pop    %ebp
  801d68:	c3                   	ret    

00801d69 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
  801d6c:	56                   	push   %esi
  801d6d:	53                   	push   %ebx
  801d6e:	89 c6                	mov    %eax,%esi
  801d70:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801d72:	83 3d 10 50 80 00 00 	cmpl   $0x0,0x805010
  801d79:	74 27                	je     801da2 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801d7b:	6a 07                	push   $0x7
  801d7d:	68 00 60 80 00       	push   $0x806000
  801d82:	56                   	push   %esi
  801d83:	ff 35 10 50 80 00    	pushl  0x805010
  801d89:	e8 a1 0e 00 00       	call   802c2f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801d8e:	83 c4 0c             	add    $0xc,%esp
  801d91:	6a 00                	push   $0x0
  801d93:	53                   	push   %ebx
  801d94:	6a 00                	push   $0x0
  801d96:	e8 2b 0e 00 00       	call   802bc6 <ipc_recv>
}
  801d9b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d9e:	5b                   	pop    %ebx
  801d9f:	5e                   	pop    %esi
  801da0:	5d                   	pop    %ebp
  801da1:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801da2:	83 ec 0c             	sub    $0xc,%esp
  801da5:	6a 01                	push   $0x1
  801da7:	e8 db 0e 00 00       	call   802c87 <ipc_find_env>
  801dac:	a3 10 50 80 00       	mov    %eax,0x805010
  801db1:	83 c4 10             	add    $0x10,%esp
  801db4:	eb c5                	jmp    801d7b <fsipc+0x12>

00801db6 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
  801db9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbf:	8b 40 0c             	mov    0xc(%eax),%eax
  801dc2:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801dc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dca:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801dcf:	ba 00 00 00 00       	mov    $0x0,%edx
  801dd4:	b8 02 00 00 00       	mov    $0x2,%eax
  801dd9:	e8 8b ff ff ff       	call   801d69 <fsipc>
}
  801dde:	c9                   	leave  
  801ddf:	c3                   	ret    

00801de0 <devfile_flush>:
{
  801de0:	55                   	push   %ebp
  801de1:	89 e5                	mov    %esp,%ebp
  801de3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801de6:	8b 45 08             	mov    0x8(%ebp),%eax
  801de9:	8b 40 0c             	mov    0xc(%eax),%eax
  801dec:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801df1:	ba 00 00 00 00       	mov    $0x0,%edx
  801df6:	b8 06 00 00 00       	mov    $0x6,%eax
  801dfb:	e8 69 ff ff ff       	call   801d69 <fsipc>
}
  801e00:	c9                   	leave  
  801e01:	c3                   	ret    

00801e02 <devfile_stat>:
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
  801e05:	53                   	push   %ebx
  801e06:	83 ec 04             	sub    $0x4,%esp
  801e09:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0f:	8b 40 0c             	mov    0xc(%eax),%eax
  801e12:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801e17:	ba 00 00 00 00       	mov    $0x0,%edx
  801e1c:	b8 05 00 00 00       	mov    $0x5,%eax
  801e21:	e8 43 ff ff ff       	call   801d69 <fsipc>
  801e26:	85 c0                	test   %eax,%eax
  801e28:	78 2c                	js     801e56 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801e2a:	83 ec 08             	sub    $0x8,%esp
  801e2d:	68 00 60 80 00       	push   $0x806000
  801e32:	53                   	push   %ebx
  801e33:	e8 b8 f2 ff ff       	call   8010f0 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801e38:	a1 80 60 80 00       	mov    0x806080,%eax
  801e3d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801e43:	a1 84 60 80 00       	mov    0x806084,%eax
  801e48:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801e4e:	83 c4 10             	add    $0x10,%esp
  801e51:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e59:	c9                   	leave  
  801e5a:	c3                   	ret    

00801e5b <devfile_write>:
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
  801e5e:	53                   	push   %ebx
  801e5f:	83 ec 08             	sub    $0x8,%esp
  801e62:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e65:	8b 45 08             	mov    0x8(%ebp),%eax
  801e68:	8b 40 0c             	mov    0xc(%eax),%eax
  801e6b:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801e70:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801e76:	53                   	push   %ebx
  801e77:	ff 75 0c             	pushl  0xc(%ebp)
  801e7a:	68 08 60 80 00       	push   $0x806008
  801e7f:	e8 5c f4 ff ff       	call   8012e0 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801e84:	ba 00 00 00 00       	mov    $0x0,%edx
  801e89:	b8 04 00 00 00       	mov    $0x4,%eax
  801e8e:	e8 d6 fe ff ff       	call   801d69 <fsipc>
  801e93:	83 c4 10             	add    $0x10,%esp
  801e96:	85 c0                	test   %eax,%eax
  801e98:	78 0b                	js     801ea5 <devfile_write+0x4a>
	assert(r <= n);
  801e9a:	39 d8                	cmp    %ebx,%eax
  801e9c:	77 0c                	ja     801eaa <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801e9e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ea3:	7f 1e                	jg     801ec3 <devfile_write+0x68>
}
  801ea5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ea8:	c9                   	leave  
  801ea9:	c3                   	ret    
	assert(r <= n);
  801eaa:	68 44 36 80 00       	push   $0x803644
  801eaf:	68 4b 36 80 00       	push   $0x80364b
  801eb4:	68 98 00 00 00       	push   $0x98
  801eb9:	68 60 36 80 00       	push   $0x803660
  801ebe:	e8 d8 e9 ff ff       	call   80089b <_panic>
	assert(r <= PGSIZE);
  801ec3:	68 6b 36 80 00       	push   $0x80366b
  801ec8:	68 4b 36 80 00       	push   $0x80364b
  801ecd:	68 99 00 00 00       	push   $0x99
  801ed2:	68 60 36 80 00       	push   $0x803660
  801ed7:	e8 bf e9 ff ff       	call   80089b <_panic>

00801edc <devfile_read>:
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
  801edf:	56                   	push   %esi
  801ee0:	53                   	push   %ebx
  801ee1:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee7:	8b 40 0c             	mov    0xc(%eax),%eax
  801eea:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801eef:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801ef5:	ba 00 00 00 00       	mov    $0x0,%edx
  801efa:	b8 03 00 00 00       	mov    $0x3,%eax
  801eff:	e8 65 fe ff ff       	call   801d69 <fsipc>
  801f04:	89 c3                	mov    %eax,%ebx
  801f06:	85 c0                	test   %eax,%eax
  801f08:	78 1f                	js     801f29 <devfile_read+0x4d>
	assert(r <= n);
  801f0a:	39 f0                	cmp    %esi,%eax
  801f0c:	77 24                	ja     801f32 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801f0e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f13:	7f 33                	jg     801f48 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801f15:	83 ec 04             	sub    $0x4,%esp
  801f18:	50                   	push   %eax
  801f19:	68 00 60 80 00       	push   $0x806000
  801f1e:	ff 75 0c             	pushl  0xc(%ebp)
  801f21:	e8 58 f3 ff ff       	call   80127e <memmove>
	return r;
  801f26:	83 c4 10             	add    $0x10,%esp
}
  801f29:	89 d8                	mov    %ebx,%eax
  801f2b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f2e:	5b                   	pop    %ebx
  801f2f:	5e                   	pop    %esi
  801f30:	5d                   	pop    %ebp
  801f31:	c3                   	ret    
	assert(r <= n);
  801f32:	68 44 36 80 00       	push   $0x803644
  801f37:	68 4b 36 80 00       	push   $0x80364b
  801f3c:	6a 7c                	push   $0x7c
  801f3e:	68 60 36 80 00       	push   $0x803660
  801f43:	e8 53 e9 ff ff       	call   80089b <_panic>
	assert(r <= PGSIZE);
  801f48:	68 6b 36 80 00       	push   $0x80366b
  801f4d:	68 4b 36 80 00       	push   $0x80364b
  801f52:	6a 7d                	push   $0x7d
  801f54:	68 60 36 80 00       	push   $0x803660
  801f59:	e8 3d e9 ff ff       	call   80089b <_panic>

00801f5e <open>:
{
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
  801f61:	56                   	push   %esi
  801f62:	53                   	push   %ebx
  801f63:	83 ec 1c             	sub    $0x1c,%esp
  801f66:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801f69:	56                   	push   %esi
  801f6a:	e8 48 f1 ff ff       	call   8010b7 <strlen>
  801f6f:	83 c4 10             	add    $0x10,%esp
  801f72:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f77:	7f 6c                	jg     801fe5 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801f79:	83 ec 0c             	sub    $0xc,%esp
  801f7c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f7f:	50                   	push   %eax
  801f80:	e8 79 f8 ff ff       	call   8017fe <fd_alloc>
  801f85:	89 c3                	mov    %eax,%ebx
  801f87:	83 c4 10             	add    $0x10,%esp
  801f8a:	85 c0                	test   %eax,%eax
  801f8c:	78 3c                	js     801fca <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801f8e:	83 ec 08             	sub    $0x8,%esp
  801f91:	56                   	push   %esi
  801f92:	68 00 60 80 00       	push   $0x806000
  801f97:	e8 54 f1 ff ff       	call   8010f0 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801f9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f9f:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801fa4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fa7:	b8 01 00 00 00       	mov    $0x1,%eax
  801fac:	e8 b8 fd ff ff       	call   801d69 <fsipc>
  801fb1:	89 c3                	mov    %eax,%ebx
  801fb3:	83 c4 10             	add    $0x10,%esp
  801fb6:	85 c0                	test   %eax,%eax
  801fb8:	78 19                	js     801fd3 <open+0x75>
	return fd2num(fd);
  801fba:	83 ec 0c             	sub    $0xc,%esp
  801fbd:	ff 75 f4             	pushl  -0xc(%ebp)
  801fc0:	e8 12 f8 ff ff       	call   8017d7 <fd2num>
  801fc5:	89 c3                	mov    %eax,%ebx
  801fc7:	83 c4 10             	add    $0x10,%esp
}
  801fca:	89 d8                	mov    %ebx,%eax
  801fcc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fcf:	5b                   	pop    %ebx
  801fd0:	5e                   	pop    %esi
  801fd1:	5d                   	pop    %ebp
  801fd2:	c3                   	ret    
		fd_close(fd, 0);
  801fd3:	83 ec 08             	sub    $0x8,%esp
  801fd6:	6a 00                	push   $0x0
  801fd8:	ff 75 f4             	pushl  -0xc(%ebp)
  801fdb:	e8 1b f9 ff ff       	call   8018fb <fd_close>
		return r;
  801fe0:	83 c4 10             	add    $0x10,%esp
  801fe3:	eb e5                	jmp    801fca <open+0x6c>
		return -E_BAD_PATH;
  801fe5:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801fea:	eb de                	jmp    801fca <open+0x6c>

00801fec <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
  801fef:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ff2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ff7:	b8 08 00 00 00       	mov    $0x8,%eax
  801ffc:	e8 68 fd ff ff       	call   801d69 <fsipc>
}
  802001:	c9                   	leave  
  802002:	c3                   	ret    

00802003 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802003:	55                   	push   %ebp
  802004:	89 e5                	mov    %esp,%ebp
  802006:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  802009:	68 77 36 80 00       	push   $0x803677
  80200e:	ff 75 0c             	pushl  0xc(%ebp)
  802011:	e8 da f0 ff ff       	call   8010f0 <strcpy>
	return 0;
}
  802016:	b8 00 00 00 00       	mov    $0x0,%eax
  80201b:	c9                   	leave  
  80201c:	c3                   	ret    

0080201d <devsock_close>:
{
  80201d:	55                   	push   %ebp
  80201e:	89 e5                	mov    %esp,%ebp
  802020:	53                   	push   %ebx
  802021:	83 ec 10             	sub    $0x10,%esp
  802024:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  802027:	53                   	push   %ebx
  802028:	e8 99 0c 00 00       	call   802cc6 <pageref>
  80202d:	83 c4 10             	add    $0x10,%esp
		return 0;
  802030:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  802035:	83 f8 01             	cmp    $0x1,%eax
  802038:	74 07                	je     802041 <devsock_close+0x24>
}
  80203a:	89 d0                	mov    %edx,%eax
  80203c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80203f:	c9                   	leave  
  802040:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  802041:	83 ec 0c             	sub    $0xc,%esp
  802044:	ff 73 0c             	pushl  0xc(%ebx)
  802047:	e8 b9 02 00 00       	call   802305 <nsipc_close>
  80204c:	89 c2                	mov    %eax,%edx
  80204e:	83 c4 10             	add    $0x10,%esp
  802051:	eb e7                	jmp    80203a <devsock_close+0x1d>

00802053 <devsock_write>:
{
  802053:	55                   	push   %ebp
  802054:	89 e5                	mov    %esp,%ebp
  802056:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802059:	6a 00                	push   $0x0
  80205b:	ff 75 10             	pushl  0x10(%ebp)
  80205e:	ff 75 0c             	pushl  0xc(%ebp)
  802061:	8b 45 08             	mov    0x8(%ebp),%eax
  802064:	ff 70 0c             	pushl  0xc(%eax)
  802067:	e8 76 03 00 00       	call   8023e2 <nsipc_send>
}
  80206c:	c9                   	leave  
  80206d:	c3                   	ret    

0080206e <devsock_read>:
{
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
  802071:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802074:	6a 00                	push   $0x0
  802076:	ff 75 10             	pushl  0x10(%ebp)
  802079:	ff 75 0c             	pushl  0xc(%ebp)
  80207c:	8b 45 08             	mov    0x8(%ebp),%eax
  80207f:	ff 70 0c             	pushl  0xc(%eax)
  802082:	e8 ef 02 00 00       	call   802376 <nsipc_recv>
}
  802087:	c9                   	leave  
  802088:	c3                   	ret    

00802089 <fd2sockid>:
{
  802089:	55                   	push   %ebp
  80208a:	89 e5                	mov    %esp,%ebp
  80208c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80208f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802092:	52                   	push   %edx
  802093:	50                   	push   %eax
  802094:	e8 b7 f7 ff ff       	call   801850 <fd_lookup>
  802099:	83 c4 10             	add    $0x10,%esp
  80209c:	85 c0                	test   %eax,%eax
  80209e:	78 10                	js     8020b0 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8020a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a3:	8b 0d 40 40 80 00    	mov    0x804040,%ecx
  8020a9:	39 08                	cmp    %ecx,(%eax)
  8020ab:	75 05                	jne    8020b2 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8020ad:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8020b0:	c9                   	leave  
  8020b1:	c3                   	ret    
		return -E_NOT_SUPP;
  8020b2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8020b7:	eb f7                	jmp    8020b0 <fd2sockid+0x27>

008020b9 <alloc_sockfd>:
{
  8020b9:	55                   	push   %ebp
  8020ba:	89 e5                	mov    %esp,%ebp
  8020bc:	56                   	push   %esi
  8020bd:	53                   	push   %ebx
  8020be:	83 ec 1c             	sub    $0x1c,%esp
  8020c1:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8020c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020c6:	50                   	push   %eax
  8020c7:	e8 32 f7 ff ff       	call   8017fe <fd_alloc>
  8020cc:	89 c3                	mov    %eax,%ebx
  8020ce:	83 c4 10             	add    $0x10,%esp
  8020d1:	85 c0                	test   %eax,%eax
  8020d3:	78 43                	js     802118 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8020d5:	83 ec 04             	sub    $0x4,%esp
  8020d8:	68 07 04 00 00       	push   $0x407
  8020dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8020e0:	6a 00                	push   $0x0
  8020e2:	e8 fb f3 ff ff       	call   8014e2 <sys_page_alloc>
  8020e7:	89 c3                	mov    %eax,%ebx
  8020e9:	83 c4 10             	add    $0x10,%esp
  8020ec:	85 c0                	test   %eax,%eax
  8020ee:	78 28                	js     802118 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8020f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f3:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8020f9:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8020fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fe:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802105:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802108:	83 ec 0c             	sub    $0xc,%esp
  80210b:	50                   	push   %eax
  80210c:	e8 c6 f6 ff ff       	call   8017d7 <fd2num>
  802111:	89 c3                	mov    %eax,%ebx
  802113:	83 c4 10             	add    $0x10,%esp
  802116:	eb 0c                	jmp    802124 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802118:	83 ec 0c             	sub    $0xc,%esp
  80211b:	56                   	push   %esi
  80211c:	e8 e4 01 00 00       	call   802305 <nsipc_close>
		return r;
  802121:	83 c4 10             	add    $0x10,%esp
}
  802124:	89 d8                	mov    %ebx,%eax
  802126:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802129:	5b                   	pop    %ebx
  80212a:	5e                   	pop    %esi
  80212b:	5d                   	pop    %ebp
  80212c:	c3                   	ret    

0080212d <accept>:
{
  80212d:	55                   	push   %ebp
  80212e:	89 e5                	mov    %esp,%ebp
  802130:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802133:	8b 45 08             	mov    0x8(%ebp),%eax
  802136:	e8 4e ff ff ff       	call   802089 <fd2sockid>
  80213b:	85 c0                	test   %eax,%eax
  80213d:	78 1b                	js     80215a <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80213f:	83 ec 04             	sub    $0x4,%esp
  802142:	ff 75 10             	pushl  0x10(%ebp)
  802145:	ff 75 0c             	pushl  0xc(%ebp)
  802148:	50                   	push   %eax
  802149:	e8 0e 01 00 00       	call   80225c <nsipc_accept>
  80214e:	83 c4 10             	add    $0x10,%esp
  802151:	85 c0                	test   %eax,%eax
  802153:	78 05                	js     80215a <accept+0x2d>
	return alloc_sockfd(r);
  802155:	e8 5f ff ff ff       	call   8020b9 <alloc_sockfd>
}
  80215a:	c9                   	leave  
  80215b:	c3                   	ret    

0080215c <bind>:
{
  80215c:	55                   	push   %ebp
  80215d:	89 e5                	mov    %esp,%ebp
  80215f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802162:	8b 45 08             	mov    0x8(%ebp),%eax
  802165:	e8 1f ff ff ff       	call   802089 <fd2sockid>
  80216a:	85 c0                	test   %eax,%eax
  80216c:	78 12                	js     802180 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80216e:	83 ec 04             	sub    $0x4,%esp
  802171:	ff 75 10             	pushl  0x10(%ebp)
  802174:	ff 75 0c             	pushl  0xc(%ebp)
  802177:	50                   	push   %eax
  802178:	e8 31 01 00 00       	call   8022ae <nsipc_bind>
  80217d:	83 c4 10             	add    $0x10,%esp
}
  802180:	c9                   	leave  
  802181:	c3                   	ret    

00802182 <shutdown>:
{
  802182:	55                   	push   %ebp
  802183:	89 e5                	mov    %esp,%ebp
  802185:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802188:	8b 45 08             	mov    0x8(%ebp),%eax
  80218b:	e8 f9 fe ff ff       	call   802089 <fd2sockid>
  802190:	85 c0                	test   %eax,%eax
  802192:	78 0f                	js     8021a3 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802194:	83 ec 08             	sub    $0x8,%esp
  802197:	ff 75 0c             	pushl  0xc(%ebp)
  80219a:	50                   	push   %eax
  80219b:	e8 43 01 00 00       	call   8022e3 <nsipc_shutdown>
  8021a0:	83 c4 10             	add    $0x10,%esp
}
  8021a3:	c9                   	leave  
  8021a4:	c3                   	ret    

008021a5 <connect>:
{
  8021a5:	55                   	push   %ebp
  8021a6:	89 e5                	mov    %esp,%ebp
  8021a8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ae:	e8 d6 fe ff ff       	call   802089 <fd2sockid>
  8021b3:	85 c0                	test   %eax,%eax
  8021b5:	78 12                	js     8021c9 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8021b7:	83 ec 04             	sub    $0x4,%esp
  8021ba:	ff 75 10             	pushl  0x10(%ebp)
  8021bd:	ff 75 0c             	pushl  0xc(%ebp)
  8021c0:	50                   	push   %eax
  8021c1:	e8 59 01 00 00       	call   80231f <nsipc_connect>
  8021c6:	83 c4 10             	add    $0x10,%esp
}
  8021c9:	c9                   	leave  
  8021ca:	c3                   	ret    

008021cb <listen>:
{
  8021cb:	55                   	push   %ebp
  8021cc:	89 e5                	mov    %esp,%ebp
  8021ce:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d4:	e8 b0 fe ff ff       	call   802089 <fd2sockid>
  8021d9:	85 c0                	test   %eax,%eax
  8021db:	78 0f                	js     8021ec <listen+0x21>
	return nsipc_listen(r, backlog);
  8021dd:	83 ec 08             	sub    $0x8,%esp
  8021e0:	ff 75 0c             	pushl  0xc(%ebp)
  8021e3:	50                   	push   %eax
  8021e4:	e8 6b 01 00 00       	call   802354 <nsipc_listen>
  8021e9:	83 c4 10             	add    $0x10,%esp
}
  8021ec:	c9                   	leave  
  8021ed:	c3                   	ret    

008021ee <socket>:

int
socket(int domain, int type, int protocol)
{
  8021ee:	55                   	push   %ebp
  8021ef:	89 e5                	mov    %esp,%ebp
  8021f1:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8021f4:	ff 75 10             	pushl  0x10(%ebp)
  8021f7:	ff 75 0c             	pushl  0xc(%ebp)
  8021fa:	ff 75 08             	pushl  0x8(%ebp)
  8021fd:	e8 3e 02 00 00       	call   802440 <nsipc_socket>
  802202:	83 c4 10             	add    $0x10,%esp
  802205:	85 c0                	test   %eax,%eax
  802207:	78 05                	js     80220e <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802209:	e8 ab fe ff ff       	call   8020b9 <alloc_sockfd>
}
  80220e:	c9                   	leave  
  80220f:	c3                   	ret    

00802210 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802210:	55                   	push   %ebp
  802211:	89 e5                	mov    %esp,%ebp
  802213:	53                   	push   %ebx
  802214:	83 ec 04             	sub    $0x4,%esp
  802217:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802219:	83 3d 14 50 80 00 00 	cmpl   $0x0,0x805014
  802220:	74 26                	je     802248 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802222:	6a 07                	push   $0x7
  802224:	68 00 70 80 00       	push   $0x807000
  802229:	53                   	push   %ebx
  80222a:	ff 35 14 50 80 00    	pushl  0x805014
  802230:	e8 fa 09 00 00       	call   802c2f <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802235:	83 c4 0c             	add    $0xc,%esp
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	e8 83 09 00 00       	call   802bc6 <ipc_recv>
}
  802243:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802246:	c9                   	leave  
  802247:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802248:	83 ec 0c             	sub    $0xc,%esp
  80224b:	6a 02                	push   $0x2
  80224d:	e8 35 0a 00 00       	call   802c87 <ipc_find_env>
  802252:	a3 14 50 80 00       	mov    %eax,0x805014
  802257:	83 c4 10             	add    $0x10,%esp
  80225a:	eb c6                	jmp    802222 <nsipc+0x12>

0080225c <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80225c:	55                   	push   %ebp
  80225d:	89 e5                	mov    %esp,%ebp
  80225f:	56                   	push   %esi
  802260:	53                   	push   %ebx
  802261:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802264:	8b 45 08             	mov    0x8(%ebp),%eax
  802267:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80226c:	8b 06                	mov    (%esi),%eax
  80226e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802273:	b8 01 00 00 00       	mov    $0x1,%eax
  802278:	e8 93 ff ff ff       	call   802210 <nsipc>
  80227d:	89 c3                	mov    %eax,%ebx
  80227f:	85 c0                	test   %eax,%eax
  802281:	79 09                	jns    80228c <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802283:	89 d8                	mov    %ebx,%eax
  802285:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802288:	5b                   	pop    %ebx
  802289:	5e                   	pop    %esi
  80228a:	5d                   	pop    %ebp
  80228b:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80228c:	83 ec 04             	sub    $0x4,%esp
  80228f:	ff 35 10 70 80 00    	pushl  0x807010
  802295:	68 00 70 80 00       	push   $0x807000
  80229a:	ff 75 0c             	pushl  0xc(%ebp)
  80229d:	e8 dc ef ff ff       	call   80127e <memmove>
		*addrlen = ret->ret_addrlen;
  8022a2:	a1 10 70 80 00       	mov    0x807010,%eax
  8022a7:	89 06                	mov    %eax,(%esi)
  8022a9:	83 c4 10             	add    $0x10,%esp
	return r;
  8022ac:	eb d5                	jmp    802283 <nsipc_accept+0x27>

008022ae <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8022ae:	55                   	push   %ebp
  8022af:	89 e5                	mov    %esp,%ebp
  8022b1:	53                   	push   %ebx
  8022b2:	83 ec 08             	sub    $0x8,%esp
  8022b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8022b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bb:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8022c0:	53                   	push   %ebx
  8022c1:	ff 75 0c             	pushl  0xc(%ebp)
  8022c4:	68 04 70 80 00       	push   $0x807004
  8022c9:	e8 b0 ef ff ff       	call   80127e <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8022ce:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8022d4:	b8 02 00 00 00       	mov    $0x2,%eax
  8022d9:	e8 32 ff ff ff       	call   802210 <nsipc>
}
  8022de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022e1:	c9                   	leave  
  8022e2:	c3                   	ret    

008022e3 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8022e3:	55                   	push   %ebp
  8022e4:	89 e5                	mov    %esp,%ebp
  8022e6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8022e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ec:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8022f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f4:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8022f9:	b8 03 00 00 00       	mov    $0x3,%eax
  8022fe:	e8 0d ff ff ff       	call   802210 <nsipc>
}
  802303:	c9                   	leave  
  802304:	c3                   	ret    

00802305 <nsipc_close>:

int
nsipc_close(int s)
{
  802305:	55                   	push   %ebp
  802306:	89 e5                	mov    %esp,%ebp
  802308:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80230b:	8b 45 08             	mov    0x8(%ebp),%eax
  80230e:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802313:	b8 04 00 00 00       	mov    $0x4,%eax
  802318:	e8 f3 fe ff ff       	call   802210 <nsipc>
}
  80231d:	c9                   	leave  
  80231e:	c3                   	ret    

0080231f <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80231f:	55                   	push   %ebp
  802320:	89 e5                	mov    %esp,%ebp
  802322:	53                   	push   %ebx
  802323:	83 ec 08             	sub    $0x8,%esp
  802326:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802329:	8b 45 08             	mov    0x8(%ebp),%eax
  80232c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802331:	53                   	push   %ebx
  802332:	ff 75 0c             	pushl  0xc(%ebp)
  802335:	68 04 70 80 00       	push   $0x807004
  80233a:	e8 3f ef ff ff       	call   80127e <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80233f:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802345:	b8 05 00 00 00       	mov    $0x5,%eax
  80234a:	e8 c1 fe ff ff       	call   802210 <nsipc>
}
  80234f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802352:	c9                   	leave  
  802353:	c3                   	ret    

00802354 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802354:	55                   	push   %ebp
  802355:	89 e5                	mov    %esp,%ebp
  802357:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80235a:	8b 45 08             	mov    0x8(%ebp),%eax
  80235d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802362:	8b 45 0c             	mov    0xc(%ebp),%eax
  802365:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80236a:	b8 06 00 00 00       	mov    $0x6,%eax
  80236f:	e8 9c fe ff ff       	call   802210 <nsipc>
}
  802374:	c9                   	leave  
  802375:	c3                   	ret    

00802376 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802376:	55                   	push   %ebp
  802377:	89 e5                	mov    %esp,%ebp
  802379:	56                   	push   %esi
  80237a:	53                   	push   %ebx
  80237b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80237e:	8b 45 08             	mov    0x8(%ebp),%eax
  802381:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802386:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80238c:	8b 45 14             	mov    0x14(%ebp),%eax
  80238f:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802394:	b8 07 00 00 00       	mov    $0x7,%eax
  802399:	e8 72 fe ff ff       	call   802210 <nsipc>
  80239e:	89 c3                	mov    %eax,%ebx
  8023a0:	85 c0                	test   %eax,%eax
  8023a2:	78 1f                	js     8023c3 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8023a4:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8023a9:	7f 21                	jg     8023cc <nsipc_recv+0x56>
  8023ab:	39 c6                	cmp    %eax,%esi
  8023ad:	7c 1d                	jl     8023cc <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8023af:	83 ec 04             	sub    $0x4,%esp
  8023b2:	50                   	push   %eax
  8023b3:	68 00 70 80 00       	push   $0x807000
  8023b8:	ff 75 0c             	pushl  0xc(%ebp)
  8023bb:	e8 be ee ff ff       	call   80127e <memmove>
  8023c0:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8023c3:	89 d8                	mov    %ebx,%eax
  8023c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023c8:	5b                   	pop    %ebx
  8023c9:	5e                   	pop    %esi
  8023ca:	5d                   	pop    %ebp
  8023cb:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8023cc:	68 83 36 80 00       	push   $0x803683
  8023d1:	68 4b 36 80 00       	push   $0x80364b
  8023d6:	6a 62                	push   $0x62
  8023d8:	68 98 36 80 00       	push   $0x803698
  8023dd:	e8 b9 e4 ff ff       	call   80089b <_panic>

008023e2 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8023e2:	55                   	push   %ebp
  8023e3:	89 e5                	mov    %esp,%ebp
  8023e5:	53                   	push   %ebx
  8023e6:	83 ec 04             	sub    $0x4,%esp
  8023e9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8023ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ef:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8023f4:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8023fa:	7f 2e                	jg     80242a <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8023fc:	83 ec 04             	sub    $0x4,%esp
  8023ff:	53                   	push   %ebx
  802400:	ff 75 0c             	pushl  0xc(%ebp)
  802403:	68 0c 70 80 00       	push   $0x80700c
  802408:	e8 71 ee ff ff       	call   80127e <memmove>
	nsipcbuf.send.req_size = size;
  80240d:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802413:	8b 45 14             	mov    0x14(%ebp),%eax
  802416:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80241b:	b8 08 00 00 00       	mov    $0x8,%eax
  802420:	e8 eb fd ff ff       	call   802210 <nsipc>
}
  802425:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802428:	c9                   	leave  
  802429:	c3                   	ret    
	assert(size < 1600);
  80242a:	68 a4 36 80 00       	push   $0x8036a4
  80242f:	68 4b 36 80 00       	push   $0x80364b
  802434:	6a 6d                	push   $0x6d
  802436:	68 98 36 80 00       	push   $0x803698
  80243b:	e8 5b e4 ff ff       	call   80089b <_panic>

00802440 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802440:	55                   	push   %ebp
  802441:	89 e5                	mov    %esp,%ebp
  802443:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802446:	8b 45 08             	mov    0x8(%ebp),%eax
  802449:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80244e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802451:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802456:	8b 45 10             	mov    0x10(%ebp),%eax
  802459:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80245e:	b8 09 00 00 00       	mov    $0x9,%eax
  802463:	e8 a8 fd ff ff       	call   802210 <nsipc>
}
  802468:	c9                   	leave  
  802469:	c3                   	ret    

0080246a <free>:
	return v;
}

void
free(void *v)
{
  80246a:	55                   	push   %ebp
  80246b:	89 e5                	mov    %esp,%ebp
  80246d:	53                   	push   %ebx
  80246e:	83 ec 04             	sub    $0x4,%esp
  802471:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
  802474:	85 db                	test   %ebx,%ebx
  802476:	0f 84 85 00 00 00    	je     802501 <free+0x97>
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  80247c:	8d 83 00 00 00 f8    	lea    -0x8000000(%ebx),%eax
  802482:	3d ff ff ff 07       	cmp    $0x7ffffff,%eax
  802487:	77 51                	ja     8024da <free+0x70>

	c = ROUNDDOWN(v, PGSIZE);
  802489:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  80248f:	89 d8                	mov    %ebx,%eax
  802491:	c1 e8 0c             	shr    $0xc,%eax
  802494:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80249b:	f6 c4 02             	test   $0x2,%ah
  80249e:	74 50                	je     8024f0 <free+0x86>
		sys_page_unmap(0, c);
  8024a0:	83 ec 08             	sub    $0x8,%esp
  8024a3:	53                   	push   %ebx
  8024a4:	6a 00                	push   $0x0
  8024a6:	e8 bc f0 ff ff       	call   801567 <sys_page_unmap>
		c += PGSIZE;
  8024ab:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		assert(mbegin <= c && c < mend);
  8024b1:	8d 83 00 00 00 f8    	lea    -0x8000000(%ebx),%eax
  8024b7:	83 c4 10             	add    $0x10,%esp
  8024ba:	3d ff ff ff 07       	cmp    $0x7ffffff,%eax
  8024bf:	76 ce                	jbe    80248f <free+0x25>
  8024c1:	68 ed 36 80 00       	push   $0x8036ed
  8024c6:	68 4b 36 80 00       	push   $0x80364b
  8024cb:	68 81 00 00 00       	push   $0x81
  8024d0:	68 e0 36 80 00       	push   $0x8036e0
  8024d5:	e8 c1 e3 ff ff       	call   80089b <_panic>
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  8024da:	68 b0 36 80 00       	push   $0x8036b0
  8024df:	68 4b 36 80 00       	push   $0x80364b
  8024e4:	6a 7a                	push   $0x7a
  8024e6:	68 e0 36 80 00       	push   $0x8036e0
  8024eb:	e8 ab e3 ff ff       	call   80089b <_panic>
	/*
	 * c is just a piece of this page, so dec the ref count
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
	if (--(*ref) == 0)
  8024f0:	8b 83 fc 0f 00 00    	mov    0xffc(%ebx),%eax
  8024f6:	83 e8 01             	sub    $0x1,%eax
  8024f9:	89 83 fc 0f 00 00    	mov    %eax,0xffc(%ebx)
  8024ff:	74 05                	je     802506 <free+0x9c>
		sys_page_unmap(0, c);
}
  802501:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802504:	c9                   	leave  
  802505:	c3                   	ret    
		sys_page_unmap(0, c);
  802506:	83 ec 08             	sub    $0x8,%esp
  802509:	53                   	push   %ebx
  80250a:	6a 00                	push   $0x0
  80250c:	e8 56 f0 ff ff       	call   801567 <sys_page_unmap>
  802511:	83 c4 10             	add    $0x10,%esp
  802514:	eb eb                	jmp    802501 <free+0x97>

00802516 <malloc>:
{
  802516:	55                   	push   %ebp
  802517:	89 e5                	mov    %esp,%ebp
  802519:	57                   	push   %edi
  80251a:	56                   	push   %esi
  80251b:	53                   	push   %ebx
  80251c:	83 ec 1c             	sub    $0x1c,%esp
	if (mptr == 0)
  80251f:	a1 18 50 80 00       	mov    0x805018,%eax
  802524:	85 c0                	test   %eax,%eax
  802526:	74 74                	je     80259c <malloc+0x86>
	n = ROUNDUP(n, 4);
  802528:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80252b:	8d 51 03             	lea    0x3(%ecx),%edx
  80252e:	83 e2 fc             	and    $0xfffffffc,%edx
  802531:	89 d6                	mov    %edx,%esi
  802533:	89 55 dc             	mov    %edx,-0x24(%ebp)
	if (n >= MAXMALLOC)
  802536:	81 fa ff ff 0f 00    	cmp    $0xfffff,%edx
  80253c:	0f 87 55 01 00 00    	ja     802697 <malloc+0x181>
	if ((uintptr_t) mptr % PGSIZE){
  802542:	89 c1                	mov    %eax,%ecx
  802544:	a9 ff 0f 00 00       	test   $0xfff,%eax
  802549:	74 30                	je     80257b <malloc+0x65>
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
  80254b:	89 c3                	mov    %eax,%ebx
  80254d:	c1 eb 0c             	shr    $0xc,%ebx
  802550:	8d 54 10 03          	lea    0x3(%eax,%edx,1),%edx
  802554:	c1 ea 0c             	shr    $0xc,%edx
  802557:	39 d3                	cmp    %edx,%ebx
  802559:	74 64                	je     8025bf <malloc+0xa9>
		free(mptr);	/* drop reference to this page */
  80255b:	83 ec 0c             	sub    $0xc,%esp
  80255e:	50                   	push   %eax
  80255f:	e8 06 ff ff ff       	call   80246a <free>
		mptr = ROUNDDOWN(mptr + PGSIZE, PGSIZE);
  802564:	a1 18 50 80 00       	mov    0x805018,%eax
  802569:	05 00 10 00 00       	add    $0x1000,%eax
  80256e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802573:	a3 18 50 80 00       	mov    %eax,0x805018
  802578:	83 c4 10             	add    $0x10,%esp
  80257b:	8b 15 18 50 80 00    	mov    0x805018,%edx
{
  802581:	c7 45 d8 02 00 00 00 	movl   $0x2,-0x28(%ebp)
  802588:	be 00 00 00 00       	mov    $0x0,%esi
		if (isfree(mptr, n + 4))
  80258d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802590:	8d 78 04             	lea    0x4(%eax),%edi
  802593:	c6 45 e3 01          	movb   $0x1,-0x1d(%ebp)
  802597:	e9 86 00 00 00       	jmp    802622 <malloc+0x10c>
		mptr = mbegin;
  80259c:	c7 05 18 50 80 00 00 	movl   $0x8000000,0x805018
  8025a3:	00 00 08 
	n = ROUNDUP(n, 4);
  8025a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025a9:	8d 51 03             	lea    0x3(%ecx),%edx
  8025ac:	83 e2 fc             	and    $0xfffffffc,%edx
  8025af:	89 55 dc             	mov    %edx,-0x24(%ebp)
	if (n >= MAXMALLOC)
  8025b2:	81 fa ff ff 0f 00    	cmp    $0xfffff,%edx
  8025b8:	76 c1                	jbe    80257b <malloc+0x65>
  8025ba:	e9 fd 00 00 00       	jmp    8026bc <malloc+0x1a6>
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
  8025bf:	81 c1 ff 0f 00 00    	add    $0xfff,%ecx
  8025c5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
			(*ref)++;
  8025cb:	83 41 fc 01          	addl   $0x1,-0x4(%ecx)
			mptr += n;
  8025cf:	89 f2                	mov    %esi,%edx
  8025d1:	01 c2                	add    %eax,%edx
  8025d3:	89 15 18 50 80 00    	mov    %edx,0x805018
			return v;
  8025d9:	e9 de 00 00 00       	jmp    8026bc <malloc+0x1a6>
	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  8025de:	05 00 10 00 00       	add    $0x1000,%eax
  8025e3:	39 c8                	cmp    %ecx,%eax
  8025e5:	73 66                	jae    80264d <malloc+0x137>
		if (va >= (uintptr_t) mend
  8025e7:	3d ff ff ff 0f       	cmp    $0xfffffff,%eax
  8025ec:	77 22                	ja     802610 <malloc+0xfa>
		    || ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
  8025ee:	89 c3                	mov    %eax,%ebx
  8025f0:	c1 eb 16             	shr    $0x16,%ebx
  8025f3:	8b 1c 9d 00 d0 7b ef 	mov    -0x10843000(,%ebx,4),%ebx
  8025fa:	f6 c3 01             	test   $0x1,%bl
  8025fd:	74 df                	je     8025de <malloc+0xc8>
  8025ff:	89 c3                	mov    %eax,%ebx
  802601:	c1 eb 0c             	shr    $0xc,%ebx
  802604:	8b 1c 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%ebx
  80260b:	f6 c3 01             	test   $0x1,%bl
  80260e:	74 ce                	je     8025de <malloc+0xc8>
  802610:	81 c2 00 10 00 00    	add    $0x1000,%edx
  802616:	0f b6 75 e3          	movzbl -0x1d(%ebp),%esi
		if (mptr == mend) {
  80261a:	81 fa 00 00 00 10    	cmp    $0x10000000,%edx
  802620:	74 0a                	je     80262c <malloc+0x116>
  802622:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  802625:	89 d0                	mov    %edx,%eax
  802627:	8d 0c 17             	lea    (%edi,%edx,1),%ecx
  80262a:	eb b7                	jmp    8025e3 <malloc+0xcd>
			mptr = mbegin;
  80262c:	ba 00 00 00 08       	mov    $0x8000000,%edx
  802631:	be 01 00 00 00       	mov    $0x1,%esi
			if (++nwrap == 2)
  802636:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80263a:	75 e6                	jne    802622 <malloc+0x10c>
  80263c:	c7 05 18 50 80 00 00 	movl   $0x8000000,0x805018
  802643:	00 00 08 
				return 0;	/* out of address space */
  802646:	b8 00 00 00 00       	mov    $0x0,%eax
  80264b:	eb 6f                	jmp    8026bc <malloc+0x1a6>
  80264d:	89 f0                	mov    %esi,%eax
  80264f:	84 c0                	test   %al,%al
  802651:	74 08                	je     80265b <malloc+0x145>
  802653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802656:	a3 18 50 80 00       	mov    %eax,0x805018
	for (i = 0; i < n + 4; i += PGSIZE){
  80265b:	bb 00 00 00 00       	mov    $0x0,%ebx
  802660:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
  802663:	8d b3 00 10 00 00    	lea    0x1000(%ebx),%esi
  802669:	39 f7                	cmp    %esi,%edi
  80266b:	76 57                	jbe    8026c4 <malloc+0x1ae>
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  80266d:	83 ec 04             	sub    $0x4,%esp
  802670:	68 07 02 00 00       	push   $0x207
  802675:	89 d8                	mov    %ebx,%eax
  802677:	03 05 18 50 80 00    	add    0x805018,%eax
  80267d:	50                   	push   %eax
  80267e:	6a 00                	push   $0x0
  802680:	e8 5d ee ff ff       	call   8014e2 <sys_page_alloc>
  802685:	83 c4 10             	add    $0x10,%esp
  802688:	85 c0                	test   %eax,%eax
  80268a:	78 55                	js     8026e1 <malloc+0x1cb>
	for (i = 0; i < n + 4; i += PGSIZE){
  80268c:	89 f3                	mov    %esi,%ebx
  80268e:	eb d0                	jmp    802660 <malloc+0x14a>
			return 0;	/* out of physical memory */
  802690:	b8 00 00 00 00       	mov    $0x0,%eax
  802695:	eb 25                	jmp    8026bc <malloc+0x1a6>
		return 0;
  802697:	b8 00 00 00 00       	mov    $0x0,%eax
  80269c:	eb 1e                	jmp    8026bc <malloc+0x1a6>
	ref = (uint32_t*) (mptr + i - 4);
  80269e:	a1 18 50 80 00       	mov    0x805018,%eax
	*ref = 2;	/* reference for mptr, reference for returned block */
  8026a3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8026a6:	c7 84 08 fc 0f 00 00 	movl   $0x2,0xffc(%eax,%ecx,1)
  8026ad:	02 00 00 00 
	mptr += n;
  8026b1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026b4:	01 c2                	add    %eax,%edx
  8026b6:	89 15 18 50 80 00    	mov    %edx,0x805018
}
  8026bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026bf:	5b                   	pop    %ebx
  8026c0:	5e                   	pop    %esi
  8026c1:	5f                   	pop    %edi
  8026c2:	5d                   	pop    %ebp
  8026c3:	c3                   	ret    
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  8026c4:	83 ec 04             	sub    $0x4,%esp
  8026c7:	6a 07                	push   $0x7
  8026c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026cc:	03 05 18 50 80 00    	add    0x805018,%eax
  8026d2:	50                   	push   %eax
  8026d3:	6a 00                	push   $0x0
  8026d5:	e8 08 ee ff ff       	call   8014e2 <sys_page_alloc>
  8026da:	83 c4 10             	add    $0x10,%esp
  8026dd:	85 c0                	test   %eax,%eax
  8026df:	79 bd                	jns    80269e <malloc+0x188>
			for (; i >= 0; i -= PGSIZE)
  8026e1:	85 db                	test   %ebx,%ebx
  8026e3:	78 ab                	js     802690 <malloc+0x17a>
				sys_page_unmap(0, mptr + i);
  8026e5:	83 ec 08             	sub    $0x8,%esp
  8026e8:	89 d8                	mov    %ebx,%eax
  8026ea:	03 05 18 50 80 00    	add    0x805018,%eax
  8026f0:	50                   	push   %eax
  8026f1:	6a 00                	push   $0x0
  8026f3:	e8 6f ee ff ff       	call   801567 <sys_page_unmap>
			for (; i >= 0; i -= PGSIZE)
  8026f8:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
  8026fe:	83 c4 10             	add    $0x10,%esp
  802701:	eb de                	jmp    8026e1 <malloc+0x1cb>

00802703 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802703:	55                   	push   %ebp
  802704:	89 e5                	mov    %esp,%ebp
  802706:	56                   	push   %esi
  802707:	53                   	push   %ebx
  802708:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80270b:	83 ec 0c             	sub    $0xc,%esp
  80270e:	ff 75 08             	pushl  0x8(%ebp)
  802711:	e8 d1 f0 ff ff       	call   8017e7 <fd2data>
  802716:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802718:	83 c4 08             	add    $0x8,%esp
  80271b:	68 05 37 80 00       	push   $0x803705
  802720:	53                   	push   %ebx
  802721:	e8 ca e9 ff ff       	call   8010f0 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802726:	8b 46 04             	mov    0x4(%esi),%eax
  802729:	2b 06                	sub    (%esi),%eax
  80272b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802731:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802738:	00 00 00 
	stat->st_dev = &devpipe;
  80273b:	c7 83 88 00 00 00 5c 	movl   $0x80405c,0x88(%ebx)
  802742:	40 80 00 
	return 0;
}
  802745:	b8 00 00 00 00       	mov    $0x0,%eax
  80274a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80274d:	5b                   	pop    %ebx
  80274e:	5e                   	pop    %esi
  80274f:	5d                   	pop    %ebp
  802750:	c3                   	ret    

00802751 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802751:	55                   	push   %ebp
  802752:	89 e5                	mov    %esp,%ebp
  802754:	53                   	push   %ebx
  802755:	83 ec 0c             	sub    $0xc,%esp
  802758:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80275b:	53                   	push   %ebx
  80275c:	6a 00                	push   $0x0
  80275e:	e8 04 ee ff ff       	call   801567 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802763:	89 1c 24             	mov    %ebx,(%esp)
  802766:	e8 7c f0 ff ff       	call   8017e7 <fd2data>
  80276b:	83 c4 08             	add    $0x8,%esp
  80276e:	50                   	push   %eax
  80276f:	6a 00                	push   $0x0
  802771:	e8 f1 ed ff ff       	call   801567 <sys_page_unmap>
}
  802776:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802779:	c9                   	leave  
  80277a:	c3                   	ret    

0080277b <_pipeisclosed>:
{
  80277b:	55                   	push   %ebp
  80277c:	89 e5                	mov    %esp,%ebp
  80277e:	57                   	push   %edi
  80277f:	56                   	push   %esi
  802780:	53                   	push   %ebx
  802781:	83 ec 1c             	sub    $0x1c,%esp
  802784:	89 c7                	mov    %eax,%edi
  802786:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802788:	a1 1c 50 80 00       	mov    0x80501c,%eax
  80278d:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802790:	83 ec 0c             	sub    $0xc,%esp
  802793:	57                   	push   %edi
  802794:	e8 2d 05 00 00       	call   802cc6 <pageref>
  802799:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80279c:	89 34 24             	mov    %esi,(%esp)
  80279f:	e8 22 05 00 00       	call   802cc6 <pageref>
		nn = thisenv->env_runs;
  8027a4:	8b 15 1c 50 80 00    	mov    0x80501c,%edx
  8027aa:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8027ad:	83 c4 10             	add    $0x10,%esp
  8027b0:	39 cb                	cmp    %ecx,%ebx
  8027b2:	74 1b                	je     8027cf <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8027b4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8027b7:	75 cf                	jne    802788 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8027b9:	8b 42 58             	mov    0x58(%edx),%eax
  8027bc:	6a 01                	push   $0x1
  8027be:	50                   	push   %eax
  8027bf:	53                   	push   %ebx
  8027c0:	68 0c 37 80 00       	push   $0x80370c
  8027c5:	e8 c7 e1 ff ff       	call   800991 <cprintf>
  8027ca:	83 c4 10             	add    $0x10,%esp
  8027cd:	eb b9                	jmp    802788 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8027cf:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8027d2:	0f 94 c0             	sete   %al
  8027d5:	0f b6 c0             	movzbl %al,%eax
}
  8027d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027db:	5b                   	pop    %ebx
  8027dc:	5e                   	pop    %esi
  8027dd:	5f                   	pop    %edi
  8027de:	5d                   	pop    %ebp
  8027df:	c3                   	ret    

008027e0 <devpipe_write>:
{
  8027e0:	55                   	push   %ebp
  8027e1:	89 e5                	mov    %esp,%ebp
  8027e3:	57                   	push   %edi
  8027e4:	56                   	push   %esi
  8027e5:	53                   	push   %ebx
  8027e6:	83 ec 28             	sub    $0x28,%esp
  8027e9:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8027ec:	56                   	push   %esi
  8027ed:	e8 f5 ef ff ff       	call   8017e7 <fd2data>
  8027f2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8027f4:	83 c4 10             	add    $0x10,%esp
  8027f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8027fc:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8027ff:	74 4f                	je     802850 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802801:	8b 43 04             	mov    0x4(%ebx),%eax
  802804:	8b 0b                	mov    (%ebx),%ecx
  802806:	8d 51 20             	lea    0x20(%ecx),%edx
  802809:	39 d0                	cmp    %edx,%eax
  80280b:	72 14                	jb     802821 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80280d:	89 da                	mov    %ebx,%edx
  80280f:	89 f0                	mov    %esi,%eax
  802811:	e8 65 ff ff ff       	call   80277b <_pipeisclosed>
  802816:	85 c0                	test   %eax,%eax
  802818:	75 3b                	jne    802855 <devpipe_write+0x75>
			sys_yield();
  80281a:	e8 a4 ec ff ff       	call   8014c3 <sys_yield>
  80281f:	eb e0                	jmp    802801 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802821:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802824:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802828:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80282b:	89 c2                	mov    %eax,%edx
  80282d:	c1 fa 1f             	sar    $0x1f,%edx
  802830:	89 d1                	mov    %edx,%ecx
  802832:	c1 e9 1b             	shr    $0x1b,%ecx
  802835:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802838:	83 e2 1f             	and    $0x1f,%edx
  80283b:	29 ca                	sub    %ecx,%edx
  80283d:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802841:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802845:	83 c0 01             	add    $0x1,%eax
  802848:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80284b:	83 c7 01             	add    $0x1,%edi
  80284e:	eb ac                	jmp    8027fc <devpipe_write+0x1c>
	return i;
  802850:	8b 45 10             	mov    0x10(%ebp),%eax
  802853:	eb 05                	jmp    80285a <devpipe_write+0x7a>
				return 0;
  802855:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80285a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80285d:	5b                   	pop    %ebx
  80285e:	5e                   	pop    %esi
  80285f:	5f                   	pop    %edi
  802860:	5d                   	pop    %ebp
  802861:	c3                   	ret    

00802862 <devpipe_read>:
{
  802862:	55                   	push   %ebp
  802863:	89 e5                	mov    %esp,%ebp
  802865:	57                   	push   %edi
  802866:	56                   	push   %esi
  802867:	53                   	push   %ebx
  802868:	83 ec 18             	sub    $0x18,%esp
  80286b:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80286e:	57                   	push   %edi
  80286f:	e8 73 ef ff ff       	call   8017e7 <fd2data>
  802874:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802876:	83 c4 10             	add    $0x10,%esp
  802879:	be 00 00 00 00       	mov    $0x0,%esi
  80287e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802881:	75 14                	jne    802897 <devpipe_read+0x35>
	return i;
  802883:	8b 45 10             	mov    0x10(%ebp),%eax
  802886:	eb 02                	jmp    80288a <devpipe_read+0x28>
				return i;
  802888:	89 f0                	mov    %esi,%eax
}
  80288a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80288d:	5b                   	pop    %ebx
  80288e:	5e                   	pop    %esi
  80288f:	5f                   	pop    %edi
  802890:	5d                   	pop    %ebp
  802891:	c3                   	ret    
			sys_yield();
  802892:	e8 2c ec ff ff       	call   8014c3 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802897:	8b 03                	mov    (%ebx),%eax
  802899:	3b 43 04             	cmp    0x4(%ebx),%eax
  80289c:	75 18                	jne    8028b6 <devpipe_read+0x54>
			if (i > 0)
  80289e:	85 f6                	test   %esi,%esi
  8028a0:	75 e6                	jne    802888 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8028a2:	89 da                	mov    %ebx,%edx
  8028a4:	89 f8                	mov    %edi,%eax
  8028a6:	e8 d0 fe ff ff       	call   80277b <_pipeisclosed>
  8028ab:	85 c0                	test   %eax,%eax
  8028ad:	74 e3                	je     802892 <devpipe_read+0x30>
				return 0;
  8028af:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b4:	eb d4                	jmp    80288a <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8028b6:	99                   	cltd   
  8028b7:	c1 ea 1b             	shr    $0x1b,%edx
  8028ba:	01 d0                	add    %edx,%eax
  8028bc:	83 e0 1f             	and    $0x1f,%eax
  8028bf:	29 d0                	sub    %edx,%eax
  8028c1:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8028c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8028c9:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8028cc:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8028cf:	83 c6 01             	add    $0x1,%esi
  8028d2:	eb aa                	jmp    80287e <devpipe_read+0x1c>

008028d4 <pipe>:
{
  8028d4:	55                   	push   %ebp
  8028d5:	89 e5                	mov    %esp,%ebp
  8028d7:	56                   	push   %esi
  8028d8:	53                   	push   %ebx
  8028d9:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8028dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028df:	50                   	push   %eax
  8028e0:	e8 19 ef ff ff       	call   8017fe <fd_alloc>
  8028e5:	89 c3                	mov    %eax,%ebx
  8028e7:	83 c4 10             	add    $0x10,%esp
  8028ea:	85 c0                	test   %eax,%eax
  8028ec:	0f 88 23 01 00 00    	js     802a15 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028f2:	83 ec 04             	sub    $0x4,%esp
  8028f5:	68 07 04 00 00       	push   $0x407
  8028fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8028fd:	6a 00                	push   $0x0
  8028ff:	e8 de eb ff ff       	call   8014e2 <sys_page_alloc>
  802904:	89 c3                	mov    %eax,%ebx
  802906:	83 c4 10             	add    $0x10,%esp
  802909:	85 c0                	test   %eax,%eax
  80290b:	0f 88 04 01 00 00    	js     802a15 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802911:	83 ec 0c             	sub    $0xc,%esp
  802914:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802917:	50                   	push   %eax
  802918:	e8 e1 ee ff ff       	call   8017fe <fd_alloc>
  80291d:	89 c3                	mov    %eax,%ebx
  80291f:	83 c4 10             	add    $0x10,%esp
  802922:	85 c0                	test   %eax,%eax
  802924:	0f 88 db 00 00 00    	js     802a05 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80292a:	83 ec 04             	sub    $0x4,%esp
  80292d:	68 07 04 00 00       	push   $0x407
  802932:	ff 75 f0             	pushl  -0x10(%ebp)
  802935:	6a 00                	push   $0x0
  802937:	e8 a6 eb ff ff       	call   8014e2 <sys_page_alloc>
  80293c:	89 c3                	mov    %eax,%ebx
  80293e:	83 c4 10             	add    $0x10,%esp
  802941:	85 c0                	test   %eax,%eax
  802943:	0f 88 bc 00 00 00    	js     802a05 <pipe+0x131>
	va = fd2data(fd0);
  802949:	83 ec 0c             	sub    $0xc,%esp
  80294c:	ff 75 f4             	pushl  -0xc(%ebp)
  80294f:	e8 93 ee ff ff       	call   8017e7 <fd2data>
  802954:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802956:	83 c4 0c             	add    $0xc,%esp
  802959:	68 07 04 00 00       	push   $0x407
  80295e:	50                   	push   %eax
  80295f:	6a 00                	push   $0x0
  802961:	e8 7c eb ff ff       	call   8014e2 <sys_page_alloc>
  802966:	89 c3                	mov    %eax,%ebx
  802968:	83 c4 10             	add    $0x10,%esp
  80296b:	85 c0                	test   %eax,%eax
  80296d:	0f 88 82 00 00 00    	js     8029f5 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802973:	83 ec 0c             	sub    $0xc,%esp
  802976:	ff 75 f0             	pushl  -0x10(%ebp)
  802979:	e8 69 ee ff ff       	call   8017e7 <fd2data>
  80297e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802985:	50                   	push   %eax
  802986:	6a 00                	push   $0x0
  802988:	56                   	push   %esi
  802989:	6a 00                	push   $0x0
  80298b:	e8 95 eb ff ff       	call   801525 <sys_page_map>
  802990:	89 c3                	mov    %eax,%ebx
  802992:	83 c4 20             	add    $0x20,%esp
  802995:	85 c0                	test   %eax,%eax
  802997:	78 4e                	js     8029e7 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802999:	a1 5c 40 80 00       	mov    0x80405c,%eax
  80299e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a1:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8029a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a6:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8029ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029b0:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8029b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8029bc:	83 ec 0c             	sub    $0xc,%esp
  8029bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8029c2:	e8 10 ee ff ff       	call   8017d7 <fd2num>
  8029c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8029ca:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8029cc:	83 c4 04             	add    $0x4,%esp
  8029cf:	ff 75 f0             	pushl  -0x10(%ebp)
  8029d2:	e8 00 ee ff ff       	call   8017d7 <fd2num>
  8029d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8029da:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8029dd:	83 c4 10             	add    $0x10,%esp
  8029e0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8029e5:	eb 2e                	jmp    802a15 <pipe+0x141>
	sys_page_unmap(0, va);
  8029e7:	83 ec 08             	sub    $0x8,%esp
  8029ea:	56                   	push   %esi
  8029eb:	6a 00                	push   $0x0
  8029ed:	e8 75 eb ff ff       	call   801567 <sys_page_unmap>
  8029f2:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8029f5:	83 ec 08             	sub    $0x8,%esp
  8029f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8029fb:	6a 00                	push   $0x0
  8029fd:	e8 65 eb ff ff       	call   801567 <sys_page_unmap>
  802a02:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802a05:	83 ec 08             	sub    $0x8,%esp
  802a08:	ff 75 f4             	pushl  -0xc(%ebp)
  802a0b:	6a 00                	push   $0x0
  802a0d:	e8 55 eb ff ff       	call   801567 <sys_page_unmap>
  802a12:	83 c4 10             	add    $0x10,%esp
}
  802a15:	89 d8                	mov    %ebx,%eax
  802a17:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a1a:	5b                   	pop    %ebx
  802a1b:	5e                   	pop    %esi
  802a1c:	5d                   	pop    %ebp
  802a1d:	c3                   	ret    

00802a1e <pipeisclosed>:
{
  802a1e:	55                   	push   %ebp
  802a1f:	89 e5                	mov    %esp,%ebp
  802a21:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a24:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a27:	50                   	push   %eax
  802a28:	ff 75 08             	pushl  0x8(%ebp)
  802a2b:	e8 20 ee ff ff       	call   801850 <fd_lookup>
  802a30:	83 c4 10             	add    $0x10,%esp
  802a33:	85 c0                	test   %eax,%eax
  802a35:	78 18                	js     802a4f <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802a37:	83 ec 0c             	sub    $0xc,%esp
  802a3a:	ff 75 f4             	pushl  -0xc(%ebp)
  802a3d:	e8 a5 ed ff ff       	call   8017e7 <fd2data>
	return _pipeisclosed(fd, p);
  802a42:	89 c2                	mov    %eax,%edx
  802a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a47:	e8 2f fd ff ff       	call   80277b <_pipeisclosed>
  802a4c:	83 c4 10             	add    $0x10,%esp
}
  802a4f:	c9                   	leave  
  802a50:	c3                   	ret    

00802a51 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802a51:	b8 00 00 00 00       	mov    $0x0,%eax
  802a56:	c3                   	ret    

00802a57 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802a57:	55                   	push   %ebp
  802a58:	89 e5                	mov    %esp,%ebp
  802a5a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802a5d:	68 24 37 80 00       	push   $0x803724
  802a62:	ff 75 0c             	pushl  0xc(%ebp)
  802a65:	e8 86 e6 ff ff       	call   8010f0 <strcpy>
	return 0;
}
  802a6a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a6f:	c9                   	leave  
  802a70:	c3                   	ret    

00802a71 <devcons_write>:
{
  802a71:	55                   	push   %ebp
  802a72:	89 e5                	mov    %esp,%ebp
  802a74:	57                   	push   %edi
  802a75:	56                   	push   %esi
  802a76:	53                   	push   %ebx
  802a77:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802a7d:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802a82:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802a88:	3b 75 10             	cmp    0x10(%ebp),%esi
  802a8b:	73 31                	jae    802abe <devcons_write+0x4d>
		m = n - tot;
  802a8d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802a90:	29 f3                	sub    %esi,%ebx
  802a92:	83 fb 7f             	cmp    $0x7f,%ebx
  802a95:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802a9a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802a9d:	83 ec 04             	sub    $0x4,%esp
  802aa0:	53                   	push   %ebx
  802aa1:	89 f0                	mov    %esi,%eax
  802aa3:	03 45 0c             	add    0xc(%ebp),%eax
  802aa6:	50                   	push   %eax
  802aa7:	57                   	push   %edi
  802aa8:	e8 d1 e7 ff ff       	call   80127e <memmove>
		sys_cputs(buf, m);
  802aad:	83 c4 08             	add    $0x8,%esp
  802ab0:	53                   	push   %ebx
  802ab1:	57                   	push   %edi
  802ab2:	e8 6f e9 ff ff       	call   801426 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802ab7:	01 de                	add    %ebx,%esi
  802ab9:	83 c4 10             	add    $0x10,%esp
  802abc:	eb ca                	jmp    802a88 <devcons_write+0x17>
}
  802abe:	89 f0                	mov    %esi,%eax
  802ac0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802ac3:	5b                   	pop    %ebx
  802ac4:	5e                   	pop    %esi
  802ac5:	5f                   	pop    %edi
  802ac6:	5d                   	pop    %ebp
  802ac7:	c3                   	ret    

00802ac8 <devcons_read>:
{
  802ac8:	55                   	push   %ebp
  802ac9:	89 e5                	mov    %esp,%ebp
  802acb:	83 ec 08             	sub    $0x8,%esp
  802ace:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802ad3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802ad7:	74 21                	je     802afa <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802ad9:	e8 66 e9 ff ff       	call   801444 <sys_cgetc>
  802ade:	85 c0                	test   %eax,%eax
  802ae0:	75 07                	jne    802ae9 <devcons_read+0x21>
		sys_yield();
  802ae2:	e8 dc e9 ff ff       	call   8014c3 <sys_yield>
  802ae7:	eb f0                	jmp    802ad9 <devcons_read+0x11>
	if (c < 0)
  802ae9:	78 0f                	js     802afa <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802aeb:	83 f8 04             	cmp    $0x4,%eax
  802aee:	74 0c                	je     802afc <devcons_read+0x34>
	*(char*)vbuf = c;
  802af0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802af3:	88 02                	mov    %al,(%edx)
	return 1;
  802af5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802afa:	c9                   	leave  
  802afb:	c3                   	ret    
		return 0;
  802afc:	b8 00 00 00 00       	mov    $0x0,%eax
  802b01:	eb f7                	jmp    802afa <devcons_read+0x32>

00802b03 <cputchar>:
{
  802b03:	55                   	push   %ebp
  802b04:	89 e5                	mov    %esp,%ebp
  802b06:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802b09:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0c:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802b0f:	6a 01                	push   $0x1
  802b11:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802b14:	50                   	push   %eax
  802b15:	e8 0c e9 ff ff       	call   801426 <sys_cputs>
}
  802b1a:	83 c4 10             	add    $0x10,%esp
  802b1d:	c9                   	leave  
  802b1e:	c3                   	ret    

00802b1f <getchar>:
{
  802b1f:	55                   	push   %ebp
  802b20:	89 e5                	mov    %esp,%ebp
  802b22:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802b25:	6a 01                	push   $0x1
  802b27:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802b2a:	50                   	push   %eax
  802b2b:	6a 00                	push   $0x0
  802b2d:	e8 8e ef ff ff       	call   801ac0 <read>
	if (r < 0)
  802b32:	83 c4 10             	add    $0x10,%esp
  802b35:	85 c0                	test   %eax,%eax
  802b37:	78 06                	js     802b3f <getchar+0x20>
	if (r < 1)
  802b39:	74 06                	je     802b41 <getchar+0x22>
	return c;
  802b3b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802b3f:	c9                   	leave  
  802b40:	c3                   	ret    
		return -E_EOF;
  802b41:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802b46:	eb f7                	jmp    802b3f <getchar+0x20>

00802b48 <iscons>:
{
  802b48:	55                   	push   %ebp
  802b49:	89 e5                	mov    %esp,%ebp
  802b4b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b4e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b51:	50                   	push   %eax
  802b52:	ff 75 08             	pushl  0x8(%ebp)
  802b55:	e8 f6 ec ff ff       	call   801850 <fd_lookup>
  802b5a:	83 c4 10             	add    $0x10,%esp
  802b5d:	85 c0                	test   %eax,%eax
  802b5f:	78 11                	js     802b72 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b64:	8b 15 78 40 80 00    	mov    0x804078,%edx
  802b6a:	39 10                	cmp    %edx,(%eax)
  802b6c:	0f 94 c0             	sete   %al
  802b6f:	0f b6 c0             	movzbl %al,%eax
}
  802b72:	c9                   	leave  
  802b73:	c3                   	ret    

00802b74 <opencons>:
{
  802b74:	55                   	push   %ebp
  802b75:	89 e5                	mov    %esp,%ebp
  802b77:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802b7a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b7d:	50                   	push   %eax
  802b7e:	e8 7b ec ff ff       	call   8017fe <fd_alloc>
  802b83:	83 c4 10             	add    $0x10,%esp
  802b86:	85 c0                	test   %eax,%eax
  802b88:	78 3a                	js     802bc4 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802b8a:	83 ec 04             	sub    $0x4,%esp
  802b8d:	68 07 04 00 00       	push   $0x407
  802b92:	ff 75 f4             	pushl  -0xc(%ebp)
  802b95:	6a 00                	push   $0x0
  802b97:	e8 46 e9 ff ff       	call   8014e2 <sys_page_alloc>
  802b9c:	83 c4 10             	add    $0x10,%esp
  802b9f:	85 c0                	test   %eax,%eax
  802ba1:	78 21                	js     802bc4 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba6:	8b 15 78 40 80 00    	mov    0x804078,%edx
  802bac:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802bb8:	83 ec 0c             	sub    $0xc,%esp
  802bbb:	50                   	push   %eax
  802bbc:	e8 16 ec ff ff       	call   8017d7 <fd2num>
  802bc1:	83 c4 10             	add    $0x10,%esp
}
  802bc4:	c9                   	leave  
  802bc5:	c3                   	ret    

00802bc6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802bc6:	55                   	push   %ebp
  802bc7:	89 e5                	mov    %esp,%ebp
  802bc9:	56                   	push   %esi
  802bca:	53                   	push   %ebx
  802bcb:	8b 75 08             	mov    0x8(%ebp),%esi
  802bce:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bd1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802bd4:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802bd6:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802bdb:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802bde:	83 ec 0c             	sub    $0xc,%esp
  802be1:	50                   	push   %eax
  802be2:	e8 ab ea ff ff       	call   801692 <sys_ipc_recv>
	if(ret < 0){
  802be7:	83 c4 10             	add    $0x10,%esp
  802bea:	85 c0                	test   %eax,%eax
  802bec:	78 2b                	js     802c19 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802bee:	85 f6                	test   %esi,%esi
  802bf0:	74 0a                	je     802bfc <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802bf2:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802bf7:	8b 40 78             	mov    0x78(%eax),%eax
  802bfa:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802bfc:	85 db                	test   %ebx,%ebx
  802bfe:	74 0a                	je     802c0a <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802c00:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802c05:	8b 40 7c             	mov    0x7c(%eax),%eax
  802c08:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802c0a:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802c0f:	8b 40 74             	mov    0x74(%eax),%eax
}
  802c12:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802c15:	5b                   	pop    %ebx
  802c16:	5e                   	pop    %esi
  802c17:	5d                   	pop    %ebp
  802c18:	c3                   	ret    
		if(from_env_store)
  802c19:	85 f6                	test   %esi,%esi
  802c1b:	74 06                	je     802c23 <ipc_recv+0x5d>
			*from_env_store = 0;
  802c1d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802c23:	85 db                	test   %ebx,%ebx
  802c25:	74 eb                	je     802c12 <ipc_recv+0x4c>
			*perm_store = 0;
  802c27:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802c2d:	eb e3                	jmp    802c12 <ipc_recv+0x4c>

00802c2f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802c2f:	55                   	push   %ebp
  802c30:	89 e5                	mov    %esp,%ebp
  802c32:	57                   	push   %edi
  802c33:	56                   	push   %esi
  802c34:	53                   	push   %ebx
  802c35:	83 ec 0c             	sub    $0xc,%esp
  802c38:	8b 7d 08             	mov    0x8(%ebp),%edi
  802c3b:	8b 75 0c             	mov    0xc(%ebp),%esi
  802c3e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802c41:	85 db                	test   %ebx,%ebx
  802c43:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802c48:	0f 44 d8             	cmove  %eax,%ebx
  802c4b:	eb 05                	jmp    802c52 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802c4d:	e8 71 e8 ff ff       	call   8014c3 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802c52:	ff 75 14             	pushl  0x14(%ebp)
  802c55:	53                   	push   %ebx
  802c56:	56                   	push   %esi
  802c57:	57                   	push   %edi
  802c58:	e8 12 ea ff ff       	call   80166f <sys_ipc_try_send>
  802c5d:	83 c4 10             	add    $0x10,%esp
  802c60:	85 c0                	test   %eax,%eax
  802c62:	74 1b                	je     802c7f <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802c64:	79 e7                	jns    802c4d <ipc_send+0x1e>
  802c66:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802c69:	74 e2                	je     802c4d <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802c6b:	83 ec 04             	sub    $0x4,%esp
  802c6e:	68 30 37 80 00       	push   $0x803730
  802c73:	6a 46                	push   $0x46
  802c75:	68 45 37 80 00       	push   $0x803745
  802c7a:	e8 1c dc ff ff       	call   80089b <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802c7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802c82:	5b                   	pop    %ebx
  802c83:	5e                   	pop    %esi
  802c84:	5f                   	pop    %edi
  802c85:	5d                   	pop    %ebp
  802c86:	c3                   	ret    

00802c87 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802c87:	55                   	push   %ebp
  802c88:	89 e5                	mov    %esp,%ebp
  802c8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802c8d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802c92:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802c98:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802c9e:	8b 52 50             	mov    0x50(%edx),%edx
  802ca1:	39 ca                	cmp    %ecx,%edx
  802ca3:	74 11                	je     802cb6 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802ca5:	83 c0 01             	add    $0x1,%eax
  802ca8:	3d 00 04 00 00       	cmp    $0x400,%eax
  802cad:	75 e3                	jne    802c92 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802caf:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb4:	eb 0e                	jmp    802cc4 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802cb6:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  802cbc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802cc1:	8b 40 48             	mov    0x48(%eax),%eax
}
  802cc4:	5d                   	pop    %ebp
  802cc5:	c3                   	ret    

00802cc6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802cc6:	55                   	push   %ebp
  802cc7:	89 e5                	mov    %esp,%ebp
  802cc9:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802ccc:	89 d0                	mov    %edx,%eax
  802cce:	c1 e8 16             	shr    $0x16,%eax
  802cd1:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802cd8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802cdd:	f6 c1 01             	test   $0x1,%cl
  802ce0:	74 1d                	je     802cff <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802ce2:	c1 ea 0c             	shr    $0xc,%edx
  802ce5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802cec:	f6 c2 01             	test   $0x1,%dl
  802cef:	74 0e                	je     802cff <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802cf1:	c1 ea 0c             	shr    $0xc,%edx
  802cf4:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802cfb:	ef 
  802cfc:	0f b7 c0             	movzwl %ax,%eax
}
  802cff:	5d                   	pop    %ebp
  802d00:	c3                   	ret    
  802d01:	66 90                	xchg   %ax,%ax
  802d03:	66 90                	xchg   %ax,%ax
  802d05:	66 90                	xchg   %ax,%ax
  802d07:	66 90                	xchg   %ax,%ax
  802d09:	66 90                	xchg   %ax,%ax
  802d0b:	66 90                	xchg   %ax,%ax
  802d0d:	66 90                	xchg   %ax,%ax
  802d0f:	90                   	nop

00802d10 <__udivdi3>:
  802d10:	55                   	push   %ebp
  802d11:	57                   	push   %edi
  802d12:	56                   	push   %esi
  802d13:	53                   	push   %ebx
  802d14:	83 ec 1c             	sub    $0x1c,%esp
  802d17:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802d1b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802d1f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802d23:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802d27:	85 d2                	test   %edx,%edx
  802d29:	75 4d                	jne    802d78 <__udivdi3+0x68>
  802d2b:	39 f3                	cmp    %esi,%ebx
  802d2d:	76 19                	jbe    802d48 <__udivdi3+0x38>
  802d2f:	31 ff                	xor    %edi,%edi
  802d31:	89 e8                	mov    %ebp,%eax
  802d33:	89 f2                	mov    %esi,%edx
  802d35:	f7 f3                	div    %ebx
  802d37:	89 fa                	mov    %edi,%edx
  802d39:	83 c4 1c             	add    $0x1c,%esp
  802d3c:	5b                   	pop    %ebx
  802d3d:	5e                   	pop    %esi
  802d3e:	5f                   	pop    %edi
  802d3f:	5d                   	pop    %ebp
  802d40:	c3                   	ret    
  802d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802d48:	89 d9                	mov    %ebx,%ecx
  802d4a:	85 db                	test   %ebx,%ebx
  802d4c:	75 0b                	jne    802d59 <__udivdi3+0x49>
  802d4e:	b8 01 00 00 00       	mov    $0x1,%eax
  802d53:	31 d2                	xor    %edx,%edx
  802d55:	f7 f3                	div    %ebx
  802d57:	89 c1                	mov    %eax,%ecx
  802d59:	31 d2                	xor    %edx,%edx
  802d5b:	89 f0                	mov    %esi,%eax
  802d5d:	f7 f1                	div    %ecx
  802d5f:	89 c6                	mov    %eax,%esi
  802d61:	89 e8                	mov    %ebp,%eax
  802d63:	89 f7                	mov    %esi,%edi
  802d65:	f7 f1                	div    %ecx
  802d67:	89 fa                	mov    %edi,%edx
  802d69:	83 c4 1c             	add    $0x1c,%esp
  802d6c:	5b                   	pop    %ebx
  802d6d:	5e                   	pop    %esi
  802d6e:	5f                   	pop    %edi
  802d6f:	5d                   	pop    %ebp
  802d70:	c3                   	ret    
  802d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802d78:	39 f2                	cmp    %esi,%edx
  802d7a:	77 1c                	ja     802d98 <__udivdi3+0x88>
  802d7c:	0f bd fa             	bsr    %edx,%edi
  802d7f:	83 f7 1f             	xor    $0x1f,%edi
  802d82:	75 2c                	jne    802db0 <__udivdi3+0xa0>
  802d84:	39 f2                	cmp    %esi,%edx
  802d86:	72 06                	jb     802d8e <__udivdi3+0x7e>
  802d88:	31 c0                	xor    %eax,%eax
  802d8a:	39 eb                	cmp    %ebp,%ebx
  802d8c:	77 a9                	ja     802d37 <__udivdi3+0x27>
  802d8e:	b8 01 00 00 00       	mov    $0x1,%eax
  802d93:	eb a2                	jmp    802d37 <__udivdi3+0x27>
  802d95:	8d 76 00             	lea    0x0(%esi),%esi
  802d98:	31 ff                	xor    %edi,%edi
  802d9a:	31 c0                	xor    %eax,%eax
  802d9c:	89 fa                	mov    %edi,%edx
  802d9e:	83 c4 1c             	add    $0x1c,%esp
  802da1:	5b                   	pop    %ebx
  802da2:	5e                   	pop    %esi
  802da3:	5f                   	pop    %edi
  802da4:	5d                   	pop    %ebp
  802da5:	c3                   	ret    
  802da6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802dad:	8d 76 00             	lea    0x0(%esi),%esi
  802db0:	89 f9                	mov    %edi,%ecx
  802db2:	b8 20 00 00 00       	mov    $0x20,%eax
  802db7:	29 f8                	sub    %edi,%eax
  802db9:	d3 e2                	shl    %cl,%edx
  802dbb:	89 54 24 08          	mov    %edx,0x8(%esp)
  802dbf:	89 c1                	mov    %eax,%ecx
  802dc1:	89 da                	mov    %ebx,%edx
  802dc3:	d3 ea                	shr    %cl,%edx
  802dc5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802dc9:	09 d1                	or     %edx,%ecx
  802dcb:	89 f2                	mov    %esi,%edx
  802dcd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802dd1:	89 f9                	mov    %edi,%ecx
  802dd3:	d3 e3                	shl    %cl,%ebx
  802dd5:	89 c1                	mov    %eax,%ecx
  802dd7:	d3 ea                	shr    %cl,%edx
  802dd9:	89 f9                	mov    %edi,%ecx
  802ddb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802ddf:	89 eb                	mov    %ebp,%ebx
  802de1:	d3 e6                	shl    %cl,%esi
  802de3:	89 c1                	mov    %eax,%ecx
  802de5:	d3 eb                	shr    %cl,%ebx
  802de7:	09 de                	or     %ebx,%esi
  802de9:	89 f0                	mov    %esi,%eax
  802deb:	f7 74 24 08          	divl   0x8(%esp)
  802def:	89 d6                	mov    %edx,%esi
  802df1:	89 c3                	mov    %eax,%ebx
  802df3:	f7 64 24 0c          	mull   0xc(%esp)
  802df7:	39 d6                	cmp    %edx,%esi
  802df9:	72 15                	jb     802e10 <__udivdi3+0x100>
  802dfb:	89 f9                	mov    %edi,%ecx
  802dfd:	d3 e5                	shl    %cl,%ebp
  802dff:	39 c5                	cmp    %eax,%ebp
  802e01:	73 04                	jae    802e07 <__udivdi3+0xf7>
  802e03:	39 d6                	cmp    %edx,%esi
  802e05:	74 09                	je     802e10 <__udivdi3+0x100>
  802e07:	89 d8                	mov    %ebx,%eax
  802e09:	31 ff                	xor    %edi,%edi
  802e0b:	e9 27 ff ff ff       	jmp    802d37 <__udivdi3+0x27>
  802e10:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802e13:	31 ff                	xor    %edi,%edi
  802e15:	e9 1d ff ff ff       	jmp    802d37 <__udivdi3+0x27>
  802e1a:	66 90                	xchg   %ax,%ax
  802e1c:	66 90                	xchg   %ax,%ax
  802e1e:	66 90                	xchg   %ax,%ax

00802e20 <__umoddi3>:
  802e20:	55                   	push   %ebp
  802e21:	57                   	push   %edi
  802e22:	56                   	push   %esi
  802e23:	53                   	push   %ebx
  802e24:	83 ec 1c             	sub    $0x1c,%esp
  802e27:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802e2b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802e2f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802e33:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802e37:	89 da                	mov    %ebx,%edx
  802e39:	85 c0                	test   %eax,%eax
  802e3b:	75 43                	jne    802e80 <__umoddi3+0x60>
  802e3d:	39 df                	cmp    %ebx,%edi
  802e3f:	76 17                	jbe    802e58 <__umoddi3+0x38>
  802e41:	89 f0                	mov    %esi,%eax
  802e43:	f7 f7                	div    %edi
  802e45:	89 d0                	mov    %edx,%eax
  802e47:	31 d2                	xor    %edx,%edx
  802e49:	83 c4 1c             	add    $0x1c,%esp
  802e4c:	5b                   	pop    %ebx
  802e4d:	5e                   	pop    %esi
  802e4e:	5f                   	pop    %edi
  802e4f:	5d                   	pop    %ebp
  802e50:	c3                   	ret    
  802e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802e58:	89 fd                	mov    %edi,%ebp
  802e5a:	85 ff                	test   %edi,%edi
  802e5c:	75 0b                	jne    802e69 <__umoddi3+0x49>
  802e5e:	b8 01 00 00 00       	mov    $0x1,%eax
  802e63:	31 d2                	xor    %edx,%edx
  802e65:	f7 f7                	div    %edi
  802e67:	89 c5                	mov    %eax,%ebp
  802e69:	89 d8                	mov    %ebx,%eax
  802e6b:	31 d2                	xor    %edx,%edx
  802e6d:	f7 f5                	div    %ebp
  802e6f:	89 f0                	mov    %esi,%eax
  802e71:	f7 f5                	div    %ebp
  802e73:	89 d0                	mov    %edx,%eax
  802e75:	eb d0                	jmp    802e47 <__umoddi3+0x27>
  802e77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802e7e:	66 90                	xchg   %ax,%ax
  802e80:	89 f1                	mov    %esi,%ecx
  802e82:	39 d8                	cmp    %ebx,%eax
  802e84:	76 0a                	jbe    802e90 <__umoddi3+0x70>
  802e86:	89 f0                	mov    %esi,%eax
  802e88:	83 c4 1c             	add    $0x1c,%esp
  802e8b:	5b                   	pop    %ebx
  802e8c:	5e                   	pop    %esi
  802e8d:	5f                   	pop    %edi
  802e8e:	5d                   	pop    %ebp
  802e8f:	c3                   	ret    
  802e90:	0f bd e8             	bsr    %eax,%ebp
  802e93:	83 f5 1f             	xor    $0x1f,%ebp
  802e96:	75 20                	jne    802eb8 <__umoddi3+0x98>
  802e98:	39 d8                	cmp    %ebx,%eax
  802e9a:	0f 82 b0 00 00 00    	jb     802f50 <__umoddi3+0x130>
  802ea0:	39 f7                	cmp    %esi,%edi
  802ea2:	0f 86 a8 00 00 00    	jbe    802f50 <__umoddi3+0x130>
  802ea8:	89 c8                	mov    %ecx,%eax
  802eaa:	83 c4 1c             	add    $0x1c,%esp
  802ead:	5b                   	pop    %ebx
  802eae:	5e                   	pop    %esi
  802eaf:	5f                   	pop    %edi
  802eb0:	5d                   	pop    %ebp
  802eb1:	c3                   	ret    
  802eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802eb8:	89 e9                	mov    %ebp,%ecx
  802eba:	ba 20 00 00 00       	mov    $0x20,%edx
  802ebf:	29 ea                	sub    %ebp,%edx
  802ec1:	d3 e0                	shl    %cl,%eax
  802ec3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ec7:	89 d1                	mov    %edx,%ecx
  802ec9:	89 f8                	mov    %edi,%eax
  802ecb:	d3 e8                	shr    %cl,%eax
  802ecd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802ed1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802ed5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802ed9:	09 c1                	or     %eax,%ecx
  802edb:	89 d8                	mov    %ebx,%eax
  802edd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ee1:	89 e9                	mov    %ebp,%ecx
  802ee3:	d3 e7                	shl    %cl,%edi
  802ee5:	89 d1                	mov    %edx,%ecx
  802ee7:	d3 e8                	shr    %cl,%eax
  802ee9:	89 e9                	mov    %ebp,%ecx
  802eeb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802eef:	d3 e3                	shl    %cl,%ebx
  802ef1:	89 c7                	mov    %eax,%edi
  802ef3:	89 d1                	mov    %edx,%ecx
  802ef5:	89 f0                	mov    %esi,%eax
  802ef7:	d3 e8                	shr    %cl,%eax
  802ef9:	89 e9                	mov    %ebp,%ecx
  802efb:	89 fa                	mov    %edi,%edx
  802efd:	d3 e6                	shl    %cl,%esi
  802eff:	09 d8                	or     %ebx,%eax
  802f01:	f7 74 24 08          	divl   0x8(%esp)
  802f05:	89 d1                	mov    %edx,%ecx
  802f07:	89 f3                	mov    %esi,%ebx
  802f09:	f7 64 24 0c          	mull   0xc(%esp)
  802f0d:	89 c6                	mov    %eax,%esi
  802f0f:	89 d7                	mov    %edx,%edi
  802f11:	39 d1                	cmp    %edx,%ecx
  802f13:	72 06                	jb     802f1b <__umoddi3+0xfb>
  802f15:	75 10                	jne    802f27 <__umoddi3+0x107>
  802f17:	39 c3                	cmp    %eax,%ebx
  802f19:	73 0c                	jae    802f27 <__umoddi3+0x107>
  802f1b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802f1f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802f23:	89 d7                	mov    %edx,%edi
  802f25:	89 c6                	mov    %eax,%esi
  802f27:	89 ca                	mov    %ecx,%edx
  802f29:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802f2e:	29 f3                	sub    %esi,%ebx
  802f30:	19 fa                	sbb    %edi,%edx
  802f32:	89 d0                	mov    %edx,%eax
  802f34:	d3 e0                	shl    %cl,%eax
  802f36:	89 e9                	mov    %ebp,%ecx
  802f38:	d3 eb                	shr    %cl,%ebx
  802f3a:	d3 ea                	shr    %cl,%edx
  802f3c:	09 d8                	or     %ebx,%eax
  802f3e:	83 c4 1c             	add    $0x1c,%esp
  802f41:	5b                   	pop    %ebx
  802f42:	5e                   	pop    %esi
  802f43:	5f                   	pop    %edi
  802f44:	5d                   	pop    %ebp
  802f45:	c3                   	ret    
  802f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802f4d:	8d 76 00             	lea    0x0(%esi),%esi
  802f50:	89 da                	mov    %ebx,%edx
  802f52:	29 fe                	sub    %edi,%esi
  802f54:	19 c2                	sbb    %eax,%edx
  802f56:	89 f1                	mov    %esi,%ecx
  802f58:	89 c8                	mov    %ecx,%eax
  802f5a:	e9 4b ff ff ff       	jmp    802eaa <__umoddi3+0x8a>
