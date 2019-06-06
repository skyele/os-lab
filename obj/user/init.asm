
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
  80006d:	68 a0 2d 80 00       	push   $0x802da0
  800072:	e8 22 05 00 00       	call   800599 <cprintf>

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
  8000a0:	68 64 2e 80 00       	push   $0x802e64
  8000a5:	e8 ef 04 00 00       	call   800599 <cprintf>
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
  8000ca:	68 a0 2e 80 00       	push   $0x802ea0
  8000cf:	e8 c5 04 00 00       	call   800599 <cprintf>
  8000d4:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  8000d7:	83 ec 08             	sub    $0x8,%esp
  8000da:	68 dc 2d 80 00       	push   $0x802ddc
  8000df:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8000e5:	50                   	push   %eax
  8000e6:	e8 2d 0c 00 00       	call   800d18 <strcat>
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
  800100:	68 e8 2d 80 00       	push   $0x802de8
  800105:	56                   	push   %esi
  800106:	e8 0d 0c 00 00       	call   800d18 <strcat>
		strcat(args, argv[i]);
  80010b:	83 c4 08             	add    $0x8,%esp
  80010e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800111:	ff 34 98             	pushl  (%eax,%ebx,4)
  800114:	56                   	push   %esi
  800115:	e8 fe 0b 00 00       	call   800d18 <strcat>
		strcat(args, "'");
  80011a:	83 c4 08             	add    $0x8,%esp
  80011d:	68 e9 2d 80 00       	push   $0x802de9
  800122:	56                   	push   %esi
  800123:	e8 f0 0b 00 00       	call   800d18 <strcat>
	for (i = 0; i < argc; i++) {
  800128:	83 c3 01             	add    $0x1,%ebx
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	eb c9                	jmp    8000f9 <umain+0x9b>
		cprintf("init: data seems okay\n");
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	68 af 2d 80 00       	push   $0x802daf
  800138:	e8 5c 04 00 00       	call   800599 <cprintf>
  80013d:	83 c4 10             	add    $0x10,%esp
  800140:	e9 68 ff ff ff       	jmp    8000ad <umain+0x4f>
		cprintf("init: bss seems okay\n");
  800145:	83 ec 0c             	sub    $0xc,%esp
  800148:	68 c6 2d 80 00       	push   $0x802dc6
  80014d:	e8 47 04 00 00       	call   800599 <cprintf>
  800152:	83 c4 10             	add    $0x10,%esp
  800155:	eb 80                	jmp    8000d7 <umain+0x79>
	}
	cprintf("%s\n", args);
  800157:	83 ec 08             	sub    $0x8,%esp
  80015a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800160:	50                   	push   %eax
  800161:	68 3a 2f 80 00       	push   $0x802f3a
  800166:	e8 2e 04 00 00       	call   800599 <cprintf>

	cprintf("init: running sh\n");
  80016b:	c7 04 24 eb 2d 80 00 	movl   $0x802deb,(%esp)
  800172:	e8 22 04 00 00       	call   800599 <cprintf>

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  800177:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80017e:	e8 e7 13 00 00       	call   80156a <close>
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
  800192:	68 16 2e 80 00       	push   $0x802e16
  800197:	6a 39                	push   $0x39
  800199:	68 0a 2e 80 00       	push   $0x802e0a
  80019e:	e8 00 03 00 00       	call   8004a3 <_panic>
		panic("opencons: %e", r);
  8001a3:	50                   	push   %eax
  8001a4:	68 fd 2d 80 00       	push   $0x802dfd
  8001a9:	6a 37                	push   $0x37
  8001ab:	68 0a 2e 80 00       	push   $0x802e0a
  8001b0:	e8 ee 02 00 00       	call   8004a3 <_panic>
	if ((r = dup(0, 1)) < 0)
  8001b5:	83 ec 08             	sub    $0x8,%esp
  8001b8:	6a 01                	push   $0x1
  8001ba:	6a 00                	push   $0x0
  8001bc:	e8 fb 13 00 00       	call   8015bc <dup>
  8001c1:	83 c4 10             	add    $0x10,%esp
  8001c4:	85 c0                	test   %eax,%eax
  8001c6:	79 23                	jns    8001eb <umain+0x18d>
		panic("dup: %e", r);
  8001c8:	50                   	push   %eax
  8001c9:	68 30 2e 80 00       	push   $0x802e30
  8001ce:	6a 3b                	push   $0x3b
  8001d0:	68 0a 2e 80 00       	push   $0x802e0a
  8001d5:	e8 c9 02 00 00       	call   8004a3 <_panic>
	while (1) {
		cprintf("init: starting sh\n");
		r = spawnl("/sh", "sh", (char*)0);
		if (r < 0) {
			cprintf("init: spawn sh: %e\n", r);
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	50                   	push   %eax
  8001de:	68 4f 2e 80 00       	push   $0x802e4f
  8001e3:	e8 b1 03 00 00       	call   800599 <cprintf>
			continue;
  8001e8:	83 c4 10             	add    $0x10,%esp
		cprintf("init: starting sh\n");
  8001eb:	83 ec 0c             	sub    $0xc,%esp
  8001ee:	68 38 2e 80 00       	push   $0x802e38
  8001f3:	e8 a1 03 00 00       	call   800599 <cprintf>
		r = spawnl("/sh", "sh", (char*)0);
  8001f8:	83 c4 0c             	add    $0xc,%esp
  8001fb:	6a 00                	push   $0x0
  8001fd:	68 4c 2e 80 00       	push   $0x802e4c
  800202:	68 4b 2e 80 00       	push   $0x802e4b
  800207:	e8 6c 1f 00 00       	call   802178 <spawnl>
		if (r < 0) {
  80020c:	83 c4 10             	add    $0x10,%esp
  80020f:	85 c0                	test   %eax,%eax
  800211:	78 c7                	js     8001da <umain+0x17c>
		}
		wait(r);
  800213:	83 ec 0c             	sub    $0xc,%esp
  800216:	50                   	push   %eax
  800217:	e8 a0 27 00 00       	call   8029bc <wait>
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
  80022d:	68 cf 2e 80 00       	push   $0x802ecf
  800232:	ff 75 0c             	pushl  0xc(%ebp)
  800235:	e8 be 0a 00 00       	call   800cf8 <strcpy>
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
  800278:	e8 09 0c 00 00       	call   800e86 <memmove>
		sys_cputs(buf, m);
  80027d:	83 c4 08             	add    $0x8,%esp
  800280:	53                   	push   %ebx
  800281:	57                   	push   %edi
  800282:	e8 a7 0d 00 00       	call   80102e <sys_cputs>
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
  8002a9:	e8 9e 0d 00 00       	call   80104c <sys_cgetc>
  8002ae:	85 c0                	test   %eax,%eax
  8002b0:	75 07                	jne    8002b9 <devcons_read+0x21>
		sys_yield();
  8002b2:	e8 14 0e 00 00       	call   8010cb <sys_yield>
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
  8002e5:	e8 44 0d 00 00       	call   80102e <sys_cputs>
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
  8002fd:	e8 a6 13 00 00       	call   8016a8 <read>
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
  800325:	e8 0e 11 00 00       	call   801438 <fd_lookup>
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
  80034e:	e8 93 10 00 00       	call   8013e6 <fd_alloc>
  800353:	83 c4 10             	add    $0x10,%esp
  800356:	85 c0                	test   %eax,%eax
  800358:	78 3a                	js     800394 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80035a:	83 ec 04             	sub    $0x4,%esp
  80035d:	68 07 04 00 00       	push   $0x407
  800362:	ff 75 f4             	pushl  -0xc(%ebp)
  800365:	6a 00                	push   $0x0
  800367:	e8 7e 0d 00 00       	call   8010ea <sys_page_alloc>
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
  80038c:	e8 2e 10 00 00       	call   8013bf <fd2num>
  800391:	83 c4 10             	add    $0x10,%esp
}
  800394:	c9                   	leave  
  800395:	c3                   	ret    

00800396 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800396:	55                   	push   %ebp
  800397:	89 e5                	mov    %esp,%ebp
  800399:	57                   	push   %edi
  80039a:	56                   	push   %esi
  80039b:	53                   	push   %ebx
  80039c:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  80039f:	c7 05 90 77 80 00 00 	movl   $0x0,0x807790
  8003a6:	00 00 00 
	envid_t find = sys_getenvid();
  8003a9:	e8 fe 0c 00 00       	call   8010ac <sys_getenvid>
  8003ae:	8b 1d 90 77 80 00    	mov    0x807790,%ebx
  8003b4:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8003b9:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8003be:	bf 01 00 00 00       	mov    $0x1,%edi
  8003c3:	eb 0b                	jmp    8003d0 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8003c5:	83 c2 01             	add    $0x1,%edx
  8003c8:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8003ce:	74 21                	je     8003f1 <libmain+0x5b>
		if(envs[i].env_id == find)
  8003d0:	89 d1                	mov    %edx,%ecx
  8003d2:	c1 e1 07             	shl    $0x7,%ecx
  8003d5:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8003db:	8b 49 48             	mov    0x48(%ecx),%ecx
  8003de:	39 c1                	cmp    %eax,%ecx
  8003e0:	75 e3                	jne    8003c5 <libmain+0x2f>
  8003e2:	89 d3                	mov    %edx,%ebx
  8003e4:	c1 e3 07             	shl    $0x7,%ebx
  8003e7:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8003ed:	89 fe                	mov    %edi,%esi
  8003ef:	eb d4                	jmp    8003c5 <libmain+0x2f>
  8003f1:	89 f0                	mov    %esi,%eax
  8003f3:	84 c0                	test   %al,%al
  8003f5:	74 06                	je     8003fd <libmain+0x67>
  8003f7:	89 1d 90 77 80 00    	mov    %ebx,0x807790
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800401:	7e 0a                	jle    80040d <libmain+0x77>
		binaryname = argv[0];
  800403:	8b 45 0c             	mov    0xc(%ebp),%eax
  800406:	8b 00                	mov    (%eax),%eax
  800408:	a3 8c 57 80 00       	mov    %eax,0x80578c

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  80040d:	a1 90 77 80 00       	mov    0x807790,%eax
  800412:	8b 40 48             	mov    0x48(%eax),%eax
  800415:	83 ec 08             	sub    $0x8,%esp
  800418:	50                   	push   %eax
  800419:	68 db 2e 80 00       	push   $0x802edb
  80041e:	e8 76 01 00 00       	call   800599 <cprintf>
	cprintf("before umain\n");
  800423:	c7 04 24 f9 2e 80 00 	movl   $0x802ef9,(%esp)
  80042a:	e8 6a 01 00 00       	call   800599 <cprintf>
	// call user main routine
	umain(argc, argv);
  80042f:	83 c4 08             	add    $0x8,%esp
  800432:	ff 75 0c             	pushl  0xc(%ebp)
  800435:	ff 75 08             	pushl  0x8(%ebp)
  800438:	e8 21 fc ff ff       	call   80005e <umain>
	cprintf("after umain\n");
  80043d:	c7 04 24 07 2f 80 00 	movl   $0x802f07,(%esp)
  800444:	e8 50 01 00 00       	call   800599 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800449:	a1 90 77 80 00       	mov    0x807790,%eax
  80044e:	8b 40 48             	mov    0x48(%eax),%eax
  800451:	83 c4 08             	add    $0x8,%esp
  800454:	50                   	push   %eax
  800455:	68 14 2f 80 00       	push   $0x802f14
  80045a:	e8 3a 01 00 00       	call   800599 <cprintf>
	// exit gracefully
	exit();
  80045f:	e8 0b 00 00 00       	call   80046f <exit>
}
  800464:	83 c4 10             	add    $0x10,%esp
  800467:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80046a:	5b                   	pop    %ebx
  80046b:	5e                   	pop    %esi
  80046c:	5f                   	pop    %edi
  80046d:	5d                   	pop    %ebp
  80046e:	c3                   	ret    

0080046f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80046f:	55                   	push   %ebp
  800470:	89 e5                	mov    %esp,%ebp
  800472:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800475:	a1 90 77 80 00       	mov    0x807790,%eax
  80047a:	8b 40 48             	mov    0x48(%eax),%eax
  80047d:	68 40 2f 80 00       	push   $0x802f40
  800482:	50                   	push   %eax
  800483:	68 33 2f 80 00       	push   $0x802f33
  800488:	e8 0c 01 00 00       	call   800599 <cprintf>
	close_all();
  80048d:	e8 05 11 00 00       	call   801597 <close_all>
	sys_env_destroy(0);
  800492:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800499:	e8 cd 0b 00 00       	call   80106b <sys_env_destroy>
}
  80049e:	83 c4 10             	add    $0x10,%esp
  8004a1:	c9                   	leave  
  8004a2:	c3                   	ret    

008004a3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8004a3:	55                   	push   %ebp
  8004a4:	89 e5                	mov    %esp,%ebp
  8004a6:	56                   	push   %esi
  8004a7:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8004a8:	a1 90 77 80 00       	mov    0x807790,%eax
  8004ad:	8b 40 48             	mov    0x48(%eax),%eax
  8004b0:	83 ec 04             	sub    $0x4,%esp
  8004b3:	68 6c 2f 80 00       	push   $0x802f6c
  8004b8:	50                   	push   %eax
  8004b9:	68 33 2f 80 00       	push   $0x802f33
  8004be:	e8 d6 00 00 00       	call   800599 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8004c3:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8004c6:	8b 35 8c 57 80 00    	mov    0x80578c,%esi
  8004cc:	e8 db 0b 00 00       	call   8010ac <sys_getenvid>
  8004d1:	83 c4 04             	add    $0x4,%esp
  8004d4:	ff 75 0c             	pushl  0xc(%ebp)
  8004d7:	ff 75 08             	pushl  0x8(%ebp)
  8004da:	56                   	push   %esi
  8004db:	50                   	push   %eax
  8004dc:	68 48 2f 80 00       	push   $0x802f48
  8004e1:	e8 b3 00 00 00       	call   800599 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004e6:	83 c4 18             	add    $0x18,%esp
  8004e9:	53                   	push   %ebx
  8004ea:	ff 75 10             	pushl  0x10(%ebp)
  8004ed:	e8 56 00 00 00       	call   800548 <vcprintf>
	cprintf("\n");
  8004f2:	c7 04 24 f7 2e 80 00 	movl   $0x802ef7,(%esp)
  8004f9:	e8 9b 00 00 00       	call   800599 <cprintf>
  8004fe:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800501:	cc                   	int3   
  800502:	eb fd                	jmp    800501 <_panic+0x5e>

00800504 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800504:	55                   	push   %ebp
  800505:	89 e5                	mov    %esp,%ebp
  800507:	53                   	push   %ebx
  800508:	83 ec 04             	sub    $0x4,%esp
  80050b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80050e:	8b 13                	mov    (%ebx),%edx
  800510:	8d 42 01             	lea    0x1(%edx),%eax
  800513:	89 03                	mov    %eax,(%ebx)
  800515:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800518:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80051c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800521:	74 09                	je     80052c <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800523:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800527:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80052a:	c9                   	leave  
  80052b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80052c:	83 ec 08             	sub    $0x8,%esp
  80052f:	68 ff 00 00 00       	push   $0xff
  800534:	8d 43 08             	lea    0x8(%ebx),%eax
  800537:	50                   	push   %eax
  800538:	e8 f1 0a 00 00       	call   80102e <sys_cputs>
		b->idx = 0;
  80053d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800543:	83 c4 10             	add    $0x10,%esp
  800546:	eb db                	jmp    800523 <putch+0x1f>

00800548 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800548:	55                   	push   %ebp
  800549:	89 e5                	mov    %esp,%ebp
  80054b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800551:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800558:	00 00 00 
	b.cnt = 0;
  80055b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800562:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800565:	ff 75 0c             	pushl  0xc(%ebp)
  800568:	ff 75 08             	pushl  0x8(%ebp)
  80056b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800571:	50                   	push   %eax
  800572:	68 04 05 80 00       	push   $0x800504
  800577:	e8 4a 01 00 00       	call   8006c6 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80057c:	83 c4 08             	add    $0x8,%esp
  80057f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800585:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80058b:	50                   	push   %eax
  80058c:	e8 9d 0a 00 00       	call   80102e <sys_cputs>

	return b.cnt;
}
  800591:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800597:	c9                   	leave  
  800598:	c3                   	ret    

00800599 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800599:	55                   	push   %ebp
  80059a:	89 e5                	mov    %esp,%ebp
  80059c:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80059f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8005a2:	50                   	push   %eax
  8005a3:	ff 75 08             	pushl  0x8(%ebp)
  8005a6:	e8 9d ff ff ff       	call   800548 <vcprintf>
	va_end(ap);

	return cnt;
}
  8005ab:	c9                   	leave  
  8005ac:	c3                   	ret    

008005ad <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005ad:	55                   	push   %ebp
  8005ae:	89 e5                	mov    %esp,%ebp
  8005b0:	57                   	push   %edi
  8005b1:	56                   	push   %esi
  8005b2:	53                   	push   %ebx
  8005b3:	83 ec 1c             	sub    $0x1c,%esp
  8005b6:	89 c6                	mov    %eax,%esi
  8005b8:	89 d7                	mov    %edx,%edi
  8005ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005c3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8005c9:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8005cc:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8005d0:	74 2c                	je     8005fe <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8005d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8005dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005df:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005e2:	39 c2                	cmp    %eax,%edx
  8005e4:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8005e7:	73 43                	jae    80062c <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8005e9:	83 eb 01             	sub    $0x1,%ebx
  8005ec:	85 db                	test   %ebx,%ebx
  8005ee:	7e 6c                	jle    80065c <printnum+0xaf>
				putch(padc, putdat);
  8005f0:	83 ec 08             	sub    $0x8,%esp
  8005f3:	57                   	push   %edi
  8005f4:	ff 75 18             	pushl  0x18(%ebp)
  8005f7:	ff d6                	call   *%esi
  8005f9:	83 c4 10             	add    $0x10,%esp
  8005fc:	eb eb                	jmp    8005e9 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8005fe:	83 ec 0c             	sub    $0xc,%esp
  800601:	6a 20                	push   $0x20
  800603:	6a 00                	push   $0x0
  800605:	50                   	push   %eax
  800606:	ff 75 e4             	pushl  -0x1c(%ebp)
  800609:	ff 75 e0             	pushl  -0x20(%ebp)
  80060c:	89 fa                	mov    %edi,%edx
  80060e:	89 f0                	mov    %esi,%eax
  800610:	e8 98 ff ff ff       	call   8005ad <printnum>
		while (--width > 0)
  800615:	83 c4 20             	add    $0x20,%esp
  800618:	83 eb 01             	sub    $0x1,%ebx
  80061b:	85 db                	test   %ebx,%ebx
  80061d:	7e 65                	jle    800684 <printnum+0xd7>
			putch(padc, putdat);
  80061f:	83 ec 08             	sub    $0x8,%esp
  800622:	57                   	push   %edi
  800623:	6a 20                	push   $0x20
  800625:	ff d6                	call   *%esi
  800627:	83 c4 10             	add    $0x10,%esp
  80062a:	eb ec                	jmp    800618 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80062c:	83 ec 0c             	sub    $0xc,%esp
  80062f:	ff 75 18             	pushl  0x18(%ebp)
  800632:	83 eb 01             	sub    $0x1,%ebx
  800635:	53                   	push   %ebx
  800636:	50                   	push   %eax
  800637:	83 ec 08             	sub    $0x8,%esp
  80063a:	ff 75 dc             	pushl  -0x24(%ebp)
  80063d:	ff 75 d8             	pushl  -0x28(%ebp)
  800640:	ff 75 e4             	pushl  -0x1c(%ebp)
  800643:	ff 75 e0             	pushl  -0x20(%ebp)
  800646:	e8 05 25 00 00       	call   802b50 <__udivdi3>
  80064b:	83 c4 18             	add    $0x18,%esp
  80064e:	52                   	push   %edx
  80064f:	50                   	push   %eax
  800650:	89 fa                	mov    %edi,%edx
  800652:	89 f0                	mov    %esi,%eax
  800654:	e8 54 ff ff ff       	call   8005ad <printnum>
  800659:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80065c:	83 ec 08             	sub    $0x8,%esp
  80065f:	57                   	push   %edi
  800660:	83 ec 04             	sub    $0x4,%esp
  800663:	ff 75 dc             	pushl  -0x24(%ebp)
  800666:	ff 75 d8             	pushl  -0x28(%ebp)
  800669:	ff 75 e4             	pushl  -0x1c(%ebp)
  80066c:	ff 75 e0             	pushl  -0x20(%ebp)
  80066f:	e8 ec 25 00 00       	call   802c60 <__umoddi3>
  800674:	83 c4 14             	add    $0x14,%esp
  800677:	0f be 80 73 2f 80 00 	movsbl 0x802f73(%eax),%eax
  80067e:	50                   	push   %eax
  80067f:	ff d6                	call   *%esi
  800681:	83 c4 10             	add    $0x10,%esp
	}
}
  800684:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800687:	5b                   	pop    %ebx
  800688:	5e                   	pop    %esi
  800689:	5f                   	pop    %edi
  80068a:	5d                   	pop    %ebp
  80068b:	c3                   	ret    

0080068c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80068c:	55                   	push   %ebp
  80068d:	89 e5                	mov    %esp,%ebp
  80068f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800692:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800696:	8b 10                	mov    (%eax),%edx
  800698:	3b 50 04             	cmp    0x4(%eax),%edx
  80069b:	73 0a                	jae    8006a7 <sprintputch+0x1b>
		*b->buf++ = ch;
  80069d:	8d 4a 01             	lea    0x1(%edx),%ecx
  8006a0:	89 08                	mov    %ecx,(%eax)
  8006a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a5:	88 02                	mov    %al,(%edx)
}
  8006a7:	5d                   	pop    %ebp
  8006a8:	c3                   	ret    

008006a9 <printfmt>:
{
  8006a9:	55                   	push   %ebp
  8006aa:	89 e5                	mov    %esp,%ebp
  8006ac:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8006af:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8006b2:	50                   	push   %eax
  8006b3:	ff 75 10             	pushl  0x10(%ebp)
  8006b6:	ff 75 0c             	pushl  0xc(%ebp)
  8006b9:	ff 75 08             	pushl  0x8(%ebp)
  8006bc:	e8 05 00 00 00       	call   8006c6 <vprintfmt>
}
  8006c1:	83 c4 10             	add    $0x10,%esp
  8006c4:	c9                   	leave  
  8006c5:	c3                   	ret    

008006c6 <vprintfmt>:
{
  8006c6:	55                   	push   %ebp
  8006c7:	89 e5                	mov    %esp,%ebp
  8006c9:	57                   	push   %edi
  8006ca:	56                   	push   %esi
  8006cb:	53                   	push   %ebx
  8006cc:	83 ec 3c             	sub    $0x3c,%esp
  8006cf:	8b 75 08             	mov    0x8(%ebp),%esi
  8006d2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006d5:	8b 7d 10             	mov    0x10(%ebp),%edi
  8006d8:	e9 32 04 00 00       	jmp    800b0f <vprintfmt+0x449>
		padc = ' ';
  8006dd:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8006e1:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8006e8:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8006ef:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8006f6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8006fd:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800704:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800709:	8d 47 01             	lea    0x1(%edi),%eax
  80070c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80070f:	0f b6 17             	movzbl (%edi),%edx
  800712:	8d 42 dd             	lea    -0x23(%edx),%eax
  800715:	3c 55                	cmp    $0x55,%al
  800717:	0f 87 12 05 00 00    	ja     800c2f <vprintfmt+0x569>
  80071d:	0f b6 c0             	movzbl %al,%eax
  800720:	ff 24 85 60 31 80 00 	jmp    *0x803160(,%eax,4)
  800727:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80072a:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80072e:	eb d9                	jmp    800709 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800730:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800733:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800737:	eb d0                	jmp    800709 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800739:	0f b6 d2             	movzbl %dl,%edx
  80073c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80073f:	b8 00 00 00 00       	mov    $0x0,%eax
  800744:	89 75 08             	mov    %esi,0x8(%ebp)
  800747:	eb 03                	jmp    80074c <vprintfmt+0x86>
  800749:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80074c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80074f:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800753:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800756:	8d 72 d0             	lea    -0x30(%edx),%esi
  800759:	83 fe 09             	cmp    $0x9,%esi
  80075c:	76 eb                	jbe    800749 <vprintfmt+0x83>
  80075e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800761:	8b 75 08             	mov    0x8(%ebp),%esi
  800764:	eb 14                	jmp    80077a <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800766:	8b 45 14             	mov    0x14(%ebp),%eax
  800769:	8b 00                	mov    (%eax),%eax
  80076b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076e:	8b 45 14             	mov    0x14(%ebp),%eax
  800771:	8d 40 04             	lea    0x4(%eax),%eax
  800774:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800777:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80077a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80077e:	79 89                	jns    800709 <vprintfmt+0x43>
				width = precision, precision = -1;
  800780:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800783:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800786:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80078d:	e9 77 ff ff ff       	jmp    800709 <vprintfmt+0x43>
  800792:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800795:	85 c0                	test   %eax,%eax
  800797:	0f 48 c1             	cmovs  %ecx,%eax
  80079a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80079d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8007a0:	e9 64 ff ff ff       	jmp    800709 <vprintfmt+0x43>
  8007a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8007a8:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8007af:	e9 55 ff ff ff       	jmp    800709 <vprintfmt+0x43>
			lflag++;
  8007b4:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8007b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8007bb:	e9 49 ff ff ff       	jmp    800709 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8007c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c3:	8d 78 04             	lea    0x4(%eax),%edi
  8007c6:	83 ec 08             	sub    $0x8,%esp
  8007c9:	53                   	push   %ebx
  8007ca:	ff 30                	pushl  (%eax)
  8007cc:	ff d6                	call   *%esi
			break;
  8007ce:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8007d1:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8007d4:	e9 33 03 00 00       	jmp    800b0c <vprintfmt+0x446>
			err = va_arg(ap, int);
  8007d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dc:	8d 78 04             	lea    0x4(%eax),%edi
  8007df:	8b 00                	mov    (%eax),%eax
  8007e1:	99                   	cltd   
  8007e2:	31 d0                	xor    %edx,%eax
  8007e4:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8007e6:	83 f8 11             	cmp    $0x11,%eax
  8007e9:	7f 23                	jg     80080e <vprintfmt+0x148>
  8007eb:	8b 14 85 c0 32 80 00 	mov    0x8032c0(,%eax,4),%edx
  8007f2:	85 d2                	test   %edx,%edx
  8007f4:	74 18                	je     80080e <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8007f6:	52                   	push   %edx
  8007f7:	68 dd 33 80 00       	push   $0x8033dd
  8007fc:	53                   	push   %ebx
  8007fd:	56                   	push   %esi
  8007fe:	e8 a6 fe ff ff       	call   8006a9 <printfmt>
  800803:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800806:	89 7d 14             	mov    %edi,0x14(%ebp)
  800809:	e9 fe 02 00 00       	jmp    800b0c <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80080e:	50                   	push   %eax
  80080f:	68 8b 2f 80 00       	push   $0x802f8b
  800814:	53                   	push   %ebx
  800815:	56                   	push   %esi
  800816:	e8 8e fe ff ff       	call   8006a9 <printfmt>
  80081b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80081e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800821:	e9 e6 02 00 00       	jmp    800b0c <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800826:	8b 45 14             	mov    0x14(%ebp),%eax
  800829:	83 c0 04             	add    $0x4,%eax
  80082c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80082f:	8b 45 14             	mov    0x14(%ebp),%eax
  800832:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800834:	85 c9                	test   %ecx,%ecx
  800836:	b8 84 2f 80 00       	mov    $0x802f84,%eax
  80083b:	0f 45 c1             	cmovne %ecx,%eax
  80083e:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800841:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800845:	7e 06                	jle    80084d <vprintfmt+0x187>
  800847:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80084b:	75 0d                	jne    80085a <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80084d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800850:	89 c7                	mov    %eax,%edi
  800852:	03 45 e0             	add    -0x20(%ebp),%eax
  800855:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800858:	eb 53                	jmp    8008ad <vprintfmt+0x1e7>
  80085a:	83 ec 08             	sub    $0x8,%esp
  80085d:	ff 75 d8             	pushl  -0x28(%ebp)
  800860:	50                   	push   %eax
  800861:	e8 71 04 00 00       	call   800cd7 <strnlen>
  800866:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800869:	29 c1                	sub    %eax,%ecx
  80086b:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80086e:	83 c4 10             	add    $0x10,%esp
  800871:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800873:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800877:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80087a:	eb 0f                	jmp    80088b <vprintfmt+0x1c5>
					putch(padc, putdat);
  80087c:	83 ec 08             	sub    $0x8,%esp
  80087f:	53                   	push   %ebx
  800880:	ff 75 e0             	pushl  -0x20(%ebp)
  800883:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800885:	83 ef 01             	sub    $0x1,%edi
  800888:	83 c4 10             	add    $0x10,%esp
  80088b:	85 ff                	test   %edi,%edi
  80088d:	7f ed                	jg     80087c <vprintfmt+0x1b6>
  80088f:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800892:	85 c9                	test   %ecx,%ecx
  800894:	b8 00 00 00 00       	mov    $0x0,%eax
  800899:	0f 49 c1             	cmovns %ecx,%eax
  80089c:	29 c1                	sub    %eax,%ecx
  80089e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8008a1:	eb aa                	jmp    80084d <vprintfmt+0x187>
					putch(ch, putdat);
  8008a3:	83 ec 08             	sub    $0x8,%esp
  8008a6:	53                   	push   %ebx
  8008a7:	52                   	push   %edx
  8008a8:	ff d6                	call   *%esi
  8008aa:	83 c4 10             	add    $0x10,%esp
  8008ad:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8008b0:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008b2:	83 c7 01             	add    $0x1,%edi
  8008b5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008b9:	0f be d0             	movsbl %al,%edx
  8008bc:	85 d2                	test   %edx,%edx
  8008be:	74 4b                	je     80090b <vprintfmt+0x245>
  8008c0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8008c4:	78 06                	js     8008cc <vprintfmt+0x206>
  8008c6:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8008ca:	78 1e                	js     8008ea <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8008cc:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8008d0:	74 d1                	je     8008a3 <vprintfmt+0x1dd>
  8008d2:	0f be c0             	movsbl %al,%eax
  8008d5:	83 e8 20             	sub    $0x20,%eax
  8008d8:	83 f8 5e             	cmp    $0x5e,%eax
  8008db:	76 c6                	jbe    8008a3 <vprintfmt+0x1dd>
					putch('?', putdat);
  8008dd:	83 ec 08             	sub    $0x8,%esp
  8008e0:	53                   	push   %ebx
  8008e1:	6a 3f                	push   $0x3f
  8008e3:	ff d6                	call   *%esi
  8008e5:	83 c4 10             	add    $0x10,%esp
  8008e8:	eb c3                	jmp    8008ad <vprintfmt+0x1e7>
  8008ea:	89 cf                	mov    %ecx,%edi
  8008ec:	eb 0e                	jmp    8008fc <vprintfmt+0x236>
				putch(' ', putdat);
  8008ee:	83 ec 08             	sub    $0x8,%esp
  8008f1:	53                   	push   %ebx
  8008f2:	6a 20                	push   $0x20
  8008f4:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8008f6:	83 ef 01             	sub    $0x1,%edi
  8008f9:	83 c4 10             	add    $0x10,%esp
  8008fc:	85 ff                	test   %edi,%edi
  8008fe:	7f ee                	jg     8008ee <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800900:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800903:	89 45 14             	mov    %eax,0x14(%ebp)
  800906:	e9 01 02 00 00       	jmp    800b0c <vprintfmt+0x446>
  80090b:	89 cf                	mov    %ecx,%edi
  80090d:	eb ed                	jmp    8008fc <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80090f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800912:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800919:	e9 eb fd ff ff       	jmp    800709 <vprintfmt+0x43>
	if (lflag >= 2)
  80091e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800922:	7f 21                	jg     800945 <vprintfmt+0x27f>
	else if (lflag)
  800924:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800928:	74 68                	je     800992 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80092a:	8b 45 14             	mov    0x14(%ebp),%eax
  80092d:	8b 00                	mov    (%eax),%eax
  80092f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800932:	89 c1                	mov    %eax,%ecx
  800934:	c1 f9 1f             	sar    $0x1f,%ecx
  800937:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80093a:	8b 45 14             	mov    0x14(%ebp),%eax
  80093d:	8d 40 04             	lea    0x4(%eax),%eax
  800940:	89 45 14             	mov    %eax,0x14(%ebp)
  800943:	eb 17                	jmp    80095c <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800945:	8b 45 14             	mov    0x14(%ebp),%eax
  800948:	8b 50 04             	mov    0x4(%eax),%edx
  80094b:	8b 00                	mov    (%eax),%eax
  80094d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800950:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800953:	8b 45 14             	mov    0x14(%ebp),%eax
  800956:	8d 40 08             	lea    0x8(%eax),%eax
  800959:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80095c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80095f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800962:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800965:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800968:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80096c:	78 3f                	js     8009ad <vprintfmt+0x2e7>
			base = 10;
  80096e:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800973:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800977:	0f 84 71 01 00 00    	je     800aee <vprintfmt+0x428>
				putch('+', putdat);
  80097d:	83 ec 08             	sub    $0x8,%esp
  800980:	53                   	push   %ebx
  800981:	6a 2b                	push   $0x2b
  800983:	ff d6                	call   *%esi
  800985:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800988:	b8 0a 00 00 00       	mov    $0xa,%eax
  80098d:	e9 5c 01 00 00       	jmp    800aee <vprintfmt+0x428>
		return va_arg(*ap, int);
  800992:	8b 45 14             	mov    0x14(%ebp),%eax
  800995:	8b 00                	mov    (%eax),%eax
  800997:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80099a:	89 c1                	mov    %eax,%ecx
  80099c:	c1 f9 1f             	sar    $0x1f,%ecx
  80099f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8009a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a5:	8d 40 04             	lea    0x4(%eax),%eax
  8009a8:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ab:	eb af                	jmp    80095c <vprintfmt+0x296>
				putch('-', putdat);
  8009ad:	83 ec 08             	sub    $0x8,%esp
  8009b0:	53                   	push   %ebx
  8009b1:	6a 2d                	push   $0x2d
  8009b3:	ff d6                	call   *%esi
				num = -(long long) num;
  8009b5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8009b8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8009bb:	f7 d8                	neg    %eax
  8009bd:	83 d2 00             	adc    $0x0,%edx
  8009c0:	f7 da                	neg    %edx
  8009c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009c5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009c8:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8009cb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009d0:	e9 19 01 00 00       	jmp    800aee <vprintfmt+0x428>
	if (lflag >= 2)
  8009d5:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8009d9:	7f 29                	jg     800a04 <vprintfmt+0x33e>
	else if (lflag)
  8009db:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8009df:	74 44                	je     800a25 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8009e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e4:	8b 00                	mov    (%eax),%eax
  8009e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8009eb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009ee:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f4:	8d 40 04             	lea    0x4(%eax),%eax
  8009f7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009fa:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009ff:	e9 ea 00 00 00       	jmp    800aee <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800a04:	8b 45 14             	mov    0x14(%ebp),%eax
  800a07:	8b 50 04             	mov    0x4(%eax),%edx
  800a0a:	8b 00                	mov    (%eax),%eax
  800a0c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a0f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a12:	8b 45 14             	mov    0x14(%ebp),%eax
  800a15:	8d 40 08             	lea    0x8(%eax),%eax
  800a18:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a1b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a20:	e9 c9 00 00 00       	jmp    800aee <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800a25:	8b 45 14             	mov    0x14(%ebp),%eax
  800a28:	8b 00                	mov    (%eax),%eax
  800a2a:	ba 00 00 00 00       	mov    $0x0,%edx
  800a2f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a32:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a35:	8b 45 14             	mov    0x14(%ebp),%eax
  800a38:	8d 40 04             	lea    0x4(%eax),%eax
  800a3b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a3e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a43:	e9 a6 00 00 00       	jmp    800aee <vprintfmt+0x428>
			putch('0', putdat);
  800a48:	83 ec 08             	sub    $0x8,%esp
  800a4b:	53                   	push   %ebx
  800a4c:	6a 30                	push   $0x30
  800a4e:	ff d6                	call   *%esi
	if (lflag >= 2)
  800a50:	83 c4 10             	add    $0x10,%esp
  800a53:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800a57:	7f 26                	jg     800a7f <vprintfmt+0x3b9>
	else if (lflag)
  800a59:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a5d:	74 3e                	je     800a9d <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800a5f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a62:	8b 00                	mov    (%eax),%eax
  800a64:	ba 00 00 00 00       	mov    $0x0,%edx
  800a69:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a6c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a72:	8d 40 04             	lea    0x4(%eax),%eax
  800a75:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a78:	b8 08 00 00 00       	mov    $0x8,%eax
  800a7d:	eb 6f                	jmp    800aee <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800a7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a82:	8b 50 04             	mov    0x4(%eax),%edx
  800a85:	8b 00                	mov    (%eax),%eax
  800a87:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a8a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a90:	8d 40 08             	lea    0x8(%eax),%eax
  800a93:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a96:	b8 08 00 00 00       	mov    $0x8,%eax
  800a9b:	eb 51                	jmp    800aee <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800a9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa0:	8b 00                	mov    (%eax),%eax
  800aa2:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aaa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800aad:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab0:	8d 40 04             	lea    0x4(%eax),%eax
  800ab3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800ab6:	b8 08 00 00 00       	mov    $0x8,%eax
  800abb:	eb 31                	jmp    800aee <vprintfmt+0x428>
			putch('0', putdat);
  800abd:	83 ec 08             	sub    $0x8,%esp
  800ac0:	53                   	push   %ebx
  800ac1:	6a 30                	push   $0x30
  800ac3:	ff d6                	call   *%esi
			putch('x', putdat);
  800ac5:	83 c4 08             	add    $0x8,%esp
  800ac8:	53                   	push   %ebx
  800ac9:	6a 78                	push   $0x78
  800acb:	ff d6                	call   *%esi
			num = (unsigned long long)
  800acd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad0:	8b 00                	mov    (%eax),%eax
  800ad2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ad7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ada:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800add:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800ae0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae3:	8d 40 04             	lea    0x4(%eax),%eax
  800ae6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ae9:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800aee:	83 ec 0c             	sub    $0xc,%esp
  800af1:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800af5:	52                   	push   %edx
  800af6:	ff 75 e0             	pushl  -0x20(%ebp)
  800af9:	50                   	push   %eax
  800afa:	ff 75 dc             	pushl  -0x24(%ebp)
  800afd:	ff 75 d8             	pushl  -0x28(%ebp)
  800b00:	89 da                	mov    %ebx,%edx
  800b02:	89 f0                	mov    %esi,%eax
  800b04:	e8 a4 fa ff ff       	call   8005ad <printnum>
			break;
  800b09:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800b0c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b0f:	83 c7 01             	add    $0x1,%edi
  800b12:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800b16:	83 f8 25             	cmp    $0x25,%eax
  800b19:	0f 84 be fb ff ff    	je     8006dd <vprintfmt+0x17>
			if (ch == '\0')
  800b1f:	85 c0                	test   %eax,%eax
  800b21:	0f 84 28 01 00 00    	je     800c4f <vprintfmt+0x589>
			putch(ch, putdat);
  800b27:	83 ec 08             	sub    $0x8,%esp
  800b2a:	53                   	push   %ebx
  800b2b:	50                   	push   %eax
  800b2c:	ff d6                	call   *%esi
  800b2e:	83 c4 10             	add    $0x10,%esp
  800b31:	eb dc                	jmp    800b0f <vprintfmt+0x449>
	if (lflag >= 2)
  800b33:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800b37:	7f 26                	jg     800b5f <vprintfmt+0x499>
	else if (lflag)
  800b39:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800b3d:	74 41                	je     800b80 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800b3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b42:	8b 00                	mov    (%eax),%eax
  800b44:	ba 00 00 00 00       	mov    $0x0,%edx
  800b49:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b4c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b52:	8d 40 04             	lea    0x4(%eax),%eax
  800b55:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b58:	b8 10 00 00 00       	mov    $0x10,%eax
  800b5d:	eb 8f                	jmp    800aee <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800b5f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b62:	8b 50 04             	mov    0x4(%eax),%edx
  800b65:	8b 00                	mov    (%eax),%eax
  800b67:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b6a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b70:	8d 40 08             	lea    0x8(%eax),%eax
  800b73:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b76:	b8 10 00 00 00       	mov    $0x10,%eax
  800b7b:	e9 6e ff ff ff       	jmp    800aee <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800b80:	8b 45 14             	mov    0x14(%ebp),%eax
  800b83:	8b 00                	mov    (%eax),%eax
  800b85:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b8d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b90:	8b 45 14             	mov    0x14(%ebp),%eax
  800b93:	8d 40 04             	lea    0x4(%eax),%eax
  800b96:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b99:	b8 10 00 00 00       	mov    $0x10,%eax
  800b9e:	e9 4b ff ff ff       	jmp    800aee <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800ba3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba6:	83 c0 04             	add    $0x4,%eax
  800ba9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bac:	8b 45 14             	mov    0x14(%ebp),%eax
  800baf:	8b 00                	mov    (%eax),%eax
  800bb1:	85 c0                	test   %eax,%eax
  800bb3:	74 14                	je     800bc9 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800bb5:	8b 13                	mov    (%ebx),%edx
  800bb7:	83 fa 7f             	cmp    $0x7f,%edx
  800bba:	7f 37                	jg     800bf3 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800bbc:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800bbe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800bc1:	89 45 14             	mov    %eax,0x14(%ebp)
  800bc4:	e9 43 ff ff ff       	jmp    800b0c <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800bc9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bce:	bf a9 30 80 00       	mov    $0x8030a9,%edi
							putch(ch, putdat);
  800bd3:	83 ec 08             	sub    $0x8,%esp
  800bd6:	53                   	push   %ebx
  800bd7:	50                   	push   %eax
  800bd8:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800bda:	83 c7 01             	add    $0x1,%edi
  800bdd:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800be1:	83 c4 10             	add    $0x10,%esp
  800be4:	85 c0                	test   %eax,%eax
  800be6:	75 eb                	jne    800bd3 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800be8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800beb:	89 45 14             	mov    %eax,0x14(%ebp)
  800bee:	e9 19 ff ff ff       	jmp    800b0c <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800bf3:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800bf5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bfa:	bf e1 30 80 00       	mov    $0x8030e1,%edi
							putch(ch, putdat);
  800bff:	83 ec 08             	sub    $0x8,%esp
  800c02:	53                   	push   %ebx
  800c03:	50                   	push   %eax
  800c04:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800c06:	83 c7 01             	add    $0x1,%edi
  800c09:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800c0d:	83 c4 10             	add    $0x10,%esp
  800c10:	85 c0                	test   %eax,%eax
  800c12:	75 eb                	jne    800bff <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800c14:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c17:	89 45 14             	mov    %eax,0x14(%ebp)
  800c1a:	e9 ed fe ff ff       	jmp    800b0c <vprintfmt+0x446>
			putch(ch, putdat);
  800c1f:	83 ec 08             	sub    $0x8,%esp
  800c22:	53                   	push   %ebx
  800c23:	6a 25                	push   $0x25
  800c25:	ff d6                	call   *%esi
			break;
  800c27:	83 c4 10             	add    $0x10,%esp
  800c2a:	e9 dd fe ff ff       	jmp    800b0c <vprintfmt+0x446>
			putch('%', putdat);
  800c2f:	83 ec 08             	sub    $0x8,%esp
  800c32:	53                   	push   %ebx
  800c33:	6a 25                	push   $0x25
  800c35:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c37:	83 c4 10             	add    $0x10,%esp
  800c3a:	89 f8                	mov    %edi,%eax
  800c3c:	eb 03                	jmp    800c41 <vprintfmt+0x57b>
  800c3e:	83 e8 01             	sub    $0x1,%eax
  800c41:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800c45:	75 f7                	jne    800c3e <vprintfmt+0x578>
  800c47:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c4a:	e9 bd fe ff ff       	jmp    800b0c <vprintfmt+0x446>
}
  800c4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c52:	5b                   	pop    %ebx
  800c53:	5e                   	pop    %esi
  800c54:	5f                   	pop    %edi
  800c55:	5d                   	pop    %ebp
  800c56:	c3                   	ret    

00800c57 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	83 ec 18             	sub    $0x18,%esp
  800c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c60:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c63:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c66:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800c6a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800c6d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c74:	85 c0                	test   %eax,%eax
  800c76:	74 26                	je     800c9e <vsnprintf+0x47>
  800c78:	85 d2                	test   %edx,%edx
  800c7a:	7e 22                	jle    800c9e <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c7c:	ff 75 14             	pushl  0x14(%ebp)
  800c7f:	ff 75 10             	pushl  0x10(%ebp)
  800c82:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c85:	50                   	push   %eax
  800c86:	68 8c 06 80 00       	push   $0x80068c
  800c8b:	e8 36 fa ff ff       	call   8006c6 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c93:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c99:	83 c4 10             	add    $0x10,%esp
}
  800c9c:	c9                   	leave  
  800c9d:	c3                   	ret    
		return -E_INVAL;
  800c9e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ca3:	eb f7                	jmp    800c9c <vsnprintf+0x45>

00800ca5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ca5:	55                   	push   %ebp
  800ca6:	89 e5                	mov    %esp,%ebp
  800ca8:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cab:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800cae:	50                   	push   %eax
  800caf:	ff 75 10             	pushl  0x10(%ebp)
  800cb2:	ff 75 0c             	pushl  0xc(%ebp)
  800cb5:	ff 75 08             	pushl  0x8(%ebp)
  800cb8:	e8 9a ff ff ff       	call   800c57 <vsnprintf>
	va_end(ap);

	return rc;
}
  800cbd:	c9                   	leave  
  800cbe:	c3                   	ret    

00800cbf <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800cbf:	55                   	push   %ebp
  800cc0:	89 e5                	mov    %esp,%ebp
  800cc2:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800cc5:	b8 00 00 00 00       	mov    $0x0,%eax
  800cca:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800cce:	74 05                	je     800cd5 <strlen+0x16>
		n++;
  800cd0:	83 c0 01             	add    $0x1,%eax
  800cd3:	eb f5                	jmp    800cca <strlen+0xb>
	return n;
}
  800cd5:	5d                   	pop    %ebp
  800cd6:	c3                   	ret    

00800cd7 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ce0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce5:	39 c2                	cmp    %eax,%edx
  800ce7:	74 0d                	je     800cf6 <strnlen+0x1f>
  800ce9:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800ced:	74 05                	je     800cf4 <strnlen+0x1d>
		n++;
  800cef:	83 c2 01             	add    $0x1,%edx
  800cf2:	eb f1                	jmp    800ce5 <strnlen+0xe>
  800cf4:	89 d0                	mov    %edx,%eax
	return n;
}
  800cf6:	5d                   	pop    %ebp
  800cf7:	c3                   	ret    

00800cf8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
  800cfb:	53                   	push   %ebx
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800d02:	ba 00 00 00 00       	mov    $0x0,%edx
  800d07:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800d0b:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800d0e:	83 c2 01             	add    $0x1,%edx
  800d11:	84 c9                	test   %cl,%cl
  800d13:	75 f2                	jne    800d07 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800d15:	5b                   	pop    %ebx
  800d16:	5d                   	pop    %ebp
  800d17:	c3                   	ret    

00800d18 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800d18:	55                   	push   %ebp
  800d19:	89 e5                	mov    %esp,%ebp
  800d1b:	53                   	push   %ebx
  800d1c:	83 ec 10             	sub    $0x10,%esp
  800d1f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800d22:	53                   	push   %ebx
  800d23:	e8 97 ff ff ff       	call   800cbf <strlen>
  800d28:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800d2b:	ff 75 0c             	pushl  0xc(%ebp)
  800d2e:	01 d8                	add    %ebx,%eax
  800d30:	50                   	push   %eax
  800d31:	e8 c2 ff ff ff       	call   800cf8 <strcpy>
	return dst;
}
  800d36:	89 d8                	mov    %ebx,%eax
  800d38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d3b:	c9                   	leave  
  800d3c:	c3                   	ret    

00800d3d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
  800d40:	56                   	push   %esi
  800d41:	53                   	push   %ebx
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d48:	89 c6                	mov    %eax,%esi
  800d4a:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d4d:	89 c2                	mov    %eax,%edx
  800d4f:	39 f2                	cmp    %esi,%edx
  800d51:	74 11                	je     800d64 <strncpy+0x27>
		*dst++ = *src;
  800d53:	83 c2 01             	add    $0x1,%edx
  800d56:	0f b6 19             	movzbl (%ecx),%ebx
  800d59:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800d5c:	80 fb 01             	cmp    $0x1,%bl
  800d5f:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800d62:	eb eb                	jmp    800d4f <strncpy+0x12>
	}
	return ret;
}
  800d64:	5b                   	pop    %ebx
  800d65:	5e                   	pop    %esi
  800d66:	5d                   	pop    %ebp
  800d67:	c3                   	ret    

00800d68 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
  800d6b:	56                   	push   %esi
  800d6c:	53                   	push   %ebx
  800d6d:	8b 75 08             	mov    0x8(%ebp),%esi
  800d70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d73:	8b 55 10             	mov    0x10(%ebp),%edx
  800d76:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800d78:	85 d2                	test   %edx,%edx
  800d7a:	74 21                	je     800d9d <strlcpy+0x35>
  800d7c:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800d80:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800d82:	39 c2                	cmp    %eax,%edx
  800d84:	74 14                	je     800d9a <strlcpy+0x32>
  800d86:	0f b6 19             	movzbl (%ecx),%ebx
  800d89:	84 db                	test   %bl,%bl
  800d8b:	74 0b                	je     800d98 <strlcpy+0x30>
			*dst++ = *src++;
  800d8d:	83 c1 01             	add    $0x1,%ecx
  800d90:	83 c2 01             	add    $0x1,%edx
  800d93:	88 5a ff             	mov    %bl,-0x1(%edx)
  800d96:	eb ea                	jmp    800d82 <strlcpy+0x1a>
  800d98:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800d9a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d9d:	29 f0                	sub    %esi,%eax
}
  800d9f:	5b                   	pop    %ebx
  800da0:	5e                   	pop    %esi
  800da1:	5d                   	pop    %ebp
  800da2:	c3                   	ret    

00800da3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800da9:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800dac:	0f b6 01             	movzbl (%ecx),%eax
  800daf:	84 c0                	test   %al,%al
  800db1:	74 0c                	je     800dbf <strcmp+0x1c>
  800db3:	3a 02                	cmp    (%edx),%al
  800db5:	75 08                	jne    800dbf <strcmp+0x1c>
		p++, q++;
  800db7:	83 c1 01             	add    $0x1,%ecx
  800dba:	83 c2 01             	add    $0x1,%edx
  800dbd:	eb ed                	jmp    800dac <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dbf:	0f b6 c0             	movzbl %al,%eax
  800dc2:	0f b6 12             	movzbl (%edx),%edx
  800dc5:	29 d0                	sub    %edx,%eax
}
  800dc7:	5d                   	pop    %ebp
  800dc8:	c3                   	ret    

00800dc9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800dc9:	55                   	push   %ebp
  800dca:	89 e5                	mov    %esp,%ebp
  800dcc:	53                   	push   %ebx
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd3:	89 c3                	mov    %eax,%ebx
  800dd5:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800dd8:	eb 06                	jmp    800de0 <strncmp+0x17>
		n--, p++, q++;
  800dda:	83 c0 01             	add    $0x1,%eax
  800ddd:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800de0:	39 d8                	cmp    %ebx,%eax
  800de2:	74 16                	je     800dfa <strncmp+0x31>
  800de4:	0f b6 08             	movzbl (%eax),%ecx
  800de7:	84 c9                	test   %cl,%cl
  800de9:	74 04                	je     800def <strncmp+0x26>
  800deb:	3a 0a                	cmp    (%edx),%cl
  800ded:	74 eb                	je     800dda <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800def:	0f b6 00             	movzbl (%eax),%eax
  800df2:	0f b6 12             	movzbl (%edx),%edx
  800df5:	29 d0                	sub    %edx,%eax
}
  800df7:	5b                   	pop    %ebx
  800df8:	5d                   	pop    %ebp
  800df9:	c3                   	ret    
		return 0;
  800dfa:	b8 00 00 00 00       	mov    $0x0,%eax
  800dff:	eb f6                	jmp    800df7 <strncmp+0x2e>

00800e01 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e01:	55                   	push   %ebp
  800e02:	89 e5                	mov    %esp,%ebp
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e0b:	0f b6 10             	movzbl (%eax),%edx
  800e0e:	84 d2                	test   %dl,%dl
  800e10:	74 09                	je     800e1b <strchr+0x1a>
		if (*s == c)
  800e12:	38 ca                	cmp    %cl,%dl
  800e14:	74 0a                	je     800e20 <strchr+0x1f>
	for (; *s; s++)
  800e16:	83 c0 01             	add    $0x1,%eax
  800e19:	eb f0                	jmp    800e0b <strchr+0xa>
			return (char *) s;
	return 0;
  800e1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e20:	5d                   	pop    %ebp
  800e21:	c3                   	ret    

00800e22 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e2c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800e2f:	38 ca                	cmp    %cl,%dl
  800e31:	74 09                	je     800e3c <strfind+0x1a>
  800e33:	84 d2                	test   %dl,%dl
  800e35:	74 05                	je     800e3c <strfind+0x1a>
	for (; *s; s++)
  800e37:	83 c0 01             	add    $0x1,%eax
  800e3a:	eb f0                	jmp    800e2c <strfind+0xa>
			break;
	return (char *) s;
}
  800e3c:	5d                   	pop    %ebp
  800e3d:	c3                   	ret    

00800e3e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800e3e:	55                   	push   %ebp
  800e3f:	89 e5                	mov    %esp,%ebp
  800e41:	57                   	push   %edi
  800e42:	56                   	push   %esi
  800e43:	53                   	push   %ebx
  800e44:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e47:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800e4a:	85 c9                	test   %ecx,%ecx
  800e4c:	74 31                	je     800e7f <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e4e:	89 f8                	mov    %edi,%eax
  800e50:	09 c8                	or     %ecx,%eax
  800e52:	a8 03                	test   $0x3,%al
  800e54:	75 23                	jne    800e79 <memset+0x3b>
		c &= 0xFF;
  800e56:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800e5a:	89 d3                	mov    %edx,%ebx
  800e5c:	c1 e3 08             	shl    $0x8,%ebx
  800e5f:	89 d0                	mov    %edx,%eax
  800e61:	c1 e0 18             	shl    $0x18,%eax
  800e64:	89 d6                	mov    %edx,%esi
  800e66:	c1 e6 10             	shl    $0x10,%esi
  800e69:	09 f0                	or     %esi,%eax
  800e6b:	09 c2                	or     %eax,%edx
  800e6d:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800e6f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800e72:	89 d0                	mov    %edx,%eax
  800e74:	fc                   	cld    
  800e75:	f3 ab                	rep stos %eax,%es:(%edi)
  800e77:	eb 06                	jmp    800e7f <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800e79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7c:	fc                   	cld    
  800e7d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800e7f:	89 f8                	mov    %edi,%eax
  800e81:	5b                   	pop    %ebx
  800e82:	5e                   	pop    %esi
  800e83:	5f                   	pop    %edi
  800e84:	5d                   	pop    %ebp
  800e85:	c3                   	ret    

00800e86 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800e86:	55                   	push   %ebp
  800e87:	89 e5                	mov    %esp,%ebp
  800e89:	57                   	push   %edi
  800e8a:	56                   	push   %esi
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e91:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e94:	39 c6                	cmp    %eax,%esi
  800e96:	73 32                	jae    800eca <memmove+0x44>
  800e98:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800e9b:	39 c2                	cmp    %eax,%edx
  800e9d:	76 2b                	jbe    800eca <memmove+0x44>
		s += n;
		d += n;
  800e9f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ea2:	89 fe                	mov    %edi,%esi
  800ea4:	09 ce                	or     %ecx,%esi
  800ea6:	09 d6                	or     %edx,%esi
  800ea8:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800eae:	75 0e                	jne    800ebe <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800eb0:	83 ef 04             	sub    $0x4,%edi
  800eb3:	8d 72 fc             	lea    -0x4(%edx),%esi
  800eb6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800eb9:	fd                   	std    
  800eba:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ebc:	eb 09                	jmp    800ec7 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ebe:	83 ef 01             	sub    $0x1,%edi
  800ec1:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ec4:	fd                   	std    
  800ec5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ec7:	fc                   	cld    
  800ec8:	eb 1a                	jmp    800ee4 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800eca:	89 c2                	mov    %eax,%edx
  800ecc:	09 ca                	or     %ecx,%edx
  800ece:	09 f2                	or     %esi,%edx
  800ed0:	f6 c2 03             	test   $0x3,%dl
  800ed3:	75 0a                	jne    800edf <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ed5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ed8:	89 c7                	mov    %eax,%edi
  800eda:	fc                   	cld    
  800edb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800edd:	eb 05                	jmp    800ee4 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800edf:	89 c7                	mov    %eax,%edi
  800ee1:	fc                   	cld    
  800ee2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ee4:	5e                   	pop    %esi
  800ee5:	5f                   	pop    %edi
  800ee6:	5d                   	pop    %ebp
  800ee7:	c3                   	ret    

00800ee8 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ee8:	55                   	push   %ebp
  800ee9:	89 e5                	mov    %esp,%ebp
  800eeb:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800eee:	ff 75 10             	pushl  0x10(%ebp)
  800ef1:	ff 75 0c             	pushl  0xc(%ebp)
  800ef4:	ff 75 08             	pushl  0x8(%ebp)
  800ef7:	e8 8a ff ff ff       	call   800e86 <memmove>
}
  800efc:	c9                   	leave  
  800efd:	c3                   	ret    

00800efe <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800efe:	55                   	push   %ebp
  800eff:	89 e5                	mov    %esp,%ebp
  800f01:	56                   	push   %esi
  800f02:	53                   	push   %ebx
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f09:	89 c6                	mov    %eax,%esi
  800f0b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f0e:	39 f0                	cmp    %esi,%eax
  800f10:	74 1c                	je     800f2e <memcmp+0x30>
		if (*s1 != *s2)
  800f12:	0f b6 08             	movzbl (%eax),%ecx
  800f15:	0f b6 1a             	movzbl (%edx),%ebx
  800f18:	38 d9                	cmp    %bl,%cl
  800f1a:	75 08                	jne    800f24 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800f1c:	83 c0 01             	add    $0x1,%eax
  800f1f:	83 c2 01             	add    $0x1,%edx
  800f22:	eb ea                	jmp    800f0e <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800f24:	0f b6 c1             	movzbl %cl,%eax
  800f27:	0f b6 db             	movzbl %bl,%ebx
  800f2a:	29 d8                	sub    %ebx,%eax
  800f2c:	eb 05                	jmp    800f33 <memcmp+0x35>
	}

	return 0;
  800f2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f33:	5b                   	pop    %ebx
  800f34:	5e                   	pop    %esi
  800f35:	5d                   	pop    %ebp
  800f36:	c3                   	ret    

00800f37 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800f40:	89 c2                	mov    %eax,%edx
  800f42:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800f45:	39 d0                	cmp    %edx,%eax
  800f47:	73 09                	jae    800f52 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f49:	38 08                	cmp    %cl,(%eax)
  800f4b:	74 05                	je     800f52 <memfind+0x1b>
	for (; s < ends; s++)
  800f4d:	83 c0 01             	add    $0x1,%eax
  800f50:	eb f3                	jmp    800f45 <memfind+0xe>
			break;
	return (void *) s;
}
  800f52:	5d                   	pop    %ebp
  800f53:	c3                   	ret    

00800f54 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f54:	55                   	push   %ebp
  800f55:	89 e5                	mov    %esp,%ebp
  800f57:	57                   	push   %edi
  800f58:	56                   	push   %esi
  800f59:	53                   	push   %ebx
  800f5a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f5d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f60:	eb 03                	jmp    800f65 <strtol+0x11>
		s++;
  800f62:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800f65:	0f b6 01             	movzbl (%ecx),%eax
  800f68:	3c 20                	cmp    $0x20,%al
  800f6a:	74 f6                	je     800f62 <strtol+0xe>
  800f6c:	3c 09                	cmp    $0x9,%al
  800f6e:	74 f2                	je     800f62 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800f70:	3c 2b                	cmp    $0x2b,%al
  800f72:	74 2a                	je     800f9e <strtol+0x4a>
	int neg = 0;
  800f74:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800f79:	3c 2d                	cmp    $0x2d,%al
  800f7b:	74 2b                	je     800fa8 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f7d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800f83:	75 0f                	jne    800f94 <strtol+0x40>
  800f85:	80 39 30             	cmpb   $0x30,(%ecx)
  800f88:	74 28                	je     800fb2 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800f8a:	85 db                	test   %ebx,%ebx
  800f8c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f91:	0f 44 d8             	cmove  %eax,%ebx
  800f94:	b8 00 00 00 00       	mov    $0x0,%eax
  800f99:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800f9c:	eb 50                	jmp    800fee <strtol+0x9a>
		s++;
  800f9e:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800fa1:	bf 00 00 00 00       	mov    $0x0,%edi
  800fa6:	eb d5                	jmp    800f7d <strtol+0x29>
		s++, neg = 1;
  800fa8:	83 c1 01             	add    $0x1,%ecx
  800fab:	bf 01 00 00 00       	mov    $0x1,%edi
  800fb0:	eb cb                	jmp    800f7d <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fb2:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800fb6:	74 0e                	je     800fc6 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800fb8:	85 db                	test   %ebx,%ebx
  800fba:	75 d8                	jne    800f94 <strtol+0x40>
		s++, base = 8;
  800fbc:	83 c1 01             	add    $0x1,%ecx
  800fbf:	bb 08 00 00 00       	mov    $0x8,%ebx
  800fc4:	eb ce                	jmp    800f94 <strtol+0x40>
		s += 2, base = 16;
  800fc6:	83 c1 02             	add    $0x2,%ecx
  800fc9:	bb 10 00 00 00       	mov    $0x10,%ebx
  800fce:	eb c4                	jmp    800f94 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800fd0:	8d 72 9f             	lea    -0x61(%edx),%esi
  800fd3:	89 f3                	mov    %esi,%ebx
  800fd5:	80 fb 19             	cmp    $0x19,%bl
  800fd8:	77 29                	ja     801003 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800fda:	0f be d2             	movsbl %dl,%edx
  800fdd:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800fe0:	3b 55 10             	cmp    0x10(%ebp),%edx
  800fe3:	7d 30                	jge    801015 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800fe5:	83 c1 01             	add    $0x1,%ecx
  800fe8:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fec:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800fee:	0f b6 11             	movzbl (%ecx),%edx
  800ff1:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ff4:	89 f3                	mov    %esi,%ebx
  800ff6:	80 fb 09             	cmp    $0x9,%bl
  800ff9:	77 d5                	ja     800fd0 <strtol+0x7c>
			dig = *s - '0';
  800ffb:	0f be d2             	movsbl %dl,%edx
  800ffe:	83 ea 30             	sub    $0x30,%edx
  801001:	eb dd                	jmp    800fe0 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  801003:	8d 72 bf             	lea    -0x41(%edx),%esi
  801006:	89 f3                	mov    %esi,%ebx
  801008:	80 fb 19             	cmp    $0x19,%bl
  80100b:	77 08                	ja     801015 <strtol+0xc1>
			dig = *s - 'A' + 10;
  80100d:	0f be d2             	movsbl %dl,%edx
  801010:	83 ea 37             	sub    $0x37,%edx
  801013:	eb cb                	jmp    800fe0 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  801015:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801019:	74 05                	je     801020 <strtol+0xcc>
		*endptr = (char *) s;
  80101b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80101e:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801020:	89 c2                	mov    %eax,%edx
  801022:	f7 da                	neg    %edx
  801024:	85 ff                	test   %edi,%edi
  801026:	0f 45 c2             	cmovne %edx,%eax
}
  801029:	5b                   	pop    %ebx
  80102a:	5e                   	pop    %esi
  80102b:	5f                   	pop    %edi
  80102c:	5d                   	pop    %ebp
  80102d:	c3                   	ret    

0080102e <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80102e:	55                   	push   %ebp
  80102f:	89 e5                	mov    %esp,%ebp
  801031:	57                   	push   %edi
  801032:	56                   	push   %esi
  801033:	53                   	push   %ebx
	asm volatile("int %1\n"
  801034:	b8 00 00 00 00       	mov    $0x0,%eax
  801039:	8b 55 08             	mov    0x8(%ebp),%edx
  80103c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80103f:	89 c3                	mov    %eax,%ebx
  801041:	89 c7                	mov    %eax,%edi
  801043:	89 c6                	mov    %eax,%esi
  801045:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801047:	5b                   	pop    %ebx
  801048:	5e                   	pop    %esi
  801049:	5f                   	pop    %edi
  80104a:	5d                   	pop    %ebp
  80104b:	c3                   	ret    

0080104c <sys_cgetc>:

int
sys_cgetc(void)
{
  80104c:	55                   	push   %ebp
  80104d:	89 e5                	mov    %esp,%ebp
  80104f:	57                   	push   %edi
  801050:	56                   	push   %esi
  801051:	53                   	push   %ebx
	asm volatile("int %1\n"
  801052:	ba 00 00 00 00       	mov    $0x0,%edx
  801057:	b8 01 00 00 00       	mov    $0x1,%eax
  80105c:	89 d1                	mov    %edx,%ecx
  80105e:	89 d3                	mov    %edx,%ebx
  801060:	89 d7                	mov    %edx,%edi
  801062:	89 d6                	mov    %edx,%esi
  801064:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801066:	5b                   	pop    %ebx
  801067:	5e                   	pop    %esi
  801068:	5f                   	pop    %edi
  801069:	5d                   	pop    %ebp
  80106a:	c3                   	ret    

0080106b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80106b:	55                   	push   %ebp
  80106c:	89 e5                	mov    %esp,%ebp
  80106e:	57                   	push   %edi
  80106f:	56                   	push   %esi
  801070:	53                   	push   %ebx
  801071:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801074:	b9 00 00 00 00       	mov    $0x0,%ecx
  801079:	8b 55 08             	mov    0x8(%ebp),%edx
  80107c:	b8 03 00 00 00       	mov    $0x3,%eax
  801081:	89 cb                	mov    %ecx,%ebx
  801083:	89 cf                	mov    %ecx,%edi
  801085:	89 ce                	mov    %ecx,%esi
  801087:	cd 30                	int    $0x30
	if(check && ret > 0)
  801089:	85 c0                	test   %eax,%eax
  80108b:	7f 08                	jg     801095 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80108d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801090:	5b                   	pop    %ebx
  801091:	5e                   	pop    %esi
  801092:	5f                   	pop    %edi
  801093:	5d                   	pop    %ebp
  801094:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801095:	83 ec 0c             	sub    $0xc,%esp
  801098:	50                   	push   %eax
  801099:	6a 03                	push   $0x3
  80109b:	68 08 33 80 00       	push   $0x803308
  8010a0:	6a 43                	push   $0x43
  8010a2:	68 25 33 80 00       	push   $0x803325
  8010a7:	e8 f7 f3 ff ff       	call   8004a3 <_panic>

008010ac <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8010ac:	55                   	push   %ebp
  8010ad:	89 e5                	mov    %esp,%ebp
  8010af:	57                   	push   %edi
  8010b0:	56                   	push   %esi
  8010b1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8010b7:	b8 02 00 00 00       	mov    $0x2,%eax
  8010bc:	89 d1                	mov    %edx,%ecx
  8010be:	89 d3                	mov    %edx,%ebx
  8010c0:	89 d7                	mov    %edx,%edi
  8010c2:	89 d6                	mov    %edx,%esi
  8010c4:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8010c6:	5b                   	pop    %ebx
  8010c7:	5e                   	pop    %esi
  8010c8:	5f                   	pop    %edi
  8010c9:	5d                   	pop    %ebp
  8010ca:	c3                   	ret    

008010cb <sys_yield>:

void
sys_yield(void)
{
  8010cb:	55                   	push   %ebp
  8010cc:	89 e5                	mov    %esp,%ebp
  8010ce:	57                   	push   %edi
  8010cf:	56                   	push   %esi
  8010d0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8010d6:	b8 0b 00 00 00       	mov    $0xb,%eax
  8010db:	89 d1                	mov    %edx,%ecx
  8010dd:	89 d3                	mov    %edx,%ebx
  8010df:	89 d7                	mov    %edx,%edi
  8010e1:	89 d6                	mov    %edx,%esi
  8010e3:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8010e5:	5b                   	pop    %ebx
  8010e6:	5e                   	pop    %esi
  8010e7:	5f                   	pop    %edi
  8010e8:	5d                   	pop    %ebp
  8010e9:	c3                   	ret    

008010ea <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8010ea:	55                   	push   %ebp
  8010eb:	89 e5                	mov    %esp,%ebp
  8010ed:	57                   	push   %edi
  8010ee:	56                   	push   %esi
  8010ef:	53                   	push   %ebx
  8010f0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010f3:	be 00 00 00 00       	mov    $0x0,%esi
  8010f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010fe:	b8 04 00 00 00       	mov    $0x4,%eax
  801103:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801106:	89 f7                	mov    %esi,%edi
  801108:	cd 30                	int    $0x30
	if(check && ret > 0)
  80110a:	85 c0                	test   %eax,%eax
  80110c:	7f 08                	jg     801116 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80110e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801111:	5b                   	pop    %ebx
  801112:	5e                   	pop    %esi
  801113:	5f                   	pop    %edi
  801114:	5d                   	pop    %ebp
  801115:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801116:	83 ec 0c             	sub    $0xc,%esp
  801119:	50                   	push   %eax
  80111a:	6a 04                	push   $0x4
  80111c:	68 08 33 80 00       	push   $0x803308
  801121:	6a 43                	push   $0x43
  801123:	68 25 33 80 00       	push   $0x803325
  801128:	e8 76 f3 ff ff       	call   8004a3 <_panic>

0080112d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80112d:	55                   	push   %ebp
  80112e:	89 e5                	mov    %esp,%ebp
  801130:	57                   	push   %edi
  801131:	56                   	push   %esi
  801132:	53                   	push   %ebx
  801133:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801136:	8b 55 08             	mov    0x8(%ebp),%edx
  801139:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80113c:	b8 05 00 00 00       	mov    $0x5,%eax
  801141:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801144:	8b 7d 14             	mov    0x14(%ebp),%edi
  801147:	8b 75 18             	mov    0x18(%ebp),%esi
  80114a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80114c:	85 c0                	test   %eax,%eax
  80114e:	7f 08                	jg     801158 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801150:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801153:	5b                   	pop    %ebx
  801154:	5e                   	pop    %esi
  801155:	5f                   	pop    %edi
  801156:	5d                   	pop    %ebp
  801157:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801158:	83 ec 0c             	sub    $0xc,%esp
  80115b:	50                   	push   %eax
  80115c:	6a 05                	push   $0x5
  80115e:	68 08 33 80 00       	push   $0x803308
  801163:	6a 43                	push   $0x43
  801165:	68 25 33 80 00       	push   $0x803325
  80116a:	e8 34 f3 ff ff       	call   8004a3 <_panic>

0080116f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
  801172:	57                   	push   %edi
  801173:	56                   	push   %esi
  801174:	53                   	push   %ebx
  801175:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801178:	bb 00 00 00 00       	mov    $0x0,%ebx
  80117d:	8b 55 08             	mov    0x8(%ebp),%edx
  801180:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801183:	b8 06 00 00 00       	mov    $0x6,%eax
  801188:	89 df                	mov    %ebx,%edi
  80118a:	89 de                	mov    %ebx,%esi
  80118c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80118e:	85 c0                	test   %eax,%eax
  801190:	7f 08                	jg     80119a <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801192:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801195:	5b                   	pop    %ebx
  801196:	5e                   	pop    %esi
  801197:	5f                   	pop    %edi
  801198:	5d                   	pop    %ebp
  801199:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80119a:	83 ec 0c             	sub    $0xc,%esp
  80119d:	50                   	push   %eax
  80119e:	6a 06                	push   $0x6
  8011a0:	68 08 33 80 00       	push   $0x803308
  8011a5:	6a 43                	push   $0x43
  8011a7:	68 25 33 80 00       	push   $0x803325
  8011ac:	e8 f2 f2 ff ff       	call   8004a3 <_panic>

008011b1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8011b1:	55                   	push   %ebp
  8011b2:	89 e5                	mov    %esp,%ebp
  8011b4:	57                   	push   %edi
  8011b5:	56                   	push   %esi
  8011b6:	53                   	push   %ebx
  8011b7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c5:	b8 08 00 00 00       	mov    $0x8,%eax
  8011ca:	89 df                	mov    %ebx,%edi
  8011cc:	89 de                	mov    %ebx,%esi
  8011ce:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011d0:	85 c0                	test   %eax,%eax
  8011d2:	7f 08                	jg     8011dc <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8011d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011d7:	5b                   	pop    %ebx
  8011d8:	5e                   	pop    %esi
  8011d9:	5f                   	pop    %edi
  8011da:	5d                   	pop    %ebp
  8011db:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011dc:	83 ec 0c             	sub    $0xc,%esp
  8011df:	50                   	push   %eax
  8011e0:	6a 08                	push   $0x8
  8011e2:	68 08 33 80 00       	push   $0x803308
  8011e7:	6a 43                	push   $0x43
  8011e9:	68 25 33 80 00       	push   $0x803325
  8011ee:	e8 b0 f2 ff ff       	call   8004a3 <_panic>

008011f3 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8011f3:	55                   	push   %ebp
  8011f4:	89 e5                	mov    %esp,%ebp
  8011f6:	57                   	push   %edi
  8011f7:	56                   	push   %esi
  8011f8:	53                   	push   %ebx
  8011f9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011fc:	bb 00 00 00 00       	mov    $0x0,%ebx
  801201:	8b 55 08             	mov    0x8(%ebp),%edx
  801204:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801207:	b8 09 00 00 00       	mov    $0x9,%eax
  80120c:	89 df                	mov    %ebx,%edi
  80120e:	89 de                	mov    %ebx,%esi
  801210:	cd 30                	int    $0x30
	if(check && ret > 0)
  801212:	85 c0                	test   %eax,%eax
  801214:	7f 08                	jg     80121e <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801216:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801219:	5b                   	pop    %ebx
  80121a:	5e                   	pop    %esi
  80121b:	5f                   	pop    %edi
  80121c:	5d                   	pop    %ebp
  80121d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80121e:	83 ec 0c             	sub    $0xc,%esp
  801221:	50                   	push   %eax
  801222:	6a 09                	push   $0x9
  801224:	68 08 33 80 00       	push   $0x803308
  801229:	6a 43                	push   $0x43
  80122b:	68 25 33 80 00       	push   $0x803325
  801230:	e8 6e f2 ff ff       	call   8004a3 <_panic>

00801235 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801235:	55                   	push   %ebp
  801236:	89 e5                	mov    %esp,%ebp
  801238:	57                   	push   %edi
  801239:	56                   	push   %esi
  80123a:	53                   	push   %ebx
  80123b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80123e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801243:	8b 55 08             	mov    0x8(%ebp),%edx
  801246:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801249:	b8 0a 00 00 00       	mov    $0xa,%eax
  80124e:	89 df                	mov    %ebx,%edi
  801250:	89 de                	mov    %ebx,%esi
  801252:	cd 30                	int    $0x30
	if(check && ret > 0)
  801254:	85 c0                	test   %eax,%eax
  801256:	7f 08                	jg     801260 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801258:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80125b:	5b                   	pop    %ebx
  80125c:	5e                   	pop    %esi
  80125d:	5f                   	pop    %edi
  80125e:	5d                   	pop    %ebp
  80125f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801260:	83 ec 0c             	sub    $0xc,%esp
  801263:	50                   	push   %eax
  801264:	6a 0a                	push   $0xa
  801266:	68 08 33 80 00       	push   $0x803308
  80126b:	6a 43                	push   $0x43
  80126d:	68 25 33 80 00       	push   $0x803325
  801272:	e8 2c f2 ff ff       	call   8004a3 <_panic>

00801277 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801277:	55                   	push   %ebp
  801278:	89 e5                	mov    %esp,%ebp
  80127a:	57                   	push   %edi
  80127b:	56                   	push   %esi
  80127c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80127d:	8b 55 08             	mov    0x8(%ebp),%edx
  801280:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801283:	b8 0c 00 00 00       	mov    $0xc,%eax
  801288:	be 00 00 00 00       	mov    $0x0,%esi
  80128d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801290:	8b 7d 14             	mov    0x14(%ebp),%edi
  801293:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801295:	5b                   	pop    %ebx
  801296:	5e                   	pop    %esi
  801297:	5f                   	pop    %edi
  801298:	5d                   	pop    %ebp
  801299:	c3                   	ret    

0080129a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80129a:	55                   	push   %ebp
  80129b:	89 e5                	mov    %esp,%ebp
  80129d:	57                   	push   %edi
  80129e:	56                   	push   %esi
  80129f:	53                   	push   %ebx
  8012a0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012a3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ab:	b8 0d 00 00 00       	mov    $0xd,%eax
  8012b0:	89 cb                	mov    %ecx,%ebx
  8012b2:	89 cf                	mov    %ecx,%edi
  8012b4:	89 ce                	mov    %ecx,%esi
  8012b6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012b8:	85 c0                	test   %eax,%eax
  8012ba:	7f 08                	jg     8012c4 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8012bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012bf:	5b                   	pop    %ebx
  8012c0:	5e                   	pop    %esi
  8012c1:	5f                   	pop    %edi
  8012c2:	5d                   	pop    %ebp
  8012c3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012c4:	83 ec 0c             	sub    $0xc,%esp
  8012c7:	50                   	push   %eax
  8012c8:	6a 0d                	push   $0xd
  8012ca:	68 08 33 80 00       	push   $0x803308
  8012cf:	6a 43                	push   $0x43
  8012d1:	68 25 33 80 00       	push   $0x803325
  8012d6:	e8 c8 f1 ff ff       	call   8004a3 <_panic>

008012db <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	57                   	push   %edi
  8012df:	56                   	push   %esi
  8012e0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012e1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012ec:	b8 0e 00 00 00       	mov    $0xe,%eax
  8012f1:	89 df                	mov    %ebx,%edi
  8012f3:	89 de                	mov    %ebx,%esi
  8012f5:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8012f7:	5b                   	pop    %ebx
  8012f8:	5e                   	pop    %esi
  8012f9:	5f                   	pop    %edi
  8012fa:	5d                   	pop    %ebp
  8012fb:	c3                   	ret    

008012fc <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8012fc:	55                   	push   %ebp
  8012fd:	89 e5                	mov    %esp,%ebp
  8012ff:	57                   	push   %edi
  801300:	56                   	push   %esi
  801301:	53                   	push   %ebx
	asm volatile("int %1\n"
  801302:	b9 00 00 00 00       	mov    $0x0,%ecx
  801307:	8b 55 08             	mov    0x8(%ebp),%edx
  80130a:	b8 0f 00 00 00       	mov    $0xf,%eax
  80130f:	89 cb                	mov    %ecx,%ebx
  801311:	89 cf                	mov    %ecx,%edi
  801313:	89 ce                	mov    %ecx,%esi
  801315:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801317:	5b                   	pop    %ebx
  801318:	5e                   	pop    %esi
  801319:	5f                   	pop    %edi
  80131a:	5d                   	pop    %ebp
  80131b:	c3                   	ret    

0080131c <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	57                   	push   %edi
  801320:	56                   	push   %esi
  801321:	53                   	push   %ebx
	asm volatile("int %1\n"
  801322:	ba 00 00 00 00       	mov    $0x0,%edx
  801327:	b8 10 00 00 00       	mov    $0x10,%eax
  80132c:	89 d1                	mov    %edx,%ecx
  80132e:	89 d3                	mov    %edx,%ebx
  801330:	89 d7                	mov    %edx,%edi
  801332:	89 d6                	mov    %edx,%esi
  801334:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801336:	5b                   	pop    %ebx
  801337:	5e                   	pop    %esi
  801338:	5f                   	pop    %edi
  801339:	5d                   	pop    %ebp
  80133a:	c3                   	ret    

0080133b <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  80133b:	55                   	push   %ebp
  80133c:	89 e5                	mov    %esp,%ebp
  80133e:	57                   	push   %edi
  80133f:	56                   	push   %esi
  801340:	53                   	push   %ebx
	asm volatile("int %1\n"
  801341:	bb 00 00 00 00       	mov    $0x0,%ebx
  801346:	8b 55 08             	mov    0x8(%ebp),%edx
  801349:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80134c:	b8 11 00 00 00       	mov    $0x11,%eax
  801351:	89 df                	mov    %ebx,%edi
  801353:	89 de                	mov    %ebx,%esi
  801355:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801357:	5b                   	pop    %ebx
  801358:	5e                   	pop    %esi
  801359:	5f                   	pop    %edi
  80135a:	5d                   	pop    %ebp
  80135b:	c3                   	ret    

0080135c <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  80135c:	55                   	push   %ebp
  80135d:	89 e5                	mov    %esp,%ebp
  80135f:	57                   	push   %edi
  801360:	56                   	push   %esi
  801361:	53                   	push   %ebx
	asm volatile("int %1\n"
  801362:	bb 00 00 00 00       	mov    $0x0,%ebx
  801367:	8b 55 08             	mov    0x8(%ebp),%edx
  80136a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80136d:	b8 12 00 00 00       	mov    $0x12,%eax
  801372:	89 df                	mov    %ebx,%edi
  801374:	89 de                	mov    %ebx,%esi
  801376:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801378:	5b                   	pop    %ebx
  801379:	5e                   	pop    %esi
  80137a:	5f                   	pop    %edi
  80137b:	5d                   	pop    %ebp
  80137c:	c3                   	ret    

0080137d <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80137d:	55                   	push   %ebp
  80137e:	89 e5                	mov    %esp,%ebp
  801380:	57                   	push   %edi
  801381:	56                   	push   %esi
  801382:	53                   	push   %ebx
  801383:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801386:	bb 00 00 00 00       	mov    $0x0,%ebx
  80138b:	8b 55 08             	mov    0x8(%ebp),%edx
  80138e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801391:	b8 13 00 00 00       	mov    $0x13,%eax
  801396:	89 df                	mov    %ebx,%edi
  801398:	89 de                	mov    %ebx,%esi
  80139a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80139c:	85 c0                	test   %eax,%eax
  80139e:	7f 08                	jg     8013a8 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8013a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013a3:	5b                   	pop    %ebx
  8013a4:	5e                   	pop    %esi
  8013a5:	5f                   	pop    %edi
  8013a6:	5d                   	pop    %ebp
  8013a7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013a8:	83 ec 0c             	sub    $0xc,%esp
  8013ab:	50                   	push   %eax
  8013ac:	6a 13                	push   $0x13
  8013ae:	68 08 33 80 00       	push   $0x803308
  8013b3:	6a 43                	push   $0x43
  8013b5:	68 25 33 80 00       	push   $0x803325
  8013ba:	e8 e4 f0 ff ff       	call   8004a3 <_panic>

008013bf <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8013bf:	55                   	push   %ebp
  8013c0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c5:	05 00 00 00 30       	add    $0x30000000,%eax
  8013ca:	c1 e8 0c             	shr    $0xc,%eax
}
  8013cd:	5d                   	pop    %ebp
  8013ce:	c3                   	ret    

008013cf <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013cf:	55                   	push   %ebp
  8013d0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d5:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8013da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013df:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8013e4:	5d                   	pop    %ebp
  8013e5:	c3                   	ret    

008013e6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013e6:	55                   	push   %ebp
  8013e7:	89 e5                	mov    %esp,%ebp
  8013e9:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013ee:	89 c2                	mov    %eax,%edx
  8013f0:	c1 ea 16             	shr    $0x16,%edx
  8013f3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013fa:	f6 c2 01             	test   $0x1,%dl
  8013fd:	74 2d                	je     80142c <fd_alloc+0x46>
  8013ff:	89 c2                	mov    %eax,%edx
  801401:	c1 ea 0c             	shr    $0xc,%edx
  801404:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80140b:	f6 c2 01             	test   $0x1,%dl
  80140e:	74 1c                	je     80142c <fd_alloc+0x46>
  801410:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801415:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80141a:	75 d2                	jne    8013ee <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80141c:	8b 45 08             	mov    0x8(%ebp),%eax
  80141f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801425:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80142a:	eb 0a                	jmp    801436 <fd_alloc+0x50>
			*fd_store = fd;
  80142c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80142f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801431:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801436:	5d                   	pop    %ebp
  801437:	c3                   	ret    

00801438 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801438:	55                   	push   %ebp
  801439:	89 e5                	mov    %esp,%ebp
  80143b:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80143e:	83 f8 1f             	cmp    $0x1f,%eax
  801441:	77 30                	ja     801473 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801443:	c1 e0 0c             	shl    $0xc,%eax
  801446:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80144b:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801451:	f6 c2 01             	test   $0x1,%dl
  801454:	74 24                	je     80147a <fd_lookup+0x42>
  801456:	89 c2                	mov    %eax,%edx
  801458:	c1 ea 0c             	shr    $0xc,%edx
  80145b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801462:	f6 c2 01             	test   $0x1,%dl
  801465:	74 1a                	je     801481 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801467:	8b 55 0c             	mov    0xc(%ebp),%edx
  80146a:	89 02                	mov    %eax,(%edx)
	return 0;
  80146c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801471:	5d                   	pop    %ebp
  801472:	c3                   	ret    
		return -E_INVAL;
  801473:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801478:	eb f7                	jmp    801471 <fd_lookup+0x39>
		return -E_INVAL;
  80147a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80147f:	eb f0                	jmp    801471 <fd_lookup+0x39>
  801481:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801486:	eb e9                	jmp    801471 <fd_lookup+0x39>

00801488 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801488:	55                   	push   %ebp
  801489:	89 e5                	mov    %esp,%ebp
  80148b:	83 ec 08             	sub    $0x8,%esp
  80148e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801491:	ba 00 00 00 00       	mov    $0x0,%edx
  801496:	b8 90 57 80 00       	mov    $0x805790,%eax
		if (devtab[i]->dev_id == dev_id) {
  80149b:	39 08                	cmp    %ecx,(%eax)
  80149d:	74 38                	je     8014d7 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80149f:	83 c2 01             	add    $0x1,%edx
  8014a2:	8b 04 95 b0 33 80 00 	mov    0x8033b0(,%edx,4),%eax
  8014a9:	85 c0                	test   %eax,%eax
  8014ab:	75 ee                	jne    80149b <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8014ad:	a1 90 77 80 00       	mov    0x807790,%eax
  8014b2:	8b 40 48             	mov    0x48(%eax),%eax
  8014b5:	83 ec 04             	sub    $0x4,%esp
  8014b8:	51                   	push   %ecx
  8014b9:	50                   	push   %eax
  8014ba:	68 34 33 80 00       	push   $0x803334
  8014bf:	e8 d5 f0 ff ff       	call   800599 <cprintf>
	*dev = 0;
  8014c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8014cd:	83 c4 10             	add    $0x10,%esp
  8014d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014d5:	c9                   	leave  
  8014d6:	c3                   	ret    
			*dev = devtab[i];
  8014d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014da:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e1:	eb f2                	jmp    8014d5 <dev_lookup+0x4d>

008014e3 <fd_close>:
{
  8014e3:	55                   	push   %ebp
  8014e4:	89 e5                	mov    %esp,%ebp
  8014e6:	57                   	push   %edi
  8014e7:	56                   	push   %esi
  8014e8:	53                   	push   %ebx
  8014e9:	83 ec 24             	sub    $0x24,%esp
  8014ec:	8b 75 08             	mov    0x8(%ebp),%esi
  8014ef:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014f2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014f5:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014f6:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8014fc:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014ff:	50                   	push   %eax
  801500:	e8 33 ff ff ff       	call   801438 <fd_lookup>
  801505:	89 c3                	mov    %eax,%ebx
  801507:	83 c4 10             	add    $0x10,%esp
  80150a:	85 c0                	test   %eax,%eax
  80150c:	78 05                	js     801513 <fd_close+0x30>
	    || fd != fd2)
  80150e:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801511:	74 16                	je     801529 <fd_close+0x46>
		return (must_exist ? r : 0);
  801513:	89 f8                	mov    %edi,%eax
  801515:	84 c0                	test   %al,%al
  801517:	b8 00 00 00 00       	mov    $0x0,%eax
  80151c:	0f 44 d8             	cmove  %eax,%ebx
}
  80151f:	89 d8                	mov    %ebx,%eax
  801521:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801524:	5b                   	pop    %ebx
  801525:	5e                   	pop    %esi
  801526:	5f                   	pop    %edi
  801527:	5d                   	pop    %ebp
  801528:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801529:	83 ec 08             	sub    $0x8,%esp
  80152c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80152f:	50                   	push   %eax
  801530:	ff 36                	pushl  (%esi)
  801532:	e8 51 ff ff ff       	call   801488 <dev_lookup>
  801537:	89 c3                	mov    %eax,%ebx
  801539:	83 c4 10             	add    $0x10,%esp
  80153c:	85 c0                	test   %eax,%eax
  80153e:	78 1a                	js     80155a <fd_close+0x77>
		if (dev->dev_close)
  801540:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801543:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801546:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80154b:	85 c0                	test   %eax,%eax
  80154d:	74 0b                	je     80155a <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80154f:	83 ec 0c             	sub    $0xc,%esp
  801552:	56                   	push   %esi
  801553:	ff d0                	call   *%eax
  801555:	89 c3                	mov    %eax,%ebx
  801557:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80155a:	83 ec 08             	sub    $0x8,%esp
  80155d:	56                   	push   %esi
  80155e:	6a 00                	push   $0x0
  801560:	e8 0a fc ff ff       	call   80116f <sys_page_unmap>
	return r;
  801565:	83 c4 10             	add    $0x10,%esp
  801568:	eb b5                	jmp    80151f <fd_close+0x3c>

0080156a <close>:

int
close(int fdnum)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801570:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801573:	50                   	push   %eax
  801574:	ff 75 08             	pushl  0x8(%ebp)
  801577:	e8 bc fe ff ff       	call   801438 <fd_lookup>
  80157c:	83 c4 10             	add    $0x10,%esp
  80157f:	85 c0                	test   %eax,%eax
  801581:	79 02                	jns    801585 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801583:	c9                   	leave  
  801584:	c3                   	ret    
		return fd_close(fd, 1);
  801585:	83 ec 08             	sub    $0x8,%esp
  801588:	6a 01                	push   $0x1
  80158a:	ff 75 f4             	pushl  -0xc(%ebp)
  80158d:	e8 51 ff ff ff       	call   8014e3 <fd_close>
  801592:	83 c4 10             	add    $0x10,%esp
  801595:	eb ec                	jmp    801583 <close+0x19>

00801597 <close_all>:

void
close_all(void)
{
  801597:	55                   	push   %ebp
  801598:	89 e5                	mov    %esp,%ebp
  80159a:	53                   	push   %ebx
  80159b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80159e:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8015a3:	83 ec 0c             	sub    $0xc,%esp
  8015a6:	53                   	push   %ebx
  8015a7:	e8 be ff ff ff       	call   80156a <close>
	for (i = 0; i < MAXFD; i++)
  8015ac:	83 c3 01             	add    $0x1,%ebx
  8015af:	83 c4 10             	add    $0x10,%esp
  8015b2:	83 fb 20             	cmp    $0x20,%ebx
  8015b5:	75 ec                	jne    8015a3 <close_all+0xc>
}
  8015b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ba:	c9                   	leave  
  8015bb:	c3                   	ret    

008015bc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
  8015bf:	57                   	push   %edi
  8015c0:	56                   	push   %esi
  8015c1:	53                   	push   %ebx
  8015c2:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015c5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015c8:	50                   	push   %eax
  8015c9:	ff 75 08             	pushl  0x8(%ebp)
  8015cc:	e8 67 fe ff ff       	call   801438 <fd_lookup>
  8015d1:	89 c3                	mov    %eax,%ebx
  8015d3:	83 c4 10             	add    $0x10,%esp
  8015d6:	85 c0                	test   %eax,%eax
  8015d8:	0f 88 81 00 00 00    	js     80165f <dup+0xa3>
		return r;
	close(newfdnum);
  8015de:	83 ec 0c             	sub    $0xc,%esp
  8015e1:	ff 75 0c             	pushl  0xc(%ebp)
  8015e4:	e8 81 ff ff ff       	call   80156a <close>

	newfd = INDEX2FD(newfdnum);
  8015e9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015ec:	c1 e6 0c             	shl    $0xc,%esi
  8015ef:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8015f5:	83 c4 04             	add    $0x4,%esp
  8015f8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015fb:	e8 cf fd ff ff       	call   8013cf <fd2data>
  801600:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801602:	89 34 24             	mov    %esi,(%esp)
  801605:	e8 c5 fd ff ff       	call   8013cf <fd2data>
  80160a:	83 c4 10             	add    $0x10,%esp
  80160d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80160f:	89 d8                	mov    %ebx,%eax
  801611:	c1 e8 16             	shr    $0x16,%eax
  801614:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80161b:	a8 01                	test   $0x1,%al
  80161d:	74 11                	je     801630 <dup+0x74>
  80161f:	89 d8                	mov    %ebx,%eax
  801621:	c1 e8 0c             	shr    $0xc,%eax
  801624:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80162b:	f6 c2 01             	test   $0x1,%dl
  80162e:	75 39                	jne    801669 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801630:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801633:	89 d0                	mov    %edx,%eax
  801635:	c1 e8 0c             	shr    $0xc,%eax
  801638:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80163f:	83 ec 0c             	sub    $0xc,%esp
  801642:	25 07 0e 00 00       	and    $0xe07,%eax
  801647:	50                   	push   %eax
  801648:	56                   	push   %esi
  801649:	6a 00                	push   $0x0
  80164b:	52                   	push   %edx
  80164c:	6a 00                	push   $0x0
  80164e:	e8 da fa ff ff       	call   80112d <sys_page_map>
  801653:	89 c3                	mov    %eax,%ebx
  801655:	83 c4 20             	add    $0x20,%esp
  801658:	85 c0                	test   %eax,%eax
  80165a:	78 31                	js     80168d <dup+0xd1>
		goto err;

	return newfdnum;
  80165c:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80165f:	89 d8                	mov    %ebx,%eax
  801661:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801664:	5b                   	pop    %ebx
  801665:	5e                   	pop    %esi
  801666:	5f                   	pop    %edi
  801667:	5d                   	pop    %ebp
  801668:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801669:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801670:	83 ec 0c             	sub    $0xc,%esp
  801673:	25 07 0e 00 00       	and    $0xe07,%eax
  801678:	50                   	push   %eax
  801679:	57                   	push   %edi
  80167a:	6a 00                	push   $0x0
  80167c:	53                   	push   %ebx
  80167d:	6a 00                	push   $0x0
  80167f:	e8 a9 fa ff ff       	call   80112d <sys_page_map>
  801684:	89 c3                	mov    %eax,%ebx
  801686:	83 c4 20             	add    $0x20,%esp
  801689:	85 c0                	test   %eax,%eax
  80168b:	79 a3                	jns    801630 <dup+0x74>
	sys_page_unmap(0, newfd);
  80168d:	83 ec 08             	sub    $0x8,%esp
  801690:	56                   	push   %esi
  801691:	6a 00                	push   $0x0
  801693:	e8 d7 fa ff ff       	call   80116f <sys_page_unmap>
	sys_page_unmap(0, nva);
  801698:	83 c4 08             	add    $0x8,%esp
  80169b:	57                   	push   %edi
  80169c:	6a 00                	push   $0x0
  80169e:	e8 cc fa ff ff       	call   80116f <sys_page_unmap>
	return r;
  8016a3:	83 c4 10             	add    $0x10,%esp
  8016a6:	eb b7                	jmp    80165f <dup+0xa3>

008016a8 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016a8:	55                   	push   %ebp
  8016a9:	89 e5                	mov    %esp,%ebp
  8016ab:	53                   	push   %ebx
  8016ac:	83 ec 1c             	sub    $0x1c,%esp
  8016af:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016b2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016b5:	50                   	push   %eax
  8016b6:	53                   	push   %ebx
  8016b7:	e8 7c fd ff ff       	call   801438 <fd_lookup>
  8016bc:	83 c4 10             	add    $0x10,%esp
  8016bf:	85 c0                	test   %eax,%eax
  8016c1:	78 3f                	js     801702 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016c3:	83 ec 08             	sub    $0x8,%esp
  8016c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016c9:	50                   	push   %eax
  8016ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016cd:	ff 30                	pushl  (%eax)
  8016cf:	e8 b4 fd ff ff       	call   801488 <dev_lookup>
  8016d4:	83 c4 10             	add    $0x10,%esp
  8016d7:	85 c0                	test   %eax,%eax
  8016d9:	78 27                	js     801702 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016db:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016de:	8b 42 08             	mov    0x8(%edx),%eax
  8016e1:	83 e0 03             	and    $0x3,%eax
  8016e4:	83 f8 01             	cmp    $0x1,%eax
  8016e7:	74 1e                	je     801707 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8016e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ec:	8b 40 08             	mov    0x8(%eax),%eax
  8016ef:	85 c0                	test   %eax,%eax
  8016f1:	74 35                	je     801728 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016f3:	83 ec 04             	sub    $0x4,%esp
  8016f6:	ff 75 10             	pushl  0x10(%ebp)
  8016f9:	ff 75 0c             	pushl  0xc(%ebp)
  8016fc:	52                   	push   %edx
  8016fd:	ff d0                	call   *%eax
  8016ff:	83 c4 10             	add    $0x10,%esp
}
  801702:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801705:	c9                   	leave  
  801706:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801707:	a1 90 77 80 00       	mov    0x807790,%eax
  80170c:	8b 40 48             	mov    0x48(%eax),%eax
  80170f:	83 ec 04             	sub    $0x4,%esp
  801712:	53                   	push   %ebx
  801713:	50                   	push   %eax
  801714:	68 75 33 80 00       	push   $0x803375
  801719:	e8 7b ee ff ff       	call   800599 <cprintf>
		return -E_INVAL;
  80171e:	83 c4 10             	add    $0x10,%esp
  801721:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801726:	eb da                	jmp    801702 <read+0x5a>
		return -E_NOT_SUPP;
  801728:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80172d:	eb d3                	jmp    801702 <read+0x5a>

0080172f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
  801732:	57                   	push   %edi
  801733:	56                   	push   %esi
  801734:	53                   	push   %ebx
  801735:	83 ec 0c             	sub    $0xc,%esp
  801738:	8b 7d 08             	mov    0x8(%ebp),%edi
  80173b:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80173e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801743:	39 f3                	cmp    %esi,%ebx
  801745:	73 23                	jae    80176a <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801747:	83 ec 04             	sub    $0x4,%esp
  80174a:	89 f0                	mov    %esi,%eax
  80174c:	29 d8                	sub    %ebx,%eax
  80174e:	50                   	push   %eax
  80174f:	89 d8                	mov    %ebx,%eax
  801751:	03 45 0c             	add    0xc(%ebp),%eax
  801754:	50                   	push   %eax
  801755:	57                   	push   %edi
  801756:	e8 4d ff ff ff       	call   8016a8 <read>
		if (m < 0)
  80175b:	83 c4 10             	add    $0x10,%esp
  80175e:	85 c0                	test   %eax,%eax
  801760:	78 06                	js     801768 <readn+0x39>
			return m;
		if (m == 0)
  801762:	74 06                	je     80176a <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801764:	01 c3                	add    %eax,%ebx
  801766:	eb db                	jmp    801743 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801768:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80176a:	89 d8                	mov    %ebx,%eax
  80176c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80176f:	5b                   	pop    %ebx
  801770:	5e                   	pop    %esi
  801771:	5f                   	pop    %edi
  801772:	5d                   	pop    %ebp
  801773:	c3                   	ret    

00801774 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801774:	55                   	push   %ebp
  801775:	89 e5                	mov    %esp,%ebp
  801777:	53                   	push   %ebx
  801778:	83 ec 1c             	sub    $0x1c,%esp
  80177b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80177e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801781:	50                   	push   %eax
  801782:	53                   	push   %ebx
  801783:	e8 b0 fc ff ff       	call   801438 <fd_lookup>
  801788:	83 c4 10             	add    $0x10,%esp
  80178b:	85 c0                	test   %eax,%eax
  80178d:	78 3a                	js     8017c9 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80178f:	83 ec 08             	sub    $0x8,%esp
  801792:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801795:	50                   	push   %eax
  801796:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801799:	ff 30                	pushl  (%eax)
  80179b:	e8 e8 fc ff ff       	call   801488 <dev_lookup>
  8017a0:	83 c4 10             	add    $0x10,%esp
  8017a3:	85 c0                	test   %eax,%eax
  8017a5:	78 22                	js     8017c9 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017aa:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017ae:	74 1e                	je     8017ce <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8017b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017b3:	8b 52 0c             	mov    0xc(%edx),%edx
  8017b6:	85 d2                	test   %edx,%edx
  8017b8:	74 35                	je     8017ef <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017ba:	83 ec 04             	sub    $0x4,%esp
  8017bd:	ff 75 10             	pushl  0x10(%ebp)
  8017c0:	ff 75 0c             	pushl  0xc(%ebp)
  8017c3:	50                   	push   %eax
  8017c4:	ff d2                	call   *%edx
  8017c6:	83 c4 10             	add    $0x10,%esp
}
  8017c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017cc:	c9                   	leave  
  8017cd:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017ce:	a1 90 77 80 00       	mov    0x807790,%eax
  8017d3:	8b 40 48             	mov    0x48(%eax),%eax
  8017d6:	83 ec 04             	sub    $0x4,%esp
  8017d9:	53                   	push   %ebx
  8017da:	50                   	push   %eax
  8017db:	68 91 33 80 00       	push   $0x803391
  8017e0:	e8 b4 ed ff ff       	call   800599 <cprintf>
		return -E_INVAL;
  8017e5:	83 c4 10             	add    $0x10,%esp
  8017e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017ed:	eb da                	jmp    8017c9 <write+0x55>
		return -E_NOT_SUPP;
  8017ef:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017f4:	eb d3                	jmp    8017c9 <write+0x55>

008017f6 <seek>:

int
seek(int fdnum, off_t offset)
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
  8017f9:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ff:	50                   	push   %eax
  801800:	ff 75 08             	pushl  0x8(%ebp)
  801803:	e8 30 fc ff ff       	call   801438 <fd_lookup>
  801808:	83 c4 10             	add    $0x10,%esp
  80180b:	85 c0                	test   %eax,%eax
  80180d:	78 0e                	js     80181d <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80180f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801812:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801815:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801818:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80181d:	c9                   	leave  
  80181e:	c3                   	ret    

0080181f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
  801822:	53                   	push   %ebx
  801823:	83 ec 1c             	sub    $0x1c,%esp
  801826:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801829:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80182c:	50                   	push   %eax
  80182d:	53                   	push   %ebx
  80182e:	e8 05 fc ff ff       	call   801438 <fd_lookup>
  801833:	83 c4 10             	add    $0x10,%esp
  801836:	85 c0                	test   %eax,%eax
  801838:	78 37                	js     801871 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80183a:	83 ec 08             	sub    $0x8,%esp
  80183d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801840:	50                   	push   %eax
  801841:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801844:	ff 30                	pushl  (%eax)
  801846:	e8 3d fc ff ff       	call   801488 <dev_lookup>
  80184b:	83 c4 10             	add    $0x10,%esp
  80184e:	85 c0                	test   %eax,%eax
  801850:	78 1f                	js     801871 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801852:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801855:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801859:	74 1b                	je     801876 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80185b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80185e:	8b 52 18             	mov    0x18(%edx),%edx
  801861:	85 d2                	test   %edx,%edx
  801863:	74 32                	je     801897 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801865:	83 ec 08             	sub    $0x8,%esp
  801868:	ff 75 0c             	pushl  0xc(%ebp)
  80186b:	50                   	push   %eax
  80186c:	ff d2                	call   *%edx
  80186e:	83 c4 10             	add    $0x10,%esp
}
  801871:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801874:	c9                   	leave  
  801875:	c3                   	ret    
			thisenv->env_id, fdnum);
  801876:	a1 90 77 80 00       	mov    0x807790,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80187b:	8b 40 48             	mov    0x48(%eax),%eax
  80187e:	83 ec 04             	sub    $0x4,%esp
  801881:	53                   	push   %ebx
  801882:	50                   	push   %eax
  801883:	68 54 33 80 00       	push   $0x803354
  801888:	e8 0c ed ff ff       	call   800599 <cprintf>
		return -E_INVAL;
  80188d:	83 c4 10             	add    $0x10,%esp
  801890:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801895:	eb da                	jmp    801871 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801897:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80189c:	eb d3                	jmp    801871 <ftruncate+0x52>

0080189e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
  8018a1:	53                   	push   %ebx
  8018a2:	83 ec 1c             	sub    $0x1c,%esp
  8018a5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018a8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018ab:	50                   	push   %eax
  8018ac:	ff 75 08             	pushl  0x8(%ebp)
  8018af:	e8 84 fb ff ff       	call   801438 <fd_lookup>
  8018b4:	83 c4 10             	add    $0x10,%esp
  8018b7:	85 c0                	test   %eax,%eax
  8018b9:	78 4b                	js     801906 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018bb:	83 ec 08             	sub    $0x8,%esp
  8018be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018c1:	50                   	push   %eax
  8018c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c5:	ff 30                	pushl  (%eax)
  8018c7:	e8 bc fb ff ff       	call   801488 <dev_lookup>
  8018cc:	83 c4 10             	add    $0x10,%esp
  8018cf:	85 c0                	test   %eax,%eax
  8018d1:	78 33                	js     801906 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8018d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d6:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018da:	74 2f                	je     80190b <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018dc:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018df:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018e6:	00 00 00 
	stat->st_isdir = 0;
  8018e9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018f0:	00 00 00 
	stat->st_dev = dev;
  8018f3:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018f9:	83 ec 08             	sub    $0x8,%esp
  8018fc:	53                   	push   %ebx
  8018fd:	ff 75 f0             	pushl  -0x10(%ebp)
  801900:	ff 50 14             	call   *0x14(%eax)
  801903:	83 c4 10             	add    $0x10,%esp
}
  801906:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801909:	c9                   	leave  
  80190a:	c3                   	ret    
		return -E_NOT_SUPP;
  80190b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801910:	eb f4                	jmp    801906 <fstat+0x68>

00801912 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
  801915:	56                   	push   %esi
  801916:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801917:	83 ec 08             	sub    $0x8,%esp
  80191a:	6a 00                	push   $0x0
  80191c:	ff 75 08             	pushl  0x8(%ebp)
  80191f:	e8 22 02 00 00       	call   801b46 <open>
  801924:	89 c3                	mov    %eax,%ebx
  801926:	83 c4 10             	add    $0x10,%esp
  801929:	85 c0                	test   %eax,%eax
  80192b:	78 1b                	js     801948 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80192d:	83 ec 08             	sub    $0x8,%esp
  801930:	ff 75 0c             	pushl  0xc(%ebp)
  801933:	50                   	push   %eax
  801934:	e8 65 ff ff ff       	call   80189e <fstat>
  801939:	89 c6                	mov    %eax,%esi
	close(fd);
  80193b:	89 1c 24             	mov    %ebx,(%esp)
  80193e:	e8 27 fc ff ff       	call   80156a <close>
	return r;
  801943:	83 c4 10             	add    $0x10,%esp
  801946:	89 f3                	mov    %esi,%ebx
}
  801948:	89 d8                	mov    %ebx,%eax
  80194a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80194d:	5b                   	pop    %ebx
  80194e:	5e                   	pop    %esi
  80194f:	5d                   	pop    %ebp
  801950:	c3                   	ret    

00801951 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
  801954:	56                   	push   %esi
  801955:	53                   	push   %ebx
  801956:	89 c6                	mov    %eax,%esi
  801958:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80195a:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801961:	74 27                	je     80198a <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801963:	6a 07                	push   $0x7
  801965:	68 00 80 80 00       	push   $0x808000
  80196a:	56                   	push   %esi
  80196b:	ff 35 00 60 80 00    	pushl  0x806000
  801971:	e8 fe 10 00 00       	call   802a74 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801976:	83 c4 0c             	add    $0xc,%esp
  801979:	6a 00                	push   $0x0
  80197b:	53                   	push   %ebx
  80197c:	6a 00                	push   $0x0
  80197e:	e8 88 10 00 00       	call   802a0b <ipc_recv>
}
  801983:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801986:	5b                   	pop    %ebx
  801987:	5e                   	pop    %esi
  801988:	5d                   	pop    %ebp
  801989:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80198a:	83 ec 0c             	sub    $0xc,%esp
  80198d:	6a 01                	push   $0x1
  80198f:	e8 38 11 00 00       	call   802acc <ipc_find_env>
  801994:	a3 00 60 80 00       	mov    %eax,0x806000
  801999:	83 c4 10             	add    $0x10,%esp
  80199c:	eb c5                	jmp    801963 <fsipc+0x12>

0080199e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
  8019a1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8019a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8019aa:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.set_size.req_size = newsize;
  8019af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b2:	a3 04 80 80 00       	mov    %eax,0x808004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8019b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8019bc:	b8 02 00 00 00       	mov    $0x2,%eax
  8019c1:	e8 8b ff ff ff       	call   801951 <fsipc>
}
  8019c6:	c9                   	leave  
  8019c7:	c3                   	ret    

008019c8 <devfile_flush>:
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
  8019cb:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8019d4:	a3 00 80 80 00       	mov    %eax,0x808000
	return fsipc(FSREQ_FLUSH, NULL);
  8019d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8019de:	b8 06 00 00 00       	mov    $0x6,%eax
  8019e3:	e8 69 ff ff ff       	call   801951 <fsipc>
}
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <devfile_stat>:
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
  8019ed:	53                   	push   %ebx
  8019ee:	83 ec 04             	sub    $0x4,%esp
  8019f1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8019f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8019fa:	a3 00 80 80 00       	mov    %eax,0x808000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8019ff:	ba 00 00 00 00       	mov    $0x0,%edx
  801a04:	b8 05 00 00 00       	mov    $0x5,%eax
  801a09:	e8 43 ff ff ff       	call   801951 <fsipc>
  801a0e:	85 c0                	test   %eax,%eax
  801a10:	78 2c                	js     801a3e <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a12:	83 ec 08             	sub    $0x8,%esp
  801a15:	68 00 80 80 00       	push   $0x808000
  801a1a:	53                   	push   %ebx
  801a1b:	e8 d8 f2 ff ff       	call   800cf8 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a20:	a1 80 80 80 00       	mov    0x808080,%eax
  801a25:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a2b:	a1 84 80 80 00       	mov    0x808084,%eax
  801a30:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a36:	83 c4 10             	add    $0x10,%esp
  801a39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    

00801a43 <devfile_write>:
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
  801a46:	53                   	push   %ebx
  801a47:	83 ec 08             	sub    $0x8,%esp
  801a4a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a50:	8b 40 0c             	mov    0xc(%eax),%eax
  801a53:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.write.req_n = n;
  801a58:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801a5e:	53                   	push   %ebx
  801a5f:	ff 75 0c             	pushl  0xc(%ebp)
  801a62:	68 08 80 80 00       	push   $0x808008
  801a67:	e8 7c f4 ff ff       	call   800ee8 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801a6c:	ba 00 00 00 00       	mov    $0x0,%edx
  801a71:	b8 04 00 00 00       	mov    $0x4,%eax
  801a76:	e8 d6 fe ff ff       	call   801951 <fsipc>
  801a7b:	83 c4 10             	add    $0x10,%esp
  801a7e:	85 c0                	test   %eax,%eax
  801a80:	78 0b                	js     801a8d <devfile_write+0x4a>
	assert(r <= n);
  801a82:	39 d8                	cmp    %ebx,%eax
  801a84:	77 0c                	ja     801a92 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801a86:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a8b:	7f 1e                	jg     801aab <devfile_write+0x68>
}
  801a8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a90:	c9                   	leave  
  801a91:	c3                   	ret    
	assert(r <= n);
  801a92:	68 c4 33 80 00       	push   $0x8033c4
  801a97:	68 cb 33 80 00       	push   $0x8033cb
  801a9c:	68 98 00 00 00       	push   $0x98
  801aa1:	68 e0 33 80 00       	push   $0x8033e0
  801aa6:	e8 f8 e9 ff ff       	call   8004a3 <_panic>
	assert(r <= PGSIZE);
  801aab:	68 eb 33 80 00       	push   $0x8033eb
  801ab0:	68 cb 33 80 00       	push   $0x8033cb
  801ab5:	68 99 00 00 00       	push   $0x99
  801aba:	68 e0 33 80 00       	push   $0x8033e0
  801abf:	e8 df e9 ff ff       	call   8004a3 <_panic>

00801ac4 <devfile_read>:
{
  801ac4:	55                   	push   %ebp
  801ac5:	89 e5                	mov    %esp,%ebp
  801ac7:	56                   	push   %esi
  801ac8:	53                   	push   %ebx
  801ac9:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801acc:	8b 45 08             	mov    0x8(%ebp),%eax
  801acf:	8b 40 0c             	mov    0xc(%eax),%eax
  801ad2:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.read.req_n = n;
  801ad7:	89 35 04 80 80 00    	mov    %esi,0x808004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801add:	ba 00 00 00 00       	mov    $0x0,%edx
  801ae2:	b8 03 00 00 00       	mov    $0x3,%eax
  801ae7:	e8 65 fe ff ff       	call   801951 <fsipc>
  801aec:	89 c3                	mov    %eax,%ebx
  801aee:	85 c0                	test   %eax,%eax
  801af0:	78 1f                	js     801b11 <devfile_read+0x4d>
	assert(r <= n);
  801af2:	39 f0                	cmp    %esi,%eax
  801af4:	77 24                	ja     801b1a <devfile_read+0x56>
	assert(r <= PGSIZE);
  801af6:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801afb:	7f 33                	jg     801b30 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801afd:	83 ec 04             	sub    $0x4,%esp
  801b00:	50                   	push   %eax
  801b01:	68 00 80 80 00       	push   $0x808000
  801b06:	ff 75 0c             	pushl  0xc(%ebp)
  801b09:	e8 78 f3 ff ff       	call   800e86 <memmove>
	return r;
  801b0e:	83 c4 10             	add    $0x10,%esp
}
  801b11:	89 d8                	mov    %ebx,%eax
  801b13:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b16:	5b                   	pop    %ebx
  801b17:	5e                   	pop    %esi
  801b18:	5d                   	pop    %ebp
  801b19:	c3                   	ret    
	assert(r <= n);
  801b1a:	68 c4 33 80 00       	push   $0x8033c4
  801b1f:	68 cb 33 80 00       	push   $0x8033cb
  801b24:	6a 7c                	push   $0x7c
  801b26:	68 e0 33 80 00       	push   $0x8033e0
  801b2b:	e8 73 e9 ff ff       	call   8004a3 <_panic>
	assert(r <= PGSIZE);
  801b30:	68 eb 33 80 00       	push   $0x8033eb
  801b35:	68 cb 33 80 00       	push   $0x8033cb
  801b3a:	6a 7d                	push   $0x7d
  801b3c:	68 e0 33 80 00       	push   $0x8033e0
  801b41:	e8 5d e9 ff ff       	call   8004a3 <_panic>

00801b46 <open>:
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
  801b49:	56                   	push   %esi
  801b4a:	53                   	push   %ebx
  801b4b:	83 ec 1c             	sub    $0x1c,%esp
  801b4e:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b51:	56                   	push   %esi
  801b52:	e8 68 f1 ff ff       	call   800cbf <strlen>
  801b57:	83 c4 10             	add    $0x10,%esp
  801b5a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b5f:	7f 6c                	jg     801bcd <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801b61:	83 ec 0c             	sub    $0xc,%esp
  801b64:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b67:	50                   	push   %eax
  801b68:	e8 79 f8 ff ff       	call   8013e6 <fd_alloc>
  801b6d:	89 c3                	mov    %eax,%ebx
  801b6f:	83 c4 10             	add    $0x10,%esp
  801b72:	85 c0                	test   %eax,%eax
  801b74:	78 3c                	js     801bb2 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801b76:	83 ec 08             	sub    $0x8,%esp
  801b79:	56                   	push   %esi
  801b7a:	68 00 80 80 00       	push   $0x808000
  801b7f:	e8 74 f1 ff ff       	call   800cf8 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b87:	a3 00 84 80 00       	mov    %eax,0x808400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b8f:	b8 01 00 00 00       	mov    $0x1,%eax
  801b94:	e8 b8 fd ff ff       	call   801951 <fsipc>
  801b99:	89 c3                	mov    %eax,%ebx
  801b9b:	83 c4 10             	add    $0x10,%esp
  801b9e:	85 c0                	test   %eax,%eax
  801ba0:	78 19                	js     801bbb <open+0x75>
	return fd2num(fd);
  801ba2:	83 ec 0c             	sub    $0xc,%esp
  801ba5:	ff 75 f4             	pushl  -0xc(%ebp)
  801ba8:	e8 12 f8 ff ff       	call   8013bf <fd2num>
  801bad:	89 c3                	mov    %eax,%ebx
  801baf:	83 c4 10             	add    $0x10,%esp
}
  801bb2:	89 d8                	mov    %ebx,%eax
  801bb4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bb7:	5b                   	pop    %ebx
  801bb8:	5e                   	pop    %esi
  801bb9:	5d                   	pop    %ebp
  801bba:	c3                   	ret    
		fd_close(fd, 0);
  801bbb:	83 ec 08             	sub    $0x8,%esp
  801bbe:	6a 00                	push   $0x0
  801bc0:	ff 75 f4             	pushl  -0xc(%ebp)
  801bc3:	e8 1b f9 ff ff       	call   8014e3 <fd_close>
		return r;
  801bc8:	83 c4 10             	add    $0x10,%esp
  801bcb:	eb e5                	jmp    801bb2 <open+0x6c>
		return -E_BAD_PATH;
  801bcd:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801bd2:	eb de                	jmp    801bb2 <open+0x6c>

00801bd4 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801bd4:	55                   	push   %ebp
  801bd5:	89 e5                	mov    %esp,%ebp
  801bd7:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801bda:	ba 00 00 00 00       	mov    $0x0,%edx
  801bdf:	b8 08 00 00 00       	mov    $0x8,%eax
  801be4:	e8 68 fd ff ff       	call   801951 <fsipc>
}
  801be9:	c9                   	leave  
  801bea:	c3                   	ret    

00801beb <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
  801bee:	57                   	push   %edi
  801bef:	56                   	push   %esi
  801bf0:	53                   	push   %ebx
  801bf1:	81 ec 94 02 00 00    	sub    $0x294,%esp
	cprintf("in %s\n", __FUNCTION__);
  801bf7:	68 d0 34 80 00       	push   $0x8034d0
  801bfc:	68 37 2f 80 00       	push   $0x802f37
  801c01:	e8 93 e9 ff ff       	call   800599 <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801c06:	83 c4 08             	add    $0x8,%esp
  801c09:	6a 00                	push   $0x0
  801c0b:	ff 75 08             	pushl  0x8(%ebp)
  801c0e:	e8 33 ff ff ff       	call   801b46 <open>
  801c13:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801c19:	83 c4 10             	add    $0x10,%esp
  801c1c:	85 c0                	test   %eax,%eax
  801c1e:	0f 88 0a 05 00 00    	js     80212e <spawn+0x543>
  801c24:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801c26:	83 ec 04             	sub    $0x4,%esp
  801c29:	68 00 02 00 00       	push   $0x200
  801c2e:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801c34:	50                   	push   %eax
  801c35:	51                   	push   %ecx
  801c36:	e8 f4 fa ff ff       	call   80172f <readn>
  801c3b:	83 c4 10             	add    $0x10,%esp
  801c3e:	3d 00 02 00 00       	cmp    $0x200,%eax
  801c43:	75 74                	jne    801cb9 <spawn+0xce>
	    || elf->e_magic != ELF_MAGIC) {
  801c45:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801c4c:	45 4c 46 
  801c4f:	75 68                	jne    801cb9 <spawn+0xce>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801c51:	b8 07 00 00 00       	mov    $0x7,%eax
  801c56:	cd 30                	int    $0x30
  801c58:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801c5e:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801c64:	85 c0                	test   %eax,%eax
  801c66:	0f 88 b6 04 00 00    	js     802122 <spawn+0x537>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801c6c:	25 ff 03 00 00       	and    $0x3ff,%eax
  801c71:	89 c6                	mov    %eax,%esi
  801c73:	c1 e6 07             	shl    $0x7,%esi
  801c76:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801c7c:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801c82:	b9 11 00 00 00       	mov    $0x11,%ecx
  801c87:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801c89:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801c8f:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
	cprintf("in %s\n", __FUNCTION__);
  801c95:	83 ec 08             	sub    $0x8,%esp
  801c98:	68 c4 34 80 00       	push   $0x8034c4
  801c9d:	68 37 2f 80 00       	push   $0x802f37
  801ca2:	e8 f2 e8 ff ff       	call   800599 <cprintf>
  801ca7:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801caa:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801caf:	be 00 00 00 00       	mov    $0x0,%esi
  801cb4:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801cb7:	eb 4b                	jmp    801d04 <spawn+0x119>
		close(fd);
  801cb9:	83 ec 0c             	sub    $0xc,%esp
  801cbc:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801cc2:	e8 a3 f8 ff ff       	call   80156a <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801cc7:	83 c4 0c             	add    $0xc,%esp
  801cca:	68 7f 45 4c 46       	push   $0x464c457f
  801ccf:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801cd5:	68 f7 33 80 00       	push   $0x8033f7
  801cda:	e8 ba e8 ff ff       	call   800599 <cprintf>
		return -E_NOT_EXEC;
  801cdf:	83 c4 10             	add    $0x10,%esp
  801ce2:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801ce9:	ff ff ff 
  801cec:	e9 3d 04 00 00       	jmp    80212e <spawn+0x543>
		string_size += strlen(argv[argc]) + 1;
  801cf1:	83 ec 0c             	sub    $0xc,%esp
  801cf4:	50                   	push   %eax
  801cf5:	e8 c5 ef ff ff       	call   800cbf <strlen>
  801cfa:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801cfe:	83 c3 01             	add    $0x1,%ebx
  801d01:	83 c4 10             	add    $0x10,%esp
  801d04:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801d0b:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801d0e:	85 c0                	test   %eax,%eax
  801d10:	75 df                	jne    801cf1 <spawn+0x106>
  801d12:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801d18:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801d1e:	bf 00 10 40 00       	mov    $0x401000,%edi
  801d23:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801d25:	89 fa                	mov    %edi,%edx
  801d27:	83 e2 fc             	and    $0xfffffffc,%edx
  801d2a:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801d31:	29 c2                	sub    %eax,%edx
  801d33:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801d39:	8d 42 f8             	lea    -0x8(%edx),%eax
  801d3c:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801d41:	0f 86 0a 04 00 00    	jbe    802151 <spawn+0x566>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801d47:	83 ec 04             	sub    $0x4,%esp
  801d4a:	6a 07                	push   $0x7
  801d4c:	68 00 00 40 00       	push   $0x400000
  801d51:	6a 00                	push   $0x0
  801d53:	e8 92 f3 ff ff       	call   8010ea <sys_page_alloc>
  801d58:	83 c4 10             	add    $0x10,%esp
  801d5b:	85 c0                	test   %eax,%eax
  801d5d:	0f 88 f3 03 00 00    	js     802156 <spawn+0x56b>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801d63:	be 00 00 00 00       	mov    $0x0,%esi
  801d68:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801d6e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801d71:	eb 30                	jmp    801da3 <spawn+0x1b8>
		argv_store[i] = UTEMP2USTACK(string_store);
  801d73:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801d79:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801d7f:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801d82:	83 ec 08             	sub    $0x8,%esp
  801d85:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801d88:	57                   	push   %edi
  801d89:	e8 6a ef ff ff       	call   800cf8 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801d8e:	83 c4 04             	add    $0x4,%esp
  801d91:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801d94:	e8 26 ef ff ff       	call   800cbf <strlen>
  801d99:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801d9d:	83 c6 01             	add    $0x1,%esi
  801da0:	83 c4 10             	add    $0x10,%esp
  801da3:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801da9:	7f c8                	jg     801d73 <spawn+0x188>
	}
	argv_store[argc] = 0;
  801dab:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801db1:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801db7:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801dbe:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801dc4:	0f 85 86 00 00 00    	jne    801e50 <spawn+0x265>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801dca:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  801dd0:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  801dd6:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  801dd9:	89 d0                	mov    %edx,%eax
  801ddb:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  801de1:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801de4:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801de9:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801def:	83 ec 0c             	sub    $0xc,%esp
  801df2:	6a 07                	push   $0x7
  801df4:	68 00 d0 bf ee       	push   $0xeebfd000
  801df9:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801dff:	68 00 00 40 00       	push   $0x400000
  801e04:	6a 00                	push   $0x0
  801e06:	e8 22 f3 ff ff       	call   80112d <sys_page_map>
  801e0b:	89 c3                	mov    %eax,%ebx
  801e0d:	83 c4 20             	add    $0x20,%esp
  801e10:	85 c0                	test   %eax,%eax
  801e12:	0f 88 46 03 00 00    	js     80215e <spawn+0x573>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801e18:	83 ec 08             	sub    $0x8,%esp
  801e1b:	68 00 00 40 00       	push   $0x400000
  801e20:	6a 00                	push   $0x0
  801e22:	e8 48 f3 ff ff       	call   80116f <sys_page_unmap>
  801e27:	89 c3                	mov    %eax,%ebx
  801e29:	83 c4 10             	add    $0x10,%esp
  801e2c:	85 c0                	test   %eax,%eax
  801e2e:	0f 88 2a 03 00 00    	js     80215e <spawn+0x573>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801e34:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801e3a:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801e41:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801e48:	00 00 00 
  801e4b:	e9 4f 01 00 00       	jmp    801f9f <spawn+0x3b4>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801e50:	68 80 34 80 00       	push   $0x803480
  801e55:	68 cb 33 80 00       	push   $0x8033cb
  801e5a:	68 f8 00 00 00       	push   $0xf8
  801e5f:	68 11 34 80 00       	push   $0x803411
  801e64:	e8 3a e6 ff ff       	call   8004a3 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801e69:	83 ec 04             	sub    $0x4,%esp
  801e6c:	6a 07                	push   $0x7
  801e6e:	68 00 00 40 00       	push   $0x400000
  801e73:	6a 00                	push   $0x0
  801e75:	e8 70 f2 ff ff       	call   8010ea <sys_page_alloc>
  801e7a:	83 c4 10             	add    $0x10,%esp
  801e7d:	85 c0                	test   %eax,%eax
  801e7f:	0f 88 b7 02 00 00    	js     80213c <spawn+0x551>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801e85:	83 ec 08             	sub    $0x8,%esp
  801e88:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801e8e:	01 f0                	add    %esi,%eax
  801e90:	50                   	push   %eax
  801e91:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801e97:	e8 5a f9 ff ff       	call   8017f6 <seek>
  801e9c:	83 c4 10             	add    $0x10,%esp
  801e9f:	85 c0                	test   %eax,%eax
  801ea1:	0f 88 9c 02 00 00    	js     802143 <spawn+0x558>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801ea7:	83 ec 04             	sub    $0x4,%esp
  801eaa:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801eb0:	29 f0                	sub    %esi,%eax
  801eb2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801eb7:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801ebc:	0f 47 c1             	cmova  %ecx,%eax
  801ebf:	50                   	push   %eax
  801ec0:	68 00 00 40 00       	push   $0x400000
  801ec5:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801ecb:	e8 5f f8 ff ff       	call   80172f <readn>
  801ed0:	83 c4 10             	add    $0x10,%esp
  801ed3:	85 c0                	test   %eax,%eax
  801ed5:	0f 88 6f 02 00 00    	js     80214a <spawn+0x55f>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801edb:	83 ec 0c             	sub    $0xc,%esp
  801ede:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801ee4:	53                   	push   %ebx
  801ee5:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801eeb:	68 00 00 40 00       	push   $0x400000
  801ef0:	6a 00                	push   $0x0
  801ef2:	e8 36 f2 ff ff       	call   80112d <sys_page_map>
  801ef7:	83 c4 20             	add    $0x20,%esp
  801efa:	85 c0                	test   %eax,%eax
  801efc:	78 7c                	js     801f7a <spawn+0x38f>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801efe:	83 ec 08             	sub    $0x8,%esp
  801f01:	68 00 00 40 00       	push   $0x400000
  801f06:	6a 00                	push   $0x0
  801f08:	e8 62 f2 ff ff       	call   80116f <sys_page_unmap>
  801f0d:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801f10:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801f16:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801f1c:	89 fe                	mov    %edi,%esi
  801f1e:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801f24:	76 69                	jbe    801f8f <spawn+0x3a4>
		if (i >= filesz) {
  801f26:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801f2c:	0f 87 37 ff ff ff    	ja     801e69 <spawn+0x27e>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801f32:	83 ec 04             	sub    $0x4,%esp
  801f35:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801f3b:	53                   	push   %ebx
  801f3c:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801f42:	e8 a3 f1 ff ff       	call   8010ea <sys_page_alloc>
  801f47:	83 c4 10             	add    $0x10,%esp
  801f4a:	85 c0                	test   %eax,%eax
  801f4c:	79 c2                	jns    801f10 <spawn+0x325>
  801f4e:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801f50:	83 ec 0c             	sub    $0xc,%esp
  801f53:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801f59:	e8 0d f1 ff ff       	call   80106b <sys_env_destroy>
	close(fd);
  801f5e:	83 c4 04             	add    $0x4,%esp
  801f61:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801f67:	e8 fe f5 ff ff       	call   80156a <close>
	return r;
  801f6c:	83 c4 10             	add    $0x10,%esp
  801f6f:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801f75:	e9 b4 01 00 00       	jmp    80212e <spawn+0x543>
				panic("spawn: sys_page_map data: %e", r);
  801f7a:	50                   	push   %eax
  801f7b:	68 1d 34 80 00       	push   $0x80341d
  801f80:	68 2b 01 00 00       	push   $0x12b
  801f85:	68 11 34 80 00       	push   $0x803411
  801f8a:	e8 14 e5 ff ff       	call   8004a3 <_panic>
  801f8f:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801f95:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801f9c:	83 c6 20             	add    $0x20,%esi
  801f9f:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801fa6:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801fac:	7e 6d                	jle    80201b <spawn+0x430>
		if (ph->p_type != ELF_PROG_LOAD)
  801fae:	83 3e 01             	cmpl   $0x1,(%esi)
  801fb1:	75 e2                	jne    801f95 <spawn+0x3aa>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801fb3:	8b 46 18             	mov    0x18(%esi),%eax
  801fb6:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801fb9:	83 f8 01             	cmp    $0x1,%eax
  801fbc:	19 c0                	sbb    %eax,%eax
  801fbe:	83 e0 fe             	and    $0xfffffffe,%eax
  801fc1:	83 c0 07             	add    $0x7,%eax
  801fc4:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801fca:	8b 4e 04             	mov    0x4(%esi),%ecx
  801fcd:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801fd3:	8b 56 10             	mov    0x10(%esi),%edx
  801fd6:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801fdc:	8b 7e 14             	mov    0x14(%esi),%edi
  801fdf:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801fe5:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801fe8:	89 d8                	mov    %ebx,%eax
  801fea:	25 ff 0f 00 00       	and    $0xfff,%eax
  801fef:	74 1a                	je     80200b <spawn+0x420>
		va -= i;
  801ff1:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801ff3:	01 c7                	add    %eax,%edi
  801ff5:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801ffb:	01 c2                	add    %eax,%edx
  801ffd:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  802003:	29 c1                	sub    %eax,%ecx
  802005:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  80200b:	bf 00 00 00 00       	mov    $0x0,%edi
  802010:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  802016:	e9 01 ff ff ff       	jmp    801f1c <spawn+0x331>
	close(fd);
  80201b:	83 ec 0c             	sub    $0xc,%esp
  80201e:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802024:	e8 41 f5 ff ff       	call   80156a <close>

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	cprintf("in %s\n", __FUNCTION__);
  802029:	83 c4 08             	add    $0x8,%esp
  80202c:	68 b0 34 80 00       	push   $0x8034b0
  802031:	68 37 2f 80 00       	push   $0x802f37
  802036:	e8 5e e5 ff ff       	call   800599 <cprintf>
  80203b:	83 c4 10             	add    $0x10,%esp
	int r;
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  80203e:	bb 00 00 80 00       	mov    $0x800000,%ebx
  802043:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  802049:	eb 0e                	jmp    802059 <spawn+0x46e>
  80204b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802051:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  802057:	74 5e                	je     8020b7 <spawn+0x4cc>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_SHARE)) == (PTE_P | PTE_U | PTE_SHARE)))
  802059:	89 d8                	mov    %ebx,%eax
  80205b:	c1 e8 16             	shr    $0x16,%eax
  80205e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802065:	a8 01                	test   $0x1,%al
  802067:	74 e2                	je     80204b <spawn+0x460>
  802069:	89 da                	mov    %ebx,%edx
  80206b:	c1 ea 0c             	shr    $0xc,%edx
  80206e:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  802075:	25 05 04 00 00       	and    $0x405,%eax
  80207a:	3d 05 04 00 00       	cmp    $0x405,%eax
  80207f:	75 ca                	jne    80204b <spawn+0x460>
			if((r = sys_page_map((envid_t)0, (void *)i, child, (void *)i, uvpt[PGNUM(i)] & PTE_SYSCALL)) < 0)
  802081:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  802088:	83 ec 0c             	sub    $0xc,%esp
  80208b:	25 07 0e 00 00       	and    $0xe07,%eax
  802090:	50                   	push   %eax
  802091:	53                   	push   %ebx
  802092:	56                   	push   %esi
  802093:	53                   	push   %ebx
  802094:	6a 00                	push   $0x0
  802096:	e8 92 f0 ff ff       	call   80112d <sys_page_map>
  80209b:	83 c4 20             	add    $0x20,%esp
  80209e:	85 c0                	test   %eax,%eax
  8020a0:	79 a9                	jns    80204b <spawn+0x460>
        		panic("sys_page_map: %e\n", r);
  8020a2:	50                   	push   %eax
  8020a3:	68 3a 34 80 00       	push   $0x80343a
  8020a8:	68 3b 01 00 00       	push   $0x13b
  8020ad:	68 11 34 80 00       	push   $0x803411
  8020b2:	e8 ec e3 ff ff       	call   8004a3 <_panic>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8020b7:	83 ec 08             	sub    $0x8,%esp
  8020ba:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  8020c0:	50                   	push   %eax
  8020c1:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8020c7:	e8 27 f1 ff ff       	call   8011f3 <sys_env_set_trapframe>
  8020cc:	83 c4 10             	add    $0x10,%esp
  8020cf:	85 c0                	test   %eax,%eax
  8020d1:	78 25                	js     8020f8 <spawn+0x50d>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8020d3:	83 ec 08             	sub    $0x8,%esp
  8020d6:	6a 02                	push   $0x2
  8020d8:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8020de:	e8 ce f0 ff ff       	call   8011b1 <sys_env_set_status>
  8020e3:	83 c4 10             	add    $0x10,%esp
  8020e6:	85 c0                	test   %eax,%eax
  8020e8:	78 23                	js     80210d <spawn+0x522>
	return child;
  8020ea:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8020f0:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8020f6:	eb 36                	jmp    80212e <spawn+0x543>
		panic("sys_env_set_trapframe: %e", r);
  8020f8:	50                   	push   %eax
  8020f9:	68 4c 34 80 00       	push   $0x80344c
  8020fe:	68 8a 00 00 00       	push   $0x8a
  802103:	68 11 34 80 00       	push   $0x803411
  802108:	e8 96 e3 ff ff       	call   8004a3 <_panic>
		panic("sys_env_set_status: %e", r);
  80210d:	50                   	push   %eax
  80210e:	68 66 34 80 00       	push   $0x803466
  802113:	68 8d 00 00 00       	push   $0x8d
  802118:	68 11 34 80 00       	push   $0x803411
  80211d:	e8 81 e3 ff ff       	call   8004a3 <_panic>
		return r;
  802122:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802128:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  80212e:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802134:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802137:	5b                   	pop    %ebx
  802138:	5e                   	pop    %esi
  802139:	5f                   	pop    %edi
  80213a:	5d                   	pop    %ebp
  80213b:	c3                   	ret    
  80213c:	89 c7                	mov    %eax,%edi
  80213e:	e9 0d fe ff ff       	jmp    801f50 <spawn+0x365>
  802143:	89 c7                	mov    %eax,%edi
  802145:	e9 06 fe ff ff       	jmp    801f50 <spawn+0x365>
  80214a:	89 c7                	mov    %eax,%edi
  80214c:	e9 ff fd ff ff       	jmp    801f50 <spawn+0x365>
		return -E_NO_MEM;
  802151:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  802156:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  80215c:	eb d0                	jmp    80212e <spawn+0x543>
	sys_page_unmap(0, UTEMP);
  80215e:	83 ec 08             	sub    $0x8,%esp
  802161:	68 00 00 40 00       	push   $0x400000
  802166:	6a 00                	push   $0x0
  802168:	e8 02 f0 ff ff       	call   80116f <sys_page_unmap>
  80216d:	83 c4 10             	add    $0x10,%esp
  802170:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  802176:	eb b6                	jmp    80212e <spawn+0x543>

00802178 <spawnl>:
{
  802178:	55                   	push   %ebp
  802179:	89 e5                	mov    %esp,%ebp
  80217b:	57                   	push   %edi
  80217c:	56                   	push   %esi
  80217d:	53                   	push   %ebx
  80217e:	83 ec 14             	sub    $0x14,%esp
	cprintf("in %s\n", __FUNCTION__);
  802181:	68 a8 34 80 00       	push   $0x8034a8
  802186:	68 37 2f 80 00       	push   $0x802f37
  80218b:	e8 09 e4 ff ff       	call   800599 <cprintf>
	va_start(vl, arg0);
  802190:	8d 55 10             	lea    0x10(%ebp),%edx
	while(va_arg(vl, void *) != NULL)
  802193:	83 c4 10             	add    $0x10,%esp
	int argc=0;
  802196:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  80219b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80219e:	83 3a 00             	cmpl   $0x0,(%edx)
  8021a1:	74 07                	je     8021aa <spawnl+0x32>
		argc++;
  8021a3:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  8021a6:	89 ca                	mov    %ecx,%edx
  8021a8:	eb f1                	jmp    80219b <spawnl+0x23>
	const char *argv[argc+2];
  8021aa:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  8021b1:	83 e2 f0             	and    $0xfffffff0,%edx
  8021b4:	29 d4                	sub    %edx,%esp
  8021b6:	8d 54 24 03          	lea    0x3(%esp),%edx
  8021ba:	c1 ea 02             	shr    $0x2,%edx
  8021bd:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  8021c4:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  8021c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021c9:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  8021d0:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  8021d7:	00 
	va_start(vl, arg0);
  8021d8:	8d 4d 10             	lea    0x10(%ebp),%ecx
  8021db:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  8021dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e2:	eb 0b                	jmp    8021ef <spawnl+0x77>
		argv[i+1] = va_arg(vl, const char *);
  8021e4:	83 c0 01             	add    $0x1,%eax
  8021e7:	8b 39                	mov    (%ecx),%edi
  8021e9:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  8021ec:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  8021ef:	39 d0                	cmp    %edx,%eax
  8021f1:	75 f1                	jne    8021e4 <spawnl+0x6c>
	return spawn(prog, argv);
  8021f3:	83 ec 08             	sub    $0x8,%esp
  8021f6:	56                   	push   %esi
  8021f7:	ff 75 08             	pushl  0x8(%ebp)
  8021fa:	e8 ec f9 ff ff       	call   801beb <spawn>
}
  8021ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802202:	5b                   	pop    %ebx
  802203:	5e                   	pop    %esi
  802204:	5f                   	pop    %edi
  802205:	5d                   	pop    %ebp
  802206:	c3                   	ret    

00802207 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802207:	55                   	push   %ebp
  802208:	89 e5                	mov    %esp,%ebp
  80220a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80220d:	68 d6 34 80 00       	push   $0x8034d6
  802212:	ff 75 0c             	pushl  0xc(%ebp)
  802215:	e8 de ea ff ff       	call   800cf8 <strcpy>
	return 0;
}
  80221a:	b8 00 00 00 00       	mov    $0x0,%eax
  80221f:	c9                   	leave  
  802220:	c3                   	ret    

00802221 <devsock_close>:
{
  802221:	55                   	push   %ebp
  802222:	89 e5                	mov    %esp,%ebp
  802224:	53                   	push   %ebx
  802225:	83 ec 10             	sub    $0x10,%esp
  802228:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80222b:	53                   	push   %ebx
  80222c:	e8 d6 08 00 00       	call   802b07 <pageref>
  802231:	83 c4 10             	add    $0x10,%esp
		return 0;
  802234:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  802239:	83 f8 01             	cmp    $0x1,%eax
  80223c:	74 07                	je     802245 <devsock_close+0x24>
}
  80223e:	89 d0                	mov    %edx,%eax
  802240:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802243:	c9                   	leave  
  802244:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  802245:	83 ec 0c             	sub    $0xc,%esp
  802248:	ff 73 0c             	pushl  0xc(%ebx)
  80224b:	e8 b9 02 00 00       	call   802509 <nsipc_close>
  802250:	89 c2                	mov    %eax,%edx
  802252:	83 c4 10             	add    $0x10,%esp
  802255:	eb e7                	jmp    80223e <devsock_close+0x1d>

00802257 <devsock_write>:
{
  802257:	55                   	push   %ebp
  802258:	89 e5                	mov    %esp,%ebp
  80225a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80225d:	6a 00                	push   $0x0
  80225f:	ff 75 10             	pushl  0x10(%ebp)
  802262:	ff 75 0c             	pushl  0xc(%ebp)
  802265:	8b 45 08             	mov    0x8(%ebp),%eax
  802268:	ff 70 0c             	pushl  0xc(%eax)
  80226b:	e8 76 03 00 00       	call   8025e6 <nsipc_send>
}
  802270:	c9                   	leave  
  802271:	c3                   	ret    

00802272 <devsock_read>:
{
  802272:	55                   	push   %ebp
  802273:	89 e5                	mov    %esp,%ebp
  802275:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802278:	6a 00                	push   $0x0
  80227a:	ff 75 10             	pushl  0x10(%ebp)
  80227d:	ff 75 0c             	pushl  0xc(%ebp)
  802280:	8b 45 08             	mov    0x8(%ebp),%eax
  802283:	ff 70 0c             	pushl  0xc(%eax)
  802286:	e8 ef 02 00 00       	call   80257a <nsipc_recv>
}
  80228b:	c9                   	leave  
  80228c:	c3                   	ret    

0080228d <fd2sockid>:
{
  80228d:	55                   	push   %ebp
  80228e:	89 e5                	mov    %esp,%ebp
  802290:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802293:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802296:	52                   	push   %edx
  802297:	50                   	push   %eax
  802298:	e8 9b f1 ff ff       	call   801438 <fd_lookup>
  80229d:	83 c4 10             	add    $0x10,%esp
  8022a0:	85 c0                	test   %eax,%eax
  8022a2:	78 10                	js     8022b4 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8022a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a7:	8b 0d ac 57 80 00    	mov    0x8057ac,%ecx
  8022ad:	39 08                	cmp    %ecx,(%eax)
  8022af:	75 05                	jne    8022b6 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8022b1:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8022b4:	c9                   	leave  
  8022b5:	c3                   	ret    
		return -E_NOT_SUPP;
  8022b6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8022bb:	eb f7                	jmp    8022b4 <fd2sockid+0x27>

008022bd <alloc_sockfd>:
{
  8022bd:	55                   	push   %ebp
  8022be:	89 e5                	mov    %esp,%ebp
  8022c0:	56                   	push   %esi
  8022c1:	53                   	push   %ebx
  8022c2:	83 ec 1c             	sub    $0x1c,%esp
  8022c5:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8022c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022ca:	50                   	push   %eax
  8022cb:	e8 16 f1 ff ff       	call   8013e6 <fd_alloc>
  8022d0:	89 c3                	mov    %eax,%ebx
  8022d2:	83 c4 10             	add    $0x10,%esp
  8022d5:	85 c0                	test   %eax,%eax
  8022d7:	78 43                	js     80231c <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8022d9:	83 ec 04             	sub    $0x4,%esp
  8022dc:	68 07 04 00 00       	push   $0x407
  8022e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8022e4:	6a 00                	push   $0x0
  8022e6:	e8 ff ed ff ff       	call   8010ea <sys_page_alloc>
  8022eb:	89 c3                	mov    %eax,%ebx
  8022ed:	83 c4 10             	add    $0x10,%esp
  8022f0:	85 c0                	test   %eax,%eax
  8022f2:	78 28                	js     80231c <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8022f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f7:	8b 15 ac 57 80 00    	mov    0x8057ac,%edx
  8022fd:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8022ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802302:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802309:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80230c:	83 ec 0c             	sub    $0xc,%esp
  80230f:	50                   	push   %eax
  802310:	e8 aa f0 ff ff       	call   8013bf <fd2num>
  802315:	89 c3                	mov    %eax,%ebx
  802317:	83 c4 10             	add    $0x10,%esp
  80231a:	eb 0c                	jmp    802328 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80231c:	83 ec 0c             	sub    $0xc,%esp
  80231f:	56                   	push   %esi
  802320:	e8 e4 01 00 00       	call   802509 <nsipc_close>
		return r;
  802325:	83 c4 10             	add    $0x10,%esp
}
  802328:	89 d8                	mov    %ebx,%eax
  80232a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80232d:	5b                   	pop    %ebx
  80232e:	5e                   	pop    %esi
  80232f:	5d                   	pop    %ebp
  802330:	c3                   	ret    

00802331 <accept>:
{
  802331:	55                   	push   %ebp
  802332:	89 e5                	mov    %esp,%ebp
  802334:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802337:	8b 45 08             	mov    0x8(%ebp),%eax
  80233a:	e8 4e ff ff ff       	call   80228d <fd2sockid>
  80233f:	85 c0                	test   %eax,%eax
  802341:	78 1b                	js     80235e <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802343:	83 ec 04             	sub    $0x4,%esp
  802346:	ff 75 10             	pushl  0x10(%ebp)
  802349:	ff 75 0c             	pushl  0xc(%ebp)
  80234c:	50                   	push   %eax
  80234d:	e8 0e 01 00 00       	call   802460 <nsipc_accept>
  802352:	83 c4 10             	add    $0x10,%esp
  802355:	85 c0                	test   %eax,%eax
  802357:	78 05                	js     80235e <accept+0x2d>
	return alloc_sockfd(r);
  802359:	e8 5f ff ff ff       	call   8022bd <alloc_sockfd>
}
  80235e:	c9                   	leave  
  80235f:	c3                   	ret    

00802360 <bind>:
{
  802360:	55                   	push   %ebp
  802361:	89 e5                	mov    %esp,%ebp
  802363:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802366:	8b 45 08             	mov    0x8(%ebp),%eax
  802369:	e8 1f ff ff ff       	call   80228d <fd2sockid>
  80236e:	85 c0                	test   %eax,%eax
  802370:	78 12                	js     802384 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802372:	83 ec 04             	sub    $0x4,%esp
  802375:	ff 75 10             	pushl  0x10(%ebp)
  802378:	ff 75 0c             	pushl  0xc(%ebp)
  80237b:	50                   	push   %eax
  80237c:	e8 31 01 00 00       	call   8024b2 <nsipc_bind>
  802381:	83 c4 10             	add    $0x10,%esp
}
  802384:	c9                   	leave  
  802385:	c3                   	ret    

00802386 <shutdown>:
{
  802386:	55                   	push   %ebp
  802387:	89 e5                	mov    %esp,%ebp
  802389:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80238c:	8b 45 08             	mov    0x8(%ebp),%eax
  80238f:	e8 f9 fe ff ff       	call   80228d <fd2sockid>
  802394:	85 c0                	test   %eax,%eax
  802396:	78 0f                	js     8023a7 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802398:	83 ec 08             	sub    $0x8,%esp
  80239b:	ff 75 0c             	pushl  0xc(%ebp)
  80239e:	50                   	push   %eax
  80239f:	e8 43 01 00 00       	call   8024e7 <nsipc_shutdown>
  8023a4:	83 c4 10             	add    $0x10,%esp
}
  8023a7:	c9                   	leave  
  8023a8:	c3                   	ret    

008023a9 <connect>:
{
  8023a9:	55                   	push   %ebp
  8023aa:	89 e5                	mov    %esp,%ebp
  8023ac:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8023af:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b2:	e8 d6 fe ff ff       	call   80228d <fd2sockid>
  8023b7:	85 c0                	test   %eax,%eax
  8023b9:	78 12                	js     8023cd <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8023bb:	83 ec 04             	sub    $0x4,%esp
  8023be:	ff 75 10             	pushl  0x10(%ebp)
  8023c1:	ff 75 0c             	pushl  0xc(%ebp)
  8023c4:	50                   	push   %eax
  8023c5:	e8 59 01 00 00       	call   802523 <nsipc_connect>
  8023ca:	83 c4 10             	add    $0x10,%esp
}
  8023cd:	c9                   	leave  
  8023ce:	c3                   	ret    

008023cf <listen>:
{
  8023cf:	55                   	push   %ebp
  8023d0:	89 e5                	mov    %esp,%ebp
  8023d2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8023d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d8:	e8 b0 fe ff ff       	call   80228d <fd2sockid>
  8023dd:	85 c0                	test   %eax,%eax
  8023df:	78 0f                	js     8023f0 <listen+0x21>
	return nsipc_listen(r, backlog);
  8023e1:	83 ec 08             	sub    $0x8,%esp
  8023e4:	ff 75 0c             	pushl  0xc(%ebp)
  8023e7:	50                   	push   %eax
  8023e8:	e8 6b 01 00 00       	call   802558 <nsipc_listen>
  8023ed:	83 c4 10             	add    $0x10,%esp
}
  8023f0:	c9                   	leave  
  8023f1:	c3                   	ret    

008023f2 <socket>:

int
socket(int domain, int type, int protocol)
{
  8023f2:	55                   	push   %ebp
  8023f3:	89 e5                	mov    %esp,%ebp
  8023f5:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8023f8:	ff 75 10             	pushl  0x10(%ebp)
  8023fb:	ff 75 0c             	pushl  0xc(%ebp)
  8023fe:	ff 75 08             	pushl  0x8(%ebp)
  802401:	e8 3e 02 00 00       	call   802644 <nsipc_socket>
  802406:	83 c4 10             	add    $0x10,%esp
  802409:	85 c0                	test   %eax,%eax
  80240b:	78 05                	js     802412 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80240d:	e8 ab fe ff ff       	call   8022bd <alloc_sockfd>
}
  802412:	c9                   	leave  
  802413:	c3                   	ret    

00802414 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802414:	55                   	push   %ebp
  802415:	89 e5                	mov    %esp,%ebp
  802417:	53                   	push   %ebx
  802418:	83 ec 04             	sub    $0x4,%esp
  80241b:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80241d:	83 3d 04 60 80 00 00 	cmpl   $0x0,0x806004
  802424:	74 26                	je     80244c <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802426:	6a 07                	push   $0x7
  802428:	68 00 90 80 00       	push   $0x809000
  80242d:	53                   	push   %ebx
  80242e:	ff 35 04 60 80 00    	pushl  0x806004
  802434:	e8 3b 06 00 00       	call   802a74 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802439:	83 c4 0c             	add    $0xc,%esp
  80243c:	6a 00                	push   $0x0
  80243e:	6a 00                	push   $0x0
  802440:	6a 00                	push   $0x0
  802442:	e8 c4 05 00 00       	call   802a0b <ipc_recv>
}
  802447:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80244a:	c9                   	leave  
  80244b:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80244c:	83 ec 0c             	sub    $0xc,%esp
  80244f:	6a 02                	push   $0x2
  802451:	e8 76 06 00 00       	call   802acc <ipc_find_env>
  802456:	a3 04 60 80 00       	mov    %eax,0x806004
  80245b:	83 c4 10             	add    $0x10,%esp
  80245e:	eb c6                	jmp    802426 <nsipc+0x12>

00802460 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802460:	55                   	push   %ebp
  802461:	89 e5                	mov    %esp,%ebp
  802463:	56                   	push   %esi
  802464:	53                   	push   %ebx
  802465:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802468:	8b 45 08             	mov    0x8(%ebp),%eax
  80246b:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802470:	8b 06                	mov    (%esi),%eax
  802472:	a3 04 90 80 00       	mov    %eax,0x809004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802477:	b8 01 00 00 00       	mov    $0x1,%eax
  80247c:	e8 93 ff ff ff       	call   802414 <nsipc>
  802481:	89 c3                	mov    %eax,%ebx
  802483:	85 c0                	test   %eax,%eax
  802485:	79 09                	jns    802490 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802487:	89 d8                	mov    %ebx,%eax
  802489:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80248c:	5b                   	pop    %ebx
  80248d:	5e                   	pop    %esi
  80248e:	5d                   	pop    %ebp
  80248f:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802490:	83 ec 04             	sub    $0x4,%esp
  802493:	ff 35 10 90 80 00    	pushl  0x809010
  802499:	68 00 90 80 00       	push   $0x809000
  80249e:	ff 75 0c             	pushl  0xc(%ebp)
  8024a1:	e8 e0 e9 ff ff       	call   800e86 <memmove>
		*addrlen = ret->ret_addrlen;
  8024a6:	a1 10 90 80 00       	mov    0x809010,%eax
  8024ab:	89 06                	mov    %eax,(%esi)
  8024ad:	83 c4 10             	add    $0x10,%esp
	return r;
  8024b0:	eb d5                	jmp    802487 <nsipc_accept+0x27>

008024b2 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8024b2:	55                   	push   %ebp
  8024b3:	89 e5                	mov    %esp,%ebp
  8024b5:	53                   	push   %ebx
  8024b6:	83 ec 08             	sub    $0x8,%esp
  8024b9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8024bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bf:	a3 00 90 80 00       	mov    %eax,0x809000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8024c4:	53                   	push   %ebx
  8024c5:	ff 75 0c             	pushl  0xc(%ebp)
  8024c8:	68 04 90 80 00       	push   $0x809004
  8024cd:	e8 b4 e9 ff ff       	call   800e86 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8024d2:	89 1d 14 90 80 00    	mov    %ebx,0x809014
	return nsipc(NSREQ_BIND);
  8024d8:	b8 02 00 00 00       	mov    $0x2,%eax
  8024dd:	e8 32 ff ff ff       	call   802414 <nsipc>
}
  8024e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024e5:	c9                   	leave  
  8024e6:	c3                   	ret    

008024e7 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8024e7:	55                   	push   %ebp
  8024e8:	89 e5                	mov    %esp,%ebp
  8024ea:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8024ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f0:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.shutdown.req_how = how;
  8024f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024f8:	a3 04 90 80 00       	mov    %eax,0x809004
	return nsipc(NSREQ_SHUTDOWN);
  8024fd:	b8 03 00 00 00       	mov    $0x3,%eax
  802502:	e8 0d ff ff ff       	call   802414 <nsipc>
}
  802507:	c9                   	leave  
  802508:	c3                   	ret    

00802509 <nsipc_close>:

int
nsipc_close(int s)
{
  802509:	55                   	push   %ebp
  80250a:	89 e5                	mov    %esp,%ebp
  80250c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80250f:	8b 45 08             	mov    0x8(%ebp),%eax
  802512:	a3 00 90 80 00       	mov    %eax,0x809000
	return nsipc(NSREQ_CLOSE);
  802517:	b8 04 00 00 00       	mov    $0x4,%eax
  80251c:	e8 f3 fe ff ff       	call   802414 <nsipc>
}
  802521:	c9                   	leave  
  802522:	c3                   	ret    

00802523 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802523:	55                   	push   %ebp
  802524:	89 e5                	mov    %esp,%ebp
  802526:	53                   	push   %ebx
  802527:	83 ec 08             	sub    $0x8,%esp
  80252a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80252d:	8b 45 08             	mov    0x8(%ebp),%eax
  802530:	a3 00 90 80 00       	mov    %eax,0x809000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802535:	53                   	push   %ebx
  802536:	ff 75 0c             	pushl  0xc(%ebp)
  802539:	68 04 90 80 00       	push   $0x809004
  80253e:	e8 43 e9 ff ff       	call   800e86 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802543:	89 1d 14 90 80 00    	mov    %ebx,0x809014
	return nsipc(NSREQ_CONNECT);
  802549:	b8 05 00 00 00       	mov    $0x5,%eax
  80254e:	e8 c1 fe ff ff       	call   802414 <nsipc>
}
  802553:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802556:	c9                   	leave  
  802557:	c3                   	ret    

00802558 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802558:	55                   	push   %ebp
  802559:	89 e5                	mov    %esp,%ebp
  80255b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80255e:	8b 45 08             	mov    0x8(%ebp),%eax
  802561:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.listen.req_backlog = backlog;
  802566:	8b 45 0c             	mov    0xc(%ebp),%eax
  802569:	a3 04 90 80 00       	mov    %eax,0x809004
	return nsipc(NSREQ_LISTEN);
  80256e:	b8 06 00 00 00       	mov    $0x6,%eax
  802573:	e8 9c fe ff ff       	call   802414 <nsipc>
}
  802578:	c9                   	leave  
  802579:	c3                   	ret    

0080257a <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80257a:	55                   	push   %ebp
  80257b:	89 e5                	mov    %esp,%ebp
  80257d:	56                   	push   %esi
  80257e:	53                   	push   %ebx
  80257f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802582:	8b 45 08             	mov    0x8(%ebp),%eax
  802585:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.recv.req_len = len;
  80258a:	89 35 04 90 80 00    	mov    %esi,0x809004
	nsipcbuf.recv.req_flags = flags;
  802590:	8b 45 14             	mov    0x14(%ebp),%eax
  802593:	a3 08 90 80 00       	mov    %eax,0x809008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802598:	b8 07 00 00 00       	mov    $0x7,%eax
  80259d:	e8 72 fe ff ff       	call   802414 <nsipc>
  8025a2:	89 c3                	mov    %eax,%ebx
  8025a4:	85 c0                	test   %eax,%eax
  8025a6:	78 1f                	js     8025c7 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8025a8:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8025ad:	7f 21                	jg     8025d0 <nsipc_recv+0x56>
  8025af:	39 c6                	cmp    %eax,%esi
  8025b1:	7c 1d                	jl     8025d0 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8025b3:	83 ec 04             	sub    $0x4,%esp
  8025b6:	50                   	push   %eax
  8025b7:	68 00 90 80 00       	push   $0x809000
  8025bc:	ff 75 0c             	pushl  0xc(%ebp)
  8025bf:	e8 c2 e8 ff ff       	call   800e86 <memmove>
  8025c4:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8025c7:	89 d8                	mov    %ebx,%eax
  8025c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025cc:	5b                   	pop    %ebx
  8025cd:	5e                   	pop    %esi
  8025ce:	5d                   	pop    %ebp
  8025cf:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8025d0:	68 e2 34 80 00       	push   $0x8034e2
  8025d5:	68 cb 33 80 00       	push   $0x8033cb
  8025da:	6a 62                	push   $0x62
  8025dc:	68 f7 34 80 00       	push   $0x8034f7
  8025e1:	e8 bd de ff ff       	call   8004a3 <_panic>

008025e6 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8025e6:	55                   	push   %ebp
  8025e7:	89 e5                	mov    %esp,%ebp
  8025e9:	53                   	push   %ebx
  8025ea:	83 ec 04             	sub    $0x4,%esp
  8025ed:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8025f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f3:	a3 00 90 80 00       	mov    %eax,0x809000
	assert(size < 1600);
  8025f8:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8025fe:	7f 2e                	jg     80262e <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802600:	83 ec 04             	sub    $0x4,%esp
  802603:	53                   	push   %ebx
  802604:	ff 75 0c             	pushl  0xc(%ebp)
  802607:	68 0c 90 80 00       	push   $0x80900c
  80260c:	e8 75 e8 ff ff       	call   800e86 <memmove>
	nsipcbuf.send.req_size = size;
  802611:	89 1d 04 90 80 00    	mov    %ebx,0x809004
	nsipcbuf.send.req_flags = flags;
  802617:	8b 45 14             	mov    0x14(%ebp),%eax
  80261a:	a3 08 90 80 00       	mov    %eax,0x809008
	return nsipc(NSREQ_SEND);
  80261f:	b8 08 00 00 00       	mov    $0x8,%eax
  802624:	e8 eb fd ff ff       	call   802414 <nsipc>
}
  802629:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80262c:	c9                   	leave  
  80262d:	c3                   	ret    
	assert(size < 1600);
  80262e:	68 03 35 80 00       	push   $0x803503
  802633:	68 cb 33 80 00       	push   $0x8033cb
  802638:	6a 6d                	push   $0x6d
  80263a:	68 f7 34 80 00       	push   $0x8034f7
  80263f:	e8 5f de ff ff       	call   8004a3 <_panic>

00802644 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802644:	55                   	push   %ebp
  802645:	89 e5                	mov    %esp,%ebp
  802647:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80264a:	8b 45 08             	mov    0x8(%ebp),%eax
  80264d:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.socket.req_type = type;
  802652:	8b 45 0c             	mov    0xc(%ebp),%eax
  802655:	a3 04 90 80 00       	mov    %eax,0x809004
	nsipcbuf.socket.req_protocol = protocol;
  80265a:	8b 45 10             	mov    0x10(%ebp),%eax
  80265d:	a3 08 90 80 00       	mov    %eax,0x809008
	return nsipc(NSREQ_SOCKET);
  802662:	b8 09 00 00 00       	mov    $0x9,%eax
  802667:	e8 a8 fd ff ff       	call   802414 <nsipc>
}
  80266c:	c9                   	leave  
  80266d:	c3                   	ret    

0080266e <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80266e:	55                   	push   %ebp
  80266f:	89 e5                	mov    %esp,%ebp
  802671:	56                   	push   %esi
  802672:	53                   	push   %ebx
  802673:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802676:	83 ec 0c             	sub    $0xc,%esp
  802679:	ff 75 08             	pushl  0x8(%ebp)
  80267c:	e8 4e ed ff ff       	call   8013cf <fd2data>
  802681:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802683:	83 c4 08             	add    $0x8,%esp
  802686:	68 0f 35 80 00       	push   $0x80350f
  80268b:	53                   	push   %ebx
  80268c:	e8 67 e6 ff ff       	call   800cf8 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802691:	8b 46 04             	mov    0x4(%esi),%eax
  802694:	2b 06                	sub    (%esi),%eax
  802696:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80269c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8026a3:	00 00 00 
	stat->st_dev = &devpipe;
  8026a6:	c7 83 88 00 00 00 c8 	movl   $0x8057c8,0x88(%ebx)
  8026ad:	57 80 00 
	return 0;
}
  8026b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026b8:	5b                   	pop    %ebx
  8026b9:	5e                   	pop    %esi
  8026ba:	5d                   	pop    %ebp
  8026bb:	c3                   	ret    

008026bc <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8026bc:	55                   	push   %ebp
  8026bd:	89 e5                	mov    %esp,%ebp
  8026bf:	53                   	push   %ebx
  8026c0:	83 ec 0c             	sub    $0xc,%esp
  8026c3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8026c6:	53                   	push   %ebx
  8026c7:	6a 00                	push   $0x0
  8026c9:	e8 a1 ea ff ff       	call   80116f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8026ce:	89 1c 24             	mov    %ebx,(%esp)
  8026d1:	e8 f9 ec ff ff       	call   8013cf <fd2data>
  8026d6:	83 c4 08             	add    $0x8,%esp
  8026d9:	50                   	push   %eax
  8026da:	6a 00                	push   $0x0
  8026dc:	e8 8e ea ff ff       	call   80116f <sys_page_unmap>
}
  8026e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026e4:	c9                   	leave  
  8026e5:	c3                   	ret    

008026e6 <_pipeisclosed>:
{
  8026e6:	55                   	push   %ebp
  8026e7:	89 e5                	mov    %esp,%ebp
  8026e9:	57                   	push   %edi
  8026ea:	56                   	push   %esi
  8026eb:	53                   	push   %ebx
  8026ec:	83 ec 1c             	sub    $0x1c,%esp
  8026ef:	89 c7                	mov    %eax,%edi
  8026f1:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8026f3:	a1 90 77 80 00       	mov    0x807790,%eax
  8026f8:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8026fb:	83 ec 0c             	sub    $0xc,%esp
  8026fe:	57                   	push   %edi
  8026ff:	e8 03 04 00 00       	call   802b07 <pageref>
  802704:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802707:	89 34 24             	mov    %esi,(%esp)
  80270a:	e8 f8 03 00 00       	call   802b07 <pageref>
		nn = thisenv->env_runs;
  80270f:	8b 15 90 77 80 00    	mov    0x807790,%edx
  802715:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802718:	83 c4 10             	add    $0x10,%esp
  80271b:	39 cb                	cmp    %ecx,%ebx
  80271d:	74 1b                	je     80273a <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80271f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802722:	75 cf                	jne    8026f3 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802724:	8b 42 58             	mov    0x58(%edx),%eax
  802727:	6a 01                	push   $0x1
  802729:	50                   	push   %eax
  80272a:	53                   	push   %ebx
  80272b:	68 16 35 80 00       	push   $0x803516
  802730:	e8 64 de ff ff       	call   800599 <cprintf>
  802735:	83 c4 10             	add    $0x10,%esp
  802738:	eb b9                	jmp    8026f3 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80273a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80273d:	0f 94 c0             	sete   %al
  802740:	0f b6 c0             	movzbl %al,%eax
}
  802743:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802746:	5b                   	pop    %ebx
  802747:	5e                   	pop    %esi
  802748:	5f                   	pop    %edi
  802749:	5d                   	pop    %ebp
  80274a:	c3                   	ret    

0080274b <devpipe_write>:
{
  80274b:	55                   	push   %ebp
  80274c:	89 e5                	mov    %esp,%ebp
  80274e:	57                   	push   %edi
  80274f:	56                   	push   %esi
  802750:	53                   	push   %ebx
  802751:	83 ec 28             	sub    $0x28,%esp
  802754:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802757:	56                   	push   %esi
  802758:	e8 72 ec ff ff       	call   8013cf <fd2data>
  80275d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80275f:	83 c4 10             	add    $0x10,%esp
  802762:	bf 00 00 00 00       	mov    $0x0,%edi
  802767:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80276a:	74 4f                	je     8027bb <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80276c:	8b 43 04             	mov    0x4(%ebx),%eax
  80276f:	8b 0b                	mov    (%ebx),%ecx
  802771:	8d 51 20             	lea    0x20(%ecx),%edx
  802774:	39 d0                	cmp    %edx,%eax
  802776:	72 14                	jb     80278c <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802778:	89 da                	mov    %ebx,%edx
  80277a:	89 f0                	mov    %esi,%eax
  80277c:	e8 65 ff ff ff       	call   8026e6 <_pipeisclosed>
  802781:	85 c0                	test   %eax,%eax
  802783:	75 3b                	jne    8027c0 <devpipe_write+0x75>
			sys_yield();
  802785:	e8 41 e9 ff ff       	call   8010cb <sys_yield>
  80278a:	eb e0                	jmp    80276c <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80278c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80278f:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802793:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802796:	89 c2                	mov    %eax,%edx
  802798:	c1 fa 1f             	sar    $0x1f,%edx
  80279b:	89 d1                	mov    %edx,%ecx
  80279d:	c1 e9 1b             	shr    $0x1b,%ecx
  8027a0:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8027a3:	83 e2 1f             	and    $0x1f,%edx
  8027a6:	29 ca                	sub    %ecx,%edx
  8027a8:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8027ac:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8027b0:	83 c0 01             	add    $0x1,%eax
  8027b3:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8027b6:	83 c7 01             	add    $0x1,%edi
  8027b9:	eb ac                	jmp    802767 <devpipe_write+0x1c>
	return i;
  8027bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8027be:	eb 05                	jmp    8027c5 <devpipe_write+0x7a>
				return 0;
  8027c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027c8:	5b                   	pop    %ebx
  8027c9:	5e                   	pop    %esi
  8027ca:	5f                   	pop    %edi
  8027cb:	5d                   	pop    %ebp
  8027cc:	c3                   	ret    

008027cd <devpipe_read>:
{
  8027cd:	55                   	push   %ebp
  8027ce:	89 e5                	mov    %esp,%ebp
  8027d0:	57                   	push   %edi
  8027d1:	56                   	push   %esi
  8027d2:	53                   	push   %ebx
  8027d3:	83 ec 18             	sub    $0x18,%esp
  8027d6:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8027d9:	57                   	push   %edi
  8027da:	e8 f0 eb ff ff       	call   8013cf <fd2data>
  8027df:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8027e1:	83 c4 10             	add    $0x10,%esp
  8027e4:	be 00 00 00 00       	mov    $0x0,%esi
  8027e9:	3b 75 10             	cmp    0x10(%ebp),%esi
  8027ec:	75 14                	jne    802802 <devpipe_read+0x35>
	return i;
  8027ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8027f1:	eb 02                	jmp    8027f5 <devpipe_read+0x28>
				return i;
  8027f3:	89 f0                	mov    %esi,%eax
}
  8027f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027f8:	5b                   	pop    %ebx
  8027f9:	5e                   	pop    %esi
  8027fa:	5f                   	pop    %edi
  8027fb:	5d                   	pop    %ebp
  8027fc:	c3                   	ret    
			sys_yield();
  8027fd:	e8 c9 e8 ff ff       	call   8010cb <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802802:	8b 03                	mov    (%ebx),%eax
  802804:	3b 43 04             	cmp    0x4(%ebx),%eax
  802807:	75 18                	jne    802821 <devpipe_read+0x54>
			if (i > 0)
  802809:	85 f6                	test   %esi,%esi
  80280b:	75 e6                	jne    8027f3 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80280d:	89 da                	mov    %ebx,%edx
  80280f:	89 f8                	mov    %edi,%eax
  802811:	e8 d0 fe ff ff       	call   8026e6 <_pipeisclosed>
  802816:	85 c0                	test   %eax,%eax
  802818:	74 e3                	je     8027fd <devpipe_read+0x30>
				return 0;
  80281a:	b8 00 00 00 00       	mov    $0x0,%eax
  80281f:	eb d4                	jmp    8027f5 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802821:	99                   	cltd   
  802822:	c1 ea 1b             	shr    $0x1b,%edx
  802825:	01 d0                	add    %edx,%eax
  802827:	83 e0 1f             	and    $0x1f,%eax
  80282a:	29 d0                	sub    %edx,%eax
  80282c:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802831:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802834:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802837:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80283a:	83 c6 01             	add    $0x1,%esi
  80283d:	eb aa                	jmp    8027e9 <devpipe_read+0x1c>

0080283f <pipe>:
{
  80283f:	55                   	push   %ebp
  802840:	89 e5                	mov    %esp,%ebp
  802842:	56                   	push   %esi
  802843:	53                   	push   %ebx
  802844:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802847:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80284a:	50                   	push   %eax
  80284b:	e8 96 eb ff ff       	call   8013e6 <fd_alloc>
  802850:	89 c3                	mov    %eax,%ebx
  802852:	83 c4 10             	add    $0x10,%esp
  802855:	85 c0                	test   %eax,%eax
  802857:	0f 88 23 01 00 00    	js     802980 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80285d:	83 ec 04             	sub    $0x4,%esp
  802860:	68 07 04 00 00       	push   $0x407
  802865:	ff 75 f4             	pushl  -0xc(%ebp)
  802868:	6a 00                	push   $0x0
  80286a:	e8 7b e8 ff ff       	call   8010ea <sys_page_alloc>
  80286f:	89 c3                	mov    %eax,%ebx
  802871:	83 c4 10             	add    $0x10,%esp
  802874:	85 c0                	test   %eax,%eax
  802876:	0f 88 04 01 00 00    	js     802980 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80287c:	83 ec 0c             	sub    $0xc,%esp
  80287f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802882:	50                   	push   %eax
  802883:	e8 5e eb ff ff       	call   8013e6 <fd_alloc>
  802888:	89 c3                	mov    %eax,%ebx
  80288a:	83 c4 10             	add    $0x10,%esp
  80288d:	85 c0                	test   %eax,%eax
  80288f:	0f 88 db 00 00 00    	js     802970 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802895:	83 ec 04             	sub    $0x4,%esp
  802898:	68 07 04 00 00       	push   $0x407
  80289d:	ff 75 f0             	pushl  -0x10(%ebp)
  8028a0:	6a 00                	push   $0x0
  8028a2:	e8 43 e8 ff ff       	call   8010ea <sys_page_alloc>
  8028a7:	89 c3                	mov    %eax,%ebx
  8028a9:	83 c4 10             	add    $0x10,%esp
  8028ac:	85 c0                	test   %eax,%eax
  8028ae:	0f 88 bc 00 00 00    	js     802970 <pipe+0x131>
	va = fd2data(fd0);
  8028b4:	83 ec 0c             	sub    $0xc,%esp
  8028b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8028ba:	e8 10 eb ff ff       	call   8013cf <fd2data>
  8028bf:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028c1:	83 c4 0c             	add    $0xc,%esp
  8028c4:	68 07 04 00 00       	push   $0x407
  8028c9:	50                   	push   %eax
  8028ca:	6a 00                	push   $0x0
  8028cc:	e8 19 e8 ff ff       	call   8010ea <sys_page_alloc>
  8028d1:	89 c3                	mov    %eax,%ebx
  8028d3:	83 c4 10             	add    $0x10,%esp
  8028d6:	85 c0                	test   %eax,%eax
  8028d8:	0f 88 82 00 00 00    	js     802960 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028de:	83 ec 0c             	sub    $0xc,%esp
  8028e1:	ff 75 f0             	pushl  -0x10(%ebp)
  8028e4:	e8 e6 ea ff ff       	call   8013cf <fd2data>
  8028e9:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8028f0:	50                   	push   %eax
  8028f1:	6a 00                	push   $0x0
  8028f3:	56                   	push   %esi
  8028f4:	6a 00                	push   $0x0
  8028f6:	e8 32 e8 ff ff       	call   80112d <sys_page_map>
  8028fb:	89 c3                	mov    %eax,%ebx
  8028fd:	83 c4 20             	add    $0x20,%esp
  802900:	85 c0                	test   %eax,%eax
  802902:	78 4e                	js     802952 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802904:	a1 c8 57 80 00       	mov    0x8057c8,%eax
  802909:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80290c:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80290e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802911:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802918:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80291b:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80291d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802920:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802927:	83 ec 0c             	sub    $0xc,%esp
  80292a:	ff 75 f4             	pushl  -0xc(%ebp)
  80292d:	e8 8d ea ff ff       	call   8013bf <fd2num>
  802932:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802935:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802937:	83 c4 04             	add    $0x4,%esp
  80293a:	ff 75 f0             	pushl  -0x10(%ebp)
  80293d:	e8 7d ea ff ff       	call   8013bf <fd2num>
  802942:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802945:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802948:	83 c4 10             	add    $0x10,%esp
  80294b:	bb 00 00 00 00       	mov    $0x0,%ebx
  802950:	eb 2e                	jmp    802980 <pipe+0x141>
	sys_page_unmap(0, va);
  802952:	83 ec 08             	sub    $0x8,%esp
  802955:	56                   	push   %esi
  802956:	6a 00                	push   $0x0
  802958:	e8 12 e8 ff ff       	call   80116f <sys_page_unmap>
  80295d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802960:	83 ec 08             	sub    $0x8,%esp
  802963:	ff 75 f0             	pushl  -0x10(%ebp)
  802966:	6a 00                	push   $0x0
  802968:	e8 02 e8 ff ff       	call   80116f <sys_page_unmap>
  80296d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802970:	83 ec 08             	sub    $0x8,%esp
  802973:	ff 75 f4             	pushl  -0xc(%ebp)
  802976:	6a 00                	push   $0x0
  802978:	e8 f2 e7 ff ff       	call   80116f <sys_page_unmap>
  80297d:	83 c4 10             	add    $0x10,%esp
}
  802980:	89 d8                	mov    %ebx,%eax
  802982:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802985:	5b                   	pop    %ebx
  802986:	5e                   	pop    %esi
  802987:	5d                   	pop    %ebp
  802988:	c3                   	ret    

00802989 <pipeisclosed>:
{
  802989:	55                   	push   %ebp
  80298a:	89 e5                	mov    %esp,%ebp
  80298c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80298f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802992:	50                   	push   %eax
  802993:	ff 75 08             	pushl  0x8(%ebp)
  802996:	e8 9d ea ff ff       	call   801438 <fd_lookup>
  80299b:	83 c4 10             	add    $0x10,%esp
  80299e:	85 c0                	test   %eax,%eax
  8029a0:	78 18                	js     8029ba <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8029a2:	83 ec 0c             	sub    $0xc,%esp
  8029a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8029a8:	e8 22 ea ff ff       	call   8013cf <fd2data>
	return _pipeisclosed(fd, p);
  8029ad:	89 c2                	mov    %eax,%edx
  8029af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b2:	e8 2f fd ff ff       	call   8026e6 <_pipeisclosed>
  8029b7:	83 c4 10             	add    $0x10,%esp
}
  8029ba:	c9                   	leave  
  8029bb:	c3                   	ret    

008029bc <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8029bc:	55                   	push   %ebp
  8029bd:	89 e5                	mov    %esp,%ebp
  8029bf:	56                   	push   %esi
  8029c0:	53                   	push   %ebx
  8029c1:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  8029c4:	85 f6                	test   %esi,%esi
  8029c6:	74 13                	je     8029db <wait+0x1f>
	e = &envs[ENVX(envid)];
  8029c8:	89 f3                	mov    %esi,%ebx
  8029ca:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8029d0:	c1 e3 07             	shl    $0x7,%ebx
  8029d3:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8029d9:	eb 1b                	jmp    8029f6 <wait+0x3a>
	assert(envid != 0);
  8029db:	68 2e 35 80 00       	push   $0x80352e
  8029e0:	68 cb 33 80 00       	push   $0x8033cb
  8029e5:	6a 09                	push   $0x9
  8029e7:	68 39 35 80 00       	push   $0x803539
  8029ec:	e8 b2 da ff ff       	call   8004a3 <_panic>
		sys_yield();
  8029f1:	e8 d5 e6 ff ff       	call   8010cb <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8029f6:	8b 43 48             	mov    0x48(%ebx),%eax
  8029f9:	39 f0                	cmp    %esi,%eax
  8029fb:	75 07                	jne    802a04 <wait+0x48>
  8029fd:	8b 43 54             	mov    0x54(%ebx),%eax
  802a00:	85 c0                	test   %eax,%eax
  802a02:	75 ed                	jne    8029f1 <wait+0x35>
}
  802a04:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a07:	5b                   	pop    %ebx
  802a08:	5e                   	pop    %esi
  802a09:	5d                   	pop    %ebp
  802a0a:	c3                   	ret    

00802a0b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802a0b:	55                   	push   %ebp
  802a0c:	89 e5                	mov    %esp,%ebp
  802a0e:	56                   	push   %esi
  802a0f:	53                   	push   %ebx
  802a10:	8b 75 08             	mov    0x8(%ebp),%esi
  802a13:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a16:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802a19:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802a1b:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802a20:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802a23:	83 ec 0c             	sub    $0xc,%esp
  802a26:	50                   	push   %eax
  802a27:	e8 6e e8 ff ff       	call   80129a <sys_ipc_recv>
	if(ret < 0){
  802a2c:	83 c4 10             	add    $0x10,%esp
  802a2f:	85 c0                	test   %eax,%eax
  802a31:	78 2b                	js     802a5e <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802a33:	85 f6                	test   %esi,%esi
  802a35:	74 0a                	je     802a41 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802a37:	a1 90 77 80 00       	mov    0x807790,%eax
  802a3c:	8b 40 74             	mov    0x74(%eax),%eax
  802a3f:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802a41:	85 db                	test   %ebx,%ebx
  802a43:	74 0a                	je     802a4f <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802a45:	a1 90 77 80 00       	mov    0x807790,%eax
  802a4a:	8b 40 78             	mov    0x78(%eax),%eax
  802a4d:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802a4f:	a1 90 77 80 00       	mov    0x807790,%eax
  802a54:	8b 40 70             	mov    0x70(%eax),%eax
}
  802a57:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a5a:	5b                   	pop    %ebx
  802a5b:	5e                   	pop    %esi
  802a5c:	5d                   	pop    %ebp
  802a5d:	c3                   	ret    
		if(from_env_store)
  802a5e:	85 f6                	test   %esi,%esi
  802a60:	74 06                	je     802a68 <ipc_recv+0x5d>
			*from_env_store = 0;
  802a62:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802a68:	85 db                	test   %ebx,%ebx
  802a6a:	74 eb                	je     802a57 <ipc_recv+0x4c>
			*perm_store = 0;
  802a6c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802a72:	eb e3                	jmp    802a57 <ipc_recv+0x4c>

00802a74 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802a74:	55                   	push   %ebp
  802a75:	89 e5                	mov    %esp,%ebp
  802a77:	57                   	push   %edi
  802a78:	56                   	push   %esi
  802a79:	53                   	push   %ebx
  802a7a:	83 ec 0c             	sub    $0xc,%esp
  802a7d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802a80:	8b 75 0c             	mov    0xc(%ebp),%esi
  802a83:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802a86:	85 db                	test   %ebx,%ebx
  802a88:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802a8d:	0f 44 d8             	cmove  %eax,%ebx
  802a90:	eb 05                	jmp    802a97 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802a92:	e8 34 e6 ff ff       	call   8010cb <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802a97:	ff 75 14             	pushl  0x14(%ebp)
  802a9a:	53                   	push   %ebx
  802a9b:	56                   	push   %esi
  802a9c:	57                   	push   %edi
  802a9d:	e8 d5 e7 ff ff       	call   801277 <sys_ipc_try_send>
  802aa2:	83 c4 10             	add    $0x10,%esp
  802aa5:	85 c0                	test   %eax,%eax
  802aa7:	74 1b                	je     802ac4 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802aa9:	79 e7                	jns    802a92 <ipc_send+0x1e>
  802aab:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802aae:	74 e2                	je     802a92 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802ab0:	83 ec 04             	sub    $0x4,%esp
  802ab3:	68 44 35 80 00       	push   $0x803544
  802ab8:	6a 46                	push   $0x46
  802aba:	68 59 35 80 00       	push   $0x803559
  802abf:	e8 df d9 ff ff       	call   8004a3 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802ac4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802ac7:	5b                   	pop    %ebx
  802ac8:	5e                   	pop    %esi
  802ac9:	5f                   	pop    %edi
  802aca:	5d                   	pop    %ebp
  802acb:	c3                   	ret    

00802acc <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802acc:	55                   	push   %ebp
  802acd:	89 e5                	mov    %esp,%ebp
  802acf:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802ad2:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802ad7:	89 c2                	mov    %eax,%edx
  802ad9:	c1 e2 07             	shl    $0x7,%edx
  802adc:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802ae2:	8b 52 50             	mov    0x50(%edx),%edx
  802ae5:	39 ca                	cmp    %ecx,%edx
  802ae7:	74 11                	je     802afa <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802ae9:	83 c0 01             	add    $0x1,%eax
  802aec:	3d 00 04 00 00       	cmp    $0x400,%eax
  802af1:	75 e4                	jne    802ad7 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802af3:	b8 00 00 00 00       	mov    $0x0,%eax
  802af8:	eb 0b                	jmp    802b05 <ipc_find_env+0x39>
			return envs[i].env_id;
  802afa:	c1 e0 07             	shl    $0x7,%eax
  802afd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802b02:	8b 40 48             	mov    0x48(%eax),%eax
}
  802b05:	5d                   	pop    %ebp
  802b06:	c3                   	ret    

00802b07 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802b07:	55                   	push   %ebp
  802b08:	89 e5                	mov    %esp,%ebp
  802b0a:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b0d:	89 d0                	mov    %edx,%eax
  802b0f:	c1 e8 16             	shr    $0x16,%eax
  802b12:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802b19:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802b1e:	f6 c1 01             	test   $0x1,%cl
  802b21:	74 1d                	je     802b40 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802b23:	c1 ea 0c             	shr    $0xc,%edx
  802b26:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802b2d:	f6 c2 01             	test   $0x1,%dl
  802b30:	74 0e                	je     802b40 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802b32:	c1 ea 0c             	shr    $0xc,%edx
  802b35:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802b3c:	ef 
  802b3d:	0f b7 c0             	movzwl %ax,%eax
}
  802b40:	5d                   	pop    %ebp
  802b41:	c3                   	ret    
  802b42:	66 90                	xchg   %ax,%ax
  802b44:	66 90                	xchg   %ax,%ax
  802b46:	66 90                	xchg   %ax,%ax
  802b48:	66 90                	xchg   %ax,%ax
  802b4a:	66 90                	xchg   %ax,%ax
  802b4c:	66 90                	xchg   %ax,%ax
  802b4e:	66 90                	xchg   %ax,%ax

00802b50 <__udivdi3>:
  802b50:	55                   	push   %ebp
  802b51:	57                   	push   %edi
  802b52:	56                   	push   %esi
  802b53:	53                   	push   %ebx
  802b54:	83 ec 1c             	sub    $0x1c,%esp
  802b57:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802b5b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802b5f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802b63:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802b67:	85 d2                	test   %edx,%edx
  802b69:	75 4d                	jne    802bb8 <__udivdi3+0x68>
  802b6b:	39 f3                	cmp    %esi,%ebx
  802b6d:	76 19                	jbe    802b88 <__udivdi3+0x38>
  802b6f:	31 ff                	xor    %edi,%edi
  802b71:	89 e8                	mov    %ebp,%eax
  802b73:	89 f2                	mov    %esi,%edx
  802b75:	f7 f3                	div    %ebx
  802b77:	89 fa                	mov    %edi,%edx
  802b79:	83 c4 1c             	add    $0x1c,%esp
  802b7c:	5b                   	pop    %ebx
  802b7d:	5e                   	pop    %esi
  802b7e:	5f                   	pop    %edi
  802b7f:	5d                   	pop    %ebp
  802b80:	c3                   	ret    
  802b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b88:	89 d9                	mov    %ebx,%ecx
  802b8a:	85 db                	test   %ebx,%ebx
  802b8c:	75 0b                	jne    802b99 <__udivdi3+0x49>
  802b8e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b93:	31 d2                	xor    %edx,%edx
  802b95:	f7 f3                	div    %ebx
  802b97:	89 c1                	mov    %eax,%ecx
  802b99:	31 d2                	xor    %edx,%edx
  802b9b:	89 f0                	mov    %esi,%eax
  802b9d:	f7 f1                	div    %ecx
  802b9f:	89 c6                	mov    %eax,%esi
  802ba1:	89 e8                	mov    %ebp,%eax
  802ba3:	89 f7                	mov    %esi,%edi
  802ba5:	f7 f1                	div    %ecx
  802ba7:	89 fa                	mov    %edi,%edx
  802ba9:	83 c4 1c             	add    $0x1c,%esp
  802bac:	5b                   	pop    %ebx
  802bad:	5e                   	pop    %esi
  802bae:	5f                   	pop    %edi
  802baf:	5d                   	pop    %ebp
  802bb0:	c3                   	ret    
  802bb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bb8:	39 f2                	cmp    %esi,%edx
  802bba:	77 1c                	ja     802bd8 <__udivdi3+0x88>
  802bbc:	0f bd fa             	bsr    %edx,%edi
  802bbf:	83 f7 1f             	xor    $0x1f,%edi
  802bc2:	75 2c                	jne    802bf0 <__udivdi3+0xa0>
  802bc4:	39 f2                	cmp    %esi,%edx
  802bc6:	72 06                	jb     802bce <__udivdi3+0x7e>
  802bc8:	31 c0                	xor    %eax,%eax
  802bca:	39 eb                	cmp    %ebp,%ebx
  802bcc:	77 a9                	ja     802b77 <__udivdi3+0x27>
  802bce:	b8 01 00 00 00       	mov    $0x1,%eax
  802bd3:	eb a2                	jmp    802b77 <__udivdi3+0x27>
  802bd5:	8d 76 00             	lea    0x0(%esi),%esi
  802bd8:	31 ff                	xor    %edi,%edi
  802bda:	31 c0                	xor    %eax,%eax
  802bdc:	89 fa                	mov    %edi,%edx
  802bde:	83 c4 1c             	add    $0x1c,%esp
  802be1:	5b                   	pop    %ebx
  802be2:	5e                   	pop    %esi
  802be3:	5f                   	pop    %edi
  802be4:	5d                   	pop    %ebp
  802be5:	c3                   	ret    
  802be6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bed:	8d 76 00             	lea    0x0(%esi),%esi
  802bf0:	89 f9                	mov    %edi,%ecx
  802bf2:	b8 20 00 00 00       	mov    $0x20,%eax
  802bf7:	29 f8                	sub    %edi,%eax
  802bf9:	d3 e2                	shl    %cl,%edx
  802bfb:	89 54 24 08          	mov    %edx,0x8(%esp)
  802bff:	89 c1                	mov    %eax,%ecx
  802c01:	89 da                	mov    %ebx,%edx
  802c03:	d3 ea                	shr    %cl,%edx
  802c05:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802c09:	09 d1                	or     %edx,%ecx
  802c0b:	89 f2                	mov    %esi,%edx
  802c0d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c11:	89 f9                	mov    %edi,%ecx
  802c13:	d3 e3                	shl    %cl,%ebx
  802c15:	89 c1                	mov    %eax,%ecx
  802c17:	d3 ea                	shr    %cl,%edx
  802c19:	89 f9                	mov    %edi,%ecx
  802c1b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802c1f:	89 eb                	mov    %ebp,%ebx
  802c21:	d3 e6                	shl    %cl,%esi
  802c23:	89 c1                	mov    %eax,%ecx
  802c25:	d3 eb                	shr    %cl,%ebx
  802c27:	09 de                	or     %ebx,%esi
  802c29:	89 f0                	mov    %esi,%eax
  802c2b:	f7 74 24 08          	divl   0x8(%esp)
  802c2f:	89 d6                	mov    %edx,%esi
  802c31:	89 c3                	mov    %eax,%ebx
  802c33:	f7 64 24 0c          	mull   0xc(%esp)
  802c37:	39 d6                	cmp    %edx,%esi
  802c39:	72 15                	jb     802c50 <__udivdi3+0x100>
  802c3b:	89 f9                	mov    %edi,%ecx
  802c3d:	d3 e5                	shl    %cl,%ebp
  802c3f:	39 c5                	cmp    %eax,%ebp
  802c41:	73 04                	jae    802c47 <__udivdi3+0xf7>
  802c43:	39 d6                	cmp    %edx,%esi
  802c45:	74 09                	je     802c50 <__udivdi3+0x100>
  802c47:	89 d8                	mov    %ebx,%eax
  802c49:	31 ff                	xor    %edi,%edi
  802c4b:	e9 27 ff ff ff       	jmp    802b77 <__udivdi3+0x27>
  802c50:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802c53:	31 ff                	xor    %edi,%edi
  802c55:	e9 1d ff ff ff       	jmp    802b77 <__udivdi3+0x27>
  802c5a:	66 90                	xchg   %ax,%ax
  802c5c:	66 90                	xchg   %ax,%ax
  802c5e:	66 90                	xchg   %ax,%ax

00802c60 <__umoddi3>:
  802c60:	55                   	push   %ebp
  802c61:	57                   	push   %edi
  802c62:	56                   	push   %esi
  802c63:	53                   	push   %ebx
  802c64:	83 ec 1c             	sub    $0x1c,%esp
  802c67:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802c6b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802c6f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802c73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802c77:	89 da                	mov    %ebx,%edx
  802c79:	85 c0                	test   %eax,%eax
  802c7b:	75 43                	jne    802cc0 <__umoddi3+0x60>
  802c7d:	39 df                	cmp    %ebx,%edi
  802c7f:	76 17                	jbe    802c98 <__umoddi3+0x38>
  802c81:	89 f0                	mov    %esi,%eax
  802c83:	f7 f7                	div    %edi
  802c85:	89 d0                	mov    %edx,%eax
  802c87:	31 d2                	xor    %edx,%edx
  802c89:	83 c4 1c             	add    $0x1c,%esp
  802c8c:	5b                   	pop    %ebx
  802c8d:	5e                   	pop    %esi
  802c8e:	5f                   	pop    %edi
  802c8f:	5d                   	pop    %ebp
  802c90:	c3                   	ret    
  802c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c98:	89 fd                	mov    %edi,%ebp
  802c9a:	85 ff                	test   %edi,%edi
  802c9c:	75 0b                	jne    802ca9 <__umoddi3+0x49>
  802c9e:	b8 01 00 00 00       	mov    $0x1,%eax
  802ca3:	31 d2                	xor    %edx,%edx
  802ca5:	f7 f7                	div    %edi
  802ca7:	89 c5                	mov    %eax,%ebp
  802ca9:	89 d8                	mov    %ebx,%eax
  802cab:	31 d2                	xor    %edx,%edx
  802cad:	f7 f5                	div    %ebp
  802caf:	89 f0                	mov    %esi,%eax
  802cb1:	f7 f5                	div    %ebp
  802cb3:	89 d0                	mov    %edx,%eax
  802cb5:	eb d0                	jmp    802c87 <__umoddi3+0x27>
  802cb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802cbe:	66 90                	xchg   %ax,%ax
  802cc0:	89 f1                	mov    %esi,%ecx
  802cc2:	39 d8                	cmp    %ebx,%eax
  802cc4:	76 0a                	jbe    802cd0 <__umoddi3+0x70>
  802cc6:	89 f0                	mov    %esi,%eax
  802cc8:	83 c4 1c             	add    $0x1c,%esp
  802ccb:	5b                   	pop    %ebx
  802ccc:	5e                   	pop    %esi
  802ccd:	5f                   	pop    %edi
  802cce:	5d                   	pop    %ebp
  802ccf:	c3                   	ret    
  802cd0:	0f bd e8             	bsr    %eax,%ebp
  802cd3:	83 f5 1f             	xor    $0x1f,%ebp
  802cd6:	75 20                	jne    802cf8 <__umoddi3+0x98>
  802cd8:	39 d8                	cmp    %ebx,%eax
  802cda:	0f 82 b0 00 00 00    	jb     802d90 <__umoddi3+0x130>
  802ce0:	39 f7                	cmp    %esi,%edi
  802ce2:	0f 86 a8 00 00 00    	jbe    802d90 <__umoddi3+0x130>
  802ce8:	89 c8                	mov    %ecx,%eax
  802cea:	83 c4 1c             	add    $0x1c,%esp
  802ced:	5b                   	pop    %ebx
  802cee:	5e                   	pop    %esi
  802cef:	5f                   	pop    %edi
  802cf0:	5d                   	pop    %ebp
  802cf1:	c3                   	ret    
  802cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802cf8:	89 e9                	mov    %ebp,%ecx
  802cfa:	ba 20 00 00 00       	mov    $0x20,%edx
  802cff:	29 ea                	sub    %ebp,%edx
  802d01:	d3 e0                	shl    %cl,%eax
  802d03:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d07:	89 d1                	mov    %edx,%ecx
  802d09:	89 f8                	mov    %edi,%eax
  802d0b:	d3 e8                	shr    %cl,%eax
  802d0d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802d11:	89 54 24 04          	mov    %edx,0x4(%esp)
  802d15:	8b 54 24 04          	mov    0x4(%esp),%edx
  802d19:	09 c1                	or     %eax,%ecx
  802d1b:	89 d8                	mov    %ebx,%eax
  802d1d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802d21:	89 e9                	mov    %ebp,%ecx
  802d23:	d3 e7                	shl    %cl,%edi
  802d25:	89 d1                	mov    %edx,%ecx
  802d27:	d3 e8                	shr    %cl,%eax
  802d29:	89 e9                	mov    %ebp,%ecx
  802d2b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d2f:	d3 e3                	shl    %cl,%ebx
  802d31:	89 c7                	mov    %eax,%edi
  802d33:	89 d1                	mov    %edx,%ecx
  802d35:	89 f0                	mov    %esi,%eax
  802d37:	d3 e8                	shr    %cl,%eax
  802d39:	89 e9                	mov    %ebp,%ecx
  802d3b:	89 fa                	mov    %edi,%edx
  802d3d:	d3 e6                	shl    %cl,%esi
  802d3f:	09 d8                	or     %ebx,%eax
  802d41:	f7 74 24 08          	divl   0x8(%esp)
  802d45:	89 d1                	mov    %edx,%ecx
  802d47:	89 f3                	mov    %esi,%ebx
  802d49:	f7 64 24 0c          	mull   0xc(%esp)
  802d4d:	89 c6                	mov    %eax,%esi
  802d4f:	89 d7                	mov    %edx,%edi
  802d51:	39 d1                	cmp    %edx,%ecx
  802d53:	72 06                	jb     802d5b <__umoddi3+0xfb>
  802d55:	75 10                	jne    802d67 <__umoddi3+0x107>
  802d57:	39 c3                	cmp    %eax,%ebx
  802d59:	73 0c                	jae    802d67 <__umoddi3+0x107>
  802d5b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802d5f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802d63:	89 d7                	mov    %edx,%edi
  802d65:	89 c6                	mov    %eax,%esi
  802d67:	89 ca                	mov    %ecx,%edx
  802d69:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802d6e:	29 f3                	sub    %esi,%ebx
  802d70:	19 fa                	sbb    %edi,%edx
  802d72:	89 d0                	mov    %edx,%eax
  802d74:	d3 e0                	shl    %cl,%eax
  802d76:	89 e9                	mov    %ebp,%ecx
  802d78:	d3 eb                	shr    %cl,%ebx
  802d7a:	d3 ea                	shr    %cl,%edx
  802d7c:	09 d8                	or     %ebx,%eax
  802d7e:	83 c4 1c             	add    $0x1c,%esp
  802d81:	5b                   	pop    %ebx
  802d82:	5e                   	pop    %esi
  802d83:	5f                   	pop    %edi
  802d84:	5d                   	pop    %ebp
  802d85:	c3                   	ret    
  802d86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802d8d:	8d 76 00             	lea    0x0(%esi),%esi
  802d90:	89 da                	mov    %ebx,%edx
  802d92:	29 fe                	sub    %edi,%esi
  802d94:	19 c2                	sbb    %eax,%edx
  802d96:	89 f1                	mov    %esi,%ecx
  802d98:	89 c8                	mov    %ecx,%eax
  802d9a:	e9 4b ff ff ff       	jmp    802cea <__umoddi3+0x8a>
