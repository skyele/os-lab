
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
  80004a:	e8 2d 1d 00 00       	call   801d7c <seek>
	seek(kfd, off);
  80004f:	83 c4 08             	add    $0x8,%esp
  800052:	53                   	push   %ebx
  800053:	57                   	push   %edi
  800054:	e8 23 1d 00 00       	call   801d7c <seek>

	cprintf("shell produced incorrect output.\n");
  800059:	c7 04 24 c0 33 80 00 	movl   $0x8033c0,(%esp)
  800060:	e8 d3 05 00 00       	call   800638 <cprintf>
	cprintf("expected:\n===\n");
  800065:	c7 04 24 2b 34 80 00 	movl   $0x80342b,(%esp)
  80006c:	e8 c7 05 00 00       	call   800638 <cprintf>
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800071:	83 c4 10             	add    $0x10,%esp
  800074:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  800077:	83 ec 04             	sub    $0x4,%esp
  80007a:	6a 63                	push   $0x63
  80007c:	53                   	push   %ebx
  80007d:	57                   	push   %edi
  80007e:	e8 ab 1b 00 00       	call   801c2e <read>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	85 c0                	test   %eax,%eax
  800088:	7e 0f                	jle    800099 <wrong+0x66>
		sys_cputs(buf, n);
  80008a:	83 ec 08             	sub    $0x8,%esp
  80008d:	50                   	push   %eax
  80008e:	53                   	push   %ebx
  80008f:	e8 39 10 00 00       	call   8010cd <sys_cputs>
  800094:	83 c4 10             	add    $0x10,%esp
  800097:	eb de                	jmp    800077 <wrong+0x44>
	cprintf("===\ngot:\n===\n");
  800099:	83 ec 0c             	sub    $0xc,%esp
  80009c:	68 3a 34 80 00       	push   $0x80343a
  8000a1:	e8 92 05 00 00       	call   800638 <cprintf>
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000a6:	83 c4 10             	add    $0x10,%esp
  8000a9:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  8000ac:	eb 0d                	jmp    8000bb <wrong+0x88>
		sys_cputs(buf, n);
  8000ae:	83 ec 08             	sub    $0x8,%esp
  8000b1:	50                   	push   %eax
  8000b2:	53                   	push   %ebx
  8000b3:	e8 15 10 00 00       	call   8010cd <sys_cputs>
  8000b8:	83 c4 10             	add    $0x10,%esp
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000bb:	83 ec 04             	sub    $0x4,%esp
  8000be:	6a 63                	push   $0x63
  8000c0:	53                   	push   %ebx
  8000c1:	56                   	push   %esi
  8000c2:	e8 67 1b 00 00       	call   801c2e <read>
  8000c7:	83 c4 10             	add    $0x10,%esp
  8000ca:	85 c0                	test   %eax,%eax
  8000cc:	7f e0                	jg     8000ae <wrong+0x7b>
	cprintf("===\n");
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	68 35 34 80 00       	push   $0x803435
  8000d6:	e8 5d 05 00 00       	call   800638 <cprintf>
	exit();
  8000db:	e8 48 04 00 00       	call   800528 <exit>
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
  8000f6:	e8 f5 19 00 00       	call   801af0 <close>
	close(1);
  8000fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800102:	e8 e9 19 00 00       	call   801af0 <close>
	opencons();
  800107:	e8 28 03 00 00       	call   800434 <opencons>
	opencons();
  80010c:	e8 23 03 00 00       	call   800434 <opencons>
	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  800111:	83 c4 08             	add    $0x8,%esp
  800114:	6a 00                	push   $0x0
  800116:	68 48 34 80 00       	push   $0x803448
  80011b:	e8 ac 1f 00 00       	call   8020cc <open>
  800120:	89 c3                	mov    %eax,%ebx
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	85 c0                	test   %eax,%eax
  800127:	0f 88 e7 00 00 00    	js     800214 <umain+0x129>
	if ((wfd = pipe(pfds)) < 0)
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800133:	50                   	push   %eax
  800134:	e8 8c 2c 00 00       	call   802dc5 <pipe>
  800139:	83 c4 10             	add    $0x10,%esp
  80013c:	85 c0                	test   %eax,%eax
  80013e:	0f 88 e2 00 00 00    	js     800226 <umain+0x13b>
	wfd = pfds[1];
  800144:	8b 75 e0             	mov    -0x20(%ebp),%esi
	cprintf("running sh -x < testshell.sh | cat\n");
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	68 e4 33 80 00       	push   $0x8033e4
  80014f:	e8 e4 04 00 00       	call   800638 <cprintf>
	if ((r = fork()) < 0)
  800154:	e8 5a 15 00 00       	call   8016b3 <fork>
  800159:	83 c4 10             	add    $0x10,%esp
  80015c:	85 c0                	test   %eax,%eax
  80015e:	0f 88 d4 00 00 00    	js     800238 <umain+0x14d>
	if (r == 0) {
  800164:	75 6f                	jne    8001d5 <umain+0xea>
		dup(rfd, 0);
  800166:	83 ec 08             	sub    $0x8,%esp
  800169:	6a 00                	push   $0x0
  80016b:	53                   	push   %ebx
  80016c:	e8 d1 19 00 00       	call   801b42 <dup>
		dup(wfd, 1);
  800171:	83 c4 08             	add    $0x8,%esp
  800174:	6a 01                	push   $0x1
  800176:	56                   	push   %esi
  800177:	e8 c6 19 00 00       	call   801b42 <dup>
		close(rfd);
  80017c:	89 1c 24             	mov    %ebx,(%esp)
  80017f:	e8 6c 19 00 00       	call   801af0 <close>
		close(wfd);
  800184:	89 34 24             	mov    %esi,(%esp)
  800187:	e8 64 19 00 00       	call   801af0 <close>
		if ((r = spawnl("/sh", "sh", "-x", 0)) < 0)
  80018c:	6a 00                	push   $0x0
  80018e:	68 8e 34 80 00       	push   $0x80348e
  800193:	68 52 34 80 00       	push   $0x803452
  800198:	68 91 34 80 00       	push   $0x803491
  80019d:	e8 5c 25 00 00       	call   8026fe <spawnl>
  8001a2:	89 c7                	mov    %eax,%edi
  8001a4:	83 c4 20             	add    $0x20,%esp
  8001a7:	85 c0                	test   %eax,%eax
  8001a9:	0f 88 9b 00 00 00    	js     80024a <umain+0x15f>
		close(0);
  8001af:	83 ec 0c             	sub    $0xc,%esp
  8001b2:	6a 00                	push   $0x0
  8001b4:	e8 37 19 00 00       	call   801af0 <close>
		close(1);
  8001b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001c0:	e8 2b 19 00 00       	call   801af0 <close>
		wait(r);
  8001c5:	89 3c 24             	mov    %edi,(%esp)
  8001c8:	e8 75 2d 00 00       	call   802f42 <wait>
		exit();
  8001cd:	e8 56 03 00 00       	call   800528 <exit>
  8001d2:	83 c4 10             	add    $0x10,%esp
	close(rfd);
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	53                   	push   %ebx
  8001d9:	e8 12 19 00 00       	call   801af0 <close>
	close(wfd);
  8001de:	89 34 24             	mov    %esi,(%esp)
  8001e1:	e8 0a 19 00 00       	call   801af0 <close>
	rfd = pfds[0];
  8001e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001e9:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8001ec:	83 c4 08             	add    $0x8,%esp
  8001ef:	6a 00                	push   $0x0
  8001f1:	68 9f 34 80 00       	push   $0x80349f
  8001f6:	e8 d1 1e 00 00       	call   8020cc <open>
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
  800215:	68 55 34 80 00       	push   $0x803455
  80021a:	6a 13                	push   $0x13
  80021c:	68 6b 34 80 00       	push   $0x80346b
  800221:	e8 1c 03 00 00       	call   800542 <_panic>
		panic("pipe: %e", wfd);
  800226:	50                   	push   %eax
  800227:	68 7c 34 80 00       	push   $0x80347c
  80022c:	6a 15                	push   $0x15
  80022e:	68 6b 34 80 00       	push   $0x80346b
  800233:	e8 0a 03 00 00       	call   800542 <_panic>
		panic("fork: %e", r);
  800238:	50                   	push   %eax
  800239:	68 85 34 80 00       	push   $0x803485
  80023e:	6a 1a                	push   $0x1a
  800240:	68 6b 34 80 00       	push   $0x80346b
  800245:	e8 f8 02 00 00       	call   800542 <_panic>
			panic("spawn: %e", r);
  80024a:	50                   	push   %eax
  80024b:	68 95 34 80 00       	push   $0x803495
  800250:	6a 21                	push   $0x21
  800252:	68 6b 34 80 00       	push   $0x80346b
  800257:	e8 e6 02 00 00       	call   800542 <_panic>
		panic("open testshell.key for reading: %e", kfd);
  80025c:	50                   	push   %eax
  80025d:	68 08 34 80 00       	push   $0x803408
  800262:	6a 2c                	push   $0x2c
  800264:	68 6b 34 80 00       	push   $0x80346b
  800269:	e8 d4 02 00 00       	call   800542 <_panic>
			panic("reading testshell.out: %e", n1);
  80026e:	53                   	push   %ebx
  80026f:	68 ad 34 80 00       	push   $0x8034ad
  800274:	6a 33                	push   $0x33
  800276:	68 6b 34 80 00       	push   $0x80346b
  80027b:	e8 c2 02 00 00       	call   800542 <_panic>
			panic("reading testshell.key: %e", n2);
  800280:	50                   	push   %eax
  800281:	68 c7 34 80 00       	push   $0x8034c7
  800286:	6a 35                	push   $0x35
  800288:	68 6b 34 80 00       	push   $0x80346b
  80028d:	e8 b0 02 00 00       	call   800542 <_panic>
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
  8002ba:	e8 6f 19 00 00       	call   801c2e <read>
  8002bf:	89 c3                	mov    %eax,%ebx
		n2 = read(kfd, &c2, 1);
  8002c1:	83 c4 0c             	add    $0xc,%esp
  8002c4:	6a 01                	push   $0x1
  8002c6:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  8002c9:	50                   	push   %eax
  8002ca:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002cd:	e8 5c 19 00 00       	call   801c2e <read>
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
  8002fb:	68 e1 34 80 00       	push   $0x8034e1
  800300:	e8 33 03 00 00       	call   800638 <cprintf>
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
  80031d:	68 f6 34 80 00       	push   $0x8034f6
  800322:	ff 75 0c             	pushl  0xc(%ebp)
  800325:	e8 6d 0a 00 00       	call   800d97 <strcpy>
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
  800368:	e8 b8 0b 00 00       	call   800f25 <memmove>
		sys_cputs(buf, m);
  80036d:	83 c4 08             	add    $0x8,%esp
  800370:	53                   	push   %ebx
  800371:	57                   	push   %edi
  800372:	e8 56 0d 00 00       	call   8010cd <sys_cputs>
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
  800399:	e8 4d 0d 00 00       	call   8010eb <sys_cgetc>
  80039e:	85 c0                	test   %eax,%eax
  8003a0:	75 07                	jne    8003a9 <devcons_read+0x21>
		sys_yield();
  8003a2:	e8 c3 0d 00 00       	call   80116a <sys_yield>
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
  8003d5:	e8 f3 0c 00 00       	call   8010cd <sys_cputs>
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
  8003ed:	e8 3c 18 00 00       	call   801c2e <read>
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
  800415:	e8 a4 15 00 00       	call   8019be <fd_lookup>
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
  80043e:	e8 29 15 00 00       	call   80196c <fd_alloc>
  800443:	83 c4 10             	add    $0x10,%esp
  800446:	85 c0                	test   %eax,%eax
  800448:	78 3a                	js     800484 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80044a:	83 ec 04             	sub    $0x4,%esp
  80044d:	68 07 04 00 00       	push   $0x407
  800452:	ff 75 f4             	pushl  -0xc(%ebp)
  800455:	6a 00                	push   $0x0
  800457:	e8 2d 0d 00 00       	call   801189 <sys_page_alloc>
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
  80047c:	e8 c4 14 00 00       	call   801945 <fd2num>
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
  800499:	e8 ad 0c 00 00       	call   80114b <sys_getenvid>
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

	cprintf("in libmain.c call umain!\n");
  8004fd:	83 ec 0c             	sub    $0xc,%esp
  800500:	68 02 35 80 00       	push   $0x803502
  800505:	e8 2e 01 00 00       	call   800638 <cprintf>
	// call user main routine
	umain(argc, argv);
  80050a:	83 c4 08             	add    $0x8,%esp
  80050d:	ff 75 0c             	pushl  0xc(%ebp)
  800510:	ff 75 08             	pushl  0x8(%ebp)
  800513:	e8 d3 fb ff ff       	call   8000eb <umain>

	// exit gracefully
	exit();
  800518:	e8 0b 00 00 00       	call   800528 <exit>
}
  80051d:	83 c4 10             	add    $0x10,%esp
  800520:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800523:	5b                   	pop    %ebx
  800524:	5e                   	pop    %esi
  800525:	5f                   	pop    %edi
  800526:	5d                   	pop    %ebp
  800527:	c3                   	ret    

00800528 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800528:	55                   	push   %ebp
  800529:	89 e5                	mov    %esp,%ebp
  80052b:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80052e:	e8 ea 15 00 00       	call   801b1d <close_all>
	sys_env_destroy(0);
  800533:	83 ec 0c             	sub    $0xc,%esp
  800536:	6a 00                	push   $0x0
  800538:	e8 cd 0b 00 00       	call   80110a <sys_env_destroy>
}
  80053d:	83 c4 10             	add    $0x10,%esp
  800540:	c9                   	leave  
  800541:	c3                   	ret    

00800542 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800542:	55                   	push   %ebp
  800543:	89 e5                	mov    %esp,%ebp
  800545:	56                   	push   %esi
  800546:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800547:	a1 08 50 80 00       	mov    0x805008,%eax
  80054c:	8b 40 48             	mov    0x48(%eax),%eax
  80054f:	83 ec 04             	sub    $0x4,%esp
  800552:	68 58 35 80 00       	push   $0x803558
  800557:	50                   	push   %eax
  800558:	68 26 35 80 00       	push   $0x803526
  80055d:	e8 d6 00 00 00       	call   800638 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800562:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800565:	8b 35 1c 40 80 00    	mov    0x80401c,%esi
  80056b:	e8 db 0b 00 00       	call   80114b <sys_getenvid>
  800570:	83 c4 04             	add    $0x4,%esp
  800573:	ff 75 0c             	pushl  0xc(%ebp)
  800576:	ff 75 08             	pushl  0x8(%ebp)
  800579:	56                   	push   %esi
  80057a:	50                   	push   %eax
  80057b:	68 34 35 80 00       	push   $0x803534
  800580:	e8 b3 00 00 00       	call   800638 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800585:	83 c4 18             	add    $0x18,%esp
  800588:	53                   	push   %ebx
  800589:	ff 75 10             	pushl  0x10(%ebp)
  80058c:	e8 56 00 00 00       	call   8005e7 <vcprintf>
	cprintf("\n");
  800591:	c7 04 24 1a 35 80 00 	movl   $0x80351a,(%esp)
  800598:	e8 9b 00 00 00       	call   800638 <cprintf>
  80059d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8005a0:	cc                   	int3   
  8005a1:	eb fd                	jmp    8005a0 <_panic+0x5e>

008005a3 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8005a3:	55                   	push   %ebp
  8005a4:	89 e5                	mov    %esp,%ebp
  8005a6:	53                   	push   %ebx
  8005a7:	83 ec 04             	sub    $0x4,%esp
  8005aa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8005ad:	8b 13                	mov    (%ebx),%edx
  8005af:	8d 42 01             	lea    0x1(%edx),%eax
  8005b2:	89 03                	mov    %eax,(%ebx)
  8005b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8005b7:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8005bb:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005c0:	74 09                	je     8005cb <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8005c2:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8005c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005c9:	c9                   	leave  
  8005ca:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8005cb:	83 ec 08             	sub    $0x8,%esp
  8005ce:	68 ff 00 00 00       	push   $0xff
  8005d3:	8d 43 08             	lea    0x8(%ebx),%eax
  8005d6:	50                   	push   %eax
  8005d7:	e8 f1 0a 00 00       	call   8010cd <sys_cputs>
		b->idx = 0;
  8005dc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8005e2:	83 c4 10             	add    $0x10,%esp
  8005e5:	eb db                	jmp    8005c2 <putch+0x1f>

008005e7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8005e7:	55                   	push   %ebp
  8005e8:	89 e5                	mov    %esp,%ebp
  8005ea:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005f0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005f7:	00 00 00 
	b.cnt = 0;
  8005fa:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800601:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800604:	ff 75 0c             	pushl  0xc(%ebp)
  800607:	ff 75 08             	pushl  0x8(%ebp)
  80060a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800610:	50                   	push   %eax
  800611:	68 a3 05 80 00       	push   $0x8005a3
  800616:	e8 4a 01 00 00       	call   800765 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80061b:	83 c4 08             	add    $0x8,%esp
  80061e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800624:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80062a:	50                   	push   %eax
  80062b:	e8 9d 0a 00 00       	call   8010cd <sys_cputs>

	return b.cnt;
}
  800630:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800636:	c9                   	leave  
  800637:	c3                   	ret    

00800638 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800638:	55                   	push   %ebp
  800639:	89 e5                	mov    %esp,%ebp
  80063b:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80063e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800641:	50                   	push   %eax
  800642:	ff 75 08             	pushl  0x8(%ebp)
  800645:	e8 9d ff ff ff       	call   8005e7 <vcprintf>
	va_end(ap);

	return cnt;
}
  80064a:	c9                   	leave  
  80064b:	c3                   	ret    

0080064c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80064c:	55                   	push   %ebp
  80064d:	89 e5                	mov    %esp,%ebp
  80064f:	57                   	push   %edi
  800650:	56                   	push   %esi
  800651:	53                   	push   %ebx
  800652:	83 ec 1c             	sub    $0x1c,%esp
  800655:	89 c6                	mov    %eax,%esi
  800657:	89 d7                	mov    %edx,%edi
  800659:	8b 45 08             	mov    0x8(%ebp),%eax
  80065c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80065f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800662:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800665:	8b 45 10             	mov    0x10(%ebp),%eax
  800668:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80066b:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80066f:	74 2c                	je     80069d <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800671:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800674:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80067b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80067e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800681:	39 c2                	cmp    %eax,%edx
  800683:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800686:	73 43                	jae    8006cb <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800688:	83 eb 01             	sub    $0x1,%ebx
  80068b:	85 db                	test   %ebx,%ebx
  80068d:	7e 6c                	jle    8006fb <printnum+0xaf>
				putch(padc, putdat);
  80068f:	83 ec 08             	sub    $0x8,%esp
  800692:	57                   	push   %edi
  800693:	ff 75 18             	pushl  0x18(%ebp)
  800696:	ff d6                	call   *%esi
  800698:	83 c4 10             	add    $0x10,%esp
  80069b:	eb eb                	jmp    800688 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80069d:	83 ec 0c             	sub    $0xc,%esp
  8006a0:	6a 20                	push   $0x20
  8006a2:	6a 00                	push   $0x0
  8006a4:	50                   	push   %eax
  8006a5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8006a8:	ff 75 e0             	pushl  -0x20(%ebp)
  8006ab:	89 fa                	mov    %edi,%edx
  8006ad:	89 f0                	mov    %esi,%eax
  8006af:	e8 98 ff ff ff       	call   80064c <printnum>
		while (--width > 0)
  8006b4:	83 c4 20             	add    $0x20,%esp
  8006b7:	83 eb 01             	sub    $0x1,%ebx
  8006ba:	85 db                	test   %ebx,%ebx
  8006bc:	7e 65                	jle    800723 <printnum+0xd7>
			putch(padc, putdat);
  8006be:	83 ec 08             	sub    $0x8,%esp
  8006c1:	57                   	push   %edi
  8006c2:	6a 20                	push   $0x20
  8006c4:	ff d6                	call   *%esi
  8006c6:	83 c4 10             	add    $0x10,%esp
  8006c9:	eb ec                	jmp    8006b7 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8006cb:	83 ec 0c             	sub    $0xc,%esp
  8006ce:	ff 75 18             	pushl  0x18(%ebp)
  8006d1:	83 eb 01             	sub    $0x1,%ebx
  8006d4:	53                   	push   %ebx
  8006d5:	50                   	push   %eax
  8006d6:	83 ec 08             	sub    $0x8,%esp
  8006d9:	ff 75 dc             	pushl  -0x24(%ebp)
  8006dc:	ff 75 d8             	pushl  -0x28(%ebp)
  8006df:	ff 75 e4             	pushl  -0x1c(%ebp)
  8006e2:	ff 75 e0             	pushl  -0x20(%ebp)
  8006e5:	e8 76 2a 00 00       	call   803160 <__udivdi3>
  8006ea:	83 c4 18             	add    $0x18,%esp
  8006ed:	52                   	push   %edx
  8006ee:	50                   	push   %eax
  8006ef:	89 fa                	mov    %edi,%edx
  8006f1:	89 f0                	mov    %esi,%eax
  8006f3:	e8 54 ff ff ff       	call   80064c <printnum>
  8006f8:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8006fb:	83 ec 08             	sub    $0x8,%esp
  8006fe:	57                   	push   %edi
  8006ff:	83 ec 04             	sub    $0x4,%esp
  800702:	ff 75 dc             	pushl  -0x24(%ebp)
  800705:	ff 75 d8             	pushl  -0x28(%ebp)
  800708:	ff 75 e4             	pushl  -0x1c(%ebp)
  80070b:	ff 75 e0             	pushl  -0x20(%ebp)
  80070e:	e8 5d 2b 00 00       	call   803270 <__umoddi3>
  800713:	83 c4 14             	add    $0x14,%esp
  800716:	0f be 80 5f 35 80 00 	movsbl 0x80355f(%eax),%eax
  80071d:	50                   	push   %eax
  80071e:	ff d6                	call   *%esi
  800720:	83 c4 10             	add    $0x10,%esp
	}
}
  800723:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800726:	5b                   	pop    %ebx
  800727:	5e                   	pop    %esi
  800728:	5f                   	pop    %edi
  800729:	5d                   	pop    %ebp
  80072a:	c3                   	ret    

0080072b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80072b:	55                   	push   %ebp
  80072c:	89 e5                	mov    %esp,%ebp
  80072e:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800731:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800735:	8b 10                	mov    (%eax),%edx
  800737:	3b 50 04             	cmp    0x4(%eax),%edx
  80073a:	73 0a                	jae    800746 <sprintputch+0x1b>
		*b->buf++ = ch;
  80073c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80073f:	89 08                	mov    %ecx,(%eax)
  800741:	8b 45 08             	mov    0x8(%ebp),%eax
  800744:	88 02                	mov    %al,(%edx)
}
  800746:	5d                   	pop    %ebp
  800747:	c3                   	ret    

00800748 <printfmt>:
{
  800748:	55                   	push   %ebp
  800749:	89 e5                	mov    %esp,%ebp
  80074b:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80074e:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800751:	50                   	push   %eax
  800752:	ff 75 10             	pushl  0x10(%ebp)
  800755:	ff 75 0c             	pushl  0xc(%ebp)
  800758:	ff 75 08             	pushl  0x8(%ebp)
  80075b:	e8 05 00 00 00       	call   800765 <vprintfmt>
}
  800760:	83 c4 10             	add    $0x10,%esp
  800763:	c9                   	leave  
  800764:	c3                   	ret    

00800765 <vprintfmt>:
{
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
  800768:	57                   	push   %edi
  800769:	56                   	push   %esi
  80076a:	53                   	push   %ebx
  80076b:	83 ec 3c             	sub    $0x3c,%esp
  80076e:	8b 75 08             	mov    0x8(%ebp),%esi
  800771:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800774:	8b 7d 10             	mov    0x10(%ebp),%edi
  800777:	e9 32 04 00 00       	jmp    800bae <vprintfmt+0x449>
		padc = ' ';
  80077c:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800780:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800787:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80078e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800795:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80079c:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8007a3:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8007a8:	8d 47 01             	lea    0x1(%edi),%eax
  8007ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007ae:	0f b6 17             	movzbl (%edi),%edx
  8007b1:	8d 42 dd             	lea    -0x23(%edx),%eax
  8007b4:	3c 55                	cmp    $0x55,%al
  8007b6:	0f 87 12 05 00 00    	ja     800cce <vprintfmt+0x569>
  8007bc:	0f b6 c0             	movzbl %al,%eax
  8007bf:	ff 24 85 40 37 80 00 	jmp    *0x803740(,%eax,4)
  8007c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8007c9:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8007cd:	eb d9                	jmp    8007a8 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8007cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8007d2:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8007d6:	eb d0                	jmp    8007a8 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8007d8:	0f b6 d2             	movzbl %dl,%edx
  8007db:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8007de:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e3:	89 75 08             	mov    %esi,0x8(%ebp)
  8007e6:	eb 03                	jmp    8007eb <vprintfmt+0x86>
  8007e8:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8007eb:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8007ee:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8007f2:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8007f5:	8d 72 d0             	lea    -0x30(%edx),%esi
  8007f8:	83 fe 09             	cmp    $0x9,%esi
  8007fb:	76 eb                	jbe    8007e8 <vprintfmt+0x83>
  8007fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800800:	8b 75 08             	mov    0x8(%ebp),%esi
  800803:	eb 14                	jmp    800819 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800805:	8b 45 14             	mov    0x14(%ebp),%eax
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80080d:	8b 45 14             	mov    0x14(%ebp),%eax
  800810:	8d 40 04             	lea    0x4(%eax),%eax
  800813:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800816:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800819:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80081d:	79 89                	jns    8007a8 <vprintfmt+0x43>
				width = precision, precision = -1;
  80081f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800822:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800825:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80082c:	e9 77 ff ff ff       	jmp    8007a8 <vprintfmt+0x43>
  800831:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800834:	85 c0                	test   %eax,%eax
  800836:	0f 48 c1             	cmovs  %ecx,%eax
  800839:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80083c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80083f:	e9 64 ff ff ff       	jmp    8007a8 <vprintfmt+0x43>
  800844:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800847:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80084e:	e9 55 ff ff ff       	jmp    8007a8 <vprintfmt+0x43>
			lflag++;
  800853:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800857:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80085a:	e9 49 ff ff ff       	jmp    8007a8 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80085f:	8b 45 14             	mov    0x14(%ebp),%eax
  800862:	8d 78 04             	lea    0x4(%eax),%edi
  800865:	83 ec 08             	sub    $0x8,%esp
  800868:	53                   	push   %ebx
  800869:	ff 30                	pushl  (%eax)
  80086b:	ff d6                	call   *%esi
			break;
  80086d:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800870:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800873:	e9 33 03 00 00       	jmp    800bab <vprintfmt+0x446>
			err = va_arg(ap, int);
  800878:	8b 45 14             	mov    0x14(%ebp),%eax
  80087b:	8d 78 04             	lea    0x4(%eax),%edi
  80087e:	8b 00                	mov    (%eax),%eax
  800880:	99                   	cltd   
  800881:	31 d0                	xor    %edx,%eax
  800883:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800885:	83 f8 10             	cmp    $0x10,%eax
  800888:	7f 23                	jg     8008ad <vprintfmt+0x148>
  80088a:	8b 14 85 a0 38 80 00 	mov    0x8038a0(,%eax,4),%edx
  800891:	85 d2                	test   %edx,%edx
  800893:	74 18                	je     8008ad <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800895:	52                   	push   %edx
  800896:	68 a9 3a 80 00       	push   $0x803aa9
  80089b:	53                   	push   %ebx
  80089c:	56                   	push   %esi
  80089d:	e8 a6 fe ff ff       	call   800748 <printfmt>
  8008a2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8008a5:	89 7d 14             	mov    %edi,0x14(%ebp)
  8008a8:	e9 fe 02 00 00       	jmp    800bab <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8008ad:	50                   	push   %eax
  8008ae:	68 77 35 80 00       	push   $0x803577
  8008b3:	53                   	push   %ebx
  8008b4:	56                   	push   %esi
  8008b5:	e8 8e fe ff ff       	call   800748 <printfmt>
  8008ba:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8008bd:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8008c0:	e9 e6 02 00 00       	jmp    800bab <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8008c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c8:	83 c0 04             	add    $0x4,%eax
  8008cb:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8008ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d1:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8008d3:	85 c9                	test   %ecx,%ecx
  8008d5:	b8 70 35 80 00       	mov    $0x803570,%eax
  8008da:	0f 45 c1             	cmovne %ecx,%eax
  8008dd:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8008e0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008e4:	7e 06                	jle    8008ec <vprintfmt+0x187>
  8008e6:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8008ea:	75 0d                	jne    8008f9 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ec:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8008ef:	89 c7                	mov    %eax,%edi
  8008f1:	03 45 e0             	add    -0x20(%ebp),%eax
  8008f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008f7:	eb 53                	jmp    80094c <vprintfmt+0x1e7>
  8008f9:	83 ec 08             	sub    $0x8,%esp
  8008fc:	ff 75 d8             	pushl  -0x28(%ebp)
  8008ff:	50                   	push   %eax
  800900:	e8 71 04 00 00       	call   800d76 <strnlen>
  800905:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800908:	29 c1                	sub    %eax,%ecx
  80090a:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80090d:	83 c4 10             	add    $0x10,%esp
  800910:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800912:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800916:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800919:	eb 0f                	jmp    80092a <vprintfmt+0x1c5>
					putch(padc, putdat);
  80091b:	83 ec 08             	sub    $0x8,%esp
  80091e:	53                   	push   %ebx
  80091f:	ff 75 e0             	pushl  -0x20(%ebp)
  800922:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800924:	83 ef 01             	sub    $0x1,%edi
  800927:	83 c4 10             	add    $0x10,%esp
  80092a:	85 ff                	test   %edi,%edi
  80092c:	7f ed                	jg     80091b <vprintfmt+0x1b6>
  80092e:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800931:	85 c9                	test   %ecx,%ecx
  800933:	b8 00 00 00 00       	mov    $0x0,%eax
  800938:	0f 49 c1             	cmovns %ecx,%eax
  80093b:	29 c1                	sub    %eax,%ecx
  80093d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800940:	eb aa                	jmp    8008ec <vprintfmt+0x187>
					putch(ch, putdat);
  800942:	83 ec 08             	sub    $0x8,%esp
  800945:	53                   	push   %ebx
  800946:	52                   	push   %edx
  800947:	ff d6                	call   *%esi
  800949:	83 c4 10             	add    $0x10,%esp
  80094c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80094f:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800951:	83 c7 01             	add    $0x1,%edi
  800954:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800958:	0f be d0             	movsbl %al,%edx
  80095b:	85 d2                	test   %edx,%edx
  80095d:	74 4b                	je     8009aa <vprintfmt+0x245>
  80095f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800963:	78 06                	js     80096b <vprintfmt+0x206>
  800965:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800969:	78 1e                	js     800989 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80096b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80096f:	74 d1                	je     800942 <vprintfmt+0x1dd>
  800971:	0f be c0             	movsbl %al,%eax
  800974:	83 e8 20             	sub    $0x20,%eax
  800977:	83 f8 5e             	cmp    $0x5e,%eax
  80097a:	76 c6                	jbe    800942 <vprintfmt+0x1dd>
					putch('?', putdat);
  80097c:	83 ec 08             	sub    $0x8,%esp
  80097f:	53                   	push   %ebx
  800980:	6a 3f                	push   $0x3f
  800982:	ff d6                	call   *%esi
  800984:	83 c4 10             	add    $0x10,%esp
  800987:	eb c3                	jmp    80094c <vprintfmt+0x1e7>
  800989:	89 cf                	mov    %ecx,%edi
  80098b:	eb 0e                	jmp    80099b <vprintfmt+0x236>
				putch(' ', putdat);
  80098d:	83 ec 08             	sub    $0x8,%esp
  800990:	53                   	push   %ebx
  800991:	6a 20                	push   $0x20
  800993:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800995:	83 ef 01             	sub    $0x1,%edi
  800998:	83 c4 10             	add    $0x10,%esp
  80099b:	85 ff                	test   %edi,%edi
  80099d:	7f ee                	jg     80098d <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80099f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8009a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a5:	e9 01 02 00 00       	jmp    800bab <vprintfmt+0x446>
  8009aa:	89 cf                	mov    %ecx,%edi
  8009ac:	eb ed                	jmp    80099b <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8009ae:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8009b1:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8009b8:	e9 eb fd ff ff       	jmp    8007a8 <vprintfmt+0x43>
	if (lflag >= 2)
  8009bd:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8009c1:	7f 21                	jg     8009e4 <vprintfmt+0x27f>
	else if (lflag)
  8009c3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8009c7:	74 68                	je     800a31 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8009c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cc:	8b 00                	mov    (%eax),%eax
  8009ce:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8009d1:	89 c1                	mov    %eax,%ecx
  8009d3:	c1 f9 1f             	sar    $0x1f,%ecx
  8009d6:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8009d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009dc:	8d 40 04             	lea    0x4(%eax),%eax
  8009df:	89 45 14             	mov    %eax,0x14(%ebp)
  8009e2:	eb 17                	jmp    8009fb <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8009e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e7:	8b 50 04             	mov    0x4(%eax),%edx
  8009ea:	8b 00                	mov    (%eax),%eax
  8009ec:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8009ef:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8009f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f5:	8d 40 08             	lea    0x8(%eax),%eax
  8009f8:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8009fb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8009fe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800a01:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a04:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800a07:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800a0b:	78 3f                	js     800a4c <vprintfmt+0x2e7>
			base = 10;
  800a0d:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800a12:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800a16:	0f 84 71 01 00 00    	je     800b8d <vprintfmt+0x428>
				putch('+', putdat);
  800a1c:	83 ec 08             	sub    $0x8,%esp
  800a1f:	53                   	push   %ebx
  800a20:	6a 2b                	push   $0x2b
  800a22:	ff d6                	call   *%esi
  800a24:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800a27:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a2c:	e9 5c 01 00 00       	jmp    800b8d <vprintfmt+0x428>
		return va_arg(*ap, int);
  800a31:	8b 45 14             	mov    0x14(%ebp),%eax
  800a34:	8b 00                	mov    (%eax),%eax
  800a36:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800a39:	89 c1                	mov    %eax,%ecx
  800a3b:	c1 f9 1f             	sar    $0x1f,%ecx
  800a3e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800a41:	8b 45 14             	mov    0x14(%ebp),%eax
  800a44:	8d 40 04             	lea    0x4(%eax),%eax
  800a47:	89 45 14             	mov    %eax,0x14(%ebp)
  800a4a:	eb af                	jmp    8009fb <vprintfmt+0x296>
				putch('-', putdat);
  800a4c:	83 ec 08             	sub    $0x8,%esp
  800a4f:	53                   	push   %ebx
  800a50:	6a 2d                	push   $0x2d
  800a52:	ff d6                	call   *%esi
				num = -(long long) num;
  800a54:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a57:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800a5a:	f7 d8                	neg    %eax
  800a5c:	83 d2 00             	adc    $0x0,%edx
  800a5f:	f7 da                	neg    %edx
  800a61:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a64:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a67:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800a6a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a6f:	e9 19 01 00 00       	jmp    800b8d <vprintfmt+0x428>
	if (lflag >= 2)
  800a74:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800a78:	7f 29                	jg     800aa3 <vprintfmt+0x33e>
	else if (lflag)
  800a7a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a7e:	74 44                	je     800ac4 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800a80:	8b 45 14             	mov    0x14(%ebp),%eax
  800a83:	8b 00                	mov    (%eax),%eax
  800a85:	ba 00 00 00 00       	mov    $0x0,%edx
  800a8a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a8d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a90:	8b 45 14             	mov    0x14(%ebp),%eax
  800a93:	8d 40 04             	lea    0x4(%eax),%eax
  800a96:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a99:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a9e:	e9 ea 00 00 00       	jmp    800b8d <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800aa3:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa6:	8b 50 04             	mov    0x4(%eax),%edx
  800aa9:	8b 00                	mov    (%eax),%eax
  800aab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aae:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ab1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab4:	8d 40 08             	lea    0x8(%eax),%eax
  800ab7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800aba:	b8 0a 00 00 00       	mov    $0xa,%eax
  800abf:	e9 c9 00 00 00       	jmp    800b8d <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800ac4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac7:	8b 00                	mov    (%eax),%eax
  800ac9:	ba 00 00 00 00       	mov    $0x0,%edx
  800ace:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ad1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ad4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad7:	8d 40 04             	lea    0x4(%eax),%eax
  800ada:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800add:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ae2:	e9 a6 00 00 00       	jmp    800b8d <vprintfmt+0x428>
			putch('0', putdat);
  800ae7:	83 ec 08             	sub    $0x8,%esp
  800aea:	53                   	push   %ebx
  800aeb:	6a 30                	push   $0x30
  800aed:	ff d6                	call   *%esi
	if (lflag >= 2)
  800aef:	83 c4 10             	add    $0x10,%esp
  800af2:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800af6:	7f 26                	jg     800b1e <vprintfmt+0x3b9>
	else if (lflag)
  800af8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800afc:	74 3e                	je     800b3c <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800afe:	8b 45 14             	mov    0x14(%ebp),%eax
  800b01:	8b 00                	mov    (%eax),%eax
  800b03:	ba 00 00 00 00       	mov    $0x0,%edx
  800b08:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b0b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b11:	8d 40 04             	lea    0x4(%eax),%eax
  800b14:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b17:	b8 08 00 00 00       	mov    $0x8,%eax
  800b1c:	eb 6f                	jmp    800b8d <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800b1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b21:	8b 50 04             	mov    0x4(%eax),%edx
  800b24:	8b 00                	mov    (%eax),%eax
  800b26:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b29:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2f:	8d 40 08             	lea    0x8(%eax),%eax
  800b32:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b35:	b8 08 00 00 00       	mov    $0x8,%eax
  800b3a:	eb 51                	jmp    800b8d <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800b3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3f:	8b 00                	mov    (%eax),%eax
  800b41:	ba 00 00 00 00       	mov    $0x0,%edx
  800b46:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b49:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b4c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4f:	8d 40 04             	lea    0x4(%eax),%eax
  800b52:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b55:	b8 08 00 00 00       	mov    $0x8,%eax
  800b5a:	eb 31                	jmp    800b8d <vprintfmt+0x428>
			putch('0', putdat);
  800b5c:	83 ec 08             	sub    $0x8,%esp
  800b5f:	53                   	push   %ebx
  800b60:	6a 30                	push   $0x30
  800b62:	ff d6                	call   *%esi
			putch('x', putdat);
  800b64:	83 c4 08             	add    $0x8,%esp
  800b67:	53                   	push   %ebx
  800b68:	6a 78                	push   $0x78
  800b6a:	ff d6                	call   *%esi
			num = (unsigned long long)
  800b6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6f:	8b 00                	mov    (%eax),%eax
  800b71:	ba 00 00 00 00       	mov    $0x0,%edx
  800b76:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b79:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800b7c:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800b7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b82:	8d 40 04             	lea    0x4(%eax),%eax
  800b85:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b88:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800b8d:	83 ec 0c             	sub    $0xc,%esp
  800b90:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800b94:	52                   	push   %edx
  800b95:	ff 75 e0             	pushl  -0x20(%ebp)
  800b98:	50                   	push   %eax
  800b99:	ff 75 dc             	pushl  -0x24(%ebp)
  800b9c:	ff 75 d8             	pushl  -0x28(%ebp)
  800b9f:	89 da                	mov    %ebx,%edx
  800ba1:	89 f0                	mov    %esi,%eax
  800ba3:	e8 a4 fa ff ff       	call   80064c <printnum>
			break;
  800ba8:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800bab:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bae:	83 c7 01             	add    $0x1,%edi
  800bb1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800bb5:	83 f8 25             	cmp    $0x25,%eax
  800bb8:	0f 84 be fb ff ff    	je     80077c <vprintfmt+0x17>
			if (ch == '\0')
  800bbe:	85 c0                	test   %eax,%eax
  800bc0:	0f 84 28 01 00 00    	je     800cee <vprintfmt+0x589>
			putch(ch, putdat);
  800bc6:	83 ec 08             	sub    $0x8,%esp
  800bc9:	53                   	push   %ebx
  800bca:	50                   	push   %eax
  800bcb:	ff d6                	call   *%esi
  800bcd:	83 c4 10             	add    $0x10,%esp
  800bd0:	eb dc                	jmp    800bae <vprintfmt+0x449>
	if (lflag >= 2)
  800bd2:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800bd6:	7f 26                	jg     800bfe <vprintfmt+0x499>
	else if (lflag)
  800bd8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800bdc:	74 41                	je     800c1f <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800bde:	8b 45 14             	mov    0x14(%ebp),%eax
  800be1:	8b 00                	mov    (%eax),%eax
  800be3:	ba 00 00 00 00       	mov    $0x0,%edx
  800be8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800beb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800bee:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf1:	8d 40 04             	lea    0x4(%eax),%eax
  800bf4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800bf7:	b8 10 00 00 00       	mov    $0x10,%eax
  800bfc:	eb 8f                	jmp    800b8d <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800bfe:	8b 45 14             	mov    0x14(%ebp),%eax
  800c01:	8b 50 04             	mov    0x4(%eax),%edx
  800c04:	8b 00                	mov    (%eax),%eax
  800c06:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c09:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c0f:	8d 40 08             	lea    0x8(%eax),%eax
  800c12:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c15:	b8 10 00 00 00       	mov    $0x10,%eax
  800c1a:	e9 6e ff ff ff       	jmp    800b8d <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800c1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c22:	8b 00                	mov    (%eax),%eax
  800c24:	ba 00 00 00 00       	mov    $0x0,%edx
  800c29:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c2c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c32:	8d 40 04             	lea    0x4(%eax),%eax
  800c35:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c38:	b8 10 00 00 00       	mov    $0x10,%eax
  800c3d:	e9 4b ff ff ff       	jmp    800b8d <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800c42:	8b 45 14             	mov    0x14(%ebp),%eax
  800c45:	83 c0 04             	add    $0x4,%eax
  800c48:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4e:	8b 00                	mov    (%eax),%eax
  800c50:	85 c0                	test   %eax,%eax
  800c52:	74 14                	je     800c68 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800c54:	8b 13                	mov    (%ebx),%edx
  800c56:	83 fa 7f             	cmp    $0x7f,%edx
  800c59:	7f 37                	jg     800c92 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800c5b:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800c5d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c60:	89 45 14             	mov    %eax,0x14(%ebp)
  800c63:	e9 43 ff ff ff       	jmp    800bab <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800c68:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c6d:	bf 95 36 80 00       	mov    $0x803695,%edi
							putch(ch, putdat);
  800c72:	83 ec 08             	sub    $0x8,%esp
  800c75:	53                   	push   %ebx
  800c76:	50                   	push   %eax
  800c77:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800c79:	83 c7 01             	add    $0x1,%edi
  800c7c:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800c80:	83 c4 10             	add    $0x10,%esp
  800c83:	85 c0                	test   %eax,%eax
  800c85:	75 eb                	jne    800c72 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800c87:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c8a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c8d:	e9 19 ff ff ff       	jmp    800bab <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800c92:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800c94:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c99:	bf cd 36 80 00       	mov    $0x8036cd,%edi
							putch(ch, putdat);
  800c9e:	83 ec 08             	sub    $0x8,%esp
  800ca1:	53                   	push   %ebx
  800ca2:	50                   	push   %eax
  800ca3:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800ca5:	83 c7 01             	add    $0x1,%edi
  800ca8:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800cac:	83 c4 10             	add    $0x10,%esp
  800caf:	85 c0                	test   %eax,%eax
  800cb1:	75 eb                	jne    800c9e <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800cb3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800cb6:	89 45 14             	mov    %eax,0x14(%ebp)
  800cb9:	e9 ed fe ff ff       	jmp    800bab <vprintfmt+0x446>
			putch(ch, putdat);
  800cbe:	83 ec 08             	sub    $0x8,%esp
  800cc1:	53                   	push   %ebx
  800cc2:	6a 25                	push   $0x25
  800cc4:	ff d6                	call   *%esi
			break;
  800cc6:	83 c4 10             	add    $0x10,%esp
  800cc9:	e9 dd fe ff ff       	jmp    800bab <vprintfmt+0x446>
			putch('%', putdat);
  800cce:	83 ec 08             	sub    $0x8,%esp
  800cd1:	53                   	push   %ebx
  800cd2:	6a 25                	push   $0x25
  800cd4:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cd6:	83 c4 10             	add    $0x10,%esp
  800cd9:	89 f8                	mov    %edi,%eax
  800cdb:	eb 03                	jmp    800ce0 <vprintfmt+0x57b>
  800cdd:	83 e8 01             	sub    $0x1,%eax
  800ce0:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800ce4:	75 f7                	jne    800cdd <vprintfmt+0x578>
  800ce6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ce9:	e9 bd fe ff ff       	jmp    800bab <vprintfmt+0x446>
}
  800cee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf1:	5b                   	pop    %ebx
  800cf2:	5e                   	pop    %esi
  800cf3:	5f                   	pop    %edi
  800cf4:	5d                   	pop    %ebp
  800cf5:	c3                   	ret    

00800cf6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	83 ec 18             	sub    $0x18,%esp
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d02:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d05:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800d09:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800d0c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d13:	85 c0                	test   %eax,%eax
  800d15:	74 26                	je     800d3d <vsnprintf+0x47>
  800d17:	85 d2                	test   %edx,%edx
  800d19:	7e 22                	jle    800d3d <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d1b:	ff 75 14             	pushl  0x14(%ebp)
  800d1e:	ff 75 10             	pushl  0x10(%ebp)
  800d21:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d24:	50                   	push   %eax
  800d25:	68 2b 07 80 00       	push   $0x80072b
  800d2a:	e8 36 fa ff ff       	call   800765 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800d2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d32:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d38:	83 c4 10             	add    $0x10,%esp
}
  800d3b:	c9                   	leave  
  800d3c:	c3                   	ret    
		return -E_INVAL;
  800d3d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d42:	eb f7                	jmp    800d3b <vsnprintf+0x45>

00800d44 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d4a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800d4d:	50                   	push   %eax
  800d4e:	ff 75 10             	pushl  0x10(%ebp)
  800d51:	ff 75 0c             	pushl  0xc(%ebp)
  800d54:	ff 75 08             	pushl  0x8(%ebp)
  800d57:	e8 9a ff ff ff       	call   800cf6 <vsnprintf>
	va_end(ap);

	return rc;
}
  800d5c:	c9                   	leave  
  800d5d:	c3                   	ret    

00800d5e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800d64:	b8 00 00 00 00       	mov    $0x0,%eax
  800d69:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800d6d:	74 05                	je     800d74 <strlen+0x16>
		n++;
  800d6f:	83 c0 01             	add    $0x1,%eax
  800d72:	eb f5                	jmp    800d69 <strlen+0xb>
	return n;
}
  800d74:	5d                   	pop    %ebp
  800d75:	c3                   	ret    

00800d76 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800d76:	55                   	push   %ebp
  800d77:	89 e5                	mov    %esp,%ebp
  800d79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d7c:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d7f:	ba 00 00 00 00       	mov    $0x0,%edx
  800d84:	39 c2                	cmp    %eax,%edx
  800d86:	74 0d                	je     800d95 <strnlen+0x1f>
  800d88:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800d8c:	74 05                	je     800d93 <strnlen+0x1d>
		n++;
  800d8e:	83 c2 01             	add    $0x1,%edx
  800d91:	eb f1                	jmp    800d84 <strnlen+0xe>
  800d93:	89 d0                	mov    %edx,%eax
	return n;
}
  800d95:	5d                   	pop    %ebp
  800d96:	c3                   	ret    

00800d97 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d97:	55                   	push   %ebp
  800d98:	89 e5                	mov    %esp,%ebp
  800d9a:	53                   	push   %ebx
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800da1:	ba 00 00 00 00       	mov    $0x0,%edx
  800da6:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800daa:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800dad:	83 c2 01             	add    $0x1,%edx
  800db0:	84 c9                	test   %cl,%cl
  800db2:	75 f2                	jne    800da6 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800db4:	5b                   	pop    %ebx
  800db5:	5d                   	pop    %ebp
  800db6:	c3                   	ret    

00800db7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800db7:	55                   	push   %ebp
  800db8:	89 e5                	mov    %esp,%ebp
  800dba:	53                   	push   %ebx
  800dbb:	83 ec 10             	sub    $0x10,%esp
  800dbe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800dc1:	53                   	push   %ebx
  800dc2:	e8 97 ff ff ff       	call   800d5e <strlen>
  800dc7:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800dca:	ff 75 0c             	pushl  0xc(%ebp)
  800dcd:	01 d8                	add    %ebx,%eax
  800dcf:	50                   	push   %eax
  800dd0:	e8 c2 ff ff ff       	call   800d97 <strcpy>
	return dst;
}
  800dd5:	89 d8                	mov    %ebx,%eax
  800dd7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800dda:	c9                   	leave  
  800ddb:	c3                   	ret    

00800ddc <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
  800ddf:	56                   	push   %esi
  800de0:	53                   	push   %ebx
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de7:	89 c6                	mov    %eax,%esi
  800de9:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dec:	89 c2                	mov    %eax,%edx
  800dee:	39 f2                	cmp    %esi,%edx
  800df0:	74 11                	je     800e03 <strncpy+0x27>
		*dst++ = *src;
  800df2:	83 c2 01             	add    $0x1,%edx
  800df5:	0f b6 19             	movzbl (%ecx),%ebx
  800df8:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800dfb:	80 fb 01             	cmp    $0x1,%bl
  800dfe:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800e01:	eb eb                	jmp    800dee <strncpy+0x12>
	}
	return ret;
}
  800e03:	5b                   	pop    %ebx
  800e04:	5e                   	pop    %esi
  800e05:	5d                   	pop    %ebp
  800e06:	c3                   	ret    

00800e07 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800e07:	55                   	push   %ebp
  800e08:	89 e5                	mov    %esp,%ebp
  800e0a:	56                   	push   %esi
  800e0b:	53                   	push   %ebx
  800e0c:	8b 75 08             	mov    0x8(%ebp),%esi
  800e0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e12:	8b 55 10             	mov    0x10(%ebp),%edx
  800e15:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800e17:	85 d2                	test   %edx,%edx
  800e19:	74 21                	je     800e3c <strlcpy+0x35>
  800e1b:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800e1f:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800e21:	39 c2                	cmp    %eax,%edx
  800e23:	74 14                	je     800e39 <strlcpy+0x32>
  800e25:	0f b6 19             	movzbl (%ecx),%ebx
  800e28:	84 db                	test   %bl,%bl
  800e2a:	74 0b                	je     800e37 <strlcpy+0x30>
			*dst++ = *src++;
  800e2c:	83 c1 01             	add    $0x1,%ecx
  800e2f:	83 c2 01             	add    $0x1,%edx
  800e32:	88 5a ff             	mov    %bl,-0x1(%edx)
  800e35:	eb ea                	jmp    800e21 <strlcpy+0x1a>
  800e37:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800e39:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e3c:	29 f0                	sub    %esi,%eax
}
  800e3e:	5b                   	pop    %ebx
  800e3f:	5e                   	pop    %esi
  800e40:	5d                   	pop    %ebp
  800e41:	c3                   	ret    

00800e42 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
  800e45:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e48:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800e4b:	0f b6 01             	movzbl (%ecx),%eax
  800e4e:	84 c0                	test   %al,%al
  800e50:	74 0c                	je     800e5e <strcmp+0x1c>
  800e52:	3a 02                	cmp    (%edx),%al
  800e54:	75 08                	jne    800e5e <strcmp+0x1c>
		p++, q++;
  800e56:	83 c1 01             	add    $0x1,%ecx
  800e59:	83 c2 01             	add    $0x1,%edx
  800e5c:	eb ed                	jmp    800e4b <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e5e:	0f b6 c0             	movzbl %al,%eax
  800e61:	0f b6 12             	movzbl (%edx),%edx
  800e64:	29 d0                	sub    %edx,%eax
}
  800e66:	5d                   	pop    %ebp
  800e67:	c3                   	ret    

00800e68 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800e68:	55                   	push   %ebp
  800e69:	89 e5                	mov    %esp,%ebp
  800e6b:	53                   	push   %ebx
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e72:	89 c3                	mov    %eax,%ebx
  800e74:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800e77:	eb 06                	jmp    800e7f <strncmp+0x17>
		n--, p++, q++;
  800e79:	83 c0 01             	add    $0x1,%eax
  800e7c:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800e7f:	39 d8                	cmp    %ebx,%eax
  800e81:	74 16                	je     800e99 <strncmp+0x31>
  800e83:	0f b6 08             	movzbl (%eax),%ecx
  800e86:	84 c9                	test   %cl,%cl
  800e88:	74 04                	je     800e8e <strncmp+0x26>
  800e8a:	3a 0a                	cmp    (%edx),%cl
  800e8c:	74 eb                	je     800e79 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e8e:	0f b6 00             	movzbl (%eax),%eax
  800e91:	0f b6 12             	movzbl (%edx),%edx
  800e94:	29 d0                	sub    %edx,%eax
}
  800e96:	5b                   	pop    %ebx
  800e97:	5d                   	pop    %ebp
  800e98:	c3                   	ret    
		return 0;
  800e99:	b8 00 00 00 00       	mov    $0x0,%eax
  800e9e:	eb f6                	jmp    800e96 <strncmp+0x2e>

00800ea0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ea0:	55                   	push   %ebp
  800ea1:	89 e5                	mov    %esp,%ebp
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800eaa:	0f b6 10             	movzbl (%eax),%edx
  800ead:	84 d2                	test   %dl,%dl
  800eaf:	74 09                	je     800eba <strchr+0x1a>
		if (*s == c)
  800eb1:	38 ca                	cmp    %cl,%dl
  800eb3:	74 0a                	je     800ebf <strchr+0x1f>
	for (; *s; s++)
  800eb5:	83 c0 01             	add    $0x1,%eax
  800eb8:	eb f0                	jmp    800eaa <strchr+0xa>
			return (char *) s;
	return 0;
  800eba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ebf:	5d                   	pop    %ebp
  800ec0:	c3                   	ret    

00800ec1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ec1:	55                   	push   %ebp
  800ec2:	89 e5                	mov    %esp,%ebp
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ecb:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ece:	38 ca                	cmp    %cl,%dl
  800ed0:	74 09                	je     800edb <strfind+0x1a>
  800ed2:	84 d2                	test   %dl,%dl
  800ed4:	74 05                	je     800edb <strfind+0x1a>
	for (; *s; s++)
  800ed6:	83 c0 01             	add    $0x1,%eax
  800ed9:	eb f0                	jmp    800ecb <strfind+0xa>
			break;
	return (char *) s;
}
  800edb:	5d                   	pop    %ebp
  800edc:	c3                   	ret    

00800edd <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	57                   	push   %edi
  800ee1:	56                   	push   %esi
  800ee2:	53                   	push   %ebx
  800ee3:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ee6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ee9:	85 c9                	test   %ecx,%ecx
  800eeb:	74 31                	je     800f1e <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800eed:	89 f8                	mov    %edi,%eax
  800eef:	09 c8                	or     %ecx,%eax
  800ef1:	a8 03                	test   $0x3,%al
  800ef3:	75 23                	jne    800f18 <memset+0x3b>
		c &= 0xFF;
  800ef5:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ef9:	89 d3                	mov    %edx,%ebx
  800efb:	c1 e3 08             	shl    $0x8,%ebx
  800efe:	89 d0                	mov    %edx,%eax
  800f00:	c1 e0 18             	shl    $0x18,%eax
  800f03:	89 d6                	mov    %edx,%esi
  800f05:	c1 e6 10             	shl    $0x10,%esi
  800f08:	09 f0                	or     %esi,%eax
  800f0a:	09 c2                	or     %eax,%edx
  800f0c:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800f0e:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800f11:	89 d0                	mov    %edx,%eax
  800f13:	fc                   	cld    
  800f14:	f3 ab                	rep stos %eax,%es:(%edi)
  800f16:	eb 06                	jmp    800f1e <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800f18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1b:	fc                   	cld    
  800f1c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800f1e:	89 f8                	mov    %edi,%eax
  800f20:	5b                   	pop    %ebx
  800f21:	5e                   	pop    %esi
  800f22:	5f                   	pop    %edi
  800f23:	5d                   	pop    %ebp
  800f24:	c3                   	ret    

00800f25 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800f25:	55                   	push   %ebp
  800f26:	89 e5                	mov    %esp,%ebp
  800f28:	57                   	push   %edi
  800f29:	56                   	push   %esi
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f30:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f33:	39 c6                	cmp    %eax,%esi
  800f35:	73 32                	jae    800f69 <memmove+0x44>
  800f37:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800f3a:	39 c2                	cmp    %eax,%edx
  800f3c:	76 2b                	jbe    800f69 <memmove+0x44>
		s += n;
		d += n;
  800f3e:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f41:	89 fe                	mov    %edi,%esi
  800f43:	09 ce                	or     %ecx,%esi
  800f45:	09 d6                	or     %edx,%esi
  800f47:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800f4d:	75 0e                	jne    800f5d <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800f4f:	83 ef 04             	sub    $0x4,%edi
  800f52:	8d 72 fc             	lea    -0x4(%edx),%esi
  800f55:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800f58:	fd                   	std    
  800f59:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f5b:	eb 09                	jmp    800f66 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800f5d:	83 ef 01             	sub    $0x1,%edi
  800f60:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800f63:	fd                   	std    
  800f64:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800f66:	fc                   	cld    
  800f67:	eb 1a                	jmp    800f83 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f69:	89 c2                	mov    %eax,%edx
  800f6b:	09 ca                	or     %ecx,%edx
  800f6d:	09 f2                	or     %esi,%edx
  800f6f:	f6 c2 03             	test   $0x3,%dl
  800f72:	75 0a                	jne    800f7e <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800f74:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800f77:	89 c7                	mov    %eax,%edi
  800f79:	fc                   	cld    
  800f7a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f7c:	eb 05                	jmp    800f83 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800f7e:	89 c7                	mov    %eax,%edi
  800f80:	fc                   	cld    
  800f81:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800f83:	5e                   	pop    %esi
  800f84:	5f                   	pop    %edi
  800f85:	5d                   	pop    %ebp
  800f86:	c3                   	ret    

00800f87 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800f87:	55                   	push   %ebp
  800f88:	89 e5                	mov    %esp,%ebp
  800f8a:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800f8d:	ff 75 10             	pushl  0x10(%ebp)
  800f90:	ff 75 0c             	pushl  0xc(%ebp)
  800f93:	ff 75 08             	pushl  0x8(%ebp)
  800f96:	e8 8a ff ff ff       	call   800f25 <memmove>
}
  800f9b:	c9                   	leave  
  800f9c:	c3                   	ret    

00800f9d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800f9d:	55                   	push   %ebp
  800f9e:	89 e5                	mov    %esp,%ebp
  800fa0:	56                   	push   %esi
  800fa1:	53                   	push   %ebx
  800fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fa8:	89 c6                	mov    %eax,%esi
  800faa:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800fad:	39 f0                	cmp    %esi,%eax
  800faf:	74 1c                	je     800fcd <memcmp+0x30>
		if (*s1 != *s2)
  800fb1:	0f b6 08             	movzbl (%eax),%ecx
  800fb4:	0f b6 1a             	movzbl (%edx),%ebx
  800fb7:	38 d9                	cmp    %bl,%cl
  800fb9:	75 08                	jne    800fc3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800fbb:	83 c0 01             	add    $0x1,%eax
  800fbe:	83 c2 01             	add    $0x1,%edx
  800fc1:	eb ea                	jmp    800fad <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800fc3:	0f b6 c1             	movzbl %cl,%eax
  800fc6:	0f b6 db             	movzbl %bl,%ebx
  800fc9:	29 d8                	sub    %ebx,%eax
  800fcb:	eb 05                	jmp    800fd2 <memcmp+0x35>
	}

	return 0;
  800fcd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fd2:	5b                   	pop    %ebx
  800fd3:	5e                   	pop    %esi
  800fd4:	5d                   	pop    %ebp
  800fd5:	c3                   	ret    

00800fd6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800fd6:	55                   	push   %ebp
  800fd7:	89 e5                	mov    %esp,%ebp
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800fdf:	89 c2                	mov    %eax,%edx
  800fe1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800fe4:	39 d0                	cmp    %edx,%eax
  800fe6:	73 09                	jae    800ff1 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fe8:	38 08                	cmp    %cl,(%eax)
  800fea:	74 05                	je     800ff1 <memfind+0x1b>
	for (; s < ends; s++)
  800fec:	83 c0 01             	add    $0x1,%eax
  800fef:	eb f3                	jmp    800fe4 <memfind+0xe>
			break;
	return (void *) s;
}
  800ff1:	5d                   	pop    %ebp
  800ff2:	c3                   	ret    

00800ff3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ff3:	55                   	push   %ebp
  800ff4:	89 e5                	mov    %esp,%ebp
  800ff6:	57                   	push   %edi
  800ff7:	56                   	push   %esi
  800ff8:	53                   	push   %ebx
  800ff9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ffc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fff:	eb 03                	jmp    801004 <strtol+0x11>
		s++;
  801001:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801004:	0f b6 01             	movzbl (%ecx),%eax
  801007:	3c 20                	cmp    $0x20,%al
  801009:	74 f6                	je     801001 <strtol+0xe>
  80100b:	3c 09                	cmp    $0x9,%al
  80100d:	74 f2                	je     801001 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  80100f:	3c 2b                	cmp    $0x2b,%al
  801011:	74 2a                	je     80103d <strtol+0x4a>
	int neg = 0;
  801013:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801018:	3c 2d                	cmp    $0x2d,%al
  80101a:	74 2b                	je     801047 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80101c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801022:	75 0f                	jne    801033 <strtol+0x40>
  801024:	80 39 30             	cmpb   $0x30,(%ecx)
  801027:	74 28                	je     801051 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801029:	85 db                	test   %ebx,%ebx
  80102b:	b8 0a 00 00 00       	mov    $0xa,%eax
  801030:	0f 44 d8             	cmove  %eax,%ebx
  801033:	b8 00 00 00 00       	mov    $0x0,%eax
  801038:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80103b:	eb 50                	jmp    80108d <strtol+0x9a>
		s++;
  80103d:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801040:	bf 00 00 00 00       	mov    $0x0,%edi
  801045:	eb d5                	jmp    80101c <strtol+0x29>
		s++, neg = 1;
  801047:	83 c1 01             	add    $0x1,%ecx
  80104a:	bf 01 00 00 00       	mov    $0x1,%edi
  80104f:	eb cb                	jmp    80101c <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801051:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801055:	74 0e                	je     801065 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  801057:	85 db                	test   %ebx,%ebx
  801059:	75 d8                	jne    801033 <strtol+0x40>
		s++, base = 8;
  80105b:	83 c1 01             	add    $0x1,%ecx
  80105e:	bb 08 00 00 00       	mov    $0x8,%ebx
  801063:	eb ce                	jmp    801033 <strtol+0x40>
		s += 2, base = 16;
  801065:	83 c1 02             	add    $0x2,%ecx
  801068:	bb 10 00 00 00       	mov    $0x10,%ebx
  80106d:	eb c4                	jmp    801033 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  80106f:	8d 72 9f             	lea    -0x61(%edx),%esi
  801072:	89 f3                	mov    %esi,%ebx
  801074:	80 fb 19             	cmp    $0x19,%bl
  801077:	77 29                	ja     8010a2 <strtol+0xaf>
			dig = *s - 'a' + 10;
  801079:	0f be d2             	movsbl %dl,%edx
  80107c:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  80107f:	3b 55 10             	cmp    0x10(%ebp),%edx
  801082:	7d 30                	jge    8010b4 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801084:	83 c1 01             	add    $0x1,%ecx
  801087:	0f af 45 10          	imul   0x10(%ebp),%eax
  80108b:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  80108d:	0f b6 11             	movzbl (%ecx),%edx
  801090:	8d 72 d0             	lea    -0x30(%edx),%esi
  801093:	89 f3                	mov    %esi,%ebx
  801095:	80 fb 09             	cmp    $0x9,%bl
  801098:	77 d5                	ja     80106f <strtol+0x7c>
			dig = *s - '0';
  80109a:	0f be d2             	movsbl %dl,%edx
  80109d:	83 ea 30             	sub    $0x30,%edx
  8010a0:	eb dd                	jmp    80107f <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  8010a2:	8d 72 bf             	lea    -0x41(%edx),%esi
  8010a5:	89 f3                	mov    %esi,%ebx
  8010a7:	80 fb 19             	cmp    $0x19,%bl
  8010aa:	77 08                	ja     8010b4 <strtol+0xc1>
			dig = *s - 'A' + 10;
  8010ac:	0f be d2             	movsbl %dl,%edx
  8010af:	83 ea 37             	sub    $0x37,%edx
  8010b2:	eb cb                	jmp    80107f <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  8010b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010b8:	74 05                	je     8010bf <strtol+0xcc>
		*endptr = (char *) s;
  8010ba:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010bd:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8010bf:	89 c2                	mov    %eax,%edx
  8010c1:	f7 da                	neg    %edx
  8010c3:	85 ff                	test   %edi,%edi
  8010c5:	0f 45 c2             	cmovne %edx,%eax
}
  8010c8:	5b                   	pop    %ebx
  8010c9:	5e                   	pop    %esi
  8010ca:	5f                   	pop    %edi
  8010cb:	5d                   	pop    %ebp
  8010cc:	c3                   	ret    

008010cd <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8010cd:	55                   	push   %ebp
  8010ce:	89 e5                	mov    %esp,%ebp
  8010d0:	57                   	push   %edi
  8010d1:	56                   	push   %esi
  8010d2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8010d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010de:	89 c3                	mov    %eax,%ebx
  8010e0:	89 c7                	mov    %eax,%edi
  8010e2:	89 c6                	mov    %eax,%esi
  8010e4:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8010e6:	5b                   	pop    %ebx
  8010e7:	5e                   	pop    %esi
  8010e8:	5f                   	pop    %edi
  8010e9:	5d                   	pop    %ebp
  8010ea:	c3                   	ret    

008010eb <sys_cgetc>:

int
sys_cgetc(void)
{
  8010eb:	55                   	push   %ebp
  8010ec:	89 e5                	mov    %esp,%ebp
  8010ee:	57                   	push   %edi
  8010ef:	56                   	push   %esi
  8010f0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8010f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8010fb:	89 d1                	mov    %edx,%ecx
  8010fd:	89 d3                	mov    %edx,%ebx
  8010ff:	89 d7                	mov    %edx,%edi
  801101:	89 d6                	mov    %edx,%esi
  801103:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801105:	5b                   	pop    %ebx
  801106:	5e                   	pop    %esi
  801107:	5f                   	pop    %edi
  801108:	5d                   	pop    %ebp
  801109:	c3                   	ret    

0080110a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80110a:	55                   	push   %ebp
  80110b:	89 e5                	mov    %esp,%ebp
  80110d:	57                   	push   %edi
  80110e:	56                   	push   %esi
  80110f:	53                   	push   %ebx
  801110:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801113:	b9 00 00 00 00       	mov    $0x0,%ecx
  801118:	8b 55 08             	mov    0x8(%ebp),%edx
  80111b:	b8 03 00 00 00       	mov    $0x3,%eax
  801120:	89 cb                	mov    %ecx,%ebx
  801122:	89 cf                	mov    %ecx,%edi
  801124:	89 ce                	mov    %ecx,%esi
  801126:	cd 30                	int    $0x30
	if(check && ret > 0)
  801128:	85 c0                	test   %eax,%eax
  80112a:	7f 08                	jg     801134 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
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
  801138:	6a 03                	push   $0x3
  80113a:	68 e4 38 80 00       	push   $0x8038e4
  80113f:	6a 43                	push   $0x43
  801141:	68 01 39 80 00       	push   $0x803901
  801146:	e8 f7 f3 ff ff       	call   800542 <_panic>

0080114b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80114b:	55                   	push   %ebp
  80114c:	89 e5                	mov    %esp,%ebp
  80114e:	57                   	push   %edi
  80114f:	56                   	push   %esi
  801150:	53                   	push   %ebx
	asm volatile("int %1\n"
  801151:	ba 00 00 00 00       	mov    $0x0,%edx
  801156:	b8 02 00 00 00       	mov    $0x2,%eax
  80115b:	89 d1                	mov    %edx,%ecx
  80115d:	89 d3                	mov    %edx,%ebx
  80115f:	89 d7                	mov    %edx,%edi
  801161:	89 d6                	mov    %edx,%esi
  801163:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801165:	5b                   	pop    %ebx
  801166:	5e                   	pop    %esi
  801167:	5f                   	pop    %edi
  801168:	5d                   	pop    %ebp
  801169:	c3                   	ret    

0080116a <sys_yield>:

void
sys_yield(void)
{
  80116a:	55                   	push   %ebp
  80116b:	89 e5                	mov    %esp,%ebp
  80116d:	57                   	push   %edi
  80116e:	56                   	push   %esi
  80116f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801170:	ba 00 00 00 00       	mov    $0x0,%edx
  801175:	b8 0b 00 00 00       	mov    $0xb,%eax
  80117a:	89 d1                	mov    %edx,%ecx
  80117c:	89 d3                	mov    %edx,%ebx
  80117e:	89 d7                	mov    %edx,%edi
  801180:	89 d6                	mov    %edx,%esi
  801182:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801184:	5b                   	pop    %ebx
  801185:	5e                   	pop    %esi
  801186:	5f                   	pop    %edi
  801187:	5d                   	pop    %ebp
  801188:	c3                   	ret    

00801189 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801189:	55                   	push   %ebp
  80118a:	89 e5                	mov    %esp,%ebp
  80118c:	57                   	push   %edi
  80118d:	56                   	push   %esi
  80118e:	53                   	push   %ebx
  80118f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801192:	be 00 00 00 00       	mov    $0x0,%esi
  801197:	8b 55 08             	mov    0x8(%ebp),%edx
  80119a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80119d:	b8 04 00 00 00       	mov    $0x4,%eax
  8011a2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011a5:	89 f7                	mov    %esi,%edi
  8011a7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011a9:	85 c0                	test   %eax,%eax
  8011ab:	7f 08                	jg     8011b5 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8011ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011b0:	5b                   	pop    %ebx
  8011b1:	5e                   	pop    %esi
  8011b2:	5f                   	pop    %edi
  8011b3:	5d                   	pop    %ebp
  8011b4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011b5:	83 ec 0c             	sub    $0xc,%esp
  8011b8:	50                   	push   %eax
  8011b9:	6a 04                	push   $0x4
  8011bb:	68 e4 38 80 00       	push   $0x8038e4
  8011c0:	6a 43                	push   $0x43
  8011c2:	68 01 39 80 00       	push   $0x803901
  8011c7:	e8 76 f3 ff ff       	call   800542 <_panic>

008011cc <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8011cc:	55                   	push   %ebp
  8011cd:	89 e5                	mov    %esp,%ebp
  8011cf:	57                   	push   %edi
  8011d0:	56                   	push   %esi
  8011d1:	53                   	push   %ebx
  8011d2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011db:	b8 05 00 00 00       	mov    $0x5,%eax
  8011e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011e3:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011e6:	8b 75 18             	mov    0x18(%ebp),%esi
  8011e9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011eb:	85 c0                	test   %eax,%eax
  8011ed:	7f 08                	jg     8011f7 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8011ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011f2:	5b                   	pop    %ebx
  8011f3:	5e                   	pop    %esi
  8011f4:	5f                   	pop    %edi
  8011f5:	5d                   	pop    %ebp
  8011f6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011f7:	83 ec 0c             	sub    $0xc,%esp
  8011fa:	50                   	push   %eax
  8011fb:	6a 05                	push   $0x5
  8011fd:	68 e4 38 80 00       	push   $0x8038e4
  801202:	6a 43                	push   $0x43
  801204:	68 01 39 80 00       	push   $0x803901
  801209:	e8 34 f3 ff ff       	call   800542 <_panic>

0080120e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80120e:	55                   	push   %ebp
  80120f:	89 e5                	mov    %esp,%ebp
  801211:	57                   	push   %edi
  801212:	56                   	push   %esi
  801213:	53                   	push   %ebx
  801214:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801217:	bb 00 00 00 00       	mov    $0x0,%ebx
  80121c:	8b 55 08             	mov    0x8(%ebp),%edx
  80121f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801222:	b8 06 00 00 00       	mov    $0x6,%eax
  801227:	89 df                	mov    %ebx,%edi
  801229:	89 de                	mov    %ebx,%esi
  80122b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80122d:	85 c0                	test   %eax,%eax
  80122f:	7f 08                	jg     801239 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801231:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801234:	5b                   	pop    %ebx
  801235:	5e                   	pop    %esi
  801236:	5f                   	pop    %edi
  801237:	5d                   	pop    %ebp
  801238:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801239:	83 ec 0c             	sub    $0xc,%esp
  80123c:	50                   	push   %eax
  80123d:	6a 06                	push   $0x6
  80123f:	68 e4 38 80 00       	push   $0x8038e4
  801244:	6a 43                	push   $0x43
  801246:	68 01 39 80 00       	push   $0x803901
  80124b:	e8 f2 f2 ff ff       	call   800542 <_panic>

00801250 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801250:	55                   	push   %ebp
  801251:	89 e5                	mov    %esp,%ebp
  801253:	57                   	push   %edi
  801254:	56                   	push   %esi
  801255:	53                   	push   %ebx
  801256:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801259:	bb 00 00 00 00       	mov    $0x0,%ebx
  80125e:	8b 55 08             	mov    0x8(%ebp),%edx
  801261:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801264:	b8 08 00 00 00       	mov    $0x8,%eax
  801269:	89 df                	mov    %ebx,%edi
  80126b:	89 de                	mov    %ebx,%esi
  80126d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80126f:	85 c0                	test   %eax,%eax
  801271:	7f 08                	jg     80127b <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801273:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801276:	5b                   	pop    %ebx
  801277:	5e                   	pop    %esi
  801278:	5f                   	pop    %edi
  801279:	5d                   	pop    %ebp
  80127a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80127b:	83 ec 0c             	sub    $0xc,%esp
  80127e:	50                   	push   %eax
  80127f:	6a 08                	push   $0x8
  801281:	68 e4 38 80 00       	push   $0x8038e4
  801286:	6a 43                	push   $0x43
  801288:	68 01 39 80 00       	push   $0x803901
  80128d:	e8 b0 f2 ff ff       	call   800542 <_panic>

00801292 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801292:	55                   	push   %ebp
  801293:	89 e5                	mov    %esp,%ebp
  801295:	57                   	push   %edi
  801296:	56                   	push   %esi
  801297:	53                   	push   %ebx
  801298:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80129b:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012a6:	b8 09 00 00 00       	mov    $0x9,%eax
  8012ab:	89 df                	mov    %ebx,%edi
  8012ad:	89 de                	mov    %ebx,%esi
  8012af:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012b1:	85 c0                	test   %eax,%eax
  8012b3:	7f 08                	jg     8012bd <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8012b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012b8:	5b                   	pop    %ebx
  8012b9:	5e                   	pop    %esi
  8012ba:	5f                   	pop    %edi
  8012bb:	5d                   	pop    %ebp
  8012bc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012bd:	83 ec 0c             	sub    $0xc,%esp
  8012c0:	50                   	push   %eax
  8012c1:	6a 09                	push   $0x9
  8012c3:	68 e4 38 80 00       	push   $0x8038e4
  8012c8:	6a 43                	push   $0x43
  8012ca:	68 01 39 80 00       	push   $0x803901
  8012cf:	e8 6e f2 ff ff       	call   800542 <_panic>

008012d4 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8012d4:	55                   	push   %ebp
  8012d5:	89 e5                	mov    %esp,%ebp
  8012d7:	57                   	push   %edi
  8012d8:	56                   	push   %esi
  8012d9:	53                   	push   %ebx
  8012da:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012dd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012e8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8012ed:	89 df                	mov    %ebx,%edi
  8012ef:	89 de                	mov    %ebx,%esi
  8012f1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012f3:	85 c0                	test   %eax,%eax
  8012f5:	7f 08                	jg     8012ff <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8012f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012fa:	5b                   	pop    %ebx
  8012fb:	5e                   	pop    %esi
  8012fc:	5f                   	pop    %edi
  8012fd:	5d                   	pop    %ebp
  8012fe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012ff:	83 ec 0c             	sub    $0xc,%esp
  801302:	50                   	push   %eax
  801303:	6a 0a                	push   $0xa
  801305:	68 e4 38 80 00       	push   $0x8038e4
  80130a:	6a 43                	push   $0x43
  80130c:	68 01 39 80 00       	push   $0x803901
  801311:	e8 2c f2 ff ff       	call   800542 <_panic>

00801316 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
  801319:	57                   	push   %edi
  80131a:	56                   	push   %esi
  80131b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80131c:	8b 55 08             	mov    0x8(%ebp),%edx
  80131f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801322:	b8 0c 00 00 00       	mov    $0xc,%eax
  801327:	be 00 00 00 00       	mov    $0x0,%esi
  80132c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80132f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801332:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801334:	5b                   	pop    %ebx
  801335:	5e                   	pop    %esi
  801336:	5f                   	pop    %edi
  801337:	5d                   	pop    %ebp
  801338:	c3                   	ret    

00801339 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
  80133c:	57                   	push   %edi
  80133d:	56                   	push   %esi
  80133e:	53                   	push   %ebx
  80133f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801342:	b9 00 00 00 00       	mov    $0x0,%ecx
  801347:	8b 55 08             	mov    0x8(%ebp),%edx
  80134a:	b8 0d 00 00 00       	mov    $0xd,%eax
  80134f:	89 cb                	mov    %ecx,%ebx
  801351:	89 cf                	mov    %ecx,%edi
  801353:	89 ce                	mov    %ecx,%esi
  801355:	cd 30                	int    $0x30
	if(check && ret > 0)
  801357:	85 c0                	test   %eax,%eax
  801359:	7f 08                	jg     801363 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80135b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80135e:	5b                   	pop    %ebx
  80135f:	5e                   	pop    %esi
  801360:	5f                   	pop    %edi
  801361:	5d                   	pop    %ebp
  801362:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801363:	83 ec 0c             	sub    $0xc,%esp
  801366:	50                   	push   %eax
  801367:	6a 0d                	push   $0xd
  801369:	68 e4 38 80 00       	push   $0x8038e4
  80136e:	6a 43                	push   $0x43
  801370:	68 01 39 80 00       	push   $0x803901
  801375:	e8 c8 f1 ff ff       	call   800542 <_panic>

0080137a <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
  80137d:	57                   	push   %edi
  80137e:	56                   	push   %esi
  80137f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801380:	bb 00 00 00 00       	mov    $0x0,%ebx
  801385:	8b 55 08             	mov    0x8(%ebp),%edx
  801388:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80138b:	b8 0e 00 00 00       	mov    $0xe,%eax
  801390:	89 df                	mov    %ebx,%edi
  801392:	89 de                	mov    %ebx,%esi
  801394:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801396:	5b                   	pop    %ebx
  801397:	5e                   	pop    %esi
  801398:	5f                   	pop    %edi
  801399:	5d                   	pop    %ebp
  80139a:	c3                   	ret    

0080139b <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80139b:	55                   	push   %ebp
  80139c:	89 e5                	mov    %esp,%ebp
  80139e:	57                   	push   %edi
  80139f:	56                   	push   %esi
  8013a0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013a1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8013a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8013a9:	b8 0f 00 00 00       	mov    $0xf,%eax
  8013ae:	89 cb                	mov    %ecx,%ebx
  8013b0:	89 cf                	mov    %ecx,%edi
  8013b2:	89 ce                	mov    %ecx,%esi
  8013b4:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8013b6:	5b                   	pop    %ebx
  8013b7:	5e                   	pop    %esi
  8013b8:	5f                   	pop    %edi
  8013b9:	5d                   	pop    %ebp
  8013ba:	c3                   	ret    

008013bb <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
  8013be:	57                   	push   %edi
  8013bf:	56                   	push   %esi
  8013c0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8013c6:	b8 10 00 00 00       	mov    $0x10,%eax
  8013cb:	89 d1                	mov    %edx,%ecx
  8013cd:	89 d3                	mov    %edx,%ebx
  8013cf:	89 d7                	mov    %edx,%edi
  8013d1:	89 d6                	mov    %edx,%esi
  8013d3:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8013d5:	5b                   	pop    %ebx
  8013d6:	5e                   	pop    %esi
  8013d7:	5f                   	pop    %edi
  8013d8:	5d                   	pop    %ebp
  8013d9:	c3                   	ret    

008013da <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
  8013dd:	57                   	push   %edi
  8013de:	56                   	push   %esi
  8013df:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013e0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8013e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013eb:	b8 11 00 00 00       	mov    $0x11,%eax
  8013f0:	89 df                	mov    %ebx,%edi
  8013f2:	89 de                	mov    %ebx,%esi
  8013f4:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8013f6:	5b                   	pop    %ebx
  8013f7:	5e                   	pop    %esi
  8013f8:	5f                   	pop    %edi
  8013f9:	5d                   	pop    %ebp
  8013fa:	c3                   	ret    

008013fb <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8013fb:	55                   	push   %ebp
  8013fc:	89 e5                	mov    %esp,%ebp
  8013fe:	57                   	push   %edi
  8013ff:	56                   	push   %esi
  801400:	53                   	push   %ebx
	asm volatile("int %1\n"
  801401:	bb 00 00 00 00       	mov    $0x0,%ebx
  801406:	8b 55 08             	mov    0x8(%ebp),%edx
  801409:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80140c:	b8 12 00 00 00       	mov    $0x12,%eax
  801411:	89 df                	mov    %ebx,%edi
  801413:	89 de                	mov    %ebx,%esi
  801415:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801417:	5b                   	pop    %ebx
  801418:	5e                   	pop    %esi
  801419:	5f                   	pop    %edi
  80141a:	5d                   	pop    %ebp
  80141b:	c3                   	ret    

0080141c <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80141c:	55                   	push   %ebp
  80141d:	89 e5                	mov    %esp,%ebp
  80141f:	57                   	push   %edi
  801420:	56                   	push   %esi
  801421:	53                   	push   %ebx
  801422:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801425:	bb 00 00 00 00       	mov    $0x0,%ebx
  80142a:	8b 55 08             	mov    0x8(%ebp),%edx
  80142d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801430:	b8 13 00 00 00       	mov    $0x13,%eax
  801435:	89 df                	mov    %ebx,%edi
  801437:	89 de                	mov    %ebx,%esi
  801439:	cd 30                	int    $0x30
	if(check && ret > 0)
  80143b:	85 c0                	test   %eax,%eax
  80143d:	7f 08                	jg     801447 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80143f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801442:	5b                   	pop    %ebx
  801443:	5e                   	pop    %esi
  801444:	5f                   	pop    %edi
  801445:	5d                   	pop    %ebp
  801446:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801447:	83 ec 0c             	sub    $0xc,%esp
  80144a:	50                   	push   %eax
  80144b:	6a 13                	push   $0x13
  80144d:	68 e4 38 80 00       	push   $0x8038e4
  801452:	6a 43                	push   $0x43
  801454:	68 01 39 80 00       	push   $0x803901
  801459:	e8 e4 f0 ff ff       	call   800542 <_panic>

0080145e <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80145e:	55                   	push   %ebp
  80145f:	89 e5                	mov    %esp,%ebp
  801461:	53                   	push   %ebx
  801462:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801465:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80146c:	f6 c5 04             	test   $0x4,%ch
  80146f:	75 45                	jne    8014b6 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801471:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801478:	83 e1 07             	and    $0x7,%ecx
  80147b:	83 f9 07             	cmp    $0x7,%ecx
  80147e:	74 6f                	je     8014ef <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801480:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801487:	81 e1 05 08 00 00    	and    $0x805,%ecx
  80148d:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801493:	0f 84 b6 00 00 00    	je     80154f <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801499:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8014a0:	83 e1 05             	and    $0x5,%ecx
  8014a3:	83 f9 05             	cmp    $0x5,%ecx
  8014a6:	0f 84 d7 00 00 00    	je     801583 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8014ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014b4:	c9                   	leave  
  8014b5:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  8014b6:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8014bd:	c1 e2 0c             	shl    $0xc,%edx
  8014c0:	83 ec 0c             	sub    $0xc,%esp
  8014c3:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8014c9:	51                   	push   %ecx
  8014ca:	52                   	push   %edx
  8014cb:	50                   	push   %eax
  8014cc:	52                   	push   %edx
  8014cd:	6a 00                	push   $0x0
  8014cf:	e8 f8 fc ff ff       	call   8011cc <sys_page_map>
		if(r < 0)
  8014d4:	83 c4 20             	add    $0x20,%esp
  8014d7:	85 c0                	test   %eax,%eax
  8014d9:	79 d1                	jns    8014ac <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8014db:	83 ec 04             	sub    $0x4,%esp
  8014de:	68 0f 39 80 00       	push   $0x80390f
  8014e3:	6a 54                	push   $0x54
  8014e5:	68 25 39 80 00       	push   $0x803925
  8014ea:	e8 53 f0 ff ff       	call   800542 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8014ef:	89 d3                	mov    %edx,%ebx
  8014f1:	c1 e3 0c             	shl    $0xc,%ebx
  8014f4:	83 ec 0c             	sub    $0xc,%esp
  8014f7:	68 05 08 00 00       	push   $0x805
  8014fc:	53                   	push   %ebx
  8014fd:	50                   	push   %eax
  8014fe:	53                   	push   %ebx
  8014ff:	6a 00                	push   $0x0
  801501:	e8 c6 fc ff ff       	call   8011cc <sys_page_map>
		if(r < 0)
  801506:	83 c4 20             	add    $0x20,%esp
  801509:	85 c0                	test   %eax,%eax
  80150b:	78 2e                	js     80153b <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  80150d:	83 ec 0c             	sub    $0xc,%esp
  801510:	68 05 08 00 00       	push   $0x805
  801515:	53                   	push   %ebx
  801516:	6a 00                	push   $0x0
  801518:	53                   	push   %ebx
  801519:	6a 00                	push   $0x0
  80151b:	e8 ac fc ff ff       	call   8011cc <sys_page_map>
		if(r < 0)
  801520:	83 c4 20             	add    $0x20,%esp
  801523:	85 c0                	test   %eax,%eax
  801525:	79 85                	jns    8014ac <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801527:	83 ec 04             	sub    $0x4,%esp
  80152a:	68 0f 39 80 00       	push   $0x80390f
  80152f:	6a 5f                	push   $0x5f
  801531:	68 25 39 80 00       	push   $0x803925
  801536:	e8 07 f0 ff ff       	call   800542 <_panic>
			panic("sys_page_map() panic\n");
  80153b:	83 ec 04             	sub    $0x4,%esp
  80153e:	68 0f 39 80 00       	push   $0x80390f
  801543:	6a 5b                	push   $0x5b
  801545:	68 25 39 80 00       	push   $0x803925
  80154a:	e8 f3 ef ff ff       	call   800542 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80154f:	c1 e2 0c             	shl    $0xc,%edx
  801552:	83 ec 0c             	sub    $0xc,%esp
  801555:	68 05 08 00 00       	push   $0x805
  80155a:	52                   	push   %edx
  80155b:	50                   	push   %eax
  80155c:	52                   	push   %edx
  80155d:	6a 00                	push   $0x0
  80155f:	e8 68 fc ff ff       	call   8011cc <sys_page_map>
		if(r < 0)
  801564:	83 c4 20             	add    $0x20,%esp
  801567:	85 c0                	test   %eax,%eax
  801569:	0f 89 3d ff ff ff    	jns    8014ac <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80156f:	83 ec 04             	sub    $0x4,%esp
  801572:	68 0f 39 80 00       	push   $0x80390f
  801577:	6a 66                	push   $0x66
  801579:	68 25 39 80 00       	push   $0x803925
  80157e:	e8 bf ef ff ff       	call   800542 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801583:	c1 e2 0c             	shl    $0xc,%edx
  801586:	83 ec 0c             	sub    $0xc,%esp
  801589:	6a 05                	push   $0x5
  80158b:	52                   	push   %edx
  80158c:	50                   	push   %eax
  80158d:	52                   	push   %edx
  80158e:	6a 00                	push   $0x0
  801590:	e8 37 fc ff ff       	call   8011cc <sys_page_map>
		if(r < 0)
  801595:	83 c4 20             	add    $0x20,%esp
  801598:	85 c0                	test   %eax,%eax
  80159a:	0f 89 0c ff ff ff    	jns    8014ac <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8015a0:	83 ec 04             	sub    $0x4,%esp
  8015a3:	68 0f 39 80 00       	push   $0x80390f
  8015a8:	6a 6d                	push   $0x6d
  8015aa:	68 25 39 80 00       	push   $0x803925
  8015af:	e8 8e ef ff ff       	call   800542 <_panic>

008015b4 <pgfault>:
{
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
  8015b7:	53                   	push   %ebx
  8015b8:	83 ec 04             	sub    $0x4,%esp
  8015bb:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8015be:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8015c0:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8015c4:	0f 84 99 00 00 00    	je     801663 <pgfault+0xaf>
  8015ca:	89 c2                	mov    %eax,%edx
  8015cc:	c1 ea 16             	shr    $0x16,%edx
  8015cf:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015d6:	f6 c2 01             	test   $0x1,%dl
  8015d9:	0f 84 84 00 00 00    	je     801663 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8015df:	89 c2                	mov    %eax,%edx
  8015e1:	c1 ea 0c             	shr    $0xc,%edx
  8015e4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015eb:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8015f1:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8015f7:	75 6a                	jne    801663 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8015f9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015fe:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801600:	83 ec 04             	sub    $0x4,%esp
  801603:	6a 07                	push   $0x7
  801605:	68 00 f0 7f 00       	push   $0x7ff000
  80160a:	6a 00                	push   $0x0
  80160c:	e8 78 fb ff ff       	call   801189 <sys_page_alloc>
	if(ret < 0)
  801611:	83 c4 10             	add    $0x10,%esp
  801614:	85 c0                	test   %eax,%eax
  801616:	78 5f                	js     801677 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801618:	83 ec 04             	sub    $0x4,%esp
  80161b:	68 00 10 00 00       	push   $0x1000
  801620:	53                   	push   %ebx
  801621:	68 00 f0 7f 00       	push   $0x7ff000
  801626:	e8 5c f9 ff ff       	call   800f87 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  80162b:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801632:	53                   	push   %ebx
  801633:	6a 00                	push   $0x0
  801635:	68 00 f0 7f 00       	push   $0x7ff000
  80163a:	6a 00                	push   $0x0
  80163c:	e8 8b fb ff ff       	call   8011cc <sys_page_map>
	if(ret < 0)
  801641:	83 c4 20             	add    $0x20,%esp
  801644:	85 c0                	test   %eax,%eax
  801646:	78 43                	js     80168b <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801648:	83 ec 08             	sub    $0x8,%esp
  80164b:	68 00 f0 7f 00       	push   $0x7ff000
  801650:	6a 00                	push   $0x0
  801652:	e8 b7 fb ff ff       	call   80120e <sys_page_unmap>
	if(ret < 0)
  801657:	83 c4 10             	add    $0x10,%esp
  80165a:	85 c0                	test   %eax,%eax
  80165c:	78 41                	js     80169f <pgfault+0xeb>
}
  80165e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801661:	c9                   	leave  
  801662:	c3                   	ret    
		panic("panic at pgfault()\n");
  801663:	83 ec 04             	sub    $0x4,%esp
  801666:	68 30 39 80 00       	push   $0x803930
  80166b:	6a 26                	push   $0x26
  80166d:	68 25 39 80 00       	push   $0x803925
  801672:	e8 cb ee ff ff       	call   800542 <_panic>
		panic("panic in sys_page_alloc()\n");
  801677:	83 ec 04             	sub    $0x4,%esp
  80167a:	68 44 39 80 00       	push   $0x803944
  80167f:	6a 31                	push   $0x31
  801681:	68 25 39 80 00       	push   $0x803925
  801686:	e8 b7 ee ff ff       	call   800542 <_panic>
		panic("panic in sys_page_map()\n");
  80168b:	83 ec 04             	sub    $0x4,%esp
  80168e:	68 5f 39 80 00       	push   $0x80395f
  801693:	6a 36                	push   $0x36
  801695:	68 25 39 80 00       	push   $0x803925
  80169a:	e8 a3 ee ff ff       	call   800542 <_panic>
		panic("panic in sys_page_unmap()\n");
  80169f:	83 ec 04             	sub    $0x4,%esp
  8016a2:	68 78 39 80 00       	push   $0x803978
  8016a7:	6a 39                	push   $0x39
  8016a9:	68 25 39 80 00       	push   $0x803925
  8016ae:	e8 8f ee ff ff       	call   800542 <_panic>

008016b3 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8016b3:	55                   	push   %ebp
  8016b4:	89 e5                	mov    %esp,%ebp
  8016b6:	57                   	push   %edi
  8016b7:	56                   	push   %esi
  8016b8:	53                   	push   %ebx
  8016b9:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  8016bc:	68 b4 15 80 00       	push   $0x8015b4
  8016c1:	e8 cb 18 00 00       	call   802f91 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8016c6:	b8 07 00 00 00       	mov    $0x7,%eax
  8016cb:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8016cd:	83 c4 10             	add    $0x10,%esp
  8016d0:	85 c0                	test   %eax,%eax
  8016d2:	78 27                	js     8016fb <fork+0x48>
  8016d4:	89 c6                	mov    %eax,%esi
  8016d6:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8016d8:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8016dd:	75 48                	jne    801727 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  8016df:	e8 67 fa ff ff       	call   80114b <sys_getenvid>
  8016e4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8016e9:	c1 e0 07             	shl    $0x7,%eax
  8016ec:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8016f1:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8016f6:	e9 90 00 00 00       	jmp    80178b <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  8016fb:	83 ec 04             	sub    $0x4,%esp
  8016fe:	68 94 39 80 00       	push   $0x803994
  801703:	68 8c 00 00 00       	push   $0x8c
  801708:	68 25 39 80 00       	push   $0x803925
  80170d:	e8 30 ee ff ff       	call   800542 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801712:	89 f8                	mov    %edi,%eax
  801714:	e8 45 fd ff ff       	call   80145e <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801719:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80171f:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801725:	74 26                	je     80174d <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801727:	89 d8                	mov    %ebx,%eax
  801729:	c1 e8 16             	shr    $0x16,%eax
  80172c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801733:	a8 01                	test   $0x1,%al
  801735:	74 e2                	je     801719 <fork+0x66>
  801737:	89 da                	mov    %ebx,%edx
  801739:	c1 ea 0c             	shr    $0xc,%edx
  80173c:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801743:	83 e0 05             	and    $0x5,%eax
  801746:	83 f8 05             	cmp    $0x5,%eax
  801749:	75 ce                	jne    801719 <fork+0x66>
  80174b:	eb c5                	jmp    801712 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80174d:	83 ec 04             	sub    $0x4,%esp
  801750:	6a 07                	push   $0x7
  801752:	68 00 f0 bf ee       	push   $0xeebff000
  801757:	56                   	push   %esi
  801758:	e8 2c fa ff ff       	call   801189 <sys_page_alloc>
	if(ret < 0)
  80175d:	83 c4 10             	add    $0x10,%esp
  801760:	85 c0                	test   %eax,%eax
  801762:	78 31                	js     801795 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801764:	83 ec 08             	sub    $0x8,%esp
  801767:	68 00 30 80 00       	push   $0x803000
  80176c:	56                   	push   %esi
  80176d:	e8 62 fb ff ff       	call   8012d4 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801772:	83 c4 10             	add    $0x10,%esp
  801775:	85 c0                	test   %eax,%eax
  801777:	78 33                	js     8017ac <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801779:	83 ec 08             	sub    $0x8,%esp
  80177c:	6a 02                	push   $0x2
  80177e:	56                   	push   %esi
  80177f:	e8 cc fa ff ff       	call   801250 <sys_env_set_status>
	if(ret < 0)
  801784:	83 c4 10             	add    $0x10,%esp
  801787:	85 c0                	test   %eax,%eax
  801789:	78 38                	js     8017c3 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  80178b:	89 f0                	mov    %esi,%eax
  80178d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801790:	5b                   	pop    %ebx
  801791:	5e                   	pop    %esi
  801792:	5f                   	pop    %edi
  801793:	5d                   	pop    %ebp
  801794:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801795:	83 ec 04             	sub    $0x4,%esp
  801798:	68 44 39 80 00       	push   $0x803944
  80179d:	68 98 00 00 00       	push   $0x98
  8017a2:	68 25 39 80 00       	push   $0x803925
  8017a7:	e8 96 ed ff ff       	call   800542 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8017ac:	83 ec 04             	sub    $0x4,%esp
  8017af:	68 b8 39 80 00       	push   $0x8039b8
  8017b4:	68 9b 00 00 00       	push   $0x9b
  8017b9:	68 25 39 80 00       	push   $0x803925
  8017be:	e8 7f ed ff ff       	call   800542 <_panic>
		panic("panic in sys_env_set_status()\n");
  8017c3:	83 ec 04             	sub    $0x4,%esp
  8017c6:	68 e0 39 80 00       	push   $0x8039e0
  8017cb:	68 9e 00 00 00       	push   $0x9e
  8017d0:	68 25 39 80 00       	push   $0x803925
  8017d5:	e8 68 ed ff ff       	call   800542 <_panic>

008017da <sfork>:

// Challenge!
int
sfork(void)
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
  8017dd:	57                   	push   %edi
  8017de:	56                   	push   %esi
  8017df:	53                   	push   %ebx
  8017e0:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8017e3:	68 b4 15 80 00       	push   $0x8015b4
  8017e8:	e8 a4 17 00 00       	call   802f91 <set_pgfault_handler>
  8017ed:	b8 07 00 00 00       	mov    $0x7,%eax
  8017f2:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8017f4:	83 c4 10             	add    $0x10,%esp
  8017f7:	85 c0                	test   %eax,%eax
  8017f9:	78 27                	js     801822 <sfork+0x48>
  8017fb:	89 c7                	mov    %eax,%edi
  8017fd:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8017ff:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801804:	75 55                	jne    80185b <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801806:	e8 40 f9 ff ff       	call   80114b <sys_getenvid>
  80180b:	25 ff 03 00 00       	and    $0x3ff,%eax
  801810:	c1 e0 07             	shl    $0x7,%eax
  801813:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801818:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  80181d:	e9 d4 00 00 00       	jmp    8018f6 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  801822:	83 ec 04             	sub    $0x4,%esp
  801825:	68 94 39 80 00       	push   $0x803994
  80182a:	68 af 00 00 00       	push   $0xaf
  80182f:	68 25 39 80 00       	push   $0x803925
  801834:	e8 09 ed ff ff       	call   800542 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801839:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80183e:	89 f0                	mov    %esi,%eax
  801840:	e8 19 fc ff ff       	call   80145e <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801845:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80184b:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801851:	77 65                	ja     8018b8 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801853:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801859:	74 de                	je     801839 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  80185b:	89 d8                	mov    %ebx,%eax
  80185d:	c1 e8 16             	shr    $0x16,%eax
  801860:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801867:	a8 01                	test   $0x1,%al
  801869:	74 da                	je     801845 <sfork+0x6b>
  80186b:	89 da                	mov    %ebx,%edx
  80186d:	c1 ea 0c             	shr    $0xc,%edx
  801870:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801877:	83 e0 05             	and    $0x5,%eax
  80187a:	83 f8 05             	cmp    $0x5,%eax
  80187d:	75 c6                	jne    801845 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  80187f:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801886:	c1 e2 0c             	shl    $0xc,%edx
  801889:	83 ec 0c             	sub    $0xc,%esp
  80188c:	83 e0 07             	and    $0x7,%eax
  80188f:	50                   	push   %eax
  801890:	52                   	push   %edx
  801891:	56                   	push   %esi
  801892:	52                   	push   %edx
  801893:	6a 00                	push   $0x0
  801895:	e8 32 f9 ff ff       	call   8011cc <sys_page_map>
  80189a:	83 c4 20             	add    $0x20,%esp
  80189d:	85 c0                	test   %eax,%eax
  80189f:	74 a4                	je     801845 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  8018a1:	83 ec 04             	sub    $0x4,%esp
  8018a4:	68 0f 39 80 00       	push   $0x80390f
  8018a9:	68 ba 00 00 00       	push   $0xba
  8018ae:	68 25 39 80 00       	push   $0x803925
  8018b3:	e8 8a ec ff ff       	call   800542 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8018b8:	83 ec 04             	sub    $0x4,%esp
  8018bb:	6a 07                	push   $0x7
  8018bd:	68 00 f0 bf ee       	push   $0xeebff000
  8018c2:	57                   	push   %edi
  8018c3:	e8 c1 f8 ff ff       	call   801189 <sys_page_alloc>
	if(ret < 0)
  8018c8:	83 c4 10             	add    $0x10,%esp
  8018cb:	85 c0                	test   %eax,%eax
  8018cd:	78 31                	js     801900 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8018cf:	83 ec 08             	sub    $0x8,%esp
  8018d2:	68 00 30 80 00       	push   $0x803000
  8018d7:	57                   	push   %edi
  8018d8:	e8 f7 f9 ff ff       	call   8012d4 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8018dd:	83 c4 10             	add    $0x10,%esp
  8018e0:	85 c0                	test   %eax,%eax
  8018e2:	78 33                	js     801917 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8018e4:	83 ec 08             	sub    $0x8,%esp
  8018e7:	6a 02                	push   $0x2
  8018e9:	57                   	push   %edi
  8018ea:	e8 61 f9 ff ff       	call   801250 <sys_env_set_status>
	if(ret < 0)
  8018ef:	83 c4 10             	add    $0x10,%esp
  8018f2:	85 c0                	test   %eax,%eax
  8018f4:	78 38                	js     80192e <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8018f6:	89 f8                	mov    %edi,%eax
  8018f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018fb:	5b                   	pop    %ebx
  8018fc:	5e                   	pop    %esi
  8018fd:	5f                   	pop    %edi
  8018fe:	5d                   	pop    %ebp
  8018ff:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801900:	83 ec 04             	sub    $0x4,%esp
  801903:	68 44 39 80 00       	push   $0x803944
  801908:	68 c0 00 00 00       	push   $0xc0
  80190d:	68 25 39 80 00       	push   $0x803925
  801912:	e8 2b ec ff ff       	call   800542 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801917:	83 ec 04             	sub    $0x4,%esp
  80191a:	68 b8 39 80 00       	push   $0x8039b8
  80191f:	68 c3 00 00 00       	push   $0xc3
  801924:	68 25 39 80 00       	push   $0x803925
  801929:	e8 14 ec ff ff       	call   800542 <_panic>
		panic("panic in sys_env_set_status()\n");
  80192e:	83 ec 04             	sub    $0x4,%esp
  801931:	68 e0 39 80 00       	push   $0x8039e0
  801936:	68 c6 00 00 00       	push   $0xc6
  80193b:	68 25 39 80 00       	push   $0x803925
  801940:	e8 fd eb ff ff       	call   800542 <_panic>

00801945 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801948:	8b 45 08             	mov    0x8(%ebp),%eax
  80194b:	05 00 00 00 30       	add    $0x30000000,%eax
  801950:	c1 e8 0c             	shr    $0xc,%eax
}
  801953:	5d                   	pop    %ebp
  801954:	c3                   	ret    

00801955 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801958:	8b 45 08             	mov    0x8(%ebp),%eax
  80195b:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801960:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801965:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80196a:	5d                   	pop    %ebp
  80196b:	c3                   	ret    

0080196c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
  80196f:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801974:	89 c2                	mov    %eax,%edx
  801976:	c1 ea 16             	shr    $0x16,%edx
  801979:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801980:	f6 c2 01             	test   $0x1,%dl
  801983:	74 2d                	je     8019b2 <fd_alloc+0x46>
  801985:	89 c2                	mov    %eax,%edx
  801987:	c1 ea 0c             	shr    $0xc,%edx
  80198a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801991:	f6 c2 01             	test   $0x1,%dl
  801994:	74 1c                	je     8019b2 <fd_alloc+0x46>
  801996:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80199b:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8019a0:	75 d2                	jne    801974 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8019a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8019ab:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8019b0:	eb 0a                	jmp    8019bc <fd_alloc+0x50>
			*fd_store = fd;
  8019b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019b5:	89 01                	mov    %eax,(%ecx)
			return 0;
  8019b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019bc:	5d                   	pop    %ebp
  8019bd:	c3                   	ret    

008019be <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
  8019c1:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8019c4:	83 f8 1f             	cmp    $0x1f,%eax
  8019c7:	77 30                	ja     8019f9 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8019c9:	c1 e0 0c             	shl    $0xc,%eax
  8019cc:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8019d1:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8019d7:	f6 c2 01             	test   $0x1,%dl
  8019da:	74 24                	je     801a00 <fd_lookup+0x42>
  8019dc:	89 c2                	mov    %eax,%edx
  8019de:	c1 ea 0c             	shr    $0xc,%edx
  8019e1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8019e8:	f6 c2 01             	test   $0x1,%dl
  8019eb:	74 1a                	je     801a07 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8019ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f0:	89 02                	mov    %eax,(%edx)
	return 0;
  8019f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019f7:	5d                   	pop    %ebp
  8019f8:	c3                   	ret    
		return -E_INVAL;
  8019f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019fe:	eb f7                	jmp    8019f7 <fd_lookup+0x39>
		return -E_INVAL;
  801a00:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a05:	eb f0                	jmp    8019f7 <fd_lookup+0x39>
  801a07:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a0c:	eb e9                	jmp    8019f7 <fd_lookup+0x39>

00801a0e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
  801a11:	83 ec 08             	sub    $0x8,%esp
  801a14:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801a17:	ba 00 00 00 00       	mov    $0x0,%edx
  801a1c:	b8 20 40 80 00       	mov    $0x804020,%eax
		if (devtab[i]->dev_id == dev_id) {
  801a21:	39 08                	cmp    %ecx,(%eax)
  801a23:	74 38                	je     801a5d <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801a25:	83 c2 01             	add    $0x1,%edx
  801a28:	8b 04 95 7c 3a 80 00 	mov    0x803a7c(,%edx,4),%eax
  801a2f:	85 c0                	test   %eax,%eax
  801a31:	75 ee                	jne    801a21 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801a33:	a1 08 50 80 00       	mov    0x805008,%eax
  801a38:	8b 40 48             	mov    0x48(%eax),%eax
  801a3b:	83 ec 04             	sub    $0x4,%esp
  801a3e:	51                   	push   %ecx
  801a3f:	50                   	push   %eax
  801a40:	68 00 3a 80 00       	push   $0x803a00
  801a45:	e8 ee eb ff ff       	call   800638 <cprintf>
	*dev = 0;
  801a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801a53:	83 c4 10             	add    $0x10,%esp
  801a56:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    
			*dev = devtab[i];
  801a5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a60:	89 01                	mov    %eax,(%ecx)
			return 0;
  801a62:	b8 00 00 00 00       	mov    $0x0,%eax
  801a67:	eb f2                	jmp    801a5b <dev_lookup+0x4d>

00801a69 <fd_close>:
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
  801a6c:	57                   	push   %edi
  801a6d:	56                   	push   %esi
  801a6e:	53                   	push   %ebx
  801a6f:	83 ec 24             	sub    $0x24,%esp
  801a72:	8b 75 08             	mov    0x8(%ebp),%esi
  801a75:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801a78:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801a7b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801a7c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801a82:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801a85:	50                   	push   %eax
  801a86:	e8 33 ff ff ff       	call   8019be <fd_lookup>
  801a8b:	89 c3                	mov    %eax,%ebx
  801a8d:	83 c4 10             	add    $0x10,%esp
  801a90:	85 c0                	test   %eax,%eax
  801a92:	78 05                	js     801a99 <fd_close+0x30>
	    || fd != fd2)
  801a94:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801a97:	74 16                	je     801aaf <fd_close+0x46>
		return (must_exist ? r : 0);
  801a99:	89 f8                	mov    %edi,%eax
  801a9b:	84 c0                	test   %al,%al
  801a9d:	b8 00 00 00 00       	mov    $0x0,%eax
  801aa2:	0f 44 d8             	cmove  %eax,%ebx
}
  801aa5:	89 d8                	mov    %ebx,%eax
  801aa7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801aaa:	5b                   	pop    %ebx
  801aab:	5e                   	pop    %esi
  801aac:	5f                   	pop    %edi
  801aad:	5d                   	pop    %ebp
  801aae:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801aaf:	83 ec 08             	sub    $0x8,%esp
  801ab2:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801ab5:	50                   	push   %eax
  801ab6:	ff 36                	pushl  (%esi)
  801ab8:	e8 51 ff ff ff       	call   801a0e <dev_lookup>
  801abd:	89 c3                	mov    %eax,%ebx
  801abf:	83 c4 10             	add    $0x10,%esp
  801ac2:	85 c0                	test   %eax,%eax
  801ac4:	78 1a                	js     801ae0 <fd_close+0x77>
		if (dev->dev_close)
  801ac6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ac9:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801acc:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801ad1:	85 c0                	test   %eax,%eax
  801ad3:	74 0b                	je     801ae0 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801ad5:	83 ec 0c             	sub    $0xc,%esp
  801ad8:	56                   	push   %esi
  801ad9:	ff d0                	call   *%eax
  801adb:	89 c3                	mov    %eax,%ebx
  801add:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801ae0:	83 ec 08             	sub    $0x8,%esp
  801ae3:	56                   	push   %esi
  801ae4:	6a 00                	push   $0x0
  801ae6:	e8 23 f7 ff ff       	call   80120e <sys_page_unmap>
	return r;
  801aeb:	83 c4 10             	add    $0x10,%esp
  801aee:	eb b5                	jmp    801aa5 <fd_close+0x3c>

00801af0 <close>:

int
close(int fdnum)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
  801af3:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801af6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801af9:	50                   	push   %eax
  801afa:	ff 75 08             	pushl  0x8(%ebp)
  801afd:	e8 bc fe ff ff       	call   8019be <fd_lookup>
  801b02:	83 c4 10             	add    $0x10,%esp
  801b05:	85 c0                	test   %eax,%eax
  801b07:	79 02                	jns    801b0b <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    
		return fd_close(fd, 1);
  801b0b:	83 ec 08             	sub    $0x8,%esp
  801b0e:	6a 01                	push   $0x1
  801b10:	ff 75 f4             	pushl  -0xc(%ebp)
  801b13:	e8 51 ff ff ff       	call   801a69 <fd_close>
  801b18:	83 c4 10             	add    $0x10,%esp
  801b1b:	eb ec                	jmp    801b09 <close+0x19>

00801b1d <close_all>:

void
close_all(void)
{
  801b1d:	55                   	push   %ebp
  801b1e:	89 e5                	mov    %esp,%ebp
  801b20:	53                   	push   %ebx
  801b21:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801b24:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801b29:	83 ec 0c             	sub    $0xc,%esp
  801b2c:	53                   	push   %ebx
  801b2d:	e8 be ff ff ff       	call   801af0 <close>
	for (i = 0; i < MAXFD; i++)
  801b32:	83 c3 01             	add    $0x1,%ebx
  801b35:	83 c4 10             	add    $0x10,%esp
  801b38:	83 fb 20             	cmp    $0x20,%ebx
  801b3b:	75 ec                	jne    801b29 <close_all+0xc>
}
  801b3d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
  801b45:	57                   	push   %edi
  801b46:	56                   	push   %esi
  801b47:	53                   	push   %ebx
  801b48:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801b4b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801b4e:	50                   	push   %eax
  801b4f:	ff 75 08             	pushl  0x8(%ebp)
  801b52:	e8 67 fe ff ff       	call   8019be <fd_lookup>
  801b57:	89 c3                	mov    %eax,%ebx
  801b59:	83 c4 10             	add    $0x10,%esp
  801b5c:	85 c0                	test   %eax,%eax
  801b5e:	0f 88 81 00 00 00    	js     801be5 <dup+0xa3>
		return r;
	close(newfdnum);
  801b64:	83 ec 0c             	sub    $0xc,%esp
  801b67:	ff 75 0c             	pushl  0xc(%ebp)
  801b6a:	e8 81 ff ff ff       	call   801af0 <close>

	newfd = INDEX2FD(newfdnum);
  801b6f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b72:	c1 e6 0c             	shl    $0xc,%esi
  801b75:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801b7b:	83 c4 04             	add    $0x4,%esp
  801b7e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b81:	e8 cf fd ff ff       	call   801955 <fd2data>
  801b86:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801b88:	89 34 24             	mov    %esi,(%esp)
  801b8b:	e8 c5 fd ff ff       	call   801955 <fd2data>
  801b90:	83 c4 10             	add    $0x10,%esp
  801b93:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801b95:	89 d8                	mov    %ebx,%eax
  801b97:	c1 e8 16             	shr    $0x16,%eax
  801b9a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801ba1:	a8 01                	test   $0x1,%al
  801ba3:	74 11                	je     801bb6 <dup+0x74>
  801ba5:	89 d8                	mov    %ebx,%eax
  801ba7:	c1 e8 0c             	shr    $0xc,%eax
  801baa:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801bb1:	f6 c2 01             	test   $0x1,%dl
  801bb4:	75 39                	jne    801bef <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801bb6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801bb9:	89 d0                	mov    %edx,%eax
  801bbb:	c1 e8 0c             	shr    $0xc,%eax
  801bbe:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801bc5:	83 ec 0c             	sub    $0xc,%esp
  801bc8:	25 07 0e 00 00       	and    $0xe07,%eax
  801bcd:	50                   	push   %eax
  801bce:	56                   	push   %esi
  801bcf:	6a 00                	push   $0x0
  801bd1:	52                   	push   %edx
  801bd2:	6a 00                	push   $0x0
  801bd4:	e8 f3 f5 ff ff       	call   8011cc <sys_page_map>
  801bd9:	89 c3                	mov    %eax,%ebx
  801bdb:	83 c4 20             	add    $0x20,%esp
  801bde:	85 c0                	test   %eax,%eax
  801be0:	78 31                	js     801c13 <dup+0xd1>
		goto err;

	return newfdnum;
  801be2:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801be5:	89 d8                	mov    %ebx,%eax
  801be7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bea:	5b                   	pop    %ebx
  801beb:	5e                   	pop    %esi
  801bec:	5f                   	pop    %edi
  801bed:	5d                   	pop    %ebp
  801bee:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801bef:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801bf6:	83 ec 0c             	sub    $0xc,%esp
  801bf9:	25 07 0e 00 00       	and    $0xe07,%eax
  801bfe:	50                   	push   %eax
  801bff:	57                   	push   %edi
  801c00:	6a 00                	push   $0x0
  801c02:	53                   	push   %ebx
  801c03:	6a 00                	push   $0x0
  801c05:	e8 c2 f5 ff ff       	call   8011cc <sys_page_map>
  801c0a:	89 c3                	mov    %eax,%ebx
  801c0c:	83 c4 20             	add    $0x20,%esp
  801c0f:	85 c0                	test   %eax,%eax
  801c11:	79 a3                	jns    801bb6 <dup+0x74>
	sys_page_unmap(0, newfd);
  801c13:	83 ec 08             	sub    $0x8,%esp
  801c16:	56                   	push   %esi
  801c17:	6a 00                	push   $0x0
  801c19:	e8 f0 f5 ff ff       	call   80120e <sys_page_unmap>
	sys_page_unmap(0, nva);
  801c1e:	83 c4 08             	add    $0x8,%esp
  801c21:	57                   	push   %edi
  801c22:	6a 00                	push   $0x0
  801c24:	e8 e5 f5 ff ff       	call   80120e <sys_page_unmap>
	return r;
  801c29:	83 c4 10             	add    $0x10,%esp
  801c2c:	eb b7                	jmp    801be5 <dup+0xa3>

00801c2e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
  801c31:	53                   	push   %ebx
  801c32:	83 ec 1c             	sub    $0x1c,%esp
  801c35:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c38:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c3b:	50                   	push   %eax
  801c3c:	53                   	push   %ebx
  801c3d:	e8 7c fd ff ff       	call   8019be <fd_lookup>
  801c42:	83 c4 10             	add    $0x10,%esp
  801c45:	85 c0                	test   %eax,%eax
  801c47:	78 3f                	js     801c88 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c49:	83 ec 08             	sub    $0x8,%esp
  801c4c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c4f:	50                   	push   %eax
  801c50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c53:	ff 30                	pushl  (%eax)
  801c55:	e8 b4 fd ff ff       	call   801a0e <dev_lookup>
  801c5a:	83 c4 10             	add    $0x10,%esp
  801c5d:	85 c0                	test   %eax,%eax
  801c5f:	78 27                	js     801c88 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801c61:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c64:	8b 42 08             	mov    0x8(%edx),%eax
  801c67:	83 e0 03             	and    $0x3,%eax
  801c6a:	83 f8 01             	cmp    $0x1,%eax
  801c6d:	74 1e                	je     801c8d <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c72:	8b 40 08             	mov    0x8(%eax),%eax
  801c75:	85 c0                	test   %eax,%eax
  801c77:	74 35                	je     801cae <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801c79:	83 ec 04             	sub    $0x4,%esp
  801c7c:	ff 75 10             	pushl  0x10(%ebp)
  801c7f:	ff 75 0c             	pushl  0xc(%ebp)
  801c82:	52                   	push   %edx
  801c83:	ff d0                	call   *%eax
  801c85:	83 c4 10             	add    $0x10,%esp
}
  801c88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c8b:	c9                   	leave  
  801c8c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801c8d:	a1 08 50 80 00       	mov    0x805008,%eax
  801c92:	8b 40 48             	mov    0x48(%eax),%eax
  801c95:	83 ec 04             	sub    $0x4,%esp
  801c98:	53                   	push   %ebx
  801c99:	50                   	push   %eax
  801c9a:	68 41 3a 80 00       	push   $0x803a41
  801c9f:	e8 94 e9 ff ff       	call   800638 <cprintf>
		return -E_INVAL;
  801ca4:	83 c4 10             	add    $0x10,%esp
  801ca7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801cac:	eb da                	jmp    801c88 <read+0x5a>
		return -E_NOT_SUPP;
  801cae:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801cb3:	eb d3                	jmp    801c88 <read+0x5a>

00801cb5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
  801cb8:	57                   	push   %edi
  801cb9:	56                   	push   %esi
  801cba:	53                   	push   %ebx
  801cbb:	83 ec 0c             	sub    $0xc,%esp
  801cbe:	8b 7d 08             	mov    0x8(%ebp),%edi
  801cc1:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801cc4:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cc9:	39 f3                	cmp    %esi,%ebx
  801ccb:	73 23                	jae    801cf0 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801ccd:	83 ec 04             	sub    $0x4,%esp
  801cd0:	89 f0                	mov    %esi,%eax
  801cd2:	29 d8                	sub    %ebx,%eax
  801cd4:	50                   	push   %eax
  801cd5:	89 d8                	mov    %ebx,%eax
  801cd7:	03 45 0c             	add    0xc(%ebp),%eax
  801cda:	50                   	push   %eax
  801cdb:	57                   	push   %edi
  801cdc:	e8 4d ff ff ff       	call   801c2e <read>
		if (m < 0)
  801ce1:	83 c4 10             	add    $0x10,%esp
  801ce4:	85 c0                	test   %eax,%eax
  801ce6:	78 06                	js     801cee <readn+0x39>
			return m;
		if (m == 0)
  801ce8:	74 06                	je     801cf0 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801cea:	01 c3                	add    %eax,%ebx
  801cec:	eb db                	jmp    801cc9 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801cee:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801cf0:	89 d8                	mov    %ebx,%eax
  801cf2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cf5:	5b                   	pop    %ebx
  801cf6:	5e                   	pop    %esi
  801cf7:	5f                   	pop    %edi
  801cf8:	5d                   	pop    %ebp
  801cf9:	c3                   	ret    

00801cfa <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801cfa:	55                   	push   %ebp
  801cfb:	89 e5                	mov    %esp,%ebp
  801cfd:	53                   	push   %ebx
  801cfe:	83 ec 1c             	sub    $0x1c,%esp
  801d01:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d04:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d07:	50                   	push   %eax
  801d08:	53                   	push   %ebx
  801d09:	e8 b0 fc ff ff       	call   8019be <fd_lookup>
  801d0e:	83 c4 10             	add    $0x10,%esp
  801d11:	85 c0                	test   %eax,%eax
  801d13:	78 3a                	js     801d4f <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d15:	83 ec 08             	sub    $0x8,%esp
  801d18:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d1b:	50                   	push   %eax
  801d1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d1f:	ff 30                	pushl  (%eax)
  801d21:	e8 e8 fc ff ff       	call   801a0e <dev_lookup>
  801d26:	83 c4 10             	add    $0x10,%esp
  801d29:	85 c0                	test   %eax,%eax
  801d2b:	78 22                	js     801d4f <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d30:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801d34:	74 1e                	je     801d54 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801d36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d39:	8b 52 0c             	mov    0xc(%edx),%edx
  801d3c:	85 d2                	test   %edx,%edx
  801d3e:	74 35                	je     801d75 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801d40:	83 ec 04             	sub    $0x4,%esp
  801d43:	ff 75 10             	pushl  0x10(%ebp)
  801d46:	ff 75 0c             	pushl  0xc(%ebp)
  801d49:	50                   	push   %eax
  801d4a:	ff d2                	call   *%edx
  801d4c:	83 c4 10             	add    $0x10,%esp
}
  801d4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801d54:	a1 08 50 80 00       	mov    0x805008,%eax
  801d59:	8b 40 48             	mov    0x48(%eax),%eax
  801d5c:	83 ec 04             	sub    $0x4,%esp
  801d5f:	53                   	push   %ebx
  801d60:	50                   	push   %eax
  801d61:	68 5d 3a 80 00       	push   $0x803a5d
  801d66:	e8 cd e8 ff ff       	call   800638 <cprintf>
		return -E_INVAL;
  801d6b:	83 c4 10             	add    $0x10,%esp
  801d6e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d73:	eb da                	jmp    801d4f <write+0x55>
		return -E_NOT_SUPP;
  801d75:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d7a:	eb d3                	jmp    801d4f <write+0x55>

00801d7c <seek>:

int
seek(int fdnum, off_t offset)
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
  801d7f:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d82:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d85:	50                   	push   %eax
  801d86:	ff 75 08             	pushl  0x8(%ebp)
  801d89:	e8 30 fc ff ff       	call   8019be <fd_lookup>
  801d8e:	83 c4 10             	add    $0x10,%esp
  801d91:	85 c0                	test   %eax,%eax
  801d93:	78 0e                	js     801da3 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801d95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801d9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
  801da8:	53                   	push   %ebx
  801da9:	83 ec 1c             	sub    $0x1c,%esp
  801dac:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801daf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801db2:	50                   	push   %eax
  801db3:	53                   	push   %ebx
  801db4:	e8 05 fc ff ff       	call   8019be <fd_lookup>
  801db9:	83 c4 10             	add    $0x10,%esp
  801dbc:	85 c0                	test   %eax,%eax
  801dbe:	78 37                	js     801df7 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801dc0:	83 ec 08             	sub    $0x8,%esp
  801dc3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dc6:	50                   	push   %eax
  801dc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dca:	ff 30                	pushl  (%eax)
  801dcc:	e8 3d fc ff ff       	call   801a0e <dev_lookup>
  801dd1:	83 c4 10             	add    $0x10,%esp
  801dd4:	85 c0                	test   %eax,%eax
  801dd6:	78 1f                	js     801df7 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801dd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ddb:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801ddf:	74 1b                	je     801dfc <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801de1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801de4:	8b 52 18             	mov    0x18(%edx),%edx
  801de7:	85 d2                	test   %edx,%edx
  801de9:	74 32                	je     801e1d <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801deb:	83 ec 08             	sub    $0x8,%esp
  801dee:	ff 75 0c             	pushl  0xc(%ebp)
  801df1:	50                   	push   %eax
  801df2:	ff d2                	call   *%edx
  801df4:	83 c4 10             	add    $0x10,%esp
}
  801df7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dfa:	c9                   	leave  
  801dfb:	c3                   	ret    
			thisenv->env_id, fdnum);
  801dfc:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801e01:	8b 40 48             	mov    0x48(%eax),%eax
  801e04:	83 ec 04             	sub    $0x4,%esp
  801e07:	53                   	push   %ebx
  801e08:	50                   	push   %eax
  801e09:	68 20 3a 80 00       	push   $0x803a20
  801e0e:	e8 25 e8 ff ff       	call   800638 <cprintf>
		return -E_INVAL;
  801e13:	83 c4 10             	add    $0x10,%esp
  801e16:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e1b:	eb da                	jmp    801df7 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801e1d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e22:	eb d3                	jmp    801df7 <ftruncate+0x52>

00801e24 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
  801e27:	53                   	push   %ebx
  801e28:	83 ec 1c             	sub    $0x1c,%esp
  801e2b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801e2e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e31:	50                   	push   %eax
  801e32:	ff 75 08             	pushl  0x8(%ebp)
  801e35:	e8 84 fb ff ff       	call   8019be <fd_lookup>
  801e3a:	83 c4 10             	add    $0x10,%esp
  801e3d:	85 c0                	test   %eax,%eax
  801e3f:	78 4b                	js     801e8c <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801e41:	83 ec 08             	sub    $0x8,%esp
  801e44:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e47:	50                   	push   %eax
  801e48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e4b:	ff 30                	pushl  (%eax)
  801e4d:	e8 bc fb ff ff       	call   801a0e <dev_lookup>
  801e52:	83 c4 10             	add    $0x10,%esp
  801e55:	85 c0                	test   %eax,%eax
  801e57:	78 33                	js     801e8c <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801e60:	74 2f                	je     801e91 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801e62:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801e65:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801e6c:	00 00 00 
	stat->st_isdir = 0;
  801e6f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e76:	00 00 00 
	stat->st_dev = dev;
  801e79:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801e7f:	83 ec 08             	sub    $0x8,%esp
  801e82:	53                   	push   %ebx
  801e83:	ff 75 f0             	pushl  -0x10(%ebp)
  801e86:	ff 50 14             	call   *0x14(%eax)
  801e89:	83 c4 10             	add    $0x10,%esp
}
  801e8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e8f:	c9                   	leave  
  801e90:	c3                   	ret    
		return -E_NOT_SUPP;
  801e91:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e96:	eb f4                	jmp    801e8c <fstat+0x68>

00801e98 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
  801e9b:	56                   	push   %esi
  801e9c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801e9d:	83 ec 08             	sub    $0x8,%esp
  801ea0:	6a 00                	push   $0x0
  801ea2:	ff 75 08             	pushl  0x8(%ebp)
  801ea5:	e8 22 02 00 00       	call   8020cc <open>
  801eaa:	89 c3                	mov    %eax,%ebx
  801eac:	83 c4 10             	add    $0x10,%esp
  801eaf:	85 c0                	test   %eax,%eax
  801eb1:	78 1b                	js     801ece <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801eb3:	83 ec 08             	sub    $0x8,%esp
  801eb6:	ff 75 0c             	pushl  0xc(%ebp)
  801eb9:	50                   	push   %eax
  801eba:	e8 65 ff ff ff       	call   801e24 <fstat>
  801ebf:	89 c6                	mov    %eax,%esi
	close(fd);
  801ec1:	89 1c 24             	mov    %ebx,(%esp)
  801ec4:	e8 27 fc ff ff       	call   801af0 <close>
	return r;
  801ec9:	83 c4 10             	add    $0x10,%esp
  801ecc:	89 f3                	mov    %esi,%ebx
}
  801ece:	89 d8                	mov    %ebx,%eax
  801ed0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ed3:	5b                   	pop    %ebx
  801ed4:	5e                   	pop    %esi
  801ed5:	5d                   	pop    %ebp
  801ed6:	c3                   	ret    

00801ed7 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
  801eda:	56                   	push   %esi
  801edb:	53                   	push   %ebx
  801edc:	89 c6                	mov    %eax,%esi
  801ede:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801ee0:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801ee7:	74 27                	je     801f10 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ee9:	6a 07                	push   $0x7
  801eeb:	68 00 60 80 00       	push   $0x806000
  801ef0:	56                   	push   %esi
  801ef1:	ff 35 00 50 80 00    	pushl  0x805000
  801ef7:	e8 93 11 00 00       	call   80308f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801efc:	83 c4 0c             	add    $0xc,%esp
  801eff:	6a 00                	push   $0x0
  801f01:	53                   	push   %ebx
  801f02:	6a 00                	push   $0x0
  801f04:	e8 1d 11 00 00       	call   803026 <ipc_recv>
}
  801f09:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f0c:	5b                   	pop    %ebx
  801f0d:	5e                   	pop    %esi
  801f0e:	5d                   	pop    %ebp
  801f0f:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801f10:	83 ec 0c             	sub    $0xc,%esp
  801f13:	6a 01                	push   $0x1
  801f15:	e8 cd 11 00 00       	call   8030e7 <ipc_find_env>
  801f1a:	a3 00 50 80 00       	mov    %eax,0x805000
  801f1f:	83 c4 10             	add    $0x10,%esp
  801f22:	eb c5                	jmp    801ee9 <fsipc+0x12>

00801f24 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
  801f27:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2d:	8b 40 0c             	mov    0xc(%eax),%eax
  801f30:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801f35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f38:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801f3d:	ba 00 00 00 00       	mov    $0x0,%edx
  801f42:	b8 02 00 00 00       	mov    $0x2,%eax
  801f47:	e8 8b ff ff ff       	call   801ed7 <fsipc>
}
  801f4c:	c9                   	leave  
  801f4d:	c3                   	ret    

00801f4e <devfile_flush>:
{
  801f4e:	55                   	push   %ebp
  801f4f:	89 e5                	mov    %esp,%ebp
  801f51:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801f54:	8b 45 08             	mov    0x8(%ebp),%eax
  801f57:	8b 40 0c             	mov    0xc(%eax),%eax
  801f5a:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801f5f:	ba 00 00 00 00       	mov    $0x0,%edx
  801f64:	b8 06 00 00 00       	mov    $0x6,%eax
  801f69:	e8 69 ff ff ff       	call   801ed7 <fsipc>
}
  801f6e:	c9                   	leave  
  801f6f:	c3                   	ret    

00801f70 <devfile_stat>:
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
  801f73:	53                   	push   %ebx
  801f74:	83 ec 04             	sub    $0x4,%esp
  801f77:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7d:	8b 40 0c             	mov    0xc(%eax),%eax
  801f80:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801f85:	ba 00 00 00 00       	mov    $0x0,%edx
  801f8a:	b8 05 00 00 00       	mov    $0x5,%eax
  801f8f:	e8 43 ff ff ff       	call   801ed7 <fsipc>
  801f94:	85 c0                	test   %eax,%eax
  801f96:	78 2c                	js     801fc4 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801f98:	83 ec 08             	sub    $0x8,%esp
  801f9b:	68 00 60 80 00       	push   $0x806000
  801fa0:	53                   	push   %ebx
  801fa1:	e8 f1 ed ff ff       	call   800d97 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801fa6:	a1 80 60 80 00       	mov    0x806080,%eax
  801fab:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801fb1:	a1 84 60 80 00       	mov    0x806084,%eax
  801fb6:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801fbc:	83 c4 10             	add    $0x10,%esp
  801fbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    

00801fc9 <devfile_write>:
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
  801fcc:	53                   	push   %ebx
  801fcd:	83 ec 08             	sub    $0x8,%esp
  801fd0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd6:	8b 40 0c             	mov    0xc(%eax),%eax
  801fd9:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801fde:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801fe4:	53                   	push   %ebx
  801fe5:	ff 75 0c             	pushl  0xc(%ebp)
  801fe8:	68 08 60 80 00       	push   $0x806008
  801fed:	e8 95 ef ff ff       	call   800f87 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801ff2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ff7:	b8 04 00 00 00       	mov    $0x4,%eax
  801ffc:	e8 d6 fe ff ff       	call   801ed7 <fsipc>
  802001:	83 c4 10             	add    $0x10,%esp
  802004:	85 c0                	test   %eax,%eax
  802006:	78 0b                	js     802013 <devfile_write+0x4a>
	assert(r <= n);
  802008:	39 d8                	cmp    %ebx,%eax
  80200a:	77 0c                	ja     802018 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80200c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802011:	7f 1e                	jg     802031 <devfile_write+0x68>
}
  802013:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802016:	c9                   	leave  
  802017:	c3                   	ret    
	assert(r <= n);
  802018:	68 90 3a 80 00       	push   $0x803a90
  80201d:	68 97 3a 80 00       	push   $0x803a97
  802022:	68 98 00 00 00       	push   $0x98
  802027:	68 ac 3a 80 00       	push   $0x803aac
  80202c:	e8 11 e5 ff ff       	call   800542 <_panic>
	assert(r <= PGSIZE);
  802031:	68 b7 3a 80 00       	push   $0x803ab7
  802036:	68 97 3a 80 00       	push   $0x803a97
  80203b:	68 99 00 00 00       	push   $0x99
  802040:	68 ac 3a 80 00       	push   $0x803aac
  802045:	e8 f8 e4 ff ff       	call   800542 <_panic>

0080204a <devfile_read>:
{
  80204a:	55                   	push   %ebp
  80204b:	89 e5                	mov    %esp,%ebp
  80204d:	56                   	push   %esi
  80204e:	53                   	push   %ebx
  80204f:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802052:	8b 45 08             	mov    0x8(%ebp),%eax
  802055:	8b 40 0c             	mov    0xc(%eax),%eax
  802058:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  80205d:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802063:	ba 00 00 00 00       	mov    $0x0,%edx
  802068:	b8 03 00 00 00       	mov    $0x3,%eax
  80206d:	e8 65 fe ff ff       	call   801ed7 <fsipc>
  802072:	89 c3                	mov    %eax,%ebx
  802074:	85 c0                	test   %eax,%eax
  802076:	78 1f                	js     802097 <devfile_read+0x4d>
	assert(r <= n);
  802078:	39 f0                	cmp    %esi,%eax
  80207a:	77 24                	ja     8020a0 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80207c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802081:	7f 33                	jg     8020b6 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802083:	83 ec 04             	sub    $0x4,%esp
  802086:	50                   	push   %eax
  802087:	68 00 60 80 00       	push   $0x806000
  80208c:	ff 75 0c             	pushl  0xc(%ebp)
  80208f:	e8 91 ee ff ff       	call   800f25 <memmove>
	return r;
  802094:	83 c4 10             	add    $0x10,%esp
}
  802097:	89 d8                	mov    %ebx,%eax
  802099:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80209c:	5b                   	pop    %ebx
  80209d:	5e                   	pop    %esi
  80209e:	5d                   	pop    %ebp
  80209f:	c3                   	ret    
	assert(r <= n);
  8020a0:	68 90 3a 80 00       	push   $0x803a90
  8020a5:	68 97 3a 80 00       	push   $0x803a97
  8020aa:	6a 7c                	push   $0x7c
  8020ac:	68 ac 3a 80 00       	push   $0x803aac
  8020b1:	e8 8c e4 ff ff       	call   800542 <_panic>
	assert(r <= PGSIZE);
  8020b6:	68 b7 3a 80 00       	push   $0x803ab7
  8020bb:	68 97 3a 80 00       	push   $0x803a97
  8020c0:	6a 7d                	push   $0x7d
  8020c2:	68 ac 3a 80 00       	push   $0x803aac
  8020c7:	e8 76 e4 ff ff       	call   800542 <_panic>

008020cc <open>:
{
  8020cc:	55                   	push   %ebp
  8020cd:	89 e5                	mov    %esp,%ebp
  8020cf:	56                   	push   %esi
  8020d0:	53                   	push   %ebx
  8020d1:	83 ec 1c             	sub    $0x1c,%esp
  8020d4:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8020d7:	56                   	push   %esi
  8020d8:	e8 81 ec ff ff       	call   800d5e <strlen>
  8020dd:	83 c4 10             	add    $0x10,%esp
  8020e0:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8020e5:	7f 6c                	jg     802153 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8020e7:	83 ec 0c             	sub    $0xc,%esp
  8020ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020ed:	50                   	push   %eax
  8020ee:	e8 79 f8 ff ff       	call   80196c <fd_alloc>
  8020f3:	89 c3                	mov    %eax,%ebx
  8020f5:	83 c4 10             	add    $0x10,%esp
  8020f8:	85 c0                	test   %eax,%eax
  8020fa:	78 3c                	js     802138 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8020fc:	83 ec 08             	sub    $0x8,%esp
  8020ff:	56                   	push   %esi
  802100:	68 00 60 80 00       	push   $0x806000
  802105:	e8 8d ec ff ff       	call   800d97 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80210a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80210d:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802112:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802115:	b8 01 00 00 00       	mov    $0x1,%eax
  80211a:	e8 b8 fd ff ff       	call   801ed7 <fsipc>
  80211f:	89 c3                	mov    %eax,%ebx
  802121:	83 c4 10             	add    $0x10,%esp
  802124:	85 c0                	test   %eax,%eax
  802126:	78 19                	js     802141 <open+0x75>
	return fd2num(fd);
  802128:	83 ec 0c             	sub    $0xc,%esp
  80212b:	ff 75 f4             	pushl  -0xc(%ebp)
  80212e:	e8 12 f8 ff ff       	call   801945 <fd2num>
  802133:	89 c3                	mov    %eax,%ebx
  802135:	83 c4 10             	add    $0x10,%esp
}
  802138:	89 d8                	mov    %ebx,%eax
  80213a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80213d:	5b                   	pop    %ebx
  80213e:	5e                   	pop    %esi
  80213f:	5d                   	pop    %ebp
  802140:	c3                   	ret    
		fd_close(fd, 0);
  802141:	83 ec 08             	sub    $0x8,%esp
  802144:	6a 00                	push   $0x0
  802146:	ff 75 f4             	pushl  -0xc(%ebp)
  802149:	e8 1b f9 ff ff       	call   801a69 <fd_close>
		return r;
  80214e:	83 c4 10             	add    $0x10,%esp
  802151:	eb e5                	jmp    802138 <open+0x6c>
		return -E_BAD_PATH;
  802153:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  802158:	eb de                	jmp    802138 <open+0x6c>

0080215a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
  80215d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802160:	ba 00 00 00 00       	mov    $0x0,%edx
  802165:	b8 08 00 00 00       	mov    $0x8,%eax
  80216a:	e8 68 fd ff ff       	call   801ed7 <fsipc>
}
  80216f:	c9                   	leave  
  802170:	c3                   	ret    

00802171 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802171:	55                   	push   %ebp
  802172:	89 e5                	mov    %esp,%ebp
  802174:	57                   	push   %edi
  802175:	56                   	push   %esi
  802176:	53                   	push   %ebx
  802177:	81 ec 94 02 00 00    	sub    $0x294,%esp
	cprintf("in %s\n", __FUNCTION__);
  80217d:	68 9c 3b 80 00       	push   $0x803b9c
  802182:	68 2a 35 80 00       	push   $0x80352a
  802187:	e8 ac e4 ff ff       	call   800638 <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  80218c:	83 c4 08             	add    $0x8,%esp
  80218f:	6a 00                	push   $0x0
  802191:	ff 75 08             	pushl  0x8(%ebp)
  802194:	e8 33 ff ff ff       	call   8020cc <open>
  802199:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  80219f:	83 c4 10             	add    $0x10,%esp
  8021a2:	85 c0                	test   %eax,%eax
  8021a4:	0f 88 0a 05 00 00    	js     8026b4 <spawn+0x543>
  8021aa:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8021ac:	83 ec 04             	sub    $0x4,%esp
  8021af:	68 00 02 00 00       	push   $0x200
  8021b4:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8021ba:	50                   	push   %eax
  8021bb:	51                   	push   %ecx
  8021bc:	e8 f4 fa ff ff       	call   801cb5 <readn>
  8021c1:	83 c4 10             	add    $0x10,%esp
  8021c4:	3d 00 02 00 00       	cmp    $0x200,%eax
  8021c9:	75 74                	jne    80223f <spawn+0xce>
	    || elf->e_magic != ELF_MAGIC) {
  8021cb:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8021d2:	45 4c 46 
  8021d5:	75 68                	jne    80223f <spawn+0xce>
  8021d7:	b8 07 00 00 00       	mov    $0x7,%eax
  8021dc:	cd 30                	int    $0x30
  8021de:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  8021e4:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8021ea:	85 c0                	test   %eax,%eax
  8021ec:	0f 88 b6 04 00 00    	js     8026a8 <spawn+0x537>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8021f2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8021f7:	89 c6                	mov    %eax,%esi
  8021f9:	c1 e6 07             	shl    $0x7,%esi
  8021fc:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  802202:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  802208:	b9 11 00 00 00       	mov    $0x11,%ecx
  80220d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  80220f:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802215:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
	cprintf("in %s\n", __FUNCTION__);
  80221b:	83 ec 08             	sub    $0x8,%esp
  80221e:	68 90 3b 80 00       	push   $0x803b90
  802223:	68 2a 35 80 00       	push   $0x80352a
  802228:	e8 0b e4 ff ff       	call   800638 <cprintf>
  80222d:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802230:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  802235:	be 00 00 00 00       	mov    $0x0,%esi
  80223a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80223d:	eb 4b                	jmp    80228a <spawn+0x119>
		close(fd);
  80223f:	83 ec 0c             	sub    $0xc,%esp
  802242:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802248:	e8 a3 f8 ff ff       	call   801af0 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80224d:	83 c4 0c             	add    $0xc,%esp
  802250:	68 7f 45 4c 46       	push   $0x464c457f
  802255:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  80225b:	68 c3 3a 80 00       	push   $0x803ac3
  802260:	e8 d3 e3 ff ff       	call   800638 <cprintf>
		return -E_NOT_EXEC;
  802265:	83 c4 10             	add    $0x10,%esp
  802268:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  80226f:	ff ff ff 
  802272:	e9 3d 04 00 00       	jmp    8026b4 <spawn+0x543>
		string_size += strlen(argv[argc]) + 1;
  802277:	83 ec 0c             	sub    $0xc,%esp
  80227a:	50                   	push   %eax
  80227b:	e8 de ea ff ff       	call   800d5e <strlen>
  802280:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  802284:	83 c3 01             	add    $0x1,%ebx
  802287:	83 c4 10             	add    $0x10,%esp
  80228a:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  802291:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  802294:	85 c0                	test   %eax,%eax
  802296:	75 df                	jne    802277 <spawn+0x106>
  802298:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  80229e:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8022a4:	bf 00 10 40 00       	mov    $0x401000,%edi
  8022a9:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  8022ab:	89 fa                	mov    %edi,%edx
  8022ad:	83 e2 fc             	and    $0xfffffffc,%edx
  8022b0:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  8022b7:	29 c2                	sub    %eax,%edx
  8022b9:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8022bf:	8d 42 f8             	lea    -0x8(%edx),%eax
  8022c2:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8022c7:	0f 86 0a 04 00 00    	jbe    8026d7 <spawn+0x566>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8022cd:	83 ec 04             	sub    $0x4,%esp
  8022d0:	6a 07                	push   $0x7
  8022d2:	68 00 00 40 00       	push   $0x400000
  8022d7:	6a 00                	push   $0x0
  8022d9:	e8 ab ee ff ff       	call   801189 <sys_page_alloc>
  8022de:	83 c4 10             	add    $0x10,%esp
  8022e1:	85 c0                	test   %eax,%eax
  8022e3:	0f 88 f3 03 00 00    	js     8026dc <spawn+0x56b>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8022e9:	be 00 00 00 00       	mov    $0x0,%esi
  8022ee:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  8022f4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8022f7:	eb 30                	jmp    802329 <spawn+0x1b8>
		argv_store[i] = UTEMP2USTACK(string_store);
  8022f9:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  8022ff:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  802305:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  802308:	83 ec 08             	sub    $0x8,%esp
  80230b:	ff 34 b3             	pushl  (%ebx,%esi,4)
  80230e:	57                   	push   %edi
  80230f:	e8 83 ea ff ff       	call   800d97 <strcpy>
		string_store += strlen(argv[i]) + 1;
  802314:	83 c4 04             	add    $0x4,%esp
  802317:	ff 34 b3             	pushl  (%ebx,%esi,4)
  80231a:	e8 3f ea ff ff       	call   800d5e <strlen>
  80231f:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  802323:	83 c6 01             	add    $0x1,%esi
  802326:	83 c4 10             	add    $0x10,%esp
  802329:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  80232f:	7f c8                	jg     8022f9 <spawn+0x188>
	}
	argv_store[argc] = 0;
  802331:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802337:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  80233d:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  802344:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  80234a:	0f 85 86 00 00 00    	jne    8023d6 <spawn+0x265>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802350:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  802356:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  80235c:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  80235f:	89 d0                	mov    %edx,%eax
  802361:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  802367:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80236a:	2d 08 30 80 11       	sub    $0x11803008,%eax
  80236f:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802375:	83 ec 0c             	sub    $0xc,%esp
  802378:	6a 07                	push   $0x7
  80237a:	68 00 d0 bf ee       	push   $0xeebfd000
  80237f:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802385:	68 00 00 40 00       	push   $0x400000
  80238a:	6a 00                	push   $0x0
  80238c:	e8 3b ee ff ff       	call   8011cc <sys_page_map>
  802391:	89 c3                	mov    %eax,%ebx
  802393:	83 c4 20             	add    $0x20,%esp
  802396:	85 c0                	test   %eax,%eax
  802398:	0f 88 46 03 00 00    	js     8026e4 <spawn+0x573>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80239e:	83 ec 08             	sub    $0x8,%esp
  8023a1:	68 00 00 40 00       	push   $0x400000
  8023a6:	6a 00                	push   $0x0
  8023a8:	e8 61 ee ff ff       	call   80120e <sys_page_unmap>
  8023ad:	89 c3                	mov    %eax,%ebx
  8023af:	83 c4 10             	add    $0x10,%esp
  8023b2:	85 c0                	test   %eax,%eax
  8023b4:	0f 88 2a 03 00 00    	js     8026e4 <spawn+0x573>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8023ba:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  8023c0:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8023c7:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  8023ce:	00 00 00 
  8023d1:	e9 4f 01 00 00       	jmp    802525 <spawn+0x3b4>
	assert(string_store == (char*)UTEMP + PGSIZE);
  8023d6:	68 4c 3b 80 00       	push   $0x803b4c
  8023db:	68 97 3a 80 00       	push   $0x803a97
  8023e0:	68 f8 00 00 00       	push   $0xf8
  8023e5:	68 dd 3a 80 00       	push   $0x803add
  8023ea:	e8 53 e1 ff ff       	call   800542 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8023ef:	83 ec 04             	sub    $0x4,%esp
  8023f2:	6a 07                	push   $0x7
  8023f4:	68 00 00 40 00       	push   $0x400000
  8023f9:	6a 00                	push   $0x0
  8023fb:	e8 89 ed ff ff       	call   801189 <sys_page_alloc>
  802400:	83 c4 10             	add    $0x10,%esp
  802403:	85 c0                	test   %eax,%eax
  802405:	0f 88 b7 02 00 00    	js     8026c2 <spawn+0x551>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  80240b:	83 ec 08             	sub    $0x8,%esp
  80240e:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802414:	01 f0                	add    %esi,%eax
  802416:	50                   	push   %eax
  802417:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80241d:	e8 5a f9 ff ff       	call   801d7c <seek>
  802422:	83 c4 10             	add    $0x10,%esp
  802425:	85 c0                	test   %eax,%eax
  802427:	0f 88 9c 02 00 00    	js     8026c9 <spawn+0x558>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80242d:	83 ec 04             	sub    $0x4,%esp
  802430:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802436:	29 f0                	sub    %esi,%eax
  802438:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80243d:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802442:	0f 47 c1             	cmova  %ecx,%eax
  802445:	50                   	push   %eax
  802446:	68 00 00 40 00       	push   $0x400000
  80244b:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802451:	e8 5f f8 ff ff       	call   801cb5 <readn>
  802456:	83 c4 10             	add    $0x10,%esp
  802459:	85 c0                	test   %eax,%eax
  80245b:	0f 88 6f 02 00 00    	js     8026d0 <spawn+0x55f>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802461:	83 ec 0c             	sub    $0xc,%esp
  802464:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  80246a:	53                   	push   %ebx
  80246b:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802471:	68 00 00 40 00       	push   $0x400000
  802476:	6a 00                	push   $0x0
  802478:	e8 4f ed ff ff       	call   8011cc <sys_page_map>
  80247d:	83 c4 20             	add    $0x20,%esp
  802480:	85 c0                	test   %eax,%eax
  802482:	78 7c                	js     802500 <spawn+0x38f>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  802484:	83 ec 08             	sub    $0x8,%esp
  802487:	68 00 00 40 00       	push   $0x400000
  80248c:	6a 00                	push   $0x0
  80248e:	e8 7b ed ff ff       	call   80120e <sys_page_unmap>
  802493:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  802496:	81 c7 00 10 00 00    	add    $0x1000,%edi
  80249c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8024a2:	89 fe                	mov    %edi,%esi
  8024a4:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  8024aa:	76 69                	jbe    802515 <spawn+0x3a4>
		if (i >= filesz) {
  8024ac:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  8024b2:	0f 87 37 ff ff ff    	ja     8023ef <spawn+0x27e>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8024b8:	83 ec 04             	sub    $0x4,%esp
  8024bb:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8024c1:	53                   	push   %ebx
  8024c2:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  8024c8:	e8 bc ec ff ff       	call   801189 <sys_page_alloc>
  8024cd:	83 c4 10             	add    $0x10,%esp
  8024d0:	85 c0                	test   %eax,%eax
  8024d2:	79 c2                	jns    802496 <spawn+0x325>
  8024d4:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  8024d6:	83 ec 0c             	sub    $0xc,%esp
  8024d9:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8024df:	e8 26 ec ff ff       	call   80110a <sys_env_destroy>
	close(fd);
  8024e4:	83 c4 04             	add    $0x4,%esp
  8024e7:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8024ed:	e8 fe f5 ff ff       	call   801af0 <close>
	return r;
  8024f2:	83 c4 10             	add    $0x10,%esp
  8024f5:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  8024fb:	e9 b4 01 00 00       	jmp    8026b4 <spawn+0x543>
				panic("spawn: sys_page_map data: %e", r);
  802500:	50                   	push   %eax
  802501:	68 e9 3a 80 00       	push   $0x803ae9
  802506:	68 2b 01 00 00       	push   $0x12b
  80250b:	68 dd 3a 80 00       	push   $0x803add
  802510:	e8 2d e0 ff ff       	call   800542 <_panic>
  802515:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80251b:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  802522:	83 c6 20             	add    $0x20,%esi
  802525:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  80252c:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  802532:	7e 6d                	jle    8025a1 <spawn+0x430>
		if (ph->p_type != ELF_PROG_LOAD)
  802534:	83 3e 01             	cmpl   $0x1,(%esi)
  802537:	75 e2                	jne    80251b <spawn+0x3aa>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802539:	8b 46 18             	mov    0x18(%esi),%eax
  80253c:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  80253f:	83 f8 01             	cmp    $0x1,%eax
  802542:	19 c0                	sbb    %eax,%eax
  802544:	83 e0 fe             	and    $0xfffffffe,%eax
  802547:	83 c0 07             	add    $0x7,%eax
  80254a:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802550:	8b 4e 04             	mov    0x4(%esi),%ecx
  802553:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  802559:	8b 56 10             	mov    0x10(%esi),%edx
  80255c:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  802562:	8b 7e 14             	mov    0x14(%esi),%edi
  802565:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  80256b:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  80256e:	89 d8                	mov    %ebx,%eax
  802570:	25 ff 0f 00 00       	and    $0xfff,%eax
  802575:	74 1a                	je     802591 <spawn+0x420>
		va -= i;
  802577:	29 c3                	sub    %eax,%ebx
		memsz += i;
  802579:	01 c7                	add    %eax,%edi
  80257b:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  802581:	01 c2                	add    %eax,%edx
  802583:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  802589:	29 c1                	sub    %eax,%ecx
  80258b:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  802591:	bf 00 00 00 00       	mov    $0x0,%edi
  802596:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  80259c:	e9 01 ff ff ff       	jmp    8024a2 <spawn+0x331>
	close(fd);
  8025a1:	83 ec 0c             	sub    $0xc,%esp
  8025a4:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8025aa:	e8 41 f5 ff ff       	call   801af0 <close>

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	cprintf("in %s\n", __FUNCTION__);
  8025af:	83 c4 08             	add    $0x8,%esp
  8025b2:	68 7c 3b 80 00       	push   $0x803b7c
  8025b7:	68 2a 35 80 00       	push   $0x80352a
  8025bc:	e8 77 e0 ff ff       	call   800638 <cprintf>
  8025c1:	83 c4 10             	add    $0x10,%esp
	int r;
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  8025c4:	bb 00 00 80 00       	mov    $0x800000,%ebx
  8025c9:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  8025cf:	eb 0e                	jmp    8025df <spawn+0x46e>
  8025d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8025d7:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8025dd:	74 5e                	je     80263d <spawn+0x4cc>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_SHARE)) == (PTE_P | PTE_U | PTE_SHARE)))
  8025df:	89 d8                	mov    %ebx,%eax
  8025e1:	c1 e8 16             	shr    $0x16,%eax
  8025e4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8025eb:	a8 01                	test   $0x1,%al
  8025ed:	74 e2                	je     8025d1 <spawn+0x460>
  8025ef:	89 da                	mov    %ebx,%edx
  8025f1:	c1 ea 0c             	shr    $0xc,%edx
  8025f4:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8025fb:	25 05 04 00 00       	and    $0x405,%eax
  802600:	3d 05 04 00 00       	cmp    $0x405,%eax
  802605:	75 ca                	jne    8025d1 <spawn+0x460>
			if((r = sys_page_map((envid_t)0, (void *)i, child, (void *)i, uvpt[PGNUM(i)] & PTE_SYSCALL)) < 0)
  802607:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80260e:	83 ec 0c             	sub    $0xc,%esp
  802611:	25 07 0e 00 00       	and    $0xe07,%eax
  802616:	50                   	push   %eax
  802617:	53                   	push   %ebx
  802618:	56                   	push   %esi
  802619:	53                   	push   %ebx
  80261a:	6a 00                	push   $0x0
  80261c:	e8 ab eb ff ff       	call   8011cc <sys_page_map>
  802621:	83 c4 20             	add    $0x20,%esp
  802624:	85 c0                	test   %eax,%eax
  802626:	79 a9                	jns    8025d1 <spawn+0x460>
        		panic("sys_page_map: %e\n", r);
  802628:	50                   	push   %eax
  802629:	68 06 3b 80 00       	push   $0x803b06
  80262e:	68 3b 01 00 00       	push   $0x13b
  802633:	68 dd 3a 80 00       	push   $0x803add
  802638:	e8 05 df ff ff       	call   800542 <_panic>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  80263d:	83 ec 08             	sub    $0x8,%esp
  802640:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802646:	50                   	push   %eax
  802647:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80264d:	e8 40 ec ff ff       	call   801292 <sys_env_set_trapframe>
  802652:	83 c4 10             	add    $0x10,%esp
  802655:	85 c0                	test   %eax,%eax
  802657:	78 25                	js     80267e <spawn+0x50d>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802659:	83 ec 08             	sub    $0x8,%esp
  80265c:	6a 02                	push   $0x2
  80265e:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802664:	e8 e7 eb ff ff       	call   801250 <sys_env_set_status>
  802669:	83 c4 10             	add    $0x10,%esp
  80266c:	85 c0                	test   %eax,%eax
  80266e:	78 23                	js     802693 <spawn+0x522>
	return child;
  802670:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802676:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  80267c:	eb 36                	jmp    8026b4 <spawn+0x543>
		panic("sys_env_set_trapframe: %e", r);
  80267e:	50                   	push   %eax
  80267f:	68 18 3b 80 00       	push   $0x803b18
  802684:	68 8a 00 00 00       	push   $0x8a
  802689:	68 dd 3a 80 00       	push   $0x803add
  80268e:	e8 af de ff ff       	call   800542 <_panic>
		panic("sys_env_set_status: %e", r);
  802693:	50                   	push   %eax
  802694:	68 32 3b 80 00       	push   $0x803b32
  802699:	68 8d 00 00 00       	push   $0x8d
  80269e:	68 dd 3a 80 00       	push   $0x803add
  8026a3:	e8 9a de ff ff       	call   800542 <_panic>
		return r;
  8026a8:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8026ae:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  8026b4:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8026ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026bd:	5b                   	pop    %ebx
  8026be:	5e                   	pop    %esi
  8026bf:	5f                   	pop    %edi
  8026c0:	5d                   	pop    %ebp
  8026c1:	c3                   	ret    
  8026c2:	89 c7                	mov    %eax,%edi
  8026c4:	e9 0d fe ff ff       	jmp    8024d6 <spawn+0x365>
  8026c9:	89 c7                	mov    %eax,%edi
  8026cb:	e9 06 fe ff ff       	jmp    8024d6 <spawn+0x365>
  8026d0:	89 c7                	mov    %eax,%edi
  8026d2:	e9 ff fd ff ff       	jmp    8024d6 <spawn+0x365>
		return -E_NO_MEM;
  8026d7:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  8026dc:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8026e2:	eb d0                	jmp    8026b4 <spawn+0x543>
	sys_page_unmap(0, UTEMP);
  8026e4:	83 ec 08             	sub    $0x8,%esp
  8026e7:	68 00 00 40 00       	push   $0x400000
  8026ec:	6a 00                	push   $0x0
  8026ee:	e8 1b eb ff ff       	call   80120e <sys_page_unmap>
  8026f3:	83 c4 10             	add    $0x10,%esp
  8026f6:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  8026fc:	eb b6                	jmp    8026b4 <spawn+0x543>

008026fe <spawnl>:
{
  8026fe:	55                   	push   %ebp
  8026ff:	89 e5                	mov    %esp,%ebp
  802701:	57                   	push   %edi
  802702:	56                   	push   %esi
  802703:	53                   	push   %ebx
  802704:	83 ec 14             	sub    $0x14,%esp
	cprintf("in %s\n", __FUNCTION__);
  802707:	68 74 3b 80 00       	push   $0x803b74
  80270c:	68 2a 35 80 00       	push   $0x80352a
  802711:	e8 22 df ff ff       	call   800638 <cprintf>
	va_start(vl, arg0);
  802716:	8d 55 10             	lea    0x10(%ebp),%edx
	while(va_arg(vl, void *) != NULL)
  802719:	83 c4 10             	add    $0x10,%esp
	int argc=0;
  80271c:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  802721:	8d 4a 04             	lea    0x4(%edx),%ecx
  802724:	83 3a 00             	cmpl   $0x0,(%edx)
  802727:	74 07                	je     802730 <spawnl+0x32>
		argc++;
  802729:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  80272c:	89 ca                	mov    %ecx,%edx
  80272e:	eb f1                	jmp    802721 <spawnl+0x23>
	const char *argv[argc+2];
  802730:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  802737:	83 e2 f0             	and    $0xfffffff0,%edx
  80273a:	29 d4                	sub    %edx,%esp
  80273c:	8d 54 24 03          	lea    0x3(%esp),%edx
  802740:	c1 ea 02             	shr    $0x2,%edx
  802743:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  80274a:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  80274c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80274f:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  802756:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  80275d:	00 
	va_start(vl, arg0);
  80275e:	8d 4d 10             	lea    0x10(%ebp),%ecx
  802761:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  802763:	b8 00 00 00 00       	mov    $0x0,%eax
  802768:	eb 0b                	jmp    802775 <spawnl+0x77>
		argv[i+1] = va_arg(vl, const char *);
  80276a:	83 c0 01             	add    $0x1,%eax
  80276d:	8b 39                	mov    (%ecx),%edi
  80276f:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  802772:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  802775:	39 d0                	cmp    %edx,%eax
  802777:	75 f1                	jne    80276a <spawnl+0x6c>
	return spawn(prog, argv);
  802779:	83 ec 08             	sub    $0x8,%esp
  80277c:	56                   	push   %esi
  80277d:	ff 75 08             	pushl  0x8(%ebp)
  802780:	e8 ec f9 ff ff       	call   802171 <spawn>
}
  802785:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802788:	5b                   	pop    %ebx
  802789:	5e                   	pop    %esi
  80278a:	5f                   	pop    %edi
  80278b:	5d                   	pop    %ebp
  80278c:	c3                   	ret    

0080278d <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80278d:	55                   	push   %ebp
  80278e:	89 e5                	mov    %esp,%ebp
  802790:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  802793:	68 a2 3b 80 00       	push   $0x803ba2
  802798:	ff 75 0c             	pushl  0xc(%ebp)
  80279b:	e8 f7 e5 ff ff       	call   800d97 <strcpy>
	return 0;
}
  8027a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a5:	c9                   	leave  
  8027a6:	c3                   	ret    

008027a7 <devsock_close>:
{
  8027a7:	55                   	push   %ebp
  8027a8:	89 e5                	mov    %esp,%ebp
  8027aa:	53                   	push   %ebx
  8027ab:	83 ec 10             	sub    $0x10,%esp
  8027ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8027b1:	53                   	push   %ebx
  8027b2:	e8 6b 09 00 00       	call   803122 <pageref>
  8027b7:	83 c4 10             	add    $0x10,%esp
		return 0;
  8027ba:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8027bf:	83 f8 01             	cmp    $0x1,%eax
  8027c2:	74 07                	je     8027cb <devsock_close+0x24>
}
  8027c4:	89 d0                	mov    %edx,%eax
  8027c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027c9:	c9                   	leave  
  8027ca:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8027cb:	83 ec 0c             	sub    $0xc,%esp
  8027ce:	ff 73 0c             	pushl  0xc(%ebx)
  8027d1:	e8 b9 02 00 00       	call   802a8f <nsipc_close>
  8027d6:	89 c2                	mov    %eax,%edx
  8027d8:	83 c4 10             	add    $0x10,%esp
  8027db:	eb e7                	jmp    8027c4 <devsock_close+0x1d>

008027dd <devsock_write>:
{
  8027dd:	55                   	push   %ebp
  8027de:	89 e5                	mov    %esp,%ebp
  8027e0:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8027e3:	6a 00                	push   $0x0
  8027e5:	ff 75 10             	pushl  0x10(%ebp)
  8027e8:	ff 75 0c             	pushl  0xc(%ebp)
  8027eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ee:	ff 70 0c             	pushl  0xc(%eax)
  8027f1:	e8 76 03 00 00       	call   802b6c <nsipc_send>
}
  8027f6:	c9                   	leave  
  8027f7:	c3                   	ret    

008027f8 <devsock_read>:
{
  8027f8:	55                   	push   %ebp
  8027f9:	89 e5                	mov    %esp,%ebp
  8027fb:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8027fe:	6a 00                	push   $0x0
  802800:	ff 75 10             	pushl  0x10(%ebp)
  802803:	ff 75 0c             	pushl  0xc(%ebp)
  802806:	8b 45 08             	mov    0x8(%ebp),%eax
  802809:	ff 70 0c             	pushl  0xc(%eax)
  80280c:	e8 ef 02 00 00       	call   802b00 <nsipc_recv>
}
  802811:	c9                   	leave  
  802812:	c3                   	ret    

00802813 <fd2sockid>:
{
  802813:	55                   	push   %ebp
  802814:	89 e5                	mov    %esp,%ebp
  802816:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802819:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80281c:	52                   	push   %edx
  80281d:	50                   	push   %eax
  80281e:	e8 9b f1 ff ff       	call   8019be <fd_lookup>
  802823:	83 c4 10             	add    $0x10,%esp
  802826:	85 c0                	test   %eax,%eax
  802828:	78 10                	js     80283a <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80282a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282d:	8b 0d 3c 40 80 00    	mov    0x80403c,%ecx
  802833:	39 08                	cmp    %ecx,(%eax)
  802835:	75 05                	jne    80283c <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802837:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80283a:	c9                   	leave  
  80283b:	c3                   	ret    
		return -E_NOT_SUPP;
  80283c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802841:	eb f7                	jmp    80283a <fd2sockid+0x27>

00802843 <alloc_sockfd>:
{
  802843:	55                   	push   %ebp
  802844:	89 e5                	mov    %esp,%ebp
  802846:	56                   	push   %esi
  802847:	53                   	push   %ebx
  802848:	83 ec 1c             	sub    $0x1c,%esp
  80284b:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80284d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802850:	50                   	push   %eax
  802851:	e8 16 f1 ff ff       	call   80196c <fd_alloc>
  802856:	89 c3                	mov    %eax,%ebx
  802858:	83 c4 10             	add    $0x10,%esp
  80285b:	85 c0                	test   %eax,%eax
  80285d:	78 43                	js     8028a2 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80285f:	83 ec 04             	sub    $0x4,%esp
  802862:	68 07 04 00 00       	push   $0x407
  802867:	ff 75 f4             	pushl  -0xc(%ebp)
  80286a:	6a 00                	push   $0x0
  80286c:	e8 18 e9 ff ff       	call   801189 <sys_page_alloc>
  802871:	89 c3                	mov    %eax,%ebx
  802873:	83 c4 10             	add    $0x10,%esp
  802876:	85 c0                	test   %eax,%eax
  802878:	78 28                	js     8028a2 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80287a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287d:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  802883:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802888:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80288f:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802892:	83 ec 0c             	sub    $0xc,%esp
  802895:	50                   	push   %eax
  802896:	e8 aa f0 ff ff       	call   801945 <fd2num>
  80289b:	89 c3                	mov    %eax,%ebx
  80289d:	83 c4 10             	add    $0x10,%esp
  8028a0:	eb 0c                	jmp    8028ae <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8028a2:	83 ec 0c             	sub    $0xc,%esp
  8028a5:	56                   	push   %esi
  8028a6:	e8 e4 01 00 00       	call   802a8f <nsipc_close>
		return r;
  8028ab:	83 c4 10             	add    $0x10,%esp
}
  8028ae:	89 d8                	mov    %ebx,%eax
  8028b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8028b3:	5b                   	pop    %ebx
  8028b4:	5e                   	pop    %esi
  8028b5:	5d                   	pop    %ebp
  8028b6:	c3                   	ret    

008028b7 <accept>:
{
  8028b7:	55                   	push   %ebp
  8028b8:	89 e5                	mov    %esp,%ebp
  8028ba:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8028bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c0:	e8 4e ff ff ff       	call   802813 <fd2sockid>
  8028c5:	85 c0                	test   %eax,%eax
  8028c7:	78 1b                	js     8028e4 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8028c9:	83 ec 04             	sub    $0x4,%esp
  8028cc:	ff 75 10             	pushl  0x10(%ebp)
  8028cf:	ff 75 0c             	pushl  0xc(%ebp)
  8028d2:	50                   	push   %eax
  8028d3:	e8 0e 01 00 00       	call   8029e6 <nsipc_accept>
  8028d8:	83 c4 10             	add    $0x10,%esp
  8028db:	85 c0                	test   %eax,%eax
  8028dd:	78 05                	js     8028e4 <accept+0x2d>
	return alloc_sockfd(r);
  8028df:	e8 5f ff ff ff       	call   802843 <alloc_sockfd>
}
  8028e4:	c9                   	leave  
  8028e5:	c3                   	ret    

008028e6 <bind>:
{
  8028e6:	55                   	push   %ebp
  8028e7:	89 e5                	mov    %esp,%ebp
  8028e9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8028ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ef:	e8 1f ff ff ff       	call   802813 <fd2sockid>
  8028f4:	85 c0                	test   %eax,%eax
  8028f6:	78 12                	js     80290a <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8028f8:	83 ec 04             	sub    $0x4,%esp
  8028fb:	ff 75 10             	pushl  0x10(%ebp)
  8028fe:	ff 75 0c             	pushl  0xc(%ebp)
  802901:	50                   	push   %eax
  802902:	e8 31 01 00 00       	call   802a38 <nsipc_bind>
  802907:	83 c4 10             	add    $0x10,%esp
}
  80290a:	c9                   	leave  
  80290b:	c3                   	ret    

0080290c <shutdown>:
{
  80290c:	55                   	push   %ebp
  80290d:	89 e5                	mov    %esp,%ebp
  80290f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802912:	8b 45 08             	mov    0x8(%ebp),%eax
  802915:	e8 f9 fe ff ff       	call   802813 <fd2sockid>
  80291a:	85 c0                	test   %eax,%eax
  80291c:	78 0f                	js     80292d <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80291e:	83 ec 08             	sub    $0x8,%esp
  802921:	ff 75 0c             	pushl  0xc(%ebp)
  802924:	50                   	push   %eax
  802925:	e8 43 01 00 00       	call   802a6d <nsipc_shutdown>
  80292a:	83 c4 10             	add    $0x10,%esp
}
  80292d:	c9                   	leave  
  80292e:	c3                   	ret    

0080292f <connect>:
{
  80292f:	55                   	push   %ebp
  802930:	89 e5                	mov    %esp,%ebp
  802932:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802935:	8b 45 08             	mov    0x8(%ebp),%eax
  802938:	e8 d6 fe ff ff       	call   802813 <fd2sockid>
  80293d:	85 c0                	test   %eax,%eax
  80293f:	78 12                	js     802953 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802941:	83 ec 04             	sub    $0x4,%esp
  802944:	ff 75 10             	pushl  0x10(%ebp)
  802947:	ff 75 0c             	pushl  0xc(%ebp)
  80294a:	50                   	push   %eax
  80294b:	e8 59 01 00 00       	call   802aa9 <nsipc_connect>
  802950:	83 c4 10             	add    $0x10,%esp
}
  802953:	c9                   	leave  
  802954:	c3                   	ret    

00802955 <listen>:
{
  802955:	55                   	push   %ebp
  802956:	89 e5                	mov    %esp,%ebp
  802958:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80295b:	8b 45 08             	mov    0x8(%ebp),%eax
  80295e:	e8 b0 fe ff ff       	call   802813 <fd2sockid>
  802963:	85 c0                	test   %eax,%eax
  802965:	78 0f                	js     802976 <listen+0x21>
	return nsipc_listen(r, backlog);
  802967:	83 ec 08             	sub    $0x8,%esp
  80296a:	ff 75 0c             	pushl  0xc(%ebp)
  80296d:	50                   	push   %eax
  80296e:	e8 6b 01 00 00       	call   802ade <nsipc_listen>
  802973:	83 c4 10             	add    $0x10,%esp
}
  802976:	c9                   	leave  
  802977:	c3                   	ret    

00802978 <socket>:

int
socket(int domain, int type, int protocol)
{
  802978:	55                   	push   %ebp
  802979:	89 e5                	mov    %esp,%ebp
  80297b:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80297e:	ff 75 10             	pushl  0x10(%ebp)
  802981:	ff 75 0c             	pushl  0xc(%ebp)
  802984:	ff 75 08             	pushl  0x8(%ebp)
  802987:	e8 3e 02 00 00       	call   802bca <nsipc_socket>
  80298c:	83 c4 10             	add    $0x10,%esp
  80298f:	85 c0                	test   %eax,%eax
  802991:	78 05                	js     802998 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802993:	e8 ab fe ff ff       	call   802843 <alloc_sockfd>
}
  802998:	c9                   	leave  
  802999:	c3                   	ret    

0080299a <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80299a:	55                   	push   %ebp
  80299b:	89 e5                	mov    %esp,%ebp
  80299d:	53                   	push   %ebx
  80299e:	83 ec 04             	sub    $0x4,%esp
  8029a1:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8029a3:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8029aa:	74 26                	je     8029d2 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8029ac:	6a 07                	push   $0x7
  8029ae:	68 00 70 80 00       	push   $0x807000
  8029b3:	53                   	push   %ebx
  8029b4:	ff 35 04 50 80 00    	pushl  0x805004
  8029ba:	e8 d0 06 00 00       	call   80308f <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8029bf:	83 c4 0c             	add    $0xc,%esp
  8029c2:	6a 00                	push   $0x0
  8029c4:	6a 00                	push   $0x0
  8029c6:	6a 00                	push   $0x0
  8029c8:	e8 59 06 00 00       	call   803026 <ipc_recv>
}
  8029cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8029d0:	c9                   	leave  
  8029d1:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8029d2:	83 ec 0c             	sub    $0xc,%esp
  8029d5:	6a 02                	push   $0x2
  8029d7:	e8 0b 07 00 00       	call   8030e7 <ipc_find_env>
  8029dc:	a3 04 50 80 00       	mov    %eax,0x805004
  8029e1:	83 c4 10             	add    $0x10,%esp
  8029e4:	eb c6                	jmp    8029ac <nsipc+0x12>

008029e6 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8029e6:	55                   	push   %ebp
  8029e7:	89 e5                	mov    %esp,%ebp
  8029e9:	56                   	push   %esi
  8029ea:	53                   	push   %ebx
  8029eb:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8029ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f1:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8029f6:	8b 06                	mov    (%esi),%eax
  8029f8:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8029fd:	b8 01 00 00 00       	mov    $0x1,%eax
  802a02:	e8 93 ff ff ff       	call   80299a <nsipc>
  802a07:	89 c3                	mov    %eax,%ebx
  802a09:	85 c0                	test   %eax,%eax
  802a0b:	79 09                	jns    802a16 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802a0d:	89 d8                	mov    %ebx,%eax
  802a0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a12:	5b                   	pop    %ebx
  802a13:	5e                   	pop    %esi
  802a14:	5d                   	pop    %ebp
  802a15:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802a16:	83 ec 04             	sub    $0x4,%esp
  802a19:	ff 35 10 70 80 00    	pushl  0x807010
  802a1f:	68 00 70 80 00       	push   $0x807000
  802a24:	ff 75 0c             	pushl  0xc(%ebp)
  802a27:	e8 f9 e4 ff ff       	call   800f25 <memmove>
		*addrlen = ret->ret_addrlen;
  802a2c:	a1 10 70 80 00       	mov    0x807010,%eax
  802a31:	89 06                	mov    %eax,(%esi)
  802a33:	83 c4 10             	add    $0x10,%esp
	return r;
  802a36:	eb d5                	jmp    802a0d <nsipc_accept+0x27>

00802a38 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802a38:	55                   	push   %ebp
  802a39:	89 e5                	mov    %esp,%ebp
  802a3b:	53                   	push   %ebx
  802a3c:	83 ec 08             	sub    $0x8,%esp
  802a3f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802a42:	8b 45 08             	mov    0x8(%ebp),%eax
  802a45:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802a4a:	53                   	push   %ebx
  802a4b:	ff 75 0c             	pushl  0xc(%ebp)
  802a4e:	68 04 70 80 00       	push   $0x807004
  802a53:	e8 cd e4 ff ff       	call   800f25 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802a58:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802a5e:	b8 02 00 00 00       	mov    $0x2,%eax
  802a63:	e8 32 ff ff ff       	call   80299a <nsipc>
}
  802a68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802a6b:	c9                   	leave  
  802a6c:	c3                   	ret    

00802a6d <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802a6d:	55                   	push   %ebp
  802a6e:	89 e5                	mov    %esp,%ebp
  802a70:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802a73:	8b 45 08             	mov    0x8(%ebp),%eax
  802a76:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802a7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a7e:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802a83:	b8 03 00 00 00       	mov    $0x3,%eax
  802a88:	e8 0d ff ff ff       	call   80299a <nsipc>
}
  802a8d:	c9                   	leave  
  802a8e:	c3                   	ret    

00802a8f <nsipc_close>:

int
nsipc_close(int s)
{
  802a8f:	55                   	push   %ebp
  802a90:	89 e5                	mov    %esp,%ebp
  802a92:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802a95:	8b 45 08             	mov    0x8(%ebp),%eax
  802a98:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802a9d:	b8 04 00 00 00       	mov    $0x4,%eax
  802aa2:	e8 f3 fe ff ff       	call   80299a <nsipc>
}
  802aa7:	c9                   	leave  
  802aa8:	c3                   	ret    

00802aa9 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802aa9:	55                   	push   %ebp
  802aaa:	89 e5                	mov    %esp,%ebp
  802aac:	53                   	push   %ebx
  802aad:	83 ec 08             	sub    $0x8,%esp
  802ab0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab6:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802abb:	53                   	push   %ebx
  802abc:	ff 75 0c             	pushl  0xc(%ebp)
  802abf:	68 04 70 80 00       	push   $0x807004
  802ac4:	e8 5c e4 ff ff       	call   800f25 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802ac9:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802acf:	b8 05 00 00 00       	mov    $0x5,%eax
  802ad4:	e8 c1 fe ff ff       	call   80299a <nsipc>
}
  802ad9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802adc:	c9                   	leave  
  802add:	c3                   	ret    

00802ade <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802ade:	55                   	push   %ebp
  802adf:	89 e5                	mov    %esp,%ebp
  802ae1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802aec:	8b 45 0c             	mov    0xc(%ebp),%eax
  802aef:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802af4:	b8 06 00 00 00       	mov    $0x6,%eax
  802af9:	e8 9c fe ff ff       	call   80299a <nsipc>
}
  802afe:	c9                   	leave  
  802aff:	c3                   	ret    

00802b00 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802b00:	55                   	push   %ebp
  802b01:	89 e5                	mov    %esp,%ebp
  802b03:	56                   	push   %esi
  802b04:	53                   	push   %ebx
  802b05:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802b08:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802b10:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802b16:	8b 45 14             	mov    0x14(%ebp),%eax
  802b19:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802b1e:	b8 07 00 00 00       	mov    $0x7,%eax
  802b23:	e8 72 fe ff ff       	call   80299a <nsipc>
  802b28:	89 c3                	mov    %eax,%ebx
  802b2a:	85 c0                	test   %eax,%eax
  802b2c:	78 1f                	js     802b4d <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802b2e:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802b33:	7f 21                	jg     802b56 <nsipc_recv+0x56>
  802b35:	39 c6                	cmp    %eax,%esi
  802b37:	7c 1d                	jl     802b56 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802b39:	83 ec 04             	sub    $0x4,%esp
  802b3c:	50                   	push   %eax
  802b3d:	68 00 70 80 00       	push   $0x807000
  802b42:	ff 75 0c             	pushl  0xc(%ebp)
  802b45:	e8 db e3 ff ff       	call   800f25 <memmove>
  802b4a:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802b4d:	89 d8                	mov    %ebx,%eax
  802b4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802b52:	5b                   	pop    %ebx
  802b53:	5e                   	pop    %esi
  802b54:	5d                   	pop    %ebp
  802b55:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802b56:	68 ae 3b 80 00       	push   $0x803bae
  802b5b:	68 97 3a 80 00       	push   $0x803a97
  802b60:	6a 62                	push   $0x62
  802b62:	68 c3 3b 80 00       	push   $0x803bc3
  802b67:	e8 d6 d9 ff ff       	call   800542 <_panic>

00802b6c <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802b6c:	55                   	push   %ebp
  802b6d:	89 e5                	mov    %esp,%ebp
  802b6f:	53                   	push   %ebx
  802b70:	83 ec 04             	sub    $0x4,%esp
  802b73:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802b76:	8b 45 08             	mov    0x8(%ebp),%eax
  802b79:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802b7e:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802b84:	7f 2e                	jg     802bb4 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802b86:	83 ec 04             	sub    $0x4,%esp
  802b89:	53                   	push   %ebx
  802b8a:	ff 75 0c             	pushl  0xc(%ebp)
  802b8d:	68 0c 70 80 00       	push   $0x80700c
  802b92:	e8 8e e3 ff ff       	call   800f25 <memmove>
	nsipcbuf.send.req_size = size;
  802b97:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802b9d:	8b 45 14             	mov    0x14(%ebp),%eax
  802ba0:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802ba5:	b8 08 00 00 00       	mov    $0x8,%eax
  802baa:	e8 eb fd ff ff       	call   80299a <nsipc>
}
  802baf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802bb2:	c9                   	leave  
  802bb3:	c3                   	ret    
	assert(size < 1600);
  802bb4:	68 cf 3b 80 00       	push   $0x803bcf
  802bb9:	68 97 3a 80 00       	push   $0x803a97
  802bbe:	6a 6d                	push   $0x6d
  802bc0:	68 c3 3b 80 00       	push   $0x803bc3
  802bc5:	e8 78 d9 ff ff       	call   800542 <_panic>

00802bca <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802bca:	55                   	push   %ebp
  802bcb:	89 e5                	mov    %esp,%ebp
  802bcd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd3:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802bd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bdb:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802be0:	8b 45 10             	mov    0x10(%ebp),%eax
  802be3:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802be8:	b8 09 00 00 00       	mov    $0x9,%eax
  802bed:	e8 a8 fd ff ff       	call   80299a <nsipc>
}
  802bf2:	c9                   	leave  
  802bf3:	c3                   	ret    

00802bf4 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802bf4:	55                   	push   %ebp
  802bf5:	89 e5                	mov    %esp,%ebp
  802bf7:	56                   	push   %esi
  802bf8:	53                   	push   %ebx
  802bf9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802bfc:	83 ec 0c             	sub    $0xc,%esp
  802bff:	ff 75 08             	pushl  0x8(%ebp)
  802c02:	e8 4e ed ff ff       	call   801955 <fd2data>
  802c07:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802c09:	83 c4 08             	add    $0x8,%esp
  802c0c:	68 db 3b 80 00       	push   $0x803bdb
  802c11:	53                   	push   %ebx
  802c12:	e8 80 e1 ff ff       	call   800d97 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802c17:	8b 46 04             	mov    0x4(%esi),%eax
  802c1a:	2b 06                	sub    (%esi),%eax
  802c1c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802c22:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802c29:	00 00 00 
	stat->st_dev = &devpipe;
  802c2c:	c7 83 88 00 00 00 58 	movl   $0x804058,0x88(%ebx)
  802c33:	40 80 00 
	return 0;
}
  802c36:	b8 00 00 00 00       	mov    $0x0,%eax
  802c3b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802c3e:	5b                   	pop    %ebx
  802c3f:	5e                   	pop    %esi
  802c40:	5d                   	pop    %ebp
  802c41:	c3                   	ret    

00802c42 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802c42:	55                   	push   %ebp
  802c43:	89 e5                	mov    %esp,%ebp
  802c45:	53                   	push   %ebx
  802c46:	83 ec 0c             	sub    $0xc,%esp
  802c49:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802c4c:	53                   	push   %ebx
  802c4d:	6a 00                	push   $0x0
  802c4f:	e8 ba e5 ff ff       	call   80120e <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802c54:	89 1c 24             	mov    %ebx,(%esp)
  802c57:	e8 f9 ec ff ff       	call   801955 <fd2data>
  802c5c:	83 c4 08             	add    $0x8,%esp
  802c5f:	50                   	push   %eax
  802c60:	6a 00                	push   $0x0
  802c62:	e8 a7 e5 ff ff       	call   80120e <sys_page_unmap>
}
  802c67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802c6a:	c9                   	leave  
  802c6b:	c3                   	ret    

00802c6c <_pipeisclosed>:
{
  802c6c:	55                   	push   %ebp
  802c6d:	89 e5                	mov    %esp,%ebp
  802c6f:	57                   	push   %edi
  802c70:	56                   	push   %esi
  802c71:	53                   	push   %ebx
  802c72:	83 ec 1c             	sub    $0x1c,%esp
  802c75:	89 c7                	mov    %eax,%edi
  802c77:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802c79:	a1 08 50 80 00       	mov    0x805008,%eax
  802c7e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802c81:	83 ec 0c             	sub    $0xc,%esp
  802c84:	57                   	push   %edi
  802c85:	e8 98 04 00 00       	call   803122 <pageref>
  802c8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802c8d:	89 34 24             	mov    %esi,(%esp)
  802c90:	e8 8d 04 00 00       	call   803122 <pageref>
		nn = thisenv->env_runs;
  802c95:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802c9b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802c9e:	83 c4 10             	add    $0x10,%esp
  802ca1:	39 cb                	cmp    %ecx,%ebx
  802ca3:	74 1b                	je     802cc0 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802ca5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802ca8:	75 cf                	jne    802c79 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802caa:	8b 42 58             	mov    0x58(%edx),%eax
  802cad:	6a 01                	push   $0x1
  802caf:	50                   	push   %eax
  802cb0:	53                   	push   %ebx
  802cb1:	68 e2 3b 80 00       	push   $0x803be2
  802cb6:	e8 7d d9 ff ff       	call   800638 <cprintf>
  802cbb:	83 c4 10             	add    $0x10,%esp
  802cbe:	eb b9                	jmp    802c79 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802cc0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802cc3:	0f 94 c0             	sete   %al
  802cc6:	0f b6 c0             	movzbl %al,%eax
}
  802cc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802ccc:	5b                   	pop    %ebx
  802ccd:	5e                   	pop    %esi
  802cce:	5f                   	pop    %edi
  802ccf:	5d                   	pop    %ebp
  802cd0:	c3                   	ret    

00802cd1 <devpipe_write>:
{
  802cd1:	55                   	push   %ebp
  802cd2:	89 e5                	mov    %esp,%ebp
  802cd4:	57                   	push   %edi
  802cd5:	56                   	push   %esi
  802cd6:	53                   	push   %ebx
  802cd7:	83 ec 28             	sub    $0x28,%esp
  802cda:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802cdd:	56                   	push   %esi
  802cde:	e8 72 ec ff ff       	call   801955 <fd2data>
  802ce3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802ce5:	83 c4 10             	add    $0x10,%esp
  802ce8:	bf 00 00 00 00       	mov    $0x0,%edi
  802ced:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802cf0:	74 4f                	je     802d41 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802cf2:	8b 43 04             	mov    0x4(%ebx),%eax
  802cf5:	8b 0b                	mov    (%ebx),%ecx
  802cf7:	8d 51 20             	lea    0x20(%ecx),%edx
  802cfa:	39 d0                	cmp    %edx,%eax
  802cfc:	72 14                	jb     802d12 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802cfe:	89 da                	mov    %ebx,%edx
  802d00:	89 f0                	mov    %esi,%eax
  802d02:	e8 65 ff ff ff       	call   802c6c <_pipeisclosed>
  802d07:	85 c0                	test   %eax,%eax
  802d09:	75 3b                	jne    802d46 <devpipe_write+0x75>
			sys_yield();
  802d0b:	e8 5a e4 ff ff       	call   80116a <sys_yield>
  802d10:	eb e0                	jmp    802cf2 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802d12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802d15:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802d19:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802d1c:	89 c2                	mov    %eax,%edx
  802d1e:	c1 fa 1f             	sar    $0x1f,%edx
  802d21:	89 d1                	mov    %edx,%ecx
  802d23:	c1 e9 1b             	shr    $0x1b,%ecx
  802d26:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802d29:	83 e2 1f             	and    $0x1f,%edx
  802d2c:	29 ca                	sub    %ecx,%edx
  802d2e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802d32:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802d36:	83 c0 01             	add    $0x1,%eax
  802d39:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802d3c:	83 c7 01             	add    $0x1,%edi
  802d3f:	eb ac                	jmp    802ced <devpipe_write+0x1c>
	return i;
  802d41:	8b 45 10             	mov    0x10(%ebp),%eax
  802d44:	eb 05                	jmp    802d4b <devpipe_write+0x7a>
				return 0;
  802d46:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d4e:	5b                   	pop    %ebx
  802d4f:	5e                   	pop    %esi
  802d50:	5f                   	pop    %edi
  802d51:	5d                   	pop    %ebp
  802d52:	c3                   	ret    

00802d53 <devpipe_read>:
{
  802d53:	55                   	push   %ebp
  802d54:	89 e5                	mov    %esp,%ebp
  802d56:	57                   	push   %edi
  802d57:	56                   	push   %esi
  802d58:	53                   	push   %ebx
  802d59:	83 ec 18             	sub    $0x18,%esp
  802d5c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802d5f:	57                   	push   %edi
  802d60:	e8 f0 eb ff ff       	call   801955 <fd2data>
  802d65:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802d67:	83 c4 10             	add    $0x10,%esp
  802d6a:	be 00 00 00 00       	mov    $0x0,%esi
  802d6f:	3b 75 10             	cmp    0x10(%ebp),%esi
  802d72:	75 14                	jne    802d88 <devpipe_read+0x35>
	return i;
  802d74:	8b 45 10             	mov    0x10(%ebp),%eax
  802d77:	eb 02                	jmp    802d7b <devpipe_read+0x28>
				return i;
  802d79:	89 f0                	mov    %esi,%eax
}
  802d7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d7e:	5b                   	pop    %ebx
  802d7f:	5e                   	pop    %esi
  802d80:	5f                   	pop    %edi
  802d81:	5d                   	pop    %ebp
  802d82:	c3                   	ret    
			sys_yield();
  802d83:	e8 e2 e3 ff ff       	call   80116a <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802d88:	8b 03                	mov    (%ebx),%eax
  802d8a:	3b 43 04             	cmp    0x4(%ebx),%eax
  802d8d:	75 18                	jne    802da7 <devpipe_read+0x54>
			if (i > 0)
  802d8f:	85 f6                	test   %esi,%esi
  802d91:	75 e6                	jne    802d79 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802d93:	89 da                	mov    %ebx,%edx
  802d95:	89 f8                	mov    %edi,%eax
  802d97:	e8 d0 fe ff ff       	call   802c6c <_pipeisclosed>
  802d9c:	85 c0                	test   %eax,%eax
  802d9e:	74 e3                	je     802d83 <devpipe_read+0x30>
				return 0;
  802da0:	b8 00 00 00 00       	mov    $0x0,%eax
  802da5:	eb d4                	jmp    802d7b <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802da7:	99                   	cltd   
  802da8:	c1 ea 1b             	shr    $0x1b,%edx
  802dab:	01 d0                	add    %edx,%eax
  802dad:	83 e0 1f             	and    $0x1f,%eax
  802db0:	29 d0                	sub    %edx,%eax
  802db2:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802db7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802dba:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802dbd:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802dc0:	83 c6 01             	add    $0x1,%esi
  802dc3:	eb aa                	jmp    802d6f <devpipe_read+0x1c>

00802dc5 <pipe>:
{
  802dc5:	55                   	push   %ebp
  802dc6:	89 e5                	mov    %esp,%ebp
  802dc8:	56                   	push   %esi
  802dc9:	53                   	push   %ebx
  802dca:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802dcd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802dd0:	50                   	push   %eax
  802dd1:	e8 96 eb ff ff       	call   80196c <fd_alloc>
  802dd6:	89 c3                	mov    %eax,%ebx
  802dd8:	83 c4 10             	add    $0x10,%esp
  802ddb:	85 c0                	test   %eax,%eax
  802ddd:	0f 88 23 01 00 00    	js     802f06 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802de3:	83 ec 04             	sub    $0x4,%esp
  802de6:	68 07 04 00 00       	push   $0x407
  802deb:	ff 75 f4             	pushl  -0xc(%ebp)
  802dee:	6a 00                	push   $0x0
  802df0:	e8 94 e3 ff ff       	call   801189 <sys_page_alloc>
  802df5:	89 c3                	mov    %eax,%ebx
  802df7:	83 c4 10             	add    $0x10,%esp
  802dfa:	85 c0                	test   %eax,%eax
  802dfc:	0f 88 04 01 00 00    	js     802f06 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802e02:	83 ec 0c             	sub    $0xc,%esp
  802e05:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802e08:	50                   	push   %eax
  802e09:	e8 5e eb ff ff       	call   80196c <fd_alloc>
  802e0e:	89 c3                	mov    %eax,%ebx
  802e10:	83 c4 10             	add    $0x10,%esp
  802e13:	85 c0                	test   %eax,%eax
  802e15:	0f 88 db 00 00 00    	js     802ef6 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e1b:	83 ec 04             	sub    $0x4,%esp
  802e1e:	68 07 04 00 00       	push   $0x407
  802e23:	ff 75 f0             	pushl  -0x10(%ebp)
  802e26:	6a 00                	push   $0x0
  802e28:	e8 5c e3 ff ff       	call   801189 <sys_page_alloc>
  802e2d:	89 c3                	mov    %eax,%ebx
  802e2f:	83 c4 10             	add    $0x10,%esp
  802e32:	85 c0                	test   %eax,%eax
  802e34:	0f 88 bc 00 00 00    	js     802ef6 <pipe+0x131>
	va = fd2data(fd0);
  802e3a:	83 ec 0c             	sub    $0xc,%esp
  802e3d:	ff 75 f4             	pushl  -0xc(%ebp)
  802e40:	e8 10 eb ff ff       	call   801955 <fd2data>
  802e45:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e47:	83 c4 0c             	add    $0xc,%esp
  802e4a:	68 07 04 00 00       	push   $0x407
  802e4f:	50                   	push   %eax
  802e50:	6a 00                	push   $0x0
  802e52:	e8 32 e3 ff ff       	call   801189 <sys_page_alloc>
  802e57:	89 c3                	mov    %eax,%ebx
  802e59:	83 c4 10             	add    $0x10,%esp
  802e5c:	85 c0                	test   %eax,%eax
  802e5e:	0f 88 82 00 00 00    	js     802ee6 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e64:	83 ec 0c             	sub    $0xc,%esp
  802e67:	ff 75 f0             	pushl  -0x10(%ebp)
  802e6a:	e8 e6 ea ff ff       	call   801955 <fd2data>
  802e6f:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802e76:	50                   	push   %eax
  802e77:	6a 00                	push   $0x0
  802e79:	56                   	push   %esi
  802e7a:	6a 00                	push   $0x0
  802e7c:	e8 4b e3 ff ff       	call   8011cc <sys_page_map>
  802e81:	89 c3                	mov    %eax,%ebx
  802e83:	83 c4 20             	add    $0x20,%esp
  802e86:	85 c0                	test   %eax,%eax
  802e88:	78 4e                	js     802ed8 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802e8a:	a1 58 40 80 00       	mov    0x804058,%eax
  802e8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e92:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802e94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e97:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802e9e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ea1:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802ead:	83 ec 0c             	sub    $0xc,%esp
  802eb0:	ff 75 f4             	pushl  -0xc(%ebp)
  802eb3:	e8 8d ea ff ff       	call   801945 <fd2num>
  802eb8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802ebb:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802ebd:	83 c4 04             	add    $0x4,%esp
  802ec0:	ff 75 f0             	pushl  -0x10(%ebp)
  802ec3:	e8 7d ea ff ff       	call   801945 <fd2num>
  802ec8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802ecb:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802ece:	83 c4 10             	add    $0x10,%esp
  802ed1:	bb 00 00 00 00       	mov    $0x0,%ebx
  802ed6:	eb 2e                	jmp    802f06 <pipe+0x141>
	sys_page_unmap(0, va);
  802ed8:	83 ec 08             	sub    $0x8,%esp
  802edb:	56                   	push   %esi
  802edc:	6a 00                	push   $0x0
  802ede:	e8 2b e3 ff ff       	call   80120e <sys_page_unmap>
  802ee3:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802ee6:	83 ec 08             	sub    $0x8,%esp
  802ee9:	ff 75 f0             	pushl  -0x10(%ebp)
  802eec:	6a 00                	push   $0x0
  802eee:	e8 1b e3 ff ff       	call   80120e <sys_page_unmap>
  802ef3:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802ef6:	83 ec 08             	sub    $0x8,%esp
  802ef9:	ff 75 f4             	pushl  -0xc(%ebp)
  802efc:	6a 00                	push   $0x0
  802efe:	e8 0b e3 ff ff       	call   80120e <sys_page_unmap>
  802f03:	83 c4 10             	add    $0x10,%esp
}
  802f06:	89 d8                	mov    %ebx,%eax
  802f08:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f0b:	5b                   	pop    %ebx
  802f0c:	5e                   	pop    %esi
  802f0d:	5d                   	pop    %ebp
  802f0e:	c3                   	ret    

00802f0f <pipeisclosed>:
{
  802f0f:	55                   	push   %ebp
  802f10:	89 e5                	mov    %esp,%ebp
  802f12:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f15:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f18:	50                   	push   %eax
  802f19:	ff 75 08             	pushl  0x8(%ebp)
  802f1c:	e8 9d ea ff ff       	call   8019be <fd_lookup>
  802f21:	83 c4 10             	add    $0x10,%esp
  802f24:	85 c0                	test   %eax,%eax
  802f26:	78 18                	js     802f40 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802f28:	83 ec 0c             	sub    $0xc,%esp
  802f2b:	ff 75 f4             	pushl  -0xc(%ebp)
  802f2e:	e8 22 ea ff ff       	call   801955 <fd2data>
	return _pipeisclosed(fd, p);
  802f33:	89 c2                	mov    %eax,%edx
  802f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f38:	e8 2f fd ff ff       	call   802c6c <_pipeisclosed>
  802f3d:	83 c4 10             	add    $0x10,%esp
}
  802f40:	c9                   	leave  
  802f41:	c3                   	ret    

00802f42 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802f42:	55                   	push   %ebp
  802f43:	89 e5                	mov    %esp,%ebp
  802f45:	56                   	push   %esi
  802f46:	53                   	push   %ebx
  802f47:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802f4a:	85 f6                	test   %esi,%esi
  802f4c:	74 13                	je     802f61 <wait+0x1f>
	e = &envs[ENVX(envid)];
  802f4e:	89 f3                	mov    %esi,%ebx
  802f50:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802f56:	c1 e3 07             	shl    $0x7,%ebx
  802f59:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802f5f:	eb 1b                	jmp    802f7c <wait+0x3a>
	assert(envid != 0);
  802f61:	68 fa 3b 80 00       	push   $0x803bfa
  802f66:	68 97 3a 80 00       	push   $0x803a97
  802f6b:	6a 09                	push   $0x9
  802f6d:	68 05 3c 80 00       	push   $0x803c05
  802f72:	e8 cb d5 ff ff       	call   800542 <_panic>
		sys_yield();
  802f77:	e8 ee e1 ff ff       	call   80116a <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802f7c:	8b 43 48             	mov    0x48(%ebx),%eax
  802f7f:	39 f0                	cmp    %esi,%eax
  802f81:	75 07                	jne    802f8a <wait+0x48>
  802f83:	8b 43 54             	mov    0x54(%ebx),%eax
  802f86:	85 c0                	test   %eax,%eax
  802f88:	75 ed                	jne    802f77 <wait+0x35>
}
  802f8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f8d:	5b                   	pop    %ebx
  802f8e:	5e                   	pop    %esi
  802f8f:	5d                   	pop    %ebp
  802f90:	c3                   	ret    

00802f91 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802f91:	55                   	push   %ebp
  802f92:	89 e5                	mov    %esp,%ebp
  802f94:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802f97:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802f9e:	74 0a                	je     802faa <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa3:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802fa8:	c9                   	leave  
  802fa9:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802faa:	83 ec 04             	sub    $0x4,%esp
  802fad:	6a 07                	push   $0x7
  802faf:	68 00 f0 bf ee       	push   $0xeebff000
  802fb4:	6a 00                	push   $0x0
  802fb6:	e8 ce e1 ff ff       	call   801189 <sys_page_alloc>
		if(r < 0)
  802fbb:	83 c4 10             	add    $0x10,%esp
  802fbe:	85 c0                	test   %eax,%eax
  802fc0:	78 2a                	js     802fec <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802fc2:	83 ec 08             	sub    $0x8,%esp
  802fc5:	68 00 30 80 00       	push   $0x803000
  802fca:	6a 00                	push   $0x0
  802fcc:	e8 03 e3 ff ff       	call   8012d4 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802fd1:	83 c4 10             	add    $0x10,%esp
  802fd4:	85 c0                	test   %eax,%eax
  802fd6:	79 c8                	jns    802fa0 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802fd8:	83 ec 04             	sub    $0x4,%esp
  802fdb:	68 40 3c 80 00       	push   $0x803c40
  802fe0:	6a 25                	push   $0x25
  802fe2:	68 7c 3c 80 00       	push   $0x803c7c
  802fe7:	e8 56 d5 ff ff       	call   800542 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802fec:	83 ec 04             	sub    $0x4,%esp
  802fef:	68 10 3c 80 00       	push   $0x803c10
  802ff4:	6a 22                	push   $0x22
  802ff6:	68 7c 3c 80 00       	push   $0x803c7c
  802ffb:	e8 42 d5 ff ff       	call   800542 <_panic>

00803000 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  803000:	54                   	push   %esp
	movl _pgfault_handler, %eax
  803001:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  803006:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  803008:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  80300b:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  80300f:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  803013:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  803016:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  803018:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  80301c:	83 c4 08             	add    $0x8,%esp
	popal
  80301f:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  803020:	83 c4 04             	add    $0x4,%esp
	popfl
  803023:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  803024:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  803025:	c3                   	ret    

00803026 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803026:	55                   	push   %ebp
  803027:	89 e5                	mov    %esp,%ebp
  803029:	56                   	push   %esi
  80302a:	53                   	push   %ebx
  80302b:	8b 75 08             	mov    0x8(%ebp),%esi
  80302e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803031:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  803034:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  803036:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80303b:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80303e:	83 ec 0c             	sub    $0xc,%esp
  803041:	50                   	push   %eax
  803042:	e8 f2 e2 ff ff       	call   801339 <sys_ipc_recv>
	if(ret < 0){
  803047:	83 c4 10             	add    $0x10,%esp
  80304a:	85 c0                	test   %eax,%eax
  80304c:	78 2b                	js     803079 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80304e:	85 f6                	test   %esi,%esi
  803050:	74 0a                	je     80305c <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  803052:	a1 08 50 80 00       	mov    0x805008,%eax
  803057:	8b 40 74             	mov    0x74(%eax),%eax
  80305a:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80305c:	85 db                	test   %ebx,%ebx
  80305e:	74 0a                	je     80306a <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  803060:	a1 08 50 80 00       	mov    0x805008,%eax
  803065:	8b 40 78             	mov    0x78(%eax),%eax
  803068:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  80306a:	a1 08 50 80 00       	mov    0x805008,%eax
  80306f:	8b 40 70             	mov    0x70(%eax),%eax
}
  803072:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803075:	5b                   	pop    %ebx
  803076:	5e                   	pop    %esi
  803077:	5d                   	pop    %ebp
  803078:	c3                   	ret    
		if(from_env_store)
  803079:	85 f6                	test   %esi,%esi
  80307b:	74 06                	je     803083 <ipc_recv+0x5d>
			*from_env_store = 0;
  80307d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  803083:	85 db                	test   %ebx,%ebx
  803085:	74 eb                	je     803072 <ipc_recv+0x4c>
			*perm_store = 0;
  803087:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80308d:	eb e3                	jmp    803072 <ipc_recv+0x4c>

0080308f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80308f:	55                   	push   %ebp
  803090:	89 e5                	mov    %esp,%ebp
  803092:	57                   	push   %edi
  803093:	56                   	push   %esi
  803094:	53                   	push   %ebx
  803095:	83 ec 0c             	sub    $0xc,%esp
  803098:	8b 7d 08             	mov    0x8(%ebp),%edi
  80309b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80309e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8030a1:	85 db                	test   %ebx,%ebx
  8030a3:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8030a8:	0f 44 d8             	cmove  %eax,%ebx
  8030ab:	eb 05                	jmp    8030b2 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8030ad:	e8 b8 e0 ff ff       	call   80116a <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8030b2:	ff 75 14             	pushl  0x14(%ebp)
  8030b5:	53                   	push   %ebx
  8030b6:	56                   	push   %esi
  8030b7:	57                   	push   %edi
  8030b8:	e8 59 e2 ff ff       	call   801316 <sys_ipc_try_send>
  8030bd:	83 c4 10             	add    $0x10,%esp
  8030c0:	85 c0                	test   %eax,%eax
  8030c2:	74 1b                	je     8030df <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8030c4:	79 e7                	jns    8030ad <ipc_send+0x1e>
  8030c6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8030c9:	74 e2                	je     8030ad <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8030cb:	83 ec 04             	sub    $0x4,%esp
  8030ce:	68 8a 3c 80 00       	push   $0x803c8a
  8030d3:	6a 48                	push   $0x48
  8030d5:	68 9f 3c 80 00       	push   $0x803c9f
  8030da:	e8 63 d4 ff ff       	call   800542 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8030df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8030e2:	5b                   	pop    %ebx
  8030e3:	5e                   	pop    %esi
  8030e4:	5f                   	pop    %edi
  8030e5:	5d                   	pop    %ebp
  8030e6:	c3                   	ret    

008030e7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8030e7:	55                   	push   %ebp
  8030e8:	89 e5                	mov    %esp,%ebp
  8030ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8030ed:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8030f2:	89 c2                	mov    %eax,%edx
  8030f4:	c1 e2 07             	shl    $0x7,%edx
  8030f7:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8030fd:	8b 52 50             	mov    0x50(%edx),%edx
  803100:	39 ca                	cmp    %ecx,%edx
  803102:	74 11                	je     803115 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  803104:	83 c0 01             	add    $0x1,%eax
  803107:	3d 00 04 00 00       	cmp    $0x400,%eax
  80310c:	75 e4                	jne    8030f2 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80310e:	b8 00 00 00 00       	mov    $0x0,%eax
  803113:	eb 0b                	jmp    803120 <ipc_find_env+0x39>
			return envs[i].env_id;
  803115:	c1 e0 07             	shl    $0x7,%eax
  803118:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80311d:	8b 40 48             	mov    0x48(%eax),%eax
}
  803120:	5d                   	pop    %ebp
  803121:	c3                   	ret    

00803122 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803122:	55                   	push   %ebp
  803123:	89 e5                	mov    %esp,%ebp
  803125:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803128:	89 d0                	mov    %edx,%eax
  80312a:	c1 e8 16             	shr    $0x16,%eax
  80312d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  803134:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  803139:	f6 c1 01             	test   $0x1,%cl
  80313c:	74 1d                	je     80315b <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80313e:	c1 ea 0c             	shr    $0xc,%edx
  803141:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803148:	f6 c2 01             	test   $0x1,%dl
  80314b:	74 0e                	je     80315b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80314d:	c1 ea 0c             	shr    $0xc,%edx
  803150:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  803157:	ef 
  803158:	0f b7 c0             	movzwl %ax,%eax
}
  80315b:	5d                   	pop    %ebp
  80315c:	c3                   	ret    
  80315d:	66 90                	xchg   %ax,%ax
  80315f:	90                   	nop

00803160 <__udivdi3>:
  803160:	55                   	push   %ebp
  803161:	57                   	push   %edi
  803162:	56                   	push   %esi
  803163:	53                   	push   %ebx
  803164:	83 ec 1c             	sub    $0x1c,%esp
  803167:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80316b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80316f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803173:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  803177:	85 d2                	test   %edx,%edx
  803179:	75 4d                	jne    8031c8 <__udivdi3+0x68>
  80317b:	39 f3                	cmp    %esi,%ebx
  80317d:	76 19                	jbe    803198 <__udivdi3+0x38>
  80317f:	31 ff                	xor    %edi,%edi
  803181:	89 e8                	mov    %ebp,%eax
  803183:	89 f2                	mov    %esi,%edx
  803185:	f7 f3                	div    %ebx
  803187:	89 fa                	mov    %edi,%edx
  803189:	83 c4 1c             	add    $0x1c,%esp
  80318c:	5b                   	pop    %ebx
  80318d:	5e                   	pop    %esi
  80318e:	5f                   	pop    %edi
  80318f:	5d                   	pop    %ebp
  803190:	c3                   	ret    
  803191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803198:	89 d9                	mov    %ebx,%ecx
  80319a:	85 db                	test   %ebx,%ebx
  80319c:	75 0b                	jne    8031a9 <__udivdi3+0x49>
  80319e:	b8 01 00 00 00       	mov    $0x1,%eax
  8031a3:	31 d2                	xor    %edx,%edx
  8031a5:	f7 f3                	div    %ebx
  8031a7:	89 c1                	mov    %eax,%ecx
  8031a9:	31 d2                	xor    %edx,%edx
  8031ab:	89 f0                	mov    %esi,%eax
  8031ad:	f7 f1                	div    %ecx
  8031af:	89 c6                	mov    %eax,%esi
  8031b1:	89 e8                	mov    %ebp,%eax
  8031b3:	89 f7                	mov    %esi,%edi
  8031b5:	f7 f1                	div    %ecx
  8031b7:	89 fa                	mov    %edi,%edx
  8031b9:	83 c4 1c             	add    $0x1c,%esp
  8031bc:	5b                   	pop    %ebx
  8031bd:	5e                   	pop    %esi
  8031be:	5f                   	pop    %edi
  8031bf:	5d                   	pop    %ebp
  8031c0:	c3                   	ret    
  8031c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8031c8:	39 f2                	cmp    %esi,%edx
  8031ca:	77 1c                	ja     8031e8 <__udivdi3+0x88>
  8031cc:	0f bd fa             	bsr    %edx,%edi
  8031cf:	83 f7 1f             	xor    $0x1f,%edi
  8031d2:	75 2c                	jne    803200 <__udivdi3+0xa0>
  8031d4:	39 f2                	cmp    %esi,%edx
  8031d6:	72 06                	jb     8031de <__udivdi3+0x7e>
  8031d8:	31 c0                	xor    %eax,%eax
  8031da:	39 eb                	cmp    %ebp,%ebx
  8031dc:	77 a9                	ja     803187 <__udivdi3+0x27>
  8031de:	b8 01 00 00 00       	mov    $0x1,%eax
  8031e3:	eb a2                	jmp    803187 <__udivdi3+0x27>
  8031e5:	8d 76 00             	lea    0x0(%esi),%esi
  8031e8:	31 ff                	xor    %edi,%edi
  8031ea:	31 c0                	xor    %eax,%eax
  8031ec:	89 fa                	mov    %edi,%edx
  8031ee:	83 c4 1c             	add    $0x1c,%esp
  8031f1:	5b                   	pop    %ebx
  8031f2:	5e                   	pop    %esi
  8031f3:	5f                   	pop    %edi
  8031f4:	5d                   	pop    %ebp
  8031f5:	c3                   	ret    
  8031f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8031fd:	8d 76 00             	lea    0x0(%esi),%esi
  803200:	89 f9                	mov    %edi,%ecx
  803202:	b8 20 00 00 00       	mov    $0x20,%eax
  803207:	29 f8                	sub    %edi,%eax
  803209:	d3 e2                	shl    %cl,%edx
  80320b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80320f:	89 c1                	mov    %eax,%ecx
  803211:	89 da                	mov    %ebx,%edx
  803213:	d3 ea                	shr    %cl,%edx
  803215:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803219:	09 d1                	or     %edx,%ecx
  80321b:	89 f2                	mov    %esi,%edx
  80321d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803221:	89 f9                	mov    %edi,%ecx
  803223:	d3 e3                	shl    %cl,%ebx
  803225:	89 c1                	mov    %eax,%ecx
  803227:	d3 ea                	shr    %cl,%edx
  803229:	89 f9                	mov    %edi,%ecx
  80322b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80322f:	89 eb                	mov    %ebp,%ebx
  803231:	d3 e6                	shl    %cl,%esi
  803233:	89 c1                	mov    %eax,%ecx
  803235:	d3 eb                	shr    %cl,%ebx
  803237:	09 de                	or     %ebx,%esi
  803239:	89 f0                	mov    %esi,%eax
  80323b:	f7 74 24 08          	divl   0x8(%esp)
  80323f:	89 d6                	mov    %edx,%esi
  803241:	89 c3                	mov    %eax,%ebx
  803243:	f7 64 24 0c          	mull   0xc(%esp)
  803247:	39 d6                	cmp    %edx,%esi
  803249:	72 15                	jb     803260 <__udivdi3+0x100>
  80324b:	89 f9                	mov    %edi,%ecx
  80324d:	d3 e5                	shl    %cl,%ebp
  80324f:	39 c5                	cmp    %eax,%ebp
  803251:	73 04                	jae    803257 <__udivdi3+0xf7>
  803253:	39 d6                	cmp    %edx,%esi
  803255:	74 09                	je     803260 <__udivdi3+0x100>
  803257:	89 d8                	mov    %ebx,%eax
  803259:	31 ff                	xor    %edi,%edi
  80325b:	e9 27 ff ff ff       	jmp    803187 <__udivdi3+0x27>
  803260:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803263:	31 ff                	xor    %edi,%edi
  803265:	e9 1d ff ff ff       	jmp    803187 <__udivdi3+0x27>
  80326a:	66 90                	xchg   %ax,%ax
  80326c:	66 90                	xchg   %ax,%ax
  80326e:	66 90                	xchg   %ax,%ax

00803270 <__umoddi3>:
  803270:	55                   	push   %ebp
  803271:	57                   	push   %edi
  803272:	56                   	push   %esi
  803273:	53                   	push   %ebx
  803274:	83 ec 1c             	sub    $0x1c,%esp
  803277:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80327b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80327f:	8b 74 24 30          	mov    0x30(%esp),%esi
  803283:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803287:	89 da                	mov    %ebx,%edx
  803289:	85 c0                	test   %eax,%eax
  80328b:	75 43                	jne    8032d0 <__umoddi3+0x60>
  80328d:	39 df                	cmp    %ebx,%edi
  80328f:	76 17                	jbe    8032a8 <__umoddi3+0x38>
  803291:	89 f0                	mov    %esi,%eax
  803293:	f7 f7                	div    %edi
  803295:	89 d0                	mov    %edx,%eax
  803297:	31 d2                	xor    %edx,%edx
  803299:	83 c4 1c             	add    $0x1c,%esp
  80329c:	5b                   	pop    %ebx
  80329d:	5e                   	pop    %esi
  80329e:	5f                   	pop    %edi
  80329f:	5d                   	pop    %ebp
  8032a0:	c3                   	ret    
  8032a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8032a8:	89 fd                	mov    %edi,%ebp
  8032aa:	85 ff                	test   %edi,%edi
  8032ac:	75 0b                	jne    8032b9 <__umoddi3+0x49>
  8032ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8032b3:	31 d2                	xor    %edx,%edx
  8032b5:	f7 f7                	div    %edi
  8032b7:	89 c5                	mov    %eax,%ebp
  8032b9:	89 d8                	mov    %ebx,%eax
  8032bb:	31 d2                	xor    %edx,%edx
  8032bd:	f7 f5                	div    %ebp
  8032bf:	89 f0                	mov    %esi,%eax
  8032c1:	f7 f5                	div    %ebp
  8032c3:	89 d0                	mov    %edx,%eax
  8032c5:	eb d0                	jmp    803297 <__umoddi3+0x27>
  8032c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8032ce:	66 90                	xchg   %ax,%ax
  8032d0:	89 f1                	mov    %esi,%ecx
  8032d2:	39 d8                	cmp    %ebx,%eax
  8032d4:	76 0a                	jbe    8032e0 <__umoddi3+0x70>
  8032d6:	89 f0                	mov    %esi,%eax
  8032d8:	83 c4 1c             	add    $0x1c,%esp
  8032db:	5b                   	pop    %ebx
  8032dc:	5e                   	pop    %esi
  8032dd:	5f                   	pop    %edi
  8032de:	5d                   	pop    %ebp
  8032df:	c3                   	ret    
  8032e0:	0f bd e8             	bsr    %eax,%ebp
  8032e3:	83 f5 1f             	xor    $0x1f,%ebp
  8032e6:	75 20                	jne    803308 <__umoddi3+0x98>
  8032e8:	39 d8                	cmp    %ebx,%eax
  8032ea:	0f 82 b0 00 00 00    	jb     8033a0 <__umoddi3+0x130>
  8032f0:	39 f7                	cmp    %esi,%edi
  8032f2:	0f 86 a8 00 00 00    	jbe    8033a0 <__umoddi3+0x130>
  8032f8:	89 c8                	mov    %ecx,%eax
  8032fa:	83 c4 1c             	add    $0x1c,%esp
  8032fd:	5b                   	pop    %ebx
  8032fe:	5e                   	pop    %esi
  8032ff:	5f                   	pop    %edi
  803300:	5d                   	pop    %ebp
  803301:	c3                   	ret    
  803302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803308:	89 e9                	mov    %ebp,%ecx
  80330a:	ba 20 00 00 00       	mov    $0x20,%edx
  80330f:	29 ea                	sub    %ebp,%edx
  803311:	d3 e0                	shl    %cl,%eax
  803313:	89 44 24 08          	mov    %eax,0x8(%esp)
  803317:	89 d1                	mov    %edx,%ecx
  803319:	89 f8                	mov    %edi,%eax
  80331b:	d3 e8                	shr    %cl,%eax
  80331d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803321:	89 54 24 04          	mov    %edx,0x4(%esp)
  803325:	8b 54 24 04          	mov    0x4(%esp),%edx
  803329:	09 c1                	or     %eax,%ecx
  80332b:	89 d8                	mov    %ebx,%eax
  80332d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803331:	89 e9                	mov    %ebp,%ecx
  803333:	d3 e7                	shl    %cl,%edi
  803335:	89 d1                	mov    %edx,%ecx
  803337:	d3 e8                	shr    %cl,%eax
  803339:	89 e9                	mov    %ebp,%ecx
  80333b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80333f:	d3 e3                	shl    %cl,%ebx
  803341:	89 c7                	mov    %eax,%edi
  803343:	89 d1                	mov    %edx,%ecx
  803345:	89 f0                	mov    %esi,%eax
  803347:	d3 e8                	shr    %cl,%eax
  803349:	89 e9                	mov    %ebp,%ecx
  80334b:	89 fa                	mov    %edi,%edx
  80334d:	d3 e6                	shl    %cl,%esi
  80334f:	09 d8                	or     %ebx,%eax
  803351:	f7 74 24 08          	divl   0x8(%esp)
  803355:	89 d1                	mov    %edx,%ecx
  803357:	89 f3                	mov    %esi,%ebx
  803359:	f7 64 24 0c          	mull   0xc(%esp)
  80335d:	89 c6                	mov    %eax,%esi
  80335f:	89 d7                	mov    %edx,%edi
  803361:	39 d1                	cmp    %edx,%ecx
  803363:	72 06                	jb     80336b <__umoddi3+0xfb>
  803365:	75 10                	jne    803377 <__umoddi3+0x107>
  803367:	39 c3                	cmp    %eax,%ebx
  803369:	73 0c                	jae    803377 <__umoddi3+0x107>
  80336b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80336f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  803373:	89 d7                	mov    %edx,%edi
  803375:	89 c6                	mov    %eax,%esi
  803377:	89 ca                	mov    %ecx,%edx
  803379:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80337e:	29 f3                	sub    %esi,%ebx
  803380:	19 fa                	sbb    %edi,%edx
  803382:	89 d0                	mov    %edx,%eax
  803384:	d3 e0                	shl    %cl,%eax
  803386:	89 e9                	mov    %ebp,%ecx
  803388:	d3 eb                	shr    %cl,%ebx
  80338a:	d3 ea                	shr    %cl,%edx
  80338c:	09 d8                	or     %ebx,%eax
  80338e:	83 c4 1c             	add    $0x1c,%esp
  803391:	5b                   	pop    %ebx
  803392:	5e                   	pop    %esi
  803393:	5f                   	pop    %edi
  803394:	5d                   	pop    %ebp
  803395:	c3                   	ret    
  803396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80339d:	8d 76 00             	lea    0x0(%esi),%esi
  8033a0:	89 da                	mov    %ebx,%edx
  8033a2:	29 fe                	sub    %edi,%esi
  8033a4:	19 c2                	sbb    %eax,%edx
  8033a6:	89 f1                	mov    %esi,%ecx
  8033a8:	89 c8                	mov    %ecx,%eax
  8033aa:	e9 4b ff ff ff       	jmp    8032fa <__umoddi3+0x8a>
