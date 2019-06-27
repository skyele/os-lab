
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
  80004a:	e8 a6 1d 00 00       	call   801df5 <seek>
	seek(kfd, off);
  80004f:	83 c4 08             	add    $0x8,%esp
  800052:	53                   	push   %ebx
  800053:	57                   	push   %edi
  800054:	e8 9c 1d 00 00       	call   801df5 <seek>

	cprintf("shell produced incorrect output.\n");
  800059:	c7 04 24 40 34 80 00 	movl   $0x803440,(%esp)
  800060:	e8 26 06 00 00       	call   80068b <cprintf>
	cprintf("expected:\n===\n");
  800065:	c7 04 24 ab 34 80 00 	movl   $0x8034ab,(%esp)
  80006c:	e8 1a 06 00 00       	call   80068b <cprintf>
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800071:	83 c4 10             	add    $0x10,%esp
  800074:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  800077:	83 ec 04             	sub    $0x4,%esp
  80007a:	6a 63                	push   $0x63
  80007c:	53                   	push   %ebx
  80007d:	57                   	push   %edi
  80007e:	e8 24 1c 00 00       	call   801ca7 <read>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	85 c0                	test   %eax,%eax
  800088:	7e 0f                	jle    800099 <wrong+0x66>
		sys_cputs(buf, n);
  80008a:	83 ec 08             	sub    $0x8,%esp
  80008d:	50                   	push   %eax
  80008e:	53                   	push   %ebx
  80008f:	e8 8c 10 00 00       	call   801120 <sys_cputs>
  800094:	83 c4 10             	add    $0x10,%esp
  800097:	eb de                	jmp    800077 <wrong+0x44>
	cprintf("===\ngot:\n===\n");
  800099:	83 ec 0c             	sub    $0xc,%esp
  80009c:	68 ba 34 80 00       	push   $0x8034ba
  8000a1:	e8 e5 05 00 00       	call   80068b <cprintf>
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000a6:	83 c4 10             	add    $0x10,%esp
  8000a9:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  8000ac:	eb 0d                	jmp    8000bb <wrong+0x88>
		sys_cputs(buf, n);
  8000ae:	83 ec 08             	sub    $0x8,%esp
  8000b1:	50                   	push   %eax
  8000b2:	53                   	push   %ebx
  8000b3:	e8 68 10 00 00       	call   801120 <sys_cputs>
  8000b8:	83 c4 10             	add    $0x10,%esp
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000bb:	83 ec 04             	sub    $0x4,%esp
  8000be:	6a 63                	push   $0x63
  8000c0:	53                   	push   %ebx
  8000c1:	56                   	push   %esi
  8000c2:	e8 e0 1b 00 00       	call   801ca7 <read>
  8000c7:	83 c4 10             	add    $0x10,%esp
  8000ca:	85 c0                	test   %eax,%eax
  8000cc:	7f e0                	jg     8000ae <wrong+0x7b>
	cprintf("===\n");
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	68 b5 34 80 00       	push   $0x8034b5
  8000d6:	e8 b0 05 00 00       	call   80068b <cprintf>
	exit();
  8000db:	e8 81 04 00 00       	call   800561 <exit>
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
  8000f6:	e8 6e 1a 00 00       	call   801b69 <close>
	close(1);
  8000fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800102:	e8 62 1a 00 00       	call   801b69 <close>
	opencons();
  800107:	e8 28 03 00 00       	call   800434 <opencons>
	opencons();
  80010c:	e8 23 03 00 00       	call   800434 <opencons>
	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  800111:	83 c4 08             	add    $0x8,%esp
  800114:	6a 00                	push   $0x0
  800116:	68 c8 34 80 00       	push   $0x8034c8
  80011b:	e8 25 20 00 00       	call   802145 <open>
  800120:	89 c3                	mov    %eax,%ebx
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	85 c0                	test   %eax,%eax
  800127:	0f 88 e7 00 00 00    	js     800214 <umain+0x129>
	if ((wfd = pipe(pfds)) < 0)
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800133:	50                   	push   %eax
  800134:	e8 06 2d 00 00       	call   802e3f <pipe>
  800139:	83 c4 10             	add    $0x10,%esp
  80013c:	85 c0                	test   %eax,%eax
  80013e:	0f 88 e2 00 00 00    	js     800226 <umain+0x13b>
	wfd = pfds[1];
  800144:	8b 75 e0             	mov    -0x20(%ebp),%esi
	cprintf("running sh -x < testshell.sh | cat\n");
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	68 64 34 80 00       	push   $0x803464
  80014f:	e8 37 05 00 00       	call   80068b <cprintf>
	if ((r = fork()) < 0)
  800154:	e8 cd 15 00 00       	call   801726 <fork>
  800159:	83 c4 10             	add    $0x10,%esp
  80015c:	85 c0                	test   %eax,%eax
  80015e:	0f 88 d4 00 00 00    	js     800238 <umain+0x14d>
	if (r == 0) {
  800164:	75 6f                	jne    8001d5 <umain+0xea>
		dup(rfd, 0);
  800166:	83 ec 08             	sub    $0x8,%esp
  800169:	6a 00                	push   $0x0
  80016b:	53                   	push   %ebx
  80016c:	e8 4a 1a 00 00       	call   801bbb <dup>
		dup(wfd, 1);
  800171:	83 c4 08             	add    $0x8,%esp
  800174:	6a 01                	push   $0x1
  800176:	56                   	push   %esi
  800177:	e8 3f 1a 00 00       	call   801bbb <dup>
		close(rfd);
  80017c:	89 1c 24             	mov    %ebx,(%esp)
  80017f:	e8 e5 19 00 00       	call   801b69 <close>
		close(wfd);
  800184:	89 34 24             	mov    %esi,(%esp)
  800187:	e8 dd 19 00 00       	call   801b69 <close>
		if ((r = spawnl("/sh", "sh", "-x", 0)) < 0)
  80018c:	6a 00                	push   $0x0
  80018e:	68 0e 35 80 00       	push   $0x80350e
  800193:	68 d2 34 80 00       	push   $0x8034d2
  800198:	68 11 35 80 00       	push   $0x803511
  80019d:	e8 d6 25 00 00       	call   802778 <spawnl>
  8001a2:	89 c7                	mov    %eax,%edi
  8001a4:	83 c4 20             	add    $0x20,%esp
  8001a7:	85 c0                	test   %eax,%eax
  8001a9:	0f 88 9b 00 00 00    	js     80024a <umain+0x15f>
		close(0);
  8001af:	83 ec 0c             	sub    $0xc,%esp
  8001b2:	6a 00                	push   $0x0
  8001b4:	e8 b0 19 00 00       	call   801b69 <close>
		close(1);
  8001b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001c0:	e8 a4 19 00 00       	call   801b69 <close>
		wait(r);
  8001c5:	89 3c 24             	mov    %edi,(%esp)
  8001c8:	e8 ef 2d 00 00       	call   802fbc <wait>
		exit();
  8001cd:	e8 8f 03 00 00       	call   800561 <exit>
  8001d2:	83 c4 10             	add    $0x10,%esp
	close(rfd);
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	53                   	push   %ebx
  8001d9:	e8 8b 19 00 00       	call   801b69 <close>
	close(wfd);
  8001de:	89 34 24             	mov    %esi,(%esp)
  8001e1:	e8 83 19 00 00       	call   801b69 <close>
	rfd = pfds[0];
  8001e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001e9:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8001ec:	83 c4 08             	add    $0x8,%esp
  8001ef:	6a 00                	push   $0x0
  8001f1:	68 1f 35 80 00       	push   $0x80351f
  8001f6:	e8 4a 1f 00 00       	call   802145 <open>
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
  800215:	68 d5 34 80 00       	push   $0x8034d5
  80021a:	6a 13                	push   $0x13
  80021c:	68 eb 34 80 00       	push   $0x8034eb
  800221:	e8 6f 03 00 00       	call   800595 <_panic>
		panic("pipe: %e", wfd);
  800226:	50                   	push   %eax
  800227:	68 fc 34 80 00       	push   $0x8034fc
  80022c:	6a 15                	push   $0x15
  80022e:	68 eb 34 80 00       	push   $0x8034eb
  800233:	e8 5d 03 00 00       	call   800595 <_panic>
		panic("fork: %e", r);
  800238:	50                   	push   %eax
  800239:	68 05 35 80 00       	push   $0x803505
  80023e:	6a 1a                	push   $0x1a
  800240:	68 eb 34 80 00       	push   $0x8034eb
  800245:	e8 4b 03 00 00       	call   800595 <_panic>
			panic("spawn: %e", r);
  80024a:	50                   	push   %eax
  80024b:	68 15 35 80 00       	push   $0x803515
  800250:	6a 21                	push   $0x21
  800252:	68 eb 34 80 00       	push   $0x8034eb
  800257:	e8 39 03 00 00       	call   800595 <_panic>
		panic("open testshell.key for reading: %e", kfd);
  80025c:	50                   	push   %eax
  80025d:	68 88 34 80 00       	push   $0x803488
  800262:	6a 2c                	push   $0x2c
  800264:	68 eb 34 80 00       	push   $0x8034eb
  800269:	e8 27 03 00 00       	call   800595 <_panic>
			panic("reading testshell.out: %e", n1);
  80026e:	53                   	push   %ebx
  80026f:	68 2d 35 80 00       	push   $0x80352d
  800274:	6a 33                	push   $0x33
  800276:	68 eb 34 80 00       	push   $0x8034eb
  80027b:	e8 15 03 00 00       	call   800595 <_panic>
			panic("reading testshell.key: %e", n2);
  800280:	50                   	push   %eax
  800281:	68 47 35 80 00       	push   $0x803547
  800286:	6a 35                	push   $0x35
  800288:	68 eb 34 80 00       	push   $0x8034eb
  80028d:	e8 03 03 00 00       	call   800595 <_panic>
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
  8002ba:	e8 e8 19 00 00       	call   801ca7 <read>
  8002bf:	89 c3                	mov    %eax,%ebx
		n2 = read(kfd, &c2, 1);
  8002c1:	83 c4 0c             	add    $0xc,%esp
  8002c4:	6a 01                	push   $0x1
  8002c6:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  8002c9:	50                   	push   %eax
  8002ca:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002cd:	e8 d5 19 00 00       	call   801ca7 <read>
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
  8002fb:	68 61 35 80 00       	push   $0x803561
  800300:	e8 86 03 00 00       	call   80068b <cprintf>
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
  80031d:	68 76 35 80 00       	push   $0x803576
  800322:	ff 75 0c             	pushl  0xc(%ebp)
  800325:	e8 c0 0a 00 00       	call   800dea <strcpy>
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
  800368:	e8 0b 0c 00 00       	call   800f78 <memmove>
		sys_cputs(buf, m);
  80036d:	83 c4 08             	add    $0x8,%esp
  800370:	53                   	push   %ebx
  800371:	57                   	push   %edi
  800372:	e8 a9 0d 00 00       	call   801120 <sys_cputs>
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
  800399:	e8 a0 0d 00 00       	call   80113e <sys_cgetc>
  80039e:	85 c0                	test   %eax,%eax
  8003a0:	75 07                	jne    8003a9 <devcons_read+0x21>
		sys_yield();
  8003a2:	e8 16 0e 00 00       	call   8011bd <sys_yield>
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
  8003d5:	e8 46 0d 00 00       	call   801120 <sys_cputs>
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
  8003ed:	e8 b5 18 00 00       	call   801ca7 <read>
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
  800415:	e8 1d 16 00 00       	call   801a37 <fd_lookup>
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
  80043e:	e8 a2 15 00 00       	call   8019e5 <fd_alloc>
  800443:	83 c4 10             	add    $0x10,%esp
  800446:	85 c0                	test   %eax,%eax
  800448:	78 3a                	js     800484 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80044a:	83 ec 04             	sub    $0x4,%esp
  80044d:	68 07 04 00 00       	push   $0x407
  800452:	ff 75 f4             	pushl  -0xc(%ebp)
  800455:	6a 00                	push   $0x0
  800457:	e8 80 0d 00 00       	call   8011dc <sys_page_alloc>
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
  80047c:	e8 3d 15 00 00       	call   8019be <fd2num>
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
  800499:	e8 00 0d 00 00       	call   80119e <sys_getenvid>
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
  8004be:	74 23                	je     8004e3 <libmain+0x5d>
		if(envs[i].env_id == find)
  8004c0:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  8004c6:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8004cc:	8b 49 48             	mov    0x48(%ecx),%ecx
  8004cf:	39 c1                	cmp    %eax,%ecx
  8004d1:	75 e2                	jne    8004b5 <libmain+0x2f>
  8004d3:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  8004d9:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8004df:	89 fe                	mov    %edi,%esi
  8004e1:	eb d2                	jmp    8004b5 <libmain+0x2f>
  8004e3:	89 f0                	mov    %esi,%eax
  8004e5:	84 c0                	test   %al,%al
  8004e7:	74 06                	je     8004ef <libmain+0x69>
  8004e9:	89 1d 08 50 80 00    	mov    %ebx,0x805008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004f3:	7e 0a                	jle    8004ff <libmain+0x79>
		binaryname = argv[0];
  8004f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f8:	8b 00                	mov    (%eax),%eax
  8004fa:	a3 1c 40 80 00       	mov    %eax,0x80401c

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8004ff:	a1 08 50 80 00       	mov    0x805008,%eax
  800504:	8b 40 48             	mov    0x48(%eax),%eax
  800507:	83 ec 08             	sub    $0x8,%esp
  80050a:	50                   	push   %eax
  80050b:	68 82 35 80 00       	push   $0x803582
  800510:	e8 76 01 00 00       	call   80068b <cprintf>
	cprintf("before umain\n");
  800515:	c7 04 24 a0 35 80 00 	movl   $0x8035a0,(%esp)
  80051c:	e8 6a 01 00 00       	call   80068b <cprintf>
	// call user main routine
	umain(argc, argv);
  800521:	83 c4 08             	add    $0x8,%esp
  800524:	ff 75 0c             	pushl  0xc(%ebp)
  800527:	ff 75 08             	pushl  0x8(%ebp)
  80052a:	e8 bc fb ff ff       	call   8000eb <umain>
	cprintf("after umain\n");
  80052f:	c7 04 24 ae 35 80 00 	movl   $0x8035ae,(%esp)
  800536:	e8 50 01 00 00       	call   80068b <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  80053b:	a1 08 50 80 00       	mov    0x805008,%eax
  800540:	8b 40 48             	mov    0x48(%eax),%eax
  800543:	83 c4 08             	add    $0x8,%esp
  800546:	50                   	push   %eax
  800547:	68 bb 35 80 00       	push   $0x8035bb
  80054c:	e8 3a 01 00 00       	call   80068b <cprintf>
	// exit gracefully
	exit();
  800551:	e8 0b 00 00 00       	call   800561 <exit>
}
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80055c:	5b                   	pop    %ebx
  80055d:	5e                   	pop    %esi
  80055e:	5f                   	pop    %edi
  80055f:	5d                   	pop    %ebp
  800560:	c3                   	ret    

00800561 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800561:	55                   	push   %ebp
  800562:	89 e5                	mov    %esp,%ebp
  800564:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800567:	a1 08 50 80 00       	mov    0x805008,%eax
  80056c:	8b 40 48             	mov    0x48(%eax),%eax
  80056f:	68 e8 35 80 00       	push   $0x8035e8
  800574:	50                   	push   %eax
  800575:	68 da 35 80 00       	push   $0x8035da
  80057a:	e8 0c 01 00 00       	call   80068b <cprintf>
	close_all();
  80057f:	e8 12 16 00 00       	call   801b96 <close_all>
	sys_env_destroy(0);
  800584:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80058b:	e8 cd 0b 00 00       	call   80115d <sys_env_destroy>
}
  800590:	83 c4 10             	add    $0x10,%esp
  800593:	c9                   	leave  
  800594:	c3                   	ret    

00800595 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800595:	55                   	push   %ebp
  800596:	89 e5                	mov    %esp,%ebp
  800598:	56                   	push   %esi
  800599:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80059a:	a1 08 50 80 00       	mov    0x805008,%eax
  80059f:	8b 40 48             	mov    0x48(%eax),%eax
  8005a2:	83 ec 04             	sub    $0x4,%esp
  8005a5:	68 14 36 80 00       	push   $0x803614
  8005aa:	50                   	push   %eax
  8005ab:	68 da 35 80 00       	push   $0x8035da
  8005b0:	e8 d6 00 00 00       	call   80068b <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8005b5:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8005b8:	8b 35 1c 40 80 00    	mov    0x80401c,%esi
  8005be:	e8 db 0b 00 00       	call   80119e <sys_getenvid>
  8005c3:	83 c4 04             	add    $0x4,%esp
  8005c6:	ff 75 0c             	pushl  0xc(%ebp)
  8005c9:	ff 75 08             	pushl  0x8(%ebp)
  8005cc:	56                   	push   %esi
  8005cd:	50                   	push   %eax
  8005ce:	68 f0 35 80 00       	push   $0x8035f0
  8005d3:	e8 b3 00 00 00       	call   80068b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005d8:	83 c4 18             	add    $0x18,%esp
  8005db:	53                   	push   %ebx
  8005dc:	ff 75 10             	pushl  0x10(%ebp)
  8005df:	e8 56 00 00 00       	call   80063a <vcprintf>
	cprintf("\n");
  8005e4:	c7 04 24 9e 35 80 00 	movl   $0x80359e,(%esp)
  8005eb:	e8 9b 00 00 00       	call   80068b <cprintf>
  8005f0:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8005f3:	cc                   	int3   
  8005f4:	eb fd                	jmp    8005f3 <_panic+0x5e>

008005f6 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8005f6:	55                   	push   %ebp
  8005f7:	89 e5                	mov    %esp,%ebp
  8005f9:	53                   	push   %ebx
  8005fa:	83 ec 04             	sub    $0x4,%esp
  8005fd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800600:	8b 13                	mov    (%ebx),%edx
  800602:	8d 42 01             	lea    0x1(%edx),%eax
  800605:	89 03                	mov    %eax,(%ebx)
  800607:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80060a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80060e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800613:	74 09                	je     80061e <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800615:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800619:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80061c:	c9                   	leave  
  80061d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80061e:	83 ec 08             	sub    $0x8,%esp
  800621:	68 ff 00 00 00       	push   $0xff
  800626:	8d 43 08             	lea    0x8(%ebx),%eax
  800629:	50                   	push   %eax
  80062a:	e8 f1 0a 00 00       	call   801120 <sys_cputs>
		b->idx = 0;
  80062f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800635:	83 c4 10             	add    $0x10,%esp
  800638:	eb db                	jmp    800615 <putch+0x1f>

0080063a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80063a:	55                   	push   %ebp
  80063b:	89 e5                	mov    %esp,%ebp
  80063d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800643:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80064a:	00 00 00 
	b.cnt = 0;
  80064d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800654:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800657:	ff 75 0c             	pushl  0xc(%ebp)
  80065a:	ff 75 08             	pushl  0x8(%ebp)
  80065d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800663:	50                   	push   %eax
  800664:	68 f6 05 80 00       	push   $0x8005f6
  800669:	e8 4a 01 00 00       	call   8007b8 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80066e:	83 c4 08             	add    $0x8,%esp
  800671:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800677:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80067d:	50                   	push   %eax
  80067e:	e8 9d 0a 00 00       	call   801120 <sys_cputs>

	return b.cnt;
}
  800683:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800689:	c9                   	leave  
  80068a:	c3                   	ret    

0080068b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80068b:	55                   	push   %ebp
  80068c:	89 e5                	mov    %esp,%ebp
  80068e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800691:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800694:	50                   	push   %eax
  800695:	ff 75 08             	pushl  0x8(%ebp)
  800698:	e8 9d ff ff ff       	call   80063a <vcprintf>
	va_end(ap);

	return cnt;
}
  80069d:	c9                   	leave  
  80069e:	c3                   	ret    

0080069f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80069f:	55                   	push   %ebp
  8006a0:	89 e5                	mov    %esp,%ebp
  8006a2:	57                   	push   %edi
  8006a3:	56                   	push   %esi
  8006a4:	53                   	push   %ebx
  8006a5:	83 ec 1c             	sub    $0x1c,%esp
  8006a8:	89 c6                	mov    %eax,%esi
  8006aa:	89 d7                	mov    %edx,%edi
  8006ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8006af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006b5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8006bb:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8006be:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8006c2:	74 2c                	je     8006f0 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8006c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8006ce:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006d1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8006d4:	39 c2                	cmp    %eax,%edx
  8006d6:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8006d9:	73 43                	jae    80071e <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8006db:	83 eb 01             	sub    $0x1,%ebx
  8006de:	85 db                	test   %ebx,%ebx
  8006e0:	7e 6c                	jle    80074e <printnum+0xaf>
				putch(padc, putdat);
  8006e2:	83 ec 08             	sub    $0x8,%esp
  8006e5:	57                   	push   %edi
  8006e6:	ff 75 18             	pushl  0x18(%ebp)
  8006e9:	ff d6                	call   *%esi
  8006eb:	83 c4 10             	add    $0x10,%esp
  8006ee:	eb eb                	jmp    8006db <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8006f0:	83 ec 0c             	sub    $0xc,%esp
  8006f3:	6a 20                	push   $0x20
  8006f5:	6a 00                	push   $0x0
  8006f7:	50                   	push   %eax
  8006f8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8006fb:	ff 75 e0             	pushl  -0x20(%ebp)
  8006fe:	89 fa                	mov    %edi,%edx
  800700:	89 f0                	mov    %esi,%eax
  800702:	e8 98 ff ff ff       	call   80069f <printnum>
		while (--width > 0)
  800707:	83 c4 20             	add    $0x20,%esp
  80070a:	83 eb 01             	sub    $0x1,%ebx
  80070d:	85 db                	test   %ebx,%ebx
  80070f:	7e 65                	jle    800776 <printnum+0xd7>
			putch(padc, putdat);
  800711:	83 ec 08             	sub    $0x8,%esp
  800714:	57                   	push   %edi
  800715:	6a 20                	push   $0x20
  800717:	ff d6                	call   *%esi
  800719:	83 c4 10             	add    $0x10,%esp
  80071c:	eb ec                	jmp    80070a <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80071e:	83 ec 0c             	sub    $0xc,%esp
  800721:	ff 75 18             	pushl  0x18(%ebp)
  800724:	83 eb 01             	sub    $0x1,%ebx
  800727:	53                   	push   %ebx
  800728:	50                   	push   %eax
  800729:	83 ec 08             	sub    $0x8,%esp
  80072c:	ff 75 dc             	pushl  -0x24(%ebp)
  80072f:	ff 75 d8             	pushl  -0x28(%ebp)
  800732:	ff 75 e4             	pushl  -0x1c(%ebp)
  800735:	ff 75 e0             	pushl  -0x20(%ebp)
  800738:	e8 a3 2a 00 00       	call   8031e0 <__udivdi3>
  80073d:	83 c4 18             	add    $0x18,%esp
  800740:	52                   	push   %edx
  800741:	50                   	push   %eax
  800742:	89 fa                	mov    %edi,%edx
  800744:	89 f0                	mov    %esi,%eax
  800746:	e8 54 ff ff ff       	call   80069f <printnum>
  80074b:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80074e:	83 ec 08             	sub    $0x8,%esp
  800751:	57                   	push   %edi
  800752:	83 ec 04             	sub    $0x4,%esp
  800755:	ff 75 dc             	pushl  -0x24(%ebp)
  800758:	ff 75 d8             	pushl  -0x28(%ebp)
  80075b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80075e:	ff 75 e0             	pushl  -0x20(%ebp)
  800761:	e8 8a 2b 00 00       	call   8032f0 <__umoddi3>
  800766:	83 c4 14             	add    $0x14,%esp
  800769:	0f be 80 1b 36 80 00 	movsbl 0x80361b(%eax),%eax
  800770:	50                   	push   %eax
  800771:	ff d6                	call   *%esi
  800773:	83 c4 10             	add    $0x10,%esp
	}
}
  800776:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800779:	5b                   	pop    %ebx
  80077a:	5e                   	pop    %esi
  80077b:	5f                   	pop    %edi
  80077c:	5d                   	pop    %ebp
  80077d:	c3                   	ret    

0080077e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80077e:	55                   	push   %ebp
  80077f:	89 e5                	mov    %esp,%ebp
  800781:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800784:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800788:	8b 10                	mov    (%eax),%edx
  80078a:	3b 50 04             	cmp    0x4(%eax),%edx
  80078d:	73 0a                	jae    800799 <sprintputch+0x1b>
		*b->buf++ = ch;
  80078f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800792:	89 08                	mov    %ecx,(%eax)
  800794:	8b 45 08             	mov    0x8(%ebp),%eax
  800797:	88 02                	mov    %al,(%edx)
}
  800799:	5d                   	pop    %ebp
  80079a:	c3                   	ret    

0080079b <printfmt>:
{
  80079b:	55                   	push   %ebp
  80079c:	89 e5                	mov    %esp,%ebp
  80079e:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8007a1:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8007a4:	50                   	push   %eax
  8007a5:	ff 75 10             	pushl  0x10(%ebp)
  8007a8:	ff 75 0c             	pushl  0xc(%ebp)
  8007ab:	ff 75 08             	pushl  0x8(%ebp)
  8007ae:	e8 05 00 00 00       	call   8007b8 <vprintfmt>
}
  8007b3:	83 c4 10             	add    $0x10,%esp
  8007b6:	c9                   	leave  
  8007b7:	c3                   	ret    

008007b8 <vprintfmt>:
{
  8007b8:	55                   	push   %ebp
  8007b9:	89 e5                	mov    %esp,%ebp
  8007bb:	57                   	push   %edi
  8007bc:	56                   	push   %esi
  8007bd:	53                   	push   %ebx
  8007be:	83 ec 3c             	sub    $0x3c,%esp
  8007c1:	8b 75 08             	mov    0x8(%ebp),%esi
  8007c4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8007c7:	8b 7d 10             	mov    0x10(%ebp),%edi
  8007ca:	e9 32 04 00 00       	jmp    800c01 <vprintfmt+0x449>
		padc = ' ';
  8007cf:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8007d3:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8007da:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8007e1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8007e8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007ef:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8007f6:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8007fb:	8d 47 01             	lea    0x1(%edi),%eax
  8007fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800801:	0f b6 17             	movzbl (%edi),%edx
  800804:	8d 42 dd             	lea    -0x23(%edx),%eax
  800807:	3c 55                	cmp    $0x55,%al
  800809:	0f 87 12 05 00 00    	ja     800d21 <vprintfmt+0x569>
  80080f:	0f b6 c0             	movzbl %al,%eax
  800812:	ff 24 85 00 38 80 00 	jmp    *0x803800(,%eax,4)
  800819:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80081c:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800820:	eb d9                	jmp    8007fb <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800822:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800825:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800829:	eb d0                	jmp    8007fb <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80082b:	0f b6 d2             	movzbl %dl,%edx
  80082e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800831:	b8 00 00 00 00       	mov    $0x0,%eax
  800836:	89 75 08             	mov    %esi,0x8(%ebp)
  800839:	eb 03                	jmp    80083e <vprintfmt+0x86>
  80083b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80083e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800841:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800845:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800848:	8d 72 d0             	lea    -0x30(%edx),%esi
  80084b:	83 fe 09             	cmp    $0x9,%esi
  80084e:	76 eb                	jbe    80083b <vprintfmt+0x83>
  800850:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800853:	8b 75 08             	mov    0x8(%ebp),%esi
  800856:	eb 14                	jmp    80086c <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800858:	8b 45 14             	mov    0x14(%ebp),%eax
  80085b:	8b 00                	mov    (%eax),%eax
  80085d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800860:	8b 45 14             	mov    0x14(%ebp),%eax
  800863:	8d 40 04             	lea    0x4(%eax),%eax
  800866:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800869:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80086c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800870:	79 89                	jns    8007fb <vprintfmt+0x43>
				width = precision, precision = -1;
  800872:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800875:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800878:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80087f:	e9 77 ff ff ff       	jmp    8007fb <vprintfmt+0x43>
  800884:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800887:	85 c0                	test   %eax,%eax
  800889:	0f 48 c1             	cmovs  %ecx,%eax
  80088c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80088f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800892:	e9 64 ff ff ff       	jmp    8007fb <vprintfmt+0x43>
  800897:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80089a:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8008a1:	e9 55 ff ff ff       	jmp    8007fb <vprintfmt+0x43>
			lflag++;
  8008a6:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8008aa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8008ad:	e9 49 ff ff ff       	jmp    8007fb <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8008b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b5:	8d 78 04             	lea    0x4(%eax),%edi
  8008b8:	83 ec 08             	sub    $0x8,%esp
  8008bb:	53                   	push   %ebx
  8008bc:	ff 30                	pushl  (%eax)
  8008be:	ff d6                	call   *%esi
			break;
  8008c0:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8008c3:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8008c6:	e9 33 03 00 00       	jmp    800bfe <vprintfmt+0x446>
			err = va_arg(ap, int);
  8008cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ce:	8d 78 04             	lea    0x4(%eax),%edi
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	99                   	cltd   
  8008d4:	31 d0                	xor    %edx,%eax
  8008d6:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008d8:	83 f8 11             	cmp    $0x11,%eax
  8008db:	7f 23                	jg     800900 <vprintfmt+0x148>
  8008dd:	8b 14 85 60 39 80 00 	mov    0x803960(,%eax,4),%edx
  8008e4:	85 d2                	test   %edx,%edx
  8008e6:	74 18                	je     800900 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8008e8:	52                   	push   %edx
  8008e9:	68 6d 3b 80 00       	push   $0x803b6d
  8008ee:	53                   	push   %ebx
  8008ef:	56                   	push   %esi
  8008f0:	e8 a6 fe ff ff       	call   80079b <printfmt>
  8008f5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8008f8:	89 7d 14             	mov    %edi,0x14(%ebp)
  8008fb:	e9 fe 02 00 00       	jmp    800bfe <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800900:	50                   	push   %eax
  800901:	68 33 36 80 00       	push   $0x803633
  800906:	53                   	push   %ebx
  800907:	56                   	push   %esi
  800908:	e8 8e fe ff ff       	call   80079b <printfmt>
  80090d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800910:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800913:	e9 e6 02 00 00       	jmp    800bfe <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800918:	8b 45 14             	mov    0x14(%ebp),%eax
  80091b:	83 c0 04             	add    $0x4,%eax
  80091e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800921:	8b 45 14             	mov    0x14(%ebp),%eax
  800924:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800926:	85 c9                	test   %ecx,%ecx
  800928:	b8 2c 36 80 00       	mov    $0x80362c,%eax
  80092d:	0f 45 c1             	cmovne %ecx,%eax
  800930:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800933:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800937:	7e 06                	jle    80093f <vprintfmt+0x187>
  800939:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80093d:	75 0d                	jne    80094c <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80093f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800942:	89 c7                	mov    %eax,%edi
  800944:	03 45 e0             	add    -0x20(%ebp),%eax
  800947:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80094a:	eb 53                	jmp    80099f <vprintfmt+0x1e7>
  80094c:	83 ec 08             	sub    $0x8,%esp
  80094f:	ff 75 d8             	pushl  -0x28(%ebp)
  800952:	50                   	push   %eax
  800953:	e8 71 04 00 00       	call   800dc9 <strnlen>
  800958:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80095b:	29 c1                	sub    %eax,%ecx
  80095d:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800960:	83 c4 10             	add    $0x10,%esp
  800963:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800965:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800969:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80096c:	eb 0f                	jmp    80097d <vprintfmt+0x1c5>
					putch(padc, putdat);
  80096e:	83 ec 08             	sub    $0x8,%esp
  800971:	53                   	push   %ebx
  800972:	ff 75 e0             	pushl  -0x20(%ebp)
  800975:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800977:	83 ef 01             	sub    $0x1,%edi
  80097a:	83 c4 10             	add    $0x10,%esp
  80097d:	85 ff                	test   %edi,%edi
  80097f:	7f ed                	jg     80096e <vprintfmt+0x1b6>
  800981:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800984:	85 c9                	test   %ecx,%ecx
  800986:	b8 00 00 00 00       	mov    $0x0,%eax
  80098b:	0f 49 c1             	cmovns %ecx,%eax
  80098e:	29 c1                	sub    %eax,%ecx
  800990:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800993:	eb aa                	jmp    80093f <vprintfmt+0x187>
					putch(ch, putdat);
  800995:	83 ec 08             	sub    $0x8,%esp
  800998:	53                   	push   %ebx
  800999:	52                   	push   %edx
  80099a:	ff d6                	call   *%esi
  80099c:	83 c4 10             	add    $0x10,%esp
  80099f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8009a2:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009a4:	83 c7 01             	add    $0x1,%edi
  8009a7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009ab:	0f be d0             	movsbl %al,%edx
  8009ae:	85 d2                	test   %edx,%edx
  8009b0:	74 4b                	je     8009fd <vprintfmt+0x245>
  8009b2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8009b6:	78 06                	js     8009be <vprintfmt+0x206>
  8009b8:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8009bc:	78 1e                	js     8009dc <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8009be:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8009c2:	74 d1                	je     800995 <vprintfmt+0x1dd>
  8009c4:	0f be c0             	movsbl %al,%eax
  8009c7:	83 e8 20             	sub    $0x20,%eax
  8009ca:	83 f8 5e             	cmp    $0x5e,%eax
  8009cd:	76 c6                	jbe    800995 <vprintfmt+0x1dd>
					putch('?', putdat);
  8009cf:	83 ec 08             	sub    $0x8,%esp
  8009d2:	53                   	push   %ebx
  8009d3:	6a 3f                	push   $0x3f
  8009d5:	ff d6                	call   *%esi
  8009d7:	83 c4 10             	add    $0x10,%esp
  8009da:	eb c3                	jmp    80099f <vprintfmt+0x1e7>
  8009dc:	89 cf                	mov    %ecx,%edi
  8009de:	eb 0e                	jmp    8009ee <vprintfmt+0x236>
				putch(' ', putdat);
  8009e0:	83 ec 08             	sub    $0x8,%esp
  8009e3:	53                   	push   %ebx
  8009e4:	6a 20                	push   $0x20
  8009e6:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8009e8:	83 ef 01             	sub    $0x1,%edi
  8009eb:	83 c4 10             	add    $0x10,%esp
  8009ee:	85 ff                	test   %edi,%edi
  8009f0:	7f ee                	jg     8009e0 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8009f2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8009f5:	89 45 14             	mov    %eax,0x14(%ebp)
  8009f8:	e9 01 02 00 00       	jmp    800bfe <vprintfmt+0x446>
  8009fd:	89 cf                	mov    %ecx,%edi
  8009ff:	eb ed                	jmp    8009ee <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800a01:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800a04:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800a0b:	e9 eb fd ff ff       	jmp    8007fb <vprintfmt+0x43>
	if (lflag >= 2)
  800a10:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800a14:	7f 21                	jg     800a37 <vprintfmt+0x27f>
	else if (lflag)
  800a16:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a1a:	74 68                	je     800a84 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800a1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1f:	8b 00                	mov    (%eax),%eax
  800a21:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800a24:	89 c1                	mov    %eax,%ecx
  800a26:	c1 f9 1f             	sar    $0x1f,%ecx
  800a29:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800a2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2f:	8d 40 04             	lea    0x4(%eax),%eax
  800a32:	89 45 14             	mov    %eax,0x14(%ebp)
  800a35:	eb 17                	jmp    800a4e <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800a37:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3a:	8b 50 04             	mov    0x4(%eax),%edx
  800a3d:	8b 00                	mov    (%eax),%eax
  800a3f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800a42:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800a45:	8b 45 14             	mov    0x14(%ebp),%eax
  800a48:	8d 40 08             	lea    0x8(%eax),%eax
  800a4b:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800a4e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a51:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800a54:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a57:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800a5a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800a5e:	78 3f                	js     800a9f <vprintfmt+0x2e7>
			base = 10;
  800a60:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800a65:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800a69:	0f 84 71 01 00 00    	je     800be0 <vprintfmt+0x428>
				putch('+', putdat);
  800a6f:	83 ec 08             	sub    $0x8,%esp
  800a72:	53                   	push   %ebx
  800a73:	6a 2b                	push   $0x2b
  800a75:	ff d6                	call   *%esi
  800a77:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800a7a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a7f:	e9 5c 01 00 00       	jmp    800be0 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800a84:	8b 45 14             	mov    0x14(%ebp),%eax
  800a87:	8b 00                	mov    (%eax),%eax
  800a89:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800a8c:	89 c1                	mov    %eax,%ecx
  800a8e:	c1 f9 1f             	sar    $0x1f,%ecx
  800a91:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800a94:	8b 45 14             	mov    0x14(%ebp),%eax
  800a97:	8d 40 04             	lea    0x4(%eax),%eax
  800a9a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a9d:	eb af                	jmp    800a4e <vprintfmt+0x296>
				putch('-', putdat);
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	53                   	push   %ebx
  800aa3:	6a 2d                	push   $0x2d
  800aa5:	ff d6                	call   *%esi
				num = -(long long) num;
  800aa7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800aaa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800aad:	f7 d8                	neg    %eax
  800aaf:	83 d2 00             	adc    $0x0,%edx
  800ab2:	f7 da                	neg    %edx
  800ab4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ab7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800aba:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800abd:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ac2:	e9 19 01 00 00       	jmp    800be0 <vprintfmt+0x428>
	if (lflag >= 2)
  800ac7:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800acb:	7f 29                	jg     800af6 <vprintfmt+0x33e>
	else if (lflag)
  800acd:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800ad1:	74 44                	je     800b17 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800ad3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad6:	8b 00                	mov    (%eax),%eax
  800ad8:	ba 00 00 00 00       	mov    $0x0,%edx
  800add:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ae0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ae3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae6:	8d 40 04             	lea    0x4(%eax),%eax
  800ae9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800aec:	b8 0a 00 00 00       	mov    $0xa,%eax
  800af1:	e9 ea 00 00 00       	jmp    800be0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800af6:	8b 45 14             	mov    0x14(%ebp),%eax
  800af9:	8b 50 04             	mov    0x4(%eax),%edx
  800afc:	8b 00                	mov    (%eax),%eax
  800afe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b01:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b04:	8b 45 14             	mov    0x14(%ebp),%eax
  800b07:	8d 40 08             	lea    0x8(%eax),%eax
  800b0a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b0d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b12:	e9 c9 00 00 00       	jmp    800be0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800b17:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1a:	8b 00                	mov    (%eax),%eax
  800b1c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b21:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b24:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b27:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2a:	8d 40 04             	lea    0x4(%eax),%eax
  800b2d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b30:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b35:	e9 a6 00 00 00       	jmp    800be0 <vprintfmt+0x428>
			putch('0', putdat);
  800b3a:	83 ec 08             	sub    $0x8,%esp
  800b3d:	53                   	push   %ebx
  800b3e:	6a 30                	push   $0x30
  800b40:	ff d6                	call   *%esi
	if (lflag >= 2)
  800b42:	83 c4 10             	add    $0x10,%esp
  800b45:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800b49:	7f 26                	jg     800b71 <vprintfmt+0x3b9>
	else if (lflag)
  800b4b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800b4f:	74 3e                	je     800b8f <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800b51:	8b 45 14             	mov    0x14(%ebp),%eax
  800b54:	8b 00                	mov    (%eax),%eax
  800b56:	ba 00 00 00 00       	mov    $0x0,%edx
  800b5b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b5e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b61:	8b 45 14             	mov    0x14(%ebp),%eax
  800b64:	8d 40 04             	lea    0x4(%eax),%eax
  800b67:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b6a:	b8 08 00 00 00       	mov    $0x8,%eax
  800b6f:	eb 6f                	jmp    800be0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800b71:	8b 45 14             	mov    0x14(%ebp),%eax
  800b74:	8b 50 04             	mov    0x4(%eax),%edx
  800b77:	8b 00                	mov    (%eax),%eax
  800b79:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b7c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b82:	8d 40 08             	lea    0x8(%eax),%eax
  800b85:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b88:	b8 08 00 00 00       	mov    $0x8,%eax
  800b8d:	eb 51                	jmp    800be0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800b8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b92:	8b 00                	mov    (%eax),%eax
  800b94:	ba 00 00 00 00       	mov    $0x0,%edx
  800b99:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b9c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b9f:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba2:	8d 40 04             	lea    0x4(%eax),%eax
  800ba5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800ba8:	b8 08 00 00 00       	mov    $0x8,%eax
  800bad:	eb 31                	jmp    800be0 <vprintfmt+0x428>
			putch('0', putdat);
  800baf:	83 ec 08             	sub    $0x8,%esp
  800bb2:	53                   	push   %ebx
  800bb3:	6a 30                	push   $0x30
  800bb5:	ff d6                	call   *%esi
			putch('x', putdat);
  800bb7:	83 c4 08             	add    $0x8,%esp
  800bba:	53                   	push   %ebx
  800bbb:	6a 78                	push   $0x78
  800bbd:	ff d6                	call   *%esi
			num = (unsigned long long)
  800bbf:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc2:	8b 00                	mov    (%eax),%eax
  800bc4:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bcc:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800bcf:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800bd2:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd5:	8d 40 04             	lea    0x4(%eax),%eax
  800bd8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800bdb:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800be0:	83 ec 0c             	sub    $0xc,%esp
  800be3:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800be7:	52                   	push   %edx
  800be8:	ff 75 e0             	pushl  -0x20(%ebp)
  800beb:	50                   	push   %eax
  800bec:	ff 75 dc             	pushl  -0x24(%ebp)
  800bef:	ff 75 d8             	pushl  -0x28(%ebp)
  800bf2:	89 da                	mov    %ebx,%edx
  800bf4:	89 f0                	mov    %esi,%eax
  800bf6:	e8 a4 fa ff ff       	call   80069f <printnum>
			break;
  800bfb:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800bfe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c01:	83 c7 01             	add    $0x1,%edi
  800c04:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800c08:	83 f8 25             	cmp    $0x25,%eax
  800c0b:	0f 84 be fb ff ff    	je     8007cf <vprintfmt+0x17>
			if (ch == '\0')
  800c11:	85 c0                	test   %eax,%eax
  800c13:	0f 84 28 01 00 00    	je     800d41 <vprintfmt+0x589>
			putch(ch, putdat);
  800c19:	83 ec 08             	sub    $0x8,%esp
  800c1c:	53                   	push   %ebx
  800c1d:	50                   	push   %eax
  800c1e:	ff d6                	call   *%esi
  800c20:	83 c4 10             	add    $0x10,%esp
  800c23:	eb dc                	jmp    800c01 <vprintfmt+0x449>
	if (lflag >= 2)
  800c25:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800c29:	7f 26                	jg     800c51 <vprintfmt+0x499>
	else if (lflag)
  800c2b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800c2f:	74 41                	je     800c72 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800c31:	8b 45 14             	mov    0x14(%ebp),%eax
  800c34:	8b 00                	mov    (%eax),%eax
  800c36:	ba 00 00 00 00       	mov    $0x0,%edx
  800c3b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c3e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c41:	8b 45 14             	mov    0x14(%ebp),%eax
  800c44:	8d 40 04             	lea    0x4(%eax),%eax
  800c47:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c4a:	b8 10 00 00 00       	mov    $0x10,%eax
  800c4f:	eb 8f                	jmp    800be0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800c51:	8b 45 14             	mov    0x14(%ebp),%eax
  800c54:	8b 50 04             	mov    0x4(%eax),%edx
  800c57:	8b 00                	mov    (%eax),%eax
  800c59:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c5c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c5f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c62:	8d 40 08             	lea    0x8(%eax),%eax
  800c65:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c68:	b8 10 00 00 00       	mov    $0x10,%eax
  800c6d:	e9 6e ff ff ff       	jmp    800be0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800c72:	8b 45 14             	mov    0x14(%ebp),%eax
  800c75:	8b 00                	mov    (%eax),%eax
  800c77:	ba 00 00 00 00       	mov    $0x0,%edx
  800c7c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c7f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c82:	8b 45 14             	mov    0x14(%ebp),%eax
  800c85:	8d 40 04             	lea    0x4(%eax),%eax
  800c88:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c8b:	b8 10 00 00 00       	mov    $0x10,%eax
  800c90:	e9 4b ff ff ff       	jmp    800be0 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800c95:	8b 45 14             	mov    0x14(%ebp),%eax
  800c98:	83 c0 04             	add    $0x4,%eax
  800c9b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca1:	8b 00                	mov    (%eax),%eax
  800ca3:	85 c0                	test   %eax,%eax
  800ca5:	74 14                	je     800cbb <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800ca7:	8b 13                	mov    (%ebx),%edx
  800ca9:	83 fa 7f             	cmp    $0x7f,%edx
  800cac:	7f 37                	jg     800ce5 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800cae:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800cb0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800cb3:	89 45 14             	mov    %eax,0x14(%ebp)
  800cb6:	e9 43 ff ff ff       	jmp    800bfe <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800cbb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cc0:	bf 51 37 80 00       	mov    $0x803751,%edi
							putch(ch, putdat);
  800cc5:	83 ec 08             	sub    $0x8,%esp
  800cc8:	53                   	push   %ebx
  800cc9:	50                   	push   %eax
  800cca:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800ccc:	83 c7 01             	add    $0x1,%edi
  800ccf:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800cd3:	83 c4 10             	add    $0x10,%esp
  800cd6:	85 c0                	test   %eax,%eax
  800cd8:	75 eb                	jne    800cc5 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800cda:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800cdd:	89 45 14             	mov    %eax,0x14(%ebp)
  800ce0:	e9 19 ff ff ff       	jmp    800bfe <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800ce5:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800ce7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cec:	bf 89 37 80 00       	mov    $0x803789,%edi
							putch(ch, putdat);
  800cf1:	83 ec 08             	sub    $0x8,%esp
  800cf4:	53                   	push   %ebx
  800cf5:	50                   	push   %eax
  800cf6:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800cf8:	83 c7 01             	add    $0x1,%edi
  800cfb:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800cff:	83 c4 10             	add    $0x10,%esp
  800d02:	85 c0                	test   %eax,%eax
  800d04:	75 eb                	jne    800cf1 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800d06:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d09:	89 45 14             	mov    %eax,0x14(%ebp)
  800d0c:	e9 ed fe ff ff       	jmp    800bfe <vprintfmt+0x446>
			putch(ch, putdat);
  800d11:	83 ec 08             	sub    $0x8,%esp
  800d14:	53                   	push   %ebx
  800d15:	6a 25                	push   $0x25
  800d17:	ff d6                	call   *%esi
			break;
  800d19:	83 c4 10             	add    $0x10,%esp
  800d1c:	e9 dd fe ff ff       	jmp    800bfe <vprintfmt+0x446>
			putch('%', putdat);
  800d21:	83 ec 08             	sub    $0x8,%esp
  800d24:	53                   	push   %ebx
  800d25:	6a 25                	push   $0x25
  800d27:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d29:	83 c4 10             	add    $0x10,%esp
  800d2c:	89 f8                	mov    %edi,%eax
  800d2e:	eb 03                	jmp    800d33 <vprintfmt+0x57b>
  800d30:	83 e8 01             	sub    $0x1,%eax
  800d33:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800d37:	75 f7                	jne    800d30 <vprintfmt+0x578>
  800d39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d3c:	e9 bd fe ff ff       	jmp    800bfe <vprintfmt+0x446>
}
  800d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d44:	5b                   	pop    %ebx
  800d45:	5e                   	pop    %esi
  800d46:	5f                   	pop    %edi
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    

00800d49 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	83 ec 18             	sub    $0x18,%esp
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d55:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d58:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800d5c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800d5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d66:	85 c0                	test   %eax,%eax
  800d68:	74 26                	je     800d90 <vsnprintf+0x47>
  800d6a:	85 d2                	test   %edx,%edx
  800d6c:	7e 22                	jle    800d90 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d6e:	ff 75 14             	pushl  0x14(%ebp)
  800d71:	ff 75 10             	pushl  0x10(%ebp)
  800d74:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d77:	50                   	push   %eax
  800d78:	68 7e 07 80 00       	push   $0x80077e
  800d7d:	e8 36 fa ff ff       	call   8007b8 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800d82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d85:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d8b:	83 c4 10             	add    $0x10,%esp
}
  800d8e:	c9                   	leave  
  800d8f:	c3                   	ret    
		return -E_INVAL;
  800d90:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d95:	eb f7                	jmp    800d8e <vsnprintf+0x45>

00800d97 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d97:	55                   	push   %ebp
  800d98:	89 e5                	mov    %esp,%ebp
  800d9a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d9d:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800da0:	50                   	push   %eax
  800da1:	ff 75 10             	pushl  0x10(%ebp)
  800da4:	ff 75 0c             	pushl  0xc(%ebp)
  800da7:	ff 75 08             	pushl  0x8(%ebp)
  800daa:	e8 9a ff ff ff       	call   800d49 <vsnprintf>
	va_end(ap);

	return rc;
}
  800daf:	c9                   	leave  
  800db0:	c3                   	ret    

00800db1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800db7:	b8 00 00 00 00       	mov    $0x0,%eax
  800dbc:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800dc0:	74 05                	je     800dc7 <strlen+0x16>
		n++;
  800dc2:	83 c0 01             	add    $0x1,%eax
  800dc5:	eb f5                	jmp    800dbc <strlen+0xb>
	return n;
}
  800dc7:	5d                   	pop    %ebp
  800dc8:	c3                   	ret    

00800dc9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800dc9:	55                   	push   %ebp
  800dca:	89 e5                	mov    %esp,%ebp
  800dcc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dd2:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd7:	39 c2                	cmp    %eax,%edx
  800dd9:	74 0d                	je     800de8 <strnlen+0x1f>
  800ddb:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800ddf:	74 05                	je     800de6 <strnlen+0x1d>
		n++;
  800de1:	83 c2 01             	add    $0x1,%edx
  800de4:	eb f1                	jmp    800dd7 <strnlen+0xe>
  800de6:	89 d0                	mov    %edx,%eax
	return n;
}
  800de8:	5d                   	pop    %ebp
  800de9:	c3                   	ret    

00800dea <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800dea:	55                   	push   %ebp
  800deb:	89 e5                	mov    %esp,%ebp
  800ded:	53                   	push   %ebx
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800df4:	ba 00 00 00 00       	mov    $0x0,%edx
  800df9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800dfd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800e00:	83 c2 01             	add    $0x1,%edx
  800e03:	84 c9                	test   %cl,%cl
  800e05:	75 f2                	jne    800df9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800e07:	5b                   	pop    %ebx
  800e08:	5d                   	pop    %ebp
  800e09:	c3                   	ret    

00800e0a <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	53                   	push   %ebx
  800e0e:	83 ec 10             	sub    $0x10,%esp
  800e11:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800e14:	53                   	push   %ebx
  800e15:	e8 97 ff ff ff       	call   800db1 <strlen>
  800e1a:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800e1d:	ff 75 0c             	pushl  0xc(%ebp)
  800e20:	01 d8                	add    %ebx,%eax
  800e22:	50                   	push   %eax
  800e23:	e8 c2 ff ff ff       	call   800dea <strcpy>
	return dst;
}
  800e28:	89 d8                	mov    %ebx,%eax
  800e2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e2d:	c9                   	leave  
  800e2e:	c3                   	ret    

00800e2f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	56                   	push   %esi
  800e33:	53                   	push   %ebx
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3a:	89 c6                	mov    %eax,%esi
  800e3c:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e3f:	89 c2                	mov    %eax,%edx
  800e41:	39 f2                	cmp    %esi,%edx
  800e43:	74 11                	je     800e56 <strncpy+0x27>
		*dst++ = *src;
  800e45:	83 c2 01             	add    $0x1,%edx
  800e48:	0f b6 19             	movzbl (%ecx),%ebx
  800e4b:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800e4e:	80 fb 01             	cmp    $0x1,%bl
  800e51:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800e54:	eb eb                	jmp    800e41 <strncpy+0x12>
	}
	return ret;
}
  800e56:	5b                   	pop    %ebx
  800e57:	5e                   	pop    %esi
  800e58:	5d                   	pop    %ebp
  800e59:	c3                   	ret    

00800e5a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800e5a:	55                   	push   %ebp
  800e5b:	89 e5                	mov    %esp,%ebp
  800e5d:	56                   	push   %esi
  800e5e:	53                   	push   %ebx
  800e5f:	8b 75 08             	mov    0x8(%ebp),%esi
  800e62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e65:	8b 55 10             	mov    0x10(%ebp),%edx
  800e68:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800e6a:	85 d2                	test   %edx,%edx
  800e6c:	74 21                	je     800e8f <strlcpy+0x35>
  800e6e:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800e72:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800e74:	39 c2                	cmp    %eax,%edx
  800e76:	74 14                	je     800e8c <strlcpy+0x32>
  800e78:	0f b6 19             	movzbl (%ecx),%ebx
  800e7b:	84 db                	test   %bl,%bl
  800e7d:	74 0b                	je     800e8a <strlcpy+0x30>
			*dst++ = *src++;
  800e7f:	83 c1 01             	add    $0x1,%ecx
  800e82:	83 c2 01             	add    $0x1,%edx
  800e85:	88 5a ff             	mov    %bl,-0x1(%edx)
  800e88:	eb ea                	jmp    800e74 <strlcpy+0x1a>
  800e8a:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800e8c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e8f:	29 f0                	sub    %esi,%eax
}
  800e91:	5b                   	pop    %ebx
  800e92:	5e                   	pop    %esi
  800e93:	5d                   	pop    %ebp
  800e94:	c3                   	ret    

00800e95 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e95:	55                   	push   %ebp
  800e96:	89 e5                	mov    %esp,%ebp
  800e98:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e9b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800e9e:	0f b6 01             	movzbl (%ecx),%eax
  800ea1:	84 c0                	test   %al,%al
  800ea3:	74 0c                	je     800eb1 <strcmp+0x1c>
  800ea5:	3a 02                	cmp    (%edx),%al
  800ea7:	75 08                	jne    800eb1 <strcmp+0x1c>
		p++, q++;
  800ea9:	83 c1 01             	add    $0x1,%ecx
  800eac:	83 c2 01             	add    $0x1,%edx
  800eaf:	eb ed                	jmp    800e9e <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800eb1:	0f b6 c0             	movzbl %al,%eax
  800eb4:	0f b6 12             	movzbl (%edx),%edx
  800eb7:	29 d0                	sub    %edx,%eax
}
  800eb9:	5d                   	pop    %ebp
  800eba:	c3                   	ret    

00800ebb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ebb:	55                   	push   %ebp
  800ebc:	89 e5                	mov    %esp,%ebp
  800ebe:	53                   	push   %ebx
  800ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec5:	89 c3                	mov    %eax,%ebx
  800ec7:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800eca:	eb 06                	jmp    800ed2 <strncmp+0x17>
		n--, p++, q++;
  800ecc:	83 c0 01             	add    $0x1,%eax
  800ecf:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ed2:	39 d8                	cmp    %ebx,%eax
  800ed4:	74 16                	je     800eec <strncmp+0x31>
  800ed6:	0f b6 08             	movzbl (%eax),%ecx
  800ed9:	84 c9                	test   %cl,%cl
  800edb:	74 04                	je     800ee1 <strncmp+0x26>
  800edd:	3a 0a                	cmp    (%edx),%cl
  800edf:	74 eb                	je     800ecc <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ee1:	0f b6 00             	movzbl (%eax),%eax
  800ee4:	0f b6 12             	movzbl (%edx),%edx
  800ee7:	29 d0                	sub    %edx,%eax
}
  800ee9:	5b                   	pop    %ebx
  800eea:	5d                   	pop    %ebp
  800eeb:	c3                   	ret    
		return 0;
  800eec:	b8 00 00 00 00       	mov    $0x0,%eax
  800ef1:	eb f6                	jmp    800ee9 <strncmp+0x2e>

00800ef3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800efd:	0f b6 10             	movzbl (%eax),%edx
  800f00:	84 d2                	test   %dl,%dl
  800f02:	74 09                	je     800f0d <strchr+0x1a>
		if (*s == c)
  800f04:	38 ca                	cmp    %cl,%dl
  800f06:	74 0a                	je     800f12 <strchr+0x1f>
	for (; *s; s++)
  800f08:	83 c0 01             	add    $0x1,%eax
  800f0b:	eb f0                	jmp    800efd <strchr+0xa>
			return (char *) s;
	return 0;
  800f0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f12:	5d                   	pop    %ebp
  800f13:	c3                   	ret    

00800f14 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f14:	55                   	push   %ebp
  800f15:	89 e5                	mov    %esp,%ebp
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800f1e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800f21:	38 ca                	cmp    %cl,%dl
  800f23:	74 09                	je     800f2e <strfind+0x1a>
  800f25:	84 d2                	test   %dl,%dl
  800f27:	74 05                	je     800f2e <strfind+0x1a>
	for (; *s; s++)
  800f29:	83 c0 01             	add    $0x1,%eax
  800f2c:	eb f0                	jmp    800f1e <strfind+0xa>
			break;
	return (char *) s;
}
  800f2e:	5d                   	pop    %ebp
  800f2f:	c3                   	ret    

00800f30 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800f30:	55                   	push   %ebp
  800f31:	89 e5                	mov    %esp,%ebp
  800f33:	57                   	push   %edi
  800f34:	56                   	push   %esi
  800f35:	53                   	push   %ebx
  800f36:	8b 7d 08             	mov    0x8(%ebp),%edi
  800f39:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800f3c:	85 c9                	test   %ecx,%ecx
  800f3e:	74 31                	je     800f71 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800f40:	89 f8                	mov    %edi,%eax
  800f42:	09 c8                	or     %ecx,%eax
  800f44:	a8 03                	test   $0x3,%al
  800f46:	75 23                	jne    800f6b <memset+0x3b>
		c &= 0xFF;
  800f48:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800f4c:	89 d3                	mov    %edx,%ebx
  800f4e:	c1 e3 08             	shl    $0x8,%ebx
  800f51:	89 d0                	mov    %edx,%eax
  800f53:	c1 e0 18             	shl    $0x18,%eax
  800f56:	89 d6                	mov    %edx,%esi
  800f58:	c1 e6 10             	shl    $0x10,%esi
  800f5b:	09 f0                	or     %esi,%eax
  800f5d:	09 c2                	or     %eax,%edx
  800f5f:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800f61:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800f64:	89 d0                	mov    %edx,%eax
  800f66:	fc                   	cld    
  800f67:	f3 ab                	rep stos %eax,%es:(%edi)
  800f69:	eb 06                	jmp    800f71 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6e:	fc                   	cld    
  800f6f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800f71:	89 f8                	mov    %edi,%eax
  800f73:	5b                   	pop    %ebx
  800f74:	5e                   	pop    %esi
  800f75:	5f                   	pop    %edi
  800f76:	5d                   	pop    %ebp
  800f77:	c3                   	ret    

00800f78 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800f78:	55                   	push   %ebp
  800f79:	89 e5                	mov    %esp,%ebp
  800f7b:	57                   	push   %edi
  800f7c:	56                   	push   %esi
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f80:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f83:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f86:	39 c6                	cmp    %eax,%esi
  800f88:	73 32                	jae    800fbc <memmove+0x44>
  800f8a:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800f8d:	39 c2                	cmp    %eax,%edx
  800f8f:	76 2b                	jbe    800fbc <memmove+0x44>
		s += n;
		d += n;
  800f91:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f94:	89 fe                	mov    %edi,%esi
  800f96:	09 ce                	or     %ecx,%esi
  800f98:	09 d6                	or     %edx,%esi
  800f9a:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800fa0:	75 0e                	jne    800fb0 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800fa2:	83 ef 04             	sub    $0x4,%edi
  800fa5:	8d 72 fc             	lea    -0x4(%edx),%esi
  800fa8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800fab:	fd                   	std    
  800fac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800fae:	eb 09                	jmp    800fb9 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800fb0:	83 ef 01             	sub    $0x1,%edi
  800fb3:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800fb6:	fd                   	std    
  800fb7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800fb9:	fc                   	cld    
  800fba:	eb 1a                	jmp    800fd6 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800fbc:	89 c2                	mov    %eax,%edx
  800fbe:	09 ca                	or     %ecx,%edx
  800fc0:	09 f2                	or     %esi,%edx
  800fc2:	f6 c2 03             	test   $0x3,%dl
  800fc5:	75 0a                	jne    800fd1 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800fc7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800fca:	89 c7                	mov    %eax,%edi
  800fcc:	fc                   	cld    
  800fcd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800fcf:	eb 05                	jmp    800fd6 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800fd1:	89 c7                	mov    %eax,%edi
  800fd3:	fc                   	cld    
  800fd4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800fd6:	5e                   	pop    %esi
  800fd7:	5f                   	pop    %edi
  800fd8:	5d                   	pop    %ebp
  800fd9:	c3                   	ret    

00800fda <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800fda:	55                   	push   %ebp
  800fdb:	89 e5                	mov    %esp,%ebp
  800fdd:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800fe0:	ff 75 10             	pushl  0x10(%ebp)
  800fe3:	ff 75 0c             	pushl  0xc(%ebp)
  800fe6:	ff 75 08             	pushl  0x8(%ebp)
  800fe9:	e8 8a ff ff ff       	call   800f78 <memmove>
}
  800fee:	c9                   	leave  
  800fef:	c3                   	ret    

00800ff0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ff0:	55                   	push   %ebp
  800ff1:	89 e5                	mov    %esp,%ebp
  800ff3:	56                   	push   %esi
  800ff4:	53                   	push   %ebx
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ffb:	89 c6                	mov    %eax,%esi
  800ffd:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801000:	39 f0                	cmp    %esi,%eax
  801002:	74 1c                	je     801020 <memcmp+0x30>
		if (*s1 != *s2)
  801004:	0f b6 08             	movzbl (%eax),%ecx
  801007:	0f b6 1a             	movzbl (%edx),%ebx
  80100a:	38 d9                	cmp    %bl,%cl
  80100c:	75 08                	jne    801016 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  80100e:	83 c0 01             	add    $0x1,%eax
  801011:	83 c2 01             	add    $0x1,%edx
  801014:	eb ea                	jmp    801000 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801016:	0f b6 c1             	movzbl %cl,%eax
  801019:	0f b6 db             	movzbl %bl,%ebx
  80101c:	29 d8                	sub    %ebx,%eax
  80101e:	eb 05                	jmp    801025 <memcmp+0x35>
	}

	return 0;
  801020:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801025:	5b                   	pop    %ebx
  801026:	5e                   	pop    %esi
  801027:	5d                   	pop    %ebp
  801028:	c3                   	ret    

00801029 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801032:	89 c2                	mov    %eax,%edx
  801034:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801037:	39 d0                	cmp    %edx,%eax
  801039:	73 09                	jae    801044 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  80103b:	38 08                	cmp    %cl,(%eax)
  80103d:	74 05                	je     801044 <memfind+0x1b>
	for (; s < ends; s++)
  80103f:	83 c0 01             	add    $0x1,%eax
  801042:	eb f3                	jmp    801037 <memfind+0xe>
			break;
	return (void *) s;
}
  801044:	5d                   	pop    %ebp
  801045:	c3                   	ret    

00801046 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801046:	55                   	push   %ebp
  801047:	89 e5                	mov    %esp,%ebp
  801049:	57                   	push   %edi
  80104a:	56                   	push   %esi
  80104b:	53                   	push   %ebx
  80104c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80104f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801052:	eb 03                	jmp    801057 <strtol+0x11>
		s++;
  801054:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801057:	0f b6 01             	movzbl (%ecx),%eax
  80105a:	3c 20                	cmp    $0x20,%al
  80105c:	74 f6                	je     801054 <strtol+0xe>
  80105e:	3c 09                	cmp    $0x9,%al
  801060:	74 f2                	je     801054 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801062:	3c 2b                	cmp    $0x2b,%al
  801064:	74 2a                	je     801090 <strtol+0x4a>
	int neg = 0;
  801066:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  80106b:	3c 2d                	cmp    $0x2d,%al
  80106d:	74 2b                	je     80109a <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80106f:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801075:	75 0f                	jne    801086 <strtol+0x40>
  801077:	80 39 30             	cmpb   $0x30,(%ecx)
  80107a:	74 28                	je     8010a4 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  80107c:	85 db                	test   %ebx,%ebx
  80107e:	b8 0a 00 00 00       	mov    $0xa,%eax
  801083:	0f 44 d8             	cmove  %eax,%ebx
  801086:	b8 00 00 00 00       	mov    $0x0,%eax
  80108b:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80108e:	eb 50                	jmp    8010e0 <strtol+0x9a>
		s++;
  801090:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801093:	bf 00 00 00 00       	mov    $0x0,%edi
  801098:	eb d5                	jmp    80106f <strtol+0x29>
		s++, neg = 1;
  80109a:	83 c1 01             	add    $0x1,%ecx
  80109d:	bf 01 00 00 00       	mov    $0x1,%edi
  8010a2:	eb cb                	jmp    80106f <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010a4:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8010a8:	74 0e                	je     8010b8 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  8010aa:	85 db                	test   %ebx,%ebx
  8010ac:	75 d8                	jne    801086 <strtol+0x40>
		s++, base = 8;
  8010ae:	83 c1 01             	add    $0x1,%ecx
  8010b1:	bb 08 00 00 00       	mov    $0x8,%ebx
  8010b6:	eb ce                	jmp    801086 <strtol+0x40>
		s += 2, base = 16;
  8010b8:	83 c1 02             	add    $0x2,%ecx
  8010bb:	bb 10 00 00 00       	mov    $0x10,%ebx
  8010c0:	eb c4                	jmp    801086 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  8010c2:	8d 72 9f             	lea    -0x61(%edx),%esi
  8010c5:	89 f3                	mov    %esi,%ebx
  8010c7:	80 fb 19             	cmp    $0x19,%bl
  8010ca:	77 29                	ja     8010f5 <strtol+0xaf>
			dig = *s - 'a' + 10;
  8010cc:	0f be d2             	movsbl %dl,%edx
  8010cf:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8010d2:	3b 55 10             	cmp    0x10(%ebp),%edx
  8010d5:	7d 30                	jge    801107 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  8010d7:	83 c1 01             	add    $0x1,%ecx
  8010da:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010de:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8010e0:	0f b6 11             	movzbl (%ecx),%edx
  8010e3:	8d 72 d0             	lea    -0x30(%edx),%esi
  8010e6:	89 f3                	mov    %esi,%ebx
  8010e8:	80 fb 09             	cmp    $0x9,%bl
  8010eb:	77 d5                	ja     8010c2 <strtol+0x7c>
			dig = *s - '0';
  8010ed:	0f be d2             	movsbl %dl,%edx
  8010f0:	83 ea 30             	sub    $0x30,%edx
  8010f3:	eb dd                	jmp    8010d2 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  8010f5:	8d 72 bf             	lea    -0x41(%edx),%esi
  8010f8:	89 f3                	mov    %esi,%ebx
  8010fa:	80 fb 19             	cmp    $0x19,%bl
  8010fd:	77 08                	ja     801107 <strtol+0xc1>
			dig = *s - 'A' + 10;
  8010ff:	0f be d2             	movsbl %dl,%edx
  801102:	83 ea 37             	sub    $0x37,%edx
  801105:	eb cb                	jmp    8010d2 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  801107:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80110b:	74 05                	je     801112 <strtol+0xcc>
		*endptr = (char *) s;
  80110d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801110:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801112:	89 c2                	mov    %eax,%edx
  801114:	f7 da                	neg    %edx
  801116:	85 ff                	test   %edi,%edi
  801118:	0f 45 c2             	cmovne %edx,%eax
}
  80111b:	5b                   	pop    %ebx
  80111c:	5e                   	pop    %esi
  80111d:	5f                   	pop    %edi
  80111e:	5d                   	pop    %ebp
  80111f:	c3                   	ret    

00801120 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
  801123:	57                   	push   %edi
  801124:	56                   	push   %esi
  801125:	53                   	push   %ebx
	asm volatile("int %1\n"
  801126:	b8 00 00 00 00       	mov    $0x0,%eax
  80112b:	8b 55 08             	mov    0x8(%ebp),%edx
  80112e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801131:	89 c3                	mov    %eax,%ebx
  801133:	89 c7                	mov    %eax,%edi
  801135:	89 c6                	mov    %eax,%esi
  801137:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801139:	5b                   	pop    %ebx
  80113a:	5e                   	pop    %esi
  80113b:	5f                   	pop    %edi
  80113c:	5d                   	pop    %ebp
  80113d:	c3                   	ret    

0080113e <sys_cgetc>:

int
sys_cgetc(void)
{
  80113e:	55                   	push   %ebp
  80113f:	89 e5                	mov    %esp,%ebp
  801141:	57                   	push   %edi
  801142:	56                   	push   %esi
  801143:	53                   	push   %ebx
	asm volatile("int %1\n"
  801144:	ba 00 00 00 00       	mov    $0x0,%edx
  801149:	b8 01 00 00 00       	mov    $0x1,%eax
  80114e:	89 d1                	mov    %edx,%ecx
  801150:	89 d3                	mov    %edx,%ebx
  801152:	89 d7                	mov    %edx,%edi
  801154:	89 d6                	mov    %edx,%esi
  801156:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801158:	5b                   	pop    %ebx
  801159:	5e                   	pop    %esi
  80115a:	5f                   	pop    %edi
  80115b:	5d                   	pop    %ebp
  80115c:	c3                   	ret    

0080115d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80115d:	55                   	push   %ebp
  80115e:	89 e5                	mov    %esp,%ebp
  801160:	57                   	push   %edi
  801161:	56                   	push   %esi
  801162:	53                   	push   %ebx
  801163:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801166:	b9 00 00 00 00       	mov    $0x0,%ecx
  80116b:	8b 55 08             	mov    0x8(%ebp),%edx
  80116e:	b8 03 00 00 00       	mov    $0x3,%eax
  801173:	89 cb                	mov    %ecx,%ebx
  801175:	89 cf                	mov    %ecx,%edi
  801177:	89 ce                	mov    %ecx,%esi
  801179:	cd 30                	int    $0x30
	if(check && ret > 0)
  80117b:	85 c0                	test   %eax,%eax
  80117d:	7f 08                	jg     801187 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80117f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801182:	5b                   	pop    %ebx
  801183:	5e                   	pop    %esi
  801184:	5f                   	pop    %edi
  801185:	5d                   	pop    %ebp
  801186:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801187:	83 ec 0c             	sub    $0xc,%esp
  80118a:	50                   	push   %eax
  80118b:	6a 03                	push   $0x3
  80118d:	68 a8 39 80 00       	push   $0x8039a8
  801192:	6a 43                	push   $0x43
  801194:	68 c5 39 80 00       	push   $0x8039c5
  801199:	e8 f7 f3 ff ff       	call   800595 <_panic>

0080119e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80119e:	55                   	push   %ebp
  80119f:	89 e5                	mov    %esp,%ebp
  8011a1:	57                   	push   %edi
  8011a2:	56                   	push   %esi
  8011a3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8011a9:	b8 02 00 00 00       	mov    $0x2,%eax
  8011ae:	89 d1                	mov    %edx,%ecx
  8011b0:	89 d3                	mov    %edx,%ebx
  8011b2:	89 d7                	mov    %edx,%edi
  8011b4:	89 d6                	mov    %edx,%esi
  8011b6:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8011b8:	5b                   	pop    %ebx
  8011b9:	5e                   	pop    %esi
  8011ba:	5f                   	pop    %edi
  8011bb:	5d                   	pop    %ebp
  8011bc:	c3                   	ret    

008011bd <sys_yield>:

void
sys_yield(void)
{
  8011bd:	55                   	push   %ebp
  8011be:	89 e5                	mov    %esp,%ebp
  8011c0:	57                   	push   %edi
  8011c1:	56                   	push   %esi
  8011c2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8011c8:	b8 0b 00 00 00       	mov    $0xb,%eax
  8011cd:	89 d1                	mov    %edx,%ecx
  8011cf:	89 d3                	mov    %edx,%ebx
  8011d1:	89 d7                	mov    %edx,%edi
  8011d3:	89 d6                	mov    %edx,%esi
  8011d5:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8011d7:	5b                   	pop    %ebx
  8011d8:	5e                   	pop    %esi
  8011d9:	5f                   	pop    %edi
  8011da:	5d                   	pop    %ebp
  8011db:	c3                   	ret    

008011dc <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8011dc:	55                   	push   %ebp
  8011dd:	89 e5                	mov    %esp,%ebp
  8011df:	57                   	push   %edi
  8011e0:	56                   	push   %esi
  8011e1:	53                   	push   %ebx
  8011e2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011e5:	be 00 00 00 00       	mov    $0x0,%esi
  8011ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011f0:	b8 04 00 00 00       	mov    $0x4,%eax
  8011f5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011f8:	89 f7                	mov    %esi,%edi
  8011fa:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011fc:	85 c0                	test   %eax,%eax
  8011fe:	7f 08                	jg     801208 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801200:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801203:	5b                   	pop    %ebx
  801204:	5e                   	pop    %esi
  801205:	5f                   	pop    %edi
  801206:	5d                   	pop    %ebp
  801207:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801208:	83 ec 0c             	sub    $0xc,%esp
  80120b:	50                   	push   %eax
  80120c:	6a 04                	push   $0x4
  80120e:	68 a8 39 80 00       	push   $0x8039a8
  801213:	6a 43                	push   $0x43
  801215:	68 c5 39 80 00       	push   $0x8039c5
  80121a:	e8 76 f3 ff ff       	call   800595 <_panic>

0080121f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80121f:	55                   	push   %ebp
  801220:	89 e5                	mov    %esp,%ebp
  801222:	57                   	push   %edi
  801223:	56                   	push   %esi
  801224:	53                   	push   %ebx
  801225:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801228:	8b 55 08             	mov    0x8(%ebp),%edx
  80122b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80122e:	b8 05 00 00 00       	mov    $0x5,%eax
  801233:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801236:	8b 7d 14             	mov    0x14(%ebp),%edi
  801239:	8b 75 18             	mov    0x18(%ebp),%esi
  80123c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80123e:	85 c0                	test   %eax,%eax
  801240:	7f 08                	jg     80124a <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801242:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801245:	5b                   	pop    %ebx
  801246:	5e                   	pop    %esi
  801247:	5f                   	pop    %edi
  801248:	5d                   	pop    %ebp
  801249:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80124a:	83 ec 0c             	sub    $0xc,%esp
  80124d:	50                   	push   %eax
  80124e:	6a 05                	push   $0x5
  801250:	68 a8 39 80 00       	push   $0x8039a8
  801255:	6a 43                	push   $0x43
  801257:	68 c5 39 80 00       	push   $0x8039c5
  80125c:	e8 34 f3 ff ff       	call   800595 <_panic>

00801261 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801261:	55                   	push   %ebp
  801262:	89 e5                	mov    %esp,%ebp
  801264:	57                   	push   %edi
  801265:	56                   	push   %esi
  801266:	53                   	push   %ebx
  801267:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80126a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80126f:	8b 55 08             	mov    0x8(%ebp),%edx
  801272:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801275:	b8 06 00 00 00       	mov    $0x6,%eax
  80127a:	89 df                	mov    %ebx,%edi
  80127c:	89 de                	mov    %ebx,%esi
  80127e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801280:	85 c0                	test   %eax,%eax
  801282:	7f 08                	jg     80128c <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801284:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801287:	5b                   	pop    %ebx
  801288:	5e                   	pop    %esi
  801289:	5f                   	pop    %edi
  80128a:	5d                   	pop    %ebp
  80128b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80128c:	83 ec 0c             	sub    $0xc,%esp
  80128f:	50                   	push   %eax
  801290:	6a 06                	push   $0x6
  801292:	68 a8 39 80 00       	push   $0x8039a8
  801297:	6a 43                	push   $0x43
  801299:	68 c5 39 80 00       	push   $0x8039c5
  80129e:	e8 f2 f2 ff ff       	call   800595 <_panic>

008012a3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
  8012a6:	57                   	push   %edi
  8012a7:	56                   	push   %esi
  8012a8:	53                   	push   %ebx
  8012a9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8012b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012b7:	b8 08 00 00 00       	mov    $0x8,%eax
  8012bc:	89 df                	mov    %ebx,%edi
  8012be:	89 de                	mov    %ebx,%esi
  8012c0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012c2:	85 c0                	test   %eax,%eax
  8012c4:	7f 08                	jg     8012ce <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8012c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012c9:	5b                   	pop    %ebx
  8012ca:	5e                   	pop    %esi
  8012cb:	5f                   	pop    %edi
  8012cc:	5d                   	pop    %ebp
  8012cd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012ce:	83 ec 0c             	sub    $0xc,%esp
  8012d1:	50                   	push   %eax
  8012d2:	6a 08                	push   $0x8
  8012d4:	68 a8 39 80 00       	push   $0x8039a8
  8012d9:	6a 43                	push   $0x43
  8012db:	68 c5 39 80 00       	push   $0x8039c5
  8012e0:	e8 b0 f2 ff ff       	call   800595 <_panic>

008012e5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8012e5:	55                   	push   %ebp
  8012e6:	89 e5                	mov    %esp,%ebp
  8012e8:	57                   	push   %edi
  8012e9:	56                   	push   %esi
  8012ea:	53                   	push   %ebx
  8012eb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012ee:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012f9:	b8 09 00 00 00       	mov    $0x9,%eax
  8012fe:	89 df                	mov    %ebx,%edi
  801300:	89 de                	mov    %ebx,%esi
  801302:	cd 30                	int    $0x30
	if(check && ret > 0)
  801304:	85 c0                	test   %eax,%eax
  801306:	7f 08                	jg     801310 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801308:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80130b:	5b                   	pop    %ebx
  80130c:	5e                   	pop    %esi
  80130d:	5f                   	pop    %edi
  80130e:	5d                   	pop    %ebp
  80130f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801310:	83 ec 0c             	sub    $0xc,%esp
  801313:	50                   	push   %eax
  801314:	6a 09                	push   $0x9
  801316:	68 a8 39 80 00       	push   $0x8039a8
  80131b:	6a 43                	push   $0x43
  80131d:	68 c5 39 80 00       	push   $0x8039c5
  801322:	e8 6e f2 ff ff       	call   800595 <_panic>

00801327 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
  80132a:	57                   	push   %edi
  80132b:	56                   	push   %esi
  80132c:	53                   	push   %ebx
  80132d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801330:	bb 00 00 00 00       	mov    $0x0,%ebx
  801335:	8b 55 08             	mov    0x8(%ebp),%edx
  801338:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80133b:	b8 0a 00 00 00       	mov    $0xa,%eax
  801340:	89 df                	mov    %ebx,%edi
  801342:	89 de                	mov    %ebx,%esi
  801344:	cd 30                	int    $0x30
	if(check && ret > 0)
  801346:	85 c0                	test   %eax,%eax
  801348:	7f 08                	jg     801352 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80134a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80134d:	5b                   	pop    %ebx
  80134e:	5e                   	pop    %esi
  80134f:	5f                   	pop    %edi
  801350:	5d                   	pop    %ebp
  801351:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801352:	83 ec 0c             	sub    $0xc,%esp
  801355:	50                   	push   %eax
  801356:	6a 0a                	push   $0xa
  801358:	68 a8 39 80 00       	push   $0x8039a8
  80135d:	6a 43                	push   $0x43
  80135f:	68 c5 39 80 00       	push   $0x8039c5
  801364:	e8 2c f2 ff ff       	call   800595 <_panic>

00801369 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801369:	55                   	push   %ebp
  80136a:	89 e5                	mov    %esp,%ebp
  80136c:	57                   	push   %edi
  80136d:	56                   	push   %esi
  80136e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80136f:	8b 55 08             	mov    0x8(%ebp),%edx
  801372:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801375:	b8 0c 00 00 00       	mov    $0xc,%eax
  80137a:	be 00 00 00 00       	mov    $0x0,%esi
  80137f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801382:	8b 7d 14             	mov    0x14(%ebp),%edi
  801385:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801387:	5b                   	pop    %ebx
  801388:	5e                   	pop    %esi
  801389:	5f                   	pop    %edi
  80138a:	5d                   	pop    %ebp
  80138b:	c3                   	ret    

0080138c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80138c:	55                   	push   %ebp
  80138d:	89 e5                	mov    %esp,%ebp
  80138f:	57                   	push   %edi
  801390:	56                   	push   %esi
  801391:	53                   	push   %ebx
  801392:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801395:	b9 00 00 00 00       	mov    $0x0,%ecx
  80139a:	8b 55 08             	mov    0x8(%ebp),%edx
  80139d:	b8 0d 00 00 00       	mov    $0xd,%eax
  8013a2:	89 cb                	mov    %ecx,%ebx
  8013a4:	89 cf                	mov    %ecx,%edi
  8013a6:	89 ce                	mov    %ecx,%esi
  8013a8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013aa:	85 c0                	test   %eax,%eax
  8013ac:	7f 08                	jg     8013b6 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8013ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013b1:	5b                   	pop    %ebx
  8013b2:	5e                   	pop    %esi
  8013b3:	5f                   	pop    %edi
  8013b4:	5d                   	pop    %ebp
  8013b5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013b6:	83 ec 0c             	sub    $0xc,%esp
  8013b9:	50                   	push   %eax
  8013ba:	6a 0d                	push   $0xd
  8013bc:	68 a8 39 80 00       	push   $0x8039a8
  8013c1:	6a 43                	push   $0x43
  8013c3:	68 c5 39 80 00       	push   $0x8039c5
  8013c8:	e8 c8 f1 ff ff       	call   800595 <_panic>

008013cd <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8013cd:	55                   	push   %ebp
  8013ce:	89 e5                	mov    %esp,%ebp
  8013d0:	57                   	push   %edi
  8013d1:	56                   	push   %esi
  8013d2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8013db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013de:	b8 0e 00 00 00       	mov    $0xe,%eax
  8013e3:	89 df                	mov    %ebx,%edi
  8013e5:	89 de                	mov    %ebx,%esi
  8013e7:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8013e9:	5b                   	pop    %ebx
  8013ea:	5e                   	pop    %esi
  8013eb:	5f                   	pop    %edi
  8013ec:	5d                   	pop    %ebp
  8013ed:	c3                   	ret    

008013ee <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8013ee:	55                   	push   %ebp
  8013ef:	89 e5                	mov    %esp,%ebp
  8013f1:	57                   	push   %edi
  8013f2:	56                   	push   %esi
  8013f3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8013f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8013fc:	b8 0f 00 00 00       	mov    $0xf,%eax
  801401:	89 cb                	mov    %ecx,%ebx
  801403:	89 cf                	mov    %ecx,%edi
  801405:	89 ce                	mov    %ecx,%esi
  801407:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801409:	5b                   	pop    %ebx
  80140a:	5e                   	pop    %esi
  80140b:	5f                   	pop    %edi
  80140c:	5d                   	pop    %ebp
  80140d:	c3                   	ret    

0080140e <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80140e:	55                   	push   %ebp
  80140f:	89 e5                	mov    %esp,%ebp
  801411:	57                   	push   %edi
  801412:	56                   	push   %esi
  801413:	53                   	push   %ebx
	asm volatile("int %1\n"
  801414:	ba 00 00 00 00       	mov    $0x0,%edx
  801419:	b8 10 00 00 00       	mov    $0x10,%eax
  80141e:	89 d1                	mov    %edx,%ecx
  801420:	89 d3                	mov    %edx,%ebx
  801422:	89 d7                	mov    %edx,%edi
  801424:	89 d6                	mov    %edx,%esi
  801426:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801428:	5b                   	pop    %ebx
  801429:	5e                   	pop    %esi
  80142a:	5f                   	pop    %edi
  80142b:	5d                   	pop    %ebp
  80142c:	c3                   	ret    

0080142d <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  80142d:	55                   	push   %ebp
  80142e:	89 e5                	mov    %esp,%ebp
  801430:	57                   	push   %edi
  801431:	56                   	push   %esi
  801432:	53                   	push   %ebx
	asm volatile("int %1\n"
  801433:	bb 00 00 00 00       	mov    $0x0,%ebx
  801438:	8b 55 08             	mov    0x8(%ebp),%edx
  80143b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80143e:	b8 11 00 00 00       	mov    $0x11,%eax
  801443:	89 df                	mov    %ebx,%edi
  801445:	89 de                	mov    %ebx,%esi
  801447:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801449:	5b                   	pop    %ebx
  80144a:	5e                   	pop    %esi
  80144b:	5f                   	pop    %edi
  80144c:	5d                   	pop    %ebp
  80144d:	c3                   	ret    

0080144e <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  80144e:	55                   	push   %ebp
  80144f:	89 e5                	mov    %esp,%ebp
  801451:	57                   	push   %edi
  801452:	56                   	push   %esi
  801453:	53                   	push   %ebx
	asm volatile("int %1\n"
  801454:	bb 00 00 00 00       	mov    $0x0,%ebx
  801459:	8b 55 08             	mov    0x8(%ebp),%edx
  80145c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80145f:	b8 12 00 00 00       	mov    $0x12,%eax
  801464:	89 df                	mov    %ebx,%edi
  801466:	89 de                	mov    %ebx,%esi
  801468:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80146a:	5b                   	pop    %ebx
  80146b:	5e                   	pop    %esi
  80146c:	5f                   	pop    %edi
  80146d:	5d                   	pop    %ebp
  80146e:	c3                   	ret    

0080146f <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80146f:	55                   	push   %ebp
  801470:	89 e5                	mov    %esp,%ebp
  801472:	57                   	push   %edi
  801473:	56                   	push   %esi
  801474:	53                   	push   %ebx
  801475:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801478:	bb 00 00 00 00       	mov    $0x0,%ebx
  80147d:	8b 55 08             	mov    0x8(%ebp),%edx
  801480:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801483:	b8 13 00 00 00       	mov    $0x13,%eax
  801488:	89 df                	mov    %ebx,%edi
  80148a:	89 de                	mov    %ebx,%esi
  80148c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80148e:	85 c0                	test   %eax,%eax
  801490:	7f 08                	jg     80149a <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801492:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801495:	5b                   	pop    %ebx
  801496:	5e                   	pop    %esi
  801497:	5f                   	pop    %edi
  801498:	5d                   	pop    %ebp
  801499:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80149a:	83 ec 0c             	sub    $0xc,%esp
  80149d:	50                   	push   %eax
  80149e:	6a 13                	push   $0x13
  8014a0:	68 a8 39 80 00       	push   $0x8039a8
  8014a5:	6a 43                	push   $0x43
  8014a7:	68 c5 39 80 00       	push   $0x8039c5
  8014ac:	e8 e4 f0 ff ff       	call   800595 <_panic>

008014b1 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8014b1:	55                   	push   %ebp
  8014b2:	89 e5                	mov    %esp,%ebp
  8014b4:	57                   	push   %edi
  8014b5:	56                   	push   %esi
  8014b6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014b7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8014bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8014bf:	b8 14 00 00 00       	mov    $0x14,%eax
  8014c4:	89 cb                	mov    %ecx,%ebx
  8014c6:	89 cf                	mov    %ecx,%edi
  8014c8:	89 ce                	mov    %ecx,%esi
  8014ca:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  8014cc:	5b                   	pop    %ebx
  8014cd:	5e                   	pop    %esi
  8014ce:	5f                   	pop    %edi
  8014cf:	5d                   	pop    %ebp
  8014d0:	c3                   	ret    

008014d1 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
  8014d4:	53                   	push   %ebx
  8014d5:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  8014d8:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8014df:	f6 c5 04             	test   $0x4,%ch
  8014e2:	75 45                	jne    801529 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8014e4:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8014eb:	83 e1 07             	and    $0x7,%ecx
  8014ee:	83 f9 07             	cmp    $0x7,%ecx
  8014f1:	74 6f                	je     801562 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8014f3:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8014fa:	81 e1 05 08 00 00    	and    $0x805,%ecx
  801500:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801506:	0f 84 b6 00 00 00    	je     8015c2 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  80150c:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801513:	83 e1 05             	and    $0x5,%ecx
  801516:	83 f9 05             	cmp    $0x5,%ecx
  801519:	0f 84 d7 00 00 00    	je     8015f6 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  80151f:	b8 00 00 00 00       	mov    $0x0,%eax
  801524:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801527:	c9                   	leave  
  801528:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801529:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801530:	c1 e2 0c             	shl    $0xc,%edx
  801533:	83 ec 0c             	sub    $0xc,%esp
  801536:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80153c:	51                   	push   %ecx
  80153d:	52                   	push   %edx
  80153e:	50                   	push   %eax
  80153f:	52                   	push   %edx
  801540:	6a 00                	push   $0x0
  801542:	e8 d8 fc ff ff       	call   80121f <sys_page_map>
		if(r < 0)
  801547:	83 c4 20             	add    $0x20,%esp
  80154a:	85 c0                	test   %eax,%eax
  80154c:	79 d1                	jns    80151f <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80154e:	83 ec 04             	sub    $0x4,%esp
  801551:	68 d3 39 80 00       	push   $0x8039d3
  801556:	6a 54                	push   $0x54
  801558:	68 e9 39 80 00       	push   $0x8039e9
  80155d:	e8 33 f0 ff ff       	call   800595 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801562:	89 d3                	mov    %edx,%ebx
  801564:	c1 e3 0c             	shl    $0xc,%ebx
  801567:	83 ec 0c             	sub    $0xc,%esp
  80156a:	68 05 08 00 00       	push   $0x805
  80156f:	53                   	push   %ebx
  801570:	50                   	push   %eax
  801571:	53                   	push   %ebx
  801572:	6a 00                	push   $0x0
  801574:	e8 a6 fc ff ff       	call   80121f <sys_page_map>
		if(r < 0)
  801579:	83 c4 20             	add    $0x20,%esp
  80157c:	85 c0                	test   %eax,%eax
  80157e:	78 2e                	js     8015ae <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801580:	83 ec 0c             	sub    $0xc,%esp
  801583:	68 05 08 00 00       	push   $0x805
  801588:	53                   	push   %ebx
  801589:	6a 00                	push   $0x0
  80158b:	53                   	push   %ebx
  80158c:	6a 00                	push   $0x0
  80158e:	e8 8c fc ff ff       	call   80121f <sys_page_map>
		if(r < 0)
  801593:	83 c4 20             	add    $0x20,%esp
  801596:	85 c0                	test   %eax,%eax
  801598:	79 85                	jns    80151f <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80159a:	83 ec 04             	sub    $0x4,%esp
  80159d:	68 d3 39 80 00       	push   $0x8039d3
  8015a2:	6a 5f                	push   $0x5f
  8015a4:	68 e9 39 80 00       	push   $0x8039e9
  8015a9:	e8 e7 ef ff ff       	call   800595 <_panic>
			panic("sys_page_map() panic\n");
  8015ae:	83 ec 04             	sub    $0x4,%esp
  8015b1:	68 d3 39 80 00       	push   $0x8039d3
  8015b6:	6a 5b                	push   $0x5b
  8015b8:	68 e9 39 80 00       	push   $0x8039e9
  8015bd:	e8 d3 ef ff ff       	call   800595 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8015c2:	c1 e2 0c             	shl    $0xc,%edx
  8015c5:	83 ec 0c             	sub    $0xc,%esp
  8015c8:	68 05 08 00 00       	push   $0x805
  8015cd:	52                   	push   %edx
  8015ce:	50                   	push   %eax
  8015cf:	52                   	push   %edx
  8015d0:	6a 00                	push   $0x0
  8015d2:	e8 48 fc ff ff       	call   80121f <sys_page_map>
		if(r < 0)
  8015d7:	83 c4 20             	add    $0x20,%esp
  8015da:	85 c0                	test   %eax,%eax
  8015dc:	0f 89 3d ff ff ff    	jns    80151f <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8015e2:	83 ec 04             	sub    $0x4,%esp
  8015e5:	68 d3 39 80 00       	push   $0x8039d3
  8015ea:	6a 66                	push   $0x66
  8015ec:	68 e9 39 80 00       	push   $0x8039e9
  8015f1:	e8 9f ef ff ff       	call   800595 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8015f6:	c1 e2 0c             	shl    $0xc,%edx
  8015f9:	83 ec 0c             	sub    $0xc,%esp
  8015fc:	6a 05                	push   $0x5
  8015fe:	52                   	push   %edx
  8015ff:	50                   	push   %eax
  801600:	52                   	push   %edx
  801601:	6a 00                	push   $0x0
  801603:	e8 17 fc ff ff       	call   80121f <sys_page_map>
		if(r < 0)
  801608:	83 c4 20             	add    $0x20,%esp
  80160b:	85 c0                	test   %eax,%eax
  80160d:	0f 89 0c ff ff ff    	jns    80151f <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801613:	83 ec 04             	sub    $0x4,%esp
  801616:	68 d3 39 80 00       	push   $0x8039d3
  80161b:	6a 6d                	push   $0x6d
  80161d:	68 e9 39 80 00       	push   $0x8039e9
  801622:	e8 6e ef ff ff       	call   800595 <_panic>

00801627 <pgfault>:
{
  801627:	55                   	push   %ebp
  801628:	89 e5                	mov    %esp,%ebp
  80162a:	53                   	push   %ebx
  80162b:	83 ec 04             	sub    $0x4,%esp
  80162e:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801631:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801633:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801637:	0f 84 99 00 00 00    	je     8016d6 <pgfault+0xaf>
  80163d:	89 c2                	mov    %eax,%edx
  80163f:	c1 ea 16             	shr    $0x16,%edx
  801642:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801649:	f6 c2 01             	test   $0x1,%dl
  80164c:	0f 84 84 00 00 00    	je     8016d6 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801652:	89 c2                	mov    %eax,%edx
  801654:	c1 ea 0c             	shr    $0xc,%edx
  801657:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80165e:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801664:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  80166a:	75 6a                	jne    8016d6 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  80166c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801671:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801673:	83 ec 04             	sub    $0x4,%esp
  801676:	6a 07                	push   $0x7
  801678:	68 00 f0 7f 00       	push   $0x7ff000
  80167d:	6a 00                	push   $0x0
  80167f:	e8 58 fb ff ff       	call   8011dc <sys_page_alloc>
	if(ret < 0)
  801684:	83 c4 10             	add    $0x10,%esp
  801687:	85 c0                	test   %eax,%eax
  801689:	78 5f                	js     8016ea <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  80168b:	83 ec 04             	sub    $0x4,%esp
  80168e:	68 00 10 00 00       	push   $0x1000
  801693:	53                   	push   %ebx
  801694:	68 00 f0 7f 00       	push   $0x7ff000
  801699:	e8 3c f9 ff ff       	call   800fda <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  80169e:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8016a5:	53                   	push   %ebx
  8016a6:	6a 00                	push   $0x0
  8016a8:	68 00 f0 7f 00       	push   $0x7ff000
  8016ad:	6a 00                	push   $0x0
  8016af:	e8 6b fb ff ff       	call   80121f <sys_page_map>
	if(ret < 0)
  8016b4:	83 c4 20             	add    $0x20,%esp
  8016b7:	85 c0                	test   %eax,%eax
  8016b9:	78 43                	js     8016fe <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8016bb:	83 ec 08             	sub    $0x8,%esp
  8016be:	68 00 f0 7f 00       	push   $0x7ff000
  8016c3:	6a 00                	push   $0x0
  8016c5:	e8 97 fb ff ff       	call   801261 <sys_page_unmap>
	if(ret < 0)
  8016ca:	83 c4 10             	add    $0x10,%esp
  8016cd:	85 c0                	test   %eax,%eax
  8016cf:	78 41                	js     801712 <pgfault+0xeb>
}
  8016d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016d4:	c9                   	leave  
  8016d5:	c3                   	ret    
		panic("panic at pgfault()\n");
  8016d6:	83 ec 04             	sub    $0x4,%esp
  8016d9:	68 f4 39 80 00       	push   $0x8039f4
  8016de:	6a 26                	push   $0x26
  8016e0:	68 e9 39 80 00       	push   $0x8039e9
  8016e5:	e8 ab ee ff ff       	call   800595 <_panic>
		panic("panic in sys_page_alloc()\n");
  8016ea:	83 ec 04             	sub    $0x4,%esp
  8016ed:	68 08 3a 80 00       	push   $0x803a08
  8016f2:	6a 31                	push   $0x31
  8016f4:	68 e9 39 80 00       	push   $0x8039e9
  8016f9:	e8 97 ee ff ff       	call   800595 <_panic>
		panic("panic in sys_page_map()\n");
  8016fe:	83 ec 04             	sub    $0x4,%esp
  801701:	68 23 3a 80 00       	push   $0x803a23
  801706:	6a 36                	push   $0x36
  801708:	68 e9 39 80 00       	push   $0x8039e9
  80170d:	e8 83 ee ff ff       	call   800595 <_panic>
		panic("panic in sys_page_unmap()\n");
  801712:	83 ec 04             	sub    $0x4,%esp
  801715:	68 3c 3a 80 00       	push   $0x803a3c
  80171a:	6a 39                	push   $0x39
  80171c:	68 e9 39 80 00       	push   $0x8039e9
  801721:	e8 6f ee ff ff       	call   800595 <_panic>

00801726 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
  801729:	57                   	push   %edi
  80172a:	56                   	push   %esi
  80172b:	53                   	push   %ebx
  80172c:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  80172f:	68 27 16 80 00       	push   $0x801627
  801734:	e8 d5 18 00 00       	call   80300e <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801739:	b8 07 00 00 00       	mov    $0x7,%eax
  80173e:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801740:	83 c4 10             	add    $0x10,%esp
  801743:	85 c0                	test   %eax,%eax
  801745:	78 2a                	js     801771 <fork+0x4b>
  801747:	89 c6                	mov    %eax,%esi
  801749:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80174b:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801750:	75 4b                	jne    80179d <fork+0x77>
		thisenv = &envs[ENVX(sys_getenvid())];
  801752:	e8 47 fa ff ff       	call   80119e <sys_getenvid>
  801757:	25 ff 03 00 00       	and    $0x3ff,%eax
  80175c:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801762:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801767:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  80176c:	e9 90 00 00 00       	jmp    801801 <fork+0xdb>
		panic("the fork panic! at sys_exofork()\n");
  801771:	83 ec 04             	sub    $0x4,%esp
  801774:	68 58 3a 80 00       	push   $0x803a58
  801779:	68 8c 00 00 00       	push   $0x8c
  80177e:	68 e9 39 80 00       	push   $0x8039e9
  801783:	e8 0d ee ff ff       	call   800595 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801788:	89 f8                	mov    %edi,%eax
  80178a:	e8 42 fd ff ff       	call   8014d1 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80178f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801795:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80179b:	74 26                	je     8017c3 <fork+0x9d>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  80179d:	89 d8                	mov    %ebx,%eax
  80179f:	c1 e8 16             	shr    $0x16,%eax
  8017a2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017a9:	a8 01                	test   $0x1,%al
  8017ab:	74 e2                	je     80178f <fork+0x69>
  8017ad:	89 da                	mov    %ebx,%edx
  8017af:	c1 ea 0c             	shr    $0xc,%edx
  8017b2:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8017b9:	83 e0 05             	and    $0x5,%eax
  8017bc:	83 f8 05             	cmp    $0x5,%eax
  8017bf:	75 ce                	jne    80178f <fork+0x69>
  8017c1:	eb c5                	jmp    801788 <fork+0x62>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8017c3:	83 ec 04             	sub    $0x4,%esp
  8017c6:	6a 07                	push   $0x7
  8017c8:	68 00 f0 bf ee       	push   $0xeebff000
  8017cd:	56                   	push   %esi
  8017ce:	e8 09 fa ff ff       	call   8011dc <sys_page_alloc>
	if(ret < 0)
  8017d3:	83 c4 10             	add    $0x10,%esp
  8017d6:	85 c0                	test   %eax,%eax
  8017d8:	78 31                	js     80180b <fork+0xe5>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8017da:	83 ec 08             	sub    $0x8,%esp
  8017dd:	68 7d 30 80 00       	push   $0x80307d
  8017e2:	56                   	push   %esi
  8017e3:	e8 3f fb ff ff       	call   801327 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8017e8:	83 c4 10             	add    $0x10,%esp
  8017eb:	85 c0                	test   %eax,%eax
  8017ed:	78 33                	js     801822 <fork+0xfc>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8017ef:	83 ec 08             	sub    $0x8,%esp
  8017f2:	6a 02                	push   $0x2
  8017f4:	56                   	push   %esi
  8017f5:	e8 a9 fa ff ff       	call   8012a3 <sys_env_set_status>
	if(ret < 0)
  8017fa:	83 c4 10             	add    $0x10,%esp
  8017fd:	85 c0                	test   %eax,%eax
  8017ff:	78 38                	js     801839 <fork+0x113>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801801:	89 f0                	mov    %esi,%eax
  801803:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801806:	5b                   	pop    %ebx
  801807:	5e                   	pop    %esi
  801808:	5f                   	pop    %edi
  801809:	5d                   	pop    %ebp
  80180a:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80180b:	83 ec 04             	sub    $0x4,%esp
  80180e:	68 08 3a 80 00       	push   $0x803a08
  801813:	68 98 00 00 00       	push   $0x98
  801818:	68 e9 39 80 00       	push   $0x8039e9
  80181d:	e8 73 ed ff ff       	call   800595 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801822:	83 ec 04             	sub    $0x4,%esp
  801825:	68 7c 3a 80 00       	push   $0x803a7c
  80182a:	68 9b 00 00 00       	push   $0x9b
  80182f:	68 e9 39 80 00       	push   $0x8039e9
  801834:	e8 5c ed ff ff       	call   800595 <_panic>
		panic("panic in sys_env_set_status()\n");
  801839:	83 ec 04             	sub    $0x4,%esp
  80183c:	68 a4 3a 80 00       	push   $0x803aa4
  801841:	68 9e 00 00 00       	push   $0x9e
  801846:	68 e9 39 80 00       	push   $0x8039e9
  80184b:	e8 45 ed ff ff       	call   800595 <_panic>

00801850 <sfork>:

// Challenge!
int
sfork(void)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	57                   	push   %edi
  801854:	56                   	push   %esi
  801855:	53                   	push   %ebx
  801856:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801859:	68 27 16 80 00       	push   $0x801627
  80185e:	e8 ab 17 00 00       	call   80300e <set_pgfault_handler>
  801863:	b8 07 00 00 00       	mov    $0x7,%eax
  801868:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80186a:	83 c4 10             	add    $0x10,%esp
  80186d:	85 c0                	test   %eax,%eax
  80186f:	78 2a                	js     80189b <sfork+0x4b>
  801871:	89 c7                	mov    %eax,%edi
  801873:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801875:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80187a:	75 58                	jne    8018d4 <sfork+0x84>
		thisenv = &envs[ENVX(sys_getenvid())];
  80187c:	e8 1d f9 ff ff       	call   80119e <sys_getenvid>
  801881:	25 ff 03 00 00       	and    $0x3ff,%eax
  801886:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80188c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801891:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801896:	e9 d4 00 00 00       	jmp    80196f <sfork+0x11f>
		panic("the fork panic! at sys_exofork()\n");
  80189b:	83 ec 04             	sub    $0x4,%esp
  80189e:	68 58 3a 80 00       	push   $0x803a58
  8018a3:	68 af 00 00 00       	push   $0xaf
  8018a8:	68 e9 39 80 00       	push   $0x8039e9
  8018ad:	e8 e3 ec ff ff       	call   800595 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8018b2:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8018b7:	89 f0                	mov    %esi,%eax
  8018b9:	e8 13 fc ff ff       	call   8014d1 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8018be:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8018c4:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8018ca:	77 65                	ja     801931 <sfork+0xe1>
		if(i == (USTACKTOP - PGSIZE))
  8018cc:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8018d2:	74 de                	je     8018b2 <sfork+0x62>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8018d4:	89 d8                	mov    %ebx,%eax
  8018d6:	c1 e8 16             	shr    $0x16,%eax
  8018d9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8018e0:	a8 01                	test   $0x1,%al
  8018e2:	74 da                	je     8018be <sfork+0x6e>
  8018e4:	89 da                	mov    %ebx,%edx
  8018e6:	c1 ea 0c             	shr    $0xc,%edx
  8018e9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8018f0:	83 e0 05             	and    $0x5,%eax
  8018f3:	83 f8 05             	cmp    $0x5,%eax
  8018f6:	75 c6                	jne    8018be <sfork+0x6e>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8018f8:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8018ff:	c1 e2 0c             	shl    $0xc,%edx
  801902:	83 ec 0c             	sub    $0xc,%esp
  801905:	83 e0 07             	and    $0x7,%eax
  801908:	50                   	push   %eax
  801909:	52                   	push   %edx
  80190a:	56                   	push   %esi
  80190b:	52                   	push   %edx
  80190c:	6a 00                	push   $0x0
  80190e:	e8 0c f9 ff ff       	call   80121f <sys_page_map>
  801913:	83 c4 20             	add    $0x20,%esp
  801916:	85 c0                	test   %eax,%eax
  801918:	74 a4                	je     8018be <sfork+0x6e>
				panic("sys_page_map() panic\n");
  80191a:	83 ec 04             	sub    $0x4,%esp
  80191d:	68 d3 39 80 00       	push   $0x8039d3
  801922:	68 ba 00 00 00       	push   $0xba
  801927:	68 e9 39 80 00       	push   $0x8039e9
  80192c:	e8 64 ec ff ff       	call   800595 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801931:	83 ec 04             	sub    $0x4,%esp
  801934:	6a 07                	push   $0x7
  801936:	68 00 f0 bf ee       	push   $0xeebff000
  80193b:	57                   	push   %edi
  80193c:	e8 9b f8 ff ff       	call   8011dc <sys_page_alloc>
	if(ret < 0)
  801941:	83 c4 10             	add    $0x10,%esp
  801944:	85 c0                	test   %eax,%eax
  801946:	78 31                	js     801979 <sfork+0x129>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801948:	83 ec 08             	sub    $0x8,%esp
  80194b:	68 7d 30 80 00       	push   $0x80307d
  801950:	57                   	push   %edi
  801951:	e8 d1 f9 ff ff       	call   801327 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801956:	83 c4 10             	add    $0x10,%esp
  801959:	85 c0                	test   %eax,%eax
  80195b:	78 33                	js     801990 <sfork+0x140>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80195d:	83 ec 08             	sub    $0x8,%esp
  801960:	6a 02                	push   $0x2
  801962:	57                   	push   %edi
  801963:	e8 3b f9 ff ff       	call   8012a3 <sys_env_set_status>
	if(ret < 0)
  801968:	83 c4 10             	add    $0x10,%esp
  80196b:	85 c0                	test   %eax,%eax
  80196d:	78 38                	js     8019a7 <sfork+0x157>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  80196f:	89 f8                	mov    %edi,%eax
  801971:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801974:	5b                   	pop    %ebx
  801975:	5e                   	pop    %esi
  801976:	5f                   	pop    %edi
  801977:	5d                   	pop    %ebp
  801978:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801979:	83 ec 04             	sub    $0x4,%esp
  80197c:	68 08 3a 80 00       	push   $0x803a08
  801981:	68 c0 00 00 00       	push   $0xc0
  801986:	68 e9 39 80 00       	push   $0x8039e9
  80198b:	e8 05 ec ff ff       	call   800595 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801990:	83 ec 04             	sub    $0x4,%esp
  801993:	68 7c 3a 80 00       	push   $0x803a7c
  801998:	68 c3 00 00 00       	push   $0xc3
  80199d:	68 e9 39 80 00       	push   $0x8039e9
  8019a2:	e8 ee eb ff ff       	call   800595 <_panic>
		panic("panic in sys_env_set_status()\n");
  8019a7:	83 ec 04             	sub    $0x4,%esp
  8019aa:	68 a4 3a 80 00       	push   $0x803aa4
  8019af:	68 c6 00 00 00       	push   $0xc6
  8019b4:	68 e9 39 80 00       	push   $0x8039e9
  8019b9:	e8 d7 eb ff ff       	call   800595 <_panic>

008019be <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8019c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c4:	05 00 00 00 30       	add    $0x30000000,%eax
  8019c9:	c1 e8 0c             	shr    $0xc,%eax
}
  8019cc:	5d                   	pop    %ebp
  8019cd:	c3                   	ret    

008019ce <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8019ce:	55                   	push   %ebp
  8019cf:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8019d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d4:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8019d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019de:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8019e3:	5d                   	pop    %ebp
  8019e4:	c3                   	ret    

008019e5 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
  8019e8:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8019ed:	89 c2                	mov    %eax,%edx
  8019ef:	c1 ea 16             	shr    $0x16,%edx
  8019f2:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8019f9:	f6 c2 01             	test   $0x1,%dl
  8019fc:	74 2d                	je     801a2b <fd_alloc+0x46>
  8019fe:	89 c2                	mov    %eax,%edx
  801a00:	c1 ea 0c             	shr    $0xc,%edx
  801a03:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a0a:	f6 c2 01             	test   $0x1,%dl
  801a0d:	74 1c                	je     801a2b <fd_alloc+0x46>
  801a0f:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801a14:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801a19:	75 d2                	jne    8019ed <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801a24:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801a29:	eb 0a                	jmp    801a35 <fd_alloc+0x50>
			*fd_store = fd;
  801a2b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a2e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801a30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a35:	5d                   	pop    %ebp
  801a36:	c3                   	ret    

00801a37 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
  801a3a:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801a3d:	83 f8 1f             	cmp    $0x1f,%eax
  801a40:	77 30                	ja     801a72 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801a42:	c1 e0 0c             	shl    $0xc,%eax
  801a45:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801a4a:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801a50:	f6 c2 01             	test   $0x1,%dl
  801a53:	74 24                	je     801a79 <fd_lookup+0x42>
  801a55:	89 c2                	mov    %eax,%edx
  801a57:	c1 ea 0c             	shr    $0xc,%edx
  801a5a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a61:	f6 c2 01             	test   $0x1,%dl
  801a64:	74 1a                	je     801a80 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801a66:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a69:	89 02                	mov    %eax,(%edx)
	return 0;
  801a6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a70:	5d                   	pop    %ebp
  801a71:	c3                   	ret    
		return -E_INVAL;
  801a72:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a77:	eb f7                	jmp    801a70 <fd_lookup+0x39>
		return -E_INVAL;
  801a79:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a7e:	eb f0                	jmp    801a70 <fd_lookup+0x39>
  801a80:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a85:	eb e9                	jmp    801a70 <fd_lookup+0x39>

00801a87 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
  801a8a:	83 ec 08             	sub    $0x8,%esp
  801a8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801a90:	ba 00 00 00 00       	mov    $0x0,%edx
  801a95:	b8 20 40 80 00       	mov    $0x804020,%eax
		if (devtab[i]->dev_id == dev_id) {
  801a9a:	39 08                	cmp    %ecx,(%eax)
  801a9c:	74 38                	je     801ad6 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801a9e:	83 c2 01             	add    $0x1,%edx
  801aa1:	8b 04 95 40 3b 80 00 	mov    0x803b40(,%edx,4),%eax
  801aa8:	85 c0                	test   %eax,%eax
  801aaa:	75 ee                	jne    801a9a <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801aac:	a1 08 50 80 00       	mov    0x805008,%eax
  801ab1:	8b 40 48             	mov    0x48(%eax),%eax
  801ab4:	83 ec 04             	sub    $0x4,%esp
  801ab7:	51                   	push   %ecx
  801ab8:	50                   	push   %eax
  801ab9:	68 c4 3a 80 00       	push   $0x803ac4
  801abe:	e8 c8 eb ff ff       	call   80068b <cprintf>
	*dev = 0;
  801ac3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801acc:	83 c4 10             	add    $0x10,%esp
  801acf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    
			*dev = devtab[i];
  801ad6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ad9:	89 01                	mov    %eax,(%ecx)
			return 0;
  801adb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae0:	eb f2                	jmp    801ad4 <dev_lookup+0x4d>

00801ae2 <fd_close>:
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
  801ae5:	57                   	push   %edi
  801ae6:	56                   	push   %esi
  801ae7:	53                   	push   %ebx
  801ae8:	83 ec 24             	sub    $0x24,%esp
  801aeb:	8b 75 08             	mov    0x8(%ebp),%esi
  801aee:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801af1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801af4:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801af5:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801afb:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801afe:	50                   	push   %eax
  801aff:	e8 33 ff ff ff       	call   801a37 <fd_lookup>
  801b04:	89 c3                	mov    %eax,%ebx
  801b06:	83 c4 10             	add    $0x10,%esp
  801b09:	85 c0                	test   %eax,%eax
  801b0b:	78 05                	js     801b12 <fd_close+0x30>
	    || fd != fd2)
  801b0d:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801b10:	74 16                	je     801b28 <fd_close+0x46>
		return (must_exist ? r : 0);
  801b12:	89 f8                	mov    %edi,%eax
  801b14:	84 c0                	test   %al,%al
  801b16:	b8 00 00 00 00       	mov    $0x0,%eax
  801b1b:	0f 44 d8             	cmove  %eax,%ebx
}
  801b1e:	89 d8                	mov    %ebx,%eax
  801b20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b23:	5b                   	pop    %ebx
  801b24:	5e                   	pop    %esi
  801b25:	5f                   	pop    %edi
  801b26:	5d                   	pop    %ebp
  801b27:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801b28:	83 ec 08             	sub    $0x8,%esp
  801b2b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801b2e:	50                   	push   %eax
  801b2f:	ff 36                	pushl  (%esi)
  801b31:	e8 51 ff ff ff       	call   801a87 <dev_lookup>
  801b36:	89 c3                	mov    %eax,%ebx
  801b38:	83 c4 10             	add    $0x10,%esp
  801b3b:	85 c0                	test   %eax,%eax
  801b3d:	78 1a                	js     801b59 <fd_close+0x77>
		if (dev->dev_close)
  801b3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b42:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801b45:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801b4a:	85 c0                	test   %eax,%eax
  801b4c:	74 0b                	je     801b59 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801b4e:	83 ec 0c             	sub    $0xc,%esp
  801b51:	56                   	push   %esi
  801b52:	ff d0                	call   *%eax
  801b54:	89 c3                	mov    %eax,%ebx
  801b56:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801b59:	83 ec 08             	sub    $0x8,%esp
  801b5c:	56                   	push   %esi
  801b5d:	6a 00                	push   $0x0
  801b5f:	e8 fd f6 ff ff       	call   801261 <sys_page_unmap>
	return r;
  801b64:	83 c4 10             	add    $0x10,%esp
  801b67:	eb b5                	jmp    801b1e <fd_close+0x3c>

00801b69 <close>:

int
close(int fdnum)
{
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
  801b6c:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b6f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b72:	50                   	push   %eax
  801b73:	ff 75 08             	pushl  0x8(%ebp)
  801b76:	e8 bc fe ff ff       	call   801a37 <fd_lookup>
  801b7b:	83 c4 10             	add    $0x10,%esp
  801b7e:	85 c0                	test   %eax,%eax
  801b80:	79 02                	jns    801b84 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801b82:	c9                   	leave  
  801b83:	c3                   	ret    
		return fd_close(fd, 1);
  801b84:	83 ec 08             	sub    $0x8,%esp
  801b87:	6a 01                	push   $0x1
  801b89:	ff 75 f4             	pushl  -0xc(%ebp)
  801b8c:	e8 51 ff ff ff       	call   801ae2 <fd_close>
  801b91:	83 c4 10             	add    $0x10,%esp
  801b94:	eb ec                	jmp    801b82 <close+0x19>

00801b96 <close_all>:

void
close_all(void)
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
  801b99:	53                   	push   %ebx
  801b9a:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801b9d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801ba2:	83 ec 0c             	sub    $0xc,%esp
  801ba5:	53                   	push   %ebx
  801ba6:	e8 be ff ff ff       	call   801b69 <close>
	for (i = 0; i < MAXFD; i++)
  801bab:	83 c3 01             	add    $0x1,%ebx
  801bae:	83 c4 10             	add    $0x10,%esp
  801bb1:	83 fb 20             	cmp    $0x20,%ebx
  801bb4:	75 ec                	jne    801ba2 <close_all+0xc>
}
  801bb6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
  801bbe:	57                   	push   %edi
  801bbf:	56                   	push   %esi
  801bc0:	53                   	push   %ebx
  801bc1:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801bc4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801bc7:	50                   	push   %eax
  801bc8:	ff 75 08             	pushl  0x8(%ebp)
  801bcb:	e8 67 fe ff ff       	call   801a37 <fd_lookup>
  801bd0:	89 c3                	mov    %eax,%ebx
  801bd2:	83 c4 10             	add    $0x10,%esp
  801bd5:	85 c0                	test   %eax,%eax
  801bd7:	0f 88 81 00 00 00    	js     801c5e <dup+0xa3>
		return r;
	close(newfdnum);
  801bdd:	83 ec 0c             	sub    $0xc,%esp
  801be0:	ff 75 0c             	pushl  0xc(%ebp)
  801be3:	e8 81 ff ff ff       	call   801b69 <close>

	newfd = INDEX2FD(newfdnum);
  801be8:	8b 75 0c             	mov    0xc(%ebp),%esi
  801beb:	c1 e6 0c             	shl    $0xc,%esi
  801bee:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801bf4:	83 c4 04             	add    $0x4,%esp
  801bf7:	ff 75 e4             	pushl  -0x1c(%ebp)
  801bfa:	e8 cf fd ff ff       	call   8019ce <fd2data>
  801bff:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801c01:	89 34 24             	mov    %esi,(%esp)
  801c04:	e8 c5 fd ff ff       	call   8019ce <fd2data>
  801c09:	83 c4 10             	add    $0x10,%esp
  801c0c:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801c0e:	89 d8                	mov    %ebx,%eax
  801c10:	c1 e8 16             	shr    $0x16,%eax
  801c13:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801c1a:	a8 01                	test   $0x1,%al
  801c1c:	74 11                	je     801c2f <dup+0x74>
  801c1e:	89 d8                	mov    %ebx,%eax
  801c20:	c1 e8 0c             	shr    $0xc,%eax
  801c23:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801c2a:	f6 c2 01             	test   $0x1,%dl
  801c2d:	75 39                	jne    801c68 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801c2f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c32:	89 d0                	mov    %edx,%eax
  801c34:	c1 e8 0c             	shr    $0xc,%eax
  801c37:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801c3e:	83 ec 0c             	sub    $0xc,%esp
  801c41:	25 07 0e 00 00       	and    $0xe07,%eax
  801c46:	50                   	push   %eax
  801c47:	56                   	push   %esi
  801c48:	6a 00                	push   $0x0
  801c4a:	52                   	push   %edx
  801c4b:	6a 00                	push   $0x0
  801c4d:	e8 cd f5 ff ff       	call   80121f <sys_page_map>
  801c52:	89 c3                	mov    %eax,%ebx
  801c54:	83 c4 20             	add    $0x20,%esp
  801c57:	85 c0                	test   %eax,%eax
  801c59:	78 31                	js     801c8c <dup+0xd1>
		goto err;

	return newfdnum;
  801c5b:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801c5e:	89 d8                	mov    %ebx,%eax
  801c60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c63:	5b                   	pop    %ebx
  801c64:	5e                   	pop    %esi
  801c65:	5f                   	pop    %edi
  801c66:	5d                   	pop    %ebp
  801c67:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801c68:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801c6f:	83 ec 0c             	sub    $0xc,%esp
  801c72:	25 07 0e 00 00       	and    $0xe07,%eax
  801c77:	50                   	push   %eax
  801c78:	57                   	push   %edi
  801c79:	6a 00                	push   $0x0
  801c7b:	53                   	push   %ebx
  801c7c:	6a 00                	push   $0x0
  801c7e:	e8 9c f5 ff ff       	call   80121f <sys_page_map>
  801c83:	89 c3                	mov    %eax,%ebx
  801c85:	83 c4 20             	add    $0x20,%esp
  801c88:	85 c0                	test   %eax,%eax
  801c8a:	79 a3                	jns    801c2f <dup+0x74>
	sys_page_unmap(0, newfd);
  801c8c:	83 ec 08             	sub    $0x8,%esp
  801c8f:	56                   	push   %esi
  801c90:	6a 00                	push   $0x0
  801c92:	e8 ca f5 ff ff       	call   801261 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801c97:	83 c4 08             	add    $0x8,%esp
  801c9a:	57                   	push   %edi
  801c9b:	6a 00                	push   $0x0
  801c9d:	e8 bf f5 ff ff       	call   801261 <sys_page_unmap>
	return r;
  801ca2:	83 c4 10             	add    $0x10,%esp
  801ca5:	eb b7                	jmp    801c5e <dup+0xa3>

00801ca7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
  801caa:	53                   	push   %ebx
  801cab:	83 ec 1c             	sub    $0x1c,%esp
  801cae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801cb1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cb4:	50                   	push   %eax
  801cb5:	53                   	push   %ebx
  801cb6:	e8 7c fd ff ff       	call   801a37 <fd_lookup>
  801cbb:	83 c4 10             	add    $0x10,%esp
  801cbe:	85 c0                	test   %eax,%eax
  801cc0:	78 3f                	js     801d01 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801cc2:	83 ec 08             	sub    $0x8,%esp
  801cc5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cc8:	50                   	push   %eax
  801cc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ccc:	ff 30                	pushl  (%eax)
  801cce:	e8 b4 fd ff ff       	call   801a87 <dev_lookup>
  801cd3:	83 c4 10             	add    $0x10,%esp
  801cd6:	85 c0                	test   %eax,%eax
  801cd8:	78 27                	js     801d01 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801cda:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cdd:	8b 42 08             	mov    0x8(%edx),%eax
  801ce0:	83 e0 03             	and    $0x3,%eax
  801ce3:	83 f8 01             	cmp    $0x1,%eax
  801ce6:	74 1e                	je     801d06 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ceb:	8b 40 08             	mov    0x8(%eax),%eax
  801cee:	85 c0                	test   %eax,%eax
  801cf0:	74 35                	je     801d27 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801cf2:	83 ec 04             	sub    $0x4,%esp
  801cf5:	ff 75 10             	pushl  0x10(%ebp)
  801cf8:	ff 75 0c             	pushl  0xc(%ebp)
  801cfb:	52                   	push   %edx
  801cfc:	ff d0                	call   *%eax
  801cfe:	83 c4 10             	add    $0x10,%esp
}
  801d01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d04:	c9                   	leave  
  801d05:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801d06:	a1 08 50 80 00       	mov    0x805008,%eax
  801d0b:	8b 40 48             	mov    0x48(%eax),%eax
  801d0e:	83 ec 04             	sub    $0x4,%esp
  801d11:	53                   	push   %ebx
  801d12:	50                   	push   %eax
  801d13:	68 05 3b 80 00       	push   $0x803b05
  801d18:	e8 6e e9 ff ff       	call   80068b <cprintf>
		return -E_INVAL;
  801d1d:	83 c4 10             	add    $0x10,%esp
  801d20:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d25:	eb da                	jmp    801d01 <read+0x5a>
		return -E_NOT_SUPP;
  801d27:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d2c:	eb d3                	jmp    801d01 <read+0x5a>

00801d2e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
  801d31:	57                   	push   %edi
  801d32:	56                   	push   %esi
  801d33:	53                   	push   %ebx
  801d34:	83 ec 0c             	sub    $0xc,%esp
  801d37:	8b 7d 08             	mov    0x8(%ebp),%edi
  801d3a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801d3d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d42:	39 f3                	cmp    %esi,%ebx
  801d44:	73 23                	jae    801d69 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801d46:	83 ec 04             	sub    $0x4,%esp
  801d49:	89 f0                	mov    %esi,%eax
  801d4b:	29 d8                	sub    %ebx,%eax
  801d4d:	50                   	push   %eax
  801d4e:	89 d8                	mov    %ebx,%eax
  801d50:	03 45 0c             	add    0xc(%ebp),%eax
  801d53:	50                   	push   %eax
  801d54:	57                   	push   %edi
  801d55:	e8 4d ff ff ff       	call   801ca7 <read>
		if (m < 0)
  801d5a:	83 c4 10             	add    $0x10,%esp
  801d5d:	85 c0                	test   %eax,%eax
  801d5f:	78 06                	js     801d67 <readn+0x39>
			return m;
		if (m == 0)
  801d61:	74 06                	je     801d69 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801d63:	01 c3                	add    %eax,%ebx
  801d65:	eb db                	jmp    801d42 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801d67:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801d69:	89 d8                	mov    %ebx,%eax
  801d6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d6e:	5b                   	pop    %ebx
  801d6f:	5e                   	pop    %esi
  801d70:	5f                   	pop    %edi
  801d71:	5d                   	pop    %ebp
  801d72:	c3                   	ret    

00801d73 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
  801d76:	53                   	push   %ebx
  801d77:	83 ec 1c             	sub    $0x1c,%esp
  801d7a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d7d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d80:	50                   	push   %eax
  801d81:	53                   	push   %ebx
  801d82:	e8 b0 fc ff ff       	call   801a37 <fd_lookup>
  801d87:	83 c4 10             	add    $0x10,%esp
  801d8a:	85 c0                	test   %eax,%eax
  801d8c:	78 3a                	js     801dc8 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d8e:	83 ec 08             	sub    $0x8,%esp
  801d91:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d94:	50                   	push   %eax
  801d95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d98:	ff 30                	pushl  (%eax)
  801d9a:	e8 e8 fc ff ff       	call   801a87 <dev_lookup>
  801d9f:	83 c4 10             	add    $0x10,%esp
  801da2:	85 c0                	test   %eax,%eax
  801da4:	78 22                	js     801dc8 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801da6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801dad:	74 1e                	je     801dcd <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801daf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801db2:	8b 52 0c             	mov    0xc(%edx),%edx
  801db5:	85 d2                	test   %edx,%edx
  801db7:	74 35                	je     801dee <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801db9:	83 ec 04             	sub    $0x4,%esp
  801dbc:	ff 75 10             	pushl  0x10(%ebp)
  801dbf:	ff 75 0c             	pushl  0xc(%ebp)
  801dc2:	50                   	push   %eax
  801dc3:	ff d2                	call   *%edx
  801dc5:	83 c4 10             	add    $0x10,%esp
}
  801dc8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dcb:	c9                   	leave  
  801dcc:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801dcd:	a1 08 50 80 00       	mov    0x805008,%eax
  801dd2:	8b 40 48             	mov    0x48(%eax),%eax
  801dd5:	83 ec 04             	sub    $0x4,%esp
  801dd8:	53                   	push   %ebx
  801dd9:	50                   	push   %eax
  801dda:	68 21 3b 80 00       	push   $0x803b21
  801ddf:	e8 a7 e8 ff ff       	call   80068b <cprintf>
		return -E_INVAL;
  801de4:	83 c4 10             	add    $0x10,%esp
  801de7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801dec:	eb da                	jmp    801dc8 <write+0x55>
		return -E_NOT_SUPP;
  801dee:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801df3:	eb d3                	jmp    801dc8 <write+0x55>

00801df5 <seek>:

int
seek(int fdnum, off_t offset)
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
  801df8:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801dfb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dfe:	50                   	push   %eax
  801dff:	ff 75 08             	pushl  0x8(%ebp)
  801e02:	e8 30 fc ff ff       	call   801a37 <fd_lookup>
  801e07:	83 c4 10             	add    $0x10,%esp
  801e0a:	85 c0                	test   %eax,%eax
  801e0c:	78 0e                	js     801e1c <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801e0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e14:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801e17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e1c:	c9                   	leave  
  801e1d:	c3                   	ret    

00801e1e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
  801e21:	53                   	push   %ebx
  801e22:	83 ec 1c             	sub    $0x1c,%esp
  801e25:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801e28:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e2b:	50                   	push   %eax
  801e2c:	53                   	push   %ebx
  801e2d:	e8 05 fc ff ff       	call   801a37 <fd_lookup>
  801e32:	83 c4 10             	add    $0x10,%esp
  801e35:	85 c0                	test   %eax,%eax
  801e37:	78 37                	js     801e70 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801e39:	83 ec 08             	sub    $0x8,%esp
  801e3c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e3f:	50                   	push   %eax
  801e40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e43:	ff 30                	pushl  (%eax)
  801e45:	e8 3d fc ff ff       	call   801a87 <dev_lookup>
  801e4a:	83 c4 10             	add    $0x10,%esp
  801e4d:	85 c0                	test   %eax,%eax
  801e4f:	78 1f                	js     801e70 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801e51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e54:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801e58:	74 1b                	je     801e75 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801e5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e5d:	8b 52 18             	mov    0x18(%edx),%edx
  801e60:	85 d2                	test   %edx,%edx
  801e62:	74 32                	je     801e96 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801e64:	83 ec 08             	sub    $0x8,%esp
  801e67:	ff 75 0c             	pushl  0xc(%ebp)
  801e6a:	50                   	push   %eax
  801e6b:	ff d2                	call   *%edx
  801e6d:	83 c4 10             	add    $0x10,%esp
}
  801e70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e73:	c9                   	leave  
  801e74:	c3                   	ret    
			thisenv->env_id, fdnum);
  801e75:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801e7a:	8b 40 48             	mov    0x48(%eax),%eax
  801e7d:	83 ec 04             	sub    $0x4,%esp
  801e80:	53                   	push   %ebx
  801e81:	50                   	push   %eax
  801e82:	68 e4 3a 80 00       	push   $0x803ae4
  801e87:	e8 ff e7 ff ff       	call   80068b <cprintf>
		return -E_INVAL;
  801e8c:	83 c4 10             	add    $0x10,%esp
  801e8f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e94:	eb da                	jmp    801e70 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801e96:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e9b:	eb d3                	jmp    801e70 <ftruncate+0x52>

00801e9d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801e9d:	55                   	push   %ebp
  801e9e:	89 e5                	mov    %esp,%ebp
  801ea0:	53                   	push   %ebx
  801ea1:	83 ec 1c             	sub    $0x1c,%esp
  801ea4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ea7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801eaa:	50                   	push   %eax
  801eab:	ff 75 08             	pushl  0x8(%ebp)
  801eae:	e8 84 fb ff ff       	call   801a37 <fd_lookup>
  801eb3:	83 c4 10             	add    $0x10,%esp
  801eb6:	85 c0                	test   %eax,%eax
  801eb8:	78 4b                	js     801f05 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801eba:	83 ec 08             	sub    $0x8,%esp
  801ebd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ec0:	50                   	push   %eax
  801ec1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec4:	ff 30                	pushl  (%eax)
  801ec6:	e8 bc fb ff ff       	call   801a87 <dev_lookup>
  801ecb:	83 c4 10             	add    $0x10,%esp
  801ece:	85 c0                	test   %eax,%eax
  801ed0:	78 33                	js     801f05 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed5:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801ed9:	74 2f                	je     801f0a <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801edb:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801ede:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801ee5:	00 00 00 
	stat->st_isdir = 0;
  801ee8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801eef:	00 00 00 
	stat->st_dev = dev;
  801ef2:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801ef8:	83 ec 08             	sub    $0x8,%esp
  801efb:	53                   	push   %ebx
  801efc:	ff 75 f0             	pushl  -0x10(%ebp)
  801eff:	ff 50 14             	call   *0x14(%eax)
  801f02:	83 c4 10             	add    $0x10,%esp
}
  801f05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f08:	c9                   	leave  
  801f09:	c3                   	ret    
		return -E_NOT_SUPP;
  801f0a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f0f:	eb f4                	jmp    801f05 <fstat+0x68>

00801f11 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
  801f14:	56                   	push   %esi
  801f15:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801f16:	83 ec 08             	sub    $0x8,%esp
  801f19:	6a 00                	push   $0x0
  801f1b:	ff 75 08             	pushl  0x8(%ebp)
  801f1e:	e8 22 02 00 00       	call   802145 <open>
  801f23:	89 c3                	mov    %eax,%ebx
  801f25:	83 c4 10             	add    $0x10,%esp
  801f28:	85 c0                	test   %eax,%eax
  801f2a:	78 1b                	js     801f47 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801f2c:	83 ec 08             	sub    $0x8,%esp
  801f2f:	ff 75 0c             	pushl  0xc(%ebp)
  801f32:	50                   	push   %eax
  801f33:	e8 65 ff ff ff       	call   801e9d <fstat>
  801f38:	89 c6                	mov    %eax,%esi
	close(fd);
  801f3a:	89 1c 24             	mov    %ebx,(%esp)
  801f3d:	e8 27 fc ff ff       	call   801b69 <close>
	return r;
  801f42:	83 c4 10             	add    $0x10,%esp
  801f45:	89 f3                	mov    %esi,%ebx
}
  801f47:	89 d8                	mov    %ebx,%eax
  801f49:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f4c:	5b                   	pop    %ebx
  801f4d:	5e                   	pop    %esi
  801f4e:	5d                   	pop    %ebp
  801f4f:	c3                   	ret    

00801f50 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801f50:	55                   	push   %ebp
  801f51:	89 e5                	mov    %esp,%ebp
  801f53:	56                   	push   %esi
  801f54:	53                   	push   %ebx
  801f55:	89 c6                	mov    %eax,%esi
  801f57:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801f59:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801f60:	74 27                	je     801f89 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801f62:	6a 07                	push   $0x7
  801f64:	68 00 60 80 00       	push   $0x806000
  801f69:	56                   	push   %esi
  801f6a:	ff 35 00 50 80 00    	pushl  0x805000
  801f70:	e8 97 11 00 00       	call   80310c <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801f75:	83 c4 0c             	add    $0xc,%esp
  801f78:	6a 00                	push   $0x0
  801f7a:	53                   	push   %ebx
  801f7b:	6a 00                	push   $0x0
  801f7d:	e8 21 11 00 00       	call   8030a3 <ipc_recv>
}
  801f82:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f85:	5b                   	pop    %ebx
  801f86:	5e                   	pop    %esi
  801f87:	5d                   	pop    %ebp
  801f88:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801f89:	83 ec 0c             	sub    $0xc,%esp
  801f8c:	6a 01                	push   $0x1
  801f8e:	e8 d1 11 00 00       	call   803164 <ipc_find_env>
  801f93:	a3 00 50 80 00       	mov    %eax,0x805000
  801f98:	83 c4 10             	add    $0x10,%esp
  801f9b:	eb c5                	jmp    801f62 <fsipc+0x12>

00801f9d <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801f9d:	55                   	push   %ebp
  801f9e:	89 e5                	mov    %esp,%ebp
  801fa0:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa6:	8b 40 0c             	mov    0xc(%eax),%eax
  801fa9:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb1:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801fb6:	ba 00 00 00 00       	mov    $0x0,%edx
  801fbb:	b8 02 00 00 00       	mov    $0x2,%eax
  801fc0:	e8 8b ff ff ff       	call   801f50 <fsipc>
}
  801fc5:	c9                   	leave  
  801fc6:	c3                   	ret    

00801fc7 <devfile_flush>:
{
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
  801fca:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd0:	8b 40 0c             	mov    0xc(%eax),%eax
  801fd3:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801fd8:	ba 00 00 00 00       	mov    $0x0,%edx
  801fdd:	b8 06 00 00 00       	mov    $0x6,%eax
  801fe2:	e8 69 ff ff ff       	call   801f50 <fsipc>
}
  801fe7:	c9                   	leave  
  801fe8:	c3                   	ret    

00801fe9 <devfile_stat>:
{
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
  801fec:	53                   	push   %ebx
  801fed:	83 ec 04             	sub    $0x4,%esp
  801ff0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff6:	8b 40 0c             	mov    0xc(%eax),%eax
  801ff9:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801ffe:	ba 00 00 00 00       	mov    $0x0,%edx
  802003:	b8 05 00 00 00       	mov    $0x5,%eax
  802008:	e8 43 ff ff ff       	call   801f50 <fsipc>
  80200d:	85 c0                	test   %eax,%eax
  80200f:	78 2c                	js     80203d <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802011:	83 ec 08             	sub    $0x8,%esp
  802014:	68 00 60 80 00       	push   $0x806000
  802019:	53                   	push   %ebx
  80201a:	e8 cb ed ff ff       	call   800dea <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80201f:	a1 80 60 80 00       	mov    0x806080,%eax
  802024:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80202a:	a1 84 60 80 00       	mov    0x806084,%eax
  80202f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  802035:	83 c4 10             	add    $0x10,%esp
  802038:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80203d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802040:	c9                   	leave  
  802041:	c3                   	ret    

00802042 <devfile_write>:
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
  802045:	53                   	push   %ebx
  802046:	83 ec 08             	sub    $0x8,%esp
  802049:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80204c:	8b 45 08             	mov    0x8(%ebp),%eax
  80204f:	8b 40 0c             	mov    0xc(%eax),%eax
  802052:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  802057:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80205d:	53                   	push   %ebx
  80205e:	ff 75 0c             	pushl  0xc(%ebp)
  802061:	68 08 60 80 00       	push   $0x806008
  802066:	e8 6f ef ff ff       	call   800fda <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80206b:	ba 00 00 00 00       	mov    $0x0,%edx
  802070:	b8 04 00 00 00       	mov    $0x4,%eax
  802075:	e8 d6 fe ff ff       	call   801f50 <fsipc>
  80207a:	83 c4 10             	add    $0x10,%esp
  80207d:	85 c0                	test   %eax,%eax
  80207f:	78 0b                	js     80208c <devfile_write+0x4a>
	assert(r <= n);
  802081:	39 d8                	cmp    %ebx,%eax
  802083:	77 0c                	ja     802091 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  802085:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80208a:	7f 1e                	jg     8020aa <devfile_write+0x68>
}
  80208c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80208f:	c9                   	leave  
  802090:	c3                   	ret    
	assert(r <= n);
  802091:	68 54 3b 80 00       	push   $0x803b54
  802096:	68 5b 3b 80 00       	push   $0x803b5b
  80209b:	68 98 00 00 00       	push   $0x98
  8020a0:	68 70 3b 80 00       	push   $0x803b70
  8020a5:	e8 eb e4 ff ff       	call   800595 <_panic>
	assert(r <= PGSIZE);
  8020aa:	68 7b 3b 80 00       	push   $0x803b7b
  8020af:	68 5b 3b 80 00       	push   $0x803b5b
  8020b4:	68 99 00 00 00       	push   $0x99
  8020b9:	68 70 3b 80 00       	push   $0x803b70
  8020be:	e8 d2 e4 ff ff       	call   800595 <_panic>

008020c3 <devfile_read>:
{
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
  8020c6:	56                   	push   %esi
  8020c7:	53                   	push   %ebx
  8020c8:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8020cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8020d1:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  8020d6:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8020dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8020e1:	b8 03 00 00 00       	mov    $0x3,%eax
  8020e6:	e8 65 fe ff ff       	call   801f50 <fsipc>
  8020eb:	89 c3                	mov    %eax,%ebx
  8020ed:	85 c0                	test   %eax,%eax
  8020ef:	78 1f                	js     802110 <devfile_read+0x4d>
	assert(r <= n);
  8020f1:	39 f0                	cmp    %esi,%eax
  8020f3:	77 24                	ja     802119 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8020f5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8020fa:	7f 33                	jg     80212f <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8020fc:	83 ec 04             	sub    $0x4,%esp
  8020ff:	50                   	push   %eax
  802100:	68 00 60 80 00       	push   $0x806000
  802105:	ff 75 0c             	pushl  0xc(%ebp)
  802108:	e8 6b ee ff ff       	call   800f78 <memmove>
	return r;
  80210d:	83 c4 10             	add    $0x10,%esp
}
  802110:	89 d8                	mov    %ebx,%eax
  802112:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802115:	5b                   	pop    %ebx
  802116:	5e                   	pop    %esi
  802117:	5d                   	pop    %ebp
  802118:	c3                   	ret    
	assert(r <= n);
  802119:	68 54 3b 80 00       	push   $0x803b54
  80211e:	68 5b 3b 80 00       	push   $0x803b5b
  802123:	6a 7c                	push   $0x7c
  802125:	68 70 3b 80 00       	push   $0x803b70
  80212a:	e8 66 e4 ff ff       	call   800595 <_panic>
	assert(r <= PGSIZE);
  80212f:	68 7b 3b 80 00       	push   $0x803b7b
  802134:	68 5b 3b 80 00       	push   $0x803b5b
  802139:	6a 7d                	push   $0x7d
  80213b:	68 70 3b 80 00       	push   $0x803b70
  802140:	e8 50 e4 ff ff       	call   800595 <_panic>

00802145 <open>:
{
  802145:	55                   	push   %ebp
  802146:	89 e5                	mov    %esp,%ebp
  802148:	56                   	push   %esi
  802149:	53                   	push   %ebx
  80214a:	83 ec 1c             	sub    $0x1c,%esp
  80214d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  802150:	56                   	push   %esi
  802151:	e8 5b ec ff ff       	call   800db1 <strlen>
  802156:	83 c4 10             	add    $0x10,%esp
  802159:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80215e:	7f 6c                	jg     8021cc <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  802160:	83 ec 0c             	sub    $0xc,%esp
  802163:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802166:	50                   	push   %eax
  802167:	e8 79 f8 ff ff       	call   8019e5 <fd_alloc>
  80216c:	89 c3                	mov    %eax,%ebx
  80216e:	83 c4 10             	add    $0x10,%esp
  802171:	85 c0                	test   %eax,%eax
  802173:	78 3c                	js     8021b1 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  802175:	83 ec 08             	sub    $0x8,%esp
  802178:	56                   	push   %esi
  802179:	68 00 60 80 00       	push   $0x806000
  80217e:	e8 67 ec ff ff       	call   800dea <strcpy>
	fsipcbuf.open.req_omode = mode;
  802183:	8b 45 0c             	mov    0xc(%ebp),%eax
  802186:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80218b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80218e:	b8 01 00 00 00       	mov    $0x1,%eax
  802193:	e8 b8 fd ff ff       	call   801f50 <fsipc>
  802198:	89 c3                	mov    %eax,%ebx
  80219a:	83 c4 10             	add    $0x10,%esp
  80219d:	85 c0                	test   %eax,%eax
  80219f:	78 19                	js     8021ba <open+0x75>
	return fd2num(fd);
  8021a1:	83 ec 0c             	sub    $0xc,%esp
  8021a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8021a7:	e8 12 f8 ff ff       	call   8019be <fd2num>
  8021ac:	89 c3                	mov    %eax,%ebx
  8021ae:	83 c4 10             	add    $0x10,%esp
}
  8021b1:	89 d8                	mov    %ebx,%eax
  8021b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021b6:	5b                   	pop    %ebx
  8021b7:	5e                   	pop    %esi
  8021b8:	5d                   	pop    %ebp
  8021b9:	c3                   	ret    
		fd_close(fd, 0);
  8021ba:	83 ec 08             	sub    $0x8,%esp
  8021bd:	6a 00                	push   $0x0
  8021bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8021c2:	e8 1b f9 ff ff       	call   801ae2 <fd_close>
		return r;
  8021c7:	83 c4 10             	add    $0x10,%esp
  8021ca:	eb e5                	jmp    8021b1 <open+0x6c>
		return -E_BAD_PATH;
  8021cc:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8021d1:	eb de                	jmp    8021b1 <open+0x6c>

008021d3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8021d3:	55                   	push   %ebp
  8021d4:	89 e5                	mov    %esp,%ebp
  8021d6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8021d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8021de:	b8 08 00 00 00       	mov    $0x8,%eax
  8021e3:	e8 68 fd ff ff       	call   801f50 <fsipc>
}
  8021e8:	c9                   	leave  
  8021e9:	c3                   	ret    

008021ea <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8021ea:	55                   	push   %ebp
  8021eb:	89 e5                	mov    %esp,%ebp
  8021ed:	57                   	push   %edi
  8021ee:	56                   	push   %esi
  8021ef:	53                   	push   %ebx
  8021f0:	81 ec 94 02 00 00    	sub    $0x294,%esp
	cprintf("in %s\n", __FUNCTION__);
  8021f6:	68 60 3c 80 00       	push   $0x803c60
  8021fb:	68 de 35 80 00       	push   $0x8035de
  802200:	e8 86 e4 ff ff       	call   80068b <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802205:	83 c4 08             	add    $0x8,%esp
  802208:	6a 00                	push   $0x0
  80220a:	ff 75 08             	pushl  0x8(%ebp)
  80220d:	e8 33 ff ff ff       	call   802145 <open>
  802212:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802218:	83 c4 10             	add    $0x10,%esp
  80221b:	85 c0                	test   %eax,%eax
  80221d:	0f 88 0b 05 00 00    	js     80272e <spawn+0x544>
  802223:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802225:	83 ec 04             	sub    $0x4,%esp
  802228:	68 00 02 00 00       	push   $0x200
  80222d:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  802233:	50                   	push   %eax
  802234:	51                   	push   %ecx
  802235:	e8 f4 fa ff ff       	call   801d2e <readn>
  80223a:	83 c4 10             	add    $0x10,%esp
  80223d:	3d 00 02 00 00       	cmp    $0x200,%eax
  802242:	75 75                	jne    8022b9 <spawn+0xcf>
	    || elf->e_magic != ELF_MAGIC) {
  802244:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  80224b:	45 4c 46 
  80224e:	75 69                	jne    8022b9 <spawn+0xcf>
  802250:	b8 07 00 00 00       	mov    $0x7,%eax
  802255:	cd 30                	int    $0x30
  802257:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  80225d:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802263:	85 c0                	test   %eax,%eax
  802265:	0f 88 b7 04 00 00    	js     802722 <spawn+0x538>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80226b:	25 ff 03 00 00       	and    $0x3ff,%eax
  802270:	69 f0 84 00 00 00    	imul   $0x84,%eax,%esi
  802276:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  80227c:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  802282:	b9 11 00 00 00       	mov    $0x11,%ecx
  802287:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  802289:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  80228f:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
	cprintf("in %s\n", __FUNCTION__);
  802295:	83 ec 08             	sub    $0x8,%esp
  802298:	68 54 3c 80 00       	push   $0x803c54
  80229d:	68 de 35 80 00       	push   $0x8035de
  8022a2:	e8 e4 e3 ff ff       	call   80068b <cprintf>
  8022a7:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8022aa:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  8022af:	be 00 00 00 00       	mov    $0x0,%esi
  8022b4:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8022b7:	eb 4b                	jmp    802304 <spawn+0x11a>
		close(fd);
  8022b9:	83 ec 0c             	sub    $0xc,%esp
  8022bc:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8022c2:	e8 a2 f8 ff ff       	call   801b69 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8022c7:	83 c4 0c             	add    $0xc,%esp
  8022ca:	68 7f 45 4c 46       	push   $0x464c457f
  8022cf:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  8022d5:	68 87 3b 80 00       	push   $0x803b87
  8022da:	e8 ac e3 ff ff       	call   80068b <cprintf>
		return -E_NOT_EXEC;
  8022df:	83 c4 10             	add    $0x10,%esp
  8022e2:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  8022e9:	ff ff ff 
  8022ec:	e9 3d 04 00 00       	jmp    80272e <spawn+0x544>
		string_size += strlen(argv[argc]) + 1;
  8022f1:	83 ec 0c             	sub    $0xc,%esp
  8022f4:	50                   	push   %eax
  8022f5:	e8 b7 ea ff ff       	call   800db1 <strlen>
  8022fa:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  8022fe:	83 c3 01             	add    $0x1,%ebx
  802301:	83 c4 10             	add    $0x10,%esp
  802304:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  80230b:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  80230e:	85 c0                	test   %eax,%eax
  802310:	75 df                	jne    8022f1 <spawn+0x107>
  802312:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  802318:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  80231e:	bf 00 10 40 00       	mov    $0x401000,%edi
  802323:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802325:	89 fa                	mov    %edi,%edx
  802327:	83 e2 fc             	and    $0xfffffffc,%edx
  80232a:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  802331:	29 c2                	sub    %eax,%edx
  802333:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802339:	8d 42 f8             	lea    -0x8(%edx),%eax
  80233c:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802341:	0f 86 0a 04 00 00    	jbe    802751 <spawn+0x567>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802347:	83 ec 04             	sub    $0x4,%esp
  80234a:	6a 07                	push   $0x7
  80234c:	68 00 00 40 00       	push   $0x400000
  802351:	6a 00                	push   $0x0
  802353:	e8 84 ee ff ff       	call   8011dc <sys_page_alloc>
  802358:	83 c4 10             	add    $0x10,%esp
  80235b:	85 c0                	test   %eax,%eax
  80235d:	0f 88 f3 03 00 00    	js     802756 <spawn+0x56c>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802363:	be 00 00 00 00       	mov    $0x0,%esi
  802368:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  80236e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802371:	eb 30                	jmp    8023a3 <spawn+0x1b9>
		argv_store[i] = UTEMP2USTACK(string_store);
  802373:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802379:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  80237f:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  802382:	83 ec 08             	sub    $0x8,%esp
  802385:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802388:	57                   	push   %edi
  802389:	e8 5c ea ff ff       	call   800dea <strcpy>
		string_store += strlen(argv[i]) + 1;
  80238e:	83 c4 04             	add    $0x4,%esp
  802391:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802394:	e8 18 ea ff ff       	call   800db1 <strlen>
  802399:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  80239d:	83 c6 01             	add    $0x1,%esi
  8023a0:	83 c4 10             	add    $0x10,%esp
  8023a3:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  8023a9:	7f c8                	jg     802373 <spawn+0x189>
	}
	argv_store[argc] = 0;
  8023ab:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8023b1:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  8023b7:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8023be:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  8023c4:	0f 85 86 00 00 00    	jne    802450 <spawn+0x266>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8023ca:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  8023d0:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  8023d6:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  8023d9:	89 d0                	mov    %edx,%eax
  8023db:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  8023e1:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8023e4:	2d 08 30 80 11       	sub    $0x11803008,%eax
  8023e9:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8023ef:	83 ec 0c             	sub    $0xc,%esp
  8023f2:	6a 07                	push   $0x7
  8023f4:	68 00 d0 bf ee       	push   $0xeebfd000
  8023f9:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8023ff:	68 00 00 40 00       	push   $0x400000
  802404:	6a 00                	push   $0x0
  802406:	e8 14 ee ff ff       	call   80121f <sys_page_map>
  80240b:	89 c3                	mov    %eax,%ebx
  80240d:	83 c4 20             	add    $0x20,%esp
  802410:	85 c0                	test   %eax,%eax
  802412:	0f 88 46 03 00 00    	js     80275e <spawn+0x574>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802418:	83 ec 08             	sub    $0x8,%esp
  80241b:	68 00 00 40 00       	push   $0x400000
  802420:	6a 00                	push   $0x0
  802422:	e8 3a ee ff ff       	call   801261 <sys_page_unmap>
  802427:	89 c3                	mov    %eax,%ebx
  802429:	83 c4 10             	add    $0x10,%esp
  80242c:	85 c0                	test   %eax,%eax
  80242e:	0f 88 2a 03 00 00    	js     80275e <spawn+0x574>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802434:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  80243a:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802441:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  802448:	00 00 00 
  80244b:	e9 4f 01 00 00       	jmp    80259f <spawn+0x3b5>
	assert(string_store == (char*)UTEMP + PGSIZE);
  802450:	68 10 3c 80 00       	push   $0x803c10
  802455:	68 5b 3b 80 00       	push   $0x803b5b
  80245a:	68 f8 00 00 00       	push   $0xf8
  80245f:	68 a1 3b 80 00       	push   $0x803ba1
  802464:	e8 2c e1 ff ff       	call   800595 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802469:	83 ec 04             	sub    $0x4,%esp
  80246c:	6a 07                	push   $0x7
  80246e:	68 00 00 40 00       	push   $0x400000
  802473:	6a 00                	push   $0x0
  802475:	e8 62 ed ff ff       	call   8011dc <sys_page_alloc>
  80247a:	83 c4 10             	add    $0x10,%esp
  80247d:	85 c0                	test   %eax,%eax
  80247f:	0f 88 b7 02 00 00    	js     80273c <spawn+0x552>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802485:	83 ec 08             	sub    $0x8,%esp
  802488:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  80248e:	01 f0                	add    %esi,%eax
  802490:	50                   	push   %eax
  802491:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802497:	e8 59 f9 ff ff       	call   801df5 <seek>
  80249c:	83 c4 10             	add    $0x10,%esp
  80249f:	85 c0                	test   %eax,%eax
  8024a1:	0f 88 9c 02 00 00    	js     802743 <spawn+0x559>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8024a7:	83 ec 04             	sub    $0x4,%esp
  8024aa:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8024b0:	29 f0                	sub    %esi,%eax
  8024b2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8024b7:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8024bc:	0f 47 c1             	cmova  %ecx,%eax
  8024bf:	50                   	push   %eax
  8024c0:	68 00 00 40 00       	push   $0x400000
  8024c5:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8024cb:	e8 5e f8 ff ff       	call   801d2e <readn>
  8024d0:	83 c4 10             	add    $0x10,%esp
  8024d3:	85 c0                	test   %eax,%eax
  8024d5:	0f 88 6f 02 00 00    	js     80274a <spawn+0x560>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8024db:	83 ec 0c             	sub    $0xc,%esp
  8024de:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8024e4:	53                   	push   %ebx
  8024e5:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  8024eb:	68 00 00 40 00       	push   $0x400000
  8024f0:	6a 00                	push   $0x0
  8024f2:	e8 28 ed ff ff       	call   80121f <sys_page_map>
  8024f7:	83 c4 20             	add    $0x20,%esp
  8024fa:	85 c0                	test   %eax,%eax
  8024fc:	78 7c                	js     80257a <spawn+0x390>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  8024fe:	83 ec 08             	sub    $0x8,%esp
  802501:	68 00 00 40 00       	push   $0x400000
  802506:	6a 00                	push   $0x0
  802508:	e8 54 ed ff ff       	call   801261 <sys_page_unmap>
  80250d:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  802510:	81 c7 00 10 00 00    	add    $0x1000,%edi
  802516:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80251c:	89 fe                	mov    %edi,%esi
  80251e:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  802524:	76 69                	jbe    80258f <spawn+0x3a5>
		if (i >= filesz) {
  802526:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  80252c:	0f 87 37 ff ff ff    	ja     802469 <spawn+0x27f>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802532:	83 ec 04             	sub    $0x4,%esp
  802535:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  80253b:	53                   	push   %ebx
  80253c:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802542:	e8 95 ec ff ff       	call   8011dc <sys_page_alloc>
  802547:	83 c4 10             	add    $0x10,%esp
  80254a:	85 c0                	test   %eax,%eax
  80254c:	79 c2                	jns    802510 <spawn+0x326>
  80254e:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  802550:	83 ec 0c             	sub    $0xc,%esp
  802553:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802559:	e8 ff eb ff ff       	call   80115d <sys_env_destroy>
	close(fd);
  80255e:	83 c4 04             	add    $0x4,%esp
  802561:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802567:	e8 fd f5 ff ff       	call   801b69 <close>
	return r;
  80256c:	83 c4 10             	add    $0x10,%esp
  80256f:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  802575:	e9 b4 01 00 00       	jmp    80272e <spawn+0x544>
				panic("spawn: sys_page_map data: %e", r);
  80257a:	50                   	push   %eax
  80257b:	68 ad 3b 80 00       	push   $0x803bad
  802580:	68 2b 01 00 00       	push   $0x12b
  802585:	68 a1 3b 80 00       	push   $0x803ba1
  80258a:	e8 06 e0 ff ff       	call   800595 <_panic>
  80258f:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802595:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  80259c:	83 c6 20             	add    $0x20,%esi
  80259f:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  8025a6:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  8025ac:	7e 6d                	jle    80261b <spawn+0x431>
		if (ph->p_type != ELF_PROG_LOAD)
  8025ae:	83 3e 01             	cmpl   $0x1,(%esi)
  8025b1:	75 e2                	jne    802595 <spawn+0x3ab>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8025b3:	8b 46 18             	mov    0x18(%esi),%eax
  8025b6:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  8025b9:	83 f8 01             	cmp    $0x1,%eax
  8025bc:	19 c0                	sbb    %eax,%eax
  8025be:	83 e0 fe             	and    $0xfffffffe,%eax
  8025c1:	83 c0 07             	add    $0x7,%eax
  8025c4:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  8025ca:	8b 4e 04             	mov    0x4(%esi),%ecx
  8025cd:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  8025d3:	8b 56 10             	mov    0x10(%esi),%edx
  8025d6:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  8025dc:	8b 7e 14             	mov    0x14(%esi),%edi
  8025df:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  8025e5:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  8025e8:	89 d8                	mov    %ebx,%eax
  8025ea:	25 ff 0f 00 00       	and    $0xfff,%eax
  8025ef:	74 1a                	je     80260b <spawn+0x421>
		va -= i;
  8025f1:	29 c3                	sub    %eax,%ebx
		memsz += i;
  8025f3:	01 c7                	add    %eax,%edi
  8025f5:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  8025fb:	01 c2                	add    %eax,%edx
  8025fd:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  802603:	29 c1                	sub    %eax,%ecx
  802605:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  80260b:	bf 00 00 00 00       	mov    $0x0,%edi
  802610:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  802616:	e9 01 ff ff ff       	jmp    80251c <spawn+0x332>
	close(fd);
  80261b:	83 ec 0c             	sub    $0xc,%esp
  80261e:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802624:	e8 40 f5 ff ff       	call   801b69 <close>

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	cprintf("in %s\n", __FUNCTION__);
  802629:	83 c4 08             	add    $0x8,%esp
  80262c:	68 40 3c 80 00       	push   $0x803c40
  802631:	68 de 35 80 00       	push   $0x8035de
  802636:	e8 50 e0 ff ff       	call   80068b <cprintf>
  80263b:	83 c4 10             	add    $0x10,%esp
	int r;
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  80263e:	bb 00 00 80 00       	mov    $0x800000,%ebx
  802643:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  802649:	eb 0e                	jmp    802659 <spawn+0x46f>
  80264b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802651:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  802657:	74 5e                	je     8026b7 <spawn+0x4cd>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_SHARE)) == (PTE_P | PTE_U | PTE_SHARE)))
  802659:	89 d8                	mov    %ebx,%eax
  80265b:	c1 e8 16             	shr    $0x16,%eax
  80265e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802665:	a8 01                	test   $0x1,%al
  802667:	74 e2                	je     80264b <spawn+0x461>
  802669:	89 da                	mov    %ebx,%edx
  80266b:	c1 ea 0c             	shr    $0xc,%edx
  80266e:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  802675:	25 05 04 00 00       	and    $0x405,%eax
  80267a:	3d 05 04 00 00       	cmp    $0x405,%eax
  80267f:	75 ca                	jne    80264b <spawn+0x461>
			if((r = sys_page_map((envid_t)0, (void *)i, child, (void *)i, uvpt[PGNUM(i)] & PTE_SYSCALL)) < 0)
  802681:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  802688:	83 ec 0c             	sub    $0xc,%esp
  80268b:	25 07 0e 00 00       	and    $0xe07,%eax
  802690:	50                   	push   %eax
  802691:	53                   	push   %ebx
  802692:	56                   	push   %esi
  802693:	53                   	push   %ebx
  802694:	6a 00                	push   $0x0
  802696:	e8 84 eb ff ff       	call   80121f <sys_page_map>
  80269b:	83 c4 20             	add    $0x20,%esp
  80269e:	85 c0                	test   %eax,%eax
  8026a0:	79 a9                	jns    80264b <spawn+0x461>
        		panic("sys_page_map: %e\n", r);
  8026a2:	50                   	push   %eax
  8026a3:	68 ca 3b 80 00       	push   $0x803bca
  8026a8:	68 3b 01 00 00       	push   $0x13b
  8026ad:	68 a1 3b 80 00       	push   $0x803ba1
  8026b2:	e8 de de ff ff       	call   800595 <_panic>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8026b7:	83 ec 08             	sub    $0x8,%esp
  8026ba:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  8026c0:	50                   	push   %eax
  8026c1:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8026c7:	e8 19 ec ff ff       	call   8012e5 <sys_env_set_trapframe>
  8026cc:	83 c4 10             	add    $0x10,%esp
  8026cf:	85 c0                	test   %eax,%eax
  8026d1:	78 25                	js     8026f8 <spawn+0x50e>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8026d3:	83 ec 08             	sub    $0x8,%esp
  8026d6:	6a 02                	push   $0x2
  8026d8:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8026de:	e8 c0 eb ff ff       	call   8012a3 <sys_env_set_status>
  8026e3:	83 c4 10             	add    $0x10,%esp
  8026e6:	85 c0                	test   %eax,%eax
  8026e8:	78 23                	js     80270d <spawn+0x523>
	return child;
  8026ea:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8026f0:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8026f6:	eb 36                	jmp    80272e <spawn+0x544>
		panic("sys_env_set_trapframe: %e", r);
  8026f8:	50                   	push   %eax
  8026f9:	68 dc 3b 80 00       	push   $0x803bdc
  8026fe:	68 8a 00 00 00       	push   $0x8a
  802703:	68 a1 3b 80 00       	push   $0x803ba1
  802708:	e8 88 de ff ff       	call   800595 <_panic>
		panic("sys_env_set_status: %e", r);
  80270d:	50                   	push   %eax
  80270e:	68 f6 3b 80 00       	push   $0x803bf6
  802713:	68 8d 00 00 00       	push   $0x8d
  802718:	68 a1 3b 80 00       	push   $0x803ba1
  80271d:	e8 73 de ff ff       	call   800595 <_panic>
		return r;
  802722:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802728:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  80272e:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802734:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802737:	5b                   	pop    %ebx
  802738:	5e                   	pop    %esi
  802739:	5f                   	pop    %edi
  80273a:	5d                   	pop    %ebp
  80273b:	c3                   	ret    
  80273c:	89 c7                	mov    %eax,%edi
  80273e:	e9 0d fe ff ff       	jmp    802550 <spawn+0x366>
  802743:	89 c7                	mov    %eax,%edi
  802745:	e9 06 fe ff ff       	jmp    802550 <spawn+0x366>
  80274a:	89 c7                	mov    %eax,%edi
  80274c:	e9 ff fd ff ff       	jmp    802550 <spawn+0x366>
		return -E_NO_MEM;
  802751:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  802756:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  80275c:	eb d0                	jmp    80272e <spawn+0x544>
	sys_page_unmap(0, UTEMP);
  80275e:	83 ec 08             	sub    $0x8,%esp
  802761:	68 00 00 40 00       	push   $0x400000
  802766:	6a 00                	push   $0x0
  802768:	e8 f4 ea ff ff       	call   801261 <sys_page_unmap>
  80276d:	83 c4 10             	add    $0x10,%esp
  802770:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  802776:	eb b6                	jmp    80272e <spawn+0x544>

00802778 <spawnl>:
{
  802778:	55                   	push   %ebp
  802779:	89 e5                	mov    %esp,%ebp
  80277b:	57                   	push   %edi
  80277c:	56                   	push   %esi
  80277d:	53                   	push   %ebx
  80277e:	83 ec 14             	sub    $0x14,%esp
	cprintf("in %s\n", __FUNCTION__);
  802781:	68 38 3c 80 00       	push   $0x803c38
  802786:	68 de 35 80 00       	push   $0x8035de
  80278b:	e8 fb de ff ff       	call   80068b <cprintf>
	va_start(vl, arg0);
  802790:	8d 55 10             	lea    0x10(%ebp),%edx
	while(va_arg(vl, void *) != NULL)
  802793:	83 c4 10             	add    $0x10,%esp
	int argc=0;
  802796:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  80279b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80279e:	83 3a 00             	cmpl   $0x0,(%edx)
  8027a1:	74 07                	je     8027aa <spawnl+0x32>
		argc++;
  8027a3:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  8027a6:	89 ca                	mov    %ecx,%edx
  8027a8:	eb f1                	jmp    80279b <spawnl+0x23>
	const char *argv[argc+2];
  8027aa:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  8027b1:	83 e2 f0             	and    $0xfffffff0,%edx
  8027b4:	29 d4                	sub    %edx,%esp
  8027b6:	8d 54 24 03          	lea    0x3(%esp),%edx
  8027ba:	c1 ea 02             	shr    $0x2,%edx
  8027bd:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  8027c4:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  8027c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027c9:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  8027d0:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  8027d7:	00 
	va_start(vl, arg0);
  8027d8:	8d 4d 10             	lea    0x10(%ebp),%ecx
  8027db:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  8027dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e2:	eb 0b                	jmp    8027ef <spawnl+0x77>
		argv[i+1] = va_arg(vl, const char *);
  8027e4:	83 c0 01             	add    $0x1,%eax
  8027e7:	8b 39                	mov    (%ecx),%edi
  8027e9:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  8027ec:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  8027ef:	39 d0                	cmp    %edx,%eax
  8027f1:	75 f1                	jne    8027e4 <spawnl+0x6c>
	return spawn(prog, argv);
  8027f3:	83 ec 08             	sub    $0x8,%esp
  8027f6:	56                   	push   %esi
  8027f7:	ff 75 08             	pushl  0x8(%ebp)
  8027fa:	e8 eb f9 ff ff       	call   8021ea <spawn>
}
  8027ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802802:	5b                   	pop    %ebx
  802803:	5e                   	pop    %esi
  802804:	5f                   	pop    %edi
  802805:	5d                   	pop    %ebp
  802806:	c3                   	ret    

00802807 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802807:	55                   	push   %ebp
  802808:	89 e5                	mov    %esp,%ebp
  80280a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80280d:	68 66 3c 80 00       	push   $0x803c66
  802812:	ff 75 0c             	pushl  0xc(%ebp)
  802815:	e8 d0 e5 ff ff       	call   800dea <strcpy>
	return 0;
}
  80281a:	b8 00 00 00 00       	mov    $0x0,%eax
  80281f:	c9                   	leave  
  802820:	c3                   	ret    

00802821 <devsock_close>:
{
  802821:	55                   	push   %ebp
  802822:	89 e5                	mov    %esp,%ebp
  802824:	53                   	push   %ebx
  802825:	83 ec 10             	sub    $0x10,%esp
  802828:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80282b:	53                   	push   %ebx
  80282c:	e8 72 09 00 00       	call   8031a3 <pageref>
  802831:	83 c4 10             	add    $0x10,%esp
		return 0;
  802834:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  802839:	83 f8 01             	cmp    $0x1,%eax
  80283c:	74 07                	je     802845 <devsock_close+0x24>
}
  80283e:	89 d0                	mov    %edx,%eax
  802840:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802843:	c9                   	leave  
  802844:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  802845:	83 ec 0c             	sub    $0xc,%esp
  802848:	ff 73 0c             	pushl  0xc(%ebx)
  80284b:	e8 b9 02 00 00       	call   802b09 <nsipc_close>
  802850:	89 c2                	mov    %eax,%edx
  802852:	83 c4 10             	add    $0x10,%esp
  802855:	eb e7                	jmp    80283e <devsock_close+0x1d>

00802857 <devsock_write>:
{
  802857:	55                   	push   %ebp
  802858:	89 e5                	mov    %esp,%ebp
  80285a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80285d:	6a 00                	push   $0x0
  80285f:	ff 75 10             	pushl  0x10(%ebp)
  802862:	ff 75 0c             	pushl  0xc(%ebp)
  802865:	8b 45 08             	mov    0x8(%ebp),%eax
  802868:	ff 70 0c             	pushl  0xc(%eax)
  80286b:	e8 76 03 00 00       	call   802be6 <nsipc_send>
}
  802870:	c9                   	leave  
  802871:	c3                   	ret    

00802872 <devsock_read>:
{
  802872:	55                   	push   %ebp
  802873:	89 e5                	mov    %esp,%ebp
  802875:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802878:	6a 00                	push   $0x0
  80287a:	ff 75 10             	pushl  0x10(%ebp)
  80287d:	ff 75 0c             	pushl  0xc(%ebp)
  802880:	8b 45 08             	mov    0x8(%ebp),%eax
  802883:	ff 70 0c             	pushl  0xc(%eax)
  802886:	e8 ef 02 00 00       	call   802b7a <nsipc_recv>
}
  80288b:	c9                   	leave  
  80288c:	c3                   	ret    

0080288d <fd2sockid>:
{
  80288d:	55                   	push   %ebp
  80288e:	89 e5                	mov    %esp,%ebp
  802890:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802893:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802896:	52                   	push   %edx
  802897:	50                   	push   %eax
  802898:	e8 9a f1 ff ff       	call   801a37 <fd_lookup>
  80289d:	83 c4 10             	add    $0x10,%esp
  8028a0:	85 c0                	test   %eax,%eax
  8028a2:	78 10                	js     8028b4 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8028a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a7:	8b 0d 3c 40 80 00    	mov    0x80403c,%ecx
  8028ad:	39 08                	cmp    %ecx,(%eax)
  8028af:	75 05                	jne    8028b6 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8028b1:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8028b4:	c9                   	leave  
  8028b5:	c3                   	ret    
		return -E_NOT_SUPP;
  8028b6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8028bb:	eb f7                	jmp    8028b4 <fd2sockid+0x27>

008028bd <alloc_sockfd>:
{
  8028bd:	55                   	push   %ebp
  8028be:	89 e5                	mov    %esp,%ebp
  8028c0:	56                   	push   %esi
  8028c1:	53                   	push   %ebx
  8028c2:	83 ec 1c             	sub    $0x1c,%esp
  8028c5:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8028c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028ca:	50                   	push   %eax
  8028cb:	e8 15 f1 ff ff       	call   8019e5 <fd_alloc>
  8028d0:	89 c3                	mov    %eax,%ebx
  8028d2:	83 c4 10             	add    $0x10,%esp
  8028d5:	85 c0                	test   %eax,%eax
  8028d7:	78 43                	js     80291c <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8028d9:	83 ec 04             	sub    $0x4,%esp
  8028dc:	68 07 04 00 00       	push   $0x407
  8028e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8028e4:	6a 00                	push   $0x0
  8028e6:	e8 f1 e8 ff ff       	call   8011dc <sys_page_alloc>
  8028eb:	89 c3                	mov    %eax,%ebx
  8028ed:	83 c4 10             	add    $0x10,%esp
  8028f0:	85 c0                	test   %eax,%eax
  8028f2:	78 28                	js     80291c <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8028f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f7:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8028fd:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8028ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802902:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802909:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80290c:	83 ec 0c             	sub    $0xc,%esp
  80290f:	50                   	push   %eax
  802910:	e8 a9 f0 ff ff       	call   8019be <fd2num>
  802915:	89 c3                	mov    %eax,%ebx
  802917:	83 c4 10             	add    $0x10,%esp
  80291a:	eb 0c                	jmp    802928 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80291c:	83 ec 0c             	sub    $0xc,%esp
  80291f:	56                   	push   %esi
  802920:	e8 e4 01 00 00       	call   802b09 <nsipc_close>
		return r;
  802925:	83 c4 10             	add    $0x10,%esp
}
  802928:	89 d8                	mov    %ebx,%eax
  80292a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80292d:	5b                   	pop    %ebx
  80292e:	5e                   	pop    %esi
  80292f:	5d                   	pop    %ebp
  802930:	c3                   	ret    

00802931 <accept>:
{
  802931:	55                   	push   %ebp
  802932:	89 e5                	mov    %esp,%ebp
  802934:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802937:	8b 45 08             	mov    0x8(%ebp),%eax
  80293a:	e8 4e ff ff ff       	call   80288d <fd2sockid>
  80293f:	85 c0                	test   %eax,%eax
  802941:	78 1b                	js     80295e <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802943:	83 ec 04             	sub    $0x4,%esp
  802946:	ff 75 10             	pushl  0x10(%ebp)
  802949:	ff 75 0c             	pushl  0xc(%ebp)
  80294c:	50                   	push   %eax
  80294d:	e8 0e 01 00 00       	call   802a60 <nsipc_accept>
  802952:	83 c4 10             	add    $0x10,%esp
  802955:	85 c0                	test   %eax,%eax
  802957:	78 05                	js     80295e <accept+0x2d>
	return alloc_sockfd(r);
  802959:	e8 5f ff ff ff       	call   8028bd <alloc_sockfd>
}
  80295e:	c9                   	leave  
  80295f:	c3                   	ret    

00802960 <bind>:
{
  802960:	55                   	push   %ebp
  802961:	89 e5                	mov    %esp,%ebp
  802963:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802966:	8b 45 08             	mov    0x8(%ebp),%eax
  802969:	e8 1f ff ff ff       	call   80288d <fd2sockid>
  80296e:	85 c0                	test   %eax,%eax
  802970:	78 12                	js     802984 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802972:	83 ec 04             	sub    $0x4,%esp
  802975:	ff 75 10             	pushl  0x10(%ebp)
  802978:	ff 75 0c             	pushl  0xc(%ebp)
  80297b:	50                   	push   %eax
  80297c:	e8 31 01 00 00       	call   802ab2 <nsipc_bind>
  802981:	83 c4 10             	add    $0x10,%esp
}
  802984:	c9                   	leave  
  802985:	c3                   	ret    

00802986 <shutdown>:
{
  802986:	55                   	push   %ebp
  802987:	89 e5                	mov    %esp,%ebp
  802989:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80298c:	8b 45 08             	mov    0x8(%ebp),%eax
  80298f:	e8 f9 fe ff ff       	call   80288d <fd2sockid>
  802994:	85 c0                	test   %eax,%eax
  802996:	78 0f                	js     8029a7 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802998:	83 ec 08             	sub    $0x8,%esp
  80299b:	ff 75 0c             	pushl  0xc(%ebp)
  80299e:	50                   	push   %eax
  80299f:	e8 43 01 00 00       	call   802ae7 <nsipc_shutdown>
  8029a4:	83 c4 10             	add    $0x10,%esp
}
  8029a7:	c9                   	leave  
  8029a8:	c3                   	ret    

008029a9 <connect>:
{
  8029a9:	55                   	push   %ebp
  8029aa:	89 e5                	mov    %esp,%ebp
  8029ac:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8029af:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b2:	e8 d6 fe ff ff       	call   80288d <fd2sockid>
  8029b7:	85 c0                	test   %eax,%eax
  8029b9:	78 12                	js     8029cd <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8029bb:	83 ec 04             	sub    $0x4,%esp
  8029be:	ff 75 10             	pushl  0x10(%ebp)
  8029c1:	ff 75 0c             	pushl  0xc(%ebp)
  8029c4:	50                   	push   %eax
  8029c5:	e8 59 01 00 00       	call   802b23 <nsipc_connect>
  8029ca:	83 c4 10             	add    $0x10,%esp
}
  8029cd:	c9                   	leave  
  8029ce:	c3                   	ret    

008029cf <listen>:
{
  8029cf:	55                   	push   %ebp
  8029d0:	89 e5                	mov    %esp,%ebp
  8029d2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8029d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d8:	e8 b0 fe ff ff       	call   80288d <fd2sockid>
  8029dd:	85 c0                	test   %eax,%eax
  8029df:	78 0f                	js     8029f0 <listen+0x21>
	return nsipc_listen(r, backlog);
  8029e1:	83 ec 08             	sub    $0x8,%esp
  8029e4:	ff 75 0c             	pushl  0xc(%ebp)
  8029e7:	50                   	push   %eax
  8029e8:	e8 6b 01 00 00       	call   802b58 <nsipc_listen>
  8029ed:	83 c4 10             	add    $0x10,%esp
}
  8029f0:	c9                   	leave  
  8029f1:	c3                   	ret    

008029f2 <socket>:

int
socket(int domain, int type, int protocol)
{
  8029f2:	55                   	push   %ebp
  8029f3:	89 e5                	mov    %esp,%ebp
  8029f5:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8029f8:	ff 75 10             	pushl  0x10(%ebp)
  8029fb:	ff 75 0c             	pushl  0xc(%ebp)
  8029fe:	ff 75 08             	pushl  0x8(%ebp)
  802a01:	e8 3e 02 00 00       	call   802c44 <nsipc_socket>
  802a06:	83 c4 10             	add    $0x10,%esp
  802a09:	85 c0                	test   %eax,%eax
  802a0b:	78 05                	js     802a12 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802a0d:	e8 ab fe ff ff       	call   8028bd <alloc_sockfd>
}
  802a12:	c9                   	leave  
  802a13:	c3                   	ret    

00802a14 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802a14:	55                   	push   %ebp
  802a15:	89 e5                	mov    %esp,%ebp
  802a17:	53                   	push   %ebx
  802a18:	83 ec 04             	sub    $0x4,%esp
  802a1b:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802a1d:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802a24:	74 26                	je     802a4c <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802a26:	6a 07                	push   $0x7
  802a28:	68 00 70 80 00       	push   $0x807000
  802a2d:	53                   	push   %ebx
  802a2e:	ff 35 04 50 80 00    	pushl  0x805004
  802a34:	e8 d3 06 00 00       	call   80310c <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802a39:	83 c4 0c             	add    $0xc,%esp
  802a3c:	6a 00                	push   $0x0
  802a3e:	6a 00                	push   $0x0
  802a40:	6a 00                	push   $0x0
  802a42:	e8 5c 06 00 00       	call   8030a3 <ipc_recv>
}
  802a47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802a4a:	c9                   	leave  
  802a4b:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802a4c:	83 ec 0c             	sub    $0xc,%esp
  802a4f:	6a 02                	push   $0x2
  802a51:	e8 0e 07 00 00       	call   803164 <ipc_find_env>
  802a56:	a3 04 50 80 00       	mov    %eax,0x805004
  802a5b:	83 c4 10             	add    $0x10,%esp
  802a5e:	eb c6                	jmp    802a26 <nsipc+0x12>

00802a60 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802a60:	55                   	push   %ebp
  802a61:	89 e5                	mov    %esp,%ebp
  802a63:	56                   	push   %esi
  802a64:	53                   	push   %ebx
  802a65:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802a68:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802a70:	8b 06                	mov    (%esi),%eax
  802a72:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802a77:	b8 01 00 00 00       	mov    $0x1,%eax
  802a7c:	e8 93 ff ff ff       	call   802a14 <nsipc>
  802a81:	89 c3                	mov    %eax,%ebx
  802a83:	85 c0                	test   %eax,%eax
  802a85:	79 09                	jns    802a90 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802a87:	89 d8                	mov    %ebx,%eax
  802a89:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a8c:	5b                   	pop    %ebx
  802a8d:	5e                   	pop    %esi
  802a8e:	5d                   	pop    %ebp
  802a8f:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802a90:	83 ec 04             	sub    $0x4,%esp
  802a93:	ff 35 10 70 80 00    	pushl  0x807010
  802a99:	68 00 70 80 00       	push   $0x807000
  802a9e:	ff 75 0c             	pushl  0xc(%ebp)
  802aa1:	e8 d2 e4 ff ff       	call   800f78 <memmove>
		*addrlen = ret->ret_addrlen;
  802aa6:	a1 10 70 80 00       	mov    0x807010,%eax
  802aab:	89 06                	mov    %eax,(%esi)
  802aad:	83 c4 10             	add    $0x10,%esp
	return r;
  802ab0:	eb d5                	jmp    802a87 <nsipc_accept+0x27>

00802ab2 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802ab2:	55                   	push   %ebp
  802ab3:	89 e5                	mov    %esp,%ebp
  802ab5:	53                   	push   %ebx
  802ab6:	83 ec 08             	sub    $0x8,%esp
  802ab9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802abc:	8b 45 08             	mov    0x8(%ebp),%eax
  802abf:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802ac4:	53                   	push   %ebx
  802ac5:	ff 75 0c             	pushl  0xc(%ebp)
  802ac8:	68 04 70 80 00       	push   $0x807004
  802acd:	e8 a6 e4 ff ff       	call   800f78 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802ad2:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802ad8:	b8 02 00 00 00       	mov    $0x2,%eax
  802add:	e8 32 ff ff ff       	call   802a14 <nsipc>
}
  802ae2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802ae5:	c9                   	leave  
  802ae6:	c3                   	ret    

00802ae7 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802ae7:	55                   	push   %ebp
  802ae8:	89 e5                	mov    %esp,%ebp
  802aea:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802aed:	8b 45 08             	mov    0x8(%ebp),%eax
  802af0:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802af5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802af8:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802afd:	b8 03 00 00 00       	mov    $0x3,%eax
  802b02:	e8 0d ff ff ff       	call   802a14 <nsipc>
}
  802b07:	c9                   	leave  
  802b08:	c3                   	ret    

00802b09 <nsipc_close>:

int
nsipc_close(int s)
{
  802b09:	55                   	push   %ebp
  802b0a:	89 e5                	mov    %esp,%ebp
  802b0c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b12:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802b17:	b8 04 00 00 00       	mov    $0x4,%eax
  802b1c:	e8 f3 fe ff ff       	call   802a14 <nsipc>
}
  802b21:	c9                   	leave  
  802b22:	c3                   	ret    

00802b23 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802b23:	55                   	push   %ebp
  802b24:	89 e5                	mov    %esp,%ebp
  802b26:	53                   	push   %ebx
  802b27:	83 ec 08             	sub    $0x8,%esp
  802b2a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b30:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802b35:	53                   	push   %ebx
  802b36:	ff 75 0c             	pushl  0xc(%ebp)
  802b39:	68 04 70 80 00       	push   $0x807004
  802b3e:	e8 35 e4 ff ff       	call   800f78 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802b43:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802b49:	b8 05 00 00 00       	mov    $0x5,%eax
  802b4e:	e8 c1 fe ff ff       	call   802a14 <nsipc>
}
  802b53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b56:	c9                   	leave  
  802b57:	c3                   	ret    

00802b58 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802b58:	55                   	push   %ebp
  802b59:	89 e5                	mov    %esp,%ebp
  802b5b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b61:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802b66:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b69:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802b6e:	b8 06 00 00 00       	mov    $0x6,%eax
  802b73:	e8 9c fe ff ff       	call   802a14 <nsipc>
}
  802b78:	c9                   	leave  
  802b79:	c3                   	ret    

00802b7a <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802b7a:	55                   	push   %ebp
  802b7b:	89 e5                	mov    %esp,%ebp
  802b7d:	56                   	push   %esi
  802b7e:	53                   	push   %ebx
  802b7f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802b82:	8b 45 08             	mov    0x8(%ebp),%eax
  802b85:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802b8a:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802b90:	8b 45 14             	mov    0x14(%ebp),%eax
  802b93:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802b98:	b8 07 00 00 00       	mov    $0x7,%eax
  802b9d:	e8 72 fe ff ff       	call   802a14 <nsipc>
  802ba2:	89 c3                	mov    %eax,%ebx
  802ba4:	85 c0                	test   %eax,%eax
  802ba6:	78 1f                	js     802bc7 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802ba8:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802bad:	7f 21                	jg     802bd0 <nsipc_recv+0x56>
  802baf:	39 c6                	cmp    %eax,%esi
  802bb1:	7c 1d                	jl     802bd0 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802bb3:	83 ec 04             	sub    $0x4,%esp
  802bb6:	50                   	push   %eax
  802bb7:	68 00 70 80 00       	push   $0x807000
  802bbc:	ff 75 0c             	pushl  0xc(%ebp)
  802bbf:	e8 b4 e3 ff ff       	call   800f78 <memmove>
  802bc4:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802bc7:	89 d8                	mov    %ebx,%eax
  802bc9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802bcc:	5b                   	pop    %ebx
  802bcd:	5e                   	pop    %esi
  802bce:	5d                   	pop    %ebp
  802bcf:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802bd0:	68 72 3c 80 00       	push   $0x803c72
  802bd5:	68 5b 3b 80 00       	push   $0x803b5b
  802bda:	6a 62                	push   $0x62
  802bdc:	68 87 3c 80 00       	push   $0x803c87
  802be1:	e8 af d9 ff ff       	call   800595 <_panic>

00802be6 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802be6:	55                   	push   %ebp
  802be7:	89 e5                	mov    %esp,%ebp
  802be9:	53                   	push   %ebx
  802bea:	83 ec 04             	sub    $0x4,%esp
  802bed:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf3:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802bf8:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802bfe:	7f 2e                	jg     802c2e <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802c00:	83 ec 04             	sub    $0x4,%esp
  802c03:	53                   	push   %ebx
  802c04:	ff 75 0c             	pushl  0xc(%ebp)
  802c07:	68 0c 70 80 00       	push   $0x80700c
  802c0c:	e8 67 e3 ff ff       	call   800f78 <memmove>
	nsipcbuf.send.req_size = size;
  802c11:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802c17:	8b 45 14             	mov    0x14(%ebp),%eax
  802c1a:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802c1f:	b8 08 00 00 00       	mov    $0x8,%eax
  802c24:	e8 eb fd ff ff       	call   802a14 <nsipc>
}
  802c29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802c2c:	c9                   	leave  
  802c2d:	c3                   	ret    
	assert(size < 1600);
  802c2e:	68 93 3c 80 00       	push   $0x803c93
  802c33:	68 5b 3b 80 00       	push   $0x803b5b
  802c38:	6a 6d                	push   $0x6d
  802c3a:	68 87 3c 80 00       	push   $0x803c87
  802c3f:	e8 51 d9 ff ff       	call   800595 <_panic>

00802c44 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802c44:	55                   	push   %ebp
  802c45:	89 e5                	mov    %esp,%ebp
  802c47:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802c52:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c55:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802c5a:	8b 45 10             	mov    0x10(%ebp),%eax
  802c5d:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802c62:	b8 09 00 00 00       	mov    $0x9,%eax
  802c67:	e8 a8 fd ff ff       	call   802a14 <nsipc>
}
  802c6c:	c9                   	leave  
  802c6d:	c3                   	ret    

00802c6e <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802c6e:	55                   	push   %ebp
  802c6f:	89 e5                	mov    %esp,%ebp
  802c71:	56                   	push   %esi
  802c72:	53                   	push   %ebx
  802c73:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802c76:	83 ec 0c             	sub    $0xc,%esp
  802c79:	ff 75 08             	pushl  0x8(%ebp)
  802c7c:	e8 4d ed ff ff       	call   8019ce <fd2data>
  802c81:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802c83:	83 c4 08             	add    $0x8,%esp
  802c86:	68 9f 3c 80 00       	push   $0x803c9f
  802c8b:	53                   	push   %ebx
  802c8c:	e8 59 e1 ff ff       	call   800dea <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802c91:	8b 46 04             	mov    0x4(%esi),%eax
  802c94:	2b 06                	sub    (%esi),%eax
  802c96:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802c9c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802ca3:	00 00 00 
	stat->st_dev = &devpipe;
  802ca6:	c7 83 88 00 00 00 58 	movl   $0x804058,0x88(%ebx)
  802cad:	40 80 00 
	return 0;
}
  802cb0:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802cb8:	5b                   	pop    %ebx
  802cb9:	5e                   	pop    %esi
  802cba:	5d                   	pop    %ebp
  802cbb:	c3                   	ret    

00802cbc <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802cbc:	55                   	push   %ebp
  802cbd:	89 e5                	mov    %esp,%ebp
  802cbf:	53                   	push   %ebx
  802cc0:	83 ec 0c             	sub    $0xc,%esp
  802cc3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802cc6:	53                   	push   %ebx
  802cc7:	6a 00                	push   $0x0
  802cc9:	e8 93 e5 ff ff       	call   801261 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802cce:	89 1c 24             	mov    %ebx,(%esp)
  802cd1:	e8 f8 ec ff ff       	call   8019ce <fd2data>
  802cd6:	83 c4 08             	add    $0x8,%esp
  802cd9:	50                   	push   %eax
  802cda:	6a 00                	push   $0x0
  802cdc:	e8 80 e5 ff ff       	call   801261 <sys_page_unmap>
}
  802ce1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802ce4:	c9                   	leave  
  802ce5:	c3                   	ret    

00802ce6 <_pipeisclosed>:
{
  802ce6:	55                   	push   %ebp
  802ce7:	89 e5                	mov    %esp,%ebp
  802ce9:	57                   	push   %edi
  802cea:	56                   	push   %esi
  802ceb:	53                   	push   %ebx
  802cec:	83 ec 1c             	sub    $0x1c,%esp
  802cef:	89 c7                	mov    %eax,%edi
  802cf1:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802cf3:	a1 08 50 80 00       	mov    0x805008,%eax
  802cf8:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802cfb:	83 ec 0c             	sub    $0xc,%esp
  802cfe:	57                   	push   %edi
  802cff:	e8 9f 04 00 00       	call   8031a3 <pageref>
  802d04:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802d07:	89 34 24             	mov    %esi,(%esp)
  802d0a:	e8 94 04 00 00       	call   8031a3 <pageref>
		nn = thisenv->env_runs;
  802d0f:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802d15:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802d18:	83 c4 10             	add    $0x10,%esp
  802d1b:	39 cb                	cmp    %ecx,%ebx
  802d1d:	74 1b                	je     802d3a <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802d1f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802d22:	75 cf                	jne    802cf3 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802d24:	8b 42 58             	mov    0x58(%edx),%eax
  802d27:	6a 01                	push   $0x1
  802d29:	50                   	push   %eax
  802d2a:	53                   	push   %ebx
  802d2b:	68 a6 3c 80 00       	push   $0x803ca6
  802d30:	e8 56 d9 ff ff       	call   80068b <cprintf>
  802d35:	83 c4 10             	add    $0x10,%esp
  802d38:	eb b9                	jmp    802cf3 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802d3a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802d3d:	0f 94 c0             	sete   %al
  802d40:	0f b6 c0             	movzbl %al,%eax
}
  802d43:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d46:	5b                   	pop    %ebx
  802d47:	5e                   	pop    %esi
  802d48:	5f                   	pop    %edi
  802d49:	5d                   	pop    %ebp
  802d4a:	c3                   	ret    

00802d4b <devpipe_write>:
{
  802d4b:	55                   	push   %ebp
  802d4c:	89 e5                	mov    %esp,%ebp
  802d4e:	57                   	push   %edi
  802d4f:	56                   	push   %esi
  802d50:	53                   	push   %ebx
  802d51:	83 ec 28             	sub    $0x28,%esp
  802d54:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802d57:	56                   	push   %esi
  802d58:	e8 71 ec ff ff       	call   8019ce <fd2data>
  802d5d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802d5f:	83 c4 10             	add    $0x10,%esp
  802d62:	bf 00 00 00 00       	mov    $0x0,%edi
  802d67:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802d6a:	74 4f                	je     802dbb <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802d6c:	8b 43 04             	mov    0x4(%ebx),%eax
  802d6f:	8b 0b                	mov    (%ebx),%ecx
  802d71:	8d 51 20             	lea    0x20(%ecx),%edx
  802d74:	39 d0                	cmp    %edx,%eax
  802d76:	72 14                	jb     802d8c <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802d78:	89 da                	mov    %ebx,%edx
  802d7a:	89 f0                	mov    %esi,%eax
  802d7c:	e8 65 ff ff ff       	call   802ce6 <_pipeisclosed>
  802d81:	85 c0                	test   %eax,%eax
  802d83:	75 3b                	jne    802dc0 <devpipe_write+0x75>
			sys_yield();
  802d85:	e8 33 e4 ff ff       	call   8011bd <sys_yield>
  802d8a:	eb e0                	jmp    802d6c <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802d8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802d8f:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802d93:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802d96:	89 c2                	mov    %eax,%edx
  802d98:	c1 fa 1f             	sar    $0x1f,%edx
  802d9b:	89 d1                	mov    %edx,%ecx
  802d9d:	c1 e9 1b             	shr    $0x1b,%ecx
  802da0:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802da3:	83 e2 1f             	and    $0x1f,%edx
  802da6:	29 ca                	sub    %ecx,%edx
  802da8:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802dac:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802db0:	83 c0 01             	add    $0x1,%eax
  802db3:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802db6:	83 c7 01             	add    $0x1,%edi
  802db9:	eb ac                	jmp    802d67 <devpipe_write+0x1c>
	return i;
  802dbb:	8b 45 10             	mov    0x10(%ebp),%eax
  802dbe:	eb 05                	jmp    802dc5 <devpipe_write+0x7a>
				return 0;
  802dc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802dc8:	5b                   	pop    %ebx
  802dc9:	5e                   	pop    %esi
  802dca:	5f                   	pop    %edi
  802dcb:	5d                   	pop    %ebp
  802dcc:	c3                   	ret    

00802dcd <devpipe_read>:
{
  802dcd:	55                   	push   %ebp
  802dce:	89 e5                	mov    %esp,%ebp
  802dd0:	57                   	push   %edi
  802dd1:	56                   	push   %esi
  802dd2:	53                   	push   %ebx
  802dd3:	83 ec 18             	sub    $0x18,%esp
  802dd6:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802dd9:	57                   	push   %edi
  802dda:	e8 ef eb ff ff       	call   8019ce <fd2data>
  802ddf:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802de1:	83 c4 10             	add    $0x10,%esp
  802de4:	be 00 00 00 00       	mov    $0x0,%esi
  802de9:	3b 75 10             	cmp    0x10(%ebp),%esi
  802dec:	75 14                	jne    802e02 <devpipe_read+0x35>
	return i;
  802dee:	8b 45 10             	mov    0x10(%ebp),%eax
  802df1:	eb 02                	jmp    802df5 <devpipe_read+0x28>
				return i;
  802df3:	89 f0                	mov    %esi,%eax
}
  802df5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802df8:	5b                   	pop    %ebx
  802df9:	5e                   	pop    %esi
  802dfa:	5f                   	pop    %edi
  802dfb:	5d                   	pop    %ebp
  802dfc:	c3                   	ret    
			sys_yield();
  802dfd:	e8 bb e3 ff ff       	call   8011bd <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802e02:	8b 03                	mov    (%ebx),%eax
  802e04:	3b 43 04             	cmp    0x4(%ebx),%eax
  802e07:	75 18                	jne    802e21 <devpipe_read+0x54>
			if (i > 0)
  802e09:	85 f6                	test   %esi,%esi
  802e0b:	75 e6                	jne    802df3 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802e0d:	89 da                	mov    %ebx,%edx
  802e0f:	89 f8                	mov    %edi,%eax
  802e11:	e8 d0 fe ff ff       	call   802ce6 <_pipeisclosed>
  802e16:	85 c0                	test   %eax,%eax
  802e18:	74 e3                	je     802dfd <devpipe_read+0x30>
				return 0;
  802e1a:	b8 00 00 00 00       	mov    $0x0,%eax
  802e1f:	eb d4                	jmp    802df5 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802e21:	99                   	cltd   
  802e22:	c1 ea 1b             	shr    $0x1b,%edx
  802e25:	01 d0                	add    %edx,%eax
  802e27:	83 e0 1f             	and    $0x1f,%eax
  802e2a:	29 d0                	sub    %edx,%eax
  802e2c:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802e31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802e34:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802e37:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802e3a:	83 c6 01             	add    $0x1,%esi
  802e3d:	eb aa                	jmp    802de9 <devpipe_read+0x1c>

00802e3f <pipe>:
{
  802e3f:	55                   	push   %ebp
  802e40:	89 e5                	mov    %esp,%ebp
  802e42:	56                   	push   %esi
  802e43:	53                   	push   %ebx
  802e44:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802e47:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e4a:	50                   	push   %eax
  802e4b:	e8 95 eb ff ff       	call   8019e5 <fd_alloc>
  802e50:	89 c3                	mov    %eax,%ebx
  802e52:	83 c4 10             	add    $0x10,%esp
  802e55:	85 c0                	test   %eax,%eax
  802e57:	0f 88 23 01 00 00    	js     802f80 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e5d:	83 ec 04             	sub    $0x4,%esp
  802e60:	68 07 04 00 00       	push   $0x407
  802e65:	ff 75 f4             	pushl  -0xc(%ebp)
  802e68:	6a 00                	push   $0x0
  802e6a:	e8 6d e3 ff ff       	call   8011dc <sys_page_alloc>
  802e6f:	89 c3                	mov    %eax,%ebx
  802e71:	83 c4 10             	add    $0x10,%esp
  802e74:	85 c0                	test   %eax,%eax
  802e76:	0f 88 04 01 00 00    	js     802f80 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802e7c:	83 ec 0c             	sub    $0xc,%esp
  802e7f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802e82:	50                   	push   %eax
  802e83:	e8 5d eb ff ff       	call   8019e5 <fd_alloc>
  802e88:	89 c3                	mov    %eax,%ebx
  802e8a:	83 c4 10             	add    $0x10,%esp
  802e8d:	85 c0                	test   %eax,%eax
  802e8f:	0f 88 db 00 00 00    	js     802f70 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e95:	83 ec 04             	sub    $0x4,%esp
  802e98:	68 07 04 00 00       	push   $0x407
  802e9d:	ff 75 f0             	pushl  -0x10(%ebp)
  802ea0:	6a 00                	push   $0x0
  802ea2:	e8 35 e3 ff ff       	call   8011dc <sys_page_alloc>
  802ea7:	89 c3                	mov    %eax,%ebx
  802ea9:	83 c4 10             	add    $0x10,%esp
  802eac:	85 c0                	test   %eax,%eax
  802eae:	0f 88 bc 00 00 00    	js     802f70 <pipe+0x131>
	va = fd2data(fd0);
  802eb4:	83 ec 0c             	sub    $0xc,%esp
  802eb7:	ff 75 f4             	pushl  -0xc(%ebp)
  802eba:	e8 0f eb ff ff       	call   8019ce <fd2data>
  802ebf:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ec1:	83 c4 0c             	add    $0xc,%esp
  802ec4:	68 07 04 00 00       	push   $0x407
  802ec9:	50                   	push   %eax
  802eca:	6a 00                	push   $0x0
  802ecc:	e8 0b e3 ff ff       	call   8011dc <sys_page_alloc>
  802ed1:	89 c3                	mov    %eax,%ebx
  802ed3:	83 c4 10             	add    $0x10,%esp
  802ed6:	85 c0                	test   %eax,%eax
  802ed8:	0f 88 82 00 00 00    	js     802f60 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ede:	83 ec 0c             	sub    $0xc,%esp
  802ee1:	ff 75 f0             	pushl  -0x10(%ebp)
  802ee4:	e8 e5 ea ff ff       	call   8019ce <fd2data>
  802ee9:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802ef0:	50                   	push   %eax
  802ef1:	6a 00                	push   $0x0
  802ef3:	56                   	push   %esi
  802ef4:	6a 00                	push   $0x0
  802ef6:	e8 24 e3 ff ff       	call   80121f <sys_page_map>
  802efb:	89 c3                	mov    %eax,%ebx
  802efd:	83 c4 20             	add    $0x20,%esp
  802f00:	85 c0                	test   %eax,%eax
  802f02:	78 4e                	js     802f52 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802f04:	a1 58 40 80 00       	mov    0x804058,%eax
  802f09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f0c:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802f0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f11:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802f18:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f1b:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802f1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f20:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802f27:	83 ec 0c             	sub    $0xc,%esp
  802f2a:	ff 75 f4             	pushl  -0xc(%ebp)
  802f2d:	e8 8c ea ff ff       	call   8019be <fd2num>
  802f32:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802f35:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802f37:	83 c4 04             	add    $0x4,%esp
  802f3a:	ff 75 f0             	pushl  -0x10(%ebp)
  802f3d:	e8 7c ea ff ff       	call   8019be <fd2num>
  802f42:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802f45:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802f48:	83 c4 10             	add    $0x10,%esp
  802f4b:	bb 00 00 00 00       	mov    $0x0,%ebx
  802f50:	eb 2e                	jmp    802f80 <pipe+0x141>
	sys_page_unmap(0, va);
  802f52:	83 ec 08             	sub    $0x8,%esp
  802f55:	56                   	push   %esi
  802f56:	6a 00                	push   $0x0
  802f58:	e8 04 e3 ff ff       	call   801261 <sys_page_unmap>
  802f5d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802f60:	83 ec 08             	sub    $0x8,%esp
  802f63:	ff 75 f0             	pushl  -0x10(%ebp)
  802f66:	6a 00                	push   $0x0
  802f68:	e8 f4 e2 ff ff       	call   801261 <sys_page_unmap>
  802f6d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802f70:	83 ec 08             	sub    $0x8,%esp
  802f73:	ff 75 f4             	pushl  -0xc(%ebp)
  802f76:	6a 00                	push   $0x0
  802f78:	e8 e4 e2 ff ff       	call   801261 <sys_page_unmap>
  802f7d:	83 c4 10             	add    $0x10,%esp
}
  802f80:	89 d8                	mov    %ebx,%eax
  802f82:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f85:	5b                   	pop    %ebx
  802f86:	5e                   	pop    %esi
  802f87:	5d                   	pop    %ebp
  802f88:	c3                   	ret    

00802f89 <pipeisclosed>:
{
  802f89:	55                   	push   %ebp
  802f8a:	89 e5                	mov    %esp,%ebp
  802f8c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f8f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f92:	50                   	push   %eax
  802f93:	ff 75 08             	pushl  0x8(%ebp)
  802f96:	e8 9c ea ff ff       	call   801a37 <fd_lookup>
  802f9b:	83 c4 10             	add    $0x10,%esp
  802f9e:	85 c0                	test   %eax,%eax
  802fa0:	78 18                	js     802fba <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802fa2:	83 ec 0c             	sub    $0xc,%esp
  802fa5:	ff 75 f4             	pushl  -0xc(%ebp)
  802fa8:	e8 21 ea ff ff       	call   8019ce <fd2data>
	return _pipeisclosed(fd, p);
  802fad:	89 c2                	mov    %eax,%edx
  802faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb2:	e8 2f fd ff ff       	call   802ce6 <_pipeisclosed>
  802fb7:	83 c4 10             	add    $0x10,%esp
}
  802fba:	c9                   	leave  
  802fbb:	c3                   	ret    

00802fbc <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802fbc:	55                   	push   %ebp
  802fbd:	89 e5                	mov    %esp,%ebp
  802fbf:	56                   	push   %esi
  802fc0:	53                   	push   %ebx
  802fc1:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802fc4:	85 f6                	test   %esi,%esi
  802fc6:	74 16                	je     802fde <wait+0x22>
	e = &envs[ENVX(envid)];
  802fc8:	89 f3                	mov    %esi,%ebx
  802fca:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802fd0:	69 db 84 00 00 00    	imul   $0x84,%ebx,%ebx
  802fd6:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802fdc:	eb 1b                	jmp    802ff9 <wait+0x3d>
	assert(envid != 0);
  802fde:	68 be 3c 80 00       	push   $0x803cbe
  802fe3:	68 5b 3b 80 00       	push   $0x803b5b
  802fe8:	6a 09                	push   $0x9
  802fea:	68 c9 3c 80 00       	push   $0x803cc9
  802fef:	e8 a1 d5 ff ff       	call   800595 <_panic>
		sys_yield();
  802ff4:	e8 c4 e1 ff ff       	call   8011bd <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802ff9:	8b 43 48             	mov    0x48(%ebx),%eax
  802ffc:	39 f0                	cmp    %esi,%eax
  802ffe:	75 07                	jne    803007 <wait+0x4b>
  803000:	8b 43 54             	mov    0x54(%ebx),%eax
  803003:	85 c0                	test   %eax,%eax
  803005:	75 ed                	jne    802ff4 <wait+0x38>
}
  803007:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80300a:	5b                   	pop    %ebx
  80300b:	5e                   	pop    %esi
  80300c:	5d                   	pop    %ebp
  80300d:	c3                   	ret    

0080300e <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80300e:	55                   	push   %ebp
  80300f:	89 e5                	mov    %esp,%ebp
  803011:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  803014:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  80301b:	74 0a                	je     803027 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80301d:	8b 45 08             	mov    0x8(%ebp),%eax
  803020:	a3 00 80 80 00       	mov    %eax,0x808000
}
  803025:	c9                   	leave  
  803026:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  803027:	83 ec 04             	sub    $0x4,%esp
  80302a:	6a 07                	push   $0x7
  80302c:	68 00 f0 bf ee       	push   $0xeebff000
  803031:	6a 00                	push   $0x0
  803033:	e8 a4 e1 ff ff       	call   8011dc <sys_page_alloc>
		if(r < 0)
  803038:	83 c4 10             	add    $0x10,%esp
  80303b:	85 c0                	test   %eax,%eax
  80303d:	78 2a                	js     803069 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80303f:	83 ec 08             	sub    $0x8,%esp
  803042:	68 7d 30 80 00       	push   $0x80307d
  803047:	6a 00                	push   $0x0
  803049:	e8 d9 e2 ff ff       	call   801327 <sys_env_set_pgfault_upcall>
		if(r < 0)
  80304e:	83 c4 10             	add    $0x10,%esp
  803051:	85 c0                	test   %eax,%eax
  803053:	79 c8                	jns    80301d <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  803055:	83 ec 04             	sub    $0x4,%esp
  803058:	68 04 3d 80 00       	push   $0x803d04
  80305d:	6a 25                	push   $0x25
  80305f:	68 40 3d 80 00       	push   $0x803d40
  803064:	e8 2c d5 ff ff       	call   800595 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  803069:	83 ec 04             	sub    $0x4,%esp
  80306c:	68 d4 3c 80 00       	push   $0x803cd4
  803071:	6a 22                	push   $0x22
  803073:	68 40 3d 80 00       	push   $0x803d40
  803078:	e8 18 d5 ff ff       	call   800595 <_panic>

0080307d <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80307d:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80307e:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  803083:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  803085:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  803088:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  80308c:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  803090:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  803093:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  803095:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  803099:	83 c4 08             	add    $0x8,%esp
	popal
  80309c:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80309d:	83 c4 04             	add    $0x4,%esp
	popfl
  8030a0:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8030a1:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8030a2:	c3                   	ret    

008030a3 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8030a3:	55                   	push   %ebp
  8030a4:	89 e5                	mov    %esp,%ebp
  8030a6:	56                   	push   %esi
  8030a7:	53                   	push   %ebx
  8030a8:	8b 75 08             	mov    0x8(%ebp),%esi
  8030ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8030b1:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8030b3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8030b8:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8030bb:	83 ec 0c             	sub    $0xc,%esp
  8030be:	50                   	push   %eax
  8030bf:	e8 c8 e2 ff ff       	call   80138c <sys_ipc_recv>
	if(ret < 0){
  8030c4:	83 c4 10             	add    $0x10,%esp
  8030c7:	85 c0                	test   %eax,%eax
  8030c9:	78 2b                	js     8030f6 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8030cb:	85 f6                	test   %esi,%esi
  8030cd:	74 0a                	je     8030d9 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8030cf:	a1 08 50 80 00       	mov    0x805008,%eax
  8030d4:	8b 40 78             	mov    0x78(%eax),%eax
  8030d7:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8030d9:	85 db                	test   %ebx,%ebx
  8030db:	74 0a                	je     8030e7 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8030dd:	a1 08 50 80 00       	mov    0x805008,%eax
  8030e2:	8b 40 7c             	mov    0x7c(%eax),%eax
  8030e5:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8030e7:	a1 08 50 80 00       	mov    0x805008,%eax
  8030ec:	8b 40 74             	mov    0x74(%eax),%eax
}
  8030ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8030f2:	5b                   	pop    %ebx
  8030f3:	5e                   	pop    %esi
  8030f4:	5d                   	pop    %ebp
  8030f5:	c3                   	ret    
		if(from_env_store)
  8030f6:	85 f6                	test   %esi,%esi
  8030f8:	74 06                	je     803100 <ipc_recv+0x5d>
			*from_env_store = 0;
  8030fa:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  803100:	85 db                	test   %ebx,%ebx
  803102:	74 eb                	je     8030ef <ipc_recv+0x4c>
			*perm_store = 0;
  803104:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80310a:	eb e3                	jmp    8030ef <ipc_recv+0x4c>

0080310c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80310c:	55                   	push   %ebp
  80310d:	89 e5                	mov    %esp,%ebp
  80310f:	57                   	push   %edi
  803110:	56                   	push   %esi
  803111:	53                   	push   %ebx
  803112:	83 ec 0c             	sub    $0xc,%esp
  803115:	8b 7d 08             	mov    0x8(%ebp),%edi
  803118:	8b 75 0c             	mov    0xc(%ebp),%esi
  80311b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80311e:	85 db                	test   %ebx,%ebx
  803120:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  803125:	0f 44 d8             	cmove  %eax,%ebx
  803128:	eb 05                	jmp    80312f <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80312a:	e8 8e e0 ff ff       	call   8011bd <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80312f:	ff 75 14             	pushl  0x14(%ebp)
  803132:	53                   	push   %ebx
  803133:	56                   	push   %esi
  803134:	57                   	push   %edi
  803135:	e8 2f e2 ff ff       	call   801369 <sys_ipc_try_send>
  80313a:	83 c4 10             	add    $0x10,%esp
  80313d:	85 c0                	test   %eax,%eax
  80313f:	74 1b                	je     80315c <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  803141:	79 e7                	jns    80312a <ipc_send+0x1e>
  803143:	83 f8 f9             	cmp    $0xfffffff9,%eax
  803146:	74 e2                	je     80312a <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  803148:	83 ec 04             	sub    $0x4,%esp
  80314b:	68 4e 3d 80 00       	push   $0x803d4e
  803150:	6a 46                	push   $0x46
  803152:	68 63 3d 80 00       	push   $0x803d63
  803157:	e8 39 d4 ff ff       	call   800595 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80315c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80315f:	5b                   	pop    %ebx
  803160:	5e                   	pop    %esi
  803161:	5f                   	pop    %edi
  803162:	5d                   	pop    %ebp
  803163:	c3                   	ret    

00803164 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803164:	55                   	push   %ebp
  803165:	89 e5                	mov    %esp,%ebp
  803167:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80316a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80316f:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  803175:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80317b:	8b 52 50             	mov    0x50(%edx),%edx
  80317e:	39 ca                	cmp    %ecx,%edx
  803180:	74 11                	je     803193 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  803182:	83 c0 01             	add    $0x1,%eax
  803185:	3d 00 04 00 00       	cmp    $0x400,%eax
  80318a:	75 e3                	jne    80316f <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80318c:	b8 00 00 00 00       	mov    $0x0,%eax
  803191:	eb 0e                	jmp    8031a1 <ipc_find_env+0x3d>
			return envs[i].env_id;
  803193:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  803199:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80319e:	8b 40 48             	mov    0x48(%eax),%eax
}
  8031a1:	5d                   	pop    %ebp
  8031a2:	c3                   	ret    

008031a3 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8031a3:	55                   	push   %ebp
  8031a4:	89 e5                	mov    %esp,%ebp
  8031a6:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8031a9:	89 d0                	mov    %edx,%eax
  8031ab:	c1 e8 16             	shr    $0x16,%eax
  8031ae:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8031b5:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8031ba:	f6 c1 01             	test   $0x1,%cl
  8031bd:	74 1d                	je     8031dc <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8031bf:	c1 ea 0c             	shr    $0xc,%edx
  8031c2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8031c9:	f6 c2 01             	test   $0x1,%dl
  8031cc:	74 0e                	je     8031dc <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8031ce:	c1 ea 0c             	shr    $0xc,%edx
  8031d1:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8031d8:	ef 
  8031d9:	0f b7 c0             	movzwl %ax,%eax
}
  8031dc:	5d                   	pop    %ebp
  8031dd:	c3                   	ret    
  8031de:	66 90                	xchg   %ax,%ax

008031e0 <__udivdi3>:
  8031e0:	55                   	push   %ebp
  8031e1:	57                   	push   %edi
  8031e2:	56                   	push   %esi
  8031e3:	53                   	push   %ebx
  8031e4:	83 ec 1c             	sub    $0x1c,%esp
  8031e7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8031eb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8031ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8031f3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8031f7:	85 d2                	test   %edx,%edx
  8031f9:	75 4d                	jne    803248 <__udivdi3+0x68>
  8031fb:	39 f3                	cmp    %esi,%ebx
  8031fd:	76 19                	jbe    803218 <__udivdi3+0x38>
  8031ff:	31 ff                	xor    %edi,%edi
  803201:	89 e8                	mov    %ebp,%eax
  803203:	89 f2                	mov    %esi,%edx
  803205:	f7 f3                	div    %ebx
  803207:	89 fa                	mov    %edi,%edx
  803209:	83 c4 1c             	add    $0x1c,%esp
  80320c:	5b                   	pop    %ebx
  80320d:	5e                   	pop    %esi
  80320e:	5f                   	pop    %edi
  80320f:	5d                   	pop    %ebp
  803210:	c3                   	ret    
  803211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803218:	89 d9                	mov    %ebx,%ecx
  80321a:	85 db                	test   %ebx,%ebx
  80321c:	75 0b                	jne    803229 <__udivdi3+0x49>
  80321e:	b8 01 00 00 00       	mov    $0x1,%eax
  803223:	31 d2                	xor    %edx,%edx
  803225:	f7 f3                	div    %ebx
  803227:	89 c1                	mov    %eax,%ecx
  803229:	31 d2                	xor    %edx,%edx
  80322b:	89 f0                	mov    %esi,%eax
  80322d:	f7 f1                	div    %ecx
  80322f:	89 c6                	mov    %eax,%esi
  803231:	89 e8                	mov    %ebp,%eax
  803233:	89 f7                	mov    %esi,%edi
  803235:	f7 f1                	div    %ecx
  803237:	89 fa                	mov    %edi,%edx
  803239:	83 c4 1c             	add    $0x1c,%esp
  80323c:	5b                   	pop    %ebx
  80323d:	5e                   	pop    %esi
  80323e:	5f                   	pop    %edi
  80323f:	5d                   	pop    %ebp
  803240:	c3                   	ret    
  803241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803248:	39 f2                	cmp    %esi,%edx
  80324a:	77 1c                	ja     803268 <__udivdi3+0x88>
  80324c:	0f bd fa             	bsr    %edx,%edi
  80324f:	83 f7 1f             	xor    $0x1f,%edi
  803252:	75 2c                	jne    803280 <__udivdi3+0xa0>
  803254:	39 f2                	cmp    %esi,%edx
  803256:	72 06                	jb     80325e <__udivdi3+0x7e>
  803258:	31 c0                	xor    %eax,%eax
  80325a:	39 eb                	cmp    %ebp,%ebx
  80325c:	77 a9                	ja     803207 <__udivdi3+0x27>
  80325e:	b8 01 00 00 00       	mov    $0x1,%eax
  803263:	eb a2                	jmp    803207 <__udivdi3+0x27>
  803265:	8d 76 00             	lea    0x0(%esi),%esi
  803268:	31 ff                	xor    %edi,%edi
  80326a:	31 c0                	xor    %eax,%eax
  80326c:	89 fa                	mov    %edi,%edx
  80326e:	83 c4 1c             	add    $0x1c,%esp
  803271:	5b                   	pop    %ebx
  803272:	5e                   	pop    %esi
  803273:	5f                   	pop    %edi
  803274:	5d                   	pop    %ebp
  803275:	c3                   	ret    
  803276:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80327d:	8d 76 00             	lea    0x0(%esi),%esi
  803280:	89 f9                	mov    %edi,%ecx
  803282:	b8 20 00 00 00       	mov    $0x20,%eax
  803287:	29 f8                	sub    %edi,%eax
  803289:	d3 e2                	shl    %cl,%edx
  80328b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80328f:	89 c1                	mov    %eax,%ecx
  803291:	89 da                	mov    %ebx,%edx
  803293:	d3 ea                	shr    %cl,%edx
  803295:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803299:	09 d1                	or     %edx,%ecx
  80329b:	89 f2                	mov    %esi,%edx
  80329d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8032a1:	89 f9                	mov    %edi,%ecx
  8032a3:	d3 e3                	shl    %cl,%ebx
  8032a5:	89 c1                	mov    %eax,%ecx
  8032a7:	d3 ea                	shr    %cl,%edx
  8032a9:	89 f9                	mov    %edi,%ecx
  8032ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8032af:	89 eb                	mov    %ebp,%ebx
  8032b1:	d3 e6                	shl    %cl,%esi
  8032b3:	89 c1                	mov    %eax,%ecx
  8032b5:	d3 eb                	shr    %cl,%ebx
  8032b7:	09 de                	or     %ebx,%esi
  8032b9:	89 f0                	mov    %esi,%eax
  8032bb:	f7 74 24 08          	divl   0x8(%esp)
  8032bf:	89 d6                	mov    %edx,%esi
  8032c1:	89 c3                	mov    %eax,%ebx
  8032c3:	f7 64 24 0c          	mull   0xc(%esp)
  8032c7:	39 d6                	cmp    %edx,%esi
  8032c9:	72 15                	jb     8032e0 <__udivdi3+0x100>
  8032cb:	89 f9                	mov    %edi,%ecx
  8032cd:	d3 e5                	shl    %cl,%ebp
  8032cf:	39 c5                	cmp    %eax,%ebp
  8032d1:	73 04                	jae    8032d7 <__udivdi3+0xf7>
  8032d3:	39 d6                	cmp    %edx,%esi
  8032d5:	74 09                	je     8032e0 <__udivdi3+0x100>
  8032d7:	89 d8                	mov    %ebx,%eax
  8032d9:	31 ff                	xor    %edi,%edi
  8032db:	e9 27 ff ff ff       	jmp    803207 <__udivdi3+0x27>
  8032e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8032e3:	31 ff                	xor    %edi,%edi
  8032e5:	e9 1d ff ff ff       	jmp    803207 <__udivdi3+0x27>
  8032ea:	66 90                	xchg   %ax,%ax
  8032ec:	66 90                	xchg   %ax,%ax
  8032ee:	66 90                	xchg   %ax,%ax

008032f0 <__umoddi3>:
  8032f0:	55                   	push   %ebp
  8032f1:	57                   	push   %edi
  8032f2:	56                   	push   %esi
  8032f3:	53                   	push   %ebx
  8032f4:	83 ec 1c             	sub    $0x1c,%esp
  8032f7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8032fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8032ff:	8b 74 24 30          	mov    0x30(%esp),%esi
  803303:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803307:	89 da                	mov    %ebx,%edx
  803309:	85 c0                	test   %eax,%eax
  80330b:	75 43                	jne    803350 <__umoddi3+0x60>
  80330d:	39 df                	cmp    %ebx,%edi
  80330f:	76 17                	jbe    803328 <__umoddi3+0x38>
  803311:	89 f0                	mov    %esi,%eax
  803313:	f7 f7                	div    %edi
  803315:	89 d0                	mov    %edx,%eax
  803317:	31 d2                	xor    %edx,%edx
  803319:	83 c4 1c             	add    $0x1c,%esp
  80331c:	5b                   	pop    %ebx
  80331d:	5e                   	pop    %esi
  80331e:	5f                   	pop    %edi
  80331f:	5d                   	pop    %ebp
  803320:	c3                   	ret    
  803321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803328:	89 fd                	mov    %edi,%ebp
  80332a:	85 ff                	test   %edi,%edi
  80332c:	75 0b                	jne    803339 <__umoddi3+0x49>
  80332e:	b8 01 00 00 00       	mov    $0x1,%eax
  803333:	31 d2                	xor    %edx,%edx
  803335:	f7 f7                	div    %edi
  803337:	89 c5                	mov    %eax,%ebp
  803339:	89 d8                	mov    %ebx,%eax
  80333b:	31 d2                	xor    %edx,%edx
  80333d:	f7 f5                	div    %ebp
  80333f:	89 f0                	mov    %esi,%eax
  803341:	f7 f5                	div    %ebp
  803343:	89 d0                	mov    %edx,%eax
  803345:	eb d0                	jmp    803317 <__umoddi3+0x27>
  803347:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80334e:	66 90                	xchg   %ax,%ax
  803350:	89 f1                	mov    %esi,%ecx
  803352:	39 d8                	cmp    %ebx,%eax
  803354:	76 0a                	jbe    803360 <__umoddi3+0x70>
  803356:	89 f0                	mov    %esi,%eax
  803358:	83 c4 1c             	add    $0x1c,%esp
  80335b:	5b                   	pop    %ebx
  80335c:	5e                   	pop    %esi
  80335d:	5f                   	pop    %edi
  80335e:	5d                   	pop    %ebp
  80335f:	c3                   	ret    
  803360:	0f bd e8             	bsr    %eax,%ebp
  803363:	83 f5 1f             	xor    $0x1f,%ebp
  803366:	75 20                	jne    803388 <__umoddi3+0x98>
  803368:	39 d8                	cmp    %ebx,%eax
  80336a:	0f 82 b0 00 00 00    	jb     803420 <__umoddi3+0x130>
  803370:	39 f7                	cmp    %esi,%edi
  803372:	0f 86 a8 00 00 00    	jbe    803420 <__umoddi3+0x130>
  803378:	89 c8                	mov    %ecx,%eax
  80337a:	83 c4 1c             	add    $0x1c,%esp
  80337d:	5b                   	pop    %ebx
  80337e:	5e                   	pop    %esi
  80337f:	5f                   	pop    %edi
  803380:	5d                   	pop    %ebp
  803381:	c3                   	ret    
  803382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803388:	89 e9                	mov    %ebp,%ecx
  80338a:	ba 20 00 00 00       	mov    $0x20,%edx
  80338f:	29 ea                	sub    %ebp,%edx
  803391:	d3 e0                	shl    %cl,%eax
  803393:	89 44 24 08          	mov    %eax,0x8(%esp)
  803397:	89 d1                	mov    %edx,%ecx
  803399:	89 f8                	mov    %edi,%eax
  80339b:	d3 e8                	shr    %cl,%eax
  80339d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8033a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8033a5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8033a9:	09 c1                	or     %eax,%ecx
  8033ab:	89 d8                	mov    %ebx,%eax
  8033ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8033b1:	89 e9                	mov    %ebp,%ecx
  8033b3:	d3 e7                	shl    %cl,%edi
  8033b5:	89 d1                	mov    %edx,%ecx
  8033b7:	d3 e8                	shr    %cl,%eax
  8033b9:	89 e9                	mov    %ebp,%ecx
  8033bb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8033bf:	d3 e3                	shl    %cl,%ebx
  8033c1:	89 c7                	mov    %eax,%edi
  8033c3:	89 d1                	mov    %edx,%ecx
  8033c5:	89 f0                	mov    %esi,%eax
  8033c7:	d3 e8                	shr    %cl,%eax
  8033c9:	89 e9                	mov    %ebp,%ecx
  8033cb:	89 fa                	mov    %edi,%edx
  8033cd:	d3 e6                	shl    %cl,%esi
  8033cf:	09 d8                	or     %ebx,%eax
  8033d1:	f7 74 24 08          	divl   0x8(%esp)
  8033d5:	89 d1                	mov    %edx,%ecx
  8033d7:	89 f3                	mov    %esi,%ebx
  8033d9:	f7 64 24 0c          	mull   0xc(%esp)
  8033dd:	89 c6                	mov    %eax,%esi
  8033df:	89 d7                	mov    %edx,%edi
  8033e1:	39 d1                	cmp    %edx,%ecx
  8033e3:	72 06                	jb     8033eb <__umoddi3+0xfb>
  8033e5:	75 10                	jne    8033f7 <__umoddi3+0x107>
  8033e7:	39 c3                	cmp    %eax,%ebx
  8033e9:	73 0c                	jae    8033f7 <__umoddi3+0x107>
  8033eb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8033ef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8033f3:	89 d7                	mov    %edx,%edi
  8033f5:	89 c6                	mov    %eax,%esi
  8033f7:	89 ca                	mov    %ecx,%edx
  8033f9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8033fe:	29 f3                	sub    %esi,%ebx
  803400:	19 fa                	sbb    %edi,%edx
  803402:	89 d0                	mov    %edx,%eax
  803404:	d3 e0                	shl    %cl,%eax
  803406:	89 e9                	mov    %ebp,%ecx
  803408:	d3 eb                	shr    %cl,%ebx
  80340a:	d3 ea                	shr    %cl,%edx
  80340c:	09 d8                	or     %ebx,%eax
  80340e:	83 c4 1c             	add    $0x1c,%esp
  803411:	5b                   	pop    %ebx
  803412:	5e                   	pop    %esi
  803413:	5f                   	pop    %edi
  803414:	5d                   	pop    %ebp
  803415:	c3                   	ret    
  803416:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80341d:	8d 76 00             	lea    0x0(%esi),%esi
  803420:	89 da                	mov    %ebx,%edx
  803422:	29 fe                	sub    %edi,%esi
  803424:	19 c2                	sbb    %eax,%edx
  803426:	89 f1                	mov    %esi,%ecx
  803428:	89 c8                	mov    %ecx,%eax
  80342a:	e9 4b ff ff ff       	jmp    80337a <__umoddi3+0x8a>
