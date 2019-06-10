
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
  80004a:	e8 9e 1d 00 00       	call   801ded <seek>
	seek(kfd, off);
  80004f:	83 c4 08             	add    $0x8,%esp
  800052:	53                   	push   %ebx
  800053:	57                   	push   %edi
  800054:	e8 94 1d 00 00       	call   801ded <seek>

	cprintf("shell produced incorrect output.\n");
  800059:	c7 04 24 20 34 80 00 	movl   $0x803420,(%esp)
  800060:	e8 24 06 00 00       	call   800689 <cprintf>
	cprintf("expected:\n===\n");
  800065:	c7 04 24 8b 34 80 00 	movl   $0x80348b,(%esp)
  80006c:	e8 18 06 00 00       	call   800689 <cprintf>
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800071:	83 c4 10             	add    $0x10,%esp
  800074:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  800077:	83 ec 04             	sub    $0x4,%esp
  80007a:	6a 63                	push   $0x63
  80007c:	53                   	push   %ebx
  80007d:	57                   	push   %edi
  80007e:	e8 1c 1c 00 00       	call   801c9f <read>
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
  80009c:	68 9a 34 80 00       	push   $0x80349a
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
  8000c2:	e8 d8 1b 00 00       	call   801c9f <read>
  8000c7:	83 c4 10             	add    $0x10,%esp
  8000ca:	85 c0                	test   %eax,%eax
  8000cc:	7f e0                	jg     8000ae <wrong+0x7b>
	cprintf("===\n");
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	68 95 34 80 00       	push   $0x803495
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
  8000f6:	e8 66 1a 00 00       	call   801b61 <close>
	close(1);
  8000fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800102:	e8 5a 1a 00 00       	call   801b61 <close>
	opencons();
  800107:	e8 28 03 00 00       	call   800434 <opencons>
	opencons();
  80010c:	e8 23 03 00 00       	call   800434 <opencons>
	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  800111:	83 c4 08             	add    $0x8,%esp
  800114:	6a 00                	push   $0x0
  800116:	68 a8 34 80 00       	push   $0x8034a8
  80011b:	e8 1d 20 00 00       	call   80213d <open>
  800120:	89 c3                	mov    %eax,%ebx
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	85 c0                	test   %eax,%eax
  800127:	0f 88 e7 00 00 00    	js     800214 <umain+0x129>
	if ((wfd = pipe(pfds)) < 0)
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800133:	50                   	push   %eax
  800134:	e8 fd 2c 00 00       	call   802e36 <pipe>
  800139:	83 c4 10             	add    $0x10,%esp
  80013c:	85 c0                	test   %eax,%eax
  80013e:	0f 88 e2 00 00 00    	js     800226 <umain+0x13b>
	wfd = pfds[1];
  800144:	8b 75 e0             	mov    -0x20(%ebp),%esi
	cprintf("running sh -x < testshell.sh | cat\n");
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	68 44 34 80 00       	push   $0x803444
  80014f:	e8 35 05 00 00       	call   800689 <cprintf>
	if ((r = fork()) < 0)
  800154:	e8 cb 15 00 00       	call   801724 <fork>
  800159:	83 c4 10             	add    $0x10,%esp
  80015c:	85 c0                	test   %eax,%eax
  80015e:	0f 88 d4 00 00 00    	js     800238 <umain+0x14d>
	if (r == 0) {
  800164:	75 6f                	jne    8001d5 <umain+0xea>
		dup(rfd, 0);
  800166:	83 ec 08             	sub    $0x8,%esp
  800169:	6a 00                	push   $0x0
  80016b:	53                   	push   %ebx
  80016c:	e8 42 1a 00 00       	call   801bb3 <dup>
		dup(wfd, 1);
  800171:	83 c4 08             	add    $0x8,%esp
  800174:	6a 01                	push   $0x1
  800176:	56                   	push   %esi
  800177:	e8 37 1a 00 00       	call   801bb3 <dup>
		close(rfd);
  80017c:	89 1c 24             	mov    %ebx,(%esp)
  80017f:	e8 dd 19 00 00       	call   801b61 <close>
		close(wfd);
  800184:	89 34 24             	mov    %esi,(%esp)
  800187:	e8 d5 19 00 00       	call   801b61 <close>
		if ((r = spawnl("/sh", "sh", "-x", 0)) < 0)
  80018c:	6a 00                	push   $0x0
  80018e:	68 ee 34 80 00       	push   $0x8034ee
  800193:	68 b2 34 80 00       	push   $0x8034b2
  800198:	68 f1 34 80 00       	push   $0x8034f1
  80019d:	e8 cd 25 00 00       	call   80276f <spawnl>
  8001a2:	89 c7                	mov    %eax,%edi
  8001a4:	83 c4 20             	add    $0x20,%esp
  8001a7:	85 c0                	test   %eax,%eax
  8001a9:	0f 88 9b 00 00 00    	js     80024a <umain+0x15f>
		close(0);
  8001af:	83 ec 0c             	sub    $0xc,%esp
  8001b2:	6a 00                	push   $0x0
  8001b4:	e8 a8 19 00 00       	call   801b61 <close>
		close(1);
  8001b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001c0:	e8 9c 19 00 00       	call   801b61 <close>
		wait(r);
  8001c5:	89 3c 24             	mov    %edi,(%esp)
  8001c8:	e8 e6 2d 00 00       	call   802fb3 <wait>
		exit();
  8001cd:	e8 8d 03 00 00       	call   80055f <exit>
  8001d2:	83 c4 10             	add    $0x10,%esp
	close(rfd);
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	53                   	push   %ebx
  8001d9:	e8 83 19 00 00       	call   801b61 <close>
	close(wfd);
  8001de:	89 34 24             	mov    %esi,(%esp)
  8001e1:	e8 7b 19 00 00       	call   801b61 <close>
	rfd = pfds[0];
  8001e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001e9:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8001ec:	83 c4 08             	add    $0x8,%esp
  8001ef:	6a 00                	push   $0x0
  8001f1:	68 ff 34 80 00       	push   $0x8034ff
  8001f6:	e8 42 1f 00 00       	call   80213d <open>
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
  800215:	68 b5 34 80 00       	push   $0x8034b5
  80021a:	6a 13                	push   $0x13
  80021c:	68 cb 34 80 00       	push   $0x8034cb
  800221:	e8 6d 03 00 00       	call   800593 <_panic>
		panic("pipe: %e", wfd);
  800226:	50                   	push   %eax
  800227:	68 dc 34 80 00       	push   $0x8034dc
  80022c:	6a 15                	push   $0x15
  80022e:	68 cb 34 80 00       	push   $0x8034cb
  800233:	e8 5b 03 00 00       	call   800593 <_panic>
		panic("fork: %e", r);
  800238:	50                   	push   %eax
  800239:	68 e5 34 80 00       	push   $0x8034e5
  80023e:	6a 1a                	push   $0x1a
  800240:	68 cb 34 80 00       	push   $0x8034cb
  800245:	e8 49 03 00 00       	call   800593 <_panic>
			panic("spawn: %e", r);
  80024a:	50                   	push   %eax
  80024b:	68 f5 34 80 00       	push   $0x8034f5
  800250:	6a 21                	push   $0x21
  800252:	68 cb 34 80 00       	push   $0x8034cb
  800257:	e8 37 03 00 00       	call   800593 <_panic>
		panic("open testshell.key for reading: %e", kfd);
  80025c:	50                   	push   %eax
  80025d:	68 68 34 80 00       	push   $0x803468
  800262:	6a 2c                	push   $0x2c
  800264:	68 cb 34 80 00       	push   $0x8034cb
  800269:	e8 25 03 00 00       	call   800593 <_panic>
			panic("reading testshell.out: %e", n1);
  80026e:	53                   	push   %ebx
  80026f:	68 0d 35 80 00       	push   $0x80350d
  800274:	6a 33                	push   $0x33
  800276:	68 cb 34 80 00       	push   $0x8034cb
  80027b:	e8 13 03 00 00       	call   800593 <_panic>
			panic("reading testshell.key: %e", n2);
  800280:	50                   	push   %eax
  800281:	68 27 35 80 00       	push   $0x803527
  800286:	6a 35                	push   $0x35
  800288:	68 cb 34 80 00       	push   $0x8034cb
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
  8002ba:	e8 e0 19 00 00       	call   801c9f <read>
  8002bf:	89 c3                	mov    %eax,%ebx
		n2 = read(kfd, &c2, 1);
  8002c1:	83 c4 0c             	add    $0xc,%esp
  8002c4:	6a 01                	push   $0x1
  8002c6:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  8002c9:	50                   	push   %eax
  8002ca:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002cd:	e8 cd 19 00 00       	call   801c9f <read>
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
  8002fb:	68 41 35 80 00       	push   $0x803541
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
  80031d:	68 56 35 80 00       	push   $0x803556
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
  8003ed:	e8 ad 18 00 00       	call   801c9f <read>
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
  800415:	e8 15 16 00 00       	call   801a2f <fd_lookup>
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
  80043e:	e8 9a 15 00 00       	call   8019dd <fd_alloc>
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
  80047c:	e8 35 15 00 00       	call   8019b6 <fd2num>
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
  800509:	68 62 35 80 00       	push   $0x803562
  80050e:	e8 76 01 00 00       	call   800689 <cprintf>
	cprintf("before umain\n");
  800513:	c7 04 24 80 35 80 00 	movl   $0x803580,(%esp)
  80051a:	e8 6a 01 00 00       	call   800689 <cprintf>
	// call user main routine
	umain(argc, argv);
  80051f:	83 c4 08             	add    $0x8,%esp
  800522:	ff 75 0c             	pushl  0xc(%ebp)
  800525:	ff 75 08             	pushl  0x8(%ebp)
  800528:	e8 be fb ff ff       	call   8000eb <umain>
	cprintf("after umain\n");
  80052d:	c7 04 24 8e 35 80 00 	movl   $0x80358e,(%esp)
  800534:	e8 50 01 00 00       	call   800689 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800539:	a1 08 50 80 00       	mov    0x805008,%eax
  80053e:	8b 40 48             	mov    0x48(%eax),%eax
  800541:	83 c4 08             	add    $0x8,%esp
  800544:	50                   	push   %eax
  800545:	68 9b 35 80 00       	push   $0x80359b
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
  80056d:	68 c8 35 80 00       	push   $0x8035c8
  800572:	50                   	push   %eax
  800573:	68 ba 35 80 00       	push   $0x8035ba
  800578:	e8 0c 01 00 00       	call   800689 <cprintf>
	close_all();
  80057d:	e8 0c 16 00 00       	call   801b8e <close_all>
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
  8005a3:	68 f4 35 80 00       	push   $0x8035f4
  8005a8:	50                   	push   %eax
  8005a9:	68 ba 35 80 00       	push   $0x8035ba
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
  8005cc:	68 d0 35 80 00       	push   $0x8035d0
  8005d1:	e8 b3 00 00 00       	call   800689 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005d6:	83 c4 18             	add    $0x18,%esp
  8005d9:	53                   	push   %ebx
  8005da:	ff 75 10             	pushl  0x10(%ebp)
  8005dd:	e8 56 00 00 00       	call   800638 <vcprintf>
	cprintf("\n");
  8005e2:	c7 04 24 7e 35 80 00 	movl   $0x80357e,(%esp)
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
  800736:	e8 95 2a 00 00       	call   8031d0 <__udivdi3>
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
  80075f:	e8 7c 2b 00 00       	call   8032e0 <__umoddi3>
  800764:	83 c4 14             	add    $0x14,%esp
  800767:	0f be 80 fb 35 80 00 	movsbl 0x8035fb(%eax),%eax
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
  800810:	ff 24 85 e0 37 80 00 	jmp    *0x8037e0(,%eax,4)
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
  8008db:	8b 14 85 40 39 80 00 	mov    0x803940(,%eax,4),%edx
  8008e2:	85 d2                	test   %edx,%edx
  8008e4:	74 18                	je     8008fe <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8008e6:	52                   	push   %edx
  8008e7:	68 4d 3b 80 00       	push   $0x803b4d
  8008ec:	53                   	push   %ebx
  8008ed:	56                   	push   %esi
  8008ee:	e8 a6 fe ff ff       	call   800799 <printfmt>
  8008f3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8008f6:	89 7d 14             	mov    %edi,0x14(%ebp)
  8008f9:	e9 fe 02 00 00       	jmp    800bfc <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8008fe:	50                   	push   %eax
  8008ff:	68 13 36 80 00       	push   $0x803613
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
  800926:	b8 0c 36 80 00       	mov    $0x80360c,%eax
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
  800cbe:	bf 31 37 80 00       	mov    $0x803731,%edi
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
  800cea:	bf 69 37 80 00       	mov    $0x803769,%edi
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
  80118b:	68 88 39 80 00       	push   $0x803988
  801190:	6a 43                	push   $0x43
  801192:	68 a5 39 80 00       	push   $0x8039a5
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
  80120c:	68 88 39 80 00       	push   $0x803988
  801211:	6a 43                	push   $0x43
  801213:	68 a5 39 80 00       	push   $0x8039a5
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
  80124e:	68 88 39 80 00       	push   $0x803988
  801253:	6a 43                	push   $0x43
  801255:	68 a5 39 80 00       	push   $0x8039a5
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
  801290:	68 88 39 80 00       	push   $0x803988
  801295:	6a 43                	push   $0x43
  801297:	68 a5 39 80 00       	push   $0x8039a5
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
  8012d2:	68 88 39 80 00       	push   $0x803988
  8012d7:	6a 43                	push   $0x43
  8012d9:	68 a5 39 80 00       	push   $0x8039a5
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
  801314:	68 88 39 80 00       	push   $0x803988
  801319:	6a 43                	push   $0x43
  80131b:	68 a5 39 80 00       	push   $0x8039a5
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
  801356:	68 88 39 80 00       	push   $0x803988
  80135b:	6a 43                	push   $0x43
  80135d:	68 a5 39 80 00       	push   $0x8039a5
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
  8013ba:	68 88 39 80 00       	push   $0x803988
  8013bf:	6a 43                	push   $0x43
  8013c1:	68 a5 39 80 00       	push   $0x8039a5
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
  80149e:	68 88 39 80 00       	push   $0x803988
  8014a3:	6a 43                	push   $0x43
  8014a5:	68 a5 39 80 00       	push   $0x8039a5
  8014aa:	e8 e4 f0 ff ff       	call   800593 <_panic>

008014af <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8014af:	55                   	push   %ebp
  8014b0:	89 e5                	mov    %esp,%ebp
  8014b2:	57                   	push   %edi
  8014b3:	56                   	push   %esi
  8014b4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014b5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8014ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8014bd:	b8 14 00 00 00       	mov    $0x14,%eax
  8014c2:	89 cb                	mov    %ecx,%ebx
  8014c4:	89 cf                	mov    %ecx,%edi
  8014c6:	89 ce                	mov    %ecx,%esi
  8014c8:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  8014ca:	5b                   	pop    %ebx
  8014cb:	5e                   	pop    %esi
  8014cc:	5f                   	pop    %edi
  8014cd:	5d                   	pop    %ebp
  8014ce:	c3                   	ret    

008014cf <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
  8014d2:	53                   	push   %ebx
  8014d3:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  8014d6:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8014dd:	f6 c5 04             	test   $0x4,%ch
  8014e0:	75 45                	jne    801527 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8014e2:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8014e9:	83 e1 07             	and    $0x7,%ecx
  8014ec:	83 f9 07             	cmp    $0x7,%ecx
  8014ef:	74 6f                	je     801560 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8014f1:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8014f8:	81 e1 05 08 00 00    	and    $0x805,%ecx
  8014fe:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801504:	0f 84 b6 00 00 00    	je     8015c0 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  80150a:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801511:	83 e1 05             	and    $0x5,%ecx
  801514:	83 f9 05             	cmp    $0x5,%ecx
  801517:	0f 84 d7 00 00 00    	je     8015f4 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  80151d:	b8 00 00 00 00       	mov    $0x0,%eax
  801522:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801525:	c9                   	leave  
  801526:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801527:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80152e:	c1 e2 0c             	shl    $0xc,%edx
  801531:	83 ec 0c             	sub    $0xc,%esp
  801534:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80153a:	51                   	push   %ecx
  80153b:	52                   	push   %edx
  80153c:	50                   	push   %eax
  80153d:	52                   	push   %edx
  80153e:	6a 00                	push   $0x0
  801540:	e8 d8 fc ff ff       	call   80121d <sys_page_map>
		if(r < 0)
  801545:	83 c4 20             	add    $0x20,%esp
  801548:	85 c0                	test   %eax,%eax
  80154a:	79 d1                	jns    80151d <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80154c:	83 ec 04             	sub    $0x4,%esp
  80154f:	68 b3 39 80 00       	push   $0x8039b3
  801554:	6a 54                	push   $0x54
  801556:	68 c9 39 80 00       	push   $0x8039c9
  80155b:	e8 33 f0 ff ff       	call   800593 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801560:	89 d3                	mov    %edx,%ebx
  801562:	c1 e3 0c             	shl    $0xc,%ebx
  801565:	83 ec 0c             	sub    $0xc,%esp
  801568:	68 05 08 00 00       	push   $0x805
  80156d:	53                   	push   %ebx
  80156e:	50                   	push   %eax
  80156f:	53                   	push   %ebx
  801570:	6a 00                	push   $0x0
  801572:	e8 a6 fc ff ff       	call   80121d <sys_page_map>
		if(r < 0)
  801577:	83 c4 20             	add    $0x20,%esp
  80157a:	85 c0                	test   %eax,%eax
  80157c:	78 2e                	js     8015ac <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  80157e:	83 ec 0c             	sub    $0xc,%esp
  801581:	68 05 08 00 00       	push   $0x805
  801586:	53                   	push   %ebx
  801587:	6a 00                	push   $0x0
  801589:	53                   	push   %ebx
  80158a:	6a 00                	push   $0x0
  80158c:	e8 8c fc ff ff       	call   80121d <sys_page_map>
		if(r < 0)
  801591:	83 c4 20             	add    $0x20,%esp
  801594:	85 c0                	test   %eax,%eax
  801596:	79 85                	jns    80151d <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801598:	83 ec 04             	sub    $0x4,%esp
  80159b:	68 b3 39 80 00       	push   $0x8039b3
  8015a0:	6a 5f                	push   $0x5f
  8015a2:	68 c9 39 80 00       	push   $0x8039c9
  8015a7:	e8 e7 ef ff ff       	call   800593 <_panic>
			panic("sys_page_map() panic\n");
  8015ac:	83 ec 04             	sub    $0x4,%esp
  8015af:	68 b3 39 80 00       	push   $0x8039b3
  8015b4:	6a 5b                	push   $0x5b
  8015b6:	68 c9 39 80 00       	push   $0x8039c9
  8015bb:	e8 d3 ef ff ff       	call   800593 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8015c0:	c1 e2 0c             	shl    $0xc,%edx
  8015c3:	83 ec 0c             	sub    $0xc,%esp
  8015c6:	68 05 08 00 00       	push   $0x805
  8015cb:	52                   	push   %edx
  8015cc:	50                   	push   %eax
  8015cd:	52                   	push   %edx
  8015ce:	6a 00                	push   $0x0
  8015d0:	e8 48 fc ff ff       	call   80121d <sys_page_map>
		if(r < 0)
  8015d5:	83 c4 20             	add    $0x20,%esp
  8015d8:	85 c0                	test   %eax,%eax
  8015da:	0f 89 3d ff ff ff    	jns    80151d <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8015e0:	83 ec 04             	sub    $0x4,%esp
  8015e3:	68 b3 39 80 00       	push   $0x8039b3
  8015e8:	6a 66                	push   $0x66
  8015ea:	68 c9 39 80 00       	push   $0x8039c9
  8015ef:	e8 9f ef ff ff       	call   800593 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8015f4:	c1 e2 0c             	shl    $0xc,%edx
  8015f7:	83 ec 0c             	sub    $0xc,%esp
  8015fa:	6a 05                	push   $0x5
  8015fc:	52                   	push   %edx
  8015fd:	50                   	push   %eax
  8015fe:	52                   	push   %edx
  8015ff:	6a 00                	push   $0x0
  801601:	e8 17 fc ff ff       	call   80121d <sys_page_map>
		if(r < 0)
  801606:	83 c4 20             	add    $0x20,%esp
  801609:	85 c0                	test   %eax,%eax
  80160b:	0f 89 0c ff ff ff    	jns    80151d <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801611:	83 ec 04             	sub    $0x4,%esp
  801614:	68 b3 39 80 00       	push   $0x8039b3
  801619:	6a 6d                	push   $0x6d
  80161b:	68 c9 39 80 00       	push   $0x8039c9
  801620:	e8 6e ef ff ff       	call   800593 <_panic>

00801625 <pgfault>:
{
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
  801628:	53                   	push   %ebx
  801629:	83 ec 04             	sub    $0x4,%esp
  80162c:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80162f:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801631:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801635:	0f 84 99 00 00 00    	je     8016d4 <pgfault+0xaf>
  80163b:	89 c2                	mov    %eax,%edx
  80163d:	c1 ea 16             	shr    $0x16,%edx
  801640:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801647:	f6 c2 01             	test   $0x1,%dl
  80164a:	0f 84 84 00 00 00    	je     8016d4 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801650:	89 c2                	mov    %eax,%edx
  801652:	c1 ea 0c             	shr    $0xc,%edx
  801655:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80165c:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801662:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801668:	75 6a                	jne    8016d4 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  80166a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80166f:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801671:	83 ec 04             	sub    $0x4,%esp
  801674:	6a 07                	push   $0x7
  801676:	68 00 f0 7f 00       	push   $0x7ff000
  80167b:	6a 00                	push   $0x0
  80167d:	e8 58 fb ff ff       	call   8011da <sys_page_alloc>
	if(ret < 0)
  801682:	83 c4 10             	add    $0x10,%esp
  801685:	85 c0                	test   %eax,%eax
  801687:	78 5f                	js     8016e8 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801689:	83 ec 04             	sub    $0x4,%esp
  80168c:	68 00 10 00 00       	push   $0x1000
  801691:	53                   	push   %ebx
  801692:	68 00 f0 7f 00       	push   $0x7ff000
  801697:	e8 3c f9 ff ff       	call   800fd8 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  80169c:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8016a3:	53                   	push   %ebx
  8016a4:	6a 00                	push   $0x0
  8016a6:	68 00 f0 7f 00       	push   $0x7ff000
  8016ab:	6a 00                	push   $0x0
  8016ad:	e8 6b fb ff ff       	call   80121d <sys_page_map>
	if(ret < 0)
  8016b2:	83 c4 20             	add    $0x20,%esp
  8016b5:	85 c0                	test   %eax,%eax
  8016b7:	78 43                	js     8016fc <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8016b9:	83 ec 08             	sub    $0x8,%esp
  8016bc:	68 00 f0 7f 00       	push   $0x7ff000
  8016c1:	6a 00                	push   $0x0
  8016c3:	e8 97 fb ff ff       	call   80125f <sys_page_unmap>
	if(ret < 0)
  8016c8:	83 c4 10             	add    $0x10,%esp
  8016cb:	85 c0                	test   %eax,%eax
  8016cd:	78 41                	js     801710 <pgfault+0xeb>
}
  8016cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016d2:	c9                   	leave  
  8016d3:	c3                   	ret    
		panic("panic at pgfault()\n");
  8016d4:	83 ec 04             	sub    $0x4,%esp
  8016d7:	68 d4 39 80 00       	push   $0x8039d4
  8016dc:	6a 26                	push   $0x26
  8016de:	68 c9 39 80 00       	push   $0x8039c9
  8016e3:	e8 ab ee ff ff       	call   800593 <_panic>
		panic("panic in sys_page_alloc()\n");
  8016e8:	83 ec 04             	sub    $0x4,%esp
  8016eb:	68 e8 39 80 00       	push   $0x8039e8
  8016f0:	6a 31                	push   $0x31
  8016f2:	68 c9 39 80 00       	push   $0x8039c9
  8016f7:	e8 97 ee ff ff       	call   800593 <_panic>
		panic("panic in sys_page_map()\n");
  8016fc:	83 ec 04             	sub    $0x4,%esp
  8016ff:	68 03 3a 80 00       	push   $0x803a03
  801704:	6a 36                	push   $0x36
  801706:	68 c9 39 80 00       	push   $0x8039c9
  80170b:	e8 83 ee ff ff       	call   800593 <_panic>
		panic("panic in sys_page_unmap()\n");
  801710:	83 ec 04             	sub    $0x4,%esp
  801713:	68 1c 3a 80 00       	push   $0x803a1c
  801718:	6a 39                	push   $0x39
  80171a:	68 c9 39 80 00       	push   $0x8039c9
  80171f:	e8 6f ee ff ff       	call   800593 <_panic>

00801724 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
  801727:	57                   	push   %edi
  801728:	56                   	push   %esi
  801729:	53                   	push   %ebx
  80172a:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  80172d:	68 25 16 80 00       	push   $0x801625
  801732:	e8 cb 18 00 00       	call   803002 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801737:	b8 07 00 00 00       	mov    $0x7,%eax
  80173c:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80173e:	83 c4 10             	add    $0x10,%esp
  801741:	85 c0                	test   %eax,%eax
  801743:	78 27                	js     80176c <fork+0x48>
  801745:	89 c6                	mov    %eax,%esi
  801747:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801749:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80174e:	75 48                	jne    801798 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  801750:	e8 47 fa ff ff       	call   80119c <sys_getenvid>
  801755:	25 ff 03 00 00       	and    $0x3ff,%eax
  80175a:	c1 e0 07             	shl    $0x7,%eax
  80175d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801762:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801767:	e9 90 00 00 00       	jmp    8017fc <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  80176c:	83 ec 04             	sub    $0x4,%esp
  80176f:	68 38 3a 80 00       	push   $0x803a38
  801774:	68 8c 00 00 00       	push   $0x8c
  801779:	68 c9 39 80 00       	push   $0x8039c9
  80177e:	e8 10 ee ff ff       	call   800593 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801783:	89 f8                	mov    %edi,%eax
  801785:	e8 45 fd ff ff       	call   8014cf <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80178a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801790:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801796:	74 26                	je     8017be <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801798:	89 d8                	mov    %ebx,%eax
  80179a:	c1 e8 16             	shr    $0x16,%eax
  80179d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017a4:	a8 01                	test   $0x1,%al
  8017a6:	74 e2                	je     80178a <fork+0x66>
  8017a8:	89 da                	mov    %ebx,%edx
  8017aa:	c1 ea 0c             	shr    $0xc,%edx
  8017ad:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8017b4:	83 e0 05             	and    $0x5,%eax
  8017b7:	83 f8 05             	cmp    $0x5,%eax
  8017ba:	75 ce                	jne    80178a <fork+0x66>
  8017bc:	eb c5                	jmp    801783 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8017be:	83 ec 04             	sub    $0x4,%esp
  8017c1:	6a 07                	push   $0x7
  8017c3:	68 00 f0 bf ee       	push   $0xeebff000
  8017c8:	56                   	push   %esi
  8017c9:	e8 0c fa ff ff       	call   8011da <sys_page_alloc>
	if(ret < 0)
  8017ce:	83 c4 10             	add    $0x10,%esp
  8017d1:	85 c0                	test   %eax,%eax
  8017d3:	78 31                	js     801806 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8017d5:	83 ec 08             	sub    $0x8,%esp
  8017d8:	68 71 30 80 00       	push   $0x803071
  8017dd:	56                   	push   %esi
  8017de:	e8 42 fb ff ff       	call   801325 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8017e3:	83 c4 10             	add    $0x10,%esp
  8017e6:	85 c0                	test   %eax,%eax
  8017e8:	78 33                	js     80181d <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8017ea:	83 ec 08             	sub    $0x8,%esp
  8017ed:	6a 02                	push   $0x2
  8017ef:	56                   	push   %esi
  8017f0:	e8 ac fa ff ff       	call   8012a1 <sys_env_set_status>
	if(ret < 0)
  8017f5:	83 c4 10             	add    $0x10,%esp
  8017f8:	85 c0                	test   %eax,%eax
  8017fa:	78 38                	js     801834 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8017fc:	89 f0                	mov    %esi,%eax
  8017fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801801:	5b                   	pop    %ebx
  801802:	5e                   	pop    %esi
  801803:	5f                   	pop    %edi
  801804:	5d                   	pop    %ebp
  801805:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801806:	83 ec 04             	sub    $0x4,%esp
  801809:	68 e8 39 80 00       	push   $0x8039e8
  80180e:	68 98 00 00 00       	push   $0x98
  801813:	68 c9 39 80 00       	push   $0x8039c9
  801818:	e8 76 ed ff ff       	call   800593 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80181d:	83 ec 04             	sub    $0x4,%esp
  801820:	68 5c 3a 80 00       	push   $0x803a5c
  801825:	68 9b 00 00 00       	push   $0x9b
  80182a:	68 c9 39 80 00       	push   $0x8039c9
  80182f:	e8 5f ed ff ff       	call   800593 <_panic>
		panic("panic in sys_env_set_status()\n");
  801834:	83 ec 04             	sub    $0x4,%esp
  801837:	68 84 3a 80 00       	push   $0x803a84
  80183c:	68 9e 00 00 00       	push   $0x9e
  801841:	68 c9 39 80 00       	push   $0x8039c9
  801846:	e8 48 ed ff ff       	call   800593 <_panic>

0080184b <sfork>:

// Challenge!
int
sfork(void)
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
  80184e:	57                   	push   %edi
  80184f:	56                   	push   %esi
  801850:	53                   	push   %ebx
  801851:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801854:	68 25 16 80 00       	push   $0x801625
  801859:	e8 a4 17 00 00       	call   803002 <set_pgfault_handler>
  80185e:	b8 07 00 00 00       	mov    $0x7,%eax
  801863:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801865:	83 c4 10             	add    $0x10,%esp
  801868:	85 c0                	test   %eax,%eax
  80186a:	78 27                	js     801893 <sfork+0x48>
  80186c:	89 c7                	mov    %eax,%edi
  80186e:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801870:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801875:	75 55                	jne    8018cc <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801877:	e8 20 f9 ff ff       	call   80119c <sys_getenvid>
  80187c:	25 ff 03 00 00       	and    $0x3ff,%eax
  801881:	c1 e0 07             	shl    $0x7,%eax
  801884:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801889:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  80188e:	e9 d4 00 00 00       	jmp    801967 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  801893:	83 ec 04             	sub    $0x4,%esp
  801896:	68 38 3a 80 00       	push   $0x803a38
  80189b:	68 af 00 00 00       	push   $0xaf
  8018a0:	68 c9 39 80 00       	push   $0x8039c9
  8018a5:	e8 e9 ec ff ff       	call   800593 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8018aa:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8018af:	89 f0                	mov    %esi,%eax
  8018b1:	e8 19 fc ff ff       	call   8014cf <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8018b6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8018bc:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8018c2:	77 65                	ja     801929 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  8018c4:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8018ca:	74 de                	je     8018aa <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8018cc:	89 d8                	mov    %ebx,%eax
  8018ce:	c1 e8 16             	shr    $0x16,%eax
  8018d1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8018d8:	a8 01                	test   $0x1,%al
  8018da:	74 da                	je     8018b6 <sfork+0x6b>
  8018dc:	89 da                	mov    %ebx,%edx
  8018de:	c1 ea 0c             	shr    $0xc,%edx
  8018e1:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8018e8:	83 e0 05             	and    $0x5,%eax
  8018eb:	83 f8 05             	cmp    $0x5,%eax
  8018ee:	75 c6                	jne    8018b6 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8018f0:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8018f7:	c1 e2 0c             	shl    $0xc,%edx
  8018fa:	83 ec 0c             	sub    $0xc,%esp
  8018fd:	83 e0 07             	and    $0x7,%eax
  801900:	50                   	push   %eax
  801901:	52                   	push   %edx
  801902:	56                   	push   %esi
  801903:	52                   	push   %edx
  801904:	6a 00                	push   $0x0
  801906:	e8 12 f9 ff ff       	call   80121d <sys_page_map>
  80190b:	83 c4 20             	add    $0x20,%esp
  80190e:	85 c0                	test   %eax,%eax
  801910:	74 a4                	je     8018b6 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  801912:	83 ec 04             	sub    $0x4,%esp
  801915:	68 b3 39 80 00       	push   $0x8039b3
  80191a:	68 ba 00 00 00       	push   $0xba
  80191f:	68 c9 39 80 00       	push   $0x8039c9
  801924:	e8 6a ec ff ff       	call   800593 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801929:	83 ec 04             	sub    $0x4,%esp
  80192c:	6a 07                	push   $0x7
  80192e:	68 00 f0 bf ee       	push   $0xeebff000
  801933:	57                   	push   %edi
  801934:	e8 a1 f8 ff ff       	call   8011da <sys_page_alloc>
	if(ret < 0)
  801939:	83 c4 10             	add    $0x10,%esp
  80193c:	85 c0                	test   %eax,%eax
  80193e:	78 31                	js     801971 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801940:	83 ec 08             	sub    $0x8,%esp
  801943:	68 71 30 80 00       	push   $0x803071
  801948:	57                   	push   %edi
  801949:	e8 d7 f9 ff ff       	call   801325 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80194e:	83 c4 10             	add    $0x10,%esp
  801951:	85 c0                	test   %eax,%eax
  801953:	78 33                	js     801988 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801955:	83 ec 08             	sub    $0x8,%esp
  801958:	6a 02                	push   $0x2
  80195a:	57                   	push   %edi
  80195b:	e8 41 f9 ff ff       	call   8012a1 <sys_env_set_status>
	if(ret < 0)
  801960:	83 c4 10             	add    $0x10,%esp
  801963:	85 c0                	test   %eax,%eax
  801965:	78 38                	js     80199f <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801967:	89 f8                	mov    %edi,%eax
  801969:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80196c:	5b                   	pop    %ebx
  80196d:	5e                   	pop    %esi
  80196e:	5f                   	pop    %edi
  80196f:	5d                   	pop    %ebp
  801970:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801971:	83 ec 04             	sub    $0x4,%esp
  801974:	68 e8 39 80 00       	push   $0x8039e8
  801979:	68 c0 00 00 00       	push   $0xc0
  80197e:	68 c9 39 80 00       	push   $0x8039c9
  801983:	e8 0b ec ff ff       	call   800593 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801988:	83 ec 04             	sub    $0x4,%esp
  80198b:	68 5c 3a 80 00       	push   $0x803a5c
  801990:	68 c3 00 00 00       	push   $0xc3
  801995:	68 c9 39 80 00       	push   $0x8039c9
  80199a:	e8 f4 eb ff ff       	call   800593 <_panic>
		panic("panic in sys_env_set_status()\n");
  80199f:	83 ec 04             	sub    $0x4,%esp
  8019a2:	68 84 3a 80 00       	push   $0x803a84
  8019a7:	68 c6 00 00 00       	push   $0xc6
  8019ac:	68 c9 39 80 00       	push   $0x8039c9
  8019b1:	e8 dd eb ff ff       	call   800593 <_panic>

008019b6 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8019b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bc:	05 00 00 00 30       	add    $0x30000000,%eax
  8019c1:	c1 e8 0c             	shr    $0xc,%eax
}
  8019c4:	5d                   	pop    %ebp
  8019c5:	c3                   	ret    

008019c6 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8019c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cc:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8019d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019d6:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8019db:	5d                   	pop    %ebp
  8019dc:	c3                   	ret    

008019dd <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
  8019e0:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8019e5:	89 c2                	mov    %eax,%edx
  8019e7:	c1 ea 16             	shr    $0x16,%edx
  8019ea:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8019f1:	f6 c2 01             	test   $0x1,%dl
  8019f4:	74 2d                	je     801a23 <fd_alloc+0x46>
  8019f6:	89 c2                	mov    %eax,%edx
  8019f8:	c1 ea 0c             	shr    $0xc,%edx
  8019fb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a02:	f6 c2 01             	test   $0x1,%dl
  801a05:	74 1c                	je     801a23 <fd_alloc+0x46>
  801a07:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801a0c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801a11:	75 d2                	jne    8019e5 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801a13:	8b 45 08             	mov    0x8(%ebp),%eax
  801a16:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801a1c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801a21:	eb 0a                	jmp    801a2d <fd_alloc+0x50>
			*fd_store = fd;
  801a23:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a26:	89 01                	mov    %eax,(%ecx)
			return 0;
  801a28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a2d:	5d                   	pop    %ebp
  801a2e:	c3                   	ret    

00801a2f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
  801a32:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801a35:	83 f8 1f             	cmp    $0x1f,%eax
  801a38:	77 30                	ja     801a6a <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801a3a:	c1 e0 0c             	shl    $0xc,%eax
  801a3d:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801a42:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801a48:	f6 c2 01             	test   $0x1,%dl
  801a4b:	74 24                	je     801a71 <fd_lookup+0x42>
  801a4d:	89 c2                	mov    %eax,%edx
  801a4f:	c1 ea 0c             	shr    $0xc,%edx
  801a52:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a59:	f6 c2 01             	test   $0x1,%dl
  801a5c:	74 1a                	je     801a78 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801a5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a61:	89 02                	mov    %eax,(%edx)
	return 0;
  801a63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a68:	5d                   	pop    %ebp
  801a69:	c3                   	ret    
		return -E_INVAL;
  801a6a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a6f:	eb f7                	jmp    801a68 <fd_lookup+0x39>
		return -E_INVAL;
  801a71:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a76:	eb f0                	jmp    801a68 <fd_lookup+0x39>
  801a78:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a7d:	eb e9                	jmp    801a68 <fd_lookup+0x39>

00801a7f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
  801a82:	83 ec 08             	sub    $0x8,%esp
  801a85:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801a88:	ba 00 00 00 00       	mov    $0x0,%edx
  801a8d:	b8 20 40 80 00       	mov    $0x804020,%eax
		if (devtab[i]->dev_id == dev_id) {
  801a92:	39 08                	cmp    %ecx,(%eax)
  801a94:	74 38                	je     801ace <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801a96:	83 c2 01             	add    $0x1,%edx
  801a99:	8b 04 95 20 3b 80 00 	mov    0x803b20(,%edx,4),%eax
  801aa0:	85 c0                	test   %eax,%eax
  801aa2:	75 ee                	jne    801a92 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801aa4:	a1 08 50 80 00       	mov    0x805008,%eax
  801aa9:	8b 40 48             	mov    0x48(%eax),%eax
  801aac:	83 ec 04             	sub    $0x4,%esp
  801aaf:	51                   	push   %ecx
  801ab0:	50                   	push   %eax
  801ab1:	68 a4 3a 80 00       	push   $0x803aa4
  801ab6:	e8 ce eb ff ff       	call   800689 <cprintf>
	*dev = 0;
  801abb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801abe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801ac4:	83 c4 10             	add    $0x10,%esp
  801ac7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    
			*dev = devtab[i];
  801ace:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ad1:	89 01                	mov    %eax,(%ecx)
			return 0;
  801ad3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad8:	eb f2                	jmp    801acc <dev_lookup+0x4d>

00801ada <fd_close>:
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
  801add:	57                   	push   %edi
  801ade:	56                   	push   %esi
  801adf:	53                   	push   %ebx
  801ae0:	83 ec 24             	sub    $0x24,%esp
  801ae3:	8b 75 08             	mov    0x8(%ebp),%esi
  801ae6:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801ae9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801aec:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801aed:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801af3:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801af6:	50                   	push   %eax
  801af7:	e8 33 ff ff ff       	call   801a2f <fd_lookup>
  801afc:	89 c3                	mov    %eax,%ebx
  801afe:	83 c4 10             	add    $0x10,%esp
  801b01:	85 c0                	test   %eax,%eax
  801b03:	78 05                	js     801b0a <fd_close+0x30>
	    || fd != fd2)
  801b05:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801b08:	74 16                	je     801b20 <fd_close+0x46>
		return (must_exist ? r : 0);
  801b0a:	89 f8                	mov    %edi,%eax
  801b0c:	84 c0                	test   %al,%al
  801b0e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b13:	0f 44 d8             	cmove  %eax,%ebx
}
  801b16:	89 d8                	mov    %ebx,%eax
  801b18:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b1b:	5b                   	pop    %ebx
  801b1c:	5e                   	pop    %esi
  801b1d:	5f                   	pop    %edi
  801b1e:	5d                   	pop    %ebp
  801b1f:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801b20:	83 ec 08             	sub    $0x8,%esp
  801b23:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801b26:	50                   	push   %eax
  801b27:	ff 36                	pushl  (%esi)
  801b29:	e8 51 ff ff ff       	call   801a7f <dev_lookup>
  801b2e:	89 c3                	mov    %eax,%ebx
  801b30:	83 c4 10             	add    $0x10,%esp
  801b33:	85 c0                	test   %eax,%eax
  801b35:	78 1a                	js     801b51 <fd_close+0x77>
		if (dev->dev_close)
  801b37:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b3a:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801b3d:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801b42:	85 c0                	test   %eax,%eax
  801b44:	74 0b                	je     801b51 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801b46:	83 ec 0c             	sub    $0xc,%esp
  801b49:	56                   	push   %esi
  801b4a:	ff d0                	call   *%eax
  801b4c:	89 c3                	mov    %eax,%ebx
  801b4e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801b51:	83 ec 08             	sub    $0x8,%esp
  801b54:	56                   	push   %esi
  801b55:	6a 00                	push   $0x0
  801b57:	e8 03 f7 ff ff       	call   80125f <sys_page_unmap>
	return r;
  801b5c:	83 c4 10             	add    $0x10,%esp
  801b5f:	eb b5                	jmp    801b16 <fd_close+0x3c>

00801b61 <close>:

int
close(int fdnum)
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
  801b64:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b67:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b6a:	50                   	push   %eax
  801b6b:	ff 75 08             	pushl  0x8(%ebp)
  801b6e:	e8 bc fe ff ff       	call   801a2f <fd_lookup>
  801b73:	83 c4 10             	add    $0x10,%esp
  801b76:	85 c0                	test   %eax,%eax
  801b78:	79 02                	jns    801b7c <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    
		return fd_close(fd, 1);
  801b7c:	83 ec 08             	sub    $0x8,%esp
  801b7f:	6a 01                	push   $0x1
  801b81:	ff 75 f4             	pushl  -0xc(%ebp)
  801b84:	e8 51 ff ff ff       	call   801ada <fd_close>
  801b89:	83 c4 10             	add    $0x10,%esp
  801b8c:	eb ec                	jmp    801b7a <close+0x19>

00801b8e <close_all>:

void
close_all(void)
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
  801b91:	53                   	push   %ebx
  801b92:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801b95:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801b9a:	83 ec 0c             	sub    $0xc,%esp
  801b9d:	53                   	push   %ebx
  801b9e:	e8 be ff ff ff       	call   801b61 <close>
	for (i = 0; i < MAXFD; i++)
  801ba3:	83 c3 01             	add    $0x1,%ebx
  801ba6:	83 c4 10             	add    $0x10,%esp
  801ba9:	83 fb 20             	cmp    $0x20,%ebx
  801bac:	75 ec                	jne    801b9a <close_all+0xc>
}
  801bae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    

00801bb3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
  801bb6:	57                   	push   %edi
  801bb7:	56                   	push   %esi
  801bb8:	53                   	push   %ebx
  801bb9:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801bbc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801bbf:	50                   	push   %eax
  801bc0:	ff 75 08             	pushl  0x8(%ebp)
  801bc3:	e8 67 fe ff ff       	call   801a2f <fd_lookup>
  801bc8:	89 c3                	mov    %eax,%ebx
  801bca:	83 c4 10             	add    $0x10,%esp
  801bcd:	85 c0                	test   %eax,%eax
  801bcf:	0f 88 81 00 00 00    	js     801c56 <dup+0xa3>
		return r;
	close(newfdnum);
  801bd5:	83 ec 0c             	sub    $0xc,%esp
  801bd8:	ff 75 0c             	pushl  0xc(%ebp)
  801bdb:	e8 81 ff ff ff       	call   801b61 <close>

	newfd = INDEX2FD(newfdnum);
  801be0:	8b 75 0c             	mov    0xc(%ebp),%esi
  801be3:	c1 e6 0c             	shl    $0xc,%esi
  801be6:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801bec:	83 c4 04             	add    $0x4,%esp
  801bef:	ff 75 e4             	pushl  -0x1c(%ebp)
  801bf2:	e8 cf fd ff ff       	call   8019c6 <fd2data>
  801bf7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801bf9:	89 34 24             	mov    %esi,(%esp)
  801bfc:	e8 c5 fd ff ff       	call   8019c6 <fd2data>
  801c01:	83 c4 10             	add    $0x10,%esp
  801c04:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801c06:	89 d8                	mov    %ebx,%eax
  801c08:	c1 e8 16             	shr    $0x16,%eax
  801c0b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801c12:	a8 01                	test   $0x1,%al
  801c14:	74 11                	je     801c27 <dup+0x74>
  801c16:	89 d8                	mov    %ebx,%eax
  801c18:	c1 e8 0c             	shr    $0xc,%eax
  801c1b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801c22:	f6 c2 01             	test   $0x1,%dl
  801c25:	75 39                	jne    801c60 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801c27:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c2a:	89 d0                	mov    %edx,%eax
  801c2c:	c1 e8 0c             	shr    $0xc,%eax
  801c2f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801c36:	83 ec 0c             	sub    $0xc,%esp
  801c39:	25 07 0e 00 00       	and    $0xe07,%eax
  801c3e:	50                   	push   %eax
  801c3f:	56                   	push   %esi
  801c40:	6a 00                	push   $0x0
  801c42:	52                   	push   %edx
  801c43:	6a 00                	push   $0x0
  801c45:	e8 d3 f5 ff ff       	call   80121d <sys_page_map>
  801c4a:	89 c3                	mov    %eax,%ebx
  801c4c:	83 c4 20             	add    $0x20,%esp
  801c4f:	85 c0                	test   %eax,%eax
  801c51:	78 31                	js     801c84 <dup+0xd1>
		goto err;

	return newfdnum;
  801c53:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801c56:	89 d8                	mov    %ebx,%eax
  801c58:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c5b:	5b                   	pop    %ebx
  801c5c:	5e                   	pop    %esi
  801c5d:	5f                   	pop    %edi
  801c5e:	5d                   	pop    %ebp
  801c5f:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801c60:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801c67:	83 ec 0c             	sub    $0xc,%esp
  801c6a:	25 07 0e 00 00       	and    $0xe07,%eax
  801c6f:	50                   	push   %eax
  801c70:	57                   	push   %edi
  801c71:	6a 00                	push   $0x0
  801c73:	53                   	push   %ebx
  801c74:	6a 00                	push   $0x0
  801c76:	e8 a2 f5 ff ff       	call   80121d <sys_page_map>
  801c7b:	89 c3                	mov    %eax,%ebx
  801c7d:	83 c4 20             	add    $0x20,%esp
  801c80:	85 c0                	test   %eax,%eax
  801c82:	79 a3                	jns    801c27 <dup+0x74>
	sys_page_unmap(0, newfd);
  801c84:	83 ec 08             	sub    $0x8,%esp
  801c87:	56                   	push   %esi
  801c88:	6a 00                	push   $0x0
  801c8a:	e8 d0 f5 ff ff       	call   80125f <sys_page_unmap>
	sys_page_unmap(0, nva);
  801c8f:	83 c4 08             	add    $0x8,%esp
  801c92:	57                   	push   %edi
  801c93:	6a 00                	push   $0x0
  801c95:	e8 c5 f5 ff ff       	call   80125f <sys_page_unmap>
	return r;
  801c9a:	83 c4 10             	add    $0x10,%esp
  801c9d:	eb b7                	jmp    801c56 <dup+0xa3>

00801c9f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
  801ca2:	53                   	push   %ebx
  801ca3:	83 ec 1c             	sub    $0x1c,%esp
  801ca6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ca9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cac:	50                   	push   %eax
  801cad:	53                   	push   %ebx
  801cae:	e8 7c fd ff ff       	call   801a2f <fd_lookup>
  801cb3:	83 c4 10             	add    $0x10,%esp
  801cb6:	85 c0                	test   %eax,%eax
  801cb8:	78 3f                	js     801cf9 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801cba:	83 ec 08             	sub    $0x8,%esp
  801cbd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cc0:	50                   	push   %eax
  801cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc4:	ff 30                	pushl  (%eax)
  801cc6:	e8 b4 fd ff ff       	call   801a7f <dev_lookup>
  801ccb:	83 c4 10             	add    $0x10,%esp
  801cce:	85 c0                	test   %eax,%eax
  801cd0:	78 27                	js     801cf9 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801cd2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cd5:	8b 42 08             	mov    0x8(%edx),%eax
  801cd8:	83 e0 03             	and    $0x3,%eax
  801cdb:	83 f8 01             	cmp    $0x1,%eax
  801cde:	74 1e                	je     801cfe <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce3:	8b 40 08             	mov    0x8(%eax),%eax
  801ce6:	85 c0                	test   %eax,%eax
  801ce8:	74 35                	je     801d1f <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801cea:	83 ec 04             	sub    $0x4,%esp
  801ced:	ff 75 10             	pushl  0x10(%ebp)
  801cf0:	ff 75 0c             	pushl  0xc(%ebp)
  801cf3:	52                   	push   %edx
  801cf4:	ff d0                	call   *%eax
  801cf6:	83 c4 10             	add    $0x10,%esp
}
  801cf9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801cfe:	a1 08 50 80 00       	mov    0x805008,%eax
  801d03:	8b 40 48             	mov    0x48(%eax),%eax
  801d06:	83 ec 04             	sub    $0x4,%esp
  801d09:	53                   	push   %ebx
  801d0a:	50                   	push   %eax
  801d0b:	68 e5 3a 80 00       	push   $0x803ae5
  801d10:	e8 74 e9 ff ff       	call   800689 <cprintf>
		return -E_INVAL;
  801d15:	83 c4 10             	add    $0x10,%esp
  801d18:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d1d:	eb da                	jmp    801cf9 <read+0x5a>
		return -E_NOT_SUPP;
  801d1f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d24:	eb d3                	jmp    801cf9 <read+0x5a>

00801d26 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
  801d29:	57                   	push   %edi
  801d2a:	56                   	push   %esi
  801d2b:	53                   	push   %ebx
  801d2c:	83 ec 0c             	sub    $0xc,%esp
  801d2f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801d32:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801d35:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d3a:	39 f3                	cmp    %esi,%ebx
  801d3c:	73 23                	jae    801d61 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801d3e:	83 ec 04             	sub    $0x4,%esp
  801d41:	89 f0                	mov    %esi,%eax
  801d43:	29 d8                	sub    %ebx,%eax
  801d45:	50                   	push   %eax
  801d46:	89 d8                	mov    %ebx,%eax
  801d48:	03 45 0c             	add    0xc(%ebp),%eax
  801d4b:	50                   	push   %eax
  801d4c:	57                   	push   %edi
  801d4d:	e8 4d ff ff ff       	call   801c9f <read>
		if (m < 0)
  801d52:	83 c4 10             	add    $0x10,%esp
  801d55:	85 c0                	test   %eax,%eax
  801d57:	78 06                	js     801d5f <readn+0x39>
			return m;
		if (m == 0)
  801d59:	74 06                	je     801d61 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801d5b:	01 c3                	add    %eax,%ebx
  801d5d:	eb db                	jmp    801d3a <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801d5f:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801d61:	89 d8                	mov    %ebx,%eax
  801d63:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d66:	5b                   	pop    %ebx
  801d67:	5e                   	pop    %esi
  801d68:	5f                   	pop    %edi
  801d69:	5d                   	pop    %ebp
  801d6a:	c3                   	ret    

00801d6b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
  801d6e:	53                   	push   %ebx
  801d6f:	83 ec 1c             	sub    $0x1c,%esp
  801d72:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d75:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d78:	50                   	push   %eax
  801d79:	53                   	push   %ebx
  801d7a:	e8 b0 fc ff ff       	call   801a2f <fd_lookup>
  801d7f:	83 c4 10             	add    $0x10,%esp
  801d82:	85 c0                	test   %eax,%eax
  801d84:	78 3a                	js     801dc0 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d86:	83 ec 08             	sub    $0x8,%esp
  801d89:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d8c:	50                   	push   %eax
  801d8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d90:	ff 30                	pushl  (%eax)
  801d92:	e8 e8 fc ff ff       	call   801a7f <dev_lookup>
  801d97:	83 c4 10             	add    $0x10,%esp
  801d9a:	85 c0                	test   %eax,%eax
  801d9c:	78 22                	js     801dc0 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801da5:	74 1e                	je     801dc5 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801da7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801daa:	8b 52 0c             	mov    0xc(%edx),%edx
  801dad:	85 d2                	test   %edx,%edx
  801daf:	74 35                	je     801de6 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801db1:	83 ec 04             	sub    $0x4,%esp
  801db4:	ff 75 10             	pushl  0x10(%ebp)
  801db7:	ff 75 0c             	pushl  0xc(%ebp)
  801dba:	50                   	push   %eax
  801dbb:	ff d2                	call   *%edx
  801dbd:	83 c4 10             	add    $0x10,%esp
}
  801dc0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dc3:	c9                   	leave  
  801dc4:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801dc5:	a1 08 50 80 00       	mov    0x805008,%eax
  801dca:	8b 40 48             	mov    0x48(%eax),%eax
  801dcd:	83 ec 04             	sub    $0x4,%esp
  801dd0:	53                   	push   %ebx
  801dd1:	50                   	push   %eax
  801dd2:	68 01 3b 80 00       	push   $0x803b01
  801dd7:	e8 ad e8 ff ff       	call   800689 <cprintf>
		return -E_INVAL;
  801ddc:	83 c4 10             	add    $0x10,%esp
  801ddf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801de4:	eb da                	jmp    801dc0 <write+0x55>
		return -E_NOT_SUPP;
  801de6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801deb:	eb d3                	jmp    801dc0 <write+0x55>

00801ded <seek>:

int
seek(int fdnum, off_t offset)
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
  801df0:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801df3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801df6:	50                   	push   %eax
  801df7:	ff 75 08             	pushl  0x8(%ebp)
  801dfa:	e8 30 fc ff ff       	call   801a2f <fd_lookup>
  801dff:	83 c4 10             	add    $0x10,%esp
  801e02:	85 c0                	test   %eax,%eax
  801e04:	78 0e                	js     801e14 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801e06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801e0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e14:	c9                   	leave  
  801e15:	c3                   	ret    

00801e16 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801e16:	55                   	push   %ebp
  801e17:	89 e5                	mov    %esp,%ebp
  801e19:	53                   	push   %ebx
  801e1a:	83 ec 1c             	sub    $0x1c,%esp
  801e1d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801e20:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e23:	50                   	push   %eax
  801e24:	53                   	push   %ebx
  801e25:	e8 05 fc ff ff       	call   801a2f <fd_lookup>
  801e2a:	83 c4 10             	add    $0x10,%esp
  801e2d:	85 c0                	test   %eax,%eax
  801e2f:	78 37                	js     801e68 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801e31:	83 ec 08             	sub    $0x8,%esp
  801e34:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e37:	50                   	push   %eax
  801e38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e3b:	ff 30                	pushl  (%eax)
  801e3d:	e8 3d fc ff ff       	call   801a7f <dev_lookup>
  801e42:	83 c4 10             	add    $0x10,%esp
  801e45:	85 c0                	test   %eax,%eax
  801e47:	78 1f                	js     801e68 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801e49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e4c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801e50:	74 1b                	je     801e6d <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801e52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e55:	8b 52 18             	mov    0x18(%edx),%edx
  801e58:	85 d2                	test   %edx,%edx
  801e5a:	74 32                	je     801e8e <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801e5c:	83 ec 08             	sub    $0x8,%esp
  801e5f:	ff 75 0c             	pushl  0xc(%ebp)
  801e62:	50                   	push   %eax
  801e63:	ff d2                	call   *%edx
  801e65:	83 c4 10             	add    $0x10,%esp
}
  801e68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e6b:	c9                   	leave  
  801e6c:	c3                   	ret    
			thisenv->env_id, fdnum);
  801e6d:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801e72:	8b 40 48             	mov    0x48(%eax),%eax
  801e75:	83 ec 04             	sub    $0x4,%esp
  801e78:	53                   	push   %ebx
  801e79:	50                   	push   %eax
  801e7a:	68 c4 3a 80 00       	push   $0x803ac4
  801e7f:	e8 05 e8 ff ff       	call   800689 <cprintf>
		return -E_INVAL;
  801e84:	83 c4 10             	add    $0x10,%esp
  801e87:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e8c:	eb da                	jmp    801e68 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801e8e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e93:	eb d3                	jmp    801e68 <ftruncate+0x52>

00801e95 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
  801e98:	53                   	push   %ebx
  801e99:	83 ec 1c             	sub    $0x1c,%esp
  801e9c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801e9f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ea2:	50                   	push   %eax
  801ea3:	ff 75 08             	pushl  0x8(%ebp)
  801ea6:	e8 84 fb ff ff       	call   801a2f <fd_lookup>
  801eab:	83 c4 10             	add    $0x10,%esp
  801eae:	85 c0                	test   %eax,%eax
  801eb0:	78 4b                	js     801efd <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801eb2:	83 ec 08             	sub    $0x8,%esp
  801eb5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eb8:	50                   	push   %eax
  801eb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ebc:	ff 30                	pushl  (%eax)
  801ebe:	e8 bc fb ff ff       	call   801a7f <dev_lookup>
  801ec3:	83 c4 10             	add    $0x10,%esp
  801ec6:	85 c0                	test   %eax,%eax
  801ec8:	78 33                	js     801efd <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ecd:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801ed1:	74 2f                	je     801f02 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801ed3:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801ed6:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801edd:	00 00 00 
	stat->st_isdir = 0;
  801ee0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ee7:	00 00 00 
	stat->st_dev = dev;
  801eea:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801ef0:	83 ec 08             	sub    $0x8,%esp
  801ef3:	53                   	push   %ebx
  801ef4:	ff 75 f0             	pushl  -0x10(%ebp)
  801ef7:	ff 50 14             	call   *0x14(%eax)
  801efa:	83 c4 10             	add    $0x10,%esp
}
  801efd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f00:	c9                   	leave  
  801f01:	c3                   	ret    
		return -E_NOT_SUPP;
  801f02:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f07:	eb f4                	jmp    801efd <fstat+0x68>

00801f09 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801f09:	55                   	push   %ebp
  801f0a:	89 e5                	mov    %esp,%ebp
  801f0c:	56                   	push   %esi
  801f0d:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801f0e:	83 ec 08             	sub    $0x8,%esp
  801f11:	6a 00                	push   $0x0
  801f13:	ff 75 08             	pushl  0x8(%ebp)
  801f16:	e8 22 02 00 00       	call   80213d <open>
  801f1b:	89 c3                	mov    %eax,%ebx
  801f1d:	83 c4 10             	add    $0x10,%esp
  801f20:	85 c0                	test   %eax,%eax
  801f22:	78 1b                	js     801f3f <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801f24:	83 ec 08             	sub    $0x8,%esp
  801f27:	ff 75 0c             	pushl  0xc(%ebp)
  801f2a:	50                   	push   %eax
  801f2b:	e8 65 ff ff ff       	call   801e95 <fstat>
  801f30:	89 c6                	mov    %eax,%esi
	close(fd);
  801f32:	89 1c 24             	mov    %ebx,(%esp)
  801f35:	e8 27 fc ff ff       	call   801b61 <close>
	return r;
  801f3a:	83 c4 10             	add    $0x10,%esp
  801f3d:	89 f3                	mov    %esi,%ebx
}
  801f3f:	89 d8                	mov    %ebx,%eax
  801f41:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f44:	5b                   	pop    %ebx
  801f45:	5e                   	pop    %esi
  801f46:	5d                   	pop    %ebp
  801f47:	c3                   	ret    

00801f48 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
  801f4b:	56                   	push   %esi
  801f4c:	53                   	push   %ebx
  801f4d:	89 c6                	mov    %eax,%esi
  801f4f:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801f51:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801f58:	74 27                	je     801f81 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801f5a:	6a 07                	push   $0x7
  801f5c:	68 00 60 80 00       	push   $0x806000
  801f61:	56                   	push   %esi
  801f62:	ff 35 00 50 80 00    	pushl  0x805000
  801f68:	e8 93 11 00 00       	call   803100 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801f6d:	83 c4 0c             	add    $0xc,%esp
  801f70:	6a 00                	push   $0x0
  801f72:	53                   	push   %ebx
  801f73:	6a 00                	push   $0x0
  801f75:	e8 1d 11 00 00       	call   803097 <ipc_recv>
}
  801f7a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f7d:	5b                   	pop    %ebx
  801f7e:	5e                   	pop    %esi
  801f7f:	5d                   	pop    %ebp
  801f80:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801f81:	83 ec 0c             	sub    $0xc,%esp
  801f84:	6a 01                	push   $0x1
  801f86:	e8 cd 11 00 00       	call   803158 <ipc_find_env>
  801f8b:	a3 00 50 80 00       	mov    %eax,0x805000
  801f90:	83 c4 10             	add    $0x10,%esp
  801f93:	eb c5                	jmp    801f5a <fsipc+0x12>

00801f95 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801f95:	55                   	push   %ebp
  801f96:	89 e5                	mov    %esp,%ebp
  801f98:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9e:	8b 40 0c             	mov    0xc(%eax),%eax
  801fa1:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801fa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa9:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801fae:	ba 00 00 00 00       	mov    $0x0,%edx
  801fb3:	b8 02 00 00 00       	mov    $0x2,%eax
  801fb8:	e8 8b ff ff ff       	call   801f48 <fsipc>
}
  801fbd:	c9                   	leave  
  801fbe:	c3                   	ret    

00801fbf <devfile_flush>:
{
  801fbf:	55                   	push   %ebp
  801fc0:	89 e5                	mov    %esp,%ebp
  801fc2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc8:	8b 40 0c             	mov    0xc(%eax),%eax
  801fcb:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801fd0:	ba 00 00 00 00       	mov    $0x0,%edx
  801fd5:	b8 06 00 00 00       	mov    $0x6,%eax
  801fda:	e8 69 ff ff ff       	call   801f48 <fsipc>
}
  801fdf:	c9                   	leave  
  801fe0:	c3                   	ret    

00801fe1 <devfile_stat>:
{
  801fe1:	55                   	push   %ebp
  801fe2:	89 e5                	mov    %esp,%ebp
  801fe4:	53                   	push   %ebx
  801fe5:	83 ec 04             	sub    $0x4,%esp
  801fe8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801feb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fee:	8b 40 0c             	mov    0xc(%eax),%eax
  801ff1:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801ff6:	ba 00 00 00 00       	mov    $0x0,%edx
  801ffb:	b8 05 00 00 00       	mov    $0x5,%eax
  802000:	e8 43 ff ff ff       	call   801f48 <fsipc>
  802005:	85 c0                	test   %eax,%eax
  802007:	78 2c                	js     802035 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802009:	83 ec 08             	sub    $0x8,%esp
  80200c:	68 00 60 80 00       	push   $0x806000
  802011:	53                   	push   %ebx
  802012:	e8 d1 ed ff ff       	call   800de8 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  802017:	a1 80 60 80 00       	mov    0x806080,%eax
  80201c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802022:	a1 84 60 80 00       	mov    0x806084,%eax
  802027:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80202d:	83 c4 10             	add    $0x10,%esp
  802030:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802035:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802038:	c9                   	leave  
  802039:	c3                   	ret    

0080203a <devfile_write>:
{
  80203a:	55                   	push   %ebp
  80203b:	89 e5                	mov    %esp,%ebp
  80203d:	53                   	push   %ebx
  80203e:	83 ec 08             	sub    $0x8,%esp
  802041:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802044:	8b 45 08             	mov    0x8(%ebp),%eax
  802047:	8b 40 0c             	mov    0xc(%eax),%eax
  80204a:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  80204f:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802055:	53                   	push   %ebx
  802056:	ff 75 0c             	pushl  0xc(%ebp)
  802059:	68 08 60 80 00       	push   $0x806008
  80205e:	e8 75 ef ff ff       	call   800fd8 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802063:	ba 00 00 00 00       	mov    $0x0,%edx
  802068:	b8 04 00 00 00       	mov    $0x4,%eax
  80206d:	e8 d6 fe ff ff       	call   801f48 <fsipc>
  802072:	83 c4 10             	add    $0x10,%esp
  802075:	85 c0                	test   %eax,%eax
  802077:	78 0b                	js     802084 <devfile_write+0x4a>
	assert(r <= n);
  802079:	39 d8                	cmp    %ebx,%eax
  80207b:	77 0c                	ja     802089 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80207d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802082:	7f 1e                	jg     8020a2 <devfile_write+0x68>
}
  802084:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802087:	c9                   	leave  
  802088:	c3                   	ret    
	assert(r <= n);
  802089:	68 34 3b 80 00       	push   $0x803b34
  80208e:	68 3b 3b 80 00       	push   $0x803b3b
  802093:	68 98 00 00 00       	push   $0x98
  802098:	68 50 3b 80 00       	push   $0x803b50
  80209d:	e8 f1 e4 ff ff       	call   800593 <_panic>
	assert(r <= PGSIZE);
  8020a2:	68 5b 3b 80 00       	push   $0x803b5b
  8020a7:	68 3b 3b 80 00       	push   $0x803b3b
  8020ac:	68 99 00 00 00       	push   $0x99
  8020b1:	68 50 3b 80 00       	push   $0x803b50
  8020b6:	e8 d8 e4 ff ff       	call   800593 <_panic>

008020bb <devfile_read>:
{
  8020bb:	55                   	push   %ebp
  8020bc:	89 e5                	mov    %esp,%ebp
  8020be:	56                   	push   %esi
  8020bf:	53                   	push   %ebx
  8020c0:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8020c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8020c9:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  8020ce:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8020d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8020d9:	b8 03 00 00 00       	mov    $0x3,%eax
  8020de:	e8 65 fe ff ff       	call   801f48 <fsipc>
  8020e3:	89 c3                	mov    %eax,%ebx
  8020e5:	85 c0                	test   %eax,%eax
  8020e7:	78 1f                	js     802108 <devfile_read+0x4d>
	assert(r <= n);
  8020e9:	39 f0                	cmp    %esi,%eax
  8020eb:	77 24                	ja     802111 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8020ed:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8020f2:	7f 33                	jg     802127 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8020f4:	83 ec 04             	sub    $0x4,%esp
  8020f7:	50                   	push   %eax
  8020f8:	68 00 60 80 00       	push   $0x806000
  8020fd:	ff 75 0c             	pushl  0xc(%ebp)
  802100:	e8 71 ee ff ff       	call   800f76 <memmove>
	return r;
  802105:	83 c4 10             	add    $0x10,%esp
}
  802108:	89 d8                	mov    %ebx,%eax
  80210a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80210d:	5b                   	pop    %ebx
  80210e:	5e                   	pop    %esi
  80210f:	5d                   	pop    %ebp
  802110:	c3                   	ret    
	assert(r <= n);
  802111:	68 34 3b 80 00       	push   $0x803b34
  802116:	68 3b 3b 80 00       	push   $0x803b3b
  80211b:	6a 7c                	push   $0x7c
  80211d:	68 50 3b 80 00       	push   $0x803b50
  802122:	e8 6c e4 ff ff       	call   800593 <_panic>
	assert(r <= PGSIZE);
  802127:	68 5b 3b 80 00       	push   $0x803b5b
  80212c:	68 3b 3b 80 00       	push   $0x803b3b
  802131:	6a 7d                	push   $0x7d
  802133:	68 50 3b 80 00       	push   $0x803b50
  802138:	e8 56 e4 ff ff       	call   800593 <_panic>

0080213d <open>:
{
  80213d:	55                   	push   %ebp
  80213e:	89 e5                	mov    %esp,%ebp
  802140:	56                   	push   %esi
  802141:	53                   	push   %ebx
  802142:	83 ec 1c             	sub    $0x1c,%esp
  802145:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  802148:	56                   	push   %esi
  802149:	e8 61 ec ff ff       	call   800daf <strlen>
  80214e:	83 c4 10             	add    $0x10,%esp
  802151:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802156:	7f 6c                	jg     8021c4 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  802158:	83 ec 0c             	sub    $0xc,%esp
  80215b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80215e:	50                   	push   %eax
  80215f:	e8 79 f8 ff ff       	call   8019dd <fd_alloc>
  802164:	89 c3                	mov    %eax,%ebx
  802166:	83 c4 10             	add    $0x10,%esp
  802169:	85 c0                	test   %eax,%eax
  80216b:	78 3c                	js     8021a9 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80216d:	83 ec 08             	sub    $0x8,%esp
  802170:	56                   	push   %esi
  802171:	68 00 60 80 00       	push   $0x806000
  802176:	e8 6d ec ff ff       	call   800de8 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80217b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80217e:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802183:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802186:	b8 01 00 00 00       	mov    $0x1,%eax
  80218b:	e8 b8 fd ff ff       	call   801f48 <fsipc>
  802190:	89 c3                	mov    %eax,%ebx
  802192:	83 c4 10             	add    $0x10,%esp
  802195:	85 c0                	test   %eax,%eax
  802197:	78 19                	js     8021b2 <open+0x75>
	return fd2num(fd);
  802199:	83 ec 0c             	sub    $0xc,%esp
  80219c:	ff 75 f4             	pushl  -0xc(%ebp)
  80219f:	e8 12 f8 ff ff       	call   8019b6 <fd2num>
  8021a4:	89 c3                	mov    %eax,%ebx
  8021a6:	83 c4 10             	add    $0x10,%esp
}
  8021a9:	89 d8                	mov    %ebx,%eax
  8021ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021ae:	5b                   	pop    %ebx
  8021af:	5e                   	pop    %esi
  8021b0:	5d                   	pop    %ebp
  8021b1:	c3                   	ret    
		fd_close(fd, 0);
  8021b2:	83 ec 08             	sub    $0x8,%esp
  8021b5:	6a 00                	push   $0x0
  8021b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8021ba:	e8 1b f9 ff ff       	call   801ada <fd_close>
		return r;
  8021bf:	83 c4 10             	add    $0x10,%esp
  8021c2:	eb e5                	jmp    8021a9 <open+0x6c>
		return -E_BAD_PATH;
  8021c4:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8021c9:	eb de                	jmp    8021a9 <open+0x6c>

008021cb <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8021cb:	55                   	push   %ebp
  8021cc:	89 e5                	mov    %esp,%ebp
  8021ce:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8021d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8021d6:	b8 08 00 00 00       	mov    $0x8,%eax
  8021db:	e8 68 fd ff ff       	call   801f48 <fsipc>
}
  8021e0:	c9                   	leave  
  8021e1:	c3                   	ret    

008021e2 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8021e2:	55                   	push   %ebp
  8021e3:	89 e5                	mov    %esp,%ebp
  8021e5:	57                   	push   %edi
  8021e6:	56                   	push   %esi
  8021e7:	53                   	push   %ebx
  8021e8:	81 ec 94 02 00 00    	sub    $0x294,%esp
	cprintf("in %s\n", __FUNCTION__);
  8021ee:	68 40 3c 80 00       	push   $0x803c40
  8021f3:	68 be 35 80 00       	push   $0x8035be
  8021f8:	e8 8c e4 ff ff       	call   800689 <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8021fd:	83 c4 08             	add    $0x8,%esp
  802200:	6a 00                	push   $0x0
  802202:	ff 75 08             	pushl  0x8(%ebp)
  802205:	e8 33 ff ff ff       	call   80213d <open>
  80220a:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802210:	83 c4 10             	add    $0x10,%esp
  802213:	85 c0                	test   %eax,%eax
  802215:	0f 88 0a 05 00 00    	js     802725 <spawn+0x543>
  80221b:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  80221d:	83 ec 04             	sub    $0x4,%esp
  802220:	68 00 02 00 00       	push   $0x200
  802225:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  80222b:	50                   	push   %eax
  80222c:	51                   	push   %ecx
  80222d:	e8 f4 fa ff ff       	call   801d26 <readn>
  802232:	83 c4 10             	add    $0x10,%esp
  802235:	3d 00 02 00 00       	cmp    $0x200,%eax
  80223a:	75 74                	jne    8022b0 <spawn+0xce>
	    || elf->e_magic != ELF_MAGIC) {
  80223c:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  802243:	45 4c 46 
  802246:	75 68                	jne    8022b0 <spawn+0xce>
  802248:	b8 07 00 00 00       	mov    $0x7,%eax
  80224d:	cd 30                	int    $0x30
  80224f:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  802255:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  80225b:	85 c0                	test   %eax,%eax
  80225d:	0f 88 b6 04 00 00    	js     802719 <spawn+0x537>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802263:	25 ff 03 00 00       	and    $0x3ff,%eax
  802268:	89 c6                	mov    %eax,%esi
  80226a:	c1 e6 07             	shl    $0x7,%esi
  80226d:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  802273:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  802279:	b9 11 00 00 00       	mov    $0x11,%ecx
  80227e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  802280:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802286:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
	cprintf("in %s\n", __FUNCTION__);
  80228c:	83 ec 08             	sub    $0x8,%esp
  80228f:	68 34 3c 80 00       	push   $0x803c34
  802294:	68 be 35 80 00       	push   $0x8035be
  802299:	e8 eb e3 ff ff       	call   800689 <cprintf>
  80229e:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8022a1:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  8022a6:	be 00 00 00 00       	mov    $0x0,%esi
  8022ab:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8022ae:	eb 4b                	jmp    8022fb <spawn+0x119>
		close(fd);
  8022b0:	83 ec 0c             	sub    $0xc,%esp
  8022b3:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8022b9:	e8 a3 f8 ff ff       	call   801b61 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8022be:	83 c4 0c             	add    $0xc,%esp
  8022c1:	68 7f 45 4c 46       	push   $0x464c457f
  8022c6:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  8022cc:	68 67 3b 80 00       	push   $0x803b67
  8022d1:	e8 b3 e3 ff ff       	call   800689 <cprintf>
		return -E_NOT_EXEC;
  8022d6:	83 c4 10             	add    $0x10,%esp
  8022d9:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  8022e0:	ff ff ff 
  8022e3:	e9 3d 04 00 00       	jmp    802725 <spawn+0x543>
		string_size += strlen(argv[argc]) + 1;
  8022e8:	83 ec 0c             	sub    $0xc,%esp
  8022eb:	50                   	push   %eax
  8022ec:	e8 be ea ff ff       	call   800daf <strlen>
  8022f1:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  8022f5:	83 c3 01             	add    $0x1,%ebx
  8022f8:	83 c4 10             	add    $0x10,%esp
  8022fb:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  802302:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  802305:	85 c0                	test   %eax,%eax
  802307:	75 df                	jne    8022e8 <spawn+0x106>
  802309:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  80230f:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  802315:	bf 00 10 40 00       	mov    $0x401000,%edi
  80231a:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  80231c:	89 fa                	mov    %edi,%edx
  80231e:	83 e2 fc             	and    $0xfffffffc,%edx
  802321:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  802328:	29 c2                	sub    %eax,%edx
  80232a:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802330:	8d 42 f8             	lea    -0x8(%edx),%eax
  802333:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802338:	0f 86 0a 04 00 00    	jbe    802748 <spawn+0x566>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80233e:	83 ec 04             	sub    $0x4,%esp
  802341:	6a 07                	push   $0x7
  802343:	68 00 00 40 00       	push   $0x400000
  802348:	6a 00                	push   $0x0
  80234a:	e8 8b ee ff ff       	call   8011da <sys_page_alloc>
  80234f:	83 c4 10             	add    $0x10,%esp
  802352:	85 c0                	test   %eax,%eax
  802354:	0f 88 f3 03 00 00    	js     80274d <spawn+0x56b>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80235a:	be 00 00 00 00       	mov    $0x0,%esi
  80235f:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  802365:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802368:	eb 30                	jmp    80239a <spawn+0x1b8>
		argv_store[i] = UTEMP2USTACK(string_store);
  80236a:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802370:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  802376:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  802379:	83 ec 08             	sub    $0x8,%esp
  80237c:	ff 34 b3             	pushl  (%ebx,%esi,4)
  80237f:	57                   	push   %edi
  802380:	e8 63 ea ff ff       	call   800de8 <strcpy>
		string_store += strlen(argv[i]) + 1;
  802385:	83 c4 04             	add    $0x4,%esp
  802388:	ff 34 b3             	pushl  (%ebx,%esi,4)
  80238b:	e8 1f ea ff ff       	call   800daf <strlen>
  802390:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  802394:	83 c6 01             	add    $0x1,%esi
  802397:	83 c4 10             	add    $0x10,%esp
  80239a:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  8023a0:	7f c8                	jg     80236a <spawn+0x188>
	}
	argv_store[argc] = 0;
  8023a2:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8023a8:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  8023ae:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8023b5:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  8023bb:	0f 85 86 00 00 00    	jne    802447 <spawn+0x265>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8023c1:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  8023c7:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  8023cd:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  8023d0:	89 d0                	mov    %edx,%eax
  8023d2:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  8023d8:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8023db:	2d 08 30 80 11       	sub    $0x11803008,%eax
  8023e0:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8023e6:	83 ec 0c             	sub    $0xc,%esp
  8023e9:	6a 07                	push   $0x7
  8023eb:	68 00 d0 bf ee       	push   $0xeebfd000
  8023f0:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8023f6:	68 00 00 40 00       	push   $0x400000
  8023fb:	6a 00                	push   $0x0
  8023fd:	e8 1b ee ff ff       	call   80121d <sys_page_map>
  802402:	89 c3                	mov    %eax,%ebx
  802404:	83 c4 20             	add    $0x20,%esp
  802407:	85 c0                	test   %eax,%eax
  802409:	0f 88 46 03 00 00    	js     802755 <spawn+0x573>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80240f:	83 ec 08             	sub    $0x8,%esp
  802412:	68 00 00 40 00       	push   $0x400000
  802417:	6a 00                	push   $0x0
  802419:	e8 41 ee ff ff       	call   80125f <sys_page_unmap>
  80241e:	89 c3                	mov    %eax,%ebx
  802420:	83 c4 10             	add    $0x10,%esp
  802423:	85 c0                	test   %eax,%eax
  802425:	0f 88 2a 03 00 00    	js     802755 <spawn+0x573>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  80242b:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  802431:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802438:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  80243f:	00 00 00 
  802442:	e9 4f 01 00 00       	jmp    802596 <spawn+0x3b4>
	assert(string_store == (char*)UTEMP + PGSIZE);
  802447:	68 f0 3b 80 00       	push   $0x803bf0
  80244c:	68 3b 3b 80 00       	push   $0x803b3b
  802451:	68 f8 00 00 00       	push   $0xf8
  802456:	68 81 3b 80 00       	push   $0x803b81
  80245b:	e8 33 e1 ff ff       	call   800593 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802460:	83 ec 04             	sub    $0x4,%esp
  802463:	6a 07                	push   $0x7
  802465:	68 00 00 40 00       	push   $0x400000
  80246a:	6a 00                	push   $0x0
  80246c:	e8 69 ed ff ff       	call   8011da <sys_page_alloc>
  802471:	83 c4 10             	add    $0x10,%esp
  802474:	85 c0                	test   %eax,%eax
  802476:	0f 88 b7 02 00 00    	js     802733 <spawn+0x551>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  80247c:	83 ec 08             	sub    $0x8,%esp
  80247f:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802485:	01 f0                	add    %esi,%eax
  802487:	50                   	push   %eax
  802488:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80248e:	e8 5a f9 ff ff       	call   801ded <seek>
  802493:	83 c4 10             	add    $0x10,%esp
  802496:	85 c0                	test   %eax,%eax
  802498:	0f 88 9c 02 00 00    	js     80273a <spawn+0x558>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80249e:	83 ec 04             	sub    $0x4,%esp
  8024a1:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8024a7:	29 f0                	sub    %esi,%eax
  8024a9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8024ae:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8024b3:	0f 47 c1             	cmova  %ecx,%eax
  8024b6:	50                   	push   %eax
  8024b7:	68 00 00 40 00       	push   $0x400000
  8024bc:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8024c2:	e8 5f f8 ff ff       	call   801d26 <readn>
  8024c7:	83 c4 10             	add    $0x10,%esp
  8024ca:	85 c0                	test   %eax,%eax
  8024cc:	0f 88 6f 02 00 00    	js     802741 <spawn+0x55f>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8024d2:	83 ec 0c             	sub    $0xc,%esp
  8024d5:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8024db:	53                   	push   %ebx
  8024dc:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  8024e2:	68 00 00 40 00       	push   $0x400000
  8024e7:	6a 00                	push   $0x0
  8024e9:	e8 2f ed ff ff       	call   80121d <sys_page_map>
  8024ee:	83 c4 20             	add    $0x20,%esp
  8024f1:	85 c0                	test   %eax,%eax
  8024f3:	78 7c                	js     802571 <spawn+0x38f>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  8024f5:	83 ec 08             	sub    $0x8,%esp
  8024f8:	68 00 00 40 00       	push   $0x400000
  8024fd:	6a 00                	push   $0x0
  8024ff:	e8 5b ed ff ff       	call   80125f <sys_page_unmap>
  802504:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  802507:	81 c7 00 10 00 00    	add    $0x1000,%edi
  80250d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802513:	89 fe                	mov    %edi,%esi
  802515:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  80251b:	76 69                	jbe    802586 <spawn+0x3a4>
		if (i >= filesz) {
  80251d:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  802523:	0f 87 37 ff ff ff    	ja     802460 <spawn+0x27e>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802529:	83 ec 04             	sub    $0x4,%esp
  80252c:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802532:	53                   	push   %ebx
  802533:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802539:	e8 9c ec ff ff       	call   8011da <sys_page_alloc>
  80253e:	83 c4 10             	add    $0x10,%esp
  802541:	85 c0                	test   %eax,%eax
  802543:	79 c2                	jns    802507 <spawn+0x325>
  802545:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  802547:	83 ec 0c             	sub    $0xc,%esp
  80254a:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802550:	e8 06 ec ff ff       	call   80115b <sys_env_destroy>
	close(fd);
  802555:	83 c4 04             	add    $0x4,%esp
  802558:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80255e:	e8 fe f5 ff ff       	call   801b61 <close>
	return r;
  802563:	83 c4 10             	add    $0x10,%esp
  802566:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  80256c:	e9 b4 01 00 00       	jmp    802725 <spawn+0x543>
				panic("spawn: sys_page_map data: %e", r);
  802571:	50                   	push   %eax
  802572:	68 8d 3b 80 00       	push   $0x803b8d
  802577:	68 2b 01 00 00       	push   $0x12b
  80257c:	68 81 3b 80 00       	push   $0x803b81
  802581:	e8 0d e0 ff ff       	call   800593 <_panic>
  802586:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80258c:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  802593:	83 c6 20             	add    $0x20,%esi
  802596:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  80259d:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  8025a3:	7e 6d                	jle    802612 <spawn+0x430>
		if (ph->p_type != ELF_PROG_LOAD)
  8025a5:	83 3e 01             	cmpl   $0x1,(%esi)
  8025a8:	75 e2                	jne    80258c <spawn+0x3aa>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8025aa:	8b 46 18             	mov    0x18(%esi),%eax
  8025ad:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  8025b0:	83 f8 01             	cmp    $0x1,%eax
  8025b3:	19 c0                	sbb    %eax,%eax
  8025b5:	83 e0 fe             	and    $0xfffffffe,%eax
  8025b8:	83 c0 07             	add    $0x7,%eax
  8025bb:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  8025c1:	8b 4e 04             	mov    0x4(%esi),%ecx
  8025c4:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  8025ca:	8b 56 10             	mov    0x10(%esi),%edx
  8025cd:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  8025d3:	8b 7e 14             	mov    0x14(%esi),%edi
  8025d6:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  8025dc:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  8025df:	89 d8                	mov    %ebx,%eax
  8025e1:	25 ff 0f 00 00       	and    $0xfff,%eax
  8025e6:	74 1a                	je     802602 <spawn+0x420>
		va -= i;
  8025e8:	29 c3                	sub    %eax,%ebx
		memsz += i;
  8025ea:	01 c7                	add    %eax,%edi
  8025ec:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  8025f2:	01 c2                	add    %eax,%edx
  8025f4:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  8025fa:	29 c1                	sub    %eax,%ecx
  8025fc:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  802602:	bf 00 00 00 00       	mov    $0x0,%edi
  802607:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  80260d:	e9 01 ff ff ff       	jmp    802513 <spawn+0x331>
	close(fd);
  802612:	83 ec 0c             	sub    $0xc,%esp
  802615:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80261b:	e8 41 f5 ff ff       	call   801b61 <close>

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	cprintf("in %s\n", __FUNCTION__);
  802620:	83 c4 08             	add    $0x8,%esp
  802623:	68 20 3c 80 00       	push   $0x803c20
  802628:	68 be 35 80 00       	push   $0x8035be
  80262d:	e8 57 e0 ff ff       	call   800689 <cprintf>
  802632:	83 c4 10             	add    $0x10,%esp
	int r;
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  802635:	bb 00 00 80 00       	mov    $0x800000,%ebx
  80263a:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  802640:	eb 0e                	jmp    802650 <spawn+0x46e>
  802642:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802648:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80264e:	74 5e                	je     8026ae <spawn+0x4cc>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_SHARE)) == (PTE_P | PTE_U | PTE_SHARE)))
  802650:	89 d8                	mov    %ebx,%eax
  802652:	c1 e8 16             	shr    $0x16,%eax
  802655:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80265c:	a8 01                	test   $0x1,%al
  80265e:	74 e2                	je     802642 <spawn+0x460>
  802660:	89 da                	mov    %ebx,%edx
  802662:	c1 ea 0c             	shr    $0xc,%edx
  802665:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80266c:	25 05 04 00 00       	and    $0x405,%eax
  802671:	3d 05 04 00 00       	cmp    $0x405,%eax
  802676:	75 ca                	jne    802642 <spawn+0x460>
			if((r = sys_page_map((envid_t)0, (void *)i, child, (void *)i, uvpt[PGNUM(i)] & PTE_SYSCALL)) < 0)
  802678:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80267f:	83 ec 0c             	sub    $0xc,%esp
  802682:	25 07 0e 00 00       	and    $0xe07,%eax
  802687:	50                   	push   %eax
  802688:	53                   	push   %ebx
  802689:	56                   	push   %esi
  80268a:	53                   	push   %ebx
  80268b:	6a 00                	push   $0x0
  80268d:	e8 8b eb ff ff       	call   80121d <sys_page_map>
  802692:	83 c4 20             	add    $0x20,%esp
  802695:	85 c0                	test   %eax,%eax
  802697:	79 a9                	jns    802642 <spawn+0x460>
        		panic("sys_page_map: %e\n", r);
  802699:	50                   	push   %eax
  80269a:	68 aa 3b 80 00       	push   $0x803baa
  80269f:	68 3b 01 00 00       	push   $0x13b
  8026a4:	68 81 3b 80 00       	push   $0x803b81
  8026a9:	e8 e5 de ff ff       	call   800593 <_panic>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8026ae:	83 ec 08             	sub    $0x8,%esp
  8026b1:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  8026b7:	50                   	push   %eax
  8026b8:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8026be:	e8 20 ec ff ff       	call   8012e3 <sys_env_set_trapframe>
  8026c3:	83 c4 10             	add    $0x10,%esp
  8026c6:	85 c0                	test   %eax,%eax
  8026c8:	78 25                	js     8026ef <spawn+0x50d>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8026ca:	83 ec 08             	sub    $0x8,%esp
  8026cd:	6a 02                	push   $0x2
  8026cf:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8026d5:	e8 c7 eb ff ff       	call   8012a1 <sys_env_set_status>
  8026da:	83 c4 10             	add    $0x10,%esp
  8026dd:	85 c0                	test   %eax,%eax
  8026df:	78 23                	js     802704 <spawn+0x522>
	return child;
  8026e1:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8026e7:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8026ed:	eb 36                	jmp    802725 <spawn+0x543>
		panic("sys_env_set_trapframe: %e", r);
  8026ef:	50                   	push   %eax
  8026f0:	68 bc 3b 80 00       	push   $0x803bbc
  8026f5:	68 8a 00 00 00       	push   $0x8a
  8026fa:	68 81 3b 80 00       	push   $0x803b81
  8026ff:	e8 8f de ff ff       	call   800593 <_panic>
		panic("sys_env_set_status: %e", r);
  802704:	50                   	push   %eax
  802705:	68 d6 3b 80 00       	push   $0x803bd6
  80270a:	68 8d 00 00 00       	push   $0x8d
  80270f:	68 81 3b 80 00       	push   $0x803b81
  802714:	e8 7a de ff ff       	call   800593 <_panic>
		return r;
  802719:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80271f:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  802725:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  80272b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80272e:	5b                   	pop    %ebx
  80272f:	5e                   	pop    %esi
  802730:	5f                   	pop    %edi
  802731:	5d                   	pop    %ebp
  802732:	c3                   	ret    
  802733:	89 c7                	mov    %eax,%edi
  802735:	e9 0d fe ff ff       	jmp    802547 <spawn+0x365>
  80273a:	89 c7                	mov    %eax,%edi
  80273c:	e9 06 fe ff ff       	jmp    802547 <spawn+0x365>
  802741:	89 c7                	mov    %eax,%edi
  802743:	e9 ff fd ff ff       	jmp    802547 <spawn+0x365>
		return -E_NO_MEM;
  802748:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  80274d:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802753:	eb d0                	jmp    802725 <spawn+0x543>
	sys_page_unmap(0, UTEMP);
  802755:	83 ec 08             	sub    $0x8,%esp
  802758:	68 00 00 40 00       	push   $0x400000
  80275d:	6a 00                	push   $0x0
  80275f:	e8 fb ea ff ff       	call   80125f <sys_page_unmap>
  802764:	83 c4 10             	add    $0x10,%esp
  802767:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  80276d:	eb b6                	jmp    802725 <spawn+0x543>

0080276f <spawnl>:
{
  80276f:	55                   	push   %ebp
  802770:	89 e5                	mov    %esp,%ebp
  802772:	57                   	push   %edi
  802773:	56                   	push   %esi
  802774:	53                   	push   %ebx
  802775:	83 ec 14             	sub    $0x14,%esp
	cprintf("in %s\n", __FUNCTION__);
  802778:	68 18 3c 80 00       	push   $0x803c18
  80277d:	68 be 35 80 00       	push   $0x8035be
  802782:	e8 02 df ff ff       	call   800689 <cprintf>
	va_start(vl, arg0);
  802787:	8d 55 10             	lea    0x10(%ebp),%edx
	while(va_arg(vl, void *) != NULL)
  80278a:	83 c4 10             	add    $0x10,%esp
	int argc=0;
  80278d:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  802792:	8d 4a 04             	lea    0x4(%edx),%ecx
  802795:	83 3a 00             	cmpl   $0x0,(%edx)
  802798:	74 07                	je     8027a1 <spawnl+0x32>
		argc++;
  80279a:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  80279d:	89 ca                	mov    %ecx,%edx
  80279f:	eb f1                	jmp    802792 <spawnl+0x23>
	const char *argv[argc+2];
  8027a1:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  8027a8:	83 e2 f0             	and    $0xfffffff0,%edx
  8027ab:	29 d4                	sub    %edx,%esp
  8027ad:	8d 54 24 03          	lea    0x3(%esp),%edx
  8027b1:	c1 ea 02             	shr    $0x2,%edx
  8027b4:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  8027bb:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  8027bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027c0:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  8027c7:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  8027ce:	00 
	va_start(vl, arg0);
  8027cf:	8d 4d 10             	lea    0x10(%ebp),%ecx
  8027d2:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  8027d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d9:	eb 0b                	jmp    8027e6 <spawnl+0x77>
		argv[i+1] = va_arg(vl, const char *);
  8027db:	83 c0 01             	add    $0x1,%eax
  8027de:	8b 39                	mov    (%ecx),%edi
  8027e0:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  8027e3:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  8027e6:	39 d0                	cmp    %edx,%eax
  8027e8:	75 f1                	jne    8027db <spawnl+0x6c>
	return spawn(prog, argv);
  8027ea:	83 ec 08             	sub    $0x8,%esp
  8027ed:	56                   	push   %esi
  8027ee:	ff 75 08             	pushl  0x8(%ebp)
  8027f1:	e8 ec f9 ff ff       	call   8021e2 <spawn>
}
  8027f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027f9:	5b                   	pop    %ebx
  8027fa:	5e                   	pop    %esi
  8027fb:	5f                   	pop    %edi
  8027fc:	5d                   	pop    %ebp
  8027fd:	c3                   	ret    

008027fe <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8027fe:	55                   	push   %ebp
  8027ff:	89 e5                	mov    %esp,%ebp
  802801:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  802804:	68 46 3c 80 00       	push   $0x803c46
  802809:	ff 75 0c             	pushl  0xc(%ebp)
  80280c:	e8 d7 e5 ff ff       	call   800de8 <strcpy>
	return 0;
}
  802811:	b8 00 00 00 00       	mov    $0x0,%eax
  802816:	c9                   	leave  
  802817:	c3                   	ret    

00802818 <devsock_close>:
{
  802818:	55                   	push   %ebp
  802819:	89 e5                	mov    %esp,%ebp
  80281b:	53                   	push   %ebx
  80281c:	83 ec 10             	sub    $0x10,%esp
  80281f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  802822:	53                   	push   %ebx
  802823:	e8 6b 09 00 00       	call   803193 <pageref>
  802828:	83 c4 10             	add    $0x10,%esp
		return 0;
  80282b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  802830:	83 f8 01             	cmp    $0x1,%eax
  802833:	74 07                	je     80283c <devsock_close+0x24>
}
  802835:	89 d0                	mov    %edx,%eax
  802837:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80283a:	c9                   	leave  
  80283b:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80283c:	83 ec 0c             	sub    $0xc,%esp
  80283f:	ff 73 0c             	pushl  0xc(%ebx)
  802842:	e8 b9 02 00 00       	call   802b00 <nsipc_close>
  802847:	89 c2                	mov    %eax,%edx
  802849:	83 c4 10             	add    $0x10,%esp
  80284c:	eb e7                	jmp    802835 <devsock_close+0x1d>

0080284e <devsock_write>:
{
  80284e:	55                   	push   %ebp
  80284f:	89 e5                	mov    %esp,%ebp
  802851:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802854:	6a 00                	push   $0x0
  802856:	ff 75 10             	pushl  0x10(%ebp)
  802859:	ff 75 0c             	pushl  0xc(%ebp)
  80285c:	8b 45 08             	mov    0x8(%ebp),%eax
  80285f:	ff 70 0c             	pushl  0xc(%eax)
  802862:	e8 76 03 00 00       	call   802bdd <nsipc_send>
}
  802867:	c9                   	leave  
  802868:	c3                   	ret    

00802869 <devsock_read>:
{
  802869:	55                   	push   %ebp
  80286a:	89 e5                	mov    %esp,%ebp
  80286c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80286f:	6a 00                	push   $0x0
  802871:	ff 75 10             	pushl  0x10(%ebp)
  802874:	ff 75 0c             	pushl  0xc(%ebp)
  802877:	8b 45 08             	mov    0x8(%ebp),%eax
  80287a:	ff 70 0c             	pushl  0xc(%eax)
  80287d:	e8 ef 02 00 00       	call   802b71 <nsipc_recv>
}
  802882:	c9                   	leave  
  802883:	c3                   	ret    

00802884 <fd2sockid>:
{
  802884:	55                   	push   %ebp
  802885:	89 e5                	mov    %esp,%ebp
  802887:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80288a:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80288d:	52                   	push   %edx
  80288e:	50                   	push   %eax
  80288f:	e8 9b f1 ff ff       	call   801a2f <fd_lookup>
  802894:	83 c4 10             	add    $0x10,%esp
  802897:	85 c0                	test   %eax,%eax
  802899:	78 10                	js     8028ab <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80289b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289e:	8b 0d 3c 40 80 00    	mov    0x80403c,%ecx
  8028a4:	39 08                	cmp    %ecx,(%eax)
  8028a6:	75 05                	jne    8028ad <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8028a8:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8028ab:	c9                   	leave  
  8028ac:	c3                   	ret    
		return -E_NOT_SUPP;
  8028ad:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8028b2:	eb f7                	jmp    8028ab <fd2sockid+0x27>

008028b4 <alloc_sockfd>:
{
  8028b4:	55                   	push   %ebp
  8028b5:	89 e5                	mov    %esp,%ebp
  8028b7:	56                   	push   %esi
  8028b8:	53                   	push   %ebx
  8028b9:	83 ec 1c             	sub    $0x1c,%esp
  8028bc:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8028be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028c1:	50                   	push   %eax
  8028c2:	e8 16 f1 ff ff       	call   8019dd <fd_alloc>
  8028c7:	89 c3                	mov    %eax,%ebx
  8028c9:	83 c4 10             	add    $0x10,%esp
  8028cc:	85 c0                	test   %eax,%eax
  8028ce:	78 43                	js     802913 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8028d0:	83 ec 04             	sub    $0x4,%esp
  8028d3:	68 07 04 00 00       	push   $0x407
  8028d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8028db:	6a 00                	push   $0x0
  8028dd:	e8 f8 e8 ff ff       	call   8011da <sys_page_alloc>
  8028e2:	89 c3                	mov    %eax,%ebx
  8028e4:	83 c4 10             	add    $0x10,%esp
  8028e7:	85 c0                	test   %eax,%eax
  8028e9:	78 28                	js     802913 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8028eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ee:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8028f4:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8028f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802900:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802903:	83 ec 0c             	sub    $0xc,%esp
  802906:	50                   	push   %eax
  802907:	e8 aa f0 ff ff       	call   8019b6 <fd2num>
  80290c:	89 c3                	mov    %eax,%ebx
  80290e:	83 c4 10             	add    $0x10,%esp
  802911:	eb 0c                	jmp    80291f <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802913:	83 ec 0c             	sub    $0xc,%esp
  802916:	56                   	push   %esi
  802917:	e8 e4 01 00 00       	call   802b00 <nsipc_close>
		return r;
  80291c:	83 c4 10             	add    $0x10,%esp
}
  80291f:	89 d8                	mov    %ebx,%eax
  802921:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802924:	5b                   	pop    %ebx
  802925:	5e                   	pop    %esi
  802926:	5d                   	pop    %ebp
  802927:	c3                   	ret    

00802928 <accept>:
{
  802928:	55                   	push   %ebp
  802929:	89 e5                	mov    %esp,%ebp
  80292b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80292e:	8b 45 08             	mov    0x8(%ebp),%eax
  802931:	e8 4e ff ff ff       	call   802884 <fd2sockid>
  802936:	85 c0                	test   %eax,%eax
  802938:	78 1b                	js     802955 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80293a:	83 ec 04             	sub    $0x4,%esp
  80293d:	ff 75 10             	pushl  0x10(%ebp)
  802940:	ff 75 0c             	pushl  0xc(%ebp)
  802943:	50                   	push   %eax
  802944:	e8 0e 01 00 00       	call   802a57 <nsipc_accept>
  802949:	83 c4 10             	add    $0x10,%esp
  80294c:	85 c0                	test   %eax,%eax
  80294e:	78 05                	js     802955 <accept+0x2d>
	return alloc_sockfd(r);
  802950:	e8 5f ff ff ff       	call   8028b4 <alloc_sockfd>
}
  802955:	c9                   	leave  
  802956:	c3                   	ret    

00802957 <bind>:
{
  802957:	55                   	push   %ebp
  802958:	89 e5                	mov    %esp,%ebp
  80295a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80295d:	8b 45 08             	mov    0x8(%ebp),%eax
  802960:	e8 1f ff ff ff       	call   802884 <fd2sockid>
  802965:	85 c0                	test   %eax,%eax
  802967:	78 12                	js     80297b <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802969:	83 ec 04             	sub    $0x4,%esp
  80296c:	ff 75 10             	pushl  0x10(%ebp)
  80296f:	ff 75 0c             	pushl  0xc(%ebp)
  802972:	50                   	push   %eax
  802973:	e8 31 01 00 00       	call   802aa9 <nsipc_bind>
  802978:	83 c4 10             	add    $0x10,%esp
}
  80297b:	c9                   	leave  
  80297c:	c3                   	ret    

0080297d <shutdown>:
{
  80297d:	55                   	push   %ebp
  80297e:	89 e5                	mov    %esp,%ebp
  802980:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802983:	8b 45 08             	mov    0x8(%ebp),%eax
  802986:	e8 f9 fe ff ff       	call   802884 <fd2sockid>
  80298b:	85 c0                	test   %eax,%eax
  80298d:	78 0f                	js     80299e <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80298f:	83 ec 08             	sub    $0x8,%esp
  802992:	ff 75 0c             	pushl  0xc(%ebp)
  802995:	50                   	push   %eax
  802996:	e8 43 01 00 00       	call   802ade <nsipc_shutdown>
  80299b:	83 c4 10             	add    $0x10,%esp
}
  80299e:	c9                   	leave  
  80299f:	c3                   	ret    

008029a0 <connect>:
{
  8029a0:	55                   	push   %ebp
  8029a1:	89 e5                	mov    %esp,%ebp
  8029a3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8029a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a9:	e8 d6 fe ff ff       	call   802884 <fd2sockid>
  8029ae:	85 c0                	test   %eax,%eax
  8029b0:	78 12                	js     8029c4 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8029b2:	83 ec 04             	sub    $0x4,%esp
  8029b5:	ff 75 10             	pushl  0x10(%ebp)
  8029b8:	ff 75 0c             	pushl  0xc(%ebp)
  8029bb:	50                   	push   %eax
  8029bc:	e8 59 01 00 00       	call   802b1a <nsipc_connect>
  8029c1:	83 c4 10             	add    $0x10,%esp
}
  8029c4:	c9                   	leave  
  8029c5:	c3                   	ret    

008029c6 <listen>:
{
  8029c6:	55                   	push   %ebp
  8029c7:	89 e5                	mov    %esp,%ebp
  8029c9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8029cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cf:	e8 b0 fe ff ff       	call   802884 <fd2sockid>
  8029d4:	85 c0                	test   %eax,%eax
  8029d6:	78 0f                	js     8029e7 <listen+0x21>
	return nsipc_listen(r, backlog);
  8029d8:	83 ec 08             	sub    $0x8,%esp
  8029db:	ff 75 0c             	pushl  0xc(%ebp)
  8029de:	50                   	push   %eax
  8029df:	e8 6b 01 00 00       	call   802b4f <nsipc_listen>
  8029e4:	83 c4 10             	add    $0x10,%esp
}
  8029e7:	c9                   	leave  
  8029e8:	c3                   	ret    

008029e9 <socket>:

int
socket(int domain, int type, int protocol)
{
  8029e9:	55                   	push   %ebp
  8029ea:	89 e5                	mov    %esp,%ebp
  8029ec:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8029ef:	ff 75 10             	pushl  0x10(%ebp)
  8029f2:	ff 75 0c             	pushl  0xc(%ebp)
  8029f5:	ff 75 08             	pushl  0x8(%ebp)
  8029f8:	e8 3e 02 00 00       	call   802c3b <nsipc_socket>
  8029fd:	83 c4 10             	add    $0x10,%esp
  802a00:	85 c0                	test   %eax,%eax
  802a02:	78 05                	js     802a09 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802a04:	e8 ab fe ff ff       	call   8028b4 <alloc_sockfd>
}
  802a09:	c9                   	leave  
  802a0a:	c3                   	ret    

00802a0b <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802a0b:	55                   	push   %ebp
  802a0c:	89 e5                	mov    %esp,%ebp
  802a0e:	53                   	push   %ebx
  802a0f:	83 ec 04             	sub    $0x4,%esp
  802a12:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802a14:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802a1b:	74 26                	je     802a43 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802a1d:	6a 07                	push   $0x7
  802a1f:	68 00 70 80 00       	push   $0x807000
  802a24:	53                   	push   %ebx
  802a25:	ff 35 04 50 80 00    	pushl  0x805004
  802a2b:	e8 d0 06 00 00       	call   803100 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802a30:	83 c4 0c             	add    $0xc,%esp
  802a33:	6a 00                	push   $0x0
  802a35:	6a 00                	push   $0x0
  802a37:	6a 00                	push   $0x0
  802a39:	e8 59 06 00 00       	call   803097 <ipc_recv>
}
  802a3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802a41:	c9                   	leave  
  802a42:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802a43:	83 ec 0c             	sub    $0xc,%esp
  802a46:	6a 02                	push   $0x2
  802a48:	e8 0b 07 00 00       	call   803158 <ipc_find_env>
  802a4d:	a3 04 50 80 00       	mov    %eax,0x805004
  802a52:	83 c4 10             	add    $0x10,%esp
  802a55:	eb c6                	jmp    802a1d <nsipc+0x12>

00802a57 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802a57:	55                   	push   %ebp
  802a58:	89 e5                	mov    %esp,%ebp
  802a5a:	56                   	push   %esi
  802a5b:	53                   	push   %ebx
  802a5c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a62:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802a67:	8b 06                	mov    (%esi),%eax
  802a69:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802a6e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a73:	e8 93 ff ff ff       	call   802a0b <nsipc>
  802a78:	89 c3                	mov    %eax,%ebx
  802a7a:	85 c0                	test   %eax,%eax
  802a7c:	79 09                	jns    802a87 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802a7e:	89 d8                	mov    %ebx,%eax
  802a80:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a83:	5b                   	pop    %ebx
  802a84:	5e                   	pop    %esi
  802a85:	5d                   	pop    %ebp
  802a86:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802a87:	83 ec 04             	sub    $0x4,%esp
  802a8a:	ff 35 10 70 80 00    	pushl  0x807010
  802a90:	68 00 70 80 00       	push   $0x807000
  802a95:	ff 75 0c             	pushl  0xc(%ebp)
  802a98:	e8 d9 e4 ff ff       	call   800f76 <memmove>
		*addrlen = ret->ret_addrlen;
  802a9d:	a1 10 70 80 00       	mov    0x807010,%eax
  802aa2:	89 06                	mov    %eax,(%esi)
  802aa4:	83 c4 10             	add    $0x10,%esp
	return r;
  802aa7:	eb d5                	jmp    802a7e <nsipc_accept+0x27>

00802aa9 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802aa9:	55                   	push   %ebp
  802aaa:	89 e5                	mov    %esp,%ebp
  802aac:	53                   	push   %ebx
  802aad:	83 ec 08             	sub    $0x8,%esp
  802ab0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab6:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802abb:	53                   	push   %ebx
  802abc:	ff 75 0c             	pushl  0xc(%ebp)
  802abf:	68 04 70 80 00       	push   $0x807004
  802ac4:	e8 ad e4 ff ff       	call   800f76 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802ac9:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802acf:	b8 02 00 00 00       	mov    $0x2,%eax
  802ad4:	e8 32 ff ff ff       	call   802a0b <nsipc>
}
  802ad9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802adc:	c9                   	leave  
  802add:	c3                   	ret    

00802ade <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802ade:	55                   	push   %ebp
  802adf:	89 e5                	mov    %esp,%ebp
  802ae1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802aec:	8b 45 0c             	mov    0xc(%ebp),%eax
  802aef:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802af4:	b8 03 00 00 00       	mov    $0x3,%eax
  802af9:	e8 0d ff ff ff       	call   802a0b <nsipc>
}
  802afe:	c9                   	leave  
  802aff:	c3                   	ret    

00802b00 <nsipc_close>:

int
nsipc_close(int s)
{
  802b00:	55                   	push   %ebp
  802b01:	89 e5                	mov    %esp,%ebp
  802b03:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802b06:	8b 45 08             	mov    0x8(%ebp),%eax
  802b09:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802b0e:	b8 04 00 00 00       	mov    $0x4,%eax
  802b13:	e8 f3 fe ff ff       	call   802a0b <nsipc>
}
  802b18:	c9                   	leave  
  802b19:	c3                   	ret    

00802b1a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802b1a:	55                   	push   %ebp
  802b1b:	89 e5                	mov    %esp,%ebp
  802b1d:	53                   	push   %ebx
  802b1e:	83 ec 08             	sub    $0x8,%esp
  802b21:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802b24:	8b 45 08             	mov    0x8(%ebp),%eax
  802b27:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802b2c:	53                   	push   %ebx
  802b2d:	ff 75 0c             	pushl  0xc(%ebp)
  802b30:	68 04 70 80 00       	push   $0x807004
  802b35:	e8 3c e4 ff ff       	call   800f76 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802b3a:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802b40:	b8 05 00 00 00       	mov    $0x5,%eax
  802b45:	e8 c1 fe ff ff       	call   802a0b <nsipc>
}
  802b4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b4d:	c9                   	leave  
  802b4e:	c3                   	ret    

00802b4f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802b4f:	55                   	push   %ebp
  802b50:	89 e5                	mov    %esp,%ebp
  802b52:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802b55:	8b 45 08             	mov    0x8(%ebp),%eax
  802b58:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b60:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802b65:	b8 06 00 00 00       	mov    $0x6,%eax
  802b6a:	e8 9c fe ff ff       	call   802a0b <nsipc>
}
  802b6f:	c9                   	leave  
  802b70:	c3                   	ret    

00802b71 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802b71:	55                   	push   %ebp
  802b72:	89 e5                	mov    %esp,%ebp
  802b74:	56                   	push   %esi
  802b75:	53                   	push   %ebx
  802b76:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802b79:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802b81:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802b87:	8b 45 14             	mov    0x14(%ebp),%eax
  802b8a:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802b8f:	b8 07 00 00 00       	mov    $0x7,%eax
  802b94:	e8 72 fe ff ff       	call   802a0b <nsipc>
  802b99:	89 c3                	mov    %eax,%ebx
  802b9b:	85 c0                	test   %eax,%eax
  802b9d:	78 1f                	js     802bbe <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802b9f:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802ba4:	7f 21                	jg     802bc7 <nsipc_recv+0x56>
  802ba6:	39 c6                	cmp    %eax,%esi
  802ba8:	7c 1d                	jl     802bc7 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802baa:	83 ec 04             	sub    $0x4,%esp
  802bad:	50                   	push   %eax
  802bae:	68 00 70 80 00       	push   $0x807000
  802bb3:	ff 75 0c             	pushl  0xc(%ebp)
  802bb6:	e8 bb e3 ff ff       	call   800f76 <memmove>
  802bbb:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802bbe:	89 d8                	mov    %ebx,%eax
  802bc0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802bc3:	5b                   	pop    %ebx
  802bc4:	5e                   	pop    %esi
  802bc5:	5d                   	pop    %ebp
  802bc6:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802bc7:	68 52 3c 80 00       	push   $0x803c52
  802bcc:	68 3b 3b 80 00       	push   $0x803b3b
  802bd1:	6a 62                	push   $0x62
  802bd3:	68 67 3c 80 00       	push   $0x803c67
  802bd8:	e8 b6 d9 ff ff       	call   800593 <_panic>

00802bdd <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802bdd:	55                   	push   %ebp
  802bde:	89 e5                	mov    %esp,%ebp
  802be0:	53                   	push   %ebx
  802be1:	83 ec 04             	sub    $0x4,%esp
  802be4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802be7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bea:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802bef:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802bf5:	7f 2e                	jg     802c25 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802bf7:	83 ec 04             	sub    $0x4,%esp
  802bfa:	53                   	push   %ebx
  802bfb:	ff 75 0c             	pushl  0xc(%ebp)
  802bfe:	68 0c 70 80 00       	push   $0x80700c
  802c03:	e8 6e e3 ff ff       	call   800f76 <memmove>
	nsipcbuf.send.req_size = size;
  802c08:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802c0e:	8b 45 14             	mov    0x14(%ebp),%eax
  802c11:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802c16:	b8 08 00 00 00       	mov    $0x8,%eax
  802c1b:	e8 eb fd ff ff       	call   802a0b <nsipc>
}
  802c20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802c23:	c9                   	leave  
  802c24:	c3                   	ret    
	assert(size < 1600);
  802c25:	68 73 3c 80 00       	push   $0x803c73
  802c2a:	68 3b 3b 80 00       	push   $0x803b3b
  802c2f:	6a 6d                	push   $0x6d
  802c31:	68 67 3c 80 00       	push   $0x803c67
  802c36:	e8 58 d9 ff ff       	call   800593 <_panic>

00802c3b <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802c3b:	55                   	push   %ebp
  802c3c:	89 e5                	mov    %esp,%ebp
  802c3e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802c41:	8b 45 08             	mov    0x8(%ebp),%eax
  802c44:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802c49:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c4c:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802c51:	8b 45 10             	mov    0x10(%ebp),%eax
  802c54:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802c59:	b8 09 00 00 00       	mov    $0x9,%eax
  802c5e:	e8 a8 fd ff ff       	call   802a0b <nsipc>
}
  802c63:	c9                   	leave  
  802c64:	c3                   	ret    

00802c65 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802c65:	55                   	push   %ebp
  802c66:	89 e5                	mov    %esp,%ebp
  802c68:	56                   	push   %esi
  802c69:	53                   	push   %ebx
  802c6a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802c6d:	83 ec 0c             	sub    $0xc,%esp
  802c70:	ff 75 08             	pushl  0x8(%ebp)
  802c73:	e8 4e ed ff ff       	call   8019c6 <fd2data>
  802c78:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802c7a:	83 c4 08             	add    $0x8,%esp
  802c7d:	68 7f 3c 80 00       	push   $0x803c7f
  802c82:	53                   	push   %ebx
  802c83:	e8 60 e1 ff ff       	call   800de8 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802c88:	8b 46 04             	mov    0x4(%esi),%eax
  802c8b:	2b 06                	sub    (%esi),%eax
  802c8d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802c93:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802c9a:	00 00 00 
	stat->st_dev = &devpipe;
  802c9d:	c7 83 88 00 00 00 58 	movl   $0x804058,0x88(%ebx)
  802ca4:	40 80 00 
	return 0;
}
  802ca7:	b8 00 00 00 00       	mov    $0x0,%eax
  802cac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802caf:	5b                   	pop    %ebx
  802cb0:	5e                   	pop    %esi
  802cb1:	5d                   	pop    %ebp
  802cb2:	c3                   	ret    

00802cb3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802cb3:	55                   	push   %ebp
  802cb4:	89 e5                	mov    %esp,%ebp
  802cb6:	53                   	push   %ebx
  802cb7:	83 ec 0c             	sub    $0xc,%esp
  802cba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802cbd:	53                   	push   %ebx
  802cbe:	6a 00                	push   $0x0
  802cc0:	e8 9a e5 ff ff       	call   80125f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802cc5:	89 1c 24             	mov    %ebx,(%esp)
  802cc8:	e8 f9 ec ff ff       	call   8019c6 <fd2data>
  802ccd:	83 c4 08             	add    $0x8,%esp
  802cd0:	50                   	push   %eax
  802cd1:	6a 00                	push   $0x0
  802cd3:	e8 87 e5 ff ff       	call   80125f <sys_page_unmap>
}
  802cd8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802cdb:	c9                   	leave  
  802cdc:	c3                   	ret    

00802cdd <_pipeisclosed>:
{
  802cdd:	55                   	push   %ebp
  802cde:	89 e5                	mov    %esp,%ebp
  802ce0:	57                   	push   %edi
  802ce1:	56                   	push   %esi
  802ce2:	53                   	push   %ebx
  802ce3:	83 ec 1c             	sub    $0x1c,%esp
  802ce6:	89 c7                	mov    %eax,%edi
  802ce8:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802cea:	a1 08 50 80 00       	mov    0x805008,%eax
  802cef:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802cf2:	83 ec 0c             	sub    $0xc,%esp
  802cf5:	57                   	push   %edi
  802cf6:	e8 98 04 00 00       	call   803193 <pageref>
  802cfb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802cfe:	89 34 24             	mov    %esi,(%esp)
  802d01:	e8 8d 04 00 00       	call   803193 <pageref>
		nn = thisenv->env_runs;
  802d06:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802d0c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802d0f:	83 c4 10             	add    $0x10,%esp
  802d12:	39 cb                	cmp    %ecx,%ebx
  802d14:	74 1b                	je     802d31 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802d16:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802d19:	75 cf                	jne    802cea <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802d1b:	8b 42 58             	mov    0x58(%edx),%eax
  802d1e:	6a 01                	push   $0x1
  802d20:	50                   	push   %eax
  802d21:	53                   	push   %ebx
  802d22:	68 86 3c 80 00       	push   $0x803c86
  802d27:	e8 5d d9 ff ff       	call   800689 <cprintf>
  802d2c:	83 c4 10             	add    $0x10,%esp
  802d2f:	eb b9                	jmp    802cea <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802d31:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802d34:	0f 94 c0             	sete   %al
  802d37:	0f b6 c0             	movzbl %al,%eax
}
  802d3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d3d:	5b                   	pop    %ebx
  802d3e:	5e                   	pop    %esi
  802d3f:	5f                   	pop    %edi
  802d40:	5d                   	pop    %ebp
  802d41:	c3                   	ret    

00802d42 <devpipe_write>:
{
  802d42:	55                   	push   %ebp
  802d43:	89 e5                	mov    %esp,%ebp
  802d45:	57                   	push   %edi
  802d46:	56                   	push   %esi
  802d47:	53                   	push   %ebx
  802d48:	83 ec 28             	sub    $0x28,%esp
  802d4b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802d4e:	56                   	push   %esi
  802d4f:	e8 72 ec ff ff       	call   8019c6 <fd2data>
  802d54:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802d56:	83 c4 10             	add    $0x10,%esp
  802d59:	bf 00 00 00 00       	mov    $0x0,%edi
  802d5e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802d61:	74 4f                	je     802db2 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802d63:	8b 43 04             	mov    0x4(%ebx),%eax
  802d66:	8b 0b                	mov    (%ebx),%ecx
  802d68:	8d 51 20             	lea    0x20(%ecx),%edx
  802d6b:	39 d0                	cmp    %edx,%eax
  802d6d:	72 14                	jb     802d83 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802d6f:	89 da                	mov    %ebx,%edx
  802d71:	89 f0                	mov    %esi,%eax
  802d73:	e8 65 ff ff ff       	call   802cdd <_pipeisclosed>
  802d78:	85 c0                	test   %eax,%eax
  802d7a:	75 3b                	jne    802db7 <devpipe_write+0x75>
			sys_yield();
  802d7c:	e8 3a e4 ff ff       	call   8011bb <sys_yield>
  802d81:	eb e0                	jmp    802d63 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802d83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802d86:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802d8a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802d8d:	89 c2                	mov    %eax,%edx
  802d8f:	c1 fa 1f             	sar    $0x1f,%edx
  802d92:	89 d1                	mov    %edx,%ecx
  802d94:	c1 e9 1b             	shr    $0x1b,%ecx
  802d97:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802d9a:	83 e2 1f             	and    $0x1f,%edx
  802d9d:	29 ca                	sub    %ecx,%edx
  802d9f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802da3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802da7:	83 c0 01             	add    $0x1,%eax
  802daa:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802dad:	83 c7 01             	add    $0x1,%edi
  802db0:	eb ac                	jmp    802d5e <devpipe_write+0x1c>
	return i;
  802db2:	8b 45 10             	mov    0x10(%ebp),%eax
  802db5:	eb 05                	jmp    802dbc <devpipe_write+0x7a>
				return 0;
  802db7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802dbf:	5b                   	pop    %ebx
  802dc0:	5e                   	pop    %esi
  802dc1:	5f                   	pop    %edi
  802dc2:	5d                   	pop    %ebp
  802dc3:	c3                   	ret    

00802dc4 <devpipe_read>:
{
  802dc4:	55                   	push   %ebp
  802dc5:	89 e5                	mov    %esp,%ebp
  802dc7:	57                   	push   %edi
  802dc8:	56                   	push   %esi
  802dc9:	53                   	push   %ebx
  802dca:	83 ec 18             	sub    $0x18,%esp
  802dcd:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802dd0:	57                   	push   %edi
  802dd1:	e8 f0 eb ff ff       	call   8019c6 <fd2data>
  802dd6:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802dd8:	83 c4 10             	add    $0x10,%esp
  802ddb:	be 00 00 00 00       	mov    $0x0,%esi
  802de0:	3b 75 10             	cmp    0x10(%ebp),%esi
  802de3:	75 14                	jne    802df9 <devpipe_read+0x35>
	return i;
  802de5:	8b 45 10             	mov    0x10(%ebp),%eax
  802de8:	eb 02                	jmp    802dec <devpipe_read+0x28>
				return i;
  802dea:	89 f0                	mov    %esi,%eax
}
  802dec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802def:	5b                   	pop    %ebx
  802df0:	5e                   	pop    %esi
  802df1:	5f                   	pop    %edi
  802df2:	5d                   	pop    %ebp
  802df3:	c3                   	ret    
			sys_yield();
  802df4:	e8 c2 e3 ff ff       	call   8011bb <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802df9:	8b 03                	mov    (%ebx),%eax
  802dfb:	3b 43 04             	cmp    0x4(%ebx),%eax
  802dfe:	75 18                	jne    802e18 <devpipe_read+0x54>
			if (i > 0)
  802e00:	85 f6                	test   %esi,%esi
  802e02:	75 e6                	jne    802dea <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802e04:	89 da                	mov    %ebx,%edx
  802e06:	89 f8                	mov    %edi,%eax
  802e08:	e8 d0 fe ff ff       	call   802cdd <_pipeisclosed>
  802e0d:	85 c0                	test   %eax,%eax
  802e0f:	74 e3                	je     802df4 <devpipe_read+0x30>
				return 0;
  802e11:	b8 00 00 00 00       	mov    $0x0,%eax
  802e16:	eb d4                	jmp    802dec <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802e18:	99                   	cltd   
  802e19:	c1 ea 1b             	shr    $0x1b,%edx
  802e1c:	01 d0                	add    %edx,%eax
  802e1e:	83 e0 1f             	and    $0x1f,%eax
  802e21:	29 d0                	sub    %edx,%eax
  802e23:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802e28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802e2b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802e2e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802e31:	83 c6 01             	add    $0x1,%esi
  802e34:	eb aa                	jmp    802de0 <devpipe_read+0x1c>

00802e36 <pipe>:
{
  802e36:	55                   	push   %ebp
  802e37:	89 e5                	mov    %esp,%ebp
  802e39:	56                   	push   %esi
  802e3a:	53                   	push   %ebx
  802e3b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802e3e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e41:	50                   	push   %eax
  802e42:	e8 96 eb ff ff       	call   8019dd <fd_alloc>
  802e47:	89 c3                	mov    %eax,%ebx
  802e49:	83 c4 10             	add    $0x10,%esp
  802e4c:	85 c0                	test   %eax,%eax
  802e4e:	0f 88 23 01 00 00    	js     802f77 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e54:	83 ec 04             	sub    $0x4,%esp
  802e57:	68 07 04 00 00       	push   $0x407
  802e5c:	ff 75 f4             	pushl  -0xc(%ebp)
  802e5f:	6a 00                	push   $0x0
  802e61:	e8 74 e3 ff ff       	call   8011da <sys_page_alloc>
  802e66:	89 c3                	mov    %eax,%ebx
  802e68:	83 c4 10             	add    $0x10,%esp
  802e6b:	85 c0                	test   %eax,%eax
  802e6d:	0f 88 04 01 00 00    	js     802f77 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802e73:	83 ec 0c             	sub    $0xc,%esp
  802e76:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802e79:	50                   	push   %eax
  802e7a:	e8 5e eb ff ff       	call   8019dd <fd_alloc>
  802e7f:	89 c3                	mov    %eax,%ebx
  802e81:	83 c4 10             	add    $0x10,%esp
  802e84:	85 c0                	test   %eax,%eax
  802e86:	0f 88 db 00 00 00    	js     802f67 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e8c:	83 ec 04             	sub    $0x4,%esp
  802e8f:	68 07 04 00 00       	push   $0x407
  802e94:	ff 75 f0             	pushl  -0x10(%ebp)
  802e97:	6a 00                	push   $0x0
  802e99:	e8 3c e3 ff ff       	call   8011da <sys_page_alloc>
  802e9e:	89 c3                	mov    %eax,%ebx
  802ea0:	83 c4 10             	add    $0x10,%esp
  802ea3:	85 c0                	test   %eax,%eax
  802ea5:	0f 88 bc 00 00 00    	js     802f67 <pipe+0x131>
	va = fd2data(fd0);
  802eab:	83 ec 0c             	sub    $0xc,%esp
  802eae:	ff 75 f4             	pushl  -0xc(%ebp)
  802eb1:	e8 10 eb ff ff       	call   8019c6 <fd2data>
  802eb6:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802eb8:	83 c4 0c             	add    $0xc,%esp
  802ebb:	68 07 04 00 00       	push   $0x407
  802ec0:	50                   	push   %eax
  802ec1:	6a 00                	push   $0x0
  802ec3:	e8 12 e3 ff ff       	call   8011da <sys_page_alloc>
  802ec8:	89 c3                	mov    %eax,%ebx
  802eca:	83 c4 10             	add    $0x10,%esp
  802ecd:	85 c0                	test   %eax,%eax
  802ecf:	0f 88 82 00 00 00    	js     802f57 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ed5:	83 ec 0c             	sub    $0xc,%esp
  802ed8:	ff 75 f0             	pushl  -0x10(%ebp)
  802edb:	e8 e6 ea ff ff       	call   8019c6 <fd2data>
  802ee0:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802ee7:	50                   	push   %eax
  802ee8:	6a 00                	push   $0x0
  802eea:	56                   	push   %esi
  802eeb:	6a 00                	push   $0x0
  802eed:	e8 2b e3 ff ff       	call   80121d <sys_page_map>
  802ef2:	89 c3                	mov    %eax,%ebx
  802ef4:	83 c4 20             	add    $0x20,%esp
  802ef7:	85 c0                	test   %eax,%eax
  802ef9:	78 4e                	js     802f49 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802efb:	a1 58 40 80 00       	mov    0x804058,%eax
  802f00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f03:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802f05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f08:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802f0f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f12:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802f14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f17:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802f1e:	83 ec 0c             	sub    $0xc,%esp
  802f21:	ff 75 f4             	pushl  -0xc(%ebp)
  802f24:	e8 8d ea ff ff       	call   8019b6 <fd2num>
  802f29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802f2c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802f2e:	83 c4 04             	add    $0x4,%esp
  802f31:	ff 75 f0             	pushl  -0x10(%ebp)
  802f34:	e8 7d ea ff ff       	call   8019b6 <fd2num>
  802f39:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802f3c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802f3f:	83 c4 10             	add    $0x10,%esp
  802f42:	bb 00 00 00 00       	mov    $0x0,%ebx
  802f47:	eb 2e                	jmp    802f77 <pipe+0x141>
	sys_page_unmap(0, va);
  802f49:	83 ec 08             	sub    $0x8,%esp
  802f4c:	56                   	push   %esi
  802f4d:	6a 00                	push   $0x0
  802f4f:	e8 0b e3 ff ff       	call   80125f <sys_page_unmap>
  802f54:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802f57:	83 ec 08             	sub    $0x8,%esp
  802f5a:	ff 75 f0             	pushl  -0x10(%ebp)
  802f5d:	6a 00                	push   $0x0
  802f5f:	e8 fb e2 ff ff       	call   80125f <sys_page_unmap>
  802f64:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802f67:	83 ec 08             	sub    $0x8,%esp
  802f6a:	ff 75 f4             	pushl  -0xc(%ebp)
  802f6d:	6a 00                	push   $0x0
  802f6f:	e8 eb e2 ff ff       	call   80125f <sys_page_unmap>
  802f74:	83 c4 10             	add    $0x10,%esp
}
  802f77:	89 d8                	mov    %ebx,%eax
  802f79:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f7c:	5b                   	pop    %ebx
  802f7d:	5e                   	pop    %esi
  802f7e:	5d                   	pop    %ebp
  802f7f:	c3                   	ret    

00802f80 <pipeisclosed>:
{
  802f80:	55                   	push   %ebp
  802f81:	89 e5                	mov    %esp,%ebp
  802f83:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f86:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f89:	50                   	push   %eax
  802f8a:	ff 75 08             	pushl  0x8(%ebp)
  802f8d:	e8 9d ea ff ff       	call   801a2f <fd_lookup>
  802f92:	83 c4 10             	add    $0x10,%esp
  802f95:	85 c0                	test   %eax,%eax
  802f97:	78 18                	js     802fb1 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802f99:	83 ec 0c             	sub    $0xc,%esp
  802f9c:	ff 75 f4             	pushl  -0xc(%ebp)
  802f9f:	e8 22 ea ff ff       	call   8019c6 <fd2data>
	return _pipeisclosed(fd, p);
  802fa4:	89 c2                	mov    %eax,%edx
  802fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa9:	e8 2f fd ff ff       	call   802cdd <_pipeisclosed>
  802fae:	83 c4 10             	add    $0x10,%esp
}
  802fb1:	c9                   	leave  
  802fb2:	c3                   	ret    

00802fb3 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802fb3:	55                   	push   %ebp
  802fb4:	89 e5                	mov    %esp,%ebp
  802fb6:	56                   	push   %esi
  802fb7:	53                   	push   %ebx
  802fb8:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802fbb:	85 f6                	test   %esi,%esi
  802fbd:	74 13                	je     802fd2 <wait+0x1f>
	e = &envs[ENVX(envid)];
  802fbf:	89 f3                	mov    %esi,%ebx
  802fc1:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802fc7:	c1 e3 07             	shl    $0x7,%ebx
  802fca:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802fd0:	eb 1b                	jmp    802fed <wait+0x3a>
	assert(envid != 0);
  802fd2:	68 9e 3c 80 00       	push   $0x803c9e
  802fd7:	68 3b 3b 80 00       	push   $0x803b3b
  802fdc:	6a 09                	push   $0x9
  802fde:	68 a9 3c 80 00       	push   $0x803ca9
  802fe3:	e8 ab d5 ff ff       	call   800593 <_panic>
		sys_yield();
  802fe8:	e8 ce e1 ff ff       	call   8011bb <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802fed:	8b 43 48             	mov    0x48(%ebx),%eax
  802ff0:	39 f0                	cmp    %esi,%eax
  802ff2:	75 07                	jne    802ffb <wait+0x48>
  802ff4:	8b 43 54             	mov    0x54(%ebx),%eax
  802ff7:	85 c0                	test   %eax,%eax
  802ff9:	75 ed                	jne    802fe8 <wait+0x35>
}
  802ffb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802ffe:	5b                   	pop    %ebx
  802fff:	5e                   	pop    %esi
  803000:	5d                   	pop    %ebp
  803001:	c3                   	ret    

00803002 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803002:	55                   	push   %ebp
  803003:	89 e5                	mov    %esp,%ebp
  803005:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  803008:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  80300f:	74 0a                	je     80301b <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803011:	8b 45 08             	mov    0x8(%ebp),%eax
  803014:	a3 00 80 80 00       	mov    %eax,0x808000
}
  803019:	c9                   	leave  
  80301a:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  80301b:	83 ec 04             	sub    $0x4,%esp
  80301e:	6a 07                	push   $0x7
  803020:	68 00 f0 bf ee       	push   $0xeebff000
  803025:	6a 00                	push   $0x0
  803027:	e8 ae e1 ff ff       	call   8011da <sys_page_alloc>
		if(r < 0)
  80302c:	83 c4 10             	add    $0x10,%esp
  80302f:	85 c0                	test   %eax,%eax
  803031:	78 2a                	js     80305d <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  803033:	83 ec 08             	sub    $0x8,%esp
  803036:	68 71 30 80 00       	push   $0x803071
  80303b:	6a 00                	push   $0x0
  80303d:	e8 e3 e2 ff ff       	call   801325 <sys_env_set_pgfault_upcall>
		if(r < 0)
  803042:	83 c4 10             	add    $0x10,%esp
  803045:	85 c0                	test   %eax,%eax
  803047:	79 c8                	jns    803011 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  803049:	83 ec 04             	sub    $0x4,%esp
  80304c:	68 e4 3c 80 00       	push   $0x803ce4
  803051:	6a 25                	push   $0x25
  803053:	68 20 3d 80 00       	push   $0x803d20
  803058:	e8 36 d5 ff ff       	call   800593 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  80305d:	83 ec 04             	sub    $0x4,%esp
  803060:	68 b4 3c 80 00       	push   $0x803cb4
  803065:	6a 22                	push   $0x22
  803067:	68 20 3d 80 00       	push   $0x803d20
  80306c:	e8 22 d5 ff ff       	call   800593 <_panic>

00803071 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  803071:	54                   	push   %esp
	movl _pgfault_handler, %eax
  803072:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  803077:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  803079:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  80307c:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  803080:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  803084:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  803087:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  803089:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  80308d:	83 c4 08             	add    $0x8,%esp
	popal
  803090:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  803091:	83 c4 04             	add    $0x4,%esp
	popfl
  803094:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  803095:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  803096:	c3                   	ret    

00803097 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803097:	55                   	push   %ebp
  803098:	89 e5                	mov    %esp,%ebp
  80309a:	56                   	push   %esi
  80309b:	53                   	push   %ebx
  80309c:	8b 75 08             	mov    0x8(%ebp),%esi
  80309f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030a2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8030a5:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8030a7:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8030ac:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8030af:	83 ec 0c             	sub    $0xc,%esp
  8030b2:	50                   	push   %eax
  8030b3:	e8 d2 e2 ff ff       	call   80138a <sys_ipc_recv>
	if(ret < 0){
  8030b8:	83 c4 10             	add    $0x10,%esp
  8030bb:	85 c0                	test   %eax,%eax
  8030bd:	78 2b                	js     8030ea <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8030bf:	85 f6                	test   %esi,%esi
  8030c1:	74 0a                	je     8030cd <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8030c3:	a1 08 50 80 00       	mov    0x805008,%eax
  8030c8:	8b 40 74             	mov    0x74(%eax),%eax
  8030cb:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8030cd:	85 db                	test   %ebx,%ebx
  8030cf:	74 0a                	je     8030db <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8030d1:	a1 08 50 80 00       	mov    0x805008,%eax
  8030d6:	8b 40 78             	mov    0x78(%eax),%eax
  8030d9:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8030db:	a1 08 50 80 00       	mov    0x805008,%eax
  8030e0:	8b 40 70             	mov    0x70(%eax),%eax
}
  8030e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8030e6:	5b                   	pop    %ebx
  8030e7:	5e                   	pop    %esi
  8030e8:	5d                   	pop    %ebp
  8030e9:	c3                   	ret    
		if(from_env_store)
  8030ea:	85 f6                	test   %esi,%esi
  8030ec:	74 06                	je     8030f4 <ipc_recv+0x5d>
			*from_env_store = 0;
  8030ee:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8030f4:	85 db                	test   %ebx,%ebx
  8030f6:	74 eb                	je     8030e3 <ipc_recv+0x4c>
			*perm_store = 0;
  8030f8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8030fe:	eb e3                	jmp    8030e3 <ipc_recv+0x4c>

00803100 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  803100:	55                   	push   %ebp
  803101:	89 e5                	mov    %esp,%ebp
  803103:	57                   	push   %edi
  803104:	56                   	push   %esi
  803105:	53                   	push   %ebx
  803106:	83 ec 0c             	sub    $0xc,%esp
  803109:	8b 7d 08             	mov    0x8(%ebp),%edi
  80310c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80310f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  803112:	85 db                	test   %ebx,%ebx
  803114:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  803119:	0f 44 d8             	cmove  %eax,%ebx
  80311c:	eb 05                	jmp    803123 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80311e:	e8 98 e0 ff ff       	call   8011bb <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  803123:	ff 75 14             	pushl  0x14(%ebp)
  803126:	53                   	push   %ebx
  803127:	56                   	push   %esi
  803128:	57                   	push   %edi
  803129:	e8 39 e2 ff ff       	call   801367 <sys_ipc_try_send>
  80312e:	83 c4 10             	add    $0x10,%esp
  803131:	85 c0                	test   %eax,%eax
  803133:	74 1b                	je     803150 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  803135:	79 e7                	jns    80311e <ipc_send+0x1e>
  803137:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80313a:	74 e2                	je     80311e <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80313c:	83 ec 04             	sub    $0x4,%esp
  80313f:	68 2e 3d 80 00       	push   $0x803d2e
  803144:	6a 46                	push   $0x46
  803146:	68 43 3d 80 00       	push   $0x803d43
  80314b:	e8 43 d4 ff ff       	call   800593 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  803150:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803153:	5b                   	pop    %ebx
  803154:	5e                   	pop    %esi
  803155:	5f                   	pop    %edi
  803156:	5d                   	pop    %ebp
  803157:	c3                   	ret    

00803158 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803158:	55                   	push   %ebp
  803159:	89 e5                	mov    %esp,%ebp
  80315b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80315e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  803163:	89 c2                	mov    %eax,%edx
  803165:	c1 e2 07             	shl    $0x7,%edx
  803168:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80316e:	8b 52 50             	mov    0x50(%edx),%edx
  803171:	39 ca                	cmp    %ecx,%edx
  803173:	74 11                	je     803186 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  803175:	83 c0 01             	add    $0x1,%eax
  803178:	3d 00 04 00 00       	cmp    $0x400,%eax
  80317d:	75 e4                	jne    803163 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80317f:	b8 00 00 00 00       	mov    $0x0,%eax
  803184:	eb 0b                	jmp    803191 <ipc_find_env+0x39>
			return envs[i].env_id;
  803186:	c1 e0 07             	shl    $0x7,%eax
  803189:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80318e:	8b 40 48             	mov    0x48(%eax),%eax
}
  803191:	5d                   	pop    %ebp
  803192:	c3                   	ret    

00803193 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803193:	55                   	push   %ebp
  803194:	89 e5                	mov    %esp,%ebp
  803196:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803199:	89 d0                	mov    %edx,%eax
  80319b:	c1 e8 16             	shr    $0x16,%eax
  80319e:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8031a5:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8031aa:	f6 c1 01             	test   $0x1,%cl
  8031ad:	74 1d                	je     8031cc <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8031af:	c1 ea 0c             	shr    $0xc,%edx
  8031b2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8031b9:	f6 c2 01             	test   $0x1,%dl
  8031bc:	74 0e                	je     8031cc <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8031be:	c1 ea 0c             	shr    $0xc,%edx
  8031c1:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8031c8:	ef 
  8031c9:	0f b7 c0             	movzwl %ax,%eax
}
  8031cc:	5d                   	pop    %ebp
  8031cd:	c3                   	ret    
  8031ce:	66 90                	xchg   %ax,%ax

008031d0 <__udivdi3>:
  8031d0:	55                   	push   %ebp
  8031d1:	57                   	push   %edi
  8031d2:	56                   	push   %esi
  8031d3:	53                   	push   %ebx
  8031d4:	83 ec 1c             	sub    $0x1c,%esp
  8031d7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8031db:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8031df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8031e3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8031e7:	85 d2                	test   %edx,%edx
  8031e9:	75 4d                	jne    803238 <__udivdi3+0x68>
  8031eb:	39 f3                	cmp    %esi,%ebx
  8031ed:	76 19                	jbe    803208 <__udivdi3+0x38>
  8031ef:	31 ff                	xor    %edi,%edi
  8031f1:	89 e8                	mov    %ebp,%eax
  8031f3:	89 f2                	mov    %esi,%edx
  8031f5:	f7 f3                	div    %ebx
  8031f7:	89 fa                	mov    %edi,%edx
  8031f9:	83 c4 1c             	add    $0x1c,%esp
  8031fc:	5b                   	pop    %ebx
  8031fd:	5e                   	pop    %esi
  8031fe:	5f                   	pop    %edi
  8031ff:	5d                   	pop    %ebp
  803200:	c3                   	ret    
  803201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803208:	89 d9                	mov    %ebx,%ecx
  80320a:	85 db                	test   %ebx,%ebx
  80320c:	75 0b                	jne    803219 <__udivdi3+0x49>
  80320e:	b8 01 00 00 00       	mov    $0x1,%eax
  803213:	31 d2                	xor    %edx,%edx
  803215:	f7 f3                	div    %ebx
  803217:	89 c1                	mov    %eax,%ecx
  803219:	31 d2                	xor    %edx,%edx
  80321b:	89 f0                	mov    %esi,%eax
  80321d:	f7 f1                	div    %ecx
  80321f:	89 c6                	mov    %eax,%esi
  803221:	89 e8                	mov    %ebp,%eax
  803223:	89 f7                	mov    %esi,%edi
  803225:	f7 f1                	div    %ecx
  803227:	89 fa                	mov    %edi,%edx
  803229:	83 c4 1c             	add    $0x1c,%esp
  80322c:	5b                   	pop    %ebx
  80322d:	5e                   	pop    %esi
  80322e:	5f                   	pop    %edi
  80322f:	5d                   	pop    %ebp
  803230:	c3                   	ret    
  803231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803238:	39 f2                	cmp    %esi,%edx
  80323a:	77 1c                	ja     803258 <__udivdi3+0x88>
  80323c:	0f bd fa             	bsr    %edx,%edi
  80323f:	83 f7 1f             	xor    $0x1f,%edi
  803242:	75 2c                	jne    803270 <__udivdi3+0xa0>
  803244:	39 f2                	cmp    %esi,%edx
  803246:	72 06                	jb     80324e <__udivdi3+0x7e>
  803248:	31 c0                	xor    %eax,%eax
  80324a:	39 eb                	cmp    %ebp,%ebx
  80324c:	77 a9                	ja     8031f7 <__udivdi3+0x27>
  80324e:	b8 01 00 00 00       	mov    $0x1,%eax
  803253:	eb a2                	jmp    8031f7 <__udivdi3+0x27>
  803255:	8d 76 00             	lea    0x0(%esi),%esi
  803258:	31 ff                	xor    %edi,%edi
  80325a:	31 c0                	xor    %eax,%eax
  80325c:	89 fa                	mov    %edi,%edx
  80325e:	83 c4 1c             	add    $0x1c,%esp
  803261:	5b                   	pop    %ebx
  803262:	5e                   	pop    %esi
  803263:	5f                   	pop    %edi
  803264:	5d                   	pop    %ebp
  803265:	c3                   	ret    
  803266:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80326d:	8d 76 00             	lea    0x0(%esi),%esi
  803270:	89 f9                	mov    %edi,%ecx
  803272:	b8 20 00 00 00       	mov    $0x20,%eax
  803277:	29 f8                	sub    %edi,%eax
  803279:	d3 e2                	shl    %cl,%edx
  80327b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80327f:	89 c1                	mov    %eax,%ecx
  803281:	89 da                	mov    %ebx,%edx
  803283:	d3 ea                	shr    %cl,%edx
  803285:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803289:	09 d1                	or     %edx,%ecx
  80328b:	89 f2                	mov    %esi,%edx
  80328d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803291:	89 f9                	mov    %edi,%ecx
  803293:	d3 e3                	shl    %cl,%ebx
  803295:	89 c1                	mov    %eax,%ecx
  803297:	d3 ea                	shr    %cl,%edx
  803299:	89 f9                	mov    %edi,%ecx
  80329b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80329f:	89 eb                	mov    %ebp,%ebx
  8032a1:	d3 e6                	shl    %cl,%esi
  8032a3:	89 c1                	mov    %eax,%ecx
  8032a5:	d3 eb                	shr    %cl,%ebx
  8032a7:	09 de                	or     %ebx,%esi
  8032a9:	89 f0                	mov    %esi,%eax
  8032ab:	f7 74 24 08          	divl   0x8(%esp)
  8032af:	89 d6                	mov    %edx,%esi
  8032b1:	89 c3                	mov    %eax,%ebx
  8032b3:	f7 64 24 0c          	mull   0xc(%esp)
  8032b7:	39 d6                	cmp    %edx,%esi
  8032b9:	72 15                	jb     8032d0 <__udivdi3+0x100>
  8032bb:	89 f9                	mov    %edi,%ecx
  8032bd:	d3 e5                	shl    %cl,%ebp
  8032bf:	39 c5                	cmp    %eax,%ebp
  8032c1:	73 04                	jae    8032c7 <__udivdi3+0xf7>
  8032c3:	39 d6                	cmp    %edx,%esi
  8032c5:	74 09                	je     8032d0 <__udivdi3+0x100>
  8032c7:	89 d8                	mov    %ebx,%eax
  8032c9:	31 ff                	xor    %edi,%edi
  8032cb:	e9 27 ff ff ff       	jmp    8031f7 <__udivdi3+0x27>
  8032d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8032d3:	31 ff                	xor    %edi,%edi
  8032d5:	e9 1d ff ff ff       	jmp    8031f7 <__udivdi3+0x27>
  8032da:	66 90                	xchg   %ax,%ax
  8032dc:	66 90                	xchg   %ax,%ax
  8032de:	66 90                	xchg   %ax,%ax

008032e0 <__umoddi3>:
  8032e0:	55                   	push   %ebp
  8032e1:	57                   	push   %edi
  8032e2:	56                   	push   %esi
  8032e3:	53                   	push   %ebx
  8032e4:	83 ec 1c             	sub    $0x1c,%esp
  8032e7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8032eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8032ef:	8b 74 24 30          	mov    0x30(%esp),%esi
  8032f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032f7:	89 da                	mov    %ebx,%edx
  8032f9:	85 c0                	test   %eax,%eax
  8032fb:	75 43                	jne    803340 <__umoddi3+0x60>
  8032fd:	39 df                	cmp    %ebx,%edi
  8032ff:	76 17                	jbe    803318 <__umoddi3+0x38>
  803301:	89 f0                	mov    %esi,%eax
  803303:	f7 f7                	div    %edi
  803305:	89 d0                	mov    %edx,%eax
  803307:	31 d2                	xor    %edx,%edx
  803309:	83 c4 1c             	add    $0x1c,%esp
  80330c:	5b                   	pop    %ebx
  80330d:	5e                   	pop    %esi
  80330e:	5f                   	pop    %edi
  80330f:	5d                   	pop    %ebp
  803310:	c3                   	ret    
  803311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803318:	89 fd                	mov    %edi,%ebp
  80331a:	85 ff                	test   %edi,%edi
  80331c:	75 0b                	jne    803329 <__umoddi3+0x49>
  80331e:	b8 01 00 00 00       	mov    $0x1,%eax
  803323:	31 d2                	xor    %edx,%edx
  803325:	f7 f7                	div    %edi
  803327:	89 c5                	mov    %eax,%ebp
  803329:	89 d8                	mov    %ebx,%eax
  80332b:	31 d2                	xor    %edx,%edx
  80332d:	f7 f5                	div    %ebp
  80332f:	89 f0                	mov    %esi,%eax
  803331:	f7 f5                	div    %ebp
  803333:	89 d0                	mov    %edx,%eax
  803335:	eb d0                	jmp    803307 <__umoddi3+0x27>
  803337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80333e:	66 90                	xchg   %ax,%ax
  803340:	89 f1                	mov    %esi,%ecx
  803342:	39 d8                	cmp    %ebx,%eax
  803344:	76 0a                	jbe    803350 <__umoddi3+0x70>
  803346:	89 f0                	mov    %esi,%eax
  803348:	83 c4 1c             	add    $0x1c,%esp
  80334b:	5b                   	pop    %ebx
  80334c:	5e                   	pop    %esi
  80334d:	5f                   	pop    %edi
  80334e:	5d                   	pop    %ebp
  80334f:	c3                   	ret    
  803350:	0f bd e8             	bsr    %eax,%ebp
  803353:	83 f5 1f             	xor    $0x1f,%ebp
  803356:	75 20                	jne    803378 <__umoddi3+0x98>
  803358:	39 d8                	cmp    %ebx,%eax
  80335a:	0f 82 b0 00 00 00    	jb     803410 <__umoddi3+0x130>
  803360:	39 f7                	cmp    %esi,%edi
  803362:	0f 86 a8 00 00 00    	jbe    803410 <__umoddi3+0x130>
  803368:	89 c8                	mov    %ecx,%eax
  80336a:	83 c4 1c             	add    $0x1c,%esp
  80336d:	5b                   	pop    %ebx
  80336e:	5e                   	pop    %esi
  80336f:	5f                   	pop    %edi
  803370:	5d                   	pop    %ebp
  803371:	c3                   	ret    
  803372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803378:	89 e9                	mov    %ebp,%ecx
  80337a:	ba 20 00 00 00       	mov    $0x20,%edx
  80337f:	29 ea                	sub    %ebp,%edx
  803381:	d3 e0                	shl    %cl,%eax
  803383:	89 44 24 08          	mov    %eax,0x8(%esp)
  803387:	89 d1                	mov    %edx,%ecx
  803389:	89 f8                	mov    %edi,%eax
  80338b:	d3 e8                	shr    %cl,%eax
  80338d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803391:	89 54 24 04          	mov    %edx,0x4(%esp)
  803395:	8b 54 24 04          	mov    0x4(%esp),%edx
  803399:	09 c1                	or     %eax,%ecx
  80339b:	89 d8                	mov    %ebx,%eax
  80339d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8033a1:	89 e9                	mov    %ebp,%ecx
  8033a3:	d3 e7                	shl    %cl,%edi
  8033a5:	89 d1                	mov    %edx,%ecx
  8033a7:	d3 e8                	shr    %cl,%eax
  8033a9:	89 e9                	mov    %ebp,%ecx
  8033ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8033af:	d3 e3                	shl    %cl,%ebx
  8033b1:	89 c7                	mov    %eax,%edi
  8033b3:	89 d1                	mov    %edx,%ecx
  8033b5:	89 f0                	mov    %esi,%eax
  8033b7:	d3 e8                	shr    %cl,%eax
  8033b9:	89 e9                	mov    %ebp,%ecx
  8033bb:	89 fa                	mov    %edi,%edx
  8033bd:	d3 e6                	shl    %cl,%esi
  8033bf:	09 d8                	or     %ebx,%eax
  8033c1:	f7 74 24 08          	divl   0x8(%esp)
  8033c5:	89 d1                	mov    %edx,%ecx
  8033c7:	89 f3                	mov    %esi,%ebx
  8033c9:	f7 64 24 0c          	mull   0xc(%esp)
  8033cd:	89 c6                	mov    %eax,%esi
  8033cf:	89 d7                	mov    %edx,%edi
  8033d1:	39 d1                	cmp    %edx,%ecx
  8033d3:	72 06                	jb     8033db <__umoddi3+0xfb>
  8033d5:	75 10                	jne    8033e7 <__umoddi3+0x107>
  8033d7:	39 c3                	cmp    %eax,%ebx
  8033d9:	73 0c                	jae    8033e7 <__umoddi3+0x107>
  8033db:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8033df:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8033e3:	89 d7                	mov    %edx,%edi
  8033e5:	89 c6                	mov    %eax,%esi
  8033e7:	89 ca                	mov    %ecx,%edx
  8033e9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8033ee:	29 f3                	sub    %esi,%ebx
  8033f0:	19 fa                	sbb    %edi,%edx
  8033f2:	89 d0                	mov    %edx,%eax
  8033f4:	d3 e0                	shl    %cl,%eax
  8033f6:	89 e9                	mov    %ebp,%ecx
  8033f8:	d3 eb                	shr    %cl,%ebx
  8033fa:	d3 ea                	shr    %cl,%edx
  8033fc:	09 d8                	or     %ebx,%eax
  8033fe:	83 c4 1c             	add    $0x1c,%esp
  803401:	5b                   	pop    %ebx
  803402:	5e                   	pop    %esi
  803403:	5f                   	pop    %edi
  803404:	5d                   	pop    %ebp
  803405:	c3                   	ret    
  803406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80340d:	8d 76 00             	lea    0x0(%esi),%esi
  803410:	89 da                	mov    %ebx,%edx
  803412:	29 fe                	sub    %edi,%esi
  803414:	19 c2                	sbb    %eax,%edx
  803416:	89 f1                	mov    %esi,%ecx
  803418:	89 c8                	mov    %ecx,%eax
  80341a:	e9 4b ff ff ff       	jmp    80336a <__umoddi3+0x8a>
