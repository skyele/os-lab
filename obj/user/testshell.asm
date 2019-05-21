
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
  80004a:	e8 41 1c 00 00       	call   801c90 <seek>
	seek(kfd, off);
  80004f:	83 c4 08             	add    $0x8,%esp
  800052:	53                   	push   %ebx
  800053:	57                   	push   %edi
  800054:	e8 37 1c 00 00       	call   801c90 <seek>

	cprintf("shell produced incorrect output.\n");
  800059:	c7 04 24 40 2d 80 00 	movl   $0x802d40,(%esp)
  800060:	e8 be 05 00 00       	call   800623 <cprintf>
	cprintf("expected:\n===\n");
  800065:	c7 04 24 ab 2d 80 00 	movl   $0x802dab,(%esp)
  80006c:	e8 b2 05 00 00       	call   800623 <cprintf>
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800071:	83 c4 10             	add    $0x10,%esp
  800074:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  800077:	83 ec 04             	sub    $0x4,%esp
  80007a:	6a 63                	push   $0x63
  80007c:	53                   	push   %ebx
  80007d:	57                   	push   %edi
  80007e:	e8 bf 1a 00 00       	call   801b42 <read>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	85 c0                	test   %eax,%eax
  800088:	7e 0f                	jle    800099 <wrong+0x66>
		sys_cputs(buf, n);
  80008a:	83 ec 08             	sub    $0x8,%esp
  80008d:	50                   	push   %eax
  80008e:	53                   	push   %ebx
  80008f:	e8 24 10 00 00       	call   8010b8 <sys_cputs>
  800094:	83 c4 10             	add    $0x10,%esp
  800097:	eb de                	jmp    800077 <wrong+0x44>
	cprintf("===\ngot:\n===\n");
  800099:	83 ec 0c             	sub    $0xc,%esp
  80009c:	68 ba 2d 80 00       	push   $0x802dba
  8000a1:	e8 7d 05 00 00       	call   800623 <cprintf>
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000a6:	83 c4 10             	add    $0x10,%esp
  8000a9:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  8000ac:	eb 0d                	jmp    8000bb <wrong+0x88>
		sys_cputs(buf, n);
  8000ae:	83 ec 08             	sub    $0x8,%esp
  8000b1:	50                   	push   %eax
  8000b2:	53                   	push   %ebx
  8000b3:	e8 00 10 00 00       	call   8010b8 <sys_cputs>
  8000b8:	83 c4 10             	add    $0x10,%esp
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000bb:	83 ec 04             	sub    $0x4,%esp
  8000be:	6a 63                	push   $0x63
  8000c0:	53                   	push   %ebx
  8000c1:	56                   	push   %esi
  8000c2:	e8 7b 1a 00 00       	call   801b42 <read>
  8000c7:	83 c4 10             	add    $0x10,%esp
  8000ca:	85 c0                	test   %eax,%eax
  8000cc:	7f e0                	jg     8000ae <wrong+0x7b>
	cprintf("===\n");
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	68 b5 2d 80 00       	push   $0x802db5
  8000d6:	e8 48 05 00 00       	call   800623 <cprintf>
	exit();
  8000db:	e8 3b 04 00 00       	call   80051b <exit>
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
  8000f6:	e8 09 19 00 00       	call   801a04 <close>
	close(1);
  8000fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800102:	e8 fd 18 00 00       	call   801a04 <close>
	opencons();
  800107:	e8 28 03 00 00       	call   800434 <opencons>
	opencons();
  80010c:	e8 23 03 00 00       	call   800434 <opencons>
	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  800111:	83 c4 08             	add    $0x8,%esp
  800114:	6a 00                	push   $0x0
  800116:	68 c8 2d 80 00       	push   $0x802dc8
  80011b:	e8 59 1e 00 00       	call   801f79 <open>
  800120:	89 c3                	mov    %eax,%ebx
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	85 c0                	test   %eax,%eax
  800127:	0f 88 e7 00 00 00    	js     800214 <umain+0x129>
	if ((wfd = pipe(pfds)) < 0)
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800133:	50                   	push   %eax
  800134:	e8 15 26 00 00       	call   80274e <pipe>
  800139:	83 c4 10             	add    $0x10,%esp
  80013c:	85 c0                	test   %eax,%eax
  80013e:	0f 88 e2 00 00 00    	js     800226 <umain+0x13b>
	wfd = pfds[1];
  800144:	8b 75 e0             	mov    -0x20(%ebp),%esi
	cprintf("running sh -x < testshell.sh | cat\n");
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	68 64 2d 80 00       	push   $0x802d64
  80014f:	e8 cf 04 00 00       	call   800623 <cprintf>
	if ((r = fork()) < 0)
  800154:	e8 59 14 00 00       	call   8015b2 <fork>
  800159:	83 c4 10             	add    $0x10,%esp
  80015c:	85 c0                	test   %eax,%eax
  80015e:	0f 88 d4 00 00 00    	js     800238 <umain+0x14d>
	if (r == 0) {
  800164:	75 6f                	jne    8001d5 <umain+0xea>
		dup(rfd, 0);
  800166:	83 ec 08             	sub    $0x8,%esp
  800169:	6a 00                	push   $0x0
  80016b:	53                   	push   %ebx
  80016c:	e8 e5 18 00 00       	call   801a56 <dup>
		dup(wfd, 1);
  800171:	83 c4 08             	add    $0x8,%esp
  800174:	6a 01                	push   $0x1
  800176:	56                   	push   %esi
  800177:	e8 da 18 00 00       	call   801a56 <dup>
		close(rfd);
  80017c:	89 1c 24             	mov    %ebx,(%esp)
  80017f:	e8 80 18 00 00       	call   801a04 <close>
		close(wfd);
  800184:	89 34 24             	mov    %esi,(%esp)
  800187:	e8 78 18 00 00       	call   801a04 <close>
		if ((r = spawnl("/sh", "sh", "-x", 0)) < 0)
  80018c:	6a 00                	push   $0x0
  80018e:	68 0e 2e 80 00       	push   $0x802e0e
  800193:	68 d2 2d 80 00       	push   $0x802dd2
  800198:	68 11 2e 80 00       	push   $0x802e11
  80019d:	e8 5e 23 00 00       	call   802500 <spawnl>
  8001a2:	89 c7                	mov    %eax,%edi
  8001a4:	83 c4 20             	add    $0x20,%esp
  8001a7:	85 c0                	test   %eax,%eax
  8001a9:	0f 88 9b 00 00 00    	js     80024a <umain+0x15f>
		close(0);
  8001af:	83 ec 0c             	sub    $0xc,%esp
  8001b2:	6a 00                	push   $0x0
  8001b4:	e8 4b 18 00 00       	call   801a04 <close>
		close(1);
  8001b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001c0:	e8 3f 18 00 00       	call   801a04 <close>
		wait(r);
  8001c5:	89 3c 24             	mov    %edi,(%esp)
  8001c8:	e8 fe 26 00 00       	call   8028cb <wait>
		exit();
  8001cd:	e8 49 03 00 00       	call   80051b <exit>
  8001d2:	83 c4 10             	add    $0x10,%esp
	close(rfd);
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	53                   	push   %ebx
  8001d9:	e8 26 18 00 00       	call   801a04 <close>
	close(wfd);
  8001de:	89 34 24             	mov    %esi,(%esp)
  8001e1:	e8 1e 18 00 00       	call   801a04 <close>
	rfd = pfds[0];
  8001e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001e9:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8001ec:	83 c4 08             	add    $0x8,%esp
  8001ef:	6a 00                	push   $0x0
  8001f1:	68 1f 2e 80 00       	push   $0x802e1f
  8001f6:	e8 7e 1d 00 00       	call   801f79 <open>
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
  800215:	68 d5 2d 80 00       	push   $0x802dd5
  80021a:	6a 13                	push   $0x13
  80021c:	68 eb 2d 80 00       	push   $0x802deb
  800221:	e8 07 03 00 00       	call   80052d <_panic>
		panic("pipe: %e", wfd);
  800226:	50                   	push   %eax
  800227:	68 fc 2d 80 00       	push   $0x802dfc
  80022c:	6a 15                	push   $0x15
  80022e:	68 eb 2d 80 00       	push   $0x802deb
  800233:	e8 f5 02 00 00       	call   80052d <_panic>
		panic("fork: %e", r);
  800238:	50                   	push   %eax
  800239:	68 05 2e 80 00       	push   $0x802e05
  80023e:	6a 1a                	push   $0x1a
  800240:	68 eb 2d 80 00       	push   $0x802deb
  800245:	e8 e3 02 00 00       	call   80052d <_panic>
			panic("spawn: %e", r);
  80024a:	50                   	push   %eax
  80024b:	68 15 2e 80 00       	push   $0x802e15
  800250:	6a 21                	push   $0x21
  800252:	68 eb 2d 80 00       	push   $0x802deb
  800257:	e8 d1 02 00 00       	call   80052d <_panic>
		panic("open testshell.key for reading: %e", kfd);
  80025c:	50                   	push   %eax
  80025d:	68 88 2d 80 00       	push   $0x802d88
  800262:	6a 2c                	push   $0x2c
  800264:	68 eb 2d 80 00       	push   $0x802deb
  800269:	e8 bf 02 00 00       	call   80052d <_panic>
			panic("reading testshell.out: %e", n1);
  80026e:	53                   	push   %ebx
  80026f:	68 2d 2e 80 00       	push   $0x802e2d
  800274:	6a 33                	push   $0x33
  800276:	68 eb 2d 80 00       	push   $0x802deb
  80027b:	e8 ad 02 00 00       	call   80052d <_panic>
			panic("reading testshell.key: %e", n2);
  800280:	50                   	push   %eax
  800281:	68 47 2e 80 00       	push   $0x802e47
  800286:	6a 35                	push   $0x35
  800288:	68 eb 2d 80 00       	push   $0x802deb
  80028d:	e8 9b 02 00 00       	call   80052d <_panic>
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
  8002ba:	e8 83 18 00 00       	call   801b42 <read>
  8002bf:	89 c3                	mov    %eax,%ebx
		n2 = read(kfd, &c2, 1);
  8002c1:	83 c4 0c             	add    $0xc,%esp
  8002c4:	6a 01                	push   $0x1
  8002c6:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  8002c9:	50                   	push   %eax
  8002ca:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002cd:	e8 70 18 00 00       	call   801b42 <read>
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
  8002fb:	68 61 2e 80 00       	push   $0x802e61
  800300:	e8 1e 03 00 00       	call   800623 <cprintf>
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
  80031d:	68 76 2e 80 00       	push   $0x802e76
  800322:	ff 75 0c             	pushl  0xc(%ebp)
  800325:	e8 58 0a 00 00       	call   800d82 <strcpy>
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
  800368:	e8 a3 0b 00 00       	call   800f10 <memmove>
		sys_cputs(buf, m);
  80036d:	83 c4 08             	add    $0x8,%esp
  800370:	53                   	push   %ebx
  800371:	57                   	push   %edi
  800372:	e8 41 0d 00 00       	call   8010b8 <sys_cputs>
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
  800399:	e8 38 0d 00 00       	call   8010d6 <sys_cgetc>
  80039e:	85 c0                	test   %eax,%eax
  8003a0:	75 07                	jne    8003a9 <devcons_read+0x21>
		sys_yield();
  8003a2:	e8 ae 0d 00 00       	call   801155 <sys_yield>
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
  8003d5:	e8 de 0c 00 00       	call   8010b8 <sys_cputs>
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
  8003ed:	e8 50 17 00 00       	call   801b42 <read>
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
  800415:	e8 bd 14 00 00       	call   8018d7 <fd_lookup>
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
  80043e:	e8 42 14 00 00       	call   801885 <fd_alloc>
  800443:	83 c4 10             	add    $0x10,%esp
  800446:	85 c0                	test   %eax,%eax
  800448:	78 3a                	js     800484 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80044a:	83 ec 04             	sub    $0x4,%esp
  80044d:	68 07 04 00 00       	push   $0x407
  800452:	ff 75 f4             	pushl  -0xc(%ebp)
  800455:	6a 00                	push   $0x0
  800457:	e8 18 0d 00 00       	call   801174 <sys_page_alloc>
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
  80047c:	e8 dd 13 00 00       	call   80185e <fd2num>
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
  80048f:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  800496:	00 00 00 
	envid_t find = sys_getenvid();
  800499:	e8 98 0c 00 00       	call   801136 <sys_getenvid>
  80049e:	8b 1d 04 50 80 00    	mov    0x805004,%ebx
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
  8004e7:	89 1d 04 50 80 00    	mov    %ebx,0x805004
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

	// call user main routine
	umain(argc, argv);
  8004fd:	83 ec 08             	sub    $0x8,%esp
  800500:	ff 75 0c             	pushl  0xc(%ebp)
  800503:	ff 75 08             	pushl  0x8(%ebp)
  800506:	e8 e0 fb ff ff       	call   8000eb <umain>

	// exit gracefully
	exit();
  80050b:	e8 0b 00 00 00       	call   80051b <exit>
}
  800510:	83 c4 10             	add    $0x10,%esp
  800513:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800516:	5b                   	pop    %ebx
  800517:	5e                   	pop    %esi
  800518:	5f                   	pop    %edi
  800519:	5d                   	pop    %ebp
  80051a:	c3                   	ret    

0080051b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80051b:	55                   	push   %ebp
  80051c:	89 e5                	mov    %esp,%ebp
  80051e:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800521:	6a 00                	push   $0x0
  800523:	e8 cd 0b 00 00       	call   8010f5 <sys_env_destroy>
}
  800528:	83 c4 10             	add    $0x10,%esp
  80052b:	c9                   	leave  
  80052c:	c3                   	ret    

0080052d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80052d:	55                   	push   %ebp
  80052e:	89 e5                	mov    %esp,%ebp
  800530:	56                   	push   %esi
  800531:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800532:	a1 04 50 80 00       	mov    0x805004,%eax
  800537:	8b 40 48             	mov    0x48(%eax),%eax
  80053a:	83 ec 04             	sub    $0x4,%esp
  80053d:	68 bc 2e 80 00       	push   $0x802ebc
  800542:	50                   	push   %eax
  800543:	68 8c 2e 80 00       	push   $0x802e8c
  800548:	e8 d6 00 00 00       	call   800623 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80054d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800550:	8b 35 1c 40 80 00    	mov    0x80401c,%esi
  800556:	e8 db 0b 00 00       	call   801136 <sys_getenvid>
  80055b:	83 c4 04             	add    $0x4,%esp
  80055e:	ff 75 0c             	pushl  0xc(%ebp)
  800561:	ff 75 08             	pushl  0x8(%ebp)
  800564:	56                   	push   %esi
  800565:	50                   	push   %eax
  800566:	68 98 2e 80 00       	push   $0x802e98
  80056b:	e8 b3 00 00 00       	call   800623 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800570:	83 c4 18             	add    $0x18,%esp
  800573:	53                   	push   %ebx
  800574:	ff 75 10             	pushl  0x10(%ebp)
  800577:	e8 56 00 00 00       	call   8005d2 <vcprintf>
	cprintf("\n");
  80057c:	c7 04 24 b9 32 80 00 	movl   $0x8032b9,(%esp)
  800583:	e8 9b 00 00 00       	call   800623 <cprintf>
  800588:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80058b:	cc                   	int3   
  80058c:	eb fd                	jmp    80058b <_panic+0x5e>

0080058e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80058e:	55                   	push   %ebp
  80058f:	89 e5                	mov    %esp,%ebp
  800591:	53                   	push   %ebx
  800592:	83 ec 04             	sub    $0x4,%esp
  800595:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800598:	8b 13                	mov    (%ebx),%edx
  80059a:	8d 42 01             	lea    0x1(%edx),%eax
  80059d:	89 03                	mov    %eax,(%ebx)
  80059f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8005a2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8005a6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005ab:	74 09                	je     8005b6 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8005ad:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8005b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005b4:	c9                   	leave  
  8005b5:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8005b6:	83 ec 08             	sub    $0x8,%esp
  8005b9:	68 ff 00 00 00       	push   $0xff
  8005be:	8d 43 08             	lea    0x8(%ebx),%eax
  8005c1:	50                   	push   %eax
  8005c2:	e8 f1 0a 00 00       	call   8010b8 <sys_cputs>
		b->idx = 0;
  8005c7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8005cd:	83 c4 10             	add    $0x10,%esp
  8005d0:	eb db                	jmp    8005ad <putch+0x1f>

008005d2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8005d2:	55                   	push   %ebp
  8005d3:	89 e5                	mov    %esp,%ebp
  8005d5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005db:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005e2:	00 00 00 
	b.cnt = 0;
  8005e5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005ec:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8005ef:	ff 75 0c             	pushl  0xc(%ebp)
  8005f2:	ff 75 08             	pushl  0x8(%ebp)
  8005f5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005fb:	50                   	push   %eax
  8005fc:	68 8e 05 80 00       	push   $0x80058e
  800601:	e8 4a 01 00 00       	call   800750 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800606:	83 c4 08             	add    $0x8,%esp
  800609:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80060f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800615:	50                   	push   %eax
  800616:	e8 9d 0a 00 00       	call   8010b8 <sys_cputs>

	return b.cnt;
}
  80061b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800621:	c9                   	leave  
  800622:	c3                   	ret    

00800623 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800623:	55                   	push   %ebp
  800624:	89 e5                	mov    %esp,%ebp
  800626:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800629:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80062c:	50                   	push   %eax
  80062d:	ff 75 08             	pushl  0x8(%ebp)
  800630:	e8 9d ff ff ff       	call   8005d2 <vcprintf>
	va_end(ap);

	return cnt;
}
  800635:	c9                   	leave  
  800636:	c3                   	ret    

00800637 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800637:	55                   	push   %ebp
  800638:	89 e5                	mov    %esp,%ebp
  80063a:	57                   	push   %edi
  80063b:	56                   	push   %esi
  80063c:	53                   	push   %ebx
  80063d:	83 ec 1c             	sub    $0x1c,%esp
  800640:	89 c6                	mov    %eax,%esi
  800642:	89 d7                	mov    %edx,%edi
  800644:	8b 45 08             	mov    0x8(%ebp),%eax
  800647:	8b 55 0c             	mov    0xc(%ebp),%edx
  80064a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80064d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800650:	8b 45 10             	mov    0x10(%ebp),%eax
  800653:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800656:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80065a:	74 2c                	je     800688 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80065c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800666:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800669:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80066c:	39 c2                	cmp    %eax,%edx
  80066e:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800671:	73 43                	jae    8006b6 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800673:	83 eb 01             	sub    $0x1,%ebx
  800676:	85 db                	test   %ebx,%ebx
  800678:	7e 6c                	jle    8006e6 <printnum+0xaf>
				putch(padc, putdat);
  80067a:	83 ec 08             	sub    $0x8,%esp
  80067d:	57                   	push   %edi
  80067e:	ff 75 18             	pushl  0x18(%ebp)
  800681:	ff d6                	call   *%esi
  800683:	83 c4 10             	add    $0x10,%esp
  800686:	eb eb                	jmp    800673 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800688:	83 ec 0c             	sub    $0xc,%esp
  80068b:	6a 20                	push   $0x20
  80068d:	6a 00                	push   $0x0
  80068f:	50                   	push   %eax
  800690:	ff 75 e4             	pushl  -0x1c(%ebp)
  800693:	ff 75 e0             	pushl  -0x20(%ebp)
  800696:	89 fa                	mov    %edi,%edx
  800698:	89 f0                	mov    %esi,%eax
  80069a:	e8 98 ff ff ff       	call   800637 <printnum>
		while (--width > 0)
  80069f:	83 c4 20             	add    $0x20,%esp
  8006a2:	83 eb 01             	sub    $0x1,%ebx
  8006a5:	85 db                	test   %ebx,%ebx
  8006a7:	7e 65                	jle    80070e <printnum+0xd7>
			putch(padc, putdat);
  8006a9:	83 ec 08             	sub    $0x8,%esp
  8006ac:	57                   	push   %edi
  8006ad:	6a 20                	push   $0x20
  8006af:	ff d6                	call   *%esi
  8006b1:	83 c4 10             	add    $0x10,%esp
  8006b4:	eb ec                	jmp    8006a2 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8006b6:	83 ec 0c             	sub    $0xc,%esp
  8006b9:	ff 75 18             	pushl  0x18(%ebp)
  8006bc:	83 eb 01             	sub    $0x1,%ebx
  8006bf:	53                   	push   %ebx
  8006c0:	50                   	push   %eax
  8006c1:	83 ec 08             	sub    $0x8,%esp
  8006c4:	ff 75 dc             	pushl  -0x24(%ebp)
  8006c7:	ff 75 d8             	pushl  -0x28(%ebp)
  8006ca:	ff 75 e4             	pushl  -0x1c(%ebp)
  8006cd:	ff 75 e0             	pushl  -0x20(%ebp)
  8006d0:	e8 1b 24 00 00       	call   802af0 <__udivdi3>
  8006d5:	83 c4 18             	add    $0x18,%esp
  8006d8:	52                   	push   %edx
  8006d9:	50                   	push   %eax
  8006da:	89 fa                	mov    %edi,%edx
  8006dc:	89 f0                	mov    %esi,%eax
  8006de:	e8 54 ff ff ff       	call   800637 <printnum>
  8006e3:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8006e6:	83 ec 08             	sub    $0x8,%esp
  8006e9:	57                   	push   %edi
  8006ea:	83 ec 04             	sub    $0x4,%esp
  8006ed:	ff 75 dc             	pushl  -0x24(%ebp)
  8006f0:	ff 75 d8             	pushl  -0x28(%ebp)
  8006f3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8006f6:	ff 75 e0             	pushl  -0x20(%ebp)
  8006f9:	e8 02 25 00 00       	call   802c00 <__umoddi3>
  8006fe:	83 c4 14             	add    $0x14,%esp
  800701:	0f be 80 c3 2e 80 00 	movsbl 0x802ec3(%eax),%eax
  800708:	50                   	push   %eax
  800709:	ff d6                	call   *%esi
  80070b:	83 c4 10             	add    $0x10,%esp
	}
}
  80070e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800711:	5b                   	pop    %ebx
  800712:	5e                   	pop    %esi
  800713:	5f                   	pop    %edi
  800714:	5d                   	pop    %ebp
  800715:	c3                   	ret    

00800716 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800716:	55                   	push   %ebp
  800717:	89 e5                	mov    %esp,%ebp
  800719:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80071c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800720:	8b 10                	mov    (%eax),%edx
  800722:	3b 50 04             	cmp    0x4(%eax),%edx
  800725:	73 0a                	jae    800731 <sprintputch+0x1b>
		*b->buf++ = ch;
  800727:	8d 4a 01             	lea    0x1(%edx),%ecx
  80072a:	89 08                	mov    %ecx,(%eax)
  80072c:	8b 45 08             	mov    0x8(%ebp),%eax
  80072f:	88 02                	mov    %al,(%edx)
}
  800731:	5d                   	pop    %ebp
  800732:	c3                   	ret    

00800733 <printfmt>:
{
  800733:	55                   	push   %ebp
  800734:	89 e5                	mov    %esp,%ebp
  800736:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800739:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80073c:	50                   	push   %eax
  80073d:	ff 75 10             	pushl  0x10(%ebp)
  800740:	ff 75 0c             	pushl  0xc(%ebp)
  800743:	ff 75 08             	pushl  0x8(%ebp)
  800746:	e8 05 00 00 00       	call   800750 <vprintfmt>
}
  80074b:	83 c4 10             	add    $0x10,%esp
  80074e:	c9                   	leave  
  80074f:	c3                   	ret    

00800750 <vprintfmt>:
{
  800750:	55                   	push   %ebp
  800751:	89 e5                	mov    %esp,%ebp
  800753:	57                   	push   %edi
  800754:	56                   	push   %esi
  800755:	53                   	push   %ebx
  800756:	83 ec 3c             	sub    $0x3c,%esp
  800759:	8b 75 08             	mov    0x8(%ebp),%esi
  80075c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80075f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800762:	e9 32 04 00 00       	jmp    800b99 <vprintfmt+0x449>
		padc = ' ';
  800767:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80076b:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800772:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800779:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800780:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800787:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80078e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800793:	8d 47 01             	lea    0x1(%edi),%eax
  800796:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800799:	0f b6 17             	movzbl (%edi),%edx
  80079c:	8d 42 dd             	lea    -0x23(%edx),%eax
  80079f:	3c 55                	cmp    $0x55,%al
  8007a1:	0f 87 12 05 00 00    	ja     800cb9 <vprintfmt+0x569>
  8007a7:	0f b6 c0             	movzbl %al,%eax
  8007aa:	ff 24 85 a0 30 80 00 	jmp    *0x8030a0(,%eax,4)
  8007b1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8007b4:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8007b8:	eb d9                	jmp    800793 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8007ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8007bd:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8007c1:	eb d0                	jmp    800793 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8007c3:	0f b6 d2             	movzbl %dl,%edx
  8007c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8007c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ce:	89 75 08             	mov    %esi,0x8(%ebp)
  8007d1:	eb 03                	jmp    8007d6 <vprintfmt+0x86>
  8007d3:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8007d6:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8007d9:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8007dd:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8007e0:	8d 72 d0             	lea    -0x30(%edx),%esi
  8007e3:	83 fe 09             	cmp    $0x9,%esi
  8007e6:	76 eb                	jbe    8007d3 <vprintfmt+0x83>
  8007e8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8007ee:	eb 14                	jmp    800804 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8007f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f3:	8b 00                	mov    (%eax),%eax
  8007f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fb:	8d 40 04             	lea    0x4(%eax),%eax
  8007fe:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800801:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800804:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800808:	79 89                	jns    800793 <vprintfmt+0x43>
				width = precision, precision = -1;
  80080a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80080d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800810:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800817:	e9 77 ff ff ff       	jmp    800793 <vprintfmt+0x43>
  80081c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80081f:	85 c0                	test   %eax,%eax
  800821:	0f 48 c1             	cmovs  %ecx,%eax
  800824:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800827:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80082a:	e9 64 ff ff ff       	jmp    800793 <vprintfmt+0x43>
  80082f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800832:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800839:	e9 55 ff ff ff       	jmp    800793 <vprintfmt+0x43>
			lflag++;
  80083e:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800842:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800845:	e9 49 ff ff ff       	jmp    800793 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80084a:	8b 45 14             	mov    0x14(%ebp),%eax
  80084d:	8d 78 04             	lea    0x4(%eax),%edi
  800850:	83 ec 08             	sub    $0x8,%esp
  800853:	53                   	push   %ebx
  800854:	ff 30                	pushl  (%eax)
  800856:	ff d6                	call   *%esi
			break;
  800858:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80085b:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80085e:	e9 33 03 00 00       	jmp    800b96 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800863:	8b 45 14             	mov    0x14(%ebp),%eax
  800866:	8d 78 04             	lea    0x4(%eax),%edi
  800869:	8b 00                	mov    (%eax),%eax
  80086b:	99                   	cltd   
  80086c:	31 d0                	xor    %edx,%eax
  80086e:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800870:	83 f8 0f             	cmp    $0xf,%eax
  800873:	7f 23                	jg     800898 <vprintfmt+0x148>
  800875:	8b 14 85 00 32 80 00 	mov    0x803200(,%eax,4),%edx
  80087c:	85 d2                	test   %edx,%edx
  80087e:	74 18                	je     800898 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800880:	52                   	push   %edx
  800881:	68 32 34 80 00       	push   $0x803432
  800886:	53                   	push   %ebx
  800887:	56                   	push   %esi
  800888:	e8 a6 fe ff ff       	call   800733 <printfmt>
  80088d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800890:	89 7d 14             	mov    %edi,0x14(%ebp)
  800893:	e9 fe 02 00 00       	jmp    800b96 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800898:	50                   	push   %eax
  800899:	68 db 2e 80 00       	push   $0x802edb
  80089e:	53                   	push   %ebx
  80089f:	56                   	push   %esi
  8008a0:	e8 8e fe ff ff       	call   800733 <printfmt>
  8008a5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8008a8:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8008ab:	e9 e6 02 00 00       	jmp    800b96 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8008b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b3:	83 c0 04             	add    $0x4,%eax
  8008b6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8008b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bc:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8008be:	85 c9                	test   %ecx,%ecx
  8008c0:	b8 d4 2e 80 00       	mov    $0x802ed4,%eax
  8008c5:	0f 45 c1             	cmovne %ecx,%eax
  8008c8:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8008cb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008cf:	7e 06                	jle    8008d7 <vprintfmt+0x187>
  8008d1:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8008d5:	75 0d                	jne    8008e4 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8008da:	89 c7                	mov    %eax,%edi
  8008dc:	03 45 e0             	add    -0x20(%ebp),%eax
  8008df:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008e2:	eb 53                	jmp    800937 <vprintfmt+0x1e7>
  8008e4:	83 ec 08             	sub    $0x8,%esp
  8008e7:	ff 75 d8             	pushl  -0x28(%ebp)
  8008ea:	50                   	push   %eax
  8008eb:	e8 71 04 00 00       	call   800d61 <strnlen>
  8008f0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8008f3:	29 c1                	sub    %eax,%ecx
  8008f5:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8008f8:	83 c4 10             	add    $0x10,%esp
  8008fb:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8008fd:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800901:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800904:	eb 0f                	jmp    800915 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800906:	83 ec 08             	sub    $0x8,%esp
  800909:	53                   	push   %ebx
  80090a:	ff 75 e0             	pushl  -0x20(%ebp)
  80090d:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80090f:	83 ef 01             	sub    $0x1,%edi
  800912:	83 c4 10             	add    $0x10,%esp
  800915:	85 ff                	test   %edi,%edi
  800917:	7f ed                	jg     800906 <vprintfmt+0x1b6>
  800919:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80091c:	85 c9                	test   %ecx,%ecx
  80091e:	b8 00 00 00 00       	mov    $0x0,%eax
  800923:	0f 49 c1             	cmovns %ecx,%eax
  800926:	29 c1                	sub    %eax,%ecx
  800928:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80092b:	eb aa                	jmp    8008d7 <vprintfmt+0x187>
					putch(ch, putdat);
  80092d:	83 ec 08             	sub    $0x8,%esp
  800930:	53                   	push   %ebx
  800931:	52                   	push   %edx
  800932:	ff d6                	call   *%esi
  800934:	83 c4 10             	add    $0x10,%esp
  800937:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80093a:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80093c:	83 c7 01             	add    $0x1,%edi
  80093f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800943:	0f be d0             	movsbl %al,%edx
  800946:	85 d2                	test   %edx,%edx
  800948:	74 4b                	je     800995 <vprintfmt+0x245>
  80094a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80094e:	78 06                	js     800956 <vprintfmt+0x206>
  800950:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800954:	78 1e                	js     800974 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800956:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80095a:	74 d1                	je     80092d <vprintfmt+0x1dd>
  80095c:	0f be c0             	movsbl %al,%eax
  80095f:	83 e8 20             	sub    $0x20,%eax
  800962:	83 f8 5e             	cmp    $0x5e,%eax
  800965:	76 c6                	jbe    80092d <vprintfmt+0x1dd>
					putch('?', putdat);
  800967:	83 ec 08             	sub    $0x8,%esp
  80096a:	53                   	push   %ebx
  80096b:	6a 3f                	push   $0x3f
  80096d:	ff d6                	call   *%esi
  80096f:	83 c4 10             	add    $0x10,%esp
  800972:	eb c3                	jmp    800937 <vprintfmt+0x1e7>
  800974:	89 cf                	mov    %ecx,%edi
  800976:	eb 0e                	jmp    800986 <vprintfmt+0x236>
				putch(' ', putdat);
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	53                   	push   %ebx
  80097c:	6a 20                	push   $0x20
  80097e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800980:	83 ef 01             	sub    $0x1,%edi
  800983:	83 c4 10             	add    $0x10,%esp
  800986:	85 ff                	test   %edi,%edi
  800988:	7f ee                	jg     800978 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80098a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80098d:	89 45 14             	mov    %eax,0x14(%ebp)
  800990:	e9 01 02 00 00       	jmp    800b96 <vprintfmt+0x446>
  800995:	89 cf                	mov    %ecx,%edi
  800997:	eb ed                	jmp    800986 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800999:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80099c:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8009a3:	e9 eb fd ff ff       	jmp    800793 <vprintfmt+0x43>
	if (lflag >= 2)
  8009a8:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8009ac:	7f 21                	jg     8009cf <vprintfmt+0x27f>
	else if (lflag)
  8009ae:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8009b2:	74 68                	je     800a1c <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8009b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b7:	8b 00                	mov    (%eax),%eax
  8009b9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8009bc:	89 c1                	mov    %eax,%ecx
  8009be:	c1 f9 1f             	sar    $0x1f,%ecx
  8009c1:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8009c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c7:	8d 40 04             	lea    0x4(%eax),%eax
  8009ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8009cd:	eb 17                	jmp    8009e6 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8009cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d2:	8b 50 04             	mov    0x4(%eax),%edx
  8009d5:	8b 00                	mov    (%eax),%eax
  8009d7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8009da:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8009dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e0:	8d 40 08             	lea    0x8(%eax),%eax
  8009e3:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8009e6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8009e9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8009ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009ef:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8009f2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8009f6:	78 3f                	js     800a37 <vprintfmt+0x2e7>
			base = 10;
  8009f8:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8009fd:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800a01:	0f 84 71 01 00 00    	je     800b78 <vprintfmt+0x428>
				putch('+', putdat);
  800a07:	83 ec 08             	sub    $0x8,%esp
  800a0a:	53                   	push   %ebx
  800a0b:	6a 2b                	push   $0x2b
  800a0d:	ff d6                	call   *%esi
  800a0f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800a12:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a17:	e9 5c 01 00 00       	jmp    800b78 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800a1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1f:	8b 00                	mov    (%eax),%eax
  800a21:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800a24:	89 c1                	mov    %eax,%ecx
  800a26:	c1 f9 1f             	sar    $0x1f,%ecx
  800a29:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800a2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2f:	8d 40 04             	lea    0x4(%eax),%eax
  800a32:	89 45 14             	mov    %eax,0x14(%ebp)
  800a35:	eb af                	jmp    8009e6 <vprintfmt+0x296>
				putch('-', putdat);
  800a37:	83 ec 08             	sub    $0x8,%esp
  800a3a:	53                   	push   %ebx
  800a3b:	6a 2d                	push   $0x2d
  800a3d:	ff d6                	call   *%esi
				num = -(long long) num;
  800a3f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a42:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800a45:	f7 d8                	neg    %eax
  800a47:	83 d2 00             	adc    $0x0,%edx
  800a4a:	f7 da                	neg    %edx
  800a4c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a4f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a52:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800a55:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a5a:	e9 19 01 00 00       	jmp    800b78 <vprintfmt+0x428>
	if (lflag >= 2)
  800a5f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800a63:	7f 29                	jg     800a8e <vprintfmt+0x33e>
	else if (lflag)
  800a65:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a69:	74 44                	je     800aaf <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800a6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6e:	8b 00                	mov    (%eax),%eax
  800a70:	ba 00 00 00 00       	mov    $0x0,%edx
  800a75:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a78:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7e:	8d 40 04             	lea    0x4(%eax),%eax
  800a81:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a84:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a89:	e9 ea 00 00 00       	jmp    800b78 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800a8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a91:	8b 50 04             	mov    0x4(%eax),%edx
  800a94:	8b 00                	mov    (%eax),%eax
  800a96:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a99:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a9c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9f:	8d 40 08             	lea    0x8(%eax),%eax
  800aa2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800aa5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800aaa:	e9 c9 00 00 00       	jmp    800b78 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800aaf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab2:	8b 00                	mov    (%eax),%eax
  800ab4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800abc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800abf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac2:	8d 40 04             	lea    0x4(%eax),%eax
  800ac5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800ac8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800acd:	e9 a6 00 00 00       	jmp    800b78 <vprintfmt+0x428>
			putch('0', putdat);
  800ad2:	83 ec 08             	sub    $0x8,%esp
  800ad5:	53                   	push   %ebx
  800ad6:	6a 30                	push   $0x30
  800ad8:	ff d6                	call   *%esi
	if (lflag >= 2)
  800ada:	83 c4 10             	add    $0x10,%esp
  800add:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800ae1:	7f 26                	jg     800b09 <vprintfmt+0x3b9>
	else if (lflag)
  800ae3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800ae7:	74 3e                	je     800b27 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800ae9:	8b 45 14             	mov    0x14(%ebp),%eax
  800aec:	8b 00                	mov    (%eax),%eax
  800aee:	ba 00 00 00 00       	mov    $0x0,%edx
  800af3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800af6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800af9:	8b 45 14             	mov    0x14(%ebp),%eax
  800afc:	8d 40 04             	lea    0x4(%eax),%eax
  800aff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b02:	b8 08 00 00 00       	mov    $0x8,%eax
  800b07:	eb 6f                	jmp    800b78 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800b09:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0c:	8b 50 04             	mov    0x4(%eax),%edx
  800b0f:	8b 00                	mov    (%eax),%eax
  800b11:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b14:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b17:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1a:	8d 40 08             	lea    0x8(%eax),%eax
  800b1d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b20:	b8 08 00 00 00       	mov    $0x8,%eax
  800b25:	eb 51                	jmp    800b78 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800b27:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2a:	8b 00                	mov    (%eax),%eax
  800b2c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b31:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b34:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b37:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3a:	8d 40 04             	lea    0x4(%eax),%eax
  800b3d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b40:	b8 08 00 00 00       	mov    $0x8,%eax
  800b45:	eb 31                	jmp    800b78 <vprintfmt+0x428>
			putch('0', putdat);
  800b47:	83 ec 08             	sub    $0x8,%esp
  800b4a:	53                   	push   %ebx
  800b4b:	6a 30                	push   $0x30
  800b4d:	ff d6                	call   *%esi
			putch('x', putdat);
  800b4f:	83 c4 08             	add    $0x8,%esp
  800b52:	53                   	push   %ebx
  800b53:	6a 78                	push   $0x78
  800b55:	ff d6                	call   *%esi
			num = (unsigned long long)
  800b57:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5a:	8b 00                	mov    (%eax),%eax
  800b5c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b61:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b64:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800b67:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800b6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6d:	8d 40 04             	lea    0x4(%eax),%eax
  800b70:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b73:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800b78:	83 ec 0c             	sub    $0xc,%esp
  800b7b:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800b7f:	52                   	push   %edx
  800b80:	ff 75 e0             	pushl  -0x20(%ebp)
  800b83:	50                   	push   %eax
  800b84:	ff 75 dc             	pushl  -0x24(%ebp)
  800b87:	ff 75 d8             	pushl  -0x28(%ebp)
  800b8a:	89 da                	mov    %ebx,%edx
  800b8c:	89 f0                	mov    %esi,%eax
  800b8e:	e8 a4 fa ff ff       	call   800637 <printnum>
			break;
  800b93:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800b96:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b99:	83 c7 01             	add    $0x1,%edi
  800b9c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800ba0:	83 f8 25             	cmp    $0x25,%eax
  800ba3:	0f 84 be fb ff ff    	je     800767 <vprintfmt+0x17>
			if (ch == '\0')
  800ba9:	85 c0                	test   %eax,%eax
  800bab:	0f 84 28 01 00 00    	je     800cd9 <vprintfmt+0x589>
			putch(ch, putdat);
  800bb1:	83 ec 08             	sub    $0x8,%esp
  800bb4:	53                   	push   %ebx
  800bb5:	50                   	push   %eax
  800bb6:	ff d6                	call   *%esi
  800bb8:	83 c4 10             	add    $0x10,%esp
  800bbb:	eb dc                	jmp    800b99 <vprintfmt+0x449>
	if (lflag >= 2)
  800bbd:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800bc1:	7f 26                	jg     800be9 <vprintfmt+0x499>
	else if (lflag)
  800bc3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800bc7:	74 41                	je     800c0a <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800bc9:	8b 45 14             	mov    0x14(%ebp),%eax
  800bcc:	8b 00                	mov    (%eax),%eax
  800bce:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bd6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800bd9:	8b 45 14             	mov    0x14(%ebp),%eax
  800bdc:	8d 40 04             	lea    0x4(%eax),%eax
  800bdf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800be2:	b8 10 00 00 00       	mov    $0x10,%eax
  800be7:	eb 8f                	jmp    800b78 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800be9:	8b 45 14             	mov    0x14(%ebp),%eax
  800bec:	8b 50 04             	mov    0x4(%eax),%edx
  800bef:	8b 00                	mov    (%eax),%eax
  800bf1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bf4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800bf7:	8b 45 14             	mov    0x14(%ebp),%eax
  800bfa:	8d 40 08             	lea    0x8(%eax),%eax
  800bfd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c00:	b8 10 00 00 00       	mov    $0x10,%eax
  800c05:	e9 6e ff ff ff       	jmp    800b78 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800c0a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c0d:	8b 00                	mov    (%eax),%eax
  800c0f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c14:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c17:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c1d:	8d 40 04             	lea    0x4(%eax),%eax
  800c20:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c23:	b8 10 00 00 00       	mov    $0x10,%eax
  800c28:	e9 4b ff ff ff       	jmp    800b78 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800c2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c30:	83 c0 04             	add    $0x4,%eax
  800c33:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c36:	8b 45 14             	mov    0x14(%ebp),%eax
  800c39:	8b 00                	mov    (%eax),%eax
  800c3b:	85 c0                	test   %eax,%eax
  800c3d:	74 14                	je     800c53 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800c3f:	8b 13                	mov    (%ebx),%edx
  800c41:	83 fa 7f             	cmp    $0x7f,%edx
  800c44:	7f 37                	jg     800c7d <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800c46:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800c48:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c4b:	89 45 14             	mov    %eax,0x14(%ebp)
  800c4e:	e9 43 ff ff ff       	jmp    800b96 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800c53:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c58:	bf f9 2f 80 00       	mov    $0x802ff9,%edi
							putch(ch, putdat);
  800c5d:	83 ec 08             	sub    $0x8,%esp
  800c60:	53                   	push   %ebx
  800c61:	50                   	push   %eax
  800c62:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800c64:	83 c7 01             	add    $0x1,%edi
  800c67:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800c6b:	83 c4 10             	add    $0x10,%esp
  800c6e:	85 c0                	test   %eax,%eax
  800c70:	75 eb                	jne    800c5d <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800c72:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c75:	89 45 14             	mov    %eax,0x14(%ebp)
  800c78:	e9 19 ff ff ff       	jmp    800b96 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800c7d:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800c7f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c84:	bf 31 30 80 00       	mov    $0x803031,%edi
							putch(ch, putdat);
  800c89:	83 ec 08             	sub    $0x8,%esp
  800c8c:	53                   	push   %ebx
  800c8d:	50                   	push   %eax
  800c8e:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800c90:	83 c7 01             	add    $0x1,%edi
  800c93:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800c97:	83 c4 10             	add    $0x10,%esp
  800c9a:	85 c0                	test   %eax,%eax
  800c9c:	75 eb                	jne    800c89 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800c9e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ca1:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca4:	e9 ed fe ff ff       	jmp    800b96 <vprintfmt+0x446>
			putch(ch, putdat);
  800ca9:	83 ec 08             	sub    $0x8,%esp
  800cac:	53                   	push   %ebx
  800cad:	6a 25                	push   $0x25
  800caf:	ff d6                	call   *%esi
			break;
  800cb1:	83 c4 10             	add    $0x10,%esp
  800cb4:	e9 dd fe ff ff       	jmp    800b96 <vprintfmt+0x446>
			putch('%', putdat);
  800cb9:	83 ec 08             	sub    $0x8,%esp
  800cbc:	53                   	push   %ebx
  800cbd:	6a 25                	push   $0x25
  800cbf:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cc1:	83 c4 10             	add    $0x10,%esp
  800cc4:	89 f8                	mov    %edi,%eax
  800cc6:	eb 03                	jmp    800ccb <vprintfmt+0x57b>
  800cc8:	83 e8 01             	sub    $0x1,%eax
  800ccb:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800ccf:	75 f7                	jne    800cc8 <vprintfmt+0x578>
  800cd1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cd4:	e9 bd fe ff ff       	jmp    800b96 <vprintfmt+0x446>
}
  800cd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cdc:	5b                   	pop    %ebx
  800cdd:	5e                   	pop    %esi
  800cde:	5f                   	pop    %edi
  800cdf:	5d                   	pop    %ebp
  800ce0:	c3                   	ret    

00800ce1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ce1:	55                   	push   %ebp
  800ce2:	89 e5                	mov    %esp,%ebp
  800ce4:	83 ec 18             	sub    $0x18,%esp
  800ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cea:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ced:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cf0:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800cf4:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800cf7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cfe:	85 c0                	test   %eax,%eax
  800d00:	74 26                	je     800d28 <vsnprintf+0x47>
  800d02:	85 d2                	test   %edx,%edx
  800d04:	7e 22                	jle    800d28 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d06:	ff 75 14             	pushl  0x14(%ebp)
  800d09:	ff 75 10             	pushl  0x10(%ebp)
  800d0c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d0f:	50                   	push   %eax
  800d10:	68 16 07 80 00       	push   $0x800716
  800d15:	e8 36 fa ff ff       	call   800750 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800d1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d1d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d23:	83 c4 10             	add    $0x10,%esp
}
  800d26:	c9                   	leave  
  800d27:	c3                   	ret    
		return -E_INVAL;
  800d28:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d2d:	eb f7                	jmp    800d26 <vsnprintf+0x45>

00800d2f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d2f:	55                   	push   %ebp
  800d30:	89 e5                	mov    %esp,%ebp
  800d32:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d35:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800d38:	50                   	push   %eax
  800d39:	ff 75 10             	pushl  0x10(%ebp)
  800d3c:	ff 75 0c             	pushl  0xc(%ebp)
  800d3f:	ff 75 08             	pushl  0x8(%ebp)
  800d42:	e8 9a ff ff ff       	call   800ce1 <vsnprintf>
	va_end(ap);

	return rc;
}
  800d47:	c9                   	leave  
  800d48:	c3                   	ret    

00800d49 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800d4f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d54:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800d58:	74 05                	je     800d5f <strlen+0x16>
		n++;
  800d5a:	83 c0 01             	add    $0x1,%eax
  800d5d:	eb f5                	jmp    800d54 <strlen+0xb>
	return n;
}
  800d5f:	5d                   	pop    %ebp
  800d60:	c3                   	ret    

00800d61 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800d61:	55                   	push   %ebp
  800d62:	89 e5                	mov    %esp,%ebp
  800d64:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d67:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d6a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d6f:	39 c2                	cmp    %eax,%edx
  800d71:	74 0d                	je     800d80 <strnlen+0x1f>
  800d73:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800d77:	74 05                	je     800d7e <strnlen+0x1d>
		n++;
  800d79:	83 c2 01             	add    $0x1,%edx
  800d7c:	eb f1                	jmp    800d6f <strnlen+0xe>
  800d7e:	89 d0                	mov    %edx,%eax
	return n;
}
  800d80:	5d                   	pop    %ebp
  800d81:	c3                   	ret    

00800d82 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	53                   	push   %ebx
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800d8c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d91:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800d95:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800d98:	83 c2 01             	add    $0x1,%edx
  800d9b:	84 c9                	test   %cl,%cl
  800d9d:	75 f2                	jne    800d91 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800d9f:	5b                   	pop    %ebx
  800da0:	5d                   	pop    %ebp
  800da1:	c3                   	ret    

00800da2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800da2:	55                   	push   %ebp
  800da3:	89 e5                	mov    %esp,%ebp
  800da5:	53                   	push   %ebx
  800da6:	83 ec 10             	sub    $0x10,%esp
  800da9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800dac:	53                   	push   %ebx
  800dad:	e8 97 ff ff ff       	call   800d49 <strlen>
  800db2:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800db5:	ff 75 0c             	pushl  0xc(%ebp)
  800db8:	01 d8                	add    %ebx,%eax
  800dba:	50                   	push   %eax
  800dbb:	e8 c2 ff ff ff       	call   800d82 <strcpy>
	return dst;
}
  800dc0:	89 d8                	mov    %ebx,%eax
  800dc2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800dc5:	c9                   	leave  
  800dc6:	c3                   	ret    

00800dc7 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800dc7:	55                   	push   %ebp
  800dc8:	89 e5                	mov    %esp,%ebp
  800dca:	56                   	push   %esi
  800dcb:	53                   	push   %ebx
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd2:	89 c6                	mov    %eax,%esi
  800dd4:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dd7:	89 c2                	mov    %eax,%edx
  800dd9:	39 f2                	cmp    %esi,%edx
  800ddb:	74 11                	je     800dee <strncpy+0x27>
		*dst++ = *src;
  800ddd:	83 c2 01             	add    $0x1,%edx
  800de0:	0f b6 19             	movzbl (%ecx),%ebx
  800de3:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800de6:	80 fb 01             	cmp    $0x1,%bl
  800de9:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800dec:	eb eb                	jmp    800dd9 <strncpy+0x12>
	}
	return ret;
}
  800dee:	5b                   	pop    %ebx
  800def:	5e                   	pop    %esi
  800df0:	5d                   	pop    %ebp
  800df1:	c3                   	ret    

00800df2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800df2:	55                   	push   %ebp
  800df3:	89 e5                	mov    %esp,%ebp
  800df5:	56                   	push   %esi
  800df6:	53                   	push   %ebx
  800df7:	8b 75 08             	mov    0x8(%ebp),%esi
  800dfa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dfd:	8b 55 10             	mov    0x10(%ebp),%edx
  800e00:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800e02:	85 d2                	test   %edx,%edx
  800e04:	74 21                	je     800e27 <strlcpy+0x35>
  800e06:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800e0a:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800e0c:	39 c2                	cmp    %eax,%edx
  800e0e:	74 14                	je     800e24 <strlcpy+0x32>
  800e10:	0f b6 19             	movzbl (%ecx),%ebx
  800e13:	84 db                	test   %bl,%bl
  800e15:	74 0b                	je     800e22 <strlcpy+0x30>
			*dst++ = *src++;
  800e17:	83 c1 01             	add    $0x1,%ecx
  800e1a:	83 c2 01             	add    $0x1,%edx
  800e1d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800e20:	eb ea                	jmp    800e0c <strlcpy+0x1a>
  800e22:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800e24:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e27:	29 f0                	sub    %esi,%eax
}
  800e29:	5b                   	pop    %ebx
  800e2a:	5e                   	pop    %esi
  800e2b:	5d                   	pop    %ebp
  800e2c:	c3                   	ret    

00800e2d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
  800e30:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e33:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800e36:	0f b6 01             	movzbl (%ecx),%eax
  800e39:	84 c0                	test   %al,%al
  800e3b:	74 0c                	je     800e49 <strcmp+0x1c>
  800e3d:	3a 02                	cmp    (%edx),%al
  800e3f:	75 08                	jne    800e49 <strcmp+0x1c>
		p++, q++;
  800e41:	83 c1 01             	add    $0x1,%ecx
  800e44:	83 c2 01             	add    $0x1,%edx
  800e47:	eb ed                	jmp    800e36 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e49:	0f b6 c0             	movzbl %al,%eax
  800e4c:	0f b6 12             	movzbl (%edx),%edx
  800e4f:	29 d0                	sub    %edx,%eax
}
  800e51:	5d                   	pop    %ebp
  800e52:	c3                   	ret    

00800e53 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800e53:	55                   	push   %ebp
  800e54:	89 e5                	mov    %esp,%ebp
  800e56:	53                   	push   %ebx
  800e57:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e5d:	89 c3                	mov    %eax,%ebx
  800e5f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800e62:	eb 06                	jmp    800e6a <strncmp+0x17>
		n--, p++, q++;
  800e64:	83 c0 01             	add    $0x1,%eax
  800e67:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800e6a:	39 d8                	cmp    %ebx,%eax
  800e6c:	74 16                	je     800e84 <strncmp+0x31>
  800e6e:	0f b6 08             	movzbl (%eax),%ecx
  800e71:	84 c9                	test   %cl,%cl
  800e73:	74 04                	je     800e79 <strncmp+0x26>
  800e75:	3a 0a                	cmp    (%edx),%cl
  800e77:	74 eb                	je     800e64 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e79:	0f b6 00             	movzbl (%eax),%eax
  800e7c:	0f b6 12             	movzbl (%edx),%edx
  800e7f:	29 d0                	sub    %edx,%eax
}
  800e81:	5b                   	pop    %ebx
  800e82:	5d                   	pop    %ebp
  800e83:	c3                   	ret    
		return 0;
  800e84:	b8 00 00 00 00       	mov    $0x0,%eax
  800e89:	eb f6                	jmp    800e81 <strncmp+0x2e>

00800e8b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e8b:	55                   	push   %ebp
  800e8c:	89 e5                	mov    %esp,%ebp
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e95:	0f b6 10             	movzbl (%eax),%edx
  800e98:	84 d2                	test   %dl,%dl
  800e9a:	74 09                	je     800ea5 <strchr+0x1a>
		if (*s == c)
  800e9c:	38 ca                	cmp    %cl,%dl
  800e9e:	74 0a                	je     800eaa <strchr+0x1f>
	for (; *s; s++)
  800ea0:	83 c0 01             	add    $0x1,%eax
  800ea3:	eb f0                	jmp    800e95 <strchr+0xa>
			return (char *) s;
	return 0;
  800ea5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eaa:	5d                   	pop    %ebp
  800eab:	c3                   	ret    

00800eac <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800eac:	55                   	push   %ebp
  800ead:	89 e5                	mov    %esp,%ebp
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800eb6:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800eb9:	38 ca                	cmp    %cl,%dl
  800ebb:	74 09                	je     800ec6 <strfind+0x1a>
  800ebd:	84 d2                	test   %dl,%dl
  800ebf:	74 05                	je     800ec6 <strfind+0x1a>
	for (; *s; s++)
  800ec1:	83 c0 01             	add    $0x1,%eax
  800ec4:	eb f0                	jmp    800eb6 <strfind+0xa>
			break;
	return (char *) s;
}
  800ec6:	5d                   	pop    %ebp
  800ec7:	c3                   	ret    

00800ec8 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ec8:	55                   	push   %ebp
  800ec9:	89 e5                	mov    %esp,%ebp
  800ecb:	57                   	push   %edi
  800ecc:	56                   	push   %esi
  800ecd:	53                   	push   %ebx
  800ece:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ed1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ed4:	85 c9                	test   %ecx,%ecx
  800ed6:	74 31                	je     800f09 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ed8:	89 f8                	mov    %edi,%eax
  800eda:	09 c8                	or     %ecx,%eax
  800edc:	a8 03                	test   $0x3,%al
  800ede:	75 23                	jne    800f03 <memset+0x3b>
		c &= 0xFF;
  800ee0:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ee4:	89 d3                	mov    %edx,%ebx
  800ee6:	c1 e3 08             	shl    $0x8,%ebx
  800ee9:	89 d0                	mov    %edx,%eax
  800eeb:	c1 e0 18             	shl    $0x18,%eax
  800eee:	89 d6                	mov    %edx,%esi
  800ef0:	c1 e6 10             	shl    $0x10,%esi
  800ef3:	09 f0                	or     %esi,%eax
  800ef5:	09 c2                	or     %eax,%edx
  800ef7:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ef9:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800efc:	89 d0                	mov    %edx,%eax
  800efe:	fc                   	cld    
  800eff:	f3 ab                	rep stos %eax,%es:(%edi)
  800f01:	eb 06                	jmp    800f09 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800f03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f06:	fc                   	cld    
  800f07:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800f09:	89 f8                	mov    %edi,%eax
  800f0b:	5b                   	pop    %ebx
  800f0c:	5e                   	pop    %esi
  800f0d:	5f                   	pop    %edi
  800f0e:	5d                   	pop    %ebp
  800f0f:	c3                   	ret    

00800f10 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
  800f13:	57                   	push   %edi
  800f14:	56                   	push   %esi
  800f15:	8b 45 08             	mov    0x8(%ebp),%eax
  800f18:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f1b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f1e:	39 c6                	cmp    %eax,%esi
  800f20:	73 32                	jae    800f54 <memmove+0x44>
  800f22:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800f25:	39 c2                	cmp    %eax,%edx
  800f27:	76 2b                	jbe    800f54 <memmove+0x44>
		s += n;
		d += n;
  800f29:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f2c:	89 fe                	mov    %edi,%esi
  800f2e:	09 ce                	or     %ecx,%esi
  800f30:	09 d6                	or     %edx,%esi
  800f32:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800f38:	75 0e                	jne    800f48 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800f3a:	83 ef 04             	sub    $0x4,%edi
  800f3d:	8d 72 fc             	lea    -0x4(%edx),%esi
  800f40:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800f43:	fd                   	std    
  800f44:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f46:	eb 09                	jmp    800f51 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800f48:	83 ef 01             	sub    $0x1,%edi
  800f4b:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800f4e:	fd                   	std    
  800f4f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800f51:	fc                   	cld    
  800f52:	eb 1a                	jmp    800f6e <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f54:	89 c2                	mov    %eax,%edx
  800f56:	09 ca                	or     %ecx,%edx
  800f58:	09 f2                	or     %esi,%edx
  800f5a:	f6 c2 03             	test   $0x3,%dl
  800f5d:	75 0a                	jne    800f69 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800f5f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800f62:	89 c7                	mov    %eax,%edi
  800f64:	fc                   	cld    
  800f65:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f67:	eb 05                	jmp    800f6e <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800f69:	89 c7                	mov    %eax,%edi
  800f6b:	fc                   	cld    
  800f6c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800f6e:	5e                   	pop    %esi
  800f6f:	5f                   	pop    %edi
  800f70:	5d                   	pop    %ebp
  800f71:	c3                   	ret    

00800f72 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800f72:	55                   	push   %ebp
  800f73:	89 e5                	mov    %esp,%ebp
  800f75:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800f78:	ff 75 10             	pushl  0x10(%ebp)
  800f7b:	ff 75 0c             	pushl  0xc(%ebp)
  800f7e:	ff 75 08             	pushl  0x8(%ebp)
  800f81:	e8 8a ff ff ff       	call   800f10 <memmove>
}
  800f86:	c9                   	leave  
  800f87:	c3                   	ret    

00800f88 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800f88:	55                   	push   %ebp
  800f89:	89 e5                	mov    %esp,%ebp
  800f8b:	56                   	push   %esi
  800f8c:	53                   	push   %ebx
  800f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f90:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f93:	89 c6                	mov    %eax,%esi
  800f95:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f98:	39 f0                	cmp    %esi,%eax
  800f9a:	74 1c                	je     800fb8 <memcmp+0x30>
		if (*s1 != *s2)
  800f9c:	0f b6 08             	movzbl (%eax),%ecx
  800f9f:	0f b6 1a             	movzbl (%edx),%ebx
  800fa2:	38 d9                	cmp    %bl,%cl
  800fa4:	75 08                	jne    800fae <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800fa6:	83 c0 01             	add    $0x1,%eax
  800fa9:	83 c2 01             	add    $0x1,%edx
  800fac:	eb ea                	jmp    800f98 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800fae:	0f b6 c1             	movzbl %cl,%eax
  800fb1:	0f b6 db             	movzbl %bl,%ebx
  800fb4:	29 d8                	sub    %ebx,%eax
  800fb6:	eb 05                	jmp    800fbd <memcmp+0x35>
	}

	return 0;
  800fb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fbd:	5b                   	pop    %ebx
  800fbe:	5e                   	pop    %esi
  800fbf:	5d                   	pop    %ebp
  800fc0:	c3                   	ret    

00800fc1 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800fc1:	55                   	push   %ebp
  800fc2:	89 e5                	mov    %esp,%ebp
  800fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800fca:	89 c2                	mov    %eax,%edx
  800fcc:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800fcf:	39 d0                	cmp    %edx,%eax
  800fd1:	73 09                	jae    800fdc <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fd3:	38 08                	cmp    %cl,(%eax)
  800fd5:	74 05                	je     800fdc <memfind+0x1b>
	for (; s < ends; s++)
  800fd7:	83 c0 01             	add    $0x1,%eax
  800fda:	eb f3                	jmp    800fcf <memfind+0xe>
			break;
	return (void *) s;
}
  800fdc:	5d                   	pop    %ebp
  800fdd:	c3                   	ret    

00800fde <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fde:	55                   	push   %ebp
  800fdf:	89 e5                	mov    %esp,%ebp
  800fe1:	57                   	push   %edi
  800fe2:	56                   	push   %esi
  800fe3:	53                   	push   %ebx
  800fe4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fe7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fea:	eb 03                	jmp    800fef <strtol+0x11>
		s++;
  800fec:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800fef:	0f b6 01             	movzbl (%ecx),%eax
  800ff2:	3c 20                	cmp    $0x20,%al
  800ff4:	74 f6                	je     800fec <strtol+0xe>
  800ff6:	3c 09                	cmp    $0x9,%al
  800ff8:	74 f2                	je     800fec <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ffa:	3c 2b                	cmp    $0x2b,%al
  800ffc:	74 2a                	je     801028 <strtol+0x4a>
	int neg = 0;
  800ffe:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801003:	3c 2d                	cmp    $0x2d,%al
  801005:	74 2b                	je     801032 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801007:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  80100d:	75 0f                	jne    80101e <strtol+0x40>
  80100f:	80 39 30             	cmpb   $0x30,(%ecx)
  801012:	74 28                	je     80103c <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801014:	85 db                	test   %ebx,%ebx
  801016:	b8 0a 00 00 00       	mov    $0xa,%eax
  80101b:	0f 44 d8             	cmove  %eax,%ebx
  80101e:	b8 00 00 00 00       	mov    $0x0,%eax
  801023:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801026:	eb 50                	jmp    801078 <strtol+0x9a>
		s++;
  801028:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  80102b:	bf 00 00 00 00       	mov    $0x0,%edi
  801030:	eb d5                	jmp    801007 <strtol+0x29>
		s++, neg = 1;
  801032:	83 c1 01             	add    $0x1,%ecx
  801035:	bf 01 00 00 00       	mov    $0x1,%edi
  80103a:	eb cb                	jmp    801007 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80103c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801040:	74 0e                	je     801050 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  801042:	85 db                	test   %ebx,%ebx
  801044:	75 d8                	jne    80101e <strtol+0x40>
		s++, base = 8;
  801046:	83 c1 01             	add    $0x1,%ecx
  801049:	bb 08 00 00 00       	mov    $0x8,%ebx
  80104e:	eb ce                	jmp    80101e <strtol+0x40>
		s += 2, base = 16;
  801050:	83 c1 02             	add    $0x2,%ecx
  801053:	bb 10 00 00 00       	mov    $0x10,%ebx
  801058:	eb c4                	jmp    80101e <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  80105a:	8d 72 9f             	lea    -0x61(%edx),%esi
  80105d:	89 f3                	mov    %esi,%ebx
  80105f:	80 fb 19             	cmp    $0x19,%bl
  801062:	77 29                	ja     80108d <strtol+0xaf>
			dig = *s - 'a' + 10;
  801064:	0f be d2             	movsbl %dl,%edx
  801067:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  80106a:	3b 55 10             	cmp    0x10(%ebp),%edx
  80106d:	7d 30                	jge    80109f <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  80106f:	83 c1 01             	add    $0x1,%ecx
  801072:	0f af 45 10          	imul   0x10(%ebp),%eax
  801076:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801078:	0f b6 11             	movzbl (%ecx),%edx
  80107b:	8d 72 d0             	lea    -0x30(%edx),%esi
  80107e:	89 f3                	mov    %esi,%ebx
  801080:	80 fb 09             	cmp    $0x9,%bl
  801083:	77 d5                	ja     80105a <strtol+0x7c>
			dig = *s - '0';
  801085:	0f be d2             	movsbl %dl,%edx
  801088:	83 ea 30             	sub    $0x30,%edx
  80108b:	eb dd                	jmp    80106a <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  80108d:	8d 72 bf             	lea    -0x41(%edx),%esi
  801090:	89 f3                	mov    %esi,%ebx
  801092:	80 fb 19             	cmp    $0x19,%bl
  801095:	77 08                	ja     80109f <strtol+0xc1>
			dig = *s - 'A' + 10;
  801097:	0f be d2             	movsbl %dl,%edx
  80109a:	83 ea 37             	sub    $0x37,%edx
  80109d:	eb cb                	jmp    80106a <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  80109f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010a3:	74 05                	je     8010aa <strtol+0xcc>
		*endptr = (char *) s;
  8010a5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010a8:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8010aa:	89 c2                	mov    %eax,%edx
  8010ac:	f7 da                	neg    %edx
  8010ae:	85 ff                	test   %edi,%edi
  8010b0:	0f 45 c2             	cmovne %edx,%eax
}
  8010b3:	5b                   	pop    %ebx
  8010b4:	5e                   	pop    %esi
  8010b5:	5f                   	pop    %edi
  8010b6:	5d                   	pop    %ebp
  8010b7:	c3                   	ret    

008010b8 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8010b8:	55                   	push   %ebp
  8010b9:	89 e5                	mov    %esp,%ebp
  8010bb:	57                   	push   %edi
  8010bc:	56                   	push   %esi
  8010bd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010be:	b8 00 00 00 00       	mov    $0x0,%eax
  8010c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c9:	89 c3                	mov    %eax,%ebx
  8010cb:	89 c7                	mov    %eax,%edi
  8010cd:	89 c6                	mov    %eax,%esi
  8010cf:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8010d1:	5b                   	pop    %ebx
  8010d2:	5e                   	pop    %esi
  8010d3:	5f                   	pop    %edi
  8010d4:	5d                   	pop    %ebp
  8010d5:	c3                   	ret    

008010d6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8010d6:	55                   	push   %ebp
  8010d7:	89 e5                	mov    %esp,%ebp
  8010d9:	57                   	push   %edi
  8010da:	56                   	push   %esi
  8010db:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8010e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8010e6:	89 d1                	mov    %edx,%ecx
  8010e8:	89 d3                	mov    %edx,%ebx
  8010ea:	89 d7                	mov    %edx,%edi
  8010ec:	89 d6                	mov    %edx,%esi
  8010ee:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8010f0:	5b                   	pop    %ebx
  8010f1:	5e                   	pop    %esi
  8010f2:	5f                   	pop    %edi
  8010f3:	5d                   	pop    %ebp
  8010f4:	c3                   	ret    

008010f5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
  8010f8:	57                   	push   %edi
  8010f9:	56                   	push   %esi
  8010fa:	53                   	push   %ebx
  8010fb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010fe:	b9 00 00 00 00       	mov    $0x0,%ecx
  801103:	8b 55 08             	mov    0x8(%ebp),%edx
  801106:	b8 03 00 00 00       	mov    $0x3,%eax
  80110b:	89 cb                	mov    %ecx,%ebx
  80110d:	89 cf                	mov    %ecx,%edi
  80110f:	89 ce                	mov    %ecx,%esi
  801111:	cd 30                	int    $0x30
	if(check && ret > 0)
  801113:	85 c0                	test   %eax,%eax
  801115:	7f 08                	jg     80111f <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801117:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80111a:	5b                   	pop    %ebx
  80111b:	5e                   	pop    %esi
  80111c:	5f                   	pop    %edi
  80111d:	5d                   	pop    %ebp
  80111e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80111f:	83 ec 0c             	sub    $0xc,%esp
  801122:	50                   	push   %eax
  801123:	6a 03                	push   $0x3
  801125:	68 40 32 80 00       	push   $0x803240
  80112a:	6a 43                	push   $0x43
  80112c:	68 5d 32 80 00       	push   $0x80325d
  801131:	e8 f7 f3 ff ff       	call   80052d <_panic>

00801136 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
  801139:	57                   	push   %edi
  80113a:	56                   	push   %esi
  80113b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80113c:	ba 00 00 00 00       	mov    $0x0,%edx
  801141:	b8 02 00 00 00       	mov    $0x2,%eax
  801146:	89 d1                	mov    %edx,%ecx
  801148:	89 d3                	mov    %edx,%ebx
  80114a:	89 d7                	mov    %edx,%edi
  80114c:	89 d6                	mov    %edx,%esi
  80114e:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801150:	5b                   	pop    %ebx
  801151:	5e                   	pop    %esi
  801152:	5f                   	pop    %edi
  801153:	5d                   	pop    %ebp
  801154:	c3                   	ret    

00801155 <sys_yield>:

void
sys_yield(void)
{
  801155:	55                   	push   %ebp
  801156:	89 e5                	mov    %esp,%ebp
  801158:	57                   	push   %edi
  801159:	56                   	push   %esi
  80115a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80115b:	ba 00 00 00 00       	mov    $0x0,%edx
  801160:	b8 0b 00 00 00       	mov    $0xb,%eax
  801165:	89 d1                	mov    %edx,%ecx
  801167:	89 d3                	mov    %edx,%ebx
  801169:	89 d7                	mov    %edx,%edi
  80116b:	89 d6                	mov    %edx,%esi
  80116d:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80116f:	5b                   	pop    %ebx
  801170:	5e                   	pop    %esi
  801171:	5f                   	pop    %edi
  801172:	5d                   	pop    %ebp
  801173:	c3                   	ret    

00801174 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801174:	55                   	push   %ebp
  801175:	89 e5                	mov    %esp,%ebp
  801177:	57                   	push   %edi
  801178:	56                   	push   %esi
  801179:	53                   	push   %ebx
  80117a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80117d:	be 00 00 00 00       	mov    $0x0,%esi
  801182:	8b 55 08             	mov    0x8(%ebp),%edx
  801185:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801188:	b8 04 00 00 00       	mov    $0x4,%eax
  80118d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801190:	89 f7                	mov    %esi,%edi
  801192:	cd 30                	int    $0x30
	if(check && ret > 0)
  801194:	85 c0                	test   %eax,%eax
  801196:	7f 08                	jg     8011a0 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801198:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80119b:	5b                   	pop    %ebx
  80119c:	5e                   	pop    %esi
  80119d:	5f                   	pop    %edi
  80119e:	5d                   	pop    %ebp
  80119f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011a0:	83 ec 0c             	sub    $0xc,%esp
  8011a3:	50                   	push   %eax
  8011a4:	6a 04                	push   $0x4
  8011a6:	68 40 32 80 00       	push   $0x803240
  8011ab:	6a 43                	push   $0x43
  8011ad:	68 5d 32 80 00       	push   $0x80325d
  8011b2:	e8 76 f3 ff ff       	call   80052d <_panic>

008011b7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8011b7:	55                   	push   %ebp
  8011b8:	89 e5                	mov    %esp,%ebp
  8011ba:	57                   	push   %edi
  8011bb:	56                   	push   %esi
  8011bc:	53                   	push   %ebx
  8011bd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c6:	b8 05 00 00 00       	mov    $0x5,%eax
  8011cb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011ce:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011d1:	8b 75 18             	mov    0x18(%ebp),%esi
  8011d4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011d6:	85 c0                	test   %eax,%eax
  8011d8:	7f 08                	jg     8011e2 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8011da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011dd:	5b                   	pop    %ebx
  8011de:	5e                   	pop    %esi
  8011df:	5f                   	pop    %edi
  8011e0:	5d                   	pop    %ebp
  8011e1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011e2:	83 ec 0c             	sub    $0xc,%esp
  8011e5:	50                   	push   %eax
  8011e6:	6a 05                	push   $0x5
  8011e8:	68 40 32 80 00       	push   $0x803240
  8011ed:	6a 43                	push   $0x43
  8011ef:	68 5d 32 80 00       	push   $0x80325d
  8011f4:	e8 34 f3 ff ff       	call   80052d <_panic>

008011f9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8011f9:	55                   	push   %ebp
  8011fa:	89 e5                	mov    %esp,%ebp
  8011fc:	57                   	push   %edi
  8011fd:	56                   	push   %esi
  8011fe:	53                   	push   %ebx
  8011ff:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801202:	bb 00 00 00 00       	mov    $0x0,%ebx
  801207:	8b 55 08             	mov    0x8(%ebp),%edx
  80120a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80120d:	b8 06 00 00 00       	mov    $0x6,%eax
  801212:	89 df                	mov    %ebx,%edi
  801214:	89 de                	mov    %ebx,%esi
  801216:	cd 30                	int    $0x30
	if(check && ret > 0)
  801218:	85 c0                	test   %eax,%eax
  80121a:	7f 08                	jg     801224 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80121c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80121f:	5b                   	pop    %ebx
  801220:	5e                   	pop    %esi
  801221:	5f                   	pop    %edi
  801222:	5d                   	pop    %ebp
  801223:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801224:	83 ec 0c             	sub    $0xc,%esp
  801227:	50                   	push   %eax
  801228:	6a 06                	push   $0x6
  80122a:	68 40 32 80 00       	push   $0x803240
  80122f:	6a 43                	push   $0x43
  801231:	68 5d 32 80 00       	push   $0x80325d
  801236:	e8 f2 f2 ff ff       	call   80052d <_panic>

0080123b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
  80123e:	57                   	push   %edi
  80123f:	56                   	push   %esi
  801240:	53                   	push   %ebx
  801241:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801244:	bb 00 00 00 00       	mov    $0x0,%ebx
  801249:	8b 55 08             	mov    0x8(%ebp),%edx
  80124c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80124f:	b8 08 00 00 00       	mov    $0x8,%eax
  801254:	89 df                	mov    %ebx,%edi
  801256:	89 de                	mov    %ebx,%esi
  801258:	cd 30                	int    $0x30
	if(check && ret > 0)
  80125a:	85 c0                	test   %eax,%eax
  80125c:	7f 08                	jg     801266 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80125e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801261:	5b                   	pop    %ebx
  801262:	5e                   	pop    %esi
  801263:	5f                   	pop    %edi
  801264:	5d                   	pop    %ebp
  801265:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801266:	83 ec 0c             	sub    $0xc,%esp
  801269:	50                   	push   %eax
  80126a:	6a 08                	push   $0x8
  80126c:	68 40 32 80 00       	push   $0x803240
  801271:	6a 43                	push   $0x43
  801273:	68 5d 32 80 00       	push   $0x80325d
  801278:	e8 b0 f2 ff ff       	call   80052d <_panic>

0080127d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	57                   	push   %edi
  801281:	56                   	push   %esi
  801282:	53                   	push   %ebx
  801283:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801286:	bb 00 00 00 00       	mov    $0x0,%ebx
  80128b:	8b 55 08             	mov    0x8(%ebp),%edx
  80128e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801291:	b8 09 00 00 00       	mov    $0x9,%eax
  801296:	89 df                	mov    %ebx,%edi
  801298:	89 de                	mov    %ebx,%esi
  80129a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80129c:	85 c0                	test   %eax,%eax
  80129e:	7f 08                	jg     8012a8 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8012a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012a3:	5b                   	pop    %ebx
  8012a4:	5e                   	pop    %esi
  8012a5:	5f                   	pop    %edi
  8012a6:	5d                   	pop    %ebp
  8012a7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012a8:	83 ec 0c             	sub    $0xc,%esp
  8012ab:	50                   	push   %eax
  8012ac:	6a 09                	push   $0x9
  8012ae:	68 40 32 80 00       	push   $0x803240
  8012b3:	6a 43                	push   $0x43
  8012b5:	68 5d 32 80 00       	push   $0x80325d
  8012ba:	e8 6e f2 ff ff       	call   80052d <_panic>

008012bf <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	57                   	push   %edi
  8012c3:	56                   	push   %esi
  8012c4:	53                   	push   %ebx
  8012c5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012c8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8012d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012d3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8012d8:	89 df                	mov    %ebx,%edi
  8012da:	89 de                	mov    %ebx,%esi
  8012dc:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012de:	85 c0                	test   %eax,%eax
  8012e0:	7f 08                	jg     8012ea <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8012e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012e5:	5b                   	pop    %ebx
  8012e6:	5e                   	pop    %esi
  8012e7:	5f                   	pop    %edi
  8012e8:	5d                   	pop    %ebp
  8012e9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012ea:	83 ec 0c             	sub    $0xc,%esp
  8012ed:	50                   	push   %eax
  8012ee:	6a 0a                	push   $0xa
  8012f0:	68 40 32 80 00       	push   $0x803240
  8012f5:	6a 43                	push   $0x43
  8012f7:	68 5d 32 80 00       	push   $0x80325d
  8012fc:	e8 2c f2 ff ff       	call   80052d <_panic>

00801301 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801301:	55                   	push   %ebp
  801302:	89 e5                	mov    %esp,%ebp
  801304:	57                   	push   %edi
  801305:	56                   	push   %esi
  801306:	53                   	push   %ebx
	asm volatile("int %1\n"
  801307:	8b 55 08             	mov    0x8(%ebp),%edx
  80130a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80130d:	b8 0c 00 00 00       	mov    $0xc,%eax
  801312:	be 00 00 00 00       	mov    $0x0,%esi
  801317:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80131a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80131d:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80131f:	5b                   	pop    %ebx
  801320:	5e                   	pop    %esi
  801321:	5f                   	pop    %edi
  801322:	5d                   	pop    %ebp
  801323:	c3                   	ret    

00801324 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801324:	55                   	push   %ebp
  801325:	89 e5                	mov    %esp,%ebp
  801327:	57                   	push   %edi
  801328:	56                   	push   %esi
  801329:	53                   	push   %ebx
  80132a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80132d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801332:	8b 55 08             	mov    0x8(%ebp),%edx
  801335:	b8 0d 00 00 00       	mov    $0xd,%eax
  80133a:	89 cb                	mov    %ecx,%ebx
  80133c:	89 cf                	mov    %ecx,%edi
  80133e:	89 ce                	mov    %ecx,%esi
  801340:	cd 30                	int    $0x30
	if(check && ret > 0)
  801342:	85 c0                	test   %eax,%eax
  801344:	7f 08                	jg     80134e <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801346:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801349:	5b                   	pop    %ebx
  80134a:	5e                   	pop    %esi
  80134b:	5f                   	pop    %edi
  80134c:	5d                   	pop    %ebp
  80134d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80134e:	83 ec 0c             	sub    $0xc,%esp
  801351:	50                   	push   %eax
  801352:	6a 0d                	push   $0xd
  801354:	68 40 32 80 00       	push   $0x803240
  801359:	6a 43                	push   $0x43
  80135b:	68 5d 32 80 00       	push   $0x80325d
  801360:	e8 c8 f1 ff ff       	call   80052d <_panic>

00801365 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
  801368:	57                   	push   %edi
  801369:	56                   	push   %esi
  80136a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80136b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801370:	8b 55 08             	mov    0x8(%ebp),%edx
  801373:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801376:	b8 0e 00 00 00       	mov    $0xe,%eax
  80137b:	89 df                	mov    %ebx,%edi
  80137d:	89 de                	mov    %ebx,%esi
  80137f:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801381:	5b                   	pop    %ebx
  801382:	5e                   	pop    %esi
  801383:	5f                   	pop    %edi
  801384:	5d                   	pop    %ebp
  801385:	c3                   	ret    

00801386 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
  801389:	57                   	push   %edi
  80138a:	56                   	push   %esi
  80138b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80138c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801391:	8b 55 08             	mov    0x8(%ebp),%edx
  801394:	b8 0f 00 00 00       	mov    $0xf,%eax
  801399:	89 cb                	mov    %ecx,%ebx
  80139b:	89 cf                	mov    %ecx,%edi
  80139d:	89 ce                	mov    %ecx,%esi
  80139f:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8013a1:	5b                   	pop    %ebx
  8013a2:	5e                   	pop    %esi
  8013a3:	5f                   	pop    %edi
  8013a4:	5d                   	pop    %ebp
  8013a5:	c3                   	ret    

008013a6 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
  8013a9:	53                   	push   %ebx
  8013aa:	83 ec 04             	sub    $0x4,%esp
	int r;
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8013ad:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8013b4:	83 e1 07             	and    $0x7,%ecx
  8013b7:	83 f9 07             	cmp    $0x7,%ecx
  8013ba:	74 32                	je     8013ee <duppage+0x48>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8013bc:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8013c3:	81 e1 05 08 00 00    	and    $0x805,%ecx
  8013c9:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  8013cf:	74 7d                	je     80144e <duppage+0xa8>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8013d1:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8013d8:	83 e1 05             	and    $0x5,%ecx
  8013db:	83 f9 05             	cmp    $0x5,%ecx
  8013de:	0f 84 9e 00 00 00    	je     801482 <duppage+0xdc>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8013e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ec:	c9                   	leave  
  8013ed:	c3                   	ret    
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8013ee:	89 d3                	mov    %edx,%ebx
  8013f0:	c1 e3 0c             	shl    $0xc,%ebx
  8013f3:	83 ec 0c             	sub    $0xc,%esp
  8013f6:	68 05 08 00 00       	push   $0x805
  8013fb:	53                   	push   %ebx
  8013fc:	50                   	push   %eax
  8013fd:	53                   	push   %ebx
  8013fe:	6a 00                	push   $0x0
  801400:	e8 b2 fd ff ff       	call   8011b7 <sys_page_map>
		if(r < 0)
  801405:	83 c4 20             	add    $0x20,%esp
  801408:	85 c0                	test   %eax,%eax
  80140a:	78 2e                	js     80143a <duppage+0x94>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  80140c:	83 ec 0c             	sub    $0xc,%esp
  80140f:	68 05 08 00 00       	push   $0x805
  801414:	53                   	push   %ebx
  801415:	6a 00                	push   $0x0
  801417:	53                   	push   %ebx
  801418:	6a 00                	push   $0x0
  80141a:	e8 98 fd ff ff       	call   8011b7 <sys_page_map>
		if(r < 0)
  80141f:	83 c4 20             	add    $0x20,%esp
  801422:	85 c0                	test   %eax,%eax
  801424:	79 be                	jns    8013e4 <duppage+0x3e>
			panic("sys_page_map() panic\n");
  801426:	83 ec 04             	sub    $0x4,%esp
  801429:	68 6b 32 80 00       	push   $0x80326b
  80142e:	6a 57                	push   $0x57
  801430:	68 81 32 80 00       	push   $0x803281
  801435:	e8 f3 f0 ff ff       	call   80052d <_panic>
			panic("sys_page_map() panic\n");
  80143a:	83 ec 04             	sub    $0x4,%esp
  80143d:	68 6b 32 80 00       	push   $0x80326b
  801442:	6a 53                	push   $0x53
  801444:	68 81 32 80 00       	push   $0x803281
  801449:	e8 df f0 ff ff       	call   80052d <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80144e:	c1 e2 0c             	shl    $0xc,%edx
  801451:	83 ec 0c             	sub    $0xc,%esp
  801454:	68 05 08 00 00       	push   $0x805
  801459:	52                   	push   %edx
  80145a:	50                   	push   %eax
  80145b:	52                   	push   %edx
  80145c:	6a 00                	push   $0x0
  80145e:	e8 54 fd ff ff       	call   8011b7 <sys_page_map>
		if(r < 0)
  801463:	83 c4 20             	add    $0x20,%esp
  801466:	85 c0                	test   %eax,%eax
  801468:	0f 89 76 ff ff ff    	jns    8013e4 <duppage+0x3e>
			panic("sys_page_map() panic\n");
  80146e:	83 ec 04             	sub    $0x4,%esp
  801471:	68 6b 32 80 00       	push   $0x80326b
  801476:	6a 5e                	push   $0x5e
  801478:	68 81 32 80 00       	push   $0x803281
  80147d:	e8 ab f0 ff ff       	call   80052d <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801482:	c1 e2 0c             	shl    $0xc,%edx
  801485:	83 ec 0c             	sub    $0xc,%esp
  801488:	6a 05                	push   $0x5
  80148a:	52                   	push   %edx
  80148b:	50                   	push   %eax
  80148c:	52                   	push   %edx
  80148d:	6a 00                	push   $0x0
  80148f:	e8 23 fd ff ff       	call   8011b7 <sys_page_map>
		if(r < 0)
  801494:	83 c4 20             	add    $0x20,%esp
  801497:	85 c0                	test   %eax,%eax
  801499:	0f 89 45 ff ff ff    	jns    8013e4 <duppage+0x3e>
			panic("sys_page_map() panic\n");
  80149f:	83 ec 04             	sub    $0x4,%esp
  8014a2:	68 6b 32 80 00       	push   $0x80326b
  8014a7:	6a 65                	push   $0x65
  8014a9:	68 81 32 80 00       	push   $0x803281
  8014ae:	e8 7a f0 ff ff       	call   80052d <_panic>

008014b3 <pgfault>:
{
  8014b3:	55                   	push   %ebp
  8014b4:	89 e5                	mov    %esp,%ebp
  8014b6:	53                   	push   %ebx
  8014b7:	83 ec 04             	sub    $0x4,%esp
  8014ba:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8014bd:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8014bf:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8014c3:	0f 84 99 00 00 00    	je     801562 <pgfault+0xaf>
  8014c9:	89 c2                	mov    %eax,%edx
  8014cb:	c1 ea 16             	shr    $0x16,%edx
  8014ce:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8014d5:	f6 c2 01             	test   $0x1,%dl
  8014d8:	0f 84 84 00 00 00    	je     801562 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8014de:	89 c2                	mov    %eax,%edx
  8014e0:	c1 ea 0c             	shr    $0xc,%edx
  8014e3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014ea:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8014f0:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8014f6:	75 6a                	jne    801562 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8014f8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014fd:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8014ff:	83 ec 04             	sub    $0x4,%esp
  801502:	6a 07                	push   $0x7
  801504:	68 00 f0 7f 00       	push   $0x7ff000
  801509:	6a 00                	push   $0x0
  80150b:	e8 64 fc ff ff       	call   801174 <sys_page_alloc>
	if(ret < 0)
  801510:	83 c4 10             	add    $0x10,%esp
  801513:	85 c0                	test   %eax,%eax
  801515:	78 5f                	js     801576 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801517:	83 ec 04             	sub    $0x4,%esp
  80151a:	68 00 10 00 00       	push   $0x1000
  80151f:	53                   	push   %ebx
  801520:	68 00 f0 7f 00       	push   $0x7ff000
  801525:	e8 48 fa ff ff       	call   800f72 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  80152a:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801531:	53                   	push   %ebx
  801532:	6a 00                	push   $0x0
  801534:	68 00 f0 7f 00       	push   $0x7ff000
  801539:	6a 00                	push   $0x0
  80153b:	e8 77 fc ff ff       	call   8011b7 <sys_page_map>
	if(ret < 0)
  801540:	83 c4 20             	add    $0x20,%esp
  801543:	85 c0                	test   %eax,%eax
  801545:	78 43                	js     80158a <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801547:	83 ec 08             	sub    $0x8,%esp
  80154a:	68 00 f0 7f 00       	push   $0x7ff000
  80154f:	6a 00                	push   $0x0
  801551:	e8 a3 fc ff ff       	call   8011f9 <sys_page_unmap>
	if(ret < 0)
  801556:	83 c4 10             	add    $0x10,%esp
  801559:	85 c0                	test   %eax,%eax
  80155b:	78 41                	js     80159e <pgfault+0xeb>
}
  80155d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801560:	c9                   	leave  
  801561:	c3                   	ret    
		panic("panic at pgfault()\n");
  801562:	83 ec 04             	sub    $0x4,%esp
  801565:	68 8c 32 80 00       	push   $0x80328c
  80156a:	6a 26                	push   $0x26
  80156c:	68 81 32 80 00       	push   $0x803281
  801571:	e8 b7 ef ff ff       	call   80052d <_panic>
		panic("panic in sys_page_alloc()\n");
  801576:	83 ec 04             	sub    $0x4,%esp
  801579:	68 a0 32 80 00       	push   $0x8032a0
  80157e:	6a 31                	push   $0x31
  801580:	68 81 32 80 00       	push   $0x803281
  801585:	e8 a3 ef ff ff       	call   80052d <_panic>
		panic("panic in sys_page_map()\n");
  80158a:	83 ec 04             	sub    $0x4,%esp
  80158d:	68 bb 32 80 00       	push   $0x8032bb
  801592:	6a 36                	push   $0x36
  801594:	68 81 32 80 00       	push   $0x803281
  801599:	e8 8f ef ff ff       	call   80052d <_panic>
		panic("panic in sys_page_unmap()\n");
  80159e:	83 ec 04             	sub    $0x4,%esp
  8015a1:	68 d4 32 80 00       	push   $0x8032d4
  8015a6:	6a 39                	push   $0x39
  8015a8:	68 81 32 80 00       	push   $0x803281
  8015ad:	e8 7b ef ff ff       	call   80052d <_panic>

008015b2 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
  8015b5:	57                   	push   %edi
  8015b6:	56                   	push   %esi
  8015b7:	53                   	push   %ebx
  8015b8:	83 ec 18             	sub    $0x18,%esp
	// cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
	int ret;
	set_pgfault_handler(pgfault);
  8015bb:	68 b3 14 80 00       	push   $0x8014b3
  8015c0:	e8 55 13 00 00       	call   80291a <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8015c5:	b8 07 00 00 00       	mov    $0x7,%eax
  8015ca:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8015cc:	83 c4 10             	add    $0x10,%esp
  8015cf:	85 c0                	test   %eax,%eax
  8015d1:	78 27                	js     8015fa <fork+0x48>
  8015d3:	89 c6                	mov    %eax,%esi
  8015d5:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8015d7:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8015dc:	75 48                	jne    801626 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  8015de:	e8 53 fb ff ff       	call   801136 <sys_getenvid>
  8015e3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8015e8:	c1 e0 07             	shl    $0x7,%eax
  8015eb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8015f0:	a3 04 50 80 00       	mov    %eax,0x805004
		return 0;
  8015f5:	e9 90 00 00 00       	jmp    80168a <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  8015fa:	83 ec 04             	sub    $0x4,%esp
  8015fd:	68 f0 32 80 00       	push   $0x8032f0
  801602:	68 85 00 00 00       	push   $0x85
  801607:	68 81 32 80 00       	push   $0x803281
  80160c:	e8 1c ef ff ff       	call   80052d <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801611:	89 f8                	mov    %edi,%eax
  801613:	e8 8e fd ff ff       	call   8013a6 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801618:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80161e:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801624:	74 26                	je     80164c <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801626:	89 d8                	mov    %ebx,%eax
  801628:	c1 e8 16             	shr    $0x16,%eax
  80162b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801632:	a8 01                	test   $0x1,%al
  801634:	74 e2                	je     801618 <fork+0x66>
  801636:	89 da                	mov    %ebx,%edx
  801638:	c1 ea 0c             	shr    $0xc,%edx
  80163b:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801642:	83 e0 05             	and    $0x5,%eax
  801645:	83 f8 05             	cmp    $0x5,%eax
  801648:	75 ce                	jne    801618 <fork+0x66>
  80164a:	eb c5                	jmp    801611 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80164c:	83 ec 04             	sub    $0x4,%esp
  80164f:	6a 07                	push   $0x7
  801651:	68 00 f0 bf ee       	push   $0xeebff000
  801656:	56                   	push   %esi
  801657:	e8 18 fb ff ff       	call   801174 <sys_page_alloc>
	if(ret < 0)
  80165c:	83 c4 10             	add    $0x10,%esp
  80165f:	85 c0                	test   %eax,%eax
  801661:	78 31                	js     801694 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801663:	83 ec 08             	sub    $0x8,%esp
  801666:	68 89 29 80 00       	push   $0x802989
  80166b:	56                   	push   %esi
  80166c:	e8 4e fc ff ff       	call   8012bf <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801671:	83 c4 10             	add    $0x10,%esp
  801674:	85 c0                	test   %eax,%eax
  801676:	78 33                	js     8016ab <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801678:	83 ec 08             	sub    $0x8,%esp
  80167b:	6a 02                	push   $0x2
  80167d:	56                   	push   %esi
  80167e:	e8 b8 fb ff ff       	call   80123b <sys_env_set_status>
	if(ret < 0)
  801683:	83 c4 10             	add    $0x10,%esp
  801686:	85 c0                	test   %eax,%eax
  801688:	78 38                	js     8016c2 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  80168a:	89 f0                	mov    %esi,%eax
  80168c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80168f:	5b                   	pop    %ebx
  801690:	5e                   	pop    %esi
  801691:	5f                   	pop    %edi
  801692:	5d                   	pop    %ebp
  801693:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801694:	83 ec 04             	sub    $0x4,%esp
  801697:	68 a0 32 80 00       	push   $0x8032a0
  80169c:	68 91 00 00 00       	push   $0x91
  8016a1:	68 81 32 80 00       	push   $0x803281
  8016a6:	e8 82 ee ff ff       	call   80052d <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8016ab:	83 ec 04             	sub    $0x4,%esp
  8016ae:	68 14 33 80 00       	push   $0x803314
  8016b3:	68 94 00 00 00       	push   $0x94
  8016b8:	68 81 32 80 00       	push   $0x803281
  8016bd:	e8 6b ee ff ff       	call   80052d <_panic>
		panic("panic in sys_env_set_status()\n");
  8016c2:	83 ec 04             	sub    $0x4,%esp
  8016c5:	68 3c 33 80 00       	push   $0x80333c
  8016ca:	68 97 00 00 00       	push   $0x97
  8016cf:	68 81 32 80 00       	push   $0x803281
  8016d4:	e8 54 ee ff ff       	call   80052d <_panic>

008016d9 <sfork>:

// Challenge!
int
sfork(void)
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
  8016dc:	57                   	push   %edi
  8016dd:	56                   	push   %esi
  8016de:	53                   	push   %ebx
  8016df:	83 ec 10             	sub    $0x10,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8016e2:	a1 04 50 80 00       	mov    0x805004,%eax
  8016e7:	8b 40 48             	mov    0x48(%eax),%eax
  8016ea:	68 5c 33 80 00       	push   $0x80335c
  8016ef:	50                   	push   %eax
  8016f0:	68 8c 2e 80 00       	push   $0x802e8c
  8016f5:	e8 29 ef ff ff       	call   800623 <cprintf>
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8016fa:	c7 04 24 b3 14 80 00 	movl   $0x8014b3,(%esp)
  801701:	e8 14 12 00 00       	call   80291a <set_pgfault_handler>
  801706:	b8 07 00 00 00       	mov    $0x7,%eax
  80170b:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80170d:	83 c4 10             	add    $0x10,%esp
  801710:	85 c0                	test   %eax,%eax
  801712:	78 27                	js     80173b <sfork+0x62>
  801714:	89 c7                	mov    %eax,%edi
  801716:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801718:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80171d:	75 55                	jne    801774 <sfork+0x9b>
		thisenv = &envs[ENVX(sys_getenvid())];
  80171f:	e8 12 fa ff ff       	call   801136 <sys_getenvid>
  801724:	25 ff 03 00 00       	and    $0x3ff,%eax
  801729:	c1 e0 07             	shl    $0x7,%eax
  80172c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801731:	a3 04 50 80 00       	mov    %eax,0x805004
		return 0;
  801736:	e9 d4 00 00 00       	jmp    80180f <sfork+0x136>
		panic("the fork panic! at sys_exofork()\n");
  80173b:	83 ec 04             	sub    $0x4,%esp
  80173e:	68 f0 32 80 00       	push   $0x8032f0
  801743:	68 a9 00 00 00       	push   $0xa9
  801748:	68 81 32 80 00       	push   $0x803281
  80174d:	e8 db ed ff ff       	call   80052d <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801752:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801757:	89 f0                	mov    %esi,%eax
  801759:	e8 48 fc ff ff       	call   8013a6 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80175e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801764:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  80176a:	77 65                	ja     8017d1 <sfork+0xf8>
		if(i == (USTACKTOP - PGSIZE))
  80176c:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801772:	74 de                	je     801752 <sfork+0x79>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801774:	89 d8                	mov    %ebx,%eax
  801776:	c1 e8 16             	shr    $0x16,%eax
  801779:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801780:	a8 01                	test   $0x1,%al
  801782:	74 da                	je     80175e <sfork+0x85>
  801784:	89 da                	mov    %ebx,%edx
  801786:	c1 ea 0c             	shr    $0xc,%edx
  801789:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801790:	83 e0 05             	and    $0x5,%eax
  801793:	83 f8 05             	cmp    $0x5,%eax
  801796:	75 c6                	jne    80175e <sfork+0x85>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801798:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  80179f:	c1 e2 0c             	shl    $0xc,%edx
  8017a2:	83 ec 0c             	sub    $0xc,%esp
  8017a5:	83 e0 07             	and    $0x7,%eax
  8017a8:	50                   	push   %eax
  8017a9:	52                   	push   %edx
  8017aa:	56                   	push   %esi
  8017ab:	52                   	push   %edx
  8017ac:	6a 00                	push   $0x0
  8017ae:	e8 04 fa ff ff       	call   8011b7 <sys_page_map>
  8017b3:	83 c4 20             	add    $0x20,%esp
  8017b6:	85 c0                	test   %eax,%eax
  8017b8:	74 a4                	je     80175e <sfork+0x85>
				panic("sys_page_map() panic\n");
  8017ba:	83 ec 04             	sub    $0x4,%esp
  8017bd:	68 6b 32 80 00       	push   $0x80326b
  8017c2:	68 b4 00 00 00       	push   $0xb4
  8017c7:	68 81 32 80 00       	push   $0x803281
  8017cc:	e8 5c ed ff ff       	call   80052d <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8017d1:	83 ec 04             	sub    $0x4,%esp
  8017d4:	6a 07                	push   $0x7
  8017d6:	68 00 f0 bf ee       	push   $0xeebff000
  8017db:	57                   	push   %edi
  8017dc:	e8 93 f9 ff ff       	call   801174 <sys_page_alloc>
	if(ret < 0)
  8017e1:	83 c4 10             	add    $0x10,%esp
  8017e4:	85 c0                	test   %eax,%eax
  8017e6:	78 31                	js     801819 <sfork+0x140>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8017e8:	83 ec 08             	sub    $0x8,%esp
  8017eb:	68 89 29 80 00       	push   $0x802989
  8017f0:	57                   	push   %edi
  8017f1:	e8 c9 fa ff ff       	call   8012bf <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8017f6:	83 c4 10             	add    $0x10,%esp
  8017f9:	85 c0                	test   %eax,%eax
  8017fb:	78 33                	js     801830 <sfork+0x157>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8017fd:	83 ec 08             	sub    $0x8,%esp
  801800:	6a 02                	push   $0x2
  801802:	57                   	push   %edi
  801803:	e8 33 fa ff ff       	call   80123b <sys_env_set_status>
	if(ret < 0)
  801808:	83 c4 10             	add    $0x10,%esp
  80180b:	85 c0                	test   %eax,%eax
  80180d:	78 38                	js     801847 <sfork+0x16e>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  80180f:	89 f8                	mov    %edi,%eax
  801811:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801814:	5b                   	pop    %ebx
  801815:	5e                   	pop    %esi
  801816:	5f                   	pop    %edi
  801817:	5d                   	pop    %ebp
  801818:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801819:	83 ec 04             	sub    $0x4,%esp
  80181c:	68 a0 32 80 00       	push   $0x8032a0
  801821:	68 ba 00 00 00       	push   $0xba
  801826:	68 81 32 80 00       	push   $0x803281
  80182b:	e8 fd ec ff ff       	call   80052d <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801830:	83 ec 04             	sub    $0x4,%esp
  801833:	68 14 33 80 00       	push   $0x803314
  801838:	68 bd 00 00 00       	push   $0xbd
  80183d:	68 81 32 80 00       	push   $0x803281
  801842:	e8 e6 ec ff ff       	call   80052d <_panic>
		panic("panic in sys_env_set_status()\n");
  801847:	83 ec 04             	sub    $0x4,%esp
  80184a:	68 3c 33 80 00       	push   $0x80333c
  80184f:	68 c0 00 00 00       	push   $0xc0
  801854:	68 81 32 80 00       	push   $0x803281
  801859:	e8 cf ec ff ff       	call   80052d <_panic>

0080185e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801861:	8b 45 08             	mov    0x8(%ebp),%eax
  801864:	05 00 00 00 30       	add    $0x30000000,%eax
  801869:	c1 e8 0c             	shr    $0xc,%eax
}
  80186c:	5d                   	pop    %ebp
  80186d:	c3                   	ret    

0080186e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801871:	8b 45 08             	mov    0x8(%ebp),%eax
  801874:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801879:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80187e:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801883:	5d                   	pop    %ebp
  801884:	c3                   	ret    

00801885 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
  801888:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80188d:	89 c2                	mov    %eax,%edx
  80188f:	c1 ea 16             	shr    $0x16,%edx
  801892:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801899:	f6 c2 01             	test   $0x1,%dl
  80189c:	74 2d                	je     8018cb <fd_alloc+0x46>
  80189e:	89 c2                	mov    %eax,%edx
  8018a0:	c1 ea 0c             	shr    $0xc,%edx
  8018a3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018aa:	f6 c2 01             	test   $0x1,%dl
  8018ad:	74 1c                	je     8018cb <fd_alloc+0x46>
  8018af:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8018b4:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8018b9:	75 d2                	jne    80188d <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8018bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8018c4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8018c9:	eb 0a                	jmp    8018d5 <fd_alloc+0x50>
			*fd_store = fd;
  8018cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018ce:	89 01                	mov    %eax,(%ecx)
			return 0;
  8018d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018d5:	5d                   	pop    %ebp
  8018d6:	c3                   	ret    

008018d7 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
  8018da:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8018dd:	83 f8 1f             	cmp    $0x1f,%eax
  8018e0:	77 30                	ja     801912 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8018e2:	c1 e0 0c             	shl    $0xc,%eax
  8018e5:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8018ea:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8018f0:	f6 c2 01             	test   $0x1,%dl
  8018f3:	74 24                	je     801919 <fd_lookup+0x42>
  8018f5:	89 c2                	mov    %eax,%edx
  8018f7:	c1 ea 0c             	shr    $0xc,%edx
  8018fa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801901:	f6 c2 01             	test   $0x1,%dl
  801904:	74 1a                	je     801920 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801906:	8b 55 0c             	mov    0xc(%ebp),%edx
  801909:	89 02                	mov    %eax,(%edx)
	return 0;
  80190b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801910:	5d                   	pop    %ebp
  801911:	c3                   	ret    
		return -E_INVAL;
  801912:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801917:	eb f7                	jmp    801910 <fd_lookup+0x39>
		return -E_INVAL;
  801919:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80191e:	eb f0                	jmp    801910 <fd_lookup+0x39>
  801920:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801925:	eb e9                	jmp    801910 <fd_lookup+0x39>

00801927 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
  80192a:	83 ec 08             	sub    $0x8,%esp
  80192d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801930:	ba e0 33 80 00       	mov    $0x8033e0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801935:	b8 20 40 80 00       	mov    $0x804020,%eax
		if (devtab[i]->dev_id == dev_id) {
  80193a:	39 08                	cmp    %ecx,(%eax)
  80193c:	74 33                	je     801971 <dev_lookup+0x4a>
  80193e:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801941:	8b 02                	mov    (%edx),%eax
  801943:	85 c0                	test   %eax,%eax
  801945:	75 f3                	jne    80193a <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801947:	a1 04 50 80 00       	mov    0x805004,%eax
  80194c:	8b 40 48             	mov    0x48(%eax),%eax
  80194f:	83 ec 04             	sub    $0x4,%esp
  801952:	51                   	push   %ecx
  801953:	50                   	push   %eax
  801954:	68 64 33 80 00       	push   $0x803364
  801959:	e8 c5 ec ff ff       	call   800623 <cprintf>
	*dev = 0;
  80195e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801961:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801967:	83 c4 10             	add    $0x10,%esp
  80196a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80196f:	c9                   	leave  
  801970:	c3                   	ret    
			*dev = devtab[i];
  801971:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801974:	89 01                	mov    %eax,(%ecx)
			return 0;
  801976:	b8 00 00 00 00       	mov    $0x0,%eax
  80197b:	eb f2                	jmp    80196f <dev_lookup+0x48>

0080197d <fd_close>:
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
  801980:	57                   	push   %edi
  801981:	56                   	push   %esi
  801982:	53                   	push   %ebx
  801983:	83 ec 24             	sub    $0x24,%esp
  801986:	8b 75 08             	mov    0x8(%ebp),%esi
  801989:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80198c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80198f:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801990:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801996:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801999:	50                   	push   %eax
  80199a:	e8 38 ff ff ff       	call   8018d7 <fd_lookup>
  80199f:	89 c3                	mov    %eax,%ebx
  8019a1:	83 c4 10             	add    $0x10,%esp
  8019a4:	85 c0                	test   %eax,%eax
  8019a6:	78 05                	js     8019ad <fd_close+0x30>
	    || fd != fd2)
  8019a8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8019ab:	74 16                	je     8019c3 <fd_close+0x46>
		return (must_exist ? r : 0);
  8019ad:	89 f8                	mov    %edi,%eax
  8019af:	84 c0                	test   %al,%al
  8019b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b6:	0f 44 d8             	cmove  %eax,%ebx
}
  8019b9:	89 d8                	mov    %ebx,%eax
  8019bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019be:	5b                   	pop    %ebx
  8019bf:	5e                   	pop    %esi
  8019c0:	5f                   	pop    %edi
  8019c1:	5d                   	pop    %ebp
  8019c2:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8019c3:	83 ec 08             	sub    $0x8,%esp
  8019c6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8019c9:	50                   	push   %eax
  8019ca:	ff 36                	pushl  (%esi)
  8019cc:	e8 56 ff ff ff       	call   801927 <dev_lookup>
  8019d1:	89 c3                	mov    %eax,%ebx
  8019d3:	83 c4 10             	add    $0x10,%esp
  8019d6:	85 c0                	test   %eax,%eax
  8019d8:	78 1a                	js     8019f4 <fd_close+0x77>
		if (dev->dev_close)
  8019da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019dd:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8019e0:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8019e5:	85 c0                	test   %eax,%eax
  8019e7:	74 0b                	je     8019f4 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8019e9:	83 ec 0c             	sub    $0xc,%esp
  8019ec:	56                   	push   %esi
  8019ed:	ff d0                	call   *%eax
  8019ef:	89 c3                	mov    %eax,%ebx
  8019f1:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8019f4:	83 ec 08             	sub    $0x8,%esp
  8019f7:	56                   	push   %esi
  8019f8:	6a 00                	push   $0x0
  8019fa:	e8 fa f7 ff ff       	call   8011f9 <sys_page_unmap>
	return r;
  8019ff:	83 c4 10             	add    $0x10,%esp
  801a02:	eb b5                	jmp    8019b9 <fd_close+0x3c>

00801a04 <close>:

int
close(int fdnum)
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
  801a07:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a0a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a0d:	50                   	push   %eax
  801a0e:	ff 75 08             	pushl  0x8(%ebp)
  801a11:	e8 c1 fe ff ff       	call   8018d7 <fd_lookup>
  801a16:	83 c4 10             	add    $0x10,%esp
  801a19:	85 c0                	test   %eax,%eax
  801a1b:	79 02                	jns    801a1f <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    
		return fd_close(fd, 1);
  801a1f:	83 ec 08             	sub    $0x8,%esp
  801a22:	6a 01                	push   $0x1
  801a24:	ff 75 f4             	pushl  -0xc(%ebp)
  801a27:	e8 51 ff ff ff       	call   80197d <fd_close>
  801a2c:	83 c4 10             	add    $0x10,%esp
  801a2f:	eb ec                	jmp    801a1d <close+0x19>

00801a31 <close_all>:

void
close_all(void)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
  801a34:	53                   	push   %ebx
  801a35:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801a38:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801a3d:	83 ec 0c             	sub    $0xc,%esp
  801a40:	53                   	push   %ebx
  801a41:	e8 be ff ff ff       	call   801a04 <close>
	for (i = 0; i < MAXFD; i++)
  801a46:	83 c3 01             	add    $0x1,%ebx
  801a49:	83 c4 10             	add    $0x10,%esp
  801a4c:	83 fb 20             	cmp    $0x20,%ebx
  801a4f:	75 ec                	jne    801a3d <close_all+0xc>
}
  801a51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
  801a59:	57                   	push   %edi
  801a5a:	56                   	push   %esi
  801a5b:	53                   	push   %ebx
  801a5c:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801a5f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801a62:	50                   	push   %eax
  801a63:	ff 75 08             	pushl  0x8(%ebp)
  801a66:	e8 6c fe ff ff       	call   8018d7 <fd_lookup>
  801a6b:	89 c3                	mov    %eax,%ebx
  801a6d:	83 c4 10             	add    $0x10,%esp
  801a70:	85 c0                	test   %eax,%eax
  801a72:	0f 88 81 00 00 00    	js     801af9 <dup+0xa3>
		return r;
	close(newfdnum);
  801a78:	83 ec 0c             	sub    $0xc,%esp
  801a7b:	ff 75 0c             	pushl  0xc(%ebp)
  801a7e:	e8 81 ff ff ff       	call   801a04 <close>

	newfd = INDEX2FD(newfdnum);
  801a83:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a86:	c1 e6 0c             	shl    $0xc,%esi
  801a89:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801a8f:	83 c4 04             	add    $0x4,%esp
  801a92:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a95:	e8 d4 fd ff ff       	call   80186e <fd2data>
  801a9a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801a9c:	89 34 24             	mov    %esi,(%esp)
  801a9f:	e8 ca fd ff ff       	call   80186e <fd2data>
  801aa4:	83 c4 10             	add    $0x10,%esp
  801aa7:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801aa9:	89 d8                	mov    %ebx,%eax
  801aab:	c1 e8 16             	shr    $0x16,%eax
  801aae:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801ab5:	a8 01                	test   $0x1,%al
  801ab7:	74 11                	je     801aca <dup+0x74>
  801ab9:	89 d8                	mov    %ebx,%eax
  801abb:	c1 e8 0c             	shr    $0xc,%eax
  801abe:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801ac5:	f6 c2 01             	test   $0x1,%dl
  801ac8:	75 39                	jne    801b03 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801aca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801acd:	89 d0                	mov    %edx,%eax
  801acf:	c1 e8 0c             	shr    $0xc,%eax
  801ad2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801ad9:	83 ec 0c             	sub    $0xc,%esp
  801adc:	25 07 0e 00 00       	and    $0xe07,%eax
  801ae1:	50                   	push   %eax
  801ae2:	56                   	push   %esi
  801ae3:	6a 00                	push   $0x0
  801ae5:	52                   	push   %edx
  801ae6:	6a 00                	push   $0x0
  801ae8:	e8 ca f6 ff ff       	call   8011b7 <sys_page_map>
  801aed:	89 c3                	mov    %eax,%ebx
  801aef:	83 c4 20             	add    $0x20,%esp
  801af2:	85 c0                	test   %eax,%eax
  801af4:	78 31                	js     801b27 <dup+0xd1>
		goto err;

	return newfdnum;
  801af6:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801af9:	89 d8                	mov    %ebx,%eax
  801afb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801afe:	5b                   	pop    %ebx
  801aff:	5e                   	pop    %esi
  801b00:	5f                   	pop    %edi
  801b01:	5d                   	pop    %ebp
  801b02:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801b03:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801b0a:	83 ec 0c             	sub    $0xc,%esp
  801b0d:	25 07 0e 00 00       	and    $0xe07,%eax
  801b12:	50                   	push   %eax
  801b13:	57                   	push   %edi
  801b14:	6a 00                	push   $0x0
  801b16:	53                   	push   %ebx
  801b17:	6a 00                	push   $0x0
  801b19:	e8 99 f6 ff ff       	call   8011b7 <sys_page_map>
  801b1e:	89 c3                	mov    %eax,%ebx
  801b20:	83 c4 20             	add    $0x20,%esp
  801b23:	85 c0                	test   %eax,%eax
  801b25:	79 a3                	jns    801aca <dup+0x74>
	sys_page_unmap(0, newfd);
  801b27:	83 ec 08             	sub    $0x8,%esp
  801b2a:	56                   	push   %esi
  801b2b:	6a 00                	push   $0x0
  801b2d:	e8 c7 f6 ff ff       	call   8011f9 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801b32:	83 c4 08             	add    $0x8,%esp
  801b35:	57                   	push   %edi
  801b36:	6a 00                	push   $0x0
  801b38:	e8 bc f6 ff ff       	call   8011f9 <sys_page_unmap>
	return r;
  801b3d:	83 c4 10             	add    $0x10,%esp
  801b40:	eb b7                	jmp    801af9 <dup+0xa3>

00801b42 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
  801b45:	53                   	push   %ebx
  801b46:	83 ec 1c             	sub    $0x1c,%esp
  801b49:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b4c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b4f:	50                   	push   %eax
  801b50:	53                   	push   %ebx
  801b51:	e8 81 fd ff ff       	call   8018d7 <fd_lookup>
  801b56:	83 c4 10             	add    $0x10,%esp
  801b59:	85 c0                	test   %eax,%eax
  801b5b:	78 3f                	js     801b9c <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b5d:	83 ec 08             	sub    $0x8,%esp
  801b60:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b63:	50                   	push   %eax
  801b64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b67:	ff 30                	pushl  (%eax)
  801b69:	e8 b9 fd ff ff       	call   801927 <dev_lookup>
  801b6e:	83 c4 10             	add    $0x10,%esp
  801b71:	85 c0                	test   %eax,%eax
  801b73:	78 27                	js     801b9c <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b75:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b78:	8b 42 08             	mov    0x8(%edx),%eax
  801b7b:	83 e0 03             	and    $0x3,%eax
  801b7e:	83 f8 01             	cmp    $0x1,%eax
  801b81:	74 1e                	je     801ba1 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b86:	8b 40 08             	mov    0x8(%eax),%eax
  801b89:	85 c0                	test   %eax,%eax
  801b8b:	74 35                	je     801bc2 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801b8d:	83 ec 04             	sub    $0x4,%esp
  801b90:	ff 75 10             	pushl  0x10(%ebp)
  801b93:	ff 75 0c             	pushl  0xc(%ebp)
  801b96:	52                   	push   %edx
  801b97:	ff d0                	call   *%eax
  801b99:	83 c4 10             	add    $0x10,%esp
}
  801b9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801ba1:	a1 04 50 80 00       	mov    0x805004,%eax
  801ba6:	8b 40 48             	mov    0x48(%eax),%eax
  801ba9:	83 ec 04             	sub    $0x4,%esp
  801bac:	53                   	push   %ebx
  801bad:	50                   	push   %eax
  801bae:	68 a5 33 80 00       	push   $0x8033a5
  801bb3:	e8 6b ea ff ff       	call   800623 <cprintf>
		return -E_INVAL;
  801bb8:	83 c4 10             	add    $0x10,%esp
  801bbb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bc0:	eb da                	jmp    801b9c <read+0x5a>
		return -E_NOT_SUPP;
  801bc2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bc7:	eb d3                	jmp    801b9c <read+0x5a>

00801bc9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
  801bcc:	57                   	push   %edi
  801bcd:	56                   	push   %esi
  801bce:	53                   	push   %ebx
  801bcf:	83 ec 0c             	sub    $0xc,%esp
  801bd2:	8b 7d 08             	mov    0x8(%ebp),%edi
  801bd5:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801bd8:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bdd:	39 f3                	cmp    %esi,%ebx
  801bdf:	73 23                	jae    801c04 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801be1:	83 ec 04             	sub    $0x4,%esp
  801be4:	89 f0                	mov    %esi,%eax
  801be6:	29 d8                	sub    %ebx,%eax
  801be8:	50                   	push   %eax
  801be9:	89 d8                	mov    %ebx,%eax
  801beb:	03 45 0c             	add    0xc(%ebp),%eax
  801bee:	50                   	push   %eax
  801bef:	57                   	push   %edi
  801bf0:	e8 4d ff ff ff       	call   801b42 <read>
		if (m < 0)
  801bf5:	83 c4 10             	add    $0x10,%esp
  801bf8:	85 c0                	test   %eax,%eax
  801bfa:	78 06                	js     801c02 <readn+0x39>
			return m;
		if (m == 0)
  801bfc:	74 06                	je     801c04 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801bfe:	01 c3                	add    %eax,%ebx
  801c00:	eb db                	jmp    801bdd <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801c02:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801c04:	89 d8                	mov    %ebx,%eax
  801c06:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c09:	5b                   	pop    %ebx
  801c0a:	5e                   	pop    %esi
  801c0b:	5f                   	pop    %edi
  801c0c:	5d                   	pop    %ebp
  801c0d:	c3                   	ret    

00801c0e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
  801c11:	53                   	push   %ebx
  801c12:	83 ec 1c             	sub    $0x1c,%esp
  801c15:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c18:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c1b:	50                   	push   %eax
  801c1c:	53                   	push   %ebx
  801c1d:	e8 b5 fc ff ff       	call   8018d7 <fd_lookup>
  801c22:	83 c4 10             	add    $0x10,%esp
  801c25:	85 c0                	test   %eax,%eax
  801c27:	78 3a                	js     801c63 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c29:	83 ec 08             	sub    $0x8,%esp
  801c2c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c2f:	50                   	push   %eax
  801c30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c33:	ff 30                	pushl  (%eax)
  801c35:	e8 ed fc ff ff       	call   801927 <dev_lookup>
  801c3a:	83 c4 10             	add    $0x10,%esp
  801c3d:	85 c0                	test   %eax,%eax
  801c3f:	78 22                	js     801c63 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c44:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c48:	74 1e                	je     801c68 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801c4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c4d:	8b 52 0c             	mov    0xc(%edx),%edx
  801c50:	85 d2                	test   %edx,%edx
  801c52:	74 35                	je     801c89 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801c54:	83 ec 04             	sub    $0x4,%esp
  801c57:	ff 75 10             	pushl  0x10(%ebp)
  801c5a:	ff 75 0c             	pushl  0xc(%ebp)
  801c5d:	50                   	push   %eax
  801c5e:	ff d2                	call   *%edx
  801c60:	83 c4 10             	add    $0x10,%esp
}
  801c63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c66:	c9                   	leave  
  801c67:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801c68:	a1 04 50 80 00       	mov    0x805004,%eax
  801c6d:	8b 40 48             	mov    0x48(%eax),%eax
  801c70:	83 ec 04             	sub    $0x4,%esp
  801c73:	53                   	push   %ebx
  801c74:	50                   	push   %eax
  801c75:	68 c1 33 80 00       	push   $0x8033c1
  801c7a:	e8 a4 e9 ff ff       	call   800623 <cprintf>
		return -E_INVAL;
  801c7f:	83 c4 10             	add    $0x10,%esp
  801c82:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c87:	eb da                	jmp    801c63 <write+0x55>
		return -E_NOT_SUPP;
  801c89:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c8e:	eb d3                	jmp    801c63 <write+0x55>

00801c90 <seek>:

int
seek(int fdnum, off_t offset)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c96:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c99:	50                   	push   %eax
  801c9a:	ff 75 08             	pushl  0x8(%ebp)
  801c9d:	e8 35 fc ff ff       	call   8018d7 <fd_lookup>
  801ca2:	83 c4 10             	add    $0x10,%esp
  801ca5:	85 c0                	test   %eax,%eax
  801ca7:	78 0e                	js     801cb7 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801ca9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801caf:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801cb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb7:	c9                   	leave  
  801cb8:	c3                   	ret    

00801cb9 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
  801cbc:	53                   	push   %ebx
  801cbd:	83 ec 1c             	sub    $0x1c,%esp
  801cc0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801cc3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cc6:	50                   	push   %eax
  801cc7:	53                   	push   %ebx
  801cc8:	e8 0a fc ff ff       	call   8018d7 <fd_lookup>
  801ccd:	83 c4 10             	add    $0x10,%esp
  801cd0:	85 c0                	test   %eax,%eax
  801cd2:	78 37                	js     801d0b <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801cd4:	83 ec 08             	sub    $0x8,%esp
  801cd7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cda:	50                   	push   %eax
  801cdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cde:	ff 30                	pushl  (%eax)
  801ce0:	e8 42 fc ff ff       	call   801927 <dev_lookup>
  801ce5:	83 c4 10             	add    $0x10,%esp
  801ce8:	85 c0                	test   %eax,%eax
  801cea:	78 1f                	js     801d0b <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801cec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cef:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801cf3:	74 1b                	je     801d10 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801cf5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cf8:	8b 52 18             	mov    0x18(%edx),%edx
  801cfb:	85 d2                	test   %edx,%edx
  801cfd:	74 32                	je     801d31 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801cff:	83 ec 08             	sub    $0x8,%esp
  801d02:	ff 75 0c             	pushl  0xc(%ebp)
  801d05:	50                   	push   %eax
  801d06:	ff d2                	call   *%edx
  801d08:	83 c4 10             	add    $0x10,%esp
}
  801d0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    
			thisenv->env_id, fdnum);
  801d10:	a1 04 50 80 00       	mov    0x805004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801d15:	8b 40 48             	mov    0x48(%eax),%eax
  801d18:	83 ec 04             	sub    $0x4,%esp
  801d1b:	53                   	push   %ebx
  801d1c:	50                   	push   %eax
  801d1d:	68 84 33 80 00       	push   $0x803384
  801d22:	e8 fc e8 ff ff       	call   800623 <cprintf>
		return -E_INVAL;
  801d27:	83 c4 10             	add    $0x10,%esp
  801d2a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d2f:	eb da                	jmp    801d0b <ftruncate+0x52>
		return -E_NOT_SUPP;
  801d31:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d36:	eb d3                	jmp    801d0b <ftruncate+0x52>

00801d38 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
  801d3b:	53                   	push   %ebx
  801d3c:	83 ec 1c             	sub    $0x1c,%esp
  801d3f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d42:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d45:	50                   	push   %eax
  801d46:	ff 75 08             	pushl  0x8(%ebp)
  801d49:	e8 89 fb ff ff       	call   8018d7 <fd_lookup>
  801d4e:	83 c4 10             	add    $0x10,%esp
  801d51:	85 c0                	test   %eax,%eax
  801d53:	78 4b                	js     801da0 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d55:	83 ec 08             	sub    $0x8,%esp
  801d58:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d5b:	50                   	push   %eax
  801d5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d5f:	ff 30                	pushl  (%eax)
  801d61:	e8 c1 fb ff ff       	call   801927 <dev_lookup>
  801d66:	83 c4 10             	add    $0x10,%esp
  801d69:	85 c0                	test   %eax,%eax
  801d6b:	78 33                	js     801da0 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d70:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801d74:	74 2f                	je     801da5 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801d76:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801d79:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801d80:	00 00 00 
	stat->st_isdir = 0;
  801d83:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d8a:	00 00 00 
	stat->st_dev = dev;
  801d8d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801d93:	83 ec 08             	sub    $0x8,%esp
  801d96:	53                   	push   %ebx
  801d97:	ff 75 f0             	pushl  -0x10(%ebp)
  801d9a:	ff 50 14             	call   *0x14(%eax)
  801d9d:	83 c4 10             	add    $0x10,%esp
}
  801da0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    
		return -E_NOT_SUPP;
  801da5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801daa:	eb f4                	jmp    801da0 <fstat+0x68>

00801dac <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801dac:	55                   	push   %ebp
  801dad:	89 e5                	mov    %esp,%ebp
  801daf:	56                   	push   %esi
  801db0:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801db1:	83 ec 08             	sub    $0x8,%esp
  801db4:	6a 00                	push   $0x0
  801db6:	ff 75 08             	pushl  0x8(%ebp)
  801db9:	e8 bb 01 00 00       	call   801f79 <open>
  801dbe:	89 c3                	mov    %eax,%ebx
  801dc0:	83 c4 10             	add    $0x10,%esp
  801dc3:	85 c0                	test   %eax,%eax
  801dc5:	78 1b                	js     801de2 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801dc7:	83 ec 08             	sub    $0x8,%esp
  801dca:	ff 75 0c             	pushl  0xc(%ebp)
  801dcd:	50                   	push   %eax
  801dce:	e8 65 ff ff ff       	call   801d38 <fstat>
  801dd3:	89 c6                	mov    %eax,%esi
	close(fd);
  801dd5:	89 1c 24             	mov    %ebx,(%esp)
  801dd8:	e8 27 fc ff ff       	call   801a04 <close>
	return r;
  801ddd:	83 c4 10             	add    $0x10,%esp
  801de0:	89 f3                	mov    %esi,%ebx
}
  801de2:	89 d8                	mov    %ebx,%eax
  801de4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801de7:	5b                   	pop    %ebx
  801de8:	5e                   	pop    %esi
  801de9:	5d                   	pop    %ebp
  801dea:	c3                   	ret    

00801deb <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
  801dee:	56                   	push   %esi
  801def:	53                   	push   %ebx
  801df0:	89 c6                	mov    %eax,%esi
  801df2:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801df4:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801dfb:	74 27                	je     801e24 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801dfd:	6a 07                	push   $0x7
  801dff:	68 00 60 80 00       	push   $0x806000
  801e04:	56                   	push   %esi
  801e05:	ff 35 00 50 80 00    	pushl  0x805000
  801e0b:	e8 08 0c 00 00       	call   802a18 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801e10:	83 c4 0c             	add    $0xc,%esp
  801e13:	6a 00                	push   $0x0
  801e15:	53                   	push   %ebx
  801e16:	6a 00                	push   $0x0
  801e18:	e8 92 0b 00 00       	call   8029af <ipc_recv>
}
  801e1d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e20:	5b                   	pop    %ebx
  801e21:	5e                   	pop    %esi
  801e22:	5d                   	pop    %ebp
  801e23:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801e24:	83 ec 0c             	sub    $0xc,%esp
  801e27:	6a 01                	push   $0x1
  801e29:	e8 42 0c 00 00       	call   802a70 <ipc_find_env>
  801e2e:	a3 00 50 80 00       	mov    %eax,0x805000
  801e33:	83 c4 10             	add    $0x10,%esp
  801e36:	eb c5                	jmp    801dfd <fsipc+0x12>

00801e38 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
  801e3b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e41:	8b 40 0c             	mov    0xc(%eax),%eax
  801e44:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801e49:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e4c:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801e51:	ba 00 00 00 00       	mov    $0x0,%edx
  801e56:	b8 02 00 00 00       	mov    $0x2,%eax
  801e5b:	e8 8b ff ff ff       	call   801deb <fsipc>
}
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <devfile_flush>:
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
  801e65:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e68:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6b:	8b 40 0c             	mov    0xc(%eax),%eax
  801e6e:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801e73:	ba 00 00 00 00       	mov    $0x0,%edx
  801e78:	b8 06 00 00 00       	mov    $0x6,%eax
  801e7d:	e8 69 ff ff ff       	call   801deb <fsipc>
}
  801e82:	c9                   	leave  
  801e83:	c3                   	ret    

00801e84 <devfile_stat>:
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
  801e87:	53                   	push   %ebx
  801e88:	83 ec 04             	sub    $0x4,%esp
  801e8b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e91:	8b 40 0c             	mov    0xc(%eax),%eax
  801e94:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801e99:	ba 00 00 00 00       	mov    $0x0,%edx
  801e9e:	b8 05 00 00 00       	mov    $0x5,%eax
  801ea3:	e8 43 ff ff ff       	call   801deb <fsipc>
  801ea8:	85 c0                	test   %eax,%eax
  801eaa:	78 2c                	js     801ed8 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801eac:	83 ec 08             	sub    $0x8,%esp
  801eaf:	68 00 60 80 00       	push   $0x806000
  801eb4:	53                   	push   %ebx
  801eb5:	e8 c8 ee ff ff       	call   800d82 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801eba:	a1 80 60 80 00       	mov    0x806080,%eax
  801ebf:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801ec5:	a1 84 60 80 00       	mov    0x806084,%eax
  801eca:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801ed0:	83 c4 10             	add    $0x10,%esp
  801ed3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ed8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801edb:	c9                   	leave  
  801edc:	c3                   	ret    

00801edd <devfile_write>:
{
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
  801ee0:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  801ee3:	68 f0 33 80 00       	push   $0x8033f0
  801ee8:	68 90 00 00 00       	push   $0x90
  801eed:	68 0e 34 80 00       	push   $0x80340e
  801ef2:	e8 36 e6 ff ff       	call   80052d <_panic>

00801ef7 <devfile_read>:
{
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
  801efa:	56                   	push   %esi
  801efb:	53                   	push   %ebx
  801efc:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801eff:	8b 45 08             	mov    0x8(%ebp),%eax
  801f02:	8b 40 0c             	mov    0xc(%eax),%eax
  801f05:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801f0a:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801f10:	ba 00 00 00 00       	mov    $0x0,%edx
  801f15:	b8 03 00 00 00       	mov    $0x3,%eax
  801f1a:	e8 cc fe ff ff       	call   801deb <fsipc>
  801f1f:	89 c3                	mov    %eax,%ebx
  801f21:	85 c0                	test   %eax,%eax
  801f23:	78 1f                	js     801f44 <devfile_read+0x4d>
	assert(r <= n);
  801f25:	39 f0                	cmp    %esi,%eax
  801f27:	77 24                	ja     801f4d <devfile_read+0x56>
	assert(r <= PGSIZE);
  801f29:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f2e:	7f 33                	jg     801f63 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801f30:	83 ec 04             	sub    $0x4,%esp
  801f33:	50                   	push   %eax
  801f34:	68 00 60 80 00       	push   $0x806000
  801f39:	ff 75 0c             	pushl  0xc(%ebp)
  801f3c:	e8 cf ef ff ff       	call   800f10 <memmove>
	return r;
  801f41:	83 c4 10             	add    $0x10,%esp
}
  801f44:	89 d8                	mov    %ebx,%eax
  801f46:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f49:	5b                   	pop    %ebx
  801f4a:	5e                   	pop    %esi
  801f4b:	5d                   	pop    %ebp
  801f4c:	c3                   	ret    
	assert(r <= n);
  801f4d:	68 19 34 80 00       	push   $0x803419
  801f52:	68 20 34 80 00       	push   $0x803420
  801f57:	6a 7c                	push   $0x7c
  801f59:	68 0e 34 80 00       	push   $0x80340e
  801f5e:	e8 ca e5 ff ff       	call   80052d <_panic>
	assert(r <= PGSIZE);
  801f63:	68 35 34 80 00       	push   $0x803435
  801f68:	68 20 34 80 00       	push   $0x803420
  801f6d:	6a 7d                	push   $0x7d
  801f6f:	68 0e 34 80 00       	push   $0x80340e
  801f74:	e8 b4 e5 ff ff       	call   80052d <_panic>

00801f79 <open>:
{
  801f79:	55                   	push   %ebp
  801f7a:	89 e5                	mov    %esp,%ebp
  801f7c:	56                   	push   %esi
  801f7d:	53                   	push   %ebx
  801f7e:	83 ec 1c             	sub    $0x1c,%esp
  801f81:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801f84:	56                   	push   %esi
  801f85:	e8 bf ed ff ff       	call   800d49 <strlen>
  801f8a:	83 c4 10             	add    $0x10,%esp
  801f8d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f92:	7f 6c                	jg     802000 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801f94:	83 ec 0c             	sub    $0xc,%esp
  801f97:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f9a:	50                   	push   %eax
  801f9b:	e8 e5 f8 ff ff       	call   801885 <fd_alloc>
  801fa0:	89 c3                	mov    %eax,%ebx
  801fa2:	83 c4 10             	add    $0x10,%esp
  801fa5:	85 c0                	test   %eax,%eax
  801fa7:	78 3c                	js     801fe5 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801fa9:	83 ec 08             	sub    $0x8,%esp
  801fac:	56                   	push   %esi
  801fad:	68 00 60 80 00       	push   $0x806000
  801fb2:	e8 cb ed ff ff       	call   800d82 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801fb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fba:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801fbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fc2:	b8 01 00 00 00       	mov    $0x1,%eax
  801fc7:	e8 1f fe ff ff       	call   801deb <fsipc>
  801fcc:	89 c3                	mov    %eax,%ebx
  801fce:	83 c4 10             	add    $0x10,%esp
  801fd1:	85 c0                	test   %eax,%eax
  801fd3:	78 19                	js     801fee <open+0x75>
	return fd2num(fd);
  801fd5:	83 ec 0c             	sub    $0xc,%esp
  801fd8:	ff 75 f4             	pushl  -0xc(%ebp)
  801fdb:	e8 7e f8 ff ff       	call   80185e <fd2num>
  801fe0:	89 c3                	mov    %eax,%ebx
  801fe2:	83 c4 10             	add    $0x10,%esp
}
  801fe5:	89 d8                	mov    %ebx,%eax
  801fe7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fea:	5b                   	pop    %ebx
  801feb:	5e                   	pop    %esi
  801fec:	5d                   	pop    %ebp
  801fed:	c3                   	ret    
		fd_close(fd, 0);
  801fee:	83 ec 08             	sub    $0x8,%esp
  801ff1:	6a 00                	push   $0x0
  801ff3:	ff 75 f4             	pushl  -0xc(%ebp)
  801ff6:	e8 82 f9 ff ff       	call   80197d <fd_close>
		return r;
  801ffb:	83 c4 10             	add    $0x10,%esp
  801ffe:	eb e5                	jmp    801fe5 <open+0x6c>
		return -E_BAD_PATH;
  802000:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  802005:	eb de                	jmp    801fe5 <open+0x6c>

00802007 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
  80200a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80200d:	ba 00 00 00 00       	mov    $0x0,%edx
  802012:	b8 08 00 00 00       	mov    $0x8,%eax
  802017:	e8 cf fd ff ff       	call   801deb <fsipc>
}
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
  802021:	57                   	push   %edi
  802022:	56                   	push   %esi
  802023:	53                   	push   %ebx
  802024:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  80202a:	6a 00                	push   $0x0
  80202c:	ff 75 08             	pushl  0x8(%ebp)
  80202f:	e8 45 ff ff ff       	call   801f79 <open>
  802034:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  80203a:	83 c4 10             	add    $0x10,%esp
  80203d:	85 c0                	test   %eax,%eax
  80203f:	0f 88 71 04 00 00    	js     8024b6 <spawn+0x498>
  802045:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802047:	83 ec 04             	sub    $0x4,%esp
  80204a:	68 00 02 00 00       	push   $0x200
  80204f:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  802055:	50                   	push   %eax
  802056:	52                   	push   %edx
  802057:	e8 6d fb ff ff       	call   801bc9 <readn>
  80205c:	83 c4 10             	add    $0x10,%esp
  80205f:	3d 00 02 00 00       	cmp    $0x200,%eax
  802064:	75 5f                	jne    8020c5 <spawn+0xa7>
	    || elf->e_magic != ELF_MAGIC) {
  802066:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  80206d:	45 4c 46 
  802070:	75 53                	jne    8020c5 <spawn+0xa7>
  802072:	b8 07 00 00 00       	mov    $0x7,%eax
  802077:	cd 30                	int    $0x30
  802079:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  80207f:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802085:	85 c0                	test   %eax,%eax
  802087:	0f 88 1d 04 00 00    	js     8024aa <spawn+0x48c>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80208d:	25 ff 03 00 00       	and    $0x3ff,%eax
  802092:	89 c6                	mov    %eax,%esi
  802094:	c1 e6 07             	shl    $0x7,%esi
  802097:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  80209d:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8020a3:	b9 11 00 00 00       	mov    $0x11,%ecx
  8020a8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8020aa:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8020b0:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8020b6:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  8020bb:	be 00 00 00 00       	mov    $0x0,%esi
  8020c0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8020c3:	eb 4b                	jmp    802110 <spawn+0xf2>
		close(fd);
  8020c5:	83 ec 0c             	sub    $0xc,%esp
  8020c8:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8020ce:	e8 31 f9 ff ff       	call   801a04 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8020d3:	83 c4 0c             	add    $0xc,%esp
  8020d6:	68 7f 45 4c 46       	push   $0x464c457f
  8020db:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  8020e1:	68 41 34 80 00       	push   $0x803441
  8020e6:	e8 38 e5 ff ff       	call   800623 <cprintf>
		return -E_NOT_EXEC;
  8020eb:	83 c4 10             	add    $0x10,%esp
  8020ee:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  8020f5:	ff ff ff 
  8020f8:	e9 b9 03 00 00       	jmp    8024b6 <spawn+0x498>
		string_size += strlen(argv[argc]) + 1;
  8020fd:	83 ec 0c             	sub    $0xc,%esp
  802100:	50                   	push   %eax
  802101:	e8 43 ec ff ff       	call   800d49 <strlen>
  802106:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  80210a:	83 c3 01             	add    $0x1,%ebx
  80210d:	83 c4 10             	add    $0x10,%esp
  802110:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  802117:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  80211a:	85 c0                	test   %eax,%eax
  80211c:	75 df                	jne    8020fd <spawn+0xdf>
  80211e:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  802124:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  80212a:	bf 00 10 40 00       	mov    $0x401000,%edi
  80212f:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802131:	89 fa                	mov    %edi,%edx
  802133:	83 e2 fc             	and    $0xfffffffc,%edx
  802136:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  80213d:	29 c2                	sub    %eax,%edx
  80213f:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802145:	8d 42 f8             	lea    -0x8(%edx),%eax
  802148:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  80214d:	0f 86 86 03 00 00    	jbe    8024d9 <spawn+0x4bb>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802153:	83 ec 04             	sub    $0x4,%esp
  802156:	6a 07                	push   $0x7
  802158:	68 00 00 40 00       	push   $0x400000
  80215d:	6a 00                	push   $0x0
  80215f:	e8 10 f0 ff ff       	call   801174 <sys_page_alloc>
  802164:	83 c4 10             	add    $0x10,%esp
  802167:	85 c0                	test   %eax,%eax
  802169:	0f 88 6f 03 00 00    	js     8024de <spawn+0x4c0>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80216f:	be 00 00 00 00       	mov    $0x0,%esi
  802174:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  80217a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80217d:	eb 30                	jmp    8021af <spawn+0x191>
		argv_store[i] = UTEMP2USTACK(string_store);
  80217f:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802185:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  80218b:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  80218e:	83 ec 08             	sub    $0x8,%esp
  802191:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802194:	57                   	push   %edi
  802195:	e8 e8 eb ff ff       	call   800d82 <strcpy>
		string_store += strlen(argv[i]) + 1;
  80219a:	83 c4 04             	add    $0x4,%esp
  80219d:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8021a0:	e8 a4 eb ff ff       	call   800d49 <strlen>
  8021a5:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  8021a9:	83 c6 01             	add    $0x1,%esi
  8021ac:	83 c4 10             	add    $0x10,%esp
  8021af:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  8021b5:	7f c8                	jg     80217f <spawn+0x161>
	}
	argv_store[argc] = 0;
  8021b7:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8021bd:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  8021c3:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8021ca:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  8021d0:	0f 85 86 00 00 00    	jne    80225c <spawn+0x23e>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8021d6:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  8021dc:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  8021e2:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  8021e5:	89 c8                	mov    %ecx,%eax
  8021e7:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  8021ed:	89 48 f8             	mov    %ecx,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8021f0:	2d 08 30 80 11       	sub    $0x11803008,%eax
  8021f5:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8021fb:	83 ec 0c             	sub    $0xc,%esp
  8021fe:	6a 07                	push   $0x7
  802200:	68 00 d0 bf ee       	push   $0xeebfd000
  802205:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80220b:	68 00 00 40 00       	push   $0x400000
  802210:	6a 00                	push   $0x0
  802212:	e8 a0 ef ff ff       	call   8011b7 <sys_page_map>
  802217:	89 c3                	mov    %eax,%ebx
  802219:	83 c4 20             	add    $0x20,%esp
  80221c:	85 c0                	test   %eax,%eax
  80221e:	0f 88 c2 02 00 00    	js     8024e6 <spawn+0x4c8>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802224:	83 ec 08             	sub    $0x8,%esp
  802227:	68 00 00 40 00       	push   $0x400000
  80222c:	6a 00                	push   $0x0
  80222e:	e8 c6 ef ff ff       	call   8011f9 <sys_page_unmap>
  802233:	89 c3                	mov    %eax,%ebx
  802235:	83 c4 10             	add    $0x10,%esp
  802238:	85 c0                	test   %eax,%eax
  80223a:	0f 88 a6 02 00 00    	js     8024e6 <spawn+0x4c8>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802240:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  802246:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80224d:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  802254:	00 00 00 
  802257:	e9 4f 01 00 00       	jmp    8023ab <spawn+0x38d>
	assert(string_store == (char*)UTEMP + PGSIZE);
  80225c:	68 b8 34 80 00       	push   $0x8034b8
  802261:	68 20 34 80 00       	push   $0x803420
  802266:	68 f2 00 00 00       	push   $0xf2
  80226b:	68 5b 34 80 00       	push   $0x80345b
  802270:	e8 b8 e2 ff ff       	call   80052d <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802275:	83 ec 04             	sub    $0x4,%esp
  802278:	6a 07                	push   $0x7
  80227a:	68 00 00 40 00       	push   $0x400000
  80227f:	6a 00                	push   $0x0
  802281:	e8 ee ee ff ff       	call   801174 <sys_page_alloc>
  802286:	83 c4 10             	add    $0x10,%esp
  802289:	85 c0                	test   %eax,%eax
  80228b:	0f 88 33 02 00 00    	js     8024c4 <spawn+0x4a6>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802291:	83 ec 08             	sub    $0x8,%esp
  802294:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  80229a:	01 f0                	add    %esi,%eax
  80229c:	50                   	push   %eax
  80229d:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8022a3:	e8 e8 f9 ff ff       	call   801c90 <seek>
  8022a8:	83 c4 10             	add    $0x10,%esp
  8022ab:	85 c0                	test   %eax,%eax
  8022ad:	0f 88 18 02 00 00    	js     8024cb <spawn+0x4ad>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8022b3:	83 ec 04             	sub    $0x4,%esp
  8022b6:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8022bc:	29 f0                	sub    %esi,%eax
  8022be:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8022c3:	ba 00 10 00 00       	mov    $0x1000,%edx
  8022c8:	0f 47 c2             	cmova  %edx,%eax
  8022cb:	50                   	push   %eax
  8022cc:	68 00 00 40 00       	push   $0x400000
  8022d1:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8022d7:	e8 ed f8 ff ff       	call   801bc9 <readn>
  8022dc:	83 c4 10             	add    $0x10,%esp
  8022df:	85 c0                	test   %eax,%eax
  8022e1:	0f 88 eb 01 00 00    	js     8024d2 <spawn+0x4b4>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8022e7:	83 ec 0c             	sub    $0xc,%esp
  8022ea:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8022f0:	53                   	push   %ebx
  8022f1:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  8022f7:	68 00 00 40 00       	push   $0x400000
  8022fc:	6a 00                	push   $0x0
  8022fe:	e8 b4 ee ff ff       	call   8011b7 <sys_page_map>
  802303:	83 c4 20             	add    $0x20,%esp
  802306:	85 c0                	test   %eax,%eax
  802308:	78 7c                	js     802386 <spawn+0x368>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  80230a:	83 ec 08             	sub    $0x8,%esp
  80230d:	68 00 00 40 00       	push   $0x400000
  802312:	6a 00                	push   $0x0
  802314:	e8 e0 ee ff ff       	call   8011f9 <sys_page_unmap>
  802319:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  80231c:	81 c7 00 10 00 00    	add    $0x1000,%edi
  802322:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802328:	89 fe                	mov    %edi,%esi
  80232a:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  802330:	76 69                	jbe    80239b <spawn+0x37d>
		if (i >= filesz) {
  802332:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  802338:	0f 87 37 ff ff ff    	ja     802275 <spawn+0x257>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  80233e:	83 ec 04             	sub    $0x4,%esp
  802341:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802347:	53                   	push   %ebx
  802348:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  80234e:	e8 21 ee ff ff       	call   801174 <sys_page_alloc>
  802353:	83 c4 10             	add    $0x10,%esp
  802356:	85 c0                	test   %eax,%eax
  802358:	79 c2                	jns    80231c <spawn+0x2fe>
  80235a:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  80235c:	83 ec 0c             	sub    $0xc,%esp
  80235f:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802365:	e8 8b ed ff ff       	call   8010f5 <sys_env_destroy>
	close(fd);
  80236a:	83 c4 04             	add    $0x4,%esp
  80236d:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802373:	e8 8c f6 ff ff       	call   801a04 <close>
	return r;
  802378:	83 c4 10             	add    $0x10,%esp
  80237b:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  802381:	e9 30 01 00 00       	jmp    8024b6 <spawn+0x498>
				panic("spawn: sys_page_map data: %e", r);
  802386:	50                   	push   %eax
  802387:	68 67 34 80 00       	push   $0x803467
  80238c:	68 25 01 00 00       	push   $0x125
  802391:	68 5b 34 80 00       	push   $0x80345b
  802396:	e8 92 e1 ff ff       	call   80052d <_panic>
  80239b:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8023a1:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  8023a8:	83 c6 20             	add    $0x20,%esi
  8023ab:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  8023b2:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  8023b8:	7e 6d                	jle    802427 <spawn+0x409>
		if (ph->p_type != ELF_PROG_LOAD)
  8023ba:	83 3e 01             	cmpl   $0x1,(%esi)
  8023bd:	75 e2                	jne    8023a1 <spawn+0x383>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8023bf:	8b 46 18             	mov    0x18(%esi),%eax
  8023c2:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  8023c5:	83 f8 01             	cmp    $0x1,%eax
  8023c8:	19 c0                	sbb    %eax,%eax
  8023ca:	83 e0 fe             	and    $0xfffffffe,%eax
  8023cd:	83 c0 07             	add    $0x7,%eax
  8023d0:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  8023d6:	8b 4e 04             	mov    0x4(%esi),%ecx
  8023d9:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  8023df:	8b 56 10             	mov    0x10(%esi),%edx
  8023e2:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  8023e8:	8b 7e 14             	mov    0x14(%esi),%edi
  8023eb:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  8023f1:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  8023f4:	89 d8                	mov    %ebx,%eax
  8023f6:	25 ff 0f 00 00       	and    $0xfff,%eax
  8023fb:	74 1a                	je     802417 <spawn+0x3f9>
		va -= i;
  8023fd:	29 c3                	sub    %eax,%ebx
		memsz += i;
  8023ff:	01 c7                	add    %eax,%edi
  802401:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  802407:	01 c2                	add    %eax,%edx
  802409:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  80240f:	29 c1                	sub    %eax,%ecx
  802411:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  802417:	bf 00 00 00 00       	mov    $0x0,%edi
  80241c:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  802422:	e9 01 ff ff ff       	jmp    802328 <spawn+0x30a>
	close(fd);
  802427:	83 ec 0c             	sub    $0xc,%esp
  80242a:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802430:	e8 cf f5 ff ff       	call   801a04 <close>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  802435:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  80243c:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  80243f:	83 c4 08             	add    $0x8,%esp
  802442:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802448:	50                   	push   %eax
  802449:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80244f:	e8 29 ee ff ff       	call   80127d <sys_env_set_trapframe>
  802454:	83 c4 10             	add    $0x10,%esp
  802457:	85 c0                	test   %eax,%eax
  802459:	78 25                	js     802480 <spawn+0x462>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  80245b:	83 ec 08             	sub    $0x8,%esp
  80245e:	6a 02                	push   $0x2
  802460:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802466:	e8 d0 ed ff ff       	call   80123b <sys_env_set_status>
  80246b:	83 c4 10             	add    $0x10,%esp
  80246e:	85 c0                	test   %eax,%eax
  802470:	78 23                	js     802495 <spawn+0x477>
	return child;
  802472:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802478:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  80247e:	eb 36                	jmp    8024b6 <spawn+0x498>
		panic("sys_env_set_trapframe: %e", r);
  802480:	50                   	push   %eax
  802481:	68 84 34 80 00       	push   $0x803484
  802486:	68 86 00 00 00       	push   $0x86
  80248b:	68 5b 34 80 00       	push   $0x80345b
  802490:	e8 98 e0 ff ff       	call   80052d <_panic>
		panic("sys_env_set_status: %e", r);
  802495:	50                   	push   %eax
  802496:	68 9e 34 80 00       	push   $0x80349e
  80249b:	68 89 00 00 00       	push   $0x89
  8024a0:	68 5b 34 80 00       	push   $0x80345b
  8024a5:	e8 83 e0 ff ff       	call   80052d <_panic>
		return r;
  8024aa:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8024b0:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  8024b6:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8024bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024bf:	5b                   	pop    %ebx
  8024c0:	5e                   	pop    %esi
  8024c1:	5f                   	pop    %edi
  8024c2:	5d                   	pop    %ebp
  8024c3:	c3                   	ret    
  8024c4:	89 c7                	mov    %eax,%edi
  8024c6:	e9 91 fe ff ff       	jmp    80235c <spawn+0x33e>
  8024cb:	89 c7                	mov    %eax,%edi
  8024cd:	e9 8a fe ff ff       	jmp    80235c <spawn+0x33e>
  8024d2:	89 c7                	mov    %eax,%edi
  8024d4:	e9 83 fe ff ff       	jmp    80235c <spawn+0x33e>
		return -E_NO_MEM;
  8024d9:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8024de:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8024e4:	eb d0                	jmp    8024b6 <spawn+0x498>
	sys_page_unmap(0, UTEMP);
  8024e6:	83 ec 08             	sub    $0x8,%esp
  8024e9:	68 00 00 40 00       	push   $0x400000
  8024ee:	6a 00                	push   $0x0
  8024f0:	e8 04 ed ff ff       	call   8011f9 <sys_page_unmap>
  8024f5:	83 c4 10             	add    $0x10,%esp
  8024f8:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  8024fe:	eb b6                	jmp    8024b6 <spawn+0x498>

00802500 <spawnl>:
{
  802500:	55                   	push   %ebp
  802501:	89 e5                	mov    %esp,%ebp
  802503:	57                   	push   %edi
  802504:	56                   	push   %esi
  802505:	53                   	push   %ebx
  802506:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  802509:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  80250c:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  802511:	8d 4a 04             	lea    0x4(%edx),%ecx
  802514:	83 3a 00             	cmpl   $0x0,(%edx)
  802517:	74 07                	je     802520 <spawnl+0x20>
		argc++;
  802519:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  80251c:	89 ca                	mov    %ecx,%edx
  80251e:	eb f1                	jmp    802511 <spawnl+0x11>
	const char *argv[argc+2];
  802520:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  802527:	83 e2 f0             	and    $0xfffffff0,%edx
  80252a:	29 d4                	sub    %edx,%esp
  80252c:	8d 54 24 03          	lea    0x3(%esp),%edx
  802530:	c1 ea 02             	shr    $0x2,%edx
  802533:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  80253a:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  80253c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80253f:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  802546:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  80254d:	00 
	va_start(vl, arg0);
  80254e:	8d 4d 10             	lea    0x10(%ebp),%ecx
  802551:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  802553:	b8 00 00 00 00       	mov    $0x0,%eax
  802558:	eb 0b                	jmp    802565 <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  80255a:	83 c0 01             	add    $0x1,%eax
  80255d:	8b 39                	mov    (%ecx),%edi
  80255f:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  802562:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  802565:	39 d0                	cmp    %edx,%eax
  802567:	75 f1                	jne    80255a <spawnl+0x5a>
	return spawn(prog, argv);
  802569:	83 ec 08             	sub    $0x8,%esp
  80256c:	56                   	push   %esi
  80256d:	ff 75 08             	pushl  0x8(%ebp)
  802570:	e8 a9 fa ff ff       	call   80201e <spawn>
}
  802575:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802578:	5b                   	pop    %ebx
  802579:	5e                   	pop    %esi
  80257a:	5f                   	pop    %edi
  80257b:	5d                   	pop    %ebp
  80257c:	c3                   	ret    

0080257d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80257d:	55                   	push   %ebp
  80257e:	89 e5                	mov    %esp,%ebp
  802580:	56                   	push   %esi
  802581:	53                   	push   %ebx
  802582:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802585:	83 ec 0c             	sub    $0xc,%esp
  802588:	ff 75 08             	pushl  0x8(%ebp)
  80258b:	e8 de f2 ff ff       	call   80186e <fd2data>
  802590:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802592:	83 c4 08             	add    $0x8,%esp
  802595:	68 de 34 80 00       	push   $0x8034de
  80259a:	53                   	push   %ebx
  80259b:	e8 e2 e7 ff ff       	call   800d82 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8025a0:	8b 46 04             	mov    0x4(%esi),%eax
  8025a3:	2b 06                	sub    (%esi),%eax
  8025a5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8025ab:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8025b2:	00 00 00 
	stat->st_dev = &devpipe;
  8025b5:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8025bc:	40 80 00 
	return 0;
}
  8025bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025c7:	5b                   	pop    %ebx
  8025c8:	5e                   	pop    %esi
  8025c9:	5d                   	pop    %ebp
  8025ca:	c3                   	ret    

008025cb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8025cb:	55                   	push   %ebp
  8025cc:	89 e5                	mov    %esp,%ebp
  8025ce:	53                   	push   %ebx
  8025cf:	83 ec 0c             	sub    $0xc,%esp
  8025d2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8025d5:	53                   	push   %ebx
  8025d6:	6a 00                	push   $0x0
  8025d8:	e8 1c ec ff ff       	call   8011f9 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8025dd:	89 1c 24             	mov    %ebx,(%esp)
  8025e0:	e8 89 f2 ff ff       	call   80186e <fd2data>
  8025e5:	83 c4 08             	add    $0x8,%esp
  8025e8:	50                   	push   %eax
  8025e9:	6a 00                	push   $0x0
  8025eb:	e8 09 ec ff ff       	call   8011f9 <sys_page_unmap>
}
  8025f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025f3:	c9                   	leave  
  8025f4:	c3                   	ret    

008025f5 <_pipeisclosed>:
{
  8025f5:	55                   	push   %ebp
  8025f6:	89 e5                	mov    %esp,%ebp
  8025f8:	57                   	push   %edi
  8025f9:	56                   	push   %esi
  8025fa:	53                   	push   %ebx
  8025fb:	83 ec 1c             	sub    $0x1c,%esp
  8025fe:	89 c7                	mov    %eax,%edi
  802600:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802602:	a1 04 50 80 00       	mov    0x805004,%eax
  802607:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80260a:	83 ec 0c             	sub    $0xc,%esp
  80260d:	57                   	push   %edi
  80260e:	e8 98 04 00 00       	call   802aab <pageref>
  802613:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802616:	89 34 24             	mov    %esi,(%esp)
  802619:	e8 8d 04 00 00       	call   802aab <pageref>
		nn = thisenv->env_runs;
  80261e:	8b 15 04 50 80 00    	mov    0x805004,%edx
  802624:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802627:	83 c4 10             	add    $0x10,%esp
  80262a:	39 cb                	cmp    %ecx,%ebx
  80262c:	74 1b                	je     802649 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80262e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802631:	75 cf                	jne    802602 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802633:	8b 42 58             	mov    0x58(%edx),%eax
  802636:	6a 01                	push   $0x1
  802638:	50                   	push   %eax
  802639:	53                   	push   %ebx
  80263a:	68 e5 34 80 00       	push   $0x8034e5
  80263f:	e8 df df ff ff       	call   800623 <cprintf>
  802644:	83 c4 10             	add    $0x10,%esp
  802647:	eb b9                	jmp    802602 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802649:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80264c:	0f 94 c0             	sete   %al
  80264f:	0f b6 c0             	movzbl %al,%eax
}
  802652:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802655:	5b                   	pop    %ebx
  802656:	5e                   	pop    %esi
  802657:	5f                   	pop    %edi
  802658:	5d                   	pop    %ebp
  802659:	c3                   	ret    

0080265a <devpipe_write>:
{
  80265a:	55                   	push   %ebp
  80265b:	89 e5                	mov    %esp,%ebp
  80265d:	57                   	push   %edi
  80265e:	56                   	push   %esi
  80265f:	53                   	push   %ebx
  802660:	83 ec 28             	sub    $0x28,%esp
  802663:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802666:	56                   	push   %esi
  802667:	e8 02 f2 ff ff       	call   80186e <fd2data>
  80266c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80266e:	83 c4 10             	add    $0x10,%esp
  802671:	bf 00 00 00 00       	mov    $0x0,%edi
  802676:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802679:	74 4f                	je     8026ca <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80267b:	8b 43 04             	mov    0x4(%ebx),%eax
  80267e:	8b 0b                	mov    (%ebx),%ecx
  802680:	8d 51 20             	lea    0x20(%ecx),%edx
  802683:	39 d0                	cmp    %edx,%eax
  802685:	72 14                	jb     80269b <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802687:	89 da                	mov    %ebx,%edx
  802689:	89 f0                	mov    %esi,%eax
  80268b:	e8 65 ff ff ff       	call   8025f5 <_pipeisclosed>
  802690:	85 c0                	test   %eax,%eax
  802692:	75 3b                	jne    8026cf <devpipe_write+0x75>
			sys_yield();
  802694:	e8 bc ea ff ff       	call   801155 <sys_yield>
  802699:	eb e0                	jmp    80267b <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80269b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80269e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8026a2:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8026a5:	89 c2                	mov    %eax,%edx
  8026a7:	c1 fa 1f             	sar    $0x1f,%edx
  8026aa:	89 d1                	mov    %edx,%ecx
  8026ac:	c1 e9 1b             	shr    $0x1b,%ecx
  8026af:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8026b2:	83 e2 1f             	and    $0x1f,%edx
  8026b5:	29 ca                	sub    %ecx,%edx
  8026b7:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8026bb:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8026bf:	83 c0 01             	add    $0x1,%eax
  8026c2:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8026c5:	83 c7 01             	add    $0x1,%edi
  8026c8:	eb ac                	jmp    802676 <devpipe_write+0x1c>
	return i;
  8026ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8026cd:	eb 05                	jmp    8026d4 <devpipe_write+0x7a>
				return 0;
  8026cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026d7:	5b                   	pop    %ebx
  8026d8:	5e                   	pop    %esi
  8026d9:	5f                   	pop    %edi
  8026da:	5d                   	pop    %ebp
  8026db:	c3                   	ret    

008026dc <devpipe_read>:
{
  8026dc:	55                   	push   %ebp
  8026dd:	89 e5                	mov    %esp,%ebp
  8026df:	57                   	push   %edi
  8026e0:	56                   	push   %esi
  8026e1:	53                   	push   %ebx
  8026e2:	83 ec 18             	sub    $0x18,%esp
  8026e5:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8026e8:	57                   	push   %edi
  8026e9:	e8 80 f1 ff ff       	call   80186e <fd2data>
  8026ee:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8026f0:	83 c4 10             	add    $0x10,%esp
  8026f3:	be 00 00 00 00       	mov    $0x0,%esi
  8026f8:	3b 75 10             	cmp    0x10(%ebp),%esi
  8026fb:	75 14                	jne    802711 <devpipe_read+0x35>
	return i;
  8026fd:	8b 45 10             	mov    0x10(%ebp),%eax
  802700:	eb 02                	jmp    802704 <devpipe_read+0x28>
				return i;
  802702:	89 f0                	mov    %esi,%eax
}
  802704:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802707:	5b                   	pop    %ebx
  802708:	5e                   	pop    %esi
  802709:	5f                   	pop    %edi
  80270a:	5d                   	pop    %ebp
  80270b:	c3                   	ret    
			sys_yield();
  80270c:	e8 44 ea ff ff       	call   801155 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802711:	8b 03                	mov    (%ebx),%eax
  802713:	3b 43 04             	cmp    0x4(%ebx),%eax
  802716:	75 18                	jne    802730 <devpipe_read+0x54>
			if (i > 0)
  802718:	85 f6                	test   %esi,%esi
  80271a:	75 e6                	jne    802702 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80271c:	89 da                	mov    %ebx,%edx
  80271e:	89 f8                	mov    %edi,%eax
  802720:	e8 d0 fe ff ff       	call   8025f5 <_pipeisclosed>
  802725:	85 c0                	test   %eax,%eax
  802727:	74 e3                	je     80270c <devpipe_read+0x30>
				return 0;
  802729:	b8 00 00 00 00       	mov    $0x0,%eax
  80272e:	eb d4                	jmp    802704 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802730:	99                   	cltd   
  802731:	c1 ea 1b             	shr    $0x1b,%edx
  802734:	01 d0                	add    %edx,%eax
  802736:	83 e0 1f             	and    $0x1f,%eax
  802739:	29 d0                	sub    %edx,%eax
  80273b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802740:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802743:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802746:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802749:	83 c6 01             	add    $0x1,%esi
  80274c:	eb aa                	jmp    8026f8 <devpipe_read+0x1c>

0080274e <pipe>:
{
  80274e:	55                   	push   %ebp
  80274f:	89 e5                	mov    %esp,%ebp
  802751:	56                   	push   %esi
  802752:	53                   	push   %ebx
  802753:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802756:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802759:	50                   	push   %eax
  80275a:	e8 26 f1 ff ff       	call   801885 <fd_alloc>
  80275f:	89 c3                	mov    %eax,%ebx
  802761:	83 c4 10             	add    $0x10,%esp
  802764:	85 c0                	test   %eax,%eax
  802766:	0f 88 23 01 00 00    	js     80288f <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80276c:	83 ec 04             	sub    $0x4,%esp
  80276f:	68 07 04 00 00       	push   $0x407
  802774:	ff 75 f4             	pushl  -0xc(%ebp)
  802777:	6a 00                	push   $0x0
  802779:	e8 f6 e9 ff ff       	call   801174 <sys_page_alloc>
  80277e:	89 c3                	mov    %eax,%ebx
  802780:	83 c4 10             	add    $0x10,%esp
  802783:	85 c0                	test   %eax,%eax
  802785:	0f 88 04 01 00 00    	js     80288f <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80278b:	83 ec 0c             	sub    $0xc,%esp
  80278e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802791:	50                   	push   %eax
  802792:	e8 ee f0 ff ff       	call   801885 <fd_alloc>
  802797:	89 c3                	mov    %eax,%ebx
  802799:	83 c4 10             	add    $0x10,%esp
  80279c:	85 c0                	test   %eax,%eax
  80279e:	0f 88 db 00 00 00    	js     80287f <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027a4:	83 ec 04             	sub    $0x4,%esp
  8027a7:	68 07 04 00 00       	push   $0x407
  8027ac:	ff 75 f0             	pushl  -0x10(%ebp)
  8027af:	6a 00                	push   $0x0
  8027b1:	e8 be e9 ff ff       	call   801174 <sys_page_alloc>
  8027b6:	89 c3                	mov    %eax,%ebx
  8027b8:	83 c4 10             	add    $0x10,%esp
  8027bb:	85 c0                	test   %eax,%eax
  8027bd:	0f 88 bc 00 00 00    	js     80287f <pipe+0x131>
	va = fd2data(fd0);
  8027c3:	83 ec 0c             	sub    $0xc,%esp
  8027c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8027c9:	e8 a0 f0 ff ff       	call   80186e <fd2data>
  8027ce:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027d0:	83 c4 0c             	add    $0xc,%esp
  8027d3:	68 07 04 00 00       	push   $0x407
  8027d8:	50                   	push   %eax
  8027d9:	6a 00                	push   $0x0
  8027db:	e8 94 e9 ff ff       	call   801174 <sys_page_alloc>
  8027e0:	89 c3                	mov    %eax,%ebx
  8027e2:	83 c4 10             	add    $0x10,%esp
  8027e5:	85 c0                	test   %eax,%eax
  8027e7:	0f 88 82 00 00 00    	js     80286f <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027ed:	83 ec 0c             	sub    $0xc,%esp
  8027f0:	ff 75 f0             	pushl  -0x10(%ebp)
  8027f3:	e8 76 f0 ff ff       	call   80186e <fd2data>
  8027f8:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8027ff:	50                   	push   %eax
  802800:	6a 00                	push   $0x0
  802802:	56                   	push   %esi
  802803:	6a 00                	push   $0x0
  802805:	e8 ad e9 ff ff       	call   8011b7 <sys_page_map>
  80280a:	89 c3                	mov    %eax,%ebx
  80280c:	83 c4 20             	add    $0x20,%esp
  80280f:	85 c0                	test   %eax,%eax
  802811:	78 4e                	js     802861 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802813:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802818:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80281b:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80281d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802820:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802827:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80282a:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80282c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802836:	83 ec 0c             	sub    $0xc,%esp
  802839:	ff 75 f4             	pushl  -0xc(%ebp)
  80283c:	e8 1d f0 ff ff       	call   80185e <fd2num>
  802841:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802844:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802846:	83 c4 04             	add    $0x4,%esp
  802849:	ff 75 f0             	pushl  -0x10(%ebp)
  80284c:	e8 0d f0 ff ff       	call   80185e <fd2num>
  802851:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802854:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802857:	83 c4 10             	add    $0x10,%esp
  80285a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80285f:	eb 2e                	jmp    80288f <pipe+0x141>
	sys_page_unmap(0, va);
  802861:	83 ec 08             	sub    $0x8,%esp
  802864:	56                   	push   %esi
  802865:	6a 00                	push   $0x0
  802867:	e8 8d e9 ff ff       	call   8011f9 <sys_page_unmap>
  80286c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80286f:	83 ec 08             	sub    $0x8,%esp
  802872:	ff 75 f0             	pushl  -0x10(%ebp)
  802875:	6a 00                	push   $0x0
  802877:	e8 7d e9 ff ff       	call   8011f9 <sys_page_unmap>
  80287c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80287f:	83 ec 08             	sub    $0x8,%esp
  802882:	ff 75 f4             	pushl  -0xc(%ebp)
  802885:	6a 00                	push   $0x0
  802887:	e8 6d e9 ff ff       	call   8011f9 <sys_page_unmap>
  80288c:	83 c4 10             	add    $0x10,%esp
}
  80288f:	89 d8                	mov    %ebx,%eax
  802891:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802894:	5b                   	pop    %ebx
  802895:	5e                   	pop    %esi
  802896:	5d                   	pop    %ebp
  802897:	c3                   	ret    

00802898 <pipeisclosed>:
{
  802898:	55                   	push   %ebp
  802899:	89 e5                	mov    %esp,%ebp
  80289b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80289e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028a1:	50                   	push   %eax
  8028a2:	ff 75 08             	pushl  0x8(%ebp)
  8028a5:	e8 2d f0 ff ff       	call   8018d7 <fd_lookup>
  8028aa:	83 c4 10             	add    $0x10,%esp
  8028ad:	85 c0                	test   %eax,%eax
  8028af:	78 18                	js     8028c9 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8028b1:	83 ec 0c             	sub    $0xc,%esp
  8028b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8028b7:	e8 b2 ef ff ff       	call   80186e <fd2data>
	return _pipeisclosed(fd, p);
  8028bc:	89 c2                	mov    %eax,%edx
  8028be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c1:	e8 2f fd ff ff       	call   8025f5 <_pipeisclosed>
  8028c6:	83 c4 10             	add    $0x10,%esp
}
  8028c9:	c9                   	leave  
  8028ca:	c3                   	ret    

008028cb <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8028cb:	55                   	push   %ebp
  8028cc:	89 e5                	mov    %esp,%ebp
  8028ce:	56                   	push   %esi
  8028cf:	53                   	push   %ebx
  8028d0:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  8028d3:	85 f6                	test   %esi,%esi
  8028d5:	74 13                	je     8028ea <wait+0x1f>
	e = &envs[ENVX(envid)];
  8028d7:	89 f3                	mov    %esi,%ebx
  8028d9:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8028df:	c1 e3 07             	shl    $0x7,%ebx
  8028e2:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8028e8:	eb 1b                	jmp    802905 <wait+0x3a>
	assert(envid != 0);
  8028ea:	68 fd 34 80 00       	push   $0x8034fd
  8028ef:	68 20 34 80 00       	push   $0x803420
  8028f4:	6a 09                	push   $0x9
  8028f6:	68 08 35 80 00       	push   $0x803508
  8028fb:	e8 2d dc ff ff       	call   80052d <_panic>
		sys_yield();
  802900:	e8 50 e8 ff ff       	call   801155 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802905:	8b 43 48             	mov    0x48(%ebx),%eax
  802908:	39 f0                	cmp    %esi,%eax
  80290a:	75 07                	jne    802913 <wait+0x48>
  80290c:	8b 43 54             	mov    0x54(%ebx),%eax
  80290f:	85 c0                	test   %eax,%eax
  802911:	75 ed                	jne    802900 <wait+0x35>
}
  802913:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802916:	5b                   	pop    %ebx
  802917:	5e                   	pop    %esi
  802918:	5d                   	pop    %ebp
  802919:	c3                   	ret    

0080291a <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80291a:	55                   	push   %ebp
  80291b:	89 e5                	mov    %esp,%ebp
  80291d:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802920:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802927:	74 0a                	je     802933 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802929:	8b 45 08             	mov    0x8(%ebp),%eax
  80292c:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802931:	c9                   	leave  
  802932:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802933:	83 ec 04             	sub    $0x4,%esp
  802936:	6a 07                	push   $0x7
  802938:	68 00 f0 bf ee       	push   $0xeebff000
  80293d:	6a 00                	push   $0x0
  80293f:	e8 30 e8 ff ff       	call   801174 <sys_page_alloc>
		if(r < 0)
  802944:	83 c4 10             	add    $0x10,%esp
  802947:	85 c0                	test   %eax,%eax
  802949:	78 2a                	js     802975 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80294b:	83 ec 08             	sub    $0x8,%esp
  80294e:	68 89 29 80 00       	push   $0x802989
  802953:	6a 00                	push   $0x0
  802955:	e8 65 e9 ff ff       	call   8012bf <sys_env_set_pgfault_upcall>
		if(r < 0)
  80295a:	83 c4 10             	add    $0x10,%esp
  80295d:	85 c0                	test   %eax,%eax
  80295f:	79 c8                	jns    802929 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802961:	83 ec 04             	sub    $0x4,%esp
  802964:	68 44 35 80 00       	push   $0x803544
  802969:	6a 25                	push   $0x25
  80296b:	68 80 35 80 00       	push   $0x803580
  802970:	e8 b8 db ff ff       	call   80052d <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802975:	83 ec 04             	sub    $0x4,%esp
  802978:	68 14 35 80 00       	push   $0x803514
  80297d:	6a 22                	push   $0x22
  80297f:	68 80 35 80 00       	push   $0x803580
  802984:	e8 a4 db ff ff       	call   80052d <_panic>

00802989 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802989:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80298a:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  80298f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802991:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802994:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802998:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  80299c:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80299f:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8029a1:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8029a5:	83 c4 08             	add    $0x8,%esp
	popal
  8029a8:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8029a9:	83 c4 04             	add    $0x4,%esp
	popfl
  8029ac:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8029ad:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8029ae:	c3                   	ret    

008029af <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8029af:	55                   	push   %ebp
  8029b0:	89 e5                	mov    %esp,%ebp
  8029b2:	56                   	push   %esi
  8029b3:	53                   	push   %ebx
  8029b4:	8b 75 08             	mov    0x8(%ebp),%esi
  8029b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029ba:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  8029bd:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8029bf:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8029c4:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8029c7:	83 ec 0c             	sub    $0xc,%esp
  8029ca:	50                   	push   %eax
  8029cb:	e8 54 e9 ff ff       	call   801324 <sys_ipc_recv>
	if(ret < 0){
  8029d0:	83 c4 10             	add    $0x10,%esp
  8029d3:	85 c0                	test   %eax,%eax
  8029d5:	78 2b                	js     802a02 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8029d7:	85 f6                	test   %esi,%esi
  8029d9:	74 0a                	je     8029e5 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8029db:	a1 04 50 80 00       	mov    0x805004,%eax
  8029e0:	8b 40 74             	mov    0x74(%eax),%eax
  8029e3:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8029e5:	85 db                	test   %ebx,%ebx
  8029e7:	74 0a                	je     8029f3 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8029e9:	a1 04 50 80 00       	mov    0x805004,%eax
  8029ee:	8b 40 78             	mov    0x78(%eax),%eax
  8029f1:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8029f3:	a1 04 50 80 00       	mov    0x805004,%eax
  8029f8:	8b 40 70             	mov    0x70(%eax),%eax
}
  8029fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8029fe:	5b                   	pop    %ebx
  8029ff:	5e                   	pop    %esi
  802a00:	5d                   	pop    %ebp
  802a01:	c3                   	ret    
		if(from_env_store)
  802a02:	85 f6                	test   %esi,%esi
  802a04:	74 06                	je     802a0c <ipc_recv+0x5d>
			*from_env_store = 0;
  802a06:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802a0c:	85 db                	test   %ebx,%ebx
  802a0e:	74 eb                	je     8029fb <ipc_recv+0x4c>
			*perm_store = 0;
  802a10:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802a16:	eb e3                	jmp    8029fb <ipc_recv+0x4c>

00802a18 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802a18:	55                   	push   %ebp
  802a19:	89 e5                	mov    %esp,%ebp
  802a1b:	57                   	push   %edi
  802a1c:	56                   	push   %esi
  802a1d:	53                   	push   %ebx
  802a1e:	83 ec 0c             	sub    $0xc,%esp
  802a21:	8b 7d 08             	mov    0x8(%ebp),%edi
  802a24:	8b 75 0c             	mov    0xc(%ebp),%esi
  802a27:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802a2a:	85 db                	test   %ebx,%ebx
  802a2c:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802a31:	0f 44 d8             	cmove  %eax,%ebx
  802a34:	eb 05                	jmp    802a3b <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802a36:	e8 1a e7 ff ff       	call   801155 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802a3b:	ff 75 14             	pushl  0x14(%ebp)
  802a3e:	53                   	push   %ebx
  802a3f:	56                   	push   %esi
  802a40:	57                   	push   %edi
  802a41:	e8 bb e8 ff ff       	call   801301 <sys_ipc_try_send>
  802a46:	83 c4 10             	add    $0x10,%esp
  802a49:	85 c0                	test   %eax,%eax
  802a4b:	74 1b                	je     802a68 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802a4d:	79 e7                	jns    802a36 <ipc_send+0x1e>
  802a4f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802a52:	74 e2                	je     802a36 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802a54:	83 ec 04             	sub    $0x4,%esp
  802a57:	68 8e 35 80 00       	push   $0x80358e
  802a5c:	6a 49                	push   $0x49
  802a5e:	68 a3 35 80 00       	push   $0x8035a3
  802a63:	e8 c5 da ff ff       	call   80052d <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802a68:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a6b:	5b                   	pop    %ebx
  802a6c:	5e                   	pop    %esi
  802a6d:	5f                   	pop    %edi
  802a6e:	5d                   	pop    %ebp
  802a6f:	c3                   	ret    

00802a70 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802a70:	55                   	push   %ebp
  802a71:	89 e5                	mov    %esp,%ebp
  802a73:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802a76:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802a7b:	89 c2                	mov    %eax,%edx
  802a7d:	c1 e2 07             	shl    $0x7,%edx
  802a80:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802a86:	8b 52 50             	mov    0x50(%edx),%edx
  802a89:	39 ca                	cmp    %ecx,%edx
  802a8b:	74 11                	je     802a9e <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802a8d:	83 c0 01             	add    $0x1,%eax
  802a90:	3d 00 04 00 00       	cmp    $0x400,%eax
  802a95:	75 e4                	jne    802a7b <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802a97:	b8 00 00 00 00       	mov    $0x0,%eax
  802a9c:	eb 0b                	jmp    802aa9 <ipc_find_env+0x39>
			return envs[i].env_id;
  802a9e:	c1 e0 07             	shl    $0x7,%eax
  802aa1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802aa6:	8b 40 48             	mov    0x48(%eax),%eax
}
  802aa9:	5d                   	pop    %ebp
  802aaa:	c3                   	ret    

00802aab <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802aab:	55                   	push   %ebp
  802aac:	89 e5                	mov    %esp,%ebp
  802aae:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802ab1:	89 d0                	mov    %edx,%eax
  802ab3:	c1 e8 16             	shr    $0x16,%eax
  802ab6:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802abd:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802ac2:	f6 c1 01             	test   $0x1,%cl
  802ac5:	74 1d                	je     802ae4 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802ac7:	c1 ea 0c             	shr    $0xc,%edx
  802aca:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802ad1:	f6 c2 01             	test   $0x1,%dl
  802ad4:	74 0e                	je     802ae4 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802ad6:	c1 ea 0c             	shr    $0xc,%edx
  802ad9:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802ae0:	ef 
  802ae1:	0f b7 c0             	movzwl %ax,%eax
}
  802ae4:	5d                   	pop    %ebp
  802ae5:	c3                   	ret    
  802ae6:	66 90                	xchg   %ax,%ax
  802ae8:	66 90                	xchg   %ax,%ax
  802aea:	66 90                	xchg   %ax,%ax
  802aec:	66 90                	xchg   %ax,%ax
  802aee:	66 90                	xchg   %ax,%ax

00802af0 <__udivdi3>:
  802af0:	55                   	push   %ebp
  802af1:	57                   	push   %edi
  802af2:	56                   	push   %esi
  802af3:	53                   	push   %ebx
  802af4:	83 ec 1c             	sub    $0x1c,%esp
  802af7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802afb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802aff:	8b 74 24 34          	mov    0x34(%esp),%esi
  802b03:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802b07:	85 d2                	test   %edx,%edx
  802b09:	75 4d                	jne    802b58 <__udivdi3+0x68>
  802b0b:	39 f3                	cmp    %esi,%ebx
  802b0d:	76 19                	jbe    802b28 <__udivdi3+0x38>
  802b0f:	31 ff                	xor    %edi,%edi
  802b11:	89 e8                	mov    %ebp,%eax
  802b13:	89 f2                	mov    %esi,%edx
  802b15:	f7 f3                	div    %ebx
  802b17:	89 fa                	mov    %edi,%edx
  802b19:	83 c4 1c             	add    $0x1c,%esp
  802b1c:	5b                   	pop    %ebx
  802b1d:	5e                   	pop    %esi
  802b1e:	5f                   	pop    %edi
  802b1f:	5d                   	pop    %ebp
  802b20:	c3                   	ret    
  802b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b28:	89 d9                	mov    %ebx,%ecx
  802b2a:	85 db                	test   %ebx,%ebx
  802b2c:	75 0b                	jne    802b39 <__udivdi3+0x49>
  802b2e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b33:	31 d2                	xor    %edx,%edx
  802b35:	f7 f3                	div    %ebx
  802b37:	89 c1                	mov    %eax,%ecx
  802b39:	31 d2                	xor    %edx,%edx
  802b3b:	89 f0                	mov    %esi,%eax
  802b3d:	f7 f1                	div    %ecx
  802b3f:	89 c6                	mov    %eax,%esi
  802b41:	89 e8                	mov    %ebp,%eax
  802b43:	89 f7                	mov    %esi,%edi
  802b45:	f7 f1                	div    %ecx
  802b47:	89 fa                	mov    %edi,%edx
  802b49:	83 c4 1c             	add    $0x1c,%esp
  802b4c:	5b                   	pop    %ebx
  802b4d:	5e                   	pop    %esi
  802b4e:	5f                   	pop    %edi
  802b4f:	5d                   	pop    %ebp
  802b50:	c3                   	ret    
  802b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b58:	39 f2                	cmp    %esi,%edx
  802b5a:	77 1c                	ja     802b78 <__udivdi3+0x88>
  802b5c:	0f bd fa             	bsr    %edx,%edi
  802b5f:	83 f7 1f             	xor    $0x1f,%edi
  802b62:	75 2c                	jne    802b90 <__udivdi3+0xa0>
  802b64:	39 f2                	cmp    %esi,%edx
  802b66:	72 06                	jb     802b6e <__udivdi3+0x7e>
  802b68:	31 c0                	xor    %eax,%eax
  802b6a:	39 eb                	cmp    %ebp,%ebx
  802b6c:	77 a9                	ja     802b17 <__udivdi3+0x27>
  802b6e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b73:	eb a2                	jmp    802b17 <__udivdi3+0x27>
  802b75:	8d 76 00             	lea    0x0(%esi),%esi
  802b78:	31 ff                	xor    %edi,%edi
  802b7a:	31 c0                	xor    %eax,%eax
  802b7c:	89 fa                	mov    %edi,%edx
  802b7e:	83 c4 1c             	add    $0x1c,%esp
  802b81:	5b                   	pop    %ebx
  802b82:	5e                   	pop    %esi
  802b83:	5f                   	pop    %edi
  802b84:	5d                   	pop    %ebp
  802b85:	c3                   	ret    
  802b86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b8d:	8d 76 00             	lea    0x0(%esi),%esi
  802b90:	89 f9                	mov    %edi,%ecx
  802b92:	b8 20 00 00 00       	mov    $0x20,%eax
  802b97:	29 f8                	sub    %edi,%eax
  802b99:	d3 e2                	shl    %cl,%edx
  802b9b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802b9f:	89 c1                	mov    %eax,%ecx
  802ba1:	89 da                	mov    %ebx,%edx
  802ba3:	d3 ea                	shr    %cl,%edx
  802ba5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802ba9:	09 d1                	or     %edx,%ecx
  802bab:	89 f2                	mov    %esi,%edx
  802bad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802bb1:	89 f9                	mov    %edi,%ecx
  802bb3:	d3 e3                	shl    %cl,%ebx
  802bb5:	89 c1                	mov    %eax,%ecx
  802bb7:	d3 ea                	shr    %cl,%edx
  802bb9:	89 f9                	mov    %edi,%ecx
  802bbb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802bbf:	89 eb                	mov    %ebp,%ebx
  802bc1:	d3 e6                	shl    %cl,%esi
  802bc3:	89 c1                	mov    %eax,%ecx
  802bc5:	d3 eb                	shr    %cl,%ebx
  802bc7:	09 de                	or     %ebx,%esi
  802bc9:	89 f0                	mov    %esi,%eax
  802bcb:	f7 74 24 08          	divl   0x8(%esp)
  802bcf:	89 d6                	mov    %edx,%esi
  802bd1:	89 c3                	mov    %eax,%ebx
  802bd3:	f7 64 24 0c          	mull   0xc(%esp)
  802bd7:	39 d6                	cmp    %edx,%esi
  802bd9:	72 15                	jb     802bf0 <__udivdi3+0x100>
  802bdb:	89 f9                	mov    %edi,%ecx
  802bdd:	d3 e5                	shl    %cl,%ebp
  802bdf:	39 c5                	cmp    %eax,%ebp
  802be1:	73 04                	jae    802be7 <__udivdi3+0xf7>
  802be3:	39 d6                	cmp    %edx,%esi
  802be5:	74 09                	je     802bf0 <__udivdi3+0x100>
  802be7:	89 d8                	mov    %ebx,%eax
  802be9:	31 ff                	xor    %edi,%edi
  802beb:	e9 27 ff ff ff       	jmp    802b17 <__udivdi3+0x27>
  802bf0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802bf3:	31 ff                	xor    %edi,%edi
  802bf5:	e9 1d ff ff ff       	jmp    802b17 <__udivdi3+0x27>
  802bfa:	66 90                	xchg   %ax,%ax
  802bfc:	66 90                	xchg   %ax,%ax
  802bfe:	66 90                	xchg   %ax,%ax

00802c00 <__umoddi3>:
  802c00:	55                   	push   %ebp
  802c01:	57                   	push   %edi
  802c02:	56                   	push   %esi
  802c03:	53                   	push   %ebx
  802c04:	83 ec 1c             	sub    $0x1c,%esp
  802c07:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802c0b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802c0f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802c13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802c17:	89 da                	mov    %ebx,%edx
  802c19:	85 c0                	test   %eax,%eax
  802c1b:	75 43                	jne    802c60 <__umoddi3+0x60>
  802c1d:	39 df                	cmp    %ebx,%edi
  802c1f:	76 17                	jbe    802c38 <__umoddi3+0x38>
  802c21:	89 f0                	mov    %esi,%eax
  802c23:	f7 f7                	div    %edi
  802c25:	89 d0                	mov    %edx,%eax
  802c27:	31 d2                	xor    %edx,%edx
  802c29:	83 c4 1c             	add    $0x1c,%esp
  802c2c:	5b                   	pop    %ebx
  802c2d:	5e                   	pop    %esi
  802c2e:	5f                   	pop    %edi
  802c2f:	5d                   	pop    %ebp
  802c30:	c3                   	ret    
  802c31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c38:	89 fd                	mov    %edi,%ebp
  802c3a:	85 ff                	test   %edi,%edi
  802c3c:	75 0b                	jne    802c49 <__umoddi3+0x49>
  802c3e:	b8 01 00 00 00       	mov    $0x1,%eax
  802c43:	31 d2                	xor    %edx,%edx
  802c45:	f7 f7                	div    %edi
  802c47:	89 c5                	mov    %eax,%ebp
  802c49:	89 d8                	mov    %ebx,%eax
  802c4b:	31 d2                	xor    %edx,%edx
  802c4d:	f7 f5                	div    %ebp
  802c4f:	89 f0                	mov    %esi,%eax
  802c51:	f7 f5                	div    %ebp
  802c53:	89 d0                	mov    %edx,%eax
  802c55:	eb d0                	jmp    802c27 <__umoddi3+0x27>
  802c57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c5e:	66 90                	xchg   %ax,%ax
  802c60:	89 f1                	mov    %esi,%ecx
  802c62:	39 d8                	cmp    %ebx,%eax
  802c64:	76 0a                	jbe    802c70 <__umoddi3+0x70>
  802c66:	89 f0                	mov    %esi,%eax
  802c68:	83 c4 1c             	add    $0x1c,%esp
  802c6b:	5b                   	pop    %ebx
  802c6c:	5e                   	pop    %esi
  802c6d:	5f                   	pop    %edi
  802c6e:	5d                   	pop    %ebp
  802c6f:	c3                   	ret    
  802c70:	0f bd e8             	bsr    %eax,%ebp
  802c73:	83 f5 1f             	xor    $0x1f,%ebp
  802c76:	75 20                	jne    802c98 <__umoddi3+0x98>
  802c78:	39 d8                	cmp    %ebx,%eax
  802c7a:	0f 82 b0 00 00 00    	jb     802d30 <__umoddi3+0x130>
  802c80:	39 f7                	cmp    %esi,%edi
  802c82:	0f 86 a8 00 00 00    	jbe    802d30 <__umoddi3+0x130>
  802c88:	89 c8                	mov    %ecx,%eax
  802c8a:	83 c4 1c             	add    $0x1c,%esp
  802c8d:	5b                   	pop    %ebx
  802c8e:	5e                   	pop    %esi
  802c8f:	5f                   	pop    %edi
  802c90:	5d                   	pop    %ebp
  802c91:	c3                   	ret    
  802c92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802c98:	89 e9                	mov    %ebp,%ecx
  802c9a:	ba 20 00 00 00       	mov    $0x20,%edx
  802c9f:	29 ea                	sub    %ebp,%edx
  802ca1:	d3 e0                	shl    %cl,%eax
  802ca3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ca7:	89 d1                	mov    %edx,%ecx
  802ca9:	89 f8                	mov    %edi,%eax
  802cab:	d3 e8                	shr    %cl,%eax
  802cad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802cb1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802cb5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802cb9:	09 c1                	or     %eax,%ecx
  802cbb:	89 d8                	mov    %ebx,%eax
  802cbd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802cc1:	89 e9                	mov    %ebp,%ecx
  802cc3:	d3 e7                	shl    %cl,%edi
  802cc5:	89 d1                	mov    %edx,%ecx
  802cc7:	d3 e8                	shr    %cl,%eax
  802cc9:	89 e9                	mov    %ebp,%ecx
  802ccb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ccf:	d3 e3                	shl    %cl,%ebx
  802cd1:	89 c7                	mov    %eax,%edi
  802cd3:	89 d1                	mov    %edx,%ecx
  802cd5:	89 f0                	mov    %esi,%eax
  802cd7:	d3 e8                	shr    %cl,%eax
  802cd9:	89 e9                	mov    %ebp,%ecx
  802cdb:	89 fa                	mov    %edi,%edx
  802cdd:	d3 e6                	shl    %cl,%esi
  802cdf:	09 d8                	or     %ebx,%eax
  802ce1:	f7 74 24 08          	divl   0x8(%esp)
  802ce5:	89 d1                	mov    %edx,%ecx
  802ce7:	89 f3                	mov    %esi,%ebx
  802ce9:	f7 64 24 0c          	mull   0xc(%esp)
  802ced:	89 c6                	mov    %eax,%esi
  802cef:	89 d7                	mov    %edx,%edi
  802cf1:	39 d1                	cmp    %edx,%ecx
  802cf3:	72 06                	jb     802cfb <__umoddi3+0xfb>
  802cf5:	75 10                	jne    802d07 <__umoddi3+0x107>
  802cf7:	39 c3                	cmp    %eax,%ebx
  802cf9:	73 0c                	jae    802d07 <__umoddi3+0x107>
  802cfb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802cff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802d03:	89 d7                	mov    %edx,%edi
  802d05:	89 c6                	mov    %eax,%esi
  802d07:	89 ca                	mov    %ecx,%edx
  802d09:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802d0e:	29 f3                	sub    %esi,%ebx
  802d10:	19 fa                	sbb    %edi,%edx
  802d12:	89 d0                	mov    %edx,%eax
  802d14:	d3 e0                	shl    %cl,%eax
  802d16:	89 e9                	mov    %ebp,%ecx
  802d18:	d3 eb                	shr    %cl,%ebx
  802d1a:	d3 ea                	shr    %cl,%edx
  802d1c:	09 d8                	or     %ebx,%eax
  802d1e:	83 c4 1c             	add    $0x1c,%esp
  802d21:	5b                   	pop    %ebx
  802d22:	5e                   	pop    %esi
  802d23:	5f                   	pop    %edi
  802d24:	5d                   	pop    %ebp
  802d25:	c3                   	ret    
  802d26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802d2d:	8d 76 00             	lea    0x0(%esi),%esi
  802d30:	89 da                	mov    %ebx,%edx
  802d32:	29 fe                	sub    %edi,%esi
  802d34:	19 c2                	sbb    %eax,%edx
  802d36:	89 f1                	mov    %esi,%ecx
  802d38:	89 c8                	mov    %ecx,%eax
  802d3a:	e9 4b ff ff ff       	jmp    802c8a <__umoddi3+0x8a>
