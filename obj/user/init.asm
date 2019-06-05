
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
  80006d:	68 60 2d 80 00       	push   $0x802d60
  800072:	e8 d1 04 00 00       	call   800548 <cprintf>

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
  8000a0:	68 24 2e 80 00       	push   $0x802e24
  8000a5:	e8 9e 04 00 00       	call   800548 <cprintf>
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
  8000ca:	68 60 2e 80 00       	push   $0x802e60
  8000cf:	e8 74 04 00 00       	call   800548 <cprintf>
  8000d4:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  8000d7:	83 ec 08             	sub    $0x8,%esp
  8000da:	68 9c 2d 80 00       	push   $0x802d9c
  8000df:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8000e5:	50                   	push   %eax
  8000e6:	e8 dc 0b 00 00       	call   800cc7 <strcat>
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
  800100:	68 a8 2d 80 00       	push   $0x802da8
  800105:	56                   	push   %esi
  800106:	e8 bc 0b 00 00       	call   800cc7 <strcat>
		strcat(args, argv[i]);
  80010b:	83 c4 08             	add    $0x8,%esp
  80010e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800111:	ff 34 98             	pushl  (%eax,%ebx,4)
  800114:	56                   	push   %esi
  800115:	e8 ad 0b 00 00       	call   800cc7 <strcat>
		strcat(args, "'");
  80011a:	83 c4 08             	add    $0x8,%esp
  80011d:	68 a9 2d 80 00       	push   $0x802da9
  800122:	56                   	push   %esi
  800123:	e8 9f 0b 00 00       	call   800cc7 <strcat>
	for (i = 0; i < argc; i++) {
  800128:	83 c3 01             	add    $0x1,%ebx
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	eb c9                	jmp    8000f9 <umain+0x9b>
		cprintf("init: data seems okay\n");
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	68 6f 2d 80 00       	push   $0x802d6f
  800138:	e8 0b 04 00 00       	call   800548 <cprintf>
  80013d:	83 c4 10             	add    $0x10,%esp
  800140:	e9 68 ff ff ff       	jmp    8000ad <umain+0x4f>
		cprintf("init: bss seems okay\n");
  800145:	83 ec 0c             	sub    $0xc,%esp
  800148:	68 86 2d 80 00       	push   $0x802d86
  80014d:	e8 f6 03 00 00       	call   800548 <cprintf>
  800152:	83 c4 10             	add    $0x10,%esp
  800155:	eb 80                	jmp    8000d7 <umain+0x79>
	}
	cprintf("%s\n", args);
  800157:	83 ec 08             	sub    $0x8,%esp
  80015a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800160:	50                   	push   %eax
  800161:	68 c6 2e 80 00       	push   $0x802ec6
  800166:	e8 dd 03 00 00       	call   800548 <cprintf>

	cprintf("init: running sh\n");
  80016b:	c7 04 24 ab 2d 80 00 	movl   $0x802dab,(%esp)
  800172:	e8 d1 03 00 00       	call   800548 <cprintf>

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  800177:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80017e:	e8 96 13 00 00       	call   801519 <close>
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
  800192:	68 d6 2d 80 00       	push   $0x802dd6
  800197:	6a 39                	push   $0x39
  800199:	68 ca 2d 80 00       	push   $0x802dca
  80019e:	e8 af 02 00 00       	call   800452 <_panic>
		panic("opencons: %e", r);
  8001a3:	50                   	push   %eax
  8001a4:	68 bd 2d 80 00       	push   $0x802dbd
  8001a9:	6a 37                	push   $0x37
  8001ab:	68 ca 2d 80 00       	push   $0x802dca
  8001b0:	e8 9d 02 00 00       	call   800452 <_panic>
	if ((r = dup(0, 1)) < 0)
  8001b5:	83 ec 08             	sub    $0x8,%esp
  8001b8:	6a 01                	push   $0x1
  8001ba:	6a 00                	push   $0x0
  8001bc:	e8 aa 13 00 00       	call   80156b <dup>
  8001c1:	83 c4 10             	add    $0x10,%esp
  8001c4:	85 c0                	test   %eax,%eax
  8001c6:	79 23                	jns    8001eb <umain+0x18d>
		panic("dup: %e", r);
  8001c8:	50                   	push   %eax
  8001c9:	68 f0 2d 80 00       	push   $0x802df0
  8001ce:	6a 3b                	push   $0x3b
  8001d0:	68 ca 2d 80 00       	push   $0x802dca
  8001d5:	e8 78 02 00 00       	call   800452 <_panic>
	while (1) {
		cprintf("init: starting sh\n");
		r = spawnl("/sh", "sh", (char*)0);
		if (r < 0) {
			cprintf("init: spawn sh: %e\n", r);
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	50                   	push   %eax
  8001de:	68 0f 2e 80 00       	push   $0x802e0f
  8001e3:	e8 60 03 00 00       	call   800548 <cprintf>
			continue;
  8001e8:	83 c4 10             	add    $0x10,%esp
		cprintf("init: starting sh\n");
  8001eb:	83 ec 0c             	sub    $0xc,%esp
  8001ee:	68 f8 2d 80 00       	push   $0x802df8
  8001f3:	e8 50 03 00 00       	call   800548 <cprintf>
		r = spawnl("/sh", "sh", (char*)0);
  8001f8:	83 c4 0c             	add    $0xc,%esp
  8001fb:	6a 00                	push   $0x0
  8001fd:	68 0c 2e 80 00       	push   $0x802e0c
  800202:	68 0b 2e 80 00       	push   $0x802e0b
  800207:	e8 1b 1f 00 00       	call   802127 <spawnl>
		if (r < 0) {
  80020c:	83 c4 10             	add    $0x10,%esp
  80020f:	85 c0                	test   %eax,%eax
  800211:	78 c7                	js     8001da <umain+0x17c>
		}
		wait(r);
  800213:	83 ec 0c             	sub    $0xc,%esp
  800216:	50                   	push   %eax
  800217:	e8 4f 27 00 00       	call   80296b <wait>
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
  80022d:	68 8f 2e 80 00       	push   $0x802e8f
  800232:	ff 75 0c             	pushl  0xc(%ebp)
  800235:	e8 6d 0a 00 00       	call   800ca7 <strcpy>
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
  800278:	e8 b8 0b 00 00       	call   800e35 <memmove>
		sys_cputs(buf, m);
  80027d:	83 c4 08             	add    $0x8,%esp
  800280:	53                   	push   %ebx
  800281:	57                   	push   %edi
  800282:	e8 56 0d 00 00       	call   800fdd <sys_cputs>
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
  8002a9:	e8 4d 0d 00 00       	call   800ffb <sys_cgetc>
  8002ae:	85 c0                	test   %eax,%eax
  8002b0:	75 07                	jne    8002b9 <devcons_read+0x21>
		sys_yield();
  8002b2:	e8 c3 0d 00 00       	call   80107a <sys_yield>
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
  8002e5:	e8 f3 0c 00 00       	call   800fdd <sys_cputs>
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
  8002fd:	e8 55 13 00 00       	call   801657 <read>
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
  800325:	e8 bd 10 00 00       	call   8013e7 <fd_lookup>
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
  80034e:	e8 42 10 00 00       	call   801395 <fd_alloc>
  800353:	83 c4 10             	add    $0x10,%esp
  800356:	85 c0                	test   %eax,%eax
  800358:	78 3a                	js     800394 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80035a:	83 ec 04             	sub    $0x4,%esp
  80035d:	68 07 04 00 00       	push   $0x407
  800362:	ff 75 f4             	pushl  -0xc(%ebp)
  800365:	6a 00                	push   $0x0
  800367:	e8 2d 0d 00 00       	call   801099 <sys_page_alloc>
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
  80038c:	e8 dd 0f 00 00       	call   80136e <fd2num>
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
  8003a9:	e8 ad 0c 00 00       	call   80105b <sys_getenvid>
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

	cprintf("in libmain.c call umain!\n");
  80040d:	83 ec 0c             	sub    $0xc,%esp
  800410:	68 9b 2e 80 00       	push   $0x802e9b
  800415:	e8 2e 01 00 00       	call   800548 <cprintf>
	// call user main routine
	umain(argc, argv);
  80041a:	83 c4 08             	add    $0x8,%esp
  80041d:	ff 75 0c             	pushl  0xc(%ebp)
  800420:	ff 75 08             	pushl  0x8(%ebp)
  800423:	e8 36 fc ff ff       	call   80005e <umain>

	// exit gracefully
	exit();
  800428:	e8 0b 00 00 00       	call   800438 <exit>
}
  80042d:	83 c4 10             	add    $0x10,%esp
  800430:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800433:	5b                   	pop    %ebx
  800434:	5e                   	pop    %esi
  800435:	5f                   	pop    %edi
  800436:	5d                   	pop    %ebp
  800437:	c3                   	ret    

00800438 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800438:	55                   	push   %ebp
  800439:	89 e5                	mov    %esp,%ebp
  80043b:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80043e:	e8 03 11 00 00       	call   801546 <close_all>
	sys_env_destroy(0);
  800443:	83 ec 0c             	sub    $0xc,%esp
  800446:	6a 00                	push   $0x0
  800448:	e8 cd 0b 00 00       	call   80101a <sys_env_destroy>
}
  80044d:	83 c4 10             	add    $0x10,%esp
  800450:	c9                   	leave  
  800451:	c3                   	ret    

00800452 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800452:	55                   	push   %ebp
  800453:	89 e5                	mov    %esp,%ebp
  800455:	56                   	push   %esi
  800456:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800457:	a1 90 77 80 00       	mov    0x807790,%eax
  80045c:	8b 40 48             	mov    0x48(%eax),%eax
  80045f:	83 ec 04             	sub    $0x4,%esp
  800462:	68 f0 2e 80 00       	push   $0x802ef0
  800467:	50                   	push   %eax
  800468:	68 bf 2e 80 00       	push   $0x802ebf
  80046d:	e8 d6 00 00 00       	call   800548 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800472:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800475:	8b 35 8c 57 80 00    	mov    0x80578c,%esi
  80047b:	e8 db 0b 00 00       	call   80105b <sys_getenvid>
  800480:	83 c4 04             	add    $0x4,%esp
  800483:	ff 75 0c             	pushl  0xc(%ebp)
  800486:	ff 75 08             	pushl  0x8(%ebp)
  800489:	56                   	push   %esi
  80048a:	50                   	push   %eax
  80048b:	68 cc 2e 80 00       	push   $0x802ecc
  800490:	e8 b3 00 00 00       	call   800548 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800495:	83 c4 18             	add    $0x18,%esp
  800498:	53                   	push   %ebx
  800499:	ff 75 10             	pushl  0x10(%ebp)
  80049c:	e8 56 00 00 00       	call   8004f7 <vcprintf>
	cprintf("\n");
  8004a1:	c7 04 24 b3 2e 80 00 	movl   $0x802eb3,(%esp)
  8004a8:	e8 9b 00 00 00       	call   800548 <cprintf>
  8004ad:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8004b0:	cc                   	int3   
  8004b1:	eb fd                	jmp    8004b0 <_panic+0x5e>

008004b3 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8004b3:	55                   	push   %ebp
  8004b4:	89 e5                	mov    %esp,%ebp
  8004b6:	53                   	push   %ebx
  8004b7:	83 ec 04             	sub    $0x4,%esp
  8004ba:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8004bd:	8b 13                	mov    (%ebx),%edx
  8004bf:	8d 42 01             	lea    0x1(%edx),%eax
  8004c2:	89 03                	mov    %eax,(%ebx)
  8004c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004c7:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8004cb:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004d0:	74 09                	je     8004db <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8004d2:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8004d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004d9:	c9                   	leave  
  8004da:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8004db:	83 ec 08             	sub    $0x8,%esp
  8004de:	68 ff 00 00 00       	push   $0xff
  8004e3:	8d 43 08             	lea    0x8(%ebx),%eax
  8004e6:	50                   	push   %eax
  8004e7:	e8 f1 0a 00 00       	call   800fdd <sys_cputs>
		b->idx = 0;
  8004ec:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8004f2:	83 c4 10             	add    $0x10,%esp
  8004f5:	eb db                	jmp    8004d2 <putch+0x1f>

008004f7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8004f7:	55                   	push   %ebp
  8004f8:	89 e5                	mov    %esp,%ebp
  8004fa:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800500:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800507:	00 00 00 
	b.cnt = 0;
  80050a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800511:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800514:	ff 75 0c             	pushl  0xc(%ebp)
  800517:	ff 75 08             	pushl  0x8(%ebp)
  80051a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800520:	50                   	push   %eax
  800521:	68 b3 04 80 00       	push   $0x8004b3
  800526:	e8 4a 01 00 00       	call   800675 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80052b:	83 c4 08             	add    $0x8,%esp
  80052e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800534:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80053a:	50                   	push   %eax
  80053b:	e8 9d 0a 00 00       	call   800fdd <sys_cputs>

	return b.cnt;
}
  800540:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800546:	c9                   	leave  
  800547:	c3                   	ret    

00800548 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800548:	55                   	push   %ebp
  800549:	89 e5                	mov    %esp,%ebp
  80054b:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80054e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800551:	50                   	push   %eax
  800552:	ff 75 08             	pushl  0x8(%ebp)
  800555:	e8 9d ff ff ff       	call   8004f7 <vcprintf>
	va_end(ap);

	return cnt;
}
  80055a:	c9                   	leave  
  80055b:	c3                   	ret    

0080055c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80055c:	55                   	push   %ebp
  80055d:	89 e5                	mov    %esp,%ebp
  80055f:	57                   	push   %edi
  800560:	56                   	push   %esi
  800561:	53                   	push   %ebx
  800562:	83 ec 1c             	sub    $0x1c,%esp
  800565:	89 c6                	mov    %eax,%esi
  800567:	89 d7                	mov    %edx,%edi
  800569:	8b 45 08             	mov    0x8(%ebp),%eax
  80056c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80056f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800572:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800575:	8b 45 10             	mov    0x10(%ebp),%eax
  800578:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80057b:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80057f:	74 2c                	je     8005ad <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800581:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800584:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80058b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80058e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800591:	39 c2                	cmp    %eax,%edx
  800593:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800596:	73 43                	jae    8005db <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800598:	83 eb 01             	sub    $0x1,%ebx
  80059b:	85 db                	test   %ebx,%ebx
  80059d:	7e 6c                	jle    80060b <printnum+0xaf>
				putch(padc, putdat);
  80059f:	83 ec 08             	sub    $0x8,%esp
  8005a2:	57                   	push   %edi
  8005a3:	ff 75 18             	pushl  0x18(%ebp)
  8005a6:	ff d6                	call   *%esi
  8005a8:	83 c4 10             	add    $0x10,%esp
  8005ab:	eb eb                	jmp    800598 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8005ad:	83 ec 0c             	sub    $0xc,%esp
  8005b0:	6a 20                	push   $0x20
  8005b2:	6a 00                	push   $0x0
  8005b4:	50                   	push   %eax
  8005b5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005b8:	ff 75 e0             	pushl  -0x20(%ebp)
  8005bb:	89 fa                	mov    %edi,%edx
  8005bd:	89 f0                	mov    %esi,%eax
  8005bf:	e8 98 ff ff ff       	call   80055c <printnum>
		while (--width > 0)
  8005c4:	83 c4 20             	add    $0x20,%esp
  8005c7:	83 eb 01             	sub    $0x1,%ebx
  8005ca:	85 db                	test   %ebx,%ebx
  8005cc:	7e 65                	jle    800633 <printnum+0xd7>
			putch(padc, putdat);
  8005ce:	83 ec 08             	sub    $0x8,%esp
  8005d1:	57                   	push   %edi
  8005d2:	6a 20                	push   $0x20
  8005d4:	ff d6                	call   *%esi
  8005d6:	83 c4 10             	add    $0x10,%esp
  8005d9:	eb ec                	jmp    8005c7 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8005db:	83 ec 0c             	sub    $0xc,%esp
  8005de:	ff 75 18             	pushl  0x18(%ebp)
  8005e1:	83 eb 01             	sub    $0x1,%ebx
  8005e4:	53                   	push   %ebx
  8005e5:	50                   	push   %eax
  8005e6:	83 ec 08             	sub    $0x8,%esp
  8005e9:	ff 75 dc             	pushl  -0x24(%ebp)
  8005ec:	ff 75 d8             	pushl  -0x28(%ebp)
  8005ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005f2:	ff 75 e0             	pushl  -0x20(%ebp)
  8005f5:	e8 06 25 00 00       	call   802b00 <__udivdi3>
  8005fa:	83 c4 18             	add    $0x18,%esp
  8005fd:	52                   	push   %edx
  8005fe:	50                   	push   %eax
  8005ff:	89 fa                	mov    %edi,%edx
  800601:	89 f0                	mov    %esi,%eax
  800603:	e8 54 ff ff ff       	call   80055c <printnum>
  800608:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80060b:	83 ec 08             	sub    $0x8,%esp
  80060e:	57                   	push   %edi
  80060f:	83 ec 04             	sub    $0x4,%esp
  800612:	ff 75 dc             	pushl  -0x24(%ebp)
  800615:	ff 75 d8             	pushl  -0x28(%ebp)
  800618:	ff 75 e4             	pushl  -0x1c(%ebp)
  80061b:	ff 75 e0             	pushl  -0x20(%ebp)
  80061e:	e8 ed 25 00 00       	call   802c10 <__umoddi3>
  800623:	83 c4 14             	add    $0x14,%esp
  800626:	0f be 80 f7 2e 80 00 	movsbl 0x802ef7(%eax),%eax
  80062d:	50                   	push   %eax
  80062e:	ff d6                	call   *%esi
  800630:	83 c4 10             	add    $0x10,%esp
	}
}
  800633:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800636:	5b                   	pop    %ebx
  800637:	5e                   	pop    %esi
  800638:	5f                   	pop    %edi
  800639:	5d                   	pop    %ebp
  80063a:	c3                   	ret    

0080063b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80063b:	55                   	push   %ebp
  80063c:	89 e5                	mov    %esp,%ebp
  80063e:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800641:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800645:	8b 10                	mov    (%eax),%edx
  800647:	3b 50 04             	cmp    0x4(%eax),%edx
  80064a:	73 0a                	jae    800656 <sprintputch+0x1b>
		*b->buf++ = ch;
  80064c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80064f:	89 08                	mov    %ecx,(%eax)
  800651:	8b 45 08             	mov    0x8(%ebp),%eax
  800654:	88 02                	mov    %al,(%edx)
}
  800656:	5d                   	pop    %ebp
  800657:	c3                   	ret    

00800658 <printfmt>:
{
  800658:	55                   	push   %ebp
  800659:	89 e5                	mov    %esp,%ebp
  80065b:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80065e:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800661:	50                   	push   %eax
  800662:	ff 75 10             	pushl  0x10(%ebp)
  800665:	ff 75 0c             	pushl  0xc(%ebp)
  800668:	ff 75 08             	pushl  0x8(%ebp)
  80066b:	e8 05 00 00 00       	call   800675 <vprintfmt>
}
  800670:	83 c4 10             	add    $0x10,%esp
  800673:	c9                   	leave  
  800674:	c3                   	ret    

00800675 <vprintfmt>:
{
  800675:	55                   	push   %ebp
  800676:	89 e5                	mov    %esp,%ebp
  800678:	57                   	push   %edi
  800679:	56                   	push   %esi
  80067a:	53                   	push   %ebx
  80067b:	83 ec 3c             	sub    $0x3c,%esp
  80067e:	8b 75 08             	mov    0x8(%ebp),%esi
  800681:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800684:	8b 7d 10             	mov    0x10(%ebp),%edi
  800687:	e9 32 04 00 00       	jmp    800abe <vprintfmt+0x449>
		padc = ' ';
  80068c:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800690:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800697:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80069e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8006a5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8006ac:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8006b3:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8006b8:	8d 47 01             	lea    0x1(%edi),%eax
  8006bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006be:	0f b6 17             	movzbl (%edi),%edx
  8006c1:	8d 42 dd             	lea    -0x23(%edx),%eax
  8006c4:	3c 55                	cmp    $0x55,%al
  8006c6:	0f 87 12 05 00 00    	ja     800bde <vprintfmt+0x569>
  8006cc:	0f b6 c0             	movzbl %al,%eax
  8006cf:	ff 24 85 e0 30 80 00 	jmp    *0x8030e0(,%eax,4)
  8006d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8006d9:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8006dd:	eb d9                	jmp    8006b8 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8006df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8006e2:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8006e6:	eb d0                	jmp    8006b8 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8006e8:	0f b6 d2             	movzbl %dl,%edx
  8006eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8006ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f3:	89 75 08             	mov    %esi,0x8(%ebp)
  8006f6:	eb 03                	jmp    8006fb <vprintfmt+0x86>
  8006f8:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8006fb:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8006fe:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800702:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800705:	8d 72 d0             	lea    -0x30(%edx),%esi
  800708:	83 fe 09             	cmp    $0x9,%esi
  80070b:	76 eb                	jbe    8006f8 <vprintfmt+0x83>
  80070d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800710:	8b 75 08             	mov    0x8(%ebp),%esi
  800713:	eb 14                	jmp    800729 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800715:	8b 45 14             	mov    0x14(%ebp),%eax
  800718:	8b 00                	mov    (%eax),%eax
  80071a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071d:	8b 45 14             	mov    0x14(%ebp),%eax
  800720:	8d 40 04             	lea    0x4(%eax),%eax
  800723:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800726:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800729:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80072d:	79 89                	jns    8006b8 <vprintfmt+0x43>
				width = precision, precision = -1;
  80072f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800732:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800735:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80073c:	e9 77 ff ff ff       	jmp    8006b8 <vprintfmt+0x43>
  800741:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800744:	85 c0                	test   %eax,%eax
  800746:	0f 48 c1             	cmovs  %ecx,%eax
  800749:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80074c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80074f:	e9 64 ff ff ff       	jmp    8006b8 <vprintfmt+0x43>
  800754:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800757:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80075e:	e9 55 ff ff ff       	jmp    8006b8 <vprintfmt+0x43>
			lflag++;
  800763:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800767:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80076a:	e9 49 ff ff ff       	jmp    8006b8 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80076f:	8b 45 14             	mov    0x14(%ebp),%eax
  800772:	8d 78 04             	lea    0x4(%eax),%edi
  800775:	83 ec 08             	sub    $0x8,%esp
  800778:	53                   	push   %ebx
  800779:	ff 30                	pushl  (%eax)
  80077b:	ff d6                	call   *%esi
			break;
  80077d:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800780:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800783:	e9 33 03 00 00       	jmp    800abb <vprintfmt+0x446>
			err = va_arg(ap, int);
  800788:	8b 45 14             	mov    0x14(%ebp),%eax
  80078b:	8d 78 04             	lea    0x4(%eax),%edi
  80078e:	8b 00                	mov    (%eax),%eax
  800790:	99                   	cltd   
  800791:	31 d0                	xor    %edx,%eax
  800793:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800795:	83 f8 10             	cmp    $0x10,%eax
  800798:	7f 23                	jg     8007bd <vprintfmt+0x148>
  80079a:	8b 14 85 40 32 80 00 	mov    0x803240(,%eax,4),%edx
  8007a1:	85 d2                	test   %edx,%edx
  8007a3:	74 18                	je     8007bd <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8007a5:	52                   	push   %edx
  8007a6:	68 59 33 80 00       	push   $0x803359
  8007ab:	53                   	push   %ebx
  8007ac:	56                   	push   %esi
  8007ad:	e8 a6 fe ff ff       	call   800658 <printfmt>
  8007b2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8007b5:	89 7d 14             	mov    %edi,0x14(%ebp)
  8007b8:	e9 fe 02 00 00       	jmp    800abb <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8007bd:	50                   	push   %eax
  8007be:	68 0f 2f 80 00       	push   $0x802f0f
  8007c3:	53                   	push   %ebx
  8007c4:	56                   	push   %esi
  8007c5:	e8 8e fe ff ff       	call   800658 <printfmt>
  8007ca:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8007cd:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8007d0:	e9 e6 02 00 00       	jmp    800abb <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8007d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d8:	83 c0 04             	add    $0x4,%eax
  8007db:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8007de:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e1:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8007e3:	85 c9                	test   %ecx,%ecx
  8007e5:	b8 08 2f 80 00       	mov    $0x802f08,%eax
  8007ea:	0f 45 c1             	cmovne %ecx,%eax
  8007ed:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8007f0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007f4:	7e 06                	jle    8007fc <vprintfmt+0x187>
  8007f6:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8007fa:	75 0d                	jne    800809 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007fc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8007ff:	89 c7                	mov    %eax,%edi
  800801:	03 45 e0             	add    -0x20(%ebp),%eax
  800804:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800807:	eb 53                	jmp    80085c <vprintfmt+0x1e7>
  800809:	83 ec 08             	sub    $0x8,%esp
  80080c:	ff 75 d8             	pushl  -0x28(%ebp)
  80080f:	50                   	push   %eax
  800810:	e8 71 04 00 00       	call   800c86 <strnlen>
  800815:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800818:	29 c1                	sub    %eax,%ecx
  80081a:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80081d:	83 c4 10             	add    $0x10,%esp
  800820:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800822:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800826:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800829:	eb 0f                	jmp    80083a <vprintfmt+0x1c5>
					putch(padc, putdat);
  80082b:	83 ec 08             	sub    $0x8,%esp
  80082e:	53                   	push   %ebx
  80082f:	ff 75 e0             	pushl  -0x20(%ebp)
  800832:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800834:	83 ef 01             	sub    $0x1,%edi
  800837:	83 c4 10             	add    $0x10,%esp
  80083a:	85 ff                	test   %edi,%edi
  80083c:	7f ed                	jg     80082b <vprintfmt+0x1b6>
  80083e:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800841:	85 c9                	test   %ecx,%ecx
  800843:	b8 00 00 00 00       	mov    $0x0,%eax
  800848:	0f 49 c1             	cmovns %ecx,%eax
  80084b:	29 c1                	sub    %eax,%ecx
  80084d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800850:	eb aa                	jmp    8007fc <vprintfmt+0x187>
					putch(ch, putdat);
  800852:	83 ec 08             	sub    $0x8,%esp
  800855:	53                   	push   %ebx
  800856:	52                   	push   %edx
  800857:	ff d6                	call   *%esi
  800859:	83 c4 10             	add    $0x10,%esp
  80085c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80085f:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800861:	83 c7 01             	add    $0x1,%edi
  800864:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800868:	0f be d0             	movsbl %al,%edx
  80086b:	85 d2                	test   %edx,%edx
  80086d:	74 4b                	je     8008ba <vprintfmt+0x245>
  80086f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800873:	78 06                	js     80087b <vprintfmt+0x206>
  800875:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800879:	78 1e                	js     800899 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80087b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80087f:	74 d1                	je     800852 <vprintfmt+0x1dd>
  800881:	0f be c0             	movsbl %al,%eax
  800884:	83 e8 20             	sub    $0x20,%eax
  800887:	83 f8 5e             	cmp    $0x5e,%eax
  80088a:	76 c6                	jbe    800852 <vprintfmt+0x1dd>
					putch('?', putdat);
  80088c:	83 ec 08             	sub    $0x8,%esp
  80088f:	53                   	push   %ebx
  800890:	6a 3f                	push   $0x3f
  800892:	ff d6                	call   *%esi
  800894:	83 c4 10             	add    $0x10,%esp
  800897:	eb c3                	jmp    80085c <vprintfmt+0x1e7>
  800899:	89 cf                	mov    %ecx,%edi
  80089b:	eb 0e                	jmp    8008ab <vprintfmt+0x236>
				putch(' ', putdat);
  80089d:	83 ec 08             	sub    $0x8,%esp
  8008a0:	53                   	push   %ebx
  8008a1:	6a 20                	push   $0x20
  8008a3:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8008a5:	83 ef 01             	sub    $0x1,%edi
  8008a8:	83 c4 10             	add    $0x10,%esp
  8008ab:	85 ff                	test   %edi,%edi
  8008ad:	7f ee                	jg     80089d <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8008af:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8008b2:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b5:	e9 01 02 00 00       	jmp    800abb <vprintfmt+0x446>
  8008ba:	89 cf                	mov    %ecx,%edi
  8008bc:	eb ed                	jmp    8008ab <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8008be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8008c1:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8008c8:	e9 eb fd ff ff       	jmp    8006b8 <vprintfmt+0x43>
	if (lflag >= 2)
  8008cd:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8008d1:	7f 21                	jg     8008f4 <vprintfmt+0x27f>
	else if (lflag)
  8008d3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008d7:	74 68                	je     800941 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8008d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dc:	8b 00                	mov    (%eax),%eax
  8008de:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008e1:	89 c1                	mov    %eax,%ecx
  8008e3:	c1 f9 1f             	sar    $0x1f,%ecx
  8008e6:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8008e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ec:	8d 40 04             	lea    0x4(%eax),%eax
  8008ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f2:	eb 17                	jmp    80090b <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8008f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f7:	8b 50 04             	mov    0x4(%eax),%edx
  8008fa:	8b 00                	mov    (%eax),%eax
  8008fc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008ff:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800902:	8b 45 14             	mov    0x14(%ebp),%eax
  800905:	8d 40 08             	lea    0x8(%eax),%eax
  800908:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80090b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80090e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800911:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800914:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800917:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80091b:	78 3f                	js     80095c <vprintfmt+0x2e7>
			base = 10;
  80091d:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800922:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800926:	0f 84 71 01 00 00    	je     800a9d <vprintfmt+0x428>
				putch('+', putdat);
  80092c:	83 ec 08             	sub    $0x8,%esp
  80092f:	53                   	push   %ebx
  800930:	6a 2b                	push   $0x2b
  800932:	ff d6                	call   *%esi
  800934:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800937:	b8 0a 00 00 00       	mov    $0xa,%eax
  80093c:	e9 5c 01 00 00       	jmp    800a9d <vprintfmt+0x428>
		return va_arg(*ap, int);
  800941:	8b 45 14             	mov    0x14(%ebp),%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800949:	89 c1                	mov    %eax,%ecx
  80094b:	c1 f9 1f             	sar    $0x1f,%ecx
  80094e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800951:	8b 45 14             	mov    0x14(%ebp),%eax
  800954:	8d 40 04             	lea    0x4(%eax),%eax
  800957:	89 45 14             	mov    %eax,0x14(%ebp)
  80095a:	eb af                	jmp    80090b <vprintfmt+0x296>
				putch('-', putdat);
  80095c:	83 ec 08             	sub    $0x8,%esp
  80095f:	53                   	push   %ebx
  800960:	6a 2d                	push   $0x2d
  800962:	ff d6                	call   *%esi
				num = -(long long) num;
  800964:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800967:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80096a:	f7 d8                	neg    %eax
  80096c:	83 d2 00             	adc    $0x0,%edx
  80096f:	f7 da                	neg    %edx
  800971:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800974:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800977:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80097a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80097f:	e9 19 01 00 00       	jmp    800a9d <vprintfmt+0x428>
	if (lflag >= 2)
  800984:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800988:	7f 29                	jg     8009b3 <vprintfmt+0x33e>
	else if (lflag)
  80098a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80098e:	74 44                	je     8009d4 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800990:	8b 45 14             	mov    0x14(%ebp),%eax
  800993:	8b 00                	mov    (%eax),%eax
  800995:	ba 00 00 00 00       	mov    $0x0,%edx
  80099a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80099d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a3:	8d 40 04             	lea    0x4(%eax),%eax
  8009a6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009a9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009ae:	e9 ea 00 00 00       	jmp    800a9d <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8009b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b6:	8b 50 04             	mov    0x4(%eax),%edx
  8009b9:	8b 00                	mov    (%eax),%eax
  8009bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009be:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c4:	8d 40 08             	lea    0x8(%eax),%eax
  8009c7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009ca:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009cf:	e9 c9 00 00 00       	jmp    800a9d <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8009d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d7:	8b 00                	mov    (%eax),%eax
  8009d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8009de:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009e1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e7:	8d 40 04             	lea    0x4(%eax),%eax
  8009ea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009ed:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009f2:	e9 a6 00 00 00       	jmp    800a9d <vprintfmt+0x428>
			putch('0', putdat);
  8009f7:	83 ec 08             	sub    $0x8,%esp
  8009fa:	53                   	push   %ebx
  8009fb:	6a 30                	push   $0x30
  8009fd:	ff d6                	call   *%esi
	if (lflag >= 2)
  8009ff:	83 c4 10             	add    $0x10,%esp
  800a02:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800a06:	7f 26                	jg     800a2e <vprintfmt+0x3b9>
	else if (lflag)
  800a08:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a0c:	74 3e                	je     800a4c <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800a0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a11:	8b 00                	mov    (%eax),%eax
  800a13:	ba 00 00 00 00       	mov    $0x0,%edx
  800a18:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a1b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a21:	8d 40 04             	lea    0x4(%eax),%eax
  800a24:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a27:	b8 08 00 00 00       	mov    $0x8,%eax
  800a2c:	eb 6f                	jmp    800a9d <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800a2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a31:	8b 50 04             	mov    0x4(%eax),%edx
  800a34:	8b 00                	mov    (%eax),%eax
  800a36:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a39:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3f:	8d 40 08             	lea    0x8(%eax),%eax
  800a42:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a45:	b8 08 00 00 00       	mov    $0x8,%eax
  800a4a:	eb 51                	jmp    800a9d <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800a4c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4f:	8b 00                	mov    (%eax),%eax
  800a51:	ba 00 00 00 00       	mov    $0x0,%edx
  800a56:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a59:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5f:	8d 40 04             	lea    0x4(%eax),%eax
  800a62:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a65:	b8 08 00 00 00       	mov    $0x8,%eax
  800a6a:	eb 31                	jmp    800a9d <vprintfmt+0x428>
			putch('0', putdat);
  800a6c:	83 ec 08             	sub    $0x8,%esp
  800a6f:	53                   	push   %ebx
  800a70:	6a 30                	push   $0x30
  800a72:	ff d6                	call   *%esi
			putch('x', putdat);
  800a74:	83 c4 08             	add    $0x8,%esp
  800a77:	53                   	push   %ebx
  800a78:	6a 78                	push   $0x78
  800a7a:	ff d6                	call   *%esi
			num = (unsigned long long)
  800a7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7f:	8b 00                	mov    (%eax),%eax
  800a81:	ba 00 00 00 00       	mov    $0x0,%edx
  800a86:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a89:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800a8c:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a92:	8d 40 04             	lea    0x4(%eax),%eax
  800a95:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a98:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800a9d:	83 ec 0c             	sub    $0xc,%esp
  800aa0:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800aa4:	52                   	push   %edx
  800aa5:	ff 75 e0             	pushl  -0x20(%ebp)
  800aa8:	50                   	push   %eax
  800aa9:	ff 75 dc             	pushl  -0x24(%ebp)
  800aac:	ff 75 d8             	pushl  -0x28(%ebp)
  800aaf:	89 da                	mov    %ebx,%edx
  800ab1:	89 f0                	mov    %esi,%eax
  800ab3:	e8 a4 fa ff ff       	call   80055c <printnum>
			break;
  800ab8:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800abb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800abe:	83 c7 01             	add    $0x1,%edi
  800ac1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800ac5:	83 f8 25             	cmp    $0x25,%eax
  800ac8:	0f 84 be fb ff ff    	je     80068c <vprintfmt+0x17>
			if (ch == '\0')
  800ace:	85 c0                	test   %eax,%eax
  800ad0:	0f 84 28 01 00 00    	je     800bfe <vprintfmt+0x589>
			putch(ch, putdat);
  800ad6:	83 ec 08             	sub    $0x8,%esp
  800ad9:	53                   	push   %ebx
  800ada:	50                   	push   %eax
  800adb:	ff d6                	call   *%esi
  800add:	83 c4 10             	add    $0x10,%esp
  800ae0:	eb dc                	jmp    800abe <vprintfmt+0x449>
	if (lflag >= 2)
  800ae2:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800ae6:	7f 26                	jg     800b0e <vprintfmt+0x499>
	else if (lflag)
  800ae8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800aec:	74 41                	je     800b2f <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800aee:	8b 45 14             	mov    0x14(%ebp),%eax
  800af1:	8b 00                	mov    (%eax),%eax
  800af3:	ba 00 00 00 00       	mov    $0x0,%edx
  800af8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800afb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800afe:	8b 45 14             	mov    0x14(%ebp),%eax
  800b01:	8d 40 04             	lea    0x4(%eax),%eax
  800b04:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b07:	b8 10 00 00 00       	mov    $0x10,%eax
  800b0c:	eb 8f                	jmp    800a9d <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800b0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b11:	8b 50 04             	mov    0x4(%eax),%edx
  800b14:	8b 00                	mov    (%eax),%eax
  800b16:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b19:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1f:	8d 40 08             	lea    0x8(%eax),%eax
  800b22:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b25:	b8 10 00 00 00       	mov    $0x10,%eax
  800b2a:	e9 6e ff ff ff       	jmp    800a9d <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800b2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b32:	8b 00                	mov    (%eax),%eax
  800b34:	ba 00 00 00 00       	mov    $0x0,%edx
  800b39:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b3c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b42:	8d 40 04             	lea    0x4(%eax),%eax
  800b45:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b48:	b8 10 00 00 00       	mov    $0x10,%eax
  800b4d:	e9 4b ff ff ff       	jmp    800a9d <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800b52:	8b 45 14             	mov    0x14(%ebp),%eax
  800b55:	83 c0 04             	add    $0x4,%eax
  800b58:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b5b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5e:	8b 00                	mov    (%eax),%eax
  800b60:	85 c0                	test   %eax,%eax
  800b62:	74 14                	je     800b78 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800b64:	8b 13                	mov    (%ebx),%edx
  800b66:	83 fa 7f             	cmp    $0x7f,%edx
  800b69:	7f 37                	jg     800ba2 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800b6b:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800b6d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b70:	89 45 14             	mov    %eax,0x14(%ebp)
  800b73:	e9 43 ff ff ff       	jmp    800abb <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800b78:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b7d:	bf 2d 30 80 00       	mov    $0x80302d,%edi
							putch(ch, putdat);
  800b82:	83 ec 08             	sub    $0x8,%esp
  800b85:	53                   	push   %ebx
  800b86:	50                   	push   %eax
  800b87:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800b89:	83 c7 01             	add    $0x1,%edi
  800b8c:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800b90:	83 c4 10             	add    $0x10,%esp
  800b93:	85 c0                	test   %eax,%eax
  800b95:	75 eb                	jne    800b82 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800b97:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b9a:	89 45 14             	mov    %eax,0x14(%ebp)
  800b9d:	e9 19 ff ff ff       	jmp    800abb <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800ba2:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800ba4:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ba9:	bf 65 30 80 00       	mov    $0x803065,%edi
							putch(ch, putdat);
  800bae:	83 ec 08             	sub    $0x8,%esp
  800bb1:	53                   	push   %ebx
  800bb2:	50                   	push   %eax
  800bb3:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800bb5:	83 c7 01             	add    $0x1,%edi
  800bb8:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800bbc:	83 c4 10             	add    $0x10,%esp
  800bbf:	85 c0                	test   %eax,%eax
  800bc1:	75 eb                	jne    800bae <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800bc3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800bc6:	89 45 14             	mov    %eax,0x14(%ebp)
  800bc9:	e9 ed fe ff ff       	jmp    800abb <vprintfmt+0x446>
			putch(ch, putdat);
  800bce:	83 ec 08             	sub    $0x8,%esp
  800bd1:	53                   	push   %ebx
  800bd2:	6a 25                	push   $0x25
  800bd4:	ff d6                	call   *%esi
			break;
  800bd6:	83 c4 10             	add    $0x10,%esp
  800bd9:	e9 dd fe ff ff       	jmp    800abb <vprintfmt+0x446>
			putch('%', putdat);
  800bde:	83 ec 08             	sub    $0x8,%esp
  800be1:	53                   	push   %ebx
  800be2:	6a 25                	push   $0x25
  800be4:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800be6:	83 c4 10             	add    $0x10,%esp
  800be9:	89 f8                	mov    %edi,%eax
  800beb:	eb 03                	jmp    800bf0 <vprintfmt+0x57b>
  800bed:	83 e8 01             	sub    $0x1,%eax
  800bf0:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800bf4:	75 f7                	jne    800bed <vprintfmt+0x578>
  800bf6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800bf9:	e9 bd fe ff ff       	jmp    800abb <vprintfmt+0x446>
}
  800bfe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c01:	5b                   	pop    %ebx
  800c02:	5e                   	pop    %esi
  800c03:	5f                   	pop    %edi
  800c04:	5d                   	pop    %ebp
  800c05:	c3                   	ret    

00800c06 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c06:	55                   	push   %ebp
  800c07:	89 e5                	mov    %esp,%ebp
  800c09:	83 ec 18             	sub    $0x18,%esp
  800c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c12:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c15:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800c19:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800c1c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c23:	85 c0                	test   %eax,%eax
  800c25:	74 26                	je     800c4d <vsnprintf+0x47>
  800c27:	85 d2                	test   %edx,%edx
  800c29:	7e 22                	jle    800c4d <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c2b:	ff 75 14             	pushl  0x14(%ebp)
  800c2e:	ff 75 10             	pushl  0x10(%ebp)
  800c31:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c34:	50                   	push   %eax
  800c35:	68 3b 06 80 00       	push   $0x80063b
  800c3a:	e8 36 fa ff ff       	call   800675 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c42:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c48:	83 c4 10             	add    $0x10,%esp
}
  800c4b:	c9                   	leave  
  800c4c:	c3                   	ret    
		return -E_INVAL;
  800c4d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c52:	eb f7                	jmp    800c4b <vsnprintf+0x45>

00800c54 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c5a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800c5d:	50                   	push   %eax
  800c5e:	ff 75 10             	pushl  0x10(%ebp)
  800c61:	ff 75 0c             	pushl  0xc(%ebp)
  800c64:	ff 75 08             	pushl  0x8(%ebp)
  800c67:	e8 9a ff ff ff       	call   800c06 <vsnprintf>
	va_end(ap);

	return rc;
}
  800c6c:	c9                   	leave  
  800c6d:	c3                   	ret    

00800c6e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800c74:	b8 00 00 00 00       	mov    $0x0,%eax
  800c79:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800c7d:	74 05                	je     800c84 <strlen+0x16>
		n++;
  800c7f:	83 c0 01             	add    $0x1,%eax
  800c82:	eb f5                	jmp    800c79 <strlen+0xb>
	return n;
}
  800c84:	5d                   	pop    %ebp
  800c85:	c3                   	ret    

00800c86 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
  800c89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c8c:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c8f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c94:	39 c2                	cmp    %eax,%edx
  800c96:	74 0d                	je     800ca5 <strnlen+0x1f>
  800c98:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800c9c:	74 05                	je     800ca3 <strnlen+0x1d>
		n++;
  800c9e:	83 c2 01             	add    $0x1,%edx
  800ca1:	eb f1                	jmp    800c94 <strnlen+0xe>
  800ca3:	89 d0                	mov    %edx,%eax
	return n;
}
  800ca5:	5d                   	pop    %ebp
  800ca6:	c3                   	ret    

00800ca7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ca7:	55                   	push   %ebp
  800ca8:	89 e5                	mov    %esp,%ebp
  800caa:	53                   	push   %ebx
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800cb1:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb6:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800cba:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800cbd:	83 c2 01             	add    $0x1,%edx
  800cc0:	84 c9                	test   %cl,%cl
  800cc2:	75 f2                	jne    800cb6 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800cc4:	5b                   	pop    %ebx
  800cc5:	5d                   	pop    %ebp
  800cc6:	c3                   	ret    

00800cc7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	53                   	push   %ebx
  800ccb:	83 ec 10             	sub    $0x10,%esp
  800cce:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800cd1:	53                   	push   %ebx
  800cd2:	e8 97 ff ff ff       	call   800c6e <strlen>
  800cd7:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800cda:	ff 75 0c             	pushl  0xc(%ebp)
  800cdd:	01 d8                	add    %ebx,%eax
  800cdf:	50                   	push   %eax
  800ce0:	e8 c2 ff ff ff       	call   800ca7 <strcpy>
	return dst;
}
  800ce5:	89 d8                	mov    %ebx,%eax
  800ce7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cea:	c9                   	leave  
  800ceb:	c3                   	ret    

00800cec <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800cec:	55                   	push   %ebp
  800ced:	89 e5                	mov    %esp,%ebp
  800cef:	56                   	push   %esi
  800cf0:	53                   	push   %ebx
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf7:	89 c6                	mov    %eax,%esi
  800cf9:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cfc:	89 c2                	mov    %eax,%edx
  800cfe:	39 f2                	cmp    %esi,%edx
  800d00:	74 11                	je     800d13 <strncpy+0x27>
		*dst++ = *src;
  800d02:	83 c2 01             	add    $0x1,%edx
  800d05:	0f b6 19             	movzbl (%ecx),%ebx
  800d08:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800d0b:	80 fb 01             	cmp    $0x1,%bl
  800d0e:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800d11:	eb eb                	jmp    800cfe <strncpy+0x12>
	}
	return ret;
}
  800d13:	5b                   	pop    %ebx
  800d14:	5e                   	pop    %esi
  800d15:	5d                   	pop    %ebp
  800d16:	c3                   	ret    

00800d17 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
  800d1a:	56                   	push   %esi
  800d1b:	53                   	push   %ebx
  800d1c:	8b 75 08             	mov    0x8(%ebp),%esi
  800d1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d22:	8b 55 10             	mov    0x10(%ebp),%edx
  800d25:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800d27:	85 d2                	test   %edx,%edx
  800d29:	74 21                	je     800d4c <strlcpy+0x35>
  800d2b:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800d2f:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800d31:	39 c2                	cmp    %eax,%edx
  800d33:	74 14                	je     800d49 <strlcpy+0x32>
  800d35:	0f b6 19             	movzbl (%ecx),%ebx
  800d38:	84 db                	test   %bl,%bl
  800d3a:	74 0b                	je     800d47 <strlcpy+0x30>
			*dst++ = *src++;
  800d3c:	83 c1 01             	add    $0x1,%ecx
  800d3f:	83 c2 01             	add    $0x1,%edx
  800d42:	88 5a ff             	mov    %bl,-0x1(%edx)
  800d45:	eb ea                	jmp    800d31 <strlcpy+0x1a>
  800d47:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800d49:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d4c:	29 f0                	sub    %esi,%eax
}
  800d4e:	5b                   	pop    %ebx
  800d4f:	5e                   	pop    %esi
  800d50:	5d                   	pop    %ebp
  800d51:	c3                   	ret    

00800d52 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d52:	55                   	push   %ebp
  800d53:	89 e5                	mov    %esp,%ebp
  800d55:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d58:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800d5b:	0f b6 01             	movzbl (%ecx),%eax
  800d5e:	84 c0                	test   %al,%al
  800d60:	74 0c                	je     800d6e <strcmp+0x1c>
  800d62:	3a 02                	cmp    (%edx),%al
  800d64:	75 08                	jne    800d6e <strcmp+0x1c>
		p++, q++;
  800d66:	83 c1 01             	add    $0x1,%ecx
  800d69:	83 c2 01             	add    $0x1,%edx
  800d6c:	eb ed                	jmp    800d5b <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d6e:	0f b6 c0             	movzbl %al,%eax
  800d71:	0f b6 12             	movzbl (%edx),%edx
  800d74:	29 d0                	sub    %edx,%eax
}
  800d76:	5d                   	pop    %ebp
  800d77:	c3                   	ret    

00800d78 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d78:	55                   	push   %ebp
  800d79:	89 e5                	mov    %esp,%ebp
  800d7b:	53                   	push   %ebx
  800d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d82:	89 c3                	mov    %eax,%ebx
  800d84:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d87:	eb 06                	jmp    800d8f <strncmp+0x17>
		n--, p++, q++;
  800d89:	83 c0 01             	add    $0x1,%eax
  800d8c:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800d8f:	39 d8                	cmp    %ebx,%eax
  800d91:	74 16                	je     800da9 <strncmp+0x31>
  800d93:	0f b6 08             	movzbl (%eax),%ecx
  800d96:	84 c9                	test   %cl,%cl
  800d98:	74 04                	je     800d9e <strncmp+0x26>
  800d9a:	3a 0a                	cmp    (%edx),%cl
  800d9c:	74 eb                	je     800d89 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d9e:	0f b6 00             	movzbl (%eax),%eax
  800da1:	0f b6 12             	movzbl (%edx),%edx
  800da4:	29 d0                	sub    %edx,%eax
}
  800da6:	5b                   	pop    %ebx
  800da7:	5d                   	pop    %ebp
  800da8:	c3                   	ret    
		return 0;
  800da9:	b8 00 00 00 00       	mov    $0x0,%eax
  800dae:	eb f6                	jmp    800da6 <strncmp+0x2e>

00800db0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800dba:	0f b6 10             	movzbl (%eax),%edx
  800dbd:	84 d2                	test   %dl,%dl
  800dbf:	74 09                	je     800dca <strchr+0x1a>
		if (*s == c)
  800dc1:	38 ca                	cmp    %cl,%dl
  800dc3:	74 0a                	je     800dcf <strchr+0x1f>
	for (; *s; s++)
  800dc5:	83 c0 01             	add    $0x1,%eax
  800dc8:	eb f0                	jmp    800dba <strchr+0xa>
			return (char *) s;
	return 0;
  800dca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dcf:	5d                   	pop    %ebp
  800dd0:	c3                   	ret    

00800dd1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dd1:	55                   	push   %ebp
  800dd2:	89 e5                	mov    %esp,%ebp
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ddb:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800dde:	38 ca                	cmp    %cl,%dl
  800de0:	74 09                	je     800deb <strfind+0x1a>
  800de2:	84 d2                	test   %dl,%dl
  800de4:	74 05                	je     800deb <strfind+0x1a>
	for (; *s; s++)
  800de6:	83 c0 01             	add    $0x1,%eax
  800de9:	eb f0                	jmp    800ddb <strfind+0xa>
			break;
	return (char *) s;
}
  800deb:	5d                   	pop    %ebp
  800dec:	c3                   	ret    

00800ded <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ded:	55                   	push   %ebp
  800dee:	89 e5                	mov    %esp,%ebp
  800df0:	57                   	push   %edi
  800df1:	56                   	push   %esi
  800df2:	53                   	push   %ebx
  800df3:	8b 7d 08             	mov    0x8(%ebp),%edi
  800df6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800df9:	85 c9                	test   %ecx,%ecx
  800dfb:	74 31                	je     800e2e <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800dfd:	89 f8                	mov    %edi,%eax
  800dff:	09 c8                	or     %ecx,%eax
  800e01:	a8 03                	test   $0x3,%al
  800e03:	75 23                	jne    800e28 <memset+0x3b>
		c &= 0xFF;
  800e05:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800e09:	89 d3                	mov    %edx,%ebx
  800e0b:	c1 e3 08             	shl    $0x8,%ebx
  800e0e:	89 d0                	mov    %edx,%eax
  800e10:	c1 e0 18             	shl    $0x18,%eax
  800e13:	89 d6                	mov    %edx,%esi
  800e15:	c1 e6 10             	shl    $0x10,%esi
  800e18:	09 f0                	or     %esi,%eax
  800e1a:	09 c2                	or     %eax,%edx
  800e1c:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800e1e:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800e21:	89 d0                	mov    %edx,%eax
  800e23:	fc                   	cld    
  800e24:	f3 ab                	rep stos %eax,%es:(%edi)
  800e26:	eb 06                	jmp    800e2e <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2b:	fc                   	cld    
  800e2c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800e2e:	89 f8                	mov    %edi,%eax
  800e30:	5b                   	pop    %ebx
  800e31:	5e                   	pop    %esi
  800e32:	5f                   	pop    %edi
  800e33:	5d                   	pop    %ebp
  800e34:	c3                   	ret    

00800e35 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800e35:	55                   	push   %ebp
  800e36:	89 e5                	mov    %esp,%ebp
  800e38:	57                   	push   %edi
  800e39:	56                   	push   %esi
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e40:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e43:	39 c6                	cmp    %eax,%esi
  800e45:	73 32                	jae    800e79 <memmove+0x44>
  800e47:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800e4a:	39 c2                	cmp    %eax,%edx
  800e4c:	76 2b                	jbe    800e79 <memmove+0x44>
		s += n;
		d += n;
  800e4e:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e51:	89 fe                	mov    %edi,%esi
  800e53:	09 ce                	or     %ecx,%esi
  800e55:	09 d6                	or     %edx,%esi
  800e57:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800e5d:	75 0e                	jne    800e6d <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800e5f:	83 ef 04             	sub    $0x4,%edi
  800e62:	8d 72 fc             	lea    -0x4(%edx),%esi
  800e65:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800e68:	fd                   	std    
  800e69:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e6b:	eb 09                	jmp    800e76 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800e6d:	83 ef 01             	sub    $0x1,%edi
  800e70:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800e73:	fd                   	std    
  800e74:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e76:	fc                   	cld    
  800e77:	eb 1a                	jmp    800e93 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e79:	89 c2                	mov    %eax,%edx
  800e7b:	09 ca                	or     %ecx,%edx
  800e7d:	09 f2                	or     %esi,%edx
  800e7f:	f6 c2 03             	test   $0x3,%dl
  800e82:	75 0a                	jne    800e8e <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e84:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800e87:	89 c7                	mov    %eax,%edi
  800e89:	fc                   	cld    
  800e8a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e8c:	eb 05                	jmp    800e93 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800e8e:	89 c7                	mov    %eax,%edi
  800e90:	fc                   	cld    
  800e91:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e93:	5e                   	pop    %esi
  800e94:	5f                   	pop    %edi
  800e95:	5d                   	pop    %ebp
  800e96:	c3                   	ret    

00800e97 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e97:	55                   	push   %ebp
  800e98:	89 e5                	mov    %esp,%ebp
  800e9a:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e9d:	ff 75 10             	pushl  0x10(%ebp)
  800ea0:	ff 75 0c             	pushl  0xc(%ebp)
  800ea3:	ff 75 08             	pushl  0x8(%ebp)
  800ea6:	e8 8a ff ff ff       	call   800e35 <memmove>
}
  800eab:	c9                   	leave  
  800eac:	c3                   	ret    

00800ead <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ead:	55                   	push   %ebp
  800eae:	89 e5                	mov    %esp,%ebp
  800eb0:	56                   	push   %esi
  800eb1:	53                   	push   %ebx
  800eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb8:	89 c6                	mov    %eax,%esi
  800eba:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ebd:	39 f0                	cmp    %esi,%eax
  800ebf:	74 1c                	je     800edd <memcmp+0x30>
		if (*s1 != *s2)
  800ec1:	0f b6 08             	movzbl (%eax),%ecx
  800ec4:	0f b6 1a             	movzbl (%edx),%ebx
  800ec7:	38 d9                	cmp    %bl,%cl
  800ec9:	75 08                	jne    800ed3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ecb:	83 c0 01             	add    $0x1,%eax
  800ece:	83 c2 01             	add    $0x1,%edx
  800ed1:	eb ea                	jmp    800ebd <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ed3:	0f b6 c1             	movzbl %cl,%eax
  800ed6:	0f b6 db             	movzbl %bl,%ebx
  800ed9:	29 d8                	sub    %ebx,%eax
  800edb:	eb 05                	jmp    800ee2 <memcmp+0x35>
	}

	return 0;
  800edd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ee2:	5b                   	pop    %ebx
  800ee3:	5e                   	pop    %esi
  800ee4:	5d                   	pop    %ebp
  800ee5:	c3                   	ret    

00800ee6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
  800ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800eef:	89 c2                	mov    %eax,%edx
  800ef1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ef4:	39 d0                	cmp    %edx,%eax
  800ef6:	73 09                	jae    800f01 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ef8:	38 08                	cmp    %cl,(%eax)
  800efa:	74 05                	je     800f01 <memfind+0x1b>
	for (; s < ends; s++)
  800efc:	83 c0 01             	add    $0x1,%eax
  800eff:	eb f3                	jmp    800ef4 <memfind+0xe>
			break;
	return (void *) s;
}
  800f01:	5d                   	pop    %ebp
  800f02:	c3                   	ret    

00800f03 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
  800f06:	57                   	push   %edi
  800f07:	56                   	push   %esi
  800f08:	53                   	push   %ebx
  800f09:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f0f:	eb 03                	jmp    800f14 <strtol+0x11>
		s++;
  800f11:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800f14:	0f b6 01             	movzbl (%ecx),%eax
  800f17:	3c 20                	cmp    $0x20,%al
  800f19:	74 f6                	je     800f11 <strtol+0xe>
  800f1b:	3c 09                	cmp    $0x9,%al
  800f1d:	74 f2                	je     800f11 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800f1f:	3c 2b                	cmp    $0x2b,%al
  800f21:	74 2a                	je     800f4d <strtol+0x4a>
	int neg = 0;
  800f23:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800f28:	3c 2d                	cmp    $0x2d,%al
  800f2a:	74 2b                	je     800f57 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f2c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800f32:	75 0f                	jne    800f43 <strtol+0x40>
  800f34:	80 39 30             	cmpb   $0x30,(%ecx)
  800f37:	74 28                	je     800f61 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800f39:	85 db                	test   %ebx,%ebx
  800f3b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f40:	0f 44 d8             	cmove  %eax,%ebx
  800f43:	b8 00 00 00 00       	mov    $0x0,%eax
  800f48:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800f4b:	eb 50                	jmp    800f9d <strtol+0x9a>
		s++;
  800f4d:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800f50:	bf 00 00 00 00       	mov    $0x0,%edi
  800f55:	eb d5                	jmp    800f2c <strtol+0x29>
		s++, neg = 1;
  800f57:	83 c1 01             	add    $0x1,%ecx
  800f5a:	bf 01 00 00 00       	mov    $0x1,%edi
  800f5f:	eb cb                	jmp    800f2c <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f61:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800f65:	74 0e                	je     800f75 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800f67:	85 db                	test   %ebx,%ebx
  800f69:	75 d8                	jne    800f43 <strtol+0x40>
		s++, base = 8;
  800f6b:	83 c1 01             	add    $0x1,%ecx
  800f6e:	bb 08 00 00 00       	mov    $0x8,%ebx
  800f73:	eb ce                	jmp    800f43 <strtol+0x40>
		s += 2, base = 16;
  800f75:	83 c1 02             	add    $0x2,%ecx
  800f78:	bb 10 00 00 00       	mov    $0x10,%ebx
  800f7d:	eb c4                	jmp    800f43 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800f7f:	8d 72 9f             	lea    -0x61(%edx),%esi
  800f82:	89 f3                	mov    %esi,%ebx
  800f84:	80 fb 19             	cmp    $0x19,%bl
  800f87:	77 29                	ja     800fb2 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800f89:	0f be d2             	movsbl %dl,%edx
  800f8c:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f8f:	3b 55 10             	cmp    0x10(%ebp),%edx
  800f92:	7d 30                	jge    800fc4 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800f94:	83 c1 01             	add    $0x1,%ecx
  800f97:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f9b:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800f9d:	0f b6 11             	movzbl (%ecx),%edx
  800fa0:	8d 72 d0             	lea    -0x30(%edx),%esi
  800fa3:	89 f3                	mov    %esi,%ebx
  800fa5:	80 fb 09             	cmp    $0x9,%bl
  800fa8:	77 d5                	ja     800f7f <strtol+0x7c>
			dig = *s - '0';
  800faa:	0f be d2             	movsbl %dl,%edx
  800fad:	83 ea 30             	sub    $0x30,%edx
  800fb0:	eb dd                	jmp    800f8f <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800fb2:	8d 72 bf             	lea    -0x41(%edx),%esi
  800fb5:	89 f3                	mov    %esi,%ebx
  800fb7:	80 fb 19             	cmp    $0x19,%bl
  800fba:	77 08                	ja     800fc4 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800fbc:	0f be d2             	movsbl %dl,%edx
  800fbf:	83 ea 37             	sub    $0x37,%edx
  800fc2:	eb cb                	jmp    800f8f <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800fc4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fc8:	74 05                	je     800fcf <strtol+0xcc>
		*endptr = (char *) s;
  800fca:	8b 75 0c             	mov    0xc(%ebp),%esi
  800fcd:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800fcf:	89 c2                	mov    %eax,%edx
  800fd1:	f7 da                	neg    %edx
  800fd3:	85 ff                	test   %edi,%edi
  800fd5:	0f 45 c2             	cmovne %edx,%eax
}
  800fd8:	5b                   	pop    %ebx
  800fd9:	5e                   	pop    %esi
  800fda:	5f                   	pop    %edi
  800fdb:	5d                   	pop    %ebp
  800fdc:	c3                   	ret    

00800fdd <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800fdd:	55                   	push   %ebp
  800fde:	89 e5                	mov    %esp,%ebp
  800fe0:	57                   	push   %edi
  800fe1:	56                   	push   %esi
  800fe2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fe3:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe8:	8b 55 08             	mov    0x8(%ebp),%edx
  800feb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fee:	89 c3                	mov    %eax,%ebx
  800ff0:	89 c7                	mov    %eax,%edi
  800ff2:	89 c6                	mov    %eax,%esi
  800ff4:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ff6:	5b                   	pop    %ebx
  800ff7:	5e                   	pop    %esi
  800ff8:	5f                   	pop    %edi
  800ff9:	5d                   	pop    %ebp
  800ffa:	c3                   	ret    

00800ffb <sys_cgetc>:

int
sys_cgetc(void)
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	57                   	push   %edi
  800fff:	56                   	push   %esi
  801000:	53                   	push   %ebx
	asm volatile("int %1\n"
  801001:	ba 00 00 00 00       	mov    $0x0,%edx
  801006:	b8 01 00 00 00       	mov    $0x1,%eax
  80100b:	89 d1                	mov    %edx,%ecx
  80100d:	89 d3                	mov    %edx,%ebx
  80100f:	89 d7                	mov    %edx,%edi
  801011:	89 d6                	mov    %edx,%esi
  801013:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801015:	5b                   	pop    %ebx
  801016:	5e                   	pop    %esi
  801017:	5f                   	pop    %edi
  801018:	5d                   	pop    %ebp
  801019:	c3                   	ret    

0080101a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80101a:	55                   	push   %ebp
  80101b:	89 e5                	mov    %esp,%ebp
  80101d:	57                   	push   %edi
  80101e:	56                   	push   %esi
  80101f:	53                   	push   %ebx
  801020:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801023:	b9 00 00 00 00       	mov    $0x0,%ecx
  801028:	8b 55 08             	mov    0x8(%ebp),%edx
  80102b:	b8 03 00 00 00       	mov    $0x3,%eax
  801030:	89 cb                	mov    %ecx,%ebx
  801032:	89 cf                	mov    %ecx,%edi
  801034:	89 ce                	mov    %ecx,%esi
  801036:	cd 30                	int    $0x30
	if(check && ret > 0)
  801038:	85 c0                	test   %eax,%eax
  80103a:	7f 08                	jg     801044 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80103c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80103f:	5b                   	pop    %ebx
  801040:	5e                   	pop    %esi
  801041:	5f                   	pop    %edi
  801042:	5d                   	pop    %ebp
  801043:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801044:	83 ec 0c             	sub    $0xc,%esp
  801047:	50                   	push   %eax
  801048:	6a 03                	push   $0x3
  80104a:	68 84 32 80 00       	push   $0x803284
  80104f:	6a 43                	push   $0x43
  801051:	68 a1 32 80 00       	push   $0x8032a1
  801056:	e8 f7 f3 ff ff       	call   800452 <_panic>

0080105b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	57                   	push   %edi
  80105f:	56                   	push   %esi
  801060:	53                   	push   %ebx
	asm volatile("int %1\n"
  801061:	ba 00 00 00 00       	mov    $0x0,%edx
  801066:	b8 02 00 00 00       	mov    $0x2,%eax
  80106b:	89 d1                	mov    %edx,%ecx
  80106d:	89 d3                	mov    %edx,%ebx
  80106f:	89 d7                	mov    %edx,%edi
  801071:	89 d6                	mov    %edx,%esi
  801073:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801075:	5b                   	pop    %ebx
  801076:	5e                   	pop    %esi
  801077:	5f                   	pop    %edi
  801078:	5d                   	pop    %ebp
  801079:	c3                   	ret    

0080107a <sys_yield>:

void
sys_yield(void)
{
  80107a:	55                   	push   %ebp
  80107b:	89 e5                	mov    %esp,%ebp
  80107d:	57                   	push   %edi
  80107e:	56                   	push   %esi
  80107f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801080:	ba 00 00 00 00       	mov    $0x0,%edx
  801085:	b8 0b 00 00 00       	mov    $0xb,%eax
  80108a:	89 d1                	mov    %edx,%ecx
  80108c:	89 d3                	mov    %edx,%ebx
  80108e:	89 d7                	mov    %edx,%edi
  801090:	89 d6                	mov    %edx,%esi
  801092:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801094:	5b                   	pop    %ebx
  801095:	5e                   	pop    %esi
  801096:	5f                   	pop    %edi
  801097:	5d                   	pop    %ebp
  801098:	c3                   	ret    

00801099 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801099:	55                   	push   %ebp
  80109a:	89 e5                	mov    %esp,%ebp
  80109c:	57                   	push   %edi
  80109d:	56                   	push   %esi
  80109e:	53                   	push   %ebx
  80109f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010a2:	be 00 00 00 00       	mov    $0x0,%esi
  8010a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8010aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ad:	b8 04 00 00 00       	mov    $0x4,%eax
  8010b2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010b5:	89 f7                	mov    %esi,%edi
  8010b7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010b9:	85 c0                	test   %eax,%eax
  8010bb:	7f 08                	jg     8010c5 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8010bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010c0:	5b                   	pop    %ebx
  8010c1:	5e                   	pop    %esi
  8010c2:	5f                   	pop    %edi
  8010c3:	5d                   	pop    %ebp
  8010c4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c5:	83 ec 0c             	sub    $0xc,%esp
  8010c8:	50                   	push   %eax
  8010c9:	6a 04                	push   $0x4
  8010cb:	68 84 32 80 00       	push   $0x803284
  8010d0:	6a 43                	push   $0x43
  8010d2:	68 a1 32 80 00       	push   $0x8032a1
  8010d7:	e8 76 f3 ff ff       	call   800452 <_panic>

008010dc <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8010dc:	55                   	push   %ebp
  8010dd:	89 e5                	mov    %esp,%ebp
  8010df:	57                   	push   %edi
  8010e0:	56                   	push   %esi
  8010e1:	53                   	push   %ebx
  8010e2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010eb:	b8 05 00 00 00       	mov    $0x5,%eax
  8010f0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010f3:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010f6:	8b 75 18             	mov    0x18(%ebp),%esi
  8010f9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010fb:	85 c0                	test   %eax,%eax
  8010fd:	7f 08                	jg     801107 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8010ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801102:	5b                   	pop    %ebx
  801103:	5e                   	pop    %esi
  801104:	5f                   	pop    %edi
  801105:	5d                   	pop    %ebp
  801106:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801107:	83 ec 0c             	sub    $0xc,%esp
  80110a:	50                   	push   %eax
  80110b:	6a 05                	push   $0x5
  80110d:	68 84 32 80 00       	push   $0x803284
  801112:	6a 43                	push   $0x43
  801114:	68 a1 32 80 00       	push   $0x8032a1
  801119:	e8 34 f3 ff ff       	call   800452 <_panic>

0080111e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80111e:	55                   	push   %ebp
  80111f:	89 e5                	mov    %esp,%ebp
  801121:	57                   	push   %edi
  801122:	56                   	push   %esi
  801123:	53                   	push   %ebx
  801124:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801127:	bb 00 00 00 00       	mov    $0x0,%ebx
  80112c:	8b 55 08             	mov    0x8(%ebp),%edx
  80112f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801132:	b8 06 00 00 00       	mov    $0x6,%eax
  801137:	89 df                	mov    %ebx,%edi
  801139:	89 de                	mov    %ebx,%esi
  80113b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80113d:	85 c0                	test   %eax,%eax
  80113f:	7f 08                	jg     801149 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801141:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801144:	5b                   	pop    %ebx
  801145:	5e                   	pop    %esi
  801146:	5f                   	pop    %edi
  801147:	5d                   	pop    %ebp
  801148:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801149:	83 ec 0c             	sub    $0xc,%esp
  80114c:	50                   	push   %eax
  80114d:	6a 06                	push   $0x6
  80114f:	68 84 32 80 00       	push   $0x803284
  801154:	6a 43                	push   $0x43
  801156:	68 a1 32 80 00       	push   $0x8032a1
  80115b:	e8 f2 f2 ff ff       	call   800452 <_panic>

00801160 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801160:	55                   	push   %ebp
  801161:	89 e5                	mov    %esp,%ebp
  801163:	57                   	push   %edi
  801164:	56                   	push   %esi
  801165:	53                   	push   %ebx
  801166:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801169:	bb 00 00 00 00       	mov    $0x0,%ebx
  80116e:	8b 55 08             	mov    0x8(%ebp),%edx
  801171:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801174:	b8 08 00 00 00       	mov    $0x8,%eax
  801179:	89 df                	mov    %ebx,%edi
  80117b:	89 de                	mov    %ebx,%esi
  80117d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80117f:	85 c0                	test   %eax,%eax
  801181:	7f 08                	jg     80118b <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801183:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801186:	5b                   	pop    %ebx
  801187:	5e                   	pop    %esi
  801188:	5f                   	pop    %edi
  801189:	5d                   	pop    %ebp
  80118a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80118b:	83 ec 0c             	sub    $0xc,%esp
  80118e:	50                   	push   %eax
  80118f:	6a 08                	push   $0x8
  801191:	68 84 32 80 00       	push   $0x803284
  801196:	6a 43                	push   $0x43
  801198:	68 a1 32 80 00       	push   $0x8032a1
  80119d:	e8 b0 f2 ff ff       	call   800452 <_panic>

008011a2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8011a2:	55                   	push   %ebp
  8011a3:	89 e5                	mov    %esp,%ebp
  8011a5:	57                   	push   %edi
  8011a6:	56                   	push   %esi
  8011a7:	53                   	push   %ebx
  8011a8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011ab:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011b6:	b8 09 00 00 00       	mov    $0x9,%eax
  8011bb:	89 df                	mov    %ebx,%edi
  8011bd:	89 de                	mov    %ebx,%esi
  8011bf:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011c1:	85 c0                	test   %eax,%eax
  8011c3:	7f 08                	jg     8011cd <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8011c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011c8:	5b                   	pop    %ebx
  8011c9:	5e                   	pop    %esi
  8011ca:	5f                   	pop    %edi
  8011cb:	5d                   	pop    %ebp
  8011cc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011cd:	83 ec 0c             	sub    $0xc,%esp
  8011d0:	50                   	push   %eax
  8011d1:	6a 09                	push   $0x9
  8011d3:	68 84 32 80 00       	push   $0x803284
  8011d8:	6a 43                	push   $0x43
  8011da:	68 a1 32 80 00       	push   $0x8032a1
  8011df:	e8 6e f2 ff ff       	call   800452 <_panic>

008011e4 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8011e4:	55                   	push   %ebp
  8011e5:	89 e5                	mov    %esp,%ebp
  8011e7:	57                   	push   %edi
  8011e8:	56                   	push   %esi
  8011e9:	53                   	push   %ebx
  8011ea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011f8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011fd:	89 df                	mov    %ebx,%edi
  8011ff:	89 de                	mov    %ebx,%esi
  801201:	cd 30                	int    $0x30
	if(check && ret > 0)
  801203:	85 c0                	test   %eax,%eax
  801205:	7f 08                	jg     80120f <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801207:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80120a:	5b                   	pop    %ebx
  80120b:	5e                   	pop    %esi
  80120c:	5f                   	pop    %edi
  80120d:	5d                   	pop    %ebp
  80120e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80120f:	83 ec 0c             	sub    $0xc,%esp
  801212:	50                   	push   %eax
  801213:	6a 0a                	push   $0xa
  801215:	68 84 32 80 00       	push   $0x803284
  80121a:	6a 43                	push   $0x43
  80121c:	68 a1 32 80 00       	push   $0x8032a1
  801221:	e8 2c f2 ff ff       	call   800452 <_panic>

00801226 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801226:	55                   	push   %ebp
  801227:	89 e5                	mov    %esp,%ebp
  801229:	57                   	push   %edi
  80122a:	56                   	push   %esi
  80122b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80122c:	8b 55 08             	mov    0x8(%ebp),%edx
  80122f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801232:	b8 0c 00 00 00       	mov    $0xc,%eax
  801237:	be 00 00 00 00       	mov    $0x0,%esi
  80123c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80123f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801242:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801244:	5b                   	pop    %ebx
  801245:	5e                   	pop    %esi
  801246:	5f                   	pop    %edi
  801247:	5d                   	pop    %ebp
  801248:	c3                   	ret    

00801249 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
  80124c:	57                   	push   %edi
  80124d:	56                   	push   %esi
  80124e:	53                   	push   %ebx
  80124f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801252:	b9 00 00 00 00       	mov    $0x0,%ecx
  801257:	8b 55 08             	mov    0x8(%ebp),%edx
  80125a:	b8 0d 00 00 00       	mov    $0xd,%eax
  80125f:	89 cb                	mov    %ecx,%ebx
  801261:	89 cf                	mov    %ecx,%edi
  801263:	89 ce                	mov    %ecx,%esi
  801265:	cd 30                	int    $0x30
	if(check && ret > 0)
  801267:	85 c0                	test   %eax,%eax
  801269:	7f 08                	jg     801273 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80126b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80126e:	5b                   	pop    %ebx
  80126f:	5e                   	pop    %esi
  801270:	5f                   	pop    %edi
  801271:	5d                   	pop    %ebp
  801272:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801273:	83 ec 0c             	sub    $0xc,%esp
  801276:	50                   	push   %eax
  801277:	6a 0d                	push   $0xd
  801279:	68 84 32 80 00       	push   $0x803284
  80127e:	6a 43                	push   $0x43
  801280:	68 a1 32 80 00       	push   $0x8032a1
  801285:	e8 c8 f1 ff ff       	call   800452 <_panic>

0080128a <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
  80128d:	57                   	push   %edi
  80128e:	56                   	push   %esi
  80128f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801290:	bb 00 00 00 00       	mov    $0x0,%ebx
  801295:	8b 55 08             	mov    0x8(%ebp),%edx
  801298:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80129b:	b8 0e 00 00 00       	mov    $0xe,%eax
  8012a0:	89 df                	mov    %ebx,%edi
  8012a2:	89 de                	mov    %ebx,%esi
  8012a4:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8012a6:	5b                   	pop    %ebx
  8012a7:	5e                   	pop    %esi
  8012a8:	5f                   	pop    %edi
  8012a9:	5d                   	pop    %ebp
  8012aa:	c3                   	ret    

008012ab <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8012ab:	55                   	push   %ebp
  8012ac:	89 e5                	mov    %esp,%ebp
  8012ae:	57                   	push   %edi
  8012af:	56                   	push   %esi
  8012b0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012b1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8012b9:	b8 0f 00 00 00       	mov    $0xf,%eax
  8012be:	89 cb                	mov    %ecx,%ebx
  8012c0:	89 cf                	mov    %ecx,%edi
  8012c2:	89 ce                	mov    %ecx,%esi
  8012c4:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8012c6:	5b                   	pop    %ebx
  8012c7:	5e                   	pop    %esi
  8012c8:	5f                   	pop    %edi
  8012c9:	5d                   	pop    %ebp
  8012ca:	c3                   	ret    

008012cb <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8012cb:	55                   	push   %ebp
  8012cc:	89 e5                	mov    %esp,%ebp
  8012ce:	57                   	push   %edi
  8012cf:	56                   	push   %esi
  8012d0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8012d6:	b8 10 00 00 00       	mov    $0x10,%eax
  8012db:	89 d1                	mov    %edx,%ecx
  8012dd:	89 d3                	mov    %edx,%ebx
  8012df:	89 d7                	mov    %edx,%edi
  8012e1:	89 d6                	mov    %edx,%esi
  8012e3:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8012e5:	5b                   	pop    %ebx
  8012e6:	5e                   	pop    %esi
  8012e7:	5f                   	pop    %edi
  8012e8:	5d                   	pop    %ebp
  8012e9:	c3                   	ret    

008012ea <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8012ea:	55                   	push   %ebp
  8012eb:	89 e5                	mov    %esp,%ebp
  8012ed:	57                   	push   %edi
  8012ee:	56                   	push   %esi
  8012ef:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012fb:	b8 11 00 00 00       	mov    $0x11,%eax
  801300:	89 df                	mov    %ebx,%edi
  801302:	89 de                	mov    %ebx,%esi
  801304:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801306:	5b                   	pop    %ebx
  801307:	5e                   	pop    %esi
  801308:	5f                   	pop    %edi
  801309:	5d                   	pop    %ebp
  80130a:	c3                   	ret    

0080130b <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
  80130e:	57                   	push   %edi
  80130f:	56                   	push   %esi
  801310:	53                   	push   %ebx
	asm volatile("int %1\n"
  801311:	bb 00 00 00 00       	mov    $0x0,%ebx
  801316:	8b 55 08             	mov    0x8(%ebp),%edx
  801319:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80131c:	b8 12 00 00 00       	mov    $0x12,%eax
  801321:	89 df                	mov    %ebx,%edi
  801323:	89 de                	mov    %ebx,%esi
  801325:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801327:	5b                   	pop    %ebx
  801328:	5e                   	pop    %esi
  801329:	5f                   	pop    %edi
  80132a:	5d                   	pop    %ebp
  80132b:	c3                   	ret    

0080132c <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
  80132f:	57                   	push   %edi
  801330:	56                   	push   %esi
  801331:	53                   	push   %ebx
  801332:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801335:	bb 00 00 00 00       	mov    $0x0,%ebx
  80133a:	8b 55 08             	mov    0x8(%ebp),%edx
  80133d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801340:	b8 13 00 00 00       	mov    $0x13,%eax
  801345:	89 df                	mov    %ebx,%edi
  801347:	89 de                	mov    %ebx,%esi
  801349:	cd 30                	int    $0x30
	if(check && ret > 0)
  80134b:	85 c0                	test   %eax,%eax
  80134d:	7f 08                	jg     801357 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80134f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801352:	5b                   	pop    %ebx
  801353:	5e                   	pop    %esi
  801354:	5f                   	pop    %edi
  801355:	5d                   	pop    %ebp
  801356:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801357:	83 ec 0c             	sub    $0xc,%esp
  80135a:	50                   	push   %eax
  80135b:	6a 13                	push   $0x13
  80135d:	68 84 32 80 00       	push   $0x803284
  801362:	6a 43                	push   $0x43
  801364:	68 a1 32 80 00       	push   $0x8032a1
  801369:	e8 e4 f0 ff ff       	call   800452 <_panic>

0080136e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80136e:	55                   	push   %ebp
  80136f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801371:	8b 45 08             	mov    0x8(%ebp),%eax
  801374:	05 00 00 00 30       	add    $0x30000000,%eax
  801379:	c1 e8 0c             	shr    $0xc,%eax
}
  80137c:	5d                   	pop    %ebp
  80137d:	c3                   	ret    

0080137e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80137e:	55                   	push   %ebp
  80137f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801381:	8b 45 08             	mov    0x8(%ebp),%eax
  801384:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801389:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80138e:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801393:	5d                   	pop    %ebp
  801394:	c3                   	ret    

00801395 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
  801398:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80139d:	89 c2                	mov    %eax,%edx
  80139f:	c1 ea 16             	shr    $0x16,%edx
  8013a2:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013a9:	f6 c2 01             	test   $0x1,%dl
  8013ac:	74 2d                	je     8013db <fd_alloc+0x46>
  8013ae:	89 c2                	mov    %eax,%edx
  8013b0:	c1 ea 0c             	shr    $0xc,%edx
  8013b3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013ba:	f6 c2 01             	test   $0x1,%dl
  8013bd:	74 1c                	je     8013db <fd_alloc+0x46>
  8013bf:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8013c4:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013c9:	75 d2                	jne    80139d <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8013cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8013d4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8013d9:	eb 0a                	jmp    8013e5 <fd_alloc+0x50>
			*fd_store = fd;
  8013db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013de:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013e5:	5d                   	pop    %ebp
  8013e6:	c3                   	ret    

008013e7 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8013e7:	55                   	push   %ebp
  8013e8:	89 e5                	mov    %esp,%ebp
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013ed:	83 f8 1f             	cmp    $0x1f,%eax
  8013f0:	77 30                	ja     801422 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8013f2:	c1 e0 0c             	shl    $0xc,%eax
  8013f5:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013fa:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801400:	f6 c2 01             	test   $0x1,%dl
  801403:	74 24                	je     801429 <fd_lookup+0x42>
  801405:	89 c2                	mov    %eax,%edx
  801407:	c1 ea 0c             	shr    $0xc,%edx
  80140a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801411:	f6 c2 01             	test   $0x1,%dl
  801414:	74 1a                	je     801430 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801416:	8b 55 0c             	mov    0xc(%ebp),%edx
  801419:	89 02                	mov    %eax,(%edx)
	return 0;
  80141b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801420:	5d                   	pop    %ebp
  801421:	c3                   	ret    
		return -E_INVAL;
  801422:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801427:	eb f7                	jmp    801420 <fd_lookup+0x39>
		return -E_INVAL;
  801429:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80142e:	eb f0                	jmp    801420 <fd_lookup+0x39>
  801430:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801435:	eb e9                	jmp    801420 <fd_lookup+0x39>

00801437 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801437:	55                   	push   %ebp
  801438:	89 e5                	mov    %esp,%ebp
  80143a:	83 ec 08             	sub    $0x8,%esp
  80143d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801440:	ba 00 00 00 00       	mov    $0x0,%edx
  801445:	b8 90 57 80 00       	mov    $0x805790,%eax
		if (devtab[i]->dev_id == dev_id) {
  80144a:	39 08                	cmp    %ecx,(%eax)
  80144c:	74 38                	je     801486 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80144e:	83 c2 01             	add    $0x1,%edx
  801451:	8b 04 95 2c 33 80 00 	mov    0x80332c(,%edx,4),%eax
  801458:	85 c0                	test   %eax,%eax
  80145a:	75 ee                	jne    80144a <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80145c:	a1 90 77 80 00       	mov    0x807790,%eax
  801461:	8b 40 48             	mov    0x48(%eax),%eax
  801464:	83 ec 04             	sub    $0x4,%esp
  801467:	51                   	push   %ecx
  801468:	50                   	push   %eax
  801469:	68 b0 32 80 00       	push   $0x8032b0
  80146e:	e8 d5 f0 ff ff       	call   800548 <cprintf>
	*dev = 0;
  801473:	8b 45 0c             	mov    0xc(%ebp),%eax
  801476:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80147c:	83 c4 10             	add    $0x10,%esp
  80147f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801484:	c9                   	leave  
  801485:	c3                   	ret    
			*dev = devtab[i];
  801486:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801489:	89 01                	mov    %eax,(%ecx)
			return 0;
  80148b:	b8 00 00 00 00       	mov    $0x0,%eax
  801490:	eb f2                	jmp    801484 <dev_lookup+0x4d>

00801492 <fd_close>:
{
  801492:	55                   	push   %ebp
  801493:	89 e5                	mov    %esp,%ebp
  801495:	57                   	push   %edi
  801496:	56                   	push   %esi
  801497:	53                   	push   %ebx
  801498:	83 ec 24             	sub    $0x24,%esp
  80149b:	8b 75 08             	mov    0x8(%ebp),%esi
  80149e:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014a1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014a4:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014a5:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8014ab:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014ae:	50                   	push   %eax
  8014af:	e8 33 ff ff ff       	call   8013e7 <fd_lookup>
  8014b4:	89 c3                	mov    %eax,%ebx
  8014b6:	83 c4 10             	add    $0x10,%esp
  8014b9:	85 c0                	test   %eax,%eax
  8014bb:	78 05                	js     8014c2 <fd_close+0x30>
	    || fd != fd2)
  8014bd:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8014c0:	74 16                	je     8014d8 <fd_close+0x46>
		return (must_exist ? r : 0);
  8014c2:	89 f8                	mov    %edi,%eax
  8014c4:	84 c0                	test   %al,%al
  8014c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8014cb:	0f 44 d8             	cmove  %eax,%ebx
}
  8014ce:	89 d8                	mov    %ebx,%eax
  8014d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014d3:	5b                   	pop    %ebx
  8014d4:	5e                   	pop    %esi
  8014d5:	5f                   	pop    %edi
  8014d6:	5d                   	pop    %ebp
  8014d7:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8014d8:	83 ec 08             	sub    $0x8,%esp
  8014db:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8014de:	50                   	push   %eax
  8014df:	ff 36                	pushl  (%esi)
  8014e1:	e8 51 ff ff ff       	call   801437 <dev_lookup>
  8014e6:	89 c3                	mov    %eax,%ebx
  8014e8:	83 c4 10             	add    $0x10,%esp
  8014eb:	85 c0                	test   %eax,%eax
  8014ed:	78 1a                	js     801509 <fd_close+0x77>
		if (dev->dev_close)
  8014ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014f2:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8014f5:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8014fa:	85 c0                	test   %eax,%eax
  8014fc:	74 0b                	je     801509 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8014fe:	83 ec 0c             	sub    $0xc,%esp
  801501:	56                   	push   %esi
  801502:	ff d0                	call   *%eax
  801504:	89 c3                	mov    %eax,%ebx
  801506:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801509:	83 ec 08             	sub    $0x8,%esp
  80150c:	56                   	push   %esi
  80150d:	6a 00                	push   $0x0
  80150f:	e8 0a fc ff ff       	call   80111e <sys_page_unmap>
	return r;
  801514:	83 c4 10             	add    $0x10,%esp
  801517:	eb b5                	jmp    8014ce <fd_close+0x3c>

00801519 <close>:

int
close(int fdnum)
{
  801519:	55                   	push   %ebp
  80151a:	89 e5                	mov    %esp,%ebp
  80151c:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80151f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801522:	50                   	push   %eax
  801523:	ff 75 08             	pushl  0x8(%ebp)
  801526:	e8 bc fe ff ff       	call   8013e7 <fd_lookup>
  80152b:	83 c4 10             	add    $0x10,%esp
  80152e:	85 c0                	test   %eax,%eax
  801530:	79 02                	jns    801534 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801532:	c9                   	leave  
  801533:	c3                   	ret    
		return fd_close(fd, 1);
  801534:	83 ec 08             	sub    $0x8,%esp
  801537:	6a 01                	push   $0x1
  801539:	ff 75 f4             	pushl  -0xc(%ebp)
  80153c:	e8 51 ff ff ff       	call   801492 <fd_close>
  801541:	83 c4 10             	add    $0x10,%esp
  801544:	eb ec                	jmp    801532 <close+0x19>

00801546 <close_all>:

void
close_all(void)
{
  801546:	55                   	push   %ebp
  801547:	89 e5                	mov    %esp,%ebp
  801549:	53                   	push   %ebx
  80154a:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80154d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801552:	83 ec 0c             	sub    $0xc,%esp
  801555:	53                   	push   %ebx
  801556:	e8 be ff ff ff       	call   801519 <close>
	for (i = 0; i < MAXFD; i++)
  80155b:	83 c3 01             	add    $0x1,%ebx
  80155e:	83 c4 10             	add    $0x10,%esp
  801561:	83 fb 20             	cmp    $0x20,%ebx
  801564:	75 ec                	jne    801552 <close_all+0xc>
}
  801566:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801569:	c9                   	leave  
  80156a:	c3                   	ret    

0080156b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
  80156e:	57                   	push   %edi
  80156f:	56                   	push   %esi
  801570:	53                   	push   %ebx
  801571:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801574:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801577:	50                   	push   %eax
  801578:	ff 75 08             	pushl  0x8(%ebp)
  80157b:	e8 67 fe ff ff       	call   8013e7 <fd_lookup>
  801580:	89 c3                	mov    %eax,%ebx
  801582:	83 c4 10             	add    $0x10,%esp
  801585:	85 c0                	test   %eax,%eax
  801587:	0f 88 81 00 00 00    	js     80160e <dup+0xa3>
		return r;
	close(newfdnum);
  80158d:	83 ec 0c             	sub    $0xc,%esp
  801590:	ff 75 0c             	pushl  0xc(%ebp)
  801593:	e8 81 ff ff ff       	call   801519 <close>

	newfd = INDEX2FD(newfdnum);
  801598:	8b 75 0c             	mov    0xc(%ebp),%esi
  80159b:	c1 e6 0c             	shl    $0xc,%esi
  80159e:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8015a4:	83 c4 04             	add    $0x4,%esp
  8015a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015aa:	e8 cf fd ff ff       	call   80137e <fd2data>
  8015af:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8015b1:	89 34 24             	mov    %esi,(%esp)
  8015b4:	e8 c5 fd ff ff       	call   80137e <fd2data>
  8015b9:	83 c4 10             	add    $0x10,%esp
  8015bc:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8015be:	89 d8                	mov    %ebx,%eax
  8015c0:	c1 e8 16             	shr    $0x16,%eax
  8015c3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015ca:	a8 01                	test   $0x1,%al
  8015cc:	74 11                	je     8015df <dup+0x74>
  8015ce:	89 d8                	mov    %ebx,%eax
  8015d0:	c1 e8 0c             	shr    $0xc,%eax
  8015d3:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8015da:	f6 c2 01             	test   $0x1,%dl
  8015dd:	75 39                	jne    801618 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015e2:	89 d0                	mov    %edx,%eax
  8015e4:	c1 e8 0c             	shr    $0xc,%eax
  8015e7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015ee:	83 ec 0c             	sub    $0xc,%esp
  8015f1:	25 07 0e 00 00       	and    $0xe07,%eax
  8015f6:	50                   	push   %eax
  8015f7:	56                   	push   %esi
  8015f8:	6a 00                	push   $0x0
  8015fa:	52                   	push   %edx
  8015fb:	6a 00                	push   $0x0
  8015fd:	e8 da fa ff ff       	call   8010dc <sys_page_map>
  801602:	89 c3                	mov    %eax,%ebx
  801604:	83 c4 20             	add    $0x20,%esp
  801607:	85 c0                	test   %eax,%eax
  801609:	78 31                	js     80163c <dup+0xd1>
		goto err;

	return newfdnum;
  80160b:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80160e:	89 d8                	mov    %ebx,%eax
  801610:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801613:	5b                   	pop    %ebx
  801614:	5e                   	pop    %esi
  801615:	5f                   	pop    %edi
  801616:	5d                   	pop    %ebp
  801617:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801618:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80161f:	83 ec 0c             	sub    $0xc,%esp
  801622:	25 07 0e 00 00       	and    $0xe07,%eax
  801627:	50                   	push   %eax
  801628:	57                   	push   %edi
  801629:	6a 00                	push   $0x0
  80162b:	53                   	push   %ebx
  80162c:	6a 00                	push   $0x0
  80162e:	e8 a9 fa ff ff       	call   8010dc <sys_page_map>
  801633:	89 c3                	mov    %eax,%ebx
  801635:	83 c4 20             	add    $0x20,%esp
  801638:	85 c0                	test   %eax,%eax
  80163a:	79 a3                	jns    8015df <dup+0x74>
	sys_page_unmap(0, newfd);
  80163c:	83 ec 08             	sub    $0x8,%esp
  80163f:	56                   	push   %esi
  801640:	6a 00                	push   $0x0
  801642:	e8 d7 fa ff ff       	call   80111e <sys_page_unmap>
	sys_page_unmap(0, nva);
  801647:	83 c4 08             	add    $0x8,%esp
  80164a:	57                   	push   %edi
  80164b:	6a 00                	push   $0x0
  80164d:	e8 cc fa ff ff       	call   80111e <sys_page_unmap>
	return r;
  801652:	83 c4 10             	add    $0x10,%esp
  801655:	eb b7                	jmp    80160e <dup+0xa3>

00801657 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
  80165a:	53                   	push   %ebx
  80165b:	83 ec 1c             	sub    $0x1c,%esp
  80165e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801661:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801664:	50                   	push   %eax
  801665:	53                   	push   %ebx
  801666:	e8 7c fd ff ff       	call   8013e7 <fd_lookup>
  80166b:	83 c4 10             	add    $0x10,%esp
  80166e:	85 c0                	test   %eax,%eax
  801670:	78 3f                	js     8016b1 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801672:	83 ec 08             	sub    $0x8,%esp
  801675:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801678:	50                   	push   %eax
  801679:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167c:	ff 30                	pushl  (%eax)
  80167e:	e8 b4 fd ff ff       	call   801437 <dev_lookup>
  801683:	83 c4 10             	add    $0x10,%esp
  801686:	85 c0                	test   %eax,%eax
  801688:	78 27                	js     8016b1 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80168a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80168d:	8b 42 08             	mov    0x8(%edx),%eax
  801690:	83 e0 03             	and    $0x3,%eax
  801693:	83 f8 01             	cmp    $0x1,%eax
  801696:	74 1e                	je     8016b6 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801698:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169b:	8b 40 08             	mov    0x8(%eax),%eax
  80169e:	85 c0                	test   %eax,%eax
  8016a0:	74 35                	je     8016d7 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016a2:	83 ec 04             	sub    $0x4,%esp
  8016a5:	ff 75 10             	pushl  0x10(%ebp)
  8016a8:	ff 75 0c             	pushl  0xc(%ebp)
  8016ab:	52                   	push   %edx
  8016ac:	ff d0                	call   *%eax
  8016ae:	83 c4 10             	add    $0x10,%esp
}
  8016b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016b4:	c9                   	leave  
  8016b5:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8016b6:	a1 90 77 80 00       	mov    0x807790,%eax
  8016bb:	8b 40 48             	mov    0x48(%eax),%eax
  8016be:	83 ec 04             	sub    $0x4,%esp
  8016c1:	53                   	push   %ebx
  8016c2:	50                   	push   %eax
  8016c3:	68 f1 32 80 00       	push   $0x8032f1
  8016c8:	e8 7b ee ff ff       	call   800548 <cprintf>
		return -E_INVAL;
  8016cd:	83 c4 10             	add    $0x10,%esp
  8016d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016d5:	eb da                	jmp    8016b1 <read+0x5a>
		return -E_NOT_SUPP;
  8016d7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016dc:	eb d3                	jmp    8016b1 <read+0x5a>

008016de <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
  8016e1:	57                   	push   %edi
  8016e2:	56                   	push   %esi
  8016e3:	53                   	push   %ebx
  8016e4:	83 ec 0c             	sub    $0xc,%esp
  8016e7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016ea:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016f2:	39 f3                	cmp    %esi,%ebx
  8016f4:	73 23                	jae    801719 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016f6:	83 ec 04             	sub    $0x4,%esp
  8016f9:	89 f0                	mov    %esi,%eax
  8016fb:	29 d8                	sub    %ebx,%eax
  8016fd:	50                   	push   %eax
  8016fe:	89 d8                	mov    %ebx,%eax
  801700:	03 45 0c             	add    0xc(%ebp),%eax
  801703:	50                   	push   %eax
  801704:	57                   	push   %edi
  801705:	e8 4d ff ff ff       	call   801657 <read>
		if (m < 0)
  80170a:	83 c4 10             	add    $0x10,%esp
  80170d:	85 c0                	test   %eax,%eax
  80170f:	78 06                	js     801717 <readn+0x39>
			return m;
		if (m == 0)
  801711:	74 06                	je     801719 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801713:	01 c3                	add    %eax,%ebx
  801715:	eb db                	jmp    8016f2 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801717:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801719:	89 d8                	mov    %ebx,%eax
  80171b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80171e:	5b                   	pop    %ebx
  80171f:	5e                   	pop    %esi
  801720:	5f                   	pop    %edi
  801721:	5d                   	pop    %ebp
  801722:	c3                   	ret    

00801723 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
  801726:	53                   	push   %ebx
  801727:	83 ec 1c             	sub    $0x1c,%esp
  80172a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80172d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801730:	50                   	push   %eax
  801731:	53                   	push   %ebx
  801732:	e8 b0 fc ff ff       	call   8013e7 <fd_lookup>
  801737:	83 c4 10             	add    $0x10,%esp
  80173a:	85 c0                	test   %eax,%eax
  80173c:	78 3a                	js     801778 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80173e:	83 ec 08             	sub    $0x8,%esp
  801741:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801744:	50                   	push   %eax
  801745:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801748:	ff 30                	pushl  (%eax)
  80174a:	e8 e8 fc ff ff       	call   801437 <dev_lookup>
  80174f:	83 c4 10             	add    $0x10,%esp
  801752:	85 c0                	test   %eax,%eax
  801754:	78 22                	js     801778 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801756:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801759:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80175d:	74 1e                	je     80177d <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80175f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801762:	8b 52 0c             	mov    0xc(%edx),%edx
  801765:	85 d2                	test   %edx,%edx
  801767:	74 35                	je     80179e <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801769:	83 ec 04             	sub    $0x4,%esp
  80176c:	ff 75 10             	pushl  0x10(%ebp)
  80176f:	ff 75 0c             	pushl  0xc(%ebp)
  801772:	50                   	push   %eax
  801773:	ff d2                	call   *%edx
  801775:	83 c4 10             	add    $0x10,%esp
}
  801778:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80177b:	c9                   	leave  
  80177c:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80177d:	a1 90 77 80 00       	mov    0x807790,%eax
  801782:	8b 40 48             	mov    0x48(%eax),%eax
  801785:	83 ec 04             	sub    $0x4,%esp
  801788:	53                   	push   %ebx
  801789:	50                   	push   %eax
  80178a:	68 0d 33 80 00       	push   $0x80330d
  80178f:	e8 b4 ed ff ff       	call   800548 <cprintf>
		return -E_INVAL;
  801794:	83 c4 10             	add    $0x10,%esp
  801797:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80179c:	eb da                	jmp    801778 <write+0x55>
		return -E_NOT_SUPP;
  80179e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017a3:	eb d3                	jmp    801778 <write+0x55>

008017a5 <seek>:

int
seek(int fdnum, off_t offset)
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
  8017a8:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ae:	50                   	push   %eax
  8017af:	ff 75 08             	pushl  0x8(%ebp)
  8017b2:	e8 30 fc ff ff       	call   8013e7 <fd_lookup>
  8017b7:	83 c4 10             	add    $0x10,%esp
  8017ba:	85 c0                	test   %eax,%eax
  8017bc:	78 0e                	js     8017cc <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8017be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c4:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8017c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017cc:	c9                   	leave  
  8017cd:	c3                   	ret    

008017ce <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
  8017d1:	53                   	push   %ebx
  8017d2:	83 ec 1c             	sub    $0x1c,%esp
  8017d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017d8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017db:	50                   	push   %eax
  8017dc:	53                   	push   %ebx
  8017dd:	e8 05 fc ff ff       	call   8013e7 <fd_lookup>
  8017e2:	83 c4 10             	add    $0x10,%esp
  8017e5:	85 c0                	test   %eax,%eax
  8017e7:	78 37                	js     801820 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017e9:	83 ec 08             	sub    $0x8,%esp
  8017ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ef:	50                   	push   %eax
  8017f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f3:	ff 30                	pushl  (%eax)
  8017f5:	e8 3d fc ff ff       	call   801437 <dev_lookup>
  8017fa:	83 c4 10             	add    $0x10,%esp
  8017fd:	85 c0                	test   %eax,%eax
  8017ff:	78 1f                	js     801820 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801801:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801804:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801808:	74 1b                	je     801825 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80180a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80180d:	8b 52 18             	mov    0x18(%edx),%edx
  801810:	85 d2                	test   %edx,%edx
  801812:	74 32                	je     801846 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801814:	83 ec 08             	sub    $0x8,%esp
  801817:	ff 75 0c             	pushl  0xc(%ebp)
  80181a:	50                   	push   %eax
  80181b:	ff d2                	call   *%edx
  80181d:	83 c4 10             	add    $0x10,%esp
}
  801820:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801823:	c9                   	leave  
  801824:	c3                   	ret    
			thisenv->env_id, fdnum);
  801825:	a1 90 77 80 00       	mov    0x807790,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80182a:	8b 40 48             	mov    0x48(%eax),%eax
  80182d:	83 ec 04             	sub    $0x4,%esp
  801830:	53                   	push   %ebx
  801831:	50                   	push   %eax
  801832:	68 d0 32 80 00       	push   $0x8032d0
  801837:	e8 0c ed ff ff       	call   800548 <cprintf>
		return -E_INVAL;
  80183c:	83 c4 10             	add    $0x10,%esp
  80183f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801844:	eb da                	jmp    801820 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801846:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80184b:	eb d3                	jmp    801820 <ftruncate+0x52>

0080184d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
  801850:	53                   	push   %ebx
  801851:	83 ec 1c             	sub    $0x1c,%esp
  801854:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801857:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80185a:	50                   	push   %eax
  80185b:	ff 75 08             	pushl  0x8(%ebp)
  80185e:	e8 84 fb ff ff       	call   8013e7 <fd_lookup>
  801863:	83 c4 10             	add    $0x10,%esp
  801866:	85 c0                	test   %eax,%eax
  801868:	78 4b                	js     8018b5 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80186a:	83 ec 08             	sub    $0x8,%esp
  80186d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801870:	50                   	push   %eax
  801871:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801874:	ff 30                	pushl  (%eax)
  801876:	e8 bc fb ff ff       	call   801437 <dev_lookup>
  80187b:	83 c4 10             	add    $0x10,%esp
  80187e:	85 c0                	test   %eax,%eax
  801880:	78 33                	js     8018b5 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801882:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801885:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801889:	74 2f                	je     8018ba <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80188b:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80188e:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801895:	00 00 00 
	stat->st_isdir = 0;
  801898:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80189f:	00 00 00 
	stat->st_dev = dev;
  8018a2:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018a8:	83 ec 08             	sub    $0x8,%esp
  8018ab:	53                   	push   %ebx
  8018ac:	ff 75 f0             	pushl  -0x10(%ebp)
  8018af:	ff 50 14             	call   *0x14(%eax)
  8018b2:	83 c4 10             	add    $0x10,%esp
}
  8018b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018b8:	c9                   	leave  
  8018b9:	c3                   	ret    
		return -E_NOT_SUPP;
  8018ba:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018bf:	eb f4                	jmp    8018b5 <fstat+0x68>

008018c1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	56                   	push   %esi
  8018c5:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018c6:	83 ec 08             	sub    $0x8,%esp
  8018c9:	6a 00                	push   $0x0
  8018cb:	ff 75 08             	pushl  0x8(%ebp)
  8018ce:	e8 22 02 00 00       	call   801af5 <open>
  8018d3:	89 c3                	mov    %eax,%ebx
  8018d5:	83 c4 10             	add    $0x10,%esp
  8018d8:	85 c0                	test   %eax,%eax
  8018da:	78 1b                	js     8018f7 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8018dc:	83 ec 08             	sub    $0x8,%esp
  8018df:	ff 75 0c             	pushl  0xc(%ebp)
  8018e2:	50                   	push   %eax
  8018e3:	e8 65 ff ff ff       	call   80184d <fstat>
  8018e8:	89 c6                	mov    %eax,%esi
	close(fd);
  8018ea:	89 1c 24             	mov    %ebx,(%esp)
  8018ed:	e8 27 fc ff ff       	call   801519 <close>
	return r;
  8018f2:	83 c4 10             	add    $0x10,%esp
  8018f5:	89 f3                	mov    %esi,%ebx
}
  8018f7:	89 d8                	mov    %ebx,%eax
  8018f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018fc:	5b                   	pop    %ebx
  8018fd:	5e                   	pop    %esi
  8018fe:	5d                   	pop    %ebp
  8018ff:	c3                   	ret    

00801900 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
  801903:	56                   	push   %esi
  801904:	53                   	push   %ebx
  801905:	89 c6                	mov    %eax,%esi
  801907:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801909:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801910:	74 27                	je     801939 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801912:	6a 07                	push   $0x7
  801914:	68 00 80 80 00       	push   $0x808000
  801919:	56                   	push   %esi
  80191a:	ff 35 00 60 80 00    	pushl  0x806000
  801920:	e8 fe 10 00 00       	call   802a23 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801925:	83 c4 0c             	add    $0xc,%esp
  801928:	6a 00                	push   $0x0
  80192a:	53                   	push   %ebx
  80192b:	6a 00                	push   $0x0
  80192d:	e8 88 10 00 00       	call   8029ba <ipc_recv>
}
  801932:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801935:	5b                   	pop    %ebx
  801936:	5e                   	pop    %esi
  801937:	5d                   	pop    %ebp
  801938:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801939:	83 ec 0c             	sub    $0xc,%esp
  80193c:	6a 01                	push   $0x1
  80193e:	e8 38 11 00 00       	call   802a7b <ipc_find_env>
  801943:	a3 00 60 80 00       	mov    %eax,0x806000
  801948:	83 c4 10             	add    $0x10,%esp
  80194b:	eb c5                	jmp    801912 <fsipc+0x12>

0080194d <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
  801950:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	8b 40 0c             	mov    0xc(%eax),%eax
  801959:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.set_size.req_size = newsize;
  80195e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801961:	a3 04 80 80 00       	mov    %eax,0x808004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801966:	ba 00 00 00 00       	mov    $0x0,%edx
  80196b:	b8 02 00 00 00       	mov    $0x2,%eax
  801970:	e8 8b ff ff ff       	call   801900 <fsipc>
}
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <devfile_flush>:
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
  80197a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80197d:	8b 45 08             	mov    0x8(%ebp),%eax
  801980:	8b 40 0c             	mov    0xc(%eax),%eax
  801983:	a3 00 80 80 00       	mov    %eax,0x808000
	return fsipc(FSREQ_FLUSH, NULL);
  801988:	ba 00 00 00 00       	mov    $0x0,%edx
  80198d:	b8 06 00 00 00       	mov    $0x6,%eax
  801992:	e8 69 ff ff ff       	call   801900 <fsipc>
}
  801997:	c9                   	leave  
  801998:	c3                   	ret    

00801999 <devfile_stat>:
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
  80199c:	53                   	push   %ebx
  80199d:	83 ec 04             	sub    $0x4,%esp
  8019a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8019a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8019a9:	a3 00 80 80 00       	mov    %eax,0x808000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8019ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b3:	b8 05 00 00 00       	mov    $0x5,%eax
  8019b8:	e8 43 ff ff ff       	call   801900 <fsipc>
  8019bd:	85 c0                	test   %eax,%eax
  8019bf:	78 2c                	js     8019ed <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019c1:	83 ec 08             	sub    $0x8,%esp
  8019c4:	68 00 80 80 00       	push   $0x808000
  8019c9:	53                   	push   %ebx
  8019ca:	e8 d8 f2 ff ff       	call   800ca7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019cf:	a1 80 80 80 00       	mov    0x808080,%eax
  8019d4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019da:	a1 84 80 80 00       	mov    0x808084,%eax
  8019df:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8019e5:	83 c4 10             	add    $0x10,%esp
  8019e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <devfile_write>:
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
  8019f5:	53                   	push   %ebx
  8019f6:	83 ec 08             	sub    $0x8,%esp
  8019f9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ff:	8b 40 0c             	mov    0xc(%eax),%eax
  801a02:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.write.req_n = n;
  801a07:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801a0d:	53                   	push   %ebx
  801a0e:	ff 75 0c             	pushl  0xc(%ebp)
  801a11:	68 08 80 80 00       	push   $0x808008
  801a16:	e8 7c f4 ff ff       	call   800e97 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801a1b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a20:	b8 04 00 00 00       	mov    $0x4,%eax
  801a25:	e8 d6 fe ff ff       	call   801900 <fsipc>
  801a2a:	83 c4 10             	add    $0x10,%esp
  801a2d:	85 c0                	test   %eax,%eax
  801a2f:	78 0b                	js     801a3c <devfile_write+0x4a>
	assert(r <= n);
  801a31:	39 d8                	cmp    %ebx,%eax
  801a33:	77 0c                	ja     801a41 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801a35:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a3a:	7f 1e                	jg     801a5a <devfile_write+0x68>
}
  801a3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    
	assert(r <= n);
  801a41:	68 40 33 80 00       	push   $0x803340
  801a46:	68 47 33 80 00       	push   $0x803347
  801a4b:	68 98 00 00 00       	push   $0x98
  801a50:	68 5c 33 80 00       	push   $0x80335c
  801a55:	e8 f8 e9 ff ff       	call   800452 <_panic>
	assert(r <= PGSIZE);
  801a5a:	68 67 33 80 00       	push   $0x803367
  801a5f:	68 47 33 80 00       	push   $0x803347
  801a64:	68 99 00 00 00       	push   $0x99
  801a69:	68 5c 33 80 00       	push   $0x80335c
  801a6e:	e8 df e9 ff ff       	call   800452 <_panic>

00801a73 <devfile_read>:
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
  801a76:	56                   	push   %esi
  801a77:	53                   	push   %ebx
  801a78:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7e:	8b 40 0c             	mov    0xc(%eax),%eax
  801a81:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.read.req_n = n;
  801a86:	89 35 04 80 80 00    	mov    %esi,0x808004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a8c:	ba 00 00 00 00       	mov    $0x0,%edx
  801a91:	b8 03 00 00 00       	mov    $0x3,%eax
  801a96:	e8 65 fe ff ff       	call   801900 <fsipc>
  801a9b:	89 c3                	mov    %eax,%ebx
  801a9d:	85 c0                	test   %eax,%eax
  801a9f:	78 1f                	js     801ac0 <devfile_read+0x4d>
	assert(r <= n);
  801aa1:	39 f0                	cmp    %esi,%eax
  801aa3:	77 24                	ja     801ac9 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801aa5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801aaa:	7f 33                	jg     801adf <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801aac:	83 ec 04             	sub    $0x4,%esp
  801aaf:	50                   	push   %eax
  801ab0:	68 00 80 80 00       	push   $0x808000
  801ab5:	ff 75 0c             	pushl  0xc(%ebp)
  801ab8:	e8 78 f3 ff ff       	call   800e35 <memmove>
	return r;
  801abd:	83 c4 10             	add    $0x10,%esp
}
  801ac0:	89 d8                	mov    %ebx,%eax
  801ac2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ac5:	5b                   	pop    %ebx
  801ac6:	5e                   	pop    %esi
  801ac7:	5d                   	pop    %ebp
  801ac8:	c3                   	ret    
	assert(r <= n);
  801ac9:	68 40 33 80 00       	push   $0x803340
  801ace:	68 47 33 80 00       	push   $0x803347
  801ad3:	6a 7c                	push   $0x7c
  801ad5:	68 5c 33 80 00       	push   $0x80335c
  801ada:	e8 73 e9 ff ff       	call   800452 <_panic>
	assert(r <= PGSIZE);
  801adf:	68 67 33 80 00       	push   $0x803367
  801ae4:	68 47 33 80 00       	push   $0x803347
  801ae9:	6a 7d                	push   $0x7d
  801aeb:	68 5c 33 80 00       	push   $0x80335c
  801af0:	e8 5d e9 ff ff       	call   800452 <_panic>

00801af5 <open>:
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
  801af8:	56                   	push   %esi
  801af9:	53                   	push   %ebx
  801afa:	83 ec 1c             	sub    $0x1c,%esp
  801afd:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b00:	56                   	push   %esi
  801b01:	e8 68 f1 ff ff       	call   800c6e <strlen>
  801b06:	83 c4 10             	add    $0x10,%esp
  801b09:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b0e:	7f 6c                	jg     801b7c <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801b10:	83 ec 0c             	sub    $0xc,%esp
  801b13:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b16:	50                   	push   %eax
  801b17:	e8 79 f8 ff ff       	call   801395 <fd_alloc>
  801b1c:	89 c3                	mov    %eax,%ebx
  801b1e:	83 c4 10             	add    $0x10,%esp
  801b21:	85 c0                	test   %eax,%eax
  801b23:	78 3c                	js     801b61 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801b25:	83 ec 08             	sub    $0x8,%esp
  801b28:	56                   	push   %esi
  801b29:	68 00 80 80 00       	push   $0x808000
  801b2e:	e8 74 f1 ff ff       	call   800ca7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b36:	a3 00 84 80 00       	mov    %eax,0x808400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b3e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b43:	e8 b8 fd ff ff       	call   801900 <fsipc>
  801b48:	89 c3                	mov    %eax,%ebx
  801b4a:	83 c4 10             	add    $0x10,%esp
  801b4d:	85 c0                	test   %eax,%eax
  801b4f:	78 19                	js     801b6a <open+0x75>
	return fd2num(fd);
  801b51:	83 ec 0c             	sub    $0xc,%esp
  801b54:	ff 75 f4             	pushl  -0xc(%ebp)
  801b57:	e8 12 f8 ff ff       	call   80136e <fd2num>
  801b5c:	89 c3                	mov    %eax,%ebx
  801b5e:	83 c4 10             	add    $0x10,%esp
}
  801b61:	89 d8                	mov    %ebx,%eax
  801b63:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b66:	5b                   	pop    %ebx
  801b67:	5e                   	pop    %esi
  801b68:	5d                   	pop    %ebp
  801b69:	c3                   	ret    
		fd_close(fd, 0);
  801b6a:	83 ec 08             	sub    $0x8,%esp
  801b6d:	6a 00                	push   $0x0
  801b6f:	ff 75 f4             	pushl  -0xc(%ebp)
  801b72:	e8 1b f9 ff ff       	call   801492 <fd_close>
		return r;
  801b77:	83 c4 10             	add    $0x10,%esp
  801b7a:	eb e5                	jmp    801b61 <open+0x6c>
		return -E_BAD_PATH;
  801b7c:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b81:	eb de                	jmp    801b61 <open+0x6c>

00801b83 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
  801b86:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b89:	ba 00 00 00 00       	mov    $0x0,%edx
  801b8e:	b8 08 00 00 00       	mov    $0x8,%eax
  801b93:	e8 68 fd ff ff       	call   801900 <fsipc>
}
  801b98:	c9                   	leave  
  801b99:	c3                   	ret    

00801b9a <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
  801b9d:	57                   	push   %edi
  801b9e:	56                   	push   %esi
  801b9f:	53                   	push   %ebx
  801ba0:	81 ec 94 02 00 00    	sub    $0x294,%esp
	cprintf("in %s\n", __FUNCTION__);
  801ba6:	68 4c 34 80 00       	push   $0x80344c
  801bab:	68 c3 2e 80 00       	push   $0x802ec3
  801bb0:	e8 93 e9 ff ff       	call   800548 <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801bb5:	83 c4 08             	add    $0x8,%esp
  801bb8:	6a 00                	push   $0x0
  801bba:	ff 75 08             	pushl  0x8(%ebp)
  801bbd:	e8 33 ff ff ff       	call   801af5 <open>
  801bc2:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801bc8:	83 c4 10             	add    $0x10,%esp
  801bcb:	85 c0                	test   %eax,%eax
  801bcd:	0f 88 0a 05 00 00    	js     8020dd <spawn+0x543>
  801bd3:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801bd5:	83 ec 04             	sub    $0x4,%esp
  801bd8:	68 00 02 00 00       	push   $0x200
  801bdd:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801be3:	50                   	push   %eax
  801be4:	51                   	push   %ecx
  801be5:	e8 f4 fa ff ff       	call   8016de <readn>
  801bea:	83 c4 10             	add    $0x10,%esp
  801bed:	3d 00 02 00 00       	cmp    $0x200,%eax
  801bf2:	75 74                	jne    801c68 <spawn+0xce>
	    || elf->e_magic != ELF_MAGIC) {
  801bf4:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801bfb:	45 4c 46 
  801bfe:	75 68                	jne    801c68 <spawn+0xce>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801c00:	b8 07 00 00 00       	mov    $0x7,%eax
  801c05:	cd 30                	int    $0x30
  801c07:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801c0d:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801c13:	85 c0                	test   %eax,%eax
  801c15:	0f 88 b6 04 00 00    	js     8020d1 <spawn+0x537>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801c1b:	25 ff 03 00 00       	and    $0x3ff,%eax
  801c20:	89 c6                	mov    %eax,%esi
  801c22:	c1 e6 07             	shl    $0x7,%esi
  801c25:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801c2b:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801c31:	b9 11 00 00 00       	mov    $0x11,%ecx
  801c36:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801c38:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801c3e:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
	cprintf("in %s\n", __FUNCTION__);
  801c44:	83 ec 08             	sub    $0x8,%esp
  801c47:	68 40 34 80 00       	push   $0x803440
  801c4c:	68 c3 2e 80 00       	push   $0x802ec3
  801c51:	e8 f2 e8 ff ff       	call   800548 <cprintf>
  801c56:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801c59:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801c5e:	be 00 00 00 00       	mov    $0x0,%esi
  801c63:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801c66:	eb 4b                	jmp    801cb3 <spawn+0x119>
		close(fd);
  801c68:	83 ec 0c             	sub    $0xc,%esp
  801c6b:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801c71:	e8 a3 f8 ff ff       	call   801519 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801c76:	83 c4 0c             	add    $0xc,%esp
  801c79:	68 7f 45 4c 46       	push   $0x464c457f
  801c7e:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801c84:	68 73 33 80 00       	push   $0x803373
  801c89:	e8 ba e8 ff ff       	call   800548 <cprintf>
		return -E_NOT_EXEC;
  801c8e:	83 c4 10             	add    $0x10,%esp
  801c91:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801c98:	ff ff ff 
  801c9b:	e9 3d 04 00 00       	jmp    8020dd <spawn+0x543>
		string_size += strlen(argv[argc]) + 1;
  801ca0:	83 ec 0c             	sub    $0xc,%esp
  801ca3:	50                   	push   %eax
  801ca4:	e8 c5 ef ff ff       	call   800c6e <strlen>
  801ca9:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801cad:	83 c3 01             	add    $0x1,%ebx
  801cb0:	83 c4 10             	add    $0x10,%esp
  801cb3:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801cba:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801cbd:	85 c0                	test   %eax,%eax
  801cbf:	75 df                	jne    801ca0 <spawn+0x106>
  801cc1:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801cc7:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801ccd:	bf 00 10 40 00       	mov    $0x401000,%edi
  801cd2:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801cd4:	89 fa                	mov    %edi,%edx
  801cd6:	83 e2 fc             	and    $0xfffffffc,%edx
  801cd9:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801ce0:	29 c2                	sub    %eax,%edx
  801ce2:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801ce8:	8d 42 f8             	lea    -0x8(%edx),%eax
  801ceb:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801cf0:	0f 86 0a 04 00 00    	jbe    802100 <spawn+0x566>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801cf6:	83 ec 04             	sub    $0x4,%esp
  801cf9:	6a 07                	push   $0x7
  801cfb:	68 00 00 40 00       	push   $0x400000
  801d00:	6a 00                	push   $0x0
  801d02:	e8 92 f3 ff ff       	call   801099 <sys_page_alloc>
  801d07:	83 c4 10             	add    $0x10,%esp
  801d0a:	85 c0                	test   %eax,%eax
  801d0c:	0f 88 f3 03 00 00    	js     802105 <spawn+0x56b>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801d12:	be 00 00 00 00       	mov    $0x0,%esi
  801d17:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801d1d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801d20:	eb 30                	jmp    801d52 <spawn+0x1b8>
		argv_store[i] = UTEMP2USTACK(string_store);
  801d22:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801d28:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801d2e:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801d31:	83 ec 08             	sub    $0x8,%esp
  801d34:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801d37:	57                   	push   %edi
  801d38:	e8 6a ef ff ff       	call   800ca7 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801d3d:	83 c4 04             	add    $0x4,%esp
  801d40:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801d43:	e8 26 ef ff ff       	call   800c6e <strlen>
  801d48:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801d4c:	83 c6 01             	add    $0x1,%esi
  801d4f:	83 c4 10             	add    $0x10,%esp
  801d52:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801d58:	7f c8                	jg     801d22 <spawn+0x188>
	}
	argv_store[argc] = 0;
  801d5a:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801d60:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801d66:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801d6d:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801d73:	0f 85 86 00 00 00    	jne    801dff <spawn+0x265>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801d79:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  801d7f:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  801d85:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  801d88:	89 d0                	mov    %edx,%eax
  801d8a:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  801d90:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801d93:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801d98:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801d9e:	83 ec 0c             	sub    $0xc,%esp
  801da1:	6a 07                	push   $0x7
  801da3:	68 00 d0 bf ee       	push   $0xeebfd000
  801da8:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801dae:	68 00 00 40 00       	push   $0x400000
  801db3:	6a 00                	push   $0x0
  801db5:	e8 22 f3 ff ff       	call   8010dc <sys_page_map>
  801dba:	89 c3                	mov    %eax,%ebx
  801dbc:	83 c4 20             	add    $0x20,%esp
  801dbf:	85 c0                	test   %eax,%eax
  801dc1:	0f 88 46 03 00 00    	js     80210d <spawn+0x573>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801dc7:	83 ec 08             	sub    $0x8,%esp
  801dca:	68 00 00 40 00       	push   $0x400000
  801dcf:	6a 00                	push   $0x0
  801dd1:	e8 48 f3 ff ff       	call   80111e <sys_page_unmap>
  801dd6:	89 c3                	mov    %eax,%ebx
  801dd8:	83 c4 10             	add    $0x10,%esp
  801ddb:	85 c0                	test   %eax,%eax
  801ddd:	0f 88 2a 03 00 00    	js     80210d <spawn+0x573>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801de3:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801de9:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801df0:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801df7:	00 00 00 
  801dfa:	e9 4f 01 00 00       	jmp    801f4e <spawn+0x3b4>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801dff:	68 fc 33 80 00       	push   $0x8033fc
  801e04:	68 47 33 80 00       	push   $0x803347
  801e09:	68 f8 00 00 00       	push   $0xf8
  801e0e:	68 8d 33 80 00       	push   $0x80338d
  801e13:	e8 3a e6 ff ff       	call   800452 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801e18:	83 ec 04             	sub    $0x4,%esp
  801e1b:	6a 07                	push   $0x7
  801e1d:	68 00 00 40 00       	push   $0x400000
  801e22:	6a 00                	push   $0x0
  801e24:	e8 70 f2 ff ff       	call   801099 <sys_page_alloc>
  801e29:	83 c4 10             	add    $0x10,%esp
  801e2c:	85 c0                	test   %eax,%eax
  801e2e:	0f 88 b7 02 00 00    	js     8020eb <spawn+0x551>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801e34:	83 ec 08             	sub    $0x8,%esp
  801e37:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801e3d:	01 f0                	add    %esi,%eax
  801e3f:	50                   	push   %eax
  801e40:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801e46:	e8 5a f9 ff ff       	call   8017a5 <seek>
  801e4b:	83 c4 10             	add    $0x10,%esp
  801e4e:	85 c0                	test   %eax,%eax
  801e50:	0f 88 9c 02 00 00    	js     8020f2 <spawn+0x558>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801e56:	83 ec 04             	sub    $0x4,%esp
  801e59:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801e5f:	29 f0                	sub    %esi,%eax
  801e61:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e66:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801e6b:	0f 47 c1             	cmova  %ecx,%eax
  801e6e:	50                   	push   %eax
  801e6f:	68 00 00 40 00       	push   $0x400000
  801e74:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801e7a:	e8 5f f8 ff ff       	call   8016de <readn>
  801e7f:	83 c4 10             	add    $0x10,%esp
  801e82:	85 c0                	test   %eax,%eax
  801e84:	0f 88 6f 02 00 00    	js     8020f9 <spawn+0x55f>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801e8a:	83 ec 0c             	sub    $0xc,%esp
  801e8d:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801e93:	53                   	push   %ebx
  801e94:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801e9a:	68 00 00 40 00       	push   $0x400000
  801e9f:	6a 00                	push   $0x0
  801ea1:	e8 36 f2 ff ff       	call   8010dc <sys_page_map>
  801ea6:	83 c4 20             	add    $0x20,%esp
  801ea9:	85 c0                	test   %eax,%eax
  801eab:	78 7c                	js     801f29 <spawn+0x38f>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801ead:	83 ec 08             	sub    $0x8,%esp
  801eb0:	68 00 00 40 00       	push   $0x400000
  801eb5:	6a 00                	push   $0x0
  801eb7:	e8 62 f2 ff ff       	call   80111e <sys_page_unmap>
  801ebc:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801ebf:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801ec5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801ecb:	89 fe                	mov    %edi,%esi
  801ecd:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801ed3:	76 69                	jbe    801f3e <spawn+0x3a4>
		if (i >= filesz) {
  801ed5:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801edb:	0f 87 37 ff ff ff    	ja     801e18 <spawn+0x27e>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801ee1:	83 ec 04             	sub    $0x4,%esp
  801ee4:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801eea:	53                   	push   %ebx
  801eeb:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801ef1:	e8 a3 f1 ff ff       	call   801099 <sys_page_alloc>
  801ef6:	83 c4 10             	add    $0x10,%esp
  801ef9:	85 c0                	test   %eax,%eax
  801efb:	79 c2                	jns    801ebf <spawn+0x325>
  801efd:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801eff:	83 ec 0c             	sub    $0xc,%esp
  801f02:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801f08:	e8 0d f1 ff ff       	call   80101a <sys_env_destroy>
	close(fd);
  801f0d:	83 c4 04             	add    $0x4,%esp
  801f10:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801f16:	e8 fe f5 ff ff       	call   801519 <close>
	return r;
  801f1b:	83 c4 10             	add    $0x10,%esp
  801f1e:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801f24:	e9 b4 01 00 00       	jmp    8020dd <spawn+0x543>
				panic("spawn: sys_page_map data: %e", r);
  801f29:	50                   	push   %eax
  801f2a:	68 99 33 80 00       	push   $0x803399
  801f2f:	68 2b 01 00 00       	push   $0x12b
  801f34:	68 8d 33 80 00       	push   $0x80338d
  801f39:	e8 14 e5 ff ff       	call   800452 <_panic>
  801f3e:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801f44:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801f4b:	83 c6 20             	add    $0x20,%esi
  801f4e:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801f55:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801f5b:	7e 6d                	jle    801fca <spawn+0x430>
		if (ph->p_type != ELF_PROG_LOAD)
  801f5d:	83 3e 01             	cmpl   $0x1,(%esi)
  801f60:	75 e2                	jne    801f44 <spawn+0x3aa>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801f62:	8b 46 18             	mov    0x18(%esi),%eax
  801f65:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801f68:	83 f8 01             	cmp    $0x1,%eax
  801f6b:	19 c0                	sbb    %eax,%eax
  801f6d:	83 e0 fe             	and    $0xfffffffe,%eax
  801f70:	83 c0 07             	add    $0x7,%eax
  801f73:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801f79:	8b 4e 04             	mov    0x4(%esi),%ecx
  801f7c:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801f82:	8b 56 10             	mov    0x10(%esi),%edx
  801f85:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801f8b:	8b 7e 14             	mov    0x14(%esi),%edi
  801f8e:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801f94:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801f97:	89 d8                	mov    %ebx,%eax
  801f99:	25 ff 0f 00 00       	and    $0xfff,%eax
  801f9e:	74 1a                	je     801fba <spawn+0x420>
		va -= i;
  801fa0:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801fa2:	01 c7                	add    %eax,%edi
  801fa4:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801faa:	01 c2                	add    %eax,%edx
  801fac:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801fb2:	29 c1                	sub    %eax,%ecx
  801fb4:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801fba:	bf 00 00 00 00       	mov    $0x0,%edi
  801fbf:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801fc5:	e9 01 ff ff ff       	jmp    801ecb <spawn+0x331>
	close(fd);
  801fca:	83 ec 0c             	sub    $0xc,%esp
  801fcd:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801fd3:	e8 41 f5 ff ff       	call   801519 <close>

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	cprintf("in %s\n", __FUNCTION__);
  801fd8:	83 c4 08             	add    $0x8,%esp
  801fdb:	68 2c 34 80 00       	push   $0x80342c
  801fe0:	68 c3 2e 80 00       	push   $0x802ec3
  801fe5:	e8 5e e5 ff ff       	call   800548 <cprintf>
  801fea:	83 c4 10             	add    $0x10,%esp
	int r;
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  801fed:	bb 00 00 80 00       	mov    $0x800000,%ebx
  801ff2:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  801ff8:	eb 0e                	jmp    802008 <spawn+0x46e>
  801ffa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802000:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  802006:	74 5e                	je     802066 <spawn+0x4cc>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_SHARE)) == (PTE_P | PTE_U | PTE_SHARE)))
  802008:	89 d8                	mov    %ebx,%eax
  80200a:	c1 e8 16             	shr    $0x16,%eax
  80200d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802014:	a8 01                	test   $0x1,%al
  802016:	74 e2                	je     801ffa <spawn+0x460>
  802018:	89 da                	mov    %ebx,%edx
  80201a:	c1 ea 0c             	shr    $0xc,%edx
  80201d:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  802024:	25 05 04 00 00       	and    $0x405,%eax
  802029:	3d 05 04 00 00       	cmp    $0x405,%eax
  80202e:	75 ca                	jne    801ffa <spawn+0x460>
			if((r = sys_page_map((envid_t)0, (void *)i, child, (void *)i, uvpt[PGNUM(i)] & PTE_SYSCALL)) < 0)
  802030:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  802037:	83 ec 0c             	sub    $0xc,%esp
  80203a:	25 07 0e 00 00       	and    $0xe07,%eax
  80203f:	50                   	push   %eax
  802040:	53                   	push   %ebx
  802041:	56                   	push   %esi
  802042:	53                   	push   %ebx
  802043:	6a 00                	push   $0x0
  802045:	e8 92 f0 ff ff       	call   8010dc <sys_page_map>
  80204a:	83 c4 20             	add    $0x20,%esp
  80204d:	85 c0                	test   %eax,%eax
  80204f:	79 a9                	jns    801ffa <spawn+0x460>
        		panic("sys_page_map: %e\n", r);
  802051:	50                   	push   %eax
  802052:	68 b6 33 80 00       	push   $0x8033b6
  802057:	68 3b 01 00 00       	push   $0x13b
  80205c:	68 8d 33 80 00       	push   $0x80338d
  802061:	e8 ec e3 ff ff       	call   800452 <_panic>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802066:	83 ec 08             	sub    $0x8,%esp
  802069:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  80206f:	50                   	push   %eax
  802070:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802076:	e8 27 f1 ff ff       	call   8011a2 <sys_env_set_trapframe>
  80207b:	83 c4 10             	add    $0x10,%esp
  80207e:	85 c0                	test   %eax,%eax
  802080:	78 25                	js     8020a7 <spawn+0x50d>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802082:	83 ec 08             	sub    $0x8,%esp
  802085:	6a 02                	push   $0x2
  802087:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80208d:	e8 ce f0 ff ff       	call   801160 <sys_env_set_status>
  802092:	83 c4 10             	add    $0x10,%esp
  802095:	85 c0                	test   %eax,%eax
  802097:	78 23                	js     8020bc <spawn+0x522>
	return child;
  802099:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80209f:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8020a5:	eb 36                	jmp    8020dd <spawn+0x543>
		panic("sys_env_set_trapframe: %e", r);
  8020a7:	50                   	push   %eax
  8020a8:	68 c8 33 80 00       	push   $0x8033c8
  8020ad:	68 8a 00 00 00       	push   $0x8a
  8020b2:	68 8d 33 80 00       	push   $0x80338d
  8020b7:	e8 96 e3 ff ff       	call   800452 <_panic>
		panic("sys_env_set_status: %e", r);
  8020bc:	50                   	push   %eax
  8020bd:	68 e2 33 80 00       	push   $0x8033e2
  8020c2:	68 8d 00 00 00       	push   $0x8d
  8020c7:	68 8d 33 80 00       	push   $0x80338d
  8020cc:	e8 81 e3 ff ff       	call   800452 <_panic>
		return r;
  8020d1:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8020d7:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  8020dd:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8020e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020e6:	5b                   	pop    %ebx
  8020e7:	5e                   	pop    %esi
  8020e8:	5f                   	pop    %edi
  8020e9:	5d                   	pop    %ebp
  8020ea:	c3                   	ret    
  8020eb:	89 c7                	mov    %eax,%edi
  8020ed:	e9 0d fe ff ff       	jmp    801eff <spawn+0x365>
  8020f2:	89 c7                	mov    %eax,%edi
  8020f4:	e9 06 fe ff ff       	jmp    801eff <spawn+0x365>
  8020f9:	89 c7                	mov    %eax,%edi
  8020fb:	e9 ff fd ff ff       	jmp    801eff <spawn+0x365>
		return -E_NO_MEM;
  802100:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  802105:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  80210b:	eb d0                	jmp    8020dd <spawn+0x543>
	sys_page_unmap(0, UTEMP);
  80210d:	83 ec 08             	sub    $0x8,%esp
  802110:	68 00 00 40 00       	push   $0x400000
  802115:	6a 00                	push   $0x0
  802117:	e8 02 f0 ff ff       	call   80111e <sys_page_unmap>
  80211c:	83 c4 10             	add    $0x10,%esp
  80211f:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  802125:	eb b6                	jmp    8020dd <spawn+0x543>

00802127 <spawnl>:
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
  80212a:	57                   	push   %edi
  80212b:	56                   	push   %esi
  80212c:	53                   	push   %ebx
  80212d:	83 ec 14             	sub    $0x14,%esp
	cprintf("in %s\n", __FUNCTION__);
  802130:	68 24 34 80 00       	push   $0x803424
  802135:	68 c3 2e 80 00       	push   $0x802ec3
  80213a:	e8 09 e4 ff ff       	call   800548 <cprintf>
	va_start(vl, arg0);
  80213f:	8d 55 10             	lea    0x10(%ebp),%edx
	while(va_arg(vl, void *) != NULL)
  802142:	83 c4 10             	add    $0x10,%esp
	int argc=0;
  802145:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  80214a:	8d 4a 04             	lea    0x4(%edx),%ecx
  80214d:	83 3a 00             	cmpl   $0x0,(%edx)
  802150:	74 07                	je     802159 <spawnl+0x32>
		argc++;
  802152:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  802155:	89 ca                	mov    %ecx,%edx
  802157:	eb f1                	jmp    80214a <spawnl+0x23>
	const char *argv[argc+2];
  802159:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  802160:	83 e2 f0             	and    $0xfffffff0,%edx
  802163:	29 d4                	sub    %edx,%esp
  802165:	8d 54 24 03          	lea    0x3(%esp),%edx
  802169:	c1 ea 02             	shr    $0x2,%edx
  80216c:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  802173:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802175:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802178:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  80217f:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  802186:	00 
	va_start(vl, arg0);
  802187:	8d 4d 10             	lea    0x10(%ebp),%ecx
  80218a:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  80218c:	b8 00 00 00 00       	mov    $0x0,%eax
  802191:	eb 0b                	jmp    80219e <spawnl+0x77>
		argv[i+1] = va_arg(vl, const char *);
  802193:	83 c0 01             	add    $0x1,%eax
  802196:	8b 39                	mov    (%ecx),%edi
  802198:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  80219b:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  80219e:	39 d0                	cmp    %edx,%eax
  8021a0:	75 f1                	jne    802193 <spawnl+0x6c>
	return spawn(prog, argv);
  8021a2:	83 ec 08             	sub    $0x8,%esp
  8021a5:	56                   	push   %esi
  8021a6:	ff 75 08             	pushl  0x8(%ebp)
  8021a9:	e8 ec f9 ff ff       	call   801b9a <spawn>
}
  8021ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021b1:	5b                   	pop    %ebx
  8021b2:	5e                   	pop    %esi
  8021b3:	5f                   	pop    %edi
  8021b4:	5d                   	pop    %ebp
  8021b5:	c3                   	ret    

008021b6 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8021b6:	55                   	push   %ebp
  8021b7:	89 e5                	mov    %esp,%ebp
  8021b9:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8021bc:	68 52 34 80 00       	push   $0x803452
  8021c1:	ff 75 0c             	pushl  0xc(%ebp)
  8021c4:	e8 de ea ff ff       	call   800ca7 <strcpy>
	return 0;
}
  8021c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ce:	c9                   	leave  
  8021cf:	c3                   	ret    

008021d0 <devsock_close>:
{
  8021d0:	55                   	push   %ebp
  8021d1:	89 e5                	mov    %esp,%ebp
  8021d3:	53                   	push   %ebx
  8021d4:	83 ec 10             	sub    $0x10,%esp
  8021d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8021da:	53                   	push   %ebx
  8021db:	e8 d6 08 00 00       	call   802ab6 <pageref>
  8021e0:	83 c4 10             	add    $0x10,%esp
		return 0;
  8021e3:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8021e8:	83 f8 01             	cmp    $0x1,%eax
  8021eb:	74 07                	je     8021f4 <devsock_close+0x24>
}
  8021ed:	89 d0                	mov    %edx,%eax
  8021ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021f2:	c9                   	leave  
  8021f3:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8021f4:	83 ec 0c             	sub    $0xc,%esp
  8021f7:	ff 73 0c             	pushl  0xc(%ebx)
  8021fa:	e8 b9 02 00 00       	call   8024b8 <nsipc_close>
  8021ff:	89 c2                	mov    %eax,%edx
  802201:	83 c4 10             	add    $0x10,%esp
  802204:	eb e7                	jmp    8021ed <devsock_close+0x1d>

00802206 <devsock_write>:
{
  802206:	55                   	push   %ebp
  802207:	89 e5                	mov    %esp,%ebp
  802209:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80220c:	6a 00                	push   $0x0
  80220e:	ff 75 10             	pushl  0x10(%ebp)
  802211:	ff 75 0c             	pushl  0xc(%ebp)
  802214:	8b 45 08             	mov    0x8(%ebp),%eax
  802217:	ff 70 0c             	pushl  0xc(%eax)
  80221a:	e8 76 03 00 00       	call   802595 <nsipc_send>
}
  80221f:	c9                   	leave  
  802220:	c3                   	ret    

00802221 <devsock_read>:
{
  802221:	55                   	push   %ebp
  802222:	89 e5                	mov    %esp,%ebp
  802224:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802227:	6a 00                	push   $0x0
  802229:	ff 75 10             	pushl  0x10(%ebp)
  80222c:	ff 75 0c             	pushl  0xc(%ebp)
  80222f:	8b 45 08             	mov    0x8(%ebp),%eax
  802232:	ff 70 0c             	pushl  0xc(%eax)
  802235:	e8 ef 02 00 00       	call   802529 <nsipc_recv>
}
  80223a:	c9                   	leave  
  80223b:	c3                   	ret    

0080223c <fd2sockid>:
{
  80223c:	55                   	push   %ebp
  80223d:	89 e5                	mov    %esp,%ebp
  80223f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802242:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802245:	52                   	push   %edx
  802246:	50                   	push   %eax
  802247:	e8 9b f1 ff ff       	call   8013e7 <fd_lookup>
  80224c:	83 c4 10             	add    $0x10,%esp
  80224f:	85 c0                	test   %eax,%eax
  802251:	78 10                	js     802263 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802253:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802256:	8b 0d ac 57 80 00    	mov    0x8057ac,%ecx
  80225c:	39 08                	cmp    %ecx,(%eax)
  80225e:	75 05                	jne    802265 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802260:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802263:	c9                   	leave  
  802264:	c3                   	ret    
		return -E_NOT_SUPP;
  802265:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80226a:	eb f7                	jmp    802263 <fd2sockid+0x27>

0080226c <alloc_sockfd>:
{
  80226c:	55                   	push   %ebp
  80226d:	89 e5                	mov    %esp,%ebp
  80226f:	56                   	push   %esi
  802270:	53                   	push   %ebx
  802271:	83 ec 1c             	sub    $0x1c,%esp
  802274:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802276:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802279:	50                   	push   %eax
  80227a:	e8 16 f1 ff ff       	call   801395 <fd_alloc>
  80227f:	89 c3                	mov    %eax,%ebx
  802281:	83 c4 10             	add    $0x10,%esp
  802284:	85 c0                	test   %eax,%eax
  802286:	78 43                	js     8022cb <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802288:	83 ec 04             	sub    $0x4,%esp
  80228b:	68 07 04 00 00       	push   $0x407
  802290:	ff 75 f4             	pushl  -0xc(%ebp)
  802293:	6a 00                	push   $0x0
  802295:	e8 ff ed ff ff       	call   801099 <sys_page_alloc>
  80229a:	89 c3                	mov    %eax,%ebx
  80229c:	83 c4 10             	add    $0x10,%esp
  80229f:	85 c0                	test   %eax,%eax
  8022a1:	78 28                	js     8022cb <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8022a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a6:	8b 15 ac 57 80 00    	mov    0x8057ac,%edx
  8022ac:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8022ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8022b8:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8022bb:	83 ec 0c             	sub    $0xc,%esp
  8022be:	50                   	push   %eax
  8022bf:	e8 aa f0 ff ff       	call   80136e <fd2num>
  8022c4:	89 c3                	mov    %eax,%ebx
  8022c6:	83 c4 10             	add    $0x10,%esp
  8022c9:	eb 0c                	jmp    8022d7 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8022cb:	83 ec 0c             	sub    $0xc,%esp
  8022ce:	56                   	push   %esi
  8022cf:	e8 e4 01 00 00       	call   8024b8 <nsipc_close>
		return r;
  8022d4:	83 c4 10             	add    $0x10,%esp
}
  8022d7:	89 d8                	mov    %ebx,%eax
  8022d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022dc:	5b                   	pop    %ebx
  8022dd:	5e                   	pop    %esi
  8022de:	5d                   	pop    %ebp
  8022df:	c3                   	ret    

008022e0 <accept>:
{
  8022e0:	55                   	push   %ebp
  8022e1:	89 e5                	mov    %esp,%ebp
  8022e3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8022e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e9:	e8 4e ff ff ff       	call   80223c <fd2sockid>
  8022ee:	85 c0                	test   %eax,%eax
  8022f0:	78 1b                	js     80230d <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8022f2:	83 ec 04             	sub    $0x4,%esp
  8022f5:	ff 75 10             	pushl  0x10(%ebp)
  8022f8:	ff 75 0c             	pushl  0xc(%ebp)
  8022fb:	50                   	push   %eax
  8022fc:	e8 0e 01 00 00       	call   80240f <nsipc_accept>
  802301:	83 c4 10             	add    $0x10,%esp
  802304:	85 c0                	test   %eax,%eax
  802306:	78 05                	js     80230d <accept+0x2d>
	return alloc_sockfd(r);
  802308:	e8 5f ff ff ff       	call   80226c <alloc_sockfd>
}
  80230d:	c9                   	leave  
  80230e:	c3                   	ret    

0080230f <bind>:
{
  80230f:	55                   	push   %ebp
  802310:	89 e5                	mov    %esp,%ebp
  802312:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802315:	8b 45 08             	mov    0x8(%ebp),%eax
  802318:	e8 1f ff ff ff       	call   80223c <fd2sockid>
  80231d:	85 c0                	test   %eax,%eax
  80231f:	78 12                	js     802333 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802321:	83 ec 04             	sub    $0x4,%esp
  802324:	ff 75 10             	pushl  0x10(%ebp)
  802327:	ff 75 0c             	pushl  0xc(%ebp)
  80232a:	50                   	push   %eax
  80232b:	e8 31 01 00 00       	call   802461 <nsipc_bind>
  802330:	83 c4 10             	add    $0x10,%esp
}
  802333:	c9                   	leave  
  802334:	c3                   	ret    

00802335 <shutdown>:
{
  802335:	55                   	push   %ebp
  802336:	89 e5                	mov    %esp,%ebp
  802338:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80233b:	8b 45 08             	mov    0x8(%ebp),%eax
  80233e:	e8 f9 fe ff ff       	call   80223c <fd2sockid>
  802343:	85 c0                	test   %eax,%eax
  802345:	78 0f                	js     802356 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802347:	83 ec 08             	sub    $0x8,%esp
  80234a:	ff 75 0c             	pushl  0xc(%ebp)
  80234d:	50                   	push   %eax
  80234e:	e8 43 01 00 00       	call   802496 <nsipc_shutdown>
  802353:	83 c4 10             	add    $0x10,%esp
}
  802356:	c9                   	leave  
  802357:	c3                   	ret    

00802358 <connect>:
{
  802358:	55                   	push   %ebp
  802359:	89 e5                	mov    %esp,%ebp
  80235b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80235e:	8b 45 08             	mov    0x8(%ebp),%eax
  802361:	e8 d6 fe ff ff       	call   80223c <fd2sockid>
  802366:	85 c0                	test   %eax,%eax
  802368:	78 12                	js     80237c <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80236a:	83 ec 04             	sub    $0x4,%esp
  80236d:	ff 75 10             	pushl  0x10(%ebp)
  802370:	ff 75 0c             	pushl  0xc(%ebp)
  802373:	50                   	push   %eax
  802374:	e8 59 01 00 00       	call   8024d2 <nsipc_connect>
  802379:	83 c4 10             	add    $0x10,%esp
}
  80237c:	c9                   	leave  
  80237d:	c3                   	ret    

0080237e <listen>:
{
  80237e:	55                   	push   %ebp
  80237f:	89 e5                	mov    %esp,%ebp
  802381:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802384:	8b 45 08             	mov    0x8(%ebp),%eax
  802387:	e8 b0 fe ff ff       	call   80223c <fd2sockid>
  80238c:	85 c0                	test   %eax,%eax
  80238e:	78 0f                	js     80239f <listen+0x21>
	return nsipc_listen(r, backlog);
  802390:	83 ec 08             	sub    $0x8,%esp
  802393:	ff 75 0c             	pushl  0xc(%ebp)
  802396:	50                   	push   %eax
  802397:	e8 6b 01 00 00       	call   802507 <nsipc_listen>
  80239c:	83 c4 10             	add    $0x10,%esp
}
  80239f:	c9                   	leave  
  8023a0:	c3                   	ret    

008023a1 <socket>:

int
socket(int domain, int type, int protocol)
{
  8023a1:	55                   	push   %ebp
  8023a2:	89 e5                	mov    %esp,%ebp
  8023a4:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8023a7:	ff 75 10             	pushl  0x10(%ebp)
  8023aa:	ff 75 0c             	pushl  0xc(%ebp)
  8023ad:	ff 75 08             	pushl  0x8(%ebp)
  8023b0:	e8 3e 02 00 00       	call   8025f3 <nsipc_socket>
  8023b5:	83 c4 10             	add    $0x10,%esp
  8023b8:	85 c0                	test   %eax,%eax
  8023ba:	78 05                	js     8023c1 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8023bc:	e8 ab fe ff ff       	call   80226c <alloc_sockfd>
}
  8023c1:	c9                   	leave  
  8023c2:	c3                   	ret    

008023c3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8023c3:	55                   	push   %ebp
  8023c4:	89 e5                	mov    %esp,%ebp
  8023c6:	53                   	push   %ebx
  8023c7:	83 ec 04             	sub    $0x4,%esp
  8023ca:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8023cc:	83 3d 04 60 80 00 00 	cmpl   $0x0,0x806004
  8023d3:	74 26                	je     8023fb <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8023d5:	6a 07                	push   $0x7
  8023d7:	68 00 90 80 00       	push   $0x809000
  8023dc:	53                   	push   %ebx
  8023dd:	ff 35 04 60 80 00    	pushl  0x806004
  8023e3:	e8 3b 06 00 00       	call   802a23 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8023e8:	83 c4 0c             	add    $0xc,%esp
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 00                	push   $0x0
  8023f1:	e8 c4 05 00 00       	call   8029ba <ipc_recv>
}
  8023f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023f9:	c9                   	leave  
  8023fa:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8023fb:	83 ec 0c             	sub    $0xc,%esp
  8023fe:	6a 02                	push   $0x2
  802400:	e8 76 06 00 00       	call   802a7b <ipc_find_env>
  802405:	a3 04 60 80 00       	mov    %eax,0x806004
  80240a:	83 c4 10             	add    $0x10,%esp
  80240d:	eb c6                	jmp    8023d5 <nsipc+0x12>

0080240f <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80240f:	55                   	push   %ebp
  802410:	89 e5                	mov    %esp,%ebp
  802412:	56                   	push   %esi
  802413:	53                   	push   %ebx
  802414:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802417:	8b 45 08             	mov    0x8(%ebp),%eax
  80241a:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80241f:	8b 06                	mov    (%esi),%eax
  802421:	a3 04 90 80 00       	mov    %eax,0x809004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802426:	b8 01 00 00 00       	mov    $0x1,%eax
  80242b:	e8 93 ff ff ff       	call   8023c3 <nsipc>
  802430:	89 c3                	mov    %eax,%ebx
  802432:	85 c0                	test   %eax,%eax
  802434:	79 09                	jns    80243f <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802436:	89 d8                	mov    %ebx,%eax
  802438:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80243b:	5b                   	pop    %ebx
  80243c:	5e                   	pop    %esi
  80243d:	5d                   	pop    %ebp
  80243e:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80243f:	83 ec 04             	sub    $0x4,%esp
  802442:	ff 35 10 90 80 00    	pushl  0x809010
  802448:	68 00 90 80 00       	push   $0x809000
  80244d:	ff 75 0c             	pushl  0xc(%ebp)
  802450:	e8 e0 e9 ff ff       	call   800e35 <memmove>
		*addrlen = ret->ret_addrlen;
  802455:	a1 10 90 80 00       	mov    0x809010,%eax
  80245a:	89 06                	mov    %eax,(%esi)
  80245c:	83 c4 10             	add    $0x10,%esp
	return r;
  80245f:	eb d5                	jmp    802436 <nsipc_accept+0x27>

00802461 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802461:	55                   	push   %ebp
  802462:	89 e5                	mov    %esp,%ebp
  802464:	53                   	push   %ebx
  802465:	83 ec 08             	sub    $0x8,%esp
  802468:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80246b:	8b 45 08             	mov    0x8(%ebp),%eax
  80246e:	a3 00 90 80 00       	mov    %eax,0x809000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802473:	53                   	push   %ebx
  802474:	ff 75 0c             	pushl  0xc(%ebp)
  802477:	68 04 90 80 00       	push   $0x809004
  80247c:	e8 b4 e9 ff ff       	call   800e35 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802481:	89 1d 14 90 80 00    	mov    %ebx,0x809014
	return nsipc(NSREQ_BIND);
  802487:	b8 02 00 00 00       	mov    $0x2,%eax
  80248c:	e8 32 ff ff ff       	call   8023c3 <nsipc>
}
  802491:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802494:	c9                   	leave  
  802495:	c3                   	ret    

00802496 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802496:	55                   	push   %ebp
  802497:	89 e5                	mov    %esp,%ebp
  802499:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80249c:	8b 45 08             	mov    0x8(%ebp),%eax
  80249f:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.shutdown.req_how = how;
  8024a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024a7:	a3 04 90 80 00       	mov    %eax,0x809004
	return nsipc(NSREQ_SHUTDOWN);
  8024ac:	b8 03 00 00 00       	mov    $0x3,%eax
  8024b1:	e8 0d ff ff ff       	call   8023c3 <nsipc>
}
  8024b6:	c9                   	leave  
  8024b7:	c3                   	ret    

008024b8 <nsipc_close>:

int
nsipc_close(int s)
{
  8024b8:	55                   	push   %ebp
  8024b9:	89 e5                	mov    %esp,%ebp
  8024bb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8024be:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c1:	a3 00 90 80 00       	mov    %eax,0x809000
	return nsipc(NSREQ_CLOSE);
  8024c6:	b8 04 00 00 00       	mov    $0x4,%eax
  8024cb:	e8 f3 fe ff ff       	call   8023c3 <nsipc>
}
  8024d0:	c9                   	leave  
  8024d1:	c3                   	ret    

008024d2 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8024d2:	55                   	push   %ebp
  8024d3:	89 e5                	mov    %esp,%ebp
  8024d5:	53                   	push   %ebx
  8024d6:	83 ec 08             	sub    $0x8,%esp
  8024d9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8024dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024df:	a3 00 90 80 00       	mov    %eax,0x809000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8024e4:	53                   	push   %ebx
  8024e5:	ff 75 0c             	pushl  0xc(%ebp)
  8024e8:	68 04 90 80 00       	push   $0x809004
  8024ed:	e8 43 e9 ff ff       	call   800e35 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8024f2:	89 1d 14 90 80 00    	mov    %ebx,0x809014
	return nsipc(NSREQ_CONNECT);
  8024f8:	b8 05 00 00 00       	mov    $0x5,%eax
  8024fd:	e8 c1 fe ff ff       	call   8023c3 <nsipc>
}
  802502:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802505:	c9                   	leave  
  802506:	c3                   	ret    

00802507 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802507:	55                   	push   %ebp
  802508:	89 e5                	mov    %esp,%ebp
  80250a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80250d:	8b 45 08             	mov    0x8(%ebp),%eax
  802510:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.listen.req_backlog = backlog;
  802515:	8b 45 0c             	mov    0xc(%ebp),%eax
  802518:	a3 04 90 80 00       	mov    %eax,0x809004
	return nsipc(NSREQ_LISTEN);
  80251d:	b8 06 00 00 00       	mov    $0x6,%eax
  802522:	e8 9c fe ff ff       	call   8023c3 <nsipc>
}
  802527:	c9                   	leave  
  802528:	c3                   	ret    

00802529 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802529:	55                   	push   %ebp
  80252a:	89 e5                	mov    %esp,%ebp
  80252c:	56                   	push   %esi
  80252d:	53                   	push   %ebx
  80252e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802531:	8b 45 08             	mov    0x8(%ebp),%eax
  802534:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.recv.req_len = len;
  802539:	89 35 04 90 80 00    	mov    %esi,0x809004
	nsipcbuf.recv.req_flags = flags;
  80253f:	8b 45 14             	mov    0x14(%ebp),%eax
  802542:	a3 08 90 80 00       	mov    %eax,0x809008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802547:	b8 07 00 00 00       	mov    $0x7,%eax
  80254c:	e8 72 fe ff ff       	call   8023c3 <nsipc>
  802551:	89 c3                	mov    %eax,%ebx
  802553:	85 c0                	test   %eax,%eax
  802555:	78 1f                	js     802576 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802557:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80255c:	7f 21                	jg     80257f <nsipc_recv+0x56>
  80255e:	39 c6                	cmp    %eax,%esi
  802560:	7c 1d                	jl     80257f <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802562:	83 ec 04             	sub    $0x4,%esp
  802565:	50                   	push   %eax
  802566:	68 00 90 80 00       	push   $0x809000
  80256b:	ff 75 0c             	pushl  0xc(%ebp)
  80256e:	e8 c2 e8 ff ff       	call   800e35 <memmove>
  802573:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802576:	89 d8                	mov    %ebx,%eax
  802578:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80257b:	5b                   	pop    %ebx
  80257c:	5e                   	pop    %esi
  80257d:	5d                   	pop    %ebp
  80257e:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80257f:	68 5e 34 80 00       	push   $0x80345e
  802584:	68 47 33 80 00       	push   $0x803347
  802589:	6a 62                	push   $0x62
  80258b:	68 73 34 80 00       	push   $0x803473
  802590:	e8 bd de ff ff       	call   800452 <_panic>

00802595 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802595:	55                   	push   %ebp
  802596:	89 e5                	mov    %esp,%ebp
  802598:	53                   	push   %ebx
  802599:	83 ec 04             	sub    $0x4,%esp
  80259c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80259f:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a2:	a3 00 90 80 00       	mov    %eax,0x809000
	assert(size < 1600);
  8025a7:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8025ad:	7f 2e                	jg     8025dd <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8025af:	83 ec 04             	sub    $0x4,%esp
  8025b2:	53                   	push   %ebx
  8025b3:	ff 75 0c             	pushl  0xc(%ebp)
  8025b6:	68 0c 90 80 00       	push   $0x80900c
  8025bb:	e8 75 e8 ff ff       	call   800e35 <memmove>
	nsipcbuf.send.req_size = size;
  8025c0:	89 1d 04 90 80 00    	mov    %ebx,0x809004
	nsipcbuf.send.req_flags = flags;
  8025c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8025c9:	a3 08 90 80 00       	mov    %eax,0x809008
	return nsipc(NSREQ_SEND);
  8025ce:	b8 08 00 00 00       	mov    $0x8,%eax
  8025d3:	e8 eb fd ff ff       	call   8023c3 <nsipc>
}
  8025d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025db:	c9                   	leave  
  8025dc:	c3                   	ret    
	assert(size < 1600);
  8025dd:	68 7f 34 80 00       	push   $0x80347f
  8025e2:	68 47 33 80 00       	push   $0x803347
  8025e7:	6a 6d                	push   $0x6d
  8025e9:	68 73 34 80 00       	push   $0x803473
  8025ee:	e8 5f de ff ff       	call   800452 <_panic>

008025f3 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8025f3:	55                   	push   %ebp
  8025f4:	89 e5                	mov    %esp,%ebp
  8025f6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8025f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fc:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.socket.req_type = type;
  802601:	8b 45 0c             	mov    0xc(%ebp),%eax
  802604:	a3 04 90 80 00       	mov    %eax,0x809004
	nsipcbuf.socket.req_protocol = protocol;
  802609:	8b 45 10             	mov    0x10(%ebp),%eax
  80260c:	a3 08 90 80 00       	mov    %eax,0x809008
	return nsipc(NSREQ_SOCKET);
  802611:	b8 09 00 00 00       	mov    $0x9,%eax
  802616:	e8 a8 fd ff ff       	call   8023c3 <nsipc>
}
  80261b:	c9                   	leave  
  80261c:	c3                   	ret    

0080261d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80261d:	55                   	push   %ebp
  80261e:	89 e5                	mov    %esp,%ebp
  802620:	56                   	push   %esi
  802621:	53                   	push   %ebx
  802622:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802625:	83 ec 0c             	sub    $0xc,%esp
  802628:	ff 75 08             	pushl  0x8(%ebp)
  80262b:	e8 4e ed ff ff       	call   80137e <fd2data>
  802630:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802632:	83 c4 08             	add    $0x8,%esp
  802635:	68 8b 34 80 00       	push   $0x80348b
  80263a:	53                   	push   %ebx
  80263b:	e8 67 e6 ff ff       	call   800ca7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802640:	8b 46 04             	mov    0x4(%esi),%eax
  802643:	2b 06                	sub    (%esi),%eax
  802645:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80264b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802652:	00 00 00 
	stat->st_dev = &devpipe;
  802655:	c7 83 88 00 00 00 c8 	movl   $0x8057c8,0x88(%ebx)
  80265c:	57 80 00 
	return 0;
}
  80265f:	b8 00 00 00 00       	mov    $0x0,%eax
  802664:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802667:	5b                   	pop    %ebx
  802668:	5e                   	pop    %esi
  802669:	5d                   	pop    %ebp
  80266a:	c3                   	ret    

0080266b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80266b:	55                   	push   %ebp
  80266c:	89 e5                	mov    %esp,%ebp
  80266e:	53                   	push   %ebx
  80266f:	83 ec 0c             	sub    $0xc,%esp
  802672:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802675:	53                   	push   %ebx
  802676:	6a 00                	push   $0x0
  802678:	e8 a1 ea ff ff       	call   80111e <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80267d:	89 1c 24             	mov    %ebx,(%esp)
  802680:	e8 f9 ec ff ff       	call   80137e <fd2data>
  802685:	83 c4 08             	add    $0x8,%esp
  802688:	50                   	push   %eax
  802689:	6a 00                	push   $0x0
  80268b:	e8 8e ea ff ff       	call   80111e <sys_page_unmap>
}
  802690:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802693:	c9                   	leave  
  802694:	c3                   	ret    

00802695 <_pipeisclosed>:
{
  802695:	55                   	push   %ebp
  802696:	89 e5                	mov    %esp,%ebp
  802698:	57                   	push   %edi
  802699:	56                   	push   %esi
  80269a:	53                   	push   %ebx
  80269b:	83 ec 1c             	sub    $0x1c,%esp
  80269e:	89 c7                	mov    %eax,%edi
  8026a0:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8026a2:	a1 90 77 80 00       	mov    0x807790,%eax
  8026a7:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8026aa:	83 ec 0c             	sub    $0xc,%esp
  8026ad:	57                   	push   %edi
  8026ae:	e8 03 04 00 00       	call   802ab6 <pageref>
  8026b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8026b6:	89 34 24             	mov    %esi,(%esp)
  8026b9:	e8 f8 03 00 00       	call   802ab6 <pageref>
		nn = thisenv->env_runs;
  8026be:	8b 15 90 77 80 00    	mov    0x807790,%edx
  8026c4:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8026c7:	83 c4 10             	add    $0x10,%esp
  8026ca:	39 cb                	cmp    %ecx,%ebx
  8026cc:	74 1b                	je     8026e9 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8026ce:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8026d1:	75 cf                	jne    8026a2 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8026d3:	8b 42 58             	mov    0x58(%edx),%eax
  8026d6:	6a 01                	push   $0x1
  8026d8:	50                   	push   %eax
  8026d9:	53                   	push   %ebx
  8026da:	68 92 34 80 00       	push   $0x803492
  8026df:	e8 64 de ff ff       	call   800548 <cprintf>
  8026e4:	83 c4 10             	add    $0x10,%esp
  8026e7:	eb b9                	jmp    8026a2 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8026e9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8026ec:	0f 94 c0             	sete   %al
  8026ef:	0f b6 c0             	movzbl %al,%eax
}
  8026f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026f5:	5b                   	pop    %ebx
  8026f6:	5e                   	pop    %esi
  8026f7:	5f                   	pop    %edi
  8026f8:	5d                   	pop    %ebp
  8026f9:	c3                   	ret    

008026fa <devpipe_write>:
{
  8026fa:	55                   	push   %ebp
  8026fb:	89 e5                	mov    %esp,%ebp
  8026fd:	57                   	push   %edi
  8026fe:	56                   	push   %esi
  8026ff:	53                   	push   %ebx
  802700:	83 ec 28             	sub    $0x28,%esp
  802703:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802706:	56                   	push   %esi
  802707:	e8 72 ec ff ff       	call   80137e <fd2data>
  80270c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80270e:	83 c4 10             	add    $0x10,%esp
  802711:	bf 00 00 00 00       	mov    $0x0,%edi
  802716:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802719:	74 4f                	je     80276a <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80271b:	8b 43 04             	mov    0x4(%ebx),%eax
  80271e:	8b 0b                	mov    (%ebx),%ecx
  802720:	8d 51 20             	lea    0x20(%ecx),%edx
  802723:	39 d0                	cmp    %edx,%eax
  802725:	72 14                	jb     80273b <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802727:	89 da                	mov    %ebx,%edx
  802729:	89 f0                	mov    %esi,%eax
  80272b:	e8 65 ff ff ff       	call   802695 <_pipeisclosed>
  802730:	85 c0                	test   %eax,%eax
  802732:	75 3b                	jne    80276f <devpipe_write+0x75>
			sys_yield();
  802734:	e8 41 e9 ff ff       	call   80107a <sys_yield>
  802739:	eb e0                	jmp    80271b <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80273b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80273e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802742:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802745:	89 c2                	mov    %eax,%edx
  802747:	c1 fa 1f             	sar    $0x1f,%edx
  80274a:	89 d1                	mov    %edx,%ecx
  80274c:	c1 e9 1b             	shr    $0x1b,%ecx
  80274f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802752:	83 e2 1f             	and    $0x1f,%edx
  802755:	29 ca                	sub    %ecx,%edx
  802757:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80275b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80275f:	83 c0 01             	add    $0x1,%eax
  802762:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802765:	83 c7 01             	add    $0x1,%edi
  802768:	eb ac                	jmp    802716 <devpipe_write+0x1c>
	return i;
  80276a:	8b 45 10             	mov    0x10(%ebp),%eax
  80276d:	eb 05                	jmp    802774 <devpipe_write+0x7a>
				return 0;
  80276f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802774:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802777:	5b                   	pop    %ebx
  802778:	5e                   	pop    %esi
  802779:	5f                   	pop    %edi
  80277a:	5d                   	pop    %ebp
  80277b:	c3                   	ret    

0080277c <devpipe_read>:
{
  80277c:	55                   	push   %ebp
  80277d:	89 e5                	mov    %esp,%ebp
  80277f:	57                   	push   %edi
  802780:	56                   	push   %esi
  802781:	53                   	push   %ebx
  802782:	83 ec 18             	sub    $0x18,%esp
  802785:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802788:	57                   	push   %edi
  802789:	e8 f0 eb ff ff       	call   80137e <fd2data>
  80278e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802790:	83 c4 10             	add    $0x10,%esp
  802793:	be 00 00 00 00       	mov    $0x0,%esi
  802798:	3b 75 10             	cmp    0x10(%ebp),%esi
  80279b:	75 14                	jne    8027b1 <devpipe_read+0x35>
	return i;
  80279d:	8b 45 10             	mov    0x10(%ebp),%eax
  8027a0:	eb 02                	jmp    8027a4 <devpipe_read+0x28>
				return i;
  8027a2:	89 f0                	mov    %esi,%eax
}
  8027a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027a7:	5b                   	pop    %ebx
  8027a8:	5e                   	pop    %esi
  8027a9:	5f                   	pop    %edi
  8027aa:	5d                   	pop    %ebp
  8027ab:	c3                   	ret    
			sys_yield();
  8027ac:	e8 c9 e8 ff ff       	call   80107a <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8027b1:	8b 03                	mov    (%ebx),%eax
  8027b3:	3b 43 04             	cmp    0x4(%ebx),%eax
  8027b6:	75 18                	jne    8027d0 <devpipe_read+0x54>
			if (i > 0)
  8027b8:	85 f6                	test   %esi,%esi
  8027ba:	75 e6                	jne    8027a2 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8027bc:	89 da                	mov    %ebx,%edx
  8027be:	89 f8                	mov    %edi,%eax
  8027c0:	e8 d0 fe ff ff       	call   802695 <_pipeisclosed>
  8027c5:	85 c0                	test   %eax,%eax
  8027c7:	74 e3                	je     8027ac <devpipe_read+0x30>
				return 0;
  8027c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ce:	eb d4                	jmp    8027a4 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8027d0:	99                   	cltd   
  8027d1:	c1 ea 1b             	shr    $0x1b,%edx
  8027d4:	01 d0                	add    %edx,%eax
  8027d6:	83 e0 1f             	and    $0x1f,%eax
  8027d9:	29 d0                	sub    %edx,%eax
  8027db:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8027e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027e3:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8027e6:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8027e9:	83 c6 01             	add    $0x1,%esi
  8027ec:	eb aa                	jmp    802798 <devpipe_read+0x1c>

008027ee <pipe>:
{
  8027ee:	55                   	push   %ebp
  8027ef:	89 e5                	mov    %esp,%ebp
  8027f1:	56                   	push   %esi
  8027f2:	53                   	push   %ebx
  8027f3:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8027f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027f9:	50                   	push   %eax
  8027fa:	e8 96 eb ff ff       	call   801395 <fd_alloc>
  8027ff:	89 c3                	mov    %eax,%ebx
  802801:	83 c4 10             	add    $0x10,%esp
  802804:	85 c0                	test   %eax,%eax
  802806:	0f 88 23 01 00 00    	js     80292f <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80280c:	83 ec 04             	sub    $0x4,%esp
  80280f:	68 07 04 00 00       	push   $0x407
  802814:	ff 75 f4             	pushl  -0xc(%ebp)
  802817:	6a 00                	push   $0x0
  802819:	e8 7b e8 ff ff       	call   801099 <sys_page_alloc>
  80281e:	89 c3                	mov    %eax,%ebx
  802820:	83 c4 10             	add    $0x10,%esp
  802823:	85 c0                	test   %eax,%eax
  802825:	0f 88 04 01 00 00    	js     80292f <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80282b:	83 ec 0c             	sub    $0xc,%esp
  80282e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802831:	50                   	push   %eax
  802832:	e8 5e eb ff ff       	call   801395 <fd_alloc>
  802837:	89 c3                	mov    %eax,%ebx
  802839:	83 c4 10             	add    $0x10,%esp
  80283c:	85 c0                	test   %eax,%eax
  80283e:	0f 88 db 00 00 00    	js     80291f <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802844:	83 ec 04             	sub    $0x4,%esp
  802847:	68 07 04 00 00       	push   $0x407
  80284c:	ff 75 f0             	pushl  -0x10(%ebp)
  80284f:	6a 00                	push   $0x0
  802851:	e8 43 e8 ff ff       	call   801099 <sys_page_alloc>
  802856:	89 c3                	mov    %eax,%ebx
  802858:	83 c4 10             	add    $0x10,%esp
  80285b:	85 c0                	test   %eax,%eax
  80285d:	0f 88 bc 00 00 00    	js     80291f <pipe+0x131>
	va = fd2data(fd0);
  802863:	83 ec 0c             	sub    $0xc,%esp
  802866:	ff 75 f4             	pushl  -0xc(%ebp)
  802869:	e8 10 eb ff ff       	call   80137e <fd2data>
  80286e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802870:	83 c4 0c             	add    $0xc,%esp
  802873:	68 07 04 00 00       	push   $0x407
  802878:	50                   	push   %eax
  802879:	6a 00                	push   $0x0
  80287b:	e8 19 e8 ff ff       	call   801099 <sys_page_alloc>
  802880:	89 c3                	mov    %eax,%ebx
  802882:	83 c4 10             	add    $0x10,%esp
  802885:	85 c0                	test   %eax,%eax
  802887:	0f 88 82 00 00 00    	js     80290f <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80288d:	83 ec 0c             	sub    $0xc,%esp
  802890:	ff 75 f0             	pushl  -0x10(%ebp)
  802893:	e8 e6 ea ff ff       	call   80137e <fd2data>
  802898:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80289f:	50                   	push   %eax
  8028a0:	6a 00                	push   $0x0
  8028a2:	56                   	push   %esi
  8028a3:	6a 00                	push   $0x0
  8028a5:	e8 32 e8 ff ff       	call   8010dc <sys_page_map>
  8028aa:	89 c3                	mov    %eax,%ebx
  8028ac:	83 c4 20             	add    $0x20,%esp
  8028af:	85 c0                	test   %eax,%eax
  8028b1:	78 4e                	js     802901 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8028b3:	a1 c8 57 80 00       	mov    0x8057c8,%eax
  8028b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028bb:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8028bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c0:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8028c7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028ca:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8028cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cf:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8028d6:	83 ec 0c             	sub    $0xc,%esp
  8028d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8028dc:	e8 8d ea ff ff       	call   80136e <fd2num>
  8028e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8028e4:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8028e6:	83 c4 04             	add    $0x4,%esp
  8028e9:	ff 75 f0             	pushl  -0x10(%ebp)
  8028ec:	e8 7d ea ff ff       	call   80136e <fd2num>
  8028f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8028f4:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8028f7:	83 c4 10             	add    $0x10,%esp
  8028fa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8028ff:	eb 2e                	jmp    80292f <pipe+0x141>
	sys_page_unmap(0, va);
  802901:	83 ec 08             	sub    $0x8,%esp
  802904:	56                   	push   %esi
  802905:	6a 00                	push   $0x0
  802907:	e8 12 e8 ff ff       	call   80111e <sys_page_unmap>
  80290c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80290f:	83 ec 08             	sub    $0x8,%esp
  802912:	ff 75 f0             	pushl  -0x10(%ebp)
  802915:	6a 00                	push   $0x0
  802917:	e8 02 e8 ff ff       	call   80111e <sys_page_unmap>
  80291c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80291f:	83 ec 08             	sub    $0x8,%esp
  802922:	ff 75 f4             	pushl  -0xc(%ebp)
  802925:	6a 00                	push   $0x0
  802927:	e8 f2 e7 ff ff       	call   80111e <sys_page_unmap>
  80292c:	83 c4 10             	add    $0x10,%esp
}
  80292f:	89 d8                	mov    %ebx,%eax
  802931:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802934:	5b                   	pop    %ebx
  802935:	5e                   	pop    %esi
  802936:	5d                   	pop    %ebp
  802937:	c3                   	ret    

00802938 <pipeisclosed>:
{
  802938:	55                   	push   %ebp
  802939:	89 e5                	mov    %esp,%ebp
  80293b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80293e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802941:	50                   	push   %eax
  802942:	ff 75 08             	pushl  0x8(%ebp)
  802945:	e8 9d ea ff ff       	call   8013e7 <fd_lookup>
  80294a:	83 c4 10             	add    $0x10,%esp
  80294d:	85 c0                	test   %eax,%eax
  80294f:	78 18                	js     802969 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802951:	83 ec 0c             	sub    $0xc,%esp
  802954:	ff 75 f4             	pushl  -0xc(%ebp)
  802957:	e8 22 ea ff ff       	call   80137e <fd2data>
	return _pipeisclosed(fd, p);
  80295c:	89 c2                	mov    %eax,%edx
  80295e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802961:	e8 2f fd ff ff       	call   802695 <_pipeisclosed>
  802966:	83 c4 10             	add    $0x10,%esp
}
  802969:	c9                   	leave  
  80296a:	c3                   	ret    

0080296b <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80296b:	55                   	push   %ebp
  80296c:	89 e5                	mov    %esp,%ebp
  80296e:	56                   	push   %esi
  80296f:	53                   	push   %ebx
  802970:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802973:	85 f6                	test   %esi,%esi
  802975:	74 13                	je     80298a <wait+0x1f>
	e = &envs[ENVX(envid)];
  802977:	89 f3                	mov    %esi,%ebx
  802979:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80297f:	c1 e3 07             	shl    $0x7,%ebx
  802982:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802988:	eb 1b                	jmp    8029a5 <wait+0x3a>
	assert(envid != 0);
  80298a:	68 aa 34 80 00       	push   $0x8034aa
  80298f:	68 47 33 80 00       	push   $0x803347
  802994:	6a 09                	push   $0x9
  802996:	68 b5 34 80 00       	push   $0x8034b5
  80299b:	e8 b2 da ff ff       	call   800452 <_panic>
		sys_yield();
  8029a0:	e8 d5 e6 ff ff       	call   80107a <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8029a5:	8b 43 48             	mov    0x48(%ebx),%eax
  8029a8:	39 f0                	cmp    %esi,%eax
  8029aa:	75 07                	jne    8029b3 <wait+0x48>
  8029ac:	8b 43 54             	mov    0x54(%ebx),%eax
  8029af:	85 c0                	test   %eax,%eax
  8029b1:	75 ed                	jne    8029a0 <wait+0x35>
}
  8029b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8029b6:	5b                   	pop    %ebx
  8029b7:	5e                   	pop    %esi
  8029b8:	5d                   	pop    %ebp
  8029b9:	c3                   	ret    

008029ba <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8029ba:	55                   	push   %ebp
  8029bb:	89 e5                	mov    %esp,%ebp
  8029bd:	56                   	push   %esi
  8029be:	53                   	push   %ebx
  8029bf:	8b 75 08             	mov    0x8(%ebp),%esi
  8029c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8029c8:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8029ca:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8029cf:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8029d2:	83 ec 0c             	sub    $0xc,%esp
  8029d5:	50                   	push   %eax
  8029d6:	e8 6e e8 ff ff       	call   801249 <sys_ipc_recv>
	if(ret < 0){
  8029db:	83 c4 10             	add    $0x10,%esp
  8029de:	85 c0                	test   %eax,%eax
  8029e0:	78 2b                	js     802a0d <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8029e2:	85 f6                	test   %esi,%esi
  8029e4:	74 0a                	je     8029f0 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8029e6:	a1 90 77 80 00       	mov    0x807790,%eax
  8029eb:	8b 40 74             	mov    0x74(%eax),%eax
  8029ee:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8029f0:	85 db                	test   %ebx,%ebx
  8029f2:	74 0a                	je     8029fe <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8029f4:	a1 90 77 80 00       	mov    0x807790,%eax
  8029f9:	8b 40 78             	mov    0x78(%eax),%eax
  8029fc:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8029fe:	a1 90 77 80 00       	mov    0x807790,%eax
  802a03:	8b 40 70             	mov    0x70(%eax),%eax
}
  802a06:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a09:	5b                   	pop    %ebx
  802a0a:	5e                   	pop    %esi
  802a0b:	5d                   	pop    %ebp
  802a0c:	c3                   	ret    
		if(from_env_store)
  802a0d:	85 f6                	test   %esi,%esi
  802a0f:	74 06                	je     802a17 <ipc_recv+0x5d>
			*from_env_store = 0;
  802a11:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802a17:	85 db                	test   %ebx,%ebx
  802a19:	74 eb                	je     802a06 <ipc_recv+0x4c>
			*perm_store = 0;
  802a1b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802a21:	eb e3                	jmp    802a06 <ipc_recv+0x4c>

00802a23 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802a23:	55                   	push   %ebp
  802a24:	89 e5                	mov    %esp,%ebp
  802a26:	57                   	push   %edi
  802a27:	56                   	push   %esi
  802a28:	53                   	push   %ebx
  802a29:	83 ec 0c             	sub    $0xc,%esp
  802a2c:	8b 7d 08             	mov    0x8(%ebp),%edi
  802a2f:	8b 75 0c             	mov    0xc(%ebp),%esi
  802a32:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802a35:	85 db                	test   %ebx,%ebx
  802a37:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802a3c:	0f 44 d8             	cmove  %eax,%ebx
  802a3f:	eb 05                	jmp    802a46 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802a41:	e8 34 e6 ff ff       	call   80107a <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802a46:	ff 75 14             	pushl  0x14(%ebp)
  802a49:	53                   	push   %ebx
  802a4a:	56                   	push   %esi
  802a4b:	57                   	push   %edi
  802a4c:	e8 d5 e7 ff ff       	call   801226 <sys_ipc_try_send>
  802a51:	83 c4 10             	add    $0x10,%esp
  802a54:	85 c0                	test   %eax,%eax
  802a56:	74 1b                	je     802a73 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802a58:	79 e7                	jns    802a41 <ipc_send+0x1e>
  802a5a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802a5d:	74 e2                	je     802a41 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802a5f:	83 ec 04             	sub    $0x4,%esp
  802a62:	68 c0 34 80 00       	push   $0x8034c0
  802a67:	6a 48                	push   $0x48
  802a69:	68 d5 34 80 00       	push   $0x8034d5
  802a6e:	e8 df d9 ff ff       	call   800452 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802a73:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a76:	5b                   	pop    %ebx
  802a77:	5e                   	pop    %esi
  802a78:	5f                   	pop    %edi
  802a79:	5d                   	pop    %ebp
  802a7a:	c3                   	ret    

00802a7b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802a7b:	55                   	push   %ebp
  802a7c:	89 e5                	mov    %esp,%ebp
  802a7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802a81:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802a86:	89 c2                	mov    %eax,%edx
  802a88:	c1 e2 07             	shl    $0x7,%edx
  802a8b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802a91:	8b 52 50             	mov    0x50(%edx),%edx
  802a94:	39 ca                	cmp    %ecx,%edx
  802a96:	74 11                	je     802aa9 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802a98:	83 c0 01             	add    $0x1,%eax
  802a9b:	3d 00 04 00 00       	cmp    $0x400,%eax
  802aa0:	75 e4                	jne    802a86 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802aa2:	b8 00 00 00 00       	mov    $0x0,%eax
  802aa7:	eb 0b                	jmp    802ab4 <ipc_find_env+0x39>
			return envs[i].env_id;
  802aa9:	c1 e0 07             	shl    $0x7,%eax
  802aac:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802ab1:	8b 40 48             	mov    0x48(%eax),%eax
}
  802ab4:	5d                   	pop    %ebp
  802ab5:	c3                   	ret    

00802ab6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802ab6:	55                   	push   %ebp
  802ab7:	89 e5                	mov    %esp,%ebp
  802ab9:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802abc:	89 d0                	mov    %edx,%eax
  802abe:	c1 e8 16             	shr    $0x16,%eax
  802ac1:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802ac8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802acd:	f6 c1 01             	test   $0x1,%cl
  802ad0:	74 1d                	je     802aef <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802ad2:	c1 ea 0c             	shr    $0xc,%edx
  802ad5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802adc:	f6 c2 01             	test   $0x1,%dl
  802adf:	74 0e                	je     802aef <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802ae1:	c1 ea 0c             	shr    $0xc,%edx
  802ae4:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802aeb:	ef 
  802aec:	0f b7 c0             	movzwl %ax,%eax
}
  802aef:	5d                   	pop    %ebp
  802af0:	c3                   	ret    
  802af1:	66 90                	xchg   %ax,%ax
  802af3:	66 90                	xchg   %ax,%ax
  802af5:	66 90                	xchg   %ax,%ax
  802af7:	66 90                	xchg   %ax,%ax
  802af9:	66 90                	xchg   %ax,%ax
  802afb:	66 90                	xchg   %ax,%ax
  802afd:	66 90                	xchg   %ax,%ax
  802aff:	90                   	nop

00802b00 <__udivdi3>:
  802b00:	55                   	push   %ebp
  802b01:	57                   	push   %edi
  802b02:	56                   	push   %esi
  802b03:	53                   	push   %ebx
  802b04:	83 ec 1c             	sub    $0x1c,%esp
  802b07:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802b0b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802b0f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802b13:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802b17:	85 d2                	test   %edx,%edx
  802b19:	75 4d                	jne    802b68 <__udivdi3+0x68>
  802b1b:	39 f3                	cmp    %esi,%ebx
  802b1d:	76 19                	jbe    802b38 <__udivdi3+0x38>
  802b1f:	31 ff                	xor    %edi,%edi
  802b21:	89 e8                	mov    %ebp,%eax
  802b23:	89 f2                	mov    %esi,%edx
  802b25:	f7 f3                	div    %ebx
  802b27:	89 fa                	mov    %edi,%edx
  802b29:	83 c4 1c             	add    $0x1c,%esp
  802b2c:	5b                   	pop    %ebx
  802b2d:	5e                   	pop    %esi
  802b2e:	5f                   	pop    %edi
  802b2f:	5d                   	pop    %ebp
  802b30:	c3                   	ret    
  802b31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b38:	89 d9                	mov    %ebx,%ecx
  802b3a:	85 db                	test   %ebx,%ebx
  802b3c:	75 0b                	jne    802b49 <__udivdi3+0x49>
  802b3e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b43:	31 d2                	xor    %edx,%edx
  802b45:	f7 f3                	div    %ebx
  802b47:	89 c1                	mov    %eax,%ecx
  802b49:	31 d2                	xor    %edx,%edx
  802b4b:	89 f0                	mov    %esi,%eax
  802b4d:	f7 f1                	div    %ecx
  802b4f:	89 c6                	mov    %eax,%esi
  802b51:	89 e8                	mov    %ebp,%eax
  802b53:	89 f7                	mov    %esi,%edi
  802b55:	f7 f1                	div    %ecx
  802b57:	89 fa                	mov    %edi,%edx
  802b59:	83 c4 1c             	add    $0x1c,%esp
  802b5c:	5b                   	pop    %ebx
  802b5d:	5e                   	pop    %esi
  802b5e:	5f                   	pop    %edi
  802b5f:	5d                   	pop    %ebp
  802b60:	c3                   	ret    
  802b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b68:	39 f2                	cmp    %esi,%edx
  802b6a:	77 1c                	ja     802b88 <__udivdi3+0x88>
  802b6c:	0f bd fa             	bsr    %edx,%edi
  802b6f:	83 f7 1f             	xor    $0x1f,%edi
  802b72:	75 2c                	jne    802ba0 <__udivdi3+0xa0>
  802b74:	39 f2                	cmp    %esi,%edx
  802b76:	72 06                	jb     802b7e <__udivdi3+0x7e>
  802b78:	31 c0                	xor    %eax,%eax
  802b7a:	39 eb                	cmp    %ebp,%ebx
  802b7c:	77 a9                	ja     802b27 <__udivdi3+0x27>
  802b7e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b83:	eb a2                	jmp    802b27 <__udivdi3+0x27>
  802b85:	8d 76 00             	lea    0x0(%esi),%esi
  802b88:	31 ff                	xor    %edi,%edi
  802b8a:	31 c0                	xor    %eax,%eax
  802b8c:	89 fa                	mov    %edi,%edx
  802b8e:	83 c4 1c             	add    $0x1c,%esp
  802b91:	5b                   	pop    %ebx
  802b92:	5e                   	pop    %esi
  802b93:	5f                   	pop    %edi
  802b94:	5d                   	pop    %ebp
  802b95:	c3                   	ret    
  802b96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b9d:	8d 76 00             	lea    0x0(%esi),%esi
  802ba0:	89 f9                	mov    %edi,%ecx
  802ba2:	b8 20 00 00 00       	mov    $0x20,%eax
  802ba7:	29 f8                	sub    %edi,%eax
  802ba9:	d3 e2                	shl    %cl,%edx
  802bab:	89 54 24 08          	mov    %edx,0x8(%esp)
  802baf:	89 c1                	mov    %eax,%ecx
  802bb1:	89 da                	mov    %ebx,%edx
  802bb3:	d3 ea                	shr    %cl,%edx
  802bb5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802bb9:	09 d1                	or     %edx,%ecx
  802bbb:	89 f2                	mov    %esi,%edx
  802bbd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802bc1:	89 f9                	mov    %edi,%ecx
  802bc3:	d3 e3                	shl    %cl,%ebx
  802bc5:	89 c1                	mov    %eax,%ecx
  802bc7:	d3 ea                	shr    %cl,%edx
  802bc9:	89 f9                	mov    %edi,%ecx
  802bcb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802bcf:	89 eb                	mov    %ebp,%ebx
  802bd1:	d3 e6                	shl    %cl,%esi
  802bd3:	89 c1                	mov    %eax,%ecx
  802bd5:	d3 eb                	shr    %cl,%ebx
  802bd7:	09 de                	or     %ebx,%esi
  802bd9:	89 f0                	mov    %esi,%eax
  802bdb:	f7 74 24 08          	divl   0x8(%esp)
  802bdf:	89 d6                	mov    %edx,%esi
  802be1:	89 c3                	mov    %eax,%ebx
  802be3:	f7 64 24 0c          	mull   0xc(%esp)
  802be7:	39 d6                	cmp    %edx,%esi
  802be9:	72 15                	jb     802c00 <__udivdi3+0x100>
  802beb:	89 f9                	mov    %edi,%ecx
  802bed:	d3 e5                	shl    %cl,%ebp
  802bef:	39 c5                	cmp    %eax,%ebp
  802bf1:	73 04                	jae    802bf7 <__udivdi3+0xf7>
  802bf3:	39 d6                	cmp    %edx,%esi
  802bf5:	74 09                	je     802c00 <__udivdi3+0x100>
  802bf7:	89 d8                	mov    %ebx,%eax
  802bf9:	31 ff                	xor    %edi,%edi
  802bfb:	e9 27 ff ff ff       	jmp    802b27 <__udivdi3+0x27>
  802c00:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802c03:	31 ff                	xor    %edi,%edi
  802c05:	e9 1d ff ff ff       	jmp    802b27 <__udivdi3+0x27>
  802c0a:	66 90                	xchg   %ax,%ax
  802c0c:	66 90                	xchg   %ax,%ax
  802c0e:	66 90                	xchg   %ax,%ax

00802c10 <__umoddi3>:
  802c10:	55                   	push   %ebp
  802c11:	57                   	push   %edi
  802c12:	56                   	push   %esi
  802c13:	53                   	push   %ebx
  802c14:	83 ec 1c             	sub    $0x1c,%esp
  802c17:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802c1b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802c1f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802c23:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802c27:	89 da                	mov    %ebx,%edx
  802c29:	85 c0                	test   %eax,%eax
  802c2b:	75 43                	jne    802c70 <__umoddi3+0x60>
  802c2d:	39 df                	cmp    %ebx,%edi
  802c2f:	76 17                	jbe    802c48 <__umoddi3+0x38>
  802c31:	89 f0                	mov    %esi,%eax
  802c33:	f7 f7                	div    %edi
  802c35:	89 d0                	mov    %edx,%eax
  802c37:	31 d2                	xor    %edx,%edx
  802c39:	83 c4 1c             	add    $0x1c,%esp
  802c3c:	5b                   	pop    %ebx
  802c3d:	5e                   	pop    %esi
  802c3e:	5f                   	pop    %edi
  802c3f:	5d                   	pop    %ebp
  802c40:	c3                   	ret    
  802c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c48:	89 fd                	mov    %edi,%ebp
  802c4a:	85 ff                	test   %edi,%edi
  802c4c:	75 0b                	jne    802c59 <__umoddi3+0x49>
  802c4e:	b8 01 00 00 00       	mov    $0x1,%eax
  802c53:	31 d2                	xor    %edx,%edx
  802c55:	f7 f7                	div    %edi
  802c57:	89 c5                	mov    %eax,%ebp
  802c59:	89 d8                	mov    %ebx,%eax
  802c5b:	31 d2                	xor    %edx,%edx
  802c5d:	f7 f5                	div    %ebp
  802c5f:	89 f0                	mov    %esi,%eax
  802c61:	f7 f5                	div    %ebp
  802c63:	89 d0                	mov    %edx,%eax
  802c65:	eb d0                	jmp    802c37 <__umoddi3+0x27>
  802c67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c6e:	66 90                	xchg   %ax,%ax
  802c70:	89 f1                	mov    %esi,%ecx
  802c72:	39 d8                	cmp    %ebx,%eax
  802c74:	76 0a                	jbe    802c80 <__umoddi3+0x70>
  802c76:	89 f0                	mov    %esi,%eax
  802c78:	83 c4 1c             	add    $0x1c,%esp
  802c7b:	5b                   	pop    %ebx
  802c7c:	5e                   	pop    %esi
  802c7d:	5f                   	pop    %edi
  802c7e:	5d                   	pop    %ebp
  802c7f:	c3                   	ret    
  802c80:	0f bd e8             	bsr    %eax,%ebp
  802c83:	83 f5 1f             	xor    $0x1f,%ebp
  802c86:	75 20                	jne    802ca8 <__umoddi3+0x98>
  802c88:	39 d8                	cmp    %ebx,%eax
  802c8a:	0f 82 b0 00 00 00    	jb     802d40 <__umoddi3+0x130>
  802c90:	39 f7                	cmp    %esi,%edi
  802c92:	0f 86 a8 00 00 00    	jbe    802d40 <__umoddi3+0x130>
  802c98:	89 c8                	mov    %ecx,%eax
  802c9a:	83 c4 1c             	add    $0x1c,%esp
  802c9d:	5b                   	pop    %ebx
  802c9e:	5e                   	pop    %esi
  802c9f:	5f                   	pop    %edi
  802ca0:	5d                   	pop    %ebp
  802ca1:	c3                   	ret    
  802ca2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802ca8:	89 e9                	mov    %ebp,%ecx
  802caa:	ba 20 00 00 00       	mov    $0x20,%edx
  802caf:	29 ea                	sub    %ebp,%edx
  802cb1:	d3 e0                	shl    %cl,%eax
  802cb3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802cb7:	89 d1                	mov    %edx,%ecx
  802cb9:	89 f8                	mov    %edi,%eax
  802cbb:	d3 e8                	shr    %cl,%eax
  802cbd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802cc1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802cc5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802cc9:	09 c1                	or     %eax,%ecx
  802ccb:	89 d8                	mov    %ebx,%eax
  802ccd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802cd1:	89 e9                	mov    %ebp,%ecx
  802cd3:	d3 e7                	shl    %cl,%edi
  802cd5:	89 d1                	mov    %edx,%ecx
  802cd7:	d3 e8                	shr    %cl,%eax
  802cd9:	89 e9                	mov    %ebp,%ecx
  802cdb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802cdf:	d3 e3                	shl    %cl,%ebx
  802ce1:	89 c7                	mov    %eax,%edi
  802ce3:	89 d1                	mov    %edx,%ecx
  802ce5:	89 f0                	mov    %esi,%eax
  802ce7:	d3 e8                	shr    %cl,%eax
  802ce9:	89 e9                	mov    %ebp,%ecx
  802ceb:	89 fa                	mov    %edi,%edx
  802ced:	d3 e6                	shl    %cl,%esi
  802cef:	09 d8                	or     %ebx,%eax
  802cf1:	f7 74 24 08          	divl   0x8(%esp)
  802cf5:	89 d1                	mov    %edx,%ecx
  802cf7:	89 f3                	mov    %esi,%ebx
  802cf9:	f7 64 24 0c          	mull   0xc(%esp)
  802cfd:	89 c6                	mov    %eax,%esi
  802cff:	89 d7                	mov    %edx,%edi
  802d01:	39 d1                	cmp    %edx,%ecx
  802d03:	72 06                	jb     802d0b <__umoddi3+0xfb>
  802d05:	75 10                	jne    802d17 <__umoddi3+0x107>
  802d07:	39 c3                	cmp    %eax,%ebx
  802d09:	73 0c                	jae    802d17 <__umoddi3+0x107>
  802d0b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802d0f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802d13:	89 d7                	mov    %edx,%edi
  802d15:	89 c6                	mov    %eax,%esi
  802d17:	89 ca                	mov    %ecx,%edx
  802d19:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802d1e:	29 f3                	sub    %esi,%ebx
  802d20:	19 fa                	sbb    %edi,%edx
  802d22:	89 d0                	mov    %edx,%eax
  802d24:	d3 e0                	shl    %cl,%eax
  802d26:	89 e9                	mov    %ebp,%ecx
  802d28:	d3 eb                	shr    %cl,%ebx
  802d2a:	d3 ea                	shr    %cl,%edx
  802d2c:	09 d8                	or     %ebx,%eax
  802d2e:	83 c4 1c             	add    $0x1c,%esp
  802d31:	5b                   	pop    %ebx
  802d32:	5e                   	pop    %esi
  802d33:	5f                   	pop    %edi
  802d34:	5d                   	pop    %ebp
  802d35:	c3                   	ret    
  802d36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802d3d:	8d 76 00             	lea    0x0(%esi),%esi
  802d40:	89 da                	mov    %ebx,%edx
  802d42:	29 fe                	sub    %edi,%esi
  802d44:	19 c2                	sbb    %eax,%edx
  802d46:	89 f1                	mov    %esi,%ecx
  802d48:	89 c8                	mov    %ecx,%eax
  802d4a:	e9 4b ff ff ff       	jmp    802c9a <__umoddi3+0x8a>
