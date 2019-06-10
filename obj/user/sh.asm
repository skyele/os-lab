
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
  800065:	68 1d 3d 80 00       	push   $0x803d1d
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
  800090:	68 00 3d 80 00       	push   $0x803d00
  800095:	e8 76 0b 00 00       	call   800c10 <cprintf>
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	eb 28                	jmp    8000c7 <_gettoken+0x94>
		cprintf("GETTOKEN: %s\n", s);
  80009f:	83 ec 08             	sub    $0x8,%esp
  8000a2:	53                   	push   %ebx
  8000a3:	68 0f 3d 80 00       	push   $0x803d0f
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
  8000d4:	68 22 3d 80 00       	push   $0x803d22
  8000d9:	e8 32 0b 00 00       	call   800c10 <cprintf>
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	eb e4                	jmp    8000c7 <_gettoken+0x94>
	if (strchr(SYMBOLS, *s)) {
  8000e3:	83 ec 08             	sub    $0x8,%esp
  8000e6:	0f be c0             	movsbl %al,%eax
  8000e9:	50                   	push   %eax
  8000ea:	68 33 3d 80 00       	push   $0x803d33
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
  800118:	68 27 3d 80 00       	push   $0x803d27
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
  80013c:	68 2f 3d 80 00       	push   $0x803d2f
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
  80016f:	68 3b 3d 80 00       	push   $0x803d3b
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
  800269:	e8 93 26 00 00       	call   802901 <open>
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
  80029a:	e8 6f 34 00 00       	call   80370e <pipe>
  80029f:	83 c4 10             	add    $0x10,%esp
  8002a2:	85 c0                	test   %eax,%eax
  8002a4:	0f 88 41 01 00 00    	js     8003eb <runcmd+0x1f1>
			if (debug)
  8002aa:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8002b1:	0f 85 4f 01 00 00    	jne    800406 <runcmd+0x20c>
			if ((r = fork()) < 0) {
  8002b7:	e8 df 1a 00 00       	call   801d9b <fork>
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
  8002e3:	e8 3d 20 00 00       	call   802325 <close>
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
  800307:	68 45 3d 80 00       	push   $0x803d45
  80030c:	e8 ff 08 00 00       	call   800c10 <cprintf>
				exit();
  800311:	e8 d0 07 00 00       	call   800ae6 <exit>
  800316:	83 c4 10             	add    $0x10,%esp
  800319:	eb da                	jmp    8002f5 <runcmd+0xfb>
				cprintf("syntax error: < not followed by word\n");
  80031b:	83 ec 0c             	sub    $0xc,%esp
  80031e:	68 98 3e 80 00       	push   $0x803e98
  800323:	e8 e8 08 00 00       	call   800c10 <cprintf>
				exit();
  800328:	e8 b9 07 00 00       	call   800ae6 <exit>
  80032d:	83 c4 10             	add    $0x10,%esp
  800330:	e9 29 ff ff ff       	jmp    80025e <runcmd+0x64>
				cprintf("open %s for read: %e", t, fd);
  800335:	83 ec 04             	sub    $0x4,%esp
  800338:	50                   	push   %eax
  800339:	ff 75 a4             	pushl  -0x5c(%ebp)
  80033c:	68 59 3d 80 00       	push   $0x803d59
  800341:	e8 ca 08 00 00       	call   800c10 <cprintf>
				exit();
  800346:	e8 9b 07 00 00       	call   800ae6 <exit>
  80034b:	83 c4 10             	add    $0x10,%esp
				dup(fd, 0);
  80034e:	83 ec 08             	sub    $0x8,%esp
  800351:	6a 00                	push   $0x0
  800353:	53                   	push   %ebx
  800354:	e8 1e 20 00 00       	call   802377 <dup>
				close(fd);
  800359:	89 1c 24             	mov    %ebx,(%esp)
  80035c:	e8 c4 1f 00 00       	call   802325 <close>
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
  800387:	e8 75 25 00 00       	call   802901 <open>
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
  8003a3:	68 c0 3e 80 00       	push   $0x803ec0
  8003a8:	e8 63 08 00 00       	call   800c10 <cprintf>
				exit();
  8003ad:	e8 34 07 00 00       	call   800ae6 <exit>
  8003b2:	83 c4 10             	add    $0x10,%esp
  8003b5:	eb c5                	jmp    80037c <runcmd+0x182>
				cprintf("open %s for write: %e", t, fd);
  8003b7:	83 ec 04             	sub    $0x4,%esp
  8003ba:	50                   	push   %eax
  8003bb:	ff 75 a4             	pushl  -0x5c(%ebp)
  8003be:	68 6e 3d 80 00       	push   $0x803d6e
  8003c3:	e8 48 08 00 00       	call   800c10 <cprintf>
				exit();
  8003c8:	e8 19 07 00 00       	call   800ae6 <exit>
  8003cd:	83 c4 10             	add    $0x10,%esp
				dup(fd, 1);
  8003d0:	83 ec 08             	sub    $0x8,%esp
  8003d3:	6a 01                	push   $0x1
  8003d5:	53                   	push   %ebx
  8003d6:	e8 9c 1f 00 00       	call   802377 <dup>
				close(fd);
  8003db:	89 1c 24             	mov    %ebx,(%esp)
  8003de:	e8 42 1f 00 00       	call   802325 <close>
  8003e3:	83 c4 10             	add    $0x10,%esp
  8003e6:	e9 30 fe ff ff       	jmp    80021b <runcmd+0x21>
				cprintf("pipe: %e", r);
  8003eb:	83 ec 08             	sub    $0x8,%esp
  8003ee:	50                   	push   %eax
  8003ef:	68 84 3d 80 00       	push   $0x803d84
  8003f4:	e8 17 08 00 00       	call   800c10 <cprintf>
				exit();
  8003f9:	e8 e8 06 00 00       	call   800ae6 <exit>
  8003fe:	83 c4 10             	add    $0x10,%esp
  800401:	e9 a4 fe ff ff       	jmp    8002aa <runcmd+0xb0>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  800406:	83 ec 04             	sub    $0x4,%esp
  800409:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  80040f:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  800415:	68 8d 3d 80 00       	push   $0x803d8d
  80041a:	e8 f1 07 00 00       	call   800c10 <cprintf>
  80041f:	83 c4 10             	add    $0x10,%esp
  800422:	e9 90 fe ff ff       	jmp    8002b7 <runcmd+0xbd>
				cprintf("fork: %e", r);
  800427:	83 ec 08             	sub    $0x8,%esp
  80042a:	50                   	push   %eax
  80042b:	68 9a 3d 80 00       	push   $0x803d9a
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
  800455:	e8 cb 1e 00 00       	call   802325 <close>
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
  800490:	e8 25 26 00 00       	call   802aba <spawn>
  800495:	89 c6                	mov    %eax,%esi
  800497:	83 c4 10             	add    $0x10,%esp
  80049a:	85 c0                	test   %eax,%eax
  80049c:	0f 88 3a 01 00 00    	js     8005dc <runcmd+0x3e2>
	close_all();
  8004a2:	e8 ab 1e 00 00       	call   802352 <close_all>
		if (debug)
  8004a7:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8004ae:	0f 85 75 01 00 00    	jne    800629 <runcmd+0x42f>
		wait(r);
  8004b4:	83 ec 0c             	sub    $0xc,%esp
  8004b7:	56                   	push   %esi
  8004b8:	e8 ce 33 00 00       	call   80388b <wait>
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
  8004d5:	e8 b1 33 00 00       	call   80388b <wait>
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
  8004fd:	e8 75 1e 00 00       	call   802377 <dup>
					close(p[0]);
  800502:	83 c4 04             	add    $0x4,%esp
  800505:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  80050b:	e8 15 1e 00 00       	call   802325 <close>
  800510:	83 c4 10             	add    $0x10,%esp
  800513:	e9 c2 fd ff ff       	jmp    8002da <runcmd+0xe0>
					dup(p[1], 1);
  800518:	83 ec 08             	sub    $0x8,%esp
  80051b:	6a 01                	push   $0x1
  80051d:	50                   	push   %eax
  80051e:	e8 54 1e 00 00       	call   802377 <dup>
					close(p[1]);
  800523:	83 c4 04             	add    $0x4,%esp
  800526:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  80052c:	e8 f4 1d 00 00       	call   802325 <close>
  800531:	83 c4 10             	add    $0x10,%esp
  800534:	e9 13 ff ff ff       	jmp    80044c <runcmd+0x252>
			panic("bad return %d from gettoken", c);
  800539:	53                   	push   %ebx
  80053a:	68 a3 3d 80 00       	push   $0x803da3
  80053f:	6a 78                	push   $0x78
  800541:	68 bf 3d 80 00       	push   $0x803dbf
  800546:	e8 cf 05 00 00       	call   800b1a <_panic>
		if (debug)
  80054b:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800552:	74 9b                	je     8004ef <runcmd+0x2f5>
			cprintf("EMPTY COMMAND\n");
  800554:	83 ec 0c             	sub    $0xc,%esp
  800557:	68 c9 3d 80 00       	push   $0x803dc9
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
  80059a:	68 d8 3d 80 00       	push   $0x803dd8
  80059f:	e8 6c 06 00 00       	call   800c10 <cprintf>
  8005a4:	8d 75 a8             	lea    -0x58(%ebp),%esi
		for (i = 0; argv[i]; i++)
  8005a7:	83 c4 10             	add    $0x10,%esp
  8005aa:	eb 11                	jmp    8005bd <runcmd+0x3c3>
			cprintf(" %s", argv[i]);
  8005ac:	83 ec 08             	sub    $0x8,%esp
  8005af:	50                   	push   %eax
  8005b0:	68 60 3e 80 00       	push   $0x803e60
  8005b5:	e8 56 06 00 00       	call   800c10 <cprintf>
  8005ba:	83 c4 10             	add    $0x10,%esp
  8005bd:	83 c6 04             	add    $0x4,%esi
		for (i = 0; argv[i]; i++)
  8005c0:	8b 46 fc             	mov    -0x4(%esi),%eax
  8005c3:	85 c0                	test   %eax,%eax
  8005c5:	75 e5                	jne    8005ac <runcmd+0x3b2>
		cprintf("\n");
  8005c7:	83 ec 0c             	sub    $0xc,%esp
  8005ca:	68 20 3d 80 00       	push   $0x803d20
  8005cf:	e8 3c 06 00 00       	call   800c10 <cprintf>
  8005d4:	83 c4 10             	add    $0x10,%esp
  8005d7:	e9 aa fe ff ff       	jmp    800486 <runcmd+0x28c>
		cprintf("spawn %s: %e\n", argv[0], r);
  8005dc:	83 ec 04             	sub    $0x4,%esp
  8005df:	50                   	push   %eax
  8005e0:	ff 75 a8             	pushl  -0x58(%ebp)
  8005e3:	68 e6 3d 80 00       	push   $0x803de6
  8005e8:	e8 23 06 00 00       	call   800c10 <cprintf>
	close_all();
  8005ed:	e8 60 1d 00 00       	call   802352 <close_all>
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
  800617:	68 1f 3e 80 00       	push   $0x803e1f
  80061c:	e8 ef 05 00 00       	call   800c10 <cprintf>
  800621:	83 c4 10             	add    $0x10,%esp
  800624:	e9 a8 fe ff ff       	jmp    8004d1 <runcmd+0x2d7>
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  800629:	a1 28 64 80 00       	mov    0x806428,%eax
  80062e:	8b 40 48             	mov    0x48(%eax),%eax
  800631:	56                   	push   %esi
  800632:	ff 75 a8             	pushl  -0x58(%ebp)
  800635:	50                   	push   %eax
  800636:	68 f4 3d 80 00       	push   $0x803df4
  80063b:	e8 d0 05 00 00       	call   800c10 <cprintf>
  800640:	83 c4 10             	add    $0x10,%esp
  800643:	e9 6c fe ff ff       	jmp    8004b4 <runcmd+0x2ba>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800648:	a1 28 64 80 00       	mov    0x806428,%eax
  80064d:	8b 40 48             	mov    0x48(%eax),%eax
  800650:	83 ec 08             	sub    $0x8,%esp
  800653:	50                   	push   %eax
  800654:	68 09 3e 80 00       	push   $0x803e09
  800659:	e8 b2 05 00 00       	call   800c10 <cprintf>
  80065e:	83 c4 10             	add    $0x10,%esp
  800661:	eb 92                	jmp    8005f5 <runcmd+0x3fb>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800663:	a1 28 64 80 00       	mov    0x806428,%eax
  800668:	8b 40 48             	mov    0x48(%eax),%eax
  80066b:	83 ec 08             	sub    $0x8,%esp
  80066e:	50                   	push   %eax
  80066f:	68 09 3e 80 00       	push   $0x803e09
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
  800687:	68 e8 3e 80 00       	push   $0x803ee8
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
  8006af:	e8 79 19 00 00       	call   80202d <argstart>
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
  8006e1:	e8 77 19 00 00       	call   80205d <argnext>
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
  800716:	bf 64 3e 80 00       	mov    $0x803e64,%edi
  80071b:	b8 00 00 00 00       	mov    $0x0,%eax
  800720:	0f 44 f8             	cmove  %eax,%edi
  800723:	e9 06 01 00 00       	jmp    80082e <umain+0x193>
		usage();
  800728:	e8 54 ff ff ff       	call   800681 <usage>
  80072d:	eb da                	jmp    800709 <umain+0x6e>
		close(0);
  80072f:	83 ec 0c             	sub    $0xc,%esp
  800732:	6a 00                	push   $0x0
  800734:	e8 ec 1b 00 00       	call   802325 <close>
		if ((r = open(argv[1], O_RDONLY)) < 0)
  800739:	83 c4 08             	add    $0x8,%esp
  80073c:	6a 00                	push   $0x0
  80073e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800741:	ff 70 04             	pushl  0x4(%eax)
  800744:	e8 b8 21 00 00       	call   802901 <open>
  800749:	83 c4 10             	add    $0x10,%esp
  80074c:	85 c0                	test   %eax,%eax
  80074e:	78 1b                	js     80076b <umain+0xd0>
		assert(r == 0);
  800750:	74 bd                	je     80070f <umain+0x74>
  800752:	68 48 3e 80 00       	push   $0x803e48
  800757:	68 4f 3e 80 00       	push   $0x803e4f
  80075c:	68 29 01 00 00       	push   $0x129
  800761:	68 bf 3d 80 00       	push   $0x803dbf
  800766:	e8 af 03 00 00       	call   800b1a <_panic>
			panic("open %s: %e", argv[1], r);
  80076b:	83 ec 0c             	sub    $0xc,%esp
  80076e:	50                   	push   %eax
  80076f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800772:	ff 70 04             	pushl  0x4(%eax)
  800775:	68 3c 3e 80 00       	push   $0x803e3c
  80077a:	68 28 01 00 00       	push   $0x128
  80077f:	68 bf 3d 80 00       	push   $0x803dbf
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
  8007b3:	68 67 3e 80 00       	push   $0x803e67
  8007b8:	e8 53 04 00 00       	call   800c10 <cprintf>
  8007bd:	83 c4 10             	add    $0x10,%esp
  8007c0:	eb e4                	jmp    8007a6 <umain+0x10b>
		}
		if (debug)
			cprintf("LINE: %s\n", buf);
  8007c2:	83 ec 08             	sub    $0x8,%esp
  8007c5:	53                   	push   %ebx
  8007c6:	68 70 3e 80 00       	push   $0x803e70
  8007cb:	e8 40 04 00 00       	call   800c10 <cprintf>
  8007d0:	83 c4 10             	add    $0x10,%esp
  8007d3:	eb 7c                	jmp    800851 <umain+0x1b6>
		if (buf[0] == '#')
			continue;
		if (echocmds)
			printf("# %s\n", buf);
  8007d5:	83 ec 08             	sub    $0x8,%esp
  8007d8:	53                   	push   %ebx
  8007d9:	68 7a 3e 80 00       	push   $0x803e7a
  8007de:	e8 c1 22 00 00       	call   802aa4 <printf>
  8007e3:	83 c4 10             	add    $0x10,%esp
  8007e6:	eb 78                	jmp    800860 <umain+0x1c5>
		if (debug)
			cprintf("BEFORE FORK\n");
  8007e8:	83 ec 0c             	sub    $0xc,%esp
  8007eb:	68 80 3e 80 00       	push   $0x803e80
  8007f0:	e8 1b 04 00 00       	call   800c10 <cprintf>
  8007f5:	83 c4 10             	add    $0x10,%esp
  8007f8:	eb 73                	jmp    80086d <umain+0x1d2>
		if ((r = fork()) < 0)
			panic("fork: %e", r);
  8007fa:	50                   	push   %eax
  8007fb:	68 9a 3d 80 00       	push   $0x803d9a
  800800:	68 40 01 00 00       	push   $0x140
  800805:	68 bf 3d 80 00       	push   $0x803dbf
  80080a:	e8 0b 03 00 00       	call   800b1a <_panic>
		if (debug)
			cprintf("FORK: %d\n", r);
  80080f:	83 ec 08             	sub    $0x8,%esp
  800812:	50                   	push   %eax
  800813:	68 8d 3e 80 00       	push   $0x803e8d
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
  800826:	e8 60 30 00 00       	call   80388b <wait>
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
  80086d:	e8 29 15 00 00       	call   801d9b <fork>
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
  8008a4:	68 09 3f 80 00       	push   $0x803f09
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
  800974:	e8 ea 1a 00 00       	call   802463 <read>
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
  80099c:	e8 52 18 00 00       	call   8021f3 <fd_lookup>
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
  8009c5:	e8 d7 17 00 00       	call   8021a1 <fd_alloc>
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
  800a03:	e8 72 17 00 00       	call   80217a <fd2num>
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
  800a90:	68 15 3f 80 00       	push   $0x803f15
  800a95:	e8 76 01 00 00       	call   800c10 <cprintf>
	cprintf("before umain\n");
  800a9a:	c7 04 24 33 3f 80 00 	movl   $0x803f33,(%esp)
  800aa1:	e8 6a 01 00 00       	call   800c10 <cprintf>
	// call user main routine
	umain(argc, argv);
  800aa6:	83 c4 08             	add    $0x8,%esp
  800aa9:	ff 75 0c             	pushl  0xc(%ebp)
  800aac:	ff 75 08             	pushl  0x8(%ebp)
  800aaf:	e8 e7 fb ff ff       	call   80069b <umain>
	cprintf("after umain\n");
  800ab4:	c7 04 24 41 3f 80 00 	movl   $0x803f41,(%esp)
  800abb:	e8 50 01 00 00       	call   800c10 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800ac0:	a1 28 64 80 00       	mov    0x806428,%eax
  800ac5:	8b 40 48             	mov    0x48(%eax),%eax
  800ac8:	83 c4 08             	add    $0x8,%esp
  800acb:	50                   	push   %eax
  800acc:	68 4e 3f 80 00       	push   $0x803f4e
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
  800af4:	68 78 3f 80 00       	push   $0x803f78
  800af9:	50                   	push   %eax
  800afa:	68 6d 3f 80 00       	push   $0x803f6d
  800aff:	e8 0c 01 00 00       	call   800c10 <cprintf>
	close_all();
  800b04:	e8 49 18 00 00       	call   802352 <close_all>
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
  800b2a:	68 a4 3f 80 00       	push   $0x803fa4
  800b2f:	50                   	push   %eax
  800b30:	68 6d 3f 80 00       	push   $0x803f6d
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
  800b53:	68 80 3f 80 00       	push   $0x803f80
  800b58:	e8 b3 00 00 00       	call   800c10 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800b5d:	83 c4 18             	add    $0x18,%esp
  800b60:	53                   	push   %ebx
  800b61:	ff 75 10             	pushl  0x10(%ebp)
  800b64:	e8 56 00 00 00       	call   800bbf <vcprintf>
	cprintf("\n");
  800b69:	c7 04 24 20 3d 80 00 	movl   $0x803d20,(%esp)
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
  800cbd:	e8 ee 2d 00 00       	call   803ab0 <__udivdi3>
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
  800ce6:	e8 d5 2e 00 00       	call   803bc0 <__umoddi3>
  800ceb:	83 c4 14             	add    $0x14,%esp
  800cee:	0f be 80 ab 3f 80 00 	movsbl 0x803fab(%eax),%eax
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
  800d97:	ff 24 85 80 41 80 00 	jmp    *0x804180(,%eax,4)
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
  800e62:	8b 14 85 e0 42 80 00 	mov    0x8042e0(,%eax,4),%edx
  800e69:	85 d2                	test   %edx,%edx
  800e6b:	74 18                	je     800e85 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800e6d:	52                   	push   %edx
  800e6e:	68 61 3e 80 00       	push   $0x803e61
  800e73:	53                   	push   %ebx
  800e74:	56                   	push   %esi
  800e75:	e8 a6 fe ff ff       	call   800d20 <printfmt>
  800e7a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800e7d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800e80:	e9 fe 02 00 00       	jmp    801183 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800e85:	50                   	push   %eax
  800e86:	68 c3 3f 80 00       	push   $0x803fc3
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
  800ead:	b8 bc 3f 80 00       	mov    $0x803fbc,%eax
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
  801245:	bf e1 40 80 00       	mov    $0x8040e1,%edi
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
  801271:	bf 19 41 80 00       	mov    $0x804119,%edi
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
  80134a:	68 61 3e 80 00       	push   $0x803e61
  80134f:	6a 01                	push   $0x1
  801351:	e8 37 17 00 00       	call   802a8d <fprintf>
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
  801385:	68 28 43 80 00       	push   $0x804328
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
  801802:	68 38 43 80 00       	push   $0x804338
  801807:	6a 43                	push   $0x43
  801809:	68 55 43 80 00       	push   $0x804355
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
  801883:	68 38 43 80 00       	push   $0x804338
  801888:	6a 43                	push   $0x43
  80188a:	68 55 43 80 00       	push   $0x804355
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
  8018c5:	68 38 43 80 00       	push   $0x804338
  8018ca:	6a 43                	push   $0x43
  8018cc:	68 55 43 80 00       	push   $0x804355
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
  801907:	68 38 43 80 00       	push   $0x804338
  80190c:	6a 43                	push   $0x43
  80190e:	68 55 43 80 00       	push   $0x804355
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
  801949:	68 38 43 80 00       	push   $0x804338
  80194e:	6a 43                	push   $0x43
  801950:	68 55 43 80 00       	push   $0x804355
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
  80198b:	68 38 43 80 00       	push   $0x804338
  801990:	6a 43                	push   $0x43
  801992:	68 55 43 80 00       	push   $0x804355
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
  8019cd:	68 38 43 80 00       	push   $0x804338
  8019d2:	6a 43                	push   $0x43
  8019d4:	68 55 43 80 00       	push   $0x804355
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
  801a31:	68 38 43 80 00       	push   $0x804338
  801a36:	6a 43                	push   $0x43
  801a38:	68 55 43 80 00       	push   $0x804355
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
  801b15:	68 38 43 80 00       	push   $0x804338
  801b1a:	6a 43                	push   $0x43
  801b1c:	68 55 43 80 00       	push   $0x804355
  801b21:	e8 f4 ef ff ff       	call   800b1a <_panic>

00801b26 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
  801b29:	57                   	push   %edi
  801b2a:	56                   	push   %esi
  801b2b:	53                   	push   %ebx
	asm volatile("int %1\n"
  801b2c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b31:	8b 55 08             	mov    0x8(%ebp),%edx
  801b34:	b8 14 00 00 00       	mov    $0x14,%eax
  801b39:	89 cb                	mov    %ecx,%ebx
  801b3b:	89 cf                	mov    %ecx,%edi
  801b3d:	89 ce                	mov    %ecx,%esi
  801b3f:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801b41:	5b                   	pop    %ebx
  801b42:	5e                   	pop    %esi
  801b43:	5f                   	pop    %edi
  801b44:	5d                   	pop    %ebp
  801b45:	c3                   	ret    

00801b46 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
  801b49:	53                   	push   %ebx
  801b4a:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801b4d:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801b54:	f6 c5 04             	test   $0x4,%ch
  801b57:	75 45                	jne    801b9e <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801b59:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801b60:	83 e1 07             	and    $0x7,%ecx
  801b63:	83 f9 07             	cmp    $0x7,%ecx
  801b66:	74 6f                	je     801bd7 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801b68:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801b6f:	81 e1 05 08 00 00    	and    $0x805,%ecx
  801b75:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801b7b:	0f 84 b6 00 00 00    	je     801c37 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801b81:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801b88:	83 e1 05             	and    $0x5,%ecx
  801b8b:	83 f9 05             	cmp    $0x5,%ecx
  801b8e:	0f 84 d7 00 00 00    	je     801c6b <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801b94:	b8 00 00 00 00       	mov    $0x0,%eax
  801b99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b9c:	c9                   	leave  
  801b9d:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801b9e:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801ba5:	c1 e2 0c             	shl    $0xc,%edx
  801ba8:	83 ec 0c             	sub    $0xc,%esp
  801bab:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801bb1:	51                   	push   %ecx
  801bb2:	52                   	push   %edx
  801bb3:	50                   	push   %eax
  801bb4:	52                   	push   %edx
  801bb5:	6a 00                	push   $0x0
  801bb7:	e8 d8 fc ff ff       	call   801894 <sys_page_map>
		if(r < 0)
  801bbc:	83 c4 20             	add    $0x20,%esp
  801bbf:	85 c0                	test   %eax,%eax
  801bc1:	79 d1                	jns    801b94 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801bc3:	83 ec 04             	sub    $0x4,%esp
  801bc6:	68 63 43 80 00       	push   $0x804363
  801bcb:	6a 54                	push   $0x54
  801bcd:	68 79 43 80 00       	push   $0x804379
  801bd2:	e8 43 ef ff ff       	call   800b1a <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801bd7:	89 d3                	mov    %edx,%ebx
  801bd9:	c1 e3 0c             	shl    $0xc,%ebx
  801bdc:	83 ec 0c             	sub    $0xc,%esp
  801bdf:	68 05 08 00 00       	push   $0x805
  801be4:	53                   	push   %ebx
  801be5:	50                   	push   %eax
  801be6:	53                   	push   %ebx
  801be7:	6a 00                	push   $0x0
  801be9:	e8 a6 fc ff ff       	call   801894 <sys_page_map>
		if(r < 0)
  801bee:	83 c4 20             	add    $0x20,%esp
  801bf1:	85 c0                	test   %eax,%eax
  801bf3:	78 2e                	js     801c23 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801bf5:	83 ec 0c             	sub    $0xc,%esp
  801bf8:	68 05 08 00 00       	push   $0x805
  801bfd:	53                   	push   %ebx
  801bfe:	6a 00                	push   $0x0
  801c00:	53                   	push   %ebx
  801c01:	6a 00                	push   $0x0
  801c03:	e8 8c fc ff ff       	call   801894 <sys_page_map>
		if(r < 0)
  801c08:	83 c4 20             	add    $0x20,%esp
  801c0b:	85 c0                	test   %eax,%eax
  801c0d:	79 85                	jns    801b94 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801c0f:	83 ec 04             	sub    $0x4,%esp
  801c12:	68 63 43 80 00       	push   $0x804363
  801c17:	6a 5f                	push   $0x5f
  801c19:	68 79 43 80 00       	push   $0x804379
  801c1e:	e8 f7 ee ff ff       	call   800b1a <_panic>
			panic("sys_page_map() panic\n");
  801c23:	83 ec 04             	sub    $0x4,%esp
  801c26:	68 63 43 80 00       	push   $0x804363
  801c2b:	6a 5b                	push   $0x5b
  801c2d:	68 79 43 80 00       	push   $0x804379
  801c32:	e8 e3 ee ff ff       	call   800b1a <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801c37:	c1 e2 0c             	shl    $0xc,%edx
  801c3a:	83 ec 0c             	sub    $0xc,%esp
  801c3d:	68 05 08 00 00       	push   $0x805
  801c42:	52                   	push   %edx
  801c43:	50                   	push   %eax
  801c44:	52                   	push   %edx
  801c45:	6a 00                	push   $0x0
  801c47:	e8 48 fc ff ff       	call   801894 <sys_page_map>
		if(r < 0)
  801c4c:	83 c4 20             	add    $0x20,%esp
  801c4f:	85 c0                	test   %eax,%eax
  801c51:	0f 89 3d ff ff ff    	jns    801b94 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801c57:	83 ec 04             	sub    $0x4,%esp
  801c5a:	68 63 43 80 00       	push   $0x804363
  801c5f:	6a 66                	push   $0x66
  801c61:	68 79 43 80 00       	push   $0x804379
  801c66:	e8 af ee ff ff       	call   800b1a <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801c6b:	c1 e2 0c             	shl    $0xc,%edx
  801c6e:	83 ec 0c             	sub    $0xc,%esp
  801c71:	6a 05                	push   $0x5
  801c73:	52                   	push   %edx
  801c74:	50                   	push   %eax
  801c75:	52                   	push   %edx
  801c76:	6a 00                	push   $0x0
  801c78:	e8 17 fc ff ff       	call   801894 <sys_page_map>
		if(r < 0)
  801c7d:	83 c4 20             	add    $0x20,%esp
  801c80:	85 c0                	test   %eax,%eax
  801c82:	0f 89 0c ff ff ff    	jns    801b94 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801c88:	83 ec 04             	sub    $0x4,%esp
  801c8b:	68 63 43 80 00       	push   $0x804363
  801c90:	6a 6d                	push   $0x6d
  801c92:	68 79 43 80 00       	push   $0x804379
  801c97:	e8 7e ee ff ff       	call   800b1a <_panic>

00801c9c <pgfault>:
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
  801c9f:	53                   	push   %ebx
  801ca0:	83 ec 04             	sub    $0x4,%esp
  801ca3:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801ca6:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801ca8:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801cac:	0f 84 99 00 00 00    	je     801d4b <pgfault+0xaf>
  801cb2:	89 c2                	mov    %eax,%edx
  801cb4:	c1 ea 16             	shr    $0x16,%edx
  801cb7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801cbe:	f6 c2 01             	test   $0x1,%dl
  801cc1:	0f 84 84 00 00 00    	je     801d4b <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801cc7:	89 c2                	mov    %eax,%edx
  801cc9:	c1 ea 0c             	shr    $0xc,%edx
  801ccc:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801cd3:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801cd9:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801cdf:	75 6a                	jne    801d4b <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801ce1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ce6:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801ce8:	83 ec 04             	sub    $0x4,%esp
  801ceb:	6a 07                	push   $0x7
  801ced:	68 00 f0 7f 00       	push   $0x7ff000
  801cf2:	6a 00                	push   $0x0
  801cf4:	e8 58 fb ff ff       	call   801851 <sys_page_alloc>
	if(ret < 0)
  801cf9:	83 c4 10             	add    $0x10,%esp
  801cfc:	85 c0                	test   %eax,%eax
  801cfe:	78 5f                	js     801d5f <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801d00:	83 ec 04             	sub    $0x4,%esp
  801d03:	68 00 10 00 00       	push   $0x1000
  801d08:	53                   	push   %ebx
  801d09:	68 00 f0 7f 00       	push   $0x7ff000
  801d0e:	e8 3c f9 ff ff       	call   80164f <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801d13:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801d1a:	53                   	push   %ebx
  801d1b:	6a 00                	push   $0x0
  801d1d:	68 00 f0 7f 00       	push   $0x7ff000
  801d22:	6a 00                	push   $0x0
  801d24:	e8 6b fb ff ff       	call   801894 <sys_page_map>
	if(ret < 0)
  801d29:	83 c4 20             	add    $0x20,%esp
  801d2c:	85 c0                	test   %eax,%eax
  801d2e:	78 43                	js     801d73 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801d30:	83 ec 08             	sub    $0x8,%esp
  801d33:	68 00 f0 7f 00       	push   $0x7ff000
  801d38:	6a 00                	push   $0x0
  801d3a:	e8 97 fb ff ff       	call   8018d6 <sys_page_unmap>
	if(ret < 0)
  801d3f:	83 c4 10             	add    $0x10,%esp
  801d42:	85 c0                	test   %eax,%eax
  801d44:	78 41                	js     801d87 <pgfault+0xeb>
}
  801d46:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d49:	c9                   	leave  
  801d4a:	c3                   	ret    
		panic("panic at pgfault()\n");
  801d4b:	83 ec 04             	sub    $0x4,%esp
  801d4e:	68 84 43 80 00       	push   $0x804384
  801d53:	6a 26                	push   $0x26
  801d55:	68 79 43 80 00       	push   $0x804379
  801d5a:	e8 bb ed ff ff       	call   800b1a <_panic>
		panic("panic in sys_page_alloc()\n");
  801d5f:	83 ec 04             	sub    $0x4,%esp
  801d62:	68 98 43 80 00       	push   $0x804398
  801d67:	6a 31                	push   $0x31
  801d69:	68 79 43 80 00       	push   $0x804379
  801d6e:	e8 a7 ed ff ff       	call   800b1a <_panic>
		panic("panic in sys_page_map()\n");
  801d73:	83 ec 04             	sub    $0x4,%esp
  801d76:	68 b3 43 80 00       	push   $0x8043b3
  801d7b:	6a 36                	push   $0x36
  801d7d:	68 79 43 80 00       	push   $0x804379
  801d82:	e8 93 ed ff ff       	call   800b1a <_panic>
		panic("panic in sys_page_unmap()\n");
  801d87:	83 ec 04             	sub    $0x4,%esp
  801d8a:	68 cc 43 80 00       	push   $0x8043cc
  801d8f:	6a 39                	push   $0x39
  801d91:	68 79 43 80 00       	push   $0x804379
  801d96:	e8 7f ed ff ff       	call   800b1a <_panic>

00801d9b <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
  801d9e:	57                   	push   %edi
  801d9f:	56                   	push   %esi
  801da0:	53                   	push   %ebx
  801da1:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801da4:	68 9c 1c 80 00       	push   $0x801c9c
  801da9:	e8 2c 1b 00 00       	call   8038da <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801dae:	b8 07 00 00 00       	mov    $0x7,%eax
  801db3:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801db5:	83 c4 10             	add    $0x10,%esp
  801db8:	85 c0                	test   %eax,%eax
  801dba:	78 27                	js     801de3 <fork+0x48>
  801dbc:	89 c6                	mov    %eax,%esi
  801dbe:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801dc0:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801dc5:	75 48                	jne    801e0f <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  801dc7:	e8 47 fa ff ff       	call   801813 <sys_getenvid>
  801dcc:	25 ff 03 00 00       	and    $0x3ff,%eax
  801dd1:	c1 e0 07             	shl    $0x7,%eax
  801dd4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801dd9:	a3 28 64 80 00       	mov    %eax,0x806428
		return 0;
  801dde:	e9 90 00 00 00       	jmp    801e73 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  801de3:	83 ec 04             	sub    $0x4,%esp
  801de6:	68 e8 43 80 00       	push   $0x8043e8
  801deb:	68 8c 00 00 00       	push   $0x8c
  801df0:	68 79 43 80 00       	push   $0x804379
  801df5:	e8 20 ed ff ff       	call   800b1a <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801dfa:	89 f8                	mov    %edi,%eax
  801dfc:	e8 45 fd ff ff       	call   801b46 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801e01:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801e07:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801e0d:	74 26                	je     801e35 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801e0f:	89 d8                	mov    %ebx,%eax
  801e11:	c1 e8 16             	shr    $0x16,%eax
  801e14:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801e1b:	a8 01                	test   $0x1,%al
  801e1d:	74 e2                	je     801e01 <fork+0x66>
  801e1f:	89 da                	mov    %ebx,%edx
  801e21:	c1 ea 0c             	shr    $0xc,%edx
  801e24:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801e2b:	83 e0 05             	and    $0x5,%eax
  801e2e:	83 f8 05             	cmp    $0x5,%eax
  801e31:	75 ce                	jne    801e01 <fork+0x66>
  801e33:	eb c5                	jmp    801dfa <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801e35:	83 ec 04             	sub    $0x4,%esp
  801e38:	6a 07                	push   $0x7
  801e3a:	68 00 f0 bf ee       	push   $0xeebff000
  801e3f:	56                   	push   %esi
  801e40:	e8 0c fa ff ff       	call   801851 <sys_page_alloc>
	if(ret < 0)
  801e45:	83 c4 10             	add    $0x10,%esp
  801e48:	85 c0                	test   %eax,%eax
  801e4a:	78 31                	js     801e7d <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801e4c:	83 ec 08             	sub    $0x8,%esp
  801e4f:	68 49 39 80 00       	push   $0x803949
  801e54:	56                   	push   %esi
  801e55:	e8 42 fb ff ff       	call   80199c <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801e5a:	83 c4 10             	add    $0x10,%esp
  801e5d:	85 c0                	test   %eax,%eax
  801e5f:	78 33                	js     801e94 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801e61:	83 ec 08             	sub    $0x8,%esp
  801e64:	6a 02                	push   $0x2
  801e66:	56                   	push   %esi
  801e67:	e8 ac fa ff ff       	call   801918 <sys_env_set_status>
	if(ret < 0)
  801e6c:	83 c4 10             	add    $0x10,%esp
  801e6f:	85 c0                	test   %eax,%eax
  801e71:	78 38                	js     801eab <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801e73:	89 f0                	mov    %esi,%eax
  801e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e78:	5b                   	pop    %ebx
  801e79:	5e                   	pop    %esi
  801e7a:	5f                   	pop    %edi
  801e7b:	5d                   	pop    %ebp
  801e7c:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801e7d:	83 ec 04             	sub    $0x4,%esp
  801e80:	68 98 43 80 00       	push   $0x804398
  801e85:	68 98 00 00 00       	push   $0x98
  801e8a:	68 79 43 80 00       	push   $0x804379
  801e8f:	e8 86 ec ff ff       	call   800b1a <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801e94:	83 ec 04             	sub    $0x4,%esp
  801e97:	68 0c 44 80 00       	push   $0x80440c
  801e9c:	68 9b 00 00 00       	push   $0x9b
  801ea1:	68 79 43 80 00       	push   $0x804379
  801ea6:	e8 6f ec ff ff       	call   800b1a <_panic>
		panic("panic in sys_env_set_status()\n");
  801eab:	83 ec 04             	sub    $0x4,%esp
  801eae:	68 34 44 80 00       	push   $0x804434
  801eb3:	68 9e 00 00 00       	push   $0x9e
  801eb8:	68 79 43 80 00       	push   $0x804379
  801ebd:	e8 58 ec ff ff       	call   800b1a <_panic>

00801ec2 <sfork>:

// Challenge!
int
sfork(void)
{
  801ec2:	55                   	push   %ebp
  801ec3:	89 e5                	mov    %esp,%ebp
  801ec5:	57                   	push   %edi
  801ec6:	56                   	push   %esi
  801ec7:	53                   	push   %ebx
  801ec8:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801ecb:	68 9c 1c 80 00       	push   $0x801c9c
  801ed0:	e8 05 1a 00 00       	call   8038da <set_pgfault_handler>
  801ed5:	b8 07 00 00 00       	mov    $0x7,%eax
  801eda:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801edc:	83 c4 10             	add    $0x10,%esp
  801edf:	85 c0                	test   %eax,%eax
  801ee1:	78 27                	js     801f0a <sfork+0x48>
  801ee3:	89 c7                	mov    %eax,%edi
  801ee5:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801ee7:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801eec:	75 55                	jne    801f43 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801eee:	e8 20 f9 ff ff       	call   801813 <sys_getenvid>
  801ef3:	25 ff 03 00 00       	and    $0x3ff,%eax
  801ef8:	c1 e0 07             	shl    $0x7,%eax
  801efb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801f00:	a3 28 64 80 00       	mov    %eax,0x806428
		return 0;
  801f05:	e9 d4 00 00 00       	jmp    801fde <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  801f0a:	83 ec 04             	sub    $0x4,%esp
  801f0d:	68 e8 43 80 00       	push   $0x8043e8
  801f12:	68 af 00 00 00       	push   $0xaf
  801f17:	68 79 43 80 00       	push   $0x804379
  801f1c:	e8 f9 eb ff ff       	call   800b1a <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801f21:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801f26:	89 f0                	mov    %esi,%eax
  801f28:	e8 19 fc ff ff       	call   801b46 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801f2d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801f33:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801f39:	77 65                	ja     801fa0 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801f3b:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801f41:	74 de                	je     801f21 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801f43:	89 d8                	mov    %ebx,%eax
  801f45:	c1 e8 16             	shr    $0x16,%eax
  801f48:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801f4f:	a8 01                	test   $0x1,%al
  801f51:	74 da                	je     801f2d <sfork+0x6b>
  801f53:	89 da                	mov    %ebx,%edx
  801f55:	c1 ea 0c             	shr    $0xc,%edx
  801f58:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801f5f:	83 e0 05             	and    $0x5,%eax
  801f62:	83 f8 05             	cmp    $0x5,%eax
  801f65:	75 c6                	jne    801f2d <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801f67:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801f6e:	c1 e2 0c             	shl    $0xc,%edx
  801f71:	83 ec 0c             	sub    $0xc,%esp
  801f74:	83 e0 07             	and    $0x7,%eax
  801f77:	50                   	push   %eax
  801f78:	52                   	push   %edx
  801f79:	56                   	push   %esi
  801f7a:	52                   	push   %edx
  801f7b:	6a 00                	push   $0x0
  801f7d:	e8 12 f9 ff ff       	call   801894 <sys_page_map>
  801f82:	83 c4 20             	add    $0x20,%esp
  801f85:	85 c0                	test   %eax,%eax
  801f87:	74 a4                	je     801f2d <sfork+0x6b>
				panic("sys_page_map() panic\n");
  801f89:	83 ec 04             	sub    $0x4,%esp
  801f8c:	68 63 43 80 00       	push   $0x804363
  801f91:	68 ba 00 00 00       	push   $0xba
  801f96:	68 79 43 80 00       	push   $0x804379
  801f9b:	e8 7a eb ff ff       	call   800b1a <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801fa0:	83 ec 04             	sub    $0x4,%esp
  801fa3:	6a 07                	push   $0x7
  801fa5:	68 00 f0 bf ee       	push   $0xeebff000
  801faa:	57                   	push   %edi
  801fab:	e8 a1 f8 ff ff       	call   801851 <sys_page_alloc>
	if(ret < 0)
  801fb0:	83 c4 10             	add    $0x10,%esp
  801fb3:	85 c0                	test   %eax,%eax
  801fb5:	78 31                	js     801fe8 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801fb7:	83 ec 08             	sub    $0x8,%esp
  801fba:	68 49 39 80 00       	push   $0x803949
  801fbf:	57                   	push   %edi
  801fc0:	e8 d7 f9 ff ff       	call   80199c <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801fc5:	83 c4 10             	add    $0x10,%esp
  801fc8:	85 c0                	test   %eax,%eax
  801fca:	78 33                	js     801fff <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801fcc:	83 ec 08             	sub    $0x8,%esp
  801fcf:	6a 02                	push   $0x2
  801fd1:	57                   	push   %edi
  801fd2:	e8 41 f9 ff ff       	call   801918 <sys_env_set_status>
	if(ret < 0)
  801fd7:	83 c4 10             	add    $0x10,%esp
  801fda:	85 c0                	test   %eax,%eax
  801fdc:	78 38                	js     802016 <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801fde:	89 f8                	mov    %edi,%eax
  801fe0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fe3:	5b                   	pop    %ebx
  801fe4:	5e                   	pop    %esi
  801fe5:	5f                   	pop    %edi
  801fe6:	5d                   	pop    %ebp
  801fe7:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801fe8:	83 ec 04             	sub    $0x4,%esp
  801feb:	68 98 43 80 00       	push   $0x804398
  801ff0:	68 c0 00 00 00       	push   $0xc0
  801ff5:	68 79 43 80 00       	push   $0x804379
  801ffa:	e8 1b eb ff ff       	call   800b1a <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801fff:	83 ec 04             	sub    $0x4,%esp
  802002:	68 0c 44 80 00       	push   $0x80440c
  802007:	68 c3 00 00 00       	push   $0xc3
  80200c:	68 79 43 80 00       	push   $0x804379
  802011:	e8 04 eb ff ff       	call   800b1a <_panic>
		panic("panic in sys_env_set_status()\n");
  802016:	83 ec 04             	sub    $0x4,%esp
  802019:	68 34 44 80 00       	push   $0x804434
  80201e:	68 c6 00 00 00       	push   $0xc6
  802023:	68 79 43 80 00       	push   $0x804379
  802028:	e8 ed ea ff ff       	call   800b1a <_panic>

0080202d <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  80202d:	55                   	push   %ebp
  80202e:	89 e5                	mov    %esp,%ebp
  802030:	8b 55 08             	mov    0x8(%ebp),%edx
  802033:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802036:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  802039:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  80203b:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  80203e:	83 3a 01             	cmpl   $0x1,(%edx)
  802041:	7e 09                	jle    80204c <argstart+0x1f>
  802043:	ba 21 3d 80 00       	mov    $0x803d21,%edx
  802048:	85 c9                	test   %ecx,%ecx
  80204a:	75 05                	jne    802051 <argstart+0x24>
  80204c:	ba 00 00 00 00       	mov    $0x0,%edx
  802051:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  802054:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  80205b:	5d                   	pop    %ebp
  80205c:	c3                   	ret    

0080205d <argnext>:

int
argnext(struct Argstate *args)
{
  80205d:	55                   	push   %ebp
  80205e:	89 e5                	mov    %esp,%ebp
  802060:	53                   	push   %ebx
  802061:	83 ec 04             	sub    $0x4,%esp
  802064:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  802067:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  80206e:	8b 43 08             	mov    0x8(%ebx),%eax
  802071:	85 c0                	test   %eax,%eax
  802073:	74 72                	je     8020e7 <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  802075:	80 38 00             	cmpb   $0x0,(%eax)
  802078:	75 48                	jne    8020c2 <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  80207a:	8b 0b                	mov    (%ebx),%ecx
  80207c:	83 39 01             	cmpl   $0x1,(%ecx)
  80207f:	74 58                	je     8020d9 <argnext+0x7c>
		    || args->argv[1][0] != '-'
  802081:	8b 53 04             	mov    0x4(%ebx),%edx
  802084:	8b 42 04             	mov    0x4(%edx),%eax
  802087:	80 38 2d             	cmpb   $0x2d,(%eax)
  80208a:	75 4d                	jne    8020d9 <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  80208c:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  802090:	74 47                	je     8020d9 <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  802092:	83 c0 01             	add    $0x1,%eax
  802095:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  802098:	83 ec 04             	sub    $0x4,%esp
  80209b:	8b 01                	mov    (%ecx),%eax
  80209d:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  8020a4:	50                   	push   %eax
  8020a5:	8d 42 08             	lea    0x8(%edx),%eax
  8020a8:	50                   	push   %eax
  8020a9:	83 c2 04             	add    $0x4,%edx
  8020ac:	52                   	push   %edx
  8020ad:	e8 3b f5 ff ff       	call   8015ed <memmove>
		(*args->argc)--;
  8020b2:	8b 03                	mov    (%ebx),%eax
  8020b4:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8020b7:	8b 43 08             	mov    0x8(%ebx),%eax
  8020ba:	83 c4 10             	add    $0x10,%esp
  8020bd:	80 38 2d             	cmpb   $0x2d,(%eax)
  8020c0:	74 11                	je     8020d3 <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  8020c2:	8b 53 08             	mov    0x8(%ebx),%edx
  8020c5:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  8020c8:	83 c2 01             	add    $0x1,%edx
  8020cb:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  8020ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020d1:	c9                   	leave  
  8020d2:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8020d3:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  8020d7:	75 e9                	jne    8020c2 <argnext+0x65>
	args->curarg = 0;
  8020d9:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  8020e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8020e5:	eb e7                	jmp    8020ce <argnext+0x71>
		return -1;
  8020e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8020ec:	eb e0                	jmp    8020ce <argnext+0x71>

008020ee <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  8020ee:	55                   	push   %ebp
  8020ef:	89 e5                	mov    %esp,%ebp
  8020f1:	53                   	push   %ebx
  8020f2:	83 ec 04             	sub    $0x4,%esp
  8020f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  8020f8:	8b 43 08             	mov    0x8(%ebx),%eax
  8020fb:	85 c0                	test   %eax,%eax
  8020fd:	74 12                	je     802111 <argnextvalue+0x23>
		return 0;
	if (*args->curarg) {
  8020ff:	80 38 00             	cmpb   $0x0,(%eax)
  802102:	74 12                	je     802116 <argnextvalue+0x28>
		args->argvalue = args->curarg;
  802104:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  802107:	c7 43 08 21 3d 80 00 	movl   $0x803d21,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  80210e:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  802111:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802114:	c9                   	leave  
  802115:	c3                   	ret    
	} else if (*args->argc > 1) {
  802116:	8b 13                	mov    (%ebx),%edx
  802118:	83 3a 01             	cmpl   $0x1,(%edx)
  80211b:	7f 10                	jg     80212d <argnextvalue+0x3f>
		args->argvalue = 0;
  80211d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  802124:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  80212b:	eb e1                	jmp    80210e <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  80212d:	8b 43 04             	mov    0x4(%ebx),%eax
  802130:	8b 48 04             	mov    0x4(%eax),%ecx
  802133:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  802136:	83 ec 04             	sub    $0x4,%esp
  802139:	8b 12                	mov    (%edx),%edx
  80213b:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  802142:	52                   	push   %edx
  802143:	8d 50 08             	lea    0x8(%eax),%edx
  802146:	52                   	push   %edx
  802147:	83 c0 04             	add    $0x4,%eax
  80214a:	50                   	push   %eax
  80214b:	e8 9d f4 ff ff       	call   8015ed <memmove>
		(*args->argc)--;
  802150:	8b 03                	mov    (%ebx),%eax
  802152:	83 28 01             	subl   $0x1,(%eax)
  802155:	83 c4 10             	add    $0x10,%esp
  802158:	eb b4                	jmp    80210e <argnextvalue+0x20>

0080215a <argvalue>:
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
  80215d:	83 ec 08             	sub    $0x8,%esp
  802160:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  802163:	8b 42 0c             	mov    0xc(%edx),%eax
  802166:	85 c0                	test   %eax,%eax
  802168:	74 02                	je     80216c <argvalue+0x12>
}
  80216a:	c9                   	leave  
  80216b:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  80216c:	83 ec 0c             	sub    $0xc,%esp
  80216f:	52                   	push   %edx
  802170:	e8 79 ff ff ff       	call   8020ee <argnextvalue>
  802175:	83 c4 10             	add    $0x10,%esp
  802178:	eb f0                	jmp    80216a <argvalue+0x10>

0080217a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80217a:	55                   	push   %ebp
  80217b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80217d:	8b 45 08             	mov    0x8(%ebp),%eax
  802180:	05 00 00 00 30       	add    $0x30000000,%eax
  802185:	c1 e8 0c             	shr    $0xc,%eax
}
  802188:	5d                   	pop    %ebp
  802189:	c3                   	ret    

0080218a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80218a:	55                   	push   %ebp
  80218b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80218d:	8b 45 08             	mov    0x8(%ebp),%eax
  802190:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  802195:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80219a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80219f:	5d                   	pop    %ebp
  8021a0:	c3                   	ret    

008021a1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8021a1:	55                   	push   %ebp
  8021a2:	89 e5                	mov    %esp,%ebp
  8021a4:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8021a9:	89 c2                	mov    %eax,%edx
  8021ab:	c1 ea 16             	shr    $0x16,%edx
  8021ae:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8021b5:	f6 c2 01             	test   $0x1,%dl
  8021b8:	74 2d                	je     8021e7 <fd_alloc+0x46>
  8021ba:	89 c2                	mov    %eax,%edx
  8021bc:	c1 ea 0c             	shr    $0xc,%edx
  8021bf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8021c6:	f6 c2 01             	test   $0x1,%dl
  8021c9:	74 1c                	je     8021e7 <fd_alloc+0x46>
  8021cb:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8021d0:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8021d5:	75 d2                	jne    8021a9 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8021d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8021e0:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8021e5:	eb 0a                	jmp    8021f1 <fd_alloc+0x50>
			*fd_store = fd;
  8021e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021ea:	89 01                	mov    %eax,(%ecx)
			return 0;
  8021ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021f1:	5d                   	pop    %ebp
  8021f2:	c3                   	ret    

008021f3 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8021f3:	55                   	push   %ebp
  8021f4:	89 e5                	mov    %esp,%ebp
  8021f6:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8021f9:	83 f8 1f             	cmp    $0x1f,%eax
  8021fc:	77 30                	ja     80222e <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8021fe:	c1 e0 0c             	shl    $0xc,%eax
  802201:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802206:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80220c:	f6 c2 01             	test   $0x1,%dl
  80220f:	74 24                	je     802235 <fd_lookup+0x42>
  802211:	89 c2                	mov    %eax,%edx
  802213:	c1 ea 0c             	shr    $0xc,%edx
  802216:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80221d:	f6 c2 01             	test   $0x1,%dl
  802220:	74 1a                	je     80223c <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  802222:	8b 55 0c             	mov    0xc(%ebp),%edx
  802225:	89 02                	mov    %eax,(%edx)
	return 0;
  802227:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80222c:	5d                   	pop    %ebp
  80222d:	c3                   	ret    
		return -E_INVAL;
  80222e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802233:	eb f7                	jmp    80222c <fd_lookup+0x39>
		return -E_INVAL;
  802235:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80223a:	eb f0                	jmp    80222c <fd_lookup+0x39>
  80223c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802241:	eb e9                	jmp    80222c <fd_lookup+0x39>

00802243 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802243:	55                   	push   %ebp
  802244:	89 e5                	mov    %esp,%ebp
  802246:	83 ec 08             	sub    $0x8,%esp
  802249:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80224c:	ba 00 00 00 00       	mov    $0x0,%edx
  802251:	b8 20 50 80 00       	mov    $0x805020,%eax
		if (devtab[i]->dev_id == dev_id) {
  802256:	39 08                	cmp    %ecx,(%eax)
  802258:	74 38                	je     802292 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80225a:	83 c2 01             	add    $0x1,%edx
  80225d:	8b 04 95 d0 44 80 00 	mov    0x8044d0(,%edx,4),%eax
  802264:	85 c0                	test   %eax,%eax
  802266:	75 ee                	jne    802256 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802268:	a1 28 64 80 00       	mov    0x806428,%eax
  80226d:	8b 40 48             	mov    0x48(%eax),%eax
  802270:	83 ec 04             	sub    $0x4,%esp
  802273:	51                   	push   %ecx
  802274:	50                   	push   %eax
  802275:	68 54 44 80 00       	push   $0x804454
  80227a:	e8 91 e9 ff ff       	call   800c10 <cprintf>
	*dev = 0;
  80227f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802282:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  802288:	83 c4 10             	add    $0x10,%esp
  80228b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802290:	c9                   	leave  
  802291:	c3                   	ret    
			*dev = devtab[i];
  802292:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802295:	89 01                	mov    %eax,(%ecx)
			return 0;
  802297:	b8 00 00 00 00       	mov    $0x0,%eax
  80229c:	eb f2                	jmp    802290 <dev_lookup+0x4d>

0080229e <fd_close>:
{
  80229e:	55                   	push   %ebp
  80229f:	89 e5                	mov    %esp,%ebp
  8022a1:	57                   	push   %edi
  8022a2:	56                   	push   %esi
  8022a3:	53                   	push   %ebx
  8022a4:	83 ec 24             	sub    $0x24,%esp
  8022a7:	8b 75 08             	mov    0x8(%ebp),%esi
  8022aa:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8022ad:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8022b0:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8022b1:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8022b7:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8022ba:	50                   	push   %eax
  8022bb:	e8 33 ff ff ff       	call   8021f3 <fd_lookup>
  8022c0:	89 c3                	mov    %eax,%ebx
  8022c2:	83 c4 10             	add    $0x10,%esp
  8022c5:	85 c0                	test   %eax,%eax
  8022c7:	78 05                	js     8022ce <fd_close+0x30>
	    || fd != fd2)
  8022c9:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8022cc:	74 16                	je     8022e4 <fd_close+0x46>
		return (must_exist ? r : 0);
  8022ce:	89 f8                	mov    %edi,%eax
  8022d0:	84 c0                	test   %al,%al
  8022d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d7:	0f 44 d8             	cmove  %eax,%ebx
}
  8022da:	89 d8                	mov    %ebx,%eax
  8022dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022df:	5b                   	pop    %ebx
  8022e0:	5e                   	pop    %esi
  8022e1:	5f                   	pop    %edi
  8022e2:	5d                   	pop    %ebp
  8022e3:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8022e4:	83 ec 08             	sub    $0x8,%esp
  8022e7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8022ea:	50                   	push   %eax
  8022eb:	ff 36                	pushl  (%esi)
  8022ed:	e8 51 ff ff ff       	call   802243 <dev_lookup>
  8022f2:	89 c3                	mov    %eax,%ebx
  8022f4:	83 c4 10             	add    $0x10,%esp
  8022f7:	85 c0                	test   %eax,%eax
  8022f9:	78 1a                	js     802315 <fd_close+0x77>
		if (dev->dev_close)
  8022fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022fe:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  802301:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  802306:	85 c0                	test   %eax,%eax
  802308:	74 0b                	je     802315 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80230a:	83 ec 0c             	sub    $0xc,%esp
  80230d:	56                   	push   %esi
  80230e:	ff d0                	call   *%eax
  802310:	89 c3                	mov    %eax,%ebx
  802312:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  802315:	83 ec 08             	sub    $0x8,%esp
  802318:	56                   	push   %esi
  802319:	6a 00                	push   $0x0
  80231b:	e8 b6 f5 ff ff       	call   8018d6 <sys_page_unmap>
	return r;
  802320:	83 c4 10             	add    $0x10,%esp
  802323:	eb b5                	jmp    8022da <fd_close+0x3c>

00802325 <close>:

int
close(int fdnum)
{
  802325:	55                   	push   %ebp
  802326:	89 e5                	mov    %esp,%ebp
  802328:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80232b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80232e:	50                   	push   %eax
  80232f:	ff 75 08             	pushl  0x8(%ebp)
  802332:	e8 bc fe ff ff       	call   8021f3 <fd_lookup>
  802337:	83 c4 10             	add    $0x10,%esp
  80233a:	85 c0                	test   %eax,%eax
  80233c:	79 02                	jns    802340 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80233e:	c9                   	leave  
  80233f:	c3                   	ret    
		return fd_close(fd, 1);
  802340:	83 ec 08             	sub    $0x8,%esp
  802343:	6a 01                	push   $0x1
  802345:	ff 75 f4             	pushl  -0xc(%ebp)
  802348:	e8 51 ff ff ff       	call   80229e <fd_close>
  80234d:	83 c4 10             	add    $0x10,%esp
  802350:	eb ec                	jmp    80233e <close+0x19>

00802352 <close_all>:

void
close_all(void)
{
  802352:	55                   	push   %ebp
  802353:	89 e5                	mov    %esp,%ebp
  802355:	53                   	push   %ebx
  802356:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  802359:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80235e:	83 ec 0c             	sub    $0xc,%esp
  802361:	53                   	push   %ebx
  802362:	e8 be ff ff ff       	call   802325 <close>
	for (i = 0; i < MAXFD; i++)
  802367:	83 c3 01             	add    $0x1,%ebx
  80236a:	83 c4 10             	add    $0x10,%esp
  80236d:	83 fb 20             	cmp    $0x20,%ebx
  802370:	75 ec                	jne    80235e <close_all+0xc>
}
  802372:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802375:	c9                   	leave  
  802376:	c3                   	ret    

00802377 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802377:	55                   	push   %ebp
  802378:	89 e5                	mov    %esp,%ebp
  80237a:	57                   	push   %edi
  80237b:	56                   	push   %esi
  80237c:	53                   	push   %ebx
  80237d:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802380:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802383:	50                   	push   %eax
  802384:	ff 75 08             	pushl  0x8(%ebp)
  802387:	e8 67 fe ff ff       	call   8021f3 <fd_lookup>
  80238c:	89 c3                	mov    %eax,%ebx
  80238e:	83 c4 10             	add    $0x10,%esp
  802391:	85 c0                	test   %eax,%eax
  802393:	0f 88 81 00 00 00    	js     80241a <dup+0xa3>
		return r;
	close(newfdnum);
  802399:	83 ec 0c             	sub    $0xc,%esp
  80239c:	ff 75 0c             	pushl  0xc(%ebp)
  80239f:	e8 81 ff ff ff       	call   802325 <close>

	newfd = INDEX2FD(newfdnum);
  8023a4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8023a7:	c1 e6 0c             	shl    $0xc,%esi
  8023aa:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8023b0:	83 c4 04             	add    $0x4,%esp
  8023b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8023b6:	e8 cf fd ff ff       	call   80218a <fd2data>
  8023bb:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8023bd:	89 34 24             	mov    %esi,(%esp)
  8023c0:	e8 c5 fd ff ff       	call   80218a <fd2data>
  8023c5:	83 c4 10             	add    $0x10,%esp
  8023c8:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8023ca:	89 d8                	mov    %ebx,%eax
  8023cc:	c1 e8 16             	shr    $0x16,%eax
  8023cf:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8023d6:	a8 01                	test   $0x1,%al
  8023d8:	74 11                	je     8023eb <dup+0x74>
  8023da:	89 d8                	mov    %ebx,%eax
  8023dc:	c1 e8 0c             	shr    $0xc,%eax
  8023df:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8023e6:	f6 c2 01             	test   $0x1,%dl
  8023e9:	75 39                	jne    802424 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8023eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023ee:	89 d0                	mov    %edx,%eax
  8023f0:	c1 e8 0c             	shr    $0xc,%eax
  8023f3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8023fa:	83 ec 0c             	sub    $0xc,%esp
  8023fd:	25 07 0e 00 00       	and    $0xe07,%eax
  802402:	50                   	push   %eax
  802403:	56                   	push   %esi
  802404:	6a 00                	push   $0x0
  802406:	52                   	push   %edx
  802407:	6a 00                	push   $0x0
  802409:	e8 86 f4 ff ff       	call   801894 <sys_page_map>
  80240e:	89 c3                	mov    %eax,%ebx
  802410:	83 c4 20             	add    $0x20,%esp
  802413:	85 c0                	test   %eax,%eax
  802415:	78 31                	js     802448 <dup+0xd1>
		goto err;

	return newfdnum;
  802417:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80241a:	89 d8                	mov    %ebx,%eax
  80241c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80241f:	5b                   	pop    %ebx
  802420:	5e                   	pop    %esi
  802421:	5f                   	pop    %edi
  802422:	5d                   	pop    %ebp
  802423:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802424:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80242b:	83 ec 0c             	sub    $0xc,%esp
  80242e:	25 07 0e 00 00       	and    $0xe07,%eax
  802433:	50                   	push   %eax
  802434:	57                   	push   %edi
  802435:	6a 00                	push   $0x0
  802437:	53                   	push   %ebx
  802438:	6a 00                	push   $0x0
  80243a:	e8 55 f4 ff ff       	call   801894 <sys_page_map>
  80243f:	89 c3                	mov    %eax,%ebx
  802441:	83 c4 20             	add    $0x20,%esp
  802444:	85 c0                	test   %eax,%eax
  802446:	79 a3                	jns    8023eb <dup+0x74>
	sys_page_unmap(0, newfd);
  802448:	83 ec 08             	sub    $0x8,%esp
  80244b:	56                   	push   %esi
  80244c:	6a 00                	push   $0x0
  80244e:	e8 83 f4 ff ff       	call   8018d6 <sys_page_unmap>
	sys_page_unmap(0, nva);
  802453:	83 c4 08             	add    $0x8,%esp
  802456:	57                   	push   %edi
  802457:	6a 00                	push   $0x0
  802459:	e8 78 f4 ff ff       	call   8018d6 <sys_page_unmap>
	return r;
  80245e:	83 c4 10             	add    $0x10,%esp
  802461:	eb b7                	jmp    80241a <dup+0xa3>

00802463 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802463:	55                   	push   %ebp
  802464:	89 e5                	mov    %esp,%ebp
  802466:	53                   	push   %ebx
  802467:	83 ec 1c             	sub    $0x1c,%esp
  80246a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80246d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802470:	50                   	push   %eax
  802471:	53                   	push   %ebx
  802472:	e8 7c fd ff ff       	call   8021f3 <fd_lookup>
  802477:	83 c4 10             	add    $0x10,%esp
  80247a:	85 c0                	test   %eax,%eax
  80247c:	78 3f                	js     8024bd <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80247e:	83 ec 08             	sub    $0x8,%esp
  802481:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802484:	50                   	push   %eax
  802485:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802488:	ff 30                	pushl  (%eax)
  80248a:	e8 b4 fd ff ff       	call   802243 <dev_lookup>
  80248f:	83 c4 10             	add    $0x10,%esp
  802492:	85 c0                	test   %eax,%eax
  802494:	78 27                	js     8024bd <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802496:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802499:	8b 42 08             	mov    0x8(%edx),%eax
  80249c:	83 e0 03             	and    $0x3,%eax
  80249f:	83 f8 01             	cmp    $0x1,%eax
  8024a2:	74 1e                	je     8024c2 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8024a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a7:	8b 40 08             	mov    0x8(%eax),%eax
  8024aa:	85 c0                	test   %eax,%eax
  8024ac:	74 35                	je     8024e3 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8024ae:	83 ec 04             	sub    $0x4,%esp
  8024b1:	ff 75 10             	pushl  0x10(%ebp)
  8024b4:	ff 75 0c             	pushl  0xc(%ebp)
  8024b7:	52                   	push   %edx
  8024b8:	ff d0                	call   *%eax
  8024ba:	83 c4 10             	add    $0x10,%esp
}
  8024bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024c0:	c9                   	leave  
  8024c1:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8024c2:	a1 28 64 80 00       	mov    0x806428,%eax
  8024c7:	8b 40 48             	mov    0x48(%eax),%eax
  8024ca:	83 ec 04             	sub    $0x4,%esp
  8024cd:	53                   	push   %ebx
  8024ce:	50                   	push   %eax
  8024cf:	68 95 44 80 00       	push   $0x804495
  8024d4:	e8 37 e7 ff ff       	call   800c10 <cprintf>
		return -E_INVAL;
  8024d9:	83 c4 10             	add    $0x10,%esp
  8024dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024e1:	eb da                	jmp    8024bd <read+0x5a>
		return -E_NOT_SUPP;
  8024e3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8024e8:	eb d3                	jmp    8024bd <read+0x5a>

008024ea <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8024ea:	55                   	push   %ebp
  8024eb:	89 e5                	mov    %esp,%ebp
  8024ed:	57                   	push   %edi
  8024ee:	56                   	push   %esi
  8024ef:	53                   	push   %ebx
  8024f0:	83 ec 0c             	sub    $0xc,%esp
  8024f3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8024f6:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8024f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8024fe:	39 f3                	cmp    %esi,%ebx
  802500:	73 23                	jae    802525 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802502:	83 ec 04             	sub    $0x4,%esp
  802505:	89 f0                	mov    %esi,%eax
  802507:	29 d8                	sub    %ebx,%eax
  802509:	50                   	push   %eax
  80250a:	89 d8                	mov    %ebx,%eax
  80250c:	03 45 0c             	add    0xc(%ebp),%eax
  80250f:	50                   	push   %eax
  802510:	57                   	push   %edi
  802511:	e8 4d ff ff ff       	call   802463 <read>
		if (m < 0)
  802516:	83 c4 10             	add    $0x10,%esp
  802519:	85 c0                	test   %eax,%eax
  80251b:	78 06                	js     802523 <readn+0x39>
			return m;
		if (m == 0)
  80251d:	74 06                	je     802525 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80251f:	01 c3                	add    %eax,%ebx
  802521:	eb db                	jmp    8024fe <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802523:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  802525:	89 d8                	mov    %ebx,%eax
  802527:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80252a:	5b                   	pop    %ebx
  80252b:	5e                   	pop    %esi
  80252c:	5f                   	pop    %edi
  80252d:	5d                   	pop    %ebp
  80252e:	c3                   	ret    

0080252f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80252f:	55                   	push   %ebp
  802530:	89 e5                	mov    %esp,%ebp
  802532:	53                   	push   %ebx
  802533:	83 ec 1c             	sub    $0x1c,%esp
  802536:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802539:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80253c:	50                   	push   %eax
  80253d:	53                   	push   %ebx
  80253e:	e8 b0 fc ff ff       	call   8021f3 <fd_lookup>
  802543:	83 c4 10             	add    $0x10,%esp
  802546:	85 c0                	test   %eax,%eax
  802548:	78 3a                	js     802584 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80254a:	83 ec 08             	sub    $0x8,%esp
  80254d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802550:	50                   	push   %eax
  802551:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802554:	ff 30                	pushl  (%eax)
  802556:	e8 e8 fc ff ff       	call   802243 <dev_lookup>
  80255b:	83 c4 10             	add    $0x10,%esp
  80255e:	85 c0                	test   %eax,%eax
  802560:	78 22                	js     802584 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802562:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802565:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802569:	74 1e                	je     802589 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80256b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80256e:	8b 52 0c             	mov    0xc(%edx),%edx
  802571:	85 d2                	test   %edx,%edx
  802573:	74 35                	je     8025aa <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802575:	83 ec 04             	sub    $0x4,%esp
  802578:	ff 75 10             	pushl  0x10(%ebp)
  80257b:	ff 75 0c             	pushl  0xc(%ebp)
  80257e:	50                   	push   %eax
  80257f:	ff d2                	call   *%edx
  802581:	83 c4 10             	add    $0x10,%esp
}
  802584:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802587:	c9                   	leave  
  802588:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802589:	a1 28 64 80 00       	mov    0x806428,%eax
  80258e:	8b 40 48             	mov    0x48(%eax),%eax
  802591:	83 ec 04             	sub    $0x4,%esp
  802594:	53                   	push   %ebx
  802595:	50                   	push   %eax
  802596:	68 b1 44 80 00       	push   $0x8044b1
  80259b:	e8 70 e6 ff ff       	call   800c10 <cprintf>
		return -E_INVAL;
  8025a0:	83 c4 10             	add    $0x10,%esp
  8025a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025a8:	eb da                	jmp    802584 <write+0x55>
		return -E_NOT_SUPP;
  8025aa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8025af:	eb d3                	jmp    802584 <write+0x55>

008025b1 <seek>:

int
seek(int fdnum, off_t offset)
{
  8025b1:	55                   	push   %ebp
  8025b2:	89 e5                	mov    %esp,%ebp
  8025b4:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025ba:	50                   	push   %eax
  8025bb:	ff 75 08             	pushl  0x8(%ebp)
  8025be:	e8 30 fc ff ff       	call   8021f3 <fd_lookup>
  8025c3:	83 c4 10             	add    $0x10,%esp
  8025c6:	85 c0                	test   %eax,%eax
  8025c8:	78 0e                	js     8025d8 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8025ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d0:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8025d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025d8:	c9                   	leave  
  8025d9:	c3                   	ret    

008025da <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8025da:	55                   	push   %ebp
  8025db:	89 e5                	mov    %esp,%ebp
  8025dd:	53                   	push   %ebx
  8025de:	83 ec 1c             	sub    $0x1c,%esp
  8025e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8025e7:	50                   	push   %eax
  8025e8:	53                   	push   %ebx
  8025e9:	e8 05 fc ff ff       	call   8021f3 <fd_lookup>
  8025ee:	83 c4 10             	add    $0x10,%esp
  8025f1:	85 c0                	test   %eax,%eax
  8025f3:	78 37                	js     80262c <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025f5:	83 ec 08             	sub    $0x8,%esp
  8025f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025fb:	50                   	push   %eax
  8025fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ff:	ff 30                	pushl  (%eax)
  802601:	e8 3d fc ff ff       	call   802243 <dev_lookup>
  802606:	83 c4 10             	add    $0x10,%esp
  802609:	85 c0                	test   %eax,%eax
  80260b:	78 1f                	js     80262c <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80260d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802610:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802614:	74 1b                	je     802631 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  802616:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802619:	8b 52 18             	mov    0x18(%edx),%edx
  80261c:	85 d2                	test   %edx,%edx
  80261e:	74 32                	je     802652 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  802620:	83 ec 08             	sub    $0x8,%esp
  802623:	ff 75 0c             	pushl  0xc(%ebp)
  802626:	50                   	push   %eax
  802627:	ff d2                	call   *%edx
  802629:	83 c4 10             	add    $0x10,%esp
}
  80262c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80262f:	c9                   	leave  
  802630:	c3                   	ret    
			thisenv->env_id, fdnum);
  802631:	a1 28 64 80 00       	mov    0x806428,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802636:	8b 40 48             	mov    0x48(%eax),%eax
  802639:	83 ec 04             	sub    $0x4,%esp
  80263c:	53                   	push   %ebx
  80263d:	50                   	push   %eax
  80263e:	68 74 44 80 00       	push   $0x804474
  802643:	e8 c8 e5 ff ff       	call   800c10 <cprintf>
		return -E_INVAL;
  802648:	83 c4 10             	add    $0x10,%esp
  80264b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802650:	eb da                	jmp    80262c <ftruncate+0x52>
		return -E_NOT_SUPP;
  802652:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802657:	eb d3                	jmp    80262c <ftruncate+0x52>

00802659 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802659:	55                   	push   %ebp
  80265a:	89 e5                	mov    %esp,%ebp
  80265c:	53                   	push   %ebx
  80265d:	83 ec 1c             	sub    $0x1c,%esp
  802660:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802663:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802666:	50                   	push   %eax
  802667:	ff 75 08             	pushl  0x8(%ebp)
  80266a:	e8 84 fb ff ff       	call   8021f3 <fd_lookup>
  80266f:	83 c4 10             	add    $0x10,%esp
  802672:	85 c0                	test   %eax,%eax
  802674:	78 4b                	js     8026c1 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802676:	83 ec 08             	sub    $0x8,%esp
  802679:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80267c:	50                   	push   %eax
  80267d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802680:	ff 30                	pushl  (%eax)
  802682:	e8 bc fb ff ff       	call   802243 <dev_lookup>
  802687:	83 c4 10             	add    $0x10,%esp
  80268a:	85 c0                	test   %eax,%eax
  80268c:	78 33                	js     8026c1 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80268e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802691:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  802695:	74 2f                	je     8026c6 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  802697:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80269a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8026a1:	00 00 00 
	stat->st_isdir = 0;
  8026a4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8026ab:	00 00 00 
	stat->st_dev = dev;
  8026ae:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8026b4:	83 ec 08             	sub    $0x8,%esp
  8026b7:	53                   	push   %ebx
  8026b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8026bb:	ff 50 14             	call   *0x14(%eax)
  8026be:	83 c4 10             	add    $0x10,%esp
}
  8026c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026c4:	c9                   	leave  
  8026c5:	c3                   	ret    
		return -E_NOT_SUPP;
  8026c6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8026cb:	eb f4                	jmp    8026c1 <fstat+0x68>

008026cd <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8026cd:	55                   	push   %ebp
  8026ce:	89 e5                	mov    %esp,%ebp
  8026d0:	56                   	push   %esi
  8026d1:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8026d2:	83 ec 08             	sub    $0x8,%esp
  8026d5:	6a 00                	push   $0x0
  8026d7:	ff 75 08             	pushl  0x8(%ebp)
  8026da:	e8 22 02 00 00       	call   802901 <open>
  8026df:	89 c3                	mov    %eax,%ebx
  8026e1:	83 c4 10             	add    $0x10,%esp
  8026e4:	85 c0                	test   %eax,%eax
  8026e6:	78 1b                	js     802703 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8026e8:	83 ec 08             	sub    $0x8,%esp
  8026eb:	ff 75 0c             	pushl  0xc(%ebp)
  8026ee:	50                   	push   %eax
  8026ef:	e8 65 ff ff ff       	call   802659 <fstat>
  8026f4:	89 c6                	mov    %eax,%esi
	close(fd);
  8026f6:	89 1c 24             	mov    %ebx,(%esp)
  8026f9:	e8 27 fc ff ff       	call   802325 <close>
	return r;
  8026fe:	83 c4 10             	add    $0x10,%esp
  802701:	89 f3                	mov    %esi,%ebx
}
  802703:	89 d8                	mov    %ebx,%eax
  802705:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802708:	5b                   	pop    %ebx
  802709:	5e                   	pop    %esi
  80270a:	5d                   	pop    %ebp
  80270b:	c3                   	ret    

0080270c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80270c:	55                   	push   %ebp
  80270d:	89 e5                	mov    %esp,%ebp
  80270f:	56                   	push   %esi
  802710:	53                   	push   %ebx
  802711:	89 c6                	mov    %eax,%esi
  802713:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  802715:	83 3d 20 64 80 00 00 	cmpl   $0x0,0x806420
  80271c:	74 27                	je     802745 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80271e:	6a 07                	push   $0x7
  802720:	68 00 70 80 00       	push   $0x807000
  802725:	56                   	push   %esi
  802726:	ff 35 20 64 80 00    	pushl  0x806420
  80272c:	e8 a7 12 00 00       	call   8039d8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  802731:	83 c4 0c             	add    $0xc,%esp
  802734:	6a 00                	push   $0x0
  802736:	53                   	push   %ebx
  802737:	6a 00                	push   $0x0
  802739:	e8 31 12 00 00       	call   80396f <ipc_recv>
}
  80273e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802741:	5b                   	pop    %ebx
  802742:	5e                   	pop    %esi
  802743:	5d                   	pop    %ebp
  802744:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802745:	83 ec 0c             	sub    $0xc,%esp
  802748:	6a 01                	push   $0x1
  80274a:	e8 e1 12 00 00       	call   803a30 <ipc_find_env>
  80274f:	a3 20 64 80 00       	mov    %eax,0x806420
  802754:	83 c4 10             	add    $0x10,%esp
  802757:	eb c5                	jmp    80271e <fsipc+0x12>

00802759 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802759:	55                   	push   %ebp
  80275a:	89 e5                	mov    %esp,%ebp
  80275c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80275f:	8b 45 08             	mov    0x8(%ebp),%eax
  802762:	8b 40 0c             	mov    0xc(%eax),%eax
  802765:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  80276a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80276d:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  802772:	ba 00 00 00 00       	mov    $0x0,%edx
  802777:	b8 02 00 00 00       	mov    $0x2,%eax
  80277c:	e8 8b ff ff ff       	call   80270c <fsipc>
}
  802781:	c9                   	leave  
  802782:	c3                   	ret    

00802783 <devfile_flush>:
{
  802783:	55                   	push   %ebp
  802784:	89 e5                	mov    %esp,%ebp
  802786:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802789:	8b 45 08             	mov    0x8(%ebp),%eax
  80278c:	8b 40 0c             	mov    0xc(%eax),%eax
  80278f:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  802794:	ba 00 00 00 00       	mov    $0x0,%edx
  802799:	b8 06 00 00 00       	mov    $0x6,%eax
  80279e:	e8 69 ff ff ff       	call   80270c <fsipc>
}
  8027a3:	c9                   	leave  
  8027a4:	c3                   	ret    

008027a5 <devfile_stat>:
{
  8027a5:	55                   	push   %ebp
  8027a6:	89 e5                	mov    %esp,%ebp
  8027a8:	53                   	push   %ebx
  8027a9:	83 ec 04             	sub    $0x4,%esp
  8027ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8027af:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b5:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8027ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8027bf:	b8 05 00 00 00       	mov    $0x5,%eax
  8027c4:	e8 43 ff ff ff       	call   80270c <fsipc>
  8027c9:	85 c0                	test   %eax,%eax
  8027cb:	78 2c                	js     8027f9 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8027cd:	83 ec 08             	sub    $0x8,%esp
  8027d0:	68 00 70 80 00       	push   $0x807000
  8027d5:	53                   	push   %ebx
  8027d6:	e8 84 ec ff ff       	call   80145f <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8027db:	a1 80 70 80 00       	mov    0x807080,%eax
  8027e0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8027e6:	a1 84 70 80 00       	mov    0x807084,%eax
  8027eb:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8027f1:	83 c4 10             	add    $0x10,%esp
  8027f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027fc:	c9                   	leave  
  8027fd:	c3                   	ret    

008027fe <devfile_write>:
{
  8027fe:	55                   	push   %ebp
  8027ff:	89 e5                	mov    %esp,%ebp
  802801:	53                   	push   %ebx
  802802:	83 ec 08             	sub    $0x8,%esp
  802805:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802808:	8b 45 08             	mov    0x8(%ebp),%eax
  80280b:	8b 40 0c             	mov    0xc(%eax),%eax
  80280e:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.write.req_n = n;
  802813:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802819:	53                   	push   %ebx
  80281a:	ff 75 0c             	pushl  0xc(%ebp)
  80281d:	68 08 70 80 00       	push   $0x807008
  802822:	e8 28 ee ff ff       	call   80164f <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802827:	ba 00 00 00 00       	mov    $0x0,%edx
  80282c:	b8 04 00 00 00       	mov    $0x4,%eax
  802831:	e8 d6 fe ff ff       	call   80270c <fsipc>
  802836:	83 c4 10             	add    $0x10,%esp
  802839:	85 c0                	test   %eax,%eax
  80283b:	78 0b                	js     802848 <devfile_write+0x4a>
	assert(r <= n);
  80283d:	39 d8                	cmp    %ebx,%eax
  80283f:	77 0c                	ja     80284d <devfile_write+0x4f>
	assert(r <= PGSIZE);
  802841:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802846:	7f 1e                	jg     802866 <devfile_write+0x68>
}
  802848:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80284b:	c9                   	leave  
  80284c:	c3                   	ret    
	assert(r <= n);
  80284d:	68 e4 44 80 00       	push   $0x8044e4
  802852:	68 4f 3e 80 00       	push   $0x803e4f
  802857:	68 98 00 00 00       	push   $0x98
  80285c:	68 eb 44 80 00       	push   $0x8044eb
  802861:	e8 b4 e2 ff ff       	call   800b1a <_panic>
	assert(r <= PGSIZE);
  802866:	68 f6 44 80 00       	push   $0x8044f6
  80286b:	68 4f 3e 80 00       	push   $0x803e4f
  802870:	68 99 00 00 00       	push   $0x99
  802875:	68 eb 44 80 00       	push   $0x8044eb
  80287a:	e8 9b e2 ff ff       	call   800b1a <_panic>

0080287f <devfile_read>:
{
  80287f:	55                   	push   %ebp
  802880:	89 e5                	mov    %esp,%ebp
  802882:	56                   	push   %esi
  802883:	53                   	push   %ebx
  802884:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802887:	8b 45 08             	mov    0x8(%ebp),%eax
  80288a:	8b 40 0c             	mov    0xc(%eax),%eax
  80288d:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  802892:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802898:	ba 00 00 00 00       	mov    $0x0,%edx
  80289d:	b8 03 00 00 00       	mov    $0x3,%eax
  8028a2:	e8 65 fe ff ff       	call   80270c <fsipc>
  8028a7:	89 c3                	mov    %eax,%ebx
  8028a9:	85 c0                	test   %eax,%eax
  8028ab:	78 1f                	js     8028cc <devfile_read+0x4d>
	assert(r <= n);
  8028ad:	39 f0                	cmp    %esi,%eax
  8028af:	77 24                	ja     8028d5 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8028b1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8028b6:	7f 33                	jg     8028eb <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8028b8:	83 ec 04             	sub    $0x4,%esp
  8028bb:	50                   	push   %eax
  8028bc:	68 00 70 80 00       	push   $0x807000
  8028c1:	ff 75 0c             	pushl  0xc(%ebp)
  8028c4:	e8 24 ed ff ff       	call   8015ed <memmove>
	return r;
  8028c9:	83 c4 10             	add    $0x10,%esp
}
  8028cc:	89 d8                	mov    %ebx,%eax
  8028ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8028d1:	5b                   	pop    %ebx
  8028d2:	5e                   	pop    %esi
  8028d3:	5d                   	pop    %ebp
  8028d4:	c3                   	ret    
	assert(r <= n);
  8028d5:	68 e4 44 80 00       	push   $0x8044e4
  8028da:	68 4f 3e 80 00       	push   $0x803e4f
  8028df:	6a 7c                	push   $0x7c
  8028e1:	68 eb 44 80 00       	push   $0x8044eb
  8028e6:	e8 2f e2 ff ff       	call   800b1a <_panic>
	assert(r <= PGSIZE);
  8028eb:	68 f6 44 80 00       	push   $0x8044f6
  8028f0:	68 4f 3e 80 00       	push   $0x803e4f
  8028f5:	6a 7d                	push   $0x7d
  8028f7:	68 eb 44 80 00       	push   $0x8044eb
  8028fc:	e8 19 e2 ff ff       	call   800b1a <_panic>

00802901 <open>:
{
  802901:	55                   	push   %ebp
  802902:	89 e5                	mov    %esp,%ebp
  802904:	56                   	push   %esi
  802905:	53                   	push   %ebx
  802906:	83 ec 1c             	sub    $0x1c,%esp
  802909:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80290c:	56                   	push   %esi
  80290d:	e8 14 eb ff ff       	call   801426 <strlen>
  802912:	83 c4 10             	add    $0x10,%esp
  802915:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80291a:	7f 6c                	jg     802988 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80291c:	83 ec 0c             	sub    $0xc,%esp
  80291f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802922:	50                   	push   %eax
  802923:	e8 79 f8 ff ff       	call   8021a1 <fd_alloc>
  802928:	89 c3                	mov    %eax,%ebx
  80292a:	83 c4 10             	add    $0x10,%esp
  80292d:	85 c0                	test   %eax,%eax
  80292f:	78 3c                	js     80296d <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  802931:	83 ec 08             	sub    $0x8,%esp
  802934:	56                   	push   %esi
  802935:	68 00 70 80 00       	push   $0x807000
  80293a:	e8 20 eb ff ff       	call   80145f <strcpy>
	fsipcbuf.open.req_omode = mode;
  80293f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802942:	a3 00 74 80 00       	mov    %eax,0x807400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802947:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80294a:	b8 01 00 00 00       	mov    $0x1,%eax
  80294f:	e8 b8 fd ff ff       	call   80270c <fsipc>
  802954:	89 c3                	mov    %eax,%ebx
  802956:	83 c4 10             	add    $0x10,%esp
  802959:	85 c0                	test   %eax,%eax
  80295b:	78 19                	js     802976 <open+0x75>
	return fd2num(fd);
  80295d:	83 ec 0c             	sub    $0xc,%esp
  802960:	ff 75 f4             	pushl  -0xc(%ebp)
  802963:	e8 12 f8 ff ff       	call   80217a <fd2num>
  802968:	89 c3                	mov    %eax,%ebx
  80296a:	83 c4 10             	add    $0x10,%esp
}
  80296d:	89 d8                	mov    %ebx,%eax
  80296f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802972:	5b                   	pop    %ebx
  802973:	5e                   	pop    %esi
  802974:	5d                   	pop    %ebp
  802975:	c3                   	ret    
		fd_close(fd, 0);
  802976:	83 ec 08             	sub    $0x8,%esp
  802979:	6a 00                	push   $0x0
  80297b:	ff 75 f4             	pushl  -0xc(%ebp)
  80297e:	e8 1b f9 ff ff       	call   80229e <fd_close>
		return r;
  802983:	83 c4 10             	add    $0x10,%esp
  802986:	eb e5                	jmp    80296d <open+0x6c>
		return -E_BAD_PATH;
  802988:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80298d:	eb de                	jmp    80296d <open+0x6c>

0080298f <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80298f:	55                   	push   %ebp
  802990:	89 e5                	mov    %esp,%ebp
  802992:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802995:	ba 00 00 00 00       	mov    $0x0,%edx
  80299a:	b8 08 00 00 00       	mov    $0x8,%eax
  80299f:	e8 68 fd ff ff       	call   80270c <fsipc>
}
  8029a4:	c9                   	leave  
  8029a5:	c3                   	ret    

008029a6 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  8029a6:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8029aa:	7f 01                	jg     8029ad <writebuf+0x7>
  8029ac:	c3                   	ret    
{
  8029ad:	55                   	push   %ebp
  8029ae:	89 e5                	mov    %esp,%ebp
  8029b0:	53                   	push   %ebx
  8029b1:	83 ec 08             	sub    $0x8,%esp
  8029b4:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  8029b6:	ff 70 04             	pushl  0x4(%eax)
  8029b9:	8d 40 10             	lea    0x10(%eax),%eax
  8029bc:	50                   	push   %eax
  8029bd:	ff 33                	pushl  (%ebx)
  8029bf:	e8 6b fb ff ff       	call   80252f <write>
		if (result > 0)
  8029c4:	83 c4 10             	add    $0x10,%esp
  8029c7:	85 c0                	test   %eax,%eax
  8029c9:	7e 03                	jle    8029ce <writebuf+0x28>
			b->result += result;
  8029cb:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8029ce:	39 43 04             	cmp    %eax,0x4(%ebx)
  8029d1:	74 0d                	je     8029e0 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  8029d3:	85 c0                	test   %eax,%eax
  8029d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8029da:	0f 4f c2             	cmovg  %edx,%eax
  8029dd:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8029e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8029e3:	c9                   	leave  
  8029e4:	c3                   	ret    

008029e5 <putch>:

static void
putch(int ch, void *thunk)
{
  8029e5:	55                   	push   %ebp
  8029e6:	89 e5                	mov    %esp,%ebp
  8029e8:	53                   	push   %ebx
  8029e9:	83 ec 04             	sub    $0x4,%esp
  8029ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8029ef:	8b 53 04             	mov    0x4(%ebx),%edx
  8029f2:	8d 42 01             	lea    0x1(%edx),%eax
  8029f5:	89 43 04             	mov    %eax,0x4(%ebx)
  8029f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8029fb:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8029ff:	3d 00 01 00 00       	cmp    $0x100,%eax
  802a04:	74 06                	je     802a0c <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  802a06:	83 c4 04             	add    $0x4,%esp
  802a09:	5b                   	pop    %ebx
  802a0a:	5d                   	pop    %ebp
  802a0b:	c3                   	ret    
		writebuf(b);
  802a0c:	89 d8                	mov    %ebx,%eax
  802a0e:	e8 93 ff ff ff       	call   8029a6 <writebuf>
		b->idx = 0;
  802a13:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  802a1a:	eb ea                	jmp    802a06 <putch+0x21>

00802a1c <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802a1c:	55                   	push   %ebp
  802a1d:	89 e5                	mov    %esp,%ebp
  802a1f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  802a25:	8b 45 08             	mov    0x8(%ebp),%eax
  802a28:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  802a2e:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  802a35:	00 00 00 
	b.result = 0;
  802a38:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  802a3f:	00 00 00 
	b.error = 1;
  802a42:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  802a49:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802a4c:	ff 75 10             	pushl  0x10(%ebp)
  802a4f:	ff 75 0c             	pushl  0xc(%ebp)
  802a52:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  802a58:	50                   	push   %eax
  802a59:	68 e5 29 80 00       	push   $0x8029e5
  802a5e:	e8 da e2 ff ff       	call   800d3d <vprintfmt>
	if (b.idx > 0)
  802a63:	83 c4 10             	add    $0x10,%esp
  802a66:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  802a6d:	7f 11                	jg     802a80 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  802a6f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  802a75:	85 c0                	test   %eax,%eax
  802a77:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  802a7e:	c9                   	leave  
  802a7f:	c3                   	ret    
		writebuf(&b);
  802a80:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  802a86:	e8 1b ff ff ff       	call   8029a6 <writebuf>
  802a8b:	eb e2                	jmp    802a6f <vfprintf+0x53>

00802a8d <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802a8d:	55                   	push   %ebp
  802a8e:	89 e5                	mov    %esp,%ebp
  802a90:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802a93:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  802a96:	50                   	push   %eax
  802a97:	ff 75 0c             	pushl  0xc(%ebp)
  802a9a:	ff 75 08             	pushl  0x8(%ebp)
  802a9d:	e8 7a ff ff ff       	call   802a1c <vfprintf>
	va_end(ap);

	return cnt;
}
  802aa2:	c9                   	leave  
  802aa3:	c3                   	ret    

00802aa4 <printf>:

int
printf(const char *fmt, ...)
{
  802aa4:	55                   	push   %ebp
  802aa5:	89 e5                	mov    %esp,%ebp
  802aa7:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802aaa:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  802aad:	50                   	push   %eax
  802aae:	ff 75 08             	pushl  0x8(%ebp)
  802ab1:	6a 01                	push   $0x1
  802ab3:	e8 64 ff ff ff       	call   802a1c <vfprintf>
	va_end(ap);

	return cnt;
}
  802ab8:	c9                   	leave  
  802ab9:	c3                   	ret    

00802aba <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802aba:	55                   	push   %ebp
  802abb:	89 e5                	mov    %esp,%ebp
  802abd:	57                   	push   %edi
  802abe:	56                   	push   %esi
  802abf:	53                   	push   %ebx
  802ac0:	81 ec 94 02 00 00    	sub    $0x294,%esp
	cprintf("in %s\n", __FUNCTION__);
  802ac6:	68 d8 45 80 00       	push   $0x8045d8
  802acb:	68 71 3f 80 00       	push   $0x803f71
  802ad0:	e8 3b e1 ff ff       	call   800c10 <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802ad5:	83 c4 08             	add    $0x8,%esp
  802ad8:	6a 00                	push   $0x0
  802ada:	ff 75 08             	pushl  0x8(%ebp)
  802add:	e8 1f fe ff ff       	call   802901 <open>
  802ae2:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802ae8:	83 c4 10             	add    $0x10,%esp
  802aeb:	85 c0                	test   %eax,%eax
  802aed:	0f 88 0a 05 00 00    	js     802ffd <spawn+0x543>
  802af3:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802af5:	83 ec 04             	sub    $0x4,%esp
  802af8:	68 00 02 00 00       	push   $0x200
  802afd:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  802b03:	50                   	push   %eax
  802b04:	51                   	push   %ecx
  802b05:	e8 e0 f9 ff ff       	call   8024ea <readn>
  802b0a:	83 c4 10             	add    $0x10,%esp
  802b0d:	3d 00 02 00 00       	cmp    $0x200,%eax
  802b12:	75 74                	jne    802b88 <spawn+0xce>
	    || elf->e_magic != ELF_MAGIC) {
  802b14:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  802b1b:	45 4c 46 
  802b1e:	75 68                	jne    802b88 <spawn+0xce>
  802b20:	b8 07 00 00 00       	mov    $0x7,%eax
  802b25:	cd 30                	int    $0x30
  802b27:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  802b2d:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802b33:	85 c0                	test   %eax,%eax
  802b35:	0f 88 b6 04 00 00    	js     802ff1 <spawn+0x537>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802b3b:	25 ff 03 00 00       	and    $0x3ff,%eax
  802b40:	89 c6                	mov    %eax,%esi
  802b42:	c1 e6 07             	shl    $0x7,%esi
  802b45:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  802b4b:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  802b51:	b9 11 00 00 00       	mov    $0x11,%ecx
  802b56:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  802b58:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802b5e:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
	cprintf("in %s\n", __FUNCTION__);
  802b64:	83 ec 08             	sub    $0x8,%esp
  802b67:	68 cc 45 80 00       	push   $0x8045cc
  802b6c:	68 71 3f 80 00       	push   $0x803f71
  802b71:	e8 9a e0 ff ff       	call   800c10 <cprintf>
  802b76:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802b79:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  802b7e:	be 00 00 00 00       	mov    $0x0,%esi
  802b83:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802b86:	eb 4b                	jmp    802bd3 <spawn+0x119>
		close(fd);
  802b88:	83 ec 0c             	sub    $0xc,%esp
  802b8b:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802b91:	e8 8f f7 ff ff       	call   802325 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802b96:	83 c4 0c             	add    $0xc,%esp
  802b99:	68 7f 45 4c 46       	push   $0x464c457f
  802b9e:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  802ba4:	68 02 45 80 00       	push   $0x804502
  802ba9:	e8 62 e0 ff ff       	call   800c10 <cprintf>
		return -E_NOT_EXEC;
  802bae:	83 c4 10             	add    $0x10,%esp
  802bb1:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  802bb8:	ff ff ff 
  802bbb:	e9 3d 04 00 00       	jmp    802ffd <spawn+0x543>
		string_size += strlen(argv[argc]) + 1;
  802bc0:	83 ec 0c             	sub    $0xc,%esp
  802bc3:	50                   	push   %eax
  802bc4:	e8 5d e8 ff ff       	call   801426 <strlen>
  802bc9:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  802bcd:	83 c3 01             	add    $0x1,%ebx
  802bd0:	83 c4 10             	add    $0x10,%esp
  802bd3:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  802bda:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  802bdd:	85 c0                	test   %eax,%eax
  802bdf:	75 df                	jne    802bc0 <spawn+0x106>
  802be1:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  802be7:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  802bed:	bf 00 10 40 00       	mov    $0x401000,%edi
  802bf2:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802bf4:	89 fa                	mov    %edi,%edx
  802bf6:	83 e2 fc             	and    $0xfffffffc,%edx
  802bf9:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  802c00:	29 c2                	sub    %eax,%edx
  802c02:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802c08:	8d 42 f8             	lea    -0x8(%edx),%eax
  802c0b:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802c10:	0f 86 0a 04 00 00    	jbe    803020 <spawn+0x566>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802c16:	83 ec 04             	sub    $0x4,%esp
  802c19:	6a 07                	push   $0x7
  802c1b:	68 00 00 40 00       	push   $0x400000
  802c20:	6a 00                	push   $0x0
  802c22:	e8 2a ec ff ff       	call   801851 <sys_page_alloc>
  802c27:	83 c4 10             	add    $0x10,%esp
  802c2a:	85 c0                	test   %eax,%eax
  802c2c:	0f 88 f3 03 00 00    	js     803025 <spawn+0x56b>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802c32:	be 00 00 00 00       	mov    $0x0,%esi
  802c37:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  802c3d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802c40:	eb 30                	jmp    802c72 <spawn+0x1b8>
		argv_store[i] = UTEMP2USTACK(string_store);
  802c42:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802c48:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  802c4e:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  802c51:	83 ec 08             	sub    $0x8,%esp
  802c54:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802c57:	57                   	push   %edi
  802c58:	e8 02 e8 ff ff       	call   80145f <strcpy>
		string_store += strlen(argv[i]) + 1;
  802c5d:	83 c4 04             	add    $0x4,%esp
  802c60:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802c63:	e8 be e7 ff ff       	call   801426 <strlen>
  802c68:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  802c6c:	83 c6 01             	add    $0x1,%esi
  802c6f:	83 c4 10             	add    $0x10,%esp
  802c72:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  802c78:	7f c8                	jg     802c42 <spawn+0x188>
	}
	argv_store[argc] = 0;
  802c7a:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802c80:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  802c86:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  802c8d:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  802c93:	0f 85 86 00 00 00    	jne    802d1f <spawn+0x265>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802c99:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  802c9f:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  802ca5:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  802ca8:	89 d0                	mov    %edx,%eax
  802caa:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  802cb0:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802cb3:	2d 08 30 80 11       	sub    $0x11803008,%eax
  802cb8:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802cbe:	83 ec 0c             	sub    $0xc,%esp
  802cc1:	6a 07                	push   $0x7
  802cc3:	68 00 d0 bf ee       	push   $0xeebfd000
  802cc8:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802cce:	68 00 00 40 00       	push   $0x400000
  802cd3:	6a 00                	push   $0x0
  802cd5:	e8 ba eb ff ff       	call   801894 <sys_page_map>
  802cda:	89 c3                	mov    %eax,%ebx
  802cdc:	83 c4 20             	add    $0x20,%esp
  802cdf:	85 c0                	test   %eax,%eax
  802ce1:	0f 88 46 03 00 00    	js     80302d <spawn+0x573>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802ce7:	83 ec 08             	sub    $0x8,%esp
  802cea:	68 00 00 40 00       	push   $0x400000
  802cef:	6a 00                	push   $0x0
  802cf1:	e8 e0 eb ff ff       	call   8018d6 <sys_page_unmap>
  802cf6:	89 c3                	mov    %eax,%ebx
  802cf8:	83 c4 10             	add    $0x10,%esp
  802cfb:	85 c0                	test   %eax,%eax
  802cfd:	0f 88 2a 03 00 00    	js     80302d <spawn+0x573>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802d03:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  802d09:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802d10:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  802d17:	00 00 00 
  802d1a:	e9 4f 01 00 00       	jmp    802e6e <spawn+0x3b4>
	assert(string_store == (char*)UTEMP + PGSIZE);
  802d1f:	68 88 45 80 00       	push   $0x804588
  802d24:	68 4f 3e 80 00       	push   $0x803e4f
  802d29:	68 f8 00 00 00       	push   $0xf8
  802d2e:	68 1c 45 80 00       	push   $0x80451c
  802d33:	e8 e2 dd ff ff       	call   800b1a <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802d38:	83 ec 04             	sub    $0x4,%esp
  802d3b:	6a 07                	push   $0x7
  802d3d:	68 00 00 40 00       	push   $0x400000
  802d42:	6a 00                	push   $0x0
  802d44:	e8 08 eb ff ff       	call   801851 <sys_page_alloc>
  802d49:	83 c4 10             	add    $0x10,%esp
  802d4c:	85 c0                	test   %eax,%eax
  802d4e:	0f 88 b7 02 00 00    	js     80300b <spawn+0x551>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802d54:	83 ec 08             	sub    $0x8,%esp
  802d57:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802d5d:	01 f0                	add    %esi,%eax
  802d5f:	50                   	push   %eax
  802d60:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802d66:	e8 46 f8 ff ff       	call   8025b1 <seek>
  802d6b:	83 c4 10             	add    $0x10,%esp
  802d6e:	85 c0                	test   %eax,%eax
  802d70:	0f 88 9c 02 00 00    	js     803012 <spawn+0x558>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802d76:	83 ec 04             	sub    $0x4,%esp
  802d79:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802d7f:	29 f0                	sub    %esi,%eax
  802d81:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802d86:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802d8b:	0f 47 c1             	cmova  %ecx,%eax
  802d8e:	50                   	push   %eax
  802d8f:	68 00 00 40 00       	push   $0x400000
  802d94:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802d9a:	e8 4b f7 ff ff       	call   8024ea <readn>
  802d9f:	83 c4 10             	add    $0x10,%esp
  802da2:	85 c0                	test   %eax,%eax
  802da4:	0f 88 6f 02 00 00    	js     803019 <spawn+0x55f>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802daa:	83 ec 0c             	sub    $0xc,%esp
  802dad:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802db3:	53                   	push   %ebx
  802db4:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802dba:	68 00 00 40 00       	push   $0x400000
  802dbf:	6a 00                	push   $0x0
  802dc1:	e8 ce ea ff ff       	call   801894 <sys_page_map>
  802dc6:	83 c4 20             	add    $0x20,%esp
  802dc9:	85 c0                	test   %eax,%eax
  802dcb:	78 7c                	js     802e49 <spawn+0x38f>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  802dcd:	83 ec 08             	sub    $0x8,%esp
  802dd0:	68 00 00 40 00       	push   $0x400000
  802dd5:	6a 00                	push   $0x0
  802dd7:	e8 fa ea ff ff       	call   8018d6 <sys_page_unmap>
  802ddc:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  802ddf:	81 c7 00 10 00 00    	add    $0x1000,%edi
  802de5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802deb:	89 fe                	mov    %edi,%esi
  802ded:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  802df3:	76 69                	jbe    802e5e <spawn+0x3a4>
		if (i >= filesz) {
  802df5:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  802dfb:	0f 87 37 ff ff ff    	ja     802d38 <spawn+0x27e>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802e01:	83 ec 04             	sub    $0x4,%esp
  802e04:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802e0a:	53                   	push   %ebx
  802e0b:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802e11:	e8 3b ea ff ff       	call   801851 <sys_page_alloc>
  802e16:	83 c4 10             	add    $0x10,%esp
  802e19:	85 c0                	test   %eax,%eax
  802e1b:	79 c2                	jns    802ddf <spawn+0x325>
  802e1d:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  802e1f:	83 ec 0c             	sub    $0xc,%esp
  802e22:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802e28:	e8 a5 e9 ff ff       	call   8017d2 <sys_env_destroy>
	close(fd);
  802e2d:	83 c4 04             	add    $0x4,%esp
  802e30:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802e36:	e8 ea f4 ff ff       	call   802325 <close>
	return r;
  802e3b:	83 c4 10             	add    $0x10,%esp
  802e3e:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  802e44:	e9 b4 01 00 00       	jmp    802ffd <spawn+0x543>
				panic("spawn: sys_page_map data: %e", r);
  802e49:	50                   	push   %eax
  802e4a:	68 28 45 80 00       	push   $0x804528
  802e4f:	68 2b 01 00 00       	push   $0x12b
  802e54:	68 1c 45 80 00       	push   $0x80451c
  802e59:	e8 bc dc ff ff       	call   800b1a <_panic>
  802e5e:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802e64:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  802e6b:	83 c6 20             	add    $0x20,%esi
  802e6e:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802e75:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  802e7b:	7e 6d                	jle    802eea <spawn+0x430>
		if (ph->p_type != ELF_PROG_LOAD)
  802e7d:	83 3e 01             	cmpl   $0x1,(%esi)
  802e80:	75 e2                	jne    802e64 <spawn+0x3aa>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802e82:	8b 46 18             	mov    0x18(%esi),%eax
  802e85:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  802e88:	83 f8 01             	cmp    $0x1,%eax
  802e8b:	19 c0                	sbb    %eax,%eax
  802e8d:	83 e0 fe             	and    $0xfffffffe,%eax
  802e90:	83 c0 07             	add    $0x7,%eax
  802e93:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802e99:	8b 4e 04             	mov    0x4(%esi),%ecx
  802e9c:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  802ea2:	8b 56 10             	mov    0x10(%esi),%edx
  802ea5:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  802eab:	8b 7e 14             	mov    0x14(%esi),%edi
  802eae:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  802eb4:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  802eb7:	89 d8                	mov    %ebx,%eax
  802eb9:	25 ff 0f 00 00       	and    $0xfff,%eax
  802ebe:	74 1a                	je     802eda <spawn+0x420>
		va -= i;
  802ec0:	29 c3                	sub    %eax,%ebx
		memsz += i;
  802ec2:	01 c7                	add    %eax,%edi
  802ec4:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  802eca:	01 c2                	add    %eax,%edx
  802ecc:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  802ed2:	29 c1                	sub    %eax,%ecx
  802ed4:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  802eda:	bf 00 00 00 00       	mov    $0x0,%edi
  802edf:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  802ee5:	e9 01 ff ff ff       	jmp    802deb <spawn+0x331>
	close(fd);
  802eea:	83 ec 0c             	sub    $0xc,%esp
  802eed:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802ef3:	e8 2d f4 ff ff       	call   802325 <close>

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	cprintf("in %s\n", __FUNCTION__);
  802ef8:	83 c4 08             	add    $0x8,%esp
  802efb:	68 b8 45 80 00       	push   $0x8045b8
  802f00:	68 71 3f 80 00       	push   $0x803f71
  802f05:	e8 06 dd ff ff       	call   800c10 <cprintf>
  802f0a:	83 c4 10             	add    $0x10,%esp
	int r;
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  802f0d:	bb 00 00 80 00       	mov    $0x800000,%ebx
  802f12:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  802f18:	eb 0e                	jmp    802f28 <spawn+0x46e>
  802f1a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802f20:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  802f26:	74 5e                	je     802f86 <spawn+0x4cc>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_SHARE)) == (PTE_P | PTE_U | PTE_SHARE)))
  802f28:	89 d8                	mov    %ebx,%eax
  802f2a:	c1 e8 16             	shr    $0x16,%eax
  802f2d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802f34:	a8 01                	test   $0x1,%al
  802f36:	74 e2                	je     802f1a <spawn+0x460>
  802f38:	89 da                	mov    %ebx,%edx
  802f3a:	c1 ea 0c             	shr    $0xc,%edx
  802f3d:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  802f44:	25 05 04 00 00       	and    $0x405,%eax
  802f49:	3d 05 04 00 00       	cmp    $0x405,%eax
  802f4e:	75 ca                	jne    802f1a <spawn+0x460>
			if((r = sys_page_map((envid_t)0, (void *)i, child, (void *)i, uvpt[PGNUM(i)] & PTE_SYSCALL)) < 0)
  802f50:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  802f57:	83 ec 0c             	sub    $0xc,%esp
  802f5a:	25 07 0e 00 00       	and    $0xe07,%eax
  802f5f:	50                   	push   %eax
  802f60:	53                   	push   %ebx
  802f61:	56                   	push   %esi
  802f62:	53                   	push   %ebx
  802f63:	6a 00                	push   $0x0
  802f65:	e8 2a e9 ff ff       	call   801894 <sys_page_map>
  802f6a:	83 c4 20             	add    $0x20,%esp
  802f6d:	85 c0                	test   %eax,%eax
  802f6f:	79 a9                	jns    802f1a <spawn+0x460>
        		panic("sys_page_map: %e\n", r);
  802f71:	50                   	push   %eax
  802f72:	68 45 45 80 00       	push   $0x804545
  802f77:	68 3b 01 00 00       	push   $0x13b
  802f7c:	68 1c 45 80 00       	push   $0x80451c
  802f81:	e8 94 db ff ff       	call   800b1a <_panic>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802f86:	83 ec 08             	sub    $0x8,%esp
  802f89:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802f8f:	50                   	push   %eax
  802f90:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802f96:	e8 bf e9 ff ff       	call   80195a <sys_env_set_trapframe>
  802f9b:	83 c4 10             	add    $0x10,%esp
  802f9e:	85 c0                	test   %eax,%eax
  802fa0:	78 25                	js     802fc7 <spawn+0x50d>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802fa2:	83 ec 08             	sub    $0x8,%esp
  802fa5:	6a 02                	push   $0x2
  802fa7:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802fad:	e8 66 e9 ff ff       	call   801918 <sys_env_set_status>
  802fb2:	83 c4 10             	add    $0x10,%esp
  802fb5:	85 c0                	test   %eax,%eax
  802fb7:	78 23                	js     802fdc <spawn+0x522>
	return child;
  802fb9:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802fbf:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802fc5:	eb 36                	jmp    802ffd <spawn+0x543>
		panic("sys_env_set_trapframe: %e", r);
  802fc7:	50                   	push   %eax
  802fc8:	68 57 45 80 00       	push   $0x804557
  802fcd:	68 8a 00 00 00       	push   $0x8a
  802fd2:	68 1c 45 80 00       	push   $0x80451c
  802fd7:	e8 3e db ff ff       	call   800b1a <_panic>
		panic("sys_env_set_status: %e", r);
  802fdc:	50                   	push   %eax
  802fdd:	68 71 45 80 00       	push   $0x804571
  802fe2:	68 8d 00 00 00       	push   $0x8d
  802fe7:	68 1c 45 80 00       	push   $0x80451c
  802fec:	e8 29 db ff ff       	call   800b1a <_panic>
		return r;
  802ff1:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802ff7:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  802ffd:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  803003:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803006:	5b                   	pop    %ebx
  803007:	5e                   	pop    %esi
  803008:	5f                   	pop    %edi
  803009:	5d                   	pop    %ebp
  80300a:	c3                   	ret    
  80300b:	89 c7                	mov    %eax,%edi
  80300d:	e9 0d fe ff ff       	jmp    802e1f <spawn+0x365>
  803012:	89 c7                	mov    %eax,%edi
  803014:	e9 06 fe ff ff       	jmp    802e1f <spawn+0x365>
  803019:	89 c7                	mov    %eax,%edi
  80301b:	e9 ff fd ff ff       	jmp    802e1f <spawn+0x365>
		return -E_NO_MEM;
  803020:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  803025:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  80302b:	eb d0                	jmp    802ffd <spawn+0x543>
	sys_page_unmap(0, UTEMP);
  80302d:	83 ec 08             	sub    $0x8,%esp
  803030:	68 00 00 40 00       	push   $0x400000
  803035:	6a 00                	push   $0x0
  803037:	e8 9a e8 ff ff       	call   8018d6 <sys_page_unmap>
  80303c:	83 c4 10             	add    $0x10,%esp
  80303f:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  803045:	eb b6                	jmp    802ffd <spawn+0x543>

00803047 <spawnl>:
{
  803047:	55                   	push   %ebp
  803048:	89 e5                	mov    %esp,%ebp
  80304a:	57                   	push   %edi
  80304b:	56                   	push   %esi
  80304c:	53                   	push   %ebx
  80304d:	83 ec 14             	sub    $0x14,%esp
	cprintf("in %s\n", __FUNCTION__);
  803050:	68 b0 45 80 00       	push   $0x8045b0
  803055:	68 71 3f 80 00       	push   $0x803f71
  80305a:	e8 b1 db ff ff       	call   800c10 <cprintf>
	va_start(vl, arg0);
  80305f:	8d 55 10             	lea    0x10(%ebp),%edx
	while(va_arg(vl, void *) != NULL)
  803062:	83 c4 10             	add    $0x10,%esp
	int argc=0;
  803065:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  80306a:	8d 4a 04             	lea    0x4(%edx),%ecx
  80306d:	83 3a 00             	cmpl   $0x0,(%edx)
  803070:	74 07                	je     803079 <spawnl+0x32>
		argc++;
  803072:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  803075:	89 ca                	mov    %ecx,%edx
  803077:	eb f1                	jmp    80306a <spawnl+0x23>
	const char *argv[argc+2];
  803079:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  803080:	83 e2 f0             	and    $0xfffffff0,%edx
  803083:	29 d4                	sub    %edx,%esp
  803085:	8d 54 24 03          	lea    0x3(%esp),%edx
  803089:	c1 ea 02             	shr    $0x2,%edx
  80308c:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  803093:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  803095:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803098:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  80309f:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  8030a6:	00 
	va_start(vl, arg0);
  8030a7:	8d 4d 10             	lea    0x10(%ebp),%ecx
  8030aa:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  8030ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8030b1:	eb 0b                	jmp    8030be <spawnl+0x77>
		argv[i+1] = va_arg(vl, const char *);
  8030b3:	83 c0 01             	add    $0x1,%eax
  8030b6:	8b 39                	mov    (%ecx),%edi
  8030b8:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  8030bb:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  8030be:	39 d0                	cmp    %edx,%eax
  8030c0:	75 f1                	jne    8030b3 <spawnl+0x6c>
	return spawn(prog, argv);
  8030c2:	83 ec 08             	sub    $0x8,%esp
  8030c5:	56                   	push   %esi
  8030c6:	ff 75 08             	pushl  0x8(%ebp)
  8030c9:	e8 ec f9 ff ff       	call   802aba <spawn>
}
  8030ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8030d1:	5b                   	pop    %ebx
  8030d2:	5e                   	pop    %esi
  8030d3:	5f                   	pop    %edi
  8030d4:	5d                   	pop    %ebp
  8030d5:	c3                   	ret    

008030d6 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8030d6:	55                   	push   %ebp
  8030d7:	89 e5                	mov    %esp,%ebp
  8030d9:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8030dc:	68 de 45 80 00       	push   $0x8045de
  8030e1:	ff 75 0c             	pushl  0xc(%ebp)
  8030e4:	e8 76 e3 ff ff       	call   80145f <strcpy>
	return 0;
}
  8030e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8030ee:	c9                   	leave  
  8030ef:	c3                   	ret    

008030f0 <devsock_close>:
{
  8030f0:	55                   	push   %ebp
  8030f1:	89 e5                	mov    %esp,%ebp
  8030f3:	53                   	push   %ebx
  8030f4:	83 ec 10             	sub    $0x10,%esp
  8030f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8030fa:	53                   	push   %ebx
  8030fb:	e8 6b 09 00 00       	call   803a6b <pageref>
  803100:	83 c4 10             	add    $0x10,%esp
		return 0;
  803103:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  803108:	83 f8 01             	cmp    $0x1,%eax
  80310b:	74 07                	je     803114 <devsock_close+0x24>
}
  80310d:	89 d0                	mov    %edx,%eax
  80310f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803112:	c9                   	leave  
  803113:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  803114:	83 ec 0c             	sub    $0xc,%esp
  803117:	ff 73 0c             	pushl  0xc(%ebx)
  80311a:	e8 b9 02 00 00       	call   8033d8 <nsipc_close>
  80311f:	89 c2                	mov    %eax,%edx
  803121:	83 c4 10             	add    $0x10,%esp
  803124:	eb e7                	jmp    80310d <devsock_close+0x1d>

00803126 <devsock_write>:
{
  803126:	55                   	push   %ebp
  803127:	89 e5                	mov    %esp,%ebp
  803129:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80312c:	6a 00                	push   $0x0
  80312e:	ff 75 10             	pushl  0x10(%ebp)
  803131:	ff 75 0c             	pushl  0xc(%ebp)
  803134:	8b 45 08             	mov    0x8(%ebp),%eax
  803137:	ff 70 0c             	pushl  0xc(%eax)
  80313a:	e8 76 03 00 00       	call   8034b5 <nsipc_send>
}
  80313f:	c9                   	leave  
  803140:	c3                   	ret    

00803141 <devsock_read>:
{
  803141:	55                   	push   %ebp
  803142:	89 e5                	mov    %esp,%ebp
  803144:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803147:	6a 00                	push   $0x0
  803149:	ff 75 10             	pushl  0x10(%ebp)
  80314c:	ff 75 0c             	pushl  0xc(%ebp)
  80314f:	8b 45 08             	mov    0x8(%ebp),%eax
  803152:	ff 70 0c             	pushl  0xc(%eax)
  803155:	e8 ef 02 00 00       	call   803449 <nsipc_recv>
}
  80315a:	c9                   	leave  
  80315b:	c3                   	ret    

0080315c <fd2sockid>:
{
  80315c:	55                   	push   %ebp
  80315d:	89 e5                	mov    %esp,%ebp
  80315f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  803162:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803165:	52                   	push   %edx
  803166:	50                   	push   %eax
  803167:	e8 87 f0 ff ff       	call   8021f3 <fd_lookup>
  80316c:	83 c4 10             	add    $0x10,%esp
  80316f:	85 c0                	test   %eax,%eax
  803171:	78 10                	js     803183 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  803173:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803176:	8b 0d 3c 50 80 00    	mov    0x80503c,%ecx
  80317c:	39 08                	cmp    %ecx,(%eax)
  80317e:	75 05                	jne    803185 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  803180:	8b 40 0c             	mov    0xc(%eax),%eax
}
  803183:	c9                   	leave  
  803184:	c3                   	ret    
		return -E_NOT_SUPP;
  803185:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80318a:	eb f7                	jmp    803183 <fd2sockid+0x27>

0080318c <alloc_sockfd>:
{
  80318c:	55                   	push   %ebp
  80318d:	89 e5                	mov    %esp,%ebp
  80318f:	56                   	push   %esi
  803190:	53                   	push   %ebx
  803191:	83 ec 1c             	sub    $0x1c,%esp
  803194:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  803196:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803199:	50                   	push   %eax
  80319a:	e8 02 f0 ff ff       	call   8021a1 <fd_alloc>
  80319f:	89 c3                	mov    %eax,%ebx
  8031a1:	83 c4 10             	add    $0x10,%esp
  8031a4:	85 c0                	test   %eax,%eax
  8031a6:	78 43                	js     8031eb <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8031a8:	83 ec 04             	sub    $0x4,%esp
  8031ab:	68 07 04 00 00       	push   $0x407
  8031b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8031b3:	6a 00                	push   $0x0
  8031b5:	e8 97 e6 ff ff       	call   801851 <sys_page_alloc>
  8031ba:	89 c3                	mov    %eax,%ebx
  8031bc:	83 c4 10             	add    $0x10,%esp
  8031bf:	85 c0                	test   %eax,%eax
  8031c1:	78 28                	js     8031eb <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8031c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c6:	8b 15 3c 50 80 00    	mov    0x80503c,%edx
  8031cc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8031ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8031d8:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8031db:	83 ec 0c             	sub    $0xc,%esp
  8031de:	50                   	push   %eax
  8031df:	e8 96 ef ff ff       	call   80217a <fd2num>
  8031e4:	89 c3                	mov    %eax,%ebx
  8031e6:	83 c4 10             	add    $0x10,%esp
  8031e9:	eb 0c                	jmp    8031f7 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8031eb:	83 ec 0c             	sub    $0xc,%esp
  8031ee:	56                   	push   %esi
  8031ef:	e8 e4 01 00 00       	call   8033d8 <nsipc_close>
		return r;
  8031f4:	83 c4 10             	add    $0x10,%esp
}
  8031f7:	89 d8                	mov    %ebx,%eax
  8031f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8031fc:	5b                   	pop    %ebx
  8031fd:	5e                   	pop    %esi
  8031fe:	5d                   	pop    %ebp
  8031ff:	c3                   	ret    

00803200 <accept>:
{
  803200:	55                   	push   %ebp
  803201:	89 e5                	mov    %esp,%ebp
  803203:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  803206:	8b 45 08             	mov    0x8(%ebp),%eax
  803209:	e8 4e ff ff ff       	call   80315c <fd2sockid>
  80320e:	85 c0                	test   %eax,%eax
  803210:	78 1b                	js     80322d <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803212:	83 ec 04             	sub    $0x4,%esp
  803215:	ff 75 10             	pushl  0x10(%ebp)
  803218:	ff 75 0c             	pushl  0xc(%ebp)
  80321b:	50                   	push   %eax
  80321c:	e8 0e 01 00 00       	call   80332f <nsipc_accept>
  803221:	83 c4 10             	add    $0x10,%esp
  803224:	85 c0                	test   %eax,%eax
  803226:	78 05                	js     80322d <accept+0x2d>
	return alloc_sockfd(r);
  803228:	e8 5f ff ff ff       	call   80318c <alloc_sockfd>
}
  80322d:	c9                   	leave  
  80322e:	c3                   	ret    

0080322f <bind>:
{
  80322f:	55                   	push   %ebp
  803230:	89 e5                	mov    %esp,%ebp
  803232:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  803235:	8b 45 08             	mov    0x8(%ebp),%eax
  803238:	e8 1f ff ff ff       	call   80315c <fd2sockid>
  80323d:	85 c0                	test   %eax,%eax
  80323f:	78 12                	js     803253 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  803241:	83 ec 04             	sub    $0x4,%esp
  803244:	ff 75 10             	pushl  0x10(%ebp)
  803247:	ff 75 0c             	pushl  0xc(%ebp)
  80324a:	50                   	push   %eax
  80324b:	e8 31 01 00 00       	call   803381 <nsipc_bind>
  803250:	83 c4 10             	add    $0x10,%esp
}
  803253:	c9                   	leave  
  803254:	c3                   	ret    

00803255 <shutdown>:
{
  803255:	55                   	push   %ebp
  803256:	89 e5                	mov    %esp,%ebp
  803258:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80325b:	8b 45 08             	mov    0x8(%ebp),%eax
  80325e:	e8 f9 fe ff ff       	call   80315c <fd2sockid>
  803263:	85 c0                	test   %eax,%eax
  803265:	78 0f                	js     803276 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  803267:	83 ec 08             	sub    $0x8,%esp
  80326a:	ff 75 0c             	pushl  0xc(%ebp)
  80326d:	50                   	push   %eax
  80326e:	e8 43 01 00 00       	call   8033b6 <nsipc_shutdown>
  803273:	83 c4 10             	add    $0x10,%esp
}
  803276:	c9                   	leave  
  803277:	c3                   	ret    

00803278 <connect>:
{
  803278:	55                   	push   %ebp
  803279:	89 e5                	mov    %esp,%ebp
  80327b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80327e:	8b 45 08             	mov    0x8(%ebp),%eax
  803281:	e8 d6 fe ff ff       	call   80315c <fd2sockid>
  803286:	85 c0                	test   %eax,%eax
  803288:	78 12                	js     80329c <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80328a:	83 ec 04             	sub    $0x4,%esp
  80328d:	ff 75 10             	pushl  0x10(%ebp)
  803290:	ff 75 0c             	pushl  0xc(%ebp)
  803293:	50                   	push   %eax
  803294:	e8 59 01 00 00       	call   8033f2 <nsipc_connect>
  803299:	83 c4 10             	add    $0x10,%esp
}
  80329c:	c9                   	leave  
  80329d:	c3                   	ret    

0080329e <listen>:
{
  80329e:	55                   	push   %ebp
  80329f:	89 e5                	mov    %esp,%ebp
  8032a1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8032a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a7:	e8 b0 fe ff ff       	call   80315c <fd2sockid>
  8032ac:	85 c0                	test   %eax,%eax
  8032ae:	78 0f                	js     8032bf <listen+0x21>
	return nsipc_listen(r, backlog);
  8032b0:	83 ec 08             	sub    $0x8,%esp
  8032b3:	ff 75 0c             	pushl  0xc(%ebp)
  8032b6:	50                   	push   %eax
  8032b7:	e8 6b 01 00 00       	call   803427 <nsipc_listen>
  8032bc:	83 c4 10             	add    $0x10,%esp
}
  8032bf:	c9                   	leave  
  8032c0:	c3                   	ret    

008032c1 <socket>:

int
socket(int domain, int type, int protocol)
{
  8032c1:	55                   	push   %ebp
  8032c2:	89 e5                	mov    %esp,%ebp
  8032c4:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8032c7:	ff 75 10             	pushl  0x10(%ebp)
  8032ca:	ff 75 0c             	pushl  0xc(%ebp)
  8032cd:	ff 75 08             	pushl  0x8(%ebp)
  8032d0:	e8 3e 02 00 00       	call   803513 <nsipc_socket>
  8032d5:	83 c4 10             	add    $0x10,%esp
  8032d8:	85 c0                	test   %eax,%eax
  8032da:	78 05                	js     8032e1 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8032dc:	e8 ab fe ff ff       	call   80318c <alloc_sockfd>
}
  8032e1:	c9                   	leave  
  8032e2:	c3                   	ret    

008032e3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8032e3:	55                   	push   %ebp
  8032e4:	89 e5                	mov    %esp,%ebp
  8032e6:	53                   	push   %ebx
  8032e7:	83 ec 04             	sub    $0x4,%esp
  8032ea:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8032ec:	83 3d 24 64 80 00 00 	cmpl   $0x0,0x806424
  8032f3:	74 26                	je     80331b <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8032f5:	6a 07                	push   $0x7
  8032f7:	68 00 80 80 00       	push   $0x808000
  8032fc:	53                   	push   %ebx
  8032fd:	ff 35 24 64 80 00    	pushl  0x806424
  803303:	e8 d0 06 00 00       	call   8039d8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  803308:	83 c4 0c             	add    $0xc,%esp
  80330b:	6a 00                	push   $0x0
  80330d:	6a 00                	push   $0x0
  80330f:	6a 00                	push   $0x0
  803311:	e8 59 06 00 00       	call   80396f <ipc_recv>
}
  803316:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803319:	c9                   	leave  
  80331a:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80331b:	83 ec 0c             	sub    $0xc,%esp
  80331e:	6a 02                	push   $0x2
  803320:	e8 0b 07 00 00       	call   803a30 <ipc_find_env>
  803325:	a3 24 64 80 00       	mov    %eax,0x806424
  80332a:	83 c4 10             	add    $0x10,%esp
  80332d:	eb c6                	jmp    8032f5 <nsipc+0x12>

0080332f <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80332f:	55                   	push   %ebp
  803330:	89 e5                	mov    %esp,%ebp
  803332:	56                   	push   %esi
  803333:	53                   	push   %ebx
  803334:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  803337:	8b 45 08             	mov    0x8(%ebp),%eax
  80333a:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80333f:	8b 06                	mov    (%esi),%eax
  803341:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803346:	b8 01 00 00 00       	mov    $0x1,%eax
  80334b:	e8 93 ff ff ff       	call   8032e3 <nsipc>
  803350:	89 c3                	mov    %eax,%ebx
  803352:	85 c0                	test   %eax,%eax
  803354:	79 09                	jns    80335f <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  803356:	89 d8                	mov    %ebx,%eax
  803358:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80335b:	5b                   	pop    %ebx
  80335c:	5e                   	pop    %esi
  80335d:	5d                   	pop    %ebp
  80335e:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80335f:	83 ec 04             	sub    $0x4,%esp
  803362:	ff 35 10 80 80 00    	pushl  0x808010
  803368:	68 00 80 80 00       	push   $0x808000
  80336d:	ff 75 0c             	pushl  0xc(%ebp)
  803370:	e8 78 e2 ff ff       	call   8015ed <memmove>
		*addrlen = ret->ret_addrlen;
  803375:	a1 10 80 80 00       	mov    0x808010,%eax
  80337a:	89 06                	mov    %eax,(%esi)
  80337c:	83 c4 10             	add    $0x10,%esp
	return r;
  80337f:	eb d5                	jmp    803356 <nsipc_accept+0x27>

00803381 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803381:	55                   	push   %ebp
  803382:	89 e5                	mov    %esp,%ebp
  803384:	53                   	push   %ebx
  803385:	83 ec 08             	sub    $0x8,%esp
  803388:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80338b:	8b 45 08             	mov    0x8(%ebp),%eax
  80338e:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803393:	53                   	push   %ebx
  803394:	ff 75 0c             	pushl  0xc(%ebp)
  803397:	68 04 80 80 00       	push   $0x808004
  80339c:	e8 4c e2 ff ff       	call   8015ed <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8033a1:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  8033a7:	b8 02 00 00 00       	mov    $0x2,%eax
  8033ac:	e8 32 ff ff ff       	call   8032e3 <nsipc>
}
  8033b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8033b4:	c9                   	leave  
  8033b5:	c3                   	ret    

008033b6 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8033b6:	55                   	push   %ebp
  8033b7:	89 e5                	mov    %esp,%ebp
  8033b9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8033bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bf:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  8033c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033c7:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  8033cc:	b8 03 00 00 00       	mov    $0x3,%eax
  8033d1:	e8 0d ff ff ff       	call   8032e3 <nsipc>
}
  8033d6:	c9                   	leave  
  8033d7:	c3                   	ret    

008033d8 <nsipc_close>:

int
nsipc_close(int s)
{
  8033d8:	55                   	push   %ebp
  8033d9:	89 e5                	mov    %esp,%ebp
  8033db:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8033de:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e1:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  8033e6:	b8 04 00 00 00       	mov    $0x4,%eax
  8033eb:	e8 f3 fe ff ff       	call   8032e3 <nsipc>
}
  8033f0:	c9                   	leave  
  8033f1:	c3                   	ret    

008033f2 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8033f2:	55                   	push   %ebp
  8033f3:	89 e5                	mov    %esp,%ebp
  8033f5:	53                   	push   %ebx
  8033f6:	83 ec 08             	sub    $0x8,%esp
  8033f9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8033fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ff:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803404:	53                   	push   %ebx
  803405:	ff 75 0c             	pushl  0xc(%ebp)
  803408:	68 04 80 80 00       	push   $0x808004
  80340d:	e8 db e1 ff ff       	call   8015ed <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  803412:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  803418:	b8 05 00 00 00       	mov    $0x5,%eax
  80341d:	e8 c1 fe ff ff       	call   8032e3 <nsipc>
}
  803422:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803425:	c9                   	leave  
  803426:	c3                   	ret    

00803427 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803427:	55                   	push   %ebp
  803428:	89 e5                	mov    %esp,%ebp
  80342a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80342d:	8b 45 08             	mov    0x8(%ebp),%eax
  803430:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  803435:	8b 45 0c             	mov    0xc(%ebp),%eax
  803438:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  80343d:	b8 06 00 00 00       	mov    $0x6,%eax
  803442:	e8 9c fe ff ff       	call   8032e3 <nsipc>
}
  803447:	c9                   	leave  
  803448:	c3                   	ret    

00803449 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803449:	55                   	push   %ebp
  80344a:	89 e5                	mov    %esp,%ebp
  80344c:	56                   	push   %esi
  80344d:	53                   	push   %ebx
  80344e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  803451:	8b 45 08             	mov    0x8(%ebp),%eax
  803454:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  803459:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  80345f:	8b 45 14             	mov    0x14(%ebp),%eax
  803462:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803467:	b8 07 00 00 00       	mov    $0x7,%eax
  80346c:	e8 72 fe ff ff       	call   8032e3 <nsipc>
  803471:	89 c3                	mov    %eax,%ebx
  803473:	85 c0                	test   %eax,%eax
  803475:	78 1f                	js     803496 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  803477:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80347c:	7f 21                	jg     80349f <nsipc_recv+0x56>
  80347e:	39 c6                	cmp    %eax,%esi
  803480:	7c 1d                	jl     80349f <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803482:	83 ec 04             	sub    $0x4,%esp
  803485:	50                   	push   %eax
  803486:	68 00 80 80 00       	push   $0x808000
  80348b:	ff 75 0c             	pushl  0xc(%ebp)
  80348e:	e8 5a e1 ff ff       	call   8015ed <memmove>
  803493:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  803496:	89 d8                	mov    %ebx,%eax
  803498:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80349b:	5b                   	pop    %ebx
  80349c:	5e                   	pop    %esi
  80349d:	5d                   	pop    %ebp
  80349e:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80349f:	68 ea 45 80 00       	push   $0x8045ea
  8034a4:	68 4f 3e 80 00       	push   $0x803e4f
  8034a9:	6a 62                	push   $0x62
  8034ab:	68 ff 45 80 00       	push   $0x8045ff
  8034b0:	e8 65 d6 ff ff       	call   800b1a <_panic>

008034b5 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8034b5:	55                   	push   %ebp
  8034b6:	89 e5                	mov    %esp,%ebp
  8034b8:	53                   	push   %ebx
  8034b9:	83 ec 04             	sub    $0x4,%esp
  8034bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8034bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c2:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  8034c7:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8034cd:	7f 2e                	jg     8034fd <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8034cf:	83 ec 04             	sub    $0x4,%esp
  8034d2:	53                   	push   %ebx
  8034d3:	ff 75 0c             	pushl  0xc(%ebp)
  8034d6:	68 0c 80 80 00       	push   $0x80800c
  8034db:	e8 0d e1 ff ff       	call   8015ed <memmove>
	nsipcbuf.send.req_size = size;
  8034e0:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  8034e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8034e9:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  8034ee:	b8 08 00 00 00       	mov    $0x8,%eax
  8034f3:	e8 eb fd ff ff       	call   8032e3 <nsipc>
}
  8034f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8034fb:	c9                   	leave  
  8034fc:	c3                   	ret    
	assert(size < 1600);
  8034fd:	68 0b 46 80 00       	push   $0x80460b
  803502:	68 4f 3e 80 00       	push   $0x803e4f
  803507:	6a 6d                	push   $0x6d
  803509:	68 ff 45 80 00       	push   $0x8045ff
  80350e:	e8 07 d6 ff ff       	call   800b1a <_panic>

00803513 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803513:	55                   	push   %ebp
  803514:	89 e5                	mov    %esp,%ebp
  803516:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  803519:	8b 45 08             	mov    0x8(%ebp),%eax
  80351c:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  803521:	8b 45 0c             	mov    0xc(%ebp),%eax
  803524:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  803529:	8b 45 10             	mov    0x10(%ebp),%eax
  80352c:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  803531:	b8 09 00 00 00       	mov    $0x9,%eax
  803536:	e8 a8 fd ff ff       	call   8032e3 <nsipc>
}
  80353b:	c9                   	leave  
  80353c:	c3                   	ret    

0080353d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80353d:	55                   	push   %ebp
  80353e:	89 e5                	mov    %esp,%ebp
  803540:	56                   	push   %esi
  803541:	53                   	push   %ebx
  803542:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803545:	83 ec 0c             	sub    $0xc,%esp
  803548:	ff 75 08             	pushl  0x8(%ebp)
  80354b:	e8 3a ec ff ff       	call   80218a <fd2data>
  803550:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  803552:	83 c4 08             	add    $0x8,%esp
  803555:	68 17 46 80 00       	push   $0x804617
  80355a:	53                   	push   %ebx
  80355b:	e8 ff de ff ff       	call   80145f <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  803560:	8b 46 04             	mov    0x4(%esi),%eax
  803563:	2b 06                	sub    (%esi),%eax
  803565:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80356b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  803572:	00 00 00 
	stat->st_dev = &devpipe;
  803575:	c7 83 88 00 00 00 58 	movl   $0x805058,0x88(%ebx)
  80357c:	50 80 00 
	return 0;
}
  80357f:	b8 00 00 00 00       	mov    $0x0,%eax
  803584:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803587:	5b                   	pop    %ebx
  803588:	5e                   	pop    %esi
  803589:	5d                   	pop    %ebp
  80358a:	c3                   	ret    

0080358b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80358b:	55                   	push   %ebp
  80358c:	89 e5                	mov    %esp,%ebp
  80358e:	53                   	push   %ebx
  80358f:	83 ec 0c             	sub    $0xc,%esp
  803592:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  803595:	53                   	push   %ebx
  803596:	6a 00                	push   $0x0
  803598:	e8 39 e3 ff ff       	call   8018d6 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80359d:	89 1c 24             	mov    %ebx,(%esp)
  8035a0:	e8 e5 eb ff ff       	call   80218a <fd2data>
  8035a5:	83 c4 08             	add    $0x8,%esp
  8035a8:	50                   	push   %eax
  8035a9:	6a 00                	push   $0x0
  8035ab:	e8 26 e3 ff ff       	call   8018d6 <sys_page_unmap>
}
  8035b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8035b3:	c9                   	leave  
  8035b4:	c3                   	ret    

008035b5 <_pipeisclosed>:
{
  8035b5:	55                   	push   %ebp
  8035b6:	89 e5                	mov    %esp,%ebp
  8035b8:	57                   	push   %edi
  8035b9:	56                   	push   %esi
  8035ba:	53                   	push   %ebx
  8035bb:	83 ec 1c             	sub    $0x1c,%esp
  8035be:	89 c7                	mov    %eax,%edi
  8035c0:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8035c2:	a1 28 64 80 00       	mov    0x806428,%eax
  8035c7:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8035ca:	83 ec 0c             	sub    $0xc,%esp
  8035cd:	57                   	push   %edi
  8035ce:	e8 98 04 00 00       	call   803a6b <pageref>
  8035d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8035d6:	89 34 24             	mov    %esi,(%esp)
  8035d9:	e8 8d 04 00 00       	call   803a6b <pageref>
		nn = thisenv->env_runs;
  8035de:	8b 15 28 64 80 00    	mov    0x806428,%edx
  8035e4:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8035e7:	83 c4 10             	add    $0x10,%esp
  8035ea:	39 cb                	cmp    %ecx,%ebx
  8035ec:	74 1b                	je     803609 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8035ee:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8035f1:	75 cf                	jne    8035c2 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8035f3:	8b 42 58             	mov    0x58(%edx),%eax
  8035f6:	6a 01                	push   $0x1
  8035f8:	50                   	push   %eax
  8035f9:	53                   	push   %ebx
  8035fa:	68 1e 46 80 00       	push   $0x80461e
  8035ff:	e8 0c d6 ff ff       	call   800c10 <cprintf>
  803604:	83 c4 10             	add    $0x10,%esp
  803607:	eb b9                	jmp    8035c2 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  803609:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80360c:	0f 94 c0             	sete   %al
  80360f:	0f b6 c0             	movzbl %al,%eax
}
  803612:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803615:	5b                   	pop    %ebx
  803616:	5e                   	pop    %esi
  803617:	5f                   	pop    %edi
  803618:	5d                   	pop    %ebp
  803619:	c3                   	ret    

0080361a <devpipe_write>:
{
  80361a:	55                   	push   %ebp
  80361b:	89 e5                	mov    %esp,%ebp
  80361d:	57                   	push   %edi
  80361e:	56                   	push   %esi
  80361f:	53                   	push   %ebx
  803620:	83 ec 28             	sub    $0x28,%esp
  803623:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  803626:	56                   	push   %esi
  803627:	e8 5e eb ff ff       	call   80218a <fd2data>
  80362c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80362e:	83 c4 10             	add    $0x10,%esp
  803631:	bf 00 00 00 00       	mov    $0x0,%edi
  803636:	3b 7d 10             	cmp    0x10(%ebp),%edi
  803639:	74 4f                	je     80368a <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80363b:	8b 43 04             	mov    0x4(%ebx),%eax
  80363e:	8b 0b                	mov    (%ebx),%ecx
  803640:	8d 51 20             	lea    0x20(%ecx),%edx
  803643:	39 d0                	cmp    %edx,%eax
  803645:	72 14                	jb     80365b <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  803647:	89 da                	mov    %ebx,%edx
  803649:	89 f0                	mov    %esi,%eax
  80364b:	e8 65 ff ff ff       	call   8035b5 <_pipeisclosed>
  803650:	85 c0                	test   %eax,%eax
  803652:	75 3b                	jne    80368f <devpipe_write+0x75>
			sys_yield();
  803654:	e8 d9 e1 ff ff       	call   801832 <sys_yield>
  803659:	eb e0                	jmp    80363b <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80365b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80365e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  803662:	88 4d e7             	mov    %cl,-0x19(%ebp)
  803665:	89 c2                	mov    %eax,%edx
  803667:	c1 fa 1f             	sar    $0x1f,%edx
  80366a:	89 d1                	mov    %edx,%ecx
  80366c:	c1 e9 1b             	shr    $0x1b,%ecx
  80366f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  803672:	83 e2 1f             	and    $0x1f,%edx
  803675:	29 ca                	sub    %ecx,%edx
  803677:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80367b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80367f:	83 c0 01             	add    $0x1,%eax
  803682:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  803685:	83 c7 01             	add    $0x1,%edi
  803688:	eb ac                	jmp    803636 <devpipe_write+0x1c>
	return i;
  80368a:	8b 45 10             	mov    0x10(%ebp),%eax
  80368d:	eb 05                	jmp    803694 <devpipe_write+0x7a>
				return 0;
  80368f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803694:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803697:	5b                   	pop    %ebx
  803698:	5e                   	pop    %esi
  803699:	5f                   	pop    %edi
  80369a:	5d                   	pop    %ebp
  80369b:	c3                   	ret    

0080369c <devpipe_read>:
{
  80369c:	55                   	push   %ebp
  80369d:	89 e5                	mov    %esp,%ebp
  80369f:	57                   	push   %edi
  8036a0:	56                   	push   %esi
  8036a1:	53                   	push   %ebx
  8036a2:	83 ec 18             	sub    $0x18,%esp
  8036a5:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8036a8:	57                   	push   %edi
  8036a9:	e8 dc ea ff ff       	call   80218a <fd2data>
  8036ae:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8036b0:	83 c4 10             	add    $0x10,%esp
  8036b3:	be 00 00 00 00       	mov    $0x0,%esi
  8036b8:	3b 75 10             	cmp    0x10(%ebp),%esi
  8036bb:	75 14                	jne    8036d1 <devpipe_read+0x35>
	return i;
  8036bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8036c0:	eb 02                	jmp    8036c4 <devpipe_read+0x28>
				return i;
  8036c2:	89 f0                	mov    %esi,%eax
}
  8036c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8036c7:	5b                   	pop    %ebx
  8036c8:	5e                   	pop    %esi
  8036c9:	5f                   	pop    %edi
  8036ca:	5d                   	pop    %ebp
  8036cb:	c3                   	ret    
			sys_yield();
  8036cc:	e8 61 e1 ff ff       	call   801832 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8036d1:	8b 03                	mov    (%ebx),%eax
  8036d3:	3b 43 04             	cmp    0x4(%ebx),%eax
  8036d6:	75 18                	jne    8036f0 <devpipe_read+0x54>
			if (i > 0)
  8036d8:	85 f6                	test   %esi,%esi
  8036da:	75 e6                	jne    8036c2 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8036dc:	89 da                	mov    %ebx,%edx
  8036de:	89 f8                	mov    %edi,%eax
  8036e0:	e8 d0 fe ff ff       	call   8035b5 <_pipeisclosed>
  8036e5:	85 c0                	test   %eax,%eax
  8036e7:	74 e3                	je     8036cc <devpipe_read+0x30>
				return 0;
  8036e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8036ee:	eb d4                	jmp    8036c4 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8036f0:	99                   	cltd   
  8036f1:	c1 ea 1b             	shr    $0x1b,%edx
  8036f4:	01 d0                	add    %edx,%eax
  8036f6:	83 e0 1f             	and    $0x1f,%eax
  8036f9:	29 d0                	sub    %edx,%eax
  8036fb:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803700:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803703:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  803706:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  803709:	83 c6 01             	add    $0x1,%esi
  80370c:	eb aa                	jmp    8036b8 <devpipe_read+0x1c>

0080370e <pipe>:
{
  80370e:	55                   	push   %ebp
  80370f:	89 e5                	mov    %esp,%ebp
  803711:	56                   	push   %esi
  803712:	53                   	push   %ebx
  803713:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  803716:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803719:	50                   	push   %eax
  80371a:	e8 82 ea ff ff       	call   8021a1 <fd_alloc>
  80371f:	89 c3                	mov    %eax,%ebx
  803721:	83 c4 10             	add    $0x10,%esp
  803724:	85 c0                	test   %eax,%eax
  803726:	0f 88 23 01 00 00    	js     80384f <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80372c:	83 ec 04             	sub    $0x4,%esp
  80372f:	68 07 04 00 00       	push   $0x407
  803734:	ff 75 f4             	pushl  -0xc(%ebp)
  803737:	6a 00                	push   $0x0
  803739:	e8 13 e1 ff ff       	call   801851 <sys_page_alloc>
  80373e:	89 c3                	mov    %eax,%ebx
  803740:	83 c4 10             	add    $0x10,%esp
  803743:	85 c0                	test   %eax,%eax
  803745:	0f 88 04 01 00 00    	js     80384f <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80374b:	83 ec 0c             	sub    $0xc,%esp
  80374e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803751:	50                   	push   %eax
  803752:	e8 4a ea ff ff       	call   8021a1 <fd_alloc>
  803757:	89 c3                	mov    %eax,%ebx
  803759:	83 c4 10             	add    $0x10,%esp
  80375c:	85 c0                	test   %eax,%eax
  80375e:	0f 88 db 00 00 00    	js     80383f <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803764:	83 ec 04             	sub    $0x4,%esp
  803767:	68 07 04 00 00       	push   $0x407
  80376c:	ff 75 f0             	pushl  -0x10(%ebp)
  80376f:	6a 00                	push   $0x0
  803771:	e8 db e0 ff ff       	call   801851 <sys_page_alloc>
  803776:	89 c3                	mov    %eax,%ebx
  803778:	83 c4 10             	add    $0x10,%esp
  80377b:	85 c0                	test   %eax,%eax
  80377d:	0f 88 bc 00 00 00    	js     80383f <pipe+0x131>
	va = fd2data(fd0);
  803783:	83 ec 0c             	sub    $0xc,%esp
  803786:	ff 75 f4             	pushl  -0xc(%ebp)
  803789:	e8 fc e9 ff ff       	call   80218a <fd2data>
  80378e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803790:	83 c4 0c             	add    $0xc,%esp
  803793:	68 07 04 00 00       	push   $0x407
  803798:	50                   	push   %eax
  803799:	6a 00                	push   $0x0
  80379b:	e8 b1 e0 ff ff       	call   801851 <sys_page_alloc>
  8037a0:	89 c3                	mov    %eax,%ebx
  8037a2:	83 c4 10             	add    $0x10,%esp
  8037a5:	85 c0                	test   %eax,%eax
  8037a7:	0f 88 82 00 00 00    	js     80382f <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8037ad:	83 ec 0c             	sub    $0xc,%esp
  8037b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8037b3:	e8 d2 e9 ff ff       	call   80218a <fd2data>
  8037b8:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8037bf:	50                   	push   %eax
  8037c0:	6a 00                	push   $0x0
  8037c2:	56                   	push   %esi
  8037c3:	6a 00                	push   $0x0
  8037c5:	e8 ca e0 ff ff       	call   801894 <sys_page_map>
  8037ca:	89 c3                	mov    %eax,%ebx
  8037cc:	83 c4 20             	add    $0x20,%esp
  8037cf:	85 c0                	test   %eax,%eax
  8037d1:	78 4e                	js     803821 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8037d3:	a1 58 50 80 00       	mov    0x805058,%eax
  8037d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037db:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8037dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037e0:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8037e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037ea:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8037ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037ef:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8037f6:	83 ec 0c             	sub    $0xc,%esp
  8037f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8037fc:	e8 79 e9 ff ff       	call   80217a <fd2num>
  803801:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803804:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  803806:	83 c4 04             	add    $0x4,%esp
  803809:	ff 75 f0             	pushl  -0x10(%ebp)
  80380c:	e8 69 e9 ff ff       	call   80217a <fd2num>
  803811:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803814:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  803817:	83 c4 10             	add    $0x10,%esp
  80381a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80381f:	eb 2e                	jmp    80384f <pipe+0x141>
	sys_page_unmap(0, va);
  803821:	83 ec 08             	sub    $0x8,%esp
  803824:	56                   	push   %esi
  803825:	6a 00                	push   $0x0
  803827:	e8 aa e0 ff ff       	call   8018d6 <sys_page_unmap>
  80382c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80382f:	83 ec 08             	sub    $0x8,%esp
  803832:	ff 75 f0             	pushl  -0x10(%ebp)
  803835:	6a 00                	push   $0x0
  803837:	e8 9a e0 ff ff       	call   8018d6 <sys_page_unmap>
  80383c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80383f:	83 ec 08             	sub    $0x8,%esp
  803842:	ff 75 f4             	pushl  -0xc(%ebp)
  803845:	6a 00                	push   $0x0
  803847:	e8 8a e0 ff ff       	call   8018d6 <sys_page_unmap>
  80384c:	83 c4 10             	add    $0x10,%esp
}
  80384f:	89 d8                	mov    %ebx,%eax
  803851:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803854:	5b                   	pop    %ebx
  803855:	5e                   	pop    %esi
  803856:	5d                   	pop    %ebp
  803857:	c3                   	ret    

00803858 <pipeisclosed>:
{
  803858:	55                   	push   %ebp
  803859:	89 e5                	mov    %esp,%ebp
  80385b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80385e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803861:	50                   	push   %eax
  803862:	ff 75 08             	pushl  0x8(%ebp)
  803865:	e8 89 e9 ff ff       	call   8021f3 <fd_lookup>
  80386a:	83 c4 10             	add    $0x10,%esp
  80386d:	85 c0                	test   %eax,%eax
  80386f:	78 18                	js     803889 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  803871:	83 ec 0c             	sub    $0xc,%esp
  803874:	ff 75 f4             	pushl  -0xc(%ebp)
  803877:	e8 0e e9 ff ff       	call   80218a <fd2data>
	return _pipeisclosed(fd, p);
  80387c:	89 c2                	mov    %eax,%edx
  80387e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803881:	e8 2f fd ff ff       	call   8035b5 <_pipeisclosed>
  803886:	83 c4 10             	add    $0x10,%esp
}
  803889:	c9                   	leave  
  80388a:	c3                   	ret    

0080388b <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80388b:	55                   	push   %ebp
  80388c:	89 e5                	mov    %esp,%ebp
  80388e:	56                   	push   %esi
  80388f:	53                   	push   %ebx
  803890:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  803893:	85 f6                	test   %esi,%esi
  803895:	74 13                	je     8038aa <wait+0x1f>
	e = &envs[ENVX(envid)];
  803897:	89 f3                	mov    %esi,%ebx
  803899:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80389f:	c1 e3 07             	shl    $0x7,%ebx
  8038a2:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8038a8:	eb 1b                	jmp    8038c5 <wait+0x3a>
	assert(envid != 0);
  8038aa:	68 36 46 80 00       	push   $0x804636
  8038af:	68 4f 3e 80 00       	push   $0x803e4f
  8038b4:	6a 09                	push   $0x9
  8038b6:	68 41 46 80 00       	push   $0x804641
  8038bb:	e8 5a d2 ff ff       	call   800b1a <_panic>
		sys_yield();
  8038c0:	e8 6d df ff ff       	call   801832 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8038c5:	8b 43 48             	mov    0x48(%ebx),%eax
  8038c8:	39 f0                	cmp    %esi,%eax
  8038ca:	75 07                	jne    8038d3 <wait+0x48>
  8038cc:	8b 43 54             	mov    0x54(%ebx),%eax
  8038cf:	85 c0                	test   %eax,%eax
  8038d1:	75 ed                	jne    8038c0 <wait+0x35>
}
  8038d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8038d6:	5b                   	pop    %ebx
  8038d7:	5e                   	pop    %esi
  8038d8:	5d                   	pop    %ebp
  8038d9:	c3                   	ret    

008038da <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8038da:	55                   	push   %ebp
  8038db:	89 e5                	mov    %esp,%ebp
  8038dd:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8038e0:	83 3d 00 90 80 00 00 	cmpl   $0x0,0x809000
  8038e7:	74 0a                	je     8038f3 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8038e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ec:	a3 00 90 80 00       	mov    %eax,0x809000
}
  8038f1:	c9                   	leave  
  8038f2:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8038f3:	83 ec 04             	sub    $0x4,%esp
  8038f6:	6a 07                	push   $0x7
  8038f8:	68 00 f0 bf ee       	push   $0xeebff000
  8038fd:	6a 00                	push   $0x0
  8038ff:	e8 4d df ff ff       	call   801851 <sys_page_alloc>
		if(r < 0)
  803904:	83 c4 10             	add    $0x10,%esp
  803907:	85 c0                	test   %eax,%eax
  803909:	78 2a                	js     803935 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80390b:	83 ec 08             	sub    $0x8,%esp
  80390e:	68 49 39 80 00       	push   $0x803949
  803913:	6a 00                	push   $0x0
  803915:	e8 82 e0 ff ff       	call   80199c <sys_env_set_pgfault_upcall>
		if(r < 0)
  80391a:	83 c4 10             	add    $0x10,%esp
  80391d:	85 c0                	test   %eax,%eax
  80391f:	79 c8                	jns    8038e9 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  803921:	83 ec 04             	sub    $0x4,%esp
  803924:	68 7c 46 80 00       	push   $0x80467c
  803929:	6a 25                	push   $0x25
  80392b:	68 b8 46 80 00       	push   $0x8046b8
  803930:	e8 e5 d1 ff ff       	call   800b1a <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  803935:	83 ec 04             	sub    $0x4,%esp
  803938:	68 4c 46 80 00       	push   $0x80464c
  80393d:	6a 22                	push   $0x22
  80393f:	68 b8 46 80 00       	push   $0x8046b8
  803944:	e8 d1 d1 ff ff       	call   800b1a <_panic>

00803949 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  803949:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80394a:	a1 00 90 80 00       	mov    0x809000,%eax
	call *%eax
  80394f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  803951:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  803954:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  803958:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  80395c:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80395f:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  803961:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  803965:	83 c4 08             	add    $0x8,%esp
	popal
  803968:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  803969:	83 c4 04             	add    $0x4,%esp
	popfl
  80396c:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80396d:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80396e:	c3                   	ret    

0080396f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80396f:	55                   	push   %ebp
  803970:	89 e5                	mov    %esp,%ebp
  803972:	56                   	push   %esi
  803973:	53                   	push   %ebx
  803974:	8b 75 08             	mov    0x8(%ebp),%esi
  803977:	8b 45 0c             	mov    0xc(%ebp),%eax
  80397a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80397d:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80397f:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  803984:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  803987:	83 ec 0c             	sub    $0xc,%esp
  80398a:	50                   	push   %eax
  80398b:	e8 71 e0 ff ff       	call   801a01 <sys_ipc_recv>
	if(ret < 0){
  803990:	83 c4 10             	add    $0x10,%esp
  803993:	85 c0                	test   %eax,%eax
  803995:	78 2b                	js     8039c2 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  803997:	85 f6                	test   %esi,%esi
  803999:	74 0a                	je     8039a5 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80399b:	a1 28 64 80 00       	mov    0x806428,%eax
  8039a0:	8b 40 74             	mov    0x74(%eax),%eax
  8039a3:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8039a5:	85 db                	test   %ebx,%ebx
  8039a7:	74 0a                	je     8039b3 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8039a9:	a1 28 64 80 00       	mov    0x806428,%eax
  8039ae:	8b 40 78             	mov    0x78(%eax),%eax
  8039b1:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8039b3:	a1 28 64 80 00       	mov    0x806428,%eax
  8039b8:	8b 40 70             	mov    0x70(%eax),%eax
}
  8039bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8039be:	5b                   	pop    %ebx
  8039bf:	5e                   	pop    %esi
  8039c0:	5d                   	pop    %ebp
  8039c1:	c3                   	ret    
		if(from_env_store)
  8039c2:	85 f6                	test   %esi,%esi
  8039c4:	74 06                	je     8039cc <ipc_recv+0x5d>
			*from_env_store = 0;
  8039c6:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8039cc:	85 db                	test   %ebx,%ebx
  8039ce:	74 eb                	je     8039bb <ipc_recv+0x4c>
			*perm_store = 0;
  8039d0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8039d6:	eb e3                	jmp    8039bb <ipc_recv+0x4c>

008039d8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8039d8:	55                   	push   %ebp
  8039d9:	89 e5                	mov    %esp,%ebp
  8039db:	57                   	push   %edi
  8039dc:	56                   	push   %esi
  8039dd:	53                   	push   %ebx
  8039de:	83 ec 0c             	sub    $0xc,%esp
  8039e1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8039e4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8039e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8039ea:	85 db                	test   %ebx,%ebx
  8039ec:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8039f1:	0f 44 d8             	cmove  %eax,%ebx
  8039f4:	eb 05                	jmp    8039fb <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8039f6:	e8 37 de ff ff       	call   801832 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8039fb:	ff 75 14             	pushl  0x14(%ebp)
  8039fe:	53                   	push   %ebx
  8039ff:	56                   	push   %esi
  803a00:	57                   	push   %edi
  803a01:	e8 d8 df ff ff       	call   8019de <sys_ipc_try_send>
  803a06:	83 c4 10             	add    $0x10,%esp
  803a09:	85 c0                	test   %eax,%eax
  803a0b:	74 1b                	je     803a28 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  803a0d:	79 e7                	jns    8039f6 <ipc_send+0x1e>
  803a0f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  803a12:	74 e2                	je     8039f6 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  803a14:	83 ec 04             	sub    $0x4,%esp
  803a17:	68 c6 46 80 00       	push   $0x8046c6
  803a1c:	6a 46                	push   $0x46
  803a1e:	68 db 46 80 00       	push   $0x8046db
  803a23:	e8 f2 d0 ff ff       	call   800b1a <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  803a28:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803a2b:	5b                   	pop    %ebx
  803a2c:	5e                   	pop    %esi
  803a2d:	5f                   	pop    %edi
  803a2e:	5d                   	pop    %ebp
  803a2f:	c3                   	ret    

00803a30 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803a30:	55                   	push   %ebp
  803a31:	89 e5                	mov    %esp,%ebp
  803a33:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  803a36:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  803a3b:	89 c2                	mov    %eax,%edx
  803a3d:	c1 e2 07             	shl    $0x7,%edx
  803a40:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  803a46:	8b 52 50             	mov    0x50(%edx),%edx
  803a49:	39 ca                	cmp    %ecx,%edx
  803a4b:	74 11                	je     803a5e <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  803a4d:	83 c0 01             	add    $0x1,%eax
  803a50:	3d 00 04 00 00       	cmp    $0x400,%eax
  803a55:	75 e4                	jne    803a3b <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  803a57:	b8 00 00 00 00       	mov    $0x0,%eax
  803a5c:	eb 0b                	jmp    803a69 <ipc_find_env+0x39>
			return envs[i].env_id;
  803a5e:	c1 e0 07             	shl    $0x7,%eax
  803a61:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  803a66:	8b 40 48             	mov    0x48(%eax),%eax
}
  803a69:	5d                   	pop    %ebp
  803a6a:	c3                   	ret    

00803a6b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803a6b:	55                   	push   %ebp
  803a6c:	89 e5                	mov    %esp,%ebp
  803a6e:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803a71:	89 d0                	mov    %edx,%eax
  803a73:	c1 e8 16             	shr    $0x16,%eax
  803a76:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  803a7d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  803a82:	f6 c1 01             	test   $0x1,%cl
  803a85:	74 1d                	je     803aa4 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  803a87:	c1 ea 0c             	shr    $0xc,%edx
  803a8a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803a91:	f6 c2 01             	test   $0x1,%dl
  803a94:	74 0e                	je     803aa4 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803a96:	c1 ea 0c             	shr    $0xc,%edx
  803a99:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  803aa0:	ef 
  803aa1:	0f b7 c0             	movzwl %ax,%eax
}
  803aa4:	5d                   	pop    %ebp
  803aa5:	c3                   	ret    
  803aa6:	66 90                	xchg   %ax,%ax
  803aa8:	66 90                	xchg   %ax,%ax
  803aaa:	66 90                	xchg   %ax,%ax
  803aac:	66 90                	xchg   %ax,%ax
  803aae:	66 90                	xchg   %ax,%ax

00803ab0 <__udivdi3>:
  803ab0:	55                   	push   %ebp
  803ab1:	57                   	push   %edi
  803ab2:	56                   	push   %esi
  803ab3:	53                   	push   %ebx
  803ab4:	83 ec 1c             	sub    $0x1c,%esp
  803ab7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  803abb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  803abf:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ac3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  803ac7:	85 d2                	test   %edx,%edx
  803ac9:	75 4d                	jne    803b18 <__udivdi3+0x68>
  803acb:	39 f3                	cmp    %esi,%ebx
  803acd:	76 19                	jbe    803ae8 <__udivdi3+0x38>
  803acf:	31 ff                	xor    %edi,%edi
  803ad1:	89 e8                	mov    %ebp,%eax
  803ad3:	89 f2                	mov    %esi,%edx
  803ad5:	f7 f3                	div    %ebx
  803ad7:	89 fa                	mov    %edi,%edx
  803ad9:	83 c4 1c             	add    $0x1c,%esp
  803adc:	5b                   	pop    %ebx
  803add:	5e                   	pop    %esi
  803ade:	5f                   	pop    %edi
  803adf:	5d                   	pop    %ebp
  803ae0:	c3                   	ret    
  803ae1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803ae8:	89 d9                	mov    %ebx,%ecx
  803aea:	85 db                	test   %ebx,%ebx
  803aec:	75 0b                	jne    803af9 <__udivdi3+0x49>
  803aee:	b8 01 00 00 00       	mov    $0x1,%eax
  803af3:	31 d2                	xor    %edx,%edx
  803af5:	f7 f3                	div    %ebx
  803af7:	89 c1                	mov    %eax,%ecx
  803af9:	31 d2                	xor    %edx,%edx
  803afb:	89 f0                	mov    %esi,%eax
  803afd:	f7 f1                	div    %ecx
  803aff:	89 c6                	mov    %eax,%esi
  803b01:	89 e8                	mov    %ebp,%eax
  803b03:	89 f7                	mov    %esi,%edi
  803b05:	f7 f1                	div    %ecx
  803b07:	89 fa                	mov    %edi,%edx
  803b09:	83 c4 1c             	add    $0x1c,%esp
  803b0c:	5b                   	pop    %ebx
  803b0d:	5e                   	pop    %esi
  803b0e:	5f                   	pop    %edi
  803b0f:	5d                   	pop    %ebp
  803b10:	c3                   	ret    
  803b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803b18:	39 f2                	cmp    %esi,%edx
  803b1a:	77 1c                	ja     803b38 <__udivdi3+0x88>
  803b1c:	0f bd fa             	bsr    %edx,%edi
  803b1f:	83 f7 1f             	xor    $0x1f,%edi
  803b22:	75 2c                	jne    803b50 <__udivdi3+0xa0>
  803b24:	39 f2                	cmp    %esi,%edx
  803b26:	72 06                	jb     803b2e <__udivdi3+0x7e>
  803b28:	31 c0                	xor    %eax,%eax
  803b2a:	39 eb                	cmp    %ebp,%ebx
  803b2c:	77 a9                	ja     803ad7 <__udivdi3+0x27>
  803b2e:	b8 01 00 00 00       	mov    $0x1,%eax
  803b33:	eb a2                	jmp    803ad7 <__udivdi3+0x27>
  803b35:	8d 76 00             	lea    0x0(%esi),%esi
  803b38:	31 ff                	xor    %edi,%edi
  803b3a:	31 c0                	xor    %eax,%eax
  803b3c:	89 fa                	mov    %edi,%edx
  803b3e:	83 c4 1c             	add    $0x1c,%esp
  803b41:	5b                   	pop    %ebx
  803b42:	5e                   	pop    %esi
  803b43:	5f                   	pop    %edi
  803b44:	5d                   	pop    %ebp
  803b45:	c3                   	ret    
  803b46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803b4d:	8d 76 00             	lea    0x0(%esi),%esi
  803b50:	89 f9                	mov    %edi,%ecx
  803b52:	b8 20 00 00 00       	mov    $0x20,%eax
  803b57:	29 f8                	sub    %edi,%eax
  803b59:	d3 e2                	shl    %cl,%edx
  803b5b:	89 54 24 08          	mov    %edx,0x8(%esp)
  803b5f:	89 c1                	mov    %eax,%ecx
  803b61:	89 da                	mov    %ebx,%edx
  803b63:	d3 ea                	shr    %cl,%edx
  803b65:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803b69:	09 d1                	or     %edx,%ecx
  803b6b:	89 f2                	mov    %esi,%edx
  803b6d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b71:	89 f9                	mov    %edi,%ecx
  803b73:	d3 e3                	shl    %cl,%ebx
  803b75:	89 c1                	mov    %eax,%ecx
  803b77:	d3 ea                	shr    %cl,%edx
  803b79:	89 f9                	mov    %edi,%ecx
  803b7b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  803b7f:	89 eb                	mov    %ebp,%ebx
  803b81:	d3 e6                	shl    %cl,%esi
  803b83:	89 c1                	mov    %eax,%ecx
  803b85:	d3 eb                	shr    %cl,%ebx
  803b87:	09 de                	or     %ebx,%esi
  803b89:	89 f0                	mov    %esi,%eax
  803b8b:	f7 74 24 08          	divl   0x8(%esp)
  803b8f:	89 d6                	mov    %edx,%esi
  803b91:	89 c3                	mov    %eax,%ebx
  803b93:	f7 64 24 0c          	mull   0xc(%esp)
  803b97:	39 d6                	cmp    %edx,%esi
  803b99:	72 15                	jb     803bb0 <__udivdi3+0x100>
  803b9b:	89 f9                	mov    %edi,%ecx
  803b9d:	d3 e5                	shl    %cl,%ebp
  803b9f:	39 c5                	cmp    %eax,%ebp
  803ba1:	73 04                	jae    803ba7 <__udivdi3+0xf7>
  803ba3:	39 d6                	cmp    %edx,%esi
  803ba5:	74 09                	je     803bb0 <__udivdi3+0x100>
  803ba7:	89 d8                	mov    %ebx,%eax
  803ba9:	31 ff                	xor    %edi,%edi
  803bab:	e9 27 ff ff ff       	jmp    803ad7 <__udivdi3+0x27>
  803bb0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803bb3:	31 ff                	xor    %edi,%edi
  803bb5:	e9 1d ff ff ff       	jmp    803ad7 <__udivdi3+0x27>
  803bba:	66 90                	xchg   %ax,%ax
  803bbc:	66 90                	xchg   %ax,%ax
  803bbe:	66 90                	xchg   %ax,%ax

00803bc0 <__umoddi3>:
  803bc0:	55                   	push   %ebp
  803bc1:	57                   	push   %edi
  803bc2:	56                   	push   %esi
  803bc3:	53                   	push   %ebx
  803bc4:	83 ec 1c             	sub    $0x1c,%esp
  803bc7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  803bcb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803bcf:	8b 74 24 30          	mov    0x30(%esp),%esi
  803bd3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803bd7:	89 da                	mov    %ebx,%edx
  803bd9:	85 c0                	test   %eax,%eax
  803bdb:	75 43                	jne    803c20 <__umoddi3+0x60>
  803bdd:	39 df                	cmp    %ebx,%edi
  803bdf:	76 17                	jbe    803bf8 <__umoddi3+0x38>
  803be1:	89 f0                	mov    %esi,%eax
  803be3:	f7 f7                	div    %edi
  803be5:	89 d0                	mov    %edx,%eax
  803be7:	31 d2                	xor    %edx,%edx
  803be9:	83 c4 1c             	add    $0x1c,%esp
  803bec:	5b                   	pop    %ebx
  803bed:	5e                   	pop    %esi
  803bee:	5f                   	pop    %edi
  803bef:	5d                   	pop    %ebp
  803bf0:	c3                   	ret    
  803bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803bf8:	89 fd                	mov    %edi,%ebp
  803bfa:	85 ff                	test   %edi,%edi
  803bfc:	75 0b                	jne    803c09 <__umoddi3+0x49>
  803bfe:	b8 01 00 00 00       	mov    $0x1,%eax
  803c03:	31 d2                	xor    %edx,%edx
  803c05:	f7 f7                	div    %edi
  803c07:	89 c5                	mov    %eax,%ebp
  803c09:	89 d8                	mov    %ebx,%eax
  803c0b:	31 d2                	xor    %edx,%edx
  803c0d:	f7 f5                	div    %ebp
  803c0f:	89 f0                	mov    %esi,%eax
  803c11:	f7 f5                	div    %ebp
  803c13:	89 d0                	mov    %edx,%eax
  803c15:	eb d0                	jmp    803be7 <__umoddi3+0x27>
  803c17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803c1e:	66 90                	xchg   %ax,%ax
  803c20:	89 f1                	mov    %esi,%ecx
  803c22:	39 d8                	cmp    %ebx,%eax
  803c24:	76 0a                	jbe    803c30 <__umoddi3+0x70>
  803c26:	89 f0                	mov    %esi,%eax
  803c28:	83 c4 1c             	add    $0x1c,%esp
  803c2b:	5b                   	pop    %ebx
  803c2c:	5e                   	pop    %esi
  803c2d:	5f                   	pop    %edi
  803c2e:	5d                   	pop    %ebp
  803c2f:	c3                   	ret    
  803c30:	0f bd e8             	bsr    %eax,%ebp
  803c33:	83 f5 1f             	xor    $0x1f,%ebp
  803c36:	75 20                	jne    803c58 <__umoddi3+0x98>
  803c38:	39 d8                	cmp    %ebx,%eax
  803c3a:	0f 82 b0 00 00 00    	jb     803cf0 <__umoddi3+0x130>
  803c40:	39 f7                	cmp    %esi,%edi
  803c42:	0f 86 a8 00 00 00    	jbe    803cf0 <__umoddi3+0x130>
  803c48:	89 c8                	mov    %ecx,%eax
  803c4a:	83 c4 1c             	add    $0x1c,%esp
  803c4d:	5b                   	pop    %ebx
  803c4e:	5e                   	pop    %esi
  803c4f:	5f                   	pop    %edi
  803c50:	5d                   	pop    %ebp
  803c51:	c3                   	ret    
  803c52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803c58:	89 e9                	mov    %ebp,%ecx
  803c5a:	ba 20 00 00 00       	mov    $0x20,%edx
  803c5f:	29 ea                	sub    %ebp,%edx
  803c61:	d3 e0                	shl    %cl,%eax
  803c63:	89 44 24 08          	mov    %eax,0x8(%esp)
  803c67:	89 d1                	mov    %edx,%ecx
  803c69:	89 f8                	mov    %edi,%eax
  803c6b:	d3 e8                	shr    %cl,%eax
  803c6d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803c71:	89 54 24 04          	mov    %edx,0x4(%esp)
  803c75:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c79:	09 c1                	or     %eax,%ecx
  803c7b:	89 d8                	mov    %ebx,%eax
  803c7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c81:	89 e9                	mov    %ebp,%ecx
  803c83:	d3 e7                	shl    %cl,%edi
  803c85:	89 d1                	mov    %edx,%ecx
  803c87:	d3 e8                	shr    %cl,%eax
  803c89:	89 e9                	mov    %ebp,%ecx
  803c8b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c8f:	d3 e3                	shl    %cl,%ebx
  803c91:	89 c7                	mov    %eax,%edi
  803c93:	89 d1                	mov    %edx,%ecx
  803c95:	89 f0                	mov    %esi,%eax
  803c97:	d3 e8                	shr    %cl,%eax
  803c99:	89 e9                	mov    %ebp,%ecx
  803c9b:	89 fa                	mov    %edi,%edx
  803c9d:	d3 e6                	shl    %cl,%esi
  803c9f:	09 d8                	or     %ebx,%eax
  803ca1:	f7 74 24 08          	divl   0x8(%esp)
  803ca5:	89 d1                	mov    %edx,%ecx
  803ca7:	89 f3                	mov    %esi,%ebx
  803ca9:	f7 64 24 0c          	mull   0xc(%esp)
  803cad:	89 c6                	mov    %eax,%esi
  803caf:	89 d7                	mov    %edx,%edi
  803cb1:	39 d1                	cmp    %edx,%ecx
  803cb3:	72 06                	jb     803cbb <__umoddi3+0xfb>
  803cb5:	75 10                	jne    803cc7 <__umoddi3+0x107>
  803cb7:	39 c3                	cmp    %eax,%ebx
  803cb9:	73 0c                	jae    803cc7 <__umoddi3+0x107>
  803cbb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  803cbf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  803cc3:	89 d7                	mov    %edx,%edi
  803cc5:	89 c6                	mov    %eax,%esi
  803cc7:	89 ca                	mov    %ecx,%edx
  803cc9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  803cce:	29 f3                	sub    %esi,%ebx
  803cd0:	19 fa                	sbb    %edi,%edx
  803cd2:	89 d0                	mov    %edx,%eax
  803cd4:	d3 e0                	shl    %cl,%eax
  803cd6:	89 e9                	mov    %ebp,%ecx
  803cd8:	d3 eb                	shr    %cl,%ebx
  803cda:	d3 ea                	shr    %cl,%edx
  803cdc:	09 d8                	or     %ebx,%eax
  803cde:	83 c4 1c             	add    $0x1c,%esp
  803ce1:	5b                   	pop    %ebx
  803ce2:	5e                   	pop    %esi
  803ce3:	5f                   	pop    %edi
  803ce4:	5d                   	pop    %ebp
  803ce5:	c3                   	ret    
  803ce6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803ced:	8d 76 00             	lea    0x0(%esi),%esi
  803cf0:	89 da                	mov    %ebx,%edx
  803cf2:	29 fe                	sub    %edi,%esi
  803cf4:	19 c2                	sbb    %eax,%edx
  803cf6:	89 f1                	mov    %esi,%ecx
  803cf8:	89 c8                	mov    %ecx,%eax
  803cfa:	e9 4b ff ff ff       	jmp    803c4a <__umoddi3+0x8a>
