
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
  80006d:	68 00 27 80 00       	push   $0x802700
  800072:	e8 bc 04 00 00       	call   800533 <cprintf>

	want = 0xf989e;
	if ((x = sum((char*)&data, sizeof data)) != want)
  800077:	83 c4 08             	add    $0x8,%esp
  80007a:	68 70 17 00 00       	push   $0x1770
  80007f:	68 00 30 80 00       	push   $0x803000
  800084:	e8 aa ff ff ff       	call   800033 <sum>
  800089:	83 c4 10             	add    $0x10,%esp
  80008c:	3d 9e 98 0f 00       	cmp    $0xf989e,%eax
  800091:	0f 84 99 00 00 00    	je     800130 <umain+0xd2>
		cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  800097:	83 ec 04             	sub    $0x4,%esp
  80009a:	68 9e 98 0f 00       	push   $0xf989e
  80009f:	50                   	push   %eax
  8000a0:	68 c4 27 80 00       	push   $0x8027c4
  8000a5:	e8 89 04 00 00       	call   800533 <cprintf>
  8000aa:	83 c4 10             	add    $0x10,%esp
			x, want);
	else
		cprintf("init: data seems okay\n");
	if ((x = sum(bss, sizeof bss)) != 0)
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	68 70 17 00 00       	push   $0x1770
  8000b5:	68 20 50 80 00       	push   $0x805020
  8000ba:	e8 74 ff ff ff       	call   800033 <sum>
  8000bf:	83 c4 10             	add    $0x10,%esp
  8000c2:	85 c0                	test   %eax,%eax
  8000c4:	74 7f                	je     800145 <umain+0xe7>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  8000c6:	83 ec 08             	sub    $0x8,%esp
  8000c9:	50                   	push   %eax
  8000ca:	68 00 28 80 00       	push   $0x802800
  8000cf:	e8 5f 04 00 00       	call   800533 <cprintf>
  8000d4:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  8000d7:	83 ec 08             	sub    $0x8,%esp
  8000da:	68 3c 27 80 00       	push   $0x80273c
  8000df:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8000e5:	50                   	push   %eax
  8000e6:	e8 c7 0b 00 00       	call   800cb2 <strcat>
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
  800100:	68 48 27 80 00       	push   $0x802748
  800105:	56                   	push   %esi
  800106:	e8 a7 0b 00 00       	call   800cb2 <strcat>
		strcat(args, argv[i]);
  80010b:	83 c4 08             	add    $0x8,%esp
  80010e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800111:	ff 34 98             	pushl  (%eax,%ebx,4)
  800114:	56                   	push   %esi
  800115:	e8 98 0b 00 00       	call   800cb2 <strcat>
		strcat(args, "'");
  80011a:	83 c4 08             	add    $0x8,%esp
  80011d:	68 49 27 80 00       	push   $0x802749
  800122:	56                   	push   %esi
  800123:	e8 8a 0b 00 00       	call   800cb2 <strcat>
	for (i = 0; i < argc; i++) {
  800128:	83 c3 01             	add    $0x1,%ebx
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	eb c9                	jmp    8000f9 <umain+0x9b>
		cprintf("init: data seems okay\n");
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	68 0f 27 80 00       	push   $0x80270f
  800138:	e8 f6 03 00 00       	call   800533 <cprintf>
  80013d:	83 c4 10             	add    $0x10,%esp
  800140:	e9 68 ff ff ff       	jmp    8000ad <umain+0x4f>
		cprintf("init: bss seems okay\n");
  800145:	83 ec 0c             	sub    $0xc,%esp
  800148:	68 26 27 80 00       	push   $0x802726
  80014d:	e8 e1 03 00 00       	call   800533 <cprintf>
  800152:	83 c4 10             	add    $0x10,%esp
  800155:	eb 80                	jmp    8000d7 <umain+0x79>
	}
	cprintf("%s\n", args);
  800157:	83 ec 08             	sub    $0x8,%esp
  80015a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800160:	50                   	push   %eax
  800161:	68 4c 28 80 00       	push   $0x80284c
  800166:	e8 c8 03 00 00       	call   800533 <cprintf>

	cprintf("init: running sh\n");
  80016b:	c7 04 24 4b 27 80 00 	movl   $0x80274b,(%esp)
  800172:	e8 bc 03 00 00       	call   800533 <cprintf>

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  800177:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80017e:	e8 d9 12 00 00       	call   80145c <close>
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
  800192:	68 76 27 80 00       	push   $0x802776
  800197:	6a 39                	push   $0x39
  800199:	68 6a 27 80 00       	push   $0x80276a
  80019e:	e8 9a 02 00 00       	call   80043d <_panic>
		panic("opencons: %e", r);
  8001a3:	50                   	push   %eax
  8001a4:	68 5d 27 80 00       	push   $0x80275d
  8001a9:	6a 37                	push   $0x37
  8001ab:	68 6a 27 80 00       	push   $0x80276a
  8001b0:	e8 88 02 00 00       	call   80043d <_panic>
	if ((r = dup(0, 1)) < 0)
  8001b5:	83 ec 08             	sub    $0x8,%esp
  8001b8:	6a 01                	push   $0x1
  8001ba:	6a 00                	push   $0x0
  8001bc:	e8 ed 12 00 00       	call   8014ae <dup>
  8001c1:	83 c4 10             	add    $0x10,%esp
  8001c4:	85 c0                	test   %eax,%eax
  8001c6:	79 23                	jns    8001eb <umain+0x18d>
		panic("dup: %e", r);
  8001c8:	50                   	push   %eax
  8001c9:	68 90 27 80 00       	push   $0x802790
  8001ce:	6a 3b                	push   $0x3b
  8001d0:	68 6a 27 80 00       	push   $0x80276a
  8001d5:	e8 63 02 00 00       	call   80043d <_panic>
	while (1) {
		cprintf("init: starting sh\n");
		r = spawnl("/sh", "sh", (char*)0);
		if (r < 0) {
			cprintf("init: spawn sh: %e\n", r);
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	50                   	push   %eax
  8001de:	68 af 27 80 00       	push   $0x8027af
  8001e3:	e8 4b 03 00 00       	call   800533 <cprintf>
			continue;
  8001e8:	83 c4 10             	add    $0x10,%esp
		cprintf("init: starting sh\n");
  8001eb:	83 ec 0c             	sub    $0xc,%esp
  8001ee:	68 98 27 80 00       	push   $0x802798
  8001f3:	e8 3b 03 00 00       	call   800533 <cprintf>
		r = spawnl("/sh", "sh", (char*)0);
  8001f8:	83 c4 0c             	add    $0xc,%esp
  8001fb:	6a 00                	push   $0x0
  8001fd:	68 ac 27 80 00       	push   $0x8027ac
  800202:	68 ab 27 80 00       	push   $0x8027ab
  800207:	e8 4c 1d 00 00       	call   801f58 <spawnl>
		if (r < 0) {
  80020c:	83 c4 10             	add    $0x10,%esp
  80020f:	85 c0                	test   %eax,%eax
  800211:	78 c7                	js     8001da <umain+0x17c>
		}
		wait(r);
  800213:	83 ec 0c             	sub    $0xc,%esp
  800216:	50                   	push   %eax
  800217:	e8 07 21 00 00       	call   802323 <wait>
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
  80022d:	68 2f 28 80 00       	push   $0x80282f
  800232:	ff 75 0c             	pushl  0xc(%ebp)
  800235:	e8 58 0a 00 00       	call   800c92 <strcpy>
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
  800278:	e8 a3 0b 00 00       	call   800e20 <memmove>
		sys_cputs(buf, m);
  80027d:	83 c4 08             	add    $0x8,%esp
  800280:	53                   	push   %ebx
  800281:	57                   	push   %edi
  800282:	e8 41 0d 00 00       	call   800fc8 <sys_cputs>
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
  8002a9:	e8 38 0d 00 00       	call   800fe6 <sys_cgetc>
  8002ae:	85 c0                	test   %eax,%eax
  8002b0:	75 07                	jne    8002b9 <devcons_read+0x21>
		sys_yield();
  8002b2:	e8 ae 0d 00 00       	call   801065 <sys_yield>
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
  8002e5:	e8 de 0c 00 00       	call   800fc8 <sys_cputs>
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
  8002fd:	e8 98 12 00 00       	call   80159a <read>
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
  800325:	e8 05 10 00 00       	call   80132f <fd_lookup>
  80032a:	83 c4 10             	add    $0x10,%esp
  80032d:	85 c0                	test   %eax,%eax
  80032f:	78 11                	js     800342 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  800331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800334:	8b 15 70 47 80 00    	mov    0x804770,%edx
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
  80034e:	e8 8a 0f 00 00       	call   8012dd <fd_alloc>
  800353:	83 c4 10             	add    $0x10,%esp
  800356:	85 c0                	test   %eax,%eax
  800358:	78 3a                	js     800394 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80035a:	83 ec 04             	sub    $0x4,%esp
  80035d:	68 07 04 00 00       	push   $0x407
  800362:	ff 75 f4             	pushl  -0xc(%ebp)
  800365:	6a 00                	push   $0x0
  800367:	e8 18 0d 00 00       	call   801084 <sys_page_alloc>
  80036c:	83 c4 10             	add    $0x10,%esp
  80036f:	85 c0                	test   %eax,%eax
  800371:	78 21                	js     800394 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  800373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800376:	8b 15 70 47 80 00    	mov    0x804770,%edx
  80037c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80037e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800381:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800388:	83 ec 0c             	sub    $0xc,%esp
  80038b:	50                   	push   %eax
  80038c:	e8 25 0f 00 00       	call   8012b6 <fd2num>
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
  80039f:	c7 05 90 67 80 00 00 	movl   $0x0,0x806790
  8003a6:	00 00 00 
	envid_t find = sys_getenvid();
  8003a9:	e8 98 0c 00 00       	call   801046 <sys_getenvid>
  8003ae:	8b 1d 90 67 80 00    	mov    0x806790,%ebx
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
  8003f7:	89 1d 90 67 80 00    	mov    %ebx,0x806790
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800401:	7e 0a                	jle    80040d <libmain+0x77>
		binaryname = argv[0];
  800403:	8b 45 0c             	mov    0xc(%ebp),%eax
  800406:	8b 00                	mov    (%eax),%eax
  800408:	a3 8c 47 80 00       	mov    %eax,0x80478c

	// call user main routine
	umain(argc, argv);
  80040d:	83 ec 08             	sub    $0x8,%esp
  800410:	ff 75 0c             	pushl  0xc(%ebp)
  800413:	ff 75 08             	pushl  0x8(%ebp)
  800416:	e8 43 fc ff ff       	call   80005e <umain>

	// exit gracefully
	exit();
  80041b:	e8 0b 00 00 00       	call   80042b <exit>
}
  800420:	83 c4 10             	add    $0x10,%esp
  800423:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800426:	5b                   	pop    %ebx
  800427:	5e                   	pop    %esi
  800428:	5f                   	pop    %edi
  800429:	5d                   	pop    %ebp
  80042a:	c3                   	ret    

0080042b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80042b:	55                   	push   %ebp
  80042c:	89 e5                	mov    %esp,%ebp
  80042e:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800431:	6a 00                	push   $0x0
  800433:	e8 cd 0b 00 00       	call   801005 <sys_env_destroy>
}
  800438:	83 c4 10             	add    $0x10,%esp
  80043b:	c9                   	leave  
  80043c:	c3                   	ret    

0080043d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80043d:	55                   	push   %ebp
  80043e:	89 e5                	mov    %esp,%ebp
  800440:	56                   	push   %esi
  800441:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800442:	a1 90 67 80 00       	mov    0x806790,%eax
  800447:	8b 40 48             	mov    0x48(%eax),%eax
  80044a:	83 ec 04             	sub    $0x4,%esp
  80044d:	68 74 28 80 00       	push   $0x802874
  800452:	50                   	push   %eax
  800453:	68 45 28 80 00       	push   $0x802845
  800458:	e8 d6 00 00 00       	call   800533 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80045d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800460:	8b 35 8c 47 80 00    	mov    0x80478c,%esi
  800466:	e8 db 0b 00 00       	call   801046 <sys_getenvid>
  80046b:	83 c4 04             	add    $0x4,%esp
  80046e:	ff 75 0c             	pushl  0xc(%ebp)
  800471:	ff 75 08             	pushl  0x8(%ebp)
  800474:	56                   	push   %esi
  800475:	50                   	push   %eax
  800476:	68 50 28 80 00       	push   $0x802850
  80047b:	e8 b3 00 00 00       	call   800533 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800480:	83 c4 18             	add    $0x18,%esp
  800483:	53                   	push   %ebx
  800484:	ff 75 10             	pushl  0x10(%ebp)
  800487:	e8 56 00 00 00       	call   8004e2 <vcprintf>
	cprintf("\n");
  80048c:	c7 04 24 f0 2d 80 00 	movl   $0x802df0,(%esp)
  800493:	e8 9b 00 00 00       	call   800533 <cprintf>
  800498:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80049b:	cc                   	int3   
  80049c:	eb fd                	jmp    80049b <_panic+0x5e>

0080049e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80049e:	55                   	push   %ebp
  80049f:	89 e5                	mov    %esp,%ebp
  8004a1:	53                   	push   %ebx
  8004a2:	83 ec 04             	sub    $0x4,%esp
  8004a5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8004a8:	8b 13                	mov    (%ebx),%edx
  8004aa:	8d 42 01             	lea    0x1(%edx),%eax
  8004ad:	89 03                	mov    %eax,(%ebx)
  8004af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004b2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8004b6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004bb:	74 09                	je     8004c6 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8004bd:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8004c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004c4:	c9                   	leave  
  8004c5:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8004c6:	83 ec 08             	sub    $0x8,%esp
  8004c9:	68 ff 00 00 00       	push   $0xff
  8004ce:	8d 43 08             	lea    0x8(%ebx),%eax
  8004d1:	50                   	push   %eax
  8004d2:	e8 f1 0a 00 00       	call   800fc8 <sys_cputs>
		b->idx = 0;
  8004d7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8004dd:	83 c4 10             	add    $0x10,%esp
  8004e0:	eb db                	jmp    8004bd <putch+0x1f>

008004e2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8004e2:	55                   	push   %ebp
  8004e3:	89 e5                	mov    %esp,%ebp
  8004e5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004eb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004f2:	00 00 00 
	b.cnt = 0;
  8004f5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004fc:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8004ff:	ff 75 0c             	pushl  0xc(%ebp)
  800502:	ff 75 08             	pushl  0x8(%ebp)
  800505:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80050b:	50                   	push   %eax
  80050c:	68 9e 04 80 00       	push   $0x80049e
  800511:	e8 4a 01 00 00       	call   800660 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800516:	83 c4 08             	add    $0x8,%esp
  800519:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80051f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800525:	50                   	push   %eax
  800526:	e8 9d 0a 00 00       	call   800fc8 <sys_cputs>

	return b.cnt;
}
  80052b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800531:	c9                   	leave  
  800532:	c3                   	ret    

00800533 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800533:	55                   	push   %ebp
  800534:	89 e5                	mov    %esp,%ebp
  800536:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800539:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80053c:	50                   	push   %eax
  80053d:	ff 75 08             	pushl  0x8(%ebp)
  800540:	e8 9d ff ff ff       	call   8004e2 <vcprintf>
	va_end(ap);

	return cnt;
}
  800545:	c9                   	leave  
  800546:	c3                   	ret    

00800547 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800547:	55                   	push   %ebp
  800548:	89 e5                	mov    %esp,%ebp
  80054a:	57                   	push   %edi
  80054b:	56                   	push   %esi
  80054c:	53                   	push   %ebx
  80054d:	83 ec 1c             	sub    $0x1c,%esp
  800550:	89 c6                	mov    %eax,%esi
  800552:	89 d7                	mov    %edx,%edi
  800554:	8b 45 08             	mov    0x8(%ebp),%eax
  800557:	8b 55 0c             	mov    0xc(%ebp),%edx
  80055a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80055d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800560:	8b 45 10             	mov    0x10(%ebp),%eax
  800563:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800566:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80056a:	74 2c                	je     800598 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80056c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80056f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800576:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800579:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80057c:	39 c2                	cmp    %eax,%edx
  80057e:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800581:	73 43                	jae    8005c6 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800583:	83 eb 01             	sub    $0x1,%ebx
  800586:	85 db                	test   %ebx,%ebx
  800588:	7e 6c                	jle    8005f6 <printnum+0xaf>
				putch(padc, putdat);
  80058a:	83 ec 08             	sub    $0x8,%esp
  80058d:	57                   	push   %edi
  80058e:	ff 75 18             	pushl  0x18(%ebp)
  800591:	ff d6                	call   *%esi
  800593:	83 c4 10             	add    $0x10,%esp
  800596:	eb eb                	jmp    800583 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800598:	83 ec 0c             	sub    $0xc,%esp
  80059b:	6a 20                	push   $0x20
  80059d:	6a 00                	push   $0x0
  80059f:	50                   	push   %eax
  8005a0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005a3:	ff 75 e0             	pushl  -0x20(%ebp)
  8005a6:	89 fa                	mov    %edi,%edx
  8005a8:	89 f0                	mov    %esi,%eax
  8005aa:	e8 98 ff ff ff       	call   800547 <printnum>
		while (--width > 0)
  8005af:	83 c4 20             	add    $0x20,%esp
  8005b2:	83 eb 01             	sub    $0x1,%ebx
  8005b5:	85 db                	test   %ebx,%ebx
  8005b7:	7e 65                	jle    80061e <printnum+0xd7>
			putch(padc, putdat);
  8005b9:	83 ec 08             	sub    $0x8,%esp
  8005bc:	57                   	push   %edi
  8005bd:	6a 20                	push   $0x20
  8005bf:	ff d6                	call   *%esi
  8005c1:	83 c4 10             	add    $0x10,%esp
  8005c4:	eb ec                	jmp    8005b2 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8005c6:	83 ec 0c             	sub    $0xc,%esp
  8005c9:	ff 75 18             	pushl  0x18(%ebp)
  8005cc:	83 eb 01             	sub    $0x1,%ebx
  8005cf:	53                   	push   %ebx
  8005d0:	50                   	push   %eax
  8005d1:	83 ec 08             	sub    $0x8,%esp
  8005d4:	ff 75 dc             	pushl  -0x24(%ebp)
  8005d7:	ff 75 d8             	pushl  -0x28(%ebp)
  8005da:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005dd:	ff 75 e0             	pushl  -0x20(%ebp)
  8005e0:	e8 cb 1e 00 00       	call   8024b0 <__udivdi3>
  8005e5:	83 c4 18             	add    $0x18,%esp
  8005e8:	52                   	push   %edx
  8005e9:	50                   	push   %eax
  8005ea:	89 fa                	mov    %edi,%edx
  8005ec:	89 f0                	mov    %esi,%eax
  8005ee:	e8 54 ff ff ff       	call   800547 <printnum>
  8005f3:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8005f6:	83 ec 08             	sub    $0x8,%esp
  8005f9:	57                   	push   %edi
  8005fa:	83 ec 04             	sub    $0x4,%esp
  8005fd:	ff 75 dc             	pushl  -0x24(%ebp)
  800600:	ff 75 d8             	pushl  -0x28(%ebp)
  800603:	ff 75 e4             	pushl  -0x1c(%ebp)
  800606:	ff 75 e0             	pushl  -0x20(%ebp)
  800609:	e8 b2 1f 00 00       	call   8025c0 <__umoddi3>
  80060e:	83 c4 14             	add    $0x14,%esp
  800611:	0f be 80 7b 28 80 00 	movsbl 0x80287b(%eax),%eax
  800618:	50                   	push   %eax
  800619:	ff d6                	call   *%esi
  80061b:	83 c4 10             	add    $0x10,%esp
	}
}
  80061e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800621:	5b                   	pop    %ebx
  800622:	5e                   	pop    %esi
  800623:	5f                   	pop    %edi
  800624:	5d                   	pop    %ebp
  800625:	c3                   	ret    

00800626 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800626:	55                   	push   %ebp
  800627:	89 e5                	mov    %esp,%ebp
  800629:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80062c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800630:	8b 10                	mov    (%eax),%edx
  800632:	3b 50 04             	cmp    0x4(%eax),%edx
  800635:	73 0a                	jae    800641 <sprintputch+0x1b>
		*b->buf++ = ch;
  800637:	8d 4a 01             	lea    0x1(%edx),%ecx
  80063a:	89 08                	mov    %ecx,(%eax)
  80063c:	8b 45 08             	mov    0x8(%ebp),%eax
  80063f:	88 02                	mov    %al,(%edx)
}
  800641:	5d                   	pop    %ebp
  800642:	c3                   	ret    

00800643 <printfmt>:
{
  800643:	55                   	push   %ebp
  800644:	89 e5                	mov    %esp,%ebp
  800646:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800649:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80064c:	50                   	push   %eax
  80064d:	ff 75 10             	pushl  0x10(%ebp)
  800650:	ff 75 0c             	pushl  0xc(%ebp)
  800653:	ff 75 08             	pushl  0x8(%ebp)
  800656:	e8 05 00 00 00       	call   800660 <vprintfmt>
}
  80065b:	83 c4 10             	add    $0x10,%esp
  80065e:	c9                   	leave  
  80065f:	c3                   	ret    

00800660 <vprintfmt>:
{
  800660:	55                   	push   %ebp
  800661:	89 e5                	mov    %esp,%ebp
  800663:	57                   	push   %edi
  800664:	56                   	push   %esi
  800665:	53                   	push   %ebx
  800666:	83 ec 3c             	sub    $0x3c,%esp
  800669:	8b 75 08             	mov    0x8(%ebp),%esi
  80066c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80066f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800672:	e9 32 04 00 00       	jmp    800aa9 <vprintfmt+0x449>
		padc = ' ';
  800677:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80067b:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800682:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800689:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800690:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800697:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80069e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8006a3:	8d 47 01             	lea    0x1(%edi),%eax
  8006a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006a9:	0f b6 17             	movzbl (%edi),%edx
  8006ac:	8d 42 dd             	lea    -0x23(%edx),%eax
  8006af:	3c 55                	cmp    $0x55,%al
  8006b1:	0f 87 12 05 00 00    	ja     800bc9 <vprintfmt+0x569>
  8006b7:	0f b6 c0             	movzbl %al,%eax
  8006ba:	ff 24 85 60 2a 80 00 	jmp    *0x802a60(,%eax,4)
  8006c1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8006c4:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8006c8:	eb d9                	jmp    8006a3 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8006ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8006cd:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8006d1:	eb d0                	jmp    8006a3 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8006d3:	0f b6 d2             	movzbl %dl,%edx
  8006d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8006d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8006de:	89 75 08             	mov    %esi,0x8(%ebp)
  8006e1:	eb 03                	jmp    8006e6 <vprintfmt+0x86>
  8006e3:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8006e6:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8006e9:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8006ed:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8006f0:	8d 72 d0             	lea    -0x30(%edx),%esi
  8006f3:	83 fe 09             	cmp    $0x9,%esi
  8006f6:	76 eb                	jbe    8006e3 <vprintfmt+0x83>
  8006f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8006fe:	eb 14                	jmp    800714 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800700:	8b 45 14             	mov    0x14(%ebp),%eax
  800703:	8b 00                	mov    (%eax),%eax
  800705:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800708:	8b 45 14             	mov    0x14(%ebp),%eax
  80070b:	8d 40 04             	lea    0x4(%eax),%eax
  80070e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800711:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800714:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800718:	79 89                	jns    8006a3 <vprintfmt+0x43>
				width = precision, precision = -1;
  80071a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80071d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800720:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800727:	e9 77 ff ff ff       	jmp    8006a3 <vprintfmt+0x43>
  80072c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80072f:	85 c0                	test   %eax,%eax
  800731:	0f 48 c1             	cmovs  %ecx,%eax
  800734:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800737:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80073a:	e9 64 ff ff ff       	jmp    8006a3 <vprintfmt+0x43>
  80073f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800742:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800749:	e9 55 ff ff ff       	jmp    8006a3 <vprintfmt+0x43>
			lflag++;
  80074e:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800752:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800755:	e9 49 ff ff ff       	jmp    8006a3 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80075a:	8b 45 14             	mov    0x14(%ebp),%eax
  80075d:	8d 78 04             	lea    0x4(%eax),%edi
  800760:	83 ec 08             	sub    $0x8,%esp
  800763:	53                   	push   %ebx
  800764:	ff 30                	pushl  (%eax)
  800766:	ff d6                	call   *%esi
			break;
  800768:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80076b:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80076e:	e9 33 03 00 00       	jmp    800aa6 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800773:	8b 45 14             	mov    0x14(%ebp),%eax
  800776:	8d 78 04             	lea    0x4(%eax),%edi
  800779:	8b 00                	mov    (%eax),%eax
  80077b:	99                   	cltd   
  80077c:	31 d0                	xor    %edx,%eax
  80077e:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800780:	83 f8 0f             	cmp    $0xf,%eax
  800783:	7f 23                	jg     8007a8 <vprintfmt+0x148>
  800785:	8b 14 85 c0 2b 80 00 	mov    0x802bc0(,%eax,4),%edx
  80078c:	85 d2                	test   %edx,%edx
  80078e:	74 18                	je     8007a8 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800790:	52                   	push   %edx
  800791:	68 fa 2c 80 00       	push   $0x802cfa
  800796:	53                   	push   %ebx
  800797:	56                   	push   %esi
  800798:	e8 a6 fe ff ff       	call   800643 <printfmt>
  80079d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8007a0:	89 7d 14             	mov    %edi,0x14(%ebp)
  8007a3:	e9 fe 02 00 00       	jmp    800aa6 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8007a8:	50                   	push   %eax
  8007a9:	68 93 28 80 00       	push   $0x802893
  8007ae:	53                   	push   %ebx
  8007af:	56                   	push   %esi
  8007b0:	e8 8e fe ff ff       	call   800643 <printfmt>
  8007b5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8007b8:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8007bb:	e9 e6 02 00 00       	jmp    800aa6 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8007c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c3:	83 c0 04             	add    $0x4,%eax
  8007c6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8007ce:	85 c9                	test   %ecx,%ecx
  8007d0:	b8 8c 28 80 00       	mov    $0x80288c,%eax
  8007d5:	0f 45 c1             	cmovne %ecx,%eax
  8007d8:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8007db:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007df:	7e 06                	jle    8007e7 <vprintfmt+0x187>
  8007e1:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8007e5:	75 0d                	jne    8007f4 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007e7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8007ea:	89 c7                	mov    %eax,%edi
  8007ec:	03 45 e0             	add    -0x20(%ebp),%eax
  8007ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007f2:	eb 53                	jmp    800847 <vprintfmt+0x1e7>
  8007f4:	83 ec 08             	sub    $0x8,%esp
  8007f7:	ff 75 d8             	pushl  -0x28(%ebp)
  8007fa:	50                   	push   %eax
  8007fb:	e8 71 04 00 00       	call   800c71 <strnlen>
  800800:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800803:	29 c1                	sub    %eax,%ecx
  800805:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800808:	83 c4 10             	add    $0x10,%esp
  80080b:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80080d:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800811:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800814:	eb 0f                	jmp    800825 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800816:	83 ec 08             	sub    $0x8,%esp
  800819:	53                   	push   %ebx
  80081a:	ff 75 e0             	pushl  -0x20(%ebp)
  80081d:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80081f:	83 ef 01             	sub    $0x1,%edi
  800822:	83 c4 10             	add    $0x10,%esp
  800825:	85 ff                	test   %edi,%edi
  800827:	7f ed                	jg     800816 <vprintfmt+0x1b6>
  800829:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80082c:	85 c9                	test   %ecx,%ecx
  80082e:	b8 00 00 00 00       	mov    $0x0,%eax
  800833:	0f 49 c1             	cmovns %ecx,%eax
  800836:	29 c1                	sub    %eax,%ecx
  800838:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80083b:	eb aa                	jmp    8007e7 <vprintfmt+0x187>
					putch(ch, putdat);
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	53                   	push   %ebx
  800841:	52                   	push   %edx
  800842:	ff d6                	call   *%esi
  800844:	83 c4 10             	add    $0x10,%esp
  800847:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80084a:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80084c:	83 c7 01             	add    $0x1,%edi
  80084f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800853:	0f be d0             	movsbl %al,%edx
  800856:	85 d2                	test   %edx,%edx
  800858:	74 4b                	je     8008a5 <vprintfmt+0x245>
  80085a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80085e:	78 06                	js     800866 <vprintfmt+0x206>
  800860:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800864:	78 1e                	js     800884 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800866:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80086a:	74 d1                	je     80083d <vprintfmt+0x1dd>
  80086c:	0f be c0             	movsbl %al,%eax
  80086f:	83 e8 20             	sub    $0x20,%eax
  800872:	83 f8 5e             	cmp    $0x5e,%eax
  800875:	76 c6                	jbe    80083d <vprintfmt+0x1dd>
					putch('?', putdat);
  800877:	83 ec 08             	sub    $0x8,%esp
  80087a:	53                   	push   %ebx
  80087b:	6a 3f                	push   $0x3f
  80087d:	ff d6                	call   *%esi
  80087f:	83 c4 10             	add    $0x10,%esp
  800882:	eb c3                	jmp    800847 <vprintfmt+0x1e7>
  800884:	89 cf                	mov    %ecx,%edi
  800886:	eb 0e                	jmp    800896 <vprintfmt+0x236>
				putch(' ', putdat);
  800888:	83 ec 08             	sub    $0x8,%esp
  80088b:	53                   	push   %ebx
  80088c:	6a 20                	push   $0x20
  80088e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800890:	83 ef 01             	sub    $0x1,%edi
  800893:	83 c4 10             	add    $0x10,%esp
  800896:	85 ff                	test   %edi,%edi
  800898:	7f ee                	jg     800888 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80089a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80089d:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a0:	e9 01 02 00 00       	jmp    800aa6 <vprintfmt+0x446>
  8008a5:	89 cf                	mov    %ecx,%edi
  8008a7:	eb ed                	jmp    800896 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8008a9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8008ac:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8008b3:	e9 eb fd ff ff       	jmp    8006a3 <vprintfmt+0x43>
	if (lflag >= 2)
  8008b8:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8008bc:	7f 21                	jg     8008df <vprintfmt+0x27f>
	else if (lflag)
  8008be:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008c2:	74 68                	je     80092c <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8008c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c7:	8b 00                	mov    (%eax),%eax
  8008c9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008cc:	89 c1                	mov    %eax,%ecx
  8008ce:	c1 f9 1f             	sar    $0x1f,%ecx
  8008d1:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8008d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d7:	8d 40 04             	lea    0x4(%eax),%eax
  8008da:	89 45 14             	mov    %eax,0x14(%ebp)
  8008dd:	eb 17                	jmp    8008f6 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8008df:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e2:	8b 50 04             	mov    0x4(%eax),%edx
  8008e5:	8b 00                	mov    (%eax),%eax
  8008e7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008ea:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8008ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f0:	8d 40 08             	lea    0x8(%eax),%eax
  8008f3:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8008f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008f9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8008fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008ff:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800902:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800906:	78 3f                	js     800947 <vprintfmt+0x2e7>
			base = 10;
  800908:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80090d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800911:	0f 84 71 01 00 00    	je     800a88 <vprintfmt+0x428>
				putch('+', putdat);
  800917:	83 ec 08             	sub    $0x8,%esp
  80091a:	53                   	push   %ebx
  80091b:	6a 2b                	push   $0x2b
  80091d:	ff d6                	call   *%esi
  80091f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800922:	b8 0a 00 00 00       	mov    $0xa,%eax
  800927:	e9 5c 01 00 00       	jmp    800a88 <vprintfmt+0x428>
		return va_arg(*ap, int);
  80092c:	8b 45 14             	mov    0x14(%ebp),%eax
  80092f:	8b 00                	mov    (%eax),%eax
  800931:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800934:	89 c1                	mov    %eax,%ecx
  800936:	c1 f9 1f             	sar    $0x1f,%ecx
  800939:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80093c:	8b 45 14             	mov    0x14(%ebp),%eax
  80093f:	8d 40 04             	lea    0x4(%eax),%eax
  800942:	89 45 14             	mov    %eax,0x14(%ebp)
  800945:	eb af                	jmp    8008f6 <vprintfmt+0x296>
				putch('-', putdat);
  800947:	83 ec 08             	sub    $0x8,%esp
  80094a:	53                   	push   %ebx
  80094b:	6a 2d                	push   $0x2d
  80094d:	ff d6                	call   *%esi
				num = -(long long) num;
  80094f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800952:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800955:	f7 d8                	neg    %eax
  800957:	83 d2 00             	adc    $0x0,%edx
  80095a:	f7 da                	neg    %edx
  80095c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80095f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800962:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800965:	b8 0a 00 00 00       	mov    $0xa,%eax
  80096a:	e9 19 01 00 00       	jmp    800a88 <vprintfmt+0x428>
	if (lflag >= 2)
  80096f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800973:	7f 29                	jg     80099e <vprintfmt+0x33e>
	else if (lflag)
  800975:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800979:	74 44                	je     8009bf <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80097b:	8b 45 14             	mov    0x14(%ebp),%eax
  80097e:	8b 00                	mov    (%eax),%eax
  800980:	ba 00 00 00 00       	mov    $0x0,%edx
  800985:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800988:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80098b:	8b 45 14             	mov    0x14(%ebp),%eax
  80098e:	8d 40 04             	lea    0x4(%eax),%eax
  800991:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800994:	b8 0a 00 00 00       	mov    $0xa,%eax
  800999:	e9 ea 00 00 00       	jmp    800a88 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80099e:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a1:	8b 50 04             	mov    0x4(%eax),%edx
  8009a4:	8b 00                	mov    (%eax),%eax
  8009a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009a9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8009af:	8d 40 08             	lea    0x8(%eax),%eax
  8009b2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009b5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009ba:	e9 c9 00 00 00       	jmp    800a88 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8009bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c2:	8b 00                	mov    (%eax),%eax
  8009c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009cc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d2:	8d 40 04             	lea    0x4(%eax),%eax
  8009d5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009d8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009dd:	e9 a6 00 00 00       	jmp    800a88 <vprintfmt+0x428>
			putch('0', putdat);
  8009e2:	83 ec 08             	sub    $0x8,%esp
  8009e5:	53                   	push   %ebx
  8009e6:	6a 30                	push   $0x30
  8009e8:	ff d6                	call   *%esi
	if (lflag >= 2)
  8009ea:	83 c4 10             	add    $0x10,%esp
  8009ed:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8009f1:	7f 26                	jg     800a19 <vprintfmt+0x3b9>
	else if (lflag)
  8009f3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8009f7:	74 3e                	je     800a37 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8009f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fc:	8b 00                	mov    (%eax),%eax
  8009fe:	ba 00 00 00 00       	mov    $0x0,%edx
  800a03:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a06:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a09:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0c:	8d 40 04             	lea    0x4(%eax),%eax
  800a0f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a12:	b8 08 00 00 00       	mov    $0x8,%eax
  800a17:	eb 6f                	jmp    800a88 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800a19:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1c:	8b 50 04             	mov    0x4(%eax),%edx
  800a1f:	8b 00                	mov    (%eax),%eax
  800a21:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a24:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a27:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2a:	8d 40 08             	lea    0x8(%eax),%eax
  800a2d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a30:	b8 08 00 00 00       	mov    $0x8,%eax
  800a35:	eb 51                	jmp    800a88 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800a37:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3a:	8b 00                	mov    (%eax),%eax
  800a3c:	ba 00 00 00 00       	mov    $0x0,%edx
  800a41:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a44:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a47:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4a:	8d 40 04             	lea    0x4(%eax),%eax
  800a4d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a50:	b8 08 00 00 00       	mov    $0x8,%eax
  800a55:	eb 31                	jmp    800a88 <vprintfmt+0x428>
			putch('0', putdat);
  800a57:	83 ec 08             	sub    $0x8,%esp
  800a5a:	53                   	push   %ebx
  800a5b:	6a 30                	push   $0x30
  800a5d:	ff d6                	call   *%esi
			putch('x', putdat);
  800a5f:	83 c4 08             	add    $0x8,%esp
  800a62:	53                   	push   %ebx
  800a63:	6a 78                	push   $0x78
  800a65:	ff d6                	call   *%esi
			num = (unsigned long long)
  800a67:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6a:	8b 00                	mov    (%eax),%eax
  800a6c:	ba 00 00 00 00       	mov    $0x0,%edx
  800a71:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a74:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800a77:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a7a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7d:	8d 40 04             	lea    0x4(%eax),%eax
  800a80:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a83:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800a88:	83 ec 0c             	sub    $0xc,%esp
  800a8b:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800a8f:	52                   	push   %edx
  800a90:	ff 75 e0             	pushl  -0x20(%ebp)
  800a93:	50                   	push   %eax
  800a94:	ff 75 dc             	pushl  -0x24(%ebp)
  800a97:	ff 75 d8             	pushl  -0x28(%ebp)
  800a9a:	89 da                	mov    %ebx,%edx
  800a9c:	89 f0                	mov    %esi,%eax
  800a9e:	e8 a4 fa ff ff       	call   800547 <printnum>
			break;
  800aa3:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800aa6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800aa9:	83 c7 01             	add    $0x1,%edi
  800aac:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800ab0:	83 f8 25             	cmp    $0x25,%eax
  800ab3:	0f 84 be fb ff ff    	je     800677 <vprintfmt+0x17>
			if (ch == '\0')
  800ab9:	85 c0                	test   %eax,%eax
  800abb:	0f 84 28 01 00 00    	je     800be9 <vprintfmt+0x589>
			putch(ch, putdat);
  800ac1:	83 ec 08             	sub    $0x8,%esp
  800ac4:	53                   	push   %ebx
  800ac5:	50                   	push   %eax
  800ac6:	ff d6                	call   *%esi
  800ac8:	83 c4 10             	add    $0x10,%esp
  800acb:	eb dc                	jmp    800aa9 <vprintfmt+0x449>
	if (lflag >= 2)
  800acd:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800ad1:	7f 26                	jg     800af9 <vprintfmt+0x499>
	else if (lflag)
  800ad3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800ad7:	74 41                	je     800b1a <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800ad9:	8b 45 14             	mov    0x14(%ebp),%eax
  800adc:	8b 00                	mov    (%eax),%eax
  800ade:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ae6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ae9:	8b 45 14             	mov    0x14(%ebp),%eax
  800aec:	8d 40 04             	lea    0x4(%eax),%eax
  800aef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800af2:	b8 10 00 00 00       	mov    $0x10,%eax
  800af7:	eb 8f                	jmp    800a88 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800af9:	8b 45 14             	mov    0x14(%ebp),%eax
  800afc:	8b 50 04             	mov    0x4(%eax),%edx
  800aff:	8b 00                	mov    (%eax),%eax
  800b01:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b04:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b07:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0a:	8d 40 08             	lea    0x8(%eax),%eax
  800b0d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b10:	b8 10 00 00 00       	mov    $0x10,%eax
  800b15:	e9 6e ff ff ff       	jmp    800a88 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800b1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1d:	8b 00                	mov    (%eax),%eax
  800b1f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b24:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b27:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b2a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2d:	8d 40 04             	lea    0x4(%eax),%eax
  800b30:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b33:	b8 10 00 00 00       	mov    $0x10,%eax
  800b38:	e9 4b ff ff ff       	jmp    800a88 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800b3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b40:	83 c0 04             	add    $0x4,%eax
  800b43:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b46:	8b 45 14             	mov    0x14(%ebp),%eax
  800b49:	8b 00                	mov    (%eax),%eax
  800b4b:	85 c0                	test   %eax,%eax
  800b4d:	74 14                	je     800b63 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800b4f:	8b 13                	mov    (%ebx),%edx
  800b51:	83 fa 7f             	cmp    $0x7f,%edx
  800b54:	7f 37                	jg     800b8d <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800b56:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800b58:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b5b:	89 45 14             	mov    %eax,0x14(%ebp)
  800b5e:	e9 43 ff ff ff       	jmp    800aa6 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800b63:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b68:	bf b1 29 80 00       	mov    $0x8029b1,%edi
							putch(ch, putdat);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	53                   	push   %ebx
  800b71:	50                   	push   %eax
  800b72:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800b74:	83 c7 01             	add    $0x1,%edi
  800b77:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800b7b:	83 c4 10             	add    $0x10,%esp
  800b7e:	85 c0                	test   %eax,%eax
  800b80:	75 eb                	jne    800b6d <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800b82:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b85:	89 45 14             	mov    %eax,0x14(%ebp)
  800b88:	e9 19 ff ff ff       	jmp    800aa6 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800b8d:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800b8f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b94:	bf e9 29 80 00       	mov    $0x8029e9,%edi
							putch(ch, putdat);
  800b99:	83 ec 08             	sub    $0x8,%esp
  800b9c:	53                   	push   %ebx
  800b9d:	50                   	push   %eax
  800b9e:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800ba0:	83 c7 01             	add    $0x1,%edi
  800ba3:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800ba7:	83 c4 10             	add    $0x10,%esp
  800baa:	85 c0                	test   %eax,%eax
  800bac:	75 eb                	jne    800b99 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800bae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800bb1:	89 45 14             	mov    %eax,0x14(%ebp)
  800bb4:	e9 ed fe ff ff       	jmp    800aa6 <vprintfmt+0x446>
			putch(ch, putdat);
  800bb9:	83 ec 08             	sub    $0x8,%esp
  800bbc:	53                   	push   %ebx
  800bbd:	6a 25                	push   $0x25
  800bbf:	ff d6                	call   *%esi
			break;
  800bc1:	83 c4 10             	add    $0x10,%esp
  800bc4:	e9 dd fe ff ff       	jmp    800aa6 <vprintfmt+0x446>
			putch('%', putdat);
  800bc9:	83 ec 08             	sub    $0x8,%esp
  800bcc:	53                   	push   %ebx
  800bcd:	6a 25                	push   $0x25
  800bcf:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bd1:	83 c4 10             	add    $0x10,%esp
  800bd4:	89 f8                	mov    %edi,%eax
  800bd6:	eb 03                	jmp    800bdb <vprintfmt+0x57b>
  800bd8:	83 e8 01             	sub    $0x1,%eax
  800bdb:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800bdf:	75 f7                	jne    800bd8 <vprintfmt+0x578>
  800be1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800be4:	e9 bd fe ff ff       	jmp    800aa6 <vprintfmt+0x446>
}
  800be9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bec:	5b                   	pop    %ebx
  800bed:	5e                   	pop    %esi
  800bee:	5f                   	pop    %edi
  800bef:	5d                   	pop    %ebp
  800bf0:	c3                   	ret    

00800bf1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bf1:	55                   	push   %ebp
  800bf2:	89 e5                	mov    %esp,%ebp
  800bf4:	83 ec 18             	sub    $0x18,%esp
  800bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfa:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bfd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c00:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800c04:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800c07:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c0e:	85 c0                	test   %eax,%eax
  800c10:	74 26                	je     800c38 <vsnprintf+0x47>
  800c12:	85 d2                	test   %edx,%edx
  800c14:	7e 22                	jle    800c38 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c16:	ff 75 14             	pushl  0x14(%ebp)
  800c19:	ff 75 10             	pushl  0x10(%ebp)
  800c1c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c1f:	50                   	push   %eax
  800c20:	68 26 06 80 00       	push   $0x800626
  800c25:	e8 36 fa ff ff       	call   800660 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c2d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c33:	83 c4 10             	add    $0x10,%esp
}
  800c36:	c9                   	leave  
  800c37:	c3                   	ret    
		return -E_INVAL;
  800c38:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c3d:	eb f7                	jmp    800c36 <vsnprintf+0x45>

00800c3f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c3f:	55                   	push   %ebp
  800c40:	89 e5                	mov    %esp,%ebp
  800c42:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c45:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800c48:	50                   	push   %eax
  800c49:	ff 75 10             	pushl  0x10(%ebp)
  800c4c:	ff 75 0c             	pushl  0xc(%ebp)
  800c4f:	ff 75 08             	pushl  0x8(%ebp)
  800c52:	e8 9a ff ff ff       	call   800bf1 <vsnprintf>
	va_end(ap);

	return rc;
}
  800c57:	c9                   	leave  
  800c58:	c3                   	ret    

00800c59 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800c59:	55                   	push   %ebp
  800c5a:	89 e5                	mov    %esp,%ebp
  800c5c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800c5f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c64:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800c68:	74 05                	je     800c6f <strlen+0x16>
		n++;
  800c6a:	83 c0 01             	add    $0x1,%eax
  800c6d:	eb f5                	jmp    800c64 <strlen+0xb>
	return n;
}
  800c6f:	5d                   	pop    %ebp
  800c70:	c3                   	ret    

00800c71 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c71:	55                   	push   %ebp
  800c72:	89 e5                	mov    %esp,%ebp
  800c74:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c77:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c7a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c7f:	39 c2                	cmp    %eax,%edx
  800c81:	74 0d                	je     800c90 <strnlen+0x1f>
  800c83:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800c87:	74 05                	je     800c8e <strnlen+0x1d>
		n++;
  800c89:	83 c2 01             	add    $0x1,%edx
  800c8c:	eb f1                	jmp    800c7f <strnlen+0xe>
  800c8e:	89 d0                	mov    %edx,%eax
	return n;
}
  800c90:	5d                   	pop    %ebp
  800c91:	c3                   	ret    

00800c92 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c92:	55                   	push   %ebp
  800c93:	89 e5                	mov    %esp,%ebp
  800c95:	53                   	push   %ebx
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c9c:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca1:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800ca5:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800ca8:	83 c2 01             	add    $0x1,%edx
  800cab:	84 c9                	test   %cl,%cl
  800cad:	75 f2                	jne    800ca1 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800caf:	5b                   	pop    %ebx
  800cb0:	5d                   	pop    %ebp
  800cb1:	c3                   	ret    

00800cb2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800cb2:	55                   	push   %ebp
  800cb3:	89 e5                	mov    %esp,%ebp
  800cb5:	53                   	push   %ebx
  800cb6:	83 ec 10             	sub    $0x10,%esp
  800cb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800cbc:	53                   	push   %ebx
  800cbd:	e8 97 ff ff ff       	call   800c59 <strlen>
  800cc2:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800cc5:	ff 75 0c             	pushl  0xc(%ebp)
  800cc8:	01 d8                	add    %ebx,%eax
  800cca:	50                   	push   %eax
  800ccb:	e8 c2 ff ff ff       	call   800c92 <strcpy>
	return dst;
}
  800cd0:	89 d8                	mov    %ebx,%eax
  800cd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cd5:	c9                   	leave  
  800cd6:	c3                   	ret    

00800cd7 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	56                   	push   %esi
  800cdb:	53                   	push   %ebx
  800cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce2:	89 c6                	mov    %eax,%esi
  800ce4:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ce7:	89 c2                	mov    %eax,%edx
  800ce9:	39 f2                	cmp    %esi,%edx
  800ceb:	74 11                	je     800cfe <strncpy+0x27>
		*dst++ = *src;
  800ced:	83 c2 01             	add    $0x1,%edx
  800cf0:	0f b6 19             	movzbl (%ecx),%ebx
  800cf3:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800cf6:	80 fb 01             	cmp    $0x1,%bl
  800cf9:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800cfc:	eb eb                	jmp    800ce9 <strncpy+0x12>
	}
	return ret;
}
  800cfe:	5b                   	pop    %ebx
  800cff:	5e                   	pop    %esi
  800d00:	5d                   	pop    %ebp
  800d01:	c3                   	ret    

00800d02 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d02:	55                   	push   %ebp
  800d03:	89 e5                	mov    %esp,%ebp
  800d05:	56                   	push   %esi
  800d06:	53                   	push   %ebx
  800d07:	8b 75 08             	mov    0x8(%ebp),%esi
  800d0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d0d:	8b 55 10             	mov    0x10(%ebp),%edx
  800d10:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800d12:	85 d2                	test   %edx,%edx
  800d14:	74 21                	je     800d37 <strlcpy+0x35>
  800d16:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800d1a:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800d1c:	39 c2                	cmp    %eax,%edx
  800d1e:	74 14                	je     800d34 <strlcpy+0x32>
  800d20:	0f b6 19             	movzbl (%ecx),%ebx
  800d23:	84 db                	test   %bl,%bl
  800d25:	74 0b                	je     800d32 <strlcpy+0x30>
			*dst++ = *src++;
  800d27:	83 c1 01             	add    $0x1,%ecx
  800d2a:	83 c2 01             	add    $0x1,%edx
  800d2d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800d30:	eb ea                	jmp    800d1c <strlcpy+0x1a>
  800d32:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800d34:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d37:	29 f0                	sub    %esi,%eax
}
  800d39:	5b                   	pop    %ebx
  800d3a:	5e                   	pop    %esi
  800d3b:	5d                   	pop    %ebp
  800d3c:	c3                   	ret    

00800d3d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
  800d40:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d43:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800d46:	0f b6 01             	movzbl (%ecx),%eax
  800d49:	84 c0                	test   %al,%al
  800d4b:	74 0c                	je     800d59 <strcmp+0x1c>
  800d4d:	3a 02                	cmp    (%edx),%al
  800d4f:	75 08                	jne    800d59 <strcmp+0x1c>
		p++, q++;
  800d51:	83 c1 01             	add    $0x1,%ecx
  800d54:	83 c2 01             	add    $0x1,%edx
  800d57:	eb ed                	jmp    800d46 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d59:	0f b6 c0             	movzbl %al,%eax
  800d5c:	0f b6 12             	movzbl (%edx),%edx
  800d5f:	29 d0                	sub    %edx,%eax
}
  800d61:	5d                   	pop    %ebp
  800d62:	c3                   	ret    

00800d63 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
  800d66:	53                   	push   %ebx
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d6d:	89 c3                	mov    %eax,%ebx
  800d6f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d72:	eb 06                	jmp    800d7a <strncmp+0x17>
		n--, p++, q++;
  800d74:	83 c0 01             	add    $0x1,%eax
  800d77:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800d7a:	39 d8                	cmp    %ebx,%eax
  800d7c:	74 16                	je     800d94 <strncmp+0x31>
  800d7e:	0f b6 08             	movzbl (%eax),%ecx
  800d81:	84 c9                	test   %cl,%cl
  800d83:	74 04                	je     800d89 <strncmp+0x26>
  800d85:	3a 0a                	cmp    (%edx),%cl
  800d87:	74 eb                	je     800d74 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d89:	0f b6 00             	movzbl (%eax),%eax
  800d8c:	0f b6 12             	movzbl (%edx),%edx
  800d8f:	29 d0                	sub    %edx,%eax
}
  800d91:	5b                   	pop    %ebx
  800d92:	5d                   	pop    %ebp
  800d93:	c3                   	ret    
		return 0;
  800d94:	b8 00 00 00 00       	mov    $0x0,%eax
  800d99:	eb f6                	jmp    800d91 <strncmp+0x2e>

00800d9b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800da5:	0f b6 10             	movzbl (%eax),%edx
  800da8:	84 d2                	test   %dl,%dl
  800daa:	74 09                	je     800db5 <strchr+0x1a>
		if (*s == c)
  800dac:	38 ca                	cmp    %cl,%dl
  800dae:	74 0a                	je     800dba <strchr+0x1f>
	for (; *s; s++)
  800db0:	83 c0 01             	add    $0x1,%eax
  800db3:	eb f0                	jmp    800da5 <strchr+0xa>
			return (char *) s;
	return 0;
  800db5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dba:	5d                   	pop    %ebp
  800dbb:	c3                   	ret    

00800dbc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dbc:	55                   	push   %ebp
  800dbd:	89 e5                	mov    %esp,%ebp
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800dc6:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800dc9:	38 ca                	cmp    %cl,%dl
  800dcb:	74 09                	je     800dd6 <strfind+0x1a>
  800dcd:	84 d2                	test   %dl,%dl
  800dcf:	74 05                	je     800dd6 <strfind+0x1a>
	for (; *s; s++)
  800dd1:	83 c0 01             	add    $0x1,%eax
  800dd4:	eb f0                	jmp    800dc6 <strfind+0xa>
			break;
	return (char *) s;
}
  800dd6:	5d                   	pop    %ebp
  800dd7:	c3                   	ret    

00800dd8 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800dd8:	55                   	push   %ebp
  800dd9:	89 e5                	mov    %esp,%ebp
  800ddb:	57                   	push   %edi
  800ddc:	56                   	push   %esi
  800ddd:	53                   	push   %ebx
  800dde:	8b 7d 08             	mov    0x8(%ebp),%edi
  800de1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800de4:	85 c9                	test   %ecx,%ecx
  800de6:	74 31                	je     800e19 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800de8:	89 f8                	mov    %edi,%eax
  800dea:	09 c8                	or     %ecx,%eax
  800dec:	a8 03                	test   $0x3,%al
  800dee:	75 23                	jne    800e13 <memset+0x3b>
		c &= 0xFF;
  800df0:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800df4:	89 d3                	mov    %edx,%ebx
  800df6:	c1 e3 08             	shl    $0x8,%ebx
  800df9:	89 d0                	mov    %edx,%eax
  800dfb:	c1 e0 18             	shl    $0x18,%eax
  800dfe:	89 d6                	mov    %edx,%esi
  800e00:	c1 e6 10             	shl    $0x10,%esi
  800e03:	09 f0                	or     %esi,%eax
  800e05:	09 c2                	or     %eax,%edx
  800e07:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800e09:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800e0c:	89 d0                	mov    %edx,%eax
  800e0e:	fc                   	cld    
  800e0f:	f3 ab                	rep stos %eax,%es:(%edi)
  800e11:	eb 06                	jmp    800e19 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800e13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e16:	fc                   	cld    
  800e17:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800e19:	89 f8                	mov    %edi,%eax
  800e1b:	5b                   	pop    %ebx
  800e1c:	5e                   	pop    %esi
  800e1d:	5f                   	pop    %edi
  800e1e:	5d                   	pop    %ebp
  800e1f:	c3                   	ret    

00800e20 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	57                   	push   %edi
  800e24:	56                   	push   %esi
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e2b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e2e:	39 c6                	cmp    %eax,%esi
  800e30:	73 32                	jae    800e64 <memmove+0x44>
  800e32:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800e35:	39 c2                	cmp    %eax,%edx
  800e37:	76 2b                	jbe    800e64 <memmove+0x44>
		s += n;
		d += n;
  800e39:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e3c:	89 fe                	mov    %edi,%esi
  800e3e:	09 ce                	or     %ecx,%esi
  800e40:	09 d6                	or     %edx,%esi
  800e42:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800e48:	75 0e                	jne    800e58 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800e4a:	83 ef 04             	sub    $0x4,%edi
  800e4d:	8d 72 fc             	lea    -0x4(%edx),%esi
  800e50:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800e53:	fd                   	std    
  800e54:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e56:	eb 09                	jmp    800e61 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800e58:	83 ef 01             	sub    $0x1,%edi
  800e5b:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800e5e:	fd                   	std    
  800e5f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e61:	fc                   	cld    
  800e62:	eb 1a                	jmp    800e7e <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e64:	89 c2                	mov    %eax,%edx
  800e66:	09 ca                	or     %ecx,%edx
  800e68:	09 f2                	or     %esi,%edx
  800e6a:	f6 c2 03             	test   $0x3,%dl
  800e6d:	75 0a                	jne    800e79 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e6f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800e72:	89 c7                	mov    %eax,%edi
  800e74:	fc                   	cld    
  800e75:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e77:	eb 05                	jmp    800e7e <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800e79:	89 c7                	mov    %eax,%edi
  800e7b:	fc                   	cld    
  800e7c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e7e:	5e                   	pop    %esi
  800e7f:	5f                   	pop    %edi
  800e80:	5d                   	pop    %ebp
  800e81:	c3                   	ret    

00800e82 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e82:	55                   	push   %ebp
  800e83:	89 e5                	mov    %esp,%ebp
  800e85:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e88:	ff 75 10             	pushl  0x10(%ebp)
  800e8b:	ff 75 0c             	pushl  0xc(%ebp)
  800e8e:	ff 75 08             	pushl  0x8(%ebp)
  800e91:	e8 8a ff ff ff       	call   800e20 <memmove>
}
  800e96:	c9                   	leave  
  800e97:	c3                   	ret    

00800e98 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e98:	55                   	push   %ebp
  800e99:	89 e5                	mov    %esp,%ebp
  800e9b:	56                   	push   %esi
  800e9c:	53                   	push   %ebx
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea3:	89 c6                	mov    %eax,%esi
  800ea5:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ea8:	39 f0                	cmp    %esi,%eax
  800eaa:	74 1c                	je     800ec8 <memcmp+0x30>
		if (*s1 != *s2)
  800eac:	0f b6 08             	movzbl (%eax),%ecx
  800eaf:	0f b6 1a             	movzbl (%edx),%ebx
  800eb2:	38 d9                	cmp    %bl,%cl
  800eb4:	75 08                	jne    800ebe <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800eb6:	83 c0 01             	add    $0x1,%eax
  800eb9:	83 c2 01             	add    $0x1,%edx
  800ebc:	eb ea                	jmp    800ea8 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ebe:	0f b6 c1             	movzbl %cl,%eax
  800ec1:	0f b6 db             	movzbl %bl,%ebx
  800ec4:	29 d8                	sub    %ebx,%eax
  800ec6:	eb 05                	jmp    800ecd <memcmp+0x35>
	}

	return 0;
  800ec8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ecd:	5b                   	pop    %ebx
  800ece:	5e                   	pop    %esi
  800ecf:	5d                   	pop    %ebp
  800ed0:	c3                   	ret    

00800ed1 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ed1:	55                   	push   %ebp
  800ed2:	89 e5                	mov    %esp,%ebp
  800ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800eda:	89 c2                	mov    %eax,%edx
  800edc:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800edf:	39 d0                	cmp    %edx,%eax
  800ee1:	73 09                	jae    800eec <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ee3:	38 08                	cmp    %cl,(%eax)
  800ee5:	74 05                	je     800eec <memfind+0x1b>
	for (; s < ends; s++)
  800ee7:	83 c0 01             	add    $0x1,%eax
  800eea:	eb f3                	jmp    800edf <memfind+0xe>
			break;
	return (void *) s;
}
  800eec:	5d                   	pop    %ebp
  800eed:	c3                   	ret    

00800eee <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800eee:	55                   	push   %ebp
  800eef:	89 e5                	mov    %esp,%ebp
  800ef1:	57                   	push   %edi
  800ef2:	56                   	push   %esi
  800ef3:	53                   	push   %ebx
  800ef4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ef7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800efa:	eb 03                	jmp    800eff <strtol+0x11>
		s++;
  800efc:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800eff:	0f b6 01             	movzbl (%ecx),%eax
  800f02:	3c 20                	cmp    $0x20,%al
  800f04:	74 f6                	je     800efc <strtol+0xe>
  800f06:	3c 09                	cmp    $0x9,%al
  800f08:	74 f2                	je     800efc <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800f0a:	3c 2b                	cmp    $0x2b,%al
  800f0c:	74 2a                	je     800f38 <strtol+0x4a>
	int neg = 0;
  800f0e:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800f13:	3c 2d                	cmp    $0x2d,%al
  800f15:	74 2b                	je     800f42 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f17:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800f1d:	75 0f                	jne    800f2e <strtol+0x40>
  800f1f:	80 39 30             	cmpb   $0x30,(%ecx)
  800f22:	74 28                	je     800f4c <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800f24:	85 db                	test   %ebx,%ebx
  800f26:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f2b:	0f 44 d8             	cmove  %eax,%ebx
  800f2e:	b8 00 00 00 00       	mov    $0x0,%eax
  800f33:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800f36:	eb 50                	jmp    800f88 <strtol+0x9a>
		s++;
  800f38:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800f3b:	bf 00 00 00 00       	mov    $0x0,%edi
  800f40:	eb d5                	jmp    800f17 <strtol+0x29>
		s++, neg = 1;
  800f42:	83 c1 01             	add    $0x1,%ecx
  800f45:	bf 01 00 00 00       	mov    $0x1,%edi
  800f4a:	eb cb                	jmp    800f17 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f4c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800f50:	74 0e                	je     800f60 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800f52:	85 db                	test   %ebx,%ebx
  800f54:	75 d8                	jne    800f2e <strtol+0x40>
		s++, base = 8;
  800f56:	83 c1 01             	add    $0x1,%ecx
  800f59:	bb 08 00 00 00       	mov    $0x8,%ebx
  800f5e:	eb ce                	jmp    800f2e <strtol+0x40>
		s += 2, base = 16;
  800f60:	83 c1 02             	add    $0x2,%ecx
  800f63:	bb 10 00 00 00       	mov    $0x10,%ebx
  800f68:	eb c4                	jmp    800f2e <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800f6a:	8d 72 9f             	lea    -0x61(%edx),%esi
  800f6d:	89 f3                	mov    %esi,%ebx
  800f6f:	80 fb 19             	cmp    $0x19,%bl
  800f72:	77 29                	ja     800f9d <strtol+0xaf>
			dig = *s - 'a' + 10;
  800f74:	0f be d2             	movsbl %dl,%edx
  800f77:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f7a:	3b 55 10             	cmp    0x10(%ebp),%edx
  800f7d:	7d 30                	jge    800faf <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800f7f:	83 c1 01             	add    $0x1,%ecx
  800f82:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f86:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800f88:	0f b6 11             	movzbl (%ecx),%edx
  800f8b:	8d 72 d0             	lea    -0x30(%edx),%esi
  800f8e:	89 f3                	mov    %esi,%ebx
  800f90:	80 fb 09             	cmp    $0x9,%bl
  800f93:	77 d5                	ja     800f6a <strtol+0x7c>
			dig = *s - '0';
  800f95:	0f be d2             	movsbl %dl,%edx
  800f98:	83 ea 30             	sub    $0x30,%edx
  800f9b:	eb dd                	jmp    800f7a <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800f9d:	8d 72 bf             	lea    -0x41(%edx),%esi
  800fa0:	89 f3                	mov    %esi,%ebx
  800fa2:	80 fb 19             	cmp    $0x19,%bl
  800fa5:	77 08                	ja     800faf <strtol+0xc1>
			dig = *s - 'A' + 10;
  800fa7:	0f be d2             	movsbl %dl,%edx
  800faa:	83 ea 37             	sub    $0x37,%edx
  800fad:	eb cb                	jmp    800f7a <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800faf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fb3:	74 05                	je     800fba <strtol+0xcc>
		*endptr = (char *) s;
  800fb5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800fb8:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800fba:	89 c2                	mov    %eax,%edx
  800fbc:	f7 da                	neg    %edx
  800fbe:	85 ff                	test   %edi,%edi
  800fc0:	0f 45 c2             	cmovne %edx,%eax
}
  800fc3:	5b                   	pop    %ebx
  800fc4:	5e                   	pop    %esi
  800fc5:	5f                   	pop    %edi
  800fc6:	5d                   	pop    %ebp
  800fc7:	c3                   	ret    

00800fc8 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800fc8:	55                   	push   %ebp
  800fc9:	89 e5                	mov    %esp,%ebp
  800fcb:	57                   	push   %edi
  800fcc:	56                   	push   %esi
  800fcd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fce:	b8 00 00 00 00       	mov    $0x0,%eax
  800fd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd9:	89 c3                	mov    %eax,%ebx
  800fdb:	89 c7                	mov    %eax,%edi
  800fdd:	89 c6                	mov    %eax,%esi
  800fdf:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800fe1:	5b                   	pop    %ebx
  800fe2:	5e                   	pop    %esi
  800fe3:	5f                   	pop    %edi
  800fe4:	5d                   	pop    %ebp
  800fe5:	c3                   	ret    

00800fe6 <sys_cgetc>:

int
sys_cgetc(void)
{
  800fe6:	55                   	push   %ebp
  800fe7:	89 e5                	mov    %esp,%ebp
  800fe9:	57                   	push   %edi
  800fea:	56                   	push   %esi
  800feb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fec:	ba 00 00 00 00       	mov    $0x0,%edx
  800ff1:	b8 01 00 00 00       	mov    $0x1,%eax
  800ff6:	89 d1                	mov    %edx,%ecx
  800ff8:	89 d3                	mov    %edx,%ebx
  800ffa:	89 d7                	mov    %edx,%edi
  800ffc:	89 d6                	mov    %edx,%esi
  800ffe:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801000:	5b                   	pop    %ebx
  801001:	5e                   	pop    %esi
  801002:	5f                   	pop    %edi
  801003:	5d                   	pop    %ebp
  801004:	c3                   	ret    

00801005 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801005:	55                   	push   %ebp
  801006:	89 e5                	mov    %esp,%ebp
  801008:	57                   	push   %edi
  801009:	56                   	push   %esi
  80100a:	53                   	push   %ebx
  80100b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80100e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801013:	8b 55 08             	mov    0x8(%ebp),%edx
  801016:	b8 03 00 00 00       	mov    $0x3,%eax
  80101b:	89 cb                	mov    %ecx,%ebx
  80101d:	89 cf                	mov    %ecx,%edi
  80101f:	89 ce                	mov    %ecx,%esi
  801021:	cd 30                	int    $0x30
	if(check && ret > 0)
  801023:	85 c0                	test   %eax,%eax
  801025:	7f 08                	jg     80102f <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801027:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80102a:	5b                   	pop    %ebx
  80102b:	5e                   	pop    %esi
  80102c:	5f                   	pop    %edi
  80102d:	5d                   	pop    %ebp
  80102e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80102f:	83 ec 0c             	sub    $0xc,%esp
  801032:	50                   	push   %eax
  801033:	6a 03                	push   $0x3
  801035:	68 00 2c 80 00       	push   $0x802c00
  80103a:	6a 43                	push   $0x43
  80103c:	68 1d 2c 80 00       	push   $0x802c1d
  801041:	e8 f7 f3 ff ff       	call   80043d <_panic>

00801046 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801046:	55                   	push   %ebp
  801047:	89 e5                	mov    %esp,%ebp
  801049:	57                   	push   %edi
  80104a:	56                   	push   %esi
  80104b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80104c:	ba 00 00 00 00       	mov    $0x0,%edx
  801051:	b8 02 00 00 00       	mov    $0x2,%eax
  801056:	89 d1                	mov    %edx,%ecx
  801058:	89 d3                	mov    %edx,%ebx
  80105a:	89 d7                	mov    %edx,%edi
  80105c:	89 d6                	mov    %edx,%esi
  80105e:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801060:	5b                   	pop    %ebx
  801061:	5e                   	pop    %esi
  801062:	5f                   	pop    %edi
  801063:	5d                   	pop    %ebp
  801064:	c3                   	ret    

00801065 <sys_yield>:

void
sys_yield(void)
{
  801065:	55                   	push   %ebp
  801066:	89 e5                	mov    %esp,%ebp
  801068:	57                   	push   %edi
  801069:	56                   	push   %esi
  80106a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80106b:	ba 00 00 00 00       	mov    $0x0,%edx
  801070:	b8 0b 00 00 00       	mov    $0xb,%eax
  801075:	89 d1                	mov    %edx,%ecx
  801077:	89 d3                	mov    %edx,%ebx
  801079:	89 d7                	mov    %edx,%edi
  80107b:	89 d6                	mov    %edx,%esi
  80107d:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80107f:	5b                   	pop    %ebx
  801080:	5e                   	pop    %esi
  801081:	5f                   	pop    %edi
  801082:	5d                   	pop    %ebp
  801083:	c3                   	ret    

00801084 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801084:	55                   	push   %ebp
  801085:	89 e5                	mov    %esp,%ebp
  801087:	57                   	push   %edi
  801088:	56                   	push   %esi
  801089:	53                   	push   %ebx
  80108a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80108d:	be 00 00 00 00       	mov    $0x0,%esi
  801092:	8b 55 08             	mov    0x8(%ebp),%edx
  801095:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801098:	b8 04 00 00 00       	mov    $0x4,%eax
  80109d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010a0:	89 f7                	mov    %esi,%edi
  8010a2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010a4:	85 c0                	test   %eax,%eax
  8010a6:	7f 08                	jg     8010b0 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8010a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ab:	5b                   	pop    %ebx
  8010ac:	5e                   	pop    %esi
  8010ad:	5f                   	pop    %edi
  8010ae:	5d                   	pop    %ebp
  8010af:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010b0:	83 ec 0c             	sub    $0xc,%esp
  8010b3:	50                   	push   %eax
  8010b4:	6a 04                	push   $0x4
  8010b6:	68 00 2c 80 00       	push   $0x802c00
  8010bb:	6a 43                	push   $0x43
  8010bd:	68 1d 2c 80 00       	push   $0x802c1d
  8010c2:	e8 76 f3 ff ff       	call   80043d <_panic>

008010c7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
  8010ca:	57                   	push   %edi
  8010cb:	56                   	push   %esi
  8010cc:	53                   	push   %ebx
  8010cd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d6:	b8 05 00 00 00       	mov    $0x5,%eax
  8010db:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010de:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010e1:	8b 75 18             	mov    0x18(%ebp),%esi
  8010e4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010e6:	85 c0                	test   %eax,%eax
  8010e8:	7f 08                	jg     8010f2 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8010ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ed:	5b                   	pop    %ebx
  8010ee:	5e                   	pop    %esi
  8010ef:	5f                   	pop    %edi
  8010f0:	5d                   	pop    %ebp
  8010f1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010f2:	83 ec 0c             	sub    $0xc,%esp
  8010f5:	50                   	push   %eax
  8010f6:	6a 05                	push   $0x5
  8010f8:	68 00 2c 80 00       	push   $0x802c00
  8010fd:	6a 43                	push   $0x43
  8010ff:	68 1d 2c 80 00       	push   $0x802c1d
  801104:	e8 34 f3 ff ff       	call   80043d <_panic>

00801109 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801109:	55                   	push   %ebp
  80110a:	89 e5                	mov    %esp,%ebp
  80110c:	57                   	push   %edi
  80110d:	56                   	push   %esi
  80110e:	53                   	push   %ebx
  80110f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801112:	bb 00 00 00 00       	mov    $0x0,%ebx
  801117:	8b 55 08             	mov    0x8(%ebp),%edx
  80111a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80111d:	b8 06 00 00 00       	mov    $0x6,%eax
  801122:	89 df                	mov    %ebx,%edi
  801124:	89 de                	mov    %ebx,%esi
  801126:	cd 30                	int    $0x30
	if(check && ret > 0)
  801128:	85 c0                	test   %eax,%eax
  80112a:	7f 08                	jg     801134 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80112c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80112f:	5b                   	pop    %ebx
  801130:	5e                   	pop    %esi
  801131:	5f                   	pop    %edi
  801132:	5d                   	pop    %ebp
  801133:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801134:	83 ec 0c             	sub    $0xc,%esp
  801137:	50                   	push   %eax
  801138:	6a 06                	push   $0x6
  80113a:	68 00 2c 80 00       	push   $0x802c00
  80113f:	6a 43                	push   $0x43
  801141:	68 1d 2c 80 00       	push   $0x802c1d
  801146:	e8 f2 f2 ff ff       	call   80043d <_panic>

0080114b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80114b:	55                   	push   %ebp
  80114c:	89 e5                	mov    %esp,%ebp
  80114e:	57                   	push   %edi
  80114f:	56                   	push   %esi
  801150:	53                   	push   %ebx
  801151:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801154:	bb 00 00 00 00       	mov    $0x0,%ebx
  801159:	8b 55 08             	mov    0x8(%ebp),%edx
  80115c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80115f:	b8 08 00 00 00       	mov    $0x8,%eax
  801164:	89 df                	mov    %ebx,%edi
  801166:	89 de                	mov    %ebx,%esi
  801168:	cd 30                	int    $0x30
	if(check && ret > 0)
  80116a:	85 c0                	test   %eax,%eax
  80116c:	7f 08                	jg     801176 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80116e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801171:	5b                   	pop    %ebx
  801172:	5e                   	pop    %esi
  801173:	5f                   	pop    %edi
  801174:	5d                   	pop    %ebp
  801175:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801176:	83 ec 0c             	sub    $0xc,%esp
  801179:	50                   	push   %eax
  80117a:	6a 08                	push   $0x8
  80117c:	68 00 2c 80 00       	push   $0x802c00
  801181:	6a 43                	push   $0x43
  801183:	68 1d 2c 80 00       	push   $0x802c1d
  801188:	e8 b0 f2 ff ff       	call   80043d <_panic>

0080118d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80118d:	55                   	push   %ebp
  80118e:	89 e5                	mov    %esp,%ebp
  801190:	57                   	push   %edi
  801191:	56                   	push   %esi
  801192:	53                   	push   %ebx
  801193:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801196:	bb 00 00 00 00       	mov    $0x0,%ebx
  80119b:	8b 55 08             	mov    0x8(%ebp),%edx
  80119e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011a1:	b8 09 00 00 00       	mov    $0x9,%eax
  8011a6:	89 df                	mov    %ebx,%edi
  8011a8:	89 de                	mov    %ebx,%esi
  8011aa:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011ac:	85 c0                	test   %eax,%eax
  8011ae:	7f 08                	jg     8011b8 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8011b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011b3:	5b                   	pop    %ebx
  8011b4:	5e                   	pop    %esi
  8011b5:	5f                   	pop    %edi
  8011b6:	5d                   	pop    %ebp
  8011b7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011b8:	83 ec 0c             	sub    $0xc,%esp
  8011bb:	50                   	push   %eax
  8011bc:	6a 09                	push   $0x9
  8011be:	68 00 2c 80 00       	push   $0x802c00
  8011c3:	6a 43                	push   $0x43
  8011c5:	68 1d 2c 80 00       	push   $0x802c1d
  8011ca:	e8 6e f2 ff ff       	call   80043d <_panic>

008011cf <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8011cf:	55                   	push   %ebp
  8011d0:	89 e5                	mov    %esp,%ebp
  8011d2:	57                   	push   %edi
  8011d3:	56                   	push   %esi
  8011d4:	53                   	push   %ebx
  8011d5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011d8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011e3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011e8:	89 df                	mov    %ebx,%edi
  8011ea:	89 de                	mov    %ebx,%esi
  8011ec:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011ee:	85 c0                	test   %eax,%eax
  8011f0:	7f 08                	jg     8011fa <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8011f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011f5:	5b                   	pop    %ebx
  8011f6:	5e                   	pop    %esi
  8011f7:	5f                   	pop    %edi
  8011f8:	5d                   	pop    %ebp
  8011f9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011fa:	83 ec 0c             	sub    $0xc,%esp
  8011fd:	50                   	push   %eax
  8011fe:	6a 0a                	push   $0xa
  801200:	68 00 2c 80 00       	push   $0x802c00
  801205:	6a 43                	push   $0x43
  801207:	68 1d 2c 80 00       	push   $0x802c1d
  80120c:	e8 2c f2 ff ff       	call   80043d <_panic>

00801211 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801211:	55                   	push   %ebp
  801212:	89 e5                	mov    %esp,%ebp
  801214:	57                   	push   %edi
  801215:	56                   	push   %esi
  801216:	53                   	push   %ebx
	asm volatile("int %1\n"
  801217:	8b 55 08             	mov    0x8(%ebp),%edx
  80121a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80121d:	b8 0c 00 00 00       	mov    $0xc,%eax
  801222:	be 00 00 00 00       	mov    $0x0,%esi
  801227:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80122a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80122d:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80122f:	5b                   	pop    %ebx
  801230:	5e                   	pop    %esi
  801231:	5f                   	pop    %edi
  801232:	5d                   	pop    %ebp
  801233:	c3                   	ret    

00801234 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801234:	55                   	push   %ebp
  801235:	89 e5                	mov    %esp,%ebp
  801237:	57                   	push   %edi
  801238:	56                   	push   %esi
  801239:	53                   	push   %ebx
  80123a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80123d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801242:	8b 55 08             	mov    0x8(%ebp),%edx
  801245:	b8 0d 00 00 00       	mov    $0xd,%eax
  80124a:	89 cb                	mov    %ecx,%ebx
  80124c:	89 cf                	mov    %ecx,%edi
  80124e:	89 ce                	mov    %ecx,%esi
  801250:	cd 30                	int    $0x30
	if(check && ret > 0)
  801252:	85 c0                	test   %eax,%eax
  801254:	7f 08                	jg     80125e <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801256:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801259:	5b                   	pop    %ebx
  80125a:	5e                   	pop    %esi
  80125b:	5f                   	pop    %edi
  80125c:	5d                   	pop    %ebp
  80125d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80125e:	83 ec 0c             	sub    $0xc,%esp
  801261:	50                   	push   %eax
  801262:	6a 0d                	push   $0xd
  801264:	68 00 2c 80 00       	push   $0x802c00
  801269:	6a 43                	push   $0x43
  80126b:	68 1d 2c 80 00       	push   $0x802c1d
  801270:	e8 c8 f1 ff ff       	call   80043d <_panic>

00801275 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801275:	55                   	push   %ebp
  801276:	89 e5                	mov    %esp,%ebp
  801278:	57                   	push   %edi
  801279:	56                   	push   %esi
  80127a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80127b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801280:	8b 55 08             	mov    0x8(%ebp),%edx
  801283:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801286:	b8 0e 00 00 00       	mov    $0xe,%eax
  80128b:	89 df                	mov    %ebx,%edi
  80128d:	89 de                	mov    %ebx,%esi
  80128f:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801291:	5b                   	pop    %ebx
  801292:	5e                   	pop    %esi
  801293:	5f                   	pop    %edi
  801294:	5d                   	pop    %ebp
  801295:	c3                   	ret    

00801296 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801296:	55                   	push   %ebp
  801297:	89 e5                	mov    %esp,%ebp
  801299:	57                   	push   %edi
  80129a:	56                   	push   %esi
  80129b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80129c:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a4:	b8 0f 00 00 00       	mov    $0xf,%eax
  8012a9:	89 cb                	mov    %ecx,%ebx
  8012ab:	89 cf                	mov    %ecx,%edi
  8012ad:	89 ce                	mov    %ecx,%esi
  8012af:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8012b1:	5b                   	pop    %ebx
  8012b2:	5e                   	pop    %esi
  8012b3:	5f                   	pop    %edi
  8012b4:	5d                   	pop    %ebp
  8012b5:	c3                   	ret    

008012b6 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012b6:	55                   	push   %ebp
  8012b7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bc:	05 00 00 00 30       	add    $0x30000000,%eax
  8012c1:	c1 e8 0c             	shr    $0xc,%eax
}
  8012c4:	5d                   	pop    %ebp
  8012c5:	c3                   	ret    

008012c6 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012c6:	55                   	push   %ebp
  8012c7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cc:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8012d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012d6:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012db:	5d                   	pop    %ebp
  8012dc:	c3                   	ret    

008012dd <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012dd:	55                   	push   %ebp
  8012de:	89 e5                	mov    %esp,%ebp
  8012e0:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012e5:	89 c2                	mov    %eax,%edx
  8012e7:	c1 ea 16             	shr    $0x16,%edx
  8012ea:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012f1:	f6 c2 01             	test   $0x1,%dl
  8012f4:	74 2d                	je     801323 <fd_alloc+0x46>
  8012f6:	89 c2                	mov    %eax,%edx
  8012f8:	c1 ea 0c             	shr    $0xc,%edx
  8012fb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801302:	f6 c2 01             	test   $0x1,%dl
  801305:	74 1c                	je     801323 <fd_alloc+0x46>
  801307:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80130c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801311:	75 d2                	jne    8012e5 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801313:	8b 45 08             	mov    0x8(%ebp),%eax
  801316:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80131c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801321:	eb 0a                	jmp    80132d <fd_alloc+0x50>
			*fd_store = fd;
  801323:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801326:	89 01                	mov    %eax,(%ecx)
			return 0;
  801328:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80132d:	5d                   	pop    %ebp
  80132e:	c3                   	ret    

0080132f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80132f:	55                   	push   %ebp
  801330:	89 e5                	mov    %esp,%ebp
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801335:	83 f8 1f             	cmp    $0x1f,%eax
  801338:	77 30                	ja     80136a <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80133a:	c1 e0 0c             	shl    $0xc,%eax
  80133d:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801342:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801348:	f6 c2 01             	test   $0x1,%dl
  80134b:	74 24                	je     801371 <fd_lookup+0x42>
  80134d:	89 c2                	mov    %eax,%edx
  80134f:	c1 ea 0c             	shr    $0xc,%edx
  801352:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801359:	f6 c2 01             	test   $0x1,%dl
  80135c:	74 1a                	je     801378 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80135e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801361:	89 02                	mov    %eax,(%edx)
	return 0;
  801363:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801368:	5d                   	pop    %ebp
  801369:	c3                   	ret    
		return -E_INVAL;
  80136a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80136f:	eb f7                	jmp    801368 <fd_lookup+0x39>
		return -E_INVAL;
  801371:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801376:	eb f0                	jmp    801368 <fd_lookup+0x39>
  801378:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80137d:	eb e9                	jmp    801368 <fd_lookup+0x39>

0080137f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80137f:	55                   	push   %ebp
  801380:	89 e5                	mov    %esp,%ebp
  801382:	83 ec 08             	sub    $0x8,%esp
  801385:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801388:	ba a8 2c 80 00       	mov    $0x802ca8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80138d:	b8 90 47 80 00       	mov    $0x804790,%eax
		if (devtab[i]->dev_id == dev_id) {
  801392:	39 08                	cmp    %ecx,(%eax)
  801394:	74 33                	je     8013c9 <dev_lookup+0x4a>
  801396:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801399:	8b 02                	mov    (%edx),%eax
  80139b:	85 c0                	test   %eax,%eax
  80139d:	75 f3                	jne    801392 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80139f:	a1 90 67 80 00       	mov    0x806790,%eax
  8013a4:	8b 40 48             	mov    0x48(%eax),%eax
  8013a7:	83 ec 04             	sub    $0x4,%esp
  8013aa:	51                   	push   %ecx
  8013ab:	50                   	push   %eax
  8013ac:	68 2c 2c 80 00       	push   $0x802c2c
  8013b1:	e8 7d f1 ff ff       	call   800533 <cprintf>
	*dev = 0;
  8013b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013bf:	83 c4 10             	add    $0x10,%esp
  8013c2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013c7:	c9                   	leave  
  8013c8:	c3                   	ret    
			*dev = devtab[i];
  8013c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013cc:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d3:	eb f2                	jmp    8013c7 <dev_lookup+0x48>

008013d5 <fd_close>:
{
  8013d5:	55                   	push   %ebp
  8013d6:	89 e5                	mov    %esp,%ebp
  8013d8:	57                   	push   %edi
  8013d9:	56                   	push   %esi
  8013da:	53                   	push   %ebx
  8013db:	83 ec 24             	sub    $0x24,%esp
  8013de:	8b 75 08             	mov    0x8(%ebp),%esi
  8013e1:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013e7:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013e8:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8013ee:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013f1:	50                   	push   %eax
  8013f2:	e8 38 ff ff ff       	call   80132f <fd_lookup>
  8013f7:	89 c3                	mov    %eax,%ebx
  8013f9:	83 c4 10             	add    $0x10,%esp
  8013fc:	85 c0                	test   %eax,%eax
  8013fe:	78 05                	js     801405 <fd_close+0x30>
	    || fd != fd2)
  801400:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801403:	74 16                	je     80141b <fd_close+0x46>
		return (must_exist ? r : 0);
  801405:	89 f8                	mov    %edi,%eax
  801407:	84 c0                	test   %al,%al
  801409:	b8 00 00 00 00       	mov    $0x0,%eax
  80140e:	0f 44 d8             	cmove  %eax,%ebx
}
  801411:	89 d8                	mov    %ebx,%eax
  801413:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801416:	5b                   	pop    %ebx
  801417:	5e                   	pop    %esi
  801418:	5f                   	pop    %edi
  801419:	5d                   	pop    %ebp
  80141a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80141b:	83 ec 08             	sub    $0x8,%esp
  80141e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801421:	50                   	push   %eax
  801422:	ff 36                	pushl  (%esi)
  801424:	e8 56 ff ff ff       	call   80137f <dev_lookup>
  801429:	89 c3                	mov    %eax,%ebx
  80142b:	83 c4 10             	add    $0x10,%esp
  80142e:	85 c0                	test   %eax,%eax
  801430:	78 1a                	js     80144c <fd_close+0x77>
		if (dev->dev_close)
  801432:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801435:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801438:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80143d:	85 c0                	test   %eax,%eax
  80143f:	74 0b                	je     80144c <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801441:	83 ec 0c             	sub    $0xc,%esp
  801444:	56                   	push   %esi
  801445:	ff d0                	call   *%eax
  801447:	89 c3                	mov    %eax,%ebx
  801449:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80144c:	83 ec 08             	sub    $0x8,%esp
  80144f:	56                   	push   %esi
  801450:	6a 00                	push   $0x0
  801452:	e8 b2 fc ff ff       	call   801109 <sys_page_unmap>
	return r;
  801457:	83 c4 10             	add    $0x10,%esp
  80145a:	eb b5                	jmp    801411 <fd_close+0x3c>

0080145c <close>:

int
close(int fdnum)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
  80145f:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801462:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801465:	50                   	push   %eax
  801466:	ff 75 08             	pushl  0x8(%ebp)
  801469:	e8 c1 fe ff ff       	call   80132f <fd_lookup>
  80146e:	83 c4 10             	add    $0x10,%esp
  801471:	85 c0                	test   %eax,%eax
  801473:	79 02                	jns    801477 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801475:	c9                   	leave  
  801476:	c3                   	ret    
		return fd_close(fd, 1);
  801477:	83 ec 08             	sub    $0x8,%esp
  80147a:	6a 01                	push   $0x1
  80147c:	ff 75 f4             	pushl  -0xc(%ebp)
  80147f:	e8 51 ff ff ff       	call   8013d5 <fd_close>
  801484:	83 c4 10             	add    $0x10,%esp
  801487:	eb ec                	jmp    801475 <close+0x19>

00801489 <close_all>:

void
close_all(void)
{
  801489:	55                   	push   %ebp
  80148a:	89 e5                	mov    %esp,%ebp
  80148c:	53                   	push   %ebx
  80148d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801490:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801495:	83 ec 0c             	sub    $0xc,%esp
  801498:	53                   	push   %ebx
  801499:	e8 be ff ff ff       	call   80145c <close>
	for (i = 0; i < MAXFD; i++)
  80149e:	83 c3 01             	add    $0x1,%ebx
  8014a1:	83 c4 10             	add    $0x10,%esp
  8014a4:	83 fb 20             	cmp    $0x20,%ebx
  8014a7:	75 ec                	jne    801495 <close_all+0xc>
}
  8014a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014ac:	c9                   	leave  
  8014ad:	c3                   	ret    

008014ae <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014ae:	55                   	push   %ebp
  8014af:	89 e5                	mov    %esp,%ebp
  8014b1:	57                   	push   %edi
  8014b2:	56                   	push   %esi
  8014b3:	53                   	push   %ebx
  8014b4:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014b7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014ba:	50                   	push   %eax
  8014bb:	ff 75 08             	pushl  0x8(%ebp)
  8014be:	e8 6c fe ff ff       	call   80132f <fd_lookup>
  8014c3:	89 c3                	mov    %eax,%ebx
  8014c5:	83 c4 10             	add    $0x10,%esp
  8014c8:	85 c0                	test   %eax,%eax
  8014ca:	0f 88 81 00 00 00    	js     801551 <dup+0xa3>
		return r;
	close(newfdnum);
  8014d0:	83 ec 0c             	sub    $0xc,%esp
  8014d3:	ff 75 0c             	pushl  0xc(%ebp)
  8014d6:	e8 81 ff ff ff       	call   80145c <close>

	newfd = INDEX2FD(newfdnum);
  8014db:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014de:	c1 e6 0c             	shl    $0xc,%esi
  8014e1:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8014e7:	83 c4 04             	add    $0x4,%esp
  8014ea:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014ed:	e8 d4 fd ff ff       	call   8012c6 <fd2data>
  8014f2:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8014f4:	89 34 24             	mov    %esi,(%esp)
  8014f7:	e8 ca fd ff ff       	call   8012c6 <fd2data>
  8014fc:	83 c4 10             	add    $0x10,%esp
  8014ff:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801501:	89 d8                	mov    %ebx,%eax
  801503:	c1 e8 16             	shr    $0x16,%eax
  801506:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80150d:	a8 01                	test   $0x1,%al
  80150f:	74 11                	je     801522 <dup+0x74>
  801511:	89 d8                	mov    %ebx,%eax
  801513:	c1 e8 0c             	shr    $0xc,%eax
  801516:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80151d:	f6 c2 01             	test   $0x1,%dl
  801520:	75 39                	jne    80155b <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801522:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801525:	89 d0                	mov    %edx,%eax
  801527:	c1 e8 0c             	shr    $0xc,%eax
  80152a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801531:	83 ec 0c             	sub    $0xc,%esp
  801534:	25 07 0e 00 00       	and    $0xe07,%eax
  801539:	50                   	push   %eax
  80153a:	56                   	push   %esi
  80153b:	6a 00                	push   $0x0
  80153d:	52                   	push   %edx
  80153e:	6a 00                	push   $0x0
  801540:	e8 82 fb ff ff       	call   8010c7 <sys_page_map>
  801545:	89 c3                	mov    %eax,%ebx
  801547:	83 c4 20             	add    $0x20,%esp
  80154a:	85 c0                	test   %eax,%eax
  80154c:	78 31                	js     80157f <dup+0xd1>
		goto err;

	return newfdnum;
  80154e:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801551:	89 d8                	mov    %ebx,%eax
  801553:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801556:	5b                   	pop    %ebx
  801557:	5e                   	pop    %esi
  801558:	5f                   	pop    %edi
  801559:	5d                   	pop    %ebp
  80155a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80155b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801562:	83 ec 0c             	sub    $0xc,%esp
  801565:	25 07 0e 00 00       	and    $0xe07,%eax
  80156a:	50                   	push   %eax
  80156b:	57                   	push   %edi
  80156c:	6a 00                	push   $0x0
  80156e:	53                   	push   %ebx
  80156f:	6a 00                	push   $0x0
  801571:	e8 51 fb ff ff       	call   8010c7 <sys_page_map>
  801576:	89 c3                	mov    %eax,%ebx
  801578:	83 c4 20             	add    $0x20,%esp
  80157b:	85 c0                	test   %eax,%eax
  80157d:	79 a3                	jns    801522 <dup+0x74>
	sys_page_unmap(0, newfd);
  80157f:	83 ec 08             	sub    $0x8,%esp
  801582:	56                   	push   %esi
  801583:	6a 00                	push   $0x0
  801585:	e8 7f fb ff ff       	call   801109 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80158a:	83 c4 08             	add    $0x8,%esp
  80158d:	57                   	push   %edi
  80158e:	6a 00                	push   $0x0
  801590:	e8 74 fb ff ff       	call   801109 <sys_page_unmap>
	return r;
  801595:	83 c4 10             	add    $0x10,%esp
  801598:	eb b7                	jmp    801551 <dup+0xa3>

0080159a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80159a:	55                   	push   %ebp
  80159b:	89 e5                	mov    %esp,%ebp
  80159d:	53                   	push   %ebx
  80159e:	83 ec 1c             	sub    $0x1c,%esp
  8015a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015a7:	50                   	push   %eax
  8015a8:	53                   	push   %ebx
  8015a9:	e8 81 fd ff ff       	call   80132f <fd_lookup>
  8015ae:	83 c4 10             	add    $0x10,%esp
  8015b1:	85 c0                	test   %eax,%eax
  8015b3:	78 3f                	js     8015f4 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015b5:	83 ec 08             	sub    $0x8,%esp
  8015b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015bb:	50                   	push   %eax
  8015bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015bf:	ff 30                	pushl  (%eax)
  8015c1:	e8 b9 fd ff ff       	call   80137f <dev_lookup>
  8015c6:	83 c4 10             	add    $0x10,%esp
  8015c9:	85 c0                	test   %eax,%eax
  8015cb:	78 27                	js     8015f4 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015d0:	8b 42 08             	mov    0x8(%edx),%eax
  8015d3:	83 e0 03             	and    $0x3,%eax
  8015d6:	83 f8 01             	cmp    $0x1,%eax
  8015d9:	74 1e                	je     8015f9 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8015db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015de:	8b 40 08             	mov    0x8(%eax),%eax
  8015e1:	85 c0                	test   %eax,%eax
  8015e3:	74 35                	je     80161a <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8015e5:	83 ec 04             	sub    $0x4,%esp
  8015e8:	ff 75 10             	pushl  0x10(%ebp)
  8015eb:	ff 75 0c             	pushl  0xc(%ebp)
  8015ee:	52                   	push   %edx
  8015ef:	ff d0                	call   *%eax
  8015f1:	83 c4 10             	add    $0x10,%esp
}
  8015f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015f7:	c9                   	leave  
  8015f8:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8015f9:	a1 90 67 80 00       	mov    0x806790,%eax
  8015fe:	8b 40 48             	mov    0x48(%eax),%eax
  801601:	83 ec 04             	sub    $0x4,%esp
  801604:	53                   	push   %ebx
  801605:	50                   	push   %eax
  801606:	68 6d 2c 80 00       	push   $0x802c6d
  80160b:	e8 23 ef ff ff       	call   800533 <cprintf>
		return -E_INVAL;
  801610:	83 c4 10             	add    $0x10,%esp
  801613:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801618:	eb da                	jmp    8015f4 <read+0x5a>
		return -E_NOT_SUPP;
  80161a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80161f:	eb d3                	jmp    8015f4 <read+0x5a>

00801621 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
  801624:	57                   	push   %edi
  801625:	56                   	push   %esi
  801626:	53                   	push   %ebx
  801627:	83 ec 0c             	sub    $0xc,%esp
  80162a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80162d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801630:	bb 00 00 00 00       	mov    $0x0,%ebx
  801635:	39 f3                	cmp    %esi,%ebx
  801637:	73 23                	jae    80165c <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801639:	83 ec 04             	sub    $0x4,%esp
  80163c:	89 f0                	mov    %esi,%eax
  80163e:	29 d8                	sub    %ebx,%eax
  801640:	50                   	push   %eax
  801641:	89 d8                	mov    %ebx,%eax
  801643:	03 45 0c             	add    0xc(%ebp),%eax
  801646:	50                   	push   %eax
  801647:	57                   	push   %edi
  801648:	e8 4d ff ff ff       	call   80159a <read>
		if (m < 0)
  80164d:	83 c4 10             	add    $0x10,%esp
  801650:	85 c0                	test   %eax,%eax
  801652:	78 06                	js     80165a <readn+0x39>
			return m;
		if (m == 0)
  801654:	74 06                	je     80165c <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801656:	01 c3                	add    %eax,%ebx
  801658:	eb db                	jmp    801635 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80165a:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80165c:	89 d8                	mov    %ebx,%eax
  80165e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801661:	5b                   	pop    %ebx
  801662:	5e                   	pop    %esi
  801663:	5f                   	pop    %edi
  801664:	5d                   	pop    %ebp
  801665:	c3                   	ret    

00801666 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
  801669:	53                   	push   %ebx
  80166a:	83 ec 1c             	sub    $0x1c,%esp
  80166d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801670:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801673:	50                   	push   %eax
  801674:	53                   	push   %ebx
  801675:	e8 b5 fc ff ff       	call   80132f <fd_lookup>
  80167a:	83 c4 10             	add    $0x10,%esp
  80167d:	85 c0                	test   %eax,%eax
  80167f:	78 3a                	js     8016bb <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801681:	83 ec 08             	sub    $0x8,%esp
  801684:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801687:	50                   	push   %eax
  801688:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80168b:	ff 30                	pushl  (%eax)
  80168d:	e8 ed fc ff ff       	call   80137f <dev_lookup>
  801692:	83 c4 10             	add    $0x10,%esp
  801695:	85 c0                	test   %eax,%eax
  801697:	78 22                	js     8016bb <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801699:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80169c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016a0:	74 1e                	je     8016c0 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016a5:	8b 52 0c             	mov    0xc(%edx),%edx
  8016a8:	85 d2                	test   %edx,%edx
  8016aa:	74 35                	je     8016e1 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016ac:	83 ec 04             	sub    $0x4,%esp
  8016af:	ff 75 10             	pushl  0x10(%ebp)
  8016b2:	ff 75 0c             	pushl  0xc(%ebp)
  8016b5:	50                   	push   %eax
  8016b6:	ff d2                	call   *%edx
  8016b8:	83 c4 10             	add    $0x10,%esp
}
  8016bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016be:	c9                   	leave  
  8016bf:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016c0:	a1 90 67 80 00       	mov    0x806790,%eax
  8016c5:	8b 40 48             	mov    0x48(%eax),%eax
  8016c8:	83 ec 04             	sub    $0x4,%esp
  8016cb:	53                   	push   %ebx
  8016cc:	50                   	push   %eax
  8016cd:	68 89 2c 80 00       	push   $0x802c89
  8016d2:	e8 5c ee ff ff       	call   800533 <cprintf>
		return -E_INVAL;
  8016d7:	83 c4 10             	add    $0x10,%esp
  8016da:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016df:	eb da                	jmp    8016bb <write+0x55>
		return -E_NOT_SUPP;
  8016e1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016e6:	eb d3                	jmp    8016bb <write+0x55>

008016e8 <seek>:

int
seek(int fdnum, off_t offset)
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
  8016eb:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016f1:	50                   	push   %eax
  8016f2:	ff 75 08             	pushl  0x8(%ebp)
  8016f5:	e8 35 fc ff ff       	call   80132f <fd_lookup>
  8016fa:	83 c4 10             	add    $0x10,%esp
  8016fd:	85 c0                	test   %eax,%eax
  8016ff:	78 0e                	js     80170f <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801701:	8b 55 0c             	mov    0xc(%ebp),%edx
  801704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801707:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80170a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80170f:	c9                   	leave  
  801710:	c3                   	ret    

00801711 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
  801714:	53                   	push   %ebx
  801715:	83 ec 1c             	sub    $0x1c,%esp
  801718:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80171b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80171e:	50                   	push   %eax
  80171f:	53                   	push   %ebx
  801720:	e8 0a fc ff ff       	call   80132f <fd_lookup>
  801725:	83 c4 10             	add    $0x10,%esp
  801728:	85 c0                	test   %eax,%eax
  80172a:	78 37                	js     801763 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80172c:	83 ec 08             	sub    $0x8,%esp
  80172f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801732:	50                   	push   %eax
  801733:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801736:	ff 30                	pushl  (%eax)
  801738:	e8 42 fc ff ff       	call   80137f <dev_lookup>
  80173d:	83 c4 10             	add    $0x10,%esp
  801740:	85 c0                	test   %eax,%eax
  801742:	78 1f                	js     801763 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801744:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801747:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80174b:	74 1b                	je     801768 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80174d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801750:	8b 52 18             	mov    0x18(%edx),%edx
  801753:	85 d2                	test   %edx,%edx
  801755:	74 32                	je     801789 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801757:	83 ec 08             	sub    $0x8,%esp
  80175a:	ff 75 0c             	pushl  0xc(%ebp)
  80175d:	50                   	push   %eax
  80175e:	ff d2                	call   *%edx
  801760:	83 c4 10             	add    $0x10,%esp
}
  801763:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801766:	c9                   	leave  
  801767:	c3                   	ret    
			thisenv->env_id, fdnum);
  801768:	a1 90 67 80 00       	mov    0x806790,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80176d:	8b 40 48             	mov    0x48(%eax),%eax
  801770:	83 ec 04             	sub    $0x4,%esp
  801773:	53                   	push   %ebx
  801774:	50                   	push   %eax
  801775:	68 4c 2c 80 00       	push   $0x802c4c
  80177a:	e8 b4 ed ff ff       	call   800533 <cprintf>
		return -E_INVAL;
  80177f:	83 c4 10             	add    $0x10,%esp
  801782:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801787:	eb da                	jmp    801763 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801789:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80178e:	eb d3                	jmp    801763 <ftruncate+0x52>

00801790 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
  801793:	53                   	push   %ebx
  801794:	83 ec 1c             	sub    $0x1c,%esp
  801797:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80179a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80179d:	50                   	push   %eax
  80179e:	ff 75 08             	pushl  0x8(%ebp)
  8017a1:	e8 89 fb ff ff       	call   80132f <fd_lookup>
  8017a6:	83 c4 10             	add    $0x10,%esp
  8017a9:	85 c0                	test   %eax,%eax
  8017ab:	78 4b                	js     8017f8 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017ad:	83 ec 08             	sub    $0x8,%esp
  8017b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017b3:	50                   	push   %eax
  8017b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b7:	ff 30                	pushl  (%eax)
  8017b9:	e8 c1 fb ff ff       	call   80137f <dev_lookup>
  8017be:	83 c4 10             	add    $0x10,%esp
  8017c1:	85 c0                	test   %eax,%eax
  8017c3:	78 33                	js     8017f8 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8017c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c8:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8017cc:	74 2f                	je     8017fd <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017ce:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017d1:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017d8:	00 00 00 
	stat->st_isdir = 0;
  8017db:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017e2:	00 00 00 
	stat->st_dev = dev;
  8017e5:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8017eb:	83 ec 08             	sub    $0x8,%esp
  8017ee:	53                   	push   %ebx
  8017ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8017f2:	ff 50 14             	call   *0x14(%eax)
  8017f5:	83 c4 10             	add    $0x10,%esp
}
  8017f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017fb:	c9                   	leave  
  8017fc:	c3                   	ret    
		return -E_NOT_SUPP;
  8017fd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801802:	eb f4                	jmp    8017f8 <fstat+0x68>

00801804 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
  801807:	56                   	push   %esi
  801808:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801809:	83 ec 08             	sub    $0x8,%esp
  80180c:	6a 00                	push   $0x0
  80180e:	ff 75 08             	pushl  0x8(%ebp)
  801811:	e8 bb 01 00 00       	call   8019d1 <open>
  801816:	89 c3                	mov    %eax,%ebx
  801818:	83 c4 10             	add    $0x10,%esp
  80181b:	85 c0                	test   %eax,%eax
  80181d:	78 1b                	js     80183a <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80181f:	83 ec 08             	sub    $0x8,%esp
  801822:	ff 75 0c             	pushl  0xc(%ebp)
  801825:	50                   	push   %eax
  801826:	e8 65 ff ff ff       	call   801790 <fstat>
  80182b:	89 c6                	mov    %eax,%esi
	close(fd);
  80182d:	89 1c 24             	mov    %ebx,(%esp)
  801830:	e8 27 fc ff ff       	call   80145c <close>
	return r;
  801835:	83 c4 10             	add    $0x10,%esp
  801838:	89 f3                	mov    %esi,%ebx
}
  80183a:	89 d8                	mov    %ebx,%eax
  80183c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80183f:	5b                   	pop    %ebx
  801840:	5e                   	pop    %esi
  801841:	5d                   	pop    %ebp
  801842:	c3                   	ret    

00801843 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	56                   	push   %esi
  801847:	53                   	push   %ebx
  801848:	89 c6                	mov    %eax,%esi
  80184a:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80184c:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801853:	74 27                	je     80187c <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801855:	6a 07                	push   $0x7
  801857:	68 00 70 80 00       	push   $0x807000
  80185c:	56                   	push   %esi
  80185d:	ff 35 00 50 80 00    	pushl  0x805000
  801863:	e8 73 0b 00 00       	call   8023db <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801868:	83 c4 0c             	add    $0xc,%esp
  80186b:	6a 00                	push   $0x0
  80186d:	53                   	push   %ebx
  80186e:	6a 00                	push   $0x0
  801870:	e8 fd 0a 00 00       	call   802372 <ipc_recv>
}
  801875:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801878:	5b                   	pop    %ebx
  801879:	5e                   	pop    %esi
  80187a:	5d                   	pop    %ebp
  80187b:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80187c:	83 ec 0c             	sub    $0xc,%esp
  80187f:	6a 01                	push   $0x1
  801881:	e8 ad 0b 00 00       	call   802433 <ipc_find_env>
  801886:	a3 00 50 80 00       	mov    %eax,0x805000
  80188b:	83 c4 10             	add    $0x10,%esp
  80188e:	eb c5                	jmp    801855 <fsipc+0x12>

00801890 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
  801893:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801896:	8b 45 08             	mov    0x8(%ebp),%eax
  801899:	8b 40 0c             	mov    0xc(%eax),%eax
  80189c:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  8018a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a4:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ae:	b8 02 00 00 00       	mov    $0x2,%eax
  8018b3:	e8 8b ff ff ff       	call   801843 <fsipc>
}
  8018b8:	c9                   	leave  
  8018b9:	c3                   	ret    

008018ba <devfile_flush>:
{
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
  8018bd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8018c6:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  8018cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d0:	b8 06 00 00 00       	mov    $0x6,%eax
  8018d5:	e8 69 ff ff ff       	call   801843 <fsipc>
}
  8018da:	c9                   	leave  
  8018db:	c3                   	ret    

008018dc <devfile_stat>:
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
  8018df:	53                   	push   %ebx
  8018e0:	83 ec 04             	sub    $0x4,%esp
  8018e3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8018e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8018ec:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8018f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f6:	b8 05 00 00 00       	mov    $0x5,%eax
  8018fb:	e8 43 ff ff ff       	call   801843 <fsipc>
  801900:	85 c0                	test   %eax,%eax
  801902:	78 2c                	js     801930 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801904:	83 ec 08             	sub    $0x8,%esp
  801907:	68 00 70 80 00       	push   $0x807000
  80190c:	53                   	push   %ebx
  80190d:	e8 80 f3 ff ff       	call   800c92 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801912:	a1 80 70 80 00       	mov    0x807080,%eax
  801917:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80191d:	a1 84 70 80 00       	mov    0x807084,%eax
  801922:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801928:	83 c4 10             	add    $0x10,%esp
  80192b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801930:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <devfile_write>:
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
  801938:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  80193b:	68 b8 2c 80 00       	push   $0x802cb8
  801940:	68 90 00 00 00       	push   $0x90
  801945:	68 d6 2c 80 00       	push   $0x802cd6
  80194a:	e8 ee ea ff ff       	call   80043d <_panic>

0080194f <devfile_read>:
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
  801952:	56                   	push   %esi
  801953:	53                   	push   %ebx
  801954:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801957:	8b 45 08             	mov    0x8(%ebp),%eax
  80195a:	8b 40 0c             	mov    0xc(%eax),%eax
  80195d:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  801962:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801968:	ba 00 00 00 00       	mov    $0x0,%edx
  80196d:	b8 03 00 00 00       	mov    $0x3,%eax
  801972:	e8 cc fe ff ff       	call   801843 <fsipc>
  801977:	89 c3                	mov    %eax,%ebx
  801979:	85 c0                	test   %eax,%eax
  80197b:	78 1f                	js     80199c <devfile_read+0x4d>
	assert(r <= n);
  80197d:	39 f0                	cmp    %esi,%eax
  80197f:	77 24                	ja     8019a5 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801981:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801986:	7f 33                	jg     8019bb <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801988:	83 ec 04             	sub    $0x4,%esp
  80198b:	50                   	push   %eax
  80198c:	68 00 70 80 00       	push   $0x807000
  801991:	ff 75 0c             	pushl  0xc(%ebp)
  801994:	e8 87 f4 ff ff       	call   800e20 <memmove>
	return r;
  801999:	83 c4 10             	add    $0x10,%esp
}
  80199c:	89 d8                	mov    %ebx,%eax
  80199e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019a1:	5b                   	pop    %ebx
  8019a2:	5e                   	pop    %esi
  8019a3:	5d                   	pop    %ebp
  8019a4:	c3                   	ret    
	assert(r <= n);
  8019a5:	68 e1 2c 80 00       	push   $0x802ce1
  8019aa:	68 e8 2c 80 00       	push   $0x802ce8
  8019af:	6a 7c                	push   $0x7c
  8019b1:	68 d6 2c 80 00       	push   $0x802cd6
  8019b6:	e8 82 ea ff ff       	call   80043d <_panic>
	assert(r <= PGSIZE);
  8019bb:	68 fd 2c 80 00       	push   $0x802cfd
  8019c0:	68 e8 2c 80 00       	push   $0x802ce8
  8019c5:	6a 7d                	push   $0x7d
  8019c7:	68 d6 2c 80 00       	push   $0x802cd6
  8019cc:	e8 6c ea ff ff       	call   80043d <_panic>

008019d1 <open>:
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
  8019d4:	56                   	push   %esi
  8019d5:	53                   	push   %ebx
  8019d6:	83 ec 1c             	sub    $0x1c,%esp
  8019d9:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8019dc:	56                   	push   %esi
  8019dd:	e8 77 f2 ff ff       	call   800c59 <strlen>
  8019e2:	83 c4 10             	add    $0x10,%esp
  8019e5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8019ea:	7f 6c                	jg     801a58 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8019ec:	83 ec 0c             	sub    $0xc,%esp
  8019ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019f2:	50                   	push   %eax
  8019f3:	e8 e5 f8 ff ff       	call   8012dd <fd_alloc>
  8019f8:	89 c3                	mov    %eax,%ebx
  8019fa:	83 c4 10             	add    $0x10,%esp
  8019fd:	85 c0                	test   %eax,%eax
  8019ff:	78 3c                	js     801a3d <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801a01:	83 ec 08             	sub    $0x8,%esp
  801a04:	56                   	push   %esi
  801a05:	68 00 70 80 00       	push   $0x807000
  801a0a:	e8 83 f2 ff ff       	call   800c92 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a12:	a3 00 74 80 00       	mov    %eax,0x807400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a1a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a1f:	e8 1f fe ff ff       	call   801843 <fsipc>
  801a24:	89 c3                	mov    %eax,%ebx
  801a26:	83 c4 10             	add    $0x10,%esp
  801a29:	85 c0                	test   %eax,%eax
  801a2b:	78 19                	js     801a46 <open+0x75>
	return fd2num(fd);
  801a2d:	83 ec 0c             	sub    $0xc,%esp
  801a30:	ff 75 f4             	pushl  -0xc(%ebp)
  801a33:	e8 7e f8 ff ff       	call   8012b6 <fd2num>
  801a38:	89 c3                	mov    %eax,%ebx
  801a3a:	83 c4 10             	add    $0x10,%esp
}
  801a3d:	89 d8                	mov    %ebx,%eax
  801a3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a42:	5b                   	pop    %ebx
  801a43:	5e                   	pop    %esi
  801a44:	5d                   	pop    %ebp
  801a45:	c3                   	ret    
		fd_close(fd, 0);
  801a46:	83 ec 08             	sub    $0x8,%esp
  801a49:	6a 00                	push   $0x0
  801a4b:	ff 75 f4             	pushl  -0xc(%ebp)
  801a4e:	e8 82 f9 ff ff       	call   8013d5 <fd_close>
		return r;
  801a53:	83 c4 10             	add    $0x10,%esp
  801a56:	eb e5                	jmp    801a3d <open+0x6c>
		return -E_BAD_PATH;
  801a58:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a5d:	eb de                	jmp    801a3d <open+0x6c>

00801a5f <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
  801a62:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a65:	ba 00 00 00 00       	mov    $0x0,%edx
  801a6a:	b8 08 00 00 00       	mov    $0x8,%eax
  801a6f:	e8 cf fd ff ff       	call   801843 <fsipc>
}
  801a74:	c9                   	leave  
  801a75:	c3                   	ret    

00801a76 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
  801a79:	57                   	push   %edi
  801a7a:	56                   	push   %esi
  801a7b:	53                   	push   %ebx
  801a7c:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801a82:	6a 00                	push   $0x0
  801a84:	ff 75 08             	pushl  0x8(%ebp)
  801a87:	e8 45 ff ff ff       	call   8019d1 <open>
  801a8c:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801a92:	83 c4 10             	add    $0x10,%esp
  801a95:	85 c0                	test   %eax,%eax
  801a97:	0f 88 71 04 00 00    	js     801f0e <spawn+0x498>
  801a9d:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801a9f:	83 ec 04             	sub    $0x4,%esp
  801aa2:	68 00 02 00 00       	push   $0x200
  801aa7:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801aad:	50                   	push   %eax
  801aae:	52                   	push   %edx
  801aaf:	e8 6d fb ff ff       	call   801621 <readn>
  801ab4:	83 c4 10             	add    $0x10,%esp
  801ab7:	3d 00 02 00 00       	cmp    $0x200,%eax
  801abc:	75 5f                	jne    801b1d <spawn+0xa7>
	    || elf->e_magic != ELF_MAGIC) {
  801abe:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801ac5:	45 4c 46 
  801ac8:	75 53                	jne    801b1d <spawn+0xa7>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801aca:	b8 07 00 00 00       	mov    $0x7,%eax
  801acf:	cd 30                	int    $0x30
  801ad1:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801ad7:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801add:	85 c0                	test   %eax,%eax
  801adf:	0f 88 1d 04 00 00    	js     801f02 <spawn+0x48c>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801ae5:	25 ff 03 00 00       	and    $0x3ff,%eax
  801aea:	89 c6                	mov    %eax,%esi
  801aec:	c1 e6 07             	shl    $0x7,%esi
  801aef:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801af5:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801afb:	b9 11 00 00 00       	mov    $0x11,%ecx
  801b00:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801b02:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801b08:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801b0e:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801b13:	be 00 00 00 00       	mov    $0x0,%esi
  801b18:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801b1b:	eb 4b                	jmp    801b68 <spawn+0xf2>
		close(fd);
  801b1d:	83 ec 0c             	sub    $0xc,%esp
  801b20:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801b26:	e8 31 f9 ff ff       	call   80145c <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801b2b:	83 c4 0c             	add    $0xc,%esp
  801b2e:	68 7f 45 4c 46       	push   $0x464c457f
  801b33:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801b39:	68 09 2d 80 00       	push   $0x802d09
  801b3e:	e8 f0 e9 ff ff       	call   800533 <cprintf>
		return -E_NOT_EXEC;
  801b43:	83 c4 10             	add    $0x10,%esp
  801b46:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801b4d:	ff ff ff 
  801b50:	e9 b9 03 00 00       	jmp    801f0e <spawn+0x498>
		string_size += strlen(argv[argc]) + 1;
  801b55:	83 ec 0c             	sub    $0xc,%esp
  801b58:	50                   	push   %eax
  801b59:	e8 fb f0 ff ff       	call   800c59 <strlen>
  801b5e:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801b62:	83 c3 01             	add    $0x1,%ebx
  801b65:	83 c4 10             	add    $0x10,%esp
  801b68:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801b6f:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801b72:	85 c0                	test   %eax,%eax
  801b74:	75 df                	jne    801b55 <spawn+0xdf>
  801b76:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801b7c:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801b82:	bf 00 10 40 00       	mov    $0x401000,%edi
  801b87:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801b89:	89 fa                	mov    %edi,%edx
  801b8b:	83 e2 fc             	and    $0xfffffffc,%edx
  801b8e:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801b95:	29 c2                	sub    %eax,%edx
  801b97:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801b9d:	8d 42 f8             	lea    -0x8(%edx),%eax
  801ba0:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801ba5:	0f 86 86 03 00 00    	jbe    801f31 <spawn+0x4bb>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801bab:	83 ec 04             	sub    $0x4,%esp
  801bae:	6a 07                	push   $0x7
  801bb0:	68 00 00 40 00       	push   $0x400000
  801bb5:	6a 00                	push   $0x0
  801bb7:	e8 c8 f4 ff ff       	call   801084 <sys_page_alloc>
  801bbc:	83 c4 10             	add    $0x10,%esp
  801bbf:	85 c0                	test   %eax,%eax
  801bc1:	0f 88 6f 03 00 00    	js     801f36 <spawn+0x4c0>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801bc7:	be 00 00 00 00       	mov    $0x0,%esi
  801bcc:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801bd2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801bd5:	eb 30                	jmp    801c07 <spawn+0x191>
		argv_store[i] = UTEMP2USTACK(string_store);
  801bd7:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801bdd:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801be3:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801be6:	83 ec 08             	sub    $0x8,%esp
  801be9:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801bec:	57                   	push   %edi
  801bed:	e8 a0 f0 ff ff       	call   800c92 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801bf2:	83 c4 04             	add    $0x4,%esp
  801bf5:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801bf8:	e8 5c f0 ff ff       	call   800c59 <strlen>
  801bfd:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801c01:	83 c6 01             	add    $0x1,%esi
  801c04:	83 c4 10             	add    $0x10,%esp
  801c07:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801c0d:	7f c8                	jg     801bd7 <spawn+0x161>
	}
	argv_store[argc] = 0;
  801c0f:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801c15:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801c1b:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801c22:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801c28:	0f 85 86 00 00 00    	jne    801cb4 <spawn+0x23e>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801c2e:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801c34:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  801c3a:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801c3d:	89 c8                	mov    %ecx,%eax
  801c3f:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  801c45:	89 48 f8             	mov    %ecx,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801c48:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801c4d:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801c53:	83 ec 0c             	sub    $0xc,%esp
  801c56:	6a 07                	push   $0x7
  801c58:	68 00 d0 bf ee       	push   $0xeebfd000
  801c5d:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801c63:	68 00 00 40 00       	push   $0x400000
  801c68:	6a 00                	push   $0x0
  801c6a:	e8 58 f4 ff ff       	call   8010c7 <sys_page_map>
  801c6f:	89 c3                	mov    %eax,%ebx
  801c71:	83 c4 20             	add    $0x20,%esp
  801c74:	85 c0                	test   %eax,%eax
  801c76:	0f 88 c2 02 00 00    	js     801f3e <spawn+0x4c8>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801c7c:	83 ec 08             	sub    $0x8,%esp
  801c7f:	68 00 00 40 00       	push   $0x400000
  801c84:	6a 00                	push   $0x0
  801c86:	e8 7e f4 ff ff       	call   801109 <sys_page_unmap>
  801c8b:	89 c3                	mov    %eax,%ebx
  801c8d:	83 c4 10             	add    $0x10,%esp
  801c90:	85 c0                	test   %eax,%eax
  801c92:	0f 88 a6 02 00 00    	js     801f3e <spawn+0x4c8>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801c98:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801c9e:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801ca5:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801cac:	00 00 00 
  801caf:	e9 4f 01 00 00       	jmp    801e03 <spawn+0x38d>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801cb4:	68 80 2d 80 00       	push   $0x802d80
  801cb9:	68 e8 2c 80 00       	push   $0x802ce8
  801cbe:	68 f2 00 00 00       	push   $0xf2
  801cc3:	68 23 2d 80 00       	push   $0x802d23
  801cc8:	e8 70 e7 ff ff       	call   80043d <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801ccd:	83 ec 04             	sub    $0x4,%esp
  801cd0:	6a 07                	push   $0x7
  801cd2:	68 00 00 40 00       	push   $0x400000
  801cd7:	6a 00                	push   $0x0
  801cd9:	e8 a6 f3 ff ff       	call   801084 <sys_page_alloc>
  801cde:	83 c4 10             	add    $0x10,%esp
  801ce1:	85 c0                	test   %eax,%eax
  801ce3:	0f 88 33 02 00 00    	js     801f1c <spawn+0x4a6>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801ce9:	83 ec 08             	sub    $0x8,%esp
  801cec:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801cf2:	01 f0                	add    %esi,%eax
  801cf4:	50                   	push   %eax
  801cf5:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801cfb:	e8 e8 f9 ff ff       	call   8016e8 <seek>
  801d00:	83 c4 10             	add    $0x10,%esp
  801d03:	85 c0                	test   %eax,%eax
  801d05:	0f 88 18 02 00 00    	js     801f23 <spawn+0x4ad>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801d0b:	83 ec 04             	sub    $0x4,%esp
  801d0e:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801d14:	29 f0                	sub    %esi,%eax
  801d16:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d1b:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d20:	0f 47 c2             	cmova  %edx,%eax
  801d23:	50                   	push   %eax
  801d24:	68 00 00 40 00       	push   $0x400000
  801d29:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801d2f:	e8 ed f8 ff ff       	call   801621 <readn>
  801d34:	83 c4 10             	add    $0x10,%esp
  801d37:	85 c0                	test   %eax,%eax
  801d39:	0f 88 eb 01 00 00    	js     801f2a <spawn+0x4b4>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801d3f:	83 ec 0c             	sub    $0xc,%esp
  801d42:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801d48:	53                   	push   %ebx
  801d49:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801d4f:	68 00 00 40 00       	push   $0x400000
  801d54:	6a 00                	push   $0x0
  801d56:	e8 6c f3 ff ff       	call   8010c7 <sys_page_map>
  801d5b:	83 c4 20             	add    $0x20,%esp
  801d5e:	85 c0                	test   %eax,%eax
  801d60:	78 7c                	js     801dde <spawn+0x368>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801d62:	83 ec 08             	sub    $0x8,%esp
  801d65:	68 00 00 40 00       	push   $0x400000
  801d6a:	6a 00                	push   $0x0
  801d6c:	e8 98 f3 ff ff       	call   801109 <sys_page_unmap>
  801d71:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801d74:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801d7a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801d80:	89 fe                	mov    %edi,%esi
  801d82:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801d88:	76 69                	jbe    801df3 <spawn+0x37d>
		if (i >= filesz) {
  801d8a:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801d90:	0f 87 37 ff ff ff    	ja     801ccd <spawn+0x257>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801d96:	83 ec 04             	sub    $0x4,%esp
  801d99:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801d9f:	53                   	push   %ebx
  801da0:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801da6:	e8 d9 f2 ff ff       	call   801084 <sys_page_alloc>
  801dab:	83 c4 10             	add    $0x10,%esp
  801dae:	85 c0                	test   %eax,%eax
  801db0:	79 c2                	jns    801d74 <spawn+0x2fe>
  801db2:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801db4:	83 ec 0c             	sub    $0xc,%esp
  801db7:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801dbd:	e8 43 f2 ff ff       	call   801005 <sys_env_destroy>
	close(fd);
  801dc2:	83 c4 04             	add    $0x4,%esp
  801dc5:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801dcb:	e8 8c f6 ff ff       	call   80145c <close>
	return r;
  801dd0:	83 c4 10             	add    $0x10,%esp
  801dd3:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801dd9:	e9 30 01 00 00       	jmp    801f0e <spawn+0x498>
				panic("spawn: sys_page_map data: %e", r);
  801dde:	50                   	push   %eax
  801ddf:	68 2f 2d 80 00       	push   $0x802d2f
  801de4:	68 25 01 00 00       	push   $0x125
  801de9:	68 23 2d 80 00       	push   $0x802d23
  801dee:	e8 4a e6 ff ff       	call   80043d <_panic>
  801df3:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801df9:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801e00:	83 c6 20             	add    $0x20,%esi
  801e03:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801e0a:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801e10:	7e 6d                	jle    801e7f <spawn+0x409>
		if (ph->p_type != ELF_PROG_LOAD)
  801e12:	83 3e 01             	cmpl   $0x1,(%esi)
  801e15:	75 e2                	jne    801df9 <spawn+0x383>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801e17:	8b 46 18             	mov    0x18(%esi),%eax
  801e1a:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801e1d:	83 f8 01             	cmp    $0x1,%eax
  801e20:	19 c0                	sbb    %eax,%eax
  801e22:	83 e0 fe             	and    $0xfffffffe,%eax
  801e25:	83 c0 07             	add    $0x7,%eax
  801e28:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801e2e:	8b 4e 04             	mov    0x4(%esi),%ecx
  801e31:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801e37:	8b 56 10             	mov    0x10(%esi),%edx
  801e3a:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801e40:	8b 7e 14             	mov    0x14(%esi),%edi
  801e43:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801e49:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801e4c:	89 d8                	mov    %ebx,%eax
  801e4e:	25 ff 0f 00 00       	and    $0xfff,%eax
  801e53:	74 1a                	je     801e6f <spawn+0x3f9>
		va -= i;
  801e55:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801e57:	01 c7                	add    %eax,%edi
  801e59:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801e5f:	01 c2                	add    %eax,%edx
  801e61:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801e67:	29 c1                	sub    %eax,%ecx
  801e69:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801e6f:	bf 00 00 00 00       	mov    $0x0,%edi
  801e74:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801e7a:	e9 01 ff ff ff       	jmp    801d80 <spawn+0x30a>
	close(fd);
  801e7f:	83 ec 0c             	sub    $0xc,%esp
  801e82:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801e88:	e8 cf f5 ff ff       	call   80145c <close>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801e8d:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801e94:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801e97:	83 c4 08             	add    $0x8,%esp
  801e9a:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801ea0:	50                   	push   %eax
  801ea1:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801ea7:	e8 e1 f2 ff ff       	call   80118d <sys_env_set_trapframe>
  801eac:	83 c4 10             	add    $0x10,%esp
  801eaf:	85 c0                	test   %eax,%eax
  801eb1:	78 25                	js     801ed8 <spawn+0x462>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801eb3:	83 ec 08             	sub    $0x8,%esp
  801eb6:	6a 02                	push   $0x2
  801eb8:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801ebe:	e8 88 f2 ff ff       	call   80114b <sys_env_set_status>
  801ec3:	83 c4 10             	add    $0x10,%esp
  801ec6:	85 c0                	test   %eax,%eax
  801ec8:	78 23                	js     801eed <spawn+0x477>
	return child;
  801eca:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801ed0:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801ed6:	eb 36                	jmp    801f0e <spawn+0x498>
		panic("sys_env_set_trapframe: %e", r);
  801ed8:	50                   	push   %eax
  801ed9:	68 4c 2d 80 00       	push   $0x802d4c
  801ede:	68 86 00 00 00       	push   $0x86
  801ee3:	68 23 2d 80 00       	push   $0x802d23
  801ee8:	e8 50 e5 ff ff       	call   80043d <_panic>
		panic("sys_env_set_status: %e", r);
  801eed:	50                   	push   %eax
  801eee:	68 66 2d 80 00       	push   $0x802d66
  801ef3:	68 89 00 00 00       	push   $0x89
  801ef8:	68 23 2d 80 00       	push   $0x802d23
  801efd:	e8 3b e5 ff ff       	call   80043d <_panic>
		return r;
  801f02:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801f08:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  801f0e:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801f14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f17:	5b                   	pop    %ebx
  801f18:	5e                   	pop    %esi
  801f19:	5f                   	pop    %edi
  801f1a:	5d                   	pop    %ebp
  801f1b:	c3                   	ret    
  801f1c:	89 c7                	mov    %eax,%edi
  801f1e:	e9 91 fe ff ff       	jmp    801db4 <spawn+0x33e>
  801f23:	89 c7                	mov    %eax,%edi
  801f25:	e9 8a fe ff ff       	jmp    801db4 <spawn+0x33e>
  801f2a:	89 c7                	mov    %eax,%edi
  801f2c:	e9 83 fe ff ff       	jmp    801db4 <spawn+0x33e>
		return -E_NO_MEM;
  801f31:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801f36:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801f3c:	eb d0                	jmp    801f0e <spawn+0x498>
	sys_page_unmap(0, UTEMP);
  801f3e:	83 ec 08             	sub    $0x8,%esp
  801f41:	68 00 00 40 00       	push   $0x400000
  801f46:	6a 00                	push   $0x0
  801f48:	e8 bc f1 ff ff       	call   801109 <sys_page_unmap>
  801f4d:	83 c4 10             	add    $0x10,%esp
  801f50:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801f56:	eb b6                	jmp    801f0e <spawn+0x498>

00801f58 <spawnl>:
{
  801f58:	55                   	push   %ebp
  801f59:	89 e5                	mov    %esp,%ebp
  801f5b:	57                   	push   %edi
  801f5c:	56                   	push   %esi
  801f5d:	53                   	push   %ebx
  801f5e:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801f61:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801f64:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801f69:	8d 4a 04             	lea    0x4(%edx),%ecx
  801f6c:	83 3a 00             	cmpl   $0x0,(%edx)
  801f6f:	74 07                	je     801f78 <spawnl+0x20>
		argc++;
  801f71:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801f74:	89 ca                	mov    %ecx,%edx
  801f76:	eb f1                	jmp    801f69 <spawnl+0x11>
	const char *argv[argc+2];
  801f78:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  801f7f:	83 e2 f0             	and    $0xfffffff0,%edx
  801f82:	29 d4                	sub    %edx,%esp
  801f84:	8d 54 24 03          	lea    0x3(%esp),%edx
  801f88:	c1 ea 02             	shr    $0x2,%edx
  801f8b:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801f92:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801f94:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f97:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801f9e:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801fa5:	00 
	va_start(vl, arg0);
  801fa6:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801fa9:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801fab:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb0:	eb 0b                	jmp    801fbd <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  801fb2:	83 c0 01             	add    $0x1,%eax
  801fb5:	8b 39                	mov    (%ecx),%edi
  801fb7:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801fba:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801fbd:	39 d0                	cmp    %edx,%eax
  801fbf:	75 f1                	jne    801fb2 <spawnl+0x5a>
	return spawn(prog, argv);
  801fc1:	83 ec 08             	sub    $0x8,%esp
  801fc4:	56                   	push   %esi
  801fc5:	ff 75 08             	pushl  0x8(%ebp)
  801fc8:	e8 a9 fa ff ff       	call   801a76 <spawn>
}
  801fcd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fd0:	5b                   	pop    %ebx
  801fd1:	5e                   	pop    %esi
  801fd2:	5f                   	pop    %edi
  801fd3:	5d                   	pop    %ebp
  801fd4:	c3                   	ret    

00801fd5 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801fd5:	55                   	push   %ebp
  801fd6:	89 e5                	mov    %esp,%ebp
  801fd8:	56                   	push   %esi
  801fd9:	53                   	push   %ebx
  801fda:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801fdd:	83 ec 0c             	sub    $0xc,%esp
  801fe0:	ff 75 08             	pushl  0x8(%ebp)
  801fe3:	e8 de f2 ff ff       	call   8012c6 <fd2data>
  801fe8:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801fea:	83 c4 08             	add    $0x8,%esp
  801fed:	68 a8 2d 80 00       	push   $0x802da8
  801ff2:	53                   	push   %ebx
  801ff3:	e8 9a ec ff ff       	call   800c92 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ff8:	8b 46 04             	mov    0x4(%esi),%eax
  801ffb:	2b 06                	sub    (%esi),%eax
  801ffd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802003:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80200a:	00 00 00 
	stat->st_dev = &devpipe;
  80200d:	c7 83 88 00 00 00 ac 	movl   $0x8047ac,0x88(%ebx)
  802014:	47 80 00 
	return 0;
}
  802017:	b8 00 00 00 00       	mov    $0x0,%eax
  80201c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80201f:	5b                   	pop    %ebx
  802020:	5e                   	pop    %esi
  802021:	5d                   	pop    %ebp
  802022:	c3                   	ret    

00802023 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
  802026:	53                   	push   %ebx
  802027:	83 ec 0c             	sub    $0xc,%esp
  80202a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80202d:	53                   	push   %ebx
  80202e:	6a 00                	push   $0x0
  802030:	e8 d4 f0 ff ff       	call   801109 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802035:	89 1c 24             	mov    %ebx,(%esp)
  802038:	e8 89 f2 ff ff       	call   8012c6 <fd2data>
  80203d:	83 c4 08             	add    $0x8,%esp
  802040:	50                   	push   %eax
  802041:	6a 00                	push   $0x0
  802043:	e8 c1 f0 ff ff       	call   801109 <sys_page_unmap>
}
  802048:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80204b:	c9                   	leave  
  80204c:	c3                   	ret    

0080204d <_pipeisclosed>:
{
  80204d:	55                   	push   %ebp
  80204e:	89 e5                	mov    %esp,%ebp
  802050:	57                   	push   %edi
  802051:	56                   	push   %esi
  802052:	53                   	push   %ebx
  802053:	83 ec 1c             	sub    $0x1c,%esp
  802056:	89 c7                	mov    %eax,%edi
  802058:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80205a:	a1 90 67 80 00       	mov    0x806790,%eax
  80205f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802062:	83 ec 0c             	sub    $0xc,%esp
  802065:	57                   	push   %edi
  802066:	e8 03 04 00 00       	call   80246e <pageref>
  80206b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80206e:	89 34 24             	mov    %esi,(%esp)
  802071:	e8 f8 03 00 00       	call   80246e <pageref>
		nn = thisenv->env_runs;
  802076:	8b 15 90 67 80 00    	mov    0x806790,%edx
  80207c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80207f:	83 c4 10             	add    $0x10,%esp
  802082:	39 cb                	cmp    %ecx,%ebx
  802084:	74 1b                	je     8020a1 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802086:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802089:	75 cf                	jne    80205a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80208b:	8b 42 58             	mov    0x58(%edx),%eax
  80208e:	6a 01                	push   $0x1
  802090:	50                   	push   %eax
  802091:	53                   	push   %ebx
  802092:	68 af 2d 80 00       	push   $0x802daf
  802097:	e8 97 e4 ff ff       	call   800533 <cprintf>
  80209c:	83 c4 10             	add    $0x10,%esp
  80209f:	eb b9                	jmp    80205a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8020a1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8020a4:	0f 94 c0             	sete   %al
  8020a7:	0f b6 c0             	movzbl %al,%eax
}
  8020aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020ad:	5b                   	pop    %ebx
  8020ae:	5e                   	pop    %esi
  8020af:	5f                   	pop    %edi
  8020b0:	5d                   	pop    %ebp
  8020b1:	c3                   	ret    

008020b2 <devpipe_write>:
{
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
  8020b5:	57                   	push   %edi
  8020b6:	56                   	push   %esi
  8020b7:	53                   	push   %ebx
  8020b8:	83 ec 28             	sub    $0x28,%esp
  8020bb:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8020be:	56                   	push   %esi
  8020bf:	e8 02 f2 ff ff       	call   8012c6 <fd2data>
  8020c4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8020c6:	83 c4 10             	add    $0x10,%esp
  8020c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8020ce:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8020d1:	74 4f                	je     802122 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8020d3:	8b 43 04             	mov    0x4(%ebx),%eax
  8020d6:	8b 0b                	mov    (%ebx),%ecx
  8020d8:	8d 51 20             	lea    0x20(%ecx),%edx
  8020db:	39 d0                	cmp    %edx,%eax
  8020dd:	72 14                	jb     8020f3 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8020df:	89 da                	mov    %ebx,%edx
  8020e1:	89 f0                	mov    %esi,%eax
  8020e3:	e8 65 ff ff ff       	call   80204d <_pipeisclosed>
  8020e8:	85 c0                	test   %eax,%eax
  8020ea:	75 3b                	jne    802127 <devpipe_write+0x75>
			sys_yield();
  8020ec:	e8 74 ef ff ff       	call   801065 <sys_yield>
  8020f1:	eb e0                	jmp    8020d3 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8020f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020f6:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8020fa:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8020fd:	89 c2                	mov    %eax,%edx
  8020ff:	c1 fa 1f             	sar    $0x1f,%edx
  802102:	89 d1                	mov    %edx,%ecx
  802104:	c1 e9 1b             	shr    $0x1b,%ecx
  802107:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80210a:	83 e2 1f             	and    $0x1f,%edx
  80210d:	29 ca                	sub    %ecx,%edx
  80210f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802113:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802117:	83 c0 01             	add    $0x1,%eax
  80211a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80211d:	83 c7 01             	add    $0x1,%edi
  802120:	eb ac                	jmp    8020ce <devpipe_write+0x1c>
	return i;
  802122:	8b 45 10             	mov    0x10(%ebp),%eax
  802125:	eb 05                	jmp    80212c <devpipe_write+0x7a>
				return 0;
  802127:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80212c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80212f:	5b                   	pop    %ebx
  802130:	5e                   	pop    %esi
  802131:	5f                   	pop    %edi
  802132:	5d                   	pop    %ebp
  802133:	c3                   	ret    

00802134 <devpipe_read>:
{
  802134:	55                   	push   %ebp
  802135:	89 e5                	mov    %esp,%ebp
  802137:	57                   	push   %edi
  802138:	56                   	push   %esi
  802139:	53                   	push   %ebx
  80213a:	83 ec 18             	sub    $0x18,%esp
  80213d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802140:	57                   	push   %edi
  802141:	e8 80 f1 ff ff       	call   8012c6 <fd2data>
  802146:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802148:	83 c4 10             	add    $0x10,%esp
  80214b:	be 00 00 00 00       	mov    $0x0,%esi
  802150:	3b 75 10             	cmp    0x10(%ebp),%esi
  802153:	75 14                	jne    802169 <devpipe_read+0x35>
	return i;
  802155:	8b 45 10             	mov    0x10(%ebp),%eax
  802158:	eb 02                	jmp    80215c <devpipe_read+0x28>
				return i;
  80215a:	89 f0                	mov    %esi,%eax
}
  80215c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80215f:	5b                   	pop    %ebx
  802160:	5e                   	pop    %esi
  802161:	5f                   	pop    %edi
  802162:	5d                   	pop    %ebp
  802163:	c3                   	ret    
			sys_yield();
  802164:	e8 fc ee ff ff       	call   801065 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802169:	8b 03                	mov    (%ebx),%eax
  80216b:	3b 43 04             	cmp    0x4(%ebx),%eax
  80216e:	75 18                	jne    802188 <devpipe_read+0x54>
			if (i > 0)
  802170:	85 f6                	test   %esi,%esi
  802172:	75 e6                	jne    80215a <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802174:	89 da                	mov    %ebx,%edx
  802176:	89 f8                	mov    %edi,%eax
  802178:	e8 d0 fe ff ff       	call   80204d <_pipeisclosed>
  80217d:	85 c0                	test   %eax,%eax
  80217f:	74 e3                	je     802164 <devpipe_read+0x30>
				return 0;
  802181:	b8 00 00 00 00       	mov    $0x0,%eax
  802186:	eb d4                	jmp    80215c <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802188:	99                   	cltd   
  802189:	c1 ea 1b             	shr    $0x1b,%edx
  80218c:	01 d0                	add    %edx,%eax
  80218e:	83 e0 1f             	and    $0x1f,%eax
  802191:	29 d0                	sub    %edx,%eax
  802193:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802198:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80219b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80219e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8021a1:	83 c6 01             	add    $0x1,%esi
  8021a4:	eb aa                	jmp    802150 <devpipe_read+0x1c>

008021a6 <pipe>:
{
  8021a6:	55                   	push   %ebp
  8021a7:	89 e5                	mov    %esp,%ebp
  8021a9:	56                   	push   %esi
  8021aa:	53                   	push   %ebx
  8021ab:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8021ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021b1:	50                   	push   %eax
  8021b2:	e8 26 f1 ff ff       	call   8012dd <fd_alloc>
  8021b7:	89 c3                	mov    %eax,%ebx
  8021b9:	83 c4 10             	add    $0x10,%esp
  8021bc:	85 c0                	test   %eax,%eax
  8021be:	0f 88 23 01 00 00    	js     8022e7 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021c4:	83 ec 04             	sub    $0x4,%esp
  8021c7:	68 07 04 00 00       	push   $0x407
  8021cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8021cf:	6a 00                	push   $0x0
  8021d1:	e8 ae ee ff ff       	call   801084 <sys_page_alloc>
  8021d6:	89 c3                	mov    %eax,%ebx
  8021d8:	83 c4 10             	add    $0x10,%esp
  8021db:	85 c0                	test   %eax,%eax
  8021dd:	0f 88 04 01 00 00    	js     8022e7 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8021e3:	83 ec 0c             	sub    $0xc,%esp
  8021e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8021e9:	50                   	push   %eax
  8021ea:	e8 ee f0 ff ff       	call   8012dd <fd_alloc>
  8021ef:	89 c3                	mov    %eax,%ebx
  8021f1:	83 c4 10             	add    $0x10,%esp
  8021f4:	85 c0                	test   %eax,%eax
  8021f6:	0f 88 db 00 00 00    	js     8022d7 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021fc:	83 ec 04             	sub    $0x4,%esp
  8021ff:	68 07 04 00 00       	push   $0x407
  802204:	ff 75 f0             	pushl  -0x10(%ebp)
  802207:	6a 00                	push   $0x0
  802209:	e8 76 ee ff ff       	call   801084 <sys_page_alloc>
  80220e:	89 c3                	mov    %eax,%ebx
  802210:	83 c4 10             	add    $0x10,%esp
  802213:	85 c0                	test   %eax,%eax
  802215:	0f 88 bc 00 00 00    	js     8022d7 <pipe+0x131>
	va = fd2data(fd0);
  80221b:	83 ec 0c             	sub    $0xc,%esp
  80221e:	ff 75 f4             	pushl  -0xc(%ebp)
  802221:	e8 a0 f0 ff ff       	call   8012c6 <fd2data>
  802226:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802228:	83 c4 0c             	add    $0xc,%esp
  80222b:	68 07 04 00 00       	push   $0x407
  802230:	50                   	push   %eax
  802231:	6a 00                	push   $0x0
  802233:	e8 4c ee ff ff       	call   801084 <sys_page_alloc>
  802238:	89 c3                	mov    %eax,%ebx
  80223a:	83 c4 10             	add    $0x10,%esp
  80223d:	85 c0                	test   %eax,%eax
  80223f:	0f 88 82 00 00 00    	js     8022c7 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802245:	83 ec 0c             	sub    $0xc,%esp
  802248:	ff 75 f0             	pushl  -0x10(%ebp)
  80224b:	e8 76 f0 ff ff       	call   8012c6 <fd2data>
  802250:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802257:	50                   	push   %eax
  802258:	6a 00                	push   $0x0
  80225a:	56                   	push   %esi
  80225b:	6a 00                	push   $0x0
  80225d:	e8 65 ee ff ff       	call   8010c7 <sys_page_map>
  802262:	89 c3                	mov    %eax,%ebx
  802264:	83 c4 20             	add    $0x20,%esp
  802267:	85 c0                	test   %eax,%eax
  802269:	78 4e                	js     8022b9 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80226b:	a1 ac 47 80 00       	mov    0x8047ac,%eax
  802270:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802273:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802275:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802278:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80227f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802282:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802284:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802287:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80228e:	83 ec 0c             	sub    $0xc,%esp
  802291:	ff 75 f4             	pushl  -0xc(%ebp)
  802294:	e8 1d f0 ff ff       	call   8012b6 <fd2num>
  802299:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80229c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80229e:	83 c4 04             	add    $0x4,%esp
  8022a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8022a4:	e8 0d f0 ff ff       	call   8012b6 <fd2num>
  8022a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022ac:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8022af:	83 c4 10             	add    $0x10,%esp
  8022b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8022b7:	eb 2e                	jmp    8022e7 <pipe+0x141>
	sys_page_unmap(0, va);
  8022b9:	83 ec 08             	sub    $0x8,%esp
  8022bc:	56                   	push   %esi
  8022bd:	6a 00                	push   $0x0
  8022bf:	e8 45 ee ff ff       	call   801109 <sys_page_unmap>
  8022c4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8022c7:	83 ec 08             	sub    $0x8,%esp
  8022ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8022cd:	6a 00                	push   $0x0
  8022cf:	e8 35 ee ff ff       	call   801109 <sys_page_unmap>
  8022d4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8022d7:	83 ec 08             	sub    $0x8,%esp
  8022da:	ff 75 f4             	pushl  -0xc(%ebp)
  8022dd:	6a 00                	push   $0x0
  8022df:	e8 25 ee ff ff       	call   801109 <sys_page_unmap>
  8022e4:	83 c4 10             	add    $0x10,%esp
}
  8022e7:	89 d8                	mov    %ebx,%eax
  8022e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022ec:	5b                   	pop    %ebx
  8022ed:	5e                   	pop    %esi
  8022ee:	5d                   	pop    %ebp
  8022ef:	c3                   	ret    

008022f0 <pipeisclosed>:
{
  8022f0:	55                   	push   %ebp
  8022f1:	89 e5                	mov    %esp,%ebp
  8022f3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022f9:	50                   	push   %eax
  8022fa:	ff 75 08             	pushl  0x8(%ebp)
  8022fd:	e8 2d f0 ff ff       	call   80132f <fd_lookup>
  802302:	83 c4 10             	add    $0x10,%esp
  802305:	85 c0                	test   %eax,%eax
  802307:	78 18                	js     802321 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802309:	83 ec 0c             	sub    $0xc,%esp
  80230c:	ff 75 f4             	pushl  -0xc(%ebp)
  80230f:	e8 b2 ef ff ff       	call   8012c6 <fd2data>
	return _pipeisclosed(fd, p);
  802314:	89 c2                	mov    %eax,%edx
  802316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802319:	e8 2f fd ff ff       	call   80204d <_pipeisclosed>
  80231e:	83 c4 10             	add    $0x10,%esp
}
  802321:	c9                   	leave  
  802322:	c3                   	ret    

00802323 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802323:	55                   	push   %ebp
  802324:	89 e5                	mov    %esp,%ebp
  802326:	56                   	push   %esi
  802327:	53                   	push   %ebx
  802328:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  80232b:	85 f6                	test   %esi,%esi
  80232d:	74 13                	je     802342 <wait+0x1f>
	e = &envs[ENVX(envid)];
  80232f:	89 f3                	mov    %esi,%ebx
  802331:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802337:	c1 e3 07             	shl    $0x7,%ebx
  80233a:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802340:	eb 1b                	jmp    80235d <wait+0x3a>
	assert(envid != 0);
  802342:	68 c7 2d 80 00       	push   $0x802dc7
  802347:	68 e8 2c 80 00       	push   $0x802ce8
  80234c:	6a 09                	push   $0x9
  80234e:	68 d2 2d 80 00       	push   $0x802dd2
  802353:	e8 e5 e0 ff ff       	call   80043d <_panic>
		sys_yield();
  802358:	e8 08 ed ff ff       	call   801065 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80235d:	8b 43 48             	mov    0x48(%ebx),%eax
  802360:	39 f0                	cmp    %esi,%eax
  802362:	75 07                	jne    80236b <wait+0x48>
  802364:	8b 43 54             	mov    0x54(%ebx),%eax
  802367:	85 c0                	test   %eax,%eax
  802369:	75 ed                	jne    802358 <wait+0x35>
}
  80236b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80236e:	5b                   	pop    %ebx
  80236f:	5e                   	pop    %esi
  802370:	5d                   	pop    %ebp
  802371:	c3                   	ret    

00802372 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802372:	55                   	push   %ebp
  802373:	89 e5                	mov    %esp,%ebp
  802375:	56                   	push   %esi
  802376:	53                   	push   %ebx
  802377:	8b 75 08             	mov    0x8(%ebp),%esi
  80237a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80237d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  802380:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802382:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802387:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80238a:	83 ec 0c             	sub    $0xc,%esp
  80238d:	50                   	push   %eax
  80238e:	e8 a1 ee ff ff       	call   801234 <sys_ipc_recv>
	if(ret < 0){
  802393:	83 c4 10             	add    $0x10,%esp
  802396:	85 c0                	test   %eax,%eax
  802398:	78 2b                	js     8023c5 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80239a:	85 f6                	test   %esi,%esi
  80239c:	74 0a                	je     8023a8 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  80239e:	a1 90 67 80 00       	mov    0x806790,%eax
  8023a3:	8b 40 74             	mov    0x74(%eax),%eax
  8023a6:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8023a8:	85 db                	test   %ebx,%ebx
  8023aa:	74 0a                	je     8023b6 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8023ac:	a1 90 67 80 00       	mov    0x806790,%eax
  8023b1:	8b 40 78             	mov    0x78(%eax),%eax
  8023b4:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8023b6:	a1 90 67 80 00       	mov    0x806790,%eax
  8023bb:	8b 40 70             	mov    0x70(%eax),%eax
}
  8023be:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023c1:	5b                   	pop    %ebx
  8023c2:	5e                   	pop    %esi
  8023c3:	5d                   	pop    %ebp
  8023c4:	c3                   	ret    
		if(from_env_store)
  8023c5:	85 f6                	test   %esi,%esi
  8023c7:	74 06                	je     8023cf <ipc_recv+0x5d>
			*from_env_store = 0;
  8023c9:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8023cf:	85 db                	test   %ebx,%ebx
  8023d1:	74 eb                	je     8023be <ipc_recv+0x4c>
			*perm_store = 0;
  8023d3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8023d9:	eb e3                	jmp    8023be <ipc_recv+0x4c>

008023db <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8023db:	55                   	push   %ebp
  8023dc:	89 e5                	mov    %esp,%ebp
  8023de:	57                   	push   %edi
  8023df:	56                   	push   %esi
  8023e0:	53                   	push   %ebx
  8023e1:	83 ec 0c             	sub    $0xc,%esp
  8023e4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8023e7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8023ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8023ed:	85 db                	test   %ebx,%ebx
  8023ef:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8023f4:	0f 44 d8             	cmove  %eax,%ebx
  8023f7:	eb 05                	jmp    8023fe <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8023f9:	e8 67 ec ff ff       	call   801065 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8023fe:	ff 75 14             	pushl  0x14(%ebp)
  802401:	53                   	push   %ebx
  802402:	56                   	push   %esi
  802403:	57                   	push   %edi
  802404:	e8 08 ee ff ff       	call   801211 <sys_ipc_try_send>
  802409:	83 c4 10             	add    $0x10,%esp
  80240c:	85 c0                	test   %eax,%eax
  80240e:	74 1b                	je     80242b <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802410:	79 e7                	jns    8023f9 <ipc_send+0x1e>
  802412:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802415:	74 e2                	je     8023f9 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802417:	83 ec 04             	sub    $0x4,%esp
  80241a:	68 dd 2d 80 00       	push   $0x802ddd
  80241f:	6a 49                	push   $0x49
  802421:	68 f2 2d 80 00       	push   $0x802df2
  802426:	e8 12 e0 ff ff       	call   80043d <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80242b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80242e:	5b                   	pop    %ebx
  80242f:	5e                   	pop    %esi
  802430:	5f                   	pop    %edi
  802431:	5d                   	pop    %ebp
  802432:	c3                   	ret    

00802433 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802433:	55                   	push   %ebp
  802434:	89 e5                	mov    %esp,%ebp
  802436:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802439:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80243e:	89 c2                	mov    %eax,%edx
  802440:	c1 e2 07             	shl    $0x7,%edx
  802443:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802449:	8b 52 50             	mov    0x50(%edx),%edx
  80244c:	39 ca                	cmp    %ecx,%edx
  80244e:	74 11                	je     802461 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802450:	83 c0 01             	add    $0x1,%eax
  802453:	3d 00 04 00 00       	cmp    $0x400,%eax
  802458:	75 e4                	jne    80243e <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80245a:	b8 00 00 00 00       	mov    $0x0,%eax
  80245f:	eb 0b                	jmp    80246c <ipc_find_env+0x39>
			return envs[i].env_id;
  802461:	c1 e0 07             	shl    $0x7,%eax
  802464:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802469:	8b 40 48             	mov    0x48(%eax),%eax
}
  80246c:	5d                   	pop    %ebp
  80246d:	c3                   	ret    

0080246e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80246e:	55                   	push   %ebp
  80246f:	89 e5                	mov    %esp,%ebp
  802471:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802474:	89 d0                	mov    %edx,%eax
  802476:	c1 e8 16             	shr    $0x16,%eax
  802479:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802480:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802485:	f6 c1 01             	test   $0x1,%cl
  802488:	74 1d                	je     8024a7 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80248a:	c1 ea 0c             	shr    $0xc,%edx
  80248d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802494:	f6 c2 01             	test   $0x1,%dl
  802497:	74 0e                	je     8024a7 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802499:	c1 ea 0c             	shr    $0xc,%edx
  80249c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8024a3:	ef 
  8024a4:	0f b7 c0             	movzwl %ax,%eax
}
  8024a7:	5d                   	pop    %ebp
  8024a8:	c3                   	ret    
  8024a9:	66 90                	xchg   %ax,%ax
  8024ab:	66 90                	xchg   %ax,%ax
  8024ad:	66 90                	xchg   %ax,%ax
  8024af:	90                   	nop

008024b0 <__udivdi3>:
  8024b0:	55                   	push   %ebp
  8024b1:	57                   	push   %edi
  8024b2:	56                   	push   %esi
  8024b3:	53                   	push   %ebx
  8024b4:	83 ec 1c             	sub    $0x1c,%esp
  8024b7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8024bb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8024bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8024c3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8024c7:	85 d2                	test   %edx,%edx
  8024c9:	75 4d                	jne    802518 <__udivdi3+0x68>
  8024cb:	39 f3                	cmp    %esi,%ebx
  8024cd:	76 19                	jbe    8024e8 <__udivdi3+0x38>
  8024cf:	31 ff                	xor    %edi,%edi
  8024d1:	89 e8                	mov    %ebp,%eax
  8024d3:	89 f2                	mov    %esi,%edx
  8024d5:	f7 f3                	div    %ebx
  8024d7:	89 fa                	mov    %edi,%edx
  8024d9:	83 c4 1c             	add    $0x1c,%esp
  8024dc:	5b                   	pop    %ebx
  8024dd:	5e                   	pop    %esi
  8024de:	5f                   	pop    %edi
  8024df:	5d                   	pop    %ebp
  8024e0:	c3                   	ret    
  8024e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024e8:	89 d9                	mov    %ebx,%ecx
  8024ea:	85 db                	test   %ebx,%ebx
  8024ec:	75 0b                	jne    8024f9 <__udivdi3+0x49>
  8024ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8024f3:	31 d2                	xor    %edx,%edx
  8024f5:	f7 f3                	div    %ebx
  8024f7:	89 c1                	mov    %eax,%ecx
  8024f9:	31 d2                	xor    %edx,%edx
  8024fb:	89 f0                	mov    %esi,%eax
  8024fd:	f7 f1                	div    %ecx
  8024ff:	89 c6                	mov    %eax,%esi
  802501:	89 e8                	mov    %ebp,%eax
  802503:	89 f7                	mov    %esi,%edi
  802505:	f7 f1                	div    %ecx
  802507:	89 fa                	mov    %edi,%edx
  802509:	83 c4 1c             	add    $0x1c,%esp
  80250c:	5b                   	pop    %ebx
  80250d:	5e                   	pop    %esi
  80250e:	5f                   	pop    %edi
  80250f:	5d                   	pop    %ebp
  802510:	c3                   	ret    
  802511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802518:	39 f2                	cmp    %esi,%edx
  80251a:	77 1c                	ja     802538 <__udivdi3+0x88>
  80251c:	0f bd fa             	bsr    %edx,%edi
  80251f:	83 f7 1f             	xor    $0x1f,%edi
  802522:	75 2c                	jne    802550 <__udivdi3+0xa0>
  802524:	39 f2                	cmp    %esi,%edx
  802526:	72 06                	jb     80252e <__udivdi3+0x7e>
  802528:	31 c0                	xor    %eax,%eax
  80252a:	39 eb                	cmp    %ebp,%ebx
  80252c:	77 a9                	ja     8024d7 <__udivdi3+0x27>
  80252e:	b8 01 00 00 00       	mov    $0x1,%eax
  802533:	eb a2                	jmp    8024d7 <__udivdi3+0x27>
  802535:	8d 76 00             	lea    0x0(%esi),%esi
  802538:	31 ff                	xor    %edi,%edi
  80253a:	31 c0                	xor    %eax,%eax
  80253c:	89 fa                	mov    %edi,%edx
  80253e:	83 c4 1c             	add    $0x1c,%esp
  802541:	5b                   	pop    %ebx
  802542:	5e                   	pop    %esi
  802543:	5f                   	pop    %edi
  802544:	5d                   	pop    %ebp
  802545:	c3                   	ret    
  802546:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80254d:	8d 76 00             	lea    0x0(%esi),%esi
  802550:	89 f9                	mov    %edi,%ecx
  802552:	b8 20 00 00 00       	mov    $0x20,%eax
  802557:	29 f8                	sub    %edi,%eax
  802559:	d3 e2                	shl    %cl,%edx
  80255b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80255f:	89 c1                	mov    %eax,%ecx
  802561:	89 da                	mov    %ebx,%edx
  802563:	d3 ea                	shr    %cl,%edx
  802565:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802569:	09 d1                	or     %edx,%ecx
  80256b:	89 f2                	mov    %esi,%edx
  80256d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802571:	89 f9                	mov    %edi,%ecx
  802573:	d3 e3                	shl    %cl,%ebx
  802575:	89 c1                	mov    %eax,%ecx
  802577:	d3 ea                	shr    %cl,%edx
  802579:	89 f9                	mov    %edi,%ecx
  80257b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80257f:	89 eb                	mov    %ebp,%ebx
  802581:	d3 e6                	shl    %cl,%esi
  802583:	89 c1                	mov    %eax,%ecx
  802585:	d3 eb                	shr    %cl,%ebx
  802587:	09 de                	or     %ebx,%esi
  802589:	89 f0                	mov    %esi,%eax
  80258b:	f7 74 24 08          	divl   0x8(%esp)
  80258f:	89 d6                	mov    %edx,%esi
  802591:	89 c3                	mov    %eax,%ebx
  802593:	f7 64 24 0c          	mull   0xc(%esp)
  802597:	39 d6                	cmp    %edx,%esi
  802599:	72 15                	jb     8025b0 <__udivdi3+0x100>
  80259b:	89 f9                	mov    %edi,%ecx
  80259d:	d3 e5                	shl    %cl,%ebp
  80259f:	39 c5                	cmp    %eax,%ebp
  8025a1:	73 04                	jae    8025a7 <__udivdi3+0xf7>
  8025a3:	39 d6                	cmp    %edx,%esi
  8025a5:	74 09                	je     8025b0 <__udivdi3+0x100>
  8025a7:	89 d8                	mov    %ebx,%eax
  8025a9:	31 ff                	xor    %edi,%edi
  8025ab:	e9 27 ff ff ff       	jmp    8024d7 <__udivdi3+0x27>
  8025b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8025b3:	31 ff                	xor    %edi,%edi
  8025b5:	e9 1d ff ff ff       	jmp    8024d7 <__udivdi3+0x27>
  8025ba:	66 90                	xchg   %ax,%ax
  8025bc:	66 90                	xchg   %ax,%ax
  8025be:	66 90                	xchg   %ax,%ax

008025c0 <__umoddi3>:
  8025c0:	55                   	push   %ebp
  8025c1:	57                   	push   %edi
  8025c2:	56                   	push   %esi
  8025c3:	53                   	push   %ebx
  8025c4:	83 ec 1c             	sub    $0x1c,%esp
  8025c7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8025cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8025cf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8025d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8025d7:	89 da                	mov    %ebx,%edx
  8025d9:	85 c0                	test   %eax,%eax
  8025db:	75 43                	jne    802620 <__umoddi3+0x60>
  8025dd:	39 df                	cmp    %ebx,%edi
  8025df:	76 17                	jbe    8025f8 <__umoddi3+0x38>
  8025e1:	89 f0                	mov    %esi,%eax
  8025e3:	f7 f7                	div    %edi
  8025e5:	89 d0                	mov    %edx,%eax
  8025e7:	31 d2                	xor    %edx,%edx
  8025e9:	83 c4 1c             	add    $0x1c,%esp
  8025ec:	5b                   	pop    %ebx
  8025ed:	5e                   	pop    %esi
  8025ee:	5f                   	pop    %edi
  8025ef:	5d                   	pop    %ebp
  8025f0:	c3                   	ret    
  8025f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025f8:	89 fd                	mov    %edi,%ebp
  8025fa:	85 ff                	test   %edi,%edi
  8025fc:	75 0b                	jne    802609 <__umoddi3+0x49>
  8025fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802603:	31 d2                	xor    %edx,%edx
  802605:	f7 f7                	div    %edi
  802607:	89 c5                	mov    %eax,%ebp
  802609:	89 d8                	mov    %ebx,%eax
  80260b:	31 d2                	xor    %edx,%edx
  80260d:	f7 f5                	div    %ebp
  80260f:	89 f0                	mov    %esi,%eax
  802611:	f7 f5                	div    %ebp
  802613:	89 d0                	mov    %edx,%eax
  802615:	eb d0                	jmp    8025e7 <__umoddi3+0x27>
  802617:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80261e:	66 90                	xchg   %ax,%ax
  802620:	89 f1                	mov    %esi,%ecx
  802622:	39 d8                	cmp    %ebx,%eax
  802624:	76 0a                	jbe    802630 <__umoddi3+0x70>
  802626:	89 f0                	mov    %esi,%eax
  802628:	83 c4 1c             	add    $0x1c,%esp
  80262b:	5b                   	pop    %ebx
  80262c:	5e                   	pop    %esi
  80262d:	5f                   	pop    %edi
  80262e:	5d                   	pop    %ebp
  80262f:	c3                   	ret    
  802630:	0f bd e8             	bsr    %eax,%ebp
  802633:	83 f5 1f             	xor    $0x1f,%ebp
  802636:	75 20                	jne    802658 <__umoddi3+0x98>
  802638:	39 d8                	cmp    %ebx,%eax
  80263a:	0f 82 b0 00 00 00    	jb     8026f0 <__umoddi3+0x130>
  802640:	39 f7                	cmp    %esi,%edi
  802642:	0f 86 a8 00 00 00    	jbe    8026f0 <__umoddi3+0x130>
  802648:	89 c8                	mov    %ecx,%eax
  80264a:	83 c4 1c             	add    $0x1c,%esp
  80264d:	5b                   	pop    %ebx
  80264e:	5e                   	pop    %esi
  80264f:	5f                   	pop    %edi
  802650:	5d                   	pop    %ebp
  802651:	c3                   	ret    
  802652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802658:	89 e9                	mov    %ebp,%ecx
  80265a:	ba 20 00 00 00       	mov    $0x20,%edx
  80265f:	29 ea                	sub    %ebp,%edx
  802661:	d3 e0                	shl    %cl,%eax
  802663:	89 44 24 08          	mov    %eax,0x8(%esp)
  802667:	89 d1                	mov    %edx,%ecx
  802669:	89 f8                	mov    %edi,%eax
  80266b:	d3 e8                	shr    %cl,%eax
  80266d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802671:	89 54 24 04          	mov    %edx,0x4(%esp)
  802675:	8b 54 24 04          	mov    0x4(%esp),%edx
  802679:	09 c1                	or     %eax,%ecx
  80267b:	89 d8                	mov    %ebx,%eax
  80267d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802681:	89 e9                	mov    %ebp,%ecx
  802683:	d3 e7                	shl    %cl,%edi
  802685:	89 d1                	mov    %edx,%ecx
  802687:	d3 e8                	shr    %cl,%eax
  802689:	89 e9                	mov    %ebp,%ecx
  80268b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80268f:	d3 e3                	shl    %cl,%ebx
  802691:	89 c7                	mov    %eax,%edi
  802693:	89 d1                	mov    %edx,%ecx
  802695:	89 f0                	mov    %esi,%eax
  802697:	d3 e8                	shr    %cl,%eax
  802699:	89 e9                	mov    %ebp,%ecx
  80269b:	89 fa                	mov    %edi,%edx
  80269d:	d3 e6                	shl    %cl,%esi
  80269f:	09 d8                	or     %ebx,%eax
  8026a1:	f7 74 24 08          	divl   0x8(%esp)
  8026a5:	89 d1                	mov    %edx,%ecx
  8026a7:	89 f3                	mov    %esi,%ebx
  8026a9:	f7 64 24 0c          	mull   0xc(%esp)
  8026ad:	89 c6                	mov    %eax,%esi
  8026af:	89 d7                	mov    %edx,%edi
  8026b1:	39 d1                	cmp    %edx,%ecx
  8026b3:	72 06                	jb     8026bb <__umoddi3+0xfb>
  8026b5:	75 10                	jne    8026c7 <__umoddi3+0x107>
  8026b7:	39 c3                	cmp    %eax,%ebx
  8026b9:	73 0c                	jae    8026c7 <__umoddi3+0x107>
  8026bb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8026bf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8026c3:	89 d7                	mov    %edx,%edi
  8026c5:	89 c6                	mov    %eax,%esi
  8026c7:	89 ca                	mov    %ecx,%edx
  8026c9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026ce:	29 f3                	sub    %esi,%ebx
  8026d0:	19 fa                	sbb    %edi,%edx
  8026d2:	89 d0                	mov    %edx,%eax
  8026d4:	d3 e0                	shl    %cl,%eax
  8026d6:	89 e9                	mov    %ebp,%ecx
  8026d8:	d3 eb                	shr    %cl,%ebx
  8026da:	d3 ea                	shr    %cl,%edx
  8026dc:	09 d8                	or     %ebx,%eax
  8026de:	83 c4 1c             	add    $0x1c,%esp
  8026e1:	5b                   	pop    %ebx
  8026e2:	5e                   	pop    %esi
  8026e3:	5f                   	pop    %edi
  8026e4:	5d                   	pop    %ebp
  8026e5:	c3                   	ret    
  8026e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026ed:	8d 76 00             	lea    0x0(%esi),%esi
  8026f0:	89 da                	mov    %ebx,%edx
  8026f2:	29 fe                	sub    %edi,%esi
  8026f4:	19 c2                	sbb    %eax,%edx
  8026f6:	89 f1                	mov    %esi,%ecx
  8026f8:	89 c8                	mov    %ecx,%eax
  8026fa:	e9 4b ff ff ff       	jmp    80264a <__umoddi3+0x8a>
