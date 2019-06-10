
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
  8000a0:	68 84 2e 80 00       	push   $0x802e84
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
  8000ca:	68 c0 2e 80 00       	push   $0x802ec0
  8000cf:	e8 c5 04 00 00       	call   800599 <cprintf>
  8000d4:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  8000d7:	83 ec 08             	sub    $0x8,%esp
  8000da:	68 fc 2d 80 00       	push   $0x802dfc
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
  800100:	68 08 2e 80 00       	push   $0x802e08
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
  80011d:	68 09 2e 80 00       	push   $0x802e09
  800122:	56                   	push   %esi
  800123:	e8 f0 0b 00 00       	call   800d18 <strcat>
	for (i = 0; i < argc; i++) {
  800128:	83 c3 01             	add    $0x1,%ebx
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	eb c9                	jmp    8000f9 <umain+0x9b>
		cprintf("init: data seems okay\n");
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	68 cf 2d 80 00       	push   $0x802dcf
  800138:	e8 5c 04 00 00       	call   800599 <cprintf>
  80013d:	83 c4 10             	add    $0x10,%esp
  800140:	e9 68 ff ff ff       	jmp    8000ad <umain+0x4f>
		cprintf("init: bss seems okay\n");
  800145:	83 ec 0c             	sub    $0xc,%esp
  800148:	68 e6 2d 80 00       	push   $0x802de6
  80014d:	e8 47 04 00 00       	call   800599 <cprintf>
  800152:	83 c4 10             	add    $0x10,%esp
  800155:	eb 80                	jmp    8000d7 <umain+0x79>
	}
	cprintf("%s\n", args);
  800157:	83 ec 08             	sub    $0x8,%esp
  80015a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800160:	50                   	push   %eax
  800161:	68 5a 2f 80 00       	push   $0x802f5a
  800166:	e8 2e 04 00 00       	call   800599 <cprintf>

	cprintf("init: running sh\n");
  80016b:	c7 04 24 0b 2e 80 00 	movl   $0x802e0b,(%esp)
  800172:	e8 22 04 00 00       	call   800599 <cprintf>

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  800177:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80017e:	e8 07 14 00 00       	call   80158a <close>
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
  80019e:	e8 00 03 00 00       	call   8004a3 <_panic>
		panic("opencons: %e", r);
  8001a3:	50                   	push   %eax
  8001a4:	68 1d 2e 80 00       	push   $0x802e1d
  8001a9:	6a 37                	push   $0x37
  8001ab:	68 2a 2e 80 00       	push   $0x802e2a
  8001b0:	e8 ee 02 00 00       	call   8004a3 <_panic>
	if ((r = dup(0, 1)) < 0)
  8001b5:	83 ec 08             	sub    $0x8,%esp
  8001b8:	6a 01                	push   $0x1
  8001ba:	6a 00                	push   $0x0
  8001bc:	e8 1b 14 00 00       	call   8015dc <dup>
  8001c1:	83 c4 10             	add    $0x10,%esp
  8001c4:	85 c0                	test   %eax,%eax
  8001c6:	79 23                	jns    8001eb <umain+0x18d>
		panic("dup: %e", r);
  8001c8:	50                   	push   %eax
  8001c9:	68 50 2e 80 00       	push   $0x802e50
  8001ce:	6a 3b                	push   $0x3b
  8001d0:	68 2a 2e 80 00       	push   $0x802e2a
  8001d5:	e8 c9 02 00 00       	call   8004a3 <_panic>
	while (1) {
		cprintf("init: starting sh\n");
		r = spawnl("/sh", "sh", (char*)0);
		if (r < 0) {
			cprintf("init: spawn sh: %e\n", r);
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	50                   	push   %eax
  8001de:	68 6f 2e 80 00       	push   $0x802e6f
  8001e3:	e8 b1 03 00 00       	call   800599 <cprintf>
			continue;
  8001e8:	83 c4 10             	add    $0x10,%esp
		cprintf("init: starting sh\n");
  8001eb:	83 ec 0c             	sub    $0xc,%esp
  8001ee:	68 58 2e 80 00       	push   $0x802e58
  8001f3:	e8 a1 03 00 00       	call   800599 <cprintf>
		r = spawnl("/sh", "sh", (char*)0);
  8001f8:	83 c4 0c             	add    $0xc,%esp
  8001fb:	6a 00                	push   $0x0
  8001fd:	68 6c 2e 80 00       	push   $0x802e6c
  800202:	68 6b 2e 80 00       	push   $0x802e6b
  800207:	e8 8c 1f 00 00       	call   802198 <spawnl>
		if (r < 0) {
  80020c:	83 c4 10             	add    $0x10,%esp
  80020f:	85 c0                	test   %eax,%eax
  800211:	78 c7                	js     8001da <umain+0x17c>
		}
		wait(r);
  800213:	83 ec 0c             	sub    $0xc,%esp
  800216:	50                   	push   %eax
  800217:	e8 c0 27 00 00       	call   8029dc <wait>
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
  8002fd:	e8 c6 13 00 00       	call   8016c8 <read>
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
  800325:	e8 2e 11 00 00       	call   801458 <fd_lookup>
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
  80034e:	e8 b3 10 00 00       	call   801406 <fd_alloc>
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
  80038c:	e8 4e 10 00 00       	call   8013df <fd2num>
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
  800419:	68 fb 2e 80 00       	push   $0x802efb
  80041e:	e8 76 01 00 00       	call   800599 <cprintf>
	cprintf("before umain\n");
  800423:	c7 04 24 19 2f 80 00 	movl   $0x802f19,(%esp)
  80042a:	e8 6a 01 00 00       	call   800599 <cprintf>
	// call user main routine
	umain(argc, argv);
  80042f:	83 c4 08             	add    $0x8,%esp
  800432:	ff 75 0c             	pushl  0xc(%ebp)
  800435:	ff 75 08             	pushl  0x8(%ebp)
  800438:	e8 21 fc ff ff       	call   80005e <umain>
	cprintf("after umain\n");
  80043d:	c7 04 24 27 2f 80 00 	movl   $0x802f27,(%esp)
  800444:	e8 50 01 00 00       	call   800599 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800449:	a1 90 77 80 00       	mov    0x807790,%eax
  80044e:	8b 40 48             	mov    0x48(%eax),%eax
  800451:	83 c4 08             	add    $0x8,%esp
  800454:	50                   	push   %eax
  800455:	68 34 2f 80 00       	push   $0x802f34
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
  80047d:	68 60 2f 80 00       	push   $0x802f60
  800482:	50                   	push   %eax
  800483:	68 53 2f 80 00       	push   $0x802f53
  800488:	e8 0c 01 00 00       	call   800599 <cprintf>
	close_all();
  80048d:	e8 25 11 00 00       	call   8015b7 <close_all>
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
  8004b3:	68 8c 2f 80 00       	push   $0x802f8c
  8004b8:	50                   	push   %eax
  8004b9:	68 53 2f 80 00       	push   $0x802f53
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
  8004dc:	68 68 2f 80 00       	push   $0x802f68
  8004e1:	e8 b3 00 00 00       	call   800599 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004e6:	83 c4 18             	add    $0x18,%esp
  8004e9:	53                   	push   %ebx
  8004ea:	ff 75 10             	pushl  0x10(%ebp)
  8004ed:	e8 56 00 00 00       	call   800548 <vcprintf>
	cprintf("\n");
  8004f2:	c7 04 24 17 2f 80 00 	movl   $0x802f17,(%esp)
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
  800646:	e8 25 25 00 00       	call   802b70 <__udivdi3>
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
  80066f:	e8 0c 26 00 00       	call   802c80 <__umoddi3>
  800674:	83 c4 14             	add    $0x14,%esp
  800677:	0f be 80 93 2f 80 00 	movsbl 0x802f93(%eax),%eax
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
  800720:	ff 24 85 80 31 80 00 	jmp    *0x803180(,%eax,4)
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
  8007eb:	8b 14 85 e0 32 80 00 	mov    0x8032e0(,%eax,4),%edx
  8007f2:	85 d2                	test   %edx,%edx
  8007f4:	74 18                	je     80080e <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8007f6:	52                   	push   %edx
  8007f7:	68 fd 33 80 00       	push   $0x8033fd
  8007fc:	53                   	push   %ebx
  8007fd:	56                   	push   %esi
  8007fe:	e8 a6 fe ff ff       	call   8006a9 <printfmt>
  800803:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800806:	89 7d 14             	mov    %edi,0x14(%ebp)
  800809:	e9 fe 02 00 00       	jmp    800b0c <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80080e:	50                   	push   %eax
  80080f:	68 ab 2f 80 00       	push   $0x802fab
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
  800836:	b8 a4 2f 80 00       	mov    $0x802fa4,%eax
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
  800bce:	bf c9 30 80 00       	mov    $0x8030c9,%edi
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
  800bfa:	bf 01 31 80 00       	mov    $0x803101,%edi
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
  80109b:	68 28 33 80 00       	push   $0x803328
  8010a0:	6a 43                	push   $0x43
  8010a2:	68 45 33 80 00       	push   $0x803345
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
  80111c:	68 28 33 80 00       	push   $0x803328
  801121:	6a 43                	push   $0x43
  801123:	68 45 33 80 00       	push   $0x803345
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
  80115e:	68 28 33 80 00       	push   $0x803328
  801163:	6a 43                	push   $0x43
  801165:	68 45 33 80 00       	push   $0x803345
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
  8011a0:	68 28 33 80 00       	push   $0x803328
  8011a5:	6a 43                	push   $0x43
  8011a7:	68 45 33 80 00       	push   $0x803345
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
  8011e2:	68 28 33 80 00       	push   $0x803328
  8011e7:	6a 43                	push   $0x43
  8011e9:	68 45 33 80 00       	push   $0x803345
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
  801224:	68 28 33 80 00       	push   $0x803328
  801229:	6a 43                	push   $0x43
  80122b:	68 45 33 80 00       	push   $0x803345
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
  801266:	68 28 33 80 00       	push   $0x803328
  80126b:	6a 43                	push   $0x43
  80126d:	68 45 33 80 00       	push   $0x803345
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
  8012ca:	68 28 33 80 00       	push   $0x803328
  8012cf:	6a 43                	push   $0x43
  8012d1:	68 45 33 80 00       	push   $0x803345
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
  8013ae:	68 28 33 80 00       	push   $0x803328
  8013b3:	6a 43                	push   $0x43
  8013b5:	68 45 33 80 00       	push   $0x803345
  8013ba:	e8 e4 f0 ff ff       	call   8004a3 <_panic>

008013bf <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8013bf:	55                   	push   %ebp
  8013c0:	89 e5                	mov    %esp,%ebp
  8013c2:	57                   	push   %edi
  8013c3:	56                   	push   %esi
  8013c4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013c5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8013ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8013cd:	b8 14 00 00 00       	mov    $0x14,%eax
  8013d2:	89 cb                	mov    %ecx,%ebx
  8013d4:	89 cf                	mov    %ecx,%edi
  8013d6:	89 ce                	mov    %ecx,%esi
  8013d8:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  8013da:	5b                   	pop    %ebx
  8013db:	5e                   	pop    %esi
  8013dc:	5f                   	pop    %edi
  8013dd:	5d                   	pop    %ebp
  8013de:	c3                   	ret    

008013df <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8013df:	55                   	push   %ebp
  8013e0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e5:	05 00 00 00 30       	add    $0x30000000,%eax
  8013ea:	c1 e8 0c             	shr    $0xc,%eax
}
  8013ed:	5d                   	pop    %ebp
  8013ee:	c3                   	ret    

008013ef <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f5:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8013fa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013ff:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801404:	5d                   	pop    %ebp
  801405:	c3                   	ret    

00801406 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801406:	55                   	push   %ebp
  801407:	89 e5                	mov    %esp,%ebp
  801409:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80140e:	89 c2                	mov    %eax,%edx
  801410:	c1 ea 16             	shr    $0x16,%edx
  801413:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80141a:	f6 c2 01             	test   $0x1,%dl
  80141d:	74 2d                	je     80144c <fd_alloc+0x46>
  80141f:	89 c2                	mov    %eax,%edx
  801421:	c1 ea 0c             	shr    $0xc,%edx
  801424:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80142b:	f6 c2 01             	test   $0x1,%dl
  80142e:	74 1c                	je     80144c <fd_alloc+0x46>
  801430:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801435:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80143a:	75 d2                	jne    80140e <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80143c:	8b 45 08             	mov    0x8(%ebp),%eax
  80143f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801445:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80144a:	eb 0a                	jmp    801456 <fd_alloc+0x50>
			*fd_store = fd;
  80144c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80144f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801451:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801456:	5d                   	pop    %ebp
  801457:	c3                   	ret    

00801458 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801458:	55                   	push   %ebp
  801459:	89 e5                	mov    %esp,%ebp
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80145e:	83 f8 1f             	cmp    $0x1f,%eax
  801461:	77 30                	ja     801493 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801463:	c1 e0 0c             	shl    $0xc,%eax
  801466:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80146b:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801471:	f6 c2 01             	test   $0x1,%dl
  801474:	74 24                	je     80149a <fd_lookup+0x42>
  801476:	89 c2                	mov    %eax,%edx
  801478:	c1 ea 0c             	shr    $0xc,%edx
  80147b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801482:	f6 c2 01             	test   $0x1,%dl
  801485:	74 1a                	je     8014a1 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801487:	8b 55 0c             	mov    0xc(%ebp),%edx
  80148a:	89 02                	mov    %eax,(%edx)
	return 0;
  80148c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801491:	5d                   	pop    %ebp
  801492:	c3                   	ret    
		return -E_INVAL;
  801493:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801498:	eb f7                	jmp    801491 <fd_lookup+0x39>
		return -E_INVAL;
  80149a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80149f:	eb f0                	jmp    801491 <fd_lookup+0x39>
  8014a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014a6:	eb e9                	jmp    801491 <fd_lookup+0x39>

008014a8 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8014a8:	55                   	push   %ebp
  8014a9:	89 e5                	mov    %esp,%ebp
  8014ab:	83 ec 08             	sub    $0x8,%esp
  8014ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8014b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b6:	b8 90 57 80 00       	mov    $0x805790,%eax
		if (devtab[i]->dev_id == dev_id) {
  8014bb:	39 08                	cmp    %ecx,(%eax)
  8014bd:	74 38                	je     8014f7 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8014bf:	83 c2 01             	add    $0x1,%edx
  8014c2:	8b 04 95 d0 33 80 00 	mov    0x8033d0(,%edx,4),%eax
  8014c9:	85 c0                	test   %eax,%eax
  8014cb:	75 ee                	jne    8014bb <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8014cd:	a1 90 77 80 00       	mov    0x807790,%eax
  8014d2:	8b 40 48             	mov    0x48(%eax),%eax
  8014d5:	83 ec 04             	sub    $0x4,%esp
  8014d8:	51                   	push   %ecx
  8014d9:	50                   	push   %eax
  8014da:	68 54 33 80 00       	push   $0x803354
  8014df:	e8 b5 f0 ff ff       	call   800599 <cprintf>
	*dev = 0;
  8014e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8014ed:	83 c4 10             	add    $0x10,%esp
  8014f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014f5:	c9                   	leave  
  8014f6:	c3                   	ret    
			*dev = devtab[i];
  8014f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014fa:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801501:	eb f2                	jmp    8014f5 <dev_lookup+0x4d>

00801503 <fd_close>:
{
  801503:	55                   	push   %ebp
  801504:	89 e5                	mov    %esp,%ebp
  801506:	57                   	push   %edi
  801507:	56                   	push   %esi
  801508:	53                   	push   %ebx
  801509:	83 ec 24             	sub    $0x24,%esp
  80150c:	8b 75 08             	mov    0x8(%ebp),%esi
  80150f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801512:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801515:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801516:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80151c:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80151f:	50                   	push   %eax
  801520:	e8 33 ff ff ff       	call   801458 <fd_lookup>
  801525:	89 c3                	mov    %eax,%ebx
  801527:	83 c4 10             	add    $0x10,%esp
  80152a:	85 c0                	test   %eax,%eax
  80152c:	78 05                	js     801533 <fd_close+0x30>
	    || fd != fd2)
  80152e:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801531:	74 16                	je     801549 <fd_close+0x46>
		return (must_exist ? r : 0);
  801533:	89 f8                	mov    %edi,%eax
  801535:	84 c0                	test   %al,%al
  801537:	b8 00 00 00 00       	mov    $0x0,%eax
  80153c:	0f 44 d8             	cmove  %eax,%ebx
}
  80153f:	89 d8                	mov    %ebx,%eax
  801541:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801544:	5b                   	pop    %ebx
  801545:	5e                   	pop    %esi
  801546:	5f                   	pop    %edi
  801547:	5d                   	pop    %ebp
  801548:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801549:	83 ec 08             	sub    $0x8,%esp
  80154c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80154f:	50                   	push   %eax
  801550:	ff 36                	pushl  (%esi)
  801552:	e8 51 ff ff ff       	call   8014a8 <dev_lookup>
  801557:	89 c3                	mov    %eax,%ebx
  801559:	83 c4 10             	add    $0x10,%esp
  80155c:	85 c0                	test   %eax,%eax
  80155e:	78 1a                	js     80157a <fd_close+0x77>
		if (dev->dev_close)
  801560:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801563:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801566:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80156b:	85 c0                	test   %eax,%eax
  80156d:	74 0b                	je     80157a <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80156f:	83 ec 0c             	sub    $0xc,%esp
  801572:	56                   	push   %esi
  801573:	ff d0                	call   *%eax
  801575:	89 c3                	mov    %eax,%ebx
  801577:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80157a:	83 ec 08             	sub    $0x8,%esp
  80157d:	56                   	push   %esi
  80157e:	6a 00                	push   $0x0
  801580:	e8 ea fb ff ff       	call   80116f <sys_page_unmap>
	return r;
  801585:	83 c4 10             	add    $0x10,%esp
  801588:	eb b5                	jmp    80153f <fd_close+0x3c>

0080158a <close>:

int
close(int fdnum)
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
  80158d:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801590:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801593:	50                   	push   %eax
  801594:	ff 75 08             	pushl  0x8(%ebp)
  801597:	e8 bc fe ff ff       	call   801458 <fd_lookup>
  80159c:	83 c4 10             	add    $0x10,%esp
  80159f:	85 c0                	test   %eax,%eax
  8015a1:	79 02                	jns    8015a5 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8015a3:	c9                   	leave  
  8015a4:	c3                   	ret    
		return fd_close(fd, 1);
  8015a5:	83 ec 08             	sub    $0x8,%esp
  8015a8:	6a 01                	push   $0x1
  8015aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8015ad:	e8 51 ff ff ff       	call   801503 <fd_close>
  8015b2:	83 c4 10             	add    $0x10,%esp
  8015b5:	eb ec                	jmp    8015a3 <close+0x19>

008015b7 <close_all>:

void
close_all(void)
{
  8015b7:	55                   	push   %ebp
  8015b8:	89 e5                	mov    %esp,%ebp
  8015ba:	53                   	push   %ebx
  8015bb:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8015be:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8015c3:	83 ec 0c             	sub    $0xc,%esp
  8015c6:	53                   	push   %ebx
  8015c7:	e8 be ff ff ff       	call   80158a <close>
	for (i = 0; i < MAXFD; i++)
  8015cc:	83 c3 01             	add    $0x1,%ebx
  8015cf:	83 c4 10             	add    $0x10,%esp
  8015d2:	83 fb 20             	cmp    $0x20,%ebx
  8015d5:	75 ec                	jne    8015c3 <close_all+0xc>
}
  8015d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015da:	c9                   	leave  
  8015db:	c3                   	ret    

008015dc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
  8015df:	57                   	push   %edi
  8015e0:	56                   	push   %esi
  8015e1:	53                   	push   %ebx
  8015e2:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015e5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015e8:	50                   	push   %eax
  8015e9:	ff 75 08             	pushl  0x8(%ebp)
  8015ec:	e8 67 fe ff ff       	call   801458 <fd_lookup>
  8015f1:	89 c3                	mov    %eax,%ebx
  8015f3:	83 c4 10             	add    $0x10,%esp
  8015f6:	85 c0                	test   %eax,%eax
  8015f8:	0f 88 81 00 00 00    	js     80167f <dup+0xa3>
		return r;
	close(newfdnum);
  8015fe:	83 ec 0c             	sub    $0xc,%esp
  801601:	ff 75 0c             	pushl  0xc(%ebp)
  801604:	e8 81 ff ff ff       	call   80158a <close>

	newfd = INDEX2FD(newfdnum);
  801609:	8b 75 0c             	mov    0xc(%ebp),%esi
  80160c:	c1 e6 0c             	shl    $0xc,%esi
  80160f:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801615:	83 c4 04             	add    $0x4,%esp
  801618:	ff 75 e4             	pushl  -0x1c(%ebp)
  80161b:	e8 cf fd ff ff       	call   8013ef <fd2data>
  801620:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801622:	89 34 24             	mov    %esi,(%esp)
  801625:	e8 c5 fd ff ff       	call   8013ef <fd2data>
  80162a:	83 c4 10             	add    $0x10,%esp
  80162d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80162f:	89 d8                	mov    %ebx,%eax
  801631:	c1 e8 16             	shr    $0x16,%eax
  801634:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80163b:	a8 01                	test   $0x1,%al
  80163d:	74 11                	je     801650 <dup+0x74>
  80163f:	89 d8                	mov    %ebx,%eax
  801641:	c1 e8 0c             	shr    $0xc,%eax
  801644:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80164b:	f6 c2 01             	test   $0x1,%dl
  80164e:	75 39                	jne    801689 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801650:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801653:	89 d0                	mov    %edx,%eax
  801655:	c1 e8 0c             	shr    $0xc,%eax
  801658:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80165f:	83 ec 0c             	sub    $0xc,%esp
  801662:	25 07 0e 00 00       	and    $0xe07,%eax
  801667:	50                   	push   %eax
  801668:	56                   	push   %esi
  801669:	6a 00                	push   $0x0
  80166b:	52                   	push   %edx
  80166c:	6a 00                	push   $0x0
  80166e:	e8 ba fa ff ff       	call   80112d <sys_page_map>
  801673:	89 c3                	mov    %eax,%ebx
  801675:	83 c4 20             	add    $0x20,%esp
  801678:	85 c0                	test   %eax,%eax
  80167a:	78 31                	js     8016ad <dup+0xd1>
		goto err;

	return newfdnum;
  80167c:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80167f:	89 d8                	mov    %ebx,%eax
  801681:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801684:	5b                   	pop    %ebx
  801685:	5e                   	pop    %esi
  801686:	5f                   	pop    %edi
  801687:	5d                   	pop    %ebp
  801688:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801689:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801690:	83 ec 0c             	sub    $0xc,%esp
  801693:	25 07 0e 00 00       	and    $0xe07,%eax
  801698:	50                   	push   %eax
  801699:	57                   	push   %edi
  80169a:	6a 00                	push   $0x0
  80169c:	53                   	push   %ebx
  80169d:	6a 00                	push   $0x0
  80169f:	e8 89 fa ff ff       	call   80112d <sys_page_map>
  8016a4:	89 c3                	mov    %eax,%ebx
  8016a6:	83 c4 20             	add    $0x20,%esp
  8016a9:	85 c0                	test   %eax,%eax
  8016ab:	79 a3                	jns    801650 <dup+0x74>
	sys_page_unmap(0, newfd);
  8016ad:	83 ec 08             	sub    $0x8,%esp
  8016b0:	56                   	push   %esi
  8016b1:	6a 00                	push   $0x0
  8016b3:	e8 b7 fa ff ff       	call   80116f <sys_page_unmap>
	sys_page_unmap(0, nva);
  8016b8:	83 c4 08             	add    $0x8,%esp
  8016bb:	57                   	push   %edi
  8016bc:	6a 00                	push   $0x0
  8016be:	e8 ac fa ff ff       	call   80116f <sys_page_unmap>
	return r;
  8016c3:	83 c4 10             	add    $0x10,%esp
  8016c6:	eb b7                	jmp    80167f <dup+0xa3>

008016c8 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016c8:	55                   	push   %ebp
  8016c9:	89 e5                	mov    %esp,%ebp
  8016cb:	53                   	push   %ebx
  8016cc:	83 ec 1c             	sub    $0x1c,%esp
  8016cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016d2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016d5:	50                   	push   %eax
  8016d6:	53                   	push   %ebx
  8016d7:	e8 7c fd ff ff       	call   801458 <fd_lookup>
  8016dc:	83 c4 10             	add    $0x10,%esp
  8016df:	85 c0                	test   %eax,%eax
  8016e1:	78 3f                	js     801722 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016e3:	83 ec 08             	sub    $0x8,%esp
  8016e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016e9:	50                   	push   %eax
  8016ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ed:	ff 30                	pushl  (%eax)
  8016ef:	e8 b4 fd ff ff       	call   8014a8 <dev_lookup>
  8016f4:	83 c4 10             	add    $0x10,%esp
  8016f7:	85 c0                	test   %eax,%eax
  8016f9:	78 27                	js     801722 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016fe:	8b 42 08             	mov    0x8(%edx),%eax
  801701:	83 e0 03             	and    $0x3,%eax
  801704:	83 f8 01             	cmp    $0x1,%eax
  801707:	74 1e                	je     801727 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80170c:	8b 40 08             	mov    0x8(%eax),%eax
  80170f:	85 c0                	test   %eax,%eax
  801711:	74 35                	je     801748 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801713:	83 ec 04             	sub    $0x4,%esp
  801716:	ff 75 10             	pushl  0x10(%ebp)
  801719:	ff 75 0c             	pushl  0xc(%ebp)
  80171c:	52                   	push   %edx
  80171d:	ff d0                	call   *%eax
  80171f:	83 c4 10             	add    $0x10,%esp
}
  801722:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801725:	c9                   	leave  
  801726:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801727:	a1 90 77 80 00       	mov    0x807790,%eax
  80172c:	8b 40 48             	mov    0x48(%eax),%eax
  80172f:	83 ec 04             	sub    $0x4,%esp
  801732:	53                   	push   %ebx
  801733:	50                   	push   %eax
  801734:	68 95 33 80 00       	push   $0x803395
  801739:	e8 5b ee ff ff       	call   800599 <cprintf>
		return -E_INVAL;
  80173e:	83 c4 10             	add    $0x10,%esp
  801741:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801746:	eb da                	jmp    801722 <read+0x5a>
		return -E_NOT_SUPP;
  801748:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80174d:	eb d3                	jmp    801722 <read+0x5a>

0080174f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
  801752:	57                   	push   %edi
  801753:	56                   	push   %esi
  801754:	53                   	push   %ebx
  801755:	83 ec 0c             	sub    $0xc,%esp
  801758:	8b 7d 08             	mov    0x8(%ebp),%edi
  80175b:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80175e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801763:	39 f3                	cmp    %esi,%ebx
  801765:	73 23                	jae    80178a <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801767:	83 ec 04             	sub    $0x4,%esp
  80176a:	89 f0                	mov    %esi,%eax
  80176c:	29 d8                	sub    %ebx,%eax
  80176e:	50                   	push   %eax
  80176f:	89 d8                	mov    %ebx,%eax
  801771:	03 45 0c             	add    0xc(%ebp),%eax
  801774:	50                   	push   %eax
  801775:	57                   	push   %edi
  801776:	e8 4d ff ff ff       	call   8016c8 <read>
		if (m < 0)
  80177b:	83 c4 10             	add    $0x10,%esp
  80177e:	85 c0                	test   %eax,%eax
  801780:	78 06                	js     801788 <readn+0x39>
			return m;
		if (m == 0)
  801782:	74 06                	je     80178a <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801784:	01 c3                	add    %eax,%ebx
  801786:	eb db                	jmp    801763 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801788:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80178a:	89 d8                	mov    %ebx,%eax
  80178c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80178f:	5b                   	pop    %ebx
  801790:	5e                   	pop    %esi
  801791:	5f                   	pop    %edi
  801792:	5d                   	pop    %ebp
  801793:	c3                   	ret    

00801794 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
  801797:	53                   	push   %ebx
  801798:	83 ec 1c             	sub    $0x1c,%esp
  80179b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80179e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017a1:	50                   	push   %eax
  8017a2:	53                   	push   %ebx
  8017a3:	e8 b0 fc ff ff       	call   801458 <fd_lookup>
  8017a8:	83 c4 10             	add    $0x10,%esp
  8017ab:	85 c0                	test   %eax,%eax
  8017ad:	78 3a                	js     8017e9 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017af:	83 ec 08             	sub    $0x8,%esp
  8017b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017b5:	50                   	push   %eax
  8017b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b9:	ff 30                	pushl  (%eax)
  8017bb:	e8 e8 fc ff ff       	call   8014a8 <dev_lookup>
  8017c0:	83 c4 10             	add    $0x10,%esp
  8017c3:	85 c0                	test   %eax,%eax
  8017c5:	78 22                	js     8017e9 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ca:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017ce:	74 1e                	je     8017ee <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8017d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d3:	8b 52 0c             	mov    0xc(%edx),%edx
  8017d6:	85 d2                	test   %edx,%edx
  8017d8:	74 35                	je     80180f <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017da:	83 ec 04             	sub    $0x4,%esp
  8017dd:	ff 75 10             	pushl  0x10(%ebp)
  8017e0:	ff 75 0c             	pushl  0xc(%ebp)
  8017e3:	50                   	push   %eax
  8017e4:	ff d2                	call   *%edx
  8017e6:	83 c4 10             	add    $0x10,%esp
}
  8017e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ec:	c9                   	leave  
  8017ed:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017ee:	a1 90 77 80 00       	mov    0x807790,%eax
  8017f3:	8b 40 48             	mov    0x48(%eax),%eax
  8017f6:	83 ec 04             	sub    $0x4,%esp
  8017f9:	53                   	push   %ebx
  8017fa:	50                   	push   %eax
  8017fb:	68 b1 33 80 00       	push   $0x8033b1
  801800:	e8 94 ed ff ff       	call   800599 <cprintf>
		return -E_INVAL;
  801805:	83 c4 10             	add    $0x10,%esp
  801808:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80180d:	eb da                	jmp    8017e9 <write+0x55>
		return -E_NOT_SUPP;
  80180f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801814:	eb d3                	jmp    8017e9 <write+0x55>

00801816 <seek>:

int
seek(int fdnum, off_t offset)
{
  801816:	55                   	push   %ebp
  801817:	89 e5                	mov    %esp,%ebp
  801819:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80181c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80181f:	50                   	push   %eax
  801820:	ff 75 08             	pushl  0x8(%ebp)
  801823:	e8 30 fc ff ff       	call   801458 <fd_lookup>
  801828:	83 c4 10             	add    $0x10,%esp
  80182b:	85 c0                	test   %eax,%eax
  80182d:	78 0e                	js     80183d <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80182f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801835:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801838:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80183d:	c9                   	leave  
  80183e:	c3                   	ret    

0080183f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
  801842:	53                   	push   %ebx
  801843:	83 ec 1c             	sub    $0x1c,%esp
  801846:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801849:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80184c:	50                   	push   %eax
  80184d:	53                   	push   %ebx
  80184e:	e8 05 fc ff ff       	call   801458 <fd_lookup>
  801853:	83 c4 10             	add    $0x10,%esp
  801856:	85 c0                	test   %eax,%eax
  801858:	78 37                	js     801891 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80185a:	83 ec 08             	sub    $0x8,%esp
  80185d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801860:	50                   	push   %eax
  801861:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801864:	ff 30                	pushl  (%eax)
  801866:	e8 3d fc ff ff       	call   8014a8 <dev_lookup>
  80186b:	83 c4 10             	add    $0x10,%esp
  80186e:	85 c0                	test   %eax,%eax
  801870:	78 1f                	js     801891 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801872:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801875:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801879:	74 1b                	je     801896 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80187b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80187e:	8b 52 18             	mov    0x18(%edx),%edx
  801881:	85 d2                	test   %edx,%edx
  801883:	74 32                	je     8018b7 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801885:	83 ec 08             	sub    $0x8,%esp
  801888:	ff 75 0c             	pushl  0xc(%ebp)
  80188b:	50                   	push   %eax
  80188c:	ff d2                	call   *%edx
  80188e:	83 c4 10             	add    $0x10,%esp
}
  801891:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801894:	c9                   	leave  
  801895:	c3                   	ret    
			thisenv->env_id, fdnum);
  801896:	a1 90 77 80 00       	mov    0x807790,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80189b:	8b 40 48             	mov    0x48(%eax),%eax
  80189e:	83 ec 04             	sub    $0x4,%esp
  8018a1:	53                   	push   %ebx
  8018a2:	50                   	push   %eax
  8018a3:	68 74 33 80 00       	push   $0x803374
  8018a8:	e8 ec ec ff ff       	call   800599 <cprintf>
		return -E_INVAL;
  8018ad:	83 c4 10             	add    $0x10,%esp
  8018b0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018b5:	eb da                	jmp    801891 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8018b7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018bc:	eb d3                	jmp    801891 <ftruncate+0x52>

008018be <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	53                   	push   %ebx
  8018c2:	83 ec 1c             	sub    $0x1c,%esp
  8018c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018c8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018cb:	50                   	push   %eax
  8018cc:	ff 75 08             	pushl  0x8(%ebp)
  8018cf:	e8 84 fb ff ff       	call   801458 <fd_lookup>
  8018d4:	83 c4 10             	add    $0x10,%esp
  8018d7:	85 c0                	test   %eax,%eax
  8018d9:	78 4b                	js     801926 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018db:	83 ec 08             	sub    $0x8,%esp
  8018de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018e1:	50                   	push   %eax
  8018e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e5:	ff 30                	pushl  (%eax)
  8018e7:	e8 bc fb ff ff       	call   8014a8 <dev_lookup>
  8018ec:	83 c4 10             	add    $0x10,%esp
  8018ef:	85 c0                	test   %eax,%eax
  8018f1:	78 33                	js     801926 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8018f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f6:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018fa:	74 2f                	je     80192b <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018fc:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018ff:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801906:	00 00 00 
	stat->st_isdir = 0;
  801909:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801910:	00 00 00 
	stat->st_dev = dev;
  801913:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801919:	83 ec 08             	sub    $0x8,%esp
  80191c:	53                   	push   %ebx
  80191d:	ff 75 f0             	pushl  -0x10(%ebp)
  801920:	ff 50 14             	call   *0x14(%eax)
  801923:	83 c4 10             	add    $0x10,%esp
}
  801926:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801929:	c9                   	leave  
  80192a:	c3                   	ret    
		return -E_NOT_SUPP;
  80192b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801930:	eb f4                	jmp    801926 <fstat+0x68>

00801932 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801932:	55                   	push   %ebp
  801933:	89 e5                	mov    %esp,%ebp
  801935:	56                   	push   %esi
  801936:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801937:	83 ec 08             	sub    $0x8,%esp
  80193a:	6a 00                	push   $0x0
  80193c:	ff 75 08             	pushl  0x8(%ebp)
  80193f:	e8 22 02 00 00       	call   801b66 <open>
  801944:	89 c3                	mov    %eax,%ebx
  801946:	83 c4 10             	add    $0x10,%esp
  801949:	85 c0                	test   %eax,%eax
  80194b:	78 1b                	js     801968 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80194d:	83 ec 08             	sub    $0x8,%esp
  801950:	ff 75 0c             	pushl  0xc(%ebp)
  801953:	50                   	push   %eax
  801954:	e8 65 ff ff ff       	call   8018be <fstat>
  801959:	89 c6                	mov    %eax,%esi
	close(fd);
  80195b:	89 1c 24             	mov    %ebx,(%esp)
  80195e:	e8 27 fc ff ff       	call   80158a <close>
	return r;
  801963:	83 c4 10             	add    $0x10,%esp
  801966:	89 f3                	mov    %esi,%ebx
}
  801968:	89 d8                	mov    %ebx,%eax
  80196a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80196d:	5b                   	pop    %ebx
  80196e:	5e                   	pop    %esi
  80196f:	5d                   	pop    %ebp
  801970:	c3                   	ret    

00801971 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp
  801974:	56                   	push   %esi
  801975:	53                   	push   %ebx
  801976:	89 c6                	mov    %eax,%esi
  801978:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80197a:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801981:	74 27                	je     8019aa <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801983:	6a 07                	push   $0x7
  801985:	68 00 80 80 00       	push   $0x808000
  80198a:	56                   	push   %esi
  80198b:	ff 35 00 60 80 00    	pushl  0x806000
  801991:	e8 fe 10 00 00       	call   802a94 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801996:	83 c4 0c             	add    $0xc,%esp
  801999:	6a 00                	push   $0x0
  80199b:	53                   	push   %ebx
  80199c:	6a 00                	push   $0x0
  80199e:	e8 88 10 00 00       	call   802a2b <ipc_recv>
}
  8019a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019a6:	5b                   	pop    %ebx
  8019a7:	5e                   	pop    %esi
  8019a8:	5d                   	pop    %ebp
  8019a9:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8019aa:	83 ec 0c             	sub    $0xc,%esp
  8019ad:	6a 01                	push   $0x1
  8019af:	e8 38 11 00 00       	call   802aec <ipc_find_env>
  8019b4:	a3 00 60 80 00       	mov    %eax,0x806000
  8019b9:	83 c4 10             	add    $0x10,%esp
  8019bc:	eb c5                	jmp    801983 <fsipc+0x12>

008019be <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
  8019c1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8019c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8019ca:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.set_size.req_size = newsize;
  8019cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d2:	a3 04 80 80 00       	mov    %eax,0x808004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8019d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8019dc:	b8 02 00 00 00       	mov    $0x2,%eax
  8019e1:	e8 8b ff ff ff       	call   801971 <fsipc>
}
  8019e6:	c9                   	leave  
  8019e7:	c3                   	ret    

008019e8 <devfile_flush>:
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
  8019eb:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8019f4:	a3 00 80 80 00       	mov    %eax,0x808000
	return fsipc(FSREQ_FLUSH, NULL);
  8019f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8019fe:	b8 06 00 00 00       	mov    $0x6,%eax
  801a03:	e8 69 ff ff ff       	call   801971 <fsipc>
}
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <devfile_stat>:
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
  801a0d:	53                   	push   %ebx
  801a0e:	83 ec 04             	sub    $0x4,%esp
  801a11:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a14:	8b 45 08             	mov    0x8(%ebp),%eax
  801a17:	8b 40 0c             	mov    0xc(%eax),%eax
  801a1a:	a3 00 80 80 00       	mov    %eax,0x808000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a1f:	ba 00 00 00 00       	mov    $0x0,%edx
  801a24:	b8 05 00 00 00       	mov    $0x5,%eax
  801a29:	e8 43 ff ff ff       	call   801971 <fsipc>
  801a2e:	85 c0                	test   %eax,%eax
  801a30:	78 2c                	js     801a5e <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a32:	83 ec 08             	sub    $0x8,%esp
  801a35:	68 00 80 80 00       	push   $0x808000
  801a3a:	53                   	push   %ebx
  801a3b:	e8 b8 f2 ff ff       	call   800cf8 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a40:	a1 80 80 80 00       	mov    0x808080,%eax
  801a45:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a4b:	a1 84 80 80 00       	mov    0x808084,%eax
  801a50:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a56:	83 c4 10             	add    $0x10,%esp
  801a59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <devfile_write>:
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
  801a66:	53                   	push   %ebx
  801a67:	83 ec 08             	sub    $0x8,%esp
  801a6a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a70:	8b 40 0c             	mov    0xc(%eax),%eax
  801a73:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.write.req_n = n;
  801a78:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801a7e:	53                   	push   %ebx
  801a7f:	ff 75 0c             	pushl  0xc(%ebp)
  801a82:	68 08 80 80 00       	push   $0x808008
  801a87:	e8 5c f4 ff ff       	call   800ee8 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801a8c:	ba 00 00 00 00       	mov    $0x0,%edx
  801a91:	b8 04 00 00 00       	mov    $0x4,%eax
  801a96:	e8 d6 fe ff ff       	call   801971 <fsipc>
  801a9b:	83 c4 10             	add    $0x10,%esp
  801a9e:	85 c0                	test   %eax,%eax
  801aa0:	78 0b                	js     801aad <devfile_write+0x4a>
	assert(r <= n);
  801aa2:	39 d8                	cmp    %ebx,%eax
  801aa4:	77 0c                	ja     801ab2 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801aa6:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801aab:	7f 1e                	jg     801acb <devfile_write+0x68>
}
  801aad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ab0:	c9                   	leave  
  801ab1:	c3                   	ret    
	assert(r <= n);
  801ab2:	68 e4 33 80 00       	push   $0x8033e4
  801ab7:	68 eb 33 80 00       	push   $0x8033eb
  801abc:	68 98 00 00 00       	push   $0x98
  801ac1:	68 00 34 80 00       	push   $0x803400
  801ac6:	e8 d8 e9 ff ff       	call   8004a3 <_panic>
	assert(r <= PGSIZE);
  801acb:	68 0b 34 80 00       	push   $0x80340b
  801ad0:	68 eb 33 80 00       	push   $0x8033eb
  801ad5:	68 99 00 00 00       	push   $0x99
  801ada:	68 00 34 80 00       	push   $0x803400
  801adf:	e8 bf e9 ff ff       	call   8004a3 <_panic>

00801ae4 <devfile_read>:
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
  801ae7:	56                   	push   %esi
  801ae8:	53                   	push   %ebx
  801ae9:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801aec:	8b 45 08             	mov    0x8(%ebp),%eax
  801aef:	8b 40 0c             	mov    0xc(%eax),%eax
  801af2:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.read.req_n = n;
  801af7:	89 35 04 80 80 00    	mov    %esi,0x808004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801afd:	ba 00 00 00 00       	mov    $0x0,%edx
  801b02:	b8 03 00 00 00       	mov    $0x3,%eax
  801b07:	e8 65 fe ff ff       	call   801971 <fsipc>
  801b0c:	89 c3                	mov    %eax,%ebx
  801b0e:	85 c0                	test   %eax,%eax
  801b10:	78 1f                	js     801b31 <devfile_read+0x4d>
	assert(r <= n);
  801b12:	39 f0                	cmp    %esi,%eax
  801b14:	77 24                	ja     801b3a <devfile_read+0x56>
	assert(r <= PGSIZE);
  801b16:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b1b:	7f 33                	jg     801b50 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b1d:	83 ec 04             	sub    $0x4,%esp
  801b20:	50                   	push   %eax
  801b21:	68 00 80 80 00       	push   $0x808000
  801b26:	ff 75 0c             	pushl  0xc(%ebp)
  801b29:	e8 58 f3 ff ff       	call   800e86 <memmove>
	return r;
  801b2e:	83 c4 10             	add    $0x10,%esp
}
  801b31:	89 d8                	mov    %ebx,%eax
  801b33:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b36:	5b                   	pop    %ebx
  801b37:	5e                   	pop    %esi
  801b38:	5d                   	pop    %ebp
  801b39:	c3                   	ret    
	assert(r <= n);
  801b3a:	68 e4 33 80 00       	push   $0x8033e4
  801b3f:	68 eb 33 80 00       	push   $0x8033eb
  801b44:	6a 7c                	push   $0x7c
  801b46:	68 00 34 80 00       	push   $0x803400
  801b4b:	e8 53 e9 ff ff       	call   8004a3 <_panic>
	assert(r <= PGSIZE);
  801b50:	68 0b 34 80 00       	push   $0x80340b
  801b55:	68 eb 33 80 00       	push   $0x8033eb
  801b5a:	6a 7d                	push   $0x7d
  801b5c:	68 00 34 80 00       	push   $0x803400
  801b61:	e8 3d e9 ff ff       	call   8004a3 <_panic>

00801b66 <open>:
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
  801b69:	56                   	push   %esi
  801b6a:	53                   	push   %ebx
  801b6b:	83 ec 1c             	sub    $0x1c,%esp
  801b6e:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b71:	56                   	push   %esi
  801b72:	e8 48 f1 ff ff       	call   800cbf <strlen>
  801b77:	83 c4 10             	add    $0x10,%esp
  801b7a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b7f:	7f 6c                	jg     801bed <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801b81:	83 ec 0c             	sub    $0xc,%esp
  801b84:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b87:	50                   	push   %eax
  801b88:	e8 79 f8 ff ff       	call   801406 <fd_alloc>
  801b8d:	89 c3                	mov    %eax,%ebx
  801b8f:	83 c4 10             	add    $0x10,%esp
  801b92:	85 c0                	test   %eax,%eax
  801b94:	78 3c                	js     801bd2 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801b96:	83 ec 08             	sub    $0x8,%esp
  801b99:	56                   	push   %esi
  801b9a:	68 00 80 80 00       	push   $0x808000
  801b9f:	e8 54 f1 ff ff       	call   800cf8 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801ba4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ba7:	a3 00 84 80 00       	mov    %eax,0x808400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801bac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801baf:	b8 01 00 00 00       	mov    $0x1,%eax
  801bb4:	e8 b8 fd ff ff       	call   801971 <fsipc>
  801bb9:	89 c3                	mov    %eax,%ebx
  801bbb:	83 c4 10             	add    $0x10,%esp
  801bbe:	85 c0                	test   %eax,%eax
  801bc0:	78 19                	js     801bdb <open+0x75>
	return fd2num(fd);
  801bc2:	83 ec 0c             	sub    $0xc,%esp
  801bc5:	ff 75 f4             	pushl  -0xc(%ebp)
  801bc8:	e8 12 f8 ff ff       	call   8013df <fd2num>
  801bcd:	89 c3                	mov    %eax,%ebx
  801bcf:	83 c4 10             	add    $0x10,%esp
}
  801bd2:	89 d8                	mov    %ebx,%eax
  801bd4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bd7:	5b                   	pop    %ebx
  801bd8:	5e                   	pop    %esi
  801bd9:	5d                   	pop    %ebp
  801bda:	c3                   	ret    
		fd_close(fd, 0);
  801bdb:	83 ec 08             	sub    $0x8,%esp
  801bde:	6a 00                	push   $0x0
  801be0:	ff 75 f4             	pushl  -0xc(%ebp)
  801be3:	e8 1b f9 ff ff       	call   801503 <fd_close>
		return r;
  801be8:	83 c4 10             	add    $0x10,%esp
  801beb:	eb e5                	jmp    801bd2 <open+0x6c>
		return -E_BAD_PATH;
  801bed:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801bf2:	eb de                	jmp    801bd2 <open+0x6c>

00801bf4 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
  801bf7:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801bfa:	ba 00 00 00 00       	mov    $0x0,%edx
  801bff:	b8 08 00 00 00       	mov    $0x8,%eax
  801c04:	e8 68 fd ff ff       	call   801971 <fsipc>
}
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
  801c0e:	57                   	push   %edi
  801c0f:	56                   	push   %esi
  801c10:	53                   	push   %ebx
  801c11:	81 ec 94 02 00 00    	sub    $0x294,%esp
	cprintf("in %s\n", __FUNCTION__);
  801c17:	68 f0 34 80 00       	push   $0x8034f0
  801c1c:	68 57 2f 80 00       	push   $0x802f57
  801c21:	e8 73 e9 ff ff       	call   800599 <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801c26:	83 c4 08             	add    $0x8,%esp
  801c29:	6a 00                	push   $0x0
  801c2b:	ff 75 08             	pushl  0x8(%ebp)
  801c2e:	e8 33 ff ff ff       	call   801b66 <open>
  801c33:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801c39:	83 c4 10             	add    $0x10,%esp
  801c3c:	85 c0                	test   %eax,%eax
  801c3e:	0f 88 0a 05 00 00    	js     80214e <spawn+0x543>
  801c44:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801c46:	83 ec 04             	sub    $0x4,%esp
  801c49:	68 00 02 00 00       	push   $0x200
  801c4e:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801c54:	50                   	push   %eax
  801c55:	51                   	push   %ecx
  801c56:	e8 f4 fa ff ff       	call   80174f <readn>
  801c5b:	83 c4 10             	add    $0x10,%esp
  801c5e:	3d 00 02 00 00       	cmp    $0x200,%eax
  801c63:	75 74                	jne    801cd9 <spawn+0xce>
	    || elf->e_magic != ELF_MAGIC) {
  801c65:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801c6c:	45 4c 46 
  801c6f:	75 68                	jne    801cd9 <spawn+0xce>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801c71:	b8 07 00 00 00       	mov    $0x7,%eax
  801c76:	cd 30                	int    $0x30
  801c78:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801c7e:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801c84:	85 c0                	test   %eax,%eax
  801c86:	0f 88 b6 04 00 00    	js     802142 <spawn+0x537>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801c8c:	25 ff 03 00 00       	and    $0x3ff,%eax
  801c91:	89 c6                	mov    %eax,%esi
  801c93:	c1 e6 07             	shl    $0x7,%esi
  801c96:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801c9c:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801ca2:	b9 11 00 00 00       	mov    $0x11,%ecx
  801ca7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801ca9:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801caf:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
	cprintf("in %s\n", __FUNCTION__);
  801cb5:	83 ec 08             	sub    $0x8,%esp
  801cb8:	68 e4 34 80 00       	push   $0x8034e4
  801cbd:	68 57 2f 80 00       	push   $0x802f57
  801cc2:	e8 d2 e8 ff ff       	call   800599 <cprintf>
  801cc7:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801cca:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801ccf:	be 00 00 00 00       	mov    $0x0,%esi
  801cd4:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801cd7:	eb 4b                	jmp    801d24 <spawn+0x119>
		close(fd);
  801cd9:	83 ec 0c             	sub    $0xc,%esp
  801cdc:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801ce2:	e8 a3 f8 ff ff       	call   80158a <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801ce7:	83 c4 0c             	add    $0xc,%esp
  801cea:	68 7f 45 4c 46       	push   $0x464c457f
  801cef:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801cf5:	68 17 34 80 00       	push   $0x803417
  801cfa:	e8 9a e8 ff ff       	call   800599 <cprintf>
		return -E_NOT_EXEC;
  801cff:	83 c4 10             	add    $0x10,%esp
  801d02:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801d09:	ff ff ff 
  801d0c:	e9 3d 04 00 00       	jmp    80214e <spawn+0x543>
		string_size += strlen(argv[argc]) + 1;
  801d11:	83 ec 0c             	sub    $0xc,%esp
  801d14:	50                   	push   %eax
  801d15:	e8 a5 ef ff ff       	call   800cbf <strlen>
  801d1a:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801d1e:	83 c3 01             	add    $0x1,%ebx
  801d21:	83 c4 10             	add    $0x10,%esp
  801d24:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801d2b:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801d2e:	85 c0                	test   %eax,%eax
  801d30:	75 df                	jne    801d11 <spawn+0x106>
  801d32:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801d38:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801d3e:	bf 00 10 40 00       	mov    $0x401000,%edi
  801d43:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801d45:	89 fa                	mov    %edi,%edx
  801d47:	83 e2 fc             	and    $0xfffffffc,%edx
  801d4a:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801d51:	29 c2                	sub    %eax,%edx
  801d53:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801d59:	8d 42 f8             	lea    -0x8(%edx),%eax
  801d5c:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801d61:	0f 86 0a 04 00 00    	jbe    802171 <spawn+0x566>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801d67:	83 ec 04             	sub    $0x4,%esp
  801d6a:	6a 07                	push   $0x7
  801d6c:	68 00 00 40 00       	push   $0x400000
  801d71:	6a 00                	push   $0x0
  801d73:	e8 72 f3 ff ff       	call   8010ea <sys_page_alloc>
  801d78:	83 c4 10             	add    $0x10,%esp
  801d7b:	85 c0                	test   %eax,%eax
  801d7d:	0f 88 f3 03 00 00    	js     802176 <spawn+0x56b>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801d83:	be 00 00 00 00       	mov    $0x0,%esi
  801d88:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801d8e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801d91:	eb 30                	jmp    801dc3 <spawn+0x1b8>
		argv_store[i] = UTEMP2USTACK(string_store);
  801d93:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801d99:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801d9f:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801da2:	83 ec 08             	sub    $0x8,%esp
  801da5:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801da8:	57                   	push   %edi
  801da9:	e8 4a ef ff ff       	call   800cf8 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801dae:	83 c4 04             	add    $0x4,%esp
  801db1:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801db4:	e8 06 ef ff ff       	call   800cbf <strlen>
  801db9:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801dbd:	83 c6 01             	add    $0x1,%esi
  801dc0:	83 c4 10             	add    $0x10,%esp
  801dc3:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801dc9:	7f c8                	jg     801d93 <spawn+0x188>
	}
	argv_store[argc] = 0;
  801dcb:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801dd1:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801dd7:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801dde:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801de4:	0f 85 86 00 00 00    	jne    801e70 <spawn+0x265>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801dea:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  801df0:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  801df6:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  801df9:	89 d0                	mov    %edx,%eax
  801dfb:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  801e01:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801e04:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801e09:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801e0f:	83 ec 0c             	sub    $0xc,%esp
  801e12:	6a 07                	push   $0x7
  801e14:	68 00 d0 bf ee       	push   $0xeebfd000
  801e19:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801e1f:	68 00 00 40 00       	push   $0x400000
  801e24:	6a 00                	push   $0x0
  801e26:	e8 02 f3 ff ff       	call   80112d <sys_page_map>
  801e2b:	89 c3                	mov    %eax,%ebx
  801e2d:	83 c4 20             	add    $0x20,%esp
  801e30:	85 c0                	test   %eax,%eax
  801e32:	0f 88 46 03 00 00    	js     80217e <spawn+0x573>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801e38:	83 ec 08             	sub    $0x8,%esp
  801e3b:	68 00 00 40 00       	push   $0x400000
  801e40:	6a 00                	push   $0x0
  801e42:	e8 28 f3 ff ff       	call   80116f <sys_page_unmap>
  801e47:	89 c3                	mov    %eax,%ebx
  801e49:	83 c4 10             	add    $0x10,%esp
  801e4c:	85 c0                	test   %eax,%eax
  801e4e:	0f 88 2a 03 00 00    	js     80217e <spawn+0x573>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801e54:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801e5a:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801e61:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801e68:	00 00 00 
  801e6b:	e9 4f 01 00 00       	jmp    801fbf <spawn+0x3b4>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801e70:	68 a0 34 80 00       	push   $0x8034a0
  801e75:	68 eb 33 80 00       	push   $0x8033eb
  801e7a:	68 f8 00 00 00       	push   $0xf8
  801e7f:	68 31 34 80 00       	push   $0x803431
  801e84:	e8 1a e6 ff ff       	call   8004a3 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801e89:	83 ec 04             	sub    $0x4,%esp
  801e8c:	6a 07                	push   $0x7
  801e8e:	68 00 00 40 00       	push   $0x400000
  801e93:	6a 00                	push   $0x0
  801e95:	e8 50 f2 ff ff       	call   8010ea <sys_page_alloc>
  801e9a:	83 c4 10             	add    $0x10,%esp
  801e9d:	85 c0                	test   %eax,%eax
  801e9f:	0f 88 b7 02 00 00    	js     80215c <spawn+0x551>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801ea5:	83 ec 08             	sub    $0x8,%esp
  801ea8:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801eae:	01 f0                	add    %esi,%eax
  801eb0:	50                   	push   %eax
  801eb1:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801eb7:	e8 5a f9 ff ff       	call   801816 <seek>
  801ebc:	83 c4 10             	add    $0x10,%esp
  801ebf:	85 c0                	test   %eax,%eax
  801ec1:	0f 88 9c 02 00 00    	js     802163 <spawn+0x558>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801ec7:	83 ec 04             	sub    $0x4,%esp
  801eca:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801ed0:	29 f0                	sub    %esi,%eax
  801ed2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ed7:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801edc:	0f 47 c1             	cmova  %ecx,%eax
  801edf:	50                   	push   %eax
  801ee0:	68 00 00 40 00       	push   $0x400000
  801ee5:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801eeb:	e8 5f f8 ff ff       	call   80174f <readn>
  801ef0:	83 c4 10             	add    $0x10,%esp
  801ef3:	85 c0                	test   %eax,%eax
  801ef5:	0f 88 6f 02 00 00    	js     80216a <spawn+0x55f>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801efb:	83 ec 0c             	sub    $0xc,%esp
  801efe:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801f04:	53                   	push   %ebx
  801f05:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801f0b:	68 00 00 40 00       	push   $0x400000
  801f10:	6a 00                	push   $0x0
  801f12:	e8 16 f2 ff ff       	call   80112d <sys_page_map>
  801f17:	83 c4 20             	add    $0x20,%esp
  801f1a:	85 c0                	test   %eax,%eax
  801f1c:	78 7c                	js     801f9a <spawn+0x38f>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801f1e:	83 ec 08             	sub    $0x8,%esp
  801f21:	68 00 00 40 00       	push   $0x400000
  801f26:	6a 00                	push   $0x0
  801f28:	e8 42 f2 ff ff       	call   80116f <sys_page_unmap>
  801f2d:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801f30:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801f36:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801f3c:	89 fe                	mov    %edi,%esi
  801f3e:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801f44:	76 69                	jbe    801faf <spawn+0x3a4>
		if (i >= filesz) {
  801f46:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801f4c:	0f 87 37 ff ff ff    	ja     801e89 <spawn+0x27e>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801f52:	83 ec 04             	sub    $0x4,%esp
  801f55:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801f5b:	53                   	push   %ebx
  801f5c:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801f62:	e8 83 f1 ff ff       	call   8010ea <sys_page_alloc>
  801f67:	83 c4 10             	add    $0x10,%esp
  801f6a:	85 c0                	test   %eax,%eax
  801f6c:	79 c2                	jns    801f30 <spawn+0x325>
  801f6e:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801f70:	83 ec 0c             	sub    $0xc,%esp
  801f73:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801f79:	e8 ed f0 ff ff       	call   80106b <sys_env_destroy>
	close(fd);
  801f7e:	83 c4 04             	add    $0x4,%esp
  801f81:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801f87:	e8 fe f5 ff ff       	call   80158a <close>
	return r;
  801f8c:	83 c4 10             	add    $0x10,%esp
  801f8f:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801f95:	e9 b4 01 00 00       	jmp    80214e <spawn+0x543>
				panic("spawn: sys_page_map data: %e", r);
  801f9a:	50                   	push   %eax
  801f9b:	68 3d 34 80 00       	push   $0x80343d
  801fa0:	68 2b 01 00 00       	push   $0x12b
  801fa5:	68 31 34 80 00       	push   $0x803431
  801faa:	e8 f4 e4 ff ff       	call   8004a3 <_panic>
  801faf:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801fb5:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801fbc:	83 c6 20             	add    $0x20,%esi
  801fbf:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801fc6:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801fcc:	7e 6d                	jle    80203b <spawn+0x430>
		if (ph->p_type != ELF_PROG_LOAD)
  801fce:	83 3e 01             	cmpl   $0x1,(%esi)
  801fd1:	75 e2                	jne    801fb5 <spawn+0x3aa>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801fd3:	8b 46 18             	mov    0x18(%esi),%eax
  801fd6:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801fd9:	83 f8 01             	cmp    $0x1,%eax
  801fdc:	19 c0                	sbb    %eax,%eax
  801fde:	83 e0 fe             	and    $0xfffffffe,%eax
  801fe1:	83 c0 07             	add    $0x7,%eax
  801fe4:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801fea:	8b 4e 04             	mov    0x4(%esi),%ecx
  801fed:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801ff3:	8b 56 10             	mov    0x10(%esi),%edx
  801ff6:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801ffc:	8b 7e 14             	mov    0x14(%esi),%edi
  801fff:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  802005:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  802008:	89 d8                	mov    %ebx,%eax
  80200a:	25 ff 0f 00 00       	and    $0xfff,%eax
  80200f:	74 1a                	je     80202b <spawn+0x420>
		va -= i;
  802011:	29 c3                	sub    %eax,%ebx
		memsz += i;
  802013:	01 c7                	add    %eax,%edi
  802015:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  80201b:	01 c2                	add    %eax,%edx
  80201d:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  802023:	29 c1                	sub    %eax,%ecx
  802025:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  80202b:	bf 00 00 00 00       	mov    $0x0,%edi
  802030:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  802036:	e9 01 ff ff ff       	jmp    801f3c <spawn+0x331>
	close(fd);
  80203b:	83 ec 0c             	sub    $0xc,%esp
  80203e:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802044:	e8 41 f5 ff ff       	call   80158a <close>

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	cprintf("in %s\n", __FUNCTION__);
  802049:	83 c4 08             	add    $0x8,%esp
  80204c:	68 d0 34 80 00       	push   $0x8034d0
  802051:	68 57 2f 80 00       	push   $0x802f57
  802056:	e8 3e e5 ff ff       	call   800599 <cprintf>
  80205b:	83 c4 10             	add    $0x10,%esp
	int r;
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  80205e:	bb 00 00 80 00       	mov    $0x800000,%ebx
  802063:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  802069:	eb 0e                	jmp    802079 <spawn+0x46e>
  80206b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802071:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  802077:	74 5e                	je     8020d7 <spawn+0x4cc>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_SHARE)) == (PTE_P | PTE_U | PTE_SHARE)))
  802079:	89 d8                	mov    %ebx,%eax
  80207b:	c1 e8 16             	shr    $0x16,%eax
  80207e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802085:	a8 01                	test   $0x1,%al
  802087:	74 e2                	je     80206b <spawn+0x460>
  802089:	89 da                	mov    %ebx,%edx
  80208b:	c1 ea 0c             	shr    $0xc,%edx
  80208e:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  802095:	25 05 04 00 00       	and    $0x405,%eax
  80209a:	3d 05 04 00 00       	cmp    $0x405,%eax
  80209f:	75 ca                	jne    80206b <spawn+0x460>
			if((r = sys_page_map((envid_t)0, (void *)i, child, (void *)i, uvpt[PGNUM(i)] & PTE_SYSCALL)) < 0)
  8020a1:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8020a8:	83 ec 0c             	sub    $0xc,%esp
  8020ab:	25 07 0e 00 00       	and    $0xe07,%eax
  8020b0:	50                   	push   %eax
  8020b1:	53                   	push   %ebx
  8020b2:	56                   	push   %esi
  8020b3:	53                   	push   %ebx
  8020b4:	6a 00                	push   $0x0
  8020b6:	e8 72 f0 ff ff       	call   80112d <sys_page_map>
  8020bb:	83 c4 20             	add    $0x20,%esp
  8020be:	85 c0                	test   %eax,%eax
  8020c0:	79 a9                	jns    80206b <spawn+0x460>
        		panic("sys_page_map: %e\n", r);
  8020c2:	50                   	push   %eax
  8020c3:	68 5a 34 80 00       	push   $0x80345a
  8020c8:	68 3b 01 00 00       	push   $0x13b
  8020cd:	68 31 34 80 00       	push   $0x803431
  8020d2:	e8 cc e3 ff ff       	call   8004a3 <_panic>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8020d7:	83 ec 08             	sub    $0x8,%esp
  8020da:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  8020e0:	50                   	push   %eax
  8020e1:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8020e7:	e8 07 f1 ff ff       	call   8011f3 <sys_env_set_trapframe>
  8020ec:	83 c4 10             	add    $0x10,%esp
  8020ef:	85 c0                	test   %eax,%eax
  8020f1:	78 25                	js     802118 <spawn+0x50d>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8020f3:	83 ec 08             	sub    $0x8,%esp
  8020f6:	6a 02                	push   $0x2
  8020f8:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8020fe:	e8 ae f0 ff ff       	call   8011b1 <sys_env_set_status>
  802103:	83 c4 10             	add    $0x10,%esp
  802106:	85 c0                	test   %eax,%eax
  802108:	78 23                	js     80212d <spawn+0x522>
	return child;
  80210a:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802110:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802116:	eb 36                	jmp    80214e <spawn+0x543>
		panic("sys_env_set_trapframe: %e", r);
  802118:	50                   	push   %eax
  802119:	68 6c 34 80 00       	push   $0x80346c
  80211e:	68 8a 00 00 00       	push   $0x8a
  802123:	68 31 34 80 00       	push   $0x803431
  802128:	e8 76 e3 ff ff       	call   8004a3 <_panic>
		panic("sys_env_set_status: %e", r);
  80212d:	50                   	push   %eax
  80212e:	68 86 34 80 00       	push   $0x803486
  802133:	68 8d 00 00 00       	push   $0x8d
  802138:	68 31 34 80 00       	push   $0x803431
  80213d:	e8 61 e3 ff ff       	call   8004a3 <_panic>
		return r;
  802142:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802148:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  80214e:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802154:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802157:	5b                   	pop    %ebx
  802158:	5e                   	pop    %esi
  802159:	5f                   	pop    %edi
  80215a:	5d                   	pop    %ebp
  80215b:	c3                   	ret    
  80215c:	89 c7                	mov    %eax,%edi
  80215e:	e9 0d fe ff ff       	jmp    801f70 <spawn+0x365>
  802163:	89 c7                	mov    %eax,%edi
  802165:	e9 06 fe ff ff       	jmp    801f70 <spawn+0x365>
  80216a:	89 c7                	mov    %eax,%edi
  80216c:	e9 ff fd ff ff       	jmp    801f70 <spawn+0x365>
		return -E_NO_MEM;
  802171:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  802176:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  80217c:	eb d0                	jmp    80214e <spawn+0x543>
	sys_page_unmap(0, UTEMP);
  80217e:	83 ec 08             	sub    $0x8,%esp
  802181:	68 00 00 40 00       	push   $0x400000
  802186:	6a 00                	push   $0x0
  802188:	e8 e2 ef ff ff       	call   80116f <sys_page_unmap>
  80218d:	83 c4 10             	add    $0x10,%esp
  802190:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  802196:	eb b6                	jmp    80214e <spawn+0x543>

00802198 <spawnl>:
{
  802198:	55                   	push   %ebp
  802199:	89 e5                	mov    %esp,%ebp
  80219b:	57                   	push   %edi
  80219c:	56                   	push   %esi
  80219d:	53                   	push   %ebx
  80219e:	83 ec 14             	sub    $0x14,%esp
	cprintf("in %s\n", __FUNCTION__);
  8021a1:	68 c8 34 80 00       	push   $0x8034c8
  8021a6:	68 57 2f 80 00       	push   $0x802f57
  8021ab:	e8 e9 e3 ff ff       	call   800599 <cprintf>
	va_start(vl, arg0);
  8021b0:	8d 55 10             	lea    0x10(%ebp),%edx
	while(va_arg(vl, void *) != NULL)
  8021b3:	83 c4 10             	add    $0x10,%esp
	int argc=0;
  8021b6:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  8021bb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8021be:	83 3a 00             	cmpl   $0x0,(%edx)
  8021c1:	74 07                	je     8021ca <spawnl+0x32>
		argc++;
  8021c3:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  8021c6:	89 ca                	mov    %ecx,%edx
  8021c8:	eb f1                	jmp    8021bb <spawnl+0x23>
	const char *argv[argc+2];
  8021ca:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  8021d1:	83 e2 f0             	and    $0xfffffff0,%edx
  8021d4:	29 d4                	sub    %edx,%esp
  8021d6:	8d 54 24 03          	lea    0x3(%esp),%edx
  8021da:	c1 ea 02             	shr    $0x2,%edx
  8021dd:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  8021e4:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  8021e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021e9:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  8021f0:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  8021f7:	00 
	va_start(vl, arg0);
  8021f8:	8d 4d 10             	lea    0x10(%ebp),%ecx
  8021fb:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  8021fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802202:	eb 0b                	jmp    80220f <spawnl+0x77>
		argv[i+1] = va_arg(vl, const char *);
  802204:	83 c0 01             	add    $0x1,%eax
  802207:	8b 39                	mov    (%ecx),%edi
  802209:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  80220c:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  80220f:	39 d0                	cmp    %edx,%eax
  802211:	75 f1                	jne    802204 <spawnl+0x6c>
	return spawn(prog, argv);
  802213:	83 ec 08             	sub    $0x8,%esp
  802216:	56                   	push   %esi
  802217:	ff 75 08             	pushl  0x8(%ebp)
  80221a:	e8 ec f9 ff ff       	call   801c0b <spawn>
}
  80221f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802222:	5b                   	pop    %ebx
  802223:	5e                   	pop    %esi
  802224:	5f                   	pop    %edi
  802225:	5d                   	pop    %ebp
  802226:	c3                   	ret    

00802227 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802227:	55                   	push   %ebp
  802228:	89 e5                	mov    %esp,%ebp
  80222a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80222d:	68 f6 34 80 00       	push   $0x8034f6
  802232:	ff 75 0c             	pushl  0xc(%ebp)
  802235:	e8 be ea ff ff       	call   800cf8 <strcpy>
	return 0;
}
  80223a:	b8 00 00 00 00       	mov    $0x0,%eax
  80223f:	c9                   	leave  
  802240:	c3                   	ret    

00802241 <devsock_close>:
{
  802241:	55                   	push   %ebp
  802242:	89 e5                	mov    %esp,%ebp
  802244:	53                   	push   %ebx
  802245:	83 ec 10             	sub    $0x10,%esp
  802248:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80224b:	53                   	push   %ebx
  80224c:	e8 d6 08 00 00       	call   802b27 <pageref>
  802251:	83 c4 10             	add    $0x10,%esp
		return 0;
  802254:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  802259:	83 f8 01             	cmp    $0x1,%eax
  80225c:	74 07                	je     802265 <devsock_close+0x24>
}
  80225e:	89 d0                	mov    %edx,%eax
  802260:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802263:	c9                   	leave  
  802264:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  802265:	83 ec 0c             	sub    $0xc,%esp
  802268:	ff 73 0c             	pushl  0xc(%ebx)
  80226b:	e8 b9 02 00 00       	call   802529 <nsipc_close>
  802270:	89 c2                	mov    %eax,%edx
  802272:	83 c4 10             	add    $0x10,%esp
  802275:	eb e7                	jmp    80225e <devsock_close+0x1d>

00802277 <devsock_write>:
{
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
  80227a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80227d:	6a 00                	push   $0x0
  80227f:	ff 75 10             	pushl  0x10(%ebp)
  802282:	ff 75 0c             	pushl  0xc(%ebp)
  802285:	8b 45 08             	mov    0x8(%ebp),%eax
  802288:	ff 70 0c             	pushl  0xc(%eax)
  80228b:	e8 76 03 00 00       	call   802606 <nsipc_send>
}
  802290:	c9                   	leave  
  802291:	c3                   	ret    

00802292 <devsock_read>:
{
  802292:	55                   	push   %ebp
  802293:	89 e5                	mov    %esp,%ebp
  802295:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802298:	6a 00                	push   $0x0
  80229a:	ff 75 10             	pushl  0x10(%ebp)
  80229d:	ff 75 0c             	pushl  0xc(%ebp)
  8022a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a3:	ff 70 0c             	pushl  0xc(%eax)
  8022a6:	e8 ef 02 00 00       	call   80259a <nsipc_recv>
}
  8022ab:	c9                   	leave  
  8022ac:	c3                   	ret    

008022ad <fd2sockid>:
{
  8022ad:	55                   	push   %ebp
  8022ae:	89 e5                	mov    %esp,%ebp
  8022b0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8022b3:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8022b6:	52                   	push   %edx
  8022b7:	50                   	push   %eax
  8022b8:	e8 9b f1 ff ff       	call   801458 <fd_lookup>
  8022bd:	83 c4 10             	add    $0x10,%esp
  8022c0:	85 c0                	test   %eax,%eax
  8022c2:	78 10                	js     8022d4 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8022c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c7:	8b 0d ac 57 80 00    	mov    0x8057ac,%ecx
  8022cd:	39 08                	cmp    %ecx,(%eax)
  8022cf:	75 05                	jne    8022d6 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8022d1:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8022d4:	c9                   	leave  
  8022d5:	c3                   	ret    
		return -E_NOT_SUPP;
  8022d6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8022db:	eb f7                	jmp    8022d4 <fd2sockid+0x27>

008022dd <alloc_sockfd>:
{
  8022dd:	55                   	push   %ebp
  8022de:	89 e5                	mov    %esp,%ebp
  8022e0:	56                   	push   %esi
  8022e1:	53                   	push   %ebx
  8022e2:	83 ec 1c             	sub    $0x1c,%esp
  8022e5:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8022e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022ea:	50                   	push   %eax
  8022eb:	e8 16 f1 ff ff       	call   801406 <fd_alloc>
  8022f0:	89 c3                	mov    %eax,%ebx
  8022f2:	83 c4 10             	add    $0x10,%esp
  8022f5:	85 c0                	test   %eax,%eax
  8022f7:	78 43                	js     80233c <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8022f9:	83 ec 04             	sub    $0x4,%esp
  8022fc:	68 07 04 00 00       	push   $0x407
  802301:	ff 75 f4             	pushl  -0xc(%ebp)
  802304:	6a 00                	push   $0x0
  802306:	e8 df ed ff ff       	call   8010ea <sys_page_alloc>
  80230b:	89 c3                	mov    %eax,%ebx
  80230d:	83 c4 10             	add    $0x10,%esp
  802310:	85 c0                	test   %eax,%eax
  802312:	78 28                	js     80233c <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802314:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802317:	8b 15 ac 57 80 00    	mov    0x8057ac,%edx
  80231d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80231f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802322:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802329:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80232c:	83 ec 0c             	sub    $0xc,%esp
  80232f:	50                   	push   %eax
  802330:	e8 aa f0 ff ff       	call   8013df <fd2num>
  802335:	89 c3                	mov    %eax,%ebx
  802337:	83 c4 10             	add    $0x10,%esp
  80233a:	eb 0c                	jmp    802348 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80233c:	83 ec 0c             	sub    $0xc,%esp
  80233f:	56                   	push   %esi
  802340:	e8 e4 01 00 00       	call   802529 <nsipc_close>
		return r;
  802345:	83 c4 10             	add    $0x10,%esp
}
  802348:	89 d8                	mov    %ebx,%eax
  80234a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80234d:	5b                   	pop    %ebx
  80234e:	5e                   	pop    %esi
  80234f:	5d                   	pop    %ebp
  802350:	c3                   	ret    

00802351 <accept>:
{
  802351:	55                   	push   %ebp
  802352:	89 e5                	mov    %esp,%ebp
  802354:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802357:	8b 45 08             	mov    0x8(%ebp),%eax
  80235a:	e8 4e ff ff ff       	call   8022ad <fd2sockid>
  80235f:	85 c0                	test   %eax,%eax
  802361:	78 1b                	js     80237e <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802363:	83 ec 04             	sub    $0x4,%esp
  802366:	ff 75 10             	pushl  0x10(%ebp)
  802369:	ff 75 0c             	pushl  0xc(%ebp)
  80236c:	50                   	push   %eax
  80236d:	e8 0e 01 00 00       	call   802480 <nsipc_accept>
  802372:	83 c4 10             	add    $0x10,%esp
  802375:	85 c0                	test   %eax,%eax
  802377:	78 05                	js     80237e <accept+0x2d>
	return alloc_sockfd(r);
  802379:	e8 5f ff ff ff       	call   8022dd <alloc_sockfd>
}
  80237e:	c9                   	leave  
  80237f:	c3                   	ret    

00802380 <bind>:
{
  802380:	55                   	push   %ebp
  802381:	89 e5                	mov    %esp,%ebp
  802383:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802386:	8b 45 08             	mov    0x8(%ebp),%eax
  802389:	e8 1f ff ff ff       	call   8022ad <fd2sockid>
  80238e:	85 c0                	test   %eax,%eax
  802390:	78 12                	js     8023a4 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802392:	83 ec 04             	sub    $0x4,%esp
  802395:	ff 75 10             	pushl  0x10(%ebp)
  802398:	ff 75 0c             	pushl  0xc(%ebp)
  80239b:	50                   	push   %eax
  80239c:	e8 31 01 00 00       	call   8024d2 <nsipc_bind>
  8023a1:	83 c4 10             	add    $0x10,%esp
}
  8023a4:	c9                   	leave  
  8023a5:	c3                   	ret    

008023a6 <shutdown>:
{
  8023a6:	55                   	push   %ebp
  8023a7:	89 e5                	mov    %esp,%ebp
  8023a9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8023ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8023af:	e8 f9 fe ff ff       	call   8022ad <fd2sockid>
  8023b4:	85 c0                	test   %eax,%eax
  8023b6:	78 0f                	js     8023c7 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8023b8:	83 ec 08             	sub    $0x8,%esp
  8023bb:	ff 75 0c             	pushl  0xc(%ebp)
  8023be:	50                   	push   %eax
  8023bf:	e8 43 01 00 00       	call   802507 <nsipc_shutdown>
  8023c4:	83 c4 10             	add    $0x10,%esp
}
  8023c7:	c9                   	leave  
  8023c8:	c3                   	ret    

008023c9 <connect>:
{
  8023c9:	55                   	push   %ebp
  8023ca:	89 e5                	mov    %esp,%ebp
  8023cc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8023cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d2:	e8 d6 fe ff ff       	call   8022ad <fd2sockid>
  8023d7:	85 c0                	test   %eax,%eax
  8023d9:	78 12                	js     8023ed <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8023db:	83 ec 04             	sub    $0x4,%esp
  8023de:	ff 75 10             	pushl  0x10(%ebp)
  8023e1:	ff 75 0c             	pushl  0xc(%ebp)
  8023e4:	50                   	push   %eax
  8023e5:	e8 59 01 00 00       	call   802543 <nsipc_connect>
  8023ea:	83 c4 10             	add    $0x10,%esp
}
  8023ed:	c9                   	leave  
  8023ee:	c3                   	ret    

008023ef <listen>:
{
  8023ef:	55                   	push   %ebp
  8023f0:	89 e5                	mov    %esp,%ebp
  8023f2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8023f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f8:	e8 b0 fe ff ff       	call   8022ad <fd2sockid>
  8023fd:	85 c0                	test   %eax,%eax
  8023ff:	78 0f                	js     802410 <listen+0x21>
	return nsipc_listen(r, backlog);
  802401:	83 ec 08             	sub    $0x8,%esp
  802404:	ff 75 0c             	pushl  0xc(%ebp)
  802407:	50                   	push   %eax
  802408:	e8 6b 01 00 00       	call   802578 <nsipc_listen>
  80240d:	83 c4 10             	add    $0x10,%esp
}
  802410:	c9                   	leave  
  802411:	c3                   	ret    

00802412 <socket>:

int
socket(int domain, int type, int protocol)
{
  802412:	55                   	push   %ebp
  802413:	89 e5                	mov    %esp,%ebp
  802415:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802418:	ff 75 10             	pushl  0x10(%ebp)
  80241b:	ff 75 0c             	pushl  0xc(%ebp)
  80241e:	ff 75 08             	pushl  0x8(%ebp)
  802421:	e8 3e 02 00 00       	call   802664 <nsipc_socket>
  802426:	83 c4 10             	add    $0x10,%esp
  802429:	85 c0                	test   %eax,%eax
  80242b:	78 05                	js     802432 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80242d:	e8 ab fe ff ff       	call   8022dd <alloc_sockfd>
}
  802432:	c9                   	leave  
  802433:	c3                   	ret    

00802434 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802434:	55                   	push   %ebp
  802435:	89 e5                	mov    %esp,%ebp
  802437:	53                   	push   %ebx
  802438:	83 ec 04             	sub    $0x4,%esp
  80243b:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80243d:	83 3d 04 60 80 00 00 	cmpl   $0x0,0x806004
  802444:	74 26                	je     80246c <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802446:	6a 07                	push   $0x7
  802448:	68 00 90 80 00       	push   $0x809000
  80244d:	53                   	push   %ebx
  80244e:	ff 35 04 60 80 00    	pushl  0x806004
  802454:	e8 3b 06 00 00       	call   802a94 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802459:	83 c4 0c             	add    $0xc,%esp
  80245c:	6a 00                	push   $0x0
  80245e:	6a 00                	push   $0x0
  802460:	6a 00                	push   $0x0
  802462:	e8 c4 05 00 00       	call   802a2b <ipc_recv>
}
  802467:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80246a:	c9                   	leave  
  80246b:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80246c:	83 ec 0c             	sub    $0xc,%esp
  80246f:	6a 02                	push   $0x2
  802471:	e8 76 06 00 00       	call   802aec <ipc_find_env>
  802476:	a3 04 60 80 00       	mov    %eax,0x806004
  80247b:	83 c4 10             	add    $0x10,%esp
  80247e:	eb c6                	jmp    802446 <nsipc+0x12>

00802480 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802480:	55                   	push   %ebp
  802481:	89 e5                	mov    %esp,%ebp
  802483:	56                   	push   %esi
  802484:	53                   	push   %ebx
  802485:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802488:	8b 45 08             	mov    0x8(%ebp),%eax
  80248b:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802490:	8b 06                	mov    (%esi),%eax
  802492:	a3 04 90 80 00       	mov    %eax,0x809004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802497:	b8 01 00 00 00       	mov    $0x1,%eax
  80249c:	e8 93 ff ff ff       	call   802434 <nsipc>
  8024a1:	89 c3                	mov    %eax,%ebx
  8024a3:	85 c0                	test   %eax,%eax
  8024a5:	79 09                	jns    8024b0 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8024a7:	89 d8                	mov    %ebx,%eax
  8024a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024ac:	5b                   	pop    %ebx
  8024ad:	5e                   	pop    %esi
  8024ae:	5d                   	pop    %ebp
  8024af:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8024b0:	83 ec 04             	sub    $0x4,%esp
  8024b3:	ff 35 10 90 80 00    	pushl  0x809010
  8024b9:	68 00 90 80 00       	push   $0x809000
  8024be:	ff 75 0c             	pushl  0xc(%ebp)
  8024c1:	e8 c0 e9 ff ff       	call   800e86 <memmove>
		*addrlen = ret->ret_addrlen;
  8024c6:	a1 10 90 80 00       	mov    0x809010,%eax
  8024cb:	89 06                	mov    %eax,(%esi)
  8024cd:	83 c4 10             	add    $0x10,%esp
	return r;
  8024d0:	eb d5                	jmp    8024a7 <nsipc_accept+0x27>

008024d2 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8024d2:	55                   	push   %ebp
  8024d3:	89 e5                	mov    %esp,%ebp
  8024d5:	53                   	push   %ebx
  8024d6:	83 ec 08             	sub    $0x8,%esp
  8024d9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8024dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024df:	a3 00 90 80 00       	mov    %eax,0x809000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8024e4:	53                   	push   %ebx
  8024e5:	ff 75 0c             	pushl  0xc(%ebp)
  8024e8:	68 04 90 80 00       	push   $0x809004
  8024ed:	e8 94 e9 ff ff       	call   800e86 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8024f2:	89 1d 14 90 80 00    	mov    %ebx,0x809014
	return nsipc(NSREQ_BIND);
  8024f8:	b8 02 00 00 00       	mov    $0x2,%eax
  8024fd:	e8 32 ff ff ff       	call   802434 <nsipc>
}
  802502:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802505:	c9                   	leave  
  802506:	c3                   	ret    

00802507 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802507:	55                   	push   %ebp
  802508:	89 e5                	mov    %esp,%ebp
  80250a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80250d:	8b 45 08             	mov    0x8(%ebp),%eax
  802510:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.shutdown.req_how = how;
  802515:	8b 45 0c             	mov    0xc(%ebp),%eax
  802518:	a3 04 90 80 00       	mov    %eax,0x809004
	return nsipc(NSREQ_SHUTDOWN);
  80251d:	b8 03 00 00 00       	mov    $0x3,%eax
  802522:	e8 0d ff ff ff       	call   802434 <nsipc>
}
  802527:	c9                   	leave  
  802528:	c3                   	ret    

00802529 <nsipc_close>:

int
nsipc_close(int s)
{
  802529:	55                   	push   %ebp
  80252a:	89 e5                	mov    %esp,%ebp
  80252c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80252f:	8b 45 08             	mov    0x8(%ebp),%eax
  802532:	a3 00 90 80 00       	mov    %eax,0x809000
	return nsipc(NSREQ_CLOSE);
  802537:	b8 04 00 00 00       	mov    $0x4,%eax
  80253c:	e8 f3 fe ff ff       	call   802434 <nsipc>
}
  802541:	c9                   	leave  
  802542:	c3                   	ret    

00802543 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802543:	55                   	push   %ebp
  802544:	89 e5                	mov    %esp,%ebp
  802546:	53                   	push   %ebx
  802547:	83 ec 08             	sub    $0x8,%esp
  80254a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80254d:	8b 45 08             	mov    0x8(%ebp),%eax
  802550:	a3 00 90 80 00       	mov    %eax,0x809000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802555:	53                   	push   %ebx
  802556:	ff 75 0c             	pushl  0xc(%ebp)
  802559:	68 04 90 80 00       	push   $0x809004
  80255e:	e8 23 e9 ff ff       	call   800e86 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802563:	89 1d 14 90 80 00    	mov    %ebx,0x809014
	return nsipc(NSREQ_CONNECT);
  802569:	b8 05 00 00 00       	mov    $0x5,%eax
  80256e:	e8 c1 fe ff ff       	call   802434 <nsipc>
}
  802573:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802576:	c9                   	leave  
  802577:	c3                   	ret    

00802578 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802578:	55                   	push   %ebp
  802579:	89 e5                	mov    %esp,%ebp
  80257b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80257e:	8b 45 08             	mov    0x8(%ebp),%eax
  802581:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.listen.req_backlog = backlog;
  802586:	8b 45 0c             	mov    0xc(%ebp),%eax
  802589:	a3 04 90 80 00       	mov    %eax,0x809004
	return nsipc(NSREQ_LISTEN);
  80258e:	b8 06 00 00 00       	mov    $0x6,%eax
  802593:	e8 9c fe ff ff       	call   802434 <nsipc>
}
  802598:	c9                   	leave  
  802599:	c3                   	ret    

0080259a <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80259a:	55                   	push   %ebp
  80259b:	89 e5                	mov    %esp,%ebp
  80259d:	56                   	push   %esi
  80259e:	53                   	push   %ebx
  80259f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8025a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a5:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.recv.req_len = len;
  8025aa:	89 35 04 90 80 00    	mov    %esi,0x809004
	nsipcbuf.recv.req_flags = flags;
  8025b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8025b3:	a3 08 90 80 00       	mov    %eax,0x809008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8025b8:	b8 07 00 00 00       	mov    $0x7,%eax
  8025bd:	e8 72 fe ff ff       	call   802434 <nsipc>
  8025c2:	89 c3                	mov    %eax,%ebx
  8025c4:	85 c0                	test   %eax,%eax
  8025c6:	78 1f                	js     8025e7 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8025c8:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8025cd:	7f 21                	jg     8025f0 <nsipc_recv+0x56>
  8025cf:	39 c6                	cmp    %eax,%esi
  8025d1:	7c 1d                	jl     8025f0 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8025d3:	83 ec 04             	sub    $0x4,%esp
  8025d6:	50                   	push   %eax
  8025d7:	68 00 90 80 00       	push   $0x809000
  8025dc:	ff 75 0c             	pushl  0xc(%ebp)
  8025df:	e8 a2 e8 ff ff       	call   800e86 <memmove>
  8025e4:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8025e7:	89 d8                	mov    %ebx,%eax
  8025e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025ec:	5b                   	pop    %ebx
  8025ed:	5e                   	pop    %esi
  8025ee:	5d                   	pop    %ebp
  8025ef:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8025f0:	68 02 35 80 00       	push   $0x803502
  8025f5:	68 eb 33 80 00       	push   $0x8033eb
  8025fa:	6a 62                	push   $0x62
  8025fc:	68 17 35 80 00       	push   $0x803517
  802601:	e8 9d de ff ff       	call   8004a3 <_panic>

00802606 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802606:	55                   	push   %ebp
  802607:	89 e5                	mov    %esp,%ebp
  802609:	53                   	push   %ebx
  80260a:	83 ec 04             	sub    $0x4,%esp
  80260d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802610:	8b 45 08             	mov    0x8(%ebp),%eax
  802613:	a3 00 90 80 00       	mov    %eax,0x809000
	assert(size < 1600);
  802618:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80261e:	7f 2e                	jg     80264e <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802620:	83 ec 04             	sub    $0x4,%esp
  802623:	53                   	push   %ebx
  802624:	ff 75 0c             	pushl  0xc(%ebp)
  802627:	68 0c 90 80 00       	push   $0x80900c
  80262c:	e8 55 e8 ff ff       	call   800e86 <memmove>
	nsipcbuf.send.req_size = size;
  802631:	89 1d 04 90 80 00    	mov    %ebx,0x809004
	nsipcbuf.send.req_flags = flags;
  802637:	8b 45 14             	mov    0x14(%ebp),%eax
  80263a:	a3 08 90 80 00       	mov    %eax,0x809008
	return nsipc(NSREQ_SEND);
  80263f:	b8 08 00 00 00       	mov    $0x8,%eax
  802644:	e8 eb fd ff ff       	call   802434 <nsipc>
}
  802649:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80264c:	c9                   	leave  
  80264d:	c3                   	ret    
	assert(size < 1600);
  80264e:	68 23 35 80 00       	push   $0x803523
  802653:	68 eb 33 80 00       	push   $0x8033eb
  802658:	6a 6d                	push   $0x6d
  80265a:	68 17 35 80 00       	push   $0x803517
  80265f:	e8 3f de ff ff       	call   8004a3 <_panic>

00802664 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802664:	55                   	push   %ebp
  802665:	89 e5                	mov    %esp,%ebp
  802667:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80266a:	8b 45 08             	mov    0x8(%ebp),%eax
  80266d:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.socket.req_type = type;
  802672:	8b 45 0c             	mov    0xc(%ebp),%eax
  802675:	a3 04 90 80 00       	mov    %eax,0x809004
	nsipcbuf.socket.req_protocol = protocol;
  80267a:	8b 45 10             	mov    0x10(%ebp),%eax
  80267d:	a3 08 90 80 00       	mov    %eax,0x809008
	return nsipc(NSREQ_SOCKET);
  802682:	b8 09 00 00 00       	mov    $0x9,%eax
  802687:	e8 a8 fd ff ff       	call   802434 <nsipc>
}
  80268c:	c9                   	leave  
  80268d:	c3                   	ret    

0080268e <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80268e:	55                   	push   %ebp
  80268f:	89 e5                	mov    %esp,%ebp
  802691:	56                   	push   %esi
  802692:	53                   	push   %ebx
  802693:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802696:	83 ec 0c             	sub    $0xc,%esp
  802699:	ff 75 08             	pushl  0x8(%ebp)
  80269c:	e8 4e ed ff ff       	call   8013ef <fd2data>
  8026a1:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8026a3:	83 c4 08             	add    $0x8,%esp
  8026a6:	68 2f 35 80 00       	push   $0x80352f
  8026ab:	53                   	push   %ebx
  8026ac:	e8 47 e6 ff ff       	call   800cf8 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8026b1:	8b 46 04             	mov    0x4(%esi),%eax
  8026b4:	2b 06                	sub    (%esi),%eax
  8026b6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8026bc:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8026c3:	00 00 00 
	stat->st_dev = &devpipe;
  8026c6:	c7 83 88 00 00 00 c8 	movl   $0x8057c8,0x88(%ebx)
  8026cd:	57 80 00 
	return 0;
}
  8026d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026d8:	5b                   	pop    %ebx
  8026d9:	5e                   	pop    %esi
  8026da:	5d                   	pop    %ebp
  8026db:	c3                   	ret    

008026dc <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8026dc:	55                   	push   %ebp
  8026dd:	89 e5                	mov    %esp,%ebp
  8026df:	53                   	push   %ebx
  8026e0:	83 ec 0c             	sub    $0xc,%esp
  8026e3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8026e6:	53                   	push   %ebx
  8026e7:	6a 00                	push   $0x0
  8026e9:	e8 81 ea ff ff       	call   80116f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8026ee:	89 1c 24             	mov    %ebx,(%esp)
  8026f1:	e8 f9 ec ff ff       	call   8013ef <fd2data>
  8026f6:	83 c4 08             	add    $0x8,%esp
  8026f9:	50                   	push   %eax
  8026fa:	6a 00                	push   $0x0
  8026fc:	e8 6e ea ff ff       	call   80116f <sys_page_unmap>
}
  802701:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802704:	c9                   	leave  
  802705:	c3                   	ret    

00802706 <_pipeisclosed>:
{
  802706:	55                   	push   %ebp
  802707:	89 e5                	mov    %esp,%ebp
  802709:	57                   	push   %edi
  80270a:	56                   	push   %esi
  80270b:	53                   	push   %ebx
  80270c:	83 ec 1c             	sub    $0x1c,%esp
  80270f:	89 c7                	mov    %eax,%edi
  802711:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802713:	a1 90 77 80 00       	mov    0x807790,%eax
  802718:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80271b:	83 ec 0c             	sub    $0xc,%esp
  80271e:	57                   	push   %edi
  80271f:	e8 03 04 00 00       	call   802b27 <pageref>
  802724:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802727:	89 34 24             	mov    %esi,(%esp)
  80272a:	e8 f8 03 00 00       	call   802b27 <pageref>
		nn = thisenv->env_runs;
  80272f:	8b 15 90 77 80 00    	mov    0x807790,%edx
  802735:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802738:	83 c4 10             	add    $0x10,%esp
  80273b:	39 cb                	cmp    %ecx,%ebx
  80273d:	74 1b                	je     80275a <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80273f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802742:	75 cf                	jne    802713 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802744:	8b 42 58             	mov    0x58(%edx),%eax
  802747:	6a 01                	push   $0x1
  802749:	50                   	push   %eax
  80274a:	53                   	push   %ebx
  80274b:	68 36 35 80 00       	push   $0x803536
  802750:	e8 44 de ff ff       	call   800599 <cprintf>
  802755:	83 c4 10             	add    $0x10,%esp
  802758:	eb b9                	jmp    802713 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80275a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80275d:	0f 94 c0             	sete   %al
  802760:	0f b6 c0             	movzbl %al,%eax
}
  802763:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802766:	5b                   	pop    %ebx
  802767:	5e                   	pop    %esi
  802768:	5f                   	pop    %edi
  802769:	5d                   	pop    %ebp
  80276a:	c3                   	ret    

0080276b <devpipe_write>:
{
  80276b:	55                   	push   %ebp
  80276c:	89 e5                	mov    %esp,%ebp
  80276e:	57                   	push   %edi
  80276f:	56                   	push   %esi
  802770:	53                   	push   %ebx
  802771:	83 ec 28             	sub    $0x28,%esp
  802774:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802777:	56                   	push   %esi
  802778:	e8 72 ec ff ff       	call   8013ef <fd2data>
  80277d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80277f:	83 c4 10             	add    $0x10,%esp
  802782:	bf 00 00 00 00       	mov    $0x0,%edi
  802787:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80278a:	74 4f                	je     8027db <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80278c:	8b 43 04             	mov    0x4(%ebx),%eax
  80278f:	8b 0b                	mov    (%ebx),%ecx
  802791:	8d 51 20             	lea    0x20(%ecx),%edx
  802794:	39 d0                	cmp    %edx,%eax
  802796:	72 14                	jb     8027ac <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802798:	89 da                	mov    %ebx,%edx
  80279a:	89 f0                	mov    %esi,%eax
  80279c:	e8 65 ff ff ff       	call   802706 <_pipeisclosed>
  8027a1:	85 c0                	test   %eax,%eax
  8027a3:	75 3b                	jne    8027e0 <devpipe_write+0x75>
			sys_yield();
  8027a5:	e8 21 e9 ff ff       	call   8010cb <sys_yield>
  8027aa:	eb e0                	jmp    80278c <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8027ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027af:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8027b3:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8027b6:	89 c2                	mov    %eax,%edx
  8027b8:	c1 fa 1f             	sar    $0x1f,%edx
  8027bb:	89 d1                	mov    %edx,%ecx
  8027bd:	c1 e9 1b             	shr    $0x1b,%ecx
  8027c0:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8027c3:	83 e2 1f             	and    $0x1f,%edx
  8027c6:	29 ca                	sub    %ecx,%edx
  8027c8:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8027cc:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8027d0:	83 c0 01             	add    $0x1,%eax
  8027d3:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8027d6:	83 c7 01             	add    $0x1,%edi
  8027d9:	eb ac                	jmp    802787 <devpipe_write+0x1c>
	return i;
  8027db:	8b 45 10             	mov    0x10(%ebp),%eax
  8027de:	eb 05                	jmp    8027e5 <devpipe_write+0x7a>
				return 0;
  8027e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027e8:	5b                   	pop    %ebx
  8027e9:	5e                   	pop    %esi
  8027ea:	5f                   	pop    %edi
  8027eb:	5d                   	pop    %ebp
  8027ec:	c3                   	ret    

008027ed <devpipe_read>:
{
  8027ed:	55                   	push   %ebp
  8027ee:	89 e5                	mov    %esp,%ebp
  8027f0:	57                   	push   %edi
  8027f1:	56                   	push   %esi
  8027f2:	53                   	push   %ebx
  8027f3:	83 ec 18             	sub    $0x18,%esp
  8027f6:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8027f9:	57                   	push   %edi
  8027fa:	e8 f0 eb ff ff       	call   8013ef <fd2data>
  8027ff:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802801:	83 c4 10             	add    $0x10,%esp
  802804:	be 00 00 00 00       	mov    $0x0,%esi
  802809:	3b 75 10             	cmp    0x10(%ebp),%esi
  80280c:	75 14                	jne    802822 <devpipe_read+0x35>
	return i;
  80280e:	8b 45 10             	mov    0x10(%ebp),%eax
  802811:	eb 02                	jmp    802815 <devpipe_read+0x28>
				return i;
  802813:	89 f0                	mov    %esi,%eax
}
  802815:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802818:	5b                   	pop    %ebx
  802819:	5e                   	pop    %esi
  80281a:	5f                   	pop    %edi
  80281b:	5d                   	pop    %ebp
  80281c:	c3                   	ret    
			sys_yield();
  80281d:	e8 a9 e8 ff ff       	call   8010cb <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802822:	8b 03                	mov    (%ebx),%eax
  802824:	3b 43 04             	cmp    0x4(%ebx),%eax
  802827:	75 18                	jne    802841 <devpipe_read+0x54>
			if (i > 0)
  802829:	85 f6                	test   %esi,%esi
  80282b:	75 e6                	jne    802813 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80282d:	89 da                	mov    %ebx,%edx
  80282f:	89 f8                	mov    %edi,%eax
  802831:	e8 d0 fe ff ff       	call   802706 <_pipeisclosed>
  802836:	85 c0                	test   %eax,%eax
  802838:	74 e3                	je     80281d <devpipe_read+0x30>
				return 0;
  80283a:	b8 00 00 00 00       	mov    $0x0,%eax
  80283f:	eb d4                	jmp    802815 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802841:	99                   	cltd   
  802842:	c1 ea 1b             	shr    $0x1b,%edx
  802845:	01 d0                	add    %edx,%eax
  802847:	83 e0 1f             	and    $0x1f,%eax
  80284a:	29 d0                	sub    %edx,%eax
  80284c:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802851:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802854:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802857:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80285a:	83 c6 01             	add    $0x1,%esi
  80285d:	eb aa                	jmp    802809 <devpipe_read+0x1c>

0080285f <pipe>:
{
  80285f:	55                   	push   %ebp
  802860:	89 e5                	mov    %esp,%ebp
  802862:	56                   	push   %esi
  802863:	53                   	push   %ebx
  802864:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802867:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80286a:	50                   	push   %eax
  80286b:	e8 96 eb ff ff       	call   801406 <fd_alloc>
  802870:	89 c3                	mov    %eax,%ebx
  802872:	83 c4 10             	add    $0x10,%esp
  802875:	85 c0                	test   %eax,%eax
  802877:	0f 88 23 01 00 00    	js     8029a0 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80287d:	83 ec 04             	sub    $0x4,%esp
  802880:	68 07 04 00 00       	push   $0x407
  802885:	ff 75 f4             	pushl  -0xc(%ebp)
  802888:	6a 00                	push   $0x0
  80288a:	e8 5b e8 ff ff       	call   8010ea <sys_page_alloc>
  80288f:	89 c3                	mov    %eax,%ebx
  802891:	83 c4 10             	add    $0x10,%esp
  802894:	85 c0                	test   %eax,%eax
  802896:	0f 88 04 01 00 00    	js     8029a0 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80289c:	83 ec 0c             	sub    $0xc,%esp
  80289f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8028a2:	50                   	push   %eax
  8028a3:	e8 5e eb ff ff       	call   801406 <fd_alloc>
  8028a8:	89 c3                	mov    %eax,%ebx
  8028aa:	83 c4 10             	add    $0x10,%esp
  8028ad:	85 c0                	test   %eax,%eax
  8028af:	0f 88 db 00 00 00    	js     802990 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028b5:	83 ec 04             	sub    $0x4,%esp
  8028b8:	68 07 04 00 00       	push   $0x407
  8028bd:	ff 75 f0             	pushl  -0x10(%ebp)
  8028c0:	6a 00                	push   $0x0
  8028c2:	e8 23 e8 ff ff       	call   8010ea <sys_page_alloc>
  8028c7:	89 c3                	mov    %eax,%ebx
  8028c9:	83 c4 10             	add    $0x10,%esp
  8028cc:	85 c0                	test   %eax,%eax
  8028ce:	0f 88 bc 00 00 00    	js     802990 <pipe+0x131>
	va = fd2data(fd0);
  8028d4:	83 ec 0c             	sub    $0xc,%esp
  8028d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8028da:	e8 10 eb ff ff       	call   8013ef <fd2data>
  8028df:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028e1:	83 c4 0c             	add    $0xc,%esp
  8028e4:	68 07 04 00 00       	push   $0x407
  8028e9:	50                   	push   %eax
  8028ea:	6a 00                	push   $0x0
  8028ec:	e8 f9 e7 ff ff       	call   8010ea <sys_page_alloc>
  8028f1:	89 c3                	mov    %eax,%ebx
  8028f3:	83 c4 10             	add    $0x10,%esp
  8028f6:	85 c0                	test   %eax,%eax
  8028f8:	0f 88 82 00 00 00    	js     802980 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028fe:	83 ec 0c             	sub    $0xc,%esp
  802901:	ff 75 f0             	pushl  -0x10(%ebp)
  802904:	e8 e6 ea ff ff       	call   8013ef <fd2data>
  802909:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802910:	50                   	push   %eax
  802911:	6a 00                	push   $0x0
  802913:	56                   	push   %esi
  802914:	6a 00                	push   $0x0
  802916:	e8 12 e8 ff ff       	call   80112d <sys_page_map>
  80291b:	89 c3                	mov    %eax,%ebx
  80291d:	83 c4 20             	add    $0x20,%esp
  802920:	85 c0                	test   %eax,%eax
  802922:	78 4e                	js     802972 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802924:	a1 c8 57 80 00       	mov    0x8057c8,%eax
  802929:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80292c:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80292e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802931:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802938:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80293b:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80293d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802940:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802947:	83 ec 0c             	sub    $0xc,%esp
  80294a:	ff 75 f4             	pushl  -0xc(%ebp)
  80294d:	e8 8d ea ff ff       	call   8013df <fd2num>
  802952:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802955:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802957:	83 c4 04             	add    $0x4,%esp
  80295a:	ff 75 f0             	pushl  -0x10(%ebp)
  80295d:	e8 7d ea ff ff       	call   8013df <fd2num>
  802962:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802965:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802968:	83 c4 10             	add    $0x10,%esp
  80296b:	bb 00 00 00 00       	mov    $0x0,%ebx
  802970:	eb 2e                	jmp    8029a0 <pipe+0x141>
	sys_page_unmap(0, va);
  802972:	83 ec 08             	sub    $0x8,%esp
  802975:	56                   	push   %esi
  802976:	6a 00                	push   $0x0
  802978:	e8 f2 e7 ff ff       	call   80116f <sys_page_unmap>
  80297d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802980:	83 ec 08             	sub    $0x8,%esp
  802983:	ff 75 f0             	pushl  -0x10(%ebp)
  802986:	6a 00                	push   $0x0
  802988:	e8 e2 e7 ff ff       	call   80116f <sys_page_unmap>
  80298d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802990:	83 ec 08             	sub    $0x8,%esp
  802993:	ff 75 f4             	pushl  -0xc(%ebp)
  802996:	6a 00                	push   $0x0
  802998:	e8 d2 e7 ff ff       	call   80116f <sys_page_unmap>
  80299d:	83 c4 10             	add    $0x10,%esp
}
  8029a0:	89 d8                	mov    %ebx,%eax
  8029a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8029a5:	5b                   	pop    %ebx
  8029a6:	5e                   	pop    %esi
  8029a7:	5d                   	pop    %ebp
  8029a8:	c3                   	ret    

008029a9 <pipeisclosed>:
{
  8029a9:	55                   	push   %ebp
  8029aa:	89 e5                	mov    %esp,%ebp
  8029ac:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029af:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8029b2:	50                   	push   %eax
  8029b3:	ff 75 08             	pushl  0x8(%ebp)
  8029b6:	e8 9d ea ff ff       	call   801458 <fd_lookup>
  8029bb:	83 c4 10             	add    $0x10,%esp
  8029be:	85 c0                	test   %eax,%eax
  8029c0:	78 18                	js     8029da <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8029c2:	83 ec 0c             	sub    $0xc,%esp
  8029c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8029c8:	e8 22 ea ff ff       	call   8013ef <fd2data>
	return _pipeisclosed(fd, p);
  8029cd:	89 c2                	mov    %eax,%edx
  8029cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d2:	e8 2f fd ff ff       	call   802706 <_pipeisclosed>
  8029d7:	83 c4 10             	add    $0x10,%esp
}
  8029da:	c9                   	leave  
  8029db:	c3                   	ret    

008029dc <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8029dc:	55                   	push   %ebp
  8029dd:	89 e5                	mov    %esp,%ebp
  8029df:	56                   	push   %esi
  8029e0:	53                   	push   %ebx
  8029e1:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  8029e4:	85 f6                	test   %esi,%esi
  8029e6:	74 13                	je     8029fb <wait+0x1f>
	e = &envs[ENVX(envid)];
  8029e8:	89 f3                	mov    %esi,%ebx
  8029ea:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8029f0:	c1 e3 07             	shl    $0x7,%ebx
  8029f3:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8029f9:	eb 1b                	jmp    802a16 <wait+0x3a>
	assert(envid != 0);
  8029fb:	68 4e 35 80 00       	push   $0x80354e
  802a00:	68 eb 33 80 00       	push   $0x8033eb
  802a05:	6a 09                	push   $0x9
  802a07:	68 59 35 80 00       	push   $0x803559
  802a0c:	e8 92 da ff ff       	call   8004a3 <_panic>
		sys_yield();
  802a11:	e8 b5 e6 ff ff       	call   8010cb <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802a16:	8b 43 48             	mov    0x48(%ebx),%eax
  802a19:	39 f0                	cmp    %esi,%eax
  802a1b:	75 07                	jne    802a24 <wait+0x48>
  802a1d:	8b 43 54             	mov    0x54(%ebx),%eax
  802a20:	85 c0                	test   %eax,%eax
  802a22:	75 ed                	jne    802a11 <wait+0x35>
}
  802a24:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a27:	5b                   	pop    %ebx
  802a28:	5e                   	pop    %esi
  802a29:	5d                   	pop    %ebp
  802a2a:	c3                   	ret    

00802a2b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802a2b:	55                   	push   %ebp
  802a2c:	89 e5                	mov    %esp,%ebp
  802a2e:	56                   	push   %esi
  802a2f:	53                   	push   %ebx
  802a30:	8b 75 08             	mov    0x8(%ebp),%esi
  802a33:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a36:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802a39:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802a3b:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802a40:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802a43:	83 ec 0c             	sub    $0xc,%esp
  802a46:	50                   	push   %eax
  802a47:	e8 4e e8 ff ff       	call   80129a <sys_ipc_recv>
	if(ret < 0){
  802a4c:	83 c4 10             	add    $0x10,%esp
  802a4f:	85 c0                	test   %eax,%eax
  802a51:	78 2b                	js     802a7e <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802a53:	85 f6                	test   %esi,%esi
  802a55:	74 0a                	je     802a61 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802a57:	a1 90 77 80 00       	mov    0x807790,%eax
  802a5c:	8b 40 74             	mov    0x74(%eax),%eax
  802a5f:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802a61:	85 db                	test   %ebx,%ebx
  802a63:	74 0a                	je     802a6f <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802a65:	a1 90 77 80 00       	mov    0x807790,%eax
  802a6a:	8b 40 78             	mov    0x78(%eax),%eax
  802a6d:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802a6f:	a1 90 77 80 00       	mov    0x807790,%eax
  802a74:	8b 40 70             	mov    0x70(%eax),%eax
}
  802a77:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a7a:	5b                   	pop    %ebx
  802a7b:	5e                   	pop    %esi
  802a7c:	5d                   	pop    %ebp
  802a7d:	c3                   	ret    
		if(from_env_store)
  802a7e:	85 f6                	test   %esi,%esi
  802a80:	74 06                	je     802a88 <ipc_recv+0x5d>
			*from_env_store = 0;
  802a82:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802a88:	85 db                	test   %ebx,%ebx
  802a8a:	74 eb                	je     802a77 <ipc_recv+0x4c>
			*perm_store = 0;
  802a8c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802a92:	eb e3                	jmp    802a77 <ipc_recv+0x4c>

00802a94 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802a94:	55                   	push   %ebp
  802a95:	89 e5                	mov    %esp,%ebp
  802a97:	57                   	push   %edi
  802a98:	56                   	push   %esi
  802a99:	53                   	push   %ebx
  802a9a:	83 ec 0c             	sub    $0xc,%esp
  802a9d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802aa0:	8b 75 0c             	mov    0xc(%ebp),%esi
  802aa3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802aa6:	85 db                	test   %ebx,%ebx
  802aa8:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802aad:	0f 44 d8             	cmove  %eax,%ebx
  802ab0:	eb 05                	jmp    802ab7 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802ab2:	e8 14 e6 ff ff       	call   8010cb <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802ab7:	ff 75 14             	pushl  0x14(%ebp)
  802aba:	53                   	push   %ebx
  802abb:	56                   	push   %esi
  802abc:	57                   	push   %edi
  802abd:	e8 b5 e7 ff ff       	call   801277 <sys_ipc_try_send>
  802ac2:	83 c4 10             	add    $0x10,%esp
  802ac5:	85 c0                	test   %eax,%eax
  802ac7:	74 1b                	je     802ae4 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802ac9:	79 e7                	jns    802ab2 <ipc_send+0x1e>
  802acb:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802ace:	74 e2                	je     802ab2 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802ad0:	83 ec 04             	sub    $0x4,%esp
  802ad3:	68 64 35 80 00       	push   $0x803564
  802ad8:	6a 46                	push   $0x46
  802ada:	68 79 35 80 00       	push   $0x803579
  802adf:	e8 bf d9 ff ff       	call   8004a3 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802ae4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802ae7:	5b                   	pop    %ebx
  802ae8:	5e                   	pop    %esi
  802ae9:	5f                   	pop    %edi
  802aea:	5d                   	pop    %ebp
  802aeb:	c3                   	ret    

00802aec <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802aec:	55                   	push   %ebp
  802aed:	89 e5                	mov    %esp,%ebp
  802aef:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802af2:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802af7:	89 c2                	mov    %eax,%edx
  802af9:	c1 e2 07             	shl    $0x7,%edx
  802afc:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802b02:	8b 52 50             	mov    0x50(%edx),%edx
  802b05:	39 ca                	cmp    %ecx,%edx
  802b07:	74 11                	je     802b1a <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802b09:	83 c0 01             	add    $0x1,%eax
  802b0c:	3d 00 04 00 00       	cmp    $0x400,%eax
  802b11:	75 e4                	jne    802af7 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802b13:	b8 00 00 00 00       	mov    $0x0,%eax
  802b18:	eb 0b                	jmp    802b25 <ipc_find_env+0x39>
			return envs[i].env_id;
  802b1a:	c1 e0 07             	shl    $0x7,%eax
  802b1d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802b22:	8b 40 48             	mov    0x48(%eax),%eax
}
  802b25:	5d                   	pop    %ebp
  802b26:	c3                   	ret    

00802b27 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802b27:	55                   	push   %ebp
  802b28:	89 e5                	mov    %esp,%ebp
  802b2a:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b2d:	89 d0                	mov    %edx,%eax
  802b2f:	c1 e8 16             	shr    $0x16,%eax
  802b32:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802b39:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802b3e:	f6 c1 01             	test   $0x1,%cl
  802b41:	74 1d                	je     802b60 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802b43:	c1 ea 0c             	shr    $0xc,%edx
  802b46:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802b4d:	f6 c2 01             	test   $0x1,%dl
  802b50:	74 0e                	je     802b60 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802b52:	c1 ea 0c             	shr    $0xc,%edx
  802b55:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802b5c:	ef 
  802b5d:	0f b7 c0             	movzwl %ax,%eax
}
  802b60:	5d                   	pop    %ebp
  802b61:	c3                   	ret    
  802b62:	66 90                	xchg   %ax,%ax
  802b64:	66 90                	xchg   %ax,%ax
  802b66:	66 90                	xchg   %ax,%ax
  802b68:	66 90                	xchg   %ax,%ax
  802b6a:	66 90                	xchg   %ax,%ax
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
