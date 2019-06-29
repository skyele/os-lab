
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
  800065:	68 9d 3c 80 00       	push   $0x803c9d
  80006a:	e8 69 14 00 00       	call   8014d8 <strchr>
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
  800090:	68 80 3c 80 00       	push   $0x803c80
  800095:	e8 e6 0a 00 00       	call   800b80 <cprintf>
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	eb 28                	jmp    8000c7 <_gettoken+0x94>
		cprintf("GETTOKEN: %s\n", s);
  80009f:	83 ec 08             	sub    $0x8,%esp
  8000a2:	53                   	push   %ebx
  8000a3:	68 8f 3c 80 00       	push   $0x803c8f
  8000a8:	e8 d3 0a 00 00       	call   800b80 <cprintf>
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
  8000d4:	68 a2 3c 80 00       	push   $0x803ca2
  8000d9:	e8 a2 0a 00 00       	call   800b80 <cprintf>
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	eb e4                	jmp    8000c7 <_gettoken+0x94>
	if (strchr(SYMBOLS, *s)) {
  8000e3:	83 ec 08             	sub    $0x8,%esp
  8000e6:	0f be c0             	movsbl %al,%eax
  8000e9:	50                   	push   %eax
  8000ea:	68 b3 3c 80 00       	push   $0x803cb3
  8000ef:	e8 e4 13 00 00       	call   8014d8 <strchr>
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
  800118:	68 a7 3c 80 00       	push   $0x803ca7
  80011d:	e8 5e 0a 00 00       	call   800b80 <cprintf>
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
  80013c:	68 af 3c 80 00       	push   $0x803caf
  800141:	e8 92 13 00 00       	call   8014d8 <strchr>
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
  80016f:	68 bb 3c 80 00       	push   $0x803cbb
  800174:	e8 07 0a 00 00       	call   800b80 <cprintf>
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
  800269:	e8 09 26 00 00       	call   802877 <open>
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
  80029a:	e8 e6 33 00 00       	call   803685 <pipe>
  80029f:	83 c4 10             	add    $0x10,%esp
  8002a2:	85 c0                	test   %eax,%eax
  8002a4:	0f 88 41 01 00 00    	js     8003eb <runcmd+0x1f1>
			if (debug)
  8002aa:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8002b1:	0f 85 4f 01 00 00    	jne    800406 <runcmd+0x20c>
			if ((r = fork()) < 0) {
  8002b7:	e8 4f 1a 00 00       	call   801d0b <fork>
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
  8002e3:	e8 b3 1f 00 00       	call   80229b <close>
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
  800307:	68 c5 3c 80 00       	push   $0x803cc5
  80030c:	e8 6f 08 00 00       	call   800b80 <cprintf>
				exit();
  800311:	e8 40 07 00 00       	call   800a56 <exit>
  800316:	83 c4 10             	add    $0x10,%esp
  800319:	eb da                	jmp    8002f5 <runcmd+0xfb>
				cprintf("syntax error: < not followed by word\n");
  80031b:	83 ec 0c             	sub    $0xc,%esp
  80031e:	68 18 3e 80 00       	push   $0x803e18
  800323:	e8 58 08 00 00       	call   800b80 <cprintf>
				exit();
  800328:	e8 29 07 00 00       	call   800a56 <exit>
  80032d:	83 c4 10             	add    $0x10,%esp
  800330:	e9 29 ff ff ff       	jmp    80025e <runcmd+0x64>
				cprintf("open %s for read: %e", t, fd);
  800335:	83 ec 04             	sub    $0x4,%esp
  800338:	50                   	push   %eax
  800339:	ff 75 a4             	pushl  -0x5c(%ebp)
  80033c:	68 d9 3c 80 00       	push   $0x803cd9
  800341:	e8 3a 08 00 00       	call   800b80 <cprintf>
				exit();
  800346:	e8 0b 07 00 00       	call   800a56 <exit>
  80034b:	83 c4 10             	add    $0x10,%esp
				dup(fd, 0);
  80034e:	83 ec 08             	sub    $0x8,%esp
  800351:	6a 00                	push   $0x0
  800353:	53                   	push   %ebx
  800354:	e8 94 1f 00 00       	call   8022ed <dup>
				close(fd);
  800359:	89 1c 24             	mov    %ebx,(%esp)
  80035c:	e8 3a 1f 00 00       	call   80229b <close>
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
  800387:	e8 eb 24 00 00       	call   802877 <open>
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
  8003a3:	68 40 3e 80 00       	push   $0x803e40
  8003a8:	e8 d3 07 00 00       	call   800b80 <cprintf>
				exit();
  8003ad:	e8 a4 06 00 00       	call   800a56 <exit>
  8003b2:	83 c4 10             	add    $0x10,%esp
  8003b5:	eb c5                	jmp    80037c <runcmd+0x182>
				cprintf("open %s for write: %e", t, fd);
  8003b7:	83 ec 04             	sub    $0x4,%esp
  8003ba:	50                   	push   %eax
  8003bb:	ff 75 a4             	pushl  -0x5c(%ebp)
  8003be:	68 ee 3c 80 00       	push   $0x803cee
  8003c3:	e8 b8 07 00 00       	call   800b80 <cprintf>
				exit();
  8003c8:	e8 89 06 00 00       	call   800a56 <exit>
  8003cd:	83 c4 10             	add    $0x10,%esp
				dup(fd, 1);
  8003d0:	83 ec 08             	sub    $0x8,%esp
  8003d3:	6a 01                	push   $0x1
  8003d5:	53                   	push   %ebx
  8003d6:	e8 12 1f 00 00       	call   8022ed <dup>
				close(fd);
  8003db:	89 1c 24             	mov    %ebx,(%esp)
  8003de:	e8 b8 1e 00 00       	call   80229b <close>
  8003e3:	83 c4 10             	add    $0x10,%esp
  8003e6:	e9 30 fe ff ff       	jmp    80021b <runcmd+0x21>
				cprintf("pipe: %e", r);
  8003eb:	83 ec 08             	sub    $0x8,%esp
  8003ee:	50                   	push   %eax
  8003ef:	68 04 3d 80 00       	push   $0x803d04
  8003f4:	e8 87 07 00 00       	call   800b80 <cprintf>
				exit();
  8003f9:	e8 58 06 00 00       	call   800a56 <exit>
  8003fe:	83 c4 10             	add    $0x10,%esp
  800401:	e9 a4 fe ff ff       	jmp    8002aa <runcmd+0xb0>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  800406:	83 ec 04             	sub    $0x4,%esp
  800409:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  80040f:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  800415:	68 0d 3d 80 00       	push   $0x803d0d
  80041a:	e8 61 07 00 00       	call   800b80 <cprintf>
  80041f:	83 c4 10             	add    $0x10,%esp
  800422:	e9 90 fe ff ff       	jmp    8002b7 <runcmd+0xbd>
				cprintf("fork: %e", r);
  800427:	83 ec 08             	sub    $0x8,%esp
  80042a:	50                   	push   %eax
  80042b:	68 1a 3d 80 00       	push   $0x803d1a
  800430:	e8 4b 07 00 00       	call   800b80 <cprintf>
				exit();
  800435:	e8 1c 06 00 00       	call   800a56 <exit>
  80043a:	83 c4 10             	add    $0x10,%esp
				if (p[1] != 1) {
  80043d:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  800443:	83 f8 01             	cmp    $0x1,%eax
  800446:	0f 85 cc 00 00 00    	jne    800518 <runcmd+0x31e>
				close(p[0]);
  80044c:	83 ec 0c             	sub    $0xc,%esp
  80044f:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  800455:	e8 41 1e 00 00       	call   80229b <close>
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
  800490:	e8 9b 25 00 00       	call   802a30 <spawn>
  800495:	89 c6                	mov    %eax,%esi
  800497:	83 c4 10             	add    $0x10,%esp
  80049a:	85 c0                	test   %eax,%eax
  80049c:	0f 88 3a 01 00 00    	js     8005dc <runcmd+0x3e2>
	close_all();
  8004a2:	e8 21 1e 00 00       	call   8022c8 <close_all>
		if (debug)
  8004a7:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8004ae:	0f 85 75 01 00 00    	jne    800629 <runcmd+0x42f>
		wait(r);
  8004b4:	83 ec 0c             	sub    $0xc,%esp
  8004b7:	56                   	push   %esi
  8004b8:	e8 45 33 00 00       	call   803802 <wait>
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
  8004d5:	e8 28 33 00 00       	call   803802 <wait>
		if (debug)
  8004da:	83 c4 10             	add    $0x10,%esp
  8004dd:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8004e4:	0f 85 79 01 00 00    	jne    800663 <runcmd+0x469>
	exit();
  8004ea:	e8 67 05 00 00       	call   800a56 <exit>
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
  8004fd:	e8 eb 1d 00 00       	call   8022ed <dup>
					close(p[0]);
  800502:	83 c4 04             	add    $0x4,%esp
  800505:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  80050b:	e8 8b 1d 00 00       	call   80229b <close>
  800510:	83 c4 10             	add    $0x10,%esp
  800513:	e9 c2 fd ff ff       	jmp    8002da <runcmd+0xe0>
					dup(p[1], 1);
  800518:	83 ec 08             	sub    $0x8,%esp
  80051b:	6a 01                	push   $0x1
  80051d:	50                   	push   %eax
  80051e:	e8 ca 1d 00 00       	call   8022ed <dup>
					close(p[1]);
  800523:	83 c4 04             	add    $0x4,%esp
  800526:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  80052c:	e8 6a 1d 00 00       	call   80229b <close>
  800531:	83 c4 10             	add    $0x10,%esp
  800534:	e9 13 ff ff ff       	jmp    80044c <runcmd+0x252>
			panic("bad return %d from gettoken", c);
  800539:	53                   	push   %ebx
  80053a:	68 23 3d 80 00       	push   $0x803d23
  80053f:	6a 78                	push   $0x78
  800541:	68 3f 3d 80 00       	push   $0x803d3f
  800546:	e8 3f 05 00 00       	call   800a8a <_panic>
		if (debug)
  80054b:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800552:	74 9b                	je     8004ef <runcmd+0x2f5>
			cprintf("EMPTY COMMAND\n");
  800554:	83 ec 0c             	sub    $0xc,%esp
  800557:	68 49 3d 80 00       	push   $0x803d49
  80055c:	e8 1f 06 00 00       	call   800b80 <cprintf>
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
  80057e:	e8 4c 0e 00 00       	call   8013cf <strcpy>
		argv[0] = argv0buf;
  800583:	89 75 a8             	mov    %esi,-0x58(%ebp)
  800586:	83 c4 10             	add    $0x10,%esp
  800589:	e9 e3 fe ff ff       	jmp    800471 <runcmd+0x277>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  80058e:	a1 28 64 80 00       	mov    0x806428,%eax
  800593:	8b 40 48             	mov    0x48(%eax),%eax
  800596:	83 ec 08             	sub    $0x8,%esp
  800599:	50                   	push   %eax
  80059a:	68 58 3d 80 00       	push   $0x803d58
  80059f:	e8 dc 05 00 00       	call   800b80 <cprintf>
  8005a4:	8d 75 a8             	lea    -0x58(%ebp),%esi
		for (i = 0; argv[i]; i++)
  8005a7:	83 c4 10             	add    $0x10,%esp
  8005aa:	eb 11                	jmp    8005bd <runcmd+0x3c3>
			cprintf(" %s", argv[i]);
  8005ac:	83 ec 08             	sub    $0x8,%esp
  8005af:	50                   	push   %eax
  8005b0:	68 e0 3d 80 00       	push   $0x803de0
  8005b5:	e8 c6 05 00 00       	call   800b80 <cprintf>
  8005ba:	83 c4 10             	add    $0x10,%esp
  8005bd:	83 c6 04             	add    $0x4,%esi
		for (i = 0; argv[i]; i++)
  8005c0:	8b 46 fc             	mov    -0x4(%esi),%eax
  8005c3:	85 c0                	test   %eax,%eax
  8005c5:	75 e5                	jne    8005ac <runcmd+0x3b2>
		cprintf("\n");
  8005c7:	83 ec 0c             	sub    $0xc,%esp
  8005ca:	68 a0 3c 80 00       	push   $0x803ca0
  8005cf:	e8 ac 05 00 00       	call   800b80 <cprintf>
  8005d4:	83 c4 10             	add    $0x10,%esp
  8005d7:	e9 aa fe ff ff       	jmp    800486 <runcmd+0x28c>
		cprintf("spawn %s: %e\n", argv[0], r);
  8005dc:	83 ec 04             	sub    $0x4,%esp
  8005df:	50                   	push   %eax
  8005e0:	ff 75 a8             	pushl  -0x58(%ebp)
  8005e3:	68 66 3d 80 00       	push   $0x803d66
  8005e8:	e8 93 05 00 00       	call   800b80 <cprintf>
	close_all();
  8005ed:	e8 d6 1c 00 00       	call   8022c8 <close_all>
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
  800617:	68 9f 3d 80 00       	push   $0x803d9f
  80061c:	e8 5f 05 00 00       	call   800b80 <cprintf>
  800621:	83 c4 10             	add    $0x10,%esp
  800624:	e9 a8 fe ff ff       	jmp    8004d1 <runcmd+0x2d7>
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  800629:	a1 28 64 80 00       	mov    0x806428,%eax
  80062e:	8b 40 48             	mov    0x48(%eax),%eax
  800631:	56                   	push   %esi
  800632:	ff 75 a8             	pushl  -0x58(%ebp)
  800635:	50                   	push   %eax
  800636:	68 74 3d 80 00       	push   $0x803d74
  80063b:	e8 40 05 00 00       	call   800b80 <cprintf>
  800640:	83 c4 10             	add    $0x10,%esp
  800643:	e9 6c fe ff ff       	jmp    8004b4 <runcmd+0x2ba>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800648:	a1 28 64 80 00       	mov    0x806428,%eax
  80064d:	8b 40 48             	mov    0x48(%eax),%eax
  800650:	83 ec 08             	sub    $0x8,%esp
  800653:	50                   	push   %eax
  800654:	68 89 3d 80 00       	push   $0x803d89
  800659:	e8 22 05 00 00       	call   800b80 <cprintf>
  80065e:	83 c4 10             	add    $0x10,%esp
  800661:	eb 92                	jmp    8005f5 <runcmd+0x3fb>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800663:	a1 28 64 80 00       	mov    0x806428,%eax
  800668:	8b 40 48             	mov    0x48(%eax),%eax
  80066b:	83 ec 08             	sub    $0x8,%esp
  80066e:	50                   	push   %eax
  80066f:	68 89 3d 80 00       	push   $0x803d89
  800674:	e8 07 05 00 00       	call   800b80 <cprintf>
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
  800687:	68 68 3e 80 00       	push   $0x803e68
  80068c:	e8 ef 04 00 00       	call   800b80 <cprintf>
	exit();
  800691:	e8 c0 03 00 00       	call   800a56 <exit>
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
  8006af:	e8 ef 18 00 00       	call   801fa3 <argstart>
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
  8006e1:	e8 ed 18 00 00       	call   801fd3 <argnext>
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
  800716:	bf e4 3d 80 00       	mov    $0x803de4,%edi
  80071b:	b8 00 00 00 00       	mov    $0x0,%eax
  800720:	0f 44 f8             	cmove  %eax,%edi
  800723:	e9 06 01 00 00       	jmp    80082e <umain+0x193>
		usage();
  800728:	e8 54 ff ff ff       	call   800681 <usage>
  80072d:	eb da                	jmp    800709 <umain+0x6e>
		close(0);
  80072f:	83 ec 0c             	sub    $0xc,%esp
  800732:	6a 00                	push   $0x0
  800734:	e8 62 1b 00 00       	call   80229b <close>
		if ((r = open(argv[1], O_RDONLY)) < 0)
  800739:	83 c4 08             	add    $0x8,%esp
  80073c:	6a 00                	push   $0x0
  80073e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800741:	ff 70 04             	pushl  0x4(%eax)
  800744:	e8 2e 21 00 00       	call   802877 <open>
  800749:	83 c4 10             	add    $0x10,%esp
  80074c:	85 c0                	test   %eax,%eax
  80074e:	78 1b                	js     80076b <umain+0xd0>
		assert(r == 0);
  800750:	74 bd                	je     80070f <umain+0x74>
  800752:	68 c8 3d 80 00       	push   $0x803dc8
  800757:	68 cf 3d 80 00       	push   $0x803dcf
  80075c:	68 29 01 00 00       	push   $0x129
  800761:	68 3f 3d 80 00       	push   $0x803d3f
  800766:	e8 1f 03 00 00       	call   800a8a <_panic>
			panic("open %s: %e", argv[1], r);
  80076b:	83 ec 0c             	sub    $0xc,%esp
  80076e:	50                   	push   %eax
  80076f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800772:	ff 70 04             	pushl  0x4(%eax)
  800775:	68 bc 3d 80 00       	push   $0x803dbc
  80077a:	68 28 01 00 00       	push   $0x128
  80077f:	68 3f 3d 80 00       	push   $0x803d3f
  800784:	e8 01 03 00 00       	call   800a8a <_panic>
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
  8007a6:	e8 ab 02 00 00       	call   800a56 <exit>
  8007ab:	e9 94 00 00 00       	jmp    800844 <umain+0x1a9>
				cprintf("EXITING\n");
  8007b0:	83 ec 0c             	sub    $0xc,%esp
  8007b3:	68 e7 3d 80 00       	push   $0x803de7
  8007b8:	e8 c3 03 00 00       	call   800b80 <cprintf>
  8007bd:	83 c4 10             	add    $0x10,%esp
  8007c0:	eb e4                	jmp    8007a6 <umain+0x10b>
		}
		if (debug)
			cprintf("LINE: %s\n", buf);
  8007c2:	83 ec 08             	sub    $0x8,%esp
  8007c5:	53                   	push   %ebx
  8007c6:	68 f0 3d 80 00       	push   $0x803df0
  8007cb:	e8 b0 03 00 00       	call   800b80 <cprintf>
  8007d0:	83 c4 10             	add    $0x10,%esp
  8007d3:	eb 7c                	jmp    800851 <umain+0x1b6>
		if (buf[0] == '#')
			continue;
		if (echocmds)
			printf("# %s\n", buf);
  8007d5:	83 ec 08             	sub    $0x8,%esp
  8007d8:	53                   	push   %ebx
  8007d9:	68 fa 3d 80 00       	push   $0x803dfa
  8007de:	e8 37 22 00 00       	call   802a1a <printf>
  8007e3:	83 c4 10             	add    $0x10,%esp
  8007e6:	eb 78                	jmp    800860 <umain+0x1c5>
		if (debug)
			cprintf("BEFORE FORK\n");
  8007e8:	83 ec 0c             	sub    $0xc,%esp
  8007eb:	68 00 3e 80 00       	push   $0x803e00
  8007f0:	e8 8b 03 00 00       	call   800b80 <cprintf>
  8007f5:	83 c4 10             	add    $0x10,%esp
  8007f8:	eb 73                	jmp    80086d <umain+0x1d2>
		if ((r = fork()) < 0)
			panic("fork: %e", r);
  8007fa:	50                   	push   %eax
  8007fb:	68 1a 3d 80 00       	push   $0x803d1a
  800800:	68 40 01 00 00       	push   $0x140
  800805:	68 3f 3d 80 00       	push   $0x803d3f
  80080a:	e8 7b 02 00 00       	call   800a8a <_panic>
		if (debug)
			cprintf("FORK: %d\n", r);
  80080f:	83 ec 08             	sub    $0x8,%esp
  800812:	50                   	push   %eax
  800813:	68 0d 3e 80 00       	push   $0x803e0d
  800818:	e8 63 03 00 00       	call   800b80 <cprintf>
  80081d:	83 c4 10             	add    $0x10,%esp
  800820:	eb 5f                	jmp    800881 <umain+0x1e6>
		if (r == 0) {
			runcmd(buf);
			exit();
		} else
			wait(r);
  800822:	83 ec 0c             	sub    $0xc,%esp
  800825:	56                   	push   %esi
  800826:	e8 d7 2f 00 00       	call   803802 <wait>
  80082b:	83 c4 10             	add    $0x10,%esp
		buf = readline(interactive ? "$ " : NULL);
  80082e:	83 ec 0c             	sub    $0xc,%esp
  800831:	57                   	push   %edi
  800832:	e8 6f 0a 00 00       	call   8012a6 <readline>
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
  80086d:	e8 99 14 00 00       	call   801d0b <fork>
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
  80088e:	e8 c3 01 00 00       	call   800a56 <exit>
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
  8008a4:	68 89 3e 80 00       	push   $0x803e89
  8008a9:	ff 75 0c             	pushl  0xc(%ebp)
  8008ac:	e8 1e 0b 00 00       	call   8013cf <strcpy>
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
  8008ef:	e8 69 0c 00 00       	call   80155d <memmove>
		sys_cputs(buf, m);
  8008f4:	83 c4 08             	add    $0x8,%esp
  8008f7:	53                   	push   %ebx
  8008f8:	57                   	push   %edi
  8008f9:	e8 07 0e 00 00       	call   801705 <sys_cputs>
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
  800920:	e8 fe 0d 00 00       	call   801723 <sys_cgetc>
  800925:	85 c0                	test   %eax,%eax
  800927:	75 07                	jne    800930 <devcons_read+0x21>
		sys_yield();
  800929:	e8 74 0e 00 00       	call   8017a2 <sys_yield>
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
  80095c:	e8 a4 0d 00 00       	call   801705 <sys_cputs>
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
  800974:	e8 60 1a 00 00       	call   8023d9 <read>
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
  80099c:	e8 c8 17 00 00       	call   802169 <fd_lookup>
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
  8009c5:	e8 4d 17 00 00       	call   802117 <fd_alloc>
  8009ca:	83 c4 10             	add    $0x10,%esp
  8009cd:	85 c0                	test   %eax,%eax
  8009cf:	78 3a                	js     800a0b <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8009d1:	83 ec 04             	sub    $0x4,%esp
  8009d4:	68 07 04 00 00       	push   $0x407
  8009d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8009dc:	6a 00                	push   $0x0
  8009de:	e8 de 0d 00 00       	call   8017c1 <sys_page_alloc>
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
  800a03:	e8 e8 16 00 00       	call   8020f0 <fd2num>
  800a08:	83 c4 10             	add    $0x10,%esp
}
  800a0b:	c9                   	leave  
  800a0c:	c3                   	ret    

00800a0d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
  800a10:	56                   	push   %esi
  800a11:	53                   	push   %ebx
  800a12:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a15:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  800a18:	e8 66 0d 00 00       	call   801783 <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  800a1d:	25 ff 03 00 00       	and    $0x3ff,%eax
  800a22:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800a28:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800a2d:	a3 28 64 80 00       	mov    %eax,0x806428

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a32:	85 db                	test   %ebx,%ebx
  800a34:	7e 07                	jle    800a3d <libmain+0x30>
		binaryname = argv[0];
  800a36:	8b 06                	mov    (%esi),%eax
  800a38:	a3 1c 50 80 00       	mov    %eax,0x80501c

	// call user main routine
	umain(argc, argv);
  800a3d:	83 ec 08             	sub    $0x8,%esp
  800a40:	56                   	push   %esi
  800a41:	53                   	push   %ebx
  800a42:	e8 54 fc ff ff       	call   80069b <umain>

	// exit gracefully
	exit();
  800a47:	e8 0a 00 00 00       	call   800a56 <exit>
}
  800a4c:	83 c4 10             	add    $0x10,%esp
  800a4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a52:	5b                   	pop    %ebx
  800a53:	5e                   	pop    %esi
  800a54:	5d                   	pop    %ebp
  800a55:	c3                   	ret    

00800a56 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800a5c:	a1 28 64 80 00       	mov    0x806428,%eax
  800a61:	8b 40 48             	mov    0x48(%eax),%eax
  800a64:	68 ac 3e 80 00       	push   $0x803eac
  800a69:	50                   	push   %eax
  800a6a:	68 9f 3e 80 00       	push   $0x803e9f
  800a6f:	e8 0c 01 00 00       	call   800b80 <cprintf>
	close_all();
  800a74:	e8 4f 18 00 00       	call   8022c8 <close_all>
	sys_env_destroy(0);
  800a79:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800a80:	e8 bd 0c 00 00       	call   801742 <sys_env_destroy>
}
  800a85:	83 c4 10             	add    $0x10,%esp
  800a88:	c9                   	leave  
  800a89:	c3                   	ret    

00800a8a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800a8a:	55                   	push   %ebp
  800a8b:	89 e5                	mov    %esp,%ebp
  800a8d:	56                   	push   %esi
  800a8e:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800a8f:	a1 28 64 80 00       	mov    0x806428,%eax
  800a94:	8b 40 48             	mov    0x48(%eax),%eax
  800a97:	83 ec 04             	sub    $0x4,%esp
  800a9a:	68 d8 3e 80 00       	push   $0x803ed8
  800a9f:	50                   	push   %eax
  800aa0:	68 9f 3e 80 00       	push   $0x803e9f
  800aa5:	e8 d6 00 00 00       	call   800b80 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800aaa:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800aad:	8b 35 1c 50 80 00    	mov    0x80501c,%esi
  800ab3:	e8 cb 0c 00 00       	call   801783 <sys_getenvid>
  800ab8:	83 c4 04             	add    $0x4,%esp
  800abb:	ff 75 0c             	pushl  0xc(%ebp)
  800abe:	ff 75 08             	pushl  0x8(%ebp)
  800ac1:	56                   	push   %esi
  800ac2:	50                   	push   %eax
  800ac3:	68 b4 3e 80 00       	push   $0x803eb4
  800ac8:	e8 b3 00 00 00       	call   800b80 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800acd:	83 c4 18             	add    $0x18,%esp
  800ad0:	53                   	push   %ebx
  800ad1:	ff 75 10             	pushl  0x10(%ebp)
  800ad4:	e8 56 00 00 00       	call   800b2f <vcprintf>
	cprintf("\n");
  800ad9:	c7 04 24 a0 3c 80 00 	movl   $0x803ca0,(%esp)
  800ae0:	e8 9b 00 00 00       	call   800b80 <cprintf>
  800ae5:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800ae8:	cc                   	int3   
  800ae9:	eb fd                	jmp    800ae8 <_panic+0x5e>

00800aeb <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800aeb:	55                   	push   %ebp
  800aec:	89 e5                	mov    %esp,%ebp
  800aee:	53                   	push   %ebx
  800aef:	83 ec 04             	sub    $0x4,%esp
  800af2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800af5:	8b 13                	mov    (%ebx),%edx
  800af7:	8d 42 01             	lea    0x1(%edx),%eax
  800afa:	89 03                	mov    %eax,(%ebx)
  800afc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aff:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800b03:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b08:	74 09                	je     800b13 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800b0a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800b0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b11:	c9                   	leave  
  800b12:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800b13:	83 ec 08             	sub    $0x8,%esp
  800b16:	68 ff 00 00 00       	push   $0xff
  800b1b:	8d 43 08             	lea    0x8(%ebx),%eax
  800b1e:	50                   	push   %eax
  800b1f:	e8 e1 0b 00 00       	call   801705 <sys_cputs>
		b->idx = 0;
  800b24:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800b2a:	83 c4 10             	add    $0x10,%esp
  800b2d:	eb db                	jmp    800b0a <putch+0x1f>

00800b2f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800b2f:	55                   	push   %ebp
  800b30:	89 e5                	mov    %esp,%ebp
  800b32:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b38:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b3f:	00 00 00 
	b.cnt = 0;
  800b42:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b49:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800b4c:	ff 75 0c             	pushl  0xc(%ebp)
  800b4f:	ff 75 08             	pushl  0x8(%ebp)
  800b52:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b58:	50                   	push   %eax
  800b59:	68 eb 0a 80 00       	push   $0x800aeb
  800b5e:	e8 4a 01 00 00       	call   800cad <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800b63:	83 c4 08             	add    $0x8,%esp
  800b66:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800b6c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800b72:	50                   	push   %eax
  800b73:	e8 8d 0b 00 00       	call   801705 <sys_cputs>

	return b.cnt;
}
  800b78:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800b7e:	c9                   	leave  
  800b7f:	c3                   	ret    

00800b80 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800b80:	55                   	push   %ebp
  800b81:	89 e5                	mov    %esp,%ebp
  800b83:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b86:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800b89:	50                   	push   %eax
  800b8a:	ff 75 08             	pushl  0x8(%ebp)
  800b8d:	e8 9d ff ff ff       	call   800b2f <vcprintf>
	va_end(ap);

	return cnt;
}
  800b92:	c9                   	leave  
  800b93:	c3                   	ret    

00800b94 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b94:	55                   	push   %ebp
  800b95:	89 e5                	mov    %esp,%ebp
  800b97:	57                   	push   %edi
  800b98:	56                   	push   %esi
  800b99:	53                   	push   %ebx
  800b9a:	83 ec 1c             	sub    $0x1c,%esp
  800b9d:	89 c6                	mov    %eax,%esi
  800b9f:	89 d7                	mov    %edx,%edi
  800ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ba7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800baa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800bad:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb0:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800bb3:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800bb7:	74 2c                	je     800be5 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800bb9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bbc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800bc3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bc6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800bc9:	39 c2                	cmp    %eax,%edx
  800bcb:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800bce:	73 43                	jae    800c13 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800bd0:	83 eb 01             	sub    $0x1,%ebx
  800bd3:	85 db                	test   %ebx,%ebx
  800bd5:	7e 6c                	jle    800c43 <printnum+0xaf>
				putch(padc, putdat);
  800bd7:	83 ec 08             	sub    $0x8,%esp
  800bda:	57                   	push   %edi
  800bdb:	ff 75 18             	pushl  0x18(%ebp)
  800bde:	ff d6                	call   *%esi
  800be0:	83 c4 10             	add    $0x10,%esp
  800be3:	eb eb                	jmp    800bd0 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800be5:	83 ec 0c             	sub    $0xc,%esp
  800be8:	6a 20                	push   $0x20
  800bea:	6a 00                	push   $0x0
  800bec:	50                   	push   %eax
  800bed:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bf0:	ff 75 e0             	pushl  -0x20(%ebp)
  800bf3:	89 fa                	mov    %edi,%edx
  800bf5:	89 f0                	mov    %esi,%eax
  800bf7:	e8 98 ff ff ff       	call   800b94 <printnum>
		while (--width > 0)
  800bfc:	83 c4 20             	add    $0x20,%esp
  800bff:	83 eb 01             	sub    $0x1,%ebx
  800c02:	85 db                	test   %ebx,%ebx
  800c04:	7e 65                	jle    800c6b <printnum+0xd7>
			putch(padc, putdat);
  800c06:	83 ec 08             	sub    $0x8,%esp
  800c09:	57                   	push   %edi
  800c0a:	6a 20                	push   $0x20
  800c0c:	ff d6                	call   *%esi
  800c0e:	83 c4 10             	add    $0x10,%esp
  800c11:	eb ec                	jmp    800bff <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800c13:	83 ec 0c             	sub    $0xc,%esp
  800c16:	ff 75 18             	pushl  0x18(%ebp)
  800c19:	83 eb 01             	sub    $0x1,%ebx
  800c1c:	53                   	push   %ebx
  800c1d:	50                   	push   %eax
  800c1e:	83 ec 08             	sub    $0x8,%esp
  800c21:	ff 75 dc             	pushl  -0x24(%ebp)
  800c24:	ff 75 d8             	pushl  -0x28(%ebp)
  800c27:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c2a:	ff 75 e0             	pushl  -0x20(%ebp)
  800c2d:	e8 fe 2d 00 00       	call   803a30 <__udivdi3>
  800c32:	83 c4 18             	add    $0x18,%esp
  800c35:	52                   	push   %edx
  800c36:	50                   	push   %eax
  800c37:	89 fa                	mov    %edi,%edx
  800c39:	89 f0                	mov    %esi,%eax
  800c3b:	e8 54 ff ff ff       	call   800b94 <printnum>
  800c40:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800c43:	83 ec 08             	sub    $0x8,%esp
  800c46:	57                   	push   %edi
  800c47:	83 ec 04             	sub    $0x4,%esp
  800c4a:	ff 75 dc             	pushl  -0x24(%ebp)
  800c4d:	ff 75 d8             	pushl  -0x28(%ebp)
  800c50:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c53:	ff 75 e0             	pushl  -0x20(%ebp)
  800c56:	e8 e5 2e 00 00       	call   803b40 <__umoddi3>
  800c5b:	83 c4 14             	add    $0x14,%esp
  800c5e:	0f be 80 df 3e 80 00 	movsbl 0x803edf(%eax),%eax
  800c65:	50                   	push   %eax
  800c66:	ff d6                	call   *%esi
  800c68:	83 c4 10             	add    $0x10,%esp
	}
}
  800c6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c6e:	5b                   	pop    %ebx
  800c6f:	5e                   	pop    %esi
  800c70:	5f                   	pop    %edi
  800c71:	5d                   	pop    %ebp
  800c72:	c3                   	ret    

00800c73 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
  800c76:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800c79:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800c7d:	8b 10                	mov    (%eax),%edx
  800c7f:	3b 50 04             	cmp    0x4(%eax),%edx
  800c82:	73 0a                	jae    800c8e <sprintputch+0x1b>
		*b->buf++ = ch;
  800c84:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c87:	89 08                	mov    %ecx,(%eax)
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	88 02                	mov    %al,(%edx)
}
  800c8e:	5d                   	pop    %ebp
  800c8f:	c3                   	ret    

00800c90 <printfmt>:
{
  800c90:	55                   	push   %ebp
  800c91:	89 e5                	mov    %esp,%ebp
  800c93:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800c96:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800c99:	50                   	push   %eax
  800c9a:	ff 75 10             	pushl  0x10(%ebp)
  800c9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ca0:	ff 75 08             	pushl  0x8(%ebp)
  800ca3:	e8 05 00 00 00       	call   800cad <vprintfmt>
}
  800ca8:	83 c4 10             	add    $0x10,%esp
  800cab:	c9                   	leave  
  800cac:	c3                   	ret    

00800cad <vprintfmt>:
{
  800cad:	55                   	push   %ebp
  800cae:	89 e5                	mov    %esp,%ebp
  800cb0:	57                   	push   %edi
  800cb1:	56                   	push   %esi
  800cb2:	53                   	push   %ebx
  800cb3:	83 ec 3c             	sub    $0x3c,%esp
  800cb6:	8b 75 08             	mov    0x8(%ebp),%esi
  800cb9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800cbc:	8b 7d 10             	mov    0x10(%ebp),%edi
  800cbf:	e9 32 04 00 00       	jmp    8010f6 <vprintfmt+0x449>
		padc = ' ';
  800cc4:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800cc8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800ccf:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800cd6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800cdd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800ce4:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800ceb:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800cf0:	8d 47 01             	lea    0x1(%edi),%eax
  800cf3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cf6:	0f b6 17             	movzbl (%edi),%edx
  800cf9:	8d 42 dd             	lea    -0x23(%edx),%eax
  800cfc:	3c 55                	cmp    $0x55,%al
  800cfe:	0f 87 12 05 00 00    	ja     801216 <vprintfmt+0x569>
  800d04:	0f b6 c0             	movzbl %al,%eax
  800d07:	ff 24 85 c0 40 80 00 	jmp    *0x8040c0(,%eax,4)
  800d0e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800d11:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800d15:	eb d9                	jmp    800cf0 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800d17:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800d1a:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800d1e:	eb d0                	jmp    800cf0 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800d20:	0f b6 d2             	movzbl %dl,%edx
  800d23:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800d26:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2b:	89 75 08             	mov    %esi,0x8(%ebp)
  800d2e:	eb 03                	jmp    800d33 <vprintfmt+0x86>
  800d30:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800d33:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800d36:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800d3a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800d3d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d40:	83 fe 09             	cmp    $0x9,%esi
  800d43:	76 eb                	jbe    800d30 <vprintfmt+0x83>
  800d45:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d48:	8b 75 08             	mov    0x8(%ebp),%esi
  800d4b:	eb 14                	jmp    800d61 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800d4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d50:	8b 00                	mov    (%eax),%eax
  800d52:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d55:	8b 45 14             	mov    0x14(%ebp),%eax
  800d58:	8d 40 04             	lea    0x4(%eax),%eax
  800d5b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800d5e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800d61:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d65:	79 89                	jns    800cf0 <vprintfmt+0x43>
				width = precision, precision = -1;
  800d67:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d6a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800d6d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800d74:	e9 77 ff ff ff       	jmp    800cf0 <vprintfmt+0x43>
  800d79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d7c:	85 c0                	test   %eax,%eax
  800d7e:	0f 48 c1             	cmovs  %ecx,%eax
  800d81:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800d84:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800d87:	e9 64 ff ff ff       	jmp    800cf0 <vprintfmt+0x43>
  800d8c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800d8f:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800d96:	e9 55 ff ff ff       	jmp    800cf0 <vprintfmt+0x43>
			lflag++;
  800d9b:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800d9f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800da2:	e9 49 ff ff ff       	jmp    800cf0 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800da7:	8b 45 14             	mov    0x14(%ebp),%eax
  800daa:	8d 78 04             	lea    0x4(%eax),%edi
  800dad:	83 ec 08             	sub    $0x8,%esp
  800db0:	53                   	push   %ebx
  800db1:	ff 30                	pushl  (%eax)
  800db3:	ff d6                	call   *%esi
			break;
  800db5:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800db8:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800dbb:	e9 33 03 00 00       	jmp    8010f3 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800dc0:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc3:	8d 78 04             	lea    0x4(%eax),%edi
  800dc6:	8b 00                	mov    (%eax),%eax
  800dc8:	99                   	cltd   
  800dc9:	31 d0                	xor    %edx,%eax
  800dcb:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800dcd:	83 f8 11             	cmp    $0x11,%eax
  800dd0:	7f 23                	jg     800df5 <vprintfmt+0x148>
  800dd2:	8b 14 85 20 42 80 00 	mov    0x804220(,%eax,4),%edx
  800dd9:	85 d2                	test   %edx,%edx
  800ddb:	74 18                	je     800df5 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800ddd:	52                   	push   %edx
  800dde:	68 e1 3d 80 00       	push   $0x803de1
  800de3:	53                   	push   %ebx
  800de4:	56                   	push   %esi
  800de5:	e8 a6 fe ff ff       	call   800c90 <printfmt>
  800dea:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800ded:	89 7d 14             	mov    %edi,0x14(%ebp)
  800df0:	e9 fe 02 00 00       	jmp    8010f3 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800df5:	50                   	push   %eax
  800df6:	68 f7 3e 80 00       	push   $0x803ef7
  800dfb:	53                   	push   %ebx
  800dfc:	56                   	push   %esi
  800dfd:	e8 8e fe ff ff       	call   800c90 <printfmt>
  800e02:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800e05:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800e08:	e9 e6 02 00 00       	jmp    8010f3 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800e0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e10:	83 c0 04             	add    $0x4,%eax
  800e13:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800e16:	8b 45 14             	mov    0x14(%ebp),%eax
  800e19:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800e1b:	85 c9                	test   %ecx,%ecx
  800e1d:	b8 f0 3e 80 00       	mov    $0x803ef0,%eax
  800e22:	0f 45 c1             	cmovne %ecx,%eax
  800e25:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800e28:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e2c:	7e 06                	jle    800e34 <vprintfmt+0x187>
  800e2e:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800e32:	75 0d                	jne    800e41 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e34:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800e37:	89 c7                	mov    %eax,%edi
  800e39:	03 45 e0             	add    -0x20(%ebp),%eax
  800e3c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800e3f:	eb 53                	jmp    800e94 <vprintfmt+0x1e7>
  800e41:	83 ec 08             	sub    $0x8,%esp
  800e44:	ff 75 d8             	pushl  -0x28(%ebp)
  800e47:	50                   	push   %eax
  800e48:	e8 61 05 00 00       	call   8013ae <strnlen>
  800e4d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800e50:	29 c1                	sub    %eax,%ecx
  800e52:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800e55:	83 c4 10             	add    $0x10,%esp
  800e58:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800e5a:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800e5e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800e61:	eb 0f                	jmp    800e72 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800e63:	83 ec 08             	sub    $0x8,%esp
  800e66:	53                   	push   %ebx
  800e67:	ff 75 e0             	pushl  -0x20(%ebp)
  800e6a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800e6c:	83 ef 01             	sub    $0x1,%edi
  800e6f:	83 c4 10             	add    $0x10,%esp
  800e72:	85 ff                	test   %edi,%edi
  800e74:	7f ed                	jg     800e63 <vprintfmt+0x1b6>
  800e76:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800e79:	85 c9                	test   %ecx,%ecx
  800e7b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e80:	0f 49 c1             	cmovns %ecx,%eax
  800e83:	29 c1                	sub    %eax,%ecx
  800e85:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800e88:	eb aa                	jmp    800e34 <vprintfmt+0x187>
					putch(ch, putdat);
  800e8a:	83 ec 08             	sub    $0x8,%esp
  800e8d:	53                   	push   %ebx
  800e8e:	52                   	push   %edx
  800e8f:	ff d6                	call   *%esi
  800e91:	83 c4 10             	add    $0x10,%esp
  800e94:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800e97:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e99:	83 c7 01             	add    $0x1,%edi
  800e9c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800ea0:	0f be d0             	movsbl %al,%edx
  800ea3:	85 d2                	test   %edx,%edx
  800ea5:	74 4b                	je     800ef2 <vprintfmt+0x245>
  800ea7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800eab:	78 06                	js     800eb3 <vprintfmt+0x206>
  800ead:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800eb1:	78 1e                	js     800ed1 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800eb3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800eb7:	74 d1                	je     800e8a <vprintfmt+0x1dd>
  800eb9:	0f be c0             	movsbl %al,%eax
  800ebc:	83 e8 20             	sub    $0x20,%eax
  800ebf:	83 f8 5e             	cmp    $0x5e,%eax
  800ec2:	76 c6                	jbe    800e8a <vprintfmt+0x1dd>
					putch('?', putdat);
  800ec4:	83 ec 08             	sub    $0x8,%esp
  800ec7:	53                   	push   %ebx
  800ec8:	6a 3f                	push   $0x3f
  800eca:	ff d6                	call   *%esi
  800ecc:	83 c4 10             	add    $0x10,%esp
  800ecf:	eb c3                	jmp    800e94 <vprintfmt+0x1e7>
  800ed1:	89 cf                	mov    %ecx,%edi
  800ed3:	eb 0e                	jmp    800ee3 <vprintfmt+0x236>
				putch(' ', putdat);
  800ed5:	83 ec 08             	sub    $0x8,%esp
  800ed8:	53                   	push   %ebx
  800ed9:	6a 20                	push   $0x20
  800edb:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800edd:	83 ef 01             	sub    $0x1,%edi
  800ee0:	83 c4 10             	add    $0x10,%esp
  800ee3:	85 ff                	test   %edi,%edi
  800ee5:	7f ee                	jg     800ed5 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800ee7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800eea:	89 45 14             	mov    %eax,0x14(%ebp)
  800eed:	e9 01 02 00 00       	jmp    8010f3 <vprintfmt+0x446>
  800ef2:	89 cf                	mov    %ecx,%edi
  800ef4:	eb ed                	jmp    800ee3 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800ef6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800ef9:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800f00:	e9 eb fd ff ff       	jmp    800cf0 <vprintfmt+0x43>
	if (lflag >= 2)
  800f05:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800f09:	7f 21                	jg     800f2c <vprintfmt+0x27f>
	else if (lflag)
  800f0b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800f0f:	74 68                	je     800f79 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800f11:	8b 45 14             	mov    0x14(%ebp),%eax
  800f14:	8b 00                	mov    (%eax),%eax
  800f16:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800f19:	89 c1                	mov    %eax,%ecx
  800f1b:	c1 f9 1f             	sar    $0x1f,%ecx
  800f1e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800f21:	8b 45 14             	mov    0x14(%ebp),%eax
  800f24:	8d 40 04             	lea    0x4(%eax),%eax
  800f27:	89 45 14             	mov    %eax,0x14(%ebp)
  800f2a:	eb 17                	jmp    800f43 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800f2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f2f:	8b 50 04             	mov    0x4(%eax),%edx
  800f32:	8b 00                	mov    (%eax),%eax
  800f34:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800f37:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800f3a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3d:	8d 40 08             	lea    0x8(%eax),%eax
  800f40:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800f43:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800f46:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800f49:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f4c:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800f4f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800f53:	78 3f                	js     800f94 <vprintfmt+0x2e7>
			base = 10;
  800f55:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800f5a:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800f5e:	0f 84 71 01 00 00    	je     8010d5 <vprintfmt+0x428>
				putch('+', putdat);
  800f64:	83 ec 08             	sub    $0x8,%esp
  800f67:	53                   	push   %ebx
  800f68:	6a 2b                	push   $0x2b
  800f6a:	ff d6                	call   *%esi
  800f6c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800f6f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f74:	e9 5c 01 00 00       	jmp    8010d5 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800f79:	8b 45 14             	mov    0x14(%ebp),%eax
  800f7c:	8b 00                	mov    (%eax),%eax
  800f7e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800f81:	89 c1                	mov    %eax,%ecx
  800f83:	c1 f9 1f             	sar    $0x1f,%ecx
  800f86:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800f89:	8b 45 14             	mov    0x14(%ebp),%eax
  800f8c:	8d 40 04             	lea    0x4(%eax),%eax
  800f8f:	89 45 14             	mov    %eax,0x14(%ebp)
  800f92:	eb af                	jmp    800f43 <vprintfmt+0x296>
				putch('-', putdat);
  800f94:	83 ec 08             	sub    $0x8,%esp
  800f97:	53                   	push   %ebx
  800f98:	6a 2d                	push   $0x2d
  800f9a:	ff d6                	call   *%esi
				num = -(long long) num;
  800f9c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800f9f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800fa2:	f7 d8                	neg    %eax
  800fa4:	83 d2 00             	adc    $0x0,%edx
  800fa7:	f7 da                	neg    %edx
  800fa9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800fac:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800faf:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800fb2:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fb7:	e9 19 01 00 00       	jmp    8010d5 <vprintfmt+0x428>
	if (lflag >= 2)
  800fbc:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800fc0:	7f 29                	jg     800feb <vprintfmt+0x33e>
	else if (lflag)
  800fc2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800fc6:	74 44                	je     80100c <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800fc8:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcb:	8b 00                	mov    (%eax),%eax
  800fcd:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800fd5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800fd8:	8b 45 14             	mov    0x14(%ebp),%eax
  800fdb:	8d 40 04             	lea    0x4(%eax),%eax
  800fde:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800fe1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fe6:	e9 ea 00 00 00       	jmp    8010d5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800feb:	8b 45 14             	mov    0x14(%ebp),%eax
  800fee:	8b 50 04             	mov    0x4(%eax),%edx
  800ff1:	8b 00                	mov    (%eax),%eax
  800ff3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ff6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ff9:	8b 45 14             	mov    0x14(%ebp),%eax
  800ffc:	8d 40 08             	lea    0x8(%eax),%eax
  800fff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801002:	b8 0a 00 00 00       	mov    $0xa,%eax
  801007:	e9 c9 00 00 00       	jmp    8010d5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80100c:	8b 45 14             	mov    0x14(%ebp),%eax
  80100f:	8b 00                	mov    (%eax),%eax
  801011:	ba 00 00 00 00       	mov    $0x0,%edx
  801016:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801019:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80101c:	8b 45 14             	mov    0x14(%ebp),%eax
  80101f:	8d 40 04             	lea    0x4(%eax),%eax
  801022:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801025:	b8 0a 00 00 00       	mov    $0xa,%eax
  80102a:	e9 a6 00 00 00       	jmp    8010d5 <vprintfmt+0x428>
			putch('0', putdat);
  80102f:	83 ec 08             	sub    $0x8,%esp
  801032:	53                   	push   %ebx
  801033:	6a 30                	push   $0x30
  801035:	ff d6                	call   *%esi
	if (lflag >= 2)
  801037:	83 c4 10             	add    $0x10,%esp
  80103a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80103e:	7f 26                	jg     801066 <vprintfmt+0x3b9>
	else if (lflag)
  801040:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  801044:	74 3e                	je     801084 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  801046:	8b 45 14             	mov    0x14(%ebp),%eax
  801049:	8b 00                	mov    (%eax),%eax
  80104b:	ba 00 00 00 00       	mov    $0x0,%edx
  801050:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801053:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801056:	8b 45 14             	mov    0x14(%ebp),%eax
  801059:	8d 40 04             	lea    0x4(%eax),%eax
  80105c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80105f:	b8 08 00 00 00       	mov    $0x8,%eax
  801064:	eb 6f                	jmp    8010d5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  801066:	8b 45 14             	mov    0x14(%ebp),%eax
  801069:	8b 50 04             	mov    0x4(%eax),%edx
  80106c:	8b 00                	mov    (%eax),%eax
  80106e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801071:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801074:	8b 45 14             	mov    0x14(%ebp),%eax
  801077:	8d 40 08             	lea    0x8(%eax),%eax
  80107a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80107d:	b8 08 00 00 00       	mov    $0x8,%eax
  801082:	eb 51                	jmp    8010d5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  801084:	8b 45 14             	mov    0x14(%ebp),%eax
  801087:	8b 00                	mov    (%eax),%eax
  801089:	ba 00 00 00 00       	mov    $0x0,%edx
  80108e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801091:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801094:	8b 45 14             	mov    0x14(%ebp),%eax
  801097:	8d 40 04             	lea    0x4(%eax),%eax
  80109a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80109d:	b8 08 00 00 00       	mov    $0x8,%eax
  8010a2:	eb 31                	jmp    8010d5 <vprintfmt+0x428>
			putch('0', putdat);
  8010a4:	83 ec 08             	sub    $0x8,%esp
  8010a7:	53                   	push   %ebx
  8010a8:	6a 30                	push   $0x30
  8010aa:	ff d6                	call   *%esi
			putch('x', putdat);
  8010ac:	83 c4 08             	add    $0x8,%esp
  8010af:	53                   	push   %ebx
  8010b0:	6a 78                	push   $0x78
  8010b2:	ff d6                	call   *%esi
			num = (unsigned long long)
  8010b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b7:	8b 00                	mov    (%eax),%eax
  8010b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8010be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8010c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8010c4:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8010c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ca:	8d 40 04             	lea    0x4(%eax),%eax
  8010cd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8010d0:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8010d5:	83 ec 0c             	sub    $0xc,%esp
  8010d8:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8010dc:	52                   	push   %edx
  8010dd:	ff 75 e0             	pushl  -0x20(%ebp)
  8010e0:	50                   	push   %eax
  8010e1:	ff 75 dc             	pushl  -0x24(%ebp)
  8010e4:	ff 75 d8             	pushl  -0x28(%ebp)
  8010e7:	89 da                	mov    %ebx,%edx
  8010e9:	89 f0                	mov    %esi,%eax
  8010eb:	e8 a4 fa ff ff       	call   800b94 <printnum>
			break;
  8010f0:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8010f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010f6:	83 c7 01             	add    $0x1,%edi
  8010f9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8010fd:	83 f8 25             	cmp    $0x25,%eax
  801100:	0f 84 be fb ff ff    	je     800cc4 <vprintfmt+0x17>
			if (ch == '\0')
  801106:	85 c0                	test   %eax,%eax
  801108:	0f 84 28 01 00 00    	je     801236 <vprintfmt+0x589>
			putch(ch, putdat);
  80110e:	83 ec 08             	sub    $0x8,%esp
  801111:	53                   	push   %ebx
  801112:	50                   	push   %eax
  801113:	ff d6                	call   *%esi
  801115:	83 c4 10             	add    $0x10,%esp
  801118:	eb dc                	jmp    8010f6 <vprintfmt+0x449>
	if (lflag >= 2)
  80111a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80111e:	7f 26                	jg     801146 <vprintfmt+0x499>
	else if (lflag)
  801120:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  801124:	74 41                	je     801167 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  801126:	8b 45 14             	mov    0x14(%ebp),%eax
  801129:	8b 00                	mov    (%eax),%eax
  80112b:	ba 00 00 00 00       	mov    $0x0,%edx
  801130:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801133:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801136:	8b 45 14             	mov    0x14(%ebp),%eax
  801139:	8d 40 04             	lea    0x4(%eax),%eax
  80113c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80113f:	b8 10 00 00 00       	mov    $0x10,%eax
  801144:	eb 8f                	jmp    8010d5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  801146:	8b 45 14             	mov    0x14(%ebp),%eax
  801149:	8b 50 04             	mov    0x4(%eax),%edx
  80114c:	8b 00                	mov    (%eax),%eax
  80114e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801151:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801154:	8b 45 14             	mov    0x14(%ebp),%eax
  801157:	8d 40 08             	lea    0x8(%eax),%eax
  80115a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80115d:	b8 10 00 00 00       	mov    $0x10,%eax
  801162:	e9 6e ff ff ff       	jmp    8010d5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  801167:	8b 45 14             	mov    0x14(%ebp),%eax
  80116a:	8b 00                	mov    (%eax),%eax
  80116c:	ba 00 00 00 00       	mov    $0x0,%edx
  801171:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801174:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801177:	8b 45 14             	mov    0x14(%ebp),%eax
  80117a:	8d 40 04             	lea    0x4(%eax),%eax
  80117d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801180:	b8 10 00 00 00       	mov    $0x10,%eax
  801185:	e9 4b ff ff ff       	jmp    8010d5 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80118a:	8b 45 14             	mov    0x14(%ebp),%eax
  80118d:	83 c0 04             	add    $0x4,%eax
  801190:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801193:	8b 45 14             	mov    0x14(%ebp),%eax
  801196:	8b 00                	mov    (%eax),%eax
  801198:	85 c0                	test   %eax,%eax
  80119a:	74 14                	je     8011b0 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80119c:	8b 13                	mov    (%ebx),%edx
  80119e:	83 fa 7f             	cmp    $0x7f,%edx
  8011a1:	7f 37                	jg     8011da <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8011a3:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8011a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8011a8:	89 45 14             	mov    %eax,0x14(%ebp)
  8011ab:	e9 43 ff ff ff       	jmp    8010f3 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8011b0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011b5:	bf 15 40 80 00       	mov    $0x804015,%edi
							putch(ch, putdat);
  8011ba:	83 ec 08             	sub    $0x8,%esp
  8011bd:	53                   	push   %ebx
  8011be:	50                   	push   %eax
  8011bf:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8011c1:	83 c7 01             	add    $0x1,%edi
  8011c4:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8011c8:	83 c4 10             	add    $0x10,%esp
  8011cb:	85 c0                	test   %eax,%eax
  8011cd:	75 eb                	jne    8011ba <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8011cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8011d2:	89 45 14             	mov    %eax,0x14(%ebp)
  8011d5:	e9 19 ff ff ff       	jmp    8010f3 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8011da:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8011dc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011e1:	bf 4d 40 80 00       	mov    $0x80404d,%edi
							putch(ch, putdat);
  8011e6:	83 ec 08             	sub    $0x8,%esp
  8011e9:	53                   	push   %ebx
  8011ea:	50                   	push   %eax
  8011eb:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8011ed:	83 c7 01             	add    $0x1,%edi
  8011f0:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8011f4:	83 c4 10             	add    $0x10,%esp
  8011f7:	85 c0                	test   %eax,%eax
  8011f9:	75 eb                	jne    8011e6 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8011fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8011fe:	89 45 14             	mov    %eax,0x14(%ebp)
  801201:	e9 ed fe ff ff       	jmp    8010f3 <vprintfmt+0x446>
			putch(ch, putdat);
  801206:	83 ec 08             	sub    $0x8,%esp
  801209:	53                   	push   %ebx
  80120a:	6a 25                	push   $0x25
  80120c:	ff d6                	call   *%esi
			break;
  80120e:	83 c4 10             	add    $0x10,%esp
  801211:	e9 dd fe ff ff       	jmp    8010f3 <vprintfmt+0x446>
			putch('%', putdat);
  801216:	83 ec 08             	sub    $0x8,%esp
  801219:	53                   	push   %ebx
  80121a:	6a 25                	push   $0x25
  80121c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80121e:	83 c4 10             	add    $0x10,%esp
  801221:	89 f8                	mov    %edi,%eax
  801223:	eb 03                	jmp    801228 <vprintfmt+0x57b>
  801225:	83 e8 01             	sub    $0x1,%eax
  801228:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80122c:	75 f7                	jne    801225 <vprintfmt+0x578>
  80122e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801231:	e9 bd fe ff ff       	jmp    8010f3 <vprintfmt+0x446>
}
  801236:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801239:	5b                   	pop    %ebx
  80123a:	5e                   	pop    %esi
  80123b:	5f                   	pop    %edi
  80123c:	5d                   	pop    %ebp
  80123d:	c3                   	ret    

0080123e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80123e:	55                   	push   %ebp
  80123f:	89 e5                	mov    %esp,%ebp
  801241:	83 ec 18             	sub    $0x18,%esp
  801244:	8b 45 08             	mov    0x8(%ebp),%eax
  801247:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80124a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80124d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801251:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801254:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80125b:	85 c0                	test   %eax,%eax
  80125d:	74 26                	je     801285 <vsnprintf+0x47>
  80125f:	85 d2                	test   %edx,%edx
  801261:	7e 22                	jle    801285 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801263:	ff 75 14             	pushl  0x14(%ebp)
  801266:	ff 75 10             	pushl  0x10(%ebp)
  801269:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80126c:	50                   	push   %eax
  80126d:	68 73 0c 80 00       	push   $0x800c73
  801272:	e8 36 fa ff ff       	call   800cad <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801277:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80127a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80127d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801280:	83 c4 10             	add    $0x10,%esp
}
  801283:	c9                   	leave  
  801284:	c3                   	ret    
		return -E_INVAL;
  801285:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80128a:	eb f7                	jmp    801283 <vsnprintf+0x45>

0080128c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80128c:	55                   	push   %ebp
  80128d:	89 e5                	mov    %esp,%ebp
  80128f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801292:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801295:	50                   	push   %eax
  801296:	ff 75 10             	pushl  0x10(%ebp)
  801299:	ff 75 0c             	pushl  0xc(%ebp)
  80129c:	ff 75 08             	pushl  0x8(%ebp)
  80129f:	e8 9a ff ff ff       	call   80123e <vsnprintf>
	va_end(ap);

	return rc;
}
  8012a4:	c9                   	leave  
  8012a5:	c3                   	ret    

008012a6 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  8012a6:	55                   	push   %ebp
  8012a7:	89 e5                	mov    %esp,%ebp
  8012a9:	57                   	push   %edi
  8012aa:	56                   	push   %esi
  8012ab:	53                   	push   %ebx
  8012ac:	83 ec 0c             	sub    $0xc,%esp
  8012af:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  8012b2:	85 c0                	test   %eax,%eax
  8012b4:	74 13                	je     8012c9 <readline+0x23>
		fprintf(1, "%s", prompt);
  8012b6:	83 ec 04             	sub    $0x4,%esp
  8012b9:	50                   	push   %eax
  8012ba:	68 e1 3d 80 00       	push   $0x803de1
  8012bf:	6a 01                	push   $0x1
  8012c1:	e8 3d 17 00 00       	call   802a03 <fprintf>
  8012c6:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
  8012c9:	83 ec 0c             	sub    $0xc,%esp
  8012cc:	6a 00                	push   $0x0
  8012ce:	e8 bc f6 ff ff       	call   80098f <iscons>
  8012d3:	89 c7                	mov    %eax,%edi
  8012d5:	83 c4 10             	add    $0x10,%esp
	i = 0;
  8012d8:	be 00 00 00 00       	mov    $0x0,%esi
  8012dd:	eb 57                	jmp    801336 <readline+0x90>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  8012df:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
  8012e4:	83 fb f8             	cmp    $0xfffffff8,%ebx
  8012e7:	75 08                	jne    8012f1 <readline+0x4b>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
  8012e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012ec:	5b                   	pop    %ebx
  8012ed:	5e                   	pop    %esi
  8012ee:	5f                   	pop    %edi
  8012ef:	5d                   	pop    %ebp
  8012f0:	c3                   	ret    
				cprintf("read error: %e\n", c);
  8012f1:	83 ec 08             	sub    $0x8,%esp
  8012f4:	53                   	push   %ebx
  8012f5:	68 68 42 80 00       	push   $0x804268
  8012fa:	e8 81 f8 ff ff       	call   800b80 <cprintf>
  8012ff:	83 c4 10             	add    $0x10,%esp
			return NULL;
  801302:	b8 00 00 00 00       	mov    $0x0,%eax
  801307:	eb e0                	jmp    8012e9 <readline+0x43>
			if (echoing)
  801309:	85 ff                	test   %edi,%edi
  80130b:	75 05                	jne    801312 <readline+0x6c>
			i--;
  80130d:	83 ee 01             	sub    $0x1,%esi
  801310:	eb 24                	jmp    801336 <readline+0x90>
				cputchar('\b');
  801312:	83 ec 0c             	sub    $0xc,%esp
  801315:	6a 08                	push   $0x8
  801317:	e8 2e f6 ff ff       	call   80094a <cputchar>
  80131c:	83 c4 10             	add    $0x10,%esp
  80131f:	eb ec                	jmp    80130d <readline+0x67>
				cputchar(c);
  801321:	83 ec 0c             	sub    $0xc,%esp
  801324:	53                   	push   %ebx
  801325:	e8 20 f6 ff ff       	call   80094a <cputchar>
  80132a:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80132d:	88 9e 20 60 80 00    	mov    %bl,0x806020(%esi)
  801333:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
  801336:	e8 2b f6 ff ff       	call   800966 <getchar>
  80133b:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  80133d:	85 c0                	test   %eax,%eax
  80133f:	78 9e                	js     8012df <readline+0x39>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  801341:	83 f8 08             	cmp    $0x8,%eax
  801344:	0f 94 c2             	sete   %dl
  801347:	83 f8 7f             	cmp    $0x7f,%eax
  80134a:	0f 94 c0             	sete   %al
  80134d:	08 c2                	or     %al,%dl
  80134f:	74 04                	je     801355 <readline+0xaf>
  801351:	85 f6                	test   %esi,%esi
  801353:	7f b4                	jg     801309 <readline+0x63>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801355:	83 fb 1f             	cmp    $0x1f,%ebx
  801358:	7e 0e                	jle    801368 <readline+0xc2>
  80135a:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  801360:	7f 06                	jg     801368 <readline+0xc2>
			if (echoing)
  801362:	85 ff                	test   %edi,%edi
  801364:	74 c7                	je     80132d <readline+0x87>
  801366:	eb b9                	jmp    801321 <readline+0x7b>
		} else if (c == '\n' || c == '\r') {
  801368:	83 fb 0a             	cmp    $0xa,%ebx
  80136b:	74 05                	je     801372 <readline+0xcc>
  80136d:	83 fb 0d             	cmp    $0xd,%ebx
  801370:	75 c4                	jne    801336 <readline+0x90>
			if (echoing)
  801372:	85 ff                	test   %edi,%edi
  801374:	75 11                	jne    801387 <readline+0xe1>
			buf[i] = 0;
  801376:	c6 86 20 60 80 00 00 	movb   $0x0,0x806020(%esi)
			return buf;
  80137d:	b8 20 60 80 00       	mov    $0x806020,%eax
  801382:	e9 62 ff ff ff       	jmp    8012e9 <readline+0x43>
				cputchar('\n');
  801387:	83 ec 0c             	sub    $0xc,%esp
  80138a:	6a 0a                	push   $0xa
  80138c:	e8 b9 f5 ff ff       	call   80094a <cputchar>
  801391:	83 c4 10             	add    $0x10,%esp
  801394:	eb e0                	jmp    801376 <readline+0xd0>

00801396 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801396:	55                   	push   %ebp
  801397:	89 e5                	mov    %esp,%ebp
  801399:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80139c:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a1:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8013a5:	74 05                	je     8013ac <strlen+0x16>
		n++;
  8013a7:	83 c0 01             	add    $0x1,%eax
  8013aa:	eb f5                	jmp    8013a1 <strlen+0xb>
	return n;
}
  8013ac:	5d                   	pop    %ebp
  8013ad:	c3                   	ret    

008013ae <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8013ae:	55                   	push   %ebp
  8013af:	89 e5                	mov    %esp,%ebp
  8013b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013b4:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8013bc:	39 c2                	cmp    %eax,%edx
  8013be:	74 0d                	je     8013cd <strnlen+0x1f>
  8013c0:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8013c4:	74 05                	je     8013cb <strnlen+0x1d>
		n++;
  8013c6:	83 c2 01             	add    $0x1,%edx
  8013c9:	eb f1                	jmp    8013bc <strnlen+0xe>
  8013cb:	89 d0                	mov    %edx,%eax
	return n;
}
  8013cd:	5d                   	pop    %ebp
  8013ce:	c3                   	ret    

008013cf <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013cf:	55                   	push   %ebp
  8013d0:	89 e5                	mov    %esp,%ebp
  8013d2:	53                   	push   %ebx
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8013d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8013de:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8013e2:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8013e5:	83 c2 01             	add    $0x1,%edx
  8013e8:	84 c9                	test   %cl,%cl
  8013ea:	75 f2                	jne    8013de <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8013ec:	5b                   	pop    %ebx
  8013ed:	5d                   	pop    %ebp
  8013ee:	c3                   	ret    

008013ef <strcat>:

char *
strcat(char *dst, const char *src)
{
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
  8013f2:	53                   	push   %ebx
  8013f3:	83 ec 10             	sub    $0x10,%esp
  8013f6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8013f9:	53                   	push   %ebx
  8013fa:	e8 97 ff ff ff       	call   801396 <strlen>
  8013ff:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801402:	ff 75 0c             	pushl  0xc(%ebp)
  801405:	01 d8                	add    %ebx,%eax
  801407:	50                   	push   %eax
  801408:	e8 c2 ff ff ff       	call   8013cf <strcpy>
	return dst;
}
  80140d:	89 d8                	mov    %ebx,%eax
  80140f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801412:	c9                   	leave  
  801413:	c3                   	ret    

00801414 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801414:	55                   	push   %ebp
  801415:	89 e5                	mov    %esp,%ebp
  801417:	56                   	push   %esi
  801418:	53                   	push   %ebx
  801419:	8b 45 08             	mov    0x8(%ebp),%eax
  80141c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80141f:	89 c6                	mov    %eax,%esi
  801421:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801424:	89 c2                	mov    %eax,%edx
  801426:	39 f2                	cmp    %esi,%edx
  801428:	74 11                	je     80143b <strncpy+0x27>
		*dst++ = *src;
  80142a:	83 c2 01             	add    $0x1,%edx
  80142d:	0f b6 19             	movzbl (%ecx),%ebx
  801430:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801433:	80 fb 01             	cmp    $0x1,%bl
  801436:	83 d9 ff             	sbb    $0xffffffff,%ecx
  801439:	eb eb                	jmp    801426 <strncpy+0x12>
	}
	return ret;
}
  80143b:	5b                   	pop    %ebx
  80143c:	5e                   	pop    %esi
  80143d:	5d                   	pop    %ebp
  80143e:	c3                   	ret    

0080143f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80143f:	55                   	push   %ebp
  801440:	89 e5                	mov    %esp,%ebp
  801442:	56                   	push   %esi
  801443:	53                   	push   %ebx
  801444:	8b 75 08             	mov    0x8(%ebp),%esi
  801447:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80144a:	8b 55 10             	mov    0x10(%ebp),%edx
  80144d:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80144f:	85 d2                	test   %edx,%edx
  801451:	74 21                	je     801474 <strlcpy+0x35>
  801453:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801457:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801459:	39 c2                	cmp    %eax,%edx
  80145b:	74 14                	je     801471 <strlcpy+0x32>
  80145d:	0f b6 19             	movzbl (%ecx),%ebx
  801460:	84 db                	test   %bl,%bl
  801462:	74 0b                	je     80146f <strlcpy+0x30>
			*dst++ = *src++;
  801464:	83 c1 01             	add    $0x1,%ecx
  801467:	83 c2 01             	add    $0x1,%edx
  80146a:	88 5a ff             	mov    %bl,-0x1(%edx)
  80146d:	eb ea                	jmp    801459 <strlcpy+0x1a>
  80146f:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801471:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801474:	29 f0                	sub    %esi,%eax
}
  801476:	5b                   	pop    %ebx
  801477:	5e                   	pop    %esi
  801478:	5d                   	pop    %ebp
  801479:	c3                   	ret    

0080147a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80147a:	55                   	push   %ebp
  80147b:	89 e5                	mov    %esp,%ebp
  80147d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801480:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801483:	0f b6 01             	movzbl (%ecx),%eax
  801486:	84 c0                	test   %al,%al
  801488:	74 0c                	je     801496 <strcmp+0x1c>
  80148a:	3a 02                	cmp    (%edx),%al
  80148c:	75 08                	jne    801496 <strcmp+0x1c>
		p++, q++;
  80148e:	83 c1 01             	add    $0x1,%ecx
  801491:	83 c2 01             	add    $0x1,%edx
  801494:	eb ed                	jmp    801483 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801496:	0f b6 c0             	movzbl %al,%eax
  801499:	0f b6 12             	movzbl (%edx),%edx
  80149c:	29 d0                	sub    %edx,%eax
}
  80149e:	5d                   	pop    %ebp
  80149f:	c3                   	ret    

008014a0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8014a0:	55                   	push   %ebp
  8014a1:	89 e5                	mov    %esp,%ebp
  8014a3:	53                   	push   %ebx
  8014a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014aa:	89 c3                	mov    %eax,%ebx
  8014ac:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8014af:	eb 06                	jmp    8014b7 <strncmp+0x17>
		n--, p++, q++;
  8014b1:	83 c0 01             	add    $0x1,%eax
  8014b4:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8014b7:	39 d8                	cmp    %ebx,%eax
  8014b9:	74 16                	je     8014d1 <strncmp+0x31>
  8014bb:	0f b6 08             	movzbl (%eax),%ecx
  8014be:	84 c9                	test   %cl,%cl
  8014c0:	74 04                	je     8014c6 <strncmp+0x26>
  8014c2:	3a 0a                	cmp    (%edx),%cl
  8014c4:	74 eb                	je     8014b1 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014c6:	0f b6 00             	movzbl (%eax),%eax
  8014c9:	0f b6 12             	movzbl (%edx),%edx
  8014cc:	29 d0                	sub    %edx,%eax
}
  8014ce:	5b                   	pop    %ebx
  8014cf:	5d                   	pop    %ebp
  8014d0:	c3                   	ret    
		return 0;
  8014d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d6:	eb f6                	jmp    8014ce <strncmp+0x2e>

008014d8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014d8:	55                   	push   %ebp
  8014d9:	89 e5                	mov    %esp,%ebp
  8014db:	8b 45 08             	mov    0x8(%ebp),%eax
  8014de:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8014e2:	0f b6 10             	movzbl (%eax),%edx
  8014e5:	84 d2                	test   %dl,%dl
  8014e7:	74 09                	je     8014f2 <strchr+0x1a>
		if (*s == c)
  8014e9:	38 ca                	cmp    %cl,%dl
  8014eb:	74 0a                	je     8014f7 <strchr+0x1f>
	for (; *s; s++)
  8014ed:	83 c0 01             	add    $0x1,%eax
  8014f0:	eb f0                	jmp    8014e2 <strchr+0xa>
			return (char *) s;
	return 0;
  8014f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014f7:	5d                   	pop    %ebp
  8014f8:	c3                   	ret    

008014f9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
  8014fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ff:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801503:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801506:	38 ca                	cmp    %cl,%dl
  801508:	74 09                	je     801513 <strfind+0x1a>
  80150a:	84 d2                	test   %dl,%dl
  80150c:	74 05                	je     801513 <strfind+0x1a>
	for (; *s; s++)
  80150e:	83 c0 01             	add    $0x1,%eax
  801511:	eb f0                	jmp    801503 <strfind+0xa>
			break;
	return (char *) s;
}
  801513:	5d                   	pop    %ebp
  801514:	c3                   	ret    

00801515 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801515:	55                   	push   %ebp
  801516:	89 e5                	mov    %esp,%ebp
  801518:	57                   	push   %edi
  801519:	56                   	push   %esi
  80151a:	53                   	push   %ebx
  80151b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80151e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801521:	85 c9                	test   %ecx,%ecx
  801523:	74 31                	je     801556 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801525:	89 f8                	mov    %edi,%eax
  801527:	09 c8                	or     %ecx,%eax
  801529:	a8 03                	test   $0x3,%al
  80152b:	75 23                	jne    801550 <memset+0x3b>
		c &= 0xFF;
  80152d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801531:	89 d3                	mov    %edx,%ebx
  801533:	c1 e3 08             	shl    $0x8,%ebx
  801536:	89 d0                	mov    %edx,%eax
  801538:	c1 e0 18             	shl    $0x18,%eax
  80153b:	89 d6                	mov    %edx,%esi
  80153d:	c1 e6 10             	shl    $0x10,%esi
  801540:	09 f0                	or     %esi,%eax
  801542:	09 c2                	or     %eax,%edx
  801544:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801546:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801549:	89 d0                	mov    %edx,%eax
  80154b:	fc                   	cld    
  80154c:	f3 ab                	rep stos %eax,%es:(%edi)
  80154e:	eb 06                	jmp    801556 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801550:	8b 45 0c             	mov    0xc(%ebp),%eax
  801553:	fc                   	cld    
  801554:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801556:	89 f8                	mov    %edi,%eax
  801558:	5b                   	pop    %ebx
  801559:	5e                   	pop    %esi
  80155a:	5f                   	pop    %edi
  80155b:	5d                   	pop    %ebp
  80155c:	c3                   	ret    

0080155d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80155d:	55                   	push   %ebp
  80155e:	89 e5                	mov    %esp,%ebp
  801560:	57                   	push   %edi
  801561:	56                   	push   %esi
  801562:	8b 45 08             	mov    0x8(%ebp),%eax
  801565:	8b 75 0c             	mov    0xc(%ebp),%esi
  801568:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80156b:	39 c6                	cmp    %eax,%esi
  80156d:	73 32                	jae    8015a1 <memmove+0x44>
  80156f:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801572:	39 c2                	cmp    %eax,%edx
  801574:	76 2b                	jbe    8015a1 <memmove+0x44>
		s += n;
		d += n;
  801576:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801579:	89 fe                	mov    %edi,%esi
  80157b:	09 ce                	or     %ecx,%esi
  80157d:	09 d6                	or     %edx,%esi
  80157f:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801585:	75 0e                	jne    801595 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801587:	83 ef 04             	sub    $0x4,%edi
  80158a:	8d 72 fc             	lea    -0x4(%edx),%esi
  80158d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801590:	fd                   	std    
  801591:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801593:	eb 09                	jmp    80159e <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801595:	83 ef 01             	sub    $0x1,%edi
  801598:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80159b:	fd                   	std    
  80159c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80159e:	fc                   	cld    
  80159f:	eb 1a                	jmp    8015bb <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8015a1:	89 c2                	mov    %eax,%edx
  8015a3:	09 ca                	or     %ecx,%edx
  8015a5:	09 f2                	or     %esi,%edx
  8015a7:	f6 c2 03             	test   $0x3,%dl
  8015aa:	75 0a                	jne    8015b6 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8015ac:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8015af:	89 c7                	mov    %eax,%edi
  8015b1:	fc                   	cld    
  8015b2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8015b4:	eb 05                	jmp    8015bb <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  8015b6:	89 c7                	mov    %eax,%edi
  8015b8:	fc                   	cld    
  8015b9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8015bb:	5e                   	pop    %esi
  8015bc:	5f                   	pop    %edi
  8015bd:	5d                   	pop    %ebp
  8015be:	c3                   	ret    

008015bf <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8015bf:	55                   	push   %ebp
  8015c0:	89 e5                	mov    %esp,%ebp
  8015c2:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8015c5:	ff 75 10             	pushl  0x10(%ebp)
  8015c8:	ff 75 0c             	pushl  0xc(%ebp)
  8015cb:	ff 75 08             	pushl  0x8(%ebp)
  8015ce:	e8 8a ff ff ff       	call   80155d <memmove>
}
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	56                   	push   %esi
  8015d9:	53                   	push   %ebx
  8015da:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e0:	89 c6                	mov    %eax,%esi
  8015e2:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8015e5:	39 f0                	cmp    %esi,%eax
  8015e7:	74 1c                	je     801605 <memcmp+0x30>
		if (*s1 != *s2)
  8015e9:	0f b6 08             	movzbl (%eax),%ecx
  8015ec:	0f b6 1a             	movzbl (%edx),%ebx
  8015ef:	38 d9                	cmp    %bl,%cl
  8015f1:	75 08                	jne    8015fb <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8015f3:	83 c0 01             	add    $0x1,%eax
  8015f6:	83 c2 01             	add    $0x1,%edx
  8015f9:	eb ea                	jmp    8015e5 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8015fb:	0f b6 c1             	movzbl %cl,%eax
  8015fe:	0f b6 db             	movzbl %bl,%ebx
  801601:	29 d8                	sub    %ebx,%eax
  801603:	eb 05                	jmp    80160a <memcmp+0x35>
	}

	return 0;
  801605:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80160a:	5b                   	pop    %ebx
  80160b:	5e                   	pop    %esi
  80160c:	5d                   	pop    %ebp
  80160d:	c3                   	ret    

0080160e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80160e:	55                   	push   %ebp
  80160f:	89 e5                	mov    %esp,%ebp
  801611:	8b 45 08             	mov    0x8(%ebp),%eax
  801614:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801617:	89 c2                	mov    %eax,%edx
  801619:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80161c:	39 d0                	cmp    %edx,%eax
  80161e:	73 09                	jae    801629 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801620:	38 08                	cmp    %cl,(%eax)
  801622:	74 05                	je     801629 <memfind+0x1b>
	for (; s < ends; s++)
  801624:	83 c0 01             	add    $0x1,%eax
  801627:	eb f3                	jmp    80161c <memfind+0xe>
			break;
	return (void *) s;
}
  801629:	5d                   	pop    %ebp
  80162a:	c3                   	ret    

0080162b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
  80162e:	57                   	push   %edi
  80162f:	56                   	push   %esi
  801630:	53                   	push   %ebx
  801631:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801634:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801637:	eb 03                	jmp    80163c <strtol+0x11>
		s++;
  801639:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  80163c:	0f b6 01             	movzbl (%ecx),%eax
  80163f:	3c 20                	cmp    $0x20,%al
  801641:	74 f6                	je     801639 <strtol+0xe>
  801643:	3c 09                	cmp    $0x9,%al
  801645:	74 f2                	je     801639 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801647:	3c 2b                	cmp    $0x2b,%al
  801649:	74 2a                	je     801675 <strtol+0x4a>
	int neg = 0;
  80164b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801650:	3c 2d                	cmp    $0x2d,%al
  801652:	74 2b                	je     80167f <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801654:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  80165a:	75 0f                	jne    80166b <strtol+0x40>
  80165c:	80 39 30             	cmpb   $0x30,(%ecx)
  80165f:	74 28                	je     801689 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801661:	85 db                	test   %ebx,%ebx
  801663:	b8 0a 00 00 00       	mov    $0xa,%eax
  801668:	0f 44 d8             	cmove  %eax,%ebx
  80166b:	b8 00 00 00 00       	mov    $0x0,%eax
  801670:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801673:	eb 50                	jmp    8016c5 <strtol+0x9a>
		s++;
  801675:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801678:	bf 00 00 00 00       	mov    $0x0,%edi
  80167d:	eb d5                	jmp    801654 <strtol+0x29>
		s++, neg = 1;
  80167f:	83 c1 01             	add    $0x1,%ecx
  801682:	bf 01 00 00 00       	mov    $0x1,%edi
  801687:	eb cb                	jmp    801654 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801689:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80168d:	74 0e                	je     80169d <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  80168f:	85 db                	test   %ebx,%ebx
  801691:	75 d8                	jne    80166b <strtol+0x40>
		s++, base = 8;
  801693:	83 c1 01             	add    $0x1,%ecx
  801696:	bb 08 00 00 00       	mov    $0x8,%ebx
  80169b:	eb ce                	jmp    80166b <strtol+0x40>
		s += 2, base = 16;
  80169d:	83 c1 02             	add    $0x2,%ecx
  8016a0:	bb 10 00 00 00       	mov    $0x10,%ebx
  8016a5:	eb c4                	jmp    80166b <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  8016a7:	8d 72 9f             	lea    -0x61(%edx),%esi
  8016aa:	89 f3                	mov    %esi,%ebx
  8016ac:	80 fb 19             	cmp    $0x19,%bl
  8016af:	77 29                	ja     8016da <strtol+0xaf>
			dig = *s - 'a' + 10;
  8016b1:	0f be d2             	movsbl %dl,%edx
  8016b4:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8016b7:	3b 55 10             	cmp    0x10(%ebp),%edx
  8016ba:	7d 30                	jge    8016ec <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  8016bc:	83 c1 01             	add    $0x1,%ecx
  8016bf:	0f af 45 10          	imul   0x10(%ebp),%eax
  8016c3:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8016c5:	0f b6 11             	movzbl (%ecx),%edx
  8016c8:	8d 72 d0             	lea    -0x30(%edx),%esi
  8016cb:	89 f3                	mov    %esi,%ebx
  8016cd:	80 fb 09             	cmp    $0x9,%bl
  8016d0:	77 d5                	ja     8016a7 <strtol+0x7c>
			dig = *s - '0';
  8016d2:	0f be d2             	movsbl %dl,%edx
  8016d5:	83 ea 30             	sub    $0x30,%edx
  8016d8:	eb dd                	jmp    8016b7 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  8016da:	8d 72 bf             	lea    -0x41(%edx),%esi
  8016dd:	89 f3                	mov    %esi,%ebx
  8016df:	80 fb 19             	cmp    $0x19,%bl
  8016e2:	77 08                	ja     8016ec <strtol+0xc1>
			dig = *s - 'A' + 10;
  8016e4:	0f be d2             	movsbl %dl,%edx
  8016e7:	83 ea 37             	sub    $0x37,%edx
  8016ea:	eb cb                	jmp    8016b7 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  8016ec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016f0:	74 05                	je     8016f7 <strtol+0xcc>
		*endptr = (char *) s;
  8016f2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8016f5:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8016f7:	89 c2                	mov    %eax,%edx
  8016f9:	f7 da                	neg    %edx
  8016fb:	85 ff                	test   %edi,%edi
  8016fd:	0f 45 c2             	cmovne %edx,%eax
}
  801700:	5b                   	pop    %ebx
  801701:	5e                   	pop    %esi
  801702:	5f                   	pop    %edi
  801703:	5d                   	pop    %ebp
  801704:	c3                   	ret    

00801705 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
  801708:	57                   	push   %edi
  801709:	56                   	push   %esi
  80170a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80170b:	b8 00 00 00 00       	mov    $0x0,%eax
  801710:	8b 55 08             	mov    0x8(%ebp),%edx
  801713:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801716:	89 c3                	mov    %eax,%ebx
  801718:	89 c7                	mov    %eax,%edi
  80171a:	89 c6                	mov    %eax,%esi
  80171c:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80171e:	5b                   	pop    %ebx
  80171f:	5e                   	pop    %esi
  801720:	5f                   	pop    %edi
  801721:	5d                   	pop    %ebp
  801722:	c3                   	ret    

00801723 <sys_cgetc>:

int
sys_cgetc(void)
{
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
  801726:	57                   	push   %edi
  801727:	56                   	push   %esi
  801728:	53                   	push   %ebx
	asm volatile("int %1\n"
  801729:	ba 00 00 00 00       	mov    $0x0,%edx
  80172e:	b8 01 00 00 00       	mov    $0x1,%eax
  801733:	89 d1                	mov    %edx,%ecx
  801735:	89 d3                	mov    %edx,%ebx
  801737:	89 d7                	mov    %edx,%edi
  801739:	89 d6                	mov    %edx,%esi
  80173b:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80173d:	5b                   	pop    %ebx
  80173e:	5e                   	pop    %esi
  80173f:	5f                   	pop    %edi
  801740:	5d                   	pop    %ebp
  801741:	c3                   	ret    

00801742 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
  801745:	57                   	push   %edi
  801746:	56                   	push   %esi
  801747:	53                   	push   %ebx
  801748:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80174b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801750:	8b 55 08             	mov    0x8(%ebp),%edx
  801753:	b8 03 00 00 00       	mov    $0x3,%eax
  801758:	89 cb                	mov    %ecx,%ebx
  80175a:	89 cf                	mov    %ecx,%edi
  80175c:	89 ce                	mov    %ecx,%esi
  80175e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801760:	85 c0                	test   %eax,%eax
  801762:	7f 08                	jg     80176c <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801764:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801767:	5b                   	pop    %ebx
  801768:	5e                   	pop    %esi
  801769:	5f                   	pop    %edi
  80176a:	5d                   	pop    %ebp
  80176b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80176c:	83 ec 0c             	sub    $0xc,%esp
  80176f:	50                   	push   %eax
  801770:	6a 03                	push   $0x3
  801772:	68 78 42 80 00       	push   $0x804278
  801777:	6a 43                	push   $0x43
  801779:	68 95 42 80 00       	push   $0x804295
  80177e:	e8 07 f3 ff ff       	call   800a8a <_panic>

00801783 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
  801786:	57                   	push   %edi
  801787:	56                   	push   %esi
  801788:	53                   	push   %ebx
	asm volatile("int %1\n"
  801789:	ba 00 00 00 00       	mov    $0x0,%edx
  80178e:	b8 02 00 00 00       	mov    $0x2,%eax
  801793:	89 d1                	mov    %edx,%ecx
  801795:	89 d3                	mov    %edx,%ebx
  801797:	89 d7                	mov    %edx,%edi
  801799:	89 d6                	mov    %edx,%esi
  80179b:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80179d:	5b                   	pop    %ebx
  80179e:	5e                   	pop    %esi
  80179f:	5f                   	pop    %edi
  8017a0:	5d                   	pop    %ebp
  8017a1:	c3                   	ret    

008017a2 <sys_yield>:

void
sys_yield(void)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
  8017a5:	57                   	push   %edi
  8017a6:	56                   	push   %esi
  8017a7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8017a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ad:	b8 0b 00 00 00       	mov    $0xb,%eax
  8017b2:	89 d1                	mov    %edx,%ecx
  8017b4:	89 d3                	mov    %edx,%ebx
  8017b6:	89 d7                	mov    %edx,%edi
  8017b8:	89 d6                	mov    %edx,%esi
  8017ba:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8017bc:	5b                   	pop    %ebx
  8017bd:	5e                   	pop    %esi
  8017be:	5f                   	pop    %edi
  8017bf:	5d                   	pop    %ebp
  8017c0:	c3                   	ret    

008017c1 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
  8017c4:	57                   	push   %edi
  8017c5:	56                   	push   %esi
  8017c6:	53                   	push   %ebx
  8017c7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8017ca:	be 00 00 00 00       	mov    $0x0,%esi
  8017cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8017d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017d5:	b8 04 00 00 00       	mov    $0x4,%eax
  8017da:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8017dd:	89 f7                	mov    %esi,%edi
  8017df:	cd 30                	int    $0x30
	if(check && ret > 0)
  8017e1:	85 c0                	test   %eax,%eax
  8017e3:	7f 08                	jg     8017ed <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8017e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017e8:	5b                   	pop    %ebx
  8017e9:	5e                   	pop    %esi
  8017ea:	5f                   	pop    %edi
  8017eb:	5d                   	pop    %ebp
  8017ec:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8017ed:	83 ec 0c             	sub    $0xc,%esp
  8017f0:	50                   	push   %eax
  8017f1:	6a 04                	push   $0x4
  8017f3:	68 78 42 80 00       	push   $0x804278
  8017f8:	6a 43                	push   $0x43
  8017fa:	68 95 42 80 00       	push   $0x804295
  8017ff:	e8 86 f2 ff ff       	call   800a8a <_panic>

00801804 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
  801807:	57                   	push   %edi
  801808:	56                   	push   %esi
  801809:	53                   	push   %ebx
  80180a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80180d:	8b 55 08             	mov    0x8(%ebp),%edx
  801810:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801813:	b8 05 00 00 00       	mov    $0x5,%eax
  801818:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80181b:	8b 7d 14             	mov    0x14(%ebp),%edi
  80181e:	8b 75 18             	mov    0x18(%ebp),%esi
  801821:	cd 30                	int    $0x30
	if(check && ret > 0)
  801823:	85 c0                	test   %eax,%eax
  801825:	7f 08                	jg     80182f <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801827:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80182a:	5b                   	pop    %ebx
  80182b:	5e                   	pop    %esi
  80182c:	5f                   	pop    %edi
  80182d:	5d                   	pop    %ebp
  80182e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80182f:	83 ec 0c             	sub    $0xc,%esp
  801832:	50                   	push   %eax
  801833:	6a 05                	push   $0x5
  801835:	68 78 42 80 00       	push   $0x804278
  80183a:	6a 43                	push   $0x43
  80183c:	68 95 42 80 00       	push   $0x804295
  801841:	e8 44 f2 ff ff       	call   800a8a <_panic>

00801846 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
  801849:	57                   	push   %edi
  80184a:	56                   	push   %esi
  80184b:	53                   	push   %ebx
  80184c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80184f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801854:	8b 55 08             	mov    0x8(%ebp),%edx
  801857:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80185a:	b8 06 00 00 00       	mov    $0x6,%eax
  80185f:	89 df                	mov    %ebx,%edi
  801861:	89 de                	mov    %ebx,%esi
  801863:	cd 30                	int    $0x30
	if(check && ret > 0)
  801865:	85 c0                	test   %eax,%eax
  801867:	7f 08                	jg     801871 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801869:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80186c:	5b                   	pop    %ebx
  80186d:	5e                   	pop    %esi
  80186e:	5f                   	pop    %edi
  80186f:	5d                   	pop    %ebp
  801870:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801871:	83 ec 0c             	sub    $0xc,%esp
  801874:	50                   	push   %eax
  801875:	6a 06                	push   $0x6
  801877:	68 78 42 80 00       	push   $0x804278
  80187c:	6a 43                	push   $0x43
  80187e:	68 95 42 80 00       	push   $0x804295
  801883:	e8 02 f2 ff ff       	call   800a8a <_panic>

00801888 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
  80188b:	57                   	push   %edi
  80188c:	56                   	push   %esi
  80188d:	53                   	push   %ebx
  80188e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801891:	bb 00 00 00 00       	mov    $0x0,%ebx
  801896:	8b 55 08             	mov    0x8(%ebp),%edx
  801899:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80189c:	b8 08 00 00 00       	mov    $0x8,%eax
  8018a1:	89 df                	mov    %ebx,%edi
  8018a3:	89 de                	mov    %ebx,%esi
  8018a5:	cd 30                	int    $0x30
	if(check && ret > 0)
  8018a7:	85 c0                	test   %eax,%eax
  8018a9:	7f 08                	jg     8018b3 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8018ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018ae:	5b                   	pop    %ebx
  8018af:	5e                   	pop    %esi
  8018b0:	5f                   	pop    %edi
  8018b1:	5d                   	pop    %ebp
  8018b2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8018b3:	83 ec 0c             	sub    $0xc,%esp
  8018b6:	50                   	push   %eax
  8018b7:	6a 08                	push   $0x8
  8018b9:	68 78 42 80 00       	push   $0x804278
  8018be:	6a 43                	push   $0x43
  8018c0:	68 95 42 80 00       	push   $0x804295
  8018c5:	e8 c0 f1 ff ff       	call   800a8a <_panic>

008018ca <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
  8018cd:	57                   	push   %edi
  8018ce:	56                   	push   %esi
  8018cf:	53                   	push   %ebx
  8018d0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8018d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8018db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018de:	b8 09 00 00 00       	mov    $0x9,%eax
  8018e3:	89 df                	mov    %ebx,%edi
  8018e5:	89 de                	mov    %ebx,%esi
  8018e7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8018e9:	85 c0                	test   %eax,%eax
  8018eb:	7f 08                	jg     8018f5 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8018ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018f0:	5b                   	pop    %ebx
  8018f1:	5e                   	pop    %esi
  8018f2:	5f                   	pop    %edi
  8018f3:	5d                   	pop    %ebp
  8018f4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8018f5:	83 ec 0c             	sub    $0xc,%esp
  8018f8:	50                   	push   %eax
  8018f9:	6a 09                	push   $0x9
  8018fb:	68 78 42 80 00       	push   $0x804278
  801900:	6a 43                	push   $0x43
  801902:	68 95 42 80 00       	push   $0x804295
  801907:	e8 7e f1 ff ff       	call   800a8a <_panic>

0080190c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
  80190f:	57                   	push   %edi
  801910:	56                   	push   %esi
  801911:	53                   	push   %ebx
  801912:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801915:	bb 00 00 00 00       	mov    $0x0,%ebx
  80191a:	8b 55 08             	mov    0x8(%ebp),%edx
  80191d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801920:	b8 0a 00 00 00       	mov    $0xa,%eax
  801925:	89 df                	mov    %ebx,%edi
  801927:	89 de                	mov    %ebx,%esi
  801929:	cd 30                	int    $0x30
	if(check && ret > 0)
  80192b:	85 c0                	test   %eax,%eax
  80192d:	7f 08                	jg     801937 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80192f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801932:	5b                   	pop    %ebx
  801933:	5e                   	pop    %esi
  801934:	5f                   	pop    %edi
  801935:	5d                   	pop    %ebp
  801936:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801937:	83 ec 0c             	sub    $0xc,%esp
  80193a:	50                   	push   %eax
  80193b:	6a 0a                	push   $0xa
  80193d:	68 78 42 80 00       	push   $0x804278
  801942:	6a 43                	push   $0x43
  801944:	68 95 42 80 00       	push   $0x804295
  801949:	e8 3c f1 ff ff       	call   800a8a <_panic>

0080194e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
  801951:	57                   	push   %edi
  801952:	56                   	push   %esi
  801953:	53                   	push   %ebx
	asm volatile("int %1\n"
  801954:	8b 55 08             	mov    0x8(%ebp),%edx
  801957:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80195a:	b8 0c 00 00 00       	mov    $0xc,%eax
  80195f:	be 00 00 00 00       	mov    $0x0,%esi
  801964:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801967:	8b 7d 14             	mov    0x14(%ebp),%edi
  80196a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80196c:	5b                   	pop    %ebx
  80196d:	5e                   	pop    %esi
  80196e:	5f                   	pop    %edi
  80196f:	5d                   	pop    %ebp
  801970:	c3                   	ret    

00801971 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp
  801974:	57                   	push   %edi
  801975:	56                   	push   %esi
  801976:	53                   	push   %ebx
  801977:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80197a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80197f:	8b 55 08             	mov    0x8(%ebp),%edx
  801982:	b8 0d 00 00 00       	mov    $0xd,%eax
  801987:	89 cb                	mov    %ecx,%ebx
  801989:	89 cf                	mov    %ecx,%edi
  80198b:	89 ce                	mov    %ecx,%esi
  80198d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80198f:	85 c0                	test   %eax,%eax
  801991:	7f 08                	jg     80199b <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801993:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801996:	5b                   	pop    %ebx
  801997:	5e                   	pop    %esi
  801998:	5f                   	pop    %edi
  801999:	5d                   	pop    %ebp
  80199a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80199b:	83 ec 0c             	sub    $0xc,%esp
  80199e:	50                   	push   %eax
  80199f:	6a 0d                	push   $0xd
  8019a1:	68 78 42 80 00       	push   $0x804278
  8019a6:	6a 43                	push   $0x43
  8019a8:	68 95 42 80 00       	push   $0x804295
  8019ad:	e8 d8 f0 ff ff       	call   800a8a <_panic>

008019b2 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
  8019b5:	57                   	push   %edi
  8019b6:	56                   	push   %esi
  8019b7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8019b8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8019c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019c3:	b8 0e 00 00 00       	mov    $0xe,%eax
  8019c8:	89 df                	mov    %ebx,%edi
  8019ca:	89 de                	mov    %ebx,%esi
  8019cc:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8019ce:	5b                   	pop    %ebx
  8019cf:	5e                   	pop    %esi
  8019d0:	5f                   	pop    %edi
  8019d1:	5d                   	pop    %ebp
  8019d2:	c3                   	ret    

008019d3 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
  8019d6:	57                   	push   %edi
  8019d7:	56                   	push   %esi
  8019d8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8019d9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019de:	8b 55 08             	mov    0x8(%ebp),%edx
  8019e1:	b8 0f 00 00 00       	mov    $0xf,%eax
  8019e6:	89 cb                	mov    %ecx,%ebx
  8019e8:	89 cf                	mov    %ecx,%edi
  8019ea:	89 ce                	mov    %ecx,%esi
  8019ec:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8019ee:	5b                   	pop    %ebx
  8019ef:	5e                   	pop    %esi
  8019f0:	5f                   	pop    %edi
  8019f1:	5d                   	pop    %ebp
  8019f2:	c3                   	ret    

008019f3 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
  8019f6:	57                   	push   %edi
  8019f7:	56                   	push   %esi
  8019f8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8019f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8019fe:	b8 10 00 00 00       	mov    $0x10,%eax
  801a03:	89 d1                	mov    %edx,%ecx
  801a05:	89 d3                	mov    %edx,%ebx
  801a07:	89 d7                	mov    %edx,%edi
  801a09:	89 d6                	mov    %edx,%esi
  801a0b:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801a0d:	5b                   	pop    %ebx
  801a0e:	5e                   	pop    %esi
  801a0f:	5f                   	pop    %edi
  801a10:	5d                   	pop    %ebp
  801a11:	c3                   	ret    

00801a12 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
  801a15:	57                   	push   %edi
  801a16:	56                   	push   %esi
  801a17:	53                   	push   %ebx
	asm volatile("int %1\n"
  801a18:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a1d:	8b 55 08             	mov    0x8(%ebp),%edx
  801a20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a23:	b8 11 00 00 00       	mov    $0x11,%eax
  801a28:	89 df                	mov    %ebx,%edi
  801a2a:	89 de                	mov    %ebx,%esi
  801a2c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801a2e:	5b                   	pop    %ebx
  801a2f:	5e                   	pop    %esi
  801a30:	5f                   	pop    %edi
  801a31:	5d                   	pop    %ebp
  801a32:	c3                   	ret    

00801a33 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
  801a36:	57                   	push   %edi
  801a37:	56                   	push   %esi
  801a38:	53                   	push   %ebx
	asm volatile("int %1\n"
  801a39:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a3e:	8b 55 08             	mov    0x8(%ebp),%edx
  801a41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a44:	b8 12 00 00 00       	mov    $0x12,%eax
  801a49:	89 df                	mov    %ebx,%edi
  801a4b:	89 de                	mov    %ebx,%esi
  801a4d:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801a4f:	5b                   	pop    %ebx
  801a50:	5e                   	pop    %esi
  801a51:	5f                   	pop    %edi
  801a52:	5d                   	pop    %ebp
  801a53:	c3                   	ret    

00801a54 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
  801a57:	57                   	push   %edi
  801a58:	56                   	push   %esi
  801a59:	53                   	push   %ebx
  801a5a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801a5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a62:	8b 55 08             	mov    0x8(%ebp),%edx
  801a65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a68:	b8 13 00 00 00       	mov    $0x13,%eax
  801a6d:	89 df                	mov    %ebx,%edi
  801a6f:	89 de                	mov    %ebx,%esi
  801a71:	cd 30                	int    $0x30
	if(check && ret > 0)
  801a73:	85 c0                	test   %eax,%eax
  801a75:	7f 08                	jg     801a7f <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801a77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a7a:	5b                   	pop    %ebx
  801a7b:	5e                   	pop    %esi
  801a7c:	5f                   	pop    %edi
  801a7d:	5d                   	pop    %ebp
  801a7e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801a7f:	83 ec 0c             	sub    $0xc,%esp
  801a82:	50                   	push   %eax
  801a83:	6a 13                	push   $0x13
  801a85:	68 78 42 80 00       	push   $0x804278
  801a8a:	6a 43                	push   $0x43
  801a8c:	68 95 42 80 00       	push   $0x804295
  801a91:	e8 f4 ef ff ff       	call   800a8a <_panic>

00801a96 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
  801a99:	57                   	push   %edi
  801a9a:	56                   	push   %esi
  801a9b:	53                   	push   %ebx
	asm volatile("int %1\n"
  801a9c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aa1:	8b 55 08             	mov    0x8(%ebp),%edx
  801aa4:	b8 14 00 00 00       	mov    $0x14,%eax
  801aa9:	89 cb                	mov    %ecx,%ebx
  801aab:	89 cf                	mov    %ecx,%edi
  801aad:	89 ce                	mov    %ecx,%esi
  801aaf:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801ab1:	5b                   	pop    %ebx
  801ab2:	5e                   	pop    %esi
  801ab3:	5f                   	pop    %edi
  801ab4:	5d                   	pop    %ebp
  801ab5:	c3                   	ret    

00801ab6 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
  801ab9:	53                   	push   %ebx
  801aba:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801abd:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801ac4:	f6 c5 04             	test   $0x4,%ch
  801ac7:	75 45                	jne    801b0e <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801ac9:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801ad0:	83 e1 07             	and    $0x7,%ecx
  801ad3:	83 f9 07             	cmp    $0x7,%ecx
  801ad6:	74 6f                	je     801b47 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801ad8:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801adf:	81 e1 05 08 00 00    	and    $0x805,%ecx
  801ae5:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801aeb:	0f 84 b6 00 00 00    	je     801ba7 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801af1:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801af8:	83 e1 05             	and    $0x5,%ecx
  801afb:	83 f9 05             	cmp    $0x5,%ecx
  801afe:	0f 84 d7 00 00 00    	je     801bdb <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801b04:	b8 00 00 00 00       	mov    $0x0,%eax
  801b09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801b0e:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801b15:	c1 e2 0c             	shl    $0xc,%edx
  801b18:	83 ec 0c             	sub    $0xc,%esp
  801b1b:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801b21:	51                   	push   %ecx
  801b22:	52                   	push   %edx
  801b23:	50                   	push   %eax
  801b24:	52                   	push   %edx
  801b25:	6a 00                	push   $0x0
  801b27:	e8 d8 fc ff ff       	call   801804 <sys_page_map>
		if(r < 0)
  801b2c:	83 c4 20             	add    $0x20,%esp
  801b2f:	85 c0                	test   %eax,%eax
  801b31:	79 d1                	jns    801b04 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801b33:	83 ec 04             	sub    $0x4,%esp
  801b36:	68 a3 42 80 00       	push   $0x8042a3
  801b3b:	6a 54                	push   $0x54
  801b3d:	68 b9 42 80 00       	push   $0x8042b9
  801b42:	e8 43 ef ff ff       	call   800a8a <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801b47:	89 d3                	mov    %edx,%ebx
  801b49:	c1 e3 0c             	shl    $0xc,%ebx
  801b4c:	83 ec 0c             	sub    $0xc,%esp
  801b4f:	68 05 08 00 00       	push   $0x805
  801b54:	53                   	push   %ebx
  801b55:	50                   	push   %eax
  801b56:	53                   	push   %ebx
  801b57:	6a 00                	push   $0x0
  801b59:	e8 a6 fc ff ff       	call   801804 <sys_page_map>
		if(r < 0)
  801b5e:	83 c4 20             	add    $0x20,%esp
  801b61:	85 c0                	test   %eax,%eax
  801b63:	78 2e                	js     801b93 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801b65:	83 ec 0c             	sub    $0xc,%esp
  801b68:	68 05 08 00 00       	push   $0x805
  801b6d:	53                   	push   %ebx
  801b6e:	6a 00                	push   $0x0
  801b70:	53                   	push   %ebx
  801b71:	6a 00                	push   $0x0
  801b73:	e8 8c fc ff ff       	call   801804 <sys_page_map>
		if(r < 0)
  801b78:	83 c4 20             	add    $0x20,%esp
  801b7b:	85 c0                	test   %eax,%eax
  801b7d:	79 85                	jns    801b04 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801b7f:	83 ec 04             	sub    $0x4,%esp
  801b82:	68 a3 42 80 00       	push   $0x8042a3
  801b87:	6a 5f                	push   $0x5f
  801b89:	68 b9 42 80 00       	push   $0x8042b9
  801b8e:	e8 f7 ee ff ff       	call   800a8a <_panic>
			panic("sys_page_map() panic\n");
  801b93:	83 ec 04             	sub    $0x4,%esp
  801b96:	68 a3 42 80 00       	push   $0x8042a3
  801b9b:	6a 5b                	push   $0x5b
  801b9d:	68 b9 42 80 00       	push   $0x8042b9
  801ba2:	e8 e3 ee ff ff       	call   800a8a <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801ba7:	c1 e2 0c             	shl    $0xc,%edx
  801baa:	83 ec 0c             	sub    $0xc,%esp
  801bad:	68 05 08 00 00       	push   $0x805
  801bb2:	52                   	push   %edx
  801bb3:	50                   	push   %eax
  801bb4:	52                   	push   %edx
  801bb5:	6a 00                	push   $0x0
  801bb7:	e8 48 fc ff ff       	call   801804 <sys_page_map>
		if(r < 0)
  801bbc:	83 c4 20             	add    $0x20,%esp
  801bbf:	85 c0                	test   %eax,%eax
  801bc1:	0f 89 3d ff ff ff    	jns    801b04 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801bc7:	83 ec 04             	sub    $0x4,%esp
  801bca:	68 a3 42 80 00       	push   $0x8042a3
  801bcf:	6a 66                	push   $0x66
  801bd1:	68 b9 42 80 00       	push   $0x8042b9
  801bd6:	e8 af ee ff ff       	call   800a8a <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801bdb:	c1 e2 0c             	shl    $0xc,%edx
  801bde:	83 ec 0c             	sub    $0xc,%esp
  801be1:	6a 05                	push   $0x5
  801be3:	52                   	push   %edx
  801be4:	50                   	push   %eax
  801be5:	52                   	push   %edx
  801be6:	6a 00                	push   $0x0
  801be8:	e8 17 fc ff ff       	call   801804 <sys_page_map>
		if(r < 0)
  801bed:	83 c4 20             	add    $0x20,%esp
  801bf0:	85 c0                	test   %eax,%eax
  801bf2:	0f 89 0c ff ff ff    	jns    801b04 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801bf8:	83 ec 04             	sub    $0x4,%esp
  801bfb:	68 a3 42 80 00       	push   $0x8042a3
  801c00:	6a 6d                	push   $0x6d
  801c02:	68 b9 42 80 00       	push   $0x8042b9
  801c07:	e8 7e ee ff ff       	call   800a8a <_panic>

00801c0c <pgfault>:
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
  801c0f:	53                   	push   %ebx
  801c10:	83 ec 04             	sub    $0x4,%esp
  801c13:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801c16:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801c18:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801c1c:	0f 84 99 00 00 00    	je     801cbb <pgfault+0xaf>
  801c22:	89 c2                	mov    %eax,%edx
  801c24:	c1 ea 16             	shr    $0x16,%edx
  801c27:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801c2e:	f6 c2 01             	test   $0x1,%dl
  801c31:	0f 84 84 00 00 00    	je     801cbb <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801c37:	89 c2                	mov    %eax,%edx
  801c39:	c1 ea 0c             	shr    $0xc,%edx
  801c3c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801c43:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801c49:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801c4f:	75 6a                	jne    801cbb <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801c51:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c56:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801c58:	83 ec 04             	sub    $0x4,%esp
  801c5b:	6a 07                	push   $0x7
  801c5d:	68 00 f0 7f 00       	push   $0x7ff000
  801c62:	6a 00                	push   $0x0
  801c64:	e8 58 fb ff ff       	call   8017c1 <sys_page_alloc>
	if(ret < 0)
  801c69:	83 c4 10             	add    $0x10,%esp
  801c6c:	85 c0                	test   %eax,%eax
  801c6e:	78 5f                	js     801ccf <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801c70:	83 ec 04             	sub    $0x4,%esp
  801c73:	68 00 10 00 00       	push   $0x1000
  801c78:	53                   	push   %ebx
  801c79:	68 00 f0 7f 00       	push   $0x7ff000
  801c7e:	e8 3c f9 ff ff       	call   8015bf <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801c83:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801c8a:	53                   	push   %ebx
  801c8b:	6a 00                	push   $0x0
  801c8d:	68 00 f0 7f 00       	push   $0x7ff000
  801c92:	6a 00                	push   $0x0
  801c94:	e8 6b fb ff ff       	call   801804 <sys_page_map>
	if(ret < 0)
  801c99:	83 c4 20             	add    $0x20,%esp
  801c9c:	85 c0                	test   %eax,%eax
  801c9e:	78 43                	js     801ce3 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801ca0:	83 ec 08             	sub    $0x8,%esp
  801ca3:	68 00 f0 7f 00       	push   $0x7ff000
  801ca8:	6a 00                	push   $0x0
  801caa:	e8 97 fb ff ff       	call   801846 <sys_page_unmap>
	if(ret < 0)
  801caf:	83 c4 10             	add    $0x10,%esp
  801cb2:	85 c0                	test   %eax,%eax
  801cb4:	78 41                	js     801cf7 <pgfault+0xeb>
}
  801cb6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cb9:	c9                   	leave  
  801cba:	c3                   	ret    
		panic("panic at pgfault()\n");
  801cbb:	83 ec 04             	sub    $0x4,%esp
  801cbe:	68 c4 42 80 00       	push   $0x8042c4
  801cc3:	6a 26                	push   $0x26
  801cc5:	68 b9 42 80 00       	push   $0x8042b9
  801cca:	e8 bb ed ff ff       	call   800a8a <_panic>
		panic("panic in sys_page_alloc()\n");
  801ccf:	83 ec 04             	sub    $0x4,%esp
  801cd2:	68 d8 42 80 00       	push   $0x8042d8
  801cd7:	6a 31                	push   $0x31
  801cd9:	68 b9 42 80 00       	push   $0x8042b9
  801cde:	e8 a7 ed ff ff       	call   800a8a <_panic>
		panic("panic in sys_page_map()\n");
  801ce3:	83 ec 04             	sub    $0x4,%esp
  801ce6:	68 f3 42 80 00       	push   $0x8042f3
  801ceb:	6a 36                	push   $0x36
  801ced:	68 b9 42 80 00       	push   $0x8042b9
  801cf2:	e8 93 ed ff ff       	call   800a8a <_panic>
		panic("panic in sys_page_unmap()\n");
  801cf7:	83 ec 04             	sub    $0x4,%esp
  801cfa:	68 0c 43 80 00       	push   $0x80430c
  801cff:	6a 39                	push   $0x39
  801d01:	68 b9 42 80 00       	push   $0x8042b9
  801d06:	e8 7f ed ff ff       	call   800a8a <_panic>

00801d0b <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
  801d0e:	57                   	push   %edi
  801d0f:	56                   	push   %esi
  801d10:	53                   	push   %ebx
  801d11:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801d14:	68 0c 1c 80 00       	push   $0x801c0c
  801d19:	e8 36 1b 00 00       	call   803854 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801d1e:	b8 07 00 00 00       	mov    $0x7,%eax
  801d23:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801d25:	83 c4 10             	add    $0x10,%esp
  801d28:	85 c0                	test   %eax,%eax
  801d2a:	78 2a                	js     801d56 <fork+0x4b>
  801d2c:	89 c6                	mov    %eax,%esi
  801d2e:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801d30:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801d35:	75 4b                	jne    801d82 <fork+0x77>
		thisenv = &envs[ENVX(sys_getenvid())];
  801d37:	e8 47 fa ff ff       	call   801783 <sys_getenvid>
  801d3c:	25 ff 03 00 00       	and    $0x3ff,%eax
  801d41:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801d47:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801d4c:	a3 28 64 80 00       	mov    %eax,0x806428
		return 0;
  801d51:	e9 90 00 00 00       	jmp    801de6 <fork+0xdb>
		panic("the fork panic! at sys_exofork()\n");
  801d56:	83 ec 04             	sub    $0x4,%esp
  801d59:	68 28 43 80 00       	push   $0x804328
  801d5e:	68 8c 00 00 00       	push   $0x8c
  801d63:	68 b9 42 80 00       	push   $0x8042b9
  801d68:	e8 1d ed ff ff       	call   800a8a <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801d6d:	89 f8                	mov    %edi,%eax
  801d6f:	e8 42 fd ff ff       	call   801ab6 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801d74:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801d7a:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801d80:	74 26                	je     801da8 <fork+0x9d>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801d82:	89 d8                	mov    %ebx,%eax
  801d84:	c1 e8 16             	shr    $0x16,%eax
  801d87:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801d8e:	a8 01                	test   $0x1,%al
  801d90:	74 e2                	je     801d74 <fork+0x69>
  801d92:	89 da                	mov    %ebx,%edx
  801d94:	c1 ea 0c             	shr    $0xc,%edx
  801d97:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801d9e:	83 e0 05             	and    $0x5,%eax
  801da1:	83 f8 05             	cmp    $0x5,%eax
  801da4:	75 ce                	jne    801d74 <fork+0x69>
  801da6:	eb c5                	jmp    801d6d <fork+0x62>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801da8:	83 ec 04             	sub    $0x4,%esp
  801dab:	6a 07                	push   $0x7
  801dad:	68 00 f0 bf ee       	push   $0xeebff000
  801db2:	56                   	push   %esi
  801db3:	e8 09 fa ff ff       	call   8017c1 <sys_page_alloc>
	if(ret < 0)
  801db8:	83 c4 10             	add    $0x10,%esp
  801dbb:	85 c0                	test   %eax,%eax
  801dbd:	78 31                	js     801df0 <fork+0xe5>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801dbf:	83 ec 08             	sub    $0x8,%esp
  801dc2:	68 c3 38 80 00       	push   $0x8038c3
  801dc7:	56                   	push   %esi
  801dc8:	e8 3f fb ff ff       	call   80190c <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801dcd:	83 c4 10             	add    $0x10,%esp
  801dd0:	85 c0                	test   %eax,%eax
  801dd2:	78 33                	js     801e07 <fork+0xfc>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801dd4:	83 ec 08             	sub    $0x8,%esp
  801dd7:	6a 02                	push   $0x2
  801dd9:	56                   	push   %esi
  801dda:	e8 a9 fa ff ff       	call   801888 <sys_env_set_status>
	if(ret < 0)
  801ddf:	83 c4 10             	add    $0x10,%esp
  801de2:	85 c0                	test   %eax,%eax
  801de4:	78 38                	js     801e1e <fork+0x113>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801de6:	89 f0                	mov    %esi,%eax
  801de8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801deb:	5b                   	pop    %ebx
  801dec:	5e                   	pop    %esi
  801ded:	5f                   	pop    %edi
  801dee:	5d                   	pop    %ebp
  801def:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801df0:	83 ec 04             	sub    $0x4,%esp
  801df3:	68 d8 42 80 00       	push   $0x8042d8
  801df8:	68 98 00 00 00       	push   $0x98
  801dfd:	68 b9 42 80 00       	push   $0x8042b9
  801e02:	e8 83 ec ff ff       	call   800a8a <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801e07:	83 ec 04             	sub    $0x4,%esp
  801e0a:	68 4c 43 80 00       	push   $0x80434c
  801e0f:	68 9b 00 00 00       	push   $0x9b
  801e14:	68 b9 42 80 00       	push   $0x8042b9
  801e19:	e8 6c ec ff ff       	call   800a8a <_panic>
		panic("panic in sys_env_set_status()\n");
  801e1e:	83 ec 04             	sub    $0x4,%esp
  801e21:	68 74 43 80 00       	push   $0x804374
  801e26:	68 9e 00 00 00       	push   $0x9e
  801e2b:	68 b9 42 80 00       	push   $0x8042b9
  801e30:	e8 55 ec ff ff       	call   800a8a <_panic>

00801e35 <sfork>:

// Challenge!
int
sfork(void)
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
  801e38:	57                   	push   %edi
  801e39:	56                   	push   %esi
  801e3a:	53                   	push   %ebx
  801e3b:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801e3e:	68 0c 1c 80 00       	push   $0x801c0c
  801e43:	e8 0c 1a 00 00       	call   803854 <set_pgfault_handler>
  801e48:	b8 07 00 00 00       	mov    $0x7,%eax
  801e4d:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801e4f:	83 c4 10             	add    $0x10,%esp
  801e52:	85 c0                	test   %eax,%eax
  801e54:	78 2a                	js     801e80 <sfork+0x4b>
  801e56:	89 c7                	mov    %eax,%edi
  801e58:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801e5a:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801e5f:	75 58                	jne    801eb9 <sfork+0x84>
		thisenv = &envs[ENVX(sys_getenvid())];
  801e61:	e8 1d f9 ff ff       	call   801783 <sys_getenvid>
  801e66:	25 ff 03 00 00       	and    $0x3ff,%eax
  801e6b:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801e71:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801e76:	a3 28 64 80 00       	mov    %eax,0x806428
		return 0;
  801e7b:	e9 d4 00 00 00       	jmp    801f54 <sfork+0x11f>
		panic("the fork panic! at sys_exofork()\n");
  801e80:	83 ec 04             	sub    $0x4,%esp
  801e83:	68 28 43 80 00       	push   $0x804328
  801e88:	68 af 00 00 00       	push   $0xaf
  801e8d:	68 b9 42 80 00       	push   $0x8042b9
  801e92:	e8 f3 eb ff ff       	call   800a8a <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801e97:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801e9c:	89 f0                	mov    %esi,%eax
  801e9e:	e8 13 fc ff ff       	call   801ab6 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801ea3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801ea9:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801eaf:	77 65                	ja     801f16 <sfork+0xe1>
		if(i == (USTACKTOP - PGSIZE))
  801eb1:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801eb7:	74 de                	je     801e97 <sfork+0x62>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801eb9:	89 d8                	mov    %ebx,%eax
  801ebb:	c1 e8 16             	shr    $0x16,%eax
  801ebe:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801ec5:	a8 01                	test   $0x1,%al
  801ec7:	74 da                	je     801ea3 <sfork+0x6e>
  801ec9:	89 da                	mov    %ebx,%edx
  801ecb:	c1 ea 0c             	shr    $0xc,%edx
  801ece:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801ed5:	83 e0 05             	and    $0x5,%eax
  801ed8:	83 f8 05             	cmp    $0x5,%eax
  801edb:	75 c6                	jne    801ea3 <sfork+0x6e>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801edd:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801ee4:	c1 e2 0c             	shl    $0xc,%edx
  801ee7:	83 ec 0c             	sub    $0xc,%esp
  801eea:	83 e0 07             	and    $0x7,%eax
  801eed:	50                   	push   %eax
  801eee:	52                   	push   %edx
  801eef:	56                   	push   %esi
  801ef0:	52                   	push   %edx
  801ef1:	6a 00                	push   $0x0
  801ef3:	e8 0c f9 ff ff       	call   801804 <sys_page_map>
  801ef8:	83 c4 20             	add    $0x20,%esp
  801efb:	85 c0                	test   %eax,%eax
  801efd:	74 a4                	je     801ea3 <sfork+0x6e>
				panic("sys_page_map() panic\n");
  801eff:	83 ec 04             	sub    $0x4,%esp
  801f02:	68 a3 42 80 00       	push   $0x8042a3
  801f07:	68 ba 00 00 00       	push   $0xba
  801f0c:	68 b9 42 80 00       	push   $0x8042b9
  801f11:	e8 74 eb ff ff       	call   800a8a <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801f16:	83 ec 04             	sub    $0x4,%esp
  801f19:	6a 07                	push   $0x7
  801f1b:	68 00 f0 bf ee       	push   $0xeebff000
  801f20:	57                   	push   %edi
  801f21:	e8 9b f8 ff ff       	call   8017c1 <sys_page_alloc>
	if(ret < 0)
  801f26:	83 c4 10             	add    $0x10,%esp
  801f29:	85 c0                	test   %eax,%eax
  801f2b:	78 31                	js     801f5e <sfork+0x129>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801f2d:	83 ec 08             	sub    $0x8,%esp
  801f30:	68 c3 38 80 00       	push   $0x8038c3
  801f35:	57                   	push   %edi
  801f36:	e8 d1 f9 ff ff       	call   80190c <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801f3b:	83 c4 10             	add    $0x10,%esp
  801f3e:	85 c0                	test   %eax,%eax
  801f40:	78 33                	js     801f75 <sfork+0x140>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801f42:	83 ec 08             	sub    $0x8,%esp
  801f45:	6a 02                	push   $0x2
  801f47:	57                   	push   %edi
  801f48:	e8 3b f9 ff ff       	call   801888 <sys_env_set_status>
	if(ret < 0)
  801f4d:	83 c4 10             	add    $0x10,%esp
  801f50:	85 c0                	test   %eax,%eax
  801f52:	78 38                	js     801f8c <sfork+0x157>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801f54:	89 f8                	mov    %edi,%eax
  801f56:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f59:	5b                   	pop    %ebx
  801f5a:	5e                   	pop    %esi
  801f5b:	5f                   	pop    %edi
  801f5c:	5d                   	pop    %ebp
  801f5d:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801f5e:	83 ec 04             	sub    $0x4,%esp
  801f61:	68 d8 42 80 00       	push   $0x8042d8
  801f66:	68 c0 00 00 00       	push   $0xc0
  801f6b:	68 b9 42 80 00       	push   $0x8042b9
  801f70:	e8 15 eb ff ff       	call   800a8a <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801f75:	83 ec 04             	sub    $0x4,%esp
  801f78:	68 4c 43 80 00       	push   $0x80434c
  801f7d:	68 c3 00 00 00       	push   $0xc3
  801f82:	68 b9 42 80 00       	push   $0x8042b9
  801f87:	e8 fe ea ff ff       	call   800a8a <_panic>
		panic("panic in sys_env_set_status()\n");
  801f8c:	83 ec 04             	sub    $0x4,%esp
  801f8f:	68 74 43 80 00       	push   $0x804374
  801f94:	68 c6 00 00 00       	push   $0xc6
  801f99:	68 b9 42 80 00       	push   $0x8042b9
  801f9e:	e8 e7 ea ff ff       	call   800a8a <_panic>

00801fa3 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
  801fa6:	8b 55 08             	mov    0x8(%ebp),%edx
  801fa9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fac:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801faf:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  801fb1:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801fb4:	83 3a 01             	cmpl   $0x1,(%edx)
  801fb7:	7e 09                	jle    801fc2 <argstart+0x1f>
  801fb9:	ba a1 3c 80 00       	mov    $0x803ca1,%edx
  801fbe:	85 c9                	test   %ecx,%ecx
  801fc0:	75 05                	jne    801fc7 <argstart+0x24>
  801fc2:	ba 00 00 00 00       	mov    $0x0,%edx
  801fc7:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  801fca:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801fd1:	5d                   	pop    %ebp
  801fd2:	c3                   	ret    

00801fd3 <argnext>:

int
argnext(struct Argstate *args)
{
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
  801fd6:	53                   	push   %ebx
  801fd7:	83 ec 04             	sub    $0x4,%esp
  801fda:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801fdd:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801fe4:	8b 43 08             	mov    0x8(%ebx),%eax
  801fe7:	85 c0                	test   %eax,%eax
  801fe9:	74 72                	je     80205d <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  801feb:	80 38 00             	cmpb   $0x0,(%eax)
  801fee:	75 48                	jne    802038 <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801ff0:	8b 0b                	mov    (%ebx),%ecx
  801ff2:	83 39 01             	cmpl   $0x1,(%ecx)
  801ff5:	74 58                	je     80204f <argnext+0x7c>
		    || args->argv[1][0] != '-'
  801ff7:	8b 53 04             	mov    0x4(%ebx),%edx
  801ffa:	8b 42 04             	mov    0x4(%edx),%eax
  801ffd:	80 38 2d             	cmpb   $0x2d,(%eax)
  802000:	75 4d                	jne    80204f <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  802002:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  802006:	74 47                	je     80204f <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  802008:	83 c0 01             	add    $0x1,%eax
  80200b:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  80200e:	83 ec 04             	sub    $0x4,%esp
  802011:	8b 01                	mov    (%ecx),%eax
  802013:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  80201a:	50                   	push   %eax
  80201b:	8d 42 08             	lea    0x8(%edx),%eax
  80201e:	50                   	push   %eax
  80201f:	83 c2 04             	add    $0x4,%edx
  802022:	52                   	push   %edx
  802023:	e8 35 f5 ff ff       	call   80155d <memmove>
		(*args->argc)--;
  802028:	8b 03                	mov    (%ebx),%eax
  80202a:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  80202d:	8b 43 08             	mov    0x8(%ebx),%eax
  802030:	83 c4 10             	add    $0x10,%esp
  802033:	80 38 2d             	cmpb   $0x2d,(%eax)
  802036:	74 11                	je     802049 <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  802038:	8b 53 08             	mov    0x8(%ebx),%edx
  80203b:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  80203e:	83 c2 01             	add    $0x1,%edx
  802041:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  802044:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802047:	c9                   	leave  
  802048:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  802049:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  80204d:	75 e9                	jne    802038 <argnext+0x65>
	args->curarg = 0;
  80204f:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  802056:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80205b:	eb e7                	jmp    802044 <argnext+0x71>
		return -1;
  80205d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  802062:	eb e0                	jmp    802044 <argnext+0x71>

00802064 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  802064:	55                   	push   %ebp
  802065:	89 e5                	mov    %esp,%ebp
  802067:	53                   	push   %ebx
  802068:	83 ec 04             	sub    $0x4,%esp
  80206b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  80206e:	8b 43 08             	mov    0x8(%ebx),%eax
  802071:	85 c0                	test   %eax,%eax
  802073:	74 12                	je     802087 <argnextvalue+0x23>
		return 0;
	if (*args->curarg) {
  802075:	80 38 00             	cmpb   $0x0,(%eax)
  802078:	74 12                	je     80208c <argnextvalue+0x28>
		args->argvalue = args->curarg;
  80207a:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  80207d:	c7 43 08 a1 3c 80 00 	movl   $0x803ca1,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  802084:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  802087:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80208a:	c9                   	leave  
  80208b:	c3                   	ret    
	} else if (*args->argc > 1) {
  80208c:	8b 13                	mov    (%ebx),%edx
  80208e:	83 3a 01             	cmpl   $0x1,(%edx)
  802091:	7f 10                	jg     8020a3 <argnextvalue+0x3f>
		args->argvalue = 0;
  802093:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  80209a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  8020a1:	eb e1                	jmp    802084 <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  8020a3:	8b 43 04             	mov    0x4(%ebx),%eax
  8020a6:	8b 48 04             	mov    0x4(%eax),%ecx
  8020a9:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8020ac:	83 ec 04             	sub    $0x4,%esp
  8020af:	8b 12                	mov    (%edx),%edx
  8020b1:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  8020b8:	52                   	push   %edx
  8020b9:	8d 50 08             	lea    0x8(%eax),%edx
  8020bc:	52                   	push   %edx
  8020bd:	83 c0 04             	add    $0x4,%eax
  8020c0:	50                   	push   %eax
  8020c1:	e8 97 f4 ff ff       	call   80155d <memmove>
		(*args->argc)--;
  8020c6:	8b 03                	mov    (%ebx),%eax
  8020c8:	83 28 01             	subl   $0x1,(%eax)
  8020cb:	83 c4 10             	add    $0x10,%esp
  8020ce:	eb b4                	jmp    802084 <argnextvalue+0x20>

008020d0 <argvalue>:
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
  8020d3:	83 ec 08             	sub    $0x8,%esp
  8020d6:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8020d9:	8b 42 0c             	mov    0xc(%edx),%eax
  8020dc:	85 c0                	test   %eax,%eax
  8020de:	74 02                	je     8020e2 <argvalue+0x12>
}
  8020e0:	c9                   	leave  
  8020e1:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8020e2:	83 ec 0c             	sub    $0xc,%esp
  8020e5:	52                   	push   %edx
  8020e6:	e8 79 ff ff ff       	call   802064 <argnextvalue>
  8020eb:	83 c4 10             	add    $0x10,%esp
  8020ee:	eb f0                	jmp    8020e0 <argvalue+0x10>

008020f0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8020f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f6:	05 00 00 00 30       	add    $0x30000000,%eax
  8020fb:	c1 e8 0c             	shr    $0xc,%eax
}
  8020fe:	5d                   	pop    %ebp
  8020ff:	c3                   	ret    

00802100 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802103:	8b 45 08             	mov    0x8(%ebp),%eax
  802106:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80210b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802110:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  802115:	5d                   	pop    %ebp
  802116:	c3                   	ret    

00802117 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802117:	55                   	push   %ebp
  802118:	89 e5                	mov    %esp,%ebp
  80211a:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80211f:	89 c2                	mov    %eax,%edx
  802121:	c1 ea 16             	shr    $0x16,%edx
  802124:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80212b:	f6 c2 01             	test   $0x1,%dl
  80212e:	74 2d                	je     80215d <fd_alloc+0x46>
  802130:	89 c2                	mov    %eax,%edx
  802132:	c1 ea 0c             	shr    $0xc,%edx
  802135:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80213c:	f6 c2 01             	test   $0x1,%dl
  80213f:	74 1c                	je     80215d <fd_alloc+0x46>
  802141:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  802146:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80214b:	75 d2                	jne    80211f <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80214d:	8b 45 08             	mov    0x8(%ebp),%eax
  802150:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  802156:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80215b:	eb 0a                	jmp    802167 <fd_alloc+0x50>
			*fd_store = fd;
  80215d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802160:	89 01                	mov    %eax,(%ecx)
			return 0;
  802162:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802167:	5d                   	pop    %ebp
  802168:	c3                   	ret    

00802169 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802169:	55                   	push   %ebp
  80216a:	89 e5                	mov    %esp,%ebp
  80216c:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80216f:	83 f8 1f             	cmp    $0x1f,%eax
  802172:	77 30                	ja     8021a4 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  802174:	c1 e0 0c             	shl    $0xc,%eax
  802177:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80217c:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  802182:	f6 c2 01             	test   $0x1,%dl
  802185:	74 24                	je     8021ab <fd_lookup+0x42>
  802187:	89 c2                	mov    %eax,%edx
  802189:	c1 ea 0c             	shr    $0xc,%edx
  80218c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802193:	f6 c2 01             	test   $0x1,%dl
  802196:	74 1a                	je     8021b2 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  802198:	8b 55 0c             	mov    0xc(%ebp),%edx
  80219b:	89 02                	mov    %eax,(%edx)
	return 0;
  80219d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021a2:	5d                   	pop    %ebp
  8021a3:	c3                   	ret    
		return -E_INVAL;
  8021a4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021a9:	eb f7                	jmp    8021a2 <fd_lookup+0x39>
		return -E_INVAL;
  8021ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021b0:	eb f0                	jmp    8021a2 <fd_lookup+0x39>
  8021b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021b7:	eb e9                	jmp    8021a2 <fd_lookup+0x39>

008021b9 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8021b9:	55                   	push   %ebp
  8021ba:	89 e5                	mov    %esp,%ebp
  8021bc:	83 ec 08             	sub    $0x8,%esp
  8021bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8021c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8021c7:	b8 20 50 80 00       	mov    $0x805020,%eax
		if (devtab[i]->dev_id == dev_id) {
  8021cc:	39 08                	cmp    %ecx,(%eax)
  8021ce:	74 38                	je     802208 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8021d0:	83 c2 01             	add    $0x1,%edx
  8021d3:	8b 04 95 10 44 80 00 	mov    0x804410(,%edx,4),%eax
  8021da:	85 c0                	test   %eax,%eax
  8021dc:	75 ee                	jne    8021cc <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8021de:	a1 28 64 80 00       	mov    0x806428,%eax
  8021e3:	8b 40 48             	mov    0x48(%eax),%eax
  8021e6:	83 ec 04             	sub    $0x4,%esp
  8021e9:	51                   	push   %ecx
  8021ea:	50                   	push   %eax
  8021eb:	68 94 43 80 00       	push   $0x804394
  8021f0:	e8 8b e9 ff ff       	call   800b80 <cprintf>
	*dev = 0;
  8021f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8021fe:	83 c4 10             	add    $0x10,%esp
  802201:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802206:	c9                   	leave  
  802207:	c3                   	ret    
			*dev = devtab[i];
  802208:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80220b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80220d:	b8 00 00 00 00       	mov    $0x0,%eax
  802212:	eb f2                	jmp    802206 <dev_lookup+0x4d>

00802214 <fd_close>:
{
  802214:	55                   	push   %ebp
  802215:	89 e5                	mov    %esp,%ebp
  802217:	57                   	push   %edi
  802218:	56                   	push   %esi
  802219:	53                   	push   %ebx
  80221a:	83 ec 24             	sub    $0x24,%esp
  80221d:	8b 75 08             	mov    0x8(%ebp),%esi
  802220:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802223:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802226:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802227:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80222d:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802230:	50                   	push   %eax
  802231:	e8 33 ff ff ff       	call   802169 <fd_lookup>
  802236:	89 c3                	mov    %eax,%ebx
  802238:	83 c4 10             	add    $0x10,%esp
  80223b:	85 c0                	test   %eax,%eax
  80223d:	78 05                	js     802244 <fd_close+0x30>
	    || fd != fd2)
  80223f:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  802242:	74 16                	je     80225a <fd_close+0x46>
		return (must_exist ? r : 0);
  802244:	89 f8                	mov    %edi,%eax
  802246:	84 c0                	test   %al,%al
  802248:	b8 00 00 00 00       	mov    $0x0,%eax
  80224d:	0f 44 d8             	cmove  %eax,%ebx
}
  802250:	89 d8                	mov    %ebx,%eax
  802252:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802255:	5b                   	pop    %ebx
  802256:	5e                   	pop    %esi
  802257:	5f                   	pop    %edi
  802258:	5d                   	pop    %ebp
  802259:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80225a:	83 ec 08             	sub    $0x8,%esp
  80225d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802260:	50                   	push   %eax
  802261:	ff 36                	pushl  (%esi)
  802263:	e8 51 ff ff ff       	call   8021b9 <dev_lookup>
  802268:	89 c3                	mov    %eax,%ebx
  80226a:	83 c4 10             	add    $0x10,%esp
  80226d:	85 c0                	test   %eax,%eax
  80226f:	78 1a                	js     80228b <fd_close+0x77>
		if (dev->dev_close)
  802271:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802274:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  802277:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80227c:	85 c0                	test   %eax,%eax
  80227e:	74 0b                	je     80228b <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  802280:	83 ec 0c             	sub    $0xc,%esp
  802283:	56                   	push   %esi
  802284:	ff d0                	call   *%eax
  802286:	89 c3                	mov    %eax,%ebx
  802288:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80228b:	83 ec 08             	sub    $0x8,%esp
  80228e:	56                   	push   %esi
  80228f:	6a 00                	push   $0x0
  802291:	e8 b0 f5 ff ff       	call   801846 <sys_page_unmap>
	return r;
  802296:	83 c4 10             	add    $0x10,%esp
  802299:	eb b5                	jmp    802250 <fd_close+0x3c>

0080229b <close>:

int
close(int fdnum)
{
  80229b:	55                   	push   %ebp
  80229c:	89 e5                	mov    %esp,%ebp
  80229e:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022a4:	50                   	push   %eax
  8022a5:	ff 75 08             	pushl  0x8(%ebp)
  8022a8:	e8 bc fe ff ff       	call   802169 <fd_lookup>
  8022ad:	83 c4 10             	add    $0x10,%esp
  8022b0:	85 c0                	test   %eax,%eax
  8022b2:	79 02                	jns    8022b6 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8022b4:	c9                   	leave  
  8022b5:	c3                   	ret    
		return fd_close(fd, 1);
  8022b6:	83 ec 08             	sub    $0x8,%esp
  8022b9:	6a 01                	push   $0x1
  8022bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8022be:	e8 51 ff ff ff       	call   802214 <fd_close>
  8022c3:	83 c4 10             	add    $0x10,%esp
  8022c6:	eb ec                	jmp    8022b4 <close+0x19>

008022c8 <close_all>:

void
close_all(void)
{
  8022c8:	55                   	push   %ebp
  8022c9:	89 e5                	mov    %esp,%ebp
  8022cb:	53                   	push   %ebx
  8022cc:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8022cf:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8022d4:	83 ec 0c             	sub    $0xc,%esp
  8022d7:	53                   	push   %ebx
  8022d8:	e8 be ff ff ff       	call   80229b <close>
	for (i = 0; i < MAXFD; i++)
  8022dd:	83 c3 01             	add    $0x1,%ebx
  8022e0:	83 c4 10             	add    $0x10,%esp
  8022e3:	83 fb 20             	cmp    $0x20,%ebx
  8022e6:	75 ec                	jne    8022d4 <close_all+0xc>
}
  8022e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022eb:	c9                   	leave  
  8022ec:	c3                   	ret    

008022ed <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8022ed:	55                   	push   %ebp
  8022ee:	89 e5                	mov    %esp,%ebp
  8022f0:	57                   	push   %edi
  8022f1:	56                   	push   %esi
  8022f2:	53                   	push   %ebx
  8022f3:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8022f6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8022f9:	50                   	push   %eax
  8022fa:	ff 75 08             	pushl  0x8(%ebp)
  8022fd:	e8 67 fe ff ff       	call   802169 <fd_lookup>
  802302:	89 c3                	mov    %eax,%ebx
  802304:	83 c4 10             	add    $0x10,%esp
  802307:	85 c0                	test   %eax,%eax
  802309:	0f 88 81 00 00 00    	js     802390 <dup+0xa3>
		return r;
	close(newfdnum);
  80230f:	83 ec 0c             	sub    $0xc,%esp
  802312:	ff 75 0c             	pushl  0xc(%ebp)
  802315:	e8 81 ff ff ff       	call   80229b <close>

	newfd = INDEX2FD(newfdnum);
  80231a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80231d:	c1 e6 0c             	shl    $0xc,%esi
  802320:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  802326:	83 c4 04             	add    $0x4,%esp
  802329:	ff 75 e4             	pushl  -0x1c(%ebp)
  80232c:	e8 cf fd ff ff       	call   802100 <fd2data>
  802331:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  802333:	89 34 24             	mov    %esi,(%esp)
  802336:	e8 c5 fd ff ff       	call   802100 <fd2data>
  80233b:	83 c4 10             	add    $0x10,%esp
  80233e:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802340:	89 d8                	mov    %ebx,%eax
  802342:	c1 e8 16             	shr    $0x16,%eax
  802345:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80234c:	a8 01                	test   $0x1,%al
  80234e:	74 11                	je     802361 <dup+0x74>
  802350:	89 d8                	mov    %ebx,%eax
  802352:	c1 e8 0c             	shr    $0xc,%eax
  802355:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80235c:	f6 c2 01             	test   $0x1,%dl
  80235f:	75 39                	jne    80239a <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802361:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802364:	89 d0                	mov    %edx,%eax
  802366:	c1 e8 0c             	shr    $0xc,%eax
  802369:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802370:	83 ec 0c             	sub    $0xc,%esp
  802373:	25 07 0e 00 00       	and    $0xe07,%eax
  802378:	50                   	push   %eax
  802379:	56                   	push   %esi
  80237a:	6a 00                	push   $0x0
  80237c:	52                   	push   %edx
  80237d:	6a 00                	push   $0x0
  80237f:	e8 80 f4 ff ff       	call   801804 <sys_page_map>
  802384:	89 c3                	mov    %eax,%ebx
  802386:	83 c4 20             	add    $0x20,%esp
  802389:	85 c0                	test   %eax,%eax
  80238b:	78 31                	js     8023be <dup+0xd1>
		goto err;

	return newfdnum;
  80238d:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  802390:	89 d8                	mov    %ebx,%eax
  802392:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802395:	5b                   	pop    %ebx
  802396:	5e                   	pop    %esi
  802397:	5f                   	pop    %edi
  802398:	5d                   	pop    %ebp
  802399:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80239a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8023a1:	83 ec 0c             	sub    $0xc,%esp
  8023a4:	25 07 0e 00 00       	and    $0xe07,%eax
  8023a9:	50                   	push   %eax
  8023aa:	57                   	push   %edi
  8023ab:	6a 00                	push   $0x0
  8023ad:	53                   	push   %ebx
  8023ae:	6a 00                	push   $0x0
  8023b0:	e8 4f f4 ff ff       	call   801804 <sys_page_map>
  8023b5:	89 c3                	mov    %eax,%ebx
  8023b7:	83 c4 20             	add    $0x20,%esp
  8023ba:	85 c0                	test   %eax,%eax
  8023bc:	79 a3                	jns    802361 <dup+0x74>
	sys_page_unmap(0, newfd);
  8023be:	83 ec 08             	sub    $0x8,%esp
  8023c1:	56                   	push   %esi
  8023c2:	6a 00                	push   $0x0
  8023c4:	e8 7d f4 ff ff       	call   801846 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8023c9:	83 c4 08             	add    $0x8,%esp
  8023cc:	57                   	push   %edi
  8023cd:	6a 00                	push   $0x0
  8023cf:	e8 72 f4 ff ff       	call   801846 <sys_page_unmap>
	return r;
  8023d4:	83 c4 10             	add    $0x10,%esp
  8023d7:	eb b7                	jmp    802390 <dup+0xa3>

008023d9 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8023d9:	55                   	push   %ebp
  8023da:	89 e5                	mov    %esp,%ebp
  8023dc:	53                   	push   %ebx
  8023dd:	83 ec 1c             	sub    $0x1c,%esp
  8023e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8023e6:	50                   	push   %eax
  8023e7:	53                   	push   %ebx
  8023e8:	e8 7c fd ff ff       	call   802169 <fd_lookup>
  8023ed:	83 c4 10             	add    $0x10,%esp
  8023f0:	85 c0                	test   %eax,%eax
  8023f2:	78 3f                	js     802433 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023f4:	83 ec 08             	sub    $0x8,%esp
  8023f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023fa:	50                   	push   %eax
  8023fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023fe:	ff 30                	pushl  (%eax)
  802400:	e8 b4 fd ff ff       	call   8021b9 <dev_lookup>
  802405:	83 c4 10             	add    $0x10,%esp
  802408:	85 c0                	test   %eax,%eax
  80240a:	78 27                	js     802433 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80240c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80240f:	8b 42 08             	mov    0x8(%edx),%eax
  802412:	83 e0 03             	and    $0x3,%eax
  802415:	83 f8 01             	cmp    $0x1,%eax
  802418:	74 1e                	je     802438 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80241a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241d:	8b 40 08             	mov    0x8(%eax),%eax
  802420:	85 c0                	test   %eax,%eax
  802422:	74 35                	je     802459 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  802424:	83 ec 04             	sub    $0x4,%esp
  802427:	ff 75 10             	pushl  0x10(%ebp)
  80242a:	ff 75 0c             	pushl  0xc(%ebp)
  80242d:	52                   	push   %edx
  80242e:	ff d0                	call   *%eax
  802430:	83 c4 10             	add    $0x10,%esp
}
  802433:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802436:	c9                   	leave  
  802437:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802438:	a1 28 64 80 00       	mov    0x806428,%eax
  80243d:	8b 40 48             	mov    0x48(%eax),%eax
  802440:	83 ec 04             	sub    $0x4,%esp
  802443:	53                   	push   %ebx
  802444:	50                   	push   %eax
  802445:	68 d5 43 80 00       	push   $0x8043d5
  80244a:	e8 31 e7 ff ff       	call   800b80 <cprintf>
		return -E_INVAL;
  80244f:	83 c4 10             	add    $0x10,%esp
  802452:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802457:	eb da                	jmp    802433 <read+0x5a>
		return -E_NOT_SUPP;
  802459:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80245e:	eb d3                	jmp    802433 <read+0x5a>

00802460 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802460:	55                   	push   %ebp
  802461:	89 e5                	mov    %esp,%ebp
  802463:	57                   	push   %edi
  802464:	56                   	push   %esi
  802465:	53                   	push   %ebx
  802466:	83 ec 0c             	sub    $0xc,%esp
  802469:	8b 7d 08             	mov    0x8(%ebp),%edi
  80246c:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80246f:	bb 00 00 00 00       	mov    $0x0,%ebx
  802474:	39 f3                	cmp    %esi,%ebx
  802476:	73 23                	jae    80249b <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802478:	83 ec 04             	sub    $0x4,%esp
  80247b:	89 f0                	mov    %esi,%eax
  80247d:	29 d8                	sub    %ebx,%eax
  80247f:	50                   	push   %eax
  802480:	89 d8                	mov    %ebx,%eax
  802482:	03 45 0c             	add    0xc(%ebp),%eax
  802485:	50                   	push   %eax
  802486:	57                   	push   %edi
  802487:	e8 4d ff ff ff       	call   8023d9 <read>
		if (m < 0)
  80248c:	83 c4 10             	add    $0x10,%esp
  80248f:	85 c0                	test   %eax,%eax
  802491:	78 06                	js     802499 <readn+0x39>
			return m;
		if (m == 0)
  802493:	74 06                	je     80249b <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  802495:	01 c3                	add    %eax,%ebx
  802497:	eb db                	jmp    802474 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802499:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80249b:	89 d8                	mov    %ebx,%eax
  80249d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024a0:	5b                   	pop    %ebx
  8024a1:	5e                   	pop    %esi
  8024a2:	5f                   	pop    %edi
  8024a3:	5d                   	pop    %ebp
  8024a4:	c3                   	ret    

008024a5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8024a5:	55                   	push   %ebp
  8024a6:	89 e5                	mov    %esp,%ebp
  8024a8:	53                   	push   %ebx
  8024a9:	83 ec 1c             	sub    $0x1c,%esp
  8024ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024af:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8024b2:	50                   	push   %eax
  8024b3:	53                   	push   %ebx
  8024b4:	e8 b0 fc ff ff       	call   802169 <fd_lookup>
  8024b9:	83 c4 10             	add    $0x10,%esp
  8024bc:	85 c0                	test   %eax,%eax
  8024be:	78 3a                	js     8024fa <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024c0:	83 ec 08             	sub    $0x8,%esp
  8024c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024c6:	50                   	push   %eax
  8024c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ca:	ff 30                	pushl  (%eax)
  8024cc:	e8 e8 fc ff ff       	call   8021b9 <dev_lookup>
  8024d1:	83 c4 10             	add    $0x10,%esp
  8024d4:	85 c0                	test   %eax,%eax
  8024d6:	78 22                	js     8024fa <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8024d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024db:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8024df:	74 1e                	je     8024ff <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8024e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e4:	8b 52 0c             	mov    0xc(%edx),%edx
  8024e7:	85 d2                	test   %edx,%edx
  8024e9:	74 35                	je     802520 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8024eb:	83 ec 04             	sub    $0x4,%esp
  8024ee:	ff 75 10             	pushl  0x10(%ebp)
  8024f1:	ff 75 0c             	pushl  0xc(%ebp)
  8024f4:	50                   	push   %eax
  8024f5:	ff d2                	call   *%edx
  8024f7:	83 c4 10             	add    $0x10,%esp
}
  8024fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024fd:	c9                   	leave  
  8024fe:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8024ff:	a1 28 64 80 00       	mov    0x806428,%eax
  802504:	8b 40 48             	mov    0x48(%eax),%eax
  802507:	83 ec 04             	sub    $0x4,%esp
  80250a:	53                   	push   %ebx
  80250b:	50                   	push   %eax
  80250c:	68 f1 43 80 00       	push   $0x8043f1
  802511:	e8 6a e6 ff ff       	call   800b80 <cprintf>
		return -E_INVAL;
  802516:	83 c4 10             	add    $0x10,%esp
  802519:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80251e:	eb da                	jmp    8024fa <write+0x55>
		return -E_NOT_SUPP;
  802520:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802525:	eb d3                	jmp    8024fa <write+0x55>

00802527 <seek>:

int
seek(int fdnum, off_t offset)
{
  802527:	55                   	push   %ebp
  802528:	89 e5                	mov    %esp,%ebp
  80252a:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80252d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802530:	50                   	push   %eax
  802531:	ff 75 08             	pushl  0x8(%ebp)
  802534:	e8 30 fc ff ff       	call   802169 <fd_lookup>
  802539:	83 c4 10             	add    $0x10,%esp
  80253c:	85 c0                	test   %eax,%eax
  80253e:	78 0e                	js     80254e <seek+0x27>
		return r;
	fd->fd_offset = offset;
  802540:	8b 55 0c             	mov    0xc(%ebp),%edx
  802543:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802546:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802549:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80254e:	c9                   	leave  
  80254f:	c3                   	ret    

00802550 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802550:	55                   	push   %ebp
  802551:	89 e5                	mov    %esp,%ebp
  802553:	53                   	push   %ebx
  802554:	83 ec 1c             	sub    $0x1c,%esp
  802557:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80255a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80255d:	50                   	push   %eax
  80255e:	53                   	push   %ebx
  80255f:	e8 05 fc ff ff       	call   802169 <fd_lookup>
  802564:	83 c4 10             	add    $0x10,%esp
  802567:	85 c0                	test   %eax,%eax
  802569:	78 37                	js     8025a2 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80256b:	83 ec 08             	sub    $0x8,%esp
  80256e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802571:	50                   	push   %eax
  802572:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802575:	ff 30                	pushl  (%eax)
  802577:	e8 3d fc ff ff       	call   8021b9 <dev_lookup>
  80257c:	83 c4 10             	add    $0x10,%esp
  80257f:	85 c0                	test   %eax,%eax
  802581:	78 1f                	js     8025a2 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802583:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802586:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80258a:	74 1b                	je     8025a7 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80258c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80258f:	8b 52 18             	mov    0x18(%edx),%edx
  802592:	85 d2                	test   %edx,%edx
  802594:	74 32                	je     8025c8 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  802596:	83 ec 08             	sub    $0x8,%esp
  802599:	ff 75 0c             	pushl  0xc(%ebp)
  80259c:	50                   	push   %eax
  80259d:	ff d2                	call   *%edx
  80259f:	83 c4 10             	add    $0x10,%esp
}
  8025a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025a5:	c9                   	leave  
  8025a6:	c3                   	ret    
			thisenv->env_id, fdnum);
  8025a7:	a1 28 64 80 00       	mov    0x806428,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8025ac:	8b 40 48             	mov    0x48(%eax),%eax
  8025af:	83 ec 04             	sub    $0x4,%esp
  8025b2:	53                   	push   %ebx
  8025b3:	50                   	push   %eax
  8025b4:	68 b4 43 80 00       	push   $0x8043b4
  8025b9:	e8 c2 e5 ff ff       	call   800b80 <cprintf>
		return -E_INVAL;
  8025be:	83 c4 10             	add    $0x10,%esp
  8025c1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025c6:	eb da                	jmp    8025a2 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8025c8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8025cd:	eb d3                	jmp    8025a2 <ftruncate+0x52>

008025cf <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8025cf:	55                   	push   %ebp
  8025d0:	89 e5                	mov    %esp,%ebp
  8025d2:	53                   	push   %ebx
  8025d3:	83 ec 1c             	sub    $0x1c,%esp
  8025d6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025d9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8025dc:	50                   	push   %eax
  8025dd:	ff 75 08             	pushl  0x8(%ebp)
  8025e0:	e8 84 fb ff ff       	call   802169 <fd_lookup>
  8025e5:	83 c4 10             	add    $0x10,%esp
  8025e8:	85 c0                	test   %eax,%eax
  8025ea:	78 4b                	js     802637 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025ec:	83 ec 08             	sub    $0x8,%esp
  8025ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025f2:	50                   	push   %eax
  8025f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f6:	ff 30                	pushl  (%eax)
  8025f8:	e8 bc fb ff ff       	call   8021b9 <dev_lookup>
  8025fd:	83 c4 10             	add    $0x10,%esp
  802600:	85 c0                	test   %eax,%eax
  802602:	78 33                	js     802637 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  802604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802607:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80260b:	74 2f                	je     80263c <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80260d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802610:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  802617:	00 00 00 
	stat->st_isdir = 0;
  80261a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802621:	00 00 00 
	stat->st_dev = dev;
  802624:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80262a:	83 ec 08             	sub    $0x8,%esp
  80262d:	53                   	push   %ebx
  80262e:	ff 75 f0             	pushl  -0x10(%ebp)
  802631:	ff 50 14             	call   *0x14(%eax)
  802634:	83 c4 10             	add    $0x10,%esp
}
  802637:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80263a:	c9                   	leave  
  80263b:	c3                   	ret    
		return -E_NOT_SUPP;
  80263c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802641:	eb f4                	jmp    802637 <fstat+0x68>

00802643 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802643:	55                   	push   %ebp
  802644:	89 e5                	mov    %esp,%ebp
  802646:	56                   	push   %esi
  802647:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802648:	83 ec 08             	sub    $0x8,%esp
  80264b:	6a 00                	push   $0x0
  80264d:	ff 75 08             	pushl  0x8(%ebp)
  802650:	e8 22 02 00 00       	call   802877 <open>
  802655:	89 c3                	mov    %eax,%ebx
  802657:	83 c4 10             	add    $0x10,%esp
  80265a:	85 c0                	test   %eax,%eax
  80265c:	78 1b                	js     802679 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80265e:	83 ec 08             	sub    $0x8,%esp
  802661:	ff 75 0c             	pushl  0xc(%ebp)
  802664:	50                   	push   %eax
  802665:	e8 65 ff ff ff       	call   8025cf <fstat>
  80266a:	89 c6                	mov    %eax,%esi
	close(fd);
  80266c:	89 1c 24             	mov    %ebx,(%esp)
  80266f:	e8 27 fc ff ff       	call   80229b <close>
	return r;
  802674:	83 c4 10             	add    $0x10,%esp
  802677:	89 f3                	mov    %esi,%ebx
}
  802679:	89 d8                	mov    %ebx,%eax
  80267b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80267e:	5b                   	pop    %ebx
  80267f:	5e                   	pop    %esi
  802680:	5d                   	pop    %ebp
  802681:	c3                   	ret    

00802682 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802682:	55                   	push   %ebp
  802683:	89 e5                	mov    %esp,%ebp
  802685:	56                   	push   %esi
  802686:	53                   	push   %ebx
  802687:	89 c6                	mov    %eax,%esi
  802689:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80268b:	83 3d 20 64 80 00 00 	cmpl   $0x0,0x806420
  802692:	74 27                	je     8026bb <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802694:	6a 07                	push   $0x7
  802696:	68 00 70 80 00       	push   $0x807000
  80269b:	56                   	push   %esi
  80269c:	ff 35 20 64 80 00    	pushl  0x806420
  8026a2:	e8 ab 12 00 00       	call   803952 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8026a7:	83 c4 0c             	add    $0xc,%esp
  8026aa:	6a 00                	push   $0x0
  8026ac:	53                   	push   %ebx
  8026ad:	6a 00                	push   $0x0
  8026af:	e8 35 12 00 00       	call   8038e9 <ipc_recv>
}
  8026b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026b7:	5b                   	pop    %ebx
  8026b8:	5e                   	pop    %esi
  8026b9:	5d                   	pop    %ebp
  8026ba:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8026bb:	83 ec 0c             	sub    $0xc,%esp
  8026be:	6a 01                	push   $0x1
  8026c0:	e8 e5 12 00 00       	call   8039aa <ipc_find_env>
  8026c5:	a3 20 64 80 00       	mov    %eax,0x806420
  8026ca:	83 c4 10             	add    $0x10,%esp
  8026cd:	eb c5                	jmp    802694 <fsipc+0x12>

008026cf <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8026cf:	55                   	push   %ebp
  8026d0:	89 e5                	mov    %esp,%ebp
  8026d2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8026d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026db:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  8026e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026e3:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8026e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8026ed:	b8 02 00 00 00       	mov    $0x2,%eax
  8026f2:	e8 8b ff ff ff       	call   802682 <fsipc>
}
  8026f7:	c9                   	leave  
  8026f8:	c3                   	ret    

008026f9 <devfile_flush>:
{
  8026f9:	55                   	push   %ebp
  8026fa:	89 e5                	mov    %esp,%ebp
  8026fc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8026ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802702:	8b 40 0c             	mov    0xc(%eax),%eax
  802705:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  80270a:	ba 00 00 00 00       	mov    $0x0,%edx
  80270f:	b8 06 00 00 00       	mov    $0x6,%eax
  802714:	e8 69 ff ff ff       	call   802682 <fsipc>
}
  802719:	c9                   	leave  
  80271a:	c3                   	ret    

0080271b <devfile_stat>:
{
  80271b:	55                   	push   %ebp
  80271c:	89 e5                	mov    %esp,%ebp
  80271e:	53                   	push   %ebx
  80271f:	83 ec 04             	sub    $0x4,%esp
  802722:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802725:	8b 45 08             	mov    0x8(%ebp),%eax
  802728:	8b 40 0c             	mov    0xc(%eax),%eax
  80272b:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802730:	ba 00 00 00 00       	mov    $0x0,%edx
  802735:	b8 05 00 00 00       	mov    $0x5,%eax
  80273a:	e8 43 ff ff ff       	call   802682 <fsipc>
  80273f:	85 c0                	test   %eax,%eax
  802741:	78 2c                	js     80276f <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802743:	83 ec 08             	sub    $0x8,%esp
  802746:	68 00 70 80 00       	push   $0x807000
  80274b:	53                   	push   %ebx
  80274c:	e8 7e ec ff ff       	call   8013cf <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  802751:	a1 80 70 80 00       	mov    0x807080,%eax
  802756:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80275c:	a1 84 70 80 00       	mov    0x807084,%eax
  802761:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  802767:	83 c4 10             	add    $0x10,%esp
  80276a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80276f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802772:	c9                   	leave  
  802773:	c3                   	ret    

00802774 <devfile_write>:
{
  802774:	55                   	push   %ebp
  802775:	89 e5                	mov    %esp,%ebp
  802777:	53                   	push   %ebx
  802778:	83 ec 08             	sub    $0x8,%esp
  80277b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80277e:	8b 45 08             	mov    0x8(%ebp),%eax
  802781:	8b 40 0c             	mov    0xc(%eax),%eax
  802784:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.write.req_n = n;
  802789:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80278f:	53                   	push   %ebx
  802790:	ff 75 0c             	pushl  0xc(%ebp)
  802793:	68 08 70 80 00       	push   $0x807008
  802798:	e8 22 ee ff ff       	call   8015bf <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80279d:	ba 00 00 00 00       	mov    $0x0,%edx
  8027a2:	b8 04 00 00 00       	mov    $0x4,%eax
  8027a7:	e8 d6 fe ff ff       	call   802682 <fsipc>
  8027ac:	83 c4 10             	add    $0x10,%esp
  8027af:	85 c0                	test   %eax,%eax
  8027b1:	78 0b                	js     8027be <devfile_write+0x4a>
	assert(r <= n);
  8027b3:	39 d8                	cmp    %ebx,%eax
  8027b5:	77 0c                	ja     8027c3 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8027b7:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8027bc:	7f 1e                	jg     8027dc <devfile_write+0x68>
}
  8027be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027c1:	c9                   	leave  
  8027c2:	c3                   	ret    
	assert(r <= n);
  8027c3:	68 24 44 80 00       	push   $0x804424
  8027c8:	68 cf 3d 80 00       	push   $0x803dcf
  8027cd:	68 98 00 00 00       	push   $0x98
  8027d2:	68 2b 44 80 00       	push   $0x80442b
  8027d7:	e8 ae e2 ff ff       	call   800a8a <_panic>
	assert(r <= PGSIZE);
  8027dc:	68 36 44 80 00       	push   $0x804436
  8027e1:	68 cf 3d 80 00       	push   $0x803dcf
  8027e6:	68 99 00 00 00       	push   $0x99
  8027eb:	68 2b 44 80 00       	push   $0x80442b
  8027f0:	e8 95 e2 ff ff       	call   800a8a <_panic>

008027f5 <devfile_read>:
{
  8027f5:	55                   	push   %ebp
  8027f6:	89 e5                	mov    %esp,%ebp
  8027f8:	56                   	push   %esi
  8027f9:	53                   	push   %ebx
  8027fa:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8027fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802800:	8b 40 0c             	mov    0xc(%eax),%eax
  802803:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  802808:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80280e:	ba 00 00 00 00       	mov    $0x0,%edx
  802813:	b8 03 00 00 00       	mov    $0x3,%eax
  802818:	e8 65 fe ff ff       	call   802682 <fsipc>
  80281d:	89 c3                	mov    %eax,%ebx
  80281f:	85 c0                	test   %eax,%eax
  802821:	78 1f                	js     802842 <devfile_read+0x4d>
	assert(r <= n);
  802823:	39 f0                	cmp    %esi,%eax
  802825:	77 24                	ja     80284b <devfile_read+0x56>
	assert(r <= PGSIZE);
  802827:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80282c:	7f 33                	jg     802861 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80282e:	83 ec 04             	sub    $0x4,%esp
  802831:	50                   	push   %eax
  802832:	68 00 70 80 00       	push   $0x807000
  802837:	ff 75 0c             	pushl  0xc(%ebp)
  80283a:	e8 1e ed ff ff       	call   80155d <memmove>
	return r;
  80283f:	83 c4 10             	add    $0x10,%esp
}
  802842:	89 d8                	mov    %ebx,%eax
  802844:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802847:	5b                   	pop    %ebx
  802848:	5e                   	pop    %esi
  802849:	5d                   	pop    %ebp
  80284a:	c3                   	ret    
	assert(r <= n);
  80284b:	68 24 44 80 00       	push   $0x804424
  802850:	68 cf 3d 80 00       	push   $0x803dcf
  802855:	6a 7c                	push   $0x7c
  802857:	68 2b 44 80 00       	push   $0x80442b
  80285c:	e8 29 e2 ff ff       	call   800a8a <_panic>
	assert(r <= PGSIZE);
  802861:	68 36 44 80 00       	push   $0x804436
  802866:	68 cf 3d 80 00       	push   $0x803dcf
  80286b:	6a 7d                	push   $0x7d
  80286d:	68 2b 44 80 00       	push   $0x80442b
  802872:	e8 13 e2 ff ff       	call   800a8a <_panic>

00802877 <open>:
{
  802877:	55                   	push   %ebp
  802878:	89 e5                	mov    %esp,%ebp
  80287a:	56                   	push   %esi
  80287b:	53                   	push   %ebx
  80287c:	83 ec 1c             	sub    $0x1c,%esp
  80287f:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  802882:	56                   	push   %esi
  802883:	e8 0e eb ff ff       	call   801396 <strlen>
  802888:	83 c4 10             	add    $0x10,%esp
  80288b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802890:	7f 6c                	jg     8028fe <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  802892:	83 ec 0c             	sub    $0xc,%esp
  802895:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802898:	50                   	push   %eax
  802899:	e8 79 f8 ff ff       	call   802117 <fd_alloc>
  80289e:	89 c3                	mov    %eax,%ebx
  8028a0:	83 c4 10             	add    $0x10,%esp
  8028a3:	85 c0                	test   %eax,%eax
  8028a5:	78 3c                	js     8028e3 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8028a7:	83 ec 08             	sub    $0x8,%esp
  8028aa:	56                   	push   %esi
  8028ab:	68 00 70 80 00       	push   $0x807000
  8028b0:	e8 1a eb ff ff       	call   8013cf <strcpy>
	fsipcbuf.open.req_omode = mode;
  8028b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028b8:	a3 00 74 80 00       	mov    %eax,0x807400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8028bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c0:	b8 01 00 00 00       	mov    $0x1,%eax
  8028c5:	e8 b8 fd ff ff       	call   802682 <fsipc>
  8028ca:	89 c3                	mov    %eax,%ebx
  8028cc:	83 c4 10             	add    $0x10,%esp
  8028cf:	85 c0                	test   %eax,%eax
  8028d1:	78 19                	js     8028ec <open+0x75>
	return fd2num(fd);
  8028d3:	83 ec 0c             	sub    $0xc,%esp
  8028d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8028d9:	e8 12 f8 ff ff       	call   8020f0 <fd2num>
  8028de:	89 c3                	mov    %eax,%ebx
  8028e0:	83 c4 10             	add    $0x10,%esp
}
  8028e3:	89 d8                	mov    %ebx,%eax
  8028e5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8028e8:	5b                   	pop    %ebx
  8028e9:	5e                   	pop    %esi
  8028ea:	5d                   	pop    %ebp
  8028eb:	c3                   	ret    
		fd_close(fd, 0);
  8028ec:	83 ec 08             	sub    $0x8,%esp
  8028ef:	6a 00                	push   $0x0
  8028f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8028f4:	e8 1b f9 ff ff       	call   802214 <fd_close>
		return r;
  8028f9:	83 c4 10             	add    $0x10,%esp
  8028fc:	eb e5                	jmp    8028e3 <open+0x6c>
		return -E_BAD_PATH;
  8028fe:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  802903:	eb de                	jmp    8028e3 <open+0x6c>

00802905 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802905:	55                   	push   %ebp
  802906:	89 e5                	mov    %esp,%ebp
  802908:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80290b:	ba 00 00 00 00       	mov    $0x0,%edx
  802910:	b8 08 00 00 00       	mov    $0x8,%eax
  802915:	e8 68 fd ff ff       	call   802682 <fsipc>
}
  80291a:	c9                   	leave  
  80291b:	c3                   	ret    

0080291c <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  80291c:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  802920:	7f 01                	jg     802923 <writebuf+0x7>
  802922:	c3                   	ret    
{
  802923:	55                   	push   %ebp
  802924:	89 e5                	mov    %esp,%ebp
  802926:	53                   	push   %ebx
  802927:	83 ec 08             	sub    $0x8,%esp
  80292a:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  80292c:	ff 70 04             	pushl  0x4(%eax)
  80292f:	8d 40 10             	lea    0x10(%eax),%eax
  802932:	50                   	push   %eax
  802933:	ff 33                	pushl  (%ebx)
  802935:	e8 6b fb ff ff       	call   8024a5 <write>
		if (result > 0)
  80293a:	83 c4 10             	add    $0x10,%esp
  80293d:	85 c0                	test   %eax,%eax
  80293f:	7e 03                	jle    802944 <writebuf+0x28>
			b->result += result;
  802941:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  802944:	39 43 04             	cmp    %eax,0x4(%ebx)
  802947:	74 0d                	je     802956 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  802949:	85 c0                	test   %eax,%eax
  80294b:	ba 00 00 00 00       	mov    $0x0,%edx
  802950:	0f 4f c2             	cmovg  %edx,%eax
  802953:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  802956:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802959:	c9                   	leave  
  80295a:	c3                   	ret    

0080295b <putch>:

static void
putch(int ch, void *thunk)
{
  80295b:	55                   	push   %ebp
  80295c:	89 e5                	mov    %esp,%ebp
  80295e:	53                   	push   %ebx
  80295f:	83 ec 04             	sub    $0x4,%esp
  802962:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  802965:	8b 53 04             	mov    0x4(%ebx),%edx
  802968:	8d 42 01             	lea    0x1(%edx),%eax
  80296b:	89 43 04             	mov    %eax,0x4(%ebx)
  80296e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802971:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  802975:	3d 00 01 00 00       	cmp    $0x100,%eax
  80297a:	74 06                	je     802982 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  80297c:	83 c4 04             	add    $0x4,%esp
  80297f:	5b                   	pop    %ebx
  802980:	5d                   	pop    %ebp
  802981:	c3                   	ret    
		writebuf(b);
  802982:	89 d8                	mov    %ebx,%eax
  802984:	e8 93 ff ff ff       	call   80291c <writebuf>
		b->idx = 0;
  802989:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  802990:	eb ea                	jmp    80297c <putch+0x21>

00802992 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802992:	55                   	push   %ebp
  802993:	89 e5                	mov    %esp,%ebp
  802995:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  80299b:	8b 45 08             	mov    0x8(%ebp),%eax
  80299e:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8029a4:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8029ab:	00 00 00 
	b.result = 0;
  8029ae:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8029b5:	00 00 00 
	b.error = 1;
  8029b8:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8029bf:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8029c2:	ff 75 10             	pushl  0x10(%ebp)
  8029c5:	ff 75 0c             	pushl  0xc(%ebp)
  8029c8:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8029ce:	50                   	push   %eax
  8029cf:	68 5b 29 80 00       	push   $0x80295b
  8029d4:	e8 d4 e2 ff ff       	call   800cad <vprintfmt>
	if (b.idx > 0)
  8029d9:	83 c4 10             	add    $0x10,%esp
  8029dc:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  8029e3:	7f 11                	jg     8029f6 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  8029e5:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8029eb:	85 c0                	test   %eax,%eax
  8029ed:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  8029f4:	c9                   	leave  
  8029f5:	c3                   	ret    
		writebuf(&b);
  8029f6:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8029fc:	e8 1b ff ff ff       	call   80291c <writebuf>
  802a01:	eb e2                	jmp    8029e5 <vfprintf+0x53>

00802a03 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802a03:	55                   	push   %ebp
  802a04:	89 e5                	mov    %esp,%ebp
  802a06:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802a09:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  802a0c:	50                   	push   %eax
  802a0d:	ff 75 0c             	pushl  0xc(%ebp)
  802a10:	ff 75 08             	pushl  0x8(%ebp)
  802a13:	e8 7a ff ff ff       	call   802992 <vfprintf>
	va_end(ap);

	return cnt;
}
  802a18:	c9                   	leave  
  802a19:	c3                   	ret    

00802a1a <printf>:

int
printf(const char *fmt, ...)
{
  802a1a:	55                   	push   %ebp
  802a1b:	89 e5                	mov    %esp,%ebp
  802a1d:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802a20:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  802a23:	50                   	push   %eax
  802a24:	ff 75 08             	pushl  0x8(%ebp)
  802a27:	6a 01                	push   $0x1
  802a29:	e8 64 ff ff ff       	call   802992 <vfprintf>
	va_end(ap);

	return cnt;
}
  802a2e:	c9                   	leave  
  802a2f:	c3                   	ret    

00802a30 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802a30:	55                   	push   %ebp
  802a31:	89 e5                	mov    %esp,%ebp
  802a33:	57                   	push   %edi
  802a34:	56                   	push   %esi
  802a35:	53                   	push   %ebx
  802a36:	81 ec 94 02 00 00    	sub    $0x294,%esp
	cprintf("in %s\n", __FUNCTION__);
  802a3c:	68 18 45 80 00       	push   $0x804518
  802a41:	68 a3 3e 80 00       	push   $0x803ea3
  802a46:	e8 35 e1 ff ff       	call   800b80 <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802a4b:	83 c4 08             	add    $0x8,%esp
  802a4e:	6a 00                	push   $0x0
  802a50:	ff 75 08             	pushl  0x8(%ebp)
  802a53:	e8 1f fe ff ff       	call   802877 <open>
  802a58:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802a5e:	83 c4 10             	add    $0x10,%esp
  802a61:	85 c0                	test   %eax,%eax
  802a63:	0f 88 0b 05 00 00    	js     802f74 <spawn+0x544>
  802a69:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802a6b:	83 ec 04             	sub    $0x4,%esp
  802a6e:	68 00 02 00 00       	push   $0x200
  802a73:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  802a79:	50                   	push   %eax
  802a7a:	51                   	push   %ecx
  802a7b:	e8 e0 f9 ff ff       	call   802460 <readn>
  802a80:	83 c4 10             	add    $0x10,%esp
  802a83:	3d 00 02 00 00       	cmp    $0x200,%eax
  802a88:	75 75                	jne    802aff <spawn+0xcf>
	    || elf->e_magic != ELF_MAGIC) {
  802a8a:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  802a91:	45 4c 46 
  802a94:	75 69                	jne    802aff <spawn+0xcf>
  802a96:	b8 07 00 00 00       	mov    $0x7,%eax
  802a9b:	cd 30                	int    $0x30
  802a9d:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  802aa3:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802aa9:	85 c0                	test   %eax,%eax
  802aab:	0f 88 b7 04 00 00    	js     802f68 <spawn+0x538>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802ab1:	25 ff 03 00 00       	and    $0x3ff,%eax
  802ab6:	69 f0 84 00 00 00    	imul   $0x84,%eax,%esi
  802abc:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  802ac2:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  802ac8:	b9 11 00 00 00       	mov    $0x11,%ecx
  802acd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  802acf:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802ad5:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
	cprintf("in %s\n", __FUNCTION__);
  802adb:	83 ec 08             	sub    $0x8,%esp
  802ade:	68 0c 45 80 00       	push   $0x80450c
  802ae3:	68 a3 3e 80 00       	push   $0x803ea3
  802ae8:	e8 93 e0 ff ff       	call   800b80 <cprintf>
  802aed:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802af0:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  802af5:	be 00 00 00 00       	mov    $0x0,%esi
  802afa:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802afd:	eb 4b                	jmp    802b4a <spawn+0x11a>
		close(fd);
  802aff:	83 ec 0c             	sub    $0xc,%esp
  802b02:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802b08:	e8 8e f7 ff ff       	call   80229b <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802b0d:	83 c4 0c             	add    $0xc,%esp
  802b10:	68 7f 45 4c 46       	push   $0x464c457f
  802b15:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  802b1b:	68 42 44 80 00       	push   $0x804442
  802b20:	e8 5b e0 ff ff       	call   800b80 <cprintf>
		return -E_NOT_EXEC;
  802b25:	83 c4 10             	add    $0x10,%esp
  802b28:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  802b2f:	ff ff ff 
  802b32:	e9 3d 04 00 00       	jmp    802f74 <spawn+0x544>
		string_size += strlen(argv[argc]) + 1;
  802b37:	83 ec 0c             	sub    $0xc,%esp
  802b3a:	50                   	push   %eax
  802b3b:	e8 56 e8 ff ff       	call   801396 <strlen>
  802b40:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  802b44:	83 c3 01             	add    $0x1,%ebx
  802b47:	83 c4 10             	add    $0x10,%esp
  802b4a:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  802b51:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  802b54:	85 c0                	test   %eax,%eax
  802b56:	75 df                	jne    802b37 <spawn+0x107>
  802b58:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  802b5e:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  802b64:	bf 00 10 40 00       	mov    $0x401000,%edi
  802b69:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802b6b:	89 fa                	mov    %edi,%edx
  802b6d:	83 e2 fc             	and    $0xfffffffc,%edx
  802b70:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  802b77:	29 c2                	sub    %eax,%edx
  802b79:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802b7f:	8d 42 f8             	lea    -0x8(%edx),%eax
  802b82:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802b87:	0f 86 0a 04 00 00    	jbe    802f97 <spawn+0x567>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802b8d:	83 ec 04             	sub    $0x4,%esp
  802b90:	6a 07                	push   $0x7
  802b92:	68 00 00 40 00       	push   $0x400000
  802b97:	6a 00                	push   $0x0
  802b99:	e8 23 ec ff ff       	call   8017c1 <sys_page_alloc>
  802b9e:	83 c4 10             	add    $0x10,%esp
  802ba1:	85 c0                	test   %eax,%eax
  802ba3:	0f 88 f3 03 00 00    	js     802f9c <spawn+0x56c>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802ba9:	be 00 00 00 00       	mov    $0x0,%esi
  802bae:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  802bb4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802bb7:	eb 30                	jmp    802be9 <spawn+0x1b9>
		argv_store[i] = UTEMP2USTACK(string_store);
  802bb9:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802bbf:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  802bc5:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  802bc8:	83 ec 08             	sub    $0x8,%esp
  802bcb:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802bce:	57                   	push   %edi
  802bcf:	e8 fb e7 ff ff       	call   8013cf <strcpy>
		string_store += strlen(argv[i]) + 1;
  802bd4:	83 c4 04             	add    $0x4,%esp
  802bd7:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802bda:	e8 b7 e7 ff ff       	call   801396 <strlen>
  802bdf:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  802be3:	83 c6 01             	add    $0x1,%esi
  802be6:	83 c4 10             	add    $0x10,%esp
  802be9:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  802bef:	7f c8                	jg     802bb9 <spawn+0x189>
	}
	argv_store[argc] = 0;
  802bf1:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802bf7:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  802bfd:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  802c04:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  802c0a:	0f 85 86 00 00 00    	jne    802c96 <spawn+0x266>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802c10:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  802c16:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  802c1c:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  802c1f:	89 d0                	mov    %edx,%eax
  802c21:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  802c27:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802c2a:	2d 08 30 80 11       	sub    $0x11803008,%eax
  802c2f:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802c35:	83 ec 0c             	sub    $0xc,%esp
  802c38:	6a 07                	push   $0x7
  802c3a:	68 00 d0 bf ee       	push   $0xeebfd000
  802c3f:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802c45:	68 00 00 40 00       	push   $0x400000
  802c4a:	6a 00                	push   $0x0
  802c4c:	e8 b3 eb ff ff       	call   801804 <sys_page_map>
  802c51:	89 c3                	mov    %eax,%ebx
  802c53:	83 c4 20             	add    $0x20,%esp
  802c56:	85 c0                	test   %eax,%eax
  802c58:	0f 88 46 03 00 00    	js     802fa4 <spawn+0x574>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802c5e:	83 ec 08             	sub    $0x8,%esp
  802c61:	68 00 00 40 00       	push   $0x400000
  802c66:	6a 00                	push   $0x0
  802c68:	e8 d9 eb ff ff       	call   801846 <sys_page_unmap>
  802c6d:	89 c3                	mov    %eax,%ebx
  802c6f:	83 c4 10             	add    $0x10,%esp
  802c72:	85 c0                	test   %eax,%eax
  802c74:	0f 88 2a 03 00 00    	js     802fa4 <spawn+0x574>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802c7a:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  802c80:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802c87:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  802c8e:	00 00 00 
  802c91:	e9 4f 01 00 00       	jmp    802de5 <spawn+0x3b5>
	assert(string_store == (char*)UTEMP + PGSIZE);
  802c96:	68 c8 44 80 00       	push   $0x8044c8
  802c9b:	68 cf 3d 80 00       	push   $0x803dcf
  802ca0:	68 f8 00 00 00       	push   $0xf8
  802ca5:	68 5c 44 80 00       	push   $0x80445c
  802caa:	e8 db dd ff ff       	call   800a8a <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802caf:	83 ec 04             	sub    $0x4,%esp
  802cb2:	6a 07                	push   $0x7
  802cb4:	68 00 00 40 00       	push   $0x400000
  802cb9:	6a 00                	push   $0x0
  802cbb:	e8 01 eb ff ff       	call   8017c1 <sys_page_alloc>
  802cc0:	83 c4 10             	add    $0x10,%esp
  802cc3:	85 c0                	test   %eax,%eax
  802cc5:	0f 88 b7 02 00 00    	js     802f82 <spawn+0x552>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802ccb:	83 ec 08             	sub    $0x8,%esp
  802cce:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802cd4:	01 f0                	add    %esi,%eax
  802cd6:	50                   	push   %eax
  802cd7:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802cdd:	e8 45 f8 ff ff       	call   802527 <seek>
  802ce2:	83 c4 10             	add    $0x10,%esp
  802ce5:	85 c0                	test   %eax,%eax
  802ce7:	0f 88 9c 02 00 00    	js     802f89 <spawn+0x559>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802ced:	83 ec 04             	sub    $0x4,%esp
  802cf0:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802cf6:	29 f0                	sub    %esi,%eax
  802cf8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802cfd:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802d02:	0f 47 c1             	cmova  %ecx,%eax
  802d05:	50                   	push   %eax
  802d06:	68 00 00 40 00       	push   $0x400000
  802d0b:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802d11:	e8 4a f7 ff ff       	call   802460 <readn>
  802d16:	83 c4 10             	add    $0x10,%esp
  802d19:	85 c0                	test   %eax,%eax
  802d1b:	0f 88 6f 02 00 00    	js     802f90 <spawn+0x560>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802d21:	83 ec 0c             	sub    $0xc,%esp
  802d24:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802d2a:	53                   	push   %ebx
  802d2b:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802d31:	68 00 00 40 00       	push   $0x400000
  802d36:	6a 00                	push   $0x0
  802d38:	e8 c7 ea ff ff       	call   801804 <sys_page_map>
  802d3d:	83 c4 20             	add    $0x20,%esp
  802d40:	85 c0                	test   %eax,%eax
  802d42:	78 7c                	js     802dc0 <spawn+0x390>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  802d44:	83 ec 08             	sub    $0x8,%esp
  802d47:	68 00 00 40 00       	push   $0x400000
  802d4c:	6a 00                	push   $0x0
  802d4e:	e8 f3 ea ff ff       	call   801846 <sys_page_unmap>
  802d53:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  802d56:	81 c7 00 10 00 00    	add    $0x1000,%edi
  802d5c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802d62:	89 fe                	mov    %edi,%esi
  802d64:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  802d6a:	76 69                	jbe    802dd5 <spawn+0x3a5>
		if (i >= filesz) {
  802d6c:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  802d72:	0f 87 37 ff ff ff    	ja     802caf <spawn+0x27f>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802d78:	83 ec 04             	sub    $0x4,%esp
  802d7b:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802d81:	53                   	push   %ebx
  802d82:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802d88:	e8 34 ea ff ff       	call   8017c1 <sys_page_alloc>
  802d8d:	83 c4 10             	add    $0x10,%esp
  802d90:	85 c0                	test   %eax,%eax
  802d92:	79 c2                	jns    802d56 <spawn+0x326>
  802d94:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  802d96:	83 ec 0c             	sub    $0xc,%esp
  802d99:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802d9f:	e8 9e e9 ff ff       	call   801742 <sys_env_destroy>
	close(fd);
  802da4:	83 c4 04             	add    $0x4,%esp
  802da7:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802dad:	e8 e9 f4 ff ff       	call   80229b <close>
	return r;
  802db2:	83 c4 10             	add    $0x10,%esp
  802db5:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  802dbb:	e9 b4 01 00 00       	jmp    802f74 <spawn+0x544>
				panic("spawn: sys_page_map data: %e", r);
  802dc0:	50                   	push   %eax
  802dc1:	68 68 44 80 00       	push   $0x804468
  802dc6:	68 2b 01 00 00       	push   $0x12b
  802dcb:	68 5c 44 80 00       	push   $0x80445c
  802dd0:	e8 b5 dc ff ff       	call   800a8a <_panic>
  802dd5:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802ddb:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  802de2:	83 c6 20             	add    $0x20,%esi
  802de5:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802dec:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  802df2:	7e 6d                	jle    802e61 <spawn+0x431>
		if (ph->p_type != ELF_PROG_LOAD)
  802df4:	83 3e 01             	cmpl   $0x1,(%esi)
  802df7:	75 e2                	jne    802ddb <spawn+0x3ab>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802df9:	8b 46 18             	mov    0x18(%esi),%eax
  802dfc:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  802dff:	83 f8 01             	cmp    $0x1,%eax
  802e02:	19 c0                	sbb    %eax,%eax
  802e04:	83 e0 fe             	and    $0xfffffffe,%eax
  802e07:	83 c0 07             	add    $0x7,%eax
  802e0a:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802e10:	8b 4e 04             	mov    0x4(%esi),%ecx
  802e13:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  802e19:	8b 56 10             	mov    0x10(%esi),%edx
  802e1c:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  802e22:	8b 7e 14             	mov    0x14(%esi),%edi
  802e25:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  802e2b:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  802e2e:	89 d8                	mov    %ebx,%eax
  802e30:	25 ff 0f 00 00       	and    $0xfff,%eax
  802e35:	74 1a                	je     802e51 <spawn+0x421>
		va -= i;
  802e37:	29 c3                	sub    %eax,%ebx
		memsz += i;
  802e39:	01 c7                	add    %eax,%edi
  802e3b:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  802e41:	01 c2                	add    %eax,%edx
  802e43:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  802e49:	29 c1                	sub    %eax,%ecx
  802e4b:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  802e51:	bf 00 00 00 00       	mov    $0x0,%edi
  802e56:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  802e5c:	e9 01 ff ff ff       	jmp    802d62 <spawn+0x332>
	close(fd);
  802e61:	83 ec 0c             	sub    $0xc,%esp
  802e64:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802e6a:	e8 2c f4 ff ff       	call   80229b <close>

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	cprintf("in %s\n", __FUNCTION__);
  802e6f:	83 c4 08             	add    $0x8,%esp
  802e72:	68 f8 44 80 00       	push   $0x8044f8
  802e77:	68 a3 3e 80 00       	push   $0x803ea3
  802e7c:	e8 ff dc ff ff       	call   800b80 <cprintf>
  802e81:	83 c4 10             	add    $0x10,%esp
	int r;
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  802e84:	bb 00 00 80 00       	mov    $0x800000,%ebx
  802e89:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  802e8f:	eb 0e                	jmp    802e9f <spawn+0x46f>
  802e91:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802e97:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  802e9d:	74 5e                	je     802efd <spawn+0x4cd>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_SHARE)) == (PTE_P | PTE_U | PTE_SHARE)))
  802e9f:	89 d8                	mov    %ebx,%eax
  802ea1:	c1 e8 16             	shr    $0x16,%eax
  802ea4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802eab:	a8 01                	test   $0x1,%al
  802ead:	74 e2                	je     802e91 <spawn+0x461>
  802eaf:	89 da                	mov    %ebx,%edx
  802eb1:	c1 ea 0c             	shr    $0xc,%edx
  802eb4:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  802ebb:	25 05 04 00 00       	and    $0x405,%eax
  802ec0:	3d 05 04 00 00       	cmp    $0x405,%eax
  802ec5:	75 ca                	jne    802e91 <spawn+0x461>
			if((r = sys_page_map((envid_t)0, (void *)i, child, (void *)i, uvpt[PGNUM(i)] & PTE_SYSCALL)) < 0)
  802ec7:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  802ece:	83 ec 0c             	sub    $0xc,%esp
  802ed1:	25 07 0e 00 00       	and    $0xe07,%eax
  802ed6:	50                   	push   %eax
  802ed7:	53                   	push   %ebx
  802ed8:	56                   	push   %esi
  802ed9:	53                   	push   %ebx
  802eda:	6a 00                	push   $0x0
  802edc:	e8 23 e9 ff ff       	call   801804 <sys_page_map>
  802ee1:	83 c4 20             	add    $0x20,%esp
  802ee4:	85 c0                	test   %eax,%eax
  802ee6:	79 a9                	jns    802e91 <spawn+0x461>
        		panic("sys_page_map: %e\n", r);
  802ee8:	50                   	push   %eax
  802ee9:	68 85 44 80 00       	push   $0x804485
  802eee:	68 3b 01 00 00       	push   $0x13b
  802ef3:	68 5c 44 80 00       	push   $0x80445c
  802ef8:	e8 8d db ff ff       	call   800a8a <_panic>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802efd:	83 ec 08             	sub    $0x8,%esp
  802f00:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802f06:	50                   	push   %eax
  802f07:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802f0d:	e8 b8 e9 ff ff       	call   8018ca <sys_env_set_trapframe>
  802f12:	83 c4 10             	add    $0x10,%esp
  802f15:	85 c0                	test   %eax,%eax
  802f17:	78 25                	js     802f3e <spawn+0x50e>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802f19:	83 ec 08             	sub    $0x8,%esp
  802f1c:	6a 02                	push   $0x2
  802f1e:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802f24:	e8 5f e9 ff ff       	call   801888 <sys_env_set_status>
  802f29:	83 c4 10             	add    $0x10,%esp
  802f2c:	85 c0                	test   %eax,%eax
  802f2e:	78 23                	js     802f53 <spawn+0x523>
	return child;
  802f30:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802f36:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802f3c:	eb 36                	jmp    802f74 <spawn+0x544>
		panic("sys_env_set_trapframe: %e", r);
  802f3e:	50                   	push   %eax
  802f3f:	68 97 44 80 00       	push   $0x804497
  802f44:	68 8a 00 00 00       	push   $0x8a
  802f49:	68 5c 44 80 00       	push   $0x80445c
  802f4e:	e8 37 db ff ff       	call   800a8a <_panic>
		panic("sys_env_set_status: %e", r);
  802f53:	50                   	push   %eax
  802f54:	68 b1 44 80 00       	push   $0x8044b1
  802f59:	68 8d 00 00 00       	push   $0x8d
  802f5e:	68 5c 44 80 00       	push   $0x80445c
  802f63:	e8 22 db ff ff       	call   800a8a <_panic>
		return r;
  802f68:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802f6e:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  802f74:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802f7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802f7d:	5b                   	pop    %ebx
  802f7e:	5e                   	pop    %esi
  802f7f:	5f                   	pop    %edi
  802f80:	5d                   	pop    %ebp
  802f81:	c3                   	ret    
  802f82:	89 c7                	mov    %eax,%edi
  802f84:	e9 0d fe ff ff       	jmp    802d96 <spawn+0x366>
  802f89:	89 c7                	mov    %eax,%edi
  802f8b:	e9 06 fe ff ff       	jmp    802d96 <spawn+0x366>
  802f90:	89 c7                	mov    %eax,%edi
  802f92:	e9 ff fd ff ff       	jmp    802d96 <spawn+0x366>
		return -E_NO_MEM;
  802f97:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  802f9c:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802fa2:	eb d0                	jmp    802f74 <spawn+0x544>
	sys_page_unmap(0, UTEMP);
  802fa4:	83 ec 08             	sub    $0x8,%esp
  802fa7:	68 00 00 40 00       	push   $0x400000
  802fac:	6a 00                	push   $0x0
  802fae:	e8 93 e8 ff ff       	call   801846 <sys_page_unmap>
  802fb3:	83 c4 10             	add    $0x10,%esp
  802fb6:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  802fbc:	eb b6                	jmp    802f74 <spawn+0x544>

00802fbe <spawnl>:
{
  802fbe:	55                   	push   %ebp
  802fbf:	89 e5                	mov    %esp,%ebp
  802fc1:	57                   	push   %edi
  802fc2:	56                   	push   %esi
  802fc3:	53                   	push   %ebx
  802fc4:	83 ec 14             	sub    $0x14,%esp
	cprintf("in %s\n", __FUNCTION__);
  802fc7:	68 f0 44 80 00       	push   $0x8044f0
  802fcc:	68 a3 3e 80 00       	push   $0x803ea3
  802fd1:	e8 aa db ff ff       	call   800b80 <cprintf>
	va_start(vl, arg0);
  802fd6:	8d 55 10             	lea    0x10(%ebp),%edx
	while(va_arg(vl, void *) != NULL)
  802fd9:	83 c4 10             	add    $0x10,%esp
	int argc=0;
  802fdc:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  802fe1:	8d 4a 04             	lea    0x4(%edx),%ecx
  802fe4:	83 3a 00             	cmpl   $0x0,(%edx)
  802fe7:	74 07                	je     802ff0 <spawnl+0x32>
		argc++;
  802fe9:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  802fec:	89 ca                	mov    %ecx,%edx
  802fee:	eb f1                	jmp    802fe1 <spawnl+0x23>
	const char *argv[argc+2];
  802ff0:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  802ff7:	83 e2 f0             	and    $0xfffffff0,%edx
  802ffa:	29 d4                	sub    %edx,%esp
  802ffc:	8d 54 24 03          	lea    0x3(%esp),%edx
  803000:	c1 ea 02             	shr    $0x2,%edx
  803003:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  80300a:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  80300c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80300f:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  803016:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  80301d:	00 
	va_start(vl, arg0);
  80301e:	8d 4d 10             	lea    0x10(%ebp),%ecx
  803021:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  803023:	b8 00 00 00 00       	mov    $0x0,%eax
  803028:	eb 0b                	jmp    803035 <spawnl+0x77>
		argv[i+1] = va_arg(vl, const char *);
  80302a:	83 c0 01             	add    $0x1,%eax
  80302d:	8b 39                	mov    (%ecx),%edi
  80302f:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  803032:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  803035:	39 d0                	cmp    %edx,%eax
  803037:	75 f1                	jne    80302a <spawnl+0x6c>
	return spawn(prog, argv);
  803039:	83 ec 08             	sub    $0x8,%esp
  80303c:	56                   	push   %esi
  80303d:	ff 75 08             	pushl  0x8(%ebp)
  803040:	e8 eb f9 ff ff       	call   802a30 <spawn>
}
  803045:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803048:	5b                   	pop    %ebx
  803049:	5e                   	pop    %esi
  80304a:	5f                   	pop    %edi
  80304b:	5d                   	pop    %ebp
  80304c:	c3                   	ret    

0080304d <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80304d:	55                   	push   %ebp
  80304e:	89 e5                	mov    %esp,%ebp
  803050:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  803053:	68 1e 45 80 00       	push   $0x80451e
  803058:	ff 75 0c             	pushl  0xc(%ebp)
  80305b:	e8 6f e3 ff ff       	call   8013cf <strcpy>
	return 0;
}
  803060:	b8 00 00 00 00       	mov    $0x0,%eax
  803065:	c9                   	leave  
  803066:	c3                   	ret    

00803067 <devsock_close>:
{
  803067:	55                   	push   %ebp
  803068:	89 e5                	mov    %esp,%ebp
  80306a:	53                   	push   %ebx
  80306b:	83 ec 10             	sub    $0x10,%esp
  80306e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  803071:	53                   	push   %ebx
  803072:	e8 72 09 00 00       	call   8039e9 <pageref>
  803077:	83 c4 10             	add    $0x10,%esp
		return 0;
  80307a:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80307f:	83 f8 01             	cmp    $0x1,%eax
  803082:	74 07                	je     80308b <devsock_close+0x24>
}
  803084:	89 d0                	mov    %edx,%eax
  803086:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803089:	c9                   	leave  
  80308a:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80308b:	83 ec 0c             	sub    $0xc,%esp
  80308e:	ff 73 0c             	pushl  0xc(%ebx)
  803091:	e8 b9 02 00 00       	call   80334f <nsipc_close>
  803096:	89 c2                	mov    %eax,%edx
  803098:	83 c4 10             	add    $0x10,%esp
  80309b:	eb e7                	jmp    803084 <devsock_close+0x1d>

0080309d <devsock_write>:
{
  80309d:	55                   	push   %ebp
  80309e:	89 e5                	mov    %esp,%ebp
  8030a0:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8030a3:	6a 00                	push   $0x0
  8030a5:	ff 75 10             	pushl  0x10(%ebp)
  8030a8:	ff 75 0c             	pushl  0xc(%ebp)
  8030ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ae:	ff 70 0c             	pushl  0xc(%eax)
  8030b1:	e8 76 03 00 00       	call   80342c <nsipc_send>
}
  8030b6:	c9                   	leave  
  8030b7:	c3                   	ret    

008030b8 <devsock_read>:
{
  8030b8:	55                   	push   %ebp
  8030b9:	89 e5                	mov    %esp,%ebp
  8030bb:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8030be:	6a 00                	push   $0x0
  8030c0:	ff 75 10             	pushl  0x10(%ebp)
  8030c3:	ff 75 0c             	pushl  0xc(%ebp)
  8030c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c9:	ff 70 0c             	pushl  0xc(%eax)
  8030cc:	e8 ef 02 00 00       	call   8033c0 <nsipc_recv>
}
  8030d1:	c9                   	leave  
  8030d2:	c3                   	ret    

008030d3 <fd2sockid>:
{
  8030d3:	55                   	push   %ebp
  8030d4:	89 e5                	mov    %esp,%ebp
  8030d6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8030d9:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8030dc:	52                   	push   %edx
  8030dd:	50                   	push   %eax
  8030de:	e8 86 f0 ff ff       	call   802169 <fd_lookup>
  8030e3:	83 c4 10             	add    $0x10,%esp
  8030e6:	85 c0                	test   %eax,%eax
  8030e8:	78 10                	js     8030fa <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8030ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ed:	8b 0d 3c 50 80 00    	mov    0x80503c,%ecx
  8030f3:	39 08                	cmp    %ecx,(%eax)
  8030f5:	75 05                	jne    8030fc <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8030f7:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8030fa:	c9                   	leave  
  8030fb:	c3                   	ret    
		return -E_NOT_SUPP;
  8030fc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803101:	eb f7                	jmp    8030fa <fd2sockid+0x27>

00803103 <alloc_sockfd>:
{
  803103:	55                   	push   %ebp
  803104:	89 e5                	mov    %esp,%ebp
  803106:	56                   	push   %esi
  803107:	53                   	push   %ebx
  803108:	83 ec 1c             	sub    $0x1c,%esp
  80310b:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80310d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803110:	50                   	push   %eax
  803111:	e8 01 f0 ff ff       	call   802117 <fd_alloc>
  803116:	89 c3                	mov    %eax,%ebx
  803118:	83 c4 10             	add    $0x10,%esp
  80311b:	85 c0                	test   %eax,%eax
  80311d:	78 43                	js     803162 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80311f:	83 ec 04             	sub    $0x4,%esp
  803122:	68 07 04 00 00       	push   $0x407
  803127:	ff 75 f4             	pushl  -0xc(%ebp)
  80312a:	6a 00                	push   $0x0
  80312c:	e8 90 e6 ff ff       	call   8017c1 <sys_page_alloc>
  803131:	89 c3                	mov    %eax,%ebx
  803133:	83 c4 10             	add    $0x10,%esp
  803136:	85 c0                	test   %eax,%eax
  803138:	78 28                	js     803162 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80313a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313d:	8b 15 3c 50 80 00    	mov    0x80503c,%edx
  803143:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  803145:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803148:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80314f:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  803152:	83 ec 0c             	sub    $0xc,%esp
  803155:	50                   	push   %eax
  803156:	e8 95 ef ff ff       	call   8020f0 <fd2num>
  80315b:	89 c3                	mov    %eax,%ebx
  80315d:	83 c4 10             	add    $0x10,%esp
  803160:	eb 0c                	jmp    80316e <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  803162:	83 ec 0c             	sub    $0xc,%esp
  803165:	56                   	push   %esi
  803166:	e8 e4 01 00 00       	call   80334f <nsipc_close>
		return r;
  80316b:	83 c4 10             	add    $0x10,%esp
}
  80316e:	89 d8                	mov    %ebx,%eax
  803170:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803173:	5b                   	pop    %ebx
  803174:	5e                   	pop    %esi
  803175:	5d                   	pop    %ebp
  803176:	c3                   	ret    

00803177 <accept>:
{
  803177:	55                   	push   %ebp
  803178:	89 e5                	mov    %esp,%ebp
  80317a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80317d:	8b 45 08             	mov    0x8(%ebp),%eax
  803180:	e8 4e ff ff ff       	call   8030d3 <fd2sockid>
  803185:	85 c0                	test   %eax,%eax
  803187:	78 1b                	js     8031a4 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803189:	83 ec 04             	sub    $0x4,%esp
  80318c:	ff 75 10             	pushl  0x10(%ebp)
  80318f:	ff 75 0c             	pushl  0xc(%ebp)
  803192:	50                   	push   %eax
  803193:	e8 0e 01 00 00       	call   8032a6 <nsipc_accept>
  803198:	83 c4 10             	add    $0x10,%esp
  80319b:	85 c0                	test   %eax,%eax
  80319d:	78 05                	js     8031a4 <accept+0x2d>
	return alloc_sockfd(r);
  80319f:	e8 5f ff ff ff       	call   803103 <alloc_sockfd>
}
  8031a4:	c9                   	leave  
  8031a5:	c3                   	ret    

008031a6 <bind>:
{
  8031a6:	55                   	push   %ebp
  8031a7:	89 e5                	mov    %esp,%ebp
  8031a9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8031ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8031af:	e8 1f ff ff ff       	call   8030d3 <fd2sockid>
  8031b4:	85 c0                	test   %eax,%eax
  8031b6:	78 12                	js     8031ca <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8031b8:	83 ec 04             	sub    $0x4,%esp
  8031bb:	ff 75 10             	pushl  0x10(%ebp)
  8031be:	ff 75 0c             	pushl  0xc(%ebp)
  8031c1:	50                   	push   %eax
  8031c2:	e8 31 01 00 00       	call   8032f8 <nsipc_bind>
  8031c7:	83 c4 10             	add    $0x10,%esp
}
  8031ca:	c9                   	leave  
  8031cb:	c3                   	ret    

008031cc <shutdown>:
{
  8031cc:	55                   	push   %ebp
  8031cd:	89 e5                	mov    %esp,%ebp
  8031cf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8031d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d5:	e8 f9 fe ff ff       	call   8030d3 <fd2sockid>
  8031da:	85 c0                	test   %eax,%eax
  8031dc:	78 0f                	js     8031ed <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8031de:	83 ec 08             	sub    $0x8,%esp
  8031e1:	ff 75 0c             	pushl  0xc(%ebp)
  8031e4:	50                   	push   %eax
  8031e5:	e8 43 01 00 00       	call   80332d <nsipc_shutdown>
  8031ea:	83 c4 10             	add    $0x10,%esp
}
  8031ed:	c9                   	leave  
  8031ee:	c3                   	ret    

008031ef <connect>:
{
  8031ef:	55                   	push   %ebp
  8031f0:	89 e5                	mov    %esp,%ebp
  8031f2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8031f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f8:	e8 d6 fe ff ff       	call   8030d3 <fd2sockid>
  8031fd:	85 c0                	test   %eax,%eax
  8031ff:	78 12                	js     803213 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  803201:	83 ec 04             	sub    $0x4,%esp
  803204:	ff 75 10             	pushl  0x10(%ebp)
  803207:	ff 75 0c             	pushl  0xc(%ebp)
  80320a:	50                   	push   %eax
  80320b:	e8 59 01 00 00       	call   803369 <nsipc_connect>
  803210:	83 c4 10             	add    $0x10,%esp
}
  803213:	c9                   	leave  
  803214:	c3                   	ret    

00803215 <listen>:
{
  803215:	55                   	push   %ebp
  803216:	89 e5                	mov    %esp,%ebp
  803218:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80321b:	8b 45 08             	mov    0x8(%ebp),%eax
  80321e:	e8 b0 fe ff ff       	call   8030d3 <fd2sockid>
  803223:	85 c0                	test   %eax,%eax
  803225:	78 0f                	js     803236 <listen+0x21>
	return nsipc_listen(r, backlog);
  803227:	83 ec 08             	sub    $0x8,%esp
  80322a:	ff 75 0c             	pushl  0xc(%ebp)
  80322d:	50                   	push   %eax
  80322e:	e8 6b 01 00 00       	call   80339e <nsipc_listen>
  803233:	83 c4 10             	add    $0x10,%esp
}
  803236:	c9                   	leave  
  803237:	c3                   	ret    

00803238 <socket>:

int
socket(int domain, int type, int protocol)
{
  803238:	55                   	push   %ebp
  803239:	89 e5                	mov    %esp,%ebp
  80323b:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80323e:	ff 75 10             	pushl  0x10(%ebp)
  803241:	ff 75 0c             	pushl  0xc(%ebp)
  803244:	ff 75 08             	pushl  0x8(%ebp)
  803247:	e8 3e 02 00 00       	call   80348a <nsipc_socket>
  80324c:	83 c4 10             	add    $0x10,%esp
  80324f:	85 c0                	test   %eax,%eax
  803251:	78 05                	js     803258 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  803253:	e8 ab fe ff ff       	call   803103 <alloc_sockfd>
}
  803258:	c9                   	leave  
  803259:	c3                   	ret    

0080325a <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80325a:	55                   	push   %ebp
  80325b:	89 e5                	mov    %esp,%ebp
  80325d:	53                   	push   %ebx
  80325e:	83 ec 04             	sub    $0x4,%esp
  803261:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  803263:	83 3d 24 64 80 00 00 	cmpl   $0x0,0x806424
  80326a:	74 26                	je     803292 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80326c:	6a 07                	push   $0x7
  80326e:	68 00 80 80 00       	push   $0x808000
  803273:	53                   	push   %ebx
  803274:	ff 35 24 64 80 00    	pushl  0x806424
  80327a:	e8 d3 06 00 00       	call   803952 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80327f:	83 c4 0c             	add    $0xc,%esp
  803282:	6a 00                	push   $0x0
  803284:	6a 00                	push   $0x0
  803286:	6a 00                	push   $0x0
  803288:	e8 5c 06 00 00       	call   8038e9 <ipc_recv>
}
  80328d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803290:	c9                   	leave  
  803291:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803292:	83 ec 0c             	sub    $0xc,%esp
  803295:	6a 02                	push   $0x2
  803297:	e8 0e 07 00 00       	call   8039aa <ipc_find_env>
  80329c:	a3 24 64 80 00       	mov    %eax,0x806424
  8032a1:	83 c4 10             	add    $0x10,%esp
  8032a4:	eb c6                	jmp    80326c <nsipc+0x12>

008032a6 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8032a6:	55                   	push   %ebp
  8032a7:	89 e5                	mov    %esp,%ebp
  8032a9:	56                   	push   %esi
  8032aa:	53                   	push   %ebx
  8032ab:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8032ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b1:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8032b6:	8b 06                	mov    (%esi),%eax
  8032b8:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8032bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8032c2:	e8 93 ff ff ff       	call   80325a <nsipc>
  8032c7:	89 c3                	mov    %eax,%ebx
  8032c9:	85 c0                	test   %eax,%eax
  8032cb:	79 09                	jns    8032d6 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8032cd:	89 d8                	mov    %ebx,%eax
  8032cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8032d2:	5b                   	pop    %ebx
  8032d3:	5e                   	pop    %esi
  8032d4:	5d                   	pop    %ebp
  8032d5:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8032d6:	83 ec 04             	sub    $0x4,%esp
  8032d9:	ff 35 10 80 80 00    	pushl  0x808010
  8032df:	68 00 80 80 00       	push   $0x808000
  8032e4:	ff 75 0c             	pushl  0xc(%ebp)
  8032e7:	e8 71 e2 ff ff       	call   80155d <memmove>
		*addrlen = ret->ret_addrlen;
  8032ec:	a1 10 80 80 00       	mov    0x808010,%eax
  8032f1:	89 06                	mov    %eax,(%esi)
  8032f3:	83 c4 10             	add    $0x10,%esp
	return r;
  8032f6:	eb d5                	jmp    8032cd <nsipc_accept+0x27>

008032f8 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8032f8:	55                   	push   %ebp
  8032f9:	89 e5                	mov    %esp,%ebp
  8032fb:	53                   	push   %ebx
  8032fc:	83 ec 08             	sub    $0x8,%esp
  8032ff:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  803302:	8b 45 08             	mov    0x8(%ebp),%eax
  803305:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80330a:	53                   	push   %ebx
  80330b:	ff 75 0c             	pushl  0xc(%ebp)
  80330e:	68 04 80 80 00       	push   $0x808004
  803313:	e8 45 e2 ff ff       	call   80155d <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  803318:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  80331e:	b8 02 00 00 00       	mov    $0x2,%eax
  803323:	e8 32 ff ff ff       	call   80325a <nsipc>
}
  803328:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80332b:	c9                   	leave  
  80332c:	c3                   	ret    

0080332d <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80332d:	55                   	push   %ebp
  80332e:	89 e5                	mov    %esp,%ebp
  803330:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  803333:	8b 45 08             	mov    0x8(%ebp),%eax
  803336:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  80333b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80333e:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  803343:	b8 03 00 00 00       	mov    $0x3,%eax
  803348:	e8 0d ff ff ff       	call   80325a <nsipc>
}
  80334d:	c9                   	leave  
  80334e:	c3                   	ret    

0080334f <nsipc_close>:

int
nsipc_close(int s)
{
  80334f:	55                   	push   %ebp
  803350:	89 e5                	mov    %esp,%ebp
  803352:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  803355:	8b 45 08             	mov    0x8(%ebp),%eax
  803358:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  80335d:	b8 04 00 00 00       	mov    $0x4,%eax
  803362:	e8 f3 fe ff ff       	call   80325a <nsipc>
}
  803367:	c9                   	leave  
  803368:	c3                   	ret    

00803369 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803369:	55                   	push   %ebp
  80336a:	89 e5                	mov    %esp,%ebp
  80336c:	53                   	push   %ebx
  80336d:	83 ec 08             	sub    $0x8,%esp
  803370:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  803373:	8b 45 08             	mov    0x8(%ebp),%eax
  803376:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80337b:	53                   	push   %ebx
  80337c:	ff 75 0c             	pushl  0xc(%ebp)
  80337f:	68 04 80 80 00       	push   $0x808004
  803384:	e8 d4 e1 ff ff       	call   80155d <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  803389:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  80338f:	b8 05 00 00 00       	mov    $0x5,%eax
  803394:	e8 c1 fe ff ff       	call   80325a <nsipc>
}
  803399:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80339c:	c9                   	leave  
  80339d:	c3                   	ret    

0080339e <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80339e:	55                   	push   %ebp
  80339f:	89 e5                	mov    %esp,%ebp
  8033a1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8033a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a7:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  8033ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033af:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  8033b4:	b8 06 00 00 00       	mov    $0x6,%eax
  8033b9:	e8 9c fe ff ff       	call   80325a <nsipc>
}
  8033be:	c9                   	leave  
  8033bf:	c3                   	ret    

008033c0 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8033c0:	55                   	push   %ebp
  8033c1:	89 e5                	mov    %esp,%ebp
  8033c3:	56                   	push   %esi
  8033c4:	53                   	push   %ebx
  8033c5:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8033c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cb:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  8033d0:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  8033d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8033d9:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8033de:	b8 07 00 00 00       	mov    $0x7,%eax
  8033e3:	e8 72 fe ff ff       	call   80325a <nsipc>
  8033e8:	89 c3                	mov    %eax,%ebx
  8033ea:	85 c0                	test   %eax,%eax
  8033ec:	78 1f                	js     80340d <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8033ee:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8033f3:	7f 21                	jg     803416 <nsipc_recv+0x56>
  8033f5:	39 c6                	cmp    %eax,%esi
  8033f7:	7c 1d                	jl     803416 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8033f9:	83 ec 04             	sub    $0x4,%esp
  8033fc:	50                   	push   %eax
  8033fd:	68 00 80 80 00       	push   $0x808000
  803402:	ff 75 0c             	pushl  0xc(%ebp)
  803405:	e8 53 e1 ff ff       	call   80155d <memmove>
  80340a:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80340d:	89 d8                	mov    %ebx,%eax
  80340f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803412:	5b                   	pop    %ebx
  803413:	5e                   	pop    %esi
  803414:	5d                   	pop    %ebp
  803415:	c3                   	ret    
		assert(r < 1600 && r <= len);
  803416:	68 2a 45 80 00       	push   $0x80452a
  80341b:	68 cf 3d 80 00       	push   $0x803dcf
  803420:	6a 62                	push   $0x62
  803422:	68 3f 45 80 00       	push   $0x80453f
  803427:	e8 5e d6 ff ff       	call   800a8a <_panic>

0080342c <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80342c:	55                   	push   %ebp
  80342d:	89 e5                	mov    %esp,%ebp
  80342f:	53                   	push   %ebx
  803430:	83 ec 04             	sub    $0x4,%esp
  803433:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  803436:	8b 45 08             	mov    0x8(%ebp),%eax
  803439:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  80343e:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  803444:	7f 2e                	jg     803474 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803446:	83 ec 04             	sub    $0x4,%esp
  803449:	53                   	push   %ebx
  80344a:	ff 75 0c             	pushl  0xc(%ebp)
  80344d:	68 0c 80 80 00       	push   $0x80800c
  803452:	e8 06 e1 ff ff       	call   80155d <memmove>
	nsipcbuf.send.req_size = size;
  803457:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  80345d:	8b 45 14             	mov    0x14(%ebp),%eax
  803460:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  803465:	b8 08 00 00 00       	mov    $0x8,%eax
  80346a:	e8 eb fd ff ff       	call   80325a <nsipc>
}
  80346f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803472:	c9                   	leave  
  803473:	c3                   	ret    
	assert(size < 1600);
  803474:	68 4b 45 80 00       	push   $0x80454b
  803479:	68 cf 3d 80 00       	push   $0x803dcf
  80347e:	6a 6d                	push   $0x6d
  803480:	68 3f 45 80 00       	push   $0x80453f
  803485:	e8 00 d6 ff ff       	call   800a8a <_panic>

0080348a <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80348a:	55                   	push   %ebp
  80348b:	89 e5                	mov    %esp,%ebp
  80348d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  803490:	8b 45 08             	mov    0x8(%ebp),%eax
  803493:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  803498:	8b 45 0c             	mov    0xc(%ebp),%eax
  80349b:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  8034a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8034a3:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  8034a8:	b8 09 00 00 00       	mov    $0x9,%eax
  8034ad:	e8 a8 fd ff ff       	call   80325a <nsipc>
}
  8034b2:	c9                   	leave  
  8034b3:	c3                   	ret    

008034b4 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8034b4:	55                   	push   %ebp
  8034b5:	89 e5                	mov    %esp,%ebp
  8034b7:	56                   	push   %esi
  8034b8:	53                   	push   %ebx
  8034b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8034bc:	83 ec 0c             	sub    $0xc,%esp
  8034bf:	ff 75 08             	pushl  0x8(%ebp)
  8034c2:	e8 39 ec ff ff       	call   802100 <fd2data>
  8034c7:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8034c9:	83 c4 08             	add    $0x8,%esp
  8034cc:	68 57 45 80 00       	push   $0x804557
  8034d1:	53                   	push   %ebx
  8034d2:	e8 f8 de ff ff       	call   8013cf <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8034d7:	8b 46 04             	mov    0x4(%esi),%eax
  8034da:	2b 06                	sub    (%esi),%eax
  8034dc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8034e2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8034e9:	00 00 00 
	stat->st_dev = &devpipe;
  8034ec:	c7 83 88 00 00 00 58 	movl   $0x805058,0x88(%ebx)
  8034f3:	50 80 00 
	return 0;
}
  8034f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8034fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8034fe:	5b                   	pop    %ebx
  8034ff:	5e                   	pop    %esi
  803500:	5d                   	pop    %ebp
  803501:	c3                   	ret    

00803502 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803502:	55                   	push   %ebp
  803503:	89 e5                	mov    %esp,%ebp
  803505:	53                   	push   %ebx
  803506:	83 ec 0c             	sub    $0xc,%esp
  803509:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80350c:	53                   	push   %ebx
  80350d:	6a 00                	push   $0x0
  80350f:	e8 32 e3 ff ff       	call   801846 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  803514:	89 1c 24             	mov    %ebx,(%esp)
  803517:	e8 e4 eb ff ff       	call   802100 <fd2data>
  80351c:	83 c4 08             	add    $0x8,%esp
  80351f:	50                   	push   %eax
  803520:	6a 00                	push   $0x0
  803522:	e8 1f e3 ff ff       	call   801846 <sys_page_unmap>
}
  803527:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80352a:	c9                   	leave  
  80352b:	c3                   	ret    

0080352c <_pipeisclosed>:
{
  80352c:	55                   	push   %ebp
  80352d:	89 e5                	mov    %esp,%ebp
  80352f:	57                   	push   %edi
  803530:	56                   	push   %esi
  803531:	53                   	push   %ebx
  803532:	83 ec 1c             	sub    $0x1c,%esp
  803535:	89 c7                	mov    %eax,%edi
  803537:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  803539:	a1 28 64 80 00       	mov    0x806428,%eax
  80353e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  803541:	83 ec 0c             	sub    $0xc,%esp
  803544:	57                   	push   %edi
  803545:	e8 9f 04 00 00       	call   8039e9 <pageref>
  80354a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80354d:	89 34 24             	mov    %esi,(%esp)
  803550:	e8 94 04 00 00       	call   8039e9 <pageref>
		nn = thisenv->env_runs;
  803555:	8b 15 28 64 80 00    	mov    0x806428,%edx
  80355b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80355e:	83 c4 10             	add    $0x10,%esp
  803561:	39 cb                	cmp    %ecx,%ebx
  803563:	74 1b                	je     803580 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  803565:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  803568:	75 cf                	jne    803539 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80356a:	8b 42 58             	mov    0x58(%edx),%eax
  80356d:	6a 01                	push   $0x1
  80356f:	50                   	push   %eax
  803570:	53                   	push   %ebx
  803571:	68 5e 45 80 00       	push   $0x80455e
  803576:	e8 05 d6 ff ff       	call   800b80 <cprintf>
  80357b:	83 c4 10             	add    $0x10,%esp
  80357e:	eb b9                	jmp    803539 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  803580:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  803583:	0f 94 c0             	sete   %al
  803586:	0f b6 c0             	movzbl %al,%eax
}
  803589:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80358c:	5b                   	pop    %ebx
  80358d:	5e                   	pop    %esi
  80358e:	5f                   	pop    %edi
  80358f:	5d                   	pop    %ebp
  803590:	c3                   	ret    

00803591 <devpipe_write>:
{
  803591:	55                   	push   %ebp
  803592:	89 e5                	mov    %esp,%ebp
  803594:	57                   	push   %edi
  803595:	56                   	push   %esi
  803596:	53                   	push   %ebx
  803597:	83 ec 28             	sub    $0x28,%esp
  80359a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80359d:	56                   	push   %esi
  80359e:	e8 5d eb ff ff       	call   802100 <fd2data>
  8035a3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8035a5:	83 c4 10             	add    $0x10,%esp
  8035a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8035ad:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8035b0:	74 4f                	je     803601 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8035b2:	8b 43 04             	mov    0x4(%ebx),%eax
  8035b5:	8b 0b                	mov    (%ebx),%ecx
  8035b7:	8d 51 20             	lea    0x20(%ecx),%edx
  8035ba:	39 d0                	cmp    %edx,%eax
  8035bc:	72 14                	jb     8035d2 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8035be:	89 da                	mov    %ebx,%edx
  8035c0:	89 f0                	mov    %esi,%eax
  8035c2:	e8 65 ff ff ff       	call   80352c <_pipeisclosed>
  8035c7:	85 c0                	test   %eax,%eax
  8035c9:	75 3b                	jne    803606 <devpipe_write+0x75>
			sys_yield();
  8035cb:	e8 d2 e1 ff ff       	call   8017a2 <sys_yield>
  8035d0:	eb e0                	jmp    8035b2 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8035d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8035d5:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8035d9:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8035dc:	89 c2                	mov    %eax,%edx
  8035de:	c1 fa 1f             	sar    $0x1f,%edx
  8035e1:	89 d1                	mov    %edx,%ecx
  8035e3:	c1 e9 1b             	shr    $0x1b,%ecx
  8035e6:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8035e9:	83 e2 1f             	and    $0x1f,%edx
  8035ec:	29 ca                	sub    %ecx,%edx
  8035ee:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8035f2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8035f6:	83 c0 01             	add    $0x1,%eax
  8035f9:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8035fc:	83 c7 01             	add    $0x1,%edi
  8035ff:	eb ac                	jmp    8035ad <devpipe_write+0x1c>
	return i;
  803601:	8b 45 10             	mov    0x10(%ebp),%eax
  803604:	eb 05                	jmp    80360b <devpipe_write+0x7a>
				return 0;
  803606:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80360b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80360e:	5b                   	pop    %ebx
  80360f:	5e                   	pop    %esi
  803610:	5f                   	pop    %edi
  803611:	5d                   	pop    %ebp
  803612:	c3                   	ret    

00803613 <devpipe_read>:
{
  803613:	55                   	push   %ebp
  803614:	89 e5                	mov    %esp,%ebp
  803616:	57                   	push   %edi
  803617:	56                   	push   %esi
  803618:	53                   	push   %ebx
  803619:	83 ec 18             	sub    $0x18,%esp
  80361c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80361f:	57                   	push   %edi
  803620:	e8 db ea ff ff       	call   802100 <fd2data>
  803625:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  803627:	83 c4 10             	add    $0x10,%esp
  80362a:	be 00 00 00 00       	mov    $0x0,%esi
  80362f:	3b 75 10             	cmp    0x10(%ebp),%esi
  803632:	75 14                	jne    803648 <devpipe_read+0x35>
	return i;
  803634:	8b 45 10             	mov    0x10(%ebp),%eax
  803637:	eb 02                	jmp    80363b <devpipe_read+0x28>
				return i;
  803639:	89 f0                	mov    %esi,%eax
}
  80363b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80363e:	5b                   	pop    %ebx
  80363f:	5e                   	pop    %esi
  803640:	5f                   	pop    %edi
  803641:	5d                   	pop    %ebp
  803642:	c3                   	ret    
			sys_yield();
  803643:	e8 5a e1 ff ff       	call   8017a2 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  803648:	8b 03                	mov    (%ebx),%eax
  80364a:	3b 43 04             	cmp    0x4(%ebx),%eax
  80364d:	75 18                	jne    803667 <devpipe_read+0x54>
			if (i > 0)
  80364f:	85 f6                	test   %esi,%esi
  803651:	75 e6                	jne    803639 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  803653:	89 da                	mov    %ebx,%edx
  803655:	89 f8                	mov    %edi,%eax
  803657:	e8 d0 fe ff ff       	call   80352c <_pipeisclosed>
  80365c:	85 c0                	test   %eax,%eax
  80365e:	74 e3                	je     803643 <devpipe_read+0x30>
				return 0;
  803660:	b8 00 00 00 00       	mov    $0x0,%eax
  803665:	eb d4                	jmp    80363b <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803667:	99                   	cltd   
  803668:	c1 ea 1b             	shr    $0x1b,%edx
  80366b:	01 d0                	add    %edx,%eax
  80366d:	83 e0 1f             	and    $0x1f,%eax
  803670:	29 d0                	sub    %edx,%eax
  803672:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803677:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80367a:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80367d:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  803680:	83 c6 01             	add    $0x1,%esi
  803683:	eb aa                	jmp    80362f <devpipe_read+0x1c>

00803685 <pipe>:
{
  803685:	55                   	push   %ebp
  803686:	89 e5                	mov    %esp,%ebp
  803688:	56                   	push   %esi
  803689:	53                   	push   %ebx
  80368a:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80368d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803690:	50                   	push   %eax
  803691:	e8 81 ea ff ff       	call   802117 <fd_alloc>
  803696:	89 c3                	mov    %eax,%ebx
  803698:	83 c4 10             	add    $0x10,%esp
  80369b:	85 c0                	test   %eax,%eax
  80369d:	0f 88 23 01 00 00    	js     8037c6 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036a3:	83 ec 04             	sub    $0x4,%esp
  8036a6:	68 07 04 00 00       	push   $0x407
  8036ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8036ae:	6a 00                	push   $0x0
  8036b0:	e8 0c e1 ff ff       	call   8017c1 <sys_page_alloc>
  8036b5:	89 c3                	mov    %eax,%ebx
  8036b7:	83 c4 10             	add    $0x10,%esp
  8036ba:	85 c0                	test   %eax,%eax
  8036bc:	0f 88 04 01 00 00    	js     8037c6 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8036c2:	83 ec 0c             	sub    $0xc,%esp
  8036c5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8036c8:	50                   	push   %eax
  8036c9:	e8 49 ea ff ff       	call   802117 <fd_alloc>
  8036ce:	89 c3                	mov    %eax,%ebx
  8036d0:	83 c4 10             	add    $0x10,%esp
  8036d3:	85 c0                	test   %eax,%eax
  8036d5:	0f 88 db 00 00 00    	js     8037b6 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036db:	83 ec 04             	sub    $0x4,%esp
  8036de:	68 07 04 00 00       	push   $0x407
  8036e3:	ff 75 f0             	pushl  -0x10(%ebp)
  8036e6:	6a 00                	push   $0x0
  8036e8:	e8 d4 e0 ff ff       	call   8017c1 <sys_page_alloc>
  8036ed:	89 c3                	mov    %eax,%ebx
  8036ef:	83 c4 10             	add    $0x10,%esp
  8036f2:	85 c0                	test   %eax,%eax
  8036f4:	0f 88 bc 00 00 00    	js     8037b6 <pipe+0x131>
	va = fd2data(fd0);
  8036fa:	83 ec 0c             	sub    $0xc,%esp
  8036fd:	ff 75 f4             	pushl  -0xc(%ebp)
  803700:	e8 fb e9 ff ff       	call   802100 <fd2data>
  803705:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803707:	83 c4 0c             	add    $0xc,%esp
  80370a:	68 07 04 00 00       	push   $0x407
  80370f:	50                   	push   %eax
  803710:	6a 00                	push   $0x0
  803712:	e8 aa e0 ff ff       	call   8017c1 <sys_page_alloc>
  803717:	89 c3                	mov    %eax,%ebx
  803719:	83 c4 10             	add    $0x10,%esp
  80371c:	85 c0                	test   %eax,%eax
  80371e:	0f 88 82 00 00 00    	js     8037a6 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803724:	83 ec 0c             	sub    $0xc,%esp
  803727:	ff 75 f0             	pushl  -0x10(%ebp)
  80372a:	e8 d1 e9 ff ff       	call   802100 <fd2data>
  80372f:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  803736:	50                   	push   %eax
  803737:	6a 00                	push   $0x0
  803739:	56                   	push   %esi
  80373a:	6a 00                	push   $0x0
  80373c:	e8 c3 e0 ff ff       	call   801804 <sys_page_map>
  803741:	89 c3                	mov    %eax,%ebx
  803743:	83 c4 20             	add    $0x20,%esp
  803746:	85 c0                	test   %eax,%eax
  803748:	78 4e                	js     803798 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80374a:	a1 58 50 80 00       	mov    0x805058,%eax
  80374f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803752:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  803754:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803757:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80375e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803761:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  803763:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803766:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80376d:	83 ec 0c             	sub    $0xc,%esp
  803770:	ff 75 f4             	pushl  -0xc(%ebp)
  803773:	e8 78 e9 ff ff       	call   8020f0 <fd2num>
  803778:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80377b:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80377d:	83 c4 04             	add    $0x4,%esp
  803780:	ff 75 f0             	pushl  -0x10(%ebp)
  803783:	e8 68 e9 ff ff       	call   8020f0 <fd2num>
  803788:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80378b:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80378e:	83 c4 10             	add    $0x10,%esp
  803791:	bb 00 00 00 00       	mov    $0x0,%ebx
  803796:	eb 2e                	jmp    8037c6 <pipe+0x141>
	sys_page_unmap(0, va);
  803798:	83 ec 08             	sub    $0x8,%esp
  80379b:	56                   	push   %esi
  80379c:	6a 00                	push   $0x0
  80379e:	e8 a3 e0 ff ff       	call   801846 <sys_page_unmap>
  8037a3:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8037a6:	83 ec 08             	sub    $0x8,%esp
  8037a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8037ac:	6a 00                	push   $0x0
  8037ae:	e8 93 e0 ff ff       	call   801846 <sys_page_unmap>
  8037b3:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8037b6:	83 ec 08             	sub    $0x8,%esp
  8037b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8037bc:	6a 00                	push   $0x0
  8037be:	e8 83 e0 ff ff       	call   801846 <sys_page_unmap>
  8037c3:	83 c4 10             	add    $0x10,%esp
}
  8037c6:	89 d8                	mov    %ebx,%eax
  8037c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8037cb:	5b                   	pop    %ebx
  8037cc:	5e                   	pop    %esi
  8037cd:	5d                   	pop    %ebp
  8037ce:	c3                   	ret    

008037cf <pipeisclosed>:
{
  8037cf:	55                   	push   %ebp
  8037d0:	89 e5                	mov    %esp,%ebp
  8037d2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8037d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8037d8:	50                   	push   %eax
  8037d9:	ff 75 08             	pushl  0x8(%ebp)
  8037dc:	e8 88 e9 ff ff       	call   802169 <fd_lookup>
  8037e1:	83 c4 10             	add    $0x10,%esp
  8037e4:	85 c0                	test   %eax,%eax
  8037e6:	78 18                	js     803800 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8037e8:	83 ec 0c             	sub    $0xc,%esp
  8037eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8037ee:	e8 0d e9 ff ff       	call   802100 <fd2data>
	return _pipeisclosed(fd, p);
  8037f3:	89 c2                	mov    %eax,%edx
  8037f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f8:	e8 2f fd ff ff       	call   80352c <_pipeisclosed>
  8037fd:	83 c4 10             	add    $0x10,%esp
}
  803800:	c9                   	leave  
  803801:	c3                   	ret    

00803802 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  803802:	55                   	push   %ebp
  803803:	89 e5                	mov    %esp,%ebp
  803805:	56                   	push   %esi
  803806:	53                   	push   %ebx
  803807:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  80380a:	85 f6                	test   %esi,%esi
  80380c:	74 16                	je     803824 <wait+0x22>
	e = &envs[ENVX(envid)];
  80380e:	89 f3                	mov    %esi,%ebx
  803810:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE){
  803816:	69 db 84 00 00 00    	imul   $0x84,%ebx,%ebx
  80381c:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  803822:	eb 1b                	jmp    80383f <wait+0x3d>
	assert(envid != 0);
  803824:	68 76 45 80 00       	push   $0x804576
  803829:	68 cf 3d 80 00       	push   $0x803dcf
  80382e:	6a 09                	push   $0x9
  803830:	68 81 45 80 00       	push   $0x804581
  803835:	e8 50 d2 ff ff       	call   800a8a <_panic>
		sys_yield();
  80383a:	e8 63 df ff ff       	call   8017a2 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE){
  80383f:	8b 43 48             	mov    0x48(%ebx),%eax
  803842:	39 f0                	cmp    %esi,%eax
  803844:	75 07                	jne    80384d <wait+0x4b>
  803846:	8b 43 54             	mov    0x54(%ebx),%eax
  803849:	85 c0                	test   %eax,%eax
  80384b:	75 ed                	jne    80383a <wait+0x38>
	}
}
  80384d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803850:	5b                   	pop    %ebx
  803851:	5e                   	pop    %esi
  803852:	5d                   	pop    %ebp
  803853:	c3                   	ret    

00803854 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803854:	55                   	push   %ebp
  803855:	89 e5                	mov    %esp,%ebp
  803857:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80385a:	83 3d 00 90 80 00 00 	cmpl   $0x0,0x809000
  803861:	74 0a                	je     80386d <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803863:	8b 45 08             	mov    0x8(%ebp),%eax
  803866:	a3 00 90 80 00       	mov    %eax,0x809000
}
  80386b:	c9                   	leave  
  80386c:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  80386d:	83 ec 04             	sub    $0x4,%esp
  803870:	6a 07                	push   $0x7
  803872:	68 00 f0 bf ee       	push   $0xeebff000
  803877:	6a 00                	push   $0x0
  803879:	e8 43 df ff ff       	call   8017c1 <sys_page_alloc>
		if(r < 0)
  80387e:	83 c4 10             	add    $0x10,%esp
  803881:	85 c0                	test   %eax,%eax
  803883:	78 2a                	js     8038af <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  803885:	83 ec 08             	sub    $0x8,%esp
  803888:	68 c3 38 80 00       	push   $0x8038c3
  80388d:	6a 00                	push   $0x0
  80388f:	e8 78 e0 ff ff       	call   80190c <sys_env_set_pgfault_upcall>
		if(r < 0)
  803894:	83 c4 10             	add    $0x10,%esp
  803897:	85 c0                	test   %eax,%eax
  803899:	79 c8                	jns    803863 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  80389b:	83 ec 04             	sub    $0x4,%esp
  80389e:	68 bc 45 80 00       	push   $0x8045bc
  8038a3:	6a 25                	push   $0x25
  8038a5:	68 f8 45 80 00       	push   $0x8045f8
  8038aa:	e8 db d1 ff ff       	call   800a8a <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8038af:	83 ec 04             	sub    $0x4,%esp
  8038b2:	68 8c 45 80 00       	push   $0x80458c
  8038b7:	6a 22                	push   $0x22
  8038b9:	68 f8 45 80 00       	push   $0x8045f8
  8038be:	e8 c7 d1 ff ff       	call   800a8a <_panic>

008038c3 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8038c3:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8038c4:	a1 00 90 80 00       	mov    0x809000,%eax
	call *%eax
  8038c9:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8038cb:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8038ce:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8038d2:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8038d6:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8038d9:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8038db:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8038df:	83 c4 08             	add    $0x8,%esp
	popal
  8038e2:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8038e3:	83 c4 04             	add    $0x4,%esp
	popfl
  8038e6:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8038e7:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8038e8:	c3                   	ret    

008038e9 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8038e9:	55                   	push   %ebp
  8038ea:	89 e5                	mov    %esp,%ebp
  8038ec:	56                   	push   %esi
  8038ed:	53                   	push   %ebx
  8038ee:	8b 75 08             	mov    0x8(%ebp),%esi
  8038f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038f4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8038f7:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8038f9:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8038fe:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  803901:	83 ec 0c             	sub    $0xc,%esp
  803904:	50                   	push   %eax
  803905:	e8 67 e0 ff ff       	call   801971 <sys_ipc_recv>
	if(ret < 0){
  80390a:	83 c4 10             	add    $0x10,%esp
  80390d:	85 c0                	test   %eax,%eax
  80390f:	78 2b                	js     80393c <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  803911:	85 f6                	test   %esi,%esi
  803913:	74 0a                	je     80391f <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  803915:	a1 28 64 80 00       	mov    0x806428,%eax
  80391a:	8b 40 78             	mov    0x78(%eax),%eax
  80391d:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80391f:	85 db                	test   %ebx,%ebx
  803921:	74 0a                	je     80392d <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  803923:	a1 28 64 80 00       	mov    0x806428,%eax
  803928:	8b 40 7c             	mov    0x7c(%eax),%eax
  80392b:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80392d:	a1 28 64 80 00       	mov    0x806428,%eax
  803932:	8b 40 74             	mov    0x74(%eax),%eax
}
  803935:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803938:	5b                   	pop    %ebx
  803939:	5e                   	pop    %esi
  80393a:	5d                   	pop    %ebp
  80393b:	c3                   	ret    
		if(from_env_store)
  80393c:	85 f6                	test   %esi,%esi
  80393e:	74 06                	je     803946 <ipc_recv+0x5d>
			*from_env_store = 0;
  803940:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  803946:	85 db                	test   %ebx,%ebx
  803948:	74 eb                	je     803935 <ipc_recv+0x4c>
			*perm_store = 0;
  80394a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  803950:	eb e3                	jmp    803935 <ipc_recv+0x4c>

00803952 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  803952:	55                   	push   %ebp
  803953:	89 e5                	mov    %esp,%ebp
  803955:	57                   	push   %edi
  803956:	56                   	push   %esi
  803957:	53                   	push   %ebx
  803958:	83 ec 0c             	sub    $0xc,%esp
  80395b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80395e:	8b 75 0c             	mov    0xc(%ebp),%esi
  803961:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  803964:	85 db                	test   %ebx,%ebx
  803966:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80396b:	0f 44 d8             	cmove  %eax,%ebx
  80396e:	eb 05                	jmp    803975 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  803970:	e8 2d de ff ff       	call   8017a2 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  803975:	ff 75 14             	pushl  0x14(%ebp)
  803978:	53                   	push   %ebx
  803979:	56                   	push   %esi
  80397a:	57                   	push   %edi
  80397b:	e8 ce df ff ff       	call   80194e <sys_ipc_try_send>
  803980:	83 c4 10             	add    $0x10,%esp
  803983:	85 c0                	test   %eax,%eax
  803985:	74 1b                	je     8039a2 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  803987:	79 e7                	jns    803970 <ipc_send+0x1e>
  803989:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80398c:	74 e2                	je     803970 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80398e:	83 ec 04             	sub    $0x4,%esp
  803991:	68 06 46 80 00       	push   $0x804606
  803996:	6a 46                	push   $0x46
  803998:	68 1b 46 80 00       	push   $0x80461b
  80399d:	e8 e8 d0 ff ff       	call   800a8a <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8039a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8039a5:	5b                   	pop    %ebx
  8039a6:	5e                   	pop    %esi
  8039a7:	5f                   	pop    %edi
  8039a8:	5d                   	pop    %ebp
  8039a9:	c3                   	ret    

008039aa <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8039aa:	55                   	push   %ebp
  8039ab:	89 e5                	mov    %esp,%ebp
  8039ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8039b0:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8039b5:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8039bb:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8039c1:	8b 52 50             	mov    0x50(%edx),%edx
  8039c4:	39 ca                	cmp    %ecx,%edx
  8039c6:	74 11                	je     8039d9 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8039c8:	83 c0 01             	add    $0x1,%eax
  8039cb:	3d 00 04 00 00       	cmp    $0x400,%eax
  8039d0:	75 e3                	jne    8039b5 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8039d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8039d7:	eb 0e                	jmp    8039e7 <ipc_find_env+0x3d>
			return envs[i].env_id;
  8039d9:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8039df:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8039e4:	8b 40 48             	mov    0x48(%eax),%eax
}
  8039e7:	5d                   	pop    %ebp
  8039e8:	c3                   	ret    

008039e9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8039e9:	55                   	push   %ebp
  8039ea:	89 e5                	mov    %esp,%ebp
  8039ec:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8039ef:	89 d0                	mov    %edx,%eax
  8039f1:	c1 e8 16             	shr    $0x16,%eax
  8039f4:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8039fb:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  803a00:	f6 c1 01             	test   $0x1,%cl
  803a03:	74 1d                	je     803a22 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  803a05:	c1 ea 0c             	shr    $0xc,%edx
  803a08:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803a0f:	f6 c2 01             	test   $0x1,%dl
  803a12:	74 0e                	je     803a22 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803a14:	c1 ea 0c             	shr    $0xc,%edx
  803a17:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  803a1e:	ef 
  803a1f:	0f b7 c0             	movzwl %ax,%eax
}
  803a22:	5d                   	pop    %ebp
  803a23:	c3                   	ret    
  803a24:	66 90                	xchg   %ax,%ax
  803a26:	66 90                	xchg   %ax,%ax
  803a28:	66 90                	xchg   %ax,%ax
  803a2a:	66 90                	xchg   %ax,%ax
  803a2c:	66 90                	xchg   %ax,%ax
  803a2e:	66 90                	xchg   %ax,%ax

00803a30 <__udivdi3>:
  803a30:	55                   	push   %ebp
  803a31:	57                   	push   %edi
  803a32:	56                   	push   %esi
  803a33:	53                   	push   %ebx
  803a34:	83 ec 1c             	sub    $0x1c,%esp
  803a37:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  803a3b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  803a3f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a43:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  803a47:	85 d2                	test   %edx,%edx
  803a49:	75 4d                	jne    803a98 <__udivdi3+0x68>
  803a4b:	39 f3                	cmp    %esi,%ebx
  803a4d:	76 19                	jbe    803a68 <__udivdi3+0x38>
  803a4f:	31 ff                	xor    %edi,%edi
  803a51:	89 e8                	mov    %ebp,%eax
  803a53:	89 f2                	mov    %esi,%edx
  803a55:	f7 f3                	div    %ebx
  803a57:	89 fa                	mov    %edi,%edx
  803a59:	83 c4 1c             	add    $0x1c,%esp
  803a5c:	5b                   	pop    %ebx
  803a5d:	5e                   	pop    %esi
  803a5e:	5f                   	pop    %edi
  803a5f:	5d                   	pop    %ebp
  803a60:	c3                   	ret    
  803a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803a68:	89 d9                	mov    %ebx,%ecx
  803a6a:	85 db                	test   %ebx,%ebx
  803a6c:	75 0b                	jne    803a79 <__udivdi3+0x49>
  803a6e:	b8 01 00 00 00       	mov    $0x1,%eax
  803a73:	31 d2                	xor    %edx,%edx
  803a75:	f7 f3                	div    %ebx
  803a77:	89 c1                	mov    %eax,%ecx
  803a79:	31 d2                	xor    %edx,%edx
  803a7b:	89 f0                	mov    %esi,%eax
  803a7d:	f7 f1                	div    %ecx
  803a7f:	89 c6                	mov    %eax,%esi
  803a81:	89 e8                	mov    %ebp,%eax
  803a83:	89 f7                	mov    %esi,%edi
  803a85:	f7 f1                	div    %ecx
  803a87:	89 fa                	mov    %edi,%edx
  803a89:	83 c4 1c             	add    $0x1c,%esp
  803a8c:	5b                   	pop    %ebx
  803a8d:	5e                   	pop    %esi
  803a8e:	5f                   	pop    %edi
  803a8f:	5d                   	pop    %ebp
  803a90:	c3                   	ret    
  803a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803a98:	39 f2                	cmp    %esi,%edx
  803a9a:	77 1c                	ja     803ab8 <__udivdi3+0x88>
  803a9c:	0f bd fa             	bsr    %edx,%edi
  803a9f:	83 f7 1f             	xor    $0x1f,%edi
  803aa2:	75 2c                	jne    803ad0 <__udivdi3+0xa0>
  803aa4:	39 f2                	cmp    %esi,%edx
  803aa6:	72 06                	jb     803aae <__udivdi3+0x7e>
  803aa8:	31 c0                	xor    %eax,%eax
  803aaa:	39 eb                	cmp    %ebp,%ebx
  803aac:	77 a9                	ja     803a57 <__udivdi3+0x27>
  803aae:	b8 01 00 00 00       	mov    $0x1,%eax
  803ab3:	eb a2                	jmp    803a57 <__udivdi3+0x27>
  803ab5:	8d 76 00             	lea    0x0(%esi),%esi
  803ab8:	31 ff                	xor    %edi,%edi
  803aba:	31 c0                	xor    %eax,%eax
  803abc:	89 fa                	mov    %edi,%edx
  803abe:	83 c4 1c             	add    $0x1c,%esp
  803ac1:	5b                   	pop    %ebx
  803ac2:	5e                   	pop    %esi
  803ac3:	5f                   	pop    %edi
  803ac4:	5d                   	pop    %ebp
  803ac5:	c3                   	ret    
  803ac6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803acd:	8d 76 00             	lea    0x0(%esi),%esi
  803ad0:	89 f9                	mov    %edi,%ecx
  803ad2:	b8 20 00 00 00       	mov    $0x20,%eax
  803ad7:	29 f8                	sub    %edi,%eax
  803ad9:	d3 e2                	shl    %cl,%edx
  803adb:	89 54 24 08          	mov    %edx,0x8(%esp)
  803adf:	89 c1                	mov    %eax,%ecx
  803ae1:	89 da                	mov    %ebx,%edx
  803ae3:	d3 ea                	shr    %cl,%edx
  803ae5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803ae9:	09 d1                	or     %edx,%ecx
  803aeb:	89 f2                	mov    %esi,%edx
  803aed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803af1:	89 f9                	mov    %edi,%ecx
  803af3:	d3 e3                	shl    %cl,%ebx
  803af5:	89 c1                	mov    %eax,%ecx
  803af7:	d3 ea                	shr    %cl,%edx
  803af9:	89 f9                	mov    %edi,%ecx
  803afb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  803aff:	89 eb                	mov    %ebp,%ebx
  803b01:	d3 e6                	shl    %cl,%esi
  803b03:	89 c1                	mov    %eax,%ecx
  803b05:	d3 eb                	shr    %cl,%ebx
  803b07:	09 de                	or     %ebx,%esi
  803b09:	89 f0                	mov    %esi,%eax
  803b0b:	f7 74 24 08          	divl   0x8(%esp)
  803b0f:	89 d6                	mov    %edx,%esi
  803b11:	89 c3                	mov    %eax,%ebx
  803b13:	f7 64 24 0c          	mull   0xc(%esp)
  803b17:	39 d6                	cmp    %edx,%esi
  803b19:	72 15                	jb     803b30 <__udivdi3+0x100>
  803b1b:	89 f9                	mov    %edi,%ecx
  803b1d:	d3 e5                	shl    %cl,%ebp
  803b1f:	39 c5                	cmp    %eax,%ebp
  803b21:	73 04                	jae    803b27 <__udivdi3+0xf7>
  803b23:	39 d6                	cmp    %edx,%esi
  803b25:	74 09                	je     803b30 <__udivdi3+0x100>
  803b27:	89 d8                	mov    %ebx,%eax
  803b29:	31 ff                	xor    %edi,%edi
  803b2b:	e9 27 ff ff ff       	jmp    803a57 <__udivdi3+0x27>
  803b30:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b33:	31 ff                	xor    %edi,%edi
  803b35:	e9 1d ff ff ff       	jmp    803a57 <__udivdi3+0x27>
  803b3a:	66 90                	xchg   %ax,%ax
  803b3c:	66 90                	xchg   %ax,%ax
  803b3e:	66 90                	xchg   %ax,%ax

00803b40 <__umoddi3>:
  803b40:	55                   	push   %ebp
  803b41:	57                   	push   %edi
  803b42:	56                   	push   %esi
  803b43:	53                   	push   %ebx
  803b44:	83 ec 1c             	sub    $0x1c,%esp
  803b47:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  803b4b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b4f:	8b 74 24 30          	mov    0x30(%esp),%esi
  803b53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b57:	89 da                	mov    %ebx,%edx
  803b59:	85 c0                	test   %eax,%eax
  803b5b:	75 43                	jne    803ba0 <__umoddi3+0x60>
  803b5d:	39 df                	cmp    %ebx,%edi
  803b5f:	76 17                	jbe    803b78 <__umoddi3+0x38>
  803b61:	89 f0                	mov    %esi,%eax
  803b63:	f7 f7                	div    %edi
  803b65:	89 d0                	mov    %edx,%eax
  803b67:	31 d2                	xor    %edx,%edx
  803b69:	83 c4 1c             	add    $0x1c,%esp
  803b6c:	5b                   	pop    %ebx
  803b6d:	5e                   	pop    %esi
  803b6e:	5f                   	pop    %edi
  803b6f:	5d                   	pop    %ebp
  803b70:	c3                   	ret    
  803b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803b78:	89 fd                	mov    %edi,%ebp
  803b7a:	85 ff                	test   %edi,%edi
  803b7c:	75 0b                	jne    803b89 <__umoddi3+0x49>
  803b7e:	b8 01 00 00 00       	mov    $0x1,%eax
  803b83:	31 d2                	xor    %edx,%edx
  803b85:	f7 f7                	div    %edi
  803b87:	89 c5                	mov    %eax,%ebp
  803b89:	89 d8                	mov    %ebx,%eax
  803b8b:	31 d2                	xor    %edx,%edx
  803b8d:	f7 f5                	div    %ebp
  803b8f:	89 f0                	mov    %esi,%eax
  803b91:	f7 f5                	div    %ebp
  803b93:	89 d0                	mov    %edx,%eax
  803b95:	eb d0                	jmp    803b67 <__umoddi3+0x27>
  803b97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803b9e:	66 90                	xchg   %ax,%ax
  803ba0:	89 f1                	mov    %esi,%ecx
  803ba2:	39 d8                	cmp    %ebx,%eax
  803ba4:	76 0a                	jbe    803bb0 <__umoddi3+0x70>
  803ba6:	89 f0                	mov    %esi,%eax
  803ba8:	83 c4 1c             	add    $0x1c,%esp
  803bab:	5b                   	pop    %ebx
  803bac:	5e                   	pop    %esi
  803bad:	5f                   	pop    %edi
  803bae:	5d                   	pop    %ebp
  803baf:	c3                   	ret    
  803bb0:	0f bd e8             	bsr    %eax,%ebp
  803bb3:	83 f5 1f             	xor    $0x1f,%ebp
  803bb6:	75 20                	jne    803bd8 <__umoddi3+0x98>
  803bb8:	39 d8                	cmp    %ebx,%eax
  803bba:	0f 82 b0 00 00 00    	jb     803c70 <__umoddi3+0x130>
  803bc0:	39 f7                	cmp    %esi,%edi
  803bc2:	0f 86 a8 00 00 00    	jbe    803c70 <__umoddi3+0x130>
  803bc8:	89 c8                	mov    %ecx,%eax
  803bca:	83 c4 1c             	add    $0x1c,%esp
  803bcd:	5b                   	pop    %ebx
  803bce:	5e                   	pop    %esi
  803bcf:	5f                   	pop    %edi
  803bd0:	5d                   	pop    %ebp
  803bd1:	c3                   	ret    
  803bd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803bd8:	89 e9                	mov    %ebp,%ecx
  803bda:	ba 20 00 00 00       	mov    $0x20,%edx
  803bdf:	29 ea                	sub    %ebp,%edx
  803be1:	d3 e0                	shl    %cl,%eax
  803be3:	89 44 24 08          	mov    %eax,0x8(%esp)
  803be7:	89 d1                	mov    %edx,%ecx
  803be9:	89 f8                	mov    %edi,%eax
  803beb:	d3 e8                	shr    %cl,%eax
  803bed:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803bf1:	89 54 24 04          	mov    %edx,0x4(%esp)
  803bf5:	8b 54 24 04          	mov    0x4(%esp),%edx
  803bf9:	09 c1                	or     %eax,%ecx
  803bfb:	89 d8                	mov    %ebx,%eax
  803bfd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c01:	89 e9                	mov    %ebp,%ecx
  803c03:	d3 e7                	shl    %cl,%edi
  803c05:	89 d1                	mov    %edx,%ecx
  803c07:	d3 e8                	shr    %cl,%eax
  803c09:	89 e9                	mov    %ebp,%ecx
  803c0b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c0f:	d3 e3                	shl    %cl,%ebx
  803c11:	89 c7                	mov    %eax,%edi
  803c13:	89 d1                	mov    %edx,%ecx
  803c15:	89 f0                	mov    %esi,%eax
  803c17:	d3 e8                	shr    %cl,%eax
  803c19:	89 e9                	mov    %ebp,%ecx
  803c1b:	89 fa                	mov    %edi,%edx
  803c1d:	d3 e6                	shl    %cl,%esi
  803c1f:	09 d8                	or     %ebx,%eax
  803c21:	f7 74 24 08          	divl   0x8(%esp)
  803c25:	89 d1                	mov    %edx,%ecx
  803c27:	89 f3                	mov    %esi,%ebx
  803c29:	f7 64 24 0c          	mull   0xc(%esp)
  803c2d:	89 c6                	mov    %eax,%esi
  803c2f:	89 d7                	mov    %edx,%edi
  803c31:	39 d1                	cmp    %edx,%ecx
  803c33:	72 06                	jb     803c3b <__umoddi3+0xfb>
  803c35:	75 10                	jne    803c47 <__umoddi3+0x107>
  803c37:	39 c3                	cmp    %eax,%ebx
  803c39:	73 0c                	jae    803c47 <__umoddi3+0x107>
  803c3b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  803c3f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  803c43:	89 d7                	mov    %edx,%edi
  803c45:	89 c6                	mov    %eax,%esi
  803c47:	89 ca                	mov    %ecx,%edx
  803c49:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  803c4e:	29 f3                	sub    %esi,%ebx
  803c50:	19 fa                	sbb    %edi,%edx
  803c52:	89 d0                	mov    %edx,%eax
  803c54:	d3 e0                	shl    %cl,%eax
  803c56:	89 e9                	mov    %ebp,%ecx
  803c58:	d3 eb                	shr    %cl,%ebx
  803c5a:	d3 ea                	shr    %cl,%edx
  803c5c:	09 d8                	or     %ebx,%eax
  803c5e:	83 c4 1c             	add    $0x1c,%esp
  803c61:	5b                   	pop    %ebx
  803c62:	5e                   	pop    %esi
  803c63:	5f                   	pop    %edi
  803c64:	5d                   	pop    %ebp
  803c65:	c3                   	ret    
  803c66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803c6d:	8d 76 00             	lea    0x0(%esi),%esi
  803c70:	89 da                	mov    %ebx,%edx
  803c72:	29 fe                	sub    %edi,%esi
  803c74:	19 c2                	sbb    %eax,%edx
  803c76:	89 f1                	mov    %esi,%ecx
  803c78:	89 c8                	mov    %ecx,%eax
  803c7a:	e9 4b ff ff ff       	jmp    803bca <__umoddi3+0x8a>
