
obj/user/init.debug:     file format elf32-i386


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
  80002c:	e8 65 03 00 00       	call   800396 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <sum>:

char bss[6000];

int
sum(const char *s, int n)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 75 08             	mov    0x8(%ebp),%esi
  80003b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i, tot = 0;
  80003e:	b8 00 00 00 00       	mov    $0x0,%eax
	for (i = 0; i < n; i++)
  800043:	ba 00 00 00 00       	mov    $0x0,%edx
  800048:	39 da                	cmp    %ebx,%edx
  80004a:	7d 0e                	jge    80005a <sum+0x27>
		tot ^= i * s[i];
  80004c:	0f be 0c 16          	movsbl (%esi,%edx,1),%ecx
  800050:	0f af ca             	imul   %edx,%ecx
  800053:	31 c8                	xor    %ecx,%eax
	for (i = 0; i < n; i++)
  800055:	83 c2 01             	add    $0x1,%edx
  800058:	eb ee                	jmp    800048 <sum+0x15>
	return tot;
}
  80005a:	5b                   	pop    %ebx
  80005b:	5e                   	pop    %esi
  80005c:	5d                   	pop    %ebp
  80005d:	c3                   	ret    

0080005e <umain>:

void
umain(int argc, char **argv)
{
  80005e:	55                   	push   %ebp
  80005f:	89 e5                	mov    %esp,%ebp
  800061:	57                   	push   %edi
  800062:	56                   	push   %esi
  800063:	53                   	push   %ebx
  800064:	81 ec 18 01 00 00    	sub    $0x118,%esp
  80006a:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i, r, x, want;
	char args[256];

	cprintf("init: running\n");
  80006d:	68 40 2d 80 00       	push   $0x802d40
  800072:	e8 92 04 00 00       	call   800509 <cprintf>

	want = 0xf989e;
	if ((x = sum((char*)&data, sizeof data)) != want)
  800077:	83 c4 08             	add    $0x8,%esp
  80007a:	68 70 17 00 00       	push   $0x1770
  80007f:	68 00 40 80 00       	push   $0x804000
  800084:	e8 aa ff ff ff       	call   800033 <sum>
  800089:	83 c4 10             	add    $0x10,%esp
  80008c:	3d 9e 98 0f 00       	cmp    $0xf989e,%eax
  800091:	0f 84 99 00 00 00    	je     800130 <umain+0xd2>
		cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  800097:	83 ec 04             	sub    $0x4,%esp
  80009a:	68 9e 98 0f 00       	push   $0xf989e
  80009f:	50                   	push   %eax
  8000a0:	68 04 2e 80 00       	push   $0x802e04
  8000a5:	e8 5f 04 00 00       	call   800509 <cprintf>
  8000aa:	83 c4 10             	add    $0x10,%esp
			x, want);
	else
		cprintf("init: data seems okay\n");
	if ((x = sum(bss, sizeof bss)) != 0)
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	68 70 17 00 00       	push   $0x1770
  8000b5:	68 20 60 80 00       	push   $0x806020
  8000ba:	e8 74 ff ff ff       	call   800033 <sum>
  8000bf:	83 c4 10             	add    $0x10,%esp
  8000c2:	85 c0                	test   %eax,%eax
  8000c4:	74 7f                	je     800145 <umain+0xe7>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  8000c6:	83 ec 08             	sub    $0x8,%esp
  8000c9:	50                   	push   %eax
  8000ca:	68 40 2e 80 00       	push   $0x802e40
  8000cf:	e8 35 04 00 00       	call   800509 <cprintf>
  8000d4:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  8000d7:	83 ec 08             	sub    $0x8,%esp
  8000da:	68 7c 2d 80 00       	push   $0x802d7c
  8000df:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8000e5:	50                   	push   %eax
  8000e6:	e8 9d 0b 00 00       	call   800c88 <strcat>
	for (i = 0; i < argc; i++) {
  8000eb:	83 c4 10             	add    $0x10,%esp
  8000ee:	bb 00 00 00 00       	mov    $0x0,%ebx
		strcat(args, " '");
  8000f3:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
	for (i = 0; i < argc; i++) {
  8000f9:	39 fb                	cmp    %edi,%ebx
  8000fb:	7d 5a                	jge    800157 <umain+0xf9>
		strcat(args, " '");
  8000fd:	83 ec 08             	sub    $0x8,%esp
  800100:	68 88 2d 80 00       	push   $0x802d88
  800105:	56                   	push   %esi
  800106:	e8 7d 0b 00 00       	call   800c88 <strcat>
		strcat(args, argv[i]);
  80010b:	83 c4 08             	add    $0x8,%esp
  80010e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800111:	ff 34 98             	pushl  (%eax,%ebx,4)
  800114:	56                   	push   %esi
  800115:	e8 6e 0b 00 00       	call   800c88 <strcat>
		strcat(args, "'");
  80011a:	83 c4 08             	add    $0x8,%esp
  80011d:	68 89 2d 80 00       	push   $0x802d89
  800122:	56                   	push   %esi
  800123:	e8 60 0b 00 00       	call   800c88 <strcat>
	for (i = 0; i < argc; i++) {
  800128:	83 c3 01             	add    $0x1,%ebx
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	eb c9                	jmp    8000f9 <umain+0x9b>
		cprintf("init: data seems okay\n");
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	68 4f 2d 80 00       	push   $0x802d4f
  800138:	e8 cc 03 00 00       	call   800509 <cprintf>
  80013d:	83 c4 10             	add    $0x10,%esp
  800140:	e9 68 ff ff ff       	jmp    8000ad <umain+0x4f>
		cprintf("init: bss seems okay\n");
  800145:	83 ec 0c             	sub    $0xc,%esp
  800148:	68 66 2d 80 00       	push   $0x802d66
  80014d:	e8 b7 03 00 00       	call   800509 <cprintf>
  800152:	83 c4 10             	add    $0x10,%esp
  800155:	eb 80                	jmp    8000d7 <umain+0x79>
	}
	cprintf("%s\n", args);
  800157:	83 ec 08             	sub    $0x8,%esp
  80015a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800160:	50                   	push   %eax
  800161:	68 8c 2e 80 00       	push   $0x802e8c
  800166:	e8 9e 03 00 00       	call   800509 <cprintf>

	cprintf("init: running sh\n");
  80016b:	c7 04 24 8b 2d 80 00 	movl   $0x802d8b,(%esp)
  800172:	e8 92 03 00 00       	call   800509 <cprintf>

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  800177:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80017e:	e8 77 13 00 00       	call   8014fa <close>
	if ((r = opencons()) < 0)
  800183:	e8 bc 01 00 00       	call   800344 <opencons>
  800188:	83 c4 10             	add    $0x10,%esp
  80018b:	85 c0                	test   %eax,%eax
  80018d:	78 14                	js     8001a3 <umain+0x145>
		panic("opencons: %e", r);
	if (r != 0)
  80018f:	74 24                	je     8001b5 <umain+0x157>
		panic("first opencons used fd %d", r);
  800191:	50                   	push   %eax
  800192:	68 b6 2d 80 00       	push   $0x802db6
  800197:	6a 39                	push   $0x39
  800199:	68 aa 2d 80 00       	push   $0x802daa
  80019e:	e8 70 02 00 00       	call   800413 <_panic>
		panic("opencons: %e", r);
  8001a3:	50                   	push   %eax
  8001a4:	68 9d 2d 80 00       	push   $0x802d9d
  8001a9:	6a 37                	push   $0x37
  8001ab:	68 aa 2d 80 00       	push   $0x802daa
  8001b0:	e8 5e 02 00 00       	call   800413 <_panic>
	if ((r = dup(0, 1)) < 0)
  8001b5:	83 ec 08             	sub    $0x8,%esp
  8001b8:	6a 01                	push   $0x1
  8001ba:	6a 00                	push   $0x0
  8001bc:	e8 8b 13 00 00       	call   80154c <dup>
  8001c1:	83 c4 10             	add    $0x10,%esp
  8001c4:	85 c0                	test   %eax,%eax
  8001c6:	79 23                	jns    8001eb <umain+0x18d>
		panic("dup: %e", r);
  8001c8:	50                   	push   %eax
  8001c9:	68 d0 2d 80 00       	push   $0x802dd0
  8001ce:	6a 3b                	push   $0x3b
  8001d0:	68 aa 2d 80 00       	push   $0x802daa
  8001d5:	e8 39 02 00 00       	call   800413 <_panic>
	while (1) {
		cprintf("init: starting sh\n");
		r = spawnl("/sh", "sh", (char*)0);
		if (r < 0) {
			cprintf("init: spawn sh: %e\n", r);
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	50                   	push   %eax
  8001de:	68 ef 2d 80 00       	push   $0x802def
  8001e3:	e8 21 03 00 00       	call   800509 <cprintf>
			continue;
  8001e8:	83 c4 10             	add    $0x10,%esp
		cprintf("init: starting sh\n");
  8001eb:	83 ec 0c             	sub    $0xc,%esp
  8001ee:	68 d8 2d 80 00       	push   $0x802dd8
  8001f3:	e8 11 03 00 00       	call   800509 <cprintf>
		r = spawnl("/sh", "sh", (char*)0);
  8001f8:	83 c4 0c             	add    $0xc,%esp
  8001fb:	6a 00                	push   $0x0
  8001fd:	68 ec 2d 80 00       	push   $0x802dec
  800202:	68 eb 2d 80 00       	push   $0x802deb
  800207:	e8 fd 1e 00 00       	call   802109 <spawnl>
		if (r < 0) {
  80020c:	83 c4 10             	add    $0x10,%esp
  80020f:	85 c0                	test   %eax,%eax
  800211:	78 c7                	js     8001da <umain+0x17c>
		}
		wait(r);
  800213:	83 ec 0c             	sub    $0xc,%esp
  800216:	50                   	push   %eax
  800217:	e8 31 27 00 00       	call   80294d <wait>
  80021c:	83 c4 10             	add    $0x10,%esp
  80021f:	eb ca                	jmp    8001eb <umain+0x18d>

00800221 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  800221:	b8 00 00 00 00       	mov    $0x0,%eax
  800226:	c3                   	ret    

00800227 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800227:	55                   	push   %ebp
  800228:	89 e5                	mov    %esp,%ebp
  80022a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80022d:	68 6f 2e 80 00       	push   $0x802e6f
  800232:	ff 75 0c             	pushl  0xc(%ebp)
  800235:	e8 2e 0a 00 00       	call   800c68 <strcpy>
	return 0;
}
  80023a:	b8 00 00 00 00       	mov    $0x0,%eax
  80023f:	c9                   	leave  
  800240:	c3                   	ret    

00800241 <devcons_write>:
{
  800241:	55                   	push   %ebp
  800242:	89 e5                	mov    %esp,%ebp
  800244:	57                   	push   %edi
  800245:	56                   	push   %esi
  800246:	53                   	push   %ebx
  800247:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80024d:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800252:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800258:	3b 75 10             	cmp    0x10(%ebp),%esi
  80025b:	73 31                	jae    80028e <devcons_write+0x4d>
		m = n - tot;
  80025d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800260:	29 f3                	sub    %esi,%ebx
  800262:	83 fb 7f             	cmp    $0x7f,%ebx
  800265:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80026a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80026d:	83 ec 04             	sub    $0x4,%esp
  800270:	53                   	push   %ebx
  800271:	89 f0                	mov    %esi,%eax
  800273:	03 45 0c             	add    0xc(%ebp),%eax
  800276:	50                   	push   %eax
  800277:	57                   	push   %edi
  800278:	e8 79 0b 00 00       	call   800df6 <memmove>
		sys_cputs(buf, m);
  80027d:	83 c4 08             	add    $0x8,%esp
  800280:	53                   	push   %ebx
  800281:	57                   	push   %edi
  800282:	e8 17 0d 00 00       	call   800f9e <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800287:	01 de                	add    %ebx,%esi
  800289:	83 c4 10             	add    $0x10,%esp
  80028c:	eb ca                	jmp    800258 <devcons_write+0x17>
}
  80028e:	89 f0                	mov    %esi,%eax
  800290:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800293:	5b                   	pop    %ebx
  800294:	5e                   	pop    %esi
  800295:	5f                   	pop    %edi
  800296:	5d                   	pop    %ebp
  800297:	c3                   	ret    

00800298 <devcons_read>:
{
  800298:	55                   	push   %ebp
  800299:	89 e5                	mov    %esp,%ebp
  80029b:	83 ec 08             	sub    $0x8,%esp
  80029e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8002a3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8002a7:	74 21                	je     8002ca <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8002a9:	e8 0e 0d 00 00       	call   800fbc <sys_cgetc>
  8002ae:	85 c0                	test   %eax,%eax
  8002b0:	75 07                	jne    8002b9 <devcons_read+0x21>
		sys_yield();
  8002b2:	e8 84 0d 00 00       	call   80103b <sys_yield>
  8002b7:	eb f0                	jmp    8002a9 <devcons_read+0x11>
	if (c < 0)
  8002b9:	78 0f                	js     8002ca <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8002bb:	83 f8 04             	cmp    $0x4,%eax
  8002be:	74 0c                	je     8002cc <devcons_read+0x34>
	*(char*)vbuf = c;
  8002c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c3:	88 02                	mov    %al,(%edx)
	return 1;
  8002c5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8002ca:	c9                   	leave  
  8002cb:	c3                   	ret    
		return 0;
  8002cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d1:	eb f7                	jmp    8002ca <devcons_read+0x32>

008002d3 <cputchar>:
{
  8002d3:	55                   	push   %ebp
  8002d4:	89 e5                	mov    %esp,%ebp
  8002d6:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8002d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002dc:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8002df:	6a 01                	push   $0x1
  8002e1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8002e4:	50                   	push   %eax
  8002e5:	e8 b4 0c 00 00       	call   800f9e <sys_cputs>
}
  8002ea:	83 c4 10             	add    $0x10,%esp
  8002ed:	c9                   	leave  
  8002ee:	c3                   	ret    

008002ef <getchar>:
{
  8002ef:	55                   	push   %ebp
  8002f0:	89 e5                	mov    %esp,%ebp
  8002f2:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8002f5:	6a 01                	push   $0x1
  8002f7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8002fa:	50                   	push   %eax
  8002fb:	6a 00                	push   $0x0
  8002fd:	e8 36 13 00 00       	call   801638 <read>
	if (r < 0)
  800302:	83 c4 10             	add    $0x10,%esp
  800305:	85 c0                	test   %eax,%eax
  800307:	78 06                	js     80030f <getchar+0x20>
	if (r < 1)
  800309:	74 06                	je     800311 <getchar+0x22>
	return c;
  80030b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80030f:	c9                   	leave  
  800310:	c3                   	ret    
		return -E_EOF;
  800311:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800316:	eb f7                	jmp    80030f <getchar+0x20>

00800318 <iscons>:
{
  800318:	55                   	push   %ebp
  800319:	89 e5                	mov    %esp,%ebp
  80031b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80031e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800321:	50                   	push   %eax
  800322:	ff 75 08             	pushl  0x8(%ebp)
  800325:	e8 9e 10 00 00       	call   8013c8 <fd_lookup>
  80032a:	83 c4 10             	add    $0x10,%esp
  80032d:	85 c0                	test   %eax,%eax
  80032f:	78 11                	js     800342 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  800331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800334:	8b 15 70 57 80 00    	mov    0x805770,%edx
  80033a:	39 10                	cmp    %edx,(%eax)
  80033c:	0f 94 c0             	sete   %al
  80033f:	0f b6 c0             	movzbl %al,%eax
}
  800342:	c9                   	leave  
  800343:	c3                   	ret    

00800344 <opencons>:
{
  800344:	55                   	push   %ebp
  800345:	89 e5                	mov    %esp,%ebp
  800347:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80034a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80034d:	50                   	push   %eax
  80034e:	e8 23 10 00 00       	call   801376 <fd_alloc>
  800353:	83 c4 10             	add    $0x10,%esp
  800356:	85 c0                	test   %eax,%eax
  800358:	78 3a                	js     800394 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80035a:	83 ec 04             	sub    $0x4,%esp
  80035d:	68 07 04 00 00       	push   $0x407
  800362:	ff 75 f4             	pushl  -0xc(%ebp)
  800365:	6a 00                	push   $0x0
  800367:	e8 ee 0c 00 00       	call   80105a <sys_page_alloc>
  80036c:	83 c4 10             	add    $0x10,%esp
  80036f:	85 c0                	test   %eax,%eax
  800371:	78 21                	js     800394 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  800373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800376:	8b 15 70 57 80 00    	mov    0x805770,%edx
  80037c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80037e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800381:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800388:	83 ec 0c             	sub    $0xc,%esp
  80038b:	50                   	push   %eax
  80038c:	e8 be 0f 00 00       	call   80134f <fd2num>
  800391:	83 c4 10             	add    $0x10,%esp
}
  800394:	c9                   	leave  
  800395:	c3                   	ret    

00800396 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800396:	55                   	push   %ebp
  800397:	89 e5                	mov    %esp,%ebp
  800399:	56                   	push   %esi
  80039a:	53                   	push   %ebx
  80039b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80039e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  8003a1:	e8 76 0c 00 00       	call   80101c <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  8003a6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003ab:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8003b1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003b6:	a3 90 77 80 00       	mov    %eax,0x807790

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003bb:	85 db                	test   %ebx,%ebx
  8003bd:	7e 07                	jle    8003c6 <libmain+0x30>
		binaryname = argv[0];
  8003bf:	8b 06                	mov    (%esi),%eax
  8003c1:	a3 8c 57 80 00       	mov    %eax,0x80578c

	// call user main routine
	umain(argc, argv);
  8003c6:	83 ec 08             	sub    $0x8,%esp
  8003c9:	56                   	push   %esi
  8003ca:	53                   	push   %ebx
  8003cb:	e8 8e fc ff ff       	call   80005e <umain>

	// exit gracefully
	exit();
  8003d0:	e8 0a 00 00 00       	call   8003df <exit>
}
  8003d5:	83 c4 10             	add    $0x10,%esp
  8003d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8003db:	5b                   	pop    %ebx
  8003dc:	5e                   	pop    %esi
  8003dd:	5d                   	pop    %ebp
  8003de:	c3                   	ret    

008003df <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003df:	55                   	push   %ebp
  8003e0:	89 e5                	mov    %esp,%ebp
  8003e2:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8003e5:	a1 90 77 80 00       	mov    0x807790,%eax
  8003ea:	8b 40 48             	mov    0x48(%eax),%eax
  8003ed:	68 90 2e 80 00       	push   $0x802e90
  8003f2:	50                   	push   %eax
  8003f3:	68 85 2e 80 00       	push   $0x802e85
  8003f8:	e8 0c 01 00 00       	call   800509 <cprintf>
	close_all();
  8003fd:	e8 25 11 00 00       	call   801527 <close_all>
	sys_env_destroy(0);
  800402:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800409:	e8 cd 0b 00 00       	call   800fdb <sys_env_destroy>
}
  80040e:	83 c4 10             	add    $0x10,%esp
  800411:	c9                   	leave  
  800412:	c3                   	ret    

00800413 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800413:	55                   	push   %ebp
  800414:	89 e5                	mov    %esp,%ebp
  800416:	56                   	push   %esi
  800417:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800418:	a1 90 77 80 00       	mov    0x807790,%eax
  80041d:	8b 40 48             	mov    0x48(%eax),%eax
  800420:	83 ec 04             	sub    $0x4,%esp
  800423:	68 bc 2e 80 00       	push   $0x802ebc
  800428:	50                   	push   %eax
  800429:	68 85 2e 80 00       	push   $0x802e85
  80042e:	e8 d6 00 00 00       	call   800509 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800433:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800436:	8b 35 8c 57 80 00    	mov    0x80578c,%esi
  80043c:	e8 db 0b 00 00       	call   80101c <sys_getenvid>
  800441:	83 c4 04             	add    $0x4,%esp
  800444:	ff 75 0c             	pushl  0xc(%ebp)
  800447:	ff 75 08             	pushl  0x8(%ebp)
  80044a:	56                   	push   %esi
  80044b:	50                   	push   %eax
  80044c:	68 98 2e 80 00       	push   $0x802e98
  800451:	e8 b3 00 00 00       	call   800509 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800456:	83 c4 18             	add    $0x18,%esp
  800459:	53                   	push   %ebx
  80045a:	ff 75 10             	pushl  0x10(%ebp)
  80045d:	e8 56 00 00 00       	call   8004b8 <vcprintf>
	cprintf("\n");
  800462:	c7 04 24 97 34 80 00 	movl   $0x803497,(%esp)
  800469:	e8 9b 00 00 00       	call   800509 <cprintf>
  80046e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800471:	cc                   	int3   
  800472:	eb fd                	jmp    800471 <_panic+0x5e>

00800474 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800474:	55                   	push   %ebp
  800475:	89 e5                	mov    %esp,%ebp
  800477:	53                   	push   %ebx
  800478:	83 ec 04             	sub    $0x4,%esp
  80047b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80047e:	8b 13                	mov    (%ebx),%edx
  800480:	8d 42 01             	lea    0x1(%edx),%eax
  800483:	89 03                	mov    %eax,(%ebx)
  800485:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800488:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80048c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800491:	74 09                	je     80049c <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800493:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800497:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80049a:	c9                   	leave  
  80049b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80049c:	83 ec 08             	sub    $0x8,%esp
  80049f:	68 ff 00 00 00       	push   $0xff
  8004a4:	8d 43 08             	lea    0x8(%ebx),%eax
  8004a7:	50                   	push   %eax
  8004a8:	e8 f1 0a 00 00       	call   800f9e <sys_cputs>
		b->idx = 0;
  8004ad:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8004b3:	83 c4 10             	add    $0x10,%esp
  8004b6:	eb db                	jmp    800493 <putch+0x1f>

008004b8 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8004b8:	55                   	push   %ebp
  8004b9:	89 e5                	mov    %esp,%ebp
  8004bb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004c1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004c8:	00 00 00 
	b.cnt = 0;
  8004cb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004d2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8004d5:	ff 75 0c             	pushl  0xc(%ebp)
  8004d8:	ff 75 08             	pushl  0x8(%ebp)
  8004db:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004e1:	50                   	push   %eax
  8004e2:	68 74 04 80 00       	push   $0x800474
  8004e7:	e8 4a 01 00 00       	call   800636 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004ec:	83 c4 08             	add    $0x8,%esp
  8004ef:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8004f5:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004fb:	50                   	push   %eax
  8004fc:	e8 9d 0a 00 00       	call   800f9e <sys_cputs>

	return b.cnt;
}
  800501:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800507:	c9                   	leave  
  800508:	c3                   	ret    

00800509 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800509:	55                   	push   %ebp
  80050a:	89 e5                	mov    %esp,%ebp
  80050c:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80050f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800512:	50                   	push   %eax
  800513:	ff 75 08             	pushl  0x8(%ebp)
  800516:	e8 9d ff ff ff       	call   8004b8 <vcprintf>
	va_end(ap);

	return cnt;
}
  80051b:	c9                   	leave  
  80051c:	c3                   	ret    

0080051d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80051d:	55                   	push   %ebp
  80051e:	89 e5                	mov    %esp,%ebp
  800520:	57                   	push   %edi
  800521:	56                   	push   %esi
  800522:	53                   	push   %ebx
  800523:	83 ec 1c             	sub    $0x1c,%esp
  800526:	89 c6                	mov    %eax,%esi
  800528:	89 d7                	mov    %edx,%edi
  80052a:	8b 45 08             	mov    0x8(%ebp),%eax
  80052d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800530:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800533:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800536:	8b 45 10             	mov    0x10(%ebp),%eax
  800539:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80053c:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800540:	74 2c                	je     80056e <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800542:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800545:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80054c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80054f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800552:	39 c2                	cmp    %eax,%edx
  800554:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800557:	73 43                	jae    80059c <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800559:	83 eb 01             	sub    $0x1,%ebx
  80055c:	85 db                	test   %ebx,%ebx
  80055e:	7e 6c                	jle    8005cc <printnum+0xaf>
				putch(padc, putdat);
  800560:	83 ec 08             	sub    $0x8,%esp
  800563:	57                   	push   %edi
  800564:	ff 75 18             	pushl  0x18(%ebp)
  800567:	ff d6                	call   *%esi
  800569:	83 c4 10             	add    $0x10,%esp
  80056c:	eb eb                	jmp    800559 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80056e:	83 ec 0c             	sub    $0xc,%esp
  800571:	6a 20                	push   $0x20
  800573:	6a 00                	push   $0x0
  800575:	50                   	push   %eax
  800576:	ff 75 e4             	pushl  -0x1c(%ebp)
  800579:	ff 75 e0             	pushl  -0x20(%ebp)
  80057c:	89 fa                	mov    %edi,%edx
  80057e:	89 f0                	mov    %esi,%eax
  800580:	e8 98 ff ff ff       	call   80051d <printnum>
		while (--width > 0)
  800585:	83 c4 20             	add    $0x20,%esp
  800588:	83 eb 01             	sub    $0x1,%ebx
  80058b:	85 db                	test   %ebx,%ebx
  80058d:	7e 65                	jle    8005f4 <printnum+0xd7>
			putch(padc, putdat);
  80058f:	83 ec 08             	sub    $0x8,%esp
  800592:	57                   	push   %edi
  800593:	6a 20                	push   $0x20
  800595:	ff d6                	call   *%esi
  800597:	83 c4 10             	add    $0x10,%esp
  80059a:	eb ec                	jmp    800588 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80059c:	83 ec 0c             	sub    $0xc,%esp
  80059f:	ff 75 18             	pushl  0x18(%ebp)
  8005a2:	83 eb 01             	sub    $0x1,%ebx
  8005a5:	53                   	push   %ebx
  8005a6:	50                   	push   %eax
  8005a7:	83 ec 08             	sub    $0x8,%esp
  8005aa:	ff 75 dc             	pushl  -0x24(%ebp)
  8005ad:	ff 75 d8             	pushl  -0x28(%ebp)
  8005b0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005b3:	ff 75 e0             	pushl  -0x20(%ebp)
  8005b6:	e8 25 25 00 00       	call   802ae0 <__udivdi3>
  8005bb:	83 c4 18             	add    $0x18,%esp
  8005be:	52                   	push   %edx
  8005bf:	50                   	push   %eax
  8005c0:	89 fa                	mov    %edi,%edx
  8005c2:	89 f0                	mov    %esi,%eax
  8005c4:	e8 54 ff ff ff       	call   80051d <printnum>
  8005c9:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8005cc:	83 ec 08             	sub    $0x8,%esp
  8005cf:	57                   	push   %edi
  8005d0:	83 ec 04             	sub    $0x4,%esp
  8005d3:	ff 75 dc             	pushl  -0x24(%ebp)
  8005d6:	ff 75 d8             	pushl  -0x28(%ebp)
  8005d9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005dc:	ff 75 e0             	pushl  -0x20(%ebp)
  8005df:	e8 0c 26 00 00       	call   802bf0 <__umoddi3>
  8005e4:	83 c4 14             	add    $0x14,%esp
  8005e7:	0f be 80 c3 2e 80 00 	movsbl 0x802ec3(%eax),%eax
  8005ee:	50                   	push   %eax
  8005ef:	ff d6                	call   *%esi
  8005f1:	83 c4 10             	add    $0x10,%esp
	}
}
  8005f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005f7:	5b                   	pop    %ebx
  8005f8:	5e                   	pop    %esi
  8005f9:	5f                   	pop    %edi
  8005fa:	5d                   	pop    %ebp
  8005fb:	c3                   	ret    

008005fc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005fc:	55                   	push   %ebp
  8005fd:	89 e5                	mov    %esp,%ebp
  8005ff:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800602:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800606:	8b 10                	mov    (%eax),%edx
  800608:	3b 50 04             	cmp    0x4(%eax),%edx
  80060b:	73 0a                	jae    800617 <sprintputch+0x1b>
		*b->buf++ = ch;
  80060d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800610:	89 08                	mov    %ecx,(%eax)
  800612:	8b 45 08             	mov    0x8(%ebp),%eax
  800615:	88 02                	mov    %al,(%edx)
}
  800617:	5d                   	pop    %ebp
  800618:	c3                   	ret    

00800619 <printfmt>:
{
  800619:	55                   	push   %ebp
  80061a:	89 e5                	mov    %esp,%ebp
  80061c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80061f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800622:	50                   	push   %eax
  800623:	ff 75 10             	pushl  0x10(%ebp)
  800626:	ff 75 0c             	pushl  0xc(%ebp)
  800629:	ff 75 08             	pushl  0x8(%ebp)
  80062c:	e8 05 00 00 00       	call   800636 <vprintfmt>
}
  800631:	83 c4 10             	add    $0x10,%esp
  800634:	c9                   	leave  
  800635:	c3                   	ret    

00800636 <vprintfmt>:
{
  800636:	55                   	push   %ebp
  800637:	89 e5                	mov    %esp,%ebp
  800639:	57                   	push   %edi
  80063a:	56                   	push   %esi
  80063b:	53                   	push   %ebx
  80063c:	83 ec 3c             	sub    $0x3c,%esp
  80063f:	8b 75 08             	mov    0x8(%ebp),%esi
  800642:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800645:	8b 7d 10             	mov    0x10(%ebp),%edi
  800648:	e9 32 04 00 00       	jmp    800a7f <vprintfmt+0x449>
		padc = ' ';
  80064d:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800651:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800658:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80065f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800666:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80066d:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800674:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800679:	8d 47 01             	lea    0x1(%edi),%eax
  80067c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80067f:	0f b6 17             	movzbl (%edi),%edx
  800682:	8d 42 dd             	lea    -0x23(%edx),%eax
  800685:	3c 55                	cmp    $0x55,%al
  800687:	0f 87 12 05 00 00    	ja     800b9f <vprintfmt+0x569>
  80068d:	0f b6 c0             	movzbl %al,%eax
  800690:	ff 24 85 a0 30 80 00 	jmp    *0x8030a0(,%eax,4)
  800697:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80069a:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80069e:	eb d9                	jmp    800679 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8006a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8006a3:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8006a7:	eb d0                	jmp    800679 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8006a9:	0f b6 d2             	movzbl %dl,%edx
  8006ac:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8006af:	b8 00 00 00 00       	mov    $0x0,%eax
  8006b4:	89 75 08             	mov    %esi,0x8(%ebp)
  8006b7:	eb 03                	jmp    8006bc <vprintfmt+0x86>
  8006b9:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8006bc:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8006bf:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8006c3:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8006c6:	8d 72 d0             	lea    -0x30(%edx),%esi
  8006c9:	83 fe 09             	cmp    $0x9,%esi
  8006cc:	76 eb                	jbe    8006b9 <vprintfmt+0x83>
  8006ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d1:	8b 75 08             	mov    0x8(%ebp),%esi
  8006d4:	eb 14                	jmp    8006ea <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8006d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d9:	8b 00                	mov    (%eax),%eax
  8006db:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006de:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e1:	8d 40 04             	lea    0x4(%eax),%eax
  8006e4:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8006ea:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006ee:	79 89                	jns    800679 <vprintfmt+0x43>
				width = precision, precision = -1;
  8006f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006f6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8006fd:	e9 77 ff ff ff       	jmp    800679 <vprintfmt+0x43>
  800702:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800705:	85 c0                	test   %eax,%eax
  800707:	0f 48 c1             	cmovs  %ecx,%eax
  80070a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80070d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800710:	e9 64 ff ff ff       	jmp    800679 <vprintfmt+0x43>
  800715:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800718:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80071f:	e9 55 ff ff ff       	jmp    800679 <vprintfmt+0x43>
			lflag++;
  800724:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800728:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80072b:	e9 49 ff ff ff       	jmp    800679 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800730:	8b 45 14             	mov    0x14(%ebp),%eax
  800733:	8d 78 04             	lea    0x4(%eax),%edi
  800736:	83 ec 08             	sub    $0x8,%esp
  800739:	53                   	push   %ebx
  80073a:	ff 30                	pushl  (%eax)
  80073c:	ff d6                	call   *%esi
			break;
  80073e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800741:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800744:	e9 33 03 00 00       	jmp    800a7c <vprintfmt+0x446>
			err = va_arg(ap, int);
  800749:	8b 45 14             	mov    0x14(%ebp),%eax
  80074c:	8d 78 04             	lea    0x4(%eax),%edi
  80074f:	8b 00                	mov    (%eax),%eax
  800751:	99                   	cltd   
  800752:	31 d0                	xor    %edx,%eax
  800754:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800756:	83 f8 11             	cmp    $0x11,%eax
  800759:	7f 23                	jg     80077e <vprintfmt+0x148>
  80075b:	8b 14 85 00 32 80 00 	mov    0x803200(,%eax,4),%edx
  800762:	85 d2                	test   %edx,%edx
  800764:	74 18                	je     80077e <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800766:	52                   	push   %edx
  800767:	68 1d 33 80 00       	push   $0x80331d
  80076c:	53                   	push   %ebx
  80076d:	56                   	push   %esi
  80076e:	e8 a6 fe ff ff       	call   800619 <printfmt>
  800773:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800776:	89 7d 14             	mov    %edi,0x14(%ebp)
  800779:	e9 fe 02 00 00       	jmp    800a7c <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80077e:	50                   	push   %eax
  80077f:	68 db 2e 80 00       	push   $0x802edb
  800784:	53                   	push   %ebx
  800785:	56                   	push   %esi
  800786:	e8 8e fe ff ff       	call   800619 <printfmt>
  80078b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80078e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800791:	e9 e6 02 00 00       	jmp    800a7c <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800796:	8b 45 14             	mov    0x14(%ebp),%eax
  800799:	83 c0 04             	add    $0x4,%eax
  80079c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80079f:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a2:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8007a4:	85 c9                	test   %ecx,%ecx
  8007a6:	b8 d4 2e 80 00       	mov    $0x802ed4,%eax
  8007ab:	0f 45 c1             	cmovne %ecx,%eax
  8007ae:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8007b1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007b5:	7e 06                	jle    8007bd <vprintfmt+0x187>
  8007b7:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8007bb:	75 0d                	jne    8007ca <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007bd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8007c0:	89 c7                	mov    %eax,%edi
  8007c2:	03 45 e0             	add    -0x20(%ebp),%eax
  8007c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007c8:	eb 53                	jmp    80081d <vprintfmt+0x1e7>
  8007ca:	83 ec 08             	sub    $0x8,%esp
  8007cd:	ff 75 d8             	pushl  -0x28(%ebp)
  8007d0:	50                   	push   %eax
  8007d1:	e8 71 04 00 00       	call   800c47 <strnlen>
  8007d6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007d9:	29 c1                	sub    %eax,%ecx
  8007db:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8007de:	83 c4 10             	add    $0x10,%esp
  8007e1:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8007e3:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8007e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8007ea:	eb 0f                	jmp    8007fb <vprintfmt+0x1c5>
					putch(padc, putdat);
  8007ec:	83 ec 08             	sub    $0x8,%esp
  8007ef:	53                   	push   %ebx
  8007f0:	ff 75 e0             	pushl  -0x20(%ebp)
  8007f3:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007f5:	83 ef 01             	sub    $0x1,%edi
  8007f8:	83 c4 10             	add    $0x10,%esp
  8007fb:	85 ff                	test   %edi,%edi
  8007fd:	7f ed                	jg     8007ec <vprintfmt+0x1b6>
  8007ff:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800802:	85 c9                	test   %ecx,%ecx
  800804:	b8 00 00 00 00       	mov    $0x0,%eax
  800809:	0f 49 c1             	cmovns %ecx,%eax
  80080c:	29 c1                	sub    %eax,%ecx
  80080e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800811:	eb aa                	jmp    8007bd <vprintfmt+0x187>
					putch(ch, putdat);
  800813:	83 ec 08             	sub    $0x8,%esp
  800816:	53                   	push   %ebx
  800817:	52                   	push   %edx
  800818:	ff d6                	call   *%esi
  80081a:	83 c4 10             	add    $0x10,%esp
  80081d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800820:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800822:	83 c7 01             	add    $0x1,%edi
  800825:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800829:	0f be d0             	movsbl %al,%edx
  80082c:	85 d2                	test   %edx,%edx
  80082e:	74 4b                	je     80087b <vprintfmt+0x245>
  800830:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800834:	78 06                	js     80083c <vprintfmt+0x206>
  800836:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80083a:	78 1e                	js     80085a <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80083c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800840:	74 d1                	je     800813 <vprintfmt+0x1dd>
  800842:	0f be c0             	movsbl %al,%eax
  800845:	83 e8 20             	sub    $0x20,%eax
  800848:	83 f8 5e             	cmp    $0x5e,%eax
  80084b:	76 c6                	jbe    800813 <vprintfmt+0x1dd>
					putch('?', putdat);
  80084d:	83 ec 08             	sub    $0x8,%esp
  800850:	53                   	push   %ebx
  800851:	6a 3f                	push   $0x3f
  800853:	ff d6                	call   *%esi
  800855:	83 c4 10             	add    $0x10,%esp
  800858:	eb c3                	jmp    80081d <vprintfmt+0x1e7>
  80085a:	89 cf                	mov    %ecx,%edi
  80085c:	eb 0e                	jmp    80086c <vprintfmt+0x236>
				putch(' ', putdat);
  80085e:	83 ec 08             	sub    $0x8,%esp
  800861:	53                   	push   %ebx
  800862:	6a 20                	push   $0x20
  800864:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800866:	83 ef 01             	sub    $0x1,%edi
  800869:	83 c4 10             	add    $0x10,%esp
  80086c:	85 ff                	test   %edi,%edi
  80086e:	7f ee                	jg     80085e <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800870:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800873:	89 45 14             	mov    %eax,0x14(%ebp)
  800876:	e9 01 02 00 00       	jmp    800a7c <vprintfmt+0x446>
  80087b:	89 cf                	mov    %ecx,%edi
  80087d:	eb ed                	jmp    80086c <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80087f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800882:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800889:	e9 eb fd ff ff       	jmp    800679 <vprintfmt+0x43>
	if (lflag >= 2)
  80088e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800892:	7f 21                	jg     8008b5 <vprintfmt+0x27f>
	else if (lflag)
  800894:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800898:	74 68                	je     800902 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80089a:	8b 45 14             	mov    0x14(%ebp),%eax
  80089d:	8b 00                	mov    (%eax),%eax
  80089f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008a2:	89 c1                	mov    %eax,%ecx
  8008a4:	c1 f9 1f             	sar    $0x1f,%ecx
  8008a7:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	8d 40 04             	lea    0x4(%eax),%eax
  8008b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b3:	eb 17                	jmp    8008cc <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8008b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b8:	8b 50 04             	mov    0x4(%eax),%edx
  8008bb:	8b 00                	mov    (%eax),%eax
  8008bd:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008c0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8008c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c6:	8d 40 08             	lea    0x8(%eax),%eax
  8008c9:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8008cc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008cf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8008d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008d5:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8008d8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8008dc:	78 3f                	js     80091d <vprintfmt+0x2e7>
			base = 10;
  8008de:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8008e3:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8008e7:	0f 84 71 01 00 00    	je     800a5e <vprintfmt+0x428>
				putch('+', putdat);
  8008ed:	83 ec 08             	sub    $0x8,%esp
  8008f0:	53                   	push   %ebx
  8008f1:	6a 2b                	push   $0x2b
  8008f3:	ff d6                	call   *%esi
  8008f5:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008f8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008fd:	e9 5c 01 00 00       	jmp    800a5e <vprintfmt+0x428>
		return va_arg(*ap, int);
  800902:	8b 45 14             	mov    0x14(%ebp),%eax
  800905:	8b 00                	mov    (%eax),%eax
  800907:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80090a:	89 c1                	mov    %eax,%ecx
  80090c:	c1 f9 1f             	sar    $0x1f,%ecx
  80090f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800912:	8b 45 14             	mov    0x14(%ebp),%eax
  800915:	8d 40 04             	lea    0x4(%eax),%eax
  800918:	89 45 14             	mov    %eax,0x14(%ebp)
  80091b:	eb af                	jmp    8008cc <vprintfmt+0x296>
				putch('-', putdat);
  80091d:	83 ec 08             	sub    $0x8,%esp
  800920:	53                   	push   %ebx
  800921:	6a 2d                	push   $0x2d
  800923:	ff d6                	call   *%esi
				num = -(long long) num;
  800925:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800928:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80092b:	f7 d8                	neg    %eax
  80092d:	83 d2 00             	adc    $0x0,%edx
  800930:	f7 da                	neg    %edx
  800932:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800935:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800938:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80093b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800940:	e9 19 01 00 00       	jmp    800a5e <vprintfmt+0x428>
	if (lflag >= 2)
  800945:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800949:	7f 29                	jg     800974 <vprintfmt+0x33e>
	else if (lflag)
  80094b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80094f:	74 44                	je     800995 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800951:	8b 45 14             	mov    0x14(%ebp),%eax
  800954:	8b 00                	mov    (%eax),%eax
  800956:	ba 00 00 00 00       	mov    $0x0,%edx
  80095b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80095e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800961:	8b 45 14             	mov    0x14(%ebp),%eax
  800964:	8d 40 04             	lea    0x4(%eax),%eax
  800967:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80096a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80096f:	e9 ea 00 00 00       	jmp    800a5e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800974:	8b 45 14             	mov    0x14(%ebp),%eax
  800977:	8b 50 04             	mov    0x4(%eax),%edx
  80097a:	8b 00                	mov    (%eax),%eax
  80097c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80097f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800982:	8b 45 14             	mov    0x14(%ebp),%eax
  800985:	8d 40 08             	lea    0x8(%eax),%eax
  800988:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80098b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800990:	e9 c9 00 00 00       	jmp    800a5e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800995:	8b 45 14             	mov    0x14(%ebp),%eax
  800998:	8b 00                	mov    (%eax),%eax
  80099a:	ba 00 00 00 00       	mov    $0x0,%edx
  80099f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009a2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a8:	8d 40 04             	lea    0x4(%eax),%eax
  8009ab:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009ae:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009b3:	e9 a6 00 00 00       	jmp    800a5e <vprintfmt+0x428>
			putch('0', putdat);
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	53                   	push   %ebx
  8009bc:	6a 30                	push   $0x30
  8009be:	ff d6                	call   *%esi
	if (lflag >= 2)
  8009c0:	83 c4 10             	add    $0x10,%esp
  8009c3:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8009c7:	7f 26                	jg     8009ef <vprintfmt+0x3b9>
	else if (lflag)
  8009c9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8009cd:	74 3e                	je     800a0d <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8009cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d2:	8b 00                	mov    (%eax),%eax
  8009d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009dc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009df:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e2:	8d 40 04             	lea    0x4(%eax),%eax
  8009e5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009e8:	b8 08 00 00 00       	mov    $0x8,%eax
  8009ed:	eb 6f                	jmp    800a5e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8009ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f2:	8b 50 04             	mov    0x4(%eax),%edx
  8009f5:	8b 00                	mov    (%eax),%eax
  8009f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009fa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800a00:	8d 40 08             	lea    0x8(%eax),%eax
  800a03:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a06:	b8 08 00 00 00       	mov    $0x8,%eax
  800a0b:	eb 51                	jmp    800a5e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800a0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a10:	8b 00                	mov    (%eax),%eax
  800a12:	ba 00 00 00 00       	mov    $0x0,%edx
  800a17:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a1a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a20:	8d 40 04             	lea    0x4(%eax),%eax
  800a23:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a26:	b8 08 00 00 00       	mov    $0x8,%eax
  800a2b:	eb 31                	jmp    800a5e <vprintfmt+0x428>
			putch('0', putdat);
  800a2d:	83 ec 08             	sub    $0x8,%esp
  800a30:	53                   	push   %ebx
  800a31:	6a 30                	push   $0x30
  800a33:	ff d6                	call   *%esi
			putch('x', putdat);
  800a35:	83 c4 08             	add    $0x8,%esp
  800a38:	53                   	push   %ebx
  800a39:	6a 78                	push   $0x78
  800a3b:	ff d6                	call   *%esi
			num = (unsigned long long)
  800a3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a40:	8b 00                	mov    (%eax),%eax
  800a42:	ba 00 00 00 00       	mov    $0x0,%edx
  800a47:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a4a:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800a4d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a50:	8b 45 14             	mov    0x14(%ebp),%eax
  800a53:	8d 40 04             	lea    0x4(%eax),%eax
  800a56:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a59:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800a5e:	83 ec 0c             	sub    $0xc,%esp
  800a61:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800a65:	52                   	push   %edx
  800a66:	ff 75 e0             	pushl  -0x20(%ebp)
  800a69:	50                   	push   %eax
  800a6a:	ff 75 dc             	pushl  -0x24(%ebp)
  800a6d:	ff 75 d8             	pushl  -0x28(%ebp)
  800a70:	89 da                	mov    %ebx,%edx
  800a72:	89 f0                	mov    %esi,%eax
  800a74:	e8 a4 fa ff ff       	call   80051d <printnum>
			break;
  800a79:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800a7c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a7f:	83 c7 01             	add    $0x1,%edi
  800a82:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a86:	83 f8 25             	cmp    $0x25,%eax
  800a89:	0f 84 be fb ff ff    	je     80064d <vprintfmt+0x17>
			if (ch == '\0')
  800a8f:	85 c0                	test   %eax,%eax
  800a91:	0f 84 28 01 00 00    	je     800bbf <vprintfmt+0x589>
			putch(ch, putdat);
  800a97:	83 ec 08             	sub    $0x8,%esp
  800a9a:	53                   	push   %ebx
  800a9b:	50                   	push   %eax
  800a9c:	ff d6                	call   *%esi
  800a9e:	83 c4 10             	add    $0x10,%esp
  800aa1:	eb dc                	jmp    800a7f <vprintfmt+0x449>
	if (lflag >= 2)
  800aa3:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800aa7:	7f 26                	jg     800acf <vprintfmt+0x499>
	else if (lflag)
  800aa9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800aad:	74 41                	je     800af0 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800aaf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab2:	8b 00                	mov    (%eax),%eax
  800ab4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800abc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800abf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac2:	8d 40 04             	lea    0x4(%eax),%eax
  800ac5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ac8:	b8 10 00 00 00       	mov    $0x10,%eax
  800acd:	eb 8f                	jmp    800a5e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800acf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad2:	8b 50 04             	mov    0x4(%eax),%edx
  800ad5:	8b 00                	mov    (%eax),%eax
  800ad7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ada:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800add:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae0:	8d 40 08             	lea    0x8(%eax),%eax
  800ae3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ae6:	b8 10 00 00 00       	mov    $0x10,%eax
  800aeb:	e9 6e ff ff ff       	jmp    800a5e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800af0:	8b 45 14             	mov    0x14(%ebp),%eax
  800af3:	8b 00                	mov    (%eax),%eax
  800af5:	ba 00 00 00 00       	mov    $0x0,%edx
  800afa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800afd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b00:	8b 45 14             	mov    0x14(%ebp),%eax
  800b03:	8d 40 04             	lea    0x4(%eax),%eax
  800b06:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b09:	b8 10 00 00 00       	mov    $0x10,%eax
  800b0e:	e9 4b ff ff ff       	jmp    800a5e <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800b13:	8b 45 14             	mov    0x14(%ebp),%eax
  800b16:	83 c0 04             	add    $0x4,%eax
  800b19:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1f:	8b 00                	mov    (%eax),%eax
  800b21:	85 c0                	test   %eax,%eax
  800b23:	74 14                	je     800b39 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800b25:	8b 13                	mov    (%ebx),%edx
  800b27:	83 fa 7f             	cmp    $0x7f,%edx
  800b2a:	7f 37                	jg     800b63 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800b2c:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800b2e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b31:	89 45 14             	mov    %eax,0x14(%ebp)
  800b34:	e9 43 ff ff ff       	jmp    800a7c <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800b39:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b3e:	bf f9 2f 80 00       	mov    $0x802ff9,%edi
							putch(ch, putdat);
  800b43:	83 ec 08             	sub    $0x8,%esp
  800b46:	53                   	push   %ebx
  800b47:	50                   	push   %eax
  800b48:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800b4a:	83 c7 01             	add    $0x1,%edi
  800b4d:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800b51:	83 c4 10             	add    $0x10,%esp
  800b54:	85 c0                	test   %eax,%eax
  800b56:	75 eb                	jne    800b43 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800b58:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b5b:	89 45 14             	mov    %eax,0x14(%ebp)
  800b5e:	e9 19 ff ff ff       	jmp    800a7c <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800b63:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800b65:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b6a:	bf 31 30 80 00       	mov    $0x803031,%edi
							putch(ch, putdat);
  800b6f:	83 ec 08             	sub    $0x8,%esp
  800b72:	53                   	push   %ebx
  800b73:	50                   	push   %eax
  800b74:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800b76:	83 c7 01             	add    $0x1,%edi
  800b79:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800b7d:	83 c4 10             	add    $0x10,%esp
  800b80:	85 c0                	test   %eax,%eax
  800b82:	75 eb                	jne    800b6f <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800b84:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b87:	89 45 14             	mov    %eax,0x14(%ebp)
  800b8a:	e9 ed fe ff ff       	jmp    800a7c <vprintfmt+0x446>
			putch(ch, putdat);
  800b8f:	83 ec 08             	sub    $0x8,%esp
  800b92:	53                   	push   %ebx
  800b93:	6a 25                	push   $0x25
  800b95:	ff d6                	call   *%esi
			break;
  800b97:	83 c4 10             	add    $0x10,%esp
  800b9a:	e9 dd fe ff ff       	jmp    800a7c <vprintfmt+0x446>
			putch('%', putdat);
  800b9f:	83 ec 08             	sub    $0x8,%esp
  800ba2:	53                   	push   %ebx
  800ba3:	6a 25                	push   $0x25
  800ba5:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ba7:	83 c4 10             	add    $0x10,%esp
  800baa:	89 f8                	mov    %edi,%eax
  800bac:	eb 03                	jmp    800bb1 <vprintfmt+0x57b>
  800bae:	83 e8 01             	sub    $0x1,%eax
  800bb1:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800bb5:	75 f7                	jne    800bae <vprintfmt+0x578>
  800bb7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800bba:	e9 bd fe ff ff       	jmp    800a7c <vprintfmt+0x446>
}
  800bbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bc2:	5b                   	pop    %ebx
  800bc3:	5e                   	pop    %esi
  800bc4:	5f                   	pop    %edi
  800bc5:	5d                   	pop    %ebp
  800bc6:	c3                   	ret    

00800bc7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bc7:	55                   	push   %ebp
  800bc8:	89 e5                	mov    %esp,%ebp
  800bca:	83 ec 18             	sub    $0x18,%esp
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bd3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bd6:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800bda:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800bdd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800be4:	85 c0                	test   %eax,%eax
  800be6:	74 26                	je     800c0e <vsnprintf+0x47>
  800be8:	85 d2                	test   %edx,%edx
  800bea:	7e 22                	jle    800c0e <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bec:	ff 75 14             	pushl  0x14(%ebp)
  800bef:	ff 75 10             	pushl  0x10(%ebp)
  800bf2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bf5:	50                   	push   %eax
  800bf6:	68 fc 05 80 00       	push   $0x8005fc
  800bfb:	e8 36 fa ff ff       	call   800636 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c03:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c09:	83 c4 10             	add    $0x10,%esp
}
  800c0c:	c9                   	leave  
  800c0d:	c3                   	ret    
		return -E_INVAL;
  800c0e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c13:	eb f7                	jmp    800c0c <vsnprintf+0x45>

00800c15 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c15:	55                   	push   %ebp
  800c16:	89 e5                	mov    %esp,%ebp
  800c18:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c1b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800c1e:	50                   	push   %eax
  800c1f:	ff 75 10             	pushl  0x10(%ebp)
  800c22:	ff 75 0c             	pushl  0xc(%ebp)
  800c25:	ff 75 08             	pushl  0x8(%ebp)
  800c28:	e8 9a ff ff ff       	call   800bc7 <vsnprintf>
	va_end(ap);

	return rc;
}
  800c2d:	c9                   	leave  
  800c2e:	c3                   	ret    

00800c2f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800c2f:	55                   	push   %ebp
  800c30:	89 e5                	mov    %esp,%ebp
  800c32:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800c35:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800c3e:	74 05                	je     800c45 <strlen+0x16>
		n++;
  800c40:	83 c0 01             	add    $0x1,%eax
  800c43:	eb f5                	jmp    800c3a <strlen+0xb>
	return n;
}
  800c45:	5d                   	pop    %ebp
  800c46:	c3                   	ret    

00800c47 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c47:	55                   	push   %ebp
  800c48:	89 e5                	mov    %esp,%ebp
  800c4a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c4d:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c50:	ba 00 00 00 00       	mov    $0x0,%edx
  800c55:	39 c2                	cmp    %eax,%edx
  800c57:	74 0d                	je     800c66 <strnlen+0x1f>
  800c59:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800c5d:	74 05                	je     800c64 <strnlen+0x1d>
		n++;
  800c5f:	83 c2 01             	add    $0x1,%edx
  800c62:	eb f1                	jmp    800c55 <strnlen+0xe>
  800c64:	89 d0                	mov    %edx,%eax
	return n;
}
  800c66:	5d                   	pop    %ebp
  800c67:	c3                   	ret    

00800c68 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c68:	55                   	push   %ebp
  800c69:	89 e5                	mov    %esp,%ebp
  800c6b:	53                   	push   %ebx
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c72:	ba 00 00 00 00       	mov    $0x0,%edx
  800c77:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800c7b:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800c7e:	83 c2 01             	add    $0x1,%edx
  800c81:	84 c9                	test   %cl,%cl
  800c83:	75 f2                	jne    800c77 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800c85:	5b                   	pop    %ebx
  800c86:	5d                   	pop    %ebp
  800c87:	c3                   	ret    

00800c88 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
  800c8b:	53                   	push   %ebx
  800c8c:	83 ec 10             	sub    $0x10,%esp
  800c8f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c92:	53                   	push   %ebx
  800c93:	e8 97 ff ff ff       	call   800c2f <strlen>
  800c98:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800c9b:	ff 75 0c             	pushl  0xc(%ebp)
  800c9e:	01 d8                	add    %ebx,%eax
  800ca0:	50                   	push   %eax
  800ca1:	e8 c2 ff ff ff       	call   800c68 <strcpy>
	return dst;
}
  800ca6:	89 d8                	mov    %ebx,%eax
  800ca8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cab:	c9                   	leave  
  800cac:	c3                   	ret    

00800cad <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800cad:	55                   	push   %ebp
  800cae:	89 e5                	mov    %esp,%ebp
  800cb0:	56                   	push   %esi
  800cb1:	53                   	push   %ebx
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb8:	89 c6                	mov    %eax,%esi
  800cba:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cbd:	89 c2                	mov    %eax,%edx
  800cbf:	39 f2                	cmp    %esi,%edx
  800cc1:	74 11                	je     800cd4 <strncpy+0x27>
		*dst++ = *src;
  800cc3:	83 c2 01             	add    $0x1,%edx
  800cc6:	0f b6 19             	movzbl (%ecx),%ebx
  800cc9:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ccc:	80 fb 01             	cmp    $0x1,%bl
  800ccf:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800cd2:	eb eb                	jmp    800cbf <strncpy+0x12>
	}
	return ret;
}
  800cd4:	5b                   	pop    %ebx
  800cd5:	5e                   	pop    %esi
  800cd6:	5d                   	pop    %ebp
  800cd7:	c3                   	ret    

00800cd8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800cd8:	55                   	push   %ebp
  800cd9:	89 e5                	mov    %esp,%ebp
  800cdb:	56                   	push   %esi
  800cdc:	53                   	push   %ebx
  800cdd:	8b 75 08             	mov    0x8(%ebp),%esi
  800ce0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce3:	8b 55 10             	mov    0x10(%ebp),%edx
  800ce6:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ce8:	85 d2                	test   %edx,%edx
  800cea:	74 21                	je     800d0d <strlcpy+0x35>
  800cec:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800cf0:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800cf2:	39 c2                	cmp    %eax,%edx
  800cf4:	74 14                	je     800d0a <strlcpy+0x32>
  800cf6:	0f b6 19             	movzbl (%ecx),%ebx
  800cf9:	84 db                	test   %bl,%bl
  800cfb:	74 0b                	je     800d08 <strlcpy+0x30>
			*dst++ = *src++;
  800cfd:	83 c1 01             	add    $0x1,%ecx
  800d00:	83 c2 01             	add    $0x1,%edx
  800d03:	88 5a ff             	mov    %bl,-0x1(%edx)
  800d06:	eb ea                	jmp    800cf2 <strlcpy+0x1a>
  800d08:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800d0a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d0d:	29 f0                	sub    %esi,%eax
}
  800d0f:	5b                   	pop    %ebx
  800d10:	5e                   	pop    %esi
  800d11:	5d                   	pop    %ebp
  800d12:	c3                   	ret    

00800d13 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d13:	55                   	push   %ebp
  800d14:	89 e5                	mov    %esp,%ebp
  800d16:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d19:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800d1c:	0f b6 01             	movzbl (%ecx),%eax
  800d1f:	84 c0                	test   %al,%al
  800d21:	74 0c                	je     800d2f <strcmp+0x1c>
  800d23:	3a 02                	cmp    (%edx),%al
  800d25:	75 08                	jne    800d2f <strcmp+0x1c>
		p++, q++;
  800d27:	83 c1 01             	add    $0x1,%ecx
  800d2a:	83 c2 01             	add    $0x1,%edx
  800d2d:	eb ed                	jmp    800d1c <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d2f:	0f b6 c0             	movzbl %al,%eax
  800d32:	0f b6 12             	movzbl (%edx),%edx
  800d35:	29 d0                	sub    %edx,%eax
}
  800d37:	5d                   	pop    %ebp
  800d38:	c3                   	ret    

00800d39 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	53                   	push   %ebx
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d40:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d43:	89 c3                	mov    %eax,%ebx
  800d45:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d48:	eb 06                	jmp    800d50 <strncmp+0x17>
		n--, p++, q++;
  800d4a:	83 c0 01             	add    $0x1,%eax
  800d4d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800d50:	39 d8                	cmp    %ebx,%eax
  800d52:	74 16                	je     800d6a <strncmp+0x31>
  800d54:	0f b6 08             	movzbl (%eax),%ecx
  800d57:	84 c9                	test   %cl,%cl
  800d59:	74 04                	je     800d5f <strncmp+0x26>
  800d5b:	3a 0a                	cmp    (%edx),%cl
  800d5d:	74 eb                	je     800d4a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d5f:	0f b6 00             	movzbl (%eax),%eax
  800d62:	0f b6 12             	movzbl (%edx),%edx
  800d65:	29 d0                	sub    %edx,%eax
}
  800d67:	5b                   	pop    %ebx
  800d68:	5d                   	pop    %ebp
  800d69:	c3                   	ret    
		return 0;
  800d6a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d6f:	eb f6                	jmp    800d67 <strncmp+0x2e>

00800d71 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d71:	55                   	push   %ebp
  800d72:	89 e5                	mov    %esp,%ebp
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d7b:	0f b6 10             	movzbl (%eax),%edx
  800d7e:	84 d2                	test   %dl,%dl
  800d80:	74 09                	je     800d8b <strchr+0x1a>
		if (*s == c)
  800d82:	38 ca                	cmp    %cl,%dl
  800d84:	74 0a                	je     800d90 <strchr+0x1f>
	for (; *s; s++)
  800d86:	83 c0 01             	add    $0x1,%eax
  800d89:	eb f0                	jmp    800d7b <strchr+0xa>
			return (char *) s;
	return 0;
  800d8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d90:	5d                   	pop    %ebp
  800d91:	c3                   	ret    

00800d92 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d92:	55                   	push   %ebp
  800d93:	89 e5                	mov    %esp,%ebp
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d9c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d9f:	38 ca                	cmp    %cl,%dl
  800da1:	74 09                	je     800dac <strfind+0x1a>
  800da3:	84 d2                	test   %dl,%dl
  800da5:	74 05                	je     800dac <strfind+0x1a>
	for (; *s; s++)
  800da7:	83 c0 01             	add    $0x1,%eax
  800daa:	eb f0                	jmp    800d9c <strfind+0xa>
			break;
	return (char *) s;
}
  800dac:	5d                   	pop    %ebp
  800dad:	c3                   	ret    

00800dae <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800dae:	55                   	push   %ebp
  800daf:	89 e5                	mov    %esp,%ebp
  800db1:	57                   	push   %edi
  800db2:	56                   	push   %esi
  800db3:	53                   	push   %ebx
  800db4:	8b 7d 08             	mov    0x8(%ebp),%edi
  800db7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800dba:	85 c9                	test   %ecx,%ecx
  800dbc:	74 31                	je     800def <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800dbe:	89 f8                	mov    %edi,%eax
  800dc0:	09 c8                	or     %ecx,%eax
  800dc2:	a8 03                	test   $0x3,%al
  800dc4:	75 23                	jne    800de9 <memset+0x3b>
		c &= 0xFF;
  800dc6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800dca:	89 d3                	mov    %edx,%ebx
  800dcc:	c1 e3 08             	shl    $0x8,%ebx
  800dcf:	89 d0                	mov    %edx,%eax
  800dd1:	c1 e0 18             	shl    $0x18,%eax
  800dd4:	89 d6                	mov    %edx,%esi
  800dd6:	c1 e6 10             	shl    $0x10,%esi
  800dd9:	09 f0                	or     %esi,%eax
  800ddb:	09 c2                	or     %eax,%edx
  800ddd:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ddf:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800de2:	89 d0                	mov    %edx,%eax
  800de4:	fc                   	cld    
  800de5:	f3 ab                	rep stos %eax,%es:(%edi)
  800de7:	eb 06                	jmp    800def <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800de9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dec:	fc                   	cld    
  800ded:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800def:	89 f8                	mov    %edi,%eax
  800df1:	5b                   	pop    %ebx
  800df2:	5e                   	pop    %esi
  800df3:	5f                   	pop    %edi
  800df4:	5d                   	pop    %ebp
  800df5:	c3                   	ret    

00800df6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800df6:	55                   	push   %ebp
  800df7:	89 e5                	mov    %esp,%ebp
  800df9:	57                   	push   %edi
  800dfa:	56                   	push   %esi
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e01:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e04:	39 c6                	cmp    %eax,%esi
  800e06:	73 32                	jae    800e3a <memmove+0x44>
  800e08:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800e0b:	39 c2                	cmp    %eax,%edx
  800e0d:	76 2b                	jbe    800e3a <memmove+0x44>
		s += n;
		d += n;
  800e0f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e12:	89 fe                	mov    %edi,%esi
  800e14:	09 ce                	or     %ecx,%esi
  800e16:	09 d6                	or     %edx,%esi
  800e18:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800e1e:	75 0e                	jne    800e2e <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800e20:	83 ef 04             	sub    $0x4,%edi
  800e23:	8d 72 fc             	lea    -0x4(%edx),%esi
  800e26:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800e29:	fd                   	std    
  800e2a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e2c:	eb 09                	jmp    800e37 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800e2e:	83 ef 01             	sub    $0x1,%edi
  800e31:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800e34:	fd                   	std    
  800e35:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e37:	fc                   	cld    
  800e38:	eb 1a                	jmp    800e54 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e3a:	89 c2                	mov    %eax,%edx
  800e3c:	09 ca                	or     %ecx,%edx
  800e3e:	09 f2                	or     %esi,%edx
  800e40:	f6 c2 03             	test   $0x3,%dl
  800e43:	75 0a                	jne    800e4f <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e45:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800e48:	89 c7                	mov    %eax,%edi
  800e4a:	fc                   	cld    
  800e4b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e4d:	eb 05                	jmp    800e54 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800e4f:	89 c7                	mov    %eax,%edi
  800e51:	fc                   	cld    
  800e52:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e54:	5e                   	pop    %esi
  800e55:	5f                   	pop    %edi
  800e56:	5d                   	pop    %ebp
  800e57:	c3                   	ret    

00800e58 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e58:	55                   	push   %ebp
  800e59:	89 e5                	mov    %esp,%ebp
  800e5b:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e5e:	ff 75 10             	pushl  0x10(%ebp)
  800e61:	ff 75 0c             	pushl  0xc(%ebp)
  800e64:	ff 75 08             	pushl  0x8(%ebp)
  800e67:	e8 8a ff ff ff       	call   800df6 <memmove>
}
  800e6c:	c9                   	leave  
  800e6d:	c3                   	ret    

00800e6e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e6e:	55                   	push   %ebp
  800e6f:	89 e5                	mov    %esp,%ebp
  800e71:	56                   	push   %esi
  800e72:	53                   	push   %ebx
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
  800e76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e79:	89 c6                	mov    %eax,%esi
  800e7b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e7e:	39 f0                	cmp    %esi,%eax
  800e80:	74 1c                	je     800e9e <memcmp+0x30>
		if (*s1 != *s2)
  800e82:	0f b6 08             	movzbl (%eax),%ecx
  800e85:	0f b6 1a             	movzbl (%edx),%ebx
  800e88:	38 d9                	cmp    %bl,%cl
  800e8a:	75 08                	jne    800e94 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e8c:	83 c0 01             	add    $0x1,%eax
  800e8f:	83 c2 01             	add    $0x1,%edx
  800e92:	eb ea                	jmp    800e7e <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800e94:	0f b6 c1             	movzbl %cl,%eax
  800e97:	0f b6 db             	movzbl %bl,%ebx
  800e9a:	29 d8                	sub    %ebx,%eax
  800e9c:	eb 05                	jmp    800ea3 <memcmp+0x35>
	}

	return 0;
  800e9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ea3:	5b                   	pop    %ebx
  800ea4:	5e                   	pop    %esi
  800ea5:	5d                   	pop    %ebp
  800ea6:	c3                   	ret    

00800ea7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ea7:	55                   	push   %ebp
  800ea8:	89 e5                	mov    %esp,%ebp
  800eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ead:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800eb0:	89 c2                	mov    %eax,%edx
  800eb2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800eb5:	39 d0                	cmp    %edx,%eax
  800eb7:	73 09                	jae    800ec2 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800eb9:	38 08                	cmp    %cl,(%eax)
  800ebb:	74 05                	je     800ec2 <memfind+0x1b>
	for (; s < ends; s++)
  800ebd:	83 c0 01             	add    $0x1,%eax
  800ec0:	eb f3                	jmp    800eb5 <memfind+0xe>
			break;
	return (void *) s;
}
  800ec2:	5d                   	pop    %ebp
  800ec3:	c3                   	ret    

00800ec4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ec4:	55                   	push   %ebp
  800ec5:	89 e5                	mov    %esp,%ebp
  800ec7:	57                   	push   %edi
  800ec8:	56                   	push   %esi
  800ec9:	53                   	push   %ebx
  800eca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ecd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ed0:	eb 03                	jmp    800ed5 <strtol+0x11>
		s++;
  800ed2:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ed5:	0f b6 01             	movzbl (%ecx),%eax
  800ed8:	3c 20                	cmp    $0x20,%al
  800eda:	74 f6                	je     800ed2 <strtol+0xe>
  800edc:	3c 09                	cmp    $0x9,%al
  800ede:	74 f2                	je     800ed2 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ee0:	3c 2b                	cmp    $0x2b,%al
  800ee2:	74 2a                	je     800f0e <strtol+0x4a>
	int neg = 0;
  800ee4:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ee9:	3c 2d                	cmp    $0x2d,%al
  800eeb:	74 2b                	je     800f18 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800eed:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ef3:	75 0f                	jne    800f04 <strtol+0x40>
  800ef5:	80 39 30             	cmpb   $0x30,(%ecx)
  800ef8:	74 28                	je     800f22 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800efa:	85 db                	test   %ebx,%ebx
  800efc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f01:	0f 44 d8             	cmove  %eax,%ebx
  800f04:	b8 00 00 00 00       	mov    $0x0,%eax
  800f09:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800f0c:	eb 50                	jmp    800f5e <strtol+0x9a>
		s++;
  800f0e:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800f11:	bf 00 00 00 00       	mov    $0x0,%edi
  800f16:	eb d5                	jmp    800eed <strtol+0x29>
		s++, neg = 1;
  800f18:	83 c1 01             	add    $0x1,%ecx
  800f1b:	bf 01 00 00 00       	mov    $0x1,%edi
  800f20:	eb cb                	jmp    800eed <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f22:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800f26:	74 0e                	je     800f36 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800f28:	85 db                	test   %ebx,%ebx
  800f2a:	75 d8                	jne    800f04 <strtol+0x40>
		s++, base = 8;
  800f2c:	83 c1 01             	add    $0x1,%ecx
  800f2f:	bb 08 00 00 00       	mov    $0x8,%ebx
  800f34:	eb ce                	jmp    800f04 <strtol+0x40>
		s += 2, base = 16;
  800f36:	83 c1 02             	add    $0x2,%ecx
  800f39:	bb 10 00 00 00       	mov    $0x10,%ebx
  800f3e:	eb c4                	jmp    800f04 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800f40:	8d 72 9f             	lea    -0x61(%edx),%esi
  800f43:	89 f3                	mov    %esi,%ebx
  800f45:	80 fb 19             	cmp    $0x19,%bl
  800f48:	77 29                	ja     800f73 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800f4a:	0f be d2             	movsbl %dl,%edx
  800f4d:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f50:	3b 55 10             	cmp    0x10(%ebp),%edx
  800f53:	7d 30                	jge    800f85 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800f55:	83 c1 01             	add    $0x1,%ecx
  800f58:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f5c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800f5e:	0f b6 11             	movzbl (%ecx),%edx
  800f61:	8d 72 d0             	lea    -0x30(%edx),%esi
  800f64:	89 f3                	mov    %esi,%ebx
  800f66:	80 fb 09             	cmp    $0x9,%bl
  800f69:	77 d5                	ja     800f40 <strtol+0x7c>
			dig = *s - '0';
  800f6b:	0f be d2             	movsbl %dl,%edx
  800f6e:	83 ea 30             	sub    $0x30,%edx
  800f71:	eb dd                	jmp    800f50 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800f73:	8d 72 bf             	lea    -0x41(%edx),%esi
  800f76:	89 f3                	mov    %esi,%ebx
  800f78:	80 fb 19             	cmp    $0x19,%bl
  800f7b:	77 08                	ja     800f85 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800f7d:	0f be d2             	movsbl %dl,%edx
  800f80:	83 ea 37             	sub    $0x37,%edx
  800f83:	eb cb                	jmp    800f50 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f85:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f89:	74 05                	je     800f90 <strtol+0xcc>
		*endptr = (char *) s;
  800f8b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f8e:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f90:	89 c2                	mov    %eax,%edx
  800f92:	f7 da                	neg    %edx
  800f94:	85 ff                	test   %edi,%edi
  800f96:	0f 45 c2             	cmovne %edx,%eax
}
  800f99:	5b                   	pop    %ebx
  800f9a:	5e                   	pop    %esi
  800f9b:	5f                   	pop    %edi
  800f9c:	5d                   	pop    %ebp
  800f9d:	c3                   	ret    

00800f9e <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f9e:	55                   	push   %ebp
  800f9f:	89 e5                	mov    %esp,%ebp
  800fa1:	57                   	push   %edi
  800fa2:	56                   	push   %esi
  800fa3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fa4:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800faf:	89 c3                	mov    %eax,%ebx
  800fb1:	89 c7                	mov    %eax,%edi
  800fb3:	89 c6                	mov    %eax,%esi
  800fb5:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800fb7:	5b                   	pop    %ebx
  800fb8:	5e                   	pop    %esi
  800fb9:	5f                   	pop    %edi
  800fba:	5d                   	pop    %ebp
  800fbb:	c3                   	ret    

00800fbc <sys_cgetc>:

int
sys_cgetc(void)
{
  800fbc:	55                   	push   %ebp
  800fbd:	89 e5                	mov    %esp,%ebp
  800fbf:	57                   	push   %edi
  800fc0:	56                   	push   %esi
  800fc1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fc2:	ba 00 00 00 00       	mov    $0x0,%edx
  800fc7:	b8 01 00 00 00       	mov    $0x1,%eax
  800fcc:	89 d1                	mov    %edx,%ecx
  800fce:	89 d3                	mov    %edx,%ebx
  800fd0:	89 d7                	mov    %edx,%edi
  800fd2:	89 d6                	mov    %edx,%esi
  800fd4:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800fd6:	5b                   	pop    %ebx
  800fd7:	5e                   	pop    %esi
  800fd8:	5f                   	pop    %edi
  800fd9:	5d                   	pop    %ebp
  800fda:	c3                   	ret    

00800fdb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800fdb:	55                   	push   %ebp
  800fdc:	89 e5                	mov    %esp,%ebp
  800fde:	57                   	push   %edi
  800fdf:	56                   	push   %esi
  800fe0:	53                   	push   %ebx
  800fe1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fe4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fe9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fec:	b8 03 00 00 00       	mov    $0x3,%eax
  800ff1:	89 cb                	mov    %ecx,%ebx
  800ff3:	89 cf                	mov    %ecx,%edi
  800ff5:	89 ce                	mov    %ecx,%esi
  800ff7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ff9:	85 c0                	test   %eax,%eax
  800ffb:	7f 08                	jg     801005 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ffd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801000:	5b                   	pop    %ebx
  801001:	5e                   	pop    %esi
  801002:	5f                   	pop    %edi
  801003:	5d                   	pop    %ebp
  801004:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801005:	83 ec 0c             	sub    $0xc,%esp
  801008:	50                   	push   %eax
  801009:	6a 03                	push   $0x3
  80100b:	68 48 32 80 00       	push   $0x803248
  801010:	6a 43                	push   $0x43
  801012:	68 65 32 80 00       	push   $0x803265
  801017:	e8 f7 f3 ff ff       	call   800413 <_panic>

0080101c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80101c:	55                   	push   %ebp
  80101d:	89 e5                	mov    %esp,%ebp
  80101f:	57                   	push   %edi
  801020:	56                   	push   %esi
  801021:	53                   	push   %ebx
	asm volatile("int %1\n"
  801022:	ba 00 00 00 00       	mov    $0x0,%edx
  801027:	b8 02 00 00 00       	mov    $0x2,%eax
  80102c:	89 d1                	mov    %edx,%ecx
  80102e:	89 d3                	mov    %edx,%ebx
  801030:	89 d7                	mov    %edx,%edi
  801032:	89 d6                	mov    %edx,%esi
  801034:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801036:	5b                   	pop    %ebx
  801037:	5e                   	pop    %esi
  801038:	5f                   	pop    %edi
  801039:	5d                   	pop    %ebp
  80103a:	c3                   	ret    

0080103b <sys_yield>:

void
sys_yield(void)
{
  80103b:	55                   	push   %ebp
  80103c:	89 e5                	mov    %esp,%ebp
  80103e:	57                   	push   %edi
  80103f:	56                   	push   %esi
  801040:	53                   	push   %ebx
	asm volatile("int %1\n"
  801041:	ba 00 00 00 00       	mov    $0x0,%edx
  801046:	b8 0b 00 00 00       	mov    $0xb,%eax
  80104b:	89 d1                	mov    %edx,%ecx
  80104d:	89 d3                	mov    %edx,%ebx
  80104f:	89 d7                	mov    %edx,%edi
  801051:	89 d6                	mov    %edx,%esi
  801053:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801055:	5b                   	pop    %ebx
  801056:	5e                   	pop    %esi
  801057:	5f                   	pop    %edi
  801058:	5d                   	pop    %ebp
  801059:	c3                   	ret    

0080105a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80105a:	55                   	push   %ebp
  80105b:	89 e5                	mov    %esp,%ebp
  80105d:	57                   	push   %edi
  80105e:	56                   	push   %esi
  80105f:	53                   	push   %ebx
  801060:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801063:	be 00 00 00 00       	mov    $0x0,%esi
  801068:	8b 55 08             	mov    0x8(%ebp),%edx
  80106b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80106e:	b8 04 00 00 00       	mov    $0x4,%eax
  801073:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801076:	89 f7                	mov    %esi,%edi
  801078:	cd 30                	int    $0x30
	if(check && ret > 0)
  80107a:	85 c0                	test   %eax,%eax
  80107c:	7f 08                	jg     801086 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80107e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801081:	5b                   	pop    %ebx
  801082:	5e                   	pop    %esi
  801083:	5f                   	pop    %edi
  801084:	5d                   	pop    %ebp
  801085:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801086:	83 ec 0c             	sub    $0xc,%esp
  801089:	50                   	push   %eax
  80108a:	6a 04                	push   $0x4
  80108c:	68 48 32 80 00       	push   $0x803248
  801091:	6a 43                	push   $0x43
  801093:	68 65 32 80 00       	push   $0x803265
  801098:	e8 76 f3 ff ff       	call   800413 <_panic>

0080109d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80109d:	55                   	push   %ebp
  80109e:	89 e5                	mov    %esp,%ebp
  8010a0:	57                   	push   %edi
  8010a1:	56                   	push   %esi
  8010a2:	53                   	push   %ebx
  8010a3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ac:	b8 05 00 00 00       	mov    $0x5,%eax
  8010b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010b4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010b7:	8b 75 18             	mov    0x18(%ebp),%esi
  8010ba:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010bc:	85 c0                	test   %eax,%eax
  8010be:	7f 08                	jg     8010c8 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8010c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010c3:	5b                   	pop    %ebx
  8010c4:	5e                   	pop    %esi
  8010c5:	5f                   	pop    %edi
  8010c6:	5d                   	pop    %ebp
  8010c7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c8:	83 ec 0c             	sub    $0xc,%esp
  8010cb:	50                   	push   %eax
  8010cc:	6a 05                	push   $0x5
  8010ce:	68 48 32 80 00       	push   $0x803248
  8010d3:	6a 43                	push   $0x43
  8010d5:	68 65 32 80 00       	push   $0x803265
  8010da:	e8 34 f3 ff ff       	call   800413 <_panic>

008010df <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8010df:	55                   	push   %ebp
  8010e0:	89 e5                	mov    %esp,%ebp
  8010e2:	57                   	push   %edi
  8010e3:	56                   	push   %esi
  8010e4:	53                   	push   %ebx
  8010e5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010e8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f3:	b8 06 00 00 00       	mov    $0x6,%eax
  8010f8:	89 df                	mov    %ebx,%edi
  8010fa:	89 de                	mov    %ebx,%esi
  8010fc:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010fe:	85 c0                	test   %eax,%eax
  801100:	7f 08                	jg     80110a <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801102:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801105:	5b                   	pop    %ebx
  801106:	5e                   	pop    %esi
  801107:	5f                   	pop    %edi
  801108:	5d                   	pop    %ebp
  801109:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80110a:	83 ec 0c             	sub    $0xc,%esp
  80110d:	50                   	push   %eax
  80110e:	6a 06                	push   $0x6
  801110:	68 48 32 80 00       	push   $0x803248
  801115:	6a 43                	push   $0x43
  801117:	68 65 32 80 00       	push   $0x803265
  80111c:	e8 f2 f2 ff ff       	call   800413 <_panic>

00801121 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801121:	55                   	push   %ebp
  801122:	89 e5                	mov    %esp,%ebp
  801124:	57                   	push   %edi
  801125:	56                   	push   %esi
  801126:	53                   	push   %ebx
  801127:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80112a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80112f:	8b 55 08             	mov    0x8(%ebp),%edx
  801132:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801135:	b8 08 00 00 00       	mov    $0x8,%eax
  80113a:	89 df                	mov    %ebx,%edi
  80113c:	89 de                	mov    %ebx,%esi
  80113e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801140:	85 c0                	test   %eax,%eax
  801142:	7f 08                	jg     80114c <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801144:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801147:	5b                   	pop    %ebx
  801148:	5e                   	pop    %esi
  801149:	5f                   	pop    %edi
  80114a:	5d                   	pop    %ebp
  80114b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80114c:	83 ec 0c             	sub    $0xc,%esp
  80114f:	50                   	push   %eax
  801150:	6a 08                	push   $0x8
  801152:	68 48 32 80 00       	push   $0x803248
  801157:	6a 43                	push   $0x43
  801159:	68 65 32 80 00       	push   $0x803265
  80115e:	e8 b0 f2 ff ff       	call   800413 <_panic>

00801163 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801163:	55                   	push   %ebp
  801164:	89 e5                	mov    %esp,%ebp
  801166:	57                   	push   %edi
  801167:	56                   	push   %esi
  801168:	53                   	push   %ebx
  801169:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80116c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801171:	8b 55 08             	mov    0x8(%ebp),%edx
  801174:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801177:	b8 09 00 00 00       	mov    $0x9,%eax
  80117c:	89 df                	mov    %ebx,%edi
  80117e:	89 de                	mov    %ebx,%esi
  801180:	cd 30                	int    $0x30
	if(check && ret > 0)
  801182:	85 c0                	test   %eax,%eax
  801184:	7f 08                	jg     80118e <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801186:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801189:	5b                   	pop    %ebx
  80118a:	5e                   	pop    %esi
  80118b:	5f                   	pop    %edi
  80118c:	5d                   	pop    %ebp
  80118d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80118e:	83 ec 0c             	sub    $0xc,%esp
  801191:	50                   	push   %eax
  801192:	6a 09                	push   $0x9
  801194:	68 48 32 80 00       	push   $0x803248
  801199:	6a 43                	push   $0x43
  80119b:	68 65 32 80 00       	push   $0x803265
  8011a0:	e8 6e f2 ff ff       	call   800413 <_panic>

008011a5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8011a5:	55                   	push   %ebp
  8011a6:	89 e5                	mov    %esp,%ebp
  8011a8:	57                   	push   %edi
  8011a9:	56                   	push   %esi
  8011aa:	53                   	push   %ebx
  8011ab:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011ae:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011b9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011be:	89 df                	mov    %ebx,%edi
  8011c0:	89 de                	mov    %ebx,%esi
  8011c2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011c4:	85 c0                	test   %eax,%eax
  8011c6:	7f 08                	jg     8011d0 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8011c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011cb:	5b                   	pop    %ebx
  8011cc:	5e                   	pop    %esi
  8011cd:	5f                   	pop    %edi
  8011ce:	5d                   	pop    %ebp
  8011cf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011d0:	83 ec 0c             	sub    $0xc,%esp
  8011d3:	50                   	push   %eax
  8011d4:	6a 0a                	push   $0xa
  8011d6:	68 48 32 80 00       	push   $0x803248
  8011db:	6a 43                	push   $0x43
  8011dd:	68 65 32 80 00       	push   $0x803265
  8011e2:	e8 2c f2 ff ff       	call   800413 <_panic>

008011e7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8011e7:	55                   	push   %ebp
  8011e8:	89 e5                	mov    %esp,%ebp
  8011ea:	57                   	push   %edi
  8011eb:	56                   	push   %esi
  8011ec:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011f3:	b8 0c 00 00 00       	mov    $0xc,%eax
  8011f8:	be 00 00 00 00       	mov    $0x0,%esi
  8011fd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801200:	8b 7d 14             	mov    0x14(%ebp),%edi
  801203:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801205:	5b                   	pop    %ebx
  801206:	5e                   	pop    %esi
  801207:	5f                   	pop    %edi
  801208:	5d                   	pop    %ebp
  801209:	c3                   	ret    

0080120a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80120a:	55                   	push   %ebp
  80120b:	89 e5                	mov    %esp,%ebp
  80120d:	57                   	push   %edi
  80120e:	56                   	push   %esi
  80120f:	53                   	push   %ebx
  801210:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801213:	b9 00 00 00 00       	mov    $0x0,%ecx
  801218:	8b 55 08             	mov    0x8(%ebp),%edx
  80121b:	b8 0d 00 00 00       	mov    $0xd,%eax
  801220:	89 cb                	mov    %ecx,%ebx
  801222:	89 cf                	mov    %ecx,%edi
  801224:	89 ce                	mov    %ecx,%esi
  801226:	cd 30                	int    $0x30
	if(check && ret > 0)
  801228:	85 c0                	test   %eax,%eax
  80122a:	7f 08                	jg     801234 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80122c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80122f:	5b                   	pop    %ebx
  801230:	5e                   	pop    %esi
  801231:	5f                   	pop    %edi
  801232:	5d                   	pop    %ebp
  801233:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801234:	83 ec 0c             	sub    $0xc,%esp
  801237:	50                   	push   %eax
  801238:	6a 0d                	push   $0xd
  80123a:	68 48 32 80 00       	push   $0x803248
  80123f:	6a 43                	push   $0x43
  801241:	68 65 32 80 00       	push   $0x803265
  801246:	e8 c8 f1 ff ff       	call   800413 <_panic>

0080124b <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80124b:	55                   	push   %ebp
  80124c:	89 e5                	mov    %esp,%ebp
  80124e:	57                   	push   %edi
  80124f:	56                   	push   %esi
  801250:	53                   	push   %ebx
	asm volatile("int %1\n"
  801251:	bb 00 00 00 00       	mov    $0x0,%ebx
  801256:	8b 55 08             	mov    0x8(%ebp),%edx
  801259:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80125c:	b8 0e 00 00 00       	mov    $0xe,%eax
  801261:	89 df                	mov    %ebx,%edi
  801263:	89 de                	mov    %ebx,%esi
  801265:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801267:	5b                   	pop    %ebx
  801268:	5e                   	pop    %esi
  801269:	5f                   	pop    %edi
  80126a:	5d                   	pop    %ebp
  80126b:	c3                   	ret    

0080126c <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80126c:	55                   	push   %ebp
  80126d:	89 e5                	mov    %esp,%ebp
  80126f:	57                   	push   %edi
  801270:	56                   	push   %esi
  801271:	53                   	push   %ebx
	asm volatile("int %1\n"
  801272:	b9 00 00 00 00       	mov    $0x0,%ecx
  801277:	8b 55 08             	mov    0x8(%ebp),%edx
  80127a:	b8 0f 00 00 00       	mov    $0xf,%eax
  80127f:	89 cb                	mov    %ecx,%ebx
  801281:	89 cf                	mov    %ecx,%edi
  801283:	89 ce                	mov    %ecx,%esi
  801285:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801287:	5b                   	pop    %ebx
  801288:	5e                   	pop    %esi
  801289:	5f                   	pop    %edi
  80128a:	5d                   	pop    %ebp
  80128b:	c3                   	ret    

0080128c <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80128c:	55                   	push   %ebp
  80128d:	89 e5                	mov    %esp,%ebp
  80128f:	57                   	push   %edi
  801290:	56                   	push   %esi
  801291:	53                   	push   %ebx
	asm volatile("int %1\n"
  801292:	ba 00 00 00 00       	mov    $0x0,%edx
  801297:	b8 10 00 00 00       	mov    $0x10,%eax
  80129c:	89 d1                	mov    %edx,%ecx
  80129e:	89 d3                	mov    %edx,%ebx
  8012a0:	89 d7                	mov    %edx,%edi
  8012a2:	89 d6                	mov    %edx,%esi
  8012a4:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8012a6:	5b                   	pop    %ebx
  8012a7:	5e                   	pop    %esi
  8012a8:	5f                   	pop    %edi
  8012a9:	5d                   	pop    %ebp
  8012aa:	c3                   	ret    

008012ab <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8012ab:	55                   	push   %ebp
  8012ac:	89 e5                	mov    %esp,%ebp
  8012ae:	57                   	push   %edi
  8012af:	56                   	push   %esi
  8012b0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012b1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8012b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012bc:	b8 11 00 00 00       	mov    $0x11,%eax
  8012c1:	89 df                	mov    %ebx,%edi
  8012c3:	89 de                	mov    %ebx,%esi
  8012c5:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8012c7:	5b                   	pop    %ebx
  8012c8:	5e                   	pop    %esi
  8012c9:	5f                   	pop    %edi
  8012ca:	5d                   	pop    %ebp
  8012cb:	c3                   	ret    

008012cc <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8012cc:	55                   	push   %ebp
  8012cd:	89 e5                	mov    %esp,%ebp
  8012cf:	57                   	push   %edi
  8012d0:	56                   	push   %esi
  8012d1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012d2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8012da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012dd:	b8 12 00 00 00       	mov    $0x12,%eax
  8012e2:	89 df                	mov    %ebx,%edi
  8012e4:	89 de                	mov    %ebx,%esi
  8012e6:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8012e8:	5b                   	pop    %ebx
  8012e9:	5e                   	pop    %esi
  8012ea:	5f                   	pop    %edi
  8012eb:	5d                   	pop    %ebp
  8012ec:	c3                   	ret    

008012ed <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
  8012f0:	57                   	push   %edi
  8012f1:	56                   	push   %esi
  8012f2:	53                   	push   %ebx
  8012f3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012f6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8012fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801301:	b8 13 00 00 00       	mov    $0x13,%eax
  801306:	89 df                	mov    %ebx,%edi
  801308:	89 de                	mov    %ebx,%esi
  80130a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80130c:	85 c0                	test   %eax,%eax
  80130e:	7f 08                	jg     801318 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801310:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801313:	5b                   	pop    %ebx
  801314:	5e                   	pop    %esi
  801315:	5f                   	pop    %edi
  801316:	5d                   	pop    %ebp
  801317:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801318:	83 ec 0c             	sub    $0xc,%esp
  80131b:	50                   	push   %eax
  80131c:	6a 13                	push   $0x13
  80131e:	68 48 32 80 00       	push   $0x803248
  801323:	6a 43                	push   $0x43
  801325:	68 65 32 80 00       	push   $0x803265
  80132a:	e8 e4 f0 ff ff       	call   800413 <_panic>

0080132f <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80132f:	55                   	push   %ebp
  801330:	89 e5                	mov    %esp,%ebp
  801332:	57                   	push   %edi
  801333:	56                   	push   %esi
  801334:	53                   	push   %ebx
	asm volatile("int %1\n"
  801335:	b9 00 00 00 00       	mov    $0x0,%ecx
  80133a:	8b 55 08             	mov    0x8(%ebp),%edx
  80133d:	b8 14 00 00 00       	mov    $0x14,%eax
  801342:	89 cb                	mov    %ecx,%ebx
  801344:	89 cf                	mov    %ecx,%edi
  801346:	89 ce                	mov    %ecx,%esi
  801348:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  80134a:	5b                   	pop    %ebx
  80134b:	5e                   	pop    %esi
  80134c:	5f                   	pop    %edi
  80134d:	5d                   	pop    %ebp
  80134e:	c3                   	ret    

0080134f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80134f:	55                   	push   %ebp
  801350:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	05 00 00 00 30       	add    $0x30000000,%eax
  80135a:	c1 e8 0c             	shr    $0xc,%eax
}
  80135d:	5d                   	pop    %ebp
  80135e:	c3                   	ret    

0080135f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80135f:	55                   	push   %ebp
  801360:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80136a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80136f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801374:	5d                   	pop    %ebp
  801375:	c3                   	ret    

00801376 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801376:	55                   	push   %ebp
  801377:	89 e5                	mov    %esp,%ebp
  801379:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80137e:	89 c2                	mov    %eax,%edx
  801380:	c1 ea 16             	shr    $0x16,%edx
  801383:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80138a:	f6 c2 01             	test   $0x1,%dl
  80138d:	74 2d                	je     8013bc <fd_alloc+0x46>
  80138f:	89 c2                	mov    %eax,%edx
  801391:	c1 ea 0c             	shr    $0xc,%edx
  801394:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80139b:	f6 c2 01             	test   $0x1,%dl
  80139e:	74 1c                	je     8013bc <fd_alloc+0x46>
  8013a0:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8013a5:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013aa:	75 d2                	jne    80137e <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8013ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8013af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8013b5:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8013ba:	eb 0a                	jmp    8013c6 <fd_alloc+0x50>
			*fd_store = fd;
  8013bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013bf:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013c6:	5d                   	pop    %ebp
  8013c7:	c3                   	ret    

008013c8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
  8013cb:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013ce:	83 f8 1f             	cmp    $0x1f,%eax
  8013d1:	77 30                	ja     801403 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8013d3:	c1 e0 0c             	shl    $0xc,%eax
  8013d6:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013db:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8013e1:	f6 c2 01             	test   $0x1,%dl
  8013e4:	74 24                	je     80140a <fd_lookup+0x42>
  8013e6:	89 c2                	mov    %eax,%edx
  8013e8:	c1 ea 0c             	shr    $0xc,%edx
  8013eb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013f2:	f6 c2 01             	test   $0x1,%dl
  8013f5:	74 1a                	je     801411 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013fa:	89 02                	mov    %eax,(%edx)
	return 0;
  8013fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801401:	5d                   	pop    %ebp
  801402:	c3                   	ret    
		return -E_INVAL;
  801403:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801408:	eb f7                	jmp    801401 <fd_lookup+0x39>
		return -E_INVAL;
  80140a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80140f:	eb f0                	jmp    801401 <fd_lookup+0x39>
  801411:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801416:	eb e9                	jmp    801401 <fd_lookup+0x39>

00801418 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801418:	55                   	push   %ebp
  801419:	89 e5                	mov    %esp,%ebp
  80141b:	83 ec 08             	sub    $0x8,%esp
  80141e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801421:	ba 00 00 00 00       	mov    $0x0,%edx
  801426:	b8 90 57 80 00       	mov    $0x805790,%eax
		if (devtab[i]->dev_id == dev_id) {
  80142b:	39 08                	cmp    %ecx,(%eax)
  80142d:	74 38                	je     801467 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80142f:	83 c2 01             	add    $0x1,%edx
  801432:	8b 04 95 f0 32 80 00 	mov    0x8032f0(,%edx,4),%eax
  801439:	85 c0                	test   %eax,%eax
  80143b:	75 ee                	jne    80142b <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80143d:	a1 90 77 80 00       	mov    0x807790,%eax
  801442:	8b 40 48             	mov    0x48(%eax),%eax
  801445:	83 ec 04             	sub    $0x4,%esp
  801448:	51                   	push   %ecx
  801449:	50                   	push   %eax
  80144a:	68 74 32 80 00       	push   $0x803274
  80144f:	e8 b5 f0 ff ff       	call   800509 <cprintf>
	*dev = 0;
  801454:	8b 45 0c             	mov    0xc(%ebp),%eax
  801457:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80145d:	83 c4 10             	add    $0x10,%esp
  801460:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801465:	c9                   	leave  
  801466:	c3                   	ret    
			*dev = devtab[i];
  801467:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80146a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80146c:	b8 00 00 00 00       	mov    $0x0,%eax
  801471:	eb f2                	jmp    801465 <dev_lookup+0x4d>

00801473 <fd_close>:
{
  801473:	55                   	push   %ebp
  801474:	89 e5                	mov    %esp,%ebp
  801476:	57                   	push   %edi
  801477:	56                   	push   %esi
  801478:	53                   	push   %ebx
  801479:	83 ec 24             	sub    $0x24,%esp
  80147c:	8b 75 08             	mov    0x8(%ebp),%esi
  80147f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801482:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801485:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801486:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80148c:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80148f:	50                   	push   %eax
  801490:	e8 33 ff ff ff       	call   8013c8 <fd_lookup>
  801495:	89 c3                	mov    %eax,%ebx
  801497:	83 c4 10             	add    $0x10,%esp
  80149a:	85 c0                	test   %eax,%eax
  80149c:	78 05                	js     8014a3 <fd_close+0x30>
	    || fd != fd2)
  80149e:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8014a1:	74 16                	je     8014b9 <fd_close+0x46>
		return (must_exist ? r : 0);
  8014a3:	89 f8                	mov    %edi,%eax
  8014a5:	84 c0                	test   %al,%al
  8014a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ac:	0f 44 d8             	cmove  %eax,%ebx
}
  8014af:	89 d8                	mov    %ebx,%eax
  8014b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014b4:	5b                   	pop    %ebx
  8014b5:	5e                   	pop    %esi
  8014b6:	5f                   	pop    %edi
  8014b7:	5d                   	pop    %ebp
  8014b8:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8014b9:	83 ec 08             	sub    $0x8,%esp
  8014bc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8014bf:	50                   	push   %eax
  8014c0:	ff 36                	pushl  (%esi)
  8014c2:	e8 51 ff ff ff       	call   801418 <dev_lookup>
  8014c7:	89 c3                	mov    %eax,%ebx
  8014c9:	83 c4 10             	add    $0x10,%esp
  8014cc:	85 c0                	test   %eax,%eax
  8014ce:	78 1a                	js     8014ea <fd_close+0x77>
		if (dev->dev_close)
  8014d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014d3:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8014d6:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8014db:	85 c0                	test   %eax,%eax
  8014dd:	74 0b                	je     8014ea <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8014df:	83 ec 0c             	sub    $0xc,%esp
  8014e2:	56                   	push   %esi
  8014e3:	ff d0                	call   *%eax
  8014e5:	89 c3                	mov    %eax,%ebx
  8014e7:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8014ea:	83 ec 08             	sub    $0x8,%esp
  8014ed:	56                   	push   %esi
  8014ee:	6a 00                	push   $0x0
  8014f0:	e8 ea fb ff ff       	call   8010df <sys_page_unmap>
	return r;
  8014f5:	83 c4 10             	add    $0x10,%esp
  8014f8:	eb b5                	jmp    8014af <fd_close+0x3c>

008014fa <close>:

int
close(int fdnum)
{
  8014fa:	55                   	push   %ebp
  8014fb:	89 e5                	mov    %esp,%ebp
  8014fd:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801500:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801503:	50                   	push   %eax
  801504:	ff 75 08             	pushl  0x8(%ebp)
  801507:	e8 bc fe ff ff       	call   8013c8 <fd_lookup>
  80150c:	83 c4 10             	add    $0x10,%esp
  80150f:	85 c0                	test   %eax,%eax
  801511:	79 02                	jns    801515 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801513:	c9                   	leave  
  801514:	c3                   	ret    
		return fd_close(fd, 1);
  801515:	83 ec 08             	sub    $0x8,%esp
  801518:	6a 01                	push   $0x1
  80151a:	ff 75 f4             	pushl  -0xc(%ebp)
  80151d:	e8 51 ff ff ff       	call   801473 <fd_close>
  801522:	83 c4 10             	add    $0x10,%esp
  801525:	eb ec                	jmp    801513 <close+0x19>

00801527 <close_all>:

void
close_all(void)
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
  80152a:	53                   	push   %ebx
  80152b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80152e:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801533:	83 ec 0c             	sub    $0xc,%esp
  801536:	53                   	push   %ebx
  801537:	e8 be ff ff ff       	call   8014fa <close>
	for (i = 0; i < MAXFD; i++)
  80153c:	83 c3 01             	add    $0x1,%ebx
  80153f:	83 c4 10             	add    $0x10,%esp
  801542:	83 fb 20             	cmp    $0x20,%ebx
  801545:	75 ec                	jne    801533 <close_all+0xc>
}
  801547:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80154a:	c9                   	leave  
  80154b:	c3                   	ret    

0080154c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80154c:	55                   	push   %ebp
  80154d:	89 e5                	mov    %esp,%ebp
  80154f:	57                   	push   %edi
  801550:	56                   	push   %esi
  801551:	53                   	push   %ebx
  801552:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801555:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801558:	50                   	push   %eax
  801559:	ff 75 08             	pushl  0x8(%ebp)
  80155c:	e8 67 fe ff ff       	call   8013c8 <fd_lookup>
  801561:	89 c3                	mov    %eax,%ebx
  801563:	83 c4 10             	add    $0x10,%esp
  801566:	85 c0                	test   %eax,%eax
  801568:	0f 88 81 00 00 00    	js     8015ef <dup+0xa3>
		return r;
	close(newfdnum);
  80156e:	83 ec 0c             	sub    $0xc,%esp
  801571:	ff 75 0c             	pushl  0xc(%ebp)
  801574:	e8 81 ff ff ff       	call   8014fa <close>

	newfd = INDEX2FD(newfdnum);
  801579:	8b 75 0c             	mov    0xc(%ebp),%esi
  80157c:	c1 e6 0c             	shl    $0xc,%esi
  80157f:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801585:	83 c4 04             	add    $0x4,%esp
  801588:	ff 75 e4             	pushl  -0x1c(%ebp)
  80158b:	e8 cf fd ff ff       	call   80135f <fd2data>
  801590:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801592:	89 34 24             	mov    %esi,(%esp)
  801595:	e8 c5 fd ff ff       	call   80135f <fd2data>
  80159a:	83 c4 10             	add    $0x10,%esp
  80159d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80159f:	89 d8                	mov    %ebx,%eax
  8015a1:	c1 e8 16             	shr    $0x16,%eax
  8015a4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015ab:	a8 01                	test   $0x1,%al
  8015ad:	74 11                	je     8015c0 <dup+0x74>
  8015af:	89 d8                	mov    %ebx,%eax
  8015b1:	c1 e8 0c             	shr    $0xc,%eax
  8015b4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8015bb:	f6 c2 01             	test   $0x1,%dl
  8015be:	75 39                	jne    8015f9 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015c3:	89 d0                	mov    %edx,%eax
  8015c5:	c1 e8 0c             	shr    $0xc,%eax
  8015c8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015cf:	83 ec 0c             	sub    $0xc,%esp
  8015d2:	25 07 0e 00 00       	and    $0xe07,%eax
  8015d7:	50                   	push   %eax
  8015d8:	56                   	push   %esi
  8015d9:	6a 00                	push   $0x0
  8015db:	52                   	push   %edx
  8015dc:	6a 00                	push   $0x0
  8015de:	e8 ba fa ff ff       	call   80109d <sys_page_map>
  8015e3:	89 c3                	mov    %eax,%ebx
  8015e5:	83 c4 20             	add    $0x20,%esp
  8015e8:	85 c0                	test   %eax,%eax
  8015ea:	78 31                	js     80161d <dup+0xd1>
		goto err;

	return newfdnum;
  8015ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8015ef:	89 d8                	mov    %ebx,%eax
  8015f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015f4:	5b                   	pop    %ebx
  8015f5:	5e                   	pop    %esi
  8015f6:	5f                   	pop    %edi
  8015f7:	5d                   	pop    %ebp
  8015f8:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015f9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801600:	83 ec 0c             	sub    $0xc,%esp
  801603:	25 07 0e 00 00       	and    $0xe07,%eax
  801608:	50                   	push   %eax
  801609:	57                   	push   %edi
  80160a:	6a 00                	push   $0x0
  80160c:	53                   	push   %ebx
  80160d:	6a 00                	push   $0x0
  80160f:	e8 89 fa ff ff       	call   80109d <sys_page_map>
  801614:	89 c3                	mov    %eax,%ebx
  801616:	83 c4 20             	add    $0x20,%esp
  801619:	85 c0                	test   %eax,%eax
  80161b:	79 a3                	jns    8015c0 <dup+0x74>
	sys_page_unmap(0, newfd);
  80161d:	83 ec 08             	sub    $0x8,%esp
  801620:	56                   	push   %esi
  801621:	6a 00                	push   $0x0
  801623:	e8 b7 fa ff ff       	call   8010df <sys_page_unmap>
	sys_page_unmap(0, nva);
  801628:	83 c4 08             	add    $0x8,%esp
  80162b:	57                   	push   %edi
  80162c:	6a 00                	push   $0x0
  80162e:	e8 ac fa ff ff       	call   8010df <sys_page_unmap>
	return r;
  801633:	83 c4 10             	add    $0x10,%esp
  801636:	eb b7                	jmp    8015ef <dup+0xa3>

00801638 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
  80163b:	53                   	push   %ebx
  80163c:	83 ec 1c             	sub    $0x1c,%esp
  80163f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801642:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801645:	50                   	push   %eax
  801646:	53                   	push   %ebx
  801647:	e8 7c fd ff ff       	call   8013c8 <fd_lookup>
  80164c:	83 c4 10             	add    $0x10,%esp
  80164f:	85 c0                	test   %eax,%eax
  801651:	78 3f                	js     801692 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801653:	83 ec 08             	sub    $0x8,%esp
  801656:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801659:	50                   	push   %eax
  80165a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80165d:	ff 30                	pushl  (%eax)
  80165f:	e8 b4 fd ff ff       	call   801418 <dev_lookup>
  801664:	83 c4 10             	add    $0x10,%esp
  801667:	85 c0                	test   %eax,%eax
  801669:	78 27                	js     801692 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80166b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80166e:	8b 42 08             	mov    0x8(%edx),%eax
  801671:	83 e0 03             	and    $0x3,%eax
  801674:	83 f8 01             	cmp    $0x1,%eax
  801677:	74 1e                	je     801697 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167c:	8b 40 08             	mov    0x8(%eax),%eax
  80167f:	85 c0                	test   %eax,%eax
  801681:	74 35                	je     8016b8 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801683:	83 ec 04             	sub    $0x4,%esp
  801686:	ff 75 10             	pushl  0x10(%ebp)
  801689:	ff 75 0c             	pushl  0xc(%ebp)
  80168c:	52                   	push   %edx
  80168d:	ff d0                	call   *%eax
  80168f:	83 c4 10             	add    $0x10,%esp
}
  801692:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801695:	c9                   	leave  
  801696:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801697:	a1 90 77 80 00       	mov    0x807790,%eax
  80169c:	8b 40 48             	mov    0x48(%eax),%eax
  80169f:	83 ec 04             	sub    $0x4,%esp
  8016a2:	53                   	push   %ebx
  8016a3:	50                   	push   %eax
  8016a4:	68 b5 32 80 00       	push   $0x8032b5
  8016a9:	e8 5b ee ff ff       	call   800509 <cprintf>
		return -E_INVAL;
  8016ae:	83 c4 10             	add    $0x10,%esp
  8016b1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016b6:	eb da                	jmp    801692 <read+0x5a>
		return -E_NOT_SUPP;
  8016b8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016bd:	eb d3                	jmp    801692 <read+0x5a>

008016bf <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
  8016c2:	57                   	push   %edi
  8016c3:	56                   	push   %esi
  8016c4:	53                   	push   %ebx
  8016c5:	83 ec 0c             	sub    $0xc,%esp
  8016c8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016cb:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016ce:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016d3:	39 f3                	cmp    %esi,%ebx
  8016d5:	73 23                	jae    8016fa <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016d7:	83 ec 04             	sub    $0x4,%esp
  8016da:	89 f0                	mov    %esi,%eax
  8016dc:	29 d8                	sub    %ebx,%eax
  8016de:	50                   	push   %eax
  8016df:	89 d8                	mov    %ebx,%eax
  8016e1:	03 45 0c             	add    0xc(%ebp),%eax
  8016e4:	50                   	push   %eax
  8016e5:	57                   	push   %edi
  8016e6:	e8 4d ff ff ff       	call   801638 <read>
		if (m < 0)
  8016eb:	83 c4 10             	add    $0x10,%esp
  8016ee:	85 c0                	test   %eax,%eax
  8016f0:	78 06                	js     8016f8 <readn+0x39>
			return m;
		if (m == 0)
  8016f2:	74 06                	je     8016fa <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8016f4:	01 c3                	add    %eax,%ebx
  8016f6:	eb db                	jmp    8016d3 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016f8:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8016fa:	89 d8                	mov    %ebx,%eax
  8016fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016ff:	5b                   	pop    %ebx
  801700:	5e                   	pop    %esi
  801701:	5f                   	pop    %edi
  801702:	5d                   	pop    %ebp
  801703:	c3                   	ret    

00801704 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801704:	55                   	push   %ebp
  801705:	89 e5                	mov    %esp,%ebp
  801707:	53                   	push   %ebx
  801708:	83 ec 1c             	sub    $0x1c,%esp
  80170b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80170e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801711:	50                   	push   %eax
  801712:	53                   	push   %ebx
  801713:	e8 b0 fc ff ff       	call   8013c8 <fd_lookup>
  801718:	83 c4 10             	add    $0x10,%esp
  80171b:	85 c0                	test   %eax,%eax
  80171d:	78 3a                	js     801759 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80171f:	83 ec 08             	sub    $0x8,%esp
  801722:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801725:	50                   	push   %eax
  801726:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801729:	ff 30                	pushl  (%eax)
  80172b:	e8 e8 fc ff ff       	call   801418 <dev_lookup>
  801730:	83 c4 10             	add    $0x10,%esp
  801733:	85 c0                	test   %eax,%eax
  801735:	78 22                	js     801759 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801737:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80173a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80173e:	74 1e                	je     80175e <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801740:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801743:	8b 52 0c             	mov    0xc(%edx),%edx
  801746:	85 d2                	test   %edx,%edx
  801748:	74 35                	je     80177f <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80174a:	83 ec 04             	sub    $0x4,%esp
  80174d:	ff 75 10             	pushl  0x10(%ebp)
  801750:	ff 75 0c             	pushl  0xc(%ebp)
  801753:	50                   	push   %eax
  801754:	ff d2                	call   *%edx
  801756:	83 c4 10             	add    $0x10,%esp
}
  801759:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80175c:	c9                   	leave  
  80175d:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80175e:	a1 90 77 80 00       	mov    0x807790,%eax
  801763:	8b 40 48             	mov    0x48(%eax),%eax
  801766:	83 ec 04             	sub    $0x4,%esp
  801769:	53                   	push   %ebx
  80176a:	50                   	push   %eax
  80176b:	68 d1 32 80 00       	push   $0x8032d1
  801770:	e8 94 ed ff ff       	call   800509 <cprintf>
		return -E_INVAL;
  801775:	83 c4 10             	add    $0x10,%esp
  801778:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80177d:	eb da                	jmp    801759 <write+0x55>
		return -E_NOT_SUPP;
  80177f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801784:	eb d3                	jmp    801759 <write+0x55>

00801786 <seek>:

int
seek(int fdnum, off_t offset)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
  801789:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80178c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80178f:	50                   	push   %eax
  801790:	ff 75 08             	pushl  0x8(%ebp)
  801793:	e8 30 fc ff ff       	call   8013c8 <fd_lookup>
  801798:	83 c4 10             	add    $0x10,%esp
  80179b:	85 c0                	test   %eax,%eax
  80179d:	78 0e                	js     8017ad <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80179f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a5:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8017a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ad:	c9                   	leave  
  8017ae:	c3                   	ret    

008017af <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
  8017b2:	53                   	push   %ebx
  8017b3:	83 ec 1c             	sub    $0x1c,%esp
  8017b6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017b9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017bc:	50                   	push   %eax
  8017bd:	53                   	push   %ebx
  8017be:	e8 05 fc ff ff       	call   8013c8 <fd_lookup>
  8017c3:	83 c4 10             	add    $0x10,%esp
  8017c6:	85 c0                	test   %eax,%eax
  8017c8:	78 37                	js     801801 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017ca:	83 ec 08             	sub    $0x8,%esp
  8017cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d0:	50                   	push   %eax
  8017d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d4:	ff 30                	pushl  (%eax)
  8017d6:	e8 3d fc ff ff       	call   801418 <dev_lookup>
  8017db:	83 c4 10             	add    $0x10,%esp
  8017de:	85 c0                	test   %eax,%eax
  8017e0:	78 1f                	js     801801 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017e9:	74 1b                	je     801806 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8017eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ee:	8b 52 18             	mov    0x18(%edx),%edx
  8017f1:	85 d2                	test   %edx,%edx
  8017f3:	74 32                	je     801827 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017f5:	83 ec 08             	sub    $0x8,%esp
  8017f8:	ff 75 0c             	pushl  0xc(%ebp)
  8017fb:	50                   	push   %eax
  8017fc:	ff d2                	call   *%edx
  8017fe:	83 c4 10             	add    $0x10,%esp
}
  801801:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801804:	c9                   	leave  
  801805:	c3                   	ret    
			thisenv->env_id, fdnum);
  801806:	a1 90 77 80 00       	mov    0x807790,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80180b:	8b 40 48             	mov    0x48(%eax),%eax
  80180e:	83 ec 04             	sub    $0x4,%esp
  801811:	53                   	push   %ebx
  801812:	50                   	push   %eax
  801813:	68 94 32 80 00       	push   $0x803294
  801818:	e8 ec ec ff ff       	call   800509 <cprintf>
		return -E_INVAL;
  80181d:	83 c4 10             	add    $0x10,%esp
  801820:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801825:	eb da                	jmp    801801 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801827:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80182c:	eb d3                	jmp    801801 <ftruncate+0x52>

0080182e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
  801831:	53                   	push   %ebx
  801832:	83 ec 1c             	sub    $0x1c,%esp
  801835:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801838:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80183b:	50                   	push   %eax
  80183c:	ff 75 08             	pushl  0x8(%ebp)
  80183f:	e8 84 fb ff ff       	call   8013c8 <fd_lookup>
  801844:	83 c4 10             	add    $0x10,%esp
  801847:	85 c0                	test   %eax,%eax
  801849:	78 4b                	js     801896 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80184b:	83 ec 08             	sub    $0x8,%esp
  80184e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801851:	50                   	push   %eax
  801852:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801855:	ff 30                	pushl  (%eax)
  801857:	e8 bc fb ff ff       	call   801418 <dev_lookup>
  80185c:	83 c4 10             	add    $0x10,%esp
  80185f:	85 c0                	test   %eax,%eax
  801861:	78 33                	js     801896 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801866:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80186a:	74 2f                	je     80189b <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80186c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80186f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801876:	00 00 00 
	stat->st_isdir = 0;
  801879:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801880:	00 00 00 
	stat->st_dev = dev;
  801883:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801889:	83 ec 08             	sub    $0x8,%esp
  80188c:	53                   	push   %ebx
  80188d:	ff 75 f0             	pushl  -0x10(%ebp)
  801890:	ff 50 14             	call   *0x14(%eax)
  801893:	83 c4 10             	add    $0x10,%esp
}
  801896:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801899:	c9                   	leave  
  80189a:	c3                   	ret    
		return -E_NOT_SUPP;
  80189b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018a0:	eb f4                	jmp    801896 <fstat+0x68>

008018a2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	56                   	push   %esi
  8018a6:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018a7:	83 ec 08             	sub    $0x8,%esp
  8018aa:	6a 00                	push   $0x0
  8018ac:	ff 75 08             	pushl  0x8(%ebp)
  8018af:	e8 22 02 00 00       	call   801ad6 <open>
  8018b4:	89 c3                	mov    %eax,%ebx
  8018b6:	83 c4 10             	add    $0x10,%esp
  8018b9:	85 c0                	test   %eax,%eax
  8018bb:	78 1b                	js     8018d8 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8018bd:	83 ec 08             	sub    $0x8,%esp
  8018c0:	ff 75 0c             	pushl  0xc(%ebp)
  8018c3:	50                   	push   %eax
  8018c4:	e8 65 ff ff ff       	call   80182e <fstat>
  8018c9:	89 c6                	mov    %eax,%esi
	close(fd);
  8018cb:	89 1c 24             	mov    %ebx,(%esp)
  8018ce:	e8 27 fc ff ff       	call   8014fa <close>
	return r;
  8018d3:	83 c4 10             	add    $0x10,%esp
  8018d6:	89 f3                	mov    %esi,%ebx
}
  8018d8:	89 d8                	mov    %ebx,%eax
  8018da:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018dd:	5b                   	pop    %ebx
  8018de:	5e                   	pop    %esi
  8018df:	5d                   	pop    %ebp
  8018e0:	c3                   	ret    

008018e1 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018e1:	55                   	push   %ebp
  8018e2:	89 e5                	mov    %esp,%ebp
  8018e4:	56                   	push   %esi
  8018e5:	53                   	push   %ebx
  8018e6:	89 c6                	mov    %eax,%esi
  8018e8:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8018ea:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8018f1:	74 27                	je     80191a <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018f3:	6a 07                	push   $0x7
  8018f5:	68 00 80 80 00       	push   $0x808000
  8018fa:	56                   	push   %esi
  8018fb:	ff 35 00 60 80 00    	pushl  0x806000
  801901:	e8 02 11 00 00       	call   802a08 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801906:	83 c4 0c             	add    $0xc,%esp
  801909:	6a 00                	push   $0x0
  80190b:	53                   	push   %ebx
  80190c:	6a 00                	push   $0x0
  80190e:	e8 8c 10 00 00       	call   80299f <ipc_recv>
}
  801913:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801916:	5b                   	pop    %ebx
  801917:	5e                   	pop    %esi
  801918:	5d                   	pop    %ebp
  801919:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80191a:	83 ec 0c             	sub    $0xc,%esp
  80191d:	6a 01                	push   $0x1
  80191f:	e8 3c 11 00 00       	call   802a60 <ipc_find_env>
  801924:	a3 00 60 80 00       	mov    %eax,0x806000
  801929:	83 c4 10             	add    $0x10,%esp
  80192c:	eb c5                	jmp    8018f3 <fsipc+0x12>

0080192e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
  801931:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801934:	8b 45 08             	mov    0x8(%ebp),%eax
  801937:	8b 40 0c             	mov    0xc(%eax),%eax
  80193a:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.set_size.req_size = newsize;
  80193f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801942:	a3 04 80 80 00       	mov    %eax,0x808004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801947:	ba 00 00 00 00       	mov    $0x0,%edx
  80194c:	b8 02 00 00 00       	mov    $0x2,%eax
  801951:	e8 8b ff ff ff       	call   8018e1 <fsipc>
}
  801956:	c9                   	leave  
  801957:	c3                   	ret    

00801958 <devfile_flush>:
{
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
  80195b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80195e:	8b 45 08             	mov    0x8(%ebp),%eax
  801961:	8b 40 0c             	mov    0xc(%eax),%eax
  801964:	a3 00 80 80 00       	mov    %eax,0x808000
	return fsipc(FSREQ_FLUSH, NULL);
  801969:	ba 00 00 00 00       	mov    $0x0,%edx
  80196e:	b8 06 00 00 00       	mov    $0x6,%eax
  801973:	e8 69 ff ff ff       	call   8018e1 <fsipc>
}
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <devfile_stat>:
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
  80197d:	53                   	push   %ebx
  80197e:	83 ec 04             	sub    $0x4,%esp
  801981:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801984:	8b 45 08             	mov    0x8(%ebp),%eax
  801987:	8b 40 0c             	mov    0xc(%eax),%eax
  80198a:	a3 00 80 80 00       	mov    %eax,0x808000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80198f:	ba 00 00 00 00       	mov    $0x0,%edx
  801994:	b8 05 00 00 00       	mov    $0x5,%eax
  801999:	e8 43 ff ff ff       	call   8018e1 <fsipc>
  80199e:	85 c0                	test   %eax,%eax
  8019a0:	78 2c                	js     8019ce <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019a2:	83 ec 08             	sub    $0x8,%esp
  8019a5:	68 00 80 80 00       	push   $0x808000
  8019aa:	53                   	push   %ebx
  8019ab:	e8 b8 f2 ff ff       	call   800c68 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019b0:	a1 80 80 80 00       	mov    0x808080,%eax
  8019b5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019bb:	a1 84 80 80 00       	mov    0x808084,%eax
  8019c0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8019c6:	83 c4 10             	add    $0x10,%esp
  8019c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019d1:	c9                   	leave  
  8019d2:	c3                   	ret    

008019d3 <devfile_write>:
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
  8019d6:	53                   	push   %ebx
  8019d7:	83 ec 08             	sub    $0x8,%esp
  8019da:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8019e3:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.write.req_n = n;
  8019e8:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8019ee:	53                   	push   %ebx
  8019ef:	ff 75 0c             	pushl  0xc(%ebp)
  8019f2:	68 08 80 80 00       	push   $0x808008
  8019f7:	e8 5c f4 ff ff       	call   800e58 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8019fc:	ba 00 00 00 00       	mov    $0x0,%edx
  801a01:	b8 04 00 00 00       	mov    $0x4,%eax
  801a06:	e8 d6 fe ff ff       	call   8018e1 <fsipc>
  801a0b:	83 c4 10             	add    $0x10,%esp
  801a0e:	85 c0                	test   %eax,%eax
  801a10:	78 0b                	js     801a1d <devfile_write+0x4a>
	assert(r <= n);
  801a12:	39 d8                	cmp    %ebx,%eax
  801a14:	77 0c                	ja     801a22 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801a16:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a1b:	7f 1e                	jg     801a3b <devfile_write+0x68>
}
  801a1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a20:	c9                   	leave  
  801a21:	c3                   	ret    
	assert(r <= n);
  801a22:	68 04 33 80 00       	push   $0x803304
  801a27:	68 0b 33 80 00       	push   $0x80330b
  801a2c:	68 98 00 00 00       	push   $0x98
  801a31:	68 20 33 80 00       	push   $0x803320
  801a36:	e8 d8 e9 ff ff       	call   800413 <_panic>
	assert(r <= PGSIZE);
  801a3b:	68 2b 33 80 00       	push   $0x80332b
  801a40:	68 0b 33 80 00       	push   $0x80330b
  801a45:	68 99 00 00 00       	push   $0x99
  801a4a:	68 20 33 80 00       	push   $0x803320
  801a4f:	e8 bf e9 ff ff       	call   800413 <_panic>

00801a54 <devfile_read>:
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
  801a57:	56                   	push   %esi
  801a58:	53                   	push   %ebx
  801a59:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5f:	8b 40 0c             	mov    0xc(%eax),%eax
  801a62:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.read.req_n = n;
  801a67:	89 35 04 80 80 00    	mov    %esi,0x808004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a6d:	ba 00 00 00 00       	mov    $0x0,%edx
  801a72:	b8 03 00 00 00       	mov    $0x3,%eax
  801a77:	e8 65 fe ff ff       	call   8018e1 <fsipc>
  801a7c:	89 c3                	mov    %eax,%ebx
  801a7e:	85 c0                	test   %eax,%eax
  801a80:	78 1f                	js     801aa1 <devfile_read+0x4d>
	assert(r <= n);
  801a82:	39 f0                	cmp    %esi,%eax
  801a84:	77 24                	ja     801aaa <devfile_read+0x56>
	assert(r <= PGSIZE);
  801a86:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a8b:	7f 33                	jg     801ac0 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a8d:	83 ec 04             	sub    $0x4,%esp
  801a90:	50                   	push   %eax
  801a91:	68 00 80 80 00       	push   $0x808000
  801a96:	ff 75 0c             	pushl  0xc(%ebp)
  801a99:	e8 58 f3 ff ff       	call   800df6 <memmove>
	return r;
  801a9e:	83 c4 10             	add    $0x10,%esp
}
  801aa1:	89 d8                	mov    %ebx,%eax
  801aa3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aa6:	5b                   	pop    %ebx
  801aa7:	5e                   	pop    %esi
  801aa8:	5d                   	pop    %ebp
  801aa9:	c3                   	ret    
	assert(r <= n);
  801aaa:	68 04 33 80 00       	push   $0x803304
  801aaf:	68 0b 33 80 00       	push   $0x80330b
  801ab4:	6a 7c                	push   $0x7c
  801ab6:	68 20 33 80 00       	push   $0x803320
  801abb:	e8 53 e9 ff ff       	call   800413 <_panic>
	assert(r <= PGSIZE);
  801ac0:	68 2b 33 80 00       	push   $0x80332b
  801ac5:	68 0b 33 80 00       	push   $0x80330b
  801aca:	6a 7d                	push   $0x7d
  801acc:	68 20 33 80 00       	push   $0x803320
  801ad1:	e8 3d e9 ff ff       	call   800413 <_panic>

00801ad6 <open>:
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
  801ad9:	56                   	push   %esi
  801ada:	53                   	push   %ebx
  801adb:	83 ec 1c             	sub    $0x1c,%esp
  801ade:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801ae1:	56                   	push   %esi
  801ae2:	e8 48 f1 ff ff       	call   800c2f <strlen>
  801ae7:	83 c4 10             	add    $0x10,%esp
  801aea:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801aef:	7f 6c                	jg     801b5d <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801af1:	83 ec 0c             	sub    $0xc,%esp
  801af4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801af7:	50                   	push   %eax
  801af8:	e8 79 f8 ff ff       	call   801376 <fd_alloc>
  801afd:	89 c3                	mov    %eax,%ebx
  801aff:	83 c4 10             	add    $0x10,%esp
  801b02:	85 c0                	test   %eax,%eax
  801b04:	78 3c                	js     801b42 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801b06:	83 ec 08             	sub    $0x8,%esp
  801b09:	56                   	push   %esi
  801b0a:	68 00 80 80 00       	push   $0x808000
  801b0f:	e8 54 f1 ff ff       	call   800c68 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b14:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b17:	a3 00 84 80 00       	mov    %eax,0x808400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b1f:	b8 01 00 00 00       	mov    $0x1,%eax
  801b24:	e8 b8 fd ff ff       	call   8018e1 <fsipc>
  801b29:	89 c3                	mov    %eax,%ebx
  801b2b:	83 c4 10             	add    $0x10,%esp
  801b2e:	85 c0                	test   %eax,%eax
  801b30:	78 19                	js     801b4b <open+0x75>
	return fd2num(fd);
  801b32:	83 ec 0c             	sub    $0xc,%esp
  801b35:	ff 75 f4             	pushl  -0xc(%ebp)
  801b38:	e8 12 f8 ff ff       	call   80134f <fd2num>
  801b3d:	89 c3                	mov    %eax,%ebx
  801b3f:	83 c4 10             	add    $0x10,%esp
}
  801b42:	89 d8                	mov    %ebx,%eax
  801b44:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b47:	5b                   	pop    %ebx
  801b48:	5e                   	pop    %esi
  801b49:	5d                   	pop    %ebp
  801b4a:	c3                   	ret    
		fd_close(fd, 0);
  801b4b:	83 ec 08             	sub    $0x8,%esp
  801b4e:	6a 00                	push   $0x0
  801b50:	ff 75 f4             	pushl  -0xc(%ebp)
  801b53:	e8 1b f9 ff ff       	call   801473 <fd_close>
		return r;
  801b58:	83 c4 10             	add    $0x10,%esp
  801b5b:	eb e5                	jmp    801b42 <open+0x6c>
		return -E_BAD_PATH;
  801b5d:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b62:	eb de                	jmp    801b42 <open+0x6c>

00801b64 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
  801b67:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b6a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b6f:	b8 08 00 00 00       	mov    $0x8,%eax
  801b74:	e8 68 fd ff ff       	call   8018e1 <fsipc>
}
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    

00801b7b <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
  801b7e:	57                   	push   %edi
  801b7f:	56                   	push   %esi
  801b80:	53                   	push   %ebx
  801b81:	81 ec 94 02 00 00    	sub    $0x294,%esp
	cprintf("in %s\n", __FUNCTION__);
  801b87:	68 10 34 80 00       	push   $0x803410
  801b8c:	68 89 2e 80 00       	push   $0x802e89
  801b91:	e8 73 e9 ff ff       	call   800509 <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801b96:	83 c4 08             	add    $0x8,%esp
  801b99:	6a 00                	push   $0x0
  801b9b:	ff 75 08             	pushl  0x8(%ebp)
  801b9e:	e8 33 ff ff ff       	call   801ad6 <open>
  801ba3:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801ba9:	83 c4 10             	add    $0x10,%esp
  801bac:	85 c0                	test   %eax,%eax
  801bae:	0f 88 0b 05 00 00    	js     8020bf <spawn+0x544>
  801bb4:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801bb6:	83 ec 04             	sub    $0x4,%esp
  801bb9:	68 00 02 00 00       	push   $0x200
  801bbe:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801bc4:	50                   	push   %eax
  801bc5:	51                   	push   %ecx
  801bc6:	e8 f4 fa ff ff       	call   8016bf <readn>
  801bcb:	83 c4 10             	add    $0x10,%esp
  801bce:	3d 00 02 00 00       	cmp    $0x200,%eax
  801bd3:	75 75                	jne    801c4a <spawn+0xcf>
	    || elf->e_magic != ELF_MAGIC) {
  801bd5:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801bdc:	45 4c 46 
  801bdf:	75 69                	jne    801c4a <spawn+0xcf>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801be1:	b8 07 00 00 00       	mov    $0x7,%eax
  801be6:	cd 30                	int    $0x30
  801be8:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801bee:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801bf4:	85 c0                	test   %eax,%eax
  801bf6:	0f 88 b7 04 00 00    	js     8020b3 <spawn+0x538>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801bfc:	25 ff 03 00 00       	and    $0x3ff,%eax
  801c01:	69 f0 84 00 00 00    	imul   $0x84,%eax,%esi
  801c07:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801c0d:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801c13:	b9 11 00 00 00       	mov    $0x11,%ecx
  801c18:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801c1a:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801c20:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
	cprintf("in %s\n", __FUNCTION__);
  801c26:	83 ec 08             	sub    $0x8,%esp
  801c29:	68 04 34 80 00       	push   $0x803404
  801c2e:	68 89 2e 80 00       	push   $0x802e89
  801c33:	e8 d1 e8 ff ff       	call   800509 <cprintf>
  801c38:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801c3b:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801c40:	be 00 00 00 00       	mov    $0x0,%esi
  801c45:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801c48:	eb 4b                	jmp    801c95 <spawn+0x11a>
		close(fd);
  801c4a:	83 ec 0c             	sub    $0xc,%esp
  801c4d:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801c53:	e8 a2 f8 ff ff       	call   8014fa <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801c58:	83 c4 0c             	add    $0xc,%esp
  801c5b:	68 7f 45 4c 46       	push   $0x464c457f
  801c60:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801c66:	68 37 33 80 00       	push   $0x803337
  801c6b:	e8 99 e8 ff ff       	call   800509 <cprintf>
		return -E_NOT_EXEC;
  801c70:	83 c4 10             	add    $0x10,%esp
  801c73:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801c7a:	ff ff ff 
  801c7d:	e9 3d 04 00 00       	jmp    8020bf <spawn+0x544>
		string_size += strlen(argv[argc]) + 1;
  801c82:	83 ec 0c             	sub    $0xc,%esp
  801c85:	50                   	push   %eax
  801c86:	e8 a4 ef ff ff       	call   800c2f <strlen>
  801c8b:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801c8f:	83 c3 01             	add    $0x1,%ebx
  801c92:	83 c4 10             	add    $0x10,%esp
  801c95:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801c9c:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801c9f:	85 c0                	test   %eax,%eax
  801ca1:	75 df                	jne    801c82 <spawn+0x107>
  801ca3:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801ca9:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801caf:	bf 00 10 40 00       	mov    $0x401000,%edi
  801cb4:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801cb6:	89 fa                	mov    %edi,%edx
  801cb8:	83 e2 fc             	and    $0xfffffffc,%edx
  801cbb:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801cc2:	29 c2                	sub    %eax,%edx
  801cc4:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801cca:	8d 42 f8             	lea    -0x8(%edx),%eax
  801ccd:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801cd2:	0f 86 0a 04 00 00    	jbe    8020e2 <spawn+0x567>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801cd8:	83 ec 04             	sub    $0x4,%esp
  801cdb:	6a 07                	push   $0x7
  801cdd:	68 00 00 40 00       	push   $0x400000
  801ce2:	6a 00                	push   $0x0
  801ce4:	e8 71 f3 ff ff       	call   80105a <sys_page_alloc>
  801ce9:	83 c4 10             	add    $0x10,%esp
  801cec:	85 c0                	test   %eax,%eax
  801cee:	0f 88 f3 03 00 00    	js     8020e7 <spawn+0x56c>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801cf4:	be 00 00 00 00       	mov    $0x0,%esi
  801cf9:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801cff:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801d02:	eb 30                	jmp    801d34 <spawn+0x1b9>
		argv_store[i] = UTEMP2USTACK(string_store);
  801d04:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801d0a:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801d10:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801d13:	83 ec 08             	sub    $0x8,%esp
  801d16:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801d19:	57                   	push   %edi
  801d1a:	e8 49 ef ff ff       	call   800c68 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801d1f:	83 c4 04             	add    $0x4,%esp
  801d22:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801d25:	e8 05 ef ff ff       	call   800c2f <strlen>
  801d2a:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801d2e:	83 c6 01             	add    $0x1,%esi
  801d31:	83 c4 10             	add    $0x10,%esp
  801d34:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801d3a:	7f c8                	jg     801d04 <spawn+0x189>
	}
	argv_store[argc] = 0;
  801d3c:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801d42:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801d48:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801d4f:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801d55:	0f 85 86 00 00 00    	jne    801de1 <spawn+0x266>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801d5b:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  801d61:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  801d67:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  801d6a:	89 d0                	mov    %edx,%eax
  801d6c:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  801d72:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801d75:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801d7a:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801d80:	83 ec 0c             	sub    $0xc,%esp
  801d83:	6a 07                	push   $0x7
  801d85:	68 00 d0 bf ee       	push   $0xeebfd000
  801d8a:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801d90:	68 00 00 40 00       	push   $0x400000
  801d95:	6a 00                	push   $0x0
  801d97:	e8 01 f3 ff ff       	call   80109d <sys_page_map>
  801d9c:	89 c3                	mov    %eax,%ebx
  801d9e:	83 c4 20             	add    $0x20,%esp
  801da1:	85 c0                	test   %eax,%eax
  801da3:	0f 88 46 03 00 00    	js     8020ef <spawn+0x574>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801da9:	83 ec 08             	sub    $0x8,%esp
  801dac:	68 00 00 40 00       	push   $0x400000
  801db1:	6a 00                	push   $0x0
  801db3:	e8 27 f3 ff ff       	call   8010df <sys_page_unmap>
  801db8:	89 c3                	mov    %eax,%ebx
  801dba:	83 c4 10             	add    $0x10,%esp
  801dbd:	85 c0                	test   %eax,%eax
  801dbf:	0f 88 2a 03 00 00    	js     8020ef <spawn+0x574>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801dc5:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801dcb:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801dd2:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801dd9:	00 00 00 
  801ddc:	e9 4f 01 00 00       	jmp    801f30 <spawn+0x3b5>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801de1:	68 c0 33 80 00       	push   $0x8033c0
  801de6:	68 0b 33 80 00       	push   $0x80330b
  801deb:	68 f8 00 00 00       	push   $0xf8
  801df0:	68 51 33 80 00       	push   $0x803351
  801df5:	e8 19 e6 ff ff       	call   800413 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801dfa:	83 ec 04             	sub    $0x4,%esp
  801dfd:	6a 07                	push   $0x7
  801dff:	68 00 00 40 00       	push   $0x400000
  801e04:	6a 00                	push   $0x0
  801e06:	e8 4f f2 ff ff       	call   80105a <sys_page_alloc>
  801e0b:	83 c4 10             	add    $0x10,%esp
  801e0e:	85 c0                	test   %eax,%eax
  801e10:	0f 88 b7 02 00 00    	js     8020cd <spawn+0x552>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801e16:	83 ec 08             	sub    $0x8,%esp
  801e19:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801e1f:	01 f0                	add    %esi,%eax
  801e21:	50                   	push   %eax
  801e22:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801e28:	e8 59 f9 ff ff       	call   801786 <seek>
  801e2d:	83 c4 10             	add    $0x10,%esp
  801e30:	85 c0                	test   %eax,%eax
  801e32:	0f 88 9c 02 00 00    	js     8020d4 <spawn+0x559>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801e38:	83 ec 04             	sub    $0x4,%esp
  801e3b:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801e41:	29 f0                	sub    %esi,%eax
  801e43:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e48:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801e4d:	0f 47 c1             	cmova  %ecx,%eax
  801e50:	50                   	push   %eax
  801e51:	68 00 00 40 00       	push   $0x400000
  801e56:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801e5c:	e8 5e f8 ff ff       	call   8016bf <readn>
  801e61:	83 c4 10             	add    $0x10,%esp
  801e64:	85 c0                	test   %eax,%eax
  801e66:	0f 88 6f 02 00 00    	js     8020db <spawn+0x560>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801e6c:	83 ec 0c             	sub    $0xc,%esp
  801e6f:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801e75:	53                   	push   %ebx
  801e76:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801e7c:	68 00 00 40 00       	push   $0x400000
  801e81:	6a 00                	push   $0x0
  801e83:	e8 15 f2 ff ff       	call   80109d <sys_page_map>
  801e88:	83 c4 20             	add    $0x20,%esp
  801e8b:	85 c0                	test   %eax,%eax
  801e8d:	78 7c                	js     801f0b <spawn+0x390>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801e8f:	83 ec 08             	sub    $0x8,%esp
  801e92:	68 00 00 40 00       	push   $0x400000
  801e97:	6a 00                	push   $0x0
  801e99:	e8 41 f2 ff ff       	call   8010df <sys_page_unmap>
  801e9e:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801ea1:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801ea7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801ead:	89 fe                	mov    %edi,%esi
  801eaf:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801eb5:	76 69                	jbe    801f20 <spawn+0x3a5>
		if (i >= filesz) {
  801eb7:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801ebd:	0f 87 37 ff ff ff    	ja     801dfa <spawn+0x27f>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801ec3:	83 ec 04             	sub    $0x4,%esp
  801ec6:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801ecc:	53                   	push   %ebx
  801ecd:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801ed3:	e8 82 f1 ff ff       	call   80105a <sys_page_alloc>
  801ed8:	83 c4 10             	add    $0x10,%esp
  801edb:	85 c0                	test   %eax,%eax
  801edd:	79 c2                	jns    801ea1 <spawn+0x326>
  801edf:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801ee1:	83 ec 0c             	sub    $0xc,%esp
  801ee4:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801eea:	e8 ec f0 ff ff       	call   800fdb <sys_env_destroy>
	close(fd);
  801eef:	83 c4 04             	add    $0x4,%esp
  801ef2:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801ef8:	e8 fd f5 ff ff       	call   8014fa <close>
	return r;
  801efd:	83 c4 10             	add    $0x10,%esp
  801f00:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801f06:	e9 b4 01 00 00       	jmp    8020bf <spawn+0x544>
				panic("spawn: sys_page_map data: %e", r);
  801f0b:	50                   	push   %eax
  801f0c:	68 5d 33 80 00       	push   $0x80335d
  801f11:	68 2b 01 00 00       	push   $0x12b
  801f16:	68 51 33 80 00       	push   $0x803351
  801f1b:	e8 f3 e4 ff ff       	call   800413 <_panic>
  801f20:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801f26:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801f2d:	83 c6 20             	add    $0x20,%esi
  801f30:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801f37:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801f3d:	7e 6d                	jle    801fac <spawn+0x431>
		if (ph->p_type != ELF_PROG_LOAD)
  801f3f:	83 3e 01             	cmpl   $0x1,(%esi)
  801f42:	75 e2                	jne    801f26 <spawn+0x3ab>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801f44:	8b 46 18             	mov    0x18(%esi),%eax
  801f47:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801f4a:	83 f8 01             	cmp    $0x1,%eax
  801f4d:	19 c0                	sbb    %eax,%eax
  801f4f:	83 e0 fe             	and    $0xfffffffe,%eax
  801f52:	83 c0 07             	add    $0x7,%eax
  801f55:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801f5b:	8b 4e 04             	mov    0x4(%esi),%ecx
  801f5e:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801f64:	8b 56 10             	mov    0x10(%esi),%edx
  801f67:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801f6d:	8b 7e 14             	mov    0x14(%esi),%edi
  801f70:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801f76:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801f79:	89 d8                	mov    %ebx,%eax
  801f7b:	25 ff 0f 00 00       	and    $0xfff,%eax
  801f80:	74 1a                	je     801f9c <spawn+0x421>
		va -= i;
  801f82:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801f84:	01 c7                	add    %eax,%edi
  801f86:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801f8c:	01 c2                	add    %eax,%edx
  801f8e:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801f94:	29 c1                	sub    %eax,%ecx
  801f96:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801f9c:	bf 00 00 00 00       	mov    $0x0,%edi
  801fa1:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801fa7:	e9 01 ff ff ff       	jmp    801ead <spawn+0x332>
	close(fd);
  801fac:	83 ec 0c             	sub    $0xc,%esp
  801faf:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801fb5:	e8 40 f5 ff ff       	call   8014fa <close>

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	cprintf("in %s\n", __FUNCTION__);
  801fba:	83 c4 08             	add    $0x8,%esp
  801fbd:	68 f0 33 80 00       	push   $0x8033f0
  801fc2:	68 89 2e 80 00       	push   $0x802e89
  801fc7:	e8 3d e5 ff ff       	call   800509 <cprintf>
  801fcc:	83 c4 10             	add    $0x10,%esp
	int r;
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  801fcf:	bb 00 00 80 00       	mov    $0x800000,%ebx
  801fd4:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  801fda:	eb 0e                	jmp    801fea <spawn+0x46f>
  801fdc:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801fe2:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801fe8:	74 5e                	je     802048 <spawn+0x4cd>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_SHARE)) == (PTE_P | PTE_U | PTE_SHARE)))
  801fea:	89 d8                	mov    %ebx,%eax
  801fec:	c1 e8 16             	shr    $0x16,%eax
  801fef:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801ff6:	a8 01                	test   $0x1,%al
  801ff8:	74 e2                	je     801fdc <spawn+0x461>
  801ffa:	89 da                	mov    %ebx,%edx
  801ffc:	c1 ea 0c             	shr    $0xc,%edx
  801fff:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  802006:	25 05 04 00 00       	and    $0x405,%eax
  80200b:	3d 05 04 00 00       	cmp    $0x405,%eax
  802010:	75 ca                	jne    801fdc <spawn+0x461>
			if((r = sys_page_map((envid_t)0, (void *)i, child, (void *)i, uvpt[PGNUM(i)] & PTE_SYSCALL)) < 0)
  802012:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  802019:	83 ec 0c             	sub    $0xc,%esp
  80201c:	25 07 0e 00 00       	and    $0xe07,%eax
  802021:	50                   	push   %eax
  802022:	53                   	push   %ebx
  802023:	56                   	push   %esi
  802024:	53                   	push   %ebx
  802025:	6a 00                	push   $0x0
  802027:	e8 71 f0 ff ff       	call   80109d <sys_page_map>
  80202c:	83 c4 20             	add    $0x20,%esp
  80202f:	85 c0                	test   %eax,%eax
  802031:	79 a9                	jns    801fdc <spawn+0x461>
        		panic("sys_page_map: %e\n", r);
  802033:	50                   	push   %eax
  802034:	68 7a 33 80 00       	push   $0x80337a
  802039:	68 3b 01 00 00       	push   $0x13b
  80203e:	68 51 33 80 00       	push   $0x803351
  802043:	e8 cb e3 ff ff       	call   800413 <_panic>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802048:	83 ec 08             	sub    $0x8,%esp
  80204b:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802051:	50                   	push   %eax
  802052:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802058:	e8 06 f1 ff ff       	call   801163 <sys_env_set_trapframe>
  80205d:	83 c4 10             	add    $0x10,%esp
  802060:	85 c0                	test   %eax,%eax
  802062:	78 25                	js     802089 <spawn+0x50e>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802064:	83 ec 08             	sub    $0x8,%esp
  802067:	6a 02                	push   $0x2
  802069:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80206f:	e8 ad f0 ff ff       	call   801121 <sys_env_set_status>
  802074:	83 c4 10             	add    $0x10,%esp
  802077:	85 c0                	test   %eax,%eax
  802079:	78 23                	js     80209e <spawn+0x523>
	return child;
  80207b:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802081:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802087:	eb 36                	jmp    8020bf <spawn+0x544>
		panic("sys_env_set_trapframe: %e", r);
  802089:	50                   	push   %eax
  80208a:	68 8c 33 80 00       	push   $0x80338c
  80208f:	68 8a 00 00 00       	push   $0x8a
  802094:	68 51 33 80 00       	push   $0x803351
  802099:	e8 75 e3 ff ff       	call   800413 <_panic>
		panic("sys_env_set_status: %e", r);
  80209e:	50                   	push   %eax
  80209f:	68 a6 33 80 00       	push   $0x8033a6
  8020a4:	68 8d 00 00 00       	push   $0x8d
  8020a9:	68 51 33 80 00       	push   $0x803351
  8020ae:	e8 60 e3 ff ff       	call   800413 <_panic>
		return r;
  8020b3:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8020b9:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  8020bf:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8020c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020c8:	5b                   	pop    %ebx
  8020c9:	5e                   	pop    %esi
  8020ca:	5f                   	pop    %edi
  8020cb:	5d                   	pop    %ebp
  8020cc:	c3                   	ret    
  8020cd:	89 c7                	mov    %eax,%edi
  8020cf:	e9 0d fe ff ff       	jmp    801ee1 <spawn+0x366>
  8020d4:	89 c7                	mov    %eax,%edi
  8020d6:	e9 06 fe ff ff       	jmp    801ee1 <spawn+0x366>
  8020db:	89 c7                	mov    %eax,%edi
  8020dd:	e9 ff fd ff ff       	jmp    801ee1 <spawn+0x366>
		return -E_NO_MEM;
  8020e2:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  8020e7:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8020ed:	eb d0                	jmp    8020bf <spawn+0x544>
	sys_page_unmap(0, UTEMP);
  8020ef:	83 ec 08             	sub    $0x8,%esp
  8020f2:	68 00 00 40 00       	push   $0x400000
  8020f7:	6a 00                	push   $0x0
  8020f9:	e8 e1 ef ff ff       	call   8010df <sys_page_unmap>
  8020fe:	83 c4 10             	add    $0x10,%esp
  802101:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  802107:	eb b6                	jmp    8020bf <spawn+0x544>

00802109 <spawnl>:
{
  802109:	55                   	push   %ebp
  80210a:	89 e5                	mov    %esp,%ebp
  80210c:	57                   	push   %edi
  80210d:	56                   	push   %esi
  80210e:	53                   	push   %ebx
  80210f:	83 ec 14             	sub    $0x14,%esp
	cprintf("in %s\n", __FUNCTION__);
  802112:	68 e8 33 80 00       	push   $0x8033e8
  802117:	68 89 2e 80 00       	push   $0x802e89
  80211c:	e8 e8 e3 ff ff       	call   800509 <cprintf>
	va_start(vl, arg0);
  802121:	8d 55 10             	lea    0x10(%ebp),%edx
	while(va_arg(vl, void *) != NULL)
  802124:	83 c4 10             	add    $0x10,%esp
	int argc=0;
  802127:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  80212c:	8d 4a 04             	lea    0x4(%edx),%ecx
  80212f:	83 3a 00             	cmpl   $0x0,(%edx)
  802132:	74 07                	je     80213b <spawnl+0x32>
		argc++;
  802134:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  802137:	89 ca                	mov    %ecx,%edx
  802139:	eb f1                	jmp    80212c <spawnl+0x23>
	const char *argv[argc+2];
  80213b:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  802142:	83 e2 f0             	and    $0xfffffff0,%edx
  802145:	29 d4                	sub    %edx,%esp
  802147:	8d 54 24 03          	lea    0x3(%esp),%edx
  80214b:	c1 ea 02             	shr    $0x2,%edx
  80214e:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  802155:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802157:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80215a:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  802161:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  802168:	00 
	va_start(vl, arg0);
  802169:	8d 4d 10             	lea    0x10(%ebp),%ecx
  80216c:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  80216e:	b8 00 00 00 00       	mov    $0x0,%eax
  802173:	eb 0b                	jmp    802180 <spawnl+0x77>
		argv[i+1] = va_arg(vl, const char *);
  802175:	83 c0 01             	add    $0x1,%eax
  802178:	8b 39                	mov    (%ecx),%edi
  80217a:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  80217d:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  802180:	39 d0                	cmp    %edx,%eax
  802182:	75 f1                	jne    802175 <spawnl+0x6c>
	return spawn(prog, argv);
  802184:	83 ec 08             	sub    $0x8,%esp
  802187:	56                   	push   %esi
  802188:	ff 75 08             	pushl  0x8(%ebp)
  80218b:	e8 eb f9 ff ff       	call   801b7b <spawn>
}
  802190:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802193:	5b                   	pop    %ebx
  802194:	5e                   	pop    %esi
  802195:	5f                   	pop    %edi
  802196:	5d                   	pop    %ebp
  802197:	c3                   	ret    

00802198 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802198:	55                   	push   %ebp
  802199:	89 e5                	mov    %esp,%ebp
  80219b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80219e:	68 16 34 80 00       	push   $0x803416
  8021a3:	ff 75 0c             	pushl  0xc(%ebp)
  8021a6:	e8 bd ea ff ff       	call   800c68 <strcpy>
	return 0;
}
  8021ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b0:	c9                   	leave  
  8021b1:	c3                   	ret    

008021b2 <devsock_close>:
{
  8021b2:	55                   	push   %ebp
  8021b3:	89 e5                	mov    %esp,%ebp
  8021b5:	53                   	push   %ebx
  8021b6:	83 ec 10             	sub    $0x10,%esp
  8021b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8021bc:	53                   	push   %ebx
  8021bd:	e8 dd 08 00 00       	call   802a9f <pageref>
  8021c2:	83 c4 10             	add    $0x10,%esp
		return 0;
  8021c5:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8021ca:	83 f8 01             	cmp    $0x1,%eax
  8021cd:	74 07                	je     8021d6 <devsock_close+0x24>
}
  8021cf:	89 d0                	mov    %edx,%eax
  8021d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021d4:	c9                   	leave  
  8021d5:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8021d6:	83 ec 0c             	sub    $0xc,%esp
  8021d9:	ff 73 0c             	pushl  0xc(%ebx)
  8021dc:	e8 b9 02 00 00       	call   80249a <nsipc_close>
  8021e1:	89 c2                	mov    %eax,%edx
  8021e3:	83 c4 10             	add    $0x10,%esp
  8021e6:	eb e7                	jmp    8021cf <devsock_close+0x1d>

008021e8 <devsock_write>:
{
  8021e8:	55                   	push   %ebp
  8021e9:	89 e5                	mov    %esp,%ebp
  8021eb:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8021ee:	6a 00                	push   $0x0
  8021f0:	ff 75 10             	pushl  0x10(%ebp)
  8021f3:	ff 75 0c             	pushl  0xc(%ebp)
  8021f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f9:	ff 70 0c             	pushl  0xc(%eax)
  8021fc:	e8 76 03 00 00       	call   802577 <nsipc_send>
}
  802201:	c9                   	leave  
  802202:	c3                   	ret    

00802203 <devsock_read>:
{
  802203:	55                   	push   %ebp
  802204:	89 e5                	mov    %esp,%ebp
  802206:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802209:	6a 00                	push   $0x0
  80220b:	ff 75 10             	pushl  0x10(%ebp)
  80220e:	ff 75 0c             	pushl  0xc(%ebp)
  802211:	8b 45 08             	mov    0x8(%ebp),%eax
  802214:	ff 70 0c             	pushl  0xc(%eax)
  802217:	e8 ef 02 00 00       	call   80250b <nsipc_recv>
}
  80221c:	c9                   	leave  
  80221d:	c3                   	ret    

0080221e <fd2sockid>:
{
  80221e:	55                   	push   %ebp
  80221f:	89 e5                	mov    %esp,%ebp
  802221:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802224:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802227:	52                   	push   %edx
  802228:	50                   	push   %eax
  802229:	e8 9a f1 ff ff       	call   8013c8 <fd_lookup>
  80222e:	83 c4 10             	add    $0x10,%esp
  802231:	85 c0                	test   %eax,%eax
  802233:	78 10                	js     802245 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802235:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802238:	8b 0d ac 57 80 00    	mov    0x8057ac,%ecx
  80223e:	39 08                	cmp    %ecx,(%eax)
  802240:	75 05                	jne    802247 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802242:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802245:	c9                   	leave  
  802246:	c3                   	ret    
		return -E_NOT_SUPP;
  802247:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80224c:	eb f7                	jmp    802245 <fd2sockid+0x27>

0080224e <alloc_sockfd>:
{
  80224e:	55                   	push   %ebp
  80224f:	89 e5                	mov    %esp,%ebp
  802251:	56                   	push   %esi
  802252:	53                   	push   %ebx
  802253:	83 ec 1c             	sub    $0x1c,%esp
  802256:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802258:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80225b:	50                   	push   %eax
  80225c:	e8 15 f1 ff ff       	call   801376 <fd_alloc>
  802261:	89 c3                	mov    %eax,%ebx
  802263:	83 c4 10             	add    $0x10,%esp
  802266:	85 c0                	test   %eax,%eax
  802268:	78 43                	js     8022ad <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80226a:	83 ec 04             	sub    $0x4,%esp
  80226d:	68 07 04 00 00       	push   $0x407
  802272:	ff 75 f4             	pushl  -0xc(%ebp)
  802275:	6a 00                	push   $0x0
  802277:	e8 de ed ff ff       	call   80105a <sys_page_alloc>
  80227c:	89 c3                	mov    %eax,%ebx
  80227e:	83 c4 10             	add    $0x10,%esp
  802281:	85 c0                	test   %eax,%eax
  802283:	78 28                	js     8022ad <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802285:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802288:	8b 15 ac 57 80 00    	mov    0x8057ac,%edx
  80228e:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802290:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802293:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80229a:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80229d:	83 ec 0c             	sub    $0xc,%esp
  8022a0:	50                   	push   %eax
  8022a1:	e8 a9 f0 ff ff       	call   80134f <fd2num>
  8022a6:	89 c3                	mov    %eax,%ebx
  8022a8:	83 c4 10             	add    $0x10,%esp
  8022ab:	eb 0c                	jmp    8022b9 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8022ad:	83 ec 0c             	sub    $0xc,%esp
  8022b0:	56                   	push   %esi
  8022b1:	e8 e4 01 00 00       	call   80249a <nsipc_close>
		return r;
  8022b6:	83 c4 10             	add    $0x10,%esp
}
  8022b9:	89 d8                	mov    %ebx,%eax
  8022bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022be:	5b                   	pop    %ebx
  8022bf:	5e                   	pop    %esi
  8022c0:	5d                   	pop    %ebp
  8022c1:	c3                   	ret    

008022c2 <accept>:
{
  8022c2:	55                   	push   %ebp
  8022c3:	89 e5                	mov    %esp,%ebp
  8022c5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8022c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cb:	e8 4e ff ff ff       	call   80221e <fd2sockid>
  8022d0:	85 c0                	test   %eax,%eax
  8022d2:	78 1b                	js     8022ef <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8022d4:	83 ec 04             	sub    $0x4,%esp
  8022d7:	ff 75 10             	pushl  0x10(%ebp)
  8022da:	ff 75 0c             	pushl  0xc(%ebp)
  8022dd:	50                   	push   %eax
  8022de:	e8 0e 01 00 00       	call   8023f1 <nsipc_accept>
  8022e3:	83 c4 10             	add    $0x10,%esp
  8022e6:	85 c0                	test   %eax,%eax
  8022e8:	78 05                	js     8022ef <accept+0x2d>
	return alloc_sockfd(r);
  8022ea:	e8 5f ff ff ff       	call   80224e <alloc_sockfd>
}
  8022ef:	c9                   	leave  
  8022f0:	c3                   	ret    

008022f1 <bind>:
{
  8022f1:	55                   	push   %ebp
  8022f2:	89 e5                	mov    %esp,%ebp
  8022f4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8022f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fa:	e8 1f ff ff ff       	call   80221e <fd2sockid>
  8022ff:	85 c0                	test   %eax,%eax
  802301:	78 12                	js     802315 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802303:	83 ec 04             	sub    $0x4,%esp
  802306:	ff 75 10             	pushl  0x10(%ebp)
  802309:	ff 75 0c             	pushl  0xc(%ebp)
  80230c:	50                   	push   %eax
  80230d:	e8 31 01 00 00       	call   802443 <nsipc_bind>
  802312:	83 c4 10             	add    $0x10,%esp
}
  802315:	c9                   	leave  
  802316:	c3                   	ret    

00802317 <shutdown>:
{
  802317:	55                   	push   %ebp
  802318:	89 e5                	mov    %esp,%ebp
  80231a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80231d:	8b 45 08             	mov    0x8(%ebp),%eax
  802320:	e8 f9 fe ff ff       	call   80221e <fd2sockid>
  802325:	85 c0                	test   %eax,%eax
  802327:	78 0f                	js     802338 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802329:	83 ec 08             	sub    $0x8,%esp
  80232c:	ff 75 0c             	pushl  0xc(%ebp)
  80232f:	50                   	push   %eax
  802330:	e8 43 01 00 00       	call   802478 <nsipc_shutdown>
  802335:	83 c4 10             	add    $0x10,%esp
}
  802338:	c9                   	leave  
  802339:	c3                   	ret    

0080233a <connect>:
{
  80233a:	55                   	push   %ebp
  80233b:	89 e5                	mov    %esp,%ebp
  80233d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802340:	8b 45 08             	mov    0x8(%ebp),%eax
  802343:	e8 d6 fe ff ff       	call   80221e <fd2sockid>
  802348:	85 c0                	test   %eax,%eax
  80234a:	78 12                	js     80235e <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80234c:	83 ec 04             	sub    $0x4,%esp
  80234f:	ff 75 10             	pushl  0x10(%ebp)
  802352:	ff 75 0c             	pushl  0xc(%ebp)
  802355:	50                   	push   %eax
  802356:	e8 59 01 00 00       	call   8024b4 <nsipc_connect>
  80235b:	83 c4 10             	add    $0x10,%esp
}
  80235e:	c9                   	leave  
  80235f:	c3                   	ret    

00802360 <listen>:
{
  802360:	55                   	push   %ebp
  802361:	89 e5                	mov    %esp,%ebp
  802363:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802366:	8b 45 08             	mov    0x8(%ebp),%eax
  802369:	e8 b0 fe ff ff       	call   80221e <fd2sockid>
  80236e:	85 c0                	test   %eax,%eax
  802370:	78 0f                	js     802381 <listen+0x21>
	return nsipc_listen(r, backlog);
  802372:	83 ec 08             	sub    $0x8,%esp
  802375:	ff 75 0c             	pushl  0xc(%ebp)
  802378:	50                   	push   %eax
  802379:	e8 6b 01 00 00       	call   8024e9 <nsipc_listen>
  80237e:	83 c4 10             	add    $0x10,%esp
}
  802381:	c9                   	leave  
  802382:	c3                   	ret    

00802383 <socket>:

int
socket(int domain, int type, int protocol)
{
  802383:	55                   	push   %ebp
  802384:	89 e5                	mov    %esp,%ebp
  802386:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802389:	ff 75 10             	pushl  0x10(%ebp)
  80238c:	ff 75 0c             	pushl  0xc(%ebp)
  80238f:	ff 75 08             	pushl  0x8(%ebp)
  802392:	e8 3e 02 00 00       	call   8025d5 <nsipc_socket>
  802397:	83 c4 10             	add    $0x10,%esp
  80239a:	85 c0                	test   %eax,%eax
  80239c:	78 05                	js     8023a3 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80239e:	e8 ab fe ff ff       	call   80224e <alloc_sockfd>
}
  8023a3:	c9                   	leave  
  8023a4:	c3                   	ret    

008023a5 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8023a5:	55                   	push   %ebp
  8023a6:	89 e5                	mov    %esp,%ebp
  8023a8:	53                   	push   %ebx
  8023a9:	83 ec 04             	sub    $0x4,%esp
  8023ac:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8023ae:	83 3d 04 60 80 00 00 	cmpl   $0x0,0x806004
  8023b5:	74 26                	je     8023dd <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8023b7:	6a 07                	push   $0x7
  8023b9:	68 00 90 80 00       	push   $0x809000
  8023be:	53                   	push   %ebx
  8023bf:	ff 35 04 60 80 00    	pushl  0x806004
  8023c5:	e8 3e 06 00 00       	call   802a08 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8023ca:	83 c4 0c             	add    $0xc,%esp
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	e8 c7 05 00 00       	call   80299f <ipc_recv>
}
  8023d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023db:	c9                   	leave  
  8023dc:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8023dd:	83 ec 0c             	sub    $0xc,%esp
  8023e0:	6a 02                	push   $0x2
  8023e2:	e8 79 06 00 00       	call   802a60 <ipc_find_env>
  8023e7:	a3 04 60 80 00       	mov    %eax,0x806004
  8023ec:	83 c4 10             	add    $0x10,%esp
  8023ef:	eb c6                	jmp    8023b7 <nsipc+0x12>

008023f1 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8023f1:	55                   	push   %ebp
  8023f2:	89 e5                	mov    %esp,%ebp
  8023f4:	56                   	push   %esi
  8023f5:	53                   	push   %ebx
  8023f6:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8023f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fc:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802401:	8b 06                	mov    (%esi),%eax
  802403:	a3 04 90 80 00       	mov    %eax,0x809004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802408:	b8 01 00 00 00       	mov    $0x1,%eax
  80240d:	e8 93 ff ff ff       	call   8023a5 <nsipc>
  802412:	89 c3                	mov    %eax,%ebx
  802414:	85 c0                	test   %eax,%eax
  802416:	79 09                	jns    802421 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802418:	89 d8                	mov    %ebx,%eax
  80241a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80241d:	5b                   	pop    %ebx
  80241e:	5e                   	pop    %esi
  80241f:	5d                   	pop    %ebp
  802420:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802421:	83 ec 04             	sub    $0x4,%esp
  802424:	ff 35 10 90 80 00    	pushl  0x809010
  80242a:	68 00 90 80 00       	push   $0x809000
  80242f:	ff 75 0c             	pushl  0xc(%ebp)
  802432:	e8 bf e9 ff ff       	call   800df6 <memmove>
		*addrlen = ret->ret_addrlen;
  802437:	a1 10 90 80 00       	mov    0x809010,%eax
  80243c:	89 06                	mov    %eax,(%esi)
  80243e:	83 c4 10             	add    $0x10,%esp
	return r;
  802441:	eb d5                	jmp    802418 <nsipc_accept+0x27>

00802443 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802443:	55                   	push   %ebp
  802444:	89 e5                	mov    %esp,%ebp
  802446:	53                   	push   %ebx
  802447:	83 ec 08             	sub    $0x8,%esp
  80244a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80244d:	8b 45 08             	mov    0x8(%ebp),%eax
  802450:	a3 00 90 80 00       	mov    %eax,0x809000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802455:	53                   	push   %ebx
  802456:	ff 75 0c             	pushl  0xc(%ebp)
  802459:	68 04 90 80 00       	push   $0x809004
  80245e:	e8 93 e9 ff ff       	call   800df6 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802463:	89 1d 14 90 80 00    	mov    %ebx,0x809014
	return nsipc(NSREQ_BIND);
  802469:	b8 02 00 00 00       	mov    $0x2,%eax
  80246e:	e8 32 ff ff ff       	call   8023a5 <nsipc>
}
  802473:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802476:	c9                   	leave  
  802477:	c3                   	ret    

00802478 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802478:	55                   	push   %ebp
  802479:	89 e5                	mov    %esp,%ebp
  80247b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80247e:	8b 45 08             	mov    0x8(%ebp),%eax
  802481:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.shutdown.req_how = how;
  802486:	8b 45 0c             	mov    0xc(%ebp),%eax
  802489:	a3 04 90 80 00       	mov    %eax,0x809004
	return nsipc(NSREQ_SHUTDOWN);
  80248e:	b8 03 00 00 00       	mov    $0x3,%eax
  802493:	e8 0d ff ff ff       	call   8023a5 <nsipc>
}
  802498:	c9                   	leave  
  802499:	c3                   	ret    

0080249a <nsipc_close>:

int
nsipc_close(int s)
{
  80249a:	55                   	push   %ebp
  80249b:	89 e5                	mov    %esp,%ebp
  80249d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8024a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a3:	a3 00 90 80 00       	mov    %eax,0x809000
	return nsipc(NSREQ_CLOSE);
  8024a8:	b8 04 00 00 00       	mov    $0x4,%eax
  8024ad:	e8 f3 fe ff ff       	call   8023a5 <nsipc>
}
  8024b2:	c9                   	leave  
  8024b3:	c3                   	ret    

008024b4 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8024b4:	55                   	push   %ebp
  8024b5:	89 e5                	mov    %esp,%ebp
  8024b7:	53                   	push   %ebx
  8024b8:	83 ec 08             	sub    $0x8,%esp
  8024bb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8024be:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c1:	a3 00 90 80 00       	mov    %eax,0x809000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8024c6:	53                   	push   %ebx
  8024c7:	ff 75 0c             	pushl  0xc(%ebp)
  8024ca:	68 04 90 80 00       	push   $0x809004
  8024cf:	e8 22 e9 ff ff       	call   800df6 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8024d4:	89 1d 14 90 80 00    	mov    %ebx,0x809014
	return nsipc(NSREQ_CONNECT);
  8024da:	b8 05 00 00 00       	mov    $0x5,%eax
  8024df:	e8 c1 fe ff ff       	call   8023a5 <nsipc>
}
  8024e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024e7:	c9                   	leave  
  8024e8:	c3                   	ret    

008024e9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8024e9:	55                   	push   %ebp
  8024ea:	89 e5                	mov    %esp,%ebp
  8024ec:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8024ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f2:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.listen.req_backlog = backlog;
  8024f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024fa:	a3 04 90 80 00       	mov    %eax,0x809004
	return nsipc(NSREQ_LISTEN);
  8024ff:	b8 06 00 00 00       	mov    $0x6,%eax
  802504:	e8 9c fe ff ff       	call   8023a5 <nsipc>
}
  802509:	c9                   	leave  
  80250a:	c3                   	ret    

0080250b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80250b:	55                   	push   %ebp
  80250c:	89 e5                	mov    %esp,%ebp
  80250e:	56                   	push   %esi
  80250f:	53                   	push   %ebx
  802510:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802513:	8b 45 08             	mov    0x8(%ebp),%eax
  802516:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.recv.req_len = len;
  80251b:	89 35 04 90 80 00    	mov    %esi,0x809004
	nsipcbuf.recv.req_flags = flags;
  802521:	8b 45 14             	mov    0x14(%ebp),%eax
  802524:	a3 08 90 80 00       	mov    %eax,0x809008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802529:	b8 07 00 00 00       	mov    $0x7,%eax
  80252e:	e8 72 fe ff ff       	call   8023a5 <nsipc>
  802533:	89 c3                	mov    %eax,%ebx
  802535:	85 c0                	test   %eax,%eax
  802537:	78 1f                	js     802558 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802539:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80253e:	7f 21                	jg     802561 <nsipc_recv+0x56>
  802540:	39 c6                	cmp    %eax,%esi
  802542:	7c 1d                	jl     802561 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802544:	83 ec 04             	sub    $0x4,%esp
  802547:	50                   	push   %eax
  802548:	68 00 90 80 00       	push   $0x809000
  80254d:	ff 75 0c             	pushl  0xc(%ebp)
  802550:	e8 a1 e8 ff ff       	call   800df6 <memmove>
  802555:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802558:	89 d8                	mov    %ebx,%eax
  80255a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80255d:	5b                   	pop    %ebx
  80255e:	5e                   	pop    %esi
  80255f:	5d                   	pop    %ebp
  802560:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802561:	68 22 34 80 00       	push   $0x803422
  802566:	68 0b 33 80 00       	push   $0x80330b
  80256b:	6a 62                	push   $0x62
  80256d:	68 37 34 80 00       	push   $0x803437
  802572:	e8 9c de ff ff       	call   800413 <_panic>

00802577 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802577:	55                   	push   %ebp
  802578:	89 e5                	mov    %esp,%ebp
  80257a:	53                   	push   %ebx
  80257b:	83 ec 04             	sub    $0x4,%esp
  80257e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802581:	8b 45 08             	mov    0x8(%ebp),%eax
  802584:	a3 00 90 80 00       	mov    %eax,0x809000
	assert(size < 1600);
  802589:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80258f:	7f 2e                	jg     8025bf <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802591:	83 ec 04             	sub    $0x4,%esp
  802594:	53                   	push   %ebx
  802595:	ff 75 0c             	pushl  0xc(%ebp)
  802598:	68 0c 90 80 00       	push   $0x80900c
  80259d:	e8 54 e8 ff ff       	call   800df6 <memmove>
	nsipcbuf.send.req_size = size;
  8025a2:	89 1d 04 90 80 00    	mov    %ebx,0x809004
	nsipcbuf.send.req_flags = flags;
  8025a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8025ab:	a3 08 90 80 00       	mov    %eax,0x809008
	return nsipc(NSREQ_SEND);
  8025b0:	b8 08 00 00 00       	mov    $0x8,%eax
  8025b5:	e8 eb fd ff ff       	call   8023a5 <nsipc>
}
  8025ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025bd:	c9                   	leave  
  8025be:	c3                   	ret    
	assert(size < 1600);
  8025bf:	68 43 34 80 00       	push   $0x803443
  8025c4:	68 0b 33 80 00       	push   $0x80330b
  8025c9:	6a 6d                	push   $0x6d
  8025cb:	68 37 34 80 00       	push   $0x803437
  8025d0:	e8 3e de ff ff       	call   800413 <_panic>

008025d5 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8025d5:	55                   	push   %ebp
  8025d6:	89 e5                	mov    %esp,%ebp
  8025d8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8025db:	8b 45 08             	mov    0x8(%ebp),%eax
  8025de:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.socket.req_type = type;
  8025e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025e6:	a3 04 90 80 00       	mov    %eax,0x809004
	nsipcbuf.socket.req_protocol = protocol;
  8025eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8025ee:	a3 08 90 80 00       	mov    %eax,0x809008
	return nsipc(NSREQ_SOCKET);
  8025f3:	b8 09 00 00 00       	mov    $0x9,%eax
  8025f8:	e8 a8 fd ff ff       	call   8023a5 <nsipc>
}
  8025fd:	c9                   	leave  
  8025fe:	c3                   	ret    

008025ff <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8025ff:	55                   	push   %ebp
  802600:	89 e5                	mov    %esp,%ebp
  802602:	56                   	push   %esi
  802603:	53                   	push   %ebx
  802604:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802607:	83 ec 0c             	sub    $0xc,%esp
  80260a:	ff 75 08             	pushl  0x8(%ebp)
  80260d:	e8 4d ed ff ff       	call   80135f <fd2data>
  802612:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802614:	83 c4 08             	add    $0x8,%esp
  802617:	68 4f 34 80 00       	push   $0x80344f
  80261c:	53                   	push   %ebx
  80261d:	e8 46 e6 ff ff       	call   800c68 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802622:	8b 46 04             	mov    0x4(%esi),%eax
  802625:	2b 06                	sub    (%esi),%eax
  802627:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80262d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802634:	00 00 00 
	stat->st_dev = &devpipe;
  802637:	c7 83 88 00 00 00 c8 	movl   $0x8057c8,0x88(%ebx)
  80263e:	57 80 00 
	return 0;
}
  802641:	b8 00 00 00 00       	mov    $0x0,%eax
  802646:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802649:	5b                   	pop    %ebx
  80264a:	5e                   	pop    %esi
  80264b:	5d                   	pop    %ebp
  80264c:	c3                   	ret    

0080264d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80264d:	55                   	push   %ebp
  80264e:	89 e5                	mov    %esp,%ebp
  802650:	53                   	push   %ebx
  802651:	83 ec 0c             	sub    $0xc,%esp
  802654:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802657:	53                   	push   %ebx
  802658:	6a 00                	push   $0x0
  80265a:	e8 80 ea ff ff       	call   8010df <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80265f:	89 1c 24             	mov    %ebx,(%esp)
  802662:	e8 f8 ec ff ff       	call   80135f <fd2data>
  802667:	83 c4 08             	add    $0x8,%esp
  80266a:	50                   	push   %eax
  80266b:	6a 00                	push   $0x0
  80266d:	e8 6d ea ff ff       	call   8010df <sys_page_unmap>
}
  802672:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802675:	c9                   	leave  
  802676:	c3                   	ret    

00802677 <_pipeisclosed>:
{
  802677:	55                   	push   %ebp
  802678:	89 e5                	mov    %esp,%ebp
  80267a:	57                   	push   %edi
  80267b:	56                   	push   %esi
  80267c:	53                   	push   %ebx
  80267d:	83 ec 1c             	sub    $0x1c,%esp
  802680:	89 c7                	mov    %eax,%edi
  802682:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802684:	a1 90 77 80 00       	mov    0x807790,%eax
  802689:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80268c:	83 ec 0c             	sub    $0xc,%esp
  80268f:	57                   	push   %edi
  802690:	e8 0a 04 00 00       	call   802a9f <pageref>
  802695:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802698:	89 34 24             	mov    %esi,(%esp)
  80269b:	e8 ff 03 00 00       	call   802a9f <pageref>
		nn = thisenv->env_runs;
  8026a0:	8b 15 90 77 80 00    	mov    0x807790,%edx
  8026a6:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8026a9:	83 c4 10             	add    $0x10,%esp
  8026ac:	39 cb                	cmp    %ecx,%ebx
  8026ae:	74 1b                	je     8026cb <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8026b0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8026b3:	75 cf                	jne    802684 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8026b5:	8b 42 58             	mov    0x58(%edx),%eax
  8026b8:	6a 01                	push   $0x1
  8026ba:	50                   	push   %eax
  8026bb:	53                   	push   %ebx
  8026bc:	68 56 34 80 00       	push   $0x803456
  8026c1:	e8 43 de ff ff       	call   800509 <cprintf>
  8026c6:	83 c4 10             	add    $0x10,%esp
  8026c9:	eb b9                	jmp    802684 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8026cb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8026ce:	0f 94 c0             	sete   %al
  8026d1:	0f b6 c0             	movzbl %al,%eax
}
  8026d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026d7:	5b                   	pop    %ebx
  8026d8:	5e                   	pop    %esi
  8026d9:	5f                   	pop    %edi
  8026da:	5d                   	pop    %ebp
  8026db:	c3                   	ret    

008026dc <devpipe_write>:
{
  8026dc:	55                   	push   %ebp
  8026dd:	89 e5                	mov    %esp,%ebp
  8026df:	57                   	push   %edi
  8026e0:	56                   	push   %esi
  8026e1:	53                   	push   %ebx
  8026e2:	83 ec 28             	sub    $0x28,%esp
  8026e5:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8026e8:	56                   	push   %esi
  8026e9:	e8 71 ec ff ff       	call   80135f <fd2data>
  8026ee:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8026f0:	83 c4 10             	add    $0x10,%esp
  8026f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8026f8:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8026fb:	74 4f                	je     80274c <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8026fd:	8b 43 04             	mov    0x4(%ebx),%eax
  802700:	8b 0b                	mov    (%ebx),%ecx
  802702:	8d 51 20             	lea    0x20(%ecx),%edx
  802705:	39 d0                	cmp    %edx,%eax
  802707:	72 14                	jb     80271d <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802709:	89 da                	mov    %ebx,%edx
  80270b:	89 f0                	mov    %esi,%eax
  80270d:	e8 65 ff ff ff       	call   802677 <_pipeisclosed>
  802712:	85 c0                	test   %eax,%eax
  802714:	75 3b                	jne    802751 <devpipe_write+0x75>
			sys_yield();
  802716:	e8 20 e9 ff ff       	call   80103b <sys_yield>
  80271b:	eb e0                	jmp    8026fd <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80271d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802720:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802724:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802727:	89 c2                	mov    %eax,%edx
  802729:	c1 fa 1f             	sar    $0x1f,%edx
  80272c:	89 d1                	mov    %edx,%ecx
  80272e:	c1 e9 1b             	shr    $0x1b,%ecx
  802731:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802734:	83 e2 1f             	and    $0x1f,%edx
  802737:	29 ca                	sub    %ecx,%edx
  802739:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80273d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802741:	83 c0 01             	add    $0x1,%eax
  802744:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802747:	83 c7 01             	add    $0x1,%edi
  80274a:	eb ac                	jmp    8026f8 <devpipe_write+0x1c>
	return i;
  80274c:	8b 45 10             	mov    0x10(%ebp),%eax
  80274f:	eb 05                	jmp    802756 <devpipe_write+0x7a>
				return 0;
  802751:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802756:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802759:	5b                   	pop    %ebx
  80275a:	5e                   	pop    %esi
  80275b:	5f                   	pop    %edi
  80275c:	5d                   	pop    %ebp
  80275d:	c3                   	ret    

0080275e <devpipe_read>:
{
  80275e:	55                   	push   %ebp
  80275f:	89 e5                	mov    %esp,%ebp
  802761:	57                   	push   %edi
  802762:	56                   	push   %esi
  802763:	53                   	push   %ebx
  802764:	83 ec 18             	sub    $0x18,%esp
  802767:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80276a:	57                   	push   %edi
  80276b:	e8 ef eb ff ff       	call   80135f <fd2data>
  802770:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802772:	83 c4 10             	add    $0x10,%esp
  802775:	be 00 00 00 00       	mov    $0x0,%esi
  80277a:	3b 75 10             	cmp    0x10(%ebp),%esi
  80277d:	75 14                	jne    802793 <devpipe_read+0x35>
	return i;
  80277f:	8b 45 10             	mov    0x10(%ebp),%eax
  802782:	eb 02                	jmp    802786 <devpipe_read+0x28>
				return i;
  802784:	89 f0                	mov    %esi,%eax
}
  802786:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802789:	5b                   	pop    %ebx
  80278a:	5e                   	pop    %esi
  80278b:	5f                   	pop    %edi
  80278c:	5d                   	pop    %ebp
  80278d:	c3                   	ret    
			sys_yield();
  80278e:	e8 a8 e8 ff ff       	call   80103b <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802793:	8b 03                	mov    (%ebx),%eax
  802795:	3b 43 04             	cmp    0x4(%ebx),%eax
  802798:	75 18                	jne    8027b2 <devpipe_read+0x54>
			if (i > 0)
  80279a:	85 f6                	test   %esi,%esi
  80279c:	75 e6                	jne    802784 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80279e:	89 da                	mov    %ebx,%edx
  8027a0:	89 f8                	mov    %edi,%eax
  8027a2:	e8 d0 fe ff ff       	call   802677 <_pipeisclosed>
  8027a7:	85 c0                	test   %eax,%eax
  8027a9:	74 e3                	je     80278e <devpipe_read+0x30>
				return 0;
  8027ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b0:	eb d4                	jmp    802786 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8027b2:	99                   	cltd   
  8027b3:	c1 ea 1b             	shr    $0x1b,%edx
  8027b6:	01 d0                	add    %edx,%eax
  8027b8:	83 e0 1f             	and    $0x1f,%eax
  8027bb:	29 d0                	sub    %edx,%eax
  8027bd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8027c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027c5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8027c8:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8027cb:	83 c6 01             	add    $0x1,%esi
  8027ce:	eb aa                	jmp    80277a <devpipe_read+0x1c>

008027d0 <pipe>:
{
  8027d0:	55                   	push   %ebp
  8027d1:	89 e5                	mov    %esp,%ebp
  8027d3:	56                   	push   %esi
  8027d4:	53                   	push   %ebx
  8027d5:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8027d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027db:	50                   	push   %eax
  8027dc:	e8 95 eb ff ff       	call   801376 <fd_alloc>
  8027e1:	89 c3                	mov    %eax,%ebx
  8027e3:	83 c4 10             	add    $0x10,%esp
  8027e6:	85 c0                	test   %eax,%eax
  8027e8:	0f 88 23 01 00 00    	js     802911 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027ee:	83 ec 04             	sub    $0x4,%esp
  8027f1:	68 07 04 00 00       	push   $0x407
  8027f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8027f9:	6a 00                	push   $0x0
  8027fb:	e8 5a e8 ff ff       	call   80105a <sys_page_alloc>
  802800:	89 c3                	mov    %eax,%ebx
  802802:	83 c4 10             	add    $0x10,%esp
  802805:	85 c0                	test   %eax,%eax
  802807:	0f 88 04 01 00 00    	js     802911 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80280d:	83 ec 0c             	sub    $0xc,%esp
  802810:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802813:	50                   	push   %eax
  802814:	e8 5d eb ff ff       	call   801376 <fd_alloc>
  802819:	89 c3                	mov    %eax,%ebx
  80281b:	83 c4 10             	add    $0x10,%esp
  80281e:	85 c0                	test   %eax,%eax
  802820:	0f 88 db 00 00 00    	js     802901 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802826:	83 ec 04             	sub    $0x4,%esp
  802829:	68 07 04 00 00       	push   $0x407
  80282e:	ff 75 f0             	pushl  -0x10(%ebp)
  802831:	6a 00                	push   $0x0
  802833:	e8 22 e8 ff ff       	call   80105a <sys_page_alloc>
  802838:	89 c3                	mov    %eax,%ebx
  80283a:	83 c4 10             	add    $0x10,%esp
  80283d:	85 c0                	test   %eax,%eax
  80283f:	0f 88 bc 00 00 00    	js     802901 <pipe+0x131>
	va = fd2data(fd0);
  802845:	83 ec 0c             	sub    $0xc,%esp
  802848:	ff 75 f4             	pushl  -0xc(%ebp)
  80284b:	e8 0f eb ff ff       	call   80135f <fd2data>
  802850:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802852:	83 c4 0c             	add    $0xc,%esp
  802855:	68 07 04 00 00       	push   $0x407
  80285a:	50                   	push   %eax
  80285b:	6a 00                	push   $0x0
  80285d:	e8 f8 e7 ff ff       	call   80105a <sys_page_alloc>
  802862:	89 c3                	mov    %eax,%ebx
  802864:	83 c4 10             	add    $0x10,%esp
  802867:	85 c0                	test   %eax,%eax
  802869:	0f 88 82 00 00 00    	js     8028f1 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80286f:	83 ec 0c             	sub    $0xc,%esp
  802872:	ff 75 f0             	pushl  -0x10(%ebp)
  802875:	e8 e5 ea ff ff       	call   80135f <fd2data>
  80287a:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802881:	50                   	push   %eax
  802882:	6a 00                	push   $0x0
  802884:	56                   	push   %esi
  802885:	6a 00                	push   $0x0
  802887:	e8 11 e8 ff ff       	call   80109d <sys_page_map>
  80288c:	89 c3                	mov    %eax,%ebx
  80288e:	83 c4 20             	add    $0x20,%esp
  802891:	85 c0                	test   %eax,%eax
  802893:	78 4e                	js     8028e3 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802895:	a1 c8 57 80 00       	mov    0x8057c8,%eax
  80289a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80289d:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80289f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8028a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028ac:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8028ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8028b8:	83 ec 0c             	sub    $0xc,%esp
  8028bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8028be:	e8 8c ea ff ff       	call   80134f <fd2num>
  8028c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8028c6:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8028c8:	83 c4 04             	add    $0x4,%esp
  8028cb:	ff 75 f0             	pushl  -0x10(%ebp)
  8028ce:	e8 7c ea ff ff       	call   80134f <fd2num>
  8028d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8028d6:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8028d9:	83 c4 10             	add    $0x10,%esp
  8028dc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8028e1:	eb 2e                	jmp    802911 <pipe+0x141>
	sys_page_unmap(0, va);
  8028e3:	83 ec 08             	sub    $0x8,%esp
  8028e6:	56                   	push   %esi
  8028e7:	6a 00                	push   $0x0
  8028e9:	e8 f1 e7 ff ff       	call   8010df <sys_page_unmap>
  8028ee:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8028f1:	83 ec 08             	sub    $0x8,%esp
  8028f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8028f7:	6a 00                	push   $0x0
  8028f9:	e8 e1 e7 ff ff       	call   8010df <sys_page_unmap>
  8028fe:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802901:	83 ec 08             	sub    $0x8,%esp
  802904:	ff 75 f4             	pushl  -0xc(%ebp)
  802907:	6a 00                	push   $0x0
  802909:	e8 d1 e7 ff ff       	call   8010df <sys_page_unmap>
  80290e:	83 c4 10             	add    $0x10,%esp
}
  802911:	89 d8                	mov    %ebx,%eax
  802913:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802916:	5b                   	pop    %ebx
  802917:	5e                   	pop    %esi
  802918:	5d                   	pop    %ebp
  802919:	c3                   	ret    

0080291a <pipeisclosed>:
{
  80291a:	55                   	push   %ebp
  80291b:	89 e5                	mov    %esp,%ebp
  80291d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802920:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802923:	50                   	push   %eax
  802924:	ff 75 08             	pushl  0x8(%ebp)
  802927:	e8 9c ea ff ff       	call   8013c8 <fd_lookup>
  80292c:	83 c4 10             	add    $0x10,%esp
  80292f:	85 c0                	test   %eax,%eax
  802931:	78 18                	js     80294b <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802933:	83 ec 0c             	sub    $0xc,%esp
  802936:	ff 75 f4             	pushl  -0xc(%ebp)
  802939:	e8 21 ea ff ff       	call   80135f <fd2data>
	return _pipeisclosed(fd, p);
  80293e:	89 c2                	mov    %eax,%edx
  802940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802943:	e8 2f fd ff ff       	call   802677 <_pipeisclosed>
  802948:	83 c4 10             	add    $0x10,%esp
}
  80294b:	c9                   	leave  
  80294c:	c3                   	ret    

0080294d <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80294d:	55                   	push   %ebp
  80294e:	89 e5                	mov    %esp,%ebp
  802950:	56                   	push   %esi
  802951:	53                   	push   %ebx
  802952:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802955:	85 f6                	test   %esi,%esi
  802957:	74 16                	je     80296f <wait+0x22>
	e = &envs[ENVX(envid)];
  802959:	89 f3                	mov    %esi,%ebx
  80295b:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE){
  802961:	69 db 84 00 00 00    	imul   $0x84,%ebx,%ebx
  802967:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80296d:	eb 1b                	jmp    80298a <wait+0x3d>
	assert(envid != 0);
  80296f:	68 6e 34 80 00       	push   $0x80346e
  802974:	68 0b 33 80 00       	push   $0x80330b
  802979:	6a 09                	push   $0x9
  80297b:	68 79 34 80 00       	push   $0x803479
  802980:	e8 8e da ff ff       	call   800413 <_panic>
		sys_yield();
  802985:	e8 b1 e6 ff ff       	call   80103b <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE){
  80298a:	8b 43 48             	mov    0x48(%ebx),%eax
  80298d:	39 f0                	cmp    %esi,%eax
  80298f:	75 07                	jne    802998 <wait+0x4b>
  802991:	8b 43 54             	mov    0x54(%ebx),%eax
  802994:	85 c0                	test   %eax,%eax
  802996:	75 ed                	jne    802985 <wait+0x38>
	}
}
  802998:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80299b:	5b                   	pop    %ebx
  80299c:	5e                   	pop    %esi
  80299d:	5d                   	pop    %ebp
  80299e:	c3                   	ret    

0080299f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80299f:	55                   	push   %ebp
  8029a0:	89 e5                	mov    %esp,%ebp
  8029a2:	56                   	push   %esi
  8029a3:	53                   	push   %ebx
  8029a4:	8b 75 08             	mov    0x8(%ebp),%esi
  8029a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029aa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8029ad:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8029af:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8029b4:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8029b7:	83 ec 0c             	sub    $0xc,%esp
  8029ba:	50                   	push   %eax
  8029bb:	e8 4a e8 ff ff       	call   80120a <sys_ipc_recv>
	if(ret < 0){
  8029c0:	83 c4 10             	add    $0x10,%esp
  8029c3:	85 c0                	test   %eax,%eax
  8029c5:	78 2b                	js     8029f2 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8029c7:	85 f6                	test   %esi,%esi
  8029c9:	74 0a                	je     8029d5 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8029cb:	a1 90 77 80 00       	mov    0x807790,%eax
  8029d0:	8b 40 78             	mov    0x78(%eax),%eax
  8029d3:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8029d5:	85 db                	test   %ebx,%ebx
  8029d7:	74 0a                	je     8029e3 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8029d9:	a1 90 77 80 00       	mov    0x807790,%eax
  8029de:	8b 40 7c             	mov    0x7c(%eax),%eax
  8029e1:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8029e3:	a1 90 77 80 00       	mov    0x807790,%eax
  8029e8:	8b 40 74             	mov    0x74(%eax),%eax
}
  8029eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8029ee:	5b                   	pop    %ebx
  8029ef:	5e                   	pop    %esi
  8029f0:	5d                   	pop    %ebp
  8029f1:	c3                   	ret    
		if(from_env_store)
  8029f2:	85 f6                	test   %esi,%esi
  8029f4:	74 06                	je     8029fc <ipc_recv+0x5d>
			*from_env_store = 0;
  8029f6:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8029fc:	85 db                	test   %ebx,%ebx
  8029fe:	74 eb                	je     8029eb <ipc_recv+0x4c>
			*perm_store = 0;
  802a00:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802a06:	eb e3                	jmp    8029eb <ipc_recv+0x4c>

00802a08 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802a08:	55                   	push   %ebp
  802a09:	89 e5                	mov    %esp,%ebp
  802a0b:	57                   	push   %edi
  802a0c:	56                   	push   %esi
  802a0d:	53                   	push   %ebx
  802a0e:	83 ec 0c             	sub    $0xc,%esp
  802a11:	8b 7d 08             	mov    0x8(%ebp),%edi
  802a14:	8b 75 0c             	mov    0xc(%ebp),%esi
  802a17:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802a1a:	85 db                	test   %ebx,%ebx
  802a1c:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802a21:	0f 44 d8             	cmove  %eax,%ebx
  802a24:	eb 05                	jmp    802a2b <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802a26:	e8 10 e6 ff ff       	call   80103b <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802a2b:	ff 75 14             	pushl  0x14(%ebp)
  802a2e:	53                   	push   %ebx
  802a2f:	56                   	push   %esi
  802a30:	57                   	push   %edi
  802a31:	e8 b1 e7 ff ff       	call   8011e7 <sys_ipc_try_send>
  802a36:	83 c4 10             	add    $0x10,%esp
  802a39:	85 c0                	test   %eax,%eax
  802a3b:	74 1b                	je     802a58 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802a3d:	79 e7                	jns    802a26 <ipc_send+0x1e>
  802a3f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802a42:	74 e2                	je     802a26 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802a44:	83 ec 04             	sub    $0x4,%esp
  802a47:	68 84 34 80 00       	push   $0x803484
  802a4c:	6a 46                	push   $0x46
  802a4e:	68 99 34 80 00       	push   $0x803499
  802a53:	e8 bb d9 ff ff       	call   800413 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802a58:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a5b:	5b                   	pop    %ebx
  802a5c:	5e                   	pop    %esi
  802a5d:	5f                   	pop    %edi
  802a5e:	5d                   	pop    %ebp
  802a5f:	c3                   	ret    

00802a60 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802a60:	55                   	push   %ebp
  802a61:	89 e5                	mov    %esp,%ebp
  802a63:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802a66:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802a6b:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802a71:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802a77:	8b 52 50             	mov    0x50(%edx),%edx
  802a7a:	39 ca                	cmp    %ecx,%edx
  802a7c:	74 11                	je     802a8f <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802a7e:	83 c0 01             	add    $0x1,%eax
  802a81:	3d 00 04 00 00       	cmp    $0x400,%eax
  802a86:	75 e3                	jne    802a6b <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802a88:	b8 00 00 00 00       	mov    $0x0,%eax
  802a8d:	eb 0e                	jmp    802a9d <ipc_find_env+0x3d>
			return envs[i].env_id;
  802a8f:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  802a95:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802a9a:	8b 40 48             	mov    0x48(%eax),%eax
}
  802a9d:	5d                   	pop    %ebp
  802a9e:	c3                   	ret    

00802a9f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802a9f:	55                   	push   %ebp
  802aa0:	89 e5                	mov    %esp,%ebp
  802aa2:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802aa5:	89 d0                	mov    %edx,%eax
  802aa7:	c1 e8 16             	shr    $0x16,%eax
  802aaa:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802ab1:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802ab6:	f6 c1 01             	test   $0x1,%cl
  802ab9:	74 1d                	je     802ad8 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802abb:	c1 ea 0c             	shr    $0xc,%edx
  802abe:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802ac5:	f6 c2 01             	test   $0x1,%dl
  802ac8:	74 0e                	je     802ad8 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802aca:	c1 ea 0c             	shr    $0xc,%edx
  802acd:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802ad4:	ef 
  802ad5:	0f b7 c0             	movzwl %ax,%eax
}
  802ad8:	5d                   	pop    %ebp
  802ad9:	c3                   	ret    
  802ada:	66 90                	xchg   %ax,%ax
  802adc:	66 90                	xchg   %ax,%ax
  802ade:	66 90                	xchg   %ax,%ax

00802ae0 <__udivdi3>:
  802ae0:	55                   	push   %ebp
  802ae1:	57                   	push   %edi
  802ae2:	56                   	push   %esi
  802ae3:	53                   	push   %ebx
  802ae4:	83 ec 1c             	sub    $0x1c,%esp
  802ae7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802aeb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802aef:	8b 74 24 34          	mov    0x34(%esp),%esi
  802af3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802af7:	85 d2                	test   %edx,%edx
  802af9:	75 4d                	jne    802b48 <__udivdi3+0x68>
  802afb:	39 f3                	cmp    %esi,%ebx
  802afd:	76 19                	jbe    802b18 <__udivdi3+0x38>
  802aff:	31 ff                	xor    %edi,%edi
  802b01:	89 e8                	mov    %ebp,%eax
  802b03:	89 f2                	mov    %esi,%edx
  802b05:	f7 f3                	div    %ebx
  802b07:	89 fa                	mov    %edi,%edx
  802b09:	83 c4 1c             	add    $0x1c,%esp
  802b0c:	5b                   	pop    %ebx
  802b0d:	5e                   	pop    %esi
  802b0e:	5f                   	pop    %edi
  802b0f:	5d                   	pop    %ebp
  802b10:	c3                   	ret    
  802b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b18:	89 d9                	mov    %ebx,%ecx
  802b1a:	85 db                	test   %ebx,%ebx
  802b1c:	75 0b                	jne    802b29 <__udivdi3+0x49>
  802b1e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b23:	31 d2                	xor    %edx,%edx
  802b25:	f7 f3                	div    %ebx
  802b27:	89 c1                	mov    %eax,%ecx
  802b29:	31 d2                	xor    %edx,%edx
  802b2b:	89 f0                	mov    %esi,%eax
  802b2d:	f7 f1                	div    %ecx
  802b2f:	89 c6                	mov    %eax,%esi
  802b31:	89 e8                	mov    %ebp,%eax
  802b33:	89 f7                	mov    %esi,%edi
  802b35:	f7 f1                	div    %ecx
  802b37:	89 fa                	mov    %edi,%edx
  802b39:	83 c4 1c             	add    $0x1c,%esp
  802b3c:	5b                   	pop    %ebx
  802b3d:	5e                   	pop    %esi
  802b3e:	5f                   	pop    %edi
  802b3f:	5d                   	pop    %ebp
  802b40:	c3                   	ret    
  802b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b48:	39 f2                	cmp    %esi,%edx
  802b4a:	77 1c                	ja     802b68 <__udivdi3+0x88>
  802b4c:	0f bd fa             	bsr    %edx,%edi
  802b4f:	83 f7 1f             	xor    $0x1f,%edi
  802b52:	75 2c                	jne    802b80 <__udivdi3+0xa0>
  802b54:	39 f2                	cmp    %esi,%edx
  802b56:	72 06                	jb     802b5e <__udivdi3+0x7e>
  802b58:	31 c0                	xor    %eax,%eax
  802b5a:	39 eb                	cmp    %ebp,%ebx
  802b5c:	77 a9                	ja     802b07 <__udivdi3+0x27>
  802b5e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b63:	eb a2                	jmp    802b07 <__udivdi3+0x27>
  802b65:	8d 76 00             	lea    0x0(%esi),%esi
  802b68:	31 ff                	xor    %edi,%edi
  802b6a:	31 c0                	xor    %eax,%eax
  802b6c:	89 fa                	mov    %edi,%edx
  802b6e:	83 c4 1c             	add    $0x1c,%esp
  802b71:	5b                   	pop    %ebx
  802b72:	5e                   	pop    %esi
  802b73:	5f                   	pop    %edi
  802b74:	5d                   	pop    %ebp
  802b75:	c3                   	ret    
  802b76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b7d:	8d 76 00             	lea    0x0(%esi),%esi
  802b80:	89 f9                	mov    %edi,%ecx
  802b82:	b8 20 00 00 00       	mov    $0x20,%eax
  802b87:	29 f8                	sub    %edi,%eax
  802b89:	d3 e2                	shl    %cl,%edx
  802b8b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802b8f:	89 c1                	mov    %eax,%ecx
  802b91:	89 da                	mov    %ebx,%edx
  802b93:	d3 ea                	shr    %cl,%edx
  802b95:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b99:	09 d1                	or     %edx,%ecx
  802b9b:	89 f2                	mov    %esi,%edx
  802b9d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ba1:	89 f9                	mov    %edi,%ecx
  802ba3:	d3 e3                	shl    %cl,%ebx
  802ba5:	89 c1                	mov    %eax,%ecx
  802ba7:	d3 ea                	shr    %cl,%edx
  802ba9:	89 f9                	mov    %edi,%ecx
  802bab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802baf:	89 eb                	mov    %ebp,%ebx
  802bb1:	d3 e6                	shl    %cl,%esi
  802bb3:	89 c1                	mov    %eax,%ecx
  802bb5:	d3 eb                	shr    %cl,%ebx
  802bb7:	09 de                	or     %ebx,%esi
  802bb9:	89 f0                	mov    %esi,%eax
  802bbb:	f7 74 24 08          	divl   0x8(%esp)
  802bbf:	89 d6                	mov    %edx,%esi
  802bc1:	89 c3                	mov    %eax,%ebx
  802bc3:	f7 64 24 0c          	mull   0xc(%esp)
  802bc7:	39 d6                	cmp    %edx,%esi
  802bc9:	72 15                	jb     802be0 <__udivdi3+0x100>
  802bcb:	89 f9                	mov    %edi,%ecx
  802bcd:	d3 e5                	shl    %cl,%ebp
  802bcf:	39 c5                	cmp    %eax,%ebp
  802bd1:	73 04                	jae    802bd7 <__udivdi3+0xf7>
  802bd3:	39 d6                	cmp    %edx,%esi
  802bd5:	74 09                	je     802be0 <__udivdi3+0x100>
  802bd7:	89 d8                	mov    %ebx,%eax
  802bd9:	31 ff                	xor    %edi,%edi
  802bdb:	e9 27 ff ff ff       	jmp    802b07 <__udivdi3+0x27>
  802be0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802be3:	31 ff                	xor    %edi,%edi
  802be5:	e9 1d ff ff ff       	jmp    802b07 <__udivdi3+0x27>
  802bea:	66 90                	xchg   %ax,%ax
  802bec:	66 90                	xchg   %ax,%ax
  802bee:	66 90                	xchg   %ax,%ax

00802bf0 <__umoddi3>:
  802bf0:	55                   	push   %ebp
  802bf1:	57                   	push   %edi
  802bf2:	56                   	push   %esi
  802bf3:	53                   	push   %ebx
  802bf4:	83 ec 1c             	sub    $0x1c,%esp
  802bf7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802bfb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802bff:	8b 74 24 30          	mov    0x30(%esp),%esi
  802c03:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802c07:	89 da                	mov    %ebx,%edx
  802c09:	85 c0                	test   %eax,%eax
  802c0b:	75 43                	jne    802c50 <__umoddi3+0x60>
  802c0d:	39 df                	cmp    %ebx,%edi
  802c0f:	76 17                	jbe    802c28 <__umoddi3+0x38>
  802c11:	89 f0                	mov    %esi,%eax
  802c13:	f7 f7                	div    %edi
  802c15:	89 d0                	mov    %edx,%eax
  802c17:	31 d2                	xor    %edx,%edx
  802c19:	83 c4 1c             	add    $0x1c,%esp
  802c1c:	5b                   	pop    %ebx
  802c1d:	5e                   	pop    %esi
  802c1e:	5f                   	pop    %edi
  802c1f:	5d                   	pop    %ebp
  802c20:	c3                   	ret    
  802c21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c28:	89 fd                	mov    %edi,%ebp
  802c2a:	85 ff                	test   %edi,%edi
  802c2c:	75 0b                	jne    802c39 <__umoddi3+0x49>
  802c2e:	b8 01 00 00 00       	mov    $0x1,%eax
  802c33:	31 d2                	xor    %edx,%edx
  802c35:	f7 f7                	div    %edi
  802c37:	89 c5                	mov    %eax,%ebp
  802c39:	89 d8                	mov    %ebx,%eax
  802c3b:	31 d2                	xor    %edx,%edx
  802c3d:	f7 f5                	div    %ebp
  802c3f:	89 f0                	mov    %esi,%eax
  802c41:	f7 f5                	div    %ebp
  802c43:	89 d0                	mov    %edx,%eax
  802c45:	eb d0                	jmp    802c17 <__umoddi3+0x27>
  802c47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c4e:	66 90                	xchg   %ax,%ax
  802c50:	89 f1                	mov    %esi,%ecx
  802c52:	39 d8                	cmp    %ebx,%eax
  802c54:	76 0a                	jbe    802c60 <__umoddi3+0x70>
  802c56:	89 f0                	mov    %esi,%eax
  802c58:	83 c4 1c             	add    $0x1c,%esp
  802c5b:	5b                   	pop    %ebx
  802c5c:	5e                   	pop    %esi
  802c5d:	5f                   	pop    %edi
  802c5e:	5d                   	pop    %ebp
  802c5f:	c3                   	ret    
  802c60:	0f bd e8             	bsr    %eax,%ebp
  802c63:	83 f5 1f             	xor    $0x1f,%ebp
  802c66:	75 20                	jne    802c88 <__umoddi3+0x98>
  802c68:	39 d8                	cmp    %ebx,%eax
  802c6a:	0f 82 b0 00 00 00    	jb     802d20 <__umoddi3+0x130>
  802c70:	39 f7                	cmp    %esi,%edi
  802c72:	0f 86 a8 00 00 00    	jbe    802d20 <__umoddi3+0x130>
  802c78:	89 c8                	mov    %ecx,%eax
  802c7a:	83 c4 1c             	add    $0x1c,%esp
  802c7d:	5b                   	pop    %ebx
  802c7e:	5e                   	pop    %esi
  802c7f:	5f                   	pop    %edi
  802c80:	5d                   	pop    %ebp
  802c81:	c3                   	ret    
  802c82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802c88:	89 e9                	mov    %ebp,%ecx
  802c8a:	ba 20 00 00 00       	mov    $0x20,%edx
  802c8f:	29 ea                	sub    %ebp,%edx
  802c91:	d3 e0                	shl    %cl,%eax
  802c93:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c97:	89 d1                	mov    %edx,%ecx
  802c99:	89 f8                	mov    %edi,%eax
  802c9b:	d3 e8                	shr    %cl,%eax
  802c9d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802ca1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802ca5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802ca9:	09 c1                	or     %eax,%ecx
  802cab:	89 d8                	mov    %ebx,%eax
  802cad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802cb1:	89 e9                	mov    %ebp,%ecx
  802cb3:	d3 e7                	shl    %cl,%edi
  802cb5:	89 d1                	mov    %edx,%ecx
  802cb7:	d3 e8                	shr    %cl,%eax
  802cb9:	89 e9                	mov    %ebp,%ecx
  802cbb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802cbf:	d3 e3                	shl    %cl,%ebx
  802cc1:	89 c7                	mov    %eax,%edi
  802cc3:	89 d1                	mov    %edx,%ecx
  802cc5:	89 f0                	mov    %esi,%eax
  802cc7:	d3 e8                	shr    %cl,%eax
  802cc9:	89 e9                	mov    %ebp,%ecx
  802ccb:	89 fa                	mov    %edi,%edx
  802ccd:	d3 e6                	shl    %cl,%esi
  802ccf:	09 d8                	or     %ebx,%eax
  802cd1:	f7 74 24 08          	divl   0x8(%esp)
  802cd5:	89 d1                	mov    %edx,%ecx
  802cd7:	89 f3                	mov    %esi,%ebx
  802cd9:	f7 64 24 0c          	mull   0xc(%esp)
  802cdd:	89 c6                	mov    %eax,%esi
  802cdf:	89 d7                	mov    %edx,%edi
  802ce1:	39 d1                	cmp    %edx,%ecx
  802ce3:	72 06                	jb     802ceb <__umoddi3+0xfb>
  802ce5:	75 10                	jne    802cf7 <__umoddi3+0x107>
  802ce7:	39 c3                	cmp    %eax,%ebx
  802ce9:	73 0c                	jae    802cf7 <__umoddi3+0x107>
  802ceb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802cef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802cf3:	89 d7                	mov    %edx,%edi
  802cf5:	89 c6                	mov    %eax,%esi
  802cf7:	89 ca                	mov    %ecx,%edx
  802cf9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802cfe:	29 f3                	sub    %esi,%ebx
  802d00:	19 fa                	sbb    %edi,%edx
  802d02:	89 d0                	mov    %edx,%eax
  802d04:	d3 e0                	shl    %cl,%eax
  802d06:	89 e9                	mov    %ebp,%ecx
  802d08:	d3 eb                	shr    %cl,%ebx
  802d0a:	d3 ea                	shr    %cl,%edx
  802d0c:	09 d8                	or     %ebx,%eax
  802d0e:	83 c4 1c             	add    $0x1c,%esp
  802d11:	5b                   	pop    %ebx
  802d12:	5e                   	pop    %esi
  802d13:	5f                   	pop    %edi
  802d14:	5d                   	pop    %ebp
  802d15:	c3                   	ret    
  802d16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802d1d:	8d 76 00             	lea    0x0(%esi),%esi
  802d20:	89 da                	mov    %ebx,%edx
  802d22:	29 fe                	sub    %edi,%esi
  802d24:	19 c2                	sbb    %eax,%edx
  802d26:	89 f1                	mov    %esi,%ecx
  802d28:	89 c8                	mov    %ecx,%eax
  802d2a:	e9 4b ff ff ff       	jmp    802c7a <__umoddi3+0x8a>
