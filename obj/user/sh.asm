
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
  80002c:	e8 9d 09 00 00       	call   8009ce <libmain>
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
  800046:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
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
  800065:	68 fd 35 80 00       	push   $0x8035fd
  80006a:	e8 54 14 00 00       	call   8014c3 <strchr>
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
  800084:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  80008b:	7e 3a                	jle    8000c7 <_gettoken+0x94>
			cprintf("GETTOKEN NULL\n");
  80008d:	83 ec 0c             	sub    $0xc,%esp
  800090:	68 e0 35 80 00       	push   $0x8035e0
  800095:	e8 d1 0a 00 00       	call   800b6b <cprintf>
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	eb 28                	jmp    8000c7 <_gettoken+0x94>
		cprintf("GETTOKEN: %s\n", s);
  80009f:	83 ec 08             	sub    $0x8,%esp
  8000a2:	53                   	push   %ebx
  8000a3:	68 ef 35 80 00       	push   $0x8035ef
  8000a8:	e8 be 0a 00 00       	call   800b6b <cprintf>
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
  8000be:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
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
  8000d4:	68 02 36 80 00       	push   $0x803602
  8000d9:	e8 8d 0a 00 00       	call   800b6b <cprintf>
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	eb e4                	jmp    8000c7 <_gettoken+0x94>
	if (strchr(SYMBOLS, *s)) {
  8000e3:	83 ec 08             	sub    $0x8,%esp
  8000e6:	0f be c0             	movsbl %al,%eax
  8000e9:	50                   	push   %eax
  8000ea:	68 13 36 80 00       	push   $0x803613
  8000ef:	e8 cf 13 00 00       	call   8014c3 <strchr>
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
  80010b:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  800112:	7e b3                	jle    8000c7 <_gettoken+0x94>
			cprintf("TOK %c\n", t);
  800114:	83 ec 08             	sub    $0x8,%esp
  800117:	56                   	push   %esi
  800118:	68 07 36 80 00       	push   $0x803607
  80011d:	e8 49 0a 00 00       	call   800b6b <cprintf>
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
  80013c:	68 0f 36 80 00       	push   $0x80360f
  800141:	e8 7d 13 00 00       	call   8014c3 <strchr>
  800146:	83 c4 10             	add    $0x10,%esp
  800149:	85 c0                	test   %eax,%eax
  80014b:	74 de                	je     80012b <_gettoken+0xf8>
	*p2 = s;
  80014d:	8b 45 10             	mov    0x10(%ebp),%eax
  800150:	89 18                	mov    %ebx,(%eax)
	return 'w';
  800152:	be 77 00 00 00       	mov    $0x77,%esi
	if (debug > 1) {
  800157:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  80015e:	0f 8e 63 ff ff ff    	jle    8000c7 <_gettoken+0x94>
		t = **p2;
  800164:	0f b6 33             	movzbl (%ebx),%esi
		**p2 = 0;
  800167:	c6 03 00             	movb   $0x0,(%ebx)
		cprintf("WORD: %s\n", *p1);
  80016a:	83 ec 08             	sub    $0x8,%esp
  80016d:	ff 37                	pushl  (%edi)
  80016f:	68 1b 36 80 00       	push   $0x80361b
  800174:	e8 f2 09 00 00       	call   800b6b <cprintf>
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
  80019f:	68 0c 50 80 00       	push   $0x80500c
  8001a4:	68 10 50 80 00       	push   $0x805010
  8001a9:	50                   	push   %eax
  8001aa:	e8 84 fe ff ff       	call   800033 <_gettoken>
  8001af:	a3 08 50 80 00       	mov    %eax,0x805008
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
  8001be:	a1 08 50 80 00       	mov    0x805008,%eax
  8001c3:	a3 04 50 80 00       	mov    %eax,0x805004
	*p1 = np1;
  8001c8:	8b 15 10 50 80 00    	mov    0x805010,%edx
  8001ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d1:	89 10                	mov    %edx,(%eax)
	nc = _gettoken(np2, &np1, &np2);
  8001d3:	83 ec 04             	sub    $0x4,%esp
  8001d6:	68 0c 50 80 00       	push   $0x80500c
  8001db:	68 10 50 80 00       	push   $0x805010
  8001e0:	ff 35 0c 50 80 00    	pushl  0x80500c
  8001e6:	e8 48 fe ff ff       	call   800033 <_gettoken>
  8001eb:	a3 08 50 80 00       	mov    %eax,0x805008
	return c;
  8001f0:	a1 04 50 80 00       	mov    0x805004,%eax
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
  800213:	8d 7d a4             	lea    -0x5c(%ebp),%edi
	argc = 0;
  800216:	be 00 00 00 00       	mov    $0x0,%esi
		switch ((c = gettoken(0, &t))) {
  80021b:	83 ec 08             	sub    $0x8,%esp
  80021e:	57                   	push   %edi
  80021f:	6a 00                	push   $0x0
  800221:	e8 69 ff ff ff       	call   80018f <gettoken>
  800226:	89 c3                	mov    %eax,%ebx
  800228:	83 c4 10             	add    $0x10,%esp
  80022b:	83 f8 3e             	cmp    $0x3e,%eax
  80022e:	0f 84 8b 01 00 00    	je     8003bf <runcmd+0x1c5>
  800234:	7e 72                	jle    8002a8 <runcmd+0xae>
  800236:	83 f8 77             	cmp    $0x77,%eax
  800239:	0f 84 3e 01 00 00    	je     80037d <runcmd+0x183>
  80023f:	83 f8 7c             	cmp    $0x7c,%eax
  800242:	0f 85 ab 02 00 00    	jne    8004f3 <runcmd+0x2f9>
			if ((r = pipe(p)) < 0) {
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	8d 85 9c fb ff ff    	lea    -0x464(%ebp),%eax
  800251:	50                   	push   %eax
  800252:	e8 90 2d 00 00       	call   802fe7 <pipe>
  800257:	83 c4 10             	add    $0x10,%esp
  80025a:	85 c0                	test   %eax,%eax
  80025c:	0f 88 df 01 00 00    	js     800441 <runcmd+0x247>
			if (debug)
  800262:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800269:	0f 85 ed 01 00 00    	jne    80045c <runcmd+0x262>
			if ((r = fork()) < 0) {
  80026f:	e8 76 19 00 00       	call   801bea <fork>
  800274:	89 c3                	mov    %eax,%ebx
  800276:	85 c0                	test   %eax,%eax
  800278:	0f 88 ff 01 00 00    	js     80047d <runcmd+0x283>
			if (r == 0) {
  80027e:	0f 85 0f 02 00 00    	jne    800493 <runcmd+0x299>
				if (p[0] != 0) {
  800284:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  80028a:	85 c0                	test   %eax,%eax
  80028c:	0f 85 22 02 00 00    	jne    8004b4 <runcmd+0x2ba>
				close(p[1]);
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  80029b:	e8 e9 1e 00 00       	call   802189 <close>
				goto again;
  8002a0:	83 c4 10             	add    $0x10,%esp
  8002a3:	e9 6e ff ff ff       	jmp    800216 <runcmd+0x1c>
		switch ((c = gettoken(0, &t))) {
  8002a8:	85 c0                	test   %eax,%eax
  8002aa:	0f 85 9a 00 00 00    	jne    80034a <runcmd+0x150>
	if(argc == 0) {
  8002b0:	85 f6                	test   %esi,%esi
  8002b2:	0f 84 4d 02 00 00    	je     800505 <runcmd+0x30b>
	if (argv[0][0] != '/') {
  8002b8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8002bb:	80 38 2f             	cmpb   $0x2f,(%eax)
  8002be:	0f 85 63 02 00 00    	jne    800527 <runcmd+0x32d>
	argv[argc] = 0;
  8002c4:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
  8002cb:	00 
	if (debug) {
  8002cc:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8002d3:	0f 85 76 02 00 00    	jne    80054f <runcmd+0x355>
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  8002d9:	83 ec 08             	sub    $0x8,%esp
  8002dc:	8d 45 a8             	lea    -0x58(%ebp),%eax
  8002df:	50                   	push   %eax
  8002e0:	ff 75 a8             	pushl  -0x58(%ebp)
  8002e3:	e8 cf 25 00 00       	call   8028b7 <spawn>
  8002e8:	89 c6                	mov    %eax,%esi
  8002ea:	83 c4 10             	add    $0x10,%esp
  8002ed:	85 c0                	test   %eax,%eax
  8002ef:	0f 88 a8 02 00 00    	js     80059d <runcmd+0x3a3>
	close_all();
  8002f5:	e8 bc 1e 00 00       	call   8021b6 <close_all>
		if (debug)
  8002fa:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800301:	0f 85 e3 02 00 00    	jne    8005ea <runcmd+0x3f0>
		wait(r);
  800307:	83 ec 0c             	sub    $0xc,%esp
  80030a:	56                   	push   %esi
  80030b:	e8 54 2e 00 00       	call   803164 <wait>
		if (debug)
  800310:	83 c4 10             	add    $0x10,%esp
  800313:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80031a:	0f 85 e9 02 00 00    	jne    800609 <runcmd+0x40f>
	if (pipe_child) {
  800320:	85 db                	test   %ebx,%ebx
  800322:	74 19                	je     80033d <runcmd+0x143>
		wait(pipe_child);
  800324:	83 ec 0c             	sub    $0xc,%esp
  800327:	53                   	push   %ebx
  800328:	e8 37 2e 00 00       	call   803164 <wait>
		if (debug)
  80032d:	83 c4 10             	add    $0x10,%esp
  800330:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800337:	0f 85 e7 02 00 00    	jne    800624 <runcmd+0x42a>
	exit();
  80033d:	e8 21 07 00 00       	call   800a63 <exit>
}
  800342:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800345:	5b                   	pop    %ebx
  800346:	5e                   	pop    %esi
  800347:	5f                   	pop    %edi
  800348:	5d                   	pop    %ebp
  800349:	c3                   	ret    
		switch ((c = gettoken(0, &t))) {
  80034a:	83 f8 3c             	cmp    $0x3c,%eax
  80034d:	0f 85 a0 01 00 00    	jne    8004f3 <runcmd+0x2f9>
			if (gettoken(0, &t) != 'w') {
  800353:	83 ec 08             	sub    $0x8,%esp
  800356:	8d 45 a4             	lea    -0x5c(%ebp),%eax
  800359:	50                   	push   %eax
  80035a:	6a 00                	push   $0x0
  80035c:	e8 2e fe ff ff       	call   80018f <gettoken>
  800361:	83 c4 10             	add    $0x10,%esp
  800364:	83 f8 77             	cmp    $0x77,%eax
  800367:	75 3f                	jne    8003a8 <runcmd+0x1ae>
			panic("< redirection not implemented");
  800369:	83 ec 04             	sub    $0x4,%esp
  80036c:	68 39 36 80 00       	push   $0x803639
  800371:	6a 3a                	push   $0x3a
  800373:	68 57 36 80 00       	push   $0x803657
  800378:	e8 f8 06 00 00       	call   800a75 <_panic>
			if (argc == MAXARGS) {
  80037d:	83 fe 10             	cmp    $0x10,%esi
  800380:	74 0f                	je     800391 <runcmd+0x197>
			argv[argc++] = t;
  800382:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800385:	89 44 b5 a8          	mov    %eax,-0x58(%ebp,%esi,4)
  800389:	8d 76 01             	lea    0x1(%esi),%esi
			break;
  80038c:	e9 8a fe ff ff       	jmp    80021b <runcmd+0x21>
				cprintf("too many arguments\n");
  800391:	83 ec 0c             	sub    $0xc,%esp
  800394:	68 25 36 80 00       	push   $0x803625
  800399:	e8 cd 07 00 00       	call   800b6b <cprintf>
				exit();
  80039e:	e8 c0 06 00 00       	call   800a63 <exit>
  8003a3:	83 c4 10             	add    $0x10,%esp
  8003a6:	eb da                	jmp    800382 <runcmd+0x188>
				cprintf("syntax error: < not followed by word\n");
  8003a8:	83 ec 0c             	sub    $0xc,%esp
  8003ab:	68 80 37 80 00       	push   $0x803780
  8003b0:	e8 b6 07 00 00       	call   800b6b <cprintf>
				exit();
  8003b5:	e8 a9 06 00 00       	call   800a63 <exit>
  8003ba:	83 c4 10             	add    $0x10,%esp
  8003bd:	eb aa                	jmp    800369 <runcmd+0x16f>
			if (gettoken(0, &t) != 'w') {
  8003bf:	83 ec 08             	sub    $0x8,%esp
  8003c2:	57                   	push   %edi
  8003c3:	6a 00                	push   $0x0
  8003c5:	e8 c5 fd ff ff       	call   80018f <gettoken>
  8003ca:	83 c4 10             	add    $0x10,%esp
  8003cd:	83 f8 77             	cmp    $0x77,%eax
  8003d0:	75 24                	jne    8003f6 <runcmd+0x1fc>
			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
  8003d2:	83 ec 08             	sub    $0x8,%esp
  8003d5:	68 01 03 00 00       	push   $0x301
  8003da:	ff 75 a4             	pushl  -0x5c(%ebp)
  8003dd:	e8 1c 23 00 00       	call   8026fe <open>
  8003e2:	89 c3                	mov    %eax,%ebx
  8003e4:	83 c4 10             	add    $0x10,%esp
  8003e7:	85 c0                	test   %eax,%eax
  8003e9:	78 22                	js     80040d <runcmd+0x213>
			if (fd != 1) {
  8003eb:	83 f8 01             	cmp    $0x1,%eax
  8003ee:	0f 84 27 fe ff ff    	je     80021b <runcmd+0x21>
  8003f4:	eb 30                	jmp    800426 <runcmd+0x22c>
				cprintf("syntax error: > not followed by word\n");
  8003f6:	83 ec 0c             	sub    $0xc,%esp
  8003f9:	68 a8 37 80 00       	push   $0x8037a8
  8003fe:	e8 68 07 00 00       	call   800b6b <cprintf>
				exit();
  800403:	e8 5b 06 00 00       	call   800a63 <exit>
  800408:	83 c4 10             	add    $0x10,%esp
  80040b:	eb c5                	jmp    8003d2 <runcmd+0x1d8>
				cprintf("open %s for write: %e", t, fd);
  80040d:	83 ec 04             	sub    $0x4,%esp
  800410:	50                   	push   %eax
  800411:	ff 75 a4             	pushl  -0x5c(%ebp)
  800414:	68 61 36 80 00       	push   $0x803661
  800419:	e8 4d 07 00 00       	call   800b6b <cprintf>
				exit();
  80041e:	e8 40 06 00 00       	call   800a63 <exit>
  800423:	83 c4 10             	add    $0x10,%esp
				dup(fd, 1);
  800426:	83 ec 08             	sub    $0x8,%esp
  800429:	6a 01                	push   $0x1
  80042b:	53                   	push   %ebx
  80042c:	e8 aa 1d 00 00       	call   8021db <dup>
				close(fd);
  800431:	89 1c 24             	mov    %ebx,(%esp)
  800434:	e8 50 1d 00 00       	call   802189 <close>
  800439:	83 c4 10             	add    $0x10,%esp
  80043c:	e9 da fd ff ff       	jmp    80021b <runcmd+0x21>
				cprintf("pipe: %e", r);
  800441:	83 ec 08             	sub    $0x8,%esp
  800444:	50                   	push   %eax
  800445:	68 77 36 80 00       	push   $0x803677
  80044a:	e8 1c 07 00 00       	call   800b6b <cprintf>
				exit();
  80044f:	e8 0f 06 00 00       	call   800a63 <exit>
  800454:	83 c4 10             	add    $0x10,%esp
  800457:	e9 06 fe ff ff       	jmp    800262 <runcmd+0x68>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  80045c:	83 ec 04             	sub    $0x4,%esp
  80045f:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  800465:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  80046b:	68 80 36 80 00       	push   $0x803680
  800470:	e8 f6 06 00 00       	call   800b6b <cprintf>
  800475:	83 c4 10             	add    $0x10,%esp
  800478:	e9 f2 fd ff ff       	jmp    80026f <runcmd+0x75>
				cprintf("fork: %e", r);
  80047d:	83 ec 08             	sub    $0x8,%esp
  800480:	50                   	push   %eax
  800481:	68 8d 36 80 00       	push   $0x80368d
  800486:	e8 e0 06 00 00       	call   800b6b <cprintf>
				exit();
  80048b:	e8 d3 05 00 00       	call   800a63 <exit>
  800490:	83 c4 10             	add    $0x10,%esp
				if (p[1] != 1) {
  800493:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  800499:	83 f8 01             	cmp    $0x1,%eax
  80049c:	75 37                	jne    8004d5 <runcmd+0x2db>
				close(p[0]);
  80049e:	83 ec 0c             	sub    $0xc,%esp
  8004a1:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  8004a7:	e8 dd 1c 00 00       	call   802189 <close>
				goto runit;
  8004ac:	83 c4 10             	add    $0x10,%esp
  8004af:	e9 fc fd ff ff       	jmp    8002b0 <runcmd+0xb6>
					dup(p[0], 0);
  8004b4:	83 ec 08             	sub    $0x8,%esp
  8004b7:	6a 00                	push   $0x0
  8004b9:	50                   	push   %eax
  8004ba:	e8 1c 1d 00 00       	call   8021db <dup>
					close(p[0]);
  8004bf:	83 c4 04             	add    $0x4,%esp
  8004c2:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  8004c8:	e8 bc 1c 00 00       	call   802189 <close>
  8004cd:	83 c4 10             	add    $0x10,%esp
  8004d0:	e9 bd fd ff ff       	jmp    800292 <runcmd+0x98>
					dup(p[1], 1);
  8004d5:	83 ec 08             	sub    $0x8,%esp
  8004d8:	6a 01                	push   $0x1
  8004da:	50                   	push   %eax
  8004db:	e8 fb 1c 00 00       	call   8021db <dup>
					close(p[1]);
  8004e0:	83 c4 04             	add    $0x4,%esp
  8004e3:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  8004e9:	e8 9b 1c 00 00       	call   802189 <close>
  8004ee:	83 c4 10             	add    $0x10,%esp
  8004f1:	eb ab                	jmp    80049e <runcmd+0x2a4>
			panic("bad return %d from gettoken", c);
  8004f3:	53                   	push   %ebx
  8004f4:	68 96 36 80 00       	push   $0x803696
  8004f9:	6a 70                	push   $0x70
  8004fb:	68 57 36 80 00       	push   $0x803657
  800500:	e8 70 05 00 00       	call   800a75 <_panic>
		if (debug)
  800505:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80050c:	0f 84 30 fe ff ff    	je     800342 <runcmd+0x148>
			cprintf("EMPTY COMMAND\n");
  800512:	83 ec 0c             	sub    $0xc,%esp
  800515:	68 b2 36 80 00       	push   $0x8036b2
  80051a:	e8 4c 06 00 00       	call   800b6b <cprintf>
  80051f:	83 c4 10             	add    $0x10,%esp
  800522:	e9 1b fe ff ff       	jmp    800342 <runcmd+0x148>
		argv0buf[0] = '/';
  800527:	c6 85 a4 fb ff ff 2f 	movb   $0x2f,-0x45c(%ebp)
		strcpy(argv0buf + 1, argv[0]);
  80052e:	83 ec 08             	sub    $0x8,%esp
  800531:	50                   	push   %eax
  800532:	8d bd a4 fb ff ff    	lea    -0x45c(%ebp),%edi
  800538:	8d 85 a5 fb ff ff    	lea    -0x45b(%ebp),%eax
  80053e:	50                   	push   %eax
  80053f:	e8 76 0e 00 00       	call   8013ba <strcpy>
		argv[0] = argv0buf;
  800544:	89 7d a8             	mov    %edi,-0x58(%ebp)
  800547:	83 c4 10             	add    $0x10,%esp
  80054a:	e9 75 fd ff ff       	jmp    8002c4 <runcmd+0xca>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  80054f:	a1 24 54 80 00       	mov    0x805424,%eax
  800554:	8b 40 48             	mov    0x48(%eax),%eax
  800557:	83 ec 08             	sub    $0x8,%esp
  80055a:	50                   	push   %eax
  80055b:	68 c1 36 80 00       	push   $0x8036c1
  800560:	e8 06 06 00 00       	call   800b6b <cprintf>
  800565:	8d 75 a8             	lea    -0x58(%ebp),%esi
		for (i = 0; argv[i]; i++)
  800568:	83 c4 10             	add    $0x10,%esp
  80056b:	eb 11                	jmp    80057e <runcmd+0x384>
			cprintf(" %s", argv[i]);
  80056d:	83 ec 08             	sub    $0x8,%esp
  800570:	50                   	push   %eax
  800571:	68 49 37 80 00       	push   $0x803749
  800576:	e8 f0 05 00 00       	call   800b6b <cprintf>
  80057b:	83 c4 10             	add    $0x10,%esp
  80057e:	83 c6 04             	add    $0x4,%esi
		for (i = 0; argv[i]; i++)
  800581:	8b 46 fc             	mov    -0x4(%esi),%eax
  800584:	85 c0                	test   %eax,%eax
  800586:	75 e5                	jne    80056d <runcmd+0x373>
		cprintf("\n");
  800588:	83 ec 0c             	sub    $0xc,%esp
  80058b:	68 00 36 80 00       	push   $0x803600
  800590:	e8 d6 05 00 00       	call   800b6b <cprintf>
  800595:	83 c4 10             	add    $0x10,%esp
  800598:	e9 3c fd ff ff       	jmp    8002d9 <runcmd+0xdf>
		cprintf("spawn %s: %e\n", argv[0], r);
  80059d:	83 ec 04             	sub    $0x4,%esp
  8005a0:	50                   	push   %eax
  8005a1:	ff 75 a8             	pushl  -0x58(%ebp)
  8005a4:	68 cf 36 80 00       	push   $0x8036cf
  8005a9:	e8 bd 05 00 00       	call   800b6b <cprintf>
	close_all();
  8005ae:	e8 03 1c 00 00       	call   8021b6 <close_all>
  8005b3:	83 c4 10             	add    $0x10,%esp
	if (pipe_child) {
  8005b6:	85 db                	test   %ebx,%ebx
  8005b8:	0f 84 7f fd ff ff    	je     80033d <runcmd+0x143>
		if (debug)
  8005be:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8005c5:	0f 84 59 fd ff ff    	je     800324 <runcmd+0x12a>
			cprintf("[%08x] WAIT pipe_child %08x\n", thisenv->env_id, pipe_child);
  8005cb:	a1 24 54 80 00       	mov    0x805424,%eax
  8005d0:	8b 40 48             	mov    0x48(%eax),%eax
  8005d3:	83 ec 04             	sub    $0x4,%esp
  8005d6:	53                   	push   %ebx
  8005d7:	50                   	push   %eax
  8005d8:	68 08 37 80 00       	push   $0x803708
  8005dd:	e8 89 05 00 00       	call   800b6b <cprintf>
  8005e2:	83 c4 10             	add    $0x10,%esp
  8005e5:	e9 3a fd ff ff       	jmp    800324 <runcmd+0x12a>
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  8005ea:	a1 24 54 80 00       	mov    0x805424,%eax
  8005ef:	8b 40 48             	mov    0x48(%eax),%eax
  8005f2:	56                   	push   %esi
  8005f3:	ff 75 a8             	pushl  -0x58(%ebp)
  8005f6:	50                   	push   %eax
  8005f7:	68 dd 36 80 00       	push   $0x8036dd
  8005fc:	e8 6a 05 00 00       	call   800b6b <cprintf>
  800601:	83 c4 10             	add    $0x10,%esp
  800604:	e9 fe fc ff ff       	jmp    800307 <runcmd+0x10d>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800609:	a1 24 54 80 00       	mov    0x805424,%eax
  80060e:	8b 40 48             	mov    0x48(%eax),%eax
  800611:	83 ec 08             	sub    $0x8,%esp
  800614:	50                   	push   %eax
  800615:	68 f2 36 80 00       	push   $0x8036f2
  80061a:	e8 4c 05 00 00       	call   800b6b <cprintf>
  80061f:	83 c4 10             	add    $0x10,%esp
  800622:	eb 92                	jmp    8005b6 <runcmd+0x3bc>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800624:	a1 24 54 80 00       	mov    0x805424,%eax
  800629:	8b 40 48             	mov    0x48(%eax),%eax
  80062c:	83 ec 08             	sub    $0x8,%esp
  80062f:	50                   	push   %eax
  800630:	68 f2 36 80 00       	push   $0x8036f2
  800635:	e8 31 05 00 00       	call   800b6b <cprintf>
  80063a:	83 c4 10             	add    $0x10,%esp
  80063d:	e9 fb fc ff ff       	jmp    80033d <runcmd+0x143>

00800642 <usage>:


void
usage(void)
{
  800642:	55                   	push   %ebp
  800643:	89 e5                	mov    %esp,%ebp
  800645:	83 ec 14             	sub    $0x14,%esp
	cprintf("usage: sh [-dix] [command-file]\n");
  800648:	68 d0 37 80 00       	push   $0x8037d0
  80064d:	e8 19 05 00 00       	call   800b6b <cprintf>
	exit();
  800652:	e8 0c 04 00 00       	call   800a63 <exit>
}
  800657:	83 c4 10             	add    $0x10,%esp
  80065a:	c9                   	leave  
  80065b:	c3                   	ret    

0080065c <umain>:

void
umain(int argc, char **argv)
{
  80065c:	55                   	push   %ebp
  80065d:	89 e5                	mov    %esp,%ebp
  80065f:	57                   	push   %edi
  800660:	56                   	push   %esi
  800661:	53                   	push   %ebx
  800662:	83 ec 30             	sub    $0x30,%esp
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
  800665:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800668:	50                   	push   %eax
  800669:	ff 75 0c             	pushl  0xc(%ebp)
  80066c:	8d 45 08             	lea    0x8(%ebp),%eax
  80066f:	50                   	push   %eax
  800670:	e8 21 18 00 00       	call   801e96 <argstart>
	while ((r = argnext(&args)) >= 0)
  800675:	83 c4 10             	add    $0x10,%esp
	echocmds = 0;
  800678:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
	interactive = '?';
  80067f:	bf 3f 00 00 00       	mov    $0x3f,%edi
	while ((r = argnext(&args)) >= 0)
  800684:	8d 5d d8             	lea    -0x28(%ebp),%ebx
		switch (r) {
		case 'd':
			debug++;
			break;
		case 'i':
			interactive = 1;
  800687:	be 01 00 00 00       	mov    $0x1,%esi
	while ((r = argnext(&args)) >= 0)
  80068c:	eb 10                	jmp    80069e <umain+0x42>
			debug++;
  80068e:	83 05 00 50 80 00 01 	addl   $0x1,0x805000
			break;
  800695:	eb 07                	jmp    80069e <umain+0x42>
			interactive = 1;
  800697:	89 f7                	mov    %esi,%edi
  800699:	eb 03                	jmp    80069e <umain+0x42>
			break;
		case 'x':
			echocmds = 1;
  80069b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
	while ((r = argnext(&args)) >= 0)
  80069e:	83 ec 0c             	sub    $0xc,%esp
  8006a1:	53                   	push   %ebx
  8006a2:	e8 1f 18 00 00       	call   801ec6 <argnext>
  8006a7:	83 c4 10             	add    $0x10,%esp
  8006aa:	85 c0                	test   %eax,%eax
  8006ac:	78 16                	js     8006c4 <umain+0x68>
		switch (r) {
  8006ae:	83 f8 69             	cmp    $0x69,%eax
  8006b1:	74 e4                	je     800697 <umain+0x3b>
  8006b3:	83 f8 78             	cmp    $0x78,%eax
  8006b6:	74 e3                	je     80069b <umain+0x3f>
  8006b8:	83 f8 64             	cmp    $0x64,%eax
  8006bb:	74 d1                	je     80068e <umain+0x32>
			break;
		default:
			usage();
  8006bd:	e8 80 ff ff ff       	call   800642 <usage>
  8006c2:	eb da                	jmp    80069e <umain+0x42>
		}

	if (argc > 2)
  8006c4:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  8006c8:	7f 1f                	jg     8006e9 <umain+0x8d>
		usage();
	if (argc == 2) {
  8006ca:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  8006ce:	74 20                	je     8006f0 <umain+0x94>
		close(0);
		if ((r = open(argv[1], O_RDONLY)) < 0)
			panic("open %s: %e", argv[1], r);
		assert(r == 0);
	}
	if (interactive == '?')
  8006d0:	83 ff 3f             	cmp    $0x3f,%edi
  8006d3:	74 75                	je     80074a <umain+0xee>
  8006d5:	85 ff                	test   %edi,%edi
  8006d7:	bf 4d 37 80 00       	mov    $0x80374d,%edi
  8006dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8006e1:	0f 44 f8             	cmove  %eax,%edi
  8006e4:	e9 06 01 00 00       	jmp    8007ef <umain+0x193>
		usage();
  8006e9:	e8 54 ff ff ff       	call   800642 <usage>
  8006ee:	eb da                	jmp    8006ca <umain+0x6e>
		close(0);
  8006f0:	83 ec 0c             	sub    $0xc,%esp
  8006f3:	6a 00                	push   $0x0
  8006f5:	e8 8f 1a 00 00       	call   802189 <close>
		if ((r = open(argv[1], O_RDONLY)) < 0)
  8006fa:	83 c4 08             	add    $0x8,%esp
  8006fd:	6a 00                	push   $0x0
  8006ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800702:	ff 70 04             	pushl  0x4(%eax)
  800705:	e8 f4 1f 00 00       	call   8026fe <open>
  80070a:	83 c4 10             	add    $0x10,%esp
  80070d:	85 c0                	test   %eax,%eax
  80070f:	78 1b                	js     80072c <umain+0xd0>
		assert(r == 0);
  800711:	74 bd                	je     8006d0 <umain+0x74>
  800713:	68 31 37 80 00       	push   $0x803731
  800718:	68 38 37 80 00       	push   $0x803738
  80071d:	68 21 01 00 00       	push   $0x121
  800722:	68 57 36 80 00       	push   $0x803657
  800727:	e8 49 03 00 00       	call   800a75 <_panic>
			panic("open %s: %e", argv[1], r);
  80072c:	83 ec 0c             	sub    $0xc,%esp
  80072f:	50                   	push   %eax
  800730:	8b 45 0c             	mov    0xc(%ebp),%eax
  800733:	ff 70 04             	pushl  0x4(%eax)
  800736:	68 25 37 80 00       	push   $0x803725
  80073b:	68 20 01 00 00       	push   $0x120
  800740:	68 57 36 80 00       	push   $0x803657
  800745:	e8 2b 03 00 00       	call   800a75 <_panic>
		interactive = iscons(0);
  80074a:	83 ec 0c             	sub    $0xc,%esp
  80074d:	6a 00                	push   $0x0
  80074f:	e8 fc 01 00 00       	call   800950 <iscons>
  800754:	89 c7                	mov    %eax,%edi
  800756:	83 c4 10             	add    $0x10,%esp
  800759:	e9 77 ff ff ff       	jmp    8006d5 <umain+0x79>
	while (1) {
		char *buf;

		buf = readline(interactive ? "$ " : NULL);
		if (buf == NULL) {
			if (debug)
  80075e:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800765:	75 0a                	jne    800771 <umain+0x115>
				cprintf("EXITING\n");
			exit();	// end of file
  800767:	e8 f7 02 00 00       	call   800a63 <exit>
  80076c:	e9 94 00 00 00       	jmp    800805 <umain+0x1a9>
				cprintf("EXITING\n");
  800771:	83 ec 0c             	sub    $0xc,%esp
  800774:	68 50 37 80 00       	push   $0x803750
  800779:	e8 ed 03 00 00       	call   800b6b <cprintf>
  80077e:	83 c4 10             	add    $0x10,%esp
  800781:	eb e4                	jmp    800767 <umain+0x10b>
		}
		if (debug)
			cprintf("LINE: %s\n", buf);
  800783:	83 ec 08             	sub    $0x8,%esp
  800786:	53                   	push   %ebx
  800787:	68 59 37 80 00       	push   $0x803759
  80078c:	e8 da 03 00 00       	call   800b6b <cprintf>
  800791:	83 c4 10             	add    $0x10,%esp
  800794:	eb 7c                	jmp    800812 <umain+0x1b6>
		if (buf[0] == '#')
			continue;
		if (echocmds)
			printf("# %s\n", buf);
  800796:	83 ec 08             	sub    $0x8,%esp
  800799:	53                   	push   %ebx
  80079a:	68 63 37 80 00       	push   $0x803763
  80079f:	e8 fd 20 00 00       	call   8028a1 <printf>
  8007a4:	83 c4 10             	add    $0x10,%esp
  8007a7:	eb 78                	jmp    800821 <umain+0x1c5>
		if (debug)
			cprintf("BEFORE FORK\n");
  8007a9:	83 ec 0c             	sub    $0xc,%esp
  8007ac:	68 69 37 80 00       	push   $0x803769
  8007b1:	e8 b5 03 00 00       	call   800b6b <cprintf>
  8007b6:	83 c4 10             	add    $0x10,%esp
  8007b9:	eb 73                	jmp    80082e <umain+0x1d2>
		if ((r = fork()) < 0)
			panic("fork: %e", r);
  8007bb:	50                   	push   %eax
  8007bc:	68 8d 36 80 00       	push   $0x80368d
  8007c1:	68 38 01 00 00       	push   $0x138
  8007c6:	68 57 36 80 00       	push   $0x803657
  8007cb:	e8 a5 02 00 00       	call   800a75 <_panic>
		if (debug)
			cprintf("FORK: %d\n", r);
  8007d0:	83 ec 08             	sub    $0x8,%esp
  8007d3:	50                   	push   %eax
  8007d4:	68 76 37 80 00       	push   $0x803776
  8007d9:	e8 8d 03 00 00       	call   800b6b <cprintf>
  8007de:	83 c4 10             	add    $0x10,%esp
  8007e1:	eb 5f                	jmp    800842 <umain+0x1e6>
		if (r == 0) {
			runcmd(buf);
			exit();
		} else
			wait(r);
  8007e3:	83 ec 0c             	sub    $0xc,%esp
  8007e6:	56                   	push   %esi
  8007e7:	e8 78 29 00 00       	call   803164 <wait>
  8007ec:	83 c4 10             	add    $0x10,%esp
		buf = readline(interactive ? "$ " : NULL);
  8007ef:	83 ec 0c             	sub    $0xc,%esp
  8007f2:	57                   	push   %edi
  8007f3:	e8 99 0a 00 00       	call   801291 <readline>
  8007f8:	89 c3                	mov    %eax,%ebx
		if (buf == NULL) {
  8007fa:	83 c4 10             	add    $0x10,%esp
  8007fd:	85 c0                	test   %eax,%eax
  8007ff:	0f 84 59 ff ff ff    	je     80075e <umain+0x102>
		if (debug)
  800805:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80080c:	0f 85 71 ff ff ff    	jne    800783 <umain+0x127>
		if (buf[0] == '#')
  800812:	80 3b 23             	cmpb   $0x23,(%ebx)
  800815:	74 d8                	je     8007ef <umain+0x193>
		if (echocmds)
  800817:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80081b:	0f 85 75 ff ff ff    	jne    800796 <umain+0x13a>
		if (debug)
  800821:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800828:	0f 85 7b ff ff ff    	jne    8007a9 <umain+0x14d>
		if ((r = fork()) < 0)
  80082e:	e8 b7 13 00 00       	call   801bea <fork>
  800833:	89 c6                	mov    %eax,%esi
  800835:	85 c0                	test   %eax,%eax
  800837:	78 82                	js     8007bb <umain+0x15f>
		if (debug)
  800839:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800840:	75 8e                	jne    8007d0 <umain+0x174>
		if (r == 0) {
  800842:	85 f6                	test   %esi,%esi
  800844:	75 9d                	jne    8007e3 <umain+0x187>
			runcmd(buf);
  800846:	83 ec 0c             	sub    $0xc,%esp
  800849:	53                   	push   %ebx
  80084a:	e8 ab f9 ff ff       	call   8001fa <runcmd>
			exit();
  80084f:	e8 0f 02 00 00       	call   800a63 <exit>
  800854:	83 c4 10             	add    $0x10,%esp
  800857:	eb 96                	jmp    8007ef <umain+0x193>

00800859 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  800859:	b8 00 00 00 00       	mov    $0x0,%eax
  80085e:	c3                   	ret    

0080085f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80085f:	55                   	push   %ebp
  800860:	89 e5                	mov    %esp,%ebp
  800862:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800865:	68 f1 37 80 00       	push   $0x8037f1
  80086a:	ff 75 0c             	pushl  0xc(%ebp)
  80086d:	e8 48 0b 00 00       	call   8013ba <strcpy>
	return 0;
}
  800872:	b8 00 00 00 00       	mov    $0x0,%eax
  800877:	c9                   	leave  
  800878:	c3                   	ret    

00800879 <devcons_write>:
{
  800879:	55                   	push   %ebp
  80087a:	89 e5                	mov    %esp,%ebp
  80087c:	57                   	push   %edi
  80087d:	56                   	push   %esi
  80087e:	53                   	push   %ebx
  80087f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800885:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80088a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800890:	3b 75 10             	cmp    0x10(%ebp),%esi
  800893:	73 31                	jae    8008c6 <devcons_write+0x4d>
		m = n - tot;
  800895:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800898:	29 f3                	sub    %esi,%ebx
  80089a:	83 fb 7f             	cmp    $0x7f,%ebx
  80089d:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8008a2:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8008a5:	83 ec 04             	sub    $0x4,%esp
  8008a8:	53                   	push   %ebx
  8008a9:	89 f0                	mov    %esi,%eax
  8008ab:	03 45 0c             	add    0xc(%ebp),%eax
  8008ae:	50                   	push   %eax
  8008af:	57                   	push   %edi
  8008b0:	e8 93 0c 00 00       	call   801548 <memmove>
		sys_cputs(buf, m);
  8008b5:	83 c4 08             	add    $0x8,%esp
  8008b8:	53                   	push   %ebx
  8008b9:	57                   	push   %edi
  8008ba:	e8 31 0e 00 00       	call   8016f0 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8008bf:	01 de                	add    %ebx,%esi
  8008c1:	83 c4 10             	add    $0x10,%esp
  8008c4:	eb ca                	jmp    800890 <devcons_write+0x17>
}
  8008c6:	89 f0                	mov    %esi,%eax
  8008c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008cb:	5b                   	pop    %ebx
  8008cc:	5e                   	pop    %esi
  8008cd:	5f                   	pop    %edi
  8008ce:	5d                   	pop    %ebp
  8008cf:	c3                   	ret    

008008d0 <devcons_read>:
{
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
  8008d3:	83 ec 08             	sub    $0x8,%esp
  8008d6:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8008db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8008df:	74 21                	je     800902 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8008e1:	e8 28 0e 00 00       	call   80170e <sys_cgetc>
  8008e6:	85 c0                	test   %eax,%eax
  8008e8:	75 07                	jne    8008f1 <devcons_read+0x21>
		sys_yield();
  8008ea:	e8 9e 0e 00 00       	call   80178d <sys_yield>
  8008ef:	eb f0                	jmp    8008e1 <devcons_read+0x11>
	if (c < 0)
  8008f1:	78 0f                	js     800902 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8008f3:	83 f8 04             	cmp    $0x4,%eax
  8008f6:	74 0c                	je     800904 <devcons_read+0x34>
	*(char*)vbuf = c;
  8008f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fb:	88 02                	mov    %al,(%edx)
	return 1;
  8008fd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800902:	c9                   	leave  
  800903:	c3                   	ret    
		return 0;
  800904:	b8 00 00 00 00       	mov    $0x0,%eax
  800909:	eb f7                	jmp    800902 <devcons_read+0x32>

0080090b <cputchar>:
{
  80090b:	55                   	push   %ebp
  80090c:	89 e5                	mov    %esp,%ebp
  80090e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  800911:	8b 45 08             	mov    0x8(%ebp),%eax
  800914:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  800917:	6a 01                	push   $0x1
  800919:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80091c:	50                   	push   %eax
  80091d:	e8 ce 0d 00 00       	call   8016f0 <sys_cputs>
}
  800922:	83 c4 10             	add    $0x10,%esp
  800925:	c9                   	leave  
  800926:	c3                   	ret    

00800927 <getchar>:
{
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80092d:	6a 01                	push   $0x1
  80092f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800932:	50                   	push   %eax
  800933:	6a 00                	push   $0x0
  800935:	e8 8d 19 00 00       	call   8022c7 <read>
	if (r < 0)
  80093a:	83 c4 10             	add    $0x10,%esp
  80093d:	85 c0                	test   %eax,%eax
  80093f:	78 06                	js     800947 <getchar+0x20>
	if (r < 1)
  800941:	74 06                	je     800949 <getchar+0x22>
	return c;
  800943:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800947:	c9                   	leave  
  800948:	c3                   	ret    
		return -E_EOF;
  800949:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80094e:	eb f7                	jmp    800947 <getchar+0x20>

00800950 <iscons>:
{
  800950:	55                   	push   %ebp
  800951:	89 e5                	mov    %esp,%ebp
  800953:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800956:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800959:	50                   	push   %eax
  80095a:	ff 75 08             	pushl  0x8(%ebp)
  80095d:	e8 fa 16 00 00       	call   80205c <fd_lookup>
  800962:	83 c4 10             	add    $0x10,%esp
  800965:	85 c0                	test   %eax,%eax
  800967:	78 11                	js     80097a <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  800969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80096c:	8b 15 00 40 80 00    	mov    0x804000,%edx
  800972:	39 10                	cmp    %edx,(%eax)
  800974:	0f 94 c0             	sete   %al
  800977:	0f b6 c0             	movzbl %al,%eax
}
  80097a:	c9                   	leave  
  80097b:	c3                   	ret    

0080097c <opencons>:
{
  80097c:	55                   	push   %ebp
  80097d:	89 e5                	mov    %esp,%ebp
  80097f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  800982:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800985:	50                   	push   %eax
  800986:	e8 7f 16 00 00       	call   80200a <fd_alloc>
  80098b:	83 c4 10             	add    $0x10,%esp
  80098e:	85 c0                	test   %eax,%eax
  800990:	78 3a                	js     8009cc <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800992:	83 ec 04             	sub    $0x4,%esp
  800995:	68 07 04 00 00       	push   $0x407
  80099a:	ff 75 f4             	pushl  -0xc(%ebp)
  80099d:	6a 00                	push   $0x0
  80099f:	e8 08 0e 00 00       	call   8017ac <sys_page_alloc>
  8009a4:	83 c4 10             	add    $0x10,%esp
  8009a7:	85 c0                	test   %eax,%eax
  8009a9:	78 21                	js     8009cc <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8009ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009ae:	8b 15 00 40 80 00    	mov    0x804000,%edx
  8009b4:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8009b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009b9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8009c0:	83 ec 0c             	sub    $0xc,%esp
  8009c3:	50                   	push   %eax
  8009c4:	e8 1a 16 00 00       	call   801fe3 <fd2num>
  8009c9:	83 c4 10             	add    $0x10,%esp
}
  8009cc:	c9                   	leave  
  8009cd:	c3                   	ret    

008009ce <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8009ce:	55                   	push   %ebp
  8009cf:	89 e5                	mov    %esp,%ebp
  8009d1:	57                   	push   %edi
  8009d2:	56                   	push   %esi
  8009d3:	53                   	push   %ebx
  8009d4:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8009d7:	c7 05 24 54 80 00 00 	movl   $0x0,0x805424
  8009de:	00 00 00 
	envid_t find = sys_getenvid();
  8009e1:	e8 88 0d 00 00       	call   80176e <sys_getenvid>
  8009e6:	8b 1d 24 54 80 00    	mov    0x805424,%ebx
  8009ec:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8009f1:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8009f6:	bf 01 00 00 00       	mov    $0x1,%edi
  8009fb:	eb 0b                	jmp    800a08 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8009fd:	83 c2 01             	add    $0x1,%edx
  800a00:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800a06:	74 21                	je     800a29 <libmain+0x5b>
		if(envs[i].env_id == find)
  800a08:	89 d1                	mov    %edx,%ecx
  800a0a:	c1 e1 07             	shl    $0x7,%ecx
  800a0d:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800a13:	8b 49 48             	mov    0x48(%ecx),%ecx
  800a16:	39 c1                	cmp    %eax,%ecx
  800a18:	75 e3                	jne    8009fd <libmain+0x2f>
  800a1a:	89 d3                	mov    %edx,%ebx
  800a1c:	c1 e3 07             	shl    $0x7,%ebx
  800a1f:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800a25:	89 fe                	mov    %edi,%esi
  800a27:	eb d4                	jmp    8009fd <libmain+0x2f>
  800a29:	89 f0                	mov    %esi,%eax
  800a2b:	84 c0                	test   %al,%al
  800a2d:	74 06                	je     800a35 <libmain+0x67>
  800a2f:	89 1d 24 54 80 00    	mov    %ebx,0x805424
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a35:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a39:	7e 0a                	jle    800a45 <libmain+0x77>
		binaryname = argv[0];
  800a3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3e:	8b 00                	mov    (%eax),%eax
  800a40:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	umain(argc, argv);
  800a45:	83 ec 08             	sub    $0x8,%esp
  800a48:	ff 75 0c             	pushl  0xc(%ebp)
  800a4b:	ff 75 08             	pushl  0x8(%ebp)
  800a4e:	e8 09 fc ff ff       	call   80065c <umain>

	// exit gracefully
	exit();
  800a53:	e8 0b 00 00 00       	call   800a63 <exit>
}
  800a58:	83 c4 10             	add    $0x10,%esp
  800a5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a5e:	5b                   	pop    %ebx
  800a5f:	5e                   	pop    %esi
  800a60:	5f                   	pop    %edi
  800a61:	5d                   	pop    %ebp
  800a62:	c3                   	ret    

00800a63 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800a63:	55                   	push   %ebp
  800a64:	89 e5                	mov    %esp,%ebp
  800a66:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800a69:	6a 00                	push   $0x0
  800a6b:	e8 bd 0c 00 00       	call   80172d <sys_env_destroy>
}
  800a70:	83 c4 10             	add    $0x10,%esp
  800a73:	c9                   	leave  
  800a74:	c3                   	ret    

00800a75 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
  800a78:	56                   	push   %esi
  800a79:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800a7a:	a1 24 54 80 00       	mov    0x805424,%eax
  800a7f:	8b 40 48             	mov    0x48(%eax),%eax
  800a82:	83 ec 04             	sub    $0x4,%esp
  800a85:	68 38 38 80 00       	push   $0x803838
  800a8a:	50                   	push   %eax
  800a8b:	68 07 38 80 00       	push   $0x803807
  800a90:	e8 d6 00 00 00       	call   800b6b <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800a95:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800a98:	8b 35 1c 40 80 00    	mov    0x80401c,%esi
  800a9e:	e8 cb 0c 00 00       	call   80176e <sys_getenvid>
  800aa3:	83 c4 04             	add    $0x4,%esp
  800aa6:	ff 75 0c             	pushl  0xc(%ebp)
  800aa9:	ff 75 08             	pushl  0x8(%ebp)
  800aac:	56                   	push   %esi
  800aad:	50                   	push   %eax
  800aae:	68 14 38 80 00       	push   $0x803814
  800ab3:	e8 b3 00 00 00       	call   800b6b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800ab8:	83 c4 18             	add    $0x18,%esp
  800abb:	53                   	push   %ebx
  800abc:	ff 75 10             	pushl  0x10(%ebp)
  800abf:	e8 56 00 00 00       	call   800b1a <vcprintf>
	cprintf("\n");
  800ac4:	c7 04 24 00 36 80 00 	movl   $0x803600,(%esp)
  800acb:	e8 9b 00 00 00       	call   800b6b <cprintf>
  800ad0:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800ad3:	cc                   	int3   
  800ad4:	eb fd                	jmp    800ad3 <_panic+0x5e>

00800ad6 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	53                   	push   %ebx
  800ada:	83 ec 04             	sub    $0x4,%esp
  800add:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800ae0:	8b 13                	mov    (%ebx),%edx
  800ae2:	8d 42 01             	lea    0x1(%edx),%eax
  800ae5:	89 03                	mov    %eax,(%ebx)
  800ae7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aea:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800aee:	3d ff 00 00 00       	cmp    $0xff,%eax
  800af3:	74 09                	je     800afe <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800af5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800af9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800afc:	c9                   	leave  
  800afd:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800afe:	83 ec 08             	sub    $0x8,%esp
  800b01:	68 ff 00 00 00       	push   $0xff
  800b06:	8d 43 08             	lea    0x8(%ebx),%eax
  800b09:	50                   	push   %eax
  800b0a:	e8 e1 0b 00 00       	call   8016f0 <sys_cputs>
		b->idx = 0;
  800b0f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800b15:	83 c4 10             	add    $0x10,%esp
  800b18:	eb db                	jmp    800af5 <putch+0x1f>

00800b1a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800b1a:	55                   	push   %ebp
  800b1b:	89 e5                	mov    %esp,%ebp
  800b1d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b23:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b2a:	00 00 00 
	b.cnt = 0;
  800b2d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b34:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800b37:	ff 75 0c             	pushl  0xc(%ebp)
  800b3a:	ff 75 08             	pushl  0x8(%ebp)
  800b3d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b43:	50                   	push   %eax
  800b44:	68 d6 0a 80 00       	push   $0x800ad6
  800b49:	e8 4a 01 00 00       	call   800c98 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800b4e:	83 c4 08             	add    $0x8,%esp
  800b51:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800b57:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800b5d:	50                   	push   %eax
  800b5e:	e8 8d 0b 00 00       	call   8016f0 <sys_cputs>

	return b.cnt;
}
  800b63:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800b69:	c9                   	leave  
  800b6a:	c3                   	ret    

00800b6b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800b6b:	55                   	push   %ebp
  800b6c:	89 e5                	mov    %esp,%ebp
  800b6e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b71:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800b74:	50                   	push   %eax
  800b75:	ff 75 08             	pushl  0x8(%ebp)
  800b78:	e8 9d ff ff ff       	call   800b1a <vcprintf>
	va_end(ap);

	return cnt;
}
  800b7d:	c9                   	leave  
  800b7e:	c3                   	ret    

00800b7f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b7f:	55                   	push   %ebp
  800b80:	89 e5                	mov    %esp,%ebp
  800b82:	57                   	push   %edi
  800b83:	56                   	push   %esi
  800b84:	53                   	push   %ebx
  800b85:	83 ec 1c             	sub    $0x1c,%esp
  800b88:	89 c6                	mov    %eax,%esi
  800b8a:	89 d7                	mov    %edx,%edi
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b92:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b95:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800b98:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9b:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800b9e:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800ba2:	74 2c                	je     800bd0 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800ba4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ba7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800bae:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bb1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800bb4:	39 c2                	cmp    %eax,%edx
  800bb6:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800bb9:	73 43                	jae    800bfe <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800bbb:	83 eb 01             	sub    $0x1,%ebx
  800bbe:	85 db                	test   %ebx,%ebx
  800bc0:	7e 6c                	jle    800c2e <printnum+0xaf>
				putch(padc, putdat);
  800bc2:	83 ec 08             	sub    $0x8,%esp
  800bc5:	57                   	push   %edi
  800bc6:	ff 75 18             	pushl  0x18(%ebp)
  800bc9:	ff d6                	call   *%esi
  800bcb:	83 c4 10             	add    $0x10,%esp
  800bce:	eb eb                	jmp    800bbb <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800bd0:	83 ec 0c             	sub    $0xc,%esp
  800bd3:	6a 20                	push   $0x20
  800bd5:	6a 00                	push   $0x0
  800bd7:	50                   	push   %eax
  800bd8:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bdb:	ff 75 e0             	pushl  -0x20(%ebp)
  800bde:	89 fa                	mov    %edi,%edx
  800be0:	89 f0                	mov    %esi,%eax
  800be2:	e8 98 ff ff ff       	call   800b7f <printnum>
		while (--width > 0)
  800be7:	83 c4 20             	add    $0x20,%esp
  800bea:	83 eb 01             	sub    $0x1,%ebx
  800bed:	85 db                	test   %ebx,%ebx
  800bef:	7e 65                	jle    800c56 <printnum+0xd7>
			putch(padc, putdat);
  800bf1:	83 ec 08             	sub    $0x8,%esp
  800bf4:	57                   	push   %edi
  800bf5:	6a 20                	push   $0x20
  800bf7:	ff d6                	call   *%esi
  800bf9:	83 c4 10             	add    $0x10,%esp
  800bfc:	eb ec                	jmp    800bea <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800bfe:	83 ec 0c             	sub    $0xc,%esp
  800c01:	ff 75 18             	pushl  0x18(%ebp)
  800c04:	83 eb 01             	sub    $0x1,%ebx
  800c07:	53                   	push   %ebx
  800c08:	50                   	push   %eax
  800c09:	83 ec 08             	sub    $0x8,%esp
  800c0c:	ff 75 dc             	pushl  -0x24(%ebp)
  800c0f:	ff 75 d8             	pushl  -0x28(%ebp)
  800c12:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c15:	ff 75 e0             	pushl  -0x20(%ebp)
  800c18:	e8 63 27 00 00       	call   803380 <__udivdi3>
  800c1d:	83 c4 18             	add    $0x18,%esp
  800c20:	52                   	push   %edx
  800c21:	50                   	push   %eax
  800c22:	89 fa                	mov    %edi,%edx
  800c24:	89 f0                	mov    %esi,%eax
  800c26:	e8 54 ff ff ff       	call   800b7f <printnum>
  800c2b:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800c2e:	83 ec 08             	sub    $0x8,%esp
  800c31:	57                   	push   %edi
  800c32:	83 ec 04             	sub    $0x4,%esp
  800c35:	ff 75 dc             	pushl  -0x24(%ebp)
  800c38:	ff 75 d8             	pushl  -0x28(%ebp)
  800c3b:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c3e:	ff 75 e0             	pushl  -0x20(%ebp)
  800c41:	e8 4a 28 00 00       	call   803490 <__umoddi3>
  800c46:	83 c4 14             	add    $0x14,%esp
  800c49:	0f be 80 3f 38 80 00 	movsbl 0x80383f(%eax),%eax
  800c50:	50                   	push   %eax
  800c51:	ff d6                	call   *%esi
  800c53:	83 c4 10             	add    $0x10,%esp
	}
}
  800c56:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c59:	5b                   	pop    %ebx
  800c5a:	5e                   	pop    %esi
  800c5b:	5f                   	pop    %edi
  800c5c:	5d                   	pop    %ebp
  800c5d:	c3                   	ret    

00800c5e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c5e:	55                   	push   %ebp
  800c5f:	89 e5                	mov    %esp,%ebp
  800c61:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800c64:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800c68:	8b 10                	mov    (%eax),%edx
  800c6a:	3b 50 04             	cmp    0x4(%eax),%edx
  800c6d:	73 0a                	jae    800c79 <sprintputch+0x1b>
		*b->buf++ = ch;
  800c6f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c72:	89 08                	mov    %ecx,(%eax)
  800c74:	8b 45 08             	mov    0x8(%ebp),%eax
  800c77:	88 02                	mov    %al,(%edx)
}
  800c79:	5d                   	pop    %ebp
  800c7a:	c3                   	ret    

00800c7b <printfmt>:
{
  800c7b:	55                   	push   %ebp
  800c7c:	89 e5                	mov    %esp,%ebp
  800c7e:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800c81:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800c84:	50                   	push   %eax
  800c85:	ff 75 10             	pushl  0x10(%ebp)
  800c88:	ff 75 0c             	pushl  0xc(%ebp)
  800c8b:	ff 75 08             	pushl  0x8(%ebp)
  800c8e:	e8 05 00 00 00       	call   800c98 <vprintfmt>
}
  800c93:	83 c4 10             	add    $0x10,%esp
  800c96:	c9                   	leave  
  800c97:	c3                   	ret    

00800c98 <vprintfmt>:
{
  800c98:	55                   	push   %ebp
  800c99:	89 e5                	mov    %esp,%ebp
  800c9b:	57                   	push   %edi
  800c9c:	56                   	push   %esi
  800c9d:	53                   	push   %ebx
  800c9e:	83 ec 3c             	sub    $0x3c,%esp
  800ca1:	8b 75 08             	mov    0x8(%ebp),%esi
  800ca4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ca7:	8b 7d 10             	mov    0x10(%ebp),%edi
  800caa:	e9 32 04 00 00       	jmp    8010e1 <vprintfmt+0x449>
		padc = ' ';
  800caf:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800cb3:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800cba:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800cc1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800cc8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800ccf:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800cd6:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800cdb:	8d 47 01             	lea    0x1(%edi),%eax
  800cde:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ce1:	0f b6 17             	movzbl (%edi),%edx
  800ce4:	8d 42 dd             	lea    -0x23(%edx),%eax
  800ce7:	3c 55                	cmp    $0x55,%al
  800ce9:	0f 87 12 05 00 00    	ja     801201 <vprintfmt+0x569>
  800cef:	0f b6 c0             	movzbl %al,%eax
  800cf2:	ff 24 85 20 3a 80 00 	jmp    *0x803a20(,%eax,4)
  800cf9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800cfc:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800d00:	eb d9                	jmp    800cdb <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800d02:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800d05:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800d09:	eb d0                	jmp    800cdb <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800d0b:	0f b6 d2             	movzbl %dl,%edx
  800d0e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800d11:	b8 00 00 00 00       	mov    $0x0,%eax
  800d16:	89 75 08             	mov    %esi,0x8(%ebp)
  800d19:	eb 03                	jmp    800d1e <vprintfmt+0x86>
  800d1b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800d1e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800d21:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800d25:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800d28:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d2b:	83 fe 09             	cmp    $0x9,%esi
  800d2e:	76 eb                	jbe    800d1b <vprintfmt+0x83>
  800d30:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d33:	8b 75 08             	mov    0x8(%ebp),%esi
  800d36:	eb 14                	jmp    800d4c <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800d38:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3b:	8b 00                	mov    (%eax),%eax
  800d3d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d40:	8b 45 14             	mov    0x14(%ebp),%eax
  800d43:	8d 40 04             	lea    0x4(%eax),%eax
  800d46:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800d49:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800d4c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d50:	79 89                	jns    800cdb <vprintfmt+0x43>
				width = precision, precision = -1;
  800d52:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d55:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800d58:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800d5f:	e9 77 ff ff ff       	jmp    800cdb <vprintfmt+0x43>
  800d64:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d67:	85 c0                	test   %eax,%eax
  800d69:	0f 48 c1             	cmovs  %ecx,%eax
  800d6c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800d6f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800d72:	e9 64 ff ff ff       	jmp    800cdb <vprintfmt+0x43>
  800d77:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800d7a:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800d81:	e9 55 ff ff ff       	jmp    800cdb <vprintfmt+0x43>
			lflag++;
  800d86:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800d8a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800d8d:	e9 49 ff ff ff       	jmp    800cdb <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800d92:	8b 45 14             	mov    0x14(%ebp),%eax
  800d95:	8d 78 04             	lea    0x4(%eax),%edi
  800d98:	83 ec 08             	sub    $0x8,%esp
  800d9b:	53                   	push   %ebx
  800d9c:	ff 30                	pushl  (%eax)
  800d9e:	ff d6                	call   *%esi
			break;
  800da0:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800da3:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800da6:	e9 33 03 00 00       	jmp    8010de <vprintfmt+0x446>
			err = va_arg(ap, int);
  800dab:	8b 45 14             	mov    0x14(%ebp),%eax
  800dae:	8d 78 04             	lea    0x4(%eax),%edi
  800db1:	8b 00                	mov    (%eax),%eax
  800db3:	99                   	cltd   
  800db4:	31 d0                	xor    %edx,%eax
  800db6:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800db8:	83 f8 0f             	cmp    $0xf,%eax
  800dbb:	7f 23                	jg     800de0 <vprintfmt+0x148>
  800dbd:	8b 14 85 80 3b 80 00 	mov    0x803b80(,%eax,4),%edx
  800dc4:	85 d2                	test   %edx,%edx
  800dc6:	74 18                	je     800de0 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800dc8:	52                   	push   %edx
  800dc9:	68 4a 37 80 00       	push   $0x80374a
  800dce:	53                   	push   %ebx
  800dcf:	56                   	push   %esi
  800dd0:	e8 a6 fe ff ff       	call   800c7b <printfmt>
  800dd5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800dd8:	89 7d 14             	mov    %edi,0x14(%ebp)
  800ddb:	e9 fe 02 00 00       	jmp    8010de <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800de0:	50                   	push   %eax
  800de1:	68 57 38 80 00       	push   $0x803857
  800de6:	53                   	push   %ebx
  800de7:	56                   	push   %esi
  800de8:	e8 8e fe ff ff       	call   800c7b <printfmt>
  800ded:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800df0:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800df3:	e9 e6 02 00 00       	jmp    8010de <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800df8:	8b 45 14             	mov    0x14(%ebp),%eax
  800dfb:	83 c0 04             	add    $0x4,%eax
  800dfe:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800e01:	8b 45 14             	mov    0x14(%ebp),%eax
  800e04:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800e06:	85 c9                	test   %ecx,%ecx
  800e08:	b8 50 38 80 00       	mov    $0x803850,%eax
  800e0d:	0f 45 c1             	cmovne %ecx,%eax
  800e10:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800e13:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e17:	7e 06                	jle    800e1f <vprintfmt+0x187>
  800e19:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800e1d:	75 0d                	jne    800e2c <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e1f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800e22:	89 c7                	mov    %eax,%edi
  800e24:	03 45 e0             	add    -0x20(%ebp),%eax
  800e27:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800e2a:	eb 53                	jmp    800e7f <vprintfmt+0x1e7>
  800e2c:	83 ec 08             	sub    $0x8,%esp
  800e2f:	ff 75 d8             	pushl  -0x28(%ebp)
  800e32:	50                   	push   %eax
  800e33:	e8 61 05 00 00       	call   801399 <strnlen>
  800e38:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800e3b:	29 c1                	sub    %eax,%ecx
  800e3d:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800e40:	83 c4 10             	add    $0x10,%esp
  800e43:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800e45:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800e49:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800e4c:	eb 0f                	jmp    800e5d <vprintfmt+0x1c5>
					putch(padc, putdat);
  800e4e:	83 ec 08             	sub    $0x8,%esp
  800e51:	53                   	push   %ebx
  800e52:	ff 75 e0             	pushl  -0x20(%ebp)
  800e55:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800e57:	83 ef 01             	sub    $0x1,%edi
  800e5a:	83 c4 10             	add    $0x10,%esp
  800e5d:	85 ff                	test   %edi,%edi
  800e5f:	7f ed                	jg     800e4e <vprintfmt+0x1b6>
  800e61:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800e64:	85 c9                	test   %ecx,%ecx
  800e66:	b8 00 00 00 00       	mov    $0x0,%eax
  800e6b:	0f 49 c1             	cmovns %ecx,%eax
  800e6e:	29 c1                	sub    %eax,%ecx
  800e70:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800e73:	eb aa                	jmp    800e1f <vprintfmt+0x187>
					putch(ch, putdat);
  800e75:	83 ec 08             	sub    $0x8,%esp
  800e78:	53                   	push   %ebx
  800e79:	52                   	push   %edx
  800e7a:	ff d6                	call   *%esi
  800e7c:	83 c4 10             	add    $0x10,%esp
  800e7f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800e82:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e84:	83 c7 01             	add    $0x1,%edi
  800e87:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800e8b:	0f be d0             	movsbl %al,%edx
  800e8e:	85 d2                	test   %edx,%edx
  800e90:	74 4b                	je     800edd <vprintfmt+0x245>
  800e92:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800e96:	78 06                	js     800e9e <vprintfmt+0x206>
  800e98:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800e9c:	78 1e                	js     800ebc <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800e9e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800ea2:	74 d1                	je     800e75 <vprintfmt+0x1dd>
  800ea4:	0f be c0             	movsbl %al,%eax
  800ea7:	83 e8 20             	sub    $0x20,%eax
  800eaa:	83 f8 5e             	cmp    $0x5e,%eax
  800ead:	76 c6                	jbe    800e75 <vprintfmt+0x1dd>
					putch('?', putdat);
  800eaf:	83 ec 08             	sub    $0x8,%esp
  800eb2:	53                   	push   %ebx
  800eb3:	6a 3f                	push   $0x3f
  800eb5:	ff d6                	call   *%esi
  800eb7:	83 c4 10             	add    $0x10,%esp
  800eba:	eb c3                	jmp    800e7f <vprintfmt+0x1e7>
  800ebc:	89 cf                	mov    %ecx,%edi
  800ebe:	eb 0e                	jmp    800ece <vprintfmt+0x236>
				putch(' ', putdat);
  800ec0:	83 ec 08             	sub    $0x8,%esp
  800ec3:	53                   	push   %ebx
  800ec4:	6a 20                	push   $0x20
  800ec6:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800ec8:	83 ef 01             	sub    $0x1,%edi
  800ecb:	83 c4 10             	add    $0x10,%esp
  800ece:	85 ff                	test   %edi,%edi
  800ed0:	7f ee                	jg     800ec0 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800ed2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800ed5:	89 45 14             	mov    %eax,0x14(%ebp)
  800ed8:	e9 01 02 00 00       	jmp    8010de <vprintfmt+0x446>
  800edd:	89 cf                	mov    %ecx,%edi
  800edf:	eb ed                	jmp    800ece <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800ee1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800ee4:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800eeb:	e9 eb fd ff ff       	jmp    800cdb <vprintfmt+0x43>
	if (lflag >= 2)
  800ef0:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800ef4:	7f 21                	jg     800f17 <vprintfmt+0x27f>
	else if (lflag)
  800ef6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800efa:	74 68                	je     800f64 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800efc:	8b 45 14             	mov    0x14(%ebp),%eax
  800eff:	8b 00                	mov    (%eax),%eax
  800f01:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800f04:	89 c1                	mov    %eax,%ecx
  800f06:	c1 f9 1f             	sar    $0x1f,%ecx
  800f09:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800f0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f0f:	8d 40 04             	lea    0x4(%eax),%eax
  800f12:	89 45 14             	mov    %eax,0x14(%ebp)
  800f15:	eb 17                	jmp    800f2e <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800f17:	8b 45 14             	mov    0x14(%ebp),%eax
  800f1a:	8b 50 04             	mov    0x4(%eax),%edx
  800f1d:	8b 00                	mov    (%eax),%eax
  800f1f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800f22:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800f25:	8b 45 14             	mov    0x14(%ebp),%eax
  800f28:	8d 40 08             	lea    0x8(%eax),%eax
  800f2b:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800f2e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800f31:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800f34:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f37:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800f3a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800f3e:	78 3f                	js     800f7f <vprintfmt+0x2e7>
			base = 10;
  800f40:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800f45:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800f49:	0f 84 71 01 00 00    	je     8010c0 <vprintfmt+0x428>
				putch('+', putdat);
  800f4f:	83 ec 08             	sub    $0x8,%esp
  800f52:	53                   	push   %ebx
  800f53:	6a 2b                	push   $0x2b
  800f55:	ff d6                	call   *%esi
  800f57:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800f5a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f5f:	e9 5c 01 00 00       	jmp    8010c0 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800f64:	8b 45 14             	mov    0x14(%ebp),%eax
  800f67:	8b 00                	mov    (%eax),%eax
  800f69:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800f6c:	89 c1                	mov    %eax,%ecx
  800f6e:	c1 f9 1f             	sar    $0x1f,%ecx
  800f71:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800f74:	8b 45 14             	mov    0x14(%ebp),%eax
  800f77:	8d 40 04             	lea    0x4(%eax),%eax
  800f7a:	89 45 14             	mov    %eax,0x14(%ebp)
  800f7d:	eb af                	jmp    800f2e <vprintfmt+0x296>
				putch('-', putdat);
  800f7f:	83 ec 08             	sub    $0x8,%esp
  800f82:	53                   	push   %ebx
  800f83:	6a 2d                	push   $0x2d
  800f85:	ff d6                	call   *%esi
				num = -(long long) num;
  800f87:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800f8a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800f8d:	f7 d8                	neg    %eax
  800f8f:	83 d2 00             	adc    $0x0,%edx
  800f92:	f7 da                	neg    %edx
  800f94:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f97:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f9a:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800f9d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fa2:	e9 19 01 00 00       	jmp    8010c0 <vprintfmt+0x428>
	if (lflag >= 2)
  800fa7:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800fab:	7f 29                	jg     800fd6 <vprintfmt+0x33e>
	else if (lflag)
  800fad:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800fb1:	74 44                	je     800ff7 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800fb3:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb6:	8b 00                	mov    (%eax),%eax
  800fb8:	ba 00 00 00 00       	mov    $0x0,%edx
  800fbd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800fc0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800fc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc6:	8d 40 04             	lea    0x4(%eax),%eax
  800fc9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800fcc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fd1:	e9 ea 00 00 00       	jmp    8010c0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800fd6:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd9:	8b 50 04             	mov    0x4(%eax),%edx
  800fdc:	8b 00                	mov    (%eax),%eax
  800fde:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800fe1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800fe4:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe7:	8d 40 08             	lea    0x8(%eax),%eax
  800fea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800fed:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ff2:	e9 c9 00 00 00       	jmp    8010c0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800ff7:	8b 45 14             	mov    0x14(%ebp),%eax
  800ffa:	8b 00                	mov    (%eax),%eax
  800ffc:	ba 00 00 00 00       	mov    $0x0,%edx
  801001:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801004:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801007:	8b 45 14             	mov    0x14(%ebp),%eax
  80100a:	8d 40 04             	lea    0x4(%eax),%eax
  80100d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801010:	b8 0a 00 00 00       	mov    $0xa,%eax
  801015:	e9 a6 00 00 00       	jmp    8010c0 <vprintfmt+0x428>
			putch('0', putdat);
  80101a:	83 ec 08             	sub    $0x8,%esp
  80101d:	53                   	push   %ebx
  80101e:	6a 30                	push   $0x30
  801020:	ff d6                	call   *%esi
	if (lflag >= 2)
  801022:	83 c4 10             	add    $0x10,%esp
  801025:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  801029:	7f 26                	jg     801051 <vprintfmt+0x3b9>
	else if (lflag)
  80102b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80102f:	74 3e                	je     80106f <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  801031:	8b 45 14             	mov    0x14(%ebp),%eax
  801034:	8b 00                	mov    (%eax),%eax
  801036:	ba 00 00 00 00       	mov    $0x0,%edx
  80103b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80103e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801041:	8b 45 14             	mov    0x14(%ebp),%eax
  801044:	8d 40 04             	lea    0x4(%eax),%eax
  801047:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80104a:	b8 08 00 00 00       	mov    $0x8,%eax
  80104f:	eb 6f                	jmp    8010c0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  801051:	8b 45 14             	mov    0x14(%ebp),%eax
  801054:	8b 50 04             	mov    0x4(%eax),%edx
  801057:	8b 00                	mov    (%eax),%eax
  801059:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80105c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80105f:	8b 45 14             	mov    0x14(%ebp),%eax
  801062:	8d 40 08             	lea    0x8(%eax),%eax
  801065:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801068:	b8 08 00 00 00       	mov    $0x8,%eax
  80106d:	eb 51                	jmp    8010c0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80106f:	8b 45 14             	mov    0x14(%ebp),%eax
  801072:	8b 00                	mov    (%eax),%eax
  801074:	ba 00 00 00 00       	mov    $0x0,%edx
  801079:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80107c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80107f:	8b 45 14             	mov    0x14(%ebp),%eax
  801082:	8d 40 04             	lea    0x4(%eax),%eax
  801085:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801088:	b8 08 00 00 00       	mov    $0x8,%eax
  80108d:	eb 31                	jmp    8010c0 <vprintfmt+0x428>
			putch('0', putdat);
  80108f:	83 ec 08             	sub    $0x8,%esp
  801092:	53                   	push   %ebx
  801093:	6a 30                	push   $0x30
  801095:	ff d6                	call   *%esi
			putch('x', putdat);
  801097:	83 c4 08             	add    $0x8,%esp
  80109a:	53                   	push   %ebx
  80109b:	6a 78                	push   $0x78
  80109d:	ff d6                	call   *%esi
			num = (unsigned long long)
  80109f:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a2:	8b 00                	mov    (%eax),%eax
  8010a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8010a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8010ac:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8010af:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8010b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b5:	8d 40 04             	lea    0x4(%eax),%eax
  8010b8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8010bb:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8010c0:	83 ec 0c             	sub    $0xc,%esp
  8010c3:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8010c7:	52                   	push   %edx
  8010c8:	ff 75 e0             	pushl  -0x20(%ebp)
  8010cb:	50                   	push   %eax
  8010cc:	ff 75 dc             	pushl  -0x24(%ebp)
  8010cf:	ff 75 d8             	pushl  -0x28(%ebp)
  8010d2:	89 da                	mov    %ebx,%edx
  8010d4:	89 f0                	mov    %esi,%eax
  8010d6:	e8 a4 fa ff ff       	call   800b7f <printnum>
			break;
  8010db:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8010de:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010e1:	83 c7 01             	add    $0x1,%edi
  8010e4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8010e8:	83 f8 25             	cmp    $0x25,%eax
  8010eb:	0f 84 be fb ff ff    	je     800caf <vprintfmt+0x17>
			if (ch == '\0')
  8010f1:	85 c0                	test   %eax,%eax
  8010f3:	0f 84 28 01 00 00    	je     801221 <vprintfmt+0x589>
			putch(ch, putdat);
  8010f9:	83 ec 08             	sub    $0x8,%esp
  8010fc:	53                   	push   %ebx
  8010fd:	50                   	push   %eax
  8010fe:	ff d6                	call   *%esi
  801100:	83 c4 10             	add    $0x10,%esp
  801103:	eb dc                	jmp    8010e1 <vprintfmt+0x449>
	if (lflag >= 2)
  801105:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  801109:	7f 26                	jg     801131 <vprintfmt+0x499>
	else if (lflag)
  80110b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80110f:	74 41                	je     801152 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  801111:	8b 45 14             	mov    0x14(%ebp),%eax
  801114:	8b 00                	mov    (%eax),%eax
  801116:	ba 00 00 00 00       	mov    $0x0,%edx
  80111b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80111e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801121:	8b 45 14             	mov    0x14(%ebp),%eax
  801124:	8d 40 04             	lea    0x4(%eax),%eax
  801127:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80112a:	b8 10 00 00 00       	mov    $0x10,%eax
  80112f:	eb 8f                	jmp    8010c0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  801131:	8b 45 14             	mov    0x14(%ebp),%eax
  801134:	8b 50 04             	mov    0x4(%eax),%edx
  801137:	8b 00                	mov    (%eax),%eax
  801139:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80113c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80113f:	8b 45 14             	mov    0x14(%ebp),%eax
  801142:	8d 40 08             	lea    0x8(%eax),%eax
  801145:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801148:	b8 10 00 00 00       	mov    $0x10,%eax
  80114d:	e9 6e ff ff ff       	jmp    8010c0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  801152:	8b 45 14             	mov    0x14(%ebp),%eax
  801155:	8b 00                	mov    (%eax),%eax
  801157:	ba 00 00 00 00       	mov    $0x0,%edx
  80115c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80115f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801162:	8b 45 14             	mov    0x14(%ebp),%eax
  801165:	8d 40 04             	lea    0x4(%eax),%eax
  801168:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80116b:	b8 10 00 00 00       	mov    $0x10,%eax
  801170:	e9 4b ff ff ff       	jmp    8010c0 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  801175:	8b 45 14             	mov    0x14(%ebp),%eax
  801178:	83 c0 04             	add    $0x4,%eax
  80117b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80117e:	8b 45 14             	mov    0x14(%ebp),%eax
  801181:	8b 00                	mov    (%eax),%eax
  801183:	85 c0                	test   %eax,%eax
  801185:	74 14                	je     80119b <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  801187:	8b 13                	mov    (%ebx),%edx
  801189:	83 fa 7f             	cmp    $0x7f,%edx
  80118c:	7f 37                	jg     8011c5 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80118e:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  801190:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801193:	89 45 14             	mov    %eax,0x14(%ebp)
  801196:	e9 43 ff ff ff       	jmp    8010de <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80119b:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011a0:	bf 75 39 80 00       	mov    $0x803975,%edi
							putch(ch, putdat);
  8011a5:	83 ec 08             	sub    $0x8,%esp
  8011a8:	53                   	push   %ebx
  8011a9:	50                   	push   %eax
  8011aa:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8011ac:	83 c7 01             	add    $0x1,%edi
  8011af:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8011b3:	83 c4 10             	add    $0x10,%esp
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	75 eb                	jne    8011a5 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8011ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8011bd:	89 45 14             	mov    %eax,0x14(%ebp)
  8011c0:	e9 19 ff ff ff       	jmp    8010de <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8011c5:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8011c7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011cc:	bf ad 39 80 00       	mov    $0x8039ad,%edi
							putch(ch, putdat);
  8011d1:	83 ec 08             	sub    $0x8,%esp
  8011d4:	53                   	push   %ebx
  8011d5:	50                   	push   %eax
  8011d6:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8011d8:	83 c7 01             	add    $0x1,%edi
  8011db:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8011df:	83 c4 10             	add    $0x10,%esp
  8011e2:	85 c0                	test   %eax,%eax
  8011e4:	75 eb                	jne    8011d1 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8011e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8011e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8011ec:	e9 ed fe ff ff       	jmp    8010de <vprintfmt+0x446>
			putch(ch, putdat);
  8011f1:	83 ec 08             	sub    $0x8,%esp
  8011f4:	53                   	push   %ebx
  8011f5:	6a 25                	push   $0x25
  8011f7:	ff d6                	call   *%esi
			break;
  8011f9:	83 c4 10             	add    $0x10,%esp
  8011fc:	e9 dd fe ff ff       	jmp    8010de <vprintfmt+0x446>
			putch('%', putdat);
  801201:	83 ec 08             	sub    $0x8,%esp
  801204:	53                   	push   %ebx
  801205:	6a 25                	push   $0x25
  801207:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801209:	83 c4 10             	add    $0x10,%esp
  80120c:	89 f8                	mov    %edi,%eax
  80120e:	eb 03                	jmp    801213 <vprintfmt+0x57b>
  801210:	83 e8 01             	sub    $0x1,%eax
  801213:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801217:	75 f7                	jne    801210 <vprintfmt+0x578>
  801219:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80121c:	e9 bd fe ff ff       	jmp    8010de <vprintfmt+0x446>
}
  801221:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801224:	5b                   	pop    %ebx
  801225:	5e                   	pop    %esi
  801226:	5f                   	pop    %edi
  801227:	5d                   	pop    %ebp
  801228:	c3                   	ret    

00801229 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801229:	55                   	push   %ebp
  80122a:	89 e5                	mov    %esp,%ebp
  80122c:	83 ec 18             	sub    $0x18,%esp
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801235:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801238:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80123c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80123f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801246:	85 c0                	test   %eax,%eax
  801248:	74 26                	je     801270 <vsnprintf+0x47>
  80124a:	85 d2                	test   %edx,%edx
  80124c:	7e 22                	jle    801270 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80124e:	ff 75 14             	pushl  0x14(%ebp)
  801251:	ff 75 10             	pushl  0x10(%ebp)
  801254:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801257:	50                   	push   %eax
  801258:	68 5e 0c 80 00       	push   $0x800c5e
  80125d:	e8 36 fa ff ff       	call   800c98 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801262:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801265:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80126b:	83 c4 10             	add    $0x10,%esp
}
  80126e:	c9                   	leave  
  80126f:	c3                   	ret    
		return -E_INVAL;
  801270:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801275:	eb f7                	jmp    80126e <vsnprintf+0x45>

00801277 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801277:	55                   	push   %ebp
  801278:	89 e5                	mov    %esp,%ebp
  80127a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80127d:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801280:	50                   	push   %eax
  801281:	ff 75 10             	pushl  0x10(%ebp)
  801284:	ff 75 0c             	pushl  0xc(%ebp)
  801287:	ff 75 08             	pushl  0x8(%ebp)
  80128a:	e8 9a ff ff ff       	call   801229 <vsnprintf>
	va_end(ap);

	return rc;
}
  80128f:	c9                   	leave  
  801290:	c3                   	ret    

00801291 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  801291:	55                   	push   %ebp
  801292:	89 e5                	mov    %esp,%ebp
  801294:	57                   	push   %edi
  801295:	56                   	push   %esi
  801296:	53                   	push   %ebx
  801297:	83 ec 0c             	sub    $0xc,%esp
  80129a:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  80129d:	85 c0                	test   %eax,%eax
  80129f:	74 13                	je     8012b4 <readline+0x23>
		fprintf(1, "%s", prompt);
  8012a1:	83 ec 04             	sub    $0x4,%esp
  8012a4:	50                   	push   %eax
  8012a5:	68 4a 37 80 00       	push   $0x80374a
  8012aa:	6a 01                	push   $0x1
  8012ac:	e8 d9 15 00 00       	call   80288a <fprintf>
  8012b1:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
  8012b4:	83 ec 0c             	sub    $0xc,%esp
  8012b7:	6a 00                	push   $0x0
  8012b9:	e8 92 f6 ff ff       	call   800950 <iscons>
  8012be:	89 c7                	mov    %eax,%edi
  8012c0:	83 c4 10             	add    $0x10,%esp
	i = 0;
  8012c3:	be 00 00 00 00       	mov    $0x0,%esi
  8012c8:	eb 57                	jmp    801321 <readline+0x90>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  8012ca:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
  8012cf:	83 fb f8             	cmp    $0xfffffff8,%ebx
  8012d2:	75 08                	jne    8012dc <readline+0x4b>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
  8012d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012d7:	5b                   	pop    %ebx
  8012d8:	5e                   	pop    %esi
  8012d9:	5f                   	pop    %edi
  8012da:	5d                   	pop    %ebp
  8012db:	c3                   	ret    
				cprintf("read error: %e\n", c);
  8012dc:	83 ec 08             	sub    $0x8,%esp
  8012df:	53                   	push   %ebx
  8012e0:	68 c0 3b 80 00       	push   $0x803bc0
  8012e5:	e8 81 f8 ff ff       	call   800b6b <cprintf>
  8012ea:	83 c4 10             	add    $0x10,%esp
			return NULL;
  8012ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f2:	eb e0                	jmp    8012d4 <readline+0x43>
			if (echoing)
  8012f4:	85 ff                	test   %edi,%edi
  8012f6:	75 05                	jne    8012fd <readline+0x6c>
			i--;
  8012f8:	83 ee 01             	sub    $0x1,%esi
  8012fb:	eb 24                	jmp    801321 <readline+0x90>
				cputchar('\b');
  8012fd:	83 ec 0c             	sub    $0xc,%esp
  801300:	6a 08                	push   $0x8
  801302:	e8 04 f6 ff ff       	call   80090b <cputchar>
  801307:	83 c4 10             	add    $0x10,%esp
  80130a:	eb ec                	jmp    8012f8 <readline+0x67>
				cputchar(c);
  80130c:	83 ec 0c             	sub    $0xc,%esp
  80130f:	53                   	push   %ebx
  801310:	e8 f6 f5 ff ff       	call   80090b <cputchar>
  801315:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801318:	88 9e 20 50 80 00    	mov    %bl,0x805020(%esi)
  80131e:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
  801321:	e8 01 f6 ff ff       	call   800927 <getchar>
  801326:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  801328:	85 c0                	test   %eax,%eax
  80132a:	78 9e                	js     8012ca <readline+0x39>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  80132c:	83 f8 08             	cmp    $0x8,%eax
  80132f:	0f 94 c2             	sete   %dl
  801332:	83 f8 7f             	cmp    $0x7f,%eax
  801335:	0f 94 c0             	sete   %al
  801338:	08 c2                	or     %al,%dl
  80133a:	74 04                	je     801340 <readline+0xaf>
  80133c:	85 f6                	test   %esi,%esi
  80133e:	7f b4                	jg     8012f4 <readline+0x63>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801340:	83 fb 1f             	cmp    $0x1f,%ebx
  801343:	7e 0e                	jle    801353 <readline+0xc2>
  801345:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  80134b:	7f 06                	jg     801353 <readline+0xc2>
			if (echoing)
  80134d:	85 ff                	test   %edi,%edi
  80134f:	74 c7                	je     801318 <readline+0x87>
  801351:	eb b9                	jmp    80130c <readline+0x7b>
		} else if (c == '\n' || c == '\r') {
  801353:	83 fb 0a             	cmp    $0xa,%ebx
  801356:	74 05                	je     80135d <readline+0xcc>
  801358:	83 fb 0d             	cmp    $0xd,%ebx
  80135b:	75 c4                	jne    801321 <readline+0x90>
			if (echoing)
  80135d:	85 ff                	test   %edi,%edi
  80135f:	75 11                	jne    801372 <readline+0xe1>
			buf[i] = 0;
  801361:	c6 86 20 50 80 00 00 	movb   $0x0,0x805020(%esi)
			return buf;
  801368:	b8 20 50 80 00       	mov    $0x805020,%eax
  80136d:	e9 62 ff ff ff       	jmp    8012d4 <readline+0x43>
				cputchar('\n');
  801372:	83 ec 0c             	sub    $0xc,%esp
  801375:	6a 0a                	push   $0xa
  801377:	e8 8f f5 ff ff       	call   80090b <cputchar>
  80137c:	83 c4 10             	add    $0x10,%esp
  80137f:	eb e0                	jmp    801361 <readline+0xd0>

00801381 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801381:	55                   	push   %ebp
  801382:	89 e5                	mov    %esp,%ebp
  801384:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801387:	b8 00 00 00 00       	mov    $0x0,%eax
  80138c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801390:	74 05                	je     801397 <strlen+0x16>
		n++;
  801392:	83 c0 01             	add    $0x1,%eax
  801395:	eb f5                	jmp    80138c <strlen+0xb>
	return n;
}
  801397:	5d                   	pop    %ebp
  801398:	c3                   	ret    

00801399 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801399:	55                   	push   %ebp
  80139a:	89 e5                	mov    %esp,%ebp
  80139c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80139f:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8013a7:	39 c2                	cmp    %eax,%edx
  8013a9:	74 0d                	je     8013b8 <strnlen+0x1f>
  8013ab:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8013af:	74 05                	je     8013b6 <strnlen+0x1d>
		n++;
  8013b1:	83 c2 01             	add    $0x1,%edx
  8013b4:	eb f1                	jmp    8013a7 <strnlen+0xe>
  8013b6:	89 d0                	mov    %edx,%eax
	return n;
}
  8013b8:	5d                   	pop    %ebp
  8013b9:	c3                   	ret    

008013ba <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013ba:	55                   	push   %ebp
  8013bb:	89 e5                	mov    %esp,%ebp
  8013bd:	53                   	push   %ebx
  8013be:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8013c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8013c9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8013cd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8013d0:	83 c2 01             	add    $0x1,%edx
  8013d3:	84 c9                	test   %cl,%cl
  8013d5:	75 f2                	jne    8013c9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8013d7:	5b                   	pop    %ebx
  8013d8:	5d                   	pop    %ebp
  8013d9:	c3                   	ret    

008013da <strcat>:

char *
strcat(char *dst, const char *src)
{
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
  8013dd:	53                   	push   %ebx
  8013de:	83 ec 10             	sub    $0x10,%esp
  8013e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8013e4:	53                   	push   %ebx
  8013e5:	e8 97 ff ff ff       	call   801381 <strlen>
  8013ea:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8013ed:	ff 75 0c             	pushl  0xc(%ebp)
  8013f0:	01 d8                	add    %ebx,%eax
  8013f2:	50                   	push   %eax
  8013f3:	e8 c2 ff ff ff       	call   8013ba <strcpy>
	return dst;
}
  8013f8:	89 d8                	mov    %ebx,%eax
  8013fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013fd:	c9                   	leave  
  8013fe:	c3                   	ret    

008013ff <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
  801402:	56                   	push   %esi
  801403:	53                   	push   %ebx
  801404:	8b 45 08             	mov    0x8(%ebp),%eax
  801407:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80140a:	89 c6                	mov    %eax,%esi
  80140c:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80140f:	89 c2                	mov    %eax,%edx
  801411:	39 f2                	cmp    %esi,%edx
  801413:	74 11                	je     801426 <strncpy+0x27>
		*dst++ = *src;
  801415:	83 c2 01             	add    $0x1,%edx
  801418:	0f b6 19             	movzbl (%ecx),%ebx
  80141b:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80141e:	80 fb 01             	cmp    $0x1,%bl
  801421:	83 d9 ff             	sbb    $0xffffffff,%ecx
  801424:	eb eb                	jmp    801411 <strncpy+0x12>
	}
	return ret;
}
  801426:	5b                   	pop    %ebx
  801427:	5e                   	pop    %esi
  801428:	5d                   	pop    %ebp
  801429:	c3                   	ret    

0080142a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80142a:	55                   	push   %ebp
  80142b:	89 e5                	mov    %esp,%ebp
  80142d:	56                   	push   %esi
  80142e:	53                   	push   %ebx
  80142f:	8b 75 08             	mov    0x8(%ebp),%esi
  801432:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801435:	8b 55 10             	mov    0x10(%ebp),%edx
  801438:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80143a:	85 d2                	test   %edx,%edx
  80143c:	74 21                	je     80145f <strlcpy+0x35>
  80143e:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801442:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801444:	39 c2                	cmp    %eax,%edx
  801446:	74 14                	je     80145c <strlcpy+0x32>
  801448:	0f b6 19             	movzbl (%ecx),%ebx
  80144b:	84 db                	test   %bl,%bl
  80144d:	74 0b                	je     80145a <strlcpy+0x30>
			*dst++ = *src++;
  80144f:	83 c1 01             	add    $0x1,%ecx
  801452:	83 c2 01             	add    $0x1,%edx
  801455:	88 5a ff             	mov    %bl,-0x1(%edx)
  801458:	eb ea                	jmp    801444 <strlcpy+0x1a>
  80145a:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80145c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80145f:	29 f0                	sub    %esi,%eax
}
  801461:	5b                   	pop    %ebx
  801462:	5e                   	pop    %esi
  801463:	5d                   	pop    %ebp
  801464:	c3                   	ret    

00801465 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801465:	55                   	push   %ebp
  801466:	89 e5                	mov    %esp,%ebp
  801468:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80146b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80146e:	0f b6 01             	movzbl (%ecx),%eax
  801471:	84 c0                	test   %al,%al
  801473:	74 0c                	je     801481 <strcmp+0x1c>
  801475:	3a 02                	cmp    (%edx),%al
  801477:	75 08                	jne    801481 <strcmp+0x1c>
		p++, q++;
  801479:	83 c1 01             	add    $0x1,%ecx
  80147c:	83 c2 01             	add    $0x1,%edx
  80147f:	eb ed                	jmp    80146e <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801481:	0f b6 c0             	movzbl %al,%eax
  801484:	0f b6 12             	movzbl (%edx),%edx
  801487:	29 d0                	sub    %edx,%eax
}
  801489:	5d                   	pop    %ebp
  80148a:	c3                   	ret    

0080148b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80148b:	55                   	push   %ebp
  80148c:	89 e5                	mov    %esp,%ebp
  80148e:	53                   	push   %ebx
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	8b 55 0c             	mov    0xc(%ebp),%edx
  801495:	89 c3                	mov    %eax,%ebx
  801497:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80149a:	eb 06                	jmp    8014a2 <strncmp+0x17>
		n--, p++, q++;
  80149c:	83 c0 01             	add    $0x1,%eax
  80149f:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8014a2:	39 d8                	cmp    %ebx,%eax
  8014a4:	74 16                	je     8014bc <strncmp+0x31>
  8014a6:	0f b6 08             	movzbl (%eax),%ecx
  8014a9:	84 c9                	test   %cl,%cl
  8014ab:	74 04                	je     8014b1 <strncmp+0x26>
  8014ad:	3a 0a                	cmp    (%edx),%cl
  8014af:	74 eb                	je     80149c <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014b1:	0f b6 00             	movzbl (%eax),%eax
  8014b4:	0f b6 12             	movzbl (%edx),%edx
  8014b7:	29 d0                	sub    %edx,%eax
}
  8014b9:	5b                   	pop    %ebx
  8014ba:	5d                   	pop    %ebp
  8014bb:	c3                   	ret    
		return 0;
  8014bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c1:	eb f6                	jmp    8014b9 <strncmp+0x2e>

008014c3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
  8014c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8014cd:	0f b6 10             	movzbl (%eax),%edx
  8014d0:	84 d2                	test   %dl,%dl
  8014d2:	74 09                	je     8014dd <strchr+0x1a>
		if (*s == c)
  8014d4:	38 ca                	cmp    %cl,%dl
  8014d6:	74 0a                	je     8014e2 <strchr+0x1f>
	for (; *s; s++)
  8014d8:	83 c0 01             	add    $0x1,%eax
  8014db:	eb f0                	jmp    8014cd <strchr+0xa>
			return (char *) s;
	return 0;
  8014dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014e2:	5d                   	pop    %ebp
  8014e3:	c3                   	ret    

008014e4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014e4:	55                   	push   %ebp
  8014e5:	89 e5                	mov    %esp,%ebp
  8014e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ea:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8014ee:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8014f1:	38 ca                	cmp    %cl,%dl
  8014f3:	74 09                	je     8014fe <strfind+0x1a>
  8014f5:	84 d2                	test   %dl,%dl
  8014f7:	74 05                	je     8014fe <strfind+0x1a>
	for (; *s; s++)
  8014f9:	83 c0 01             	add    $0x1,%eax
  8014fc:	eb f0                	jmp    8014ee <strfind+0xa>
			break;
	return (char *) s;
}
  8014fe:	5d                   	pop    %ebp
  8014ff:	c3                   	ret    

00801500 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
  801503:	57                   	push   %edi
  801504:	56                   	push   %esi
  801505:	53                   	push   %ebx
  801506:	8b 7d 08             	mov    0x8(%ebp),%edi
  801509:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80150c:	85 c9                	test   %ecx,%ecx
  80150e:	74 31                	je     801541 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801510:	89 f8                	mov    %edi,%eax
  801512:	09 c8                	or     %ecx,%eax
  801514:	a8 03                	test   $0x3,%al
  801516:	75 23                	jne    80153b <memset+0x3b>
		c &= 0xFF;
  801518:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80151c:	89 d3                	mov    %edx,%ebx
  80151e:	c1 e3 08             	shl    $0x8,%ebx
  801521:	89 d0                	mov    %edx,%eax
  801523:	c1 e0 18             	shl    $0x18,%eax
  801526:	89 d6                	mov    %edx,%esi
  801528:	c1 e6 10             	shl    $0x10,%esi
  80152b:	09 f0                	or     %esi,%eax
  80152d:	09 c2                	or     %eax,%edx
  80152f:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801531:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801534:	89 d0                	mov    %edx,%eax
  801536:	fc                   	cld    
  801537:	f3 ab                	rep stos %eax,%es:(%edi)
  801539:	eb 06                	jmp    801541 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80153b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153e:	fc                   	cld    
  80153f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801541:	89 f8                	mov    %edi,%eax
  801543:	5b                   	pop    %ebx
  801544:	5e                   	pop    %esi
  801545:	5f                   	pop    %edi
  801546:	5d                   	pop    %ebp
  801547:	c3                   	ret    

00801548 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801548:	55                   	push   %ebp
  801549:	89 e5                	mov    %esp,%ebp
  80154b:	57                   	push   %edi
  80154c:	56                   	push   %esi
  80154d:	8b 45 08             	mov    0x8(%ebp),%eax
  801550:	8b 75 0c             	mov    0xc(%ebp),%esi
  801553:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801556:	39 c6                	cmp    %eax,%esi
  801558:	73 32                	jae    80158c <memmove+0x44>
  80155a:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80155d:	39 c2                	cmp    %eax,%edx
  80155f:	76 2b                	jbe    80158c <memmove+0x44>
		s += n;
		d += n;
  801561:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801564:	89 fe                	mov    %edi,%esi
  801566:	09 ce                	or     %ecx,%esi
  801568:	09 d6                	or     %edx,%esi
  80156a:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801570:	75 0e                	jne    801580 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801572:	83 ef 04             	sub    $0x4,%edi
  801575:	8d 72 fc             	lea    -0x4(%edx),%esi
  801578:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80157b:	fd                   	std    
  80157c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80157e:	eb 09                	jmp    801589 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801580:	83 ef 01             	sub    $0x1,%edi
  801583:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801586:	fd                   	std    
  801587:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801589:	fc                   	cld    
  80158a:	eb 1a                	jmp    8015a6 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80158c:	89 c2                	mov    %eax,%edx
  80158e:	09 ca                	or     %ecx,%edx
  801590:	09 f2                	or     %esi,%edx
  801592:	f6 c2 03             	test   $0x3,%dl
  801595:	75 0a                	jne    8015a1 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801597:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80159a:	89 c7                	mov    %eax,%edi
  80159c:	fc                   	cld    
  80159d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80159f:	eb 05                	jmp    8015a6 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  8015a1:	89 c7                	mov    %eax,%edi
  8015a3:	fc                   	cld    
  8015a4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8015a6:	5e                   	pop    %esi
  8015a7:	5f                   	pop    %edi
  8015a8:	5d                   	pop    %ebp
  8015a9:	c3                   	ret    

008015aa <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
  8015ad:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8015b0:	ff 75 10             	pushl  0x10(%ebp)
  8015b3:	ff 75 0c             	pushl  0xc(%ebp)
  8015b6:	ff 75 08             	pushl  0x8(%ebp)
  8015b9:	e8 8a ff ff ff       	call   801548 <memmove>
}
  8015be:	c9                   	leave  
  8015bf:	c3                   	ret    

008015c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
  8015c3:	56                   	push   %esi
  8015c4:	53                   	push   %ebx
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015cb:	89 c6                	mov    %eax,%esi
  8015cd:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8015d0:	39 f0                	cmp    %esi,%eax
  8015d2:	74 1c                	je     8015f0 <memcmp+0x30>
		if (*s1 != *s2)
  8015d4:	0f b6 08             	movzbl (%eax),%ecx
  8015d7:	0f b6 1a             	movzbl (%edx),%ebx
  8015da:	38 d9                	cmp    %bl,%cl
  8015dc:	75 08                	jne    8015e6 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8015de:	83 c0 01             	add    $0x1,%eax
  8015e1:	83 c2 01             	add    $0x1,%edx
  8015e4:	eb ea                	jmp    8015d0 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8015e6:	0f b6 c1             	movzbl %cl,%eax
  8015e9:	0f b6 db             	movzbl %bl,%ebx
  8015ec:	29 d8                	sub    %ebx,%eax
  8015ee:	eb 05                	jmp    8015f5 <memcmp+0x35>
	}

	return 0;
  8015f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015f5:	5b                   	pop    %ebx
  8015f6:	5e                   	pop    %esi
  8015f7:	5d                   	pop    %ebp
  8015f8:	c3                   	ret    

008015f9 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
  8015fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801602:	89 c2                	mov    %eax,%edx
  801604:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801607:	39 d0                	cmp    %edx,%eax
  801609:	73 09                	jae    801614 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  80160b:	38 08                	cmp    %cl,(%eax)
  80160d:	74 05                	je     801614 <memfind+0x1b>
	for (; s < ends; s++)
  80160f:	83 c0 01             	add    $0x1,%eax
  801612:	eb f3                	jmp    801607 <memfind+0xe>
			break;
	return (void *) s;
}
  801614:	5d                   	pop    %ebp
  801615:	c3                   	ret    

00801616 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
  801619:	57                   	push   %edi
  80161a:	56                   	push   %esi
  80161b:	53                   	push   %ebx
  80161c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80161f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801622:	eb 03                	jmp    801627 <strtol+0x11>
		s++;
  801624:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801627:	0f b6 01             	movzbl (%ecx),%eax
  80162a:	3c 20                	cmp    $0x20,%al
  80162c:	74 f6                	je     801624 <strtol+0xe>
  80162e:	3c 09                	cmp    $0x9,%al
  801630:	74 f2                	je     801624 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801632:	3c 2b                	cmp    $0x2b,%al
  801634:	74 2a                	je     801660 <strtol+0x4a>
	int neg = 0;
  801636:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  80163b:	3c 2d                	cmp    $0x2d,%al
  80163d:	74 2b                	je     80166a <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80163f:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801645:	75 0f                	jne    801656 <strtol+0x40>
  801647:	80 39 30             	cmpb   $0x30,(%ecx)
  80164a:	74 28                	je     801674 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  80164c:	85 db                	test   %ebx,%ebx
  80164e:	b8 0a 00 00 00       	mov    $0xa,%eax
  801653:	0f 44 d8             	cmove  %eax,%ebx
  801656:	b8 00 00 00 00       	mov    $0x0,%eax
  80165b:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80165e:	eb 50                	jmp    8016b0 <strtol+0x9a>
		s++;
  801660:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801663:	bf 00 00 00 00       	mov    $0x0,%edi
  801668:	eb d5                	jmp    80163f <strtol+0x29>
		s++, neg = 1;
  80166a:	83 c1 01             	add    $0x1,%ecx
  80166d:	bf 01 00 00 00       	mov    $0x1,%edi
  801672:	eb cb                	jmp    80163f <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801674:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801678:	74 0e                	je     801688 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  80167a:	85 db                	test   %ebx,%ebx
  80167c:	75 d8                	jne    801656 <strtol+0x40>
		s++, base = 8;
  80167e:	83 c1 01             	add    $0x1,%ecx
  801681:	bb 08 00 00 00       	mov    $0x8,%ebx
  801686:	eb ce                	jmp    801656 <strtol+0x40>
		s += 2, base = 16;
  801688:	83 c1 02             	add    $0x2,%ecx
  80168b:	bb 10 00 00 00       	mov    $0x10,%ebx
  801690:	eb c4                	jmp    801656 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801692:	8d 72 9f             	lea    -0x61(%edx),%esi
  801695:	89 f3                	mov    %esi,%ebx
  801697:	80 fb 19             	cmp    $0x19,%bl
  80169a:	77 29                	ja     8016c5 <strtol+0xaf>
			dig = *s - 'a' + 10;
  80169c:	0f be d2             	movsbl %dl,%edx
  80169f:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8016a2:	3b 55 10             	cmp    0x10(%ebp),%edx
  8016a5:	7d 30                	jge    8016d7 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  8016a7:	83 c1 01             	add    $0x1,%ecx
  8016aa:	0f af 45 10          	imul   0x10(%ebp),%eax
  8016ae:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8016b0:	0f b6 11             	movzbl (%ecx),%edx
  8016b3:	8d 72 d0             	lea    -0x30(%edx),%esi
  8016b6:	89 f3                	mov    %esi,%ebx
  8016b8:	80 fb 09             	cmp    $0x9,%bl
  8016bb:	77 d5                	ja     801692 <strtol+0x7c>
			dig = *s - '0';
  8016bd:	0f be d2             	movsbl %dl,%edx
  8016c0:	83 ea 30             	sub    $0x30,%edx
  8016c3:	eb dd                	jmp    8016a2 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  8016c5:	8d 72 bf             	lea    -0x41(%edx),%esi
  8016c8:	89 f3                	mov    %esi,%ebx
  8016ca:	80 fb 19             	cmp    $0x19,%bl
  8016cd:	77 08                	ja     8016d7 <strtol+0xc1>
			dig = *s - 'A' + 10;
  8016cf:	0f be d2             	movsbl %dl,%edx
  8016d2:	83 ea 37             	sub    $0x37,%edx
  8016d5:	eb cb                	jmp    8016a2 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  8016d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016db:	74 05                	je     8016e2 <strtol+0xcc>
		*endptr = (char *) s;
  8016dd:	8b 75 0c             	mov    0xc(%ebp),%esi
  8016e0:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8016e2:	89 c2                	mov    %eax,%edx
  8016e4:	f7 da                	neg    %edx
  8016e6:	85 ff                	test   %edi,%edi
  8016e8:	0f 45 c2             	cmovne %edx,%eax
}
  8016eb:	5b                   	pop    %ebx
  8016ec:	5e                   	pop    %esi
  8016ed:	5f                   	pop    %edi
  8016ee:	5d                   	pop    %ebp
  8016ef:	c3                   	ret    

008016f0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
  8016f3:	57                   	push   %edi
  8016f4:	56                   	push   %esi
  8016f5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8016f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8016fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801701:	89 c3                	mov    %eax,%ebx
  801703:	89 c7                	mov    %eax,%edi
  801705:	89 c6                	mov    %eax,%esi
  801707:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801709:	5b                   	pop    %ebx
  80170a:	5e                   	pop    %esi
  80170b:	5f                   	pop    %edi
  80170c:	5d                   	pop    %ebp
  80170d:	c3                   	ret    

0080170e <sys_cgetc>:

int
sys_cgetc(void)
{
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
  801711:	57                   	push   %edi
  801712:	56                   	push   %esi
  801713:	53                   	push   %ebx
	asm volatile("int %1\n"
  801714:	ba 00 00 00 00       	mov    $0x0,%edx
  801719:	b8 01 00 00 00       	mov    $0x1,%eax
  80171e:	89 d1                	mov    %edx,%ecx
  801720:	89 d3                	mov    %edx,%ebx
  801722:	89 d7                	mov    %edx,%edi
  801724:	89 d6                	mov    %edx,%esi
  801726:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801728:	5b                   	pop    %ebx
  801729:	5e                   	pop    %esi
  80172a:	5f                   	pop    %edi
  80172b:	5d                   	pop    %ebp
  80172c:	c3                   	ret    

0080172d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
  801730:	57                   	push   %edi
  801731:	56                   	push   %esi
  801732:	53                   	push   %ebx
  801733:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801736:	b9 00 00 00 00       	mov    $0x0,%ecx
  80173b:	8b 55 08             	mov    0x8(%ebp),%edx
  80173e:	b8 03 00 00 00       	mov    $0x3,%eax
  801743:	89 cb                	mov    %ecx,%ebx
  801745:	89 cf                	mov    %ecx,%edi
  801747:	89 ce                	mov    %ecx,%esi
  801749:	cd 30                	int    $0x30
	if(check && ret > 0)
  80174b:	85 c0                	test   %eax,%eax
  80174d:	7f 08                	jg     801757 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80174f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801752:	5b                   	pop    %ebx
  801753:	5e                   	pop    %esi
  801754:	5f                   	pop    %edi
  801755:	5d                   	pop    %ebp
  801756:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801757:	83 ec 0c             	sub    $0xc,%esp
  80175a:	50                   	push   %eax
  80175b:	6a 03                	push   $0x3
  80175d:	68 d0 3b 80 00       	push   $0x803bd0
  801762:	6a 43                	push   $0x43
  801764:	68 ed 3b 80 00       	push   $0x803bed
  801769:	e8 07 f3 ff ff       	call   800a75 <_panic>

0080176e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80176e:	55                   	push   %ebp
  80176f:	89 e5                	mov    %esp,%ebp
  801771:	57                   	push   %edi
  801772:	56                   	push   %esi
  801773:	53                   	push   %ebx
	asm volatile("int %1\n"
  801774:	ba 00 00 00 00       	mov    $0x0,%edx
  801779:	b8 02 00 00 00       	mov    $0x2,%eax
  80177e:	89 d1                	mov    %edx,%ecx
  801780:	89 d3                	mov    %edx,%ebx
  801782:	89 d7                	mov    %edx,%edi
  801784:	89 d6                	mov    %edx,%esi
  801786:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801788:	5b                   	pop    %ebx
  801789:	5e                   	pop    %esi
  80178a:	5f                   	pop    %edi
  80178b:	5d                   	pop    %ebp
  80178c:	c3                   	ret    

0080178d <sys_yield>:

void
sys_yield(void)
{
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
  801790:	57                   	push   %edi
  801791:	56                   	push   %esi
  801792:	53                   	push   %ebx
	asm volatile("int %1\n"
  801793:	ba 00 00 00 00       	mov    $0x0,%edx
  801798:	b8 0b 00 00 00       	mov    $0xb,%eax
  80179d:	89 d1                	mov    %edx,%ecx
  80179f:	89 d3                	mov    %edx,%ebx
  8017a1:	89 d7                	mov    %edx,%edi
  8017a3:	89 d6                	mov    %edx,%esi
  8017a5:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8017a7:	5b                   	pop    %ebx
  8017a8:	5e                   	pop    %esi
  8017a9:	5f                   	pop    %edi
  8017aa:	5d                   	pop    %ebp
  8017ab:	c3                   	ret    

008017ac <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
  8017af:	57                   	push   %edi
  8017b0:	56                   	push   %esi
  8017b1:	53                   	push   %ebx
  8017b2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8017b5:	be 00 00 00 00       	mov    $0x0,%esi
  8017ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8017bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017c0:	b8 04 00 00 00       	mov    $0x4,%eax
  8017c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8017c8:	89 f7                	mov    %esi,%edi
  8017ca:	cd 30                	int    $0x30
	if(check && ret > 0)
  8017cc:	85 c0                	test   %eax,%eax
  8017ce:	7f 08                	jg     8017d8 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8017d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017d3:	5b                   	pop    %ebx
  8017d4:	5e                   	pop    %esi
  8017d5:	5f                   	pop    %edi
  8017d6:	5d                   	pop    %ebp
  8017d7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8017d8:	83 ec 0c             	sub    $0xc,%esp
  8017db:	50                   	push   %eax
  8017dc:	6a 04                	push   $0x4
  8017de:	68 d0 3b 80 00       	push   $0x803bd0
  8017e3:	6a 43                	push   $0x43
  8017e5:	68 ed 3b 80 00       	push   $0x803bed
  8017ea:	e8 86 f2 ff ff       	call   800a75 <_panic>

008017ef <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8017ef:	55                   	push   %ebp
  8017f0:	89 e5                	mov    %esp,%ebp
  8017f2:	57                   	push   %edi
  8017f3:	56                   	push   %esi
  8017f4:	53                   	push   %ebx
  8017f5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8017f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8017fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017fe:	b8 05 00 00 00       	mov    $0x5,%eax
  801803:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801806:	8b 7d 14             	mov    0x14(%ebp),%edi
  801809:	8b 75 18             	mov    0x18(%ebp),%esi
  80180c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80180e:	85 c0                	test   %eax,%eax
  801810:	7f 08                	jg     80181a <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801812:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801815:	5b                   	pop    %ebx
  801816:	5e                   	pop    %esi
  801817:	5f                   	pop    %edi
  801818:	5d                   	pop    %ebp
  801819:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80181a:	83 ec 0c             	sub    $0xc,%esp
  80181d:	50                   	push   %eax
  80181e:	6a 05                	push   $0x5
  801820:	68 d0 3b 80 00       	push   $0x803bd0
  801825:	6a 43                	push   $0x43
  801827:	68 ed 3b 80 00       	push   $0x803bed
  80182c:	e8 44 f2 ff ff       	call   800a75 <_panic>

00801831 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
  801834:	57                   	push   %edi
  801835:	56                   	push   %esi
  801836:	53                   	push   %ebx
  801837:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80183a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80183f:	8b 55 08             	mov    0x8(%ebp),%edx
  801842:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801845:	b8 06 00 00 00       	mov    $0x6,%eax
  80184a:	89 df                	mov    %ebx,%edi
  80184c:	89 de                	mov    %ebx,%esi
  80184e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801850:	85 c0                	test   %eax,%eax
  801852:	7f 08                	jg     80185c <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801854:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801857:	5b                   	pop    %ebx
  801858:	5e                   	pop    %esi
  801859:	5f                   	pop    %edi
  80185a:	5d                   	pop    %ebp
  80185b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80185c:	83 ec 0c             	sub    $0xc,%esp
  80185f:	50                   	push   %eax
  801860:	6a 06                	push   $0x6
  801862:	68 d0 3b 80 00       	push   $0x803bd0
  801867:	6a 43                	push   $0x43
  801869:	68 ed 3b 80 00       	push   $0x803bed
  80186e:	e8 02 f2 ff ff       	call   800a75 <_panic>

00801873 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
  801876:	57                   	push   %edi
  801877:	56                   	push   %esi
  801878:	53                   	push   %ebx
  801879:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80187c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801881:	8b 55 08             	mov    0x8(%ebp),%edx
  801884:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801887:	b8 08 00 00 00       	mov    $0x8,%eax
  80188c:	89 df                	mov    %ebx,%edi
  80188e:	89 de                	mov    %ebx,%esi
  801890:	cd 30                	int    $0x30
	if(check && ret > 0)
  801892:	85 c0                	test   %eax,%eax
  801894:	7f 08                	jg     80189e <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801896:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801899:	5b                   	pop    %ebx
  80189a:	5e                   	pop    %esi
  80189b:	5f                   	pop    %edi
  80189c:	5d                   	pop    %ebp
  80189d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80189e:	83 ec 0c             	sub    $0xc,%esp
  8018a1:	50                   	push   %eax
  8018a2:	6a 08                	push   $0x8
  8018a4:	68 d0 3b 80 00       	push   $0x803bd0
  8018a9:	6a 43                	push   $0x43
  8018ab:	68 ed 3b 80 00       	push   $0x803bed
  8018b0:	e8 c0 f1 ff ff       	call   800a75 <_panic>

008018b5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
  8018b8:	57                   	push   %edi
  8018b9:	56                   	push   %esi
  8018ba:	53                   	push   %ebx
  8018bb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8018be:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8018c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018c9:	b8 09 00 00 00       	mov    $0x9,%eax
  8018ce:	89 df                	mov    %ebx,%edi
  8018d0:	89 de                	mov    %ebx,%esi
  8018d2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8018d4:	85 c0                	test   %eax,%eax
  8018d6:	7f 08                	jg     8018e0 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8018d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018db:	5b                   	pop    %ebx
  8018dc:	5e                   	pop    %esi
  8018dd:	5f                   	pop    %edi
  8018de:	5d                   	pop    %ebp
  8018df:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8018e0:	83 ec 0c             	sub    $0xc,%esp
  8018e3:	50                   	push   %eax
  8018e4:	6a 09                	push   $0x9
  8018e6:	68 d0 3b 80 00       	push   $0x803bd0
  8018eb:	6a 43                	push   $0x43
  8018ed:	68 ed 3b 80 00       	push   $0x803bed
  8018f2:	e8 7e f1 ff ff       	call   800a75 <_panic>

008018f7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
  8018fa:	57                   	push   %edi
  8018fb:	56                   	push   %esi
  8018fc:	53                   	push   %ebx
  8018fd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801900:	bb 00 00 00 00       	mov    $0x0,%ebx
  801905:	8b 55 08             	mov    0x8(%ebp),%edx
  801908:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80190b:	b8 0a 00 00 00       	mov    $0xa,%eax
  801910:	89 df                	mov    %ebx,%edi
  801912:	89 de                	mov    %ebx,%esi
  801914:	cd 30                	int    $0x30
	if(check && ret > 0)
  801916:	85 c0                	test   %eax,%eax
  801918:	7f 08                	jg     801922 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80191a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80191d:	5b                   	pop    %ebx
  80191e:	5e                   	pop    %esi
  80191f:	5f                   	pop    %edi
  801920:	5d                   	pop    %ebp
  801921:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801922:	83 ec 0c             	sub    $0xc,%esp
  801925:	50                   	push   %eax
  801926:	6a 0a                	push   $0xa
  801928:	68 d0 3b 80 00       	push   $0x803bd0
  80192d:	6a 43                	push   $0x43
  80192f:	68 ed 3b 80 00       	push   $0x803bed
  801934:	e8 3c f1 ff ff       	call   800a75 <_panic>

00801939 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
  80193c:	57                   	push   %edi
  80193d:	56                   	push   %esi
  80193e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80193f:	8b 55 08             	mov    0x8(%ebp),%edx
  801942:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801945:	b8 0c 00 00 00       	mov    $0xc,%eax
  80194a:	be 00 00 00 00       	mov    $0x0,%esi
  80194f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801952:	8b 7d 14             	mov    0x14(%ebp),%edi
  801955:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801957:	5b                   	pop    %ebx
  801958:	5e                   	pop    %esi
  801959:	5f                   	pop    %edi
  80195a:	5d                   	pop    %ebp
  80195b:	c3                   	ret    

0080195c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	57                   	push   %edi
  801960:	56                   	push   %esi
  801961:	53                   	push   %ebx
  801962:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801965:	b9 00 00 00 00       	mov    $0x0,%ecx
  80196a:	8b 55 08             	mov    0x8(%ebp),%edx
  80196d:	b8 0d 00 00 00       	mov    $0xd,%eax
  801972:	89 cb                	mov    %ecx,%ebx
  801974:	89 cf                	mov    %ecx,%edi
  801976:	89 ce                	mov    %ecx,%esi
  801978:	cd 30                	int    $0x30
	if(check && ret > 0)
  80197a:	85 c0                	test   %eax,%eax
  80197c:	7f 08                	jg     801986 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80197e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801981:	5b                   	pop    %ebx
  801982:	5e                   	pop    %esi
  801983:	5f                   	pop    %edi
  801984:	5d                   	pop    %ebp
  801985:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801986:	83 ec 0c             	sub    $0xc,%esp
  801989:	50                   	push   %eax
  80198a:	6a 0d                	push   $0xd
  80198c:	68 d0 3b 80 00       	push   $0x803bd0
  801991:	6a 43                	push   $0x43
  801993:	68 ed 3b 80 00       	push   $0x803bed
  801998:	e8 d8 f0 ff ff       	call   800a75 <_panic>

0080199d <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
  8019a0:	57                   	push   %edi
  8019a1:	56                   	push   %esi
  8019a2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8019a3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8019ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019ae:	b8 0e 00 00 00       	mov    $0xe,%eax
  8019b3:	89 df                	mov    %ebx,%edi
  8019b5:	89 de                	mov    %ebx,%esi
  8019b7:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8019b9:	5b                   	pop    %ebx
  8019ba:	5e                   	pop    %esi
  8019bb:	5f                   	pop    %edi
  8019bc:	5d                   	pop    %ebp
  8019bd:	c3                   	ret    

008019be <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
  8019c1:	57                   	push   %edi
  8019c2:	56                   	push   %esi
  8019c3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8019c4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8019cc:	b8 0f 00 00 00       	mov    $0xf,%eax
  8019d1:	89 cb                	mov    %ecx,%ebx
  8019d3:	89 cf                	mov    %ecx,%edi
  8019d5:	89 ce                	mov    %ecx,%esi
  8019d7:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8019d9:	5b                   	pop    %ebx
  8019da:	5e                   	pop    %esi
  8019db:	5f                   	pop    %edi
  8019dc:	5d                   	pop    %ebp
  8019dd:	c3                   	ret    

008019de <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
  8019e1:	53                   	push   %ebx
  8019e2:	83 ec 04             	sub    $0x4,%esp
	int r;
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8019e5:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8019ec:	83 e1 07             	and    $0x7,%ecx
  8019ef:	83 f9 07             	cmp    $0x7,%ecx
  8019f2:	74 32                	je     801a26 <duppage+0x48>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8019f4:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8019fb:	81 e1 05 08 00 00    	and    $0x805,%ecx
  801a01:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801a07:	74 7d                	je     801a86 <duppage+0xa8>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801a09:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801a10:	83 e1 05             	and    $0x5,%ecx
  801a13:	83 f9 05             	cmp    $0x5,%ecx
  801a16:	0f 84 9e 00 00 00    	je     801aba <duppage+0xdc>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801a1c:	b8 00 00 00 00       	mov    $0x0,%eax
  801a21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801a26:	89 d3                	mov    %edx,%ebx
  801a28:	c1 e3 0c             	shl    $0xc,%ebx
  801a2b:	83 ec 0c             	sub    $0xc,%esp
  801a2e:	68 05 08 00 00       	push   $0x805
  801a33:	53                   	push   %ebx
  801a34:	50                   	push   %eax
  801a35:	53                   	push   %ebx
  801a36:	6a 00                	push   $0x0
  801a38:	e8 b2 fd ff ff       	call   8017ef <sys_page_map>
		if(r < 0)
  801a3d:	83 c4 20             	add    $0x20,%esp
  801a40:	85 c0                	test   %eax,%eax
  801a42:	78 2e                	js     801a72 <duppage+0x94>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801a44:	83 ec 0c             	sub    $0xc,%esp
  801a47:	68 05 08 00 00       	push   $0x805
  801a4c:	53                   	push   %ebx
  801a4d:	6a 00                	push   $0x0
  801a4f:	53                   	push   %ebx
  801a50:	6a 00                	push   $0x0
  801a52:	e8 98 fd ff ff       	call   8017ef <sys_page_map>
		if(r < 0)
  801a57:	83 c4 20             	add    $0x20,%esp
  801a5a:	85 c0                	test   %eax,%eax
  801a5c:	79 be                	jns    801a1c <duppage+0x3e>
			panic("sys_page_map() panic\n");
  801a5e:	83 ec 04             	sub    $0x4,%esp
  801a61:	68 fb 3b 80 00       	push   $0x803bfb
  801a66:	6a 57                	push   $0x57
  801a68:	68 11 3c 80 00       	push   $0x803c11
  801a6d:	e8 03 f0 ff ff       	call   800a75 <_panic>
			panic("sys_page_map() panic\n");
  801a72:	83 ec 04             	sub    $0x4,%esp
  801a75:	68 fb 3b 80 00       	push   $0x803bfb
  801a7a:	6a 53                	push   $0x53
  801a7c:	68 11 3c 80 00       	push   $0x803c11
  801a81:	e8 ef ef ff ff       	call   800a75 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801a86:	c1 e2 0c             	shl    $0xc,%edx
  801a89:	83 ec 0c             	sub    $0xc,%esp
  801a8c:	68 05 08 00 00       	push   $0x805
  801a91:	52                   	push   %edx
  801a92:	50                   	push   %eax
  801a93:	52                   	push   %edx
  801a94:	6a 00                	push   $0x0
  801a96:	e8 54 fd ff ff       	call   8017ef <sys_page_map>
		if(r < 0)
  801a9b:	83 c4 20             	add    $0x20,%esp
  801a9e:	85 c0                	test   %eax,%eax
  801aa0:	0f 89 76 ff ff ff    	jns    801a1c <duppage+0x3e>
			panic("sys_page_map() panic\n");
  801aa6:	83 ec 04             	sub    $0x4,%esp
  801aa9:	68 fb 3b 80 00       	push   $0x803bfb
  801aae:	6a 5e                	push   $0x5e
  801ab0:	68 11 3c 80 00       	push   $0x803c11
  801ab5:	e8 bb ef ff ff       	call   800a75 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801aba:	c1 e2 0c             	shl    $0xc,%edx
  801abd:	83 ec 0c             	sub    $0xc,%esp
  801ac0:	6a 05                	push   $0x5
  801ac2:	52                   	push   %edx
  801ac3:	50                   	push   %eax
  801ac4:	52                   	push   %edx
  801ac5:	6a 00                	push   $0x0
  801ac7:	e8 23 fd ff ff       	call   8017ef <sys_page_map>
		if(r < 0)
  801acc:	83 c4 20             	add    $0x20,%esp
  801acf:	85 c0                	test   %eax,%eax
  801ad1:	0f 89 45 ff ff ff    	jns    801a1c <duppage+0x3e>
			panic("sys_page_map() panic\n");
  801ad7:	83 ec 04             	sub    $0x4,%esp
  801ada:	68 fb 3b 80 00       	push   $0x803bfb
  801adf:	6a 65                	push   $0x65
  801ae1:	68 11 3c 80 00       	push   $0x803c11
  801ae6:	e8 8a ef ff ff       	call   800a75 <_panic>

00801aeb <pgfault>:
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
  801aee:	53                   	push   %ebx
  801aef:	83 ec 04             	sub    $0x4,%esp
  801af2:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801af5:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801af7:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801afb:	0f 84 99 00 00 00    	je     801b9a <pgfault+0xaf>
  801b01:	89 c2                	mov    %eax,%edx
  801b03:	c1 ea 16             	shr    $0x16,%edx
  801b06:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801b0d:	f6 c2 01             	test   $0x1,%dl
  801b10:	0f 84 84 00 00 00    	je     801b9a <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801b16:	89 c2                	mov    %eax,%edx
  801b18:	c1 ea 0c             	shr    $0xc,%edx
  801b1b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801b22:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801b28:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801b2e:	75 6a                	jne    801b9a <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801b30:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b35:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801b37:	83 ec 04             	sub    $0x4,%esp
  801b3a:	6a 07                	push   $0x7
  801b3c:	68 00 f0 7f 00       	push   $0x7ff000
  801b41:	6a 00                	push   $0x0
  801b43:	e8 64 fc ff ff       	call   8017ac <sys_page_alloc>
	if(ret < 0)
  801b48:	83 c4 10             	add    $0x10,%esp
  801b4b:	85 c0                	test   %eax,%eax
  801b4d:	78 5f                	js     801bae <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801b4f:	83 ec 04             	sub    $0x4,%esp
  801b52:	68 00 10 00 00       	push   $0x1000
  801b57:	53                   	push   %ebx
  801b58:	68 00 f0 7f 00       	push   $0x7ff000
  801b5d:	e8 48 fa ff ff       	call   8015aa <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801b62:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801b69:	53                   	push   %ebx
  801b6a:	6a 00                	push   $0x0
  801b6c:	68 00 f0 7f 00       	push   $0x7ff000
  801b71:	6a 00                	push   $0x0
  801b73:	e8 77 fc ff ff       	call   8017ef <sys_page_map>
	if(ret < 0)
  801b78:	83 c4 20             	add    $0x20,%esp
  801b7b:	85 c0                	test   %eax,%eax
  801b7d:	78 43                	js     801bc2 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801b7f:	83 ec 08             	sub    $0x8,%esp
  801b82:	68 00 f0 7f 00       	push   $0x7ff000
  801b87:	6a 00                	push   $0x0
  801b89:	e8 a3 fc ff ff       	call   801831 <sys_page_unmap>
	if(ret < 0)
  801b8e:	83 c4 10             	add    $0x10,%esp
  801b91:	85 c0                	test   %eax,%eax
  801b93:	78 41                	js     801bd6 <pgfault+0xeb>
}
  801b95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b98:	c9                   	leave  
  801b99:	c3                   	ret    
		panic("panic at pgfault()\n");
  801b9a:	83 ec 04             	sub    $0x4,%esp
  801b9d:	68 1c 3c 80 00       	push   $0x803c1c
  801ba2:	6a 26                	push   $0x26
  801ba4:	68 11 3c 80 00       	push   $0x803c11
  801ba9:	e8 c7 ee ff ff       	call   800a75 <_panic>
		panic("panic in sys_page_alloc()\n");
  801bae:	83 ec 04             	sub    $0x4,%esp
  801bb1:	68 30 3c 80 00       	push   $0x803c30
  801bb6:	6a 31                	push   $0x31
  801bb8:	68 11 3c 80 00       	push   $0x803c11
  801bbd:	e8 b3 ee ff ff       	call   800a75 <_panic>
		panic("panic in sys_page_map()\n");
  801bc2:	83 ec 04             	sub    $0x4,%esp
  801bc5:	68 4b 3c 80 00       	push   $0x803c4b
  801bca:	6a 36                	push   $0x36
  801bcc:	68 11 3c 80 00       	push   $0x803c11
  801bd1:	e8 9f ee ff ff       	call   800a75 <_panic>
		panic("panic in sys_page_unmap()\n");
  801bd6:	83 ec 04             	sub    $0x4,%esp
  801bd9:	68 64 3c 80 00       	push   $0x803c64
  801bde:	6a 39                	push   $0x39
  801be0:	68 11 3c 80 00       	push   $0x803c11
  801be5:	e8 8b ee ff ff       	call   800a75 <_panic>

00801bea <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
  801bed:	57                   	push   %edi
  801bee:	56                   	push   %esi
  801bef:	53                   	push   %ebx
  801bf0:	83 ec 18             	sub    $0x18,%esp
	// cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
	int ret;
	set_pgfault_handler(pgfault);
  801bf3:	68 eb 1a 80 00       	push   $0x801aeb
  801bf8:	e8 b6 15 00 00       	call   8031b3 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801bfd:	b8 07 00 00 00       	mov    $0x7,%eax
  801c02:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801c04:	83 c4 10             	add    $0x10,%esp
  801c07:	85 c0                	test   %eax,%eax
  801c09:	78 27                	js     801c32 <fork+0x48>
  801c0b:	89 c6                	mov    %eax,%esi
  801c0d:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801c0f:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801c14:	75 48                	jne    801c5e <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  801c16:	e8 53 fb ff ff       	call   80176e <sys_getenvid>
  801c1b:	25 ff 03 00 00       	and    $0x3ff,%eax
  801c20:	c1 e0 07             	shl    $0x7,%eax
  801c23:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801c28:	a3 24 54 80 00       	mov    %eax,0x805424
		return 0;
  801c2d:	e9 90 00 00 00       	jmp    801cc2 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  801c32:	83 ec 04             	sub    $0x4,%esp
  801c35:	68 80 3c 80 00       	push   $0x803c80
  801c3a:	68 85 00 00 00       	push   $0x85
  801c3f:	68 11 3c 80 00       	push   $0x803c11
  801c44:	e8 2c ee ff ff       	call   800a75 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801c49:	89 f8                	mov    %edi,%eax
  801c4b:	e8 8e fd ff ff       	call   8019de <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801c50:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801c56:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801c5c:	74 26                	je     801c84 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801c5e:	89 d8                	mov    %ebx,%eax
  801c60:	c1 e8 16             	shr    $0x16,%eax
  801c63:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801c6a:	a8 01                	test   $0x1,%al
  801c6c:	74 e2                	je     801c50 <fork+0x66>
  801c6e:	89 da                	mov    %ebx,%edx
  801c70:	c1 ea 0c             	shr    $0xc,%edx
  801c73:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801c7a:	83 e0 05             	and    $0x5,%eax
  801c7d:	83 f8 05             	cmp    $0x5,%eax
  801c80:	75 ce                	jne    801c50 <fork+0x66>
  801c82:	eb c5                	jmp    801c49 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801c84:	83 ec 04             	sub    $0x4,%esp
  801c87:	6a 07                	push   $0x7
  801c89:	68 00 f0 bf ee       	push   $0xeebff000
  801c8e:	56                   	push   %esi
  801c8f:	e8 18 fb ff ff       	call   8017ac <sys_page_alloc>
	if(ret < 0)
  801c94:	83 c4 10             	add    $0x10,%esp
  801c97:	85 c0                	test   %eax,%eax
  801c99:	78 31                	js     801ccc <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801c9b:	83 ec 08             	sub    $0x8,%esp
  801c9e:	68 22 32 80 00       	push   $0x803222
  801ca3:	56                   	push   %esi
  801ca4:	e8 4e fc ff ff       	call   8018f7 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801ca9:	83 c4 10             	add    $0x10,%esp
  801cac:	85 c0                	test   %eax,%eax
  801cae:	78 33                	js     801ce3 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801cb0:	83 ec 08             	sub    $0x8,%esp
  801cb3:	6a 02                	push   $0x2
  801cb5:	56                   	push   %esi
  801cb6:	e8 b8 fb ff ff       	call   801873 <sys_env_set_status>
	if(ret < 0)
  801cbb:	83 c4 10             	add    $0x10,%esp
  801cbe:	85 c0                	test   %eax,%eax
  801cc0:	78 38                	js     801cfa <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801cc2:	89 f0                	mov    %esi,%eax
  801cc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cc7:	5b                   	pop    %ebx
  801cc8:	5e                   	pop    %esi
  801cc9:	5f                   	pop    %edi
  801cca:	5d                   	pop    %ebp
  801ccb:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801ccc:	83 ec 04             	sub    $0x4,%esp
  801ccf:	68 30 3c 80 00       	push   $0x803c30
  801cd4:	68 91 00 00 00       	push   $0x91
  801cd9:	68 11 3c 80 00       	push   $0x803c11
  801cde:	e8 92 ed ff ff       	call   800a75 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801ce3:	83 ec 04             	sub    $0x4,%esp
  801ce6:	68 a4 3c 80 00       	push   $0x803ca4
  801ceb:	68 94 00 00 00       	push   $0x94
  801cf0:	68 11 3c 80 00       	push   $0x803c11
  801cf5:	e8 7b ed ff ff       	call   800a75 <_panic>
		panic("panic in sys_env_set_status()\n");
  801cfa:	83 ec 04             	sub    $0x4,%esp
  801cfd:	68 cc 3c 80 00       	push   $0x803ccc
  801d02:	68 97 00 00 00       	push   $0x97
  801d07:	68 11 3c 80 00       	push   $0x803c11
  801d0c:	e8 64 ed ff ff       	call   800a75 <_panic>

00801d11 <sfork>:

// Challenge!
int
sfork(void)
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
  801d14:	57                   	push   %edi
  801d15:	56                   	push   %esi
  801d16:	53                   	push   %ebx
  801d17:	83 ec 10             	sub    $0x10,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  801d1a:	a1 24 54 80 00       	mov    0x805424,%eax
  801d1f:	8b 40 48             	mov    0x48(%eax),%eax
  801d22:	68 ec 3c 80 00       	push   $0x803cec
  801d27:	50                   	push   %eax
  801d28:	68 07 38 80 00       	push   $0x803807
  801d2d:	e8 39 ee ff ff       	call   800b6b <cprintf>
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801d32:	c7 04 24 eb 1a 80 00 	movl   $0x801aeb,(%esp)
  801d39:	e8 75 14 00 00       	call   8031b3 <set_pgfault_handler>
  801d3e:	b8 07 00 00 00       	mov    $0x7,%eax
  801d43:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801d45:	83 c4 10             	add    $0x10,%esp
  801d48:	85 c0                	test   %eax,%eax
  801d4a:	78 27                	js     801d73 <sfork+0x62>
  801d4c:	89 c7                	mov    %eax,%edi
  801d4e:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801d50:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801d55:	75 55                	jne    801dac <sfork+0x9b>
		thisenv = &envs[ENVX(sys_getenvid())];
  801d57:	e8 12 fa ff ff       	call   80176e <sys_getenvid>
  801d5c:	25 ff 03 00 00       	and    $0x3ff,%eax
  801d61:	c1 e0 07             	shl    $0x7,%eax
  801d64:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801d69:	a3 24 54 80 00       	mov    %eax,0x805424
		return 0;
  801d6e:	e9 d4 00 00 00       	jmp    801e47 <sfork+0x136>
		panic("the fork panic! at sys_exofork()\n");
  801d73:	83 ec 04             	sub    $0x4,%esp
  801d76:	68 80 3c 80 00       	push   $0x803c80
  801d7b:	68 a9 00 00 00       	push   $0xa9
  801d80:	68 11 3c 80 00       	push   $0x803c11
  801d85:	e8 eb ec ff ff       	call   800a75 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801d8a:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801d8f:	89 f0                	mov    %esi,%eax
  801d91:	e8 48 fc ff ff       	call   8019de <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801d96:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801d9c:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801da2:	77 65                	ja     801e09 <sfork+0xf8>
		if(i == (USTACKTOP - PGSIZE))
  801da4:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801daa:	74 de                	je     801d8a <sfork+0x79>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801dac:	89 d8                	mov    %ebx,%eax
  801dae:	c1 e8 16             	shr    $0x16,%eax
  801db1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801db8:	a8 01                	test   $0x1,%al
  801dba:	74 da                	je     801d96 <sfork+0x85>
  801dbc:	89 da                	mov    %ebx,%edx
  801dbe:	c1 ea 0c             	shr    $0xc,%edx
  801dc1:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801dc8:	83 e0 05             	and    $0x5,%eax
  801dcb:	83 f8 05             	cmp    $0x5,%eax
  801dce:	75 c6                	jne    801d96 <sfork+0x85>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801dd0:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801dd7:	c1 e2 0c             	shl    $0xc,%edx
  801dda:	83 ec 0c             	sub    $0xc,%esp
  801ddd:	83 e0 07             	and    $0x7,%eax
  801de0:	50                   	push   %eax
  801de1:	52                   	push   %edx
  801de2:	56                   	push   %esi
  801de3:	52                   	push   %edx
  801de4:	6a 00                	push   $0x0
  801de6:	e8 04 fa ff ff       	call   8017ef <sys_page_map>
  801deb:	83 c4 20             	add    $0x20,%esp
  801dee:	85 c0                	test   %eax,%eax
  801df0:	74 a4                	je     801d96 <sfork+0x85>
				panic("sys_page_map() panic\n");
  801df2:	83 ec 04             	sub    $0x4,%esp
  801df5:	68 fb 3b 80 00       	push   $0x803bfb
  801dfa:	68 b4 00 00 00       	push   $0xb4
  801dff:	68 11 3c 80 00       	push   $0x803c11
  801e04:	e8 6c ec ff ff       	call   800a75 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801e09:	83 ec 04             	sub    $0x4,%esp
  801e0c:	6a 07                	push   $0x7
  801e0e:	68 00 f0 bf ee       	push   $0xeebff000
  801e13:	57                   	push   %edi
  801e14:	e8 93 f9 ff ff       	call   8017ac <sys_page_alloc>
	if(ret < 0)
  801e19:	83 c4 10             	add    $0x10,%esp
  801e1c:	85 c0                	test   %eax,%eax
  801e1e:	78 31                	js     801e51 <sfork+0x140>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801e20:	83 ec 08             	sub    $0x8,%esp
  801e23:	68 22 32 80 00       	push   $0x803222
  801e28:	57                   	push   %edi
  801e29:	e8 c9 fa ff ff       	call   8018f7 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801e2e:	83 c4 10             	add    $0x10,%esp
  801e31:	85 c0                	test   %eax,%eax
  801e33:	78 33                	js     801e68 <sfork+0x157>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801e35:	83 ec 08             	sub    $0x8,%esp
  801e38:	6a 02                	push   $0x2
  801e3a:	57                   	push   %edi
  801e3b:	e8 33 fa ff ff       	call   801873 <sys_env_set_status>
	if(ret < 0)
  801e40:	83 c4 10             	add    $0x10,%esp
  801e43:	85 c0                	test   %eax,%eax
  801e45:	78 38                	js     801e7f <sfork+0x16e>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801e47:	89 f8                	mov    %edi,%eax
  801e49:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e4c:	5b                   	pop    %ebx
  801e4d:	5e                   	pop    %esi
  801e4e:	5f                   	pop    %edi
  801e4f:	5d                   	pop    %ebp
  801e50:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801e51:	83 ec 04             	sub    $0x4,%esp
  801e54:	68 30 3c 80 00       	push   $0x803c30
  801e59:	68 ba 00 00 00       	push   $0xba
  801e5e:	68 11 3c 80 00       	push   $0x803c11
  801e63:	e8 0d ec ff ff       	call   800a75 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801e68:	83 ec 04             	sub    $0x4,%esp
  801e6b:	68 a4 3c 80 00       	push   $0x803ca4
  801e70:	68 bd 00 00 00       	push   $0xbd
  801e75:	68 11 3c 80 00       	push   $0x803c11
  801e7a:	e8 f6 eb ff ff       	call   800a75 <_panic>
		panic("panic in sys_env_set_status()\n");
  801e7f:	83 ec 04             	sub    $0x4,%esp
  801e82:	68 cc 3c 80 00       	push   $0x803ccc
  801e87:	68 c0 00 00 00       	push   $0xc0
  801e8c:	68 11 3c 80 00       	push   $0x803c11
  801e91:	e8 df eb ff ff       	call   800a75 <_panic>

00801e96 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
  801e99:	8b 55 08             	mov    0x8(%ebp),%edx
  801e9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e9f:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801ea2:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  801ea4:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801ea7:	83 3a 01             	cmpl   $0x1,(%edx)
  801eaa:	7e 09                	jle    801eb5 <argstart+0x1f>
  801eac:	ba 01 36 80 00       	mov    $0x803601,%edx
  801eb1:	85 c9                	test   %ecx,%ecx
  801eb3:	75 05                	jne    801eba <argstart+0x24>
  801eb5:	ba 00 00 00 00       	mov    $0x0,%edx
  801eba:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  801ebd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801ec4:	5d                   	pop    %ebp
  801ec5:	c3                   	ret    

00801ec6 <argnext>:

int
argnext(struct Argstate *args)
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
  801ec9:	53                   	push   %ebx
  801eca:	83 ec 04             	sub    $0x4,%esp
  801ecd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801ed0:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801ed7:	8b 43 08             	mov    0x8(%ebx),%eax
  801eda:	85 c0                	test   %eax,%eax
  801edc:	74 72                	je     801f50 <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  801ede:	80 38 00             	cmpb   $0x0,(%eax)
  801ee1:	75 48                	jne    801f2b <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801ee3:	8b 0b                	mov    (%ebx),%ecx
  801ee5:	83 39 01             	cmpl   $0x1,(%ecx)
  801ee8:	74 58                	je     801f42 <argnext+0x7c>
		    || args->argv[1][0] != '-'
  801eea:	8b 53 04             	mov    0x4(%ebx),%edx
  801eed:	8b 42 04             	mov    0x4(%edx),%eax
  801ef0:	80 38 2d             	cmpb   $0x2d,(%eax)
  801ef3:	75 4d                	jne    801f42 <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  801ef5:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801ef9:	74 47                	je     801f42 <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801efb:	83 c0 01             	add    $0x1,%eax
  801efe:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801f01:	83 ec 04             	sub    $0x4,%esp
  801f04:	8b 01                	mov    (%ecx),%eax
  801f06:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801f0d:	50                   	push   %eax
  801f0e:	8d 42 08             	lea    0x8(%edx),%eax
  801f11:	50                   	push   %eax
  801f12:	83 c2 04             	add    $0x4,%edx
  801f15:	52                   	push   %edx
  801f16:	e8 2d f6 ff ff       	call   801548 <memmove>
		(*args->argc)--;
  801f1b:	8b 03                	mov    (%ebx),%eax
  801f1d:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801f20:	8b 43 08             	mov    0x8(%ebx),%eax
  801f23:	83 c4 10             	add    $0x10,%esp
  801f26:	80 38 2d             	cmpb   $0x2d,(%eax)
  801f29:	74 11                	je     801f3c <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801f2b:	8b 53 08             	mov    0x8(%ebx),%edx
  801f2e:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  801f31:	83 c2 01             	add    $0x1,%edx
  801f34:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801f37:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f3a:	c9                   	leave  
  801f3b:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801f3c:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801f40:	75 e9                	jne    801f2b <argnext+0x65>
	args->curarg = 0;
  801f42:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801f49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801f4e:	eb e7                	jmp    801f37 <argnext+0x71>
		return -1;
  801f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801f55:	eb e0                	jmp    801f37 <argnext+0x71>

00801f57 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801f57:	55                   	push   %ebp
  801f58:	89 e5                	mov    %esp,%ebp
  801f5a:	53                   	push   %ebx
  801f5b:	83 ec 04             	sub    $0x4,%esp
  801f5e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801f61:	8b 43 08             	mov    0x8(%ebx),%eax
  801f64:	85 c0                	test   %eax,%eax
  801f66:	74 12                	je     801f7a <argnextvalue+0x23>
		return 0;
	if (*args->curarg) {
  801f68:	80 38 00             	cmpb   $0x0,(%eax)
  801f6b:	74 12                	je     801f7f <argnextvalue+0x28>
		args->argvalue = args->curarg;
  801f6d:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801f70:	c7 43 08 01 36 80 00 	movl   $0x803601,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  801f77:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  801f7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f7d:	c9                   	leave  
  801f7e:	c3                   	ret    
	} else if (*args->argc > 1) {
  801f7f:	8b 13                	mov    (%ebx),%edx
  801f81:	83 3a 01             	cmpl   $0x1,(%edx)
  801f84:	7f 10                	jg     801f96 <argnextvalue+0x3f>
		args->argvalue = 0;
  801f86:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  801f8d:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  801f94:	eb e1                	jmp    801f77 <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  801f96:	8b 43 04             	mov    0x4(%ebx),%eax
  801f99:	8b 48 04             	mov    0x4(%eax),%ecx
  801f9c:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801f9f:	83 ec 04             	sub    $0x4,%esp
  801fa2:	8b 12                	mov    (%edx),%edx
  801fa4:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  801fab:	52                   	push   %edx
  801fac:	8d 50 08             	lea    0x8(%eax),%edx
  801faf:	52                   	push   %edx
  801fb0:	83 c0 04             	add    $0x4,%eax
  801fb3:	50                   	push   %eax
  801fb4:	e8 8f f5 ff ff       	call   801548 <memmove>
		(*args->argc)--;
  801fb9:	8b 03                	mov    (%ebx),%eax
  801fbb:	83 28 01             	subl   $0x1,(%eax)
  801fbe:	83 c4 10             	add    $0x10,%esp
  801fc1:	eb b4                	jmp    801f77 <argnextvalue+0x20>

00801fc3 <argvalue>:
{
  801fc3:	55                   	push   %ebp
  801fc4:	89 e5                	mov    %esp,%ebp
  801fc6:	83 ec 08             	sub    $0x8,%esp
  801fc9:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801fcc:	8b 42 0c             	mov    0xc(%edx),%eax
  801fcf:	85 c0                	test   %eax,%eax
  801fd1:	74 02                	je     801fd5 <argvalue+0x12>
}
  801fd3:	c9                   	leave  
  801fd4:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801fd5:	83 ec 0c             	sub    $0xc,%esp
  801fd8:	52                   	push   %edx
  801fd9:	e8 79 ff ff ff       	call   801f57 <argnextvalue>
  801fde:	83 c4 10             	add    $0x10,%esp
  801fe1:	eb f0                	jmp    801fd3 <argvalue+0x10>

00801fe3 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801fe3:	55                   	push   %ebp
  801fe4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe9:	05 00 00 00 30       	add    $0x30000000,%eax
  801fee:	c1 e8 0c             	shr    $0xc,%eax
}
  801ff1:	5d                   	pop    %ebp
  801ff2:	c3                   	ret    

00801ff3 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801ff3:	55                   	push   %ebp
  801ff4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff9:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801ffe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802003:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  802008:	5d                   	pop    %ebp
  802009:	c3                   	ret    

0080200a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80200a:	55                   	push   %ebp
  80200b:	89 e5                	mov    %esp,%ebp
  80200d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802012:	89 c2                	mov    %eax,%edx
  802014:	c1 ea 16             	shr    $0x16,%edx
  802017:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80201e:	f6 c2 01             	test   $0x1,%dl
  802021:	74 2d                	je     802050 <fd_alloc+0x46>
  802023:	89 c2                	mov    %eax,%edx
  802025:	c1 ea 0c             	shr    $0xc,%edx
  802028:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80202f:	f6 c2 01             	test   $0x1,%dl
  802032:	74 1c                	je     802050 <fd_alloc+0x46>
  802034:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  802039:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80203e:	75 d2                	jne    802012 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802040:	8b 45 08             	mov    0x8(%ebp),%eax
  802043:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  802049:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80204e:	eb 0a                	jmp    80205a <fd_alloc+0x50>
			*fd_store = fd;
  802050:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802053:	89 01                	mov    %eax,(%ecx)
			return 0;
  802055:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80205a:	5d                   	pop    %ebp
  80205b:	c3                   	ret    

0080205c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
  80205f:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802062:	83 f8 1f             	cmp    $0x1f,%eax
  802065:	77 30                	ja     802097 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  802067:	c1 e0 0c             	shl    $0xc,%eax
  80206a:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80206f:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  802075:	f6 c2 01             	test   $0x1,%dl
  802078:	74 24                	je     80209e <fd_lookup+0x42>
  80207a:	89 c2                	mov    %eax,%edx
  80207c:	c1 ea 0c             	shr    $0xc,%edx
  80207f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802086:	f6 c2 01             	test   $0x1,%dl
  802089:	74 1a                	je     8020a5 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80208b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80208e:	89 02                	mov    %eax,(%edx)
	return 0;
  802090:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802095:	5d                   	pop    %ebp
  802096:	c3                   	ret    
		return -E_INVAL;
  802097:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80209c:	eb f7                	jmp    802095 <fd_lookup+0x39>
		return -E_INVAL;
  80209e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020a3:	eb f0                	jmp    802095 <fd_lookup+0x39>
  8020a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020aa:	eb e9                	jmp    802095 <fd_lookup+0x39>

008020ac <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8020ac:	55                   	push   %ebp
  8020ad:	89 e5                	mov    %esp,%ebp
  8020af:	83 ec 08             	sub    $0x8,%esp
  8020b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020b5:	ba 70 3d 80 00       	mov    $0x803d70,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8020ba:	b8 20 40 80 00       	mov    $0x804020,%eax
		if (devtab[i]->dev_id == dev_id) {
  8020bf:	39 08                	cmp    %ecx,(%eax)
  8020c1:	74 33                	je     8020f6 <dev_lookup+0x4a>
  8020c3:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8020c6:	8b 02                	mov    (%edx),%eax
  8020c8:	85 c0                	test   %eax,%eax
  8020ca:	75 f3                	jne    8020bf <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8020cc:	a1 24 54 80 00       	mov    0x805424,%eax
  8020d1:	8b 40 48             	mov    0x48(%eax),%eax
  8020d4:	83 ec 04             	sub    $0x4,%esp
  8020d7:	51                   	push   %ecx
  8020d8:	50                   	push   %eax
  8020d9:	68 f4 3c 80 00       	push   $0x803cf4
  8020de:	e8 88 ea ff ff       	call   800b6b <cprintf>
	*dev = 0;
  8020e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8020ec:	83 c4 10             	add    $0x10,%esp
  8020ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8020f4:	c9                   	leave  
  8020f5:	c3                   	ret    
			*dev = devtab[i];
  8020f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020f9:	89 01                	mov    %eax,(%ecx)
			return 0;
  8020fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802100:	eb f2                	jmp    8020f4 <dev_lookup+0x48>

00802102 <fd_close>:
{
  802102:	55                   	push   %ebp
  802103:	89 e5                	mov    %esp,%ebp
  802105:	57                   	push   %edi
  802106:	56                   	push   %esi
  802107:	53                   	push   %ebx
  802108:	83 ec 24             	sub    $0x24,%esp
  80210b:	8b 75 08             	mov    0x8(%ebp),%esi
  80210e:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802111:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802114:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802115:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80211b:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80211e:	50                   	push   %eax
  80211f:	e8 38 ff ff ff       	call   80205c <fd_lookup>
  802124:	89 c3                	mov    %eax,%ebx
  802126:	83 c4 10             	add    $0x10,%esp
  802129:	85 c0                	test   %eax,%eax
  80212b:	78 05                	js     802132 <fd_close+0x30>
	    || fd != fd2)
  80212d:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  802130:	74 16                	je     802148 <fd_close+0x46>
		return (must_exist ? r : 0);
  802132:	89 f8                	mov    %edi,%eax
  802134:	84 c0                	test   %al,%al
  802136:	b8 00 00 00 00       	mov    $0x0,%eax
  80213b:	0f 44 d8             	cmove  %eax,%ebx
}
  80213e:	89 d8                	mov    %ebx,%eax
  802140:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802143:	5b                   	pop    %ebx
  802144:	5e                   	pop    %esi
  802145:	5f                   	pop    %edi
  802146:	5d                   	pop    %ebp
  802147:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802148:	83 ec 08             	sub    $0x8,%esp
  80214b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80214e:	50                   	push   %eax
  80214f:	ff 36                	pushl  (%esi)
  802151:	e8 56 ff ff ff       	call   8020ac <dev_lookup>
  802156:	89 c3                	mov    %eax,%ebx
  802158:	83 c4 10             	add    $0x10,%esp
  80215b:	85 c0                	test   %eax,%eax
  80215d:	78 1a                	js     802179 <fd_close+0x77>
		if (dev->dev_close)
  80215f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802162:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  802165:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80216a:	85 c0                	test   %eax,%eax
  80216c:	74 0b                	je     802179 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80216e:	83 ec 0c             	sub    $0xc,%esp
  802171:	56                   	push   %esi
  802172:	ff d0                	call   *%eax
  802174:	89 c3                	mov    %eax,%ebx
  802176:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  802179:	83 ec 08             	sub    $0x8,%esp
  80217c:	56                   	push   %esi
  80217d:	6a 00                	push   $0x0
  80217f:	e8 ad f6 ff ff       	call   801831 <sys_page_unmap>
	return r;
  802184:	83 c4 10             	add    $0x10,%esp
  802187:	eb b5                	jmp    80213e <fd_close+0x3c>

00802189 <close>:

int
close(int fdnum)
{
  802189:	55                   	push   %ebp
  80218a:	89 e5                	mov    %esp,%ebp
  80218c:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80218f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802192:	50                   	push   %eax
  802193:	ff 75 08             	pushl  0x8(%ebp)
  802196:	e8 c1 fe ff ff       	call   80205c <fd_lookup>
  80219b:	83 c4 10             	add    $0x10,%esp
  80219e:	85 c0                	test   %eax,%eax
  8021a0:	79 02                	jns    8021a4 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8021a2:	c9                   	leave  
  8021a3:	c3                   	ret    
		return fd_close(fd, 1);
  8021a4:	83 ec 08             	sub    $0x8,%esp
  8021a7:	6a 01                	push   $0x1
  8021a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8021ac:	e8 51 ff ff ff       	call   802102 <fd_close>
  8021b1:	83 c4 10             	add    $0x10,%esp
  8021b4:	eb ec                	jmp    8021a2 <close+0x19>

008021b6 <close_all>:

void
close_all(void)
{
  8021b6:	55                   	push   %ebp
  8021b7:	89 e5                	mov    %esp,%ebp
  8021b9:	53                   	push   %ebx
  8021ba:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8021bd:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8021c2:	83 ec 0c             	sub    $0xc,%esp
  8021c5:	53                   	push   %ebx
  8021c6:	e8 be ff ff ff       	call   802189 <close>
	for (i = 0; i < MAXFD; i++)
  8021cb:	83 c3 01             	add    $0x1,%ebx
  8021ce:	83 c4 10             	add    $0x10,%esp
  8021d1:	83 fb 20             	cmp    $0x20,%ebx
  8021d4:	75 ec                	jne    8021c2 <close_all+0xc>
}
  8021d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021d9:	c9                   	leave  
  8021da:	c3                   	ret    

008021db <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8021db:	55                   	push   %ebp
  8021dc:	89 e5                	mov    %esp,%ebp
  8021de:	57                   	push   %edi
  8021df:	56                   	push   %esi
  8021e0:	53                   	push   %ebx
  8021e1:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8021e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8021e7:	50                   	push   %eax
  8021e8:	ff 75 08             	pushl  0x8(%ebp)
  8021eb:	e8 6c fe ff ff       	call   80205c <fd_lookup>
  8021f0:	89 c3                	mov    %eax,%ebx
  8021f2:	83 c4 10             	add    $0x10,%esp
  8021f5:	85 c0                	test   %eax,%eax
  8021f7:	0f 88 81 00 00 00    	js     80227e <dup+0xa3>
		return r;
	close(newfdnum);
  8021fd:	83 ec 0c             	sub    $0xc,%esp
  802200:	ff 75 0c             	pushl  0xc(%ebp)
  802203:	e8 81 ff ff ff       	call   802189 <close>

	newfd = INDEX2FD(newfdnum);
  802208:	8b 75 0c             	mov    0xc(%ebp),%esi
  80220b:	c1 e6 0c             	shl    $0xc,%esi
  80220e:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  802214:	83 c4 04             	add    $0x4,%esp
  802217:	ff 75 e4             	pushl  -0x1c(%ebp)
  80221a:	e8 d4 fd ff ff       	call   801ff3 <fd2data>
  80221f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  802221:	89 34 24             	mov    %esi,(%esp)
  802224:	e8 ca fd ff ff       	call   801ff3 <fd2data>
  802229:	83 c4 10             	add    $0x10,%esp
  80222c:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80222e:	89 d8                	mov    %ebx,%eax
  802230:	c1 e8 16             	shr    $0x16,%eax
  802233:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80223a:	a8 01                	test   $0x1,%al
  80223c:	74 11                	je     80224f <dup+0x74>
  80223e:	89 d8                	mov    %ebx,%eax
  802240:	c1 e8 0c             	shr    $0xc,%eax
  802243:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80224a:	f6 c2 01             	test   $0x1,%dl
  80224d:	75 39                	jne    802288 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80224f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802252:	89 d0                	mov    %edx,%eax
  802254:	c1 e8 0c             	shr    $0xc,%eax
  802257:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80225e:	83 ec 0c             	sub    $0xc,%esp
  802261:	25 07 0e 00 00       	and    $0xe07,%eax
  802266:	50                   	push   %eax
  802267:	56                   	push   %esi
  802268:	6a 00                	push   $0x0
  80226a:	52                   	push   %edx
  80226b:	6a 00                	push   $0x0
  80226d:	e8 7d f5 ff ff       	call   8017ef <sys_page_map>
  802272:	89 c3                	mov    %eax,%ebx
  802274:	83 c4 20             	add    $0x20,%esp
  802277:	85 c0                	test   %eax,%eax
  802279:	78 31                	js     8022ac <dup+0xd1>
		goto err;

	return newfdnum;
  80227b:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80227e:	89 d8                	mov    %ebx,%eax
  802280:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802283:	5b                   	pop    %ebx
  802284:	5e                   	pop    %esi
  802285:	5f                   	pop    %edi
  802286:	5d                   	pop    %ebp
  802287:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802288:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80228f:	83 ec 0c             	sub    $0xc,%esp
  802292:	25 07 0e 00 00       	and    $0xe07,%eax
  802297:	50                   	push   %eax
  802298:	57                   	push   %edi
  802299:	6a 00                	push   $0x0
  80229b:	53                   	push   %ebx
  80229c:	6a 00                	push   $0x0
  80229e:	e8 4c f5 ff ff       	call   8017ef <sys_page_map>
  8022a3:	89 c3                	mov    %eax,%ebx
  8022a5:	83 c4 20             	add    $0x20,%esp
  8022a8:	85 c0                	test   %eax,%eax
  8022aa:	79 a3                	jns    80224f <dup+0x74>
	sys_page_unmap(0, newfd);
  8022ac:	83 ec 08             	sub    $0x8,%esp
  8022af:	56                   	push   %esi
  8022b0:	6a 00                	push   $0x0
  8022b2:	e8 7a f5 ff ff       	call   801831 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8022b7:	83 c4 08             	add    $0x8,%esp
  8022ba:	57                   	push   %edi
  8022bb:	6a 00                	push   $0x0
  8022bd:	e8 6f f5 ff ff       	call   801831 <sys_page_unmap>
	return r;
  8022c2:	83 c4 10             	add    $0x10,%esp
  8022c5:	eb b7                	jmp    80227e <dup+0xa3>

008022c7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8022c7:	55                   	push   %ebp
  8022c8:	89 e5                	mov    %esp,%ebp
  8022ca:	53                   	push   %ebx
  8022cb:	83 ec 1c             	sub    $0x1c,%esp
  8022ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022d1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8022d4:	50                   	push   %eax
  8022d5:	53                   	push   %ebx
  8022d6:	e8 81 fd ff ff       	call   80205c <fd_lookup>
  8022db:	83 c4 10             	add    $0x10,%esp
  8022de:	85 c0                	test   %eax,%eax
  8022e0:	78 3f                	js     802321 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022e2:	83 ec 08             	sub    $0x8,%esp
  8022e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022e8:	50                   	push   %eax
  8022e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ec:	ff 30                	pushl  (%eax)
  8022ee:	e8 b9 fd ff ff       	call   8020ac <dev_lookup>
  8022f3:	83 c4 10             	add    $0x10,%esp
  8022f6:	85 c0                	test   %eax,%eax
  8022f8:	78 27                	js     802321 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8022fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022fd:	8b 42 08             	mov    0x8(%edx),%eax
  802300:	83 e0 03             	and    $0x3,%eax
  802303:	83 f8 01             	cmp    $0x1,%eax
  802306:	74 1e                	je     802326 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  802308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230b:	8b 40 08             	mov    0x8(%eax),%eax
  80230e:	85 c0                	test   %eax,%eax
  802310:	74 35                	je     802347 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  802312:	83 ec 04             	sub    $0x4,%esp
  802315:	ff 75 10             	pushl  0x10(%ebp)
  802318:	ff 75 0c             	pushl  0xc(%ebp)
  80231b:	52                   	push   %edx
  80231c:	ff d0                	call   *%eax
  80231e:	83 c4 10             	add    $0x10,%esp
}
  802321:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802324:	c9                   	leave  
  802325:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802326:	a1 24 54 80 00       	mov    0x805424,%eax
  80232b:	8b 40 48             	mov    0x48(%eax),%eax
  80232e:	83 ec 04             	sub    $0x4,%esp
  802331:	53                   	push   %ebx
  802332:	50                   	push   %eax
  802333:	68 35 3d 80 00       	push   $0x803d35
  802338:	e8 2e e8 ff ff       	call   800b6b <cprintf>
		return -E_INVAL;
  80233d:	83 c4 10             	add    $0x10,%esp
  802340:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802345:	eb da                	jmp    802321 <read+0x5a>
		return -E_NOT_SUPP;
  802347:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80234c:	eb d3                	jmp    802321 <read+0x5a>

0080234e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80234e:	55                   	push   %ebp
  80234f:	89 e5                	mov    %esp,%ebp
  802351:	57                   	push   %edi
  802352:	56                   	push   %esi
  802353:	53                   	push   %ebx
  802354:	83 ec 0c             	sub    $0xc,%esp
  802357:	8b 7d 08             	mov    0x8(%ebp),%edi
  80235a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80235d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802362:	39 f3                	cmp    %esi,%ebx
  802364:	73 23                	jae    802389 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802366:	83 ec 04             	sub    $0x4,%esp
  802369:	89 f0                	mov    %esi,%eax
  80236b:	29 d8                	sub    %ebx,%eax
  80236d:	50                   	push   %eax
  80236e:	89 d8                	mov    %ebx,%eax
  802370:	03 45 0c             	add    0xc(%ebp),%eax
  802373:	50                   	push   %eax
  802374:	57                   	push   %edi
  802375:	e8 4d ff ff ff       	call   8022c7 <read>
		if (m < 0)
  80237a:	83 c4 10             	add    $0x10,%esp
  80237d:	85 c0                	test   %eax,%eax
  80237f:	78 06                	js     802387 <readn+0x39>
			return m;
		if (m == 0)
  802381:	74 06                	je     802389 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  802383:	01 c3                	add    %eax,%ebx
  802385:	eb db                	jmp    802362 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802387:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  802389:	89 d8                	mov    %ebx,%eax
  80238b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80238e:	5b                   	pop    %ebx
  80238f:	5e                   	pop    %esi
  802390:	5f                   	pop    %edi
  802391:	5d                   	pop    %ebp
  802392:	c3                   	ret    

00802393 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802393:	55                   	push   %ebp
  802394:	89 e5                	mov    %esp,%ebp
  802396:	53                   	push   %ebx
  802397:	83 ec 1c             	sub    $0x1c,%esp
  80239a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80239d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8023a0:	50                   	push   %eax
  8023a1:	53                   	push   %ebx
  8023a2:	e8 b5 fc ff ff       	call   80205c <fd_lookup>
  8023a7:	83 c4 10             	add    $0x10,%esp
  8023aa:	85 c0                	test   %eax,%eax
  8023ac:	78 3a                	js     8023e8 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023ae:	83 ec 08             	sub    $0x8,%esp
  8023b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023b4:	50                   	push   %eax
  8023b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b8:	ff 30                	pushl  (%eax)
  8023ba:	e8 ed fc ff ff       	call   8020ac <dev_lookup>
  8023bf:	83 c4 10             	add    $0x10,%esp
  8023c2:	85 c0                	test   %eax,%eax
  8023c4:	78 22                	js     8023e8 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8023c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8023cd:	74 1e                	je     8023ed <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8023cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d2:	8b 52 0c             	mov    0xc(%edx),%edx
  8023d5:	85 d2                	test   %edx,%edx
  8023d7:	74 35                	je     80240e <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8023d9:	83 ec 04             	sub    $0x4,%esp
  8023dc:	ff 75 10             	pushl  0x10(%ebp)
  8023df:	ff 75 0c             	pushl  0xc(%ebp)
  8023e2:	50                   	push   %eax
  8023e3:	ff d2                	call   *%edx
  8023e5:	83 c4 10             	add    $0x10,%esp
}
  8023e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023eb:	c9                   	leave  
  8023ec:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8023ed:	a1 24 54 80 00       	mov    0x805424,%eax
  8023f2:	8b 40 48             	mov    0x48(%eax),%eax
  8023f5:	83 ec 04             	sub    $0x4,%esp
  8023f8:	53                   	push   %ebx
  8023f9:	50                   	push   %eax
  8023fa:	68 51 3d 80 00       	push   $0x803d51
  8023ff:	e8 67 e7 ff ff       	call   800b6b <cprintf>
		return -E_INVAL;
  802404:	83 c4 10             	add    $0x10,%esp
  802407:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80240c:	eb da                	jmp    8023e8 <write+0x55>
		return -E_NOT_SUPP;
  80240e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802413:	eb d3                	jmp    8023e8 <write+0x55>

00802415 <seek>:

int
seek(int fdnum, off_t offset)
{
  802415:	55                   	push   %ebp
  802416:	89 e5                	mov    %esp,%ebp
  802418:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80241b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80241e:	50                   	push   %eax
  80241f:	ff 75 08             	pushl  0x8(%ebp)
  802422:	e8 35 fc ff ff       	call   80205c <fd_lookup>
  802427:	83 c4 10             	add    $0x10,%esp
  80242a:	85 c0                	test   %eax,%eax
  80242c:	78 0e                	js     80243c <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80242e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802434:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802437:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80243c:	c9                   	leave  
  80243d:	c3                   	ret    

0080243e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80243e:	55                   	push   %ebp
  80243f:	89 e5                	mov    %esp,%ebp
  802441:	53                   	push   %ebx
  802442:	83 ec 1c             	sub    $0x1c,%esp
  802445:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802448:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80244b:	50                   	push   %eax
  80244c:	53                   	push   %ebx
  80244d:	e8 0a fc ff ff       	call   80205c <fd_lookup>
  802452:	83 c4 10             	add    $0x10,%esp
  802455:	85 c0                	test   %eax,%eax
  802457:	78 37                	js     802490 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802459:	83 ec 08             	sub    $0x8,%esp
  80245c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80245f:	50                   	push   %eax
  802460:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802463:	ff 30                	pushl  (%eax)
  802465:	e8 42 fc ff ff       	call   8020ac <dev_lookup>
  80246a:	83 c4 10             	add    $0x10,%esp
  80246d:	85 c0                	test   %eax,%eax
  80246f:	78 1f                	js     802490 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802471:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802474:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802478:	74 1b                	je     802495 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80247a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80247d:	8b 52 18             	mov    0x18(%edx),%edx
  802480:	85 d2                	test   %edx,%edx
  802482:	74 32                	je     8024b6 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  802484:	83 ec 08             	sub    $0x8,%esp
  802487:	ff 75 0c             	pushl  0xc(%ebp)
  80248a:	50                   	push   %eax
  80248b:	ff d2                	call   *%edx
  80248d:	83 c4 10             	add    $0x10,%esp
}
  802490:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802493:	c9                   	leave  
  802494:	c3                   	ret    
			thisenv->env_id, fdnum);
  802495:	a1 24 54 80 00       	mov    0x805424,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80249a:	8b 40 48             	mov    0x48(%eax),%eax
  80249d:	83 ec 04             	sub    $0x4,%esp
  8024a0:	53                   	push   %ebx
  8024a1:	50                   	push   %eax
  8024a2:	68 14 3d 80 00       	push   $0x803d14
  8024a7:	e8 bf e6 ff ff       	call   800b6b <cprintf>
		return -E_INVAL;
  8024ac:	83 c4 10             	add    $0x10,%esp
  8024af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024b4:	eb da                	jmp    802490 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8024b6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8024bb:	eb d3                	jmp    802490 <ftruncate+0x52>

008024bd <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8024bd:	55                   	push   %ebp
  8024be:	89 e5                	mov    %esp,%ebp
  8024c0:	53                   	push   %ebx
  8024c1:	83 ec 1c             	sub    $0x1c,%esp
  8024c4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024c7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8024ca:	50                   	push   %eax
  8024cb:	ff 75 08             	pushl  0x8(%ebp)
  8024ce:	e8 89 fb ff ff       	call   80205c <fd_lookup>
  8024d3:	83 c4 10             	add    $0x10,%esp
  8024d6:	85 c0                	test   %eax,%eax
  8024d8:	78 4b                	js     802525 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024da:	83 ec 08             	sub    $0x8,%esp
  8024dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024e0:	50                   	push   %eax
  8024e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e4:	ff 30                	pushl  (%eax)
  8024e6:	e8 c1 fb ff ff       	call   8020ac <dev_lookup>
  8024eb:	83 c4 10             	add    $0x10,%esp
  8024ee:	85 c0                	test   %eax,%eax
  8024f0:	78 33                	js     802525 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8024f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f5:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8024f9:	74 2f                	je     80252a <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8024fb:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8024fe:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  802505:	00 00 00 
	stat->st_isdir = 0;
  802508:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80250f:	00 00 00 
	stat->st_dev = dev;
  802512:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802518:	83 ec 08             	sub    $0x8,%esp
  80251b:	53                   	push   %ebx
  80251c:	ff 75 f0             	pushl  -0x10(%ebp)
  80251f:	ff 50 14             	call   *0x14(%eax)
  802522:	83 c4 10             	add    $0x10,%esp
}
  802525:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802528:	c9                   	leave  
  802529:	c3                   	ret    
		return -E_NOT_SUPP;
  80252a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80252f:	eb f4                	jmp    802525 <fstat+0x68>

00802531 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802531:	55                   	push   %ebp
  802532:	89 e5                	mov    %esp,%ebp
  802534:	56                   	push   %esi
  802535:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802536:	83 ec 08             	sub    $0x8,%esp
  802539:	6a 00                	push   $0x0
  80253b:	ff 75 08             	pushl  0x8(%ebp)
  80253e:	e8 bb 01 00 00       	call   8026fe <open>
  802543:	89 c3                	mov    %eax,%ebx
  802545:	83 c4 10             	add    $0x10,%esp
  802548:	85 c0                	test   %eax,%eax
  80254a:	78 1b                	js     802567 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80254c:	83 ec 08             	sub    $0x8,%esp
  80254f:	ff 75 0c             	pushl  0xc(%ebp)
  802552:	50                   	push   %eax
  802553:	e8 65 ff ff ff       	call   8024bd <fstat>
  802558:	89 c6                	mov    %eax,%esi
	close(fd);
  80255a:	89 1c 24             	mov    %ebx,(%esp)
  80255d:	e8 27 fc ff ff       	call   802189 <close>
	return r;
  802562:	83 c4 10             	add    $0x10,%esp
  802565:	89 f3                	mov    %esi,%ebx
}
  802567:	89 d8                	mov    %ebx,%eax
  802569:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80256c:	5b                   	pop    %ebx
  80256d:	5e                   	pop    %esi
  80256e:	5d                   	pop    %ebp
  80256f:	c3                   	ret    

00802570 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802570:	55                   	push   %ebp
  802571:	89 e5                	mov    %esp,%ebp
  802573:	56                   	push   %esi
  802574:	53                   	push   %ebx
  802575:	89 c6                	mov    %eax,%esi
  802577:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  802579:	83 3d 20 54 80 00 00 	cmpl   $0x0,0x805420
  802580:	74 27                	je     8025a9 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802582:	6a 07                	push   $0x7
  802584:	68 00 60 80 00       	push   $0x806000
  802589:	56                   	push   %esi
  80258a:	ff 35 20 54 80 00    	pushl  0x805420
  802590:	e8 1c 0d 00 00       	call   8032b1 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  802595:	83 c4 0c             	add    $0xc,%esp
  802598:	6a 00                	push   $0x0
  80259a:	53                   	push   %ebx
  80259b:	6a 00                	push   $0x0
  80259d:	e8 a6 0c 00 00       	call   803248 <ipc_recv>
}
  8025a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025a5:	5b                   	pop    %ebx
  8025a6:	5e                   	pop    %esi
  8025a7:	5d                   	pop    %ebp
  8025a8:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8025a9:	83 ec 0c             	sub    $0xc,%esp
  8025ac:	6a 01                	push   $0x1
  8025ae:	e8 56 0d 00 00       	call   803309 <ipc_find_env>
  8025b3:	a3 20 54 80 00       	mov    %eax,0x805420
  8025b8:	83 c4 10             	add    $0x10,%esp
  8025bb:	eb c5                	jmp    802582 <fsipc+0x12>

008025bd <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8025bd:	55                   	push   %ebp
  8025be:	89 e5                	mov    %esp,%ebp
  8025c0:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8025c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c9:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  8025ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025d1:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8025d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8025db:	b8 02 00 00 00       	mov    $0x2,%eax
  8025e0:	e8 8b ff ff ff       	call   802570 <fsipc>
}
  8025e5:	c9                   	leave  
  8025e6:	c3                   	ret    

008025e7 <devfile_flush>:
{
  8025e7:	55                   	push   %ebp
  8025e8:	89 e5                	mov    %esp,%ebp
  8025ea:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8025ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f3:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8025f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8025fd:	b8 06 00 00 00       	mov    $0x6,%eax
  802602:	e8 69 ff ff ff       	call   802570 <fsipc>
}
  802607:	c9                   	leave  
  802608:	c3                   	ret    

00802609 <devfile_stat>:
{
  802609:	55                   	push   %ebp
  80260a:	89 e5                	mov    %esp,%ebp
  80260c:	53                   	push   %ebx
  80260d:	83 ec 04             	sub    $0x4,%esp
  802610:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802613:	8b 45 08             	mov    0x8(%ebp),%eax
  802616:	8b 40 0c             	mov    0xc(%eax),%eax
  802619:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80261e:	ba 00 00 00 00       	mov    $0x0,%edx
  802623:	b8 05 00 00 00       	mov    $0x5,%eax
  802628:	e8 43 ff ff ff       	call   802570 <fsipc>
  80262d:	85 c0                	test   %eax,%eax
  80262f:	78 2c                	js     80265d <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802631:	83 ec 08             	sub    $0x8,%esp
  802634:	68 00 60 80 00       	push   $0x806000
  802639:	53                   	push   %ebx
  80263a:	e8 7b ed ff ff       	call   8013ba <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80263f:	a1 80 60 80 00       	mov    0x806080,%eax
  802644:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80264a:	a1 84 60 80 00       	mov    0x806084,%eax
  80264f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  802655:	83 c4 10             	add    $0x10,%esp
  802658:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80265d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802660:	c9                   	leave  
  802661:	c3                   	ret    

00802662 <devfile_write>:
{
  802662:	55                   	push   %ebp
  802663:	89 e5                	mov    %esp,%ebp
  802665:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  802668:	68 80 3d 80 00       	push   $0x803d80
  80266d:	68 90 00 00 00       	push   $0x90
  802672:	68 9e 3d 80 00       	push   $0x803d9e
  802677:	e8 f9 e3 ff ff       	call   800a75 <_panic>

0080267c <devfile_read>:
{
  80267c:	55                   	push   %ebp
  80267d:	89 e5                	mov    %esp,%ebp
  80267f:	56                   	push   %esi
  802680:	53                   	push   %ebx
  802681:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802684:	8b 45 08             	mov    0x8(%ebp),%eax
  802687:	8b 40 0c             	mov    0xc(%eax),%eax
  80268a:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  80268f:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802695:	ba 00 00 00 00       	mov    $0x0,%edx
  80269a:	b8 03 00 00 00       	mov    $0x3,%eax
  80269f:	e8 cc fe ff ff       	call   802570 <fsipc>
  8026a4:	89 c3                	mov    %eax,%ebx
  8026a6:	85 c0                	test   %eax,%eax
  8026a8:	78 1f                	js     8026c9 <devfile_read+0x4d>
	assert(r <= n);
  8026aa:	39 f0                	cmp    %esi,%eax
  8026ac:	77 24                	ja     8026d2 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8026ae:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8026b3:	7f 33                	jg     8026e8 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8026b5:	83 ec 04             	sub    $0x4,%esp
  8026b8:	50                   	push   %eax
  8026b9:	68 00 60 80 00       	push   $0x806000
  8026be:	ff 75 0c             	pushl  0xc(%ebp)
  8026c1:	e8 82 ee ff ff       	call   801548 <memmove>
	return r;
  8026c6:	83 c4 10             	add    $0x10,%esp
}
  8026c9:	89 d8                	mov    %ebx,%eax
  8026cb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026ce:	5b                   	pop    %ebx
  8026cf:	5e                   	pop    %esi
  8026d0:	5d                   	pop    %ebp
  8026d1:	c3                   	ret    
	assert(r <= n);
  8026d2:	68 a9 3d 80 00       	push   $0x803da9
  8026d7:	68 38 37 80 00       	push   $0x803738
  8026dc:	6a 7c                	push   $0x7c
  8026de:	68 9e 3d 80 00       	push   $0x803d9e
  8026e3:	e8 8d e3 ff ff       	call   800a75 <_panic>
	assert(r <= PGSIZE);
  8026e8:	68 b0 3d 80 00       	push   $0x803db0
  8026ed:	68 38 37 80 00       	push   $0x803738
  8026f2:	6a 7d                	push   $0x7d
  8026f4:	68 9e 3d 80 00       	push   $0x803d9e
  8026f9:	e8 77 e3 ff ff       	call   800a75 <_panic>

008026fe <open>:
{
  8026fe:	55                   	push   %ebp
  8026ff:	89 e5                	mov    %esp,%ebp
  802701:	56                   	push   %esi
  802702:	53                   	push   %ebx
  802703:	83 ec 1c             	sub    $0x1c,%esp
  802706:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  802709:	56                   	push   %esi
  80270a:	e8 72 ec ff ff       	call   801381 <strlen>
  80270f:	83 c4 10             	add    $0x10,%esp
  802712:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802717:	7f 6c                	jg     802785 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  802719:	83 ec 0c             	sub    $0xc,%esp
  80271c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80271f:	50                   	push   %eax
  802720:	e8 e5 f8 ff ff       	call   80200a <fd_alloc>
  802725:	89 c3                	mov    %eax,%ebx
  802727:	83 c4 10             	add    $0x10,%esp
  80272a:	85 c0                	test   %eax,%eax
  80272c:	78 3c                	js     80276a <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80272e:	83 ec 08             	sub    $0x8,%esp
  802731:	56                   	push   %esi
  802732:	68 00 60 80 00       	push   $0x806000
  802737:	e8 7e ec ff ff       	call   8013ba <strcpy>
	fsipcbuf.open.req_omode = mode;
  80273c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80273f:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802744:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802747:	b8 01 00 00 00       	mov    $0x1,%eax
  80274c:	e8 1f fe ff ff       	call   802570 <fsipc>
  802751:	89 c3                	mov    %eax,%ebx
  802753:	83 c4 10             	add    $0x10,%esp
  802756:	85 c0                	test   %eax,%eax
  802758:	78 19                	js     802773 <open+0x75>
	return fd2num(fd);
  80275a:	83 ec 0c             	sub    $0xc,%esp
  80275d:	ff 75 f4             	pushl  -0xc(%ebp)
  802760:	e8 7e f8 ff ff       	call   801fe3 <fd2num>
  802765:	89 c3                	mov    %eax,%ebx
  802767:	83 c4 10             	add    $0x10,%esp
}
  80276a:	89 d8                	mov    %ebx,%eax
  80276c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80276f:	5b                   	pop    %ebx
  802770:	5e                   	pop    %esi
  802771:	5d                   	pop    %ebp
  802772:	c3                   	ret    
		fd_close(fd, 0);
  802773:	83 ec 08             	sub    $0x8,%esp
  802776:	6a 00                	push   $0x0
  802778:	ff 75 f4             	pushl  -0xc(%ebp)
  80277b:	e8 82 f9 ff ff       	call   802102 <fd_close>
		return r;
  802780:	83 c4 10             	add    $0x10,%esp
  802783:	eb e5                	jmp    80276a <open+0x6c>
		return -E_BAD_PATH;
  802785:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80278a:	eb de                	jmp    80276a <open+0x6c>

0080278c <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80278c:	55                   	push   %ebp
  80278d:	89 e5                	mov    %esp,%ebp
  80278f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802792:	ba 00 00 00 00       	mov    $0x0,%edx
  802797:	b8 08 00 00 00       	mov    $0x8,%eax
  80279c:	e8 cf fd ff ff       	call   802570 <fsipc>
}
  8027a1:	c9                   	leave  
  8027a2:	c3                   	ret    

008027a3 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  8027a3:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8027a7:	7f 01                	jg     8027aa <writebuf+0x7>
  8027a9:	c3                   	ret    
{
  8027aa:	55                   	push   %ebp
  8027ab:	89 e5                	mov    %esp,%ebp
  8027ad:	53                   	push   %ebx
  8027ae:	83 ec 08             	sub    $0x8,%esp
  8027b1:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  8027b3:	ff 70 04             	pushl  0x4(%eax)
  8027b6:	8d 40 10             	lea    0x10(%eax),%eax
  8027b9:	50                   	push   %eax
  8027ba:	ff 33                	pushl  (%ebx)
  8027bc:	e8 d2 fb ff ff       	call   802393 <write>
		if (result > 0)
  8027c1:	83 c4 10             	add    $0x10,%esp
  8027c4:	85 c0                	test   %eax,%eax
  8027c6:	7e 03                	jle    8027cb <writebuf+0x28>
			b->result += result;
  8027c8:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8027cb:	39 43 04             	cmp    %eax,0x4(%ebx)
  8027ce:	74 0d                	je     8027dd <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  8027d0:	85 c0                	test   %eax,%eax
  8027d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8027d7:	0f 4f c2             	cmovg  %edx,%eax
  8027da:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8027dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027e0:	c9                   	leave  
  8027e1:	c3                   	ret    

008027e2 <putch>:

static void
putch(int ch, void *thunk)
{
  8027e2:	55                   	push   %ebp
  8027e3:	89 e5                	mov    %esp,%ebp
  8027e5:	53                   	push   %ebx
  8027e6:	83 ec 04             	sub    $0x4,%esp
  8027e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8027ec:	8b 53 04             	mov    0x4(%ebx),%edx
  8027ef:	8d 42 01             	lea    0x1(%edx),%eax
  8027f2:	89 43 04             	mov    %eax,0x4(%ebx)
  8027f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8027f8:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8027fc:	3d 00 01 00 00       	cmp    $0x100,%eax
  802801:	74 06                	je     802809 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  802803:	83 c4 04             	add    $0x4,%esp
  802806:	5b                   	pop    %ebx
  802807:	5d                   	pop    %ebp
  802808:	c3                   	ret    
		writebuf(b);
  802809:	89 d8                	mov    %ebx,%eax
  80280b:	e8 93 ff ff ff       	call   8027a3 <writebuf>
		b->idx = 0;
  802810:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  802817:	eb ea                	jmp    802803 <putch+0x21>

00802819 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802819:	55                   	push   %ebp
  80281a:	89 e5                	mov    %esp,%ebp
  80281c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  802822:	8b 45 08             	mov    0x8(%ebp),%eax
  802825:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  80282b:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  802832:	00 00 00 
	b.result = 0;
  802835:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80283c:	00 00 00 
	b.error = 1;
  80283f:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  802846:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802849:	ff 75 10             	pushl  0x10(%ebp)
  80284c:	ff 75 0c             	pushl  0xc(%ebp)
  80284f:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  802855:	50                   	push   %eax
  802856:	68 e2 27 80 00       	push   $0x8027e2
  80285b:	e8 38 e4 ff ff       	call   800c98 <vprintfmt>
	if (b.idx > 0)
  802860:	83 c4 10             	add    $0x10,%esp
  802863:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  80286a:	7f 11                	jg     80287d <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  80286c:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  802872:	85 c0                	test   %eax,%eax
  802874:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  80287b:	c9                   	leave  
  80287c:	c3                   	ret    
		writebuf(&b);
  80287d:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  802883:	e8 1b ff ff ff       	call   8027a3 <writebuf>
  802888:	eb e2                	jmp    80286c <vfprintf+0x53>

0080288a <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  80288a:	55                   	push   %ebp
  80288b:	89 e5                	mov    %esp,%ebp
  80288d:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802890:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  802893:	50                   	push   %eax
  802894:	ff 75 0c             	pushl  0xc(%ebp)
  802897:	ff 75 08             	pushl  0x8(%ebp)
  80289a:	e8 7a ff ff ff       	call   802819 <vfprintf>
	va_end(ap);

	return cnt;
}
  80289f:	c9                   	leave  
  8028a0:	c3                   	ret    

008028a1 <printf>:

int
printf(const char *fmt, ...)
{
  8028a1:	55                   	push   %ebp
  8028a2:	89 e5                	mov    %esp,%ebp
  8028a4:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8028a7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  8028aa:	50                   	push   %eax
  8028ab:	ff 75 08             	pushl  0x8(%ebp)
  8028ae:	6a 01                	push   $0x1
  8028b0:	e8 64 ff ff ff       	call   802819 <vfprintf>
	va_end(ap);

	return cnt;
}
  8028b5:	c9                   	leave  
  8028b6:	c3                   	ret    

008028b7 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8028b7:	55                   	push   %ebp
  8028b8:	89 e5                	mov    %esp,%ebp
  8028ba:	57                   	push   %edi
  8028bb:	56                   	push   %esi
  8028bc:	53                   	push   %ebx
  8028bd:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8028c3:	6a 00                	push   $0x0
  8028c5:	ff 75 08             	pushl  0x8(%ebp)
  8028c8:	e8 31 fe ff ff       	call   8026fe <open>
  8028cd:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8028d3:	83 c4 10             	add    $0x10,%esp
  8028d6:	85 c0                	test   %eax,%eax
  8028d8:	0f 88 71 04 00 00    	js     802d4f <spawn+0x498>
  8028de:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8028e0:	83 ec 04             	sub    $0x4,%esp
  8028e3:	68 00 02 00 00       	push   $0x200
  8028e8:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8028ee:	50                   	push   %eax
  8028ef:	52                   	push   %edx
  8028f0:	e8 59 fa ff ff       	call   80234e <readn>
  8028f5:	83 c4 10             	add    $0x10,%esp
  8028f8:	3d 00 02 00 00       	cmp    $0x200,%eax
  8028fd:	75 5f                	jne    80295e <spawn+0xa7>
	    || elf->e_magic != ELF_MAGIC) {
  8028ff:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  802906:	45 4c 46 
  802909:	75 53                	jne    80295e <spawn+0xa7>
  80290b:	b8 07 00 00 00       	mov    $0x7,%eax
  802910:	cd 30                	int    $0x30
  802912:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  802918:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  80291e:	85 c0                	test   %eax,%eax
  802920:	0f 88 1d 04 00 00    	js     802d43 <spawn+0x48c>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802926:	25 ff 03 00 00       	and    $0x3ff,%eax
  80292b:	89 c6                	mov    %eax,%esi
  80292d:	c1 e6 07             	shl    $0x7,%esi
  802930:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  802936:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  80293c:	b9 11 00 00 00       	mov    $0x11,%ecx
  802941:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  802943:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802949:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  80294f:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  802954:	be 00 00 00 00       	mov    $0x0,%esi
  802959:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80295c:	eb 4b                	jmp    8029a9 <spawn+0xf2>
		close(fd);
  80295e:	83 ec 0c             	sub    $0xc,%esp
  802961:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802967:	e8 1d f8 ff ff       	call   802189 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80296c:	83 c4 0c             	add    $0xc,%esp
  80296f:	68 7f 45 4c 46       	push   $0x464c457f
  802974:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  80297a:	68 bc 3d 80 00       	push   $0x803dbc
  80297f:	e8 e7 e1 ff ff       	call   800b6b <cprintf>
		return -E_NOT_EXEC;
  802984:	83 c4 10             	add    $0x10,%esp
  802987:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  80298e:	ff ff ff 
  802991:	e9 b9 03 00 00       	jmp    802d4f <spawn+0x498>
		string_size += strlen(argv[argc]) + 1;
  802996:	83 ec 0c             	sub    $0xc,%esp
  802999:	50                   	push   %eax
  80299a:	e8 e2 e9 ff ff       	call   801381 <strlen>
  80299f:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  8029a3:	83 c3 01             	add    $0x1,%ebx
  8029a6:	83 c4 10             	add    $0x10,%esp
  8029a9:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  8029b0:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  8029b3:	85 c0                	test   %eax,%eax
  8029b5:	75 df                	jne    802996 <spawn+0xdf>
  8029b7:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  8029bd:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8029c3:	bf 00 10 40 00       	mov    $0x401000,%edi
  8029c8:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  8029ca:	89 fa                	mov    %edi,%edx
  8029cc:	83 e2 fc             	and    $0xfffffffc,%edx
  8029cf:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  8029d6:	29 c2                	sub    %eax,%edx
  8029d8:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8029de:	8d 42 f8             	lea    -0x8(%edx),%eax
  8029e1:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8029e6:	0f 86 86 03 00 00    	jbe    802d72 <spawn+0x4bb>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8029ec:	83 ec 04             	sub    $0x4,%esp
  8029ef:	6a 07                	push   $0x7
  8029f1:	68 00 00 40 00       	push   $0x400000
  8029f6:	6a 00                	push   $0x0
  8029f8:	e8 af ed ff ff       	call   8017ac <sys_page_alloc>
  8029fd:	83 c4 10             	add    $0x10,%esp
  802a00:	85 c0                	test   %eax,%eax
  802a02:	0f 88 6f 03 00 00    	js     802d77 <spawn+0x4c0>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802a08:	be 00 00 00 00       	mov    $0x0,%esi
  802a0d:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  802a13:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802a16:	eb 30                	jmp    802a48 <spawn+0x191>
		argv_store[i] = UTEMP2USTACK(string_store);
  802a18:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802a1e:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  802a24:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  802a27:	83 ec 08             	sub    $0x8,%esp
  802a2a:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802a2d:	57                   	push   %edi
  802a2e:	e8 87 e9 ff ff       	call   8013ba <strcpy>
		string_store += strlen(argv[i]) + 1;
  802a33:	83 c4 04             	add    $0x4,%esp
  802a36:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802a39:	e8 43 e9 ff ff       	call   801381 <strlen>
  802a3e:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  802a42:	83 c6 01             	add    $0x1,%esi
  802a45:	83 c4 10             	add    $0x10,%esp
  802a48:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  802a4e:	7f c8                	jg     802a18 <spawn+0x161>
	}
	argv_store[argc] = 0;
  802a50:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802a56:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  802a5c:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  802a63:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  802a69:	0f 85 86 00 00 00    	jne    802af5 <spawn+0x23e>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802a6f:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  802a75:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  802a7b:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  802a7e:	89 c8                	mov    %ecx,%eax
  802a80:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  802a86:	89 48 f8             	mov    %ecx,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802a89:	2d 08 30 80 11       	sub    $0x11803008,%eax
  802a8e:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802a94:	83 ec 0c             	sub    $0xc,%esp
  802a97:	6a 07                	push   $0x7
  802a99:	68 00 d0 bf ee       	push   $0xeebfd000
  802a9e:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802aa4:	68 00 00 40 00       	push   $0x400000
  802aa9:	6a 00                	push   $0x0
  802aab:	e8 3f ed ff ff       	call   8017ef <sys_page_map>
  802ab0:	89 c3                	mov    %eax,%ebx
  802ab2:	83 c4 20             	add    $0x20,%esp
  802ab5:	85 c0                	test   %eax,%eax
  802ab7:	0f 88 c2 02 00 00    	js     802d7f <spawn+0x4c8>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802abd:	83 ec 08             	sub    $0x8,%esp
  802ac0:	68 00 00 40 00       	push   $0x400000
  802ac5:	6a 00                	push   $0x0
  802ac7:	e8 65 ed ff ff       	call   801831 <sys_page_unmap>
  802acc:	89 c3                	mov    %eax,%ebx
  802ace:	83 c4 10             	add    $0x10,%esp
  802ad1:	85 c0                	test   %eax,%eax
  802ad3:	0f 88 a6 02 00 00    	js     802d7f <spawn+0x4c8>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802ad9:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  802adf:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802ae6:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  802aed:	00 00 00 
  802af0:	e9 4f 01 00 00       	jmp    802c44 <spawn+0x38d>
	assert(string_store == (char*)UTEMP + PGSIZE);
  802af5:	68 30 3e 80 00       	push   $0x803e30
  802afa:	68 38 37 80 00       	push   $0x803738
  802aff:	68 f2 00 00 00       	push   $0xf2
  802b04:	68 d6 3d 80 00       	push   $0x803dd6
  802b09:	e8 67 df ff ff       	call   800a75 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802b0e:	83 ec 04             	sub    $0x4,%esp
  802b11:	6a 07                	push   $0x7
  802b13:	68 00 00 40 00       	push   $0x400000
  802b18:	6a 00                	push   $0x0
  802b1a:	e8 8d ec ff ff       	call   8017ac <sys_page_alloc>
  802b1f:	83 c4 10             	add    $0x10,%esp
  802b22:	85 c0                	test   %eax,%eax
  802b24:	0f 88 33 02 00 00    	js     802d5d <spawn+0x4a6>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802b2a:	83 ec 08             	sub    $0x8,%esp
  802b2d:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802b33:	01 f0                	add    %esi,%eax
  802b35:	50                   	push   %eax
  802b36:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802b3c:	e8 d4 f8 ff ff       	call   802415 <seek>
  802b41:	83 c4 10             	add    $0x10,%esp
  802b44:	85 c0                	test   %eax,%eax
  802b46:	0f 88 18 02 00 00    	js     802d64 <spawn+0x4ad>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802b4c:	83 ec 04             	sub    $0x4,%esp
  802b4f:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802b55:	29 f0                	sub    %esi,%eax
  802b57:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802b5c:	ba 00 10 00 00       	mov    $0x1000,%edx
  802b61:	0f 47 c2             	cmova  %edx,%eax
  802b64:	50                   	push   %eax
  802b65:	68 00 00 40 00       	push   $0x400000
  802b6a:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802b70:	e8 d9 f7 ff ff       	call   80234e <readn>
  802b75:	83 c4 10             	add    $0x10,%esp
  802b78:	85 c0                	test   %eax,%eax
  802b7a:	0f 88 eb 01 00 00    	js     802d6b <spawn+0x4b4>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802b80:	83 ec 0c             	sub    $0xc,%esp
  802b83:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802b89:	53                   	push   %ebx
  802b8a:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802b90:	68 00 00 40 00       	push   $0x400000
  802b95:	6a 00                	push   $0x0
  802b97:	e8 53 ec ff ff       	call   8017ef <sys_page_map>
  802b9c:	83 c4 20             	add    $0x20,%esp
  802b9f:	85 c0                	test   %eax,%eax
  802ba1:	78 7c                	js     802c1f <spawn+0x368>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  802ba3:	83 ec 08             	sub    $0x8,%esp
  802ba6:	68 00 00 40 00       	push   $0x400000
  802bab:	6a 00                	push   $0x0
  802bad:	e8 7f ec ff ff       	call   801831 <sys_page_unmap>
  802bb2:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  802bb5:	81 c7 00 10 00 00    	add    $0x1000,%edi
  802bbb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802bc1:	89 fe                	mov    %edi,%esi
  802bc3:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  802bc9:	76 69                	jbe    802c34 <spawn+0x37d>
		if (i >= filesz) {
  802bcb:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  802bd1:	0f 87 37 ff ff ff    	ja     802b0e <spawn+0x257>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802bd7:	83 ec 04             	sub    $0x4,%esp
  802bda:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802be0:	53                   	push   %ebx
  802be1:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802be7:	e8 c0 eb ff ff       	call   8017ac <sys_page_alloc>
  802bec:	83 c4 10             	add    $0x10,%esp
  802bef:	85 c0                	test   %eax,%eax
  802bf1:	79 c2                	jns    802bb5 <spawn+0x2fe>
  802bf3:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  802bf5:	83 ec 0c             	sub    $0xc,%esp
  802bf8:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802bfe:	e8 2a eb ff ff       	call   80172d <sys_env_destroy>
	close(fd);
  802c03:	83 c4 04             	add    $0x4,%esp
  802c06:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802c0c:	e8 78 f5 ff ff       	call   802189 <close>
	return r;
  802c11:	83 c4 10             	add    $0x10,%esp
  802c14:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  802c1a:	e9 30 01 00 00       	jmp    802d4f <spawn+0x498>
				panic("spawn: sys_page_map data: %e", r);
  802c1f:	50                   	push   %eax
  802c20:	68 e2 3d 80 00       	push   $0x803de2
  802c25:	68 25 01 00 00       	push   $0x125
  802c2a:	68 d6 3d 80 00       	push   $0x803dd6
  802c2f:	e8 41 de ff ff       	call   800a75 <_panic>
  802c34:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802c3a:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  802c41:	83 c6 20             	add    $0x20,%esi
  802c44:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802c4b:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  802c51:	7e 6d                	jle    802cc0 <spawn+0x409>
		if (ph->p_type != ELF_PROG_LOAD)
  802c53:	83 3e 01             	cmpl   $0x1,(%esi)
  802c56:	75 e2                	jne    802c3a <spawn+0x383>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802c58:	8b 46 18             	mov    0x18(%esi),%eax
  802c5b:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  802c5e:	83 f8 01             	cmp    $0x1,%eax
  802c61:	19 c0                	sbb    %eax,%eax
  802c63:	83 e0 fe             	and    $0xfffffffe,%eax
  802c66:	83 c0 07             	add    $0x7,%eax
  802c69:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802c6f:	8b 4e 04             	mov    0x4(%esi),%ecx
  802c72:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  802c78:	8b 56 10             	mov    0x10(%esi),%edx
  802c7b:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  802c81:	8b 7e 14             	mov    0x14(%esi),%edi
  802c84:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  802c8a:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  802c8d:	89 d8                	mov    %ebx,%eax
  802c8f:	25 ff 0f 00 00       	and    $0xfff,%eax
  802c94:	74 1a                	je     802cb0 <spawn+0x3f9>
		va -= i;
  802c96:	29 c3                	sub    %eax,%ebx
		memsz += i;
  802c98:	01 c7                	add    %eax,%edi
  802c9a:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  802ca0:	01 c2                	add    %eax,%edx
  802ca2:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  802ca8:	29 c1                	sub    %eax,%ecx
  802caa:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  802cb0:	bf 00 00 00 00       	mov    $0x0,%edi
  802cb5:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  802cbb:	e9 01 ff ff ff       	jmp    802bc1 <spawn+0x30a>
	close(fd);
  802cc0:	83 ec 0c             	sub    $0xc,%esp
  802cc3:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802cc9:	e8 bb f4 ff ff       	call   802189 <close>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  802cce:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  802cd5:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802cd8:	83 c4 08             	add    $0x8,%esp
  802cdb:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802ce1:	50                   	push   %eax
  802ce2:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802ce8:	e8 c8 eb ff ff       	call   8018b5 <sys_env_set_trapframe>
  802ced:	83 c4 10             	add    $0x10,%esp
  802cf0:	85 c0                	test   %eax,%eax
  802cf2:	78 25                	js     802d19 <spawn+0x462>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802cf4:	83 ec 08             	sub    $0x8,%esp
  802cf7:	6a 02                	push   $0x2
  802cf9:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802cff:	e8 6f eb ff ff       	call   801873 <sys_env_set_status>
  802d04:	83 c4 10             	add    $0x10,%esp
  802d07:	85 c0                	test   %eax,%eax
  802d09:	78 23                	js     802d2e <spawn+0x477>
	return child;
  802d0b:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802d11:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802d17:	eb 36                	jmp    802d4f <spawn+0x498>
		panic("sys_env_set_trapframe: %e", r);
  802d19:	50                   	push   %eax
  802d1a:	68 ff 3d 80 00       	push   $0x803dff
  802d1f:	68 86 00 00 00       	push   $0x86
  802d24:	68 d6 3d 80 00       	push   $0x803dd6
  802d29:	e8 47 dd ff ff       	call   800a75 <_panic>
		panic("sys_env_set_status: %e", r);
  802d2e:	50                   	push   %eax
  802d2f:	68 19 3e 80 00       	push   $0x803e19
  802d34:	68 89 00 00 00       	push   $0x89
  802d39:	68 d6 3d 80 00       	push   $0x803dd6
  802d3e:	e8 32 dd ff ff       	call   800a75 <_panic>
		return r;
  802d43:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802d49:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  802d4f:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802d55:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d58:	5b                   	pop    %ebx
  802d59:	5e                   	pop    %esi
  802d5a:	5f                   	pop    %edi
  802d5b:	5d                   	pop    %ebp
  802d5c:	c3                   	ret    
  802d5d:	89 c7                	mov    %eax,%edi
  802d5f:	e9 91 fe ff ff       	jmp    802bf5 <spawn+0x33e>
  802d64:	89 c7                	mov    %eax,%edi
  802d66:	e9 8a fe ff ff       	jmp    802bf5 <spawn+0x33e>
  802d6b:	89 c7                	mov    %eax,%edi
  802d6d:	e9 83 fe ff ff       	jmp    802bf5 <spawn+0x33e>
		return -E_NO_MEM;
  802d72:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802d77:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802d7d:	eb d0                	jmp    802d4f <spawn+0x498>
	sys_page_unmap(0, UTEMP);
  802d7f:	83 ec 08             	sub    $0x8,%esp
  802d82:	68 00 00 40 00       	push   $0x400000
  802d87:	6a 00                	push   $0x0
  802d89:	e8 a3 ea ff ff       	call   801831 <sys_page_unmap>
  802d8e:	83 c4 10             	add    $0x10,%esp
  802d91:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  802d97:	eb b6                	jmp    802d4f <spawn+0x498>

00802d99 <spawnl>:
{
  802d99:	55                   	push   %ebp
  802d9a:	89 e5                	mov    %esp,%ebp
  802d9c:	57                   	push   %edi
  802d9d:	56                   	push   %esi
  802d9e:	53                   	push   %ebx
  802d9f:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  802da2:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  802da5:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  802daa:	8d 4a 04             	lea    0x4(%edx),%ecx
  802dad:	83 3a 00             	cmpl   $0x0,(%edx)
  802db0:	74 07                	je     802db9 <spawnl+0x20>
		argc++;
  802db2:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  802db5:	89 ca                	mov    %ecx,%edx
  802db7:	eb f1                	jmp    802daa <spawnl+0x11>
	const char *argv[argc+2];
  802db9:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  802dc0:	83 e2 f0             	and    $0xfffffff0,%edx
  802dc3:	29 d4                	sub    %edx,%esp
  802dc5:	8d 54 24 03          	lea    0x3(%esp),%edx
  802dc9:	c1 ea 02             	shr    $0x2,%edx
  802dcc:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  802dd3:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802dd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802dd8:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  802ddf:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  802de6:	00 
	va_start(vl, arg0);
  802de7:	8d 4d 10             	lea    0x10(%ebp),%ecx
  802dea:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  802dec:	b8 00 00 00 00       	mov    $0x0,%eax
  802df1:	eb 0b                	jmp    802dfe <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  802df3:	83 c0 01             	add    $0x1,%eax
  802df6:	8b 39                	mov    (%ecx),%edi
  802df8:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  802dfb:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  802dfe:	39 d0                	cmp    %edx,%eax
  802e00:	75 f1                	jne    802df3 <spawnl+0x5a>
	return spawn(prog, argv);
  802e02:	83 ec 08             	sub    $0x8,%esp
  802e05:	56                   	push   %esi
  802e06:	ff 75 08             	pushl  0x8(%ebp)
  802e09:	e8 a9 fa ff ff       	call   8028b7 <spawn>
}
  802e0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802e11:	5b                   	pop    %ebx
  802e12:	5e                   	pop    %esi
  802e13:	5f                   	pop    %edi
  802e14:	5d                   	pop    %ebp
  802e15:	c3                   	ret    

00802e16 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802e16:	55                   	push   %ebp
  802e17:	89 e5                	mov    %esp,%ebp
  802e19:	56                   	push   %esi
  802e1a:	53                   	push   %ebx
  802e1b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802e1e:	83 ec 0c             	sub    $0xc,%esp
  802e21:	ff 75 08             	pushl  0x8(%ebp)
  802e24:	e8 ca f1 ff ff       	call   801ff3 <fd2data>
  802e29:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802e2b:	83 c4 08             	add    $0x8,%esp
  802e2e:	68 56 3e 80 00       	push   $0x803e56
  802e33:	53                   	push   %ebx
  802e34:	e8 81 e5 ff ff       	call   8013ba <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802e39:	8b 46 04             	mov    0x4(%esi),%eax
  802e3c:	2b 06                	sub    (%esi),%eax
  802e3e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802e44:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802e4b:	00 00 00 
	stat->st_dev = &devpipe;
  802e4e:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802e55:	40 80 00 
	return 0;
}
  802e58:	b8 00 00 00 00       	mov    $0x0,%eax
  802e5d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802e60:	5b                   	pop    %ebx
  802e61:	5e                   	pop    %esi
  802e62:	5d                   	pop    %ebp
  802e63:	c3                   	ret    

00802e64 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802e64:	55                   	push   %ebp
  802e65:	89 e5                	mov    %esp,%ebp
  802e67:	53                   	push   %ebx
  802e68:	83 ec 0c             	sub    $0xc,%esp
  802e6b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802e6e:	53                   	push   %ebx
  802e6f:	6a 00                	push   $0x0
  802e71:	e8 bb e9 ff ff       	call   801831 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802e76:	89 1c 24             	mov    %ebx,(%esp)
  802e79:	e8 75 f1 ff ff       	call   801ff3 <fd2data>
  802e7e:	83 c4 08             	add    $0x8,%esp
  802e81:	50                   	push   %eax
  802e82:	6a 00                	push   $0x0
  802e84:	e8 a8 e9 ff ff       	call   801831 <sys_page_unmap>
}
  802e89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e8c:	c9                   	leave  
  802e8d:	c3                   	ret    

00802e8e <_pipeisclosed>:
{
  802e8e:	55                   	push   %ebp
  802e8f:	89 e5                	mov    %esp,%ebp
  802e91:	57                   	push   %edi
  802e92:	56                   	push   %esi
  802e93:	53                   	push   %ebx
  802e94:	83 ec 1c             	sub    $0x1c,%esp
  802e97:	89 c7                	mov    %eax,%edi
  802e99:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802e9b:	a1 24 54 80 00       	mov    0x805424,%eax
  802ea0:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802ea3:	83 ec 0c             	sub    $0xc,%esp
  802ea6:	57                   	push   %edi
  802ea7:	e8 98 04 00 00       	call   803344 <pageref>
  802eac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802eaf:	89 34 24             	mov    %esi,(%esp)
  802eb2:	e8 8d 04 00 00       	call   803344 <pageref>
		nn = thisenv->env_runs;
  802eb7:	8b 15 24 54 80 00    	mov    0x805424,%edx
  802ebd:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802ec0:	83 c4 10             	add    $0x10,%esp
  802ec3:	39 cb                	cmp    %ecx,%ebx
  802ec5:	74 1b                	je     802ee2 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802ec7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802eca:	75 cf                	jne    802e9b <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802ecc:	8b 42 58             	mov    0x58(%edx),%eax
  802ecf:	6a 01                	push   $0x1
  802ed1:	50                   	push   %eax
  802ed2:	53                   	push   %ebx
  802ed3:	68 5d 3e 80 00       	push   $0x803e5d
  802ed8:	e8 8e dc ff ff       	call   800b6b <cprintf>
  802edd:	83 c4 10             	add    $0x10,%esp
  802ee0:	eb b9                	jmp    802e9b <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802ee2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802ee5:	0f 94 c0             	sete   %al
  802ee8:	0f b6 c0             	movzbl %al,%eax
}
  802eeb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802eee:	5b                   	pop    %ebx
  802eef:	5e                   	pop    %esi
  802ef0:	5f                   	pop    %edi
  802ef1:	5d                   	pop    %ebp
  802ef2:	c3                   	ret    

00802ef3 <devpipe_write>:
{
  802ef3:	55                   	push   %ebp
  802ef4:	89 e5                	mov    %esp,%ebp
  802ef6:	57                   	push   %edi
  802ef7:	56                   	push   %esi
  802ef8:	53                   	push   %ebx
  802ef9:	83 ec 28             	sub    $0x28,%esp
  802efc:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802eff:	56                   	push   %esi
  802f00:	e8 ee f0 ff ff       	call   801ff3 <fd2data>
  802f05:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802f07:	83 c4 10             	add    $0x10,%esp
  802f0a:	bf 00 00 00 00       	mov    $0x0,%edi
  802f0f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802f12:	74 4f                	je     802f63 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802f14:	8b 43 04             	mov    0x4(%ebx),%eax
  802f17:	8b 0b                	mov    (%ebx),%ecx
  802f19:	8d 51 20             	lea    0x20(%ecx),%edx
  802f1c:	39 d0                	cmp    %edx,%eax
  802f1e:	72 14                	jb     802f34 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802f20:	89 da                	mov    %ebx,%edx
  802f22:	89 f0                	mov    %esi,%eax
  802f24:	e8 65 ff ff ff       	call   802e8e <_pipeisclosed>
  802f29:	85 c0                	test   %eax,%eax
  802f2b:	75 3b                	jne    802f68 <devpipe_write+0x75>
			sys_yield();
  802f2d:	e8 5b e8 ff ff       	call   80178d <sys_yield>
  802f32:	eb e0                	jmp    802f14 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802f34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802f37:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802f3b:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802f3e:	89 c2                	mov    %eax,%edx
  802f40:	c1 fa 1f             	sar    $0x1f,%edx
  802f43:	89 d1                	mov    %edx,%ecx
  802f45:	c1 e9 1b             	shr    $0x1b,%ecx
  802f48:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802f4b:	83 e2 1f             	and    $0x1f,%edx
  802f4e:	29 ca                	sub    %ecx,%edx
  802f50:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802f54:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802f58:	83 c0 01             	add    $0x1,%eax
  802f5b:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802f5e:	83 c7 01             	add    $0x1,%edi
  802f61:	eb ac                	jmp    802f0f <devpipe_write+0x1c>
	return i;
  802f63:	8b 45 10             	mov    0x10(%ebp),%eax
  802f66:	eb 05                	jmp    802f6d <devpipe_write+0x7a>
				return 0;
  802f68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802f70:	5b                   	pop    %ebx
  802f71:	5e                   	pop    %esi
  802f72:	5f                   	pop    %edi
  802f73:	5d                   	pop    %ebp
  802f74:	c3                   	ret    

00802f75 <devpipe_read>:
{
  802f75:	55                   	push   %ebp
  802f76:	89 e5                	mov    %esp,%ebp
  802f78:	57                   	push   %edi
  802f79:	56                   	push   %esi
  802f7a:	53                   	push   %ebx
  802f7b:	83 ec 18             	sub    $0x18,%esp
  802f7e:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802f81:	57                   	push   %edi
  802f82:	e8 6c f0 ff ff       	call   801ff3 <fd2data>
  802f87:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802f89:	83 c4 10             	add    $0x10,%esp
  802f8c:	be 00 00 00 00       	mov    $0x0,%esi
  802f91:	3b 75 10             	cmp    0x10(%ebp),%esi
  802f94:	75 14                	jne    802faa <devpipe_read+0x35>
	return i;
  802f96:	8b 45 10             	mov    0x10(%ebp),%eax
  802f99:	eb 02                	jmp    802f9d <devpipe_read+0x28>
				return i;
  802f9b:	89 f0                	mov    %esi,%eax
}
  802f9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802fa0:	5b                   	pop    %ebx
  802fa1:	5e                   	pop    %esi
  802fa2:	5f                   	pop    %edi
  802fa3:	5d                   	pop    %ebp
  802fa4:	c3                   	ret    
			sys_yield();
  802fa5:	e8 e3 e7 ff ff       	call   80178d <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802faa:	8b 03                	mov    (%ebx),%eax
  802fac:	3b 43 04             	cmp    0x4(%ebx),%eax
  802faf:	75 18                	jne    802fc9 <devpipe_read+0x54>
			if (i > 0)
  802fb1:	85 f6                	test   %esi,%esi
  802fb3:	75 e6                	jne    802f9b <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802fb5:	89 da                	mov    %ebx,%edx
  802fb7:	89 f8                	mov    %edi,%eax
  802fb9:	e8 d0 fe ff ff       	call   802e8e <_pipeisclosed>
  802fbe:	85 c0                	test   %eax,%eax
  802fc0:	74 e3                	je     802fa5 <devpipe_read+0x30>
				return 0;
  802fc2:	b8 00 00 00 00       	mov    $0x0,%eax
  802fc7:	eb d4                	jmp    802f9d <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802fc9:	99                   	cltd   
  802fca:	c1 ea 1b             	shr    $0x1b,%edx
  802fcd:	01 d0                	add    %edx,%eax
  802fcf:	83 e0 1f             	and    $0x1f,%eax
  802fd2:	29 d0                	sub    %edx,%eax
  802fd4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802fd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802fdc:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802fdf:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802fe2:	83 c6 01             	add    $0x1,%esi
  802fe5:	eb aa                	jmp    802f91 <devpipe_read+0x1c>

00802fe7 <pipe>:
{
  802fe7:	55                   	push   %ebp
  802fe8:	89 e5                	mov    %esp,%ebp
  802fea:	56                   	push   %esi
  802feb:	53                   	push   %ebx
  802fec:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802fef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ff2:	50                   	push   %eax
  802ff3:	e8 12 f0 ff ff       	call   80200a <fd_alloc>
  802ff8:	89 c3                	mov    %eax,%ebx
  802ffa:	83 c4 10             	add    $0x10,%esp
  802ffd:	85 c0                	test   %eax,%eax
  802fff:	0f 88 23 01 00 00    	js     803128 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803005:	83 ec 04             	sub    $0x4,%esp
  803008:	68 07 04 00 00       	push   $0x407
  80300d:	ff 75 f4             	pushl  -0xc(%ebp)
  803010:	6a 00                	push   $0x0
  803012:	e8 95 e7 ff ff       	call   8017ac <sys_page_alloc>
  803017:	89 c3                	mov    %eax,%ebx
  803019:	83 c4 10             	add    $0x10,%esp
  80301c:	85 c0                	test   %eax,%eax
  80301e:	0f 88 04 01 00 00    	js     803128 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  803024:	83 ec 0c             	sub    $0xc,%esp
  803027:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80302a:	50                   	push   %eax
  80302b:	e8 da ef ff ff       	call   80200a <fd_alloc>
  803030:	89 c3                	mov    %eax,%ebx
  803032:	83 c4 10             	add    $0x10,%esp
  803035:	85 c0                	test   %eax,%eax
  803037:	0f 88 db 00 00 00    	js     803118 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80303d:	83 ec 04             	sub    $0x4,%esp
  803040:	68 07 04 00 00       	push   $0x407
  803045:	ff 75 f0             	pushl  -0x10(%ebp)
  803048:	6a 00                	push   $0x0
  80304a:	e8 5d e7 ff ff       	call   8017ac <sys_page_alloc>
  80304f:	89 c3                	mov    %eax,%ebx
  803051:	83 c4 10             	add    $0x10,%esp
  803054:	85 c0                	test   %eax,%eax
  803056:	0f 88 bc 00 00 00    	js     803118 <pipe+0x131>
	va = fd2data(fd0);
  80305c:	83 ec 0c             	sub    $0xc,%esp
  80305f:	ff 75 f4             	pushl  -0xc(%ebp)
  803062:	e8 8c ef ff ff       	call   801ff3 <fd2data>
  803067:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803069:	83 c4 0c             	add    $0xc,%esp
  80306c:	68 07 04 00 00       	push   $0x407
  803071:	50                   	push   %eax
  803072:	6a 00                	push   $0x0
  803074:	e8 33 e7 ff ff       	call   8017ac <sys_page_alloc>
  803079:	89 c3                	mov    %eax,%ebx
  80307b:	83 c4 10             	add    $0x10,%esp
  80307e:	85 c0                	test   %eax,%eax
  803080:	0f 88 82 00 00 00    	js     803108 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803086:	83 ec 0c             	sub    $0xc,%esp
  803089:	ff 75 f0             	pushl  -0x10(%ebp)
  80308c:	e8 62 ef ff ff       	call   801ff3 <fd2data>
  803091:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  803098:	50                   	push   %eax
  803099:	6a 00                	push   $0x0
  80309b:	56                   	push   %esi
  80309c:	6a 00                	push   $0x0
  80309e:	e8 4c e7 ff ff       	call   8017ef <sys_page_map>
  8030a3:	89 c3                	mov    %eax,%ebx
  8030a5:	83 c4 20             	add    $0x20,%esp
  8030a8:	85 c0                	test   %eax,%eax
  8030aa:	78 4e                	js     8030fa <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8030ac:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8030b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030b4:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8030b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030b9:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8030c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030c3:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8030c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c8:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8030cf:	83 ec 0c             	sub    $0xc,%esp
  8030d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8030d5:	e8 09 ef ff ff       	call   801fe3 <fd2num>
  8030da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8030dd:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8030df:	83 c4 04             	add    $0x4,%esp
  8030e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8030e5:	e8 f9 ee ff ff       	call   801fe3 <fd2num>
  8030ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8030ed:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8030f0:	83 c4 10             	add    $0x10,%esp
  8030f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8030f8:	eb 2e                	jmp    803128 <pipe+0x141>
	sys_page_unmap(0, va);
  8030fa:	83 ec 08             	sub    $0x8,%esp
  8030fd:	56                   	push   %esi
  8030fe:	6a 00                	push   $0x0
  803100:	e8 2c e7 ff ff       	call   801831 <sys_page_unmap>
  803105:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  803108:	83 ec 08             	sub    $0x8,%esp
  80310b:	ff 75 f0             	pushl  -0x10(%ebp)
  80310e:	6a 00                	push   $0x0
  803110:	e8 1c e7 ff ff       	call   801831 <sys_page_unmap>
  803115:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  803118:	83 ec 08             	sub    $0x8,%esp
  80311b:	ff 75 f4             	pushl  -0xc(%ebp)
  80311e:	6a 00                	push   $0x0
  803120:	e8 0c e7 ff ff       	call   801831 <sys_page_unmap>
  803125:	83 c4 10             	add    $0x10,%esp
}
  803128:	89 d8                	mov    %ebx,%eax
  80312a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80312d:	5b                   	pop    %ebx
  80312e:	5e                   	pop    %esi
  80312f:	5d                   	pop    %ebp
  803130:	c3                   	ret    

00803131 <pipeisclosed>:
{
  803131:	55                   	push   %ebp
  803132:	89 e5                	mov    %esp,%ebp
  803134:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803137:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80313a:	50                   	push   %eax
  80313b:	ff 75 08             	pushl  0x8(%ebp)
  80313e:	e8 19 ef ff ff       	call   80205c <fd_lookup>
  803143:	83 c4 10             	add    $0x10,%esp
  803146:	85 c0                	test   %eax,%eax
  803148:	78 18                	js     803162 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80314a:	83 ec 0c             	sub    $0xc,%esp
  80314d:	ff 75 f4             	pushl  -0xc(%ebp)
  803150:	e8 9e ee ff ff       	call   801ff3 <fd2data>
	return _pipeisclosed(fd, p);
  803155:	89 c2                	mov    %eax,%edx
  803157:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315a:	e8 2f fd ff ff       	call   802e8e <_pipeisclosed>
  80315f:	83 c4 10             	add    $0x10,%esp
}
  803162:	c9                   	leave  
  803163:	c3                   	ret    

00803164 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  803164:	55                   	push   %ebp
  803165:	89 e5                	mov    %esp,%ebp
  803167:	56                   	push   %esi
  803168:	53                   	push   %ebx
  803169:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  80316c:	85 f6                	test   %esi,%esi
  80316e:	74 13                	je     803183 <wait+0x1f>
	e = &envs[ENVX(envid)];
  803170:	89 f3                	mov    %esi,%ebx
  803172:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803178:	c1 e3 07             	shl    $0x7,%ebx
  80317b:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  803181:	eb 1b                	jmp    80319e <wait+0x3a>
	assert(envid != 0);
  803183:	68 75 3e 80 00       	push   $0x803e75
  803188:	68 38 37 80 00       	push   $0x803738
  80318d:	6a 09                	push   $0x9
  80318f:	68 80 3e 80 00       	push   $0x803e80
  803194:	e8 dc d8 ff ff       	call   800a75 <_panic>
		sys_yield();
  803199:	e8 ef e5 ff ff       	call   80178d <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80319e:	8b 43 48             	mov    0x48(%ebx),%eax
  8031a1:	39 f0                	cmp    %esi,%eax
  8031a3:	75 07                	jne    8031ac <wait+0x48>
  8031a5:	8b 43 54             	mov    0x54(%ebx),%eax
  8031a8:	85 c0                	test   %eax,%eax
  8031aa:	75 ed                	jne    803199 <wait+0x35>
}
  8031ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8031af:	5b                   	pop    %ebx
  8031b0:	5e                   	pop    %esi
  8031b1:	5d                   	pop    %ebp
  8031b2:	c3                   	ret    

008031b3 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8031b3:	55                   	push   %ebp
  8031b4:	89 e5                	mov    %esp,%ebp
  8031b6:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8031b9:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  8031c0:	74 0a                	je     8031cc <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8031c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c5:	a3 00 70 80 00       	mov    %eax,0x807000
}
  8031ca:	c9                   	leave  
  8031cb:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8031cc:	83 ec 04             	sub    $0x4,%esp
  8031cf:	6a 07                	push   $0x7
  8031d1:	68 00 f0 bf ee       	push   $0xeebff000
  8031d6:	6a 00                	push   $0x0
  8031d8:	e8 cf e5 ff ff       	call   8017ac <sys_page_alloc>
		if(r < 0)
  8031dd:	83 c4 10             	add    $0x10,%esp
  8031e0:	85 c0                	test   %eax,%eax
  8031e2:	78 2a                	js     80320e <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8031e4:	83 ec 08             	sub    $0x8,%esp
  8031e7:	68 22 32 80 00       	push   $0x803222
  8031ec:	6a 00                	push   $0x0
  8031ee:	e8 04 e7 ff ff       	call   8018f7 <sys_env_set_pgfault_upcall>
		if(r < 0)
  8031f3:	83 c4 10             	add    $0x10,%esp
  8031f6:	85 c0                	test   %eax,%eax
  8031f8:	79 c8                	jns    8031c2 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8031fa:	83 ec 04             	sub    $0x4,%esp
  8031fd:	68 bc 3e 80 00       	push   $0x803ebc
  803202:	6a 25                	push   $0x25
  803204:	68 f8 3e 80 00       	push   $0x803ef8
  803209:	e8 67 d8 ff ff       	call   800a75 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  80320e:	83 ec 04             	sub    $0x4,%esp
  803211:	68 8c 3e 80 00       	push   $0x803e8c
  803216:	6a 22                	push   $0x22
  803218:	68 f8 3e 80 00       	push   $0x803ef8
  80321d:	e8 53 d8 ff ff       	call   800a75 <_panic>

00803222 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  803222:	54                   	push   %esp
	movl _pgfault_handler, %eax
  803223:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  803228:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80322a:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  80322d:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  803231:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  803235:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  803238:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  80323a:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  80323e:	83 c4 08             	add    $0x8,%esp
	popal
  803241:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  803242:	83 c4 04             	add    $0x4,%esp
	popfl
  803245:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  803246:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  803247:	c3                   	ret    

00803248 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803248:	55                   	push   %ebp
  803249:	89 e5                	mov    %esp,%ebp
  80324b:	56                   	push   %esi
  80324c:	53                   	push   %ebx
  80324d:	8b 75 08             	mov    0x8(%ebp),%esi
  803250:	8b 45 0c             	mov    0xc(%ebp),%eax
  803253:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  803256:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  803258:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80325d:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  803260:	83 ec 0c             	sub    $0xc,%esp
  803263:	50                   	push   %eax
  803264:	e8 f3 e6 ff ff       	call   80195c <sys_ipc_recv>
	if(ret < 0){
  803269:	83 c4 10             	add    $0x10,%esp
  80326c:	85 c0                	test   %eax,%eax
  80326e:	78 2b                	js     80329b <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  803270:	85 f6                	test   %esi,%esi
  803272:	74 0a                	je     80327e <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  803274:	a1 24 54 80 00       	mov    0x805424,%eax
  803279:	8b 40 74             	mov    0x74(%eax),%eax
  80327c:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80327e:	85 db                	test   %ebx,%ebx
  803280:	74 0a                	je     80328c <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  803282:	a1 24 54 80 00       	mov    0x805424,%eax
  803287:	8b 40 78             	mov    0x78(%eax),%eax
  80328a:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  80328c:	a1 24 54 80 00       	mov    0x805424,%eax
  803291:	8b 40 70             	mov    0x70(%eax),%eax
}
  803294:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803297:	5b                   	pop    %ebx
  803298:	5e                   	pop    %esi
  803299:	5d                   	pop    %ebp
  80329a:	c3                   	ret    
		if(from_env_store)
  80329b:	85 f6                	test   %esi,%esi
  80329d:	74 06                	je     8032a5 <ipc_recv+0x5d>
			*from_env_store = 0;
  80329f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8032a5:	85 db                	test   %ebx,%ebx
  8032a7:	74 eb                	je     803294 <ipc_recv+0x4c>
			*perm_store = 0;
  8032a9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8032af:	eb e3                	jmp    803294 <ipc_recv+0x4c>

008032b1 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8032b1:	55                   	push   %ebp
  8032b2:	89 e5                	mov    %esp,%ebp
  8032b4:	57                   	push   %edi
  8032b5:	56                   	push   %esi
  8032b6:	53                   	push   %ebx
  8032b7:	83 ec 0c             	sub    $0xc,%esp
  8032ba:	8b 7d 08             	mov    0x8(%ebp),%edi
  8032bd:	8b 75 0c             	mov    0xc(%ebp),%esi
  8032c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8032c3:	85 db                	test   %ebx,%ebx
  8032c5:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8032ca:	0f 44 d8             	cmove  %eax,%ebx
  8032cd:	eb 05                	jmp    8032d4 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8032cf:	e8 b9 e4 ff ff       	call   80178d <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8032d4:	ff 75 14             	pushl  0x14(%ebp)
  8032d7:	53                   	push   %ebx
  8032d8:	56                   	push   %esi
  8032d9:	57                   	push   %edi
  8032da:	e8 5a e6 ff ff       	call   801939 <sys_ipc_try_send>
  8032df:	83 c4 10             	add    $0x10,%esp
  8032e2:	85 c0                	test   %eax,%eax
  8032e4:	74 1b                	je     803301 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8032e6:	79 e7                	jns    8032cf <ipc_send+0x1e>
  8032e8:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8032eb:	74 e2                	je     8032cf <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8032ed:	83 ec 04             	sub    $0x4,%esp
  8032f0:	68 06 3f 80 00       	push   $0x803f06
  8032f5:	6a 49                	push   $0x49
  8032f7:	68 1b 3f 80 00       	push   $0x803f1b
  8032fc:	e8 74 d7 ff ff       	call   800a75 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  803301:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803304:	5b                   	pop    %ebx
  803305:	5e                   	pop    %esi
  803306:	5f                   	pop    %edi
  803307:	5d                   	pop    %ebp
  803308:	c3                   	ret    

00803309 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803309:	55                   	push   %ebp
  80330a:	89 e5                	mov    %esp,%ebp
  80330c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80330f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  803314:	89 c2                	mov    %eax,%edx
  803316:	c1 e2 07             	shl    $0x7,%edx
  803319:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80331f:	8b 52 50             	mov    0x50(%edx),%edx
  803322:	39 ca                	cmp    %ecx,%edx
  803324:	74 11                	je     803337 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  803326:	83 c0 01             	add    $0x1,%eax
  803329:	3d 00 04 00 00       	cmp    $0x400,%eax
  80332e:	75 e4                	jne    803314 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  803330:	b8 00 00 00 00       	mov    $0x0,%eax
  803335:	eb 0b                	jmp    803342 <ipc_find_env+0x39>
			return envs[i].env_id;
  803337:	c1 e0 07             	shl    $0x7,%eax
  80333a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80333f:	8b 40 48             	mov    0x48(%eax),%eax
}
  803342:	5d                   	pop    %ebp
  803343:	c3                   	ret    

00803344 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803344:	55                   	push   %ebp
  803345:	89 e5                	mov    %esp,%ebp
  803347:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80334a:	89 d0                	mov    %edx,%eax
  80334c:	c1 e8 16             	shr    $0x16,%eax
  80334f:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  803356:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80335b:	f6 c1 01             	test   $0x1,%cl
  80335e:	74 1d                	je     80337d <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  803360:	c1 ea 0c             	shr    $0xc,%edx
  803363:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80336a:	f6 c2 01             	test   $0x1,%dl
  80336d:	74 0e                	je     80337d <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80336f:	c1 ea 0c             	shr    $0xc,%edx
  803372:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  803379:	ef 
  80337a:	0f b7 c0             	movzwl %ax,%eax
}
  80337d:	5d                   	pop    %ebp
  80337e:	c3                   	ret    
  80337f:	90                   	nop

00803380 <__udivdi3>:
  803380:	55                   	push   %ebp
  803381:	57                   	push   %edi
  803382:	56                   	push   %esi
  803383:	53                   	push   %ebx
  803384:	83 ec 1c             	sub    $0x1c,%esp
  803387:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80338b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80338f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803393:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  803397:	85 d2                	test   %edx,%edx
  803399:	75 4d                	jne    8033e8 <__udivdi3+0x68>
  80339b:	39 f3                	cmp    %esi,%ebx
  80339d:	76 19                	jbe    8033b8 <__udivdi3+0x38>
  80339f:	31 ff                	xor    %edi,%edi
  8033a1:	89 e8                	mov    %ebp,%eax
  8033a3:	89 f2                	mov    %esi,%edx
  8033a5:	f7 f3                	div    %ebx
  8033a7:	89 fa                	mov    %edi,%edx
  8033a9:	83 c4 1c             	add    $0x1c,%esp
  8033ac:	5b                   	pop    %ebx
  8033ad:	5e                   	pop    %esi
  8033ae:	5f                   	pop    %edi
  8033af:	5d                   	pop    %ebp
  8033b0:	c3                   	ret    
  8033b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8033b8:	89 d9                	mov    %ebx,%ecx
  8033ba:	85 db                	test   %ebx,%ebx
  8033bc:	75 0b                	jne    8033c9 <__udivdi3+0x49>
  8033be:	b8 01 00 00 00       	mov    $0x1,%eax
  8033c3:	31 d2                	xor    %edx,%edx
  8033c5:	f7 f3                	div    %ebx
  8033c7:	89 c1                	mov    %eax,%ecx
  8033c9:	31 d2                	xor    %edx,%edx
  8033cb:	89 f0                	mov    %esi,%eax
  8033cd:	f7 f1                	div    %ecx
  8033cf:	89 c6                	mov    %eax,%esi
  8033d1:	89 e8                	mov    %ebp,%eax
  8033d3:	89 f7                	mov    %esi,%edi
  8033d5:	f7 f1                	div    %ecx
  8033d7:	89 fa                	mov    %edi,%edx
  8033d9:	83 c4 1c             	add    $0x1c,%esp
  8033dc:	5b                   	pop    %ebx
  8033dd:	5e                   	pop    %esi
  8033de:	5f                   	pop    %edi
  8033df:	5d                   	pop    %ebp
  8033e0:	c3                   	ret    
  8033e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8033e8:	39 f2                	cmp    %esi,%edx
  8033ea:	77 1c                	ja     803408 <__udivdi3+0x88>
  8033ec:	0f bd fa             	bsr    %edx,%edi
  8033ef:	83 f7 1f             	xor    $0x1f,%edi
  8033f2:	75 2c                	jne    803420 <__udivdi3+0xa0>
  8033f4:	39 f2                	cmp    %esi,%edx
  8033f6:	72 06                	jb     8033fe <__udivdi3+0x7e>
  8033f8:	31 c0                	xor    %eax,%eax
  8033fa:	39 eb                	cmp    %ebp,%ebx
  8033fc:	77 a9                	ja     8033a7 <__udivdi3+0x27>
  8033fe:	b8 01 00 00 00       	mov    $0x1,%eax
  803403:	eb a2                	jmp    8033a7 <__udivdi3+0x27>
  803405:	8d 76 00             	lea    0x0(%esi),%esi
  803408:	31 ff                	xor    %edi,%edi
  80340a:	31 c0                	xor    %eax,%eax
  80340c:	89 fa                	mov    %edi,%edx
  80340e:	83 c4 1c             	add    $0x1c,%esp
  803411:	5b                   	pop    %ebx
  803412:	5e                   	pop    %esi
  803413:	5f                   	pop    %edi
  803414:	5d                   	pop    %ebp
  803415:	c3                   	ret    
  803416:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80341d:	8d 76 00             	lea    0x0(%esi),%esi
  803420:	89 f9                	mov    %edi,%ecx
  803422:	b8 20 00 00 00       	mov    $0x20,%eax
  803427:	29 f8                	sub    %edi,%eax
  803429:	d3 e2                	shl    %cl,%edx
  80342b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80342f:	89 c1                	mov    %eax,%ecx
  803431:	89 da                	mov    %ebx,%edx
  803433:	d3 ea                	shr    %cl,%edx
  803435:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803439:	09 d1                	or     %edx,%ecx
  80343b:	89 f2                	mov    %esi,%edx
  80343d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803441:	89 f9                	mov    %edi,%ecx
  803443:	d3 e3                	shl    %cl,%ebx
  803445:	89 c1                	mov    %eax,%ecx
  803447:	d3 ea                	shr    %cl,%edx
  803449:	89 f9                	mov    %edi,%ecx
  80344b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80344f:	89 eb                	mov    %ebp,%ebx
  803451:	d3 e6                	shl    %cl,%esi
  803453:	89 c1                	mov    %eax,%ecx
  803455:	d3 eb                	shr    %cl,%ebx
  803457:	09 de                	or     %ebx,%esi
  803459:	89 f0                	mov    %esi,%eax
  80345b:	f7 74 24 08          	divl   0x8(%esp)
  80345f:	89 d6                	mov    %edx,%esi
  803461:	89 c3                	mov    %eax,%ebx
  803463:	f7 64 24 0c          	mull   0xc(%esp)
  803467:	39 d6                	cmp    %edx,%esi
  803469:	72 15                	jb     803480 <__udivdi3+0x100>
  80346b:	89 f9                	mov    %edi,%ecx
  80346d:	d3 e5                	shl    %cl,%ebp
  80346f:	39 c5                	cmp    %eax,%ebp
  803471:	73 04                	jae    803477 <__udivdi3+0xf7>
  803473:	39 d6                	cmp    %edx,%esi
  803475:	74 09                	je     803480 <__udivdi3+0x100>
  803477:	89 d8                	mov    %ebx,%eax
  803479:	31 ff                	xor    %edi,%edi
  80347b:	e9 27 ff ff ff       	jmp    8033a7 <__udivdi3+0x27>
  803480:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803483:	31 ff                	xor    %edi,%edi
  803485:	e9 1d ff ff ff       	jmp    8033a7 <__udivdi3+0x27>
  80348a:	66 90                	xchg   %ax,%ax
  80348c:	66 90                	xchg   %ax,%ax
  80348e:	66 90                	xchg   %ax,%ax

00803490 <__umoddi3>:
  803490:	55                   	push   %ebp
  803491:	57                   	push   %edi
  803492:	56                   	push   %esi
  803493:	53                   	push   %ebx
  803494:	83 ec 1c             	sub    $0x1c,%esp
  803497:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80349b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80349f:	8b 74 24 30          	mov    0x30(%esp),%esi
  8034a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034a7:	89 da                	mov    %ebx,%edx
  8034a9:	85 c0                	test   %eax,%eax
  8034ab:	75 43                	jne    8034f0 <__umoddi3+0x60>
  8034ad:	39 df                	cmp    %ebx,%edi
  8034af:	76 17                	jbe    8034c8 <__umoddi3+0x38>
  8034b1:	89 f0                	mov    %esi,%eax
  8034b3:	f7 f7                	div    %edi
  8034b5:	89 d0                	mov    %edx,%eax
  8034b7:	31 d2                	xor    %edx,%edx
  8034b9:	83 c4 1c             	add    $0x1c,%esp
  8034bc:	5b                   	pop    %ebx
  8034bd:	5e                   	pop    %esi
  8034be:	5f                   	pop    %edi
  8034bf:	5d                   	pop    %ebp
  8034c0:	c3                   	ret    
  8034c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8034c8:	89 fd                	mov    %edi,%ebp
  8034ca:	85 ff                	test   %edi,%edi
  8034cc:	75 0b                	jne    8034d9 <__umoddi3+0x49>
  8034ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8034d3:	31 d2                	xor    %edx,%edx
  8034d5:	f7 f7                	div    %edi
  8034d7:	89 c5                	mov    %eax,%ebp
  8034d9:	89 d8                	mov    %ebx,%eax
  8034db:	31 d2                	xor    %edx,%edx
  8034dd:	f7 f5                	div    %ebp
  8034df:	89 f0                	mov    %esi,%eax
  8034e1:	f7 f5                	div    %ebp
  8034e3:	89 d0                	mov    %edx,%eax
  8034e5:	eb d0                	jmp    8034b7 <__umoddi3+0x27>
  8034e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8034ee:	66 90                	xchg   %ax,%ax
  8034f0:	89 f1                	mov    %esi,%ecx
  8034f2:	39 d8                	cmp    %ebx,%eax
  8034f4:	76 0a                	jbe    803500 <__umoddi3+0x70>
  8034f6:	89 f0                	mov    %esi,%eax
  8034f8:	83 c4 1c             	add    $0x1c,%esp
  8034fb:	5b                   	pop    %ebx
  8034fc:	5e                   	pop    %esi
  8034fd:	5f                   	pop    %edi
  8034fe:	5d                   	pop    %ebp
  8034ff:	c3                   	ret    
  803500:	0f bd e8             	bsr    %eax,%ebp
  803503:	83 f5 1f             	xor    $0x1f,%ebp
  803506:	75 20                	jne    803528 <__umoddi3+0x98>
  803508:	39 d8                	cmp    %ebx,%eax
  80350a:	0f 82 b0 00 00 00    	jb     8035c0 <__umoddi3+0x130>
  803510:	39 f7                	cmp    %esi,%edi
  803512:	0f 86 a8 00 00 00    	jbe    8035c0 <__umoddi3+0x130>
  803518:	89 c8                	mov    %ecx,%eax
  80351a:	83 c4 1c             	add    $0x1c,%esp
  80351d:	5b                   	pop    %ebx
  80351e:	5e                   	pop    %esi
  80351f:	5f                   	pop    %edi
  803520:	5d                   	pop    %ebp
  803521:	c3                   	ret    
  803522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803528:	89 e9                	mov    %ebp,%ecx
  80352a:	ba 20 00 00 00       	mov    $0x20,%edx
  80352f:	29 ea                	sub    %ebp,%edx
  803531:	d3 e0                	shl    %cl,%eax
  803533:	89 44 24 08          	mov    %eax,0x8(%esp)
  803537:	89 d1                	mov    %edx,%ecx
  803539:	89 f8                	mov    %edi,%eax
  80353b:	d3 e8                	shr    %cl,%eax
  80353d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803541:	89 54 24 04          	mov    %edx,0x4(%esp)
  803545:	8b 54 24 04          	mov    0x4(%esp),%edx
  803549:	09 c1                	or     %eax,%ecx
  80354b:	89 d8                	mov    %ebx,%eax
  80354d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803551:	89 e9                	mov    %ebp,%ecx
  803553:	d3 e7                	shl    %cl,%edi
  803555:	89 d1                	mov    %edx,%ecx
  803557:	d3 e8                	shr    %cl,%eax
  803559:	89 e9                	mov    %ebp,%ecx
  80355b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80355f:	d3 e3                	shl    %cl,%ebx
  803561:	89 c7                	mov    %eax,%edi
  803563:	89 d1                	mov    %edx,%ecx
  803565:	89 f0                	mov    %esi,%eax
  803567:	d3 e8                	shr    %cl,%eax
  803569:	89 e9                	mov    %ebp,%ecx
  80356b:	89 fa                	mov    %edi,%edx
  80356d:	d3 e6                	shl    %cl,%esi
  80356f:	09 d8                	or     %ebx,%eax
  803571:	f7 74 24 08          	divl   0x8(%esp)
  803575:	89 d1                	mov    %edx,%ecx
  803577:	89 f3                	mov    %esi,%ebx
  803579:	f7 64 24 0c          	mull   0xc(%esp)
  80357d:	89 c6                	mov    %eax,%esi
  80357f:	89 d7                	mov    %edx,%edi
  803581:	39 d1                	cmp    %edx,%ecx
  803583:	72 06                	jb     80358b <__umoddi3+0xfb>
  803585:	75 10                	jne    803597 <__umoddi3+0x107>
  803587:	39 c3                	cmp    %eax,%ebx
  803589:	73 0c                	jae    803597 <__umoddi3+0x107>
  80358b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80358f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  803593:	89 d7                	mov    %edx,%edi
  803595:	89 c6                	mov    %eax,%esi
  803597:	89 ca                	mov    %ecx,%edx
  803599:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80359e:	29 f3                	sub    %esi,%ebx
  8035a0:	19 fa                	sbb    %edi,%edx
  8035a2:	89 d0                	mov    %edx,%eax
  8035a4:	d3 e0                	shl    %cl,%eax
  8035a6:	89 e9                	mov    %ebp,%ecx
  8035a8:	d3 eb                	shr    %cl,%ebx
  8035aa:	d3 ea                	shr    %cl,%edx
  8035ac:	09 d8                	or     %ebx,%eax
  8035ae:	83 c4 1c             	add    $0x1c,%esp
  8035b1:	5b                   	pop    %ebx
  8035b2:	5e                   	pop    %esi
  8035b3:	5f                   	pop    %edi
  8035b4:	5d                   	pop    %ebp
  8035b5:	c3                   	ret    
  8035b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8035bd:	8d 76 00             	lea    0x0(%esi),%esi
  8035c0:	89 da                	mov    %ebx,%edx
  8035c2:	29 fe                	sub    %edi,%esi
  8035c4:	19 c2                	sbb    %eax,%edx
  8035c6:	89 f1                	mov    %esi,%ecx
  8035c8:	89 c8                	mov    %ecx,%eax
  8035ca:	e9 4b ff ff ff       	jmp    80351a <__umoddi3+0x8a>
