
obj/user/ls.debug:     file format elf32-i386


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
  80002c:	e8 95 02 00 00       	call   8002c6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <ls1>:
		panic("error reading directory %s: %e", path, n);
}

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80003b:	8b 75 0c             	mov    0xc(%ebp),%esi
	const char *sep;

	if(flag['l'])
  80003e:	83 3d d0 51 80 00 00 	cmpl   $0x0,0x8051d0
  800045:	74 20                	je     800067 <ls1+0x34>
		printf("%11d %c ", size, isdir ? 'd' : '-');
  800047:	89 f0                	mov    %esi,%eax
  800049:	3c 01                	cmp    $0x1,%al
  80004b:	19 c0                	sbb    %eax,%eax
  80004d:	83 e0 c9             	and    $0xffffffc9,%eax
  800050:	83 c0 64             	add    $0x64,%eax
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	50                   	push   %eax
  800057:	ff 75 10             	pushl  0x10(%ebp)
  80005a:	68 62 2a 80 00       	push   $0x802a62
  80005f:	e8 22 1d 00 00       	call   801d86 <printf>
  800064:	83 c4 10             	add    $0x10,%esp
	if(prefix) {
  800067:	85 db                	test   %ebx,%ebx
  800069:	74 1c                	je     800087 <ls1+0x54>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
			sep = "/";
		else
			sep = "";
  80006b:	b8 08 2b 80 00       	mov    $0x802b08,%eax
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  800070:	80 3b 00             	cmpb   $0x0,(%ebx)
  800073:	75 4b                	jne    8000c0 <ls1+0x8d>
		printf("%s%s", prefix, sep);
  800075:	83 ec 04             	sub    $0x4,%esp
  800078:	50                   	push   %eax
  800079:	53                   	push   %ebx
  80007a:	68 6b 2a 80 00       	push   $0x802a6b
  80007f:	e8 02 1d 00 00       	call   801d86 <printf>
  800084:	83 c4 10             	add    $0x10,%esp
	}
	printf("%s", name);
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	ff 75 14             	pushl  0x14(%ebp)
  80008d:	68 e1 2f 80 00       	push   $0x802fe1
  800092:	e8 ef 1c 00 00       	call   801d86 <printf>
	if(flag['F'] && isdir)
  800097:	83 c4 10             	add    $0x10,%esp
  80009a:	83 3d 38 51 80 00 00 	cmpl   $0x0,0x805138
  8000a1:	74 06                	je     8000a9 <ls1+0x76>
  8000a3:	89 f0                	mov    %esi,%eax
  8000a5:	84 c0                	test   %al,%al
  8000a7:	75 37                	jne    8000e0 <ls1+0xad>
		printf("/");
	printf("\n");
  8000a9:	83 ec 0c             	sub    $0xc,%esp
  8000ac:	68 07 2b 80 00       	push   $0x802b07
  8000b1:	e8 d0 1c 00 00       	call   801d86 <printf>
}
  8000b6:	83 c4 10             	add    $0x10,%esp
  8000b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000bc:	5b                   	pop    %ebx
  8000bd:	5e                   	pop    %esi
  8000be:	5d                   	pop    %ebp
  8000bf:	c3                   	ret    
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  8000c0:	83 ec 0c             	sub    $0xc,%esp
  8000c3:	53                   	push   %ebx
  8000c4:	e8 26 0b 00 00       	call   800bef <strlen>
  8000c9:	83 c4 10             	add    $0x10,%esp
			sep = "";
  8000cc:	80 7c 03 ff 2f       	cmpb   $0x2f,-0x1(%ebx,%eax,1)
  8000d1:	b8 60 2a 80 00       	mov    $0x802a60,%eax
  8000d6:	ba 08 2b 80 00       	mov    $0x802b08,%edx
  8000db:	0f 44 c2             	cmove  %edx,%eax
  8000de:	eb 95                	jmp    800075 <ls1+0x42>
		printf("/");
  8000e0:	83 ec 0c             	sub    $0xc,%esp
  8000e3:	68 60 2a 80 00       	push   $0x802a60
  8000e8:	e8 99 1c 00 00       	call   801d86 <printf>
  8000ed:	83 c4 10             	add    $0x10,%esp
  8000f0:	eb b7                	jmp    8000a9 <ls1+0x76>

008000f2 <lsdir>:
{
  8000f2:	55                   	push   %ebp
  8000f3:	89 e5                	mov    %esp,%ebp
  8000f5:	57                   	push   %edi
  8000f6:	56                   	push   %esi
  8000f7:	53                   	push   %ebx
  8000f8:	81 ec 14 01 00 00    	sub    $0x114,%esp
  8000fe:	8b 7d 08             	mov    0x8(%ebp),%edi
	if ((fd = open(path, O_RDONLY)) < 0)
  800101:	6a 00                	push   $0x0
  800103:	57                   	push   %edi
  800104:	e8 da 1a 00 00       	call   801be3 <open>
  800109:	89 c3                	mov    %eax,%ebx
  80010b:	83 c4 10             	add    $0x10,%esp
  80010e:	85 c0                	test   %eax,%eax
  800110:	78 4a                	js     80015c <lsdir+0x6a>
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  800112:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800118:	83 ec 04             	sub    $0x4,%esp
  80011b:	68 00 01 00 00       	push   $0x100
  800120:	56                   	push   %esi
  800121:	53                   	push   %ebx
  800122:	e8 a5 16 00 00       	call   8017cc <readn>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	3d 00 01 00 00       	cmp    $0x100,%eax
  80012f:	75 41                	jne    800172 <lsdir+0x80>
		if (f.f_name[0])
  800131:	80 bd e8 fe ff ff 00 	cmpb   $0x0,-0x118(%ebp)
  800138:	74 de                	je     800118 <lsdir+0x26>
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
  80013a:	56                   	push   %esi
  80013b:	ff b5 68 ff ff ff    	pushl  -0x98(%ebp)
  800141:	83 bd 6c ff ff ff 01 	cmpl   $0x1,-0x94(%ebp)
  800148:	0f 94 c0             	sete   %al
  80014b:	0f b6 c0             	movzbl %al,%eax
  80014e:	50                   	push   %eax
  80014f:	ff 75 0c             	pushl  0xc(%ebp)
  800152:	e8 dc fe ff ff       	call   800033 <ls1>
  800157:	83 c4 10             	add    $0x10,%esp
  80015a:	eb bc                	jmp    800118 <lsdir+0x26>
		panic("open %s: %e", path, fd);
  80015c:	83 ec 0c             	sub    $0xc,%esp
  80015f:	50                   	push   %eax
  800160:	57                   	push   %edi
  800161:	68 70 2a 80 00       	push   $0x802a70
  800166:	6a 1d                	push   $0x1d
  800168:	68 7c 2a 80 00       	push   $0x802a7c
  80016d:	e8 61 02 00 00       	call   8003d3 <_panic>
	if (n > 0)
  800172:	85 c0                	test   %eax,%eax
  800174:	7f 0a                	jg     800180 <lsdir+0x8e>
	if (n < 0)
  800176:	78 1a                	js     800192 <lsdir+0xa0>
}
  800178:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80017b:	5b                   	pop    %ebx
  80017c:	5e                   	pop    %esi
  80017d:	5f                   	pop    %edi
  80017e:	5d                   	pop    %ebp
  80017f:	c3                   	ret    
		panic("short read in directory %s", path);
  800180:	57                   	push   %edi
  800181:	68 86 2a 80 00       	push   $0x802a86
  800186:	6a 22                	push   $0x22
  800188:	68 7c 2a 80 00       	push   $0x802a7c
  80018d:	e8 41 02 00 00       	call   8003d3 <_panic>
		panic("error reading directory %s: %e", path, n);
  800192:	83 ec 0c             	sub    $0xc,%esp
  800195:	50                   	push   %eax
  800196:	57                   	push   %edi
  800197:	68 cc 2a 80 00       	push   $0x802acc
  80019c:	6a 24                	push   $0x24
  80019e:	68 7c 2a 80 00       	push   $0x802a7c
  8001a3:	e8 2b 02 00 00       	call   8003d3 <_panic>

008001a8 <ls>:
{
  8001a8:	55                   	push   %ebp
  8001a9:	89 e5                	mov    %esp,%ebp
  8001ab:	53                   	push   %ebx
  8001ac:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  8001b2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if ((r = stat(path, &st)) < 0)
  8001b5:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
  8001bb:	50                   	push   %eax
  8001bc:	53                   	push   %ebx
  8001bd:	e8 ed 17 00 00       	call   8019af <stat>
  8001c2:	83 c4 10             	add    $0x10,%esp
  8001c5:	85 c0                	test   %eax,%eax
  8001c7:	78 2c                	js     8001f5 <ls+0x4d>
	if (st.st_isdir && !flag['d'])
  8001c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001cc:	85 c0                	test   %eax,%eax
  8001ce:	74 09                	je     8001d9 <ls+0x31>
  8001d0:	83 3d b0 51 80 00 00 	cmpl   $0x0,0x8051b0
  8001d7:	74 32                	je     80020b <ls+0x63>
		ls1(0, st.st_isdir, st.st_size, path);
  8001d9:	53                   	push   %ebx
  8001da:	ff 75 ec             	pushl  -0x14(%ebp)
  8001dd:	85 c0                	test   %eax,%eax
  8001df:	0f 95 c0             	setne  %al
  8001e2:	0f b6 c0             	movzbl %al,%eax
  8001e5:	50                   	push   %eax
  8001e6:	6a 00                	push   $0x0
  8001e8:	e8 46 fe ff ff       	call   800033 <ls1>
  8001ed:	83 c4 10             	add    $0x10,%esp
}
  8001f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001f3:	c9                   	leave  
  8001f4:	c3                   	ret    
		panic("stat %s: %e", path, r);
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	50                   	push   %eax
  8001f9:	53                   	push   %ebx
  8001fa:	68 a1 2a 80 00       	push   $0x802aa1
  8001ff:	6a 0f                	push   $0xf
  800201:	68 7c 2a 80 00       	push   $0x802a7c
  800206:	e8 c8 01 00 00       	call   8003d3 <_panic>
		lsdir(path, prefix);
  80020b:	83 ec 08             	sub    $0x8,%esp
  80020e:	ff 75 0c             	pushl  0xc(%ebp)
  800211:	53                   	push   %ebx
  800212:	e8 db fe ff ff       	call   8000f2 <lsdir>
  800217:	83 c4 10             	add    $0x10,%esp
  80021a:	eb d4                	jmp    8001f0 <ls+0x48>

0080021c <usage>:

void
usage(void)
{
  80021c:	55                   	push   %ebp
  80021d:	89 e5                	mov    %esp,%ebp
  80021f:	83 ec 14             	sub    $0x14,%esp
	printf("usage: ls [-dFl] [file...]\n");
  800222:	68 ad 2a 80 00       	push   $0x802aad
  800227:	e8 5a 1b 00 00       	call   801d86 <printf>
	exit();
  80022c:	e8 6e 01 00 00       	call   80039f <exit>
}
  800231:	83 c4 10             	add    $0x10,%esp
  800234:	c9                   	leave  
  800235:	c3                   	ret    

00800236 <umain>:

void
umain(int argc, char **argv)
{
  800236:	55                   	push   %ebp
  800237:	89 e5                	mov    %esp,%ebp
  800239:	56                   	push   %esi
  80023a:	53                   	push   %ebx
  80023b:	83 ec 14             	sub    $0x14,%esp
  80023e:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800241:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800244:	50                   	push   %eax
  800245:	56                   	push   %esi
  800246:	8d 45 08             	lea    0x8(%ebp),%eax
  800249:	50                   	push   %eax
  80024a:	e8 c0 10 00 00       	call   80130f <argstart>
	while ((i = argnext(&args)) >= 0)
  80024f:	83 c4 10             	add    $0x10,%esp
  800252:	8d 5d e8             	lea    -0x18(%ebp),%ebx
  800255:	eb 08                	jmp    80025f <umain+0x29>
		switch (i) {
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
  800257:	83 04 85 20 50 80 00 	addl   $0x1,0x805020(,%eax,4)
  80025e:	01 
	while ((i = argnext(&args)) >= 0)
  80025f:	83 ec 0c             	sub    $0xc,%esp
  800262:	53                   	push   %ebx
  800263:	e8 d7 10 00 00       	call   80133f <argnext>
  800268:	83 c4 10             	add    $0x10,%esp
  80026b:	85 c0                	test   %eax,%eax
  80026d:	78 16                	js     800285 <umain+0x4f>
		switch (i) {
  80026f:	83 f8 64             	cmp    $0x64,%eax
  800272:	74 e3                	je     800257 <umain+0x21>
  800274:	83 f8 6c             	cmp    $0x6c,%eax
  800277:	74 de                	je     800257 <umain+0x21>
  800279:	83 f8 46             	cmp    $0x46,%eax
  80027c:	74 d9                	je     800257 <umain+0x21>
			break;
		default:
			usage();
  80027e:	e8 99 ff ff ff       	call   80021c <usage>
  800283:	eb da                	jmp    80025f <umain+0x29>
		}

	if (argc == 1)
		ls("/", "");
	else {
		for (i = 1; i < argc; i++)
  800285:	bb 01 00 00 00       	mov    $0x1,%ebx
	if (argc == 1)
  80028a:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80028e:	75 2a                	jne    8002ba <umain+0x84>
		ls("/", "");
  800290:	83 ec 08             	sub    $0x8,%esp
  800293:	68 08 2b 80 00       	push   $0x802b08
  800298:	68 60 2a 80 00       	push   $0x802a60
  80029d:	e8 06 ff ff ff       	call   8001a8 <ls>
  8002a2:	83 c4 10             	add    $0x10,%esp
  8002a5:	eb 18                	jmp    8002bf <umain+0x89>
			ls(argv[i], argv[i]);
  8002a7:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8002aa:	83 ec 08             	sub    $0x8,%esp
  8002ad:	50                   	push   %eax
  8002ae:	50                   	push   %eax
  8002af:	e8 f4 fe ff ff       	call   8001a8 <ls>
		for (i = 1; i < argc; i++)
  8002b4:	83 c3 01             	add    $0x1,%ebx
  8002b7:	83 c4 10             	add    $0x10,%esp
  8002ba:	39 5d 08             	cmp    %ebx,0x8(%ebp)
  8002bd:	7f e8                	jg     8002a7 <umain+0x71>
	}
}
  8002bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8002c2:	5b                   	pop    %ebx
  8002c3:	5e                   	pop    %esi
  8002c4:	5d                   	pop    %ebp
  8002c5:	c3                   	ret    

008002c6 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8002c6:	55                   	push   %ebp
  8002c7:	89 e5                	mov    %esp,%ebp
  8002c9:	57                   	push   %edi
  8002ca:	56                   	push   %esi
  8002cb:	53                   	push   %ebx
  8002cc:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8002cf:	c7 05 20 54 80 00 00 	movl   $0x0,0x805420
  8002d6:	00 00 00 
	envid_t find = sys_getenvid();
  8002d9:	e8 fe 0c 00 00       	call   800fdc <sys_getenvid>
  8002de:	8b 1d 20 54 80 00    	mov    0x805420,%ebx
  8002e4:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8002e9:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8002ee:	bf 01 00 00 00       	mov    $0x1,%edi
  8002f3:	eb 0b                	jmp    800300 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8002f5:	83 c2 01             	add    $0x1,%edx
  8002f8:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8002fe:	74 21                	je     800321 <libmain+0x5b>
		if(envs[i].env_id == find)
  800300:	89 d1                	mov    %edx,%ecx
  800302:	c1 e1 07             	shl    $0x7,%ecx
  800305:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  80030b:	8b 49 48             	mov    0x48(%ecx),%ecx
  80030e:	39 c1                	cmp    %eax,%ecx
  800310:	75 e3                	jne    8002f5 <libmain+0x2f>
  800312:	89 d3                	mov    %edx,%ebx
  800314:	c1 e3 07             	shl    $0x7,%ebx
  800317:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80031d:	89 fe                	mov    %edi,%esi
  80031f:	eb d4                	jmp    8002f5 <libmain+0x2f>
  800321:	89 f0                	mov    %esi,%eax
  800323:	84 c0                	test   %al,%al
  800325:	74 06                	je     80032d <libmain+0x67>
  800327:	89 1d 20 54 80 00    	mov    %ebx,0x805420
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80032d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800331:	7e 0a                	jle    80033d <libmain+0x77>
		binaryname = argv[0];
  800333:	8b 45 0c             	mov    0xc(%ebp),%eax
  800336:	8b 00                	mov    (%eax),%eax
  800338:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  80033d:	a1 20 54 80 00       	mov    0x805420,%eax
  800342:	8b 40 48             	mov    0x48(%eax),%eax
  800345:	83 ec 08             	sub    $0x8,%esp
  800348:	50                   	push   %eax
  800349:	68 eb 2a 80 00       	push   $0x802aeb
  80034e:	e8 76 01 00 00       	call   8004c9 <cprintf>
	cprintf("before umain\n");
  800353:	c7 04 24 09 2b 80 00 	movl   $0x802b09,(%esp)
  80035a:	e8 6a 01 00 00       	call   8004c9 <cprintf>
	// call user main routine
	umain(argc, argv);
  80035f:	83 c4 08             	add    $0x8,%esp
  800362:	ff 75 0c             	pushl  0xc(%ebp)
  800365:	ff 75 08             	pushl  0x8(%ebp)
  800368:	e8 c9 fe ff ff       	call   800236 <umain>
	cprintf("after umain\n");
  80036d:	c7 04 24 17 2b 80 00 	movl   $0x802b17,(%esp)
  800374:	e8 50 01 00 00       	call   8004c9 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800379:	a1 20 54 80 00       	mov    0x805420,%eax
  80037e:	8b 40 48             	mov    0x48(%eax),%eax
  800381:	83 c4 08             	add    $0x8,%esp
  800384:	50                   	push   %eax
  800385:	68 24 2b 80 00       	push   $0x802b24
  80038a:	e8 3a 01 00 00       	call   8004c9 <cprintf>
	// exit gracefully
	exit();
  80038f:	e8 0b 00 00 00       	call   80039f <exit>
}
  800394:	83 c4 10             	add    $0x10,%esp
  800397:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80039a:	5b                   	pop    %ebx
  80039b:	5e                   	pop    %esi
  80039c:	5f                   	pop    %edi
  80039d:	5d                   	pop    %ebp
  80039e:	c3                   	ret    

0080039f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8003a5:	a1 20 54 80 00       	mov    0x805420,%eax
  8003aa:	8b 40 48             	mov    0x48(%eax),%eax
  8003ad:	68 50 2b 80 00       	push   $0x802b50
  8003b2:	50                   	push   %eax
  8003b3:	68 43 2b 80 00       	push   $0x802b43
  8003b8:	e8 0c 01 00 00       	call   8004c9 <cprintf>
	close_all();
  8003bd:	e8 72 12 00 00       	call   801634 <close_all>
	sys_env_destroy(0);
  8003c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8003c9:	e8 cd 0b 00 00       	call   800f9b <sys_env_destroy>
}
  8003ce:	83 c4 10             	add    $0x10,%esp
  8003d1:	c9                   	leave  
  8003d2:	c3                   	ret    

008003d3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003d3:	55                   	push   %ebp
  8003d4:	89 e5                	mov    %esp,%ebp
  8003d6:	56                   	push   %esi
  8003d7:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8003d8:	a1 20 54 80 00       	mov    0x805420,%eax
  8003dd:	8b 40 48             	mov    0x48(%eax),%eax
  8003e0:	83 ec 04             	sub    $0x4,%esp
  8003e3:	68 7c 2b 80 00       	push   $0x802b7c
  8003e8:	50                   	push   %eax
  8003e9:	68 43 2b 80 00       	push   $0x802b43
  8003ee:	e8 d6 00 00 00       	call   8004c9 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8003f3:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003f6:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8003fc:	e8 db 0b 00 00       	call   800fdc <sys_getenvid>
  800401:	83 c4 04             	add    $0x4,%esp
  800404:	ff 75 0c             	pushl  0xc(%ebp)
  800407:	ff 75 08             	pushl  0x8(%ebp)
  80040a:	56                   	push   %esi
  80040b:	50                   	push   %eax
  80040c:	68 58 2b 80 00       	push   $0x802b58
  800411:	e8 b3 00 00 00       	call   8004c9 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800416:	83 c4 18             	add    $0x18,%esp
  800419:	53                   	push   %ebx
  80041a:	ff 75 10             	pushl  0x10(%ebp)
  80041d:	e8 56 00 00 00       	call   800478 <vcprintf>
	cprintf("\n");
  800422:	c7 04 24 07 2b 80 00 	movl   $0x802b07,(%esp)
  800429:	e8 9b 00 00 00       	call   8004c9 <cprintf>
  80042e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800431:	cc                   	int3   
  800432:	eb fd                	jmp    800431 <_panic+0x5e>

00800434 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800434:	55                   	push   %ebp
  800435:	89 e5                	mov    %esp,%ebp
  800437:	53                   	push   %ebx
  800438:	83 ec 04             	sub    $0x4,%esp
  80043b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80043e:	8b 13                	mov    (%ebx),%edx
  800440:	8d 42 01             	lea    0x1(%edx),%eax
  800443:	89 03                	mov    %eax,(%ebx)
  800445:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800448:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80044c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800451:	74 09                	je     80045c <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800453:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800457:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80045a:	c9                   	leave  
  80045b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80045c:	83 ec 08             	sub    $0x8,%esp
  80045f:	68 ff 00 00 00       	push   $0xff
  800464:	8d 43 08             	lea    0x8(%ebx),%eax
  800467:	50                   	push   %eax
  800468:	e8 f1 0a 00 00       	call   800f5e <sys_cputs>
		b->idx = 0;
  80046d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800473:	83 c4 10             	add    $0x10,%esp
  800476:	eb db                	jmp    800453 <putch+0x1f>

00800478 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800478:	55                   	push   %ebp
  800479:	89 e5                	mov    %esp,%ebp
  80047b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800481:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800488:	00 00 00 
	b.cnt = 0;
  80048b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800492:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800495:	ff 75 0c             	pushl  0xc(%ebp)
  800498:	ff 75 08             	pushl  0x8(%ebp)
  80049b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004a1:	50                   	push   %eax
  8004a2:	68 34 04 80 00       	push   $0x800434
  8004a7:	e8 4a 01 00 00       	call   8005f6 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004ac:	83 c4 08             	add    $0x8,%esp
  8004af:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8004b5:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004bb:	50                   	push   %eax
  8004bc:	e8 9d 0a 00 00       	call   800f5e <sys_cputs>

	return b.cnt;
}
  8004c1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004c7:	c9                   	leave  
  8004c8:	c3                   	ret    

008004c9 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004c9:	55                   	push   %ebp
  8004ca:	89 e5                	mov    %esp,%ebp
  8004cc:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004cf:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004d2:	50                   	push   %eax
  8004d3:	ff 75 08             	pushl  0x8(%ebp)
  8004d6:	e8 9d ff ff ff       	call   800478 <vcprintf>
	va_end(ap);

	return cnt;
}
  8004db:	c9                   	leave  
  8004dc:	c3                   	ret    

008004dd <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004dd:	55                   	push   %ebp
  8004de:	89 e5                	mov    %esp,%ebp
  8004e0:	57                   	push   %edi
  8004e1:	56                   	push   %esi
  8004e2:	53                   	push   %ebx
  8004e3:	83 ec 1c             	sub    $0x1c,%esp
  8004e6:	89 c6                	mov    %eax,%esi
  8004e8:	89 d7                	mov    %edx,%edi
  8004ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004f3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8004f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f9:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8004fc:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800500:	74 2c                	je     80052e <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800502:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800505:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80050c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80050f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800512:	39 c2                	cmp    %eax,%edx
  800514:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800517:	73 43                	jae    80055c <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800519:	83 eb 01             	sub    $0x1,%ebx
  80051c:	85 db                	test   %ebx,%ebx
  80051e:	7e 6c                	jle    80058c <printnum+0xaf>
				putch(padc, putdat);
  800520:	83 ec 08             	sub    $0x8,%esp
  800523:	57                   	push   %edi
  800524:	ff 75 18             	pushl  0x18(%ebp)
  800527:	ff d6                	call   *%esi
  800529:	83 c4 10             	add    $0x10,%esp
  80052c:	eb eb                	jmp    800519 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80052e:	83 ec 0c             	sub    $0xc,%esp
  800531:	6a 20                	push   $0x20
  800533:	6a 00                	push   $0x0
  800535:	50                   	push   %eax
  800536:	ff 75 e4             	pushl  -0x1c(%ebp)
  800539:	ff 75 e0             	pushl  -0x20(%ebp)
  80053c:	89 fa                	mov    %edi,%edx
  80053e:	89 f0                	mov    %esi,%eax
  800540:	e8 98 ff ff ff       	call   8004dd <printnum>
		while (--width > 0)
  800545:	83 c4 20             	add    $0x20,%esp
  800548:	83 eb 01             	sub    $0x1,%ebx
  80054b:	85 db                	test   %ebx,%ebx
  80054d:	7e 65                	jle    8005b4 <printnum+0xd7>
			putch(padc, putdat);
  80054f:	83 ec 08             	sub    $0x8,%esp
  800552:	57                   	push   %edi
  800553:	6a 20                	push   $0x20
  800555:	ff d6                	call   *%esi
  800557:	83 c4 10             	add    $0x10,%esp
  80055a:	eb ec                	jmp    800548 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80055c:	83 ec 0c             	sub    $0xc,%esp
  80055f:	ff 75 18             	pushl  0x18(%ebp)
  800562:	83 eb 01             	sub    $0x1,%ebx
  800565:	53                   	push   %ebx
  800566:	50                   	push   %eax
  800567:	83 ec 08             	sub    $0x8,%esp
  80056a:	ff 75 dc             	pushl  -0x24(%ebp)
  80056d:	ff 75 d8             	pushl  -0x28(%ebp)
  800570:	ff 75 e4             	pushl  -0x1c(%ebp)
  800573:	ff 75 e0             	pushl  -0x20(%ebp)
  800576:	e8 85 22 00 00       	call   802800 <__udivdi3>
  80057b:	83 c4 18             	add    $0x18,%esp
  80057e:	52                   	push   %edx
  80057f:	50                   	push   %eax
  800580:	89 fa                	mov    %edi,%edx
  800582:	89 f0                	mov    %esi,%eax
  800584:	e8 54 ff ff ff       	call   8004dd <printnum>
  800589:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80058c:	83 ec 08             	sub    $0x8,%esp
  80058f:	57                   	push   %edi
  800590:	83 ec 04             	sub    $0x4,%esp
  800593:	ff 75 dc             	pushl  -0x24(%ebp)
  800596:	ff 75 d8             	pushl  -0x28(%ebp)
  800599:	ff 75 e4             	pushl  -0x1c(%ebp)
  80059c:	ff 75 e0             	pushl  -0x20(%ebp)
  80059f:	e8 6c 23 00 00       	call   802910 <__umoddi3>
  8005a4:	83 c4 14             	add    $0x14,%esp
  8005a7:	0f be 80 83 2b 80 00 	movsbl 0x802b83(%eax),%eax
  8005ae:	50                   	push   %eax
  8005af:	ff d6                	call   *%esi
  8005b1:	83 c4 10             	add    $0x10,%esp
	}
}
  8005b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005b7:	5b                   	pop    %ebx
  8005b8:	5e                   	pop    %esi
  8005b9:	5f                   	pop    %edi
  8005ba:	5d                   	pop    %ebp
  8005bb:	c3                   	ret    

008005bc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005bc:	55                   	push   %ebp
  8005bd:	89 e5                	mov    %esp,%ebp
  8005bf:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005c2:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005c6:	8b 10                	mov    (%eax),%edx
  8005c8:	3b 50 04             	cmp    0x4(%eax),%edx
  8005cb:	73 0a                	jae    8005d7 <sprintputch+0x1b>
		*b->buf++ = ch;
  8005cd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005d0:	89 08                	mov    %ecx,(%eax)
  8005d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d5:	88 02                	mov    %al,(%edx)
}
  8005d7:	5d                   	pop    %ebp
  8005d8:	c3                   	ret    

008005d9 <printfmt>:
{
  8005d9:	55                   	push   %ebp
  8005da:	89 e5                	mov    %esp,%ebp
  8005dc:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8005df:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005e2:	50                   	push   %eax
  8005e3:	ff 75 10             	pushl  0x10(%ebp)
  8005e6:	ff 75 0c             	pushl  0xc(%ebp)
  8005e9:	ff 75 08             	pushl  0x8(%ebp)
  8005ec:	e8 05 00 00 00       	call   8005f6 <vprintfmt>
}
  8005f1:	83 c4 10             	add    $0x10,%esp
  8005f4:	c9                   	leave  
  8005f5:	c3                   	ret    

008005f6 <vprintfmt>:
{
  8005f6:	55                   	push   %ebp
  8005f7:	89 e5                	mov    %esp,%ebp
  8005f9:	57                   	push   %edi
  8005fa:	56                   	push   %esi
  8005fb:	53                   	push   %ebx
  8005fc:	83 ec 3c             	sub    $0x3c,%esp
  8005ff:	8b 75 08             	mov    0x8(%ebp),%esi
  800602:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800605:	8b 7d 10             	mov    0x10(%ebp),%edi
  800608:	e9 32 04 00 00       	jmp    800a3f <vprintfmt+0x449>
		padc = ' ';
  80060d:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800611:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800618:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80061f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800626:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80062d:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800634:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800639:	8d 47 01             	lea    0x1(%edi),%eax
  80063c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80063f:	0f b6 17             	movzbl (%edi),%edx
  800642:	8d 42 dd             	lea    -0x23(%edx),%eax
  800645:	3c 55                	cmp    $0x55,%al
  800647:	0f 87 12 05 00 00    	ja     800b5f <vprintfmt+0x569>
  80064d:	0f b6 c0             	movzbl %al,%eax
  800650:	ff 24 85 60 2d 80 00 	jmp    *0x802d60(,%eax,4)
  800657:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80065a:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80065e:	eb d9                	jmp    800639 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800660:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800663:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800667:	eb d0                	jmp    800639 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800669:	0f b6 d2             	movzbl %dl,%edx
  80066c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80066f:	b8 00 00 00 00       	mov    $0x0,%eax
  800674:	89 75 08             	mov    %esi,0x8(%ebp)
  800677:	eb 03                	jmp    80067c <vprintfmt+0x86>
  800679:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80067c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80067f:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800683:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800686:	8d 72 d0             	lea    -0x30(%edx),%esi
  800689:	83 fe 09             	cmp    $0x9,%esi
  80068c:	76 eb                	jbe    800679 <vprintfmt+0x83>
  80068e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800691:	8b 75 08             	mov    0x8(%ebp),%esi
  800694:	eb 14                	jmp    8006aa <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800696:	8b 45 14             	mov    0x14(%ebp),%eax
  800699:	8b 00                	mov    (%eax),%eax
  80069b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069e:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a1:	8d 40 04             	lea    0x4(%eax),%eax
  8006a4:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8006aa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006ae:	79 89                	jns    800639 <vprintfmt+0x43>
				width = precision, precision = -1;
  8006b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006b6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8006bd:	e9 77 ff ff ff       	jmp    800639 <vprintfmt+0x43>
  8006c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006c5:	85 c0                	test   %eax,%eax
  8006c7:	0f 48 c1             	cmovs  %ecx,%eax
  8006ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006cd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006d0:	e9 64 ff ff ff       	jmp    800639 <vprintfmt+0x43>
  8006d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8006d8:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8006df:	e9 55 ff ff ff       	jmp    800639 <vprintfmt+0x43>
			lflag++;
  8006e4:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006eb:	e9 49 ff ff ff       	jmp    800639 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8006f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f3:	8d 78 04             	lea    0x4(%eax),%edi
  8006f6:	83 ec 08             	sub    $0x8,%esp
  8006f9:	53                   	push   %ebx
  8006fa:	ff 30                	pushl  (%eax)
  8006fc:	ff d6                	call   *%esi
			break;
  8006fe:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800701:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800704:	e9 33 03 00 00       	jmp    800a3c <vprintfmt+0x446>
			err = va_arg(ap, int);
  800709:	8b 45 14             	mov    0x14(%ebp),%eax
  80070c:	8d 78 04             	lea    0x4(%eax),%edi
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	99                   	cltd   
  800712:	31 d0                	xor    %edx,%eax
  800714:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800716:	83 f8 11             	cmp    $0x11,%eax
  800719:	7f 23                	jg     80073e <vprintfmt+0x148>
  80071b:	8b 14 85 c0 2e 80 00 	mov    0x802ec0(,%eax,4),%edx
  800722:	85 d2                	test   %edx,%edx
  800724:	74 18                	je     80073e <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800726:	52                   	push   %edx
  800727:	68 e1 2f 80 00       	push   $0x802fe1
  80072c:	53                   	push   %ebx
  80072d:	56                   	push   %esi
  80072e:	e8 a6 fe ff ff       	call   8005d9 <printfmt>
  800733:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800736:	89 7d 14             	mov    %edi,0x14(%ebp)
  800739:	e9 fe 02 00 00       	jmp    800a3c <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80073e:	50                   	push   %eax
  80073f:	68 9b 2b 80 00       	push   $0x802b9b
  800744:	53                   	push   %ebx
  800745:	56                   	push   %esi
  800746:	e8 8e fe ff ff       	call   8005d9 <printfmt>
  80074b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80074e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800751:	e9 e6 02 00 00       	jmp    800a3c <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800756:	8b 45 14             	mov    0x14(%ebp),%eax
  800759:	83 c0 04             	add    $0x4,%eax
  80075c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80075f:	8b 45 14             	mov    0x14(%ebp),%eax
  800762:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800764:	85 c9                	test   %ecx,%ecx
  800766:	b8 94 2b 80 00       	mov    $0x802b94,%eax
  80076b:	0f 45 c1             	cmovne %ecx,%eax
  80076e:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800771:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800775:	7e 06                	jle    80077d <vprintfmt+0x187>
  800777:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80077b:	75 0d                	jne    80078a <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80077d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800780:	89 c7                	mov    %eax,%edi
  800782:	03 45 e0             	add    -0x20(%ebp),%eax
  800785:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800788:	eb 53                	jmp    8007dd <vprintfmt+0x1e7>
  80078a:	83 ec 08             	sub    $0x8,%esp
  80078d:	ff 75 d8             	pushl  -0x28(%ebp)
  800790:	50                   	push   %eax
  800791:	e8 71 04 00 00       	call   800c07 <strnlen>
  800796:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800799:	29 c1                	sub    %eax,%ecx
  80079b:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80079e:	83 c4 10             	add    $0x10,%esp
  8007a1:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8007a3:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8007a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8007aa:	eb 0f                	jmp    8007bb <vprintfmt+0x1c5>
					putch(padc, putdat);
  8007ac:	83 ec 08             	sub    $0x8,%esp
  8007af:	53                   	push   %ebx
  8007b0:	ff 75 e0             	pushl  -0x20(%ebp)
  8007b3:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007b5:	83 ef 01             	sub    $0x1,%edi
  8007b8:	83 c4 10             	add    $0x10,%esp
  8007bb:	85 ff                	test   %edi,%edi
  8007bd:	7f ed                	jg     8007ac <vprintfmt+0x1b6>
  8007bf:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8007c2:	85 c9                	test   %ecx,%ecx
  8007c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c9:	0f 49 c1             	cmovns %ecx,%eax
  8007cc:	29 c1                	sub    %eax,%ecx
  8007ce:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8007d1:	eb aa                	jmp    80077d <vprintfmt+0x187>
					putch(ch, putdat);
  8007d3:	83 ec 08             	sub    $0x8,%esp
  8007d6:	53                   	push   %ebx
  8007d7:	52                   	push   %edx
  8007d8:	ff d6                	call   *%esi
  8007da:	83 c4 10             	add    $0x10,%esp
  8007dd:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007e0:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007e2:	83 c7 01             	add    $0x1,%edi
  8007e5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007e9:	0f be d0             	movsbl %al,%edx
  8007ec:	85 d2                	test   %edx,%edx
  8007ee:	74 4b                	je     80083b <vprintfmt+0x245>
  8007f0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007f4:	78 06                	js     8007fc <vprintfmt+0x206>
  8007f6:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8007fa:	78 1e                	js     80081a <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8007fc:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800800:	74 d1                	je     8007d3 <vprintfmt+0x1dd>
  800802:	0f be c0             	movsbl %al,%eax
  800805:	83 e8 20             	sub    $0x20,%eax
  800808:	83 f8 5e             	cmp    $0x5e,%eax
  80080b:	76 c6                	jbe    8007d3 <vprintfmt+0x1dd>
					putch('?', putdat);
  80080d:	83 ec 08             	sub    $0x8,%esp
  800810:	53                   	push   %ebx
  800811:	6a 3f                	push   $0x3f
  800813:	ff d6                	call   *%esi
  800815:	83 c4 10             	add    $0x10,%esp
  800818:	eb c3                	jmp    8007dd <vprintfmt+0x1e7>
  80081a:	89 cf                	mov    %ecx,%edi
  80081c:	eb 0e                	jmp    80082c <vprintfmt+0x236>
				putch(' ', putdat);
  80081e:	83 ec 08             	sub    $0x8,%esp
  800821:	53                   	push   %ebx
  800822:	6a 20                	push   $0x20
  800824:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800826:	83 ef 01             	sub    $0x1,%edi
  800829:	83 c4 10             	add    $0x10,%esp
  80082c:	85 ff                	test   %edi,%edi
  80082e:	7f ee                	jg     80081e <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800830:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800833:	89 45 14             	mov    %eax,0x14(%ebp)
  800836:	e9 01 02 00 00       	jmp    800a3c <vprintfmt+0x446>
  80083b:	89 cf                	mov    %ecx,%edi
  80083d:	eb ed                	jmp    80082c <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80083f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800842:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800849:	e9 eb fd ff ff       	jmp    800639 <vprintfmt+0x43>
	if (lflag >= 2)
  80084e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800852:	7f 21                	jg     800875 <vprintfmt+0x27f>
	else if (lflag)
  800854:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800858:	74 68                	je     8008c2 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80085a:	8b 45 14             	mov    0x14(%ebp),%eax
  80085d:	8b 00                	mov    (%eax),%eax
  80085f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800862:	89 c1                	mov    %eax,%ecx
  800864:	c1 f9 1f             	sar    $0x1f,%ecx
  800867:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80086a:	8b 45 14             	mov    0x14(%ebp),%eax
  80086d:	8d 40 04             	lea    0x4(%eax),%eax
  800870:	89 45 14             	mov    %eax,0x14(%ebp)
  800873:	eb 17                	jmp    80088c <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	8b 50 04             	mov    0x4(%eax),%edx
  80087b:	8b 00                	mov    (%eax),%eax
  80087d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800880:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800883:	8b 45 14             	mov    0x14(%ebp),%eax
  800886:	8d 40 08             	lea    0x8(%eax),%eax
  800889:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80088c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80088f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800892:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800895:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800898:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80089c:	78 3f                	js     8008dd <vprintfmt+0x2e7>
			base = 10;
  80089e:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8008a3:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8008a7:	0f 84 71 01 00 00    	je     800a1e <vprintfmt+0x428>
				putch('+', putdat);
  8008ad:	83 ec 08             	sub    $0x8,%esp
  8008b0:	53                   	push   %ebx
  8008b1:	6a 2b                	push   $0x2b
  8008b3:	ff d6                	call   *%esi
  8008b5:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008b8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008bd:	e9 5c 01 00 00       	jmp    800a1e <vprintfmt+0x428>
		return va_arg(*ap, int);
  8008c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c5:	8b 00                	mov    (%eax),%eax
  8008c7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008ca:	89 c1                	mov    %eax,%ecx
  8008cc:	c1 f9 1f             	sar    $0x1f,%ecx
  8008cf:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8008d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d5:	8d 40 04             	lea    0x4(%eax),%eax
  8008d8:	89 45 14             	mov    %eax,0x14(%ebp)
  8008db:	eb af                	jmp    80088c <vprintfmt+0x296>
				putch('-', putdat);
  8008dd:	83 ec 08             	sub    $0x8,%esp
  8008e0:	53                   	push   %ebx
  8008e1:	6a 2d                	push   $0x2d
  8008e3:	ff d6                	call   *%esi
				num = -(long long) num;
  8008e5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008e8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8008eb:	f7 d8                	neg    %eax
  8008ed:	83 d2 00             	adc    $0x0,%edx
  8008f0:	f7 da                	neg    %edx
  8008f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008f5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008f8:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008fb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800900:	e9 19 01 00 00       	jmp    800a1e <vprintfmt+0x428>
	if (lflag >= 2)
  800905:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800909:	7f 29                	jg     800934 <vprintfmt+0x33e>
	else if (lflag)
  80090b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80090f:	74 44                	je     800955 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800911:	8b 45 14             	mov    0x14(%ebp),%eax
  800914:	8b 00                	mov    (%eax),%eax
  800916:	ba 00 00 00 00       	mov    $0x0,%edx
  80091b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80091e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800921:	8b 45 14             	mov    0x14(%ebp),%eax
  800924:	8d 40 04             	lea    0x4(%eax),%eax
  800927:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80092a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80092f:	e9 ea 00 00 00       	jmp    800a1e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800934:	8b 45 14             	mov    0x14(%ebp),%eax
  800937:	8b 50 04             	mov    0x4(%eax),%edx
  80093a:	8b 00                	mov    (%eax),%eax
  80093c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80093f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800942:	8b 45 14             	mov    0x14(%ebp),%eax
  800945:	8d 40 08             	lea    0x8(%eax),%eax
  800948:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80094b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800950:	e9 c9 00 00 00       	jmp    800a1e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800955:	8b 45 14             	mov    0x14(%ebp),%eax
  800958:	8b 00                	mov    (%eax),%eax
  80095a:	ba 00 00 00 00       	mov    $0x0,%edx
  80095f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800962:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800965:	8b 45 14             	mov    0x14(%ebp),%eax
  800968:	8d 40 04             	lea    0x4(%eax),%eax
  80096b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80096e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800973:	e9 a6 00 00 00       	jmp    800a1e <vprintfmt+0x428>
			putch('0', putdat);
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	53                   	push   %ebx
  80097c:	6a 30                	push   $0x30
  80097e:	ff d6                	call   *%esi
	if (lflag >= 2)
  800980:	83 c4 10             	add    $0x10,%esp
  800983:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800987:	7f 26                	jg     8009af <vprintfmt+0x3b9>
	else if (lflag)
  800989:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80098d:	74 3e                	je     8009cd <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80098f:	8b 45 14             	mov    0x14(%ebp),%eax
  800992:	8b 00                	mov    (%eax),%eax
  800994:	ba 00 00 00 00       	mov    $0x0,%edx
  800999:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80099c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80099f:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a2:	8d 40 04             	lea    0x4(%eax),%eax
  8009a5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009a8:	b8 08 00 00 00       	mov    $0x8,%eax
  8009ad:	eb 6f                	jmp    800a1e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8009af:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b2:	8b 50 04             	mov    0x4(%eax),%edx
  8009b5:	8b 00                	mov    (%eax),%eax
  8009b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009ba:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c0:	8d 40 08             	lea    0x8(%eax),%eax
  8009c3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009c6:	b8 08 00 00 00       	mov    $0x8,%eax
  8009cb:	eb 51                	jmp    800a1e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8009cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d0:	8b 00                	mov    (%eax),%eax
  8009d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009da:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e0:	8d 40 04             	lea    0x4(%eax),%eax
  8009e3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009e6:	b8 08 00 00 00       	mov    $0x8,%eax
  8009eb:	eb 31                	jmp    800a1e <vprintfmt+0x428>
			putch('0', putdat);
  8009ed:	83 ec 08             	sub    $0x8,%esp
  8009f0:	53                   	push   %ebx
  8009f1:	6a 30                	push   $0x30
  8009f3:	ff d6                	call   *%esi
			putch('x', putdat);
  8009f5:	83 c4 08             	add    $0x8,%esp
  8009f8:	53                   	push   %ebx
  8009f9:	6a 78                	push   $0x78
  8009fb:	ff d6                	call   *%esi
			num = (unsigned long long)
  8009fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800a00:	8b 00                	mov    (%eax),%eax
  800a02:	ba 00 00 00 00       	mov    $0x0,%edx
  800a07:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a0a:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800a0d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a10:	8b 45 14             	mov    0x14(%ebp),%eax
  800a13:	8d 40 04             	lea    0x4(%eax),%eax
  800a16:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a19:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800a1e:	83 ec 0c             	sub    $0xc,%esp
  800a21:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800a25:	52                   	push   %edx
  800a26:	ff 75 e0             	pushl  -0x20(%ebp)
  800a29:	50                   	push   %eax
  800a2a:	ff 75 dc             	pushl  -0x24(%ebp)
  800a2d:	ff 75 d8             	pushl  -0x28(%ebp)
  800a30:	89 da                	mov    %ebx,%edx
  800a32:	89 f0                	mov    %esi,%eax
  800a34:	e8 a4 fa ff ff       	call   8004dd <printnum>
			break;
  800a39:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800a3c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a3f:	83 c7 01             	add    $0x1,%edi
  800a42:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a46:	83 f8 25             	cmp    $0x25,%eax
  800a49:	0f 84 be fb ff ff    	je     80060d <vprintfmt+0x17>
			if (ch == '\0')
  800a4f:	85 c0                	test   %eax,%eax
  800a51:	0f 84 28 01 00 00    	je     800b7f <vprintfmt+0x589>
			putch(ch, putdat);
  800a57:	83 ec 08             	sub    $0x8,%esp
  800a5a:	53                   	push   %ebx
  800a5b:	50                   	push   %eax
  800a5c:	ff d6                	call   *%esi
  800a5e:	83 c4 10             	add    $0x10,%esp
  800a61:	eb dc                	jmp    800a3f <vprintfmt+0x449>
	if (lflag >= 2)
  800a63:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800a67:	7f 26                	jg     800a8f <vprintfmt+0x499>
	else if (lflag)
  800a69:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a6d:	74 41                	je     800ab0 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800a6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a72:	8b 00                	mov    (%eax),%eax
  800a74:	ba 00 00 00 00       	mov    $0x0,%edx
  800a79:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a7c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a82:	8d 40 04             	lea    0x4(%eax),%eax
  800a85:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a88:	b8 10 00 00 00       	mov    $0x10,%eax
  800a8d:	eb 8f                	jmp    800a1e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800a8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a92:	8b 50 04             	mov    0x4(%eax),%edx
  800a95:	8b 00                	mov    (%eax),%eax
  800a97:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a9a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa0:	8d 40 08             	lea    0x8(%eax),%eax
  800aa3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800aa6:	b8 10 00 00 00       	mov    $0x10,%eax
  800aab:	e9 6e ff ff ff       	jmp    800a1e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800ab0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab3:	8b 00                	mov    (%eax),%eax
  800ab5:	ba 00 00 00 00       	mov    $0x0,%edx
  800aba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800abd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ac0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac3:	8d 40 04             	lea    0x4(%eax),%eax
  800ac6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ac9:	b8 10 00 00 00       	mov    $0x10,%eax
  800ace:	e9 4b ff ff ff       	jmp    800a1e <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800ad3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad6:	83 c0 04             	add    $0x4,%eax
  800ad9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800adc:	8b 45 14             	mov    0x14(%ebp),%eax
  800adf:	8b 00                	mov    (%eax),%eax
  800ae1:	85 c0                	test   %eax,%eax
  800ae3:	74 14                	je     800af9 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800ae5:	8b 13                	mov    (%ebx),%edx
  800ae7:	83 fa 7f             	cmp    $0x7f,%edx
  800aea:	7f 37                	jg     800b23 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800aec:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800aee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800af1:	89 45 14             	mov    %eax,0x14(%ebp)
  800af4:	e9 43 ff ff ff       	jmp    800a3c <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800af9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800afe:	bf b9 2c 80 00       	mov    $0x802cb9,%edi
							putch(ch, putdat);
  800b03:	83 ec 08             	sub    $0x8,%esp
  800b06:	53                   	push   %ebx
  800b07:	50                   	push   %eax
  800b08:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800b0a:	83 c7 01             	add    $0x1,%edi
  800b0d:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800b11:	83 c4 10             	add    $0x10,%esp
  800b14:	85 c0                	test   %eax,%eax
  800b16:	75 eb                	jne    800b03 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800b18:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b1b:	89 45 14             	mov    %eax,0x14(%ebp)
  800b1e:	e9 19 ff ff ff       	jmp    800a3c <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800b23:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800b25:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b2a:	bf f1 2c 80 00       	mov    $0x802cf1,%edi
							putch(ch, putdat);
  800b2f:	83 ec 08             	sub    $0x8,%esp
  800b32:	53                   	push   %ebx
  800b33:	50                   	push   %eax
  800b34:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800b36:	83 c7 01             	add    $0x1,%edi
  800b39:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800b3d:	83 c4 10             	add    $0x10,%esp
  800b40:	85 c0                	test   %eax,%eax
  800b42:	75 eb                	jne    800b2f <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800b44:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b47:	89 45 14             	mov    %eax,0x14(%ebp)
  800b4a:	e9 ed fe ff ff       	jmp    800a3c <vprintfmt+0x446>
			putch(ch, putdat);
  800b4f:	83 ec 08             	sub    $0x8,%esp
  800b52:	53                   	push   %ebx
  800b53:	6a 25                	push   $0x25
  800b55:	ff d6                	call   *%esi
			break;
  800b57:	83 c4 10             	add    $0x10,%esp
  800b5a:	e9 dd fe ff ff       	jmp    800a3c <vprintfmt+0x446>
			putch('%', putdat);
  800b5f:	83 ec 08             	sub    $0x8,%esp
  800b62:	53                   	push   %ebx
  800b63:	6a 25                	push   $0x25
  800b65:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b67:	83 c4 10             	add    $0x10,%esp
  800b6a:	89 f8                	mov    %edi,%eax
  800b6c:	eb 03                	jmp    800b71 <vprintfmt+0x57b>
  800b6e:	83 e8 01             	sub    $0x1,%eax
  800b71:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b75:	75 f7                	jne    800b6e <vprintfmt+0x578>
  800b77:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b7a:	e9 bd fe ff ff       	jmp    800a3c <vprintfmt+0x446>
}
  800b7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b82:	5b                   	pop    %ebx
  800b83:	5e                   	pop    %esi
  800b84:	5f                   	pop    %edi
  800b85:	5d                   	pop    %ebp
  800b86:	c3                   	ret    

00800b87 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	83 ec 18             	sub    $0x18,%esp
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b93:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b96:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b9a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b9d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ba4:	85 c0                	test   %eax,%eax
  800ba6:	74 26                	je     800bce <vsnprintf+0x47>
  800ba8:	85 d2                	test   %edx,%edx
  800baa:	7e 22                	jle    800bce <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bac:	ff 75 14             	pushl  0x14(%ebp)
  800baf:	ff 75 10             	pushl  0x10(%ebp)
  800bb2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bb5:	50                   	push   %eax
  800bb6:	68 bc 05 80 00       	push   $0x8005bc
  800bbb:	e8 36 fa ff ff       	call   8005f6 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800bc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bc3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bc9:	83 c4 10             	add    $0x10,%esp
}
  800bcc:	c9                   	leave  
  800bcd:	c3                   	ret    
		return -E_INVAL;
  800bce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bd3:	eb f7                	jmp    800bcc <vsnprintf+0x45>

00800bd5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bdb:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800bde:	50                   	push   %eax
  800bdf:	ff 75 10             	pushl  0x10(%ebp)
  800be2:	ff 75 0c             	pushl  0xc(%ebp)
  800be5:	ff 75 08             	pushl  0x8(%ebp)
  800be8:	e8 9a ff ff ff       	call   800b87 <vsnprintf>
	va_end(ap);

	return rc;
}
  800bed:	c9                   	leave  
  800bee:	c3                   	ret    

00800bef <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800bef:	55                   	push   %ebp
  800bf0:	89 e5                	mov    %esp,%ebp
  800bf2:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800bf5:	b8 00 00 00 00       	mov    $0x0,%eax
  800bfa:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800bfe:	74 05                	je     800c05 <strlen+0x16>
		n++;
  800c00:	83 c0 01             	add    $0x1,%eax
  800c03:	eb f5                	jmp    800bfa <strlen+0xb>
	return n;
}
  800c05:	5d                   	pop    %ebp
  800c06:	c3                   	ret    

00800c07 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c10:	ba 00 00 00 00       	mov    $0x0,%edx
  800c15:	39 c2                	cmp    %eax,%edx
  800c17:	74 0d                	je     800c26 <strnlen+0x1f>
  800c19:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800c1d:	74 05                	je     800c24 <strnlen+0x1d>
		n++;
  800c1f:	83 c2 01             	add    $0x1,%edx
  800c22:	eb f1                	jmp    800c15 <strnlen+0xe>
  800c24:	89 d0                	mov    %edx,%eax
	return n;
}
  800c26:	5d                   	pop    %ebp
  800c27:	c3                   	ret    

00800c28 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c28:	55                   	push   %ebp
  800c29:	89 e5                	mov    %esp,%ebp
  800c2b:	53                   	push   %ebx
  800c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c32:	ba 00 00 00 00       	mov    $0x0,%edx
  800c37:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800c3b:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800c3e:	83 c2 01             	add    $0x1,%edx
  800c41:	84 c9                	test   %cl,%cl
  800c43:	75 f2                	jne    800c37 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800c45:	5b                   	pop    %ebx
  800c46:	5d                   	pop    %ebp
  800c47:	c3                   	ret    

00800c48 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c48:	55                   	push   %ebp
  800c49:	89 e5                	mov    %esp,%ebp
  800c4b:	53                   	push   %ebx
  800c4c:	83 ec 10             	sub    $0x10,%esp
  800c4f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c52:	53                   	push   %ebx
  800c53:	e8 97 ff ff ff       	call   800bef <strlen>
  800c58:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800c5b:	ff 75 0c             	pushl  0xc(%ebp)
  800c5e:	01 d8                	add    %ebx,%eax
  800c60:	50                   	push   %eax
  800c61:	e8 c2 ff ff ff       	call   800c28 <strcpy>
	return dst;
}
  800c66:	89 d8                	mov    %ebx,%eax
  800c68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c6b:	c9                   	leave  
  800c6c:	c3                   	ret    

00800c6d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	56                   	push   %esi
  800c71:	53                   	push   %ebx
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c78:	89 c6                	mov    %eax,%esi
  800c7a:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c7d:	89 c2                	mov    %eax,%edx
  800c7f:	39 f2                	cmp    %esi,%edx
  800c81:	74 11                	je     800c94 <strncpy+0x27>
		*dst++ = *src;
  800c83:	83 c2 01             	add    $0x1,%edx
  800c86:	0f b6 19             	movzbl (%ecx),%ebx
  800c89:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c8c:	80 fb 01             	cmp    $0x1,%bl
  800c8f:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800c92:	eb eb                	jmp    800c7f <strncpy+0x12>
	}
	return ret;
}
  800c94:	5b                   	pop    %ebx
  800c95:	5e                   	pop    %esi
  800c96:	5d                   	pop    %ebp
  800c97:	c3                   	ret    

00800c98 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c98:	55                   	push   %ebp
  800c99:	89 e5                	mov    %esp,%ebp
  800c9b:	56                   	push   %esi
  800c9c:	53                   	push   %ebx
  800c9d:	8b 75 08             	mov    0x8(%ebp),%esi
  800ca0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca3:	8b 55 10             	mov    0x10(%ebp),%edx
  800ca6:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ca8:	85 d2                	test   %edx,%edx
  800caa:	74 21                	je     800ccd <strlcpy+0x35>
  800cac:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800cb0:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800cb2:	39 c2                	cmp    %eax,%edx
  800cb4:	74 14                	je     800cca <strlcpy+0x32>
  800cb6:	0f b6 19             	movzbl (%ecx),%ebx
  800cb9:	84 db                	test   %bl,%bl
  800cbb:	74 0b                	je     800cc8 <strlcpy+0x30>
			*dst++ = *src++;
  800cbd:	83 c1 01             	add    $0x1,%ecx
  800cc0:	83 c2 01             	add    $0x1,%edx
  800cc3:	88 5a ff             	mov    %bl,-0x1(%edx)
  800cc6:	eb ea                	jmp    800cb2 <strlcpy+0x1a>
  800cc8:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800cca:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ccd:	29 f0                	sub    %esi,%eax
}
  800ccf:	5b                   	pop    %ebx
  800cd0:	5e                   	pop    %esi
  800cd1:	5d                   	pop    %ebp
  800cd2:	c3                   	ret    

00800cd3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cd9:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800cdc:	0f b6 01             	movzbl (%ecx),%eax
  800cdf:	84 c0                	test   %al,%al
  800ce1:	74 0c                	je     800cef <strcmp+0x1c>
  800ce3:	3a 02                	cmp    (%edx),%al
  800ce5:	75 08                	jne    800cef <strcmp+0x1c>
		p++, q++;
  800ce7:	83 c1 01             	add    $0x1,%ecx
  800cea:	83 c2 01             	add    $0x1,%edx
  800ced:	eb ed                	jmp    800cdc <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cef:	0f b6 c0             	movzbl %al,%eax
  800cf2:	0f b6 12             	movzbl (%edx),%edx
  800cf5:	29 d0                	sub    %edx,%eax
}
  800cf7:	5d                   	pop    %ebp
  800cf8:	c3                   	ret    

00800cf9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800cf9:	55                   	push   %ebp
  800cfa:	89 e5                	mov    %esp,%ebp
  800cfc:	53                   	push   %ebx
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d03:	89 c3                	mov    %eax,%ebx
  800d05:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d08:	eb 06                	jmp    800d10 <strncmp+0x17>
		n--, p++, q++;
  800d0a:	83 c0 01             	add    $0x1,%eax
  800d0d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800d10:	39 d8                	cmp    %ebx,%eax
  800d12:	74 16                	je     800d2a <strncmp+0x31>
  800d14:	0f b6 08             	movzbl (%eax),%ecx
  800d17:	84 c9                	test   %cl,%cl
  800d19:	74 04                	je     800d1f <strncmp+0x26>
  800d1b:	3a 0a                	cmp    (%edx),%cl
  800d1d:	74 eb                	je     800d0a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d1f:	0f b6 00             	movzbl (%eax),%eax
  800d22:	0f b6 12             	movzbl (%edx),%edx
  800d25:	29 d0                	sub    %edx,%eax
}
  800d27:	5b                   	pop    %ebx
  800d28:	5d                   	pop    %ebp
  800d29:	c3                   	ret    
		return 0;
  800d2a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2f:	eb f6                	jmp    800d27 <strncmp+0x2e>

00800d31 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d31:	55                   	push   %ebp
  800d32:	89 e5                	mov    %esp,%ebp
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d3b:	0f b6 10             	movzbl (%eax),%edx
  800d3e:	84 d2                	test   %dl,%dl
  800d40:	74 09                	je     800d4b <strchr+0x1a>
		if (*s == c)
  800d42:	38 ca                	cmp    %cl,%dl
  800d44:	74 0a                	je     800d50 <strchr+0x1f>
	for (; *s; s++)
  800d46:	83 c0 01             	add    $0x1,%eax
  800d49:	eb f0                	jmp    800d3b <strchr+0xa>
			return (char *) s;
	return 0;
  800d4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d50:	5d                   	pop    %ebp
  800d51:	c3                   	ret    

00800d52 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d52:	55                   	push   %ebp
  800d53:	89 e5                	mov    %esp,%ebp
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d5c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d5f:	38 ca                	cmp    %cl,%dl
  800d61:	74 09                	je     800d6c <strfind+0x1a>
  800d63:	84 d2                	test   %dl,%dl
  800d65:	74 05                	je     800d6c <strfind+0x1a>
	for (; *s; s++)
  800d67:	83 c0 01             	add    $0x1,%eax
  800d6a:	eb f0                	jmp    800d5c <strfind+0xa>
			break;
	return (char *) s;
}
  800d6c:	5d                   	pop    %ebp
  800d6d:	c3                   	ret    

00800d6e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d6e:	55                   	push   %ebp
  800d6f:	89 e5                	mov    %esp,%ebp
  800d71:	57                   	push   %edi
  800d72:	56                   	push   %esi
  800d73:	53                   	push   %ebx
  800d74:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d77:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d7a:	85 c9                	test   %ecx,%ecx
  800d7c:	74 31                	je     800daf <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d7e:	89 f8                	mov    %edi,%eax
  800d80:	09 c8                	or     %ecx,%eax
  800d82:	a8 03                	test   $0x3,%al
  800d84:	75 23                	jne    800da9 <memset+0x3b>
		c &= 0xFF;
  800d86:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d8a:	89 d3                	mov    %edx,%ebx
  800d8c:	c1 e3 08             	shl    $0x8,%ebx
  800d8f:	89 d0                	mov    %edx,%eax
  800d91:	c1 e0 18             	shl    $0x18,%eax
  800d94:	89 d6                	mov    %edx,%esi
  800d96:	c1 e6 10             	shl    $0x10,%esi
  800d99:	09 f0                	or     %esi,%eax
  800d9b:	09 c2                	or     %eax,%edx
  800d9d:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d9f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800da2:	89 d0                	mov    %edx,%eax
  800da4:	fc                   	cld    
  800da5:	f3 ab                	rep stos %eax,%es:(%edi)
  800da7:	eb 06                	jmp    800daf <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800da9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dac:	fc                   	cld    
  800dad:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800daf:	89 f8                	mov    %edi,%eax
  800db1:	5b                   	pop    %ebx
  800db2:	5e                   	pop    %esi
  800db3:	5f                   	pop    %edi
  800db4:	5d                   	pop    %ebp
  800db5:	c3                   	ret    

00800db6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800db6:	55                   	push   %ebp
  800db7:	89 e5                	mov    %esp,%ebp
  800db9:	57                   	push   %edi
  800dba:	56                   	push   %esi
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dc1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dc4:	39 c6                	cmp    %eax,%esi
  800dc6:	73 32                	jae    800dfa <memmove+0x44>
  800dc8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800dcb:	39 c2                	cmp    %eax,%edx
  800dcd:	76 2b                	jbe    800dfa <memmove+0x44>
		s += n;
		d += n;
  800dcf:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dd2:	89 fe                	mov    %edi,%esi
  800dd4:	09 ce                	or     %ecx,%esi
  800dd6:	09 d6                	or     %edx,%esi
  800dd8:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800dde:	75 0e                	jne    800dee <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800de0:	83 ef 04             	sub    $0x4,%edi
  800de3:	8d 72 fc             	lea    -0x4(%edx),%esi
  800de6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800de9:	fd                   	std    
  800dea:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800dec:	eb 09                	jmp    800df7 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800dee:	83 ef 01             	sub    $0x1,%edi
  800df1:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800df4:	fd                   	std    
  800df5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800df7:	fc                   	cld    
  800df8:	eb 1a                	jmp    800e14 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dfa:	89 c2                	mov    %eax,%edx
  800dfc:	09 ca                	or     %ecx,%edx
  800dfe:	09 f2                	or     %esi,%edx
  800e00:	f6 c2 03             	test   $0x3,%dl
  800e03:	75 0a                	jne    800e0f <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e05:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800e08:	89 c7                	mov    %eax,%edi
  800e0a:	fc                   	cld    
  800e0b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e0d:	eb 05                	jmp    800e14 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800e0f:	89 c7                	mov    %eax,%edi
  800e11:	fc                   	cld    
  800e12:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e14:	5e                   	pop    %esi
  800e15:	5f                   	pop    %edi
  800e16:	5d                   	pop    %ebp
  800e17:	c3                   	ret    

00800e18 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e18:	55                   	push   %ebp
  800e19:	89 e5                	mov    %esp,%ebp
  800e1b:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e1e:	ff 75 10             	pushl  0x10(%ebp)
  800e21:	ff 75 0c             	pushl  0xc(%ebp)
  800e24:	ff 75 08             	pushl  0x8(%ebp)
  800e27:	e8 8a ff ff ff       	call   800db6 <memmove>
}
  800e2c:	c9                   	leave  
  800e2d:	c3                   	ret    

00800e2e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e2e:	55                   	push   %ebp
  800e2f:	89 e5                	mov    %esp,%ebp
  800e31:	56                   	push   %esi
  800e32:	53                   	push   %ebx
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e39:	89 c6                	mov    %eax,%esi
  800e3b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e3e:	39 f0                	cmp    %esi,%eax
  800e40:	74 1c                	je     800e5e <memcmp+0x30>
		if (*s1 != *s2)
  800e42:	0f b6 08             	movzbl (%eax),%ecx
  800e45:	0f b6 1a             	movzbl (%edx),%ebx
  800e48:	38 d9                	cmp    %bl,%cl
  800e4a:	75 08                	jne    800e54 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e4c:	83 c0 01             	add    $0x1,%eax
  800e4f:	83 c2 01             	add    $0x1,%edx
  800e52:	eb ea                	jmp    800e3e <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800e54:	0f b6 c1             	movzbl %cl,%eax
  800e57:	0f b6 db             	movzbl %bl,%ebx
  800e5a:	29 d8                	sub    %ebx,%eax
  800e5c:	eb 05                	jmp    800e63 <memcmp+0x35>
	}

	return 0;
  800e5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e63:	5b                   	pop    %ebx
  800e64:	5e                   	pop    %esi
  800e65:	5d                   	pop    %ebp
  800e66:	c3                   	ret    

00800e67 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e70:	89 c2                	mov    %eax,%edx
  800e72:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e75:	39 d0                	cmp    %edx,%eax
  800e77:	73 09                	jae    800e82 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e79:	38 08                	cmp    %cl,(%eax)
  800e7b:	74 05                	je     800e82 <memfind+0x1b>
	for (; s < ends; s++)
  800e7d:	83 c0 01             	add    $0x1,%eax
  800e80:	eb f3                	jmp    800e75 <memfind+0xe>
			break;
	return (void *) s;
}
  800e82:	5d                   	pop    %ebp
  800e83:	c3                   	ret    

00800e84 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e84:	55                   	push   %ebp
  800e85:	89 e5                	mov    %esp,%ebp
  800e87:	57                   	push   %edi
  800e88:	56                   	push   %esi
  800e89:	53                   	push   %ebx
  800e8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e8d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e90:	eb 03                	jmp    800e95 <strtol+0x11>
		s++;
  800e92:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e95:	0f b6 01             	movzbl (%ecx),%eax
  800e98:	3c 20                	cmp    $0x20,%al
  800e9a:	74 f6                	je     800e92 <strtol+0xe>
  800e9c:	3c 09                	cmp    $0x9,%al
  800e9e:	74 f2                	je     800e92 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ea0:	3c 2b                	cmp    $0x2b,%al
  800ea2:	74 2a                	je     800ece <strtol+0x4a>
	int neg = 0;
  800ea4:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ea9:	3c 2d                	cmp    $0x2d,%al
  800eab:	74 2b                	je     800ed8 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ead:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800eb3:	75 0f                	jne    800ec4 <strtol+0x40>
  800eb5:	80 39 30             	cmpb   $0x30,(%ecx)
  800eb8:	74 28                	je     800ee2 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800eba:	85 db                	test   %ebx,%ebx
  800ebc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ec1:	0f 44 d8             	cmove  %eax,%ebx
  800ec4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ecc:	eb 50                	jmp    800f1e <strtol+0x9a>
		s++;
  800ece:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ed1:	bf 00 00 00 00       	mov    $0x0,%edi
  800ed6:	eb d5                	jmp    800ead <strtol+0x29>
		s++, neg = 1;
  800ed8:	83 c1 01             	add    $0x1,%ecx
  800edb:	bf 01 00 00 00       	mov    $0x1,%edi
  800ee0:	eb cb                	jmp    800ead <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ee2:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ee6:	74 0e                	je     800ef6 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ee8:	85 db                	test   %ebx,%ebx
  800eea:	75 d8                	jne    800ec4 <strtol+0x40>
		s++, base = 8;
  800eec:	83 c1 01             	add    $0x1,%ecx
  800eef:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ef4:	eb ce                	jmp    800ec4 <strtol+0x40>
		s += 2, base = 16;
  800ef6:	83 c1 02             	add    $0x2,%ecx
  800ef9:	bb 10 00 00 00       	mov    $0x10,%ebx
  800efe:	eb c4                	jmp    800ec4 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800f00:	8d 72 9f             	lea    -0x61(%edx),%esi
  800f03:	89 f3                	mov    %esi,%ebx
  800f05:	80 fb 19             	cmp    $0x19,%bl
  800f08:	77 29                	ja     800f33 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800f0a:	0f be d2             	movsbl %dl,%edx
  800f0d:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f10:	3b 55 10             	cmp    0x10(%ebp),%edx
  800f13:	7d 30                	jge    800f45 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800f15:	83 c1 01             	add    $0x1,%ecx
  800f18:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f1c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800f1e:	0f b6 11             	movzbl (%ecx),%edx
  800f21:	8d 72 d0             	lea    -0x30(%edx),%esi
  800f24:	89 f3                	mov    %esi,%ebx
  800f26:	80 fb 09             	cmp    $0x9,%bl
  800f29:	77 d5                	ja     800f00 <strtol+0x7c>
			dig = *s - '0';
  800f2b:	0f be d2             	movsbl %dl,%edx
  800f2e:	83 ea 30             	sub    $0x30,%edx
  800f31:	eb dd                	jmp    800f10 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800f33:	8d 72 bf             	lea    -0x41(%edx),%esi
  800f36:	89 f3                	mov    %esi,%ebx
  800f38:	80 fb 19             	cmp    $0x19,%bl
  800f3b:	77 08                	ja     800f45 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800f3d:	0f be d2             	movsbl %dl,%edx
  800f40:	83 ea 37             	sub    $0x37,%edx
  800f43:	eb cb                	jmp    800f10 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f45:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f49:	74 05                	je     800f50 <strtol+0xcc>
		*endptr = (char *) s;
  800f4b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f4e:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f50:	89 c2                	mov    %eax,%edx
  800f52:	f7 da                	neg    %edx
  800f54:	85 ff                	test   %edi,%edi
  800f56:	0f 45 c2             	cmovne %edx,%eax
}
  800f59:	5b                   	pop    %ebx
  800f5a:	5e                   	pop    %esi
  800f5b:	5f                   	pop    %edi
  800f5c:	5d                   	pop    %ebp
  800f5d:	c3                   	ret    

00800f5e <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	57                   	push   %edi
  800f62:	56                   	push   %esi
  800f63:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f64:	b8 00 00 00 00       	mov    $0x0,%eax
  800f69:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6f:	89 c3                	mov    %eax,%ebx
  800f71:	89 c7                	mov    %eax,%edi
  800f73:	89 c6                	mov    %eax,%esi
  800f75:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f77:	5b                   	pop    %ebx
  800f78:	5e                   	pop    %esi
  800f79:	5f                   	pop    %edi
  800f7a:	5d                   	pop    %ebp
  800f7b:	c3                   	ret    

00800f7c <sys_cgetc>:

int
sys_cgetc(void)
{
  800f7c:	55                   	push   %ebp
  800f7d:	89 e5                	mov    %esp,%ebp
  800f7f:	57                   	push   %edi
  800f80:	56                   	push   %esi
  800f81:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f82:	ba 00 00 00 00       	mov    $0x0,%edx
  800f87:	b8 01 00 00 00       	mov    $0x1,%eax
  800f8c:	89 d1                	mov    %edx,%ecx
  800f8e:	89 d3                	mov    %edx,%ebx
  800f90:	89 d7                	mov    %edx,%edi
  800f92:	89 d6                	mov    %edx,%esi
  800f94:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f96:	5b                   	pop    %ebx
  800f97:	5e                   	pop    %esi
  800f98:	5f                   	pop    %edi
  800f99:	5d                   	pop    %ebp
  800f9a:	c3                   	ret    

00800f9b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f9b:	55                   	push   %ebp
  800f9c:	89 e5                	mov    %esp,%ebp
  800f9e:	57                   	push   %edi
  800f9f:	56                   	push   %esi
  800fa0:	53                   	push   %ebx
  800fa1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fa4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fa9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fac:	b8 03 00 00 00       	mov    $0x3,%eax
  800fb1:	89 cb                	mov    %ecx,%ebx
  800fb3:	89 cf                	mov    %ecx,%edi
  800fb5:	89 ce                	mov    %ecx,%esi
  800fb7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fb9:	85 c0                	test   %eax,%eax
  800fbb:	7f 08                	jg     800fc5 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800fbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc0:	5b                   	pop    %ebx
  800fc1:	5e                   	pop    %esi
  800fc2:	5f                   	pop    %edi
  800fc3:	5d                   	pop    %ebp
  800fc4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc5:	83 ec 0c             	sub    $0xc,%esp
  800fc8:	50                   	push   %eax
  800fc9:	6a 03                	push   $0x3
  800fcb:	68 08 2f 80 00       	push   $0x802f08
  800fd0:	6a 43                	push   $0x43
  800fd2:	68 25 2f 80 00       	push   $0x802f25
  800fd7:	e8 f7 f3 ff ff       	call   8003d3 <_panic>

00800fdc <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	57                   	push   %edi
  800fe0:	56                   	push   %esi
  800fe1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fe2:	ba 00 00 00 00       	mov    $0x0,%edx
  800fe7:	b8 02 00 00 00       	mov    $0x2,%eax
  800fec:	89 d1                	mov    %edx,%ecx
  800fee:	89 d3                	mov    %edx,%ebx
  800ff0:	89 d7                	mov    %edx,%edi
  800ff2:	89 d6                	mov    %edx,%esi
  800ff4:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ff6:	5b                   	pop    %ebx
  800ff7:	5e                   	pop    %esi
  800ff8:	5f                   	pop    %edi
  800ff9:	5d                   	pop    %ebp
  800ffa:	c3                   	ret    

00800ffb <sys_yield>:

void
sys_yield(void)
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	57                   	push   %edi
  800fff:	56                   	push   %esi
  801000:	53                   	push   %ebx
	asm volatile("int %1\n"
  801001:	ba 00 00 00 00       	mov    $0x0,%edx
  801006:	b8 0b 00 00 00       	mov    $0xb,%eax
  80100b:	89 d1                	mov    %edx,%ecx
  80100d:	89 d3                	mov    %edx,%ebx
  80100f:	89 d7                	mov    %edx,%edi
  801011:	89 d6                	mov    %edx,%esi
  801013:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801015:	5b                   	pop    %ebx
  801016:	5e                   	pop    %esi
  801017:	5f                   	pop    %edi
  801018:	5d                   	pop    %ebp
  801019:	c3                   	ret    

0080101a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80101a:	55                   	push   %ebp
  80101b:	89 e5                	mov    %esp,%ebp
  80101d:	57                   	push   %edi
  80101e:	56                   	push   %esi
  80101f:	53                   	push   %ebx
  801020:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801023:	be 00 00 00 00       	mov    $0x0,%esi
  801028:	8b 55 08             	mov    0x8(%ebp),%edx
  80102b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80102e:	b8 04 00 00 00       	mov    $0x4,%eax
  801033:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801036:	89 f7                	mov    %esi,%edi
  801038:	cd 30                	int    $0x30
	if(check && ret > 0)
  80103a:	85 c0                	test   %eax,%eax
  80103c:	7f 08                	jg     801046 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80103e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801041:	5b                   	pop    %ebx
  801042:	5e                   	pop    %esi
  801043:	5f                   	pop    %edi
  801044:	5d                   	pop    %ebp
  801045:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801046:	83 ec 0c             	sub    $0xc,%esp
  801049:	50                   	push   %eax
  80104a:	6a 04                	push   $0x4
  80104c:	68 08 2f 80 00       	push   $0x802f08
  801051:	6a 43                	push   $0x43
  801053:	68 25 2f 80 00       	push   $0x802f25
  801058:	e8 76 f3 ff ff       	call   8003d3 <_panic>

0080105d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80105d:	55                   	push   %ebp
  80105e:	89 e5                	mov    %esp,%ebp
  801060:	57                   	push   %edi
  801061:	56                   	push   %esi
  801062:	53                   	push   %ebx
  801063:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801066:	8b 55 08             	mov    0x8(%ebp),%edx
  801069:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80106c:	b8 05 00 00 00       	mov    $0x5,%eax
  801071:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801074:	8b 7d 14             	mov    0x14(%ebp),%edi
  801077:	8b 75 18             	mov    0x18(%ebp),%esi
  80107a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80107c:	85 c0                	test   %eax,%eax
  80107e:	7f 08                	jg     801088 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801080:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801083:	5b                   	pop    %ebx
  801084:	5e                   	pop    %esi
  801085:	5f                   	pop    %edi
  801086:	5d                   	pop    %ebp
  801087:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801088:	83 ec 0c             	sub    $0xc,%esp
  80108b:	50                   	push   %eax
  80108c:	6a 05                	push   $0x5
  80108e:	68 08 2f 80 00       	push   $0x802f08
  801093:	6a 43                	push   $0x43
  801095:	68 25 2f 80 00       	push   $0x802f25
  80109a:	e8 34 f3 ff ff       	call   8003d3 <_panic>

0080109f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80109f:	55                   	push   %ebp
  8010a0:	89 e5                	mov    %esp,%ebp
  8010a2:	57                   	push   %edi
  8010a3:	56                   	push   %esi
  8010a4:	53                   	push   %ebx
  8010a5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010a8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b3:	b8 06 00 00 00       	mov    $0x6,%eax
  8010b8:	89 df                	mov    %ebx,%edi
  8010ba:	89 de                	mov    %ebx,%esi
  8010bc:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010be:	85 c0                	test   %eax,%eax
  8010c0:	7f 08                	jg     8010ca <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010c5:	5b                   	pop    %ebx
  8010c6:	5e                   	pop    %esi
  8010c7:	5f                   	pop    %edi
  8010c8:	5d                   	pop    %ebp
  8010c9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010ca:	83 ec 0c             	sub    $0xc,%esp
  8010cd:	50                   	push   %eax
  8010ce:	6a 06                	push   $0x6
  8010d0:	68 08 2f 80 00       	push   $0x802f08
  8010d5:	6a 43                	push   $0x43
  8010d7:	68 25 2f 80 00       	push   $0x802f25
  8010dc:	e8 f2 f2 ff ff       	call   8003d3 <_panic>

008010e1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8010e1:	55                   	push   %ebp
  8010e2:	89 e5                	mov    %esp,%ebp
  8010e4:	57                   	push   %edi
  8010e5:	56                   	push   %esi
  8010e6:	53                   	push   %ebx
  8010e7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010ea:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f5:	b8 08 00 00 00       	mov    $0x8,%eax
  8010fa:	89 df                	mov    %ebx,%edi
  8010fc:	89 de                	mov    %ebx,%esi
  8010fe:	cd 30                	int    $0x30
	if(check && ret > 0)
  801100:	85 c0                	test   %eax,%eax
  801102:	7f 08                	jg     80110c <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801104:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801107:	5b                   	pop    %ebx
  801108:	5e                   	pop    %esi
  801109:	5f                   	pop    %edi
  80110a:	5d                   	pop    %ebp
  80110b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80110c:	83 ec 0c             	sub    $0xc,%esp
  80110f:	50                   	push   %eax
  801110:	6a 08                	push   $0x8
  801112:	68 08 2f 80 00       	push   $0x802f08
  801117:	6a 43                	push   $0x43
  801119:	68 25 2f 80 00       	push   $0x802f25
  80111e:	e8 b0 f2 ff ff       	call   8003d3 <_panic>

00801123 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801123:	55                   	push   %ebp
  801124:	89 e5                	mov    %esp,%ebp
  801126:	57                   	push   %edi
  801127:	56                   	push   %esi
  801128:	53                   	push   %ebx
  801129:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80112c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801131:	8b 55 08             	mov    0x8(%ebp),%edx
  801134:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801137:	b8 09 00 00 00       	mov    $0x9,%eax
  80113c:	89 df                	mov    %ebx,%edi
  80113e:	89 de                	mov    %ebx,%esi
  801140:	cd 30                	int    $0x30
	if(check && ret > 0)
  801142:	85 c0                	test   %eax,%eax
  801144:	7f 08                	jg     80114e <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801146:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801149:	5b                   	pop    %ebx
  80114a:	5e                   	pop    %esi
  80114b:	5f                   	pop    %edi
  80114c:	5d                   	pop    %ebp
  80114d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80114e:	83 ec 0c             	sub    $0xc,%esp
  801151:	50                   	push   %eax
  801152:	6a 09                	push   $0x9
  801154:	68 08 2f 80 00       	push   $0x802f08
  801159:	6a 43                	push   $0x43
  80115b:	68 25 2f 80 00       	push   $0x802f25
  801160:	e8 6e f2 ff ff       	call   8003d3 <_panic>

00801165 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801165:	55                   	push   %ebp
  801166:	89 e5                	mov    %esp,%ebp
  801168:	57                   	push   %edi
  801169:	56                   	push   %esi
  80116a:	53                   	push   %ebx
  80116b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80116e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801173:	8b 55 08             	mov    0x8(%ebp),%edx
  801176:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801179:	b8 0a 00 00 00       	mov    $0xa,%eax
  80117e:	89 df                	mov    %ebx,%edi
  801180:	89 de                	mov    %ebx,%esi
  801182:	cd 30                	int    $0x30
	if(check && ret > 0)
  801184:	85 c0                	test   %eax,%eax
  801186:	7f 08                	jg     801190 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801188:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80118b:	5b                   	pop    %ebx
  80118c:	5e                   	pop    %esi
  80118d:	5f                   	pop    %edi
  80118e:	5d                   	pop    %ebp
  80118f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801190:	83 ec 0c             	sub    $0xc,%esp
  801193:	50                   	push   %eax
  801194:	6a 0a                	push   $0xa
  801196:	68 08 2f 80 00       	push   $0x802f08
  80119b:	6a 43                	push   $0x43
  80119d:	68 25 2f 80 00       	push   $0x802f25
  8011a2:	e8 2c f2 ff ff       	call   8003d3 <_panic>

008011a7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
  8011aa:	57                   	push   %edi
  8011ab:	56                   	push   %esi
  8011ac:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011b3:	b8 0c 00 00 00       	mov    $0xc,%eax
  8011b8:	be 00 00 00 00       	mov    $0x0,%esi
  8011bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011c0:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011c3:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8011c5:	5b                   	pop    %ebx
  8011c6:	5e                   	pop    %esi
  8011c7:	5f                   	pop    %edi
  8011c8:	5d                   	pop    %ebp
  8011c9:	c3                   	ret    

008011ca <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
  8011cd:	57                   	push   %edi
  8011ce:	56                   	push   %esi
  8011cf:	53                   	push   %ebx
  8011d0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011d3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011db:	b8 0d 00 00 00       	mov    $0xd,%eax
  8011e0:	89 cb                	mov    %ecx,%ebx
  8011e2:	89 cf                	mov    %ecx,%edi
  8011e4:	89 ce                	mov    %ecx,%esi
  8011e6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011e8:	85 c0                	test   %eax,%eax
  8011ea:	7f 08                	jg     8011f4 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8011ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011ef:	5b                   	pop    %ebx
  8011f0:	5e                   	pop    %esi
  8011f1:	5f                   	pop    %edi
  8011f2:	5d                   	pop    %ebp
  8011f3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011f4:	83 ec 0c             	sub    $0xc,%esp
  8011f7:	50                   	push   %eax
  8011f8:	6a 0d                	push   $0xd
  8011fa:	68 08 2f 80 00       	push   $0x802f08
  8011ff:	6a 43                	push   $0x43
  801201:	68 25 2f 80 00       	push   $0x802f25
  801206:	e8 c8 f1 ff ff       	call   8003d3 <_panic>

0080120b <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
  80120e:	57                   	push   %edi
  80120f:	56                   	push   %esi
  801210:	53                   	push   %ebx
	asm volatile("int %1\n"
  801211:	bb 00 00 00 00       	mov    $0x0,%ebx
  801216:	8b 55 08             	mov    0x8(%ebp),%edx
  801219:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80121c:	b8 0e 00 00 00       	mov    $0xe,%eax
  801221:	89 df                	mov    %ebx,%edi
  801223:	89 de                	mov    %ebx,%esi
  801225:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801227:	5b                   	pop    %ebx
  801228:	5e                   	pop    %esi
  801229:	5f                   	pop    %edi
  80122a:	5d                   	pop    %ebp
  80122b:	c3                   	ret    

0080122c <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80122c:	55                   	push   %ebp
  80122d:	89 e5                	mov    %esp,%ebp
  80122f:	57                   	push   %edi
  801230:	56                   	push   %esi
  801231:	53                   	push   %ebx
	asm volatile("int %1\n"
  801232:	b9 00 00 00 00       	mov    $0x0,%ecx
  801237:	8b 55 08             	mov    0x8(%ebp),%edx
  80123a:	b8 0f 00 00 00       	mov    $0xf,%eax
  80123f:	89 cb                	mov    %ecx,%ebx
  801241:	89 cf                	mov    %ecx,%edi
  801243:	89 ce                	mov    %ecx,%esi
  801245:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801247:	5b                   	pop    %ebx
  801248:	5e                   	pop    %esi
  801249:	5f                   	pop    %edi
  80124a:	5d                   	pop    %ebp
  80124b:	c3                   	ret    

0080124c <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
  80124f:	57                   	push   %edi
  801250:	56                   	push   %esi
  801251:	53                   	push   %ebx
	asm volatile("int %1\n"
  801252:	ba 00 00 00 00       	mov    $0x0,%edx
  801257:	b8 10 00 00 00       	mov    $0x10,%eax
  80125c:	89 d1                	mov    %edx,%ecx
  80125e:	89 d3                	mov    %edx,%ebx
  801260:	89 d7                	mov    %edx,%edi
  801262:	89 d6                	mov    %edx,%esi
  801264:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801266:	5b                   	pop    %ebx
  801267:	5e                   	pop    %esi
  801268:	5f                   	pop    %edi
  801269:	5d                   	pop    %ebp
  80126a:	c3                   	ret    

0080126b <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  80126b:	55                   	push   %ebp
  80126c:	89 e5                	mov    %esp,%ebp
  80126e:	57                   	push   %edi
  80126f:	56                   	push   %esi
  801270:	53                   	push   %ebx
	asm volatile("int %1\n"
  801271:	bb 00 00 00 00       	mov    $0x0,%ebx
  801276:	8b 55 08             	mov    0x8(%ebp),%edx
  801279:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80127c:	b8 11 00 00 00       	mov    $0x11,%eax
  801281:	89 df                	mov    %ebx,%edi
  801283:	89 de                	mov    %ebx,%esi
  801285:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801287:	5b                   	pop    %ebx
  801288:	5e                   	pop    %esi
  801289:	5f                   	pop    %edi
  80128a:	5d                   	pop    %ebp
  80128b:	c3                   	ret    

0080128c <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  80128c:	55                   	push   %ebp
  80128d:	89 e5                	mov    %esp,%ebp
  80128f:	57                   	push   %edi
  801290:	56                   	push   %esi
  801291:	53                   	push   %ebx
	asm volatile("int %1\n"
  801292:	bb 00 00 00 00       	mov    $0x0,%ebx
  801297:	8b 55 08             	mov    0x8(%ebp),%edx
  80129a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80129d:	b8 12 00 00 00       	mov    $0x12,%eax
  8012a2:	89 df                	mov    %ebx,%edi
  8012a4:	89 de                	mov    %ebx,%esi
  8012a6:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8012a8:	5b                   	pop    %ebx
  8012a9:	5e                   	pop    %esi
  8012aa:	5f                   	pop    %edi
  8012ab:	5d                   	pop    %ebp
  8012ac:	c3                   	ret    

008012ad <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8012ad:	55                   	push   %ebp
  8012ae:	89 e5                	mov    %esp,%ebp
  8012b0:	57                   	push   %edi
  8012b1:	56                   	push   %esi
  8012b2:	53                   	push   %ebx
  8012b3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8012be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012c1:	b8 13 00 00 00       	mov    $0x13,%eax
  8012c6:	89 df                	mov    %ebx,%edi
  8012c8:	89 de                	mov    %ebx,%esi
  8012ca:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012cc:	85 c0                	test   %eax,%eax
  8012ce:	7f 08                	jg     8012d8 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8012d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012d3:	5b                   	pop    %ebx
  8012d4:	5e                   	pop    %esi
  8012d5:	5f                   	pop    %edi
  8012d6:	5d                   	pop    %ebp
  8012d7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012d8:	83 ec 0c             	sub    $0xc,%esp
  8012db:	50                   	push   %eax
  8012dc:	6a 13                	push   $0x13
  8012de:	68 08 2f 80 00       	push   $0x802f08
  8012e3:	6a 43                	push   $0x43
  8012e5:	68 25 2f 80 00       	push   $0x802f25
  8012ea:	e8 e4 f0 ff ff       	call   8003d3 <_panic>

008012ef <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8012ef:	55                   	push   %ebp
  8012f0:	89 e5                	mov    %esp,%ebp
  8012f2:	57                   	push   %edi
  8012f3:	56                   	push   %esi
  8012f4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012f5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8012fd:	b8 14 00 00 00       	mov    $0x14,%eax
  801302:	89 cb                	mov    %ecx,%ebx
  801304:	89 cf                	mov    %ecx,%edi
  801306:	89 ce                	mov    %ecx,%esi
  801308:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  80130a:	5b                   	pop    %ebx
  80130b:	5e                   	pop    %esi
  80130c:	5f                   	pop    %edi
  80130d:	5d                   	pop    %ebp
  80130e:	c3                   	ret    

0080130f <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	8b 55 08             	mov    0x8(%ebp),%edx
  801315:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801318:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  80131b:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  80131d:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801320:	83 3a 01             	cmpl   $0x1,(%edx)
  801323:	7e 09                	jle    80132e <argstart+0x1f>
  801325:	ba 08 2b 80 00       	mov    $0x802b08,%edx
  80132a:	85 c9                	test   %ecx,%ecx
  80132c:	75 05                	jne    801333 <argstart+0x24>
  80132e:	ba 00 00 00 00       	mov    $0x0,%edx
  801333:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  801336:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  80133d:	5d                   	pop    %ebp
  80133e:	c3                   	ret    

0080133f <argnext>:

int
argnext(struct Argstate *args)
{
  80133f:	55                   	push   %ebp
  801340:	89 e5                	mov    %esp,%ebp
  801342:	53                   	push   %ebx
  801343:	83 ec 04             	sub    $0x4,%esp
  801346:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801349:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801350:	8b 43 08             	mov    0x8(%ebx),%eax
  801353:	85 c0                	test   %eax,%eax
  801355:	74 72                	je     8013c9 <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  801357:	80 38 00             	cmpb   $0x0,(%eax)
  80135a:	75 48                	jne    8013a4 <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  80135c:	8b 0b                	mov    (%ebx),%ecx
  80135e:	83 39 01             	cmpl   $0x1,(%ecx)
  801361:	74 58                	je     8013bb <argnext+0x7c>
		    || args->argv[1][0] != '-'
  801363:	8b 53 04             	mov    0x4(%ebx),%edx
  801366:	8b 42 04             	mov    0x4(%edx),%eax
  801369:	80 38 2d             	cmpb   $0x2d,(%eax)
  80136c:	75 4d                	jne    8013bb <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  80136e:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801372:	74 47                	je     8013bb <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801374:	83 c0 01             	add    $0x1,%eax
  801377:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  80137a:	83 ec 04             	sub    $0x4,%esp
  80137d:	8b 01                	mov    (%ecx),%eax
  80137f:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801386:	50                   	push   %eax
  801387:	8d 42 08             	lea    0x8(%edx),%eax
  80138a:	50                   	push   %eax
  80138b:	83 c2 04             	add    $0x4,%edx
  80138e:	52                   	push   %edx
  80138f:	e8 22 fa ff ff       	call   800db6 <memmove>
		(*args->argc)--;
  801394:	8b 03                	mov    (%ebx),%eax
  801396:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801399:	8b 43 08             	mov    0x8(%ebx),%eax
  80139c:	83 c4 10             	add    $0x10,%esp
  80139f:	80 38 2d             	cmpb   $0x2d,(%eax)
  8013a2:	74 11                	je     8013b5 <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  8013a4:	8b 53 08             	mov    0x8(%ebx),%edx
  8013a7:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  8013aa:	83 c2 01             	add    $0x1,%edx
  8013ad:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  8013b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013b3:	c9                   	leave  
  8013b4:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8013b5:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  8013b9:	75 e9                	jne    8013a4 <argnext+0x65>
	args->curarg = 0;
  8013bb:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  8013c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8013c7:	eb e7                	jmp    8013b0 <argnext+0x71>
		return -1;
  8013c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8013ce:	eb e0                	jmp    8013b0 <argnext+0x71>

008013d0 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
  8013d3:	53                   	push   %ebx
  8013d4:	83 ec 04             	sub    $0x4,%esp
  8013d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  8013da:	8b 43 08             	mov    0x8(%ebx),%eax
  8013dd:	85 c0                	test   %eax,%eax
  8013df:	74 12                	je     8013f3 <argnextvalue+0x23>
		return 0;
	if (*args->curarg) {
  8013e1:	80 38 00             	cmpb   $0x0,(%eax)
  8013e4:	74 12                	je     8013f8 <argnextvalue+0x28>
		args->argvalue = args->curarg;
  8013e6:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  8013e9:	c7 43 08 08 2b 80 00 	movl   $0x802b08,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  8013f0:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  8013f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013f6:	c9                   	leave  
  8013f7:	c3                   	ret    
	} else if (*args->argc > 1) {
  8013f8:	8b 13                	mov    (%ebx),%edx
  8013fa:	83 3a 01             	cmpl   $0x1,(%edx)
  8013fd:	7f 10                	jg     80140f <argnextvalue+0x3f>
		args->argvalue = 0;
  8013ff:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  801406:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  80140d:	eb e1                	jmp    8013f0 <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  80140f:	8b 43 04             	mov    0x4(%ebx),%eax
  801412:	8b 48 04             	mov    0x4(%eax),%ecx
  801415:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801418:	83 ec 04             	sub    $0x4,%esp
  80141b:	8b 12                	mov    (%edx),%edx
  80141d:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  801424:	52                   	push   %edx
  801425:	8d 50 08             	lea    0x8(%eax),%edx
  801428:	52                   	push   %edx
  801429:	83 c0 04             	add    $0x4,%eax
  80142c:	50                   	push   %eax
  80142d:	e8 84 f9 ff ff       	call   800db6 <memmove>
		(*args->argc)--;
  801432:	8b 03                	mov    (%ebx),%eax
  801434:	83 28 01             	subl   $0x1,(%eax)
  801437:	83 c4 10             	add    $0x10,%esp
  80143a:	eb b4                	jmp    8013f0 <argnextvalue+0x20>

0080143c <argvalue>:
{
  80143c:	55                   	push   %ebp
  80143d:	89 e5                	mov    %esp,%ebp
  80143f:	83 ec 08             	sub    $0x8,%esp
  801442:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801445:	8b 42 0c             	mov    0xc(%edx),%eax
  801448:	85 c0                	test   %eax,%eax
  80144a:	74 02                	je     80144e <argvalue+0x12>
}
  80144c:	c9                   	leave  
  80144d:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  80144e:	83 ec 0c             	sub    $0xc,%esp
  801451:	52                   	push   %edx
  801452:	e8 79 ff ff ff       	call   8013d0 <argnextvalue>
  801457:	83 c4 10             	add    $0x10,%esp
  80145a:	eb f0                	jmp    80144c <argvalue+0x10>

0080145c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80145f:	8b 45 08             	mov    0x8(%ebp),%eax
  801462:	05 00 00 00 30       	add    $0x30000000,%eax
  801467:	c1 e8 0c             	shr    $0xc,%eax
}
  80146a:	5d                   	pop    %ebp
  80146b:	c3                   	ret    

0080146c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80146c:	55                   	push   %ebp
  80146d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80146f:	8b 45 08             	mov    0x8(%ebp),%eax
  801472:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801477:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80147c:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801481:	5d                   	pop    %ebp
  801482:	c3                   	ret    

00801483 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80148b:	89 c2                	mov    %eax,%edx
  80148d:	c1 ea 16             	shr    $0x16,%edx
  801490:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801497:	f6 c2 01             	test   $0x1,%dl
  80149a:	74 2d                	je     8014c9 <fd_alloc+0x46>
  80149c:	89 c2                	mov    %eax,%edx
  80149e:	c1 ea 0c             	shr    $0xc,%edx
  8014a1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014a8:	f6 c2 01             	test   $0x1,%dl
  8014ab:	74 1c                	je     8014c9 <fd_alloc+0x46>
  8014ad:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8014b2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8014b7:	75 d2                	jne    80148b <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8014b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8014c2:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8014c7:	eb 0a                	jmp    8014d3 <fd_alloc+0x50>
			*fd_store = fd;
  8014c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014cc:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014d3:	5d                   	pop    %ebp
  8014d4:	c3                   	ret    

008014d5 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
  8014d8:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8014db:	83 f8 1f             	cmp    $0x1f,%eax
  8014de:	77 30                	ja     801510 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8014e0:	c1 e0 0c             	shl    $0xc,%eax
  8014e3:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8014e8:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8014ee:	f6 c2 01             	test   $0x1,%dl
  8014f1:	74 24                	je     801517 <fd_lookup+0x42>
  8014f3:	89 c2                	mov    %eax,%edx
  8014f5:	c1 ea 0c             	shr    $0xc,%edx
  8014f8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014ff:	f6 c2 01             	test   $0x1,%dl
  801502:	74 1a                	je     80151e <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801504:	8b 55 0c             	mov    0xc(%ebp),%edx
  801507:	89 02                	mov    %eax,(%edx)
	return 0;
  801509:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80150e:	5d                   	pop    %ebp
  80150f:	c3                   	ret    
		return -E_INVAL;
  801510:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801515:	eb f7                	jmp    80150e <fd_lookup+0x39>
		return -E_INVAL;
  801517:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80151c:	eb f0                	jmp    80150e <fd_lookup+0x39>
  80151e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801523:	eb e9                	jmp    80150e <fd_lookup+0x39>

00801525 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
  801528:	83 ec 08             	sub    $0x8,%esp
  80152b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80152e:	ba 00 00 00 00       	mov    $0x0,%edx
  801533:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801538:	39 08                	cmp    %ecx,(%eax)
  80153a:	74 38                	je     801574 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80153c:	83 c2 01             	add    $0x1,%edx
  80153f:	8b 04 95 b4 2f 80 00 	mov    0x802fb4(,%edx,4),%eax
  801546:	85 c0                	test   %eax,%eax
  801548:	75 ee                	jne    801538 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80154a:	a1 20 54 80 00       	mov    0x805420,%eax
  80154f:	8b 40 48             	mov    0x48(%eax),%eax
  801552:	83 ec 04             	sub    $0x4,%esp
  801555:	51                   	push   %ecx
  801556:	50                   	push   %eax
  801557:	68 34 2f 80 00       	push   $0x802f34
  80155c:	e8 68 ef ff ff       	call   8004c9 <cprintf>
	*dev = 0;
  801561:	8b 45 0c             	mov    0xc(%ebp),%eax
  801564:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80156a:	83 c4 10             	add    $0x10,%esp
  80156d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801572:	c9                   	leave  
  801573:	c3                   	ret    
			*dev = devtab[i];
  801574:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801577:	89 01                	mov    %eax,(%ecx)
			return 0;
  801579:	b8 00 00 00 00       	mov    $0x0,%eax
  80157e:	eb f2                	jmp    801572 <dev_lookup+0x4d>

00801580 <fd_close>:
{
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
  801583:	57                   	push   %edi
  801584:	56                   	push   %esi
  801585:	53                   	push   %ebx
  801586:	83 ec 24             	sub    $0x24,%esp
  801589:	8b 75 08             	mov    0x8(%ebp),%esi
  80158c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80158f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801592:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801593:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801599:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80159c:	50                   	push   %eax
  80159d:	e8 33 ff ff ff       	call   8014d5 <fd_lookup>
  8015a2:	89 c3                	mov    %eax,%ebx
  8015a4:	83 c4 10             	add    $0x10,%esp
  8015a7:	85 c0                	test   %eax,%eax
  8015a9:	78 05                	js     8015b0 <fd_close+0x30>
	    || fd != fd2)
  8015ab:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8015ae:	74 16                	je     8015c6 <fd_close+0x46>
		return (must_exist ? r : 0);
  8015b0:	89 f8                	mov    %edi,%eax
  8015b2:	84 c0                	test   %al,%al
  8015b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b9:	0f 44 d8             	cmove  %eax,%ebx
}
  8015bc:	89 d8                	mov    %ebx,%eax
  8015be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015c1:	5b                   	pop    %ebx
  8015c2:	5e                   	pop    %esi
  8015c3:	5f                   	pop    %edi
  8015c4:	5d                   	pop    %ebp
  8015c5:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8015c6:	83 ec 08             	sub    $0x8,%esp
  8015c9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8015cc:	50                   	push   %eax
  8015cd:	ff 36                	pushl  (%esi)
  8015cf:	e8 51 ff ff ff       	call   801525 <dev_lookup>
  8015d4:	89 c3                	mov    %eax,%ebx
  8015d6:	83 c4 10             	add    $0x10,%esp
  8015d9:	85 c0                	test   %eax,%eax
  8015db:	78 1a                	js     8015f7 <fd_close+0x77>
		if (dev->dev_close)
  8015dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015e0:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8015e3:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8015e8:	85 c0                	test   %eax,%eax
  8015ea:	74 0b                	je     8015f7 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8015ec:	83 ec 0c             	sub    $0xc,%esp
  8015ef:	56                   	push   %esi
  8015f0:	ff d0                	call   *%eax
  8015f2:	89 c3                	mov    %eax,%ebx
  8015f4:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8015f7:	83 ec 08             	sub    $0x8,%esp
  8015fa:	56                   	push   %esi
  8015fb:	6a 00                	push   $0x0
  8015fd:	e8 9d fa ff ff       	call   80109f <sys_page_unmap>
	return r;
  801602:	83 c4 10             	add    $0x10,%esp
  801605:	eb b5                	jmp    8015bc <fd_close+0x3c>

00801607 <close>:

int
close(int fdnum)
{
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
  80160a:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80160d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801610:	50                   	push   %eax
  801611:	ff 75 08             	pushl  0x8(%ebp)
  801614:	e8 bc fe ff ff       	call   8014d5 <fd_lookup>
  801619:	83 c4 10             	add    $0x10,%esp
  80161c:	85 c0                	test   %eax,%eax
  80161e:	79 02                	jns    801622 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801620:	c9                   	leave  
  801621:	c3                   	ret    
		return fd_close(fd, 1);
  801622:	83 ec 08             	sub    $0x8,%esp
  801625:	6a 01                	push   $0x1
  801627:	ff 75 f4             	pushl  -0xc(%ebp)
  80162a:	e8 51 ff ff ff       	call   801580 <fd_close>
  80162f:	83 c4 10             	add    $0x10,%esp
  801632:	eb ec                	jmp    801620 <close+0x19>

00801634 <close_all>:

void
close_all(void)
{
  801634:	55                   	push   %ebp
  801635:	89 e5                	mov    %esp,%ebp
  801637:	53                   	push   %ebx
  801638:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80163b:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801640:	83 ec 0c             	sub    $0xc,%esp
  801643:	53                   	push   %ebx
  801644:	e8 be ff ff ff       	call   801607 <close>
	for (i = 0; i < MAXFD; i++)
  801649:	83 c3 01             	add    $0x1,%ebx
  80164c:	83 c4 10             	add    $0x10,%esp
  80164f:	83 fb 20             	cmp    $0x20,%ebx
  801652:	75 ec                	jne    801640 <close_all+0xc>
}
  801654:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801657:	c9                   	leave  
  801658:	c3                   	ret    

00801659 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
  80165c:	57                   	push   %edi
  80165d:	56                   	push   %esi
  80165e:	53                   	push   %ebx
  80165f:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801662:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801665:	50                   	push   %eax
  801666:	ff 75 08             	pushl  0x8(%ebp)
  801669:	e8 67 fe ff ff       	call   8014d5 <fd_lookup>
  80166e:	89 c3                	mov    %eax,%ebx
  801670:	83 c4 10             	add    $0x10,%esp
  801673:	85 c0                	test   %eax,%eax
  801675:	0f 88 81 00 00 00    	js     8016fc <dup+0xa3>
		return r;
	close(newfdnum);
  80167b:	83 ec 0c             	sub    $0xc,%esp
  80167e:	ff 75 0c             	pushl  0xc(%ebp)
  801681:	e8 81 ff ff ff       	call   801607 <close>

	newfd = INDEX2FD(newfdnum);
  801686:	8b 75 0c             	mov    0xc(%ebp),%esi
  801689:	c1 e6 0c             	shl    $0xc,%esi
  80168c:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801692:	83 c4 04             	add    $0x4,%esp
  801695:	ff 75 e4             	pushl  -0x1c(%ebp)
  801698:	e8 cf fd ff ff       	call   80146c <fd2data>
  80169d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80169f:	89 34 24             	mov    %esi,(%esp)
  8016a2:	e8 c5 fd ff ff       	call   80146c <fd2data>
  8016a7:	83 c4 10             	add    $0x10,%esp
  8016aa:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8016ac:	89 d8                	mov    %ebx,%eax
  8016ae:	c1 e8 16             	shr    $0x16,%eax
  8016b1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016b8:	a8 01                	test   $0x1,%al
  8016ba:	74 11                	je     8016cd <dup+0x74>
  8016bc:	89 d8                	mov    %ebx,%eax
  8016be:	c1 e8 0c             	shr    $0xc,%eax
  8016c1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8016c8:	f6 c2 01             	test   $0x1,%dl
  8016cb:	75 39                	jne    801706 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016cd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016d0:	89 d0                	mov    %edx,%eax
  8016d2:	c1 e8 0c             	shr    $0xc,%eax
  8016d5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016dc:	83 ec 0c             	sub    $0xc,%esp
  8016df:	25 07 0e 00 00       	and    $0xe07,%eax
  8016e4:	50                   	push   %eax
  8016e5:	56                   	push   %esi
  8016e6:	6a 00                	push   $0x0
  8016e8:	52                   	push   %edx
  8016e9:	6a 00                	push   $0x0
  8016eb:	e8 6d f9 ff ff       	call   80105d <sys_page_map>
  8016f0:	89 c3                	mov    %eax,%ebx
  8016f2:	83 c4 20             	add    $0x20,%esp
  8016f5:	85 c0                	test   %eax,%eax
  8016f7:	78 31                	js     80172a <dup+0xd1>
		goto err;

	return newfdnum;
  8016f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8016fc:	89 d8                	mov    %ebx,%eax
  8016fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801701:	5b                   	pop    %ebx
  801702:	5e                   	pop    %esi
  801703:	5f                   	pop    %edi
  801704:	5d                   	pop    %ebp
  801705:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801706:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80170d:	83 ec 0c             	sub    $0xc,%esp
  801710:	25 07 0e 00 00       	and    $0xe07,%eax
  801715:	50                   	push   %eax
  801716:	57                   	push   %edi
  801717:	6a 00                	push   $0x0
  801719:	53                   	push   %ebx
  80171a:	6a 00                	push   $0x0
  80171c:	e8 3c f9 ff ff       	call   80105d <sys_page_map>
  801721:	89 c3                	mov    %eax,%ebx
  801723:	83 c4 20             	add    $0x20,%esp
  801726:	85 c0                	test   %eax,%eax
  801728:	79 a3                	jns    8016cd <dup+0x74>
	sys_page_unmap(0, newfd);
  80172a:	83 ec 08             	sub    $0x8,%esp
  80172d:	56                   	push   %esi
  80172e:	6a 00                	push   $0x0
  801730:	e8 6a f9 ff ff       	call   80109f <sys_page_unmap>
	sys_page_unmap(0, nva);
  801735:	83 c4 08             	add    $0x8,%esp
  801738:	57                   	push   %edi
  801739:	6a 00                	push   $0x0
  80173b:	e8 5f f9 ff ff       	call   80109f <sys_page_unmap>
	return r;
  801740:	83 c4 10             	add    $0x10,%esp
  801743:	eb b7                	jmp    8016fc <dup+0xa3>

00801745 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
  801748:	53                   	push   %ebx
  801749:	83 ec 1c             	sub    $0x1c,%esp
  80174c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80174f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801752:	50                   	push   %eax
  801753:	53                   	push   %ebx
  801754:	e8 7c fd ff ff       	call   8014d5 <fd_lookup>
  801759:	83 c4 10             	add    $0x10,%esp
  80175c:	85 c0                	test   %eax,%eax
  80175e:	78 3f                	js     80179f <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801760:	83 ec 08             	sub    $0x8,%esp
  801763:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801766:	50                   	push   %eax
  801767:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176a:	ff 30                	pushl  (%eax)
  80176c:	e8 b4 fd ff ff       	call   801525 <dev_lookup>
  801771:	83 c4 10             	add    $0x10,%esp
  801774:	85 c0                	test   %eax,%eax
  801776:	78 27                	js     80179f <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801778:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80177b:	8b 42 08             	mov    0x8(%edx),%eax
  80177e:	83 e0 03             	and    $0x3,%eax
  801781:	83 f8 01             	cmp    $0x1,%eax
  801784:	74 1e                	je     8017a4 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801786:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801789:	8b 40 08             	mov    0x8(%eax),%eax
  80178c:	85 c0                	test   %eax,%eax
  80178e:	74 35                	je     8017c5 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801790:	83 ec 04             	sub    $0x4,%esp
  801793:	ff 75 10             	pushl  0x10(%ebp)
  801796:	ff 75 0c             	pushl  0xc(%ebp)
  801799:	52                   	push   %edx
  80179a:	ff d0                	call   *%eax
  80179c:	83 c4 10             	add    $0x10,%esp
}
  80179f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017a2:	c9                   	leave  
  8017a3:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8017a4:	a1 20 54 80 00       	mov    0x805420,%eax
  8017a9:	8b 40 48             	mov    0x48(%eax),%eax
  8017ac:	83 ec 04             	sub    $0x4,%esp
  8017af:	53                   	push   %ebx
  8017b0:	50                   	push   %eax
  8017b1:	68 78 2f 80 00       	push   $0x802f78
  8017b6:	e8 0e ed ff ff       	call   8004c9 <cprintf>
		return -E_INVAL;
  8017bb:	83 c4 10             	add    $0x10,%esp
  8017be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017c3:	eb da                	jmp    80179f <read+0x5a>
		return -E_NOT_SUPP;
  8017c5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017ca:	eb d3                	jmp    80179f <read+0x5a>

008017cc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
  8017cf:	57                   	push   %edi
  8017d0:	56                   	push   %esi
  8017d1:	53                   	push   %ebx
  8017d2:	83 ec 0c             	sub    $0xc,%esp
  8017d5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017d8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017e0:	39 f3                	cmp    %esi,%ebx
  8017e2:	73 23                	jae    801807 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017e4:	83 ec 04             	sub    $0x4,%esp
  8017e7:	89 f0                	mov    %esi,%eax
  8017e9:	29 d8                	sub    %ebx,%eax
  8017eb:	50                   	push   %eax
  8017ec:	89 d8                	mov    %ebx,%eax
  8017ee:	03 45 0c             	add    0xc(%ebp),%eax
  8017f1:	50                   	push   %eax
  8017f2:	57                   	push   %edi
  8017f3:	e8 4d ff ff ff       	call   801745 <read>
		if (m < 0)
  8017f8:	83 c4 10             	add    $0x10,%esp
  8017fb:	85 c0                	test   %eax,%eax
  8017fd:	78 06                	js     801805 <readn+0x39>
			return m;
		if (m == 0)
  8017ff:	74 06                	je     801807 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801801:	01 c3                	add    %eax,%ebx
  801803:	eb db                	jmp    8017e0 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801805:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801807:	89 d8                	mov    %ebx,%eax
  801809:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80180c:	5b                   	pop    %ebx
  80180d:	5e                   	pop    %esi
  80180e:	5f                   	pop    %edi
  80180f:	5d                   	pop    %ebp
  801810:	c3                   	ret    

00801811 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
  801814:	53                   	push   %ebx
  801815:	83 ec 1c             	sub    $0x1c,%esp
  801818:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80181b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80181e:	50                   	push   %eax
  80181f:	53                   	push   %ebx
  801820:	e8 b0 fc ff ff       	call   8014d5 <fd_lookup>
  801825:	83 c4 10             	add    $0x10,%esp
  801828:	85 c0                	test   %eax,%eax
  80182a:	78 3a                	js     801866 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80182c:	83 ec 08             	sub    $0x8,%esp
  80182f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801832:	50                   	push   %eax
  801833:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801836:	ff 30                	pushl  (%eax)
  801838:	e8 e8 fc ff ff       	call   801525 <dev_lookup>
  80183d:	83 c4 10             	add    $0x10,%esp
  801840:	85 c0                	test   %eax,%eax
  801842:	78 22                	js     801866 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801844:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801847:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80184b:	74 1e                	je     80186b <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80184d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801850:	8b 52 0c             	mov    0xc(%edx),%edx
  801853:	85 d2                	test   %edx,%edx
  801855:	74 35                	je     80188c <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801857:	83 ec 04             	sub    $0x4,%esp
  80185a:	ff 75 10             	pushl  0x10(%ebp)
  80185d:	ff 75 0c             	pushl  0xc(%ebp)
  801860:	50                   	push   %eax
  801861:	ff d2                	call   *%edx
  801863:	83 c4 10             	add    $0x10,%esp
}
  801866:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801869:	c9                   	leave  
  80186a:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80186b:	a1 20 54 80 00       	mov    0x805420,%eax
  801870:	8b 40 48             	mov    0x48(%eax),%eax
  801873:	83 ec 04             	sub    $0x4,%esp
  801876:	53                   	push   %ebx
  801877:	50                   	push   %eax
  801878:	68 94 2f 80 00       	push   $0x802f94
  80187d:	e8 47 ec ff ff       	call   8004c9 <cprintf>
		return -E_INVAL;
  801882:	83 c4 10             	add    $0x10,%esp
  801885:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80188a:	eb da                	jmp    801866 <write+0x55>
		return -E_NOT_SUPP;
  80188c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801891:	eb d3                	jmp    801866 <write+0x55>

00801893 <seek>:

int
seek(int fdnum, off_t offset)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
  801896:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801899:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80189c:	50                   	push   %eax
  80189d:	ff 75 08             	pushl  0x8(%ebp)
  8018a0:	e8 30 fc ff ff       	call   8014d5 <fd_lookup>
  8018a5:	83 c4 10             	add    $0x10,%esp
  8018a8:	85 c0                	test   %eax,%eax
  8018aa:	78 0e                	js     8018ba <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8018ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8018b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
  8018bf:	53                   	push   %ebx
  8018c0:	83 ec 1c             	sub    $0x1c,%esp
  8018c3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018c6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018c9:	50                   	push   %eax
  8018ca:	53                   	push   %ebx
  8018cb:	e8 05 fc ff ff       	call   8014d5 <fd_lookup>
  8018d0:	83 c4 10             	add    $0x10,%esp
  8018d3:	85 c0                	test   %eax,%eax
  8018d5:	78 37                	js     80190e <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018d7:	83 ec 08             	sub    $0x8,%esp
  8018da:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018dd:	50                   	push   %eax
  8018de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e1:	ff 30                	pushl  (%eax)
  8018e3:	e8 3d fc ff ff       	call   801525 <dev_lookup>
  8018e8:	83 c4 10             	add    $0x10,%esp
  8018eb:	85 c0                	test   %eax,%eax
  8018ed:	78 1f                	js     80190e <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018f6:	74 1b                	je     801913 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8018f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018fb:	8b 52 18             	mov    0x18(%edx),%edx
  8018fe:	85 d2                	test   %edx,%edx
  801900:	74 32                	je     801934 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801902:	83 ec 08             	sub    $0x8,%esp
  801905:	ff 75 0c             	pushl  0xc(%ebp)
  801908:	50                   	push   %eax
  801909:	ff d2                	call   *%edx
  80190b:	83 c4 10             	add    $0x10,%esp
}
  80190e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801911:	c9                   	leave  
  801912:	c3                   	ret    
			thisenv->env_id, fdnum);
  801913:	a1 20 54 80 00       	mov    0x805420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801918:	8b 40 48             	mov    0x48(%eax),%eax
  80191b:	83 ec 04             	sub    $0x4,%esp
  80191e:	53                   	push   %ebx
  80191f:	50                   	push   %eax
  801920:	68 54 2f 80 00       	push   $0x802f54
  801925:	e8 9f eb ff ff       	call   8004c9 <cprintf>
		return -E_INVAL;
  80192a:	83 c4 10             	add    $0x10,%esp
  80192d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801932:	eb da                	jmp    80190e <ftruncate+0x52>
		return -E_NOT_SUPP;
  801934:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801939:	eb d3                	jmp    80190e <ftruncate+0x52>

0080193b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
  80193e:	53                   	push   %ebx
  80193f:	83 ec 1c             	sub    $0x1c,%esp
  801942:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801945:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801948:	50                   	push   %eax
  801949:	ff 75 08             	pushl  0x8(%ebp)
  80194c:	e8 84 fb ff ff       	call   8014d5 <fd_lookup>
  801951:	83 c4 10             	add    $0x10,%esp
  801954:	85 c0                	test   %eax,%eax
  801956:	78 4b                	js     8019a3 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801958:	83 ec 08             	sub    $0x8,%esp
  80195b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80195e:	50                   	push   %eax
  80195f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801962:	ff 30                	pushl  (%eax)
  801964:	e8 bc fb ff ff       	call   801525 <dev_lookup>
  801969:	83 c4 10             	add    $0x10,%esp
  80196c:	85 c0                	test   %eax,%eax
  80196e:	78 33                	js     8019a3 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801973:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801977:	74 2f                	je     8019a8 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801979:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80197c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801983:	00 00 00 
	stat->st_isdir = 0;
  801986:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80198d:	00 00 00 
	stat->st_dev = dev;
  801990:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801996:	83 ec 08             	sub    $0x8,%esp
  801999:	53                   	push   %ebx
  80199a:	ff 75 f0             	pushl  -0x10(%ebp)
  80199d:	ff 50 14             	call   *0x14(%eax)
  8019a0:	83 c4 10             	add    $0x10,%esp
}
  8019a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019a6:	c9                   	leave  
  8019a7:	c3                   	ret    
		return -E_NOT_SUPP;
  8019a8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019ad:	eb f4                	jmp    8019a3 <fstat+0x68>

008019af <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
  8019b2:	56                   	push   %esi
  8019b3:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8019b4:	83 ec 08             	sub    $0x8,%esp
  8019b7:	6a 00                	push   $0x0
  8019b9:	ff 75 08             	pushl  0x8(%ebp)
  8019bc:	e8 22 02 00 00       	call   801be3 <open>
  8019c1:	89 c3                	mov    %eax,%ebx
  8019c3:	83 c4 10             	add    $0x10,%esp
  8019c6:	85 c0                	test   %eax,%eax
  8019c8:	78 1b                	js     8019e5 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8019ca:	83 ec 08             	sub    $0x8,%esp
  8019cd:	ff 75 0c             	pushl  0xc(%ebp)
  8019d0:	50                   	push   %eax
  8019d1:	e8 65 ff ff ff       	call   80193b <fstat>
  8019d6:	89 c6                	mov    %eax,%esi
	close(fd);
  8019d8:	89 1c 24             	mov    %ebx,(%esp)
  8019db:	e8 27 fc ff ff       	call   801607 <close>
	return r;
  8019e0:	83 c4 10             	add    $0x10,%esp
  8019e3:	89 f3                	mov    %esi,%ebx
}
  8019e5:	89 d8                	mov    %ebx,%eax
  8019e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ea:	5b                   	pop    %ebx
  8019eb:	5e                   	pop    %esi
  8019ec:	5d                   	pop    %ebp
  8019ed:	c3                   	ret    

008019ee <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
  8019f1:	56                   	push   %esi
  8019f2:	53                   	push   %ebx
  8019f3:	89 c6                	mov    %eax,%esi
  8019f5:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8019f7:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8019fe:	74 27                	je     801a27 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a00:	6a 07                	push   $0x7
  801a02:	68 00 60 80 00       	push   $0x806000
  801a07:	56                   	push   %esi
  801a08:	ff 35 00 50 80 00    	pushl  0x805000
  801a0e:	e8 1c 0d 00 00       	call   80272f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a13:	83 c4 0c             	add    $0xc,%esp
  801a16:	6a 00                	push   $0x0
  801a18:	53                   	push   %ebx
  801a19:	6a 00                	push   $0x0
  801a1b:	e8 a6 0c 00 00       	call   8026c6 <ipc_recv>
}
  801a20:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a23:	5b                   	pop    %ebx
  801a24:	5e                   	pop    %esi
  801a25:	5d                   	pop    %ebp
  801a26:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a27:	83 ec 0c             	sub    $0xc,%esp
  801a2a:	6a 01                	push   $0x1
  801a2c:	e8 56 0d 00 00       	call   802787 <ipc_find_env>
  801a31:	a3 00 50 80 00       	mov    %eax,0x805000
  801a36:	83 c4 10             	add    $0x10,%esp
  801a39:	eb c5                	jmp    801a00 <fsipc+0x12>

00801a3b <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
  801a3e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a41:	8b 45 08             	mov    0x8(%ebp),%eax
  801a44:	8b 40 0c             	mov    0xc(%eax),%eax
  801a47:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801a4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a4f:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a54:	ba 00 00 00 00       	mov    $0x0,%edx
  801a59:	b8 02 00 00 00       	mov    $0x2,%eax
  801a5e:	e8 8b ff ff ff       	call   8019ee <fsipc>
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <devfile_flush>:
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
  801a68:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6e:	8b 40 0c             	mov    0xc(%eax),%eax
  801a71:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801a76:	ba 00 00 00 00       	mov    $0x0,%edx
  801a7b:	b8 06 00 00 00       	mov    $0x6,%eax
  801a80:	e8 69 ff ff ff       	call   8019ee <fsipc>
}
  801a85:	c9                   	leave  
  801a86:	c3                   	ret    

00801a87 <devfile_stat>:
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
  801a8a:	53                   	push   %ebx
  801a8b:	83 ec 04             	sub    $0x4,%esp
  801a8e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a91:	8b 45 08             	mov    0x8(%ebp),%eax
  801a94:	8b 40 0c             	mov    0xc(%eax),%eax
  801a97:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a9c:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa1:	b8 05 00 00 00       	mov    $0x5,%eax
  801aa6:	e8 43 ff ff ff       	call   8019ee <fsipc>
  801aab:	85 c0                	test   %eax,%eax
  801aad:	78 2c                	js     801adb <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801aaf:	83 ec 08             	sub    $0x8,%esp
  801ab2:	68 00 60 80 00       	push   $0x806000
  801ab7:	53                   	push   %ebx
  801ab8:	e8 6b f1 ff ff       	call   800c28 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801abd:	a1 80 60 80 00       	mov    0x806080,%eax
  801ac2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801ac8:	a1 84 60 80 00       	mov    0x806084,%eax
  801acd:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801ad3:	83 c4 10             	add    $0x10,%esp
  801ad6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801adb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <devfile_write>:
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
  801ae3:	53                   	push   %ebx
  801ae4:	83 ec 08             	sub    $0x8,%esp
  801ae7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801aea:	8b 45 08             	mov    0x8(%ebp),%eax
  801aed:	8b 40 0c             	mov    0xc(%eax),%eax
  801af0:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801af5:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801afb:	53                   	push   %ebx
  801afc:	ff 75 0c             	pushl  0xc(%ebp)
  801aff:	68 08 60 80 00       	push   $0x806008
  801b04:	e8 0f f3 ff ff       	call   800e18 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801b09:	ba 00 00 00 00       	mov    $0x0,%edx
  801b0e:	b8 04 00 00 00       	mov    $0x4,%eax
  801b13:	e8 d6 fe ff ff       	call   8019ee <fsipc>
  801b18:	83 c4 10             	add    $0x10,%esp
  801b1b:	85 c0                	test   %eax,%eax
  801b1d:	78 0b                	js     801b2a <devfile_write+0x4a>
	assert(r <= n);
  801b1f:	39 d8                	cmp    %ebx,%eax
  801b21:	77 0c                	ja     801b2f <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801b23:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b28:	7f 1e                	jg     801b48 <devfile_write+0x68>
}
  801b2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b2d:	c9                   	leave  
  801b2e:	c3                   	ret    
	assert(r <= n);
  801b2f:	68 c8 2f 80 00       	push   $0x802fc8
  801b34:	68 cf 2f 80 00       	push   $0x802fcf
  801b39:	68 98 00 00 00       	push   $0x98
  801b3e:	68 e4 2f 80 00       	push   $0x802fe4
  801b43:	e8 8b e8 ff ff       	call   8003d3 <_panic>
	assert(r <= PGSIZE);
  801b48:	68 ef 2f 80 00       	push   $0x802fef
  801b4d:	68 cf 2f 80 00       	push   $0x802fcf
  801b52:	68 99 00 00 00       	push   $0x99
  801b57:	68 e4 2f 80 00       	push   $0x802fe4
  801b5c:	e8 72 e8 ff ff       	call   8003d3 <_panic>

00801b61 <devfile_read>:
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
  801b64:	56                   	push   %esi
  801b65:	53                   	push   %ebx
  801b66:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b69:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6c:	8b 40 0c             	mov    0xc(%eax),%eax
  801b6f:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801b74:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b7a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b7f:	b8 03 00 00 00       	mov    $0x3,%eax
  801b84:	e8 65 fe ff ff       	call   8019ee <fsipc>
  801b89:	89 c3                	mov    %eax,%ebx
  801b8b:	85 c0                	test   %eax,%eax
  801b8d:	78 1f                	js     801bae <devfile_read+0x4d>
	assert(r <= n);
  801b8f:	39 f0                	cmp    %esi,%eax
  801b91:	77 24                	ja     801bb7 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801b93:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b98:	7f 33                	jg     801bcd <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b9a:	83 ec 04             	sub    $0x4,%esp
  801b9d:	50                   	push   %eax
  801b9e:	68 00 60 80 00       	push   $0x806000
  801ba3:	ff 75 0c             	pushl  0xc(%ebp)
  801ba6:	e8 0b f2 ff ff       	call   800db6 <memmove>
	return r;
  801bab:	83 c4 10             	add    $0x10,%esp
}
  801bae:	89 d8                	mov    %ebx,%eax
  801bb0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bb3:	5b                   	pop    %ebx
  801bb4:	5e                   	pop    %esi
  801bb5:	5d                   	pop    %ebp
  801bb6:	c3                   	ret    
	assert(r <= n);
  801bb7:	68 c8 2f 80 00       	push   $0x802fc8
  801bbc:	68 cf 2f 80 00       	push   $0x802fcf
  801bc1:	6a 7c                	push   $0x7c
  801bc3:	68 e4 2f 80 00       	push   $0x802fe4
  801bc8:	e8 06 e8 ff ff       	call   8003d3 <_panic>
	assert(r <= PGSIZE);
  801bcd:	68 ef 2f 80 00       	push   $0x802fef
  801bd2:	68 cf 2f 80 00       	push   $0x802fcf
  801bd7:	6a 7d                	push   $0x7d
  801bd9:	68 e4 2f 80 00       	push   $0x802fe4
  801bde:	e8 f0 e7 ff ff       	call   8003d3 <_panic>

00801be3 <open>:
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
  801be6:	56                   	push   %esi
  801be7:	53                   	push   %ebx
  801be8:	83 ec 1c             	sub    $0x1c,%esp
  801beb:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801bee:	56                   	push   %esi
  801bef:	e8 fb ef ff ff       	call   800bef <strlen>
  801bf4:	83 c4 10             	add    $0x10,%esp
  801bf7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801bfc:	7f 6c                	jg     801c6a <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801bfe:	83 ec 0c             	sub    $0xc,%esp
  801c01:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c04:	50                   	push   %eax
  801c05:	e8 79 f8 ff ff       	call   801483 <fd_alloc>
  801c0a:	89 c3                	mov    %eax,%ebx
  801c0c:	83 c4 10             	add    $0x10,%esp
  801c0f:	85 c0                	test   %eax,%eax
  801c11:	78 3c                	js     801c4f <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801c13:	83 ec 08             	sub    $0x8,%esp
  801c16:	56                   	push   %esi
  801c17:	68 00 60 80 00       	push   $0x806000
  801c1c:	e8 07 f0 ff ff       	call   800c28 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c24:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c29:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c2c:	b8 01 00 00 00       	mov    $0x1,%eax
  801c31:	e8 b8 fd ff ff       	call   8019ee <fsipc>
  801c36:	89 c3                	mov    %eax,%ebx
  801c38:	83 c4 10             	add    $0x10,%esp
  801c3b:	85 c0                	test   %eax,%eax
  801c3d:	78 19                	js     801c58 <open+0x75>
	return fd2num(fd);
  801c3f:	83 ec 0c             	sub    $0xc,%esp
  801c42:	ff 75 f4             	pushl  -0xc(%ebp)
  801c45:	e8 12 f8 ff ff       	call   80145c <fd2num>
  801c4a:	89 c3                	mov    %eax,%ebx
  801c4c:	83 c4 10             	add    $0x10,%esp
}
  801c4f:	89 d8                	mov    %ebx,%eax
  801c51:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c54:	5b                   	pop    %ebx
  801c55:	5e                   	pop    %esi
  801c56:	5d                   	pop    %ebp
  801c57:	c3                   	ret    
		fd_close(fd, 0);
  801c58:	83 ec 08             	sub    $0x8,%esp
  801c5b:	6a 00                	push   $0x0
  801c5d:	ff 75 f4             	pushl  -0xc(%ebp)
  801c60:	e8 1b f9 ff ff       	call   801580 <fd_close>
		return r;
  801c65:	83 c4 10             	add    $0x10,%esp
  801c68:	eb e5                	jmp    801c4f <open+0x6c>
		return -E_BAD_PATH;
  801c6a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801c6f:	eb de                	jmp    801c4f <open+0x6c>

00801c71 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c71:	55                   	push   %ebp
  801c72:	89 e5                	mov    %esp,%ebp
  801c74:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c77:	ba 00 00 00 00       	mov    $0x0,%edx
  801c7c:	b8 08 00 00 00       	mov    $0x8,%eax
  801c81:	e8 68 fd ff ff       	call   8019ee <fsipc>
}
  801c86:	c9                   	leave  
  801c87:	c3                   	ret    

00801c88 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801c88:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801c8c:	7f 01                	jg     801c8f <writebuf+0x7>
  801c8e:	c3                   	ret    
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
  801c92:	53                   	push   %ebx
  801c93:	83 ec 08             	sub    $0x8,%esp
  801c96:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801c98:	ff 70 04             	pushl  0x4(%eax)
  801c9b:	8d 40 10             	lea    0x10(%eax),%eax
  801c9e:	50                   	push   %eax
  801c9f:	ff 33                	pushl  (%ebx)
  801ca1:	e8 6b fb ff ff       	call   801811 <write>
		if (result > 0)
  801ca6:	83 c4 10             	add    $0x10,%esp
  801ca9:	85 c0                	test   %eax,%eax
  801cab:	7e 03                	jle    801cb0 <writebuf+0x28>
			b->result += result;
  801cad:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801cb0:	39 43 04             	cmp    %eax,0x4(%ebx)
  801cb3:	74 0d                	je     801cc2 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801cb5:	85 c0                	test   %eax,%eax
  801cb7:	ba 00 00 00 00       	mov    $0x0,%edx
  801cbc:	0f 4f c2             	cmovg  %edx,%eax
  801cbf:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801cc2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <putch>:

static void
putch(int ch, void *thunk)
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
  801cca:	53                   	push   %ebx
  801ccb:	83 ec 04             	sub    $0x4,%esp
  801cce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801cd1:	8b 53 04             	mov    0x4(%ebx),%edx
  801cd4:	8d 42 01             	lea    0x1(%edx),%eax
  801cd7:	89 43 04             	mov    %eax,0x4(%ebx)
  801cda:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cdd:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801ce1:	3d 00 01 00 00       	cmp    $0x100,%eax
  801ce6:	74 06                	je     801cee <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801ce8:	83 c4 04             	add    $0x4,%esp
  801ceb:	5b                   	pop    %ebx
  801cec:	5d                   	pop    %ebp
  801ced:	c3                   	ret    
		writebuf(b);
  801cee:	89 d8                	mov    %ebx,%eax
  801cf0:	e8 93 ff ff ff       	call   801c88 <writebuf>
		b->idx = 0;
  801cf5:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801cfc:	eb ea                	jmp    801ce8 <putch+0x21>

00801cfe <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
  801d01:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801d07:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0a:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801d10:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801d17:	00 00 00 
	b.result = 0;
  801d1a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801d21:	00 00 00 
	b.error = 1;
  801d24:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801d2b:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801d2e:	ff 75 10             	pushl  0x10(%ebp)
  801d31:	ff 75 0c             	pushl  0xc(%ebp)
  801d34:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801d3a:	50                   	push   %eax
  801d3b:	68 c7 1c 80 00       	push   $0x801cc7
  801d40:	e8 b1 e8 ff ff       	call   8005f6 <vprintfmt>
	if (b.idx > 0)
  801d45:	83 c4 10             	add    $0x10,%esp
  801d48:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801d4f:	7f 11                	jg     801d62 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801d51:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801d57:	85 c0                	test   %eax,%eax
  801d59:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801d60:	c9                   	leave  
  801d61:	c3                   	ret    
		writebuf(&b);
  801d62:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801d68:	e8 1b ff ff ff       	call   801c88 <writebuf>
  801d6d:	eb e2                	jmp    801d51 <vfprintf+0x53>

00801d6f <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801d6f:	55                   	push   %ebp
  801d70:	89 e5                	mov    %esp,%ebp
  801d72:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801d75:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801d78:	50                   	push   %eax
  801d79:	ff 75 0c             	pushl  0xc(%ebp)
  801d7c:	ff 75 08             	pushl  0x8(%ebp)
  801d7f:	e8 7a ff ff ff       	call   801cfe <vfprintf>
	va_end(ap);

	return cnt;
}
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <printf>:

int
printf(const char *fmt, ...)
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
  801d89:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801d8c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801d8f:	50                   	push   %eax
  801d90:	ff 75 08             	pushl  0x8(%ebp)
  801d93:	6a 01                	push   $0x1
  801d95:	e8 64 ff ff ff       	call   801cfe <vfprintf>
	va_end(ap);

	return cnt;
}
  801d9a:	c9                   	leave  
  801d9b:	c3                   	ret    

00801d9c <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
  801d9f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801da2:	68 fb 2f 80 00       	push   $0x802ffb
  801da7:	ff 75 0c             	pushl  0xc(%ebp)
  801daa:	e8 79 ee ff ff       	call   800c28 <strcpy>
	return 0;
}
  801daf:	b8 00 00 00 00       	mov    $0x0,%eax
  801db4:	c9                   	leave  
  801db5:	c3                   	ret    

00801db6 <devsock_close>:
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
  801db9:	53                   	push   %ebx
  801dba:	83 ec 10             	sub    $0x10,%esp
  801dbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801dc0:	53                   	push   %ebx
  801dc1:	e8 fc 09 00 00       	call   8027c2 <pageref>
  801dc6:	83 c4 10             	add    $0x10,%esp
		return 0;
  801dc9:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801dce:	83 f8 01             	cmp    $0x1,%eax
  801dd1:	74 07                	je     801dda <devsock_close+0x24>
}
  801dd3:	89 d0                	mov    %edx,%eax
  801dd5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dd8:	c9                   	leave  
  801dd9:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801dda:	83 ec 0c             	sub    $0xc,%esp
  801ddd:	ff 73 0c             	pushl  0xc(%ebx)
  801de0:	e8 b9 02 00 00       	call   80209e <nsipc_close>
  801de5:	89 c2                	mov    %eax,%edx
  801de7:	83 c4 10             	add    $0x10,%esp
  801dea:	eb e7                	jmp    801dd3 <devsock_close+0x1d>

00801dec <devsock_write>:
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
  801def:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801df2:	6a 00                	push   $0x0
  801df4:	ff 75 10             	pushl  0x10(%ebp)
  801df7:	ff 75 0c             	pushl  0xc(%ebp)
  801dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfd:	ff 70 0c             	pushl  0xc(%eax)
  801e00:	e8 76 03 00 00       	call   80217b <nsipc_send>
}
  801e05:	c9                   	leave  
  801e06:	c3                   	ret    

00801e07 <devsock_read>:
{
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
  801e0a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e0d:	6a 00                	push   $0x0
  801e0f:	ff 75 10             	pushl  0x10(%ebp)
  801e12:	ff 75 0c             	pushl  0xc(%ebp)
  801e15:	8b 45 08             	mov    0x8(%ebp),%eax
  801e18:	ff 70 0c             	pushl  0xc(%eax)
  801e1b:	e8 ef 02 00 00       	call   80210f <nsipc_recv>
}
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <fd2sockid>:
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
  801e25:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801e28:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e2b:	52                   	push   %edx
  801e2c:	50                   	push   %eax
  801e2d:	e8 a3 f6 ff ff       	call   8014d5 <fd_lookup>
  801e32:	83 c4 10             	add    $0x10,%esp
  801e35:	85 c0                	test   %eax,%eax
  801e37:	78 10                	js     801e49 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3c:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801e42:	39 08                	cmp    %ecx,(%eax)
  801e44:	75 05                	jne    801e4b <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801e46:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801e49:	c9                   	leave  
  801e4a:	c3                   	ret    
		return -E_NOT_SUPP;
  801e4b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e50:	eb f7                	jmp    801e49 <fd2sockid+0x27>

00801e52 <alloc_sockfd>:
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
  801e55:	56                   	push   %esi
  801e56:	53                   	push   %ebx
  801e57:	83 ec 1c             	sub    $0x1c,%esp
  801e5a:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801e5c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e5f:	50                   	push   %eax
  801e60:	e8 1e f6 ff ff       	call   801483 <fd_alloc>
  801e65:	89 c3                	mov    %eax,%ebx
  801e67:	83 c4 10             	add    $0x10,%esp
  801e6a:	85 c0                	test   %eax,%eax
  801e6c:	78 43                	js     801eb1 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801e6e:	83 ec 04             	sub    $0x4,%esp
  801e71:	68 07 04 00 00       	push   $0x407
  801e76:	ff 75 f4             	pushl  -0xc(%ebp)
  801e79:	6a 00                	push   $0x0
  801e7b:	e8 9a f1 ff ff       	call   80101a <sys_page_alloc>
  801e80:	89 c3                	mov    %eax,%ebx
  801e82:	83 c4 10             	add    $0x10,%esp
  801e85:	85 c0                	test   %eax,%eax
  801e87:	78 28                	js     801eb1 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8c:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801e92:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e97:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801e9e:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801ea1:	83 ec 0c             	sub    $0xc,%esp
  801ea4:	50                   	push   %eax
  801ea5:	e8 b2 f5 ff ff       	call   80145c <fd2num>
  801eaa:	89 c3                	mov    %eax,%ebx
  801eac:	83 c4 10             	add    $0x10,%esp
  801eaf:	eb 0c                	jmp    801ebd <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801eb1:	83 ec 0c             	sub    $0xc,%esp
  801eb4:	56                   	push   %esi
  801eb5:	e8 e4 01 00 00       	call   80209e <nsipc_close>
		return r;
  801eba:	83 c4 10             	add    $0x10,%esp
}
  801ebd:	89 d8                	mov    %ebx,%eax
  801ebf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ec2:	5b                   	pop    %ebx
  801ec3:	5e                   	pop    %esi
  801ec4:	5d                   	pop    %ebp
  801ec5:	c3                   	ret    

00801ec6 <accept>:
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
  801ec9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecf:	e8 4e ff ff ff       	call   801e22 <fd2sockid>
  801ed4:	85 c0                	test   %eax,%eax
  801ed6:	78 1b                	js     801ef3 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ed8:	83 ec 04             	sub    $0x4,%esp
  801edb:	ff 75 10             	pushl  0x10(%ebp)
  801ede:	ff 75 0c             	pushl  0xc(%ebp)
  801ee1:	50                   	push   %eax
  801ee2:	e8 0e 01 00 00       	call   801ff5 <nsipc_accept>
  801ee7:	83 c4 10             	add    $0x10,%esp
  801eea:	85 c0                	test   %eax,%eax
  801eec:	78 05                	js     801ef3 <accept+0x2d>
	return alloc_sockfd(r);
  801eee:	e8 5f ff ff ff       	call   801e52 <alloc_sockfd>
}
  801ef3:	c9                   	leave  
  801ef4:	c3                   	ret    

00801ef5 <bind>:
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
  801ef8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801efb:	8b 45 08             	mov    0x8(%ebp),%eax
  801efe:	e8 1f ff ff ff       	call   801e22 <fd2sockid>
  801f03:	85 c0                	test   %eax,%eax
  801f05:	78 12                	js     801f19 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801f07:	83 ec 04             	sub    $0x4,%esp
  801f0a:	ff 75 10             	pushl  0x10(%ebp)
  801f0d:	ff 75 0c             	pushl  0xc(%ebp)
  801f10:	50                   	push   %eax
  801f11:	e8 31 01 00 00       	call   802047 <nsipc_bind>
  801f16:	83 c4 10             	add    $0x10,%esp
}
  801f19:	c9                   	leave  
  801f1a:	c3                   	ret    

00801f1b <shutdown>:
{
  801f1b:	55                   	push   %ebp
  801f1c:	89 e5                	mov    %esp,%ebp
  801f1e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f21:	8b 45 08             	mov    0x8(%ebp),%eax
  801f24:	e8 f9 fe ff ff       	call   801e22 <fd2sockid>
  801f29:	85 c0                	test   %eax,%eax
  801f2b:	78 0f                	js     801f3c <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801f2d:	83 ec 08             	sub    $0x8,%esp
  801f30:	ff 75 0c             	pushl  0xc(%ebp)
  801f33:	50                   	push   %eax
  801f34:	e8 43 01 00 00       	call   80207c <nsipc_shutdown>
  801f39:	83 c4 10             	add    $0x10,%esp
}
  801f3c:	c9                   	leave  
  801f3d:	c3                   	ret    

00801f3e <connect>:
{
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
  801f41:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f44:	8b 45 08             	mov    0x8(%ebp),%eax
  801f47:	e8 d6 fe ff ff       	call   801e22 <fd2sockid>
  801f4c:	85 c0                	test   %eax,%eax
  801f4e:	78 12                	js     801f62 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801f50:	83 ec 04             	sub    $0x4,%esp
  801f53:	ff 75 10             	pushl  0x10(%ebp)
  801f56:	ff 75 0c             	pushl  0xc(%ebp)
  801f59:	50                   	push   %eax
  801f5a:	e8 59 01 00 00       	call   8020b8 <nsipc_connect>
  801f5f:	83 c4 10             	add    $0x10,%esp
}
  801f62:	c9                   	leave  
  801f63:	c3                   	ret    

00801f64 <listen>:
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
  801f67:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6d:	e8 b0 fe ff ff       	call   801e22 <fd2sockid>
  801f72:	85 c0                	test   %eax,%eax
  801f74:	78 0f                	js     801f85 <listen+0x21>
	return nsipc_listen(r, backlog);
  801f76:	83 ec 08             	sub    $0x8,%esp
  801f79:	ff 75 0c             	pushl  0xc(%ebp)
  801f7c:	50                   	push   %eax
  801f7d:	e8 6b 01 00 00       	call   8020ed <nsipc_listen>
  801f82:	83 c4 10             	add    $0x10,%esp
}
  801f85:	c9                   	leave  
  801f86:	c3                   	ret    

00801f87 <socket>:

int
socket(int domain, int type, int protocol)
{
  801f87:	55                   	push   %ebp
  801f88:	89 e5                	mov    %esp,%ebp
  801f8a:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f8d:	ff 75 10             	pushl  0x10(%ebp)
  801f90:	ff 75 0c             	pushl  0xc(%ebp)
  801f93:	ff 75 08             	pushl  0x8(%ebp)
  801f96:	e8 3e 02 00 00       	call   8021d9 <nsipc_socket>
  801f9b:	83 c4 10             	add    $0x10,%esp
  801f9e:	85 c0                	test   %eax,%eax
  801fa0:	78 05                	js     801fa7 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801fa2:	e8 ab fe ff ff       	call   801e52 <alloc_sockfd>
}
  801fa7:	c9                   	leave  
  801fa8:	c3                   	ret    

00801fa9 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801fa9:	55                   	push   %ebp
  801faa:	89 e5                	mov    %esp,%ebp
  801fac:	53                   	push   %ebx
  801fad:	83 ec 04             	sub    $0x4,%esp
  801fb0:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801fb2:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801fb9:	74 26                	je     801fe1 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801fbb:	6a 07                	push   $0x7
  801fbd:	68 00 70 80 00       	push   $0x807000
  801fc2:	53                   	push   %ebx
  801fc3:	ff 35 04 50 80 00    	pushl  0x805004
  801fc9:	e8 61 07 00 00       	call   80272f <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801fce:	83 c4 0c             	add    $0xc,%esp
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	e8 ea 06 00 00       	call   8026c6 <ipc_recv>
}
  801fdc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fdf:	c9                   	leave  
  801fe0:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801fe1:	83 ec 0c             	sub    $0xc,%esp
  801fe4:	6a 02                	push   $0x2
  801fe6:	e8 9c 07 00 00       	call   802787 <ipc_find_env>
  801feb:	a3 04 50 80 00       	mov    %eax,0x805004
  801ff0:	83 c4 10             	add    $0x10,%esp
  801ff3:	eb c6                	jmp    801fbb <nsipc+0x12>

00801ff5 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
  801ff8:	56                   	push   %esi
  801ff9:	53                   	push   %ebx
  801ffa:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  802000:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802005:	8b 06                	mov    (%esi),%eax
  802007:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80200c:	b8 01 00 00 00       	mov    $0x1,%eax
  802011:	e8 93 ff ff ff       	call   801fa9 <nsipc>
  802016:	89 c3                	mov    %eax,%ebx
  802018:	85 c0                	test   %eax,%eax
  80201a:	79 09                	jns    802025 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80201c:	89 d8                	mov    %ebx,%eax
  80201e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802021:	5b                   	pop    %ebx
  802022:	5e                   	pop    %esi
  802023:	5d                   	pop    %ebp
  802024:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802025:	83 ec 04             	sub    $0x4,%esp
  802028:	ff 35 10 70 80 00    	pushl  0x807010
  80202e:	68 00 70 80 00       	push   $0x807000
  802033:	ff 75 0c             	pushl  0xc(%ebp)
  802036:	e8 7b ed ff ff       	call   800db6 <memmove>
		*addrlen = ret->ret_addrlen;
  80203b:	a1 10 70 80 00       	mov    0x807010,%eax
  802040:	89 06                	mov    %eax,(%esi)
  802042:	83 c4 10             	add    $0x10,%esp
	return r;
  802045:	eb d5                	jmp    80201c <nsipc_accept+0x27>

00802047 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802047:	55                   	push   %ebp
  802048:	89 e5                	mov    %esp,%ebp
  80204a:	53                   	push   %ebx
  80204b:	83 ec 08             	sub    $0x8,%esp
  80204e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802051:	8b 45 08             	mov    0x8(%ebp),%eax
  802054:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802059:	53                   	push   %ebx
  80205a:	ff 75 0c             	pushl  0xc(%ebp)
  80205d:	68 04 70 80 00       	push   $0x807004
  802062:	e8 4f ed ff ff       	call   800db6 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802067:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80206d:	b8 02 00 00 00       	mov    $0x2,%eax
  802072:	e8 32 ff ff ff       	call   801fa9 <nsipc>
}
  802077:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80207a:	c9                   	leave  
  80207b:	c3                   	ret    

0080207c <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80207c:	55                   	push   %ebp
  80207d:	89 e5                	mov    %esp,%ebp
  80207f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802082:	8b 45 08             	mov    0x8(%ebp),%eax
  802085:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80208a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80208d:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802092:	b8 03 00 00 00       	mov    $0x3,%eax
  802097:	e8 0d ff ff ff       	call   801fa9 <nsipc>
}
  80209c:	c9                   	leave  
  80209d:	c3                   	ret    

0080209e <nsipc_close>:

int
nsipc_close(int s)
{
  80209e:	55                   	push   %ebp
  80209f:	89 e5                	mov    %esp,%ebp
  8020a1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8020a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a7:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8020ac:	b8 04 00 00 00       	mov    $0x4,%eax
  8020b1:	e8 f3 fe ff ff       	call   801fa9 <nsipc>
}
  8020b6:	c9                   	leave  
  8020b7:	c3                   	ret    

008020b8 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020b8:	55                   	push   %ebp
  8020b9:	89 e5                	mov    %esp,%ebp
  8020bb:	53                   	push   %ebx
  8020bc:	83 ec 08             	sub    $0x8,%esp
  8020bf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8020c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c5:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8020ca:	53                   	push   %ebx
  8020cb:	ff 75 0c             	pushl  0xc(%ebp)
  8020ce:	68 04 70 80 00       	push   $0x807004
  8020d3:	e8 de ec ff ff       	call   800db6 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8020d8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8020de:	b8 05 00 00 00       	mov    $0x5,%eax
  8020e3:	e8 c1 fe ff ff       	call   801fa9 <nsipc>
}
  8020e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020eb:	c9                   	leave  
  8020ec:	c3                   	ret    

008020ed <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8020ed:	55                   	push   %ebp
  8020ee:	89 e5                	mov    %esp,%ebp
  8020f0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8020f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f6:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8020fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020fe:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802103:	b8 06 00 00 00       	mov    $0x6,%eax
  802108:	e8 9c fe ff ff       	call   801fa9 <nsipc>
}
  80210d:	c9                   	leave  
  80210e:	c3                   	ret    

0080210f <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80210f:	55                   	push   %ebp
  802110:	89 e5                	mov    %esp,%ebp
  802112:	56                   	push   %esi
  802113:	53                   	push   %ebx
  802114:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802117:	8b 45 08             	mov    0x8(%ebp),%eax
  80211a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80211f:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802125:	8b 45 14             	mov    0x14(%ebp),%eax
  802128:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80212d:	b8 07 00 00 00       	mov    $0x7,%eax
  802132:	e8 72 fe ff ff       	call   801fa9 <nsipc>
  802137:	89 c3                	mov    %eax,%ebx
  802139:	85 c0                	test   %eax,%eax
  80213b:	78 1f                	js     80215c <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80213d:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802142:	7f 21                	jg     802165 <nsipc_recv+0x56>
  802144:	39 c6                	cmp    %eax,%esi
  802146:	7c 1d                	jl     802165 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802148:	83 ec 04             	sub    $0x4,%esp
  80214b:	50                   	push   %eax
  80214c:	68 00 70 80 00       	push   $0x807000
  802151:	ff 75 0c             	pushl  0xc(%ebp)
  802154:	e8 5d ec ff ff       	call   800db6 <memmove>
  802159:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80215c:	89 d8                	mov    %ebx,%eax
  80215e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802161:	5b                   	pop    %ebx
  802162:	5e                   	pop    %esi
  802163:	5d                   	pop    %ebp
  802164:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802165:	68 07 30 80 00       	push   $0x803007
  80216a:	68 cf 2f 80 00       	push   $0x802fcf
  80216f:	6a 62                	push   $0x62
  802171:	68 1c 30 80 00       	push   $0x80301c
  802176:	e8 58 e2 ff ff       	call   8003d3 <_panic>

0080217b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80217b:	55                   	push   %ebp
  80217c:	89 e5                	mov    %esp,%ebp
  80217e:	53                   	push   %ebx
  80217f:	83 ec 04             	sub    $0x4,%esp
  802182:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802185:	8b 45 08             	mov    0x8(%ebp),%eax
  802188:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80218d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802193:	7f 2e                	jg     8021c3 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802195:	83 ec 04             	sub    $0x4,%esp
  802198:	53                   	push   %ebx
  802199:	ff 75 0c             	pushl  0xc(%ebp)
  80219c:	68 0c 70 80 00       	push   $0x80700c
  8021a1:	e8 10 ec ff ff       	call   800db6 <memmove>
	nsipcbuf.send.req_size = size;
  8021a6:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8021ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8021af:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8021b4:	b8 08 00 00 00       	mov    $0x8,%eax
  8021b9:	e8 eb fd ff ff       	call   801fa9 <nsipc>
}
  8021be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021c1:	c9                   	leave  
  8021c2:	c3                   	ret    
	assert(size < 1600);
  8021c3:	68 28 30 80 00       	push   $0x803028
  8021c8:	68 cf 2f 80 00       	push   $0x802fcf
  8021cd:	6a 6d                	push   $0x6d
  8021cf:	68 1c 30 80 00       	push   $0x80301c
  8021d4:	e8 fa e1 ff ff       	call   8003d3 <_panic>

008021d9 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8021d9:	55                   	push   %ebp
  8021da:	89 e5                	mov    %esp,%ebp
  8021dc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8021df:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8021e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ea:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8021ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8021f2:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8021f7:	b8 09 00 00 00       	mov    $0x9,%eax
  8021fc:	e8 a8 fd ff ff       	call   801fa9 <nsipc>
}
  802201:	c9                   	leave  
  802202:	c3                   	ret    

00802203 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802203:	55                   	push   %ebp
  802204:	89 e5                	mov    %esp,%ebp
  802206:	56                   	push   %esi
  802207:	53                   	push   %ebx
  802208:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80220b:	83 ec 0c             	sub    $0xc,%esp
  80220e:	ff 75 08             	pushl  0x8(%ebp)
  802211:	e8 56 f2 ff ff       	call   80146c <fd2data>
  802216:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802218:	83 c4 08             	add    $0x8,%esp
  80221b:	68 34 30 80 00       	push   $0x803034
  802220:	53                   	push   %ebx
  802221:	e8 02 ea ff ff       	call   800c28 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802226:	8b 46 04             	mov    0x4(%esi),%eax
  802229:	2b 06                	sub    (%esi),%eax
  80222b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802231:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802238:	00 00 00 
	stat->st_dev = &devpipe;
  80223b:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802242:	40 80 00 
	return 0;
}
  802245:	b8 00 00 00 00       	mov    $0x0,%eax
  80224a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80224d:	5b                   	pop    %ebx
  80224e:	5e                   	pop    %esi
  80224f:	5d                   	pop    %ebp
  802250:	c3                   	ret    

00802251 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802251:	55                   	push   %ebp
  802252:	89 e5                	mov    %esp,%ebp
  802254:	53                   	push   %ebx
  802255:	83 ec 0c             	sub    $0xc,%esp
  802258:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80225b:	53                   	push   %ebx
  80225c:	6a 00                	push   $0x0
  80225e:	e8 3c ee ff ff       	call   80109f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802263:	89 1c 24             	mov    %ebx,(%esp)
  802266:	e8 01 f2 ff ff       	call   80146c <fd2data>
  80226b:	83 c4 08             	add    $0x8,%esp
  80226e:	50                   	push   %eax
  80226f:	6a 00                	push   $0x0
  802271:	e8 29 ee ff ff       	call   80109f <sys_page_unmap>
}
  802276:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802279:	c9                   	leave  
  80227a:	c3                   	ret    

0080227b <_pipeisclosed>:
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
  80227e:	57                   	push   %edi
  80227f:	56                   	push   %esi
  802280:	53                   	push   %ebx
  802281:	83 ec 1c             	sub    $0x1c,%esp
  802284:	89 c7                	mov    %eax,%edi
  802286:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802288:	a1 20 54 80 00       	mov    0x805420,%eax
  80228d:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802290:	83 ec 0c             	sub    $0xc,%esp
  802293:	57                   	push   %edi
  802294:	e8 29 05 00 00       	call   8027c2 <pageref>
  802299:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80229c:	89 34 24             	mov    %esi,(%esp)
  80229f:	e8 1e 05 00 00       	call   8027c2 <pageref>
		nn = thisenv->env_runs;
  8022a4:	8b 15 20 54 80 00    	mov    0x805420,%edx
  8022aa:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8022ad:	83 c4 10             	add    $0x10,%esp
  8022b0:	39 cb                	cmp    %ecx,%ebx
  8022b2:	74 1b                	je     8022cf <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8022b4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8022b7:	75 cf                	jne    802288 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8022b9:	8b 42 58             	mov    0x58(%edx),%eax
  8022bc:	6a 01                	push   $0x1
  8022be:	50                   	push   %eax
  8022bf:	53                   	push   %ebx
  8022c0:	68 3b 30 80 00       	push   $0x80303b
  8022c5:	e8 ff e1 ff ff       	call   8004c9 <cprintf>
  8022ca:	83 c4 10             	add    $0x10,%esp
  8022cd:	eb b9                	jmp    802288 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8022cf:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8022d2:	0f 94 c0             	sete   %al
  8022d5:	0f b6 c0             	movzbl %al,%eax
}
  8022d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022db:	5b                   	pop    %ebx
  8022dc:	5e                   	pop    %esi
  8022dd:	5f                   	pop    %edi
  8022de:	5d                   	pop    %ebp
  8022df:	c3                   	ret    

008022e0 <devpipe_write>:
{
  8022e0:	55                   	push   %ebp
  8022e1:	89 e5                	mov    %esp,%ebp
  8022e3:	57                   	push   %edi
  8022e4:	56                   	push   %esi
  8022e5:	53                   	push   %ebx
  8022e6:	83 ec 28             	sub    $0x28,%esp
  8022e9:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8022ec:	56                   	push   %esi
  8022ed:	e8 7a f1 ff ff       	call   80146c <fd2data>
  8022f2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8022f4:	83 c4 10             	add    $0x10,%esp
  8022f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8022fc:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8022ff:	74 4f                	je     802350 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802301:	8b 43 04             	mov    0x4(%ebx),%eax
  802304:	8b 0b                	mov    (%ebx),%ecx
  802306:	8d 51 20             	lea    0x20(%ecx),%edx
  802309:	39 d0                	cmp    %edx,%eax
  80230b:	72 14                	jb     802321 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80230d:	89 da                	mov    %ebx,%edx
  80230f:	89 f0                	mov    %esi,%eax
  802311:	e8 65 ff ff ff       	call   80227b <_pipeisclosed>
  802316:	85 c0                	test   %eax,%eax
  802318:	75 3b                	jne    802355 <devpipe_write+0x75>
			sys_yield();
  80231a:	e8 dc ec ff ff       	call   800ffb <sys_yield>
  80231f:	eb e0                	jmp    802301 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802321:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802324:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802328:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80232b:	89 c2                	mov    %eax,%edx
  80232d:	c1 fa 1f             	sar    $0x1f,%edx
  802330:	89 d1                	mov    %edx,%ecx
  802332:	c1 e9 1b             	shr    $0x1b,%ecx
  802335:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802338:	83 e2 1f             	and    $0x1f,%edx
  80233b:	29 ca                	sub    %ecx,%edx
  80233d:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802341:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802345:	83 c0 01             	add    $0x1,%eax
  802348:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80234b:	83 c7 01             	add    $0x1,%edi
  80234e:	eb ac                	jmp    8022fc <devpipe_write+0x1c>
	return i;
  802350:	8b 45 10             	mov    0x10(%ebp),%eax
  802353:	eb 05                	jmp    80235a <devpipe_write+0x7a>
				return 0;
  802355:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80235a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80235d:	5b                   	pop    %ebx
  80235e:	5e                   	pop    %esi
  80235f:	5f                   	pop    %edi
  802360:	5d                   	pop    %ebp
  802361:	c3                   	ret    

00802362 <devpipe_read>:
{
  802362:	55                   	push   %ebp
  802363:	89 e5                	mov    %esp,%ebp
  802365:	57                   	push   %edi
  802366:	56                   	push   %esi
  802367:	53                   	push   %ebx
  802368:	83 ec 18             	sub    $0x18,%esp
  80236b:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80236e:	57                   	push   %edi
  80236f:	e8 f8 f0 ff ff       	call   80146c <fd2data>
  802374:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802376:	83 c4 10             	add    $0x10,%esp
  802379:	be 00 00 00 00       	mov    $0x0,%esi
  80237e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802381:	75 14                	jne    802397 <devpipe_read+0x35>
	return i;
  802383:	8b 45 10             	mov    0x10(%ebp),%eax
  802386:	eb 02                	jmp    80238a <devpipe_read+0x28>
				return i;
  802388:	89 f0                	mov    %esi,%eax
}
  80238a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80238d:	5b                   	pop    %ebx
  80238e:	5e                   	pop    %esi
  80238f:	5f                   	pop    %edi
  802390:	5d                   	pop    %ebp
  802391:	c3                   	ret    
			sys_yield();
  802392:	e8 64 ec ff ff       	call   800ffb <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802397:	8b 03                	mov    (%ebx),%eax
  802399:	3b 43 04             	cmp    0x4(%ebx),%eax
  80239c:	75 18                	jne    8023b6 <devpipe_read+0x54>
			if (i > 0)
  80239e:	85 f6                	test   %esi,%esi
  8023a0:	75 e6                	jne    802388 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8023a2:	89 da                	mov    %ebx,%edx
  8023a4:	89 f8                	mov    %edi,%eax
  8023a6:	e8 d0 fe ff ff       	call   80227b <_pipeisclosed>
  8023ab:	85 c0                	test   %eax,%eax
  8023ad:	74 e3                	je     802392 <devpipe_read+0x30>
				return 0;
  8023af:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b4:	eb d4                	jmp    80238a <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8023b6:	99                   	cltd   
  8023b7:	c1 ea 1b             	shr    $0x1b,%edx
  8023ba:	01 d0                	add    %edx,%eax
  8023bc:	83 e0 1f             	and    $0x1f,%eax
  8023bf:	29 d0                	sub    %edx,%eax
  8023c1:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8023c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023c9:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8023cc:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8023cf:	83 c6 01             	add    $0x1,%esi
  8023d2:	eb aa                	jmp    80237e <devpipe_read+0x1c>

008023d4 <pipe>:
{
  8023d4:	55                   	push   %ebp
  8023d5:	89 e5                	mov    %esp,%ebp
  8023d7:	56                   	push   %esi
  8023d8:	53                   	push   %ebx
  8023d9:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8023dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023df:	50                   	push   %eax
  8023e0:	e8 9e f0 ff ff       	call   801483 <fd_alloc>
  8023e5:	89 c3                	mov    %eax,%ebx
  8023e7:	83 c4 10             	add    $0x10,%esp
  8023ea:	85 c0                	test   %eax,%eax
  8023ec:	0f 88 23 01 00 00    	js     802515 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023f2:	83 ec 04             	sub    $0x4,%esp
  8023f5:	68 07 04 00 00       	push   $0x407
  8023fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8023fd:	6a 00                	push   $0x0
  8023ff:	e8 16 ec ff ff       	call   80101a <sys_page_alloc>
  802404:	89 c3                	mov    %eax,%ebx
  802406:	83 c4 10             	add    $0x10,%esp
  802409:	85 c0                	test   %eax,%eax
  80240b:	0f 88 04 01 00 00    	js     802515 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802411:	83 ec 0c             	sub    $0xc,%esp
  802414:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802417:	50                   	push   %eax
  802418:	e8 66 f0 ff ff       	call   801483 <fd_alloc>
  80241d:	89 c3                	mov    %eax,%ebx
  80241f:	83 c4 10             	add    $0x10,%esp
  802422:	85 c0                	test   %eax,%eax
  802424:	0f 88 db 00 00 00    	js     802505 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80242a:	83 ec 04             	sub    $0x4,%esp
  80242d:	68 07 04 00 00       	push   $0x407
  802432:	ff 75 f0             	pushl  -0x10(%ebp)
  802435:	6a 00                	push   $0x0
  802437:	e8 de eb ff ff       	call   80101a <sys_page_alloc>
  80243c:	89 c3                	mov    %eax,%ebx
  80243e:	83 c4 10             	add    $0x10,%esp
  802441:	85 c0                	test   %eax,%eax
  802443:	0f 88 bc 00 00 00    	js     802505 <pipe+0x131>
	va = fd2data(fd0);
  802449:	83 ec 0c             	sub    $0xc,%esp
  80244c:	ff 75 f4             	pushl  -0xc(%ebp)
  80244f:	e8 18 f0 ff ff       	call   80146c <fd2data>
  802454:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802456:	83 c4 0c             	add    $0xc,%esp
  802459:	68 07 04 00 00       	push   $0x407
  80245e:	50                   	push   %eax
  80245f:	6a 00                	push   $0x0
  802461:	e8 b4 eb ff ff       	call   80101a <sys_page_alloc>
  802466:	89 c3                	mov    %eax,%ebx
  802468:	83 c4 10             	add    $0x10,%esp
  80246b:	85 c0                	test   %eax,%eax
  80246d:	0f 88 82 00 00 00    	js     8024f5 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802473:	83 ec 0c             	sub    $0xc,%esp
  802476:	ff 75 f0             	pushl  -0x10(%ebp)
  802479:	e8 ee ef ff ff       	call   80146c <fd2data>
  80247e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802485:	50                   	push   %eax
  802486:	6a 00                	push   $0x0
  802488:	56                   	push   %esi
  802489:	6a 00                	push   $0x0
  80248b:	e8 cd eb ff ff       	call   80105d <sys_page_map>
  802490:	89 c3                	mov    %eax,%ebx
  802492:	83 c4 20             	add    $0x20,%esp
  802495:	85 c0                	test   %eax,%eax
  802497:	78 4e                	js     8024e7 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802499:	a1 3c 40 80 00       	mov    0x80403c,%eax
  80249e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a1:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8024a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a6:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8024ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024b0:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8024b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8024bc:	83 ec 0c             	sub    $0xc,%esp
  8024bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8024c2:	e8 95 ef ff ff       	call   80145c <fd2num>
  8024c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024ca:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8024cc:	83 c4 04             	add    $0x4,%esp
  8024cf:	ff 75 f0             	pushl  -0x10(%ebp)
  8024d2:	e8 85 ef ff ff       	call   80145c <fd2num>
  8024d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024da:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8024dd:	83 c4 10             	add    $0x10,%esp
  8024e0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8024e5:	eb 2e                	jmp    802515 <pipe+0x141>
	sys_page_unmap(0, va);
  8024e7:	83 ec 08             	sub    $0x8,%esp
  8024ea:	56                   	push   %esi
  8024eb:	6a 00                	push   $0x0
  8024ed:	e8 ad eb ff ff       	call   80109f <sys_page_unmap>
  8024f2:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8024f5:	83 ec 08             	sub    $0x8,%esp
  8024f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8024fb:	6a 00                	push   $0x0
  8024fd:	e8 9d eb ff ff       	call   80109f <sys_page_unmap>
  802502:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802505:	83 ec 08             	sub    $0x8,%esp
  802508:	ff 75 f4             	pushl  -0xc(%ebp)
  80250b:	6a 00                	push   $0x0
  80250d:	e8 8d eb ff ff       	call   80109f <sys_page_unmap>
  802512:	83 c4 10             	add    $0x10,%esp
}
  802515:	89 d8                	mov    %ebx,%eax
  802517:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80251a:	5b                   	pop    %ebx
  80251b:	5e                   	pop    %esi
  80251c:	5d                   	pop    %ebp
  80251d:	c3                   	ret    

0080251e <pipeisclosed>:
{
  80251e:	55                   	push   %ebp
  80251f:	89 e5                	mov    %esp,%ebp
  802521:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802524:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802527:	50                   	push   %eax
  802528:	ff 75 08             	pushl  0x8(%ebp)
  80252b:	e8 a5 ef ff ff       	call   8014d5 <fd_lookup>
  802530:	83 c4 10             	add    $0x10,%esp
  802533:	85 c0                	test   %eax,%eax
  802535:	78 18                	js     80254f <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802537:	83 ec 0c             	sub    $0xc,%esp
  80253a:	ff 75 f4             	pushl  -0xc(%ebp)
  80253d:	e8 2a ef ff ff       	call   80146c <fd2data>
	return _pipeisclosed(fd, p);
  802542:	89 c2                	mov    %eax,%edx
  802544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802547:	e8 2f fd ff ff       	call   80227b <_pipeisclosed>
  80254c:	83 c4 10             	add    $0x10,%esp
}
  80254f:	c9                   	leave  
  802550:	c3                   	ret    

00802551 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802551:	b8 00 00 00 00       	mov    $0x0,%eax
  802556:	c3                   	ret    

00802557 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802557:	55                   	push   %ebp
  802558:	89 e5                	mov    %esp,%ebp
  80255a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80255d:	68 53 30 80 00       	push   $0x803053
  802562:	ff 75 0c             	pushl  0xc(%ebp)
  802565:	e8 be e6 ff ff       	call   800c28 <strcpy>
	return 0;
}
  80256a:	b8 00 00 00 00       	mov    $0x0,%eax
  80256f:	c9                   	leave  
  802570:	c3                   	ret    

00802571 <devcons_write>:
{
  802571:	55                   	push   %ebp
  802572:	89 e5                	mov    %esp,%ebp
  802574:	57                   	push   %edi
  802575:	56                   	push   %esi
  802576:	53                   	push   %ebx
  802577:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80257d:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802582:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802588:	3b 75 10             	cmp    0x10(%ebp),%esi
  80258b:	73 31                	jae    8025be <devcons_write+0x4d>
		m = n - tot;
  80258d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802590:	29 f3                	sub    %esi,%ebx
  802592:	83 fb 7f             	cmp    $0x7f,%ebx
  802595:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80259a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80259d:	83 ec 04             	sub    $0x4,%esp
  8025a0:	53                   	push   %ebx
  8025a1:	89 f0                	mov    %esi,%eax
  8025a3:	03 45 0c             	add    0xc(%ebp),%eax
  8025a6:	50                   	push   %eax
  8025a7:	57                   	push   %edi
  8025a8:	e8 09 e8 ff ff       	call   800db6 <memmove>
		sys_cputs(buf, m);
  8025ad:	83 c4 08             	add    $0x8,%esp
  8025b0:	53                   	push   %ebx
  8025b1:	57                   	push   %edi
  8025b2:	e8 a7 e9 ff ff       	call   800f5e <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8025b7:	01 de                	add    %ebx,%esi
  8025b9:	83 c4 10             	add    $0x10,%esp
  8025bc:	eb ca                	jmp    802588 <devcons_write+0x17>
}
  8025be:	89 f0                	mov    %esi,%eax
  8025c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025c3:	5b                   	pop    %ebx
  8025c4:	5e                   	pop    %esi
  8025c5:	5f                   	pop    %edi
  8025c6:	5d                   	pop    %ebp
  8025c7:	c3                   	ret    

008025c8 <devcons_read>:
{
  8025c8:	55                   	push   %ebp
  8025c9:	89 e5                	mov    %esp,%ebp
  8025cb:	83 ec 08             	sub    $0x8,%esp
  8025ce:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8025d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025d7:	74 21                	je     8025fa <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8025d9:	e8 9e e9 ff ff       	call   800f7c <sys_cgetc>
  8025de:	85 c0                	test   %eax,%eax
  8025e0:	75 07                	jne    8025e9 <devcons_read+0x21>
		sys_yield();
  8025e2:	e8 14 ea ff ff       	call   800ffb <sys_yield>
  8025e7:	eb f0                	jmp    8025d9 <devcons_read+0x11>
	if (c < 0)
  8025e9:	78 0f                	js     8025fa <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8025eb:	83 f8 04             	cmp    $0x4,%eax
  8025ee:	74 0c                	je     8025fc <devcons_read+0x34>
	*(char*)vbuf = c;
  8025f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025f3:	88 02                	mov    %al,(%edx)
	return 1;
  8025f5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8025fa:	c9                   	leave  
  8025fb:	c3                   	ret    
		return 0;
  8025fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802601:	eb f7                	jmp    8025fa <devcons_read+0x32>

00802603 <cputchar>:
{
  802603:	55                   	push   %ebp
  802604:	89 e5                	mov    %esp,%ebp
  802606:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802609:	8b 45 08             	mov    0x8(%ebp),%eax
  80260c:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80260f:	6a 01                	push   $0x1
  802611:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802614:	50                   	push   %eax
  802615:	e8 44 e9 ff ff       	call   800f5e <sys_cputs>
}
  80261a:	83 c4 10             	add    $0x10,%esp
  80261d:	c9                   	leave  
  80261e:	c3                   	ret    

0080261f <getchar>:
{
  80261f:	55                   	push   %ebp
  802620:	89 e5                	mov    %esp,%ebp
  802622:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802625:	6a 01                	push   $0x1
  802627:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80262a:	50                   	push   %eax
  80262b:	6a 00                	push   $0x0
  80262d:	e8 13 f1 ff ff       	call   801745 <read>
	if (r < 0)
  802632:	83 c4 10             	add    $0x10,%esp
  802635:	85 c0                	test   %eax,%eax
  802637:	78 06                	js     80263f <getchar+0x20>
	if (r < 1)
  802639:	74 06                	je     802641 <getchar+0x22>
	return c;
  80263b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80263f:	c9                   	leave  
  802640:	c3                   	ret    
		return -E_EOF;
  802641:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802646:	eb f7                	jmp    80263f <getchar+0x20>

00802648 <iscons>:
{
  802648:	55                   	push   %ebp
  802649:	89 e5                	mov    %esp,%ebp
  80264b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80264e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802651:	50                   	push   %eax
  802652:	ff 75 08             	pushl  0x8(%ebp)
  802655:	e8 7b ee ff ff       	call   8014d5 <fd_lookup>
  80265a:	83 c4 10             	add    $0x10,%esp
  80265d:	85 c0                	test   %eax,%eax
  80265f:	78 11                	js     802672 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802664:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80266a:	39 10                	cmp    %edx,(%eax)
  80266c:	0f 94 c0             	sete   %al
  80266f:	0f b6 c0             	movzbl %al,%eax
}
  802672:	c9                   	leave  
  802673:	c3                   	ret    

00802674 <opencons>:
{
  802674:	55                   	push   %ebp
  802675:	89 e5                	mov    %esp,%ebp
  802677:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80267a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80267d:	50                   	push   %eax
  80267e:	e8 00 ee ff ff       	call   801483 <fd_alloc>
  802683:	83 c4 10             	add    $0x10,%esp
  802686:	85 c0                	test   %eax,%eax
  802688:	78 3a                	js     8026c4 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80268a:	83 ec 04             	sub    $0x4,%esp
  80268d:	68 07 04 00 00       	push   $0x407
  802692:	ff 75 f4             	pushl  -0xc(%ebp)
  802695:	6a 00                	push   $0x0
  802697:	e8 7e e9 ff ff       	call   80101a <sys_page_alloc>
  80269c:	83 c4 10             	add    $0x10,%esp
  80269f:	85 c0                	test   %eax,%eax
  8026a1:	78 21                	js     8026c4 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8026a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a6:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8026ac:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8026ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8026b8:	83 ec 0c             	sub    $0xc,%esp
  8026bb:	50                   	push   %eax
  8026bc:	e8 9b ed ff ff       	call   80145c <fd2num>
  8026c1:	83 c4 10             	add    $0x10,%esp
}
  8026c4:	c9                   	leave  
  8026c5:	c3                   	ret    

008026c6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8026c6:	55                   	push   %ebp
  8026c7:	89 e5                	mov    %esp,%ebp
  8026c9:	56                   	push   %esi
  8026ca:	53                   	push   %ebx
  8026cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8026ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026d1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8026d4:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8026d6:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8026db:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8026de:	83 ec 0c             	sub    $0xc,%esp
  8026e1:	50                   	push   %eax
  8026e2:	e8 e3 ea ff ff       	call   8011ca <sys_ipc_recv>
	if(ret < 0){
  8026e7:	83 c4 10             	add    $0x10,%esp
  8026ea:	85 c0                	test   %eax,%eax
  8026ec:	78 2b                	js     802719 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8026ee:	85 f6                	test   %esi,%esi
  8026f0:	74 0a                	je     8026fc <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8026f2:	a1 20 54 80 00       	mov    0x805420,%eax
  8026f7:	8b 40 74             	mov    0x74(%eax),%eax
  8026fa:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8026fc:	85 db                	test   %ebx,%ebx
  8026fe:	74 0a                	je     80270a <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802700:	a1 20 54 80 00       	mov    0x805420,%eax
  802705:	8b 40 78             	mov    0x78(%eax),%eax
  802708:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80270a:	a1 20 54 80 00       	mov    0x805420,%eax
  80270f:	8b 40 70             	mov    0x70(%eax),%eax
}
  802712:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802715:	5b                   	pop    %ebx
  802716:	5e                   	pop    %esi
  802717:	5d                   	pop    %ebp
  802718:	c3                   	ret    
		if(from_env_store)
  802719:	85 f6                	test   %esi,%esi
  80271b:	74 06                	je     802723 <ipc_recv+0x5d>
			*from_env_store = 0;
  80271d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802723:	85 db                	test   %ebx,%ebx
  802725:	74 eb                	je     802712 <ipc_recv+0x4c>
			*perm_store = 0;
  802727:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80272d:	eb e3                	jmp    802712 <ipc_recv+0x4c>

0080272f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80272f:	55                   	push   %ebp
  802730:	89 e5                	mov    %esp,%ebp
  802732:	57                   	push   %edi
  802733:	56                   	push   %esi
  802734:	53                   	push   %ebx
  802735:	83 ec 0c             	sub    $0xc,%esp
  802738:	8b 7d 08             	mov    0x8(%ebp),%edi
  80273b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80273e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802741:	85 db                	test   %ebx,%ebx
  802743:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802748:	0f 44 d8             	cmove  %eax,%ebx
  80274b:	eb 05                	jmp    802752 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80274d:	e8 a9 e8 ff ff       	call   800ffb <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802752:	ff 75 14             	pushl  0x14(%ebp)
  802755:	53                   	push   %ebx
  802756:	56                   	push   %esi
  802757:	57                   	push   %edi
  802758:	e8 4a ea ff ff       	call   8011a7 <sys_ipc_try_send>
  80275d:	83 c4 10             	add    $0x10,%esp
  802760:	85 c0                	test   %eax,%eax
  802762:	74 1b                	je     80277f <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802764:	79 e7                	jns    80274d <ipc_send+0x1e>
  802766:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802769:	74 e2                	je     80274d <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80276b:	83 ec 04             	sub    $0x4,%esp
  80276e:	68 5f 30 80 00       	push   $0x80305f
  802773:	6a 46                	push   $0x46
  802775:	68 74 30 80 00       	push   $0x803074
  80277a:	e8 54 dc ff ff       	call   8003d3 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80277f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802782:	5b                   	pop    %ebx
  802783:	5e                   	pop    %esi
  802784:	5f                   	pop    %edi
  802785:	5d                   	pop    %ebp
  802786:	c3                   	ret    

00802787 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802787:	55                   	push   %ebp
  802788:	89 e5                	mov    %esp,%ebp
  80278a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80278d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802792:	89 c2                	mov    %eax,%edx
  802794:	c1 e2 07             	shl    $0x7,%edx
  802797:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80279d:	8b 52 50             	mov    0x50(%edx),%edx
  8027a0:	39 ca                	cmp    %ecx,%edx
  8027a2:	74 11                	je     8027b5 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8027a4:	83 c0 01             	add    $0x1,%eax
  8027a7:	3d 00 04 00 00       	cmp    $0x400,%eax
  8027ac:	75 e4                	jne    802792 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8027ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b3:	eb 0b                	jmp    8027c0 <ipc_find_env+0x39>
			return envs[i].env_id;
  8027b5:	c1 e0 07             	shl    $0x7,%eax
  8027b8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8027bd:	8b 40 48             	mov    0x48(%eax),%eax
}
  8027c0:	5d                   	pop    %ebp
  8027c1:	c3                   	ret    

008027c2 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8027c2:	55                   	push   %ebp
  8027c3:	89 e5                	mov    %esp,%ebp
  8027c5:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8027c8:	89 d0                	mov    %edx,%eax
  8027ca:	c1 e8 16             	shr    $0x16,%eax
  8027cd:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8027d4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8027d9:	f6 c1 01             	test   $0x1,%cl
  8027dc:	74 1d                	je     8027fb <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8027de:	c1 ea 0c             	shr    $0xc,%edx
  8027e1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8027e8:	f6 c2 01             	test   $0x1,%dl
  8027eb:	74 0e                	je     8027fb <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8027ed:	c1 ea 0c             	shr    $0xc,%edx
  8027f0:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8027f7:	ef 
  8027f8:	0f b7 c0             	movzwl %ax,%eax
}
  8027fb:	5d                   	pop    %ebp
  8027fc:	c3                   	ret    
  8027fd:	66 90                	xchg   %ax,%ax
  8027ff:	90                   	nop

00802800 <__udivdi3>:
  802800:	55                   	push   %ebp
  802801:	57                   	push   %edi
  802802:	56                   	push   %esi
  802803:	53                   	push   %ebx
  802804:	83 ec 1c             	sub    $0x1c,%esp
  802807:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80280b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80280f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802813:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802817:	85 d2                	test   %edx,%edx
  802819:	75 4d                	jne    802868 <__udivdi3+0x68>
  80281b:	39 f3                	cmp    %esi,%ebx
  80281d:	76 19                	jbe    802838 <__udivdi3+0x38>
  80281f:	31 ff                	xor    %edi,%edi
  802821:	89 e8                	mov    %ebp,%eax
  802823:	89 f2                	mov    %esi,%edx
  802825:	f7 f3                	div    %ebx
  802827:	89 fa                	mov    %edi,%edx
  802829:	83 c4 1c             	add    $0x1c,%esp
  80282c:	5b                   	pop    %ebx
  80282d:	5e                   	pop    %esi
  80282e:	5f                   	pop    %edi
  80282f:	5d                   	pop    %ebp
  802830:	c3                   	ret    
  802831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802838:	89 d9                	mov    %ebx,%ecx
  80283a:	85 db                	test   %ebx,%ebx
  80283c:	75 0b                	jne    802849 <__udivdi3+0x49>
  80283e:	b8 01 00 00 00       	mov    $0x1,%eax
  802843:	31 d2                	xor    %edx,%edx
  802845:	f7 f3                	div    %ebx
  802847:	89 c1                	mov    %eax,%ecx
  802849:	31 d2                	xor    %edx,%edx
  80284b:	89 f0                	mov    %esi,%eax
  80284d:	f7 f1                	div    %ecx
  80284f:	89 c6                	mov    %eax,%esi
  802851:	89 e8                	mov    %ebp,%eax
  802853:	89 f7                	mov    %esi,%edi
  802855:	f7 f1                	div    %ecx
  802857:	89 fa                	mov    %edi,%edx
  802859:	83 c4 1c             	add    $0x1c,%esp
  80285c:	5b                   	pop    %ebx
  80285d:	5e                   	pop    %esi
  80285e:	5f                   	pop    %edi
  80285f:	5d                   	pop    %ebp
  802860:	c3                   	ret    
  802861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802868:	39 f2                	cmp    %esi,%edx
  80286a:	77 1c                	ja     802888 <__udivdi3+0x88>
  80286c:	0f bd fa             	bsr    %edx,%edi
  80286f:	83 f7 1f             	xor    $0x1f,%edi
  802872:	75 2c                	jne    8028a0 <__udivdi3+0xa0>
  802874:	39 f2                	cmp    %esi,%edx
  802876:	72 06                	jb     80287e <__udivdi3+0x7e>
  802878:	31 c0                	xor    %eax,%eax
  80287a:	39 eb                	cmp    %ebp,%ebx
  80287c:	77 a9                	ja     802827 <__udivdi3+0x27>
  80287e:	b8 01 00 00 00       	mov    $0x1,%eax
  802883:	eb a2                	jmp    802827 <__udivdi3+0x27>
  802885:	8d 76 00             	lea    0x0(%esi),%esi
  802888:	31 ff                	xor    %edi,%edi
  80288a:	31 c0                	xor    %eax,%eax
  80288c:	89 fa                	mov    %edi,%edx
  80288e:	83 c4 1c             	add    $0x1c,%esp
  802891:	5b                   	pop    %ebx
  802892:	5e                   	pop    %esi
  802893:	5f                   	pop    %edi
  802894:	5d                   	pop    %ebp
  802895:	c3                   	ret    
  802896:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80289d:	8d 76 00             	lea    0x0(%esi),%esi
  8028a0:	89 f9                	mov    %edi,%ecx
  8028a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8028a7:	29 f8                	sub    %edi,%eax
  8028a9:	d3 e2                	shl    %cl,%edx
  8028ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8028af:	89 c1                	mov    %eax,%ecx
  8028b1:	89 da                	mov    %ebx,%edx
  8028b3:	d3 ea                	shr    %cl,%edx
  8028b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8028b9:	09 d1                	or     %edx,%ecx
  8028bb:	89 f2                	mov    %esi,%edx
  8028bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8028c1:	89 f9                	mov    %edi,%ecx
  8028c3:	d3 e3                	shl    %cl,%ebx
  8028c5:	89 c1                	mov    %eax,%ecx
  8028c7:	d3 ea                	shr    %cl,%edx
  8028c9:	89 f9                	mov    %edi,%ecx
  8028cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8028cf:	89 eb                	mov    %ebp,%ebx
  8028d1:	d3 e6                	shl    %cl,%esi
  8028d3:	89 c1                	mov    %eax,%ecx
  8028d5:	d3 eb                	shr    %cl,%ebx
  8028d7:	09 de                	or     %ebx,%esi
  8028d9:	89 f0                	mov    %esi,%eax
  8028db:	f7 74 24 08          	divl   0x8(%esp)
  8028df:	89 d6                	mov    %edx,%esi
  8028e1:	89 c3                	mov    %eax,%ebx
  8028e3:	f7 64 24 0c          	mull   0xc(%esp)
  8028e7:	39 d6                	cmp    %edx,%esi
  8028e9:	72 15                	jb     802900 <__udivdi3+0x100>
  8028eb:	89 f9                	mov    %edi,%ecx
  8028ed:	d3 e5                	shl    %cl,%ebp
  8028ef:	39 c5                	cmp    %eax,%ebp
  8028f1:	73 04                	jae    8028f7 <__udivdi3+0xf7>
  8028f3:	39 d6                	cmp    %edx,%esi
  8028f5:	74 09                	je     802900 <__udivdi3+0x100>
  8028f7:	89 d8                	mov    %ebx,%eax
  8028f9:	31 ff                	xor    %edi,%edi
  8028fb:	e9 27 ff ff ff       	jmp    802827 <__udivdi3+0x27>
  802900:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802903:	31 ff                	xor    %edi,%edi
  802905:	e9 1d ff ff ff       	jmp    802827 <__udivdi3+0x27>
  80290a:	66 90                	xchg   %ax,%ax
  80290c:	66 90                	xchg   %ax,%ax
  80290e:	66 90                	xchg   %ax,%ax

00802910 <__umoddi3>:
  802910:	55                   	push   %ebp
  802911:	57                   	push   %edi
  802912:	56                   	push   %esi
  802913:	53                   	push   %ebx
  802914:	83 ec 1c             	sub    $0x1c,%esp
  802917:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80291b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80291f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802923:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802927:	89 da                	mov    %ebx,%edx
  802929:	85 c0                	test   %eax,%eax
  80292b:	75 43                	jne    802970 <__umoddi3+0x60>
  80292d:	39 df                	cmp    %ebx,%edi
  80292f:	76 17                	jbe    802948 <__umoddi3+0x38>
  802931:	89 f0                	mov    %esi,%eax
  802933:	f7 f7                	div    %edi
  802935:	89 d0                	mov    %edx,%eax
  802937:	31 d2                	xor    %edx,%edx
  802939:	83 c4 1c             	add    $0x1c,%esp
  80293c:	5b                   	pop    %ebx
  80293d:	5e                   	pop    %esi
  80293e:	5f                   	pop    %edi
  80293f:	5d                   	pop    %ebp
  802940:	c3                   	ret    
  802941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802948:	89 fd                	mov    %edi,%ebp
  80294a:	85 ff                	test   %edi,%edi
  80294c:	75 0b                	jne    802959 <__umoddi3+0x49>
  80294e:	b8 01 00 00 00       	mov    $0x1,%eax
  802953:	31 d2                	xor    %edx,%edx
  802955:	f7 f7                	div    %edi
  802957:	89 c5                	mov    %eax,%ebp
  802959:	89 d8                	mov    %ebx,%eax
  80295b:	31 d2                	xor    %edx,%edx
  80295d:	f7 f5                	div    %ebp
  80295f:	89 f0                	mov    %esi,%eax
  802961:	f7 f5                	div    %ebp
  802963:	89 d0                	mov    %edx,%eax
  802965:	eb d0                	jmp    802937 <__umoddi3+0x27>
  802967:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80296e:	66 90                	xchg   %ax,%ax
  802970:	89 f1                	mov    %esi,%ecx
  802972:	39 d8                	cmp    %ebx,%eax
  802974:	76 0a                	jbe    802980 <__umoddi3+0x70>
  802976:	89 f0                	mov    %esi,%eax
  802978:	83 c4 1c             	add    $0x1c,%esp
  80297b:	5b                   	pop    %ebx
  80297c:	5e                   	pop    %esi
  80297d:	5f                   	pop    %edi
  80297e:	5d                   	pop    %ebp
  80297f:	c3                   	ret    
  802980:	0f bd e8             	bsr    %eax,%ebp
  802983:	83 f5 1f             	xor    $0x1f,%ebp
  802986:	75 20                	jne    8029a8 <__umoddi3+0x98>
  802988:	39 d8                	cmp    %ebx,%eax
  80298a:	0f 82 b0 00 00 00    	jb     802a40 <__umoddi3+0x130>
  802990:	39 f7                	cmp    %esi,%edi
  802992:	0f 86 a8 00 00 00    	jbe    802a40 <__umoddi3+0x130>
  802998:	89 c8                	mov    %ecx,%eax
  80299a:	83 c4 1c             	add    $0x1c,%esp
  80299d:	5b                   	pop    %ebx
  80299e:	5e                   	pop    %esi
  80299f:	5f                   	pop    %edi
  8029a0:	5d                   	pop    %ebp
  8029a1:	c3                   	ret    
  8029a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8029a8:	89 e9                	mov    %ebp,%ecx
  8029aa:	ba 20 00 00 00       	mov    $0x20,%edx
  8029af:	29 ea                	sub    %ebp,%edx
  8029b1:	d3 e0                	shl    %cl,%eax
  8029b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8029b7:	89 d1                	mov    %edx,%ecx
  8029b9:	89 f8                	mov    %edi,%eax
  8029bb:	d3 e8                	shr    %cl,%eax
  8029bd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8029c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8029c5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8029c9:	09 c1                	or     %eax,%ecx
  8029cb:	89 d8                	mov    %ebx,%eax
  8029cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8029d1:	89 e9                	mov    %ebp,%ecx
  8029d3:	d3 e7                	shl    %cl,%edi
  8029d5:	89 d1                	mov    %edx,%ecx
  8029d7:	d3 e8                	shr    %cl,%eax
  8029d9:	89 e9                	mov    %ebp,%ecx
  8029db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8029df:	d3 e3                	shl    %cl,%ebx
  8029e1:	89 c7                	mov    %eax,%edi
  8029e3:	89 d1                	mov    %edx,%ecx
  8029e5:	89 f0                	mov    %esi,%eax
  8029e7:	d3 e8                	shr    %cl,%eax
  8029e9:	89 e9                	mov    %ebp,%ecx
  8029eb:	89 fa                	mov    %edi,%edx
  8029ed:	d3 e6                	shl    %cl,%esi
  8029ef:	09 d8                	or     %ebx,%eax
  8029f1:	f7 74 24 08          	divl   0x8(%esp)
  8029f5:	89 d1                	mov    %edx,%ecx
  8029f7:	89 f3                	mov    %esi,%ebx
  8029f9:	f7 64 24 0c          	mull   0xc(%esp)
  8029fd:	89 c6                	mov    %eax,%esi
  8029ff:	89 d7                	mov    %edx,%edi
  802a01:	39 d1                	cmp    %edx,%ecx
  802a03:	72 06                	jb     802a0b <__umoddi3+0xfb>
  802a05:	75 10                	jne    802a17 <__umoddi3+0x107>
  802a07:	39 c3                	cmp    %eax,%ebx
  802a09:	73 0c                	jae    802a17 <__umoddi3+0x107>
  802a0b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802a0f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802a13:	89 d7                	mov    %edx,%edi
  802a15:	89 c6                	mov    %eax,%esi
  802a17:	89 ca                	mov    %ecx,%edx
  802a19:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802a1e:	29 f3                	sub    %esi,%ebx
  802a20:	19 fa                	sbb    %edi,%edx
  802a22:	89 d0                	mov    %edx,%eax
  802a24:	d3 e0                	shl    %cl,%eax
  802a26:	89 e9                	mov    %ebp,%ecx
  802a28:	d3 eb                	shr    %cl,%ebx
  802a2a:	d3 ea                	shr    %cl,%edx
  802a2c:	09 d8                	or     %ebx,%eax
  802a2e:	83 c4 1c             	add    $0x1c,%esp
  802a31:	5b                   	pop    %ebx
  802a32:	5e                   	pop    %esi
  802a33:	5f                   	pop    %edi
  802a34:	5d                   	pop    %ebp
  802a35:	c3                   	ret    
  802a36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a3d:	8d 76 00             	lea    0x0(%esi),%esi
  802a40:	89 da                	mov    %ebx,%edx
  802a42:	29 fe                	sub    %edi,%esi
  802a44:	19 c2                	sbb    %eax,%edx
  802a46:	89 f1                	mov    %esi,%ecx
  802a48:	89 c8                	mov    %ecx,%eax
  802a4a:	e9 4b ff ff ff       	jmp    80299a <__umoddi3+0x8a>
