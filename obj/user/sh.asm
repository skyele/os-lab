
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
  800065:	68 bd 3c 80 00       	push   $0x803cbd
  80006a:	e8 a8 14 00 00       	call   801517 <strchr>
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
  800090:	68 a0 3c 80 00       	push   $0x803ca0
  800095:	e8 25 0b 00 00       	call   800bbf <cprintf>
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	eb 28                	jmp    8000c7 <_gettoken+0x94>
		cprintf("GETTOKEN: %s\n", s);
  80009f:	83 ec 08             	sub    $0x8,%esp
  8000a2:	53                   	push   %ebx
  8000a3:	68 af 3c 80 00       	push   $0x803caf
  8000a8:	e8 12 0b 00 00       	call   800bbf <cprintf>
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
  8000d4:	68 c2 3c 80 00       	push   $0x803cc2
  8000d9:	e8 e1 0a 00 00       	call   800bbf <cprintf>
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	eb e4                	jmp    8000c7 <_gettoken+0x94>
	if (strchr(SYMBOLS, *s)) {
  8000e3:	83 ec 08             	sub    $0x8,%esp
  8000e6:	0f be c0             	movsbl %al,%eax
  8000e9:	50                   	push   %eax
  8000ea:	68 d3 3c 80 00       	push   $0x803cd3
  8000ef:	e8 23 14 00 00       	call   801517 <strchr>
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
  800118:	68 c7 3c 80 00       	push   $0x803cc7
  80011d:	e8 9d 0a 00 00       	call   800bbf <cprintf>
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
  80013c:	68 cf 3c 80 00       	push   $0x803ccf
  800141:	e8 d1 13 00 00       	call   801517 <strchr>
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
  80016f:	68 db 3c 80 00       	push   $0x803cdb
  800174:	e8 46 0a 00 00       	call   800bbf <cprintf>
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
  800269:	e8 22 26 00 00       	call   802890 <open>
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
  80029a:	e8 fe 33 00 00       	call   80369d <pipe>
  80029f:	83 c4 10             	add    $0x10,%esp
  8002a2:	85 c0                	test   %eax,%eax
  8002a4:	0f 88 41 01 00 00    	js     8003eb <runcmd+0x1f1>
			if (debug)
  8002aa:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8002b1:	0f 85 4f 01 00 00    	jne    800406 <runcmd+0x20c>
			if ((r = fork()) < 0) {
  8002b7:	e8 6e 1a 00 00       	call   801d2a <fork>
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
  8002e3:	e8 cc 1f 00 00       	call   8022b4 <close>
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
  800307:	68 e5 3c 80 00       	push   $0x803ce5
  80030c:	e8 ae 08 00 00       	call   800bbf <cprintf>
				exit();
  800311:	e8 99 07 00 00       	call   800aaf <exit>
  800316:	83 c4 10             	add    $0x10,%esp
  800319:	eb da                	jmp    8002f5 <runcmd+0xfb>
				cprintf("syntax error: < not followed by word\n");
  80031b:	83 ec 0c             	sub    $0xc,%esp
  80031e:	68 38 3e 80 00       	push   $0x803e38
  800323:	e8 97 08 00 00       	call   800bbf <cprintf>
				exit();
  800328:	e8 82 07 00 00       	call   800aaf <exit>
  80032d:	83 c4 10             	add    $0x10,%esp
  800330:	e9 29 ff ff ff       	jmp    80025e <runcmd+0x64>
				cprintf("open %s for read: %e", t, fd);
  800335:	83 ec 04             	sub    $0x4,%esp
  800338:	50                   	push   %eax
  800339:	ff 75 a4             	pushl  -0x5c(%ebp)
  80033c:	68 f9 3c 80 00       	push   $0x803cf9
  800341:	e8 79 08 00 00       	call   800bbf <cprintf>
				exit();
  800346:	e8 64 07 00 00       	call   800aaf <exit>
  80034b:	83 c4 10             	add    $0x10,%esp
				dup(fd, 0);
  80034e:	83 ec 08             	sub    $0x8,%esp
  800351:	6a 00                	push   $0x0
  800353:	53                   	push   %ebx
  800354:	e8 ad 1f 00 00       	call   802306 <dup>
				close(fd);
  800359:	89 1c 24             	mov    %ebx,(%esp)
  80035c:	e8 53 1f 00 00       	call   8022b4 <close>
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
  800387:	e8 04 25 00 00       	call   802890 <open>
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
  8003a3:	68 60 3e 80 00       	push   $0x803e60
  8003a8:	e8 12 08 00 00       	call   800bbf <cprintf>
				exit();
  8003ad:	e8 fd 06 00 00       	call   800aaf <exit>
  8003b2:	83 c4 10             	add    $0x10,%esp
  8003b5:	eb c5                	jmp    80037c <runcmd+0x182>
				cprintf("open %s for write: %e", t, fd);
  8003b7:	83 ec 04             	sub    $0x4,%esp
  8003ba:	50                   	push   %eax
  8003bb:	ff 75 a4             	pushl  -0x5c(%ebp)
  8003be:	68 0e 3d 80 00       	push   $0x803d0e
  8003c3:	e8 f7 07 00 00       	call   800bbf <cprintf>
				exit();
  8003c8:	e8 e2 06 00 00       	call   800aaf <exit>
  8003cd:	83 c4 10             	add    $0x10,%esp
				dup(fd, 1);
  8003d0:	83 ec 08             	sub    $0x8,%esp
  8003d3:	6a 01                	push   $0x1
  8003d5:	53                   	push   %ebx
  8003d6:	e8 2b 1f 00 00       	call   802306 <dup>
				close(fd);
  8003db:	89 1c 24             	mov    %ebx,(%esp)
  8003de:	e8 d1 1e 00 00       	call   8022b4 <close>
  8003e3:	83 c4 10             	add    $0x10,%esp
  8003e6:	e9 30 fe ff ff       	jmp    80021b <runcmd+0x21>
				cprintf("pipe: %e", r);
  8003eb:	83 ec 08             	sub    $0x8,%esp
  8003ee:	50                   	push   %eax
  8003ef:	68 24 3d 80 00       	push   $0x803d24
  8003f4:	e8 c6 07 00 00       	call   800bbf <cprintf>
				exit();
  8003f9:	e8 b1 06 00 00       	call   800aaf <exit>
  8003fe:	83 c4 10             	add    $0x10,%esp
  800401:	e9 a4 fe ff ff       	jmp    8002aa <runcmd+0xb0>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  800406:	83 ec 04             	sub    $0x4,%esp
  800409:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  80040f:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  800415:	68 2d 3d 80 00       	push   $0x803d2d
  80041a:	e8 a0 07 00 00       	call   800bbf <cprintf>
  80041f:	83 c4 10             	add    $0x10,%esp
  800422:	e9 90 fe ff ff       	jmp    8002b7 <runcmd+0xbd>
				cprintf("fork: %e", r);
  800427:	83 ec 08             	sub    $0x8,%esp
  80042a:	50                   	push   %eax
  80042b:	68 3a 3d 80 00       	push   $0x803d3a
  800430:	e8 8a 07 00 00       	call   800bbf <cprintf>
				exit();
  800435:	e8 75 06 00 00       	call   800aaf <exit>
  80043a:	83 c4 10             	add    $0x10,%esp
				if (p[1] != 1) {
  80043d:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  800443:	83 f8 01             	cmp    $0x1,%eax
  800446:	0f 85 cc 00 00 00    	jne    800518 <runcmd+0x31e>
				close(p[0]);
  80044c:	83 ec 0c             	sub    $0xc,%esp
  80044f:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  800455:	e8 5a 1e 00 00       	call   8022b4 <close>
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
  800490:	e8 b4 25 00 00       	call   802a49 <spawn>
  800495:	89 c6                	mov    %eax,%esi
  800497:	83 c4 10             	add    $0x10,%esp
  80049a:	85 c0                	test   %eax,%eax
  80049c:	0f 88 3a 01 00 00    	js     8005dc <runcmd+0x3e2>
	close_all();
  8004a2:	e8 3a 1e 00 00       	call   8022e1 <close_all>
		if (debug)
  8004a7:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8004ae:	0f 85 75 01 00 00    	jne    800629 <runcmd+0x42f>
		wait(r);
  8004b4:	83 ec 0c             	sub    $0xc,%esp
  8004b7:	56                   	push   %esi
  8004b8:	e8 5d 33 00 00       	call   80381a <wait>
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
  8004d5:	e8 40 33 00 00       	call   80381a <wait>
		if (debug)
  8004da:	83 c4 10             	add    $0x10,%esp
  8004dd:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8004e4:	0f 85 79 01 00 00    	jne    800663 <runcmd+0x469>
	exit();
  8004ea:	e8 c0 05 00 00       	call   800aaf <exit>
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
  8004fd:	e8 04 1e 00 00       	call   802306 <dup>
					close(p[0]);
  800502:	83 c4 04             	add    $0x4,%esp
  800505:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  80050b:	e8 a4 1d 00 00       	call   8022b4 <close>
  800510:	83 c4 10             	add    $0x10,%esp
  800513:	e9 c2 fd ff ff       	jmp    8002da <runcmd+0xe0>
					dup(p[1], 1);
  800518:	83 ec 08             	sub    $0x8,%esp
  80051b:	6a 01                	push   $0x1
  80051d:	50                   	push   %eax
  80051e:	e8 e3 1d 00 00       	call   802306 <dup>
					close(p[1]);
  800523:	83 c4 04             	add    $0x4,%esp
  800526:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  80052c:	e8 83 1d 00 00       	call   8022b4 <close>
  800531:	83 c4 10             	add    $0x10,%esp
  800534:	e9 13 ff ff ff       	jmp    80044c <runcmd+0x252>
			panic("bad return %d from gettoken", c);
  800539:	53                   	push   %ebx
  80053a:	68 43 3d 80 00       	push   $0x803d43
  80053f:	6a 78                	push   $0x78
  800541:	68 5f 3d 80 00       	push   $0x803d5f
  800546:	e8 7e 05 00 00       	call   800ac9 <_panic>
		if (debug)
  80054b:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800552:	74 9b                	je     8004ef <runcmd+0x2f5>
			cprintf("EMPTY COMMAND\n");
  800554:	83 ec 0c             	sub    $0xc,%esp
  800557:	68 69 3d 80 00       	push   $0x803d69
  80055c:	e8 5e 06 00 00       	call   800bbf <cprintf>
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
  80057e:	e8 8b 0e 00 00       	call   80140e <strcpy>
		argv[0] = argv0buf;
  800583:	89 75 a8             	mov    %esi,-0x58(%ebp)
  800586:	83 c4 10             	add    $0x10,%esp
  800589:	e9 e3 fe ff ff       	jmp    800471 <runcmd+0x277>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  80058e:	a1 28 64 80 00       	mov    0x806428,%eax
  800593:	8b 40 48             	mov    0x48(%eax),%eax
  800596:	83 ec 08             	sub    $0x8,%esp
  800599:	50                   	push   %eax
  80059a:	68 78 3d 80 00       	push   $0x803d78
  80059f:	e8 1b 06 00 00       	call   800bbf <cprintf>
  8005a4:	8d 75 a8             	lea    -0x58(%ebp),%esi
		for (i = 0; argv[i]; i++)
  8005a7:	83 c4 10             	add    $0x10,%esp
  8005aa:	eb 11                	jmp    8005bd <runcmd+0x3c3>
			cprintf(" %s", argv[i]);
  8005ac:	83 ec 08             	sub    $0x8,%esp
  8005af:	50                   	push   %eax
  8005b0:	68 00 3e 80 00       	push   $0x803e00
  8005b5:	e8 05 06 00 00       	call   800bbf <cprintf>
  8005ba:	83 c4 10             	add    $0x10,%esp
  8005bd:	83 c6 04             	add    $0x4,%esi
		for (i = 0; argv[i]; i++)
  8005c0:	8b 46 fc             	mov    -0x4(%esi),%eax
  8005c3:	85 c0                	test   %eax,%eax
  8005c5:	75 e5                	jne    8005ac <runcmd+0x3b2>
		cprintf("\n");
  8005c7:	83 ec 0c             	sub    $0xc,%esp
  8005ca:	68 c0 3c 80 00       	push   $0x803cc0
  8005cf:	e8 eb 05 00 00       	call   800bbf <cprintf>
  8005d4:	83 c4 10             	add    $0x10,%esp
  8005d7:	e9 aa fe ff ff       	jmp    800486 <runcmd+0x28c>
		cprintf("spawn %s: %e\n", argv[0], r);
  8005dc:	83 ec 04             	sub    $0x4,%esp
  8005df:	50                   	push   %eax
  8005e0:	ff 75 a8             	pushl  -0x58(%ebp)
  8005e3:	68 86 3d 80 00       	push   $0x803d86
  8005e8:	e8 d2 05 00 00       	call   800bbf <cprintf>
	close_all();
  8005ed:	e8 ef 1c 00 00       	call   8022e1 <close_all>
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
  800617:	68 bf 3d 80 00       	push   $0x803dbf
  80061c:	e8 9e 05 00 00       	call   800bbf <cprintf>
  800621:	83 c4 10             	add    $0x10,%esp
  800624:	e9 a8 fe ff ff       	jmp    8004d1 <runcmd+0x2d7>
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  800629:	a1 28 64 80 00       	mov    0x806428,%eax
  80062e:	8b 40 48             	mov    0x48(%eax),%eax
  800631:	56                   	push   %esi
  800632:	ff 75 a8             	pushl  -0x58(%ebp)
  800635:	50                   	push   %eax
  800636:	68 94 3d 80 00       	push   $0x803d94
  80063b:	e8 7f 05 00 00       	call   800bbf <cprintf>
  800640:	83 c4 10             	add    $0x10,%esp
  800643:	e9 6c fe ff ff       	jmp    8004b4 <runcmd+0x2ba>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800648:	a1 28 64 80 00       	mov    0x806428,%eax
  80064d:	8b 40 48             	mov    0x48(%eax),%eax
  800650:	83 ec 08             	sub    $0x8,%esp
  800653:	50                   	push   %eax
  800654:	68 a9 3d 80 00       	push   $0x803da9
  800659:	e8 61 05 00 00       	call   800bbf <cprintf>
  80065e:	83 c4 10             	add    $0x10,%esp
  800661:	eb 92                	jmp    8005f5 <runcmd+0x3fb>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800663:	a1 28 64 80 00       	mov    0x806428,%eax
  800668:	8b 40 48             	mov    0x48(%eax),%eax
  80066b:	83 ec 08             	sub    $0x8,%esp
  80066e:	50                   	push   %eax
  80066f:	68 a9 3d 80 00       	push   $0x803da9
  800674:	e8 46 05 00 00       	call   800bbf <cprintf>
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
  800687:	68 88 3e 80 00       	push   $0x803e88
  80068c:	e8 2e 05 00 00       	call   800bbf <cprintf>
	exit();
  800691:	e8 19 04 00 00       	call   800aaf <exit>
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
  8006af:	e8 08 19 00 00       	call   801fbc <argstart>
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
  8006e1:	e8 06 19 00 00       	call   801fec <argnext>
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
  800716:	bf 04 3e 80 00       	mov    $0x803e04,%edi
  80071b:	b8 00 00 00 00       	mov    $0x0,%eax
  800720:	0f 44 f8             	cmove  %eax,%edi
  800723:	e9 06 01 00 00       	jmp    80082e <umain+0x193>
		usage();
  800728:	e8 54 ff ff ff       	call   800681 <usage>
  80072d:	eb da                	jmp    800709 <umain+0x6e>
		close(0);
  80072f:	83 ec 0c             	sub    $0xc,%esp
  800732:	6a 00                	push   $0x0
  800734:	e8 7b 1b 00 00       	call   8022b4 <close>
		if ((r = open(argv[1], O_RDONLY)) < 0)
  800739:	83 c4 08             	add    $0x8,%esp
  80073c:	6a 00                	push   $0x0
  80073e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800741:	ff 70 04             	pushl  0x4(%eax)
  800744:	e8 47 21 00 00       	call   802890 <open>
  800749:	83 c4 10             	add    $0x10,%esp
  80074c:	85 c0                	test   %eax,%eax
  80074e:	78 1b                	js     80076b <umain+0xd0>
		assert(r == 0);
  800750:	74 bd                	je     80070f <umain+0x74>
  800752:	68 e8 3d 80 00       	push   $0x803de8
  800757:	68 ef 3d 80 00       	push   $0x803def
  80075c:	68 29 01 00 00       	push   $0x129
  800761:	68 5f 3d 80 00       	push   $0x803d5f
  800766:	e8 5e 03 00 00       	call   800ac9 <_panic>
			panic("open %s: %e", argv[1], r);
  80076b:	83 ec 0c             	sub    $0xc,%esp
  80076e:	50                   	push   %eax
  80076f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800772:	ff 70 04             	pushl  0x4(%eax)
  800775:	68 dc 3d 80 00       	push   $0x803ddc
  80077a:	68 28 01 00 00       	push   $0x128
  80077f:	68 5f 3d 80 00       	push   $0x803d5f
  800784:	e8 40 03 00 00       	call   800ac9 <_panic>
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
  8007a6:	e8 04 03 00 00       	call   800aaf <exit>
  8007ab:	e9 94 00 00 00       	jmp    800844 <umain+0x1a9>
				cprintf("EXITING\n");
  8007b0:	83 ec 0c             	sub    $0xc,%esp
  8007b3:	68 07 3e 80 00       	push   $0x803e07
  8007b8:	e8 02 04 00 00       	call   800bbf <cprintf>
  8007bd:	83 c4 10             	add    $0x10,%esp
  8007c0:	eb e4                	jmp    8007a6 <umain+0x10b>
		}
		if (debug)
			cprintf("LINE: %s\n", buf);
  8007c2:	83 ec 08             	sub    $0x8,%esp
  8007c5:	53                   	push   %ebx
  8007c6:	68 10 3e 80 00       	push   $0x803e10
  8007cb:	e8 ef 03 00 00       	call   800bbf <cprintf>
  8007d0:	83 c4 10             	add    $0x10,%esp
  8007d3:	eb 7c                	jmp    800851 <umain+0x1b6>
		if (buf[0] == '#')
			continue;
		if (echocmds)
			printf("# %s\n", buf);
  8007d5:	83 ec 08             	sub    $0x8,%esp
  8007d8:	53                   	push   %ebx
  8007d9:	68 1a 3e 80 00       	push   $0x803e1a
  8007de:	e8 50 22 00 00       	call   802a33 <printf>
  8007e3:	83 c4 10             	add    $0x10,%esp
  8007e6:	eb 78                	jmp    800860 <umain+0x1c5>
		if (debug)
			cprintf("BEFORE FORK\n");
  8007e8:	83 ec 0c             	sub    $0xc,%esp
  8007eb:	68 20 3e 80 00       	push   $0x803e20
  8007f0:	e8 ca 03 00 00       	call   800bbf <cprintf>
  8007f5:	83 c4 10             	add    $0x10,%esp
  8007f8:	eb 73                	jmp    80086d <umain+0x1d2>
		if ((r = fork()) < 0)
			panic("fork: %e", r);
  8007fa:	50                   	push   %eax
  8007fb:	68 3a 3d 80 00       	push   $0x803d3a
  800800:	68 40 01 00 00       	push   $0x140
  800805:	68 5f 3d 80 00       	push   $0x803d5f
  80080a:	e8 ba 02 00 00       	call   800ac9 <_panic>
		if (debug)
			cprintf("FORK: %d\n", r);
  80080f:	83 ec 08             	sub    $0x8,%esp
  800812:	50                   	push   %eax
  800813:	68 2d 3e 80 00       	push   $0x803e2d
  800818:	e8 a2 03 00 00       	call   800bbf <cprintf>
  80081d:	83 c4 10             	add    $0x10,%esp
  800820:	eb 5f                	jmp    800881 <umain+0x1e6>
		if (r == 0) {
			runcmd(buf);
			exit();
		} else
			wait(r);
  800822:	83 ec 0c             	sub    $0xc,%esp
  800825:	56                   	push   %esi
  800826:	e8 ef 2f 00 00       	call   80381a <wait>
  80082b:	83 c4 10             	add    $0x10,%esp
		buf = readline(interactive ? "$ " : NULL);
  80082e:	83 ec 0c             	sub    $0xc,%esp
  800831:	57                   	push   %edi
  800832:	e8 ae 0a 00 00       	call   8012e5 <readline>
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
  80086d:	e8 b8 14 00 00       	call   801d2a <fork>
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
  80088e:	e8 1c 02 00 00       	call   800aaf <exit>
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
  8008a4:	68 a9 3e 80 00       	push   $0x803ea9
  8008a9:	ff 75 0c             	pushl  0xc(%ebp)
  8008ac:	e8 5d 0b 00 00       	call   80140e <strcpy>
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
  8008ef:	e8 a8 0c 00 00       	call   80159c <memmove>
		sys_cputs(buf, m);
  8008f4:	83 c4 08             	add    $0x8,%esp
  8008f7:	53                   	push   %ebx
  8008f8:	57                   	push   %edi
  8008f9:	e8 46 0e 00 00       	call   801744 <sys_cputs>
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
  800920:	e8 3d 0e 00 00       	call   801762 <sys_cgetc>
  800925:	85 c0                	test   %eax,%eax
  800927:	75 07                	jne    800930 <devcons_read+0x21>
		sys_yield();
  800929:	e8 b3 0e 00 00       	call   8017e1 <sys_yield>
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
  80095c:	e8 e3 0d 00 00       	call   801744 <sys_cputs>
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
  800974:	e8 79 1a 00 00       	call   8023f2 <read>
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
  80099c:	e8 e1 17 00 00       	call   802182 <fd_lookup>
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
  8009c5:	e8 66 17 00 00       	call   802130 <fd_alloc>
  8009ca:	83 c4 10             	add    $0x10,%esp
  8009cd:	85 c0                	test   %eax,%eax
  8009cf:	78 3a                	js     800a0b <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8009d1:	83 ec 04             	sub    $0x4,%esp
  8009d4:	68 07 04 00 00       	push   $0x407
  8009d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8009dc:	6a 00                	push   $0x0
  8009de:	e8 1d 0e 00 00       	call   801800 <sys_page_alloc>
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
  800a03:	e8 01 17 00 00       	call   802109 <fd2num>
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
  800a20:	e8 9d 0d 00 00       	call   8017c2 <sys_getenvid>
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

	cprintf("in libmain.c call umain!\n");
  800a84:	83 ec 0c             	sub    $0xc,%esp
  800a87:	68 b5 3e 80 00       	push   $0x803eb5
  800a8c:	e8 2e 01 00 00       	call   800bbf <cprintf>
	// call user main routine
	umain(argc, argv);
  800a91:	83 c4 08             	add    $0x8,%esp
  800a94:	ff 75 0c             	pushl  0xc(%ebp)
  800a97:	ff 75 08             	pushl  0x8(%ebp)
  800a9a:	e8 fc fb ff ff       	call   80069b <umain>

	// exit gracefully
	exit();
  800a9f:	e8 0b 00 00 00       	call   800aaf <exit>
}
  800aa4:	83 c4 10             	add    $0x10,%esp
  800aa7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800aaa:	5b                   	pop    %ebx
  800aab:	5e                   	pop    %esi
  800aac:	5f                   	pop    %edi
  800aad:	5d                   	pop    %ebp
  800aae:	c3                   	ret    

00800aaf <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800aaf:	55                   	push   %ebp
  800ab0:	89 e5                	mov    %esp,%ebp
  800ab2:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800ab5:	e8 27 18 00 00       	call   8022e1 <close_all>
	sys_env_destroy(0);
  800aba:	83 ec 0c             	sub    $0xc,%esp
  800abd:	6a 00                	push   $0x0
  800abf:	e8 bd 0c 00 00       	call   801781 <sys_env_destroy>
}
  800ac4:	83 c4 10             	add    $0x10,%esp
  800ac7:	c9                   	leave  
  800ac8:	c3                   	ret    

00800ac9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800ac9:	55                   	push   %ebp
  800aca:	89 e5                	mov    %esp,%ebp
  800acc:	56                   	push   %esi
  800acd:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800ace:	a1 28 64 80 00       	mov    0x806428,%eax
  800ad3:	8b 40 48             	mov    0x48(%eax),%eax
  800ad6:	83 ec 04             	sub    $0x4,%esp
  800ad9:	68 08 3f 80 00       	push   $0x803f08
  800ade:	50                   	push   %eax
  800adf:	68 d9 3e 80 00       	push   $0x803ed9
  800ae4:	e8 d6 00 00 00       	call   800bbf <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800ae9:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800aec:	8b 35 1c 50 80 00    	mov    0x80501c,%esi
  800af2:	e8 cb 0c 00 00       	call   8017c2 <sys_getenvid>
  800af7:	83 c4 04             	add    $0x4,%esp
  800afa:	ff 75 0c             	pushl  0xc(%ebp)
  800afd:	ff 75 08             	pushl  0x8(%ebp)
  800b00:	56                   	push   %esi
  800b01:	50                   	push   %eax
  800b02:	68 e4 3e 80 00       	push   $0x803ee4
  800b07:	e8 b3 00 00 00       	call   800bbf <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800b0c:	83 c4 18             	add    $0x18,%esp
  800b0f:	53                   	push   %ebx
  800b10:	ff 75 10             	pushl  0x10(%ebp)
  800b13:	e8 56 00 00 00       	call   800b6e <vcprintf>
	cprintf("\n");
  800b18:	c7 04 24 c0 3c 80 00 	movl   $0x803cc0,(%esp)
  800b1f:	e8 9b 00 00 00       	call   800bbf <cprintf>
  800b24:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800b27:	cc                   	int3   
  800b28:	eb fd                	jmp    800b27 <_panic+0x5e>

00800b2a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800b2a:	55                   	push   %ebp
  800b2b:	89 e5                	mov    %esp,%ebp
  800b2d:	53                   	push   %ebx
  800b2e:	83 ec 04             	sub    $0x4,%esp
  800b31:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800b34:	8b 13                	mov    (%ebx),%edx
  800b36:	8d 42 01             	lea    0x1(%edx),%eax
  800b39:	89 03                	mov    %eax,(%ebx)
  800b3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b3e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800b42:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b47:	74 09                	je     800b52 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800b49:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800b4d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b50:	c9                   	leave  
  800b51:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800b52:	83 ec 08             	sub    $0x8,%esp
  800b55:	68 ff 00 00 00       	push   $0xff
  800b5a:	8d 43 08             	lea    0x8(%ebx),%eax
  800b5d:	50                   	push   %eax
  800b5e:	e8 e1 0b 00 00       	call   801744 <sys_cputs>
		b->idx = 0;
  800b63:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800b69:	83 c4 10             	add    $0x10,%esp
  800b6c:	eb db                	jmp    800b49 <putch+0x1f>

00800b6e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800b6e:	55                   	push   %ebp
  800b6f:	89 e5                	mov    %esp,%ebp
  800b71:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b77:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b7e:	00 00 00 
	b.cnt = 0;
  800b81:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b88:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800b8b:	ff 75 0c             	pushl  0xc(%ebp)
  800b8e:	ff 75 08             	pushl  0x8(%ebp)
  800b91:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b97:	50                   	push   %eax
  800b98:	68 2a 0b 80 00       	push   $0x800b2a
  800b9d:	e8 4a 01 00 00       	call   800cec <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800ba2:	83 c4 08             	add    $0x8,%esp
  800ba5:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800bab:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800bb1:	50                   	push   %eax
  800bb2:	e8 8d 0b 00 00       	call   801744 <sys_cputs>

	return b.cnt;
}
  800bb7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800bbd:	c9                   	leave  
  800bbe:	c3                   	ret    

00800bbf <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800bbf:	55                   	push   %ebp
  800bc0:	89 e5                	mov    %esp,%ebp
  800bc2:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bc5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800bc8:	50                   	push   %eax
  800bc9:	ff 75 08             	pushl  0x8(%ebp)
  800bcc:	e8 9d ff ff ff       	call   800b6e <vcprintf>
	va_end(ap);

	return cnt;
}
  800bd1:	c9                   	leave  
  800bd2:	c3                   	ret    

00800bd3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800bd3:	55                   	push   %ebp
  800bd4:	89 e5                	mov    %esp,%ebp
  800bd6:	57                   	push   %edi
  800bd7:	56                   	push   %esi
  800bd8:	53                   	push   %ebx
  800bd9:	83 ec 1c             	sub    $0x1c,%esp
  800bdc:	89 c6                	mov    %eax,%esi
  800bde:	89 d7                	mov    %edx,%edi
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800be6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800be9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800bec:	8b 45 10             	mov    0x10(%ebp),%eax
  800bef:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800bf2:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800bf6:	74 2c                	je     800c24 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800bf8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bfb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800c02:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c05:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800c08:	39 c2                	cmp    %eax,%edx
  800c0a:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800c0d:	73 43                	jae    800c52 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800c0f:	83 eb 01             	sub    $0x1,%ebx
  800c12:	85 db                	test   %ebx,%ebx
  800c14:	7e 6c                	jle    800c82 <printnum+0xaf>
				putch(padc, putdat);
  800c16:	83 ec 08             	sub    $0x8,%esp
  800c19:	57                   	push   %edi
  800c1a:	ff 75 18             	pushl  0x18(%ebp)
  800c1d:	ff d6                	call   *%esi
  800c1f:	83 c4 10             	add    $0x10,%esp
  800c22:	eb eb                	jmp    800c0f <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800c24:	83 ec 0c             	sub    $0xc,%esp
  800c27:	6a 20                	push   $0x20
  800c29:	6a 00                	push   $0x0
  800c2b:	50                   	push   %eax
  800c2c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c2f:	ff 75 e0             	pushl  -0x20(%ebp)
  800c32:	89 fa                	mov    %edi,%edx
  800c34:	89 f0                	mov    %esi,%eax
  800c36:	e8 98 ff ff ff       	call   800bd3 <printnum>
		while (--width > 0)
  800c3b:	83 c4 20             	add    $0x20,%esp
  800c3e:	83 eb 01             	sub    $0x1,%ebx
  800c41:	85 db                	test   %ebx,%ebx
  800c43:	7e 65                	jle    800caa <printnum+0xd7>
			putch(padc, putdat);
  800c45:	83 ec 08             	sub    $0x8,%esp
  800c48:	57                   	push   %edi
  800c49:	6a 20                	push   $0x20
  800c4b:	ff d6                	call   *%esi
  800c4d:	83 c4 10             	add    $0x10,%esp
  800c50:	eb ec                	jmp    800c3e <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800c52:	83 ec 0c             	sub    $0xc,%esp
  800c55:	ff 75 18             	pushl  0x18(%ebp)
  800c58:	83 eb 01             	sub    $0x1,%ebx
  800c5b:	53                   	push   %ebx
  800c5c:	50                   	push   %eax
  800c5d:	83 ec 08             	sub    $0x8,%esp
  800c60:	ff 75 dc             	pushl  -0x24(%ebp)
  800c63:	ff 75 d8             	pushl  -0x28(%ebp)
  800c66:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c69:	ff 75 e0             	pushl  -0x20(%ebp)
  800c6c:	e8 cf 2d 00 00       	call   803a40 <__udivdi3>
  800c71:	83 c4 18             	add    $0x18,%esp
  800c74:	52                   	push   %edx
  800c75:	50                   	push   %eax
  800c76:	89 fa                	mov    %edi,%edx
  800c78:	89 f0                	mov    %esi,%eax
  800c7a:	e8 54 ff ff ff       	call   800bd3 <printnum>
  800c7f:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800c82:	83 ec 08             	sub    $0x8,%esp
  800c85:	57                   	push   %edi
  800c86:	83 ec 04             	sub    $0x4,%esp
  800c89:	ff 75 dc             	pushl  -0x24(%ebp)
  800c8c:	ff 75 d8             	pushl  -0x28(%ebp)
  800c8f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c92:	ff 75 e0             	pushl  -0x20(%ebp)
  800c95:	e8 b6 2e 00 00       	call   803b50 <__umoddi3>
  800c9a:	83 c4 14             	add    $0x14,%esp
  800c9d:	0f be 80 0f 3f 80 00 	movsbl 0x803f0f(%eax),%eax
  800ca4:	50                   	push   %eax
  800ca5:	ff d6                	call   *%esi
  800ca7:	83 c4 10             	add    $0x10,%esp
	}
}
  800caa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cad:	5b                   	pop    %ebx
  800cae:	5e                   	pop    %esi
  800caf:	5f                   	pop    %edi
  800cb0:	5d                   	pop    %ebp
  800cb1:	c3                   	ret    

00800cb2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800cb2:	55                   	push   %ebp
  800cb3:	89 e5                	mov    %esp,%ebp
  800cb5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800cb8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800cbc:	8b 10                	mov    (%eax),%edx
  800cbe:	3b 50 04             	cmp    0x4(%eax),%edx
  800cc1:	73 0a                	jae    800ccd <sprintputch+0x1b>
		*b->buf++ = ch;
  800cc3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cc6:	89 08                	mov    %ecx,(%eax)
  800cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccb:	88 02                	mov    %al,(%edx)
}
  800ccd:	5d                   	pop    %ebp
  800cce:	c3                   	ret    

00800ccf <printfmt>:
{
  800ccf:	55                   	push   %ebp
  800cd0:	89 e5                	mov    %esp,%ebp
  800cd2:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800cd5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800cd8:	50                   	push   %eax
  800cd9:	ff 75 10             	pushl  0x10(%ebp)
  800cdc:	ff 75 0c             	pushl  0xc(%ebp)
  800cdf:	ff 75 08             	pushl  0x8(%ebp)
  800ce2:	e8 05 00 00 00       	call   800cec <vprintfmt>
}
  800ce7:	83 c4 10             	add    $0x10,%esp
  800cea:	c9                   	leave  
  800ceb:	c3                   	ret    

00800cec <vprintfmt>:
{
  800cec:	55                   	push   %ebp
  800ced:	89 e5                	mov    %esp,%ebp
  800cef:	57                   	push   %edi
  800cf0:	56                   	push   %esi
  800cf1:	53                   	push   %ebx
  800cf2:	83 ec 3c             	sub    $0x3c,%esp
  800cf5:	8b 75 08             	mov    0x8(%ebp),%esi
  800cf8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800cfb:	8b 7d 10             	mov    0x10(%ebp),%edi
  800cfe:	e9 32 04 00 00       	jmp    801135 <vprintfmt+0x449>
		padc = ' ';
  800d03:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800d07:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800d0e:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800d15:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800d1c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d23:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800d2a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800d2f:	8d 47 01             	lea    0x1(%edi),%eax
  800d32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d35:	0f b6 17             	movzbl (%edi),%edx
  800d38:	8d 42 dd             	lea    -0x23(%edx),%eax
  800d3b:	3c 55                	cmp    $0x55,%al
  800d3d:	0f 87 12 05 00 00    	ja     801255 <vprintfmt+0x569>
  800d43:	0f b6 c0             	movzbl %al,%eax
  800d46:	ff 24 85 e0 40 80 00 	jmp    *0x8040e0(,%eax,4)
  800d4d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800d50:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800d54:	eb d9                	jmp    800d2f <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800d56:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800d59:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800d5d:	eb d0                	jmp    800d2f <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800d5f:	0f b6 d2             	movzbl %dl,%edx
  800d62:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800d65:	b8 00 00 00 00       	mov    $0x0,%eax
  800d6a:	89 75 08             	mov    %esi,0x8(%ebp)
  800d6d:	eb 03                	jmp    800d72 <vprintfmt+0x86>
  800d6f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800d72:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800d75:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800d79:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800d7c:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d7f:	83 fe 09             	cmp    $0x9,%esi
  800d82:	76 eb                	jbe    800d6f <vprintfmt+0x83>
  800d84:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d87:	8b 75 08             	mov    0x8(%ebp),%esi
  800d8a:	eb 14                	jmp    800da0 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800d8c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d8f:	8b 00                	mov    (%eax),%eax
  800d91:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d94:	8b 45 14             	mov    0x14(%ebp),%eax
  800d97:	8d 40 04             	lea    0x4(%eax),%eax
  800d9a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800d9d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800da0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800da4:	79 89                	jns    800d2f <vprintfmt+0x43>
				width = precision, precision = -1;
  800da6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800da9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800dac:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800db3:	e9 77 ff ff ff       	jmp    800d2f <vprintfmt+0x43>
  800db8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dbb:	85 c0                	test   %eax,%eax
  800dbd:	0f 48 c1             	cmovs  %ecx,%eax
  800dc0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800dc3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800dc6:	e9 64 ff ff ff       	jmp    800d2f <vprintfmt+0x43>
  800dcb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800dce:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800dd5:	e9 55 ff ff ff       	jmp    800d2f <vprintfmt+0x43>
			lflag++;
  800dda:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800dde:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800de1:	e9 49 ff ff ff       	jmp    800d2f <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800de6:	8b 45 14             	mov    0x14(%ebp),%eax
  800de9:	8d 78 04             	lea    0x4(%eax),%edi
  800dec:	83 ec 08             	sub    $0x8,%esp
  800def:	53                   	push   %ebx
  800df0:	ff 30                	pushl  (%eax)
  800df2:	ff d6                	call   *%esi
			break;
  800df4:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800df7:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800dfa:	e9 33 03 00 00       	jmp    801132 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800dff:	8b 45 14             	mov    0x14(%ebp),%eax
  800e02:	8d 78 04             	lea    0x4(%eax),%edi
  800e05:	8b 00                	mov    (%eax),%eax
  800e07:	99                   	cltd   
  800e08:	31 d0                	xor    %edx,%eax
  800e0a:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800e0c:	83 f8 10             	cmp    $0x10,%eax
  800e0f:	7f 23                	jg     800e34 <vprintfmt+0x148>
  800e11:	8b 14 85 40 42 80 00 	mov    0x804240(,%eax,4),%edx
  800e18:	85 d2                	test   %edx,%edx
  800e1a:	74 18                	je     800e34 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800e1c:	52                   	push   %edx
  800e1d:	68 01 3e 80 00       	push   $0x803e01
  800e22:	53                   	push   %ebx
  800e23:	56                   	push   %esi
  800e24:	e8 a6 fe ff ff       	call   800ccf <printfmt>
  800e29:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800e2c:	89 7d 14             	mov    %edi,0x14(%ebp)
  800e2f:	e9 fe 02 00 00       	jmp    801132 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800e34:	50                   	push   %eax
  800e35:	68 27 3f 80 00       	push   $0x803f27
  800e3a:	53                   	push   %ebx
  800e3b:	56                   	push   %esi
  800e3c:	e8 8e fe ff ff       	call   800ccf <printfmt>
  800e41:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800e44:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800e47:	e9 e6 02 00 00       	jmp    801132 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800e4c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e4f:	83 c0 04             	add    $0x4,%eax
  800e52:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800e55:	8b 45 14             	mov    0x14(%ebp),%eax
  800e58:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800e5a:	85 c9                	test   %ecx,%ecx
  800e5c:	b8 20 3f 80 00       	mov    $0x803f20,%eax
  800e61:	0f 45 c1             	cmovne %ecx,%eax
  800e64:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800e67:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e6b:	7e 06                	jle    800e73 <vprintfmt+0x187>
  800e6d:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800e71:	75 0d                	jne    800e80 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e73:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800e76:	89 c7                	mov    %eax,%edi
  800e78:	03 45 e0             	add    -0x20(%ebp),%eax
  800e7b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800e7e:	eb 53                	jmp    800ed3 <vprintfmt+0x1e7>
  800e80:	83 ec 08             	sub    $0x8,%esp
  800e83:	ff 75 d8             	pushl  -0x28(%ebp)
  800e86:	50                   	push   %eax
  800e87:	e8 61 05 00 00       	call   8013ed <strnlen>
  800e8c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800e8f:	29 c1                	sub    %eax,%ecx
  800e91:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800e94:	83 c4 10             	add    $0x10,%esp
  800e97:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800e99:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800e9d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800ea0:	eb 0f                	jmp    800eb1 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800ea2:	83 ec 08             	sub    $0x8,%esp
  800ea5:	53                   	push   %ebx
  800ea6:	ff 75 e0             	pushl  -0x20(%ebp)
  800ea9:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800eab:	83 ef 01             	sub    $0x1,%edi
  800eae:	83 c4 10             	add    $0x10,%esp
  800eb1:	85 ff                	test   %edi,%edi
  800eb3:	7f ed                	jg     800ea2 <vprintfmt+0x1b6>
  800eb5:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800eb8:	85 c9                	test   %ecx,%ecx
  800eba:	b8 00 00 00 00       	mov    $0x0,%eax
  800ebf:	0f 49 c1             	cmovns %ecx,%eax
  800ec2:	29 c1                	sub    %eax,%ecx
  800ec4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800ec7:	eb aa                	jmp    800e73 <vprintfmt+0x187>
					putch(ch, putdat);
  800ec9:	83 ec 08             	sub    $0x8,%esp
  800ecc:	53                   	push   %ebx
  800ecd:	52                   	push   %edx
  800ece:	ff d6                	call   *%esi
  800ed0:	83 c4 10             	add    $0x10,%esp
  800ed3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800ed6:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ed8:	83 c7 01             	add    $0x1,%edi
  800edb:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800edf:	0f be d0             	movsbl %al,%edx
  800ee2:	85 d2                	test   %edx,%edx
  800ee4:	74 4b                	je     800f31 <vprintfmt+0x245>
  800ee6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800eea:	78 06                	js     800ef2 <vprintfmt+0x206>
  800eec:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800ef0:	78 1e                	js     800f10 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800ef2:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800ef6:	74 d1                	je     800ec9 <vprintfmt+0x1dd>
  800ef8:	0f be c0             	movsbl %al,%eax
  800efb:	83 e8 20             	sub    $0x20,%eax
  800efe:	83 f8 5e             	cmp    $0x5e,%eax
  800f01:	76 c6                	jbe    800ec9 <vprintfmt+0x1dd>
					putch('?', putdat);
  800f03:	83 ec 08             	sub    $0x8,%esp
  800f06:	53                   	push   %ebx
  800f07:	6a 3f                	push   $0x3f
  800f09:	ff d6                	call   *%esi
  800f0b:	83 c4 10             	add    $0x10,%esp
  800f0e:	eb c3                	jmp    800ed3 <vprintfmt+0x1e7>
  800f10:	89 cf                	mov    %ecx,%edi
  800f12:	eb 0e                	jmp    800f22 <vprintfmt+0x236>
				putch(' ', putdat);
  800f14:	83 ec 08             	sub    $0x8,%esp
  800f17:	53                   	push   %ebx
  800f18:	6a 20                	push   $0x20
  800f1a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800f1c:	83 ef 01             	sub    $0x1,%edi
  800f1f:	83 c4 10             	add    $0x10,%esp
  800f22:	85 ff                	test   %edi,%edi
  800f24:	7f ee                	jg     800f14 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800f26:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800f29:	89 45 14             	mov    %eax,0x14(%ebp)
  800f2c:	e9 01 02 00 00       	jmp    801132 <vprintfmt+0x446>
  800f31:	89 cf                	mov    %ecx,%edi
  800f33:	eb ed                	jmp    800f22 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800f35:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800f38:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800f3f:	e9 eb fd ff ff       	jmp    800d2f <vprintfmt+0x43>
	if (lflag >= 2)
  800f44:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800f48:	7f 21                	jg     800f6b <vprintfmt+0x27f>
	else if (lflag)
  800f4a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800f4e:	74 68                	je     800fb8 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800f50:	8b 45 14             	mov    0x14(%ebp),%eax
  800f53:	8b 00                	mov    (%eax),%eax
  800f55:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800f58:	89 c1                	mov    %eax,%ecx
  800f5a:	c1 f9 1f             	sar    $0x1f,%ecx
  800f5d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800f60:	8b 45 14             	mov    0x14(%ebp),%eax
  800f63:	8d 40 04             	lea    0x4(%eax),%eax
  800f66:	89 45 14             	mov    %eax,0x14(%ebp)
  800f69:	eb 17                	jmp    800f82 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800f6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6e:	8b 50 04             	mov    0x4(%eax),%edx
  800f71:	8b 00                	mov    (%eax),%eax
  800f73:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800f76:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800f79:	8b 45 14             	mov    0x14(%ebp),%eax
  800f7c:	8d 40 08             	lea    0x8(%eax),%eax
  800f7f:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800f82:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800f85:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800f88:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f8b:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800f8e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800f92:	78 3f                	js     800fd3 <vprintfmt+0x2e7>
			base = 10;
  800f94:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800f99:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800f9d:	0f 84 71 01 00 00    	je     801114 <vprintfmt+0x428>
				putch('+', putdat);
  800fa3:	83 ec 08             	sub    $0x8,%esp
  800fa6:	53                   	push   %ebx
  800fa7:	6a 2b                	push   $0x2b
  800fa9:	ff d6                	call   *%esi
  800fab:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800fae:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fb3:	e9 5c 01 00 00       	jmp    801114 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800fb8:	8b 45 14             	mov    0x14(%ebp),%eax
  800fbb:	8b 00                	mov    (%eax),%eax
  800fbd:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800fc0:	89 c1                	mov    %eax,%ecx
  800fc2:	c1 f9 1f             	sar    $0x1f,%ecx
  800fc5:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800fc8:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcb:	8d 40 04             	lea    0x4(%eax),%eax
  800fce:	89 45 14             	mov    %eax,0x14(%ebp)
  800fd1:	eb af                	jmp    800f82 <vprintfmt+0x296>
				putch('-', putdat);
  800fd3:	83 ec 08             	sub    $0x8,%esp
  800fd6:	53                   	push   %ebx
  800fd7:	6a 2d                	push   $0x2d
  800fd9:	ff d6                	call   *%esi
				num = -(long long) num;
  800fdb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800fde:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800fe1:	f7 d8                	neg    %eax
  800fe3:	83 d2 00             	adc    $0x0,%edx
  800fe6:	f7 da                	neg    %edx
  800fe8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800feb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800fee:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800ff1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ff6:	e9 19 01 00 00       	jmp    801114 <vprintfmt+0x428>
	if (lflag >= 2)
  800ffb:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800fff:	7f 29                	jg     80102a <vprintfmt+0x33e>
	else if (lflag)
  801001:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  801005:	74 44                	je     80104b <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  801007:	8b 45 14             	mov    0x14(%ebp),%eax
  80100a:	8b 00                	mov    (%eax),%eax
  80100c:	ba 00 00 00 00       	mov    $0x0,%edx
  801011:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801014:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801017:	8b 45 14             	mov    0x14(%ebp),%eax
  80101a:	8d 40 04             	lea    0x4(%eax),%eax
  80101d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801020:	b8 0a 00 00 00       	mov    $0xa,%eax
  801025:	e9 ea 00 00 00       	jmp    801114 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80102a:	8b 45 14             	mov    0x14(%ebp),%eax
  80102d:	8b 50 04             	mov    0x4(%eax),%edx
  801030:	8b 00                	mov    (%eax),%eax
  801032:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801035:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801038:	8b 45 14             	mov    0x14(%ebp),%eax
  80103b:	8d 40 08             	lea    0x8(%eax),%eax
  80103e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801041:	b8 0a 00 00 00       	mov    $0xa,%eax
  801046:	e9 c9 00 00 00       	jmp    801114 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80104b:	8b 45 14             	mov    0x14(%ebp),%eax
  80104e:	8b 00                	mov    (%eax),%eax
  801050:	ba 00 00 00 00       	mov    $0x0,%edx
  801055:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801058:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80105b:	8b 45 14             	mov    0x14(%ebp),%eax
  80105e:	8d 40 04             	lea    0x4(%eax),%eax
  801061:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801064:	b8 0a 00 00 00       	mov    $0xa,%eax
  801069:	e9 a6 00 00 00       	jmp    801114 <vprintfmt+0x428>
			putch('0', putdat);
  80106e:	83 ec 08             	sub    $0x8,%esp
  801071:	53                   	push   %ebx
  801072:	6a 30                	push   $0x30
  801074:	ff d6                	call   *%esi
	if (lflag >= 2)
  801076:	83 c4 10             	add    $0x10,%esp
  801079:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80107d:	7f 26                	jg     8010a5 <vprintfmt+0x3b9>
	else if (lflag)
  80107f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  801083:	74 3e                	je     8010c3 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  801085:	8b 45 14             	mov    0x14(%ebp),%eax
  801088:	8b 00                	mov    (%eax),%eax
  80108a:	ba 00 00 00 00       	mov    $0x0,%edx
  80108f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801092:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801095:	8b 45 14             	mov    0x14(%ebp),%eax
  801098:	8d 40 04             	lea    0x4(%eax),%eax
  80109b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80109e:	b8 08 00 00 00       	mov    $0x8,%eax
  8010a3:	eb 6f                	jmp    801114 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8010a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a8:	8b 50 04             	mov    0x4(%eax),%edx
  8010ab:	8b 00                	mov    (%eax),%eax
  8010ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8010b0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8010b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b6:	8d 40 08             	lea    0x8(%eax),%eax
  8010b9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8010bc:	b8 08 00 00 00       	mov    $0x8,%eax
  8010c1:	eb 51                	jmp    801114 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8010c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8010c6:	8b 00                	mov    (%eax),%eax
  8010c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8010cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8010d0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8010d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8010d6:	8d 40 04             	lea    0x4(%eax),%eax
  8010d9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8010dc:	b8 08 00 00 00       	mov    $0x8,%eax
  8010e1:	eb 31                	jmp    801114 <vprintfmt+0x428>
			putch('0', putdat);
  8010e3:	83 ec 08             	sub    $0x8,%esp
  8010e6:	53                   	push   %ebx
  8010e7:	6a 30                	push   $0x30
  8010e9:	ff d6                	call   *%esi
			putch('x', putdat);
  8010eb:	83 c4 08             	add    $0x8,%esp
  8010ee:	53                   	push   %ebx
  8010ef:	6a 78                	push   $0x78
  8010f1:	ff d6                	call   *%esi
			num = (unsigned long long)
  8010f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f6:	8b 00                	mov    (%eax),%eax
  8010f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8010fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801100:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  801103:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801106:	8b 45 14             	mov    0x14(%ebp),%eax
  801109:	8d 40 04             	lea    0x4(%eax),%eax
  80110c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80110f:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801114:	83 ec 0c             	sub    $0xc,%esp
  801117:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80111b:	52                   	push   %edx
  80111c:	ff 75 e0             	pushl  -0x20(%ebp)
  80111f:	50                   	push   %eax
  801120:	ff 75 dc             	pushl  -0x24(%ebp)
  801123:	ff 75 d8             	pushl  -0x28(%ebp)
  801126:	89 da                	mov    %ebx,%edx
  801128:	89 f0                	mov    %esi,%eax
  80112a:	e8 a4 fa ff ff       	call   800bd3 <printnum>
			break;
  80112f:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801132:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801135:	83 c7 01             	add    $0x1,%edi
  801138:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80113c:	83 f8 25             	cmp    $0x25,%eax
  80113f:	0f 84 be fb ff ff    	je     800d03 <vprintfmt+0x17>
			if (ch == '\0')
  801145:	85 c0                	test   %eax,%eax
  801147:	0f 84 28 01 00 00    	je     801275 <vprintfmt+0x589>
			putch(ch, putdat);
  80114d:	83 ec 08             	sub    $0x8,%esp
  801150:	53                   	push   %ebx
  801151:	50                   	push   %eax
  801152:	ff d6                	call   *%esi
  801154:	83 c4 10             	add    $0x10,%esp
  801157:	eb dc                	jmp    801135 <vprintfmt+0x449>
	if (lflag >= 2)
  801159:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80115d:	7f 26                	jg     801185 <vprintfmt+0x499>
	else if (lflag)
  80115f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  801163:	74 41                	je     8011a6 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  801165:	8b 45 14             	mov    0x14(%ebp),%eax
  801168:	8b 00                	mov    (%eax),%eax
  80116a:	ba 00 00 00 00       	mov    $0x0,%edx
  80116f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801172:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801175:	8b 45 14             	mov    0x14(%ebp),%eax
  801178:	8d 40 04             	lea    0x4(%eax),%eax
  80117b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80117e:	b8 10 00 00 00       	mov    $0x10,%eax
  801183:	eb 8f                	jmp    801114 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  801185:	8b 45 14             	mov    0x14(%ebp),%eax
  801188:	8b 50 04             	mov    0x4(%eax),%edx
  80118b:	8b 00                	mov    (%eax),%eax
  80118d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801190:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801193:	8b 45 14             	mov    0x14(%ebp),%eax
  801196:	8d 40 08             	lea    0x8(%eax),%eax
  801199:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80119c:	b8 10 00 00 00       	mov    $0x10,%eax
  8011a1:	e9 6e ff ff ff       	jmp    801114 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8011a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011a9:	8b 00                	mov    (%eax),%eax
  8011ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8011b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8011b3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8011b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011b9:	8d 40 04             	lea    0x4(%eax),%eax
  8011bc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8011bf:	b8 10 00 00 00       	mov    $0x10,%eax
  8011c4:	e9 4b ff ff ff       	jmp    801114 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8011c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8011cc:	83 c0 04             	add    $0x4,%eax
  8011cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8011d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d5:	8b 00                	mov    (%eax),%eax
  8011d7:	85 c0                	test   %eax,%eax
  8011d9:	74 14                	je     8011ef <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8011db:	8b 13                	mov    (%ebx),%edx
  8011dd:	83 fa 7f             	cmp    $0x7f,%edx
  8011e0:	7f 37                	jg     801219 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8011e2:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8011e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8011e7:	89 45 14             	mov    %eax,0x14(%ebp)
  8011ea:	e9 43 ff ff ff       	jmp    801132 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8011ef:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011f4:	bf 45 40 80 00       	mov    $0x804045,%edi
							putch(ch, putdat);
  8011f9:	83 ec 08             	sub    $0x8,%esp
  8011fc:	53                   	push   %ebx
  8011fd:	50                   	push   %eax
  8011fe:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  801200:	83 c7 01             	add    $0x1,%edi
  801203:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  801207:	83 c4 10             	add    $0x10,%esp
  80120a:	85 c0                	test   %eax,%eax
  80120c:	75 eb                	jne    8011f9 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80120e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801211:	89 45 14             	mov    %eax,0x14(%ebp)
  801214:	e9 19 ff ff ff       	jmp    801132 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  801219:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80121b:	b8 0a 00 00 00       	mov    $0xa,%eax
  801220:	bf 7d 40 80 00       	mov    $0x80407d,%edi
							putch(ch, putdat);
  801225:	83 ec 08             	sub    $0x8,%esp
  801228:	53                   	push   %ebx
  801229:	50                   	push   %eax
  80122a:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80122c:	83 c7 01             	add    $0x1,%edi
  80122f:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  801233:	83 c4 10             	add    $0x10,%esp
  801236:	85 c0                	test   %eax,%eax
  801238:	75 eb                	jne    801225 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80123a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80123d:	89 45 14             	mov    %eax,0x14(%ebp)
  801240:	e9 ed fe ff ff       	jmp    801132 <vprintfmt+0x446>
			putch(ch, putdat);
  801245:	83 ec 08             	sub    $0x8,%esp
  801248:	53                   	push   %ebx
  801249:	6a 25                	push   $0x25
  80124b:	ff d6                	call   *%esi
			break;
  80124d:	83 c4 10             	add    $0x10,%esp
  801250:	e9 dd fe ff ff       	jmp    801132 <vprintfmt+0x446>
			putch('%', putdat);
  801255:	83 ec 08             	sub    $0x8,%esp
  801258:	53                   	push   %ebx
  801259:	6a 25                	push   $0x25
  80125b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80125d:	83 c4 10             	add    $0x10,%esp
  801260:	89 f8                	mov    %edi,%eax
  801262:	eb 03                	jmp    801267 <vprintfmt+0x57b>
  801264:	83 e8 01             	sub    $0x1,%eax
  801267:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80126b:	75 f7                	jne    801264 <vprintfmt+0x578>
  80126d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801270:	e9 bd fe ff ff       	jmp    801132 <vprintfmt+0x446>
}
  801275:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801278:	5b                   	pop    %ebx
  801279:	5e                   	pop    %esi
  80127a:	5f                   	pop    %edi
  80127b:	5d                   	pop    %ebp
  80127c:	c3                   	ret    

0080127d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	83 ec 18             	sub    $0x18,%esp
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801289:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80128c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801290:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801293:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80129a:	85 c0                	test   %eax,%eax
  80129c:	74 26                	je     8012c4 <vsnprintf+0x47>
  80129e:	85 d2                	test   %edx,%edx
  8012a0:	7e 22                	jle    8012c4 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8012a2:	ff 75 14             	pushl  0x14(%ebp)
  8012a5:	ff 75 10             	pushl  0x10(%ebp)
  8012a8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8012ab:	50                   	push   %eax
  8012ac:	68 b2 0c 80 00       	push   $0x800cb2
  8012b1:	e8 36 fa ff ff       	call   800cec <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8012b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012b9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8012bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012bf:	83 c4 10             	add    $0x10,%esp
}
  8012c2:	c9                   	leave  
  8012c3:	c3                   	ret    
		return -E_INVAL;
  8012c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012c9:	eb f7                	jmp    8012c2 <vsnprintf+0x45>

008012cb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012cb:	55                   	push   %ebp
  8012cc:	89 e5                	mov    %esp,%ebp
  8012ce:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8012d1:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8012d4:	50                   	push   %eax
  8012d5:	ff 75 10             	pushl  0x10(%ebp)
  8012d8:	ff 75 0c             	pushl  0xc(%ebp)
  8012db:	ff 75 08             	pushl  0x8(%ebp)
  8012de:	e8 9a ff ff ff       	call   80127d <vsnprintf>
	va_end(ap);

	return rc;
}
  8012e3:	c9                   	leave  
  8012e4:	c3                   	ret    

008012e5 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  8012e5:	55                   	push   %ebp
  8012e6:	89 e5                	mov    %esp,%ebp
  8012e8:	57                   	push   %edi
  8012e9:	56                   	push   %esi
  8012ea:	53                   	push   %ebx
  8012eb:	83 ec 0c             	sub    $0xc,%esp
  8012ee:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  8012f1:	85 c0                	test   %eax,%eax
  8012f3:	74 13                	je     801308 <readline+0x23>
		fprintf(1, "%s", prompt);
  8012f5:	83 ec 04             	sub    $0x4,%esp
  8012f8:	50                   	push   %eax
  8012f9:	68 01 3e 80 00       	push   $0x803e01
  8012fe:	6a 01                	push   $0x1
  801300:	e8 17 17 00 00       	call   802a1c <fprintf>
  801305:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
  801308:	83 ec 0c             	sub    $0xc,%esp
  80130b:	6a 00                	push   $0x0
  80130d:	e8 7d f6 ff ff       	call   80098f <iscons>
  801312:	89 c7                	mov    %eax,%edi
  801314:	83 c4 10             	add    $0x10,%esp
	i = 0;
  801317:	be 00 00 00 00       	mov    $0x0,%esi
  80131c:	eb 57                	jmp    801375 <readline+0x90>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  80131e:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
  801323:	83 fb f8             	cmp    $0xfffffff8,%ebx
  801326:	75 08                	jne    801330 <readline+0x4b>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
  801328:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80132b:	5b                   	pop    %ebx
  80132c:	5e                   	pop    %esi
  80132d:	5f                   	pop    %edi
  80132e:	5d                   	pop    %ebp
  80132f:	c3                   	ret    
				cprintf("read error: %e\n", c);
  801330:	83 ec 08             	sub    $0x8,%esp
  801333:	53                   	push   %ebx
  801334:	68 84 42 80 00       	push   $0x804284
  801339:	e8 81 f8 ff ff       	call   800bbf <cprintf>
  80133e:	83 c4 10             	add    $0x10,%esp
			return NULL;
  801341:	b8 00 00 00 00       	mov    $0x0,%eax
  801346:	eb e0                	jmp    801328 <readline+0x43>
			if (echoing)
  801348:	85 ff                	test   %edi,%edi
  80134a:	75 05                	jne    801351 <readline+0x6c>
			i--;
  80134c:	83 ee 01             	sub    $0x1,%esi
  80134f:	eb 24                	jmp    801375 <readline+0x90>
				cputchar('\b');
  801351:	83 ec 0c             	sub    $0xc,%esp
  801354:	6a 08                	push   $0x8
  801356:	e8 ef f5 ff ff       	call   80094a <cputchar>
  80135b:	83 c4 10             	add    $0x10,%esp
  80135e:	eb ec                	jmp    80134c <readline+0x67>
				cputchar(c);
  801360:	83 ec 0c             	sub    $0xc,%esp
  801363:	53                   	push   %ebx
  801364:	e8 e1 f5 ff ff       	call   80094a <cputchar>
  801369:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80136c:	88 9e 20 60 80 00    	mov    %bl,0x806020(%esi)
  801372:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
  801375:	e8 ec f5 ff ff       	call   800966 <getchar>
  80137a:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  80137c:	85 c0                	test   %eax,%eax
  80137e:	78 9e                	js     80131e <readline+0x39>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  801380:	83 f8 08             	cmp    $0x8,%eax
  801383:	0f 94 c2             	sete   %dl
  801386:	83 f8 7f             	cmp    $0x7f,%eax
  801389:	0f 94 c0             	sete   %al
  80138c:	08 c2                	or     %al,%dl
  80138e:	74 04                	je     801394 <readline+0xaf>
  801390:	85 f6                	test   %esi,%esi
  801392:	7f b4                	jg     801348 <readline+0x63>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801394:	83 fb 1f             	cmp    $0x1f,%ebx
  801397:	7e 0e                	jle    8013a7 <readline+0xc2>
  801399:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  80139f:	7f 06                	jg     8013a7 <readline+0xc2>
			if (echoing)
  8013a1:	85 ff                	test   %edi,%edi
  8013a3:	74 c7                	je     80136c <readline+0x87>
  8013a5:	eb b9                	jmp    801360 <readline+0x7b>
		} else if (c == '\n' || c == '\r') {
  8013a7:	83 fb 0a             	cmp    $0xa,%ebx
  8013aa:	74 05                	je     8013b1 <readline+0xcc>
  8013ac:	83 fb 0d             	cmp    $0xd,%ebx
  8013af:	75 c4                	jne    801375 <readline+0x90>
			if (echoing)
  8013b1:	85 ff                	test   %edi,%edi
  8013b3:	75 11                	jne    8013c6 <readline+0xe1>
			buf[i] = 0;
  8013b5:	c6 86 20 60 80 00 00 	movb   $0x0,0x806020(%esi)
			return buf;
  8013bc:	b8 20 60 80 00       	mov    $0x806020,%eax
  8013c1:	e9 62 ff ff ff       	jmp    801328 <readline+0x43>
				cputchar('\n');
  8013c6:	83 ec 0c             	sub    $0xc,%esp
  8013c9:	6a 0a                	push   $0xa
  8013cb:	e8 7a f5 ff ff       	call   80094a <cputchar>
  8013d0:	83 c4 10             	add    $0x10,%esp
  8013d3:	eb e0                	jmp    8013b5 <readline+0xd0>

008013d5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8013d5:	55                   	push   %ebp
  8013d6:	89 e5                	mov    %esp,%ebp
  8013d8:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8013db:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8013e4:	74 05                	je     8013eb <strlen+0x16>
		n++;
  8013e6:	83 c0 01             	add    $0x1,%eax
  8013e9:	eb f5                	jmp    8013e0 <strlen+0xb>
	return n;
}
  8013eb:	5d                   	pop    %ebp
  8013ec:	c3                   	ret    

008013ed <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8013ed:	55                   	push   %ebp
  8013ee:	89 e5                	mov    %esp,%ebp
  8013f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013f3:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8013fb:	39 c2                	cmp    %eax,%edx
  8013fd:	74 0d                	je     80140c <strnlen+0x1f>
  8013ff:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  801403:	74 05                	je     80140a <strnlen+0x1d>
		n++;
  801405:	83 c2 01             	add    $0x1,%edx
  801408:	eb f1                	jmp    8013fb <strnlen+0xe>
  80140a:	89 d0                	mov    %edx,%eax
	return n;
}
  80140c:	5d                   	pop    %ebp
  80140d:	c3                   	ret    

0080140e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80140e:	55                   	push   %ebp
  80140f:	89 e5                	mov    %esp,%ebp
  801411:	53                   	push   %ebx
  801412:	8b 45 08             	mov    0x8(%ebp),%eax
  801415:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801418:	ba 00 00 00 00       	mov    $0x0,%edx
  80141d:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  801421:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  801424:	83 c2 01             	add    $0x1,%edx
  801427:	84 c9                	test   %cl,%cl
  801429:	75 f2                	jne    80141d <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80142b:	5b                   	pop    %ebx
  80142c:	5d                   	pop    %ebp
  80142d:	c3                   	ret    

0080142e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80142e:	55                   	push   %ebp
  80142f:	89 e5                	mov    %esp,%ebp
  801431:	53                   	push   %ebx
  801432:	83 ec 10             	sub    $0x10,%esp
  801435:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801438:	53                   	push   %ebx
  801439:	e8 97 ff ff ff       	call   8013d5 <strlen>
  80143e:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801441:	ff 75 0c             	pushl  0xc(%ebp)
  801444:	01 d8                	add    %ebx,%eax
  801446:	50                   	push   %eax
  801447:	e8 c2 ff ff ff       	call   80140e <strcpy>
	return dst;
}
  80144c:	89 d8                	mov    %ebx,%eax
  80144e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801451:	c9                   	leave  
  801452:	c3                   	ret    

00801453 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801453:	55                   	push   %ebp
  801454:	89 e5                	mov    %esp,%ebp
  801456:	56                   	push   %esi
  801457:	53                   	push   %ebx
  801458:	8b 45 08             	mov    0x8(%ebp),%eax
  80145b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80145e:	89 c6                	mov    %eax,%esi
  801460:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801463:	89 c2                	mov    %eax,%edx
  801465:	39 f2                	cmp    %esi,%edx
  801467:	74 11                	je     80147a <strncpy+0x27>
		*dst++ = *src;
  801469:	83 c2 01             	add    $0x1,%edx
  80146c:	0f b6 19             	movzbl (%ecx),%ebx
  80146f:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801472:	80 fb 01             	cmp    $0x1,%bl
  801475:	83 d9 ff             	sbb    $0xffffffff,%ecx
  801478:	eb eb                	jmp    801465 <strncpy+0x12>
	}
	return ret;
}
  80147a:	5b                   	pop    %ebx
  80147b:	5e                   	pop    %esi
  80147c:	5d                   	pop    %ebp
  80147d:	c3                   	ret    

0080147e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80147e:	55                   	push   %ebp
  80147f:	89 e5                	mov    %esp,%ebp
  801481:	56                   	push   %esi
  801482:	53                   	push   %ebx
  801483:	8b 75 08             	mov    0x8(%ebp),%esi
  801486:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801489:	8b 55 10             	mov    0x10(%ebp),%edx
  80148c:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80148e:	85 d2                	test   %edx,%edx
  801490:	74 21                	je     8014b3 <strlcpy+0x35>
  801492:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801496:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801498:	39 c2                	cmp    %eax,%edx
  80149a:	74 14                	je     8014b0 <strlcpy+0x32>
  80149c:	0f b6 19             	movzbl (%ecx),%ebx
  80149f:	84 db                	test   %bl,%bl
  8014a1:	74 0b                	je     8014ae <strlcpy+0x30>
			*dst++ = *src++;
  8014a3:	83 c1 01             	add    $0x1,%ecx
  8014a6:	83 c2 01             	add    $0x1,%edx
  8014a9:	88 5a ff             	mov    %bl,-0x1(%edx)
  8014ac:	eb ea                	jmp    801498 <strlcpy+0x1a>
  8014ae:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8014b0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8014b3:	29 f0                	sub    %esi,%eax
}
  8014b5:	5b                   	pop    %ebx
  8014b6:	5e                   	pop    %esi
  8014b7:	5d                   	pop    %ebp
  8014b8:	c3                   	ret    

008014b9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014b9:	55                   	push   %ebp
  8014ba:	89 e5                	mov    %esp,%ebp
  8014bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014bf:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8014c2:	0f b6 01             	movzbl (%ecx),%eax
  8014c5:	84 c0                	test   %al,%al
  8014c7:	74 0c                	je     8014d5 <strcmp+0x1c>
  8014c9:	3a 02                	cmp    (%edx),%al
  8014cb:	75 08                	jne    8014d5 <strcmp+0x1c>
		p++, q++;
  8014cd:	83 c1 01             	add    $0x1,%ecx
  8014d0:	83 c2 01             	add    $0x1,%edx
  8014d3:	eb ed                	jmp    8014c2 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014d5:	0f b6 c0             	movzbl %al,%eax
  8014d8:	0f b6 12             	movzbl (%edx),%edx
  8014db:	29 d0                	sub    %edx,%eax
}
  8014dd:	5d                   	pop    %ebp
  8014de:	c3                   	ret    

008014df <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8014df:	55                   	push   %ebp
  8014e0:	89 e5                	mov    %esp,%ebp
  8014e2:	53                   	push   %ebx
  8014e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e9:	89 c3                	mov    %eax,%ebx
  8014eb:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8014ee:	eb 06                	jmp    8014f6 <strncmp+0x17>
		n--, p++, q++;
  8014f0:	83 c0 01             	add    $0x1,%eax
  8014f3:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8014f6:	39 d8                	cmp    %ebx,%eax
  8014f8:	74 16                	je     801510 <strncmp+0x31>
  8014fa:	0f b6 08             	movzbl (%eax),%ecx
  8014fd:	84 c9                	test   %cl,%cl
  8014ff:	74 04                	je     801505 <strncmp+0x26>
  801501:	3a 0a                	cmp    (%edx),%cl
  801503:	74 eb                	je     8014f0 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801505:	0f b6 00             	movzbl (%eax),%eax
  801508:	0f b6 12             	movzbl (%edx),%edx
  80150b:	29 d0                	sub    %edx,%eax
}
  80150d:	5b                   	pop    %ebx
  80150e:	5d                   	pop    %ebp
  80150f:	c3                   	ret    
		return 0;
  801510:	b8 00 00 00 00       	mov    $0x0,%eax
  801515:	eb f6                	jmp    80150d <strncmp+0x2e>

00801517 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801517:	55                   	push   %ebp
  801518:	89 e5                	mov    %esp,%ebp
  80151a:	8b 45 08             	mov    0x8(%ebp),%eax
  80151d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801521:	0f b6 10             	movzbl (%eax),%edx
  801524:	84 d2                	test   %dl,%dl
  801526:	74 09                	je     801531 <strchr+0x1a>
		if (*s == c)
  801528:	38 ca                	cmp    %cl,%dl
  80152a:	74 0a                	je     801536 <strchr+0x1f>
	for (; *s; s++)
  80152c:	83 c0 01             	add    $0x1,%eax
  80152f:	eb f0                	jmp    801521 <strchr+0xa>
			return (char *) s;
	return 0;
  801531:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801536:	5d                   	pop    %ebp
  801537:	c3                   	ret    

00801538 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
  80153b:	8b 45 08             	mov    0x8(%ebp),%eax
  80153e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801542:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801545:	38 ca                	cmp    %cl,%dl
  801547:	74 09                	je     801552 <strfind+0x1a>
  801549:	84 d2                	test   %dl,%dl
  80154b:	74 05                	je     801552 <strfind+0x1a>
	for (; *s; s++)
  80154d:	83 c0 01             	add    $0x1,%eax
  801550:	eb f0                	jmp    801542 <strfind+0xa>
			break;
	return (char *) s;
}
  801552:	5d                   	pop    %ebp
  801553:	c3                   	ret    

00801554 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801554:	55                   	push   %ebp
  801555:	89 e5                	mov    %esp,%ebp
  801557:	57                   	push   %edi
  801558:	56                   	push   %esi
  801559:	53                   	push   %ebx
  80155a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80155d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801560:	85 c9                	test   %ecx,%ecx
  801562:	74 31                	je     801595 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801564:	89 f8                	mov    %edi,%eax
  801566:	09 c8                	or     %ecx,%eax
  801568:	a8 03                	test   $0x3,%al
  80156a:	75 23                	jne    80158f <memset+0x3b>
		c &= 0xFF;
  80156c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801570:	89 d3                	mov    %edx,%ebx
  801572:	c1 e3 08             	shl    $0x8,%ebx
  801575:	89 d0                	mov    %edx,%eax
  801577:	c1 e0 18             	shl    $0x18,%eax
  80157a:	89 d6                	mov    %edx,%esi
  80157c:	c1 e6 10             	shl    $0x10,%esi
  80157f:	09 f0                	or     %esi,%eax
  801581:	09 c2                	or     %eax,%edx
  801583:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801585:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801588:	89 d0                	mov    %edx,%eax
  80158a:	fc                   	cld    
  80158b:	f3 ab                	rep stos %eax,%es:(%edi)
  80158d:	eb 06                	jmp    801595 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80158f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801592:	fc                   	cld    
  801593:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801595:	89 f8                	mov    %edi,%eax
  801597:	5b                   	pop    %ebx
  801598:	5e                   	pop    %esi
  801599:	5f                   	pop    %edi
  80159a:	5d                   	pop    %ebp
  80159b:	c3                   	ret    

0080159c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
  80159f:	57                   	push   %edi
  8015a0:	56                   	push   %esi
  8015a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8015aa:	39 c6                	cmp    %eax,%esi
  8015ac:	73 32                	jae    8015e0 <memmove+0x44>
  8015ae:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8015b1:	39 c2                	cmp    %eax,%edx
  8015b3:	76 2b                	jbe    8015e0 <memmove+0x44>
		s += n;
		d += n;
  8015b5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8015b8:	89 fe                	mov    %edi,%esi
  8015ba:	09 ce                	or     %ecx,%esi
  8015bc:	09 d6                	or     %edx,%esi
  8015be:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8015c4:	75 0e                	jne    8015d4 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8015c6:	83 ef 04             	sub    $0x4,%edi
  8015c9:	8d 72 fc             	lea    -0x4(%edx),%esi
  8015cc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8015cf:	fd                   	std    
  8015d0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8015d2:	eb 09                	jmp    8015dd <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8015d4:	83 ef 01             	sub    $0x1,%edi
  8015d7:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8015da:	fd                   	std    
  8015db:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015dd:	fc                   	cld    
  8015de:	eb 1a                	jmp    8015fa <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8015e0:	89 c2                	mov    %eax,%edx
  8015e2:	09 ca                	or     %ecx,%edx
  8015e4:	09 f2                	or     %esi,%edx
  8015e6:	f6 c2 03             	test   $0x3,%dl
  8015e9:	75 0a                	jne    8015f5 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8015eb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8015ee:	89 c7                	mov    %eax,%edi
  8015f0:	fc                   	cld    
  8015f1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8015f3:	eb 05                	jmp    8015fa <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  8015f5:	89 c7                	mov    %eax,%edi
  8015f7:	fc                   	cld    
  8015f8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8015fa:	5e                   	pop    %esi
  8015fb:	5f                   	pop    %edi
  8015fc:	5d                   	pop    %ebp
  8015fd:	c3                   	ret    

008015fe <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8015fe:	55                   	push   %ebp
  8015ff:	89 e5                	mov    %esp,%ebp
  801601:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801604:	ff 75 10             	pushl  0x10(%ebp)
  801607:	ff 75 0c             	pushl  0xc(%ebp)
  80160a:	ff 75 08             	pushl  0x8(%ebp)
  80160d:	e8 8a ff ff ff       	call   80159c <memmove>
}
  801612:	c9                   	leave  
  801613:	c3                   	ret    

00801614 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
  801617:	56                   	push   %esi
  801618:	53                   	push   %ebx
  801619:	8b 45 08             	mov    0x8(%ebp),%eax
  80161c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161f:	89 c6                	mov    %eax,%esi
  801621:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801624:	39 f0                	cmp    %esi,%eax
  801626:	74 1c                	je     801644 <memcmp+0x30>
		if (*s1 != *s2)
  801628:	0f b6 08             	movzbl (%eax),%ecx
  80162b:	0f b6 1a             	movzbl (%edx),%ebx
  80162e:	38 d9                	cmp    %bl,%cl
  801630:	75 08                	jne    80163a <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801632:	83 c0 01             	add    $0x1,%eax
  801635:	83 c2 01             	add    $0x1,%edx
  801638:	eb ea                	jmp    801624 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  80163a:	0f b6 c1             	movzbl %cl,%eax
  80163d:	0f b6 db             	movzbl %bl,%ebx
  801640:	29 d8                	sub    %ebx,%eax
  801642:	eb 05                	jmp    801649 <memcmp+0x35>
	}

	return 0;
  801644:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801649:	5b                   	pop    %ebx
  80164a:	5e                   	pop    %esi
  80164b:	5d                   	pop    %ebp
  80164c:	c3                   	ret    

0080164d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
  801650:	8b 45 08             	mov    0x8(%ebp),%eax
  801653:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801656:	89 c2                	mov    %eax,%edx
  801658:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80165b:	39 d0                	cmp    %edx,%eax
  80165d:	73 09                	jae    801668 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  80165f:	38 08                	cmp    %cl,(%eax)
  801661:	74 05                	je     801668 <memfind+0x1b>
	for (; s < ends; s++)
  801663:	83 c0 01             	add    $0x1,%eax
  801666:	eb f3                	jmp    80165b <memfind+0xe>
			break;
	return (void *) s;
}
  801668:	5d                   	pop    %ebp
  801669:	c3                   	ret    

0080166a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80166a:	55                   	push   %ebp
  80166b:	89 e5                	mov    %esp,%ebp
  80166d:	57                   	push   %edi
  80166e:	56                   	push   %esi
  80166f:	53                   	push   %ebx
  801670:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801673:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801676:	eb 03                	jmp    80167b <strtol+0x11>
		s++;
  801678:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  80167b:	0f b6 01             	movzbl (%ecx),%eax
  80167e:	3c 20                	cmp    $0x20,%al
  801680:	74 f6                	je     801678 <strtol+0xe>
  801682:	3c 09                	cmp    $0x9,%al
  801684:	74 f2                	je     801678 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801686:	3c 2b                	cmp    $0x2b,%al
  801688:	74 2a                	je     8016b4 <strtol+0x4a>
	int neg = 0;
  80168a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  80168f:	3c 2d                	cmp    $0x2d,%al
  801691:	74 2b                	je     8016be <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801693:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801699:	75 0f                	jne    8016aa <strtol+0x40>
  80169b:	80 39 30             	cmpb   $0x30,(%ecx)
  80169e:	74 28                	je     8016c8 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8016a0:	85 db                	test   %ebx,%ebx
  8016a2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8016a7:	0f 44 d8             	cmove  %eax,%ebx
  8016aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8016af:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8016b2:	eb 50                	jmp    801704 <strtol+0x9a>
		s++;
  8016b4:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8016b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8016bc:	eb d5                	jmp    801693 <strtol+0x29>
		s++, neg = 1;
  8016be:	83 c1 01             	add    $0x1,%ecx
  8016c1:	bf 01 00 00 00       	mov    $0x1,%edi
  8016c6:	eb cb                	jmp    801693 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8016c8:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8016cc:	74 0e                	je     8016dc <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  8016ce:	85 db                	test   %ebx,%ebx
  8016d0:	75 d8                	jne    8016aa <strtol+0x40>
		s++, base = 8;
  8016d2:	83 c1 01             	add    $0x1,%ecx
  8016d5:	bb 08 00 00 00       	mov    $0x8,%ebx
  8016da:	eb ce                	jmp    8016aa <strtol+0x40>
		s += 2, base = 16;
  8016dc:	83 c1 02             	add    $0x2,%ecx
  8016df:	bb 10 00 00 00       	mov    $0x10,%ebx
  8016e4:	eb c4                	jmp    8016aa <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  8016e6:	8d 72 9f             	lea    -0x61(%edx),%esi
  8016e9:	89 f3                	mov    %esi,%ebx
  8016eb:	80 fb 19             	cmp    $0x19,%bl
  8016ee:	77 29                	ja     801719 <strtol+0xaf>
			dig = *s - 'a' + 10;
  8016f0:	0f be d2             	movsbl %dl,%edx
  8016f3:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8016f6:	3b 55 10             	cmp    0x10(%ebp),%edx
  8016f9:	7d 30                	jge    80172b <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  8016fb:	83 c1 01             	add    $0x1,%ecx
  8016fe:	0f af 45 10          	imul   0x10(%ebp),%eax
  801702:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801704:	0f b6 11             	movzbl (%ecx),%edx
  801707:	8d 72 d0             	lea    -0x30(%edx),%esi
  80170a:	89 f3                	mov    %esi,%ebx
  80170c:	80 fb 09             	cmp    $0x9,%bl
  80170f:	77 d5                	ja     8016e6 <strtol+0x7c>
			dig = *s - '0';
  801711:	0f be d2             	movsbl %dl,%edx
  801714:	83 ea 30             	sub    $0x30,%edx
  801717:	eb dd                	jmp    8016f6 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  801719:	8d 72 bf             	lea    -0x41(%edx),%esi
  80171c:	89 f3                	mov    %esi,%ebx
  80171e:	80 fb 19             	cmp    $0x19,%bl
  801721:	77 08                	ja     80172b <strtol+0xc1>
			dig = *s - 'A' + 10;
  801723:	0f be d2             	movsbl %dl,%edx
  801726:	83 ea 37             	sub    $0x37,%edx
  801729:	eb cb                	jmp    8016f6 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  80172b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80172f:	74 05                	je     801736 <strtol+0xcc>
		*endptr = (char *) s;
  801731:	8b 75 0c             	mov    0xc(%ebp),%esi
  801734:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801736:	89 c2                	mov    %eax,%edx
  801738:	f7 da                	neg    %edx
  80173a:	85 ff                	test   %edi,%edi
  80173c:	0f 45 c2             	cmovne %edx,%eax
}
  80173f:	5b                   	pop    %ebx
  801740:	5e                   	pop    %esi
  801741:	5f                   	pop    %edi
  801742:	5d                   	pop    %ebp
  801743:	c3                   	ret    

00801744 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
  801747:	57                   	push   %edi
  801748:	56                   	push   %esi
  801749:	53                   	push   %ebx
	asm volatile("int %1\n"
  80174a:	b8 00 00 00 00       	mov    $0x0,%eax
  80174f:	8b 55 08             	mov    0x8(%ebp),%edx
  801752:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801755:	89 c3                	mov    %eax,%ebx
  801757:	89 c7                	mov    %eax,%edi
  801759:	89 c6                	mov    %eax,%esi
  80175b:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80175d:	5b                   	pop    %ebx
  80175e:	5e                   	pop    %esi
  80175f:	5f                   	pop    %edi
  801760:	5d                   	pop    %ebp
  801761:	c3                   	ret    

00801762 <sys_cgetc>:

int
sys_cgetc(void)
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
  801765:	57                   	push   %edi
  801766:	56                   	push   %esi
  801767:	53                   	push   %ebx
	asm volatile("int %1\n"
  801768:	ba 00 00 00 00       	mov    $0x0,%edx
  80176d:	b8 01 00 00 00       	mov    $0x1,%eax
  801772:	89 d1                	mov    %edx,%ecx
  801774:	89 d3                	mov    %edx,%ebx
  801776:	89 d7                	mov    %edx,%edi
  801778:	89 d6                	mov    %edx,%esi
  80177a:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80177c:	5b                   	pop    %ebx
  80177d:	5e                   	pop    %esi
  80177e:	5f                   	pop    %edi
  80177f:	5d                   	pop    %ebp
  801780:	c3                   	ret    

00801781 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
  801784:	57                   	push   %edi
  801785:	56                   	push   %esi
  801786:	53                   	push   %ebx
  801787:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80178a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80178f:	8b 55 08             	mov    0x8(%ebp),%edx
  801792:	b8 03 00 00 00       	mov    $0x3,%eax
  801797:	89 cb                	mov    %ecx,%ebx
  801799:	89 cf                	mov    %ecx,%edi
  80179b:	89 ce                	mov    %ecx,%esi
  80179d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80179f:	85 c0                	test   %eax,%eax
  8017a1:	7f 08                	jg     8017ab <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8017a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017a6:	5b                   	pop    %ebx
  8017a7:	5e                   	pop    %esi
  8017a8:	5f                   	pop    %edi
  8017a9:	5d                   	pop    %ebp
  8017aa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8017ab:	83 ec 0c             	sub    $0xc,%esp
  8017ae:	50                   	push   %eax
  8017af:	6a 03                	push   $0x3
  8017b1:	68 94 42 80 00       	push   $0x804294
  8017b6:	6a 43                	push   $0x43
  8017b8:	68 b1 42 80 00       	push   $0x8042b1
  8017bd:	e8 07 f3 ff ff       	call   800ac9 <_panic>

008017c2 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
  8017c5:	57                   	push   %edi
  8017c6:	56                   	push   %esi
  8017c7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8017c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8017cd:	b8 02 00 00 00       	mov    $0x2,%eax
  8017d2:	89 d1                	mov    %edx,%ecx
  8017d4:	89 d3                	mov    %edx,%ebx
  8017d6:	89 d7                	mov    %edx,%edi
  8017d8:	89 d6                	mov    %edx,%esi
  8017da:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8017dc:	5b                   	pop    %ebx
  8017dd:	5e                   	pop    %esi
  8017de:	5f                   	pop    %edi
  8017df:	5d                   	pop    %ebp
  8017e0:	c3                   	ret    

008017e1 <sys_yield>:

void
sys_yield(void)
{
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
  8017e4:	57                   	push   %edi
  8017e5:	56                   	push   %esi
  8017e6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8017e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ec:	b8 0b 00 00 00       	mov    $0xb,%eax
  8017f1:	89 d1                	mov    %edx,%ecx
  8017f3:	89 d3                	mov    %edx,%ebx
  8017f5:	89 d7                	mov    %edx,%edi
  8017f7:	89 d6                	mov    %edx,%esi
  8017f9:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8017fb:	5b                   	pop    %ebx
  8017fc:	5e                   	pop    %esi
  8017fd:	5f                   	pop    %edi
  8017fe:	5d                   	pop    %ebp
  8017ff:	c3                   	ret    

00801800 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	57                   	push   %edi
  801804:	56                   	push   %esi
  801805:	53                   	push   %ebx
  801806:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801809:	be 00 00 00 00       	mov    $0x0,%esi
  80180e:	8b 55 08             	mov    0x8(%ebp),%edx
  801811:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801814:	b8 04 00 00 00       	mov    $0x4,%eax
  801819:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80181c:	89 f7                	mov    %esi,%edi
  80181e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801820:	85 c0                	test   %eax,%eax
  801822:	7f 08                	jg     80182c <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801824:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801827:	5b                   	pop    %ebx
  801828:	5e                   	pop    %esi
  801829:	5f                   	pop    %edi
  80182a:	5d                   	pop    %ebp
  80182b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80182c:	83 ec 0c             	sub    $0xc,%esp
  80182f:	50                   	push   %eax
  801830:	6a 04                	push   $0x4
  801832:	68 94 42 80 00       	push   $0x804294
  801837:	6a 43                	push   $0x43
  801839:	68 b1 42 80 00       	push   $0x8042b1
  80183e:	e8 86 f2 ff ff       	call   800ac9 <_panic>

00801843 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	57                   	push   %edi
  801847:	56                   	push   %esi
  801848:	53                   	push   %ebx
  801849:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80184c:	8b 55 08             	mov    0x8(%ebp),%edx
  80184f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801852:	b8 05 00 00 00       	mov    $0x5,%eax
  801857:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80185a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80185d:	8b 75 18             	mov    0x18(%ebp),%esi
  801860:	cd 30                	int    $0x30
	if(check && ret > 0)
  801862:	85 c0                	test   %eax,%eax
  801864:	7f 08                	jg     80186e <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801866:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801869:	5b                   	pop    %ebx
  80186a:	5e                   	pop    %esi
  80186b:	5f                   	pop    %edi
  80186c:	5d                   	pop    %ebp
  80186d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80186e:	83 ec 0c             	sub    $0xc,%esp
  801871:	50                   	push   %eax
  801872:	6a 05                	push   $0x5
  801874:	68 94 42 80 00       	push   $0x804294
  801879:	6a 43                	push   $0x43
  80187b:	68 b1 42 80 00       	push   $0x8042b1
  801880:	e8 44 f2 ff ff       	call   800ac9 <_panic>

00801885 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
  801888:	57                   	push   %edi
  801889:	56                   	push   %esi
  80188a:	53                   	push   %ebx
  80188b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80188e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801893:	8b 55 08             	mov    0x8(%ebp),%edx
  801896:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801899:	b8 06 00 00 00       	mov    $0x6,%eax
  80189e:	89 df                	mov    %ebx,%edi
  8018a0:	89 de                	mov    %ebx,%esi
  8018a2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8018a4:	85 c0                	test   %eax,%eax
  8018a6:	7f 08                	jg     8018b0 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8018a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018ab:	5b                   	pop    %ebx
  8018ac:	5e                   	pop    %esi
  8018ad:	5f                   	pop    %edi
  8018ae:	5d                   	pop    %ebp
  8018af:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8018b0:	83 ec 0c             	sub    $0xc,%esp
  8018b3:	50                   	push   %eax
  8018b4:	6a 06                	push   $0x6
  8018b6:	68 94 42 80 00       	push   $0x804294
  8018bb:	6a 43                	push   $0x43
  8018bd:	68 b1 42 80 00       	push   $0x8042b1
  8018c2:	e8 02 f2 ff ff       	call   800ac9 <_panic>

008018c7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
  8018ca:	57                   	push   %edi
  8018cb:	56                   	push   %esi
  8018cc:	53                   	push   %ebx
  8018cd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8018d0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8018d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018db:	b8 08 00 00 00       	mov    $0x8,%eax
  8018e0:	89 df                	mov    %ebx,%edi
  8018e2:	89 de                	mov    %ebx,%esi
  8018e4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8018e6:	85 c0                	test   %eax,%eax
  8018e8:	7f 08                	jg     8018f2 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8018ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018ed:	5b                   	pop    %ebx
  8018ee:	5e                   	pop    %esi
  8018ef:	5f                   	pop    %edi
  8018f0:	5d                   	pop    %ebp
  8018f1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8018f2:	83 ec 0c             	sub    $0xc,%esp
  8018f5:	50                   	push   %eax
  8018f6:	6a 08                	push   $0x8
  8018f8:	68 94 42 80 00       	push   $0x804294
  8018fd:	6a 43                	push   $0x43
  8018ff:	68 b1 42 80 00       	push   $0x8042b1
  801904:	e8 c0 f1 ff ff       	call   800ac9 <_panic>

00801909 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
  80190c:	57                   	push   %edi
  80190d:	56                   	push   %esi
  80190e:	53                   	push   %ebx
  80190f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801912:	bb 00 00 00 00       	mov    $0x0,%ebx
  801917:	8b 55 08             	mov    0x8(%ebp),%edx
  80191a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80191d:	b8 09 00 00 00       	mov    $0x9,%eax
  801922:	89 df                	mov    %ebx,%edi
  801924:	89 de                	mov    %ebx,%esi
  801926:	cd 30                	int    $0x30
	if(check && ret > 0)
  801928:	85 c0                	test   %eax,%eax
  80192a:	7f 08                	jg     801934 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80192c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80192f:	5b                   	pop    %ebx
  801930:	5e                   	pop    %esi
  801931:	5f                   	pop    %edi
  801932:	5d                   	pop    %ebp
  801933:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801934:	83 ec 0c             	sub    $0xc,%esp
  801937:	50                   	push   %eax
  801938:	6a 09                	push   $0x9
  80193a:	68 94 42 80 00       	push   $0x804294
  80193f:	6a 43                	push   $0x43
  801941:	68 b1 42 80 00       	push   $0x8042b1
  801946:	e8 7e f1 ff ff       	call   800ac9 <_panic>

0080194b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
  80194e:	57                   	push   %edi
  80194f:	56                   	push   %esi
  801950:	53                   	push   %ebx
  801951:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801954:	bb 00 00 00 00       	mov    $0x0,%ebx
  801959:	8b 55 08             	mov    0x8(%ebp),%edx
  80195c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80195f:	b8 0a 00 00 00       	mov    $0xa,%eax
  801964:	89 df                	mov    %ebx,%edi
  801966:	89 de                	mov    %ebx,%esi
  801968:	cd 30                	int    $0x30
	if(check && ret > 0)
  80196a:	85 c0                	test   %eax,%eax
  80196c:	7f 08                	jg     801976 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80196e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801971:	5b                   	pop    %ebx
  801972:	5e                   	pop    %esi
  801973:	5f                   	pop    %edi
  801974:	5d                   	pop    %ebp
  801975:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801976:	83 ec 0c             	sub    $0xc,%esp
  801979:	50                   	push   %eax
  80197a:	6a 0a                	push   $0xa
  80197c:	68 94 42 80 00       	push   $0x804294
  801981:	6a 43                	push   $0x43
  801983:	68 b1 42 80 00       	push   $0x8042b1
  801988:	e8 3c f1 ff ff       	call   800ac9 <_panic>

0080198d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
  801990:	57                   	push   %edi
  801991:	56                   	push   %esi
  801992:	53                   	push   %ebx
	asm volatile("int %1\n"
  801993:	8b 55 08             	mov    0x8(%ebp),%edx
  801996:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801999:	b8 0c 00 00 00       	mov    $0xc,%eax
  80199e:	be 00 00 00 00       	mov    $0x0,%esi
  8019a3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8019a6:	8b 7d 14             	mov    0x14(%ebp),%edi
  8019a9:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8019ab:	5b                   	pop    %ebx
  8019ac:	5e                   	pop    %esi
  8019ad:	5f                   	pop    %edi
  8019ae:	5d                   	pop    %ebp
  8019af:	c3                   	ret    

008019b0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
  8019b3:	57                   	push   %edi
  8019b4:	56                   	push   %esi
  8019b5:	53                   	push   %ebx
  8019b6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8019b9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019be:	8b 55 08             	mov    0x8(%ebp),%edx
  8019c1:	b8 0d 00 00 00       	mov    $0xd,%eax
  8019c6:	89 cb                	mov    %ecx,%ebx
  8019c8:	89 cf                	mov    %ecx,%edi
  8019ca:	89 ce                	mov    %ecx,%esi
  8019cc:	cd 30                	int    $0x30
	if(check && ret > 0)
  8019ce:	85 c0                	test   %eax,%eax
  8019d0:	7f 08                	jg     8019da <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8019d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019d5:	5b                   	pop    %ebx
  8019d6:	5e                   	pop    %esi
  8019d7:	5f                   	pop    %edi
  8019d8:	5d                   	pop    %ebp
  8019d9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8019da:	83 ec 0c             	sub    $0xc,%esp
  8019dd:	50                   	push   %eax
  8019de:	6a 0d                	push   $0xd
  8019e0:	68 94 42 80 00       	push   $0x804294
  8019e5:	6a 43                	push   $0x43
  8019e7:	68 b1 42 80 00       	push   $0x8042b1
  8019ec:	e8 d8 f0 ff ff       	call   800ac9 <_panic>

008019f1 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
  8019f4:	57                   	push   %edi
  8019f5:	56                   	push   %esi
  8019f6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8019f7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8019ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a02:	b8 0e 00 00 00       	mov    $0xe,%eax
  801a07:	89 df                	mov    %ebx,%edi
  801a09:	89 de                	mov    %ebx,%esi
  801a0b:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801a0d:	5b                   	pop    %ebx
  801a0e:	5e                   	pop    %esi
  801a0f:	5f                   	pop    %edi
  801a10:	5d                   	pop    %ebp
  801a11:	c3                   	ret    

00801a12 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
  801a15:	57                   	push   %edi
  801a16:	56                   	push   %esi
  801a17:	53                   	push   %ebx
	asm volatile("int %1\n"
  801a18:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a1d:	8b 55 08             	mov    0x8(%ebp),%edx
  801a20:	b8 0f 00 00 00       	mov    $0xf,%eax
  801a25:	89 cb                	mov    %ecx,%ebx
  801a27:	89 cf                	mov    %ecx,%edi
  801a29:	89 ce                	mov    %ecx,%esi
  801a2b:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801a2d:	5b                   	pop    %ebx
  801a2e:	5e                   	pop    %esi
  801a2f:	5f                   	pop    %edi
  801a30:	5d                   	pop    %ebp
  801a31:	c3                   	ret    

00801a32 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
  801a35:	57                   	push   %edi
  801a36:	56                   	push   %esi
  801a37:	53                   	push   %ebx
	asm volatile("int %1\n"
  801a38:	ba 00 00 00 00       	mov    $0x0,%edx
  801a3d:	b8 10 00 00 00       	mov    $0x10,%eax
  801a42:	89 d1                	mov    %edx,%ecx
  801a44:	89 d3                	mov    %edx,%ebx
  801a46:	89 d7                	mov    %edx,%edi
  801a48:	89 d6                	mov    %edx,%esi
  801a4a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801a4c:	5b                   	pop    %ebx
  801a4d:	5e                   	pop    %esi
  801a4e:	5f                   	pop    %edi
  801a4f:	5d                   	pop    %ebp
  801a50:	c3                   	ret    

00801a51 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
  801a54:	57                   	push   %edi
  801a55:	56                   	push   %esi
  801a56:	53                   	push   %ebx
	asm volatile("int %1\n"
  801a57:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a5c:	8b 55 08             	mov    0x8(%ebp),%edx
  801a5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a62:	b8 11 00 00 00       	mov    $0x11,%eax
  801a67:	89 df                	mov    %ebx,%edi
  801a69:	89 de                	mov    %ebx,%esi
  801a6b:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801a6d:	5b                   	pop    %ebx
  801a6e:	5e                   	pop    %esi
  801a6f:	5f                   	pop    %edi
  801a70:	5d                   	pop    %ebp
  801a71:	c3                   	ret    

00801a72 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
  801a75:	57                   	push   %edi
  801a76:	56                   	push   %esi
  801a77:	53                   	push   %ebx
	asm volatile("int %1\n"
  801a78:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a7d:	8b 55 08             	mov    0x8(%ebp),%edx
  801a80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a83:	b8 12 00 00 00       	mov    $0x12,%eax
  801a88:	89 df                	mov    %ebx,%edi
  801a8a:	89 de                	mov    %ebx,%esi
  801a8c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801a8e:	5b                   	pop    %ebx
  801a8f:	5e                   	pop    %esi
  801a90:	5f                   	pop    %edi
  801a91:	5d                   	pop    %ebp
  801a92:	c3                   	ret    

00801a93 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
  801a96:	57                   	push   %edi
  801a97:	56                   	push   %esi
  801a98:	53                   	push   %ebx
  801a99:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801a9c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801aa1:	8b 55 08             	mov    0x8(%ebp),%edx
  801aa4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801aa7:	b8 13 00 00 00       	mov    $0x13,%eax
  801aac:	89 df                	mov    %ebx,%edi
  801aae:	89 de                	mov    %ebx,%esi
  801ab0:	cd 30                	int    $0x30
	if(check && ret > 0)
  801ab2:	85 c0                	test   %eax,%eax
  801ab4:	7f 08                	jg     801abe <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801ab6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ab9:	5b                   	pop    %ebx
  801aba:	5e                   	pop    %esi
  801abb:	5f                   	pop    %edi
  801abc:	5d                   	pop    %ebp
  801abd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801abe:	83 ec 0c             	sub    $0xc,%esp
  801ac1:	50                   	push   %eax
  801ac2:	6a 13                	push   $0x13
  801ac4:	68 94 42 80 00       	push   $0x804294
  801ac9:	6a 43                	push   $0x43
  801acb:	68 b1 42 80 00       	push   $0x8042b1
  801ad0:	e8 f4 ef ff ff       	call   800ac9 <_panic>

00801ad5 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
  801ad8:	53                   	push   %ebx
  801ad9:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801adc:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801ae3:	f6 c5 04             	test   $0x4,%ch
  801ae6:	75 45                	jne    801b2d <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801ae8:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801aef:	83 e1 07             	and    $0x7,%ecx
  801af2:	83 f9 07             	cmp    $0x7,%ecx
  801af5:	74 6f                	je     801b66 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801af7:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801afe:	81 e1 05 08 00 00    	and    $0x805,%ecx
  801b04:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801b0a:	0f 84 b6 00 00 00    	je     801bc6 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801b10:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801b17:	83 e1 05             	and    $0x5,%ecx
  801b1a:	83 f9 05             	cmp    $0x5,%ecx
  801b1d:	0f 84 d7 00 00 00    	je     801bfa <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801b23:	b8 00 00 00 00       	mov    $0x0,%eax
  801b28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b2b:	c9                   	leave  
  801b2c:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801b2d:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801b34:	c1 e2 0c             	shl    $0xc,%edx
  801b37:	83 ec 0c             	sub    $0xc,%esp
  801b3a:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801b40:	51                   	push   %ecx
  801b41:	52                   	push   %edx
  801b42:	50                   	push   %eax
  801b43:	52                   	push   %edx
  801b44:	6a 00                	push   $0x0
  801b46:	e8 f8 fc ff ff       	call   801843 <sys_page_map>
		if(r < 0)
  801b4b:	83 c4 20             	add    $0x20,%esp
  801b4e:	85 c0                	test   %eax,%eax
  801b50:	79 d1                	jns    801b23 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801b52:	83 ec 04             	sub    $0x4,%esp
  801b55:	68 bf 42 80 00       	push   $0x8042bf
  801b5a:	6a 54                	push   $0x54
  801b5c:	68 d5 42 80 00       	push   $0x8042d5
  801b61:	e8 63 ef ff ff       	call   800ac9 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801b66:	89 d3                	mov    %edx,%ebx
  801b68:	c1 e3 0c             	shl    $0xc,%ebx
  801b6b:	83 ec 0c             	sub    $0xc,%esp
  801b6e:	68 05 08 00 00       	push   $0x805
  801b73:	53                   	push   %ebx
  801b74:	50                   	push   %eax
  801b75:	53                   	push   %ebx
  801b76:	6a 00                	push   $0x0
  801b78:	e8 c6 fc ff ff       	call   801843 <sys_page_map>
		if(r < 0)
  801b7d:	83 c4 20             	add    $0x20,%esp
  801b80:	85 c0                	test   %eax,%eax
  801b82:	78 2e                	js     801bb2 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801b84:	83 ec 0c             	sub    $0xc,%esp
  801b87:	68 05 08 00 00       	push   $0x805
  801b8c:	53                   	push   %ebx
  801b8d:	6a 00                	push   $0x0
  801b8f:	53                   	push   %ebx
  801b90:	6a 00                	push   $0x0
  801b92:	e8 ac fc ff ff       	call   801843 <sys_page_map>
		if(r < 0)
  801b97:	83 c4 20             	add    $0x20,%esp
  801b9a:	85 c0                	test   %eax,%eax
  801b9c:	79 85                	jns    801b23 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801b9e:	83 ec 04             	sub    $0x4,%esp
  801ba1:	68 bf 42 80 00       	push   $0x8042bf
  801ba6:	6a 5f                	push   $0x5f
  801ba8:	68 d5 42 80 00       	push   $0x8042d5
  801bad:	e8 17 ef ff ff       	call   800ac9 <_panic>
			panic("sys_page_map() panic\n");
  801bb2:	83 ec 04             	sub    $0x4,%esp
  801bb5:	68 bf 42 80 00       	push   $0x8042bf
  801bba:	6a 5b                	push   $0x5b
  801bbc:	68 d5 42 80 00       	push   $0x8042d5
  801bc1:	e8 03 ef ff ff       	call   800ac9 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801bc6:	c1 e2 0c             	shl    $0xc,%edx
  801bc9:	83 ec 0c             	sub    $0xc,%esp
  801bcc:	68 05 08 00 00       	push   $0x805
  801bd1:	52                   	push   %edx
  801bd2:	50                   	push   %eax
  801bd3:	52                   	push   %edx
  801bd4:	6a 00                	push   $0x0
  801bd6:	e8 68 fc ff ff       	call   801843 <sys_page_map>
		if(r < 0)
  801bdb:	83 c4 20             	add    $0x20,%esp
  801bde:	85 c0                	test   %eax,%eax
  801be0:	0f 89 3d ff ff ff    	jns    801b23 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801be6:	83 ec 04             	sub    $0x4,%esp
  801be9:	68 bf 42 80 00       	push   $0x8042bf
  801bee:	6a 66                	push   $0x66
  801bf0:	68 d5 42 80 00       	push   $0x8042d5
  801bf5:	e8 cf ee ff ff       	call   800ac9 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801bfa:	c1 e2 0c             	shl    $0xc,%edx
  801bfd:	83 ec 0c             	sub    $0xc,%esp
  801c00:	6a 05                	push   $0x5
  801c02:	52                   	push   %edx
  801c03:	50                   	push   %eax
  801c04:	52                   	push   %edx
  801c05:	6a 00                	push   $0x0
  801c07:	e8 37 fc ff ff       	call   801843 <sys_page_map>
		if(r < 0)
  801c0c:	83 c4 20             	add    $0x20,%esp
  801c0f:	85 c0                	test   %eax,%eax
  801c11:	0f 89 0c ff ff ff    	jns    801b23 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801c17:	83 ec 04             	sub    $0x4,%esp
  801c1a:	68 bf 42 80 00       	push   $0x8042bf
  801c1f:	6a 6d                	push   $0x6d
  801c21:	68 d5 42 80 00       	push   $0x8042d5
  801c26:	e8 9e ee ff ff       	call   800ac9 <_panic>

00801c2b <pgfault>:
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
  801c2e:	53                   	push   %ebx
  801c2f:	83 ec 04             	sub    $0x4,%esp
  801c32:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801c35:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801c37:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801c3b:	0f 84 99 00 00 00    	je     801cda <pgfault+0xaf>
  801c41:	89 c2                	mov    %eax,%edx
  801c43:	c1 ea 16             	shr    $0x16,%edx
  801c46:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801c4d:	f6 c2 01             	test   $0x1,%dl
  801c50:	0f 84 84 00 00 00    	je     801cda <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801c56:	89 c2                	mov    %eax,%edx
  801c58:	c1 ea 0c             	shr    $0xc,%edx
  801c5b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801c62:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801c68:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801c6e:	75 6a                	jne    801cda <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801c70:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c75:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801c77:	83 ec 04             	sub    $0x4,%esp
  801c7a:	6a 07                	push   $0x7
  801c7c:	68 00 f0 7f 00       	push   $0x7ff000
  801c81:	6a 00                	push   $0x0
  801c83:	e8 78 fb ff ff       	call   801800 <sys_page_alloc>
	if(ret < 0)
  801c88:	83 c4 10             	add    $0x10,%esp
  801c8b:	85 c0                	test   %eax,%eax
  801c8d:	78 5f                	js     801cee <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801c8f:	83 ec 04             	sub    $0x4,%esp
  801c92:	68 00 10 00 00       	push   $0x1000
  801c97:	53                   	push   %ebx
  801c98:	68 00 f0 7f 00       	push   $0x7ff000
  801c9d:	e8 5c f9 ff ff       	call   8015fe <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801ca2:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801ca9:	53                   	push   %ebx
  801caa:	6a 00                	push   $0x0
  801cac:	68 00 f0 7f 00       	push   $0x7ff000
  801cb1:	6a 00                	push   $0x0
  801cb3:	e8 8b fb ff ff       	call   801843 <sys_page_map>
	if(ret < 0)
  801cb8:	83 c4 20             	add    $0x20,%esp
  801cbb:	85 c0                	test   %eax,%eax
  801cbd:	78 43                	js     801d02 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801cbf:	83 ec 08             	sub    $0x8,%esp
  801cc2:	68 00 f0 7f 00       	push   $0x7ff000
  801cc7:	6a 00                	push   $0x0
  801cc9:	e8 b7 fb ff ff       	call   801885 <sys_page_unmap>
	if(ret < 0)
  801cce:	83 c4 10             	add    $0x10,%esp
  801cd1:	85 c0                	test   %eax,%eax
  801cd3:	78 41                	js     801d16 <pgfault+0xeb>
}
  801cd5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    
		panic("panic at pgfault()\n");
  801cda:	83 ec 04             	sub    $0x4,%esp
  801cdd:	68 e0 42 80 00       	push   $0x8042e0
  801ce2:	6a 26                	push   $0x26
  801ce4:	68 d5 42 80 00       	push   $0x8042d5
  801ce9:	e8 db ed ff ff       	call   800ac9 <_panic>
		panic("panic in sys_page_alloc()\n");
  801cee:	83 ec 04             	sub    $0x4,%esp
  801cf1:	68 f4 42 80 00       	push   $0x8042f4
  801cf6:	6a 31                	push   $0x31
  801cf8:	68 d5 42 80 00       	push   $0x8042d5
  801cfd:	e8 c7 ed ff ff       	call   800ac9 <_panic>
		panic("panic in sys_page_map()\n");
  801d02:	83 ec 04             	sub    $0x4,%esp
  801d05:	68 0f 43 80 00       	push   $0x80430f
  801d0a:	6a 36                	push   $0x36
  801d0c:	68 d5 42 80 00       	push   $0x8042d5
  801d11:	e8 b3 ed ff ff       	call   800ac9 <_panic>
		panic("panic in sys_page_unmap()\n");
  801d16:	83 ec 04             	sub    $0x4,%esp
  801d19:	68 28 43 80 00       	push   $0x804328
  801d1e:	6a 39                	push   $0x39
  801d20:	68 d5 42 80 00       	push   $0x8042d5
  801d25:	e8 9f ed ff ff       	call   800ac9 <_panic>

00801d2a <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
  801d2d:	57                   	push   %edi
  801d2e:	56                   	push   %esi
  801d2f:	53                   	push   %ebx
  801d30:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801d33:	68 2b 1c 80 00       	push   $0x801c2b
  801d38:	e8 2c 1b 00 00       	call   803869 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801d3d:	b8 07 00 00 00       	mov    $0x7,%eax
  801d42:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801d44:	83 c4 10             	add    $0x10,%esp
  801d47:	85 c0                	test   %eax,%eax
  801d49:	78 27                	js     801d72 <fork+0x48>
  801d4b:	89 c6                	mov    %eax,%esi
  801d4d:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801d4f:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801d54:	75 48                	jne    801d9e <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  801d56:	e8 67 fa ff ff       	call   8017c2 <sys_getenvid>
  801d5b:	25 ff 03 00 00       	and    $0x3ff,%eax
  801d60:	c1 e0 07             	shl    $0x7,%eax
  801d63:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801d68:	a3 28 64 80 00       	mov    %eax,0x806428
		return 0;
  801d6d:	e9 90 00 00 00       	jmp    801e02 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  801d72:	83 ec 04             	sub    $0x4,%esp
  801d75:	68 44 43 80 00       	push   $0x804344
  801d7a:	68 8c 00 00 00       	push   $0x8c
  801d7f:	68 d5 42 80 00       	push   $0x8042d5
  801d84:	e8 40 ed ff ff       	call   800ac9 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801d89:	89 f8                	mov    %edi,%eax
  801d8b:	e8 45 fd ff ff       	call   801ad5 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801d90:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801d96:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801d9c:	74 26                	je     801dc4 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801d9e:	89 d8                	mov    %ebx,%eax
  801da0:	c1 e8 16             	shr    $0x16,%eax
  801da3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801daa:	a8 01                	test   $0x1,%al
  801dac:	74 e2                	je     801d90 <fork+0x66>
  801dae:	89 da                	mov    %ebx,%edx
  801db0:	c1 ea 0c             	shr    $0xc,%edx
  801db3:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801dba:	83 e0 05             	and    $0x5,%eax
  801dbd:	83 f8 05             	cmp    $0x5,%eax
  801dc0:	75 ce                	jne    801d90 <fork+0x66>
  801dc2:	eb c5                	jmp    801d89 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801dc4:	83 ec 04             	sub    $0x4,%esp
  801dc7:	6a 07                	push   $0x7
  801dc9:	68 00 f0 bf ee       	push   $0xeebff000
  801dce:	56                   	push   %esi
  801dcf:	e8 2c fa ff ff       	call   801800 <sys_page_alloc>
	if(ret < 0)
  801dd4:	83 c4 10             	add    $0x10,%esp
  801dd7:	85 c0                	test   %eax,%eax
  801dd9:	78 31                	js     801e0c <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801ddb:	83 ec 08             	sub    $0x8,%esp
  801dde:	68 d8 38 80 00       	push   $0x8038d8
  801de3:	56                   	push   %esi
  801de4:	e8 62 fb ff ff       	call   80194b <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801de9:	83 c4 10             	add    $0x10,%esp
  801dec:	85 c0                	test   %eax,%eax
  801dee:	78 33                	js     801e23 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801df0:	83 ec 08             	sub    $0x8,%esp
  801df3:	6a 02                	push   $0x2
  801df5:	56                   	push   %esi
  801df6:	e8 cc fa ff ff       	call   8018c7 <sys_env_set_status>
	if(ret < 0)
  801dfb:	83 c4 10             	add    $0x10,%esp
  801dfe:	85 c0                	test   %eax,%eax
  801e00:	78 38                	js     801e3a <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801e02:	89 f0                	mov    %esi,%eax
  801e04:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e07:	5b                   	pop    %ebx
  801e08:	5e                   	pop    %esi
  801e09:	5f                   	pop    %edi
  801e0a:	5d                   	pop    %ebp
  801e0b:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801e0c:	83 ec 04             	sub    $0x4,%esp
  801e0f:	68 f4 42 80 00       	push   $0x8042f4
  801e14:	68 98 00 00 00       	push   $0x98
  801e19:	68 d5 42 80 00       	push   $0x8042d5
  801e1e:	e8 a6 ec ff ff       	call   800ac9 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801e23:	83 ec 04             	sub    $0x4,%esp
  801e26:	68 68 43 80 00       	push   $0x804368
  801e2b:	68 9b 00 00 00       	push   $0x9b
  801e30:	68 d5 42 80 00       	push   $0x8042d5
  801e35:	e8 8f ec ff ff       	call   800ac9 <_panic>
		panic("panic in sys_env_set_status()\n");
  801e3a:	83 ec 04             	sub    $0x4,%esp
  801e3d:	68 90 43 80 00       	push   $0x804390
  801e42:	68 9e 00 00 00       	push   $0x9e
  801e47:	68 d5 42 80 00       	push   $0x8042d5
  801e4c:	e8 78 ec ff ff       	call   800ac9 <_panic>

00801e51 <sfork>:

// Challenge!
int
sfork(void)
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
  801e54:	57                   	push   %edi
  801e55:	56                   	push   %esi
  801e56:	53                   	push   %ebx
  801e57:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801e5a:	68 2b 1c 80 00       	push   $0x801c2b
  801e5f:	e8 05 1a 00 00       	call   803869 <set_pgfault_handler>
  801e64:	b8 07 00 00 00       	mov    $0x7,%eax
  801e69:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801e6b:	83 c4 10             	add    $0x10,%esp
  801e6e:	85 c0                	test   %eax,%eax
  801e70:	78 27                	js     801e99 <sfork+0x48>
  801e72:	89 c7                	mov    %eax,%edi
  801e74:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801e76:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801e7b:	75 55                	jne    801ed2 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801e7d:	e8 40 f9 ff ff       	call   8017c2 <sys_getenvid>
  801e82:	25 ff 03 00 00       	and    $0x3ff,%eax
  801e87:	c1 e0 07             	shl    $0x7,%eax
  801e8a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801e8f:	a3 28 64 80 00       	mov    %eax,0x806428
		return 0;
  801e94:	e9 d4 00 00 00       	jmp    801f6d <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  801e99:	83 ec 04             	sub    $0x4,%esp
  801e9c:	68 44 43 80 00       	push   $0x804344
  801ea1:	68 af 00 00 00       	push   $0xaf
  801ea6:	68 d5 42 80 00       	push   $0x8042d5
  801eab:	e8 19 ec ff ff       	call   800ac9 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801eb0:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801eb5:	89 f0                	mov    %esi,%eax
  801eb7:	e8 19 fc ff ff       	call   801ad5 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801ebc:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801ec2:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801ec8:	77 65                	ja     801f2f <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801eca:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801ed0:	74 de                	je     801eb0 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801ed2:	89 d8                	mov    %ebx,%eax
  801ed4:	c1 e8 16             	shr    $0x16,%eax
  801ed7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801ede:	a8 01                	test   $0x1,%al
  801ee0:	74 da                	je     801ebc <sfork+0x6b>
  801ee2:	89 da                	mov    %ebx,%edx
  801ee4:	c1 ea 0c             	shr    $0xc,%edx
  801ee7:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801eee:	83 e0 05             	and    $0x5,%eax
  801ef1:	83 f8 05             	cmp    $0x5,%eax
  801ef4:	75 c6                	jne    801ebc <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801ef6:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801efd:	c1 e2 0c             	shl    $0xc,%edx
  801f00:	83 ec 0c             	sub    $0xc,%esp
  801f03:	83 e0 07             	and    $0x7,%eax
  801f06:	50                   	push   %eax
  801f07:	52                   	push   %edx
  801f08:	56                   	push   %esi
  801f09:	52                   	push   %edx
  801f0a:	6a 00                	push   $0x0
  801f0c:	e8 32 f9 ff ff       	call   801843 <sys_page_map>
  801f11:	83 c4 20             	add    $0x20,%esp
  801f14:	85 c0                	test   %eax,%eax
  801f16:	74 a4                	je     801ebc <sfork+0x6b>
				panic("sys_page_map() panic\n");
  801f18:	83 ec 04             	sub    $0x4,%esp
  801f1b:	68 bf 42 80 00       	push   $0x8042bf
  801f20:	68 ba 00 00 00       	push   $0xba
  801f25:	68 d5 42 80 00       	push   $0x8042d5
  801f2a:	e8 9a eb ff ff       	call   800ac9 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801f2f:	83 ec 04             	sub    $0x4,%esp
  801f32:	6a 07                	push   $0x7
  801f34:	68 00 f0 bf ee       	push   $0xeebff000
  801f39:	57                   	push   %edi
  801f3a:	e8 c1 f8 ff ff       	call   801800 <sys_page_alloc>
	if(ret < 0)
  801f3f:	83 c4 10             	add    $0x10,%esp
  801f42:	85 c0                	test   %eax,%eax
  801f44:	78 31                	js     801f77 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801f46:	83 ec 08             	sub    $0x8,%esp
  801f49:	68 d8 38 80 00       	push   $0x8038d8
  801f4e:	57                   	push   %edi
  801f4f:	e8 f7 f9 ff ff       	call   80194b <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801f54:	83 c4 10             	add    $0x10,%esp
  801f57:	85 c0                	test   %eax,%eax
  801f59:	78 33                	js     801f8e <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801f5b:	83 ec 08             	sub    $0x8,%esp
  801f5e:	6a 02                	push   $0x2
  801f60:	57                   	push   %edi
  801f61:	e8 61 f9 ff ff       	call   8018c7 <sys_env_set_status>
	if(ret < 0)
  801f66:	83 c4 10             	add    $0x10,%esp
  801f69:	85 c0                	test   %eax,%eax
  801f6b:	78 38                	js     801fa5 <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801f6d:	89 f8                	mov    %edi,%eax
  801f6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f72:	5b                   	pop    %ebx
  801f73:	5e                   	pop    %esi
  801f74:	5f                   	pop    %edi
  801f75:	5d                   	pop    %ebp
  801f76:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801f77:	83 ec 04             	sub    $0x4,%esp
  801f7a:	68 f4 42 80 00       	push   $0x8042f4
  801f7f:	68 c0 00 00 00       	push   $0xc0
  801f84:	68 d5 42 80 00       	push   $0x8042d5
  801f89:	e8 3b eb ff ff       	call   800ac9 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801f8e:	83 ec 04             	sub    $0x4,%esp
  801f91:	68 68 43 80 00       	push   $0x804368
  801f96:	68 c3 00 00 00       	push   $0xc3
  801f9b:	68 d5 42 80 00       	push   $0x8042d5
  801fa0:	e8 24 eb ff ff       	call   800ac9 <_panic>
		panic("panic in sys_env_set_status()\n");
  801fa5:	83 ec 04             	sub    $0x4,%esp
  801fa8:	68 90 43 80 00       	push   $0x804390
  801fad:	68 c6 00 00 00       	push   $0xc6
  801fb2:	68 d5 42 80 00       	push   $0x8042d5
  801fb7:	e8 0d eb ff ff       	call   800ac9 <_panic>

00801fbc <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801fbc:	55                   	push   %ebp
  801fbd:	89 e5                	mov    %esp,%ebp
  801fbf:	8b 55 08             	mov    0x8(%ebp),%edx
  801fc2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fc5:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801fc8:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  801fca:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801fcd:	83 3a 01             	cmpl   $0x1,(%edx)
  801fd0:	7e 09                	jle    801fdb <argstart+0x1f>
  801fd2:	ba c1 3c 80 00       	mov    $0x803cc1,%edx
  801fd7:	85 c9                	test   %ecx,%ecx
  801fd9:	75 05                	jne    801fe0 <argstart+0x24>
  801fdb:	ba 00 00 00 00       	mov    $0x0,%edx
  801fe0:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  801fe3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801fea:	5d                   	pop    %ebp
  801feb:	c3                   	ret    

00801fec <argnext>:

int
argnext(struct Argstate *args)
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
  801fef:	53                   	push   %ebx
  801ff0:	83 ec 04             	sub    $0x4,%esp
  801ff3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801ff6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801ffd:	8b 43 08             	mov    0x8(%ebx),%eax
  802000:	85 c0                	test   %eax,%eax
  802002:	74 72                	je     802076 <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  802004:	80 38 00             	cmpb   $0x0,(%eax)
  802007:	75 48                	jne    802051 <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  802009:	8b 0b                	mov    (%ebx),%ecx
  80200b:	83 39 01             	cmpl   $0x1,(%ecx)
  80200e:	74 58                	je     802068 <argnext+0x7c>
		    || args->argv[1][0] != '-'
  802010:	8b 53 04             	mov    0x4(%ebx),%edx
  802013:	8b 42 04             	mov    0x4(%edx),%eax
  802016:	80 38 2d             	cmpb   $0x2d,(%eax)
  802019:	75 4d                	jne    802068 <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  80201b:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  80201f:	74 47                	je     802068 <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  802021:	83 c0 01             	add    $0x1,%eax
  802024:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  802027:	83 ec 04             	sub    $0x4,%esp
  80202a:	8b 01                	mov    (%ecx),%eax
  80202c:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  802033:	50                   	push   %eax
  802034:	8d 42 08             	lea    0x8(%edx),%eax
  802037:	50                   	push   %eax
  802038:	83 c2 04             	add    $0x4,%edx
  80203b:	52                   	push   %edx
  80203c:	e8 5b f5 ff ff       	call   80159c <memmove>
		(*args->argc)--;
  802041:	8b 03                	mov    (%ebx),%eax
  802043:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  802046:	8b 43 08             	mov    0x8(%ebx),%eax
  802049:	83 c4 10             	add    $0x10,%esp
  80204c:	80 38 2d             	cmpb   $0x2d,(%eax)
  80204f:	74 11                	je     802062 <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  802051:	8b 53 08             	mov    0x8(%ebx),%edx
  802054:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  802057:	83 c2 01             	add    $0x1,%edx
  80205a:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  80205d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802060:	c9                   	leave  
  802061:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  802062:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  802066:	75 e9                	jne    802051 <argnext+0x65>
	args->curarg = 0;
  802068:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  80206f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  802074:	eb e7                	jmp    80205d <argnext+0x71>
		return -1;
  802076:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80207b:	eb e0                	jmp    80205d <argnext+0x71>

0080207d <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  80207d:	55                   	push   %ebp
  80207e:	89 e5                	mov    %esp,%ebp
  802080:	53                   	push   %ebx
  802081:	83 ec 04             	sub    $0x4,%esp
  802084:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  802087:	8b 43 08             	mov    0x8(%ebx),%eax
  80208a:	85 c0                	test   %eax,%eax
  80208c:	74 12                	je     8020a0 <argnextvalue+0x23>
		return 0;
	if (*args->curarg) {
  80208e:	80 38 00             	cmpb   $0x0,(%eax)
  802091:	74 12                	je     8020a5 <argnextvalue+0x28>
		args->argvalue = args->curarg;
  802093:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  802096:	c7 43 08 c1 3c 80 00 	movl   $0x803cc1,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  80209d:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  8020a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020a3:	c9                   	leave  
  8020a4:	c3                   	ret    
	} else if (*args->argc > 1) {
  8020a5:	8b 13                	mov    (%ebx),%edx
  8020a7:	83 3a 01             	cmpl   $0x1,(%edx)
  8020aa:	7f 10                	jg     8020bc <argnextvalue+0x3f>
		args->argvalue = 0;
  8020ac:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  8020b3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  8020ba:	eb e1                	jmp    80209d <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  8020bc:	8b 43 04             	mov    0x4(%ebx),%eax
  8020bf:	8b 48 04             	mov    0x4(%eax),%ecx
  8020c2:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8020c5:	83 ec 04             	sub    $0x4,%esp
  8020c8:	8b 12                	mov    (%edx),%edx
  8020ca:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  8020d1:	52                   	push   %edx
  8020d2:	8d 50 08             	lea    0x8(%eax),%edx
  8020d5:	52                   	push   %edx
  8020d6:	83 c0 04             	add    $0x4,%eax
  8020d9:	50                   	push   %eax
  8020da:	e8 bd f4 ff ff       	call   80159c <memmove>
		(*args->argc)--;
  8020df:	8b 03                	mov    (%ebx),%eax
  8020e1:	83 28 01             	subl   $0x1,(%eax)
  8020e4:	83 c4 10             	add    $0x10,%esp
  8020e7:	eb b4                	jmp    80209d <argnextvalue+0x20>

008020e9 <argvalue>:
{
  8020e9:	55                   	push   %ebp
  8020ea:	89 e5                	mov    %esp,%ebp
  8020ec:	83 ec 08             	sub    $0x8,%esp
  8020ef:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8020f2:	8b 42 0c             	mov    0xc(%edx),%eax
  8020f5:	85 c0                	test   %eax,%eax
  8020f7:	74 02                	je     8020fb <argvalue+0x12>
}
  8020f9:	c9                   	leave  
  8020fa:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8020fb:	83 ec 0c             	sub    $0xc,%esp
  8020fe:	52                   	push   %edx
  8020ff:	e8 79 ff ff ff       	call   80207d <argnextvalue>
  802104:	83 c4 10             	add    $0x10,%esp
  802107:	eb f0                	jmp    8020f9 <argvalue+0x10>

00802109 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  802109:	55                   	push   %ebp
  80210a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80210c:	8b 45 08             	mov    0x8(%ebp),%eax
  80210f:	05 00 00 00 30       	add    $0x30000000,%eax
  802114:	c1 e8 0c             	shr    $0xc,%eax
}
  802117:	5d                   	pop    %ebp
  802118:	c3                   	ret    

00802119 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80211c:	8b 45 08             	mov    0x8(%ebp),%eax
  80211f:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  802124:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802129:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80212e:	5d                   	pop    %ebp
  80212f:	c3                   	ret    

00802130 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802130:	55                   	push   %ebp
  802131:	89 e5                	mov    %esp,%ebp
  802133:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802138:	89 c2                	mov    %eax,%edx
  80213a:	c1 ea 16             	shr    $0x16,%edx
  80213d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802144:	f6 c2 01             	test   $0x1,%dl
  802147:	74 2d                	je     802176 <fd_alloc+0x46>
  802149:	89 c2                	mov    %eax,%edx
  80214b:	c1 ea 0c             	shr    $0xc,%edx
  80214e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802155:	f6 c2 01             	test   $0x1,%dl
  802158:	74 1c                	je     802176 <fd_alloc+0x46>
  80215a:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80215f:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  802164:	75 d2                	jne    802138 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802166:	8b 45 08             	mov    0x8(%ebp),%eax
  802169:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80216f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  802174:	eb 0a                	jmp    802180 <fd_alloc+0x50>
			*fd_store = fd;
  802176:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802179:	89 01                	mov    %eax,(%ecx)
			return 0;
  80217b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802180:	5d                   	pop    %ebp
  802181:	c3                   	ret    

00802182 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802182:	55                   	push   %ebp
  802183:	89 e5                	mov    %esp,%ebp
  802185:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802188:	83 f8 1f             	cmp    $0x1f,%eax
  80218b:	77 30                	ja     8021bd <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80218d:	c1 e0 0c             	shl    $0xc,%eax
  802190:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802195:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80219b:	f6 c2 01             	test   $0x1,%dl
  80219e:	74 24                	je     8021c4 <fd_lookup+0x42>
  8021a0:	89 c2                	mov    %eax,%edx
  8021a2:	c1 ea 0c             	shr    $0xc,%edx
  8021a5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8021ac:	f6 c2 01             	test   $0x1,%dl
  8021af:	74 1a                	je     8021cb <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8021b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b4:	89 02                	mov    %eax,(%edx)
	return 0;
  8021b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021bb:	5d                   	pop    %ebp
  8021bc:	c3                   	ret    
		return -E_INVAL;
  8021bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021c2:	eb f7                	jmp    8021bb <fd_lookup+0x39>
		return -E_INVAL;
  8021c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021c9:	eb f0                	jmp    8021bb <fd_lookup+0x39>
  8021cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021d0:	eb e9                	jmp    8021bb <fd_lookup+0x39>

008021d2 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8021d2:	55                   	push   %ebp
  8021d3:	89 e5                	mov    %esp,%ebp
  8021d5:	83 ec 08             	sub    $0x8,%esp
  8021d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8021db:	ba 00 00 00 00       	mov    $0x0,%edx
  8021e0:	b8 20 50 80 00       	mov    $0x805020,%eax
		if (devtab[i]->dev_id == dev_id) {
  8021e5:	39 08                	cmp    %ecx,(%eax)
  8021e7:	74 38                	je     802221 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8021e9:	83 c2 01             	add    $0x1,%edx
  8021ec:	8b 04 95 2c 44 80 00 	mov    0x80442c(,%edx,4),%eax
  8021f3:	85 c0                	test   %eax,%eax
  8021f5:	75 ee                	jne    8021e5 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8021f7:	a1 28 64 80 00       	mov    0x806428,%eax
  8021fc:	8b 40 48             	mov    0x48(%eax),%eax
  8021ff:	83 ec 04             	sub    $0x4,%esp
  802202:	51                   	push   %ecx
  802203:	50                   	push   %eax
  802204:	68 b0 43 80 00       	push   $0x8043b0
  802209:	e8 b1 e9 ff ff       	call   800bbf <cprintf>
	*dev = 0;
  80220e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802211:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  802217:	83 c4 10             	add    $0x10,%esp
  80221a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80221f:	c9                   	leave  
  802220:	c3                   	ret    
			*dev = devtab[i];
  802221:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802224:	89 01                	mov    %eax,(%ecx)
			return 0;
  802226:	b8 00 00 00 00       	mov    $0x0,%eax
  80222b:	eb f2                	jmp    80221f <dev_lookup+0x4d>

0080222d <fd_close>:
{
  80222d:	55                   	push   %ebp
  80222e:	89 e5                	mov    %esp,%ebp
  802230:	57                   	push   %edi
  802231:	56                   	push   %esi
  802232:	53                   	push   %ebx
  802233:	83 ec 24             	sub    $0x24,%esp
  802236:	8b 75 08             	mov    0x8(%ebp),%esi
  802239:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80223c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80223f:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802240:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  802246:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802249:	50                   	push   %eax
  80224a:	e8 33 ff ff ff       	call   802182 <fd_lookup>
  80224f:	89 c3                	mov    %eax,%ebx
  802251:	83 c4 10             	add    $0x10,%esp
  802254:	85 c0                	test   %eax,%eax
  802256:	78 05                	js     80225d <fd_close+0x30>
	    || fd != fd2)
  802258:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80225b:	74 16                	je     802273 <fd_close+0x46>
		return (must_exist ? r : 0);
  80225d:	89 f8                	mov    %edi,%eax
  80225f:	84 c0                	test   %al,%al
  802261:	b8 00 00 00 00       	mov    $0x0,%eax
  802266:	0f 44 d8             	cmove  %eax,%ebx
}
  802269:	89 d8                	mov    %ebx,%eax
  80226b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80226e:	5b                   	pop    %ebx
  80226f:	5e                   	pop    %esi
  802270:	5f                   	pop    %edi
  802271:	5d                   	pop    %ebp
  802272:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802273:	83 ec 08             	sub    $0x8,%esp
  802276:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802279:	50                   	push   %eax
  80227a:	ff 36                	pushl  (%esi)
  80227c:	e8 51 ff ff ff       	call   8021d2 <dev_lookup>
  802281:	89 c3                	mov    %eax,%ebx
  802283:	83 c4 10             	add    $0x10,%esp
  802286:	85 c0                	test   %eax,%eax
  802288:	78 1a                	js     8022a4 <fd_close+0x77>
		if (dev->dev_close)
  80228a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80228d:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  802290:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  802295:	85 c0                	test   %eax,%eax
  802297:	74 0b                	je     8022a4 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  802299:	83 ec 0c             	sub    $0xc,%esp
  80229c:	56                   	push   %esi
  80229d:	ff d0                	call   *%eax
  80229f:	89 c3                	mov    %eax,%ebx
  8022a1:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8022a4:	83 ec 08             	sub    $0x8,%esp
  8022a7:	56                   	push   %esi
  8022a8:	6a 00                	push   $0x0
  8022aa:	e8 d6 f5 ff ff       	call   801885 <sys_page_unmap>
	return r;
  8022af:	83 c4 10             	add    $0x10,%esp
  8022b2:	eb b5                	jmp    802269 <fd_close+0x3c>

008022b4 <close>:

int
close(int fdnum)
{
  8022b4:	55                   	push   %ebp
  8022b5:	89 e5                	mov    %esp,%ebp
  8022b7:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022bd:	50                   	push   %eax
  8022be:	ff 75 08             	pushl  0x8(%ebp)
  8022c1:	e8 bc fe ff ff       	call   802182 <fd_lookup>
  8022c6:	83 c4 10             	add    $0x10,%esp
  8022c9:	85 c0                	test   %eax,%eax
  8022cb:	79 02                	jns    8022cf <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8022cd:	c9                   	leave  
  8022ce:	c3                   	ret    
		return fd_close(fd, 1);
  8022cf:	83 ec 08             	sub    $0x8,%esp
  8022d2:	6a 01                	push   $0x1
  8022d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8022d7:	e8 51 ff ff ff       	call   80222d <fd_close>
  8022dc:	83 c4 10             	add    $0x10,%esp
  8022df:	eb ec                	jmp    8022cd <close+0x19>

008022e1 <close_all>:

void
close_all(void)
{
  8022e1:	55                   	push   %ebp
  8022e2:	89 e5                	mov    %esp,%ebp
  8022e4:	53                   	push   %ebx
  8022e5:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8022e8:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8022ed:	83 ec 0c             	sub    $0xc,%esp
  8022f0:	53                   	push   %ebx
  8022f1:	e8 be ff ff ff       	call   8022b4 <close>
	for (i = 0; i < MAXFD; i++)
  8022f6:	83 c3 01             	add    $0x1,%ebx
  8022f9:	83 c4 10             	add    $0x10,%esp
  8022fc:	83 fb 20             	cmp    $0x20,%ebx
  8022ff:	75 ec                	jne    8022ed <close_all+0xc>
}
  802301:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802304:	c9                   	leave  
  802305:	c3                   	ret    

00802306 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802306:	55                   	push   %ebp
  802307:	89 e5                	mov    %esp,%ebp
  802309:	57                   	push   %edi
  80230a:	56                   	push   %esi
  80230b:	53                   	push   %ebx
  80230c:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80230f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802312:	50                   	push   %eax
  802313:	ff 75 08             	pushl  0x8(%ebp)
  802316:	e8 67 fe ff ff       	call   802182 <fd_lookup>
  80231b:	89 c3                	mov    %eax,%ebx
  80231d:	83 c4 10             	add    $0x10,%esp
  802320:	85 c0                	test   %eax,%eax
  802322:	0f 88 81 00 00 00    	js     8023a9 <dup+0xa3>
		return r;
	close(newfdnum);
  802328:	83 ec 0c             	sub    $0xc,%esp
  80232b:	ff 75 0c             	pushl  0xc(%ebp)
  80232e:	e8 81 ff ff ff       	call   8022b4 <close>

	newfd = INDEX2FD(newfdnum);
  802333:	8b 75 0c             	mov    0xc(%ebp),%esi
  802336:	c1 e6 0c             	shl    $0xc,%esi
  802339:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80233f:	83 c4 04             	add    $0x4,%esp
  802342:	ff 75 e4             	pushl  -0x1c(%ebp)
  802345:	e8 cf fd ff ff       	call   802119 <fd2data>
  80234a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80234c:	89 34 24             	mov    %esi,(%esp)
  80234f:	e8 c5 fd ff ff       	call   802119 <fd2data>
  802354:	83 c4 10             	add    $0x10,%esp
  802357:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802359:	89 d8                	mov    %ebx,%eax
  80235b:	c1 e8 16             	shr    $0x16,%eax
  80235e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802365:	a8 01                	test   $0x1,%al
  802367:	74 11                	je     80237a <dup+0x74>
  802369:	89 d8                	mov    %ebx,%eax
  80236b:	c1 e8 0c             	shr    $0xc,%eax
  80236e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802375:	f6 c2 01             	test   $0x1,%dl
  802378:	75 39                	jne    8023b3 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80237a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80237d:	89 d0                	mov    %edx,%eax
  80237f:	c1 e8 0c             	shr    $0xc,%eax
  802382:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802389:	83 ec 0c             	sub    $0xc,%esp
  80238c:	25 07 0e 00 00       	and    $0xe07,%eax
  802391:	50                   	push   %eax
  802392:	56                   	push   %esi
  802393:	6a 00                	push   $0x0
  802395:	52                   	push   %edx
  802396:	6a 00                	push   $0x0
  802398:	e8 a6 f4 ff ff       	call   801843 <sys_page_map>
  80239d:	89 c3                	mov    %eax,%ebx
  80239f:	83 c4 20             	add    $0x20,%esp
  8023a2:	85 c0                	test   %eax,%eax
  8023a4:	78 31                	js     8023d7 <dup+0xd1>
		goto err;

	return newfdnum;
  8023a6:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8023a9:	89 d8                	mov    %ebx,%eax
  8023ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023ae:	5b                   	pop    %ebx
  8023af:	5e                   	pop    %esi
  8023b0:	5f                   	pop    %edi
  8023b1:	5d                   	pop    %ebp
  8023b2:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8023b3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8023ba:	83 ec 0c             	sub    $0xc,%esp
  8023bd:	25 07 0e 00 00       	and    $0xe07,%eax
  8023c2:	50                   	push   %eax
  8023c3:	57                   	push   %edi
  8023c4:	6a 00                	push   $0x0
  8023c6:	53                   	push   %ebx
  8023c7:	6a 00                	push   $0x0
  8023c9:	e8 75 f4 ff ff       	call   801843 <sys_page_map>
  8023ce:	89 c3                	mov    %eax,%ebx
  8023d0:	83 c4 20             	add    $0x20,%esp
  8023d3:	85 c0                	test   %eax,%eax
  8023d5:	79 a3                	jns    80237a <dup+0x74>
	sys_page_unmap(0, newfd);
  8023d7:	83 ec 08             	sub    $0x8,%esp
  8023da:	56                   	push   %esi
  8023db:	6a 00                	push   $0x0
  8023dd:	e8 a3 f4 ff ff       	call   801885 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8023e2:	83 c4 08             	add    $0x8,%esp
  8023e5:	57                   	push   %edi
  8023e6:	6a 00                	push   $0x0
  8023e8:	e8 98 f4 ff ff       	call   801885 <sys_page_unmap>
	return r;
  8023ed:	83 c4 10             	add    $0x10,%esp
  8023f0:	eb b7                	jmp    8023a9 <dup+0xa3>

008023f2 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8023f2:	55                   	push   %ebp
  8023f3:	89 e5                	mov    %esp,%ebp
  8023f5:	53                   	push   %ebx
  8023f6:	83 ec 1c             	sub    $0x1c,%esp
  8023f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023fc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8023ff:	50                   	push   %eax
  802400:	53                   	push   %ebx
  802401:	e8 7c fd ff ff       	call   802182 <fd_lookup>
  802406:	83 c4 10             	add    $0x10,%esp
  802409:	85 c0                	test   %eax,%eax
  80240b:	78 3f                	js     80244c <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80240d:	83 ec 08             	sub    $0x8,%esp
  802410:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802413:	50                   	push   %eax
  802414:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802417:	ff 30                	pushl  (%eax)
  802419:	e8 b4 fd ff ff       	call   8021d2 <dev_lookup>
  80241e:	83 c4 10             	add    $0x10,%esp
  802421:	85 c0                	test   %eax,%eax
  802423:	78 27                	js     80244c <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802425:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802428:	8b 42 08             	mov    0x8(%edx),%eax
  80242b:	83 e0 03             	and    $0x3,%eax
  80242e:	83 f8 01             	cmp    $0x1,%eax
  802431:	74 1e                	je     802451 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  802433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802436:	8b 40 08             	mov    0x8(%eax),%eax
  802439:	85 c0                	test   %eax,%eax
  80243b:	74 35                	je     802472 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80243d:	83 ec 04             	sub    $0x4,%esp
  802440:	ff 75 10             	pushl  0x10(%ebp)
  802443:	ff 75 0c             	pushl  0xc(%ebp)
  802446:	52                   	push   %edx
  802447:	ff d0                	call   *%eax
  802449:	83 c4 10             	add    $0x10,%esp
}
  80244c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80244f:	c9                   	leave  
  802450:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802451:	a1 28 64 80 00       	mov    0x806428,%eax
  802456:	8b 40 48             	mov    0x48(%eax),%eax
  802459:	83 ec 04             	sub    $0x4,%esp
  80245c:	53                   	push   %ebx
  80245d:	50                   	push   %eax
  80245e:	68 f1 43 80 00       	push   $0x8043f1
  802463:	e8 57 e7 ff ff       	call   800bbf <cprintf>
		return -E_INVAL;
  802468:	83 c4 10             	add    $0x10,%esp
  80246b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802470:	eb da                	jmp    80244c <read+0x5a>
		return -E_NOT_SUPP;
  802472:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802477:	eb d3                	jmp    80244c <read+0x5a>

00802479 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802479:	55                   	push   %ebp
  80247a:	89 e5                	mov    %esp,%ebp
  80247c:	57                   	push   %edi
  80247d:	56                   	push   %esi
  80247e:	53                   	push   %ebx
  80247f:	83 ec 0c             	sub    $0xc,%esp
  802482:	8b 7d 08             	mov    0x8(%ebp),%edi
  802485:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802488:	bb 00 00 00 00       	mov    $0x0,%ebx
  80248d:	39 f3                	cmp    %esi,%ebx
  80248f:	73 23                	jae    8024b4 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802491:	83 ec 04             	sub    $0x4,%esp
  802494:	89 f0                	mov    %esi,%eax
  802496:	29 d8                	sub    %ebx,%eax
  802498:	50                   	push   %eax
  802499:	89 d8                	mov    %ebx,%eax
  80249b:	03 45 0c             	add    0xc(%ebp),%eax
  80249e:	50                   	push   %eax
  80249f:	57                   	push   %edi
  8024a0:	e8 4d ff ff ff       	call   8023f2 <read>
		if (m < 0)
  8024a5:	83 c4 10             	add    $0x10,%esp
  8024a8:	85 c0                	test   %eax,%eax
  8024aa:	78 06                	js     8024b2 <readn+0x39>
			return m;
		if (m == 0)
  8024ac:	74 06                	je     8024b4 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8024ae:	01 c3                	add    %eax,%ebx
  8024b0:	eb db                	jmp    80248d <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8024b2:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8024b4:	89 d8                	mov    %ebx,%eax
  8024b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024b9:	5b                   	pop    %ebx
  8024ba:	5e                   	pop    %esi
  8024bb:	5f                   	pop    %edi
  8024bc:	5d                   	pop    %ebp
  8024bd:	c3                   	ret    

008024be <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8024be:	55                   	push   %ebp
  8024bf:	89 e5                	mov    %esp,%ebp
  8024c1:	53                   	push   %ebx
  8024c2:	83 ec 1c             	sub    $0x1c,%esp
  8024c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024c8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8024cb:	50                   	push   %eax
  8024cc:	53                   	push   %ebx
  8024cd:	e8 b0 fc ff ff       	call   802182 <fd_lookup>
  8024d2:	83 c4 10             	add    $0x10,%esp
  8024d5:	85 c0                	test   %eax,%eax
  8024d7:	78 3a                	js     802513 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024d9:	83 ec 08             	sub    $0x8,%esp
  8024dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024df:	50                   	push   %eax
  8024e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e3:	ff 30                	pushl  (%eax)
  8024e5:	e8 e8 fc ff ff       	call   8021d2 <dev_lookup>
  8024ea:	83 c4 10             	add    $0x10,%esp
  8024ed:	85 c0                	test   %eax,%eax
  8024ef:	78 22                	js     802513 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8024f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f4:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8024f8:	74 1e                	je     802518 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8024fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024fd:	8b 52 0c             	mov    0xc(%edx),%edx
  802500:	85 d2                	test   %edx,%edx
  802502:	74 35                	je     802539 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802504:	83 ec 04             	sub    $0x4,%esp
  802507:	ff 75 10             	pushl  0x10(%ebp)
  80250a:	ff 75 0c             	pushl  0xc(%ebp)
  80250d:	50                   	push   %eax
  80250e:	ff d2                	call   *%edx
  802510:	83 c4 10             	add    $0x10,%esp
}
  802513:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802516:	c9                   	leave  
  802517:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802518:	a1 28 64 80 00       	mov    0x806428,%eax
  80251d:	8b 40 48             	mov    0x48(%eax),%eax
  802520:	83 ec 04             	sub    $0x4,%esp
  802523:	53                   	push   %ebx
  802524:	50                   	push   %eax
  802525:	68 0d 44 80 00       	push   $0x80440d
  80252a:	e8 90 e6 ff ff       	call   800bbf <cprintf>
		return -E_INVAL;
  80252f:	83 c4 10             	add    $0x10,%esp
  802532:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802537:	eb da                	jmp    802513 <write+0x55>
		return -E_NOT_SUPP;
  802539:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80253e:	eb d3                	jmp    802513 <write+0x55>

00802540 <seek>:

int
seek(int fdnum, off_t offset)
{
  802540:	55                   	push   %ebp
  802541:	89 e5                	mov    %esp,%ebp
  802543:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802546:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802549:	50                   	push   %eax
  80254a:	ff 75 08             	pushl  0x8(%ebp)
  80254d:	e8 30 fc ff ff       	call   802182 <fd_lookup>
  802552:	83 c4 10             	add    $0x10,%esp
  802555:	85 c0                	test   %eax,%eax
  802557:	78 0e                	js     802567 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  802559:	8b 55 0c             	mov    0xc(%ebp),%edx
  80255c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255f:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802562:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802567:	c9                   	leave  
  802568:	c3                   	ret    

00802569 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802569:	55                   	push   %ebp
  80256a:	89 e5                	mov    %esp,%ebp
  80256c:	53                   	push   %ebx
  80256d:	83 ec 1c             	sub    $0x1c,%esp
  802570:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802573:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802576:	50                   	push   %eax
  802577:	53                   	push   %ebx
  802578:	e8 05 fc ff ff       	call   802182 <fd_lookup>
  80257d:	83 c4 10             	add    $0x10,%esp
  802580:	85 c0                	test   %eax,%eax
  802582:	78 37                	js     8025bb <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802584:	83 ec 08             	sub    $0x8,%esp
  802587:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80258a:	50                   	push   %eax
  80258b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80258e:	ff 30                	pushl  (%eax)
  802590:	e8 3d fc ff ff       	call   8021d2 <dev_lookup>
  802595:	83 c4 10             	add    $0x10,%esp
  802598:	85 c0                	test   %eax,%eax
  80259a:	78 1f                	js     8025bb <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80259c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80259f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8025a3:	74 1b                	je     8025c0 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8025a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a8:	8b 52 18             	mov    0x18(%edx),%edx
  8025ab:	85 d2                	test   %edx,%edx
  8025ad:	74 32                	je     8025e1 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8025af:	83 ec 08             	sub    $0x8,%esp
  8025b2:	ff 75 0c             	pushl  0xc(%ebp)
  8025b5:	50                   	push   %eax
  8025b6:	ff d2                	call   *%edx
  8025b8:	83 c4 10             	add    $0x10,%esp
}
  8025bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025be:	c9                   	leave  
  8025bf:	c3                   	ret    
			thisenv->env_id, fdnum);
  8025c0:	a1 28 64 80 00       	mov    0x806428,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8025c5:	8b 40 48             	mov    0x48(%eax),%eax
  8025c8:	83 ec 04             	sub    $0x4,%esp
  8025cb:	53                   	push   %ebx
  8025cc:	50                   	push   %eax
  8025cd:	68 d0 43 80 00       	push   $0x8043d0
  8025d2:	e8 e8 e5 ff ff       	call   800bbf <cprintf>
		return -E_INVAL;
  8025d7:	83 c4 10             	add    $0x10,%esp
  8025da:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025df:	eb da                	jmp    8025bb <ftruncate+0x52>
		return -E_NOT_SUPP;
  8025e1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8025e6:	eb d3                	jmp    8025bb <ftruncate+0x52>

008025e8 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8025e8:	55                   	push   %ebp
  8025e9:	89 e5                	mov    %esp,%ebp
  8025eb:	53                   	push   %ebx
  8025ec:	83 ec 1c             	sub    $0x1c,%esp
  8025ef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025f2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8025f5:	50                   	push   %eax
  8025f6:	ff 75 08             	pushl  0x8(%ebp)
  8025f9:	e8 84 fb ff ff       	call   802182 <fd_lookup>
  8025fe:	83 c4 10             	add    $0x10,%esp
  802601:	85 c0                	test   %eax,%eax
  802603:	78 4b                	js     802650 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802605:	83 ec 08             	sub    $0x8,%esp
  802608:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80260b:	50                   	push   %eax
  80260c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80260f:	ff 30                	pushl  (%eax)
  802611:	e8 bc fb ff ff       	call   8021d2 <dev_lookup>
  802616:	83 c4 10             	add    $0x10,%esp
  802619:	85 c0                	test   %eax,%eax
  80261b:	78 33                	js     802650 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80261d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802620:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  802624:	74 2f                	je     802655 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  802626:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802629:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  802630:	00 00 00 
	stat->st_isdir = 0;
  802633:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80263a:	00 00 00 
	stat->st_dev = dev;
  80263d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802643:	83 ec 08             	sub    $0x8,%esp
  802646:	53                   	push   %ebx
  802647:	ff 75 f0             	pushl  -0x10(%ebp)
  80264a:	ff 50 14             	call   *0x14(%eax)
  80264d:	83 c4 10             	add    $0x10,%esp
}
  802650:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802653:	c9                   	leave  
  802654:	c3                   	ret    
		return -E_NOT_SUPP;
  802655:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80265a:	eb f4                	jmp    802650 <fstat+0x68>

0080265c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80265c:	55                   	push   %ebp
  80265d:	89 e5                	mov    %esp,%ebp
  80265f:	56                   	push   %esi
  802660:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802661:	83 ec 08             	sub    $0x8,%esp
  802664:	6a 00                	push   $0x0
  802666:	ff 75 08             	pushl  0x8(%ebp)
  802669:	e8 22 02 00 00       	call   802890 <open>
  80266e:	89 c3                	mov    %eax,%ebx
  802670:	83 c4 10             	add    $0x10,%esp
  802673:	85 c0                	test   %eax,%eax
  802675:	78 1b                	js     802692 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  802677:	83 ec 08             	sub    $0x8,%esp
  80267a:	ff 75 0c             	pushl  0xc(%ebp)
  80267d:	50                   	push   %eax
  80267e:	e8 65 ff ff ff       	call   8025e8 <fstat>
  802683:	89 c6                	mov    %eax,%esi
	close(fd);
  802685:	89 1c 24             	mov    %ebx,(%esp)
  802688:	e8 27 fc ff ff       	call   8022b4 <close>
	return r;
  80268d:	83 c4 10             	add    $0x10,%esp
  802690:	89 f3                	mov    %esi,%ebx
}
  802692:	89 d8                	mov    %ebx,%eax
  802694:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802697:	5b                   	pop    %ebx
  802698:	5e                   	pop    %esi
  802699:	5d                   	pop    %ebp
  80269a:	c3                   	ret    

0080269b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80269b:	55                   	push   %ebp
  80269c:	89 e5                	mov    %esp,%ebp
  80269e:	56                   	push   %esi
  80269f:	53                   	push   %ebx
  8026a0:	89 c6                	mov    %eax,%esi
  8026a2:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8026a4:	83 3d 20 64 80 00 00 	cmpl   $0x0,0x806420
  8026ab:	74 27                	je     8026d4 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8026ad:	6a 07                	push   $0x7
  8026af:	68 00 70 80 00       	push   $0x807000
  8026b4:	56                   	push   %esi
  8026b5:	ff 35 20 64 80 00    	pushl  0x806420
  8026bb:	e8 a7 12 00 00       	call   803967 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8026c0:	83 c4 0c             	add    $0xc,%esp
  8026c3:	6a 00                	push   $0x0
  8026c5:	53                   	push   %ebx
  8026c6:	6a 00                	push   $0x0
  8026c8:	e8 31 12 00 00       	call   8038fe <ipc_recv>
}
  8026cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026d0:	5b                   	pop    %ebx
  8026d1:	5e                   	pop    %esi
  8026d2:	5d                   	pop    %ebp
  8026d3:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8026d4:	83 ec 0c             	sub    $0xc,%esp
  8026d7:	6a 01                	push   $0x1
  8026d9:	e8 e1 12 00 00       	call   8039bf <ipc_find_env>
  8026de:	a3 20 64 80 00       	mov    %eax,0x806420
  8026e3:	83 c4 10             	add    $0x10,%esp
  8026e6:	eb c5                	jmp    8026ad <fsipc+0x12>

008026e8 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8026e8:	55                   	push   %ebp
  8026e9:	89 e5                	mov    %esp,%ebp
  8026eb:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8026ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f4:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  8026f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026fc:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  802701:	ba 00 00 00 00       	mov    $0x0,%edx
  802706:	b8 02 00 00 00       	mov    $0x2,%eax
  80270b:	e8 8b ff ff ff       	call   80269b <fsipc>
}
  802710:	c9                   	leave  
  802711:	c3                   	ret    

00802712 <devfile_flush>:
{
  802712:	55                   	push   %ebp
  802713:	89 e5                	mov    %esp,%ebp
  802715:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802718:	8b 45 08             	mov    0x8(%ebp),%eax
  80271b:	8b 40 0c             	mov    0xc(%eax),%eax
  80271e:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  802723:	ba 00 00 00 00       	mov    $0x0,%edx
  802728:	b8 06 00 00 00       	mov    $0x6,%eax
  80272d:	e8 69 ff ff ff       	call   80269b <fsipc>
}
  802732:	c9                   	leave  
  802733:	c3                   	ret    

00802734 <devfile_stat>:
{
  802734:	55                   	push   %ebp
  802735:	89 e5                	mov    %esp,%ebp
  802737:	53                   	push   %ebx
  802738:	83 ec 04             	sub    $0x4,%esp
  80273b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80273e:	8b 45 08             	mov    0x8(%ebp),%eax
  802741:	8b 40 0c             	mov    0xc(%eax),%eax
  802744:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802749:	ba 00 00 00 00       	mov    $0x0,%edx
  80274e:	b8 05 00 00 00       	mov    $0x5,%eax
  802753:	e8 43 ff ff ff       	call   80269b <fsipc>
  802758:	85 c0                	test   %eax,%eax
  80275a:	78 2c                	js     802788 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80275c:	83 ec 08             	sub    $0x8,%esp
  80275f:	68 00 70 80 00       	push   $0x807000
  802764:	53                   	push   %ebx
  802765:	e8 a4 ec ff ff       	call   80140e <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80276a:	a1 80 70 80 00       	mov    0x807080,%eax
  80276f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802775:	a1 84 70 80 00       	mov    0x807084,%eax
  80277a:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  802780:	83 c4 10             	add    $0x10,%esp
  802783:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802788:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80278b:	c9                   	leave  
  80278c:	c3                   	ret    

0080278d <devfile_write>:
{
  80278d:	55                   	push   %ebp
  80278e:	89 e5                	mov    %esp,%ebp
  802790:	53                   	push   %ebx
  802791:	83 ec 08             	sub    $0x8,%esp
  802794:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802797:	8b 45 08             	mov    0x8(%ebp),%eax
  80279a:	8b 40 0c             	mov    0xc(%eax),%eax
  80279d:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.write.req_n = n;
  8027a2:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8027a8:	53                   	push   %ebx
  8027a9:	ff 75 0c             	pushl  0xc(%ebp)
  8027ac:	68 08 70 80 00       	push   $0x807008
  8027b1:	e8 48 ee ff ff       	call   8015fe <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8027b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8027bb:	b8 04 00 00 00       	mov    $0x4,%eax
  8027c0:	e8 d6 fe ff ff       	call   80269b <fsipc>
  8027c5:	83 c4 10             	add    $0x10,%esp
  8027c8:	85 c0                	test   %eax,%eax
  8027ca:	78 0b                	js     8027d7 <devfile_write+0x4a>
	assert(r <= n);
  8027cc:	39 d8                	cmp    %ebx,%eax
  8027ce:	77 0c                	ja     8027dc <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8027d0:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8027d5:	7f 1e                	jg     8027f5 <devfile_write+0x68>
}
  8027d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027da:	c9                   	leave  
  8027db:	c3                   	ret    
	assert(r <= n);
  8027dc:	68 40 44 80 00       	push   $0x804440
  8027e1:	68 ef 3d 80 00       	push   $0x803def
  8027e6:	68 98 00 00 00       	push   $0x98
  8027eb:	68 47 44 80 00       	push   $0x804447
  8027f0:	e8 d4 e2 ff ff       	call   800ac9 <_panic>
	assert(r <= PGSIZE);
  8027f5:	68 52 44 80 00       	push   $0x804452
  8027fa:	68 ef 3d 80 00       	push   $0x803def
  8027ff:	68 99 00 00 00       	push   $0x99
  802804:	68 47 44 80 00       	push   $0x804447
  802809:	e8 bb e2 ff ff       	call   800ac9 <_panic>

0080280e <devfile_read>:
{
  80280e:	55                   	push   %ebp
  80280f:	89 e5                	mov    %esp,%ebp
  802811:	56                   	push   %esi
  802812:	53                   	push   %ebx
  802813:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802816:	8b 45 08             	mov    0x8(%ebp),%eax
  802819:	8b 40 0c             	mov    0xc(%eax),%eax
  80281c:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  802821:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802827:	ba 00 00 00 00       	mov    $0x0,%edx
  80282c:	b8 03 00 00 00       	mov    $0x3,%eax
  802831:	e8 65 fe ff ff       	call   80269b <fsipc>
  802836:	89 c3                	mov    %eax,%ebx
  802838:	85 c0                	test   %eax,%eax
  80283a:	78 1f                	js     80285b <devfile_read+0x4d>
	assert(r <= n);
  80283c:	39 f0                	cmp    %esi,%eax
  80283e:	77 24                	ja     802864 <devfile_read+0x56>
	assert(r <= PGSIZE);
  802840:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802845:	7f 33                	jg     80287a <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802847:	83 ec 04             	sub    $0x4,%esp
  80284a:	50                   	push   %eax
  80284b:	68 00 70 80 00       	push   $0x807000
  802850:	ff 75 0c             	pushl  0xc(%ebp)
  802853:	e8 44 ed ff ff       	call   80159c <memmove>
	return r;
  802858:	83 c4 10             	add    $0x10,%esp
}
  80285b:	89 d8                	mov    %ebx,%eax
  80285d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802860:	5b                   	pop    %ebx
  802861:	5e                   	pop    %esi
  802862:	5d                   	pop    %ebp
  802863:	c3                   	ret    
	assert(r <= n);
  802864:	68 40 44 80 00       	push   $0x804440
  802869:	68 ef 3d 80 00       	push   $0x803def
  80286e:	6a 7c                	push   $0x7c
  802870:	68 47 44 80 00       	push   $0x804447
  802875:	e8 4f e2 ff ff       	call   800ac9 <_panic>
	assert(r <= PGSIZE);
  80287a:	68 52 44 80 00       	push   $0x804452
  80287f:	68 ef 3d 80 00       	push   $0x803def
  802884:	6a 7d                	push   $0x7d
  802886:	68 47 44 80 00       	push   $0x804447
  80288b:	e8 39 e2 ff ff       	call   800ac9 <_panic>

00802890 <open>:
{
  802890:	55                   	push   %ebp
  802891:	89 e5                	mov    %esp,%ebp
  802893:	56                   	push   %esi
  802894:	53                   	push   %ebx
  802895:	83 ec 1c             	sub    $0x1c,%esp
  802898:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80289b:	56                   	push   %esi
  80289c:	e8 34 eb ff ff       	call   8013d5 <strlen>
  8028a1:	83 c4 10             	add    $0x10,%esp
  8028a4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8028a9:	7f 6c                	jg     802917 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8028ab:	83 ec 0c             	sub    $0xc,%esp
  8028ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028b1:	50                   	push   %eax
  8028b2:	e8 79 f8 ff ff       	call   802130 <fd_alloc>
  8028b7:	89 c3                	mov    %eax,%ebx
  8028b9:	83 c4 10             	add    $0x10,%esp
  8028bc:	85 c0                	test   %eax,%eax
  8028be:	78 3c                	js     8028fc <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8028c0:	83 ec 08             	sub    $0x8,%esp
  8028c3:	56                   	push   %esi
  8028c4:	68 00 70 80 00       	push   $0x807000
  8028c9:	e8 40 eb ff ff       	call   80140e <strcpy>
	fsipcbuf.open.req_omode = mode;
  8028ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028d1:	a3 00 74 80 00       	mov    %eax,0x807400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8028d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8028de:	e8 b8 fd ff ff       	call   80269b <fsipc>
  8028e3:	89 c3                	mov    %eax,%ebx
  8028e5:	83 c4 10             	add    $0x10,%esp
  8028e8:	85 c0                	test   %eax,%eax
  8028ea:	78 19                	js     802905 <open+0x75>
	return fd2num(fd);
  8028ec:	83 ec 0c             	sub    $0xc,%esp
  8028ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8028f2:	e8 12 f8 ff ff       	call   802109 <fd2num>
  8028f7:	89 c3                	mov    %eax,%ebx
  8028f9:	83 c4 10             	add    $0x10,%esp
}
  8028fc:	89 d8                	mov    %ebx,%eax
  8028fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802901:	5b                   	pop    %ebx
  802902:	5e                   	pop    %esi
  802903:	5d                   	pop    %ebp
  802904:	c3                   	ret    
		fd_close(fd, 0);
  802905:	83 ec 08             	sub    $0x8,%esp
  802908:	6a 00                	push   $0x0
  80290a:	ff 75 f4             	pushl  -0xc(%ebp)
  80290d:	e8 1b f9 ff ff       	call   80222d <fd_close>
		return r;
  802912:	83 c4 10             	add    $0x10,%esp
  802915:	eb e5                	jmp    8028fc <open+0x6c>
		return -E_BAD_PATH;
  802917:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80291c:	eb de                	jmp    8028fc <open+0x6c>

0080291e <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80291e:	55                   	push   %ebp
  80291f:	89 e5                	mov    %esp,%ebp
  802921:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802924:	ba 00 00 00 00       	mov    $0x0,%edx
  802929:	b8 08 00 00 00       	mov    $0x8,%eax
  80292e:	e8 68 fd ff ff       	call   80269b <fsipc>
}
  802933:	c9                   	leave  
  802934:	c3                   	ret    

00802935 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  802935:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  802939:	7f 01                	jg     80293c <writebuf+0x7>
  80293b:	c3                   	ret    
{
  80293c:	55                   	push   %ebp
  80293d:	89 e5                	mov    %esp,%ebp
  80293f:	53                   	push   %ebx
  802940:	83 ec 08             	sub    $0x8,%esp
  802943:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  802945:	ff 70 04             	pushl  0x4(%eax)
  802948:	8d 40 10             	lea    0x10(%eax),%eax
  80294b:	50                   	push   %eax
  80294c:	ff 33                	pushl  (%ebx)
  80294e:	e8 6b fb ff ff       	call   8024be <write>
		if (result > 0)
  802953:	83 c4 10             	add    $0x10,%esp
  802956:	85 c0                	test   %eax,%eax
  802958:	7e 03                	jle    80295d <writebuf+0x28>
			b->result += result;
  80295a:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  80295d:	39 43 04             	cmp    %eax,0x4(%ebx)
  802960:	74 0d                	je     80296f <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  802962:	85 c0                	test   %eax,%eax
  802964:	ba 00 00 00 00       	mov    $0x0,%edx
  802969:	0f 4f c2             	cmovg  %edx,%eax
  80296c:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  80296f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802972:	c9                   	leave  
  802973:	c3                   	ret    

00802974 <putch>:

static void
putch(int ch, void *thunk)
{
  802974:	55                   	push   %ebp
  802975:	89 e5                	mov    %esp,%ebp
  802977:	53                   	push   %ebx
  802978:	83 ec 04             	sub    $0x4,%esp
  80297b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  80297e:	8b 53 04             	mov    0x4(%ebx),%edx
  802981:	8d 42 01             	lea    0x1(%edx),%eax
  802984:	89 43 04             	mov    %eax,0x4(%ebx)
  802987:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80298a:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  80298e:	3d 00 01 00 00       	cmp    $0x100,%eax
  802993:	74 06                	je     80299b <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  802995:	83 c4 04             	add    $0x4,%esp
  802998:	5b                   	pop    %ebx
  802999:	5d                   	pop    %ebp
  80299a:	c3                   	ret    
		writebuf(b);
  80299b:	89 d8                	mov    %ebx,%eax
  80299d:	e8 93 ff ff ff       	call   802935 <writebuf>
		b->idx = 0;
  8029a2:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8029a9:	eb ea                	jmp    802995 <putch+0x21>

008029ab <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8029ab:	55                   	push   %ebp
  8029ac:	89 e5                	mov    %esp,%ebp
  8029ae:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  8029b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b7:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8029bd:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8029c4:	00 00 00 
	b.result = 0;
  8029c7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8029ce:	00 00 00 
	b.error = 1;
  8029d1:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8029d8:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8029db:	ff 75 10             	pushl  0x10(%ebp)
  8029de:	ff 75 0c             	pushl  0xc(%ebp)
  8029e1:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8029e7:	50                   	push   %eax
  8029e8:	68 74 29 80 00       	push   $0x802974
  8029ed:	e8 fa e2 ff ff       	call   800cec <vprintfmt>
	if (b.idx > 0)
  8029f2:	83 c4 10             	add    $0x10,%esp
  8029f5:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  8029fc:	7f 11                	jg     802a0f <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  8029fe:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  802a04:	85 c0                	test   %eax,%eax
  802a06:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  802a0d:	c9                   	leave  
  802a0e:	c3                   	ret    
		writebuf(&b);
  802a0f:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  802a15:	e8 1b ff ff ff       	call   802935 <writebuf>
  802a1a:	eb e2                	jmp    8029fe <vfprintf+0x53>

00802a1c <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802a1c:	55                   	push   %ebp
  802a1d:	89 e5                	mov    %esp,%ebp
  802a1f:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802a22:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  802a25:	50                   	push   %eax
  802a26:	ff 75 0c             	pushl  0xc(%ebp)
  802a29:	ff 75 08             	pushl  0x8(%ebp)
  802a2c:	e8 7a ff ff ff       	call   8029ab <vfprintf>
	va_end(ap);

	return cnt;
}
  802a31:	c9                   	leave  
  802a32:	c3                   	ret    

00802a33 <printf>:

int
printf(const char *fmt, ...)
{
  802a33:	55                   	push   %ebp
  802a34:	89 e5                	mov    %esp,%ebp
  802a36:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802a39:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  802a3c:	50                   	push   %eax
  802a3d:	ff 75 08             	pushl  0x8(%ebp)
  802a40:	6a 01                	push   $0x1
  802a42:	e8 64 ff ff ff       	call   8029ab <vfprintf>
	va_end(ap);

	return cnt;
}
  802a47:	c9                   	leave  
  802a48:	c3                   	ret    

00802a49 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802a49:	55                   	push   %ebp
  802a4a:	89 e5                	mov    %esp,%ebp
  802a4c:	57                   	push   %edi
  802a4d:	56                   	push   %esi
  802a4e:	53                   	push   %ebx
  802a4f:	81 ec 94 02 00 00    	sub    $0x294,%esp
	cprintf("in %s\n", __FUNCTION__);
  802a55:	68 34 45 80 00       	push   $0x804534
  802a5a:	68 dd 3e 80 00       	push   $0x803edd
  802a5f:	e8 5b e1 ff ff       	call   800bbf <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802a64:	83 c4 08             	add    $0x8,%esp
  802a67:	6a 00                	push   $0x0
  802a69:	ff 75 08             	pushl  0x8(%ebp)
  802a6c:	e8 1f fe ff ff       	call   802890 <open>
  802a71:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802a77:	83 c4 10             	add    $0x10,%esp
  802a7a:	85 c0                	test   %eax,%eax
  802a7c:	0f 88 0a 05 00 00    	js     802f8c <spawn+0x543>
  802a82:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802a84:	83 ec 04             	sub    $0x4,%esp
  802a87:	68 00 02 00 00       	push   $0x200
  802a8c:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  802a92:	50                   	push   %eax
  802a93:	51                   	push   %ecx
  802a94:	e8 e0 f9 ff ff       	call   802479 <readn>
  802a99:	83 c4 10             	add    $0x10,%esp
  802a9c:	3d 00 02 00 00       	cmp    $0x200,%eax
  802aa1:	75 74                	jne    802b17 <spawn+0xce>
	    || elf->e_magic != ELF_MAGIC) {
  802aa3:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  802aaa:	45 4c 46 
  802aad:	75 68                	jne    802b17 <spawn+0xce>
  802aaf:	b8 07 00 00 00       	mov    $0x7,%eax
  802ab4:	cd 30                	int    $0x30
  802ab6:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  802abc:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802ac2:	85 c0                	test   %eax,%eax
  802ac4:	0f 88 b6 04 00 00    	js     802f80 <spawn+0x537>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802aca:	25 ff 03 00 00       	and    $0x3ff,%eax
  802acf:	89 c6                	mov    %eax,%esi
  802ad1:	c1 e6 07             	shl    $0x7,%esi
  802ad4:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  802ada:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  802ae0:	b9 11 00 00 00       	mov    $0x11,%ecx
  802ae5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  802ae7:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802aed:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
	cprintf("in %s\n", __FUNCTION__);
  802af3:	83 ec 08             	sub    $0x8,%esp
  802af6:	68 28 45 80 00       	push   $0x804528
  802afb:	68 dd 3e 80 00       	push   $0x803edd
  802b00:	e8 ba e0 ff ff       	call   800bbf <cprintf>
  802b05:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802b08:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  802b0d:	be 00 00 00 00       	mov    $0x0,%esi
  802b12:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802b15:	eb 4b                	jmp    802b62 <spawn+0x119>
		close(fd);
  802b17:	83 ec 0c             	sub    $0xc,%esp
  802b1a:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802b20:	e8 8f f7 ff ff       	call   8022b4 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802b25:	83 c4 0c             	add    $0xc,%esp
  802b28:	68 7f 45 4c 46       	push   $0x464c457f
  802b2d:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  802b33:	68 5e 44 80 00       	push   $0x80445e
  802b38:	e8 82 e0 ff ff       	call   800bbf <cprintf>
		return -E_NOT_EXEC;
  802b3d:	83 c4 10             	add    $0x10,%esp
  802b40:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  802b47:	ff ff ff 
  802b4a:	e9 3d 04 00 00       	jmp    802f8c <spawn+0x543>
		string_size += strlen(argv[argc]) + 1;
  802b4f:	83 ec 0c             	sub    $0xc,%esp
  802b52:	50                   	push   %eax
  802b53:	e8 7d e8 ff ff       	call   8013d5 <strlen>
  802b58:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  802b5c:	83 c3 01             	add    $0x1,%ebx
  802b5f:	83 c4 10             	add    $0x10,%esp
  802b62:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  802b69:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  802b6c:	85 c0                	test   %eax,%eax
  802b6e:	75 df                	jne    802b4f <spawn+0x106>
  802b70:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  802b76:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  802b7c:	bf 00 10 40 00       	mov    $0x401000,%edi
  802b81:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802b83:	89 fa                	mov    %edi,%edx
  802b85:	83 e2 fc             	and    $0xfffffffc,%edx
  802b88:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  802b8f:	29 c2                	sub    %eax,%edx
  802b91:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802b97:	8d 42 f8             	lea    -0x8(%edx),%eax
  802b9a:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802b9f:	0f 86 0a 04 00 00    	jbe    802faf <spawn+0x566>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802ba5:	83 ec 04             	sub    $0x4,%esp
  802ba8:	6a 07                	push   $0x7
  802baa:	68 00 00 40 00       	push   $0x400000
  802baf:	6a 00                	push   $0x0
  802bb1:	e8 4a ec ff ff       	call   801800 <sys_page_alloc>
  802bb6:	83 c4 10             	add    $0x10,%esp
  802bb9:	85 c0                	test   %eax,%eax
  802bbb:	0f 88 f3 03 00 00    	js     802fb4 <spawn+0x56b>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802bc1:	be 00 00 00 00       	mov    $0x0,%esi
  802bc6:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  802bcc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802bcf:	eb 30                	jmp    802c01 <spawn+0x1b8>
		argv_store[i] = UTEMP2USTACK(string_store);
  802bd1:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802bd7:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  802bdd:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  802be0:	83 ec 08             	sub    $0x8,%esp
  802be3:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802be6:	57                   	push   %edi
  802be7:	e8 22 e8 ff ff       	call   80140e <strcpy>
		string_store += strlen(argv[i]) + 1;
  802bec:	83 c4 04             	add    $0x4,%esp
  802bef:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802bf2:	e8 de e7 ff ff       	call   8013d5 <strlen>
  802bf7:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  802bfb:	83 c6 01             	add    $0x1,%esi
  802bfe:	83 c4 10             	add    $0x10,%esp
  802c01:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  802c07:	7f c8                	jg     802bd1 <spawn+0x188>
	}
	argv_store[argc] = 0;
  802c09:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802c0f:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  802c15:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  802c1c:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  802c22:	0f 85 86 00 00 00    	jne    802cae <spawn+0x265>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802c28:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  802c2e:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  802c34:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  802c37:	89 d0                	mov    %edx,%eax
  802c39:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  802c3f:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802c42:	2d 08 30 80 11       	sub    $0x11803008,%eax
  802c47:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802c4d:	83 ec 0c             	sub    $0xc,%esp
  802c50:	6a 07                	push   $0x7
  802c52:	68 00 d0 bf ee       	push   $0xeebfd000
  802c57:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802c5d:	68 00 00 40 00       	push   $0x400000
  802c62:	6a 00                	push   $0x0
  802c64:	e8 da eb ff ff       	call   801843 <sys_page_map>
  802c69:	89 c3                	mov    %eax,%ebx
  802c6b:	83 c4 20             	add    $0x20,%esp
  802c6e:	85 c0                	test   %eax,%eax
  802c70:	0f 88 46 03 00 00    	js     802fbc <spawn+0x573>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802c76:	83 ec 08             	sub    $0x8,%esp
  802c79:	68 00 00 40 00       	push   $0x400000
  802c7e:	6a 00                	push   $0x0
  802c80:	e8 00 ec ff ff       	call   801885 <sys_page_unmap>
  802c85:	89 c3                	mov    %eax,%ebx
  802c87:	83 c4 10             	add    $0x10,%esp
  802c8a:	85 c0                	test   %eax,%eax
  802c8c:	0f 88 2a 03 00 00    	js     802fbc <spawn+0x573>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802c92:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  802c98:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802c9f:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  802ca6:	00 00 00 
  802ca9:	e9 4f 01 00 00       	jmp    802dfd <spawn+0x3b4>
	assert(string_store == (char*)UTEMP + PGSIZE);
  802cae:	68 e4 44 80 00       	push   $0x8044e4
  802cb3:	68 ef 3d 80 00       	push   $0x803def
  802cb8:	68 f8 00 00 00       	push   $0xf8
  802cbd:	68 78 44 80 00       	push   $0x804478
  802cc2:	e8 02 de ff ff       	call   800ac9 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802cc7:	83 ec 04             	sub    $0x4,%esp
  802cca:	6a 07                	push   $0x7
  802ccc:	68 00 00 40 00       	push   $0x400000
  802cd1:	6a 00                	push   $0x0
  802cd3:	e8 28 eb ff ff       	call   801800 <sys_page_alloc>
  802cd8:	83 c4 10             	add    $0x10,%esp
  802cdb:	85 c0                	test   %eax,%eax
  802cdd:	0f 88 b7 02 00 00    	js     802f9a <spawn+0x551>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802ce3:	83 ec 08             	sub    $0x8,%esp
  802ce6:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802cec:	01 f0                	add    %esi,%eax
  802cee:	50                   	push   %eax
  802cef:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802cf5:	e8 46 f8 ff ff       	call   802540 <seek>
  802cfa:	83 c4 10             	add    $0x10,%esp
  802cfd:	85 c0                	test   %eax,%eax
  802cff:	0f 88 9c 02 00 00    	js     802fa1 <spawn+0x558>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802d05:	83 ec 04             	sub    $0x4,%esp
  802d08:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802d0e:	29 f0                	sub    %esi,%eax
  802d10:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802d15:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802d1a:	0f 47 c1             	cmova  %ecx,%eax
  802d1d:	50                   	push   %eax
  802d1e:	68 00 00 40 00       	push   $0x400000
  802d23:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802d29:	e8 4b f7 ff ff       	call   802479 <readn>
  802d2e:	83 c4 10             	add    $0x10,%esp
  802d31:	85 c0                	test   %eax,%eax
  802d33:	0f 88 6f 02 00 00    	js     802fa8 <spawn+0x55f>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802d39:	83 ec 0c             	sub    $0xc,%esp
  802d3c:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802d42:	53                   	push   %ebx
  802d43:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802d49:	68 00 00 40 00       	push   $0x400000
  802d4e:	6a 00                	push   $0x0
  802d50:	e8 ee ea ff ff       	call   801843 <sys_page_map>
  802d55:	83 c4 20             	add    $0x20,%esp
  802d58:	85 c0                	test   %eax,%eax
  802d5a:	78 7c                	js     802dd8 <spawn+0x38f>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  802d5c:	83 ec 08             	sub    $0x8,%esp
  802d5f:	68 00 00 40 00       	push   $0x400000
  802d64:	6a 00                	push   $0x0
  802d66:	e8 1a eb ff ff       	call   801885 <sys_page_unmap>
  802d6b:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  802d6e:	81 c7 00 10 00 00    	add    $0x1000,%edi
  802d74:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802d7a:	89 fe                	mov    %edi,%esi
  802d7c:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  802d82:	76 69                	jbe    802ded <spawn+0x3a4>
		if (i >= filesz) {
  802d84:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  802d8a:	0f 87 37 ff ff ff    	ja     802cc7 <spawn+0x27e>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802d90:	83 ec 04             	sub    $0x4,%esp
  802d93:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802d99:	53                   	push   %ebx
  802d9a:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802da0:	e8 5b ea ff ff       	call   801800 <sys_page_alloc>
  802da5:	83 c4 10             	add    $0x10,%esp
  802da8:	85 c0                	test   %eax,%eax
  802daa:	79 c2                	jns    802d6e <spawn+0x325>
  802dac:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  802dae:	83 ec 0c             	sub    $0xc,%esp
  802db1:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802db7:	e8 c5 e9 ff ff       	call   801781 <sys_env_destroy>
	close(fd);
  802dbc:	83 c4 04             	add    $0x4,%esp
  802dbf:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802dc5:	e8 ea f4 ff ff       	call   8022b4 <close>
	return r;
  802dca:	83 c4 10             	add    $0x10,%esp
  802dcd:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  802dd3:	e9 b4 01 00 00       	jmp    802f8c <spawn+0x543>
				panic("spawn: sys_page_map data: %e", r);
  802dd8:	50                   	push   %eax
  802dd9:	68 84 44 80 00       	push   $0x804484
  802dde:	68 2b 01 00 00       	push   $0x12b
  802de3:	68 78 44 80 00       	push   $0x804478
  802de8:	e8 dc dc ff ff       	call   800ac9 <_panic>
  802ded:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802df3:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  802dfa:	83 c6 20             	add    $0x20,%esi
  802dfd:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802e04:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  802e0a:	7e 6d                	jle    802e79 <spawn+0x430>
		if (ph->p_type != ELF_PROG_LOAD)
  802e0c:	83 3e 01             	cmpl   $0x1,(%esi)
  802e0f:	75 e2                	jne    802df3 <spawn+0x3aa>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802e11:	8b 46 18             	mov    0x18(%esi),%eax
  802e14:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  802e17:	83 f8 01             	cmp    $0x1,%eax
  802e1a:	19 c0                	sbb    %eax,%eax
  802e1c:	83 e0 fe             	and    $0xfffffffe,%eax
  802e1f:	83 c0 07             	add    $0x7,%eax
  802e22:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802e28:	8b 4e 04             	mov    0x4(%esi),%ecx
  802e2b:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  802e31:	8b 56 10             	mov    0x10(%esi),%edx
  802e34:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  802e3a:	8b 7e 14             	mov    0x14(%esi),%edi
  802e3d:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  802e43:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  802e46:	89 d8                	mov    %ebx,%eax
  802e48:	25 ff 0f 00 00       	and    $0xfff,%eax
  802e4d:	74 1a                	je     802e69 <spawn+0x420>
		va -= i;
  802e4f:	29 c3                	sub    %eax,%ebx
		memsz += i;
  802e51:	01 c7                	add    %eax,%edi
  802e53:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  802e59:	01 c2                	add    %eax,%edx
  802e5b:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  802e61:	29 c1                	sub    %eax,%ecx
  802e63:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  802e69:	bf 00 00 00 00       	mov    $0x0,%edi
  802e6e:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  802e74:	e9 01 ff ff ff       	jmp    802d7a <spawn+0x331>
	close(fd);
  802e79:	83 ec 0c             	sub    $0xc,%esp
  802e7c:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802e82:	e8 2d f4 ff ff       	call   8022b4 <close>

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	cprintf("in %s\n", __FUNCTION__);
  802e87:	83 c4 08             	add    $0x8,%esp
  802e8a:	68 14 45 80 00       	push   $0x804514
  802e8f:	68 dd 3e 80 00       	push   $0x803edd
  802e94:	e8 26 dd ff ff       	call   800bbf <cprintf>
  802e99:	83 c4 10             	add    $0x10,%esp
	int r;
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  802e9c:	bb 00 00 80 00       	mov    $0x800000,%ebx
  802ea1:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  802ea7:	eb 0e                	jmp    802eb7 <spawn+0x46e>
  802ea9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802eaf:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  802eb5:	74 5e                	je     802f15 <spawn+0x4cc>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_SHARE)) == (PTE_P | PTE_U | PTE_SHARE)))
  802eb7:	89 d8                	mov    %ebx,%eax
  802eb9:	c1 e8 16             	shr    $0x16,%eax
  802ebc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802ec3:	a8 01                	test   $0x1,%al
  802ec5:	74 e2                	je     802ea9 <spawn+0x460>
  802ec7:	89 da                	mov    %ebx,%edx
  802ec9:	c1 ea 0c             	shr    $0xc,%edx
  802ecc:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  802ed3:	25 05 04 00 00       	and    $0x405,%eax
  802ed8:	3d 05 04 00 00       	cmp    $0x405,%eax
  802edd:	75 ca                	jne    802ea9 <spawn+0x460>
			if((r = sys_page_map((envid_t)0, (void *)i, child, (void *)i, uvpt[PGNUM(i)] & PTE_SYSCALL)) < 0)
  802edf:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  802ee6:	83 ec 0c             	sub    $0xc,%esp
  802ee9:	25 07 0e 00 00       	and    $0xe07,%eax
  802eee:	50                   	push   %eax
  802eef:	53                   	push   %ebx
  802ef0:	56                   	push   %esi
  802ef1:	53                   	push   %ebx
  802ef2:	6a 00                	push   $0x0
  802ef4:	e8 4a e9 ff ff       	call   801843 <sys_page_map>
  802ef9:	83 c4 20             	add    $0x20,%esp
  802efc:	85 c0                	test   %eax,%eax
  802efe:	79 a9                	jns    802ea9 <spawn+0x460>
        		panic("sys_page_map: %e\n", r);
  802f00:	50                   	push   %eax
  802f01:	68 a1 44 80 00       	push   $0x8044a1
  802f06:	68 3b 01 00 00       	push   $0x13b
  802f0b:	68 78 44 80 00       	push   $0x804478
  802f10:	e8 b4 db ff ff       	call   800ac9 <_panic>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802f15:	83 ec 08             	sub    $0x8,%esp
  802f18:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802f1e:	50                   	push   %eax
  802f1f:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802f25:	e8 df e9 ff ff       	call   801909 <sys_env_set_trapframe>
  802f2a:	83 c4 10             	add    $0x10,%esp
  802f2d:	85 c0                	test   %eax,%eax
  802f2f:	78 25                	js     802f56 <spawn+0x50d>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802f31:	83 ec 08             	sub    $0x8,%esp
  802f34:	6a 02                	push   $0x2
  802f36:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802f3c:	e8 86 e9 ff ff       	call   8018c7 <sys_env_set_status>
  802f41:	83 c4 10             	add    $0x10,%esp
  802f44:	85 c0                	test   %eax,%eax
  802f46:	78 23                	js     802f6b <spawn+0x522>
	return child;
  802f48:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802f4e:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802f54:	eb 36                	jmp    802f8c <spawn+0x543>
		panic("sys_env_set_trapframe: %e", r);
  802f56:	50                   	push   %eax
  802f57:	68 b3 44 80 00       	push   $0x8044b3
  802f5c:	68 8a 00 00 00       	push   $0x8a
  802f61:	68 78 44 80 00       	push   $0x804478
  802f66:	e8 5e db ff ff       	call   800ac9 <_panic>
		panic("sys_env_set_status: %e", r);
  802f6b:	50                   	push   %eax
  802f6c:	68 cd 44 80 00       	push   $0x8044cd
  802f71:	68 8d 00 00 00       	push   $0x8d
  802f76:	68 78 44 80 00       	push   $0x804478
  802f7b:	e8 49 db ff ff       	call   800ac9 <_panic>
		return r;
  802f80:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802f86:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  802f8c:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802f92:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802f95:	5b                   	pop    %ebx
  802f96:	5e                   	pop    %esi
  802f97:	5f                   	pop    %edi
  802f98:	5d                   	pop    %ebp
  802f99:	c3                   	ret    
  802f9a:	89 c7                	mov    %eax,%edi
  802f9c:	e9 0d fe ff ff       	jmp    802dae <spawn+0x365>
  802fa1:	89 c7                	mov    %eax,%edi
  802fa3:	e9 06 fe ff ff       	jmp    802dae <spawn+0x365>
  802fa8:	89 c7                	mov    %eax,%edi
  802faa:	e9 ff fd ff ff       	jmp    802dae <spawn+0x365>
		return -E_NO_MEM;
  802faf:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  802fb4:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802fba:	eb d0                	jmp    802f8c <spawn+0x543>
	sys_page_unmap(0, UTEMP);
  802fbc:	83 ec 08             	sub    $0x8,%esp
  802fbf:	68 00 00 40 00       	push   $0x400000
  802fc4:	6a 00                	push   $0x0
  802fc6:	e8 ba e8 ff ff       	call   801885 <sys_page_unmap>
  802fcb:	83 c4 10             	add    $0x10,%esp
  802fce:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  802fd4:	eb b6                	jmp    802f8c <spawn+0x543>

00802fd6 <spawnl>:
{
  802fd6:	55                   	push   %ebp
  802fd7:	89 e5                	mov    %esp,%ebp
  802fd9:	57                   	push   %edi
  802fda:	56                   	push   %esi
  802fdb:	53                   	push   %ebx
  802fdc:	83 ec 14             	sub    $0x14,%esp
	cprintf("in %s\n", __FUNCTION__);
  802fdf:	68 0c 45 80 00       	push   $0x80450c
  802fe4:	68 dd 3e 80 00       	push   $0x803edd
  802fe9:	e8 d1 db ff ff       	call   800bbf <cprintf>
	va_start(vl, arg0);
  802fee:	8d 55 10             	lea    0x10(%ebp),%edx
	while(va_arg(vl, void *) != NULL)
  802ff1:	83 c4 10             	add    $0x10,%esp
	int argc=0;
  802ff4:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  802ff9:	8d 4a 04             	lea    0x4(%edx),%ecx
  802ffc:	83 3a 00             	cmpl   $0x0,(%edx)
  802fff:	74 07                	je     803008 <spawnl+0x32>
		argc++;
  803001:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  803004:	89 ca                	mov    %ecx,%edx
  803006:	eb f1                	jmp    802ff9 <spawnl+0x23>
	const char *argv[argc+2];
  803008:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  80300f:	83 e2 f0             	and    $0xfffffff0,%edx
  803012:	29 d4                	sub    %edx,%esp
  803014:	8d 54 24 03          	lea    0x3(%esp),%edx
  803018:	c1 ea 02             	shr    $0x2,%edx
  80301b:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  803022:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  803024:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803027:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  80302e:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  803035:	00 
	va_start(vl, arg0);
  803036:	8d 4d 10             	lea    0x10(%ebp),%ecx
  803039:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  80303b:	b8 00 00 00 00       	mov    $0x0,%eax
  803040:	eb 0b                	jmp    80304d <spawnl+0x77>
		argv[i+1] = va_arg(vl, const char *);
  803042:	83 c0 01             	add    $0x1,%eax
  803045:	8b 39                	mov    (%ecx),%edi
  803047:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  80304a:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  80304d:	39 d0                	cmp    %edx,%eax
  80304f:	75 f1                	jne    803042 <spawnl+0x6c>
	return spawn(prog, argv);
  803051:	83 ec 08             	sub    $0x8,%esp
  803054:	56                   	push   %esi
  803055:	ff 75 08             	pushl  0x8(%ebp)
  803058:	e8 ec f9 ff ff       	call   802a49 <spawn>
}
  80305d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803060:	5b                   	pop    %ebx
  803061:	5e                   	pop    %esi
  803062:	5f                   	pop    %edi
  803063:	5d                   	pop    %ebp
  803064:	c3                   	ret    

00803065 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803065:	55                   	push   %ebp
  803066:	89 e5                	mov    %esp,%ebp
  803068:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80306b:	68 3a 45 80 00       	push   $0x80453a
  803070:	ff 75 0c             	pushl  0xc(%ebp)
  803073:	e8 96 e3 ff ff       	call   80140e <strcpy>
	return 0;
}
  803078:	b8 00 00 00 00       	mov    $0x0,%eax
  80307d:	c9                   	leave  
  80307e:	c3                   	ret    

0080307f <devsock_close>:
{
  80307f:	55                   	push   %ebp
  803080:	89 e5                	mov    %esp,%ebp
  803082:	53                   	push   %ebx
  803083:	83 ec 10             	sub    $0x10,%esp
  803086:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  803089:	53                   	push   %ebx
  80308a:	e8 6b 09 00 00       	call   8039fa <pageref>
  80308f:	83 c4 10             	add    $0x10,%esp
		return 0;
  803092:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  803097:	83 f8 01             	cmp    $0x1,%eax
  80309a:	74 07                	je     8030a3 <devsock_close+0x24>
}
  80309c:	89 d0                	mov    %edx,%eax
  80309e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8030a1:	c9                   	leave  
  8030a2:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8030a3:	83 ec 0c             	sub    $0xc,%esp
  8030a6:	ff 73 0c             	pushl  0xc(%ebx)
  8030a9:	e8 b9 02 00 00       	call   803367 <nsipc_close>
  8030ae:	89 c2                	mov    %eax,%edx
  8030b0:	83 c4 10             	add    $0x10,%esp
  8030b3:	eb e7                	jmp    80309c <devsock_close+0x1d>

008030b5 <devsock_write>:
{
  8030b5:	55                   	push   %ebp
  8030b6:	89 e5                	mov    %esp,%ebp
  8030b8:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8030bb:	6a 00                	push   $0x0
  8030bd:	ff 75 10             	pushl  0x10(%ebp)
  8030c0:	ff 75 0c             	pushl  0xc(%ebp)
  8030c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c6:	ff 70 0c             	pushl  0xc(%eax)
  8030c9:	e8 76 03 00 00       	call   803444 <nsipc_send>
}
  8030ce:	c9                   	leave  
  8030cf:	c3                   	ret    

008030d0 <devsock_read>:
{
  8030d0:	55                   	push   %ebp
  8030d1:	89 e5                	mov    %esp,%ebp
  8030d3:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8030d6:	6a 00                	push   $0x0
  8030d8:	ff 75 10             	pushl  0x10(%ebp)
  8030db:	ff 75 0c             	pushl  0xc(%ebp)
  8030de:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e1:	ff 70 0c             	pushl  0xc(%eax)
  8030e4:	e8 ef 02 00 00       	call   8033d8 <nsipc_recv>
}
  8030e9:	c9                   	leave  
  8030ea:	c3                   	ret    

008030eb <fd2sockid>:
{
  8030eb:	55                   	push   %ebp
  8030ec:	89 e5                	mov    %esp,%ebp
  8030ee:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8030f1:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8030f4:	52                   	push   %edx
  8030f5:	50                   	push   %eax
  8030f6:	e8 87 f0 ff ff       	call   802182 <fd_lookup>
  8030fb:	83 c4 10             	add    $0x10,%esp
  8030fe:	85 c0                	test   %eax,%eax
  803100:	78 10                	js     803112 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  803102:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803105:	8b 0d 3c 50 80 00    	mov    0x80503c,%ecx
  80310b:	39 08                	cmp    %ecx,(%eax)
  80310d:	75 05                	jne    803114 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80310f:	8b 40 0c             	mov    0xc(%eax),%eax
}
  803112:	c9                   	leave  
  803113:	c3                   	ret    
		return -E_NOT_SUPP;
  803114:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803119:	eb f7                	jmp    803112 <fd2sockid+0x27>

0080311b <alloc_sockfd>:
{
  80311b:	55                   	push   %ebp
  80311c:	89 e5                	mov    %esp,%ebp
  80311e:	56                   	push   %esi
  80311f:	53                   	push   %ebx
  803120:	83 ec 1c             	sub    $0x1c,%esp
  803123:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  803125:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803128:	50                   	push   %eax
  803129:	e8 02 f0 ff ff       	call   802130 <fd_alloc>
  80312e:	89 c3                	mov    %eax,%ebx
  803130:	83 c4 10             	add    $0x10,%esp
  803133:	85 c0                	test   %eax,%eax
  803135:	78 43                	js     80317a <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803137:	83 ec 04             	sub    $0x4,%esp
  80313a:	68 07 04 00 00       	push   $0x407
  80313f:	ff 75 f4             	pushl  -0xc(%ebp)
  803142:	6a 00                	push   $0x0
  803144:	e8 b7 e6 ff ff       	call   801800 <sys_page_alloc>
  803149:	89 c3                	mov    %eax,%ebx
  80314b:	83 c4 10             	add    $0x10,%esp
  80314e:	85 c0                	test   %eax,%eax
  803150:	78 28                	js     80317a <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  803152:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803155:	8b 15 3c 50 80 00    	mov    0x80503c,%edx
  80315b:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80315d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803160:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  803167:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80316a:	83 ec 0c             	sub    $0xc,%esp
  80316d:	50                   	push   %eax
  80316e:	e8 96 ef ff ff       	call   802109 <fd2num>
  803173:	89 c3                	mov    %eax,%ebx
  803175:	83 c4 10             	add    $0x10,%esp
  803178:	eb 0c                	jmp    803186 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80317a:	83 ec 0c             	sub    $0xc,%esp
  80317d:	56                   	push   %esi
  80317e:	e8 e4 01 00 00       	call   803367 <nsipc_close>
		return r;
  803183:	83 c4 10             	add    $0x10,%esp
}
  803186:	89 d8                	mov    %ebx,%eax
  803188:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80318b:	5b                   	pop    %ebx
  80318c:	5e                   	pop    %esi
  80318d:	5d                   	pop    %ebp
  80318e:	c3                   	ret    

0080318f <accept>:
{
  80318f:	55                   	push   %ebp
  803190:	89 e5                	mov    %esp,%ebp
  803192:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  803195:	8b 45 08             	mov    0x8(%ebp),%eax
  803198:	e8 4e ff ff ff       	call   8030eb <fd2sockid>
  80319d:	85 c0                	test   %eax,%eax
  80319f:	78 1b                	js     8031bc <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8031a1:	83 ec 04             	sub    $0x4,%esp
  8031a4:	ff 75 10             	pushl  0x10(%ebp)
  8031a7:	ff 75 0c             	pushl  0xc(%ebp)
  8031aa:	50                   	push   %eax
  8031ab:	e8 0e 01 00 00       	call   8032be <nsipc_accept>
  8031b0:	83 c4 10             	add    $0x10,%esp
  8031b3:	85 c0                	test   %eax,%eax
  8031b5:	78 05                	js     8031bc <accept+0x2d>
	return alloc_sockfd(r);
  8031b7:	e8 5f ff ff ff       	call   80311b <alloc_sockfd>
}
  8031bc:	c9                   	leave  
  8031bd:	c3                   	ret    

008031be <bind>:
{
  8031be:	55                   	push   %ebp
  8031bf:	89 e5                	mov    %esp,%ebp
  8031c1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8031c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c7:	e8 1f ff ff ff       	call   8030eb <fd2sockid>
  8031cc:	85 c0                	test   %eax,%eax
  8031ce:	78 12                	js     8031e2 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8031d0:	83 ec 04             	sub    $0x4,%esp
  8031d3:	ff 75 10             	pushl  0x10(%ebp)
  8031d6:	ff 75 0c             	pushl  0xc(%ebp)
  8031d9:	50                   	push   %eax
  8031da:	e8 31 01 00 00       	call   803310 <nsipc_bind>
  8031df:	83 c4 10             	add    $0x10,%esp
}
  8031e2:	c9                   	leave  
  8031e3:	c3                   	ret    

008031e4 <shutdown>:
{
  8031e4:	55                   	push   %ebp
  8031e5:	89 e5                	mov    %esp,%ebp
  8031e7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8031ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ed:	e8 f9 fe ff ff       	call   8030eb <fd2sockid>
  8031f2:	85 c0                	test   %eax,%eax
  8031f4:	78 0f                	js     803205 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8031f6:	83 ec 08             	sub    $0x8,%esp
  8031f9:	ff 75 0c             	pushl  0xc(%ebp)
  8031fc:	50                   	push   %eax
  8031fd:	e8 43 01 00 00       	call   803345 <nsipc_shutdown>
  803202:	83 c4 10             	add    $0x10,%esp
}
  803205:	c9                   	leave  
  803206:	c3                   	ret    

00803207 <connect>:
{
  803207:	55                   	push   %ebp
  803208:	89 e5                	mov    %esp,%ebp
  80320a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80320d:	8b 45 08             	mov    0x8(%ebp),%eax
  803210:	e8 d6 fe ff ff       	call   8030eb <fd2sockid>
  803215:	85 c0                	test   %eax,%eax
  803217:	78 12                	js     80322b <connect+0x24>
	return nsipc_connect(r, name, namelen);
  803219:	83 ec 04             	sub    $0x4,%esp
  80321c:	ff 75 10             	pushl  0x10(%ebp)
  80321f:	ff 75 0c             	pushl  0xc(%ebp)
  803222:	50                   	push   %eax
  803223:	e8 59 01 00 00       	call   803381 <nsipc_connect>
  803228:	83 c4 10             	add    $0x10,%esp
}
  80322b:	c9                   	leave  
  80322c:	c3                   	ret    

0080322d <listen>:
{
  80322d:	55                   	push   %ebp
  80322e:	89 e5                	mov    %esp,%ebp
  803230:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  803233:	8b 45 08             	mov    0x8(%ebp),%eax
  803236:	e8 b0 fe ff ff       	call   8030eb <fd2sockid>
  80323b:	85 c0                	test   %eax,%eax
  80323d:	78 0f                	js     80324e <listen+0x21>
	return nsipc_listen(r, backlog);
  80323f:	83 ec 08             	sub    $0x8,%esp
  803242:	ff 75 0c             	pushl  0xc(%ebp)
  803245:	50                   	push   %eax
  803246:	e8 6b 01 00 00       	call   8033b6 <nsipc_listen>
  80324b:	83 c4 10             	add    $0x10,%esp
}
  80324e:	c9                   	leave  
  80324f:	c3                   	ret    

00803250 <socket>:

int
socket(int domain, int type, int protocol)
{
  803250:	55                   	push   %ebp
  803251:	89 e5                	mov    %esp,%ebp
  803253:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803256:	ff 75 10             	pushl  0x10(%ebp)
  803259:	ff 75 0c             	pushl  0xc(%ebp)
  80325c:	ff 75 08             	pushl  0x8(%ebp)
  80325f:	e8 3e 02 00 00       	call   8034a2 <nsipc_socket>
  803264:	83 c4 10             	add    $0x10,%esp
  803267:	85 c0                	test   %eax,%eax
  803269:	78 05                	js     803270 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80326b:	e8 ab fe ff ff       	call   80311b <alloc_sockfd>
}
  803270:	c9                   	leave  
  803271:	c3                   	ret    

00803272 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803272:	55                   	push   %ebp
  803273:	89 e5                	mov    %esp,%ebp
  803275:	53                   	push   %ebx
  803276:	83 ec 04             	sub    $0x4,%esp
  803279:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80327b:	83 3d 24 64 80 00 00 	cmpl   $0x0,0x806424
  803282:	74 26                	je     8032aa <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803284:	6a 07                	push   $0x7
  803286:	68 00 80 80 00       	push   $0x808000
  80328b:	53                   	push   %ebx
  80328c:	ff 35 24 64 80 00    	pushl  0x806424
  803292:	e8 d0 06 00 00       	call   803967 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  803297:	83 c4 0c             	add    $0xc,%esp
  80329a:	6a 00                	push   $0x0
  80329c:	6a 00                	push   $0x0
  80329e:	6a 00                	push   $0x0
  8032a0:	e8 59 06 00 00       	call   8038fe <ipc_recv>
}
  8032a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8032a8:	c9                   	leave  
  8032a9:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8032aa:	83 ec 0c             	sub    $0xc,%esp
  8032ad:	6a 02                	push   $0x2
  8032af:	e8 0b 07 00 00       	call   8039bf <ipc_find_env>
  8032b4:	a3 24 64 80 00       	mov    %eax,0x806424
  8032b9:	83 c4 10             	add    $0x10,%esp
  8032bc:	eb c6                	jmp    803284 <nsipc+0x12>

008032be <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8032be:	55                   	push   %ebp
  8032bf:	89 e5                	mov    %esp,%ebp
  8032c1:	56                   	push   %esi
  8032c2:	53                   	push   %ebx
  8032c3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8032c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c9:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8032ce:	8b 06                	mov    (%esi),%eax
  8032d0:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8032d5:	b8 01 00 00 00       	mov    $0x1,%eax
  8032da:	e8 93 ff ff ff       	call   803272 <nsipc>
  8032df:	89 c3                	mov    %eax,%ebx
  8032e1:	85 c0                	test   %eax,%eax
  8032e3:	79 09                	jns    8032ee <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8032e5:	89 d8                	mov    %ebx,%eax
  8032e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8032ea:	5b                   	pop    %ebx
  8032eb:	5e                   	pop    %esi
  8032ec:	5d                   	pop    %ebp
  8032ed:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8032ee:	83 ec 04             	sub    $0x4,%esp
  8032f1:	ff 35 10 80 80 00    	pushl  0x808010
  8032f7:	68 00 80 80 00       	push   $0x808000
  8032fc:	ff 75 0c             	pushl  0xc(%ebp)
  8032ff:	e8 98 e2 ff ff       	call   80159c <memmove>
		*addrlen = ret->ret_addrlen;
  803304:	a1 10 80 80 00       	mov    0x808010,%eax
  803309:	89 06                	mov    %eax,(%esi)
  80330b:	83 c4 10             	add    $0x10,%esp
	return r;
  80330e:	eb d5                	jmp    8032e5 <nsipc_accept+0x27>

00803310 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803310:	55                   	push   %ebp
  803311:	89 e5                	mov    %esp,%ebp
  803313:	53                   	push   %ebx
  803314:	83 ec 08             	sub    $0x8,%esp
  803317:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80331a:	8b 45 08             	mov    0x8(%ebp),%eax
  80331d:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803322:	53                   	push   %ebx
  803323:	ff 75 0c             	pushl  0xc(%ebp)
  803326:	68 04 80 80 00       	push   $0x808004
  80332b:	e8 6c e2 ff ff       	call   80159c <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  803330:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  803336:	b8 02 00 00 00       	mov    $0x2,%eax
  80333b:	e8 32 ff ff ff       	call   803272 <nsipc>
}
  803340:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803343:	c9                   	leave  
  803344:	c3                   	ret    

00803345 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803345:	55                   	push   %ebp
  803346:	89 e5                	mov    %esp,%ebp
  803348:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80334b:	8b 45 08             	mov    0x8(%ebp),%eax
  80334e:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  803353:	8b 45 0c             	mov    0xc(%ebp),%eax
  803356:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  80335b:	b8 03 00 00 00       	mov    $0x3,%eax
  803360:	e8 0d ff ff ff       	call   803272 <nsipc>
}
  803365:	c9                   	leave  
  803366:	c3                   	ret    

00803367 <nsipc_close>:

int
nsipc_close(int s)
{
  803367:	55                   	push   %ebp
  803368:	89 e5                	mov    %esp,%ebp
  80336a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80336d:	8b 45 08             	mov    0x8(%ebp),%eax
  803370:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  803375:	b8 04 00 00 00       	mov    $0x4,%eax
  80337a:	e8 f3 fe ff ff       	call   803272 <nsipc>
}
  80337f:	c9                   	leave  
  803380:	c3                   	ret    

00803381 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803381:	55                   	push   %ebp
  803382:	89 e5                	mov    %esp,%ebp
  803384:	53                   	push   %ebx
  803385:	83 ec 08             	sub    $0x8,%esp
  803388:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80338b:	8b 45 08             	mov    0x8(%ebp),%eax
  80338e:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803393:	53                   	push   %ebx
  803394:	ff 75 0c             	pushl  0xc(%ebp)
  803397:	68 04 80 80 00       	push   $0x808004
  80339c:	e8 fb e1 ff ff       	call   80159c <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8033a1:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  8033a7:	b8 05 00 00 00       	mov    $0x5,%eax
  8033ac:	e8 c1 fe ff ff       	call   803272 <nsipc>
}
  8033b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8033b4:	c9                   	leave  
  8033b5:	c3                   	ret    

008033b6 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8033b6:	55                   	push   %ebp
  8033b7:	89 e5                	mov    %esp,%ebp
  8033b9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8033bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bf:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  8033c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033c7:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  8033cc:	b8 06 00 00 00       	mov    $0x6,%eax
  8033d1:	e8 9c fe ff ff       	call   803272 <nsipc>
}
  8033d6:	c9                   	leave  
  8033d7:	c3                   	ret    

008033d8 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8033d8:	55                   	push   %ebp
  8033d9:	89 e5                	mov    %esp,%ebp
  8033db:	56                   	push   %esi
  8033dc:	53                   	push   %ebx
  8033dd:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8033e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e3:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  8033e8:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  8033ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8033f1:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8033f6:	b8 07 00 00 00       	mov    $0x7,%eax
  8033fb:	e8 72 fe ff ff       	call   803272 <nsipc>
  803400:	89 c3                	mov    %eax,%ebx
  803402:	85 c0                	test   %eax,%eax
  803404:	78 1f                	js     803425 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  803406:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80340b:	7f 21                	jg     80342e <nsipc_recv+0x56>
  80340d:	39 c6                	cmp    %eax,%esi
  80340f:	7c 1d                	jl     80342e <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803411:	83 ec 04             	sub    $0x4,%esp
  803414:	50                   	push   %eax
  803415:	68 00 80 80 00       	push   $0x808000
  80341a:	ff 75 0c             	pushl  0xc(%ebp)
  80341d:	e8 7a e1 ff ff       	call   80159c <memmove>
  803422:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  803425:	89 d8                	mov    %ebx,%eax
  803427:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80342a:	5b                   	pop    %ebx
  80342b:	5e                   	pop    %esi
  80342c:	5d                   	pop    %ebp
  80342d:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80342e:	68 46 45 80 00       	push   $0x804546
  803433:	68 ef 3d 80 00       	push   $0x803def
  803438:	6a 62                	push   $0x62
  80343a:	68 5b 45 80 00       	push   $0x80455b
  80343f:	e8 85 d6 ff ff       	call   800ac9 <_panic>

00803444 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803444:	55                   	push   %ebp
  803445:	89 e5                	mov    %esp,%ebp
  803447:	53                   	push   %ebx
  803448:	83 ec 04             	sub    $0x4,%esp
  80344b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80344e:	8b 45 08             	mov    0x8(%ebp),%eax
  803451:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  803456:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80345c:	7f 2e                	jg     80348c <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80345e:	83 ec 04             	sub    $0x4,%esp
  803461:	53                   	push   %ebx
  803462:	ff 75 0c             	pushl  0xc(%ebp)
  803465:	68 0c 80 80 00       	push   $0x80800c
  80346a:	e8 2d e1 ff ff       	call   80159c <memmove>
	nsipcbuf.send.req_size = size;
  80346f:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  803475:	8b 45 14             	mov    0x14(%ebp),%eax
  803478:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  80347d:	b8 08 00 00 00       	mov    $0x8,%eax
  803482:	e8 eb fd ff ff       	call   803272 <nsipc>
}
  803487:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80348a:	c9                   	leave  
  80348b:	c3                   	ret    
	assert(size < 1600);
  80348c:	68 67 45 80 00       	push   $0x804567
  803491:	68 ef 3d 80 00       	push   $0x803def
  803496:	6a 6d                	push   $0x6d
  803498:	68 5b 45 80 00       	push   $0x80455b
  80349d:	e8 27 d6 ff ff       	call   800ac9 <_panic>

008034a2 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8034a2:	55                   	push   %ebp
  8034a3:	89 e5                	mov    %esp,%ebp
  8034a5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8034a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ab:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  8034b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034b3:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  8034b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8034bb:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  8034c0:	b8 09 00 00 00       	mov    $0x9,%eax
  8034c5:	e8 a8 fd ff ff       	call   803272 <nsipc>
}
  8034ca:	c9                   	leave  
  8034cb:	c3                   	ret    

008034cc <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8034cc:	55                   	push   %ebp
  8034cd:	89 e5                	mov    %esp,%ebp
  8034cf:	56                   	push   %esi
  8034d0:	53                   	push   %ebx
  8034d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8034d4:	83 ec 0c             	sub    $0xc,%esp
  8034d7:	ff 75 08             	pushl  0x8(%ebp)
  8034da:	e8 3a ec ff ff       	call   802119 <fd2data>
  8034df:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8034e1:	83 c4 08             	add    $0x8,%esp
  8034e4:	68 73 45 80 00       	push   $0x804573
  8034e9:	53                   	push   %ebx
  8034ea:	e8 1f df ff ff       	call   80140e <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8034ef:	8b 46 04             	mov    0x4(%esi),%eax
  8034f2:	2b 06                	sub    (%esi),%eax
  8034f4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8034fa:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  803501:	00 00 00 
	stat->st_dev = &devpipe;
  803504:	c7 83 88 00 00 00 58 	movl   $0x805058,0x88(%ebx)
  80350b:	50 80 00 
	return 0;
}
  80350e:	b8 00 00 00 00       	mov    $0x0,%eax
  803513:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803516:	5b                   	pop    %ebx
  803517:	5e                   	pop    %esi
  803518:	5d                   	pop    %ebp
  803519:	c3                   	ret    

0080351a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80351a:	55                   	push   %ebp
  80351b:	89 e5                	mov    %esp,%ebp
  80351d:	53                   	push   %ebx
  80351e:	83 ec 0c             	sub    $0xc,%esp
  803521:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  803524:	53                   	push   %ebx
  803525:	6a 00                	push   $0x0
  803527:	e8 59 e3 ff ff       	call   801885 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80352c:	89 1c 24             	mov    %ebx,(%esp)
  80352f:	e8 e5 eb ff ff       	call   802119 <fd2data>
  803534:	83 c4 08             	add    $0x8,%esp
  803537:	50                   	push   %eax
  803538:	6a 00                	push   $0x0
  80353a:	e8 46 e3 ff ff       	call   801885 <sys_page_unmap>
}
  80353f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803542:	c9                   	leave  
  803543:	c3                   	ret    

00803544 <_pipeisclosed>:
{
  803544:	55                   	push   %ebp
  803545:	89 e5                	mov    %esp,%ebp
  803547:	57                   	push   %edi
  803548:	56                   	push   %esi
  803549:	53                   	push   %ebx
  80354a:	83 ec 1c             	sub    $0x1c,%esp
  80354d:	89 c7                	mov    %eax,%edi
  80354f:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  803551:	a1 28 64 80 00       	mov    0x806428,%eax
  803556:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  803559:	83 ec 0c             	sub    $0xc,%esp
  80355c:	57                   	push   %edi
  80355d:	e8 98 04 00 00       	call   8039fa <pageref>
  803562:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803565:	89 34 24             	mov    %esi,(%esp)
  803568:	e8 8d 04 00 00       	call   8039fa <pageref>
		nn = thisenv->env_runs;
  80356d:	8b 15 28 64 80 00    	mov    0x806428,%edx
  803573:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  803576:	83 c4 10             	add    $0x10,%esp
  803579:	39 cb                	cmp    %ecx,%ebx
  80357b:	74 1b                	je     803598 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80357d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  803580:	75 cf                	jne    803551 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803582:	8b 42 58             	mov    0x58(%edx),%eax
  803585:	6a 01                	push   $0x1
  803587:	50                   	push   %eax
  803588:	53                   	push   %ebx
  803589:	68 7a 45 80 00       	push   $0x80457a
  80358e:	e8 2c d6 ff ff       	call   800bbf <cprintf>
  803593:	83 c4 10             	add    $0x10,%esp
  803596:	eb b9                	jmp    803551 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  803598:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80359b:	0f 94 c0             	sete   %al
  80359e:	0f b6 c0             	movzbl %al,%eax
}
  8035a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8035a4:	5b                   	pop    %ebx
  8035a5:	5e                   	pop    %esi
  8035a6:	5f                   	pop    %edi
  8035a7:	5d                   	pop    %ebp
  8035a8:	c3                   	ret    

008035a9 <devpipe_write>:
{
  8035a9:	55                   	push   %ebp
  8035aa:	89 e5                	mov    %esp,%ebp
  8035ac:	57                   	push   %edi
  8035ad:	56                   	push   %esi
  8035ae:	53                   	push   %ebx
  8035af:	83 ec 28             	sub    $0x28,%esp
  8035b2:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8035b5:	56                   	push   %esi
  8035b6:	e8 5e eb ff ff       	call   802119 <fd2data>
  8035bb:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8035bd:	83 c4 10             	add    $0x10,%esp
  8035c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8035c5:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8035c8:	74 4f                	je     803619 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8035ca:	8b 43 04             	mov    0x4(%ebx),%eax
  8035cd:	8b 0b                	mov    (%ebx),%ecx
  8035cf:	8d 51 20             	lea    0x20(%ecx),%edx
  8035d2:	39 d0                	cmp    %edx,%eax
  8035d4:	72 14                	jb     8035ea <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8035d6:	89 da                	mov    %ebx,%edx
  8035d8:	89 f0                	mov    %esi,%eax
  8035da:	e8 65 ff ff ff       	call   803544 <_pipeisclosed>
  8035df:	85 c0                	test   %eax,%eax
  8035e1:	75 3b                	jne    80361e <devpipe_write+0x75>
			sys_yield();
  8035e3:	e8 f9 e1 ff ff       	call   8017e1 <sys_yield>
  8035e8:	eb e0                	jmp    8035ca <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8035ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8035ed:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8035f1:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8035f4:	89 c2                	mov    %eax,%edx
  8035f6:	c1 fa 1f             	sar    $0x1f,%edx
  8035f9:	89 d1                	mov    %edx,%ecx
  8035fb:	c1 e9 1b             	shr    $0x1b,%ecx
  8035fe:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  803601:	83 e2 1f             	and    $0x1f,%edx
  803604:	29 ca                	sub    %ecx,%edx
  803606:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80360a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80360e:	83 c0 01             	add    $0x1,%eax
  803611:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  803614:	83 c7 01             	add    $0x1,%edi
  803617:	eb ac                	jmp    8035c5 <devpipe_write+0x1c>
	return i;
  803619:	8b 45 10             	mov    0x10(%ebp),%eax
  80361c:	eb 05                	jmp    803623 <devpipe_write+0x7a>
				return 0;
  80361e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803623:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803626:	5b                   	pop    %ebx
  803627:	5e                   	pop    %esi
  803628:	5f                   	pop    %edi
  803629:	5d                   	pop    %ebp
  80362a:	c3                   	ret    

0080362b <devpipe_read>:
{
  80362b:	55                   	push   %ebp
  80362c:	89 e5                	mov    %esp,%ebp
  80362e:	57                   	push   %edi
  80362f:	56                   	push   %esi
  803630:	53                   	push   %ebx
  803631:	83 ec 18             	sub    $0x18,%esp
  803634:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  803637:	57                   	push   %edi
  803638:	e8 dc ea ff ff       	call   802119 <fd2data>
  80363d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80363f:	83 c4 10             	add    $0x10,%esp
  803642:	be 00 00 00 00       	mov    $0x0,%esi
  803647:	3b 75 10             	cmp    0x10(%ebp),%esi
  80364a:	75 14                	jne    803660 <devpipe_read+0x35>
	return i;
  80364c:	8b 45 10             	mov    0x10(%ebp),%eax
  80364f:	eb 02                	jmp    803653 <devpipe_read+0x28>
				return i;
  803651:	89 f0                	mov    %esi,%eax
}
  803653:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803656:	5b                   	pop    %ebx
  803657:	5e                   	pop    %esi
  803658:	5f                   	pop    %edi
  803659:	5d                   	pop    %ebp
  80365a:	c3                   	ret    
			sys_yield();
  80365b:	e8 81 e1 ff ff       	call   8017e1 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  803660:	8b 03                	mov    (%ebx),%eax
  803662:	3b 43 04             	cmp    0x4(%ebx),%eax
  803665:	75 18                	jne    80367f <devpipe_read+0x54>
			if (i > 0)
  803667:	85 f6                	test   %esi,%esi
  803669:	75 e6                	jne    803651 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80366b:	89 da                	mov    %ebx,%edx
  80366d:	89 f8                	mov    %edi,%eax
  80366f:	e8 d0 fe ff ff       	call   803544 <_pipeisclosed>
  803674:	85 c0                	test   %eax,%eax
  803676:	74 e3                	je     80365b <devpipe_read+0x30>
				return 0;
  803678:	b8 00 00 00 00       	mov    $0x0,%eax
  80367d:	eb d4                	jmp    803653 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80367f:	99                   	cltd   
  803680:	c1 ea 1b             	shr    $0x1b,%edx
  803683:	01 d0                	add    %edx,%eax
  803685:	83 e0 1f             	and    $0x1f,%eax
  803688:	29 d0                	sub    %edx,%eax
  80368a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80368f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803692:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  803695:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  803698:	83 c6 01             	add    $0x1,%esi
  80369b:	eb aa                	jmp    803647 <devpipe_read+0x1c>

0080369d <pipe>:
{
  80369d:	55                   	push   %ebp
  80369e:	89 e5                	mov    %esp,%ebp
  8036a0:	56                   	push   %esi
  8036a1:	53                   	push   %ebx
  8036a2:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8036a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8036a8:	50                   	push   %eax
  8036a9:	e8 82 ea ff ff       	call   802130 <fd_alloc>
  8036ae:	89 c3                	mov    %eax,%ebx
  8036b0:	83 c4 10             	add    $0x10,%esp
  8036b3:	85 c0                	test   %eax,%eax
  8036b5:	0f 88 23 01 00 00    	js     8037de <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036bb:	83 ec 04             	sub    $0x4,%esp
  8036be:	68 07 04 00 00       	push   $0x407
  8036c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8036c6:	6a 00                	push   $0x0
  8036c8:	e8 33 e1 ff ff       	call   801800 <sys_page_alloc>
  8036cd:	89 c3                	mov    %eax,%ebx
  8036cf:	83 c4 10             	add    $0x10,%esp
  8036d2:	85 c0                	test   %eax,%eax
  8036d4:	0f 88 04 01 00 00    	js     8037de <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8036da:	83 ec 0c             	sub    $0xc,%esp
  8036dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8036e0:	50                   	push   %eax
  8036e1:	e8 4a ea ff ff       	call   802130 <fd_alloc>
  8036e6:	89 c3                	mov    %eax,%ebx
  8036e8:	83 c4 10             	add    $0x10,%esp
  8036eb:	85 c0                	test   %eax,%eax
  8036ed:	0f 88 db 00 00 00    	js     8037ce <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036f3:	83 ec 04             	sub    $0x4,%esp
  8036f6:	68 07 04 00 00       	push   $0x407
  8036fb:	ff 75 f0             	pushl  -0x10(%ebp)
  8036fe:	6a 00                	push   $0x0
  803700:	e8 fb e0 ff ff       	call   801800 <sys_page_alloc>
  803705:	89 c3                	mov    %eax,%ebx
  803707:	83 c4 10             	add    $0x10,%esp
  80370a:	85 c0                	test   %eax,%eax
  80370c:	0f 88 bc 00 00 00    	js     8037ce <pipe+0x131>
	va = fd2data(fd0);
  803712:	83 ec 0c             	sub    $0xc,%esp
  803715:	ff 75 f4             	pushl  -0xc(%ebp)
  803718:	e8 fc e9 ff ff       	call   802119 <fd2data>
  80371d:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80371f:	83 c4 0c             	add    $0xc,%esp
  803722:	68 07 04 00 00       	push   $0x407
  803727:	50                   	push   %eax
  803728:	6a 00                	push   $0x0
  80372a:	e8 d1 e0 ff ff       	call   801800 <sys_page_alloc>
  80372f:	89 c3                	mov    %eax,%ebx
  803731:	83 c4 10             	add    $0x10,%esp
  803734:	85 c0                	test   %eax,%eax
  803736:	0f 88 82 00 00 00    	js     8037be <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80373c:	83 ec 0c             	sub    $0xc,%esp
  80373f:	ff 75 f0             	pushl  -0x10(%ebp)
  803742:	e8 d2 e9 ff ff       	call   802119 <fd2data>
  803747:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80374e:	50                   	push   %eax
  80374f:	6a 00                	push   $0x0
  803751:	56                   	push   %esi
  803752:	6a 00                	push   $0x0
  803754:	e8 ea e0 ff ff       	call   801843 <sys_page_map>
  803759:	89 c3                	mov    %eax,%ebx
  80375b:	83 c4 20             	add    $0x20,%esp
  80375e:	85 c0                	test   %eax,%eax
  803760:	78 4e                	js     8037b0 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  803762:	a1 58 50 80 00       	mov    0x805058,%eax
  803767:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80376a:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80376c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80376f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  803776:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803779:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80377b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80377e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  803785:	83 ec 0c             	sub    $0xc,%esp
  803788:	ff 75 f4             	pushl  -0xc(%ebp)
  80378b:	e8 79 e9 ff ff       	call   802109 <fd2num>
  803790:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803793:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  803795:	83 c4 04             	add    $0x4,%esp
  803798:	ff 75 f0             	pushl  -0x10(%ebp)
  80379b:	e8 69 e9 ff ff       	call   802109 <fd2num>
  8037a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8037a3:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8037a6:	83 c4 10             	add    $0x10,%esp
  8037a9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8037ae:	eb 2e                	jmp    8037de <pipe+0x141>
	sys_page_unmap(0, va);
  8037b0:	83 ec 08             	sub    $0x8,%esp
  8037b3:	56                   	push   %esi
  8037b4:	6a 00                	push   $0x0
  8037b6:	e8 ca e0 ff ff       	call   801885 <sys_page_unmap>
  8037bb:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8037be:	83 ec 08             	sub    $0x8,%esp
  8037c1:	ff 75 f0             	pushl  -0x10(%ebp)
  8037c4:	6a 00                	push   $0x0
  8037c6:	e8 ba e0 ff ff       	call   801885 <sys_page_unmap>
  8037cb:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8037ce:	83 ec 08             	sub    $0x8,%esp
  8037d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8037d4:	6a 00                	push   $0x0
  8037d6:	e8 aa e0 ff ff       	call   801885 <sys_page_unmap>
  8037db:	83 c4 10             	add    $0x10,%esp
}
  8037de:	89 d8                	mov    %ebx,%eax
  8037e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8037e3:	5b                   	pop    %ebx
  8037e4:	5e                   	pop    %esi
  8037e5:	5d                   	pop    %ebp
  8037e6:	c3                   	ret    

008037e7 <pipeisclosed>:
{
  8037e7:	55                   	push   %ebp
  8037e8:	89 e5                	mov    %esp,%ebp
  8037ea:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8037ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8037f0:	50                   	push   %eax
  8037f1:	ff 75 08             	pushl  0x8(%ebp)
  8037f4:	e8 89 e9 ff ff       	call   802182 <fd_lookup>
  8037f9:	83 c4 10             	add    $0x10,%esp
  8037fc:	85 c0                	test   %eax,%eax
  8037fe:	78 18                	js     803818 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  803800:	83 ec 0c             	sub    $0xc,%esp
  803803:	ff 75 f4             	pushl  -0xc(%ebp)
  803806:	e8 0e e9 ff ff       	call   802119 <fd2data>
	return _pipeisclosed(fd, p);
  80380b:	89 c2                	mov    %eax,%edx
  80380d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803810:	e8 2f fd ff ff       	call   803544 <_pipeisclosed>
  803815:	83 c4 10             	add    $0x10,%esp
}
  803818:	c9                   	leave  
  803819:	c3                   	ret    

0080381a <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80381a:	55                   	push   %ebp
  80381b:	89 e5                	mov    %esp,%ebp
  80381d:	56                   	push   %esi
  80381e:	53                   	push   %ebx
  80381f:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  803822:	85 f6                	test   %esi,%esi
  803824:	74 13                	je     803839 <wait+0x1f>
	e = &envs[ENVX(envid)];
  803826:	89 f3                	mov    %esi,%ebx
  803828:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80382e:	c1 e3 07             	shl    $0x7,%ebx
  803831:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  803837:	eb 1b                	jmp    803854 <wait+0x3a>
	assert(envid != 0);
  803839:	68 92 45 80 00       	push   $0x804592
  80383e:	68 ef 3d 80 00       	push   $0x803def
  803843:	6a 09                	push   $0x9
  803845:	68 9d 45 80 00       	push   $0x80459d
  80384a:	e8 7a d2 ff ff       	call   800ac9 <_panic>
		sys_yield();
  80384f:	e8 8d df ff ff       	call   8017e1 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803854:	8b 43 48             	mov    0x48(%ebx),%eax
  803857:	39 f0                	cmp    %esi,%eax
  803859:	75 07                	jne    803862 <wait+0x48>
  80385b:	8b 43 54             	mov    0x54(%ebx),%eax
  80385e:	85 c0                	test   %eax,%eax
  803860:	75 ed                	jne    80384f <wait+0x35>
}
  803862:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803865:	5b                   	pop    %ebx
  803866:	5e                   	pop    %esi
  803867:	5d                   	pop    %ebp
  803868:	c3                   	ret    

00803869 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803869:	55                   	push   %ebp
  80386a:	89 e5                	mov    %esp,%ebp
  80386c:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80386f:	83 3d 00 90 80 00 00 	cmpl   $0x0,0x809000
  803876:	74 0a                	je     803882 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803878:	8b 45 08             	mov    0x8(%ebp),%eax
  80387b:	a3 00 90 80 00       	mov    %eax,0x809000
}
  803880:	c9                   	leave  
  803881:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  803882:	83 ec 04             	sub    $0x4,%esp
  803885:	6a 07                	push   $0x7
  803887:	68 00 f0 bf ee       	push   $0xeebff000
  80388c:	6a 00                	push   $0x0
  80388e:	e8 6d df ff ff       	call   801800 <sys_page_alloc>
		if(r < 0)
  803893:	83 c4 10             	add    $0x10,%esp
  803896:	85 c0                	test   %eax,%eax
  803898:	78 2a                	js     8038c4 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80389a:	83 ec 08             	sub    $0x8,%esp
  80389d:	68 d8 38 80 00       	push   $0x8038d8
  8038a2:	6a 00                	push   $0x0
  8038a4:	e8 a2 e0 ff ff       	call   80194b <sys_env_set_pgfault_upcall>
		if(r < 0)
  8038a9:	83 c4 10             	add    $0x10,%esp
  8038ac:	85 c0                	test   %eax,%eax
  8038ae:	79 c8                	jns    803878 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8038b0:	83 ec 04             	sub    $0x4,%esp
  8038b3:	68 d8 45 80 00       	push   $0x8045d8
  8038b8:	6a 25                	push   $0x25
  8038ba:	68 14 46 80 00       	push   $0x804614
  8038bf:	e8 05 d2 ff ff       	call   800ac9 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8038c4:	83 ec 04             	sub    $0x4,%esp
  8038c7:	68 a8 45 80 00       	push   $0x8045a8
  8038cc:	6a 22                	push   $0x22
  8038ce:	68 14 46 80 00       	push   $0x804614
  8038d3:	e8 f1 d1 ff ff       	call   800ac9 <_panic>

008038d8 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8038d8:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8038d9:	a1 00 90 80 00       	mov    0x809000,%eax
	call *%eax
  8038de:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8038e0:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8038e3:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8038e7:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8038eb:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8038ee:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8038f0:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8038f4:	83 c4 08             	add    $0x8,%esp
	popal
  8038f7:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8038f8:	83 c4 04             	add    $0x4,%esp
	popfl
  8038fb:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8038fc:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8038fd:	c3                   	ret    

008038fe <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8038fe:	55                   	push   %ebp
  8038ff:	89 e5                	mov    %esp,%ebp
  803901:	56                   	push   %esi
  803902:	53                   	push   %ebx
  803903:	8b 75 08             	mov    0x8(%ebp),%esi
  803906:	8b 45 0c             	mov    0xc(%ebp),%eax
  803909:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80390c:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80390e:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  803913:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  803916:	83 ec 0c             	sub    $0xc,%esp
  803919:	50                   	push   %eax
  80391a:	e8 91 e0 ff ff       	call   8019b0 <sys_ipc_recv>
	if(ret < 0){
  80391f:	83 c4 10             	add    $0x10,%esp
  803922:	85 c0                	test   %eax,%eax
  803924:	78 2b                	js     803951 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  803926:	85 f6                	test   %esi,%esi
  803928:	74 0a                	je     803934 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  80392a:	a1 28 64 80 00       	mov    0x806428,%eax
  80392f:	8b 40 74             	mov    0x74(%eax),%eax
  803932:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  803934:	85 db                	test   %ebx,%ebx
  803936:	74 0a                	je     803942 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  803938:	a1 28 64 80 00       	mov    0x806428,%eax
  80393d:	8b 40 78             	mov    0x78(%eax),%eax
  803940:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  803942:	a1 28 64 80 00       	mov    0x806428,%eax
  803947:	8b 40 70             	mov    0x70(%eax),%eax
}
  80394a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80394d:	5b                   	pop    %ebx
  80394e:	5e                   	pop    %esi
  80394f:	5d                   	pop    %ebp
  803950:	c3                   	ret    
		if(from_env_store)
  803951:	85 f6                	test   %esi,%esi
  803953:	74 06                	je     80395b <ipc_recv+0x5d>
			*from_env_store = 0;
  803955:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80395b:	85 db                	test   %ebx,%ebx
  80395d:	74 eb                	je     80394a <ipc_recv+0x4c>
			*perm_store = 0;
  80395f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  803965:	eb e3                	jmp    80394a <ipc_recv+0x4c>

00803967 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  803967:	55                   	push   %ebp
  803968:	89 e5                	mov    %esp,%ebp
  80396a:	57                   	push   %edi
  80396b:	56                   	push   %esi
  80396c:	53                   	push   %ebx
  80396d:	83 ec 0c             	sub    $0xc,%esp
  803970:	8b 7d 08             	mov    0x8(%ebp),%edi
  803973:	8b 75 0c             	mov    0xc(%ebp),%esi
  803976:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  803979:	85 db                	test   %ebx,%ebx
  80397b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  803980:	0f 44 d8             	cmove  %eax,%ebx
  803983:	eb 05                	jmp    80398a <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  803985:	e8 57 de ff ff       	call   8017e1 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80398a:	ff 75 14             	pushl  0x14(%ebp)
  80398d:	53                   	push   %ebx
  80398e:	56                   	push   %esi
  80398f:	57                   	push   %edi
  803990:	e8 f8 df ff ff       	call   80198d <sys_ipc_try_send>
  803995:	83 c4 10             	add    $0x10,%esp
  803998:	85 c0                	test   %eax,%eax
  80399a:	74 1b                	je     8039b7 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80399c:	79 e7                	jns    803985 <ipc_send+0x1e>
  80399e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8039a1:	74 e2                	je     803985 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8039a3:	83 ec 04             	sub    $0x4,%esp
  8039a6:	68 22 46 80 00       	push   $0x804622
  8039ab:	6a 48                	push   $0x48
  8039ad:	68 37 46 80 00       	push   $0x804637
  8039b2:	e8 12 d1 ff ff       	call   800ac9 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8039b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8039ba:	5b                   	pop    %ebx
  8039bb:	5e                   	pop    %esi
  8039bc:	5f                   	pop    %edi
  8039bd:	5d                   	pop    %ebp
  8039be:	c3                   	ret    

008039bf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8039bf:	55                   	push   %ebp
  8039c0:	89 e5                	mov    %esp,%ebp
  8039c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8039c5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8039ca:	89 c2                	mov    %eax,%edx
  8039cc:	c1 e2 07             	shl    $0x7,%edx
  8039cf:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8039d5:	8b 52 50             	mov    0x50(%edx),%edx
  8039d8:	39 ca                	cmp    %ecx,%edx
  8039da:	74 11                	je     8039ed <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8039dc:	83 c0 01             	add    $0x1,%eax
  8039df:	3d 00 04 00 00       	cmp    $0x400,%eax
  8039e4:	75 e4                	jne    8039ca <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8039e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8039eb:	eb 0b                	jmp    8039f8 <ipc_find_env+0x39>
			return envs[i].env_id;
  8039ed:	c1 e0 07             	shl    $0x7,%eax
  8039f0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8039f5:	8b 40 48             	mov    0x48(%eax),%eax
}
  8039f8:	5d                   	pop    %ebp
  8039f9:	c3                   	ret    

008039fa <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8039fa:	55                   	push   %ebp
  8039fb:	89 e5                	mov    %esp,%ebp
  8039fd:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803a00:	89 d0                	mov    %edx,%eax
  803a02:	c1 e8 16             	shr    $0x16,%eax
  803a05:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  803a0c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  803a11:	f6 c1 01             	test   $0x1,%cl
  803a14:	74 1d                	je     803a33 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  803a16:	c1 ea 0c             	shr    $0xc,%edx
  803a19:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803a20:	f6 c2 01             	test   $0x1,%dl
  803a23:	74 0e                	je     803a33 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803a25:	c1 ea 0c             	shr    $0xc,%edx
  803a28:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  803a2f:	ef 
  803a30:	0f b7 c0             	movzwl %ax,%eax
}
  803a33:	5d                   	pop    %ebp
  803a34:	c3                   	ret    
  803a35:	66 90                	xchg   %ax,%ax
  803a37:	66 90                	xchg   %ax,%ax
  803a39:	66 90                	xchg   %ax,%ax
  803a3b:	66 90                	xchg   %ax,%ax
  803a3d:	66 90                	xchg   %ax,%ax
  803a3f:	90                   	nop

00803a40 <__udivdi3>:
  803a40:	55                   	push   %ebp
  803a41:	57                   	push   %edi
  803a42:	56                   	push   %esi
  803a43:	53                   	push   %ebx
  803a44:	83 ec 1c             	sub    $0x1c,%esp
  803a47:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  803a4b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  803a4f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a53:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  803a57:	85 d2                	test   %edx,%edx
  803a59:	75 4d                	jne    803aa8 <__udivdi3+0x68>
  803a5b:	39 f3                	cmp    %esi,%ebx
  803a5d:	76 19                	jbe    803a78 <__udivdi3+0x38>
  803a5f:	31 ff                	xor    %edi,%edi
  803a61:	89 e8                	mov    %ebp,%eax
  803a63:	89 f2                	mov    %esi,%edx
  803a65:	f7 f3                	div    %ebx
  803a67:	89 fa                	mov    %edi,%edx
  803a69:	83 c4 1c             	add    $0x1c,%esp
  803a6c:	5b                   	pop    %ebx
  803a6d:	5e                   	pop    %esi
  803a6e:	5f                   	pop    %edi
  803a6f:	5d                   	pop    %ebp
  803a70:	c3                   	ret    
  803a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803a78:	89 d9                	mov    %ebx,%ecx
  803a7a:	85 db                	test   %ebx,%ebx
  803a7c:	75 0b                	jne    803a89 <__udivdi3+0x49>
  803a7e:	b8 01 00 00 00       	mov    $0x1,%eax
  803a83:	31 d2                	xor    %edx,%edx
  803a85:	f7 f3                	div    %ebx
  803a87:	89 c1                	mov    %eax,%ecx
  803a89:	31 d2                	xor    %edx,%edx
  803a8b:	89 f0                	mov    %esi,%eax
  803a8d:	f7 f1                	div    %ecx
  803a8f:	89 c6                	mov    %eax,%esi
  803a91:	89 e8                	mov    %ebp,%eax
  803a93:	89 f7                	mov    %esi,%edi
  803a95:	f7 f1                	div    %ecx
  803a97:	89 fa                	mov    %edi,%edx
  803a99:	83 c4 1c             	add    $0x1c,%esp
  803a9c:	5b                   	pop    %ebx
  803a9d:	5e                   	pop    %esi
  803a9e:	5f                   	pop    %edi
  803a9f:	5d                   	pop    %ebp
  803aa0:	c3                   	ret    
  803aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803aa8:	39 f2                	cmp    %esi,%edx
  803aaa:	77 1c                	ja     803ac8 <__udivdi3+0x88>
  803aac:	0f bd fa             	bsr    %edx,%edi
  803aaf:	83 f7 1f             	xor    $0x1f,%edi
  803ab2:	75 2c                	jne    803ae0 <__udivdi3+0xa0>
  803ab4:	39 f2                	cmp    %esi,%edx
  803ab6:	72 06                	jb     803abe <__udivdi3+0x7e>
  803ab8:	31 c0                	xor    %eax,%eax
  803aba:	39 eb                	cmp    %ebp,%ebx
  803abc:	77 a9                	ja     803a67 <__udivdi3+0x27>
  803abe:	b8 01 00 00 00       	mov    $0x1,%eax
  803ac3:	eb a2                	jmp    803a67 <__udivdi3+0x27>
  803ac5:	8d 76 00             	lea    0x0(%esi),%esi
  803ac8:	31 ff                	xor    %edi,%edi
  803aca:	31 c0                	xor    %eax,%eax
  803acc:	89 fa                	mov    %edi,%edx
  803ace:	83 c4 1c             	add    $0x1c,%esp
  803ad1:	5b                   	pop    %ebx
  803ad2:	5e                   	pop    %esi
  803ad3:	5f                   	pop    %edi
  803ad4:	5d                   	pop    %ebp
  803ad5:	c3                   	ret    
  803ad6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803add:	8d 76 00             	lea    0x0(%esi),%esi
  803ae0:	89 f9                	mov    %edi,%ecx
  803ae2:	b8 20 00 00 00       	mov    $0x20,%eax
  803ae7:	29 f8                	sub    %edi,%eax
  803ae9:	d3 e2                	shl    %cl,%edx
  803aeb:	89 54 24 08          	mov    %edx,0x8(%esp)
  803aef:	89 c1                	mov    %eax,%ecx
  803af1:	89 da                	mov    %ebx,%edx
  803af3:	d3 ea                	shr    %cl,%edx
  803af5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803af9:	09 d1                	or     %edx,%ecx
  803afb:	89 f2                	mov    %esi,%edx
  803afd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b01:	89 f9                	mov    %edi,%ecx
  803b03:	d3 e3                	shl    %cl,%ebx
  803b05:	89 c1                	mov    %eax,%ecx
  803b07:	d3 ea                	shr    %cl,%edx
  803b09:	89 f9                	mov    %edi,%ecx
  803b0b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  803b0f:	89 eb                	mov    %ebp,%ebx
  803b11:	d3 e6                	shl    %cl,%esi
  803b13:	89 c1                	mov    %eax,%ecx
  803b15:	d3 eb                	shr    %cl,%ebx
  803b17:	09 de                	or     %ebx,%esi
  803b19:	89 f0                	mov    %esi,%eax
  803b1b:	f7 74 24 08          	divl   0x8(%esp)
  803b1f:	89 d6                	mov    %edx,%esi
  803b21:	89 c3                	mov    %eax,%ebx
  803b23:	f7 64 24 0c          	mull   0xc(%esp)
  803b27:	39 d6                	cmp    %edx,%esi
  803b29:	72 15                	jb     803b40 <__udivdi3+0x100>
  803b2b:	89 f9                	mov    %edi,%ecx
  803b2d:	d3 e5                	shl    %cl,%ebp
  803b2f:	39 c5                	cmp    %eax,%ebp
  803b31:	73 04                	jae    803b37 <__udivdi3+0xf7>
  803b33:	39 d6                	cmp    %edx,%esi
  803b35:	74 09                	je     803b40 <__udivdi3+0x100>
  803b37:	89 d8                	mov    %ebx,%eax
  803b39:	31 ff                	xor    %edi,%edi
  803b3b:	e9 27 ff ff ff       	jmp    803a67 <__udivdi3+0x27>
  803b40:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b43:	31 ff                	xor    %edi,%edi
  803b45:	e9 1d ff ff ff       	jmp    803a67 <__udivdi3+0x27>
  803b4a:	66 90                	xchg   %ax,%ax
  803b4c:	66 90                	xchg   %ax,%ax
  803b4e:	66 90                	xchg   %ax,%ax

00803b50 <__umoddi3>:
  803b50:	55                   	push   %ebp
  803b51:	57                   	push   %edi
  803b52:	56                   	push   %esi
  803b53:	53                   	push   %ebx
  803b54:	83 ec 1c             	sub    $0x1c,%esp
  803b57:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  803b5b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b5f:	8b 74 24 30          	mov    0x30(%esp),%esi
  803b63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b67:	89 da                	mov    %ebx,%edx
  803b69:	85 c0                	test   %eax,%eax
  803b6b:	75 43                	jne    803bb0 <__umoddi3+0x60>
  803b6d:	39 df                	cmp    %ebx,%edi
  803b6f:	76 17                	jbe    803b88 <__umoddi3+0x38>
  803b71:	89 f0                	mov    %esi,%eax
  803b73:	f7 f7                	div    %edi
  803b75:	89 d0                	mov    %edx,%eax
  803b77:	31 d2                	xor    %edx,%edx
  803b79:	83 c4 1c             	add    $0x1c,%esp
  803b7c:	5b                   	pop    %ebx
  803b7d:	5e                   	pop    %esi
  803b7e:	5f                   	pop    %edi
  803b7f:	5d                   	pop    %ebp
  803b80:	c3                   	ret    
  803b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803b88:	89 fd                	mov    %edi,%ebp
  803b8a:	85 ff                	test   %edi,%edi
  803b8c:	75 0b                	jne    803b99 <__umoddi3+0x49>
  803b8e:	b8 01 00 00 00       	mov    $0x1,%eax
  803b93:	31 d2                	xor    %edx,%edx
  803b95:	f7 f7                	div    %edi
  803b97:	89 c5                	mov    %eax,%ebp
  803b99:	89 d8                	mov    %ebx,%eax
  803b9b:	31 d2                	xor    %edx,%edx
  803b9d:	f7 f5                	div    %ebp
  803b9f:	89 f0                	mov    %esi,%eax
  803ba1:	f7 f5                	div    %ebp
  803ba3:	89 d0                	mov    %edx,%eax
  803ba5:	eb d0                	jmp    803b77 <__umoddi3+0x27>
  803ba7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803bae:	66 90                	xchg   %ax,%ax
  803bb0:	89 f1                	mov    %esi,%ecx
  803bb2:	39 d8                	cmp    %ebx,%eax
  803bb4:	76 0a                	jbe    803bc0 <__umoddi3+0x70>
  803bb6:	89 f0                	mov    %esi,%eax
  803bb8:	83 c4 1c             	add    $0x1c,%esp
  803bbb:	5b                   	pop    %ebx
  803bbc:	5e                   	pop    %esi
  803bbd:	5f                   	pop    %edi
  803bbe:	5d                   	pop    %ebp
  803bbf:	c3                   	ret    
  803bc0:	0f bd e8             	bsr    %eax,%ebp
  803bc3:	83 f5 1f             	xor    $0x1f,%ebp
  803bc6:	75 20                	jne    803be8 <__umoddi3+0x98>
  803bc8:	39 d8                	cmp    %ebx,%eax
  803bca:	0f 82 b0 00 00 00    	jb     803c80 <__umoddi3+0x130>
  803bd0:	39 f7                	cmp    %esi,%edi
  803bd2:	0f 86 a8 00 00 00    	jbe    803c80 <__umoddi3+0x130>
  803bd8:	89 c8                	mov    %ecx,%eax
  803bda:	83 c4 1c             	add    $0x1c,%esp
  803bdd:	5b                   	pop    %ebx
  803bde:	5e                   	pop    %esi
  803bdf:	5f                   	pop    %edi
  803be0:	5d                   	pop    %ebp
  803be1:	c3                   	ret    
  803be2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803be8:	89 e9                	mov    %ebp,%ecx
  803bea:	ba 20 00 00 00       	mov    $0x20,%edx
  803bef:	29 ea                	sub    %ebp,%edx
  803bf1:	d3 e0                	shl    %cl,%eax
  803bf3:	89 44 24 08          	mov    %eax,0x8(%esp)
  803bf7:	89 d1                	mov    %edx,%ecx
  803bf9:	89 f8                	mov    %edi,%eax
  803bfb:	d3 e8                	shr    %cl,%eax
  803bfd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803c01:	89 54 24 04          	mov    %edx,0x4(%esp)
  803c05:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c09:	09 c1                	or     %eax,%ecx
  803c0b:	89 d8                	mov    %ebx,%eax
  803c0d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c11:	89 e9                	mov    %ebp,%ecx
  803c13:	d3 e7                	shl    %cl,%edi
  803c15:	89 d1                	mov    %edx,%ecx
  803c17:	d3 e8                	shr    %cl,%eax
  803c19:	89 e9                	mov    %ebp,%ecx
  803c1b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c1f:	d3 e3                	shl    %cl,%ebx
  803c21:	89 c7                	mov    %eax,%edi
  803c23:	89 d1                	mov    %edx,%ecx
  803c25:	89 f0                	mov    %esi,%eax
  803c27:	d3 e8                	shr    %cl,%eax
  803c29:	89 e9                	mov    %ebp,%ecx
  803c2b:	89 fa                	mov    %edi,%edx
  803c2d:	d3 e6                	shl    %cl,%esi
  803c2f:	09 d8                	or     %ebx,%eax
  803c31:	f7 74 24 08          	divl   0x8(%esp)
  803c35:	89 d1                	mov    %edx,%ecx
  803c37:	89 f3                	mov    %esi,%ebx
  803c39:	f7 64 24 0c          	mull   0xc(%esp)
  803c3d:	89 c6                	mov    %eax,%esi
  803c3f:	89 d7                	mov    %edx,%edi
  803c41:	39 d1                	cmp    %edx,%ecx
  803c43:	72 06                	jb     803c4b <__umoddi3+0xfb>
  803c45:	75 10                	jne    803c57 <__umoddi3+0x107>
  803c47:	39 c3                	cmp    %eax,%ebx
  803c49:	73 0c                	jae    803c57 <__umoddi3+0x107>
  803c4b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  803c4f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  803c53:	89 d7                	mov    %edx,%edi
  803c55:	89 c6                	mov    %eax,%esi
  803c57:	89 ca                	mov    %ecx,%edx
  803c59:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  803c5e:	29 f3                	sub    %esi,%ebx
  803c60:	19 fa                	sbb    %edi,%edx
  803c62:	89 d0                	mov    %edx,%eax
  803c64:	d3 e0                	shl    %cl,%eax
  803c66:	89 e9                	mov    %ebp,%ecx
  803c68:	d3 eb                	shr    %cl,%ebx
  803c6a:	d3 ea                	shr    %cl,%edx
  803c6c:	09 d8                	or     %ebx,%eax
  803c6e:	83 c4 1c             	add    $0x1c,%esp
  803c71:	5b                   	pop    %ebx
  803c72:	5e                   	pop    %esi
  803c73:	5f                   	pop    %edi
  803c74:	5d                   	pop    %ebp
  803c75:	c3                   	ret    
  803c76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803c7d:	8d 76 00             	lea    0x0(%esi),%esi
  803c80:	89 da                	mov    %ebx,%edx
  803c82:	29 fe                	sub    %edi,%esi
  803c84:	19 c2                	sbb    %eax,%edx
  803c86:	89 f1                	mov    %esi,%ecx
  803c88:	89 c8                	mov    %ecx,%eax
  803c8a:	e9 4b ff ff ff       	jmp    803bda <__umoddi3+0x8a>
