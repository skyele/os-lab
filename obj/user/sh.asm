
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
  800065:	68 fd 3c 80 00       	push   $0x803cfd
  80006a:	e8 f9 14 00 00       	call   801568 <strchr>
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
  800090:	68 e0 3c 80 00       	push   $0x803ce0
  800095:	e8 76 0b 00 00       	call   800c10 <cprintf>
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	eb 28                	jmp    8000c7 <_gettoken+0x94>
		cprintf("GETTOKEN: %s\n", s);
  80009f:	83 ec 08             	sub    $0x8,%esp
  8000a2:	53                   	push   %ebx
  8000a3:	68 ef 3c 80 00       	push   $0x803cef
  8000a8:	e8 63 0b 00 00       	call   800c10 <cprintf>
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
  8000d4:	68 02 3d 80 00       	push   $0x803d02
  8000d9:	e8 32 0b 00 00       	call   800c10 <cprintf>
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	eb e4                	jmp    8000c7 <_gettoken+0x94>
	if (strchr(SYMBOLS, *s)) {
  8000e3:	83 ec 08             	sub    $0x8,%esp
  8000e6:	0f be c0             	movsbl %al,%eax
  8000e9:	50                   	push   %eax
  8000ea:	68 13 3d 80 00       	push   $0x803d13
  8000ef:	e8 74 14 00 00       	call   801568 <strchr>
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
  800118:	68 07 3d 80 00       	push   $0x803d07
  80011d:	e8 ee 0a 00 00       	call   800c10 <cprintf>
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
  80013c:	68 0f 3d 80 00       	push   $0x803d0f
  800141:	e8 22 14 00 00       	call   801568 <strchr>
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
  80016f:	68 1b 3d 80 00       	push   $0x803d1b
  800174:	e8 97 0a 00 00       	call   800c10 <cprintf>
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
  800269:	e8 73 26 00 00       	call   8028e1 <open>
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
  80029a:	e8 4f 34 00 00       	call   8036ee <pipe>
  80029f:	83 c4 10             	add    $0x10,%esp
  8002a2:	85 c0                	test   %eax,%eax
  8002a4:	0f 88 41 01 00 00    	js     8003eb <runcmd+0x1f1>
			if (debug)
  8002aa:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8002b1:	0f 85 4f 01 00 00    	jne    800406 <runcmd+0x20c>
			if ((r = fork()) < 0) {
  8002b7:	e8 bf 1a 00 00       	call   801d7b <fork>
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
  8002e3:	e8 1d 20 00 00       	call   802305 <close>
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
  800307:	68 25 3d 80 00       	push   $0x803d25
  80030c:	e8 ff 08 00 00       	call   800c10 <cprintf>
				exit();
  800311:	e8 d0 07 00 00       	call   800ae6 <exit>
  800316:	83 c4 10             	add    $0x10,%esp
  800319:	eb da                	jmp    8002f5 <runcmd+0xfb>
				cprintf("syntax error: < not followed by word\n");
  80031b:	83 ec 0c             	sub    $0xc,%esp
  80031e:	68 78 3e 80 00       	push   $0x803e78
  800323:	e8 e8 08 00 00       	call   800c10 <cprintf>
				exit();
  800328:	e8 b9 07 00 00       	call   800ae6 <exit>
  80032d:	83 c4 10             	add    $0x10,%esp
  800330:	e9 29 ff ff ff       	jmp    80025e <runcmd+0x64>
				cprintf("open %s for read: %e", t, fd);
  800335:	83 ec 04             	sub    $0x4,%esp
  800338:	50                   	push   %eax
  800339:	ff 75 a4             	pushl  -0x5c(%ebp)
  80033c:	68 39 3d 80 00       	push   $0x803d39
  800341:	e8 ca 08 00 00       	call   800c10 <cprintf>
				exit();
  800346:	e8 9b 07 00 00       	call   800ae6 <exit>
  80034b:	83 c4 10             	add    $0x10,%esp
				dup(fd, 0);
  80034e:	83 ec 08             	sub    $0x8,%esp
  800351:	6a 00                	push   $0x0
  800353:	53                   	push   %ebx
  800354:	e8 fe 1f 00 00       	call   802357 <dup>
				close(fd);
  800359:	89 1c 24             	mov    %ebx,(%esp)
  80035c:	e8 a4 1f 00 00       	call   802305 <close>
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
  800387:	e8 55 25 00 00       	call   8028e1 <open>
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
  8003a3:	68 a0 3e 80 00       	push   $0x803ea0
  8003a8:	e8 63 08 00 00       	call   800c10 <cprintf>
				exit();
  8003ad:	e8 34 07 00 00       	call   800ae6 <exit>
  8003b2:	83 c4 10             	add    $0x10,%esp
  8003b5:	eb c5                	jmp    80037c <runcmd+0x182>
				cprintf("open %s for write: %e", t, fd);
  8003b7:	83 ec 04             	sub    $0x4,%esp
  8003ba:	50                   	push   %eax
  8003bb:	ff 75 a4             	pushl  -0x5c(%ebp)
  8003be:	68 4e 3d 80 00       	push   $0x803d4e
  8003c3:	e8 48 08 00 00       	call   800c10 <cprintf>
				exit();
  8003c8:	e8 19 07 00 00       	call   800ae6 <exit>
  8003cd:	83 c4 10             	add    $0x10,%esp
				dup(fd, 1);
  8003d0:	83 ec 08             	sub    $0x8,%esp
  8003d3:	6a 01                	push   $0x1
  8003d5:	53                   	push   %ebx
  8003d6:	e8 7c 1f 00 00       	call   802357 <dup>
				close(fd);
  8003db:	89 1c 24             	mov    %ebx,(%esp)
  8003de:	e8 22 1f 00 00       	call   802305 <close>
  8003e3:	83 c4 10             	add    $0x10,%esp
  8003e6:	e9 30 fe ff ff       	jmp    80021b <runcmd+0x21>
				cprintf("pipe: %e", r);
  8003eb:	83 ec 08             	sub    $0x8,%esp
  8003ee:	50                   	push   %eax
  8003ef:	68 64 3d 80 00       	push   $0x803d64
  8003f4:	e8 17 08 00 00       	call   800c10 <cprintf>
				exit();
  8003f9:	e8 e8 06 00 00       	call   800ae6 <exit>
  8003fe:	83 c4 10             	add    $0x10,%esp
  800401:	e9 a4 fe ff ff       	jmp    8002aa <runcmd+0xb0>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  800406:	83 ec 04             	sub    $0x4,%esp
  800409:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  80040f:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  800415:	68 6d 3d 80 00       	push   $0x803d6d
  80041a:	e8 f1 07 00 00       	call   800c10 <cprintf>
  80041f:	83 c4 10             	add    $0x10,%esp
  800422:	e9 90 fe ff ff       	jmp    8002b7 <runcmd+0xbd>
				cprintf("fork: %e", r);
  800427:	83 ec 08             	sub    $0x8,%esp
  80042a:	50                   	push   %eax
  80042b:	68 7a 3d 80 00       	push   $0x803d7a
  800430:	e8 db 07 00 00       	call   800c10 <cprintf>
				exit();
  800435:	e8 ac 06 00 00       	call   800ae6 <exit>
  80043a:	83 c4 10             	add    $0x10,%esp
				if (p[1] != 1) {
  80043d:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  800443:	83 f8 01             	cmp    $0x1,%eax
  800446:	0f 85 cc 00 00 00    	jne    800518 <runcmd+0x31e>
				close(p[0]);
  80044c:	83 ec 0c             	sub    $0xc,%esp
  80044f:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  800455:	e8 ab 1e 00 00       	call   802305 <close>
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
  800490:	e8 05 26 00 00       	call   802a9a <spawn>
  800495:	89 c6                	mov    %eax,%esi
  800497:	83 c4 10             	add    $0x10,%esp
  80049a:	85 c0                	test   %eax,%eax
  80049c:	0f 88 3a 01 00 00    	js     8005dc <runcmd+0x3e2>
	close_all();
  8004a2:	e8 8b 1e 00 00       	call   802332 <close_all>
		if (debug)
  8004a7:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8004ae:	0f 85 75 01 00 00    	jne    800629 <runcmd+0x42f>
		wait(r);
  8004b4:	83 ec 0c             	sub    $0xc,%esp
  8004b7:	56                   	push   %esi
  8004b8:	e8 ae 33 00 00       	call   80386b <wait>
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
  8004d5:	e8 91 33 00 00       	call   80386b <wait>
		if (debug)
  8004da:	83 c4 10             	add    $0x10,%esp
  8004dd:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8004e4:	0f 85 79 01 00 00    	jne    800663 <runcmd+0x469>
	exit();
  8004ea:	e8 f7 05 00 00       	call   800ae6 <exit>
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
  8004fd:	e8 55 1e 00 00       	call   802357 <dup>
					close(p[0]);
  800502:	83 c4 04             	add    $0x4,%esp
  800505:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  80050b:	e8 f5 1d 00 00       	call   802305 <close>
  800510:	83 c4 10             	add    $0x10,%esp
  800513:	e9 c2 fd ff ff       	jmp    8002da <runcmd+0xe0>
					dup(p[1], 1);
  800518:	83 ec 08             	sub    $0x8,%esp
  80051b:	6a 01                	push   $0x1
  80051d:	50                   	push   %eax
  80051e:	e8 34 1e 00 00       	call   802357 <dup>
					close(p[1]);
  800523:	83 c4 04             	add    $0x4,%esp
  800526:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  80052c:	e8 d4 1d 00 00       	call   802305 <close>
  800531:	83 c4 10             	add    $0x10,%esp
  800534:	e9 13 ff ff ff       	jmp    80044c <runcmd+0x252>
			panic("bad return %d from gettoken", c);
  800539:	53                   	push   %ebx
  80053a:	68 83 3d 80 00       	push   $0x803d83
  80053f:	6a 78                	push   $0x78
  800541:	68 9f 3d 80 00       	push   $0x803d9f
  800546:	e8 cf 05 00 00       	call   800b1a <_panic>
		if (debug)
  80054b:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800552:	74 9b                	je     8004ef <runcmd+0x2f5>
			cprintf("EMPTY COMMAND\n");
  800554:	83 ec 0c             	sub    $0xc,%esp
  800557:	68 a9 3d 80 00       	push   $0x803da9
  80055c:	e8 af 06 00 00       	call   800c10 <cprintf>
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
  80057e:	e8 dc 0e 00 00       	call   80145f <strcpy>
		argv[0] = argv0buf;
  800583:	89 75 a8             	mov    %esi,-0x58(%ebp)
  800586:	83 c4 10             	add    $0x10,%esp
  800589:	e9 e3 fe ff ff       	jmp    800471 <runcmd+0x277>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  80058e:	a1 28 64 80 00       	mov    0x806428,%eax
  800593:	8b 40 48             	mov    0x48(%eax),%eax
  800596:	83 ec 08             	sub    $0x8,%esp
  800599:	50                   	push   %eax
  80059a:	68 b8 3d 80 00       	push   $0x803db8
  80059f:	e8 6c 06 00 00       	call   800c10 <cprintf>
  8005a4:	8d 75 a8             	lea    -0x58(%ebp),%esi
		for (i = 0; argv[i]; i++)
  8005a7:	83 c4 10             	add    $0x10,%esp
  8005aa:	eb 11                	jmp    8005bd <runcmd+0x3c3>
			cprintf(" %s", argv[i]);
  8005ac:	83 ec 08             	sub    $0x8,%esp
  8005af:	50                   	push   %eax
  8005b0:	68 40 3e 80 00       	push   $0x803e40
  8005b5:	e8 56 06 00 00       	call   800c10 <cprintf>
  8005ba:	83 c4 10             	add    $0x10,%esp
  8005bd:	83 c6 04             	add    $0x4,%esi
		for (i = 0; argv[i]; i++)
  8005c0:	8b 46 fc             	mov    -0x4(%esi),%eax
  8005c3:	85 c0                	test   %eax,%eax
  8005c5:	75 e5                	jne    8005ac <runcmd+0x3b2>
		cprintf("\n");
  8005c7:	83 ec 0c             	sub    $0xc,%esp
  8005ca:	68 00 3d 80 00       	push   $0x803d00
  8005cf:	e8 3c 06 00 00       	call   800c10 <cprintf>
  8005d4:	83 c4 10             	add    $0x10,%esp
  8005d7:	e9 aa fe ff ff       	jmp    800486 <runcmd+0x28c>
		cprintf("spawn %s: %e\n", argv[0], r);
  8005dc:	83 ec 04             	sub    $0x4,%esp
  8005df:	50                   	push   %eax
  8005e0:	ff 75 a8             	pushl  -0x58(%ebp)
  8005e3:	68 c6 3d 80 00       	push   $0x803dc6
  8005e8:	e8 23 06 00 00       	call   800c10 <cprintf>
	close_all();
  8005ed:	e8 40 1d 00 00       	call   802332 <close_all>
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
  800617:	68 ff 3d 80 00       	push   $0x803dff
  80061c:	e8 ef 05 00 00       	call   800c10 <cprintf>
  800621:	83 c4 10             	add    $0x10,%esp
  800624:	e9 a8 fe ff ff       	jmp    8004d1 <runcmd+0x2d7>
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  800629:	a1 28 64 80 00       	mov    0x806428,%eax
  80062e:	8b 40 48             	mov    0x48(%eax),%eax
  800631:	56                   	push   %esi
  800632:	ff 75 a8             	pushl  -0x58(%ebp)
  800635:	50                   	push   %eax
  800636:	68 d4 3d 80 00       	push   $0x803dd4
  80063b:	e8 d0 05 00 00       	call   800c10 <cprintf>
  800640:	83 c4 10             	add    $0x10,%esp
  800643:	e9 6c fe ff ff       	jmp    8004b4 <runcmd+0x2ba>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800648:	a1 28 64 80 00       	mov    0x806428,%eax
  80064d:	8b 40 48             	mov    0x48(%eax),%eax
  800650:	83 ec 08             	sub    $0x8,%esp
  800653:	50                   	push   %eax
  800654:	68 e9 3d 80 00       	push   $0x803de9
  800659:	e8 b2 05 00 00       	call   800c10 <cprintf>
  80065e:	83 c4 10             	add    $0x10,%esp
  800661:	eb 92                	jmp    8005f5 <runcmd+0x3fb>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800663:	a1 28 64 80 00       	mov    0x806428,%eax
  800668:	8b 40 48             	mov    0x48(%eax),%eax
  80066b:	83 ec 08             	sub    $0x8,%esp
  80066e:	50                   	push   %eax
  80066f:	68 e9 3d 80 00       	push   $0x803de9
  800674:	e8 97 05 00 00       	call   800c10 <cprintf>
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
  800687:	68 c8 3e 80 00       	push   $0x803ec8
  80068c:	e8 7f 05 00 00       	call   800c10 <cprintf>
	exit();
  800691:	e8 50 04 00 00       	call   800ae6 <exit>
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
  8006af:	e8 59 19 00 00       	call   80200d <argstart>
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
  8006e1:	e8 57 19 00 00       	call   80203d <argnext>
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
  800716:	bf 44 3e 80 00       	mov    $0x803e44,%edi
  80071b:	b8 00 00 00 00       	mov    $0x0,%eax
  800720:	0f 44 f8             	cmove  %eax,%edi
  800723:	e9 06 01 00 00       	jmp    80082e <umain+0x193>
		usage();
  800728:	e8 54 ff ff ff       	call   800681 <usage>
  80072d:	eb da                	jmp    800709 <umain+0x6e>
		close(0);
  80072f:	83 ec 0c             	sub    $0xc,%esp
  800732:	6a 00                	push   $0x0
  800734:	e8 cc 1b 00 00       	call   802305 <close>
		if ((r = open(argv[1], O_RDONLY)) < 0)
  800739:	83 c4 08             	add    $0x8,%esp
  80073c:	6a 00                	push   $0x0
  80073e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800741:	ff 70 04             	pushl  0x4(%eax)
  800744:	e8 98 21 00 00       	call   8028e1 <open>
  800749:	83 c4 10             	add    $0x10,%esp
  80074c:	85 c0                	test   %eax,%eax
  80074e:	78 1b                	js     80076b <umain+0xd0>
		assert(r == 0);
  800750:	74 bd                	je     80070f <umain+0x74>
  800752:	68 28 3e 80 00       	push   $0x803e28
  800757:	68 2f 3e 80 00       	push   $0x803e2f
  80075c:	68 29 01 00 00       	push   $0x129
  800761:	68 9f 3d 80 00       	push   $0x803d9f
  800766:	e8 af 03 00 00       	call   800b1a <_panic>
			panic("open %s: %e", argv[1], r);
  80076b:	83 ec 0c             	sub    $0xc,%esp
  80076e:	50                   	push   %eax
  80076f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800772:	ff 70 04             	pushl  0x4(%eax)
  800775:	68 1c 3e 80 00       	push   $0x803e1c
  80077a:	68 28 01 00 00       	push   $0x128
  80077f:	68 9f 3d 80 00       	push   $0x803d9f
  800784:	e8 91 03 00 00       	call   800b1a <_panic>
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
  8007a6:	e8 3b 03 00 00       	call   800ae6 <exit>
  8007ab:	e9 94 00 00 00       	jmp    800844 <umain+0x1a9>
				cprintf("EXITING\n");
  8007b0:	83 ec 0c             	sub    $0xc,%esp
  8007b3:	68 47 3e 80 00       	push   $0x803e47
  8007b8:	e8 53 04 00 00       	call   800c10 <cprintf>
  8007bd:	83 c4 10             	add    $0x10,%esp
  8007c0:	eb e4                	jmp    8007a6 <umain+0x10b>
		}
		if (debug)
			cprintf("LINE: %s\n", buf);
  8007c2:	83 ec 08             	sub    $0x8,%esp
  8007c5:	53                   	push   %ebx
  8007c6:	68 50 3e 80 00       	push   $0x803e50
  8007cb:	e8 40 04 00 00       	call   800c10 <cprintf>
  8007d0:	83 c4 10             	add    $0x10,%esp
  8007d3:	eb 7c                	jmp    800851 <umain+0x1b6>
		if (buf[0] == '#')
			continue;
		if (echocmds)
			printf("# %s\n", buf);
  8007d5:	83 ec 08             	sub    $0x8,%esp
  8007d8:	53                   	push   %ebx
  8007d9:	68 5a 3e 80 00       	push   $0x803e5a
  8007de:	e8 a1 22 00 00       	call   802a84 <printf>
  8007e3:	83 c4 10             	add    $0x10,%esp
  8007e6:	eb 78                	jmp    800860 <umain+0x1c5>
		if (debug)
			cprintf("BEFORE FORK\n");
  8007e8:	83 ec 0c             	sub    $0xc,%esp
  8007eb:	68 60 3e 80 00       	push   $0x803e60
  8007f0:	e8 1b 04 00 00       	call   800c10 <cprintf>
  8007f5:	83 c4 10             	add    $0x10,%esp
  8007f8:	eb 73                	jmp    80086d <umain+0x1d2>
		if ((r = fork()) < 0)
			panic("fork: %e", r);
  8007fa:	50                   	push   %eax
  8007fb:	68 7a 3d 80 00       	push   $0x803d7a
  800800:	68 40 01 00 00       	push   $0x140
  800805:	68 9f 3d 80 00       	push   $0x803d9f
  80080a:	e8 0b 03 00 00       	call   800b1a <_panic>
		if (debug)
			cprintf("FORK: %d\n", r);
  80080f:	83 ec 08             	sub    $0x8,%esp
  800812:	50                   	push   %eax
  800813:	68 6d 3e 80 00       	push   $0x803e6d
  800818:	e8 f3 03 00 00       	call   800c10 <cprintf>
  80081d:	83 c4 10             	add    $0x10,%esp
  800820:	eb 5f                	jmp    800881 <umain+0x1e6>
		if (r == 0) {
			runcmd(buf);
			exit();
		} else
			wait(r);
  800822:	83 ec 0c             	sub    $0xc,%esp
  800825:	56                   	push   %esi
  800826:	e8 40 30 00 00       	call   80386b <wait>
  80082b:	83 c4 10             	add    $0x10,%esp
		buf = readline(interactive ? "$ " : NULL);
  80082e:	83 ec 0c             	sub    $0xc,%esp
  800831:	57                   	push   %edi
  800832:	e8 ff 0a 00 00       	call   801336 <readline>
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
  80086d:	e8 09 15 00 00       	call   801d7b <fork>
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
  80088e:	e8 53 02 00 00       	call   800ae6 <exit>
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
  8008a4:	68 e9 3e 80 00       	push   $0x803ee9
  8008a9:	ff 75 0c             	pushl  0xc(%ebp)
  8008ac:	e8 ae 0b 00 00       	call   80145f <strcpy>
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
  8008ef:	e8 f9 0c 00 00       	call   8015ed <memmove>
		sys_cputs(buf, m);
  8008f4:	83 c4 08             	add    $0x8,%esp
  8008f7:	53                   	push   %ebx
  8008f8:	57                   	push   %edi
  8008f9:	e8 97 0e 00 00       	call   801795 <sys_cputs>
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
  800920:	e8 8e 0e 00 00       	call   8017b3 <sys_cgetc>
  800925:	85 c0                	test   %eax,%eax
  800927:	75 07                	jne    800930 <devcons_read+0x21>
		sys_yield();
  800929:	e8 04 0f 00 00       	call   801832 <sys_yield>
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
  80095c:	e8 34 0e 00 00       	call   801795 <sys_cputs>
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
  800974:	e8 ca 1a 00 00       	call   802443 <read>
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
  80099c:	e8 32 18 00 00       	call   8021d3 <fd_lookup>
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
  8009c5:	e8 b7 17 00 00       	call   802181 <fd_alloc>
  8009ca:	83 c4 10             	add    $0x10,%esp
  8009cd:	85 c0                	test   %eax,%eax
  8009cf:	78 3a                	js     800a0b <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8009d1:	83 ec 04             	sub    $0x4,%esp
  8009d4:	68 07 04 00 00       	push   $0x407
  8009d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8009dc:	6a 00                	push   $0x0
  8009de:	e8 6e 0e 00 00       	call   801851 <sys_page_alloc>
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
  800a03:	e8 52 17 00 00       	call   80215a <fd2num>
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
  800a20:	e8 ee 0d 00 00       	call   801813 <sys_getenvid>
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
  800a45:	74 21                	je     800a68 <libmain+0x5b>
		if(envs[i].env_id == find)
  800a47:	89 d1                	mov    %edx,%ecx
  800a49:	c1 e1 07             	shl    $0x7,%ecx
  800a4c:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800a52:	8b 49 48             	mov    0x48(%ecx),%ecx
  800a55:	39 c1                	cmp    %eax,%ecx
  800a57:	75 e3                	jne    800a3c <libmain+0x2f>
  800a59:	89 d3                	mov    %edx,%ebx
  800a5b:	c1 e3 07             	shl    $0x7,%ebx
  800a5e:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800a64:	89 fe                	mov    %edi,%esi
  800a66:	eb d4                	jmp    800a3c <libmain+0x2f>
  800a68:	89 f0                	mov    %esi,%eax
  800a6a:	84 c0                	test   %al,%al
  800a6c:	74 06                	je     800a74 <libmain+0x67>
  800a6e:	89 1d 28 64 80 00    	mov    %ebx,0x806428
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a74:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a78:	7e 0a                	jle    800a84 <libmain+0x77>
		binaryname = argv[0];
  800a7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7d:	8b 00                	mov    (%eax),%eax
  800a7f:	a3 1c 50 80 00       	mov    %eax,0x80501c

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  800a84:	a1 28 64 80 00       	mov    0x806428,%eax
  800a89:	8b 40 48             	mov    0x48(%eax),%eax
  800a8c:	83 ec 08             	sub    $0x8,%esp
  800a8f:	50                   	push   %eax
  800a90:	68 f5 3e 80 00       	push   $0x803ef5
  800a95:	e8 76 01 00 00       	call   800c10 <cprintf>
	cprintf("before umain\n");
  800a9a:	c7 04 24 13 3f 80 00 	movl   $0x803f13,(%esp)
  800aa1:	e8 6a 01 00 00       	call   800c10 <cprintf>
	// call user main routine
	umain(argc, argv);
  800aa6:	83 c4 08             	add    $0x8,%esp
  800aa9:	ff 75 0c             	pushl  0xc(%ebp)
  800aac:	ff 75 08             	pushl  0x8(%ebp)
  800aaf:	e8 e7 fb ff ff       	call   80069b <umain>
	cprintf("after umain\n");
  800ab4:	c7 04 24 21 3f 80 00 	movl   $0x803f21,(%esp)
  800abb:	e8 50 01 00 00       	call   800c10 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800ac0:	a1 28 64 80 00       	mov    0x806428,%eax
  800ac5:	8b 40 48             	mov    0x48(%eax),%eax
  800ac8:	83 c4 08             	add    $0x8,%esp
  800acb:	50                   	push   %eax
  800acc:	68 2e 3f 80 00       	push   $0x803f2e
  800ad1:	e8 3a 01 00 00       	call   800c10 <cprintf>
	// exit gracefully
	exit();
  800ad6:	e8 0b 00 00 00       	call   800ae6 <exit>
}
  800adb:	83 c4 10             	add    $0x10,%esp
  800ade:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ae1:	5b                   	pop    %ebx
  800ae2:	5e                   	pop    %esi
  800ae3:	5f                   	pop    %edi
  800ae4:	5d                   	pop    %ebp
  800ae5:	c3                   	ret    

00800ae6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800aec:	a1 28 64 80 00       	mov    0x806428,%eax
  800af1:	8b 40 48             	mov    0x48(%eax),%eax
  800af4:	68 58 3f 80 00       	push   $0x803f58
  800af9:	50                   	push   %eax
  800afa:	68 4d 3f 80 00       	push   $0x803f4d
  800aff:	e8 0c 01 00 00       	call   800c10 <cprintf>
	close_all();
  800b04:	e8 29 18 00 00       	call   802332 <close_all>
	sys_env_destroy(0);
  800b09:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800b10:	e8 bd 0c 00 00       	call   8017d2 <sys_env_destroy>
}
  800b15:	83 c4 10             	add    $0x10,%esp
  800b18:	c9                   	leave  
  800b19:	c3                   	ret    

00800b1a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800b1a:	55                   	push   %ebp
  800b1b:	89 e5                	mov    %esp,%ebp
  800b1d:	56                   	push   %esi
  800b1e:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800b1f:	a1 28 64 80 00       	mov    0x806428,%eax
  800b24:	8b 40 48             	mov    0x48(%eax),%eax
  800b27:	83 ec 04             	sub    $0x4,%esp
  800b2a:	68 84 3f 80 00       	push   $0x803f84
  800b2f:	50                   	push   %eax
  800b30:	68 4d 3f 80 00       	push   $0x803f4d
  800b35:	e8 d6 00 00 00       	call   800c10 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800b3a:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800b3d:	8b 35 1c 50 80 00    	mov    0x80501c,%esi
  800b43:	e8 cb 0c 00 00       	call   801813 <sys_getenvid>
  800b48:	83 c4 04             	add    $0x4,%esp
  800b4b:	ff 75 0c             	pushl  0xc(%ebp)
  800b4e:	ff 75 08             	pushl  0x8(%ebp)
  800b51:	56                   	push   %esi
  800b52:	50                   	push   %eax
  800b53:	68 60 3f 80 00       	push   $0x803f60
  800b58:	e8 b3 00 00 00       	call   800c10 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800b5d:	83 c4 18             	add    $0x18,%esp
  800b60:	53                   	push   %ebx
  800b61:	ff 75 10             	pushl  0x10(%ebp)
  800b64:	e8 56 00 00 00       	call   800bbf <vcprintf>
	cprintf("\n");
  800b69:	c7 04 24 00 3d 80 00 	movl   $0x803d00,(%esp)
  800b70:	e8 9b 00 00 00       	call   800c10 <cprintf>
  800b75:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800b78:	cc                   	int3   
  800b79:	eb fd                	jmp    800b78 <_panic+0x5e>

00800b7b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	53                   	push   %ebx
  800b7f:	83 ec 04             	sub    $0x4,%esp
  800b82:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800b85:	8b 13                	mov    (%ebx),%edx
  800b87:	8d 42 01             	lea    0x1(%edx),%eax
  800b8a:	89 03                	mov    %eax,(%ebx)
  800b8c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b8f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800b93:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b98:	74 09                	je     800ba3 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800b9a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800b9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ba1:	c9                   	leave  
  800ba2:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800ba3:	83 ec 08             	sub    $0x8,%esp
  800ba6:	68 ff 00 00 00       	push   $0xff
  800bab:	8d 43 08             	lea    0x8(%ebx),%eax
  800bae:	50                   	push   %eax
  800baf:	e8 e1 0b 00 00       	call   801795 <sys_cputs>
		b->idx = 0;
  800bb4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800bba:	83 c4 10             	add    $0x10,%esp
  800bbd:	eb db                	jmp    800b9a <putch+0x1f>

00800bbf <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800bbf:	55                   	push   %ebp
  800bc0:	89 e5                	mov    %esp,%ebp
  800bc2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800bc8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800bcf:	00 00 00 
	b.cnt = 0;
  800bd2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800bd9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800bdc:	ff 75 0c             	pushl  0xc(%ebp)
  800bdf:	ff 75 08             	pushl  0x8(%ebp)
  800be2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800be8:	50                   	push   %eax
  800be9:	68 7b 0b 80 00       	push   $0x800b7b
  800bee:	e8 4a 01 00 00       	call   800d3d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800bf3:	83 c4 08             	add    $0x8,%esp
  800bf6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800bfc:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800c02:	50                   	push   %eax
  800c03:	e8 8d 0b 00 00       	call   801795 <sys_cputs>

	return b.cnt;
}
  800c08:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800c0e:	c9                   	leave  
  800c0f:	c3                   	ret    

00800c10 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800c10:	55                   	push   %ebp
  800c11:	89 e5                	mov    %esp,%ebp
  800c13:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800c16:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800c19:	50                   	push   %eax
  800c1a:	ff 75 08             	pushl  0x8(%ebp)
  800c1d:	e8 9d ff ff ff       	call   800bbf <vcprintf>
	va_end(ap);

	return cnt;
}
  800c22:	c9                   	leave  
  800c23:	c3                   	ret    

00800c24 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	57                   	push   %edi
  800c28:	56                   	push   %esi
  800c29:	53                   	push   %ebx
  800c2a:	83 ec 1c             	sub    $0x1c,%esp
  800c2d:	89 c6                	mov    %eax,%esi
  800c2f:	89 d7                	mov    %edx,%edi
  800c31:	8b 45 08             	mov    0x8(%ebp),%eax
  800c34:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c37:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800c3a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800c3d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c40:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800c43:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800c47:	74 2c                	je     800c75 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800c49:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c4c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800c53:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c56:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800c59:	39 c2                	cmp    %eax,%edx
  800c5b:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800c5e:	73 43                	jae    800ca3 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800c60:	83 eb 01             	sub    $0x1,%ebx
  800c63:	85 db                	test   %ebx,%ebx
  800c65:	7e 6c                	jle    800cd3 <printnum+0xaf>
				putch(padc, putdat);
  800c67:	83 ec 08             	sub    $0x8,%esp
  800c6a:	57                   	push   %edi
  800c6b:	ff 75 18             	pushl  0x18(%ebp)
  800c6e:	ff d6                	call   *%esi
  800c70:	83 c4 10             	add    $0x10,%esp
  800c73:	eb eb                	jmp    800c60 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800c75:	83 ec 0c             	sub    $0xc,%esp
  800c78:	6a 20                	push   $0x20
  800c7a:	6a 00                	push   $0x0
  800c7c:	50                   	push   %eax
  800c7d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c80:	ff 75 e0             	pushl  -0x20(%ebp)
  800c83:	89 fa                	mov    %edi,%edx
  800c85:	89 f0                	mov    %esi,%eax
  800c87:	e8 98 ff ff ff       	call   800c24 <printnum>
		while (--width > 0)
  800c8c:	83 c4 20             	add    $0x20,%esp
  800c8f:	83 eb 01             	sub    $0x1,%ebx
  800c92:	85 db                	test   %ebx,%ebx
  800c94:	7e 65                	jle    800cfb <printnum+0xd7>
			putch(padc, putdat);
  800c96:	83 ec 08             	sub    $0x8,%esp
  800c99:	57                   	push   %edi
  800c9a:	6a 20                	push   $0x20
  800c9c:	ff d6                	call   *%esi
  800c9e:	83 c4 10             	add    $0x10,%esp
  800ca1:	eb ec                	jmp    800c8f <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800ca3:	83 ec 0c             	sub    $0xc,%esp
  800ca6:	ff 75 18             	pushl  0x18(%ebp)
  800ca9:	83 eb 01             	sub    $0x1,%ebx
  800cac:	53                   	push   %ebx
  800cad:	50                   	push   %eax
  800cae:	83 ec 08             	sub    $0x8,%esp
  800cb1:	ff 75 dc             	pushl  -0x24(%ebp)
  800cb4:	ff 75 d8             	pushl  -0x28(%ebp)
  800cb7:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cba:	ff 75 e0             	pushl  -0x20(%ebp)
  800cbd:	e8 ce 2d 00 00       	call   803a90 <__udivdi3>
  800cc2:	83 c4 18             	add    $0x18,%esp
  800cc5:	52                   	push   %edx
  800cc6:	50                   	push   %eax
  800cc7:	89 fa                	mov    %edi,%edx
  800cc9:	89 f0                	mov    %esi,%eax
  800ccb:	e8 54 ff ff ff       	call   800c24 <printnum>
  800cd0:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800cd3:	83 ec 08             	sub    $0x8,%esp
  800cd6:	57                   	push   %edi
  800cd7:	83 ec 04             	sub    $0x4,%esp
  800cda:	ff 75 dc             	pushl  -0x24(%ebp)
  800cdd:	ff 75 d8             	pushl  -0x28(%ebp)
  800ce0:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ce3:	ff 75 e0             	pushl  -0x20(%ebp)
  800ce6:	e8 b5 2e 00 00       	call   803ba0 <__umoddi3>
  800ceb:	83 c4 14             	add    $0x14,%esp
  800cee:	0f be 80 8b 3f 80 00 	movsbl 0x803f8b(%eax),%eax
  800cf5:	50                   	push   %eax
  800cf6:	ff d6                	call   *%esi
  800cf8:	83 c4 10             	add    $0x10,%esp
	}
}
  800cfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfe:	5b                   	pop    %ebx
  800cff:	5e                   	pop    %esi
  800d00:	5f                   	pop    %edi
  800d01:	5d                   	pop    %ebp
  800d02:	c3                   	ret    

00800d03 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
  800d06:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800d09:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800d0d:	8b 10                	mov    (%eax),%edx
  800d0f:	3b 50 04             	cmp    0x4(%eax),%edx
  800d12:	73 0a                	jae    800d1e <sprintputch+0x1b>
		*b->buf++ = ch;
  800d14:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d17:	89 08                	mov    %ecx,(%eax)
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	88 02                	mov    %al,(%edx)
}
  800d1e:	5d                   	pop    %ebp
  800d1f:	c3                   	ret    

00800d20 <printfmt>:
{
  800d20:	55                   	push   %ebp
  800d21:	89 e5                	mov    %esp,%ebp
  800d23:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800d26:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800d29:	50                   	push   %eax
  800d2a:	ff 75 10             	pushl  0x10(%ebp)
  800d2d:	ff 75 0c             	pushl  0xc(%ebp)
  800d30:	ff 75 08             	pushl  0x8(%ebp)
  800d33:	e8 05 00 00 00       	call   800d3d <vprintfmt>
}
  800d38:	83 c4 10             	add    $0x10,%esp
  800d3b:	c9                   	leave  
  800d3c:	c3                   	ret    

00800d3d <vprintfmt>:
{
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
  800d40:	57                   	push   %edi
  800d41:	56                   	push   %esi
  800d42:	53                   	push   %ebx
  800d43:	83 ec 3c             	sub    $0x3c,%esp
  800d46:	8b 75 08             	mov    0x8(%ebp),%esi
  800d49:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800d4c:	8b 7d 10             	mov    0x10(%ebp),%edi
  800d4f:	e9 32 04 00 00       	jmp    801186 <vprintfmt+0x449>
		padc = ' ';
  800d54:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800d58:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800d5f:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800d66:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800d6d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d74:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800d7b:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800d80:	8d 47 01             	lea    0x1(%edi),%eax
  800d83:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d86:	0f b6 17             	movzbl (%edi),%edx
  800d89:	8d 42 dd             	lea    -0x23(%edx),%eax
  800d8c:	3c 55                	cmp    $0x55,%al
  800d8e:	0f 87 12 05 00 00    	ja     8012a6 <vprintfmt+0x569>
  800d94:	0f b6 c0             	movzbl %al,%eax
  800d97:	ff 24 85 60 41 80 00 	jmp    *0x804160(,%eax,4)
  800d9e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800da1:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800da5:	eb d9                	jmp    800d80 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800da7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800daa:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800dae:	eb d0                	jmp    800d80 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800db0:	0f b6 d2             	movzbl %dl,%edx
  800db3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800db6:	b8 00 00 00 00       	mov    $0x0,%eax
  800dbb:	89 75 08             	mov    %esi,0x8(%ebp)
  800dbe:	eb 03                	jmp    800dc3 <vprintfmt+0x86>
  800dc0:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800dc3:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800dc6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800dca:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800dcd:	8d 72 d0             	lea    -0x30(%edx),%esi
  800dd0:	83 fe 09             	cmp    $0x9,%esi
  800dd3:	76 eb                	jbe    800dc0 <vprintfmt+0x83>
  800dd5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800dd8:	8b 75 08             	mov    0x8(%ebp),%esi
  800ddb:	eb 14                	jmp    800df1 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800ddd:	8b 45 14             	mov    0x14(%ebp),%eax
  800de0:	8b 00                	mov    (%eax),%eax
  800de2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800de5:	8b 45 14             	mov    0x14(%ebp),%eax
  800de8:	8d 40 04             	lea    0x4(%eax),%eax
  800deb:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800dee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800df1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800df5:	79 89                	jns    800d80 <vprintfmt+0x43>
				width = precision, precision = -1;
  800df7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800dfa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800dfd:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800e04:	e9 77 ff ff ff       	jmp    800d80 <vprintfmt+0x43>
  800e09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e0c:	85 c0                	test   %eax,%eax
  800e0e:	0f 48 c1             	cmovs  %ecx,%eax
  800e11:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800e14:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800e17:	e9 64 ff ff ff       	jmp    800d80 <vprintfmt+0x43>
  800e1c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800e1f:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800e26:	e9 55 ff ff ff       	jmp    800d80 <vprintfmt+0x43>
			lflag++;
  800e2b:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800e2f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800e32:	e9 49 ff ff ff       	jmp    800d80 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800e37:	8b 45 14             	mov    0x14(%ebp),%eax
  800e3a:	8d 78 04             	lea    0x4(%eax),%edi
  800e3d:	83 ec 08             	sub    $0x8,%esp
  800e40:	53                   	push   %ebx
  800e41:	ff 30                	pushl  (%eax)
  800e43:	ff d6                	call   *%esi
			break;
  800e45:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800e48:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800e4b:	e9 33 03 00 00       	jmp    801183 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800e50:	8b 45 14             	mov    0x14(%ebp),%eax
  800e53:	8d 78 04             	lea    0x4(%eax),%edi
  800e56:	8b 00                	mov    (%eax),%eax
  800e58:	99                   	cltd   
  800e59:	31 d0                	xor    %edx,%eax
  800e5b:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800e5d:	83 f8 11             	cmp    $0x11,%eax
  800e60:	7f 23                	jg     800e85 <vprintfmt+0x148>
  800e62:	8b 14 85 c0 42 80 00 	mov    0x8042c0(,%eax,4),%edx
  800e69:	85 d2                	test   %edx,%edx
  800e6b:	74 18                	je     800e85 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800e6d:	52                   	push   %edx
  800e6e:	68 41 3e 80 00       	push   $0x803e41
  800e73:	53                   	push   %ebx
  800e74:	56                   	push   %esi
  800e75:	e8 a6 fe ff ff       	call   800d20 <printfmt>
  800e7a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800e7d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800e80:	e9 fe 02 00 00       	jmp    801183 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800e85:	50                   	push   %eax
  800e86:	68 a3 3f 80 00       	push   $0x803fa3
  800e8b:	53                   	push   %ebx
  800e8c:	56                   	push   %esi
  800e8d:	e8 8e fe ff ff       	call   800d20 <printfmt>
  800e92:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800e95:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800e98:	e9 e6 02 00 00       	jmp    801183 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800e9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea0:	83 c0 04             	add    $0x4,%eax
  800ea3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800ea6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea9:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800eab:	85 c9                	test   %ecx,%ecx
  800ead:	b8 9c 3f 80 00       	mov    $0x803f9c,%eax
  800eb2:	0f 45 c1             	cmovne %ecx,%eax
  800eb5:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800eb8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ebc:	7e 06                	jle    800ec4 <vprintfmt+0x187>
  800ebe:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800ec2:	75 0d                	jne    800ed1 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ec4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800ec7:	89 c7                	mov    %eax,%edi
  800ec9:	03 45 e0             	add    -0x20(%ebp),%eax
  800ecc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800ecf:	eb 53                	jmp    800f24 <vprintfmt+0x1e7>
  800ed1:	83 ec 08             	sub    $0x8,%esp
  800ed4:	ff 75 d8             	pushl  -0x28(%ebp)
  800ed7:	50                   	push   %eax
  800ed8:	e8 61 05 00 00       	call   80143e <strnlen>
  800edd:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800ee0:	29 c1                	sub    %eax,%ecx
  800ee2:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800ee5:	83 c4 10             	add    $0x10,%esp
  800ee8:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800eea:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800eee:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800ef1:	eb 0f                	jmp    800f02 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800ef3:	83 ec 08             	sub    $0x8,%esp
  800ef6:	53                   	push   %ebx
  800ef7:	ff 75 e0             	pushl  -0x20(%ebp)
  800efa:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800efc:	83 ef 01             	sub    $0x1,%edi
  800eff:	83 c4 10             	add    $0x10,%esp
  800f02:	85 ff                	test   %edi,%edi
  800f04:	7f ed                	jg     800ef3 <vprintfmt+0x1b6>
  800f06:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800f09:	85 c9                	test   %ecx,%ecx
  800f0b:	b8 00 00 00 00       	mov    $0x0,%eax
  800f10:	0f 49 c1             	cmovns %ecx,%eax
  800f13:	29 c1                	sub    %eax,%ecx
  800f15:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800f18:	eb aa                	jmp    800ec4 <vprintfmt+0x187>
					putch(ch, putdat);
  800f1a:	83 ec 08             	sub    $0x8,%esp
  800f1d:	53                   	push   %ebx
  800f1e:	52                   	push   %edx
  800f1f:	ff d6                	call   *%esi
  800f21:	83 c4 10             	add    $0x10,%esp
  800f24:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800f27:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f29:	83 c7 01             	add    $0x1,%edi
  800f2c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800f30:	0f be d0             	movsbl %al,%edx
  800f33:	85 d2                	test   %edx,%edx
  800f35:	74 4b                	je     800f82 <vprintfmt+0x245>
  800f37:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800f3b:	78 06                	js     800f43 <vprintfmt+0x206>
  800f3d:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800f41:	78 1e                	js     800f61 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800f43:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800f47:	74 d1                	je     800f1a <vprintfmt+0x1dd>
  800f49:	0f be c0             	movsbl %al,%eax
  800f4c:	83 e8 20             	sub    $0x20,%eax
  800f4f:	83 f8 5e             	cmp    $0x5e,%eax
  800f52:	76 c6                	jbe    800f1a <vprintfmt+0x1dd>
					putch('?', putdat);
  800f54:	83 ec 08             	sub    $0x8,%esp
  800f57:	53                   	push   %ebx
  800f58:	6a 3f                	push   $0x3f
  800f5a:	ff d6                	call   *%esi
  800f5c:	83 c4 10             	add    $0x10,%esp
  800f5f:	eb c3                	jmp    800f24 <vprintfmt+0x1e7>
  800f61:	89 cf                	mov    %ecx,%edi
  800f63:	eb 0e                	jmp    800f73 <vprintfmt+0x236>
				putch(' ', putdat);
  800f65:	83 ec 08             	sub    $0x8,%esp
  800f68:	53                   	push   %ebx
  800f69:	6a 20                	push   $0x20
  800f6b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800f6d:	83 ef 01             	sub    $0x1,%edi
  800f70:	83 c4 10             	add    $0x10,%esp
  800f73:	85 ff                	test   %edi,%edi
  800f75:	7f ee                	jg     800f65 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800f77:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800f7a:	89 45 14             	mov    %eax,0x14(%ebp)
  800f7d:	e9 01 02 00 00       	jmp    801183 <vprintfmt+0x446>
  800f82:	89 cf                	mov    %ecx,%edi
  800f84:	eb ed                	jmp    800f73 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800f86:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800f89:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800f90:	e9 eb fd ff ff       	jmp    800d80 <vprintfmt+0x43>
	if (lflag >= 2)
  800f95:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800f99:	7f 21                	jg     800fbc <vprintfmt+0x27f>
	else if (lflag)
  800f9b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800f9f:	74 68                	je     801009 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800fa1:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa4:	8b 00                	mov    (%eax),%eax
  800fa6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800fa9:	89 c1                	mov    %eax,%ecx
  800fab:	c1 f9 1f             	sar    $0x1f,%ecx
  800fae:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800fb1:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb4:	8d 40 04             	lea    0x4(%eax),%eax
  800fb7:	89 45 14             	mov    %eax,0x14(%ebp)
  800fba:	eb 17                	jmp    800fd3 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800fbc:	8b 45 14             	mov    0x14(%ebp),%eax
  800fbf:	8b 50 04             	mov    0x4(%eax),%edx
  800fc2:	8b 00                	mov    (%eax),%eax
  800fc4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800fc7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800fca:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcd:	8d 40 08             	lea    0x8(%eax),%eax
  800fd0:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800fd3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800fd6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800fd9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800fdc:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800fdf:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800fe3:	78 3f                	js     801024 <vprintfmt+0x2e7>
			base = 10;
  800fe5:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800fea:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800fee:	0f 84 71 01 00 00    	je     801165 <vprintfmt+0x428>
				putch('+', putdat);
  800ff4:	83 ec 08             	sub    $0x8,%esp
  800ff7:	53                   	push   %ebx
  800ff8:	6a 2b                	push   $0x2b
  800ffa:	ff d6                	call   *%esi
  800ffc:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800fff:	b8 0a 00 00 00       	mov    $0xa,%eax
  801004:	e9 5c 01 00 00       	jmp    801165 <vprintfmt+0x428>
		return va_arg(*ap, int);
  801009:	8b 45 14             	mov    0x14(%ebp),%eax
  80100c:	8b 00                	mov    (%eax),%eax
  80100e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801011:	89 c1                	mov    %eax,%ecx
  801013:	c1 f9 1f             	sar    $0x1f,%ecx
  801016:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  801019:	8b 45 14             	mov    0x14(%ebp),%eax
  80101c:	8d 40 04             	lea    0x4(%eax),%eax
  80101f:	89 45 14             	mov    %eax,0x14(%ebp)
  801022:	eb af                	jmp    800fd3 <vprintfmt+0x296>
				putch('-', putdat);
  801024:	83 ec 08             	sub    $0x8,%esp
  801027:	53                   	push   %ebx
  801028:	6a 2d                	push   $0x2d
  80102a:	ff d6                	call   *%esi
				num = -(long long) num;
  80102c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80102f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801032:	f7 d8                	neg    %eax
  801034:	83 d2 00             	adc    $0x0,%edx
  801037:	f7 da                	neg    %edx
  801039:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80103c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80103f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801042:	b8 0a 00 00 00       	mov    $0xa,%eax
  801047:	e9 19 01 00 00       	jmp    801165 <vprintfmt+0x428>
	if (lflag >= 2)
  80104c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  801050:	7f 29                	jg     80107b <vprintfmt+0x33e>
	else if (lflag)
  801052:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  801056:	74 44                	je     80109c <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  801058:	8b 45 14             	mov    0x14(%ebp),%eax
  80105b:	8b 00                	mov    (%eax),%eax
  80105d:	ba 00 00 00 00       	mov    $0x0,%edx
  801062:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801065:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801068:	8b 45 14             	mov    0x14(%ebp),%eax
  80106b:	8d 40 04             	lea    0x4(%eax),%eax
  80106e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801071:	b8 0a 00 00 00       	mov    $0xa,%eax
  801076:	e9 ea 00 00 00       	jmp    801165 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80107b:	8b 45 14             	mov    0x14(%ebp),%eax
  80107e:	8b 50 04             	mov    0x4(%eax),%edx
  801081:	8b 00                	mov    (%eax),%eax
  801083:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801086:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801089:	8b 45 14             	mov    0x14(%ebp),%eax
  80108c:	8d 40 08             	lea    0x8(%eax),%eax
  80108f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801092:	b8 0a 00 00 00       	mov    $0xa,%eax
  801097:	e9 c9 00 00 00       	jmp    801165 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80109c:	8b 45 14             	mov    0x14(%ebp),%eax
  80109f:	8b 00                	mov    (%eax),%eax
  8010a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8010a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8010a9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8010ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8010af:	8d 40 04             	lea    0x4(%eax),%eax
  8010b2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8010b5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010ba:	e9 a6 00 00 00       	jmp    801165 <vprintfmt+0x428>
			putch('0', putdat);
  8010bf:	83 ec 08             	sub    $0x8,%esp
  8010c2:	53                   	push   %ebx
  8010c3:	6a 30                	push   $0x30
  8010c5:	ff d6                	call   *%esi
	if (lflag >= 2)
  8010c7:	83 c4 10             	add    $0x10,%esp
  8010ca:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8010ce:	7f 26                	jg     8010f6 <vprintfmt+0x3b9>
	else if (lflag)
  8010d0:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8010d4:	74 3e                	je     801114 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8010d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8010d9:	8b 00                	mov    (%eax),%eax
  8010db:	ba 00 00 00 00       	mov    $0x0,%edx
  8010e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8010e3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8010e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8010e9:	8d 40 04             	lea    0x4(%eax),%eax
  8010ec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8010ef:	b8 08 00 00 00       	mov    $0x8,%eax
  8010f4:	eb 6f                	jmp    801165 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8010f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f9:	8b 50 04             	mov    0x4(%eax),%edx
  8010fc:	8b 00                	mov    (%eax),%eax
  8010fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801101:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801104:	8b 45 14             	mov    0x14(%ebp),%eax
  801107:	8d 40 08             	lea    0x8(%eax),%eax
  80110a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80110d:	b8 08 00 00 00       	mov    $0x8,%eax
  801112:	eb 51                	jmp    801165 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  801114:	8b 45 14             	mov    0x14(%ebp),%eax
  801117:	8b 00                	mov    (%eax),%eax
  801119:	ba 00 00 00 00       	mov    $0x0,%edx
  80111e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801121:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801124:	8b 45 14             	mov    0x14(%ebp),%eax
  801127:	8d 40 04             	lea    0x4(%eax),%eax
  80112a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80112d:	b8 08 00 00 00       	mov    $0x8,%eax
  801132:	eb 31                	jmp    801165 <vprintfmt+0x428>
			putch('0', putdat);
  801134:	83 ec 08             	sub    $0x8,%esp
  801137:	53                   	push   %ebx
  801138:	6a 30                	push   $0x30
  80113a:	ff d6                	call   *%esi
			putch('x', putdat);
  80113c:	83 c4 08             	add    $0x8,%esp
  80113f:	53                   	push   %ebx
  801140:	6a 78                	push   $0x78
  801142:	ff d6                	call   *%esi
			num = (unsigned long long)
  801144:	8b 45 14             	mov    0x14(%ebp),%eax
  801147:	8b 00                	mov    (%eax),%eax
  801149:	ba 00 00 00 00       	mov    $0x0,%edx
  80114e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801151:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  801154:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801157:	8b 45 14             	mov    0x14(%ebp),%eax
  80115a:	8d 40 04             	lea    0x4(%eax),%eax
  80115d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801160:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801165:	83 ec 0c             	sub    $0xc,%esp
  801168:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80116c:	52                   	push   %edx
  80116d:	ff 75 e0             	pushl  -0x20(%ebp)
  801170:	50                   	push   %eax
  801171:	ff 75 dc             	pushl  -0x24(%ebp)
  801174:	ff 75 d8             	pushl  -0x28(%ebp)
  801177:	89 da                	mov    %ebx,%edx
  801179:	89 f0                	mov    %esi,%eax
  80117b:	e8 a4 fa ff ff       	call   800c24 <printnum>
			break;
  801180:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801183:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801186:	83 c7 01             	add    $0x1,%edi
  801189:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80118d:	83 f8 25             	cmp    $0x25,%eax
  801190:	0f 84 be fb ff ff    	je     800d54 <vprintfmt+0x17>
			if (ch == '\0')
  801196:	85 c0                	test   %eax,%eax
  801198:	0f 84 28 01 00 00    	je     8012c6 <vprintfmt+0x589>
			putch(ch, putdat);
  80119e:	83 ec 08             	sub    $0x8,%esp
  8011a1:	53                   	push   %ebx
  8011a2:	50                   	push   %eax
  8011a3:	ff d6                	call   *%esi
  8011a5:	83 c4 10             	add    $0x10,%esp
  8011a8:	eb dc                	jmp    801186 <vprintfmt+0x449>
	if (lflag >= 2)
  8011aa:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8011ae:	7f 26                	jg     8011d6 <vprintfmt+0x499>
	else if (lflag)
  8011b0:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8011b4:	74 41                	je     8011f7 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8011b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011b9:	8b 00                	mov    (%eax),%eax
  8011bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8011c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8011c3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8011c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c9:	8d 40 04             	lea    0x4(%eax),%eax
  8011cc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8011cf:	b8 10 00 00 00       	mov    $0x10,%eax
  8011d4:	eb 8f                	jmp    801165 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8011d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d9:	8b 50 04             	mov    0x4(%eax),%edx
  8011dc:	8b 00                	mov    (%eax),%eax
  8011de:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8011e1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8011e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e7:	8d 40 08             	lea    0x8(%eax),%eax
  8011ea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8011ed:	b8 10 00 00 00       	mov    $0x10,%eax
  8011f2:	e9 6e ff ff ff       	jmp    801165 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8011f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8011fa:	8b 00                	mov    (%eax),%eax
  8011fc:	ba 00 00 00 00       	mov    $0x0,%edx
  801201:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801204:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801207:	8b 45 14             	mov    0x14(%ebp),%eax
  80120a:	8d 40 04             	lea    0x4(%eax),%eax
  80120d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801210:	b8 10 00 00 00       	mov    $0x10,%eax
  801215:	e9 4b ff ff ff       	jmp    801165 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80121a:	8b 45 14             	mov    0x14(%ebp),%eax
  80121d:	83 c0 04             	add    $0x4,%eax
  801220:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801223:	8b 45 14             	mov    0x14(%ebp),%eax
  801226:	8b 00                	mov    (%eax),%eax
  801228:	85 c0                	test   %eax,%eax
  80122a:	74 14                	je     801240 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80122c:	8b 13                	mov    (%ebx),%edx
  80122e:	83 fa 7f             	cmp    $0x7f,%edx
  801231:	7f 37                	jg     80126a <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  801233:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  801235:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801238:	89 45 14             	mov    %eax,0x14(%ebp)
  80123b:	e9 43 ff ff ff       	jmp    801183 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  801240:	b8 0a 00 00 00       	mov    $0xa,%eax
  801245:	bf c1 40 80 00       	mov    $0x8040c1,%edi
							putch(ch, putdat);
  80124a:	83 ec 08             	sub    $0x8,%esp
  80124d:	53                   	push   %ebx
  80124e:	50                   	push   %eax
  80124f:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  801251:	83 c7 01             	add    $0x1,%edi
  801254:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  801258:	83 c4 10             	add    $0x10,%esp
  80125b:	85 c0                	test   %eax,%eax
  80125d:	75 eb                	jne    80124a <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80125f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801262:	89 45 14             	mov    %eax,0x14(%ebp)
  801265:	e9 19 ff ff ff       	jmp    801183 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80126a:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80126c:	b8 0a 00 00 00       	mov    $0xa,%eax
  801271:	bf f9 40 80 00       	mov    $0x8040f9,%edi
							putch(ch, putdat);
  801276:	83 ec 08             	sub    $0x8,%esp
  801279:	53                   	push   %ebx
  80127a:	50                   	push   %eax
  80127b:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80127d:	83 c7 01             	add    $0x1,%edi
  801280:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  801284:	83 c4 10             	add    $0x10,%esp
  801287:	85 c0                	test   %eax,%eax
  801289:	75 eb                	jne    801276 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80128b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80128e:	89 45 14             	mov    %eax,0x14(%ebp)
  801291:	e9 ed fe ff ff       	jmp    801183 <vprintfmt+0x446>
			putch(ch, putdat);
  801296:	83 ec 08             	sub    $0x8,%esp
  801299:	53                   	push   %ebx
  80129a:	6a 25                	push   $0x25
  80129c:	ff d6                	call   *%esi
			break;
  80129e:	83 c4 10             	add    $0x10,%esp
  8012a1:	e9 dd fe ff ff       	jmp    801183 <vprintfmt+0x446>
			putch('%', putdat);
  8012a6:	83 ec 08             	sub    $0x8,%esp
  8012a9:	53                   	push   %ebx
  8012aa:	6a 25                	push   $0x25
  8012ac:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8012ae:	83 c4 10             	add    $0x10,%esp
  8012b1:	89 f8                	mov    %edi,%eax
  8012b3:	eb 03                	jmp    8012b8 <vprintfmt+0x57b>
  8012b5:	83 e8 01             	sub    $0x1,%eax
  8012b8:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8012bc:	75 f7                	jne    8012b5 <vprintfmt+0x578>
  8012be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8012c1:	e9 bd fe ff ff       	jmp    801183 <vprintfmt+0x446>
}
  8012c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012c9:	5b                   	pop    %ebx
  8012ca:	5e                   	pop    %esi
  8012cb:	5f                   	pop    %edi
  8012cc:	5d                   	pop    %ebp
  8012cd:	c3                   	ret    

008012ce <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	83 ec 18             	sub    $0x18,%esp
  8012d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d7:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8012da:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8012dd:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8012e1:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8012e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8012eb:	85 c0                	test   %eax,%eax
  8012ed:	74 26                	je     801315 <vsnprintf+0x47>
  8012ef:	85 d2                	test   %edx,%edx
  8012f1:	7e 22                	jle    801315 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8012f3:	ff 75 14             	pushl  0x14(%ebp)
  8012f6:	ff 75 10             	pushl  0x10(%ebp)
  8012f9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8012fc:	50                   	push   %eax
  8012fd:	68 03 0d 80 00       	push   $0x800d03
  801302:	e8 36 fa ff ff       	call   800d3d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801307:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80130a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80130d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801310:	83 c4 10             	add    $0x10,%esp
}
  801313:	c9                   	leave  
  801314:	c3                   	ret    
		return -E_INVAL;
  801315:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80131a:	eb f7                	jmp    801313 <vsnprintf+0x45>

0080131c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801322:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801325:	50                   	push   %eax
  801326:	ff 75 10             	pushl  0x10(%ebp)
  801329:	ff 75 0c             	pushl  0xc(%ebp)
  80132c:	ff 75 08             	pushl  0x8(%ebp)
  80132f:	e8 9a ff ff ff       	call   8012ce <vsnprintf>
	va_end(ap);

	return rc;
}
  801334:	c9                   	leave  
  801335:	c3                   	ret    

00801336 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  801336:	55                   	push   %ebp
  801337:	89 e5                	mov    %esp,%ebp
  801339:	57                   	push   %edi
  80133a:	56                   	push   %esi
  80133b:	53                   	push   %ebx
  80133c:	83 ec 0c             	sub    $0xc,%esp
  80133f:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  801342:	85 c0                	test   %eax,%eax
  801344:	74 13                	je     801359 <readline+0x23>
		fprintf(1, "%s", prompt);
  801346:	83 ec 04             	sub    $0x4,%esp
  801349:	50                   	push   %eax
  80134a:	68 41 3e 80 00       	push   $0x803e41
  80134f:	6a 01                	push   $0x1
  801351:	e8 17 17 00 00       	call   802a6d <fprintf>
  801356:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
  801359:	83 ec 0c             	sub    $0xc,%esp
  80135c:	6a 00                	push   $0x0
  80135e:	e8 2c f6 ff ff       	call   80098f <iscons>
  801363:	89 c7                	mov    %eax,%edi
  801365:	83 c4 10             	add    $0x10,%esp
	i = 0;
  801368:	be 00 00 00 00       	mov    $0x0,%esi
  80136d:	eb 57                	jmp    8013c6 <readline+0x90>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  80136f:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
  801374:	83 fb f8             	cmp    $0xfffffff8,%ebx
  801377:	75 08                	jne    801381 <readline+0x4b>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
  801379:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80137c:	5b                   	pop    %ebx
  80137d:	5e                   	pop    %esi
  80137e:	5f                   	pop    %edi
  80137f:	5d                   	pop    %ebp
  801380:	c3                   	ret    
				cprintf("read error: %e\n", c);
  801381:	83 ec 08             	sub    $0x8,%esp
  801384:	53                   	push   %ebx
  801385:	68 08 43 80 00       	push   $0x804308
  80138a:	e8 81 f8 ff ff       	call   800c10 <cprintf>
  80138f:	83 c4 10             	add    $0x10,%esp
			return NULL;
  801392:	b8 00 00 00 00       	mov    $0x0,%eax
  801397:	eb e0                	jmp    801379 <readline+0x43>
			if (echoing)
  801399:	85 ff                	test   %edi,%edi
  80139b:	75 05                	jne    8013a2 <readline+0x6c>
			i--;
  80139d:	83 ee 01             	sub    $0x1,%esi
  8013a0:	eb 24                	jmp    8013c6 <readline+0x90>
				cputchar('\b');
  8013a2:	83 ec 0c             	sub    $0xc,%esp
  8013a5:	6a 08                	push   $0x8
  8013a7:	e8 9e f5 ff ff       	call   80094a <cputchar>
  8013ac:	83 c4 10             	add    $0x10,%esp
  8013af:	eb ec                	jmp    80139d <readline+0x67>
				cputchar(c);
  8013b1:	83 ec 0c             	sub    $0xc,%esp
  8013b4:	53                   	push   %ebx
  8013b5:	e8 90 f5 ff ff       	call   80094a <cputchar>
  8013ba:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8013bd:	88 9e 20 60 80 00    	mov    %bl,0x806020(%esi)
  8013c3:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
  8013c6:	e8 9b f5 ff ff       	call   800966 <getchar>
  8013cb:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  8013cd:	85 c0                	test   %eax,%eax
  8013cf:	78 9e                	js     80136f <readline+0x39>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  8013d1:	83 f8 08             	cmp    $0x8,%eax
  8013d4:	0f 94 c2             	sete   %dl
  8013d7:	83 f8 7f             	cmp    $0x7f,%eax
  8013da:	0f 94 c0             	sete   %al
  8013dd:	08 c2                	or     %al,%dl
  8013df:	74 04                	je     8013e5 <readline+0xaf>
  8013e1:	85 f6                	test   %esi,%esi
  8013e3:	7f b4                	jg     801399 <readline+0x63>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8013e5:	83 fb 1f             	cmp    $0x1f,%ebx
  8013e8:	7e 0e                	jle    8013f8 <readline+0xc2>
  8013ea:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  8013f0:	7f 06                	jg     8013f8 <readline+0xc2>
			if (echoing)
  8013f2:	85 ff                	test   %edi,%edi
  8013f4:	74 c7                	je     8013bd <readline+0x87>
  8013f6:	eb b9                	jmp    8013b1 <readline+0x7b>
		} else if (c == '\n' || c == '\r') {
  8013f8:	83 fb 0a             	cmp    $0xa,%ebx
  8013fb:	74 05                	je     801402 <readline+0xcc>
  8013fd:	83 fb 0d             	cmp    $0xd,%ebx
  801400:	75 c4                	jne    8013c6 <readline+0x90>
			if (echoing)
  801402:	85 ff                	test   %edi,%edi
  801404:	75 11                	jne    801417 <readline+0xe1>
			buf[i] = 0;
  801406:	c6 86 20 60 80 00 00 	movb   $0x0,0x806020(%esi)
			return buf;
  80140d:	b8 20 60 80 00       	mov    $0x806020,%eax
  801412:	e9 62 ff ff ff       	jmp    801379 <readline+0x43>
				cputchar('\n');
  801417:	83 ec 0c             	sub    $0xc,%esp
  80141a:	6a 0a                	push   $0xa
  80141c:	e8 29 f5 ff ff       	call   80094a <cputchar>
  801421:	83 c4 10             	add    $0x10,%esp
  801424:	eb e0                	jmp    801406 <readline+0xd0>

00801426 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801426:	55                   	push   %ebp
  801427:	89 e5                	mov    %esp,%ebp
  801429:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80142c:	b8 00 00 00 00       	mov    $0x0,%eax
  801431:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801435:	74 05                	je     80143c <strlen+0x16>
		n++;
  801437:	83 c0 01             	add    $0x1,%eax
  80143a:	eb f5                	jmp    801431 <strlen+0xb>
	return n;
}
  80143c:	5d                   	pop    %ebp
  80143d:	c3                   	ret    

0080143e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
  801441:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801444:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801447:	ba 00 00 00 00       	mov    $0x0,%edx
  80144c:	39 c2                	cmp    %eax,%edx
  80144e:	74 0d                	je     80145d <strnlen+0x1f>
  801450:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  801454:	74 05                	je     80145b <strnlen+0x1d>
		n++;
  801456:	83 c2 01             	add    $0x1,%edx
  801459:	eb f1                	jmp    80144c <strnlen+0xe>
  80145b:	89 d0                	mov    %edx,%eax
	return n;
}
  80145d:	5d                   	pop    %ebp
  80145e:	c3                   	ret    

0080145f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
  801462:	53                   	push   %ebx
  801463:	8b 45 08             	mov    0x8(%ebp),%eax
  801466:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801469:	ba 00 00 00 00       	mov    $0x0,%edx
  80146e:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  801472:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  801475:	83 c2 01             	add    $0x1,%edx
  801478:	84 c9                	test   %cl,%cl
  80147a:	75 f2                	jne    80146e <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80147c:	5b                   	pop    %ebx
  80147d:	5d                   	pop    %ebp
  80147e:	c3                   	ret    

0080147f <strcat>:

char *
strcat(char *dst, const char *src)
{
  80147f:	55                   	push   %ebp
  801480:	89 e5                	mov    %esp,%ebp
  801482:	53                   	push   %ebx
  801483:	83 ec 10             	sub    $0x10,%esp
  801486:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801489:	53                   	push   %ebx
  80148a:	e8 97 ff ff ff       	call   801426 <strlen>
  80148f:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801492:	ff 75 0c             	pushl  0xc(%ebp)
  801495:	01 d8                	add    %ebx,%eax
  801497:	50                   	push   %eax
  801498:	e8 c2 ff ff ff       	call   80145f <strcpy>
	return dst;
}
  80149d:	89 d8                	mov    %ebx,%eax
  80149f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014a2:	c9                   	leave  
  8014a3:	c3                   	ret    

008014a4 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8014a4:	55                   	push   %ebp
  8014a5:	89 e5                	mov    %esp,%ebp
  8014a7:	56                   	push   %esi
  8014a8:	53                   	push   %ebx
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014af:	89 c6                	mov    %eax,%esi
  8014b1:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014b4:	89 c2                	mov    %eax,%edx
  8014b6:	39 f2                	cmp    %esi,%edx
  8014b8:	74 11                	je     8014cb <strncpy+0x27>
		*dst++ = *src;
  8014ba:	83 c2 01             	add    $0x1,%edx
  8014bd:	0f b6 19             	movzbl (%ecx),%ebx
  8014c0:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8014c3:	80 fb 01             	cmp    $0x1,%bl
  8014c6:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8014c9:	eb eb                	jmp    8014b6 <strncpy+0x12>
	}
	return ret;
}
  8014cb:	5b                   	pop    %ebx
  8014cc:	5e                   	pop    %esi
  8014cd:	5d                   	pop    %ebp
  8014ce:	c3                   	ret    

008014cf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
  8014d2:	56                   	push   %esi
  8014d3:	53                   	push   %ebx
  8014d4:	8b 75 08             	mov    0x8(%ebp),%esi
  8014d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014da:	8b 55 10             	mov    0x10(%ebp),%edx
  8014dd:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8014df:	85 d2                	test   %edx,%edx
  8014e1:	74 21                	je     801504 <strlcpy+0x35>
  8014e3:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8014e7:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8014e9:	39 c2                	cmp    %eax,%edx
  8014eb:	74 14                	je     801501 <strlcpy+0x32>
  8014ed:	0f b6 19             	movzbl (%ecx),%ebx
  8014f0:	84 db                	test   %bl,%bl
  8014f2:	74 0b                	je     8014ff <strlcpy+0x30>
			*dst++ = *src++;
  8014f4:	83 c1 01             	add    $0x1,%ecx
  8014f7:	83 c2 01             	add    $0x1,%edx
  8014fa:	88 5a ff             	mov    %bl,-0x1(%edx)
  8014fd:	eb ea                	jmp    8014e9 <strlcpy+0x1a>
  8014ff:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801501:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801504:	29 f0                	sub    %esi,%eax
}
  801506:	5b                   	pop    %ebx
  801507:	5e                   	pop    %esi
  801508:	5d                   	pop    %ebp
  801509:	c3                   	ret    

0080150a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80150a:	55                   	push   %ebp
  80150b:	89 e5                	mov    %esp,%ebp
  80150d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801510:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801513:	0f b6 01             	movzbl (%ecx),%eax
  801516:	84 c0                	test   %al,%al
  801518:	74 0c                	je     801526 <strcmp+0x1c>
  80151a:	3a 02                	cmp    (%edx),%al
  80151c:	75 08                	jne    801526 <strcmp+0x1c>
		p++, q++;
  80151e:	83 c1 01             	add    $0x1,%ecx
  801521:	83 c2 01             	add    $0x1,%edx
  801524:	eb ed                	jmp    801513 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801526:	0f b6 c0             	movzbl %al,%eax
  801529:	0f b6 12             	movzbl (%edx),%edx
  80152c:	29 d0                	sub    %edx,%eax
}
  80152e:	5d                   	pop    %ebp
  80152f:	c3                   	ret    

00801530 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
  801533:	53                   	push   %ebx
  801534:	8b 45 08             	mov    0x8(%ebp),%eax
  801537:	8b 55 0c             	mov    0xc(%ebp),%edx
  80153a:	89 c3                	mov    %eax,%ebx
  80153c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80153f:	eb 06                	jmp    801547 <strncmp+0x17>
		n--, p++, q++;
  801541:	83 c0 01             	add    $0x1,%eax
  801544:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801547:	39 d8                	cmp    %ebx,%eax
  801549:	74 16                	je     801561 <strncmp+0x31>
  80154b:	0f b6 08             	movzbl (%eax),%ecx
  80154e:	84 c9                	test   %cl,%cl
  801550:	74 04                	je     801556 <strncmp+0x26>
  801552:	3a 0a                	cmp    (%edx),%cl
  801554:	74 eb                	je     801541 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801556:	0f b6 00             	movzbl (%eax),%eax
  801559:	0f b6 12             	movzbl (%edx),%edx
  80155c:	29 d0                	sub    %edx,%eax
}
  80155e:	5b                   	pop    %ebx
  80155f:	5d                   	pop    %ebp
  801560:	c3                   	ret    
		return 0;
  801561:	b8 00 00 00 00       	mov    $0x0,%eax
  801566:	eb f6                	jmp    80155e <strncmp+0x2e>

00801568 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801568:	55                   	push   %ebp
  801569:	89 e5                	mov    %esp,%ebp
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801572:	0f b6 10             	movzbl (%eax),%edx
  801575:	84 d2                	test   %dl,%dl
  801577:	74 09                	je     801582 <strchr+0x1a>
		if (*s == c)
  801579:	38 ca                	cmp    %cl,%dl
  80157b:	74 0a                	je     801587 <strchr+0x1f>
	for (; *s; s++)
  80157d:	83 c0 01             	add    $0x1,%eax
  801580:	eb f0                	jmp    801572 <strchr+0xa>
			return (char *) s;
	return 0;
  801582:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801587:	5d                   	pop    %ebp
  801588:	c3                   	ret    

00801589 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801589:	55                   	push   %ebp
  80158a:	89 e5                	mov    %esp,%ebp
  80158c:	8b 45 08             	mov    0x8(%ebp),%eax
  80158f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801593:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801596:	38 ca                	cmp    %cl,%dl
  801598:	74 09                	je     8015a3 <strfind+0x1a>
  80159a:	84 d2                	test   %dl,%dl
  80159c:	74 05                	je     8015a3 <strfind+0x1a>
	for (; *s; s++)
  80159e:	83 c0 01             	add    $0x1,%eax
  8015a1:	eb f0                	jmp    801593 <strfind+0xa>
			break;
	return (char *) s;
}
  8015a3:	5d                   	pop    %ebp
  8015a4:	c3                   	ret    

008015a5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
  8015a8:	57                   	push   %edi
  8015a9:	56                   	push   %esi
  8015aa:	53                   	push   %ebx
  8015ab:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8015b1:	85 c9                	test   %ecx,%ecx
  8015b3:	74 31                	je     8015e6 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8015b5:	89 f8                	mov    %edi,%eax
  8015b7:	09 c8                	or     %ecx,%eax
  8015b9:	a8 03                	test   $0x3,%al
  8015bb:	75 23                	jne    8015e0 <memset+0x3b>
		c &= 0xFF;
  8015bd:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8015c1:	89 d3                	mov    %edx,%ebx
  8015c3:	c1 e3 08             	shl    $0x8,%ebx
  8015c6:	89 d0                	mov    %edx,%eax
  8015c8:	c1 e0 18             	shl    $0x18,%eax
  8015cb:	89 d6                	mov    %edx,%esi
  8015cd:	c1 e6 10             	shl    $0x10,%esi
  8015d0:	09 f0                	or     %esi,%eax
  8015d2:	09 c2                	or     %eax,%edx
  8015d4:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8015d6:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8015d9:	89 d0                	mov    %edx,%eax
  8015db:	fc                   	cld    
  8015dc:	f3 ab                	rep stos %eax,%es:(%edi)
  8015de:	eb 06                	jmp    8015e6 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8015e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e3:	fc                   	cld    
  8015e4:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8015e6:	89 f8                	mov    %edi,%eax
  8015e8:	5b                   	pop    %ebx
  8015e9:	5e                   	pop    %esi
  8015ea:	5f                   	pop    %edi
  8015eb:	5d                   	pop    %ebp
  8015ec:	c3                   	ret    

008015ed <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
  8015f0:	57                   	push   %edi
  8015f1:	56                   	push   %esi
  8015f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8015fb:	39 c6                	cmp    %eax,%esi
  8015fd:	73 32                	jae    801631 <memmove+0x44>
  8015ff:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801602:	39 c2                	cmp    %eax,%edx
  801604:	76 2b                	jbe    801631 <memmove+0x44>
		s += n;
		d += n;
  801606:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801609:	89 fe                	mov    %edi,%esi
  80160b:	09 ce                	or     %ecx,%esi
  80160d:	09 d6                	or     %edx,%esi
  80160f:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801615:	75 0e                	jne    801625 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801617:	83 ef 04             	sub    $0x4,%edi
  80161a:	8d 72 fc             	lea    -0x4(%edx),%esi
  80161d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801620:	fd                   	std    
  801621:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801623:	eb 09                	jmp    80162e <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801625:	83 ef 01             	sub    $0x1,%edi
  801628:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80162b:	fd                   	std    
  80162c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80162e:	fc                   	cld    
  80162f:	eb 1a                	jmp    80164b <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801631:	89 c2                	mov    %eax,%edx
  801633:	09 ca                	or     %ecx,%edx
  801635:	09 f2                	or     %esi,%edx
  801637:	f6 c2 03             	test   $0x3,%dl
  80163a:	75 0a                	jne    801646 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80163c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80163f:	89 c7                	mov    %eax,%edi
  801641:	fc                   	cld    
  801642:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801644:	eb 05                	jmp    80164b <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  801646:	89 c7                	mov    %eax,%edi
  801648:	fc                   	cld    
  801649:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80164b:	5e                   	pop    %esi
  80164c:	5f                   	pop    %edi
  80164d:	5d                   	pop    %ebp
  80164e:	c3                   	ret    

0080164f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
  801652:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801655:	ff 75 10             	pushl  0x10(%ebp)
  801658:	ff 75 0c             	pushl  0xc(%ebp)
  80165b:	ff 75 08             	pushl  0x8(%ebp)
  80165e:	e8 8a ff ff ff       	call   8015ed <memmove>
}
  801663:	c9                   	leave  
  801664:	c3                   	ret    

00801665 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801665:	55                   	push   %ebp
  801666:	89 e5                	mov    %esp,%ebp
  801668:	56                   	push   %esi
  801669:	53                   	push   %ebx
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
  80166d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801670:	89 c6                	mov    %eax,%esi
  801672:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801675:	39 f0                	cmp    %esi,%eax
  801677:	74 1c                	je     801695 <memcmp+0x30>
		if (*s1 != *s2)
  801679:	0f b6 08             	movzbl (%eax),%ecx
  80167c:	0f b6 1a             	movzbl (%edx),%ebx
  80167f:	38 d9                	cmp    %bl,%cl
  801681:	75 08                	jne    80168b <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801683:	83 c0 01             	add    $0x1,%eax
  801686:	83 c2 01             	add    $0x1,%edx
  801689:	eb ea                	jmp    801675 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  80168b:	0f b6 c1             	movzbl %cl,%eax
  80168e:	0f b6 db             	movzbl %bl,%ebx
  801691:	29 d8                	sub    %ebx,%eax
  801693:	eb 05                	jmp    80169a <memcmp+0x35>
	}

	return 0;
  801695:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80169a:	5b                   	pop    %ebx
  80169b:	5e                   	pop    %esi
  80169c:	5d                   	pop    %ebp
  80169d:	c3                   	ret    

0080169e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
  8016a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8016a7:	89 c2                	mov    %eax,%edx
  8016a9:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8016ac:	39 d0                	cmp    %edx,%eax
  8016ae:	73 09                	jae    8016b9 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016b0:	38 08                	cmp    %cl,(%eax)
  8016b2:	74 05                	je     8016b9 <memfind+0x1b>
	for (; s < ends; s++)
  8016b4:	83 c0 01             	add    $0x1,%eax
  8016b7:	eb f3                	jmp    8016ac <memfind+0xe>
			break;
	return (void *) s;
}
  8016b9:	5d                   	pop    %ebp
  8016ba:	c3                   	ret    

008016bb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016bb:	55                   	push   %ebp
  8016bc:	89 e5                	mov    %esp,%ebp
  8016be:	57                   	push   %edi
  8016bf:	56                   	push   %esi
  8016c0:	53                   	push   %ebx
  8016c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016c4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016c7:	eb 03                	jmp    8016cc <strtol+0x11>
		s++;
  8016c9:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8016cc:	0f b6 01             	movzbl (%ecx),%eax
  8016cf:	3c 20                	cmp    $0x20,%al
  8016d1:	74 f6                	je     8016c9 <strtol+0xe>
  8016d3:	3c 09                	cmp    $0x9,%al
  8016d5:	74 f2                	je     8016c9 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8016d7:	3c 2b                	cmp    $0x2b,%al
  8016d9:	74 2a                	je     801705 <strtol+0x4a>
	int neg = 0;
  8016db:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8016e0:	3c 2d                	cmp    $0x2d,%al
  8016e2:	74 2b                	je     80170f <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8016e4:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8016ea:	75 0f                	jne    8016fb <strtol+0x40>
  8016ec:	80 39 30             	cmpb   $0x30,(%ecx)
  8016ef:	74 28                	je     801719 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8016f1:	85 db                	test   %ebx,%ebx
  8016f3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8016f8:	0f 44 d8             	cmove  %eax,%ebx
  8016fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801700:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801703:	eb 50                	jmp    801755 <strtol+0x9a>
		s++;
  801705:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801708:	bf 00 00 00 00       	mov    $0x0,%edi
  80170d:	eb d5                	jmp    8016e4 <strtol+0x29>
		s++, neg = 1;
  80170f:	83 c1 01             	add    $0x1,%ecx
  801712:	bf 01 00 00 00       	mov    $0x1,%edi
  801717:	eb cb                	jmp    8016e4 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801719:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80171d:	74 0e                	je     80172d <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  80171f:	85 db                	test   %ebx,%ebx
  801721:	75 d8                	jne    8016fb <strtol+0x40>
		s++, base = 8;
  801723:	83 c1 01             	add    $0x1,%ecx
  801726:	bb 08 00 00 00       	mov    $0x8,%ebx
  80172b:	eb ce                	jmp    8016fb <strtol+0x40>
		s += 2, base = 16;
  80172d:	83 c1 02             	add    $0x2,%ecx
  801730:	bb 10 00 00 00       	mov    $0x10,%ebx
  801735:	eb c4                	jmp    8016fb <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801737:	8d 72 9f             	lea    -0x61(%edx),%esi
  80173a:	89 f3                	mov    %esi,%ebx
  80173c:	80 fb 19             	cmp    $0x19,%bl
  80173f:	77 29                	ja     80176a <strtol+0xaf>
			dig = *s - 'a' + 10;
  801741:	0f be d2             	movsbl %dl,%edx
  801744:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801747:	3b 55 10             	cmp    0x10(%ebp),%edx
  80174a:	7d 30                	jge    80177c <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  80174c:	83 c1 01             	add    $0x1,%ecx
  80174f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801753:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801755:	0f b6 11             	movzbl (%ecx),%edx
  801758:	8d 72 d0             	lea    -0x30(%edx),%esi
  80175b:	89 f3                	mov    %esi,%ebx
  80175d:	80 fb 09             	cmp    $0x9,%bl
  801760:	77 d5                	ja     801737 <strtol+0x7c>
			dig = *s - '0';
  801762:	0f be d2             	movsbl %dl,%edx
  801765:	83 ea 30             	sub    $0x30,%edx
  801768:	eb dd                	jmp    801747 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  80176a:	8d 72 bf             	lea    -0x41(%edx),%esi
  80176d:	89 f3                	mov    %esi,%ebx
  80176f:	80 fb 19             	cmp    $0x19,%bl
  801772:	77 08                	ja     80177c <strtol+0xc1>
			dig = *s - 'A' + 10;
  801774:	0f be d2             	movsbl %dl,%edx
  801777:	83 ea 37             	sub    $0x37,%edx
  80177a:	eb cb                	jmp    801747 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  80177c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801780:	74 05                	je     801787 <strtol+0xcc>
		*endptr = (char *) s;
  801782:	8b 75 0c             	mov    0xc(%ebp),%esi
  801785:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801787:	89 c2                	mov    %eax,%edx
  801789:	f7 da                	neg    %edx
  80178b:	85 ff                	test   %edi,%edi
  80178d:	0f 45 c2             	cmovne %edx,%eax
}
  801790:	5b                   	pop    %ebx
  801791:	5e                   	pop    %esi
  801792:	5f                   	pop    %edi
  801793:	5d                   	pop    %ebp
  801794:	c3                   	ret    

00801795 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
  801798:	57                   	push   %edi
  801799:	56                   	push   %esi
  80179a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80179b:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8017a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017a6:	89 c3                	mov    %eax,%ebx
  8017a8:	89 c7                	mov    %eax,%edi
  8017aa:	89 c6                	mov    %eax,%esi
  8017ac:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8017ae:	5b                   	pop    %ebx
  8017af:	5e                   	pop    %esi
  8017b0:	5f                   	pop    %edi
  8017b1:	5d                   	pop    %ebp
  8017b2:	c3                   	ret    

008017b3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
  8017b6:	57                   	push   %edi
  8017b7:	56                   	push   %esi
  8017b8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8017b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8017be:	b8 01 00 00 00       	mov    $0x1,%eax
  8017c3:	89 d1                	mov    %edx,%ecx
  8017c5:	89 d3                	mov    %edx,%ebx
  8017c7:	89 d7                	mov    %edx,%edi
  8017c9:	89 d6                	mov    %edx,%esi
  8017cb:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8017cd:	5b                   	pop    %ebx
  8017ce:	5e                   	pop    %esi
  8017cf:	5f                   	pop    %edi
  8017d0:	5d                   	pop    %ebp
  8017d1:	c3                   	ret    

008017d2 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8017d2:	55                   	push   %ebp
  8017d3:	89 e5                	mov    %esp,%ebp
  8017d5:	57                   	push   %edi
  8017d6:	56                   	push   %esi
  8017d7:	53                   	push   %ebx
  8017d8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8017db:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8017e3:	b8 03 00 00 00       	mov    $0x3,%eax
  8017e8:	89 cb                	mov    %ecx,%ebx
  8017ea:	89 cf                	mov    %ecx,%edi
  8017ec:	89 ce                	mov    %ecx,%esi
  8017ee:	cd 30                	int    $0x30
	if(check && ret > 0)
  8017f0:	85 c0                	test   %eax,%eax
  8017f2:	7f 08                	jg     8017fc <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8017f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017f7:	5b                   	pop    %ebx
  8017f8:	5e                   	pop    %esi
  8017f9:	5f                   	pop    %edi
  8017fa:	5d                   	pop    %ebp
  8017fb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8017fc:	83 ec 0c             	sub    $0xc,%esp
  8017ff:	50                   	push   %eax
  801800:	6a 03                	push   $0x3
  801802:	68 18 43 80 00       	push   $0x804318
  801807:	6a 43                	push   $0x43
  801809:	68 35 43 80 00       	push   $0x804335
  80180e:	e8 07 f3 ff ff       	call   800b1a <_panic>

00801813 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
  801816:	57                   	push   %edi
  801817:	56                   	push   %esi
  801818:	53                   	push   %ebx
	asm volatile("int %1\n"
  801819:	ba 00 00 00 00       	mov    $0x0,%edx
  80181e:	b8 02 00 00 00       	mov    $0x2,%eax
  801823:	89 d1                	mov    %edx,%ecx
  801825:	89 d3                	mov    %edx,%ebx
  801827:	89 d7                	mov    %edx,%edi
  801829:	89 d6                	mov    %edx,%esi
  80182b:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80182d:	5b                   	pop    %ebx
  80182e:	5e                   	pop    %esi
  80182f:	5f                   	pop    %edi
  801830:	5d                   	pop    %ebp
  801831:	c3                   	ret    

00801832 <sys_yield>:

void
sys_yield(void)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
  801835:	57                   	push   %edi
  801836:	56                   	push   %esi
  801837:	53                   	push   %ebx
	asm volatile("int %1\n"
  801838:	ba 00 00 00 00       	mov    $0x0,%edx
  80183d:	b8 0b 00 00 00       	mov    $0xb,%eax
  801842:	89 d1                	mov    %edx,%ecx
  801844:	89 d3                	mov    %edx,%ebx
  801846:	89 d7                	mov    %edx,%edi
  801848:	89 d6                	mov    %edx,%esi
  80184a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80184c:	5b                   	pop    %ebx
  80184d:	5e                   	pop    %esi
  80184e:	5f                   	pop    %edi
  80184f:	5d                   	pop    %ebp
  801850:	c3                   	ret    

00801851 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
  801854:	57                   	push   %edi
  801855:	56                   	push   %esi
  801856:	53                   	push   %ebx
  801857:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80185a:	be 00 00 00 00       	mov    $0x0,%esi
  80185f:	8b 55 08             	mov    0x8(%ebp),%edx
  801862:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801865:	b8 04 00 00 00       	mov    $0x4,%eax
  80186a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80186d:	89 f7                	mov    %esi,%edi
  80186f:	cd 30                	int    $0x30
	if(check && ret > 0)
  801871:	85 c0                	test   %eax,%eax
  801873:	7f 08                	jg     80187d <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801875:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801878:	5b                   	pop    %ebx
  801879:	5e                   	pop    %esi
  80187a:	5f                   	pop    %edi
  80187b:	5d                   	pop    %ebp
  80187c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80187d:	83 ec 0c             	sub    $0xc,%esp
  801880:	50                   	push   %eax
  801881:	6a 04                	push   $0x4
  801883:	68 18 43 80 00       	push   $0x804318
  801888:	6a 43                	push   $0x43
  80188a:	68 35 43 80 00       	push   $0x804335
  80188f:	e8 86 f2 ff ff       	call   800b1a <_panic>

00801894 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
  801897:	57                   	push   %edi
  801898:	56                   	push   %esi
  801899:	53                   	push   %ebx
  80189a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80189d:	8b 55 08             	mov    0x8(%ebp),%edx
  8018a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018a3:	b8 05 00 00 00       	mov    $0x5,%eax
  8018a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8018ab:	8b 7d 14             	mov    0x14(%ebp),%edi
  8018ae:	8b 75 18             	mov    0x18(%ebp),%esi
  8018b1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8018b3:	85 c0                	test   %eax,%eax
  8018b5:	7f 08                	jg     8018bf <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8018b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018ba:	5b                   	pop    %ebx
  8018bb:	5e                   	pop    %esi
  8018bc:	5f                   	pop    %edi
  8018bd:	5d                   	pop    %ebp
  8018be:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8018bf:	83 ec 0c             	sub    $0xc,%esp
  8018c2:	50                   	push   %eax
  8018c3:	6a 05                	push   $0x5
  8018c5:	68 18 43 80 00       	push   $0x804318
  8018ca:	6a 43                	push   $0x43
  8018cc:	68 35 43 80 00       	push   $0x804335
  8018d1:	e8 44 f2 ff ff       	call   800b1a <_panic>

008018d6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
  8018d9:	57                   	push   %edi
  8018da:	56                   	push   %esi
  8018db:	53                   	push   %ebx
  8018dc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8018df:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8018e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018ea:	b8 06 00 00 00       	mov    $0x6,%eax
  8018ef:	89 df                	mov    %ebx,%edi
  8018f1:	89 de                	mov    %ebx,%esi
  8018f3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8018f5:	85 c0                	test   %eax,%eax
  8018f7:	7f 08                	jg     801901 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8018f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018fc:	5b                   	pop    %ebx
  8018fd:	5e                   	pop    %esi
  8018fe:	5f                   	pop    %edi
  8018ff:	5d                   	pop    %ebp
  801900:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801901:	83 ec 0c             	sub    $0xc,%esp
  801904:	50                   	push   %eax
  801905:	6a 06                	push   $0x6
  801907:	68 18 43 80 00       	push   $0x804318
  80190c:	6a 43                	push   $0x43
  80190e:	68 35 43 80 00       	push   $0x804335
  801913:	e8 02 f2 ff ff       	call   800b1a <_panic>

00801918 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
  80191b:	57                   	push   %edi
  80191c:	56                   	push   %esi
  80191d:	53                   	push   %ebx
  80191e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801921:	bb 00 00 00 00       	mov    $0x0,%ebx
  801926:	8b 55 08             	mov    0x8(%ebp),%edx
  801929:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80192c:	b8 08 00 00 00       	mov    $0x8,%eax
  801931:	89 df                	mov    %ebx,%edi
  801933:	89 de                	mov    %ebx,%esi
  801935:	cd 30                	int    $0x30
	if(check && ret > 0)
  801937:	85 c0                	test   %eax,%eax
  801939:	7f 08                	jg     801943 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80193b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80193e:	5b                   	pop    %ebx
  80193f:	5e                   	pop    %esi
  801940:	5f                   	pop    %edi
  801941:	5d                   	pop    %ebp
  801942:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801943:	83 ec 0c             	sub    $0xc,%esp
  801946:	50                   	push   %eax
  801947:	6a 08                	push   $0x8
  801949:	68 18 43 80 00       	push   $0x804318
  80194e:	6a 43                	push   $0x43
  801950:	68 35 43 80 00       	push   $0x804335
  801955:	e8 c0 f1 ff ff       	call   800b1a <_panic>

0080195a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
  80195d:	57                   	push   %edi
  80195e:	56                   	push   %esi
  80195f:	53                   	push   %ebx
  801960:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801963:	bb 00 00 00 00       	mov    $0x0,%ebx
  801968:	8b 55 08             	mov    0x8(%ebp),%edx
  80196b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80196e:	b8 09 00 00 00       	mov    $0x9,%eax
  801973:	89 df                	mov    %ebx,%edi
  801975:	89 de                	mov    %ebx,%esi
  801977:	cd 30                	int    $0x30
	if(check && ret > 0)
  801979:	85 c0                	test   %eax,%eax
  80197b:	7f 08                	jg     801985 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80197d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801980:	5b                   	pop    %ebx
  801981:	5e                   	pop    %esi
  801982:	5f                   	pop    %edi
  801983:	5d                   	pop    %ebp
  801984:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801985:	83 ec 0c             	sub    $0xc,%esp
  801988:	50                   	push   %eax
  801989:	6a 09                	push   $0x9
  80198b:	68 18 43 80 00       	push   $0x804318
  801990:	6a 43                	push   $0x43
  801992:	68 35 43 80 00       	push   $0x804335
  801997:	e8 7e f1 ff ff       	call   800b1a <_panic>

0080199c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
  80199f:	57                   	push   %edi
  8019a0:	56                   	push   %esi
  8019a1:	53                   	push   %ebx
  8019a2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8019a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8019ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019b0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019b5:	89 df                	mov    %ebx,%edi
  8019b7:	89 de                	mov    %ebx,%esi
  8019b9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8019bb:	85 c0                	test   %eax,%eax
  8019bd:	7f 08                	jg     8019c7 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8019bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019c2:	5b                   	pop    %ebx
  8019c3:	5e                   	pop    %esi
  8019c4:	5f                   	pop    %edi
  8019c5:	5d                   	pop    %ebp
  8019c6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8019c7:	83 ec 0c             	sub    $0xc,%esp
  8019ca:	50                   	push   %eax
  8019cb:	6a 0a                	push   $0xa
  8019cd:	68 18 43 80 00       	push   $0x804318
  8019d2:	6a 43                	push   $0x43
  8019d4:	68 35 43 80 00       	push   $0x804335
  8019d9:	e8 3c f1 ff ff       	call   800b1a <_panic>

008019de <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
  8019e1:	57                   	push   %edi
  8019e2:	56                   	push   %esi
  8019e3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8019e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8019e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019ea:	b8 0c 00 00 00       	mov    $0xc,%eax
  8019ef:	be 00 00 00 00       	mov    $0x0,%esi
  8019f4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8019f7:	8b 7d 14             	mov    0x14(%ebp),%edi
  8019fa:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8019fc:	5b                   	pop    %ebx
  8019fd:	5e                   	pop    %esi
  8019fe:	5f                   	pop    %edi
  8019ff:	5d                   	pop    %ebp
  801a00:	c3                   	ret    

00801a01 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
  801a04:	57                   	push   %edi
  801a05:	56                   	push   %esi
  801a06:	53                   	push   %ebx
  801a07:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801a0a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a0f:	8b 55 08             	mov    0x8(%ebp),%edx
  801a12:	b8 0d 00 00 00       	mov    $0xd,%eax
  801a17:	89 cb                	mov    %ecx,%ebx
  801a19:	89 cf                	mov    %ecx,%edi
  801a1b:	89 ce                	mov    %ecx,%esi
  801a1d:	cd 30                	int    $0x30
	if(check && ret > 0)
  801a1f:	85 c0                	test   %eax,%eax
  801a21:	7f 08                	jg     801a2b <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801a23:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a26:	5b                   	pop    %ebx
  801a27:	5e                   	pop    %esi
  801a28:	5f                   	pop    %edi
  801a29:	5d                   	pop    %ebp
  801a2a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801a2b:	83 ec 0c             	sub    $0xc,%esp
  801a2e:	50                   	push   %eax
  801a2f:	6a 0d                	push   $0xd
  801a31:	68 18 43 80 00       	push   $0x804318
  801a36:	6a 43                	push   $0x43
  801a38:	68 35 43 80 00       	push   $0x804335
  801a3d:	e8 d8 f0 ff ff       	call   800b1a <_panic>

00801a42 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
  801a45:	57                   	push   %edi
  801a46:	56                   	push   %esi
  801a47:	53                   	push   %ebx
	asm volatile("int %1\n"
  801a48:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a4d:	8b 55 08             	mov    0x8(%ebp),%edx
  801a50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a53:	b8 0e 00 00 00       	mov    $0xe,%eax
  801a58:	89 df                	mov    %ebx,%edi
  801a5a:	89 de                	mov    %ebx,%esi
  801a5c:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801a5e:	5b                   	pop    %ebx
  801a5f:	5e                   	pop    %esi
  801a60:	5f                   	pop    %edi
  801a61:	5d                   	pop    %ebp
  801a62:	c3                   	ret    

00801a63 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
  801a66:	57                   	push   %edi
  801a67:	56                   	push   %esi
  801a68:	53                   	push   %ebx
	asm volatile("int %1\n"
  801a69:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a6e:	8b 55 08             	mov    0x8(%ebp),%edx
  801a71:	b8 0f 00 00 00       	mov    $0xf,%eax
  801a76:	89 cb                	mov    %ecx,%ebx
  801a78:	89 cf                	mov    %ecx,%edi
  801a7a:	89 ce                	mov    %ecx,%esi
  801a7c:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801a7e:	5b                   	pop    %ebx
  801a7f:	5e                   	pop    %esi
  801a80:	5f                   	pop    %edi
  801a81:	5d                   	pop    %ebp
  801a82:	c3                   	ret    

00801a83 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
  801a86:	57                   	push   %edi
  801a87:	56                   	push   %esi
  801a88:	53                   	push   %ebx
	asm volatile("int %1\n"
  801a89:	ba 00 00 00 00       	mov    $0x0,%edx
  801a8e:	b8 10 00 00 00       	mov    $0x10,%eax
  801a93:	89 d1                	mov    %edx,%ecx
  801a95:	89 d3                	mov    %edx,%ebx
  801a97:	89 d7                	mov    %edx,%edi
  801a99:	89 d6                	mov    %edx,%esi
  801a9b:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801a9d:	5b                   	pop    %ebx
  801a9e:	5e                   	pop    %esi
  801a9f:	5f                   	pop    %edi
  801aa0:	5d                   	pop    %ebp
  801aa1:	c3                   	ret    

00801aa2 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
  801aa5:	57                   	push   %edi
  801aa6:	56                   	push   %esi
  801aa7:	53                   	push   %ebx
	asm volatile("int %1\n"
  801aa8:	bb 00 00 00 00       	mov    $0x0,%ebx
  801aad:	8b 55 08             	mov    0x8(%ebp),%edx
  801ab0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ab3:	b8 11 00 00 00       	mov    $0x11,%eax
  801ab8:	89 df                	mov    %ebx,%edi
  801aba:	89 de                	mov    %ebx,%esi
  801abc:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801abe:	5b                   	pop    %ebx
  801abf:	5e                   	pop    %esi
  801ac0:	5f                   	pop    %edi
  801ac1:	5d                   	pop    %ebp
  801ac2:	c3                   	ret    

00801ac3 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
  801ac6:	57                   	push   %edi
  801ac7:	56                   	push   %esi
  801ac8:	53                   	push   %ebx
	asm volatile("int %1\n"
  801ac9:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ace:	8b 55 08             	mov    0x8(%ebp),%edx
  801ad1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ad4:	b8 12 00 00 00       	mov    $0x12,%eax
  801ad9:	89 df                	mov    %ebx,%edi
  801adb:	89 de                	mov    %ebx,%esi
  801add:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801adf:	5b                   	pop    %ebx
  801ae0:	5e                   	pop    %esi
  801ae1:	5f                   	pop    %edi
  801ae2:	5d                   	pop    %ebp
  801ae3:	c3                   	ret    

00801ae4 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
  801ae7:	57                   	push   %edi
  801ae8:	56                   	push   %esi
  801ae9:	53                   	push   %ebx
  801aea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801aed:	bb 00 00 00 00       	mov    $0x0,%ebx
  801af2:	8b 55 08             	mov    0x8(%ebp),%edx
  801af5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801af8:	b8 13 00 00 00       	mov    $0x13,%eax
  801afd:	89 df                	mov    %ebx,%edi
  801aff:	89 de                	mov    %ebx,%esi
  801b01:	cd 30                	int    $0x30
	if(check && ret > 0)
  801b03:	85 c0                	test   %eax,%eax
  801b05:	7f 08                	jg     801b0f <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801b07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b0a:	5b                   	pop    %ebx
  801b0b:	5e                   	pop    %esi
  801b0c:	5f                   	pop    %edi
  801b0d:	5d                   	pop    %ebp
  801b0e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801b0f:	83 ec 0c             	sub    $0xc,%esp
  801b12:	50                   	push   %eax
  801b13:	6a 13                	push   $0x13
  801b15:	68 18 43 80 00       	push   $0x804318
  801b1a:	6a 43                	push   $0x43
  801b1c:	68 35 43 80 00       	push   $0x804335
  801b21:	e8 f4 ef ff ff       	call   800b1a <_panic>

00801b26 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
  801b29:	53                   	push   %ebx
  801b2a:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801b2d:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801b34:	f6 c5 04             	test   $0x4,%ch
  801b37:	75 45                	jne    801b7e <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801b39:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801b40:	83 e1 07             	and    $0x7,%ecx
  801b43:	83 f9 07             	cmp    $0x7,%ecx
  801b46:	74 6f                	je     801bb7 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801b48:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801b4f:	81 e1 05 08 00 00    	and    $0x805,%ecx
  801b55:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801b5b:	0f 84 b6 00 00 00    	je     801c17 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801b61:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801b68:	83 e1 05             	and    $0x5,%ecx
  801b6b:	83 f9 05             	cmp    $0x5,%ecx
  801b6e:	0f 84 d7 00 00 00    	je     801c4b <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801b74:	b8 00 00 00 00       	mov    $0x0,%eax
  801b79:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801b7e:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801b85:	c1 e2 0c             	shl    $0xc,%edx
  801b88:	83 ec 0c             	sub    $0xc,%esp
  801b8b:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801b91:	51                   	push   %ecx
  801b92:	52                   	push   %edx
  801b93:	50                   	push   %eax
  801b94:	52                   	push   %edx
  801b95:	6a 00                	push   $0x0
  801b97:	e8 f8 fc ff ff       	call   801894 <sys_page_map>
		if(r < 0)
  801b9c:	83 c4 20             	add    $0x20,%esp
  801b9f:	85 c0                	test   %eax,%eax
  801ba1:	79 d1                	jns    801b74 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801ba3:	83 ec 04             	sub    $0x4,%esp
  801ba6:	68 43 43 80 00       	push   $0x804343
  801bab:	6a 54                	push   $0x54
  801bad:	68 59 43 80 00       	push   $0x804359
  801bb2:	e8 63 ef ff ff       	call   800b1a <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801bb7:	89 d3                	mov    %edx,%ebx
  801bb9:	c1 e3 0c             	shl    $0xc,%ebx
  801bbc:	83 ec 0c             	sub    $0xc,%esp
  801bbf:	68 05 08 00 00       	push   $0x805
  801bc4:	53                   	push   %ebx
  801bc5:	50                   	push   %eax
  801bc6:	53                   	push   %ebx
  801bc7:	6a 00                	push   $0x0
  801bc9:	e8 c6 fc ff ff       	call   801894 <sys_page_map>
		if(r < 0)
  801bce:	83 c4 20             	add    $0x20,%esp
  801bd1:	85 c0                	test   %eax,%eax
  801bd3:	78 2e                	js     801c03 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801bd5:	83 ec 0c             	sub    $0xc,%esp
  801bd8:	68 05 08 00 00       	push   $0x805
  801bdd:	53                   	push   %ebx
  801bde:	6a 00                	push   $0x0
  801be0:	53                   	push   %ebx
  801be1:	6a 00                	push   $0x0
  801be3:	e8 ac fc ff ff       	call   801894 <sys_page_map>
		if(r < 0)
  801be8:	83 c4 20             	add    $0x20,%esp
  801beb:	85 c0                	test   %eax,%eax
  801bed:	79 85                	jns    801b74 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801bef:	83 ec 04             	sub    $0x4,%esp
  801bf2:	68 43 43 80 00       	push   $0x804343
  801bf7:	6a 5f                	push   $0x5f
  801bf9:	68 59 43 80 00       	push   $0x804359
  801bfe:	e8 17 ef ff ff       	call   800b1a <_panic>
			panic("sys_page_map() panic\n");
  801c03:	83 ec 04             	sub    $0x4,%esp
  801c06:	68 43 43 80 00       	push   $0x804343
  801c0b:	6a 5b                	push   $0x5b
  801c0d:	68 59 43 80 00       	push   $0x804359
  801c12:	e8 03 ef ff ff       	call   800b1a <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801c17:	c1 e2 0c             	shl    $0xc,%edx
  801c1a:	83 ec 0c             	sub    $0xc,%esp
  801c1d:	68 05 08 00 00       	push   $0x805
  801c22:	52                   	push   %edx
  801c23:	50                   	push   %eax
  801c24:	52                   	push   %edx
  801c25:	6a 00                	push   $0x0
  801c27:	e8 68 fc ff ff       	call   801894 <sys_page_map>
		if(r < 0)
  801c2c:	83 c4 20             	add    $0x20,%esp
  801c2f:	85 c0                	test   %eax,%eax
  801c31:	0f 89 3d ff ff ff    	jns    801b74 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801c37:	83 ec 04             	sub    $0x4,%esp
  801c3a:	68 43 43 80 00       	push   $0x804343
  801c3f:	6a 66                	push   $0x66
  801c41:	68 59 43 80 00       	push   $0x804359
  801c46:	e8 cf ee ff ff       	call   800b1a <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801c4b:	c1 e2 0c             	shl    $0xc,%edx
  801c4e:	83 ec 0c             	sub    $0xc,%esp
  801c51:	6a 05                	push   $0x5
  801c53:	52                   	push   %edx
  801c54:	50                   	push   %eax
  801c55:	52                   	push   %edx
  801c56:	6a 00                	push   $0x0
  801c58:	e8 37 fc ff ff       	call   801894 <sys_page_map>
		if(r < 0)
  801c5d:	83 c4 20             	add    $0x20,%esp
  801c60:	85 c0                	test   %eax,%eax
  801c62:	0f 89 0c ff ff ff    	jns    801b74 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801c68:	83 ec 04             	sub    $0x4,%esp
  801c6b:	68 43 43 80 00       	push   $0x804343
  801c70:	6a 6d                	push   $0x6d
  801c72:	68 59 43 80 00       	push   $0x804359
  801c77:	e8 9e ee ff ff       	call   800b1a <_panic>

00801c7c <pgfault>:
{
  801c7c:	55                   	push   %ebp
  801c7d:	89 e5                	mov    %esp,%ebp
  801c7f:	53                   	push   %ebx
  801c80:	83 ec 04             	sub    $0x4,%esp
  801c83:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801c86:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801c88:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801c8c:	0f 84 99 00 00 00    	je     801d2b <pgfault+0xaf>
  801c92:	89 c2                	mov    %eax,%edx
  801c94:	c1 ea 16             	shr    $0x16,%edx
  801c97:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801c9e:	f6 c2 01             	test   $0x1,%dl
  801ca1:	0f 84 84 00 00 00    	je     801d2b <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801ca7:	89 c2                	mov    %eax,%edx
  801ca9:	c1 ea 0c             	shr    $0xc,%edx
  801cac:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801cb3:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801cb9:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801cbf:	75 6a                	jne    801d2b <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801cc1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801cc6:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801cc8:	83 ec 04             	sub    $0x4,%esp
  801ccb:	6a 07                	push   $0x7
  801ccd:	68 00 f0 7f 00       	push   $0x7ff000
  801cd2:	6a 00                	push   $0x0
  801cd4:	e8 78 fb ff ff       	call   801851 <sys_page_alloc>
	if(ret < 0)
  801cd9:	83 c4 10             	add    $0x10,%esp
  801cdc:	85 c0                	test   %eax,%eax
  801cde:	78 5f                	js     801d3f <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801ce0:	83 ec 04             	sub    $0x4,%esp
  801ce3:	68 00 10 00 00       	push   $0x1000
  801ce8:	53                   	push   %ebx
  801ce9:	68 00 f0 7f 00       	push   $0x7ff000
  801cee:	e8 5c f9 ff ff       	call   80164f <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801cf3:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801cfa:	53                   	push   %ebx
  801cfb:	6a 00                	push   $0x0
  801cfd:	68 00 f0 7f 00       	push   $0x7ff000
  801d02:	6a 00                	push   $0x0
  801d04:	e8 8b fb ff ff       	call   801894 <sys_page_map>
	if(ret < 0)
  801d09:	83 c4 20             	add    $0x20,%esp
  801d0c:	85 c0                	test   %eax,%eax
  801d0e:	78 43                	js     801d53 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801d10:	83 ec 08             	sub    $0x8,%esp
  801d13:	68 00 f0 7f 00       	push   $0x7ff000
  801d18:	6a 00                	push   $0x0
  801d1a:	e8 b7 fb ff ff       	call   8018d6 <sys_page_unmap>
	if(ret < 0)
  801d1f:	83 c4 10             	add    $0x10,%esp
  801d22:	85 c0                	test   %eax,%eax
  801d24:	78 41                	js     801d67 <pgfault+0xeb>
}
  801d26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d29:	c9                   	leave  
  801d2a:	c3                   	ret    
		panic("panic at pgfault()\n");
  801d2b:	83 ec 04             	sub    $0x4,%esp
  801d2e:	68 64 43 80 00       	push   $0x804364
  801d33:	6a 26                	push   $0x26
  801d35:	68 59 43 80 00       	push   $0x804359
  801d3a:	e8 db ed ff ff       	call   800b1a <_panic>
		panic("panic in sys_page_alloc()\n");
  801d3f:	83 ec 04             	sub    $0x4,%esp
  801d42:	68 78 43 80 00       	push   $0x804378
  801d47:	6a 31                	push   $0x31
  801d49:	68 59 43 80 00       	push   $0x804359
  801d4e:	e8 c7 ed ff ff       	call   800b1a <_panic>
		panic("panic in sys_page_map()\n");
  801d53:	83 ec 04             	sub    $0x4,%esp
  801d56:	68 93 43 80 00       	push   $0x804393
  801d5b:	6a 36                	push   $0x36
  801d5d:	68 59 43 80 00       	push   $0x804359
  801d62:	e8 b3 ed ff ff       	call   800b1a <_panic>
		panic("panic in sys_page_unmap()\n");
  801d67:	83 ec 04             	sub    $0x4,%esp
  801d6a:	68 ac 43 80 00       	push   $0x8043ac
  801d6f:	6a 39                	push   $0x39
  801d71:	68 59 43 80 00       	push   $0x804359
  801d76:	e8 9f ed ff ff       	call   800b1a <_panic>

00801d7b <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
  801d7e:	57                   	push   %edi
  801d7f:	56                   	push   %esi
  801d80:	53                   	push   %ebx
  801d81:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801d84:	68 7c 1c 80 00       	push   $0x801c7c
  801d89:	e8 2c 1b 00 00       	call   8038ba <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801d8e:	b8 07 00 00 00       	mov    $0x7,%eax
  801d93:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801d95:	83 c4 10             	add    $0x10,%esp
  801d98:	85 c0                	test   %eax,%eax
  801d9a:	78 27                	js     801dc3 <fork+0x48>
  801d9c:	89 c6                	mov    %eax,%esi
  801d9e:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801da0:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801da5:	75 48                	jne    801def <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  801da7:	e8 67 fa ff ff       	call   801813 <sys_getenvid>
  801dac:	25 ff 03 00 00       	and    $0x3ff,%eax
  801db1:	c1 e0 07             	shl    $0x7,%eax
  801db4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801db9:	a3 28 64 80 00       	mov    %eax,0x806428
		return 0;
  801dbe:	e9 90 00 00 00       	jmp    801e53 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  801dc3:	83 ec 04             	sub    $0x4,%esp
  801dc6:	68 c8 43 80 00       	push   $0x8043c8
  801dcb:	68 8c 00 00 00       	push   $0x8c
  801dd0:	68 59 43 80 00       	push   $0x804359
  801dd5:	e8 40 ed ff ff       	call   800b1a <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801dda:	89 f8                	mov    %edi,%eax
  801ddc:	e8 45 fd ff ff       	call   801b26 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801de1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801de7:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801ded:	74 26                	je     801e15 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801def:	89 d8                	mov    %ebx,%eax
  801df1:	c1 e8 16             	shr    $0x16,%eax
  801df4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801dfb:	a8 01                	test   $0x1,%al
  801dfd:	74 e2                	je     801de1 <fork+0x66>
  801dff:	89 da                	mov    %ebx,%edx
  801e01:	c1 ea 0c             	shr    $0xc,%edx
  801e04:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801e0b:	83 e0 05             	and    $0x5,%eax
  801e0e:	83 f8 05             	cmp    $0x5,%eax
  801e11:	75 ce                	jne    801de1 <fork+0x66>
  801e13:	eb c5                	jmp    801dda <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801e15:	83 ec 04             	sub    $0x4,%esp
  801e18:	6a 07                	push   $0x7
  801e1a:	68 00 f0 bf ee       	push   $0xeebff000
  801e1f:	56                   	push   %esi
  801e20:	e8 2c fa ff ff       	call   801851 <sys_page_alloc>
	if(ret < 0)
  801e25:	83 c4 10             	add    $0x10,%esp
  801e28:	85 c0                	test   %eax,%eax
  801e2a:	78 31                	js     801e5d <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801e2c:	83 ec 08             	sub    $0x8,%esp
  801e2f:	68 29 39 80 00       	push   $0x803929
  801e34:	56                   	push   %esi
  801e35:	e8 62 fb ff ff       	call   80199c <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801e3a:	83 c4 10             	add    $0x10,%esp
  801e3d:	85 c0                	test   %eax,%eax
  801e3f:	78 33                	js     801e74 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801e41:	83 ec 08             	sub    $0x8,%esp
  801e44:	6a 02                	push   $0x2
  801e46:	56                   	push   %esi
  801e47:	e8 cc fa ff ff       	call   801918 <sys_env_set_status>
	if(ret < 0)
  801e4c:	83 c4 10             	add    $0x10,%esp
  801e4f:	85 c0                	test   %eax,%eax
  801e51:	78 38                	js     801e8b <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801e53:	89 f0                	mov    %esi,%eax
  801e55:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e58:	5b                   	pop    %ebx
  801e59:	5e                   	pop    %esi
  801e5a:	5f                   	pop    %edi
  801e5b:	5d                   	pop    %ebp
  801e5c:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801e5d:	83 ec 04             	sub    $0x4,%esp
  801e60:	68 78 43 80 00       	push   $0x804378
  801e65:	68 98 00 00 00       	push   $0x98
  801e6a:	68 59 43 80 00       	push   $0x804359
  801e6f:	e8 a6 ec ff ff       	call   800b1a <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801e74:	83 ec 04             	sub    $0x4,%esp
  801e77:	68 ec 43 80 00       	push   $0x8043ec
  801e7c:	68 9b 00 00 00       	push   $0x9b
  801e81:	68 59 43 80 00       	push   $0x804359
  801e86:	e8 8f ec ff ff       	call   800b1a <_panic>
		panic("panic in sys_env_set_status()\n");
  801e8b:	83 ec 04             	sub    $0x4,%esp
  801e8e:	68 14 44 80 00       	push   $0x804414
  801e93:	68 9e 00 00 00       	push   $0x9e
  801e98:	68 59 43 80 00       	push   $0x804359
  801e9d:	e8 78 ec ff ff       	call   800b1a <_panic>

00801ea2 <sfork>:

// Challenge!
int
sfork(void)
{
  801ea2:	55                   	push   %ebp
  801ea3:	89 e5                	mov    %esp,%ebp
  801ea5:	57                   	push   %edi
  801ea6:	56                   	push   %esi
  801ea7:	53                   	push   %ebx
  801ea8:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801eab:	68 7c 1c 80 00       	push   $0x801c7c
  801eb0:	e8 05 1a 00 00       	call   8038ba <set_pgfault_handler>
  801eb5:	b8 07 00 00 00       	mov    $0x7,%eax
  801eba:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801ebc:	83 c4 10             	add    $0x10,%esp
  801ebf:	85 c0                	test   %eax,%eax
  801ec1:	78 27                	js     801eea <sfork+0x48>
  801ec3:	89 c7                	mov    %eax,%edi
  801ec5:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801ec7:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801ecc:	75 55                	jne    801f23 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801ece:	e8 40 f9 ff ff       	call   801813 <sys_getenvid>
  801ed3:	25 ff 03 00 00       	and    $0x3ff,%eax
  801ed8:	c1 e0 07             	shl    $0x7,%eax
  801edb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801ee0:	a3 28 64 80 00       	mov    %eax,0x806428
		return 0;
  801ee5:	e9 d4 00 00 00       	jmp    801fbe <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  801eea:	83 ec 04             	sub    $0x4,%esp
  801eed:	68 c8 43 80 00       	push   $0x8043c8
  801ef2:	68 af 00 00 00       	push   $0xaf
  801ef7:	68 59 43 80 00       	push   $0x804359
  801efc:	e8 19 ec ff ff       	call   800b1a <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801f01:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801f06:	89 f0                	mov    %esi,%eax
  801f08:	e8 19 fc ff ff       	call   801b26 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801f0d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801f13:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801f19:	77 65                	ja     801f80 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801f1b:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801f21:	74 de                	je     801f01 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801f23:	89 d8                	mov    %ebx,%eax
  801f25:	c1 e8 16             	shr    $0x16,%eax
  801f28:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801f2f:	a8 01                	test   $0x1,%al
  801f31:	74 da                	je     801f0d <sfork+0x6b>
  801f33:	89 da                	mov    %ebx,%edx
  801f35:	c1 ea 0c             	shr    $0xc,%edx
  801f38:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801f3f:	83 e0 05             	and    $0x5,%eax
  801f42:	83 f8 05             	cmp    $0x5,%eax
  801f45:	75 c6                	jne    801f0d <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801f47:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801f4e:	c1 e2 0c             	shl    $0xc,%edx
  801f51:	83 ec 0c             	sub    $0xc,%esp
  801f54:	83 e0 07             	and    $0x7,%eax
  801f57:	50                   	push   %eax
  801f58:	52                   	push   %edx
  801f59:	56                   	push   %esi
  801f5a:	52                   	push   %edx
  801f5b:	6a 00                	push   $0x0
  801f5d:	e8 32 f9 ff ff       	call   801894 <sys_page_map>
  801f62:	83 c4 20             	add    $0x20,%esp
  801f65:	85 c0                	test   %eax,%eax
  801f67:	74 a4                	je     801f0d <sfork+0x6b>
				panic("sys_page_map() panic\n");
  801f69:	83 ec 04             	sub    $0x4,%esp
  801f6c:	68 43 43 80 00       	push   $0x804343
  801f71:	68 ba 00 00 00       	push   $0xba
  801f76:	68 59 43 80 00       	push   $0x804359
  801f7b:	e8 9a eb ff ff       	call   800b1a <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801f80:	83 ec 04             	sub    $0x4,%esp
  801f83:	6a 07                	push   $0x7
  801f85:	68 00 f0 bf ee       	push   $0xeebff000
  801f8a:	57                   	push   %edi
  801f8b:	e8 c1 f8 ff ff       	call   801851 <sys_page_alloc>
	if(ret < 0)
  801f90:	83 c4 10             	add    $0x10,%esp
  801f93:	85 c0                	test   %eax,%eax
  801f95:	78 31                	js     801fc8 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801f97:	83 ec 08             	sub    $0x8,%esp
  801f9a:	68 29 39 80 00       	push   $0x803929
  801f9f:	57                   	push   %edi
  801fa0:	e8 f7 f9 ff ff       	call   80199c <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801fa5:	83 c4 10             	add    $0x10,%esp
  801fa8:	85 c0                	test   %eax,%eax
  801faa:	78 33                	js     801fdf <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801fac:	83 ec 08             	sub    $0x8,%esp
  801faf:	6a 02                	push   $0x2
  801fb1:	57                   	push   %edi
  801fb2:	e8 61 f9 ff ff       	call   801918 <sys_env_set_status>
	if(ret < 0)
  801fb7:	83 c4 10             	add    $0x10,%esp
  801fba:	85 c0                	test   %eax,%eax
  801fbc:	78 38                	js     801ff6 <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801fbe:	89 f8                	mov    %edi,%eax
  801fc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fc3:	5b                   	pop    %ebx
  801fc4:	5e                   	pop    %esi
  801fc5:	5f                   	pop    %edi
  801fc6:	5d                   	pop    %ebp
  801fc7:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801fc8:	83 ec 04             	sub    $0x4,%esp
  801fcb:	68 78 43 80 00       	push   $0x804378
  801fd0:	68 c0 00 00 00       	push   $0xc0
  801fd5:	68 59 43 80 00       	push   $0x804359
  801fda:	e8 3b eb ff ff       	call   800b1a <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801fdf:	83 ec 04             	sub    $0x4,%esp
  801fe2:	68 ec 43 80 00       	push   $0x8043ec
  801fe7:	68 c3 00 00 00       	push   $0xc3
  801fec:	68 59 43 80 00       	push   $0x804359
  801ff1:	e8 24 eb ff ff       	call   800b1a <_panic>
		panic("panic in sys_env_set_status()\n");
  801ff6:	83 ec 04             	sub    $0x4,%esp
  801ff9:	68 14 44 80 00       	push   $0x804414
  801ffe:	68 c6 00 00 00       	push   $0xc6
  802003:	68 59 43 80 00       	push   $0x804359
  802008:	e8 0d eb ff ff       	call   800b1a <_panic>

0080200d <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  80200d:	55                   	push   %ebp
  80200e:	89 e5                	mov    %esp,%ebp
  802010:	8b 55 08             	mov    0x8(%ebp),%edx
  802013:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802016:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  802019:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  80201b:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  80201e:	83 3a 01             	cmpl   $0x1,(%edx)
  802021:	7e 09                	jle    80202c <argstart+0x1f>
  802023:	ba 01 3d 80 00       	mov    $0x803d01,%edx
  802028:	85 c9                	test   %ecx,%ecx
  80202a:	75 05                	jne    802031 <argstart+0x24>
  80202c:	ba 00 00 00 00       	mov    $0x0,%edx
  802031:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  802034:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  80203b:	5d                   	pop    %ebp
  80203c:	c3                   	ret    

0080203d <argnext>:

int
argnext(struct Argstate *args)
{
  80203d:	55                   	push   %ebp
  80203e:	89 e5                	mov    %esp,%ebp
  802040:	53                   	push   %ebx
  802041:	83 ec 04             	sub    $0x4,%esp
  802044:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  802047:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  80204e:	8b 43 08             	mov    0x8(%ebx),%eax
  802051:	85 c0                	test   %eax,%eax
  802053:	74 72                	je     8020c7 <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  802055:	80 38 00             	cmpb   $0x0,(%eax)
  802058:	75 48                	jne    8020a2 <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  80205a:	8b 0b                	mov    (%ebx),%ecx
  80205c:	83 39 01             	cmpl   $0x1,(%ecx)
  80205f:	74 58                	je     8020b9 <argnext+0x7c>
		    || args->argv[1][0] != '-'
  802061:	8b 53 04             	mov    0x4(%ebx),%edx
  802064:	8b 42 04             	mov    0x4(%edx),%eax
  802067:	80 38 2d             	cmpb   $0x2d,(%eax)
  80206a:	75 4d                	jne    8020b9 <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  80206c:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  802070:	74 47                	je     8020b9 <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  802072:	83 c0 01             	add    $0x1,%eax
  802075:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  802078:	83 ec 04             	sub    $0x4,%esp
  80207b:	8b 01                	mov    (%ecx),%eax
  80207d:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  802084:	50                   	push   %eax
  802085:	8d 42 08             	lea    0x8(%edx),%eax
  802088:	50                   	push   %eax
  802089:	83 c2 04             	add    $0x4,%edx
  80208c:	52                   	push   %edx
  80208d:	e8 5b f5 ff ff       	call   8015ed <memmove>
		(*args->argc)--;
  802092:	8b 03                	mov    (%ebx),%eax
  802094:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  802097:	8b 43 08             	mov    0x8(%ebx),%eax
  80209a:	83 c4 10             	add    $0x10,%esp
  80209d:	80 38 2d             	cmpb   $0x2d,(%eax)
  8020a0:	74 11                	je     8020b3 <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  8020a2:	8b 53 08             	mov    0x8(%ebx),%edx
  8020a5:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  8020a8:	83 c2 01             	add    $0x1,%edx
  8020ab:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  8020ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020b1:	c9                   	leave  
  8020b2:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8020b3:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  8020b7:	75 e9                	jne    8020a2 <argnext+0x65>
	args->curarg = 0;
  8020b9:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  8020c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8020c5:	eb e7                	jmp    8020ae <argnext+0x71>
		return -1;
  8020c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8020cc:	eb e0                	jmp    8020ae <argnext+0x71>

008020ce <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  8020ce:	55                   	push   %ebp
  8020cf:	89 e5                	mov    %esp,%ebp
  8020d1:	53                   	push   %ebx
  8020d2:	83 ec 04             	sub    $0x4,%esp
  8020d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  8020d8:	8b 43 08             	mov    0x8(%ebx),%eax
  8020db:	85 c0                	test   %eax,%eax
  8020dd:	74 12                	je     8020f1 <argnextvalue+0x23>
		return 0;
	if (*args->curarg) {
  8020df:	80 38 00             	cmpb   $0x0,(%eax)
  8020e2:	74 12                	je     8020f6 <argnextvalue+0x28>
		args->argvalue = args->curarg;
  8020e4:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  8020e7:	c7 43 08 01 3d 80 00 	movl   $0x803d01,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  8020ee:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  8020f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020f4:	c9                   	leave  
  8020f5:	c3                   	ret    
	} else if (*args->argc > 1) {
  8020f6:	8b 13                	mov    (%ebx),%edx
  8020f8:	83 3a 01             	cmpl   $0x1,(%edx)
  8020fb:	7f 10                	jg     80210d <argnextvalue+0x3f>
		args->argvalue = 0;
  8020fd:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  802104:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  80210b:	eb e1                	jmp    8020ee <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  80210d:	8b 43 04             	mov    0x4(%ebx),%eax
  802110:	8b 48 04             	mov    0x4(%eax),%ecx
  802113:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  802116:	83 ec 04             	sub    $0x4,%esp
  802119:	8b 12                	mov    (%edx),%edx
  80211b:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  802122:	52                   	push   %edx
  802123:	8d 50 08             	lea    0x8(%eax),%edx
  802126:	52                   	push   %edx
  802127:	83 c0 04             	add    $0x4,%eax
  80212a:	50                   	push   %eax
  80212b:	e8 bd f4 ff ff       	call   8015ed <memmove>
		(*args->argc)--;
  802130:	8b 03                	mov    (%ebx),%eax
  802132:	83 28 01             	subl   $0x1,(%eax)
  802135:	83 c4 10             	add    $0x10,%esp
  802138:	eb b4                	jmp    8020ee <argnextvalue+0x20>

0080213a <argvalue>:
{
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
  80213d:	83 ec 08             	sub    $0x8,%esp
  802140:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  802143:	8b 42 0c             	mov    0xc(%edx),%eax
  802146:	85 c0                	test   %eax,%eax
  802148:	74 02                	je     80214c <argvalue+0x12>
}
  80214a:	c9                   	leave  
  80214b:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  80214c:	83 ec 0c             	sub    $0xc,%esp
  80214f:	52                   	push   %edx
  802150:	e8 79 ff ff ff       	call   8020ce <argnextvalue>
  802155:	83 c4 10             	add    $0x10,%esp
  802158:	eb f0                	jmp    80214a <argvalue+0x10>

0080215a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80215d:	8b 45 08             	mov    0x8(%ebp),%eax
  802160:	05 00 00 00 30       	add    $0x30000000,%eax
  802165:	c1 e8 0c             	shr    $0xc,%eax
}
  802168:	5d                   	pop    %ebp
  802169:	c3                   	ret    

0080216a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80216a:	55                   	push   %ebp
  80216b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80216d:	8b 45 08             	mov    0x8(%ebp),%eax
  802170:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  802175:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80217a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80217f:	5d                   	pop    %ebp
  802180:	c3                   	ret    

00802181 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802181:	55                   	push   %ebp
  802182:	89 e5                	mov    %esp,%ebp
  802184:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802189:	89 c2                	mov    %eax,%edx
  80218b:	c1 ea 16             	shr    $0x16,%edx
  80218e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802195:	f6 c2 01             	test   $0x1,%dl
  802198:	74 2d                	je     8021c7 <fd_alloc+0x46>
  80219a:	89 c2                	mov    %eax,%edx
  80219c:	c1 ea 0c             	shr    $0xc,%edx
  80219f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8021a6:	f6 c2 01             	test   $0x1,%dl
  8021a9:	74 1c                	je     8021c7 <fd_alloc+0x46>
  8021ab:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8021b0:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8021b5:	75 d2                	jne    802189 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8021b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8021c0:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8021c5:	eb 0a                	jmp    8021d1 <fd_alloc+0x50>
			*fd_store = fd;
  8021c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021ca:	89 01                	mov    %eax,(%ecx)
			return 0;
  8021cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021d1:	5d                   	pop    %ebp
  8021d2:	c3                   	ret    

008021d3 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8021d3:	55                   	push   %ebp
  8021d4:	89 e5                	mov    %esp,%ebp
  8021d6:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8021d9:	83 f8 1f             	cmp    $0x1f,%eax
  8021dc:	77 30                	ja     80220e <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8021de:	c1 e0 0c             	shl    $0xc,%eax
  8021e1:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8021e6:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8021ec:	f6 c2 01             	test   $0x1,%dl
  8021ef:	74 24                	je     802215 <fd_lookup+0x42>
  8021f1:	89 c2                	mov    %eax,%edx
  8021f3:	c1 ea 0c             	shr    $0xc,%edx
  8021f6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8021fd:	f6 c2 01             	test   $0x1,%dl
  802200:	74 1a                	je     80221c <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  802202:	8b 55 0c             	mov    0xc(%ebp),%edx
  802205:	89 02                	mov    %eax,(%edx)
	return 0;
  802207:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80220c:	5d                   	pop    %ebp
  80220d:	c3                   	ret    
		return -E_INVAL;
  80220e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802213:	eb f7                	jmp    80220c <fd_lookup+0x39>
		return -E_INVAL;
  802215:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80221a:	eb f0                	jmp    80220c <fd_lookup+0x39>
  80221c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802221:	eb e9                	jmp    80220c <fd_lookup+0x39>

00802223 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802223:	55                   	push   %ebp
  802224:	89 e5                	mov    %esp,%ebp
  802226:	83 ec 08             	sub    $0x8,%esp
  802229:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80222c:	ba 00 00 00 00       	mov    $0x0,%edx
  802231:	b8 20 50 80 00       	mov    $0x805020,%eax
		if (devtab[i]->dev_id == dev_id) {
  802236:	39 08                	cmp    %ecx,(%eax)
  802238:	74 38                	je     802272 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80223a:	83 c2 01             	add    $0x1,%edx
  80223d:	8b 04 95 b0 44 80 00 	mov    0x8044b0(,%edx,4),%eax
  802244:	85 c0                	test   %eax,%eax
  802246:	75 ee                	jne    802236 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802248:	a1 28 64 80 00       	mov    0x806428,%eax
  80224d:	8b 40 48             	mov    0x48(%eax),%eax
  802250:	83 ec 04             	sub    $0x4,%esp
  802253:	51                   	push   %ecx
  802254:	50                   	push   %eax
  802255:	68 34 44 80 00       	push   $0x804434
  80225a:	e8 b1 e9 ff ff       	call   800c10 <cprintf>
	*dev = 0;
  80225f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802262:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  802268:	83 c4 10             	add    $0x10,%esp
  80226b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802270:	c9                   	leave  
  802271:	c3                   	ret    
			*dev = devtab[i];
  802272:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802275:	89 01                	mov    %eax,(%ecx)
			return 0;
  802277:	b8 00 00 00 00       	mov    $0x0,%eax
  80227c:	eb f2                	jmp    802270 <dev_lookup+0x4d>

0080227e <fd_close>:
{
  80227e:	55                   	push   %ebp
  80227f:	89 e5                	mov    %esp,%ebp
  802281:	57                   	push   %edi
  802282:	56                   	push   %esi
  802283:	53                   	push   %ebx
  802284:	83 ec 24             	sub    $0x24,%esp
  802287:	8b 75 08             	mov    0x8(%ebp),%esi
  80228a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80228d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802290:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802291:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  802297:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80229a:	50                   	push   %eax
  80229b:	e8 33 ff ff ff       	call   8021d3 <fd_lookup>
  8022a0:	89 c3                	mov    %eax,%ebx
  8022a2:	83 c4 10             	add    $0x10,%esp
  8022a5:	85 c0                	test   %eax,%eax
  8022a7:	78 05                	js     8022ae <fd_close+0x30>
	    || fd != fd2)
  8022a9:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8022ac:	74 16                	je     8022c4 <fd_close+0x46>
		return (must_exist ? r : 0);
  8022ae:	89 f8                	mov    %edi,%eax
  8022b0:	84 c0                	test   %al,%al
  8022b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b7:	0f 44 d8             	cmove  %eax,%ebx
}
  8022ba:	89 d8                	mov    %ebx,%eax
  8022bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022bf:	5b                   	pop    %ebx
  8022c0:	5e                   	pop    %esi
  8022c1:	5f                   	pop    %edi
  8022c2:	5d                   	pop    %ebp
  8022c3:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8022c4:	83 ec 08             	sub    $0x8,%esp
  8022c7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8022ca:	50                   	push   %eax
  8022cb:	ff 36                	pushl  (%esi)
  8022cd:	e8 51 ff ff ff       	call   802223 <dev_lookup>
  8022d2:	89 c3                	mov    %eax,%ebx
  8022d4:	83 c4 10             	add    $0x10,%esp
  8022d7:	85 c0                	test   %eax,%eax
  8022d9:	78 1a                	js     8022f5 <fd_close+0x77>
		if (dev->dev_close)
  8022db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022de:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8022e1:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8022e6:	85 c0                	test   %eax,%eax
  8022e8:	74 0b                	je     8022f5 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8022ea:	83 ec 0c             	sub    $0xc,%esp
  8022ed:	56                   	push   %esi
  8022ee:	ff d0                	call   *%eax
  8022f0:	89 c3                	mov    %eax,%ebx
  8022f2:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8022f5:	83 ec 08             	sub    $0x8,%esp
  8022f8:	56                   	push   %esi
  8022f9:	6a 00                	push   $0x0
  8022fb:	e8 d6 f5 ff ff       	call   8018d6 <sys_page_unmap>
	return r;
  802300:	83 c4 10             	add    $0x10,%esp
  802303:	eb b5                	jmp    8022ba <fd_close+0x3c>

00802305 <close>:

int
close(int fdnum)
{
  802305:	55                   	push   %ebp
  802306:	89 e5                	mov    %esp,%ebp
  802308:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80230b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80230e:	50                   	push   %eax
  80230f:	ff 75 08             	pushl  0x8(%ebp)
  802312:	e8 bc fe ff ff       	call   8021d3 <fd_lookup>
  802317:	83 c4 10             	add    $0x10,%esp
  80231a:	85 c0                	test   %eax,%eax
  80231c:	79 02                	jns    802320 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80231e:	c9                   	leave  
  80231f:	c3                   	ret    
		return fd_close(fd, 1);
  802320:	83 ec 08             	sub    $0x8,%esp
  802323:	6a 01                	push   $0x1
  802325:	ff 75 f4             	pushl  -0xc(%ebp)
  802328:	e8 51 ff ff ff       	call   80227e <fd_close>
  80232d:	83 c4 10             	add    $0x10,%esp
  802330:	eb ec                	jmp    80231e <close+0x19>

00802332 <close_all>:

void
close_all(void)
{
  802332:	55                   	push   %ebp
  802333:	89 e5                	mov    %esp,%ebp
  802335:	53                   	push   %ebx
  802336:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  802339:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80233e:	83 ec 0c             	sub    $0xc,%esp
  802341:	53                   	push   %ebx
  802342:	e8 be ff ff ff       	call   802305 <close>
	for (i = 0; i < MAXFD; i++)
  802347:	83 c3 01             	add    $0x1,%ebx
  80234a:	83 c4 10             	add    $0x10,%esp
  80234d:	83 fb 20             	cmp    $0x20,%ebx
  802350:	75 ec                	jne    80233e <close_all+0xc>
}
  802352:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802355:	c9                   	leave  
  802356:	c3                   	ret    

00802357 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802357:	55                   	push   %ebp
  802358:	89 e5                	mov    %esp,%ebp
  80235a:	57                   	push   %edi
  80235b:	56                   	push   %esi
  80235c:	53                   	push   %ebx
  80235d:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802360:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802363:	50                   	push   %eax
  802364:	ff 75 08             	pushl  0x8(%ebp)
  802367:	e8 67 fe ff ff       	call   8021d3 <fd_lookup>
  80236c:	89 c3                	mov    %eax,%ebx
  80236e:	83 c4 10             	add    $0x10,%esp
  802371:	85 c0                	test   %eax,%eax
  802373:	0f 88 81 00 00 00    	js     8023fa <dup+0xa3>
		return r;
	close(newfdnum);
  802379:	83 ec 0c             	sub    $0xc,%esp
  80237c:	ff 75 0c             	pushl  0xc(%ebp)
  80237f:	e8 81 ff ff ff       	call   802305 <close>

	newfd = INDEX2FD(newfdnum);
  802384:	8b 75 0c             	mov    0xc(%ebp),%esi
  802387:	c1 e6 0c             	shl    $0xc,%esi
  80238a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  802390:	83 c4 04             	add    $0x4,%esp
  802393:	ff 75 e4             	pushl  -0x1c(%ebp)
  802396:	e8 cf fd ff ff       	call   80216a <fd2data>
  80239b:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80239d:	89 34 24             	mov    %esi,(%esp)
  8023a0:	e8 c5 fd ff ff       	call   80216a <fd2data>
  8023a5:	83 c4 10             	add    $0x10,%esp
  8023a8:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8023aa:	89 d8                	mov    %ebx,%eax
  8023ac:	c1 e8 16             	shr    $0x16,%eax
  8023af:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8023b6:	a8 01                	test   $0x1,%al
  8023b8:	74 11                	je     8023cb <dup+0x74>
  8023ba:	89 d8                	mov    %ebx,%eax
  8023bc:	c1 e8 0c             	shr    $0xc,%eax
  8023bf:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8023c6:	f6 c2 01             	test   $0x1,%dl
  8023c9:	75 39                	jne    802404 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8023cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023ce:	89 d0                	mov    %edx,%eax
  8023d0:	c1 e8 0c             	shr    $0xc,%eax
  8023d3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8023da:	83 ec 0c             	sub    $0xc,%esp
  8023dd:	25 07 0e 00 00       	and    $0xe07,%eax
  8023e2:	50                   	push   %eax
  8023e3:	56                   	push   %esi
  8023e4:	6a 00                	push   $0x0
  8023e6:	52                   	push   %edx
  8023e7:	6a 00                	push   $0x0
  8023e9:	e8 a6 f4 ff ff       	call   801894 <sys_page_map>
  8023ee:	89 c3                	mov    %eax,%ebx
  8023f0:	83 c4 20             	add    $0x20,%esp
  8023f3:	85 c0                	test   %eax,%eax
  8023f5:	78 31                	js     802428 <dup+0xd1>
		goto err;

	return newfdnum;
  8023f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8023fa:	89 d8                	mov    %ebx,%eax
  8023fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023ff:	5b                   	pop    %ebx
  802400:	5e                   	pop    %esi
  802401:	5f                   	pop    %edi
  802402:	5d                   	pop    %ebp
  802403:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802404:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80240b:	83 ec 0c             	sub    $0xc,%esp
  80240e:	25 07 0e 00 00       	and    $0xe07,%eax
  802413:	50                   	push   %eax
  802414:	57                   	push   %edi
  802415:	6a 00                	push   $0x0
  802417:	53                   	push   %ebx
  802418:	6a 00                	push   $0x0
  80241a:	e8 75 f4 ff ff       	call   801894 <sys_page_map>
  80241f:	89 c3                	mov    %eax,%ebx
  802421:	83 c4 20             	add    $0x20,%esp
  802424:	85 c0                	test   %eax,%eax
  802426:	79 a3                	jns    8023cb <dup+0x74>
	sys_page_unmap(0, newfd);
  802428:	83 ec 08             	sub    $0x8,%esp
  80242b:	56                   	push   %esi
  80242c:	6a 00                	push   $0x0
  80242e:	e8 a3 f4 ff ff       	call   8018d6 <sys_page_unmap>
	sys_page_unmap(0, nva);
  802433:	83 c4 08             	add    $0x8,%esp
  802436:	57                   	push   %edi
  802437:	6a 00                	push   $0x0
  802439:	e8 98 f4 ff ff       	call   8018d6 <sys_page_unmap>
	return r;
  80243e:	83 c4 10             	add    $0x10,%esp
  802441:	eb b7                	jmp    8023fa <dup+0xa3>

00802443 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802443:	55                   	push   %ebp
  802444:	89 e5                	mov    %esp,%ebp
  802446:	53                   	push   %ebx
  802447:	83 ec 1c             	sub    $0x1c,%esp
  80244a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80244d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802450:	50                   	push   %eax
  802451:	53                   	push   %ebx
  802452:	e8 7c fd ff ff       	call   8021d3 <fd_lookup>
  802457:	83 c4 10             	add    $0x10,%esp
  80245a:	85 c0                	test   %eax,%eax
  80245c:	78 3f                	js     80249d <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80245e:	83 ec 08             	sub    $0x8,%esp
  802461:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802464:	50                   	push   %eax
  802465:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802468:	ff 30                	pushl  (%eax)
  80246a:	e8 b4 fd ff ff       	call   802223 <dev_lookup>
  80246f:	83 c4 10             	add    $0x10,%esp
  802472:	85 c0                	test   %eax,%eax
  802474:	78 27                	js     80249d <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802476:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802479:	8b 42 08             	mov    0x8(%edx),%eax
  80247c:	83 e0 03             	and    $0x3,%eax
  80247f:	83 f8 01             	cmp    $0x1,%eax
  802482:	74 1e                	je     8024a2 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  802484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802487:	8b 40 08             	mov    0x8(%eax),%eax
  80248a:	85 c0                	test   %eax,%eax
  80248c:	74 35                	je     8024c3 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80248e:	83 ec 04             	sub    $0x4,%esp
  802491:	ff 75 10             	pushl  0x10(%ebp)
  802494:	ff 75 0c             	pushl  0xc(%ebp)
  802497:	52                   	push   %edx
  802498:	ff d0                	call   *%eax
  80249a:	83 c4 10             	add    $0x10,%esp
}
  80249d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024a0:	c9                   	leave  
  8024a1:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8024a2:	a1 28 64 80 00       	mov    0x806428,%eax
  8024a7:	8b 40 48             	mov    0x48(%eax),%eax
  8024aa:	83 ec 04             	sub    $0x4,%esp
  8024ad:	53                   	push   %ebx
  8024ae:	50                   	push   %eax
  8024af:	68 75 44 80 00       	push   $0x804475
  8024b4:	e8 57 e7 ff ff       	call   800c10 <cprintf>
		return -E_INVAL;
  8024b9:	83 c4 10             	add    $0x10,%esp
  8024bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024c1:	eb da                	jmp    80249d <read+0x5a>
		return -E_NOT_SUPP;
  8024c3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8024c8:	eb d3                	jmp    80249d <read+0x5a>

008024ca <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8024ca:	55                   	push   %ebp
  8024cb:	89 e5                	mov    %esp,%ebp
  8024cd:	57                   	push   %edi
  8024ce:	56                   	push   %esi
  8024cf:	53                   	push   %ebx
  8024d0:	83 ec 0c             	sub    $0xc,%esp
  8024d3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8024d6:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8024d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8024de:	39 f3                	cmp    %esi,%ebx
  8024e0:	73 23                	jae    802505 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8024e2:	83 ec 04             	sub    $0x4,%esp
  8024e5:	89 f0                	mov    %esi,%eax
  8024e7:	29 d8                	sub    %ebx,%eax
  8024e9:	50                   	push   %eax
  8024ea:	89 d8                	mov    %ebx,%eax
  8024ec:	03 45 0c             	add    0xc(%ebp),%eax
  8024ef:	50                   	push   %eax
  8024f0:	57                   	push   %edi
  8024f1:	e8 4d ff ff ff       	call   802443 <read>
		if (m < 0)
  8024f6:	83 c4 10             	add    $0x10,%esp
  8024f9:	85 c0                	test   %eax,%eax
  8024fb:	78 06                	js     802503 <readn+0x39>
			return m;
		if (m == 0)
  8024fd:	74 06                	je     802505 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8024ff:	01 c3                	add    %eax,%ebx
  802501:	eb db                	jmp    8024de <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802503:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  802505:	89 d8                	mov    %ebx,%eax
  802507:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80250a:	5b                   	pop    %ebx
  80250b:	5e                   	pop    %esi
  80250c:	5f                   	pop    %edi
  80250d:	5d                   	pop    %ebp
  80250e:	c3                   	ret    

0080250f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80250f:	55                   	push   %ebp
  802510:	89 e5                	mov    %esp,%ebp
  802512:	53                   	push   %ebx
  802513:	83 ec 1c             	sub    $0x1c,%esp
  802516:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802519:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80251c:	50                   	push   %eax
  80251d:	53                   	push   %ebx
  80251e:	e8 b0 fc ff ff       	call   8021d3 <fd_lookup>
  802523:	83 c4 10             	add    $0x10,%esp
  802526:	85 c0                	test   %eax,%eax
  802528:	78 3a                	js     802564 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80252a:	83 ec 08             	sub    $0x8,%esp
  80252d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802530:	50                   	push   %eax
  802531:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802534:	ff 30                	pushl  (%eax)
  802536:	e8 e8 fc ff ff       	call   802223 <dev_lookup>
  80253b:	83 c4 10             	add    $0x10,%esp
  80253e:	85 c0                	test   %eax,%eax
  802540:	78 22                	js     802564 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802542:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802545:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802549:	74 1e                	je     802569 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80254b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80254e:	8b 52 0c             	mov    0xc(%edx),%edx
  802551:	85 d2                	test   %edx,%edx
  802553:	74 35                	je     80258a <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802555:	83 ec 04             	sub    $0x4,%esp
  802558:	ff 75 10             	pushl  0x10(%ebp)
  80255b:	ff 75 0c             	pushl  0xc(%ebp)
  80255e:	50                   	push   %eax
  80255f:	ff d2                	call   *%edx
  802561:	83 c4 10             	add    $0x10,%esp
}
  802564:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802567:	c9                   	leave  
  802568:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802569:	a1 28 64 80 00       	mov    0x806428,%eax
  80256e:	8b 40 48             	mov    0x48(%eax),%eax
  802571:	83 ec 04             	sub    $0x4,%esp
  802574:	53                   	push   %ebx
  802575:	50                   	push   %eax
  802576:	68 91 44 80 00       	push   $0x804491
  80257b:	e8 90 e6 ff ff       	call   800c10 <cprintf>
		return -E_INVAL;
  802580:	83 c4 10             	add    $0x10,%esp
  802583:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802588:	eb da                	jmp    802564 <write+0x55>
		return -E_NOT_SUPP;
  80258a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80258f:	eb d3                	jmp    802564 <write+0x55>

00802591 <seek>:

int
seek(int fdnum, off_t offset)
{
  802591:	55                   	push   %ebp
  802592:	89 e5                	mov    %esp,%ebp
  802594:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802597:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80259a:	50                   	push   %eax
  80259b:	ff 75 08             	pushl  0x8(%ebp)
  80259e:	e8 30 fc ff ff       	call   8021d3 <fd_lookup>
  8025a3:	83 c4 10             	add    $0x10,%esp
  8025a6:	85 c0                	test   %eax,%eax
  8025a8:	78 0e                	js     8025b8 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8025aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b0:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8025b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025b8:	c9                   	leave  
  8025b9:	c3                   	ret    

008025ba <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8025ba:	55                   	push   %ebp
  8025bb:	89 e5                	mov    %esp,%ebp
  8025bd:	53                   	push   %ebx
  8025be:	83 ec 1c             	sub    $0x1c,%esp
  8025c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8025c7:	50                   	push   %eax
  8025c8:	53                   	push   %ebx
  8025c9:	e8 05 fc ff ff       	call   8021d3 <fd_lookup>
  8025ce:	83 c4 10             	add    $0x10,%esp
  8025d1:	85 c0                	test   %eax,%eax
  8025d3:	78 37                	js     80260c <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025d5:	83 ec 08             	sub    $0x8,%esp
  8025d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025db:	50                   	push   %eax
  8025dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025df:	ff 30                	pushl  (%eax)
  8025e1:	e8 3d fc ff ff       	call   802223 <dev_lookup>
  8025e6:	83 c4 10             	add    $0x10,%esp
  8025e9:	85 c0                	test   %eax,%eax
  8025eb:	78 1f                	js     80260c <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8025ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8025f4:	74 1b                	je     802611 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8025f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f9:	8b 52 18             	mov    0x18(%edx),%edx
  8025fc:	85 d2                	test   %edx,%edx
  8025fe:	74 32                	je     802632 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  802600:	83 ec 08             	sub    $0x8,%esp
  802603:	ff 75 0c             	pushl  0xc(%ebp)
  802606:	50                   	push   %eax
  802607:	ff d2                	call   *%edx
  802609:	83 c4 10             	add    $0x10,%esp
}
  80260c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80260f:	c9                   	leave  
  802610:	c3                   	ret    
			thisenv->env_id, fdnum);
  802611:	a1 28 64 80 00       	mov    0x806428,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802616:	8b 40 48             	mov    0x48(%eax),%eax
  802619:	83 ec 04             	sub    $0x4,%esp
  80261c:	53                   	push   %ebx
  80261d:	50                   	push   %eax
  80261e:	68 54 44 80 00       	push   $0x804454
  802623:	e8 e8 e5 ff ff       	call   800c10 <cprintf>
		return -E_INVAL;
  802628:	83 c4 10             	add    $0x10,%esp
  80262b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802630:	eb da                	jmp    80260c <ftruncate+0x52>
		return -E_NOT_SUPP;
  802632:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802637:	eb d3                	jmp    80260c <ftruncate+0x52>

00802639 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802639:	55                   	push   %ebp
  80263a:	89 e5                	mov    %esp,%ebp
  80263c:	53                   	push   %ebx
  80263d:	83 ec 1c             	sub    $0x1c,%esp
  802640:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802643:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802646:	50                   	push   %eax
  802647:	ff 75 08             	pushl  0x8(%ebp)
  80264a:	e8 84 fb ff ff       	call   8021d3 <fd_lookup>
  80264f:	83 c4 10             	add    $0x10,%esp
  802652:	85 c0                	test   %eax,%eax
  802654:	78 4b                	js     8026a1 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802656:	83 ec 08             	sub    $0x8,%esp
  802659:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80265c:	50                   	push   %eax
  80265d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802660:	ff 30                	pushl  (%eax)
  802662:	e8 bc fb ff ff       	call   802223 <dev_lookup>
  802667:	83 c4 10             	add    $0x10,%esp
  80266a:	85 c0                	test   %eax,%eax
  80266c:	78 33                	js     8026a1 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80266e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802671:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  802675:	74 2f                	je     8026a6 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  802677:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80267a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  802681:	00 00 00 
	stat->st_isdir = 0;
  802684:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80268b:	00 00 00 
	stat->st_dev = dev;
  80268e:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802694:	83 ec 08             	sub    $0x8,%esp
  802697:	53                   	push   %ebx
  802698:	ff 75 f0             	pushl  -0x10(%ebp)
  80269b:	ff 50 14             	call   *0x14(%eax)
  80269e:	83 c4 10             	add    $0x10,%esp
}
  8026a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026a4:	c9                   	leave  
  8026a5:	c3                   	ret    
		return -E_NOT_SUPP;
  8026a6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8026ab:	eb f4                	jmp    8026a1 <fstat+0x68>

008026ad <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8026ad:	55                   	push   %ebp
  8026ae:	89 e5                	mov    %esp,%ebp
  8026b0:	56                   	push   %esi
  8026b1:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8026b2:	83 ec 08             	sub    $0x8,%esp
  8026b5:	6a 00                	push   $0x0
  8026b7:	ff 75 08             	pushl  0x8(%ebp)
  8026ba:	e8 22 02 00 00       	call   8028e1 <open>
  8026bf:	89 c3                	mov    %eax,%ebx
  8026c1:	83 c4 10             	add    $0x10,%esp
  8026c4:	85 c0                	test   %eax,%eax
  8026c6:	78 1b                	js     8026e3 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8026c8:	83 ec 08             	sub    $0x8,%esp
  8026cb:	ff 75 0c             	pushl  0xc(%ebp)
  8026ce:	50                   	push   %eax
  8026cf:	e8 65 ff ff ff       	call   802639 <fstat>
  8026d4:	89 c6                	mov    %eax,%esi
	close(fd);
  8026d6:	89 1c 24             	mov    %ebx,(%esp)
  8026d9:	e8 27 fc ff ff       	call   802305 <close>
	return r;
  8026de:	83 c4 10             	add    $0x10,%esp
  8026e1:	89 f3                	mov    %esi,%ebx
}
  8026e3:	89 d8                	mov    %ebx,%eax
  8026e5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026e8:	5b                   	pop    %ebx
  8026e9:	5e                   	pop    %esi
  8026ea:	5d                   	pop    %ebp
  8026eb:	c3                   	ret    

008026ec <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8026ec:	55                   	push   %ebp
  8026ed:	89 e5                	mov    %esp,%ebp
  8026ef:	56                   	push   %esi
  8026f0:	53                   	push   %ebx
  8026f1:	89 c6                	mov    %eax,%esi
  8026f3:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8026f5:	83 3d 20 64 80 00 00 	cmpl   $0x0,0x806420
  8026fc:	74 27                	je     802725 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8026fe:	6a 07                	push   $0x7
  802700:	68 00 70 80 00       	push   $0x807000
  802705:	56                   	push   %esi
  802706:	ff 35 20 64 80 00    	pushl  0x806420
  80270c:	e8 a7 12 00 00       	call   8039b8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  802711:	83 c4 0c             	add    $0xc,%esp
  802714:	6a 00                	push   $0x0
  802716:	53                   	push   %ebx
  802717:	6a 00                	push   $0x0
  802719:	e8 31 12 00 00       	call   80394f <ipc_recv>
}
  80271e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802721:	5b                   	pop    %ebx
  802722:	5e                   	pop    %esi
  802723:	5d                   	pop    %ebp
  802724:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802725:	83 ec 0c             	sub    $0xc,%esp
  802728:	6a 01                	push   $0x1
  80272a:	e8 e1 12 00 00       	call   803a10 <ipc_find_env>
  80272f:	a3 20 64 80 00       	mov    %eax,0x806420
  802734:	83 c4 10             	add    $0x10,%esp
  802737:	eb c5                	jmp    8026fe <fsipc+0x12>

00802739 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802739:	55                   	push   %ebp
  80273a:	89 e5                	mov    %esp,%ebp
  80273c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80273f:	8b 45 08             	mov    0x8(%ebp),%eax
  802742:	8b 40 0c             	mov    0xc(%eax),%eax
  802745:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  80274a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80274d:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  802752:	ba 00 00 00 00       	mov    $0x0,%edx
  802757:	b8 02 00 00 00       	mov    $0x2,%eax
  80275c:	e8 8b ff ff ff       	call   8026ec <fsipc>
}
  802761:	c9                   	leave  
  802762:	c3                   	ret    

00802763 <devfile_flush>:
{
  802763:	55                   	push   %ebp
  802764:	89 e5                	mov    %esp,%ebp
  802766:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802769:	8b 45 08             	mov    0x8(%ebp),%eax
  80276c:	8b 40 0c             	mov    0xc(%eax),%eax
  80276f:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  802774:	ba 00 00 00 00       	mov    $0x0,%edx
  802779:	b8 06 00 00 00       	mov    $0x6,%eax
  80277e:	e8 69 ff ff ff       	call   8026ec <fsipc>
}
  802783:	c9                   	leave  
  802784:	c3                   	ret    

00802785 <devfile_stat>:
{
  802785:	55                   	push   %ebp
  802786:	89 e5                	mov    %esp,%ebp
  802788:	53                   	push   %ebx
  802789:	83 ec 04             	sub    $0x4,%esp
  80278c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80278f:	8b 45 08             	mov    0x8(%ebp),%eax
  802792:	8b 40 0c             	mov    0xc(%eax),%eax
  802795:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80279a:	ba 00 00 00 00       	mov    $0x0,%edx
  80279f:	b8 05 00 00 00       	mov    $0x5,%eax
  8027a4:	e8 43 ff ff ff       	call   8026ec <fsipc>
  8027a9:	85 c0                	test   %eax,%eax
  8027ab:	78 2c                	js     8027d9 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8027ad:	83 ec 08             	sub    $0x8,%esp
  8027b0:	68 00 70 80 00       	push   $0x807000
  8027b5:	53                   	push   %ebx
  8027b6:	e8 a4 ec ff ff       	call   80145f <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8027bb:	a1 80 70 80 00       	mov    0x807080,%eax
  8027c0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8027c6:	a1 84 70 80 00       	mov    0x807084,%eax
  8027cb:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8027d1:	83 c4 10             	add    $0x10,%esp
  8027d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027dc:	c9                   	leave  
  8027dd:	c3                   	ret    

008027de <devfile_write>:
{
  8027de:	55                   	push   %ebp
  8027df:	89 e5                	mov    %esp,%ebp
  8027e1:	53                   	push   %ebx
  8027e2:	83 ec 08             	sub    $0x8,%esp
  8027e5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8027e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ee:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.write.req_n = n;
  8027f3:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8027f9:	53                   	push   %ebx
  8027fa:	ff 75 0c             	pushl  0xc(%ebp)
  8027fd:	68 08 70 80 00       	push   $0x807008
  802802:	e8 48 ee ff ff       	call   80164f <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802807:	ba 00 00 00 00       	mov    $0x0,%edx
  80280c:	b8 04 00 00 00       	mov    $0x4,%eax
  802811:	e8 d6 fe ff ff       	call   8026ec <fsipc>
  802816:	83 c4 10             	add    $0x10,%esp
  802819:	85 c0                	test   %eax,%eax
  80281b:	78 0b                	js     802828 <devfile_write+0x4a>
	assert(r <= n);
  80281d:	39 d8                	cmp    %ebx,%eax
  80281f:	77 0c                	ja     80282d <devfile_write+0x4f>
	assert(r <= PGSIZE);
  802821:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802826:	7f 1e                	jg     802846 <devfile_write+0x68>
}
  802828:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80282b:	c9                   	leave  
  80282c:	c3                   	ret    
	assert(r <= n);
  80282d:	68 c4 44 80 00       	push   $0x8044c4
  802832:	68 2f 3e 80 00       	push   $0x803e2f
  802837:	68 98 00 00 00       	push   $0x98
  80283c:	68 cb 44 80 00       	push   $0x8044cb
  802841:	e8 d4 e2 ff ff       	call   800b1a <_panic>
	assert(r <= PGSIZE);
  802846:	68 d6 44 80 00       	push   $0x8044d6
  80284b:	68 2f 3e 80 00       	push   $0x803e2f
  802850:	68 99 00 00 00       	push   $0x99
  802855:	68 cb 44 80 00       	push   $0x8044cb
  80285a:	e8 bb e2 ff ff       	call   800b1a <_panic>

0080285f <devfile_read>:
{
  80285f:	55                   	push   %ebp
  802860:	89 e5                	mov    %esp,%ebp
  802862:	56                   	push   %esi
  802863:	53                   	push   %ebx
  802864:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802867:	8b 45 08             	mov    0x8(%ebp),%eax
  80286a:	8b 40 0c             	mov    0xc(%eax),%eax
  80286d:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  802872:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802878:	ba 00 00 00 00       	mov    $0x0,%edx
  80287d:	b8 03 00 00 00       	mov    $0x3,%eax
  802882:	e8 65 fe ff ff       	call   8026ec <fsipc>
  802887:	89 c3                	mov    %eax,%ebx
  802889:	85 c0                	test   %eax,%eax
  80288b:	78 1f                	js     8028ac <devfile_read+0x4d>
	assert(r <= n);
  80288d:	39 f0                	cmp    %esi,%eax
  80288f:	77 24                	ja     8028b5 <devfile_read+0x56>
	assert(r <= PGSIZE);
  802891:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802896:	7f 33                	jg     8028cb <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802898:	83 ec 04             	sub    $0x4,%esp
  80289b:	50                   	push   %eax
  80289c:	68 00 70 80 00       	push   $0x807000
  8028a1:	ff 75 0c             	pushl  0xc(%ebp)
  8028a4:	e8 44 ed ff ff       	call   8015ed <memmove>
	return r;
  8028a9:	83 c4 10             	add    $0x10,%esp
}
  8028ac:	89 d8                	mov    %ebx,%eax
  8028ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8028b1:	5b                   	pop    %ebx
  8028b2:	5e                   	pop    %esi
  8028b3:	5d                   	pop    %ebp
  8028b4:	c3                   	ret    
	assert(r <= n);
  8028b5:	68 c4 44 80 00       	push   $0x8044c4
  8028ba:	68 2f 3e 80 00       	push   $0x803e2f
  8028bf:	6a 7c                	push   $0x7c
  8028c1:	68 cb 44 80 00       	push   $0x8044cb
  8028c6:	e8 4f e2 ff ff       	call   800b1a <_panic>
	assert(r <= PGSIZE);
  8028cb:	68 d6 44 80 00       	push   $0x8044d6
  8028d0:	68 2f 3e 80 00       	push   $0x803e2f
  8028d5:	6a 7d                	push   $0x7d
  8028d7:	68 cb 44 80 00       	push   $0x8044cb
  8028dc:	e8 39 e2 ff ff       	call   800b1a <_panic>

008028e1 <open>:
{
  8028e1:	55                   	push   %ebp
  8028e2:	89 e5                	mov    %esp,%ebp
  8028e4:	56                   	push   %esi
  8028e5:	53                   	push   %ebx
  8028e6:	83 ec 1c             	sub    $0x1c,%esp
  8028e9:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8028ec:	56                   	push   %esi
  8028ed:	e8 34 eb ff ff       	call   801426 <strlen>
  8028f2:	83 c4 10             	add    $0x10,%esp
  8028f5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8028fa:	7f 6c                	jg     802968 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8028fc:	83 ec 0c             	sub    $0xc,%esp
  8028ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802902:	50                   	push   %eax
  802903:	e8 79 f8 ff ff       	call   802181 <fd_alloc>
  802908:	89 c3                	mov    %eax,%ebx
  80290a:	83 c4 10             	add    $0x10,%esp
  80290d:	85 c0                	test   %eax,%eax
  80290f:	78 3c                	js     80294d <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  802911:	83 ec 08             	sub    $0x8,%esp
  802914:	56                   	push   %esi
  802915:	68 00 70 80 00       	push   $0x807000
  80291a:	e8 40 eb ff ff       	call   80145f <strcpy>
	fsipcbuf.open.req_omode = mode;
  80291f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802922:	a3 00 74 80 00       	mov    %eax,0x807400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802927:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80292a:	b8 01 00 00 00       	mov    $0x1,%eax
  80292f:	e8 b8 fd ff ff       	call   8026ec <fsipc>
  802934:	89 c3                	mov    %eax,%ebx
  802936:	83 c4 10             	add    $0x10,%esp
  802939:	85 c0                	test   %eax,%eax
  80293b:	78 19                	js     802956 <open+0x75>
	return fd2num(fd);
  80293d:	83 ec 0c             	sub    $0xc,%esp
  802940:	ff 75 f4             	pushl  -0xc(%ebp)
  802943:	e8 12 f8 ff ff       	call   80215a <fd2num>
  802948:	89 c3                	mov    %eax,%ebx
  80294a:	83 c4 10             	add    $0x10,%esp
}
  80294d:	89 d8                	mov    %ebx,%eax
  80294f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802952:	5b                   	pop    %ebx
  802953:	5e                   	pop    %esi
  802954:	5d                   	pop    %ebp
  802955:	c3                   	ret    
		fd_close(fd, 0);
  802956:	83 ec 08             	sub    $0x8,%esp
  802959:	6a 00                	push   $0x0
  80295b:	ff 75 f4             	pushl  -0xc(%ebp)
  80295e:	e8 1b f9 ff ff       	call   80227e <fd_close>
		return r;
  802963:	83 c4 10             	add    $0x10,%esp
  802966:	eb e5                	jmp    80294d <open+0x6c>
		return -E_BAD_PATH;
  802968:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80296d:	eb de                	jmp    80294d <open+0x6c>

0080296f <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80296f:	55                   	push   %ebp
  802970:	89 e5                	mov    %esp,%ebp
  802972:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802975:	ba 00 00 00 00       	mov    $0x0,%edx
  80297a:	b8 08 00 00 00       	mov    $0x8,%eax
  80297f:	e8 68 fd ff ff       	call   8026ec <fsipc>
}
  802984:	c9                   	leave  
  802985:	c3                   	ret    

00802986 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  802986:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  80298a:	7f 01                	jg     80298d <writebuf+0x7>
  80298c:	c3                   	ret    
{
  80298d:	55                   	push   %ebp
  80298e:	89 e5                	mov    %esp,%ebp
  802990:	53                   	push   %ebx
  802991:	83 ec 08             	sub    $0x8,%esp
  802994:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  802996:	ff 70 04             	pushl  0x4(%eax)
  802999:	8d 40 10             	lea    0x10(%eax),%eax
  80299c:	50                   	push   %eax
  80299d:	ff 33                	pushl  (%ebx)
  80299f:	e8 6b fb ff ff       	call   80250f <write>
		if (result > 0)
  8029a4:	83 c4 10             	add    $0x10,%esp
  8029a7:	85 c0                	test   %eax,%eax
  8029a9:	7e 03                	jle    8029ae <writebuf+0x28>
			b->result += result;
  8029ab:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8029ae:	39 43 04             	cmp    %eax,0x4(%ebx)
  8029b1:	74 0d                	je     8029c0 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  8029b3:	85 c0                	test   %eax,%eax
  8029b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8029ba:	0f 4f c2             	cmovg  %edx,%eax
  8029bd:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8029c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8029c3:	c9                   	leave  
  8029c4:	c3                   	ret    

008029c5 <putch>:

static void
putch(int ch, void *thunk)
{
  8029c5:	55                   	push   %ebp
  8029c6:	89 e5                	mov    %esp,%ebp
  8029c8:	53                   	push   %ebx
  8029c9:	83 ec 04             	sub    $0x4,%esp
  8029cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8029cf:	8b 53 04             	mov    0x4(%ebx),%edx
  8029d2:	8d 42 01             	lea    0x1(%edx),%eax
  8029d5:	89 43 04             	mov    %eax,0x4(%ebx)
  8029d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8029db:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8029df:	3d 00 01 00 00       	cmp    $0x100,%eax
  8029e4:	74 06                	je     8029ec <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  8029e6:	83 c4 04             	add    $0x4,%esp
  8029e9:	5b                   	pop    %ebx
  8029ea:	5d                   	pop    %ebp
  8029eb:	c3                   	ret    
		writebuf(b);
  8029ec:	89 d8                	mov    %ebx,%eax
  8029ee:	e8 93 ff ff ff       	call   802986 <writebuf>
		b->idx = 0;
  8029f3:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8029fa:	eb ea                	jmp    8029e6 <putch+0x21>

008029fc <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8029fc:	55                   	push   %ebp
  8029fd:	89 e5                	mov    %esp,%ebp
  8029ff:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  802a05:	8b 45 08             	mov    0x8(%ebp),%eax
  802a08:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  802a0e:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  802a15:	00 00 00 
	b.result = 0;
  802a18:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  802a1f:	00 00 00 
	b.error = 1;
  802a22:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  802a29:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802a2c:	ff 75 10             	pushl  0x10(%ebp)
  802a2f:	ff 75 0c             	pushl  0xc(%ebp)
  802a32:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  802a38:	50                   	push   %eax
  802a39:	68 c5 29 80 00       	push   $0x8029c5
  802a3e:	e8 fa e2 ff ff       	call   800d3d <vprintfmt>
	if (b.idx > 0)
  802a43:	83 c4 10             	add    $0x10,%esp
  802a46:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  802a4d:	7f 11                	jg     802a60 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  802a4f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  802a55:	85 c0                	test   %eax,%eax
  802a57:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  802a5e:	c9                   	leave  
  802a5f:	c3                   	ret    
		writebuf(&b);
  802a60:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  802a66:	e8 1b ff ff ff       	call   802986 <writebuf>
  802a6b:	eb e2                	jmp    802a4f <vfprintf+0x53>

00802a6d <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802a6d:	55                   	push   %ebp
  802a6e:	89 e5                	mov    %esp,%ebp
  802a70:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802a73:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  802a76:	50                   	push   %eax
  802a77:	ff 75 0c             	pushl  0xc(%ebp)
  802a7a:	ff 75 08             	pushl  0x8(%ebp)
  802a7d:	e8 7a ff ff ff       	call   8029fc <vfprintf>
	va_end(ap);

	return cnt;
}
  802a82:	c9                   	leave  
  802a83:	c3                   	ret    

00802a84 <printf>:

int
printf(const char *fmt, ...)
{
  802a84:	55                   	push   %ebp
  802a85:	89 e5                	mov    %esp,%ebp
  802a87:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802a8a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  802a8d:	50                   	push   %eax
  802a8e:	ff 75 08             	pushl  0x8(%ebp)
  802a91:	6a 01                	push   $0x1
  802a93:	e8 64 ff ff ff       	call   8029fc <vfprintf>
	va_end(ap);

	return cnt;
}
  802a98:	c9                   	leave  
  802a99:	c3                   	ret    

00802a9a <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802a9a:	55                   	push   %ebp
  802a9b:	89 e5                	mov    %esp,%ebp
  802a9d:	57                   	push   %edi
  802a9e:	56                   	push   %esi
  802a9f:	53                   	push   %ebx
  802aa0:	81 ec 94 02 00 00    	sub    $0x294,%esp
	cprintf("in %s\n", __FUNCTION__);
  802aa6:	68 b8 45 80 00       	push   $0x8045b8
  802aab:	68 51 3f 80 00       	push   $0x803f51
  802ab0:	e8 5b e1 ff ff       	call   800c10 <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802ab5:	83 c4 08             	add    $0x8,%esp
  802ab8:	6a 00                	push   $0x0
  802aba:	ff 75 08             	pushl  0x8(%ebp)
  802abd:	e8 1f fe ff ff       	call   8028e1 <open>
  802ac2:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802ac8:	83 c4 10             	add    $0x10,%esp
  802acb:	85 c0                	test   %eax,%eax
  802acd:	0f 88 0a 05 00 00    	js     802fdd <spawn+0x543>
  802ad3:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802ad5:	83 ec 04             	sub    $0x4,%esp
  802ad8:	68 00 02 00 00       	push   $0x200
  802add:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  802ae3:	50                   	push   %eax
  802ae4:	51                   	push   %ecx
  802ae5:	e8 e0 f9 ff ff       	call   8024ca <readn>
  802aea:	83 c4 10             	add    $0x10,%esp
  802aed:	3d 00 02 00 00       	cmp    $0x200,%eax
  802af2:	75 74                	jne    802b68 <spawn+0xce>
	    || elf->e_magic != ELF_MAGIC) {
  802af4:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  802afb:	45 4c 46 
  802afe:	75 68                	jne    802b68 <spawn+0xce>
  802b00:	b8 07 00 00 00       	mov    $0x7,%eax
  802b05:	cd 30                	int    $0x30
  802b07:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  802b0d:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802b13:	85 c0                	test   %eax,%eax
  802b15:	0f 88 b6 04 00 00    	js     802fd1 <spawn+0x537>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802b1b:	25 ff 03 00 00       	and    $0x3ff,%eax
  802b20:	89 c6                	mov    %eax,%esi
  802b22:	c1 e6 07             	shl    $0x7,%esi
  802b25:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  802b2b:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  802b31:	b9 11 00 00 00       	mov    $0x11,%ecx
  802b36:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  802b38:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802b3e:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
	cprintf("in %s\n", __FUNCTION__);
  802b44:	83 ec 08             	sub    $0x8,%esp
  802b47:	68 ac 45 80 00       	push   $0x8045ac
  802b4c:	68 51 3f 80 00       	push   $0x803f51
  802b51:	e8 ba e0 ff ff       	call   800c10 <cprintf>
  802b56:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802b59:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  802b5e:	be 00 00 00 00       	mov    $0x0,%esi
  802b63:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802b66:	eb 4b                	jmp    802bb3 <spawn+0x119>
		close(fd);
  802b68:	83 ec 0c             	sub    $0xc,%esp
  802b6b:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802b71:	e8 8f f7 ff ff       	call   802305 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802b76:	83 c4 0c             	add    $0xc,%esp
  802b79:	68 7f 45 4c 46       	push   $0x464c457f
  802b7e:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  802b84:	68 e2 44 80 00       	push   $0x8044e2
  802b89:	e8 82 e0 ff ff       	call   800c10 <cprintf>
		return -E_NOT_EXEC;
  802b8e:	83 c4 10             	add    $0x10,%esp
  802b91:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  802b98:	ff ff ff 
  802b9b:	e9 3d 04 00 00       	jmp    802fdd <spawn+0x543>
		string_size += strlen(argv[argc]) + 1;
  802ba0:	83 ec 0c             	sub    $0xc,%esp
  802ba3:	50                   	push   %eax
  802ba4:	e8 7d e8 ff ff       	call   801426 <strlen>
  802ba9:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  802bad:	83 c3 01             	add    $0x1,%ebx
  802bb0:	83 c4 10             	add    $0x10,%esp
  802bb3:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  802bba:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  802bbd:	85 c0                	test   %eax,%eax
  802bbf:	75 df                	jne    802ba0 <spawn+0x106>
  802bc1:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  802bc7:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  802bcd:	bf 00 10 40 00       	mov    $0x401000,%edi
  802bd2:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802bd4:	89 fa                	mov    %edi,%edx
  802bd6:	83 e2 fc             	and    $0xfffffffc,%edx
  802bd9:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  802be0:	29 c2                	sub    %eax,%edx
  802be2:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802be8:	8d 42 f8             	lea    -0x8(%edx),%eax
  802beb:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802bf0:	0f 86 0a 04 00 00    	jbe    803000 <spawn+0x566>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802bf6:	83 ec 04             	sub    $0x4,%esp
  802bf9:	6a 07                	push   $0x7
  802bfb:	68 00 00 40 00       	push   $0x400000
  802c00:	6a 00                	push   $0x0
  802c02:	e8 4a ec ff ff       	call   801851 <sys_page_alloc>
  802c07:	83 c4 10             	add    $0x10,%esp
  802c0a:	85 c0                	test   %eax,%eax
  802c0c:	0f 88 f3 03 00 00    	js     803005 <spawn+0x56b>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802c12:	be 00 00 00 00       	mov    $0x0,%esi
  802c17:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  802c1d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802c20:	eb 30                	jmp    802c52 <spawn+0x1b8>
		argv_store[i] = UTEMP2USTACK(string_store);
  802c22:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802c28:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  802c2e:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  802c31:	83 ec 08             	sub    $0x8,%esp
  802c34:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802c37:	57                   	push   %edi
  802c38:	e8 22 e8 ff ff       	call   80145f <strcpy>
		string_store += strlen(argv[i]) + 1;
  802c3d:	83 c4 04             	add    $0x4,%esp
  802c40:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802c43:	e8 de e7 ff ff       	call   801426 <strlen>
  802c48:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  802c4c:	83 c6 01             	add    $0x1,%esi
  802c4f:	83 c4 10             	add    $0x10,%esp
  802c52:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  802c58:	7f c8                	jg     802c22 <spawn+0x188>
	}
	argv_store[argc] = 0;
  802c5a:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802c60:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  802c66:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  802c6d:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  802c73:	0f 85 86 00 00 00    	jne    802cff <spawn+0x265>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802c79:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  802c7f:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  802c85:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  802c88:	89 d0                	mov    %edx,%eax
  802c8a:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  802c90:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802c93:	2d 08 30 80 11       	sub    $0x11803008,%eax
  802c98:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802c9e:	83 ec 0c             	sub    $0xc,%esp
  802ca1:	6a 07                	push   $0x7
  802ca3:	68 00 d0 bf ee       	push   $0xeebfd000
  802ca8:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802cae:	68 00 00 40 00       	push   $0x400000
  802cb3:	6a 00                	push   $0x0
  802cb5:	e8 da eb ff ff       	call   801894 <sys_page_map>
  802cba:	89 c3                	mov    %eax,%ebx
  802cbc:	83 c4 20             	add    $0x20,%esp
  802cbf:	85 c0                	test   %eax,%eax
  802cc1:	0f 88 46 03 00 00    	js     80300d <spawn+0x573>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802cc7:	83 ec 08             	sub    $0x8,%esp
  802cca:	68 00 00 40 00       	push   $0x400000
  802ccf:	6a 00                	push   $0x0
  802cd1:	e8 00 ec ff ff       	call   8018d6 <sys_page_unmap>
  802cd6:	89 c3                	mov    %eax,%ebx
  802cd8:	83 c4 10             	add    $0x10,%esp
  802cdb:	85 c0                	test   %eax,%eax
  802cdd:	0f 88 2a 03 00 00    	js     80300d <spawn+0x573>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802ce3:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  802ce9:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802cf0:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  802cf7:	00 00 00 
  802cfa:	e9 4f 01 00 00       	jmp    802e4e <spawn+0x3b4>
	assert(string_store == (char*)UTEMP + PGSIZE);
  802cff:	68 68 45 80 00       	push   $0x804568
  802d04:	68 2f 3e 80 00       	push   $0x803e2f
  802d09:	68 f8 00 00 00       	push   $0xf8
  802d0e:	68 fc 44 80 00       	push   $0x8044fc
  802d13:	e8 02 de ff ff       	call   800b1a <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802d18:	83 ec 04             	sub    $0x4,%esp
  802d1b:	6a 07                	push   $0x7
  802d1d:	68 00 00 40 00       	push   $0x400000
  802d22:	6a 00                	push   $0x0
  802d24:	e8 28 eb ff ff       	call   801851 <sys_page_alloc>
  802d29:	83 c4 10             	add    $0x10,%esp
  802d2c:	85 c0                	test   %eax,%eax
  802d2e:	0f 88 b7 02 00 00    	js     802feb <spawn+0x551>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802d34:	83 ec 08             	sub    $0x8,%esp
  802d37:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802d3d:	01 f0                	add    %esi,%eax
  802d3f:	50                   	push   %eax
  802d40:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802d46:	e8 46 f8 ff ff       	call   802591 <seek>
  802d4b:	83 c4 10             	add    $0x10,%esp
  802d4e:	85 c0                	test   %eax,%eax
  802d50:	0f 88 9c 02 00 00    	js     802ff2 <spawn+0x558>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802d56:	83 ec 04             	sub    $0x4,%esp
  802d59:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802d5f:	29 f0                	sub    %esi,%eax
  802d61:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802d66:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802d6b:	0f 47 c1             	cmova  %ecx,%eax
  802d6e:	50                   	push   %eax
  802d6f:	68 00 00 40 00       	push   $0x400000
  802d74:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802d7a:	e8 4b f7 ff ff       	call   8024ca <readn>
  802d7f:	83 c4 10             	add    $0x10,%esp
  802d82:	85 c0                	test   %eax,%eax
  802d84:	0f 88 6f 02 00 00    	js     802ff9 <spawn+0x55f>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802d8a:	83 ec 0c             	sub    $0xc,%esp
  802d8d:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802d93:	53                   	push   %ebx
  802d94:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802d9a:	68 00 00 40 00       	push   $0x400000
  802d9f:	6a 00                	push   $0x0
  802da1:	e8 ee ea ff ff       	call   801894 <sys_page_map>
  802da6:	83 c4 20             	add    $0x20,%esp
  802da9:	85 c0                	test   %eax,%eax
  802dab:	78 7c                	js     802e29 <spawn+0x38f>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  802dad:	83 ec 08             	sub    $0x8,%esp
  802db0:	68 00 00 40 00       	push   $0x400000
  802db5:	6a 00                	push   $0x0
  802db7:	e8 1a eb ff ff       	call   8018d6 <sys_page_unmap>
  802dbc:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  802dbf:	81 c7 00 10 00 00    	add    $0x1000,%edi
  802dc5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802dcb:	89 fe                	mov    %edi,%esi
  802dcd:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  802dd3:	76 69                	jbe    802e3e <spawn+0x3a4>
		if (i >= filesz) {
  802dd5:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  802ddb:	0f 87 37 ff ff ff    	ja     802d18 <spawn+0x27e>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802de1:	83 ec 04             	sub    $0x4,%esp
  802de4:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802dea:	53                   	push   %ebx
  802deb:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802df1:	e8 5b ea ff ff       	call   801851 <sys_page_alloc>
  802df6:	83 c4 10             	add    $0x10,%esp
  802df9:	85 c0                	test   %eax,%eax
  802dfb:	79 c2                	jns    802dbf <spawn+0x325>
  802dfd:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  802dff:	83 ec 0c             	sub    $0xc,%esp
  802e02:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802e08:	e8 c5 e9 ff ff       	call   8017d2 <sys_env_destroy>
	close(fd);
  802e0d:	83 c4 04             	add    $0x4,%esp
  802e10:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802e16:	e8 ea f4 ff ff       	call   802305 <close>
	return r;
  802e1b:	83 c4 10             	add    $0x10,%esp
  802e1e:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  802e24:	e9 b4 01 00 00       	jmp    802fdd <spawn+0x543>
				panic("spawn: sys_page_map data: %e", r);
  802e29:	50                   	push   %eax
  802e2a:	68 08 45 80 00       	push   $0x804508
  802e2f:	68 2b 01 00 00       	push   $0x12b
  802e34:	68 fc 44 80 00       	push   $0x8044fc
  802e39:	e8 dc dc ff ff       	call   800b1a <_panic>
  802e3e:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802e44:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  802e4b:	83 c6 20             	add    $0x20,%esi
  802e4e:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802e55:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  802e5b:	7e 6d                	jle    802eca <spawn+0x430>
		if (ph->p_type != ELF_PROG_LOAD)
  802e5d:	83 3e 01             	cmpl   $0x1,(%esi)
  802e60:	75 e2                	jne    802e44 <spawn+0x3aa>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802e62:	8b 46 18             	mov    0x18(%esi),%eax
  802e65:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  802e68:	83 f8 01             	cmp    $0x1,%eax
  802e6b:	19 c0                	sbb    %eax,%eax
  802e6d:	83 e0 fe             	and    $0xfffffffe,%eax
  802e70:	83 c0 07             	add    $0x7,%eax
  802e73:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802e79:	8b 4e 04             	mov    0x4(%esi),%ecx
  802e7c:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  802e82:	8b 56 10             	mov    0x10(%esi),%edx
  802e85:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  802e8b:	8b 7e 14             	mov    0x14(%esi),%edi
  802e8e:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  802e94:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  802e97:	89 d8                	mov    %ebx,%eax
  802e99:	25 ff 0f 00 00       	and    $0xfff,%eax
  802e9e:	74 1a                	je     802eba <spawn+0x420>
		va -= i;
  802ea0:	29 c3                	sub    %eax,%ebx
		memsz += i;
  802ea2:	01 c7                	add    %eax,%edi
  802ea4:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  802eaa:	01 c2                	add    %eax,%edx
  802eac:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  802eb2:	29 c1                	sub    %eax,%ecx
  802eb4:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  802eba:	bf 00 00 00 00       	mov    $0x0,%edi
  802ebf:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  802ec5:	e9 01 ff ff ff       	jmp    802dcb <spawn+0x331>
	close(fd);
  802eca:	83 ec 0c             	sub    $0xc,%esp
  802ecd:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802ed3:	e8 2d f4 ff ff       	call   802305 <close>

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	cprintf("in %s\n", __FUNCTION__);
  802ed8:	83 c4 08             	add    $0x8,%esp
  802edb:	68 98 45 80 00       	push   $0x804598
  802ee0:	68 51 3f 80 00       	push   $0x803f51
  802ee5:	e8 26 dd ff ff       	call   800c10 <cprintf>
  802eea:	83 c4 10             	add    $0x10,%esp
	int r;
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  802eed:	bb 00 00 80 00       	mov    $0x800000,%ebx
  802ef2:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  802ef8:	eb 0e                	jmp    802f08 <spawn+0x46e>
  802efa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802f00:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  802f06:	74 5e                	je     802f66 <spawn+0x4cc>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_SHARE)) == (PTE_P | PTE_U | PTE_SHARE)))
  802f08:	89 d8                	mov    %ebx,%eax
  802f0a:	c1 e8 16             	shr    $0x16,%eax
  802f0d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802f14:	a8 01                	test   $0x1,%al
  802f16:	74 e2                	je     802efa <spawn+0x460>
  802f18:	89 da                	mov    %ebx,%edx
  802f1a:	c1 ea 0c             	shr    $0xc,%edx
  802f1d:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  802f24:	25 05 04 00 00       	and    $0x405,%eax
  802f29:	3d 05 04 00 00       	cmp    $0x405,%eax
  802f2e:	75 ca                	jne    802efa <spawn+0x460>
			if((r = sys_page_map((envid_t)0, (void *)i, child, (void *)i, uvpt[PGNUM(i)] & PTE_SYSCALL)) < 0)
  802f30:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  802f37:	83 ec 0c             	sub    $0xc,%esp
  802f3a:	25 07 0e 00 00       	and    $0xe07,%eax
  802f3f:	50                   	push   %eax
  802f40:	53                   	push   %ebx
  802f41:	56                   	push   %esi
  802f42:	53                   	push   %ebx
  802f43:	6a 00                	push   $0x0
  802f45:	e8 4a e9 ff ff       	call   801894 <sys_page_map>
  802f4a:	83 c4 20             	add    $0x20,%esp
  802f4d:	85 c0                	test   %eax,%eax
  802f4f:	79 a9                	jns    802efa <spawn+0x460>
        		panic("sys_page_map: %e\n", r);
  802f51:	50                   	push   %eax
  802f52:	68 25 45 80 00       	push   $0x804525
  802f57:	68 3b 01 00 00       	push   $0x13b
  802f5c:	68 fc 44 80 00       	push   $0x8044fc
  802f61:	e8 b4 db ff ff       	call   800b1a <_panic>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802f66:	83 ec 08             	sub    $0x8,%esp
  802f69:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802f6f:	50                   	push   %eax
  802f70:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802f76:	e8 df e9 ff ff       	call   80195a <sys_env_set_trapframe>
  802f7b:	83 c4 10             	add    $0x10,%esp
  802f7e:	85 c0                	test   %eax,%eax
  802f80:	78 25                	js     802fa7 <spawn+0x50d>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802f82:	83 ec 08             	sub    $0x8,%esp
  802f85:	6a 02                	push   $0x2
  802f87:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802f8d:	e8 86 e9 ff ff       	call   801918 <sys_env_set_status>
  802f92:	83 c4 10             	add    $0x10,%esp
  802f95:	85 c0                	test   %eax,%eax
  802f97:	78 23                	js     802fbc <spawn+0x522>
	return child;
  802f99:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802f9f:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802fa5:	eb 36                	jmp    802fdd <spawn+0x543>
		panic("sys_env_set_trapframe: %e", r);
  802fa7:	50                   	push   %eax
  802fa8:	68 37 45 80 00       	push   $0x804537
  802fad:	68 8a 00 00 00       	push   $0x8a
  802fb2:	68 fc 44 80 00       	push   $0x8044fc
  802fb7:	e8 5e db ff ff       	call   800b1a <_panic>
		panic("sys_env_set_status: %e", r);
  802fbc:	50                   	push   %eax
  802fbd:	68 51 45 80 00       	push   $0x804551
  802fc2:	68 8d 00 00 00       	push   $0x8d
  802fc7:	68 fc 44 80 00       	push   $0x8044fc
  802fcc:	e8 49 db ff ff       	call   800b1a <_panic>
		return r;
  802fd1:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802fd7:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  802fdd:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802fe3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802fe6:	5b                   	pop    %ebx
  802fe7:	5e                   	pop    %esi
  802fe8:	5f                   	pop    %edi
  802fe9:	5d                   	pop    %ebp
  802fea:	c3                   	ret    
  802feb:	89 c7                	mov    %eax,%edi
  802fed:	e9 0d fe ff ff       	jmp    802dff <spawn+0x365>
  802ff2:	89 c7                	mov    %eax,%edi
  802ff4:	e9 06 fe ff ff       	jmp    802dff <spawn+0x365>
  802ff9:	89 c7                	mov    %eax,%edi
  802ffb:	e9 ff fd ff ff       	jmp    802dff <spawn+0x365>
		return -E_NO_MEM;
  803000:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  803005:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  80300b:	eb d0                	jmp    802fdd <spawn+0x543>
	sys_page_unmap(0, UTEMP);
  80300d:	83 ec 08             	sub    $0x8,%esp
  803010:	68 00 00 40 00       	push   $0x400000
  803015:	6a 00                	push   $0x0
  803017:	e8 ba e8 ff ff       	call   8018d6 <sys_page_unmap>
  80301c:	83 c4 10             	add    $0x10,%esp
  80301f:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  803025:	eb b6                	jmp    802fdd <spawn+0x543>

00803027 <spawnl>:
{
  803027:	55                   	push   %ebp
  803028:	89 e5                	mov    %esp,%ebp
  80302a:	57                   	push   %edi
  80302b:	56                   	push   %esi
  80302c:	53                   	push   %ebx
  80302d:	83 ec 14             	sub    $0x14,%esp
	cprintf("in %s\n", __FUNCTION__);
  803030:	68 90 45 80 00       	push   $0x804590
  803035:	68 51 3f 80 00       	push   $0x803f51
  80303a:	e8 d1 db ff ff       	call   800c10 <cprintf>
	va_start(vl, arg0);
  80303f:	8d 55 10             	lea    0x10(%ebp),%edx
	while(va_arg(vl, void *) != NULL)
  803042:	83 c4 10             	add    $0x10,%esp
	int argc=0;
  803045:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  80304a:	8d 4a 04             	lea    0x4(%edx),%ecx
  80304d:	83 3a 00             	cmpl   $0x0,(%edx)
  803050:	74 07                	je     803059 <spawnl+0x32>
		argc++;
  803052:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  803055:	89 ca                	mov    %ecx,%edx
  803057:	eb f1                	jmp    80304a <spawnl+0x23>
	const char *argv[argc+2];
  803059:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  803060:	83 e2 f0             	and    $0xfffffff0,%edx
  803063:	29 d4                	sub    %edx,%esp
  803065:	8d 54 24 03          	lea    0x3(%esp),%edx
  803069:	c1 ea 02             	shr    $0x2,%edx
  80306c:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  803073:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  803075:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803078:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  80307f:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  803086:	00 
	va_start(vl, arg0);
  803087:	8d 4d 10             	lea    0x10(%ebp),%ecx
  80308a:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  80308c:	b8 00 00 00 00       	mov    $0x0,%eax
  803091:	eb 0b                	jmp    80309e <spawnl+0x77>
		argv[i+1] = va_arg(vl, const char *);
  803093:	83 c0 01             	add    $0x1,%eax
  803096:	8b 39                	mov    (%ecx),%edi
  803098:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  80309b:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  80309e:	39 d0                	cmp    %edx,%eax
  8030a0:	75 f1                	jne    803093 <spawnl+0x6c>
	return spawn(prog, argv);
  8030a2:	83 ec 08             	sub    $0x8,%esp
  8030a5:	56                   	push   %esi
  8030a6:	ff 75 08             	pushl  0x8(%ebp)
  8030a9:	e8 ec f9 ff ff       	call   802a9a <spawn>
}
  8030ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8030b1:	5b                   	pop    %ebx
  8030b2:	5e                   	pop    %esi
  8030b3:	5f                   	pop    %edi
  8030b4:	5d                   	pop    %ebp
  8030b5:	c3                   	ret    

008030b6 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8030b6:	55                   	push   %ebp
  8030b7:	89 e5                	mov    %esp,%ebp
  8030b9:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8030bc:	68 be 45 80 00       	push   $0x8045be
  8030c1:	ff 75 0c             	pushl  0xc(%ebp)
  8030c4:	e8 96 e3 ff ff       	call   80145f <strcpy>
	return 0;
}
  8030c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8030ce:	c9                   	leave  
  8030cf:	c3                   	ret    

008030d0 <devsock_close>:
{
  8030d0:	55                   	push   %ebp
  8030d1:	89 e5                	mov    %esp,%ebp
  8030d3:	53                   	push   %ebx
  8030d4:	83 ec 10             	sub    $0x10,%esp
  8030d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8030da:	53                   	push   %ebx
  8030db:	e8 6b 09 00 00       	call   803a4b <pageref>
  8030e0:	83 c4 10             	add    $0x10,%esp
		return 0;
  8030e3:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8030e8:	83 f8 01             	cmp    $0x1,%eax
  8030eb:	74 07                	je     8030f4 <devsock_close+0x24>
}
  8030ed:	89 d0                	mov    %edx,%eax
  8030ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8030f2:	c9                   	leave  
  8030f3:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8030f4:	83 ec 0c             	sub    $0xc,%esp
  8030f7:	ff 73 0c             	pushl  0xc(%ebx)
  8030fa:	e8 b9 02 00 00       	call   8033b8 <nsipc_close>
  8030ff:	89 c2                	mov    %eax,%edx
  803101:	83 c4 10             	add    $0x10,%esp
  803104:	eb e7                	jmp    8030ed <devsock_close+0x1d>

00803106 <devsock_write>:
{
  803106:	55                   	push   %ebp
  803107:	89 e5                	mov    %esp,%ebp
  803109:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80310c:	6a 00                	push   $0x0
  80310e:	ff 75 10             	pushl  0x10(%ebp)
  803111:	ff 75 0c             	pushl  0xc(%ebp)
  803114:	8b 45 08             	mov    0x8(%ebp),%eax
  803117:	ff 70 0c             	pushl  0xc(%eax)
  80311a:	e8 76 03 00 00       	call   803495 <nsipc_send>
}
  80311f:	c9                   	leave  
  803120:	c3                   	ret    

00803121 <devsock_read>:
{
  803121:	55                   	push   %ebp
  803122:	89 e5                	mov    %esp,%ebp
  803124:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803127:	6a 00                	push   $0x0
  803129:	ff 75 10             	pushl  0x10(%ebp)
  80312c:	ff 75 0c             	pushl  0xc(%ebp)
  80312f:	8b 45 08             	mov    0x8(%ebp),%eax
  803132:	ff 70 0c             	pushl  0xc(%eax)
  803135:	e8 ef 02 00 00       	call   803429 <nsipc_recv>
}
  80313a:	c9                   	leave  
  80313b:	c3                   	ret    

0080313c <fd2sockid>:
{
  80313c:	55                   	push   %ebp
  80313d:	89 e5                	mov    %esp,%ebp
  80313f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  803142:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803145:	52                   	push   %edx
  803146:	50                   	push   %eax
  803147:	e8 87 f0 ff ff       	call   8021d3 <fd_lookup>
  80314c:	83 c4 10             	add    $0x10,%esp
  80314f:	85 c0                	test   %eax,%eax
  803151:	78 10                	js     803163 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  803153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803156:	8b 0d 3c 50 80 00    	mov    0x80503c,%ecx
  80315c:	39 08                	cmp    %ecx,(%eax)
  80315e:	75 05                	jne    803165 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  803160:	8b 40 0c             	mov    0xc(%eax),%eax
}
  803163:	c9                   	leave  
  803164:	c3                   	ret    
		return -E_NOT_SUPP;
  803165:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80316a:	eb f7                	jmp    803163 <fd2sockid+0x27>

0080316c <alloc_sockfd>:
{
  80316c:	55                   	push   %ebp
  80316d:	89 e5                	mov    %esp,%ebp
  80316f:	56                   	push   %esi
  803170:	53                   	push   %ebx
  803171:	83 ec 1c             	sub    $0x1c,%esp
  803174:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  803176:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803179:	50                   	push   %eax
  80317a:	e8 02 f0 ff ff       	call   802181 <fd_alloc>
  80317f:	89 c3                	mov    %eax,%ebx
  803181:	83 c4 10             	add    $0x10,%esp
  803184:	85 c0                	test   %eax,%eax
  803186:	78 43                	js     8031cb <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803188:	83 ec 04             	sub    $0x4,%esp
  80318b:	68 07 04 00 00       	push   $0x407
  803190:	ff 75 f4             	pushl  -0xc(%ebp)
  803193:	6a 00                	push   $0x0
  803195:	e8 b7 e6 ff ff       	call   801851 <sys_page_alloc>
  80319a:	89 c3                	mov    %eax,%ebx
  80319c:	83 c4 10             	add    $0x10,%esp
  80319f:	85 c0                	test   %eax,%eax
  8031a1:	78 28                	js     8031cb <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8031a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a6:	8b 15 3c 50 80 00    	mov    0x80503c,%edx
  8031ac:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8031ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8031b8:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8031bb:	83 ec 0c             	sub    $0xc,%esp
  8031be:	50                   	push   %eax
  8031bf:	e8 96 ef ff ff       	call   80215a <fd2num>
  8031c4:	89 c3                	mov    %eax,%ebx
  8031c6:	83 c4 10             	add    $0x10,%esp
  8031c9:	eb 0c                	jmp    8031d7 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8031cb:	83 ec 0c             	sub    $0xc,%esp
  8031ce:	56                   	push   %esi
  8031cf:	e8 e4 01 00 00       	call   8033b8 <nsipc_close>
		return r;
  8031d4:	83 c4 10             	add    $0x10,%esp
}
  8031d7:	89 d8                	mov    %ebx,%eax
  8031d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8031dc:	5b                   	pop    %ebx
  8031dd:	5e                   	pop    %esi
  8031de:	5d                   	pop    %ebp
  8031df:	c3                   	ret    

008031e0 <accept>:
{
  8031e0:	55                   	push   %ebp
  8031e1:	89 e5                	mov    %esp,%ebp
  8031e3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8031e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e9:	e8 4e ff ff ff       	call   80313c <fd2sockid>
  8031ee:	85 c0                	test   %eax,%eax
  8031f0:	78 1b                	js     80320d <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8031f2:	83 ec 04             	sub    $0x4,%esp
  8031f5:	ff 75 10             	pushl  0x10(%ebp)
  8031f8:	ff 75 0c             	pushl  0xc(%ebp)
  8031fb:	50                   	push   %eax
  8031fc:	e8 0e 01 00 00       	call   80330f <nsipc_accept>
  803201:	83 c4 10             	add    $0x10,%esp
  803204:	85 c0                	test   %eax,%eax
  803206:	78 05                	js     80320d <accept+0x2d>
	return alloc_sockfd(r);
  803208:	e8 5f ff ff ff       	call   80316c <alloc_sockfd>
}
  80320d:	c9                   	leave  
  80320e:	c3                   	ret    

0080320f <bind>:
{
  80320f:	55                   	push   %ebp
  803210:	89 e5                	mov    %esp,%ebp
  803212:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  803215:	8b 45 08             	mov    0x8(%ebp),%eax
  803218:	e8 1f ff ff ff       	call   80313c <fd2sockid>
  80321d:	85 c0                	test   %eax,%eax
  80321f:	78 12                	js     803233 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  803221:	83 ec 04             	sub    $0x4,%esp
  803224:	ff 75 10             	pushl  0x10(%ebp)
  803227:	ff 75 0c             	pushl  0xc(%ebp)
  80322a:	50                   	push   %eax
  80322b:	e8 31 01 00 00       	call   803361 <nsipc_bind>
  803230:	83 c4 10             	add    $0x10,%esp
}
  803233:	c9                   	leave  
  803234:	c3                   	ret    

00803235 <shutdown>:
{
  803235:	55                   	push   %ebp
  803236:	89 e5                	mov    %esp,%ebp
  803238:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80323b:	8b 45 08             	mov    0x8(%ebp),%eax
  80323e:	e8 f9 fe ff ff       	call   80313c <fd2sockid>
  803243:	85 c0                	test   %eax,%eax
  803245:	78 0f                	js     803256 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  803247:	83 ec 08             	sub    $0x8,%esp
  80324a:	ff 75 0c             	pushl  0xc(%ebp)
  80324d:	50                   	push   %eax
  80324e:	e8 43 01 00 00       	call   803396 <nsipc_shutdown>
  803253:	83 c4 10             	add    $0x10,%esp
}
  803256:	c9                   	leave  
  803257:	c3                   	ret    

00803258 <connect>:
{
  803258:	55                   	push   %ebp
  803259:	89 e5                	mov    %esp,%ebp
  80325b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80325e:	8b 45 08             	mov    0x8(%ebp),%eax
  803261:	e8 d6 fe ff ff       	call   80313c <fd2sockid>
  803266:	85 c0                	test   %eax,%eax
  803268:	78 12                	js     80327c <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80326a:	83 ec 04             	sub    $0x4,%esp
  80326d:	ff 75 10             	pushl  0x10(%ebp)
  803270:	ff 75 0c             	pushl  0xc(%ebp)
  803273:	50                   	push   %eax
  803274:	e8 59 01 00 00       	call   8033d2 <nsipc_connect>
  803279:	83 c4 10             	add    $0x10,%esp
}
  80327c:	c9                   	leave  
  80327d:	c3                   	ret    

0080327e <listen>:
{
  80327e:	55                   	push   %ebp
  80327f:	89 e5                	mov    %esp,%ebp
  803281:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  803284:	8b 45 08             	mov    0x8(%ebp),%eax
  803287:	e8 b0 fe ff ff       	call   80313c <fd2sockid>
  80328c:	85 c0                	test   %eax,%eax
  80328e:	78 0f                	js     80329f <listen+0x21>
	return nsipc_listen(r, backlog);
  803290:	83 ec 08             	sub    $0x8,%esp
  803293:	ff 75 0c             	pushl  0xc(%ebp)
  803296:	50                   	push   %eax
  803297:	e8 6b 01 00 00       	call   803407 <nsipc_listen>
  80329c:	83 c4 10             	add    $0x10,%esp
}
  80329f:	c9                   	leave  
  8032a0:	c3                   	ret    

008032a1 <socket>:

int
socket(int domain, int type, int protocol)
{
  8032a1:	55                   	push   %ebp
  8032a2:	89 e5                	mov    %esp,%ebp
  8032a4:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8032a7:	ff 75 10             	pushl  0x10(%ebp)
  8032aa:	ff 75 0c             	pushl  0xc(%ebp)
  8032ad:	ff 75 08             	pushl  0x8(%ebp)
  8032b0:	e8 3e 02 00 00       	call   8034f3 <nsipc_socket>
  8032b5:	83 c4 10             	add    $0x10,%esp
  8032b8:	85 c0                	test   %eax,%eax
  8032ba:	78 05                	js     8032c1 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8032bc:	e8 ab fe ff ff       	call   80316c <alloc_sockfd>
}
  8032c1:	c9                   	leave  
  8032c2:	c3                   	ret    

008032c3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8032c3:	55                   	push   %ebp
  8032c4:	89 e5                	mov    %esp,%ebp
  8032c6:	53                   	push   %ebx
  8032c7:	83 ec 04             	sub    $0x4,%esp
  8032ca:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8032cc:	83 3d 24 64 80 00 00 	cmpl   $0x0,0x806424
  8032d3:	74 26                	je     8032fb <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8032d5:	6a 07                	push   $0x7
  8032d7:	68 00 80 80 00       	push   $0x808000
  8032dc:	53                   	push   %ebx
  8032dd:	ff 35 24 64 80 00    	pushl  0x806424
  8032e3:	e8 d0 06 00 00       	call   8039b8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8032e8:	83 c4 0c             	add    $0xc,%esp
  8032eb:	6a 00                	push   $0x0
  8032ed:	6a 00                	push   $0x0
  8032ef:	6a 00                	push   $0x0
  8032f1:	e8 59 06 00 00       	call   80394f <ipc_recv>
}
  8032f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8032f9:	c9                   	leave  
  8032fa:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8032fb:	83 ec 0c             	sub    $0xc,%esp
  8032fe:	6a 02                	push   $0x2
  803300:	e8 0b 07 00 00       	call   803a10 <ipc_find_env>
  803305:	a3 24 64 80 00       	mov    %eax,0x806424
  80330a:	83 c4 10             	add    $0x10,%esp
  80330d:	eb c6                	jmp    8032d5 <nsipc+0x12>

0080330f <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80330f:	55                   	push   %ebp
  803310:	89 e5                	mov    %esp,%ebp
  803312:	56                   	push   %esi
  803313:	53                   	push   %ebx
  803314:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  803317:	8b 45 08             	mov    0x8(%ebp),%eax
  80331a:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80331f:	8b 06                	mov    (%esi),%eax
  803321:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803326:	b8 01 00 00 00       	mov    $0x1,%eax
  80332b:	e8 93 ff ff ff       	call   8032c3 <nsipc>
  803330:	89 c3                	mov    %eax,%ebx
  803332:	85 c0                	test   %eax,%eax
  803334:	79 09                	jns    80333f <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  803336:	89 d8                	mov    %ebx,%eax
  803338:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80333b:	5b                   	pop    %ebx
  80333c:	5e                   	pop    %esi
  80333d:	5d                   	pop    %ebp
  80333e:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80333f:	83 ec 04             	sub    $0x4,%esp
  803342:	ff 35 10 80 80 00    	pushl  0x808010
  803348:	68 00 80 80 00       	push   $0x808000
  80334d:	ff 75 0c             	pushl  0xc(%ebp)
  803350:	e8 98 e2 ff ff       	call   8015ed <memmove>
		*addrlen = ret->ret_addrlen;
  803355:	a1 10 80 80 00       	mov    0x808010,%eax
  80335a:	89 06                	mov    %eax,(%esi)
  80335c:	83 c4 10             	add    $0x10,%esp
	return r;
  80335f:	eb d5                	jmp    803336 <nsipc_accept+0x27>

00803361 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803361:	55                   	push   %ebp
  803362:	89 e5                	mov    %esp,%ebp
  803364:	53                   	push   %ebx
  803365:	83 ec 08             	sub    $0x8,%esp
  803368:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80336b:	8b 45 08             	mov    0x8(%ebp),%eax
  80336e:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803373:	53                   	push   %ebx
  803374:	ff 75 0c             	pushl  0xc(%ebp)
  803377:	68 04 80 80 00       	push   $0x808004
  80337c:	e8 6c e2 ff ff       	call   8015ed <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  803381:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  803387:	b8 02 00 00 00       	mov    $0x2,%eax
  80338c:	e8 32 ff ff ff       	call   8032c3 <nsipc>
}
  803391:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803394:	c9                   	leave  
  803395:	c3                   	ret    

00803396 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803396:	55                   	push   %ebp
  803397:	89 e5                	mov    %esp,%ebp
  803399:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80339c:	8b 45 08             	mov    0x8(%ebp),%eax
  80339f:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  8033a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033a7:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  8033ac:	b8 03 00 00 00       	mov    $0x3,%eax
  8033b1:	e8 0d ff ff ff       	call   8032c3 <nsipc>
}
  8033b6:	c9                   	leave  
  8033b7:	c3                   	ret    

008033b8 <nsipc_close>:

int
nsipc_close(int s)
{
  8033b8:	55                   	push   %ebp
  8033b9:	89 e5                	mov    %esp,%ebp
  8033bb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8033be:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c1:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  8033c6:	b8 04 00 00 00       	mov    $0x4,%eax
  8033cb:	e8 f3 fe ff ff       	call   8032c3 <nsipc>
}
  8033d0:	c9                   	leave  
  8033d1:	c3                   	ret    

008033d2 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8033d2:	55                   	push   %ebp
  8033d3:	89 e5                	mov    %esp,%ebp
  8033d5:	53                   	push   %ebx
  8033d6:	83 ec 08             	sub    $0x8,%esp
  8033d9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8033dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033df:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8033e4:	53                   	push   %ebx
  8033e5:	ff 75 0c             	pushl  0xc(%ebp)
  8033e8:	68 04 80 80 00       	push   $0x808004
  8033ed:	e8 fb e1 ff ff       	call   8015ed <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8033f2:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  8033f8:	b8 05 00 00 00       	mov    $0x5,%eax
  8033fd:	e8 c1 fe ff ff       	call   8032c3 <nsipc>
}
  803402:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803405:	c9                   	leave  
  803406:	c3                   	ret    

00803407 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803407:	55                   	push   %ebp
  803408:	89 e5                	mov    %esp,%ebp
  80340a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80340d:	8b 45 08             	mov    0x8(%ebp),%eax
  803410:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  803415:	8b 45 0c             	mov    0xc(%ebp),%eax
  803418:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  80341d:	b8 06 00 00 00       	mov    $0x6,%eax
  803422:	e8 9c fe ff ff       	call   8032c3 <nsipc>
}
  803427:	c9                   	leave  
  803428:	c3                   	ret    

00803429 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803429:	55                   	push   %ebp
  80342a:	89 e5                	mov    %esp,%ebp
  80342c:	56                   	push   %esi
  80342d:	53                   	push   %ebx
  80342e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  803431:	8b 45 08             	mov    0x8(%ebp),%eax
  803434:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  803439:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  80343f:	8b 45 14             	mov    0x14(%ebp),%eax
  803442:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803447:	b8 07 00 00 00       	mov    $0x7,%eax
  80344c:	e8 72 fe ff ff       	call   8032c3 <nsipc>
  803451:	89 c3                	mov    %eax,%ebx
  803453:	85 c0                	test   %eax,%eax
  803455:	78 1f                	js     803476 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  803457:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80345c:	7f 21                	jg     80347f <nsipc_recv+0x56>
  80345e:	39 c6                	cmp    %eax,%esi
  803460:	7c 1d                	jl     80347f <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803462:	83 ec 04             	sub    $0x4,%esp
  803465:	50                   	push   %eax
  803466:	68 00 80 80 00       	push   $0x808000
  80346b:	ff 75 0c             	pushl  0xc(%ebp)
  80346e:	e8 7a e1 ff ff       	call   8015ed <memmove>
  803473:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  803476:	89 d8                	mov    %ebx,%eax
  803478:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80347b:	5b                   	pop    %ebx
  80347c:	5e                   	pop    %esi
  80347d:	5d                   	pop    %ebp
  80347e:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80347f:	68 ca 45 80 00       	push   $0x8045ca
  803484:	68 2f 3e 80 00       	push   $0x803e2f
  803489:	6a 62                	push   $0x62
  80348b:	68 df 45 80 00       	push   $0x8045df
  803490:	e8 85 d6 ff ff       	call   800b1a <_panic>

00803495 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803495:	55                   	push   %ebp
  803496:	89 e5                	mov    %esp,%ebp
  803498:	53                   	push   %ebx
  803499:	83 ec 04             	sub    $0x4,%esp
  80349c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80349f:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a2:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  8034a7:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8034ad:	7f 2e                	jg     8034dd <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8034af:	83 ec 04             	sub    $0x4,%esp
  8034b2:	53                   	push   %ebx
  8034b3:	ff 75 0c             	pushl  0xc(%ebp)
  8034b6:	68 0c 80 80 00       	push   $0x80800c
  8034bb:	e8 2d e1 ff ff       	call   8015ed <memmove>
	nsipcbuf.send.req_size = size;
  8034c0:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  8034c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8034c9:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  8034ce:	b8 08 00 00 00       	mov    $0x8,%eax
  8034d3:	e8 eb fd ff ff       	call   8032c3 <nsipc>
}
  8034d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8034db:	c9                   	leave  
  8034dc:	c3                   	ret    
	assert(size < 1600);
  8034dd:	68 eb 45 80 00       	push   $0x8045eb
  8034e2:	68 2f 3e 80 00       	push   $0x803e2f
  8034e7:	6a 6d                	push   $0x6d
  8034e9:	68 df 45 80 00       	push   $0x8045df
  8034ee:	e8 27 d6 ff ff       	call   800b1a <_panic>

008034f3 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8034f3:	55                   	push   %ebp
  8034f4:	89 e5                	mov    %esp,%ebp
  8034f6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8034f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fc:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  803501:	8b 45 0c             	mov    0xc(%ebp),%eax
  803504:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  803509:	8b 45 10             	mov    0x10(%ebp),%eax
  80350c:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  803511:	b8 09 00 00 00       	mov    $0x9,%eax
  803516:	e8 a8 fd ff ff       	call   8032c3 <nsipc>
}
  80351b:	c9                   	leave  
  80351c:	c3                   	ret    

0080351d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80351d:	55                   	push   %ebp
  80351e:	89 e5                	mov    %esp,%ebp
  803520:	56                   	push   %esi
  803521:	53                   	push   %ebx
  803522:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803525:	83 ec 0c             	sub    $0xc,%esp
  803528:	ff 75 08             	pushl  0x8(%ebp)
  80352b:	e8 3a ec ff ff       	call   80216a <fd2data>
  803530:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  803532:	83 c4 08             	add    $0x8,%esp
  803535:	68 f7 45 80 00       	push   $0x8045f7
  80353a:	53                   	push   %ebx
  80353b:	e8 1f df ff ff       	call   80145f <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  803540:	8b 46 04             	mov    0x4(%esi),%eax
  803543:	2b 06                	sub    (%esi),%eax
  803545:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80354b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  803552:	00 00 00 
	stat->st_dev = &devpipe;
  803555:	c7 83 88 00 00 00 58 	movl   $0x805058,0x88(%ebx)
  80355c:	50 80 00 
	return 0;
}
  80355f:	b8 00 00 00 00       	mov    $0x0,%eax
  803564:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803567:	5b                   	pop    %ebx
  803568:	5e                   	pop    %esi
  803569:	5d                   	pop    %ebp
  80356a:	c3                   	ret    

0080356b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80356b:	55                   	push   %ebp
  80356c:	89 e5                	mov    %esp,%ebp
  80356e:	53                   	push   %ebx
  80356f:	83 ec 0c             	sub    $0xc,%esp
  803572:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  803575:	53                   	push   %ebx
  803576:	6a 00                	push   $0x0
  803578:	e8 59 e3 ff ff       	call   8018d6 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80357d:	89 1c 24             	mov    %ebx,(%esp)
  803580:	e8 e5 eb ff ff       	call   80216a <fd2data>
  803585:	83 c4 08             	add    $0x8,%esp
  803588:	50                   	push   %eax
  803589:	6a 00                	push   $0x0
  80358b:	e8 46 e3 ff ff       	call   8018d6 <sys_page_unmap>
}
  803590:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803593:	c9                   	leave  
  803594:	c3                   	ret    

00803595 <_pipeisclosed>:
{
  803595:	55                   	push   %ebp
  803596:	89 e5                	mov    %esp,%ebp
  803598:	57                   	push   %edi
  803599:	56                   	push   %esi
  80359a:	53                   	push   %ebx
  80359b:	83 ec 1c             	sub    $0x1c,%esp
  80359e:	89 c7                	mov    %eax,%edi
  8035a0:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8035a2:	a1 28 64 80 00       	mov    0x806428,%eax
  8035a7:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8035aa:	83 ec 0c             	sub    $0xc,%esp
  8035ad:	57                   	push   %edi
  8035ae:	e8 98 04 00 00       	call   803a4b <pageref>
  8035b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8035b6:	89 34 24             	mov    %esi,(%esp)
  8035b9:	e8 8d 04 00 00       	call   803a4b <pageref>
		nn = thisenv->env_runs;
  8035be:	8b 15 28 64 80 00    	mov    0x806428,%edx
  8035c4:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8035c7:	83 c4 10             	add    $0x10,%esp
  8035ca:	39 cb                	cmp    %ecx,%ebx
  8035cc:	74 1b                	je     8035e9 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8035ce:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8035d1:	75 cf                	jne    8035a2 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8035d3:	8b 42 58             	mov    0x58(%edx),%eax
  8035d6:	6a 01                	push   $0x1
  8035d8:	50                   	push   %eax
  8035d9:	53                   	push   %ebx
  8035da:	68 fe 45 80 00       	push   $0x8045fe
  8035df:	e8 2c d6 ff ff       	call   800c10 <cprintf>
  8035e4:	83 c4 10             	add    $0x10,%esp
  8035e7:	eb b9                	jmp    8035a2 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8035e9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8035ec:	0f 94 c0             	sete   %al
  8035ef:	0f b6 c0             	movzbl %al,%eax
}
  8035f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8035f5:	5b                   	pop    %ebx
  8035f6:	5e                   	pop    %esi
  8035f7:	5f                   	pop    %edi
  8035f8:	5d                   	pop    %ebp
  8035f9:	c3                   	ret    

008035fa <devpipe_write>:
{
  8035fa:	55                   	push   %ebp
  8035fb:	89 e5                	mov    %esp,%ebp
  8035fd:	57                   	push   %edi
  8035fe:	56                   	push   %esi
  8035ff:	53                   	push   %ebx
  803600:	83 ec 28             	sub    $0x28,%esp
  803603:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  803606:	56                   	push   %esi
  803607:	e8 5e eb ff ff       	call   80216a <fd2data>
  80360c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80360e:	83 c4 10             	add    $0x10,%esp
  803611:	bf 00 00 00 00       	mov    $0x0,%edi
  803616:	3b 7d 10             	cmp    0x10(%ebp),%edi
  803619:	74 4f                	je     80366a <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80361b:	8b 43 04             	mov    0x4(%ebx),%eax
  80361e:	8b 0b                	mov    (%ebx),%ecx
  803620:	8d 51 20             	lea    0x20(%ecx),%edx
  803623:	39 d0                	cmp    %edx,%eax
  803625:	72 14                	jb     80363b <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  803627:	89 da                	mov    %ebx,%edx
  803629:	89 f0                	mov    %esi,%eax
  80362b:	e8 65 ff ff ff       	call   803595 <_pipeisclosed>
  803630:	85 c0                	test   %eax,%eax
  803632:	75 3b                	jne    80366f <devpipe_write+0x75>
			sys_yield();
  803634:	e8 f9 e1 ff ff       	call   801832 <sys_yield>
  803639:	eb e0                	jmp    80361b <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80363b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80363e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  803642:	88 4d e7             	mov    %cl,-0x19(%ebp)
  803645:	89 c2                	mov    %eax,%edx
  803647:	c1 fa 1f             	sar    $0x1f,%edx
  80364a:	89 d1                	mov    %edx,%ecx
  80364c:	c1 e9 1b             	shr    $0x1b,%ecx
  80364f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  803652:	83 e2 1f             	and    $0x1f,%edx
  803655:	29 ca                	sub    %ecx,%edx
  803657:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80365b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80365f:	83 c0 01             	add    $0x1,%eax
  803662:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  803665:	83 c7 01             	add    $0x1,%edi
  803668:	eb ac                	jmp    803616 <devpipe_write+0x1c>
	return i;
  80366a:	8b 45 10             	mov    0x10(%ebp),%eax
  80366d:	eb 05                	jmp    803674 <devpipe_write+0x7a>
				return 0;
  80366f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803674:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803677:	5b                   	pop    %ebx
  803678:	5e                   	pop    %esi
  803679:	5f                   	pop    %edi
  80367a:	5d                   	pop    %ebp
  80367b:	c3                   	ret    

0080367c <devpipe_read>:
{
  80367c:	55                   	push   %ebp
  80367d:	89 e5                	mov    %esp,%ebp
  80367f:	57                   	push   %edi
  803680:	56                   	push   %esi
  803681:	53                   	push   %ebx
  803682:	83 ec 18             	sub    $0x18,%esp
  803685:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  803688:	57                   	push   %edi
  803689:	e8 dc ea ff ff       	call   80216a <fd2data>
  80368e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  803690:	83 c4 10             	add    $0x10,%esp
  803693:	be 00 00 00 00       	mov    $0x0,%esi
  803698:	3b 75 10             	cmp    0x10(%ebp),%esi
  80369b:	75 14                	jne    8036b1 <devpipe_read+0x35>
	return i;
  80369d:	8b 45 10             	mov    0x10(%ebp),%eax
  8036a0:	eb 02                	jmp    8036a4 <devpipe_read+0x28>
				return i;
  8036a2:	89 f0                	mov    %esi,%eax
}
  8036a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8036a7:	5b                   	pop    %ebx
  8036a8:	5e                   	pop    %esi
  8036a9:	5f                   	pop    %edi
  8036aa:	5d                   	pop    %ebp
  8036ab:	c3                   	ret    
			sys_yield();
  8036ac:	e8 81 e1 ff ff       	call   801832 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8036b1:	8b 03                	mov    (%ebx),%eax
  8036b3:	3b 43 04             	cmp    0x4(%ebx),%eax
  8036b6:	75 18                	jne    8036d0 <devpipe_read+0x54>
			if (i > 0)
  8036b8:	85 f6                	test   %esi,%esi
  8036ba:	75 e6                	jne    8036a2 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8036bc:	89 da                	mov    %ebx,%edx
  8036be:	89 f8                	mov    %edi,%eax
  8036c0:	e8 d0 fe ff ff       	call   803595 <_pipeisclosed>
  8036c5:	85 c0                	test   %eax,%eax
  8036c7:	74 e3                	je     8036ac <devpipe_read+0x30>
				return 0;
  8036c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8036ce:	eb d4                	jmp    8036a4 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8036d0:	99                   	cltd   
  8036d1:	c1 ea 1b             	shr    $0x1b,%edx
  8036d4:	01 d0                	add    %edx,%eax
  8036d6:	83 e0 1f             	and    $0x1f,%eax
  8036d9:	29 d0                	sub    %edx,%eax
  8036db:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8036e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8036e3:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8036e6:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8036e9:	83 c6 01             	add    $0x1,%esi
  8036ec:	eb aa                	jmp    803698 <devpipe_read+0x1c>

008036ee <pipe>:
{
  8036ee:	55                   	push   %ebp
  8036ef:	89 e5                	mov    %esp,%ebp
  8036f1:	56                   	push   %esi
  8036f2:	53                   	push   %ebx
  8036f3:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8036f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8036f9:	50                   	push   %eax
  8036fa:	e8 82 ea ff ff       	call   802181 <fd_alloc>
  8036ff:	89 c3                	mov    %eax,%ebx
  803701:	83 c4 10             	add    $0x10,%esp
  803704:	85 c0                	test   %eax,%eax
  803706:	0f 88 23 01 00 00    	js     80382f <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80370c:	83 ec 04             	sub    $0x4,%esp
  80370f:	68 07 04 00 00       	push   $0x407
  803714:	ff 75 f4             	pushl  -0xc(%ebp)
  803717:	6a 00                	push   $0x0
  803719:	e8 33 e1 ff ff       	call   801851 <sys_page_alloc>
  80371e:	89 c3                	mov    %eax,%ebx
  803720:	83 c4 10             	add    $0x10,%esp
  803723:	85 c0                	test   %eax,%eax
  803725:	0f 88 04 01 00 00    	js     80382f <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80372b:	83 ec 0c             	sub    $0xc,%esp
  80372e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803731:	50                   	push   %eax
  803732:	e8 4a ea ff ff       	call   802181 <fd_alloc>
  803737:	89 c3                	mov    %eax,%ebx
  803739:	83 c4 10             	add    $0x10,%esp
  80373c:	85 c0                	test   %eax,%eax
  80373e:	0f 88 db 00 00 00    	js     80381f <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803744:	83 ec 04             	sub    $0x4,%esp
  803747:	68 07 04 00 00       	push   $0x407
  80374c:	ff 75 f0             	pushl  -0x10(%ebp)
  80374f:	6a 00                	push   $0x0
  803751:	e8 fb e0 ff ff       	call   801851 <sys_page_alloc>
  803756:	89 c3                	mov    %eax,%ebx
  803758:	83 c4 10             	add    $0x10,%esp
  80375b:	85 c0                	test   %eax,%eax
  80375d:	0f 88 bc 00 00 00    	js     80381f <pipe+0x131>
	va = fd2data(fd0);
  803763:	83 ec 0c             	sub    $0xc,%esp
  803766:	ff 75 f4             	pushl  -0xc(%ebp)
  803769:	e8 fc e9 ff ff       	call   80216a <fd2data>
  80376e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803770:	83 c4 0c             	add    $0xc,%esp
  803773:	68 07 04 00 00       	push   $0x407
  803778:	50                   	push   %eax
  803779:	6a 00                	push   $0x0
  80377b:	e8 d1 e0 ff ff       	call   801851 <sys_page_alloc>
  803780:	89 c3                	mov    %eax,%ebx
  803782:	83 c4 10             	add    $0x10,%esp
  803785:	85 c0                	test   %eax,%eax
  803787:	0f 88 82 00 00 00    	js     80380f <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80378d:	83 ec 0c             	sub    $0xc,%esp
  803790:	ff 75 f0             	pushl  -0x10(%ebp)
  803793:	e8 d2 e9 ff ff       	call   80216a <fd2data>
  803798:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80379f:	50                   	push   %eax
  8037a0:	6a 00                	push   $0x0
  8037a2:	56                   	push   %esi
  8037a3:	6a 00                	push   $0x0
  8037a5:	e8 ea e0 ff ff       	call   801894 <sys_page_map>
  8037aa:	89 c3                	mov    %eax,%ebx
  8037ac:	83 c4 20             	add    $0x20,%esp
  8037af:	85 c0                	test   %eax,%eax
  8037b1:	78 4e                	js     803801 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8037b3:	a1 58 50 80 00       	mov    0x805058,%eax
  8037b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037bb:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8037bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037c0:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8037c7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037ca:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8037cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037cf:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8037d6:	83 ec 0c             	sub    $0xc,%esp
  8037d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8037dc:	e8 79 e9 ff ff       	call   80215a <fd2num>
  8037e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8037e4:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8037e6:	83 c4 04             	add    $0x4,%esp
  8037e9:	ff 75 f0             	pushl  -0x10(%ebp)
  8037ec:	e8 69 e9 ff ff       	call   80215a <fd2num>
  8037f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8037f4:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8037f7:	83 c4 10             	add    $0x10,%esp
  8037fa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8037ff:	eb 2e                	jmp    80382f <pipe+0x141>
	sys_page_unmap(0, va);
  803801:	83 ec 08             	sub    $0x8,%esp
  803804:	56                   	push   %esi
  803805:	6a 00                	push   $0x0
  803807:	e8 ca e0 ff ff       	call   8018d6 <sys_page_unmap>
  80380c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80380f:	83 ec 08             	sub    $0x8,%esp
  803812:	ff 75 f0             	pushl  -0x10(%ebp)
  803815:	6a 00                	push   $0x0
  803817:	e8 ba e0 ff ff       	call   8018d6 <sys_page_unmap>
  80381c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80381f:	83 ec 08             	sub    $0x8,%esp
  803822:	ff 75 f4             	pushl  -0xc(%ebp)
  803825:	6a 00                	push   $0x0
  803827:	e8 aa e0 ff ff       	call   8018d6 <sys_page_unmap>
  80382c:	83 c4 10             	add    $0x10,%esp
}
  80382f:	89 d8                	mov    %ebx,%eax
  803831:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803834:	5b                   	pop    %ebx
  803835:	5e                   	pop    %esi
  803836:	5d                   	pop    %ebp
  803837:	c3                   	ret    

00803838 <pipeisclosed>:
{
  803838:	55                   	push   %ebp
  803839:	89 e5                	mov    %esp,%ebp
  80383b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80383e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803841:	50                   	push   %eax
  803842:	ff 75 08             	pushl  0x8(%ebp)
  803845:	e8 89 e9 ff ff       	call   8021d3 <fd_lookup>
  80384a:	83 c4 10             	add    $0x10,%esp
  80384d:	85 c0                	test   %eax,%eax
  80384f:	78 18                	js     803869 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  803851:	83 ec 0c             	sub    $0xc,%esp
  803854:	ff 75 f4             	pushl  -0xc(%ebp)
  803857:	e8 0e e9 ff ff       	call   80216a <fd2data>
	return _pipeisclosed(fd, p);
  80385c:	89 c2                	mov    %eax,%edx
  80385e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803861:	e8 2f fd ff ff       	call   803595 <_pipeisclosed>
  803866:	83 c4 10             	add    $0x10,%esp
}
  803869:	c9                   	leave  
  80386a:	c3                   	ret    

0080386b <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80386b:	55                   	push   %ebp
  80386c:	89 e5                	mov    %esp,%ebp
  80386e:	56                   	push   %esi
  80386f:	53                   	push   %ebx
  803870:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  803873:	85 f6                	test   %esi,%esi
  803875:	74 13                	je     80388a <wait+0x1f>
	e = &envs[ENVX(envid)];
  803877:	89 f3                	mov    %esi,%ebx
  803879:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80387f:	c1 e3 07             	shl    $0x7,%ebx
  803882:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  803888:	eb 1b                	jmp    8038a5 <wait+0x3a>
	assert(envid != 0);
  80388a:	68 16 46 80 00       	push   $0x804616
  80388f:	68 2f 3e 80 00       	push   $0x803e2f
  803894:	6a 09                	push   $0x9
  803896:	68 21 46 80 00       	push   $0x804621
  80389b:	e8 7a d2 ff ff       	call   800b1a <_panic>
		sys_yield();
  8038a0:	e8 8d df ff ff       	call   801832 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8038a5:	8b 43 48             	mov    0x48(%ebx),%eax
  8038a8:	39 f0                	cmp    %esi,%eax
  8038aa:	75 07                	jne    8038b3 <wait+0x48>
  8038ac:	8b 43 54             	mov    0x54(%ebx),%eax
  8038af:	85 c0                	test   %eax,%eax
  8038b1:	75 ed                	jne    8038a0 <wait+0x35>
}
  8038b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8038b6:	5b                   	pop    %ebx
  8038b7:	5e                   	pop    %esi
  8038b8:	5d                   	pop    %ebp
  8038b9:	c3                   	ret    

008038ba <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8038ba:	55                   	push   %ebp
  8038bb:	89 e5                	mov    %esp,%ebp
  8038bd:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8038c0:	83 3d 00 90 80 00 00 	cmpl   $0x0,0x809000
  8038c7:	74 0a                	je     8038d3 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8038c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038cc:	a3 00 90 80 00       	mov    %eax,0x809000
}
  8038d1:	c9                   	leave  
  8038d2:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8038d3:	83 ec 04             	sub    $0x4,%esp
  8038d6:	6a 07                	push   $0x7
  8038d8:	68 00 f0 bf ee       	push   $0xeebff000
  8038dd:	6a 00                	push   $0x0
  8038df:	e8 6d df ff ff       	call   801851 <sys_page_alloc>
		if(r < 0)
  8038e4:	83 c4 10             	add    $0x10,%esp
  8038e7:	85 c0                	test   %eax,%eax
  8038e9:	78 2a                	js     803915 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8038eb:	83 ec 08             	sub    $0x8,%esp
  8038ee:	68 29 39 80 00       	push   $0x803929
  8038f3:	6a 00                	push   $0x0
  8038f5:	e8 a2 e0 ff ff       	call   80199c <sys_env_set_pgfault_upcall>
		if(r < 0)
  8038fa:	83 c4 10             	add    $0x10,%esp
  8038fd:	85 c0                	test   %eax,%eax
  8038ff:	79 c8                	jns    8038c9 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  803901:	83 ec 04             	sub    $0x4,%esp
  803904:	68 5c 46 80 00       	push   $0x80465c
  803909:	6a 25                	push   $0x25
  80390b:	68 98 46 80 00       	push   $0x804698
  803910:	e8 05 d2 ff ff       	call   800b1a <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  803915:	83 ec 04             	sub    $0x4,%esp
  803918:	68 2c 46 80 00       	push   $0x80462c
  80391d:	6a 22                	push   $0x22
  80391f:	68 98 46 80 00       	push   $0x804698
  803924:	e8 f1 d1 ff ff       	call   800b1a <_panic>

00803929 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  803929:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80392a:	a1 00 90 80 00       	mov    0x809000,%eax
	call *%eax
  80392f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  803931:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  803934:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  803938:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  80393c:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80393f:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  803941:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  803945:	83 c4 08             	add    $0x8,%esp
	popal
  803948:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  803949:	83 c4 04             	add    $0x4,%esp
	popfl
  80394c:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80394d:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80394e:	c3                   	ret    

0080394f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80394f:	55                   	push   %ebp
  803950:	89 e5                	mov    %esp,%ebp
  803952:	56                   	push   %esi
  803953:	53                   	push   %ebx
  803954:	8b 75 08             	mov    0x8(%ebp),%esi
  803957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80395a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80395d:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80395f:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  803964:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  803967:	83 ec 0c             	sub    $0xc,%esp
  80396a:	50                   	push   %eax
  80396b:	e8 91 e0 ff ff       	call   801a01 <sys_ipc_recv>
	if(ret < 0){
  803970:	83 c4 10             	add    $0x10,%esp
  803973:	85 c0                	test   %eax,%eax
  803975:	78 2b                	js     8039a2 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  803977:	85 f6                	test   %esi,%esi
  803979:	74 0a                	je     803985 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80397b:	a1 28 64 80 00       	mov    0x806428,%eax
  803980:	8b 40 74             	mov    0x74(%eax),%eax
  803983:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  803985:	85 db                	test   %ebx,%ebx
  803987:	74 0a                	je     803993 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  803989:	a1 28 64 80 00       	mov    0x806428,%eax
  80398e:	8b 40 78             	mov    0x78(%eax),%eax
  803991:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  803993:	a1 28 64 80 00       	mov    0x806428,%eax
  803998:	8b 40 70             	mov    0x70(%eax),%eax
}
  80399b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80399e:	5b                   	pop    %ebx
  80399f:	5e                   	pop    %esi
  8039a0:	5d                   	pop    %ebp
  8039a1:	c3                   	ret    
		if(from_env_store)
  8039a2:	85 f6                	test   %esi,%esi
  8039a4:	74 06                	je     8039ac <ipc_recv+0x5d>
			*from_env_store = 0;
  8039a6:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8039ac:	85 db                	test   %ebx,%ebx
  8039ae:	74 eb                	je     80399b <ipc_recv+0x4c>
			*perm_store = 0;
  8039b0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8039b6:	eb e3                	jmp    80399b <ipc_recv+0x4c>

008039b8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8039b8:	55                   	push   %ebp
  8039b9:	89 e5                	mov    %esp,%ebp
  8039bb:	57                   	push   %edi
  8039bc:	56                   	push   %esi
  8039bd:	53                   	push   %ebx
  8039be:	83 ec 0c             	sub    $0xc,%esp
  8039c1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8039c4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8039c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8039ca:	85 db                	test   %ebx,%ebx
  8039cc:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8039d1:	0f 44 d8             	cmove  %eax,%ebx
  8039d4:	eb 05                	jmp    8039db <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8039d6:	e8 57 de ff ff       	call   801832 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8039db:	ff 75 14             	pushl  0x14(%ebp)
  8039de:	53                   	push   %ebx
  8039df:	56                   	push   %esi
  8039e0:	57                   	push   %edi
  8039e1:	e8 f8 df ff ff       	call   8019de <sys_ipc_try_send>
  8039e6:	83 c4 10             	add    $0x10,%esp
  8039e9:	85 c0                	test   %eax,%eax
  8039eb:	74 1b                	je     803a08 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8039ed:	79 e7                	jns    8039d6 <ipc_send+0x1e>
  8039ef:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8039f2:	74 e2                	je     8039d6 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8039f4:	83 ec 04             	sub    $0x4,%esp
  8039f7:	68 a6 46 80 00       	push   $0x8046a6
  8039fc:	6a 46                	push   $0x46
  8039fe:	68 bb 46 80 00       	push   $0x8046bb
  803a03:	e8 12 d1 ff ff       	call   800b1a <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  803a08:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803a0b:	5b                   	pop    %ebx
  803a0c:	5e                   	pop    %esi
  803a0d:	5f                   	pop    %edi
  803a0e:	5d                   	pop    %ebp
  803a0f:	c3                   	ret    

00803a10 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803a10:	55                   	push   %ebp
  803a11:	89 e5                	mov    %esp,%ebp
  803a13:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  803a16:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  803a1b:	89 c2                	mov    %eax,%edx
  803a1d:	c1 e2 07             	shl    $0x7,%edx
  803a20:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  803a26:	8b 52 50             	mov    0x50(%edx),%edx
  803a29:	39 ca                	cmp    %ecx,%edx
  803a2b:	74 11                	je     803a3e <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  803a2d:	83 c0 01             	add    $0x1,%eax
  803a30:	3d 00 04 00 00       	cmp    $0x400,%eax
  803a35:	75 e4                	jne    803a1b <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  803a37:	b8 00 00 00 00       	mov    $0x0,%eax
  803a3c:	eb 0b                	jmp    803a49 <ipc_find_env+0x39>
			return envs[i].env_id;
  803a3e:	c1 e0 07             	shl    $0x7,%eax
  803a41:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  803a46:	8b 40 48             	mov    0x48(%eax),%eax
}
  803a49:	5d                   	pop    %ebp
  803a4a:	c3                   	ret    

00803a4b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803a4b:	55                   	push   %ebp
  803a4c:	89 e5                	mov    %esp,%ebp
  803a4e:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803a51:	89 d0                	mov    %edx,%eax
  803a53:	c1 e8 16             	shr    $0x16,%eax
  803a56:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  803a5d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  803a62:	f6 c1 01             	test   $0x1,%cl
  803a65:	74 1d                	je     803a84 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  803a67:	c1 ea 0c             	shr    $0xc,%edx
  803a6a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803a71:	f6 c2 01             	test   $0x1,%dl
  803a74:	74 0e                	je     803a84 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803a76:	c1 ea 0c             	shr    $0xc,%edx
  803a79:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  803a80:	ef 
  803a81:	0f b7 c0             	movzwl %ax,%eax
}
  803a84:	5d                   	pop    %ebp
  803a85:	c3                   	ret    
  803a86:	66 90                	xchg   %ax,%ax
  803a88:	66 90                	xchg   %ax,%ax
  803a8a:	66 90                	xchg   %ax,%ax
  803a8c:	66 90                	xchg   %ax,%ax
  803a8e:	66 90                	xchg   %ax,%ax

00803a90 <__udivdi3>:
  803a90:	55                   	push   %ebp
  803a91:	57                   	push   %edi
  803a92:	56                   	push   %esi
  803a93:	53                   	push   %ebx
  803a94:	83 ec 1c             	sub    $0x1c,%esp
  803a97:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  803a9b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  803a9f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803aa3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  803aa7:	85 d2                	test   %edx,%edx
  803aa9:	75 4d                	jne    803af8 <__udivdi3+0x68>
  803aab:	39 f3                	cmp    %esi,%ebx
  803aad:	76 19                	jbe    803ac8 <__udivdi3+0x38>
  803aaf:	31 ff                	xor    %edi,%edi
  803ab1:	89 e8                	mov    %ebp,%eax
  803ab3:	89 f2                	mov    %esi,%edx
  803ab5:	f7 f3                	div    %ebx
  803ab7:	89 fa                	mov    %edi,%edx
  803ab9:	83 c4 1c             	add    $0x1c,%esp
  803abc:	5b                   	pop    %ebx
  803abd:	5e                   	pop    %esi
  803abe:	5f                   	pop    %edi
  803abf:	5d                   	pop    %ebp
  803ac0:	c3                   	ret    
  803ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803ac8:	89 d9                	mov    %ebx,%ecx
  803aca:	85 db                	test   %ebx,%ebx
  803acc:	75 0b                	jne    803ad9 <__udivdi3+0x49>
  803ace:	b8 01 00 00 00       	mov    $0x1,%eax
  803ad3:	31 d2                	xor    %edx,%edx
  803ad5:	f7 f3                	div    %ebx
  803ad7:	89 c1                	mov    %eax,%ecx
  803ad9:	31 d2                	xor    %edx,%edx
  803adb:	89 f0                	mov    %esi,%eax
  803add:	f7 f1                	div    %ecx
  803adf:	89 c6                	mov    %eax,%esi
  803ae1:	89 e8                	mov    %ebp,%eax
  803ae3:	89 f7                	mov    %esi,%edi
  803ae5:	f7 f1                	div    %ecx
  803ae7:	89 fa                	mov    %edi,%edx
  803ae9:	83 c4 1c             	add    $0x1c,%esp
  803aec:	5b                   	pop    %ebx
  803aed:	5e                   	pop    %esi
  803aee:	5f                   	pop    %edi
  803aef:	5d                   	pop    %ebp
  803af0:	c3                   	ret    
  803af1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803af8:	39 f2                	cmp    %esi,%edx
  803afa:	77 1c                	ja     803b18 <__udivdi3+0x88>
  803afc:	0f bd fa             	bsr    %edx,%edi
  803aff:	83 f7 1f             	xor    $0x1f,%edi
  803b02:	75 2c                	jne    803b30 <__udivdi3+0xa0>
  803b04:	39 f2                	cmp    %esi,%edx
  803b06:	72 06                	jb     803b0e <__udivdi3+0x7e>
  803b08:	31 c0                	xor    %eax,%eax
  803b0a:	39 eb                	cmp    %ebp,%ebx
  803b0c:	77 a9                	ja     803ab7 <__udivdi3+0x27>
  803b0e:	b8 01 00 00 00       	mov    $0x1,%eax
  803b13:	eb a2                	jmp    803ab7 <__udivdi3+0x27>
  803b15:	8d 76 00             	lea    0x0(%esi),%esi
  803b18:	31 ff                	xor    %edi,%edi
  803b1a:	31 c0                	xor    %eax,%eax
  803b1c:	89 fa                	mov    %edi,%edx
  803b1e:	83 c4 1c             	add    $0x1c,%esp
  803b21:	5b                   	pop    %ebx
  803b22:	5e                   	pop    %esi
  803b23:	5f                   	pop    %edi
  803b24:	5d                   	pop    %ebp
  803b25:	c3                   	ret    
  803b26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803b2d:	8d 76 00             	lea    0x0(%esi),%esi
  803b30:	89 f9                	mov    %edi,%ecx
  803b32:	b8 20 00 00 00       	mov    $0x20,%eax
  803b37:	29 f8                	sub    %edi,%eax
  803b39:	d3 e2                	shl    %cl,%edx
  803b3b:	89 54 24 08          	mov    %edx,0x8(%esp)
  803b3f:	89 c1                	mov    %eax,%ecx
  803b41:	89 da                	mov    %ebx,%edx
  803b43:	d3 ea                	shr    %cl,%edx
  803b45:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803b49:	09 d1                	or     %edx,%ecx
  803b4b:	89 f2                	mov    %esi,%edx
  803b4d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b51:	89 f9                	mov    %edi,%ecx
  803b53:	d3 e3                	shl    %cl,%ebx
  803b55:	89 c1                	mov    %eax,%ecx
  803b57:	d3 ea                	shr    %cl,%edx
  803b59:	89 f9                	mov    %edi,%ecx
  803b5b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  803b5f:	89 eb                	mov    %ebp,%ebx
  803b61:	d3 e6                	shl    %cl,%esi
  803b63:	89 c1                	mov    %eax,%ecx
  803b65:	d3 eb                	shr    %cl,%ebx
  803b67:	09 de                	or     %ebx,%esi
  803b69:	89 f0                	mov    %esi,%eax
  803b6b:	f7 74 24 08          	divl   0x8(%esp)
  803b6f:	89 d6                	mov    %edx,%esi
  803b71:	89 c3                	mov    %eax,%ebx
  803b73:	f7 64 24 0c          	mull   0xc(%esp)
  803b77:	39 d6                	cmp    %edx,%esi
  803b79:	72 15                	jb     803b90 <__udivdi3+0x100>
  803b7b:	89 f9                	mov    %edi,%ecx
  803b7d:	d3 e5                	shl    %cl,%ebp
  803b7f:	39 c5                	cmp    %eax,%ebp
  803b81:	73 04                	jae    803b87 <__udivdi3+0xf7>
  803b83:	39 d6                	cmp    %edx,%esi
  803b85:	74 09                	je     803b90 <__udivdi3+0x100>
  803b87:	89 d8                	mov    %ebx,%eax
  803b89:	31 ff                	xor    %edi,%edi
  803b8b:	e9 27 ff ff ff       	jmp    803ab7 <__udivdi3+0x27>
  803b90:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b93:	31 ff                	xor    %edi,%edi
  803b95:	e9 1d ff ff ff       	jmp    803ab7 <__udivdi3+0x27>
  803b9a:	66 90                	xchg   %ax,%ax
  803b9c:	66 90                	xchg   %ax,%ax
  803b9e:	66 90                	xchg   %ax,%ax

00803ba0 <__umoddi3>:
  803ba0:	55                   	push   %ebp
  803ba1:	57                   	push   %edi
  803ba2:	56                   	push   %esi
  803ba3:	53                   	push   %ebx
  803ba4:	83 ec 1c             	sub    $0x1c,%esp
  803ba7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  803bab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803baf:	8b 74 24 30          	mov    0x30(%esp),%esi
  803bb3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803bb7:	89 da                	mov    %ebx,%edx
  803bb9:	85 c0                	test   %eax,%eax
  803bbb:	75 43                	jne    803c00 <__umoddi3+0x60>
  803bbd:	39 df                	cmp    %ebx,%edi
  803bbf:	76 17                	jbe    803bd8 <__umoddi3+0x38>
  803bc1:	89 f0                	mov    %esi,%eax
  803bc3:	f7 f7                	div    %edi
  803bc5:	89 d0                	mov    %edx,%eax
  803bc7:	31 d2                	xor    %edx,%edx
  803bc9:	83 c4 1c             	add    $0x1c,%esp
  803bcc:	5b                   	pop    %ebx
  803bcd:	5e                   	pop    %esi
  803bce:	5f                   	pop    %edi
  803bcf:	5d                   	pop    %ebp
  803bd0:	c3                   	ret    
  803bd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803bd8:	89 fd                	mov    %edi,%ebp
  803bda:	85 ff                	test   %edi,%edi
  803bdc:	75 0b                	jne    803be9 <__umoddi3+0x49>
  803bde:	b8 01 00 00 00       	mov    $0x1,%eax
  803be3:	31 d2                	xor    %edx,%edx
  803be5:	f7 f7                	div    %edi
  803be7:	89 c5                	mov    %eax,%ebp
  803be9:	89 d8                	mov    %ebx,%eax
  803beb:	31 d2                	xor    %edx,%edx
  803bed:	f7 f5                	div    %ebp
  803bef:	89 f0                	mov    %esi,%eax
  803bf1:	f7 f5                	div    %ebp
  803bf3:	89 d0                	mov    %edx,%eax
  803bf5:	eb d0                	jmp    803bc7 <__umoddi3+0x27>
  803bf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803bfe:	66 90                	xchg   %ax,%ax
  803c00:	89 f1                	mov    %esi,%ecx
  803c02:	39 d8                	cmp    %ebx,%eax
  803c04:	76 0a                	jbe    803c10 <__umoddi3+0x70>
  803c06:	89 f0                	mov    %esi,%eax
  803c08:	83 c4 1c             	add    $0x1c,%esp
  803c0b:	5b                   	pop    %ebx
  803c0c:	5e                   	pop    %esi
  803c0d:	5f                   	pop    %edi
  803c0e:	5d                   	pop    %ebp
  803c0f:	c3                   	ret    
  803c10:	0f bd e8             	bsr    %eax,%ebp
  803c13:	83 f5 1f             	xor    $0x1f,%ebp
  803c16:	75 20                	jne    803c38 <__umoddi3+0x98>
  803c18:	39 d8                	cmp    %ebx,%eax
  803c1a:	0f 82 b0 00 00 00    	jb     803cd0 <__umoddi3+0x130>
  803c20:	39 f7                	cmp    %esi,%edi
  803c22:	0f 86 a8 00 00 00    	jbe    803cd0 <__umoddi3+0x130>
  803c28:	89 c8                	mov    %ecx,%eax
  803c2a:	83 c4 1c             	add    $0x1c,%esp
  803c2d:	5b                   	pop    %ebx
  803c2e:	5e                   	pop    %esi
  803c2f:	5f                   	pop    %edi
  803c30:	5d                   	pop    %ebp
  803c31:	c3                   	ret    
  803c32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803c38:	89 e9                	mov    %ebp,%ecx
  803c3a:	ba 20 00 00 00       	mov    $0x20,%edx
  803c3f:	29 ea                	sub    %ebp,%edx
  803c41:	d3 e0                	shl    %cl,%eax
  803c43:	89 44 24 08          	mov    %eax,0x8(%esp)
  803c47:	89 d1                	mov    %edx,%ecx
  803c49:	89 f8                	mov    %edi,%eax
  803c4b:	d3 e8                	shr    %cl,%eax
  803c4d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803c51:	89 54 24 04          	mov    %edx,0x4(%esp)
  803c55:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c59:	09 c1                	or     %eax,%ecx
  803c5b:	89 d8                	mov    %ebx,%eax
  803c5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c61:	89 e9                	mov    %ebp,%ecx
  803c63:	d3 e7                	shl    %cl,%edi
  803c65:	89 d1                	mov    %edx,%ecx
  803c67:	d3 e8                	shr    %cl,%eax
  803c69:	89 e9                	mov    %ebp,%ecx
  803c6b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c6f:	d3 e3                	shl    %cl,%ebx
  803c71:	89 c7                	mov    %eax,%edi
  803c73:	89 d1                	mov    %edx,%ecx
  803c75:	89 f0                	mov    %esi,%eax
  803c77:	d3 e8                	shr    %cl,%eax
  803c79:	89 e9                	mov    %ebp,%ecx
  803c7b:	89 fa                	mov    %edi,%edx
  803c7d:	d3 e6                	shl    %cl,%esi
  803c7f:	09 d8                	or     %ebx,%eax
  803c81:	f7 74 24 08          	divl   0x8(%esp)
  803c85:	89 d1                	mov    %edx,%ecx
  803c87:	89 f3                	mov    %esi,%ebx
  803c89:	f7 64 24 0c          	mull   0xc(%esp)
  803c8d:	89 c6                	mov    %eax,%esi
  803c8f:	89 d7                	mov    %edx,%edi
  803c91:	39 d1                	cmp    %edx,%ecx
  803c93:	72 06                	jb     803c9b <__umoddi3+0xfb>
  803c95:	75 10                	jne    803ca7 <__umoddi3+0x107>
  803c97:	39 c3                	cmp    %eax,%ebx
  803c99:	73 0c                	jae    803ca7 <__umoddi3+0x107>
  803c9b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  803c9f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  803ca3:	89 d7                	mov    %edx,%edi
  803ca5:	89 c6                	mov    %eax,%esi
  803ca7:	89 ca                	mov    %ecx,%edx
  803ca9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  803cae:	29 f3                	sub    %esi,%ebx
  803cb0:	19 fa                	sbb    %edi,%edx
  803cb2:	89 d0                	mov    %edx,%eax
  803cb4:	d3 e0                	shl    %cl,%eax
  803cb6:	89 e9                	mov    %ebp,%ecx
  803cb8:	d3 eb                	shr    %cl,%ebx
  803cba:	d3 ea                	shr    %cl,%edx
  803cbc:	09 d8                	or     %ebx,%eax
  803cbe:	83 c4 1c             	add    $0x1c,%esp
  803cc1:	5b                   	pop    %ebx
  803cc2:	5e                   	pop    %esi
  803cc3:	5f                   	pop    %edi
  803cc4:	5d                   	pop    %ebp
  803cc5:	c3                   	ret    
  803cc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803ccd:	8d 76 00             	lea    0x0(%esi),%esi
  803cd0:	89 da                	mov    %ebx,%edx
  803cd2:	29 fe                	sub    %edi,%esi
  803cd4:	19 c2                	sbb    %eax,%edx
  803cd6:	89 f1                	mov    %esi,%ecx
  803cd8:	89 c8                	mov    %ecx,%eax
  803cda:	e9 4b ff ff ff       	jmp    803c2a <__umoddi3+0x8a>
