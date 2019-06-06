
obj/user/testshell.debug:     file format elf32-i386


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
  80002c:	e8 55 04 00 00       	call   800486 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <wrong>:
	breakpoint();
}

void
wrong(int rfd, int kfd, int off)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	81 ec 84 00 00 00    	sub    $0x84,%esp
  80003f:	8b 75 08             	mov    0x8(%ebp),%esi
  800042:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800045:	8b 5d 10             	mov    0x10(%ebp),%ebx
	char buf[100];
	int n;

	seek(rfd, off);
  800048:	53                   	push   %ebx
  800049:	56                   	push   %esi
  80004a:	e8 7e 1d 00 00       	call   801dcd <seek>
	seek(kfd, off);
  80004f:	83 c4 08             	add    $0x8,%esp
  800052:	53                   	push   %ebx
  800053:	57                   	push   %edi
  800054:	e8 74 1d 00 00       	call   801dcd <seek>

	cprintf("shell produced incorrect output.\n");
  800059:	c7 04 24 00 34 80 00 	movl   $0x803400,(%esp)
  800060:	e8 24 06 00 00       	call   800689 <cprintf>
	cprintf("expected:\n===\n");
  800065:	c7 04 24 6b 34 80 00 	movl   $0x80346b,(%esp)
  80006c:	e8 18 06 00 00       	call   800689 <cprintf>
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800071:	83 c4 10             	add    $0x10,%esp
  800074:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  800077:	83 ec 04             	sub    $0x4,%esp
  80007a:	6a 63                	push   $0x63
  80007c:	53                   	push   %ebx
  80007d:	57                   	push   %edi
  80007e:	e8 fc 1b 00 00       	call   801c7f <read>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	85 c0                	test   %eax,%eax
  800088:	7e 0f                	jle    800099 <wrong+0x66>
		sys_cputs(buf, n);
  80008a:	83 ec 08             	sub    $0x8,%esp
  80008d:	50                   	push   %eax
  80008e:	53                   	push   %ebx
  80008f:	e8 8a 10 00 00       	call   80111e <sys_cputs>
  800094:	83 c4 10             	add    $0x10,%esp
  800097:	eb de                	jmp    800077 <wrong+0x44>
	cprintf("===\ngot:\n===\n");
  800099:	83 ec 0c             	sub    $0xc,%esp
  80009c:	68 7a 34 80 00       	push   $0x80347a
  8000a1:	e8 e3 05 00 00       	call   800689 <cprintf>
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000a6:	83 c4 10             	add    $0x10,%esp
  8000a9:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  8000ac:	eb 0d                	jmp    8000bb <wrong+0x88>
		sys_cputs(buf, n);
  8000ae:	83 ec 08             	sub    $0x8,%esp
  8000b1:	50                   	push   %eax
  8000b2:	53                   	push   %ebx
  8000b3:	e8 66 10 00 00       	call   80111e <sys_cputs>
  8000b8:	83 c4 10             	add    $0x10,%esp
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000bb:	83 ec 04             	sub    $0x4,%esp
  8000be:	6a 63                	push   $0x63
  8000c0:	53                   	push   %ebx
  8000c1:	56                   	push   %esi
  8000c2:	e8 b8 1b 00 00       	call   801c7f <read>
  8000c7:	83 c4 10             	add    $0x10,%esp
  8000ca:	85 c0                	test   %eax,%eax
  8000cc:	7f e0                	jg     8000ae <wrong+0x7b>
	cprintf("===\n");
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	68 75 34 80 00       	push   $0x803475
  8000d6:	e8 ae 05 00 00       	call   800689 <cprintf>
	exit();
  8000db:	e8 7f 04 00 00       	call   80055f <exit>
}
  8000e0:	83 c4 10             	add    $0x10,%esp
  8000e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000e6:	5b                   	pop    %ebx
  8000e7:	5e                   	pop    %esi
  8000e8:	5f                   	pop    %edi
  8000e9:	5d                   	pop    %ebp
  8000ea:	c3                   	ret    

008000eb <umain>:
{
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	57                   	push   %edi
  8000ef:	56                   	push   %esi
  8000f0:	53                   	push   %ebx
  8000f1:	83 ec 38             	sub    $0x38,%esp
	close(0);
  8000f4:	6a 00                	push   $0x0
  8000f6:	e8 46 1a 00 00       	call   801b41 <close>
	close(1);
  8000fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800102:	e8 3a 1a 00 00       	call   801b41 <close>
	opencons();
  800107:	e8 28 03 00 00       	call   800434 <opencons>
	opencons();
  80010c:	e8 23 03 00 00       	call   800434 <opencons>
	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  800111:	83 c4 08             	add    $0x8,%esp
  800114:	6a 00                	push   $0x0
  800116:	68 88 34 80 00       	push   $0x803488
  80011b:	e8 fd 1f 00 00       	call   80211d <open>
  800120:	89 c3                	mov    %eax,%ebx
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	85 c0                	test   %eax,%eax
  800127:	0f 88 e7 00 00 00    	js     800214 <umain+0x129>
	if ((wfd = pipe(pfds)) < 0)
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800133:	50                   	push   %eax
  800134:	e8 dd 2c 00 00       	call   802e16 <pipe>
  800139:	83 c4 10             	add    $0x10,%esp
  80013c:	85 c0                	test   %eax,%eax
  80013e:	0f 88 e2 00 00 00    	js     800226 <umain+0x13b>
	wfd = pfds[1];
  800144:	8b 75 e0             	mov    -0x20(%ebp),%esi
	cprintf("running sh -x < testshell.sh | cat\n");
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	68 24 34 80 00       	push   $0x803424
  80014f:	e8 35 05 00 00       	call   800689 <cprintf>
	if ((r = fork()) < 0)
  800154:	e8 ab 15 00 00       	call   801704 <fork>
  800159:	83 c4 10             	add    $0x10,%esp
  80015c:	85 c0                	test   %eax,%eax
  80015e:	0f 88 d4 00 00 00    	js     800238 <umain+0x14d>
	if (r == 0) {
  800164:	75 6f                	jne    8001d5 <umain+0xea>
		dup(rfd, 0);
  800166:	83 ec 08             	sub    $0x8,%esp
  800169:	6a 00                	push   $0x0
  80016b:	53                   	push   %ebx
  80016c:	e8 22 1a 00 00       	call   801b93 <dup>
		dup(wfd, 1);
  800171:	83 c4 08             	add    $0x8,%esp
  800174:	6a 01                	push   $0x1
  800176:	56                   	push   %esi
  800177:	e8 17 1a 00 00       	call   801b93 <dup>
		close(rfd);
  80017c:	89 1c 24             	mov    %ebx,(%esp)
  80017f:	e8 bd 19 00 00       	call   801b41 <close>
		close(wfd);
  800184:	89 34 24             	mov    %esi,(%esp)
  800187:	e8 b5 19 00 00       	call   801b41 <close>
		if ((r = spawnl("/sh", "sh", "-x", 0)) < 0)
  80018c:	6a 00                	push   $0x0
  80018e:	68 ce 34 80 00       	push   $0x8034ce
  800193:	68 92 34 80 00       	push   $0x803492
  800198:	68 d1 34 80 00       	push   $0x8034d1
  80019d:	e8 ad 25 00 00       	call   80274f <spawnl>
  8001a2:	89 c7                	mov    %eax,%edi
  8001a4:	83 c4 20             	add    $0x20,%esp
  8001a7:	85 c0                	test   %eax,%eax
  8001a9:	0f 88 9b 00 00 00    	js     80024a <umain+0x15f>
		close(0);
  8001af:	83 ec 0c             	sub    $0xc,%esp
  8001b2:	6a 00                	push   $0x0
  8001b4:	e8 88 19 00 00       	call   801b41 <close>
		close(1);
  8001b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001c0:	e8 7c 19 00 00       	call   801b41 <close>
		wait(r);
  8001c5:	89 3c 24             	mov    %edi,(%esp)
  8001c8:	e8 c6 2d 00 00       	call   802f93 <wait>
		exit();
  8001cd:	e8 8d 03 00 00       	call   80055f <exit>
  8001d2:	83 c4 10             	add    $0x10,%esp
	close(rfd);
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	53                   	push   %ebx
  8001d9:	e8 63 19 00 00       	call   801b41 <close>
	close(wfd);
  8001de:	89 34 24             	mov    %esi,(%esp)
  8001e1:	e8 5b 19 00 00       	call   801b41 <close>
	rfd = pfds[0];
  8001e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001e9:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8001ec:	83 c4 08             	add    $0x8,%esp
  8001ef:	6a 00                	push   $0x0
  8001f1:	68 df 34 80 00       	push   $0x8034df
  8001f6:	e8 22 1f 00 00       	call   80211d <open>
  8001fb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8001fe:	83 c4 10             	add    $0x10,%esp
  800201:	85 c0                	test   %eax,%eax
  800203:	78 57                	js     80025c <umain+0x171>
  800205:	be 01 00 00 00       	mov    $0x1,%esi
	nloff = 0;
  80020a:	bf 00 00 00 00       	mov    $0x0,%edi
  80020f:	e9 9a 00 00 00       	jmp    8002ae <umain+0x1c3>
		panic("open testshell.sh: %e", rfd);
  800214:	50                   	push   %eax
  800215:	68 95 34 80 00       	push   $0x803495
  80021a:	6a 13                	push   $0x13
  80021c:	68 ab 34 80 00       	push   $0x8034ab
  800221:	e8 6d 03 00 00       	call   800593 <_panic>
		panic("pipe: %e", wfd);
  800226:	50                   	push   %eax
  800227:	68 bc 34 80 00       	push   $0x8034bc
  80022c:	6a 15                	push   $0x15
  80022e:	68 ab 34 80 00       	push   $0x8034ab
  800233:	e8 5b 03 00 00       	call   800593 <_panic>
		panic("fork: %e", r);
  800238:	50                   	push   %eax
  800239:	68 c5 34 80 00       	push   $0x8034c5
  80023e:	6a 1a                	push   $0x1a
  800240:	68 ab 34 80 00       	push   $0x8034ab
  800245:	e8 49 03 00 00       	call   800593 <_panic>
			panic("spawn: %e", r);
  80024a:	50                   	push   %eax
  80024b:	68 d5 34 80 00       	push   $0x8034d5
  800250:	6a 21                	push   $0x21
  800252:	68 ab 34 80 00       	push   $0x8034ab
  800257:	e8 37 03 00 00       	call   800593 <_panic>
		panic("open testshell.key for reading: %e", kfd);
  80025c:	50                   	push   %eax
  80025d:	68 48 34 80 00       	push   $0x803448
  800262:	6a 2c                	push   $0x2c
  800264:	68 ab 34 80 00       	push   $0x8034ab
  800269:	e8 25 03 00 00       	call   800593 <_panic>
			panic("reading testshell.out: %e", n1);
  80026e:	53                   	push   %ebx
  80026f:	68 ed 34 80 00       	push   $0x8034ed
  800274:	6a 33                	push   $0x33
  800276:	68 ab 34 80 00       	push   $0x8034ab
  80027b:	e8 13 03 00 00       	call   800593 <_panic>
			panic("reading testshell.key: %e", n2);
  800280:	50                   	push   %eax
  800281:	68 07 35 80 00       	push   $0x803507
  800286:	6a 35                	push   $0x35
  800288:	68 ab 34 80 00       	push   $0x8034ab
  80028d:	e8 01 03 00 00       	call   800593 <_panic>
			wrong(rfd, kfd, nloff);
  800292:	83 ec 04             	sub    $0x4,%esp
  800295:	57                   	push   %edi
  800296:	ff 75 d4             	pushl  -0x2c(%ebp)
  800299:	ff 75 d0             	pushl  -0x30(%ebp)
  80029c:	e8 92 fd ff ff       	call   800033 <wrong>
  8002a1:	83 c4 10             	add    $0x10,%esp
			nloff = off+1;
  8002a4:	80 7d e7 0a          	cmpb   $0xa,-0x19(%ebp)
  8002a8:	0f 44 fe             	cmove  %esi,%edi
  8002ab:	83 c6 01             	add    $0x1,%esi
		n1 = read(rfd, &c1, 1);
  8002ae:	83 ec 04             	sub    $0x4,%esp
  8002b1:	6a 01                	push   $0x1
  8002b3:	8d 45 e7             	lea    -0x19(%ebp),%eax
  8002b6:	50                   	push   %eax
  8002b7:	ff 75 d0             	pushl  -0x30(%ebp)
  8002ba:	e8 c0 19 00 00       	call   801c7f <read>
  8002bf:	89 c3                	mov    %eax,%ebx
		n2 = read(kfd, &c2, 1);
  8002c1:	83 c4 0c             	add    $0xc,%esp
  8002c4:	6a 01                	push   $0x1
  8002c6:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  8002c9:	50                   	push   %eax
  8002ca:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002cd:	e8 ad 19 00 00       	call   801c7f <read>
		if (n1 < 0)
  8002d2:	83 c4 10             	add    $0x10,%esp
  8002d5:	85 db                	test   %ebx,%ebx
  8002d7:	78 95                	js     80026e <umain+0x183>
		if (n2 < 0)
  8002d9:	85 c0                	test   %eax,%eax
  8002db:	78 a3                	js     800280 <umain+0x195>
		if (n1 == 0 && n2 == 0)
  8002dd:	89 da                	mov    %ebx,%edx
  8002df:	09 c2                	or     %eax,%edx
  8002e1:	74 15                	je     8002f8 <umain+0x20d>
		if (n1 != 1 || n2 != 1 || c1 != c2)
  8002e3:	83 fb 01             	cmp    $0x1,%ebx
  8002e6:	75 aa                	jne    800292 <umain+0x1a7>
  8002e8:	83 f8 01             	cmp    $0x1,%eax
  8002eb:	75 a5                	jne    800292 <umain+0x1a7>
  8002ed:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
  8002f1:	38 45 e7             	cmp    %al,-0x19(%ebp)
  8002f4:	75 9c                	jne    800292 <umain+0x1a7>
  8002f6:	eb ac                	jmp    8002a4 <umain+0x1b9>
	cprintf("shell ran correctly\n");
  8002f8:	83 ec 0c             	sub    $0xc,%esp
  8002fb:	68 21 35 80 00       	push   $0x803521
  800300:	e8 84 03 00 00       	call   800689 <cprintf>
  : "c" (msr), "a" (val1), "d" (val2))

static inline void
breakpoint(void)
{
	asm volatile("int3");
  800305:	cc                   	int3   
}
  800306:	83 c4 10             	add    $0x10,%esp
  800309:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80030c:	5b                   	pop    %ebx
  80030d:	5e                   	pop    %esi
  80030e:	5f                   	pop    %edi
  80030f:	5d                   	pop    %ebp
  800310:	c3                   	ret    

00800311 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  800311:	b8 00 00 00 00       	mov    $0x0,%eax
  800316:	c3                   	ret    

00800317 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800317:	55                   	push   %ebp
  800318:	89 e5                	mov    %esp,%ebp
  80031a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80031d:	68 36 35 80 00       	push   $0x803536
  800322:	ff 75 0c             	pushl  0xc(%ebp)
  800325:	e8 be 0a 00 00       	call   800de8 <strcpy>
	return 0;
}
  80032a:	b8 00 00 00 00       	mov    $0x0,%eax
  80032f:	c9                   	leave  
  800330:	c3                   	ret    

00800331 <devcons_write>:
{
  800331:	55                   	push   %ebp
  800332:	89 e5                	mov    %esp,%ebp
  800334:	57                   	push   %edi
  800335:	56                   	push   %esi
  800336:	53                   	push   %ebx
  800337:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80033d:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800342:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800348:	3b 75 10             	cmp    0x10(%ebp),%esi
  80034b:	73 31                	jae    80037e <devcons_write+0x4d>
		m = n - tot;
  80034d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800350:	29 f3                	sub    %esi,%ebx
  800352:	83 fb 7f             	cmp    $0x7f,%ebx
  800355:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80035a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80035d:	83 ec 04             	sub    $0x4,%esp
  800360:	53                   	push   %ebx
  800361:	89 f0                	mov    %esi,%eax
  800363:	03 45 0c             	add    0xc(%ebp),%eax
  800366:	50                   	push   %eax
  800367:	57                   	push   %edi
  800368:	e8 09 0c 00 00       	call   800f76 <memmove>
		sys_cputs(buf, m);
  80036d:	83 c4 08             	add    $0x8,%esp
  800370:	53                   	push   %ebx
  800371:	57                   	push   %edi
  800372:	e8 a7 0d 00 00       	call   80111e <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800377:	01 de                	add    %ebx,%esi
  800379:	83 c4 10             	add    $0x10,%esp
  80037c:	eb ca                	jmp    800348 <devcons_write+0x17>
}
  80037e:	89 f0                	mov    %esi,%eax
  800380:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800383:	5b                   	pop    %ebx
  800384:	5e                   	pop    %esi
  800385:	5f                   	pop    %edi
  800386:	5d                   	pop    %ebp
  800387:	c3                   	ret    

00800388 <devcons_read>:
{
  800388:	55                   	push   %ebp
  800389:	89 e5                	mov    %esp,%ebp
  80038b:	83 ec 08             	sub    $0x8,%esp
  80038e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800393:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800397:	74 21                	je     8003ba <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  800399:	e8 9e 0d 00 00       	call   80113c <sys_cgetc>
  80039e:	85 c0                	test   %eax,%eax
  8003a0:	75 07                	jne    8003a9 <devcons_read+0x21>
		sys_yield();
  8003a2:	e8 14 0e 00 00       	call   8011bb <sys_yield>
  8003a7:	eb f0                	jmp    800399 <devcons_read+0x11>
	if (c < 0)
  8003a9:	78 0f                	js     8003ba <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8003ab:	83 f8 04             	cmp    $0x4,%eax
  8003ae:	74 0c                	je     8003bc <devcons_read+0x34>
	*(char*)vbuf = c;
  8003b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003b3:	88 02                	mov    %al,(%edx)
	return 1;
  8003b5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8003ba:	c9                   	leave  
  8003bb:	c3                   	ret    
		return 0;
  8003bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c1:	eb f7                	jmp    8003ba <devcons_read+0x32>

008003c3 <cputchar>:
{
  8003c3:	55                   	push   %ebp
  8003c4:	89 e5                	mov    %esp,%ebp
  8003c6:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8003c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cc:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8003cf:	6a 01                	push   $0x1
  8003d1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8003d4:	50                   	push   %eax
  8003d5:	e8 44 0d 00 00       	call   80111e <sys_cputs>
}
  8003da:	83 c4 10             	add    $0x10,%esp
  8003dd:	c9                   	leave  
  8003de:	c3                   	ret    

008003df <getchar>:
{
  8003df:	55                   	push   %ebp
  8003e0:	89 e5                	mov    %esp,%ebp
  8003e2:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8003e5:	6a 01                	push   $0x1
  8003e7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8003ea:	50                   	push   %eax
  8003eb:	6a 00                	push   $0x0
  8003ed:	e8 8d 18 00 00       	call   801c7f <read>
	if (r < 0)
  8003f2:	83 c4 10             	add    $0x10,%esp
  8003f5:	85 c0                	test   %eax,%eax
  8003f7:	78 06                	js     8003ff <getchar+0x20>
	if (r < 1)
  8003f9:	74 06                	je     800401 <getchar+0x22>
	return c;
  8003fb:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8003ff:	c9                   	leave  
  800400:	c3                   	ret    
		return -E_EOF;
  800401:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800406:	eb f7                	jmp    8003ff <getchar+0x20>

00800408 <iscons>:
{
  800408:	55                   	push   %ebp
  800409:	89 e5                	mov    %esp,%ebp
  80040b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80040e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800411:	50                   	push   %eax
  800412:	ff 75 08             	pushl  0x8(%ebp)
  800415:	e8 f5 15 00 00       	call   801a0f <fd_lookup>
  80041a:	83 c4 10             	add    $0x10,%esp
  80041d:	85 c0                	test   %eax,%eax
  80041f:	78 11                	js     800432 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  800421:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800424:	8b 15 00 40 80 00    	mov    0x804000,%edx
  80042a:	39 10                	cmp    %edx,(%eax)
  80042c:	0f 94 c0             	sete   %al
  80042f:	0f b6 c0             	movzbl %al,%eax
}
  800432:	c9                   	leave  
  800433:	c3                   	ret    

00800434 <opencons>:
{
  800434:	55                   	push   %ebp
  800435:	89 e5                	mov    %esp,%ebp
  800437:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80043a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80043d:	50                   	push   %eax
  80043e:	e8 7a 15 00 00       	call   8019bd <fd_alloc>
  800443:	83 c4 10             	add    $0x10,%esp
  800446:	85 c0                	test   %eax,%eax
  800448:	78 3a                	js     800484 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80044a:	83 ec 04             	sub    $0x4,%esp
  80044d:	68 07 04 00 00       	push   $0x407
  800452:	ff 75 f4             	pushl  -0xc(%ebp)
  800455:	6a 00                	push   $0x0
  800457:	e8 7e 0d 00 00       	call   8011da <sys_page_alloc>
  80045c:	83 c4 10             	add    $0x10,%esp
  80045f:	85 c0                	test   %eax,%eax
  800461:	78 21                	js     800484 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  800463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800466:	8b 15 00 40 80 00    	mov    0x804000,%edx
  80046c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80046e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800471:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800478:	83 ec 0c             	sub    $0xc,%esp
  80047b:	50                   	push   %eax
  80047c:	e8 15 15 00 00       	call   801996 <fd2num>
  800481:	83 c4 10             	add    $0x10,%esp
}
  800484:	c9                   	leave  
  800485:	c3                   	ret    

00800486 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800486:	55                   	push   %ebp
  800487:	89 e5                	mov    %esp,%ebp
  800489:	57                   	push   %edi
  80048a:	56                   	push   %esi
  80048b:	53                   	push   %ebx
  80048c:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  80048f:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  800496:	00 00 00 
	envid_t find = sys_getenvid();
  800499:	e8 fe 0c 00 00       	call   80119c <sys_getenvid>
  80049e:	8b 1d 08 50 80 00    	mov    0x805008,%ebx
  8004a4:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8004a9:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8004ae:	bf 01 00 00 00       	mov    $0x1,%edi
  8004b3:	eb 0b                	jmp    8004c0 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8004b5:	83 c2 01             	add    $0x1,%edx
  8004b8:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8004be:	74 21                	je     8004e1 <libmain+0x5b>
		if(envs[i].env_id == find)
  8004c0:	89 d1                	mov    %edx,%ecx
  8004c2:	c1 e1 07             	shl    $0x7,%ecx
  8004c5:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8004cb:	8b 49 48             	mov    0x48(%ecx),%ecx
  8004ce:	39 c1                	cmp    %eax,%ecx
  8004d0:	75 e3                	jne    8004b5 <libmain+0x2f>
  8004d2:	89 d3                	mov    %edx,%ebx
  8004d4:	c1 e3 07             	shl    $0x7,%ebx
  8004d7:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8004dd:	89 fe                	mov    %edi,%esi
  8004df:	eb d4                	jmp    8004b5 <libmain+0x2f>
  8004e1:	89 f0                	mov    %esi,%eax
  8004e3:	84 c0                	test   %al,%al
  8004e5:	74 06                	je     8004ed <libmain+0x67>
  8004e7:	89 1d 08 50 80 00    	mov    %ebx,0x805008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004f1:	7e 0a                	jle    8004fd <libmain+0x77>
		binaryname = argv[0];
  8004f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f6:	8b 00                	mov    (%eax),%eax
  8004f8:	a3 1c 40 80 00       	mov    %eax,0x80401c

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8004fd:	a1 08 50 80 00       	mov    0x805008,%eax
  800502:	8b 40 48             	mov    0x48(%eax),%eax
  800505:	83 ec 08             	sub    $0x8,%esp
  800508:	50                   	push   %eax
  800509:	68 42 35 80 00       	push   $0x803542
  80050e:	e8 76 01 00 00       	call   800689 <cprintf>
	cprintf("before umain\n");
  800513:	c7 04 24 60 35 80 00 	movl   $0x803560,(%esp)
  80051a:	e8 6a 01 00 00       	call   800689 <cprintf>
	// call user main routine
	umain(argc, argv);
  80051f:	83 c4 08             	add    $0x8,%esp
  800522:	ff 75 0c             	pushl  0xc(%ebp)
  800525:	ff 75 08             	pushl  0x8(%ebp)
  800528:	e8 be fb ff ff       	call   8000eb <umain>
	cprintf("after umain\n");
  80052d:	c7 04 24 6e 35 80 00 	movl   $0x80356e,(%esp)
  800534:	e8 50 01 00 00       	call   800689 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800539:	a1 08 50 80 00       	mov    0x805008,%eax
  80053e:	8b 40 48             	mov    0x48(%eax),%eax
  800541:	83 c4 08             	add    $0x8,%esp
  800544:	50                   	push   %eax
  800545:	68 7b 35 80 00       	push   $0x80357b
  80054a:	e8 3a 01 00 00       	call   800689 <cprintf>
	// exit gracefully
	exit();
  80054f:	e8 0b 00 00 00       	call   80055f <exit>
}
  800554:	83 c4 10             	add    $0x10,%esp
  800557:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80055a:	5b                   	pop    %ebx
  80055b:	5e                   	pop    %esi
  80055c:	5f                   	pop    %edi
  80055d:	5d                   	pop    %ebp
  80055e:	c3                   	ret    

0080055f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80055f:	55                   	push   %ebp
  800560:	89 e5                	mov    %esp,%ebp
  800562:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800565:	a1 08 50 80 00       	mov    0x805008,%eax
  80056a:	8b 40 48             	mov    0x48(%eax),%eax
  80056d:	68 a8 35 80 00       	push   $0x8035a8
  800572:	50                   	push   %eax
  800573:	68 9a 35 80 00       	push   $0x80359a
  800578:	e8 0c 01 00 00       	call   800689 <cprintf>
	close_all();
  80057d:	e8 ec 15 00 00       	call   801b6e <close_all>
	sys_env_destroy(0);
  800582:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800589:	e8 cd 0b 00 00       	call   80115b <sys_env_destroy>
}
  80058e:	83 c4 10             	add    $0x10,%esp
  800591:	c9                   	leave  
  800592:	c3                   	ret    

00800593 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800593:	55                   	push   %ebp
  800594:	89 e5                	mov    %esp,%ebp
  800596:	56                   	push   %esi
  800597:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800598:	a1 08 50 80 00       	mov    0x805008,%eax
  80059d:	8b 40 48             	mov    0x48(%eax),%eax
  8005a0:	83 ec 04             	sub    $0x4,%esp
  8005a3:	68 d4 35 80 00       	push   $0x8035d4
  8005a8:	50                   	push   %eax
  8005a9:	68 9a 35 80 00       	push   $0x80359a
  8005ae:	e8 d6 00 00 00       	call   800689 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8005b3:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8005b6:	8b 35 1c 40 80 00    	mov    0x80401c,%esi
  8005bc:	e8 db 0b 00 00       	call   80119c <sys_getenvid>
  8005c1:	83 c4 04             	add    $0x4,%esp
  8005c4:	ff 75 0c             	pushl  0xc(%ebp)
  8005c7:	ff 75 08             	pushl  0x8(%ebp)
  8005ca:	56                   	push   %esi
  8005cb:	50                   	push   %eax
  8005cc:	68 b0 35 80 00       	push   $0x8035b0
  8005d1:	e8 b3 00 00 00       	call   800689 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005d6:	83 c4 18             	add    $0x18,%esp
  8005d9:	53                   	push   %ebx
  8005da:	ff 75 10             	pushl  0x10(%ebp)
  8005dd:	e8 56 00 00 00       	call   800638 <vcprintf>
	cprintf("\n");
  8005e2:	c7 04 24 5e 35 80 00 	movl   $0x80355e,(%esp)
  8005e9:	e8 9b 00 00 00       	call   800689 <cprintf>
  8005ee:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8005f1:	cc                   	int3   
  8005f2:	eb fd                	jmp    8005f1 <_panic+0x5e>

008005f4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8005f4:	55                   	push   %ebp
  8005f5:	89 e5                	mov    %esp,%ebp
  8005f7:	53                   	push   %ebx
  8005f8:	83 ec 04             	sub    $0x4,%esp
  8005fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8005fe:	8b 13                	mov    (%ebx),%edx
  800600:	8d 42 01             	lea    0x1(%edx),%eax
  800603:	89 03                	mov    %eax,(%ebx)
  800605:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800608:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80060c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800611:	74 09                	je     80061c <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800613:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800617:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80061a:	c9                   	leave  
  80061b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80061c:	83 ec 08             	sub    $0x8,%esp
  80061f:	68 ff 00 00 00       	push   $0xff
  800624:	8d 43 08             	lea    0x8(%ebx),%eax
  800627:	50                   	push   %eax
  800628:	e8 f1 0a 00 00       	call   80111e <sys_cputs>
		b->idx = 0;
  80062d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800633:	83 c4 10             	add    $0x10,%esp
  800636:	eb db                	jmp    800613 <putch+0x1f>

00800638 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800638:	55                   	push   %ebp
  800639:	89 e5                	mov    %esp,%ebp
  80063b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800641:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800648:	00 00 00 
	b.cnt = 0;
  80064b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800652:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800655:	ff 75 0c             	pushl  0xc(%ebp)
  800658:	ff 75 08             	pushl  0x8(%ebp)
  80065b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800661:	50                   	push   %eax
  800662:	68 f4 05 80 00       	push   $0x8005f4
  800667:	e8 4a 01 00 00       	call   8007b6 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80066c:	83 c4 08             	add    $0x8,%esp
  80066f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800675:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80067b:	50                   	push   %eax
  80067c:	e8 9d 0a 00 00       	call   80111e <sys_cputs>

	return b.cnt;
}
  800681:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800687:	c9                   	leave  
  800688:	c3                   	ret    

00800689 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800689:	55                   	push   %ebp
  80068a:	89 e5                	mov    %esp,%ebp
  80068c:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80068f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800692:	50                   	push   %eax
  800693:	ff 75 08             	pushl  0x8(%ebp)
  800696:	e8 9d ff ff ff       	call   800638 <vcprintf>
	va_end(ap);

	return cnt;
}
  80069b:	c9                   	leave  
  80069c:	c3                   	ret    

0080069d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80069d:	55                   	push   %ebp
  80069e:	89 e5                	mov    %esp,%ebp
  8006a0:	57                   	push   %edi
  8006a1:	56                   	push   %esi
  8006a2:	53                   	push   %ebx
  8006a3:	83 ec 1c             	sub    $0x1c,%esp
  8006a6:	89 c6                	mov    %eax,%esi
  8006a8:	89 d7                	mov    %edx,%edi
  8006aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006b3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8006b9:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8006bc:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8006c0:	74 2c                	je     8006ee <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8006c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8006cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006cf:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8006d2:	39 c2                	cmp    %eax,%edx
  8006d4:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8006d7:	73 43                	jae    80071c <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8006d9:	83 eb 01             	sub    $0x1,%ebx
  8006dc:	85 db                	test   %ebx,%ebx
  8006de:	7e 6c                	jle    80074c <printnum+0xaf>
				putch(padc, putdat);
  8006e0:	83 ec 08             	sub    $0x8,%esp
  8006e3:	57                   	push   %edi
  8006e4:	ff 75 18             	pushl  0x18(%ebp)
  8006e7:	ff d6                	call   *%esi
  8006e9:	83 c4 10             	add    $0x10,%esp
  8006ec:	eb eb                	jmp    8006d9 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8006ee:	83 ec 0c             	sub    $0xc,%esp
  8006f1:	6a 20                	push   $0x20
  8006f3:	6a 00                	push   $0x0
  8006f5:	50                   	push   %eax
  8006f6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8006f9:	ff 75 e0             	pushl  -0x20(%ebp)
  8006fc:	89 fa                	mov    %edi,%edx
  8006fe:	89 f0                	mov    %esi,%eax
  800700:	e8 98 ff ff ff       	call   80069d <printnum>
		while (--width > 0)
  800705:	83 c4 20             	add    $0x20,%esp
  800708:	83 eb 01             	sub    $0x1,%ebx
  80070b:	85 db                	test   %ebx,%ebx
  80070d:	7e 65                	jle    800774 <printnum+0xd7>
			putch(padc, putdat);
  80070f:	83 ec 08             	sub    $0x8,%esp
  800712:	57                   	push   %edi
  800713:	6a 20                	push   $0x20
  800715:	ff d6                	call   *%esi
  800717:	83 c4 10             	add    $0x10,%esp
  80071a:	eb ec                	jmp    800708 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80071c:	83 ec 0c             	sub    $0xc,%esp
  80071f:	ff 75 18             	pushl  0x18(%ebp)
  800722:	83 eb 01             	sub    $0x1,%ebx
  800725:	53                   	push   %ebx
  800726:	50                   	push   %eax
  800727:	83 ec 08             	sub    $0x8,%esp
  80072a:	ff 75 dc             	pushl  -0x24(%ebp)
  80072d:	ff 75 d8             	pushl  -0x28(%ebp)
  800730:	ff 75 e4             	pushl  -0x1c(%ebp)
  800733:	ff 75 e0             	pushl  -0x20(%ebp)
  800736:	e8 75 2a 00 00       	call   8031b0 <__udivdi3>
  80073b:	83 c4 18             	add    $0x18,%esp
  80073e:	52                   	push   %edx
  80073f:	50                   	push   %eax
  800740:	89 fa                	mov    %edi,%edx
  800742:	89 f0                	mov    %esi,%eax
  800744:	e8 54 ff ff ff       	call   80069d <printnum>
  800749:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80074c:	83 ec 08             	sub    $0x8,%esp
  80074f:	57                   	push   %edi
  800750:	83 ec 04             	sub    $0x4,%esp
  800753:	ff 75 dc             	pushl  -0x24(%ebp)
  800756:	ff 75 d8             	pushl  -0x28(%ebp)
  800759:	ff 75 e4             	pushl  -0x1c(%ebp)
  80075c:	ff 75 e0             	pushl  -0x20(%ebp)
  80075f:	e8 5c 2b 00 00       	call   8032c0 <__umoddi3>
  800764:	83 c4 14             	add    $0x14,%esp
  800767:	0f be 80 db 35 80 00 	movsbl 0x8035db(%eax),%eax
  80076e:	50                   	push   %eax
  80076f:	ff d6                	call   *%esi
  800771:	83 c4 10             	add    $0x10,%esp
	}
}
  800774:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800777:	5b                   	pop    %ebx
  800778:	5e                   	pop    %esi
  800779:	5f                   	pop    %edi
  80077a:	5d                   	pop    %ebp
  80077b:	c3                   	ret    

0080077c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80077c:	55                   	push   %ebp
  80077d:	89 e5                	mov    %esp,%ebp
  80077f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800782:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800786:	8b 10                	mov    (%eax),%edx
  800788:	3b 50 04             	cmp    0x4(%eax),%edx
  80078b:	73 0a                	jae    800797 <sprintputch+0x1b>
		*b->buf++ = ch;
  80078d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800790:	89 08                	mov    %ecx,(%eax)
  800792:	8b 45 08             	mov    0x8(%ebp),%eax
  800795:	88 02                	mov    %al,(%edx)
}
  800797:	5d                   	pop    %ebp
  800798:	c3                   	ret    

00800799 <printfmt>:
{
  800799:	55                   	push   %ebp
  80079a:	89 e5                	mov    %esp,%ebp
  80079c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80079f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8007a2:	50                   	push   %eax
  8007a3:	ff 75 10             	pushl  0x10(%ebp)
  8007a6:	ff 75 0c             	pushl  0xc(%ebp)
  8007a9:	ff 75 08             	pushl  0x8(%ebp)
  8007ac:	e8 05 00 00 00       	call   8007b6 <vprintfmt>
}
  8007b1:	83 c4 10             	add    $0x10,%esp
  8007b4:	c9                   	leave  
  8007b5:	c3                   	ret    

008007b6 <vprintfmt>:
{
  8007b6:	55                   	push   %ebp
  8007b7:	89 e5                	mov    %esp,%ebp
  8007b9:	57                   	push   %edi
  8007ba:	56                   	push   %esi
  8007bb:	53                   	push   %ebx
  8007bc:	83 ec 3c             	sub    $0x3c,%esp
  8007bf:	8b 75 08             	mov    0x8(%ebp),%esi
  8007c2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8007c5:	8b 7d 10             	mov    0x10(%ebp),%edi
  8007c8:	e9 32 04 00 00       	jmp    800bff <vprintfmt+0x449>
		padc = ' ';
  8007cd:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8007d1:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8007d8:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8007df:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8007e6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007ed:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8007f4:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8007f9:	8d 47 01             	lea    0x1(%edi),%eax
  8007fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007ff:	0f b6 17             	movzbl (%edi),%edx
  800802:	8d 42 dd             	lea    -0x23(%edx),%eax
  800805:	3c 55                	cmp    $0x55,%al
  800807:	0f 87 12 05 00 00    	ja     800d1f <vprintfmt+0x569>
  80080d:	0f b6 c0             	movzbl %al,%eax
  800810:	ff 24 85 c0 37 80 00 	jmp    *0x8037c0(,%eax,4)
  800817:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80081a:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80081e:	eb d9                	jmp    8007f9 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800820:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800823:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800827:	eb d0                	jmp    8007f9 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800829:	0f b6 d2             	movzbl %dl,%edx
  80082c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80082f:	b8 00 00 00 00       	mov    $0x0,%eax
  800834:	89 75 08             	mov    %esi,0x8(%ebp)
  800837:	eb 03                	jmp    80083c <vprintfmt+0x86>
  800839:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80083c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80083f:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800843:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800846:	8d 72 d0             	lea    -0x30(%edx),%esi
  800849:	83 fe 09             	cmp    $0x9,%esi
  80084c:	76 eb                	jbe    800839 <vprintfmt+0x83>
  80084e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800851:	8b 75 08             	mov    0x8(%ebp),%esi
  800854:	eb 14                	jmp    80086a <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800856:	8b 45 14             	mov    0x14(%ebp),%eax
  800859:	8b 00                	mov    (%eax),%eax
  80085b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80085e:	8b 45 14             	mov    0x14(%ebp),%eax
  800861:	8d 40 04             	lea    0x4(%eax),%eax
  800864:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800867:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80086a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80086e:	79 89                	jns    8007f9 <vprintfmt+0x43>
				width = precision, precision = -1;
  800870:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800873:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800876:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80087d:	e9 77 ff ff ff       	jmp    8007f9 <vprintfmt+0x43>
  800882:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800885:	85 c0                	test   %eax,%eax
  800887:	0f 48 c1             	cmovs  %ecx,%eax
  80088a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80088d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800890:	e9 64 ff ff ff       	jmp    8007f9 <vprintfmt+0x43>
  800895:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800898:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80089f:	e9 55 ff ff ff       	jmp    8007f9 <vprintfmt+0x43>
			lflag++;
  8008a4:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8008a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8008ab:	e9 49 ff ff ff       	jmp    8007f9 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8008b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b3:	8d 78 04             	lea    0x4(%eax),%edi
  8008b6:	83 ec 08             	sub    $0x8,%esp
  8008b9:	53                   	push   %ebx
  8008ba:	ff 30                	pushl  (%eax)
  8008bc:	ff d6                	call   *%esi
			break;
  8008be:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8008c1:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8008c4:	e9 33 03 00 00       	jmp    800bfc <vprintfmt+0x446>
			err = va_arg(ap, int);
  8008c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cc:	8d 78 04             	lea    0x4(%eax),%edi
  8008cf:	8b 00                	mov    (%eax),%eax
  8008d1:	99                   	cltd   
  8008d2:	31 d0                	xor    %edx,%eax
  8008d4:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008d6:	83 f8 11             	cmp    $0x11,%eax
  8008d9:	7f 23                	jg     8008fe <vprintfmt+0x148>
  8008db:	8b 14 85 20 39 80 00 	mov    0x803920(,%eax,4),%edx
  8008e2:	85 d2                	test   %edx,%edx
  8008e4:	74 18                	je     8008fe <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8008e6:	52                   	push   %edx
  8008e7:	68 2d 3b 80 00       	push   $0x803b2d
  8008ec:	53                   	push   %ebx
  8008ed:	56                   	push   %esi
  8008ee:	e8 a6 fe ff ff       	call   800799 <printfmt>
  8008f3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8008f6:	89 7d 14             	mov    %edi,0x14(%ebp)
  8008f9:	e9 fe 02 00 00       	jmp    800bfc <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8008fe:	50                   	push   %eax
  8008ff:	68 f3 35 80 00       	push   $0x8035f3
  800904:	53                   	push   %ebx
  800905:	56                   	push   %esi
  800906:	e8 8e fe ff ff       	call   800799 <printfmt>
  80090b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80090e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800911:	e9 e6 02 00 00       	jmp    800bfc <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800916:	8b 45 14             	mov    0x14(%ebp),%eax
  800919:	83 c0 04             	add    $0x4,%eax
  80091c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80091f:	8b 45 14             	mov    0x14(%ebp),%eax
  800922:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800924:	85 c9                	test   %ecx,%ecx
  800926:	b8 ec 35 80 00       	mov    $0x8035ec,%eax
  80092b:	0f 45 c1             	cmovne %ecx,%eax
  80092e:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800931:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800935:	7e 06                	jle    80093d <vprintfmt+0x187>
  800937:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80093b:	75 0d                	jne    80094a <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80093d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800940:	89 c7                	mov    %eax,%edi
  800942:	03 45 e0             	add    -0x20(%ebp),%eax
  800945:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800948:	eb 53                	jmp    80099d <vprintfmt+0x1e7>
  80094a:	83 ec 08             	sub    $0x8,%esp
  80094d:	ff 75 d8             	pushl  -0x28(%ebp)
  800950:	50                   	push   %eax
  800951:	e8 71 04 00 00       	call   800dc7 <strnlen>
  800956:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800959:	29 c1                	sub    %eax,%ecx
  80095b:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80095e:	83 c4 10             	add    $0x10,%esp
  800961:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800963:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800967:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80096a:	eb 0f                	jmp    80097b <vprintfmt+0x1c5>
					putch(padc, putdat);
  80096c:	83 ec 08             	sub    $0x8,%esp
  80096f:	53                   	push   %ebx
  800970:	ff 75 e0             	pushl  -0x20(%ebp)
  800973:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800975:	83 ef 01             	sub    $0x1,%edi
  800978:	83 c4 10             	add    $0x10,%esp
  80097b:	85 ff                	test   %edi,%edi
  80097d:	7f ed                	jg     80096c <vprintfmt+0x1b6>
  80097f:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800982:	85 c9                	test   %ecx,%ecx
  800984:	b8 00 00 00 00       	mov    $0x0,%eax
  800989:	0f 49 c1             	cmovns %ecx,%eax
  80098c:	29 c1                	sub    %eax,%ecx
  80098e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800991:	eb aa                	jmp    80093d <vprintfmt+0x187>
					putch(ch, putdat);
  800993:	83 ec 08             	sub    $0x8,%esp
  800996:	53                   	push   %ebx
  800997:	52                   	push   %edx
  800998:	ff d6                	call   *%esi
  80099a:	83 c4 10             	add    $0x10,%esp
  80099d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8009a0:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009a2:	83 c7 01             	add    $0x1,%edi
  8009a5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009a9:	0f be d0             	movsbl %al,%edx
  8009ac:	85 d2                	test   %edx,%edx
  8009ae:	74 4b                	je     8009fb <vprintfmt+0x245>
  8009b0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8009b4:	78 06                	js     8009bc <vprintfmt+0x206>
  8009b6:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8009ba:	78 1e                	js     8009da <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8009bc:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8009c0:	74 d1                	je     800993 <vprintfmt+0x1dd>
  8009c2:	0f be c0             	movsbl %al,%eax
  8009c5:	83 e8 20             	sub    $0x20,%eax
  8009c8:	83 f8 5e             	cmp    $0x5e,%eax
  8009cb:	76 c6                	jbe    800993 <vprintfmt+0x1dd>
					putch('?', putdat);
  8009cd:	83 ec 08             	sub    $0x8,%esp
  8009d0:	53                   	push   %ebx
  8009d1:	6a 3f                	push   $0x3f
  8009d3:	ff d6                	call   *%esi
  8009d5:	83 c4 10             	add    $0x10,%esp
  8009d8:	eb c3                	jmp    80099d <vprintfmt+0x1e7>
  8009da:	89 cf                	mov    %ecx,%edi
  8009dc:	eb 0e                	jmp    8009ec <vprintfmt+0x236>
				putch(' ', putdat);
  8009de:	83 ec 08             	sub    $0x8,%esp
  8009e1:	53                   	push   %ebx
  8009e2:	6a 20                	push   $0x20
  8009e4:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8009e6:	83 ef 01             	sub    $0x1,%edi
  8009e9:	83 c4 10             	add    $0x10,%esp
  8009ec:	85 ff                	test   %edi,%edi
  8009ee:	7f ee                	jg     8009de <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8009f0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8009f3:	89 45 14             	mov    %eax,0x14(%ebp)
  8009f6:	e9 01 02 00 00       	jmp    800bfc <vprintfmt+0x446>
  8009fb:	89 cf                	mov    %ecx,%edi
  8009fd:	eb ed                	jmp    8009ec <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8009ff:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800a02:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800a09:	e9 eb fd ff ff       	jmp    8007f9 <vprintfmt+0x43>
	if (lflag >= 2)
  800a0e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800a12:	7f 21                	jg     800a35 <vprintfmt+0x27f>
	else if (lflag)
  800a14:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a18:	74 68                	je     800a82 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800a1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1d:	8b 00                	mov    (%eax),%eax
  800a1f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800a22:	89 c1                	mov    %eax,%ecx
  800a24:	c1 f9 1f             	sar    $0x1f,%ecx
  800a27:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800a2a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2d:	8d 40 04             	lea    0x4(%eax),%eax
  800a30:	89 45 14             	mov    %eax,0x14(%ebp)
  800a33:	eb 17                	jmp    800a4c <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800a35:	8b 45 14             	mov    0x14(%ebp),%eax
  800a38:	8b 50 04             	mov    0x4(%eax),%edx
  800a3b:	8b 00                	mov    (%eax),%eax
  800a3d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800a40:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800a43:	8b 45 14             	mov    0x14(%ebp),%eax
  800a46:	8d 40 08             	lea    0x8(%eax),%eax
  800a49:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800a4c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a4f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800a52:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a55:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800a58:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800a5c:	78 3f                	js     800a9d <vprintfmt+0x2e7>
			base = 10;
  800a5e:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800a63:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800a67:	0f 84 71 01 00 00    	je     800bde <vprintfmt+0x428>
				putch('+', putdat);
  800a6d:	83 ec 08             	sub    $0x8,%esp
  800a70:	53                   	push   %ebx
  800a71:	6a 2b                	push   $0x2b
  800a73:	ff d6                	call   *%esi
  800a75:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800a78:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a7d:	e9 5c 01 00 00       	jmp    800bde <vprintfmt+0x428>
		return va_arg(*ap, int);
  800a82:	8b 45 14             	mov    0x14(%ebp),%eax
  800a85:	8b 00                	mov    (%eax),%eax
  800a87:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800a8a:	89 c1                	mov    %eax,%ecx
  800a8c:	c1 f9 1f             	sar    $0x1f,%ecx
  800a8f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800a92:	8b 45 14             	mov    0x14(%ebp),%eax
  800a95:	8d 40 04             	lea    0x4(%eax),%eax
  800a98:	89 45 14             	mov    %eax,0x14(%ebp)
  800a9b:	eb af                	jmp    800a4c <vprintfmt+0x296>
				putch('-', putdat);
  800a9d:	83 ec 08             	sub    $0x8,%esp
  800aa0:	53                   	push   %ebx
  800aa1:	6a 2d                	push   $0x2d
  800aa3:	ff d6                	call   *%esi
				num = -(long long) num;
  800aa5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800aa8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800aab:	f7 d8                	neg    %eax
  800aad:	83 d2 00             	adc    $0x0,%edx
  800ab0:	f7 da                	neg    %edx
  800ab2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ab5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ab8:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800abb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ac0:	e9 19 01 00 00       	jmp    800bde <vprintfmt+0x428>
	if (lflag >= 2)
  800ac5:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800ac9:	7f 29                	jg     800af4 <vprintfmt+0x33e>
	else if (lflag)
  800acb:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800acf:	74 44                	je     800b15 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800ad1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad4:	8b 00                	mov    (%eax),%eax
  800ad6:	ba 00 00 00 00       	mov    $0x0,%edx
  800adb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ade:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ae1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae4:	8d 40 04             	lea    0x4(%eax),%eax
  800ae7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800aea:	b8 0a 00 00 00       	mov    $0xa,%eax
  800aef:	e9 ea 00 00 00       	jmp    800bde <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800af4:	8b 45 14             	mov    0x14(%ebp),%eax
  800af7:	8b 50 04             	mov    0x4(%eax),%edx
  800afa:	8b 00                	mov    (%eax),%eax
  800afc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aff:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b02:	8b 45 14             	mov    0x14(%ebp),%eax
  800b05:	8d 40 08             	lea    0x8(%eax),%eax
  800b08:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b0b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b10:	e9 c9 00 00 00       	jmp    800bde <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800b15:	8b 45 14             	mov    0x14(%ebp),%eax
  800b18:	8b 00                	mov    (%eax),%eax
  800b1a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b1f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b22:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b25:	8b 45 14             	mov    0x14(%ebp),%eax
  800b28:	8d 40 04             	lea    0x4(%eax),%eax
  800b2b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b2e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b33:	e9 a6 00 00 00       	jmp    800bde <vprintfmt+0x428>
			putch('0', putdat);
  800b38:	83 ec 08             	sub    $0x8,%esp
  800b3b:	53                   	push   %ebx
  800b3c:	6a 30                	push   $0x30
  800b3e:	ff d6                	call   *%esi
	if (lflag >= 2)
  800b40:	83 c4 10             	add    $0x10,%esp
  800b43:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800b47:	7f 26                	jg     800b6f <vprintfmt+0x3b9>
	else if (lflag)
  800b49:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800b4d:	74 3e                	je     800b8d <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800b4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b52:	8b 00                	mov    (%eax),%eax
  800b54:	ba 00 00 00 00       	mov    $0x0,%edx
  800b59:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b5c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b5f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b62:	8d 40 04             	lea    0x4(%eax),%eax
  800b65:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b68:	b8 08 00 00 00       	mov    $0x8,%eax
  800b6d:	eb 6f                	jmp    800bde <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800b6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b72:	8b 50 04             	mov    0x4(%eax),%edx
  800b75:	8b 00                	mov    (%eax),%eax
  800b77:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b7a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b80:	8d 40 08             	lea    0x8(%eax),%eax
  800b83:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b86:	b8 08 00 00 00       	mov    $0x8,%eax
  800b8b:	eb 51                	jmp    800bde <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800b8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b90:	8b 00                	mov    (%eax),%eax
  800b92:	ba 00 00 00 00       	mov    $0x0,%edx
  800b97:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b9a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba0:	8d 40 04             	lea    0x4(%eax),%eax
  800ba3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800ba6:	b8 08 00 00 00       	mov    $0x8,%eax
  800bab:	eb 31                	jmp    800bde <vprintfmt+0x428>
			putch('0', putdat);
  800bad:	83 ec 08             	sub    $0x8,%esp
  800bb0:	53                   	push   %ebx
  800bb1:	6a 30                	push   $0x30
  800bb3:	ff d6                	call   *%esi
			putch('x', putdat);
  800bb5:	83 c4 08             	add    $0x8,%esp
  800bb8:	53                   	push   %ebx
  800bb9:	6a 78                	push   $0x78
  800bbb:	ff d6                	call   *%esi
			num = (unsigned long long)
  800bbd:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc0:	8b 00                	mov    (%eax),%eax
  800bc2:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bca:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800bcd:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800bd0:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd3:	8d 40 04             	lea    0x4(%eax),%eax
  800bd6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800bd9:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800bde:	83 ec 0c             	sub    $0xc,%esp
  800be1:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800be5:	52                   	push   %edx
  800be6:	ff 75 e0             	pushl  -0x20(%ebp)
  800be9:	50                   	push   %eax
  800bea:	ff 75 dc             	pushl  -0x24(%ebp)
  800bed:	ff 75 d8             	pushl  -0x28(%ebp)
  800bf0:	89 da                	mov    %ebx,%edx
  800bf2:	89 f0                	mov    %esi,%eax
  800bf4:	e8 a4 fa ff ff       	call   80069d <printnum>
			break;
  800bf9:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800bfc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bff:	83 c7 01             	add    $0x1,%edi
  800c02:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800c06:	83 f8 25             	cmp    $0x25,%eax
  800c09:	0f 84 be fb ff ff    	je     8007cd <vprintfmt+0x17>
			if (ch == '\0')
  800c0f:	85 c0                	test   %eax,%eax
  800c11:	0f 84 28 01 00 00    	je     800d3f <vprintfmt+0x589>
			putch(ch, putdat);
  800c17:	83 ec 08             	sub    $0x8,%esp
  800c1a:	53                   	push   %ebx
  800c1b:	50                   	push   %eax
  800c1c:	ff d6                	call   *%esi
  800c1e:	83 c4 10             	add    $0x10,%esp
  800c21:	eb dc                	jmp    800bff <vprintfmt+0x449>
	if (lflag >= 2)
  800c23:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800c27:	7f 26                	jg     800c4f <vprintfmt+0x499>
	else if (lflag)
  800c29:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800c2d:	74 41                	je     800c70 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800c2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c32:	8b 00                	mov    (%eax),%eax
  800c34:	ba 00 00 00 00       	mov    $0x0,%edx
  800c39:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c3c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c42:	8d 40 04             	lea    0x4(%eax),%eax
  800c45:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c48:	b8 10 00 00 00       	mov    $0x10,%eax
  800c4d:	eb 8f                	jmp    800bde <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800c4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c52:	8b 50 04             	mov    0x4(%eax),%edx
  800c55:	8b 00                	mov    (%eax),%eax
  800c57:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c5a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c60:	8d 40 08             	lea    0x8(%eax),%eax
  800c63:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c66:	b8 10 00 00 00       	mov    $0x10,%eax
  800c6b:	e9 6e ff ff ff       	jmp    800bde <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800c70:	8b 45 14             	mov    0x14(%ebp),%eax
  800c73:	8b 00                	mov    (%eax),%eax
  800c75:	ba 00 00 00 00       	mov    $0x0,%edx
  800c7a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c7d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c80:	8b 45 14             	mov    0x14(%ebp),%eax
  800c83:	8d 40 04             	lea    0x4(%eax),%eax
  800c86:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c89:	b8 10 00 00 00       	mov    $0x10,%eax
  800c8e:	e9 4b ff ff ff       	jmp    800bde <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800c93:	8b 45 14             	mov    0x14(%ebp),%eax
  800c96:	83 c0 04             	add    $0x4,%eax
  800c99:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c9c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9f:	8b 00                	mov    (%eax),%eax
  800ca1:	85 c0                	test   %eax,%eax
  800ca3:	74 14                	je     800cb9 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800ca5:	8b 13                	mov    (%ebx),%edx
  800ca7:	83 fa 7f             	cmp    $0x7f,%edx
  800caa:	7f 37                	jg     800ce3 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800cac:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800cae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800cb1:	89 45 14             	mov    %eax,0x14(%ebp)
  800cb4:	e9 43 ff ff ff       	jmp    800bfc <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800cb9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cbe:	bf 11 37 80 00       	mov    $0x803711,%edi
							putch(ch, putdat);
  800cc3:	83 ec 08             	sub    $0x8,%esp
  800cc6:	53                   	push   %ebx
  800cc7:	50                   	push   %eax
  800cc8:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800cca:	83 c7 01             	add    $0x1,%edi
  800ccd:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800cd1:	83 c4 10             	add    $0x10,%esp
  800cd4:	85 c0                	test   %eax,%eax
  800cd6:	75 eb                	jne    800cc3 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800cd8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800cdb:	89 45 14             	mov    %eax,0x14(%ebp)
  800cde:	e9 19 ff ff ff       	jmp    800bfc <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800ce3:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800ce5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cea:	bf 49 37 80 00       	mov    $0x803749,%edi
							putch(ch, putdat);
  800cef:	83 ec 08             	sub    $0x8,%esp
  800cf2:	53                   	push   %ebx
  800cf3:	50                   	push   %eax
  800cf4:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800cf6:	83 c7 01             	add    $0x1,%edi
  800cf9:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800cfd:	83 c4 10             	add    $0x10,%esp
  800d00:	85 c0                	test   %eax,%eax
  800d02:	75 eb                	jne    800cef <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800d04:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d07:	89 45 14             	mov    %eax,0x14(%ebp)
  800d0a:	e9 ed fe ff ff       	jmp    800bfc <vprintfmt+0x446>
			putch(ch, putdat);
  800d0f:	83 ec 08             	sub    $0x8,%esp
  800d12:	53                   	push   %ebx
  800d13:	6a 25                	push   $0x25
  800d15:	ff d6                	call   *%esi
			break;
  800d17:	83 c4 10             	add    $0x10,%esp
  800d1a:	e9 dd fe ff ff       	jmp    800bfc <vprintfmt+0x446>
			putch('%', putdat);
  800d1f:	83 ec 08             	sub    $0x8,%esp
  800d22:	53                   	push   %ebx
  800d23:	6a 25                	push   $0x25
  800d25:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d27:	83 c4 10             	add    $0x10,%esp
  800d2a:	89 f8                	mov    %edi,%eax
  800d2c:	eb 03                	jmp    800d31 <vprintfmt+0x57b>
  800d2e:	83 e8 01             	sub    $0x1,%eax
  800d31:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800d35:	75 f7                	jne    800d2e <vprintfmt+0x578>
  800d37:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d3a:	e9 bd fe ff ff       	jmp    800bfc <vprintfmt+0x446>
}
  800d3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d42:	5b                   	pop    %ebx
  800d43:	5e                   	pop    %esi
  800d44:	5f                   	pop    %edi
  800d45:	5d                   	pop    %ebp
  800d46:	c3                   	ret    

00800d47 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d47:	55                   	push   %ebp
  800d48:	89 e5                	mov    %esp,%ebp
  800d4a:	83 ec 18             	sub    $0x18,%esp
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d53:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d56:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800d5a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800d5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d64:	85 c0                	test   %eax,%eax
  800d66:	74 26                	je     800d8e <vsnprintf+0x47>
  800d68:	85 d2                	test   %edx,%edx
  800d6a:	7e 22                	jle    800d8e <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d6c:	ff 75 14             	pushl  0x14(%ebp)
  800d6f:	ff 75 10             	pushl  0x10(%ebp)
  800d72:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d75:	50                   	push   %eax
  800d76:	68 7c 07 80 00       	push   $0x80077c
  800d7b:	e8 36 fa ff ff       	call   8007b6 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800d80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d83:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d89:	83 c4 10             	add    $0x10,%esp
}
  800d8c:	c9                   	leave  
  800d8d:	c3                   	ret    
		return -E_INVAL;
  800d8e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d93:	eb f7                	jmp    800d8c <vsnprintf+0x45>

00800d95 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
  800d98:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d9b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800d9e:	50                   	push   %eax
  800d9f:	ff 75 10             	pushl  0x10(%ebp)
  800da2:	ff 75 0c             	pushl  0xc(%ebp)
  800da5:	ff 75 08             	pushl  0x8(%ebp)
  800da8:	e8 9a ff ff ff       	call   800d47 <vsnprintf>
	va_end(ap);

	return rc;
}
  800dad:	c9                   	leave  
  800dae:	c3                   	ret    

00800daf <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800db5:	b8 00 00 00 00       	mov    $0x0,%eax
  800dba:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800dbe:	74 05                	je     800dc5 <strlen+0x16>
		n++;
  800dc0:	83 c0 01             	add    $0x1,%eax
  800dc3:	eb f5                	jmp    800dba <strlen+0xb>
	return n;
}
  800dc5:	5d                   	pop    %ebp
  800dc6:	c3                   	ret    

00800dc7 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800dc7:	55                   	push   %ebp
  800dc8:	89 e5                	mov    %esp,%ebp
  800dca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dcd:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dd0:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd5:	39 c2                	cmp    %eax,%edx
  800dd7:	74 0d                	je     800de6 <strnlen+0x1f>
  800dd9:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800ddd:	74 05                	je     800de4 <strnlen+0x1d>
		n++;
  800ddf:	83 c2 01             	add    $0x1,%edx
  800de2:	eb f1                	jmp    800dd5 <strnlen+0xe>
  800de4:	89 d0                	mov    %edx,%eax
	return n;
}
  800de6:	5d                   	pop    %ebp
  800de7:	c3                   	ret    

00800de8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
  800deb:	53                   	push   %ebx
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800df2:	ba 00 00 00 00       	mov    $0x0,%edx
  800df7:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800dfb:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800dfe:	83 c2 01             	add    $0x1,%edx
  800e01:	84 c9                	test   %cl,%cl
  800e03:	75 f2                	jne    800df7 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800e05:	5b                   	pop    %ebx
  800e06:	5d                   	pop    %ebp
  800e07:	c3                   	ret    

00800e08 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e08:	55                   	push   %ebp
  800e09:	89 e5                	mov    %esp,%ebp
  800e0b:	53                   	push   %ebx
  800e0c:	83 ec 10             	sub    $0x10,%esp
  800e0f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800e12:	53                   	push   %ebx
  800e13:	e8 97 ff ff ff       	call   800daf <strlen>
  800e18:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800e1b:	ff 75 0c             	pushl  0xc(%ebp)
  800e1e:	01 d8                	add    %ebx,%eax
  800e20:	50                   	push   %eax
  800e21:	e8 c2 ff ff ff       	call   800de8 <strcpy>
	return dst;
}
  800e26:	89 d8                	mov    %ebx,%eax
  800e28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e2b:	c9                   	leave  
  800e2c:	c3                   	ret    

00800e2d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
  800e30:	56                   	push   %esi
  800e31:	53                   	push   %ebx
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e38:	89 c6                	mov    %eax,%esi
  800e3a:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e3d:	89 c2                	mov    %eax,%edx
  800e3f:	39 f2                	cmp    %esi,%edx
  800e41:	74 11                	je     800e54 <strncpy+0x27>
		*dst++ = *src;
  800e43:	83 c2 01             	add    $0x1,%edx
  800e46:	0f b6 19             	movzbl (%ecx),%ebx
  800e49:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800e4c:	80 fb 01             	cmp    $0x1,%bl
  800e4f:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800e52:	eb eb                	jmp    800e3f <strncpy+0x12>
	}
	return ret;
}
  800e54:	5b                   	pop    %ebx
  800e55:	5e                   	pop    %esi
  800e56:	5d                   	pop    %ebp
  800e57:	c3                   	ret    

00800e58 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800e58:	55                   	push   %ebp
  800e59:	89 e5                	mov    %esp,%ebp
  800e5b:	56                   	push   %esi
  800e5c:	53                   	push   %ebx
  800e5d:	8b 75 08             	mov    0x8(%ebp),%esi
  800e60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e63:	8b 55 10             	mov    0x10(%ebp),%edx
  800e66:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800e68:	85 d2                	test   %edx,%edx
  800e6a:	74 21                	je     800e8d <strlcpy+0x35>
  800e6c:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800e70:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800e72:	39 c2                	cmp    %eax,%edx
  800e74:	74 14                	je     800e8a <strlcpy+0x32>
  800e76:	0f b6 19             	movzbl (%ecx),%ebx
  800e79:	84 db                	test   %bl,%bl
  800e7b:	74 0b                	je     800e88 <strlcpy+0x30>
			*dst++ = *src++;
  800e7d:	83 c1 01             	add    $0x1,%ecx
  800e80:	83 c2 01             	add    $0x1,%edx
  800e83:	88 5a ff             	mov    %bl,-0x1(%edx)
  800e86:	eb ea                	jmp    800e72 <strlcpy+0x1a>
  800e88:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800e8a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e8d:	29 f0                	sub    %esi,%eax
}
  800e8f:	5b                   	pop    %ebx
  800e90:	5e                   	pop    %esi
  800e91:	5d                   	pop    %ebp
  800e92:	c3                   	ret    

00800e93 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e93:	55                   	push   %ebp
  800e94:	89 e5                	mov    %esp,%ebp
  800e96:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e99:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800e9c:	0f b6 01             	movzbl (%ecx),%eax
  800e9f:	84 c0                	test   %al,%al
  800ea1:	74 0c                	je     800eaf <strcmp+0x1c>
  800ea3:	3a 02                	cmp    (%edx),%al
  800ea5:	75 08                	jne    800eaf <strcmp+0x1c>
		p++, q++;
  800ea7:	83 c1 01             	add    $0x1,%ecx
  800eaa:	83 c2 01             	add    $0x1,%edx
  800ead:	eb ed                	jmp    800e9c <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800eaf:	0f b6 c0             	movzbl %al,%eax
  800eb2:	0f b6 12             	movzbl (%edx),%edx
  800eb5:	29 d0                	sub    %edx,%eax
}
  800eb7:	5d                   	pop    %ebp
  800eb8:	c3                   	ret    

00800eb9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	53                   	push   %ebx
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec3:	89 c3                	mov    %eax,%ebx
  800ec5:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ec8:	eb 06                	jmp    800ed0 <strncmp+0x17>
		n--, p++, q++;
  800eca:	83 c0 01             	add    $0x1,%eax
  800ecd:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ed0:	39 d8                	cmp    %ebx,%eax
  800ed2:	74 16                	je     800eea <strncmp+0x31>
  800ed4:	0f b6 08             	movzbl (%eax),%ecx
  800ed7:	84 c9                	test   %cl,%cl
  800ed9:	74 04                	je     800edf <strncmp+0x26>
  800edb:	3a 0a                	cmp    (%edx),%cl
  800edd:	74 eb                	je     800eca <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800edf:	0f b6 00             	movzbl (%eax),%eax
  800ee2:	0f b6 12             	movzbl (%edx),%edx
  800ee5:	29 d0                	sub    %edx,%eax
}
  800ee7:	5b                   	pop    %ebx
  800ee8:	5d                   	pop    %ebp
  800ee9:	c3                   	ret    
		return 0;
  800eea:	b8 00 00 00 00       	mov    $0x0,%eax
  800eef:	eb f6                	jmp    800ee7 <strncmp+0x2e>

00800ef1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800efb:	0f b6 10             	movzbl (%eax),%edx
  800efe:	84 d2                	test   %dl,%dl
  800f00:	74 09                	je     800f0b <strchr+0x1a>
		if (*s == c)
  800f02:	38 ca                	cmp    %cl,%dl
  800f04:	74 0a                	je     800f10 <strchr+0x1f>
	for (; *s; s++)
  800f06:	83 c0 01             	add    $0x1,%eax
  800f09:	eb f0                	jmp    800efb <strchr+0xa>
			return (char *) s;
	return 0;
  800f0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f10:	5d                   	pop    %ebp
  800f11:	c3                   	ret    

00800f12 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f12:	55                   	push   %ebp
  800f13:	89 e5                	mov    %esp,%ebp
  800f15:	8b 45 08             	mov    0x8(%ebp),%eax
  800f18:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800f1c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800f1f:	38 ca                	cmp    %cl,%dl
  800f21:	74 09                	je     800f2c <strfind+0x1a>
  800f23:	84 d2                	test   %dl,%dl
  800f25:	74 05                	je     800f2c <strfind+0x1a>
	for (; *s; s++)
  800f27:	83 c0 01             	add    $0x1,%eax
  800f2a:	eb f0                	jmp    800f1c <strfind+0xa>
			break;
	return (char *) s;
}
  800f2c:	5d                   	pop    %ebp
  800f2d:	c3                   	ret    

00800f2e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
  800f31:	57                   	push   %edi
  800f32:	56                   	push   %esi
  800f33:	53                   	push   %ebx
  800f34:	8b 7d 08             	mov    0x8(%ebp),%edi
  800f37:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800f3a:	85 c9                	test   %ecx,%ecx
  800f3c:	74 31                	je     800f6f <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800f3e:	89 f8                	mov    %edi,%eax
  800f40:	09 c8                	or     %ecx,%eax
  800f42:	a8 03                	test   $0x3,%al
  800f44:	75 23                	jne    800f69 <memset+0x3b>
		c &= 0xFF;
  800f46:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800f4a:	89 d3                	mov    %edx,%ebx
  800f4c:	c1 e3 08             	shl    $0x8,%ebx
  800f4f:	89 d0                	mov    %edx,%eax
  800f51:	c1 e0 18             	shl    $0x18,%eax
  800f54:	89 d6                	mov    %edx,%esi
  800f56:	c1 e6 10             	shl    $0x10,%esi
  800f59:	09 f0                	or     %esi,%eax
  800f5b:	09 c2                	or     %eax,%edx
  800f5d:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800f5f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800f62:	89 d0                	mov    %edx,%eax
  800f64:	fc                   	cld    
  800f65:	f3 ab                	rep stos %eax,%es:(%edi)
  800f67:	eb 06                	jmp    800f6f <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800f69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6c:	fc                   	cld    
  800f6d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800f6f:	89 f8                	mov    %edi,%eax
  800f71:	5b                   	pop    %ebx
  800f72:	5e                   	pop    %esi
  800f73:	5f                   	pop    %edi
  800f74:	5d                   	pop    %ebp
  800f75:	c3                   	ret    

00800f76 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
  800f79:	57                   	push   %edi
  800f7a:	56                   	push   %esi
  800f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f81:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f84:	39 c6                	cmp    %eax,%esi
  800f86:	73 32                	jae    800fba <memmove+0x44>
  800f88:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800f8b:	39 c2                	cmp    %eax,%edx
  800f8d:	76 2b                	jbe    800fba <memmove+0x44>
		s += n;
		d += n;
  800f8f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f92:	89 fe                	mov    %edi,%esi
  800f94:	09 ce                	or     %ecx,%esi
  800f96:	09 d6                	or     %edx,%esi
  800f98:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800f9e:	75 0e                	jne    800fae <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800fa0:	83 ef 04             	sub    $0x4,%edi
  800fa3:	8d 72 fc             	lea    -0x4(%edx),%esi
  800fa6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800fa9:	fd                   	std    
  800faa:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800fac:	eb 09                	jmp    800fb7 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800fae:	83 ef 01             	sub    $0x1,%edi
  800fb1:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800fb4:	fd                   	std    
  800fb5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800fb7:	fc                   	cld    
  800fb8:	eb 1a                	jmp    800fd4 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800fba:	89 c2                	mov    %eax,%edx
  800fbc:	09 ca                	or     %ecx,%edx
  800fbe:	09 f2                	or     %esi,%edx
  800fc0:	f6 c2 03             	test   $0x3,%dl
  800fc3:	75 0a                	jne    800fcf <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800fc5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800fc8:	89 c7                	mov    %eax,%edi
  800fca:	fc                   	cld    
  800fcb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800fcd:	eb 05                	jmp    800fd4 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800fcf:	89 c7                	mov    %eax,%edi
  800fd1:	fc                   	cld    
  800fd2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800fd4:	5e                   	pop    %esi
  800fd5:	5f                   	pop    %edi
  800fd6:	5d                   	pop    %ebp
  800fd7:	c3                   	ret    

00800fd8 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800fd8:	55                   	push   %ebp
  800fd9:	89 e5                	mov    %esp,%ebp
  800fdb:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800fde:	ff 75 10             	pushl  0x10(%ebp)
  800fe1:	ff 75 0c             	pushl  0xc(%ebp)
  800fe4:	ff 75 08             	pushl  0x8(%ebp)
  800fe7:	e8 8a ff ff ff       	call   800f76 <memmove>
}
  800fec:	c9                   	leave  
  800fed:	c3                   	ret    

00800fee <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800fee:	55                   	push   %ebp
  800fef:	89 e5                	mov    %esp,%ebp
  800ff1:	56                   	push   %esi
  800ff2:	53                   	push   %ebx
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ff9:	89 c6                	mov    %eax,%esi
  800ffb:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ffe:	39 f0                	cmp    %esi,%eax
  801000:	74 1c                	je     80101e <memcmp+0x30>
		if (*s1 != *s2)
  801002:	0f b6 08             	movzbl (%eax),%ecx
  801005:	0f b6 1a             	movzbl (%edx),%ebx
  801008:	38 d9                	cmp    %bl,%cl
  80100a:	75 08                	jne    801014 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  80100c:	83 c0 01             	add    $0x1,%eax
  80100f:	83 c2 01             	add    $0x1,%edx
  801012:	eb ea                	jmp    800ffe <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801014:	0f b6 c1             	movzbl %cl,%eax
  801017:	0f b6 db             	movzbl %bl,%ebx
  80101a:	29 d8                	sub    %ebx,%eax
  80101c:	eb 05                	jmp    801023 <memcmp+0x35>
	}

	return 0;
  80101e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801023:	5b                   	pop    %ebx
  801024:	5e                   	pop    %esi
  801025:	5d                   	pop    %ebp
  801026:	c3                   	ret    

00801027 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801027:	55                   	push   %ebp
  801028:	89 e5                	mov    %esp,%ebp
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801030:	89 c2                	mov    %eax,%edx
  801032:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801035:	39 d0                	cmp    %edx,%eax
  801037:	73 09                	jae    801042 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801039:	38 08                	cmp    %cl,(%eax)
  80103b:	74 05                	je     801042 <memfind+0x1b>
	for (; s < ends; s++)
  80103d:	83 c0 01             	add    $0x1,%eax
  801040:	eb f3                	jmp    801035 <memfind+0xe>
			break;
	return (void *) s;
}
  801042:	5d                   	pop    %ebp
  801043:	c3                   	ret    

00801044 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801044:	55                   	push   %ebp
  801045:	89 e5                	mov    %esp,%ebp
  801047:	57                   	push   %edi
  801048:	56                   	push   %esi
  801049:	53                   	push   %ebx
  80104a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80104d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801050:	eb 03                	jmp    801055 <strtol+0x11>
		s++;
  801052:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801055:	0f b6 01             	movzbl (%ecx),%eax
  801058:	3c 20                	cmp    $0x20,%al
  80105a:	74 f6                	je     801052 <strtol+0xe>
  80105c:	3c 09                	cmp    $0x9,%al
  80105e:	74 f2                	je     801052 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801060:	3c 2b                	cmp    $0x2b,%al
  801062:	74 2a                	je     80108e <strtol+0x4a>
	int neg = 0;
  801064:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801069:	3c 2d                	cmp    $0x2d,%al
  80106b:	74 2b                	je     801098 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80106d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801073:	75 0f                	jne    801084 <strtol+0x40>
  801075:	80 39 30             	cmpb   $0x30,(%ecx)
  801078:	74 28                	je     8010a2 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  80107a:	85 db                	test   %ebx,%ebx
  80107c:	b8 0a 00 00 00       	mov    $0xa,%eax
  801081:	0f 44 d8             	cmove  %eax,%ebx
  801084:	b8 00 00 00 00       	mov    $0x0,%eax
  801089:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80108c:	eb 50                	jmp    8010de <strtol+0x9a>
		s++;
  80108e:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801091:	bf 00 00 00 00       	mov    $0x0,%edi
  801096:	eb d5                	jmp    80106d <strtol+0x29>
		s++, neg = 1;
  801098:	83 c1 01             	add    $0x1,%ecx
  80109b:	bf 01 00 00 00       	mov    $0x1,%edi
  8010a0:	eb cb                	jmp    80106d <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010a2:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8010a6:	74 0e                	je     8010b6 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  8010a8:	85 db                	test   %ebx,%ebx
  8010aa:	75 d8                	jne    801084 <strtol+0x40>
		s++, base = 8;
  8010ac:	83 c1 01             	add    $0x1,%ecx
  8010af:	bb 08 00 00 00       	mov    $0x8,%ebx
  8010b4:	eb ce                	jmp    801084 <strtol+0x40>
		s += 2, base = 16;
  8010b6:	83 c1 02             	add    $0x2,%ecx
  8010b9:	bb 10 00 00 00       	mov    $0x10,%ebx
  8010be:	eb c4                	jmp    801084 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  8010c0:	8d 72 9f             	lea    -0x61(%edx),%esi
  8010c3:	89 f3                	mov    %esi,%ebx
  8010c5:	80 fb 19             	cmp    $0x19,%bl
  8010c8:	77 29                	ja     8010f3 <strtol+0xaf>
			dig = *s - 'a' + 10;
  8010ca:	0f be d2             	movsbl %dl,%edx
  8010cd:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8010d0:	3b 55 10             	cmp    0x10(%ebp),%edx
  8010d3:	7d 30                	jge    801105 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  8010d5:	83 c1 01             	add    $0x1,%ecx
  8010d8:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010dc:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8010de:	0f b6 11             	movzbl (%ecx),%edx
  8010e1:	8d 72 d0             	lea    -0x30(%edx),%esi
  8010e4:	89 f3                	mov    %esi,%ebx
  8010e6:	80 fb 09             	cmp    $0x9,%bl
  8010e9:	77 d5                	ja     8010c0 <strtol+0x7c>
			dig = *s - '0';
  8010eb:	0f be d2             	movsbl %dl,%edx
  8010ee:	83 ea 30             	sub    $0x30,%edx
  8010f1:	eb dd                	jmp    8010d0 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  8010f3:	8d 72 bf             	lea    -0x41(%edx),%esi
  8010f6:	89 f3                	mov    %esi,%ebx
  8010f8:	80 fb 19             	cmp    $0x19,%bl
  8010fb:	77 08                	ja     801105 <strtol+0xc1>
			dig = *s - 'A' + 10;
  8010fd:	0f be d2             	movsbl %dl,%edx
  801100:	83 ea 37             	sub    $0x37,%edx
  801103:	eb cb                	jmp    8010d0 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  801105:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801109:	74 05                	je     801110 <strtol+0xcc>
		*endptr = (char *) s;
  80110b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80110e:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801110:	89 c2                	mov    %eax,%edx
  801112:	f7 da                	neg    %edx
  801114:	85 ff                	test   %edi,%edi
  801116:	0f 45 c2             	cmovne %edx,%eax
}
  801119:	5b                   	pop    %ebx
  80111a:	5e                   	pop    %esi
  80111b:	5f                   	pop    %edi
  80111c:	5d                   	pop    %ebp
  80111d:	c3                   	ret    

0080111e <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80111e:	55                   	push   %ebp
  80111f:	89 e5                	mov    %esp,%ebp
  801121:	57                   	push   %edi
  801122:	56                   	push   %esi
  801123:	53                   	push   %ebx
	asm volatile("int %1\n"
  801124:	b8 00 00 00 00       	mov    $0x0,%eax
  801129:	8b 55 08             	mov    0x8(%ebp),%edx
  80112c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80112f:	89 c3                	mov    %eax,%ebx
  801131:	89 c7                	mov    %eax,%edi
  801133:	89 c6                	mov    %eax,%esi
  801135:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801137:	5b                   	pop    %ebx
  801138:	5e                   	pop    %esi
  801139:	5f                   	pop    %edi
  80113a:	5d                   	pop    %ebp
  80113b:	c3                   	ret    

0080113c <sys_cgetc>:

int
sys_cgetc(void)
{
  80113c:	55                   	push   %ebp
  80113d:	89 e5                	mov    %esp,%ebp
  80113f:	57                   	push   %edi
  801140:	56                   	push   %esi
  801141:	53                   	push   %ebx
	asm volatile("int %1\n"
  801142:	ba 00 00 00 00       	mov    $0x0,%edx
  801147:	b8 01 00 00 00       	mov    $0x1,%eax
  80114c:	89 d1                	mov    %edx,%ecx
  80114e:	89 d3                	mov    %edx,%ebx
  801150:	89 d7                	mov    %edx,%edi
  801152:	89 d6                	mov    %edx,%esi
  801154:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801156:	5b                   	pop    %ebx
  801157:	5e                   	pop    %esi
  801158:	5f                   	pop    %edi
  801159:	5d                   	pop    %ebp
  80115a:	c3                   	ret    

0080115b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80115b:	55                   	push   %ebp
  80115c:	89 e5                	mov    %esp,%ebp
  80115e:	57                   	push   %edi
  80115f:	56                   	push   %esi
  801160:	53                   	push   %ebx
  801161:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801164:	b9 00 00 00 00       	mov    $0x0,%ecx
  801169:	8b 55 08             	mov    0x8(%ebp),%edx
  80116c:	b8 03 00 00 00       	mov    $0x3,%eax
  801171:	89 cb                	mov    %ecx,%ebx
  801173:	89 cf                	mov    %ecx,%edi
  801175:	89 ce                	mov    %ecx,%esi
  801177:	cd 30                	int    $0x30
	if(check && ret > 0)
  801179:	85 c0                	test   %eax,%eax
  80117b:	7f 08                	jg     801185 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80117d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801180:	5b                   	pop    %ebx
  801181:	5e                   	pop    %esi
  801182:	5f                   	pop    %edi
  801183:	5d                   	pop    %ebp
  801184:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801185:	83 ec 0c             	sub    $0xc,%esp
  801188:	50                   	push   %eax
  801189:	6a 03                	push   $0x3
  80118b:	68 68 39 80 00       	push   $0x803968
  801190:	6a 43                	push   $0x43
  801192:	68 85 39 80 00       	push   $0x803985
  801197:	e8 f7 f3 ff ff       	call   800593 <_panic>

0080119c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80119c:	55                   	push   %ebp
  80119d:	89 e5                	mov    %esp,%ebp
  80119f:	57                   	push   %edi
  8011a0:	56                   	push   %esi
  8011a1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8011a7:	b8 02 00 00 00       	mov    $0x2,%eax
  8011ac:	89 d1                	mov    %edx,%ecx
  8011ae:	89 d3                	mov    %edx,%ebx
  8011b0:	89 d7                	mov    %edx,%edi
  8011b2:	89 d6                	mov    %edx,%esi
  8011b4:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8011b6:	5b                   	pop    %ebx
  8011b7:	5e                   	pop    %esi
  8011b8:	5f                   	pop    %edi
  8011b9:	5d                   	pop    %ebp
  8011ba:	c3                   	ret    

008011bb <sys_yield>:

void
sys_yield(void)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
  8011be:	57                   	push   %edi
  8011bf:	56                   	push   %esi
  8011c0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8011c6:	b8 0b 00 00 00       	mov    $0xb,%eax
  8011cb:	89 d1                	mov    %edx,%ecx
  8011cd:	89 d3                	mov    %edx,%ebx
  8011cf:	89 d7                	mov    %edx,%edi
  8011d1:	89 d6                	mov    %edx,%esi
  8011d3:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8011d5:	5b                   	pop    %ebx
  8011d6:	5e                   	pop    %esi
  8011d7:	5f                   	pop    %edi
  8011d8:	5d                   	pop    %ebp
  8011d9:	c3                   	ret    

008011da <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8011da:	55                   	push   %ebp
  8011db:	89 e5                	mov    %esp,%ebp
  8011dd:	57                   	push   %edi
  8011de:	56                   	push   %esi
  8011df:	53                   	push   %ebx
  8011e0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011e3:	be 00 00 00 00       	mov    $0x0,%esi
  8011e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ee:	b8 04 00 00 00       	mov    $0x4,%eax
  8011f3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011f6:	89 f7                	mov    %esi,%edi
  8011f8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011fa:	85 c0                	test   %eax,%eax
  8011fc:	7f 08                	jg     801206 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8011fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801201:	5b                   	pop    %ebx
  801202:	5e                   	pop    %esi
  801203:	5f                   	pop    %edi
  801204:	5d                   	pop    %ebp
  801205:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801206:	83 ec 0c             	sub    $0xc,%esp
  801209:	50                   	push   %eax
  80120a:	6a 04                	push   $0x4
  80120c:	68 68 39 80 00       	push   $0x803968
  801211:	6a 43                	push   $0x43
  801213:	68 85 39 80 00       	push   $0x803985
  801218:	e8 76 f3 ff ff       	call   800593 <_panic>

0080121d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80121d:	55                   	push   %ebp
  80121e:	89 e5                	mov    %esp,%ebp
  801220:	57                   	push   %edi
  801221:	56                   	push   %esi
  801222:	53                   	push   %ebx
  801223:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801226:	8b 55 08             	mov    0x8(%ebp),%edx
  801229:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80122c:	b8 05 00 00 00       	mov    $0x5,%eax
  801231:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801234:	8b 7d 14             	mov    0x14(%ebp),%edi
  801237:	8b 75 18             	mov    0x18(%ebp),%esi
  80123a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80123c:	85 c0                	test   %eax,%eax
  80123e:	7f 08                	jg     801248 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801240:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801243:	5b                   	pop    %ebx
  801244:	5e                   	pop    %esi
  801245:	5f                   	pop    %edi
  801246:	5d                   	pop    %ebp
  801247:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801248:	83 ec 0c             	sub    $0xc,%esp
  80124b:	50                   	push   %eax
  80124c:	6a 05                	push   $0x5
  80124e:	68 68 39 80 00       	push   $0x803968
  801253:	6a 43                	push   $0x43
  801255:	68 85 39 80 00       	push   $0x803985
  80125a:	e8 34 f3 ff ff       	call   800593 <_panic>

0080125f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80125f:	55                   	push   %ebp
  801260:	89 e5                	mov    %esp,%ebp
  801262:	57                   	push   %edi
  801263:	56                   	push   %esi
  801264:	53                   	push   %ebx
  801265:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801268:	bb 00 00 00 00       	mov    $0x0,%ebx
  80126d:	8b 55 08             	mov    0x8(%ebp),%edx
  801270:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801273:	b8 06 00 00 00       	mov    $0x6,%eax
  801278:	89 df                	mov    %ebx,%edi
  80127a:	89 de                	mov    %ebx,%esi
  80127c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80127e:	85 c0                	test   %eax,%eax
  801280:	7f 08                	jg     80128a <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801282:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801285:	5b                   	pop    %ebx
  801286:	5e                   	pop    %esi
  801287:	5f                   	pop    %edi
  801288:	5d                   	pop    %ebp
  801289:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80128a:	83 ec 0c             	sub    $0xc,%esp
  80128d:	50                   	push   %eax
  80128e:	6a 06                	push   $0x6
  801290:	68 68 39 80 00       	push   $0x803968
  801295:	6a 43                	push   $0x43
  801297:	68 85 39 80 00       	push   $0x803985
  80129c:	e8 f2 f2 ff ff       	call   800593 <_panic>

008012a1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8012a1:	55                   	push   %ebp
  8012a2:	89 e5                	mov    %esp,%ebp
  8012a4:	57                   	push   %edi
  8012a5:	56                   	push   %esi
  8012a6:	53                   	push   %ebx
  8012a7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012aa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012af:	8b 55 08             	mov    0x8(%ebp),%edx
  8012b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012b5:	b8 08 00 00 00       	mov    $0x8,%eax
  8012ba:	89 df                	mov    %ebx,%edi
  8012bc:	89 de                	mov    %ebx,%esi
  8012be:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012c0:	85 c0                	test   %eax,%eax
  8012c2:	7f 08                	jg     8012cc <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8012c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012c7:	5b                   	pop    %ebx
  8012c8:	5e                   	pop    %esi
  8012c9:	5f                   	pop    %edi
  8012ca:	5d                   	pop    %ebp
  8012cb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012cc:	83 ec 0c             	sub    $0xc,%esp
  8012cf:	50                   	push   %eax
  8012d0:	6a 08                	push   $0x8
  8012d2:	68 68 39 80 00       	push   $0x803968
  8012d7:	6a 43                	push   $0x43
  8012d9:	68 85 39 80 00       	push   $0x803985
  8012de:	e8 b0 f2 ff ff       	call   800593 <_panic>

008012e3 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8012e3:	55                   	push   %ebp
  8012e4:	89 e5                	mov    %esp,%ebp
  8012e6:	57                   	push   %edi
  8012e7:	56                   	push   %esi
  8012e8:	53                   	push   %ebx
  8012e9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012f7:	b8 09 00 00 00       	mov    $0x9,%eax
  8012fc:	89 df                	mov    %ebx,%edi
  8012fe:	89 de                	mov    %ebx,%esi
  801300:	cd 30                	int    $0x30
	if(check && ret > 0)
  801302:	85 c0                	test   %eax,%eax
  801304:	7f 08                	jg     80130e <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801306:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801309:	5b                   	pop    %ebx
  80130a:	5e                   	pop    %esi
  80130b:	5f                   	pop    %edi
  80130c:	5d                   	pop    %ebp
  80130d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80130e:	83 ec 0c             	sub    $0xc,%esp
  801311:	50                   	push   %eax
  801312:	6a 09                	push   $0x9
  801314:	68 68 39 80 00       	push   $0x803968
  801319:	6a 43                	push   $0x43
  80131b:	68 85 39 80 00       	push   $0x803985
  801320:	e8 6e f2 ff ff       	call   800593 <_panic>

00801325 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801325:	55                   	push   %ebp
  801326:	89 e5                	mov    %esp,%ebp
  801328:	57                   	push   %edi
  801329:	56                   	push   %esi
  80132a:	53                   	push   %ebx
  80132b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80132e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801333:	8b 55 08             	mov    0x8(%ebp),%edx
  801336:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801339:	b8 0a 00 00 00       	mov    $0xa,%eax
  80133e:	89 df                	mov    %ebx,%edi
  801340:	89 de                	mov    %ebx,%esi
  801342:	cd 30                	int    $0x30
	if(check && ret > 0)
  801344:	85 c0                	test   %eax,%eax
  801346:	7f 08                	jg     801350 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801348:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80134b:	5b                   	pop    %ebx
  80134c:	5e                   	pop    %esi
  80134d:	5f                   	pop    %edi
  80134e:	5d                   	pop    %ebp
  80134f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801350:	83 ec 0c             	sub    $0xc,%esp
  801353:	50                   	push   %eax
  801354:	6a 0a                	push   $0xa
  801356:	68 68 39 80 00       	push   $0x803968
  80135b:	6a 43                	push   $0x43
  80135d:	68 85 39 80 00       	push   $0x803985
  801362:	e8 2c f2 ff ff       	call   800593 <_panic>

00801367 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801367:	55                   	push   %ebp
  801368:	89 e5                	mov    %esp,%ebp
  80136a:	57                   	push   %edi
  80136b:	56                   	push   %esi
  80136c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80136d:	8b 55 08             	mov    0x8(%ebp),%edx
  801370:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801373:	b8 0c 00 00 00       	mov    $0xc,%eax
  801378:	be 00 00 00 00       	mov    $0x0,%esi
  80137d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801380:	8b 7d 14             	mov    0x14(%ebp),%edi
  801383:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801385:	5b                   	pop    %ebx
  801386:	5e                   	pop    %esi
  801387:	5f                   	pop    %edi
  801388:	5d                   	pop    %ebp
  801389:	c3                   	ret    

0080138a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80138a:	55                   	push   %ebp
  80138b:	89 e5                	mov    %esp,%ebp
  80138d:	57                   	push   %edi
  80138e:	56                   	push   %esi
  80138f:	53                   	push   %ebx
  801390:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801393:	b9 00 00 00 00       	mov    $0x0,%ecx
  801398:	8b 55 08             	mov    0x8(%ebp),%edx
  80139b:	b8 0d 00 00 00       	mov    $0xd,%eax
  8013a0:	89 cb                	mov    %ecx,%ebx
  8013a2:	89 cf                	mov    %ecx,%edi
  8013a4:	89 ce                	mov    %ecx,%esi
  8013a6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013a8:	85 c0                	test   %eax,%eax
  8013aa:	7f 08                	jg     8013b4 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8013ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013af:	5b                   	pop    %ebx
  8013b0:	5e                   	pop    %esi
  8013b1:	5f                   	pop    %edi
  8013b2:	5d                   	pop    %ebp
  8013b3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013b4:	83 ec 0c             	sub    $0xc,%esp
  8013b7:	50                   	push   %eax
  8013b8:	6a 0d                	push   $0xd
  8013ba:	68 68 39 80 00       	push   $0x803968
  8013bf:	6a 43                	push   $0x43
  8013c1:	68 85 39 80 00       	push   $0x803985
  8013c6:	e8 c8 f1 ff ff       	call   800593 <_panic>

008013cb <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8013cb:	55                   	push   %ebp
  8013cc:	89 e5                	mov    %esp,%ebp
  8013ce:	57                   	push   %edi
  8013cf:	56                   	push   %esi
  8013d0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013d1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8013d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013dc:	b8 0e 00 00 00       	mov    $0xe,%eax
  8013e1:	89 df                	mov    %ebx,%edi
  8013e3:	89 de                	mov    %ebx,%esi
  8013e5:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8013e7:	5b                   	pop    %ebx
  8013e8:	5e                   	pop    %esi
  8013e9:	5f                   	pop    %edi
  8013ea:	5d                   	pop    %ebp
  8013eb:	c3                   	ret    

008013ec <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8013ec:	55                   	push   %ebp
  8013ed:	89 e5                	mov    %esp,%ebp
  8013ef:	57                   	push   %edi
  8013f0:	56                   	push   %esi
  8013f1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8013f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8013fa:	b8 0f 00 00 00       	mov    $0xf,%eax
  8013ff:	89 cb                	mov    %ecx,%ebx
  801401:	89 cf                	mov    %ecx,%edi
  801403:	89 ce                	mov    %ecx,%esi
  801405:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801407:	5b                   	pop    %ebx
  801408:	5e                   	pop    %esi
  801409:	5f                   	pop    %edi
  80140a:	5d                   	pop    %ebp
  80140b:	c3                   	ret    

0080140c <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	57                   	push   %edi
  801410:	56                   	push   %esi
  801411:	53                   	push   %ebx
	asm volatile("int %1\n"
  801412:	ba 00 00 00 00       	mov    $0x0,%edx
  801417:	b8 10 00 00 00       	mov    $0x10,%eax
  80141c:	89 d1                	mov    %edx,%ecx
  80141e:	89 d3                	mov    %edx,%ebx
  801420:	89 d7                	mov    %edx,%edi
  801422:	89 d6                	mov    %edx,%esi
  801424:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801426:	5b                   	pop    %ebx
  801427:	5e                   	pop    %esi
  801428:	5f                   	pop    %edi
  801429:	5d                   	pop    %ebp
  80142a:	c3                   	ret    

0080142b <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  80142b:	55                   	push   %ebp
  80142c:	89 e5                	mov    %esp,%ebp
  80142e:	57                   	push   %edi
  80142f:	56                   	push   %esi
  801430:	53                   	push   %ebx
	asm volatile("int %1\n"
  801431:	bb 00 00 00 00       	mov    $0x0,%ebx
  801436:	8b 55 08             	mov    0x8(%ebp),%edx
  801439:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80143c:	b8 11 00 00 00       	mov    $0x11,%eax
  801441:	89 df                	mov    %ebx,%edi
  801443:	89 de                	mov    %ebx,%esi
  801445:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801447:	5b                   	pop    %ebx
  801448:	5e                   	pop    %esi
  801449:	5f                   	pop    %edi
  80144a:	5d                   	pop    %ebp
  80144b:	c3                   	ret    

0080144c <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  80144c:	55                   	push   %ebp
  80144d:	89 e5                	mov    %esp,%ebp
  80144f:	57                   	push   %edi
  801450:	56                   	push   %esi
  801451:	53                   	push   %ebx
	asm volatile("int %1\n"
  801452:	bb 00 00 00 00       	mov    $0x0,%ebx
  801457:	8b 55 08             	mov    0x8(%ebp),%edx
  80145a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80145d:	b8 12 00 00 00       	mov    $0x12,%eax
  801462:	89 df                	mov    %ebx,%edi
  801464:	89 de                	mov    %ebx,%esi
  801466:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801468:	5b                   	pop    %ebx
  801469:	5e                   	pop    %esi
  80146a:	5f                   	pop    %edi
  80146b:	5d                   	pop    %ebp
  80146c:	c3                   	ret    

0080146d <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80146d:	55                   	push   %ebp
  80146e:	89 e5                	mov    %esp,%ebp
  801470:	57                   	push   %edi
  801471:	56                   	push   %esi
  801472:	53                   	push   %ebx
  801473:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801476:	bb 00 00 00 00       	mov    $0x0,%ebx
  80147b:	8b 55 08             	mov    0x8(%ebp),%edx
  80147e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801481:	b8 13 00 00 00       	mov    $0x13,%eax
  801486:	89 df                	mov    %ebx,%edi
  801488:	89 de                	mov    %ebx,%esi
  80148a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80148c:	85 c0                	test   %eax,%eax
  80148e:	7f 08                	jg     801498 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801490:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801493:	5b                   	pop    %ebx
  801494:	5e                   	pop    %esi
  801495:	5f                   	pop    %edi
  801496:	5d                   	pop    %ebp
  801497:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801498:	83 ec 0c             	sub    $0xc,%esp
  80149b:	50                   	push   %eax
  80149c:	6a 13                	push   $0x13
  80149e:	68 68 39 80 00       	push   $0x803968
  8014a3:	6a 43                	push   $0x43
  8014a5:	68 85 39 80 00       	push   $0x803985
  8014aa:	e8 e4 f0 ff ff       	call   800593 <_panic>

008014af <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8014af:	55                   	push   %ebp
  8014b0:	89 e5                	mov    %esp,%ebp
  8014b2:	53                   	push   %ebx
  8014b3:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  8014b6:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8014bd:	f6 c5 04             	test   $0x4,%ch
  8014c0:	75 45                	jne    801507 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8014c2:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8014c9:	83 e1 07             	and    $0x7,%ecx
  8014cc:	83 f9 07             	cmp    $0x7,%ecx
  8014cf:	74 6f                	je     801540 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8014d1:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8014d8:	81 e1 05 08 00 00    	and    $0x805,%ecx
  8014de:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  8014e4:	0f 84 b6 00 00 00    	je     8015a0 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8014ea:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8014f1:	83 e1 05             	and    $0x5,%ecx
  8014f4:	83 f9 05             	cmp    $0x5,%ecx
  8014f7:	0f 84 d7 00 00 00    	je     8015d4 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8014fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801502:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801505:	c9                   	leave  
  801506:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801507:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80150e:	c1 e2 0c             	shl    $0xc,%edx
  801511:	83 ec 0c             	sub    $0xc,%esp
  801514:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80151a:	51                   	push   %ecx
  80151b:	52                   	push   %edx
  80151c:	50                   	push   %eax
  80151d:	52                   	push   %edx
  80151e:	6a 00                	push   $0x0
  801520:	e8 f8 fc ff ff       	call   80121d <sys_page_map>
		if(r < 0)
  801525:	83 c4 20             	add    $0x20,%esp
  801528:	85 c0                	test   %eax,%eax
  80152a:	79 d1                	jns    8014fd <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80152c:	83 ec 04             	sub    $0x4,%esp
  80152f:	68 93 39 80 00       	push   $0x803993
  801534:	6a 54                	push   $0x54
  801536:	68 a9 39 80 00       	push   $0x8039a9
  80153b:	e8 53 f0 ff ff       	call   800593 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801540:	89 d3                	mov    %edx,%ebx
  801542:	c1 e3 0c             	shl    $0xc,%ebx
  801545:	83 ec 0c             	sub    $0xc,%esp
  801548:	68 05 08 00 00       	push   $0x805
  80154d:	53                   	push   %ebx
  80154e:	50                   	push   %eax
  80154f:	53                   	push   %ebx
  801550:	6a 00                	push   $0x0
  801552:	e8 c6 fc ff ff       	call   80121d <sys_page_map>
		if(r < 0)
  801557:	83 c4 20             	add    $0x20,%esp
  80155a:	85 c0                	test   %eax,%eax
  80155c:	78 2e                	js     80158c <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  80155e:	83 ec 0c             	sub    $0xc,%esp
  801561:	68 05 08 00 00       	push   $0x805
  801566:	53                   	push   %ebx
  801567:	6a 00                	push   $0x0
  801569:	53                   	push   %ebx
  80156a:	6a 00                	push   $0x0
  80156c:	e8 ac fc ff ff       	call   80121d <sys_page_map>
		if(r < 0)
  801571:	83 c4 20             	add    $0x20,%esp
  801574:	85 c0                	test   %eax,%eax
  801576:	79 85                	jns    8014fd <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801578:	83 ec 04             	sub    $0x4,%esp
  80157b:	68 93 39 80 00       	push   $0x803993
  801580:	6a 5f                	push   $0x5f
  801582:	68 a9 39 80 00       	push   $0x8039a9
  801587:	e8 07 f0 ff ff       	call   800593 <_panic>
			panic("sys_page_map() panic\n");
  80158c:	83 ec 04             	sub    $0x4,%esp
  80158f:	68 93 39 80 00       	push   $0x803993
  801594:	6a 5b                	push   $0x5b
  801596:	68 a9 39 80 00       	push   $0x8039a9
  80159b:	e8 f3 ef ff ff       	call   800593 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8015a0:	c1 e2 0c             	shl    $0xc,%edx
  8015a3:	83 ec 0c             	sub    $0xc,%esp
  8015a6:	68 05 08 00 00       	push   $0x805
  8015ab:	52                   	push   %edx
  8015ac:	50                   	push   %eax
  8015ad:	52                   	push   %edx
  8015ae:	6a 00                	push   $0x0
  8015b0:	e8 68 fc ff ff       	call   80121d <sys_page_map>
		if(r < 0)
  8015b5:	83 c4 20             	add    $0x20,%esp
  8015b8:	85 c0                	test   %eax,%eax
  8015ba:	0f 89 3d ff ff ff    	jns    8014fd <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8015c0:	83 ec 04             	sub    $0x4,%esp
  8015c3:	68 93 39 80 00       	push   $0x803993
  8015c8:	6a 66                	push   $0x66
  8015ca:	68 a9 39 80 00       	push   $0x8039a9
  8015cf:	e8 bf ef ff ff       	call   800593 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8015d4:	c1 e2 0c             	shl    $0xc,%edx
  8015d7:	83 ec 0c             	sub    $0xc,%esp
  8015da:	6a 05                	push   $0x5
  8015dc:	52                   	push   %edx
  8015dd:	50                   	push   %eax
  8015de:	52                   	push   %edx
  8015df:	6a 00                	push   $0x0
  8015e1:	e8 37 fc ff ff       	call   80121d <sys_page_map>
		if(r < 0)
  8015e6:	83 c4 20             	add    $0x20,%esp
  8015e9:	85 c0                	test   %eax,%eax
  8015eb:	0f 89 0c ff ff ff    	jns    8014fd <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8015f1:	83 ec 04             	sub    $0x4,%esp
  8015f4:	68 93 39 80 00       	push   $0x803993
  8015f9:	6a 6d                	push   $0x6d
  8015fb:	68 a9 39 80 00       	push   $0x8039a9
  801600:	e8 8e ef ff ff       	call   800593 <_panic>

00801605 <pgfault>:
{
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
  801608:	53                   	push   %ebx
  801609:	83 ec 04             	sub    $0x4,%esp
  80160c:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80160f:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801611:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801615:	0f 84 99 00 00 00    	je     8016b4 <pgfault+0xaf>
  80161b:	89 c2                	mov    %eax,%edx
  80161d:	c1 ea 16             	shr    $0x16,%edx
  801620:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801627:	f6 c2 01             	test   $0x1,%dl
  80162a:	0f 84 84 00 00 00    	je     8016b4 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801630:	89 c2                	mov    %eax,%edx
  801632:	c1 ea 0c             	shr    $0xc,%edx
  801635:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80163c:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801642:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801648:	75 6a                	jne    8016b4 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  80164a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80164f:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801651:	83 ec 04             	sub    $0x4,%esp
  801654:	6a 07                	push   $0x7
  801656:	68 00 f0 7f 00       	push   $0x7ff000
  80165b:	6a 00                	push   $0x0
  80165d:	e8 78 fb ff ff       	call   8011da <sys_page_alloc>
	if(ret < 0)
  801662:	83 c4 10             	add    $0x10,%esp
  801665:	85 c0                	test   %eax,%eax
  801667:	78 5f                	js     8016c8 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801669:	83 ec 04             	sub    $0x4,%esp
  80166c:	68 00 10 00 00       	push   $0x1000
  801671:	53                   	push   %ebx
  801672:	68 00 f0 7f 00       	push   $0x7ff000
  801677:	e8 5c f9 ff ff       	call   800fd8 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  80167c:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801683:	53                   	push   %ebx
  801684:	6a 00                	push   $0x0
  801686:	68 00 f0 7f 00       	push   $0x7ff000
  80168b:	6a 00                	push   $0x0
  80168d:	e8 8b fb ff ff       	call   80121d <sys_page_map>
	if(ret < 0)
  801692:	83 c4 20             	add    $0x20,%esp
  801695:	85 c0                	test   %eax,%eax
  801697:	78 43                	js     8016dc <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801699:	83 ec 08             	sub    $0x8,%esp
  80169c:	68 00 f0 7f 00       	push   $0x7ff000
  8016a1:	6a 00                	push   $0x0
  8016a3:	e8 b7 fb ff ff       	call   80125f <sys_page_unmap>
	if(ret < 0)
  8016a8:	83 c4 10             	add    $0x10,%esp
  8016ab:	85 c0                	test   %eax,%eax
  8016ad:	78 41                	js     8016f0 <pgfault+0xeb>
}
  8016af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016b2:	c9                   	leave  
  8016b3:	c3                   	ret    
		panic("panic at pgfault()\n");
  8016b4:	83 ec 04             	sub    $0x4,%esp
  8016b7:	68 b4 39 80 00       	push   $0x8039b4
  8016bc:	6a 26                	push   $0x26
  8016be:	68 a9 39 80 00       	push   $0x8039a9
  8016c3:	e8 cb ee ff ff       	call   800593 <_panic>
		panic("panic in sys_page_alloc()\n");
  8016c8:	83 ec 04             	sub    $0x4,%esp
  8016cb:	68 c8 39 80 00       	push   $0x8039c8
  8016d0:	6a 31                	push   $0x31
  8016d2:	68 a9 39 80 00       	push   $0x8039a9
  8016d7:	e8 b7 ee ff ff       	call   800593 <_panic>
		panic("panic in sys_page_map()\n");
  8016dc:	83 ec 04             	sub    $0x4,%esp
  8016df:	68 e3 39 80 00       	push   $0x8039e3
  8016e4:	6a 36                	push   $0x36
  8016e6:	68 a9 39 80 00       	push   $0x8039a9
  8016eb:	e8 a3 ee ff ff       	call   800593 <_panic>
		panic("panic in sys_page_unmap()\n");
  8016f0:	83 ec 04             	sub    $0x4,%esp
  8016f3:	68 fc 39 80 00       	push   $0x8039fc
  8016f8:	6a 39                	push   $0x39
  8016fa:	68 a9 39 80 00       	push   $0x8039a9
  8016ff:	e8 8f ee ff ff       	call   800593 <_panic>

00801704 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801704:	55                   	push   %ebp
  801705:	89 e5                	mov    %esp,%ebp
  801707:	57                   	push   %edi
  801708:	56                   	push   %esi
  801709:	53                   	push   %ebx
  80170a:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  80170d:	68 05 16 80 00       	push   $0x801605
  801712:	e8 cb 18 00 00       	call   802fe2 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801717:	b8 07 00 00 00       	mov    $0x7,%eax
  80171c:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80171e:	83 c4 10             	add    $0x10,%esp
  801721:	85 c0                	test   %eax,%eax
  801723:	78 27                	js     80174c <fork+0x48>
  801725:	89 c6                	mov    %eax,%esi
  801727:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801729:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80172e:	75 48                	jne    801778 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  801730:	e8 67 fa ff ff       	call   80119c <sys_getenvid>
  801735:	25 ff 03 00 00       	and    $0x3ff,%eax
  80173a:	c1 e0 07             	shl    $0x7,%eax
  80173d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801742:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801747:	e9 90 00 00 00       	jmp    8017dc <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  80174c:	83 ec 04             	sub    $0x4,%esp
  80174f:	68 18 3a 80 00       	push   $0x803a18
  801754:	68 8c 00 00 00       	push   $0x8c
  801759:	68 a9 39 80 00       	push   $0x8039a9
  80175e:	e8 30 ee ff ff       	call   800593 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801763:	89 f8                	mov    %edi,%eax
  801765:	e8 45 fd ff ff       	call   8014af <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80176a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801770:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801776:	74 26                	je     80179e <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801778:	89 d8                	mov    %ebx,%eax
  80177a:	c1 e8 16             	shr    $0x16,%eax
  80177d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801784:	a8 01                	test   $0x1,%al
  801786:	74 e2                	je     80176a <fork+0x66>
  801788:	89 da                	mov    %ebx,%edx
  80178a:	c1 ea 0c             	shr    $0xc,%edx
  80178d:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801794:	83 e0 05             	and    $0x5,%eax
  801797:	83 f8 05             	cmp    $0x5,%eax
  80179a:	75 ce                	jne    80176a <fork+0x66>
  80179c:	eb c5                	jmp    801763 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80179e:	83 ec 04             	sub    $0x4,%esp
  8017a1:	6a 07                	push   $0x7
  8017a3:	68 00 f0 bf ee       	push   $0xeebff000
  8017a8:	56                   	push   %esi
  8017a9:	e8 2c fa ff ff       	call   8011da <sys_page_alloc>
	if(ret < 0)
  8017ae:	83 c4 10             	add    $0x10,%esp
  8017b1:	85 c0                	test   %eax,%eax
  8017b3:	78 31                	js     8017e6 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8017b5:	83 ec 08             	sub    $0x8,%esp
  8017b8:	68 51 30 80 00       	push   $0x803051
  8017bd:	56                   	push   %esi
  8017be:	e8 62 fb ff ff       	call   801325 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8017c3:	83 c4 10             	add    $0x10,%esp
  8017c6:	85 c0                	test   %eax,%eax
  8017c8:	78 33                	js     8017fd <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8017ca:	83 ec 08             	sub    $0x8,%esp
  8017cd:	6a 02                	push   $0x2
  8017cf:	56                   	push   %esi
  8017d0:	e8 cc fa ff ff       	call   8012a1 <sys_env_set_status>
	if(ret < 0)
  8017d5:	83 c4 10             	add    $0x10,%esp
  8017d8:	85 c0                	test   %eax,%eax
  8017da:	78 38                	js     801814 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8017dc:	89 f0                	mov    %esi,%eax
  8017de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017e1:	5b                   	pop    %ebx
  8017e2:	5e                   	pop    %esi
  8017e3:	5f                   	pop    %edi
  8017e4:	5d                   	pop    %ebp
  8017e5:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8017e6:	83 ec 04             	sub    $0x4,%esp
  8017e9:	68 c8 39 80 00       	push   $0x8039c8
  8017ee:	68 98 00 00 00       	push   $0x98
  8017f3:	68 a9 39 80 00       	push   $0x8039a9
  8017f8:	e8 96 ed ff ff       	call   800593 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8017fd:	83 ec 04             	sub    $0x4,%esp
  801800:	68 3c 3a 80 00       	push   $0x803a3c
  801805:	68 9b 00 00 00       	push   $0x9b
  80180a:	68 a9 39 80 00       	push   $0x8039a9
  80180f:	e8 7f ed ff ff       	call   800593 <_panic>
		panic("panic in sys_env_set_status()\n");
  801814:	83 ec 04             	sub    $0x4,%esp
  801817:	68 64 3a 80 00       	push   $0x803a64
  80181c:	68 9e 00 00 00       	push   $0x9e
  801821:	68 a9 39 80 00       	push   $0x8039a9
  801826:	e8 68 ed ff ff       	call   800593 <_panic>

0080182b <sfork>:

// Challenge!
int
sfork(void)
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
  80182e:	57                   	push   %edi
  80182f:	56                   	push   %esi
  801830:	53                   	push   %ebx
  801831:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801834:	68 05 16 80 00       	push   $0x801605
  801839:	e8 a4 17 00 00       	call   802fe2 <set_pgfault_handler>
  80183e:	b8 07 00 00 00       	mov    $0x7,%eax
  801843:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801845:	83 c4 10             	add    $0x10,%esp
  801848:	85 c0                	test   %eax,%eax
  80184a:	78 27                	js     801873 <sfork+0x48>
  80184c:	89 c7                	mov    %eax,%edi
  80184e:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801850:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801855:	75 55                	jne    8018ac <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801857:	e8 40 f9 ff ff       	call   80119c <sys_getenvid>
  80185c:	25 ff 03 00 00       	and    $0x3ff,%eax
  801861:	c1 e0 07             	shl    $0x7,%eax
  801864:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801869:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  80186e:	e9 d4 00 00 00       	jmp    801947 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  801873:	83 ec 04             	sub    $0x4,%esp
  801876:	68 18 3a 80 00       	push   $0x803a18
  80187b:	68 af 00 00 00       	push   $0xaf
  801880:	68 a9 39 80 00       	push   $0x8039a9
  801885:	e8 09 ed ff ff       	call   800593 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  80188a:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80188f:	89 f0                	mov    %esi,%eax
  801891:	e8 19 fc ff ff       	call   8014af <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801896:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80189c:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8018a2:	77 65                	ja     801909 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  8018a4:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8018aa:	74 de                	je     80188a <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8018ac:	89 d8                	mov    %ebx,%eax
  8018ae:	c1 e8 16             	shr    $0x16,%eax
  8018b1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8018b8:	a8 01                	test   $0x1,%al
  8018ba:	74 da                	je     801896 <sfork+0x6b>
  8018bc:	89 da                	mov    %ebx,%edx
  8018be:	c1 ea 0c             	shr    $0xc,%edx
  8018c1:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8018c8:	83 e0 05             	and    $0x5,%eax
  8018cb:	83 f8 05             	cmp    $0x5,%eax
  8018ce:	75 c6                	jne    801896 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8018d0:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8018d7:	c1 e2 0c             	shl    $0xc,%edx
  8018da:	83 ec 0c             	sub    $0xc,%esp
  8018dd:	83 e0 07             	and    $0x7,%eax
  8018e0:	50                   	push   %eax
  8018e1:	52                   	push   %edx
  8018e2:	56                   	push   %esi
  8018e3:	52                   	push   %edx
  8018e4:	6a 00                	push   $0x0
  8018e6:	e8 32 f9 ff ff       	call   80121d <sys_page_map>
  8018eb:	83 c4 20             	add    $0x20,%esp
  8018ee:	85 c0                	test   %eax,%eax
  8018f0:	74 a4                	je     801896 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  8018f2:	83 ec 04             	sub    $0x4,%esp
  8018f5:	68 93 39 80 00       	push   $0x803993
  8018fa:	68 ba 00 00 00       	push   $0xba
  8018ff:	68 a9 39 80 00       	push   $0x8039a9
  801904:	e8 8a ec ff ff       	call   800593 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801909:	83 ec 04             	sub    $0x4,%esp
  80190c:	6a 07                	push   $0x7
  80190e:	68 00 f0 bf ee       	push   $0xeebff000
  801913:	57                   	push   %edi
  801914:	e8 c1 f8 ff ff       	call   8011da <sys_page_alloc>
	if(ret < 0)
  801919:	83 c4 10             	add    $0x10,%esp
  80191c:	85 c0                	test   %eax,%eax
  80191e:	78 31                	js     801951 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801920:	83 ec 08             	sub    $0x8,%esp
  801923:	68 51 30 80 00       	push   $0x803051
  801928:	57                   	push   %edi
  801929:	e8 f7 f9 ff ff       	call   801325 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80192e:	83 c4 10             	add    $0x10,%esp
  801931:	85 c0                	test   %eax,%eax
  801933:	78 33                	js     801968 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801935:	83 ec 08             	sub    $0x8,%esp
  801938:	6a 02                	push   $0x2
  80193a:	57                   	push   %edi
  80193b:	e8 61 f9 ff ff       	call   8012a1 <sys_env_set_status>
	if(ret < 0)
  801940:	83 c4 10             	add    $0x10,%esp
  801943:	85 c0                	test   %eax,%eax
  801945:	78 38                	js     80197f <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801947:	89 f8                	mov    %edi,%eax
  801949:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80194c:	5b                   	pop    %ebx
  80194d:	5e                   	pop    %esi
  80194e:	5f                   	pop    %edi
  80194f:	5d                   	pop    %ebp
  801950:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801951:	83 ec 04             	sub    $0x4,%esp
  801954:	68 c8 39 80 00       	push   $0x8039c8
  801959:	68 c0 00 00 00       	push   $0xc0
  80195e:	68 a9 39 80 00       	push   $0x8039a9
  801963:	e8 2b ec ff ff       	call   800593 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801968:	83 ec 04             	sub    $0x4,%esp
  80196b:	68 3c 3a 80 00       	push   $0x803a3c
  801970:	68 c3 00 00 00       	push   $0xc3
  801975:	68 a9 39 80 00       	push   $0x8039a9
  80197a:	e8 14 ec ff ff       	call   800593 <_panic>
		panic("panic in sys_env_set_status()\n");
  80197f:	83 ec 04             	sub    $0x4,%esp
  801982:	68 64 3a 80 00       	push   $0x803a64
  801987:	68 c6 00 00 00       	push   $0xc6
  80198c:	68 a9 39 80 00       	push   $0x8039a9
  801991:	e8 fd eb ff ff       	call   800593 <_panic>

00801996 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	05 00 00 00 30       	add    $0x30000000,%eax
  8019a1:	c1 e8 0c             	shr    $0xc,%eax
}
  8019a4:	5d                   	pop    %ebp
  8019a5:	c3                   	ret    

008019a6 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8019a6:	55                   	push   %ebp
  8019a7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8019a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ac:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8019b1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019b6:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8019bb:	5d                   	pop    %ebp
  8019bc:	c3                   	ret    

008019bd <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
  8019c0:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8019c5:	89 c2                	mov    %eax,%edx
  8019c7:	c1 ea 16             	shr    $0x16,%edx
  8019ca:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8019d1:	f6 c2 01             	test   $0x1,%dl
  8019d4:	74 2d                	je     801a03 <fd_alloc+0x46>
  8019d6:	89 c2                	mov    %eax,%edx
  8019d8:	c1 ea 0c             	shr    $0xc,%edx
  8019db:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8019e2:	f6 c2 01             	test   $0x1,%dl
  8019e5:	74 1c                	je     801a03 <fd_alloc+0x46>
  8019e7:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8019ec:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8019f1:	75 d2                	jne    8019c5 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8019f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8019fc:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801a01:	eb 0a                	jmp    801a0d <fd_alloc+0x50>
			*fd_store = fd;
  801a03:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a06:	89 01                	mov    %eax,(%ecx)
			return 0;
  801a08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a0d:	5d                   	pop    %ebp
  801a0e:	c3                   	ret    

00801a0f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
  801a12:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801a15:	83 f8 1f             	cmp    $0x1f,%eax
  801a18:	77 30                	ja     801a4a <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801a1a:	c1 e0 0c             	shl    $0xc,%eax
  801a1d:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801a22:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801a28:	f6 c2 01             	test   $0x1,%dl
  801a2b:	74 24                	je     801a51 <fd_lookup+0x42>
  801a2d:	89 c2                	mov    %eax,%edx
  801a2f:	c1 ea 0c             	shr    $0xc,%edx
  801a32:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a39:	f6 c2 01             	test   $0x1,%dl
  801a3c:	74 1a                	je     801a58 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801a3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a41:	89 02                	mov    %eax,(%edx)
	return 0;
  801a43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a48:	5d                   	pop    %ebp
  801a49:	c3                   	ret    
		return -E_INVAL;
  801a4a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a4f:	eb f7                	jmp    801a48 <fd_lookup+0x39>
		return -E_INVAL;
  801a51:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a56:	eb f0                	jmp    801a48 <fd_lookup+0x39>
  801a58:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a5d:	eb e9                	jmp    801a48 <fd_lookup+0x39>

00801a5f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
  801a62:	83 ec 08             	sub    $0x8,%esp
  801a65:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801a68:	ba 00 00 00 00       	mov    $0x0,%edx
  801a6d:	b8 20 40 80 00       	mov    $0x804020,%eax
		if (devtab[i]->dev_id == dev_id) {
  801a72:	39 08                	cmp    %ecx,(%eax)
  801a74:	74 38                	je     801aae <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801a76:	83 c2 01             	add    $0x1,%edx
  801a79:	8b 04 95 00 3b 80 00 	mov    0x803b00(,%edx,4),%eax
  801a80:	85 c0                	test   %eax,%eax
  801a82:	75 ee                	jne    801a72 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801a84:	a1 08 50 80 00       	mov    0x805008,%eax
  801a89:	8b 40 48             	mov    0x48(%eax),%eax
  801a8c:	83 ec 04             	sub    $0x4,%esp
  801a8f:	51                   	push   %ecx
  801a90:	50                   	push   %eax
  801a91:	68 84 3a 80 00       	push   $0x803a84
  801a96:	e8 ee eb ff ff       	call   800689 <cprintf>
	*dev = 0;
  801a9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a9e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801aa4:	83 c4 10             	add    $0x10,%esp
  801aa7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801aac:	c9                   	leave  
  801aad:	c3                   	ret    
			*dev = devtab[i];
  801aae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ab1:	89 01                	mov    %eax,(%ecx)
			return 0;
  801ab3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab8:	eb f2                	jmp    801aac <dev_lookup+0x4d>

00801aba <fd_close>:
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
  801abd:	57                   	push   %edi
  801abe:	56                   	push   %esi
  801abf:	53                   	push   %ebx
  801ac0:	83 ec 24             	sub    $0x24,%esp
  801ac3:	8b 75 08             	mov    0x8(%ebp),%esi
  801ac6:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801ac9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801acc:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801acd:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801ad3:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801ad6:	50                   	push   %eax
  801ad7:	e8 33 ff ff ff       	call   801a0f <fd_lookup>
  801adc:	89 c3                	mov    %eax,%ebx
  801ade:	83 c4 10             	add    $0x10,%esp
  801ae1:	85 c0                	test   %eax,%eax
  801ae3:	78 05                	js     801aea <fd_close+0x30>
	    || fd != fd2)
  801ae5:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801ae8:	74 16                	je     801b00 <fd_close+0x46>
		return (must_exist ? r : 0);
  801aea:	89 f8                	mov    %edi,%eax
  801aec:	84 c0                	test   %al,%al
  801aee:	b8 00 00 00 00       	mov    $0x0,%eax
  801af3:	0f 44 d8             	cmove  %eax,%ebx
}
  801af6:	89 d8                	mov    %ebx,%eax
  801af8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801afb:	5b                   	pop    %ebx
  801afc:	5e                   	pop    %esi
  801afd:	5f                   	pop    %edi
  801afe:	5d                   	pop    %ebp
  801aff:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801b00:	83 ec 08             	sub    $0x8,%esp
  801b03:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801b06:	50                   	push   %eax
  801b07:	ff 36                	pushl  (%esi)
  801b09:	e8 51 ff ff ff       	call   801a5f <dev_lookup>
  801b0e:	89 c3                	mov    %eax,%ebx
  801b10:	83 c4 10             	add    $0x10,%esp
  801b13:	85 c0                	test   %eax,%eax
  801b15:	78 1a                	js     801b31 <fd_close+0x77>
		if (dev->dev_close)
  801b17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b1a:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801b1d:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801b22:	85 c0                	test   %eax,%eax
  801b24:	74 0b                	je     801b31 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801b26:	83 ec 0c             	sub    $0xc,%esp
  801b29:	56                   	push   %esi
  801b2a:	ff d0                	call   *%eax
  801b2c:	89 c3                	mov    %eax,%ebx
  801b2e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801b31:	83 ec 08             	sub    $0x8,%esp
  801b34:	56                   	push   %esi
  801b35:	6a 00                	push   $0x0
  801b37:	e8 23 f7 ff ff       	call   80125f <sys_page_unmap>
	return r;
  801b3c:	83 c4 10             	add    $0x10,%esp
  801b3f:	eb b5                	jmp    801af6 <fd_close+0x3c>

00801b41 <close>:

int
close(int fdnum)
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
  801b44:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b47:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b4a:	50                   	push   %eax
  801b4b:	ff 75 08             	pushl  0x8(%ebp)
  801b4e:	e8 bc fe ff ff       	call   801a0f <fd_lookup>
  801b53:	83 c4 10             	add    $0x10,%esp
  801b56:	85 c0                	test   %eax,%eax
  801b58:	79 02                	jns    801b5c <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801b5a:	c9                   	leave  
  801b5b:	c3                   	ret    
		return fd_close(fd, 1);
  801b5c:	83 ec 08             	sub    $0x8,%esp
  801b5f:	6a 01                	push   $0x1
  801b61:	ff 75 f4             	pushl  -0xc(%ebp)
  801b64:	e8 51 ff ff ff       	call   801aba <fd_close>
  801b69:	83 c4 10             	add    $0x10,%esp
  801b6c:	eb ec                	jmp    801b5a <close+0x19>

00801b6e <close_all>:

void
close_all(void)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
  801b71:	53                   	push   %ebx
  801b72:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801b75:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801b7a:	83 ec 0c             	sub    $0xc,%esp
  801b7d:	53                   	push   %ebx
  801b7e:	e8 be ff ff ff       	call   801b41 <close>
	for (i = 0; i < MAXFD; i++)
  801b83:	83 c3 01             	add    $0x1,%ebx
  801b86:	83 c4 10             	add    $0x10,%esp
  801b89:	83 fb 20             	cmp    $0x20,%ebx
  801b8c:	75 ec                	jne    801b7a <close_all+0xc>
}
  801b8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
  801b96:	57                   	push   %edi
  801b97:	56                   	push   %esi
  801b98:	53                   	push   %ebx
  801b99:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801b9c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801b9f:	50                   	push   %eax
  801ba0:	ff 75 08             	pushl  0x8(%ebp)
  801ba3:	e8 67 fe ff ff       	call   801a0f <fd_lookup>
  801ba8:	89 c3                	mov    %eax,%ebx
  801baa:	83 c4 10             	add    $0x10,%esp
  801bad:	85 c0                	test   %eax,%eax
  801baf:	0f 88 81 00 00 00    	js     801c36 <dup+0xa3>
		return r;
	close(newfdnum);
  801bb5:	83 ec 0c             	sub    $0xc,%esp
  801bb8:	ff 75 0c             	pushl  0xc(%ebp)
  801bbb:	e8 81 ff ff ff       	call   801b41 <close>

	newfd = INDEX2FD(newfdnum);
  801bc0:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bc3:	c1 e6 0c             	shl    $0xc,%esi
  801bc6:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801bcc:	83 c4 04             	add    $0x4,%esp
  801bcf:	ff 75 e4             	pushl  -0x1c(%ebp)
  801bd2:	e8 cf fd ff ff       	call   8019a6 <fd2data>
  801bd7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801bd9:	89 34 24             	mov    %esi,(%esp)
  801bdc:	e8 c5 fd ff ff       	call   8019a6 <fd2data>
  801be1:	83 c4 10             	add    $0x10,%esp
  801be4:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801be6:	89 d8                	mov    %ebx,%eax
  801be8:	c1 e8 16             	shr    $0x16,%eax
  801beb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801bf2:	a8 01                	test   $0x1,%al
  801bf4:	74 11                	je     801c07 <dup+0x74>
  801bf6:	89 d8                	mov    %ebx,%eax
  801bf8:	c1 e8 0c             	shr    $0xc,%eax
  801bfb:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801c02:	f6 c2 01             	test   $0x1,%dl
  801c05:	75 39                	jne    801c40 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801c07:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c0a:	89 d0                	mov    %edx,%eax
  801c0c:	c1 e8 0c             	shr    $0xc,%eax
  801c0f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801c16:	83 ec 0c             	sub    $0xc,%esp
  801c19:	25 07 0e 00 00       	and    $0xe07,%eax
  801c1e:	50                   	push   %eax
  801c1f:	56                   	push   %esi
  801c20:	6a 00                	push   $0x0
  801c22:	52                   	push   %edx
  801c23:	6a 00                	push   $0x0
  801c25:	e8 f3 f5 ff ff       	call   80121d <sys_page_map>
  801c2a:	89 c3                	mov    %eax,%ebx
  801c2c:	83 c4 20             	add    $0x20,%esp
  801c2f:	85 c0                	test   %eax,%eax
  801c31:	78 31                	js     801c64 <dup+0xd1>
		goto err;

	return newfdnum;
  801c33:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801c36:	89 d8                	mov    %ebx,%eax
  801c38:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c3b:	5b                   	pop    %ebx
  801c3c:	5e                   	pop    %esi
  801c3d:	5f                   	pop    %edi
  801c3e:	5d                   	pop    %ebp
  801c3f:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801c40:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801c47:	83 ec 0c             	sub    $0xc,%esp
  801c4a:	25 07 0e 00 00       	and    $0xe07,%eax
  801c4f:	50                   	push   %eax
  801c50:	57                   	push   %edi
  801c51:	6a 00                	push   $0x0
  801c53:	53                   	push   %ebx
  801c54:	6a 00                	push   $0x0
  801c56:	e8 c2 f5 ff ff       	call   80121d <sys_page_map>
  801c5b:	89 c3                	mov    %eax,%ebx
  801c5d:	83 c4 20             	add    $0x20,%esp
  801c60:	85 c0                	test   %eax,%eax
  801c62:	79 a3                	jns    801c07 <dup+0x74>
	sys_page_unmap(0, newfd);
  801c64:	83 ec 08             	sub    $0x8,%esp
  801c67:	56                   	push   %esi
  801c68:	6a 00                	push   $0x0
  801c6a:	e8 f0 f5 ff ff       	call   80125f <sys_page_unmap>
	sys_page_unmap(0, nva);
  801c6f:	83 c4 08             	add    $0x8,%esp
  801c72:	57                   	push   %edi
  801c73:	6a 00                	push   $0x0
  801c75:	e8 e5 f5 ff ff       	call   80125f <sys_page_unmap>
	return r;
  801c7a:	83 c4 10             	add    $0x10,%esp
  801c7d:	eb b7                	jmp    801c36 <dup+0xa3>

00801c7f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
  801c82:	53                   	push   %ebx
  801c83:	83 ec 1c             	sub    $0x1c,%esp
  801c86:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c89:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c8c:	50                   	push   %eax
  801c8d:	53                   	push   %ebx
  801c8e:	e8 7c fd ff ff       	call   801a0f <fd_lookup>
  801c93:	83 c4 10             	add    $0x10,%esp
  801c96:	85 c0                	test   %eax,%eax
  801c98:	78 3f                	js     801cd9 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c9a:	83 ec 08             	sub    $0x8,%esp
  801c9d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ca0:	50                   	push   %eax
  801ca1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca4:	ff 30                	pushl  (%eax)
  801ca6:	e8 b4 fd ff ff       	call   801a5f <dev_lookup>
  801cab:	83 c4 10             	add    $0x10,%esp
  801cae:	85 c0                	test   %eax,%eax
  801cb0:	78 27                	js     801cd9 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801cb2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cb5:	8b 42 08             	mov    0x8(%edx),%eax
  801cb8:	83 e0 03             	and    $0x3,%eax
  801cbb:	83 f8 01             	cmp    $0x1,%eax
  801cbe:	74 1e                	je     801cde <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc3:	8b 40 08             	mov    0x8(%eax),%eax
  801cc6:	85 c0                	test   %eax,%eax
  801cc8:	74 35                	je     801cff <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801cca:	83 ec 04             	sub    $0x4,%esp
  801ccd:	ff 75 10             	pushl  0x10(%ebp)
  801cd0:	ff 75 0c             	pushl  0xc(%ebp)
  801cd3:	52                   	push   %edx
  801cd4:	ff d0                	call   *%eax
  801cd6:	83 c4 10             	add    $0x10,%esp
}
  801cd9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801cde:	a1 08 50 80 00       	mov    0x805008,%eax
  801ce3:	8b 40 48             	mov    0x48(%eax),%eax
  801ce6:	83 ec 04             	sub    $0x4,%esp
  801ce9:	53                   	push   %ebx
  801cea:	50                   	push   %eax
  801ceb:	68 c5 3a 80 00       	push   $0x803ac5
  801cf0:	e8 94 e9 ff ff       	call   800689 <cprintf>
		return -E_INVAL;
  801cf5:	83 c4 10             	add    $0x10,%esp
  801cf8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801cfd:	eb da                	jmp    801cd9 <read+0x5a>
		return -E_NOT_SUPP;
  801cff:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d04:	eb d3                	jmp    801cd9 <read+0x5a>

00801d06 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
  801d09:	57                   	push   %edi
  801d0a:	56                   	push   %esi
  801d0b:	53                   	push   %ebx
  801d0c:	83 ec 0c             	sub    $0xc,%esp
  801d0f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801d12:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801d15:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d1a:	39 f3                	cmp    %esi,%ebx
  801d1c:	73 23                	jae    801d41 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801d1e:	83 ec 04             	sub    $0x4,%esp
  801d21:	89 f0                	mov    %esi,%eax
  801d23:	29 d8                	sub    %ebx,%eax
  801d25:	50                   	push   %eax
  801d26:	89 d8                	mov    %ebx,%eax
  801d28:	03 45 0c             	add    0xc(%ebp),%eax
  801d2b:	50                   	push   %eax
  801d2c:	57                   	push   %edi
  801d2d:	e8 4d ff ff ff       	call   801c7f <read>
		if (m < 0)
  801d32:	83 c4 10             	add    $0x10,%esp
  801d35:	85 c0                	test   %eax,%eax
  801d37:	78 06                	js     801d3f <readn+0x39>
			return m;
		if (m == 0)
  801d39:	74 06                	je     801d41 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801d3b:	01 c3                	add    %eax,%ebx
  801d3d:	eb db                	jmp    801d1a <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801d3f:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801d41:	89 d8                	mov    %ebx,%eax
  801d43:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d46:	5b                   	pop    %ebx
  801d47:	5e                   	pop    %esi
  801d48:	5f                   	pop    %edi
  801d49:	5d                   	pop    %ebp
  801d4a:	c3                   	ret    

00801d4b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
  801d4e:	53                   	push   %ebx
  801d4f:	83 ec 1c             	sub    $0x1c,%esp
  801d52:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d55:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d58:	50                   	push   %eax
  801d59:	53                   	push   %ebx
  801d5a:	e8 b0 fc ff ff       	call   801a0f <fd_lookup>
  801d5f:	83 c4 10             	add    $0x10,%esp
  801d62:	85 c0                	test   %eax,%eax
  801d64:	78 3a                	js     801da0 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d66:	83 ec 08             	sub    $0x8,%esp
  801d69:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d6c:	50                   	push   %eax
  801d6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d70:	ff 30                	pushl  (%eax)
  801d72:	e8 e8 fc ff ff       	call   801a5f <dev_lookup>
  801d77:	83 c4 10             	add    $0x10,%esp
  801d7a:	85 c0                	test   %eax,%eax
  801d7c:	78 22                	js     801da0 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d81:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801d85:	74 1e                	je     801da5 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801d87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d8a:	8b 52 0c             	mov    0xc(%edx),%edx
  801d8d:	85 d2                	test   %edx,%edx
  801d8f:	74 35                	je     801dc6 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801d91:	83 ec 04             	sub    $0x4,%esp
  801d94:	ff 75 10             	pushl  0x10(%ebp)
  801d97:	ff 75 0c             	pushl  0xc(%ebp)
  801d9a:	50                   	push   %eax
  801d9b:	ff d2                	call   *%edx
  801d9d:	83 c4 10             	add    $0x10,%esp
}
  801da0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801da5:	a1 08 50 80 00       	mov    0x805008,%eax
  801daa:	8b 40 48             	mov    0x48(%eax),%eax
  801dad:	83 ec 04             	sub    $0x4,%esp
  801db0:	53                   	push   %ebx
  801db1:	50                   	push   %eax
  801db2:	68 e1 3a 80 00       	push   $0x803ae1
  801db7:	e8 cd e8 ff ff       	call   800689 <cprintf>
		return -E_INVAL;
  801dbc:	83 c4 10             	add    $0x10,%esp
  801dbf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801dc4:	eb da                	jmp    801da0 <write+0x55>
		return -E_NOT_SUPP;
  801dc6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801dcb:	eb d3                	jmp    801da0 <write+0x55>

00801dcd <seek>:

int
seek(int fdnum, off_t offset)
{
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
  801dd0:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801dd3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dd6:	50                   	push   %eax
  801dd7:	ff 75 08             	pushl  0x8(%ebp)
  801dda:	e8 30 fc ff ff       	call   801a0f <fd_lookup>
  801ddf:	83 c4 10             	add    $0x10,%esp
  801de2:	85 c0                	test   %eax,%eax
  801de4:	78 0e                	js     801df4 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801de6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dec:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801def:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df4:	c9                   	leave  
  801df5:	c3                   	ret    

00801df6 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801df6:	55                   	push   %ebp
  801df7:	89 e5                	mov    %esp,%ebp
  801df9:	53                   	push   %ebx
  801dfa:	83 ec 1c             	sub    $0x1c,%esp
  801dfd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801e00:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e03:	50                   	push   %eax
  801e04:	53                   	push   %ebx
  801e05:	e8 05 fc ff ff       	call   801a0f <fd_lookup>
  801e0a:	83 c4 10             	add    $0x10,%esp
  801e0d:	85 c0                	test   %eax,%eax
  801e0f:	78 37                	js     801e48 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801e11:	83 ec 08             	sub    $0x8,%esp
  801e14:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e17:	50                   	push   %eax
  801e18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e1b:	ff 30                	pushl  (%eax)
  801e1d:	e8 3d fc ff ff       	call   801a5f <dev_lookup>
  801e22:	83 c4 10             	add    $0x10,%esp
  801e25:	85 c0                	test   %eax,%eax
  801e27:	78 1f                	js     801e48 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801e29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e2c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801e30:	74 1b                	je     801e4d <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801e32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e35:	8b 52 18             	mov    0x18(%edx),%edx
  801e38:	85 d2                	test   %edx,%edx
  801e3a:	74 32                	je     801e6e <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801e3c:	83 ec 08             	sub    $0x8,%esp
  801e3f:	ff 75 0c             	pushl  0xc(%ebp)
  801e42:	50                   	push   %eax
  801e43:	ff d2                	call   *%edx
  801e45:	83 c4 10             	add    $0x10,%esp
}
  801e48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    
			thisenv->env_id, fdnum);
  801e4d:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801e52:	8b 40 48             	mov    0x48(%eax),%eax
  801e55:	83 ec 04             	sub    $0x4,%esp
  801e58:	53                   	push   %ebx
  801e59:	50                   	push   %eax
  801e5a:	68 a4 3a 80 00       	push   $0x803aa4
  801e5f:	e8 25 e8 ff ff       	call   800689 <cprintf>
		return -E_INVAL;
  801e64:	83 c4 10             	add    $0x10,%esp
  801e67:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e6c:	eb da                	jmp    801e48 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801e6e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e73:	eb d3                	jmp    801e48 <ftruncate+0x52>

00801e75 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801e75:	55                   	push   %ebp
  801e76:	89 e5                	mov    %esp,%ebp
  801e78:	53                   	push   %ebx
  801e79:	83 ec 1c             	sub    $0x1c,%esp
  801e7c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801e7f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e82:	50                   	push   %eax
  801e83:	ff 75 08             	pushl  0x8(%ebp)
  801e86:	e8 84 fb ff ff       	call   801a0f <fd_lookup>
  801e8b:	83 c4 10             	add    $0x10,%esp
  801e8e:	85 c0                	test   %eax,%eax
  801e90:	78 4b                	js     801edd <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801e92:	83 ec 08             	sub    $0x8,%esp
  801e95:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e98:	50                   	push   %eax
  801e99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e9c:	ff 30                	pushl  (%eax)
  801e9e:	e8 bc fb ff ff       	call   801a5f <dev_lookup>
  801ea3:	83 c4 10             	add    $0x10,%esp
  801ea6:	85 c0                	test   %eax,%eax
  801ea8:	78 33                	js     801edd <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ead:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801eb1:	74 2f                	je     801ee2 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801eb3:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801eb6:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801ebd:	00 00 00 
	stat->st_isdir = 0;
  801ec0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ec7:	00 00 00 
	stat->st_dev = dev;
  801eca:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801ed0:	83 ec 08             	sub    $0x8,%esp
  801ed3:	53                   	push   %ebx
  801ed4:	ff 75 f0             	pushl  -0x10(%ebp)
  801ed7:	ff 50 14             	call   *0x14(%eax)
  801eda:	83 c4 10             	add    $0x10,%esp
}
  801edd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ee0:	c9                   	leave  
  801ee1:	c3                   	ret    
		return -E_NOT_SUPP;
  801ee2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ee7:	eb f4                	jmp    801edd <fstat+0x68>

00801ee9 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801ee9:	55                   	push   %ebp
  801eea:	89 e5                	mov    %esp,%ebp
  801eec:	56                   	push   %esi
  801eed:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801eee:	83 ec 08             	sub    $0x8,%esp
  801ef1:	6a 00                	push   $0x0
  801ef3:	ff 75 08             	pushl  0x8(%ebp)
  801ef6:	e8 22 02 00 00       	call   80211d <open>
  801efb:	89 c3                	mov    %eax,%ebx
  801efd:	83 c4 10             	add    $0x10,%esp
  801f00:	85 c0                	test   %eax,%eax
  801f02:	78 1b                	js     801f1f <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801f04:	83 ec 08             	sub    $0x8,%esp
  801f07:	ff 75 0c             	pushl  0xc(%ebp)
  801f0a:	50                   	push   %eax
  801f0b:	e8 65 ff ff ff       	call   801e75 <fstat>
  801f10:	89 c6                	mov    %eax,%esi
	close(fd);
  801f12:	89 1c 24             	mov    %ebx,(%esp)
  801f15:	e8 27 fc ff ff       	call   801b41 <close>
	return r;
  801f1a:	83 c4 10             	add    $0x10,%esp
  801f1d:	89 f3                	mov    %esi,%ebx
}
  801f1f:	89 d8                	mov    %ebx,%eax
  801f21:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f24:	5b                   	pop    %ebx
  801f25:	5e                   	pop    %esi
  801f26:	5d                   	pop    %ebp
  801f27:	c3                   	ret    

00801f28 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801f28:	55                   	push   %ebp
  801f29:	89 e5                	mov    %esp,%ebp
  801f2b:	56                   	push   %esi
  801f2c:	53                   	push   %ebx
  801f2d:	89 c6                	mov    %eax,%esi
  801f2f:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801f31:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801f38:	74 27                	je     801f61 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801f3a:	6a 07                	push   $0x7
  801f3c:	68 00 60 80 00       	push   $0x806000
  801f41:	56                   	push   %esi
  801f42:	ff 35 00 50 80 00    	pushl  0x805000
  801f48:	e8 93 11 00 00       	call   8030e0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801f4d:	83 c4 0c             	add    $0xc,%esp
  801f50:	6a 00                	push   $0x0
  801f52:	53                   	push   %ebx
  801f53:	6a 00                	push   $0x0
  801f55:	e8 1d 11 00 00       	call   803077 <ipc_recv>
}
  801f5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f5d:	5b                   	pop    %ebx
  801f5e:	5e                   	pop    %esi
  801f5f:	5d                   	pop    %ebp
  801f60:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801f61:	83 ec 0c             	sub    $0xc,%esp
  801f64:	6a 01                	push   $0x1
  801f66:	e8 cd 11 00 00       	call   803138 <ipc_find_env>
  801f6b:	a3 00 50 80 00       	mov    %eax,0x805000
  801f70:	83 c4 10             	add    $0x10,%esp
  801f73:	eb c5                	jmp    801f3a <fsipc+0x12>

00801f75 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801f75:	55                   	push   %ebp
  801f76:	89 e5                	mov    %esp,%ebp
  801f78:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f81:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801f86:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f89:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801f8e:	ba 00 00 00 00       	mov    $0x0,%edx
  801f93:	b8 02 00 00 00       	mov    $0x2,%eax
  801f98:	e8 8b ff ff ff       	call   801f28 <fsipc>
}
  801f9d:	c9                   	leave  
  801f9e:	c3                   	ret    

00801f9f <devfile_flush>:
{
  801f9f:	55                   	push   %ebp
  801fa0:	89 e5                	mov    %esp,%ebp
  801fa2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa8:	8b 40 0c             	mov    0xc(%eax),%eax
  801fab:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801fb0:	ba 00 00 00 00       	mov    $0x0,%edx
  801fb5:	b8 06 00 00 00       	mov    $0x6,%eax
  801fba:	e8 69 ff ff ff       	call   801f28 <fsipc>
}
  801fbf:	c9                   	leave  
  801fc0:	c3                   	ret    

00801fc1 <devfile_stat>:
{
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
  801fc4:	53                   	push   %ebx
  801fc5:	83 ec 04             	sub    $0x4,%esp
  801fc8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fce:	8b 40 0c             	mov    0xc(%eax),%eax
  801fd1:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801fd6:	ba 00 00 00 00       	mov    $0x0,%edx
  801fdb:	b8 05 00 00 00       	mov    $0x5,%eax
  801fe0:	e8 43 ff ff ff       	call   801f28 <fsipc>
  801fe5:	85 c0                	test   %eax,%eax
  801fe7:	78 2c                	js     802015 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801fe9:	83 ec 08             	sub    $0x8,%esp
  801fec:	68 00 60 80 00       	push   $0x806000
  801ff1:	53                   	push   %ebx
  801ff2:	e8 f1 ed ff ff       	call   800de8 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801ff7:	a1 80 60 80 00       	mov    0x806080,%eax
  801ffc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802002:	a1 84 60 80 00       	mov    0x806084,%eax
  802007:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80200d:	83 c4 10             	add    $0x10,%esp
  802010:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802015:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802018:	c9                   	leave  
  802019:	c3                   	ret    

0080201a <devfile_write>:
{
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
  80201d:	53                   	push   %ebx
  80201e:	83 ec 08             	sub    $0x8,%esp
  802021:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802024:	8b 45 08             	mov    0x8(%ebp),%eax
  802027:	8b 40 0c             	mov    0xc(%eax),%eax
  80202a:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  80202f:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802035:	53                   	push   %ebx
  802036:	ff 75 0c             	pushl  0xc(%ebp)
  802039:	68 08 60 80 00       	push   $0x806008
  80203e:	e8 95 ef ff ff       	call   800fd8 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802043:	ba 00 00 00 00       	mov    $0x0,%edx
  802048:	b8 04 00 00 00       	mov    $0x4,%eax
  80204d:	e8 d6 fe ff ff       	call   801f28 <fsipc>
  802052:	83 c4 10             	add    $0x10,%esp
  802055:	85 c0                	test   %eax,%eax
  802057:	78 0b                	js     802064 <devfile_write+0x4a>
	assert(r <= n);
  802059:	39 d8                	cmp    %ebx,%eax
  80205b:	77 0c                	ja     802069 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80205d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802062:	7f 1e                	jg     802082 <devfile_write+0x68>
}
  802064:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802067:	c9                   	leave  
  802068:	c3                   	ret    
	assert(r <= n);
  802069:	68 14 3b 80 00       	push   $0x803b14
  80206e:	68 1b 3b 80 00       	push   $0x803b1b
  802073:	68 98 00 00 00       	push   $0x98
  802078:	68 30 3b 80 00       	push   $0x803b30
  80207d:	e8 11 e5 ff ff       	call   800593 <_panic>
	assert(r <= PGSIZE);
  802082:	68 3b 3b 80 00       	push   $0x803b3b
  802087:	68 1b 3b 80 00       	push   $0x803b1b
  80208c:	68 99 00 00 00       	push   $0x99
  802091:	68 30 3b 80 00       	push   $0x803b30
  802096:	e8 f8 e4 ff ff       	call   800593 <_panic>

0080209b <devfile_read>:
{
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
  80209e:	56                   	push   %esi
  80209f:	53                   	push   %ebx
  8020a0:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8020a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8020a9:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  8020ae:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8020b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8020b9:	b8 03 00 00 00       	mov    $0x3,%eax
  8020be:	e8 65 fe ff ff       	call   801f28 <fsipc>
  8020c3:	89 c3                	mov    %eax,%ebx
  8020c5:	85 c0                	test   %eax,%eax
  8020c7:	78 1f                	js     8020e8 <devfile_read+0x4d>
	assert(r <= n);
  8020c9:	39 f0                	cmp    %esi,%eax
  8020cb:	77 24                	ja     8020f1 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8020cd:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8020d2:	7f 33                	jg     802107 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8020d4:	83 ec 04             	sub    $0x4,%esp
  8020d7:	50                   	push   %eax
  8020d8:	68 00 60 80 00       	push   $0x806000
  8020dd:	ff 75 0c             	pushl  0xc(%ebp)
  8020e0:	e8 91 ee ff ff       	call   800f76 <memmove>
	return r;
  8020e5:	83 c4 10             	add    $0x10,%esp
}
  8020e8:	89 d8                	mov    %ebx,%eax
  8020ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020ed:	5b                   	pop    %ebx
  8020ee:	5e                   	pop    %esi
  8020ef:	5d                   	pop    %ebp
  8020f0:	c3                   	ret    
	assert(r <= n);
  8020f1:	68 14 3b 80 00       	push   $0x803b14
  8020f6:	68 1b 3b 80 00       	push   $0x803b1b
  8020fb:	6a 7c                	push   $0x7c
  8020fd:	68 30 3b 80 00       	push   $0x803b30
  802102:	e8 8c e4 ff ff       	call   800593 <_panic>
	assert(r <= PGSIZE);
  802107:	68 3b 3b 80 00       	push   $0x803b3b
  80210c:	68 1b 3b 80 00       	push   $0x803b1b
  802111:	6a 7d                	push   $0x7d
  802113:	68 30 3b 80 00       	push   $0x803b30
  802118:	e8 76 e4 ff ff       	call   800593 <_panic>

0080211d <open>:
{
  80211d:	55                   	push   %ebp
  80211e:	89 e5                	mov    %esp,%ebp
  802120:	56                   	push   %esi
  802121:	53                   	push   %ebx
  802122:	83 ec 1c             	sub    $0x1c,%esp
  802125:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  802128:	56                   	push   %esi
  802129:	e8 81 ec ff ff       	call   800daf <strlen>
  80212e:	83 c4 10             	add    $0x10,%esp
  802131:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802136:	7f 6c                	jg     8021a4 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  802138:	83 ec 0c             	sub    $0xc,%esp
  80213b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80213e:	50                   	push   %eax
  80213f:	e8 79 f8 ff ff       	call   8019bd <fd_alloc>
  802144:	89 c3                	mov    %eax,%ebx
  802146:	83 c4 10             	add    $0x10,%esp
  802149:	85 c0                	test   %eax,%eax
  80214b:	78 3c                	js     802189 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80214d:	83 ec 08             	sub    $0x8,%esp
  802150:	56                   	push   %esi
  802151:	68 00 60 80 00       	push   $0x806000
  802156:	e8 8d ec ff ff       	call   800de8 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80215b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80215e:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802163:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802166:	b8 01 00 00 00       	mov    $0x1,%eax
  80216b:	e8 b8 fd ff ff       	call   801f28 <fsipc>
  802170:	89 c3                	mov    %eax,%ebx
  802172:	83 c4 10             	add    $0x10,%esp
  802175:	85 c0                	test   %eax,%eax
  802177:	78 19                	js     802192 <open+0x75>
	return fd2num(fd);
  802179:	83 ec 0c             	sub    $0xc,%esp
  80217c:	ff 75 f4             	pushl  -0xc(%ebp)
  80217f:	e8 12 f8 ff ff       	call   801996 <fd2num>
  802184:	89 c3                	mov    %eax,%ebx
  802186:	83 c4 10             	add    $0x10,%esp
}
  802189:	89 d8                	mov    %ebx,%eax
  80218b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80218e:	5b                   	pop    %ebx
  80218f:	5e                   	pop    %esi
  802190:	5d                   	pop    %ebp
  802191:	c3                   	ret    
		fd_close(fd, 0);
  802192:	83 ec 08             	sub    $0x8,%esp
  802195:	6a 00                	push   $0x0
  802197:	ff 75 f4             	pushl  -0xc(%ebp)
  80219a:	e8 1b f9 ff ff       	call   801aba <fd_close>
		return r;
  80219f:	83 c4 10             	add    $0x10,%esp
  8021a2:	eb e5                	jmp    802189 <open+0x6c>
		return -E_BAD_PATH;
  8021a4:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8021a9:	eb de                	jmp    802189 <open+0x6c>

008021ab <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
  8021ae:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8021b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8021b6:	b8 08 00 00 00       	mov    $0x8,%eax
  8021bb:	e8 68 fd ff ff       	call   801f28 <fsipc>
}
  8021c0:	c9                   	leave  
  8021c1:	c3                   	ret    

008021c2 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8021c2:	55                   	push   %ebp
  8021c3:	89 e5                	mov    %esp,%ebp
  8021c5:	57                   	push   %edi
  8021c6:	56                   	push   %esi
  8021c7:	53                   	push   %ebx
  8021c8:	81 ec 94 02 00 00    	sub    $0x294,%esp
	cprintf("in %s\n", __FUNCTION__);
  8021ce:	68 20 3c 80 00       	push   $0x803c20
  8021d3:	68 9e 35 80 00       	push   $0x80359e
  8021d8:	e8 ac e4 ff ff       	call   800689 <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8021dd:	83 c4 08             	add    $0x8,%esp
  8021e0:	6a 00                	push   $0x0
  8021e2:	ff 75 08             	pushl  0x8(%ebp)
  8021e5:	e8 33 ff ff ff       	call   80211d <open>
  8021ea:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8021f0:	83 c4 10             	add    $0x10,%esp
  8021f3:	85 c0                	test   %eax,%eax
  8021f5:	0f 88 0a 05 00 00    	js     802705 <spawn+0x543>
  8021fb:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8021fd:	83 ec 04             	sub    $0x4,%esp
  802200:	68 00 02 00 00       	push   $0x200
  802205:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  80220b:	50                   	push   %eax
  80220c:	51                   	push   %ecx
  80220d:	e8 f4 fa ff ff       	call   801d06 <readn>
  802212:	83 c4 10             	add    $0x10,%esp
  802215:	3d 00 02 00 00       	cmp    $0x200,%eax
  80221a:	75 74                	jne    802290 <spawn+0xce>
	    || elf->e_magic != ELF_MAGIC) {
  80221c:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  802223:	45 4c 46 
  802226:	75 68                	jne    802290 <spawn+0xce>
  802228:	b8 07 00 00 00       	mov    $0x7,%eax
  80222d:	cd 30                	int    $0x30
  80222f:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  802235:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  80223b:	85 c0                	test   %eax,%eax
  80223d:	0f 88 b6 04 00 00    	js     8026f9 <spawn+0x537>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802243:	25 ff 03 00 00       	and    $0x3ff,%eax
  802248:	89 c6                	mov    %eax,%esi
  80224a:	c1 e6 07             	shl    $0x7,%esi
  80224d:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  802253:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  802259:	b9 11 00 00 00       	mov    $0x11,%ecx
  80225e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  802260:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802266:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
	cprintf("in %s\n", __FUNCTION__);
  80226c:	83 ec 08             	sub    $0x8,%esp
  80226f:	68 14 3c 80 00       	push   $0x803c14
  802274:	68 9e 35 80 00       	push   $0x80359e
  802279:	e8 0b e4 ff ff       	call   800689 <cprintf>
  80227e:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802281:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  802286:	be 00 00 00 00       	mov    $0x0,%esi
  80228b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80228e:	eb 4b                	jmp    8022db <spawn+0x119>
		close(fd);
  802290:	83 ec 0c             	sub    $0xc,%esp
  802293:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802299:	e8 a3 f8 ff ff       	call   801b41 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80229e:	83 c4 0c             	add    $0xc,%esp
  8022a1:	68 7f 45 4c 46       	push   $0x464c457f
  8022a6:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  8022ac:	68 47 3b 80 00       	push   $0x803b47
  8022b1:	e8 d3 e3 ff ff       	call   800689 <cprintf>
		return -E_NOT_EXEC;
  8022b6:	83 c4 10             	add    $0x10,%esp
  8022b9:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  8022c0:	ff ff ff 
  8022c3:	e9 3d 04 00 00       	jmp    802705 <spawn+0x543>
		string_size += strlen(argv[argc]) + 1;
  8022c8:	83 ec 0c             	sub    $0xc,%esp
  8022cb:	50                   	push   %eax
  8022cc:	e8 de ea ff ff       	call   800daf <strlen>
  8022d1:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  8022d5:	83 c3 01             	add    $0x1,%ebx
  8022d8:	83 c4 10             	add    $0x10,%esp
  8022db:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  8022e2:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  8022e5:	85 c0                	test   %eax,%eax
  8022e7:	75 df                	jne    8022c8 <spawn+0x106>
  8022e9:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  8022ef:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8022f5:	bf 00 10 40 00       	mov    $0x401000,%edi
  8022fa:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  8022fc:	89 fa                	mov    %edi,%edx
  8022fe:	83 e2 fc             	and    $0xfffffffc,%edx
  802301:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  802308:	29 c2                	sub    %eax,%edx
  80230a:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802310:	8d 42 f8             	lea    -0x8(%edx),%eax
  802313:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802318:	0f 86 0a 04 00 00    	jbe    802728 <spawn+0x566>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80231e:	83 ec 04             	sub    $0x4,%esp
  802321:	6a 07                	push   $0x7
  802323:	68 00 00 40 00       	push   $0x400000
  802328:	6a 00                	push   $0x0
  80232a:	e8 ab ee ff ff       	call   8011da <sys_page_alloc>
  80232f:	83 c4 10             	add    $0x10,%esp
  802332:	85 c0                	test   %eax,%eax
  802334:	0f 88 f3 03 00 00    	js     80272d <spawn+0x56b>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80233a:	be 00 00 00 00       	mov    $0x0,%esi
  80233f:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  802345:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802348:	eb 30                	jmp    80237a <spawn+0x1b8>
		argv_store[i] = UTEMP2USTACK(string_store);
  80234a:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802350:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  802356:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  802359:	83 ec 08             	sub    $0x8,%esp
  80235c:	ff 34 b3             	pushl  (%ebx,%esi,4)
  80235f:	57                   	push   %edi
  802360:	e8 83 ea ff ff       	call   800de8 <strcpy>
		string_store += strlen(argv[i]) + 1;
  802365:	83 c4 04             	add    $0x4,%esp
  802368:	ff 34 b3             	pushl  (%ebx,%esi,4)
  80236b:	e8 3f ea ff ff       	call   800daf <strlen>
  802370:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  802374:	83 c6 01             	add    $0x1,%esi
  802377:	83 c4 10             	add    $0x10,%esp
  80237a:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  802380:	7f c8                	jg     80234a <spawn+0x188>
	}
	argv_store[argc] = 0;
  802382:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802388:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  80238e:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  802395:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  80239b:	0f 85 86 00 00 00    	jne    802427 <spawn+0x265>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8023a1:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  8023a7:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  8023ad:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  8023b0:	89 d0                	mov    %edx,%eax
  8023b2:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  8023b8:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8023bb:	2d 08 30 80 11       	sub    $0x11803008,%eax
  8023c0:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8023c6:	83 ec 0c             	sub    $0xc,%esp
  8023c9:	6a 07                	push   $0x7
  8023cb:	68 00 d0 bf ee       	push   $0xeebfd000
  8023d0:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8023d6:	68 00 00 40 00       	push   $0x400000
  8023db:	6a 00                	push   $0x0
  8023dd:	e8 3b ee ff ff       	call   80121d <sys_page_map>
  8023e2:	89 c3                	mov    %eax,%ebx
  8023e4:	83 c4 20             	add    $0x20,%esp
  8023e7:	85 c0                	test   %eax,%eax
  8023e9:	0f 88 46 03 00 00    	js     802735 <spawn+0x573>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8023ef:	83 ec 08             	sub    $0x8,%esp
  8023f2:	68 00 00 40 00       	push   $0x400000
  8023f7:	6a 00                	push   $0x0
  8023f9:	e8 61 ee ff ff       	call   80125f <sys_page_unmap>
  8023fe:	89 c3                	mov    %eax,%ebx
  802400:	83 c4 10             	add    $0x10,%esp
  802403:	85 c0                	test   %eax,%eax
  802405:	0f 88 2a 03 00 00    	js     802735 <spawn+0x573>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  80240b:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  802411:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802418:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  80241f:	00 00 00 
  802422:	e9 4f 01 00 00       	jmp    802576 <spawn+0x3b4>
	assert(string_store == (char*)UTEMP + PGSIZE);
  802427:	68 d0 3b 80 00       	push   $0x803bd0
  80242c:	68 1b 3b 80 00       	push   $0x803b1b
  802431:	68 f8 00 00 00       	push   $0xf8
  802436:	68 61 3b 80 00       	push   $0x803b61
  80243b:	e8 53 e1 ff ff       	call   800593 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802440:	83 ec 04             	sub    $0x4,%esp
  802443:	6a 07                	push   $0x7
  802445:	68 00 00 40 00       	push   $0x400000
  80244a:	6a 00                	push   $0x0
  80244c:	e8 89 ed ff ff       	call   8011da <sys_page_alloc>
  802451:	83 c4 10             	add    $0x10,%esp
  802454:	85 c0                	test   %eax,%eax
  802456:	0f 88 b7 02 00 00    	js     802713 <spawn+0x551>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  80245c:	83 ec 08             	sub    $0x8,%esp
  80245f:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802465:	01 f0                	add    %esi,%eax
  802467:	50                   	push   %eax
  802468:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80246e:	e8 5a f9 ff ff       	call   801dcd <seek>
  802473:	83 c4 10             	add    $0x10,%esp
  802476:	85 c0                	test   %eax,%eax
  802478:	0f 88 9c 02 00 00    	js     80271a <spawn+0x558>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80247e:	83 ec 04             	sub    $0x4,%esp
  802481:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802487:	29 f0                	sub    %esi,%eax
  802489:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80248e:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802493:	0f 47 c1             	cmova  %ecx,%eax
  802496:	50                   	push   %eax
  802497:	68 00 00 40 00       	push   $0x400000
  80249c:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8024a2:	e8 5f f8 ff ff       	call   801d06 <readn>
  8024a7:	83 c4 10             	add    $0x10,%esp
  8024aa:	85 c0                	test   %eax,%eax
  8024ac:	0f 88 6f 02 00 00    	js     802721 <spawn+0x55f>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8024b2:	83 ec 0c             	sub    $0xc,%esp
  8024b5:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8024bb:	53                   	push   %ebx
  8024bc:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  8024c2:	68 00 00 40 00       	push   $0x400000
  8024c7:	6a 00                	push   $0x0
  8024c9:	e8 4f ed ff ff       	call   80121d <sys_page_map>
  8024ce:	83 c4 20             	add    $0x20,%esp
  8024d1:	85 c0                	test   %eax,%eax
  8024d3:	78 7c                	js     802551 <spawn+0x38f>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  8024d5:	83 ec 08             	sub    $0x8,%esp
  8024d8:	68 00 00 40 00       	push   $0x400000
  8024dd:	6a 00                	push   $0x0
  8024df:	e8 7b ed ff ff       	call   80125f <sys_page_unmap>
  8024e4:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  8024e7:	81 c7 00 10 00 00    	add    $0x1000,%edi
  8024ed:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8024f3:	89 fe                	mov    %edi,%esi
  8024f5:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  8024fb:	76 69                	jbe    802566 <spawn+0x3a4>
		if (i >= filesz) {
  8024fd:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  802503:	0f 87 37 ff ff ff    	ja     802440 <spawn+0x27e>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802509:	83 ec 04             	sub    $0x4,%esp
  80250c:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802512:	53                   	push   %ebx
  802513:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802519:	e8 bc ec ff ff       	call   8011da <sys_page_alloc>
  80251e:	83 c4 10             	add    $0x10,%esp
  802521:	85 c0                	test   %eax,%eax
  802523:	79 c2                	jns    8024e7 <spawn+0x325>
  802525:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  802527:	83 ec 0c             	sub    $0xc,%esp
  80252a:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802530:	e8 26 ec ff ff       	call   80115b <sys_env_destroy>
	close(fd);
  802535:	83 c4 04             	add    $0x4,%esp
  802538:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80253e:	e8 fe f5 ff ff       	call   801b41 <close>
	return r;
  802543:	83 c4 10             	add    $0x10,%esp
  802546:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  80254c:	e9 b4 01 00 00       	jmp    802705 <spawn+0x543>
				panic("spawn: sys_page_map data: %e", r);
  802551:	50                   	push   %eax
  802552:	68 6d 3b 80 00       	push   $0x803b6d
  802557:	68 2b 01 00 00       	push   $0x12b
  80255c:	68 61 3b 80 00       	push   $0x803b61
  802561:	e8 2d e0 ff ff       	call   800593 <_panic>
  802566:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80256c:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  802573:	83 c6 20             	add    $0x20,%esi
  802576:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  80257d:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  802583:	7e 6d                	jle    8025f2 <spawn+0x430>
		if (ph->p_type != ELF_PROG_LOAD)
  802585:	83 3e 01             	cmpl   $0x1,(%esi)
  802588:	75 e2                	jne    80256c <spawn+0x3aa>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  80258a:	8b 46 18             	mov    0x18(%esi),%eax
  80258d:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  802590:	83 f8 01             	cmp    $0x1,%eax
  802593:	19 c0                	sbb    %eax,%eax
  802595:	83 e0 fe             	and    $0xfffffffe,%eax
  802598:	83 c0 07             	add    $0x7,%eax
  80259b:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  8025a1:	8b 4e 04             	mov    0x4(%esi),%ecx
  8025a4:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  8025aa:	8b 56 10             	mov    0x10(%esi),%edx
  8025ad:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  8025b3:	8b 7e 14             	mov    0x14(%esi),%edi
  8025b6:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  8025bc:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  8025bf:	89 d8                	mov    %ebx,%eax
  8025c1:	25 ff 0f 00 00       	and    $0xfff,%eax
  8025c6:	74 1a                	je     8025e2 <spawn+0x420>
		va -= i;
  8025c8:	29 c3                	sub    %eax,%ebx
		memsz += i;
  8025ca:	01 c7                	add    %eax,%edi
  8025cc:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  8025d2:	01 c2                	add    %eax,%edx
  8025d4:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  8025da:	29 c1                	sub    %eax,%ecx
  8025dc:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  8025e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8025e7:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  8025ed:	e9 01 ff ff ff       	jmp    8024f3 <spawn+0x331>
	close(fd);
  8025f2:	83 ec 0c             	sub    $0xc,%esp
  8025f5:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8025fb:	e8 41 f5 ff ff       	call   801b41 <close>

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	cprintf("in %s\n", __FUNCTION__);
  802600:	83 c4 08             	add    $0x8,%esp
  802603:	68 00 3c 80 00       	push   $0x803c00
  802608:	68 9e 35 80 00       	push   $0x80359e
  80260d:	e8 77 e0 ff ff       	call   800689 <cprintf>
  802612:	83 c4 10             	add    $0x10,%esp
	int r;
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  802615:	bb 00 00 80 00       	mov    $0x800000,%ebx
  80261a:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  802620:	eb 0e                	jmp    802630 <spawn+0x46e>
  802622:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802628:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80262e:	74 5e                	je     80268e <spawn+0x4cc>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_SHARE)) == (PTE_P | PTE_U | PTE_SHARE)))
  802630:	89 d8                	mov    %ebx,%eax
  802632:	c1 e8 16             	shr    $0x16,%eax
  802635:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80263c:	a8 01                	test   $0x1,%al
  80263e:	74 e2                	je     802622 <spawn+0x460>
  802640:	89 da                	mov    %ebx,%edx
  802642:	c1 ea 0c             	shr    $0xc,%edx
  802645:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80264c:	25 05 04 00 00       	and    $0x405,%eax
  802651:	3d 05 04 00 00       	cmp    $0x405,%eax
  802656:	75 ca                	jne    802622 <spawn+0x460>
			if((r = sys_page_map((envid_t)0, (void *)i, child, (void *)i, uvpt[PGNUM(i)] & PTE_SYSCALL)) < 0)
  802658:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80265f:	83 ec 0c             	sub    $0xc,%esp
  802662:	25 07 0e 00 00       	and    $0xe07,%eax
  802667:	50                   	push   %eax
  802668:	53                   	push   %ebx
  802669:	56                   	push   %esi
  80266a:	53                   	push   %ebx
  80266b:	6a 00                	push   $0x0
  80266d:	e8 ab eb ff ff       	call   80121d <sys_page_map>
  802672:	83 c4 20             	add    $0x20,%esp
  802675:	85 c0                	test   %eax,%eax
  802677:	79 a9                	jns    802622 <spawn+0x460>
        		panic("sys_page_map: %e\n", r);
  802679:	50                   	push   %eax
  80267a:	68 8a 3b 80 00       	push   $0x803b8a
  80267f:	68 3b 01 00 00       	push   $0x13b
  802684:	68 61 3b 80 00       	push   $0x803b61
  802689:	e8 05 df ff ff       	call   800593 <_panic>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  80268e:	83 ec 08             	sub    $0x8,%esp
  802691:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802697:	50                   	push   %eax
  802698:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80269e:	e8 40 ec ff ff       	call   8012e3 <sys_env_set_trapframe>
  8026a3:	83 c4 10             	add    $0x10,%esp
  8026a6:	85 c0                	test   %eax,%eax
  8026a8:	78 25                	js     8026cf <spawn+0x50d>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8026aa:	83 ec 08             	sub    $0x8,%esp
  8026ad:	6a 02                	push   $0x2
  8026af:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8026b5:	e8 e7 eb ff ff       	call   8012a1 <sys_env_set_status>
  8026ba:	83 c4 10             	add    $0x10,%esp
  8026bd:	85 c0                	test   %eax,%eax
  8026bf:	78 23                	js     8026e4 <spawn+0x522>
	return child;
  8026c1:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8026c7:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8026cd:	eb 36                	jmp    802705 <spawn+0x543>
		panic("sys_env_set_trapframe: %e", r);
  8026cf:	50                   	push   %eax
  8026d0:	68 9c 3b 80 00       	push   $0x803b9c
  8026d5:	68 8a 00 00 00       	push   $0x8a
  8026da:	68 61 3b 80 00       	push   $0x803b61
  8026df:	e8 af de ff ff       	call   800593 <_panic>
		panic("sys_env_set_status: %e", r);
  8026e4:	50                   	push   %eax
  8026e5:	68 b6 3b 80 00       	push   $0x803bb6
  8026ea:	68 8d 00 00 00       	push   $0x8d
  8026ef:	68 61 3b 80 00       	push   $0x803b61
  8026f4:	e8 9a de ff ff       	call   800593 <_panic>
		return r;
  8026f9:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8026ff:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  802705:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  80270b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80270e:	5b                   	pop    %ebx
  80270f:	5e                   	pop    %esi
  802710:	5f                   	pop    %edi
  802711:	5d                   	pop    %ebp
  802712:	c3                   	ret    
  802713:	89 c7                	mov    %eax,%edi
  802715:	e9 0d fe ff ff       	jmp    802527 <spawn+0x365>
  80271a:	89 c7                	mov    %eax,%edi
  80271c:	e9 06 fe ff ff       	jmp    802527 <spawn+0x365>
  802721:	89 c7                	mov    %eax,%edi
  802723:	e9 ff fd ff ff       	jmp    802527 <spawn+0x365>
		return -E_NO_MEM;
  802728:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  80272d:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802733:	eb d0                	jmp    802705 <spawn+0x543>
	sys_page_unmap(0, UTEMP);
  802735:	83 ec 08             	sub    $0x8,%esp
  802738:	68 00 00 40 00       	push   $0x400000
  80273d:	6a 00                	push   $0x0
  80273f:	e8 1b eb ff ff       	call   80125f <sys_page_unmap>
  802744:	83 c4 10             	add    $0x10,%esp
  802747:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  80274d:	eb b6                	jmp    802705 <spawn+0x543>

0080274f <spawnl>:
{
  80274f:	55                   	push   %ebp
  802750:	89 e5                	mov    %esp,%ebp
  802752:	57                   	push   %edi
  802753:	56                   	push   %esi
  802754:	53                   	push   %ebx
  802755:	83 ec 14             	sub    $0x14,%esp
	cprintf("in %s\n", __FUNCTION__);
  802758:	68 f8 3b 80 00       	push   $0x803bf8
  80275d:	68 9e 35 80 00       	push   $0x80359e
  802762:	e8 22 df ff ff       	call   800689 <cprintf>
	va_start(vl, arg0);
  802767:	8d 55 10             	lea    0x10(%ebp),%edx
	while(va_arg(vl, void *) != NULL)
  80276a:	83 c4 10             	add    $0x10,%esp
	int argc=0;
  80276d:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  802772:	8d 4a 04             	lea    0x4(%edx),%ecx
  802775:	83 3a 00             	cmpl   $0x0,(%edx)
  802778:	74 07                	je     802781 <spawnl+0x32>
		argc++;
  80277a:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  80277d:	89 ca                	mov    %ecx,%edx
  80277f:	eb f1                	jmp    802772 <spawnl+0x23>
	const char *argv[argc+2];
  802781:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  802788:	83 e2 f0             	and    $0xfffffff0,%edx
  80278b:	29 d4                	sub    %edx,%esp
  80278d:	8d 54 24 03          	lea    0x3(%esp),%edx
  802791:	c1 ea 02             	shr    $0x2,%edx
  802794:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  80279b:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  80279d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027a0:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  8027a7:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  8027ae:	00 
	va_start(vl, arg0);
  8027af:	8d 4d 10             	lea    0x10(%ebp),%ecx
  8027b2:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  8027b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b9:	eb 0b                	jmp    8027c6 <spawnl+0x77>
		argv[i+1] = va_arg(vl, const char *);
  8027bb:	83 c0 01             	add    $0x1,%eax
  8027be:	8b 39                	mov    (%ecx),%edi
  8027c0:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  8027c3:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  8027c6:	39 d0                	cmp    %edx,%eax
  8027c8:	75 f1                	jne    8027bb <spawnl+0x6c>
	return spawn(prog, argv);
  8027ca:	83 ec 08             	sub    $0x8,%esp
  8027cd:	56                   	push   %esi
  8027ce:	ff 75 08             	pushl  0x8(%ebp)
  8027d1:	e8 ec f9 ff ff       	call   8021c2 <spawn>
}
  8027d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027d9:	5b                   	pop    %ebx
  8027da:	5e                   	pop    %esi
  8027db:	5f                   	pop    %edi
  8027dc:	5d                   	pop    %ebp
  8027dd:	c3                   	ret    

008027de <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8027de:	55                   	push   %ebp
  8027df:	89 e5                	mov    %esp,%ebp
  8027e1:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8027e4:	68 26 3c 80 00       	push   $0x803c26
  8027e9:	ff 75 0c             	pushl  0xc(%ebp)
  8027ec:	e8 f7 e5 ff ff       	call   800de8 <strcpy>
	return 0;
}
  8027f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f6:	c9                   	leave  
  8027f7:	c3                   	ret    

008027f8 <devsock_close>:
{
  8027f8:	55                   	push   %ebp
  8027f9:	89 e5                	mov    %esp,%ebp
  8027fb:	53                   	push   %ebx
  8027fc:	83 ec 10             	sub    $0x10,%esp
  8027ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  802802:	53                   	push   %ebx
  802803:	e8 6b 09 00 00       	call   803173 <pageref>
  802808:	83 c4 10             	add    $0x10,%esp
		return 0;
  80280b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  802810:	83 f8 01             	cmp    $0x1,%eax
  802813:	74 07                	je     80281c <devsock_close+0x24>
}
  802815:	89 d0                	mov    %edx,%eax
  802817:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80281a:	c9                   	leave  
  80281b:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80281c:	83 ec 0c             	sub    $0xc,%esp
  80281f:	ff 73 0c             	pushl  0xc(%ebx)
  802822:	e8 b9 02 00 00       	call   802ae0 <nsipc_close>
  802827:	89 c2                	mov    %eax,%edx
  802829:	83 c4 10             	add    $0x10,%esp
  80282c:	eb e7                	jmp    802815 <devsock_close+0x1d>

0080282e <devsock_write>:
{
  80282e:	55                   	push   %ebp
  80282f:	89 e5                	mov    %esp,%ebp
  802831:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802834:	6a 00                	push   $0x0
  802836:	ff 75 10             	pushl  0x10(%ebp)
  802839:	ff 75 0c             	pushl  0xc(%ebp)
  80283c:	8b 45 08             	mov    0x8(%ebp),%eax
  80283f:	ff 70 0c             	pushl  0xc(%eax)
  802842:	e8 76 03 00 00       	call   802bbd <nsipc_send>
}
  802847:	c9                   	leave  
  802848:	c3                   	ret    

00802849 <devsock_read>:
{
  802849:	55                   	push   %ebp
  80284a:	89 e5                	mov    %esp,%ebp
  80284c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80284f:	6a 00                	push   $0x0
  802851:	ff 75 10             	pushl  0x10(%ebp)
  802854:	ff 75 0c             	pushl  0xc(%ebp)
  802857:	8b 45 08             	mov    0x8(%ebp),%eax
  80285a:	ff 70 0c             	pushl  0xc(%eax)
  80285d:	e8 ef 02 00 00       	call   802b51 <nsipc_recv>
}
  802862:	c9                   	leave  
  802863:	c3                   	ret    

00802864 <fd2sockid>:
{
  802864:	55                   	push   %ebp
  802865:	89 e5                	mov    %esp,%ebp
  802867:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80286a:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80286d:	52                   	push   %edx
  80286e:	50                   	push   %eax
  80286f:	e8 9b f1 ff ff       	call   801a0f <fd_lookup>
  802874:	83 c4 10             	add    $0x10,%esp
  802877:	85 c0                	test   %eax,%eax
  802879:	78 10                	js     80288b <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80287b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287e:	8b 0d 3c 40 80 00    	mov    0x80403c,%ecx
  802884:	39 08                	cmp    %ecx,(%eax)
  802886:	75 05                	jne    80288d <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802888:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80288b:	c9                   	leave  
  80288c:	c3                   	ret    
		return -E_NOT_SUPP;
  80288d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802892:	eb f7                	jmp    80288b <fd2sockid+0x27>

00802894 <alloc_sockfd>:
{
  802894:	55                   	push   %ebp
  802895:	89 e5                	mov    %esp,%ebp
  802897:	56                   	push   %esi
  802898:	53                   	push   %ebx
  802899:	83 ec 1c             	sub    $0x1c,%esp
  80289c:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80289e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028a1:	50                   	push   %eax
  8028a2:	e8 16 f1 ff ff       	call   8019bd <fd_alloc>
  8028a7:	89 c3                	mov    %eax,%ebx
  8028a9:	83 c4 10             	add    $0x10,%esp
  8028ac:	85 c0                	test   %eax,%eax
  8028ae:	78 43                	js     8028f3 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8028b0:	83 ec 04             	sub    $0x4,%esp
  8028b3:	68 07 04 00 00       	push   $0x407
  8028b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8028bb:	6a 00                	push   $0x0
  8028bd:	e8 18 e9 ff ff       	call   8011da <sys_page_alloc>
  8028c2:	89 c3                	mov    %eax,%ebx
  8028c4:	83 c4 10             	add    $0x10,%esp
  8028c7:	85 c0                	test   %eax,%eax
  8028c9:	78 28                	js     8028f3 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8028cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ce:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8028d4:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8028d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8028e0:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8028e3:	83 ec 0c             	sub    $0xc,%esp
  8028e6:	50                   	push   %eax
  8028e7:	e8 aa f0 ff ff       	call   801996 <fd2num>
  8028ec:	89 c3                	mov    %eax,%ebx
  8028ee:	83 c4 10             	add    $0x10,%esp
  8028f1:	eb 0c                	jmp    8028ff <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8028f3:	83 ec 0c             	sub    $0xc,%esp
  8028f6:	56                   	push   %esi
  8028f7:	e8 e4 01 00 00       	call   802ae0 <nsipc_close>
		return r;
  8028fc:	83 c4 10             	add    $0x10,%esp
}
  8028ff:	89 d8                	mov    %ebx,%eax
  802901:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802904:	5b                   	pop    %ebx
  802905:	5e                   	pop    %esi
  802906:	5d                   	pop    %ebp
  802907:	c3                   	ret    

00802908 <accept>:
{
  802908:	55                   	push   %ebp
  802909:	89 e5                	mov    %esp,%ebp
  80290b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80290e:	8b 45 08             	mov    0x8(%ebp),%eax
  802911:	e8 4e ff ff ff       	call   802864 <fd2sockid>
  802916:	85 c0                	test   %eax,%eax
  802918:	78 1b                	js     802935 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80291a:	83 ec 04             	sub    $0x4,%esp
  80291d:	ff 75 10             	pushl  0x10(%ebp)
  802920:	ff 75 0c             	pushl  0xc(%ebp)
  802923:	50                   	push   %eax
  802924:	e8 0e 01 00 00       	call   802a37 <nsipc_accept>
  802929:	83 c4 10             	add    $0x10,%esp
  80292c:	85 c0                	test   %eax,%eax
  80292e:	78 05                	js     802935 <accept+0x2d>
	return alloc_sockfd(r);
  802930:	e8 5f ff ff ff       	call   802894 <alloc_sockfd>
}
  802935:	c9                   	leave  
  802936:	c3                   	ret    

00802937 <bind>:
{
  802937:	55                   	push   %ebp
  802938:	89 e5                	mov    %esp,%ebp
  80293a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80293d:	8b 45 08             	mov    0x8(%ebp),%eax
  802940:	e8 1f ff ff ff       	call   802864 <fd2sockid>
  802945:	85 c0                	test   %eax,%eax
  802947:	78 12                	js     80295b <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802949:	83 ec 04             	sub    $0x4,%esp
  80294c:	ff 75 10             	pushl  0x10(%ebp)
  80294f:	ff 75 0c             	pushl  0xc(%ebp)
  802952:	50                   	push   %eax
  802953:	e8 31 01 00 00       	call   802a89 <nsipc_bind>
  802958:	83 c4 10             	add    $0x10,%esp
}
  80295b:	c9                   	leave  
  80295c:	c3                   	ret    

0080295d <shutdown>:
{
  80295d:	55                   	push   %ebp
  80295e:	89 e5                	mov    %esp,%ebp
  802960:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802963:	8b 45 08             	mov    0x8(%ebp),%eax
  802966:	e8 f9 fe ff ff       	call   802864 <fd2sockid>
  80296b:	85 c0                	test   %eax,%eax
  80296d:	78 0f                	js     80297e <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80296f:	83 ec 08             	sub    $0x8,%esp
  802972:	ff 75 0c             	pushl  0xc(%ebp)
  802975:	50                   	push   %eax
  802976:	e8 43 01 00 00       	call   802abe <nsipc_shutdown>
  80297b:	83 c4 10             	add    $0x10,%esp
}
  80297e:	c9                   	leave  
  80297f:	c3                   	ret    

00802980 <connect>:
{
  802980:	55                   	push   %ebp
  802981:	89 e5                	mov    %esp,%ebp
  802983:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802986:	8b 45 08             	mov    0x8(%ebp),%eax
  802989:	e8 d6 fe ff ff       	call   802864 <fd2sockid>
  80298e:	85 c0                	test   %eax,%eax
  802990:	78 12                	js     8029a4 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802992:	83 ec 04             	sub    $0x4,%esp
  802995:	ff 75 10             	pushl  0x10(%ebp)
  802998:	ff 75 0c             	pushl  0xc(%ebp)
  80299b:	50                   	push   %eax
  80299c:	e8 59 01 00 00       	call   802afa <nsipc_connect>
  8029a1:	83 c4 10             	add    $0x10,%esp
}
  8029a4:	c9                   	leave  
  8029a5:	c3                   	ret    

008029a6 <listen>:
{
  8029a6:	55                   	push   %ebp
  8029a7:	89 e5                	mov    %esp,%ebp
  8029a9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8029ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8029af:	e8 b0 fe ff ff       	call   802864 <fd2sockid>
  8029b4:	85 c0                	test   %eax,%eax
  8029b6:	78 0f                	js     8029c7 <listen+0x21>
	return nsipc_listen(r, backlog);
  8029b8:	83 ec 08             	sub    $0x8,%esp
  8029bb:	ff 75 0c             	pushl  0xc(%ebp)
  8029be:	50                   	push   %eax
  8029bf:	e8 6b 01 00 00       	call   802b2f <nsipc_listen>
  8029c4:	83 c4 10             	add    $0x10,%esp
}
  8029c7:	c9                   	leave  
  8029c8:	c3                   	ret    

008029c9 <socket>:

int
socket(int domain, int type, int protocol)
{
  8029c9:	55                   	push   %ebp
  8029ca:	89 e5                	mov    %esp,%ebp
  8029cc:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8029cf:	ff 75 10             	pushl  0x10(%ebp)
  8029d2:	ff 75 0c             	pushl  0xc(%ebp)
  8029d5:	ff 75 08             	pushl  0x8(%ebp)
  8029d8:	e8 3e 02 00 00       	call   802c1b <nsipc_socket>
  8029dd:	83 c4 10             	add    $0x10,%esp
  8029e0:	85 c0                	test   %eax,%eax
  8029e2:	78 05                	js     8029e9 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8029e4:	e8 ab fe ff ff       	call   802894 <alloc_sockfd>
}
  8029e9:	c9                   	leave  
  8029ea:	c3                   	ret    

008029eb <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8029eb:	55                   	push   %ebp
  8029ec:	89 e5                	mov    %esp,%ebp
  8029ee:	53                   	push   %ebx
  8029ef:	83 ec 04             	sub    $0x4,%esp
  8029f2:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8029f4:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8029fb:	74 26                	je     802a23 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8029fd:	6a 07                	push   $0x7
  8029ff:	68 00 70 80 00       	push   $0x807000
  802a04:	53                   	push   %ebx
  802a05:	ff 35 04 50 80 00    	pushl  0x805004
  802a0b:	e8 d0 06 00 00       	call   8030e0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802a10:	83 c4 0c             	add    $0xc,%esp
  802a13:	6a 00                	push   $0x0
  802a15:	6a 00                	push   $0x0
  802a17:	6a 00                	push   $0x0
  802a19:	e8 59 06 00 00       	call   803077 <ipc_recv>
}
  802a1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802a21:	c9                   	leave  
  802a22:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802a23:	83 ec 0c             	sub    $0xc,%esp
  802a26:	6a 02                	push   $0x2
  802a28:	e8 0b 07 00 00       	call   803138 <ipc_find_env>
  802a2d:	a3 04 50 80 00       	mov    %eax,0x805004
  802a32:	83 c4 10             	add    $0x10,%esp
  802a35:	eb c6                	jmp    8029fd <nsipc+0x12>

00802a37 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802a37:	55                   	push   %ebp
  802a38:	89 e5                	mov    %esp,%ebp
  802a3a:	56                   	push   %esi
  802a3b:	53                   	push   %ebx
  802a3c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a42:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802a47:	8b 06                	mov    (%esi),%eax
  802a49:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802a4e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a53:	e8 93 ff ff ff       	call   8029eb <nsipc>
  802a58:	89 c3                	mov    %eax,%ebx
  802a5a:	85 c0                	test   %eax,%eax
  802a5c:	79 09                	jns    802a67 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802a5e:	89 d8                	mov    %ebx,%eax
  802a60:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a63:	5b                   	pop    %ebx
  802a64:	5e                   	pop    %esi
  802a65:	5d                   	pop    %ebp
  802a66:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802a67:	83 ec 04             	sub    $0x4,%esp
  802a6a:	ff 35 10 70 80 00    	pushl  0x807010
  802a70:	68 00 70 80 00       	push   $0x807000
  802a75:	ff 75 0c             	pushl  0xc(%ebp)
  802a78:	e8 f9 e4 ff ff       	call   800f76 <memmove>
		*addrlen = ret->ret_addrlen;
  802a7d:	a1 10 70 80 00       	mov    0x807010,%eax
  802a82:	89 06                	mov    %eax,(%esi)
  802a84:	83 c4 10             	add    $0x10,%esp
	return r;
  802a87:	eb d5                	jmp    802a5e <nsipc_accept+0x27>

00802a89 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802a89:	55                   	push   %ebp
  802a8a:	89 e5                	mov    %esp,%ebp
  802a8c:	53                   	push   %ebx
  802a8d:	83 ec 08             	sub    $0x8,%esp
  802a90:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802a93:	8b 45 08             	mov    0x8(%ebp),%eax
  802a96:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802a9b:	53                   	push   %ebx
  802a9c:	ff 75 0c             	pushl  0xc(%ebp)
  802a9f:	68 04 70 80 00       	push   $0x807004
  802aa4:	e8 cd e4 ff ff       	call   800f76 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802aa9:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802aaf:	b8 02 00 00 00       	mov    $0x2,%eax
  802ab4:	e8 32 ff ff ff       	call   8029eb <nsipc>
}
  802ab9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802abc:	c9                   	leave  
  802abd:	c3                   	ret    

00802abe <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802abe:	55                   	push   %ebp
  802abf:	89 e5                	mov    %esp,%ebp
  802ac1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802acc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802acf:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802ad4:	b8 03 00 00 00       	mov    $0x3,%eax
  802ad9:	e8 0d ff ff ff       	call   8029eb <nsipc>
}
  802ade:	c9                   	leave  
  802adf:	c3                   	ret    

00802ae0 <nsipc_close>:

int
nsipc_close(int s)
{
  802ae0:	55                   	push   %ebp
  802ae1:	89 e5                	mov    %esp,%ebp
  802ae3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802aee:	b8 04 00 00 00       	mov    $0x4,%eax
  802af3:	e8 f3 fe ff ff       	call   8029eb <nsipc>
}
  802af8:	c9                   	leave  
  802af9:	c3                   	ret    

00802afa <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802afa:	55                   	push   %ebp
  802afb:	89 e5                	mov    %esp,%ebp
  802afd:	53                   	push   %ebx
  802afe:	83 ec 08             	sub    $0x8,%esp
  802b01:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802b04:	8b 45 08             	mov    0x8(%ebp),%eax
  802b07:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802b0c:	53                   	push   %ebx
  802b0d:	ff 75 0c             	pushl  0xc(%ebp)
  802b10:	68 04 70 80 00       	push   $0x807004
  802b15:	e8 5c e4 ff ff       	call   800f76 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802b1a:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802b20:	b8 05 00 00 00       	mov    $0x5,%eax
  802b25:	e8 c1 fe ff ff       	call   8029eb <nsipc>
}
  802b2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b2d:	c9                   	leave  
  802b2e:	c3                   	ret    

00802b2f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802b2f:	55                   	push   %ebp
  802b30:	89 e5                	mov    %esp,%ebp
  802b32:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802b35:	8b 45 08             	mov    0x8(%ebp),%eax
  802b38:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802b3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b40:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802b45:	b8 06 00 00 00       	mov    $0x6,%eax
  802b4a:	e8 9c fe ff ff       	call   8029eb <nsipc>
}
  802b4f:	c9                   	leave  
  802b50:	c3                   	ret    

00802b51 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802b51:	55                   	push   %ebp
  802b52:	89 e5                	mov    %esp,%ebp
  802b54:	56                   	push   %esi
  802b55:	53                   	push   %ebx
  802b56:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802b59:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802b61:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802b67:	8b 45 14             	mov    0x14(%ebp),%eax
  802b6a:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802b6f:	b8 07 00 00 00       	mov    $0x7,%eax
  802b74:	e8 72 fe ff ff       	call   8029eb <nsipc>
  802b79:	89 c3                	mov    %eax,%ebx
  802b7b:	85 c0                	test   %eax,%eax
  802b7d:	78 1f                	js     802b9e <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802b7f:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802b84:	7f 21                	jg     802ba7 <nsipc_recv+0x56>
  802b86:	39 c6                	cmp    %eax,%esi
  802b88:	7c 1d                	jl     802ba7 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802b8a:	83 ec 04             	sub    $0x4,%esp
  802b8d:	50                   	push   %eax
  802b8e:	68 00 70 80 00       	push   $0x807000
  802b93:	ff 75 0c             	pushl  0xc(%ebp)
  802b96:	e8 db e3 ff ff       	call   800f76 <memmove>
  802b9b:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802b9e:	89 d8                	mov    %ebx,%eax
  802ba0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802ba3:	5b                   	pop    %ebx
  802ba4:	5e                   	pop    %esi
  802ba5:	5d                   	pop    %ebp
  802ba6:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802ba7:	68 32 3c 80 00       	push   $0x803c32
  802bac:	68 1b 3b 80 00       	push   $0x803b1b
  802bb1:	6a 62                	push   $0x62
  802bb3:	68 47 3c 80 00       	push   $0x803c47
  802bb8:	e8 d6 d9 ff ff       	call   800593 <_panic>

00802bbd <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802bbd:	55                   	push   %ebp
  802bbe:	89 e5                	mov    %esp,%ebp
  802bc0:	53                   	push   %ebx
  802bc1:	83 ec 04             	sub    $0x4,%esp
  802bc4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bca:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802bcf:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802bd5:	7f 2e                	jg     802c05 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802bd7:	83 ec 04             	sub    $0x4,%esp
  802bda:	53                   	push   %ebx
  802bdb:	ff 75 0c             	pushl  0xc(%ebp)
  802bde:	68 0c 70 80 00       	push   $0x80700c
  802be3:	e8 8e e3 ff ff       	call   800f76 <memmove>
	nsipcbuf.send.req_size = size;
  802be8:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802bee:	8b 45 14             	mov    0x14(%ebp),%eax
  802bf1:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802bf6:	b8 08 00 00 00       	mov    $0x8,%eax
  802bfb:	e8 eb fd ff ff       	call   8029eb <nsipc>
}
  802c00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802c03:	c9                   	leave  
  802c04:	c3                   	ret    
	assert(size < 1600);
  802c05:	68 53 3c 80 00       	push   $0x803c53
  802c0a:	68 1b 3b 80 00       	push   $0x803b1b
  802c0f:	6a 6d                	push   $0x6d
  802c11:	68 47 3c 80 00       	push   $0x803c47
  802c16:	e8 78 d9 ff ff       	call   800593 <_panic>

00802c1b <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802c1b:	55                   	push   %ebp
  802c1c:	89 e5                	mov    %esp,%ebp
  802c1e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802c21:	8b 45 08             	mov    0x8(%ebp),%eax
  802c24:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802c29:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c2c:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802c31:	8b 45 10             	mov    0x10(%ebp),%eax
  802c34:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802c39:	b8 09 00 00 00       	mov    $0x9,%eax
  802c3e:	e8 a8 fd ff ff       	call   8029eb <nsipc>
}
  802c43:	c9                   	leave  
  802c44:	c3                   	ret    

00802c45 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802c45:	55                   	push   %ebp
  802c46:	89 e5                	mov    %esp,%ebp
  802c48:	56                   	push   %esi
  802c49:	53                   	push   %ebx
  802c4a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802c4d:	83 ec 0c             	sub    $0xc,%esp
  802c50:	ff 75 08             	pushl  0x8(%ebp)
  802c53:	e8 4e ed ff ff       	call   8019a6 <fd2data>
  802c58:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802c5a:	83 c4 08             	add    $0x8,%esp
  802c5d:	68 5f 3c 80 00       	push   $0x803c5f
  802c62:	53                   	push   %ebx
  802c63:	e8 80 e1 ff ff       	call   800de8 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802c68:	8b 46 04             	mov    0x4(%esi),%eax
  802c6b:	2b 06                	sub    (%esi),%eax
  802c6d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802c73:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802c7a:	00 00 00 
	stat->st_dev = &devpipe;
  802c7d:	c7 83 88 00 00 00 58 	movl   $0x804058,0x88(%ebx)
  802c84:	40 80 00 
	return 0;
}
  802c87:	b8 00 00 00 00       	mov    $0x0,%eax
  802c8c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802c8f:	5b                   	pop    %ebx
  802c90:	5e                   	pop    %esi
  802c91:	5d                   	pop    %ebp
  802c92:	c3                   	ret    

00802c93 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802c93:	55                   	push   %ebp
  802c94:	89 e5                	mov    %esp,%ebp
  802c96:	53                   	push   %ebx
  802c97:	83 ec 0c             	sub    $0xc,%esp
  802c9a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802c9d:	53                   	push   %ebx
  802c9e:	6a 00                	push   $0x0
  802ca0:	e8 ba e5 ff ff       	call   80125f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802ca5:	89 1c 24             	mov    %ebx,(%esp)
  802ca8:	e8 f9 ec ff ff       	call   8019a6 <fd2data>
  802cad:	83 c4 08             	add    $0x8,%esp
  802cb0:	50                   	push   %eax
  802cb1:	6a 00                	push   $0x0
  802cb3:	e8 a7 e5 ff ff       	call   80125f <sys_page_unmap>
}
  802cb8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802cbb:	c9                   	leave  
  802cbc:	c3                   	ret    

00802cbd <_pipeisclosed>:
{
  802cbd:	55                   	push   %ebp
  802cbe:	89 e5                	mov    %esp,%ebp
  802cc0:	57                   	push   %edi
  802cc1:	56                   	push   %esi
  802cc2:	53                   	push   %ebx
  802cc3:	83 ec 1c             	sub    $0x1c,%esp
  802cc6:	89 c7                	mov    %eax,%edi
  802cc8:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802cca:	a1 08 50 80 00       	mov    0x805008,%eax
  802ccf:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802cd2:	83 ec 0c             	sub    $0xc,%esp
  802cd5:	57                   	push   %edi
  802cd6:	e8 98 04 00 00       	call   803173 <pageref>
  802cdb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802cde:	89 34 24             	mov    %esi,(%esp)
  802ce1:	e8 8d 04 00 00       	call   803173 <pageref>
		nn = thisenv->env_runs;
  802ce6:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802cec:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802cef:	83 c4 10             	add    $0x10,%esp
  802cf2:	39 cb                	cmp    %ecx,%ebx
  802cf4:	74 1b                	je     802d11 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802cf6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802cf9:	75 cf                	jne    802cca <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802cfb:	8b 42 58             	mov    0x58(%edx),%eax
  802cfe:	6a 01                	push   $0x1
  802d00:	50                   	push   %eax
  802d01:	53                   	push   %ebx
  802d02:	68 66 3c 80 00       	push   $0x803c66
  802d07:	e8 7d d9 ff ff       	call   800689 <cprintf>
  802d0c:	83 c4 10             	add    $0x10,%esp
  802d0f:	eb b9                	jmp    802cca <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802d11:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802d14:	0f 94 c0             	sete   %al
  802d17:	0f b6 c0             	movzbl %al,%eax
}
  802d1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d1d:	5b                   	pop    %ebx
  802d1e:	5e                   	pop    %esi
  802d1f:	5f                   	pop    %edi
  802d20:	5d                   	pop    %ebp
  802d21:	c3                   	ret    

00802d22 <devpipe_write>:
{
  802d22:	55                   	push   %ebp
  802d23:	89 e5                	mov    %esp,%ebp
  802d25:	57                   	push   %edi
  802d26:	56                   	push   %esi
  802d27:	53                   	push   %ebx
  802d28:	83 ec 28             	sub    $0x28,%esp
  802d2b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802d2e:	56                   	push   %esi
  802d2f:	e8 72 ec ff ff       	call   8019a6 <fd2data>
  802d34:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802d36:	83 c4 10             	add    $0x10,%esp
  802d39:	bf 00 00 00 00       	mov    $0x0,%edi
  802d3e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802d41:	74 4f                	je     802d92 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802d43:	8b 43 04             	mov    0x4(%ebx),%eax
  802d46:	8b 0b                	mov    (%ebx),%ecx
  802d48:	8d 51 20             	lea    0x20(%ecx),%edx
  802d4b:	39 d0                	cmp    %edx,%eax
  802d4d:	72 14                	jb     802d63 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802d4f:	89 da                	mov    %ebx,%edx
  802d51:	89 f0                	mov    %esi,%eax
  802d53:	e8 65 ff ff ff       	call   802cbd <_pipeisclosed>
  802d58:	85 c0                	test   %eax,%eax
  802d5a:	75 3b                	jne    802d97 <devpipe_write+0x75>
			sys_yield();
  802d5c:	e8 5a e4 ff ff       	call   8011bb <sys_yield>
  802d61:	eb e0                	jmp    802d43 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802d63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802d66:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802d6a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802d6d:	89 c2                	mov    %eax,%edx
  802d6f:	c1 fa 1f             	sar    $0x1f,%edx
  802d72:	89 d1                	mov    %edx,%ecx
  802d74:	c1 e9 1b             	shr    $0x1b,%ecx
  802d77:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802d7a:	83 e2 1f             	and    $0x1f,%edx
  802d7d:	29 ca                	sub    %ecx,%edx
  802d7f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802d83:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802d87:	83 c0 01             	add    $0x1,%eax
  802d8a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802d8d:	83 c7 01             	add    $0x1,%edi
  802d90:	eb ac                	jmp    802d3e <devpipe_write+0x1c>
	return i;
  802d92:	8b 45 10             	mov    0x10(%ebp),%eax
  802d95:	eb 05                	jmp    802d9c <devpipe_write+0x7a>
				return 0;
  802d97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d9f:	5b                   	pop    %ebx
  802da0:	5e                   	pop    %esi
  802da1:	5f                   	pop    %edi
  802da2:	5d                   	pop    %ebp
  802da3:	c3                   	ret    

00802da4 <devpipe_read>:
{
  802da4:	55                   	push   %ebp
  802da5:	89 e5                	mov    %esp,%ebp
  802da7:	57                   	push   %edi
  802da8:	56                   	push   %esi
  802da9:	53                   	push   %ebx
  802daa:	83 ec 18             	sub    $0x18,%esp
  802dad:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802db0:	57                   	push   %edi
  802db1:	e8 f0 eb ff ff       	call   8019a6 <fd2data>
  802db6:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802db8:	83 c4 10             	add    $0x10,%esp
  802dbb:	be 00 00 00 00       	mov    $0x0,%esi
  802dc0:	3b 75 10             	cmp    0x10(%ebp),%esi
  802dc3:	75 14                	jne    802dd9 <devpipe_read+0x35>
	return i;
  802dc5:	8b 45 10             	mov    0x10(%ebp),%eax
  802dc8:	eb 02                	jmp    802dcc <devpipe_read+0x28>
				return i;
  802dca:	89 f0                	mov    %esi,%eax
}
  802dcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802dcf:	5b                   	pop    %ebx
  802dd0:	5e                   	pop    %esi
  802dd1:	5f                   	pop    %edi
  802dd2:	5d                   	pop    %ebp
  802dd3:	c3                   	ret    
			sys_yield();
  802dd4:	e8 e2 e3 ff ff       	call   8011bb <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802dd9:	8b 03                	mov    (%ebx),%eax
  802ddb:	3b 43 04             	cmp    0x4(%ebx),%eax
  802dde:	75 18                	jne    802df8 <devpipe_read+0x54>
			if (i > 0)
  802de0:	85 f6                	test   %esi,%esi
  802de2:	75 e6                	jne    802dca <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802de4:	89 da                	mov    %ebx,%edx
  802de6:	89 f8                	mov    %edi,%eax
  802de8:	e8 d0 fe ff ff       	call   802cbd <_pipeisclosed>
  802ded:	85 c0                	test   %eax,%eax
  802def:	74 e3                	je     802dd4 <devpipe_read+0x30>
				return 0;
  802df1:	b8 00 00 00 00       	mov    $0x0,%eax
  802df6:	eb d4                	jmp    802dcc <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802df8:	99                   	cltd   
  802df9:	c1 ea 1b             	shr    $0x1b,%edx
  802dfc:	01 d0                	add    %edx,%eax
  802dfe:	83 e0 1f             	and    $0x1f,%eax
  802e01:	29 d0                	sub    %edx,%eax
  802e03:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802e08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802e0b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802e0e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802e11:	83 c6 01             	add    $0x1,%esi
  802e14:	eb aa                	jmp    802dc0 <devpipe_read+0x1c>

00802e16 <pipe>:
{
  802e16:	55                   	push   %ebp
  802e17:	89 e5                	mov    %esp,%ebp
  802e19:	56                   	push   %esi
  802e1a:	53                   	push   %ebx
  802e1b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802e1e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e21:	50                   	push   %eax
  802e22:	e8 96 eb ff ff       	call   8019bd <fd_alloc>
  802e27:	89 c3                	mov    %eax,%ebx
  802e29:	83 c4 10             	add    $0x10,%esp
  802e2c:	85 c0                	test   %eax,%eax
  802e2e:	0f 88 23 01 00 00    	js     802f57 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e34:	83 ec 04             	sub    $0x4,%esp
  802e37:	68 07 04 00 00       	push   $0x407
  802e3c:	ff 75 f4             	pushl  -0xc(%ebp)
  802e3f:	6a 00                	push   $0x0
  802e41:	e8 94 e3 ff ff       	call   8011da <sys_page_alloc>
  802e46:	89 c3                	mov    %eax,%ebx
  802e48:	83 c4 10             	add    $0x10,%esp
  802e4b:	85 c0                	test   %eax,%eax
  802e4d:	0f 88 04 01 00 00    	js     802f57 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802e53:	83 ec 0c             	sub    $0xc,%esp
  802e56:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802e59:	50                   	push   %eax
  802e5a:	e8 5e eb ff ff       	call   8019bd <fd_alloc>
  802e5f:	89 c3                	mov    %eax,%ebx
  802e61:	83 c4 10             	add    $0x10,%esp
  802e64:	85 c0                	test   %eax,%eax
  802e66:	0f 88 db 00 00 00    	js     802f47 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e6c:	83 ec 04             	sub    $0x4,%esp
  802e6f:	68 07 04 00 00       	push   $0x407
  802e74:	ff 75 f0             	pushl  -0x10(%ebp)
  802e77:	6a 00                	push   $0x0
  802e79:	e8 5c e3 ff ff       	call   8011da <sys_page_alloc>
  802e7e:	89 c3                	mov    %eax,%ebx
  802e80:	83 c4 10             	add    $0x10,%esp
  802e83:	85 c0                	test   %eax,%eax
  802e85:	0f 88 bc 00 00 00    	js     802f47 <pipe+0x131>
	va = fd2data(fd0);
  802e8b:	83 ec 0c             	sub    $0xc,%esp
  802e8e:	ff 75 f4             	pushl  -0xc(%ebp)
  802e91:	e8 10 eb ff ff       	call   8019a6 <fd2data>
  802e96:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e98:	83 c4 0c             	add    $0xc,%esp
  802e9b:	68 07 04 00 00       	push   $0x407
  802ea0:	50                   	push   %eax
  802ea1:	6a 00                	push   $0x0
  802ea3:	e8 32 e3 ff ff       	call   8011da <sys_page_alloc>
  802ea8:	89 c3                	mov    %eax,%ebx
  802eaa:	83 c4 10             	add    $0x10,%esp
  802ead:	85 c0                	test   %eax,%eax
  802eaf:	0f 88 82 00 00 00    	js     802f37 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802eb5:	83 ec 0c             	sub    $0xc,%esp
  802eb8:	ff 75 f0             	pushl  -0x10(%ebp)
  802ebb:	e8 e6 ea ff ff       	call   8019a6 <fd2data>
  802ec0:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802ec7:	50                   	push   %eax
  802ec8:	6a 00                	push   $0x0
  802eca:	56                   	push   %esi
  802ecb:	6a 00                	push   $0x0
  802ecd:	e8 4b e3 ff ff       	call   80121d <sys_page_map>
  802ed2:	89 c3                	mov    %eax,%ebx
  802ed4:	83 c4 20             	add    $0x20,%esp
  802ed7:	85 c0                	test   %eax,%eax
  802ed9:	78 4e                	js     802f29 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802edb:	a1 58 40 80 00       	mov    0x804058,%eax
  802ee0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ee3:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802ee5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ee8:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802eef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ef2:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802ef4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802efe:	83 ec 0c             	sub    $0xc,%esp
  802f01:	ff 75 f4             	pushl  -0xc(%ebp)
  802f04:	e8 8d ea ff ff       	call   801996 <fd2num>
  802f09:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802f0c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802f0e:	83 c4 04             	add    $0x4,%esp
  802f11:	ff 75 f0             	pushl  -0x10(%ebp)
  802f14:	e8 7d ea ff ff       	call   801996 <fd2num>
  802f19:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802f1c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802f1f:	83 c4 10             	add    $0x10,%esp
  802f22:	bb 00 00 00 00       	mov    $0x0,%ebx
  802f27:	eb 2e                	jmp    802f57 <pipe+0x141>
	sys_page_unmap(0, va);
  802f29:	83 ec 08             	sub    $0x8,%esp
  802f2c:	56                   	push   %esi
  802f2d:	6a 00                	push   $0x0
  802f2f:	e8 2b e3 ff ff       	call   80125f <sys_page_unmap>
  802f34:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802f37:	83 ec 08             	sub    $0x8,%esp
  802f3a:	ff 75 f0             	pushl  -0x10(%ebp)
  802f3d:	6a 00                	push   $0x0
  802f3f:	e8 1b e3 ff ff       	call   80125f <sys_page_unmap>
  802f44:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802f47:	83 ec 08             	sub    $0x8,%esp
  802f4a:	ff 75 f4             	pushl  -0xc(%ebp)
  802f4d:	6a 00                	push   $0x0
  802f4f:	e8 0b e3 ff ff       	call   80125f <sys_page_unmap>
  802f54:	83 c4 10             	add    $0x10,%esp
}
  802f57:	89 d8                	mov    %ebx,%eax
  802f59:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f5c:	5b                   	pop    %ebx
  802f5d:	5e                   	pop    %esi
  802f5e:	5d                   	pop    %ebp
  802f5f:	c3                   	ret    

00802f60 <pipeisclosed>:
{
  802f60:	55                   	push   %ebp
  802f61:	89 e5                	mov    %esp,%ebp
  802f63:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f66:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f69:	50                   	push   %eax
  802f6a:	ff 75 08             	pushl  0x8(%ebp)
  802f6d:	e8 9d ea ff ff       	call   801a0f <fd_lookup>
  802f72:	83 c4 10             	add    $0x10,%esp
  802f75:	85 c0                	test   %eax,%eax
  802f77:	78 18                	js     802f91 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802f79:	83 ec 0c             	sub    $0xc,%esp
  802f7c:	ff 75 f4             	pushl  -0xc(%ebp)
  802f7f:	e8 22 ea ff ff       	call   8019a6 <fd2data>
	return _pipeisclosed(fd, p);
  802f84:	89 c2                	mov    %eax,%edx
  802f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f89:	e8 2f fd ff ff       	call   802cbd <_pipeisclosed>
  802f8e:	83 c4 10             	add    $0x10,%esp
}
  802f91:	c9                   	leave  
  802f92:	c3                   	ret    

00802f93 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802f93:	55                   	push   %ebp
  802f94:	89 e5                	mov    %esp,%ebp
  802f96:	56                   	push   %esi
  802f97:	53                   	push   %ebx
  802f98:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802f9b:	85 f6                	test   %esi,%esi
  802f9d:	74 13                	je     802fb2 <wait+0x1f>
	e = &envs[ENVX(envid)];
  802f9f:	89 f3                	mov    %esi,%ebx
  802fa1:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802fa7:	c1 e3 07             	shl    $0x7,%ebx
  802faa:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802fb0:	eb 1b                	jmp    802fcd <wait+0x3a>
	assert(envid != 0);
  802fb2:	68 7e 3c 80 00       	push   $0x803c7e
  802fb7:	68 1b 3b 80 00       	push   $0x803b1b
  802fbc:	6a 09                	push   $0x9
  802fbe:	68 89 3c 80 00       	push   $0x803c89
  802fc3:	e8 cb d5 ff ff       	call   800593 <_panic>
		sys_yield();
  802fc8:	e8 ee e1 ff ff       	call   8011bb <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802fcd:	8b 43 48             	mov    0x48(%ebx),%eax
  802fd0:	39 f0                	cmp    %esi,%eax
  802fd2:	75 07                	jne    802fdb <wait+0x48>
  802fd4:	8b 43 54             	mov    0x54(%ebx),%eax
  802fd7:	85 c0                	test   %eax,%eax
  802fd9:	75 ed                	jne    802fc8 <wait+0x35>
}
  802fdb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802fde:	5b                   	pop    %ebx
  802fdf:	5e                   	pop    %esi
  802fe0:	5d                   	pop    %ebp
  802fe1:	c3                   	ret    

00802fe2 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802fe2:	55                   	push   %ebp
  802fe3:	89 e5                	mov    %esp,%ebp
  802fe5:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802fe8:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802fef:	74 0a                	je     802ffb <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff4:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802ff9:	c9                   	leave  
  802ffa:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802ffb:	83 ec 04             	sub    $0x4,%esp
  802ffe:	6a 07                	push   $0x7
  803000:	68 00 f0 bf ee       	push   $0xeebff000
  803005:	6a 00                	push   $0x0
  803007:	e8 ce e1 ff ff       	call   8011da <sys_page_alloc>
		if(r < 0)
  80300c:	83 c4 10             	add    $0x10,%esp
  80300f:	85 c0                	test   %eax,%eax
  803011:	78 2a                	js     80303d <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  803013:	83 ec 08             	sub    $0x8,%esp
  803016:	68 51 30 80 00       	push   $0x803051
  80301b:	6a 00                	push   $0x0
  80301d:	e8 03 e3 ff ff       	call   801325 <sys_env_set_pgfault_upcall>
		if(r < 0)
  803022:	83 c4 10             	add    $0x10,%esp
  803025:	85 c0                	test   %eax,%eax
  803027:	79 c8                	jns    802ff1 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  803029:	83 ec 04             	sub    $0x4,%esp
  80302c:	68 c4 3c 80 00       	push   $0x803cc4
  803031:	6a 25                	push   $0x25
  803033:	68 00 3d 80 00       	push   $0x803d00
  803038:	e8 56 d5 ff ff       	call   800593 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  80303d:	83 ec 04             	sub    $0x4,%esp
  803040:	68 94 3c 80 00       	push   $0x803c94
  803045:	6a 22                	push   $0x22
  803047:	68 00 3d 80 00       	push   $0x803d00
  80304c:	e8 42 d5 ff ff       	call   800593 <_panic>

00803051 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  803051:	54                   	push   %esp
	movl _pgfault_handler, %eax
  803052:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  803057:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  803059:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  80305c:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  803060:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  803064:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  803067:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  803069:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  80306d:	83 c4 08             	add    $0x8,%esp
	popal
  803070:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  803071:	83 c4 04             	add    $0x4,%esp
	popfl
  803074:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  803075:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  803076:	c3                   	ret    

00803077 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803077:	55                   	push   %ebp
  803078:	89 e5                	mov    %esp,%ebp
  80307a:	56                   	push   %esi
  80307b:	53                   	push   %ebx
  80307c:	8b 75 08             	mov    0x8(%ebp),%esi
  80307f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803082:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  803085:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  803087:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80308c:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80308f:	83 ec 0c             	sub    $0xc,%esp
  803092:	50                   	push   %eax
  803093:	e8 f2 e2 ff ff       	call   80138a <sys_ipc_recv>
	if(ret < 0){
  803098:	83 c4 10             	add    $0x10,%esp
  80309b:	85 c0                	test   %eax,%eax
  80309d:	78 2b                	js     8030ca <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80309f:	85 f6                	test   %esi,%esi
  8030a1:	74 0a                	je     8030ad <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8030a3:	a1 08 50 80 00       	mov    0x805008,%eax
  8030a8:	8b 40 74             	mov    0x74(%eax),%eax
  8030ab:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8030ad:	85 db                	test   %ebx,%ebx
  8030af:	74 0a                	je     8030bb <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8030b1:	a1 08 50 80 00       	mov    0x805008,%eax
  8030b6:	8b 40 78             	mov    0x78(%eax),%eax
  8030b9:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8030bb:	a1 08 50 80 00       	mov    0x805008,%eax
  8030c0:	8b 40 70             	mov    0x70(%eax),%eax
}
  8030c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8030c6:	5b                   	pop    %ebx
  8030c7:	5e                   	pop    %esi
  8030c8:	5d                   	pop    %ebp
  8030c9:	c3                   	ret    
		if(from_env_store)
  8030ca:	85 f6                	test   %esi,%esi
  8030cc:	74 06                	je     8030d4 <ipc_recv+0x5d>
			*from_env_store = 0;
  8030ce:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8030d4:	85 db                	test   %ebx,%ebx
  8030d6:	74 eb                	je     8030c3 <ipc_recv+0x4c>
			*perm_store = 0;
  8030d8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8030de:	eb e3                	jmp    8030c3 <ipc_recv+0x4c>

008030e0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8030e0:	55                   	push   %ebp
  8030e1:	89 e5                	mov    %esp,%ebp
  8030e3:	57                   	push   %edi
  8030e4:	56                   	push   %esi
  8030e5:	53                   	push   %ebx
  8030e6:	83 ec 0c             	sub    $0xc,%esp
  8030e9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8030ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  8030ef:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8030f2:	85 db                	test   %ebx,%ebx
  8030f4:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8030f9:	0f 44 d8             	cmove  %eax,%ebx
  8030fc:	eb 05                	jmp    803103 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8030fe:	e8 b8 e0 ff ff       	call   8011bb <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  803103:	ff 75 14             	pushl  0x14(%ebp)
  803106:	53                   	push   %ebx
  803107:	56                   	push   %esi
  803108:	57                   	push   %edi
  803109:	e8 59 e2 ff ff       	call   801367 <sys_ipc_try_send>
  80310e:	83 c4 10             	add    $0x10,%esp
  803111:	85 c0                	test   %eax,%eax
  803113:	74 1b                	je     803130 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  803115:	79 e7                	jns    8030fe <ipc_send+0x1e>
  803117:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80311a:	74 e2                	je     8030fe <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80311c:	83 ec 04             	sub    $0x4,%esp
  80311f:	68 0e 3d 80 00       	push   $0x803d0e
  803124:	6a 46                	push   $0x46
  803126:	68 23 3d 80 00       	push   $0x803d23
  80312b:	e8 63 d4 ff ff       	call   800593 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  803130:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803133:	5b                   	pop    %ebx
  803134:	5e                   	pop    %esi
  803135:	5f                   	pop    %edi
  803136:	5d                   	pop    %ebp
  803137:	c3                   	ret    

00803138 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803138:	55                   	push   %ebp
  803139:	89 e5                	mov    %esp,%ebp
  80313b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80313e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  803143:	89 c2                	mov    %eax,%edx
  803145:	c1 e2 07             	shl    $0x7,%edx
  803148:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80314e:	8b 52 50             	mov    0x50(%edx),%edx
  803151:	39 ca                	cmp    %ecx,%edx
  803153:	74 11                	je     803166 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  803155:	83 c0 01             	add    $0x1,%eax
  803158:	3d 00 04 00 00       	cmp    $0x400,%eax
  80315d:	75 e4                	jne    803143 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80315f:	b8 00 00 00 00       	mov    $0x0,%eax
  803164:	eb 0b                	jmp    803171 <ipc_find_env+0x39>
			return envs[i].env_id;
  803166:	c1 e0 07             	shl    $0x7,%eax
  803169:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80316e:	8b 40 48             	mov    0x48(%eax),%eax
}
  803171:	5d                   	pop    %ebp
  803172:	c3                   	ret    

00803173 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803173:	55                   	push   %ebp
  803174:	89 e5                	mov    %esp,%ebp
  803176:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803179:	89 d0                	mov    %edx,%eax
  80317b:	c1 e8 16             	shr    $0x16,%eax
  80317e:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  803185:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80318a:	f6 c1 01             	test   $0x1,%cl
  80318d:	74 1d                	je     8031ac <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80318f:	c1 ea 0c             	shr    $0xc,%edx
  803192:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803199:	f6 c2 01             	test   $0x1,%dl
  80319c:	74 0e                	je     8031ac <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80319e:	c1 ea 0c             	shr    $0xc,%edx
  8031a1:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8031a8:	ef 
  8031a9:	0f b7 c0             	movzwl %ax,%eax
}
  8031ac:	5d                   	pop    %ebp
  8031ad:	c3                   	ret    
  8031ae:	66 90                	xchg   %ax,%ax

008031b0 <__udivdi3>:
  8031b0:	55                   	push   %ebp
  8031b1:	57                   	push   %edi
  8031b2:	56                   	push   %esi
  8031b3:	53                   	push   %ebx
  8031b4:	83 ec 1c             	sub    $0x1c,%esp
  8031b7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8031bb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8031bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8031c3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8031c7:	85 d2                	test   %edx,%edx
  8031c9:	75 4d                	jne    803218 <__udivdi3+0x68>
  8031cb:	39 f3                	cmp    %esi,%ebx
  8031cd:	76 19                	jbe    8031e8 <__udivdi3+0x38>
  8031cf:	31 ff                	xor    %edi,%edi
  8031d1:	89 e8                	mov    %ebp,%eax
  8031d3:	89 f2                	mov    %esi,%edx
  8031d5:	f7 f3                	div    %ebx
  8031d7:	89 fa                	mov    %edi,%edx
  8031d9:	83 c4 1c             	add    $0x1c,%esp
  8031dc:	5b                   	pop    %ebx
  8031dd:	5e                   	pop    %esi
  8031de:	5f                   	pop    %edi
  8031df:	5d                   	pop    %ebp
  8031e0:	c3                   	ret    
  8031e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8031e8:	89 d9                	mov    %ebx,%ecx
  8031ea:	85 db                	test   %ebx,%ebx
  8031ec:	75 0b                	jne    8031f9 <__udivdi3+0x49>
  8031ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8031f3:	31 d2                	xor    %edx,%edx
  8031f5:	f7 f3                	div    %ebx
  8031f7:	89 c1                	mov    %eax,%ecx
  8031f9:	31 d2                	xor    %edx,%edx
  8031fb:	89 f0                	mov    %esi,%eax
  8031fd:	f7 f1                	div    %ecx
  8031ff:	89 c6                	mov    %eax,%esi
  803201:	89 e8                	mov    %ebp,%eax
  803203:	89 f7                	mov    %esi,%edi
  803205:	f7 f1                	div    %ecx
  803207:	89 fa                	mov    %edi,%edx
  803209:	83 c4 1c             	add    $0x1c,%esp
  80320c:	5b                   	pop    %ebx
  80320d:	5e                   	pop    %esi
  80320e:	5f                   	pop    %edi
  80320f:	5d                   	pop    %ebp
  803210:	c3                   	ret    
  803211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803218:	39 f2                	cmp    %esi,%edx
  80321a:	77 1c                	ja     803238 <__udivdi3+0x88>
  80321c:	0f bd fa             	bsr    %edx,%edi
  80321f:	83 f7 1f             	xor    $0x1f,%edi
  803222:	75 2c                	jne    803250 <__udivdi3+0xa0>
  803224:	39 f2                	cmp    %esi,%edx
  803226:	72 06                	jb     80322e <__udivdi3+0x7e>
  803228:	31 c0                	xor    %eax,%eax
  80322a:	39 eb                	cmp    %ebp,%ebx
  80322c:	77 a9                	ja     8031d7 <__udivdi3+0x27>
  80322e:	b8 01 00 00 00       	mov    $0x1,%eax
  803233:	eb a2                	jmp    8031d7 <__udivdi3+0x27>
  803235:	8d 76 00             	lea    0x0(%esi),%esi
  803238:	31 ff                	xor    %edi,%edi
  80323a:	31 c0                	xor    %eax,%eax
  80323c:	89 fa                	mov    %edi,%edx
  80323e:	83 c4 1c             	add    $0x1c,%esp
  803241:	5b                   	pop    %ebx
  803242:	5e                   	pop    %esi
  803243:	5f                   	pop    %edi
  803244:	5d                   	pop    %ebp
  803245:	c3                   	ret    
  803246:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80324d:	8d 76 00             	lea    0x0(%esi),%esi
  803250:	89 f9                	mov    %edi,%ecx
  803252:	b8 20 00 00 00       	mov    $0x20,%eax
  803257:	29 f8                	sub    %edi,%eax
  803259:	d3 e2                	shl    %cl,%edx
  80325b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80325f:	89 c1                	mov    %eax,%ecx
  803261:	89 da                	mov    %ebx,%edx
  803263:	d3 ea                	shr    %cl,%edx
  803265:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803269:	09 d1                	or     %edx,%ecx
  80326b:	89 f2                	mov    %esi,%edx
  80326d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803271:	89 f9                	mov    %edi,%ecx
  803273:	d3 e3                	shl    %cl,%ebx
  803275:	89 c1                	mov    %eax,%ecx
  803277:	d3 ea                	shr    %cl,%edx
  803279:	89 f9                	mov    %edi,%ecx
  80327b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80327f:	89 eb                	mov    %ebp,%ebx
  803281:	d3 e6                	shl    %cl,%esi
  803283:	89 c1                	mov    %eax,%ecx
  803285:	d3 eb                	shr    %cl,%ebx
  803287:	09 de                	or     %ebx,%esi
  803289:	89 f0                	mov    %esi,%eax
  80328b:	f7 74 24 08          	divl   0x8(%esp)
  80328f:	89 d6                	mov    %edx,%esi
  803291:	89 c3                	mov    %eax,%ebx
  803293:	f7 64 24 0c          	mull   0xc(%esp)
  803297:	39 d6                	cmp    %edx,%esi
  803299:	72 15                	jb     8032b0 <__udivdi3+0x100>
  80329b:	89 f9                	mov    %edi,%ecx
  80329d:	d3 e5                	shl    %cl,%ebp
  80329f:	39 c5                	cmp    %eax,%ebp
  8032a1:	73 04                	jae    8032a7 <__udivdi3+0xf7>
  8032a3:	39 d6                	cmp    %edx,%esi
  8032a5:	74 09                	je     8032b0 <__udivdi3+0x100>
  8032a7:	89 d8                	mov    %ebx,%eax
  8032a9:	31 ff                	xor    %edi,%edi
  8032ab:	e9 27 ff ff ff       	jmp    8031d7 <__udivdi3+0x27>
  8032b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8032b3:	31 ff                	xor    %edi,%edi
  8032b5:	e9 1d ff ff ff       	jmp    8031d7 <__udivdi3+0x27>
  8032ba:	66 90                	xchg   %ax,%ax
  8032bc:	66 90                	xchg   %ax,%ax
  8032be:	66 90                	xchg   %ax,%ax

008032c0 <__umoddi3>:
  8032c0:	55                   	push   %ebp
  8032c1:	57                   	push   %edi
  8032c2:	56                   	push   %esi
  8032c3:	53                   	push   %ebx
  8032c4:	83 ec 1c             	sub    $0x1c,%esp
  8032c7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8032cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8032cf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8032d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032d7:	89 da                	mov    %ebx,%edx
  8032d9:	85 c0                	test   %eax,%eax
  8032db:	75 43                	jne    803320 <__umoddi3+0x60>
  8032dd:	39 df                	cmp    %ebx,%edi
  8032df:	76 17                	jbe    8032f8 <__umoddi3+0x38>
  8032e1:	89 f0                	mov    %esi,%eax
  8032e3:	f7 f7                	div    %edi
  8032e5:	89 d0                	mov    %edx,%eax
  8032e7:	31 d2                	xor    %edx,%edx
  8032e9:	83 c4 1c             	add    $0x1c,%esp
  8032ec:	5b                   	pop    %ebx
  8032ed:	5e                   	pop    %esi
  8032ee:	5f                   	pop    %edi
  8032ef:	5d                   	pop    %ebp
  8032f0:	c3                   	ret    
  8032f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8032f8:	89 fd                	mov    %edi,%ebp
  8032fa:	85 ff                	test   %edi,%edi
  8032fc:	75 0b                	jne    803309 <__umoddi3+0x49>
  8032fe:	b8 01 00 00 00       	mov    $0x1,%eax
  803303:	31 d2                	xor    %edx,%edx
  803305:	f7 f7                	div    %edi
  803307:	89 c5                	mov    %eax,%ebp
  803309:	89 d8                	mov    %ebx,%eax
  80330b:	31 d2                	xor    %edx,%edx
  80330d:	f7 f5                	div    %ebp
  80330f:	89 f0                	mov    %esi,%eax
  803311:	f7 f5                	div    %ebp
  803313:	89 d0                	mov    %edx,%eax
  803315:	eb d0                	jmp    8032e7 <__umoddi3+0x27>
  803317:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80331e:	66 90                	xchg   %ax,%ax
  803320:	89 f1                	mov    %esi,%ecx
  803322:	39 d8                	cmp    %ebx,%eax
  803324:	76 0a                	jbe    803330 <__umoddi3+0x70>
  803326:	89 f0                	mov    %esi,%eax
  803328:	83 c4 1c             	add    $0x1c,%esp
  80332b:	5b                   	pop    %ebx
  80332c:	5e                   	pop    %esi
  80332d:	5f                   	pop    %edi
  80332e:	5d                   	pop    %ebp
  80332f:	c3                   	ret    
  803330:	0f bd e8             	bsr    %eax,%ebp
  803333:	83 f5 1f             	xor    $0x1f,%ebp
  803336:	75 20                	jne    803358 <__umoddi3+0x98>
  803338:	39 d8                	cmp    %ebx,%eax
  80333a:	0f 82 b0 00 00 00    	jb     8033f0 <__umoddi3+0x130>
  803340:	39 f7                	cmp    %esi,%edi
  803342:	0f 86 a8 00 00 00    	jbe    8033f0 <__umoddi3+0x130>
  803348:	89 c8                	mov    %ecx,%eax
  80334a:	83 c4 1c             	add    $0x1c,%esp
  80334d:	5b                   	pop    %ebx
  80334e:	5e                   	pop    %esi
  80334f:	5f                   	pop    %edi
  803350:	5d                   	pop    %ebp
  803351:	c3                   	ret    
  803352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803358:	89 e9                	mov    %ebp,%ecx
  80335a:	ba 20 00 00 00       	mov    $0x20,%edx
  80335f:	29 ea                	sub    %ebp,%edx
  803361:	d3 e0                	shl    %cl,%eax
  803363:	89 44 24 08          	mov    %eax,0x8(%esp)
  803367:	89 d1                	mov    %edx,%ecx
  803369:	89 f8                	mov    %edi,%eax
  80336b:	d3 e8                	shr    %cl,%eax
  80336d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803371:	89 54 24 04          	mov    %edx,0x4(%esp)
  803375:	8b 54 24 04          	mov    0x4(%esp),%edx
  803379:	09 c1                	or     %eax,%ecx
  80337b:	89 d8                	mov    %ebx,%eax
  80337d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803381:	89 e9                	mov    %ebp,%ecx
  803383:	d3 e7                	shl    %cl,%edi
  803385:	89 d1                	mov    %edx,%ecx
  803387:	d3 e8                	shr    %cl,%eax
  803389:	89 e9                	mov    %ebp,%ecx
  80338b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80338f:	d3 e3                	shl    %cl,%ebx
  803391:	89 c7                	mov    %eax,%edi
  803393:	89 d1                	mov    %edx,%ecx
  803395:	89 f0                	mov    %esi,%eax
  803397:	d3 e8                	shr    %cl,%eax
  803399:	89 e9                	mov    %ebp,%ecx
  80339b:	89 fa                	mov    %edi,%edx
  80339d:	d3 e6                	shl    %cl,%esi
  80339f:	09 d8                	or     %ebx,%eax
  8033a1:	f7 74 24 08          	divl   0x8(%esp)
  8033a5:	89 d1                	mov    %edx,%ecx
  8033a7:	89 f3                	mov    %esi,%ebx
  8033a9:	f7 64 24 0c          	mull   0xc(%esp)
  8033ad:	89 c6                	mov    %eax,%esi
  8033af:	89 d7                	mov    %edx,%edi
  8033b1:	39 d1                	cmp    %edx,%ecx
  8033b3:	72 06                	jb     8033bb <__umoddi3+0xfb>
  8033b5:	75 10                	jne    8033c7 <__umoddi3+0x107>
  8033b7:	39 c3                	cmp    %eax,%ebx
  8033b9:	73 0c                	jae    8033c7 <__umoddi3+0x107>
  8033bb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8033bf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8033c3:	89 d7                	mov    %edx,%edi
  8033c5:	89 c6                	mov    %eax,%esi
  8033c7:	89 ca                	mov    %ecx,%edx
  8033c9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8033ce:	29 f3                	sub    %esi,%ebx
  8033d0:	19 fa                	sbb    %edi,%edx
  8033d2:	89 d0                	mov    %edx,%eax
  8033d4:	d3 e0                	shl    %cl,%eax
  8033d6:	89 e9                	mov    %ebp,%ecx
  8033d8:	d3 eb                	shr    %cl,%ebx
  8033da:	d3 ea                	shr    %cl,%edx
  8033dc:	09 d8                	or     %ebx,%eax
  8033de:	83 c4 1c             	add    $0x1c,%esp
  8033e1:	5b                   	pop    %ebx
  8033e2:	5e                   	pop    %esi
  8033e3:	5f                   	pop    %edi
  8033e4:	5d                   	pop    %ebp
  8033e5:	c3                   	ret    
  8033e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8033ed:	8d 76 00             	lea    0x0(%esi),%esi
  8033f0:	89 da                	mov    %ebx,%edx
  8033f2:	29 fe                	sub    %edi,%esi
  8033f4:	19 c2                	sbb    %eax,%edx
  8033f6:	89 f1                	mov    %esi,%ecx
  8033f8:	89 c8                	mov    %ecx,%eax
  8033fa:	e9 4b ff ff ff       	jmp    80334a <__umoddi3+0x8a>
