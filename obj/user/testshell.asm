
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
  80004a:	e8 14 1d 00 00       	call   801d63 <seek>
	seek(kfd, off);
  80004f:	83 c4 08             	add    $0x8,%esp
  800052:	53                   	push   %ebx
  800053:	57                   	push   %edi
  800054:	e8 0a 1d 00 00       	call   801d63 <seek>

	cprintf("shell produced incorrect output.\n");
  800059:	c7 04 24 a0 33 80 00 	movl   $0x8033a0,(%esp)
  800060:	e8 94 05 00 00       	call   8005f9 <cprintf>
	cprintf("expected:\n===\n");
  800065:	c7 04 24 0b 34 80 00 	movl   $0x80340b,(%esp)
  80006c:	e8 88 05 00 00       	call   8005f9 <cprintf>
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800071:	83 c4 10             	add    $0x10,%esp
  800074:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  800077:	83 ec 04             	sub    $0x4,%esp
  80007a:	6a 63                	push   $0x63
  80007c:	53                   	push   %ebx
  80007d:	57                   	push   %edi
  80007e:	e8 92 1b 00 00       	call   801c15 <read>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	85 c0                	test   %eax,%eax
  800088:	7e 0f                	jle    800099 <wrong+0x66>
		sys_cputs(buf, n);
  80008a:	83 ec 08             	sub    $0x8,%esp
  80008d:	50                   	push   %eax
  80008e:	53                   	push   %ebx
  80008f:	e8 fa 0f 00 00       	call   80108e <sys_cputs>
  800094:	83 c4 10             	add    $0x10,%esp
  800097:	eb de                	jmp    800077 <wrong+0x44>
	cprintf("===\ngot:\n===\n");
  800099:	83 ec 0c             	sub    $0xc,%esp
  80009c:	68 1a 34 80 00       	push   $0x80341a
  8000a1:	e8 53 05 00 00       	call   8005f9 <cprintf>
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000a6:	83 c4 10             	add    $0x10,%esp
  8000a9:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  8000ac:	eb 0d                	jmp    8000bb <wrong+0x88>
		sys_cputs(buf, n);
  8000ae:	83 ec 08             	sub    $0x8,%esp
  8000b1:	50                   	push   %eax
  8000b2:	53                   	push   %ebx
  8000b3:	e8 d6 0f 00 00       	call   80108e <sys_cputs>
  8000b8:	83 c4 10             	add    $0x10,%esp
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000bb:	83 ec 04             	sub    $0x4,%esp
  8000be:	6a 63                	push   $0x63
  8000c0:	53                   	push   %ebx
  8000c1:	56                   	push   %esi
  8000c2:	e8 4e 1b 00 00       	call   801c15 <read>
  8000c7:	83 c4 10             	add    $0x10,%esp
  8000ca:	85 c0                	test   %eax,%eax
  8000cc:	7f e0                	jg     8000ae <wrong+0x7b>
	cprintf("===\n");
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	68 15 34 80 00       	push   $0x803415
  8000d6:	e8 1e 05 00 00       	call   8005f9 <cprintf>
	exit();
  8000db:	e8 ef 03 00 00       	call   8004cf <exit>
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
  8000f6:	e8 dc 19 00 00       	call   801ad7 <close>
	close(1);
  8000fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800102:	e8 d0 19 00 00       	call   801ad7 <close>
	opencons();
  800107:	e8 28 03 00 00       	call   800434 <opencons>
	opencons();
  80010c:	e8 23 03 00 00       	call   800434 <opencons>
	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  800111:	83 c4 08             	add    $0x8,%esp
  800114:	6a 00                	push   $0x0
  800116:	68 28 34 80 00       	push   $0x803428
  80011b:	e8 93 1f 00 00       	call   8020b3 <open>
  800120:	89 c3                	mov    %eax,%ebx
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	85 c0                	test   %eax,%eax
  800127:	0f 88 e7 00 00 00    	js     800214 <umain+0x129>
	if ((wfd = pipe(pfds)) < 0)
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800133:	50                   	push   %eax
  800134:	e8 74 2c 00 00       	call   802dad <pipe>
  800139:	83 c4 10             	add    $0x10,%esp
  80013c:	85 c0                	test   %eax,%eax
  80013e:	0f 88 e2 00 00 00    	js     800226 <umain+0x13b>
	wfd = pfds[1];
  800144:	8b 75 e0             	mov    -0x20(%ebp),%esi
	cprintf("running sh -x < testshell.sh | cat\n");
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	68 c4 33 80 00       	push   $0x8033c4
  80014f:	e8 a5 04 00 00       	call   8005f9 <cprintf>
	if ((r = fork()) < 0)
  800154:	e8 3b 15 00 00       	call   801694 <fork>
  800159:	83 c4 10             	add    $0x10,%esp
  80015c:	85 c0                	test   %eax,%eax
  80015e:	0f 88 d4 00 00 00    	js     800238 <umain+0x14d>
	if (r == 0) {
  800164:	75 6f                	jne    8001d5 <umain+0xea>
		dup(rfd, 0);
  800166:	83 ec 08             	sub    $0x8,%esp
  800169:	6a 00                	push   $0x0
  80016b:	53                   	push   %ebx
  80016c:	e8 b8 19 00 00       	call   801b29 <dup>
		dup(wfd, 1);
  800171:	83 c4 08             	add    $0x8,%esp
  800174:	6a 01                	push   $0x1
  800176:	56                   	push   %esi
  800177:	e8 ad 19 00 00       	call   801b29 <dup>
		close(rfd);
  80017c:	89 1c 24             	mov    %ebx,(%esp)
  80017f:	e8 53 19 00 00       	call   801ad7 <close>
		close(wfd);
  800184:	89 34 24             	mov    %esi,(%esp)
  800187:	e8 4b 19 00 00       	call   801ad7 <close>
		if ((r = spawnl("/sh", "sh", "-x", 0)) < 0)
  80018c:	6a 00                	push   $0x0
  80018e:	68 6e 34 80 00       	push   $0x80346e
  800193:	68 32 34 80 00       	push   $0x803432
  800198:	68 71 34 80 00       	push   $0x803471
  80019d:	e8 44 25 00 00       	call   8026e6 <spawnl>
  8001a2:	89 c7                	mov    %eax,%edi
  8001a4:	83 c4 20             	add    $0x20,%esp
  8001a7:	85 c0                	test   %eax,%eax
  8001a9:	0f 88 9b 00 00 00    	js     80024a <umain+0x15f>
		close(0);
  8001af:	83 ec 0c             	sub    $0xc,%esp
  8001b2:	6a 00                	push   $0x0
  8001b4:	e8 1e 19 00 00       	call   801ad7 <close>
		close(1);
  8001b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001c0:	e8 12 19 00 00       	call   801ad7 <close>
		wait(r);
  8001c5:	89 3c 24             	mov    %edi,(%esp)
  8001c8:	e8 5d 2d 00 00       	call   802f2a <wait>
		exit();
  8001cd:	e8 fd 02 00 00       	call   8004cf <exit>
  8001d2:	83 c4 10             	add    $0x10,%esp
	close(rfd);
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	53                   	push   %ebx
  8001d9:	e8 f9 18 00 00       	call   801ad7 <close>
	close(wfd);
  8001de:	89 34 24             	mov    %esi,(%esp)
  8001e1:	e8 f1 18 00 00       	call   801ad7 <close>
	rfd = pfds[0];
  8001e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001e9:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8001ec:	83 c4 08             	add    $0x8,%esp
  8001ef:	6a 00                	push   $0x0
  8001f1:	68 7f 34 80 00       	push   $0x80347f
  8001f6:	e8 b8 1e 00 00       	call   8020b3 <open>
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
  800215:	68 35 34 80 00       	push   $0x803435
  80021a:	6a 13                	push   $0x13
  80021c:	68 4b 34 80 00       	push   $0x80344b
  800221:	e8 dd 02 00 00       	call   800503 <_panic>
		panic("pipe: %e", wfd);
  800226:	50                   	push   %eax
  800227:	68 5c 34 80 00       	push   $0x80345c
  80022c:	6a 15                	push   $0x15
  80022e:	68 4b 34 80 00       	push   $0x80344b
  800233:	e8 cb 02 00 00       	call   800503 <_panic>
		panic("fork: %e", r);
  800238:	50                   	push   %eax
  800239:	68 65 34 80 00       	push   $0x803465
  80023e:	6a 1a                	push   $0x1a
  800240:	68 4b 34 80 00       	push   $0x80344b
  800245:	e8 b9 02 00 00       	call   800503 <_panic>
			panic("spawn: %e", r);
  80024a:	50                   	push   %eax
  80024b:	68 75 34 80 00       	push   $0x803475
  800250:	6a 21                	push   $0x21
  800252:	68 4b 34 80 00       	push   $0x80344b
  800257:	e8 a7 02 00 00       	call   800503 <_panic>
		panic("open testshell.key for reading: %e", kfd);
  80025c:	50                   	push   %eax
  80025d:	68 e8 33 80 00       	push   $0x8033e8
  800262:	6a 2c                	push   $0x2c
  800264:	68 4b 34 80 00       	push   $0x80344b
  800269:	e8 95 02 00 00       	call   800503 <_panic>
			panic("reading testshell.out: %e", n1);
  80026e:	53                   	push   %ebx
  80026f:	68 8d 34 80 00       	push   $0x80348d
  800274:	6a 33                	push   $0x33
  800276:	68 4b 34 80 00       	push   $0x80344b
  80027b:	e8 83 02 00 00       	call   800503 <_panic>
			panic("reading testshell.key: %e", n2);
  800280:	50                   	push   %eax
  800281:	68 a7 34 80 00       	push   $0x8034a7
  800286:	6a 35                	push   $0x35
  800288:	68 4b 34 80 00       	push   $0x80344b
  80028d:	e8 71 02 00 00       	call   800503 <_panic>
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
  8002ba:	e8 56 19 00 00       	call   801c15 <read>
  8002bf:	89 c3                	mov    %eax,%ebx
		n2 = read(kfd, &c2, 1);
  8002c1:	83 c4 0c             	add    $0xc,%esp
  8002c4:	6a 01                	push   $0x1
  8002c6:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  8002c9:	50                   	push   %eax
  8002ca:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002cd:	e8 43 19 00 00       	call   801c15 <read>
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
  8002fb:	68 c1 34 80 00       	push   $0x8034c1
  800300:	e8 f4 02 00 00       	call   8005f9 <cprintf>
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
  80031d:	68 d6 34 80 00       	push   $0x8034d6
  800322:	ff 75 0c             	pushl  0xc(%ebp)
  800325:	e8 2e 0a 00 00       	call   800d58 <strcpy>
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
  800368:	e8 79 0b 00 00       	call   800ee6 <memmove>
		sys_cputs(buf, m);
  80036d:	83 c4 08             	add    $0x8,%esp
  800370:	53                   	push   %ebx
  800371:	57                   	push   %edi
  800372:	e8 17 0d 00 00       	call   80108e <sys_cputs>
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
  800399:	e8 0e 0d 00 00       	call   8010ac <sys_cgetc>
  80039e:	85 c0                	test   %eax,%eax
  8003a0:	75 07                	jne    8003a9 <devcons_read+0x21>
		sys_yield();
  8003a2:	e8 84 0d 00 00       	call   80112b <sys_yield>
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
  8003d5:	e8 b4 0c 00 00       	call   80108e <sys_cputs>
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
  8003ed:	e8 23 18 00 00       	call   801c15 <read>
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
  800415:	e8 8b 15 00 00       	call   8019a5 <fd_lookup>
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
  80043e:	e8 10 15 00 00       	call   801953 <fd_alloc>
  800443:	83 c4 10             	add    $0x10,%esp
  800446:	85 c0                	test   %eax,%eax
  800448:	78 3a                	js     800484 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80044a:	83 ec 04             	sub    $0x4,%esp
  80044d:	68 07 04 00 00       	push   $0x407
  800452:	ff 75 f4             	pushl  -0xc(%ebp)
  800455:	6a 00                	push   $0x0
  800457:	e8 ee 0c 00 00       	call   80114a <sys_page_alloc>
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
  80047c:	e8 ab 14 00 00       	call   80192c <fd2num>
  800481:	83 c4 10             	add    $0x10,%esp
}
  800484:	c9                   	leave  
  800485:	c3                   	ret    

00800486 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800486:	55                   	push   %ebp
  800487:	89 e5                	mov    %esp,%ebp
  800489:	56                   	push   %esi
  80048a:	53                   	push   %ebx
  80048b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80048e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  800491:	e8 76 0c 00 00       	call   80110c <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  800496:	25 ff 03 00 00       	and    $0x3ff,%eax
  80049b:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8004a1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004a6:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004ab:	85 db                	test   %ebx,%ebx
  8004ad:	7e 07                	jle    8004b6 <libmain+0x30>
		binaryname = argv[0];
  8004af:	8b 06                	mov    (%esi),%eax
  8004b1:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	umain(argc, argv);
  8004b6:	83 ec 08             	sub    $0x8,%esp
  8004b9:	56                   	push   %esi
  8004ba:	53                   	push   %ebx
  8004bb:	e8 2b fc ff ff       	call   8000eb <umain>

	// exit gracefully
	exit();
  8004c0:	e8 0a 00 00 00       	call   8004cf <exit>
}
  8004c5:	83 c4 10             	add    $0x10,%esp
  8004c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8004cb:	5b                   	pop    %ebx
  8004cc:	5e                   	pop    %esi
  8004cd:	5d                   	pop    %ebp
  8004ce:	c3                   	ret    

008004cf <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8004cf:	55                   	push   %ebp
  8004d0:	89 e5                	mov    %esp,%ebp
  8004d2:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8004d5:	a1 08 50 80 00       	mov    0x805008,%eax
  8004da:	8b 40 48             	mov    0x48(%eax),%eax
  8004dd:	68 f8 34 80 00       	push   $0x8034f8
  8004e2:	50                   	push   %eax
  8004e3:	68 ec 34 80 00       	push   $0x8034ec
  8004e8:	e8 0c 01 00 00       	call   8005f9 <cprintf>
	close_all();
  8004ed:	e8 12 16 00 00       	call   801b04 <close_all>
	sys_env_destroy(0);
  8004f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8004f9:	e8 cd 0b 00 00       	call   8010cb <sys_env_destroy>
}
  8004fe:	83 c4 10             	add    $0x10,%esp
  800501:	c9                   	leave  
  800502:	c3                   	ret    

00800503 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800503:	55                   	push   %ebp
  800504:	89 e5                	mov    %esp,%ebp
  800506:	56                   	push   %esi
  800507:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800508:	a1 08 50 80 00       	mov    0x805008,%eax
  80050d:	8b 40 48             	mov    0x48(%eax),%eax
  800510:	83 ec 04             	sub    $0x4,%esp
  800513:	68 24 35 80 00       	push   $0x803524
  800518:	50                   	push   %eax
  800519:	68 ec 34 80 00       	push   $0x8034ec
  80051e:	e8 d6 00 00 00       	call   8005f9 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800523:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800526:	8b 35 1c 40 80 00    	mov    0x80401c,%esi
  80052c:	e8 db 0b 00 00       	call   80110c <sys_getenvid>
  800531:	83 c4 04             	add    $0x4,%esp
  800534:	ff 75 0c             	pushl  0xc(%ebp)
  800537:	ff 75 08             	pushl  0x8(%ebp)
  80053a:	56                   	push   %esi
  80053b:	50                   	push   %eax
  80053c:	68 00 35 80 00       	push   $0x803500
  800541:	e8 b3 00 00 00       	call   8005f9 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800546:	83 c4 18             	add    $0x18,%esp
  800549:	53                   	push   %ebx
  80054a:	ff 75 10             	pushl  0x10(%ebp)
  80054d:	e8 56 00 00 00       	call   8005a8 <vcprintf>
	cprintf("\n");
  800552:	c7 04 24 21 39 80 00 	movl   $0x803921,(%esp)
  800559:	e8 9b 00 00 00       	call   8005f9 <cprintf>
  80055e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800561:	cc                   	int3   
  800562:	eb fd                	jmp    800561 <_panic+0x5e>

00800564 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800564:	55                   	push   %ebp
  800565:	89 e5                	mov    %esp,%ebp
  800567:	53                   	push   %ebx
  800568:	83 ec 04             	sub    $0x4,%esp
  80056b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80056e:	8b 13                	mov    (%ebx),%edx
  800570:	8d 42 01             	lea    0x1(%edx),%eax
  800573:	89 03                	mov    %eax,(%ebx)
  800575:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800578:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80057c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800581:	74 09                	je     80058c <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800583:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800587:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80058a:	c9                   	leave  
  80058b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80058c:	83 ec 08             	sub    $0x8,%esp
  80058f:	68 ff 00 00 00       	push   $0xff
  800594:	8d 43 08             	lea    0x8(%ebx),%eax
  800597:	50                   	push   %eax
  800598:	e8 f1 0a 00 00       	call   80108e <sys_cputs>
		b->idx = 0;
  80059d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8005a3:	83 c4 10             	add    $0x10,%esp
  8005a6:	eb db                	jmp    800583 <putch+0x1f>

008005a8 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8005a8:	55                   	push   %ebp
  8005a9:	89 e5                	mov    %esp,%ebp
  8005ab:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005b1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005b8:	00 00 00 
	b.cnt = 0;
  8005bb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005c2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8005c5:	ff 75 0c             	pushl  0xc(%ebp)
  8005c8:	ff 75 08             	pushl  0x8(%ebp)
  8005cb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005d1:	50                   	push   %eax
  8005d2:	68 64 05 80 00       	push   $0x800564
  8005d7:	e8 4a 01 00 00       	call   800726 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8005dc:	83 c4 08             	add    $0x8,%esp
  8005df:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8005e5:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8005eb:	50                   	push   %eax
  8005ec:	e8 9d 0a 00 00       	call   80108e <sys_cputs>

	return b.cnt;
}
  8005f1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8005f7:	c9                   	leave  
  8005f8:	c3                   	ret    

008005f9 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8005f9:	55                   	push   %ebp
  8005fa:	89 e5                	mov    %esp,%ebp
  8005fc:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005ff:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800602:	50                   	push   %eax
  800603:	ff 75 08             	pushl  0x8(%ebp)
  800606:	e8 9d ff ff ff       	call   8005a8 <vcprintf>
	va_end(ap);

	return cnt;
}
  80060b:	c9                   	leave  
  80060c:	c3                   	ret    

0080060d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80060d:	55                   	push   %ebp
  80060e:	89 e5                	mov    %esp,%ebp
  800610:	57                   	push   %edi
  800611:	56                   	push   %esi
  800612:	53                   	push   %ebx
  800613:	83 ec 1c             	sub    $0x1c,%esp
  800616:	89 c6                	mov    %eax,%esi
  800618:	89 d7                	mov    %edx,%edi
  80061a:	8b 45 08             	mov    0x8(%ebp),%eax
  80061d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800620:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800623:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800626:	8b 45 10             	mov    0x10(%ebp),%eax
  800629:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80062c:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800630:	74 2c                	je     80065e <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800632:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800635:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80063c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80063f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800642:	39 c2                	cmp    %eax,%edx
  800644:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800647:	73 43                	jae    80068c <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800649:	83 eb 01             	sub    $0x1,%ebx
  80064c:	85 db                	test   %ebx,%ebx
  80064e:	7e 6c                	jle    8006bc <printnum+0xaf>
				putch(padc, putdat);
  800650:	83 ec 08             	sub    $0x8,%esp
  800653:	57                   	push   %edi
  800654:	ff 75 18             	pushl  0x18(%ebp)
  800657:	ff d6                	call   *%esi
  800659:	83 c4 10             	add    $0x10,%esp
  80065c:	eb eb                	jmp    800649 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80065e:	83 ec 0c             	sub    $0xc,%esp
  800661:	6a 20                	push   $0x20
  800663:	6a 00                	push   $0x0
  800665:	50                   	push   %eax
  800666:	ff 75 e4             	pushl  -0x1c(%ebp)
  800669:	ff 75 e0             	pushl  -0x20(%ebp)
  80066c:	89 fa                	mov    %edi,%edx
  80066e:	89 f0                	mov    %esi,%eax
  800670:	e8 98 ff ff ff       	call   80060d <printnum>
		while (--width > 0)
  800675:	83 c4 20             	add    $0x20,%esp
  800678:	83 eb 01             	sub    $0x1,%ebx
  80067b:	85 db                	test   %ebx,%ebx
  80067d:	7e 65                	jle    8006e4 <printnum+0xd7>
			putch(padc, putdat);
  80067f:	83 ec 08             	sub    $0x8,%esp
  800682:	57                   	push   %edi
  800683:	6a 20                	push   $0x20
  800685:	ff d6                	call   *%esi
  800687:	83 c4 10             	add    $0x10,%esp
  80068a:	eb ec                	jmp    800678 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80068c:	83 ec 0c             	sub    $0xc,%esp
  80068f:	ff 75 18             	pushl  0x18(%ebp)
  800692:	83 eb 01             	sub    $0x1,%ebx
  800695:	53                   	push   %ebx
  800696:	50                   	push   %eax
  800697:	83 ec 08             	sub    $0x8,%esp
  80069a:	ff 75 dc             	pushl  -0x24(%ebp)
  80069d:	ff 75 d8             	pushl  -0x28(%ebp)
  8006a0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8006a3:	ff 75 e0             	pushl  -0x20(%ebp)
  8006a6:	e8 a5 2a 00 00       	call   803150 <__udivdi3>
  8006ab:	83 c4 18             	add    $0x18,%esp
  8006ae:	52                   	push   %edx
  8006af:	50                   	push   %eax
  8006b0:	89 fa                	mov    %edi,%edx
  8006b2:	89 f0                	mov    %esi,%eax
  8006b4:	e8 54 ff ff ff       	call   80060d <printnum>
  8006b9:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8006bc:	83 ec 08             	sub    $0x8,%esp
  8006bf:	57                   	push   %edi
  8006c0:	83 ec 04             	sub    $0x4,%esp
  8006c3:	ff 75 dc             	pushl  -0x24(%ebp)
  8006c6:	ff 75 d8             	pushl  -0x28(%ebp)
  8006c9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8006cc:	ff 75 e0             	pushl  -0x20(%ebp)
  8006cf:	e8 8c 2b 00 00       	call   803260 <__umoddi3>
  8006d4:	83 c4 14             	add    $0x14,%esp
  8006d7:	0f be 80 2b 35 80 00 	movsbl 0x80352b(%eax),%eax
  8006de:	50                   	push   %eax
  8006df:	ff d6                	call   *%esi
  8006e1:	83 c4 10             	add    $0x10,%esp
	}
}
  8006e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006e7:	5b                   	pop    %ebx
  8006e8:	5e                   	pop    %esi
  8006e9:	5f                   	pop    %edi
  8006ea:	5d                   	pop    %ebp
  8006eb:	c3                   	ret    

008006ec <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8006ec:	55                   	push   %ebp
  8006ed:	89 e5                	mov    %esp,%ebp
  8006ef:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8006f2:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8006f6:	8b 10                	mov    (%eax),%edx
  8006f8:	3b 50 04             	cmp    0x4(%eax),%edx
  8006fb:	73 0a                	jae    800707 <sprintputch+0x1b>
		*b->buf++ = ch;
  8006fd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800700:	89 08                	mov    %ecx,(%eax)
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	88 02                	mov    %al,(%edx)
}
  800707:	5d                   	pop    %ebp
  800708:	c3                   	ret    

00800709 <printfmt>:
{
  800709:	55                   	push   %ebp
  80070a:	89 e5                	mov    %esp,%ebp
  80070c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80070f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800712:	50                   	push   %eax
  800713:	ff 75 10             	pushl  0x10(%ebp)
  800716:	ff 75 0c             	pushl  0xc(%ebp)
  800719:	ff 75 08             	pushl  0x8(%ebp)
  80071c:	e8 05 00 00 00       	call   800726 <vprintfmt>
}
  800721:	83 c4 10             	add    $0x10,%esp
  800724:	c9                   	leave  
  800725:	c3                   	ret    

00800726 <vprintfmt>:
{
  800726:	55                   	push   %ebp
  800727:	89 e5                	mov    %esp,%ebp
  800729:	57                   	push   %edi
  80072a:	56                   	push   %esi
  80072b:	53                   	push   %ebx
  80072c:	83 ec 3c             	sub    $0x3c,%esp
  80072f:	8b 75 08             	mov    0x8(%ebp),%esi
  800732:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800735:	8b 7d 10             	mov    0x10(%ebp),%edi
  800738:	e9 32 04 00 00       	jmp    800b6f <vprintfmt+0x449>
		padc = ' ';
  80073d:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800741:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800748:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80074f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800756:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80075d:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800764:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800769:	8d 47 01             	lea    0x1(%edi),%eax
  80076c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80076f:	0f b6 17             	movzbl (%edi),%edx
  800772:	8d 42 dd             	lea    -0x23(%edx),%eax
  800775:	3c 55                	cmp    $0x55,%al
  800777:	0f 87 12 05 00 00    	ja     800c8f <vprintfmt+0x569>
  80077d:	0f b6 c0             	movzbl %al,%eax
  800780:	ff 24 85 00 37 80 00 	jmp    *0x803700(,%eax,4)
  800787:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80078a:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80078e:	eb d9                	jmp    800769 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800790:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800793:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800797:	eb d0                	jmp    800769 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800799:	0f b6 d2             	movzbl %dl,%edx
  80079c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80079f:	b8 00 00 00 00       	mov    $0x0,%eax
  8007a4:	89 75 08             	mov    %esi,0x8(%ebp)
  8007a7:	eb 03                	jmp    8007ac <vprintfmt+0x86>
  8007a9:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8007ac:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8007af:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8007b3:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8007b6:	8d 72 d0             	lea    -0x30(%edx),%esi
  8007b9:	83 fe 09             	cmp    $0x9,%esi
  8007bc:	76 eb                	jbe    8007a9 <vprintfmt+0x83>
  8007be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c1:	8b 75 08             	mov    0x8(%ebp),%esi
  8007c4:	eb 14                	jmp    8007da <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8007c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c9:	8b 00                	mov    (%eax),%eax
  8007cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d1:	8d 40 04             	lea    0x4(%eax),%eax
  8007d4:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8007d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8007da:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007de:	79 89                	jns    800769 <vprintfmt+0x43>
				width = precision, precision = -1;
  8007e0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007e6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8007ed:	e9 77 ff ff ff       	jmp    800769 <vprintfmt+0x43>
  8007f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007f5:	85 c0                	test   %eax,%eax
  8007f7:	0f 48 c1             	cmovs  %ecx,%eax
  8007fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8007fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800800:	e9 64 ff ff ff       	jmp    800769 <vprintfmt+0x43>
  800805:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800808:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80080f:	e9 55 ff ff ff       	jmp    800769 <vprintfmt+0x43>
			lflag++;
  800814:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800818:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80081b:	e9 49 ff ff ff       	jmp    800769 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800820:	8b 45 14             	mov    0x14(%ebp),%eax
  800823:	8d 78 04             	lea    0x4(%eax),%edi
  800826:	83 ec 08             	sub    $0x8,%esp
  800829:	53                   	push   %ebx
  80082a:	ff 30                	pushl  (%eax)
  80082c:	ff d6                	call   *%esi
			break;
  80082e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800831:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800834:	e9 33 03 00 00       	jmp    800b6c <vprintfmt+0x446>
			err = va_arg(ap, int);
  800839:	8b 45 14             	mov    0x14(%ebp),%eax
  80083c:	8d 78 04             	lea    0x4(%eax),%edi
  80083f:	8b 00                	mov    (%eax),%eax
  800841:	99                   	cltd   
  800842:	31 d0                	xor    %edx,%eax
  800844:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800846:	83 f8 11             	cmp    $0x11,%eax
  800849:	7f 23                	jg     80086e <vprintfmt+0x148>
  80084b:	8b 14 85 60 38 80 00 	mov    0x803860(,%eax,4),%edx
  800852:	85 d2                	test   %edx,%edx
  800854:	74 18                	je     80086e <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800856:	52                   	push   %edx
  800857:	68 6d 3a 80 00       	push   $0x803a6d
  80085c:	53                   	push   %ebx
  80085d:	56                   	push   %esi
  80085e:	e8 a6 fe ff ff       	call   800709 <printfmt>
  800863:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800866:	89 7d 14             	mov    %edi,0x14(%ebp)
  800869:	e9 fe 02 00 00       	jmp    800b6c <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80086e:	50                   	push   %eax
  80086f:	68 43 35 80 00       	push   $0x803543
  800874:	53                   	push   %ebx
  800875:	56                   	push   %esi
  800876:	e8 8e fe ff ff       	call   800709 <printfmt>
  80087b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80087e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800881:	e9 e6 02 00 00       	jmp    800b6c <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800886:	8b 45 14             	mov    0x14(%ebp),%eax
  800889:	83 c0 04             	add    $0x4,%eax
  80088c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80088f:	8b 45 14             	mov    0x14(%ebp),%eax
  800892:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800894:	85 c9                	test   %ecx,%ecx
  800896:	b8 3c 35 80 00       	mov    $0x80353c,%eax
  80089b:	0f 45 c1             	cmovne %ecx,%eax
  80089e:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8008a1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008a5:	7e 06                	jle    8008ad <vprintfmt+0x187>
  8008a7:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8008ab:	75 0d                	jne    8008ba <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ad:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8008b0:	89 c7                	mov    %eax,%edi
  8008b2:	03 45 e0             	add    -0x20(%ebp),%eax
  8008b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008b8:	eb 53                	jmp    80090d <vprintfmt+0x1e7>
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	ff 75 d8             	pushl  -0x28(%ebp)
  8008c0:	50                   	push   %eax
  8008c1:	e8 71 04 00 00       	call   800d37 <strnlen>
  8008c6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8008c9:	29 c1                	sub    %eax,%ecx
  8008cb:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8008ce:	83 c4 10             	add    $0x10,%esp
  8008d1:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8008d3:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8008d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8008da:	eb 0f                	jmp    8008eb <vprintfmt+0x1c5>
					putch(padc, putdat);
  8008dc:	83 ec 08             	sub    $0x8,%esp
  8008df:	53                   	push   %ebx
  8008e0:	ff 75 e0             	pushl  -0x20(%ebp)
  8008e3:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e5:	83 ef 01             	sub    $0x1,%edi
  8008e8:	83 c4 10             	add    $0x10,%esp
  8008eb:	85 ff                	test   %edi,%edi
  8008ed:	7f ed                	jg     8008dc <vprintfmt+0x1b6>
  8008ef:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8008f2:	85 c9                	test   %ecx,%ecx
  8008f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f9:	0f 49 c1             	cmovns %ecx,%eax
  8008fc:	29 c1                	sub    %eax,%ecx
  8008fe:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800901:	eb aa                	jmp    8008ad <vprintfmt+0x187>
					putch(ch, putdat);
  800903:	83 ec 08             	sub    $0x8,%esp
  800906:	53                   	push   %ebx
  800907:	52                   	push   %edx
  800908:	ff d6                	call   *%esi
  80090a:	83 c4 10             	add    $0x10,%esp
  80090d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800910:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800912:	83 c7 01             	add    $0x1,%edi
  800915:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800919:	0f be d0             	movsbl %al,%edx
  80091c:	85 d2                	test   %edx,%edx
  80091e:	74 4b                	je     80096b <vprintfmt+0x245>
  800920:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800924:	78 06                	js     80092c <vprintfmt+0x206>
  800926:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80092a:	78 1e                	js     80094a <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80092c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800930:	74 d1                	je     800903 <vprintfmt+0x1dd>
  800932:	0f be c0             	movsbl %al,%eax
  800935:	83 e8 20             	sub    $0x20,%eax
  800938:	83 f8 5e             	cmp    $0x5e,%eax
  80093b:	76 c6                	jbe    800903 <vprintfmt+0x1dd>
					putch('?', putdat);
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	53                   	push   %ebx
  800941:	6a 3f                	push   $0x3f
  800943:	ff d6                	call   *%esi
  800945:	83 c4 10             	add    $0x10,%esp
  800948:	eb c3                	jmp    80090d <vprintfmt+0x1e7>
  80094a:	89 cf                	mov    %ecx,%edi
  80094c:	eb 0e                	jmp    80095c <vprintfmt+0x236>
				putch(' ', putdat);
  80094e:	83 ec 08             	sub    $0x8,%esp
  800951:	53                   	push   %ebx
  800952:	6a 20                	push   $0x20
  800954:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800956:	83 ef 01             	sub    $0x1,%edi
  800959:	83 c4 10             	add    $0x10,%esp
  80095c:	85 ff                	test   %edi,%edi
  80095e:	7f ee                	jg     80094e <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800960:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800963:	89 45 14             	mov    %eax,0x14(%ebp)
  800966:	e9 01 02 00 00       	jmp    800b6c <vprintfmt+0x446>
  80096b:	89 cf                	mov    %ecx,%edi
  80096d:	eb ed                	jmp    80095c <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80096f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800972:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800979:	e9 eb fd ff ff       	jmp    800769 <vprintfmt+0x43>
	if (lflag >= 2)
  80097e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800982:	7f 21                	jg     8009a5 <vprintfmt+0x27f>
	else if (lflag)
  800984:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800988:	74 68                	je     8009f2 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80098a:	8b 45 14             	mov    0x14(%ebp),%eax
  80098d:	8b 00                	mov    (%eax),%eax
  80098f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800992:	89 c1                	mov    %eax,%ecx
  800994:	c1 f9 1f             	sar    $0x1f,%ecx
  800997:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80099a:	8b 45 14             	mov    0x14(%ebp),%eax
  80099d:	8d 40 04             	lea    0x4(%eax),%eax
  8009a0:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a3:	eb 17                	jmp    8009bc <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8009a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a8:	8b 50 04             	mov    0x4(%eax),%edx
  8009ab:	8b 00                	mov    (%eax),%eax
  8009ad:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8009b0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8009b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b6:	8d 40 08             	lea    0x8(%eax),%eax
  8009b9:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8009bc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8009bf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8009c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009c5:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8009c8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8009cc:	78 3f                	js     800a0d <vprintfmt+0x2e7>
			base = 10;
  8009ce:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8009d3:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8009d7:	0f 84 71 01 00 00    	je     800b4e <vprintfmt+0x428>
				putch('+', putdat);
  8009dd:	83 ec 08             	sub    $0x8,%esp
  8009e0:	53                   	push   %ebx
  8009e1:	6a 2b                	push   $0x2b
  8009e3:	ff d6                	call   *%esi
  8009e5:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8009e8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009ed:	e9 5c 01 00 00       	jmp    800b4e <vprintfmt+0x428>
		return va_arg(*ap, int);
  8009f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f5:	8b 00                	mov    (%eax),%eax
  8009f7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8009fa:	89 c1                	mov    %eax,%ecx
  8009fc:	c1 f9 1f             	sar    $0x1f,%ecx
  8009ff:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800a02:	8b 45 14             	mov    0x14(%ebp),%eax
  800a05:	8d 40 04             	lea    0x4(%eax),%eax
  800a08:	89 45 14             	mov    %eax,0x14(%ebp)
  800a0b:	eb af                	jmp    8009bc <vprintfmt+0x296>
				putch('-', putdat);
  800a0d:	83 ec 08             	sub    $0x8,%esp
  800a10:	53                   	push   %ebx
  800a11:	6a 2d                	push   $0x2d
  800a13:	ff d6                	call   *%esi
				num = -(long long) num;
  800a15:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a18:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800a1b:	f7 d8                	neg    %eax
  800a1d:	83 d2 00             	adc    $0x0,%edx
  800a20:	f7 da                	neg    %edx
  800a22:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a25:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a28:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800a2b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a30:	e9 19 01 00 00       	jmp    800b4e <vprintfmt+0x428>
	if (lflag >= 2)
  800a35:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800a39:	7f 29                	jg     800a64 <vprintfmt+0x33e>
	else if (lflag)
  800a3b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a3f:	74 44                	je     800a85 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800a41:	8b 45 14             	mov    0x14(%ebp),%eax
  800a44:	8b 00                	mov    (%eax),%eax
  800a46:	ba 00 00 00 00       	mov    $0x0,%edx
  800a4b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a4e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a51:	8b 45 14             	mov    0x14(%ebp),%eax
  800a54:	8d 40 04             	lea    0x4(%eax),%eax
  800a57:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a5a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a5f:	e9 ea 00 00 00       	jmp    800b4e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800a64:	8b 45 14             	mov    0x14(%ebp),%eax
  800a67:	8b 50 04             	mov    0x4(%eax),%edx
  800a6a:	8b 00                	mov    (%eax),%eax
  800a6c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a6f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a72:	8b 45 14             	mov    0x14(%ebp),%eax
  800a75:	8d 40 08             	lea    0x8(%eax),%eax
  800a78:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a7b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a80:	e9 c9 00 00 00       	jmp    800b4e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800a85:	8b 45 14             	mov    0x14(%ebp),%eax
  800a88:	8b 00                	mov    (%eax),%eax
  800a8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800a8f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a92:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a95:	8b 45 14             	mov    0x14(%ebp),%eax
  800a98:	8d 40 04             	lea    0x4(%eax),%eax
  800a9b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a9e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800aa3:	e9 a6 00 00 00       	jmp    800b4e <vprintfmt+0x428>
			putch('0', putdat);
  800aa8:	83 ec 08             	sub    $0x8,%esp
  800aab:	53                   	push   %ebx
  800aac:	6a 30                	push   $0x30
  800aae:	ff d6                	call   *%esi
	if (lflag >= 2)
  800ab0:	83 c4 10             	add    $0x10,%esp
  800ab3:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800ab7:	7f 26                	jg     800adf <vprintfmt+0x3b9>
	else if (lflag)
  800ab9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800abd:	74 3e                	je     800afd <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800abf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac2:	8b 00                	mov    (%eax),%eax
  800ac4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800acc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800acf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad2:	8d 40 04             	lea    0x4(%eax),%eax
  800ad5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800ad8:	b8 08 00 00 00       	mov    $0x8,%eax
  800add:	eb 6f                	jmp    800b4e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800adf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae2:	8b 50 04             	mov    0x4(%eax),%edx
  800ae5:	8b 00                	mov    (%eax),%eax
  800ae7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aea:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800aed:	8b 45 14             	mov    0x14(%ebp),%eax
  800af0:	8d 40 08             	lea    0x8(%eax),%eax
  800af3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800af6:	b8 08 00 00 00       	mov    $0x8,%eax
  800afb:	eb 51                	jmp    800b4e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800afd:	8b 45 14             	mov    0x14(%ebp),%eax
  800b00:	8b 00                	mov    (%eax),%eax
  800b02:	ba 00 00 00 00       	mov    $0x0,%edx
  800b07:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b0a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b10:	8d 40 04             	lea    0x4(%eax),%eax
  800b13:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b16:	b8 08 00 00 00       	mov    $0x8,%eax
  800b1b:	eb 31                	jmp    800b4e <vprintfmt+0x428>
			putch('0', putdat);
  800b1d:	83 ec 08             	sub    $0x8,%esp
  800b20:	53                   	push   %ebx
  800b21:	6a 30                	push   $0x30
  800b23:	ff d6                	call   *%esi
			putch('x', putdat);
  800b25:	83 c4 08             	add    $0x8,%esp
  800b28:	53                   	push   %ebx
  800b29:	6a 78                	push   $0x78
  800b2b:	ff d6                	call   *%esi
			num = (unsigned long long)
  800b2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b30:	8b 00                	mov    (%eax),%eax
  800b32:	ba 00 00 00 00       	mov    $0x0,%edx
  800b37:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b3a:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800b3d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800b40:	8b 45 14             	mov    0x14(%ebp),%eax
  800b43:	8d 40 04             	lea    0x4(%eax),%eax
  800b46:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b49:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800b4e:	83 ec 0c             	sub    $0xc,%esp
  800b51:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800b55:	52                   	push   %edx
  800b56:	ff 75 e0             	pushl  -0x20(%ebp)
  800b59:	50                   	push   %eax
  800b5a:	ff 75 dc             	pushl  -0x24(%ebp)
  800b5d:	ff 75 d8             	pushl  -0x28(%ebp)
  800b60:	89 da                	mov    %ebx,%edx
  800b62:	89 f0                	mov    %esi,%eax
  800b64:	e8 a4 fa ff ff       	call   80060d <printnum>
			break;
  800b69:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800b6c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b6f:	83 c7 01             	add    $0x1,%edi
  800b72:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800b76:	83 f8 25             	cmp    $0x25,%eax
  800b79:	0f 84 be fb ff ff    	je     80073d <vprintfmt+0x17>
			if (ch == '\0')
  800b7f:	85 c0                	test   %eax,%eax
  800b81:	0f 84 28 01 00 00    	je     800caf <vprintfmt+0x589>
			putch(ch, putdat);
  800b87:	83 ec 08             	sub    $0x8,%esp
  800b8a:	53                   	push   %ebx
  800b8b:	50                   	push   %eax
  800b8c:	ff d6                	call   *%esi
  800b8e:	83 c4 10             	add    $0x10,%esp
  800b91:	eb dc                	jmp    800b6f <vprintfmt+0x449>
	if (lflag >= 2)
  800b93:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800b97:	7f 26                	jg     800bbf <vprintfmt+0x499>
	else if (lflag)
  800b99:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800b9d:	74 41                	je     800be0 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800b9f:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba2:	8b 00                	mov    (%eax),%eax
  800ba4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bac:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800baf:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb2:	8d 40 04             	lea    0x4(%eax),%eax
  800bb5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800bb8:	b8 10 00 00 00       	mov    $0x10,%eax
  800bbd:	eb 8f                	jmp    800b4e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800bbf:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc2:	8b 50 04             	mov    0x4(%eax),%edx
  800bc5:	8b 00                	mov    (%eax),%eax
  800bc7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bca:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800bcd:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd0:	8d 40 08             	lea    0x8(%eax),%eax
  800bd3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800bd6:	b8 10 00 00 00       	mov    $0x10,%eax
  800bdb:	e9 6e ff ff ff       	jmp    800b4e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800be0:	8b 45 14             	mov    0x14(%ebp),%eax
  800be3:	8b 00                	mov    (%eax),%eax
  800be5:	ba 00 00 00 00       	mov    $0x0,%edx
  800bea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bed:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800bf0:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf3:	8d 40 04             	lea    0x4(%eax),%eax
  800bf6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800bf9:	b8 10 00 00 00       	mov    $0x10,%eax
  800bfe:	e9 4b ff ff ff       	jmp    800b4e <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800c03:	8b 45 14             	mov    0x14(%ebp),%eax
  800c06:	83 c0 04             	add    $0x4,%eax
  800c09:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c0f:	8b 00                	mov    (%eax),%eax
  800c11:	85 c0                	test   %eax,%eax
  800c13:	74 14                	je     800c29 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800c15:	8b 13                	mov    (%ebx),%edx
  800c17:	83 fa 7f             	cmp    $0x7f,%edx
  800c1a:	7f 37                	jg     800c53 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800c1c:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800c1e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c21:	89 45 14             	mov    %eax,0x14(%ebp)
  800c24:	e9 43 ff ff ff       	jmp    800b6c <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800c29:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c2e:	bf 61 36 80 00       	mov    $0x803661,%edi
							putch(ch, putdat);
  800c33:	83 ec 08             	sub    $0x8,%esp
  800c36:	53                   	push   %ebx
  800c37:	50                   	push   %eax
  800c38:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800c3a:	83 c7 01             	add    $0x1,%edi
  800c3d:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800c41:	83 c4 10             	add    $0x10,%esp
  800c44:	85 c0                	test   %eax,%eax
  800c46:	75 eb                	jne    800c33 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800c48:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c4b:	89 45 14             	mov    %eax,0x14(%ebp)
  800c4e:	e9 19 ff ff ff       	jmp    800b6c <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800c53:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800c55:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c5a:	bf 99 36 80 00       	mov    $0x803699,%edi
							putch(ch, putdat);
  800c5f:	83 ec 08             	sub    $0x8,%esp
  800c62:	53                   	push   %ebx
  800c63:	50                   	push   %eax
  800c64:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800c66:	83 c7 01             	add    $0x1,%edi
  800c69:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800c6d:	83 c4 10             	add    $0x10,%esp
  800c70:	85 c0                	test   %eax,%eax
  800c72:	75 eb                	jne    800c5f <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800c74:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c77:	89 45 14             	mov    %eax,0x14(%ebp)
  800c7a:	e9 ed fe ff ff       	jmp    800b6c <vprintfmt+0x446>
			putch(ch, putdat);
  800c7f:	83 ec 08             	sub    $0x8,%esp
  800c82:	53                   	push   %ebx
  800c83:	6a 25                	push   $0x25
  800c85:	ff d6                	call   *%esi
			break;
  800c87:	83 c4 10             	add    $0x10,%esp
  800c8a:	e9 dd fe ff ff       	jmp    800b6c <vprintfmt+0x446>
			putch('%', putdat);
  800c8f:	83 ec 08             	sub    $0x8,%esp
  800c92:	53                   	push   %ebx
  800c93:	6a 25                	push   $0x25
  800c95:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c97:	83 c4 10             	add    $0x10,%esp
  800c9a:	89 f8                	mov    %edi,%eax
  800c9c:	eb 03                	jmp    800ca1 <vprintfmt+0x57b>
  800c9e:	83 e8 01             	sub    $0x1,%eax
  800ca1:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800ca5:	75 f7                	jne    800c9e <vprintfmt+0x578>
  800ca7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800caa:	e9 bd fe ff ff       	jmp    800b6c <vprintfmt+0x446>
}
  800caf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb2:	5b                   	pop    %ebx
  800cb3:	5e                   	pop    %esi
  800cb4:	5f                   	pop    %edi
  800cb5:	5d                   	pop    %ebp
  800cb6:	c3                   	ret    

00800cb7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cb7:	55                   	push   %ebp
  800cb8:	89 e5                	mov    %esp,%ebp
  800cba:	83 ec 18             	sub    $0x18,%esp
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cc3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cc6:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800cca:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800ccd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cd4:	85 c0                	test   %eax,%eax
  800cd6:	74 26                	je     800cfe <vsnprintf+0x47>
  800cd8:	85 d2                	test   %edx,%edx
  800cda:	7e 22                	jle    800cfe <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cdc:	ff 75 14             	pushl  0x14(%ebp)
  800cdf:	ff 75 10             	pushl  0x10(%ebp)
  800ce2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ce5:	50                   	push   %eax
  800ce6:	68 ec 06 80 00       	push   $0x8006ec
  800ceb:	e8 36 fa ff ff       	call   800726 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800cf0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cf3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cf9:	83 c4 10             	add    $0x10,%esp
}
  800cfc:	c9                   	leave  
  800cfd:	c3                   	ret    
		return -E_INVAL;
  800cfe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d03:	eb f7                	jmp    800cfc <vsnprintf+0x45>

00800d05 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d0b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800d0e:	50                   	push   %eax
  800d0f:	ff 75 10             	pushl  0x10(%ebp)
  800d12:	ff 75 0c             	pushl  0xc(%ebp)
  800d15:	ff 75 08             	pushl  0x8(%ebp)
  800d18:	e8 9a ff ff ff       	call   800cb7 <vsnprintf>
	va_end(ap);

	return rc;
}
  800d1d:	c9                   	leave  
  800d1e:	c3                   	ret    

00800d1f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d1f:	55                   	push   %ebp
  800d20:	89 e5                	mov    %esp,%ebp
  800d22:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800d25:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800d2e:	74 05                	je     800d35 <strlen+0x16>
		n++;
  800d30:	83 c0 01             	add    $0x1,%eax
  800d33:	eb f5                	jmp    800d2a <strlen+0xb>
	return n;
}
  800d35:	5d                   	pop    %ebp
  800d36:	c3                   	ret    

00800d37 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800d37:	55                   	push   %ebp
  800d38:	89 e5                	mov    %esp,%ebp
  800d3a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d40:	ba 00 00 00 00       	mov    $0x0,%edx
  800d45:	39 c2                	cmp    %eax,%edx
  800d47:	74 0d                	je     800d56 <strnlen+0x1f>
  800d49:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800d4d:	74 05                	je     800d54 <strnlen+0x1d>
		n++;
  800d4f:	83 c2 01             	add    $0x1,%edx
  800d52:	eb f1                	jmp    800d45 <strnlen+0xe>
  800d54:	89 d0                	mov    %edx,%eax
	return n;
}
  800d56:	5d                   	pop    %ebp
  800d57:	c3                   	ret    

00800d58 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d58:	55                   	push   %ebp
  800d59:	89 e5                	mov    %esp,%ebp
  800d5b:	53                   	push   %ebx
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800d62:	ba 00 00 00 00       	mov    $0x0,%edx
  800d67:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800d6b:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800d6e:	83 c2 01             	add    $0x1,%edx
  800d71:	84 c9                	test   %cl,%cl
  800d73:	75 f2                	jne    800d67 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800d75:	5b                   	pop    %ebx
  800d76:	5d                   	pop    %ebp
  800d77:	c3                   	ret    

00800d78 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800d78:	55                   	push   %ebp
  800d79:	89 e5                	mov    %esp,%ebp
  800d7b:	53                   	push   %ebx
  800d7c:	83 ec 10             	sub    $0x10,%esp
  800d7f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800d82:	53                   	push   %ebx
  800d83:	e8 97 ff ff ff       	call   800d1f <strlen>
  800d88:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800d8b:	ff 75 0c             	pushl  0xc(%ebp)
  800d8e:	01 d8                	add    %ebx,%eax
  800d90:	50                   	push   %eax
  800d91:	e8 c2 ff ff ff       	call   800d58 <strcpy>
	return dst;
}
  800d96:	89 d8                	mov    %ebx,%eax
  800d98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d9b:	c9                   	leave  
  800d9c:	c3                   	ret    

00800d9d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d9d:	55                   	push   %ebp
  800d9e:	89 e5                	mov    %esp,%ebp
  800da0:	56                   	push   %esi
  800da1:	53                   	push   %ebx
  800da2:	8b 45 08             	mov    0x8(%ebp),%eax
  800da5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da8:	89 c6                	mov    %eax,%esi
  800daa:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dad:	89 c2                	mov    %eax,%edx
  800daf:	39 f2                	cmp    %esi,%edx
  800db1:	74 11                	je     800dc4 <strncpy+0x27>
		*dst++ = *src;
  800db3:	83 c2 01             	add    $0x1,%edx
  800db6:	0f b6 19             	movzbl (%ecx),%ebx
  800db9:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800dbc:	80 fb 01             	cmp    $0x1,%bl
  800dbf:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800dc2:	eb eb                	jmp    800daf <strncpy+0x12>
	}
	return ret;
}
  800dc4:	5b                   	pop    %ebx
  800dc5:	5e                   	pop    %esi
  800dc6:	5d                   	pop    %ebp
  800dc7:	c3                   	ret    

00800dc8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
  800dcb:	56                   	push   %esi
  800dcc:	53                   	push   %ebx
  800dcd:	8b 75 08             	mov    0x8(%ebp),%esi
  800dd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd3:	8b 55 10             	mov    0x10(%ebp),%edx
  800dd6:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800dd8:	85 d2                	test   %edx,%edx
  800dda:	74 21                	je     800dfd <strlcpy+0x35>
  800ddc:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800de0:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800de2:	39 c2                	cmp    %eax,%edx
  800de4:	74 14                	je     800dfa <strlcpy+0x32>
  800de6:	0f b6 19             	movzbl (%ecx),%ebx
  800de9:	84 db                	test   %bl,%bl
  800deb:	74 0b                	je     800df8 <strlcpy+0x30>
			*dst++ = *src++;
  800ded:	83 c1 01             	add    $0x1,%ecx
  800df0:	83 c2 01             	add    $0x1,%edx
  800df3:	88 5a ff             	mov    %bl,-0x1(%edx)
  800df6:	eb ea                	jmp    800de2 <strlcpy+0x1a>
  800df8:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800dfa:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dfd:	29 f0                	sub    %esi,%eax
}
  800dff:	5b                   	pop    %ebx
  800e00:	5e                   	pop    %esi
  800e01:	5d                   	pop    %ebp
  800e02:	c3                   	ret    

00800e03 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e03:	55                   	push   %ebp
  800e04:	89 e5                	mov    %esp,%ebp
  800e06:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e09:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800e0c:	0f b6 01             	movzbl (%ecx),%eax
  800e0f:	84 c0                	test   %al,%al
  800e11:	74 0c                	je     800e1f <strcmp+0x1c>
  800e13:	3a 02                	cmp    (%edx),%al
  800e15:	75 08                	jne    800e1f <strcmp+0x1c>
		p++, q++;
  800e17:	83 c1 01             	add    $0x1,%ecx
  800e1a:	83 c2 01             	add    $0x1,%edx
  800e1d:	eb ed                	jmp    800e0c <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e1f:	0f b6 c0             	movzbl %al,%eax
  800e22:	0f b6 12             	movzbl (%edx),%edx
  800e25:	29 d0                	sub    %edx,%eax
}
  800e27:	5d                   	pop    %ebp
  800e28:	c3                   	ret    

00800e29 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800e29:	55                   	push   %ebp
  800e2a:	89 e5                	mov    %esp,%ebp
  800e2c:	53                   	push   %ebx
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e33:	89 c3                	mov    %eax,%ebx
  800e35:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800e38:	eb 06                	jmp    800e40 <strncmp+0x17>
		n--, p++, q++;
  800e3a:	83 c0 01             	add    $0x1,%eax
  800e3d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800e40:	39 d8                	cmp    %ebx,%eax
  800e42:	74 16                	je     800e5a <strncmp+0x31>
  800e44:	0f b6 08             	movzbl (%eax),%ecx
  800e47:	84 c9                	test   %cl,%cl
  800e49:	74 04                	je     800e4f <strncmp+0x26>
  800e4b:	3a 0a                	cmp    (%edx),%cl
  800e4d:	74 eb                	je     800e3a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e4f:	0f b6 00             	movzbl (%eax),%eax
  800e52:	0f b6 12             	movzbl (%edx),%edx
  800e55:	29 d0                	sub    %edx,%eax
}
  800e57:	5b                   	pop    %ebx
  800e58:	5d                   	pop    %ebp
  800e59:	c3                   	ret    
		return 0;
  800e5a:	b8 00 00 00 00       	mov    $0x0,%eax
  800e5f:	eb f6                	jmp    800e57 <strncmp+0x2e>

00800e61 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e61:	55                   	push   %ebp
  800e62:	89 e5                	mov    %esp,%ebp
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
  800e67:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e6b:	0f b6 10             	movzbl (%eax),%edx
  800e6e:	84 d2                	test   %dl,%dl
  800e70:	74 09                	je     800e7b <strchr+0x1a>
		if (*s == c)
  800e72:	38 ca                	cmp    %cl,%dl
  800e74:	74 0a                	je     800e80 <strchr+0x1f>
	for (; *s; s++)
  800e76:	83 c0 01             	add    $0x1,%eax
  800e79:	eb f0                	jmp    800e6b <strchr+0xa>
			return (char *) s;
	return 0;
  800e7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e80:	5d                   	pop    %ebp
  800e81:	c3                   	ret    

00800e82 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e82:	55                   	push   %ebp
  800e83:	89 e5                	mov    %esp,%ebp
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e8c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800e8f:	38 ca                	cmp    %cl,%dl
  800e91:	74 09                	je     800e9c <strfind+0x1a>
  800e93:	84 d2                	test   %dl,%dl
  800e95:	74 05                	je     800e9c <strfind+0x1a>
	for (; *s; s++)
  800e97:	83 c0 01             	add    $0x1,%eax
  800e9a:	eb f0                	jmp    800e8c <strfind+0xa>
			break;
	return (char *) s;
}
  800e9c:	5d                   	pop    %ebp
  800e9d:	c3                   	ret    

00800e9e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800e9e:	55                   	push   %ebp
  800e9f:	89 e5                	mov    %esp,%ebp
  800ea1:	57                   	push   %edi
  800ea2:	56                   	push   %esi
  800ea3:	53                   	push   %ebx
  800ea4:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ea7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800eaa:	85 c9                	test   %ecx,%ecx
  800eac:	74 31                	je     800edf <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800eae:	89 f8                	mov    %edi,%eax
  800eb0:	09 c8                	or     %ecx,%eax
  800eb2:	a8 03                	test   $0x3,%al
  800eb4:	75 23                	jne    800ed9 <memset+0x3b>
		c &= 0xFF;
  800eb6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800eba:	89 d3                	mov    %edx,%ebx
  800ebc:	c1 e3 08             	shl    $0x8,%ebx
  800ebf:	89 d0                	mov    %edx,%eax
  800ec1:	c1 e0 18             	shl    $0x18,%eax
  800ec4:	89 d6                	mov    %edx,%esi
  800ec6:	c1 e6 10             	shl    $0x10,%esi
  800ec9:	09 f0                	or     %esi,%eax
  800ecb:	09 c2                	or     %eax,%edx
  800ecd:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ecf:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ed2:	89 d0                	mov    %edx,%eax
  800ed4:	fc                   	cld    
  800ed5:	f3 ab                	rep stos %eax,%es:(%edi)
  800ed7:	eb 06                	jmp    800edf <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ed9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edc:	fc                   	cld    
  800edd:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800edf:	89 f8                	mov    %edi,%eax
  800ee1:	5b                   	pop    %ebx
  800ee2:	5e                   	pop    %esi
  800ee3:	5f                   	pop    %edi
  800ee4:	5d                   	pop    %ebp
  800ee5:	c3                   	ret    

00800ee6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
  800ee9:	57                   	push   %edi
  800eea:	56                   	push   %esi
  800eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800eee:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ef1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ef4:	39 c6                	cmp    %eax,%esi
  800ef6:	73 32                	jae    800f2a <memmove+0x44>
  800ef8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800efb:	39 c2                	cmp    %eax,%edx
  800efd:	76 2b                	jbe    800f2a <memmove+0x44>
		s += n;
		d += n;
  800eff:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f02:	89 fe                	mov    %edi,%esi
  800f04:	09 ce                	or     %ecx,%esi
  800f06:	09 d6                	or     %edx,%esi
  800f08:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800f0e:	75 0e                	jne    800f1e <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800f10:	83 ef 04             	sub    $0x4,%edi
  800f13:	8d 72 fc             	lea    -0x4(%edx),%esi
  800f16:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800f19:	fd                   	std    
  800f1a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f1c:	eb 09                	jmp    800f27 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800f1e:	83 ef 01             	sub    $0x1,%edi
  800f21:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800f24:	fd                   	std    
  800f25:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800f27:	fc                   	cld    
  800f28:	eb 1a                	jmp    800f44 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f2a:	89 c2                	mov    %eax,%edx
  800f2c:	09 ca                	or     %ecx,%edx
  800f2e:	09 f2                	or     %esi,%edx
  800f30:	f6 c2 03             	test   $0x3,%dl
  800f33:	75 0a                	jne    800f3f <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800f35:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800f38:	89 c7                	mov    %eax,%edi
  800f3a:	fc                   	cld    
  800f3b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f3d:	eb 05                	jmp    800f44 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800f3f:	89 c7                	mov    %eax,%edi
  800f41:	fc                   	cld    
  800f42:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800f44:	5e                   	pop    %esi
  800f45:	5f                   	pop    %edi
  800f46:	5d                   	pop    %ebp
  800f47:	c3                   	ret    

00800f48 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800f48:	55                   	push   %ebp
  800f49:	89 e5                	mov    %esp,%ebp
  800f4b:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800f4e:	ff 75 10             	pushl  0x10(%ebp)
  800f51:	ff 75 0c             	pushl  0xc(%ebp)
  800f54:	ff 75 08             	pushl  0x8(%ebp)
  800f57:	e8 8a ff ff ff       	call   800ee6 <memmove>
}
  800f5c:	c9                   	leave  
  800f5d:	c3                   	ret    

00800f5e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	56                   	push   %esi
  800f62:	53                   	push   %ebx
  800f63:	8b 45 08             	mov    0x8(%ebp),%eax
  800f66:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f69:	89 c6                	mov    %eax,%esi
  800f6b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f6e:	39 f0                	cmp    %esi,%eax
  800f70:	74 1c                	je     800f8e <memcmp+0x30>
		if (*s1 != *s2)
  800f72:	0f b6 08             	movzbl (%eax),%ecx
  800f75:	0f b6 1a             	movzbl (%edx),%ebx
  800f78:	38 d9                	cmp    %bl,%cl
  800f7a:	75 08                	jne    800f84 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800f7c:	83 c0 01             	add    $0x1,%eax
  800f7f:	83 c2 01             	add    $0x1,%edx
  800f82:	eb ea                	jmp    800f6e <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800f84:	0f b6 c1             	movzbl %cl,%eax
  800f87:	0f b6 db             	movzbl %bl,%ebx
  800f8a:	29 d8                	sub    %ebx,%eax
  800f8c:	eb 05                	jmp    800f93 <memcmp+0x35>
	}

	return 0;
  800f8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f93:	5b                   	pop    %ebx
  800f94:	5e                   	pop    %esi
  800f95:	5d                   	pop    %ebp
  800f96:	c3                   	ret    

00800f97 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800f97:	55                   	push   %ebp
  800f98:	89 e5                	mov    %esp,%ebp
  800f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800fa0:	89 c2                	mov    %eax,%edx
  800fa2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800fa5:	39 d0                	cmp    %edx,%eax
  800fa7:	73 09                	jae    800fb2 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fa9:	38 08                	cmp    %cl,(%eax)
  800fab:	74 05                	je     800fb2 <memfind+0x1b>
	for (; s < ends; s++)
  800fad:	83 c0 01             	add    $0x1,%eax
  800fb0:	eb f3                	jmp    800fa5 <memfind+0xe>
			break;
	return (void *) s;
}
  800fb2:	5d                   	pop    %ebp
  800fb3:	c3                   	ret    

00800fb4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fb4:	55                   	push   %ebp
  800fb5:	89 e5                	mov    %esp,%ebp
  800fb7:	57                   	push   %edi
  800fb8:	56                   	push   %esi
  800fb9:	53                   	push   %ebx
  800fba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fbd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fc0:	eb 03                	jmp    800fc5 <strtol+0x11>
		s++;
  800fc2:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800fc5:	0f b6 01             	movzbl (%ecx),%eax
  800fc8:	3c 20                	cmp    $0x20,%al
  800fca:	74 f6                	je     800fc2 <strtol+0xe>
  800fcc:	3c 09                	cmp    $0x9,%al
  800fce:	74 f2                	je     800fc2 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800fd0:	3c 2b                	cmp    $0x2b,%al
  800fd2:	74 2a                	je     800ffe <strtol+0x4a>
	int neg = 0;
  800fd4:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800fd9:	3c 2d                	cmp    $0x2d,%al
  800fdb:	74 2b                	je     801008 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fdd:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800fe3:	75 0f                	jne    800ff4 <strtol+0x40>
  800fe5:	80 39 30             	cmpb   $0x30,(%ecx)
  800fe8:	74 28                	je     801012 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800fea:	85 db                	test   %ebx,%ebx
  800fec:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ff1:	0f 44 d8             	cmove  %eax,%ebx
  800ff4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ffc:	eb 50                	jmp    80104e <strtol+0x9a>
		s++;
  800ffe:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801001:	bf 00 00 00 00       	mov    $0x0,%edi
  801006:	eb d5                	jmp    800fdd <strtol+0x29>
		s++, neg = 1;
  801008:	83 c1 01             	add    $0x1,%ecx
  80100b:	bf 01 00 00 00       	mov    $0x1,%edi
  801010:	eb cb                	jmp    800fdd <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801012:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801016:	74 0e                	je     801026 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  801018:	85 db                	test   %ebx,%ebx
  80101a:	75 d8                	jne    800ff4 <strtol+0x40>
		s++, base = 8;
  80101c:	83 c1 01             	add    $0x1,%ecx
  80101f:	bb 08 00 00 00       	mov    $0x8,%ebx
  801024:	eb ce                	jmp    800ff4 <strtol+0x40>
		s += 2, base = 16;
  801026:	83 c1 02             	add    $0x2,%ecx
  801029:	bb 10 00 00 00       	mov    $0x10,%ebx
  80102e:	eb c4                	jmp    800ff4 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801030:	8d 72 9f             	lea    -0x61(%edx),%esi
  801033:	89 f3                	mov    %esi,%ebx
  801035:	80 fb 19             	cmp    $0x19,%bl
  801038:	77 29                	ja     801063 <strtol+0xaf>
			dig = *s - 'a' + 10;
  80103a:	0f be d2             	movsbl %dl,%edx
  80103d:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801040:	3b 55 10             	cmp    0x10(%ebp),%edx
  801043:	7d 30                	jge    801075 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801045:	83 c1 01             	add    $0x1,%ecx
  801048:	0f af 45 10          	imul   0x10(%ebp),%eax
  80104c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  80104e:	0f b6 11             	movzbl (%ecx),%edx
  801051:	8d 72 d0             	lea    -0x30(%edx),%esi
  801054:	89 f3                	mov    %esi,%ebx
  801056:	80 fb 09             	cmp    $0x9,%bl
  801059:	77 d5                	ja     801030 <strtol+0x7c>
			dig = *s - '0';
  80105b:	0f be d2             	movsbl %dl,%edx
  80105e:	83 ea 30             	sub    $0x30,%edx
  801061:	eb dd                	jmp    801040 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  801063:	8d 72 bf             	lea    -0x41(%edx),%esi
  801066:	89 f3                	mov    %esi,%ebx
  801068:	80 fb 19             	cmp    $0x19,%bl
  80106b:	77 08                	ja     801075 <strtol+0xc1>
			dig = *s - 'A' + 10;
  80106d:	0f be d2             	movsbl %dl,%edx
  801070:	83 ea 37             	sub    $0x37,%edx
  801073:	eb cb                	jmp    801040 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  801075:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801079:	74 05                	je     801080 <strtol+0xcc>
		*endptr = (char *) s;
  80107b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80107e:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801080:	89 c2                	mov    %eax,%edx
  801082:	f7 da                	neg    %edx
  801084:	85 ff                	test   %edi,%edi
  801086:	0f 45 c2             	cmovne %edx,%eax
}
  801089:	5b                   	pop    %ebx
  80108a:	5e                   	pop    %esi
  80108b:	5f                   	pop    %edi
  80108c:	5d                   	pop    %ebp
  80108d:	c3                   	ret    

0080108e <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80108e:	55                   	push   %ebp
  80108f:	89 e5                	mov    %esp,%ebp
  801091:	57                   	push   %edi
  801092:	56                   	push   %esi
  801093:	53                   	push   %ebx
	asm volatile("int %1\n"
  801094:	b8 00 00 00 00       	mov    $0x0,%eax
  801099:	8b 55 08             	mov    0x8(%ebp),%edx
  80109c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80109f:	89 c3                	mov    %eax,%ebx
  8010a1:	89 c7                	mov    %eax,%edi
  8010a3:	89 c6                	mov    %eax,%esi
  8010a5:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8010a7:	5b                   	pop    %ebx
  8010a8:	5e                   	pop    %esi
  8010a9:	5f                   	pop    %edi
  8010aa:	5d                   	pop    %ebp
  8010ab:	c3                   	ret    

008010ac <sys_cgetc>:

int
sys_cgetc(void)
{
  8010ac:	55                   	push   %ebp
  8010ad:	89 e5                	mov    %esp,%ebp
  8010af:	57                   	push   %edi
  8010b0:	56                   	push   %esi
  8010b1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8010b7:	b8 01 00 00 00       	mov    $0x1,%eax
  8010bc:	89 d1                	mov    %edx,%ecx
  8010be:	89 d3                	mov    %edx,%ebx
  8010c0:	89 d7                	mov    %edx,%edi
  8010c2:	89 d6                	mov    %edx,%esi
  8010c4:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8010c6:	5b                   	pop    %ebx
  8010c7:	5e                   	pop    %esi
  8010c8:	5f                   	pop    %edi
  8010c9:	5d                   	pop    %ebp
  8010ca:	c3                   	ret    

008010cb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8010cb:	55                   	push   %ebp
  8010cc:	89 e5                	mov    %esp,%ebp
  8010ce:	57                   	push   %edi
  8010cf:	56                   	push   %esi
  8010d0:	53                   	push   %ebx
  8010d1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010d4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010dc:	b8 03 00 00 00       	mov    $0x3,%eax
  8010e1:	89 cb                	mov    %ecx,%ebx
  8010e3:	89 cf                	mov    %ecx,%edi
  8010e5:	89 ce                	mov    %ecx,%esi
  8010e7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010e9:	85 c0                	test   %eax,%eax
  8010eb:	7f 08                	jg     8010f5 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8010ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010f0:	5b                   	pop    %ebx
  8010f1:	5e                   	pop    %esi
  8010f2:	5f                   	pop    %edi
  8010f3:	5d                   	pop    %ebp
  8010f4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010f5:	83 ec 0c             	sub    $0xc,%esp
  8010f8:	50                   	push   %eax
  8010f9:	6a 03                	push   $0x3
  8010fb:	68 a8 38 80 00       	push   $0x8038a8
  801100:	6a 43                	push   $0x43
  801102:	68 c5 38 80 00       	push   $0x8038c5
  801107:	e8 f7 f3 ff ff       	call   800503 <_panic>

0080110c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80110c:	55                   	push   %ebp
  80110d:	89 e5                	mov    %esp,%ebp
  80110f:	57                   	push   %edi
  801110:	56                   	push   %esi
  801111:	53                   	push   %ebx
	asm volatile("int %1\n"
  801112:	ba 00 00 00 00       	mov    $0x0,%edx
  801117:	b8 02 00 00 00       	mov    $0x2,%eax
  80111c:	89 d1                	mov    %edx,%ecx
  80111e:	89 d3                	mov    %edx,%ebx
  801120:	89 d7                	mov    %edx,%edi
  801122:	89 d6                	mov    %edx,%esi
  801124:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801126:	5b                   	pop    %ebx
  801127:	5e                   	pop    %esi
  801128:	5f                   	pop    %edi
  801129:	5d                   	pop    %ebp
  80112a:	c3                   	ret    

0080112b <sys_yield>:

void
sys_yield(void)
{
  80112b:	55                   	push   %ebp
  80112c:	89 e5                	mov    %esp,%ebp
  80112e:	57                   	push   %edi
  80112f:	56                   	push   %esi
  801130:	53                   	push   %ebx
	asm volatile("int %1\n"
  801131:	ba 00 00 00 00       	mov    $0x0,%edx
  801136:	b8 0b 00 00 00       	mov    $0xb,%eax
  80113b:	89 d1                	mov    %edx,%ecx
  80113d:	89 d3                	mov    %edx,%ebx
  80113f:	89 d7                	mov    %edx,%edi
  801141:	89 d6                	mov    %edx,%esi
  801143:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801145:	5b                   	pop    %ebx
  801146:	5e                   	pop    %esi
  801147:	5f                   	pop    %edi
  801148:	5d                   	pop    %ebp
  801149:	c3                   	ret    

0080114a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
  80114d:	57                   	push   %edi
  80114e:	56                   	push   %esi
  80114f:	53                   	push   %ebx
  801150:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801153:	be 00 00 00 00       	mov    $0x0,%esi
  801158:	8b 55 08             	mov    0x8(%ebp),%edx
  80115b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80115e:	b8 04 00 00 00       	mov    $0x4,%eax
  801163:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801166:	89 f7                	mov    %esi,%edi
  801168:	cd 30                	int    $0x30
	if(check && ret > 0)
  80116a:	85 c0                	test   %eax,%eax
  80116c:	7f 08                	jg     801176 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  80117a:	6a 04                	push   $0x4
  80117c:	68 a8 38 80 00       	push   $0x8038a8
  801181:	6a 43                	push   $0x43
  801183:	68 c5 38 80 00       	push   $0x8038c5
  801188:	e8 76 f3 ff ff       	call   800503 <_panic>

0080118d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80118d:	55                   	push   %ebp
  80118e:	89 e5                	mov    %esp,%ebp
  801190:	57                   	push   %edi
  801191:	56                   	push   %esi
  801192:	53                   	push   %ebx
  801193:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801196:	8b 55 08             	mov    0x8(%ebp),%edx
  801199:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80119c:	b8 05 00 00 00       	mov    $0x5,%eax
  8011a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011a4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011a7:	8b 75 18             	mov    0x18(%ebp),%esi
  8011aa:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011ac:	85 c0                	test   %eax,%eax
  8011ae:	7f 08                	jg     8011b8 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  8011bc:	6a 05                	push   $0x5
  8011be:	68 a8 38 80 00       	push   $0x8038a8
  8011c3:	6a 43                	push   $0x43
  8011c5:	68 c5 38 80 00       	push   $0x8038c5
  8011ca:	e8 34 f3 ff ff       	call   800503 <_panic>

008011cf <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
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
  8011e3:	b8 06 00 00 00       	mov    $0x6,%eax
  8011e8:	89 df                	mov    %ebx,%edi
  8011ea:	89 de                	mov    %ebx,%esi
  8011ec:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011ee:	85 c0                	test   %eax,%eax
  8011f0:	7f 08                	jg     8011fa <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  8011fe:	6a 06                	push   $0x6
  801200:	68 a8 38 80 00       	push   $0x8038a8
  801205:	6a 43                	push   $0x43
  801207:	68 c5 38 80 00       	push   $0x8038c5
  80120c:	e8 f2 f2 ff ff       	call   800503 <_panic>

00801211 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801211:	55                   	push   %ebp
  801212:	89 e5                	mov    %esp,%ebp
  801214:	57                   	push   %edi
  801215:	56                   	push   %esi
  801216:	53                   	push   %ebx
  801217:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80121a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80121f:	8b 55 08             	mov    0x8(%ebp),%edx
  801222:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801225:	b8 08 00 00 00       	mov    $0x8,%eax
  80122a:	89 df                	mov    %ebx,%edi
  80122c:	89 de                	mov    %ebx,%esi
  80122e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801230:	85 c0                	test   %eax,%eax
  801232:	7f 08                	jg     80123c <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801234:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801237:	5b                   	pop    %ebx
  801238:	5e                   	pop    %esi
  801239:	5f                   	pop    %edi
  80123a:	5d                   	pop    %ebp
  80123b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80123c:	83 ec 0c             	sub    $0xc,%esp
  80123f:	50                   	push   %eax
  801240:	6a 08                	push   $0x8
  801242:	68 a8 38 80 00       	push   $0x8038a8
  801247:	6a 43                	push   $0x43
  801249:	68 c5 38 80 00       	push   $0x8038c5
  80124e:	e8 b0 f2 ff ff       	call   800503 <_panic>

00801253 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801253:	55                   	push   %ebp
  801254:	89 e5                	mov    %esp,%ebp
  801256:	57                   	push   %edi
  801257:	56                   	push   %esi
  801258:	53                   	push   %ebx
  801259:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80125c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801261:	8b 55 08             	mov    0x8(%ebp),%edx
  801264:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801267:	b8 09 00 00 00       	mov    $0x9,%eax
  80126c:	89 df                	mov    %ebx,%edi
  80126e:	89 de                	mov    %ebx,%esi
  801270:	cd 30                	int    $0x30
	if(check && ret > 0)
  801272:	85 c0                	test   %eax,%eax
  801274:	7f 08                	jg     80127e <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801276:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801279:	5b                   	pop    %ebx
  80127a:	5e                   	pop    %esi
  80127b:	5f                   	pop    %edi
  80127c:	5d                   	pop    %ebp
  80127d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80127e:	83 ec 0c             	sub    $0xc,%esp
  801281:	50                   	push   %eax
  801282:	6a 09                	push   $0x9
  801284:	68 a8 38 80 00       	push   $0x8038a8
  801289:	6a 43                	push   $0x43
  80128b:	68 c5 38 80 00       	push   $0x8038c5
  801290:	e8 6e f2 ff ff       	call   800503 <_panic>

00801295 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801295:	55                   	push   %ebp
  801296:	89 e5                	mov    %esp,%ebp
  801298:	57                   	push   %edi
  801299:	56                   	push   %esi
  80129a:	53                   	push   %ebx
  80129b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80129e:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012a9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8012ae:	89 df                	mov    %ebx,%edi
  8012b0:	89 de                	mov    %ebx,%esi
  8012b2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012b4:	85 c0                	test   %eax,%eax
  8012b6:	7f 08                	jg     8012c0 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8012b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012bb:	5b                   	pop    %ebx
  8012bc:	5e                   	pop    %esi
  8012bd:	5f                   	pop    %edi
  8012be:	5d                   	pop    %ebp
  8012bf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012c0:	83 ec 0c             	sub    $0xc,%esp
  8012c3:	50                   	push   %eax
  8012c4:	6a 0a                	push   $0xa
  8012c6:	68 a8 38 80 00       	push   $0x8038a8
  8012cb:	6a 43                	push   $0x43
  8012cd:	68 c5 38 80 00       	push   $0x8038c5
  8012d2:	e8 2c f2 ff ff       	call   800503 <_panic>

008012d7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8012d7:	55                   	push   %ebp
  8012d8:	89 e5                	mov    %esp,%ebp
  8012da:	57                   	push   %edi
  8012db:	56                   	push   %esi
  8012dc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012e3:	b8 0c 00 00 00       	mov    $0xc,%eax
  8012e8:	be 00 00 00 00       	mov    $0x0,%esi
  8012ed:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012f0:	8b 7d 14             	mov    0x14(%ebp),%edi
  8012f3:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8012f5:	5b                   	pop    %ebx
  8012f6:	5e                   	pop    %esi
  8012f7:	5f                   	pop    %edi
  8012f8:	5d                   	pop    %ebp
  8012f9:	c3                   	ret    

008012fa <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8012fa:	55                   	push   %ebp
  8012fb:	89 e5                	mov    %esp,%ebp
  8012fd:	57                   	push   %edi
  8012fe:	56                   	push   %esi
  8012ff:	53                   	push   %ebx
  801300:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801303:	b9 00 00 00 00       	mov    $0x0,%ecx
  801308:	8b 55 08             	mov    0x8(%ebp),%edx
  80130b:	b8 0d 00 00 00       	mov    $0xd,%eax
  801310:	89 cb                	mov    %ecx,%ebx
  801312:	89 cf                	mov    %ecx,%edi
  801314:	89 ce                	mov    %ecx,%esi
  801316:	cd 30                	int    $0x30
	if(check && ret > 0)
  801318:	85 c0                	test   %eax,%eax
  80131a:	7f 08                	jg     801324 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80131c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80131f:	5b                   	pop    %ebx
  801320:	5e                   	pop    %esi
  801321:	5f                   	pop    %edi
  801322:	5d                   	pop    %ebp
  801323:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801324:	83 ec 0c             	sub    $0xc,%esp
  801327:	50                   	push   %eax
  801328:	6a 0d                	push   $0xd
  80132a:	68 a8 38 80 00       	push   $0x8038a8
  80132f:	6a 43                	push   $0x43
  801331:	68 c5 38 80 00       	push   $0x8038c5
  801336:	e8 c8 f1 ff ff       	call   800503 <_panic>

0080133b <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
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
  80134c:	b8 0e 00 00 00       	mov    $0xe,%eax
  801351:	89 df                	mov    %ebx,%edi
  801353:	89 de                	mov    %ebx,%esi
  801355:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801357:	5b                   	pop    %ebx
  801358:	5e                   	pop    %esi
  801359:	5f                   	pop    %edi
  80135a:	5d                   	pop    %ebp
  80135b:	c3                   	ret    

0080135c <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80135c:	55                   	push   %ebp
  80135d:	89 e5                	mov    %esp,%ebp
  80135f:	57                   	push   %edi
  801360:	56                   	push   %esi
  801361:	53                   	push   %ebx
	asm volatile("int %1\n"
  801362:	b9 00 00 00 00       	mov    $0x0,%ecx
  801367:	8b 55 08             	mov    0x8(%ebp),%edx
  80136a:	b8 0f 00 00 00       	mov    $0xf,%eax
  80136f:	89 cb                	mov    %ecx,%ebx
  801371:	89 cf                	mov    %ecx,%edi
  801373:	89 ce                	mov    %ecx,%esi
  801375:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801377:	5b                   	pop    %ebx
  801378:	5e                   	pop    %esi
  801379:	5f                   	pop    %edi
  80137a:	5d                   	pop    %ebp
  80137b:	c3                   	ret    

0080137c <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
  80137f:	57                   	push   %edi
  801380:	56                   	push   %esi
  801381:	53                   	push   %ebx
	asm volatile("int %1\n"
  801382:	ba 00 00 00 00       	mov    $0x0,%edx
  801387:	b8 10 00 00 00       	mov    $0x10,%eax
  80138c:	89 d1                	mov    %edx,%ecx
  80138e:	89 d3                	mov    %edx,%ebx
  801390:	89 d7                	mov    %edx,%edi
  801392:	89 d6                	mov    %edx,%esi
  801394:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801396:	5b                   	pop    %ebx
  801397:	5e                   	pop    %esi
  801398:	5f                   	pop    %edi
  801399:	5d                   	pop    %ebp
  80139a:	c3                   	ret    

0080139b <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  80139b:	55                   	push   %ebp
  80139c:	89 e5                	mov    %esp,%ebp
  80139e:	57                   	push   %edi
  80139f:	56                   	push   %esi
  8013a0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013a1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8013a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013ac:	b8 11 00 00 00       	mov    $0x11,%eax
  8013b1:	89 df                	mov    %ebx,%edi
  8013b3:	89 de                	mov    %ebx,%esi
  8013b5:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8013b7:	5b                   	pop    %ebx
  8013b8:	5e                   	pop    %esi
  8013b9:	5f                   	pop    %edi
  8013ba:	5d                   	pop    %ebp
  8013bb:	c3                   	ret    

008013bc <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
  8013bf:	57                   	push   %edi
  8013c0:	56                   	push   %esi
  8013c1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013c2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8013ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013cd:	b8 12 00 00 00       	mov    $0x12,%eax
  8013d2:	89 df                	mov    %ebx,%edi
  8013d4:	89 de                	mov    %ebx,%esi
  8013d6:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8013d8:	5b                   	pop    %ebx
  8013d9:	5e                   	pop    %esi
  8013da:	5f                   	pop    %edi
  8013db:	5d                   	pop    %ebp
  8013dc:	c3                   	ret    

008013dd <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8013dd:	55                   	push   %ebp
  8013de:	89 e5                	mov    %esp,%ebp
  8013e0:	57                   	push   %edi
  8013e1:	56                   	push   %esi
  8013e2:	53                   	push   %ebx
  8013e3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8013ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013f1:	b8 13 00 00 00       	mov    $0x13,%eax
  8013f6:	89 df                	mov    %ebx,%edi
  8013f8:	89 de                	mov    %ebx,%esi
  8013fa:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013fc:	85 c0                	test   %eax,%eax
  8013fe:	7f 08                	jg     801408 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801400:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801403:	5b                   	pop    %ebx
  801404:	5e                   	pop    %esi
  801405:	5f                   	pop    %edi
  801406:	5d                   	pop    %ebp
  801407:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801408:	83 ec 0c             	sub    $0xc,%esp
  80140b:	50                   	push   %eax
  80140c:	6a 13                	push   $0x13
  80140e:	68 a8 38 80 00       	push   $0x8038a8
  801413:	6a 43                	push   $0x43
  801415:	68 c5 38 80 00       	push   $0x8038c5
  80141a:	e8 e4 f0 ff ff       	call   800503 <_panic>

0080141f <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80141f:	55                   	push   %ebp
  801420:	89 e5                	mov    %esp,%ebp
  801422:	57                   	push   %edi
  801423:	56                   	push   %esi
  801424:	53                   	push   %ebx
	asm volatile("int %1\n"
  801425:	b9 00 00 00 00       	mov    $0x0,%ecx
  80142a:	8b 55 08             	mov    0x8(%ebp),%edx
  80142d:	b8 14 00 00 00       	mov    $0x14,%eax
  801432:	89 cb                	mov    %ecx,%ebx
  801434:	89 cf                	mov    %ecx,%edi
  801436:	89 ce                	mov    %ecx,%esi
  801438:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  80143a:	5b                   	pop    %ebx
  80143b:	5e                   	pop    %esi
  80143c:	5f                   	pop    %edi
  80143d:	5d                   	pop    %ebp
  80143e:	c3                   	ret    

0080143f <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80143f:	55                   	push   %ebp
  801440:	89 e5                	mov    %esp,%ebp
  801442:	53                   	push   %ebx
  801443:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801446:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80144d:	f6 c5 04             	test   $0x4,%ch
  801450:	75 45                	jne    801497 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801452:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801459:	83 e1 07             	and    $0x7,%ecx
  80145c:	83 f9 07             	cmp    $0x7,%ecx
  80145f:	74 6f                	je     8014d0 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801461:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801468:	81 e1 05 08 00 00    	and    $0x805,%ecx
  80146e:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801474:	0f 84 b6 00 00 00    	je     801530 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  80147a:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801481:	83 e1 05             	and    $0x5,%ecx
  801484:	83 f9 05             	cmp    $0x5,%ecx
  801487:	0f 84 d7 00 00 00    	je     801564 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  80148d:	b8 00 00 00 00       	mov    $0x0,%eax
  801492:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801495:	c9                   	leave  
  801496:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801497:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80149e:	c1 e2 0c             	shl    $0xc,%edx
  8014a1:	83 ec 0c             	sub    $0xc,%esp
  8014a4:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8014aa:	51                   	push   %ecx
  8014ab:	52                   	push   %edx
  8014ac:	50                   	push   %eax
  8014ad:	52                   	push   %edx
  8014ae:	6a 00                	push   $0x0
  8014b0:	e8 d8 fc ff ff       	call   80118d <sys_page_map>
		if(r < 0)
  8014b5:	83 c4 20             	add    $0x20,%esp
  8014b8:	85 c0                	test   %eax,%eax
  8014ba:	79 d1                	jns    80148d <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8014bc:	83 ec 04             	sub    $0x4,%esp
  8014bf:	68 d3 38 80 00       	push   $0x8038d3
  8014c4:	6a 54                	push   $0x54
  8014c6:	68 e9 38 80 00       	push   $0x8038e9
  8014cb:	e8 33 f0 ff ff       	call   800503 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8014d0:	89 d3                	mov    %edx,%ebx
  8014d2:	c1 e3 0c             	shl    $0xc,%ebx
  8014d5:	83 ec 0c             	sub    $0xc,%esp
  8014d8:	68 05 08 00 00       	push   $0x805
  8014dd:	53                   	push   %ebx
  8014de:	50                   	push   %eax
  8014df:	53                   	push   %ebx
  8014e0:	6a 00                	push   $0x0
  8014e2:	e8 a6 fc ff ff       	call   80118d <sys_page_map>
		if(r < 0)
  8014e7:	83 c4 20             	add    $0x20,%esp
  8014ea:	85 c0                	test   %eax,%eax
  8014ec:	78 2e                	js     80151c <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8014ee:	83 ec 0c             	sub    $0xc,%esp
  8014f1:	68 05 08 00 00       	push   $0x805
  8014f6:	53                   	push   %ebx
  8014f7:	6a 00                	push   $0x0
  8014f9:	53                   	push   %ebx
  8014fa:	6a 00                	push   $0x0
  8014fc:	e8 8c fc ff ff       	call   80118d <sys_page_map>
		if(r < 0)
  801501:	83 c4 20             	add    $0x20,%esp
  801504:	85 c0                	test   %eax,%eax
  801506:	79 85                	jns    80148d <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801508:	83 ec 04             	sub    $0x4,%esp
  80150b:	68 d3 38 80 00       	push   $0x8038d3
  801510:	6a 5f                	push   $0x5f
  801512:	68 e9 38 80 00       	push   $0x8038e9
  801517:	e8 e7 ef ff ff       	call   800503 <_panic>
			panic("sys_page_map() panic\n");
  80151c:	83 ec 04             	sub    $0x4,%esp
  80151f:	68 d3 38 80 00       	push   $0x8038d3
  801524:	6a 5b                	push   $0x5b
  801526:	68 e9 38 80 00       	push   $0x8038e9
  80152b:	e8 d3 ef ff ff       	call   800503 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801530:	c1 e2 0c             	shl    $0xc,%edx
  801533:	83 ec 0c             	sub    $0xc,%esp
  801536:	68 05 08 00 00       	push   $0x805
  80153b:	52                   	push   %edx
  80153c:	50                   	push   %eax
  80153d:	52                   	push   %edx
  80153e:	6a 00                	push   $0x0
  801540:	e8 48 fc ff ff       	call   80118d <sys_page_map>
		if(r < 0)
  801545:	83 c4 20             	add    $0x20,%esp
  801548:	85 c0                	test   %eax,%eax
  80154a:	0f 89 3d ff ff ff    	jns    80148d <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801550:	83 ec 04             	sub    $0x4,%esp
  801553:	68 d3 38 80 00       	push   $0x8038d3
  801558:	6a 66                	push   $0x66
  80155a:	68 e9 38 80 00       	push   $0x8038e9
  80155f:	e8 9f ef ff ff       	call   800503 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801564:	c1 e2 0c             	shl    $0xc,%edx
  801567:	83 ec 0c             	sub    $0xc,%esp
  80156a:	6a 05                	push   $0x5
  80156c:	52                   	push   %edx
  80156d:	50                   	push   %eax
  80156e:	52                   	push   %edx
  80156f:	6a 00                	push   $0x0
  801571:	e8 17 fc ff ff       	call   80118d <sys_page_map>
		if(r < 0)
  801576:	83 c4 20             	add    $0x20,%esp
  801579:	85 c0                	test   %eax,%eax
  80157b:	0f 89 0c ff ff ff    	jns    80148d <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801581:	83 ec 04             	sub    $0x4,%esp
  801584:	68 d3 38 80 00       	push   $0x8038d3
  801589:	6a 6d                	push   $0x6d
  80158b:	68 e9 38 80 00       	push   $0x8038e9
  801590:	e8 6e ef ff ff       	call   800503 <_panic>

00801595 <pgfault>:
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
  801598:	53                   	push   %ebx
  801599:	83 ec 04             	sub    $0x4,%esp
  80159c:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80159f:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8015a1:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8015a5:	0f 84 99 00 00 00    	je     801644 <pgfault+0xaf>
  8015ab:	89 c2                	mov    %eax,%edx
  8015ad:	c1 ea 16             	shr    $0x16,%edx
  8015b0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015b7:	f6 c2 01             	test   $0x1,%dl
  8015ba:	0f 84 84 00 00 00    	je     801644 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8015c0:	89 c2                	mov    %eax,%edx
  8015c2:	c1 ea 0c             	shr    $0xc,%edx
  8015c5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015cc:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8015d2:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8015d8:	75 6a                	jne    801644 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8015da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015df:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8015e1:	83 ec 04             	sub    $0x4,%esp
  8015e4:	6a 07                	push   $0x7
  8015e6:	68 00 f0 7f 00       	push   $0x7ff000
  8015eb:	6a 00                	push   $0x0
  8015ed:	e8 58 fb ff ff       	call   80114a <sys_page_alloc>
	if(ret < 0)
  8015f2:	83 c4 10             	add    $0x10,%esp
  8015f5:	85 c0                	test   %eax,%eax
  8015f7:	78 5f                	js     801658 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8015f9:	83 ec 04             	sub    $0x4,%esp
  8015fc:	68 00 10 00 00       	push   $0x1000
  801601:	53                   	push   %ebx
  801602:	68 00 f0 7f 00       	push   $0x7ff000
  801607:	e8 3c f9 ff ff       	call   800f48 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  80160c:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801613:	53                   	push   %ebx
  801614:	6a 00                	push   $0x0
  801616:	68 00 f0 7f 00       	push   $0x7ff000
  80161b:	6a 00                	push   $0x0
  80161d:	e8 6b fb ff ff       	call   80118d <sys_page_map>
	if(ret < 0)
  801622:	83 c4 20             	add    $0x20,%esp
  801625:	85 c0                	test   %eax,%eax
  801627:	78 43                	js     80166c <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801629:	83 ec 08             	sub    $0x8,%esp
  80162c:	68 00 f0 7f 00       	push   $0x7ff000
  801631:	6a 00                	push   $0x0
  801633:	e8 97 fb ff ff       	call   8011cf <sys_page_unmap>
	if(ret < 0)
  801638:	83 c4 10             	add    $0x10,%esp
  80163b:	85 c0                	test   %eax,%eax
  80163d:	78 41                	js     801680 <pgfault+0xeb>
}
  80163f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801642:	c9                   	leave  
  801643:	c3                   	ret    
		panic("panic at pgfault()\n");
  801644:	83 ec 04             	sub    $0x4,%esp
  801647:	68 f4 38 80 00       	push   $0x8038f4
  80164c:	6a 26                	push   $0x26
  80164e:	68 e9 38 80 00       	push   $0x8038e9
  801653:	e8 ab ee ff ff       	call   800503 <_panic>
		panic("panic in sys_page_alloc()\n");
  801658:	83 ec 04             	sub    $0x4,%esp
  80165b:	68 08 39 80 00       	push   $0x803908
  801660:	6a 31                	push   $0x31
  801662:	68 e9 38 80 00       	push   $0x8038e9
  801667:	e8 97 ee ff ff       	call   800503 <_panic>
		panic("panic in sys_page_map()\n");
  80166c:	83 ec 04             	sub    $0x4,%esp
  80166f:	68 23 39 80 00       	push   $0x803923
  801674:	6a 36                	push   $0x36
  801676:	68 e9 38 80 00       	push   $0x8038e9
  80167b:	e8 83 ee ff ff       	call   800503 <_panic>
		panic("panic in sys_page_unmap()\n");
  801680:	83 ec 04             	sub    $0x4,%esp
  801683:	68 3c 39 80 00       	push   $0x80393c
  801688:	6a 39                	push   $0x39
  80168a:	68 e9 38 80 00       	push   $0x8038e9
  80168f:	e8 6f ee ff ff       	call   800503 <_panic>

00801694 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801694:	55                   	push   %ebp
  801695:	89 e5                	mov    %esp,%ebp
  801697:	57                   	push   %edi
  801698:	56                   	push   %esi
  801699:	53                   	push   %ebx
  80169a:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  80169d:	68 95 15 80 00       	push   $0x801595
  8016a2:	e8 d5 18 00 00       	call   802f7c <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8016a7:	b8 07 00 00 00       	mov    $0x7,%eax
  8016ac:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8016ae:	83 c4 10             	add    $0x10,%esp
  8016b1:	85 c0                	test   %eax,%eax
  8016b3:	78 2a                	js     8016df <fork+0x4b>
  8016b5:	89 c6                	mov    %eax,%esi
  8016b7:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8016b9:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8016be:	75 4b                	jne    80170b <fork+0x77>
		thisenv = &envs[ENVX(sys_getenvid())];
  8016c0:	e8 47 fa ff ff       	call   80110c <sys_getenvid>
  8016c5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8016ca:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8016d0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8016d5:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8016da:	e9 90 00 00 00       	jmp    80176f <fork+0xdb>
		panic("the fork panic! at sys_exofork()\n");
  8016df:	83 ec 04             	sub    $0x4,%esp
  8016e2:	68 58 39 80 00       	push   $0x803958
  8016e7:	68 8c 00 00 00       	push   $0x8c
  8016ec:	68 e9 38 80 00       	push   $0x8038e9
  8016f1:	e8 0d ee ff ff       	call   800503 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8016f6:	89 f8                	mov    %edi,%eax
  8016f8:	e8 42 fd ff ff       	call   80143f <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8016fd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801703:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801709:	74 26                	je     801731 <fork+0x9d>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  80170b:	89 d8                	mov    %ebx,%eax
  80170d:	c1 e8 16             	shr    $0x16,%eax
  801710:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801717:	a8 01                	test   $0x1,%al
  801719:	74 e2                	je     8016fd <fork+0x69>
  80171b:	89 da                	mov    %ebx,%edx
  80171d:	c1 ea 0c             	shr    $0xc,%edx
  801720:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801727:	83 e0 05             	and    $0x5,%eax
  80172a:	83 f8 05             	cmp    $0x5,%eax
  80172d:	75 ce                	jne    8016fd <fork+0x69>
  80172f:	eb c5                	jmp    8016f6 <fork+0x62>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801731:	83 ec 04             	sub    $0x4,%esp
  801734:	6a 07                	push   $0x7
  801736:	68 00 f0 bf ee       	push   $0xeebff000
  80173b:	56                   	push   %esi
  80173c:	e8 09 fa ff ff       	call   80114a <sys_page_alloc>
	if(ret < 0)
  801741:	83 c4 10             	add    $0x10,%esp
  801744:	85 c0                	test   %eax,%eax
  801746:	78 31                	js     801779 <fork+0xe5>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801748:	83 ec 08             	sub    $0x8,%esp
  80174b:	68 eb 2f 80 00       	push   $0x802feb
  801750:	56                   	push   %esi
  801751:	e8 3f fb ff ff       	call   801295 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801756:	83 c4 10             	add    $0x10,%esp
  801759:	85 c0                	test   %eax,%eax
  80175b:	78 33                	js     801790 <fork+0xfc>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80175d:	83 ec 08             	sub    $0x8,%esp
  801760:	6a 02                	push   $0x2
  801762:	56                   	push   %esi
  801763:	e8 a9 fa ff ff       	call   801211 <sys_env_set_status>
	if(ret < 0)
  801768:	83 c4 10             	add    $0x10,%esp
  80176b:	85 c0                	test   %eax,%eax
  80176d:	78 38                	js     8017a7 <fork+0x113>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  80176f:	89 f0                	mov    %esi,%eax
  801771:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801774:	5b                   	pop    %ebx
  801775:	5e                   	pop    %esi
  801776:	5f                   	pop    %edi
  801777:	5d                   	pop    %ebp
  801778:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801779:	83 ec 04             	sub    $0x4,%esp
  80177c:	68 08 39 80 00       	push   $0x803908
  801781:	68 98 00 00 00       	push   $0x98
  801786:	68 e9 38 80 00       	push   $0x8038e9
  80178b:	e8 73 ed ff ff       	call   800503 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801790:	83 ec 04             	sub    $0x4,%esp
  801793:	68 7c 39 80 00       	push   $0x80397c
  801798:	68 9b 00 00 00       	push   $0x9b
  80179d:	68 e9 38 80 00       	push   $0x8038e9
  8017a2:	e8 5c ed ff ff       	call   800503 <_panic>
		panic("panic in sys_env_set_status()\n");
  8017a7:	83 ec 04             	sub    $0x4,%esp
  8017aa:	68 a4 39 80 00       	push   $0x8039a4
  8017af:	68 9e 00 00 00       	push   $0x9e
  8017b4:	68 e9 38 80 00       	push   $0x8038e9
  8017b9:	e8 45 ed ff ff       	call   800503 <_panic>

008017be <sfork>:

// Challenge!
int
sfork(void)
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
  8017c1:	57                   	push   %edi
  8017c2:	56                   	push   %esi
  8017c3:	53                   	push   %ebx
  8017c4:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8017c7:	68 95 15 80 00       	push   $0x801595
  8017cc:	e8 ab 17 00 00       	call   802f7c <set_pgfault_handler>
  8017d1:	b8 07 00 00 00       	mov    $0x7,%eax
  8017d6:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8017d8:	83 c4 10             	add    $0x10,%esp
  8017db:	85 c0                	test   %eax,%eax
  8017dd:	78 2a                	js     801809 <sfork+0x4b>
  8017df:	89 c7                	mov    %eax,%edi
  8017e1:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8017e3:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8017e8:	75 58                	jne    801842 <sfork+0x84>
		thisenv = &envs[ENVX(sys_getenvid())];
  8017ea:	e8 1d f9 ff ff       	call   80110c <sys_getenvid>
  8017ef:	25 ff 03 00 00       	and    $0x3ff,%eax
  8017f4:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8017fa:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8017ff:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801804:	e9 d4 00 00 00       	jmp    8018dd <sfork+0x11f>
		panic("the fork panic! at sys_exofork()\n");
  801809:	83 ec 04             	sub    $0x4,%esp
  80180c:	68 58 39 80 00       	push   $0x803958
  801811:	68 af 00 00 00       	push   $0xaf
  801816:	68 e9 38 80 00       	push   $0x8038e9
  80181b:	e8 e3 ec ff ff       	call   800503 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801820:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801825:	89 f0                	mov    %esi,%eax
  801827:	e8 13 fc ff ff       	call   80143f <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80182c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801832:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801838:	77 65                	ja     80189f <sfork+0xe1>
		if(i == (USTACKTOP - PGSIZE))
  80183a:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801840:	74 de                	je     801820 <sfork+0x62>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801842:	89 d8                	mov    %ebx,%eax
  801844:	c1 e8 16             	shr    $0x16,%eax
  801847:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80184e:	a8 01                	test   $0x1,%al
  801850:	74 da                	je     80182c <sfork+0x6e>
  801852:	89 da                	mov    %ebx,%edx
  801854:	c1 ea 0c             	shr    $0xc,%edx
  801857:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80185e:	83 e0 05             	and    $0x5,%eax
  801861:	83 f8 05             	cmp    $0x5,%eax
  801864:	75 c6                	jne    80182c <sfork+0x6e>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801866:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  80186d:	c1 e2 0c             	shl    $0xc,%edx
  801870:	83 ec 0c             	sub    $0xc,%esp
  801873:	83 e0 07             	and    $0x7,%eax
  801876:	50                   	push   %eax
  801877:	52                   	push   %edx
  801878:	56                   	push   %esi
  801879:	52                   	push   %edx
  80187a:	6a 00                	push   $0x0
  80187c:	e8 0c f9 ff ff       	call   80118d <sys_page_map>
  801881:	83 c4 20             	add    $0x20,%esp
  801884:	85 c0                	test   %eax,%eax
  801886:	74 a4                	je     80182c <sfork+0x6e>
				panic("sys_page_map() panic\n");
  801888:	83 ec 04             	sub    $0x4,%esp
  80188b:	68 d3 38 80 00       	push   $0x8038d3
  801890:	68 ba 00 00 00       	push   $0xba
  801895:	68 e9 38 80 00       	push   $0x8038e9
  80189a:	e8 64 ec ff ff       	call   800503 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80189f:	83 ec 04             	sub    $0x4,%esp
  8018a2:	6a 07                	push   $0x7
  8018a4:	68 00 f0 bf ee       	push   $0xeebff000
  8018a9:	57                   	push   %edi
  8018aa:	e8 9b f8 ff ff       	call   80114a <sys_page_alloc>
	if(ret < 0)
  8018af:	83 c4 10             	add    $0x10,%esp
  8018b2:	85 c0                	test   %eax,%eax
  8018b4:	78 31                	js     8018e7 <sfork+0x129>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8018b6:	83 ec 08             	sub    $0x8,%esp
  8018b9:	68 eb 2f 80 00       	push   $0x802feb
  8018be:	57                   	push   %edi
  8018bf:	e8 d1 f9 ff ff       	call   801295 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8018c4:	83 c4 10             	add    $0x10,%esp
  8018c7:	85 c0                	test   %eax,%eax
  8018c9:	78 33                	js     8018fe <sfork+0x140>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8018cb:	83 ec 08             	sub    $0x8,%esp
  8018ce:	6a 02                	push   $0x2
  8018d0:	57                   	push   %edi
  8018d1:	e8 3b f9 ff ff       	call   801211 <sys_env_set_status>
	if(ret < 0)
  8018d6:	83 c4 10             	add    $0x10,%esp
  8018d9:	85 c0                	test   %eax,%eax
  8018db:	78 38                	js     801915 <sfork+0x157>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8018dd:	89 f8                	mov    %edi,%eax
  8018df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018e2:	5b                   	pop    %ebx
  8018e3:	5e                   	pop    %esi
  8018e4:	5f                   	pop    %edi
  8018e5:	5d                   	pop    %ebp
  8018e6:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8018e7:	83 ec 04             	sub    $0x4,%esp
  8018ea:	68 08 39 80 00       	push   $0x803908
  8018ef:	68 c0 00 00 00       	push   $0xc0
  8018f4:	68 e9 38 80 00       	push   $0x8038e9
  8018f9:	e8 05 ec ff ff       	call   800503 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8018fe:	83 ec 04             	sub    $0x4,%esp
  801901:	68 7c 39 80 00       	push   $0x80397c
  801906:	68 c3 00 00 00       	push   $0xc3
  80190b:	68 e9 38 80 00       	push   $0x8038e9
  801910:	e8 ee eb ff ff       	call   800503 <_panic>
		panic("panic in sys_env_set_status()\n");
  801915:	83 ec 04             	sub    $0x4,%esp
  801918:	68 a4 39 80 00       	push   $0x8039a4
  80191d:	68 c6 00 00 00       	push   $0xc6
  801922:	68 e9 38 80 00       	push   $0x8038e9
  801927:	e8 d7 eb ff ff       	call   800503 <_panic>

0080192c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80192f:	8b 45 08             	mov    0x8(%ebp),%eax
  801932:	05 00 00 00 30       	add    $0x30000000,%eax
  801937:	c1 e8 0c             	shr    $0xc,%eax
}
  80193a:	5d                   	pop    %ebp
  80193b:	c3                   	ret    

0080193c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80193f:	8b 45 08             	mov    0x8(%ebp),%eax
  801942:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801947:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80194c:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801951:	5d                   	pop    %ebp
  801952:	c3                   	ret    

00801953 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
  801956:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80195b:	89 c2                	mov    %eax,%edx
  80195d:	c1 ea 16             	shr    $0x16,%edx
  801960:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801967:	f6 c2 01             	test   $0x1,%dl
  80196a:	74 2d                	je     801999 <fd_alloc+0x46>
  80196c:	89 c2                	mov    %eax,%edx
  80196e:	c1 ea 0c             	shr    $0xc,%edx
  801971:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801978:	f6 c2 01             	test   $0x1,%dl
  80197b:	74 1c                	je     801999 <fd_alloc+0x46>
  80197d:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801982:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801987:	75 d2                	jne    80195b <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801989:	8b 45 08             	mov    0x8(%ebp),%eax
  80198c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801992:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801997:	eb 0a                	jmp    8019a3 <fd_alloc+0x50>
			*fd_store = fd;
  801999:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80199c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80199e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019a3:	5d                   	pop    %ebp
  8019a4:	c3                   	ret    

008019a5 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
  8019a8:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8019ab:	83 f8 1f             	cmp    $0x1f,%eax
  8019ae:	77 30                	ja     8019e0 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8019b0:	c1 e0 0c             	shl    $0xc,%eax
  8019b3:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8019b8:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8019be:	f6 c2 01             	test   $0x1,%dl
  8019c1:	74 24                	je     8019e7 <fd_lookup+0x42>
  8019c3:	89 c2                	mov    %eax,%edx
  8019c5:	c1 ea 0c             	shr    $0xc,%edx
  8019c8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8019cf:	f6 c2 01             	test   $0x1,%dl
  8019d2:	74 1a                	je     8019ee <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8019d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d7:	89 02                	mov    %eax,(%edx)
	return 0;
  8019d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019de:	5d                   	pop    %ebp
  8019df:	c3                   	ret    
		return -E_INVAL;
  8019e0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019e5:	eb f7                	jmp    8019de <fd_lookup+0x39>
		return -E_INVAL;
  8019e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019ec:	eb f0                	jmp    8019de <fd_lookup+0x39>
  8019ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019f3:	eb e9                	jmp    8019de <fd_lookup+0x39>

008019f5 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
  8019f8:	83 ec 08             	sub    $0x8,%esp
  8019fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8019fe:	ba 00 00 00 00       	mov    $0x0,%edx
  801a03:	b8 20 40 80 00       	mov    $0x804020,%eax
		if (devtab[i]->dev_id == dev_id) {
  801a08:	39 08                	cmp    %ecx,(%eax)
  801a0a:	74 38                	je     801a44 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801a0c:	83 c2 01             	add    $0x1,%edx
  801a0f:	8b 04 95 40 3a 80 00 	mov    0x803a40(,%edx,4),%eax
  801a16:	85 c0                	test   %eax,%eax
  801a18:	75 ee                	jne    801a08 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801a1a:	a1 08 50 80 00       	mov    0x805008,%eax
  801a1f:	8b 40 48             	mov    0x48(%eax),%eax
  801a22:	83 ec 04             	sub    $0x4,%esp
  801a25:	51                   	push   %ecx
  801a26:	50                   	push   %eax
  801a27:	68 c4 39 80 00       	push   $0x8039c4
  801a2c:	e8 c8 eb ff ff       	call   8005f9 <cprintf>
	*dev = 0;
  801a31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a34:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801a3a:	83 c4 10             	add    $0x10,%esp
  801a3d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    
			*dev = devtab[i];
  801a44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a47:	89 01                	mov    %eax,(%ecx)
			return 0;
  801a49:	b8 00 00 00 00       	mov    $0x0,%eax
  801a4e:	eb f2                	jmp    801a42 <dev_lookup+0x4d>

00801a50 <fd_close>:
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
  801a53:	57                   	push   %edi
  801a54:	56                   	push   %esi
  801a55:	53                   	push   %ebx
  801a56:	83 ec 24             	sub    $0x24,%esp
  801a59:	8b 75 08             	mov    0x8(%ebp),%esi
  801a5c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801a5f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801a62:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801a63:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801a69:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801a6c:	50                   	push   %eax
  801a6d:	e8 33 ff ff ff       	call   8019a5 <fd_lookup>
  801a72:	89 c3                	mov    %eax,%ebx
  801a74:	83 c4 10             	add    $0x10,%esp
  801a77:	85 c0                	test   %eax,%eax
  801a79:	78 05                	js     801a80 <fd_close+0x30>
	    || fd != fd2)
  801a7b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801a7e:	74 16                	je     801a96 <fd_close+0x46>
		return (must_exist ? r : 0);
  801a80:	89 f8                	mov    %edi,%eax
  801a82:	84 c0                	test   %al,%al
  801a84:	b8 00 00 00 00       	mov    $0x0,%eax
  801a89:	0f 44 d8             	cmove  %eax,%ebx
}
  801a8c:	89 d8                	mov    %ebx,%eax
  801a8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a91:	5b                   	pop    %ebx
  801a92:	5e                   	pop    %esi
  801a93:	5f                   	pop    %edi
  801a94:	5d                   	pop    %ebp
  801a95:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801a96:	83 ec 08             	sub    $0x8,%esp
  801a99:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801a9c:	50                   	push   %eax
  801a9d:	ff 36                	pushl  (%esi)
  801a9f:	e8 51 ff ff ff       	call   8019f5 <dev_lookup>
  801aa4:	89 c3                	mov    %eax,%ebx
  801aa6:	83 c4 10             	add    $0x10,%esp
  801aa9:	85 c0                	test   %eax,%eax
  801aab:	78 1a                	js     801ac7 <fd_close+0x77>
		if (dev->dev_close)
  801aad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ab0:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801ab3:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801ab8:	85 c0                	test   %eax,%eax
  801aba:	74 0b                	je     801ac7 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801abc:	83 ec 0c             	sub    $0xc,%esp
  801abf:	56                   	push   %esi
  801ac0:	ff d0                	call   *%eax
  801ac2:	89 c3                	mov    %eax,%ebx
  801ac4:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801ac7:	83 ec 08             	sub    $0x8,%esp
  801aca:	56                   	push   %esi
  801acb:	6a 00                	push   $0x0
  801acd:	e8 fd f6 ff ff       	call   8011cf <sys_page_unmap>
	return r;
  801ad2:	83 c4 10             	add    $0x10,%esp
  801ad5:	eb b5                	jmp    801a8c <fd_close+0x3c>

00801ad7 <close>:

int
close(int fdnum)
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
  801ada:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801add:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ae0:	50                   	push   %eax
  801ae1:	ff 75 08             	pushl  0x8(%ebp)
  801ae4:	e8 bc fe ff ff       	call   8019a5 <fd_lookup>
  801ae9:	83 c4 10             	add    $0x10,%esp
  801aec:	85 c0                	test   %eax,%eax
  801aee:	79 02                	jns    801af2 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    
		return fd_close(fd, 1);
  801af2:	83 ec 08             	sub    $0x8,%esp
  801af5:	6a 01                	push   $0x1
  801af7:	ff 75 f4             	pushl  -0xc(%ebp)
  801afa:	e8 51 ff ff ff       	call   801a50 <fd_close>
  801aff:	83 c4 10             	add    $0x10,%esp
  801b02:	eb ec                	jmp    801af0 <close+0x19>

00801b04 <close_all>:

void
close_all(void)
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
  801b07:	53                   	push   %ebx
  801b08:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801b0b:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801b10:	83 ec 0c             	sub    $0xc,%esp
  801b13:	53                   	push   %ebx
  801b14:	e8 be ff ff ff       	call   801ad7 <close>
	for (i = 0; i < MAXFD; i++)
  801b19:	83 c3 01             	add    $0x1,%ebx
  801b1c:	83 c4 10             	add    $0x10,%esp
  801b1f:	83 fb 20             	cmp    $0x20,%ebx
  801b22:	75 ec                	jne    801b10 <close_all+0xc>
}
  801b24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b27:	c9                   	leave  
  801b28:	c3                   	ret    

00801b29 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
  801b2c:	57                   	push   %edi
  801b2d:	56                   	push   %esi
  801b2e:	53                   	push   %ebx
  801b2f:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801b32:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801b35:	50                   	push   %eax
  801b36:	ff 75 08             	pushl  0x8(%ebp)
  801b39:	e8 67 fe ff ff       	call   8019a5 <fd_lookup>
  801b3e:	89 c3                	mov    %eax,%ebx
  801b40:	83 c4 10             	add    $0x10,%esp
  801b43:	85 c0                	test   %eax,%eax
  801b45:	0f 88 81 00 00 00    	js     801bcc <dup+0xa3>
		return r;
	close(newfdnum);
  801b4b:	83 ec 0c             	sub    $0xc,%esp
  801b4e:	ff 75 0c             	pushl  0xc(%ebp)
  801b51:	e8 81 ff ff ff       	call   801ad7 <close>

	newfd = INDEX2FD(newfdnum);
  801b56:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b59:	c1 e6 0c             	shl    $0xc,%esi
  801b5c:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801b62:	83 c4 04             	add    $0x4,%esp
  801b65:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b68:	e8 cf fd ff ff       	call   80193c <fd2data>
  801b6d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801b6f:	89 34 24             	mov    %esi,(%esp)
  801b72:	e8 c5 fd ff ff       	call   80193c <fd2data>
  801b77:	83 c4 10             	add    $0x10,%esp
  801b7a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801b7c:	89 d8                	mov    %ebx,%eax
  801b7e:	c1 e8 16             	shr    $0x16,%eax
  801b81:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801b88:	a8 01                	test   $0x1,%al
  801b8a:	74 11                	je     801b9d <dup+0x74>
  801b8c:	89 d8                	mov    %ebx,%eax
  801b8e:	c1 e8 0c             	shr    $0xc,%eax
  801b91:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801b98:	f6 c2 01             	test   $0x1,%dl
  801b9b:	75 39                	jne    801bd6 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801b9d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ba0:	89 d0                	mov    %edx,%eax
  801ba2:	c1 e8 0c             	shr    $0xc,%eax
  801ba5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801bac:	83 ec 0c             	sub    $0xc,%esp
  801baf:	25 07 0e 00 00       	and    $0xe07,%eax
  801bb4:	50                   	push   %eax
  801bb5:	56                   	push   %esi
  801bb6:	6a 00                	push   $0x0
  801bb8:	52                   	push   %edx
  801bb9:	6a 00                	push   $0x0
  801bbb:	e8 cd f5 ff ff       	call   80118d <sys_page_map>
  801bc0:	89 c3                	mov    %eax,%ebx
  801bc2:	83 c4 20             	add    $0x20,%esp
  801bc5:	85 c0                	test   %eax,%eax
  801bc7:	78 31                	js     801bfa <dup+0xd1>
		goto err;

	return newfdnum;
  801bc9:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801bcc:	89 d8                	mov    %ebx,%eax
  801bce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bd1:	5b                   	pop    %ebx
  801bd2:	5e                   	pop    %esi
  801bd3:	5f                   	pop    %edi
  801bd4:	5d                   	pop    %ebp
  801bd5:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801bd6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801bdd:	83 ec 0c             	sub    $0xc,%esp
  801be0:	25 07 0e 00 00       	and    $0xe07,%eax
  801be5:	50                   	push   %eax
  801be6:	57                   	push   %edi
  801be7:	6a 00                	push   $0x0
  801be9:	53                   	push   %ebx
  801bea:	6a 00                	push   $0x0
  801bec:	e8 9c f5 ff ff       	call   80118d <sys_page_map>
  801bf1:	89 c3                	mov    %eax,%ebx
  801bf3:	83 c4 20             	add    $0x20,%esp
  801bf6:	85 c0                	test   %eax,%eax
  801bf8:	79 a3                	jns    801b9d <dup+0x74>
	sys_page_unmap(0, newfd);
  801bfa:	83 ec 08             	sub    $0x8,%esp
  801bfd:	56                   	push   %esi
  801bfe:	6a 00                	push   $0x0
  801c00:	e8 ca f5 ff ff       	call   8011cf <sys_page_unmap>
	sys_page_unmap(0, nva);
  801c05:	83 c4 08             	add    $0x8,%esp
  801c08:	57                   	push   %edi
  801c09:	6a 00                	push   $0x0
  801c0b:	e8 bf f5 ff ff       	call   8011cf <sys_page_unmap>
	return r;
  801c10:	83 c4 10             	add    $0x10,%esp
  801c13:	eb b7                	jmp    801bcc <dup+0xa3>

00801c15 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
  801c18:	53                   	push   %ebx
  801c19:	83 ec 1c             	sub    $0x1c,%esp
  801c1c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c1f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c22:	50                   	push   %eax
  801c23:	53                   	push   %ebx
  801c24:	e8 7c fd ff ff       	call   8019a5 <fd_lookup>
  801c29:	83 c4 10             	add    $0x10,%esp
  801c2c:	85 c0                	test   %eax,%eax
  801c2e:	78 3f                	js     801c6f <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c30:	83 ec 08             	sub    $0x8,%esp
  801c33:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c36:	50                   	push   %eax
  801c37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c3a:	ff 30                	pushl  (%eax)
  801c3c:	e8 b4 fd ff ff       	call   8019f5 <dev_lookup>
  801c41:	83 c4 10             	add    $0x10,%esp
  801c44:	85 c0                	test   %eax,%eax
  801c46:	78 27                	js     801c6f <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801c48:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c4b:	8b 42 08             	mov    0x8(%edx),%eax
  801c4e:	83 e0 03             	and    $0x3,%eax
  801c51:	83 f8 01             	cmp    $0x1,%eax
  801c54:	74 1e                	je     801c74 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c59:	8b 40 08             	mov    0x8(%eax),%eax
  801c5c:	85 c0                	test   %eax,%eax
  801c5e:	74 35                	je     801c95 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801c60:	83 ec 04             	sub    $0x4,%esp
  801c63:	ff 75 10             	pushl  0x10(%ebp)
  801c66:	ff 75 0c             	pushl  0xc(%ebp)
  801c69:	52                   	push   %edx
  801c6a:	ff d0                	call   *%eax
  801c6c:	83 c4 10             	add    $0x10,%esp
}
  801c6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c72:	c9                   	leave  
  801c73:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801c74:	a1 08 50 80 00       	mov    0x805008,%eax
  801c79:	8b 40 48             	mov    0x48(%eax),%eax
  801c7c:	83 ec 04             	sub    $0x4,%esp
  801c7f:	53                   	push   %ebx
  801c80:	50                   	push   %eax
  801c81:	68 05 3a 80 00       	push   $0x803a05
  801c86:	e8 6e e9 ff ff       	call   8005f9 <cprintf>
		return -E_INVAL;
  801c8b:	83 c4 10             	add    $0x10,%esp
  801c8e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c93:	eb da                	jmp    801c6f <read+0x5a>
		return -E_NOT_SUPP;
  801c95:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c9a:	eb d3                	jmp    801c6f <read+0x5a>

00801c9c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
  801c9f:	57                   	push   %edi
  801ca0:	56                   	push   %esi
  801ca1:	53                   	push   %ebx
  801ca2:	83 ec 0c             	sub    $0xc,%esp
  801ca5:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ca8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801cab:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cb0:	39 f3                	cmp    %esi,%ebx
  801cb2:	73 23                	jae    801cd7 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801cb4:	83 ec 04             	sub    $0x4,%esp
  801cb7:	89 f0                	mov    %esi,%eax
  801cb9:	29 d8                	sub    %ebx,%eax
  801cbb:	50                   	push   %eax
  801cbc:	89 d8                	mov    %ebx,%eax
  801cbe:	03 45 0c             	add    0xc(%ebp),%eax
  801cc1:	50                   	push   %eax
  801cc2:	57                   	push   %edi
  801cc3:	e8 4d ff ff ff       	call   801c15 <read>
		if (m < 0)
  801cc8:	83 c4 10             	add    $0x10,%esp
  801ccb:	85 c0                	test   %eax,%eax
  801ccd:	78 06                	js     801cd5 <readn+0x39>
			return m;
		if (m == 0)
  801ccf:	74 06                	je     801cd7 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801cd1:	01 c3                	add    %eax,%ebx
  801cd3:	eb db                	jmp    801cb0 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801cd5:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801cd7:	89 d8                	mov    %ebx,%eax
  801cd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cdc:	5b                   	pop    %ebx
  801cdd:	5e                   	pop    %esi
  801cde:	5f                   	pop    %edi
  801cdf:	5d                   	pop    %ebp
  801ce0:	c3                   	ret    

00801ce1 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
  801ce4:	53                   	push   %ebx
  801ce5:	83 ec 1c             	sub    $0x1c,%esp
  801ce8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ceb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cee:	50                   	push   %eax
  801cef:	53                   	push   %ebx
  801cf0:	e8 b0 fc ff ff       	call   8019a5 <fd_lookup>
  801cf5:	83 c4 10             	add    $0x10,%esp
  801cf8:	85 c0                	test   %eax,%eax
  801cfa:	78 3a                	js     801d36 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801cfc:	83 ec 08             	sub    $0x8,%esp
  801cff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d02:	50                   	push   %eax
  801d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d06:	ff 30                	pushl  (%eax)
  801d08:	e8 e8 fc ff ff       	call   8019f5 <dev_lookup>
  801d0d:	83 c4 10             	add    $0x10,%esp
  801d10:	85 c0                	test   %eax,%eax
  801d12:	78 22                	js     801d36 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d17:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801d1b:	74 1e                	je     801d3b <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801d1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d20:	8b 52 0c             	mov    0xc(%edx),%edx
  801d23:	85 d2                	test   %edx,%edx
  801d25:	74 35                	je     801d5c <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801d27:	83 ec 04             	sub    $0x4,%esp
  801d2a:	ff 75 10             	pushl  0x10(%ebp)
  801d2d:	ff 75 0c             	pushl  0xc(%ebp)
  801d30:	50                   	push   %eax
  801d31:	ff d2                	call   *%edx
  801d33:	83 c4 10             	add    $0x10,%esp
}
  801d36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801d3b:	a1 08 50 80 00       	mov    0x805008,%eax
  801d40:	8b 40 48             	mov    0x48(%eax),%eax
  801d43:	83 ec 04             	sub    $0x4,%esp
  801d46:	53                   	push   %ebx
  801d47:	50                   	push   %eax
  801d48:	68 21 3a 80 00       	push   $0x803a21
  801d4d:	e8 a7 e8 ff ff       	call   8005f9 <cprintf>
		return -E_INVAL;
  801d52:	83 c4 10             	add    $0x10,%esp
  801d55:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d5a:	eb da                	jmp    801d36 <write+0x55>
		return -E_NOT_SUPP;
  801d5c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d61:	eb d3                	jmp    801d36 <write+0x55>

00801d63 <seek>:

int
seek(int fdnum, off_t offset)
{
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
  801d66:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d69:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d6c:	50                   	push   %eax
  801d6d:	ff 75 08             	pushl  0x8(%ebp)
  801d70:	e8 30 fc ff ff       	call   8019a5 <fd_lookup>
  801d75:	83 c4 10             	add    $0x10,%esp
  801d78:	85 c0                	test   %eax,%eax
  801d7a:	78 0e                	js     801d8a <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801d7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d82:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801d85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d8a:	c9                   	leave  
  801d8b:	c3                   	ret    

00801d8c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
  801d8f:	53                   	push   %ebx
  801d90:	83 ec 1c             	sub    $0x1c,%esp
  801d93:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d96:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d99:	50                   	push   %eax
  801d9a:	53                   	push   %ebx
  801d9b:	e8 05 fc ff ff       	call   8019a5 <fd_lookup>
  801da0:	83 c4 10             	add    $0x10,%esp
  801da3:	85 c0                	test   %eax,%eax
  801da5:	78 37                	js     801dde <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801da7:	83 ec 08             	sub    $0x8,%esp
  801daa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dad:	50                   	push   %eax
  801dae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db1:	ff 30                	pushl  (%eax)
  801db3:	e8 3d fc ff ff       	call   8019f5 <dev_lookup>
  801db8:	83 c4 10             	add    $0x10,%esp
  801dbb:	85 c0                	test   %eax,%eax
  801dbd:	78 1f                	js     801dde <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801dbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dc2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801dc6:	74 1b                	je     801de3 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801dc8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dcb:	8b 52 18             	mov    0x18(%edx),%edx
  801dce:	85 d2                	test   %edx,%edx
  801dd0:	74 32                	je     801e04 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801dd2:	83 ec 08             	sub    $0x8,%esp
  801dd5:	ff 75 0c             	pushl  0xc(%ebp)
  801dd8:	50                   	push   %eax
  801dd9:	ff d2                	call   *%edx
  801ddb:	83 c4 10             	add    $0x10,%esp
}
  801dde:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801de1:	c9                   	leave  
  801de2:	c3                   	ret    
			thisenv->env_id, fdnum);
  801de3:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801de8:	8b 40 48             	mov    0x48(%eax),%eax
  801deb:	83 ec 04             	sub    $0x4,%esp
  801dee:	53                   	push   %ebx
  801def:	50                   	push   %eax
  801df0:	68 e4 39 80 00       	push   $0x8039e4
  801df5:	e8 ff e7 ff ff       	call   8005f9 <cprintf>
		return -E_INVAL;
  801dfa:	83 c4 10             	add    $0x10,%esp
  801dfd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e02:	eb da                	jmp    801dde <ftruncate+0x52>
		return -E_NOT_SUPP;
  801e04:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e09:	eb d3                	jmp    801dde <ftruncate+0x52>

00801e0b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801e0b:	55                   	push   %ebp
  801e0c:	89 e5                	mov    %esp,%ebp
  801e0e:	53                   	push   %ebx
  801e0f:	83 ec 1c             	sub    $0x1c,%esp
  801e12:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801e15:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e18:	50                   	push   %eax
  801e19:	ff 75 08             	pushl  0x8(%ebp)
  801e1c:	e8 84 fb ff ff       	call   8019a5 <fd_lookup>
  801e21:	83 c4 10             	add    $0x10,%esp
  801e24:	85 c0                	test   %eax,%eax
  801e26:	78 4b                	js     801e73 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801e28:	83 ec 08             	sub    $0x8,%esp
  801e2b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e2e:	50                   	push   %eax
  801e2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e32:	ff 30                	pushl  (%eax)
  801e34:	e8 bc fb ff ff       	call   8019f5 <dev_lookup>
  801e39:	83 c4 10             	add    $0x10,%esp
  801e3c:	85 c0                	test   %eax,%eax
  801e3e:	78 33                	js     801e73 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e43:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801e47:	74 2f                	je     801e78 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801e49:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801e4c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801e53:	00 00 00 
	stat->st_isdir = 0;
  801e56:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e5d:	00 00 00 
	stat->st_dev = dev;
  801e60:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801e66:	83 ec 08             	sub    $0x8,%esp
  801e69:	53                   	push   %ebx
  801e6a:	ff 75 f0             	pushl  -0x10(%ebp)
  801e6d:	ff 50 14             	call   *0x14(%eax)
  801e70:	83 c4 10             	add    $0x10,%esp
}
  801e73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e76:	c9                   	leave  
  801e77:	c3                   	ret    
		return -E_NOT_SUPP;
  801e78:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e7d:	eb f4                	jmp    801e73 <fstat+0x68>

00801e7f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
  801e82:	56                   	push   %esi
  801e83:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801e84:	83 ec 08             	sub    $0x8,%esp
  801e87:	6a 00                	push   $0x0
  801e89:	ff 75 08             	pushl  0x8(%ebp)
  801e8c:	e8 22 02 00 00       	call   8020b3 <open>
  801e91:	89 c3                	mov    %eax,%ebx
  801e93:	83 c4 10             	add    $0x10,%esp
  801e96:	85 c0                	test   %eax,%eax
  801e98:	78 1b                	js     801eb5 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801e9a:	83 ec 08             	sub    $0x8,%esp
  801e9d:	ff 75 0c             	pushl  0xc(%ebp)
  801ea0:	50                   	push   %eax
  801ea1:	e8 65 ff ff ff       	call   801e0b <fstat>
  801ea6:	89 c6                	mov    %eax,%esi
	close(fd);
  801ea8:	89 1c 24             	mov    %ebx,(%esp)
  801eab:	e8 27 fc ff ff       	call   801ad7 <close>
	return r;
  801eb0:	83 c4 10             	add    $0x10,%esp
  801eb3:	89 f3                	mov    %esi,%ebx
}
  801eb5:	89 d8                	mov    %ebx,%eax
  801eb7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801eba:	5b                   	pop    %ebx
  801ebb:	5e                   	pop    %esi
  801ebc:	5d                   	pop    %ebp
  801ebd:	c3                   	ret    

00801ebe <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
  801ec1:	56                   	push   %esi
  801ec2:	53                   	push   %ebx
  801ec3:	89 c6                	mov    %eax,%esi
  801ec5:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801ec7:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801ece:	74 27                	je     801ef7 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ed0:	6a 07                	push   $0x7
  801ed2:	68 00 60 80 00       	push   $0x806000
  801ed7:	56                   	push   %esi
  801ed8:	ff 35 00 50 80 00    	pushl  0x805000
  801ede:	e8 97 11 00 00       	call   80307a <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801ee3:	83 c4 0c             	add    $0xc,%esp
  801ee6:	6a 00                	push   $0x0
  801ee8:	53                   	push   %ebx
  801ee9:	6a 00                	push   $0x0
  801eeb:	e8 21 11 00 00       	call   803011 <ipc_recv>
}
  801ef0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ef3:	5b                   	pop    %ebx
  801ef4:	5e                   	pop    %esi
  801ef5:	5d                   	pop    %ebp
  801ef6:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801ef7:	83 ec 0c             	sub    $0xc,%esp
  801efa:	6a 01                	push   $0x1
  801efc:	e8 d1 11 00 00       	call   8030d2 <ipc_find_env>
  801f01:	a3 00 50 80 00       	mov    %eax,0x805000
  801f06:	83 c4 10             	add    $0x10,%esp
  801f09:	eb c5                	jmp    801ed0 <fsipc+0x12>

00801f0b <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801f0b:	55                   	push   %ebp
  801f0c:	89 e5                	mov    %esp,%ebp
  801f0e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801f11:	8b 45 08             	mov    0x8(%ebp),%eax
  801f14:	8b 40 0c             	mov    0xc(%eax),%eax
  801f17:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801f1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f1f:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801f24:	ba 00 00 00 00       	mov    $0x0,%edx
  801f29:	b8 02 00 00 00       	mov    $0x2,%eax
  801f2e:	e8 8b ff ff ff       	call   801ebe <fsipc>
}
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <devfile_flush>:
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
  801f38:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f41:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801f46:	ba 00 00 00 00       	mov    $0x0,%edx
  801f4b:	b8 06 00 00 00       	mov    $0x6,%eax
  801f50:	e8 69 ff ff ff       	call   801ebe <fsipc>
}
  801f55:	c9                   	leave  
  801f56:	c3                   	ret    

00801f57 <devfile_stat>:
{
  801f57:	55                   	push   %ebp
  801f58:	89 e5                	mov    %esp,%ebp
  801f5a:	53                   	push   %ebx
  801f5b:	83 ec 04             	sub    $0x4,%esp
  801f5e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801f61:	8b 45 08             	mov    0x8(%ebp),%eax
  801f64:	8b 40 0c             	mov    0xc(%eax),%eax
  801f67:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801f6c:	ba 00 00 00 00       	mov    $0x0,%edx
  801f71:	b8 05 00 00 00       	mov    $0x5,%eax
  801f76:	e8 43 ff ff ff       	call   801ebe <fsipc>
  801f7b:	85 c0                	test   %eax,%eax
  801f7d:	78 2c                	js     801fab <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801f7f:	83 ec 08             	sub    $0x8,%esp
  801f82:	68 00 60 80 00       	push   $0x806000
  801f87:	53                   	push   %ebx
  801f88:	e8 cb ed ff ff       	call   800d58 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801f8d:	a1 80 60 80 00       	mov    0x806080,%eax
  801f92:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801f98:	a1 84 60 80 00       	mov    0x806084,%eax
  801f9d:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801fa3:	83 c4 10             	add    $0x10,%esp
  801fa6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fae:	c9                   	leave  
  801faf:	c3                   	ret    

00801fb0 <devfile_write>:
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
  801fb3:	53                   	push   %ebx
  801fb4:	83 ec 08             	sub    $0x8,%esp
  801fb7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801fba:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbd:	8b 40 0c             	mov    0xc(%eax),%eax
  801fc0:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801fc5:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801fcb:	53                   	push   %ebx
  801fcc:	ff 75 0c             	pushl  0xc(%ebp)
  801fcf:	68 08 60 80 00       	push   $0x806008
  801fd4:	e8 6f ef ff ff       	call   800f48 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801fd9:	ba 00 00 00 00       	mov    $0x0,%edx
  801fde:	b8 04 00 00 00       	mov    $0x4,%eax
  801fe3:	e8 d6 fe ff ff       	call   801ebe <fsipc>
  801fe8:	83 c4 10             	add    $0x10,%esp
  801feb:	85 c0                	test   %eax,%eax
  801fed:	78 0b                	js     801ffa <devfile_write+0x4a>
	assert(r <= n);
  801fef:	39 d8                	cmp    %ebx,%eax
  801ff1:	77 0c                	ja     801fff <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801ff3:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ff8:	7f 1e                	jg     802018 <devfile_write+0x68>
}
  801ffa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ffd:	c9                   	leave  
  801ffe:	c3                   	ret    
	assert(r <= n);
  801fff:	68 54 3a 80 00       	push   $0x803a54
  802004:	68 5b 3a 80 00       	push   $0x803a5b
  802009:	68 98 00 00 00       	push   $0x98
  80200e:	68 70 3a 80 00       	push   $0x803a70
  802013:	e8 eb e4 ff ff       	call   800503 <_panic>
	assert(r <= PGSIZE);
  802018:	68 7b 3a 80 00       	push   $0x803a7b
  80201d:	68 5b 3a 80 00       	push   $0x803a5b
  802022:	68 99 00 00 00       	push   $0x99
  802027:	68 70 3a 80 00       	push   $0x803a70
  80202c:	e8 d2 e4 ff ff       	call   800503 <_panic>

00802031 <devfile_read>:
{
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
  802034:	56                   	push   %esi
  802035:	53                   	push   %ebx
  802036:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802039:	8b 45 08             	mov    0x8(%ebp),%eax
  80203c:	8b 40 0c             	mov    0xc(%eax),%eax
  80203f:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  802044:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80204a:	ba 00 00 00 00       	mov    $0x0,%edx
  80204f:	b8 03 00 00 00       	mov    $0x3,%eax
  802054:	e8 65 fe ff ff       	call   801ebe <fsipc>
  802059:	89 c3                	mov    %eax,%ebx
  80205b:	85 c0                	test   %eax,%eax
  80205d:	78 1f                	js     80207e <devfile_read+0x4d>
	assert(r <= n);
  80205f:	39 f0                	cmp    %esi,%eax
  802061:	77 24                	ja     802087 <devfile_read+0x56>
	assert(r <= PGSIZE);
  802063:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802068:	7f 33                	jg     80209d <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80206a:	83 ec 04             	sub    $0x4,%esp
  80206d:	50                   	push   %eax
  80206e:	68 00 60 80 00       	push   $0x806000
  802073:	ff 75 0c             	pushl  0xc(%ebp)
  802076:	e8 6b ee ff ff       	call   800ee6 <memmove>
	return r;
  80207b:	83 c4 10             	add    $0x10,%esp
}
  80207e:	89 d8                	mov    %ebx,%eax
  802080:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802083:	5b                   	pop    %ebx
  802084:	5e                   	pop    %esi
  802085:	5d                   	pop    %ebp
  802086:	c3                   	ret    
	assert(r <= n);
  802087:	68 54 3a 80 00       	push   $0x803a54
  80208c:	68 5b 3a 80 00       	push   $0x803a5b
  802091:	6a 7c                	push   $0x7c
  802093:	68 70 3a 80 00       	push   $0x803a70
  802098:	e8 66 e4 ff ff       	call   800503 <_panic>
	assert(r <= PGSIZE);
  80209d:	68 7b 3a 80 00       	push   $0x803a7b
  8020a2:	68 5b 3a 80 00       	push   $0x803a5b
  8020a7:	6a 7d                	push   $0x7d
  8020a9:	68 70 3a 80 00       	push   $0x803a70
  8020ae:	e8 50 e4 ff ff       	call   800503 <_panic>

008020b3 <open>:
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
  8020b6:	56                   	push   %esi
  8020b7:	53                   	push   %ebx
  8020b8:	83 ec 1c             	sub    $0x1c,%esp
  8020bb:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8020be:	56                   	push   %esi
  8020bf:	e8 5b ec ff ff       	call   800d1f <strlen>
  8020c4:	83 c4 10             	add    $0x10,%esp
  8020c7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8020cc:	7f 6c                	jg     80213a <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8020ce:	83 ec 0c             	sub    $0xc,%esp
  8020d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020d4:	50                   	push   %eax
  8020d5:	e8 79 f8 ff ff       	call   801953 <fd_alloc>
  8020da:	89 c3                	mov    %eax,%ebx
  8020dc:	83 c4 10             	add    $0x10,%esp
  8020df:	85 c0                	test   %eax,%eax
  8020e1:	78 3c                	js     80211f <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8020e3:	83 ec 08             	sub    $0x8,%esp
  8020e6:	56                   	push   %esi
  8020e7:	68 00 60 80 00       	push   $0x806000
  8020ec:	e8 67 ec ff ff       	call   800d58 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8020f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020f4:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8020f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020fc:	b8 01 00 00 00       	mov    $0x1,%eax
  802101:	e8 b8 fd ff ff       	call   801ebe <fsipc>
  802106:	89 c3                	mov    %eax,%ebx
  802108:	83 c4 10             	add    $0x10,%esp
  80210b:	85 c0                	test   %eax,%eax
  80210d:	78 19                	js     802128 <open+0x75>
	return fd2num(fd);
  80210f:	83 ec 0c             	sub    $0xc,%esp
  802112:	ff 75 f4             	pushl  -0xc(%ebp)
  802115:	e8 12 f8 ff ff       	call   80192c <fd2num>
  80211a:	89 c3                	mov    %eax,%ebx
  80211c:	83 c4 10             	add    $0x10,%esp
}
  80211f:	89 d8                	mov    %ebx,%eax
  802121:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802124:	5b                   	pop    %ebx
  802125:	5e                   	pop    %esi
  802126:	5d                   	pop    %ebp
  802127:	c3                   	ret    
		fd_close(fd, 0);
  802128:	83 ec 08             	sub    $0x8,%esp
  80212b:	6a 00                	push   $0x0
  80212d:	ff 75 f4             	pushl  -0xc(%ebp)
  802130:	e8 1b f9 ff ff       	call   801a50 <fd_close>
		return r;
  802135:	83 c4 10             	add    $0x10,%esp
  802138:	eb e5                	jmp    80211f <open+0x6c>
		return -E_BAD_PATH;
  80213a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80213f:	eb de                	jmp    80211f <open+0x6c>

00802141 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802141:	55                   	push   %ebp
  802142:	89 e5                	mov    %esp,%ebp
  802144:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802147:	ba 00 00 00 00       	mov    $0x0,%edx
  80214c:	b8 08 00 00 00       	mov    $0x8,%eax
  802151:	e8 68 fd ff ff       	call   801ebe <fsipc>
}
  802156:	c9                   	leave  
  802157:	c3                   	ret    

00802158 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802158:	55                   	push   %ebp
  802159:	89 e5                	mov    %esp,%ebp
  80215b:	57                   	push   %edi
  80215c:	56                   	push   %esi
  80215d:	53                   	push   %ebx
  80215e:	81 ec 94 02 00 00    	sub    $0x294,%esp
	cprintf("in %s\n", __FUNCTION__);
  802164:	68 60 3b 80 00       	push   $0x803b60
  802169:	68 f0 34 80 00       	push   $0x8034f0
  80216e:	e8 86 e4 ff ff       	call   8005f9 <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802173:	83 c4 08             	add    $0x8,%esp
  802176:	6a 00                	push   $0x0
  802178:	ff 75 08             	pushl  0x8(%ebp)
  80217b:	e8 33 ff ff ff       	call   8020b3 <open>
  802180:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802186:	83 c4 10             	add    $0x10,%esp
  802189:	85 c0                	test   %eax,%eax
  80218b:	0f 88 0b 05 00 00    	js     80269c <spawn+0x544>
  802191:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802193:	83 ec 04             	sub    $0x4,%esp
  802196:	68 00 02 00 00       	push   $0x200
  80219b:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8021a1:	50                   	push   %eax
  8021a2:	51                   	push   %ecx
  8021a3:	e8 f4 fa ff ff       	call   801c9c <readn>
  8021a8:	83 c4 10             	add    $0x10,%esp
  8021ab:	3d 00 02 00 00       	cmp    $0x200,%eax
  8021b0:	75 75                	jne    802227 <spawn+0xcf>
	    || elf->e_magic != ELF_MAGIC) {
  8021b2:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8021b9:	45 4c 46 
  8021bc:	75 69                	jne    802227 <spawn+0xcf>
  8021be:	b8 07 00 00 00       	mov    $0x7,%eax
  8021c3:	cd 30                	int    $0x30
  8021c5:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  8021cb:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8021d1:	85 c0                	test   %eax,%eax
  8021d3:	0f 88 b7 04 00 00    	js     802690 <spawn+0x538>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8021d9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8021de:	69 f0 84 00 00 00    	imul   $0x84,%eax,%esi
  8021e4:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  8021ea:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8021f0:	b9 11 00 00 00       	mov    $0x11,%ecx
  8021f5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8021f7:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8021fd:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
	cprintf("in %s\n", __FUNCTION__);
  802203:	83 ec 08             	sub    $0x8,%esp
  802206:	68 54 3b 80 00       	push   $0x803b54
  80220b:	68 f0 34 80 00       	push   $0x8034f0
  802210:	e8 e4 e3 ff ff       	call   8005f9 <cprintf>
  802215:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802218:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  80221d:	be 00 00 00 00       	mov    $0x0,%esi
  802222:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802225:	eb 4b                	jmp    802272 <spawn+0x11a>
		close(fd);
  802227:	83 ec 0c             	sub    $0xc,%esp
  80222a:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802230:	e8 a2 f8 ff ff       	call   801ad7 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802235:	83 c4 0c             	add    $0xc,%esp
  802238:	68 7f 45 4c 46       	push   $0x464c457f
  80223d:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  802243:	68 87 3a 80 00       	push   $0x803a87
  802248:	e8 ac e3 ff ff       	call   8005f9 <cprintf>
		return -E_NOT_EXEC;
  80224d:	83 c4 10             	add    $0x10,%esp
  802250:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  802257:	ff ff ff 
  80225a:	e9 3d 04 00 00       	jmp    80269c <spawn+0x544>
		string_size += strlen(argv[argc]) + 1;
  80225f:	83 ec 0c             	sub    $0xc,%esp
  802262:	50                   	push   %eax
  802263:	e8 b7 ea ff ff       	call   800d1f <strlen>
  802268:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  80226c:	83 c3 01             	add    $0x1,%ebx
  80226f:	83 c4 10             	add    $0x10,%esp
  802272:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  802279:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  80227c:	85 c0                	test   %eax,%eax
  80227e:	75 df                	jne    80225f <spawn+0x107>
  802280:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  802286:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  80228c:	bf 00 10 40 00       	mov    $0x401000,%edi
  802291:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802293:	89 fa                	mov    %edi,%edx
  802295:	83 e2 fc             	and    $0xfffffffc,%edx
  802298:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  80229f:	29 c2                	sub    %eax,%edx
  8022a1:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8022a7:	8d 42 f8             	lea    -0x8(%edx),%eax
  8022aa:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8022af:	0f 86 0a 04 00 00    	jbe    8026bf <spawn+0x567>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8022b5:	83 ec 04             	sub    $0x4,%esp
  8022b8:	6a 07                	push   $0x7
  8022ba:	68 00 00 40 00       	push   $0x400000
  8022bf:	6a 00                	push   $0x0
  8022c1:	e8 84 ee ff ff       	call   80114a <sys_page_alloc>
  8022c6:	83 c4 10             	add    $0x10,%esp
  8022c9:	85 c0                	test   %eax,%eax
  8022cb:	0f 88 f3 03 00 00    	js     8026c4 <spawn+0x56c>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8022d1:	be 00 00 00 00       	mov    $0x0,%esi
  8022d6:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  8022dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8022df:	eb 30                	jmp    802311 <spawn+0x1b9>
		argv_store[i] = UTEMP2USTACK(string_store);
  8022e1:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  8022e7:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  8022ed:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  8022f0:	83 ec 08             	sub    $0x8,%esp
  8022f3:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8022f6:	57                   	push   %edi
  8022f7:	e8 5c ea ff ff       	call   800d58 <strcpy>
		string_store += strlen(argv[i]) + 1;
  8022fc:	83 c4 04             	add    $0x4,%esp
  8022ff:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802302:	e8 18 ea ff ff       	call   800d1f <strlen>
  802307:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  80230b:	83 c6 01             	add    $0x1,%esi
  80230e:	83 c4 10             	add    $0x10,%esp
  802311:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  802317:	7f c8                	jg     8022e1 <spawn+0x189>
	}
	argv_store[argc] = 0;
  802319:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80231f:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  802325:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  80232c:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  802332:	0f 85 86 00 00 00    	jne    8023be <spawn+0x266>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802338:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  80233e:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  802344:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  802347:	89 d0                	mov    %edx,%eax
  802349:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  80234f:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802352:	2d 08 30 80 11       	sub    $0x11803008,%eax
  802357:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80235d:	83 ec 0c             	sub    $0xc,%esp
  802360:	6a 07                	push   $0x7
  802362:	68 00 d0 bf ee       	push   $0xeebfd000
  802367:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80236d:	68 00 00 40 00       	push   $0x400000
  802372:	6a 00                	push   $0x0
  802374:	e8 14 ee ff ff       	call   80118d <sys_page_map>
  802379:	89 c3                	mov    %eax,%ebx
  80237b:	83 c4 20             	add    $0x20,%esp
  80237e:	85 c0                	test   %eax,%eax
  802380:	0f 88 46 03 00 00    	js     8026cc <spawn+0x574>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802386:	83 ec 08             	sub    $0x8,%esp
  802389:	68 00 00 40 00       	push   $0x400000
  80238e:	6a 00                	push   $0x0
  802390:	e8 3a ee ff ff       	call   8011cf <sys_page_unmap>
  802395:	89 c3                	mov    %eax,%ebx
  802397:	83 c4 10             	add    $0x10,%esp
  80239a:	85 c0                	test   %eax,%eax
  80239c:	0f 88 2a 03 00 00    	js     8026cc <spawn+0x574>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8023a2:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  8023a8:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8023af:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  8023b6:	00 00 00 
  8023b9:	e9 4f 01 00 00       	jmp    80250d <spawn+0x3b5>
	assert(string_store == (char*)UTEMP + PGSIZE);
  8023be:	68 10 3b 80 00       	push   $0x803b10
  8023c3:	68 5b 3a 80 00       	push   $0x803a5b
  8023c8:	68 f8 00 00 00       	push   $0xf8
  8023cd:	68 a1 3a 80 00       	push   $0x803aa1
  8023d2:	e8 2c e1 ff ff       	call   800503 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8023d7:	83 ec 04             	sub    $0x4,%esp
  8023da:	6a 07                	push   $0x7
  8023dc:	68 00 00 40 00       	push   $0x400000
  8023e1:	6a 00                	push   $0x0
  8023e3:	e8 62 ed ff ff       	call   80114a <sys_page_alloc>
  8023e8:	83 c4 10             	add    $0x10,%esp
  8023eb:	85 c0                	test   %eax,%eax
  8023ed:	0f 88 b7 02 00 00    	js     8026aa <spawn+0x552>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8023f3:	83 ec 08             	sub    $0x8,%esp
  8023f6:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8023fc:	01 f0                	add    %esi,%eax
  8023fe:	50                   	push   %eax
  8023ff:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802405:	e8 59 f9 ff ff       	call   801d63 <seek>
  80240a:	83 c4 10             	add    $0x10,%esp
  80240d:	85 c0                	test   %eax,%eax
  80240f:	0f 88 9c 02 00 00    	js     8026b1 <spawn+0x559>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802415:	83 ec 04             	sub    $0x4,%esp
  802418:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80241e:	29 f0                	sub    %esi,%eax
  802420:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802425:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80242a:	0f 47 c1             	cmova  %ecx,%eax
  80242d:	50                   	push   %eax
  80242e:	68 00 00 40 00       	push   $0x400000
  802433:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802439:	e8 5e f8 ff ff       	call   801c9c <readn>
  80243e:	83 c4 10             	add    $0x10,%esp
  802441:	85 c0                	test   %eax,%eax
  802443:	0f 88 6f 02 00 00    	js     8026b8 <spawn+0x560>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802449:	83 ec 0c             	sub    $0xc,%esp
  80244c:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802452:	53                   	push   %ebx
  802453:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802459:	68 00 00 40 00       	push   $0x400000
  80245e:	6a 00                	push   $0x0
  802460:	e8 28 ed ff ff       	call   80118d <sys_page_map>
  802465:	83 c4 20             	add    $0x20,%esp
  802468:	85 c0                	test   %eax,%eax
  80246a:	78 7c                	js     8024e8 <spawn+0x390>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  80246c:	83 ec 08             	sub    $0x8,%esp
  80246f:	68 00 00 40 00       	push   $0x400000
  802474:	6a 00                	push   $0x0
  802476:	e8 54 ed ff ff       	call   8011cf <sys_page_unmap>
  80247b:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  80247e:	81 c7 00 10 00 00    	add    $0x1000,%edi
  802484:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80248a:	89 fe                	mov    %edi,%esi
  80248c:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  802492:	76 69                	jbe    8024fd <spawn+0x3a5>
		if (i >= filesz) {
  802494:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  80249a:	0f 87 37 ff ff ff    	ja     8023d7 <spawn+0x27f>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8024a0:	83 ec 04             	sub    $0x4,%esp
  8024a3:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8024a9:	53                   	push   %ebx
  8024aa:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  8024b0:	e8 95 ec ff ff       	call   80114a <sys_page_alloc>
  8024b5:	83 c4 10             	add    $0x10,%esp
  8024b8:	85 c0                	test   %eax,%eax
  8024ba:	79 c2                	jns    80247e <spawn+0x326>
  8024bc:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  8024be:	83 ec 0c             	sub    $0xc,%esp
  8024c1:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8024c7:	e8 ff eb ff ff       	call   8010cb <sys_env_destroy>
	close(fd);
  8024cc:	83 c4 04             	add    $0x4,%esp
  8024cf:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8024d5:	e8 fd f5 ff ff       	call   801ad7 <close>
	return r;
  8024da:	83 c4 10             	add    $0x10,%esp
  8024dd:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  8024e3:	e9 b4 01 00 00       	jmp    80269c <spawn+0x544>
				panic("spawn: sys_page_map data: %e", r);
  8024e8:	50                   	push   %eax
  8024e9:	68 ad 3a 80 00       	push   $0x803aad
  8024ee:	68 2b 01 00 00       	push   $0x12b
  8024f3:	68 a1 3a 80 00       	push   $0x803aa1
  8024f8:	e8 06 e0 ff ff       	call   800503 <_panic>
  8024fd:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802503:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  80250a:	83 c6 20             	add    $0x20,%esi
  80250d:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802514:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  80251a:	7e 6d                	jle    802589 <spawn+0x431>
		if (ph->p_type != ELF_PROG_LOAD)
  80251c:	83 3e 01             	cmpl   $0x1,(%esi)
  80251f:	75 e2                	jne    802503 <spawn+0x3ab>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802521:	8b 46 18             	mov    0x18(%esi),%eax
  802524:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  802527:	83 f8 01             	cmp    $0x1,%eax
  80252a:	19 c0                	sbb    %eax,%eax
  80252c:	83 e0 fe             	and    $0xfffffffe,%eax
  80252f:	83 c0 07             	add    $0x7,%eax
  802532:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802538:	8b 4e 04             	mov    0x4(%esi),%ecx
  80253b:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  802541:	8b 56 10             	mov    0x10(%esi),%edx
  802544:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  80254a:	8b 7e 14             	mov    0x14(%esi),%edi
  80254d:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  802553:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  802556:	89 d8                	mov    %ebx,%eax
  802558:	25 ff 0f 00 00       	and    $0xfff,%eax
  80255d:	74 1a                	je     802579 <spawn+0x421>
		va -= i;
  80255f:	29 c3                	sub    %eax,%ebx
		memsz += i;
  802561:	01 c7                	add    %eax,%edi
  802563:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  802569:	01 c2                	add    %eax,%edx
  80256b:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  802571:	29 c1                	sub    %eax,%ecx
  802573:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  802579:	bf 00 00 00 00       	mov    $0x0,%edi
  80257e:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  802584:	e9 01 ff ff ff       	jmp    80248a <spawn+0x332>
	close(fd);
  802589:	83 ec 0c             	sub    $0xc,%esp
  80258c:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802592:	e8 40 f5 ff ff       	call   801ad7 <close>

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	cprintf("in %s\n", __FUNCTION__);
  802597:	83 c4 08             	add    $0x8,%esp
  80259a:	68 40 3b 80 00       	push   $0x803b40
  80259f:	68 f0 34 80 00       	push   $0x8034f0
  8025a4:	e8 50 e0 ff ff       	call   8005f9 <cprintf>
  8025a9:	83 c4 10             	add    $0x10,%esp
	int r;
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  8025ac:	bb 00 00 80 00       	mov    $0x800000,%ebx
  8025b1:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  8025b7:	eb 0e                	jmp    8025c7 <spawn+0x46f>
  8025b9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8025bf:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8025c5:	74 5e                	je     802625 <spawn+0x4cd>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_SHARE)) == (PTE_P | PTE_U | PTE_SHARE)))
  8025c7:	89 d8                	mov    %ebx,%eax
  8025c9:	c1 e8 16             	shr    $0x16,%eax
  8025cc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8025d3:	a8 01                	test   $0x1,%al
  8025d5:	74 e2                	je     8025b9 <spawn+0x461>
  8025d7:	89 da                	mov    %ebx,%edx
  8025d9:	c1 ea 0c             	shr    $0xc,%edx
  8025dc:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8025e3:	25 05 04 00 00       	and    $0x405,%eax
  8025e8:	3d 05 04 00 00       	cmp    $0x405,%eax
  8025ed:	75 ca                	jne    8025b9 <spawn+0x461>
			if((r = sys_page_map((envid_t)0, (void *)i, child, (void *)i, uvpt[PGNUM(i)] & PTE_SYSCALL)) < 0)
  8025ef:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8025f6:	83 ec 0c             	sub    $0xc,%esp
  8025f9:	25 07 0e 00 00       	and    $0xe07,%eax
  8025fe:	50                   	push   %eax
  8025ff:	53                   	push   %ebx
  802600:	56                   	push   %esi
  802601:	53                   	push   %ebx
  802602:	6a 00                	push   $0x0
  802604:	e8 84 eb ff ff       	call   80118d <sys_page_map>
  802609:	83 c4 20             	add    $0x20,%esp
  80260c:	85 c0                	test   %eax,%eax
  80260e:	79 a9                	jns    8025b9 <spawn+0x461>
        		panic("sys_page_map: %e\n", r);
  802610:	50                   	push   %eax
  802611:	68 ca 3a 80 00       	push   $0x803aca
  802616:	68 3b 01 00 00       	push   $0x13b
  80261b:	68 a1 3a 80 00       	push   $0x803aa1
  802620:	e8 de de ff ff       	call   800503 <_panic>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802625:	83 ec 08             	sub    $0x8,%esp
  802628:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  80262e:	50                   	push   %eax
  80262f:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802635:	e8 19 ec ff ff       	call   801253 <sys_env_set_trapframe>
  80263a:	83 c4 10             	add    $0x10,%esp
  80263d:	85 c0                	test   %eax,%eax
  80263f:	78 25                	js     802666 <spawn+0x50e>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802641:	83 ec 08             	sub    $0x8,%esp
  802644:	6a 02                	push   $0x2
  802646:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80264c:	e8 c0 eb ff ff       	call   801211 <sys_env_set_status>
  802651:	83 c4 10             	add    $0x10,%esp
  802654:	85 c0                	test   %eax,%eax
  802656:	78 23                	js     80267b <spawn+0x523>
	return child;
  802658:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80265e:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802664:	eb 36                	jmp    80269c <spawn+0x544>
		panic("sys_env_set_trapframe: %e", r);
  802666:	50                   	push   %eax
  802667:	68 dc 3a 80 00       	push   $0x803adc
  80266c:	68 8a 00 00 00       	push   $0x8a
  802671:	68 a1 3a 80 00       	push   $0x803aa1
  802676:	e8 88 de ff ff       	call   800503 <_panic>
		panic("sys_env_set_status: %e", r);
  80267b:	50                   	push   %eax
  80267c:	68 f6 3a 80 00       	push   $0x803af6
  802681:	68 8d 00 00 00       	push   $0x8d
  802686:	68 a1 3a 80 00       	push   $0x803aa1
  80268b:	e8 73 de ff ff       	call   800503 <_panic>
		return r;
  802690:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802696:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  80269c:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8026a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026a5:	5b                   	pop    %ebx
  8026a6:	5e                   	pop    %esi
  8026a7:	5f                   	pop    %edi
  8026a8:	5d                   	pop    %ebp
  8026a9:	c3                   	ret    
  8026aa:	89 c7                	mov    %eax,%edi
  8026ac:	e9 0d fe ff ff       	jmp    8024be <spawn+0x366>
  8026b1:	89 c7                	mov    %eax,%edi
  8026b3:	e9 06 fe ff ff       	jmp    8024be <spawn+0x366>
  8026b8:	89 c7                	mov    %eax,%edi
  8026ba:	e9 ff fd ff ff       	jmp    8024be <spawn+0x366>
		return -E_NO_MEM;
  8026bf:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  8026c4:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8026ca:	eb d0                	jmp    80269c <spawn+0x544>
	sys_page_unmap(0, UTEMP);
  8026cc:	83 ec 08             	sub    $0x8,%esp
  8026cf:	68 00 00 40 00       	push   $0x400000
  8026d4:	6a 00                	push   $0x0
  8026d6:	e8 f4 ea ff ff       	call   8011cf <sys_page_unmap>
  8026db:	83 c4 10             	add    $0x10,%esp
  8026de:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  8026e4:	eb b6                	jmp    80269c <spawn+0x544>

008026e6 <spawnl>:
{
  8026e6:	55                   	push   %ebp
  8026e7:	89 e5                	mov    %esp,%ebp
  8026e9:	57                   	push   %edi
  8026ea:	56                   	push   %esi
  8026eb:	53                   	push   %ebx
  8026ec:	83 ec 14             	sub    $0x14,%esp
	cprintf("in %s\n", __FUNCTION__);
  8026ef:	68 38 3b 80 00       	push   $0x803b38
  8026f4:	68 f0 34 80 00       	push   $0x8034f0
  8026f9:	e8 fb de ff ff       	call   8005f9 <cprintf>
	va_start(vl, arg0);
  8026fe:	8d 55 10             	lea    0x10(%ebp),%edx
	while(va_arg(vl, void *) != NULL)
  802701:	83 c4 10             	add    $0x10,%esp
	int argc=0;
  802704:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  802709:	8d 4a 04             	lea    0x4(%edx),%ecx
  80270c:	83 3a 00             	cmpl   $0x0,(%edx)
  80270f:	74 07                	je     802718 <spawnl+0x32>
		argc++;
  802711:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  802714:	89 ca                	mov    %ecx,%edx
  802716:	eb f1                	jmp    802709 <spawnl+0x23>
	const char *argv[argc+2];
  802718:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  80271f:	83 e2 f0             	and    $0xfffffff0,%edx
  802722:	29 d4                	sub    %edx,%esp
  802724:	8d 54 24 03          	lea    0x3(%esp),%edx
  802728:	c1 ea 02             	shr    $0x2,%edx
  80272b:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  802732:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802734:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802737:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  80273e:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  802745:	00 
	va_start(vl, arg0);
  802746:	8d 4d 10             	lea    0x10(%ebp),%ecx
  802749:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  80274b:	b8 00 00 00 00       	mov    $0x0,%eax
  802750:	eb 0b                	jmp    80275d <spawnl+0x77>
		argv[i+1] = va_arg(vl, const char *);
  802752:	83 c0 01             	add    $0x1,%eax
  802755:	8b 39                	mov    (%ecx),%edi
  802757:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  80275a:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  80275d:	39 d0                	cmp    %edx,%eax
  80275f:	75 f1                	jne    802752 <spawnl+0x6c>
	return spawn(prog, argv);
  802761:	83 ec 08             	sub    $0x8,%esp
  802764:	56                   	push   %esi
  802765:	ff 75 08             	pushl  0x8(%ebp)
  802768:	e8 eb f9 ff ff       	call   802158 <spawn>
}
  80276d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802770:	5b                   	pop    %ebx
  802771:	5e                   	pop    %esi
  802772:	5f                   	pop    %edi
  802773:	5d                   	pop    %ebp
  802774:	c3                   	ret    

00802775 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802775:	55                   	push   %ebp
  802776:	89 e5                	mov    %esp,%ebp
  802778:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80277b:	68 66 3b 80 00       	push   $0x803b66
  802780:	ff 75 0c             	pushl  0xc(%ebp)
  802783:	e8 d0 e5 ff ff       	call   800d58 <strcpy>
	return 0;
}
  802788:	b8 00 00 00 00       	mov    $0x0,%eax
  80278d:	c9                   	leave  
  80278e:	c3                   	ret    

0080278f <devsock_close>:
{
  80278f:	55                   	push   %ebp
  802790:	89 e5                	mov    %esp,%ebp
  802792:	53                   	push   %ebx
  802793:	83 ec 10             	sub    $0x10,%esp
  802796:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  802799:	53                   	push   %ebx
  80279a:	e8 72 09 00 00       	call   803111 <pageref>
  80279f:	83 c4 10             	add    $0x10,%esp
		return 0;
  8027a2:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8027a7:	83 f8 01             	cmp    $0x1,%eax
  8027aa:	74 07                	je     8027b3 <devsock_close+0x24>
}
  8027ac:	89 d0                	mov    %edx,%eax
  8027ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027b1:	c9                   	leave  
  8027b2:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8027b3:	83 ec 0c             	sub    $0xc,%esp
  8027b6:	ff 73 0c             	pushl  0xc(%ebx)
  8027b9:	e8 b9 02 00 00       	call   802a77 <nsipc_close>
  8027be:	89 c2                	mov    %eax,%edx
  8027c0:	83 c4 10             	add    $0x10,%esp
  8027c3:	eb e7                	jmp    8027ac <devsock_close+0x1d>

008027c5 <devsock_write>:
{
  8027c5:	55                   	push   %ebp
  8027c6:	89 e5                	mov    %esp,%ebp
  8027c8:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8027cb:	6a 00                	push   $0x0
  8027cd:	ff 75 10             	pushl  0x10(%ebp)
  8027d0:	ff 75 0c             	pushl  0xc(%ebp)
  8027d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d6:	ff 70 0c             	pushl  0xc(%eax)
  8027d9:	e8 76 03 00 00       	call   802b54 <nsipc_send>
}
  8027de:	c9                   	leave  
  8027df:	c3                   	ret    

008027e0 <devsock_read>:
{
  8027e0:	55                   	push   %ebp
  8027e1:	89 e5                	mov    %esp,%ebp
  8027e3:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8027e6:	6a 00                	push   $0x0
  8027e8:	ff 75 10             	pushl  0x10(%ebp)
  8027eb:	ff 75 0c             	pushl  0xc(%ebp)
  8027ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f1:	ff 70 0c             	pushl  0xc(%eax)
  8027f4:	e8 ef 02 00 00       	call   802ae8 <nsipc_recv>
}
  8027f9:	c9                   	leave  
  8027fa:	c3                   	ret    

008027fb <fd2sockid>:
{
  8027fb:	55                   	push   %ebp
  8027fc:	89 e5                	mov    %esp,%ebp
  8027fe:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802801:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802804:	52                   	push   %edx
  802805:	50                   	push   %eax
  802806:	e8 9a f1 ff ff       	call   8019a5 <fd_lookup>
  80280b:	83 c4 10             	add    $0x10,%esp
  80280e:	85 c0                	test   %eax,%eax
  802810:	78 10                	js     802822 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802812:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802815:	8b 0d 3c 40 80 00    	mov    0x80403c,%ecx
  80281b:	39 08                	cmp    %ecx,(%eax)
  80281d:	75 05                	jne    802824 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80281f:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802822:	c9                   	leave  
  802823:	c3                   	ret    
		return -E_NOT_SUPP;
  802824:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802829:	eb f7                	jmp    802822 <fd2sockid+0x27>

0080282b <alloc_sockfd>:
{
  80282b:	55                   	push   %ebp
  80282c:	89 e5                	mov    %esp,%ebp
  80282e:	56                   	push   %esi
  80282f:	53                   	push   %ebx
  802830:	83 ec 1c             	sub    $0x1c,%esp
  802833:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802835:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802838:	50                   	push   %eax
  802839:	e8 15 f1 ff ff       	call   801953 <fd_alloc>
  80283e:	89 c3                	mov    %eax,%ebx
  802840:	83 c4 10             	add    $0x10,%esp
  802843:	85 c0                	test   %eax,%eax
  802845:	78 43                	js     80288a <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802847:	83 ec 04             	sub    $0x4,%esp
  80284a:	68 07 04 00 00       	push   $0x407
  80284f:	ff 75 f4             	pushl  -0xc(%ebp)
  802852:	6a 00                	push   $0x0
  802854:	e8 f1 e8 ff ff       	call   80114a <sys_page_alloc>
  802859:	89 c3                	mov    %eax,%ebx
  80285b:	83 c4 10             	add    $0x10,%esp
  80285e:	85 c0                	test   %eax,%eax
  802860:	78 28                	js     80288a <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802865:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80286b:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80286d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802870:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802877:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80287a:	83 ec 0c             	sub    $0xc,%esp
  80287d:	50                   	push   %eax
  80287e:	e8 a9 f0 ff ff       	call   80192c <fd2num>
  802883:	89 c3                	mov    %eax,%ebx
  802885:	83 c4 10             	add    $0x10,%esp
  802888:	eb 0c                	jmp    802896 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80288a:	83 ec 0c             	sub    $0xc,%esp
  80288d:	56                   	push   %esi
  80288e:	e8 e4 01 00 00       	call   802a77 <nsipc_close>
		return r;
  802893:	83 c4 10             	add    $0x10,%esp
}
  802896:	89 d8                	mov    %ebx,%eax
  802898:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80289b:	5b                   	pop    %ebx
  80289c:	5e                   	pop    %esi
  80289d:	5d                   	pop    %ebp
  80289e:	c3                   	ret    

0080289f <accept>:
{
  80289f:	55                   	push   %ebp
  8028a0:	89 e5                	mov    %esp,%ebp
  8028a2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8028a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a8:	e8 4e ff ff ff       	call   8027fb <fd2sockid>
  8028ad:	85 c0                	test   %eax,%eax
  8028af:	78 1b                	js     8028cc <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8028b1:	83 ec 04             	sub    $0x4,%esp
  8028b4:	ff 75 10             	pushl  0x10(%ebp)
  8028b7:	ff 75 0c             	pushl  0xc(%ebp)
  8028ba:	50                   	push   %eax
  8028bb:	e8 0e 01 00 00       	call   8029ce <nsipc_accept>
  8028c0:	83 c4 10             	add    $0x10,%esp
  8028c3:	85 c0                	test   %eax,%eax
  8028c5:	78 05                	js     8028cc <accept+0x2d>
	return alloc_sockfd(r);
  8028c7:	e8 5f ff ff ff       	call   80282b <alloc_sockfd>
}
  8028cc:	c9                   	leave  
  8028cd:	c3                   	ret    

008028ce <bind>:
{
  8028ce:	55                   	push   %ebp
  8028cf:	89 e5                	mov    %esp,%ebp
  8028d1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8028d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d7:	e8 1f ff ff ff       	call   8027fb <fd2sockid>
  8028dc:	85 c0                	test   %eax,%eax
  8028de:	78 12                	js     8028f2 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8028e0:	83 ec 04             	sub    $0x4,%esp
  8028e3:	ff 75 10             	pushl  0x10(%ebp)
  8028e6:	ff 75 0c             	pushl  0xc(%ebp)
  8028e9:	50                   	push   %eax
  8028ea:	e8 31 01 00 00       	call   802a20 <nsipc_bind>
  8028ef:	83 c4 10             	add    $0x10,%esp
}
  8028f2:	c9                   	leave  
  8028f3:	c3                   	ret    

008028f4 <shutdown>:
{
  8028f4:	55                   	push   %ebp
  8028f5:	89 e5                	mov    %esp,%ebp
  8028f7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8028fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fd:	e8 f9 fe ff ff       	call   8027fb <fd2sockid>
  802902:	85 c0                	test   %eax,%eax
  802904:	78 0f                	js     802915 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802906:	83 ec 08             	sub    $0x8,%esp
  802909:	ff 75 0c             	pushl  0xc(%ebp)
  80290c:	50                   	push   %eax
  80290d:	e8 43 01 00 00       	call   802a55 <nsipc_shutdown>
  802912:	83 c4 10             	add    $0x10,%esp
}
  802915:	c9                   	leave  
  802916:	c3                   	ret    

00802917 <connect>:
{
  802917:	55                   	push   %ebp
  802918:	89 e5                	mov    %esp,%ebp
  80291a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80291d:	8b 45 08             	mov    0x8(%ebp),%eax
  802920:	e8 d6 fe ff ff       	call   8027fb <fd2sockid>
  802925:	85 c0                	test   %eax,%eax
  802927:	78 12                	js     80293b <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802929:	83 ec 04             	sub    $0x4,%esp
  80292c:	ff 75 10             	pushl  0x10(%ebp)
  80292f:	ff 75 0c             	pushl  0xc(%ebp)
  802932:	50                   	push   %eax
  802933:	e8 59 01 00 00       	call   802a91 <nsipc_connect>
  802938:	83 c4 10             	add    $0x10,%esp
}
  80293b:	c9                   	leave  
  80293c:	c3                   	ret    

0080293d <listen>:
{
  80293d:	55                   	push   %ebp
  80293e:	89 e5                	mov    %esp,%ebp
  802940:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802943:	8b 45 08             	mov    0x8(%ebp),%eax
  802946:	e8 b0 fe ff ff       	call   8027fb <fd2sockid>
  80294b:	85 c0                	test   %eax,%eax
  80294d:	78 0f                	js     80295e <listen+0x21>
	return nsipc_listen(r, backlog);
  80294f:	83 ec 08             	sub    $0x8,%esp
  802952:	ff 75 0c             	pushl  0xc(%ebp)
  802955:	50                   	push   %eax
  802956:	e8 6b 01 00 00       	call   802ac6 <nsipc_listen>
  80295b:	83 c4 10             	add    $0x10,%esp
}
  80295e:	c9                   	leave  
  80295f:	c3                   	ret    

00802960 <socket>:

int
socket(int domain, int type, int protocol)
{
  802960:	55                   	push   %ebp
  802961:	89 e5                	mov    %esp,%ebp
  802963:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802966:	ff 75 10             	pushl  0x10(%ebp)
  802969:	ff 75 0c             	pushl  0xc(%ebp)
  80296c:	ff 75 08             	pushl  0x8(%ebp)
  80296f:	e8 3e 02 00 00       	call   802bb2 <nsipc_socket>
  802974:	83 c4 10             	add    $0x10,%esp
  802977:	85 c0                	test   %eax,%eax
  802979:	78 05                	js     802980 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80297b:	e8 ab fe ff ff       	call   80282b <alloc_sockfd>
}
  802980:	c9                   	leave  
  802981:	c3                   	ret    

00802982 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802982:	55                   	push   %ebp
  802983:	89 e5                	mov    %esp,%ebp
  802985:	53                   	push   %ebx
  802986:	83 ec 04             	sub    $0x4,%esp
  802989:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80298b:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802992:	74 26                	je     8029ba <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802994:	6a 07                	push   $0x7
  802996:	68 00 70 80 00       	push   $0x807000
  80299b:	53                   	push   %ebx
  80299c:	ff 35 04 50 80 00    	pushl  0x805004
  8029a2:	e8 d3 06 00 00       	call   80307a <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8029a7:	83 c4 0c             	add    $0xc,%esp
  8029aa:	6a 00                	push   $0x0
  8029ac:	6a 00                	push   $0x0
  8029ae:	6a 00                	push   $0x0
  8029b0:	e8 5c 06 00 00       	call   803011 <ipc_recv>
}
  8029b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8029b8:	c9                   	leave  
  8029b9:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8029ba:	83 ec 0c             	sub    $0xc,%esp
  8029bd:	6a 02                	push   $0x2
  8029bf:	e8 0e 07 00 00       	call   8030d2 <ipc_find_env>
  8029c4:	a3 04 50 80 00       	mov    %eax,0x805004
  8029c9:	83 c4 10             	add    $0x10,%esp
  8029cc:	eb c6                	jmp    802994 <nsipc+0x12>

008029ce <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8029ce:	55                   	push   %ebp
  8029cf:	89 e5                	mov    %esp,%ebp
  8029d1:	56                   	push   %esi
  8029d2:	53                   	push   %ebx
  8029d3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8029d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8029de:	8b 06                	mov    (%esi),%eax
  8029e0:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8029e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8029ea:	e8 93 ff ff ff       	call   802982 <nsipc>
  8029ef:	89 c3                	mov    %eax,%ebx
  8029f1:	85 c0                	test   %eax,%eax
  8029f3:	79 09                	jns    8029fe <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8029f5:	89 d8                	mov    %ebx,%eax
  8029f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8029fa:	5b                   	pop    %ebx
  8029fb:	5e                   	pop    %esi
  8029fc:	5d                   	pop    %ebp
  8029fd:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8029fe:	83 ec 04             	sub    $0x4,%esp
  802a01:	ff 35 10 70 80 00    	pushl  0x807010
  802a07:	68 00 70 80 00       	push   $0x807000
  802a0c:	ff 75 0c             	pushl  0xc(%ebp)
  802a0f:	e8 d2 e4 ff ff       	call   800ee6 <memmove>
		*addrlen = ret->ret_addrlen;
  802a14:	a1 10 70 80 00       	mov    0x807010,%eax
  802a19:	89 06                	mov    %eax,(%esi)
  802a1b:	83 c4 10             	add    $0x10,%esp
	return r;
  802a1e:	eb d5                	jmp    8029f5 <nsipc_accept+0x27>

00802a20 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802a20:	55                   	push   %ebp
  802a21:	89 e5                	mov    %esp,%ebp
  802a23:	53                   	push   %ebx
  802a24:	83 ec 08             	sub    $0x8,%esp
  802a27:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2d:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802a32:	53                   	push   %ebx
  802a33:	ff 75 0c             	pushl  0xc(%ebp)
  802a36:	68 04 70 80 00       	push   $0x807004
  802a3b:	e8 a6 e4 ff ff       	call   800ee6 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802a40:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802a46:	b8 02 00 00 00       	mov    $0x2,%eax
  802a4b:	e8 32 ff ff ff       	call   802982 <nsipc>
}
  802a50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802a53:	c9                   	leave  
  802a54:	c3                   	ret    

00802a55 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802a55:	55                   	push   %ebp
  802a56:	89 e5                	mov    %esp,%ebp
  802a58:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802a63:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a66:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802a6b:	b8 03 00 00 00       	mov    $0x3,%eax
  802a70:	e8 0d ff ff ff       	call   802982 <nsipc>
}
  802a75:	c9                   	leave  
  802a76:	c3                   	ret    

00802a77 <nsipc_close>:

int
nsipc_close(int s)
{
  802a77:	55                   	push   %ebp
  802a78:	89 e5                	mov    %esp,%ebp
  802a7a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a80:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802a85:	b8 04 00 00 00       	mov    $0x4,%eax
  802a8a:	e8 f3 fe ff ff       	call   802982 <nsipc>
}
  802a8f:	c9                   	leave  
  802a90:	c3                   	ret    

00802a91 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802a91:	55                   	push   %ebp
  802a92:	89 e5                	mov    %esp,%ebp
  802a94:	53                   	push   %ebx
  802a95:	83 ec 08             	sub    $0x8,%esp
  802a98:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9e:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802aa3:	53                   	push   %ebx
  802aa4:	ff 75 0c             	pushl  0xc(%ebp)
  802aa7:	68 04 70 80 00       	push   $0x807004
  802aac:	e8 35 e4 ff ff       	call   800ee6 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802ab1:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802ab7:	b8 05 00 00 00       	mov    $0x5,%eax
  802abc:	e8 c1 fe ff ff       	call   802982 <nsipc>
}
  802ac1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802ac4:	c9                   	leave  
  802ac5:	c3                   	ret    

00802ac6 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802ac6:	55                   	push   %ebp
  802ac7:	89 e5                	mov    %esp,%ebp
  802ac9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802acc:	8b 45 08             	mov    0x8(%ebp),%eax
  802acf:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802ad4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ad7:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802adc:	b8 06 00 00 00       	mov    $0x6,%eax
  802ae1:	e8 9c fe ff ff       	call   802982 <nsipc>
}
  802ae6:	c9                   	leave  
  802ae7:	c3                   	ret    

00802ae8 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802ae8:	55                   	push   %ebp
  802ae9:	89 e5                	mov    %esp,%ebp
  802aeb:	56                   	push   %esi
  802aec:	53                   	push   %ebx
  802aed:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802af0:	8b 45 08             	mov    0x8(%ebp),%eax
  802af3:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802af8:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802afe:	8b 45 14             	mov    0x14(%ebp),%eax
  802b01:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802b06:	b8 07 00 00 00       	mov    $0x7,%eax
  802b0b:	e8 72 fe ff ff       	call   802982 <nsipc>
  802b10:	89 c3                	mov    %eax,%ebx
  802b12:	85 c0                	test   %eax,%eax
  802b14:	78 1f                	js     802b35 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802b16:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802b1b:	7f 21                	jg     802b3e <nsipc_recv+0x56>
  802b1d:	39 c6                	cmp    %eax,%esi
  802b1f:	7c 1d                	jl     802b3e <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802b21:	83 ec 04             	sub    $0x4,%esp
  802b24:	50                   	push   %eax
  802b25:	68 00 70 80 00       	push   $0x807000
  802b2a:	ff 75 0c             	pushl  0xc(%ebp)
  802b2d:	e8 b4 e3 ff ff       	call   800ee6 <memmove>
  802b32:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802b35:	89 d8                	mov    %ebx,%eax
  802b37:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802b3a:	5b                   	pop    %ebx
  802b3b:	5e                   	pop    %esi
  802b3c:	5d                   	pop    %ebp
  802b3d:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802b3e:	68 72 3b 80 00       	push   $0x803b72
  802b43:	68 5b 3a 80 00       	push   $0x803a5b
  802b48:	6a 62                	push   $0x62
  802b4a:	68 87 3b 80 00       	push   $0x803b87
  802b4f:	e8 af d9 ff ff       	call   800503 <_panic>

00802b54 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802b54:	55                   	push   %ebp
  802b55:	89 e5                	mov    %esp,%ebp
  802b57:	53                   	push   %ebx
  802b58:	83 ec 04             	sub    $0x4,%esp
  802b5b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b61:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802b66:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802b6c:	7f 2e                	jg     802b9c <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802b6e:	83 ec 04             	sub    $0x4,%esp
  802b71:	53                   	push   %ebx
  802b72:	ff 75 0c             	pushl  0xc(%ebp)
  802b75:	68 0c 70 80 00       	push   $0x80700c
  802b7a:	e8 67 e3 ff ff       	call   800ee6 <memmove>
	nsipcbuf.send.req_size = size;
  802b7f:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802b85:	8b 45 14             	mov    0x14(%ebp),%eax
  802b88:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802b8d:	b8 08 00 00 00       	mov    $0x8,%eax
  802b92:	e8 eb fd ff ff       	call   802982 <nsipc>
}
  802b97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b9a:	c9                   	leave  
  802b9b:	c3                   	ret    
	assert(size < 1600);
  802b9c:	68 93 3b 80 00       	push   $0x803b93
  802ba1:	68 5b 3a 80 00       	push   $0x803a5b
  802ba6:	6a 6d                	push   $0x6d
  802ba8:	68 87 3b 80 00       	push   $0x803b87
  802bad:	e8 51 d9 ff ff       	call   800503 <_panic>

00802bb2 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802bb2:	55                   	push   %ebp
  802bb3:	89 e5                	mov    %esp,%ebp
  802bb5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbb:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802bc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bc3:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802bc8:	8b 45 10             	mov    0x10(%ebp),%eax
  802bcb:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802bd0:	b8 09 00 00 00       	mov    $0x9,%eax
  802bd5:	e8 a8 fd ff ff       	call   802982 <nsipc>
}
  802bda:	c9                   	leave  
  802bdb:	c3                   	ret    

00802bdc <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802bdc:	55                   	push   %ebp
  802bdd:	89 e5                	mov    %esp,%ebp
  802bdf:	56                   	push   %esi
  802be0:	53                   	push   %ebx
  802be1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802be4:	83 ec 0c             	sub    $0xc,%esp
  802be7:	ff 75 08             	pushl  0x8(%ebp)
  802bea:	e8 4d ed ff ff       	call   80193c <fd2data>
  802bef:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802bf1:	83 c4 08             	add    $0x8,%esp
  802bf4:	68 9f 3b 80 00       	push   $0x803b9f
  802bf9:	53                   	push   %ebx
  802bfa:	e8 59 e1 ff ff       	call   800d58 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802bff:	8b 46 04             	mov    0x4(%esi),%eax
  802c02:	2b 06                	sub    (%esi),%eax
  802c04:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802c0a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802c11:	00 00 00 
	stat->st_dev = &devpipe;
  802c14:	c7 83 88 00 00 00 58 	movl   $0x804058,0x88(%ebx)
  802c1b:	40 80 00 
	return 0;
}
  802c1e:	b8 00 00 00 00       	mov    $0x0,%eax
  802c23:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802c26:	5b                   	pop    %ebx
  802c27:	5e                   	pop    %esi
  802c28:	5d                   	pop    %ebp
  802c29:	c3                   	ret    

00802c2a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802c2a:	55                   	push   %ebp
  802c2b:	89 e5                	mov    %esp,%ebp
  802c2d:	53                   	push   %ebx
  802c2e:	83 ec 0c             	sub    $0xc,%esp
  802c31:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802c34:	53                   	push   %ebx
  802c35:	6a 00                	push   $0x0
  802c37:	e8 93 e5 ff ff       	call   8011cf <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802c3c:	89 1c 24             	mov    %ebx,(%esp)
  802c3f:	e8 f8 ec ff ff       	call   80193c <fd2data>
  802c44:	83 c4 08             	add    $0x8,%esp
  802c47:	50                   	push   %eax
  802c48:	6a 00                	push   $0x0
  802c4a:	e8 80 e5 ff ff       	call   8011cf <sys_page_unmap>
}
  802c4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802c52:	c9                   	leave  
  802c53:	c3                   	ret    

00802c54 <_pipeisclosed>:
{
  802c54:	55                   	push   %ebp
  802c55:	89 e5                	mov    %esp,%ebp
  802c57:	57                   	push   %edi
  802c58:	56                   	push   %esi
  802c59:	53                   	push   %ebx
  802c5a:	83 ec 1c             	sub    $0x1c,%esp
  802c5d:	89 c7                	mov    %eax,%edi
  802c5f:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802c61:	a1 08 50 80 00       	mov    0x805008,%eax
  802c66:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802c69:	83 ec 0c             	sub    $0xc,%esp
  802c6c:	57                   	push   %edi
  802c6d:	e8 9f 04 00 00       	call   803111 <pageref>
  802c72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802c75:	89 34 24             	mov    %esi,(%esp)
  802c78:	e8 94 04 00 00       	call   803111 <pageref>
		nn = thisenv->env_runs;
  802c7d:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802c83:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802c86:	83 c4 10             	add    $0x10,%esp
  802c89:	39 cb                	cmp    %ecx,%ebx
  802c8b:	74 1b                	je     802ca8 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802c8d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802c90:	75 cf                	jne    802c61 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802c92:	8b 42 58             	mov    0x58(%edx),%eax
  802c95:	6a 01                	push   $0x1
  802c97:	50                   	push   %eax
  802c98:	53                   	push   %ebx
  802c99:	68 a6 3b 80 00       	push   $0x803ba6
  802c9e:	e8 56 d9 ff ff       	call   8005f9 <cprintf>
  802ca3:	83 c4 10             	add    $0x10,%esp
  802ca6:	eb b9                	jmp    802c61 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802ca8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802cab:	0f 94 c0             	sete   %al
  802cae:	0f b6 c0             	movzbl %al,%eax
}
  802cb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802cb4:	5b                   	pop    %ebx
  802cb5:	5e                   	pop    %esi
  802cb6:	5f                   	pop    %edi
  802cb7:	5d                   	pop    %ebp
  802cb8:	c3                   	ret    

00802cb9 <devpipe_write>:
{
  802cb9:	55                   	push   %ebp
  802cba:	89 e5                	mov    %esp,%ebp
  802cbc:	57                   	push   %edi
  802cbd:	56                   	push   %esi
  802cbe:	53                   	push   %ebx
  802cbf:	83 ec 28             	sub    $0x28,%esp
  802cc2:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802cc5:	56                   	push   %esi
  802cc6:	e8 71 ec ff ff       	call   80193c <fd2data>
  802ccb:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802ccd:	83 c4 10             	add    $0x10,%esp
  802cd0:	bf 00 00 00 00       	mov    $0x0,%edi
  802cd5:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802cd8:	74 4f                	je     802d29 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802cda:	8b 43 04             	mov    0x4(%ebx),%eax
  802cdd:	8b 0b                	mov    (%ebx),%ecx
  802cdf:	8d 51 20             	lea    0x20(%ecx),%edx
  802ce2:	39 d0                	cmp    %edx,%eax
  802ce4:	72 14                	jb     802cfa <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802ce6:	89 da                	mov    %ebx,%edx
  802ce8:	89 f0                	mov    %esi,%eax
  802cea:	e8 65 ff ff ff       	call   802c54 <_pipeisclosed>
  802cef:	85 c0                	test   %eax,%eax
  802cf1:	75 3b                	jne    802d2e <devpipe_write+0x75>
			sys_yield();
  802cf3:	e8 33 e4 ff ff       	call   80112b <sys_yield>
  802cf8:	eb e0                	jmp    802cda <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802cfa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802cfd:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802d01:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802d04:	89 c2                	mov    %eax,%edx
  802d06:	c1 fa 1f             	sar    $0x1f,%edx
  802d09:	89 d1                	mov    %edx,%ecx
  802d0b:	c1 e9 1b             	shr    $0x1b,%ecx
  802d0e:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802d11:	83 e2 1f             	and    $0x1f,%edx
  802d14:	29 ca                	sub    %ecx,%edx
  802d16:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802d1a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802d1e:	83 c0 01             	add    $0x1,%eax
  802d21:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802d24:	83 c7 01             	add    $0x1,%edi
  802d27:	eb ac                	jmp    802cd5 <devpipe_write+0x1c>
	return i;
  802d29:	8b 45 10             	mov    0x10(%ebp),%eax
  802d2c:	eb 05                	jmp    802d33 <devpipe_write+0x7a>
				return 0;
  802d2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d33:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d36:	5b                   	pop    %ebx
  802d37:	5e                   	pop    %esi
  802d38:	5f                   	pop    %edi
  802d39:	5d                   	pop    %ebp
  802d3a:	c3                   	ret    

00802d3b <devpipe_read>:
{
  802d3b:	55                   	push   %ebp
  802d3c:	89 e5                	mov    %esp,%ebp
  802d3e:	57                   	push   %edi
  802d3f:	56                   	push   %esi
  802d40:	53                   	push   %ebx
  802d41:	83 ec 18             	sub    $0x18,%esp
  802d44:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802d47:	57                   	push   %edi
  802d48:	e8 ef eb ff ff       	call   80193c <fd2data>
  802d4d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802d4f:	83 c4 10             	add    $0x10,%esp
  802d52:	be 00 00 00 00       	mov    $0x0,%esi
  802d57:	3b 75 10             	cmp    0x10(%ebp),%esi
  802d5a:	75 14                	jne    802d70 <devpipe_read+0x35>
	return i;
  802d5c:	8b 45 10             	mov    0x10(%ebp),%eax
  802d5f:	eb 02                	jmp    802d63 <devpipe_read+0x28>
				return i;
  802d61:	89 f0                	mov    %esi,%eax
}
  802d63:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d66:	5b                   	pop    %ebx
  802d67:	5e                   	pop    %esi
  802d68:	5f                   	pop    %edi
  802d69:	5d                   	pop    %ebp
  802d6a:	c3                   	ret    
			sys_yield();
  802d6b:	e8 bb e3 ff ff       	call   80112b <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802d70:	8b 03                	mov    (%ebx),%eax
  802d72:	3b 43 04             	cmp    0x4(%ebx),%eax
  802d75:	75 18                	jne    802d8f <devpipe_read+0x54>
			if (i > 0)
  802d77:	85 f6                	test   %esi,%esi
  802d79:	75 e6                	jne    802d61 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802d7b:	89 da                	mov    %ebx,%edx
  802d7d:	89 f8                	mov    %edi,%eax
  802d7f:	e8 d0 fe ff ff       	call   802c54 <_pipeisclosed>
  802d84:	85 c0                	test   %eax,%eax
  802d86:	74 e3                	je     802d6b <devpipe_read+0x30>
				return 0;
  802d88:	b8 00 00 00 00       	mov    $0x0,%eax
  802d8d:	eb d4                	jmp    802d63 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802d8f:	99                   	cltd   
  802d90:	c1 ea 1b             	shr    $0x1b,%edx
  802d93:	01 d0                	add    %edx,%eax
  802d95:	83 e0 1f             	and    $0x1f,%eax
  802d98:	29 d0                	sub    %edx,%eax
  802d9a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802d9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802da2:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802da5:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802da8:	83 c6 01             	add    $0x1,%esi
  802dab:	eb aa                	jmp    802d57 <devpipe_read+0x1c>

00802dad <pipe>:
{
  802dad:	55                   	push   %ebp
  802dae:	89 e5                	mov    %esp,%ebp
  802db0:	56                   	push   %esi
  802db1:	53                   	push   %ebx
  802db2:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802db5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802db8:	50                   	push   %eax
  802db9:	e8 95 eb ff ff       	call   801953 <fd_alloc>
  802dbe:	89 c3                	mov    %eax,%ebx
  802dc0:	83 c4 10             	add    $0x10,%esp
  802dc3:	85 c0                	test   %eax,%eax
  802dc5:	0f 88 23 01 00 00    	js     802eee <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802dcb:	83 ec 04             	sub    $0x4,%esp
  802dce:	68 07 04 00 00       	push   $0x407
  802dd3:	ff 75 f4             	pushl  -0xc(%ebp)
  802dd6:	6a 00                	push   $0x0
  802dd8:	e8 6d e3 ff ff       	call   80114a <sys_page_alloc>
  802ddd:	89 c3                	mov    %eax,%ebx
  802ddf:	83 c4 10             	add    $0x10,%esp
  802de2:	85 c0                	test   %eax,%eax
  802de4:	0f 88 04 01 00 00    	js     802eee <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802dea:	83 ec 0c             	sub    $0xc,%esp
  802ded:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802df0:	50                   	push   %eax
  802df1:	e8 5d eb ff ff       	call   801953 <fd_alloc>
  802df6:	89 c3                	mov    %eax,%ebx
  802df8:	83 c4 10             	add    $0x10,%esp
  802dfb:	85 c0                	test   %eax,%eax
  802dfd:	0f 88 db 00 00 00    	js     802ede <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e03:	83 ec 04             	sub    $0x4,%esp
  802e06:	68 07 04 00 00       	push   $0x407
  802e0b:	ff 75 f0             	pushl  -0x10(%ebp)
  802e0e:	6a 00                	push   $0x0
  802e10:	e8 35 e3 ff ff       	call   80114a <sys_page_alloc>
  802e15:	89 c3                	mov    %eax,%ebx
  802e17:	83 c4 10             	add    $0x10,%esp
  802e1a:	85 c0                	test   %eax,%eax
  802e1c:	0f 88 bc 00 00 00    	js     802ede <pipe+0x131>
	va = fd2data(fd0);
  802e22:	83 ec 0c             	sub    $0xc,%esp
  802e25:	ff 75 f4             	pushl  -0xc(%ebp)
  802e28:	e8 0f eb ff ff       	call   80193c <fd2data>
  802e2d:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e2f:	83 c4 0c             	add    $0xc,%esp
  802e32:	68 07 04 00 00       	push   $0x407
  802e37:	50                   	push   %eax
  802e38:	6a 00                	push   $0x0
  802e3a:	e8 0b e3 ff ff       	call   80114a <sys_page_alloc>
  802e3f:	89 c3                	mov    %eax,%ebx
  802e41:	83 c4 10             	add    $0x10,%esp
  802e44:	85 c0                	test   %eax,%eax
  802e46:	0f 88 82 00 00 00    	js     802ece <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e4c:	83 ec 0c             	sub    $0xc,%esp
  802e4f:	ff 75 f0             	pushl  -0x10(%ebp)
  802e52:	e8 e5 ea ff ff       	call   80193c <fd2data>
  802e57:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802e5e:	50                   	push   %eax
  802e5f:	6a 00                	push   $0x0
  802e61:	56                   	push   %esi
  802e62:	6a 00                	push   $0x0
  802e64:	e8 24 e3 ff ff       	call   80118d <sys_page_map>
  802e69:	89 c3                	mov    %eax,%ebx
  802e6b:	83 c4 20             	add    $0x20,%esp
  802e6e:	85 c0                	test   %eax,%eax
  802e70:	78 4e                	js     802ec0 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802e72:	a1 58 40 80 00       	mov    0x804058,%eax
  802e77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e7a:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802e7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e7f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802e86:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e89:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802e8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802e95:	83 ec 0c             	sub    $0xc,%esp
  802e98:	ff 75 f4             	pushl  -0xc(%ebp)
  802e9b:	e8 8c ea ff ff       	call   80192c <fd2num>
  802ea0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802ea3:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802ea5:	83 c4 04             	add    $0x4,%esp
  802ea8:	ff 75 f0             	pushl  -0x10(%ebp)
  802eab:	e8 7c ea ff ff       	call   80192c <fd2num>
  802eb0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802eb3:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802eb6:	83 c4 10             	add    $0x10,%esp
  802eb9:	bb 00 00 00 00       	mov    $0x0,%ebx
  802ebe:	eb 2e                	jmp    802eee <pipe+0x141>
	sys_page_unmap(0, va);
  802ec0:	83 ec 08             	sub    $0x8,%esp
  802ec3:	56                   	push   %esi
  802ec4:	6a 00                	push   $0x0
  802ec6:	e8 04 e3 ff ff       	call   8011cf <sys_page_unmap>
  802ecb:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802ece:	83 ec 08             	sub    $0x8,%esp
  802ed1:	ff 75 f0             	pushl  -0x10(%ebp)
  802ed4:	6a 00                	push   $0x0
  802ed6:	e8 f4 e2 ff ff       	call   8011cf <sys_page_unmap>
  802edb:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802ede:	83 ec 08             	sub    $0x8,%esp
  802ee1:	ff 75 f4             	pushl  -0xc(%ebp)
  802ee4:	6a 00                	push   $0x0
  802ee6:	e8 e4 e2 ff ff       	call   8011cf <sys_page_unmap>
  802eeb:	83 c4 10             	add    $0x10,%esp
}
  802eee:	89 d8                	mov    %ebx,%eax
  802ef0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802ef3:	5b                   	pop    %ebx
  802ef4:	5e                   	pop    %esi
  802ef5:	5d                   	pop    %ebp
  802ef6:	c3                   	ret    

00802ef7 <pipeisclosed>:
{
  802ef7:	55                   	push   %ebp
  802ef8:	89 e5                	mov    %esp,%ebp
  802efa:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802efd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f00:	50                   	push   %eax
  802f01:	ff 75 08             	pushl  0x8(%ebp)
  802f04:	e8 9c ea ff ff       	call   8019a5 <fd_lookup>
  802f09:	83 c4 10             	add    $0x10,%esp
  802f0c:	85 c0                	test   %eax,%eax
  802f0e:	78 18                	js     802f28 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802f10:	83 ec 0c             	sub    $0xc,%esp
  802f13:	ff 75 f4             	pushl  -0xc(%ebp)
  802f16:	e8 21 ea ff ff       	call   80193c <fd2data>
	return _pipeisclosed(fd, p);
  802f1b:	89 c2                	mov    %eax,%edx
  802f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f20:	e8 2f fd ff ff       	call   802c54 <_pipeisclosed>
  802f25:	83 c4 10             	add    $0x10,%esp
}
  802f28:	c9                   	leave  
  802f29:	c3                   	ret    

00802f2a <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802f2a:	55                   	push   %ebp
  802f2b:	89 e5                	mov    %esp,%ebp
  802f2d:	56                   	push   %esi
  802f2e:	53                   	push   %ebx
  802f2f:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802f32:	85 f6                	test   %esi,%esi
  802f34:	74 16                	je     802f4c <wait+0x22>
	e = &envs[ENVX(envid)];
  802f36:	89 f3                	mov    %esi,%ebx
  802f38:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE){
  802f3e:	69 db 84 00 00 00    	imul   $0x84,%ebx,%ebx
  802f44:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802f4a:	eb 1b                	jmp    802f67 <wait+0x3d>
	assert(envid != 0);
  802f4c:	68 be 3b 80 00       	push   $0x803bbe
  802f51:	68 5b 3a 80 00       	push   $0x803a5b
  802f56:	6a 09                	push   $0x9
  802f58:	68 c9 3b 80 00       	push   $0x803bc9
  802f5d:	e8 a1 d5 ff ff       	call   800503 <_panic>
		sys_yield();
  802f62:	e8 c4 e1 ff ff       	call   80112b <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE){
  802f67:	8b 43 48             	mov    0x48(%ebx),%eax
  802f6a:	39 f0                	cmp    %esi,%eax
  802f6c:	75 07                	jne    802f75 <wait+0x4b>
  802f6e:	8b 43 54             	mov    0x54(%ebx),%eax
  802f71:	85 c0                	test   %eax,%eax
  802f73:	75 ed                	jne    802f62 <wait+0x38>
	}
}
  802f75:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f78:	5b                   	pop    %ebx
  802f79:	5e                   	pop    %esi
  802f7a:	5d                   	pop    %ebp
  802f7b:	c3                   	ret    

00802f7c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802f7c:	55                   	push   %ebp
  802f7d:	89 e5                	mov    %esp,%ebp
  802f7f:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802f82:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802f89:	74 0a                	je     802f95 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8e:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802f93:	c9                   	leave  
  802f94:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802f95:	83 ec 04             	sub    $0x4,%esp
  802f98:	6a 07                	push   $0x7
  802f9a:	68 00 f0 bf ee       	push   $0xeebff000
  802f9f:	6a 00                	push   $0x0
  802fa1:	e8 a4 e1 ff ff       	call   80114a <sys_page_alloc>
		if(r < 0)
  802fa6:	83 c4 10             	add    $0x10,%esp
  802fa9:	85 c0                	test   %eax,%eax
  802fab:	78 2a                	js     802fd7 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802fad:	83 ec 08             	sub    $0x8,%esp
  802fb0:	68 eb 2f 80 00       	push   $0x802feb
  802fb5:	6a 00                	push   $0x0
  802fb7:	e8 d9 e2 ff ff       	call   801295 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802fbc:	83 c4 10             	add    $0x10,%esp
  802fbf:	85 c0                	test   %eax,%eax
  802fc1:	79 c8                	jns    802f8b <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802fc3:	83 ec 04             	sub    $0x4,%esp
  802fc6:	68 04 3c 80 00       	push   $0x803c04
  802fcb:	6a 25                	push   $0x25
  802fcd:	68 40 3c 80 00       	push   $0x803c40
  802fd2:	e8 2c d5 ff ff       	call   800503 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802fd7:	83 ec 04             	sub    $0x4,%esp
  802fda:	68 d4 3b 80 00       	push   $0x803bd4
  802fdf:	6a 22                	push   $0x22
  802fe1:	68 40 3c 80 00       	push   $0x803c40
  802fe6:	e8 18 d5 ff ff       	call   800503 <_panic>

00802feb <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802feb:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802fec:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802ff1:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802ff3:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802ff6:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802ffa:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802ffe:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  803001:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  803003:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  803007:	83 c4 08             	add    $0x8,%esp
	popal
  80300a:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80300b:	83 c4 04             	add    $0x4,%esp
	popfl
  80300e:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80300f:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  803010:	c3                   	ret    

00803011 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803011:	55                   	push   %ebp
  803012:	89 e5                	mov    %esp,%ebp
  803014:	56                   	push   %esi
  803015:	53                   	push   %ebx
  803016:	8b 75 08             	mov    0x8(%ebp),%esi
  803019:	8b 45 0c             	mov    0xc(%ebp),%eax
  80301c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80301f:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  803021:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  803026:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  803029:	83 ec 0c             	sub    $0xc,%esp
  80302c:	50                   	push   %eax
  80302d:	e8 c8 e2 ff ff       	call   8012fa <sys_ipc_recv>
	if(ret < 0){
  803032:	83 c4 10             	add    $0x10,%esp
  803035:	85 c0                	test   %eax,%eax
  803037:	78 2b                	js     803064 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  803039:	85 f6                	test   %esi,%esi
  80303b:	74 0a                	je     803047 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80303d:	a1 08 50 80 00       	mov    0x805008,%eax
  803042:	8b 40 78             	mov    0x78(%eax),%eax
  803045:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  803047:	85 db                	test   %ebx,%ebx
  803049:	74 0a                	je     803055 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80304b:	a1 08 50 80 00       	mov    0x805008,%eax
  803050:	8b 40 7c             	mov    0x7c(%eax),%eax
  803053:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  803055:	a1 08 50 80 00       	mov    0x805008,%eax
  80305a:	8b 40 74             	mov    0x74(%eax),%eax
}
  80305d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803060:	5b                   	pop    %ebx
  803061:	5e                   	pop    %esi
  803062:	5d                   	pop    %ebp
  803063:	c3                   	ret    
		if(from_env_store)
  803064:	85 f6                	test   %esi,%esi
  803066:	74 06                	je     80306e <ipc_recv+0x5d>
			*from_env_store = 0;
  803068:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80306e:	85 db                	test   %ebx,%ebx
  803070:	74 eb                	je     80305d <ipc_recv+0x4c>
			*perm_store = 0;
  803072:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  803078:	eb e3                	jmp    80305d <ipc_recv+0x4c>

0080307a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80307a:	55                   	push   %ebp
  80307b:	89 e5                	mov    %esp,%ebp
  80307d:	57                   	push   %edi
  80307e:	56                   	push   %esi
  80307f:	53                   	push   %ebx
  803080:	83 ec 0c             	sub    $0xc,%esp
  803083:	8b 7d 08             	mov    0x8(%ebp),%edi
  803086:	8b 75 0c             	mov    0xc(%ebp),%esi
  803089:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80308c:	85 db                	test   %ebx,%ebx
  80308e:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  803093:	0f 44 d8             	cmove  %eax,%ebx
  803096:	eb 05                	jmp    80309d <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  803098:	e8 8e e0 ff ff       	call   80112b <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80309d:	ff 75 14             	pushl  0x14(%ebp)
  8030a0:	53                   	push   %ebx
  8030a1:	56                   	push   %esi
  8030a2:	57                   	push   %edi
  8030a3:	e8 2f e2 ff ff       	call   8012d7 <sys_ipc_try_send>
  8030a8:	83 c4 10             	add    $0x10,%esp
  8030ab:	85 c0                	test   %eax,%eax
  8030ad:	74 1b                	je     8030ca <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8030af:	79 e7                	jns    803098 <ipc_send+0x1e>
  8030b1:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8030b4:	74 e2                	je     803098 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8030b6:	83 ec 04             	sub    $0x4,%esp
  8030b9:	68 4e 3c 80 00       	push   $0x803c4e
  8030be:	6a 46                	push   $0x46
  8030c0:	68 63 3c 80 00       	push   $0x803c63
  8030c5:	e8 39 d4 ff ff       	call   800503 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8030ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8030cd:	5b                   	pop    %ebx
  8030ce:	5e                   	pop    %esi
  8030cf:	5f                   	pop    %edi
  8030d0:	5d                   	pop    %ebp
  8030d1:	c3                   	ret    

008030d2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8030d2:	55                   	push   %ebp
  8030d3:	89 e5                	mov    %esp,%ebp
  8030d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8030d8:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8030dd:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8030e3:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8030e9:	8b 52 50             	mov    0x50(%edx),%edx
  8030ec:	39 ca                	cmp    %ecx,%edx
  8030ee:	74 11                	je     803101 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8030f0:	83 c0 01             	add    $0x1,%eax
  8030f3:	3d 00 04 00 00       	cmp    $0x400,%eax
  8030f8:	75 e3                	jne    8030dd <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8030fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8030ff:	eb 0e                	jmp    80310f <ipc_find_env+0x3d>
			return envs[i].env_id;
  803101:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  803107:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80310c:	8b 40 48             	mov    0x48(%eax),%eax
}
  80310f:	5d                   	pop    %ebp
  803110:	c3                   	ret    

00803111 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803111:	55                   	push   %ebp
  803112:	89 e5                	mov    %esp,%ebp
  803114:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803117:	89 d0                	mov    %edx,%eax
  803119:	c1 e8 16             	shr    $0x16,%eax
  80311c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  803123:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  803128:	f6 c1 01             	test   $0x1,%cl
  80312b:	74 1d                	je     80314a <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80312d:	c1 ea 0c             	shr    $0xc,%edx
  803130:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803137:	f6 c2 01             	test   $0x1,%dl
  80313a:	74 0e                	je     80314a <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80313c:	c1 ea 0c             	shr    $0xc,%edx
  80313f:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  803146:	ef 
  803147:	0f b7 c0             	movzwl %ax,%eax
}
  80314a:	5d                   	pop    %ebp
  80314b:	c3                   	ret    
  80314c:	66 90                	xchg   %ax,%ax
  80314e:	66 90                	xchg   %ax,%ax

00803150 <__udivdi3>:
  803150:	55                   	push   %ebp
  803151:	57                   	push   %edi
  803152:	56                   	push   %esi
  803153:	53                   	push   %ebx
  803154:	83 ec 1c             	sub    $0x1c,%esp
  803157:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80315b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80315f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803163:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  803167:	85 d2                	test   %edx,%edx
  803169:	75 4d                	jne    8031b8 <__udivdi3+0x68>
  80316b:	39 f3                	cmp    %esi,%ebx
  80316d:	76 19                	jbe    803188 <__udivdi3+0x38>
  80316f:	31 ff                	xor    %edi,%edi
  803171:	89 e8                	mov    %ebp,%eax
  803173:	89 f2                	mov    %esi,%edx
  803175:	f7 f3                	div    %ebx
  803177:	89 fa                	mov    %edi,%edx
  803179:	83 c4 1c             	add    $0x1c,%esp
  80317c:	5b                   	pop    %ebx
  80317d:	5e                   	pop    %esi
  80317e:	5f                   	pop    %edi
  80317f:	5d                   	pop    %ebp
  803180:	c3                   	ret    
  803181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803188:	89 d9                	mov    %ebx,%ecx
  80318a:	85 db                	test   %ebx,%ebx
  80318c:	75 0b                	jne    803199 <__udivdi3+0x49>
  80318e:	b8 01 00 00 00       	mov    $0x1,%eax
  803193:	31 d2                	xor    %edx,%edx
  803195:	f7 f3                	div    %ebx
  803197:	89 c1                	mov    %eax,%ecx
  803199:	31 d2                	xor    %edx,%edx
  80319b:	89 f0                	mov    %esi,%eax
  80319d:	f7 f1                	div    %ecx
  80319f:	89 c6                	mov    %eax,%esi
  8031a1:	89 e8                	mov    %ebp,%eax
  8031a3:	89 f7                	mov    %esi,%edi
  8031a5:	f7 f1                	div    %ecx
  8031a7:	89 fa                	mov    %edi,%edx
  8031a9:	83 c4 1c             	add    $0x1c,%esp
  8031ac:	5b                   	pop    %ebx
  8031ad:	5e                   	pop    %esi
  8031ae:	5f                   	pop    %edi
  8031af:	5d                   	pop    %ebp
  8031b0:	c3                   	ret    
  8031b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8031b8:	39 f2                	cmp    %esi,%edx
  8031ba:	77 1c                	ja     8031d8 <__udivdi3+0x88>
  8031bc:	0f bd fa             	bsr    %edx,%edi
  8031bf:	83 f7 1f             	xor    $0x1f,%edi
  8031c2:	75 2c                	jne    8031f0 <__udivdi3+0xa0>
  8031c4:	39 f2                	cmp    %esi,%edx
  8031c6:	72 06                	jb     8031ce <__udivdi3+0x7e>
  8031c8:	31 c0                	xor    %eax,%eax
  8031ca:	39 eb                	cmp    %ebp,%ebx
  8031cc:	77 a9                	ja     803177 <__udivdi3+0x27>
  8031ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8031d3:	eb a2                	jmp    803177 <__udivdi3+0x27>
  8031d5:	8d 76 00             	lea    0x0(%esi),%esi
  8031d8:	31 ff                	xor    %edi,%edi
  8031da:	31 c0                	xor    %eax,%eax
  8031dc:	89 fa                	mov    %edi,%edx
  8031de:	83 c4 1c             	add    $0x1c,%esp
  8031e1:	5b                   	pop    %ebx
  8031e2:	5e                   	pop    %esi
  8031e3:	5f                   	pop    %edi
  8031e4:	5d                   	pop    %ebp
  8031e5:	c3                   	ret    
  8031e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8031ed:	8d 76 00             	lea    0x0(%esi),%esi
  8031f0:	89 f9                	mov    %edi,%ecx
  8031f2:	b8 20 00 00 00       	mov    $0x20,%eax
  8031f7:	29 f8                	sub    %edi,%eax
  8031f9:	d3 e2                	shl    %cl,%edx
  8031fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8031ff:	89 c1                	mov    %eax,%ecx
  803201:	89 da                	mov    %ebx,%edx
  803203:	d3 ea                	shr    %cl,%edx
  803205:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803209:	09 d1                	or     %edx,%ecx
  80320b:	89 f2                	mov    %esi,%edx
  80320d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803211:	89 f9                	mov    %edi,%ecx
  803213:	d3 e3                	shl    %cl,%ebx
  803215:	89 c1                	mov    %eax,%ecx
  803217:	d3 ea                	shr    %cl,%edx
  803219:	89 f9                	mov    %edi,%ecx
  80321b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80321f:	89 eb                	mov    %ebp,%ebx
  803221:	d3 e6                	shl    %cl,%esi
  803223:	89 c1                	mov    %eax,%ecx
  803225:	d3 eb                	shr    %cl,%ebx
  803227:	09 de                	or     %ebx,%esi
  803229:	89 f0                	mov    %esi,%eax
  80322b:	f7 74 24 08          	divl   0x8(%esp)
  80322f:	89 d6                	mov    %edx,%esi
  803231:	89 c3                	mov    %eax,%ebx
  803233:	f7 64 24 0c          	mull   0xc(%esp)
  803237:	39 d6                	cmp    %edx,%esi
  803239:	72 15                	jb     803250 <__udivdi3+0x100>
  80323b:	89 f9                	mov    %edi,%ecx
  80323d:	d3 e5                	shl    %cl,%ebp
  80323f:	39 c5                	cmp    %eax,%ebp
  803241:	73 04                	jae    803247 <__udivdi3+0xf7>
  803243:	39 d6                	cmp    %edx,%esi
  803245:	74 09                	je     803250 <__udivdi3+0x100>
  803247:	89 d8                	mov    %ebx,%eax
  803249:	31 ff                	xor    %edi,%edi
  80324b:	e9 27 ff ff ff       	jmp    803177 <__udivdi3+0x27>
  803250:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803253:	31 ff                	xor    %edi,%edi
  803255:	e9 1d ff ff ff       	jmp    803177 <__udivdi3+0x27>
  80325a:	66 90                	xchg   %ax,%ax
  80325c:	66 90                	xchg   %ax,%ax
  80325e:	66 90                	xchg   %ax,%ax

00803260 <__umoddi3>:
  803260:	55                   	push   %ebp
  803261:	57                   	push   %edi
  803262:	56                   	push   %esi
  803263:	53                   	push   %ebx
  803264:	83 ec 1c             	sub    $0x1c,%esp
  803267:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80326b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80326f:	8b 74 24 30          	mov    0x30(%esp),%esi
  803273:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803277:	89 da                	mov    %ebx,%edx
  803279:	85 c0                	test   %eax,%eax
  80327b:	75 43                	jne    8032c0 <__umoddi3+0x60>
  80327d:	39 df                	cmp    %ebx,%edi
  80327f:	76 17                	jbe    803298 <__umoddi3+0x38>
  803281:	89 f0                	mov    %esi,%eax
  803283:	f7 f7                	div    %edi
  803285:	89 d0                	mov    %edx,%eax
  803287:	31 d2                	xor    %edx,%edx
  803289:	83 c4 1c             	add    $0x1c,%esp
  80328c:	5b                   	pop    %ebx
  80328d:	5e                   	pop    %esi
  80328e:	5f                   	pop    %edi
  80328f:	5d                   	pop    %ebp
  803290:	c3                   	ret    
  803291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803298:	89 fd                	mov    %edi,%ebp
  80329a:	85 ff                	test   %edi,%edi
  80329c:	75 0b                	jne    8032a9 <__umoddi3+0x49>
  80329e:	b8 01 00 00 00       	mov    $0x1,%eax
  8032a3:	31 d2                	xor    %edx,%edx
  8032a5:	f7 f7                	div    %edi
  8032a7:	89 c5                	mov    %eax,%ebp
  8032a9:	89 d8                	mov    %ebx,%eax
  8032ab:	31 d2                	xor    %edx,%edx
  8032ad:	f7 f5                	div    %ebp
  8032af:	89 f0                	mov    %esi,%eax
  8032b1:	f7 f5                	div    %ebp
  8032b3:	89 d0                	mov    %edx,%eax
  8032b5:	eb d0                	jmp    803287 <__umoddi3+0x27>
  8032b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8032be:	66 90                	xchg   %ax,%ax
  8032c0:	89 f1                	mov    %esi,%ecx
  8032c2:	39 d8                	cmp    %ebx,%eax
  8032c4:	76 0a                	jbe    8032d0 <__umoddi3+0x70>
  8032c6:	89 f0                	mov    %esi,%eax
  8032c8:	83 c4 1c             	add    $0x1c,%esp
  8032cb:	5b                   	pop    %ebx
  8032cc:	5e                   	pop    %esi
  8032cd:	5f                   	pop    %edi
  8032ce:	5d                   	pop    %ebp
  8032cf:	c3                   	ret    
  8032d0:	0f bd e8             	bsr    %eax,%ebp
  8032d3:	83 f5 1f             	xor    $0x1f,%ebp
  8032d6:	75 20                	jne    8032f8 <__umoddi3+0x98>
  8032d8:	39 d8                	cmp    %ebx,%eax
  8032da:	0f 82 b0 00 00 00    	jb     803390 <__umoddi3+0x130>
  8032e0:	39 f7                	cmp    %esi,%edi
  8032e2:	0f 86 a8 00 00 00    	jbe    803390 <__umoddi3+0x130>
  8032e8:	89 c8                	mov    %ecx,%eax
  8032ea:	83 c4 1c             	add    $0x1c,%esp
  8032ed:	5b                   	pop    %ebx
  8032ee:	5e                   	pop    %esi
  8032ef:	5f                   	pop    %edi
  8032f0:	5d                   	pop    %ebp
  8032f1:	c3                   	ret    
  8032f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8032f8:	89 e9                	mov    %ebp,%ecx
  8032fa:	ba 20 00 00 00       	mov    $0x20,%edx
  8032ff:	29 ea                	sub    %ebp,%edx
  803301:	d3 e0                	shl    %cl,%eax
  803303:	89 44 24 08          	mov    %eax,0x8(%esp)
  803307:	89 d1                	mov    %edx,%ecx
  803309:	89 f8                	mov    %edi,%eax
  80330b:	d3 e8                	shr    %cl,%eax
  80330d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803311:	89 54 24 04          	mov    %edx,0x4(%esp)
  803315:	8b 54 24 04          	mov    0x4(%esp),%edx
  803319:	09 c1                	or     %eax,%ecx
  80331b:	89 d8                	mov    %ebx,%eax
  80331d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803321:	89 e9                	mov    %ebp,%ecx
  803323:	d3 e7                	shl    %cl,%edi
  803325:	89 d1                	mov    %edx,%ecx
  803327:	d3 e8                	shr    %cl,%eax
  803329:	89 e9                	mov    %ebp,%ecx
  80332b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80332f:	d3 e3                	shl    %cl,%ebx
  803331:	89 c7                	mov    %eax,%edi
  803333:	89 d1                	mov    %edx,%ecx
  803335:	89 f0                	mov    %esi,%eax
  803337:	d3 e8                	shr    %cl,%eax
  803339:	89 e9                	mov    %ebp,%ecx
  80333b:	89 fa                	mov    %edi,%edx
  80333d:	d3 e6                	shl    %cl,%esi
  80333f:	09 d8                	or     %ebx,%eax
  803341:	f7 74 24 08          	divl   0x8(%esp)
  803345:	89 d1                	mov    %edx,%ecx
  803347:	89 f3                	mov    %esi,%ebx
  803349:	f7 64 24 0c          	mull   0xc(%esp)
  80334d:	89 c6                	mov    %eax,%esi
  80334f:	89 d7                	mov    %edx,%edi
  803351:	39 d1                	cmp    %edx,%ecx
  803353:	72 06                	jb     80335b <__umoddi3+0xfb>
  803355:	75 10                	jne    803367 <__umoddi3+0x107>
  803357:	39 c3                	cmp    %eax,%ebx
  803359:	73 0c                	jae    803367 <__umoddi3+0x107>
  80335b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80335f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  803363:	89 d7                	mov    %edx,%edi
  803365:	89 c6                	mov    %eax,%esi
  803367:	89 ca                	mov    %ecx,%edx
  803369:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80336e:	29 f3                	sub    %esi,%ebx
  803370:	19 fa                	sbb    %edi,%edx
  803372:	89 d0                	mov    %edx,%eax
  803374:	d3 e0                	shl    %cl,%eax
  803376:	89 e9                	mov    %ebp,%ecx
  803378:	d3 eb                	shr    %cl,%ebx
  80337a:	d3 ea                	shr    %cl,%edx
  80337c:	09 d8                	or     %ebx,%eax
  80337e:	83 c4 1c             	add    $0x1c,%esp
  803381:	5b                   	pop    %ebx
  803382:	5e                   	pop    %esi
  803383:	5f                   	pop    %edi
  803384:	5d                   	pop    %ebp
  803385:	c3                   	ret    
  803386:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80338d:	8d 76 00             	lea    0x0(%esi),%esi
  803390:	89 da                	mov    %ebx,%edx
  803392:	29 fe                	sub    %edi,%esi
  803394:	19 c2                	sbb    %eax,%edx
  803396:	89 f1                	mov    %esi,%ecx
  803398:	89 c8                	mov    %ecx,%eax
  80339a:	e9 4b ff ff ff       	jmp    8032ea <__umoddi3+0x8a>
