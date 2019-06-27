
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
  80006d:	68 c0 2d 80 00       	push   $0x802dc0
  800072:	e8 24 05 00 00       	call   80059b <cprintf>

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
  8000a0:	68 84 2e 80 00       	push   $0x802e84
  8000a5:	e8 f1 04 00 00       	call   80059b <cprintf>
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
  8000ca:	68 c0 2e 80 00       	push   $0x802ec0
  8000cf:	e8 c7 04 00 00       	call   80059b <cprintf>
  8000d4:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  8000d7:	83 ec 08             	sub    $0x8,%esp
  8000da:	68 fc 2d 80 00       	push   $0x802dfc
  8000df:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8000e5:	50                   	push   %eax
  8000e6:	e8 2f 0c 00 00       	call   800d1a <strcat>
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
  800100:	68 08 2e 80 00       	push   $0x802e08
  800105:	56                   	push   %esi
  800106:	e8 0f 0c 00 00       	call   800d1a <strcat>
		strcat(args, argv[i]);
  80010b:	83 c4 08             	add    $0x8,%esp
  80010e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800111:	ff 34 98             	pushl  (%eax,%ebx,4)
  800114:	56                   	push   %esi
  800115:	e8 00 0c 00 00       	call   800d1a <strcat>
		strcat(args, "'");
  80011a:	83 c4 08             	add    $0x8,%esp
  80011d:	68 09 2e 80 00       	push   $0x802e09
  800122:	56                   	push   %esi
  800123:	e8 f2 0b 00 00       	call   800d1a <strcat>
	for (i = 0; i < argc; i++) {
  800128:	83 c3 01             	add    $0x1,%ebx
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	eb c9                	jmp    8000f9 <umain+0x9b>
		cprintf("init: data seems okay\n");
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	68 cf 2d 80 00       	push   $0x802dcf
  800138:	e8 5e 04 00 00       	call   80059b <cprintf>
  80013d:	83 c4 10             	add    $0x10,%esp
  800140:	e9 68 ff ff ff       	jmp    8000ad <umain+0x4f>
		cprintf("init: bss seems okay\n");
  800145:	83 ec 0c             	sub    $0xc,%esp
  800148:	68 e6 2d 80 00       	push   $0x802de6
  80014d:	e8 49 04 00 00       	call   80059b <cprintf>
  800152:	83 c4 10             	add    $0x10,%esp
  800155:	eb 80                	jmp    8000d7 <umain+0x79>
	}
	cprintf("%s\n", args);
  800157:	83 ec 08             	sub    $0x8,%esp
  80015a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800160:	50                   	push   %eax
  800161:	68 5a 2f 80 00       	push   $0x802f5a
  800166:	e8 30 04 00 00       	call   80059b <cprintf>

	cprintf("init: running sh\n");
  80016b:	c7 04 24 0b 2e 80 00 	movl   $0x802e0b,(%esp)
  800172:	e8 24 04 00 00       	call   80059b <cprintf>

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  800177:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80017e:	e8 09 14 00 00       	call   80158c <close>
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
  800192:	68 36 2e 80 00       	push   $0x802e36
  800197:	6a 39                	push   $0x39
  800199:	68 2a 2e 80 00       	push   $0x802e2a
  80019e:	e8 02 03 00 00       	call   8004a5 <_panic>
		panic("opencons: %e", r);
  8001a3:	50                   	push   %eax
  8001a4:	68 1d 2e 80 00       	push   $0x802e1d
  8001a9:	6a 37                	push   $0x37
  8001ab:	68 2a 2e 80 00       	push   $0x802e2a
  8001b0:	e8 f0 02 00 00       	call   8004a5 <_panic>
	if ((r = dup(0, 1)) < 0)
  8001b5:	83 ec 08             	sub    $0x8,%esp
  8001b8:	6a 01                	push   $0x1
  8001ba:	6a 00                	push   $0x0
  8001bc:	e8 1d 14 00 00       	call   8015de <dup>
  8001c1:	83 c4 10             	add    $0x10,%esp
  8001c4:	85 c0                	test   %eax,%eax
  8001c6:	79 23                	jns    8001eb <umain+0x18d>
		panic("dup: %e", r);
  8001c8:	50                   	push   %eax
  8001c9:	68 50 2e 80 00       	push   $0x802e50
  8001ce:	6a 3b                	push   $0x3b
  8001d0:	68 2a 2e 80 00       	push   $0x802e2a
  8001d5:	e8 cb 02 00 00       	call   8004a5 <_panic>
	while (1) {
		cprintf("init: starting sh\n");
		r = spawnl("/sh", "sh", (char*)0);
		if (r < 0) {
			cprintf("init: spawn sh: %e\n", r);
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	50                   	push   %eax
  8001de:	68 6f 2e 80 00       	push   $0x802e6f
  8001e3:	e8 b3 03 00 00       	call   80059b <cprintf>
			continue;
  8001e8:	83 c4 10             	add    $0x10,%esp
		cprintf("init: starting sh\n");
  8001eb:	83 ec 0c             	sub    $0xc,%esp
  8001ee:	68 58 2e 80 00       	push   $0x802e58
  8001f3:	e8 a3 03 00 00       	call   80059b <cprintf>
		r = spawnl("/sh", "sh", (char*)0);
  8001f8:	83 c4 0c             	add    $0xc,%esp
  8001fb:	6a 00                	push   $0x0
  8001fd:	68 6c 2e 80 00       	push   $0x802e6c
  800202:	68 6b 2e 80 00       	push   $0x802e6b
  800207:	e8 8f 1f 00 00       	call   80219b <spawnl>
		if (r < 0) {
  80020c:	83 c4 10             	add    $0x10,%esp
  80020f:	85 c0                	test   %eax,%eax
  800211:	78 c7                	js     8001da <umain+0x17c>
		}
		wait(r);
  800213:	83 ec 0c             	sub    $0xc,%esp
  800216:	50                   	push   %eax
  800217:	e8 c3 27 00 00       	call   8029df <wait>
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
  80022d:	68 ef 2e 80 00       	push   $0x802eef
  800232:	ff 75 0c             	pushl  0xc(%ebp)
  800235:	e8 c0 0a 00 00       	call   800cfa <strcpy>
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
  800278:	e8 0b 0c 00 00       	call   800e88 <memmove>
		sys_cputs(buf, m);
  80027d:	83 c4 08             	add    $0x8,%esp
  800280:	53                   	push   %ebx
  800281:	57                   	push   %edi
  800282:	e8 a9 0d 00 00       	call   801030 <sys_cputs>
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
  8002a9:	e8 a0 0d 00 00       	call   80104e <sys_cgetc>
  8002ae:	85 c0                	test   %eax,%eax
  8002b0:	75 07                	jne    8002b9 <devcons_read+0x21>
		sys_yield();
  8002b2:	e8 16 0e 00 00       	call   8010cd <sys_yield>
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
  8002e5:	e8 46 0d 00 00       	call   801030 <sys_cputs>
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
  8002fd:	e8 c8 13 00 00       	call   8016ca <read>
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
  800325:	e8 30 11 00 00       	call   80145a <fd_lookup>
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
  80034e:	e8 b5 10 00 00       	call   801408 <fd_alloc>
  800353:	83 c4 10             	add    $0x10,%esp
  800356:	85 c0                	test   %eax,%eax
  800358:	78 3a                	js     800394 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80035a:	83 ec 04             	sub    $0x4,%esp
  80035d:	68 07 04 00 00       	push   $0x407
  800362:	ff 75 f4             	pushl  -0xc(%ebp)
  800365:	6a 00                	push   $0x0
  800367:	e8 80 0d 00 00       	call   8010ec <sys_page_alloc>
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
  80038c:	e8 50 10 00 00       	call   8013e1 <fd2num>
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
  8003a9:	e8 00 0d 00 00       	call   8010ae <sys_getenvid>
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
  8003ce:	74 23                	je     8003f3 <libmain+0x5d>
		if(envs[i].env_id == find)
  8003d0:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  8003d6:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8003dc:	8b 49 48             	mov    0x48(%ecx),%ecx
  8003df:	39 c1                	cmp    %eax,%ecx
  8003e1:	75 e2                	jne    8003c5 <libmain+0x2f>
  8003e3:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  8003e9:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8003ef:	89 fe                	mov    %edi,%esi
  8003f1:	eb d2                	jmp    8003c5 <libmain+0x2f>
  8003f3:	89 f0                	mov    %esi,%eax
  8003f5:	84 c0                	test   %al,%al
  8003f7:	74 06                	je     8003ff <libmain+0x69>
  8003f9:	89 1d 90 77 80 00    	mov    %ebx,0x807790
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800403:	7e 0a                	jle    80040f <libmain+0x79>
		binaryname = argv[0];
  800405:	8b 45 0c             	mov    0xc(%ebp),%eax
  800408:	8b 00                	mov    (%eax),%eax
  80040a:	a3 8c 57 80 00       	mov    %eax,0x80578c

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  80040f:	a1 90 77 80 00       	mov    0x807790,%eax
  800414:	8b 40 48             	mov    0x48(%eax),%eax
  800417:	83 ec 08             	sub    $0x8,%esp
  80041a:	50                   	push   %eax
  80041b:	68 fb 2e 80 00       	push   $0x802efb
  800420:	e8 76 01 00 00       	call   80059b <cprintf>
	cprintf("before umain\n");
  800425:	c7 04 24 19 2f 80 00 	movl   $0x802f19,(%esp)
  80042c:	e8 6a 01 00 00       	call   80059b <cprintf>
	// call user main routine
	umain(argc, argv);
  800431:	83 c4 08             	add    $0x8,%esp
  800434:	ff 75 0c             	pushl  0xc(%ebp)
  800437:	ff 75 08             	pushl  0x8(%ebp)
  80043a:	e8 1f fc ff ff       	call   80005e <umain>
	cprintf("after umain\n");
  80043f:	c7 04 24 27 2f 80 00 	movl   $0x802f27,(%esp)
  800446:	e8 50 01 00 00       	call   80059b <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  80044b:	a1 90 77 80 00       	mov    0x807790,%eax
  800450:	8b 40 48             	mov    0x48(%eax),%eax
  800453:	83 c4 08             	add    $0x8,%esp
  800456:	50                   	push   %eax
  800457:	68 34 2f 80 00       	push   $0x802f34
  80045c:	e8 3a 01 00 00       	call   80059b <cprintf>
	// exit gracefully
	exit();
  800461:	e8 0b 00 00 00       	call   800471 <exit>
}
  800466:	83 c4 10             	add    $0x10,%esp
  800469:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80046c:	5b                   	pop    %ebx
  80046d:	5e                   	pop    %esi
  80046e:	5f                   	pop    %edi
  80046f:	5d                   	pop    %ebp
  800470:	c3                   	ret    

00800471 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800471:	55                   	push   %ebp
  800472:	89 e5                	mov    %esp,%ebp
  800474:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800477:	a1 90 77 80 00       	mov    0x807790,%eax
  80047c:	8b 40 48             	mov    0x48(%eax),%eax
  80047f:	68 60 2f 80 00       	push   $0x802f60
  800484:	50                   	push   %eax
  800485:	68 53 2f 80 00       	push   $0x802f53
  80048a:	e8 0c 01 00 00       	call   80059b <cprintf>
	close_all();
  80048f:	e8 25 11 00 00       	call   8015b9 <close_all>
	sys_env_destroy(0);
  800494:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80049b:	e8 cd 0b 00 00       	call   80106d <sys_env_destroy>
}
  8004a0:	83 c4 10             	add    $0x10,%esp
  8004a3:	c9                   	leave  
  8004a4:	c3                   	ret    

008004a5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8004a5:	55                   	push   %ebp
  8004a6:	89 e5                	mov    %esp,%ebp
  8004a8:	56                   	push   %esi
  8004a9:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8004aa:	a1 90 77 80 00       	mov    0x807790,%eax
  8004af:	8b 40 48             	mov    0x48(%eax),%eax
  8004b2:	83 ec 04             	sub    $0x4,%esp
  8004b5:	68 8c 2f 80 00       	push   $0x802f8c
  8004ba:	50                   	push   %eax
  8004bb:	68 53 2f 80 00       	push   $0x802f53
  8004c0:	e8 d6 00 00 00       	call   80059b <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8004c5:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8004c8:	8b 35 8c 57 80 00    	mov    0x80578c,%esi
  8004ce:	e8 db 0b 00 00       	call   8010ae <sys_getenvid>
  8004d3:	83 c4 04             	add    $0x4,%esp
  8004d6:	ff 75 0c             	pushl  0xc(%ebp)
  8004d9:	ff 75 08             	pushl  0x8(%ebp)
  8004dc:	56                   	push   %esi
  8004dd:	50                   	push   %eax
  8004de:	68 68 2f 80 00       	push   $0x802f68
  8004e3:	e8 b3 00 00 00       	call   80059b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004e8:	83 c4 18             	add    $0x18,%esp
  8004eb:	53                   	push   %ebx
  8004ec:	ff 75 10             	pushl  0x10(%ebp)
  8004ef:	e8 56 00 00 00       	call   80054a <vcprintf>
	cprintf("\n");
  8004f4:	c7 04 24 17 2f 80 00 	movl   $0x802f17,(%esp)
  8004fb:	e8 9b 00 00 00       	call   80059b <cprintf>
  800500:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800503:	cc                   	int3   
  800504:	eb fd                	jmp    800503 <_panic+0x5e>

00800506 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800506:	55                   	push   %ebp
  800507:	89 e5                	mov    %esp,%ebp
  800509:	53                   	push   %ebx
  80050a:	83 ec 04             	sub    $0x4,%esp
  80050d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800510:	8b 13                	mov    (%ebx),%edx
  800512:	8d 42 01             	lea    0x1(%edx),%eax
  800515:	89 03                	mov    %eax,(%ebx)
  800517:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80051a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80051e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800523:	74 09                	je     80052e <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800525:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800529:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80052c:	c9                   	leave  
  80052d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80052e:	83 ec 08             	sub    $0x8,%esp
  800531:	68 ff 00 00 00       	push   $0xff
  800536:	8d 43 08             	lea    0x8(%ebx),%eax
  800539:	50                   	push   %eax
  80053a:	e8 f1 0a 00 00       	call   801030 <sys_cputs>
		b->idx = 0;
  80053f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800545:	83 c4 10             	add    $0x10,%esp
  800548:	eb db                	jmp    800525 <putch+0x1f>

0080054a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80054a:	55                   	push   %ebp
  80054b:	89 e5                	mov    %esp,%ebp
  80054d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800553:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80055a:	00 00 00 
	b.cnt = 0;
  80055d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800564:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800567:	ff 75 0c             	pushl  0xc(%ebp)
  80056a:	ff 75 08             	pushl  0x8(%ebp)
  80056d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800573:	50                   	push   %eax
  800574:	68 06 05 80 00       	push   $0x800506
  800579:	e8 4a 01 00 00       	call   8006c8 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80057e:	83 c4 08             	add    $0x8,%esp
  800581:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800587:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80058d:	50                   	push   %eax
  80058e:	e8 9d 0a 00 00       	call   801030 <sys_cputs>

	return b.cnt;
}
  800593:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800599:	c9                   	leave  
  80059a:	c3                   	ret    

0080059b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80059b:	55                   	push   %ebp
  80059c:	89 e5                	mov    %esp,%ebp
  80059e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005a1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8005a4:	50                   	push   %eax
  8005a5:	ff 75 08             	pushl  0x8(%ebp)
  8005a8:	e8 9d ff ff ff       	call   80054a <vcprintf>
	va_end(ap);

	return cnt;
}
  8005ad:	c9                   	leave  
  8005ae:	c3                   	ret    

008005af <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005af:	55                   	push   %ebp
  8005b0:	89 e5                	mov    %esp,%ebp
  8005b2:	57                   	push   %edi
  8005b3:	56                   	push   %esi
  8005b4:	53                   	push   %ebx
  8005b5:	83 ec 1c             	sub    $0x1c,%esp
  8005b8:	89 c6                	mov    %eax,%esi
  8005ba:	89 d7                	mov    %edx,%edi
  8005bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005c5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8005cb:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8005ce:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8005d2:	74 2c                	je     800600 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8005d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8005de:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005e1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005e4:	39 c2                	cmp    %eax,%edx
  8005e6:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8005e9:	73 43                	jae    80062e <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8005eb:	83 eb 01             	sub    $0x1,%ebx
  8005ee:	85 db                	test   %ebx,%ebx
  8005f0:	7e 6c                	jle    80065e <printnum+0xaf>
				putch(padc, putdat);
  8005f2:	83 ec 08             	sub    $0x8,%esp
  8005f5:	57                   	push   %edi
  8005f6:	ff 75 18             	pushl  0x18(%ebp)
  8005f9:	ff d6                	call   *%esi
  8005fb:	83 c4 10             	add    $0x10,%esp
  8005fe:	eb eb                	jmp    8005eb <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800600:	83 ec 0c             	sub    $0xc,%esp
  800603:	6a 20                	push   $0x20
  800605:	6a 00                	push   $0x0
  800607:	50                   	push   %eax
  800608:	ff 75 e4             	pushl  -0x1c(%ebp)
  80060b:	ff 75 e0             	pushl  -0x20(%ebp)
  80060e:	89 fa                	mov    %edi,%edx
  800610:	89 f0                	mov    %esi,%eax
  800612:	e8 98 ff ff ff       	call   8005af <printnum>
		while (--width > 0)
  800617:	83 c4 20             	add    $0x20,%esp
  80061a:	83 eb 01             	sub    $0x1,%ebx
  80061d:	85 db                	test   %ebx,%ebx
  80061f:	7e 65                	jle    800686 <printnum+0xd7>
			putch(padc, putdat);
  800621:	83 ec 08             	sub    $0x8,%esp
  800624:	57                   	push   %edi
  800625:	6a 20                	push   $0x20
  800627:	ff d6                	call   *%esi
  800629:	83 c4 10             	add    $0x10,%esp
  80062c:	eb ec                	jmp    80061a <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80062e:	83 ec 0c             	sub    $0xc,%esp
  800631:	ff 75 18             	pushl  0x18(%ebp)
  800634:	83 eb 01             	sub    $0x1,%ebx
  800637:	53                   	push   %ebx
  800638:	50                   	push   %eax
  800639:	83 ec 08             	sub    $0x8,%esp
  80063c:	ff 75 dc             	pushl  -0x24(%ebp)
  80063f:	ff 75 d8             	pushl  -0x28(%ebp)
  800642:	ff 75 e4             	pushl  -0x1c(%ebp)
  800645:	ff 75 e0             	pushl  -0x20(%ebp)
  800648:	e8 23 25 00 00       	call   802b70 <__udivdi3>
  80064d:	83 c4 18             	add    $0x18,%esp
  800650:	52                   	push   %edx
  800651:	50                   	push   %eax
  800652:	89 fa                	mov    %edi,%edx
  800654:	89 f0                	mov    %esi,%eax
  800656:	e8 54 ff ff ff       	call   8005af <printnum>
  80065b:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80065e:	83 ec 08             	sub    $0x8,%esp
  800661:	57                   	push   %edi
  800662:	83 ec 04             	sub    $0x4,%esp
  800665:	ff 75 dc             	pushl  -0x24(%ebp)
  800668:	ff 75 d8             	pushl  -0x28(%ebp)
  80066b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80066e:	ff 75 e0             	pushl  -0x20(%ebp)
  800671:	e8 0a 26 00 00       	call   802c80 <__umoddi3>
  800676:	83 c4 14             	add    $0x14,%esp
  800679:	0f be 80 93 2f 80 00 	movsbl 0x802f93(%eax),%eax
  800680:	50                   	push   %eax
  800681:	ff d6                	call   *%esi
  800683:	83 c4 10             	add    $0x10,%esp
	}
}
  800686:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800689:	5b                   	pop    %ebx
  80068a:	5e                   	pop    %esi
  80068b:	5f                   	pop    %edi
  80068c:	5d                   	pop    %ebp
  80068d:	c3                   	ret    

0080068e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80068e:	55                   	push   %ebp
  80068f:	89 e5                	mov    %esp,%ebp
  800691:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800694:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800698:	8b 10                	mov    (%eax),%edx
  80069a:	3b 50 04             	cmp    0x4(%eax),%edx
  80069d:	73 0a                	jae    8006a9 <sprintputch+0x1b>
		*b->buf++ = ch;
  80069f:	8d 4a 01             	lea    0x1(%edx),%ecx
  8006a2:	89 08                	mov    %ecx,(%eax)
  8006a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a7:	88 02                	mov    %al,(%edx)
}
  8006a9:	5d                   	pop    %ebp
  8006aa:	c3                   	ret    

008006ab <printfmt>:
{
  8006ab:	55                   	push   %ebp
  8006ac:	89 e5                	mov    %esp,%ebp
  8006ae:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8006b1:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8006b4:	50                   	push   %eax
  8006b5:	ff 75 10             	pushl  0x10(%ebp)
  8006b8:	ff 75 0c             	pushl  0xc(%ebp)
  8006bb:	ff 75 08             	pushl  0x8(%ebp)
  8006be:	e8 05 00 00 00       	call   8006c8 <vprintfmt>
}
  8006c3:	83 c4 10             	add    $0x10,%esp
  8006c6:	c9                   	leave  
  8006c7:	c3                   	ret    

008006c8 <vprintfmt>:
{
  8006c8:	55                   	push   %ebp
  8006c9:	89 e5                	mov    %esp,%ebp
  8006cb:	57                   	push   %edi
  8006cc:	56                   	push   %esi
  8006cd:	53                   	push   %ebx
  8006ce:	83 ec 3c             	sub    $0x3c,%esp
  8006d1:	8b 75 08             	mov    0x8(%ebp),%esi
  8006d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006d7:	8b 7d 10             	mov    0x10(%ebp),%edi
  8006da:	e9 32 04 00 00       	jmp    800b11 <vprintfmt+0x449>
		padc = ' ';
  8006df:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8006e3:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8006ea:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8006f1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8006f8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8006ff:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800706:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80070b:	8d 47 01             	lea    0x1(%edi),%eax
  80070e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800711:	0f b6 17             	movzbl (%edi),%edx
  800714:	8d 42 dd             	lea    -0x23(%edx),%eax
  800717:	3c 55                	cmp    $0x55,%al
  800719:	0f 87 12 05 00 00    	ja     800c31 <vprintfmt+0x569>
  80071f:	0f b6 c0             	movzbl %al,%eax
  800722:	ff 24 85 80 31 80 00 	jmp    *0x803180(,%eax,4)
  800729:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80072c:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800730:	eb d9                	jmp    80070b <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800732:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800735:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800739:	eb d0                	jmp    80070b <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80073b:	0f b6 d2             	movzbl %dl,%edx
  80073e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800741:	b8 00 00 00 00       	mov    $0x0,%eax
  800746:	89 75 08             	mov    %esi,0x8(%ebp)
  800749:	eb 03                	jmp    80074e <vprintfmt+0x86>
  80074b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80074e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800751:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800755:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800758:	8d 72 d0             	lea    -0x30(%edx),%esi
  80075b:	83 fe 09             	cmp    $0x9,%esi
  80075e:	76 eb                	jbe    80074b <vprintfmt+0x83>
  800760:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800763:	8b 75 08             	mov    0x8(%ebp),%esi
  800766:	eb 14                	jmp    80077c <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800768:	8b 45 14             	mov    0x14(%ebp),%eax
  80076b:	8b 00                	mov    (%eax),%eax
  80076d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800770:	8b 45 14             	mov    0x14(%ebp),%eax
  800773:	8d 40 04             	lea    0x4(%eax),%eax
  800776:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800779:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80077c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800780:	79 89                	jns    80070b <vprintfmt+0x43>
				width = precision, precision = -1;
  800782:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800785:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800788:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80078f:	e9 77 ff ff ff       	jmp    80070b <vprintfmt+0x43>
  800794:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800797:	85 c0                	test   %eax,%eax
  800799:	0f 48 c1             	cmovs  %ecx,%eax
  80079c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80079f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8007a2:	e9 64 ff ff ff       	jmp    80070b <vprintfmt+0x43>
  8007a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8007aa:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8007b1:	e9 55 ff ff ff       	jmp    80070b <vprintfmt+0x43>
			lflag++;
  8007b6:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8007ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8007bd:	e9 49 ff ff ff       	jmp    80070b <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8007c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c5:	8d 78 04             	lea    0x4(%eax),%edi
  8007c8:	83 ec 08             	sub    $0x8,%esp
  8007cb:	53                   	push   %ebx
  8007cc:	ff 30                	pushl  (%eax)
  8007ce:	ff d6                	call   *%esi
			break;
  8007d0:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8007d3:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8007d6:	e9 33 03 00 00       	jmp    800b0e <vprintfmt+0x446>
			err = va_arg(ap, int);
  8007db:	8b 45 14             	mov    0x14(%ebp),%eax
  8007de:	8d 78 04             	lea    0x4(%eax),%edi
  8007e1:	8b 00                	mov    (%eax),%eax
  8007e3:	99                   	cltd   
  8007e4:	31 d0                	xor    %edx,%eax
  8007e6:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8007e8:	83 f8 11             	cmp    $0x11,%eax
  8007eb:	7f 23                	jg     800810 <vprintfmt+0x148>
  8007ed:	8b 14 85 e0 32 80 00 	mov    0x8032e0(,%eax,4),%edx
  8007f4:	85 d2                	test   %edx,%edx
  8007f6:	74 18                	je     800810 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8007f8:	52                   	push   %edx
  8007f9:	68 fd 33 80 00       	push   $0x8033fd
  8007fe:	53                   	push   %ebx
  8007ff:	56                   	push   %esi
  800800:	e8 a6 fe ff ff       	call   8006ab <printfmt>
  800805:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800808:	89 7d 14             	mov    %edi,0x14(%ebp)
  80080b:	e9 fe 02 00 00       	jmp    800b0e <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800810:	50                   	push   %eax
  800811:	68 ab 2f 80 00       	push   $0x802fab
  800816:	53                   	push   %ebx
  800817:	56                   	push   %esi
  800818:	e8 8e fe ff ff       	call   8006ab <printfmt>
  80081d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800820:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800823:	e9 e6 02 00 00       	jmp    800b0e <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800828:	8b 45 14             	mov    0x14(%ebp),%eax
  80082b:	83 c0 04             	add    $0x4,%eax
  80082e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800831:	8b 45 14             	mov    0x14(%ebp),%eax
  800834:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800836:	85 c9                	test   %ecx,%ecx
  800838:	b8 a4 2f 80 00       	mov    $0x802fa4,%eax
  80083d:	0f 45 c1             	cmovne %ecx,%eax
  800840:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800843:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800847:	7e 06                	jle    80084f <vprintfmt+0x187>
  800849:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80084d:	75 0d                	jne    80085c <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80084f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800852:	89 c7                	mov    %eax,%edi
  800854:	03 45 e0             	add    -0x20(%ebp),%eax
  800857:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80085a:	eb 53                	jmp    8008af <vprintfmt+0x1e7>
  80085c:	83 ec 08             	sub    $0x8,%esp
  80085f:	ff 75 d8             	pushl  -0x28(%ebp)
  800862:	50                   	push   %eax
  800863:	e8 71 04 00 00       	call   800cd9 <strnlen>
  800868:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80086b:	29 c1                	sub    %eax,%ecx
  80086d:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800870:	83 c4 10             	add    $0x10,%esp
  800873:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800875:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800879:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80087c:	eb 0f                	jmp    80088d <vprintfmt+0x1c5>
					putch(padc, putdat);
  80087e:	83 ec 08             	sub    $0x8,%esp
  800881:	53                   	push   %ebx
  800882:	ff 75 e0             	pushl  -0x20(%ebp)
  800885:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800887:	83 ef 01             	sub    $0x1,%edi
  80088a:	83 c4 10             	add    $0x10,%esp
  80088d:	85 ff                	test   %edi,%edi
  80088f:	7f ed                	jg     80087e <vprintfmt+0x1b6>
  800891:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800894:	85 c9                	test   %ecx,%ecx
  800896:	b8 00 00 00 00       	mov    $0x0,%eax
  80089b:	0f 49 c1             	cmovns %ecx,%eax
  80089e:	29 c1                	sub    %eax,%ecx
  8008a0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8008a3:	eb aa                	jmp    80084f <vprintfmt+0x187>
					putch(ch, putdat);
  8008a5:	83 ec 08             	sub    $0x8,%esp
  8008a8:	53                   	push   %ebx
  8008a9:	52                   	push   %edx
  8008aa:	ff d6                	call   *%esi
  8008ac:	83 c4 10             	add    $0x10,%esp
  8008af:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8008b2:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008b4:	83 c7 01             	add    $0x1,%edi
  8008b7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008bb:	0f be d0             	movsbl %al,%edx
  8008be:	85 d2                	test   %edx,%edx
  8008c0:	74 4b                	je     80090d <vprintfmt+0x245>
  8008c2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8008c6:	78 06                	js     8008ce <vprintfmt+0x206>
  8008c8:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8008cc:	78 1e                	js     8008ec <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8008ce:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8008d2:	74 d1                	je     8008a5 <vprintfmt+0x1dd>
  8008d4:	0f be c0             	movsbl %al,%eax
  8008d7:	83 e8 20             	sub    $0x20,%eax
  8008da:	83 f8 5e             	cmp    $0x5e,%eax
  8008dd:	76 c6                	jbe    8008a5 <vprintfmt+0x1dd>
					putch('?', putdat);
  8008df:	83 ec 08             	sub    $0x8,%esp
  8008e2:	53                   	push   %ebx
  8008e3:	6a 3f                	push   $0x3f
  8008e5:	ff d6                	call   *%esi
  8008e7:	83 c4 10             	add    $0x10,%esp
  8008ea:	eb c3                	jmp    8008af <vprintfmt+0x1e7>
  8008ec:	89 cf                	mov    %ecx,%edi
  8008ee:	eb 0e                	jmp    8008fe <vprintfmt+0x236>
				putch(' ', putdat);
  8008f0:	83 ec 08             	sub    $0x8,%esp
  8008f3:	53                   	push   %ebx
  8008f4:	6a 20                	push   $0x20
  8008f6:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8008f8:	83 ef 01             	sub    $0x1,%edi
  8008fb:	83 c4 10             	add    $0x10,%esp
  8008fe:	85 ff                	test   %edi,%edi
  800900:	7f ee                	jg     8008f0 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800902:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800905:	89 45 14             	mov    %eax,0x14(%ebp)
  800908:	e9 01 02 00 00       	jmp    800b0e <vprintfmt+0x446>
  80090d:	89 cf                	mov    %ecx,%edi
  80090f:	eb ed                	jmp    8008fe <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800911:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800914:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80091b:	e9 eb fd ff ff       	jmp    80070b <vprintfmt+0x43>
	if (lflag >= 2)
  800920:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800924:	7f 21                	jg     800947 <vprintfmt+0x27f>
	else if (lflag)
  800926:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80092a:	74 68                	je     800994 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80092c:	8b 45 14             	mov    0x14(%ebp),%eax
  80092f:	8b 00                	mov    (%eax),%eax
  800931:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800934:	89 c1                	mov    %eax,%ecx
  800936:	c1 f9 1f             	sar    $0x1f,%ecx
  800939:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80093c:	8b 45 14             	mov    0x14(%ebp),%eax
  80093f:	8d 40 04             	lea    0x4(%eax),%eax
  800942:	89 45 14             	mov    %eax,0x14(%ebp)
  800945:	eb 17                	jmp    80095e <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800947:	8b 45 14             	mov    0x14(%ebp),%eax
  80094a:	8b 50 04             	mov    0x4(%eax),%edx
  80094d:	8b 00                	mov    (%eax),%eax
  80094f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800952:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800955:	8b 45 14             	mov    0x14(%ebp),%eax
  800958:	8d 40 08             	lea    0x8(%eax),%eax
  80095b:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80095e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800961:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800964:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800967:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80096a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80096e:	78 3f                	js     8009af <vprintfmt+0x2e7>
			base = 10;
  800970:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800975:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800979:	0f 84 71 01 00 00    	je     800af0 <vprintfmt+0x428>
				putch('+', putdat);
  80097f:	83 ec 08             	sub    $0x8,%esp
  800982:	53                   	push   %ebx
  800983:	6a 2b                	push   $0x2b
  800985:	ff d6                	call   *%esi
  800987:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80098a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80098f:	e9 5c 01 00 00       	jmp    800af0 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800994:	8b 45 14             	mov    0x14(%ebp),%eax
  800997:	8b 00                	mov    (%eax),%eax
  800999:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80099c:	89 c1                	mov    %eax,%ecx
  80099e:	c1 f9 1f             	sar    $0x1f,%ecx
  8009a1:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8009a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a7:	8d 40 04             	lea    0x4(%eax),%eax
  8009aa:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ad:	eb af                	jmp    80095e <vprintfmt+0x296>
				putch('-', putdat);
  8009af:	83 ec 08             	sub    $0x8,%esp
  8009b2:	53                   	push   %ebx
  8009b3:	6a 2d                	push   $0x2d
  8009b5:	ff d6                	call   *%esi
				num = -(long long) num;
  8009b7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8009ba:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8009bd:	f7 d8                	neg    %eax
  8009bf:	83 d2 00             	adc    $0x0,%edx
  8009c2:	f7 da                	neg    %edx
  8009c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009c7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009ca:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8009cd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009d2:	e9 19 01 00 00       	jmp    800af0 <vprintfmt+0x428>
	if (lflag >= 2)
  8009d7:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8009db:	7f 29                	jg     800a06 <vprintfmt+0x33e>
	else if (lflag)
  8009dd:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8009e1:	74 44                	je     800a27 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8009e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e6:	8b 00                	mov    (%eax),%eax
  8009e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009f0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f6:	8d 40 04             	lea    0x4(%eax),%eax
  8009f9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009fc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a01:	e9 ea 00 00 00       	jmp    800af0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800a06:	8b 45 14             	mov    0x14(%ebp),%eax
  800a09:	8b 50 04             	mov    0x4(%eax),%edx
  800a0c:	8b 00                	mov    (%eax),%eax
  800a0e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a11:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a14:	8b 45 14             	mov    0x14(%ebp),%eax
  800a17:	8d 40 08             	lea    0x8(%eax),%eax
  800a1a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a1d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a22:	e9 c9 00 00 00       	jmp    800af0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800a27:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2a:	8b 00                	mov    (%eax),%eax
  800a2c:	ba 00 00 00 00       	mov    $0x0,%edx
  800a31:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a34:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a37:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3a:	8d 40 04             	lea    0x4(%eax),%eax
  800a3d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a40:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a45:	e9 a6 00 00 00       	jmp    800af0 <vprintfmt+0x428>
			putch('0', putdat);
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	53                   	push   %ebx
  800a4e:	6a 30                	push   $0x30
  800a50:	ff d6                	call   *%esi
	if (lflag >= 2)
  800a52:	83 c4 10             	add    $0x10,%esp
  800a55:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800a59:	7f 26                	jg     800a81 <vprintfmt+0x3b9>
	else if (lflag)
  800a5b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a5f:	74 3e                	je     800a9f <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800a61:	8b 45 14             	mov    0x14(%ebp),%eax
  800a64:	8b 00                	mov    (%eax),%eax
  800a66:	ba 00 00 00 00       	mov    $0x0,%edx
  800a6b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a6e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a71:	8b 45 14             	mov    0x14(%ebp),%eax
  800a74:	8d 40 04             	lea    0x4(%eax),%eax
  800a77:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a7a:	b8 08 00 00 00       	mov    $0x8,%eax
  800a7f:	eb 6f                	jmp    800af0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800a81:	8b 45 14             	mov    0x14(%ebp),%eax
  800a84:	8b 50 04             	mov    0x4(%eax),%edx
  800a87:	8b 00                	mov    (%eax),%eax
  800a89:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a8c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a92:	8d 40 08             	lea    0x8(%eax),%eax
  800a95:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a98:	b8 08 00 00 00       	mov    $0x8,%eax
  800a9d:	eb 51                	jmp    800af0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800a9f:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa2:	8b 00                	mov    (%eax),%eax
  800aa4:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aac:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800aaf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab2:	8d 40 04             	lea    0x4(%eax),%eax
  800ab5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800ab8:	b8 08 00 00 00       	mov    $0x8,%eax
  800abd:	eb 31                	jmp    800af0 <vprintfmt+0x428>
			putch('0', putdat);
  800abf:	83 ec 08             	sub    $0x8,%esp
  800ac2:	53                   	push   %ebx
  800ac3:	6a 30                	push   $0x30
  800ac5:	ff d6                	call   *%esi
			putch('x', putdat);
  800ac7:	83 c4 08             	add    $0x8,%esp
  800aca:	53                   	push   %ebx
  800acb:	6a 78                	push   $0x78
  800acd:	ff d6                	call   *%esi
			num = (unsigned long long)
  800acf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad2:	8b 00                	mov    (%eax),%eax
  800ad4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ad9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800adc:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800adf:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800ae2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae5:	8d 40 04             	lea    0x4(%eax),%eax
  800ae8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800aeb:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800af0:	83 ec 0c             	sub    $0xc,%esp
  800af3:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800af7:	52                   	push   %edx
  800af8:	ff 75 e0             	pushl  -0x20(%ebp)
  800afb:	50                   	push   %eax
  800afc:	ff 75 dc             	pushl  -0x24(%ebp)
  800aff:	ff 75 d8             	pushl  -0x28(%ebp)
  800b02:	89 da                	mov    %ebx,%edx
  800b04:	89 f0                	mov    %esi,%eax
  800b06:	e8 a4 fa ff ff       	call   8005af <printnum>
			break;
  800b0b:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800b0e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b11:	83 c7 01             	add    $0x1,%edi
  800b14:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800b18:	83 f8 25             	cmp    $0x25,%eax
  800b1b:	0f 84 be fb ff ff    	je     8006df <vprintfmt+0x17>
			if (ch == '\0')
  800b21:	85 c0                	test   %eax,%eax
  800b23:	0f 84 28 01 00 00    	je     800c51 <vprintfmt+0x589>
			putch(ch, putdat);
  800b29:	83 ec 08             	sub    $0x8,%esp
  800b2c:	53                   	push   %ebx
  800b2d:	50                   	push   %eax
  800b2e:	ff d6                	call   *%esi
  800b30:	83 c4 10             	add    $0x10,%esp
  800b33:	eb dc                	jmp    800b11 <vprintfmt+0x449>
	if (lflag >= 2)
  800b35:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800b39:	7f 26                	jg     800b61 <vprintfmt+0x499>
	else if (lflag)
  800b3b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800b3f:	74 41                	je     800b82 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800b41:	8b 45 14             	mov    0x14(%ebp),%eax
  800b44:	8b 00                	mov    (%eax),%eax
  800b46:	ba 00 00 00 00       	mov    $0x0,%edx
  800b4b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b4e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b51:	8b 45 14             	mov    0x14(%ebp),%eax
  800b54:	8d 40 04             	lea    0x4(%eax),%eax
  800b57:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b5a:	b8 10 00 00 00       	mov    $0x10,%eax
  800b5f:	eb 8f                	jmp    800af0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800b61:	8b 45 14             	mov    0x14(%ebp),%eax
  800b64:	8b 50 04             	mov    0x4(%eax),%edx
  800b67:	8b 00                	mov    (%eax),%eax
  800b69:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b6c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b72:	8d 40 08             	lea    0x8(%eax),%eax
  800b75:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b78:	b8 10 00 00 00       	mov    $0x10,%eax
  800b7d:	e9 6e ff ff ff       	jmp    800af0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800b82:	8b 45 14             	mov    0x14(%ebp),%eax
  800b85:	8b 00                	mov    (%eax),%eax
  800b87:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b8f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b92:	8b 45 14             	mov    0x14(%ebp),%eax
  800b95:	8d 40 04             	lea    0x4(%eax),%eax
  800b98:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b9b:	b8 10 00 00 00       	mov    $0x10,%eax
  800ba0:	e9 4b ff ff ff       	jmp    800af0 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800ba5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba8:	83 c0 04             	add    $0x4,%eax
  800bab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bae:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb1:	8b 00                	mov    (%eax),%eax
  800bb3:	85 c0                	test   %eax,%eax
  800bb5:	74 14                	je     800bcb <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800bb7:	8b 13                	mov    (%ebx),%edx
  800bb9:	83 fa 7f             	cmp    $0x7f,%edx
  800bbc:	7f 37                	jg     800bf5 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800bbe:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800bc0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800bc3:	89 45 14             	mov    %eax,0x14(%ebp)
  800bc6:	e9 43 ff ff ff       	jmp    800b0e <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800bcb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bd0:	bf c9 30 80 00       	mov    $0x8030c9,%edi
							putch(ch, putdat);
  800bd5:	83 ec 08             	sub    $0x8,%esp
  800bd8:	53                   	push   %ebx
  800bd9:	50                   	push   %eax
  800bda:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800bdc:	83 c7 01             	add    $0x1,%edi
  800bdf:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800be3:	83 c4 10             	add    $0x10,%esp
  800be6:	85 c0                	test   %eax,%eax
  800be8:	75 eb                	jne    800bd5 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800bea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800bed:	89 45 14             	mov    %eax,0x14(%ebp)
  800bf0:	e9 19 ff ff ff       	jmp    800b0e <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800bf5:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800bf7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bfc:	bf 01 31 80 00       	mov    $0x803101,%edi
							putch(ch, putdat);
  800c01:	83 ec 08             	sub    $0x8,%esp
  800c04:	53                   	push   %ebx
  800c05:	50                   	push   %eax
  800c06:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800c08:	83 c7 01             	add    $0x1,%edi
  800c0b:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800c0f:	83 c4 10             	add    $0x10,%esp
  800c12:	85 c0                	test   %eax,%eax
  800c14:	75 eb                	jne    800c01 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800c16:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c19:	89 45 14             	mov    %eax,0x14(%ebp)
  800c1c:	e9 ed fe ff ff       	jmp    800b0e <vprintfmt+0x446>
			putch(ch, putdat);
  800c21:	83 ec 08             	sub    $0x8,%esp
  800c24:	53                   	push   %ebx
  800c25:	6a 25                	push   $0x25
  800c27:	ff d6                	call   *%esi
			break;
  800c29:	83 c4 10             	add    $0x10,%esp
  800c2c:	e9 dd fe ff ff       	jmp    800b0e <vprintfmt+0x446>
			putch('%', putdat);
  800c31:	83 ec 08             	sub    $0x8,%esp
  800c34:	53                   	push   %ebx
  800c35:	6a 25                	push   $0x25
  800c37:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c39:	83 c4 10             	add    $0x10,%esp
  800c3c:	89 f8                	mov    %edi,%eax
  800c3e:	eb 03                	jmp    800c43 <vprintfmt+0x57b>
  800c40:	83 e8 01             	sub    $0x1,%eax
  800c43:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800c47:	75 f7                	jne    800c40 <vprintfmt+0x578>
  800c49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c4c:	e9 bd fe ff ff       	jmp    800b0e <vprintfmt+0x446>
}
  800c51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c54:	5b                   	pop    %ebx
  800c55:	5e                   	pop    %esi
  800c56:	5f                   	pop    %edi
  800c57:	5d                   	pop    %ebp
  800c58:	c3                   	ret    

00800c59 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c59:	55                   	push   %ebp
  800c5a:	89 e5                	mov    %esp,%ebp
  800c5c:	83 ec 18             	sub    $0x18,%esp
  800c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c62:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c65:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c68:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800c6c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800c6f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c76:	85 c0                	test   %eax,%eax
  800c78:	74 26                	je     800ca0 <vsnprintf+0x47>
  800c7a:	85 d2                	test   %edx,%edx
  800c7c:	7e 22                	jle    800ca0 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c7e:	ff 75 14             	pushl  0x14(%ebp)
  800c81:	ff 75 10             	pushl  0x10(%ebp)
  800c84:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c87:	50                   	push   %eax
  800c88:	68 8e 06 80 00       	push   $0x80068e
  800c8d:	e8 36 fa ff ff       	call   8006c8 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c95:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c9b:	83 c4 10             	add    $0x10,%esp
}
  800c9e:	c9                   	leave  
  800c9f:	c3                   	ret    
		return -E_INVAL;
  800ca0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ca5:	eb f7                	jmp    800c9e <vsnprintf+0x45>

00800ca7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ca7:	55                   	push   %ebp
  800ca8:	89 e5                	mov    %esp,%ebp
  800caa:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cad:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800cb0:	50                   	push   %eax
  800cb1:	ff 75 10             	pushl  0x10(%ebp)
  800cb4:	ff 75 0c             	pushl  0xc(%ebp)
  800cb7:	ff 75 08             	pushl  0x8(%ebp)
  800cba:	e8 9a ff ff ff       	call   800c59 <vsnprintf>
	va_end(ap);

	return rc;
}
  800cbf:	c9                   	leave  
  800cc0:	c3                   	ret    

00800cc1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800cc1:	55                   	push   %ebp
  800cc2:	89 e5                	mov    %esp,%ebp
  800cc4:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800cc7:	b8 00 00 00 00       	mov    $0x0,%eax
  800ccc:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800cd0:	74 05                	je     800cd7 <strlen+0x16>
		n++;
  800cd2:	83 c0 01             	add    $0x1,%eax
  800cd5:	eb f5                	jmp    800ccc <strlen+0xb>
	return n;
}
  800cd7:	5d                   	pop    %ebp
  800cd8:	c3                   	ret    

00800cd9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cdf:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ce2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce7:	39 c2                	cmp    %eax,%edx
  800ce9:	74 0d                	je     800cf8 <strnlen+0x1f>
  800ceb:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800cef:	74 05                	je     800cf6 <strnlen+0x1d>
		n++;
  800cf1:	83 c2 01             	add    $0x1,%edx
  800cf4:	eb f1                	jmp    800ce7 <strnlen+0xe>
  800cf6:	89 d0                	mov    %edx,%eax
	return n;
}
  800cf8:	5d                   	pop    %ebp
  800cf9:	c3                   	ret    

00800cfa <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cfa:	55                   	push   %ebp
  800cfb:	89 e5                	mov    %esp,%ebp
  800cfd:	53                   	push   %ebx
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800d04:	ba 00 00 00 00       	mov    $0x0,%edx
  800d09:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800d0d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800d10:	83 c2 01             	add    $0x1,%edx
  800d13:	84 c9                	test   %cl,%cl
  800d15:	75 f2                	jne    800d09 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800d17:	5b                   	pop    %ebx
  800d18:	5d                   	pop    %ebp
  800d19:	c3                   	ret    

00800d1a <strcat>:

char *
strcat(char *dst, const char *src)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
  800d1d:	53                   	push   %ebx
  800d1e:	83 ec 10             	sub    $0x10,%esp
  800d21:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800d24:	53                   	push   %ebx
  800d25:	e8 97 ff ff ff       	call   800cc1 <strlen>
  800d2a:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800d2d:	ff 75 0c             	pushl  0xc(%ebp)
  800d30:	01 d8                	add    %ebx,%eax
  800d32:	50                   	push   %eax
  800d33:	e8 c2 ff ff ff       	call   800cfa <strcpy>
	return dst;
}
  800d38:	89 d8                	mov    %ebx,%eax
  800d3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d3d:	c9                   	leave  
  800d3e:	c3                   	ret    

00800d3f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d3f:	55                   	push   %ebp
  800d40:	89 e5                	mov    %esp,%ebp
  800d42:	56                   	push   %esi
  800d43:	53                   	push   %ebx
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4a:	89 c6                	mov    %eax,%esi
  800d4c:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d4f:	89 c2                	mov    %eax,%edx
  800d51:	39 f2                	cmp    %esi,%edx
  800d53:	74 11                	je     800d66 <strncpy+0x27>
		*dst++ = *src;
  800d55:	83 c2 01             	add    $0x1,%edx
  800d58:	0f b6 19             	movzbl (%ecx),%ebx
  800d5b:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800d5e:	80 fb 01             	cmp    $0x1,%bl
  800d61:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800d64:	eb eb                	jmp    800d51 <strncpy+0x12>
	}
	return ret;
}
  800d66:	5b                   	pop    %ebx
  800d67:	5e                   	pop    %esi
  800d68:	5d                   	pop    %ebp
  800d69:	c3                   	ret    

00800d6a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
  800d6d:	56                   	push   %esi
  800d6e:	53                   	push   %ebx
  800d6f:	8b 75 08             	mov    0x8(%ebp),%esi
  800d72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d75:	8b 55 10             	mov    0x10(%ebp),%edx
  800d78:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800d7a:	85 d2                	test   %edx,%edx
  800d7c:	74 21                	je     800d9f <strlcpy+0x35>
  800d7e:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800d82:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800d84:	39 c2                	cmp    %eax,%edx
  800d86:	74 14                	je     800d9c <strlcpy+0x32>
  800d88:	0f b6 19             	movzbl (%ecx),%ebx
  800d8b:	84 db                	test   %bl,%bl
  800d8d:	74 0b                	je     800d9a <strlcpy+0x30>
			*dst++ = *src++;
  800d8f:	83 c1 01             	add    $0x1,%ecx
  800d92:	83 c2 01             	add    $0x1,%edx
  800d95:	88 5a ff             	mov    %bl,-0x1(%edx)
  800d98:	eb ea                	jmp    800d84 <strlcpy+0x1a>
  800d9a:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800d9c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d9f:	29 f0                	sub    %esi,%eax
}
  800da1:	5b                   	pop    %ebx
  800da2:	5e                   	pop    %esi
  800da3:	5d                   	pop    %ebp
  800da4:	c3                   	ret    

00800da5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800da5:	55                   	push   %ebp
  800da6:	89 e5                	mov    %esp,%ebp
  800da8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dab:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800dae:	0f b6 01             	movzbl (%ecx),%eax
  800db1:	84 c0                	test   %al,%al
  800db3:	74 0c                	je     800dc1 <strcmp+0x1c>
  800db5:	3a 02                	cmp    (%edx),%al
  800db7:	75 08                	jne    800dc1 <strcmp+0x1c>
		p++, q++;
  800db9:	83 c1 01             	add    $0x1,%ecx
  800dbc:	83 c2 01             	add    $0x1,%edx
  800dbf:	eb ed                	jmp    800dae <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dc1:	0f b6 c0             	movzbl %al,%eax
  800dc4:	0f b6 12             	movzbl (%edx),%edx
  800dc7:	29 d0                	sub    %edx,%eax
}
  800dc9:	5d                   	pop    %ebp
  800dca:	c3                   	ret    

00800dcb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800dcb:	55                   	push   %ebp
  800dcc:	89 e5                	mov    %esp,%ebp
  800dce:	53                   	push   %ebx
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd5:	89 c3                	mov    %eax,%ebx
  800dd7:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800dda:	eb 06                	jmp    800de2 <strncmp+0x17>
		n--, p++, q++;
  800ddc:	83 c0 01             	add    $0x1,%eax
  800ddf:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800de2:	39 d8                	cmp    %ebx,%eax
  800de4:	74 16                	je     800dfc <strncmp+0x31>
  800de6:	0f b6 08             	movzbl (%eax),%ecx
  800de9:	84 c9                	test   %cl,%cl
  800deb:	74 04                	je     800df1 <strncmp+0x26>
  800ded:	3a 0a                	cmp    (%edx),%cl
  800def:	74 eb                	je     800ddc <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800df1:	0f b6 00             	movzbl (%eax),%eax
  800df4:	0f b6 12             	movzbl (%edx),%edx
  800df7:	29 d0                	sub    %edx,%eax
}
  800df9:	5b                   	pop    %ebx
  800dfa:	5d                   	pop    %ebp
  800dfb:	c3                   	ret    
		return 0;
  800dfc:	b8 00 00 00 00       	mov    $0x0,%eax
  800e01:	eb f6                	jmp    800df9 <strncmp+0x2e>

00800e03 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e03:	55                   	push   %ebp
  800e04:	89 e5                	mov    %esp,%ebp
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e0d:	0f b6 10             	movzbl (%eax),%edx
  800e10:	84 d2                	test   %dl,%dl
  800e12:	74 09                	je     800e1d <strchr+0x1a>
		if (*s == c)
  800e14:	38 ca                	cmp    %cl,%dl
  800e16:	74 0a                	je     800e22 <strchr+0x1f>
	for (; *s; s++)
  800e18:	83 c0 01             	add    $0x1,%eax
  800e1b:	eb f0                	jmp    800e0d <strchr+0xa>
			return (char *) s;
	return 0;
  800e1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e22:	5d                   	pop    %ebp
  800e23:	c3                   	ret    

00800e24 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e2e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800e31:	38 ca                	cmp    %cl,%dl
  800e33:	74 09                	je     800e3e <strfind+0x1a>
  800e35:	84 d2                	test   %dl,%dl
  800e37:	74 05                	je     800e3e <strfind+0x1a>
	for (; *s; s++)
  800e39:	83 c0 01             	add    $0x1,%eax
  800e3c:	eb f0                	jmp    800e2e <strfind+0xa>
			break;
	return (char *) s;
}
  800e3e:	5d                   	pop    %ebp
  800e3f:	c3                   	ret    

00800e40 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	57                   	push   %edi
  800e44:	56                   	push   %esi
  800e45:	53                   	push   %ebx
  800e46:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e49:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800e4c:	85 c9                	test   %ecx,%ecx
  800e4e:	74 31                	je     800e81 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e50:	89 f8                	mov    %edi,%eax
  800e52:	09 c8                	or     %ecx,%eax
  800e54:	a8 03                	test   $0x3,%al
  800e56:	75 23                	jne    800e7b <memset+0x3b>
		c &= 0xFF;
  800e58:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800e5c:	89 d3                	mov    %edx,%ebx
  800e5e:	c1 e3 08             	shl    $0x8,%ebx
  800e61:	89 d0                	mov    %edx,%eax
  800e63:	c1 e0 18             	shl    $0x18,%eax
  800e66:	89 d6                	mov    %edx,%esi
  800e68:	c1 e6 10             	shl    $0x10,%esi
  800e6b:	09 f0                	or     %esi,%eax
  800e6d:	09 c2                	or     %eax,%edx
  800e6f:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800e71:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800e74:	89 d0                	mov    %edx,%eax
  800e76:	fc                   	cld    
  800e77:	f3 ab                	rep stos %eax,%es:(%edi)
  800e79:	eb 06                	jmp    800e81 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7e:	fc                   	cld    
  800e7f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800e81:	89 f8                	mov    %edi,%eax
  800e83:	5b                   	pop    %ebx
  800e84:	5e                   	pop    %esi
  800e85:	5f                   	pop    %edi
  800e86:	5d                   	pop    %ebp
  800e87:	c3                   	ret    

00800e88 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800e88:	55                   	push   %ebp
  800e89:	89 e5                	mov    %esp,%ebp
  800e8b:	57                   	push   %edi
  800e8c:	56                   	push   %esi
  800e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e90:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e93:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e96:	39 c6                	cmp    %eax,%esi
  800e98:	73 32                	jae    800ecc <memmove+0x44>
  800e9a:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800e9d:	39 c2                	cmp    %eax,%edx
  800e9f:	76 2b                	jbe    800ecc <memmove+0x44>
		s += n;
		d += n;
  800ea1:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ea4:	89 fe                	mov    %edi,%esi
  800ea6:	09 ce                	or     %ecx,%esi
  800ea8:	09 d6                	or     %edx,%esi
  800eaa:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800eb0:	75 0e                	jne    800ec0 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800eb2:	83 ef 04             	sub    $0x4,%edi
  800eb5:	8d 72 fc             	lea    -0x4(%edx),%esi
  800eb8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ebb:	fd                   	std    
  800ebc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ebe:	eb 09                	jmp    800ec9 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ec0:	83 ef 01             	sub    $0x1,%edi
  800ec3:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ec6:	fd                   	std    
  800ec7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ec9:	fc                   	cld    
  800eca:	eb 1a                	jmp    800ee6 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ecc:	89 c2                	mov    %eax,%edx
  800ece:	09 ca                	or     %ecx,%edx
  800ed0:	09 f2                	or     %esi,%edx
  800ed2:	f6 c2 03             	test   $0x3,%dl
  800ed5:	75 0a                	jne    800ee1 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ed7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800eda:	89 c7                	mov    %eax,%edi
  800edc:	fc                   	cld    
  800edd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800edf:	eb 05                	jmp    800ee6 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ee1:	89 c7                	mov    %eax,%edi
  800ee3:	fc                   	cld    
  800ee4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ee6:	5e                   	pop    %esi
  800ee7:	5f                   	pop    %edi
  800ee8:	5d                   	pop    %ebp
  800ee9:	c3                   	ret    

00800eea <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800eea:	55                   	push   %ebp
  800eeb:	89 e5                	mov    %esp,%ebp
  800eed:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ef0:	ff 75 10             	pushl  0x10(%ebp)
  800ef3:	ff 75 0c             	pushl  0xc(%ebp)
  800ef6:	ff 75 08             	pushl  0x8(%ebp)
  800ef9:	e8 8a ff ff ff       	call   800e88 <memmove>
}
  800efe:	c9                   	leave  
  800eff:	c3                   	ret    

00800f00 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800f00:	55                   	push   %ebp
  800f01:	89 e5                	mov    %esp,%ebp
  800f03:	56                   	push   %esi
  800f04:	53                   	push   %ebx
  800f05:	8b 45 08             	mov    0x8(%ebp),%eax
  800f08:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f0b:	89 c6                	mov    %eax,%esi
  800f0d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f10:	39 f0                	cmp    %esi,%eax
  800f12:	74 1c                	je     800f30 <memcmp+0x30>
		if (*s1 != *s2)
  800f14:	0f b6 08             	movzbl (%eax),%ecx
  800f17:	0f b6 1a             	movzbl (%edx),%ebx
  800f1a:	38 d9                	cmp    %bl,%cl
  800f1c:	75 08                	jne    800f26 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800f1e:	83 c0 01             	add    $0x1,%eax
  800f21:	83 c2 01             	add    $0x1,%edx
  800f24:	eb ea                	jmp    800f10 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800f26:	0f b6 c1             	movzbl %cl,%eax
  800f29:	0f b6 db             	movzbl %bl,%ebx
  800f2c:	29 d8                	sub    %ebx,%eax
  800f2e:	eb 05                	jmp    800f35 <memcmp+0x35>
	}

	return 0;
  800f30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f35:	5b                   	pop    %ebx
  800f36:	5e                   	pop    %esi
  800f37:	5d                   	pop    %ebp
  800f38:	c3                   	ret    

00800f39 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800f39:	55                   	push   %ebp
  800f3a:	89 e5                	mov    %esp,%ebp
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800f42:	89 c2                	mov    %eax,%edx
  800f44:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800f47:	39 d0                	cmp    %edx,%eax
  800f49:	73 09                	jae    800f54 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f4b:	38 08                	cmp    %cl,(%eax)
  800f4d:	74 05                	je     800f54 <memfind+0x1b>
	for (; s < ends; s++)
  800f4f:	83 c0 01             	add    $0x1,%eax
  800f52:	eb f3                	jmp    800f47 <memfind+0xe>
			break;
	return (void *) s;
}
  800f54:	5d                   	pop    %ebp
  800f55:	c3                   	ret    

00800f56 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f56:	55                   	push   %ebp
  800f57:	89 e5                	mov    %esp,%ebp
  800f59:	57                   	push   %edi
  800f5a:	56                   	push   %esi
  800f5b:	53                   	push   %ebx
  800f5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f5f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f62:	eb 03                	jmp    800f67 <strtol+0x11>
		s++;
  800f64:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800f67:	0f b6 01             	movzbl (%ecx),%eax
  800f6a:	3c 20                	cmp    $0x20,%al
  800f6c:	74 f6                	je     800f64 <strtol+0xe>
  800f6e:	3c 09                	cmp    $0x9,%al
  800f70:	74 f2                	je     800f64 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800f72:	3c 2b                	cmp    $0x2b,%al
  800f74:	74 2a                	je     800fa0 <strtol+0x4a>
	int neg = 0;
  800f76:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800f7b:	3c 2d                	cmp    $0x2d,%al
  800f7d:	74 2b                	je     800faa <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f7f:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800f85:	75 0f                	jne    800f96 <strtol+0x40>
  800f87:	80 39 30             	cmpb   $0x30,(%ecx)
  800f8a:	74 28                	je     800fb4 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800f8c:	85 db                	test   %ebx,%ebx
  800f8e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f93:	0f 44 d8             	cmove  %eax,%ebx
  800f96:	b8 00 00 00 00       	mov    $0x0,%eax
  800f9b:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800f9e:	eb 50                	jmp    800ff0 <strtol+0x9a>
		s++;
  800fa0:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800fa3:	bf 00 00 00 00       	mov    $0x0,%edi
  800fa8:	eb d5                	jmp    800f7f <strtol+0x29>
		s++, neg = 1;
  800faa:	83 c1 01             	add    $0x1,%ecx
  800fad:	bf 01 00 00 00       	mov    $0x1,%edi
  800fb2:	eb cb                	jmp    800f7f <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fb4:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800fb8:	74 0e                	je     800fc8 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800fba:	85 db                	test   %ebx,%ebx
  800fbc:	75 d8                	jne    800f96 <strtol+0x40>
		s++, base = 8;
  800fbe:	83 c1 01             	add    $0x1,%ecx
  800fc1:	bb 08 00 00 00       	mov    $0x8,%ebx
  800fc6:	eb ce                	jmp    800f96 <strtol+0x40>
		s += 2, base = 16;
  800fc8:	83 c1 02             	add    $0x2,%ecx
  800fcb:	bb 10 00 00 00       	mov    $0x10,%ebx
  800fd0:	eb c4                	jmp    800f96 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800fd2:	8d 72 9f             	lea    -0x61(%edx),%esi
  800fd5:	89 f3                	mov    %esi,%ebx
  800fd7:	80 fb 19             	cmp    $0x19,%bl
  800fda:	77 29                	ja     801005 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800fdc:	0f be d2             	movsbl %dl,%edx
  800fdf:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800fe2:	3b 55 10             	cmp    0x10(%ebp),%edx
  800fe5:	7d 30                	jge    801017 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800fe7:	83 c1 01             	add    $0x1,%ecx
  800fea:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fee:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ff0:	0f b6 11             	movzbl (%ecx),%edx
  800ff3:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ff6:	89 f3                	mov    %esi,%ebx
  800ff8:	80 fb 09             	cmp    $0x9,%bl
  800ffb:	77 d5                	ja     800fd2 <strtol+0x7c>
			dig = *s - '0';
  800ffd:	0f be d2             	movsbl %dl,%edx
  801000:	83 ea 30             	sub    $0x30,%edx
  801003:	eb dd                	jmp    800fe2 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  801005:	8d 72 bf             	lea    -0x41(%edx),%esi
  801008:	89 f3                	mov    %esi,%ebx
  80100a:	80 fb 19             	cmp    $0x19,%bl
  80100d:	77 08                	ja     801017 <strtol+0xc1>
			dig = *s - 'A' + 10;
  80100f:	0f be d2             	movsbl %dl,%edx
  801012:	83 ea 37             	sub    $0x37,%edx
  801015:	eb cb                	jmp    800fe2 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  801017:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80101b:	74 05                	je     801022 <strtol+0xcc>
		*endptr = (char *) s;
  80101d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801020:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801022:	89 c2                	mov    %eax,%edx
  801024:	f7 da                	neg    %edx
  801026:	85 ff                	test   %edi,%edi
  801028:	0f 45 c2             	cmovne %edx,%eax
}
  80102b:	5b                   	pop    %ebx
  80102c:	5e                   	pop    %esi
  80102d:	5f                   	pop    %edi
  80102e:	5d                   	pop    %ebp
  80102f:	c3                   	ret    

00801030 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801030:	55                   	push   %ebp
  801031:	89 e5                	mov    %esp,%ebp
  801033:	57                   	push   %edi
  801034:	56                   	push   %esi
  801035:	53                   	push   %ebx
	asm volatile("int %1\n"
  801036:	b8 00 00 00 00       	mov    $0x0,%eax
  80103b:	8b 55 08             	mov    0x8(%ebp),%edx
  80103e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801041:	89 c3                	mov    %eax,%ebx
  801043:	89 c7                	mov    %eax,%edi
  801045:	89 c6                	mov    %eax,%esi
  801047:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801049:	5b                   	pop    %ebx
  80104a:	5e                   	pop    %esi
  80104b:	5f                   	pop    %edi
  80104c:	5d                   	pop    %ebp
  80104d:	c3                   	ret    

0080104e <sys_cgetc>:

int
sys_cgetc(void)
{
  80104e:	55                   	push   %ebp
  80104f:	89 e5                	mov    %esp,%ebp
  801051:	57                   	push   %edi
  801052:	56                   	push   %esi
  801053:	53                   	push   %ebx
	asm volatile("int %1\n"
  801054:	ba 00 00 00 00       	mov    $0x0,%edx
  801059:	b8 01 00 00 00       	mov    $0x1,%eax
  80105e:	89 d1                	mov    %edx,%ecx
  801060:	89 d3                	mov    %edx,%ebx
  801062:	89 d7                	mov    %edx,%edi
  801064:	89 d6                	mov    %edx,%esi
  801066:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801068:	5b                   	pop    %ebx
  801069:	5e                   	pop    %esi
  80106a:	5f                   	pop    %edi
  80106b:	5d                   	pop    %ebp
  80106c:	c3                   	ret    

0080106d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80106d:	55                   	push   %ebp
  80106e:	89 e5                	mov    %esp,%ebp
  801070:	57                   	push   %edi
  801071:	56                   	push   %esi
  801072:	53                   	push   %ebx
  801073:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801076:	b9 00 00 00 00       	mov    $0x0,%ecx
  80107b:	8b 55 08             	mov    0x8(%ebp),%edx
  80107e:	b8 03 00 00 00       	mov    $0x3,%eax
  801083:	89 cb                	mov    %ecx,%ebx
  801085:	89 cf                	mov    %ecx,%edi
  801087:	89 ce                	mov    %ecx,%esi
  801089:	cd 30                	int    $0x30
	if(check && ret > 0)
  80108b:	85 c0                	test   %eax,%eax
  80108d:	7f 08                	jg     801097 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80108f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801092:	5b                   	pop    %ebx
  801093:	5e                   	pop    %esi
  801094:	5f                   	pop    %edi
  801095:	5d                   	pop    %ebp
  801096:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801097:	83 ec 0c             	sub    $0xc,%esp
  80109a:	50                   	push   %eax
  80109b:	6a 03                	push   $0x3
  80109d:	68 28 33 80 00       	push   $0x803328
  8010a2:	6a 43                	push   $0x43
  8010a4:	68 45 33 80 00       	push   $0x803345
  8010a9:	e8 f7 f3 ff ff       	call   8004a5 <_panic>

008010ae <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8010ae:	55                   	push   %ebp
  8010af:	89 e5                	mov    %esp,%ebp
  8010b1:	57                   	push   %edi
  8010b2:	56                   	push   %esi
  8010b3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8010b9:	b8 02 00 00 00       	mov    $0x2,%eax
  8010be:	89 d1                	mov    %edx,%ecx
  8010c0:	89 d3                	mov    %edx,%ebx
  8010c2:	89 d7                	mov    %edx,%edi
  8010c4:	89 d6                	mov    %edx,%esi
  8010c6:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8010c8:	5b                   	pop    %ebx
  8010c9:	5e                   	pop    %esi
  8010ca:	5f                   	pop    %edi
  8010cb:	5d                   	pop    %ebp
  8010cc:	c3                   	ret    

008010cd <sys_yield>:

void
sys_yield(void)
{
  8010cd:	55                   	push   %ebp
  8010ce:	89 e5                	mov    %esp,%ebp
  8010d0:	57                   	push   %edi
  8010d1:	56                   	push   %esi
  8010d2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8010d8:	b8 0b 00 00 00       	mov    $0xb,%eax
  8010dd:	89 d1                	mov    %edx,%ecx
  8010df:	89 d3                	mov    %edx,%ebx
  8010e1:	89 d7                	mov    %edx,%edi
  8010e3:	89 d6                	mov    %edx,%esi
  8010e5:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8010e7:	5b                   	pop    %ebx
  8010e8:	5e                   	pop    %esi
  8010e9:	5f                   	pop    %edi
  8010ea:	5d                   	pop    %ebp
  8010eb:	c3                   	ret    

008010ec <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8010ec:	55                   	push   %ebp
  8010ed:	89 e5                	mov    %esp,%ebp
  8010ef:	57                   	push   %edi
  8010f0:	56                   	push   %esi
  8010f1:	53                   	push   %ebx
  8010f2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010f5:	be 00 00 00 00       	mov    $0x0,%esi
  8010fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801100:	b8 04 00 00 00       	mov    $0x4,%eax
  801105:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801108:	89 f7                	mov    %esi,%edi
  80110a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80110c:	85 c0                	test   %eax,%eax
  80110e:	7f 08                	jg     801118 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801110:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801113:	5b                   	pop    %ebx
  801114:	5e                   	pop    %esi
  801115:	5f                   	pop    %edi
  801116:	5d                   	pop    %ebp
  801117:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801118:	83 ec 0c             	sub    $0xc,%esp
  80111b:	50                   	push   %eax
  80111c:	6a 04                	push   $0x4
  80111e:	68 28 33 80 00       	push   $0x803328
  801123:	6a 43                	push   $0x43
  801125:	68 45 33 80 00       	push   $0x803345
  80112a:	e8 76 f3 ff ff       	call   8004a5 <_panic>

0080112f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
  801132:	57                   	push   %edi
  801133:	56                   	push   %esi
  801134:	53                   	push   %ebx
  801135:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801138:	8b 55 08             	mov    0x8(%ebp),%edx
  80113b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80113e:	b8 05 00 00 00       	mov    $0x5,%eax
  801143:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801146:	8b 7d 14             	mov    0x14(%ebp),%edi
  801149:	8b 75 18             	mov    0x18(%ebp),%esi
  80114c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80114e:	85 c0                	test   %eax,%eax
  801150:	7f 08                	jg     80115a <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801152:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801155:	5b                   	pop    %ebx
  801156:	5e                   	pop    %esi
  801157:	5f                   	pop    %edi
  801158:	5d                   	pop    %ebp
  801159:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80115a:	83 ec 0c             	sub    $0xc,%esp
  80115d:	50                   	push   %eax
  80115e:	6a 05                	push   $0x5
  801160:	68 28 33 80 00       	push   $0x803328
  801165:	6a 43                	push   $0x43
  801167:	68 45 33 80 00       	push   $0x803345
  80116c:	e8 34 f3 ff ff       	call   8004a5 <_panic>

00801171 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801171:	55                   	push   %ebp
  801172:	89 e5                	mov    %esp,%ebp
  801174:	57                   	push   %edi
  801175:	56                   	push   %esi
  801176:	53                   	push   %ebx
  801177:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80117a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80117f:	8b 55 08             	mov    0x8(%ebp),%edx
  801182:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801185:	b8 06 00 00 00       	mov    $0x6,%eax
  80118a:	89 df                	mov    %ebx,%edi
  80118c:	89 de                	mov    %ebx,%esi
  80118e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801190:	85 c0                	test   %eax,%eax
  801192:	7f 08                	jg     80119c <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801194:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801197:	5b                   	pop    %ebx
  801198:	5e                   	pop    %esi
  801199:	5f                   	pop    %edi
  80119a:	5d                   	pop    %ebp
  80119b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80119c:	83 ec 0c             	sub    $0xc,%esp
  80119f:	50                   	push   %eax
  8011a0:	6a 06                	push   $0x6
  8011a2:	68 28 33 80 00       	push   $0x803328
  8011a7:	6a 43                	push   $0x43
  8011a9:	68 45 33 80 00       	push   $0x803345
  8011ae:	e8 f2 f2 ff ff       	call   8004a5 <_panic>

008011b3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8011b3:	55                   	push   %ebp
  8011b4:	89 e5                	mov    %esp,%ebp
  8011b6:	57                   	push   %edi
  8011b7:	56                   	push   %esi
  8011b8:	53                   	push   %ebx
  8011b9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011bc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c7:	b8 08 00 00 00       	mov    $0x8,%eax
  8011cc:	89 df                	mov    %ebx,%edi
  8011ce:	89 de                	mov    %ebx,%esi
  8011d0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011d2:	85 c0                	test   %eax,%eax
  8011d4:	7f 08                	jg     8011de <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8011d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011d9:	5b                   	pop    %ebx
  8011da:	5e                   	pop    %esi
  8011db:	5f                   	pop    %edi
  8011dc:	5d                   	pop    %ebp
  8011dd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011de:	83 ec 0c             	sub    $0xc,%esp
  8011e1:	50                   	push   %eax
  8011e2:	6a 08                	push   $0x8
  8011e4:	68 28 33 80 00       	push   $0x803328
  8011e9:	6a 43                	push   $0x43
  8011eb:	68 45 33 80 00       	push   $0x803345
  8011f0:	e8 b0 f2 ff ff       	call   8004a5 <_panic>

008011f5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8011f5:	55                   	push   %ebp
  8011f6:	89 e5                	mov    %esp,%ebp
  8011f8:	57                   	push   %edi
  8011f9:	56                   	push   %esi
  8011fa:	53                   	push   %ebx
  8011fb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011fe:	bb 00 00 00 00       	mov    $0x0,%ebx
  801203:	8b 55 08             	mov    0x8(%ebp),%edx
  801206:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801209:	b8 09 00 00 00       	mov    $0x9,%eax
  80120e:	89 df                	mov    %ebx,%edi
  801210:	89 de                	mov    %ebx,%esi
  801212:	cd 30                	int    $0x30
	if(check && ret > 0)
  801214:	85 c0                	test   %eax,%eax
  801216:	7f 08                	jg     801220 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801218:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80121b:	5b                   	pop    %ebx
  80121c:	5e                   	pop    %esi
  80121d:	5f                   	pop    %edi
  80121e:	5d                   	pop    %ebp
  80121f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801220:	83 ec 0c             	sub    $0xc,%esp
  801223:	50                   	push   %eax
  801224:	6a 09                	push   $0x9
  801226:	68 28 33 80 00       	push   $0x803328
  80122b:	6a 43                	push   $0x43
  80122d:	68 45 33 80 00       	push   $0x803345
  801232:	e8 6e f2 ff ff       	call   8004a5 <_panic>

00801237 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801237:	55                   	push   %ebp
  801238:	89 e5                	mov    %esp,%ebp
  80123a:	57                   	push   %edi
  80123b:	56                   	push   %esi
  80123c:	53                   	push   %ebx
  80123d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801240:	bb 00 00 00 00       	mov    $0x0,%ebx
  801245:	8b 55 08             	mov    0x8(%ebp),%edx
  801248:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80124b:	b8 0a 00 00 00       	mov    $0xa,%eax
  801250:	89 df                	mov    %ebx,%edi
  801252:	89 de                	mov    %ebx,%esi
  801254:	cd 30                	int    $0x30
	if(check && ret > 0)
  801256:	85 c0                	test   %eax,%eax
  801258:	7f 08                	jg     801262 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80125a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80125d:	5b                   	pop    %ebx
  80125e:	5e                   	pop    %esi
  80125f:	5f                   	pop    %edi
  801260:	5d                   	pop    %ebp
  801261:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801262:	83 ec 0c             	sub    $0xc,%esp
  801265:	50                   	push   %eax
  801266:	6a 0a                	push   $0xa
  801268:	68 28 33 80 00       	push   $0x803328
  80126d:	6a 43                	push   $0x43
  80126f:	68 45 33 80 00       	push   $0x803345
  801274:	e8 2c f2 ff ff       	call   8004a5 <_panic>

00801279 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801279:	55                   	push   %ebp
  80127a:	89 e5                	mov    %esp,%ebp
  80127c:	57                   	push   %edi
  80127d:	56                   	push   %esi
  80127e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80127f:	8b 55 08             	mov    0x8(%ebp),%edx
  801282:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801285:	b8 0c 00 00 00       	mov    $0xc,%eax
  80128a:	be 00 00 00 00       	mov    $0x0,%esi
  80128f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801292:	8b 7d 14             	mov    0x14(%ebp),%edi
  801295:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801297:	5b                   	pop    %ebx
  801298:	5e                   	pop    %esi
  801299:	5f                   	pop    %edi
  80129a:	5d                   	pop    %ebp
  80129b:	c3                   	ret    

0080129c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	57                   	push   %edi
  8012a0:	56                   	push   %esi
  8012a1:	53                   	push   %ebx
  8012a2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012a5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ad:	b8 0d 00 00 00       	mov    $0xd,%eax
  8012b2:	89 cb                	mov    %ecx,%ebx
  8012b4:	89 cf                	mov    %ecx,%edi
  8012b6:	89 ce                	mov    %ecx,%esi
  8012b8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012ba:	85 c0                	test   %eax,%eax
  8012bc:	7f 08                	jg     8012c6 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8012be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012c1:	5b                   	pop    %ebx
  8012c2:	5e                   	pop    %esi
  8012c3:	5f                   	pop    %edi
  8012c4:	5d                   	pop    %ebp
  8012c5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012c6:	83 ec 0c             	sub    $0xc,%esp
  8012c9:	50                   	push   %eax
  8012ca:	6a 0d                	push   $0xd
  8012cc:	68 28 33 80 00       	push   $0x803328
  8012d1:	6a 43                	push   $0x43
  8012d3:	68 45 33 80 00       	push   $0x803345
  8012d8:	e8 c8 f1 ff ff       	call   8004a5 <_panic>

008012dd <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8012dd:	55                   	push   %ebp
  8012de:	89 e5                	mov    %esp,%ebp
  8012e0:	57                   	push   %edi
  8012e1:	56                   	push   %esi
  8012e2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8012eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012ee:	b8 0e 00 00 00       	mov    $0xe,%eax
  8012f3:	89 df                	mov    %ebx,%edi
  8012f5:	89 de                	mov    %ebx,%esi
  8012f7:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8012f9:	5b                   	pop    %ebx
  8012fa:	5e                   	pop    %esi
  8012fb:	5f                   	pop    %edi
  8012fc:	5d                   	pop    %ebp
  8012fd:	c3                   	ret    

008012fe <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8012fe:	55                   	push   %ebp
  8012ff:	89 e5                	mov    %esp,%ebp
  801301:	57                   	push   %edi
  801302:	56                   	push   %esi
  801303:	53                   	push   %ebx
	asm volatile("int %1\n"
  801304:	b9 00 00 00 00       	mov    $0x0,%ecx
  801309:	8b 55 08             	mov    0x8(%ebp),%edx
  80130c:	b8 0f 00 00 00       	mov    $0xf,%eax
  801311:	89 cb                	mov    %ecx,%ebx
  801313:	89 cf                	mov    %ecx,%edi
  801315:	89 ce                	mov    %ecx,%esi
  801317:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801319:	5b                   	pop    %ebx
  80131a:	5e                   	pop    %esi
  80131b:	5f                   	pop    %edi
  80131c:	5d                   	pop    %ebp
  80131d:	c3                   	ret    

0080131e <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80131e:	55                   	push   %ebp
  80131f:	89 e5                	mov    %esp,%ebp
  801321:	57                   	push   %edi
  801322:	56                   	push   %esi
  801323:	53                   	push   %ebx
	asm volatile("int %1\n"
  801324:	ba 00 00 00 00       	mov    $0x0,%edx
  801329:	b8 10 00 00 00       	mov    $0x10,%eax
  80132e:	89 d1                	mov    %edx,%ecx
  801330:	89 d3                	mov    %edx,%ebx
  801332:	89 d7                	mov    %edx,%edi
  801334:	89 d6                	mov    %edx,%esi
  801336:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801338:	5b                   	pop    %ebx
  801339:	5e                   	pop    %esi
  80133a:	5f                   	pop    %edi
  80133b:	5d                   	pop    %ebp
  80133c:	c3                   	ret    

0080133d <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
  801340:	57                   	push   %edi
  801341:	56                   	push   %esi
  801342:	53                   	push   %ebx
	asm volatile("int %1\n"
  801343:	bb 00 00 00 00       	mov    $0x0,%ebx
  801348:	8b 55 08             	mov    0x8(%ebp),%edx
  80134b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80134e:	b8 11 00 00 00       	mov    $0x11,%eax
  801353:	89 df                	mov    %ebx,%edi
  801355:	89 de                	mov    %ebx,%esi
  801357:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801359:	5b                   	pop    %ebx
  80135a:	5e                   	pop    %esi
  80135b:	5f                   	pop    %edi
  80135c:	5d                   	pop    %ebp
  80135d:	c3                   	ret    

0080135e <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
  801361:	57                   	push   %edi
  801362:	56                   	push   %esi
  801363:	53                   	push   %ebx
	asm volatile("int %1\n"
  801364:	bb 00 00 00 00       	mov    $0x0,%ebx
  801369:	8b 55 08             	mov    0x8(%ebp),%edx
  80136c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80136f:	b8 12 00 00 00       	mov    $0x12,%eax
  801374:	89 df                	mov    %ebx,%edi
  801376:	89 de                	mov    %ebx,%esi
  801378:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80137a:	5b                   	pop    %ebx
  80137b:	5e                   	pop    %esi
  80137c:	5f                   	pop    %edi
  80137d:	5d                   	pop    %ebp
  80137e:	c3                   	ret    

0080137f <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80137f:	55                   	push   %ebp
  801380:	89 e5                	mov    %esp,%ebp
  801382:	57                   	push   %edi
  801383:	56                   	push   %esi
  801384:	53                   	push   %ebx
  801385:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801388:	bb 00 00 00 00       	mov    $0x0,%ebx
  80138d:	8b 55 08             	mov    0x8(%ebp),%edx
  801390:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801393:	b8 13 00 00 00       	mov    $0x13,%eax
  801398:	89 df                	mov    %ebx,%edi
  80139a:	89 de                	mov    %ebx,%esi
  80139c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80139e:	85 c0                	test   %eax,%eax
  8013a0:	7f 08                	jg     8013aa <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8013a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013a5:	5b                   	pop    %ebx
  8013a6:	5e                   	pop    %esi
  8013a7:	5f                   	pop    %edi
  8013a8:	5d                   	pop    %ebp
  8013a9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013aa:	83 ec 0c             	sub    $0xc,%esp
  8013ad:	50                   	push   %eax
  8013ae:	6a 13                	push   $0x13
  8013b0:	68 28 33 80 00       	push   $0x803328
  8013b5:	6a 43                	push   $0x43
  8013b7:	68 45 33 80 00       	push   $0x803345
  8013bc:	e8 e4 f0 ff ff       	call   8004a5 <_panic>

008013c1 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8013c1:	55                   	push   %ebp
  8013c2:	89 e5                	mov    %esp,%ebp
  8013c4:	57                   	push   %edi
  8013c5:	56                   	push   %esi
  8013c6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013c7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8013cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8013cf:	b8 14 00 00 00       	mov    $0x14,%eax
  8013d4:	89 cb                	mov    %ecx,%ebx
  8013d6:	89 cf                	mov    %ecx,%edi
  8013d8:	89 ce                	mov    %ecx,%esi
  8013da:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  8013dc:	5b                   	pop    %ebx
  8013dd:	5e                   	pop    %esi
  8013de:	5f                   	pop    %edi
  8013df:	5d                   	pop    %ebp
  8013e0:	c3                   	ret    

008013e1 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8013e1:	55                   	push   %ebp
  8013e2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	05 00 00 00 30       	add    $0x30000000,%eax
  8013ec:	c1 e8 0c             	shr    $0xc,%eax
}
  8013ef:	5d                   	pop    %ebp
  8013f0:	c3                   	ret    

008013f1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013f1:	55                   	push   %ebp
  8013f2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f7:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8013fc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801401:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801406:	5d                   	pop    %ebp
  801407:	c3                   	ret    

00801408 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
  80140b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801410:	89 c2                	mov    %eax,%edx
  801412:	c1 ea 16             	shr    $0x16,%edx
  801415:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80141c:	f6 c2 01             	test   $0x1,%dl
  80141f:	74 2d                	je     80144e <fd_alloc+0x46>
  801421:	89 c2                	mov    %eax,%edx
  801423:	c1 ea 0c             	shr    $0xc,%edx
  801426:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80142d:	f6 c2 01             	test   $0x1,%dl
  801430:	74 1c                	je     80144e <fd_alloc+0x46>
  801432:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801437:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80143c:	75 d2                	jne    801410 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80143e:	8b 45 08             	mov    0x8(%ebp),%eax
  801441:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801447:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80144c:	eb 0a                	jmp    801458 <fd_alloc+0x50>
			*fd_store = fd;
  80144e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801451:	89 01                	mov    %eax,(%ecx)
			return 0;
  801453:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801458:	5d                   	pop    %ebp
  801459:	c3                   	ret    

0080145a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80145a:	55                   	push   %ebp
  80145b:	89 e5                	mov    %esp,%ebp
  80145d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801460:	83 f8 1f             	cmp    $0x1f,%eax
  801463:	77 30                	ja     801495 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801465:	c1 e0 0c             	shl    $0xc,%eax
  801468:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80146d:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801473:	f6 c2 01             	test   $0x1,%dl
  801476:	74 24                	je     80149c <fd_lookup+0x42>
  801478:	89 c2                	mov    %eax,%edx
  80147a:	c1 ea 0c             	shr    $0xc,%edx
  80147d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801484:	f6 c2 01             	test   $0x1,%dl
  801487:	74 1a                	je     8014a3 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801489:	8b 55 0c             	mov    0xc(%ebp),%edx
  80148c:	89 02                	mov    %eax,(%edx)
	return 0;
  80148e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801493:	5d                   	pop    %ebp
  801494:	c3                   	ret    
		return -E_INVAL;
  801495:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80149a:	eb f7                	jmp    801493 <fd_lookup+0x39>
		return -E_INVAL;
  80149c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014a1:	eb f0                	jmp    801493 <fd_lookup+0x39>
  8014a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014a8:	eb e9                	jmp    801493 <fd_lookup+0x39>

008014aa <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
  8014ad:	83 ec 08             	sub    $0x8,%esp
  8014b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8014b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b8:	b8 90 57 80 00       	mov    $0x805790,%eax
		if (devtab[i]->dev_id == dev_id) {
  8014bd:	39 08                	cmp    %ecx,(%eax)
  8014bf:	74 38                	je     8014f9 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8014c1:	83 c2 01             	add    $0x1,%edx
  8014c4:	8b 04 95 d0 33 80 00 	mov    0x8033d0(,%edx,4),%eax
  8014cb:	85 c0                	test   %eax,%eax
  8014cd:	75 ee                	jne    8014bd <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8014cf:	a1 90 77 80 00       	mov    0x807790,%eax
  8014d4:	8b 40 48             	mov    0x48(%eax),%eax
  8014d7:	83 ec 04             	sub    $0x4,%esp
  8014da:	51                   	push   %ecx
  8014db:	50                   	push   %eax
  8014dc:	68 54 33 80 00       	push   $0x803354
  8014e1:	e8 b5 f0 ff ff       	call   80059b <cprintf>
	*dev = 0;
  8014e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8014ef:	83 c4 10             	add    $0x10,%esp
  8014f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    
			*dev = devtab[i];
  8014f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014fc:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014fe:	b8 00 00 00 00       	mov    $0x0,%eax
  801503:	eb f2                	jmp    8014f7 <dev_lookup+0x4d>

00801505 <fd_close>:
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
  801508:	57                   	push   %edi
  801509:	56                   	push   %esi
  80150a:	53                   	push   %ebx
  80150b:	83 ec 24             	sub    $0x24,%esp
  80150e:	8b 75 08             	mov    0x8(%ebp),%esi
  801511:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801514:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801517:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801518:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80151e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801521:	50                   	push   %eax
  801522:	e8 33 ff ff ff       	call   80145a <fd_lookup>
  801527:	89 c3                	mov    %eax,%ebx
  801529:	83 c4 10             	add    $0x10,%esp
  80152c:	85 c0                	test   %eax,%eax
  80152e:	78 05                	js     801535 <fd_close+0x30>
	    || fd != fd2)
  801530:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801533:	74 16                	je     80154b <fd_close+0x46>
		return (must_exist ? r : 0);
  801535:	89 f8                	mov    %edi,%eax
  801537:	84 c0                	test   %al,%al
  801539:	b8 00 00 00 00       	mov    $0x0,%eax
  80153e:	0f 44 d8             	cmove  %eax,%ebx
}
  801541:	89 d8                	mov    %ebx,%eax
  801543:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801546:	5b                   	pop    %ebx
  801547:	5e                   	pop    %esi
  801548:	5f                   	pop    %edi
  801549:	5d                   	pop    %ebp
  80154a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80154b:	83 ec 08             	sub    $0x8,%esp
  80154e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801551:	50                   	push   %eax
  801552:	ff 36                	pushl  (%esi)
  801554:	e8 51 ff ff ff       	call   8014aa <dev_lookup>
  801559:	89 c3                	mov    %eax,%ebx
  80155b:	83 c4 10             	add    $0x10,%esp
  80155e:	85 c0                	test   %eax,%eax
  801560:	78 1a                	js     80157c <fd_close+0x77>
		if (dev->dev_close)
  801562:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801565:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801568:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80156d:	85 c0                	test   %eax,%eax
  80156f:	74 0b                	je     80157c <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801571:	83 ec 0c             	sub    $0xc,%esp
  801574:	56                   	push   %esi
  801575:	ff d0                	call   *%eax
  801577:	89 c3                	mov    %eax,%ebx
  801579:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80157c:	83 ec 08             	sub    $0x8,%esp
  80157f:	56                   	push   %esi
  801580:	6a 00                	push   $0x0
  801582:	e8 ea fb ff ff       	call   801171 <sys_page_unmap>
	return r;
  801587:	83 c4 10             	add    $0x10,%esp
  80158a:	eb b5                	jmp    801541 <fd_close+0x3c>

0080158c <close>:

int
close(int fdnum)
{
  80158c:	55                   	push   %ebp
  80158d:	89 e5                	mov    %esp,%ebp
  80158f:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801592:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801595:	50                   	push   %eax
  801596:	ff 75 08             	pushl  0x8(%ebp)
  801599:	e8 bc fe ff ff       	call   80145a <fd_lookup>
  80159e:	83 c4 10             	add    $0x10,%esp
  8015a1:	85 c0                	test   %eax,%eax
  8015a3:	79 02                	jns    8015a7 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8015a5:	c9                   	leave  
  8015a6:	c3                   	ret    
		return fd_close(fd, 1);
  8015a7:	83 ec 08             	sub    $0x8,%esp
  8015aa:	6a 01                	push   $0x1
  8015ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8015af:	e8 51 ff ff ff       	call   801505 <fd_close>
  8015b4:	83 c4 10             	add    $0x10,%esp
  8015b7:	eb ec                	jmp    8015a5 <close+0x19>

008015b9 <close_all>:

void
close_all(void)
{
  8015b9:	55                   	push   %ebp
  8015ba:	89 e5                	mov    %esp,%ebp
  8015bc:	53                   	push   %ebx
  8015bd:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8015c0:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8015c5:	83 ec 0c             	sub    $0xc,%esp
  8015c8:	53                   	push   %ebx
  8015c9:	e8 be ff ff ff       	call   80158c <close>
	for (i = 0; i < MAXFD; i++)
  8015ce:	83 c3 01             	add    $0x1,%ebx
  8015d1:	83 c4 10             	add    $0x10,%esp
  8015d4:	83 fb 20             	cmp    $0x20,%ebx
  8015d7:	75 ec                	jne    8015c5 <close_all+0xc>
}
  8015d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015dc:	c9                   	leave  
  8015dd:	c3                   	ret    

008015de <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
  8015e1:	57                   	push   %edi
  8015e2:	56                   	push   %esi
  8015e3:	53                   	push   %ebx
  8015e4:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015e7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015ea:	50                   	push   %eax
  8015eb:	ff 75 08             	pushl  0x8(%ebp)
  8015ee:	e8 67 fe ff ff       	call   80145a <fd_lookup>
  8015f3:	89 c3                	mov    %eax,%ebx
  8015f5:	83 c4 10             	add    $0x10,%esp
  8015f8:	85 c0                	test   %eax,%eax
  8015fa:	0f 88 81 00 00 00    	js     801681 <dup+0xa3>
		return r;
	close(newfdnum);
  801600:	83 ec 0c             	sub    $0xc,%esp
  801603:	ff 75 0c             	pushl  0xc(%ebp)
  801606:	e8 81 ff ff ff       	call   80158c <close>

	newfd = INDEX2FD(newfdnum);
  80160b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80160e:	c1 e6 0c             	shl    $0xc,%esi
  801611:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801617:	83 c4 04             	add    $0x4,%esp
  80161a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80161d:	e8 cf fd ff ff       	call   8013f1 <fd2data>
  801622:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801624:	89 34 24             	mov    %esi,(%esp)
  801627:	e8 c5 fd ff ff       	call   8013f1 <fd2data>
  80162c:	83 c4 10             	add    $0x10,%esp
  80162f:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801631:	89 d8                	mov    %ebx,%eax
  801633:	c1 e8 16             	shr    $0x16,%eax
  801636:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80163d:	a8 01                	test   $0x1,%al
  80163f:	74 11                	je     801652 <dup+0x74>
  801641:	89 d8                	mov    %ebx,%eax
  801643:	c1 e8 0c             	shr    $0xc,%eax
  801646:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80164d:	f6 c2 01             	test   $0x1,%dl
  801650:	75 39                	jne    80168b <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801652:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801655:	89 d0                	mov    %edx,%eax
  801657:	c1 e8 0c             	shr    $0xc,%eax
  80165a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801661:	83 ec 0c             	sub    $0xc,%esp
  801664:	25 07 0e 00 00       	and    $0xe07,%eax
  801669:	50                   	push   %eax
  80166a:	56                   	push   %esi
  80166b:	6a 00                	push   $0x0
  80166d:	52                   	push   %edx
  80166e:	6a 00                	push   $0x0
  801670:	e8 ba fa ff ff       	call   80112f <sys_page_map>
  801675:	89 c3                	mov    %eax,%ebx
  801677:	83 c4 20             	add    $0x20,%esp
  80167a:	85 c0                	test   %eax,%eax
  80167c:	78 31                	js     8016af <dup+0xd1>
		goto err;

	return newfdnum;
  80167e:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801681:	89 d8                	mov    %ebx,%eax
  801683:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801686:	5b                   	pop    %ebx
  801687:	5e                   	pop    %esi
  801688:	5f                   	pop    %edi
  801689:	5d                   	pop    %ebp
  80168a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80168b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801692:	83 ec 0c             	sub    $0xc,%esp
  801695:	25 07 0e 00 00       	and    $0xe07,%eax
  80169a:	50                   	push   %eax
  80169b:	57                   	push   %edi
  80169c:	6a 00                	push   $0x0
  80169e:	53                   	push   %ebx
  80169f:	6a 00                	push   $0x0
  8016a1:	e8 89 fa ff ff       	call   80112f <sys_page_map>
  8016a6:	89 c3                	mov    %eax,%ebx
  8016a8:	83 c4 20             	add    $0x20,%esp
  8016ab:	85 c0                	test   %eax,%eax
  8016ad:	79 a3                	jns    801652 <dup+0x74>
	sys_page_unmap(0, newfd);
  8016af:	83 ec 08             	sub    $0x8,%esp
  8016b2:	56                   	push   %esi
  8016b3:	6a 00                	push   $0x0
  8016b5:	e8 b7 fa ff ff       	call   801171 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8016ba:	83 c4 08             	add    $0x8,%esp
  8016bd:	57                   	push   %edi
  8016be:	6a 00                	push   $0x0
  8016c0:	e8 ac fa ff ff       	call   801171 <sys_page_unmap>
	return r;
  8016c5:	83 c4 10             	add    $0x10,%esp
  8016c8:	eb b7                	jmp    801681 <dup+0xa3>

008016ca <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016ca:	55                   	push   %ebp
  8016cb:	89 e5                	mov    %esp,%ebp
  8016cd:	53                   	push   %ebx
  8016ce:	83 ec 1c             	sub    $0x1c,%esp
  8016d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016d7:	50                   	push   %eax
  8016d8:	53                   	push   %ebx
  8016d9:	e8 7c fd ff ff       	call   80145a <fd_lookup>
  8016de:	83 c4 10             	add    $0x10,%esp
  8016e1:	85 c0                	test   %eax,%eax
  8016e3:	78 3f                	js     801724 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016e5:	83 ec 08             	sub    $0x8,%esp
  8016e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016eb:	50                   	push   %eax
  8016ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ef:	ff 30                	pushl  (%eax)
  8016f1:	e8 b4 fd ff ff       	call   8014aa <dev_lookup>
  8016f6:	83 c4 10             	add    $0x10,%esp
  8016f9:	85 c0                	test   %eax,%eax
  8016fb:	78 27                	js     801724 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801700:	8b 42 08             	mov    0x8(%edx),%eax
  801703:	83 e0 03             	and    $0x3,%eax
  801706:	83 f8 01             	cmp    $0x1,%eax
  801709:	74 1e                	je     801729 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80170b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80170e:	8b 40 08             	mov    0x8(%eax),%eax
  801711:	85 c0                	test   %eax,%eax
  801713:	74 35                	je     80174a <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801715:	83 ec 04             	sub    $0x4,%esp
  801718:	ff 75 10             	pushl  0x10(%ebp)
  80171b:	ff 75 0c             	pushl  0xc(%ebp)
  80171e:	52                   	push   %edx
  80171f:	ff d0                	call   *%eax
  801721:	83 c4 10             	add    $0x10,%esp
}
  801724:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801727:	c9                   	leave  
  801728:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801729:	a1 90 77 80 00       	mov    0x807790,%eax
  80172e:	8b 40 48             	mov    0x48(%eax),%eax
  801731:	83 ec 04             	sub    $0x4,%esp
  801734:	53                   	push   %ebx
  801735:	50                   	push   %eax
  801736:	68 95 33 80 00       	push   $0x803395
  80173b:	e8 5b ee ff ff       	call   80059b <cprintf>
		return -E_INVAL;
  801740:	83 c4 10             	add    $0x10,%esp
  801743:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801748:	eb da                	jmp    801724 <read+0x5a>
		return -E_NOT_SUPP;
  80174a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80174f:	eb d3                	jmp    801724 <read+0x5a>

00801751 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801751:	55                   	push   %ebp
  801752:	89 e5                	mov    %esp,%ebp
  801754:	57                   	push   %edi
  801755:	56                   	push   %esi
  801756:	53                   	push   %ebx
  801757:	83 ec 0c             	sub    $0xc,%esp
  80175a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80175d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801760:	bb 00 00 00 00       	mov    $0x0,%ebx
  801765:	39 f3                	cmp    %esi,%ebx
  801767:	73 23                	jae    80178c <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801769:	83 ec 04             	sub    $0x4,%esp
  80176c:	89 f0                	mov    %esi,%eax
  80176e:	29 d8                	sub    %ebx,%eax
  801770:	50                   	push   %eax
  801771:	89 d8                	mov    %ebx,%eax
  801773:	03 45 0c             	add    0xc(%ebp),%eax
  801776:	50                   	push   %eax
  801777:	57                   	push   %edi
  801778:	e8 4d ff ff ff       	call   8016ca <read>
		if (m < 0)
  80177d:	83 c4 10             	add    $0x10,%esp
  801780:	85 c0                	test   %eax,%eax
  801782:	78 06                	js     80178a <readn+0x39>
			return m;
		if (m == 0)
  801784:	74 06                	je     80178c <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801786:	01 c3                	add    %eax,%ebx
  801788:	eb db                	jmp    801765 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80178a:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80178c:	89 d8                	mov    %ebx,%eax
  80178e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801791:	5b                   	pop    %ebx
  801792:	5e                   	pop    %esi
  801793:	5f                   	pop    %edi
  801794:	5d                   	pop    %ebp
  801795:	c3                   	ret    

00801796 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
  801799:	53                   	push   %ebx
  80179a:	83 ec 1c             	sub    $0x1c,%esp
  80179d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017a3:	50                   	push   %eax
  8017a4:	53                   	push   %ebx
  8017a5:	e8 b0 fc ff ff       	call   80145a <fd_lookup>
  8017aa:	83 c4 10             	add    $0x10,%esp
  8017ad:	85 c0                	test   %eax,%eax
  8017af:	78 3a                	js     8017eb <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017b1:	83 ec 08             	sub    $0x8,%esp
  8017b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017b7:	50                   	push   %eax
  8017b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017bb:	ff 30                	pushl  (%eax)
  8017bd:	e8 e8 fc ff ff       	call   8014aa <dev_lookup>
  8017c2:	83 c4 10             	add    $0x10,%esp
  8017c5:	85 c0                	test   %eax,%eax
  8017c7:	78 22                	js     8017eb <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017cc:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017d0:	74 1e                	je     8017f0 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8017d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d5:	8b 52 0c             	mov    0xc(%edx),%edx
  8017d8:	85 d2                	test   %edx,%edx
  8017da:	74 35                	je     801811 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017dc:	83 ec 04             	sub    $0x4,%esp
  8017df:	ff 75 10             	pushl  0x10(%ebp)
  8017e2:	ff 75 0c             	pushl  0xc(%ebp)
  8017e5:	50                   	push   %eax
  8017e6:	ff d2                	call   *%edx
  8017e8:	83 c4 10             	add    $0x10,%esp
}
  8017eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ee:	c9                   	leave  
  8017ef:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017f0:	a1 90 77 80 00       	mov    0x807790,%eax
  8017f5:	8b 40 48             	mov    0x48(%eax),%eax
  8017f8:	83 ec 04             	sub    $0x4,%esp
  8017fb:	53                   	push   %ebx
  8017fc:	50                   	push   %eax
  8017fd:	68 b1 33 80 00       	push   $0x8033b1
  801802:	e8 94 ed ff ff       	call   80059b <cprintf>
		return -E_INVAL;
  801807:	83 c4 10             	add    $0x10,%esp
  80180a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80180f:	eb da                	jmp    8017eb <write+0x55>
		return -E_NOT_SUPP;
  801811:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801816:	eb d3                	jmp    8017eb <write+0x55>

00801818 <seek>:

int
seek(int fdnum, off_t offset)
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
  80181b:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80181e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801821:	50                   	push   %eax
  801822:	ff 75 08             	pushl  0x8(%ebp)
  801825:	e8 30 fc ff ff       	call   80145a <fd_lookup>
  80182a:	83 c4 10             	add    $0x10,%esp
  80182d:	85 c0                	test   %eax,%eax
  80182f:	78 0e                	js     80183f <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801831:	8b 55 0c             	mov    0xc(%ebp),%edx
  801834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801837:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80183a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80183f:	c9                   	leave  
  801840:	c3                   	ret    

00801841 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
  801844:	53                   	push   %ebx
  801845:	83 ec 1c             	sub    $0x1c,%esp
  801848:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80184b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80184e:	50                   	push   %eax
  80184f:	53                   	push   %ebx
  801850:	e8 05 fc ff ff       	call   80145a <fd_lookup>
  801855:	83 c4 10             	add    $0x10,%esp
  801858:	85 c0                	test   %eax,%eax
  80185a:	78 37                	js     801893 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80185c:	83 ec 08             	sub    $0x8,%esp
  80185f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801862:	50                   	push   %eax
  801863:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801866:	ff 30                	pushl  (%eax)
  801868:	e8 3d fc ff ff       	call   8014aa <dev_lookup>
  80186d:	83 c4 10             	add    $0x10,%esp
  801870:	85 c0                	test   %eax,%eax
  801872:	78 1f                	js     801893 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801874:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801877:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80187b:	74 1b                	je     801898 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80187d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801880:	8b 52 18             	mov    0x18(%edx),%edx
  801883:	85 d2                	test   %edx,%edx
  801885:	74 32                	je     8018b9 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801887:	83 ec 08             	sub    $0x8,%esp
  80188a:	ff 75 0c             	pushl  0xc(%ebp)
  80188d:	50                   	push   %eax
  80188e:	ff d2                	call   *%edx
  801890:	83 c4 10             	add    $0x10,%esp
}
  801893:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801896:	c9                   	leave  
  801897:	c3                   	ret    
			thisenv->env_id, fdnum);
  801898:	a1 90 77 80 00       	mov    0x807790,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80189d:	8b 40 48             	mov    0x48(%eax),%eax
  8018a0:	83 ec 04             	sub    $0x4,%esp
  8018a3:	53                   	push   %ebx
  8018a4:	50                   	push   %eax
  8018a5:	68 74 33 80 00       	push   $0x803374
  8018aa:	e8 ec ec ff ff       	call   80059b <cprintf>
		return -E_INVAL;
  8018af:	83 c4 10             	add    $0x10,%esp
  8018b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018b7:	eb da                	jmp    801893 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8018b9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018be:	eb d3                	jmp    801893 <ftruncate+0x52>

008018c0 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	53                   	push   %ebx
  8018c4:	83 ec 1c             	sub    $0x1c,%esp
  8018c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018ca:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018cd:	50                   	push   %eax
  8018ce:	ff 75 08             	pushl  0x8(%ebp)
  8018d1:	e8 84 fb ff ff       	call   80145a <fd_lookup>
  8018d6:	83 c4 10             	add    $0x10,%esp
  8018d9:	85 c0                	test   %eax,%eax
  8018db:	78 4b                	js     801928 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018dd:	83 ec 08             	sub    $0x8,%esp
  8018e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018e3:	50                   	push   %eax
  8018e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e7:	ff 30                	pushl  (%eax)
  8018e9:	e8 bc fb ff ff       	call   8014aa <dev_lookup>
  8018ee:	83 c4 10             	add    $0x10,%esp
  8018f1:	85 c0                	test   %eax,%eax
  8018f3:	78 33                	js     801928 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8018f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f8:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018fc:	74 2f                	je     80192d <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018fe:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801901:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801908:	00 00 00 
	stat->st_isdir = 0;
  80190b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801912:	00 00 00 
	stat->st_dev = dev;
  801915:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80191b:	83 ec 08             	sub    $0x8,%esp
  80191e:	53                   	push   %ebx
  80191f:	ff 75 f0             	pushl  -0x10(%ebp)
  801922:	ff 50 14             	call   *0x14(%eax)
  801925:	83 c4 10             	add    $0x10,%esp
}
  801928:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80192b:	c9                   	leave  
  80192c:	c3                   	ret    
		return -E_NOT_SUPP;
  80192d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801932:	eb f4                	jmp    801928 <fstat+0x68>

00801934 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
  801937:	56                   	push   %esi
  801938:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801939:	83 ec 08             	sub    $0x8,%esp
  80193c:	6a 00                	push   $0x0
  80193e:	ff 75 08             	pushl  0x8(%ebp)
  801941:	e8 22 02 00 00       	call   801b68 <open>
  801946:	89 c3                	mov    %eax,%ebx
  801948:	83 c4 10             	add    $0x10,%esp
  80194b:	85 c0                	test   %eax,%eax
  80194d:	78 1b                	js     80196a <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80194f:	83 ec 08             	sub    $0x8,%esp
  801952:	ff 75 0c             	pushl  0xc(%ebp)
  801955:	50                   	push   %eax
  801956:	e8 65 ff ff ff       	call   8018c0 <fstat>
  80195b:	89 c6                	mov    %eax,%esi
	close(fd);
  80195d:	89 1c 24             	mov    %ebx,(%esp)
  801960:	e8 27 fc ff ff       	call   80158c <close>
	return r;
  801965:	83 c4 10             	add    $0x10,%esp
  801968:	89 f3                	mov    %esi,%ebx
}
  80196a:	89 d8                	mov    %ebx,%eax
  80196c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80196f:	5b                   	pop    %ebx
  801970:	5e                   	pop    %esi
  801971:	5d                   	pop    %ebp
  801972:	c3                   	ret    

00801973 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
  801976:	56                   	push   %esi
  801977:	53                   	push   %ebx
  801978:	89 c6                	mov    %eax,%esi
  80197a:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80197c:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801983:	74 27                	je     8019ac <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801985:	6a 07                	push   $0x7
  801987:	68 00 80 80 00       	push   $0x808000
  80198c:	56                   	push   %esi
  80198d:	ff 35 00 60 80 00    	pushl  0x806000
  801993:	e8 02 11 00 00       	call   802a9a <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801998:	83 c4 0c             	add    $0xc,%esp
  80199b:	6a 00                	push   $0x0
  80199d:	53                   	push   %ebx
  80199e:	6a 00                	push   $0x0
  8019a0:	e8 8c 10 00 00       	call   802a31 <ipc_recv>
}
  8019a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019a8:	5b                   	pop    %ebx
  8019a9:	5e                   	pop    %esi
  8019aa:	5d                   	pop    %ebp
  8019ab:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8019ac:	83 ec 0c             	sub    $0xc,%esp
  8019af:	6a 01                	push   $0x1
  8019b1:	e8 3c 11 00 00       	call   802af2 <ipc_find_env>
  8019b6:	a3 00 60 80 00       	mov    %eax,0x806000
  8019bb:	83 c4 10             	add    $0x10,%esp
  8019be:	eb c5                	jmp    801985 <fsipc+0x12>

008019c0 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
  8019c3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8019cc:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.set_size.req_size = newsize;
  8019d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d4:	a3 04 80 80 00       	mov    %eax,0x808004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8019d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8019de:	b8 02 00 00 00       	mov    $0x2,%eax
  8019e3:	e8 8b ff ff ff       	call   801973 <fsipc>
}
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <devfile_flush>:
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
  8019ed:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8019f6:	a3 00 80 80 00       	mov    %eax,0x808000
	return fsipc(FSREQ_FLUSH, NULL);
  8019fb:	ba 00 00 00 00       	mov    $0x0,%edx
  801a00:	b8 06 00 00 00       	mov    $0x6,%eax
  801a05:	e8 69 ff ff ff       	call   801973 <fsipc>
}
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    

00801a0c <devfile_stat>:
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
  801a0f:	53                   	push   %ebx
  801a10:	83 ec 04             	sub    $0x4,%esp
  801a13:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	8b 40 0c             	mov    0xc(%eax),%eax
  801a1c:	a3 00 80 80 00       	mov    %eax,0x808000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a21:	ba 00 00 00 00       	mov    $0x0,%edx
  801a26:	b8 05 00 00 00       	mov    $0x5,%eax
  801a2b:	e8 43 ff ff ff       	call   801973 <fsipc>
  801a30:	85 c0                	test   %eax,%eax
  801a32:	78 2c                	js     801a60 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a34:	83 ec 08             	sub    $0x8,%esp
  801a37:	68 00 80 80 00       	push   $0x808000
  801a3c:	53                   	push   %ebx
  801a3d:	e8 b8 f2 ff ff       	call   800cfa <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a42:	a1 80 80 80 00       	mov    0x808080,%eax
  801a47:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a4d:	a1 84 80 80 00       	mov    0x808084,%eax
  801a52:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a58:	83 c4 10             	add    $0x10,%esp
  801a5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <devfile_write>:
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
  801a68:	53                   	push   %ebx
  801a69:	83 ec 08             	sub    $0x8,%esp
  801a6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a72:	8b 40 0c             	mov    0xc(%eax),%eax
  801a75:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.write.req_n = n;
  801a7a:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801a80:	53                   	push   %ebx
  801a81:	ff 75 0c             	pushl  0xc(%ebp)
  801a84:	68 08 80 80 00       	push   $0x808008
  801a89:	e8 5c f4 ff ff       	call   800eea <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801a8e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a93:	b8 04 00 00 00       	mov    $0x4,%eax
  801a98:	e8 d6 fe ff ff       	call   801973 <fsipc>
  801a9d:	83 c4 10             	add    $0x10,%esp
  801aa0:	85 c0                	test   %eax,%eax
  801aa2:	78 0b                	js     801aaf <devfile_write+0x4a>
	assert(r <= n);
  801aa4:	39 d8                	cmp    %ebx,%eax
  801aa6:	77 0c                	ja     801ab4 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801aa8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801aad:	7f 1e                	jg     801acd <devfile_write+0x68>
}
  801aaf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    
	assert(r <= n);
  801ab4:	68 e4 33 80 00       	push   $0x8033e4
  801ab9:	68 eb 33 80 00       	push   $0x8033eb
  801abe:	68 98 00 00 00       	push   $0x98
  801ac3:	68 00 34 80 00       	push   $0x803400
  801ac8:	e8 d8 e9 ff ff       	call   8004a5 <_panic>
	assert(r <= PGSIZE);
  801acd:	68 0b 34 80 00       	push   $0x80340b
  801ad2:	68 eb 33 80 00       	push   $0x8033eb
  801ad7:	68 99 00 00 00       	push   $0x99
  801adc:	68 00 34 80 00       	push   $0x803400
  801ae1:	e8 bf e9 ff ff       	call   8004a5 <_panic>

00801ae6 <devfile_read>:
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
  801ae9:	56                   	push   %esi
  801aea:	53                   	push   %ebx
  801aeb:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801aee:	8b 45 08             	mov    0x8(%ebp),%eax
  801af1:	8b 40 0c             	mov    0xc(%eax),%eax
  801af4:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.read.req_n = n;
  801af9:	89 35 04 80 80 00    	mov    %esi,0x808004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801aff:	ba 00 00 00 00       	mov    $0x0,%edx
  801b04:	b8 03 00 00 00       	mov    $0x3,%eax
  801b09:	e8 65 fe ff ff       	call   801973 <fsipc>
  801b0e:	89 c3                	mov    %eax,%ebx
  801b10:	85 c0                	test   %eax,%eax
  801b12:	78 1f                	js     801b33 <devfile_read+0x4d>
	assert(r <= n);
  801b14:	39 f0                	cmp    %esi,%eax
  801b16:	77 24                	ja     801b3c <devfile_read+0x56>
	assert(r <= PGSIZE);
  801b18:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b1d:	7f 33                	jg     801b52 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b1f:	83 ec 04             	sub    $0x4,%esp
  801b22:	50                   	push   %eax
  801b23:	68 00 80 80 00       	push   $0x808000
  801b28:	ff 75 0c             	pushl  0xc(%ebp)
  801b2b:	e8 58 f3 ff ff       	call   800e88 <memmove>
	return r;
  801b30:	83 c4 10             	add    $0x10,%esp
}
  801b33:	89 d8                	mov    %ebx,%eax
  801b35:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b38:	5b                   	pop    %ebx
  801b39:	5e                   	pop    %esi
  801b3a:	5d                   	pop    %ebp
  801b3b:	c3                   	ret    
	assert(r <= n);
  801b3c:	68 e4 33 80 00       	push   $0x8033e4
  801b41:	68 eb 33 80 00       	push   $0x8033eb
  801b46:	6a 7c                	push   $0x7c
  801b48:	68 00 34 80 00       	push   $0x803400
  801b4d:	e8 53 e9 ff ff       	call   8004a5 <_panic>
	assert(r <= PGSIZE);
  801b52:	68 0b 34 80 00       	push   $0x80340b
  801b57:	68 eb 33 80 00       	push   $0x8033eb
  801b5c:	6a 7d                	push   $0x7d
  801b5e:	68 00 34 80 00       	push   $0x803400
  801b63:	e8 3d e9 ff ff       	call   8004a5 <_panic>

00801b68 <open>:
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
  801b6b:	56                   	push   %esi
  801b6c:	53                   	push   %ebx
  801b6d:	83 ec 1c             	sub    $0x1c,%esp
  801b70:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b73:	56                   	push   %esi
  801b74:	e8 48 f1 ff ff       	call   800cc1 <strlen>
  801b79:	83 c4 10             	add    $0x10,%esp
  801b7c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b81:	7f 6c                	jg     801bef <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801b83:	83 ec 0c             	sub    $0xc,%esp
  801b86:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b89:	50                   	push   %eax
  801b8a:	e8 79 f8 ff ff       	call   801408 <fd_alloc>
  801b8f:	89 c3                	mov    %eax,%ebx
  801b91:	83 c4 10             	add    $0x10,%esp
  801b94:	85 c0                	test   %eax,%eax
  801b96:	78 3c                	js     801bd4 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801b98:	83 ec 08             	sub    $0x8,%esp
  801b9b:	56                   	push   %esi
  801b9c:	68 00 80 80 00       	push   $0x808000
  801ba1:	e8 54 f1 ff ff       	call   800cfa <strcpy>
	fsipcbuf.open.req_omode = mode;
  801ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ba9:	a3 00 84 80 00       	mov    %eax,0x808400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801bae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bb1:	b8 01 00 00 00       	mov    $0x1,%eax
  801bb6:	e8 b8 fd ff ff       	call   801973 <fsipc>
  801bbb:	89 c3                	mov    %eax,%ebx
  801bbd:	83 c4 10             	add    $0x10,%esp
  801bc0:	85 c0                	test   %eax,%eax
  801bc2:	78 19                	js     801bdd <open+0x75>
	return fd2num(fd);
  801bc4:	83 ec 0c             	sub    $0xc,%esp
  801bc7:	ff 75 f4             	pushl  -0xc(%ebp)
  801bca:	e8 12 f8 ff ff       	call   8013e1 <fd2num>
  801bcf:	89 c3                	mov    %eax,%ebx
  801bd1:	83 c4 10             	add    $0x10,%esp
}
  801bd4:	89 d8                	mov    %ebx,%eax
  801bd6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bd9:	5b                   	pop    %ebx
  801bda:	5e                   	pop    %esi
  801bdb:	5d                   	pop    %ebp
  801bdc:	c3                   	ret    
		fd_close(fd, 0);
  801bdd:	83 ec 08             	sub    $0x8,%esp
  801be0:	6a 00                	push   $0x0
  801be2:	ff 75 f4             	pushl  -0xc(%ebp)
  801be5:	e8 1b f9 ff ff       	call   801505 <fd_close>
		return r;
  801bea:	83 c4 10             	add    $0x10,%esp
  801bed:	eb e5                	jmp    801bd4 <open+0x6c>
		return -E_BAD_PATH;
  801bef:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801bf4:	eb de                	jmp    801bd4 <open+0x6c>

00801bf6 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
  801bf9:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801bfc:	ba 00 00 00 00       	mov    $0x0,%edx
  801c01:	b8 08 00 00 00       	mov    $0x8,%eax
  801c06:	e8 68 fd ff ff       	call   801973 <fsipc>
}
  801c0b:	c9                   	leave  
  801c0c:	c3                   	ret    

00801c0d <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
  801c10:	57                   	push   %edi
  801c11:	56                   	push   %esi
  801c12:	53                   	push   %ebx
  801c13:	81 ec 94 02 00 00    	sub    $0x294,%esp
	cprintf("in %s\n", __FUNCTION__);
  801c19:	68 f0 34 80 00       	push   $0x8034f0
  801c1e:	68 57 2f 80 00       	push   $0x802f57
  801c23:	e8 73 e9 ff ff       	call   80059b <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801c28:	83 c4 08             	add    $0x8,%esp
  801c2b:	6a 00                	push   $0x0
  801c2d:	ff 75 08             	pushl  0x8(%ebp)
  801c30:	e8 33 ff ff ff       	call   801b68 <open>
  801c35:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801c3b:	83 c4 10             	add    $0x10,%esp
  801c3e:	85 c0                	test   %eax,%eax
  801c40:	0f 88 0b 05 00 00    	js     802151 <spawn+0x544>
  801c46:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801c48:	83 ec 04             	sub    $0x4,%esp
  801c4b:	68 00 02 00 00       	push   $0x200
  801c50:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801c56:	50                   	push   %eax
  801c57:	51                   	push   %ecx
  801c58:	e8 f4 fa ff ff       	call   801751 <readn>
  801c5d:	83 c4 10             	add    $0x10,%esp
  801c60:	3d 00 02 00 00       	cmp    $0x200,%eax
  801c65:	75 75                	jne    801cdc <spawn+0xcf>
	    || elf->e_magic != ELF_MAGIC) {
  801c67:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801c6e:	45 4c 46 
  801c71:	75 69                	jne    801cdc <spawn+0xcf>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801c73:	b8 07 00 00 00       	mov    $0x7,%eax
  801c78:	cd 30                	int    $0x30
  801c7a:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801c80:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801c86:	85 c0                	test   %eax,%eax
  801c88:	0f 88 b7 04 00 00    	js     802145 <spawn+0x538>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801c8e:	25 ff 03 00 00       	and    $0x3ff,%eax
  801c93:	69 f0 84 00 00 00    	imul   $0x84,%eax,%esi
  801c99:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801c9f:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801ca5:	b9 11 00 00 00       	mov    $0x11,%ecx
  801caa:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801cac:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801cb2:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
	cprintf("in %s\n", __FUNCTION__);
  801cb8:	83 ec 08             	sub    $0x8,%esp
  801cbb:	68 e4 34 80 00       	push   $0x8034e4
  801cc0:	68 57 2f 80 00       	push   $0x802f57
  801cc5:	e8 d1 e8 ff ff       	call   80059b <cprintf>
  801cca:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801ccd:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801cd2:	be 00 00 00 00       	mov    $0x0,%esi
  801cd7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801cda:	eb 4b                	jmp    801d27 <spawn+0x11a>
		close(fd);
  801cdc:	83 ec 0c             	sub    $0xc,%esp
  801cdf:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801ce5:	e8 a2 f8 ff ff       	call   80158c <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801cea:	83 c4 0c             	add    $0xc,%esp
  801ced:	68 7f 45 4c 46       	push   $0x464c457f
  801cf2:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801cf8:	68 17 34 80 00       	push   $0x803417
  801cfd:	e8 99 e8 ff ff       	call   80059b <cprintf>
		return -E_NOT_EXEC;
  801d02:	83 c4 10             	add    $0x10,%esp
  801d05:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801d0c:	ff ff ff 
  801d0f:	e9 3d 04 00 00       	jmp    802151 <spawn+0x544>
		string_size += strlen(argv[argc]) + 1;
  801d14:	83 ec 0c             	sub    $0xc,%esp
  801d17:	50                   	push   %eax
  801d18:	e8 a4 ef ff ff       	call   800cc1 <strlen>
  801d1d:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801d21:	83 c3 01             	add    $0x1,%ebx
  801d24:	83 c4 10             	add    $0x10,%esp
  801d27:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801d2e:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801d31:	85 c0                	test   %eax,%eax
  801d33:	75 df                	jne    801d14 <spawn+0x107>
  801d35:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801d3b:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801d41:	bf 00 10 40 00       	mov    $0x401000,%edi
  801d46:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801d48:	89 fa                	mov    %edi,%edx
  801d4a:	83 e2 fc             	and    $0xfffffffc,%edx
  801d4d:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801d54:	29 c2                	sub    %eax,%edx
  801d56:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801d5c:	8d 42 f8             	lea    -0x8(%edx),%eax
  801d5f:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801d64:	0f 86 0a 04 00 00    	jbe    802174 <spawn+0x567>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801d6a:	83 ec 04             	sub    $0x4,%esp
  801d6d:	6a 07                	push   $0x7
  801d6f:	68 00 00 40 00       	push   $0x400000
  801d74:	6a 00                	push   $0x0
  801d76:	e8 71 f3 ff ff       	call   8010ec <sys_page_alloc>
  801d7b:	83 c4 10             	add    $0x10,%esp
  801d7e:	85 c0                	test   %eax,%eax
  801d80:	0f 88 f3 03 00 00    	js     802179 <spawn+0x56c>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801d86:	be 00 00 00 00       	mov    $0x0,%esi
  801d8b:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801d91:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801d94:	eb 30                	jmp    801dc6 <spawn+0x1b9>
		argv_store[i] = UTEMP2USTACK(string_store);
  801d96:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801d9c:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801da2:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801da5:	83 ec 08             	sub    $0x8,%esp
  801da8:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801dab:	57                   	push   %edi
  801dac:	e8 49 ef ff ff       	call   800cfa <strcpy>
		string_store += strlen(argv[i]) + 1;
  801db1:	83 c4 04             	add    $0x4,%esp
  801db4:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801db7:	e8 05 ef ff ff       	call   800cc1 <strlen>
  801dbc:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801dc0:	83 c6 01             	add    $0x1,%esi
  801dc3:	83 c4 10             	add    $0x10,%esp
  801dc6:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801dcc:	7f c8                	jg     801d96 <spawn+0x189>
	}
	argv_store[argc] = 0;
  801dce:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801dd4:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801dda:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801de1:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801de7:	0f 85 86 00 00 00    	jne    801e73 <spawn+0x266>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801ded:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  801df3:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  801df9:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  801dfc:	89 d0                	mov    %edx,%eax
  801dfe:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  801e04:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801e07:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801e0c:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801e12:	83 ec 0c             	sub    $0xc,%esp
  801e15:	6a 07                	push   $0x7
  801e17:	68 00 d0 bf ee       	push   $0xeebfd000
  801e1c:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801e22:	68 00 00 40 00       	push   $0x400000
  801e27:	6a 00                	push   $0x0
  801e29:	e8 01 f3 ff ff       	call   80112f <sys_page_map>
  801e2e:	89 c3                	mov    %eax,%ebx
  801e30:	83 c4 20             	add    $0x20,%esp
  801e33:	85 c0                	test   %eax,%eax
  801e35:	0f 88 46 03 00 00    	js     802181 <spawn+0x574>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801e3b:	83 ec 08             	sub    $0x8,%esp
  801e3e:	68 00 00 40 00       	push   $0x400000
  801e43:	6a 00                	push   $0x0
  801e45:	e8 27 f3 ff ff       	call   801171 <sys_page_unmap>
  801e4a:	89 c3                	mov    %eax,%ebx
  801e4c:	83 c4 10             	add    $0x10,%esp
  801e4f:	85 c0                	test   %eax,%eax
  801e51:	0f 88 2a 03 00 00    	js     802181 <spawn+0x574>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801e57:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801e5d:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801e64:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801e6b:	00 00 00 
  801e6e:	e9 4f 01 00 00       	jmp    801fc2 <spawn+0x3b5>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801e73:	68 a0 34 80 00       	push   $0x8034a0
  801e78:	68 eb 33 80 00       	push   $0x8033eb
  801e7d:	68 f8 00 00 00       	push   $0xf8
  801e82:	68 31 34 80 00       	push   $0x803431
  801e87:	e8 19 e6 ff ff       	call   8004a5 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801e8c:	83 ec 04             	sub    $0x4,%esp
  801e8f:	6a 07                	push   $0x7
  801e91:	68 00 00 40 00       	push   $0x400000
  801e96:	6a 00                	push   $0x0
  801e98:	e8 4f f2 ff ff       	call   8010ec <sys_page_alloc>
  801e9d:	83 c4 10             	add    $0x10,%esp
  801ea0:	85 c0                	test   %eax,%eax
  801ea2:	0f 88 b7 02 00 00    	js     80215f <spawn+0x552>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801ea8:	83 ec 08             	sub    $0x8,%esp
  801eab:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801eb1:	01 f0                	add    %esi,%eax
  801eb3:	50                   	push   %eax
  801eb4:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801eba:	e8 59 f9 ff ff       	call   801818 <seek>
  801ebf:	83 c4 10             	add    $0x10,%esp
  801ec2:	85 c0                	test   %eax,%eax
  801ec4:	0f 88 9c 02 00 00    	js     802166 <spawn+0x559>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801eca:	83 ec 04             	sub    $0x4,%esp
  801ecd:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801ed3:	29 f0                	sub    %esi,%eax
  801ed5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801eda:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801edf:	0f 47 c1             	cmova  %ecx,%eax
  801ee2:	50                   	push   %eax
  801ee3:	68 00 00 40 00       	push   $0x400000
  801ee8:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801eee:	e8 5e f8 ff ff       	call   801751 <readn>
  801ef3:	83 c4 10             	add    $0x10,%esp
  801ef6:	85 c0                	test   %eax,%eax
  801ef8:	0f 88 6f 02 00 00    	js     80216d <spawn+0x560>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801efe:	83 ec 0c             	sub    $0xc,%esp
  801f01:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801f07:	53                   	push   %ebx
  801f08:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801f0e:	68 00 00 40 00       	push   $0x400000
  801f13:	6a 00                	push   $0x0
  801f15:	e8 15 f2 ff ff       	call   80112f <sys_page_map>
  801f1a:	83 c4 20             	add    $0x20,%esp
  801f1d:	85 c0                	test   %eax,%eax
  801f1f:	78 7c                	js     801f9d <spawn+0x390>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801f21:	83 ec 08             	sub    $0x8,%esp
  801f24:	68 00 00 40 00       	push   $0x400000
  801f29:	6a 00                	push   $0x0
  801f2b:	e8 41 f2 ff ff       	call   801171 <sys_page_unmap>
  801f30:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801f33:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801f39:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801f3f:	89 fe                	mov    %edi,%esi
  801f41:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801f47:	76 69                	jbe    801fb2 <spawn+0x3a5>
		if (i >= filesz) {
  801f49:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801f4f:	0f 87 37 ff ff ff    	ja     801e8c <spawn+0x27f>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801f55:	83 ec 04             	sub    $0x4,%esp
  801f58:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801f5e:	53                   	push   %ebx
  801f5f:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801f65:	e8 82 f1 ff ff       	call   8010ec <sys_page_alloc>
  801f6a:	83 c4 10             	add    $0x10,%esp
  801f6d:	85 c0                	test   %eax,%eax
  801f6f:	79 c2                	jns    801f33 <spawn+0x326>
  801f71:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801f73:	83 ec 0c             	sub    $0xc,%esp
  801f76:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801f7c:	e8 ec f0 ff ff       	call   80106d <sys_env_destroy>
	close(fd);
  801f81:	83 c4 04             	add    $0x4,%esp
  801f84:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801f8a:	e8 fd f5 ff ff       	call   80158c <close>
	return r;
  801f8f:	83 c4 10             	add    $0x10,%esp
  801f92:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801f98:	e9 b4 01 00 00       	jmp    802151 <spawn+0x544>
				panic("spawn: sys_page_map data: %e", r);
  801f9d:	50                   	push   %eax
  801f9e:	68 3d 34 80 00       	push   $0x80343d
  801fa3:	68 2b 01 00 00       	push   $0x12b
  801fa8:	68 31 34 80 00       	push   $0x803431
  801fad:	e8 f3 e4 ff ff       	call   8004a5 <_panic>
  801fb2:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801fb8:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801fbf:	83 c6 20             	add    $0x20,%esi
  801fc2:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801fc9:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801fcf:	7e 6d                	jle    80203e <spawn+0x431>
		if (ph->p_type != ELF_PROG_LOAD)
  801fd1:	83 3e 01             	cmpl   $0x1,(%esi)
  801fd4:	75 e2                	jne    801fb8 <spawn+0x3ab>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801fd6:	8b 46 18             	mov    0x18(%esi),%eax
  801fd9:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801fdc:	83 f8 01             	cmp    $0x1,%eax
  801fdf:	19 c0                	sbb    %eax,%eax
  801fe1:	83 e0 fe             	and    $0xfffffffe,%eax
  801fe4:	83 c0 07             	add    $0x7,%eax
  801fe7:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801fed:	8b 4e 04             	mov    0x4(%esi),%ecx
  801ff0:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801ff6:	8b 56 10             	mov    0x10(%esi),%edx
  801ff9:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801fff:	8b 7e 14             	mov    0x14(%esi),%edi
  802002:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  802008:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  80200b:	89 d8                	mov    %ebx,%eax
  80200d:	25 ff 0f 00 00       	and    $0xfff,%eax
  802012:	74 1a                	je     80202e <spawn+0x421>
		va -= i;
  802014:	29 c3                	sub    %eax,%ebx
		memsz += i;
  802016:	01 c7                	add    %eax,%edi
  802018:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  80201e:	01 c2                	add    %eax,%edx
  802020:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  802026:	29 c1                	sub    %eax,%ecx
  802028:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  80202e:	bf 00 00 00 00       	mov    $0x0,%edi
  802033:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  802039:	e9 01 ff ff ff       	jmp    801f3f <spawn+0x332>
	close(fd);
  80203e:	83 ec 0c             	sub    $0xc,%esp
  802041:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802047:	e8 40 f5 ff ff       	call   80158c <close>

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	cprintf("in %s\n", __FUNCTION__);
  80204c:	83 c4 08             	add    $0x8,%esp
  80204f:	68 d0 34 80 00       	push   $0x8034d0
  802054:	68 57 2f 80 00       	push   $0x802f57
  802059:	e8 3d e5 ff ff       	call   80059b <cprintf>
  80205e:	83 c4 10             	add    $0x10,%esp
	int r;
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  802061:	bb 00 00 80 00       	mov    $0x800000,%ebx
  802066:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  80206c:	eb 0e                	jmp    80207c <spawn+0x46f>
  80206e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802074:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80207a:	74 5e                	je     8020da <spawn+0x4cd>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_SHARE)) == (PTE_P | PTE_U | PTE_SHARE)))
  80207c:	89 d8                	mov    %ebx,%eax
  80207e:	c1 e8 16             	shr    $0x16,%eax
  802081:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802088:	a8 01                	test   $0x1,%al
  80208a:	74 e2                	je     80206e <spawn+0x461>
  80208c:	89 da                	mov    %ebx,%edx
  80208e:	c1 ea 0c             	shr    $0xc,%edx
  802091:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  802098:	25 05 04 00 00       	and    $0x405,%eax
  80209d:	3d 05 04 00 00       	cmp    $0x405,%eax
  8020a2:	75 ca                	jne    80206e <spawn+0x461>
			if((r = sys_page_map((envid_t)0, (void *)i, child, (void *)i, uvpt[PGNUM(i)] & PTE_SYSCALL)) < 0)
  8020a4:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8020ab:	83 ec 0c             	sub    $0xc,%esp
  8020ae:	25 07 0e 00 00       	and    $0xe07,%eax
  8020b3:	50                   	push   %eax
  8020b4:	53                   	push   %ebx
  8020b5:	56                   	push   %esi
  8020b6:	53                   	push   %ebx
  8020b7:	6a 00                	push   $0x0
  8020b9:	e8 71 f0 ff ff       	call   80112f <sys_page_map>
  8020be:	83 c4 20             	add    $0x20,%esp
  8020c1:	85 c0                	test   %eax,%eax
  8020c3:	79 a9                	jns    80206e <spawn+0x461>
        		panic("sys_page_map: %e\n", r);
  8020c5:	50                   	push   %eax
  8020c6:	68 5a 34 80 00       	push   $0x80345a
  8020cb:	68 3b 01 00 00       	push   $0x13b
  8020d0:	68 31 34 80 00       	push   $0x803431
  8020d5:	e8 cb e3 ff ff       	call   8004a5 <_panic>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8020da:	83 ec 08             	sub    $0x8,%esp
  8020dd:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  8020e3:	50                   	push   %eax
  8020e4:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8020ea:	e8 06 f1 ff ff       	call   8011f5 <sys_env_set_trapframe>
  8020ef:	83 c4 10             	add    $0x10,%esp
  8020f2:	85 c0                	test   %eax,%eax
  8020f4:	78 25                	js     80211b <spawn+0x50e>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8020f6:	83 ec 08             	sub    $0x8,%esp
  8020f9:	6a 02                	push   $0x2
  8020fb:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802101:	e8 ad f0 ff ff       	call   8011b3 <sys_env_set_status>
  802106:	83 c4 10             	add    $0x10,%esp
  802109:	85 c0                	test   %eax,%eax
  80210b:	78 23                	js     802130 <spawn+0x523>
	return child;
  80210d:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802113:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802119:	eb 36                	jmp    802151 <spawn+0x544>
		panic("sys_env_set_trapframe: %e", r);
  80211b:	50                   	push   %eax
  80211c:	68 6c 34 80 00       	push   $0x80346c
  802121:	68 8a 00 00 00       	push   $0x8a
  802126:	68 31 34 80 00       	push   $0x803431
  80212b:	e8 75 e3 ff ff       	call   8004a5 <_panic>
		panic("sys_env_set_status: %e", r);
  802130:	50                   	push   %eax
  802131:	68 86 34 80 00       	push   $0x803486
  802136:	68 8d 00 00 00       	push   $0x8d
  80213b:	68 31 34 80 00       	push   $0x803431
  802140:	e8 60 e3 ff ff       	call   8004a5 <_panic>
		return r;
  802145:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80214b:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  802151:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802157:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80215a:	5b                   	pop    %ebx
  80215b:	5e                   	pop    %esi
  80215c:	5f                   	pop    %edi
  80215d:	5d                   	pop    %ebp
  80215e:	c3                   	ret    
  80215f:	89 c7                	mov    %eax,%edi
  802161:	e9 0d fe ff ff       	jmp    801f73 <spawn+0x366>
  802166:	89 c7                	mov    %eax,%edi
  802168:	e9 06 fe ff ff       	jmp    801f73 <spawn+0x366>
  80216d:	89 c7                	mov    %eax,%edi
  80216f:	e9 ff fd ff ff       	jmp    801f73 <spawn+0x366>
		return -E_NO_MEM;
  802174:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  802179:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  80217f:	eb d0                	jmp    802151 <spawn+0x544>
	sys_page_unmap(0, UTEMP);
  802181:	83 ec 08             	sub    $0x8,%esp
  802184:	68 00 00 40 00       	push   $0x400000
  802189:	6a 00                	push   $0x0
  80218b:	e8 e1 ef ff ff       	call   801171 <sys_page_unmap>
  802190:	83 c4 10             	add    $0x10,%esp
  802193:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  802199:	eb b6                	jmp    802151 <spawn+0x544>

0080219b <spawnl>:
{
  80219b:	55                   	push   %ebp
  80219c:	89 e5                	mov    %esp,%ebp
  80219e:	57                   	push   %edi
  80219f:	56                   	push   %esi
  8021a0:	53                   	push   %ebx
  8021a1:	83 ec 14             	sub    $0x14,%esp
	cprintf("in %s\n", __FUNCTION__);
  8021a4:	68 c8 34 80 00       	push   $0x8034c8
  8021a9:	68 57 2f 80 00       	push   $0x802f57
  8021ae:	e8 e8 e3 ff ff       	call   80059b <cprintf>
	va_start(vl, arg0);
  8021b3:	8d 55 10             	lea    0x10(%ebp),%edx
	while(va_arg(vl, void *) != NULL)
  8021b6:	83 c4 10             	add    $0x10,%esp
	int argc=0;
  8021b9:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  8021be:	8d 4a 04             	lea    0x4(%edx),%ecx
  8021c1:	83 3a 00             	cmpl   $0x0,(%edx)
  8021c4:	74 07                	je     8021cd <spawnl+0x32>
		argc++;
  8021c6:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  8021c9:	89 ca                	mov    %ecx,%edx
  8021cb:	eb f1                	jmp    8021be <spawnl+0x23>
	const char *argv[argc+2];
  8021cd:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  8021d4:	83 e2 f0             	and    $0xfffffff0,%edx
  8021d7:	29 d4                	sub    %edx,%esp
  8021d9:	8d 54 24 03          	lea    0x3(%esp),%edx
  8021dd:	c1 ea 02             	shr    $0x2,%edx
  8021e0:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  8021e7:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  8021e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021ec:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  8021f3:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  8021fa:	00 
	va_start(vl, arg0);
  8021fb:	8d 4d 10             	lea    0x10(%ebp),%ecx
  8021fe:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  802200:	b8 00 00 00 00       	mov    $0x0,%eax
  802205:	eb 0b                	jmp    802212 <spawnl+0x77>
		argv[i+1] = va_arg(vl, const char *);
  802207:	83 c0 01             	add    $0x1,%eax
  80220a:	8b 39                	mov    (%ecx),%edi
  80220c:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  80220f:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  802212:	39 d0                	cmp    %edx,%eax
  802214:	75 f1                	jne    802207 <spawnl+0x6c>
	return spawn(prog, argv);
  802216:	83 ec 08             	sub    $0x8,%esp
  802219:	56                   	push   %esi
  80221a:	ff 75 08             	pushl  0x8(%ebp)
  80221d:	e8 eb f9 ff ff       	call   801c0d <spawn>
}
  802222:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802225:	5b                   	pop    %ebx
  802226:	5e                   	pop    %esi
  802227:	5f                   	pop    %edi
  802228:	5d                   	pop    %ebp
  802229:	c3                   	ret    

0080222a <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80222a:	55                   	push   %ebp
  80222b:	89 e5                	mov    %esp,%ebp
  80222d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  802230:	68 f6 34 80 00       	push   $0x8034f6
  802235:	ff 75 0c             	pushl  0xc(%ebp)
  802238:	e8 bd ea ff ff       	call   800cfa <strcpy>
	return 0;
}
  80223d:	b8 00 00 00 00       	mov    $0x0,%eax
  802242:	c9                   	leave  
  802243:	c3                   	ret    

00802244 <devsock_close>:
{
  802244:	55                   	push   %ebp
  802245:	89 e5                	mov    %esp,%ebp
  802247:	53                   	push   %ebx
  802248:	83 ec 10             	sub    $0x10,%esp
  80224b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80224e:	53                   	push   %ebx
  80224f:	e8 dd 08 00 00       	call   802b31 <pageref>
  802254:	83 c4 10             	add    $0x10,%esp
		return 0;
  802257:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80225c:	83 f8 01             	cmp    $0x1,%eax
  80225f:	74 07                	je     802268 <devsock_close+0x24>
}
  802261:	89 d0                	mov    %edx,%eax
  802263:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802266:	c9                   	leave  
  802267:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  802268:	83 ec 0c             	sub    $0xc,%esp
  80226b:	ff 73 0c             	pushl  0xc(%ebx)
  80226e:	e8 b9 02 00 00       	call   80252c <nsipc_close>
  802273:	89 c2                	mov    %eax,%edx
  802275:	83 c4 10             	add    $0x10,%esp
  802278:	eb e7                	jmp    802261 <devsock_close+0x1d>

0080227a <devsock_write>:
{
  80227a:	55                   	push   %ebp
  80227b:	89 e5                	mov    %esp,%ebp
  80227d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802280:	6a 00                	push   $0x0
  802282:	ff 75 10             	pushl  0x10(%ebp)
  802285:	ff 75 0c             	pushl  0xc(%ebp)
  802288:	8b 45 08             	mov    0x8(%ebp),%eax
  80228b:	ff 70 0c             	pushl  0xc(%eax)
  80228e:	e8 76 03 00 00       	call   802609 <nsipc_send>
}
  802293:	c9                   	leave  
  802294:	c3                   	ret    

00802295 <devsock_read>:
{
  802295:	55                   	push   %ebp
  802296:	89 e5                	mov    %esp,%ebp
  802298:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80229b:	6a 00                	push   $0x0
  80229d:	ff 75 10             	pushl  0x10(%ebp)
  8022a0:	ff 75 0c             	pushl  0xc(%ebp)
  8022a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a6:	ff 70 0c             	pushl  0xc(%eax)
  8022a9:	e8 ef 02 00 00       	call   80259d <nsipc_recv>
}
  8022ae:	c9                   	leave  
  8022af:	c3                   	ret    

008022b0 <fd2sockid>:
{
  8022b0:	55                   	push   %ebp
  8022b1:	89 e5                	mov    %esp,%ebp
  8022b3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8022b6:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8022b9:	52                   	push   %edx
  8022ba:	50                   	push   %eax
  8022bb:	e8 9a f1 ff ff       	call   80145a <fd_lookup>
  8022c0:	83 c4 10             	add    $0x10,%esp
  8022c3:	85 c0                	test   %eax,%eax
  8022c5:	78 10                	js     8022d7 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8022c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ca:	8b 0d ac 57 80 00    	mov    0x8057ac,%ecx
  8022d0:	39 08                	cmp    %ecx,(%eax)
  8022d2:	75 05                	jne    8022d9 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8022d4:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8022d7:	c9                   	leave  
  8022d8:	c3                   	ret    
		return -E_NOT_SUPP;
  8022d9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8022de:	eb f7                	jmp    8022d7 <fd2sockid+0x27>

008022e0 <alloc_sockfd>:
{
  8022e0:	55                   	push   %ebp
  8022e1:	89 e5                	mov    %esp,%ebp
  8022e3:	56                   	push   %esi
  8022e4:	53                   	push   %ebx
  8022e5:	83 ec 1c             	sub    $0x1c,%esp
  8022e8:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8022ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022ed:	50                   	push   %eax
  8022ee:	e8 15 f1 ff ff       	call   801408 <fd_alloc>
  8022f3:	89 c3                	mov    %eax,%ebx
  8022f5:	83 c4 10             	add    $0x10,%esp
  8022f8:	85 c0                	test   %eax,%eax
  8022fa:	78 43                	js     80233f <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8022fc:	83 ec 04             	sub    $0x4,%esp
  8022ff:	68 07 04 00 00       	push   $0x407
  802304:	ff 75 f4             	pushl  -0xc(%ebp)
  802307:	6a 00                	push   $0x0
  802309:	e8 de ed ff ff       	call   8010ec <sys_page_alloc>
  80230e:	89 c3                	mov    %eax,%ebx
  802310:	83 c4 10             	add    $0x10,%esp
  802313:	85 c0                	test   %eax,%eax
  802315:	78 28                	js     80233f <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802317:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231a:	8b 15 ac 57 80 00    	mov    0x8057ac,%edx
  802320:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802322:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802325:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80232c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80232f:	83 ec 0c             	sub    $0xc,%esp
  802332:	50                   	push   %eax
  802333:	e8 a9 f0 ff ff       	call   8013e1 <fd2num>
  802338:	89 c3                	mov    %eax,%ebx
  80233a:	83 c4 10             	add    $0x10,%esp
  80233d:	eb 0c                	jmp    80234b <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80233f:	83 ec 0c             	sub    $0xc,%esp
  802342:	56                   	push   %esi
  802343:	e8 e4 01 00 00       	call   80252c <nsipc_close>
		return r;
  802348:	83 c4 10             	add    $0x10,%esp
}
  80234b:	89 d8                	mov    %ebx,%eax
  80234d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802350:	5b                   	pop    %ebx
  802351:	5e                   	pop    %esi
  802352:	5d                   	pop    %ebp
  802353:	c3                   	ret    

00802354 <accept>:
{
  802354:	55                   	push   %ebp
  802355:	89 e5                	mov    %esp,%ebp
  802357:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80235a:	8b 45 08             	mov    0x8(%ebp),%eax
  80235d:	e8 4e ff ff ff       	call   8022b0 <fd2sockid>
  802362:	85 c0                	test   %eax,%eax
  802364:	78 1b                	js     802381 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802366:	83 ec 04             	sub    $0x4,%esp
  802369:	ff 75 10             	pushl  0x10(%ebp)
  80236c:	ff 75 0c             	pushl  0xc(%ebp)
  80236f:	50                   	push   %eax
  802370:	e8 0e 01 00 00       	call   802483 <nsipc_accept>
  802375:	83 c4 10             	add    $0x10,%esp
  802378:	85 c0                	test   %eax,%eax
  80237a:	78 05                	js     802381 <accept+0x2d>
	return alloc_sockfd(r);
  80237c:	e8 5f ff ff ff       	call   8022e0 <alloc_sockfd>
}
  802381:	c9                   	leave  
  802382:	c3                   	ret    

00802383 <bind>:
{
  802383:	55                   	push   %ebp
  802384:	89 e5                	mov    %esp,%ebp
  802386:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802389:	8b 45 08             	mov    0x8(%ebp),%eax
  80238c:	e8 1f ff ff ff       	call   8022b0 <fd2sockid>
  802391:	85 c0                	test   %eax,%eax
  802393:	78 12                	js     8023a7 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802395:	83 ec 04             	sub    $0x4,%esp
  802398:	ff 75 10             	pushl  0x10(%ebp)
  80239b:	ff 75 0c             	pushl  0xc(%ebp)
  80239e:	50                   	push   %eax
  80239f:	e8 31 01 00 00       	call   8024d5 <nsipc_bind>
  8023a4:	83 c4 10             	add    $0x10,%esp
}
  8023a7:	c9                   	leave  
  8023a8:	c3                   	ret    

008023a9 <shutdown>:
{
  8023a9:	55                   	push   %ebp
  8023aa:	89 e5                	mov    %esp,%ebp
  8023ac:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8023af:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b2:	e8 f9 fe ff ff       	call   8022b0 <fd2sockid>
  8023b7:	85 c0                	test   %eax,%eax
  8023b9:	78 0f                	js     8023ca <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8023bb:	83 ec 08             	sub    $0x8,%esp
  8023be:	ff 75 0c             	pushl  0xc(%ebp)
  8023c1:	50                   	push   %eax
  8023c2:	e8 43 01 00 00       	call   80250a <nsipc_shutdown>
  8023c7:	83 c4 10             	add    $0x10,%esp
}
  8023ca:	c9                   	leave  
  8023cb:	c3                   	ret    

008023cc <connect>:
{
  8023cc:	55                   	push   %ebp
  8023cd:	89 e5                	mov    %esp,%ebp
  8023cf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8023d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d5:	e8 d6 fe ff ff       	call   8022b0 <fd2sockid>
  8023da:	85 c0                	test   %eax,%eax
  8023dc:	78 12                	js     8023f0 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8023de:	83 ec 04             	sub    $0x4,%esp
  8023e1:	ff 75 10             	pushl  0x10(%ebp)
  8023e4:	ff 75 0c             	pushl  0xc(%ebp)
  8023e7:	50                   	push   %eax
  8023e8:	e8 59 01 00 00       	call   802546 <nsipc_connect>
  8023ed:	83 c4 10             	add    $0x10,%esp
}
  8023f0:	c9                   	leave  
  8023f1:	c3                   	ret    

008023f2 <listen>:
{
  8023f2:	55                   	push   %ebp
  8023f3:	89 e5                	mov    %esp,%ebp
  8023f5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8023f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fb:	e8 b0 fe ff ff       	call   8022b0 <fd2sockid>
  802400:	85 c0                	test   %eax,%eax
  802402:	78 0f                	js     802413 <listen+0x21>
	return nsipc_listen(r, backlog);
  802404:	83 ec 08             	sub    $0x8,%esp
  802407:	ff 75 0c             	pushl  0xc(%ebp)
  80240a:	50                   	push   %eax
  80240b:	e8 6b 01 00 00       	call   80257b <nsipc_listen>
  802410:	83 c4 10             	add    $0x10,%esp
}
  802413:	c9                   	leave  
  802414:	c3                   	ret    

00802415 <socket>:

int
socket(int domain, int type, int protocol)
{
  802415:	55                   	push   %ebp
  802416:	89 e5                	mov    %esp,%ebp
  802418:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80241b:	ff 75 10             	pushl  0x10(%ebp)
  80241e:	ff 75 0c             	pushl  0xc(%ebp)
  802421:	ff 75 08             	pushl  0x8(%ebp)
  802424:	e8 3e 02 00 00       	call   802667 <nsipc_socket>
  802429:	83 c4 10             	add    $0x10,%esp
  80242c:	85 c0                	test   %eax,%eax
  80242e:	78 05                	js     802435 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802430:	e8 ab fe ff ff       	call   8022e0 <alloc_sockfd>
}
  802435:	c9                   	leave  
  802436:	c3                   	ret    

00802437 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802437:	55                   	push   %ebp
  802438:	89 e5                	mov    %esp,%ebp
  80243a:	53                   	push   %ebx
  80243b:	83 ec 04             	sub    $0x4,%esp
  80243e:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802440:	83 3d 04 60 80 00 00 	cmpl   $0x0,0x806004
  802447:	74 26                	je     80246f <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802449:	6a 07                	push   $0x7
  80244b:	68 00 90 80 00       	push   $0x809000
  802450:	53                   	push   %ebx
  802451:	ff 35 04 60 80 00    	pushl  0x806004
  802457:	e8 3e 06 00 00       	call   802a9a <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80245c:	83 c4 0c             	add    $0xc,%esp
  80245f:	6a 00                	push   $0x0
  802461:	6a 00                	push   $0x0
  802463:	6a 00                	push   $0x0
  802465:	e8 c7 05 00 00       	call   802a31 <ipc_recv>
}
  80246a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80246d:	c9                   	leave  
  80246e:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80246f:	83 ec 0c             	sub    $0xc,%esp
  802472:	6a 02                	push   $0x2
  802474:	e8 79 06 00 00       	call   802af2 <ipc_find_env>
  802479:	a3 04 60 80 00       	mov    %eax,0x806004
  80247e:	83 c4 10             	add    $0x10,%esp
  802481:	eb c6                	jmp    802449 <nsipc+0x12>

00802483 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802483:	55                   	push   %ebp
  802484:	89 e5                	mov    %esp,%ebp
  802486:	56                   	push   %esi
  802487:	53                   	push   %ebx
  802488:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80248b:	8b 45 08             	mov    0x8(%ebp),%eax
  80248e:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802493:	8b 06                	mov    (%esi),%eax
  802495:	a3 04 90 80 00       	mov    %eax,0x809004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80249a:	b8 01 00 00 00       	mov    $0x1,%eax
  80249f:	e8 93 ff ff ff       	call   802437 <nsipc>
  8024a4:	89 c3                	mov    %eax,%ebx
  8024a6:	85 c0                	test   %eax,%eax
  8024a8:	79 09                	jns    8024b3 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8024aa:	89 d8                	mov    %ebx,%eax
  8024ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024af:	5b                   	pop    %ebx
  8024b0:	5e                   	pop    %esi
  8024b1:	5d                   	pop    %ebp
  8024b2:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8024b3:	83 ec 04             	sub    $0x4,%esp
  8024b6:	ff 35 10 90 80 00    	pushl  0x809010
  8024bc:	68 00 90 80 00       	push   $0x809000
  8024c1:	ff 75 0c             	pushl  0xc(%ebp)
  8024c4:	e8 bf e9 ff ff       	call   800e88 <memmove>
		*addrlen = ret->ret_addrlen;
  8024c9:	a1 10 90 80 00       	mov    0x809010,%eax
  8024ce:	89 06                	mov    %eax,(%esi)
  8024d0:	83 c4 10             	add    $0x10,%esp
	return r;
  8024d3:	eb d5                	jmp    8024aa <nsipc_accept+0x27>

008024d5 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8024d5:	55                   	push   %ebp
  8024d6:	89 e5                	mov    %esp,%ebp
  8024d8:	53                   	push   %ebx
  8024d9:	83 ec 08             	sub    $0x8,%esp
  8024dc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8024df:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e2:	a3 00 90 80 00       	mov    %eax,0x809000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8024e7:	53                   	push   %ebx
  8024e8:	ff 75 0c             	pushl  0xc(%ebp)
  8024eb:	68 04 90 80 00       	push   $0x809004
  8024f0:	e8 93 e9 ff ff       	call   800e88 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8024f5:	89 1d 14 90 80 00    	mov    %ebx,0x809014
	return nsipc(NSREQ_BIND);
  8024fb:	b8 02 00 00 00       	mov    $0x2,%eax
  802500:	e8 32 ff ff ff       	call   802437 <nsipc>
}
  802505:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802508:	c9                   	leave  
  802509:	c3                   	ret    

0080250a <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80250a:	55                   	push   %ebp
  80250b:	89 e5                	mov    %esp,%ebp
  80250d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802510:	8b 45 08             	mov    0x8(%ebp),%eax
  802513:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.shutdown.req_how = how;
  802518:	8b 45 0c             	mov    0xc(%ebp),%eax
  80251b:	a3 04 90 80 00       	mov    %eax,0x809004
	return nsipc(NSREQ_SHUTDOWN);
  802520:	b8 03 00 00 00       	mov    $0x3,%eax
  802525:	e8 0d ff ff ff       	call   802437 <nsipc>
}
  80252a:	c9                   	leave  
  80252b:	c3                   	ret    

0080252c <nsipc_close>:

int
nsipc_close(int s)
{
  80252c:	55                   	push   %ebp
  80252d:	89 e5                	mov    %esp,%ebp
  80252f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802532:	8b 45 08             	mov    0x8(%ebp),%eax
  802535:	a3 00 90 80 00       	mov    %eax,0x809000
	return nsipc(NSREQ_CLOSE);
  80253a:	b8 04 00 00 00       	mov    $0x4,%eax
  80253f:	e8 f3 fe ff ff       	call   802437 <nsipc>
}
  802544:	c9                   	leave  
  802545:	c3                   	ret    

00802546 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802546:	55                   	push   %ebp
  802547:	89 e5                	mov    %esp,%ebp
  802549:	53                   	push   %ebx
  80254a:	83 ec 08             	sub    $0x8,%esp
  80254d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802550:	8b 45 08             	mov    0x8(%ebp),%eax
  802553:	a3 00 90 80 00       	mov    %eax,0x809000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802558:	53                   	push   %ebx
  802559:	ff 75 0c             	pushl  0xc(%ebp)
  80255c:	68 04 90 80 00       	push   $0x809004
  802561:	e8 22 e9 ff ff       	call   800e88 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802566:	89 1d 14 90 80 00    	mov    %ebx,0x809014
	return nsipc(NSREQ_CONNECT);
  80256c:	b8 05 00 00 00       	mov    $0x5,%eax
  802571:	e8 c1 fe ff ff       	call   802437 <nsipc>
}
  802576:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802579:	c9                   	leave  
  80257a:	c3                   	ret    

0080257b <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80257b:	55                   	push   %ebp
  80257c:	89 e5                	mov    %esp,%ebp
  80257e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802581:	8b 45 08             	mov    0x8(%ebp),%eax
  802584:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.listen.req_backlog = backlog;
  802589:	8b 45 0c             	mov    0xc(%ebp),%eax
  80258c:	a3 04 90 80 00       	mov    %eax,0x809004
	return nsipc(NSREQ_LISTEN);
  802591:	b8 06 00 00 00       	mov    $0x6,%eax
  802596:	e8 9c fe ff ff       	call   802437 <nsipc>
}
  80259b:	c9                   	leave  
  80259c:	c3                   	ret    

0080259d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80259d:	55                   	push   %ebp
  80259e:	89 e5                	mov    %esp,%ebp
  8025a0:	56                   	push   %esi
  8025a1:	53                   	push   %ebx
  8025a2:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8025a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a8:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.recv.req_len = len;
  8025ad:	89 35 04 90 80 00    	mov    %esi,0x809004
	nsipcbuf.recv.req_flags = flags;
  8025b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8025b6:	a3 08 90 80 00       	mov    %eax,0x809008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8025bb:	b8 07 00 00 00       	mov    $0x7,%eax
  8025c0:	e8 72 fe ff ff       	call   802437 <nsipc>
  8025c5:	89 c3                	mov    %eax,%ebx
  8025c7:	85 c0                	test   %eax,%eax
  8025c9:	78 1f                	js     8025ea <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8025cb:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8025d0:	7f 21                	jg     8025f3 <nsipc_recv+0x56>
  8025d2:	39 c6                	cmp    %eax,%esi
  8025d4:	7c 1d                	jl     8025f3 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8025d6:	83 ec 04             	sub    $0x4,%esp
  8025d9:	50                   	push   %eax
  8025da:	68 00 90 80 00       	push   $0x809000
  8025df:	ff 75 0c             	pushl  0xc(%ebp)
  8025e2:	e8 a1 e8 ff ff       	call   800e88 <memmove>
  8025e7:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8025ea:	89 d8                	mov    %ebx,%eax
  8025ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025ef:	5b                   	pop    %ebx
  8025f0:	5e                   	pop    %esi
  8025f1:	5d                   	pop    %ebp
  8025f2:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8025f3:	68 02 35 80 00       	push   $0x803502
  8025f8:	68 eb 33 80 00       	push   $0x8033eb
  8025fd:	6a 62                	push   $0x62
  8025ff:	68 17 35 80 00       	push   $0x803517
  802604:	e8 9c de ff ff       	call   8004a5 <_panic>

00802609 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802609:	55                   	push   %ebp
  80260a:	89 e5                	mov    %esp,%ebp
  80260c:	53                   	push   %ebx
  80260d:	83 ec 04             	sub    $0x4,%esp
  802610:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802613:	8b 45 08             	mov    0x8(%ebp),%eax
  802616:	a3 00 90 80 00       	mov    %eax,0x809000
	assert(size < 1600);
  80261b:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802621:	7f 2e                	jg     802651 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802623:	83 ec 04             	sub    $0x4,%esp
  802626:	53                   	push   %ebx
  802627:	ff 75 0c             	pushl  0xc(%ebp)
  80262a:	68 0c 90 80 00       	push   $0x80900c
  80262f:	e8 54 e8 ff ff       	call   800e88 <memmove>
	nsipcbuf.send.req_size = size;
  802634:	89 1d 04 90 80 00    	mov    %ebx,0x809004
	nsipcbuf.send.req_flags = flags;
  80263a:	8b 45 14             	mov    0x14(%ebp),%eax
  80263d:	a3 08 90 80 00       	mov    %eax,0x809008
	return nsipc(NSREQ_SEND);
  802642:	b8 08 00 00 00       	mov    $0x8,%eax
  802647:	e8 eb fd ff ff       	call   802437 <nsipc>
}
  80264c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80264f:	c9                   	leave  
  802650:	c3                   	ret    
	assert(size < 1600);
  802651:	68 23 35 80 00       	push   $0x803523
  802656:	68 eb 33 80 00       	push   $0x8033eb
  80265b:	6a 6d                	push   $0x6d
  80265d:	68 17 35 80 00       	push   $0x803517
  802662:	e8 3e de ff ff       	call   8004a5 <_panic>

00802667 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802667:	55                   	push   %ebp
  802668:	89 e5                	mov    %esp,%ebp
  80266a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80266d:	8b 45 08             	mov    0x8(%ebp),%eax
  802670:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.socket.req_type = type;
  802675:	8b 45 0c             	mov    0xc(%ebp),%eax
  802678:	a3 04 90 80 00       	mov    %eax,0x809004
	nsipcbuf.socket.req_protocol = protocol;
  80267d:	8b 45 10             	mov    0x10(%ebp),%eax
  802680:	a3 08 90 80 00       	mov    %eax,0x809008
	return nsipc(NSREQ_SOCKET);
  802685:	b8 09 00 00 00       	mov    $0x9,%eax
  80268a:	e8 a8 fd ff ff       	call   802437 <nsipc>
}
  80268f:	c9                   	leave  
  802690:	c3                   	ret    

00802691 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802691:	55                   	push   %ebp
  802692:	89 e5                	mov    %esp,%ebp
  802694:	56                   	push   %esi
  802695:	53                   	push   %ebx
  802696:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802699:	83 ec 0c             	sub    $0xc,%esp
  80269c:	ff 75 08             	pushl  0x8(%ebp)
  80269f:	e8 4d ed ff ff       	call   8013f1 <fd2data>
  8026a4:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8026a6:	83 c4 08             	add    $0x8,%esp
  8026a9:	68 2f 35 80 00       	push   $0x80352f
  8026ae:	53                   	push   %ebx
  8026af:	e8 46 e6 ff ff       	call   800cfa <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8026b4:	8b 46 04             	mov    0x4(%esi),%eax
  8026b7:	2b 06                	sub    (%esi),%eax
  8026b9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8026bf:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8026c6:	00 00 00 
	stat->st_dev = &devpipe;
  8026c9:	c7 83 88 00 00 00 c8 	movl   $0x8057c8,0x88(%ebx)
  8026d0:	57 80 00 
	return 0;
}
  8026d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026db:	5b                   	pop    %ebx
  8026dc:	5e                   	pop    %esi
  8026dd:	5d                   	pop    %ebp
  8026de:	c3                   	ret    

008026df <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8026df:	55                   	push   %ebp
  8026e0:	89 e5                	mov    %esp,%ebp
  8026e2:	53                   	push   %ebx
  8026e3:	83 ec 0c             	sub    $0xc,%esp
  8026e6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8026e9:	53                   	push   %ebx
  8026ea:	6a 00                	push   $0x0
  8026ec:	e8 80 ea ff ff       	call   801171 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8026f1:	89 1c 24             	mov    %ebx,(%esp)
  8026f4:	e8 f8 ec ff ff       	call   8013f1 <fd2data>
  8026f9:	83 c4 08             	add    $0x8,%esp
  8026fc:	50                   	push   %eax
  8026fd:	6a 00                	push   $0x0
  8026ff:	e8 6d ea ff ff       	call   801171 <sys_page_unmap>
}
  802704:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802707:	c9                   	leave  
  802708:	c3                   	ret    

00802709 <_pipeisclosed>:
{
  802709:	55                   	push   %ebp
  80270a:	89 e5                	mov    %esp,%ebp
  80270c:	57                   	push   %edi
  80270d:	56                   	push   %esi
  80270e:	53                   	push   %ebx
  80270f:	83 ec 1c             	sub    $0x1c,%esp
  802712:	89 c7                	mov    %eax,%edi
  802714:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802716:	a1 90 77 80 00       	mov    0x807790,%eax
  80271b:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80271e:	83 ec 0c             	sub    $0xc,%esp
  802721:	57                   	push   %edi
  802722:	e8 0a 04 00 00       	call   802b31 <pageref>
  802727:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80272a:	89 34 24             	mov    %esi,(%esp)
  80272d:	e8 ff 03 00 00       	call   802b31 <pageref>
		nn = thisenv->env_runs;
  802732:	8b 15 90 77 80 00    	mov    0x807790,%edx
  802738:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80273b:	83 c4 10             	add    $0x10,%esp
  80273e:	39 cb                	cmp    %ecx,%ebx
  802740:	74 1b                	je     80275d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802742:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802745:	75 cf                	jne    802716 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802747:	8b 42 58             	mov    0x58(%edx),%eax
  80274a:	6a 01                	push   $0x1
  80274c:	50                   	push   %eax
  80274d:	53                   	push   %ebx
  80274e:	68 36 35 80 00       	push   $0x803536
  802753:	e8 43 de ff ff       	call   80059b <cprintf>
  802758:	83 c4 10             	add    $0x10,%esp
  80275b:	eb b9                	jmp    802716 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80275d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802760:	0f 94 c0             	sete   %al
  802763:	0f b6 c0             	movzbl %al,%eax
}
  802766:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802769:	5b                   	pop    %ebx
  80276a:	5e                   	pop    %esi
  80276b:	5f                   	pop    %edi
  80276c:	5d                   	pop    %ebp
  80276d:	c3                   	ret    

0080276e <devpipe_write>:
{
  80276e:	55                   	push   %ebp
  80276f:	89 e5                	mov    %esp,%ebp
  802771:	57                   	push   %edi
  802772:	56                   	push   %esi
  802773:	53                   	push   %ebx
  802774:	83 ec 28             	sub    $0x28,%esp
  802777:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80277a:	56                   	push   %esi
  80277b:	e8 71 ec ff ff       	call   8013f1 <fd2data>
  802780:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802782:	83 c4 10             	add    $0x10,%esp
  802785:	bf 00 00 00 00       	mov    $0x0,%edi
  80278a:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80278d:	74 4f                	je     8027de <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80278f:	8b 43 04             	mov    0x4(%ebx),%eax
  802792:	8b 0b                	mov    (%ebx),%ecx
  802794:	8d 51 20             	lea    0x20(%ecx),%edx
  802797:	39 d0                	cmp    %edx,%eax
  802799:	72 14                	jb     8027af <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80279b:	89 da                	mov    %ebx,%edx
  80279d:	89 f0                	mov    %esi,%eax
  80279f:	e8 65 ff ff ff       	call   802709 <_pipeisclosed>
  8027a4:	85 c0                	test   %eax,%eax
  8027a6:	75 3b                	jne    8027e3 <devpipe_write+0x75>
			sys_yield();
  8027a8:	e8 20 e9 ff ff       	call   8010cd <sys_yield>
  8027ad:	eb e0                	jmp    80278f <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8027af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027b2:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8027b6:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8027b9:	89 c2                	mov    %eax,%edx
  8027bb:	c1 fa 1f             	sar    $0x1f,%edx
  8027be:	89 d1                	mov    %edx,%ecx
  8027c0:	c1 e9 1b             	shr    $0x1b,%ecx
  8027c3:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8027c6:	83 e2 1f             	and    $0x1f,%edx
  8027c9:	29 ca                	sub    %ecx,%edx
  8027cb:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8027cf:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8027d3:	83 c0 01             	add    $0x1,%eax
  8027d6:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8027d9:	83 c7 01             	add    $0x1,%edi
  8027dc:	eb ac                	jmp    80278a <devpipe_write+0x1c>
	return i;
  8027de:	8b 45 10             	mov    0x10(%ebp),%eax
  8027e1:	eb 05                	jmp    8027e8 <devpipe_write+0x7a>
				return 0;
  8027e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027eb:	5b                   	pop    %ebx
  8027ec:	5e                   	pop    %esi
  8027ed:	5f                   	pop    %edi
  8027ee:	5d                   	pop    %ebp
  8027ef:	c3                   	ret    

008027f0 <devpipe_read>:
{
  8027f0:	55                   	push   %ebp
  8027f1:	89 e5                	mov    %esp,%ebp
  8027f3:	57                   	push   %edi
  8027f4:	56                   	push   %esi
  8027f5:	53                   	push   %ebx
  8027f6:	83 ec 18             	sub    $0x18,%esp
  8027f9:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8027fc:	57                   	push   %edi
  8027fd:	e8 ef eb ff ff       	call   8013f1 <fd2data>
  802802:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802804:	83 c4 10             	add    $0x10,%esp
  802807:	be 00 00 00 00       	mov    $0x0,%esi
  80280c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80280f:	75 14                	jne    802825 <devpipe_read+0x35>
	return i;
  802811:	8b 45 10             	mov    0x10(%ebp),%eax
  802814:	eb 02                	jmp    802818 <devpipe_read+0x28>
				return i;
  802816:	89 f0                	mov    %esi,%eax
}
  802818:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80281b:	5b                   	pop    %ebx
  80281c:	5e                   	pop    %esi
  80281d:	5f                   	pop    %edi
  80281e:	5d                   	pop    %ebp
  80281f:	c3                   	ret    
			sys_yield();
  802820:	e8 a8 e8 ff ff       	call   8010cd <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802825:	8b 03                	mov    (%ebx),%eax
  802827:	3b 43 04             	cmp    0x4(%ebx),%eax
  80282a:	75 18                	jne    802844 <devpipe_read+0x54>
			if (i > 0)
  80282c:	85 f6                	test   %esi,%esi
  80282e:	75 e6                	jne    802816 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802830:	89 da                	mov    %ebx,%edx
  802832:	89 f8                	mov    %edi,%eax
  802834:	e8 d0 fe ff ff       	call   802709 <_pipeisclosed>
  802839:	85 c0                	test   %eax,%eax
  80283b:	74 e3                	je     802820 <devpipe_read+0x30>
				return 0;
  80283d:	b8 00 00 00 00       	mov    $0x0,%eax
  802842:	eb d4                	jmp    802818 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802844:	99                   	cltd   
  802845:	c1 ea 1b             	shr    $0x1b,%edx
  802848:	01 d0                	add    %edx,%eax
  80284a:	83 e0 1f             	and    $0x1f,%eax
  80284d:	29 d0                	sub    %edx,%eax
  80284f:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802854:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802857:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80285a:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80285d:	83 c6 01             	add    $0x1,%esi
  802860:	eb aa                	jmp    80280c <devpipe_read+0x1c>

00802862 <pipe>:
{
  802862:	55                   	push   %ebp
  802863:	89 e5                	mov    %esp,%ebp
  802865:	56                   	push   %esi
  802866:	53                   	push   %ebx
  802867:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80286a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80286d:	50                   	push   %eax
  80286e:	e8 95 eb ff ff       	call   801408 <fd_alloc>
  802873:	89 c3                	mov    %eax,%ebx
  802875:	83 c4 10             	add    $0x10,%esp
  802878:	85 c0                	test   %eax,%eax
  80287a:	0f 88 23 01 00 00    	js     8029a3 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802880:	83 ec 04             	sub    $0x4,%esp
  802883:	68 07 04 00 00       	push   $0x407
  802888:	ff 75 f4             	pushl  -0xc(%ebp)
  80288b:	6a 00                	push   $0x0
  80288d:	e8 5a e8 ff ff       	call   8010ec <sys_page_alloc>
  802892:	89 c3                	mov    %eax,%ebx
  802894:	83 c4 10             	add    $0x10,%esp
  802897:	85 c0                	test   %eax,%eax
  802899:	0f 88 04 01 00 00    	js     8029a3 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80289f:	83 ec 0c             	sub    $0xc,%esp
  8028a2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8028a5:	50                   	push   %eax
  8028a6:	e8 5d eb ff ff       	call   801408 <fd_alloc>
  8028ab:	89 c3                	mov    %eax,%ebx
  8028ad:	83 c4 10             	add    $0x10,%esp
  8028b0:	85 c0                	test   %eax,%eax
  8028b2:	0f 88 db 00 00 00    	js     802993 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028b8:	83 ec 04             	sub    $0x4,%esp
  8028bb:	68 07 04 00 00       	push   $0x407
  8028c0:	ff 75 f0             	pushl  -0x10(%ebp)
  8028c3:	6a 00                	push   $0x0
  8028c5:	e8 22 e8 ff ff       	call   8010ec <sys_page_alloc>
  8028ca:	89 c3                	mov    %eax,%ebx
  8028cc:	83 c4 10             	add    $0x10,%esp
  8028cf:	85 c0                	test   %eax,%eax
  8028d1:	0f 88 bc 00 00 00    	js     802993 <pipe+0x131>
	va = fd2data(fd0);
  8028d7:	83 ec 0c             	sub    $0xc,%esp
  8028da:	ff 75 f4             	pushl  -0xc(%ebp)
  8028dd:	e8 0f eb ff ff       	call   8013f1 <fd2data>
  8028e2:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028e4:	83 c4 0c             	add    $0xc,%esp
  8028e7:	68 07 04 00 00       	push   $0x407
  8028ec:	50                   	push   %eax
  8028ed:	6a 00                	push   $0x0
  8028ef:	e8 f8 e7 ff ff       	call   8010ec <sys_page_alloc>
  8028f4:	89 c3                	mov    %eax,%ebx
  8028f6:	83 c4 10             	add    $0x10,%esp
  8028f9:	85 c0                	test   %eax,%eax
  8028fb:	0f 88 82 00 00 00    	js     802983 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802901:	83 ec 0c             	sub    $0xc,%esp
  802904:	ff 75 f0             	pushl  -0x10(%ebp)
  802907:	e8 e5 ea ff ff       	call   8013f1 <fd2data>
  80290c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802913:	50                   	push   %eax
  802914:	6a 00                	push   $0x0
  802916:	56                   	push   %esi
  802917:	6a 00                	push   $0x0
  802919:	e8 11 e8 ff ff       	call   80112f <sys_page_map>
  80291e:	89 c3                	mov    %eax,%ebx
  802920:	83 c4 20             	add    $0x20,%esp
  802923:	85 c0                	test   %eax,%eax
  802925:	78 4e                	js     802975 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802927:	a1 c8 57 80 00       	mov    0x8057c8,%eax
  80292c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80292f:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802931:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802934:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80293b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80293e:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802940:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802943:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80294a:	83 ec 0c             	sub    $0xc,%esp
  80294d:	ff 75 f4             	pushl  -0xc(%ebp)
  802950:	e8 8c ea ff ff       	call   8013e1 <fd2num>
  802955:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802958:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80295a:	83 c4 04             	add    $0x4,%esp
  80295d:	ff 75 f0             	pushl  -0x10(%ebp)
  802960:	e8 7c ea ff ff       	call   8013e1 <fd2num>
  802965:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802968:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80296b:	83 c4 10             	add    $0x10,%esp
  80296e:	bb 00 00 00 00       	mov    $0x0,%ebx
  802973:	eb 2e                	jmp    8029a3 <pipe+0x141>
	sys_page_unmap(0, va);
  802975:	83 ec 08             	sub    $0x8,%esp
  802978:	56                   	push   %esi
  802979:	6a 00                	push   $0x0
  80297b:	e8 f1 e7 ff ff       	call   801171 <sys_page_unmap>
  802980:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802983:	83 ec 08             	sub    $0x8,%esp
  802986:	ff 75 f0             	pushl  -0x10(%ebp)
  802989:	6a 00                	push   $0x0
  80298b:	e8 e1 e7 ff ff       	call   801171 <sys_page_unmap>
  802990:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802993:	83 ec 08             	sub    $0x8,%esp
  802996:	ff 75 f4             	pushl  -0xc(%ebp)
  802999:	6a 00                	push   $0x0
  80299b:	e8 d1 e7 ff ff       	call   801171 <sys_page_unmap>
  8029a0:	83 c4 10             	add    $0x10,%esp
}
  8029a3:	89 d8                	mov    %ebx,%eax
  8029a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8029a8:	5b                   	pop    %ebx
  8029a9:	5e                   	pop    %esi
  8029aa:	5d                   	pop    %ebp
  8029ab:	c3                   	ret    

008029ac <pipeisclosed>:
{
  8029ac:	55                   	push   %ebp
  8029ad:	89 e5                	mov    %esp,%ebp
  8029af:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8029b5:	50                   	push   %eax
  8029b6:	ff 75 08             	pushl  0x8(%ebp)
  8029b9:	e8 9c ea ff ff       	call   80145a <fd_lookup>
  8029be:	83 c4 10             	add    $0x10,%esp
  8029c1:	85 c0                	test   %eax,%eax
  8029c3:	78 18                	js     8029dd <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8029c5:	83 ec 0c             	sub    $0xc,%esp
  8029c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8029cb:	e8 21 ea ff ff       	call   8013f1 <fd2data>
	return _pipeisclosed(fd, p);
  8029d0:	89 c2                	mov    %eax,%edx
  8029d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d5:	e8 2f fd ff ff       	call   802709 <_pipeisclosed>
  8029da:	83 c4 10             	add    $0x10,%esp
}
  8029dd:	c9                   	leave  
  8029de:	c3                   	ret    

008029df <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8029df:	55                   	push   %ebp
  8029e0:	89 e5                	mov    %esp,%ebp
  8029e2:	56                   	push   %esi
  8029e3:	53                   	push   %ebx
  8029e4:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  8029e7:	85 f6                	test   %esi,%esi
  8029e9:	74 16                	je     802a01 <wait+0x22>
	e = &envs[ENVX(envid)];
  8029eb:	89 f3                	mov    %esi,%ebx
  8029ed:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8029f3:	69 db 84 00 00 00    	imul   $0x84,%ebx,%ebx
  8029f9:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8029ff:	eb 1b                	jmp    802a1c <wait+0x3d>
	assert(envid != 0);
  802a01:	68 4e 35 80 00       	push   $0x80354e
  802a06:	68 eb 33 80 00       	push   $0x8033eb
  802a0b:	6a 09                	push   $0x9
  802a0d:	68 59 35 80 00       	push   $0x803559
  802a12:	e8 8e da ff ff       	call   8004a5 <_panic>
		sys_yield();
  802a17:	e8 b1 e6 ff ff       	call   8010cd <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802a1c:	8b 43 48             	mov    0x48(%ebx),%eax
  802a1f:	39 f0                	cmp    %esi,%eax
  802a21:	75 07                	jne    802a2a <wait+0x4b>
  802a23:	8b 43 54             	mov    0x54(%ebx),%eax
  802a26:	85 c0                	test   %eax,%eax
  802a28:	75 ed                	jne    802a17 <wait+0x38>
}
  802a2a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a2d:	5b                   	pop    %ebx
  802a2e:	5e                   	pop    %esi
  802a2f:	5d                   	pop    %ebp
  802a30:	c3                   	ret    

00802a31 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802a31:	55                   	push   %ebp
  802a32:	89 e5                	mov    %esp,%ebp
  802a34:	56                   	push   %esi
  802a35:	53                   	push   %ebx
  802a36:	8b 75 08             	mov    0x8(%ebp),%esi
  802a39:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a3c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802a3f:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802a41:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802a46:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802a49:	83 ec 0c             	sub    $0xc,%esp
  802a4c:	50                   	push   %eax
  802a4d:	e8 4a e8 ff ff       	call   80129c <sys_ipc_recv>
	if(ret < 0){
  802a52:	83 c4 10             	add    $0x10,%esp
  802a55:	85 c0                	test   %eax,%eax
  802a57:	78 2b                	js     802a84 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802a59:	85 f6                	test   %esi,%esi
  802a5b:	74 0a                	je     802a67 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802a5d:	a1 90 77 80 00       	mov    0x807790,%eax
  802a62:	8b 40 78             	mov    0x78(%eax),%eax
  802a65:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802a67:	85 db                	test   %ebx,%ebx
  802a69:	74 0a                	je     802a75 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802a6b:	a1 90 77 80 00       	mov    0x807790,%eax
  802a70:	8b 40 7c             	mov    0x7c(%eax),%eax
  802a73:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802a75:	a1 90 77 80 00       	mov    0x807790,%eax
  802a7a:	8b 40 74             	mov    0x74(%eax),%eax
}
  802a7d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a80:	5b                   	pop    %ebx
  802a81:	5e                   	pop    %esi
  802a82:	5d                   	pop    %ebp
  802a83:	c3                   	ret    
		if(from_env_store)
  802a84:	85 f6                	test   %esi,%esi
  802a86:	74 06                	je     802a8e <ipc_recv+0x5d>
			*from_env_store = 0;
  802a88:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802a8e:	85 db                	test   %ebx,%ebx
  802a90:	74 eb                	je     802a7d <ipc_recv+0x4c>
			*perm_store = 0;
  802a92:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802a98:	eb e3                	jmp    802a7d <ipc_recv+0x4c>

00802a9a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802a9a:	55                   	push   %ebp
  802a9b:	89 e5                	mov    %esp,%ebp
  802a9d:	57                   	push   %edi
  802a9e:	56                   	push   %esi
  802a9f:	53                   	push   %ebx
  802aa0:	83 ec 0c             	sub    $0xc,%esp
  802aa3:	8b 7d 08             	mov    0x8(%ebp),%edi
  802aa6:	8b 75 0c             	mov    0xc(%ebp),%esi
  802aa9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802aac:	85 db                	test   %ebx,%ebx
  802aae:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802ab3:	0f 44 d8             	cmove  %eax,%ebx
  802ab6:	eb 05                	jmp    802abd <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802ab8:	e8 10 e6 ff ff       	call   8010cd <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802abd:	ff 75 14             	pushl  0x14(%ebp)
  802ac0:	53                   	push   %ebx
  802ac1:	56                   	push   %esi
  802ac2:	57                   	push   %edi
  802ac3:	e8 b1 e7 ff ff       	call   801279 <sys_ipc_try_send>
  802ac8:	83 c4 10             	add    $0x10,%esp
  802acb:	85 c0                	test   %eax,%eax
  802acd:	74 1b                	je     802aea <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802acf:	79 e7                	jns    802ab8 <ipc_send+0x1e>
  802ad1:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802ad4:	74 e2                	je     802ab8 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802ad6:	83 ec 04             	sub    $0x4,%esp
  802ad9:	68 64 35 80 00       	push   $0x803564
  802ade:	6a 46                	push   $0x46
  802ae0:	68 79 35 80 00       	push   $0x803579
  802ae5:	e8 bb d9 ff ff       	call   8004a5 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802aea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802aed:	5b                   	pop    %ebx
  802aee:	5e                   	pop    %esi
  802aef:	5f                   	pop    %edi
  802af0:	5d                   	pop    %ebp
  802af1:	c3                   	ret    

00802af2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802af2:	55                   	push   %ebp
  802af3:	89 e5                	mov    %esp,%ebp
  802af5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802af8:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802afd:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802b03:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802b09:	8b 52 50             	mov    0x50(%edx),%edx
  802b0c:	39 ca                	cmp    %ecx,%edx
  802b0e:	74 11                	je     802b21 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802b10:	83 c0 01             	add    $0x1,%eax
  802b13:	3d 00 04 00 00       	cmp    $0x400,%eax
  802b18:	75 e3                	jne    802afd <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802b1a:	b8 00 00 00 00       	mov    $0x0,%eax
  802b1f:	eb 0e                	jmp    802b2f <ipc_find_env+0x3d>
			return envs[i].env_id;
  802b21:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  802b27:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802b2c:	8b 40 48             	mov    0x48(%eax),%eax
}
  802b2f:	5d                   	pop    %ebp
  802b30:	c3                   	ret    

00802b31 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802b31:	55                   	push   %ebp
  802b32:	89 e5                	mov    %esp,%ebp
  802b34:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b37:	89 d0                	mov    %edx,%eax
  802b39:	c1 e8 16             	shr    $0x16,%eax
  802b3c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802b43:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802b48:	f6 c1 01             	test   $0x1,%cl
  802b4b:	74 1d                	je     802b6a <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802b4d:	c1 ea 0c             	shr    $0xc,%edx
  802b50:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802b57:	f6 c2 01             	test   $0x1,%dl
  802b5a:	74 0e                	je     802b6a <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802b5c:	c1 ea 0c             	shr    $0xc,%edx
  802b5f:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802b66:	ef 
  802b67:	0f b7 c0             	movzwl %ax,%eax
}
  802b6a:	5d                   	pop    %ebp
  802b6b:	c3                   	ret    
  802b6c:	66 90                	xchg   %ax,%ax
  802b6e:	66 90                	xchg   %ax,%ax

00802b70 <__udivdi3>:
  802b70:	55                   	push   %ebp
  802b71:	57                   	push   %edi
  802b72:	56                   	push   %esi
  802b73:	53                   	push   %ebx
  802b74:	83 ec 1c             	sub    $0x1c,%esp
  802b77:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802b7b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802b7f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802b83:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802b87:	85 d2                	test   %edx,%edx
  802b89:	75 4d                	jne    802bd8 <__udivdi3+0x68>
  802b8b:	39 f3                	cmp    %esi,%ebx
  802b8d:	76 19                	jbe    802ba8 <__udivdi3+0x38>
  802b8f:	31 ff                	xor    %edi,%edi
  802b91:	89 e8                	mov    %ebp,%eax
  802b93:	89 f2                	mov    %esi,%edx
  802b95:	f7 f3                	div    %ebx
  802b97:	89 fa                	mov    %edi,%edx
  802b99:	83 c4 1c             	add    $0x1c,%esp
  802b9c:	5b                   	pop    %ebx
  802b9d:	5e                   	pop    %esi
  802b9e:	5f                   	pop    %edi
  802b9f:	5d                   	pop    %ebp
  802ba0:	c3                   	ret    
  802ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ba8:	89 d9                	mov    %ebx,%ecx
  802baa:	85 db                	test   %ebx,%ebx
  802bac:	75 0b                	jne    802bb9 <__udivdi3+0x49>
  802bae:	b8 01 00 00 00       	mov    $0x1,%eax
  802bb3:	31 d2                	xor    %edx,%edx
  802bb5:	f7 f3                	div    %ebx
  802bb7:	89 c1                	mov    %eax,%ecx
  802bb9:	31 d2                	xor    %edx,%edx
  802bbb:	89 f0                	mov    %esi,%eax
  802bbd:	f7 f1                	div    %ecx
  802bbf:	89 c6                	mov    %eax,%esi
  802bc1:	89 e8                	mov    %ebp,%eax
  802bc3:	89 f7                	mov    %esi,%edi
  802bc5:	f7 f1                	div    %ecx
  802bc7:	89 fa                	mov    %edi,%edx
  802bc9:	83 c4 1c             	add    $0x1c,%esp
  802bcc:	5b                   	pop    %ebx
  802bcd:	5e                   	pop    %esi
  802bce:	5f                   	pop    %edi
  802bcf:	5d                   	pop    %ebp
  802bd0:	c3                   	ret    
  802bd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bd8:	39 f2                	cmp    %esi,%edx
  802bda:	77 1c                	ja     802bf8 <__udivdi3+0x88>
  802bdc:	0f bd fa             	bsr    %edx,%edi
  802bdf:	83 f7 1f             	xor    $0x1f,%edi
  802be2:	75 2c                	jne    802c10 <__udivdi3+0xa0>
  802be4:	39 f2                	cmp    %esi,%edx
  802be6:	72 06                	jb     802bee <__udivdi3+0x7e>
  802be8:	31 c0                	xor    %eax,%eax
  802bea:	39 eb                	cmp    %ebp,%ebx
  802bec:	77 a9                	ja     802b97 <__udivdi3+0x27>
  802bee:	b8 01 00 00 00       	mov    $0x1,%eax
  802bf3:	eb a2                	jmp    802b97 <__udivdi3+0x27>
  802bf5:	8d 76 00             	lea    0x0(%esi),%esi
  802bf8:	31 ff                	xor    %edi,%edi
  802bfa:	31 c0                	xor    %eax,%eax
  802bfc:	89 fa                	mov    %edi,%edx
  802bfe:	83 c4 1c             	add    $0x1c,%esp
  802c01:	5b                   	pop    %ebx
  802c02:	5e                   	pop    %esi
  802c03:	5f                   	pop    %edi
  802c04:	5d                   	pop    %ebp
  802c05:	c3                   	ret    
  802c06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c0d:	8d 76 00             	lea    0x0(%esi),%esi
  802c10:	89 f9                	mov    %edi,%ecx
  802c12:	b8 20 00 00 00       	mov    $0x20,%eax
  802c17:	29 f8                	sub    %edi,%eax
  802c19:	d3 e2                	shl    %cl,%edx
  802c1b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802c1f:	89 c1                	mov    %eax,%ecx
  802c21:	89 da                	mov    %ebx,%edx
  802c23:	d3 ea                	shr    %cl,%edx
  802c25:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802c29:	09 d1                	or     %edx,%ecx
  802c2b:	89 f2                	mov    %esi,%edx
  802c2d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c31:	89 f9                	mov    %edi,%ecx
  802c33:	d3 e3                	shl    %cl,%ebx
  802c35:	89 c1                	mov    %eax,%ecx
  802c37:	d3 ea                	shr    %cl,%edx
  802c39:	89 f9                	mov    %edi,%ecx
  802c3b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802c3f:	89 eb                	mov    %ebp,%ebx
  802c41:	d3 e6                	shl    %cl,%esi
  802c43:	89 c1                	mov    %eax,%ecx
  802c45:	d3 eb                	shr    %cl,%ebx
  802c47:	09 de                	or     %ebx,%esi
  802c49:	89 f0                	mov    %esi,%eax
  802c4b:	f7 74 24 08          	divl   0x8(%esp)
  802c4f:	89 d6                	mov    %edx,%esi
  802c51:	89 c3                	mov    %eax,%ebx
  802c53:	f7 64 24 0c          	mull   0xc(%esp)
  802c57:	39 d6                	cmp    %edx,%esi
  802c59:	72 15                	jb     802c70 <__udivdi3+0x100>
  802c5b:	89 f9                	mov    %edi,%ecx
  802c5d:	d3 e5                	shl    %cl,%ebp
  802c5f:	39 c5                	cmp    %eax,%ebp
  802c61:	73 04                	jae    802c67 <__udivdi3+0xf7>
  802c63:	39 d6                	cmp    %edx,%esi
  802c65:	74 09                	je     802c70 <__udivdi3+0x100>
  802c67:	89 d8                	mov    %ebx,%eax
  802c69:	31 ff                	xor    %edi,%edi
  802c6b:	e9 27 ff ff ff       	jmp    802b97 <__udivdi3+0x27>
  802c70:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802c73:	31 ff                	xor    %edi,%edi
  802c75:	e9 1d ff ff ff       	jmp    802b97 <__udivdi3+0x27>
  802c7a:	66 90                	xchg   %ax,%ax
  802c7c:	66 90                	xchg   %ax,%ax
  802c7e:	66 90                	xchg   %ax,%ax

00802c80 <__umoddi3>:
  802c80:	55                   	push   %ebp
  802c81:	57                   	push   %edi
  802c82:	56                   	push   %esi
  802c83:	53                   	push   %ebx
  802c84:	83 ec 1c             	sub    $0x1c,%esp
  802c87:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802c8b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802c8f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802c93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802c97:	89 da                	mov    %ebx,%edx
  802c99:	85 c0                	test   %eax,%eax
  802c9b:	75 43                	jne    802ce0 <__umoddi3+0x60>
  802c9d:	39 df                	cmp    %ebx,%edi
  802c9f:	76 17                	jbe    802cb8 <__umoddi3+0x38>
  802ca1:	89 f0                	mov    %esi,%eax
  802ca3:	f7 f7                	div    %edi
  802ca5:	89 d0                	mov    %edx,%eax
  802ca7:	31 d2                	xor    %edx,%edx
  802ca9:	83 c4 1c             	add    $0x1c,%esp
  802cac:	5b                   	pop    %ebx
  802cad:	5e                   	pop    %esi
  802cae:	5f                   	pop    %edi
  802caf:	5d                   	pop    %ebp
  802cb0:	c3                   	ret    
  802cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802cb8:	89 fd                	mov    %edi,%ebp
  802cba:	85 ff                	test   %edi,%edi
  802cbc:	75 0b                	jne    802cc9 <__umoddi3+0x49>
  802cbe:	b8 01 00 00 00       	mov    $0x1,%eax
  802cc3:	31 d2                	xor    %edx,%edx
  802cc5:	f7 f7                	div    %edi
  802cc7:	89 c5                	mov    %eax,%ebp
  802cc9:	89 d8                	mov    %ebx,%eax
  802ccb:	31 d2                	xor    %edx,%edx
  802ccd:	f7 f5                	div    %ebp
  802ccf:	89 f0                	mov    %esi,%eax
  802cd1:	f7 f5                	div    %ebp
  802cd3:	89 d0                	mov    %edx,%eax
  802cd5:	eb d0                	jmp    802ca7 <__umoddi3+0x27>
  802cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802cde:	66 90                	xchg   %ax,%ax
  802ce0:	89 f1                	mov    %esi,%ecx
  802ce2:	39 d8                	cmp    %ebx,%eax
  802ce4:	76 0a                	jbe    802cf0 <__umoddi3+0x70>
  802ce6:	89 f0                	mov    %esi,%eax
  802ce8:	83 c4 1c             	add    $0x1c,%esp
  802ceb:	5b                   	pop    %ebx
  802cec:	5e                   	pop    %esi
  802ced:	5f                   	pop    %edi
  802cee:	5d                   	pop    %ebp
  802cef:	c3                   	ret    
  802cf0:	0f bd e8             	bsr    %eax,%ebp
  802cf3:	83 f5 1f             	xor    $0x1f,%ebp
  802cf6:	75 20                	jne    802d18 <__umoddi3+0x98>
  802cf8:	39 d8                	cmp    %ebx,%eax
  802cfa:	0f 82 b0 00 00 00    	jb     802db0 <__umoddi3+0x130>
  802d00:	39 f7                	cmp    %esi,%edi
  802d02:	0f 86 a8 00 00 00    	jbe    802db0 <__umoddi3+0x130>
  802d08:	89 c8                	mov    %ecx,%eax
  802d0a:	83 c4 1c             	add    $0x1c,%esp
  802d0d:	5b                   	pop    %ebx
  802d0e:	5e                   	pop    %esi
  802d0f:	5f                   	pop    %edi
  802d10:	5d                   	pop    %ebp
  802d11:	c3                   	ret    
  802d12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802d18:	89 e9                	mov    %ebp,%ecx
  802d1a:	ba 20 00 00 00       	mov    $0x20,%edx
  802d1f:	29 ea                	sub    %ebp,%edx
  802d21:	d3 e0                	shl    %cl,%eax
  802d23:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d27:	89 d1                	mov    %edx,%ecx
  802d29:	89 f8                	mov    %edi,%eax
  802d2b:	d3 e8                	shr    %cl,%eax
  802d2d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802d31:	89 54 24 04          	mov    %edx,0x4(%esp)
  802d35:	8b 54 24 04          	mov    0x4(%esp),%edx
  802d39:	09 c1                	or     %eax,%ecx
  802d3b:	89 d8                	mov    %ebx,%eax
  802d3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802d41:	89 e9                	mov    %ebp,%ecx
  802d43:	d3 e7                	shl    %cl,%edi
  802d45:	89 d1                	mov    %edx,%ecx
  802d47:	d3 e8                	shr    %cl,%eax
  802d49:	89 e9                	mov    %ebp,%ecx
  802d4b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d4f:	d3 e3                	shl    %cl,%ebx
  802d51:	89 c7                	mov    %eax,%edi
  802d53:	89 d1                	mov    %edx,%ecx
  802d55:	89 f0                	mov    %esi,%eax
  802d57:	d3 e8                	shr    %cl,%eax
  802d59:	89 e9                	mov    %ebp,%ecx
  802d5b:	89 fa                	mov    %edi,%edx
  802d5d:	d3 e6                	shl    %cl,%esi
  802d5f:	09 d8                	or     %ebx,%eax
  802d61:	f7 74 24 08          	divl   0x8(%esp)
  802d65:	89 d1                	mov    %edx,%ecx
  802d67:	89 f3                	mov    %esi,%ebx
  802d69:	f7 64 24 0c          	mull   0xc(%esp)
  802d6d:	89 c6                	mov    %eax,%esi
  802d6f:	89 d7                	mov    %edx,%edi
  802d71:	39 d1                	cmp    %edx,%ecx
  802d73:	72 06                	jb     802d7b <__umoddi3+0xfb>
  802d75:	75 10                	jne    802d87 <__umoddi3+0x107>
  802d77:	39 c3                	cmp    %eax,%ebx
  802d79:	73 0c                	jae    802d87 <__umoddi3+0x107>
  802d7b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802d7f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802d83:	89 d7                	mov    %edx,%edi
  802d85:	89 c6                	mov    %eax,%esi
  802d87:	89 ca                	mov    %ecx,%edx
  802d89:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802d8e:	29 f3                	sub    %esi,%ebx
  802d90:	19 fa                	sbb    %edi,%edx
  802d92:	89 d0                	mov    %edx,%eax
  802d94:	d3 e0                	shl    %cl,%eax
  802d96:	89 e9                	mov    %ebp,%ecx
  802d98:	d3 eb                	shr    %cl,%ebx
  802d9a:	d3 ea                	shr    %cl,%edx
  802d9c:	09 d8                	or     %ebx,%eax
  802d9e:	83 c4 1c             	add    $0x1c,%esp
  802da1:	5b                   	pop    %ebx
  802da2:	5e                   	pop    %esi
  802da3:	5f                   	pop    %edi
  802da4:	5d                   	pop    %ebp
  802da5:	c3                   	ret    
  802da6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802dad:	8d 76 00             	lea    0x0(%esi),%esi
  802db0:	89 da                	mov    %ebx,%edx
  802db2:	29 fe                	sub    %edi,%esi
  802db4:	19 c2                	sbb    %eax,%edx
  802db6:	89 f1                	mov    %esi,%ecx
  802db8:	89 c8                	mov    %ecx,%eax
  802dba:	e9 4b ff ff ff       	jmp    802d0a <__umoddi3+0x8a>
