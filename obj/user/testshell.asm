
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
  80004a:	e8 41 1d 00 00       	call   801d90 <seek>
	seek(kfd, off);
  80004f:	83 c4 08             	add    $0x8,%esp
  800052:	53                   	push   %ebx
  800053:	57                   	push   %edi
  800054:	e8 37 1d 00 00       	call   801d90 <seek>

	cprintf("shell produced incorrect output.\n");
  800059:	c7 04 24 e0 33 80 00 	movl   $0x8033e0,(%esp)
  800060:	e8 d3 05 00 00       	call   800638 <cprintf>
	cprintf("expected:\n===\n");
  800065:	c7 04 24 4b 34 80 00 	movl   $0x80344b,(%esp)
  80006c:	e8 c7 05 00 00       	call   800638 <cprintf>
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800071:	83 c4 10             	add    $0x10,%esp
  800074:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  800077:	83 ec 04             	sub    $0x4,%esp
  80007a:	6a 63                	push   $0x63
  80007c:	53                   	push   %ebx
  80007d:	57                   	push   %edi
  80007e:	e8 bf 1b 00 00       	call   801c42 <read>
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
  80009c:	68 5a 34 80 00       	push   $0x80345a
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
  8000c2:	e8 7b 1b 00 00       	call   801c42 <read>
  8000c7:	83 c4 10             	add    $0x10,%esp
  8000ca:	85 c0                	test   %eax,%eax
  8000cc:	7f e0                	jg     8000ae <wrong+0x7b>
	cprintf("===\n");
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	68 55 34 80 00       	push   $0x803455
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
  8000f6:	e8 09 1a 00 00       	call   801b04 <close>
	close(1);
  8000fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800102:	e8 fd 19 00 00       	call   801b04 <close>
	opencons();
  800107:	e8 28 03 00 00       	call   800434 <opencons>
	opencons();
  80010c:	e8 23 03 00 00       	call   800434 <opencons>
	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  800111:	83 c4 08             	add    $0x8,%esp
  800114:	6a 00                	push   $0x0
  800116:	68 68 34 80 00       	push   $0x803468
  80011b:	e8 c0 1f 00 00       	call   8020e0 <open>
  800120:	89 c3                	mov    %eax,%ebx
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	85 c0                	test   %eax,%eax
  800127:	0f 88 e7 00 00 00    	js     800214 <umain+0x129>
	if ((wfd = pipe(pfds)) < 0)
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800133:	50                   	push   %eax
  800134:	e8 a0 2c 00 00       	call   802dd9 <pipe>
  800139:	83 c4 10             	add    $0x10,%esp
  80013c:	85 c0                	test   %eax,%eax
  80013e:	0f 88 e2 00 00 00    	js     800226 <umain+0x13b>
	wfd = pfds[1];
  800144:	8b 75 e0             	mov    -0x20(%ebp),%esi
	cprintf("running sh -x < testshell.sh | cat\n");
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	68 04 34 80 00       	push   $0x803404
  80014f:	e8 e4 04 00 00       	call   800638 <cprintf>
	if ((r = fork()) < 0)
  800154:	e8 6e 15 00 00       	call   8016c7 <fork>
  800159:	83 c4 10             	add    $0x10,%esp
  80015c:	85 c0                	test   %eax,%eax
  80015e:	0f 88 d4 00 00 00    	js     800238 <umain+0x14d>
	if (r == 0) {
  800164:	75 6f                	jne    8001d5 <umain+0xea>
		dup(rfd, 0);
  800166:	83 ec 08             	sub    $0x8,%esp
  800169:	6a 00                	push   $0x0
  80016b:	53                   	push   %ebx
  80016c:	e8 e5 19 00 00       	call   801b56 <dup>
		dup(wfd, 1);
  800171:	83 c4 08             	add    $0x8,%esp
  800174:	6a 01                	push   $0x1
  800176:	56                   	push   %esi
  800177:	e8 da 19 00 00       	call   801b56 <dup>
		close(rfd);
  80017c:	89 1c 24             	mov    %ebx,(%esp)
  80017f:	e8 80 19 00 00       	call   801b04 <close>
		close(wfd);
  800184:	89 34 24             	mov    %esi,(%esp)
  800187:	e8 78 19 00 00       	call   801b04 <close>
		if ((r = spawnl("/sh", "sh", "-x", 0)) < 0)
  80018c:	6a 00                	push   $0x0
  80018e:	68 ae 34 80 00       	push   $0x8034ae
  800193:	68 72 34 80 00       	push   $0x803472
  800198:	68 b1 34 80 00       	push   $0x8034b1
  80019d:	e8 70 25 00 00       	call   802712 <spawnl>
  8001a2:	89 c7                	mov    %eax,%edi
  8001a4:	83 c4 20             	add    $0x20,%esp
  8001a7:	85 c0                	test   %eax,%eax
  8001a9:	0f 88 9b 00 00 00    	js     80024a <umain+0x15f>
		close(0);
  8001af:	83 ec 0c             	sub    $0xc,%esp
  8001b2:	6a 00                	push   $0x0
  8001b4:	e8 4b 19 00 00       	call   801b04 <close>
		close(1);
  8001b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001c0:	e8 3f 19 00 00       	call   801b04 <close>
		wait(r);
  8001c5:	89 3c 24             	mov    %edi,(%esp)
  8001c8:	e8 89 2d 00 00       	call   802f56 <wait>
		exit();
  8001cd:	e8 56 03 00 00       	call   800528 <exit>
  8001d2:	83 c4 10             	add    $0x10,%esp
	close(rfd);
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	53                   	push   %ebx
  8001d9:	e8 26 19 00 00       	call   801b04 <close>
	close(wfd);
  8001de:	89 34 24             	mov    %esi,(%esp)
  8001e1:	e8 1e 19 00 00       	call   801b04 <close>
	rfd = pfds[0];
  8001e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001e9:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8001ec:	83 c4 08             	add    $0x8,%esp
  8001ef:	6a 00                	push   $0x0
  8001f1:	68 bf 34 80 00       	push   $0x8034bf
  8001f6:	e8 e5 1e 00 00       	call   8020e0 <open>
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
  800215:	68 75 34 80 00       	push   $0x803475
  80021a:	6a 13                	push   $0x13
  80021c:	68 8b 34 80 00       	push   $0x80348b
  800221:	e8 1c 03 00 00       	call   800542 <_panic>
		panic("pipe: %e", wfd);
  800226:	50                   	push   %eax
  800227:	68 9c 34 80 00       	push   $0x80349c
  80022c:	6a 15                	push   $0x15
  80022e:	68 8b 34 80 00       	push   $0x80348b
  800233:	e8 0a 03 00 00       	call   800542 <_panic>
		panic("fork: %e", r);
  800238:	50                   	push   %eax
  800239:	68 a5 34 80 00       	push   $0x8034a5
  80023e:	6a 1a                	push   $0x1a
  800240:	68 8b 34 80 00       	push   $0x80348b
  800245:	e8 f8 02 00 00       	call   800542 <_panic>
			panic("spawn: %e", r);
  80024a:	50                   	push   %eax
  80024b:	68 b5 34 80 00       	push   $0x8034b5
  800250:	6a 21                	push   $0x21
  800252:	68 8b 34 80 00       	push   $0x80348b
  800257:	e8 e6 02 00 00       	call   800542 <_panic>
		panic("open testshell.key for reading: %e", kfd);
  80025c:	50                   	push   %eax
  80025d:	68 28 34 80 00       	push   $0x803428
  800262:	6a 2c                	push   $0x2c
  800264:	68 8b 34 80 00       	push   $0x80348b
  800269:	e8 d4 02 00 00       	call   800542 <_panic>
			panic("reading testshell.out: %e", n1);
  80026e:	53                   	push   %ebx
  80026f:	68 cd 34 80 00       	push   $0x8034cd
  800274:	6a 33                	push   $0x33
  800276:	68 8b 34 80 00       	push   $0x80348b
  80027b:	e8 c2 02 00 00       	call   800542 <_panic>
			panic("reading testshell.key: %e", n2);
  800280:	50                   	push   %eax
  800281:	68 e7 34 80 00       	push   $0x8034e7
  800286:	6a 35                	push   $0x35
  800288:	68 8b 34 80 00       	push   $0x80348b
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
  8002ba:	e8 83 19 00 00       	call   801c42 <read>
  8002bf:	89 c3                	mov    %eax,%ebx
		n2 = read(kfd, &c2, 1);
  8002c1:	83 c4 0c             	add    $0xc,%esp
  8002c4:	6a 01                	push   $0x1
  8002c6:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  8002c9:	50                   	push   %eax
  8002ca:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002cd:	e8 70 19 00 00       	call   801c42 <read>
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
  8002fb:	68 01 35 80 00       	push   $0x803501
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
  80031d:	68 16 35 80 00       	push   $0x803516
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
  8003ed:	e8 50 18 00 00       	call   801c42 <read>
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
  800415:	e8 b8 15 00 00       	call   8019d2 <fd_lookup>
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
  80043e:	e8 3d 15 00 00       	call   801980 <fd_alloc>
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
  80047c:	e8 d8 14 00 00       	call   801959 <fd2num>
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

	cprintf("call umain!\n");
  8004fd:	83 ec 0c             	sub    $0xc,%esp
  800500:	68 22 35 80 00       	push   $0x803522
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
  80052e:	e8 fe 15 00 00       	call   801b31 <close_all>
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
  800552:	68 68 35 80 00       	push   $0x803568
  800557:	50                   	push   %eax
  800558:	68 39 35 80 00       	push   $0x803539
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
  80057b:	68 44 35 80 00       	push   $0x803544
  800580:	e8 b3 00 00 00       	call   800638 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800585:	83 c4 18             	add    $0x18,%esp
  800588:	53                   	push   %ebx
  800589:	ff 75 10             	pushl  0x10(%ebp)
  80058c:	e8 56 00 00 00       	call   8005e7 <vcprintf>
	cprintf("\n");
  800591:	c7 04 24 2d 35 80 00 	movl   $0x80352d,(%esp)
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
  8006e5:	e8 96 2a 00 00       	call   803180 <__udivdi3>
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
  80070e:	e8 7d 2b 00 00       	call   803290 <__umoddi3>
  800713:	83 c4 14             	add    $0x14,%esp
  800716:	0f be 80 6f 35 80 00 	movsbl 0x80356f(%eax),%eax
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
  800896:	68 b1 3a 80 00       	push   $0x803ab1
  80089b:	53                   	push   %ebx
  80089c:	56                   	push   %esi
  80089d:	e8 a6 fe ff ff       	call   800748 <printfmt>
  8008a2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8008a5:	89 7d 14             	mov    %edi,0x14(%ebp)
  8008a8:	e9 fe 02 00 00       	jmp    800bab <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8008ad:	50                   	push   %eax
  8008ae:	68 87 35 80 00       	push   $0x803587
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
  8008d5:	b8 80 35 80 00       	mov    $0x803580,%eax
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
  800c6d:	bf a5 36 80 00       	mov    $0x8036a5,%edi
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
  800c99:	bf dd 36 80 00       	mov    $0x8036dd,%edi
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

0080145e <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80145e:	55                   	push   %ebp
  80145f:	89 e5                	mov    %esp,%ebp
  801461:	53                   	push   %ebx
  801462:	83 ec 04             	sub    $0x4,%esp
  801465:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801468:	8b 02                	mov    (%edx),%eax
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80146a:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  80146e:	0f 84 99 00 00 00    	je     80150d <pgfault+0xaf>
  801474:	89 c2                	mov    %eax,%edx
  801476:	c1 ea 16             	shr    $0x16,%edx
  801479:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801480:	f6 c2 01             	test   $0x1,%dl
  801483:	0f 84 84 00 00 00    	je     80150d <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801489:	89 c2                	mov    %eax,%edx
  80148b:	c1 ea 0c             	shr    $0xc,%edx
  80148e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801495:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80149b:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8014a1:	75 6a                	jne    80150d <pgfault+0xaf>
	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	addr = ROUNDDOWN(addr, PGSIZE);
  8014a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014a8:	89 c3                	mov    %eax,%ebx
	int ret;
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8014aa:	83 ec 04             	sub    $0x4,%esp
  8014ad:	6a 07                	push   $0x7
  8014af:	68 00 f0 7f 00       	push   $0x7ff000
  8014b4:	6a 00                	push   $0x0
  8014b6:	e8 ce fc ff ff       	call   801189 <sys_page_alloc>
	if(ret < 0)
  8014bb:	83 c4 10             	add    $0x10,%esp
  8014be:	85 c0                	test   %eax,%eax
  8014c0:	78 5f                	js     801521 <pgfault+0xc3>
		panic("panic in sys_page_alloc()\n");
	
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8014c2:	83 ec 04             	sub    $0x4,%esp
  8014c5:	68 00 10 00 00       	push   $0x1000
  8014ca:	53                   	push   %ebx
  8014cb:	68 00 f0 7f 00       	push   $0x7ff000
  8014d0:	e8 b2 fa ff ff       	call   800f87 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8014d5:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8014dc:	53                   	push   %ebx
  8014dd:	6a 00                	push   $0x0
  8014df:	68 00 f0 7f 00       	push   $0x7ff000
  8014e4:	6a 00                	push   $0x0
  8014e6:	e8 e1 fc ff ff       	call   8011cc <sys_page_map>
	if(ret < 0)
  8014eb:	83 c4 20             	add    $0x20,%esp
  8014ee:	85 c0                	test   %eax,%eax
  8014f0:	78 43                	js     801535 <pgfault+0xd7>
		panic("panic in sys_page_map()\n");
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8014f2:	83 ec 08             	sub    $0x8,%esp
  8014f5:	68 00 f0 7f 00       	push   $0x7ff000
  8014fa:	6a 00                	push   $0x0
  8014fc:	e8 0d fd ff ff       	call   80120e <sys_page_unmap>
	if(ret < 0)
  801501:	83 c4 10             	add    $0x10,%esp
  801504:	85 c0                	test   %eax,%eax
  801506:	78 41                	js     801549 <pgfault+0xeb>
		panic("panic in sys_page_unmap()\n");
	// LAB 4: Your code here.

	// panic("pgfault not implemented");

}
  801508:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80150b:	c9                   	leave  
  80150c:	c3                   	ret    
		panic("panic at pgfault()\n");
  80150d:	83 ec 04             	sub    $0x4,%esp
  801510:	68 0f 39 80 00       	push   $0x80390f
  801515:	6a 26                	push   $0x26
  801517:	68 23 39 80 00       	push   $0x803923
  80151c:	e8 21 f0 ff ff       	call   800542 <_panic>
		panic("panic in sys_page_alloc()\n");
  801521:	83 ec 04             	sub    $0x4,%esp
  801524:	68 2e 39 80 00       	push   $0x80392e
  801529:	6a 31                	push   $0x31
  80152b:	68 23 39 80 00       	push   $0x803923
  801530:	e8 0d f0 ff ff       	call   800542 <_panic>
		panic("panic in sys_page_map()\n");
  801535:	83 ec 04             	sub    $0x4,%esp
  801538:	68 49 39 80 00       	push   $0x803949
  80153d:	6a 36                	push   $0x36
  80153f:	68 23 39 80 00       	push   $0x803923
  801544:	e8 f9 ef ff ff       	call   800542 <_panic>
		panic("panic in sys_page_unmap()\n");
  801549:	83 ec 04             	sub    $0x4,%esp
  80154c:	68 62 39 80 00       	push   $0x803962
  801551:	6a 39                	push   $0x39
  801553:	68 23 39 80 00       	push   $0x803923
  801558:	e8 e5 ef ff ff       	call   800542 <_panic>

0080155d <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80155d:	55                   	push   %ebp
  80155e:	89 e5                	mov    %esp,%ebp
  801560:	56                   	push   %esi
  801561:	53                   	push   %ebx
  801562:	89 c6                	mov    %eax,%esi
  801564:	89 d3                	mov    %edx,%ebx
	cprintf("in %s\n", __FUNCTION__);
  801566:	83 ec 08             	sub    $0x8,%esp
  801569:	68 00 3a 80 00       	push   $0x803a00
  80156e:	68 3d 35 80 00       	push   $0x80353d
  801573:	e8 c0 f0 ff ff       	call   800638 <cprintf>
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801578:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80157f:	83 c4 10             	add    $0x10,%esp
  801582:	f6 c4 04             	test   $0x4,%ah
  801585:	75 45                	jne    8015cc <duppage+0x6f>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801587:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80158e:	83 e0 07             	and    $0x7,%eax
  801591:	83 f8 07             	cmp    $0x7,%eax
  801594:	74 6e                	je     801604 <duppage+0xa7>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801596:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80159d:	25 05 08 00 00       	and    $0x805,%eax
  8015a2:	3d 05 08 00 00       	cmp    $0x805,%eax
  8015a7:	0f 84 b5 00 00 00    	je     801662 <duppage+0x105>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8015ad:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8015b4:	83 e0 05             	and    $0x5,%eax
  8015b7:	83 f8 05             	cmp    $0x5,%eax
  8015ba:	0f 84 d6 00 00 00    	je     801696 <duppage+0x139>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8015c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015c8:	5b                   	pop    %ebx
  8015c9:	5e                   	pop    %esi
  8015ca:	5d                   	pop    %ebp
  8015cb:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  8015cc:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8015d3:	c1 e3 0c             	shl    $0xc,%ebx
  8015d6:	83 ec 0c             	sub    $0xc,%esp
  8015d9:	25 07 0e 00 00       	and    $0xe07,%eax
  8015de:	50                   	push   %eax
  8015df:	53                   	push   %ebx
  8015e0:	56                   	push   %esi
  8015e1:	53                   	push   %ebx
  8015e2:	6a 00                	push   $0x0
  8015e4:	e8 e3 fb ff ff       	call   8011cc <sys_page_map>
		if(r < 0)
  8015e9:	83 c4 20             	add    $0x20,%esp
  8015ec:	85 c0                	test   %eax,%eax
  8015ee:	79 d0                	jns    8015c0 <duppage+0x63>
			panic("sys_page_map() panic\n");
  8015f0:	83 ec 04             	sub    $0x4,%esp
  8015f3:	68 7d 39 80 00       	push   $0x80397d
  8015f8:	6a 55                	push   $0x55
  8015fa:	68 23 39 80 00       	push   $0x803923
  8015ff:	e8 3e ef ff ff       	call   800542 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801604:	c1 e3 0c             	shl    $0xc,%ebx
  801607:	83 ec 0c             	sub    $0xc,%esp
  80160a:	68 05 08 00 00       	push   $0x805
  80160f:	53                   	push   %ebx
  801610:	56                   	push   %esi
  801611:	53                   	push   %ebx
  801612:	6a 00                	push   $0x0
  801614:	e8 b3 fb ff ff       	call   8011cc <sys_page_map>
		if(r < 0)
  801619:	83 c4 20             	add    $0x20,%esp
  80161c:	85 c0                	test   %eax,%eax
  80161e:	78 2e                	js     80164e <duppage+0xf1>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801620:	83 ec 0c             	sub    $0xc,%esp
  801623:	68 05 08 00 00       	push   $0x805
  801628:	53                   	push   %ebx
  801629:	6a 00                	push   $0x0
  80162b:	53                   	push   %ebx
  80162c:	6a 00                	push   $0x0
  80162e:	e8 99 fb ff ff       	call   8011cc <sys_page_map>
		if(r < 0)
  801633:	83 c4 20             	add    $0x20,%esp
  801636:	85 c0                	test   %eax,%eax
  801638:	79 86                	jns    8015c0 <duppage+0x63>
			panic("sys_page_map() panic\n");
  80163a:	83 ec 04             	sub    $0x4,%esp
  80163d:	68 7d 39 80 00       	push   $0x80397d
  801642:	6a 60                	push   $0x60
  801644:	68 23 39 80 00       	push   $0x803923
  801649:	e8 f4 ee ff ff       	call   800542 <_panic>
			panic("sys_page_map() panic\n");
  80164e:	83 ec 04             	sub    $0x4,%esp
  801651:	68 7d 39 80 00       	push   $0x80397d
  801656:	6a 5c                	push   $0x5c
  801658:	68 23 39 80 00       	push   $0x803923
  80165d:	e8 e0 ee ff ff       	call   800542 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801662:	c1 e3 0c             	shl    $0xc,%ebx
  801665:	83 ec 0c             	sub    $0xc,%esp
  801668:	68 05 08 00 00       	push   $0x805
  80166d:	53                   	push   %ebx
  80166e:	56                   	push   %esi
  80166f:	53                   	push   %ebx
  801670:	6a 00                	push   $0x0
  801672:	e8 55 fb ff ff       	call   8011cc <sys_page_map>
		if(r < 0)
  801677:	83 c4 20             	add    $0x20,%esp
  80167a:	85 c0                	test   %eax,%eax
  80167c:	0f 89 3e ff ff ff    	jns    8015c0 <duppage+0x63>
			panic("sys_page_map() panic\n");
  801682:	83 ec 04             	sub    $0x4,%esp
  801685:	68 7d 39 80 00       	push   $0x80397d
  80168a:	6a 67                	push   $0x67
  80168c:	68 23 39 80 00       	push   $0x803923
  801691:	e8 ac ee ff ff       	call   800542 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801696:	c1 e3 0c             	shl    $0xc,%ebx
  801699:	83 ec 0c             	sub    $0xc,%esp
  80169c:	6a 05                	push   $0x5
  80169e:	53                   	push   %ebx
  80169f:	56                   	push   %esi
  8016a0:	53                   	push   %ebx
  8016a1:	6a 00                	push   $0x0
  8016a3:	e8 24 fb ff ff       	call   8011cc <sys_page_map>
		if(r < 0)
  8016a8:	83 c4 20             	add    $0x20,%esp
  8016ab:	85 c0                	test   %eax,%eax
  8016ad:	0f 89 0d ff ff ff    	jns    8015c0 <duppage+0x63>
			panic("sys_page_map() panic\n");
  8016b3:	83 ec 04             	sub    $0x4,%esp
  8016b6:	68 7d 39 80 00       	push   $0x80397d
  8016bb:	6a 6e                	push   $0x6e
  8016bd:	68 23 39 80 00       	push   $0x803923
  8016c2:	e8 7b ee ff ff       	call   800542 <_panic>

008016c7 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
  8016ca:	57                   	push   %edi
  8016cb:	56                   	push   %esi
  8016cc:	53                   	push   %ebx
  8016cd:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  8016d0:	68 5e 14 80 00       	push   $0x80145e
  8016d5:	e8 cb 18 00 00       	call   802fa5 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8016da:	b8 07 00 00 00       	mov    $0x7,%eax
  8016df:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8016e1:	83 c4 10             	add    $0x10,%esp
  8016e4:	85 c0                	test   %eax,%eax
  8016e6:	78 27                	js     80170f <fork+0x48>
  8016e8:	89 c6                	mov    %eax,%esi
  8016ea:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8016ec:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8016f1:	75 48                	jne    80173b <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  8016f3:	e8 53 fa ff ff       	call   80114b <sys_getenvid>
  8016f8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8016fd:	c1 e0 07             	shl    $0x7,%eax
  801700:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801705:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  80170a:	e9 90 00 00 00       	jmp    80179f <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  80170f:	83 ec 04             	sub    $0x4,%esp
  801712:	68 94 39 80 00       	push   $0x803994
  801717:	68 8d 00 00 00       	push   $0x8d
  80171c:	68 23 39 80 00       	push   $0x803923
  801721:	e8 1c ee ff ff       	call   800542 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801726:	89 f8                	mov    %edi,%eax
  801728:	e8 30 fe ff ff       	call   80155d <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80172d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801733:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801739:	74 26                	je     801761 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  80173b:	89 d8                	mov    %ebx,%eax
  80173d:	c1 e8 16             	shr    $0x16,%eax
  801740:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801747:	a8 01                	test   $0x1,%al
  801749:	74 e2                	je     80172d <fork+0x66>
  80174b:	89 da                	mov    %ebx,%edx
  80174d:	c1 ea 0c             	shr    $0xc,%edx
  801750:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801757:	83 e0 05             	and    $0x5,%eax
  80175a:	83 f8 05             	cmp    $0x5,%eax
  80175d:	75 ce                	jne    80172d <fork+0x66>
  80175f:	eb c5                	jmp    801726 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801761:	83 ec 04             	sub    $0x4,%esp
  801764:	6a 07                	push   $0x7
  801766:	68 00 f0 bf ee       	push   $0xeebff000
  80176b:	56                   	push   %esi
  80176c:	e8 18 fa ff ff       	call   801189 <sys_page_alloc>
	if(ret < 0)
  801771:	83 c4 10             	add    $0x10,%esp
  801774:	85 c0                	test   %eax,%eax
  801776:	78 31                	js     8017a9 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801778:	83 ec 08             	sub    $0x8,%esp
  80177b:	68 14 30 80 00       	push   $0x803014
  801780:	56                   	push   %esi
  801781:	e8 4e fb ff ff       	call   8012d4 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801786:	83 c4 10             	add    $0x10,%esp
  801789:	85 c0                	test   %eax,%eax
  80178b:	78 33                	js     8017c0 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80178d:	83 ec 08             	sub    $0x8,%esp
  801790:	6a 02                	push   $0x2
  801792:	56                   	push   %esi
  801793:	e8 b8 fa ff ff       	call   801250 <sys_env_set_status>
	if(ret < 0)
  801798:	83 c4 10             	add    $0x10,%esp
  80179b:	85 c0                	test   %eax,%eax
  80179d:	78 38                	js     8017d7 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  80179f:	89 f0                	mov    %esi,%eax
  8017a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017a4:	5b                   	pop    %ebx
  8017a5:	5e                   	pop    %esi
  8017a6:	5f                   	pop    %edi
  8017a7:	5d                   	pop    %ebp
  8017a8:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8017a9:	83 ec 04             	sub    $0x4,%esp
  8017ac:	68 2e 39 80 00       	push   $0x80392e
  8017b1:	68 99 00 00 00       	push   $0x99
  8017b6:	68 23 39 80 00       	push   $0x803923
  8017bb:	e8 82 ed ff ff       	call   800542 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8017c0:	83 ec 04             	sub    $0x4,%esp
  8017c3:	68 b8 39 80 00       	push   $0x8039b8
  8017c8:	68 9c 00 00 00       	push   $0x9c
  8017cd:	68 23 39 80 00       	push   $0x803923
  8017d2:	e8 6b ed ff ff       	call   800542 <_panic>
		panic("panic in sys_env_set_status()\n");
  8017d7:	83 ec 04             	sub    $0x4,%esp
  8017da:	68 e0 39 80 00       	push   $0x8039e0
  8017df:	68 9f 00 00 00       	push   $0x9f
  8017e4:	68 23 39 80 00       	push   $0x803923
  8017e9:	e8 54 ed ff ff       	call   800542 <_panic>

008017ee <sfork>:

// Challenge!
int
sfork(void)
{
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
  8017f1:	57                   	push   %edi
  8017f2:	56                   	push   %esi
  8017f3:	53                   	push   %ebx
  8017f4:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8017f7:	68 5e 14 80 00       	push   $0x80145e
  8017fc:	e8 a4 17 00 00       	call   802fa5 <set_pgfault_handler>
  801801:	b8 07 00 00 00       	mov    $0x7,%eax
  801806:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801808:	83 c4 10             	add    $0x10,%esp
  80180b:	85 c0                	test   %eax,%eax
  80180d:	78 27                	js     801836 <sfork+0x48>
  80180f:	89 c7                	mov    %eax,%edi
  801811:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801813:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801818:	75 55                	jne    80186f <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  80181a:	e8 2c f9 ff ff       	call   80114b <sys_getenvid>
  80181f:	25 ff 03 00 00       	and    $0x3ff,%eax
  801824:	c1 e0 07             	shl    $0x7,%eax
  801827:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80182c:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801831:	e9 d4 00 00 00       	jmp    80190a <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  801836:	83 ec 04             	sub    $0x4,%esp
  801839:	68 94 39 80 00       	push   $0x803994
  80183e:	68 b0 00 00 00       	push   $0xb0
  801843:	68 23 39 80 00       	push   $0x803923
  801848:	e8 f5 ec ff ff       	call   800542 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  80184d:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801852:	89 f0                	mov    %esi,%eax
  801854:	e8 04 fd ff ff       	call   80155d <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801859:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80185f:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801865:	77 65                	ja     8018cc <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801867:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  80186d:	74 de                	je     80184d <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  80186f:	89 d8                	mov    %ebx,%eax
  801871:	c1 e8 16             	shr    $0x16,%eax
  801874:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80187b:	a8 01                	test   $0x1,%al
  80187d:	74 da                	je     801859 <sfork+0x6b>
  80187f:	89 da                	mov    %ebx,%edx
  801881:	c1 ea 0c             	shr    $0xc,%edx
  801884:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80188b:	83 e0 05             	and    $0x5,%eax
  80188e:	83 f8 05             	cmp    $0x5,%eax
  801891:	75 c6                	jne    801859 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801893:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  80189a:	c1 e2 0c             	shl    $0xc,%edx
  80189d:	83 ec 0c             	sub    $0xc,%esp
  8018a0:	83 e0 07             	and    $0x7,%eax
  8018a3:	50                   	push   %eax
  8018a4:	52                   	push   %edx
  8018a5:	56                   	push   %esi
  8018a6:	52                   	push   %edx
  8018a7:	6a 00                	push   $0x0
  8018a9:	e8 1e f9 ff ff       	call   8011cc <sys_page_map>
  8018ae:	83 c4 20             	add    $0x20,%esp
  8018b1:	85 c0                	test   %eax,%eax
  8018b3:	74 a4                	je     801859 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  8018b5:	83 ec 04             	sub    $0x4,%esp
  8018b8:	68 7d 39 80 00       	push   $0x80397d
  8018bd:	68 bb 00 00 00       	push   $0xbb
  8018c2:	68 23 39 80 00       	push   $0x803923
  8018c7:	e8 76 ec ff ff       	call   800542 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8018cc:	83 ec 04             	sub    $0x4,%esp
  8018cf:	6a 07                	push   $0x7
  8018d1:	68 00 f0 bf ee       	push   $0xeebff000
  8018d6:	57                   	push   %edi
  8018d7:	e8 ad f8 ff ff       	call   801189 <sys_page_alloc>
	if(ret < 0)
  8018dc:	83 c4 10             	add    $0x10,%esp
  8018df:	85 c0                	test   %eax,%eax
  8018e1:	78 31                	js     801914 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8018e3:	83 ec 08             	sub    $0x8,%esp
  8018e6:	68 14 30 80 00       	push   $0x803014
  8018eb:	57                   	push   %edi
  8018ec:	e8 e3 f9 ff ff       	call   8012d4 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8018f1:	83 c4 10             	add    $0x10,%esp
  8018f4:	85 c0                	test   %eax,%eax
  8018f6:	78 33                	js     80192b <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8018f8:	83 ec 08             	sub    $0x8,%esp
  8018fb:	6a 02                	push   $0x2
  8018fd:	57                   	push   %edi
  8018fe:	e8 4d f9 ff ff       	call   801250 <sys_env_set_status>
	if(ret < 0)
  801903:	83 c4 10             	add    $0x10,%esp
  801906:	85 c0                	test   %eax,%eax
  801908:	78 38                	js     801942 <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  80190a:	89 f8                	mov    %edi,%eax
  80190c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80190f:	5b                   	pop    %ebx
  801910:	5e                   	pop    %esi
  801911:	5f                   	pop    %edi
  801912:	5d                   	pop    %ebp
  801913:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801914:	83 ec 04             	sub    $0x4,%esp
  801917:	68 2e 39 80 00       	push   $0x80392e
  80191c:	68 c1 00 00 00       	push   $0xc1
  801921:	68 23 39 80 00       	push   $0x803923
  801926:	e8 17 ec ff ff       	call   800542 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80192b:	83 ec 04             	sub    $0x4,%esp
  80192e:	68 b8 39 80 00       	push   $0x8039b8
  801933:	68 c4 00 00 00       	push   $0xc4
  801938:	68 23 39 80 00       	push   $0x803923
  80193d:	e8 00 ec ff ff       	call   800542 <_panic>
		panic("panic in sys_env_set_status()\n");
  801942:	83 ec 04             	sub    $0x4,%esp
  801945:	68 e0 39 80 00       	push   $0x8039e0
  80194a:	68 c7 00 00 00       	push   $0xc7
  80194f:	68 23 39 80 00       	push   $0x803923
  801954:	e8 e9 eb ff ff       	call   800542 <_panic>

00801959 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80195c:	8b 45 08             	mov    0x8(%ebp),%eax
  80195f:	05 00 00 00 30       	add    $0x30000000,%eax
  801964:	c1 e8 0c             	shr    $0xc,%eax
}
  801967:	5d                   	pop    %ebp
  801968:	c3                   	ret    

00801969 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80196c:	8b 45 08             	mov    0x8(%ebp),%eax
  80196f:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801974:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801979:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80197e:	5d                   	pop    %ebp
  80197f:	c3                   	ret    

00801980 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
  801983:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801988:	89 c2                	mov    %eax,%edx
  80198a:	c1 ea 16             	shr    $0x16,%edx
  80198d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801994:	f6 c2 01             	test   $0x1,%dl
  801997:	74 2d                	je     8019c6 <fd_alloc+0x46>
  801999:	89 c2                	mov    %eax,%edx
  80199b:	c1 ea 0c             	shr    $0xc,%edx
  80199e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8019a5:	f6 c2 01             	test   $0x1,%dl
  8019a8:	74 1c                	je     8019c6 <fd_alloc+0x46>
  8019aa:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8019af:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8019b4:	75 d2                	jne    801988 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8019bf:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8019c4:	eb 0a                	jmp    8019d0 <fd_alloc+0x50>
			*fd_store = fd;
  8019c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019c9:	89 01                	mov    %eax,(%ecx)
			return 0;
  8019cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019d0:	5d                   	pop    %ebp
  8019d1:	c3                   	ret    

008019d2 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
  8019d5:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8019d8:	83 f8 1f             	cmp    $0x1f,%eax
  8019db:	77 30                	ja     801a0d <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8019dd:	c1 e0 0c             	shl    $0xc,%eax
  8019e0:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8019e5:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8019eb:	f6 c2 01             	test   $0x1,%dl
  8019ee:	74 24                	je     801a14 <fd_lookup+0x42>
  8019f0:	89 c2                	mov    %eax,%edx
  8019f2:	c1 ea 0c             	shr    $0xc,%edx
  8019f5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8019fc:	f6 c2 01             	test   $0x1,%dl
  8019ff:	74 1a                	je     801a1b <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801a01:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a04:	89 02                	mov    %eax,(%edx)
	return 0;
  801a06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a0b:	5d                   	pop    %ebp
  801a0c:	c3                   	ret    
		return -E_INVAL;
  801a0d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a12:	eb f7                	jmp    801a0b <fd_lookup+0x39>
		return -E_INVAL;
  801a14:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a19:	eb f0                	jmp    801a0b <fd_lookup+0x39>
  801a1b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a20:	eb e9                	jmp    801a0b <fd_lookup+0x39>

00801a22 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
  801a25:	83 ec 08             	sub    $0x8,%esp
  801a28:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801a2b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a30:	b8 20 40 80 00       	mov    $0x804020,%eax
		if (devtab[i]->dev_id == dev_id) {
  801a35:	39 08                	cmp    %ecx,(%eax)
  801a37:	74 38                	je     801a71 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801a39:	83 c2 01             	add    $0x1,%edx
  801a3c:	8b 04 95 84 3a 80 00 	mov    0x803a84(,%edx,4),%eax
  801a43:	85 c0                	test   %eax,%eax
  801a45:	75 ee                	jne    801a35 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801a47:	a1 08 50 80 00       	mov    0x805008,%eax
  801a4c:	8b 40 48             	mov    0x48(%eax),%eax
  801a4f:	83 ec 04             	sub    $0x4,%esp
  801a52:	51                   	push   %ecx
  801a53:	50                   	push   %eax
  801a54:	68 08 3a 80 00       	push   $0x803a08
  801a59:	e8 da eb ff ff       	call   800638 <cprintf>
	*dev = 0;
  801a5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a61:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801a67:	83 c4 10             	add    $0x10,%esp
  801a6a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    
			*dev = devtab[i];
  801a71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a74:	89 01                	mov    %eax,(%ecx)
			return 0;
  801a76:	b8 00 00 00 00       	mov    $0x0,%eax
  801a7b:	eb f2                	jmp    801a6f <dev_lookup+0x4d>

00801a7d <fd_close>:
{
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
  801a80:	57                   	push   %edi
  801a81:	56                   	push   %esi
  801a82:	53                   	push   %ebx
  801a83:	83 ec 24             	sub    $0x24,%esp
  801a86:	8b 75 08             	mov    0x8(%ebp),%esi
  801a89:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801a8c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801a8f:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801a90:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801a96:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801a99:	50                   	push   %eax
  801a9a:	e8 33 ff ff ff       	call   8019d2 <fd_lookup>
  801a9f:	89 c3                	mov    %eax,%ebx
  801aa1:	83 c4 10             	add    $0x10,%esp
  801aa4:	85 c0                	test   %eax,%eax
  801aa6:	78 05                	js     801aad <fd_close+0x30>
	    || fd != fd2)
  801aa8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801aab:	74 16                	je     801ac3 <fd_close+0x46>
		return (must_exist ? r : 0);
  801aad:	89 f8                	mov    %edi,%eax
  801aaf:	84 c0                	test   %al,%al
  801ab1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab6:	0f 44 d8             	cmove  %eax,%ebx
}
  801ab9:	89 d8                	mov    %ebx,%eax
  801abb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801abe:	5b                   	pop    %ebx
  801abf:	5e                   	pop    %esi
  801ac0:	5f                   	pop    %edi
  801ac1:	5d                   	pop    %ebp
  801ac2:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801ac3:	83 ec 08             	sub    $0x8,%esp
  801ac6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801ac9:	50                   	push   %eax
  801aca:	ff 36                	pushl  (%esi)
  801acc:	e8 51 ff ff ff       	call   801a22 <dev_lookup>
  801ad1:	89 c3                	mov    %eax,%ebx
  801ad3:	83 c4 10             	add    $0x10,%esp
  801ad6:	85 c0                	test   %eax,%eax
  801ad8:	78 1a                	js     801af4 <fd_close+0x77>
		if (dev->dev_close)
  801ada:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801add:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801ae0:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801ae5:	85 c0                	test   %eax,%eax
  801ae7:	74 0b                	je     801af4 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801ae9:	83 ec 0c             	sub    $0xc,%esp
  801aec:	56                   	push   %esi
  801aed:	ff d0                	call   *%eax
  801aef:	89 c3                	mov    %eax,%ebx
  801af1:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801af4:	83 ec 08             	sub    $0x8,%esp
  801af7:	56                   	push   %esi
  801af8:	6a 00                	push   $0x0
  801afa:	e8 0f f7 ff ff       	call   80120e <sys_page_unmap>
	return r;
  801aff:	83 c4 10             	add    $0x10,%esp
  801b02:	eb b5                	jmp    801ab9 <fd_close+0x3c>

00801b04 <close>:

int
close(int fdnum)
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
  801b07:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b0a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b0d:	50                   	push   %eax
  801b0e:	ff 75 08             	pushl  0x8(%ebp)
  801b11:	e8 bc fe ff ff       	call   8019d2 <fd_lookup>
  801b16:	83 c4 10             	add    $0x10,%esp
  801b19:	85 c0                	test   %eax,%eax
  801b1b:	79 02                	jns    801b1f <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    
		return fd_close(fd, 1);
  801b1f:	83 ec 08             	sub    $0x8,%esp
  801b22:	6a 01                	push   $0x1
  801b24:	ff 75 f4             	pushl  -0xc(%ebp)
  801b27:	e8 51 ff ff ff       	call   801a7d <fd_close>
  801b2c:	83 c4 10             	add    $0x10,%esp
  801b2f:	eb ec                	jmp    801b1d <close+0x19>

00801b31 <close_all>:

void
close_all(void)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
  801b34:	53                   	push   %ebx
  801b35:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801b38:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801b3d:	83 ec 0c             	sub    $0xc,%esp
  801b40:	53                   	push   %ebx
  801b41:	e8 be ff ff ff       	call   801b04 <close>
	for (i = 0; i < MAXFD; i++)
  801b46:	83 c3 01             	add    $0x1,%ebx
  801b49:	83 c4 10             	add    $0x10,%esp
  801b4c:	83 fb 20             	cmp    $0x20,%ebx
  801b4f:	75 ec                	jne    801b3d <close_all+0xc>
}
  801b51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b54:	c9                   	leave  
  801b55:	c3                   	ret    

00801b56 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
  801b59:	57                   	push   %edi
  801b5a:	56                   	push   %esi
  801b5b:	53                   	push   %ebx
  801b5c:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801b5f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801b62:	50                   	push   %eax
  801b63:	ff 75 08             	pushl  0x8(%ebp)
  801b66:	e8 67 fe ff ff       	call   8019d2 <fd_lookup>
  801b6b:	89 c3                	mov    %eax,%ebx
  801b6d:	83 c4 10             	add    $0x10,%esp
  801b70:	85 c0                	test   %eax,%eax
  801b72:	0f 88 81 00 00 00    	js     801bf9 <dup+0xa3>
		return r;
	close(newfdnum);
  801b78:	83 ec 0c             	sub    $0xc,%esp
  801b7b:	ff 75 0c             	pushl  0xc(%ebp)
  801b7e:	e8 81 ff ff ff       	call   801b04 <close>

	newfd = INDEX2FD(newfdnum);
  801b83:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b86:	c1 e6 0c             	shl    $0xc,%esi
  801b89:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801b8f:	83 c4 04             	add    $0x4,%esp
  801b92:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b95:	e8 cf fd ff ff       	call   801969 <fd2data>
  801b9a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801b9c:	89 34 24             	mov    %esi,(%esp)
  801b9f:	e8 c5 fd ff ff       	call   801969 <fd2data>
  801ba4:	83 c4 10             	add    $0x10,%esp
  801ba7:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801ba9:	89 d8                	mov    %ebx,%eax
  801bab:	c1 e8 16             	shr    $0x16,%eax
  801bae:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801bb5:	a8 01                	test   $0x1,%al
  801bb7:	74 11                	je     801bca <dup+0x74>
  801bb9:	89 d8                	mov    %ebx,%eax
  801bbb:	c1 e8 0c             	shr    $0xc,%eax
  801bbe:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801bc5:	f6 c2 01             	test   $0x1,%dl
  801bc8:	75 39                	jne    801c03 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801bca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801bcd:	89 d0                	mov    %edx,%eax
  801bcf:	c1 e8 0c             	shr    $0xc,%eax
  801bd2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801bd9:	83 ec 0c             	sub    $0xc,%esp
  801bdc:	25 07 0e 00 00       	and    $0xe07,%eax
  801be1:	50                   	push   %eax
  801be2:	56                   	push   %esi
  801be3:	6a 00                	push   $0x0
  801be5:	52                   	push   %edx
  801be6:	6a 00                	push   $0x0
  801be8:	e8 df f5 ff ff       	call   8011cc <sys_page_map>
  801bed:	89 c3                	mov    %eax,%ebx
  801bef:	83 c4 20             	add    $0x20,%esp
  801bf2:	85 c0                	test   %eax,%eax
  801bf4:	78 31                	js     801c27 <dup+0xd1>
		goto err;

	return newfdnum;
  801bf6:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801bf9:	89 d8                	mov    %ebx,%eax
  801bfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bfe:	5b                   	pop    %ebx
  801bff:	5e                   	pop    %esi
  801c00:	5f                   	pop    %edi
  801c01:	5d                   	pop    %ebp
  801c02:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801c03:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801c0a:	83 ec 0c             	sub    $0xc,%esp
  801c0d:	25 07 0e 00 00       	and    $0xe07,%eax
  801c12:	50                   	push   %eax
  801c13:	57                   	push   %edi
  801c14:	6a 00                	push   $0x0
  801c16:	53                   	push   %ebx
  801c17:	6a 00                	push   $0x0
  801c19:	e8 ae f5 ff ff       	call   8011cc <sys_page_map>
  801c1e:	89 c3                	mov    %eax,%ebx
  801c20:	83 c4 20             	add    $0x20,%esp
  801c23:	85 c0                	test   %eax,%eax
  801c25:	79 a3                	jns    801bca <dup+0x74>
	sys_page_unmap(0, newfd);
  801c27:	83 ec 08             	sub    $0x8,%esp
  801c2a:	56                   	push   %esi
  801c2b:	6a 00                	push   $0x0
  801c2d:	e8 dc f5 ff ff       	call   80120e <sys_page_unmap>
	sys_page_unmap(0, nva);
  801c32:	83 c4 08             	add    $0x8,%esp
  801c35:	57                   	push   %edi
  801c36:	6a 00                	push   $0x0
  801c38:	e8 d1 f5 ff ff       	call   80120e <sys_page_unmap>
	return r;
  801c3d:	83 c4 10             	add    $0x10,%esp
  801c40:	eb b7                	jmp    801bf9 <dup+0xa3>

00801c42 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
  801c45:	53                   	push   %ebx
  801c46:	83 ec 1c             	sub    $0x1c,%esp
  801c49:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c4c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c4f:	50                   	push   %eax
  801c50:	53                   	push   %ebx
  801c51:	e8 7c fd ff ff       	call   8019d2 <fd_lookup>
  801c56:	83 c4 10             	add    $0x10,%esp
  801c59:	85 c0                	test   %eax,%eax
  801c5b:	78 3f                	js     801c9c <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c5d:	83 ec 08             	sub    $0x8,%esp
  801c60:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c63:	50                   	push   %eax
  801c64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c67:	ff 30                	pushl  (%eax)
  801c69:	e8 b4 fd ff ff       	call   801a22 <dev_lookup>
  801c6e:	83 c4 10             	add    $0x10,%esp
  801c71:	85 c0                	test   %eax,%eax
  801c73:	78 27                	js     801c9c <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801c75:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c78:	8b 42 08             	mov    0x8(%edx),%eax
  801c7b:	83 e0 03             	and    $0x3,%eax
  801c7e:	83 f8 01             	cmp    $0x1,%eax
  801c81:	74 1e                	je     801ca1 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c86:	8b 40 08             	mov    0x8(%eax),%eax
  801c89:	85 c0                	test   %eax,%eax
  801c8b:	74 35                	je     801cc2 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801c8d:	83 ec 04             	sub    $0x4,%esp
  801c90:	ff 75 10             	pushl  0x10(%ebp)
  801c93:	ff 75 0c             	pushl  0xc(%ebp)
  801c96:	52                   	push   %edx
  801c97:	ff d0                	call   *%eax
  801c99:	83 c4 10             	add    $0x10,%esp
}
  801c9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c9f:	c9                   	leave  
  801ca0:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801ca1:	a1 08 50 80 00       	mov    0x805008,%eax
  801ca6:	8b 40 48             	mov    0x48(%eax),%eax
  801ca9:	83 ec 04             	sub    $0x4,%esp
  801cac:	53                   	push   %ebx
  801cad:	50                   	push   %eax
  801cae:	68 49 3a 80 00       	push   $0x803a49
  801cb3:	e8 80 e9 ff ff       	call   800638 <cprintf>
		return -E_INVAL;
  801cb8:	83 c4 10             	add    $0x10,%esp
  801cbb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801cc0:	eb da                	jmp    801c9c <read+0x5a>
		return -E_NOT_SUPP;
  801cc2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801cc7:	eb d3                	jmp    801c9c <read+0x5a>

00801cc9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
  801ccc:	57                   	push   %edi
  801ccd:	56                   	push   %esi
  801cce:	53                   	push   %ebx
  801ccf:	83 ec 0c             	sub    $0xc,%esp
  801cd2:	8b 7d 08             	mov    0x8(%ebp),%edi
  801cd5:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801cd8:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cdd:	39 f3                	cmp    %esi,%ebx
  801cdf:	73 23                	jae    801d04 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801ce1:	83 ec 04             	sub    $0x4,%esp
  801ce4:	89 f0                	mov    %esi,%eax
  801ce6:	29 d8                	sub    %ebx,%eax
  801ce8:	50                   	push   %eax
  801ce9:	89 d8                	mov    %ebx,%eax
  801ceb:	03 45 0c             	add    0xc(%ebp),%eax
  801cee:	50                   	push   %eax
  801cef:	57                   	push   %edi
  801cf0:	e8 4d ff ff ff       	call   801c42 <read>
		if (m < 0)
  801cf5:	83 c4 10             	add    $0x10,%esp
  801cf8:	85 c0                	test   %eax,%eax
  801cfa:	78 06                	js     801d02 <readn+0x39>
			return m;
		if (m == 0)
  801cfc:	74 06                	je     801d04 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801cfe:	01 c3                	add    %eax,%ebx
  801d00:	eb db                	jmp    801cdd <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801d02:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801d04:	89 d8                	mov    %ebx,%eax
  801d06:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d09:	5b                   	pop    %ebx
  801d0a:	5e                   	pop    %esi
  801d0b:	5f                   	pop    %edi
  801d0c:	5d                   	pop    %ebp
  801d0d:	c3                   	ret    

00801d0e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
  801d11:	53                   	push   %ebx
  801d12:	83 ec 1c             	sub    $0x1c,%esp
  801d15:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d18:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d1b:	50                   	push   %eax
  801d1c:	53                   	push   %ebx
  801d1d:	e8 b0 fc ff ff       	call   8019d2 <fd_lookup>
  801d22:	83 c4 10             	add    $0x10,%esp
  801d25:	85 c0                	test   %eax,%eax
  801d27:	78 3a                	js     801d63 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d29:	83 ec 08             	sub    $0x8,%esp
  801d2c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d2f:	50                   	push   %eax
  801d30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d33:	ff 30                	pushl  (%eax)
  801d35:	e8 e8 fc ff ff       	call   801a22 <dev_lookup>
  801d3a:	83 c4 10             	add    $0x10,%esp
  801d3d:	85 c0                	test   %eax,%eax
  801d3f:	78 22                	js     801d63 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d44:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801d48:	74 1e                	je     801d68 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801d4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d4d:	8b 52 0c             	mov    0xc(%edx),%edx
  801d50:	85 d2                	test   %edx,%edx
  801d52:	74 35                	je     801d89 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801d54:	83 ec 04             	sub    $0x4,%esp
  801d57:	ff 75 10             	pushl  0x10(%ebp)
  801d5a:	ff 75 0c             	pushl  0xc(%ebp)
  801d5d:	50                   	push   %eax
  801d5e:	ff d2                	call   *%edx
  801d60:	83 c4 10             	add    $0x10,%esp
}
  801d63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d66:	c9                   	leave  
  801d67:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801d68:	a1 08 50 80 00       	mov    0x805008,%eax
  801d6d:	8b 40 48             	mov    0x48(%eax),%eax
  801d70:	83 ec 04             	sub    $0x4,%esp
  801d73:	53                   	push   %ebx
  801d74:	50                   	push   %eax
  801d75:	68 65 3a 80 00       	push   $0x803a65
  801d7a:	e8 b9 e8 ff ff       	call   800638 <cprintf>
		return -E_INVAL;
  801d7f:	83 c4 10             	add    $0x10,%esp
  801d82:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d87:	eb da                	jmp    801d63 <write+0x55>
		return -E_NOT_SUPP;
  801d89:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d8e:	eb d3                	jmp    801d63 <write+0x55>

00801d90 <seek>:

int
seek(int fdnum, off_t offset)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
  801d93:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d96:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d99:	50                   	push   %eax
  801d9a:	ff 75 08             	pushl  0x8(%ebp)
  801d9d:	e8 30 fc ff ff       	call   8019d2 <fd_lookup>
  801da2:	83 c4 10             	add    $0x10,%esp
  801da5:	85 c0                	test   %eax,%eax
  801da7:	78 0e                	js     801db7 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801da9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801daf:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801db2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db7:	c9                   	leave  
  801db8:	c3                   	ret    

00801db9 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
  801dbc:	53                   	push   %ebx
  801dbd:	83 ec 1c             	sub    $0x1c,%esp
  801dc0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801dc3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801dc6:	50                   	push   %eax
  801dc7:	53                   	push   %ebx
  801dc8:	e8 05 fc ff ff       	call   8019d2 <fd_lookup>
  801dcd:	83 c4 10             	add    $0x10,%esp
  801dd0:	85 c0                	test   %eax,%eax
  801dd2:	78 37                	js     801e0b <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801dd4:	83 ec 08             	sub    $0x8,%esp
  801dd7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dda:	50                   	push   %eax
  801ddb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dde:	ff 30                	pushl  (%eax)
  801de0:	e8 3d fc ff ff       	call   801a22 <dev_lookup>
  801de5:	83 c4 10             	add    $0x10,%esp
  801de8:	85 c0                	test   %eax,%eax
  801dea:	78 1f                	js     801e0b <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801dec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801def:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801df3:	74 1b                	je     801e10 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801df5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801df8:	8b 52 18             	mov    0x18(%edx),%edx
  801dfb:	85 d2                	test   %edx,%edx
  801dfd:	74 32                	je     801e31 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801dff:	83 ec 08             	sub    $0x8,%esp
  801e02:	ff 75 0c             	pushl  0xc(%ebp)
  801e05:	50                   	push   %eax
  801e06:	ff d2                	call   *%edx
  801e08:	83 c4 10             	add    $0x10,%esp
}
  801e0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    
			thisenv->env_id, fdnum);
  801e10:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801e15:	8b 40 48             	mov    0x48(%eax),%eax
  801e18:	83 ec 04             	sub    $0x4,%esp
  801e1b:	53                   	push   %ebx
  801e1c:	50                   	push   %eax
  801e1d:	68 28 3a 80 00       	push   $0x803a28
  801e22:	e8 11 e8 ff ff       	call   800638 <cprintf>
		return -E_INVAL;
  801e27:	83 c4 10             	add    $0x10,%esp
  801e2a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e2f:	eb da                	jmp    801e0b <ftruncate+0x52>
		return -E_NOT_SUPP;
  801e31:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e36:	eb d3                	jmp    801e0b <ftruncate+0x52>

00801e38 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
  801e3b:	53                   	push   %ebx
  801e3c:	83 ec 1c             	sub    $0x1c,%esp
  801e3f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801e42:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e45:	50                   	push   %eax
  801e46:	ff 75 08             	pushl  0x8(%ebp)
  801e49:	e8 84 fb ff ff       	call   8019d2 <fd_lookup>
  801e4e:	83 c4 10             	add    $0x10,%esp
  801e51:	85 c0                	test   %eax,%eax
  801e53:	78 4b                	js     801ea0 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801e55:	83 ec 08             	sub    $0x8,%esp
  801e58:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e5b:	50                   	push   %eax
  801e5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e5f:	ff 30                	pushl  (%eax)
  801e61:	e8 bc fb ff ff       	call   801a22 <dev_lookup>
  801e66:	83 c4 10             	add    $0x10,%esp
  801e69:	85 c0                	test   %eax,%eax
  801e6b:	78 33                	js     801ea0 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e70:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801e74:	74 2f                	je     801ea5 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801e76:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801e79:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801e80:	00 00 00 
	stat->st_isdir = 0;
  801e83:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e8a:	00 00 00 
	stat->st_dev = dev;
  801e8d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801e93:	83 ec 08             	sub    $0x8,%esp
  801e96:	53                   	push   %ebx
  801e97:	ff 75 f0             	pushl  -0x10(%ebp)
  801e9a:	ff 50 14             	call   *0x14(%eax)
  801e9d:	83 c4 10             	add    $0x10,%esp
}
  801ea0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ea3:	c9                   	leave  
  801ea4:	c3                   	ret    
		return -E_NOT_SUPP;
  801ea5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801eaa:	eb f4                	jmp    801ea0 <fstat+0x68>

00801eac <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
  801eaf:	56                   	push   %esi
  801eb0:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801eb1:	83 ec 08             	sub    $0x8,%esp
  801eb4:	6a 00                	push   $0x0
  801eb6:	ff 75 08             	pushl  0x8(%ebp)
  801eb9:	e8 22 02 00 00       	call   8020e0 <open>
  801ebe:	89 c3                	mov    %eax,%ebx
  801ec0:	83 c4 10             	add    $0x10,%esp
  801ec3:	85 c0                	test   %eax,%eax
  801ec5:	78 1b                	js     801ee2 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801ec7:	83 ec 08             	sub    $0x8,%esp
  801eca:	ff 75 0c             	pushl  0xc(%ebp)
  801ecd:	50                   	push   %eax
  801ece:	e8 65 ff ff ff       	call   801e38 <fstat>
  801ed3:	89 c6                	mov    %eax,%esi
	close(fd);
  801ed5:	89 1c 24             	mov    %ebx,(%esp)
  801ed8:	e8 27 fc ff ff       	call   801b04 <close>
	return r;
  801edd:	83 c4 10             	add    $0x10,%esp
  801ee0:	89 f3                	mov    %esi,%ebx
}
  801ee2:	89 d8                	mov    %ebx,%eax
  801ee4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ee7:	5b                   	pop    %ebx
  801ee8:	5e                   	pop    %esi
  801ee9:	5d                   	pop    %ebp
  801eea:	c3                   	ret    

00801eeb <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
  801eee:	56                   	push   %esi
  801eef:	53                   	push   %ebx
  801ef0:	89 c6                	mov    %eax,%esi
  801ef2:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801ef4:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801efb:	74 27                	je     801f24 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801efd:	6a 07                	push   $0x7
  801eff:	68 00 60 80 00       	push   $0x806000
  801f04:	56                   	push   %esi
  801f05:	ff 35 00 50 80 00    	pushl  0x805000
  801f0b:	e8 93 11 00 00       	call   8030a3 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801f10:	83 c4 0c             	add    $0xc,%esp
  801f13:	6a 00                	push   $0x0
  801f15:	53                   	push   %ebx
  801f16:	6a 00                	push   $0x0
  801f18:	e8 1d 11 00 00       	call   80303a <ipc_recv>
}
  801f1d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f20:	5b                   	pop    %ebx
  801f21:	5e                   	pop    %esi
  801f22:	5d                   	pop    %ebp
  801f23:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801f24:	83 ec 0c             	sub    $0xc,%esp
  801f27:	6a 01                	push   $0x1
  801f29:	e8 cd 11 00 00       	call   8030fb <ipc_find_env>
  801f2e:	a3 00 50 80 00       	mov    %eax,0x805000
  801f33:	83 c4 10             	add    $0x10,%esp
  801f36:	eb c5                	jmp    801efd <fsipc+0x12>

00801f38 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801f38:	55                   	push   %ebp
  801f39:	89 e5                	mov    %esp,%ebp
  801f3b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f41:	8b 40 0c             	mov    0xc(%eax),%eax
  801f44:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801f49:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f4c:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801f51:	ba 00 00 00 00       	mov    $0x0,%edx
  801f56:	b8 02 00 00 00       	mov    $0x2,%eax
  801f5b:	e8 8b ff ff ff       	call   801eeb <fsipc>
}
  801f60:	c9                   	leave  
  801f61:	c3                   	ret    

00801f62 <devfile_flush>:
{
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
  801f65:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801f68:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6b:	8b 40 0c             	mov    0xc(%eax),%eax
  801f6e:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801f73:	ba 00 00 00 00       	mov    $0x0,%edx
  801f78:	b8 06 00 00 00       	mov    $0x6,%eax
  801f7d:	e8 69 ff ff ff       	call   801eeb <fsipc>
}
  801f82:	c9                   	leave  
  801f83:	c3                   	ret    

00801f84 <devfile_stat>:
{
  801f84:	55                   	push   %ebp
  801f85:	89 e5                	mov    %esp,%ebp
  801f87:	53                   	push   %ebx
  801f88:	83 ec 04             	sub    $0x4,%esp
  801f8b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f91:	8b 40 0c             	mov    0xc(%eax),%eax
  801f94:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801f99:	ba 00 00 00 00       	mov    $0x0,%edx
  801f9e:	b8 05 00 00 00       	mov    $0x5,%eax
  801fa3:	e8 43 ff ff ff       	call   801eeb <fsipc>
  801fa8:	85 c0                	test   %eax,%eax
  801faa:	78 2c                	js     801fd8 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801fac:	83 ec 08             	sub    $0x8,%esp
  801faf:	68 00 60 80 00       	push   $0x806000
  801fb4:	53                   	push   %ebx
  801fb5:	e8 dd ed ff ff       	call   800d97 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801fba:	a1 80 60 80 00       	mov    0x806080,%eax
  801fbf:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801fc5:	a1 84 60 80 00       	mov    0x806084,%eax
  801fca:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801fd0:	83 c4 10             	add    $0x10,%esp
  801fd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fdb:	c9                   	leave  
  801fdc:	c3                   	ret    

00801fdd <devfile_write>:
{
  801fdd:	55                   	push   %ebp
  801fde:	89 e5                	mov    %esp,%ebp
  801fe0:	53                   	push   %ebx
  801fe1:	83 ec 08             	sub    $0x8,%esp
  801fe4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fea:	8b 40 0c             	mov    0xc(%eax),%eax
  801fed:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801ff2:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801ff8:	53                   	push   %ebx
  801ff9:	ff 75 0c             	pushl  0xc(%ebp)
  801ffc:	68 08 60 80 00       	push   $0x806008
  802001:	e8 81 ef ff ff       	call   800f87 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802006:	ba 00 00 00 00       	mov    $0x0,%edx
  80200b:	b8 04 00 00 00       	mov    $0x4,%eax
  802010:	e8 d6 fe ff ff       	call   801eeb <fsipc>
  802015:	83 c4 10             	add    $0x10,%esp
  802018:	85 c0                	test   %eax,%eax
  80201a:	78 0b                	js     802027 <devfile_write+0x4a>
	assert(r <= n);
  80201c:	39 d8                	cmp    %ebx,%eax
  80201e:	77 0c                	ja     80202c <devfile_write+0x4f>
	assert(r <= PGSIZE);
  802020:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802025:	7f 1e                	jg     802045 <devfile_write+0x68>
}
  802027:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80202a:	c9                   	leave  
  80202b:	c3                   	ret    
	assert(r <= n);
  80202c:	68 98 3a 80 00       	push   $0x803a98
  802031:	68 9f 3a 80 00       	push   $0x803a9f
  802036:	68 98 00 00 00       	push   $0x98
  80203b:	68 b4 3a 80 00       	push   $0x803ab4
  802040:	e8 fd e4 ff ff       	call   800542 <_panic>
	assert(r <= PGSIZE);
  802045:	68 bf 3a 80 00       	push   $0x803abf
  80204a:	68 9f 3a 80 00       	push   $0x803a9f
  80204f:	68 99 00 00 00       	push   $0x99
  802054:	68 b4 3a 80 00       	push   $0x803ab4
  802059:	e8 e4 e4 ff ff       	call   800542 <_panic>

0080205e <devfile_read>:
{
  80205e:	55                   	push   %ebp
  80205f:	89 e5                	mov    %esp,%ebp
  802061:	56                   	push   %esi
  802062:	53                   	push   %ebx
  802063:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802066:	8b 45 08             	mov    0x8(%ebp),%eax
  802069:	8b 40 0c             	mov    0xc(%eax),%eax
  80206c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  802071:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802077:	ba 00 00 00 00       	mov    $0x0,%edx
  80207c:	b8 03 00 00 00       	mov    $0x3,%eax
  802081:	e8 65 fe ff ff       	call   801eeb <fsipc>
  802086:	89 c3                	mov    %eax,%ebx
  802088:	85 c0                	test   %eax,%eax
  80208a:	78 1f                	js     8020ab <devfile_read+0x4d>
	assert(r <= n);
  80208c:	39 f0                	cmp    %esi,%eax
  80208e:	77 24                	ja     8020b4 <devfile_read+0x56>
	assert(r <= PGSIZE);
  802090:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802095:	7f 33                	jg     8020ca <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802097:	83 ec 04             	sub    $0x4,%esp
  80209a:	50                   	push   %eax
  80209b:	68 00 60 80 00       	push   $0x806000
  8020a0:	ff 75 0c             	pushl  0xc(%ebp)
  8020a3:	e8 7d ee ff ff       	call   800f25 <memmove>
	return r;
  8020a8:	83 c4 10             	add    $0x10,%esp
}
  8020ab:	89 d8                	mov    %ebx,%eax
  8020ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020b0:	5b                   	pop    %ebx
  8020b1:	5e                   	pop    %esi
  8020b2:	5d                   	pop    %ebp
  8020b3:	c3                   	ret    
	assert(r <= n);
  8020b4:	68 98 3a 80 00       	push   $0x803a98
  8020b9:	68 9f 3a 80 00       	push   $0x803a9f
  8020be:	6a 7c                	push   $0x7c
  8020c0:	68 b4 3a 80 00       	push   $0x803ab4
  8020c5:	e8 78 e4 ff ff       	call   800542 <_panic>
	assert(r <= PGSIZE);
  8020ca:	68 bf 3a 80 00       	push   $0x803abf
  8020cf:	68 9f 3a 80 00       	push   $0x803a9f
  8020d4:	6a 7d                	push   $0x7d
  8020d6:	68 b4 3a 80 00       	push   $0x803ab4
  8020db:	e8 62 e4 ff ff       	call   800542 <_panic>

008020e0 <open>:
{
  8020e0:	55                   	push   %ebp
  8020e1:	89 e5                	mov    %esp,%ebp
  8020e3:	56                   	push   %esi
  8020e4:	53                   	push   %ebx
  8020e5:	83 ec 1c             	sub    $0x1c,%esp
  8020e8:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8020eb:	56                   	push   %esi
  8020ec:	e8 6d ec ff ff       	call   800d5e <strlen>
  8020f1:	83 c4 10             	add    $0x10,%esp
  8020f4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8020f9:	7f 6c                	jg     802167 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8020fb:	83 ec 0c             	sub    $0xc,%esp
  8020fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802101:	50                   	push   %eax
  802102:	e8 79 f8 ff ff       	call   801980 <fd_alloc>
  802107:	89 c3                	mov    %eax,%ebx
  802109:	83 c4 10             	add    $0x10,%esp
  80210c:	85 c0                	test   %eax,%eax
  80210e:	78 3c                	js     80214c <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  802110:	83 ec 08             	sub    $0x8,%esp
  802113:	56                   	push   %esi
  802114:	68 00 60 80 00       	push   $0x806000
  802119:	e8 79 ec ff ff       	call   800d97 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80211e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802121:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802126:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802129:	b8 01 00 00 00       	mov    $0x1,%eax
  80212e:	e8 b8 fd ff ff       	call   801eeb <fsipc>
  802133:	89 c3                	mov    %eax,%ebx
  802135:	83 c4 10             	add    $0x10,%esp
  802138:	85 c0                	test   %eax,%eax
  80213a:	78 19                	js     802155 <open+0x75>
	return fd2num(fd);
  80213c:	83 ec 0c             	sub    $0xc,%esp
  80213f:	ff 75 f4             	pushl  -0xc(%ebp)
  802142:	e8 12 f8 ff ff       	call   801959 <fd2num>
  802147:	89 c3                	mov    %eax,%ebx
  802149:	83 c4 10             	add    $0x10,%esp
}
  80214c:	89 d8                	mov    %ebx,%eax
  80214e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802151:	5b                   	pop    %ebx
  802152:	5e                   	pop    %esi
  802153:	5d                   	pop    %ebp
  802154:	c3                   	ret    
		fd_close(fd, 0);
  802155:	83 ec 08             	sub    $0x8,%esp
  802158:	6a 00                	push   $0x0
  80215a:	ff 75 f4             	pushl  -0xc(%ebp)
  80215d:	e8 1b f9 ff ff       	call   801a7d <fd_close>
		return r;
  802162:	83 c4 10             	add    $0x10,%esp
  802165:	eb e5                	jmp    80214c <open+0x6c>
		return -E_BAD_PATH;
  802167:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80216c:	eb de                	jmp    80214c <open+0x6c>

0080216e <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80216e:	55                   	push   %ebp
  80216f:	89 e5                	mov    %esp,%ebp
  802171:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802174:	ba 00 00 00 00       	mov    $0x0,%edx
  802179:	b8 08 00 00 00       	mov    $0x8,%eax
  80217e:	e8 68 fd ff ff       	call   801eeb <fsipc>
}
  802183:	c9                   	leave  
  802184:	c3                   	ret    

00802185 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802185:	55                   	push   %ebp
  802186:	89 e5                	mov    %esp,%ebp
  802188:	57                   	push   %edi
  802189:	56                   	push   %esi
  80218a:	53                   	push   %ebx
  80218b:	81 ec 94 02 00 00    	sub    $0x294,%esp
	cprintf("in %s\n", __FUNCTION__);
  802191:	68 a4 3b 80 00       	push   $0x803ba4
  802196:	68 3d 35 80 00       	push   $0x80353d
  80219b:	e8 98 e4 ff ff       	call   800638 <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8021a0:	83 c4 08             	add    $0x8,%esp
  8021a3:	6a 00                	push   $0x0
  8021a5:	ff 75 08             	pushl  0x8(%ebp)
  8021a8:	e8 33 ff ff ff       	call   8020e0 <open>
  8021ad:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8021b3:	83 c4 10             	add    $0x10,%esp
  8021b6:	85 c0                	test   %eax,%eax
  8021b8:	0f 88 0a 05 00 00    	js     8026c8 <spawn+0x543>
  8021be:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8021c0:	83 ec 04             	sub    $0x4,%esp
  8021c3:	68 00 02 00 00       	push   $0x200
  8021c8:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8021ce:	50                   	push   %eax
  8021cf:	51                   	push   %ecx
  8021d0:	e8 f4 fa ff ff       	call   801cc9 <readn>
  8021d5:	83 c4 10             	add    $0x10,%esp
  8021d8:	3d 00 02 00 00       	cmp    $0x200,%eax
  8021dd:	75 74                	jne    802253 <spawn+0xce>
	    || elf->e_magic != ELF_MAGIC) {
  8021df:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8021e6:	45 4c 46 
  8021e9:	75 68                	jne    802253 <spawn+0xce>
  8021eb:	b8 07 00 00 00       	mov    $0x7,%eax
  8021f0:	cd 30                	int    $0x30
  8021f2:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  8021f8:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8021fe:	85 c0                	test   %eax,%eax
  802200:	0f 88 b6 04 00 00    	js     8026bc <spawn+0x537>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802206:	25 ff 03 00 00       	and    $0x3ff,%eax
  80220b:	89 c6                	mov    %eax,%esi
  80220d:	c1 e6 07             	shl    $0x7,%esi
  802210:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  802216:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  80221c:	b9 11 00 00 00       	mov    $0x11,%ecx
  802221:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  802223:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802229:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
	cprintf("in %s\n", __FUNCTION__);
  80222f:	83 ec 08             	sub    $0x8,%esp
  802232:	68 98 3b 80 00       	push   $0x803b98
  802237:	68 3d 35 80 00       	push   $0x80353d
  80223c:	e8 f7 e3 ff ff       	call   800638 <cprintf>
  802241:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802244:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  802249:	be 00 00 00 00       	mov    $0x0,%esi
  80224e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802251:	eb 4b                	jmp    80229e <spawn+0x119>
		close(fd);
  802253:	83 ec 0c             	sub    $0xc,%esp
  802256:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80225c:	e8 a3 f8 ff ff       	call   801b04 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802261:	83 c4 0c             	add    $0xc,%esp
  802264:	68 7f 45 4c 46       	push   $0x464c457f
  802269:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  80226f:	68 cb 3a 80 00       	push   $0x803acb
  802274:	e8 bf e3 ff ff       	call   800638 <cprintf>
		return -E_NOT_EXEC;
  802279:	83 c4 10             	add    $0x10,%esp
  80227c:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  802283:	ff ff ff 
  802286:	e9 3d 04 00 00       	jmp    8026c8 <spawn+0x543>
		string_size += strlen(argv[argc]) + 1;
  80228b:	83 ec 0c             	sub    $0xc,%esp
  80228e:	50                   	push   %eax
  80228f:	e8 ca ea ff ff       	call   800d5e <strlen>
  802294:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  802298:	83 c3 01             	add    $0x1,%ebx
  80229b:	83 c4 10             	add    $0x10,%esp
  80229e:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  8022a5:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  8022a8:	85 c0                	test   %eax,%eax
  8022aa:	75 df                	jne    80228b <spawn+0x106>
  8022ac:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  8022b2:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8022b8:	bf 00 10 40 00       	mov    $0x401000,%edi
  8022bd:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  8022bf:	89 fa                	mov    %edi,%edx
  8022c1:	83 e2 fc             	and    $0xfffffffc,%edx
  8022c4:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  8022cb:	29 c2                	sub    %eax,%edx
  8022cd:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8022d3:	8d 42 f8             	lea    -0x8(%edx),%eax
  8022d6:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8022db:	0f 86 0a 04 00 00    	jbe    8026eb <spawn+0x566>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8022e1:	83 ec 04             	sub    $0x4,%esp
  8022e4:	6a 07                	push   $0x7
  8022e6:	68 00 00 40 00       	push   $0x400000
  8022eb:	6a 00                	push   $0x0
  8022ed:	e8 97 ee ff ff       	call   801189 <sys_page_alloc>
  8022f2:	83 c4 10             	add    $0x10,%esp
  8022f5:	85 c0                	test   %eax,%eax
  8022f7:	0f 88 f3 03 00 00    	js     8026f0 <spawn+0x56b>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8022fd:	be 00 00 00 00       	mov    $0x0,%esi
  802302:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  802308:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80230b:	eb 30                	jmp    80233d <spawn+0x1b8>
		argv_store[i] = UTEMP2USTACK(string_store);
  80230d:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802313:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  802319:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  80231c:	83 ec 08             	sub    $0x8,%esp
  80231f:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802322:	57                   	push   %edi
  802323:	e8 6f ea ff ff       	call   800d97 <strcpy>
		string_store += strlen(argv[i]) + 1;
  802328:	83 c4 04             	add    $0x4,%esp
  80232b:	ff 34 b3             	pushl  (%ebx,%esi,4)
  80232e:	e8 2b ea ff ff       	call   800d5e <strlen>
  802333:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  802337:	83 c6 01             	add    $0x1,%esi
  80233a:	83 c4 10             	add    $0x10,%esp
  80233d:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  802343:	7f c8                	jg     80230d <spawn+0x188>
	}
	argv_store[argc] = 0;
  802345:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80234b:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  802351:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  802358:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  80235e:	0f 85 86 00 00 00    	jne    8023ea <spawn+0x265>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802364:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  80236a:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  802370:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  802373:	89 d0                	mov    %edx,%eax
  802375:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  80237b:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80237e:	2d 08 30 80 11       	sub    $0x11803008,%eax
  802383:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802389:	83 ec 0c             	sub    $0xc,%esp
  80238c:	6a 07                	push   $0x7
  80238e:	68 00 d0 bf ee       	push   $0xeebfd000
  802393:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802399:	68 00 00 40 00       	push   $0x400000
  80239e:	6a 00                	push   $0x0
  8023a0:	e8 27 ee ff ff       	call   8011cc <sys_page_map>
  8023a5:	89 c3                	mov    %eax,%ebx
  8023a7:	83 c4 20             	add    $0x20,%esp
  8023aa:	85 c0                	test   %eax,%eax
  8023ac:	0f 88 46 03 00 00    	js     8026f8 <spawn+0x573>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8023b2:	83 ec 08             	sub    $0x8,%esp
  8023b5:	68 00 00 40 00       	push   $0x400000
  8023ba:	6a 00                	push   $0x0
  8023bc:	e8 4d ee ff ff       	call   80120e <sys_page_unmap>
  8023c1:	89 c3                	mov    %eax,%ebx
  8023c3:	83 c4 10             	add    $0x10,%esp
  8023c6:	85 c0                	test   %eax,%eax
  8023c8:	0f 88 2a 03 00 00    	js     8026f8 <spawn+0x573>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8023ce:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  8023d4:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8023db:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  8023e2:	00 00 00 
  8023e5:	e9 4f 01 00 00       	jmp    802539 <spawn+0x3b4>
	assert(string_store == (char*)UTEMP + PGSIZE);
  8023ea:	68 54 3b 80 00       	push   $0x803b54
  8023ef:	68 9f 3a 80 00       	push   $0x803a9f
  8023f4:	68 f8 00 00 00       	push   $0xf8
  8023f9:	68 e5 3a 80 00       	push   $0x803ae5
  8023fe:	e8 3f e1 ff ff       	call   800542 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802403:	83 ec 04             	sub    $0x4,%esp
  802406:	6a 07                	push   $0x7
  802408:	68 00 00 40 00       	push   $0x400000
  80240d:	6a 00                	push   $0x0
  80240f:	e8 75 ed ff ff       	call   801189 <sys_page_alloc>
  802414:	83 c4 10             	add    $0x10,%esp
  802417:	85 c0                	test   %eax,%eax
  802419:	0f 88 b7 02 00 00    	js     8026d6 <spawn+0x551>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  80241f:	83 ec 08             	sub    $0x8,%esp
  802422:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802428:	01 f0                	add    %esi,%eax
  80242a:	50                   	push   %eax
  80242b:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802431:	e8 5a f9 ff ff       	call   801d90 <seek>
  802436:	83 c4 10             	add    $0x10,%esp
  802439:	85 c0                	test   %eax,%eax
  80243b:	0f 88 9c 02 00 00    	js     8026dd <spawn+0x558>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802441:	83 ec 04             	sub    $0x4,%esp
  802444:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80244a:	29 f0                	sub    %esi,%eax
  80244c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802451:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802456:	0f 47 c1             	cmova  %ecx,%eax
  802459:	50                   	push   %eax
  80245a:	68 00 00 40 00       	push   $0x400000
  80245f:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802465:	e8 5f f8 ff ff       	call   801cc9 <readn>
  80246a:	83 c4 10             	add    $0x10,%esp
  80246d:	85 c0                	test   %eax,%eax
  80246f:	0f 88 6f 02 00 00    	js     8026e4 <spawn+0x55f>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802475:	83 ec 0c             	sub    $0xc,%esp
  802478:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  80247e:	53                   	push   %ebx
  80247f:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802485:	68 00 00 40 00       	push   $0x400000
  80248a:	6a 00                	push   $0x0
  80248c:	e8 3b ed ff ff       	call   8011cc <sys_page_map>
  802491:	83 c4 20             	add    $0x20,%esp
  802494:	85 c0                	test   %eax,%eax
  802496:	78 7c                	js     802514 <spawn+0x38f>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  802498:	83 ec 08             	sub    $0x8,%esp
  80249b:	68 00 00 40 00       	push   $0x400000
  8024a0:	6a 00                	push   $0x0
  8024a2:	e8 67 ed ff ff       	call   80120e <sys_page_unmap>
  8024a7:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  8024aa:	81 c7 00 10 00 00    	add    $0x1000,%edi
  8024b0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8024b6:	89 fe                	mov    %edi,%esi
  8024b8:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  8024be:	76 69                	jbe    802529 <spawn+0x3a4>
		if (i >= filesz) {
  8024c0:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  8024c6:	0f 87 37 ff ff ff    	ja     802403 <spawn+0x27e>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8024cc:	83 ec 04             	sub    $0x4,%esp
  8024cf:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8024d5:	53                   	push   %ebx
  8024d6:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  8024dc:	e8 a8 ec ff ff       	call   801189 <sys_page_alloc>
  8024e1:	83 c4 10             	add    $0x10,%esp
  8024e4:	85 c0                	test   %eax,%eax
  8024e6:	79 c2                	jns    8024aa <spawn+0x325>
  8024e8:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  8024ea:	83 ec 0c             	sub    $0xc,%esp
  8024ed:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8024f3:	e8 12 ec ff ff       	call   80110a <sys_env_destroy>
	close(fd);
  8024f8:	83 c4 04             	add    $0x4,%esp
  8024fb:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802501:	e8 fe f5 ff ff       	call   801b04 <close>
	return r;
  802506:	83 c4 10             	add    $0x10,%esp
  802509:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  80250f:	e9 b4 01 00 00       	jmp    8026c8 <spawn+0x543>
				panic("spawn: sys_page_map data: %e", r);
  802514:	50                   	push   %eax
  802515:	68 f1 3a 80 00       	push   $0x803af1
  80251a:	68 2b 01 00 00       	push   $0x12b
  80251f:	68 e5 3a 80 00       	push   $0x803ae5
  802524:	e8 19 e0 ff ff       	call   800542 <_panic>
  802529:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80252f:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  802536:	83 c6 20             	add    $0x20,%esi
  802539:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802540:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  802546:	7e 6d                	jle    8025b5 <spawn+0x430>
		if (ph->p_type != ELF_PROG_LOAD)
  802548:	83 3e 01             	cmpl   $0x1,(%esi)
  80254b:	75 e2                	jne    80252f <spawn+0x3aa>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  80254d:	8b 46 18             	mov    0x18(%esi),%eax
  802550:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  802553:	83 f8 01             	cmp    $0x1,%eax
  802556:	19 c0                	sbb    %eax,%eax
  802558:	83 e0 fe             	and    $0xfffffffe,%eax
  80255b:	83 c0 07             	add    $0x7,%eax
  80255e:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802564:	8b 4e 04             	mov    0x4(%esi),%ecx
  802567:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  80256d:	8b 56 10             	mov    0x10(%esi),%edx
  802570:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  802576:	8b 7e 14             	mov    0x14(%esi),%edi
  802579:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  80257f:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  802582:	89 d8                	mov    %ebx,%eax
  802584:	25 ff 0f 00 00       	and    $0xfff,%eax
  802589:	74 1a                	je     8025a5 <spawn+0x420>
		va -= i;
  80258b:	29 c3                	sub    %eax,%ebx
		memsz += i;
  80258d:	01 c7                	add    %eax,%edi
  80258f:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  802595:	01 c2                	add    %eax,%edx
  802597:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  80259d:	29 c1                	sub    %eax,%ecx
  80259f:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  8025a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8025aa:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  8025b0:	e9 01 ff ff ff       	jmp    8024b6 <spawn+0x331>
	close(fd);
  8025b5:	83 ec 0c             	sub    $0xc,%esp
  8025b8:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8025be:	e8 41 f5 ff ff       	call   801b04 <close>

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	cprintf("in %s\n", __FUNCTION__);
  8025c3:	83 c4 08             	add    $0x8,%esp
  8025c6:	68 84 3b 80 00       	push   $0x803b84
  8025cb:	68 3d 35 80 00       	push   $0x80353d
  8025d0:	e8 63 e0 ff ff       	call   800638 <cprintf>
  8025d5:	83 c4 10             	add    $0x10,%esp
	int r;
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  8025d8:	bb 00 00 80 00       	mov    $0x800000,%ebx
  8025dd:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  8025e3:	eb 0e                	jmp    8025f3 <spawn+0x46e>
  8025e5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8025eb:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8025f1:	74 5e                	je     802651 <spawn+0x4cc>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_SHARE)) == (PTE_P | PTE_U | PTE_SHARE)))
  8025f3:	89 d8                	mov    %ebx,%eax
  8025f5:	c1 e8 16             	shr    $0x16,%eax
  8025f8:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8025ff:	a8 01                	test   $0x1,%al
  802601:	74 e2                	je     8025e5 <spawn+0x460>
  802603:	89 da                	mov    %ebx,%edx
  802605:	c1 ea 0c             	shr    $0xc,%edx
  802608:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80260f:	25 05 04 00 00       	and    $0x405,%eax
  802614:	3d 05 04 00 00       	cmp    $0x405,%eax
  802619:	75 ca                	jne    8025e5 <spawn+0x460>
			if((r = sys_page_map((envid_t)0, (void *)i, child, (void *)i, uvpt[PGNUM(i)] & PTE_SYSCALL)) < 0)
  80261b:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  802622:	83 ec 0c             	sub    $0xc,%esp
  802625:	25 07 0e 00 00       	and    $0xe07,%eax
  80262a:	50                   	push   %eax
  80262b:	53                   	push   %ebx
  80262c:	56                   	push   %esi
  80262d:	53                   	push   %ebx
  80262e:	6a 00                	push   $0x0
  802630:	e8 97 eb ff ff       	call   8011cc <sys_page_map>
  802635:	83 c4 20             	add    $0x20,%esp
  802638:	85 c0                	test   %eax,%eax
  80263a:	79 a9                	jns    8025e5 <spawn+0x460>
        		panic("sys_page_map: %e\n", r);
  80263c:	50                   	push   %eax
  80263d:	68 0e 3b 80 00       	push   $0x803b0e
  802642:	68 3b 01 00 00       	push   $0x13b
  802647:	68 e5 3a 80 00       	push   $0x803ae5
  80264c:	e8 f1 de ff ff       	call   800542 <_panic>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802651:	83 ec 08             	sub    $0x8,%esp
  802654:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  80265a:	50                   	push   %eax
  80265b:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802661:	e8 2c ec ff ff       	call   801292 <sys_env_set_trapframe>
  802666:	83 c4 10             	add    $0x10,%esp
  802669:	85 c0                	test   %eax,%eax
  80266b:	78 25                	js     802692 <spawn+0x50d>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  80266d:	83 ec 08             	sub    $0x8,%esp
  802670:	6a 02                	push   $0x2
  802672:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802678:	e8 d3 eb ff ff       	call   801250 <sys_env_set_status>
  80267d:	83 c4 10             	add    $0x10,%esp
  802680:	85 c0                	test   %eax,%eax
  802682:	78 23                	js     8026a7 <spawn+0x522>
	return child;
  802684:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80268a:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802690:	eb 36                	jmp    8026c8 <spawn+0x543>
		panic("sys_env_set_trapframe: %e", r);
  802692:	50                   	push   %eax
  802693:	68 20 3b 80 00       	push   $0x803b20
  802698:	68 8a 00 00 00       	push   $0x8a
  80269d:	68 e5 3a 80 00       	push   $0x803ae5
  8026a2:	e8 9b de ff ff       	call   800542 <_panic>
		panic("sys_env_set_status: %e", r);
  8026a7:	50                   	push   %eax
  8026a8:	68 3a 3b 80 00       	push   $0x803b3a
  8026ad:	68 8d 00 00 00       	push   $0x8d
  8026b2:	68 e5 3a 80 00       	push   $0x803ae5
  8026b7:	e8 86 de ff ff       	call   800542 <_panic>
		return r;
  8026bc:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8026c2:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  8026c8:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8026ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026d1:	5b                   	pop    %ebx
  8026d2:	5e                   	pop    %esi
  8026d3:	5f                   	pop    %edi
  8026d4:	5d                   	pop    %ebp
  8026d5:	c3                   	ret    
  8026d6:	89 c7                	mov    %eax,%edi
  8026d8:	e9 0d fe ff ff       	jmp    8024ea <spawn+0x365>
  8026dd:	89 c7                	mov    %eax,%edi
  8026df:	e9 06 fe ff ff       	jmp    8024ea <spawn+0x365>
  8026e4:	89 c7                	mov    %eax,%edi
  8026e6:	e9 ff fd ff ff       	jmp    8024ea <spawn+0x365>
		return -E_NO_MEM;
  8026eb:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  8026f0:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8026f6:	eb d0                	jmp    8026c8 <spawn+0x543>
	sys_page_unmap(0, UTEMP);
  8026f8:	83 ec 08             	sub    $0x8,%esp
  8026fb:	68 00 00 40 00       	push   $0x400000
  802700:	6a 00                	push   $0x0
  802702:	e8 07 eb ff ff       	call   80120e <sys_page_unmap>
  802707:	83 c4 10             	add    $0x10,%esp
  80270a:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  802710:	eb b6                	jmp    8026c8 <spawn+0x543>

00802712 <spawnl>:
{
  802712:	55                   	push   %ebp
  802713:	89 e5                	mov    %esp,%ebp
  802715:	57                   	push   %edi
  802716:	56                   	push   %esi
  802717:	53                   	push   %ebx
  802718:	83 ec 14             	sub    $0x14,%esp
	cprintf("in %s\n", __FUNCTION__);
  80271b:	68 7c 3b 80 00       	push   $0x803b7c
  802720:	68 3d 35 80 00       	push   $0x80353d
  802725:	e8 0e df ff ff       	call   800638 <cprintf>
	va_start(vl, arg0);
  80272a:	8d 55 10             	lea    0x10(%ebp),%edx
	while(va_arg(vl, void *) != NULL)
  80272d:	83 c4 10             	add    $0x10,%esp
	int argc=0;
  802730:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  802735:	8d 4a 04             	lea    0x4(%edx),%ecx
  802738:	83 3a 00             	cmpl   $0x0,(%edx)
  80273b:	74 07                	je     802744 <spawnl+0x32>
		argc++;
  80273d:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  802740:	89 ca                	mov    %ecx,%edx
  802742:	eb f1                	jmp    802735 <spawnl+0x23>
	const char *argv[argc+2];
  802744:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  80274b:	83 e2 f0             	and    $0xfffffff0,%edx
  80274e:	29 d4                	sub    %edx,%esp
  802750:	8d 54 24 03          	lea    0x3(%esp),%edx
  802754:	c1 ea 02             	shr    $0x2,%edx
  802757:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  80275e:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802760:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802763:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  80276a:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  802771:	00 
	va_start(vl, arg0);
  802772:	8d 4d 10             	lea    0x10(%ebp),%ecx
  802775:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  802777:	b8 00 00 00 00       	mov    $0x0,%eax
  80277c:	eb 0b                	jmp    802789 <spawnl+0x77>
		argv[i+1] = va_arg(vl, const char *);
  80277e:	83 c0 01             	add    $0x1,%eax
  802781:	8b 39                	mov    (%ecx),%edi
  802783:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  802786:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  802789:	39 d0                	cmp    %edx,%eax
  80278b:	75 f1                	jne    80277e <spawnl+0x6c>
	return spawn(prog, argv);
  80278d:	83 ec 08             	sub    $0x8,%esp
  802790:	56                   	push   %esi
  802791:	ff 75 08             	pushl  0x8(%ebp)
  802794:	e8 ec f9 ff ff       	call   802185 <spawn>
}
  802799:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80279c:	5b                   	pop    %ebx
  80279d:	5e                   	pop    %esi
  80279e:	5f                   	pop    %edi
  80279f:	5d                   	pop    %ebp
  8027a0:	c3                   	ret    

008027a1 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8027a1:	55                   	push   %ebp
  8027a2:	89 e5                	mov    %esp,%ebp
  8027a4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8027a7:	68 aa 3b 80 00       	push   $0x803baa
  8027ac:	ff 75 0c             	pushl  0xc(%ebp)
  8027af:	e8 e3 e5 ff ff       	call   800d97 <strcpy>
	return 0;
}
  8027b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b9:	c9                   	leave  
  8027ba:	c3                   	ret    

008027bb <devsock_close>:
{
  8027bb:	55                   	push   %ebp
  8027bc:	89 e5                	mov    %esp,%ebp
  8027be:	53                   	push   %ebx
  8027bf:	83 ec 10             	sub    $0x10,%esp
  8027c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8027c5:	53                   	push   %ebx
  8027c6:	e8 6b 09 00 00       	call   803136 <pageref>
  8027cb:	83 c4 10             	add    $0x10,%esp
		return 0;
  8027ce:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8027d3:	83 f8 01             	cmp    $0x1,%eax
  8027d6:	74 07                	je     8027df <devsock_close+0x24>
}
  8027d8:	89 d0                	mov    %edx,%eax
  8027da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027dd:	c9                   	leave  
  8027de:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8027df:	83 ec 0c             	sub    $0xc,%esp
  8027e2:	ff 73 0c             	pushl  0xc(%ebx)
  8027e5:	e8 b9 02 00 00       	call   802aa3 <nsipc_close>
  8027ea:	89 c2                	mov    %eax,%edx
  8027ec:	83 c4 10             	add    $0x10,%esp
  8027ef:	eb e7                	jmp    8027d8 <devsock_close+0x1d>

008027f1 <devsock_write>:
{
  8027f1:	55                   	push   %ebp
  8027f2:	89 e5                	mov    %esp,%ebp
  8027f4:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8027f7:	6a 00                	push   $0x0
  8027f9:	ff 75 10             	pushl  0x10(%ebp)
  8027fc:	ff 75 0c             	pushl  0xc(%ebp)
  8027ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802802:	ff 70 0c             	pushl  0xc(%eax)
  802805:	e8 76 03 00 00       	call   802b80 <nsipc_send>
}
  80280a:	c9                   	leave  
  80280b:	c3                   	ret    

0080280c <devsock_read>:
{
  80280c:	55                   	push   %ebp
  80280d:	89 e5                	mov    %esp,%ebp
  80280f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802812:	6a 00                	push   $0x0
  802814:	ff 75 10             	pushl  0x10(%ebp)
  802817:	ff 75 0c             	pushl  0xc(%ebp)
  80281a:	8b 45 08             	mov    0x8(%ebp),%eax
  80281d:	ff 70 0c             	pushl  0xc(%eax)
  802820:	e8 ef 02 00 00       	call   802b14 <nsipc_recv>
}
  802825:	c9                   	leave  
  802826:	c3                   	ret    

00802827 <fd2sockid>:
{
  802827:	55                   	push   %ebp
  802828:	89 e5                	mov    %esp,%ebp
  80282a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80282d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802830:	52                   	push   %edx
  802831:	50                   	push   %eax
  802832:	e8 9b f1 ff ff       	call   8019d2 <fd_lookup>
  802837:	83 c4 10             	add    $0x10,%esp
  80283a:	85 c0                	test   %eax,%eax
  80283c:	78 10                	js     80284e <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80283e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802841:	8b 0d 3c 40 80 00    	mov    0x80403c,%ecx
  802847:	39 08                	cmp    %ecx,(%eax)
  802849:	75 05                	jne    802850 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80284b:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80284e:	c9                   	leave  
  80284f:	c3                   	ret    
		return -E_NOT_SUPP;
  802850:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802855:	eb f7                	jmp    80284e <fd2sockid+0x27>

00802857 <alloc_sockfd>:
{
  802857:	55                   	push   %ebp
  802858:	89 e5                	mov    %esp,%ebp
  80285a:	56                   	push   %esi
  80285b:	53                   	push   %ebx
  80285c:	83 ec 1c             	sub    $0x1c,%esp
  80285f:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802861:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802864:	50                   	push   %eax
  802865:	e8 16 f1 ff ff       	call   801980 <fd_alloc>
  80286a:	89 c3                	mov    %eax,%ebx
  80286c:	83 c4 10             	add    $0x10,%esp
  80286f:	85 c0                	test   %eax,%eax
  802871:	78 43                	js     8028b6 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802873:	83 ec 04             	sub    $0x4,%esp
  802876:	68 07 04 00 00       	push   $0x407
  80287b:	ff 75 f4             	pushl  -0xc(%ebp)
  80287e:	6a 00                	push   $0x0
  802880:	e8 04 e9 ff ff       	call   801189 <sys_page_alloc>
  802885:	89 c3                	mov    %eax,%ebx
  802887:	83 c4 10             	add    $0x10,%esp
  80288a:	85 c0                	test   %eax,%eax
  80288c:	78 28                	js     8028b6 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80288e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802891:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  802897:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802899:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8028a3:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8028a6:	83 ec 0c             	sub    $0xc,%esp
  8028a9:	50                   	push   %eax
  8028aa:	e8 aa f0 ff ff       	call   801959 <fd2num>
  8028af:	89 c3                	mov    %eax,%ebx
  8028b1:	83 c4 10             	add    $0x10,%esp
  8028b4:	eb 0c                	jmp    8028c2 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8028b6:	83 ec 0c             	sub    $0xc,%esp
  8028b9:	56                   	push   %esi
  8028ba:	e8 e4 01 00 00       	call   802aa3 <nsipc_close>
		return r;
  8028bf:	83 c4 10             	add    $0x10,%esp
}
  8028c2:	89 d8                	mov    %ebx,%eax
  8028c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8028c7:	5b                   	pop    %ebx
  8028c8:	5e                   	pop    %esi
  8028c9:	5d                   	pop    %ebp
  8028ca:	c3                   	ret    

008028cb <accept>:
{
  8028cb:	55                   	push   %ebp
  8028cc:	89 e5                	mov    %esp,%ebp
  8028ce:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8028d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d4:	e8 4e ff ff ff       	call   802827 <fd2sockid>
  8028d9:	85 c0                	test   %eax,%eax
  8028db:	78 1b                	js     8028f8 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8028dd:	83 ec 04             	sub    $0x4,%esp
  8028e0:	ff 75 10             	pushl  0x10(%ebp)
  8028e3:	ff 75 0c             	pushl  0xc(%ebp)
  8028e6:	50                   	push   %eax
  8028e7:	e8 0e 01 00 00       	call   8029fa <nsipc_accept>
  8028ec:	83 c4 10             	add    $0x10,%esp
  8028ef:	85 c0                	test   %eax,%eax
  8028f1:	78 05                	js     8028f8 <accept+0x2d>
	return alloc_sockfd(r);
  8028f3:	e8 5f ff ff ff       	call   802857 <alloc_sockfd>
}
  8028f8:	c9                   	leave  
  8028f9:	c3                   	ret    

008028fa <bind>:
{
  8028fa:	55                   	push   %ebp
  8028fb:	89 e5                	mov    %esp,%ebp
  8028fd:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802900:	8b 45 08             	mov    0x8(%ebp),%eax
  802903:	e8 1f ff ff ff       	call   802827 <fd2sockid>
  802908:	85 c0                	test   %eax,%eax
  80290a:	78 12                	js     80291e <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80290c:	83 ec 04             	sub    $0x4,%esp
  80290f:	ff 75 10             	pushl  0x10(%ebp)
  802912:	ff 75 0c             	pushl  0xc(%ebp)
  802915:	50                   	push   %eax
  802916:	e8 31 01 00 00       	call   802a4c <nsipc_bind>
  80291b:	83 c4 10             	add    $0x10,%esp
}
  80291e:	c9                   	leave  
  80291f:	c3                   	ret    

00802920 <shutdown>:
{
  802920:	55                   	push   %ebp
  802921:	89 e5                	mov    %esp,%ebp
  802923:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802926:	8b 45 08             	mov    0x8(%ebp),%eax
  802929:	e8 f9 fe ff ff       	call   802827 <fd2sockid>
  80292e:	85 c0                	test   %eax,%eax
  802930:	78 0f                	js     802941 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802932:	83 ec 08             	sub    $0x8,%esp
  802935:	ff 75 0c             	pushl  0xc(%ebp)
  802938:	50                   	push   %eax
  802939:	e8 43 01 00 00       	call   802a81 <nsipc_shutdown>
  80293e:	83 c4 10             	add    $0x10,%esp
}
  802941:	c9                   	leave  
  802942:	c3                   	ret    

00802943 <connect>:
{
  802943:	55                   	push   %ebp
  802944:	89 e5                	mov    %esp,%ebp
  802946:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802949:	8b 45 08             	mov    0x8(%ebp),%eax
  80294c:	e8 d6 fe ff ff       	call   802827 <fd2sockid>
  802951:	85 c0                	test   %eax,%eax
  802953:	78 12                	js     802967 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802955:	83 ec 04             	sub    $0x4,%esp
  802958:	ff 75 10             	pushl  0x10(%ebp)
  80295b:	ff 75 0c             	pushl  0xc(%ebp)
  80295e:	50                   	push   %eax
  80295f:	e8 59 01 00 00       	call   802abd <nsipc_connect>
  802964:	83 c4 10             	add    $0x10,%esp
}
  802967:	c9                   	leave  
  802968:	c3                   	ret    

00802969 <listen>:
{
  802969:	55                   	push   %ebp
  80296a:	89 e5                	mov    %esp,%ebp
  80296c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80296f:	8b 45 08             	mov    0x8(%ebp),%eax
  802972:	e8 b0 fe ff ff       	call   802827 <fd2sockid>
  802977:	85 c0                	test   %eax,%eax
  802979:	78 0f                	js     80298a <listen+0x21>
	return nsipc_listen(r, backlog);
  80297b:	83 ec 08             	sub    $0x8,%esp
  80297e:	ff 75 0c             	pushl  0xc(%ebp)
  802981:	50                   	push   %eax
  802982:	e8 6b 01 00 00       	call   802af2 <nsipc_listen>
  802987:	83 c4 10             	add    $0x10,%esp
}
  80298a:	c9                   	leave  
  80298b:	c3                   	ret    

0080298c <socket>:

int
socket(int domain, int type, int protocol)
{
  80298c:	55                   	push   %ebp
  80298d:	89 e5                	mov    %esp,%ebp
  80298f:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802992:	ff 75 10             	pushl  0x10(%ebp)
  802995:	ff 75 0c             	pushl  0xc(%ebp)
  802998:	ff 75 08             	pushl  0x8(%ebp)
  80299b:	e8 3e 02 00 00       	call   802bde <nsipc_socket>
  8029a0:	83 c4 10             	add    $0x10,%esp
  8029a3:	85 c0                	test   %eax,%eax
  8029a5:	78 05                	js     8029ac <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8029a7:	e8 ab fe ff ff       	call   802857 <alloc_sockfd>
}
  8029ac:	c9                   	leave  
  8029ad:	c3                   	ret    

008029ae <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8029ae:	55                   	push   %ebp
  8029af:	89 e5                	mov    %esp,%ebp
  8029b1:	53                   	push   %ebx
  8029b2:	83 ec 04             	sub    $0x4,%esp
  8029b5:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8029b7:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8029be:	74 26                	je     8029e6 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8029c0:	6a 07                	push   $0x7
  8029c2:	68 00 70 80 00       	push   $0x807000
  8029c7:	53                   	push   %ebx
  8029c8:	ff 35 04 50 80 00    	pushl  0x805004
  8029ce:	e8 d0 06 00 00       	call   8030a3 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8029d3:	83 c4 0c             	add    $0xc,%esp
  8029d6:	6a 00                	push   $0x0
  8029d8:	6a 00                	push   $0x0
  8029da:	6a 00                	push   $0x0
  8029dc:	e8 59 06 00 00       	call   80303a <ipc_recv>
}
  8029e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8029e4:	c9                   	leave  
  8029e5:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8029e6:	83 ec 0c             	sub    $0xc,%esp
  8029e9:	6a 02                	push   $0x2
  8029eb:	e8 0b 07 00 00       	call   8030fb <ipc_find_env>
  8029f0:	a3 04 50 80 00       	mov    %eax,0x805004
  8029f5:	83 c4 10             	add    $0x10,%esp
  8029f8:	eb c6                	jmp    8029c0 <nsipc+0x12>

008029fa <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8029fa:	55                   	push   %ebp
  8029fb:	89 e5                	mov    %esp,%ebp
  8029fd:	56                   	push   %esi
  8029fe:	53                   	push   %ebx
  8029ff:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802a02:	8b 45 08             	mov    0x8(%ebp),%eax
  802a05:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802a0a:	8b 06                	mov    (%esi),%eax
  802a0c:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802a11:	b8 01 00 00 00       	mov    $0x1,%eax
  802a16:	e8 93 ff ff ff       	call   8029ae <nsipc>
  802a1b:	89 c3                	mov    %eax,%ebx
  802a1d:	85 c0                	test   %eax,%eax
  802a1f:	79 09                	jns    802a2a <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802a21:	89 d8                	mov    %ebx,%eax
  802a23:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a26:	5b                   	pop    %ebx
  802a27:	5e                   	pop    %esi
  802a28:	5d                   	pop    %ebp
  802a29:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802a2a:	83 ec 04             	sub    $0x4,%esp
  802a2d:	ff 35 10 70 80 00    	pushl  0x807010
  802a33:	68 00 70 80 00       	push   $0x807000
  802a38:	ff 75 0c             	pushl  0xc(%ebp)
  802a3b:	e8 e5 e4 ff ff       	call   800f25 <memmove>
		*addrlen = ret->ret_addrlen;
  802a40:	a1 10 70 80 00       	mov    0x807010,%eax
  802a45:	89 06                	mov    %eax,(%esi)
  802a47:	83 c4 10             	add    $0x10,%esp
	return r;
  802a4a:	eb d5                	jmp    802a21 <nsipc_accept+0x27>

00802a4c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802a4c:	55                   	push   %ebp
  802a4d:	89 e5                	mov    %esp,%ebp
  802a4f:	53                   	push   %ebx
  802a50:	83 ec 08             	sub    $0x8,%esp
  802a53:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802a56:	8b 45 08             	mov    0x8(%ebp),%eax
  802a59:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802a5e:	53                   	push   %ebx
  802a5f:	ff 75 0c             	pushl  0xc(%ebp)
  802a62:	68 04 70 80 00       	push   $0x807004
  802a67:	e8 b9 e4 ff ff       	call   800f25 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802a6c:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802a72:	b8 02 00 00 00       	mov    $0x2,%eax
  802a77:	e8 32 ff ff ff       	call   8029ae <nsipc>
}
  802a7c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802a7f:	c9                   	leave  
  802a80:	c3                   	ret    

00802a81 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802a81:	55                   	push   %ebp
  802a82:	89 e5                	mov    %esp,%ebp
  802a84:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802a87:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802a8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a92:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802a97:	b8 03 00 00 00       	mov    $0x3,%eax
  802a9c:	e8 0d ff ff ff       	call   8029ae <nsipc>
}
  802aa1:	c9                   	leave  
  802aa2:	c3                   	ret    

00802aa3 <nsipc_close>:

int
nsipc_close(int s)
{
  802aa3:	55                   	push   %ebp
  802aa4:	89 e5                	mov    %esp,%ebp
  802aa6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  802aac:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802ab1:	b8 04 00 00 00       	mov    $0x4,%eax
  802ab6:	e8 f3 fe ff ff       	call   8029ae <nsipc>
}
  802abb:	c9                   	leave  
  802abc:	c3                   	ret    

00802abd <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802abd:	55                   	push   %ebp
  802abe:	89 e5                	mov    %esp,%ebp
  802ac0:	53                   	push   %ebx
  802ac1:	83 ec 08             	sub    $0x8,%esp
  802ac4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aca:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802acf:	53                   	push   %ebx
  802ad0:	ff 75 0c             	pushl  0xc(%ebp)
  802ad3:	68 04 70 80 00       	push   $0x807004
  802ad8:	e8 48 e4 ff ff       	call   800f25 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802add:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802ae3:	b8 05 00 00 00       	mov    $0x5,%eax
  802ae8:	e8 c1 fe ff ff       	call   8029ae <nsipc>
}
  802aed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802af0:	c9                   	leave  
  802af1:	c3                   	ret    

00802af2 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802af2:	55                   	push   %ebp
  802af3:	89 e5                	mov    %esp,%ebp
  802af5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802af8:	8b 45 08             	mov    0x8(%ebp),%eax
  802afb:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b03:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802b08:	b8 06 00 00 00       	mov    $0x6,%eax
  802b0d:	e8 9c fe ff ff       	call   8029ae <nsipc>
}
  802b12:	c9                   	leave  
  802b13:	c3                   	ret    

00802b14 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802b14:	55                   	push   %ebp
  802b15:	89 e5                	mov    %esp,%ebp
  802b17:	56                   	push   %esi
  802b18:	53                   	push   %ebx
  802b19:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802b24:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802b2a:	8b 45 14             	mov    0x14(%ebp),%eax
  802b2d:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802b32:	b8 07 00 00 00       	mov    $0x7,%eax
  802b37:	e8 72 fe ff ff       	call   8029ae <nsipc>
  802b3c:	89 c3                	mov    %eax,%ebx
  802b3e:	85 c0                	test   %eax,%eax
  802b40:	78 1f                	js     802b61 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802b42:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802b47:	7f 21                	jg     802b6a <nsipc_recv+0x56>
  802b49:	39 c6                	cmp    %eax,%esi
  802b4b:	7c 1d                	jl     802b6a <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802b4d:	83 ec 04             	sub    $0x4,%esp
  802b50:	50                   	push   %eax
  802b51:	68 00 70 80 00       	push   $0x807000
  802b56:	ff 75 0c             	pushl  0xc(%ebp)
  802b59:	e8 c7 e3 ff ff       	call   800f25 <memmove>
  802b5e:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802b61:	89 d8                	mov    %ebx,%eax
  802b63:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802b66:	5b                   	pop    %ebx
  802b67:	5e                   	pop    %esi
  802b68:	5d                   	pop    %ebp
  802b69:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802b6a:	68 b6 3b 80 00       	push   $0x803bb6
  802b6f:	68 9f 3a 80 00       	push   $0x803a9f
  802b74:	6a 62                	push   $0x62
  802b76:	68 cb 3b 80 00       	push   $0x803bcb
  802b7b:	e8 c2 d9 ff ff       	call   800542 <_panic>

00802b80 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802b80:	55                   	push   %ebp
  802b81:	89 e5                	mov    %esp,%ebp
  802b83:	53                   	push   %ebx
  802b84:	83 ec 04             	sub    $0x4,%esp
  802b87:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8d:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802b92:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802b98:	7f 2e                	jg     802bc8 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802b9a:	83 ec 04             	sub    $0x4,%esp
  802b9d:	53                   	push   %ebx
  802b9e:	ff 75 0c             	pushl  0xc(%ebp)
  802ba1:	68 0c 70 80 00       	push   $0x80700c
  802ba6:	e8 7a e3 ff ff       	call   800f25 <memmove>
	nsipcbuf.send.req_size = size;
  802bab:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802bb1:	8b 45 14             	mov    0x14(%ebp),%eax
  802bb4:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802bb9:	b8 08 00 00 00       	mov    $0x8,%eax
  802bbe:	e8 eb fd ff ff       	call   8029ae <nsipc>
}
  802bc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802bc6:	c9                   	leave  
  802bc7:	c3                   	ret    
	assert(size < 1600);
  802bc8:	68 d7 3b 80 00       	push   $0x803bd7
  802bcd:	68 9f 3a 80 00       	push   $0x803a9f
  802bd2:	6a 6d                	push   $0x6d
  802bd4:	68 cb 3b 80 00       	push   $0x803bcb
  802bd9:	e8 64 d9 ff ff       	call   800542 <_panic>

00802bde <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802bde:	55                   	push   %ebp
  802bdf:	89 e5                	mov    %esp,%ebp
  802be1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802be4:	8b 45 08             	mov    0x8(%ebp),%eax
  802be7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802bec:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bef:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802bf4:	8b 45 10             	mov    0x10(%ebp),%eax
  802bf7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802bfc:	b8 09 00 00 00       	mov    $0x9,%eax
  802c01:	e8 a8 fd ff ff       	call   8029ae <nsipc>
}
  802c06:	c9                   	leave  
  802c07:	c3                   	ret    

00802c08 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802c08:	55                   	push   %ebp
  802c09:	89 e5                	mov    %esp,%ebp
  802c0b:	56                   	push   %esi
  802c0c:	53                   	push   %ebx
  802c0d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802c10:	83 ec 0c             	sub    $0xc,%esp
  802c13:	ff 75 08             	pushl  0x8(%ebp)
  802c16:	e8 4e ed ff ff       	call   801969 <fd2data>
  802c1b:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802c1d:	83 c4 08             	add    $0x8,%esp
  802c20:	68 e3 3b 80 00       	push   $0x803be3
  802c25:	53                   	push   %ebx
  802c26:	e8 6c e1 ff ff       	call   800d97 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802c2b:	8b 46 04             	mov    0x4(%esi),%eax
  802c2e:	2b 06                	sub    (%esi),%eax
  802c30:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802c36:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802c3d:	00 00 00 
	stat->st_dev = &devpipe;
  802c40:	c7 83 88 00 00 00 58 	movl   $0x804058,0x88(%ebx)
  802c47:	40 80 00 
	return 0;
}
  802c4a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802c52:	5b                   	pop    %ebx
  802c53:	5e                   	pop    %esi
  802c54:	5d                   	pop    %ebp
  802c55:	c3                   	ret    

00802c56 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802c56:	55                   	push   %ebp
  802c57:	89 e5                	mov    %esp,%ebp
  802c59:	53                   	push   %ebx
  802c5a:	83 ec 0c             	sub    $0xc,%esp
  802c5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802c60:	53                   	push   %ebx
  802c61:	6a 00                	push   $0x0
  802c63:	e8 a6 e5 ff ff       	call   80120e <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802c68:	89 1c 24             	mov    %ebx,(%esp)
  802c6b:	e8 f9 ec ff ff       	call   801969 <fd2data>
  802c70:	83 c4 08             	add    $0x8,%esp
  802c73:	50                   	push   %eax
  802c74:	6a 00                	push   $0x0
  802c76:	e8 93 e5 ff ff       	call   80120e <sys_page_unmap>
}
  802c7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802c7e:	c9                   	leave  
  802c7f:	c3                   	ret    

00802c80 <_pipeisclosed>:
{
  802c80:	55                   	push   %ebp
  802c81:	89 e5                	mov    %esp,%ebp
  802c83:	57                   	push   %edi
  802c84:	56                   	push   %esi
  802c85:	53                   	push   %ebx
  802c86:	83 ec 1c             	sub    $0x1c,%esp
  802c89:	89 c7                	mov    %eax,%edi
  802c8b:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802c8d:	a1 08 50 80 00       	mov    0x805008,%eax
  802c92:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802c95:	83 ec 0c             	sub    $0xc,%esp
  802c98:	57                   	push   %edi
  802c99:	e8 98 04 00 00       	call   803136 <pageref>
  802c9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802ca1:	89 34 24             	mov    %esi,(%esp)
  802ca4:	e8 8d 04 00 00       	call   803136 <pageref>
		nn = thisenv->env_runs;
  802ca9:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802caf:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802cb2:	83 c4 10             	add    $0x10,%esp
  802cb5:	39 cb                	cmp    %ecx,%ebx
  802cb7:	74 1b                	je     802cd4 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802cb9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802cbc:	75 cf                	jne    802c8d <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802cbe:	8b 42 58             	mov    0x58(%edx),%eax
  802cc1:	6a 01                	push   $0x1
  802cc3:	50                   	push   %eax
  802cc4:	53                   	push   %ebx
  802cc5:	68 ea 3b 80 00       	push   $0x803bea
  802cca:	e8 69 d9 ff ff       	call   800638 <cprintf>
  802ccf:	83 c4 10             	add    $0x10,%esp
  802cd2:	eb b9                	jmp    802c8d <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802cd4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802cd7:	0f 94 c0             	sete   %al
  802cda:	0f b6 c0             	movzbl %al,%eax
}
  802cdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802ce0:	5b                   	pop    %ebx
  802ce1:	5e                   	pop    %esi
  802ce2:	5f                   	pop    %edi
  802ce3:	5d                   	pop    %ebp
  802ce4:	c3                   	ret    

00802ce5 <devpipe_write>:
{
  802ce5:	55                   	push   %ebp
  802ce6:	89 e5                	mov    %esp,%ebp
  802ce8:	57                   	push   %edi
  802ce9:	56                   	push   %esi
  802cea:	53                   	push   %ebx
  802ceb:	83 ec 28             	sub    $0x28,%esp
  802cee:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802cf1:	56                   	push   %esi
  802cf2:	e8 72 ec ff ff       	call   801969 <fd2data>
  802cf7:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802cf9:	83 c4 10             	add    $0x10,%esp
  802cfc:	bf 00 00 00 00       	mov    $0x0,%edi
  802d01:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802d04:	74 4f                	je     802d55 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802d06:	8b 43 04             	mov    0x4(%ebx),%eax
  802d09:	8b 0b                	mov    (%ebx),%ecx
  802d0b:	8d 51 20             	lea    0x20(%ecx),%edx
  802d0e:	39 d0                	cmp    %edx,%eax
  802d10:	72 14                	jb     802d26 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802d12:	89 da                	mov    %ebx,%edx
  802d14:	89 f0                	mov    %esi,%eax
  802d16:	e8 65 ff ff ff       	call   802c80 <_pipeisclosed>
  802d1b:	85 c0                	test   %eax,%eax
  802d1d:	75 3b                	jne    802d5a <devpipe_write+0x75>
			sys_yield();
  802d1f:	e8 46 e4 ff ff       	call   80116a <sys_yield>
  802d24:	eb e0                	jmp    802d06 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802d26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802d29:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802d2d:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802d30:	89 c2                	mov    %eax,%edx
  802d32:	c1 fa 1f             	sar    $0x1f,%edx
  802d35:	89 d1                	mov    %edx,%ecx
  802d37:	c1 e9 1b             	shr    $0x1b,%ecx
  802d3a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802d3d:	83 e2 1f             	and    $0x1f,%edx
  802d40:	29 ca                	sub    %ecx,%edx
  802d42:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802d46:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802d4a:	83 c0 01             	add    $0x1,%eax
  802d4d:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802d50:	83 c7 01             	add    $0x1,%edi
  802d53:	eb ac                	jmp    802d01 <devpipe_write+0x1c>
	return i;
  802d55:	8b 45 10             	mov    0x10(%ebp),%eax
  802d58:	eb 05                	jmp    802d5f <devpipe_write+0x7a>
				return 0;
  802d5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d62:	5b                   	pop    %ebx
  802d63:	5e                   	pop    %esi
  802d64:	5f                   	pop    %edi
  802d65:	5d                   	pop    %ebp
  802d66:	c3                   	ret    

00802d67 <devpipe_read>:
{
  802d67:	55                   	push   %ebp
  802d68:	89 e5                	mov    %esp,%ebp
  802d6a:	57                   	push   %edi
  802d6b:	56                   	push   %esi
  802d6c:	53                   	push   %ebx
  802d6d:	83 ec 18             	sub    $0x18,%esp
  802d70:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802d73:	57                   	push   %edi
  802d74:	e8 f0 eb ff ff       	call   801969 <fd2data>
  802d79:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802d7b:	83 c4 10             	add    $0x10,%esp
  802d7e:	be 00 00 00 00       	mov    $0x0,%esi
  802d83:	3b 75 10             	cmp    0x10(%ebp),%esi
  802d86:	75 14                	jne    802d9c <devpipe_read+0x35>
	return i;
  802d88:	8b 45 10             	mov    0x10(%ebp),%eax
  802d8b:	eb 02                	jmp    802d8f <devpipe_read+0x28>
				return i;
  802d8d:	89 f0                	mov    %esi,%eax
}
  802d8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d92:	5b                   	pop    %ebx
  802d93:	5e                   	pop    %esi
  802d94:	5f                   	pop    %edi
  802d95:	5d                   	pop    %ebp
  802d96:	c3                   	ret    
			sys_yield();
  802d97:	e8 ce e3 ff ff       	call   80116a <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802d9c:	8b 03                	mov    (%ebx),%eax
  802d9e:	3b 43 04             	cmp    0x4(%ebx),%eax
  802da1:	75 18                	jne    802dbb <devpipe_read+0x54>
			if (i > 0)
  802da3:	85 f6                	test   %esi,%esi
  802da5:	75 e6                	jne    802d8d <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802da7:	89 da                	mov    %ebx,%edx
  802da9:	89 f8                	mov    %edi,%eax
  802dab:	e8 d0 fe ff ff       	call   802c80 <_pipeisclosed>
  802db0:	85 c0                	test   %eax,%eax
  802db2:	74 e3                	je     802d97 <devpipe_read+0x30>
				return 0;
  802db4:	b8 00 00 00 00       	mov    $0x0,%eax
  802db9:	eb d4                	jmp    802d8f <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802dbb:	99                   	cltd   
  802dbc:	c1 ea 1b             	shr    $0x1b,%edx
  802dbf:	01 d0                	add    %edx,%eax
  802dc1:	83 e0 1f             	and    $0x1f,%eax
  802dc4:	29 d0                	sub    %edx,%eax
  802dc6:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802dcb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802dce:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802dd1:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802dd4:	83 c6 01             	add    $0x1,%esi
  802dd7:	eb aa                	jmp    802d83 <devpipe_read+0x1c>

00802dd9 <pipe>:
{
  802dd9:	55                   	push   %ebp
  802dda:	89 e5                	mov    %esp,%ebp
  802ddc:	56                   	push   %esi
  802ddd:	53                   	push   %ebx
  802dde:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802de1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802de4:	50                   	push   %eax
  802de5:	e8 96 eb ff ff       	call   801980 <fd_alloc>
  802dea:	89 c3                	mov    %eax,%ebx
  802dec:	83 c4 10             	add    $0x10,%esp
  802def:	85 c0                	test   %eax,%eax
  802df1:	0f 88 23 01 00 00    	js     802f1a <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802df7:	83 ec 04             	sub    $0x4,%esp
  802dfa:	68 07 04 00 00       	push   $0x407
  802dff:	ff 75 f4             	pushl  -0xc(%ebp)
  802e02:	6a 00                	push   $0x0
  802e04:	e8 80 e3 ff ff       	call   801189 <sys_page_alloc>
  802e09:	89 c3                	mov    %eax,%ebx
  802e0b:	83 c4 10             	add    $0x10,%esp
  802e0e:	85 c0                	test   %eax,%eax
  802e10:	0f 88 04 01 00 00    	js     802f1a <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802e16:	83 ec 0c             	sub    $0xc,%esp
  802e19:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802e1c:	50                   	push   %eax
  802e1d:	e8 5e eb ff ff       	call   801980 <fd_alloc>
  802e22:	89 c3                	mov    %eax,%ebx
  802e24:	83 c4 10             	add    $0x10,%esp
  802e27:	85 c0                	test   %eax,%eax
  802e29:	0f 88 db 00 00 00    	js     802f0a <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e2f:	83 ec 04             	sub    $0x4,%esp
  802e32:	68 07 04 00 00       	push   $0x407
  802e37:	ff 75 f0             	pushl  -0x10(%ebp)
  802e3a:	6a 00                	push   $0x0
  802e3c:	e8 48 e3 ff ff       	call   801189 <sys_page_alloc>
  802e41:	89 c3                	mov    %eax,%ebx
  802e43:	83 c4 10             	add    $0x10,%esp
  802e46:	85 c0                	test   %eax,%eax
  802e48:	0f 88 bc 00 00 00    	js     802f0a <pipe+0x131>
	va = fd2data(fd0);
  802e4e:	83 ec 0c             	sub    $0xc,%esp
  802e51:	ff 75 f4             	pushl  -0xc(%ebp)
  802e54:	e8 10 eb ff ff       	call   801969 <fd2data>
  802e59:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e5b:	83 c4 0c             	add    $0xc,%esp
  802e5e:	68 07 04 00 00       	push   $0x407
  802e63:	50                   	push   %eax
  802e64:	6a 00                	push   $0x0
  802e66:	e8 1e e3 ff ff       	call   801189 <sys_page_alloc>
  802e6b:	89 c3                	mov    %eax,%ebx
  802e6d:	83 c4 10             	add    $0x10,%esp
  802e70:	85 c0                	test   %eax,%eax
  802e72:	0f 88 82 00 00 00    	js     802efa <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e78:	83 ec 0c             	sub    $0xc,%esp
  802e7b:	ff 75 f0             	pushl  -0x10(%ebp)
  802e7e:	e8 e6 ea ff ff       	call   801969 <fd2data>
  802e83:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802e8a:	50                   	push   %eax
  802e8b:	6a 00                	push   $0x0
  802e8d:	56                   	push   %esi
  802e8e:	6a 00                	push   $0x0
  802e90:	e8 37 e3 ff ff       	call   8011cc <sys_page_map>
  802e95:	89 c3                	mov    %eax,%ebx
  802e97:	83 c4 20             	add    $0x20,%esp
  802e9a:	85 c0                	test   %eax,%eax
  802e9c:	78 4e                	js     802eec <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802e9e:	a1 58 40 80 00       	mov    0x804058,%eax
  802ea3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ea6:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802ea8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eab:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802eb2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802eb5:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802eb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eba:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802ec1:	83 ec 0c             	sub    $0xc,%esp
  802ec4:	ff 75 f4             	pushl  -0xc(%ebp)
  802ec7:	e8 8d ea ff ff       	call   801959 <fd2num>
  802ecc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802ecf:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802ed1:	83 c4 04             	add    $0x4,%esp
  802ed4:	ff 75 f0             	pushl  -0x10(%ebp)
  802ed7:	e8 7d ea ff ff       	call   801959 <fd2num>
  802edc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802edf:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802ee2:	83 c4 10             	add    $0x10,%esp
  802ee5:	bb 00 00 00 00       	mov    $0x0,%ebx
  802eea:	eb 2e                	jmp    802f1a <pipe+0x141>
	sys_page_unmap(0, va);
  802eec:	83 ec 08             	sub    $0x8,%esp
  802eef:	56                   	push   %esi
  802ef0:	6a 00                	push   $0x0
  802ef2:	e8 17 e3 ff ff       	call   80120e <sys_page_unmap>
  802ef7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802efa:	83 ec 08             	sub    $0x8,%esp
  802efd:	ff 75 f0             	pushl  -0x10(%ebp)
  802f00:	6a 00                	push   $0x0
  802f02:	e8 07 e3 ff ff       	call   80120e <sys_page_unmap>
  802f07:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802f0a:	83 ec 08             	sub    $0x8,%esp
  802f0d:	ff 75 f4             	pushl  -0xc(%ebp)
  802f10:	6a 00                	push   $0x0
  802f12:	e8 f7 e2 ff ff       	call   80120e <sys_page_unmap>
  802f17:	83 c4 10             	add    $0x10,%esp
}
  802f1a:	89 d8                	mov    %ebx,%eax
  802f1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f1f:	5b                   	pop    %ebx
  802f20:	5e                   	pop    %esi
  802f21:	5d                   	pop    %ebp
  802f22:	c3                   	ret    

00802f23 <pipeisclosed>:
{
  802f23:	55                   	push   %ebp
  802f24:	89 e5                	mov    %esp,%ebp
  802f26:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f29:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f2c:	50                   	push   %eax
  802f2d:	ff 75 08             	pushl  0x8(%ebp)
  802f30:	e8 9d ea ff ff       	call   8019d2 <fd_lookup>
  802f35:	83 c4 10             	add    $0x10,%esp
  802f38:	85 c0                	test   %eax,%eax
  802f3a:	78 18                	js     802f54 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802f3c:	83 ec 0c             	sub    $0xc,%esp
  802f3f:	ff 75 f4             	pushl  -0xc(%ebp)
  802f42:	e8 22 ea ff ff       	call   801969 <fd2data>
	return _pipeisclosed(fd, p);
  802f47:	89 c2                	mov    %eax,%edx
  802f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4c:	e8 2f fd ff ff       	call   802c80 <_pipeisclosed>
  802f51:	83 c4 10             	add    $0x10,%esp
}
  802f54:	c9                   	leave  
  802f55:	c3                   	ret    

00802f56 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802f56:	55                   	push   %ebp
  802f57:	89 e5                	mov    %esp,%ebp
  802f59:	56                   	push   %esi
  802f5a:	53                   	push   %ebx
  802f5b:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802f5e:	85 f6                	test   %esi,%esi
  802f60:	74 13                	je     802f75 <wait+0x1f>
	e = &envs[ENVX(envid)];
  802f62:	89 f3                	mov    %esi,%ebx
  802f64:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802f6a:	c1 e3 07             	shl    $0x7,%ebx
  802f6d:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802f73:	eb 1b                	jmp    802f90 <wait+0x3a>
	assert(envid != 0);
  802f75:	68 02 3c 80 00       	push   $0x803c02
  802f7a:	68 9f 3a 80 00       	push   $0x803a9f
  802f7f:	6a 09                	push   $0x9
  802f81:	68 0d 3c 80 00       	push   $0x803c0d
  802f86:	e8 b7 d5 ff ff       	call   800542 <_panic>
		sys_yield();
  802f8b:	e8 da e1 ff ff       	call   80116a <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802f90:	8b 43 48             	mov    0x48(%ebx),%eax
  802f93:	39 f0                	cmp    %esi,%eax
  802f95:	75 07                	jne    802f9e <wait+0x48>
  802f97:	8b 43 54             	mov    0x54(%ebx),%eax
  802f9a:	85 c0                	test   %eax,%eax
  802f9c:	75 ed                	jne    802f8b <wait+0x35>
}
  802f9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802fa1:	5b                   	pop    %ebx
  802fa2:	5e                   	pop    %esi
  802fa3:	5d                   	pop    %ebp
  802fa4:	c3                   	ret    

00802fa5 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802fa5:	55                   	push   %ebp
  802fa6:	89 e5                	mov    %esp,%ebp
  802fa8:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802fab:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802fb2:	74 0a                	je     802fbe <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb7:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802fbc:	c9                   	leave  
  802fbd:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802fbe:	83 ec 04             	sub    $0x4,%esp
  802fc1:	6a 07                	push   $0x7
  802fc3:	68 00 f0 bf ee       	push   $0xeebff000
  802fc8:	6a 00                	push   $0x0
  802fca:	e8 ba e1 ff ff       	call   801189 <sys_page_alloc>
		if(r < 0)
  802fcf:	83 c4 10             	add    $0x10,%esp
  802fd2:	85 c0                	test   %eax,%eax
  802fd4:	78 2a                	js     803000 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802fd6:	83 ec 08             	sub    $0x8,%esp
  802fd9:	68 14 30 80 00       	push   $0x803014
  802fde:	6a 00                	push   $0x0
  802fe0:	e8 ef e2 ff ff       	call   8012d4 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802fe5:	83 c4 10             	add    $0x10,%esp
  802fe8:	85 c0                	test   %eax,%eax
  802fea:	79 c8                	jns    802fb4 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802fec:	83 ec 04             	sub    $0x4,%esp
  802fef:	68 48 3c 80 00       	push   $0x803c48
  802ff4:	6a 25                	push   $0x25
  802ff6:	68 84 3c 80 00       	push   $0x803c84
  802ffb:	e8 42 d5 ff ff       	call   800542 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  803000:	83 ec 04             	sub    $0x4,%esp
  803003:	68 18 3c 80 00       	push   $0x803c18
  803008:	6a 22                	push   $0x22
  80300a:	68 84 3c 80 00       	push   $0x803c84
  80300f:	e8 2e d5 ff ff       	call   800542 <_panic>

00803014 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  803014:	54                   	push   %esp
	movl _pgfault_handler, %eax
  803015:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  80301a:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80301c:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  80301f:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  803023:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  803027:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80302a:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  80302c:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  803030:	83 c4 08             	add    $0x8,%esp
	popal
  803033:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  803034:	83 c4 04             	add    $0x4,%esp
	popfl
  803037:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  803038:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  803039:	c3                   	ret    

0080303a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80303a:	55                   	push   %ebp
  80303b:	89 e5                	mov    %esp,%ebp
  80303d:	56                   	push   %esi
  80303e:	53                   	push   %ebx
  80303f:	8b 75 08             	mov    0x8(%ebp),%esi
  803042:	8b 45 0c             	mov    0xc(%ebp),%eax
  803045:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  803048:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80304a:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80304f:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  803052:	83 ec 0c             	sub    $0xc,%esp
  803055:	50                   	push   %eax
  803056:	e8 de e2 ff ff       	call   801339 <sys_ipc_recv>
	if(ret < 0){
  80305b:	83 c4 10             	add    $0x10,%esp
  80305e:	85 c0                	test   %eax,%eax
  803060:	78 2b                	js     80308d <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  803062:	85 f6                	test   %esi,%esi
  803064:	74 0a                	je     803070 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  803066:	a1 08 50 80 00       	mov    0x805008,%eax
  80306b:	8b 40 74             	mov    0x74(%eax),%eax
  80306e:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  803070:	85 db                	test   %ebx,%ebx
  803072:	74 0a                	je     80307e <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  803074:	a1 08 50 80 00       	mov    0x805008,%eax
  803079:	8b 40 78             	mov    0x78(%eax),%eax
  80307c:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  80307e:	a1 08 50 80 00       	mov    0x805008,%eax
  803083:	8b 40 70             	mov    0x70(%eax),%eax
}
  803086:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803089:	5b                   	pop    %ebx
  80308a:	5e                   	pop    %esi
  80308b:	5d                   	pop    %ebp
  80308c:	c3                   	ret    
		if(from_env_store)
  80308d:	85 f6                	test   %esi,%esi
  80308f:	74 06                	je     803097 <ipc_recv+0x5d>
			*from_env_store = 0;
  803091:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  803097:	85 db                	test   %ebx,%ebx
  803099:	74 eb                	je     803086 <ipc_recv+0x4c>
			*perm_store = 0;
  80309b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8030a1:	eb e3                	jmp    803086 <ipc_recv+0x4c>

008030a3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8030a3:	55                   	push   %ebp
  8030a4:	89 e5                	mov    %esp,%ebp
  8030a6:	57                   	push   %edi
  8030a7:	56                   	push   %esi
  8030a8:	53                   	push   %ebx
  8030a9:	83 ec 0c             	sub    $0xc,%esp
  8030ac:	8b 7d 08             	mov    0x8(%ebp),%edi
  8030af:	8b 75 0c             	mov    0xc(%ebp),%esi
  8030b2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8030b5:	85 db                	test   %ebx,%ebx
  8030b7:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8030bc:	0f 44 d8             	cmove  %eax,%ebx
  8030bf:	eb 05                	jmp    8030c6 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8030c1:	e8 a4 e0 ff ff       	call   80116a <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8030c6:	ff 75 14             	pushl  0x14(%ebp)
  8030c9:	53                   	push   %ebx
  8030ca:	56                   	push   %esi
  8030cb:	57                   	push   %edi
  8030cc:	e8 45 e2 ff ff       	call   801316 <sys_ipc_try_send>
  8030d1:	83 c4 10             	add    $0x10,%esp
  8030d4:	85 c0                	test   %eax,%eax
  8030d6:	74 1b                	je     8030f3 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8030d8:	79 e7                	jns    8030c1 <ipc_send+0x1e>
  8030da:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8030dd:	74 e2                	je     8030c1 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8030df:	83 ec 04             	sub    $0x4,%esp
  8030e2:	68 92 3c 80 00       	push   $0x803c92
  8030e7:	6a 48                	push   $0x48
  8030e9:	68 a7 3c 80 00       	push   $0x803ca7
  8030ee:	e8 4f d4 ff ff       	call   800542 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8030f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8030f6:	5b                   	pop    %ebx
  8030f7:	5e                   	pop    %esi
  8030f8:	5f                   	pop    %edi
  8030f9:	5d                   	pop    %ebp
  8030fa:	c3                   	ret    

008030fb <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8030fb:	55                   	push   %ebp
  8030fc:	89 e5                	mov    %esp,%ebp
  8030fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  803101:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  803106:	89 c2                	mov    %eax,%edx
  803108:	c1 e2 07             	shl    $0x7,%edx
  80310b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  803111:	8b 52 50             	mov    0x50(%edx),%edx
  803114:	39 ca                	cmp    %ecx,%edx
  803116:	74 11                	je     803129 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  803118:	83 c0 01             	add    $0x1,%eax
  80311b:	3d 00 04 00 00       	cmp    $0x400,%eax
  803120:	75 e4                	jne    803106 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  803122:	b8 00 00 00 00       	mov    $0x0,%eax
  803127:	eb 0b                	jmp    803134 <ipc_find_env+0x39>
			return envs[i].env_id;
  803129:	c1 e0 07             	shl    $0x7,%eax
  80312c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  803131:	8b 40 48             	mov    0x48(%eax),%eax
}
  803134:	5d                   	pop    %ebp
  803135:	c3                   	ret    

00803136 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803136:	55                   	push   %ebp
  803137:	89 e5                	mov    %esp,%ebp
  803139:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80313c:	89 d0                	mov    %edx,%eax
  80313e:	c1 e8 16             	shr    $0x16,%eax
  803141:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  803148:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80314d:	f6 c1 01             	test   $0x1,%cl
  803150:	74 1d                	je     80316f <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  803152:	c1 ea 0c             	shr    $0xc,%edx
  803155:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80315c:	f6 c2 01             	test   $0x1,%dl
  80315f:	74 0e                	je     80316f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803161:	c1 ea 0c             	shr    $0xc,%edx
  803164:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80316b:	ef 
  80316c:	0f b7 c0             	movzwl %ax,%eax
}
  80316f:	5d                   	pop    %ebp
  803170:	c3                   	ret    
  803171:	66 90                	xchg   %ax,%ax
  803173:	66 90                	xchg   %ax,%ax
  803175:	66 90                	xchg   %ax,%ax
  803177:	66 90                	xchg   %ax,%ax
  803179:	66 90                	xchg   %ax,%ax
  80317b:	66 90                	xchg   %ax,%ax
  80317d:	66 90                	xchg   %ax,%ax
  80317f:	90                   	nop

00803180 <__udivdi3>:
  803180:	55                   	push   %ebp
  803181:	57                   	push   %edi
  803182:	56                   	push   %esi
  803183:	53                   	push   %ebx
  803184:	83 ec 1c             	sub    $0x1c,%esp
  803187:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80318b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80318f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803193:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  803197:	85 d2                	test   %edx,%edx
  803199:	75 4d                	jne    8031e8 <__udivdi3+0x68>
  80319b:	39 f3                	cmp    %esi,%ebx
  80319d:	76 19                	jbe    8031b8 <__udivdi3+0x38>
  80319f:	31 ff                	xor    %edi,%edi
  8031a1:	89 e8                	mov    %ebp,%eax
  8031a3:	89 f2                	mov    %esi,%edx
  8031a5:	f7 f3                	div    %ebx
  8031a7:	89 fa                	mov    %edi,%edx
  8031a9:	83 c4 1c             	add    $0x1c,%esp
  8031ac:	5b                   	pop    %ebx
  8031ad:	5e                   	pop    %esi
  8031ae:	5f                   	pop    %edi
  8031af:	5d                   	pop    %ebp
  8031b0:	c3                   	ret    
  8031b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8031b8:	89 d9                	mov    %ebx,%ecx
  8031ba:	85 db                	test   %ebx,%ebx
  8031bc:	75 0b                	jne    8031c9 <__udivdi3+0x49>
  8031be:	b8 01 00 00 00       	mov    $0x1,%eax
  8031c3:	31 d2                	xor    %edx,%edx
  8031c5:	f7 f3                	div    %ebx
  8031c7:	89 c1                	mov    %eax,%ecx
  8031c9:	31 d2                	xor    %edx,%edx
  8031cb:	89 f0                	mov    %esi,%eax
  8031cd:	f7 f1                	div    %ecx
  8031cf:	89 c6                	mov    %eax,%esi
  8031d1:	89 e8                	mov    %ebp,%eax
  8031d3:	89 f7                	mov    %esi,%edi
  8031d5:	f7 f1                	div    %ecx
  8031d7:	89 fa                	mov    %edi,%edx
  8031d9:	83 c4 1c             	add    $0x1c,%esp
  8031dc:	5b                   	pop    %ebx
  8031dd:	5e                   	pop    %esi
  8031de:	5f                   	pop    %edi
  8031df:	5d                   	pop    %ebp
  8031e0:	c3                   	ret    
  8031e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8031e8:	39 f2                	cmp    %esi,%edx
  8031ea:	77 1c                	ja     803208 <__udivdi3+0x88>
  8031ec:	0f bd fa             	bsr    %edx,%edi
  8031ef:	83 f7 1f             	xor    $0x1f,%edi
  8031f2:	75 2c                	jne    803220 <__udivdi3+0xa0>
  8031f4:	39 f2                	cmp    %esi,%edx
  8031f6:	72 06                	jb     8031fe <__udivdi3+0x7e>
  8031f8:	31 c0                	xor    %eax,%eax
  8031fa:	39 eb                	cmp    %ebp,%ebx
  8031fc:	77 a9                	ja     8031a7 <__udivdi3+0x27>
  8031fe:	b8 01 00 00 00       	mov    $0x1,%eax
  803203:	eb a2                	jmp    8031a7 <__udivdi3+0x27>
  803205:	8d 76 00             	lea    0x0(%esi),%esi
  803208:	31 ff                	xor    %edi,%edi
  80320a:	31 c0                	xor    %eax,%eax
  80320c:	89 fa                	mov    %edi,%edx
  80320e:	83 c4 1c             	add    $0x1c,%esp
  803211:	5b                   	pop    %ebx
  803212:	5e                   	pop    %esi
  803213:	5f                   	pop    %edi
  803214:	5d                   	pop    %ebp
  803215:	c3                   	ret    
  803216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80321d:	8d 76 00             	lea    0x0(%esi),%esi
  803220:	89 f9                	mov    %edi,%ecx
  803222:	b8 20 00 00 00       	mov    $0x20,%eax
  803227:	29 f8                	sub    %edi,%eax
  803229:	d3 e2                	shl    %cl,%edx
  80322b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80322f:	89 c1                	mov    %eax,%ecx
  803231:	89 da                	mov    %ebx,%edx
  803233:	d3 ea                	shr    %cl,%edx
  803235:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803239:	09 d1                	or     %edx,%ecx
  80323b:	89 f2                	mov    %esi,%edx
  80323d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803241:	89 f9                	mov    %edi,%ecx
  803243:	d3 e3                	shl    %cl,%ebx
  803245:	89 c1                	mov    %eax,%ecx
  803247:	d3 ea                	shr    %cl,%edx
  803249:	89 f9                	mov    %edi,%ecx
  80324b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80324f:	89 eb                	mov    %ebp,%ebx
  803251:	d3 e6                	shl    %cl,%esi
  803253:	89 c1                	mov    %eax,%ecx
  803255:	d3 eb                	shr    %cl,%ebx
  803257:	09 de                	or     %ebx,%esi
  803259:	89 f0                	mov    %esi,%eax
  80325b:	f7 74 24 08          	divl   0x8(%esp)
  80325f:	89 d6                	mov    %edx,%esi
  803261:	89 c3                	mov    %eax,%ebx
  803263:	f7 64 24 0c          	mull   0xc(%esp)
  803267:	39 d6                	cmp    %edx,%esi
  803269:	72 15                	jb     803280 <__udivdi3+0x100>
  80326b:	89 f9                	mov    %edi,%ecx
  80326d:	d3 e5                	shl    %cl,%ebp
  80326f:	39 c5                	cmp    %eax,%ebp
  803271:	73 04                	jae    803277 <__udivdi3+0xf7>
  803273:	39 d6                	cmp    %edx,%esi
  803275:	74 09                	je     803280 <__udivdi3+0x100>
  803277:	89 d8                	mov    %ebx,%eax
  803279:	31 ff                	xor    %edi,%edi
  80327b:	e9 27 ff ff ff       	jmp    8031a7 <__udivdi3+0x27>
  803280:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803283:	31 ff                	xor    %edi,%edi
  803285:	e9 1d ff ff ff       	jmp    8031a7 <__udivdi3+0x27>
  80328a:	66 90                	xchg   %ax,%ax
  80328c:	66 90                	xchg   %ax,%ax
  80328e:	66 90                	xchg   %ax,%ax

00803290 <__umoddi3>:
  803290:	55                   	push   %ebp
  803291:	57                   	push   %edi
  803292:	56                   	push   %esi
  803293:	53                   	push   %ebx
  803294:	83 ec 1c             	sub    $0x1c,%esp
  803297:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80329b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80329f:	8b 74 24 30          	mov    0x30(%esp),%esi
  8032a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032a7:	89 da                	mov    %ebx,%edx
  8032a9:	85 c0                	test   %eax,%eax
  8032ab:	75 43                	jne    8032f0 <__umoddi3+0x60>
  8032ad:	39 df                	cmp    %ebx,%edi
  8032af:	76 17                	jbe    8032c8 <__umoddi3+0x38>
  8032b1:	89 f0                	mov    %esi,%eax
  8032b3:	f7 f7                	div    %edi
  8032b5:	89 d0                	mov    %edx,%eax
  8032b7:	31 d2                	xor    %edx,%edx
  8032b9:	83 c4 1c             	add    $0x1c,%esp
  8032bc:	5b                   	pop    %ebx
  8032bd:	5e                   	pop    %esi
  8032be:	5f                   	pop    %edi
  8032bf:	5d                   	pop    %ebp
  8032c0:	c3                   	ret    
  8032c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8032c8:	89 fd                	mov    %edi,%ebp
  8032ca:	85 ff                	test   %edi,%edi
  8032cc:	75 0b                	jne    8032d9 <__umoddi3+0x49>
  8032ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8032d3:	31 d2                	xor    %edx,%edx
  8032d5:	f7 f7                	div    %edi
  8032d7:	89 c5                	mov    %eax,%ebp
  8032d9:	89 d8                	mov    %ebx,%eax
  8032db:	31 d2                	xor    %edx,%edx
  8032dd:	f7 f5                	div    %ebp
  8032df:	89 f0                	mov    %esi,%eax
  8032e1:	f7 f5                	div    %ebp
  8032e3:	89 d0                	mov    %edx,%eax
  8032e5:	eb d0                	jmp    8032b7 <__umoddi3+0x27>
  8032e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8032ee:	66 90                	xchg   %ax,%ax
  8032f0:	89 f1                	mov    %esi,%ecx
  8032f2:	39 d8                	cmp    %ebx,%eax
  8032f4:	76 0a                	jbe    803300 <__umoddi3+0x70>
  8032f6:	89 f0                	mov    %esi,%eax
  8032f8:	83 c4 1c             	add    $0x1c,%esp
  8032fb:	5b                   	pop    %ebx
  8032fc:	5e                   	pop    %esi
  8032fd:	5f                   	pop    %edi
  8032fe:	5d                   	pop    %ebp
  8032ff:	c3                   	ret    
  803300:	0f bd e8             	bsr    %eax,%ebp
  803303:	83 f5 1f             	xor    $0x1f,%ebp
  803306:	75 20                	jne    803328 <__umoddi3+0x98>
  803308:	39 d8                	cmp    %ebx,%eax
  80330a:	0f 82 b0 00 00 00    	jb     8033c0 <__umoddi3+0x130>
  803310:	39 f7                	cmp    %esi,%edi
  803312:	0f 86 a8 00 00 00    	jbe    8033c0 <__umoddi3+0x130>
  803318:	89 c8                	mov    %ecx,%eax
  80331a:	83 c4 1c             	add    $0x1c,%esp
  80331d:	5b                   	pop    %ebx
  80331e:	5e                   	pop    %esi
  80331f:	5f                   	pop    %edi
  803320:	5d                   	pop    %ebp
  803321:	c3                   	ret    
  803322:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803328:	89 e9                	mov    %ebp,%ecx
  80332a:	ba 20 00 00 00       	mov    $0x20,%edx
  80332f:	29 ea                	sub    %ebp,%edx
  803331:	d3 e0                	shl    %cl,%eax
  803333:	89 44 24 08          	mov    %eax,0x8(%esp)
  803337:	89 d1                	mov    %edx,%ecx
  803339:	89 f8                	mov    %edi,%eax
  80333b:	d3 e8                	shr    %cl,%eax
  80333d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803341:	89 54 24 04          	mov    %edx,0x4(%esp)
  803345:	8b 54 24 04          	mov    0x4(%esp),%edx
  803349:	09 c1                	or     %eax,%ecx
  80334b:	89 d8                	mov    %ebx,%eax
  80334d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803351:	89 e9                	mov    %ebp,%ecx
  803353:	d3 e7                	shl    %cl,%edi
  803355:	89 d1                	mov    %edx,%ecx
  803357:	d3 e8                	shr    %cl,%eax
  803359:	89 e9                	mov    %ebp,%ecx
  80335b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80335f:	d3 e3                	shl    %cl,%ebx
  803361:	89 c7                	mov    %eax,%edi
  803363:	89 d1                	mov    %edx,%ecx
  803365:	89 f0                	mov    %esi,%eax
  803367:	d3 e8                	shr    %cl,%eax
  803369:	89 e9                	mov    %ebp,%ecx
  80336b:	89 fa                	mov    %edi,%edx
  80336d:	d3 e6                	shl    %cl,%esi
  80336f:	09 d8                	or     %ebx,%eax
  803371:	f7 74 24 08          	divl   0x8(%esp)
  803375:	89 d1                	mov    %edx,%ecx
  803377:	89 f3                	mov    %esi,%ebx
  803379:	f7 64 24 0c          	mull   0xc(%esp)
  80337d:	89 c6                	mov    %eax,%esi
  80337f:	89 d7                	mov    %edx,%edi
  803381:	39 d1                	cmp    %edx,%ecx
  803383:	72 06                	jb     80338b <__umoddi3+0xfb>
  803385:	75 10                	jne    803397 <__umoddi3+0x107>
  803387:	39 c3                	cmp    %eax,%ebx
  803389:	73 0c                	jae    803397 <__umoddi3+0x107>
  80338b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80338f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  803393:	89 d7                	mov    %edx,%edi
  803395:	89 c6                	mov    %eax,%esi
  803397:	89 ca                	mov    %ecx,%edx
  803399:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80339e:	29 f3                	sub    %esi,%ebx
  8033a0:	19 fa                	sbb    %edi,%edx
  8033a2:	89 d0                	mov    %edx,%eax
  8033a4:	d3 e0                	shl    %cl,%eax
  8033a6:	89 e9                	mov    %ebp,%ecx
  8033a8:	d3 eb                	shr    %cl,%ebx
  8033aa:	d3 ea                	shr    %cl,%edx
  8033ac:	09 d8                	or     %ebx,%eax
  8033ae:	83 c4 1c             	add    $0x1c,%esp
  8033b1:	5b                   	pop    %ebx
  8033b2:	5e                   	pop    %esi
  8033b3:	5f                   	pop    %edi
  8033b4:	5d                   	pop    %ebp
  8033b5:	c3                   	ret    
  8033b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8033bd:	8d 76 00             	lea    0x0(%esi),%esi
  8033c0:	89 da                	mov    %ebx,%edx
  8033c2:	29 fe                	sub    %edi,%esi
  8033c4:	19 c2                	sbb    %eax,%edx
  8033c6:	89 f1                	mov    %esi,%ecx
  8033c8:	89 c8                	mov    %ecx,%eax
  8033ca:	e9 4b ff ff ff       	jmp    80331a <__umoddi3+0x8a>
