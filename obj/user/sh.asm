
obj/user/sh.debug:     file format elf32-i386


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
  80002c:	e8 dc 09 00 00       	call   800a0d <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <_gettoken>:
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 0c             	sub    $0xc,%esp
  80003c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80003f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int t;

	if (s == 0) {
  800042:	85 db                	test   %ebx,%ebx
  800044:	74 39                	je     80007f <_gettoken+0x4c>
		if (debug > 1)
			cprintf("GETTOKEN NULL\n");
		return 0;
	}

	if (debug > 1)
  800046:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  80004d:	7f 50                	jg     80009f <_gettoken+0x6c>
		cprintf("GETTOKEN: %s\n", s);

	*p1 = 0;
  80004f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	*p2 = 0;
  800055:	8b 45 10             	mov    0x10(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	while (strchr(WHITESPACE, *s))
  80005e:	83 ec 08             	sub    $0x8,%esp
  800061:	0f be 03             	movsbl (%ebx),%eax
  800064:	50                   	push   %eax
  800065:	68 3d 3d 80 00       	push   $0x803d3d
  80006a:	e8 fb 14 00 00       	call   80156a <strchr>
  80006f:	83 c4 10             	add    $0x10,%esp
  800072:	85 c0                	test   %eax,%eax
  800074:	74 3c                	je     8000b2 <_gettoken+0x7f>
		*s++ = 0;
  800076:	83 c3 01             	add    $0x1,%ebx
  800079:	c6 43 ff 00          	movb   $0x0,-0x1(%ebx)
  80007d:	eb df                	jmp    80005e <_gettoken+0x2b>
		return 0;
  80007f:	be 00 00 00 00       	mov    $0x0,%esi
		if (debug > 1)
  800084:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  80008b:	7e 3a                	jle    8000c7 <_gettoken+0x94>
			cprintf("GETTOKEN NULL\n");
  80008d:	83 ec 0c             	sub    $0xc,%esp
  800090:	68 20 3d 80 00       	push   $0x803d20
  800095:	e8 78 0b 00 00       	call   800c12 <cprintf>
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	eb 28                	jmp    8000c7 <_gettoken+0x94>
		cprintf("GETTOKEN: %s\n", s);
  80009f:	83 ec 08             	sub    $0x8,%esp
  8000a2:	53                   	push   %ebx
  8000a3:	68 2f 3d 80 00       	push   $0x803d2f
  8000a8:	e8 65 0b 00 00       	call   800c12 <cprintf>
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	eb 9d                	jmp    80004f <_gettoken+0x1c>
	if (*s == 0) {
  8000b2:	0f b6 03             	movzbl (%ebx),%eax
  8000b5:	84 c0                	test   %al,%al
  8000b7:	75 2a                	jne    8000e3 <_gettoken+0xb0>
		if (debug > 1)
			cprintf("EOL\n");
		return 0;
  8000b9:	be 00 00 00 00       	mov    $0x0,%esi
		if (debug > 1)
  8000be:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  8000c5:	7f 0a                	jg     8000d1 <_gettoken+0x9e>
		**p2 = 0;
		cprintf("WORD: %s\n", *p1);
		**p2 = t;
	}
	return 'w';
}
  8000c7:	89 f0                	mov    %esi,%eax
  8000c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000cc:	5b                   	pop    %ebx
  8000cd:	5e                   	pop    %esi
  8000ce:	5f                   	pop    %edi
  8000cf:	5d                   	pop    %ebp
  8000d0:	c3                   	ret    
			cprintf("EOL\n");
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	68 42 3d 80 00       	push   $0x803d42
  8000d9:	e8 34 0b 00 00       	call   800c12 <cprintf>
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	eb e4                	jmp    8000c7 <_gettoken+0x94>
	if (strchr(SYMBOLS, *s)) {
  8000e3:	83 ec 08             	sub    $0x8,%esp
  8000e6:	0f be c0             	movsbl %al,%eax
  8000e9:	50                   	push   %eax
  8000ea:	68 53 3d 80 00       	push   $0x803d53
  8000ef:	e8 76 14 00 00       	call   80156a <strchr>
  8000f4:	83 c4 10             	add    $0x10,%esp
  8000f7:	85 c0                	test   %eax,%eax
  8000f9:	74 2c                	je     800127 <_gettoken+0xf4>
		t = *s;
  8000fb:	0f be 33             	movsbl (%ebx),%esi
		*p1 = s;
  8000fe:	89 1f                	mov    %ebx,(%edi)
		*s++ = 0;
  800100:	c6 03 00             	movb   $0x0,(%ebx)
  800103:	83 c3 01             	add    $0x1,%ebx
  800106:	8b 45 10             	mov    0x10(%ebp),%eax
  800109:	89 18                	mov    %ebx,(%eax)
		if (debug > 1)
  80010b:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  800112:	7e b3                	jle    8000c7 <_gettoken+0x94>
			cprintf("TOK %c\n", t);
  800114:	83 ec 08             	sub    $0x8,%esp
  800117:	56                   	push   %esi
  800118:	68 47 3d 80 00       	push   $0x803d47
  80011d:	e8 f0 0a 00 00       	call   800c12 <cprintf>
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	eb a0                	jmp    8000c7 <_gettoken+0x94>
	*p1 = s;
  800127:	89 1f                	mov    %ebx,(%edi)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  800129:	eb 03                	jmp    80012e <_gettoken+0xfb>
		s++;
  80012b:	83 c3 01             	add    $0x1,%ebx
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  80012e:	0f b6 03             	movzbl (%ebx),%eax
  800131:	84 c0                	test   %al,%al
  800133:	74 18                	je     80014d <_gettoken+0x11a>
  800135:	83 ec 08             	sub    $0x8,%esp
  800138:	0f be c0             	movsbl %al,%eax
  80013b:	50                   	push   %eax
  80013c:	68 4f 3d 80 00       	push   $0x803d4f
  800141:	e8 24 14 00 00       	call   80156a <strchr>
  800146:	83 c4 10             	add    $0x10,%esp
  800149:	85 c0                	test   %eax,%eax
  80014b:	74 de                	je     80012b <_gettoken+0xf8>
	*p2 = s;
  80014d:	8b 45 10             	mov    0x10(%ebp),%eax
  800150:	89 18                	mov    %ebx,(%eax)
	return 'w';
  800152:	be 77 00 00 00       	mov    $0x77,%esi
	if (debug > 1) {
  800157:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  80015e:	0f 8e 63 ff ff ff    	jle    8000c7 <_gettoken+0x94>
		t = **p2;
  800164:	0f b6 33             	movzbl (%ebx),%esi
		**p2 = 0;
  800167:	c6 03 00             	movb   $0x0,(%ebx)
		cprintf("WORD: %s\n", *p1);
  80016a:	83 ec 08             	sub    $0x8,%esp
  80016d:	ff 37                	pushl  (%edi)
  80016f:	68 5b 3d 80 00       	push   $0x803d5b
  800174:	e8 99 0a 00 00       	call   800c12 <cprintf>
		**p2 = t;
  800179:	8b 45 10             	mov    0x10(%ebp),%eax
  80017c:	8b 00                	mov    (%eax),%eax
  80017e:	89 f2                	mov    %esi,%edx
  800180:	88 10                	mov    %dl,(%eax)
  800182:	83 c4 10             	add    $0x10,%esp
	return 'w';
  800185:	be 77 00 00 00       	mov    $0x77,%esi
  80018a:	e9 38 ff ff ff       	jmp    8000c7 <_gettoken+0x94>

0080018f <gettoken>:

int
gettoken(char *s, char **p1)
{
  80018f:	55                   	push   %ebp
  800190:	89 e5                	mov    %esp,%ebp
  800192:	83 ec 08             	sub    $0x8,%esp
  800195:	8b 45 08             	mov    0x8(%ebp),%eax
	static int c, nc;
	static char* np1, *np2;

	if (s) {
  800198:	85 c0                	test   %eax,%eax
  80019a:	74 22                	je     8001be <gettoken+0x2f>
		nc = _gettoken(s, &np1, &np2);
  80019c:	83 ec 04             	sub    $0x4,%esp
  80019f:	68 0c 60 80 00       	push   $0x80600c
  8001a4:	68 10 60 80 00       	push   $0x806010
  8001a9:	50                   	push   %eax
  8001aa:	e8 84 fe ff ff       	call   800033 <_gettoken>
  8001af:	a3 08 60 80 00       	mov    %eax,0x806008
		return 0;
  8001b4:	83 c4 10             	add    $0x10,%esp
  8001b7:	b8 00 00 00 00       	mov    $0x0,%eax
	}
	c = nc;
	*p1 = np1;
	nc = _gettoken(np2, &np1, &np2);
	return c;
}
  8001bc:	c9                   	leave  
  8001bd:	c3                   	ret    
	c = nc;
  8001be:	a1 08 60 80 00       	mov    0x806008,%eax
  8001c3:	a3 04 60 80 00       	mov    %eax,0x806004
	*p1 = np1;
  8001c8:	8b 15 10 60 80 00    	mov    0x806010,%edx
  8001ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d1:	89 10                	mov    %edx,(%eax)
	nc = _gettoken(np2, &np1, &np2);
  8001d3:	83 ec 04             	sub    $0x4,%esp
  8001d6:	68 0c 60 80 00       	push   $0x80600c
  8001db:	68 10 60 80 00       	push   $0x806010
  8001e0:	ff 35 0c 60 80 00    	pushl  0x80600c
  8001e6:	e8 48 fe ff ff       	call   800033 <_gettoken>
  8001eb:	a3 08 60 80 00       	mov    %eax,0x806008
	return c;
  8001f0:	a1 04 60 80 00       	mov    0x806004,%eax
  8001f5:	83 c4 10             	add    $0x10,%esp
  8001f8:	eb c2                	jmp    8001bc <gettoken+0x2d>

008001fa <runcmd>:
{
  8001fa:	55                   	push   %ebp
  8001fb:	89 e5                	mov    %esp,%ebp
  8001fd:	57                   	push   %edi
  8001fe:	56                   	push   %esi
  8001ff:	53                   	push   %ebx
  800200:	81 ec 64 04 00 00    	sub    $0x464,%esp
	gettoken(s, 0);
  800206:	6a 00                	push   $0x0
  800208:	ff 75 08             	pushl  0x8(%ebp)
  80020b:	e8 7f ff ff ff       	call   80018f <gettoken>
  800210:	83 c4 10             	add    $0x10,%esp
		switch ((c = gettoken(0, &t))) {
  800213:	8d 75 a4             	lea    -0x5c(%ebp),%esi
	argc = 0;
  800216:	bf 00 00 00 00       	mov    $0x0,%edi
		switch ((c = gettoken(0, &t))) {
  80021b:	83 ec 08             	sub    $0x8,%esp
  80021e:	56                   	push   %esi
  80021f:	6a 00                	push   $0x0
  800221:	e8 69 ff ff ff       	call   80018f <gettoken>
  800226:	89 c3                	mov    %eax,%ebx
  800228:	83 c4 10             	add    $0x10,%esp
  80022b:	83 f8 3e             	cmp    $0x3e,%eax
  80022e:	0f 84 35 01 00 00    	je     800369 <runcmd+0x16f>
  800234:	7f 4c                	jg     800282 <runcmd+0x88>
  800236:	85 c0                	test   %eax,%eax
  800238:	0f 84 1f 02 00 00    	je     80045d <runcmd+0x263>
  80023e:	83 f8 3c             	cmp    $0x3c,%eax
  800241:	0f 85 f2 02 00 00    	jne    800539 <runcmd+0x33f>
			if (gettoken(0, &t) != 'w') {
  800247:	83 ec 08             	sub    $0x8,%esp
  80024a:	56                   	push   %esi
  80024b:	6a 00                	push   $0x0
  80024d:	e8 3d ff ff ff       	call   80018f <gettoken>
  800252:	83 c4 10             	add    $0x10,%esp
  800255:	83 f8 77             	cmp    $0x77,%eax
  800258:	0f 85 bd 00 00 00    	jne    80031b <runcmd+0x121>
			if ((fd = open(t, O_RDONLY|O_CREAT)) < 0) {
  80025e:	83 ec 08             	sub    $0x8,%esp
  800261:	68 00 01 00 00       	push   $0x100
  800266:	ff 75 a4             	pushl  -0x5c(%ebp)
  800269:	e8 9b 26 00 00       	call   802909 <open>
  80026e:	89 c3                	mov    %eax,%ebx
  800270:	83 c4 10             	add    $0x10,%esp
  800273:	85 c0                	test   %eax,%eax
  800275:	0f 88 ba 00 00 00    	js     800335 <runcmd+0x13b>
			if (fd != 0) {
  80027b:	74 9e                	je     80021b <runcmd+0x21>
  80027d:	e9 cc 00 00 00       	jmp    80034e <runcmd+0x154>
		switch ((c = gettoken(0, &t))) {
  800282:	83 f8 77             	cmp    $0x77,%eax
  800285:	74 69                	je     8002f0 <runcmd+0xf6>
  800287:	83 f8 7c             	cmp    $0x7c,%eax
  80028a:	0f 85 a9 02 00 00    	jne    800539 <runcmd+0x33f>
			if ((r = pipe(p)) < 0) {
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	8d 85 9c fb ff ff    	lea    -0x464(%ebp),%eax
  800299:	50                   	push   %eax
  80029a:	e8 78 34 00 00       	call   803717 <pipe>
  80029f:	83 c4 10             	add    $0x10,%esp
  8002a2:	85 c0                	test   %eax,%eax
  8002a4:	0f 88 41 01 00 00    	js     8003eb <runcmd+0x1f1>
			if (debug)
  8002aa:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8002b1:	0f 85 4f 01 00 00    	jne    800406 <runcmd+0x20c>
			if ((r = fork()) < 0) {
  8002b7:	e8 e1 1a 00 00       	call   801d9d <fork>
  8002bc:	89 c3                	mov    %eax,%ebx
  8002be:	85 c0                	test   %eax,%eax
  8002c0:	0f 88 61 01 00 00    	js     800427 <runcmd+0x22d>
			if (r == 0) {
  8002c6:	0f 85 71 01 00 00    	jne    80043d <runcmd+0x243>
				if (p[0] != 0) {
  8002cc:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  8002d2:	85 c0                	test   %eax,%eax
  8002d4:	0f 85 1d 02 00 00    	jne    8004f7 <runcmd+0x2fd>
				close(p[1]);
  8002da:	83 ec 0c             	sub    $0xc,%esp
  8002dd:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  8002e3:	e8 45 20 00 00       	call   80232d <close>
				goto again;
  8002e8:	83 c4 10             	add    $0x10,%esp
  8002eb:	e9 26 ff ff ff       	jmp    800216 <runcmd+0x1c>
			if (argc == MAXARGS) {
  8002f0:	83 ff 10             	cmp    $0x10,%edi
  8002f3:	74 0f                	je     800304 <runcmd+0x10a>
			argv[argc++] = t;
  8002f5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8002f8:	89 44 bd a8          	mov    %eax,-0x58(%ebp,%edi,4)
  8002fc:	8d 7f 01             	lea    0x1(%edi),%edi
			break;
  8002ff:	e9 17 ff ff ff       	jmp    80021b <runcmd+0x21>
				cprintf("too many arguments\n");
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	68 65 3d 80 00       	push   $0x803d65
  80030c:	e8 01 09 00 00       	call   800c12 <cprintf>
				exit();
  800311:	e8 d2 07 00 00       	call   800ae8 <exit>
  800316:	83 c4 10             	add    $0x10,%esp
  800319:	eb da                	jmp    8002f5 <runcmd+0xfb>
				cprintf("syntax error: < not followed by word\n");
  80031b:	83 ec 0c             	sub    $0xc,%esp
  80031e:	68 b8 3e 80 00       	push   $0x803eb8
  800323:	e8 ea 08 00 00       	call   800c12 <cprintf>
				exit();
  800328:	e8 bb 07 00 00       	call   800ae8 <exit>
  80032d:	83 c4 10             	add    $0x10,%esp
  800330:	e9 29 ff ff ff       	jmp    80025e <runcmd+0x64>
				cprintf("open %s for read: %e", t, fd);
  800335:	83 ec 04             	sub    $0x4,%esp
  800338:	50                   	push   %eax
  800339:	ff 75 a4             	pushl  -0x5c(%ebp)
  80033c:	68 79 3d 80 00       	push   $0x803d79
  800341:	e8 cc 08 00 00       	call   800c12 <cprintf>
				exit();
  800346:	e8 9d 07 00 00       	call   800ae8 <exit>
  80034b:	83 c4 10             	add    $0x10,%esp
				dup(fd, 0);
  80034e:	83 ec 08             	sub    $0x8,%esp
  800351:	6a 00                	push   $0x0
  800353:	53                   	push   %ebx
  800354:	e8 26 20 00 00       	call   80237f <dup>
				close(fd);
  800359:	89 1c 24             	mov    %ebx,(%esp)
  80035c:	e8 cc 1f 00 00       	call   80232d <close>
  800361:	83 c4 10             	add    $0x10,%esp
  800364:	e9 b2 fe ff ff       	jmp    80021b <runcmd+0x21>
			if (gettoken(0, &t) != 'w') {
  800369:	83 ec 08             	sub    $0x8,%esp
  80036c:	56                   	push   %esi
  80036d:	6a 00                	push   $0x0
  80036f:	e8 1b fe ff ff       	call   80018f <gettoken>
  800374:	83 c4 10             	add    $0x10,%esp
  800377:	83 f8 77             	cmp    $0x77,%eax
  80037a:	75 24                	jne    8003a0 <runcmd+0x1a6>
			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
  80037c:	83 ec 08             	sub    $0x8,%esp
  80037f:	68 01 03 00 00       	push   $0x301
  800384:	ff 75 a4             	pushl  -0x5c(%ebp)
  800387:	e8 7d 25 00 00       	call   802909 <open>
  80038c:	89 c3                	mov    %eax,%ebx
  80038e:	83 c4 10             	add    $0x10,%esp
  800391:	85 c0                	test   %eax,%eax
  800393:	78 22                	js     8003b7 <runcmd+0x1bd>
			if (fd != 1) {
  800395:	83 f8 01             	cmp    $0x1,%eax
  800398:	0f 84 7d fe ff ff    	je     80021b <runcmd+0x21>
  80039e:	eb 30                	jmp    8003d0 <runcmd+0x1d6>
				cprintf("syntax error: > not followed by word\n");
  8003a0:	83 ec 0c             	sub    $0xc,%esp
  8003a3:	68 e0 3e 80 00       	push   $0x803ee0
  8003a8:	e8 65 08 00 00       	call   800c12 <cprintf>
				exit();
  8003ad:	e8 36 07 00 00       	call   800ae8 <exit>
  8003b2:	83 c4 10             	add    $0x10,%esp
  8003b5:	eb c5                	jmp    80037c <runcmd+0x182>
				cprintf("open %s for write: %e", t, fd);
  8003b7:	83 ec 04             	sub    $0x4,%esp
  8003ba:	50                   	push   %eax
  8003bb:	ff 75 a4             	pushl  -0x5c(%ebp)
  8003be:	68 8e 3d 80 00       	push   $0x803d8e
  8003c3:	e8 4a 08 00 00       	call   800c12 <cprintf>
				exit();
  8003c8:	e8 1b 07 00 00       	call   800ae8 <exit>
  8003cd:	83 c4 10             	add    $0x10,%esp
				dup(fd, 1);
  8003d0:	83 ec 08             	sub    $0x8,%esp
  8003d3:	6a 01                	push   $0x1
  8003d5:	53                   	push   %ebx
  8003d6:	e8 a4 1f 00 00       	call   80237f <dup>
				close(fd);
  8003db:	89 1c 24             	mov    %ebx,(%esp)
  8003de:	e8 4a 1f 00 00       	call   80232d <close>
  8003e3:	83 c4 10             	add    $0x10,%esp
  8003e6:	e9 30 fe ff ff       	jmp    80021b <runcmd+0x21>
				cprintf("pipe: %e", r);
  8003eb:	83 ec 08             	sub    $0x8,%esp
  8003ee:	50                   	push   %eax
  8003ef:	68 a4 3d 80 00       	push   $0x803da4
  8003f4:	e8 19 08 00 00       	call   800c12 <cprintf>
				exit();
  8003f9:	e8 ea 06 00 00       	call   800ae8 <exit>
  8003fe:	83 c4 10             	add    $0x10,%esp
  800401:	e9 a4 fe ff ff       	jmp    8002aa <runcmd+0xb0>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  800406:	83 ec 04             	sub    $0x4,%esp
  800409:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  80040f:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  800415:	68 ad 3d 80 00       	push   $0x803dad
  80041a:	e8 f3 07 00 00       	call   800c12 <cprintf>
  80041f:	83 c4 10             	add    $0x10,%esp
  800422:	e9 90 fe ff ff       	jmp    8002b7 <runcmd+0xbd>
				cprintf("fork: %e", r);
  800427:	83 ec 08             	sub    $0x8,%esp
  80042a:	50                   	push   %eax
  80042b:	68 ba 3d 80 00       	push   $0x803dba
  800430:	e8 dd 07 00 00       	call   800c12 <cprintf>
				exit();
  800435:	e8 ae 06 00 00       	call   800ae8 <exit>
  80043a:	83 c4 10             	add    $0x10,%esp
				if (p[1] != 1) {
  80043d:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  800443:	83 f8 01             	cmp    $0x1,%eax
  800446:	0f 85 cc 00 00 00    	jne    800518 <runcmd+0x31e>
				close(p[0]);
  80044c:	83 ec 0c             	sub    $0xc,%esp
  80044f:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  800455:	e8 d3 1e 00 00       	call   80232d <close>
				goto runit;
  80045a:	83 c4 10             	add    $0x10,%esp
	if(argc == 0) {
  80045d:	85 ff                	test   %edi,%edi
  80045f:	0f 84 e6 00 00 00    	je     80054b <runcmd+0x351>
	if (argv[0][0] != '/') {
  800465:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800468:	80 38 2f             	cmpb   $0x2f,(%eax)
  80046b:	0f 85 f5 00 00 00    	jne    800566 <runcmd+0x36c>
	argv[argc] = 0;
  800471:	c7 44 bd a8 00 00 00 	movl   $0x0,-0x58(%ebp,%edi,4)
  800478:	00 
	if (debug) {
  800479:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800480:	0f 85 08 01 00 00    	jne    80058e <runcmd+0x394>
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  800486:	83 ec 08             	sub    $0x8,%esp
  800489:	8d 45 a8             	lea    -0x58(%ebp),%eax
  80048c:	50                   	push   %eax
  80048d:	ff 75 a8             	pushl  -0x58(%ebp)
  800490:	e8 2d 26 00 00       	call   802ac2 <spawn>
  800495:	89 c6                	mov    %eax,%esi
  800497:	83 c4 10             	add    $0x10,%esp
  80049a:	85 c0                	test   %eax,%eax
  80049c:	0f 88 3a 01 00 00    	js     8005dc <runcmd+0x3e2>
	close_all();
  8004a2:	e8 b3 1e 00 00       	call   80235a <close_all>
		if (debug)
  8004a7:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8004ae:	0f 85 75 01 00 00    	jne    800629 <runcmd+0x42f>
		wait(r);
  8004b4:	83 ec 0c             	sub    $0xc,%esp
  8004b7:	56                   	push   %esi
  8004b8:	e8 d7 33 00 00       	call   803894 <wait>
		if (debug)
  8004bd:	83 c4 10             	add    $0x10,%esp
  8004c0:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8004c7:	0f 85 7b 01 00 00    	jne    800648 <runcmd+0x44e>
	if (pipe_child) {
  8004cd:	85 db                	test   %ebx,%ebx
  8004cf:	74 19                	je     8004ea <runcmd+0x2f0>
		wait(pipe_child);
  8004d1:	83 ec 0c             	sub    $0xc,%esp
  8004d4:	53                   	push   %ebx
  8004d5:	e8 ba 33 00 00       	call   803894 <wait>
		if (debug)
  8004da:	83 c4 10             	add    $0x10,%esp
  8004dd:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8004e4:	0f 85 79 01 00 00    	jne    800663 <runcmd+0x469>
	exit();
  8004ea:	e8 f9 05 00 00       	call   800ae8 <exit>
}
  8004ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004f2:	5b                   	pop    %ebx
  8004f3:	5e                   	pop    %esi
  8004f4:	5f                   	pop    %edi
  8004f5:	5d                   	pop    %ebp
  8004f6:	c3                   	ret    
					dup(p[0], 0);
  8004f7:	83 ec 08             	sub    $0x8,%esp
  8004fa:	6a 00                	push   $0x0
  8004fc:	50                   	push   %eax
  8004fd:	e8 7d 1e 00 00       	call   80237f <dup>
					close(p[0]);
  800502:	83 c4 04             	add    $0x4,%esp
  800505:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  80050b:	e8 1d 1e 00 00       	call   80232d <close>
  800510:	83 c4 10             	add    $0x10,%esp
  800513:	e9 c2 fd ff ff       	jmp    8002da <runcmd+0xe0>
					dup(p[1], 1);
  800518:	83 ec 08             	sub    $0x8,%esp
  80051b:	6a 01                	push   $0x1
  80051d:	50                   	push   %eax
  80051e:	e8 5c 1e 00 00       	call   80237f <dup>
					close(p[1]);
  800523:	83 c4 04             	add    $0x4,%esp
  800526:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  80052c:	e8 fc 1d 00 00       	call   80232d <close>
  800531:	83 c4 10             	add    $0x10,%esp
  800534:	e9 13 ff ff ff       	jmp    80044c <runcmd+0x252>
			panic("bad return %d from gettoken", c);
  800539:	53                   	push   %ebx
  80053a:	68 c3 3d 80 00       	push   $0x803dc3
  80053f:	6a 78                	push   $0x78
  800541:	68 df 3d 80 00       	push   $0x803ddf
  800546:	e8 d1 05 00 00       	call   800b1c <_panic>
		if (debug)
  80054b:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800552:	74 9b                	je     8004ef <runcmd+0x2f5>
			cprintf("EMPTY COMMAND\n");
  800554:	83 ec 0c             	sub    $0xc,%esp
  800557:	68 e9 3d 80 00       	push   $0x803de9
  80055c:	e8 b1 06 00 00       	call   800c12 <cprintf>
  800561:	83 c4 10             	add    $0x10,%esp
  800564:	eb 89                	jmp    8004ef <runcmd+0x2f5>
		argv0buf[0] = '/';
  800566:	c6 85 a4 fb ff ff 2f 	movb   $0x2f,-0x45c(%ebp)
		strcpy(argv0buf + 1, argv[0]);
  80056d:	83 ec 08             	sub    $0x8,%esp
  800570:	50                   	push   %eax
  800571:	8d b5 a4 fb ff ff    	lea    -0x45c(%ebp),%esi
  800577:	8d 85 a5 fb ff ff    	lea    -0x45b(%ebp),%eax
  80057d:	50                   	push   %eax
  80057e:	e8 de 0e 00 00       	call   801461 <strcpy>
		argv[0] = argv0buf;
  800583:	89 75 a8             	mov    %esi,-0x58(%ebp)
  800586:	83 c4 10             	add    $0x10,%esp
  800589:	e9 e3 fe ff ff       	jmp    800471 <runcmd+0x277>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  80058e:	a1 28 64 80 00       	mov    0x806428,%eax
  800593:	8b 40 48             	mov    0x48(%eax),%eax
  800596:	83 ec 08             	sub    $0x8,%esp
  800599:	50                   	push   %eax
  80059a:	68 f8 3d 80 00       	push   $0x803df8
  80059f:	e8 6e 06 00 00       	call   800c12 <cprintf>
  8005a4:	8d 75 a8             	lea    -0x58(%ebp),%esi
		for (i = 0; argv[i]; i++)
  8005a7:	83 c4 10             	add    $0x10,%esp
  8005aa:	eb 11                	jmp    8005bd <runcmd+0x3c3>
			cprintf(" %s", argv[i]);
  8005ac:	83 ec 08             	sub    $0x8,%esp
  8005af:	50                   	push   %eax
  8005b0:	68 80 3e 80 00       	push   $0x803e80
  8005b5:	e8 58 06 00 00       	call   800c12 <cprintf>
  8005ba:	83 c4 10             	add    $0x10,%esp
  8005bd:	83 c6 04             	add    $0x4,%esi
		for (i = 0; argv[i]; i++)
  8005c0:	8b 46 fc             	mov    -0x4(%esi),%eax
  8005c3:	85 c0                	test   %eax,%eax
  8005c5:	75 e5                	jne    8005ac <runcmd+0x3b2>
		cprintf("\n");
  8005c7:	83 ec 0c             	sub    $0xc,%esp
  8005ca:	68 40 3d 80 00       	push   $0x803d40
  8005cf:	e8 3e 06 00 00       	call   800c12 <cprintf>
  8005d4:	83 c4 10             	add    $0x10,%esp
  8005d7:	e9 aa fe ff ff       	jmp    800486 <runcmd+0x28c>
		cprintf("spawn %s: %e\n", argv[0], r);
  8005dc:	83 ec 04             	sub    $0x4,%esp
  8005df:	50                   	push   %eax
  8005e0:	ff 75 a8             	pushl  -0x58(%ebp)
  8005e3:	68 06 3e 80 00       	push   $0x803e06
  8005e8:	e8 25 06 00 00       	call   800c12 <cprintf>
	close_all();
  8005ed:	e8 68 1d 00 00       	call   80235a <close_all>
  8005f2:	83 c4 10             	add    $0x10,%esp
	if (pipe_child) {
  8005f5:	85 db                	test   %ebx,%ebx
  8005f7:	0f 84 ed fe ff ff    	je     8004ea <runcmd+0x2f0>
		if (debug)
  8005fd:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800604:	0f 84 c7 fe ff ff    	je     8004d1 <runcmd+0x2d7>
			cprintf("[%08x] WAIT pipe_child %08x\n", thisenv->env_id, pipe_child);
  80060a:	a1 28 64 80 00       	mov    0x806428,%eax
  80060f:	8b 40 48             	mov    0x48(%eax),%eax
  800612:	83 ec 04             	sub    $0x4,%esp
  800615:	53                   	push   %ebx
  800616:	50                   	push   %eax
  800617:	68 3f 3e 80 00       	push   $0x803e3f
  80061c:	e8 f1 05 00 00       	call   800c12 <cprintf>
  800621:	83 c4 10             	add    $0x10,%esp
  800624:	e9 a8 fe ff ff       	jmp    8004d1 <runcmd+0x2d7>
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  800629:	a1 28 64 80 00       	mov    0x806428,%eax
  80062e:	8b 40 48             	mov    0x48(%eax),%eax
  800631:	56                   	push   %esi
  800632:	ff 75 a8             	pushl  -0x58(%ebp)
  800635:	50                   	push   %eax
  800636:	68 14 3e 80 00       	push   $0x803e14
  80063b:	e8 d2 05 00 00       	call   800c12 <cprintf>
  800640:	83 c4 10             	add    $0x10,%esp
  800643:	e9 6c fe ff ff       	jmp    8004b4 <runcmd+0x2ba>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800648:	a1 28 64 80 00       	mov    0x806428,%eax
  80064d:	8b 40 48             	mov    0x48(%eax),%eax
  800650:	83 ec 08             	sub    $0x8,%esp
  800653:	50                   	push   %eax
  800654:	68 29 3e 80 00       	push   $0x803e29
  800659:	e8 b4 05 00 00       	call   800c12 <cprintf>
  80065e:	83 c4 10             	add    $0x10,%esp
  800661:	eb 92                	jmp    8005f5 <runcmd+0x3fb>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800663:	a1 28 64 80 00       	mov    0x806428,%eax
  800668:	8b 40 48             	mov    0x48(%eax),%eax
  80066b:	83 ec 08             	sub    $0x8,%esp
  80066e:	50                   	push   %eax
  80066f:	68 29 3e 80 00       	push   $0x803e29
  800674:	e8 99 05 00 00       	call   800c12 <cprintf>
  800679:	83 c4 10             	add    $0x10,%esp
  80067c:	e9 69 fe ff ff       	jmp    8004ea <runcmd+0x2f0>

00800681 <usage>:


void
usage(void)
{
  800681:	55                   	push   %ebp
  800682:	89 e5                	mov    %esp,%ebp
  800684:	83 ec 14             	sub    $0x14,%esp
	cprintf("usage: sh [-dix] [command-file]\n");
  800687:	68 08 3f 80 00       	push   $0x803f08
  80068c:	e8 81 05 00 00       	call   800c12 <cprintf>
	exit();
  800691:	e8 52 04 00 00       	call   800ae8 <exit>
}
  800696:	83 c4 10             	add    $0x10,%esp
  800699:	c9                   	leave  
  80069a:	c3                   	ret    

0080069b <umain>:

void
umain(int argc, char **argv)
{
  80069b:	55                   	push   %ebp
  80069c:	89 e5                	mov    %esp,%ebp
  80069e:	57                   	push   %edi
  80069f:	56                   	push   %esi
  8006a0:	53                   	push   %ebx
  8006a1:	83 ec 30             	sub    $0x30,%esp
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
  8006a4:	8d 45 d8             	lea    -0x28(%ebp),%eax
  8006a7:	50                   	push   %eax
  8006a8:	ff 75 0c             	pushl  0xc(%ebp)
  8006ab:	8d 45 08             	lea    0x8(%ebp),%eax
  8006ae:	50                   	push   %eax
  8006af:	e8 81 19 00 00       	call   802035 <argstart>
	while ((r = argnext(&args)) >= 0)
  8006b4:	83 c4 10             	add    $0x10,%esp
	echocmds = 0;
  8006b7:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
	interactive = '?';
  8006be:	bf 3f 00 00 00       	mov    $0x3f,%edi
	while ((r = argnext(&args)) >= 0)
  8006c3:	8d 5d d8             	lea    -0x28(%ebp),%ebx
		switch (r) {
		case 'd':
			debug++;
			break;
		case 'i':
			interactive = 1;
  8006c6:	be 01 00 00 00       	mov    $0x1,%esi
	while ((r = argnext(&args)) >= 0)
  8006cb:	eb 10                	jmp    8006dd <umain+0x42>
			debug++;
  8006cd:	83 05 00 60 80 00 01 	addl   $0x1,0x806000
			break;
  8006d4:	eb 07                	jmp    8006dd <umain+0x42>
			interactive = 1;
  8006d6:	89 f7                	mov    %esi,%edi
  8006d8:	eb 03                	jmp    8006dd <umain+0x42>
			break;
		case 'x':
			echocmds = 1;
  8006da:	89 75 d4             	mov    %esi,-0x2c(%ebp)
	while ((r = argnext(&args)) >= 0)
  8006dd:	83 ec 0c             	sub    $0xc,%esp
  8006e0:	53                   	push   %ebx
  8006e1:	e8 7f 19 00 00       	call   802065 <argnext>
  8006e6:	83 c4 10             	add    $0x10,%esp
  8006e9:	85 c0                	test   %eax,%eax
  8006eb:	78 16                	js     800703 <umain+0x68>
		switch (r) {
  8006ed:	83 f8 69             	cmp    $0x69,%eax
  8006f0:	74 e4                	je     8006d6 <umain+0x3b>
  8006f2:	83 f8 78             	cmp    $0x78,%eax
  8006f5:	74 e3                	je     8006da <umain+0x3f>
  8006f7:	83 f8 64             	cmp    $0x64,%eax
  8006fa:	74 d1                	je     8006cd <umain+0x32>
			break;
		default:
			usage();
  8006fc:	e8 80 ff ff ff       	call   800681 <usage>
  800701:	eb da                	jmp    8006dd <umain+0x42>
		}

	if (argc > 2)
  800703:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  800707:	7f 1f                	jg     800728 <umain+0x8d>
		usage();
	if (argc == 2) {
  800709:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  80070d:	74 20                	je     80072f <umain+0x94>
		close(0);
		if ((r = open(argv[1], O_RDONLY)) < 0)
			panic("open %s: %e", argv[1], r);
		assert(r == 0);
	}
	if (interactive == '?')
  80070f:	83 ff 3f             	cmp    $0x3f,%edi
  800712:	74 75                	je     800789 <umain+0xee>
  800714:	85 ff                	test   %edi,%edi
  800716:	bf 84 3e 80 00       	mov    $0x803e84,%edi
  80071b:	b8 00 00 00 00       	mov    $0x0,%eax
  800720:	0f 44 f8             	cmove  %eax,%edi
  800723:	e9 06 01 00 00       	jmp    80082e <umain+0x193>
		usage();
  800728:	e8 54 ff ff ff       	call   800681 <usage>
  80072d:	eb da                	jmp    800709 <umain+0x6e>
		close(0);
  80072f:	83 ec 0c             	sub    $0xc,%esp
  800732:	6a 00                	push   $0x0
  800734:	e8 f4 1b 00 00       	call   80232d <close>
		if ((r = open(argv[1], O_RDONLY)) < 0)
  800739:	83 c4 08             	add    $0x8,%esp
  80073c:	6a 00                	push   $0x0
  80073e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800741:	ff 70 04             	pushl  0x4(%eax)
  800744:	e8 c0 21 00 00       	call   802909 <open>
  800749:	83 c4 10             	add    $0x10,%esp
  80074c:	85 c0                	test   %eax,%eax
  80074e:	78 1b                	js     80076b <umain+0xd0>
		assert(r == 0);
  800750:	74 bd                	je     80070f <umain+0x74>
  800752:	68 68 3e 80 00       	push   $0x803e68
  800757:	68 6f 3e 80 00       	push   $0x803e6f
  80075c:	68 29 01 00 00       	push   $0x129
  800761:	68 df 3d 80 00       	push   $0x803ddf
  800766:	e8 b1 03 00 00       	call   800b1c <_panic>
			panic("open %s: %e", argv[1], r);
  80076b:	83 ec 0c             	sub    $0xc,%esp
  80076e:	50                   	push   %eax
  80076f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800772:	ff 70 04             	pushl  0x4(%eax)
  800775:	68 5c 3e 80 00       	push   $0x803e5c
  80077a:	68 28 01 00 00       	push   $0x128
  80077f:	68 df 3d 80 00       	push   $0x803ddf
  800784:	e8 93 03 00 00       	call   800b1c <_panic>
		interactive = iscons(0);
  800789:	83 ec 0c             	sub    $0xc,%esp
  80078c:	6a 00                	push   $0x0
  80078e:	e8 fc 01 00 00       	call   80098f <iscons>
  800793:	89 c7                	mov    %eax,%edi
  800795:	83 c4 10             	add    $0x10,%esp
  800798:	e9 77 ff ff ff       	jmp    800714 <umain+0x79>
	while (1) {
		char *buf;

		buf = readline(interactive ? "$ " : NULL);
		if (buf == NULL) {
			if (debug)
  80079d:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8007a4:	75 0a                	jne    8007b0 <umain+0x115>
				cprintf("EXITING\n");
			exit();	// end of file
  8007a6:	e8 3d 03 00 00       	call   800ae8 <exit>
  8007ab:	e9 94 00 00 00       	jmp    800844 <umain+0x1a9>
				cprintf("EXITING\n");
  8007b0:	83 ec 0c             	sub    $0xc,%esp
  8007b3:	68 87 3e 80 00       	push   $0x803e87
  8007b8:	e8 55 04 00 00       	call   800c12 <cprintf>
  8007bd:	83 c4 10             	add    $0x10,%esp
  8007c0:	eb e4                	jmp    8007a6 <umain+0x10b>
		}
		if (debug)
			cprintf("LINE: %s\n", buf);
  8007c2:	83 ec 08             	sub    $0x8,%esp
  8007c5:	53                   	push   %ebx
  8007c6:	68 90 3e 80 00       	push   $0x803e90
  8007cb:	e8 42 04 00 00       	call   800c12 <cprintf>
  8007d0:	83 c4 10             	add    $0x10,%esp
  8007d3:	eb 7c                	jmp    800851 <umain+0x1b6>
		if (buf[0] == '#')
			continue;
		if (echocmds)
			printf("# %s\n", buf);
  8007d5:	83 ec 08             	sub    $0x8,%esp
  8007d8:	53                   	push   %ebx
  8007d9:	68 9a 3e 80 00       	push   $0x803e9a
  8007de:	e8 c9 22 00 00       	call   802aac <printf>
  8007e3:	83 c4 10             	add    $0x10,%esp
  8007e6:	eb 78                	jmp    800860 <umain+0x1c5>
		if (debug)
			cprintf("BEFORE FORK\n");
  8007e8:	83 ec 0c             	sub    $0xc,%esp
  8007eb:	68 a0 3e 80 00       	push   $0x803ea0
  8007f0:	e8 1d 04 00 00       	call   800c12 <cprintf>
  8007f5:	83 c4 10             	add    $0x10,%esp
  8007f8:	eb 73                	jmp    80086d <umain+0x1d2>
		if ((r = fork()) < 0)
			panic("fork: %e", r);
  8007fa:	50                   	push   %eax
  8007fb:	68 ba 3d 80 00       	push   $0x803dba
  800800:	68 40 01 00 00       	push   $0x140
  800805:	68 df 3d 80 00       	push   $0x803ddf
  80080a:	e8 0d 03 00 00       	call   800b1c <_panic>
		if (debug)
			cprintf("FORK: %d\n", r);
  80080f:	83 ec 08             	sub    $0x8,%esp
  800812:	50                   	push   %eax
  800813:	68 ad 3e 80 00       	push   $0x803ead
  800818:	e8 f5 03 00 00       	call   800c12 <cprintf>
  80081d:	83 c4 10             	add    $0x10,%esp
  800820:	eb 5f                	jmp    800881 <umain+0x1e6>
		if (r == 0) {
			runcmd(buf);
			exit();
		} else
			wait(r);
  800822:	83 ec 0c             	sub    $0xc,%esp
  800825:	56                   	push   %esi
  800826:	e8 69 30 00 00       	call   803894 <wait>
  80082b:	83 c4 10             	add    $0x10,%esp
		buf = readline(interactive ? "$ " : NULL);
  80082e:	83 ec 0c             	sub    $0xc,%esp
  800831:	57                   	push   %edi
  800832:	e8 01 0b 00 00       	call   801338 <readline>
  800837:	89 c3                	mov    %eax,%ebx
		if (buf == NULL) {
  800839:	83 c4 10             	add    $0x10,%esp
  80083c:	85 c0                	test   %eax,%eax
  80083e:	0f 84 59 ff ff ff    	je     80079d <umain+0x102>
		if (debug)
  800844:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80084b:	0f 85 71 ff ff ff    	jne    8007c2 <umain+0x127>
		if (buf[0] == '#')
  800851:	80 3b 23             	cmpb   $0x23,(%ebx)
  800854:	74 d8                	je     80082e <umain+0x193>
		if (echocmds)
  800856:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80085a:	0f 85 75 ff ff ff    	jne    8007d5 <umain+0x13a>
		if (debug)
  800860:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800867:	0f 85 7b ff ff ff    	jne    8007e8 <umain+0x14d>
		if ((r = fork()) < 0)
  80086d:	e8 2b 15 00 00       	call   801d9d <fork>
  800872:	89 c6                	mov    %eax,%esi
  800874:	85 c0                	test   %eax,%eax
  800876:	78 82                	js     8007fa <umain+0x15f>
		if (debug)
  800878:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80087f:	75 8e                	jne    80080f <umain+0x174>
		if (r == 0) {
  800881:	85 f6                	test   %esi,%esi
  800883:	75 9d                	jne    800822 <umain+0x187>
			runcmd(buf);
  800885:	83 ec 0c             	sub    $0xc,%esp
  800888:	53                   	push   %ebx
  800889:	e8 6c f9 ff ff       	call   8001fa <runcmd>
			exit();
  80088e:	e8 55 02 00 00       	call   800ae8 <exit>
  800893:	83 c4 10             	add    $0x10,%esp
  800896:	eb 96                	jmp    80082e <umain+0x193>

00800898 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  800898:	b8 00 00 00 00       	mov    $0x0,%eax
  80089d:	c3                   	ret    

0080089e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80089e:	55                   	push   %ebp
  80089f:	89 e5                	mov    %esp,%ebp
  8008a1:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8008a4:	68 29 3f 80 00       	push   $0x803f29
  8008a9:	ff 75 0c             	pushl  0xc(%ebp)
  8008ac:	e8 b0 0b 00 00       	call   801461 <strcpy>
	return 0;
}
  8008b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b6:	c9                   	leave  
  8008b7:	c3                   	ret    

008008b8 <devcons_write>:
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	57                   	push   %edi
  8008bc:	56                   	push   %esi
  8008bd:	53                   	push   %ebx
  8008be:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8008c4:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8008c9:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8008cf:	3b 75 10             	cmp    0x10(%ebp),%esi
  8008d2:	73 31                	jae    800905 <devcons_write+0x4d>
		m = n - tot;
  8008d4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8008d7:	29 f3                	sub    %esi,%ebx
  8008d9:	83 fb 7f             	cmp    $0x7f,%ebx
  8008dc:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8008e1:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8008e4:	83 ec 04             	sub    $0x4,%esp
  8008e7:	53                   	push   %ebx
  8008e8:	89 f0                	mov    %esi,%eax
  8008ea:	03 45 0c             	add    0xc(%ebp),%eax
  8008ed:	50                   	push   %eax
  8008ee:	57                   	push   %edi
  8008ef:	e8 fb 0c 00 00       	call   8015ef <memmove>
		sys_cputs(buf, m);
  8008f4:	83 c4 08             	add    $0x8,%esp
  8008f7:	53                   	push   %ebx
  8008f8:	57                   	push   %edi
  8008f9:	e8 99 0e 00 00       	call   801797 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8008fe:	01 de                	add    %ebx,%esi
  800900:	83 c4 10             	add    $0x10,%esp
  800903:	eb ca                	jmp    8008cf <devcons_write+0x17>
}
  800905:	89 f0                	mov    %esi,%eax
  800907:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80090a:	5b                   	pop    %ebx
  80090b:	5e                   	pop    %esi
  80090c:	5f                   	pop    %edi
  80090d:	5d                   	pop    %ebp
  80090e:	c3                   	ret    

0080090f <devcons_read>:
{
  80090f:	55                   	push   %ebp
  800910:	89 e5                	mov    %esp,%ebp
  800912:	83 ec 08             	sub    $0x8,%esp
  800915:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80091a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80091e:	74 21                	je     800941 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  800920:	e8 90 0e 00 00       	call   8017b5 <sys_cgetc>
  800925:	85 c0                	test   %eax,%eax
  800927:	75 07                	jne    800930 <devcons_read+0x21>
		sys_yield();
  800929:	e8 06 0f 00 00       	call   801834 <sys_yield>
  80092e:	eb f0                	jmp    800920 <devcons_read+0x11>
	if (c < 0)
  800930:	78 0f                	js     800941 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  800932:	83 f8 04             	cmp    $0x4,%eax
  800935:	74 0c                	je     800943 <devcons_read+0x34>
	*(char*)vbuf = c;
  800937:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093a:	88 02                	mov    %al,(%edx)
	return 1;
  80093c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800941:	c9                   	leave  
  800942:	c3                   	ret    
		return 0;
  800943:	b8 00 00 00 00       	mov    $0x0,%eax
  800948:	eb f7                	jmp    800941 <devcons_read+0x32>

0080094a <cputchar>:
{
  80094a:	55                   	push   %ebp
  80094b:	89 e5                	mov    %esp,%ebp
  80094d:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  800956:	6a 01                	push   $0x1
  800958:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80095b:	50                   	push   %eax
  80095c:	e8 36 0e 00 00       	call   801797 <sys_cputs>
}
  800961:	83 c4 10             	add    $0x10,%esp
  800964:	c9                   	leave  
  800965:	c3                   	ret    

00800966 <getchar>:
{
  800966:	55                   	push   %ebp
  800967:	89 e5                	mov    %esp,%ebp
  800969:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80096c:	6a 01                	push   $0x1
  80096e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800971:	50                   	push   %eax
  800972:	6a 00                	push   $0x0
  800974:	e8 f2 1a 00 00       	call   80246b <read>
	if (r < 0)
  800979:	83 c4 10             	add    $0x10,%esp
  80097c:	85 c0                	test   %eax,%eax
  80097e:	78 06                	js     800986 <getchar+0x20>
	if (r < 1)
  800980:	74 06                	je     800988 <getchar+0x22>
	return c;
  800982:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800986:	c9                   	leave  
  800987:	c3                   	ret    
		return -E_EOF;
  800988:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80098d:	eb f7                	jmp    800986 <getchar+0x20>

0080098f <iscons>:
{
  80098f:	55                   	push   %ebp
  800990:	89 e5                	mov    %esp,%ebp
  800992:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800995:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800998:	50                   	push   %eax
  800999:	ff 75 08             	pushl  0x8(%ebp)
  80099c:	e8 5a 18 00 00       	call   8021fb <fd_lookup>
  8009a1:	83 c4 10             	add    $0x10,%esp
  8009a4:	85 c0                	test   %eax,%eax
  8009a6:	78 11                	js     8009b9 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8009a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009ab:	8b 15 00 50 80 00    	mov    0x805000,%edx
  8009b1:	39 10                	cmp    %edx,(%eax)
  8009b3:	0f 94 c0             	sete   %al
  8009b6:	0f b6 c0             	movzbl %al,%eax
}
  8009b9:	c9                   	leave  
  8009ba:	c3                   	ret    

008009bb <opencons>:
{
  8009bb:	55                   	push   %ebp
  8009bc:	89 e5                	mov    %esp,%ebp
  8009be:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8009c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009c4:	50                   	push   %eax
  8009c5:	e8 df 17 00 00       	call   8021a9 <fd_alloc>
  8009ca:	83 c4 10             	add    $0x10,%esp
  8009cd:	85 c0                	test   %eax,%eax
  8009cf:	78 3a                	js     800a0b <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8009d1:	83 ec 04             	sub    $0x4,%esp
  8009d4:	68 07 04 00 00       	push   $0x407
  8009d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8009dc:	6a 00                	push   $0x0
  8009de:	e8 70 0e 00 00       	call   801853 <sys_page_alloc>
  8009e3:	83 c4 10             	add    $0x10,%esp
  8009e6:	85 c0                	test   %eax,%eax
  8009e8:	78 21                	js     800a0b <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8009ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009ed:	8b 15 00 50 80 00    	mov    0x805000,%edx
  8009f3:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8009f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009f8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8009ff:	83 ec 0c             	sub    $0xc,%esp
  800a02:	50                   	push   %eax
  800a03:	e8 7a 17 00 00       	call   802182 <fd2num>
  800a08:	83 c4 10             	add    $0x10,%esp
}
  800a0b:	c9                   	leave  
  800a0c:	c3                   	ret    

00800a0d <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
  800a10:	57                   	push   %edi
  800a11:	56                   	push   %esi
  800a12:	53                   	push   %ebx
  800a13:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  800a16:	c7 05 28 64 80 00 00 	movl   $0x0,0x806428
  800a1d:	00 00 00 
	envid_t find = sys_getenvid();
  800a20:	e8 f0 0d 00 00       	call   801815 <sys_getenvid>
  800a25:	8b 1d 28 64 80 00    	mov    0x806428,%ebx
  800a2b:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800a30:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  800a35:	bf 01 00 00 00       	mov    $0x1,%edi
  800a3a:	eb 0b                	jmp    800a47 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800a3c:	83 c2 01             	add    $0x1,%edx
  800a3f:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800a45:	74 23                	je     800a6a <libmain+0x5d>
		if(envs[i].env_id == find)
  800a47:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  800a4d:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800a53:	8b 49 48             	mov    0x48(%ecx),%ecx
  800a56:	39 c1                	cmp    %eax,%ecx
  800a58:	75 e2                	jne    800a3c <libmain+0x2f>
  800a5a:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  800a60:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800a66:	89 fe                	mov    %edi,%esi
  800a68:	eb d2                	jmp    800a3c <libmain+0x2f>
  800a6a:	89 f0                	mov    %esi,%eax
  800a6c:	84 c0                	test   %al,%al
  800a6e:	74 06                	je     800a76 <libmain+0x69>
  800a70:	89 1d 28 64 80 00    	mov    %ebx,0x806428
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a76:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a7a:	7e 0a                	jle    800a86 <libmain+0x79>
		binaryname = argv[0];
  800a7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7f:	8b 00                	mov    (%eax),%eax
  800a81:	a3 1c 50 80 00       	mov    %eax,0x80501c

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  800a86:	a1 28 64 80 00       	mov    0x806428,%eax
  800a8b:	8b 40 48             	mov    0x48(%eax),%eax
  800a8e:	83 ec 08             	sub    $0x8,%esp
  800a91:	50                   	push   %eax
  800a92:	68 35 3f 80 00       	push   $0x803f35
  800a97:	e8 76 01 00 00       	call   800c12 <cprintf>
	cprintf("before umain\n");
  800a9c:	c7 04 24 53 3f 80 00 	movl   $0x803f53,(%esp)
  800aa3:	e8 6a 01 00 00       	call   800c12 <cprintf>
	// call user main routine
	umain(argc, argv);
  800aa8:	83 c4 08             	add    $0x8,%esp
  800aab:	ff 75 0c             	pushl  0xc(%ebp)
  800aae:	ff 75 08             	pushl  0x8(%ebp)
  800ab1:	e8 e5 fb ff ff       	call   80069b <umain>
	cprintf("after umain\n");
  800ab6:	c7 04 24 61 3f 80 00 	movl   $0x803f61,(%esp)
  800abd:	e8 50 01 00 00       	call   800c12 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800ac2:	a1 28 64 80 00       	mov    0x806428,%eax
  800ac7:	8b 40 48             	mov    0x48(%eax),%eax
  800aca:	83 c4 08             	add    $0x8,%esp
  800acd:	50                   	push   %eax
  800ace:	68 6e 3f 80 00       	push   $0x803f6e
  800ad3:	e8 3a 01 00 00       	call   800c12 <cprintf>
	// exit gracefully
	exit();
  800ad8:	e8 0b 00 00 00       	call   800ae8 <exit>
}
  800add:	83 c4 10             	add    $0x10,%esp
  800ae0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ae3:	5b                   	pop    %ebx
  800ae4:	5e                   	pop    %esi
  800ae5:	5f                   	pop    %edi
  800ae6:	5d                   	pop    %ebp
  800ae7:	c3                   	ret    

00800ae8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800ae8:	55                   	push   %ebp
  800ae9:	89 e5                	mov    %esp,%ebp
  800aeb:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800aee:	a1 28 64 80 00       	mov    0x806428,%eax
  800af3:	8b 40 48             	mov    0x48(%eax),%eax
  800af6:	68 98 3f 80 00       	push   $0x803f98
  800afb:	50                   	push   %eax
  800afc:	68 8d 3f 80 00       	push   $0x803f8d
  800b01:	e8 0c 01 00 00       	call   800c12 <cprintf>
	close_all();
  800b06:	e8 4f 18 00 00       	call   80235a <close_all>
	sys_env_destroy(0);
  800b0b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800b12:	e8 bd 0c 00 00       	call   8017d4 <sys_env_destroy>
}
  800b17:	83 c4 10             	add    $0x10,%esp
  800b1a:	c9                   	leave  
  800b1b:	c3                   	ret    

00800b1c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
  800b1f:	56                   	push   %esi
  800b20:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800b21:	a1 28 64 80 00       	mov    0x806428,%eax
  800b26:	8b 40 48             	mov    0x48(%eax),%eax
  800b29:	83 ec 04             	sub    $0x4,%esp
  800b2c:	68 c4 3f 80 00       	push   $0x803fc4
  800b31:	50                   	push   %eax
  800b32:	68 8d 3f 80 00       	push   $0x803f8d
  800b37:	e8 d6 00 00 00       	call   800c12 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800b3c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800b3f:	8b 35 1c 50 80 00    	mov    0x80501c,%esi
  800b45:	e8 cb 0c 00 00       	call   801815 <sys_getenvid>
  800b4a:	83 c4 04             	add    $0x4,%esp
  800b4d:	ff 75 0c             	pushl  0xc(%ebp)
  800b50:	ff 75 08             	pushl  0x8(%ebp)
  800b53:	56                   	push   %esi
  800b54:	50                   	push   %eax
  800b55:	68 a0 3f 80 00       	push   $0x803fa0
  800b5a:	e8 b3 00 00 00       	call   800c12 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800b5f:	83 c4 18             	add    $0x18,%esp
  800b62:	53                   	push   %ebx
  800b63:	ff 75 10             	pushl  0x10(%ebp)
  800b66:	e8 56 00 00 00       	call   800bc1 <vcprintf>
	cprintf("\n");
  800b6b:	c7 04 24 40 3d 80 00 	movl   $0x803d40,(%esp)
  800b72:	e8 9b 00 00 00       	call   800c12 <cprintf>
  800b77:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800b7a:	cc                   	int3   
  800b7b:	eb fd                	jmp    800b7a <_panic+0x5e>

00800b7d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800b7d:	55                   	push   %ebp
  800b7e:	89 e5                	mov    %esp,%ebp
  800b80:	53                   	push   %ebx
  800b81:	83 ec 04             	sub    $0x4,%esp
  800b84:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800b87:	8b 13                	mov    (%ebx),%edx
  800b89:	8d 42 01             	lea    0x1(%edx),%eax
  800b8c:	89 03                	mov    %eax,(%ebx)
  800b8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b91:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800b95:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b9a:	74 09                	je     800ba5 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800b9c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800ba0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ba3:	c9                   	leave  
  800ba4:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800ba5:	83 ec 08             	sub    $0x8,%esp
  800ba8:	68 ff 00 00 00       	push   $0xff
  800bad:	8d 43 08             	lea    0x8(%ebx),%eax
  800bb0:	50                   	push   %eax
  800bb1:	e8 e1 0b 00 00       	call   801797 <sys_cputs>
		b->idx = 0;
  800bb6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800bbc:	83 c4 10             	add    $0x10,%esp
  800bbf:	eb db                	jmp    800b9c <putch+0x1f>

00800bc1 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800bc1:	55                   	push   %ebp
  800bc2:	89 e5                	mov    %esp,%ebp
  800bc4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800bca:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800bd1:	00 00 00 
	b.cnt = 0;
  800bd4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800bdb:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800bde:	ff 75 0c             	pushl  0xc(%ebp)
  800be1:	ff 75 08             	pushl  0x8(%ebp)
  800be4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800bea:	50                   	push   %eax
  800beb:	68 7d 0b 80 00       	push   $0x800b7d
  800bf0:	e8 4a 01 00 00       	call   800d3f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800bf5:	83 c4 08             	add    $0x8,%esp
  800bf8:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800bfe:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800c04:	50                   	push   %eax
  800c05:	e8 8d 0b 00 00       	call   801797 <sys_cputs>

	return b.cnt;
}
  800c0a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800c10:	c9                   	leave  
  800c11:	c3                   	ret    

00800c12 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800c18:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800c1b:	50                   	push   %eax
  800c1c:	ff 75 08             	pushl  0x8(%ebp)
  800c1f:	e8 9d ff ff ff       	call   800bc1 <vcprintf>
	va_end(ap);

	return cnt;
}
  800c24:	c9                   	leave  
  800c25:	c3                   	ret    

00800c26 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
  800c29:	57                   	push   %edi
  800c2a:	56                   	push   %esi
  800c2b:	53                   	push   %ebx
  800c2c:	83 ec 1c             	sub    $0x1c,%esp
  800c2f:	89 c6                	mov    %eax,%esi
  800c31:	89 d7                	mov    %edx,%edi
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800c3c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800c3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c42:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800c45:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800c49:	74 2c                	je     800c77 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800c4b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c4e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800c55:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c58:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800c5b:	39 c2                	cmp    %eax,%edx
  800c5d:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800c60:	73 43                	jae    800ca5 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800c62:	83 eb 01             	sub    $0x1,%ebx
  800c65:	85 db                	test   %ebx,%ebx
  800c67:	7e 6c                	jle    800cd5 <printnum+0xaf>
				putch(padc, putdat);
  800c69:	83 ec 08             	sub    $0x8,%esp
  800c6c:	57                   	push   %edi
  800c6d:	ff 75 18             	pushl  0x18(%ebp)
  800c70:	ff d6                	call   *%esi
  800c72:	83 c4 10             	add    $0x10,%esp
  800c75:	eb eb                	jmp    800c62 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800c77:	83 ec 0c             	sub    $0xc,%esp
  800c7a:	6a 20                	push   $0x20
  800c7c:	6a 00                	push   $0x0
  800c7e:	50                   	push   %eax
  800c7f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c82:	ff 75 e0             	pushl  -0x20(%ebp)
  800c85:	89 fa                	mov    %edi,%edx
  800c87:	89 f0                	mov    %esi,%eax
  800c89:	e8 98 ff ff ff       	call   800c26 <printnum>
		while (--width > 0)
  800c8e:	83 c4 20             	add    $0x20,%esp
  800c91:	83 eb 01             	sub    $0x1,%ebx
  800c94:	85 db                	test   %ebx,%ebx
  800c96:	7e 65                	jle    800cfd <printnum+0xd7>
			putch(padc, putdat);
  800c98:	83 ec 08             	sub    $0x8,%esp
  800c9b:	57                   	push   %edi
  800c9c:	6a 20                	push   $0x20
  800c9e:	ff d6                	call   *%esi
  800ca0:	83 c4 10             	add    $0x10,%esp
  800ca3:	eb ec                	jmp    800c91 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800ca5:	83 ec 0c             	sub    $0xc,%esp
  800ca8:	ff 75 18             	pushl  0x18(%ebp)
  800cab:	83 eb 01             	sub    $0x1,%ebx
  800cae:	53                   	push   %ebx
  800caf:	50                   	push   %eax
  800cb0:	83 ec 08             	sub    $0x8,%esp
  800cb3:	ff 75 dc             	pushl  -0x24(%ebp)
  800cb6:	ff 75 d8             	pushl  -0x28(%ebp)
  800cb9:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cbc:	ff 75 e0             	pushl  -0x20(%ebp)
  800cbf:	e8 fc 2d 00 00       	call   803ac0 <__udivdi3>
  800cc4:	83 c4 18             	add    $0x18,%esp
  800cc7:	52                   	push   %edx
  800cc8:	50                   	push   %eax
  800cc9:	89 fa                	mov    %edi,%edx
  800ccb:	89 f0                	mov    %esi,%eax
  800ccd:	e8 54 ff ff ff       	call   800c26 <printnum>
  800cd2:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800cd5:	83 ec 08             	sub    $0x8,%esp
  800cd8:	57                   	push   %edi
  800cd9:	83 ec 04             	sub    $0x4,%esp
  800cdc:	ff 75 dc             	pushl  -0x24(%ebp)
  800cdf:	ff 75 d8             	pushl  -0x28(%ebp)
  800ce2:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ce5:	ff 75 e0             	pushl  -0x20(%ebp)
  800ce8:	e8 e3 2e 00 00       	call   803bd0 <__umoddi3>
  800ced:	83 c4 14             	add    $0x14,%esp
  800cf0:	0f be 80 cb 3f 80 00 	movsbl 0x803fcb(%eax),%eax
  800cf7:	50                   	push   %eax
  800cf8:	ff d6                	call   *%esi
  800cfa:	83 c4 10             	add    $0x10,%esp
	}
}
  800cfd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d00:	5b                   	pop    %ebx
  800d01:	5e                   	pop    %esi
  800d02:	5f                   	pop    %edi
  800d03:	5d                   	pop    %ebp
  800d04:	c3                   	ret    

00800d05 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800d0b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800d0f:	8b 10                	mov    (%eax),%edx
  800d11:	3b 50 04             	cmp    0x4(%eax),%edx
  800d14:	73 0a                	jae    800d20 <sprintputch+0x1b>
		*b->buf++ = ch;
  800d16:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d19:	89 08                	mov    %ecx,(%eax)
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	88 02                	mov    %al,(%edx)
}
  800d20:	5d                   	pop    %ebp
  800d21:	c3                   	ret    

00800d22 <printfmt>:
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
  800d25:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800d28:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800d2b:	50                   	push   %eax
  800d2c:	ff 75 10             	pushl  0x10(%ebp)
  800d2f:	ff 75 0c             	pushl  0xc(%ebp)
  800d32:	ff 75 08             	pushl  0x8(%ebp)
  800d35:	e8 05 00 00 00       	call   800d3f <vprintfmt>
}
  800d3a:	83 c4 10             	add    $0x10,%esp
  800d3d:	c9                   	leave  
  800d3e:	c3                   	ret    

00800d3f <vprintfmt>:
{
  800d3f:	55                   	push   %ebp
  800d40:	89 e5                	mov    %esp,%ebp
  800d42:	57                   	push   %edi
  800d43:	56                   	push   %esi
  800d44:	53                   	push   %ebx
  800d45:	83 ec 3c             	sub    $0x3c,%esp
  800d48:	8b 75 08             	mov    0x8(%ebp),%esi
  800d4b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800d4e:	8b 7d 10             	mov    0x10(%ebp),%edi
  800d51:	e9 32 04 00 00       	jmp    801188 <vprintfmt+0x449>
		padc = ' ';
  800d56:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800d5a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800d61:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800d68:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800d6f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d76:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800d7d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800d82:	8d 47 01             	lea    0x1(%edi),%eax
  800d85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d88:	0f b6 17             	movzbl (%edi),%edx
  800d8b:	8d 42 dd             	lea    -0x23(%edx),%eax
  800d8e:	3c 55                	cmp    $0x55,%al
  800d90:	0f 87 12 05 00 00    	ja     8012a8 <vprintfmt+0x569>
  800d96:	0f b6 c0             	movzbl %al,%eax
  800d99:	ff 24 85 a0 41 80 00 	jmp    *0x8041a0(,%eax,4)
  800da0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800da3:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800da7:	eb d9                	jmp    800d82 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800da9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800dac:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800db0:	eb d0                	jmp    800d82 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800db2:	0f b6 d2             	movzbl %dl,%edx
  800db5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800db8:	b8 00 00 00 00       	mov    $0x0,%eax
  800dbd:	89 75 08             	mov    %esi,0x8(%ebp)
  800dc0:	eb 03                	jmp    800dc5 <vprintfmt+0x86>
  800dc2:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800dc5:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800dc8:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800dcc:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800dcf:	8d 72 d0             	lea    -0x30(%edx),%esi
  800dd2:	83 fe 09             	cmp    $0x9,%esi
  800dd5:	76 eb                	jbe    800dc2 <vprintfmt+0x83>
  800dd7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800dda:	8b 75 08             	mov    0x8(%ebp),%esi
  800ddd:	eb 14                	jmp    800df3 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800ddf:	8b 45 14             	mov    0x14(%ebp),%eax
  800de2:	8b 00                	mov    (%eax),%eax
  800de4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800de7:	8b 45 14             	mov    0x14(%ebp),%eax
  800dea:	8d 40 04             	lea    0x4(%eax),%eax
  800ded:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800df0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800df3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800df7:	79 89                	jns    800d82 <vprintfmt+0x43>
				width = precision, precision = -1;
  800df9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800dfc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800dff:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800e06:	e9 77 ff ff ff       	jmp    800d82 <vprintfmt+0x43>
  800e0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e0e:	85 c0                	test   %eax,%eax
  800e10:	0f 48 c1             	cmovs  %ecx,%eax
  800e13:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800e16:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800e19:	e9 64 ff ff ff       	jmp    800d82 <vprintfmt+0x43>
  800e1e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800e21:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800e28:	e9 55 ff ff ff       	jmp    800d82 <vprintfmt+0x43>
			lflag++;
  800e2d:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800e31:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800e34:	e9 49 ff ff ff       	jmp    800d82 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800e39:	8b 45 14             	mov    0x14(%ebp),%eax
  800e3c:	8d 78 04             	lea    0x4(%eax),%edi
  800e3f:	83 ec 08             	sub    $0x8,%esp
  800e42:	53                   	push   %ebx
  800e43:	ff 30                	pushl  (%eax)
  800e45:	ff d6                	call   *%esi
			break;
  800e47:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800e4a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800e4d:	e9 33 03 00 00       	jmp    801185 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800e52:	8b 45 14             	mov    0x14(%ebp),%eax
  800e55:	8d 78 04             	lea    0x4(%eax),%edi
  800e58:	8b 00                	mov    (%eax),%eax
  800e5a:	99                   	cltd   
  800e5b:	31 d0                	xor    %edx,%eax
  800e5d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800e5f:	83 f8 11             	cmp    $0x11,%eax
  800e62:	7f 23                	jg     800e87 <vprintfmt+0x148>
  800e64:	8b 14 85 00 43 80 00 	mov    0x804300(,%eax,4),%edx
  800e6b:	85 d2                	test   %edx,%edx
  800e6d:	74 18                	je     800e87 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800e6f:	52                   	push   %edx
  800e70:	68 81 3e 80 00       	push   $0x803e81
  800e75:	53                   	push   %ebx
  800e76:	56                   	push   %esi
  800e77:	e8 a6 fe ff ff       	call   800d22 <printfmt>
  800e7c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800e7f:	89 7d 14             	mov    %edi,0x14(%ebp)
  800e82:	e9 fe 02 00 00       	jmp    801185 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800e87:	50                   	push   %eax
  800e88:	68 e3 3f 80 00       	push   $0x803fe3
  800e8d:	53                   	push   %ebx
  800e8e:	56                   	push   %esi
  800e8f:	e8 8e fe ff ff       	call   800d22 <printfmt>
  800e94:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800e97:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800e9a:	e9 e6 02 00 00       	jmp    801185 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800e9f:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea2:	83 c0 04             	add    $0x4,%eax
  800ea5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800ea8:	8b 45 14             	mov    0x14(%ebp),%eax
  800eab:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800ead:	85 c9                	test   %ecx,%ecx
  800eaf:	b8 dc 3f 80 00       	mov    $0x803fdc,%eax
  800eb4:	0f 45 c1             	cmovne %ecx,%eax
  800eb7:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800eba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ebe:	7e 06                	jle    800ec6 <vprintfmt+0x187>
  800ec0:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800ec4:	75 0d                	jne    800ed3 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ec6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800ec9:	89 c7                	mov    %eax,%edi
  800ecb:	03 45 e0             	add    -0x20(%ebp),%eax
  800ece:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800ed1:	eb 53                	jmp    800f26 <vprintfmt+0x1e7>
  800ed3:	83 ec 08             	sub    $0x8,%esp
  800ed6:	ff 75 d8             	pushl  -0x28(%ebp)
  800ed9:	50                   	push   %eax
  800eda:	e8 61 05 00 00       	call   801440 <strnlen>
  800edf:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800ee2:	29 c1                	sub    %eax,%ecx
  800ee4:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800ee7:	83 c4 10             	add    $0x10,%esp
  800eea:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800eec:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800ef0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800ef3:	eb 0f                	jmp    800f04 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800ef5:	83 ec 08             	sub    $0x8,%esp
  800ef8:	53                   	push   %ebx
  800ef9:	ff 75 e0             	pushl  -0x20(%ebp)
  800efc:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800efe:	83 ef 01             	sub    $0x1,%edi
  800f01:	83 c4 10             	add    $0x10,%esp
  800f04:	85 ff                	test   %edi,%edi
  800f06:	7f ed                	jg     800ef5 <vprintfmt+0x1b6>
  800f08:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800f0b:	85 c9                	test   %ecx,%ecx
  800f0d:	b8 00 00 00 00       	mov    $0x0,%eax
  800f12:	0f 49 c1             	cmovns %ecx,%eax
  800f15:	29 c1                	sub    %eax,%ecx
  800f17:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800f1a:	eb aa                	jmp    800ec6 <vprintfmt+0x187>
					putch(ch, putdat);
  800f1c:	83 ec 08             	sub    $0x8,%esp
  800f1f:	53                   	push   %ebx
  800f20:	52                   	push   %edx
  800f21:	ff d6                	call   *%esi
  800f23:	83 c4 10             	add    $0x10,%esp
  800f26:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800f29:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f2b:	83 c7 01             	add    $0x1,%edi
  800f2e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800f32:	0f be d0             	movsbl %al,%edx
  800f35:	85 d2                	test   %edx,%edx
  800f37:	74 4b                	je     800f84 <vprintfmt+0x245>
  800f39:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800f3d:	78 06                	js     800f45 <vprintfmt+0x206>
  800f3f:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800f43:	78 1e                	js     800f63 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800f45:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800f49:	74 d1                	je     800f1c <vprintfmt+0x1dd>
  800f4b:	0f be c0             	movsbl %al,%eax
  800f4e:	83 e8 20             	sub    $0x20,%eax
  800f51:	83 f8 5e             	cmp    $0x5e,%eax
  800f54:	76 c6                	jbe    800f1c <vprintfmt+0x1dd>
					putch('?', putdat);
  800f56:	83 ec 08             	sub    $0x8,%esp
  800f59:	53                   	push   %ebx
  800f5a:	6a 3f                	push   $0x3f
  800f5c:	ff d6                	call   *%esi
  800f5e:	83 c4 10             	add    $0x10,%esp
  800f61:	eb c3                	jmp    800f26 <vprintfmt+0x1e7>
  800f63:	89 cf                	mov    %ecx,%edi
  800f65:	eb 0e                	jmp    800f75 <vprintfmt+0x236>
				putch(' ', putdat);
  800f67:	83 ec 08             	sub    $0x8,%esp
  800f6a:	53                   	push   %ebx
  800f6b:	6a 20                	push   $0x20
  800f6d:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800f6f:	83 ef 01             	sub    $0x1,%edi
  800f72:	83 c4 10             	add    $0x10,%esp
  800f75:	85 ff                	test   %edi,%edi
  800f77:	7f ee                	jg     800f67 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800f79:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800f7c:	89 45 14             	mov    %eax,0x14(%ebp)
  800f7f:	e9 01 02 00 00       	jmp    801185 <vprintfmt+0x446>
  800f84:	89 cf                	mov    %ecx,%edi
  800f86:	eb ed                	jmp    800f75 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800f88:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800f8b:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800f92:	e9 eb fd ff ff       	jmp    800d82 <vprintfmt+0x43>
	if (lflag >= 2)
  800f97:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800f9b:	7f 21                	jg     800fbe <vprintfmt+0x27f>
	else if (lflag)
  800f9d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800fa1:	74 68                	je     80100b <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800fa3:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa6:	8b 00                	mov    (%eax),%eax
  800fa8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800fab:	89 c1                	mov    %eax,%ecx
  800fad:	c1 f9 1f             	sar    $0x1f,%ecx
  800fb0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800fb3:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb6:	8d 40 04             	lea    0x4(%eax),%eax
  800fb9:	89 45 14             	mov    %eax,0x14(%ebp)
  800fbc:	eb 17                	jmp    800fd5 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800fbe:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc1:	8b 50 04             	mov    0x4(%eax),%edx
  800fc4:	8b 00                	mov    (%eax),%eax
  800fc6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800fc9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800fcc:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcf:	8d 40 08             	lea    0x8(%eax),%eax
  800fd2:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800fd5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800fd8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800fdb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800fde:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800fe1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800fe5:	78 3f                	js     801026 <vprintfmt+0x2e7>
			base = 10;
  800fe7:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800fec:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800ff0:	0f 84 71 01 00 00    	je     801167 <vprintfmt+0x428>
				putch('+', putdat);
  800ff6:	83 ec 08             	sub    $0x8,%esp
  800ff9:	53                   	push   %ebx
  800ffa:	6a 2b                	push   $0x2b
  800ffc:	ff d6                	call   *%esi
  800ffe:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801001:	b8 0a 00 00 00       	mov    $0xa,%eax
  801006:	e9 5c 01 00 00       	jmp    801167 <vprintfmt+0x428>
		return va_arg(*ap, int);
  80100b:	8b 45 14             	mov    0x14(%ebp),%eax
  80100e:	8b 00                	mov    (%eax),%eax
  801010:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801013:	89 c1                	mov    %eax,%ecx
  801015:	c1 f9 1f             	sar    $0x1f,%ecx
  801018:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80101b:	8b 45 14             	mov    0x14(%ebp),%eax
  80101e:	8d 40 04             	lea    0x4(%eax),%eax
  801021:	89 45 14             	mov    %eax,0x14(%ebp)
  801024:	eb af                	jmp    800fd5 <vprintfmt+0x296>
				putch('-', putdat);
  801026:	83 ec 08             	sub    $0x8,%esp
  801029:	53                   	push   %ebx
  80102a:	6a 2d                	push   $0x2d
  80102c:	ff d6                	call   *%esi
				num = -(long long) num;
  80102e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801031:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801034:	f7 d8                	neg    %eax
  801036:	83 d2 00             	adc    $0x0,%edx
  801039:	f7 da                	neg    %edx
  80103b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80103e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801041:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801044:	b8 0a 00 00 00       	mov    $0xa,%eax
  801049:	e9 19 01 00 00       	jmp    801167 <vprintfmt+0x428>
	if (lflag >= 2)
  80104e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  801052:	7f 29                	jg     80107d <vprintfmt+0x33e>
	else if (lflag)
  801054:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  801058:	74 44                	je     80109e <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80105a:	8b 45 14             	mov    0x14(%ebp),%eax
  80105d:	8b 00                	mov    (%eax),%eax
  80105f:	ba 00 00 00 00       	mov    $0x0,%edx
  801064:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801067:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80106a:	8b 45 14             	mov    0x14(%ebp),%eax
  80106d:	8d 40 04             	lea    0x4(%eax),%eax
  801070:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801073:	b8 0a 00 00 00       	mov    $0xa,%eax
  801078:	e9 ea 00 00 00       	jmp    801167 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80107d:	8b 45 14             	mov    0x14(%ebp),%eax
  801080:	8b 50 04             	mov    0x4(%eax),%edx
  801083:	8b 00                	mov    (%eax),%eax
  801085:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801088:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80108b:	8b 45 14             	mov    0x14(%ebp),%eax
  80108e:	8d 40 08             	lea    0x8(%eax),%eax
  801091:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801094:	b8 0a 00 00 00       	mov    $0xa,%eax
  801099:	e9 c9 00 00 00       	jmp    801167 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80109e:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a1:	8b 00                	mov    (%eax),%eax
  8010a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8010a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8010ab:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8010ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b1:	8d 40 04             	lea    0x4(%eax),%eax
  8010b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8010b7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010bc:	e9 a6 00 00 00       	jmp    801167 <vprintfmt+0x428>
			putch('0', putdat);
  8010c1:	83 ec 08             	sub    $0x8,%esp
  8010c4:	53                   	push   %ebx
  8010c5:	6a 30                	push   $0x30
  8010c7:	ff d6                	call   *%esi
	if (lflag >= 2)
  8010c9:	83 c4 10             	add    $0x10,%esp
  8010cc:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8010d0:	7f 26                	jg     8010f8 <vprintfmt+0x3b9>
	else if (lflag)
  8010d2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8010d6:	74 3e                	je     801116 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8010d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010db:	8b 00                	mov    (%eax),%eax
  8010dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8010e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8010e5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8010e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010eb:	8d 40 04             	lea    0x4(%eax),%eax
  8010ee:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8010f1:	b8 08 00 00 00       	mov    $0x8,%eax
  8010f6:	eb 6f                	jmp    801167 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8010f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010fb:	8b 50 04             	mov    0x4(%eax),%edx
  8010fe:	8b 00                	mov    (%eax),%eax
  801100:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801103:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801106:	8b 45 14             	mov    0x14(%ebp),%eax
  801109:	8d 40 08             	lea    0x8(%eax),%eax
  80110c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80110f:	b8 08 00 00 00       	mov    $0x8,%eax
  801114:	eb 51                	jmp    801167 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  801116:	8b 45 14             	mov    0x14(%ebp),%eax
  801119:	8b 00                	mov    (%eax),%eax
  80111b:	ba 00 00 00 00       	mov    $0x0,%edx
  801120:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801123:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801126:	8b 45 14             	mov    0x14(%ebp),%eax
  801129:	8d 40 04             	lea    0x4(%eax),%eax
  80112c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80112f:	b8 08 00 00 00       	mov    $0x8,%eax
  801134:	eb 31                	jmp    801167 <vprintfmt+0x428>
			putch('0', putdat);
  801136:	83 ec 08             	sub    $0x8,%esp
  801139:	53                   	push   %ebx
  80113a:	6a 30                	push   $0x30
  80113c:	ff d6                	call   *%esi
			putch('x', putdat);
  80113e:	83 c4 08             	add    $0x8,%esp
  801141:	53                   	push   %ebx
  801142:	6a 78                	push   $0x78
  801144:	ff d6                	call   *%esi
			num = (unsigned long long)
  801146:	8b 45 14             	mov    0x14(%ebp),%eax
  801149:	8b 00                	mov    (%eax),%eax
  80114b:	ba 00 00 00 00       	mov    $0x0,%edx
  801150:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801153:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  801156:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801159:	8b 45 14             	mov    0x14(%ebp),%eax
  80115c:	8d 40 04             	lea    0x4(%eax),%eax
  80115f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801162:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801167:	83 ec 0c             	sub    $0xc,%esp
  80116a:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80116e:	52                   	push   %edx
  80116f:	ff 75 e0             	pushl  -0x20(%ebp)
  801172:	50                   	push   %eax
  801173:	ff 75 dc             	pushl  -0x24(%ebp)
  801176:	ff 75 d8             	pushl  -0x28(%ebp)
  801179:	89 da                	mov    %ebx,%edx
  80117b:	89 f0                	mov    %esi,%eax
  80117d:	e8 a4 fa ff ff       	call   800c26 <printnum>
			break;
  801182:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801185:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801188:	83 c7 01             	add    $0x1,%edi
  80118b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80118f:	83 f8 25             	cmp    $0x25,%eax
  801192:	0f 84 be fb ff ff    	je     800d56 <vprintfmt+0x17>
			if (ch == '\0')
  801198:	85 c0                	test   %eax,%eax
  80119a:	0f 84 28 01 00 00    	je     8012c8 <vprintfmt+0x589>
			putch(ch, putdat);
  8011a0:	83 ec 08             	sub    $0x8,%esp
  8011a3:	53                   	push   %ebx
  8011a4:	50                   	push   %eax
  8011a5:	ff d6                	call   *%esi
  8011a7:	83 c4 10             	add    $0x10,%esp
  8011aa:	eb dc                	jmp    801188 <vprintfmt+0x449>
	if (lflag >= 2)
  8011ac:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8011b0:	7f 26                	jg     8011d8 <vprintfmt+0x499>
	else if (lflag)
  8011b2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8011b6:	74 41                	je     8011f9 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8011b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011bb:	8b 00                	mov    (%eax),%eax
  8011bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8011c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8011c5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8011c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011cb:	8d 40 04             	lea    0x4(%eax),%eax
  8011ce:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8011d1:	b8 10 00 00 00       	mov    $0x10,%eax
  8011d6:	eb 8f                	jmp    801167 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8011d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011db:	8b 50 04             	mov    0x4(%eax),%edx
  8011de:	8b 00                	mov    (%eax),%eax
  8011e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8011e3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8011e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e9:	8d 40 08             	lea    0x8(%eax),%eax
  8011ec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8011ef:	b8 10 00 00 00       	mov    $0x10,%eax
  8011f4:	e9 6e ff ff ff       	jmp    801167 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8011f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8011fc:	8b 00                	mov    (%eax),%eax
  8011fe:	ba 00 00 00 00       	mov    $0x0,%edx
  801203:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801206:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801209:	8b 45 14             	mov    0x14(%ebp),%eax
  80120c:	8d 40 04             	lea    0x4(%eax),%eax
  80120f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801212:	b8 10 00 00 00       	mov    $0x10,%eax
  801217:	e9 4b ff ff ff       	jmp    801167 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80121c:	8b 45 14             	mov    0x14(%ebp),%eax
  80121f:	83 c0 04             	add    $0x4,%eax
  801222:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801225:	8b 45 14             	mov    0x14(%ebp),%eax
  801228:	8b 00                	mov    (%eax),%eax
  80122a:	85 c0                	test   %eax,%eax
  80122c:	74 14                	je     801242 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80122e:	8b 13                	mov    (%ebx),%edx
  801230:	83 fa 7f             	cmp    $0x7f,%edx
  801233:	7f 37                	jg     80126c <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  801235:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  801237:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80123a:	89 45 14             	mov    %eax,0x14(%ebp)
  80123d:	e9 43 ff ff ff       	jmp    801185 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  801242:	b8 0a 00 00 00       	mov    $0xa,%eax
  801247:	bf 01 41 80 00       	mov    $0x804101,%edi
							putch(ch, putdat);
  80124c:	83 ec 08             	sub    $0x8,%esp
  80124f:	53                   	push   %ebx
  801250:	50                   	push   %eax
  801251:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  801253:	83 c7 01             	add    $0x1,%edi
  801256:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80125a:	83 c4 10             	add    $0x10,%esp
  80125d:	85 c0                	test   %eax,%eax
  80125f:	75 eb                	jne    80124c <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  801261:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801264:	89 45 14             	mov    %eax,0x14(%ebp)
  801267:	e9 19 ff ff ff       	jmp    801185 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80126c:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80126e:	b8 0a 00 00 00       	mov    $0xa,%eax
  801273:	bf 39 41 80 00       	mov    $0x804139,%edi
							putch(ch, putdat);
  801278:	83 ec 08             	sub    $0x8,%esp
  80127b:	53                   	push   %ebx
  80127c:	50                   	push   %eax
  80127d:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80127f:	83 c7 01             	add    $0x1,%edi
  801282:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  801286:	83 c4 10             	add    $0x10,%esp
  801289:	85 c0                	test   %eax,%eax
  80128b:	75 eb                	jne    801278 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80128d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801290:	89 45 14             	mov    %eax,0x14(%ebp)
  801293:	e9 ed fe ff ff       	jmp    801185 <vprintfmt+0x446>
			putch(ch, putdat);
  801298:	83 ec 08             	sub    $0x8,%esp
  80129b:	53                   	push   %ebx
  80129c:	6a 25                	push   $0x25
  80129e:	ff d6                	call   *%esi
			break;
  8012a0:	83 c4 10             	add    $0x10,%esp
  8012a3:	e9 dd fe ff ff       	jmp    801185 <vprintfmt+0x446>
			putch('%', putdat);
  8012a8:	83 ec 08             	sub    $0x8,%esp
  8012ab:	53                   	push   %ebx
  8012ac:	6a 25                	push   $0x25
  8012ae:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8012b0:	83 c4 10             	add    $0x10,%esp
  8012b3:	89 f8                	mov    %edi,%eax
  8012b5:	eb 03                	jmp    8012ba <vprintfmt+0x57b>
  8012b7:	83 e8 01             	sub    $0x1,%eax
  8012ba:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8012be:	75 f7                	jne    8012b7 <vprintfmt+0x578>
  8012c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8012c3:	e9 bd fe ff ff       	jmp    801185 <vprintfmt+0x446>
}
  8012c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012cb:	5b                   	pop    %ebx
  8012cc:	5e                   	pop    %esi
  8012cd:	5f                   	pop    %edi
  8012ce:	5d                   	pop    %ebp
  8012cf:	c3                   	ret    

008012d0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8012d0:	55                   	push   %ebp
  8012d1:	89 e5                	mov    %esp,%ebp
  8012d3:	83 ec 18             	sub    $0x18,%esp
  8012d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d9:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8012dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8012df:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8012e3:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8012e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8012ed:	85 c0                	test   %eax,%eax
  8012ef:	74 26                	je     801317 <vsnprintf+0x47>
  8012f1:	85 d2                	test   %edx,%edx
  8012f3:	7e 22                	jle    801317 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8012f5:	ff 75 14             	pushl  0x14(%ebp)
  8012f8:	ff 75 10             	pushl  0x10(%ebp)
  8012fb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8012fe:	50                   	push   %eax
  8012ff:	68 05 0d 80 00       	push   $0x800d05
  801304:	e8 36 fa ff ff       	call   800d3f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801309:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80130c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80130f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801312:	83 c4 10             	add    $0x10,%esp
}
  801315:	c9                   	leave  
  801316:	c3                   	ret    
		return -E_INVAL;
  801317:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80131c:	eb f7                	jmp    801315 <vsnprintf+0x45>

0080131e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80131e:	55                   	push   %ebp
  80131f:	89 e5                	mov    %esp,%ebp
  801321:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801324:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801327:	50                   	push   %eax
  801328:	ff 75 10             	pushl  0x10(%ebp)
  80132b:	ff 75 0c             	pushl  0xc(%ebp)
  80132e:	ff 75 08             	pushl  0x8(%ebp)
  801331:	e8 9a ff ff ff       	call   8012d0 <vsnprintf>
	va_end(ap);

	return rc;
}
  801336:	c9                   	leave  
  801337:	c3                   	ret    

00801338 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  801338:	55                   	push   %ebp
  801339:	89 e5                	mov    %esp,%ebp
  80133b:	57                   	push   %edi
  80133c:	56                   	push   %esi
  80133d:	53                   	push   %ebx
  80133e:	83 ec 0c             	sub    $0xc,%esp
  801341:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  801344:	85 c0                	test   %eax,%eax
  801346:	74 13                	je     80135b <readline+0x23>
		fprintf(1, "%s", prompt);
  801348:	83 ec 04             	sub    $0x4,%esp
  80134b:	50                   	push   %eax
  80134c:	68 81 3e 80 00       	push   $0x803e81
  801351:	6a 01                	push   $0x1
  801353:	e8 3d 17 00 00       	call   802a95 <fprintf>
  801358:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
  80135b:	83 ec 0c             	sub    $0xc,%esp
  80135e:	6a 00                	push   $0x0
  801360:	e8 2a f6 ff ff       	call   80098f <iscons>
  801365:	89 c7                	mov    %eax,%edi
  801367:	83 c4 10             	add    $0x10,%esp
	i = 0;
  80136a:	be 00 00 00 00       	mov    $0x0,%esi
  80136f:	eb 57                	jmp    8013c8 <readline+0x90>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  801371:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
  801376:	83 fb f8             	cmp    $0xfffffff8,%ebx
  801379:	75 08                	jne    801383 <readline+0x4b>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
  80137b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80137e:	5b                   	pop    %ebx
  80137f:	5e                   	pop    %esi
  801380:	5f                   	pop    %edi
  801381:	5d                   	pop    %ebp
  801382:	c3                   	ret    
				cprintf("read error: %e\n", c);
  801383:	83 ec 08             	sub    $0x8,%esp
  801386:	53                   	push   %ebx
  801387:	68 48 43 80 00       	push   $0x804348
  80138c:	e8 81 f8 ff ff       	call   800c12 <cprintf>
  801391:	83 c4 10             	add    $0x10,%esp
			return NULL;
  801394:	b8 00 00 00 00       	mov    $0x0,%eax
  801399:	eb e0                	jmp    80137b <readline+0x43>
			if (echoing)
  80139b:	85 ff                	test   %edi,%edi
  80139d:	75 05                	jne    8013a4 <readline+0x6c>
			i--;
  80139f:	83 ee 01             	sub    $0x1,%esi
  8013a2:	eb 24                	jmp    8013c8 <readline+0x90>
				cputchar('\b');
  8013a4:	83 ec 0c             	sub    $0xc,%esp
  8013a7:	6a 08                	push   $0x8
  8013a9:	e8 9c f5 ff ff       	call   80094a <cputchar>
  8013ae:	83 c4 10             	add    $0x10,%esp
  8013b1:	eb ec                	jmp    80139f <readline+0x67>
				cputchar(c);
  8013b3:	83 ec 0c             	sub    $0xc,%esp
  8013b6:	53                   	push   %ebx
  8013b7:	e8 8e f5 ff ff       	call   80094a <cputchar>
  8013bc:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8013bf:	88 9e 20 60 80 00    	mov    %bl,0x806020(%esi)
  8013c5:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
  8013c8:	e8 99 f5 ff ff       	call   800966 <getchar>
  8013cd:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  8013cf:	85 c0                	test   %eax,%eax
  8013d1:	78 9e                	js     801371 <readline+0x39>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  8013d3:	83 f8 08             	cmp    $0x8,%eax
  8013d6:	0f 94 c2             	sete   %dl
  8013d9:	83 f8 7f             	cmp    $0x7f,%eax
  8013dc:	0f 94 c0             	sete   %al
  8013df:	08 c2                	or     %al,%dl
  8013e1:	74 04                	je     8013e7 <readline+0xaf>
  8013e3:	85 f6                	test   %esi,%esi
  8013e5:	7f b4                	jg     80139b <readline+0x63>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8013e7:	83 fb 1f             	cmp    $0x1f,%ebx
  8013ea:	7e 0e                	jle    8013fa <readline+0xc2>
  8013ec:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  8013f2:	7f 06                	jg     8013fa <readline+0xc2>
			if (echoing)
  8013f4:	85 ff                	test   %edi,%edi
  8013f6:	74 c7                	je     8013bf <readline+0x87>
  8013f8:	eb b9                	jmp    8013b3 <readline+0x7b>
		} else if (c == '\n' || c == '\r') {
  8013fa:	83 fb 0a             	cmp    $0xa,%ebx
  8013fd:	74 05                	je     801404 <readline+0xcc>
  8013ff:	83 fb 0d             	cmp    $0xd,%ebx
  801402:	75 c4                	jne    8013c8 <readline+0x90>
			if (echoing)
  801404:	85 ff                	test   %edi,%edi
  801406:	75 11                	jne    801419 <readline+0xe1>
			buf[i] = 0;
  801408:	c6 86 20 60 80 00 00 	movb   $0x0,0x806020(%esi)
			return buf;
  80140f:	b8 20 60 80 00       	mov    $0x806020,%eax
  801414:	e9 62 ff ff ff       	jmp    80137b <readline+0x43>
				cputchar('\n');
  801419:	83 ec 0c             	sub    $0xc,%esp
  80141c:	6a 0a                	push   $0xa
  80141e:	e8 27 f5 ff ff       	call   80094a <cputchar>
  801423:	83 c4 10             	add    $0x10,%esp
  801426:	eb e0                	jmp    801408 <readline+0xd0>

00801428 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801428:	55                   	push   %ebp
  801429:	89 e5                	mov    %esp,%ebp
  80142b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80142e:	b8 00 00 00 00       	mov    $0x0,%eax
  801433:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801437:	74 05                	je     80143e <strlen+0x16>
		n++;
  801439:	83 c0 01             	add    $0x1,%eax
  80143c:	eb f5                	jmp    801433 <strlen+0xb>
	return n;
}
  80143e:	5d                   	pop    %ebp
  80143f:	c3                   	ret    

00801440 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
  801443:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801446:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801449:	ba 00 00 00 00       	mov    $0x0,%edx
  80144e:	39 c2                	cmp    %eax,%edx
  801450:	74 0d                	je     80145f <strnlen+0x1f>
  801452:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  801456:	74 05                	je     80145d <strnlen+0x1d>
		n++;
  801458:	83 c2 01             	add    $0x1,%edx
  80145b:	eb f1                	jmp    80144e <strnlen+0xe>
  80145d:	89 d0                	mov    %edx,%eax
	return n;
}
  80145f:	5d                   	pop    %ebp
  801460:	c3                   	ret    

00801461 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801461:	55                   	push   %ebp
  801462:	89 e5                	mov    %esp,%ebp
  801464:	53                   	push   %ebx
  801465:	8b 45 08             	mov    0x8(%ebp),%eax
  801468:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80146b:	ba 00 00 00 00       	mov    $0x0,%edx
  801470:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  801474:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  801477:	83 c2 01             	add    $0x1,%edx
  80147a:	84 c9                	test   %cl,%cl
  80147c:	75 f2                	jne    801470 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80147e:	5b                   	pop    %ebx
  80147f:	5d                   	pop    %ebp
  801480:	c3                   	ret    

00801481 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801481:	55                   	push   %ebp
  801482:	89 e5                	mov    %esp,%ebp
  801484:	53                   	push   %ebx
  801485:	83 ec 10             	sub    $0x10,%esp
  801488:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80148b:	53                   	push   %ebx
  80148c:	e8 97 ff ff ff       	call   801428 <strlen>
  801491:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801494:	ff 75 0c             	pushl  0xc(%ebp)
  801497:	01 d8                	add    %ebx,%eax
  801499:	50                   	push   %eax
  80149a:	e8 c2 ff ff ff       	call   801461 <strcpy>
	return dst;
}
  80149f:	89 d8                	mov    %ebx,%eax
  8014a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014a4:	c9                   	leave  
  8014a5:	c3                   	ret    

008014a6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8014a6:	55                   	push   %ebp
  8014a7:	89 e5                	mov    %esp,%ebp
  8014a9:	56                   	push   %esi
  8014aa:	53                   	push   %ebx
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014b1:	89 c6                	mov    %eax,%esi
  8014b3:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014b6:	89 c2                	mov    %eax,%edx
  8014b8:	39 f2                	cmp    %esi,%edx
  8014ba:	74 11                	je     8014cd <strncpy+0x27>
		*dst++ = *src;
  8014bc:	83 c2 01             	add    $0x1,%edx
  8014bf:	0f b6 19             	movzbl (%ecx),%ebx
  8014c2:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8014c5:	80 fb 01             	cmp    $0x1,%bl
  8014c8:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8014cb:	eb eb                	jmp    8014b8 <strncpy+0x12>
	}
	return ret;
}
  8014cd:	5b                   	pop    %ebx
  8014ce:	5e                   	pop    %esi
  8014cf:	5d                   	pop    %ebp
  8014d0:	c3                   	ret    

008014d1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
  8014d4:	56                   	push   %esi
  8014d5:	53                   	push   %ebx
  8014d6:	8b 75 08             	mov    0x8(%ebp),%esi
  8014d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014dc:	8b 55 10             	mov    0x10(%ebp),%edx
  8014df:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8014e1:	85 d2                	test   %edx,%edx
  8014e3:	74 21                	je     801506 <strlcpy+0x35>
  8014e5:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8014e9:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8014eb:	39 c2                	cmp    %eax,%edx
  8014ed:	74 14                	je     801503 <strlcpy+0x32>
  8014ef:	0f b6 19             	movzbl (%ecx),%ebx
  8014f2:	84 db                	test   %bl,%bl
  8014f4:	74 0b                	je     801501 <strlcpy+0x30>
			*dst++ = *src++;
  8014f6:	83 c1 01             	add    $0x1,%ecx
  8014f9:	83 c2 01             	add    $0x1,%edx
  8014fc:	88 5a ff             	mov    %bl,-0x1(%edx)
  8014ff:	eb ea                	jmp    8014eb <strlcpy+0x1a>
  801501:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801503:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801506:	29 f0                	sub    %esi,%eax
}
  801508:	5b                   	pop    %ebx
  801509:	5e                   	pop    %esi
  80150a:	5d                   	pop    %ebp
  80150b:	c3                   	ret    

0080150c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80150c:	55                   	push   %ebp
  80150d:	89 e5                	mov    %esp,%ebp
  80150f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801512:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801515:	0f b6 01             	movzbl (%ecx),%eax
  801518:	84 c0                	test   %al,%al
  80151a:	74 0c                	je     801528 <strcmp+0x1c>
  80151c:	3a 02                	cmp    (%edx),%al
  80151e:	75 08                	jne    801528 <strcmp+0x1c>
		p++, q++;
  801520:	83 c1 01             	add    $0x1,%ecx
  801523:	83 c2 01             	add    $0x1,%edx
  801526:	eb ed                	jmp    801515 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801528:	0f b6 c0             	movzbl %al,%eax
  80152b:	0f b6 12             	movzbl (%edx),%edx
  80152e:	29 d0                	sub    %edx,%eax
}
  801530:	5d                   	pop    %ebp
  801531:	c3                   	ret    

00801532 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
  801535:	53                   	push   %ebx
  801536:	8b 45 08             	mov    0x8(%ebp),%eax
  801539:	8b 55 0c             	mov    0xc(%ebp),%edx
  80153c:	89 c3                	mov    %eax,%ebx
  80153e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801541:	eb 06                	jmp    801549 <strncmp+0x17>
		n--, p++, q++;
  801543:	83 c0 01             	add    $0x1,%eax
  801546:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801549:	39 d8                	cmp    %ebx,%eax
  80154b:	74 16                	je     801563 <strncmp+0x31>
  80154d:	0f b6 08             	movzbl (%eax),%ecx
  801550:	84 c9                	test   %cl,%cl
  801552:	74 04                	je     801558 <strncmp+0x26>
  801554:	3a 0a                	cmp    (%edx),%cl
  801556:	74 eb                	je     801543 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801558:	0f b6 00             	movzbl (%eax),%eax
  80155b:	0f b6 12             	movzbl (%edx),%edx
  80155e:	29 d0                	sub    %edx,%eax
}
  801560:	5b                   	pop    %ebx
  801561:	5d                   	pop    %ebp
  801562:	c3                   	ret    
		return 0;
  801563:	b8 00 00 00 00       	mov    $0x0,%eax
  801568:	eb f6                	jmp    801560 <strncmp+0x2e>

0080156a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	8b 45 08             	mov    0x8(%ebp),%eax
  801570:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801574:	0f b6 10             	movzbl (%eax),%edx
  801577:	84 d2                	test   %dl,%dl
  801579:	74 09                	je     801584 <strchr+0x1a>
		if (*s == c)
  80157b:	38 ca                	cmp    %cl,%dl
  80157d:	74 0a                	je     801589 <strchr+0x1f>
	for (; *s; s++)
  80157f:	83 c0 01             	add    $0x1,%eax
  801582:	eb f0                	jmp    801574 <strchr+0xa>
			return (char *) s;
	return 0;
  801584:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801589:	5d                   	pop    %ebp
  80158a:	c3                   	ret    

0080158b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
  80158e:	8b 45 08             	mov    0x8(%ebp),%eax
  801591:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801595:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801598:	38 ca                	cmp    %cl,%dl
  80159a:	74 09                	je     8015a5 <strfind+0x1a>
  80159c:	84 d2                	test   %dl,%dl
  80159e:	74 05                	je     8015a5 <strfind+0x1a>
	for (; *s; s++)
  8015a0:	83 c0 01             	add    $0x1,%eax
  8015a3:	eb f0                	jmp    801595 <strfind+0xa>
			break;
	return (char *) s;
}
  8015a5:	5d                   	pop    %ebp
  8015a6:	c3                   	ret    

008015a7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8015a7:	55                   	push   %ebp
  8015a8:	89 e5                	mov    %esp,%ebp
  8015aa:	57                   	push   %edi
  8015ab:	56                   	push   %esi
  8015ac:	53                   	push   %ebx
  8015ad:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015b0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8015b3:	85 c9                	test   %ecx,%ecx
  8015b5:	74 31                	je     8015e8 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8015b7:	89 f8                	mov    %edi,%eax
  8015b9:	09 c8                	or     %ecx,%eax
  8015bb:	a8 03                	test   $0x3,%al
  8015bd:	75 23                	jne    8015e2 <memset+0x3b>
		c &= 0xFF;
  8015bf:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8015c3:	89 d3                	mov    %edx,%ebx
  8015c5:	c1 e3 08             	shl    $0x8,%ebx
  8015c8:	89 d0                	mov    %edx,%eax
  8015ca:	c1 e0 18             	shl    $0x18,%eax
  8015cd:	89 d6                	mov    %edx,%esi
  8015cf:	c1 e6 10             	shl    $0x10,%esi
  8015d2:	09 f0                	or     %esi,%eax
  8015d4:	09 c2                	or     %eax,%edx
  8015d6:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8015d8:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8015db:	89 d0                	mov    %edx,%eax
  8015dd:	fc                   	cld    
  8015de:	f3 ab                	rep stos %eax,%es:(%edi)
  8015e0:	eb 06                	jmp    8015e8 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8015e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e5:	fc                   	cld    
  8015e6:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8015e8:	89 f8                	mov    %edi,%eax
  8015ea:	5b                   	pop    %ebx
  8015eb:	5e                   	pop    %esi
  8015ec:	5f                   	pop    %edi
  8015ed:	5d                   	pop    %ebp
  8015ee:	c3                   	ret    

008015ef <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
  8015f2:	57                   	push   %edi
  8015f3:	56                   	push   %esi
  8015f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8015fd:	39 c6                	cmp    %eax,%esi
  8015ff:	73 32                	jae    801633 <memmove+0x44>
  801601:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801604:	39 c2                	cmp    %eax,%edx
  801606:	76 2b                	jbe    801633 <memmove+0x44>
		s += n;
		d += n;
  801608:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80160b:	89 fe                	mov    %edi,%esi
  80160d:	09 ce                	or     %ecx,%esi
  80160f:	09 d6                	or     %edx,%esi
  801611:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801617:	75 0e                	jne    801627 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801619:	83 ef 04             	sub    $0x4,%edi
  80161c:	8d 72 fc             	lea    -0x4(%edx),%esi
  80161f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801622:	fd                   	std    
  801623:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801625:	eb 09                	jmp    801630 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801627:	83 ef 01             	sub    $0x1,%edi
  80162a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80162d:	fd                   	std    
  80162e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801630:	fc                   	cld    
  801631:	eb 1a                	jmp    80164d <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801633:	89 c2                	mov    %eax,%edx
  801635:	09 ca                	or     %ecx,%edx
  801637:	09 f2                	or     %esi,%edx
  801639:	f6 c2 03             	test   $0x3,%dl
  80163c:	75 0a                	jne    801648 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80163e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801641:	89 c7                	mov    %eax,%edi
  801643:	fc                   	cld    
  801644:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801646:	eb 05                	jmp    80164d <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  801648:	89 c7                	mov    %eax,%edi
  80164a:	fc                   	cld    
  80164b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80164d:	5e                   	pop    %esi
  80164e:	5f                   	pop    %edi
  80164f:	5d                   	pop    %ebp
  801650:	c3                   	ret    

00801651 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801651:	55                   	push   %ebp
  801652:	89 e5                	mov    %esp,%ebp
  801654:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801657:	ff 75 10             	pushl  0x10(%ebp)
  80165a:	ff 75 0c             	pushl  0xc(%ebp)
  80165d:	ff 75 08             	pushl  0x8(%ebp)
  801660:	e8 8a ff ff ff       	call   8015ef <memmove>
}
  801665:	c9                   	leave  
  801666:	c3                   	ret    

00801667 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
  80166a:	56                   	push   %esi
  80166b:	53                   	push   %ebx
  80166c:	8b 45 08             	mov    0x8(%ebp),%eax
  80166f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801672:	89 c6                	mov    %eax,%esi
  801674:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801677:	39 f0                	cmp    %esi,%eax
  801679:	74 1c                	je     801697 <memcmp+0x30>
		if (*s1 != *s2)
  80167b:	0f b6 08             	movzbl (%eax),%ecx
  80167e:	0f b6 1a             	movzbl (%edx),%ebx
  801681:	38 d9                	cmp    %bl,%cl
  801683:	75 08                	jne    80168d <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801685:	83 c0 01             	add    $0x1,%eax
  801688:	83 c2 01             	add    $0x1,%edx
  80168b:	eb ea                	jmp    801677 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  80168d:	0f b6 c1             	movzbl %cl,%eax
  801690:	0f b6 db             	movzbl %bl,%ebx
  801693:	29 d8                	sub    %ebx,%eax
  801695:	eb 05                	jmp    80169c <memcmp+0x35>
	}

	return 0;
  801697:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80169c:	5b                   	pop    %ebx
  80169d:	5e                   	pop    %esi
  80169e:	5d                   	pop    %ebp
  80169f:	c3                   	ret    

008016a0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
  8016a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8016a9:	89 c2                	mov    %eax,%edx
  8016ab:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8016ae:	39 d0                	cmp    %edx,%eax
  8016b0:	73 09                	jae    8016bb <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016b2:	38 08                	cmp    %cl,(%eax)
  8016b4:	74 05                	je     8016bb <memfind+0x1b>
	for (; s < ends; s++)
  8016b6:	83 c0 01             	add    $0x1,%eax
  8016b9:	eb f3                	jmp    8016ae <memfind+0xe>
			break;
	return (void *) s;
}
  8016bb:	5d                   	pop    %ebp
  8016bc:	c3                   	ret    

008016bd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
  8016c0:	57                   	push   %edi
  8016c1:	56                   	push   %esi
  8016c2:	53                   	push   %ebx
  8016c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016c9:	eb 03                	jmp    8016ce <strtol+0x11>
		s++;
  8016cb:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8016ce:	0f b6 01             	movzbl (%ecx),%eax
  8016d1:	3c 20                	cmp    $0x20,%al
  8016d3:	74 f6                	je     8016cb <strtol+0xe>
  8016d5:	3c 09                	cmp    $0x9,%al
  8016d7:	74 f2                	je     8016cb <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8016d9:	3c 2b                	cmp    $0x2b,%al
  8016db:	74 2a                	je     801707 <strtol+0x4a>
	int neg = 0;
  8016dd:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8016e2:	3c 2d                	cmp    $0x2d,%al
  8016e4:	74 2b                	je     801711 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8016e6:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8016ec:	75 0f                	jne    8016fd <strtol+0x40>
  8016ee:	80 39 30             	cmpb   $0x30,(%ecx)
  8016f1:	74 28                	je     80171b <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8016f3:	85 db                	test   %ebx,%ebx
  8016f5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8016fa:	0f 44 d8             	cmove  %eax,%ebx
  8016fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801702:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801705:	eb 50                	jmp    801757 <strtol+0x9a>
		s++;
  801707:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  80170a:	bf 00 00 00 00       	mov    $0x0,%edi
  80170f:	eb d5                	jmp    8016e6 <strtol+0x29>
		s++, neg = 1;
  801711:	83 c1 01             	add    $0x1,%ecx
  801714:	bf 01 00 00 00       	mov    $0x1,%edi
  801719:	eb cb                	jmp    8016e6 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80171b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80171f:	74 0e                	je     80172f <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  801721:	85 db                	test   %ebx,%ebx
  801723:	75 d8                	jne    8016fd <strtol+0x40>
		s++, base = 8;
  801725:	83 c1 01             	add    $0x1,%ecx
  801728:	bb 08 00 00 00       	mov    $0x8,%ebx
  80172d:	eb ce                	jmp    8016fd <strtol+0x40>
		s += 2, base = 16;
  80172f:	83 c1 02             	add    $0x2,%ecx
  801732:	bb 10 00 00 00       	mov    $0x10,%ebx
  801737:	eb c4                	jmp    8016fd <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801739:	8d 72 9f             	lea    -0x61(%edx),%esi
  80173c:	89 f3                	mov    %esi,%ebx
  80173e:	80 fb 19             	cmp    $0x19,%bl
  801741:	77 29                	ja     80176c <strtol+0xaf>
			dig = *s - 'a' + 10;
  801743:	0f be d2             	movsbl %dl,%edx
  801746:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801749:	3b 55 10             	cmp    0x10(%ebp),%edx
  80174c:	7d 30                	jge    80177e <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  80174e:	83 c1 01             	add    $0x1,%ecx
  801751:	0f af 45 10          	imul   0x10(%ebp),%eax
  801755:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801757:	0f b6 11             	movzbl (%ecx),%edx
  80175a:	8d 72 d0             	lea    -0x30(%edx),%esi
  80175d:	89 f3                	mov    %esi,%ebx
  80175f:	80 fb 09             	cmp    $0x9,%bl
  801762:	77 d5                	ja     801739 <strtol+0x7c>
			dig = *s - '0';
  801764:	0f be d2             	movsbl %dl,%edx
  801767:	83 ea 30             	sub    $0x30,%edx
  80176a:	eb dd                	jmp    801749 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  80176c:	8d 72 bf             	lea    -0x41(%edx),%esi
  80176f:	89 f3                	mov    %esi,%ebx
  801771:	80 fb 19             	cmp    $0x19,%bl
  801774:	77 08                	ja     80177e <strtol+0xc1>
			dig = *s - 'A' + 10;
  801776:	0f be d2             	movsbl %dl,%edx
  801779:	83 ea 37             	sub    $0x37,%edx
  80177c:	eb cb                	jmp    801749 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  80177e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801782:	74 05                	je     801789 <strtol+0xcc>
		*endptr = (char *) s;
  801784:	8b 75 0c             	mov    0xc(%ebp),%esi
  801787:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801789:	89 c2                	mov    %eax,%edx
  80178b:	f7 da                	neg    %edx
  80178d:	85 ff                	test   %edi,%edi
  80178f:	0f 45 c2             	cmovne %edx,%eax
}
  801792:	5b                   	pop    %ebx
  801793:	5e                   	pop    %esi
  801794:	5f                   	pop    %edi
  801795:	5d                   	pop    %ebp
  801796:	c3                   	ret    

00801797 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
  80179a:	57                   	push   %edi
  80179b:	56                   	push   %esi
  80179c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80179d:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8017a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017a8:	89 c3                	mov    %eax,%ebx
  8017aa:	89 c7                	mov    %eax,%edi
  8017ac:	89 c6                	mov    %eax,%esi
  8017ae:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8017b0:	5b                   	pop    %ebx
  8017b1:	5e                   	pop    %esi
  8017b2:	5f                   	pop    %edi
  8017b3:	5d                   	pop    %ebp
  8017b4:	c3                   	ret    

008017b5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017b5:	55                   	push   %ebp
  8017b6:	89 e5                	mov    %esp,%ebp
  8017b8:	57                   	push   %edi
  8017b9:	56                   	push   %esi
  8017ba:	53                   	push   %ebx
	asm volatile("int %1\n"
  8017bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c0:	b8 01 00 00 00       	mov    $0x1,%eax
  8017c5:	89 d1                	mov    %edx,%ecx
  8017c7:	89 d3                	mov    %edx,%ebx
  8017c9:	89 d7                	mov    %edx,%edi
  8017cb:	89 d6                	mov    %edx,%esi
  8017cd:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8017cf:	5b                   	pop    %ebx
  8017d0:	5e                   	pop    %esi
  8017d1:	5f                   	pop    %edi
  8017d2:	5d                   	pop    %ebp
  8017d3:	c3                   	ret    

008017d4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	57                   	push   %edi
  8017d8:	56                   	push   %esi
  8017d9:	53                   	push   %ebx
  8017da:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8017dd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8017e5:	b8 03 00 00 00       	mov    $0x3,%eax
  8017ea:	89 cb                	mov    %ecx,%ebx
  8017ec:	89 cf                	mov    %ecx,%edi
  8017ee:	89 ce                	mov    %ecx,%esi
  8017f0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8017f2:	85 c0                	test   %eax,%eax
  8017f4:	7f 08                	jg     8017fe <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8017f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017f9:	5b                   	pop    %ebx
  8017fa:	5e                   	pop    %esi
  8017fb:	5f                   	pop    %edi
  8017fc:	5d                   	pop    %ebp
  8017fd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8017fe:	83 ec 0c             	sub    $0xc,%esp
  801801:	50                   	push   %eax
  801802:	6a 03                	push   $0x3
  801804:	68 58 43 80 00       	push   $0x804358
  801809:	6a 43                	push   $0x43
  80180b:	68 75 43 80 00       	push   $0x804375
  801810:	e8 07 f3 ff ff       	call   800b1c <_panic>

00801815 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
  801818:	57                   	push   %edi
  801819:	56                   	push   %esi
  80181a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80181b:	ba 00 00 00 00       	mov    $0x0,%edx
  801820:	b8 02 00 00 00       	mov    $0x2,%eax
  801825:	89 d1                	mov    %edx,%ecx
  801827:	89 d3                	mov    %edx,%ebx
  801829:	89 d7                	mov    %edx,%edi
  80182b:	89 d6                	mov    %edx,%esi
  80182d:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80182f:	5b                   	pop    %ebx
  801830:	5e                   	pop    %esi
  801831:	5f                   	pop    %edi
  801832:	5d                   	pop    %ebp
  801833:	c3                   	ret    

00801834 <sys_yield>:

void
sys_yield(void)
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
  801837:	57                   	push   %edi
  801838:	56                   	push   %esi
  801839:	53                   	push   %ebx
	asm volatile("int %1\n"
  80183a:	ba 00 00 00 00       	mov    $0x0,%edx
  80183f:	b8 0b 00 00 00       	mov    $0xb,%eax
  801844:	89 d1                	mov    %edx,%ecx
  801846:	89 d3                	mov    %edx,%ebx
  801848:	89 d7                	mov    %edx,%edi
  80184a:	89 d6                	mov    %edx,%esi
  80184c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80184e:	5b                   	pop    %ebx
  80184f:	5e                   	pop    %esi
  801850:	5f                   	pop    %edi
  801851:	5d                   	pop    %ebp
  801852:	c3                   	ret    

00801853 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
  801856:	57                   	push   %edi
  801857:	56                   	push   %esi
  801858:	53                   	push   %ebx
  801859:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80185c:	be 00 00 00 00       	mov    $0x0,%esi
  801861:	8b 55 08             	mov    0x8(%ebp),%edx
  801864:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801867:	b8 04 00 00 00       	mov    $0x4,%eax
  80186c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80186f:	89 f7                	mov    %esi,%edi
  801871:	cd 30                	int    $0x30
	if(check && ret > 0)
  801873:	85 c0                	test   %eax,%eax
  801875:	7f 08                	jg     80187f <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801877:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80187a:	5b                   	pop    %ebx
  80187b:	5e                   	pop    %esi
  80187c:	5f                   	pop    %edi
  80187d:	5d                   	pop    %ebp
  80187e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80187f:	83 ec 0c             	sub    $0xc,%esp
  801882:	50                   	push   %eax
  801883:	6a 04                	push   $0x4
  801885:	68 58 43 80 00       	push   $0x804358
  80188a:	6a 43                	push   $0x43
  80188c:	68 75 43 80 00       	push   $0x804375
  801891:	e8 86 f2 ff ff       	call   800b1c <_panic>

00801896 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
  801899:	57                   	push   %edi
  80189a:	56                   	push   %esi
  80189b:	53                   	push   %ebx
  80189c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80189f:	8b 55 08             	mov    0x8(%ebp),%edx
  8018a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018a5:	b8 05 00 00 00       	mov    $0x5,%eax
  8018aa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8018ad:	8b 7d 14             	mov    0x14(%ebp),%edi
  8018b0:	8b 75 18             	mov    0x18(%ebp),%esi
  8018b3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8018b5:	85 c0                	test   %eax,%eax
  8018b7:	7f 08                	jg     8018c1 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8018b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018bc:	5b                   	pop    %ebx
  8018bd:	5e                   	pop    %esi
  8018be:	5f                   	pop    %edi
  8018bf:	5d                   	pop    %ebp
  8018c0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8018c1:	83 ec 0c             	sub    $0xc,%esp
  8018c4:	50                   	push   %eax
  8018c5:	6a 05                	push   $0x5
  8018c7:	68 58 43 80 00       	push   $0x804358
  8018cc:	6a 43                	push   $0x43
  8018ce:	68 75 43 80 00       	push   $0x804375
  8018d3:	e8 44 f2 ff ff       	call   800b1c <_panic>

008018d8 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
  8018db:	57                   	push   %edi
  8018dc:	56                   	push   %esi
  8018dd:	53                   	push   %ebx
  8018de:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8018e1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8018e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018ec:	b8 06 00 00 00       	mov    $0x6,%eax
  8018f1:	89 df                	mov    %ebx,%edi
  8018f3:	89 de                	mov    %ebx,%esi
  8018f5:	cd 30                	int    $0x30
	if(check && ret > 0)
  8018f7:	85 c0                	test   %eax,%eax
  8018f9:	7f 08                	jg     801903 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8018fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018fe:	5b                   	pop    %ebx
  8018ff:	5e                   	pop    %esi
  801900:	5f                   	pop    %edi
  801901:	5d                   	pop    %ebp
  801902:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801903:	83 ec 0c             	sub    $0xc,%esp
  801906:	50                   	push   %eax
  801907:	6a 06                	push   $0x6
  801909:	68 58 43 80 00       	push   $0x804358
  80190e:	6a 43                	push   $0x43
  801910:	68 75 43 80 00       	push   $0x804375
  801915:	e8 02 f2 ff ff       	call   800b1c <_panic>

0080191a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
  80191d:	57                   	push   %edi
  80191e:	56                   	push   %esi
  80191f:	53                   	push   %ebx
  801920:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801923:	bb 00 00 00 00       	mov    $0x0,%ebx
  801928:	8b 55 08             	mov    0x8(%ebp),%edx
  80192b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80192e:	b8 08 00 00 00       	mov    $0x8,%eax
  801933:	89 df                	mov    %ebx,%edi
  801935:	89 de                	mov    %ebx,%esi
  801937:	cd 30                	int    $0x30
	if(check && ret > 0)
  801939:	85 c0                	test   %eax,%eax
  80193b:	7f 08                	jg     801945 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80193d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801940:	5b                   	pop    %ebx
  801941:	5e                   	pop    %esi
  801942:	5f                   	pop    %edi
  801943:	5d                   	pop    %ebp
  801944:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801945:	83 ec 0c             	sub    $0xc,%esp
  801948:	50                   	push   %eax
  801949:	6a 08                	push   $0x8
  80194b:	68 58 43 80 00       	push   $0x804358
  801950:	6a 43                	push   $0x43
  801952:	68 75 43 80 00       	push   $0x804375
  801957:	e8 c0 f1 ff ff       	call   800b1c <_panic>

0080195c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	57                   	push   %edi
  801960:	56                   	push   %esi
  801961:	53                   	push   %ebx
  801962:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801965:	bb 00 00 00 00       	mov    $0x0,%ebx
  80196a:	8b 55 08             	mov    0x8(%ebp),%edx
  80196d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801970:	b8 09 00 00 00       	mov    $0x9,%eax
  801975:	89 df                	mov    %ebx,%edi
  801977:	89 de                	mov    %ebx,%esi
  801979:	cd 30                	int    $0x30
	if(check && ret > 0)
  80197b:	85 c0                	test   %eax,%eax
  80197d:	7f 08                	jg     801987 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80197f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801982:	5b                   	pop    %ebx
  801983:	5e                   	pop    %esi
  801984:	5f                   	pop    %edi
  801985:	5d                   	pop    %ebp
  801986:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801987:	83 ec 0c             	sub    $0xc,%esp
  80198a:	50                   	push   %eax
  80198b:	6a 09                	push   $0x9
  80198d:	68 58 43 80 00       	push   $0x804358
  801992:	6a 43                	push   $0x43
  801994:	68 75 43 80 00       	push   $0x804375
  801999:	e8 7e f1 ff ff       	call   800b1c <_panic>

0080199e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
  8019a1:	57                   	push   %edi
  8019a2:	56                   	push   %esi
  8019a3:	53                   	push   %ebx
  8019a4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8019a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8019af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019b2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019b7:	89 df                	mov    %ebx,%edi
  8019b9:	89 de                	mov    %ebx,%esi
  8019bb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8019bd:	85 c0                	test   %eax,%eax
  8019bf:	7f 08                	jg     8019c9 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8019c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019c4:	5b                   	pop    %ebx
  8019c5:	5e                   	pop    %esi
  8019c6:	5f                   	pop    %edi
  8019c7:	5d                   	pop    %ebp
  8019c8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8019c9:	83 ec 0c             	sub    $0xc,%esp
  8019cc:	50                   	push   %eax
  8019cd:	6a 0a                	push   $0xa
  8019cf:	68 58 43 80 00       	push   $0x804358
  8019d4:	6a 43                	push   $0x43
  8019d6:	68 75 43 80 00       	push   $0x804375
  8019db:	e8 3c f1 ff ff       	call   800b1c <_panic>

008019e0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
  8019e3:	57                   	push   %edi
  8019e4:	56                   	push   %esi
  8019e5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8019e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8019e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019ec:	b8 0c 00 00 00       	mov    $0xc,%eax
  8019f1:	be 00 00 00 00       	mov    $0x0,%esi
  8019f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8019f9:	8b 7d 14             	mov    0x14(%ebp),%edi
  8019fc:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8019fe:	5b                   	pop    %ebx
  8019ff:	5e                   	pop    %esi
  801a00:	5f                   	pop    %edi
  801a01:	5d                   	pop    %ebp
  801a02:	c3                   	ret    

00801a03 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
  801a06:	57                   	push   %edi
  801a07:	56                   	push   %esi
  801a08:	53                   	push   %ebx
  801a09:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801a0c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a11:	8b 55 08             	mov    0x8(%ebp),%edx
  801a14:	b8 0d 00 00 00       	mov    $0xd,%eax
  801a19:	89 cb                	mov    %ecx,%ebx
  801a1b:	89 cf                	mov    %ecx,%edi
  801a1d:	89 ce                	mov    %ecx,%esi
  801a1f:	cd 30                	int    $0x30
	if(check && ret > 0)
  801a21:	85 c0                	test   %eax,%eax
  801a23:	7f 08                	jg     801a2d <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801a25:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a28:	5b                   	pop    %ebx
  801a29:	5e                   	pop    %esi
  801a2a:	5f                   	pop    %edi
  801a2b:	5d                   	pop    %ebp
  801a2c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801a2d:	83 ec 0c             	sub    $0xc,%esp
  801a30:	50                   	push   %eax
  801a31:	6a 0d                	push   $0xd
  801a33:	68 58 43 80 00       	push   $0x804358
  801a38:	6a 43                	push   $0x43
  801a3a:	68 75 43 80 00       	push   $0x804375
  801a3f:	e8 d8 f0 ff ff       	call   800b1c <_panic>

00801a44 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
  801a47:	57                   	push   %edi
  801a48:	56                   	push   %esi
  801a49:	53                   	push   %ebx
	asm volatile("int %1\n"
  801a4a:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a4f:	8b 55 08             	mov    0x8(%ebp),%edx
  801a52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a55:	b8 0e 00 00 00       	mov    $0xe,%eax
  801a5a:	89 df                	mov    %ebx,%edi
  801a5c:	89 de                	mov    %ebx,%esi
  801a5e:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801a60:	5b                   	pop    %ebx
  801a61:	5e                   	pop    %esi
  801a62:	5f                   	pop    %edi
  801a63:	5d                   	pop    %ebp
  801a64:	c3                   	ret    

00801a65 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
  801a68:	57                   	push   %edi
  801a69:	56                   	push   %esi
  801a6a:	53                   	push   %ebx
	asm volatile("int %1\n"
  801a6b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a70:	8b 55 08             	mov    0x8(%ebp),%edx
  801a73:	b8 0f 00 00 00       	mov    $0xf,%eax
  801a78:	89 cb                	mov    %ecx,%ebx
  801a7a:	89 cf                	mov    %ecx,%edi
  801a7c:	89 ce                	mov    %ecx,%esi
  801a7e:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801a80:	5b                   	pop    %ebx
  801a81:	5e                   	pop    %esi
  801a82:	5f                   	pop    %edi
  801a83:	5d                   	pop    %ebp
  801a84:	c3                   	ret    

00801a85 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
  801a88:	57                   	push   %edi
  801a89:	56                   	push   %esi
  801a8a:	53                   	push   %ebx
	asm volatile("int %1\n"
  801a8b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a90:	b8 10 00 00 00       	mov    $0x10,%eax
  801a95:	89 d1                	mov    %edx,%ecx
  801a97:	89 d3                	mov    %edx,%ebx
  801a99:	89 d7                	mov    %edx,%edi
  801a9b:	89 d6                	mov    %edx,%esi
  801a9d:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801a9f:	5b                   	pop    %ebx
  801aa0:	5e                   	pop    %esi
  801aa1:	5f                   	pop    %edi
  801aa2:	5d                   	pop    %ebp
  801aa3:	c3                   	ret    

00801aa4 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
  801aa7:	57                   	push   %edi
  801aa8:	56                   	push   %esi
  801aa9:	53                   	push   %ebx
	asm volatile("int %1\n"
  801aaa:	bb 00 00 00 00       	mov    $0x0,%ebx
  801aaf:	8b 55 08             	mov    0x8(%ebp),%edx
  801ab2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ab5:	b8 11 00 00 00       	mov    $0x11,%eax
  801aba:	89 df                	mov    %ebx,%edi
  801abc:	89 de                	mov    %ebx,%esi
  801abe:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801ac0:	5b                   	pop    %ebx
  801ac1:	5e                   	pop    %esi
  801ac2:	5f                   	pop    %edi
  801ac3:	5d                   	pop    %ebp
  801ac4:	c3                   	ret    

00801ac5 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
  801ac8:	57                   	push   %edi
  801ac9:	56                   	push   %esi
  801aca:	53                   	push   %ebx
	asm volatile("int %1\n"
  801acb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ad0:	8b 55 08             	mov    0x8(%ebp),%edx
  801ad3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ad6:	b8 12 00 00 00       	mov    $0x12,%eax
  801adb:	89 df                	mov    %ebx,%edi
  801add:	89 de                	mov    %ebx,%esi
  801adf:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801ae1:	5b                   	pop    %ebx
  801ae2:	5e                   	pop    %esi
  801ae3:	5f                   	pop    %edi
  801ae4:	5d                   	pop    %ebp
  801ae5:	c3                   	ret    

00801ae6 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
  801ae9:	57                   	push   %edi
  801aea:	56                   	push   %esi
  801aeb:	53                   	push   %ebx
  801aec:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801aef:	bb 00 00 00 00       	mov    $0x0,%ebx
  801af4:	8b 55 08             	mov    0x8(%ebp),%edx
  801af7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801afa:	b8 13 00 00 00       	mov    $0x13,%eax
  801aff:	89 df                	mov    %ebx,%edi
  801b01:	89 de                	mov    %ebx,%esi
  801b03:	cd 30                	int    $0x30
	if(check && ret > 0)
  801b05:	85 c0                	test   %eax,%eax
  801b07:	7f 08                	jg     801b11 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801b09:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b0c:	5b                   	pop    %ebx
  801b0d:	5e                   	pop    %esi
  801b0e:	5f                   	pop    %edi
  801b0f:	5d                   	pop    %ebp
  801b10:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801b11:	83 ec 0c             	sub    $0xc,%esp
  801b14:	50                   	push   %eax
  801b15:	6a 13                	push   $0x13
  801b17:	68 58 43 80 00       	push   $0x804358
  801b1c:	6a 43                	push   $0x43
  801b1e:	68 75 43 80 00       	push   $0x804375
  801b23:	e8 f4 ef ff ff       	call   800b1c <_panic>

00801b28 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
  801b2b:	57                   	push   %edi
  801b2c:	56                   	push   %esi
  801b2d:	53                   	push   %ebx
	asm volatile("int %1\n"
  801b2e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b33:	8b 55 08             	mov    0x8(%ebp),%edx
  801b36:	b8 14 00 00 00       	mov    $0x14,%eax
  801b3b:	89 cb                	mov    %ecx,%ebx
  801b3d:	89 cf                	mov    %ecx,%edi
  801b3f:	89 ce                	mov    %ecx,%esi
  801b41:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801b43:	5b                   	pop    %ebx
  801b44:	5e                   	pop    %esi
  801b45:	5f                   	pop    %edi
  801b46:	5d                   	pop    %ebp
  801b47:	c3                   	ret    

00801b48 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
  801b4b:	53                   	push   %ebx
  801b4c:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801b4f:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801b56:	f6 c5 04             	test   $0x4,%ch
  801b59:	75 45                	jne    801ba0 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801b5b:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801b62:	83 e1 07             	and    $0x7,%ecx
  801b65:	83 f9 07             	cmp    $0x7,%ecx
  801b68:	74 6f                	je     801bd9 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801b6a:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801b71:	81 e1 05 08 00 00    	and    $0x805,%ecx
  801b77:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801b7d:	0f 84 b6 00 00 00    	je     801c39 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801b83:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801b8a:	83 e1 05             	and    $0x5,%ecx
  801b8d:	83 f9 05             	cmp    $0x5,%ecx
  801b90:	0f 84 d7 00 00 00    	je     801c6d <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801b96:	b8 00 00 00 00       	mov    $0x0,%eax
  801b9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801ba0:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801ba7:	c1 e2 0c             	shl    $0xc,%edx
  801baa:	83 ec 0c             	sub    $0xc,%esp
  801bad:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801bb3:	51                   	push   %ecx
  801bb4:	52                   	push   %edx
  801bb5:	50                   	push   %eax
  801bb6:	52                   	push   %edx
  801bb7:	6a 00                	push   $0x0
  801bb9:	e8 d8 fc ff ff       	call   801896 <sys_page_map>
		if(r < 0)
  801bbe:	83 c4 20             	add    $0x20,%esp
  801bc1:	85 c0                	test   %eax,%eax
  801bc3:	79 d1                	jns    801b96 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801bc5:	83 ec 04             	sub    $0x4,%esp
  801bc8:	68 83 43 80 00       	push   $0x804383
  801bcd:	6a 54                	push   $0x54
  801bcf:	68 99 43 80 00       	push   $0x804399
  801bd4:	e8 43 ef ff ff       	call   800b1c <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801bd9:	89 d3                	mov    %edx,%ebx
  801bdb:	c1 e3 0c             	shl    $0xc,%ebx
  801bde:	83 ec 0c             	sub    $0xc,%esp
  801be1:	68 05 08 00 00       	push   $0x805
  801be6:	53                   	push   %ebx
  801be7:	50                   	push   %eax
  801be8:	53                   	push   %ebx
  801be9:	6a 00                	push   $0x0
  801beb:	e8 a6 fc ff ff       	call   801896 <sys_page_map>
		if(r < 0)
  801bf0:	83 c4 20             	add    $0x20,%esp
  801bf3:	85 c0                	test   %eax,%eax
  801bf5:	78 2e                	js     801c25 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801bf7:	83 ec 0c             	sub    $0xc,%esp
  801bfa:	68 05 08 00 00       	push   $0x805
  801bff:	53                   	push   %ebx
  801c00:	6a 00                	push   $0x0
  801c02:	53                   	push   %ebx
  801c03:	6a 00                	push   $0x0
  801c05:	e8 8c fc ff ff       	call   801896 <sys_page_map>
		if(r < 0)
  801c0a:	83 c4 20             	add    $0x20,%esp
  801c0d:	85 c0                	test   %eax,%eax
  801c0f:	79 85                	jns    801b96 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801c11:	83 ec 04             	sub    $0x4,%esp
  801c14:	68 83 43 80 00       	push   $0x804383
  801c19:	6a 5f                	push   $0x5f
  801c1b:	68 99 43 80 00       	push   $0x804399
  801c20:	e8 f7 ee ff ff       	call   800b1c <_panic>
			panic("sys_page_map() panic\n");
  801c25:	83 ec 04             	sub    $0x4,%esp
  801c28:	68 83 43 80 00       	push   $0x804383
  801c2d:	6a 5b                	push   $0x5b
  801c2f:	68 99 43 80 00       	push   $0x804399
  801c34:	e8 e3 ee ff ff       	call   800b1c <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801c39:	c1 e2 0c             	shl    $0xc,%edx
  801c3c:	83 ec 0c             	sub    $0xc,%esp
  801c3f:	68 05 08 00 00       	push   $0x805
  801c44:	52                   	push   %edx
  801c45:	50                   	push   %eax
  801c46:	52                   	push   %edx
  801c47:	6a 00                	push   $0x0
  801c49:	e8 48 fc ff ff       	call   801896 <sys_page_map>
		if(r < 0)
  801c4e:	83 c4 20             	add    $0x20,%esp
  801c51:	85 c0                	test   %eax,%eax
  801c53:	0f 89 3d ff ff ff    	jns    801b96 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801c59:	83 ec 04             	sub    $0x4,%esp
  801c5c:	68 83 43 80 00       	push   $0x804383
  801c61:	6a 66                	push   $0x66
  801c63:	68 99 43 80 00       	push   $0x804399
  801c68:	e8 af ee ff ff       	call   800b1c <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801c6d:	c1 e2 0c             	shl    $0xc,%edx
  801c70:	83 ec 0c             	sub    $0xc,%esp
  801c73:	6a 05                	push   $0x5
  801c75:	52                   	push   %edx
  801c76:	50                   	push   %eax
  801c77:	52                   	push   %edx
  801c78:	6a 00                	push   $0x0
  801c7a:	e8 17 fc ff ff       	call   801896 <sys_page_map>
		if(r < 0)
  801c7f:	83 c4 20             	add    $0x20,%esp
  801c82:	85 c0                	test   %eax,%eax
  801c84:	0f 89 0c ff ff ff    	jns    801b96 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801c8a:	83 ec 04             	sub    $0x4,%esp
  801c8d:	68 83 43 80 00       	push   $0x804383
  801c92:	6a 6d                	push   $0x6d
  801c94:	68 99 43 80 00       	push   $0x804399
  801c99:	e8 7e ee ff ff       	call   800b1c <_panic>

00801c9e <pgfault>:
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	53                   	push   %ebx
  801ca2:	83 ec 04             	sub    $0x4,%esp
  801ca5:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801ca8:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801caa:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801cae:	0f 84 99 00 00 00    	je     801d4d <pgfault+0xaf>
  801cb4:	89 c2                	mov    %eax,%edx
  801cb6:	c1 ea 16             	shr    $0x16,%edx
  801cb9:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801cc0:	f6 c2 01             	test   $0x1,%dl
  801cc3:	0f 84 84 00 00 00    	je     801d4d <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801cc9:	89 c2                	mov    %eax,%edx
  801ccb:	c1 ea 0c             	shr    $0xc,%edx
  801cce:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801cd5:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801cdb:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801ce1:	75 6a                	jne    801d4d <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801ce3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ce8:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801cea:	83 ec 04             	sub    $0x4,%esp
  801ced:	6a 07                	push   $0x7
  801cef:	68 00 f0 7f 00       	push   $0x7ff000
  801cf4:	6a 00                	push   $0x0
  801cf6:	e8 58 fb ff ff       	call   801853 <sys_page_alloc>
	if(ret < 0)
  801cfb:	83 c4 10             	add    $0x10,%esp
  801cfe:	85 c0                	test   %eax,%eax
  801d00:	78 5f                	js     801d61 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801d02:	83 ec 04             	sub    $0x4,%esp
  801d05:	68 00 10 00 00       	push   $0x1000
  801d0a:	53                   	push   %ebx
  801d0b:	68 00 f0 7f 00       	push   $0x7ff000
  801d10:	e8 3c f9 ff ff       	call   801651 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801d15:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801d1c:	53                   	push   %ebx
  801d1d:	6a 00                	push   $0x0
  801d1f:	68 00 f0 7f 00       	push   $0x7ff000
  801d24:	6a 00                	push   $0x0
  801d26:	e8 6b fb ff ff       	call   801896 <sys_page_map>
	if(ret < 0)
  801d2b:	83 c4 20             	add    $0x20,%esp
  801d2e:	85 c0                	test   %eax,%eax
  801d30:	78 43                	js     801d75 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801d32:	83 ec 08             	sub    $0x8,%esp
  801d35:	68 00 f0 7f 00       	push   $0x7ff000
  801d3a:	6a 00                	push   $0x0
  801d3c:	e8 97 fb ff ff       	call   8018d8 <sys_page_unmap>
	if(ret < 0)
  801d41:	83 c4 10             	add    $0x10,%esp
  801d44:	85 c0                	test   %eax,%eax
  801d46:	78 41                	js     801d89 <pgfault+0xeb>
}
  801d48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d4b:	c9                   	leave  
  801d4c:	c3                   	ret    
		panic("panic at pgfault()\n");
  801d4d:	83 ec 04             	sub    $0x4,%esp
  801d50:	68 a4 43 80 00       	push   $0x8043a4
  801d55:	6a 26                	push   $0x26
  801d57:	68 99 43 80 00       	push   $0x804399
  801d5c:	e8 bb ed ff ff       	call   800b1c <_panic>
		panic("panic in sys_page_alloc()\n");
  801d61:	83 ec 04             	sub    $0x4,%esp
  801d64:	68 b8 43 80 00       	push   $0x8043b8
  801d69:	6a 31                	push   $0x31
  801d6b:	68 99 43 80 00       	push   $0x804399
  801d70:	e8 a7 ed ff ff       	call   800b1c <_panic>
		panic("panic in sys_page_map()\n");
  801d75:	83 ec 04             	sub    $0x4,%esp
  801d78:	68 d3 43 80 00       	push   $0x8043d3
  801d7d:	6a 36                	push   $0x36
  801d7f:	68 99 43 80 00       	push   $0x804399
  801d84:	e8 93 ed ff ff       	call   800b1c <_panic>
		panic("panic in sys_page_unmap()\n");
  801d89:	83 ec 04             	sub    $0x4,%esp
  801d8c:	68 ec 43 80 00       	push   $0x8043ec
  801d91:	6a 39                	push   $0x39
  801d93:	68 99 43 80 00       	push   $0x804399
  801d98:	e8 7f ed ff ff       	call   800b1c <_panic>

00801d9d <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
  801da0:	57                   	push   %edi
  801da1:	56                   	push   %esi
  801da2:	53                   	push   %ebx
  801da3:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801da6:	68 9e 1c 80 00       	push   $0x801c9e
  801dab:	e8 36 1b 00 00       	call   8038e6 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801db0:	b8 07 00 00 00       	mov    $0x7,%eax
  801db5:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801db7:	83 c4 10             	add    $0x10,%esp
  801dba:	85 c0                	test   %eax,%eax
  801dbc:	78 2a                	js     801de8 <fork+0x4b>
  801dbe:	89 c6                	mov    %eax,%esi
  801dc0:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801dc2:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801dc7:	75 4b                	jne    801e14 <fork+0x77>
		thisenv = &envs[ENVX(sys_getenvid())];
  801dc9:	e8 47 fa ff ff       	call   801815 <sys_getenvid>
  801dce:	25 ff 03 00 00       	and    $0x3ff,%eax
  801dd3:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801dd9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801dde:	a3 28 64 80 00       	mov    %eax,0x806428
		return 0;
  801de3:	e9 90 00 00 00       	jmp    801e78 <fork+0xdb>
		panic("the fork panic! at sys_exofork()\n");
  801de8:	83 ec 04             	sub    $0x4,%esp
  801deb:	68 08 44 80 00       	push   $0x804408
  801df0:	68 8c 00 00 00       	push   $0x8c
  801df5:	68 99 43 80 00       	push   $0x804399
  801dfa:	e8 1d ed ff ff       	call   800b1c <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801dff:	89 f8                	mov    %edi,%eax
  801e01:	e8 42 fd ff ff       	call   801b48 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801e06:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801e0c:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801e12:	74 26                	je     801e3a <fork+0x9d>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801e14:	89 d8                	mov    %ebx,%eax
  801e16:	c1 e8 16             	shr    $0x16,%eax
  801e19:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801e20:	a8 01                	test   $0x1,%al
  801e22:	74 e2                	je     801e06 <fork+0x69>
  801e24:	89 da                	mov    %ebx,%edx
  801e26:	c1 ea 0c             	shr    $0xc,%edx
  801e29:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801e30:	83 e0 05             	and    $0x5,%eax
  801e33:	83 f8 05             	cmp    $0x5,%eax
  801e36:	75 ce                	jne    801e06 <fork+0x69>
  801e38:	eb c5                	jmp    801dff <fork+0x62>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801e3a:	83 ec 04             	sub    $0x4,%esp
  801e3d:	6a 07                	push   $0x7
  801e3f:	68 00 f0 bf ee       	push   $0xeebff000
  801e44:	56                   	push   %esi
  801e45:	e8 09 fa ff ff       	call   801853 <sys_page_alloc>
	if(ret < 0)
  801e4a:	83 c4 10             	add    $0x10,%esp
  801e4d:	85 c0                	test   %eax,%eax
  801e4f:	78 31                	js     801e82 <fork+0xe5>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801e51:	83 ec 08             	sub    $0x8,%esp
  801e54:	68 55 39 80 00       	push   $0x803955
  801e59:	56                   	push   %esi
  801e5a:	e8 3f fb ff ff       	call   80199e <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801e5f:	83 c4 10             	add    $0x10,%esp
  801e62:	85 c0                	test   %eax,%eax
  801e64:	78 33                	js     801e99 <fork+0xfc>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801e66:	83 ec 08             	sub    $0x8,%esp
  801e69:	6a 02                	push   $0x2
  801e6b:	56                   	push   %esi
  801e6c:	e8 a9 fa ff ff       	call   80191a <sys_env_set_status>
	if(ret < 0)
  801e71:	83 c4 10             	add    $0x10,%esp
  801e74:	85 c0                	test   %eax,%eax
  801e76:	78 38                	js     801eb0 <fork+0x113>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801e78:	89 f0                	mov    %esi,%eax
  801e7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e7d:	5b                   	pop    %ebx
  801e7e:	5e                   	pop    %esi
  801e7f:	5f                   	pop    %edi
  801e80:	5d                   	pop    %ebp
  801e81:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801e82:	83 ec 04             	sub    $0x4,%esp
  801e85:	68 b8 43 80 00       	push   $0x8043b8
  801e8a:	68 98 00 00 00       	push   $0x98
  801e8f:	68 99 43 80 00       	push   $0x804399
  801e94:	e8 83 ec ff ff       	call   800b1c <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801e99:	83 ec 04             	sub    $0x4,%esp
  801e9c:	68 2c 44 80 00       	push   $0x80442c
  801ea1:	68 9b 00 00 00       	push   $0x9b
  801ea6:	68 99 43 80 00       	push   $0x804399
  801eab:	e8 6c ec ff ff       	call   800b1c <_panic>
		panic("panic in sys_env_set_status()\n");
  801eb0:	83 ec 04             	sub    $0x4,%esp
  801eb3:	68 54 44 80 00       	push   $0x804454
  801eb8:	68 9e 00 00 00       	push   $0x9e
  801ebd:	68 99 43 80 00       	push   $0x804399
  801ec2:	e8 55 ec ff ff       	call   800b1c <_panic>

00801ec7 <sfork>:

// Challenge!
int
sfork(void)
{
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
  801eca:	57                   	push   %edi
  801ecb:	56                   	push   %esi
  801ecc:	53                   	push   %ebx
  801ecd:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801ed0:	68 9e 1c 80 00       	push   $0x801c9e
  801ed5:	e8 0c 1a 00 00       	call   8038e6 <set_pgfault_handler>
  801eda:	b8 07 00 00 00       	mov    $0x7,%eax
  801edf:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801ee1:	83 c4 10             	add    $0x10,%esp
  801ee4:	85 c0                	test   %eax,%eax
  801ee6:	78 2a                	js     801f12 <sfork+0x4b>
  801ee8:	89 c7                	mov    %eax,%edi
  801eea:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801eec:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801ef1:	75 58                	jne    801f4b <sfork+0x84>
		thisenv = &envs[ENVX(sys_getenvid())];
  801ef3:	e8 1d f9 ff ff       	call   801815 <sys_getenvid>
  801ef8:	25 ff 03 00 00       	and    $0x3ff,%eax
  801efd:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801f03:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801f08:	a3 28 64 80 00       	mov    %eax,0x806428
		return 0;
  801f0d:	e9 d4 00 00 00       	jmp    801fe6 <sfork+0x11f>
		panic("the fork panic! at sys_exofork()\n");
  801f12:	83 ec 04             	sub    $0x4,%esp
  801f15:	68 08 44 80 00       	push   $0x804408
  801f1a:	68 af 00 00 00       	push   $0xaf
  801f1f:	68 99 43 80 00       	push   $0x804399
  801f24:	e8 f3 eb ff ff       	call   800b1c <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801f29:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801f2e:	89 f0                	mov    %esi,%eax
  801f30:	e8 13 fc ff ff       	call   801b48 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801f35:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801f3b:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801f41:	77 65                	ja     801fa8 <sfork+0xe1>
		if(i == (USTACKTOP - PGSIZE))
  801f43:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801f49:	74 de                	je     801f29 <sfork+0x62>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801f4b:	89 d8                	mov    %ebx,%eax
  801f4d:	c1 e8 16             	shr    $0x16,%eax
  801f50:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801f57:	a8 01                	test   $0x1,%al
  801f59:	74 da                	je     801f35 <sfork+0x6e>
  801f5b:	89 da                	mov    %ebx,%edx
  801f5d:	c1 ea 0c             	shr    $0xc,%edx
  801f60:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801f67:	83 e0 05             	and    $0x5,%eax
  801f6a:	83 f8 05             	cmp    $0x5,%eax
  801f6d:	75 c6                	jne    801f35 <sfork+0x6e>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801f6f:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801f76:	c1 e2 0c             	shl    $0xc,%edx
  801f79:	83 ec 0c             	sub    $0xc,%esp
  801f7c:	83 e0 07             	and    $0x7,%eax
  801f7f:	50                   	push   %eax
  801f80:	52                   	push   %edx
  801f81:	56                   	push   %esi
  801f82:	52                   	push   %edx
  801f83:	6a 00                	push   $0x0
  801f85:	e8 0c f9 ff ff       	call   801896 <sys_page_map>
  801f8a:	83 c4 20             	add    $0x20,%esp
  801f8d:	85 c0                	test   %eax,%eax
  801f8f:	74 a4                	je     801f35 <sfork+0x6e>
				panic("sys_page_map() panic\n");
  801f91:	83 ec 04             	sub    $0x4,%esp
  801f94:	68 83 43 80 00       	push   $0x804383
  801f99:	68 ba 00 00 00       	push   $0xba
  801f9e:	68 99 43 80 00       	push   $0x804399
  801fa3:	e8 74 eb ff ff       	call   800b1c <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801fa8:	83 ec 04             	sub    $0x4,%esp
  801fab:	6a 07                	push   $0x7
  801fad:	68 00 f0 bf ee       	push   $0xeebff000
  801fb2:	57                   	push   %edi
  801fb3:	e8 9b f8 ff ff       	call   801853 <sys_page_alloc>
	if(ret < 0)
  801fb8:	83 c4 10             	add    $0x10,%esp
  801fbb:	85 c0                	test   %eax,%eax
  801fbd:	78 31                	js     801ff0 <sfork+0x129>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801fbf:	83 ec 08             	sub    $0x8,%esp
  801fc2:	68 55 39 80 00       	push   $0x803955
  801fc7:	57                   	push   %edi
  801fc8:	e8 d1 f9 ff ff       	call   80199e <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801fcd:	83 c4 10             	add    $0x10,%esp
  801fd0:	85 c0                	test   %eax,%eax
  801fd2:	78 33                	js     802007 <sfork+0x140>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801fd4:	83 ec 08             	sub    $0x8,%esp
  801fd7:	6a 02                	push   $0x2
  801fd9:	57                   	push   %edi
  801fda:	e8 3b f9 ff ff       	call   80191a <sys_env_set_status>
	if(ret < 0)
  801fdf:	83 c4 10             	add    $0x10,%esp
  801fe2:	85 c0                	test   %eax,%eax
  801fe4:	78 38                	js     80201e <sfork+0x157>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801fe6:	89 f8                	mov    %edi,%eax
  801fe8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801feb:	5b                   	pop    %ebx
  801fec:	5e                   	pop    %esi
  801fed:	5f                   	pop    %edi
  801fee:	5d                   	pop    %ebp
  801fef:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801ff0:	83 ec 04             	sub    $0x4,%esp
  801ff3:	68 b8 43 80 00       	push   $0x8043b8
  801ff8:	68 c0 00 00 00       	push   $0xc0
  801ffd:	68 99 43 80 00       	push   $0x804399
  802002:	e8 15 eb ff ff       	call   800b1c <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  802007:	83 ec 04             	sub    $0x4,%esp
  80200a:	68 2c 44 80 00       	push   $0x80442c
  80200f:	68 c3 00 00 00       	push   $0xc3
  802014:	68 99 43 80 00       	push   $0x804399
  802019:	e8 fe ea ff ff       	call   800b1c <_panic>
		panic("panic in sys_env_set_status()\n");
  80201e:	83 ec 04             	sub    $0x4,%esp
  802021:	68 54 44 80 00       	push   $0x804454
  802026:	68 c6 00 00 00       	push   $0xc6
  80202b:	68 99 43 80 00       	push   $0x804399
  802030:	e8 e7 ea ff ff       	call   800b1c <_panic>

00802035 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  802035:	55                   	push   %ebp
  802036:	89 e5                	mov    %esp,%ebp
  802038:	8b 55 08             	mov    0x8(%ebp),%edx
  80203b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80203e:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  802041:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  802043:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  802046:	83 3a 01             	cmpl   $0x1,(%edx)
  802049:	7e 09                	jle    802054 <argstart+0x1f>
  80204b:	ba 41 3d 80 00       	mov    $0x803d41,%edx
  802050:	85 c9                	test   %ecx,%ecx
  802052:	75 05                	jne    802059 <argstart+0x24>
  802054:	ba 00 00 00 00       	mov    $0x0,%edx
  802059:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  80205c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  802063:	5d                   	pop    %ebp
  802064:	c3                   	ret    

00802065 <argnext>:

int
argnext(struct Argstate *args)
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
  802068:	53                   	push   %ebx
  802069:	83 ec 04             	sub    $0x4,%esp
  80206c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  80206f:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  802076:	8b 43 08             	mov    0x8(%ebx),%eax
  802079:	85 c0                	test   %eax,%eax
  80207b:	74 72                	je     8020ef <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  80207d:	80 38 00             	cmpb   $0x0,(%eax)
  802080:	75 48                	jne    8020ca <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  802082:	8b 0b                	mov    (%ebx),%ecx
  802084:	83 39 01             	cmpl   $0x1,(%ecx)
  802087:	74 58                	je     8020e1 <argnext+0x7c>
		    || args->argv[1][0] != '-'
  802089:	8b 53 04             	mov    0x4(%ebx),%edx
  80208c:	8b 42 04             	mov    0x4(%edx),%eax
  80208f:	80 38 2d             	cmpb   $0x2d,(%eax)
  802092:	75 4d                	jne    8020e1 <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  802094:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  802098:	74 47                	je     8020e1 <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  80209a:	83 c0 01             	add    $0x1,%eax
  80209d:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8020a0:	83 ec 04             	sub    $0x4,%esp
  8020a3:	8b 01                	mov    (%ecx),%eax
  8020a5:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  8020ac:	50                   	push   %eax
  8020ad:	8d 42 08             	lea    0x8(%edx),%eax
  8020b0:	50                   	push   %eax
  8020b1:	83 c2 04             	add    $0x4,%edx
  8020b4:	52                   	push   %edx
  8020b5:	e8 35 f5 ff ff       	call   8015ef <memmove>
		(*args->argc)--;
  8020ba:	8b 03                	mov    (%ebx),%eax
  8020bc:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8020bf:	8b 43 08             	mov    0x8(%ebx),%eax
  8020c2:	83 c4 10             	add    $0x10,%esp
  8020c5:	80 38 2d             	cmpb   $0x2d,(%eax)
  8020c8:	74 11                	je     8020db <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  8020ca:	8b 53 08             	mov    0x8(%ebx),%edx
  8020cd:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  8020d0:	83 c2 01             	add    $0x1,%edx
  8020d3:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  8020d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020d9:	c9                   	leave  
  8020da:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8020db:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  8020df:	75 e9                	jne    8020ca <argnext+0x65>
	args->curarg = 0;
  8020e1:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  8020e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8020ed:	eb e7                	jmp    8020d6 <argnext+0x71>
		return -1;
  8020ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8020f4:	eb e0                	jmp    8020d6 <argnext+0x71>

008020f6 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
  8020f9:	53                   	push   %ebx
  8020fa:	83 ec 04             	sub    $0x4,%esp
  8020fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  802100:	8b 43 08             	mov    0x8(%ebx),%eax
  802103:	85 c0                	test   %eax,%eax
  802105:	74 12                	je     802119 <argnextvalue+0x23>
		return 0;
	if (*args->curarg) {
  802107:	80 38 00             	cmpb   $0x0,(%eax)
  80210a:	74 12                	je     80211e <argnextvalue+0x28>
		args->argvalue = args->curarg;
  80210c:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  80210f:	c7 43 08 41 3d 80 00 	movl   $0x803d41,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  802116:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  802119:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80211c:	c9                   	leave  
  80211d:	c3                   	ret    
	} else if (*args->argc > 1) {
  80211e:	8b 13                	mov    (%ebx),%edx
  802120:	83 3a 01             	cmpl   $0x1,(%edx)
  802123:	7f 10                	jg     802135 <argnextvalue+0x3f>
		args->argvalue = 0;
  802125:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  80212c:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  802133:	eb e1                	jmp    802116 <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  802135:	8b 43 04             	mov    0x4(%ebx),%eax
  802138:	8b 48 04             	mov    0x4(%eax),%ecx
  80213b:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  80213e:	83 ec 04             	sub    $0x4,%esp
  802141:	8b 12                	mov    (%edx),%edx
  802143:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  80214a:	52                   	push   %edx
  80214b:	8d 50 08             	lea    0x8(%eax),%edx
  80214e:	52                   	push   %edx
  80214f:	83 c0 04             	add    $0x4,%eax
  802152:	50                   	push   %eax
  802153:	e8 97 f4 ff ff       	call   8015ef <memmove>
		(*args->argc)--;
  802158:	8b 03                	mov    (%ebx),%eax
  80215a:	83 28 01             	subl   $0x1,(%eax)
  80215d:	83 c4 10             	add    $0x10,%esp
  802160:	eb b4                	jmp    802116 <argnextvalue+0x20>

00802162 <argvalue>:
{
  802162:	55                   	push   %ebp
  802163:	89 e5                	mov    %esp,%ebp
  802165:	83 ec 08             	sub    $0x8,%esp
  802168:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  80216b:	8b 42 0c             	mov    0xc(%edx),%eax
  80216e:	85 c0                	test   %eax,%eax
  802170:	74 02                	je     802174 <argvalue+0x12>
}
  802172:	c9                   	leave  
  802173:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  802174:	83 ec 0c             	sub    $0xc,%esp
  802177:	52                   	push   %edx
  802178:	e8 79 ff ff ff       	call   8020f6 <argnextvalue>
  80217d:	83 c4 10             	add    $0x10,%esp
  802180:	eb f0                	jmp    802172 <argvalue+0x10>

00802182 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  802182:	55                   	push   %ebp
  802183:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802185:	8b 45 08             	mov    0x8(%ebp),%eax
  802188:	05 00 00 00 30       	add    $0x30000000,%eax
  80218d:	c1 e8 0c             	shr    $0xc,%eax
}
  802190:	5d                   	pop    %ebp
  802191:	c3                   	ret    

00802192 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802192:	55                   	push   %ebp
  802193:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802195:	8b 45 08             	mov    0x8(%ebp),%eax
  802198:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80219d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8021a2:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8021a7:	5d                   	pop    %ebp
  8021a8:	c3                   	ret    

008021a9 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8021a9:	55                   	push   %ebp
  8021aa:	89 e5                	mov    %esp,%ebp
  8021ac:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8021b1:	89 c2                	mov    %eax,%edx
  8021b3:	c1 ea 16             	shr    $0x16,%edx
  8021b6:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8021bd:	f6 c2 01             	test   $0x1,%dl
  8021c0:	74 2d                	je     8021ef <fd_alloc+0x46>
  8021c2:	89 c2                	mov    %eax,%edx
  8021c4:	c1 ea 0c             	shr    $0xc,%edx
  8021c7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8021ce:	f6 c2 01             	test   $0x1,%dl
  8021d1:	74 1c                	je     8021ef <fd_alloc+0x46>
  8021d3:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8021d8:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8021dd:	75 d2                	jne    8021b1 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8021df:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8021e8:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8021ed:	eb 0a                	jmp    8021f9 <fd_alloc+0x50>
			*fd_store = fd;
  8021ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021f2:	89 01                	mov    %eax,(%ecx)
			return 0;
  8021f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021f9:	5d                   	pop    %ebp
  8021fa:	c3                   	ret    

008021fb <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8021fb:	55                   	push   %ebp
  8021fc:	89 e5                	mov    %esp,%ebp
  8021fe:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802201:	83 f8 1f             	cmp    $0x1f,%eax
  802204:	77 30                	ja     802236 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  802206:	c1 e0 0c             	shl    $0xc,%eax
  802209:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80220e:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  802214:	f6 c2 01             	test   $0x1,%dl
  802217:	74 24                	je     80223d <fd_lookup+0x42>
  802219:	89 c2                	mov    %eax,%edx
  80221b:	c1 ea 0c             	shr    $0xc,%edx
  80221e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802225:	f6 c2 01             	test   $0x1,%dl
  802228:	74 1a                	je     802244 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80222a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80222d:	89 02                	mov    %eax,(%edx)
	return 0;
  80222f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802234:	5d                   	pop    %ebp
  802235:	c3                   	ret    
		return -E_INVAL;
  802236:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80223b:	eb f7                	jmp    802234 <fd_lookup+0x39>
		return -E_INVAL;
  80223d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802242:	eb f0                	jmp    802234 <fd_lookup+0x39>
  802244:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802249:	eb e9                	jmp    802234 <fd_lookup+0x39>

0080224b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80224b:	55                   	push   %ebp
  80224c:	89 e5                	mov    %esp,%ebp
  80224e:	83 ec 08             	sub    $0x8,%esp
  802251:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  802254:	ba 00 00 00 00       	mov    $0x0,%edx
  802259:	b8 20 50 80 00       	mov    $0x805020,%eax
		if (devtab[i]->dev_id == dev_id) {
  80225e:	39 08                	cmp    %ecx,(%eax)
  802260:	74 38                	je     80229a <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  802262:	83 c2 01             	add    $0x1,%edx
  802265:	8b 04 95 f0 44 80 00 	mov    0x8044f0(,%edx,4),%eax
  80226c:	85 c0                	test   %eax,%eax
  80226e:	75 ee                	jne    80225e <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802270:	a1 28 64 80 00       	mov    0x806428,%eax
  802275:	8b 40 48             	mov    0x48(%eax),%eax
  802278:	83 ec 04             	sub    $0x4,%esp
  80227b:	51                   	push   %ecx
  80227c:	50                   	push   %eax
  80227d:	68 74 44 80 00       	push   $0x804474
  802282:	e8 8b e9 ff ff       	call   800c12 <cprintf>
	*dev = 0;
  802287:	8b 45 0c             	mov    0xc(%ebp),%eax
  80228a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  802290:	83 c4 10             	add    $0x10,%esp
  802293:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802298:	c9                   	leave  
  802299:	c3                   	ret    
			*dev = devtab[i];
  80229a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80229d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80229f:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a4:	eb f2                	jmp    802298 <dev_lookup+0x4d>

008022a6 <fd_close>:
{
  8022a6:	55                   	push   %ebp
  8022a7:	89 e5                	mov    %esp,%ebp
  8022a9:	57                   	push   %edi
  8022aa:	56                   	push   %esi
  8022ab:	53                   	push   %ebx
  8022ac:	83 ec 24             	sub    $0x24,%esp
  8022af:	8b 75 08             	mov    0x8(%ebp),%esi
  8022b2:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8022b5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8022b8:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8022b9:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8022bf:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8022c2:	50                   	push   %eax
  8022c3:	e8 33 ff ff ff       	call   8021fb <fd_lookup>
  8022c8:	89 c3                	mov    %eax,%ebx
  8022ca:	83 c4 10             	add    $0x10,%esp
  8022cd:	85 c0                	test   %eax,%eax
  8022cf:	78 05                	js     8022d6 <fd_close+0x30>
	    || fd != fd2)
  8022d1:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8022d4:	74 16                	je     8022ec <fd_close+0x46>
		return (must_exist ? r : 0);
  8022d6:	89 f8                	mov    %edi,%eax
  8022d8:	84 c0                	test   %al,%al
  8022da:	b8 00 00 00 00       	mov    $0x0,%eax
  8022df:	0f 44 d8             	cmove  %eax,%ebx
}
  8022e2:	89 d8                	mov    %ebx,%eax
  8022e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022e7:	5b                   	pop    %ebx
  8022e8:	5e                   	pop    %esi
  8022e9:	5f                   	pop    %edi
  8022ea:	5d                   	pop    %ebp
  8022eb:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8022ec:	83 ec 08             	sub    $0x8,%esp
  8022ef:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8022f2:	50                   	push   %eax
  8022f3:	ff 36                	pushl  (%esi)
  8022f5:	e8 51 ff ff ff       	call   80224b <dev_lookup>
  8022fa:	89 c3                	mov    %eax,%ebx
  8022fc:	83 c4 10             	add    $0x10,%esp
  8022ff:	85 c0                	test   %eax,%eax
  802301:	78 1a                	js     80231d <fd_close+0x77>
		if (dev->dev_close)
  802303:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802306:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  802309:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80230e:	85 c0                	test   %eax,%eax
  802310:	74 0b                	je     80231d <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  802312:	83 ec 0c             	sub    $0xc,%esp
  802315:	56                   	push   %esi
  802316:	ff d0                	call   *%eax
  802318:	89 c3                	mov    %eax,%ebx
  80231a:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80231d:	83 ec 08             	sub    $0x8,%esp
  802320:	56                   	push   %esi
  802321:	6a 00                	push   $0x0
  802323:	e8 b0 f5 ff ff       	call   8018d8 <sys_page_unmap>
	return r;
  802328:	83 c4 10             	add    $0x10,%esp
  80232b:	eb b5                	jmp    8022e2 <fd_close+0x3c>

0080232d <close>:

int
close(int fdnum)
{
  80232d:	55                   	push   %ebp
  80232e:	89 e5                	mov    %esp,%ebp
  802330:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802333:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802336:	50                   	push   %eax
  802337:	ff 75 08             	pushl  0x8(%ebp)
  80233a:	e8 bc fe ff ff       	call   8021fb <fd_lookup>
  80233f:	83 c4 10             	add    $0x10,%esp
  802342:	85 c0                	test   %eax,%eax
  802344:	79 02                	jns    802348 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  802346:	c9                   	leave  
  802347:	c3                   	ret    
		return fd_close(fd, 1);
  802348:	83 ec 08             	sub    $0x8,%esp
  80234b:	6a 01                	push   $0x1
  80234d:	ff 75 f4             	pushl  -0xc(%ebp)
  802350:	e8 51 ff ff ff       	call   8022a6 <fd_close>
  802355:	83 c4 10             	add    $0x10,%esp
  802358:	eb ec                	jmp    802346 <close+0x19>

0080235a <close_all>:

void
close_all(void)
{
  80235a:	55                   	push   %ebp
  80235b:	89 e5                	mov    %esp,%ebp
  80235d:	53                   	push   %ebx
  80235e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  802361:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  802366:	83 ec 0c             	sub    $0xc,%esp
  802369:	53                   	push   %ebx
  80236a:	e8 be ff ff ff       	call   80232d <close>
	for (i = 0; i < MAXFD; i++)
  80236f:	83 c3 01             	add    $0x1,%ebx
  802372:	83 c4 10             	add    $0x10,%esp
  802375:	83 fb 20             	cmp    $0x20,%ebx
  802378:	75 ec                	jne    802366 <close_all+0xc>
}
  80237a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80237d:	c9                   	leave  
  80237e:	c3                   	ret    

0080237f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80237f:	55                   	push   %ebp
  802380:	89 e5                	mov    %esp,%ebp
  802382:	57                   	push   %edi
  802383:	56                   	push   %esi
  802384:	53                   	push   %ebx
  802385:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802388:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80238b:	50                   	push   %eax
  80238c:	ff 75 08             	pushl  0x8(%ebp)
  80238f:	e8 67 fe ff ff       	call   8021fb <fd_lookup>
  802394:	89 c3                	mov    %eax,%ebx
  802396:	83 c4 10             	add    $0x10,%esp
  802399:	85 c0                	test   %eax,%eax
  80239b:	0f 88 81 00 00 00    	js     802422 <dup+0xa3>
		return r;
	close(newfdnum);
  8023a1:	83 ec 0c             	sub    $0xc,%esp
  8023a4:	ff 75 0c             	pushl  0xc(%ebp)
  8023a7:	e8 81 ff ff ff       	call   80232d <close>

	newfd = INDEX2FD(newfdnum);
  8023ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  8023af:	c1 e6 0c             	shl    $0xc,%esi
  8023b2:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8023b8:	83 c4 04             	add    $0x4,%esp
  8023bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8023be:	e8 cf fd ff ff       	call   802192 <fd2data>
  8023c3:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8023c5:	89 34 24             	mov    %esi,(%esp)
  8023c8:	e8 c5 fd ff ff       	call   802192 <fd2data>
  8023cd:	83 c4 10             	add    $0x10,%esp
  8023d0:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8023d2:	89 d8                	mov    %ebx,%eax
  8023d4:	c1 e8 16             	shr    $0x16,%eax
  8023d7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8023de:	a8 01                	test   $0x1,%al
  8023e0:	74 11                	je     8023f3 <dup+0x74>
  8023e2:	89 d8                	mov    %ebx,%eax
  8023e4:	c1 e8 0c             	shr    $0xc,%eax
  8023e7:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8023ee:	f6 c2 01             	test   $0x1,%dl
  8023f1:	75 39                	jne    80242c <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8023f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023f6:	89 d0                	mov    %edx,%eax
  8023f8:	c1 e8 0c             	shr    $0xc,%eax
  8023fb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802402:	83 ec 0c             	sub    $0xc,%esp
  802405:	25 07 0e 00 00       	and    $0xe07,%eax
  80240a:	50                   	push   %eax
  80240b:	56                   	push   %esi
  80240c:	6a 00                	push   $0x0
  80240e:	52                   	push   %edx
  80240f:	6a 00                	push   $0x0
  802411:	e8 80 f4 ff ff       	call   801896 <sys_page_map>
  802416:	89 c3                	mov    %eax,%ebx
  802418:	83 c4 20             	add    $0x20,%esp
  80241b:	85 c0                	test   %eax,%eax
  80241d:	78 31                	js     802450 <dup+0xd1>
		goto err;

	return newfdnum;
  80241f:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  802422:	89 d8                	mov    %ebx,%eax
  802424:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802427:	5b                   	pop    %ebx
  802428:	5e                   	pop    %esi
  802429:	5f                   	pop    %edi
  80242a:	5d                   	pop    %ebp
  80242b:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80242c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802433:	83 ec 0c             	sub    $0xc,%esp
  802436:	25 07 0e 00 00       	and    $0xe07,%eax
  80243b:	50                   	push   %eax
  80243c:	57                   	push   %edi
  80243d:	6a 00                	push   $0x0
  80243f:	53                   	push   %ebx
  802440:	6a 00                	push   $0x0
  802442:	e8 4f f4 ff ff       	call   801896 <sys_page_map>
  802447:	89 c3                	mov    %eax,%ebx
  802449:	83 c4 20             	add    $0x20,%esp
  80244c:	85 c0                	test   %eax,%eax
  80244e:	79 a3                	jns    8023f3 <dup+0x74>
	sys_page_unmap(0, newfd);
  802450:	83 ec 08             	sub    $0x8,%esp
  802453:	56                   	push   %esi
  802454:	6a 00                	push   $0x0
  802456:	e8 7d f4 ff ff       	call   8018d8 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80245b:	83 c4 08             	add    $0x8,%esp
  80245e:	57                   	push   %edi
  80245f:	6a 00                	push   $0x0
  802461:	e8 72 f4 ff ff       	call   8018d8 <sys_page_unmap>
	return r;
  802466:	83 c4 10             	add    $0x10,%esp
  802469:	eb b7                	jmp    802422 <dup+0xa3>

0080246b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80246b:	55                   	push   %ebp
  80246c:	89 e5                	mov    %esp,%ebp
  80246e:	53                   	push   %ebx
  80246f:	83 ec 1c             	sub    $0x1c,%esp
  802472:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802475:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802478:	50                   	push   %eax
  802479:	53                   	push   %ebx
  80247a:	e8 7c fd ff ff       	call   8021fb <fd_lookup>
  80247f:	83 c4 10             	add    $0x10,%esp
  802482:	85 c0                	test   %eax,%eax
  802484:	78 3f                	js     8024c5 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802486:	83 ec 08             	sub    $0x8,%esp
  802489:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80248c:	50                   	push   %eax
  80248d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802490:	ff 30                	pushl  (%eax)
  802492:	e8 b4 fd ff ff       	call   80224b <dev_lookup>
  802497:	83 c4 10             	add    $0x10,%esp
  80249a:	85 c0                	test   %eax,%eax
  80249c:	78 27                	js     8024c5 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80249e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024a1:	8b 42 08             	mov    0x8(%edx),%eax
  8024a4:	83 e0 03             	and    $0x3,%eax
  8024a7:	83 f8 01             	cmp    $0x1,%eax
  8024aa:	74 1e                	je     8024ca <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8024ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024af:	8b 40 08             	mov    0x8(%eax),%eax
  8024b2:	85 c0                	test   %eax,%eax
  8024b4:	74 35                	je     8024eb <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8024b6:	83 ec 04             	sub    $0x4,%esp
  8024b9:	ff 75 10             	pushl  0x10(%ebp)
  8024bc:	ff 75 0c             	pushl  0xc(%ebp)
  8024bf:	52                   	push   %edx
  8024c0:	ff d0                	call   *%eax
  8024c2:	83 c4 10             	add    $0x10,%esp
}
  8024c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024c8:	c9                   	leave  
  8024c9:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8024ca:	a1 28 64 80 00       	mov    0x806428,%eax
  8024cf:	8b 40 48             	mov    0x48(%eax),%eax
  8024d2:	83 ec 04             	sub    $0x4,%esp
  8024d5:	53                   	push   %ebx
  8024d6:	50                   	push   %eax
  8024d7:	68 b5 44 80 00       	push   $0x8044b5
  8024dc:	e8 31 e7 ff ff       	call   800c12 <cprintf>
		return -E_INVAL;
  8024e1:	83 c4 10             	add    $0x10,%esp
  8024e4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024e9:	eb da                	jmp    8024c5 <read+0x5a>
		return -E_NOT_SUPP;
  8024eb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8024f0:	eb d3                	jmp    8024c5 <read+0x5a>

008024f2 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8024f2:	55                   	push   %ebp
  8024f3:	89 e5                	mov    %esp,%ebp
  8024f5:	57                   	push   %edi
  8024f6:	56                   	push   %esi
  8024f7:	53                   	push   %ebx
  8024f8:	83 ec 0c             	sub    $0xc,%esp
  8024fb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8024fe:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802501:	bb 00 00 00 00       	mov    $0x0,%ebx
  802506:	39 f3                	cmp    %esi,%ebx
  802508:	73 23                	jae    80252d <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80250a:	83 ec 04             	sub    $0x4,%esp
  80250d:	89 f0                	mov    %esi,%eax
  80250f:	29 d8                	sub    %ebx,%eax
  802511:	50                   	push   %eax
  802512:	89 d8                	mov    %ebx,%eax
  802514:	03 45 0c             	add    0xc(%ebp),%eax
  802517:	50                   	push   %eax
  802518:	57                   	push   %edi
  802519:	e8 4d ff ff ff       	call   80246b <read>
		if (m < 0)
  80251e:	83 c4 10             	add    $0x10,%esp
  802521:	85 c0                	test   %eax,%eax
  802523:	78 06                	js     80252b <readn+0x39>
			return m;
		if (m == 0)
  802525:	74 06                	je     80252d <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  802527:	01 c3                	add    %eax,%ebx
  802529:	eb db                	jmp    802506 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80252b:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80252d:	89 d8                	mov    %ebx,%eax
  80252f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802532:	5b                   	pop    %ebx
  802533:	5e                   	pop    %esi
  802534:	5f                   	pop    %edi
  802535:	5d                   	pop    %ebp
  802536:	c3                   	ret    

00802537 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802537:	55                   	push   %ebp
  802538:	89 e5                	mov    %esp,%ebp
  80253a:	53                   	push   %ebx
  80253b:	83 ec 1c             	sub    $0x1c,%esp
  80253e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802541:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802544:	50                   	push   %eax
  802545:	53                   	push   %ebx
  802546:	e8 b0 fc ff ff       	call   8021fb <fd_lookup>
  80254b:	83 c4 10             	add    $0x10,%esp
  80254e:	85 c0                	test   %eax,%eax
  802550:	78 3a                	js     80258c <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802552:	83 ec 08             	sub    $0x8,%esp
  802555:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802558:	50                   	push   %eax
  802559:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255c:	ff 30                	pushl  (%eax)
  80255e:	e8 e8 fc ff ff       	call   80224b <dev_lookup>
  802563:	83 c4 10             	add    $0x10,%esp
  802566:	85 c0                	test   %eax,%eax
  802568:	78 22                	js     80258c <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80256a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80256d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802571:	74 1e                	je     802591 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802573:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802576:	8b 52 0c             	mov    0xc(%edx),%edx
  802579:	85 d2                	test   %edx,%edx
  80257b:	74 35                	je     8025b2 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80257d:	83 ec 04             	sub    $0x4,%esp
  802580:	ff 75 10             	pushl  0x10(%ebp)
  802583:	ff 75 0c             	pushl  0xc(%ebp)
  802586:	50                   	push   %eax
  802587:	ff d2                	call   *%edx
  802589:	83 c4 10             	add    $0x10,%esp
}
  80258c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80258f:	c9                   	leave  
  802590:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802591:	a1 28 64 80 00       	mov    0x806428,%eax
  802596:	8b 40 48             	mov    0x48(%eax),%eax
  802599:	83 ec 04             	sub    $0x4,%esp
  80259c:	53                   	push   %ebx
  80259d:	50                   	push   %eax
  80259e:	68 d1 44 80 00       	push   $0x8044d1
  8025a3:	e8 6a e6 ff ff       	call   800c12 <cprintf>
		return -E_INVAL;
  8025a8:	83 c4 10             	add    $0x10,%esp
  8025ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025b0:	eb da                	jmp    80258c <write+0x55>
		return -E_NOT_SUPP;
  8025b2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8025b7:	eb d3                	jmp    80258c <write+0x55>

008025b9 <seek>:

int
seek(int fdnum, off_t offset)
{
  8025b9:	55                   	push   %ebp
  8025ba:	89 e5                	mov    %esp,%ebp
  8025bc:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025c2:	50                   	push   %eax
  8025c3:	ff 75 08             	pushl  0x8(%ebp)
  8025c6:	e8 30 fc ff ff       	call   8021fb <fd_lookup>
  8025cb:	83 c4 10             	add    $0x10,%esp
  8025ce:	85 c0                	test   %eax,%eax
  8025d0:	78 0e                	js     8025e0 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8025d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d8:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8025db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025e0:	c9                   	leave  
  8025e1:	c3                   	ret    

008025e2 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8025e2:	55                   	push   %ebp
  8025e3:	89 e5                	mov    %esp,%ebp
  8025e5:	53                   	push   %ebx
  8025e6:	83 ec 1c             	sub    $0x1c,%esp
  8025e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025ec:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8025ef:	50                   	push   %eax
  8025f0:	53                   	push   %ebx
  8025f1:	e8 05 fc ff ff       	call   8021fb <fd_lookup>
  8025f6:	83 c4 10             	add    $0x10,%esp
  8025f9:	85 c0                	test   %eax,%eax
  8025fb:	78 37                	js     802634 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025fd:	83 ec 08             	sub    $0x8,%esp
  802600:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802603:	50                   	push   %eax
  802604:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802607:	ff 30                	pushl  (%eax)
  802609:	e8 3d fc ff ff       	call   80224b <dev_lookup>
  80260e:	83 c4 10             	add    $0x10,%esp
  802611:	85 c0                	test   %eax,%eax
  802613:	78 1f                	js     802634 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802615:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802618:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80261c:	74 1b                	je     802639 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80261e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802621:	8b 52 18             	mov    0x18(%edx),%edx
  802624:	85 d2                	test   %edx,%edx
  802626:	74 32                	je     80265a <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  802628:	83 ec 08             	sub    $0x8,%esp
  80262b:	ff 75 0c             	pushl  0xc(%ebp)
  80262e:	50                   	push   %eax
  80262f:	ff d2                	call   *%edx
  802631:	83 c4 10             	add    $0x10,%esp
}
  802634:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802637:	c9                   	leave  
  802638:	c3                   	ret    
			thisenv->env_id, fdnum);
  802639:	a1 28 64 80 00       	mov    0x806428,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80263e:	8b 40 48             	mov    0x48(%eax),%eax
  802641:	83 ec 04             	sub    $0x4,%esp
  802644:	53                   	push   %ebx
  802645:	50                   	push   %eax
  802646:	68 94 44 80 00       	push   $0x804494
  80264b:	e8 c2 e5 ff ff       	call   800c12 <cprintf>
		return -E_INVAL;
  802650:	83 c4 10             	add    $0x10,%esp
  802653:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802658:	eb da                	jmp    802634 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80265a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80265f:	eb d3                	jmp    802634 <ftruncate+0x52>

00802661 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802661:	55                   	push   %ebp
  802662:	89 e5                	mov    %esp,%ebp
  802664:	53                   	push   %ebx
  802665:	83 ec 1c             	sub    $0x1c,%esp
  802668:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80266b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80266e:	50                   	push   %eax
  80266f:	ff 75 08             	pushl  0x8(%ebp)
  802672:	e8 84 fb ff ff       	call   8021fb <fd_lookup>
  802677:	83 c4 10             	add    $0x10,%esp
  80267a:	85 c0                	test   %eax,%eax
  80267c:	78 4b                	js     8026c9 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80267e:	83 ec 08             	sub    $0x8,%esp
  802681:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802684:	50                   	push   %eax
  802685:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802688:	ff 30                	pushl  (%eax)
  80268a:	e8 bc fb ff ff       	call   80224b <dev_lookup>
  80268f:	83 c4 10             	add    $0x10,%esp
  802692:	85 c0                	test   %eax,%eax
  802694:	78 33                	js     8026c9 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  802696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802699:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80269d:	74 2f                	je     8026ce <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80269f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8026a2:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8026a9:	00 00 00 
	stat->st_isdir = 0;
  8026ac:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8026b3:	00 00 00 
	stat->st_dev = dev;
  8026b6:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8026bc:	83 ec 08             	sub    $0x8,%esp
  8026bf:	53                   	push   %ebx
  8026c0:	ff 75 f0             	pushl  -0x10(%ebp)
  8026c3:	ff 50 14             	call   *0x14(%eax)
  8026c6:	83 c4 10             	add    $0x10,%esp
}
  8026c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026cc:	c9                   	leave  
  8026cd:	c3                   	ret    
		return -E_NOT_SUPP;
  8026ce:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8026d3:	eb f4                	jmp    8026c9 <fstat+0x68>

008026d5 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8026d5:	55                   	push   %ebp
  8026d6:	89 e5                	mov    %esp,%ebp
  8026d8:	56                   	push   %esi
  8026d9:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8026da:	83 ec 08             	sub    $0x8,%esp
  8026dd:	6a 00                	push   $0x0
  8026df:	ff 75 08             	pushl  0x8(%ebp)
  8026e2:	e8 22 02 00 00       	call   802909 <open>
  8026e7:	89 c3                	mov    %eax,%ebx
  8026e9:	83 c4 10             	add    $0x10,%esp
  8026ec:	85 c0                	test   %eax,%eax
  8026ee:	78 1b                	js     80270b <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8026f0:	83 ec 08             	sub    $0x8,%esp
  8026f3:	ff 75 0c             	pushl  0xc(%ebp)
  8026f6:	50                   	push   %eax
  8026f7:	e8 65 ff ff ff       	call   802661 <fstat>
  8026fc:	89 c6                	mov    %eax,%esi
	close(fd);
  8026fe:	89 1c 24             	mov    %ebx,(%esp)
  802701:	e8 27 fc ff ff       	call   80232d <close>
	return r;
  802706:	83 c4 10             	add    $0x10,%esp
  802709:	89 f3                	mov    %esi,%ebx
}
  80270b:	89 d8                	mov    %ebx,%eax
  80270d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802710:	5b                   	pop    %ebx
  802711:	5e                   	pop    %esi
  802712:	5d                   	pop    %ebp
  802713:	c3                   	ret    

00802714 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802714:	55                   	push   %ebp
  802715:	89 e5                	mov    %esp,%ebp
  802717:	56                   	push   %esi
  802718:	53                   	push   %ebx
  802719:	89 c6                	mov    %eax,%esi
  80271b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80271d:	83 3d 20 64 80 00 00 	cmpl   $0x0,0x806420
  802724:	74 27                	je     80274d <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802726:	6a 07                	push   $0x7
  802728:	68 00 70 80 00       	push   $0x807000
  80272d:	56                   	push   %esi
  80272e:	ff 35 20 64 80 00    	pushl  0x806420
  802734:	e8 ab 12 00 00       	call   8039e4 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  802739:	83 c4 0c             	add    $0xc,%esp
  80273c:	6a 00                	push   $0x0
  80273e:	53                   	push   %ebx
  80273f:	6a 00                	push   $0x0
  802741:	e8 35 12 00 00       	call   80397b <ipc_recv>
}
  802746:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802749:	5b                   	pop    %ebx
  80274a:	5e                   	pop    %esi
  80274b:	5d                   	pop    %ebp
  80274c:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80274d:	83 ec 0c             	sub    $0xc,%esp
  802750:	6a 01                	push   $0x1
  802752:	e8 e5 12 00 00       	call   803a3c <ipc_find_env>
  802757:	a3 20 64 80 00       	mov    %eax,0x806420
  80275c:	83 c4 10             	add    $0x10,%esp
  80275f:	eb c5                	jmp    802726 <fsipc+0x12>

00802761 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802761:	55                   	push   %ebp
  802762:	89 e5                	mov    %esp,%ebp
  802764:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802767:	8b 45 08             	mov    0x8(%ebp),%eax
  80276a:	8b 40 0c             	mov    0xc(%eax),%eax
  80276d:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  802772:	8b 45 0c             	mov    0xc(%ebp),%eax
  802775:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80277a:	ba 00 00 00 00       	mov    $0x0,%edx
  80277f:	b8 02 00 00 00       	mov    $0x2,%eax
  802784:	e8 8b ff ff ff       	call   802714 <fsipc>
}
  802789:	c9                   	leave  
  80278a:	c3                   	ret    

0080278b <devfile_flush>:
{
  80278b:	55                   	push   %ebp
  80278c:	89 e5                	mov    %esp,%ebp
  80278e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802791:	8b 45 08             	mov    0x8(%ebp),%eax
  802794:	8b 40 0c             	mov    0xc(%eax),%eax
  802797:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  80279c:	ba 00 00 00 00       	mov    $0x0,%edx
  8027a1:	b8 06 00 00 00       	mov    $0x6,%eax
  8027a6:	e8 69 ff ff ff       	call   802714 <fsipc>
}
  8027ab:	c9                   	leave  
  8027ac:	c3                   	ret    

008027ad <devfile_stat>:
{
  8027ad:	55                   	push   %ebp
  8027ae:	89 e5                	mov    %esp,%ebp
  8027b0:	53                   	push   %ebx
  8027b1:	83 ec 04             	sub    $0x4,%esp
  8027b4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8027b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8027bd:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8027c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8027c7:	b8 05 00 00 00       	mov    $0x5,%eax
  8027cc:	e8 43 ff ff ff       	call   802714 <fsipc>
  8027d1:	85 c0                	test   %eax,%eax
  8027d3:	78 2c                	js     802801 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8027d5:	83 ec 08             	sub    $0x8,%esp
  8027d8:	68 00 70 80 00       	push   $0x807000
  8027dd:	53                   	push   %ebx
  8027de:	e8 7e ec ff ff       	call   801461 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8027e3:	a1 80 70 80 00       	mov    0x807080,%eax
  8027e8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8027ee:	a1 84 70 80 00       	mov    0x807084,%eax
  8027f3:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8027f9:	83 c4 10             	add    $0x10,%esp
  8027fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802801:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802804:	c9                   	leave  
  802805:	c3                   	ret    

00802806 <devfile_write>:
{
  802806:	55                   	push   %ebp
  802807:	89 e5                	mov    %esp,%ebp
  802809:	53                   	push   %ebx
  80280a:	83 ec 08             	sub    $0x8,%esp
  80280d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802810:	8b 45 08             	mov    0x8(%ebp),%eax
  802813:	8b 40 0c             	mov    0xc(%eax),%eax
  802816:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.write.req_n = n;
  80281b:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802821:	53                   	push   %ebx
  802822:	ff 75 0c             	pushl  0xc(%ebp)
  802825:	68 08 70 80 00       	push   $0x807008
  80282a:	e8 22 ee ff ff       	call   801651 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80282f:	ba 00 00 00 00       	mov    $0x0,%edx
  802834:	b8 04 00 00 00       	mov    $0x4,%eax
  802839:	e8 d6 fe ff ff       	call   802714 <fsipc>
  80283e:	83 c4 10             	add    $0x10,%esp
  802841:	85 c0                	test   %eax,%eax
  802843:	78 0b                	js     802850 <devfile_write+0x4a>
	assert(r <= n);
  802845:	39 d8                	cmp    %ebx,%eax
  802847:	77 0c                	ja     802855 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  802849:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80284e:	7f 1e                	jg     80286e <devfile_write+0x68>
}
  802850:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802853:	c9                   	leave  
  802854:	c3                   	ret    
	assert(r <= n);
  802855:	68 04 45 80 00       	push   $0x804504
  80285a:	68 6f 3e 80 00       	push   $0x803e6f
  80285f:	68 98 00 00 00       	push   $0x98
  802864:	68 0b 45 80 00       	push   $0x80450b
  802869:	e8 ae e2 ff ff       	call   800b1c <_panic>
	assert(r <= PGSIZE);
  80286e:	68 16 45 80 00       	push   $0x804516
  802873:	68 6f 3e 80 00       	push   $0x803e6f
  802878:	68 99 00 00 00       	push   $0x99
  80287d:	68 0b 45 80 00       	push   $0x80450b
  802882:	e8 95 e2 ff ff       	call   800b1c <_panic>

00802887 <devfile_read>:
{
  802887:	55                   	push   %ebp
  802888:	89 e5                	mov    %esp,%ebp
  80288a:	56                   	push   %esi
  80288b:	53                   	push   %ebx
  80288c:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80288f:	8b 45 08             	mov    0x8(%ebp),%eax
  802892:	8b 40 0c             	mov    0xc(%eax),%eax
  802895:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  80289a:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8028a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8028a5:	b8 03 00 00 00       	mov    $0x3,%eax
  8028aa:	e8 65 fe ff ff       	call   802714 <fsipc>
  8028af:	89 c3                	mov    %eax,%ebx
  8028b1:	85 c0                	test   %eax,%eax
  8028b3:	78 1f                	js     8028d4 <devfile_read+0x4d>
	assert(r <= n);
  8028b5:	39 f0                	cmp    %esi,%eax
  8028b7:	77 24                	ja     8028dd <devfile_read+0x56>
	assert(r <= PGSIZE);
  8028b9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8028be:	7f 33                	jg     8028f3 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8028c0:	83 ec 04             	sub    $0x4,%esp
  8028c3:	50                   	push   %eax
  8028c4:	68 00 70 80 00       	push   $0x807000
  8028c9:	ff 75 0c             	pushl  0xc(%ebp)
  8028cc:	e8 1e ed ff ff       	call   8015ef <memmove>
	return r;
  8028d1:	83 c4 10             	add    $0x10,%esp
}
  8028d4:	89 d8                	mov    %ebx,%eax
  8028d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8028d9:	5b                   	pop    %ebx
  8028da:	5e                   	pop    %esi
  8028db:	5d                   	pop    %ebp
  8028dc:	c3                   	ret    
	assert(r <= n);
  8028dd:	68 04 45 80 00       	push   $0x804504
  8028e2:	68 6f 3e 80 00       	push   $0x803e6f
  8028e7:	6a 7c                	push   $0x7c
  8028e9:	68 0b 45 80 00       	push   $0x80450b
  8028ee:	e8 29 e2 ff ff       	call   800b1c <_panic>
	assert(r <= PGSIZE);
  8028f3:	68 16 45 80 00       	push   $0x804516
  8028f8:	68 6f 3e 80 00       	push   $0x803e6f
  8028fd:	6a 7d                	push   $0x7d
  8028ff:	68 0b 45 80 00       	push   $0x80450b
  802904:	e8 13 e2 ff ff       	call   800b1c <_panic>

00802909 <open>:
{
  802909:	55                   	push   %ebp
  80290a:	89 e5                	mov    %esp,%ebp
  80290c:	56                   	push   %esi
  80290d:	53                   	push   %ebx
  80290e:	83 ec 1c             	sub    $0x1c,%esp
  802911:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  802914:	56                   	push   %esi
  802915:	e8 0e eb ff ff       	call   801428 <strlen>
  80291a:	83 c4 10             	add    $0x10,%esp
  80291d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802922:	7f 6c                	jg     802990 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  802924:	83 ec 0c             	sub    $0xc,%esp
  802927:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80292a:	50                   	push   %eax
  80292b:	e8 79 f8 ff ff       	call   8021a9 <fd_alloc>
  802930:	89 c3                	mov    %eax,%ebx
  802932:	83 c4 10             	add    $0x10,%esp
  802935:	85 c0                	test   %eax,%eax
  802937:	78 3c                	js     802975 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  802939:	83 ec 08             	sub    $0x8,%esp
  80293c:	56                   	push   %esi
  80293d:	68 00 70 80 00       	push   $0x807000
  802942:	e8 1a eb ff ff       	call   801461 <strcpy>
	fsipcbuf.open.req_omode = mode;
  802947:	8b 45 0c             	mov    0xc(%ebp),%eax
  80294a:	a3 00 74 80 00       	mov    %eax,0x807400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80294f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802952:	b8 01 00 00 00       	mov    $0x1,%eax
  802957:	e8 b8 fd ff ff       	call   802714 <fsipc>
  80295c:	89 c3                	mov    %eax,%ebx
  80295e:	83 c4 10             	add    $0x10,%esp
  802961:	85 c0                	test   %eax,%eax
  802963:	78 19                	js     80297e <open+0x75>
	return fd2num(fd);
  802965:	83 ec 0c             	sub    $0xc,%esp
  802968:	ff 75 f4             	pushl  -0xc(%ebp)
  80296b:	e8 12 f8 ff ff       	call   802182 <fd2num>
  802970:	89 c3                	mov    %eax,%ebx
  802972:	83 c4 10             	add    $0x10,%esp
}
  802975:	89 d8                	mov    %ebx,%eax
  802977:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80297a:	5b                   	pop    %ebx
  80297b:	5e                   	pop    %esi
  80297c:	5d                   	pop    %ebp
  80297d:	c3                   	ret    
		fd_close(fd, 0);
  80297e:	83 ec 08             	sub    $0x8,%esp
  802981:	6a 00                	push   $0x0
  802983:	ff 75 f4             	pushl  -0xc(%ebp)
  802986:	e8 1b f9 ff ff       	call   8022a6 <fd_close>
		return r;
  80298b:	83 c4 10             	add    $0x10,%esp
  80298e:	eb e5                	jmp    802975 <open+0x6c>
		return -E_BAD_PATH;
  802990:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  802995:	eb de                	jmp    802975 <open+0x6c>

00802997 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802997:	55                   	push   %ebp
  802998:	89 e5                	mov    %esp,%ebp
  80299a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80299d:	ba 00 00 00 00       	mov    $0x0,%edx
  8029a2:	b8 08 00 00 00       	mov    $0x8,%eax
  8029a7:	e8 68 fd ff ff       	call   802714 <fsipc>
}
  8029ac:	c9                   	leave  
  8029ad:	c3                   	ret    

008029ae <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  8029ae:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8029b2:	7f 01                	jg     8029b5 <writebuf+0x7>
  8029b4:	c3                   	ret    
{
  8029b5:	55                   	push   %ebp
  8029b6:	89 e5                	mov    %esp,%ebp
  8029b8:	53                   	push   %ebx
  8029b9:	83 ec 08             	sub    $0x8,%esp
  8029bc:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  8029be:	ff 70 04             	pushl  0x4(%eax)
  8029c1:	8d 40 10             	lea    0x10(%eax),%eax
  8029c4:	50                   	push   %eax
  8029c5:	ff 33                	pushl  (%ebx)
  8029c7:	e8 6b fb ff ff       	call   802537 <write>
		if (result > 0)
  8029cc:	83 c4 10             	add    $0x10,%esp
  8029cf:	85 c0                	test   %eax,%eax
  8029d1:	7e 03                	jle    8029d6 <writebuf+0x28>
			b->result += result;
  8029d3:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8029d6:	39 43 04             	cmp    %eax,0x4(%ebx)
  8029d9:	74 0d                	je     8029e8 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  8029db:	85 c0                	test   %eax,%eax
  8029dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8029e2:	0f 4f c2             	cmovg  %edx,%eax
  8029e5:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8029e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8029eb:	c9                   	leave  
  8029ec:	c3                   	ret    

008029ed <putch>:

static void
putch(int ch, void *thunk)
{
  8029ed:	55                   	push   %ebp
  8029ee:	89 e5                	mov    %esp,%ebp
  8029f0:	53                   	push   %ebx
  8029f1:	83 ec 04             	sub    $0x4,%esp
  8029f4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8029f7:	8b 53 04             	mov    0x4(%ebx),%edx
  8029fa:	8d 42 01             	lea    0x1(%edx),%eax
  8029fd:	89 43 04             	mov    %eax,0x4(%ebx)
  802a00:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802a03:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  802a07:	3d 00 01 00 00       	cmp    $0x100,%eax
  802a0c:	74 06                	je     802a14 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  802a0e:	83 c4 04             	add    $0x4,%esp
  802a11:	5b                   	pop    %ebx
  802a12:	5d                   	pop    %ebp
  802a13:	c3                   	ret    
		writebuf(b);
  802a14:	89 d8                	mov    %ebx,%eax
  802a16:	e8 93 ff ff ff       	call   8029ae <writebuf>
		b->idx = 0;
  802a1b:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  802a22:	eb ea                	jmp    802a0e <putch+0x21>

00802a24 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802a24:	55                   	push   %ebp
  802a25:	89 e5                	mov    %esp,%ebp
  802a27:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  802a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a30:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  802a36:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  802a3d:	00 00 00 
	b.result = 0;
  802a40:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  802a47:	00 00 00 
	b.error = 1;
  802a4a:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  802a51:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802a54:	ff 75 10             	pushl  0x10(%ebp)
  802a57:	ff 75 0c             	pushl  0xc(%ebp)
  802a5a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  802a60:	50                   	push   %eax
  802a61:	68 ed 29 80 00       	push   $0x8029ed
  802a66:	e8 d4 e2 ff ff       	call   800d3f <vprintfmt>
	if (b.idx > 0)
  802a6b:	83 c4 10             	add    $0x10,%esp
  802a6e:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  802a75:	7f 11                	jg     802a88 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  802a77:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  802a7d:	85 c0                	test   %eax,%eax
  802a7f:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  802a86:	c9                   	leave  
  802a87:	c3                   	ret    
		writebuf(&b);
  802a88:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  802a8e:	e8 1b ff ff ff       	call   8029ae <writebuf>
  802a93:	eb e2                	jmp    802a77 <vfprintf+0x53>

00802a95 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802a95:	55                   	push   %ebp
  802a96:	89 e5                	mov    %esp,%ebp
  802a98:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802a9b:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  802a9e:	50                   	push   %eax
  802a9f:	ff 75 0c             	pushl  0xc(%ebp)
  802aa2:	ff 75 08             	pushl  0x8(%ebp)
  802aa5:	e8 7a ff ff ff       	call   802a24 <vfprintf>
	va_end(ap);

	return cnt;
}
  802aaa:	c9                   	leave  
  802aab:	c3                   	ret    

00802aac <printf>:

int
printf(const char *fmt, ...)
{
  802aac:	55                   	push   %ebp
  802aad:	89 e5                	mov    %esp,%ebp
  802aaf:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802ab2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  802ab5:	50                   	push   %eax
  802ab6:	ff 75 08             	pushl  0x8(%ebp)
  802ab9:	6a 01                	push   $0x1
  802abb:	e8 64 ff ff ff       	call   802a24 <vfprintf>
	va_end(ap);

	return cnt;
}
  802ac0:	c9                   	leave  
  802ac1:	c3                   	ret    

00802ac2 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802ac2:	55                   	push   %ebp
  802ac3:	89 e5                	mov    %esp,%ebp
  802ac5:	57                   	push   %edi
  802ac6:	56                   	push   %esi
  802ac7:	53                   	push   %ebx
  802ac8:	81 ec 94 02 00 00    	sub    $0x294,%esp
	cprintf("in %s\n", __FUNCTION__);
  802ace:	68 f8 45 80 00       	push   $0x8045f8
  802ad3:	68 91 3f 80 00       	push   $0x803f91
  802ad8:	e8 35 e1 ff ff       	call   800c12 <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802add:	83 c4 08             	add    $0x8,%esp
  802ae0:	6a 00                	push   $0x0
  802ae2:	ff 75 08             	pushl  0x8(%ebp)
  802ae5:	e8 1f fe ff ff       	call   802909 <open>
  802aea:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802af0:	83 c4 10             	add    $0x10,%esp
  802af3:	85 c0                	test   %eax,%eax
  802af5:	0f 88 0b 05 00 00    	js     803006 <spawn+0x544>
  802afb:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802afd:	83 ec 04             	sub    $0x4,%esp
  802b00:	68 00 02 00 00       	push   $0x200
  802b05:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  802b0b:	50                   	push   %eax
  802b0c:	51                   	push   %ecx
  802b0d:	e8 e0 f9 ff ff       	call   8024f2 <readn>
  802b12:	83 c4 10             	add    $0x10,%esp
  802b15:	3d 00 02 00 00       	cmp    $0x200,%eax
  802b1a:	75 75                	jne    802b91 <spawn+0xcf>
	    || elf->e_magic != ELF_MAGIC) {
  802b1c:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  802b23:	45 4c 46 
  802b26:	75 69                	jne    802b91 <spawn+0xcf>
  802b28:	b8 07 00 00 00       	mov    $0x7,%eax
  802b2d:	cd 30                	int    $0x30
  802b2f:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  802b35:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802b3b:	85 c0                	test   %eax,%eax
  802b3d:	0f 88 b7 04 00 00    	js     802ffa <spawn+0x538>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802b43:	25 ff 03 00 00       	and    $0x3ff,%eax
  802b48:	69 f0 84 00 00 00    	imul   $0x84,%eax,%esi
  802b4e:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  802b54:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  802b5a:	b9 11 00 00 00       	mov    $0x11,%ecx
  802b5f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  802b61:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802b67:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
	cprintf("in %s\n", __FUNCTION__);
  802b6d:	83 ec 08             	sub    $0x8,%esp
  802b70:	68 ec 45 80 00       	push   $0x8045ec
  802b75:	68 91 3f 80 00       	push   $0x803f91
  802b7a:	e8 93 e0 ff ff       	call   800c12 <cprintf>
  802b7f:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802b82:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  802b87:	be 00 00 00 00       	mov    $0x0,%esi
  802b8c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802b8f:	eb 4b                	jmp    802bdc <spawn+0x11a>
		close(fd);
  802b91:	83 ec 0c             	sub    $0xc,%esp
  802b94:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802b9a:	e8 8e f7 ff ff       	call   80232d <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802b9f:	83 c4 0c             	add    $0xc,%esp
  802ba2:	68 7f 45 4c 46       	push   $0x464c457f
  802ba7:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  802bad:	68 22 45 80 00       	push   $0x804522
  802bb2:	e8 5b e0 ff ff       	call   800c12 <cprintf>
		return -E_NOT_EXEC;
  802bb7:	83 c4 10             	add    $0x10,%esp
  802bba:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  802bc1:	ff ff ff 
  802bc4:	e9 3d 04 00 00       	jmp    803006 <spawn+0x544>
		string_size += strlen(argv[argc]) + 1;
  802bc9:	83 ec 0c             	sub    $0xc,%esp
  802bcc:	50                   	push   %eax
  802bcd:	e8 56 e8 ff ff       	call   801428 <strlen>
  802bd2:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  802bd6:	83 c3 01             	add    $0x1,%ebx
  802bd9:	83 c4 10             	add    $0x10,%esp
  802bdc:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  802be3:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  802be6:	85 c0                	test   %eax,%eax
  802be8:	75 df                	jne    802bc9 <spawn+0x107>
  802bea:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  802bf0:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  802bf6:	bf 00 10 40 00       	mov    $0x401000,%edi
  802bfb:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802bfd:	89 fa                	mov    %edi,%edx
  802bff:	83 e2 fc             	and    $0xfffffffc,%edx
  802c02:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  802c09:	29 c2                	sub    %eax,%edx
  802c0b:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802c11:	8d 42 f8             	lea    -0x8(%edx),%eax
  802c14:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802c19:	0f 86 0a 04 00 00    	jbe    803029 <spawn+0x567>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802c1f:	83 ec 04             	sub    $0x4,%esp
  802c22:	6a 07                	push   $0x7
  802c24:	68 00 00 40 00       	push   $0x400000
  802c29:	6a 00                	push   $0x0
  802c2b:	e8 23 ec ff ff       	call   801853 <sys_page_alloc>
  802c30:	83 c4 10             	add    $0x10,%esp
  802c33:	85 c0                	test   %eax,%eax
  802c35:	0f 88 f3 03 00 00    	js     80302e <spawn+0x56c>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802c3b:	be 00 00 00 00       	mov    $0x0,%esi
  802c40:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  802c46:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802c49:	eb 30                	jmp    802c7b <spawn+0x1b9>
		argv_store[i] = UTEMP2USTACK(string_store);
  802c4b:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802c51:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  802c57:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  802c5a:	83 ec 08             	sub    $0x8,%esp
  802c5d:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802c60:	57                   	push   %edi
  802c61:	e8 fb e7 ff ff       	call   801461 <strcpy>
		string_store += strlen(argv[i]) + 1;
  802c66:	83 c4 04             	add    $0x4,%esp
  802c69:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802c6c:	e8 b7 e7 ff ff       	call   801428 <strlen>
  802c71:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  802c75:	83 c6 01             	add    $0x1,%esi
  802c78:	83 c4 10             	add    $0x10,%esp
  802c7b:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  802c81:	7f c8                	jg     802c4b <spawn+0x189>
	}
	argv_store[argc] = 0;
  802c83:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802c89:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  802c8f:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  802c96:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  802c9c:	0f 85 86 00 00 00    	jne    802d28 <spawn+0x266>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802ca2:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  802ca8:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  802cae:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  802cb1:	89 d0                	mov    %edx,%eax
  802cb3:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  802cb9:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802cbc:	2d 08 30 80 11       	sub    $0x11803008,%eax
  802cc1:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802cc7:	83 ec 0c             	sub    $0xc,%esp
  802cca:	6a 07                	push   $0x7
  802ccc:	68 00 d0 bf ee       	push   $0xeebfd000
  802cd1:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802cd7:	68 00 00 40 00       	push   $0x400000
  802cdc:	6a 00                	push   $0x0
  802cde:	e8 b3 eb ff ff       	call   801896 <sys_page_map>
  802ce3:	89 c3                	mov    %eax,%ebx
  802ce5:	83 c4 20             	add    $0x20,%esp
  802ce8:	85 c0                	test   %eax,%eax
  802cea:	0f 88 46 03 00 00    	js     803036 <spawn+0x574>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802cf0:	83 ec 08             	sub    $0x8,%esp
  802cf3:	68 00 00 40 00       	push   $0x400000
  802cf8:	6a 00                	push   $0x0
  802cfa:	e8 d9 eb ff ff       	call   8018d8 <sys_page_unmap>
  802cff:	89 c3                	mov    %eax,%ebx
  802d01:	83 c4 10             	add    $0x10,%esp
  802d04:	85 c0                	test   %eax,%eax
  802d06:	0f 88 2a 03 00 00    	js     803036 <spawn+0x574>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802d0c:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  802d12:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802d19:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  802d20:	00 00 00 
  802d23:	e9 4f 01 00 00       	jmp    802e77 <spawn+0x3b5>
	assert(string_store == (char*)UTEMP + PGSIZE);
  802d28:	68 a8 45 80 00       	push   $0x8045a8
  802d2d:	68 6f 3e 80 00       	push   $0x803e6f
  802d32:	68 f8 00 00 00       	push   $0xf8
  802d37:	68 3c 45 80 00       	push   $0x80453c
  802d3c:	e8 db dd ff ff       	call   800b1c <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802d41:	83 ec 04             	sub    $0x4,%esp
  802d44:	6a 07                	push   $0x7
  802d46:	68 00 00 40 00       	push   $0x400000
  802d4b:	6a 00                	push   $0x0
  802d4d:	e8 01 eb ff ff       	call   801853 <sys_page_alloc>
  802d52:	83 c4 10             	add    $0x10,%esp
  802d55:	85 c0                	test   %eax,%eax
  802d57:	0f 88 b7 02 00 00    	js     803014 <spawn+0x552>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802d5d:	83 ec 08             	sub    $0x8,%esp
  802d60:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802d66:	01 f0                	add    %esi,%eax
  802d68:	50                   	push   %eax
  802d69:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802d6f:	e8 45 f8 ff ff       	call   8025b9 <seek>
  802d74:	83 c4 10             	add    $0x10,%esp
  802d77:	85 c0                	test   %eax,%eax
  802d79:	0f 88 9c 02 00 00    	js     80301b <spawn+0x559>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802d7f:	83 ec 04             	sub    $0x4,%esp
  802d82:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802d88:	29 f0                	sub    %esi,%eax
  802d8a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802d8f:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802d94:	0f 47 c1             	cmova  %ecx,%eax
  802d97:	50                   	push   %eax
  802d98:	68 00 00 40 00       	push   $0x400000
  802d9d:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802da3:	e8 4a f7 ff ff       	call   8024f2 <readn>
  802da8:	83 c4 10             	add    $0x10,%esp
  802dab:	85 c0                	test   %eax,%eax
  802dad:	0f 88 6f 02 00 00    	js     803022 <spawn+0x560>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802db3:	83 ec 0c             	sub    $0xc,%esp
  802db6:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802dbc:	53                   	push   %ebx
  802dbd:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802dc3:	68 00 00 40 00       	push   $0x400000
  802dc8:	6a 00                	push   $0x0
  802dca:	e8 c7 ea ff ff       	call   801896 <sys_page_map>
  802dcf:	83 c4 20             	add    $0x20,%esp
  802dd2:	85 c0                	test   %eax,%eax
  802dd4:	78 7c                	js     802e52 <spawn+0x390>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  802dd6:	83 ec 08             	sub    $0x8,%esp
  802dd9:	68 00 00 40 00       	push   $0x400000
  802dde:	6a 00                	push   $0x0
  802de0:	e8 f3 ea ff ff       	call   8018d8 <sys_page_unmap>
  802de5:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  802de8:	81 c7 00 10 00 00    	add    $0x1000,%edi
  802dee:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802df4:	89 fe                	mov    %edi,%esi
  802df6:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  802dfc:	76 69                	jbe    802e67 <spawn+0x3a5>
		if (i >= filesz) {
  802dfe:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  802e04:	0f 87 37 ff ff ff    	ja     802d41 <spawn+0x27f>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802e0a:	83 ec 04             	sub    $0x4,%esp
  802e0d:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802e13:	53                   	push   %ebx
  802e14:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802e1a:	e8 34 ea ff ff       	call   801853 <sys_page_alloc>
  802e1f:	83 c4 10             	add    $0x10,%esp
  802e22:	85 c0                	test   %eax,%eax
  802e24:	79 c2                	jns    802de8 <spawn+0x326>
  802e26:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  802e28:	83 ec 0c             	sub    $0xc,%esp
  802e2b:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802e31:	e8 9e e9 ff ff       	call   8017d4 <sys_env_destroy>
	close(fd);
  802e36:	83 c4 04             	add    $0x4,%esp
  802e39:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802e3f:	e8 e9 f4 ff ff       	call   80232d <close>
	return r;
  802e44:	83 c4 10             	add    $0x10,%esp
  802e47:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  802e4d:	e9 b4 01 00 00       	jmp    803006 <spawn+0x544>
				panic("spawn: sys_page_map data: %e", r);
  802e52:	50                   	push   %eax
  802e53:	68 48 45 80 00       	push   $0x804548
  802e58:	68 2b 01 00 00       	push   $0x12b
  802e5d:	68 3c 45 80 00       	push   $0x80453c
  802e62:	e8 b5 dc ff ff       	call   800b1c <_panic>
  802e67:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802e6d:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  802e74:	83 c6 20             	add    $0x20,%esi
  802e77:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802e7e:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  802e84:	7e 6d                	jle    802ef3 <spawn+0x431>
		if (ph->p_type != ELF_PROG_LOAD)
  802e86:	83 3e 01             	cmpl   $0x1,(%esi)
  802e89:	75 e2                	jne    802e6d <spawn+0x3ab>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802e8b:	8b 46 18             	mov    0x18(%esi),%eax
  802e8e:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  802e91:	83 f8 01             	cmp    $0x1,%eax
  802e94:	19 c0                	sbb    %eax,%eax
  802e96:	83 e0 fe             	and    $0xfffffffe,%eax
  802e99:	83 c0 07             	add    $0x7,%eax
  802e9c:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802ea2:	8b 4e 04             	mov    0x4(%esi),%ecx
  802ea5:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  802eab:	8b 56 10             	mov    0x10(%esi),%edx
  802eae:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  802eb4:	8b 7e 14             	mov    0x14(%esi),%edi
  802eb7:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  802ebd:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  802ec0:	89 d8                	mov    %ebx,%eax
  802ec2:	25 ff 0f 00 00       	and    $0xfff,%eax
  802ec7:	74 1a                	je     802ee3 <spawn+0x421>
		va -= i;
  802ec9:	29 c3                	sub    %eax,%ebx
		memsz += i;
  802ecb:	01 c7                	add    %eax,%edi
  802ecd:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  802ed3:	01 c2                	add    %eax,%edx
  802ed5:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  802edb:	29 c1                	sub    %eax,%ecx
  802edd:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  802ee3:	bf 00 00 00 00       	mov    $0x0,%edi
  802ee8:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  802eee:	e9 01 ff ff ff       	jmp    802df4 <spawn+0x332>
	close(fd);
  802ef3:	83 ec 0c             	sub    $0xc,%esp
  802ef6:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802efc:	e8 2c f4 ff ff       	call   80232d <close>

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	cprintf("in %s\n", __FUNCTION__);
  802f01:	83 c4 08             	add    $0x8,%esp
  802f04:	68 d8 45 80 00       	push   $0x8045d8
  802f09:	68 91 3f 80 00       	push   $0x803f91
  802f0e:	e8 ff dc ff ff       	call   800c12 <cprintf>
  802f13:	83 c4 10             	add    $0x10,%esp
	int r;
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  802f16:	bb 00 00 80 00       	mov    $0x800000,%ebx
  802f1b:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  802f21:	eb 0e                	jmp    802f31 <spawn+0x46f>
  802f23:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802f29:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  802f2f:	74 5e                	je     802f8f <spawn+0x4cd>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_SHARE)) == (PTE_P | PTE_U | PTE_SHARE)))
  802f31:	89 d8                	mov    %ebx,%eax
  802f33:	c1 e8 16             	shr    $0x16,%eax
  802f36:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802f3d:	a8 01                	test   $0x1,%al
  802f3f:	74 e2                	je     802f23 <spawn+0x461>
  802f41:	89 da                	mov    %ebx,%edx
  802f43:	c1 ea 0c             	shr    $0xc,%edx
  802f46:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  802f4d:	25 05 04 00 00       	and    $0x405,%eax
  802f52:	3d 05 04 00 00       	cmp    $0x405,%eax
  802f57:	75 ca                	jne    802f23 <spawn+0x461>
			if((r = sys_page_map((envid_t)0, (void *)i, child, (void *)i, uvpt[PGNUM(i)] & PTE_SYSCALL)) < 0)
  802f59:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  802f60:	83 ec 0c             	sub    $0xc,%esp
  802f63:	25 07 0e 00 00       	and    $0xe07,%eax
  802f68:	50                   	push   %eax
  802f69:	53                   	push   %ebx
  802f6a:	56                   	push   %esi
  802f6b:	53                   	push   %ebx
  802f6c:	6a 00                	push   $0x0
  802f6e:	e8 23 e9 ff ff       	call   801896 <sys_page_map>
  802f73:	83 c4 20             	add    $0x20,%esp
  802f76:	85 c0                	test   %eax,%eax
  802f78:	79 a9                	jns    802f23 <spawn+0x461>
        		panic("sys_page_map: %e\n", r);
  802f7a:	50                   	push   %eax
  802f7b:	68 65 45 80 00       	push   $0x804565
  802f80:	68 3b 01 00 00       	push   $0x13b
  802f85:	68 3c 45 80 00       	push   $0x80453c
  802f8a:	e8 8d db ff ff       	call   800b1c <_panic>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802f8f:	83 ec 08             	sub    $0x8,%esp
  802f92:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802f98:	50                   	push   %eax
  802f99:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802f9f:	e8 b8 e9 ff ff       	call   80195c <sys_env_set_trapframe>
  802fa4:	83 c4 10             	add    $0x10,%esp
  802fa7:	85 c0                	test   %eax,%eax
  802fa9:	78 25                	js     802fd0 <spawn+0x50e>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802fab:	83 ec 08             	sub    $0x8,%esp
  802fae:	6a 02                	push   $0x2
  802fb0:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802fb6:	e8 5f e9 ff ff       	call   80191a <sys_env_set_status>
  802fbb:	83 c4 10             	add    $0x10,%esp
  802fbe:	85 c0                	test   %eax,%eax
  802fc0:	78 23                	js     802fe5 <spawn+0x523>
	return child;
  802fc2:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802fc8:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802fce:	eb 36                	jmp    803006 <spawn+0x544>
		panic("sys_env_set_trapframe: %e", r);
  802fd0:	50                   	push   %eax
  802fd1:	68 77 45 80 00       	push   $0x804577
  802fd6:	68 8a 00 00 00       	push   $0x8a
  802fdb:	68 3c 45 80 00       	push   $0x80453c
  802fe0:	e8 37 db ff ff       	call   800b1c <_panic>
		panic("sys_env_set_status: %e", r);
  802fe5:	50                   	push   %eax
  802fe6:	68 91 45 80 00       	push   $0x804591
  802feb:	68 8d 00 00 00       	push   $0x8d
  802ff0:	68 3c 45 80 00       	push   $0x80453c
  802ff5:	e8 22 db ff ff       	call   800b1c <_panic>
		return r;
  802ffa:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  803000:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  803006:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  80300c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80300f:	5b                   	pop    %ebx
  803010:	5e                   	pop    %esi
  803011:	5f                   	pop    %edi
  803012:	5d                   	pop    %ebp
  803013:	c3                   	ret    
  803014:	89 c7                	mov    %eax,%edi
  803016:	e9 0d fe ff ff       	jmp    802e28 <spawn+0x366>
  80301b:	89 c7                	mov    %eax,%edi
  80301d:	e9 06 fe ff ff       	jmp    802e28 <spawn+0x366>
  803022:	89 c7                	mov    %eax,%edi
  803024:	e9 ff fd ff ff       	jmp    802e28 <spawn+0x366>
		return -E_NO_MEM;
  803029:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  80302e:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  803034:	eb d0                	jmp    803006 <spawn+0x544>
	sys_page_unmap(0, UTEMP);
  803036:	83 ec 08             	sub    $0x8,%esp
  803039:	68 00 00 40 00       	push   $0x400000
  80303e:	6a 00                	push   $0x0
  803040:	e8 93 e8 ff ff       	call   8018d8 <sys_page_unmap>
  803045:	83 c4 10             	add    $0x10,%esp
  803048:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  80304e:	eb b6                	jmp    803006 <spawn+0x544>

00803050 <spawnl>:
{
  803050:	55                   	push   %ebp
  803051:	89 e5                	mov    %esp,%ebp
  803053:	57                   	push   %edi
  803054:	56                   	push   %esi
  803055:	53                   	push   %ebx
  803056:	83 ec 14             	sub    $0x14,%esp
	cprintf("in %s\n", __FUNCTION__);
  803059:	68 d0 45 80 00       	push   $0x8045d0
  80305e:	68 91 3f 80 00       	push   $0x803f91
  803063:	e8 aa db ff ff       	call   800c12 <cprintf>
	va_start(vl, arg0);
  803068:	8d 55 10             	lea    0x10(%ebp),%edx
	while(va_arg(vl, void *) != NULL)
  80306b:	83 c4 10             	add    $0x10,%esp
	int argc=0;
  80306e:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  803073:	8d 4a 04             	lea    0x4(%edx),%ecx
  803076:	83 3a 00             	cmpl   $0x0,(%edx)
  803079:	74 07                	je     803082 <spawnl+0x32>
		argc++;
  80307b:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  80307e:	89 ca                	mov    %ecx,%edx
  803080:	eb f1                	jmp    803073 <spawnl+0x23>
	const char *argv[argc+2];
  803082:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  803089:	83 e2 f0             	and    $0xfffffff0,%edx
  80308c:	29 d4                	sub    %edx,%esp
  80308e:	8d 54 24 03          	lea    0x3(%esp),%edx
  803092:	c1 ea 02             	shr    $0x2,%edx
  803095:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  80309c:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  80309e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8030a1:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  8030a8:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  8030af:	00 
	va_start(vl, arg0);
  8030b0:	8d 4d 10             	lea    0x10(%ebp),%ecx
  8030b3:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  8030b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8030ba:	eb 0b                	jmp    8030c7 <spawnl+0x77>
		argv[i+1] = va_arg(vl, const char *);
  8030bc:	83 c0 01             	add    $0x1,%eax
  8030bf:	8b 39                	mov    (%ecx),%edi
  8030c1:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  8030c4:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  8030c7:	39 d0                	cmp    %edx,%eax
  8030c9:	75 f1                	jne    8030bc <spawnl+0x6c>
	return spawn(prog, argv);
  8030cb:	83 ec 08             	sub    $0x8,%esp
  8030ce:	56                   	push   %esi
  8030cf:	ff 75 08             	pushl  0x8(%ebp)
  8030d2:	e8 eb f9 ff ff       	call   802ac2 <spawn>
}
  8030d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8030da:	5b                   	pop    %ebx
  8030db:	5e                   	pop    %esi
  8030dc:	5f                   	pop    %edi
  8030dd:	5d                   	pop    %ebp
  8030de:	c3                   	ret    

008030df <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8030df:	55                   	push   %ebp
  8030e0:	89 e5                	mov    %esp,%ebp
  8030e2:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8030e5:	68 fe 45 80 00       	push   $0x8045fe
  8030ea:	ff 75 0c             	pushl  0xc(%ebp)
  8030ed:	e8 6f e3 ff ff       	call   801461 <strcpy>
	return 0;
}
  8030f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8030f7:	c9                   	leave  
  8030f8:	c3                   	ret    

008030f9 <devsock_close>:
{
  8030f9:	55                   	push   %ebp
  8030fa:	89 e5                	mov    %esp,%ebp
  8030fc:	53                   	push   %ebx
  8030fd:	83 ec 10             	sub    $0x10,%esp
  803100:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  803103:	53                   	push   %ebx
  803104:	e8 72 09 00 00       	call   803a7b <pageref>
  803109:	83 c4 10             	add    $0x10,%esp
		return 0;
  80310c:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  803111:	83 f8 01             	cmp    $0x1,%eax
  803114:	74 07                	je     80311d <devsock_close+0x24>
}
  803116:	89 d0                	mov    %edx,%eax
  803118:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80311b:	c9                   	leave  
  80311c:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80311d:	83 ec 0c             	sub    $0xc,%esp
  803120:	ff 73 0c             	pushl  0xc(%ebx)
  803123:	e8 b9 02 00 00       	call   8033e1 <nsipc_close>
  803128:	89 c2                	mov    %eax,%edx
  80312a:	83 c4 10             	add    $0x10,%esp
  80312d:	eb e7                	jmp    803116 <devsock_close+0x1d>

0080312f <devsock_write>:
{
  80312f:	55                   	push   %ebp
  803130:	89 e5                	mov    %esp,%ebp
  803132:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803135:	6a 00                	push   $0x0
  803137:	ff 75 10             	pushl  0x10(%ebp)
  80313a:	ff 75 0c             	pushl  0xc(%ebp)
  80313d:	8b 45 08             	mov    0x8(%ebp),%eax
  803140:	ff 70 0c             	pushl  0xc(%eax)
  803143:	e8 76 03 00 00       	call   8034be <nsipc_send>
}
  803148:	c9                   	leave  
  803149:	c3                   	ret    

0080314a <devsock_read>:
{
  80314a:	55                   	push   %ebp
  80314b:	89 e5                	mov    %esp,%ebp
  80314d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803150:	6a 00                	push   $0x0
  803152:	ff 75 10             	pushl  0x10(%ebp)
  803155:	ff 75 0c             	pushl  0xc(%ebp)
  803158:	8b 45 08             	mov    0x8(%ebp),%eax
  80315b:	ff 70 0c             	pushl  0xc(%eax)
  80315e:	e8 ef 02 00 00       	call   803452 <nsipc_recv>
}
  803163:	c9                   	leave  
  803164:	c3                   	ret    

00803165 <fd2sockid>:
{
  803165:	55                   	push   %ebp
  803166:	89 e5                	mov    %esp,%ebp
  803168:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80316b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80316e:	52                   	push   %edx
  80316f:	50                   	push   %eax
  803170:	e8 86 f0 ff ff       	call   8021fb <fd_lookup>
  803175:	83 c4 10             	add    $0x10,%esp
  803178:	85 c0                	test   %eax,%eax
  80317a:	78 10                	js     80318c <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80317c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317f:	8b 0d 3c 50 80 00    	mov    0x80503c,%ecx
  803185:	39 08                	cmp    %ecx,(%eax)
  803187:	75 05                	jne    80318e <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  803189:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80318c:	c9                   	leave  
  80318d:	c3                   	ret    
		return -E_NOT_SUPP;
  80318e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803193:	eb f7                	jmp    80318c <fd2sockid+0x27>

00803195 <alloc_sockfd>:
{
  803195:	55                   	push   %ebp
  803196:	89 e5                	mov    %esp,%ebp
  803198:	56                   	push   %esi
  803199:	53                   	push   %ebx
  80319a:	83 ec 1c             	sub    $0x1c,%esp
  80319d:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80319f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8031a2:	50                   	push   %eax
  8031a3:	e8 01 f0 ff ff       	call   8021a9 <fd_alloc>
  8031a8:	89 c3                	mov    %eax,%ebx
  8031aa:	83 c4 10             	add    $0x10,%esp
  8031ad:	85 c0                	test   %eax,%eax
  8031af:	78 43                	js     8031f4 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8031b1:	83 ec 04             	sub    $0x4,%esp
  8031b4:	68 07 04 00 00       	push   $0x407
  8031b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8031bc:	6a 00                	push   $0x0
  8031be:	e8 90 e6 ff ff       	call   801853 <sys_page_alloc>
  8031c3:	89 c3                	mov    %eax,%ebx
  8031c5:	83 c4 10             	add    $0x10,%esp
  8031c8:	85 c0                	test   %eax,%eax
  8031ca:	78 28                	js     8031f4 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8031cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cf:	8b 15 3c 50 80 00    	mov    0x80503c,%edx
  8031d5:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8031d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031da:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8031e1:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8031e4:	83 ec 0c             	sub    $0xc,%esp
  8031e7:	50                   	push   %eax
  8031e8:	e8 95 ef ff ff       	call   802182 <fd2num>
  8031ed:	89 c3                	mov    %eax,%ebx
  8031ef:	83 c4 10             	add    $0x10,%esp
  8031f2:	eb 0c                	jmp    803200 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8031f4:	83 ec 0c             	sub    $0xc,%esp
  8031f7:	56                   	push   %esi
  8031f8:	e8 e4 01 00 00       	call   8033e1 <nsipc_close>
		return r;
  8031fd:	83 c4 10             	add    $0x10,%esp
}
  803200:	89 d8                	mov    %ebx,%eax
  803202:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803205:	5b                   	pop    %ebx
  803206:	5e                   	pop    %esi
  803207:	5d                   	pop    %ebp
  803208:	c3                   	ret    

00803209 <accept>:
{
  803209:	55                   	push   %ebp
  80320a:	89 e5                	mov    %esp,%ebp
  80320c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80320f:	8b 45 08             	mov    0x8(%ebp),%eax
  803212:	e8 4e ff ff ff       	call   803165 <fd2sockid>
  803217:	85 c0                	test   %eax,%eax
  803219:	78 1b                	js     803236 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80321b:	83 ec 04             	sub    $0x4,%esp
  80321e:	ff 75 10             	pushl  0x10(%ebp)
  803221:	ff 75 0c             	pushl  0xc(%ebp)
  803224:	50                   	push   %eax
  803225:	e8 0e 01 00 00       	call   803338 <nsipc_accept>
  80322a:	83 c4 10             	add    $0x10,%esp
  80322d:	85 c0                	test   %eax,%eax
  80322f:	78 05                	js     803236 <accept+0x2d>
	return alloc_sockfd(r);
  803231:	e8 5f ff ff ff       	call   803195 <alloc_sockfd>
}
  803236:	c9                   	leave  
  803237:	c3                   	ret    

00803238 <bind>:
{
  803238:	55                   	push   %ebp
  803239:	89 e5                	mov    %esp,%ebp
  80323b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80323e:	8b 45 08             	mov    0x8(%ebp),%eax
  803241:	e8 1f ff ff ff       	call   803165 <fd2sockid>
  803246:	85 c0                	test   %eax,%eax
  803248:	78 12                	js     80325c <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80324a:	83 ec 04             	sub    $0x4,%esp
  80324d:	ff 75 10             	pushl  0x10(%ebp)
  803250:	ff 75 0c             	pushl  0xc(%ebp)
  803253:	50                   	push   %eax
  803254:	e8 31 01 00 00       	call   80338a <nsipc_bind>
  803259:	83 c4 10             	add    $0x10,%esp
}
  80325c:	c9                   	leave  
  80325d:	c3                   	ret    

0080325e <shutdown>:
{
  80325e:	55                   	push   %ebp
  80325f:	89 e5                	mov    %esp,%ebp
  803261:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  803264:	8b 45 08             	mov    0x8(%ebp),%eax
  803267:	e8 f9 fe ff ff       	call   803165 <fd2sockid>
  80326c:	85 c0                	test   %eax,%eax
  80326e:	78 0f                	js     80327f <shutdown+0x21>
	return nsipc_shutdown(r, how);
  803270:	83 ec 08             	sub    $0x8,%esp
  803273:	ff 75 0c             	pushl  0xc(%ebp)
  803276:	50                   	push   %eax
  803277:	e8 43 01 00 00       	call   8033bf <nsipc_shutdown>
  80327c:	83 c4 10             	add    $0x10,%esp
}
  80327f:	c9                   	leave  
  803280:	c3                   	ret    

00803281 <connect>:
{
  803281:	55                   	push   %ebp
  803282:	89 e5                	mov    %esp,%ebp
  803284:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  803287:	8b 45 08             	mov    0x8(%ebp),%eax
  80328a:	e8 d6 fe ff ff       	call   803165 <fd2sockid>
  80328f:	85 c0                	test   %eax,%eax
  803291:	78 12                	js     8032a5 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  803293:	83 ec 04             	sub    $0x4,%esp
  803296:	ff 75 10             	pushl  0x10(%ebp)
  803299:	ff 75 0c             	pushl  0xc(%ebp)
  80329c:	50                   	push   %eax
  80329d:	e8 59 01 00 00       	call   8033fb <nsipc_connect>
  8032a2:	83 c4 10             	add    $0x10,%esp
}
  8032a5:	c9                   	leave  
  8032a6:	c3                   	ret    

008032a7 <listen>:
{
  8032a7:	55                   	push   %ebp
  8032a8:	89 e5                	mov    %esp,%ebp
  8032aa:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8032ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b0:	e8 b0 fe ff ff       	call   803165 <fd2sockid>
  8032b5:	85 c0                	test   %eax,%eax
  8032b7:	78 0f                	js     8032c8 <listen+0x21>
	return nsipc_listen(r, backlog);
  8032b9:	83 ec 08             	sub    $0x8,%esp
  8032bc:	ff 75 0c             	pushl  0xc(%ebp)
  8032bf:	50                   	push   %eax
  8032c0:	e8 6b 01 00 00       	call   803430 <nsipc_listen>
  8032c5:	83 c4 10             	add    $0x10,%esp
}
  8032c8:	c9                   	leave  
  8032c9:	c3                   	ret    

008032ca <socket>:

int
socket(int domain, int type, int protocol)
{
  8032ca:	55                   	push   %ebp
  8032cb:	89 e5                	mov    %esp,%ebp
  8032cd:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8032d0:	ff 75 10             	pushl  0x10(%ebp)
  8032d3:	ff 75 0c             	pushl  0xc(%ebp)
  8032d6:	ff 75 08             	pushl  0x8(%ebp)
  8032d9:	e8 3e 02 00 00       	call   80351c <nsipc_socket>
  8032de:	83 c4 10             	add    $0x10,%esp
  8032e1:	85 c0                	test   %eax,%eax
  8032e3:	78 05                	js     8032ea <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8032e5:	e8 ab fe ff ff       	call   803195 <alloc_sockfd>
}
  8032ea:	c9                   	leave  
  8032eb:	c3                   	ret    

008032ec <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8032ec:	55                   	push   %ebp
  8032ed:	89 e5                	mov    %esp,%ebp
  8032ef:	53                   	push   %ebx
  8032f0:	83 ec 04             	sub    $0x4,%esp
  8032f3:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8032f5:	83 3d 24 64 80 00 00 	cmpl   $0x0,0x806424
  8032fc:	74 26                	je     803324 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8032fe:	6a 07                	push   $0x7
  803300:	68 00 80 80 00       	push   $0x808000
  803305:	53                   	push   %ebx
  803306:	ff 35 24 64 80 00    	pushl  0x806424
  80330c:	e8 d3 06 00 00       	call   8039e4 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  803311:	83 c4 0c             	add    $0xc,%esp
  803314:	6a 00                	push   $0x0
  803316:	6a 00                	push   $0x0
  803318:	6a 00                	push   $0x0
  80331a:	e8 5c 06 00 00       	call   80397b <ipc_recv>
}
  80331f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803322:	c9                   	leave  
  803323:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803324:	83 ec 0c             	sub    $0xc,%esp
  803327:	6a 02                	push   $0x2
  803329:	e8 0e 07 00 00       	call   803a3c <ipc_find_env>
  80332e:	a3 24 64 80 00       	mov    %eax,0x806424
  803333:	83 c4 10             	add    $0x10,%esp
  803336:	eb c6                	jmp    8032fe <nsipc+0x12>

00803338 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803338:	55                   	push   %ebp
  803339:	89 e5                	mov    %esp,%ebp
  80333b:	56                   	push   %esi
  80333c:	53                   	push   %ebx
  80333d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  803340:	8b 45 08             	mov    0x8(%ebp),%eax
  803343:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  803348:	8b 06                	mov    (%esi),%eax
  80334a:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80334f:	b8 01 00 00 00       	mov    $0x1,%eax
  803354:	e8 93 ff ff ff       	call   8032ec <nsipc>
  803359:	89 c3                	mov    %eax,%ebx
  80335b:	85 c0                	test   %eax,%eax
  80335d:	79 09                	jns    803368 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80335f:	89 d8                	mov    %ebx,%eax
  803361:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803364:	5b                   	pop    %ebx
  803365:	5e                   	pop    %esi
  803366:	5d                   	pop    %ebp
  803367:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803368:	83 ec 04             	sub    $0x4,%esp
  80336b:	ff 35 10 80 80 00    	pushl  0x808010
  803371:	68 00 80 80 00       	push   $0x808000
  803376:	ff 75 0c             	pushl  0xc(%ebp)
  803379:	e8 71 e2 ff ff       	call   8015ef <memmove>
		*addrlen = ret->ret_addrlen;
  80337e:	a1 10 80 80 00       	mov    0x808010,%eax
  803383:	89 06                	mov    %eax,(%esi)
  803385:	83 c4 10             	add    $0x10,%esp
	return r;
  803388:	eb d5                	jmp    80335f <nsipc_accept+0x27>

0080338a <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80338a:	55                   	push   %ebp
  80338b:	89 e5                	mov    %esp,%ebp
  80338d:	53                   	push   %ebx
  80338e:	83 ec 08             	sub    $0x8,%esp
  803391:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  803394:	8b 45 08             	mov    0x8(%ebp),%eax
  803397:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80339c:	53                   	push   %ebx
  80339d:	ff 75 0c             	pushl  0xc(%ebp)
  8033a0:	68 04 80 80 00       	push   $0x808004
  8033a5:	e8 45 e2 ff ff       	call   8015ef <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8033aa:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  8033b0:	b8 02 00 00 00       	mov    $0x2,%eax
  8033b5:	e8 32 ff ff ff       	call   8032ec <nsipc>
}
  8033ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8033bd:	c9                   	leave  
  8033be:	c3                   	ret    

008033bf <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8033bf:	55                   	push   %ebp
  8033c0:	89 e5                	mov    %esp,%ebp
  8033c2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8033c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c8:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  8033cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033d0:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  8033d5:	b8 03 00 00 00       	mov    $0x3,%eax
  8033da:	e8 0d ff ff ff       	call   8032ec <nsipc>
}
  8033df:	c9                   	leave  
  8033e0:	c3                   	ret    

008033e1 <nsipc_close>:

int
nsipc_close(int s)
{
  8033e1:	55                   	push   %ebp
  8033e2:	89 e5                	mov    %esp,%ebp
  8033e4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8033e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ea:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  8033ef:	b8 04 00 00 00       	mov    $0x4,%eax
  8033f4:	e8 f3 fe ff ff       	call   8032ec <nsipc>
}
  8033f9:	c9                   	leave  
  8033fa:	c3                   	ret    

008033fb <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8033fb:	55                   	push   %ebp
  8033fc:	89 e5                	mov    %esp,%ebp
  8033fe:	53                   	push   %ebx
  8033ff:	83 ec 08             	sub    $0x8,%esp
  803402:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  803405:	8b 45 08             	mov    0x8(%ebp),%eax
  803408:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80340d:	53                   	push   %ebx
  80340e:	ff 75 0c             	pushl  0xc(%ebp)
  803411:	68 04 80 80 00       	push   $0x808004
  803416:	e8 d4 e1 ff ff       	call   8015ef <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80341b:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  803421:	b8 05 00 00 00       	mov    $0x5,%eax
  803426:	e8 c1 fe ff ff       	call   8032ec <nsipc>
}
  80342b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80342e:	c9                   	leave  
  80342f:	c3                   	ret    

00803430 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803430:	55                   	push   %ebp
  803431:	89 e5                	mov    %esp,%ebp
  803433:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  803436:	8b 45 08             	mov    0x8(%ebp),%eax
  803439:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  80343e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803441:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  803446:	b8 06 00 00 00       	mov    $0x6,%eax
  80344b:	e8 9c fe ff ff       	call   8032ec <nsipc>
}
  803450:	c9                   	leave  
  803451:	c3                   	ret    

00803452 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803452:	55                   	push   %ebp
  803453:	89 e5                	mov    %esp,%ebp
  803455:	56                   	push   %esi
  803456:	53                   	push   %ebx
  803457:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80345a:	8b 45 08             	mov    0x8(%ebp),%eax
  80345d:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  803462:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  803468:	8b 45 14             	mov    0x14(%ebp),%eax
  80346b:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803470:	b8 07 00 00 00       	mov    $0x7,%eax
  803475:	e8 72 fe ff ff       	call   8032ec <nsipc>
  80347a:	89 c3                	mov    %eax,%ebx
  80347c:	85 c0                	test   %eax,%eax
  80347e:	78 1f                	js     80349f <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  803480:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  803485:	7f 21                	jg     8034a8 <nsipc_recv+0x56>
  803487:	39 c6                	cmp    %eax,%esi
  803489:	7c 1d                	jl     8034a8 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80348b:	83 ec 04             	sub    $0x4,%esp
  80348e:	50                   	push   %eax
  80348f:	68 00 80 80 00       	push   $0x808000
  803494:	ff 75 0c             	pushl  0xc(%ebp)
  803497:	e8 53 e1 ff ff       	call   8015ef <memmove>
  80349c:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80349f:	89 d8                	mov    %ebx,%eax
  8034a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8034a4:	5b                   	pop    %ebx
  8034a5:	5e                   	pop    %esi
  8034a6:	5d                   	pop    %ebp
  8034a7:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8034a8:	68 0a 46 80 00       	push   $0x80460a
  8034ad:	68 6f 3e 80 00       	push   $0x803e6f
  8034b2:	6a 62                	push   $0x62
  8034b4:	68 1f 46 80 00       	push   $0x80461f
  8034b9:	e8 5e d6 ff ff       	call   800b1c <_panic>

008034be <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8034be:	55                   	push   %ebp
  8034bf:	89 e5                	mov    %esp,%ebp
  8034c1:	53                   	push   %ebx
  8034c2:	83 ec 04             	sub    $0x4,%esp
  8034c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8034c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cb:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  8034d0:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8034d6:	7f 2e                	jg     803506 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8034d8:	83 ec 04             	sub    $0x4,%esp
  8034db:	53                   	push   %ebx
  8034dc:	ff 75 0c             	pushl  0xc(%ebp)
  8034df:	68 0c 80 80 00       	push   $0x80800c
  8034e4:	e8 06 e1 ff ff       	call   8015ef <memmove>
	nsipcbuf.send.req_size = size;
  8034e9:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  8034ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8034f2:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  8034f7:	b8 08 00 00 00       	mov    $0x8,%eax
  8034fc:	e8 eb fd ff ff       	call   8032ec <nsipc>
}
  803501:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803504:	c9                   	leave  
  803505:	c3                   	ret    
	assert(size < 1600);
  803506:	68 2b 46 80 00       	push   $0x80462b
  80350b:	68 6f 3e 80 00       	push   $0x803e6f
  803510:	6a 6d                	push   $0x6d
  803512:	68 1f 46 80 00       	push   $0x80461f
  803517:	e8 00 d6 ff ff       	call   800b1c <_panic>

0080351c <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80351c:	55                   	push   %ebp
  80351d:	89 e5                	mov    %esp,%ebp
  80351f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  803522:	8b 45 08             	mov    0x8(%ebp),%eax
  803525:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  80352a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80352d:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  803532:	8b 45 10             	mov    0x10(%ebp),%eax
  803535:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  80353a:	b8 09 00 00 00       	mov    $0x9,%eax
  80353f:	e8 a8 fd ff ff       	call   8032ec <nsipc>
}
  803544:	c9                   	leave  
  803545:	c3                   	ret    

00803546 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803546:	55                   	push   %ebp
  803547:	89 e5                	mov    %esp,%ebp
  803549:	56                   	push   %esi
  80354a:	53                   	push   %ebx
  80354b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80354e:	83 ec 0c             	sub    $0xc,%esp
  803551:	ff 75 08             	pushl  0x8(%ebp)
  803554:	e8 39 ec ff ff       	call   802192 <fd2data>
  803559:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80355b:	83 c4 08             	add    $0x8,%esp
  80355e:	68 37 46 80 00       	push   $0x804637
  803563:	53                   	push   %ebx
  803564:	e8 f8 de ff ff       	call   801461 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  803569:	8b 46 04             	mov    0x4(%esi),%eax
  80356c:	2b 06                	sub    (%esi),%eax
  80356e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  803574:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80357b:	00 00 00 
	stat->st_dev = &devpipe;
  80357e:	c7 83 88 00 00 00 58 	movl   $0x805058,0x88(%ebx)
  803585:	50 80 00 
	return 0;
}
  803588:	b8 00 00 00 00       	mov    $0x0,%eax
  80358d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803590:	5b                   	pop    %ebx
  803591:	5e                   	pop    %esi
  803592:	5d                   	pop    %ebp
  803593:	c3                   	ret    

00803594 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803594:	55                   	push   %ebp
  803595:	89 e5                	mov    %esp,%ebp
  803597:	53                   	push   %ebx
  803598:	83 ec 0c             	sub    $0xc,%esp
  80359b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80359e:	53                   	push   %ebx
  80359f:	6a 00                	push   $0x0
  8035a1:	e8 32 e3 ff ff       	call   8018d8 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8035a6:	89 1c 24             	mov    %ebx,(%esp)
  8035a9:	e8 e4 eb ff ff       	call   802192 <fd2data>
  8035ae:	83 c4 08             	add    $0x8,%esp
  8035b1:	50                   	push   %eax
  8035b2:	6a 00                	push   $0x0
  8035b4:	e8 1f e3 ff ff       	call   8018d8 <sys_page_unmap>
}
  8035b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8035bc:	c9                   	leave  
  8035bd:	c3                   	ret    

008035be <_pipeisclosed>:
{
  8035be:	55                   	push   %ebp
  8035bf:	89 e5                	mov    %esp,%ebp
  8035c1:	57                   	push   %edi
  8035c2:	56                   	push   %esi
  8035c3:	53                   	push   %ebx
  8035c4:	83 ec 1c             	sub    $0x1c,%esp
  8035c7:	89 c7                	mov    %eax,%edi
  8035c9:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8035cb:	a1 28 64 80 00       	mov    0x806428,%eax
  8035d0:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8035d3:	83 ec 0c             	sub    $0xc,%esp
  8035d6:	57                   	push   %edi
  8035d7:	e8 9f 04 00 00       	call   803a7b <pageref>
  8035dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8035df:	89 34 24             	mov    %esi,(%esp)
  8035e2:	e8 94 04 00 00       	call   803a7b <pageref>
		nn = thisenv->env_runs;
  8035e7:	8b 15 28 64 80 00    	mov    0x806428,%edx
  8035ed:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8035f0:	83 c4 10             	add    $0x10,%esp
  8035f3:	39 cb                	cmp    %ecx,%ebx
  8035f5:	74 1b                	je     803612 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8035f7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8035fa:	75 cf                	jne    8035cb <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8035fc:	8b 42 58             	mov    0x58(%edx),%eax
  8035ff:	6a 01                	push   $0x1
  803601:	50                   	push   %eax
  803602:	53                   	push   %ebx
  803603:	68 3e 46 80 00       	push   $0x80463e
  803608:	e8 05 d6 ff ff       	call   800c12 <cprintf>
  80360d:	83 c4 10             	add    $0x10,%esp
  803610:	eb b9                	jmp    8035cb <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  803612:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  803615:	0f 94 c0             	sete   %al
  803618:	0f b6 c0             	movzbl %al,%eax
}
  80361b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80361e:	5b                   	pop    %ebx
  80361f:	5e                   	pop    %esi
  803620:	5f                   	pop    %edi
  803621:	5d                   	pop    %ebp
  803622:	c3                   	ret    

00803623 <devpipe_write>:
{
  803623:	55                   	push   %ebp
  803624:	89 e5                	mov    %esp,%ebp
  803626:	57                   	push   %edi
  803627:	56                   	push   %esi
  803628:	53                   	push   %ebx
  803629:	83 ec 28             	sub    $0x28,%esp
  80362c:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80362f:	56                   	push   %esi
  803630:	e8 5d eb ff ff       	call   802192 <fd2data>
  803635:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  803637:	83 c4 10             	add    $0x10,%esp
  80363a:	bf 00 00 00 00       	mov    $0x0,%edi
  80363f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  803642:	74 4f                	je     803693 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803644:	8b 43 04             	mov    0x4(%ebx),%eax
  803647:	8b 0b                	mov    (%ebx),%ecx
  803649:	8d 51 20             	lea    0x20(%ecx),%edx
  80364c:	39 d0                	cmp    %edx,%eax
  80364e:	72 14                	jb     803664 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  803650:	89 da                	mov    %ebx,%edx
  803652:	89 f0                	mov    %esi,%eax
  803654:	e8 65 ff ff ff       	call   8035be <_pipeisclosed>
  803659:	85 c0                	test   %eax,%eax
  80365b:	75 3b                	jne    803698 <devpipe_write+0x75>
			sys_yield();
  80365d:	e8 d2 e1 ff ff       	call   801834 <sys_yield>
  803662:	eb e0                	jmp    803644 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803664:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803667:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80366b:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80366e:	89 c2                	mov    %eax,%edx
  803670:	c1 fa 1f             	sar    $0x1f,%edx
  803673:	89 d1                	mov    %edx,%ecx
  803675:	c1 e9 1b             	shr    $0x1b,%ecx
  803678:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80367b:	83 e2 1f             	and    $0x1f,%edx
  80367e:	29 ca                	sub    %ecx,%edx
  803680:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  803684:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  803688:	83 c0 01             	add    $0x1,%eax
  80368b:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80368e:	83 c7 01             	add    $0x1,%edi
  803691:	eb ac                	jmp    80363f <devpipe_write+0x1c>
	return i;
  803693:	8b 45 10             	mov    0x10(%ebp),%eax
  803696:	eb 05                	jmp    80369d <devpipe_write+0x7a>
				return 0;
  803698:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80369d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8036a0:	5b                   	pop    %ebx
  8036a1:	5e                   	pop    %esi
  8036a2:	5f                   	pop    %edi
  8036a3:	5d                   	pop    %ebp
  8036a4:	c3                   	ret    

008036a5 <devpipe_read>:
{
  8036a5:	55                   	push   %ebp
  8036a6:	89 e5                	mov    %esp,%ebp
  8036a8:	57                   	push   %edi
  8036a9:	56                   	push   %esi
  8036aa:	53                   	push   %ebx
  8036ab:	83 ec 18             	sub    $0x18,%esp
  8036ae:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8036b1:	57                   	push   %edi
  8036b2:	e8 db ea ff ff       	call   802192 <fd2data>
  8036b7:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8036b9:	83 c4 10             	add    $0x10,%esp
  8036bc:	be 00 00 00 00       	mov    $0x0,%esi
  8036c1:	3b 75 10             	cmp    0x10(%ebp),%esi
  8036c4:	75 14                	jne    8036da <devpipe_read+0x35>
	return i;
  8036c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8036c9:	eb 02                	jmp    8036cd <devpipe_read+0x28>
				return i;
  8036cb:	89 f0                	mov    %esi,%eax
}
  8036cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8036d0:	5b                   	pop    %ebx
  8036d1:	5e                   	pop    %esi
  8036d2:	5f                   	pop    %edi
  8036d3:	5d                   	pop    %ebp
  8036d4:	c3                   	ret    
			sys_yield();
  8036d5:	e8 5a e1 ff ff       	call   801834 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8036da:	8b 03                	mov    (%ebx),%eax
  8036dc:	3b 43 04             	cmp    0x4(%ebx),%eax
  8036df:	75 18                	jne    8036f9 <devpipe_read+0x54>
			if (i > 0)
  8036e1:	85 f6                	test   %esi,%esi
  8036e3:	75 e6                	jne    8036cb <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8036e5:	89 da                	mov    %ebx,%edx
  8036e7:	89 f8                	mov    %edi,%eax
  8036e9:	e8 d0 fe ff ff       	call   8035be <_pipeisclosed>
  8036ee:	85 c0                	test   %eax,%eax
  8036f0:	74 e3                	je     8036d5 <devpipe_read+0x30>
				return 0;
  8036f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8036f7:	eb d4                	jmp    8036cd <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8036f9:	99                   	cltd   
  8036fa:	c1 ea 1b             	shr    $0x1b,%edx
  8036fd:	01 d0                	add    %edx,%eax
  8036ff:	83 e0 1f             	and    $0x1f,%eax
  803702:	29 d0                	sub    %edx,%eax
  803704:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803709:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80370c:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80370f:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  803712:	83 c6 01             	add    $0x1,%esi
  803715:	eb aa                	jmp    8036c1 <devpipe_read+0x1c>

00803717 <pipe>:
{
  803717:	55                   	push   %ebp
  803718:	89 e5                	mov    %esp,%ebp
  80371a:	56                   	push   %esi
  80371b:	53                   	push   %ebx
  80371c:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80371f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803722:	50                   	push   %eax
  803723:	e8 81 ea ff ff       	call   8021a9 <fd_alloc>
  803728:	89 c3                	mov    %eax,%ebx
  80372a:	83 c4 10             	add    $0x10,%esp
  80372d:	85 c0                	test   %eax,%eax
  80372f:	0f 88 23 01 00 00    	js     803858 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803735:	83 ec 04             	sub    $0x4,%esp
  803738:	68 07 04 00 00       	push   $0x407
  80373d:	ff 75 f4             	pushl  -0xc(%ebp)
  803740:	6a 00                	push   $0x0
  803742:	e8 0c e1 ff ff       	call   801853 <sys_page_alloc>
  803747:	89 c3                	mov    %eax,%ebx
  803749:	83 c4 10             	add    $0x10,%esp
  80374c:	85 c0                	test   %eax,%eax
  80374e:	0f 88 04 01 00 00    	js     803858 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  803754:	83 ec 0c             	sub    $0xc,%esp
  803757:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80375a:	50                   	push   %eax
  80375b:	e8 49 ea ff ff       	call   8021a9 <fd_alloc>
  803760:	89 c3                	mov    %eax,%ebx
  803762:	83 c4 10             	add    $0x10,%esp
  803765:	85 c0                	test   %eax,%eax
  803767:	0f 88 db 00 00 00    	js     803848 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80376d:	83 ec 04             	sub    $0x4,%esp
  803770:	68 07 04 00 00       	push   $0x407
  803775:	ff 75 f0             	pushl  -0x10(%ebp)
  803778:	6a 00                	push   $0x0
  80377a:	e8 d4 e0 ff ff       	call   801853 <sys_page_alloc>
  80377f:	89 c3                	mov    %eax,%ebx
  803781:	83 c4 10             	add    $0x10,%esp
  803784:	85 c0                	test   %eax,%eax
  803786:	0f 88 bc 00 00 00    	js     803848 <pipe+0x131>
	va = fd2data(fd0);
  80378c:	83 ec 0c             	sub    $0xc,%esp
  80378f:	ff 75 f4             	pushl  -0xc(%ebp)
  803792:	e8 fb e9 ff ff       	call   802192 <fd2data>
  803797:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803799:	83 c4 0c             	add    $0xc,%esp
  80379c:	68 07 04 00 00       	push   $0x407
  8037a1:	50                   	push   %eax
  8037a2:	6a 00                	push   $0x0
  8037a4:	e8 aa e0 ff ff       	call   801853 <sys_page_alloc>
  8037a9:	89 c3                	mov    %eax,%ebx
  8037ab:	83 c4 10             	add    $0x10,%esp
  8037ae:	85 c0                	test   %eax,%eax
  8037b0:	0f 88 82 00 00 00    	js     803838 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8037b6:	83 ec 0c             	sub    $0xc,%esp
  8037b9:	ff 75 f0             	pushl  -0x10(%ebp)
  8037bc:	e8 d1 e9 ff ff       	call   802192 <fd2data>
  8037c1:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8037c8:	50                   	push   %eax
  8037c9:	6a 00                	push   $0x0
  8037cb:	56                   	push   %esi
  8037cc:	6a 00                	push   $0x0
  8037ce:	e8 c3 e0 ff ff       	call   801896 <sys_page_map>
  8037d3:	89 c3                	mov    %eax,%ebx
  8037d5:	83 c4 20             	add    $0x20,%esp
  8037d8:	85 c0                	test   %eax,%eax
  8037da:	78 4e                	js     80382a <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8037dc:	a1 58 50 80 00       	mov    0x805058,%eax
  8037e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037e4:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8037e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037e9:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8037f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037f3:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8037f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037f8:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8037ff:	83 ec 0c             	sub    $0xc,%esp
  803802:	ff 75 f4             	pushl  -0xc(%ebp)
  803805:	e8 78 e9 ff ff       	call   802182 <fd2num>
  80380a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80380d:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80380f:	83 c4 04             	add    $0x4,%esp
  803812:	ff 75 f0             	pushl  -0x10(%ebp)
  803815:	e8 68 e9 ff ff       	call   802182 <fd2num>
  80381a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80381d:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  803820:	83 c4 10             	add    $0x10,%esp
  803823:	bb 00 00 00 00       	mov    $0x0,%ebx
  803828:	eb 2e                	jmp    803858 <pipe+0x141>
	sys_page_unmap(0, va);
  80382a:	83 ec 08             	sub    $0x8,%esp
  80382d:	56                   	push   %esi
  80382e:	6a 00                	push   $0x0
  803830:	e8 a3 e0 ff ff       	call   8018d8 <sys_page_unmap>
  803835:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  803838:	83 ec 08             	sub    $0x8,%esp
  80383b:	ff 75 f0             	pushl  -0x10(%ebp)
  80383e:	6a 00                	push   $0x0
  803840:	e8 93 e0 ff ff       	call   8018d8 <sys_page_unmap>
  803845:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  803848:	83 ec 08             	sub    $0x8,%esp
  80384b:	ff 75 f4             	pushl  -0xc(%ebp)
  80384e:	6a 00                	push   $0x0
  803850:	e8 83 e0 ff ff       	call   8018d8 <sys_page_unmap>
  803855:	83 c4 10             	add    $0x10,%esp
}
  803858:	89 d8                	mov    %ebx,%eax
  80385a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80385d:	5b                   	pop    %ebx
  80385e:	5e                   	pop    %esi
  80385f:	5d                   	pop    %ebp
  803860:	c3                   	ret    

00803861 <pipeisclosed>:
{
  803861:	55                   	push   %ebp
  803862:	89 e5                	mov    %esp,%ebp
  803864:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803867:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80386a:	50                   	push   %eax
  80386b:	ff 75 08             	pushl  0x8(%ebp)
  80386e:	e8 88 e9 ff ff       	call   8021fb <fd_lookup>
  803873:	83 c4 10             	add    $0x10,%esp
  803876:	85 c0                	test   %eax,%eax
  803878:	78 18                	js     803892 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80387a:	83 ec 0c             	sub    $0xc,%esp
  80387d:	ff 75 f4             	pushl  -0xc(%ebp)
  803880:	e8 0d e9 ff ff       	call   802192 <fd2data>
	return _pipeisclosed(fd, p);
  803885:	89 c2                	mov    %eax,%edx
  803887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80388a:	e8 2f fd ff ff       	call   8035be <_pipeisclosed>
  80388f:	83 c4 10             	add    $0x10,%esp
}
  803892:	c9                   	leave  
  803893:	c3                   	ret    

00803894 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  803894:	55                   	push   %ebp
  803895:	89 e5                	mov    %esp,%ebp
  803897:	56                   	push   %esi
  803898:	53                   	push   %ebx
  803899:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  80389c:	85 f6                	test   %esi,%esi
  80389e:	74 16                	je     8038b6 <wait+0x22>
	e = &envs[ENVX(envid)];
  8038a0:	89 f3                	mov    %esi,%ebx
  8038a2:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8038a8:	69 db 84 00 00 00    	imul   $0x84,%ebx,%ebx
  8038ae:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8038b4:	eb 1b                	jmp    8038d1 <wait+0x3d>
	assert(envid != 0);
  8038b6:	68 56 46 80 00       	push   $0x804656
  8038bb:	68 6f 3e 80 00       	push   $0x803e6f
  8038c0:	6a 09                	push   $0x9
  8038c2:	68 61 46 80 00       	push   $0x804661
  8038c7:	e8 50 d2 ff ff       	call   800b1c <_panic>
		sys_yield();
  8038cc:	e8 63 df ff ff       	call   801834 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8038d1:	8b 43 48             	mov    0x48(%ebx),%eax
  8038d4:	39 f0                	cmp    %esi,%eax
  8038d6:	75 07                	jne    8038df <wait+0x4b>
  8038d8:	8b 43 54             	mov    0x54(%ebx),%eax
  8038db:	85 c0                	test   %eax,%eax
  8038dd:	75 ed                	jne    8038cc <wait+0x38>
}
  8038df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8038e2:	5b                   	pop    %ebx
  8038e3:	5e                   	pop    %esi
  8038e4:	5d                   	pop    %ebp
  8038e5:	c3                   	ret    

008038e6 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8038e6:	55                   	push   %ebp
  8038e7:	89 e5                	mov    %esp,%ebp
  8038e9:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8038ec:	83 3d 00 90 80 00 00 	cmpl   $0x0,0x809000
  8038f3:	74 0a                	je     8038ff <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8038f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f8:	a3 00 90 80 00       	mov    %eax,0x809000
}
  8038fd:	c9                   	leave  
  8038fe:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8038ff:	83 ec 04             	sub    $0x4,%esp
  803902:	6a 07                	push   $0x7
  803904:	68 00 f0 bf ee       	push   $0xeebff000
  803909:	6a 00                	push   $0x0
  80390b:	e8 43 df ff ff       	call   801853 <sys_page_alloc>
		if(r < 0)
  803910:	83 c4 10             	add    $0x10,%esp
  803913:	85 c0                	test   %eax,%eax
  803915:	78 2a                	js     803941 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  803917:	83 ec 08             	sub    $0x8,%esp
  80391a:	68 55 39 80 00       	push   $0x803955
  80391f:	6a 00                	push   $0x0
  803921:	e8 78 e0 ff ff       	call   80199e <sys_env_set_pgfault_upcall>
		if(r < 0)
  803926:	83 c4 10             	add    $0x10,%esp
  803929:	85 c0                	test   %eax,%eax
  80392b:	79 c8                	jns    8038f5 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  80392d:	83 ec 04             	sub    $0x4,%esp
  803930:	68 9c 46 80 00       	push   $0x80469c
  803935:	6a 25                	push   $0x25
  803937:	68 d8 46 80 00       	push   $0x8046d8
  80393c:	e8 db d1 ff ff       	call   800b1c <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  803941:	83 ec 04             	sub    $0x4,%esp
  803944:	68 6c 46 80 00       	push   $0x80466c
  803949:	6a 22                	push   $0x22
  80394b:	68 d8 46 80 00       	push   $0x8046d8
  803950:	e8 c7 d1 ff ff       	call   800b1c <_panic>

00803955 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  803955:	54                   	push   %esp
	movl _pgfault_handler, %eax
  803956:	a1 00 90 80 00       	mov    0x809000,%eax
	call *%eax
  80395b:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80395d:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  803960:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  803964:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  803968:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80396b:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  80396d:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  803971:	83 c4 08             	add    $0x8,%esp
	popal
  803974:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  803975:	83 c4 04             	add    $0x4,%esp
	popfl
  803978:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  803979:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80397a:	c3                   	ret    

0080397b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80397b:	55                   	push   %ebp
  80397c:	89 e5                	mov    %esp,%ebp
  80397e:	56                   	push   %esi
  80397f:	53                   	push   %ebx
  803980:	8b 75 08             	mov    0x8(%ebp),%esi
  803983:	8b 45 0c             	mov    0xc(%ebp),%eax
  803986:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  803989:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80398b:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  803990:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  803993:	83 ec 0c             	sub    $0xc,%esp
  803996:	50                   	push   %eax
  803997:	e8 67 e0 ff ff       	call   801a03 <sys_ipc_recv>
	if(ret < 0){
  80399c:	83 c4 10             	add    $0x10,%esp
  80399f:	85 c0                	test   %eax,%eax
  8039a1:	78 2b                	js     8039ce <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8039a3:	85 f6                	test   %esi,%esi
  8039a5:	74 0a                	je     8039b1 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8039a7:	a1 28 64 80 00       	mov    0x806428,%eax
  8039ac:	8b 40 78             	mov    0x78(%eax),%eax
  8039af:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8039b1:	85 db                	test   %ebx,%ebx
  8039b3:	74 0a                	je     8039bf <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8039b5:	a1 28 64 80 00       	mov    0x806428,%eax
  8039ba:	8b 40 7c             	mov    0x7c(%eax),%eax
  8039bd:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8039bf:	a1 28 64 80 00       	mov    0x806428,%eax
  8039c4:	8b 40 74             	mov    0x74(%eax),%eax
}
  8039c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8039ca:	5b                   	pop    %ebx
  8039cb:	5e                   	pop    %esi
  8039cc:	5d                   	pop    %ebp
  8039cd:	c3                   	ret    
		if(from_env_store)
  8039ce:	85 f6                	test   %esi,%esi
  8039d0:	74 06                	je     8039d8 <ipc_recv+0x5d>
			*from_env_store = 0;
  8039d2:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8039d8:	85 db                	test   %ebx,%ebx
  8039da:	74 eb                	je     8039c7 <ipc_recv+0x4c>
			*perm_store = 0;
  8039dc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8039e2:	eb e3                	jmp    8039c7 <ipc_recv+0x4c>

008039e4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8039e4:	55                   	push   %ebp
  8039e5:	89 e5                	mov    %esp,%ebp
  8039e7:	57                   	push   %edi
  8039e8:	56                   	push   %esi
  8039e9:	53                   	push   %ebx
  8039ea:	83 ec 0c             	sub    $0xc,%esp
  8039ed:	8b 7d 08             	mov    0x8(%ebp),%edi
  8039f0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8039f3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8039f6:	85 db                	test   %ebx,%ebx
  8039f8:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8039fd:	0f 44 d8             	cmove  %eax,%ebx
  803a00:	eb 05                	jmp    803a07 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  803a02:	e8 2d de ff ff       	call   801834 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  803a07:	ff 75 14             	pushl  0x14(%ebp)
  803a0a:	53                   	push   %ebx
  803a0b:	56                   	push   %esi
  803a0c:	57                   	push   %edi
  803a0d:	e8 ce df ff ff       	call   8019e0 <sys_ipc_try_send>
  803a12:	83 c4 10             	add    $0x10,%esp
  803a15:	85 c0                	test   %eax,%eax
  803a17:	74 1b                	je     803a34 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  803a19:	79 e7                	jns    803a02 <ipc_send+0x1e>
  803a1b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  803a1e:	74 e2                	je     803a02 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  803a20:	83 ec 04             	sub    $0x4,%esp
  803a23:	68 e6 46 80 00       	push   $0x8046e6
  803a28:	6a 46                	push   $0x46
  803a2a:	68 fb 46 80 00       	push   $0x8046fb
  803a2f:	e8 e8 d0 ff ff       	call   800b1c <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  803a34:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803a37:	5b                   	pop    %ebx
  803a38:	5e                   	pop    %esi
  803a39:	5f                   	pop    %edi
  803a3a:	5d                   	pop    %ebp
  803a3b:	c3                   	ret    

00803a3c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803a3c:	55                   	push   %ebp
  803a3d:	89 e5                	mov    %esp,%ebp
  803a3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  803a42:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  803a47:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  803a4d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  803a53:	8b 52 50             	mov    0x50(%edx),%edx
  803a56:	39 ca                	cmp    %ecx,%edx
  803a58:	74 11                	je     803a6b <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  803a5a:	83 c0 01             	add    $0x1,%eax
  803a5d:	3d 00 04 00 00       	cmp    $0x400,%eax
  803a62:	75 e3                	jne    803a47 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  803a64:	b8 00 00 00 00       	mov    $0x0,%eax
  803a69:	eb 0e                	jmp    803a79 <ipc_find_env+0x3d>
			return envs[i].env_id;
  803a6b:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  803a71:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  803a76:	8b 40 48             	mov    0x48(%eax),%eax
}
  803a79:	5d                   	pop    %ebp
  803a7a:	c3                   	ret    

00803a7b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803a7b:	55                   	push   %ebp
  803a7c:	89 e5                	mov    %esp,%ebp
  803a7e:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803a81:	89 d0                	mov    %edx,%eax
  803a83:	c1 e8 16             	shr    $0x16,%eax
  803a86:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  803a8d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  803a92:	f6 c1 01             	test   $0x1,%cl
  803a95:	74 1d                	je     803ab4 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  803a97:	c1 ea 0c             	shr    $0xc,%edx
  803a9a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803aa1:	f6 c2 01             	test   $0x1,%dl
  803aa4:	74 0e                	je     803ab4 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803aa6:	c1 ea 0c             	shr    $0xc,%edx
  803aa9:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  803ab0:	ef 
  803ab1:	0f b7 c0             	movzwl %ax,%eax
}
  803ab4:	5d                   	pop    %ebp
  803ab5:	c3                   	ret    
  803ab6:	66 90                	xchg   %ax,%ax
  803ab8:	66 90                	xchg   %ax,%ax
  803aba:	66 90                	xchg   %ax,%ax
  803abc:	66 90                	xchg   %ax,%ax
  803abe:	66 90                	xchg   %ax,%ax

00803ac0 <__udivdi3>:
  803ac0:	55                   	push   %ebp
  803ac1:	57                   	push   %edi
  803ac2:	56                   	push   %esi
  803ac3:	53                   	push   %ebx
  803ac4:	83 ec 1c             	sub    $0x1c,%esp
  803ac7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  803acb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  803acf:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ad3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  803ad7:	85 d2                	test   %edx,%edx
  803ad9:	75 4d                	jne    803b28 <__udivdi3+0x68>
  803adb:	39 f3                	cmp    %esi,%ebx
  803add:	76 19                	jbe    803af8 <__udivdi3+0x38>
  803adf:	31 ff                	xor    %edi,%edi
  803ae1:	89 e8                	mov    %ebp,%eax
  803ae3:	89 f2                	mov    %esi,%edx
  803ae5:	f7 f3                	div    %ebx
  803ae7:	89 fa                	mov    %edi,%edx
  803ae9:	83 c4 1c             	add    $0x1c,%esp
  803aec:	5b                   	pop    %ebx
  803aed:	5e                   	pop    %esi
  803aee:	5f                   	pop    %edi
  803aef:	5d                   	pop    %ebp
  803af0:	c3                   	ret    
  803af1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803af8:	89 d9                	mov    %ebx,%ecx
  803afa:	85 db                	test   %ebx,%ebx
  803afc:	75 0b                	jne    803b09 <__udivdi3+0x49>
  803afe:	b8 01 00 00 00       	mov    $0x1,%eax
  803b03:	31 d2                	xor    %edx,%edx
  803b05:	f7 f3                	div    %ebx
  803b07:	89 c1                	mov    %eax,%ecx
  803b09:	31 d2                	xor    %edx,%edx
  803b0b:	89 f0                	mov    %esi,%eax
  803b0d:	f7 f1                	div    %ecx
  803b0f:	89 c6                	mov    %eax,%esi
  803b11:	89 e8                	mov    %ebp,%eax
  803b13:	89 f7                	mov    %esi,%edi
  803b15:	f7 f1                	div    %ecx
  803b17:	89 fa                	mov    %edi,%edx
  803b19:	83 c4 1c             	add    $0x1c,%esp
  803b1c:	5b                   	pop    %ebx
  803b1d:	5e                   	pop    %esi
  803b1e:	5f                   	pop    %edi
  803b1f:	5d                   	pop    %ebp
  803b20:	c3                   	ret    
  803b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803b28:	39 f2                	cmp    %esi,%edx
  803b2a:	77 1c                	ja     803b48 <__udivdi3+0x88>
  803b2c:	0f bd fa             	bsr    %edx,%edi
  803b2f:	83 f7 1f             	xor    $0x1f,%edi
  803b32:	75 2c                	jne    803b60 <__udivdi3+0xa0>
  803b34:	39 f2                	cmp    %esi,%edx
  803b36:	72 06                	jb     803b3e <__udivdi3+0x7e>
  803b38:	31 c0                	xor    %eax,%eax
  803b3a:	39 eb                	cmp    %ebp,%ebx
  803b3c:	77 a9                	ja     803ae7 <__udivdi3+0x27>
  803b3e:	b8 01 00 00 00       	mov    $0x1,%eax
  803b43:	eb a2                	jmp    803ae7 <__udivdi3+0x27>
  803b45:	8d 76 00             	lea    0x0(%esi),%esi
  803b48:	31 ff                	xor    %edi,%edi
  803b4a:	31 c0                	xor    %eax,%eax
  803b4c:	89 fa                	mov    %edi,%edx
  803b4e:	83 c4 1c             	add    $0x1c,%esp
  803b51:	5b                   	pop    %ebx
  803b52:	5e                   	pop    %esi
  803b53:	5f                   	pop    %edi
  803b54:	5d                   	pop    %ebp
  803b55:	c3                   	ret    
  803b56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803b5d:	8d 76 00             	lea    0x0(%esi),%esi
  803b60:	89 f9                	mov    %edi,%ecx
  803b62:	b8 20 00 00 00       	mov    $0x20,%eax
  803b67:	29 f8                	sub    %edi,%eax
  803b69:	d3 e2                	shl    %cl,%edx
  803b6b:	89 54 24 08          	mov    %edx,0x8(%esp)
  803b6f:	89 c1                	mov    %eax,%ecx
  803b71:	89 da                	mov    %ebx,%edx
  803b73:	d3 ea                	shr    %cl,%edx
  803b75:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803b79:	09 d1                	or     %edx,%ecx
  803b7b:	89 f2                	mov    %esi,%edx
  803b7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b81:	89 f9                	mov    %edi,%ecx
  803b83:	d3 e3                	shl    %cl,%ebx
  803b85:	89 c1                	mov    %eax,%ecx
  803b87:	d3 ea                	shr    %cl,%edx
  803b89:	89 f9                	mov    %edi,%ecx
  803b8b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  803b8f:	89 eb                	mov    %ebp,%ebx
  803b91:	d3 e6                	shl    %cl,%esi
  803b93:	89 c1                	mov    %eax,%ecx
  803b95:	d3 eb                	shr    %cl,%ebx
  803b97:	09 de                	or     %ebx,%esi
  803b99:	89 f0                	mov    %esi,%eax
  803b9b:	f7 74 24 08          	divl   0x8(%esp)
  803b9f:	89 d6                	mov    %edx,%esi
  803ba1:	89 c3                	mov    %eax,%ebx
  803ba3:	f7 64 24 0c          	mull   0xc(%esp)
  803ba7:	39 d6                	cmp    %edx,%esi
  803ba9:	72 15                	jb     803bc0 <__udivdi3+0x100>
  803bab:	89 f9                	mov    %edi,%ecx
  803bad:	d3 e5                	shl    %cl,%ebp
  803baf:	39 c5                	cmp    %eax,%ebp
  803bb1:	73 04                	jae    803bb7 <__udivdi3+0xf7>
  803bb3:	39 d6                	cmp    %edx,%esi
  803bb5:	74 09                	je     803bc0 <__udivdi3+0x100>
  803bb7:	89 d8                	mov    %ebx,%eax
  803bb9:	31 ff                	xor    %edi,%edi
  803bbb:	e9 27 ff ff ff       	jmp    803ae7 <__udivdi3+0x27>
  803bc0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803bc3:	31 ff                	xor    %edi,%edi
  803bc5:	e9 1d ff ff ff       	jmp    803ae7 <__udivdi3+0x27>
  803bca:	66 90                	xchg   %ax,%ax
  803bcc:	66 90                	xchg   %ax,%ax
  803bce:	66 90                	xchg   %ax,%ax

00803bd0 <__umoddi3>:
  803bd0:	55                   	push   %ebp
  803bd1:	57                   	push   %edi
  803bd2:	56                   	push   %esi
  803bd3:	53                   	push   %ebx
  803bd4:	83 ec 1c             	sub    $0x1c,%esp
  803bd7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  803bdb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803bdf:	8b 74 24 30          	mov    0x30(%esp),%esi
  803be3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803be7:	89 da                	mov    %ebx,%edx
  803be9:	85 c0                	test   %eax,%eax
  803beb:	75 43                	jne    803c30 <__umoddi3+0x60>
  803bed:	39 df                	cmp    %ebx,%edi
  803bef:	76 17                	jbe    803c08 <__umoddi3+0x38>
  803bf1:	89 f0                	mov    %esi,%eax
  803bf3:	f7 f7                	div    %edi
  803bf5:	89 d0                	mov    %edx,%eax
  803bf7:	31 d2                	xor    %edx,%edx
  803bf9:	83 c4 1c             	add    $0x1c,%esp
  803bfc:	5b                   	pop    %ebx
  803bfd:	5e                   	pop    %esi
  803bfe:	5f                   	pop    %edi
  803bff:	5d                   	pop    %ebp
  803c00:	c3                   	ret    
  803c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803c08:	89 fd                	mov    %edi,%ebp
  803c0a:	85 ff                	test   %edi,%edi
  803c0c:	75 0b                	jne    803c19 <__umoddi3+0x49>
  803c0e:	b8 01 00 00 00       	mov    $0x1,%eax
  803c13:	31 d2                	xor    %edx,%edx
  803c15:	f7 f7                	div    %edi
  803c17:	89 c5                	mov    %eax,%ebp
  803c19:	89 d8                	mov    %ebx,%eax
  803c1b:	31 d2                	xor    %edx,%edx
  803c1d:	f7 f5                	div    %ebp
  803c1f:	89 f0                	mov    %esi,%eax
  803c21:	f7 f5                	div    %ebp
  803c23:	89 d0                	mov    %edx,%eax
  803c25:	eb d0                	jmp    803bf7 <__umoddi3+0x27>
  803c27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803c2e:	66 90                	xchg   %ax,%ax
  803c30:	89 f1                	mov    %esi,%ecx
  803c32:	39 d8                	cmp    %ebx,%eax
  803c34:	76 0a                	jbe    803c40 <__umoddi3+0x70>
  803c36:	89 f0                	mov    %esi,%eax
  803c38:	83 c4 1c             	add    $0x1c,%esp
  803c3b:	5b                   	pop    %ebx
  803c3c:	5e                   	pop    %esi
  803c3d:	5f                   	pop    %edi
  803c3e:	5d                   	pop    %ebp
  803c3f:	c3                   	ret    
  803c40:	0f bd e8             	bsr    %eax,%ebp
  803c43:	83 f5 1f             	xor    $0x1f,%ebp
  803c46:	75 20                	jne    803c68 <__umoddi3+0x98>
  803c48:	39 d8                	cmp    %ebx,%eax
  803c4a:	0f 82 b0 00 00 00    	jb     803d00 <__umoddi3+0x130>
  803c50:	39 f7                	cmp    %esi,%edi
  803c52:	0f 86 a8 00 00 00    	jbe    803d00 <__umoddi3+0x130>
  803c58:	89 c8                	mov    %ecx,%eax
  803c5a:	83 c4 1c             	add    $0x1c,%esp
  803c5d:	5b                   	pop    %ebx
  803c5e:	5e                   	pop    %esi
  803c5f:	5f                   	pop    %edi
  803c60:	5d                   	pop    %ebp
  803c61:	c3                   	ret    
  803c62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803c68:	89 e9                	mov    %ebp,%ecx
  803c6a:	ba 20 00 00 00       	mov    $0x20,%edx
  803c6f:	29 ea                	sub    %ebp,%edx
  803c71:	d3 e0                	shl    %cl,%eax
  803c73:	89 44 24 08          	mov    %eax,0x8(%esp)
  803c77:	89 d1                	mov    %edx,%ecx
  803c79:	89 f8                	mov    %edi,%eax
  803c7b:	d3 e8                	shr    %cl,%eax
  803c7d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803c81:	89 54 24 04          	mov    %edx,0x4(%esp)
  803c85:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c89:	09 c1                	or     %eax,%ecx
  803c8b:	89 d8                	mov    %ebx,%eax
  803c8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c91:	89 e9                	mov    %ebp,%ecx
  803c93:	d3 e7                	shl    %cl,%edi
  803c95:	89 d1                	mov    %edx,%ecx
  803c97:	d3 e8                	shr    %cl,%eax
  803c99:	89 e9                	mov    %ebp,%ecx
  803c9b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c9f:	d3 e3                	shl    %cl,%ebx
  803ca1:	89 c7                	mov    %eax,%edi
  803ca3:	89 d1                	mov    %edx,%ecx
  803ca5:	89 f0                	mov    %esi,%eax
  803ca7:	d3 e8                	shr    %cl,%eax
  803ca9:	89 e9                	mov    %ebp,%ecx
  803cab:	89 fa                	mov    %edi,%edx
  803cad:	d3 e6                	shl    %cl,%esi
  803caf:	09 d8                	or     %ebx,%eax
  803cb1:	f7 74 24 08          	divl   0x8(%esp)
  803cb5:	89 d1                	mov    %edx,%ecx
  803cb7:	89 f3                	mov    %esi,%ebx
  803cb9:	f7 64 24 0c          	mull   0xc(%esp)
  803cbd:	89 c6                	mov    %eax,%esi
  803cbf:	89 d7                	mov    %edx,%edi
  803cc1:	39 d1                	cmp    %edx,%ecx
  803cc3:	72 06                	jb     803ccb <__umoddi3+0xfb>
  803cc5:	75 10                	jne    803cd7 <__umoddi3+0x107>
  803cc7:	39 c3                	cmp    %eax,%ebx
  803cc9:	73 0c                	jae    803cd7 <__umoddi3+0x107>
  803ccb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  803ccf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  803cd3:	89 d7                	mov    %edx,%edi
  803cd5:	89 c6                	mov    %eax,%esi
  803cd7:	89 ca                	mov    %ecx,%edx
  803cd9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  803cde:	29 f3                	sub    %esi,%ebx
  803ce0:	19 fa                	sbb    %edi,%edx
  803ce2:	89 d0                	mov    %edx,%eax
  803ce4:	d3 e0                	shl    %cl,%eax
  803ce6:	89 e9                	mov    %ebp,%ecx
  803ce8:	d3 eb                	shr    %cl,%ebx
  803cea:	d3 ea                	shr    %cl,%edx
  803cec:	09 d8                	or     %ebx,%eax
  803cee:	83 c4 1c             	add    $0x1c,%esp
  803cf1:	5b                   	pop    %ebx
  803cf2:	5e                   	pop    %esi
  803cf3:	5f                   	pop    %edi
  803cf4:	5d                   	pop    %ebp
  803cf5:	c3                   	ret    
  803cf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803cfd:	8d 76 00             	lea    0x0(%esi),%esi
  803d00:	89 da                	mov    %ebx,%edx
  803d02:	29 fe                	sub    %edi,%esi
  803d04:	19 c2                	sbb    %eax,%edx
  803d06:	89 f1                	mov    %esi,%ecx
  803d08:	89 c8                	mov    %ecx,%eax
  803d0a:	e9 4b ff ff ff       	jmp    803c5a <__umoddi3+0x8a>
