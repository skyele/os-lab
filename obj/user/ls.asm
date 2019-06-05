
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
  80005a:	68 42 2a 80 00       	push   $0x802a42
  80005f:	e8 02 1d 00 00       	call   801d66 <printf>
  800064:	83 c4 10             	add    $0x10,%esp
	if(prefix) {
  800067:	85 db                	test   %ebx,%ebx
  800069:	74 1c                	je     800087 <ls1+0x54>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
			sep = "/";
		else
			sep = "";
  80006b:	b8 e8 2a 80 00       	mov    $0x802ae8,%eax
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  800070:	80 3b 00             	cmpb   $0x0,(%ebx)
  800073:	75 4b                	jne    8000c0 <ls1+0x8d>
		printf("%s%s", prefix, sep);
  800075:	83 ec 04             	sub    $0x4,%esp
  800078:	50                   	push   %eax
  800079:	53                   	push   %ebx
  80007a:	68 4b 2a 80 00       	push   $0x802a4b
  80007f:	e8 e2 1c 00 00       	call   801d66 <printf>
  800084:	83 c4 10             	add    $0x10,%esp
	}
	printf("%s", name);
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	ff 75 14             	pushl  0x14(%ebp)
  80008d:	68 c1 2f 80 00       	push   $0x802fc1
  800092:	e8 cf 1c 00 00       	call   801d66 <printf>
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
  8000ac:	68 e7 2a 80 00       	push   $0x802ae7
  8000b1:	e8 b0 1c 00 00       	call   801d66 <printf>
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
  8000d1:	b8 40 2a 80 00       	mov    $0x802a40,%eax
  8000d6:	ba e8 2a 80 00       	mov    $0x802ae8,%edx
  8000db:	0f 44 c2             	cmove  %edx,%eax
  8000de:	eb 95                	jmp    800075 <ls1+0x42>
		printf("/");
  8000e0:	83 ec 0c             	sub    $0xc,%esp
  8000e3:	68 40 2a 80 00       	push   $0x802a40
  8000e8:	e8 79 1c 00 00       	call   801d66 <printf>
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
  800104:	e8 ba 1a 00 00       	call   801bc3 <open>
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
  800122:	e8 85 16 00 00       	call   8017ac <readn>
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
  800161:	68 50 2a 80 00       	push   $0x802a50
  800166:	6a 1d                	push   $0x1d
  800168:	68 5c 2a 80 00       	push   $0x802a5c
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
  800181:	68 66 2a 80 00       	push   $0x802a66
  800186:	6a 22                	push   $0x22
  800188:	68 5c 2a 80 00       	push   $0x802a5c
  80018d:	e8 41 02 00 00       	call   8003d3 <_panic>
		panic("error reading directory %s: %e", path, n);
  800192:	83 ec 0c             	sub    $0xc,%esp
  800195:	50                   	push   %eax
  800196:	57                   	push   %edi
  800197:	68 ac 2a 80 00       	push   $0x802aac
  80019c:	6a 24                	push   $0x24
  80019e:	68 5c 2a 80 00       	push   $0x802a5c
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
  8001bd:	e8 cd 17 00 00       	call   80198f <stat>
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
  8001fa:	68 81 2a 80 00       	push   $0x802a81
  8001ff:	6a 0f                	push   $0xf
  800201:	68 5c 2a 80 00       	push   $0x802a5c
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
  800222:	68 8d 2a 80 00       	push   $0x802a8d
  800227:	e8 3a 1b 00 00       	call   801d66 <printf>
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
  80024a:	e8 a0 10 00 00       	call   8012ef <argstart>
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
  800263:	e8 b7 10 00 00       	call   80131f <argnext>
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
  800293:	68 e8 2a 80 00       	push   $0x802ae8
  800298:	68 40 2a 80 00       	push   $0x802a40
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
  800349:	68 cb 2a 80 00       	push   $0x802acb
  80034e:	e8 76 01 00 00       	call   8004c9 <cprintf>
	cprintf("before umain\n");
  800353:	c7 04 24 e9 2a 80 00 	movl   $0x802ae9,(%esp)
  80035a:	e8 6a 01 00 00       	call   8004c9 <cprintf>
	// call user main routine
	umain(argc, argv);
  80035f:	83 c4 08             	add    $0x8,%esp
  800362:	ff 75 0c             	pushl  0xc(%ebp)
  800365:	ff 75 08             	pushl  0x8(%ebp)
  800368:	e8 c9 fe ff ff       	call   800236 <umain>
	cprintf("after umain\n");
  80036d:	c7 04 24 f7 2a 80 00 	movl   $0x802af7,(%esp)
  800374:	e8 50 01 00 00       	call   8004c9 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800379:	a1 20 54 80 00       	mov    0x805420,%eax
  80037e:	8b 40 48             	mov    0x48(%eax),%eax
  800381:	83 c4 08             	add    $0x8,%esp
  800384:	50                   	push   %eax
  800385:	68 04 2b 80 00       	push   $0x802b04
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
  8003ad:	68 30 2b 80 00       	push   $0x802b30
  8003b2:	50                   	push   %eax
  8003b3:	68 23 2b 80 00       	push   $0x802b23
  8003b8:	e8 0c 01 00 00       	call   8004c9 <cprintf>
	close_all();
  8003bd:	e8 52 12 00 00       	call   801614 <close_all>
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
  8003e3:	68 5c 2b 80 00       	push   $0x802b5c
  8003e8:	50                   	push   %eax
  8003e9:	68 23 2b 80 00       	push   $0x802b23
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
  80040c:	68 38 2b 80 00       	push   $0x802b38
  800411:	e8 b3 00 00 00       	call   8004c9 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800416:	83 c4 18             	add    $0x18,%esp
  800419:	53                   	push   %ebx
  80041a:	ff 75 10             	pushl  0x10(%ebp)
  80041d:	e8 56 00 00 00       	call   800478 <vcprintf>
	cprintf("\n");
  800422:	c7 04 24 e7 2a 80 00 	movl   $0x802ae7,(%esp)
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
  800576:	e8 65 22 00 00       	call   8027e0 <__udivdi3>
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
  80059f:	e8 4c 23 00 00       	call   8028f0 <__umoddi3>
  8005a4:	83 c4 14             	add    $0x14,%esp
  8005a7:	0f be 80 63 2b 80 00 	movsbl 0x802b63(%eax),%eax
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
  800650:	ff 24 85 40 2d 80 00 	jmp    *0x802d40(,%eax,4)
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
  80071b:	8b 14 85 a0 2e 80 00 	mov    0x802ea0(,%eax,4),%edx
  800722:	85 d2                	test   %edx,%edx
  800724:	74 18                	je     80073e <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800726:	52                   	push   %edx
  800727:	68 c1 2f 80 00       	push   $0x802fc1
  80072c:	53                   	push   %ebx
  80072d:	56                   	push   %esi
  80072e:	e8 a6 fe ff ff       	call   8005d9 <printfmt>
  800733:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800736:	89 7d 14             	mov    %edi,0x14(%ebp)
  800739:	e9 fe 02 00 00       	jmp    800a3c <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80073e:	50                   	push   %eax
  80073f:	68 7b 2b 80 00       	push   $0x802b7b
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
  800766:	b8 74 2b 80 00       	mov    $0x802b74,%eax
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
  800afe:	bf 99 2c 80 00       	mov    $0x802c99,%edi
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
  800b2a:	bf d1 2c 80 00       	mov    $0x802cd1,%edi
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
  800fcb:	68 e8 2e 80 00       	push   $0x802ee8
  800fd0:	6a 43                	push   $0x43
  800fd2:	68 05 2f 80 00       	push   $0x802f05
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
  80104c:	68 e8 2e 80 00       	push   $0x802ee8
  801051:	6a 43                	push   $0x43
  801053:	68 05 2f 80 00       	push   $0x802f05
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
  80108e:	68 e8 2e 80 00       	push   $0x802ee8
  801093:	6a 43                	push   $0x43
  801095:	68 05 2f 80 00       	push   $0x802f05
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
  8010d0:	68 e8 2e 80 00       	push   $0x802ee8
  8010d5:	6a 43                	push   $0x43
  8010d7:	68 05 2f 80 00       	push   $0x802f05
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
  801112:	68 e8 2e 80 00       	push   $0x802ee8
  801117:	6a 43                	push   $0x43
  801119:	68 05 2f 80 00       	push   $0x802f05
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
  801154:	68 e8 2e 80 00       	push   $0x802ee8
  801159:	6a 43                	push   $0x43
  80115b:	68 05 2f 80 00       	push   $0x802f05
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
  801196:	68 e8 2e 80 00       	push   $0x802ee8
  80119b:	6a 43                	push   $0x43
  80119d:	68 05 2f 80 00       	push   $0x802f05
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
  8011fa:	68 e8 2e 80 00       	push   $0x802ee8
  8011ff:	6a 43                	push   $0x43
  801201:	68 05 2f 80 00       	push   $0x802f05
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
  8012de:	68 e8 2e 80 00       	push   $0x802ee8
  8012e3:	6a 43                	push   $0x43
  8012e5:	68 05 2f 80 00       	push   $0x802f05
  8012ea:	e8 e4 f0 ff ff       	call   8003d3 <_panic>

008012ef <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  8012ef:	55                   	push   %ebp
  8012f0:	89 e5                	mov    %esp,%ebp
  8012f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012f8:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  8012fb:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  8012fd:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801300:	83 3a 01             	cmpl   $0x1,(%edx)
  801303:	7e 09                	jle    80130e <argstart+0x1f>
  801305:	ba e8 2a 80 00       	mov    $0x802ae8,%edx
  80130a:	85 c9                	test   %ecx,%ecx
  80130c:	75 05                	jne    801313 <argstart+0x24>
  80130e:	ba 00 00 00 00       	mov    $0x0,%edx
  801313:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  801316:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  80131d:	5d                   	pop    %ebp
  80131e:	c3                   	ret    

0080131f <argnext>:

int
argnext(struct Argstate *args)
{
  80131f:	55                   	push   %ebp
  801320:	89 e5                	mov    %esp,%ebp
  801322:	53                   	push   %ebx
  801323:	83 ec 04             	sub    $0x4,%esp
  801326:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801329:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801330:	8b 43 08             	mov    0x8(%ebx),%eax
  801333:	85 c0                	test   %eax,%eax
  801335:	74 72                	je     8013a9 <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  801337:	80 38 00             	cmpb   $0x0,(%eax)
  80133a:	75 48                	jne    801384 <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  80133c:	8b 0b                	mov    (%ebx),%ecx
  80133e:	83 39 01             	cmpl   $0x1,(%ecx)
  801341:	74 58                	je     80139b <argnext+0x7c>
		    || args->argv[1][0] != '-'
  801343:	8b 53 04             	mov    0x4(%ebx),%edx
  801346:	8b 42 04             	mov    0x4(%edx),%eax
  801349:	80 38 2d             	cmpb   $0x2d,(%eax)
  80134c:	75 4d                	jne    80139b <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  80134e:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801352:	74 47                	je     80139b <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801354:	83 c0 01             	add    $0x1,%eax
  801357:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  80135a:	83 ec 04             	sub    $0x4,%esp
  80135d:	8b 01                	mov    (%ecx),%eax
  80135f:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801366:	50                   	push   %eax
  801367:	8d 42 08             	lea    0x8(%edx),%eax
  80136a:	50                   	push   %eax
  80136b:	83 c2 04             	add    $0x4,%edx
  80136e:	52                   	push   %edx
  80136f:	e8 42 fa ff ff       	call   800db6 <memmove>
		(*args->argc)--;
  801374:	8b 03                	mov    (%ebx),%eax
  801376:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801379:	8b 43 08             	mov    0x8(%ebx),%eax
  80137c:	83 c4 10             	add    $0x10,%esp
  80137f:	80 38 2d             	cmpb   $0x2d,(%eax)
  801382:	74 11                	je     801395 <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801384:	8b 53 08             	mov    0x8(%ebx),%edx
  801387:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  80138a:	83 c2 01             	add    $0x1,%edx
  80138d:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801390:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801393:	c9                   	leave  
  801394:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801395:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801399:	75 e9                	jne    801384 <argnext+0x65>
	args->curarg = 0;
  80139b:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  8013a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8013a7:	eb e7                	jmp    801390 <argnext+0x71>
		return -1;
  8013a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8013ae:	eb e0                	jmp    801390 <argnext+0x71>

008013b0 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  8013b0:	55                   	push   %ebp
  8013b1:	89 e5                	mov    %esp,%ebp
  8013b3:	53                   	push   %ebx
  8013b4:	83 ec 04             	sub    $0x4,%esp
  8013b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  8013ba:	8b 43 08             	mov    0x8(%ebx),%eax
  8013bd:	85 c0                	test   %eax,%eax
  8013bf:	74 12                	je     8013d3 <argnextvalue+0x23>
		return 0;
	if (*args->curarg) {
  8013c1:	80 38 00             	cmpb   $0x0,(%eax)
  8013c4:	74 12                	je     8013d8 <argnextvalue+0x28>
		args->argvalue = args->curarg;
  8013c6:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  8013c9:	c7 43 08 e8 2a 80 00 	movl   $0x802ae8,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  8013d0:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  8013d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013d6:	c9                   	leave  
  8013d7:	c3                   	ret    
	} else if (*args->argc > 1) {
  8013d8:	8b 13                	mov    (%ebx),%edx
  8013da:	83 3a 01             	cmpl   $0x1,(%edx)
  8013dd:	7f 10                	jg     8013ef <argnextvalue+0x3f>
		args->argvalue = 0;
  8013df:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  8013e6:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  8013ed:	eb e1                	jmp    8013d0 <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  8013ef:	8b 43 04             	mov    0x4(%ebx),%eax
  8013f2:	8b 48 04             	mov    0x4(%eax),%ecx
  8013f5:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8013f8:	83 ec 04             	sub    $0x4,%esp
  8013fb:	8b 12                	mov    (%edx),%edx
  8013fd:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  801404:	52                   	push   %edx
  801405:	8d 50 08             	lea    0x8(%eax),%edx
  801408:	52                   	push   %edx
  801409:	83 c0 04             	add    $0x4,%eax
  80140c:	50                   	push   %eax
  80140d:	e8 a4 f9 ff ff       	call   800db6 <memmove>
		(*args->argc)--;
  801412:	8b 03                	mov    (%ebx),%eax
  801414:	83 28 01             	subl   $0x1,(%eax)
  801417:	83 c4 10             	add    $0x10,%esp
  80141a:	eb b4                	jmp    8013d0 <argnextvalue+0x20>

0080141c <argvalue>:
{
  80141c:	55                   	push   %ebp
  80141d:	89 e5                	mov    %esp,%ebp
  80141f:	83 ec 08             	sub    $0x8,%esp
  801422:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801425:	8b 42 0c             	mov    0xc(%edx),%eax
  801428:	85 c0                	test   %eax,%eax
  80142a:	74 02                	je     80142e <argvalue+0x12>
}
  80142c:	c9                   	leave  
  80142d:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  80142e:	83 ec 0c             	sub    $0xc,%esp
  801431:	52                   	push   %edx
  801432:	e8 79 ff ff ff       	call   8013b0 <argnextvalue>
  801437:	83 c4 10             	add    $0x10,%esp
  80143a:	eb f0                	jmp    80142c <argvalue+0x10>

0080143c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80143c:	55                   	push   %ebp
  80143d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80143f:	8b 45 08             	mov    0x8(%ebp),%eax
  801442:	05 00 00 00 30       	add    $0x30000000,%eax
  801447:	c1 e8 0c             	shr    $0xc,%eax
}
  80144a:	5d                   	pop    %ebp
  80144b:	c3                   	ret    

0080144c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80144c:	55                   	push   %ebp
  80144d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80144f:	8b 45 08             	mov    0x8(%ebp),%eax
  801452:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801457:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80145c:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801461:	5d                   	pop    %ebp
  801462:	c3                   	ret    

00801463 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
  801466:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80146b:	89 c2                	mov    %eax,%edx
  80146d:	c1 ea 16             	shr    $0x16,%edx
  801470:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801477:	f6 c2 01             	test   $0x1,%dl
  80147a:	74 2d                	je     8014a9 <fd_alloc+0x46>
  80147c:	89 c2                	mov    %eax,%edx
  80147e:	c1 ea 0c             	shr    $0xc,%edx
  801481:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801488:	f6 c2 01             	test   $0x1,%dl
  80148b:	74 1c                	je     8014a9 <fd_alloc+0x46>
  80148d:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801492:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801497:	75 d2                	jne    80146b <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8014a2:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8014a7:	eb 0a                	jmp    8014b3 <fd_alloc+0x50>
			*fd_store = fd;
  8014a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014ac:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014b3:	5d                   	pop    %ebp
  8014b4:	c3                   	ret    

008014b5 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8014b5:	55                   	push   %ebp
  8014b6:	89 e5                	mov    %esp,%ebp
  8014b8:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8014bb:	83 f8 1f             	cmp    $0x1f,%eax
  8014be:	77 30                	ja     8014f0 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8014c0:	c1 e0 0c             	shl    $0xc,%eax
  8014c3:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8014c8:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8014ce:	f6 c2 01             	test   $0x1,%dl
  8014d1:	74 24                	je     8014f7 <fd_lookup+0x42>
  8014d3:	89 c2                	mov    %eax,%edx
  8014d5:	c1 ea 0c             	shr    $0xc,%edx
  8014d8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014df:	f6 c2 01             	test   $0x1,%dl
  8014e2:	74 1a                	je     8014fe <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8014e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e7:	89 02                	mov    %eax,(%edx)
	return 0;
  8014e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ee:	5d                   	pop    %ebp
  8014ef:	c3                   	ret    
		return -E_INVAL;
  8014f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014f5:	eb f7                	jmp    8014ee <fd_lookup+0x39>
		return -E_INVAL;
  8014f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014fc:	eb f0                	jmp    8014ee <fd_lookup+0x39>
  8014fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801503:	eb e9                	jmp    8014ee <fd_lookup+0x39>

00801505 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
  801508:	83 ec 08             	sub    $0x8,%esp
  80150b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80150e:	ba 00 00 00 00       	mov    $0x0,%edx
  801513:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801518:	39 08                	cmp    %ecx,(%eax)
  80151a:	74 38                	je     801554 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80151c:	83 c2 01             	add    $0x1,%edx
  80151f:	8b 04 95 94 2f 80 00 	mov    0x802f94(,%edx,4),%eax
  801526:	85 c0                	test   %eax,%eax
  801528:	75 ee                	jne    801518 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80152a:	a1 20 54 80 00       	mov    0x805420,%eax
  80152f:	8b 40 48             	mov    0x48(%eax),%eax
  801532:	83 ec 04             	sub    $0x4,%esp
  801535:	51                   	push   %ecx
  801536:	50                   	push   %eax
  801537:	68 14 2f 80 00       	push   $0x802f14
  80153c:	e8 88 ef ff ff       	call   8004c9 <cprintf>
	*dev = 0;
  801541:	8b 45 0c             	mov    0xc(%ebp),%eax
  801544:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80154a:	83 c4 10             	add    $0x10,%esp
  80154d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801552:	c9                   	leave  
  801553:	c3                   	ret    
			*dev = devtab[i];
  801554:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801557:	89 01                	mov    %eax,(%ecx)
			return 0;
  801559:	b8 00 00 00 00       	mov    $0x0,%eax
  80155e:	eb f2                	jmp    801552 <dev_lookup+0x4d>

00801560 <fd_close>:
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
  801563:	57                   	push   %edi
  801564:	56                   	push   %esi
  801565:	53                   	push   %ebx
  801566:	83 ec 24             	sub    $0x24,%esp
  801569:	8b 75 08             	mov    0x8(%ebp),%esi
  80156c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80156f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801572:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801573:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801579:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80157c:	50                   	push   %eax
  80157d:	e8 33 ff ff ff       	call   8014b5 <fd_lookup>
  801582:	89 c3                	mov    %eax,%ebx
  801584:	83 c4 10             	add    $0x10,%esp
  801587:	85 c0                	test   %eax,%eax
  801589:	78 05                	js     801590 <fd_close+0x30>
	    || fd != fd2)
  80158b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80158e:	74 16                	je     8015a6 <fd_close+0x46>
		return (must_exist ? r : 0);
  801590:	89 f8                	mov    %edi,%eax
  801592:	84 c0                	test   %al,%al
  801594:	b8 00 00 00 00       	mov    $0x0,%eax
  801599:	0f 44 d8             	cmove  %eax,%ebx
}
  80159c:	89 d8                	mov    %ebx,%eax
  80159e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015a1:	5b                   	pop    %ebx
  8015a2:	5e                   	pop    %esi
  8015a3:	5f                   	pop    %edi
  8015a4:	5d                   	pop    %ebp
  8015a5:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8015a6:	83 ec 08             	sub    $0x8,%esp
  8015a9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8015ac:	50                   	push   %eax
  8015ad:	ff 36                	pushl  (%esi)
  8015af:	e8 51 ff ff ff       	call   801505 <dev_lookup>
  8015b4:	89 c3                	mov    %eax,%ebx
  8015b6:	83 c4 10             	add    $0x10,%esp
  8015b9:	85 c0                	test   %eax,%eax
  8015bb:	78 1a                	js     8015d7 <fd_close+0x77>
		if (dev->dev_close)
  8015bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015c0:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8015c3:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8015c8:	85 c0                	test   %eax,%eax
  8015ca:	74 0b                	je     8015d7 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8015cc:	83 ec 0c             	sub    $0xc,%esp
  8015cf:	56                   	push   %esi
  8015d0:	ff d0                	call   *%eax
  8015d2:	89 c3                	mov    %eax,%ebx
  8015d4:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8015d7:	83 ec 08             	sub    $0x8,%esp
  8015da:	56                   	push   %esi
  8015db:	6a 00                	push   $0x0
  8015dd:	e8 bd fa ff ff       	call   80109f <sys_page_unmap>
	return r;
  8015e2:	83 c4 10             	add    $0x10,%esp
  8015e5:	eb b5                	jmp    80159c <fd_close+0x3c>

008015e7 <close>:

int
close(int fdnum)
{
  8015e7:	55                   	push   %ebp
  8015e8:	89 e5                	mov    %esp,%ebp
  8015ea:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015f0:	50                   	push   %eax
  8015f1:	ff 75 08             	pushl  0x8(%ebp)
  8015f4:	e8 bc fe ff ff       	call   8014b5 <fd_lookup>
  8015f9:	83 c4 10             	add    $0x10,%esp
  8015fc:	85 c0                	test   %eax,%eax
  8015fe:	79 02                	jns    801602 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801600:	c9                   	leave  
  801601:	c3                   	ret    
		return fd_close(fd, 1);
  801602:	83 ec 08             	sub    $0x8,%esp
  801605:	6a 01                	push   $0x1
  801607:	ff 75 f4             	pushl  -0xc(%ebp)
  80160a:	e8 51 ff ff ff       	call   801560 <fd_close>
  80160f:	83 c4 10             	add    $0x10,%esp
  801612:	eb ec                	jmp    801600 <close+0x19>

00801614 <close_all>:

void
close_all(void)
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
  801617:	53                   	push   %ebx
  801618:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80161b:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801620:	83 ec 0c             	sub    $0xc,%esp
  801623:	53                   	push   %ebx
  801624:	e8 be ff ff ff       	call   8015e7 <close>
	for (i = 0; i < MAXFD; i++)
  801629:	83 c3 01             	add    $0x1,%ebx
  80162c:	83 c4 10             	add    $0x10,%esp
  80162f:	83 fb 20             	cmp    $0x20,%ebx
  801632:	75 ec                	jne    801620 <close_all+0xc>
}
  801634:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801637:	c9                   	leave  
  801638:	c3                   	ret    

00801639 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
  80163c:	57                   	push   %edi
  80163d:	56                   	push   %esi
  80163e:	53                   	push   %ebx
  80163f:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801642:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801645:	50                   	push   %eax
  801646:	ff 75 08             	pushl  0x8(%ebp)
  801649:	e8 67 fe ff ff       	call   8014b5 <fd_lookup>
  80164e:	89 c3                	mov    %eax,%ebx
  801650:	83 c4 10             	add    $0x10,%esp
  801653:	85 c0                	test   %eax,%eax
  801655:	0f 88 81 00 00 00    	js     8016dc <dup+0xa3>
		return r;
	close(newfdnum);
  80165b:	83 ec 0c             	sub    $0xc,%esp
  80165e:	ff 75 0c             	pushl  0xc(%ebp)
  801661:	e8 81 ff ff ff       	call   8015e7 <close>

	newfd = INDEX2FD(newfdnum);
  801666:	8b 75 0c             	mov    0xc(%ebp),%esi
  801669:	c1 e6 0c             	shl    $0xc,%esi
  80166c:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801672:	83 c4 04             	add    $0x4,%esp
  801675:	ff 75 e4             	pushl  -0x1c(%ebp)
  801678:	e8 cf fd ff ff       	call   80144c <fd2data>
  80167d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80167f:	89 34 24             	mov    %esi,(%esp)
  801682:	e8 c5 fd ff ff       	call   80144c <fd2data>
  801687:	83 c4 10             	add    $0x10,%esp
  80168a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80168c:	89 d8                	mov    %ebx,%eax
  80168e:	c1 e8 16             	shr    $0x16,%eax
  801691:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801698:	a8 01                	test   $0x1,%al
  80169a:	74 11                	je     8016ad <dup+0x74>
  80169c:	89 d8                	mov    %ebx,%eax
  80169e:	c1 e8 0c             	shr    $0xc,%eax
  8016a1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8016a8:	f6 c2 01             	test   $0x1,%dl
  8016ab:	75 39                	jne    8016e6 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016b0:	89 d0                	mov    %edx,%eax
  8016b2:	c1 e8 0c             	shr    $0xc,%eax
  8016b5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016bc:	83 ec 0c             	sub    $0xc,%esp
  8016bf:	25 07 0e 00 00       	and    $0xe07,%eax
  8016c4:	50                   	push   %eax
  8016c5:	56                   	push   %esi
  8016c6:	6a 00                	push   $0x0
  8016c8:	52                   	push   %edx
  8016c9:	6a 00                	push   $0x0
  8016cb:	e8 8d f9 ff ff       	call   80105d <sys_page_map>
  8016d0:	89 c3                	mov    %eax,%ebx
  8016d2:	83 c4 20             	add    $0x20,%esp
  8016d5:	85 c0                	test   %eax,%eax
  8016d7:	78 31                	js     80170a <dup+0xd1>
		goto err;

	return newfdnum;
  8016d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8016dc:	89 d8                	mov    %ebx,%eax
  8016de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016e1:	5b                   	pop    %ebx
  8016e2:	5e                   	pop    %esi
  8016e3:	5f                   	pop    %edi
  8016e4:	5d                   	pop    %ebp
  8016e5:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8016e6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016ed:	83 ec 0c             	sub    $0xc,%esp
  8016f0:	25 07 0e 00 00       	and    $0xe07,%eax
  8016f5:	50                   	push   %eax
  8016f6:	57                   	push   %edi
  8016f7:	6a 00                	push   $0x0
  8016f9:	53                   	push   %ebx
  8016fa:	6a 00                	push   $0x0
  8016fc:	e8 5c f9 ff ff       	call   80105d <sys_page_map>
  801701:	89 c3                	mov    %eax,%ebx
  801703:	83 c4 20             	add    $0x20,%esp
  801706:	85 c0                	test   %eax,%eax
  801708:	79 a3                	jns    8016ad <dup+0x74>
	sys_page_unmap(0, newfd);
  80170a:	83 ec 08             	sub    $0x8,%esp
  80170d:	56                   	push   %esi
  80170e:	6a 00                	push   $0x0
  801710:	e8 8a f9 ff ff       	call   80109f <sys_page_unmap>
	sys_page_unmap(0, nva);
  801715:	83 c4 08             	add    $0x8,%esp
  801718:	57                   	push   %edi
  801719:	6a 00                	push   $0x0
  80171b:	e8 7f f9 ff ff       	call   80109f <sys_page_unmap>
	return r;
  801720:	83 c4 10             	add    $0x10,%esp
  801723:	eb b7                	jmp    8016dc <dup+0xa3>

00801725 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
  801728:	53                   	push   %ebx
  801729:	83 ec 1c             	sub    $0x1c,%esp
  80172c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80172f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801732:	50                   	push   %eax
  801733:	53                   	push   %ebx
  801734:	e8 7c fd ff ff       	call   8014b5 <fd_lookup>
  801739:	83 c4 10             	add    $0x10,%esp
  80173c:	85 c0                	test   %eax,%eax
  80173e:	78 3f                	js     80177f <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801740:	83 ec 08             	sub    $0x8,%esp
  801743:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801746:	50                   	push   %eax
  801747:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80174a:	ff 30                	pushl  (%eax)
  80174c:	e8 b4 fd ff ff       	call   801505 <dev_lookup>
  801751:	83 c4 10             	add    $0x10,%esp
  801754:	85 c0                	test   %eax,%eax
  801756:	78 27                	js     80177f <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801758:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80175b:	8b 42 08             	mov    0x8(%edx),%eax
  80175e:	83 e0 03             	and    $0x3,%eax
  801761:	83 f8 01             	cmp    $0x1,%eax
  801764:	74 1e                	je     801784 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801766:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801769:	8b 40 08             	mov    0x8(%eax),%eax
  80176c:	85 c0                	test   %eax,%eax
  80176e:	74 35                	je     8017a5 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801770:	83 ec 04             	sub    $0x4,%esp
  801773:	ff 75 10             	pushl  0x10(%ebp)
  801776:	ff 75 0c             	pushl  0xc(%ebp)
  801779:	52                   	push   %edx
  80177a:	ff d0                	call   *%eax
  80177c:	83 c4 10             	add    $0x10,%esp
}
  80177f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801782:	c9                   	leave  
  801783:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801784:	a1 20 54 80 00       	mov    0x805420,%eax
  801789:	8b 40 48             	mov    0x48(%eax),%eax
  80178c:	83 ec 04             	sub    $0x4,%esp
  80178f:	53                   	push   %ebx
  801790:	50                   	push   %eax
  801791:	68 58 2f 80 00       	push   $0x802f58
  801796:	e8 2e ed ff ff       	call   8004c9 <cprintf>
		return -E_INVAL;
  80179b:	83 c4 10             	add    $0x10,%esp
  80179e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017a3:	eb da                	jmp    80177f <read+0x5a>
		return -E_NOT_SUPP;
  8017a5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017aa:	eb d3                	jmp    80177f <read+0x5a>

008017ac <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
  8017af:	57                   	push   %edi
  8017b0:	56                   	push   %esi
  8017b1:	53                   	push   %ebx
  8017b2:	83 ec 0c             	sub    $0xc,%esp
  8017b5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017b8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017c0:	39 f3                	cmp    %esi,%ebx
  8017c2:	73 23                	jae    8017e7 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017c4:	83 ec 04             	sub    $0x4,%esp
  8017c7:	89 f0                	mov    %esi,%eax
  8017c9:	29 d8                	sub    %ebx,%eax
  8017cb:	50                   	push   %eax
  8017cc:	89 d8                	mov    %ebx,%eax
  8017ce:	03 45 0c             	add    0xc(%ebp),%eax
  8017d1:	50                   	push   %eax
  8017d2:	57                   	push   %edi
  8017d3:	e8 4d ff ff ff       	call   801725 <read>
		if (m < 0)
  8017d8:	83 c4 10             	add    $0x10,%esp
  8017db:	85 c0                	test   %eax,%eax
  8017dd:	78 06                	js     8017e5 <readn+0x39>
			return m;
		if (m == 0)
  8017df:	74 06                	je     8017e7 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8017e1:	01 c3                	add    %eax,%ebx
  8017e3:	eb db                	jmp    8017c0 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017e5:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8017e7:	89 d8                	mov    %ebx,%eax
  8017e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017ec:	5b                   	pop    %ebx
  8017ed:	5e                   	pop    %esi
  8017ee:	5f                   	pop    %edi
  8017ef:	5d                   	pop    %ebp
  8017f0:	c3                   	ret    

008017f1 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
  8017f4:	53                   	push   %ebx
  8017f5:	83 ec 1c             	sub    $0x1c,%esp
  8017f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017fb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017fe:	50                   	push   %eax
  8017ff:	53                   	push   %ebx
  801800:	e8 b0 fc ff ff       	call   8014b5 <fd_lookup>
  801805:	83 c4 10             	add    $0x10,%esp
  801808:	85 c0                	test   %eax,%eax
  80180a:	78 3a                	js     801846 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80180c:	83 ec 08             	sub    $0x8,%esp
  80180f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801812:	50                   	push   %eax
  801813:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801816:	ff 30                	pushl  (%eax)
  801818:	e8 e8 fc ff ff       	call   801505 <dev_lookup>
  80181d:	83 c4 10             	add    $0x10,%esp
  801820:	85 c0                	test   %eax,%eax
  801822:	78 22                	js     801846 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801824:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801827:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80182b:	74 1e                	je     80184b <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80182d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801830:	8b 52 0c             	mov    0xc(%edx),%edx
  801833:	85 d2                	test   %edx,%edx
  801835:	74 35                	je     80186c <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801837:	83 ec 04             	sub    $0x4,%esp
  80183a:	ff 75 10             	pushl  0x10(%ebp)
  80183d:	ff 75 0c             	pushl  0xc(%ebp)
  801840:	50                   	push   %eax
  801841:	ff d2                	call   *%edx
  801843:	83 c4 10             	add    $0x10,%esp
}
  801846:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801849:	c9                   	leave  
  80184a:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80184b:	a1 20 54 80 00       	mov    0x805420,%eax
  801850:	8b 40 48             	mov    0x48(%eax),%eax
  801853:	83 ec 04             	sub    $0x4,%esp
  801856:	53                   	push   %ebx
  801857:	50                   	push   %eax
  801858:	68 74 2f 80 00       	push   $0x802f74
  80185d:	e8 67 ec ff ff       	call   8004c9 <cprintf>
		return -E_INVAL;
  801862:	83 c4 10             	add    $0x10,%esp
  801865:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80186a:	eb da                	jmp    801846 <write+0x55>
		return -E_NOT_SUPP;
  80186c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801871:	eb d3                	jmp    801846 <write+0x55>

00801873 <seek>:

int
seek(int fdnum, off_t offset)
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
  801876:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801879:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80187c:	50                   	push   %eax
  80187d:	ff 75 08             	pushl  0x8(%ebp)
  801880:	e8 30 fc ff ff       	call   8014b5 <fd_lookup>
  801885:	83 c4 10             	add    $0x10,%esp
  801888:	85 c0                	test   %eax,%eax
  80188a:	78 0e                	js     80189a <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80188c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801892:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801895:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80189a:	c9                   	leave  
  80189b:	c3                   	ret    

0080189c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
  80189f:	53                   	push   %ebx
  8018a0:	83 ec 1c             	sub    $0x1c,%esp
  8018a3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018a9:	50                   	push   %eax
  8018aa:	53                   	push   %ebx
  8018ab:	e8 05 fc ff ff       	call   8014b5 <fd_lookup>
  8018b0:	83 c4 10             	add    $0x10,%esp
  8018b3:	85 c0                	test   %eax,%eax
  8018b5:	78 37                	js     8018ee <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018b7:	83 ec 08             	sub    $0x8,%esp
  8018ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018bd:	50                   	push   %eax
  8018be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c1:	ff 30                	pushl  (%eax)
  8018c3:	e8 3d fc ff ff       	call   801505 <dev_lookup>
  8018c8:	83 c4 10             	add    $0x10,%esp
  8018cb:	85 c0                	test   %eax,%eax
  8018cd:	78 1f                	js     8018ee <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018d2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018d6:	74 1b                	je     8018f3 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8018d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018db:	8b 52 18             	mov    0x18(%edx),%edx
  8018de:	85 d2                	test   %edx,%edx
  8018e0:	74 32                	je     801914 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8018e2:	83 ec 08             	sub    $0x8,%esp
  8018e5:	ff 75 0c             	pushl  0xc(%ebp)
  8018e8:	50                   	push   %eax
  8018e9:	ff d2                	call   *%edx
  8018eb:	83 c4 10             	add    $0x10,%esp
}
  8018ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018f1:	c9                   	leave  
  8018f2:	c3                   	ret    
			thisenv->env_id, fdnum);
  8018f3:	a1 20 54 80 00       	mov    0x805420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8018f8:	8b 40 48             	mov    0x48(%eax),%eax
  8018fb:	83 ec 04             	sub    $0x4,%esp
  8018fe:	53                   	push   %ebx
  8018ff:	50                   	push   %eax
  801900:	68 34 2f 80 00       	push   $0x802f34
  801905:	e8 bf eb ff ff       	call   8004c9 <cprintf>
		return -E_INVAL;
  80190a:	83 c4 10             	add    $0x10,%esp
  80190d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801912:	eb da                	jmp    8018ee <ftruncate+0x52>
		return -E_NOT_SUPP;
  801914:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801919:	eb d3                	jmp    8018ee <ftruncate+0x52>

0080191b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
  80191e:	53                   	push   %ebx
  80191f:	83 ec 1c             	sub    $0x1c,%esp
  801922:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801925:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801928:	50                   	push   %eax
  801929:	ff 75 08             	pushl  0x8(%ebp)
  80192c:	e8 84 fb ff ff       	call   8014b5 <fd_lookup>
  801931:	83 c4 10             	add    $0x10,%esp
  801934:	85 c0                	test   %eax,%eax
  801936:	78 4b                	js     801983 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801938:	83 ec 08             	sub    $0x8,%esp
  80193b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80193e:	50                   	push   %eax
  80193f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801942:	ff 30                	pushl  (%eax)
  801944:	e8 bc fb ff ff       	call   801505 <dev_lookup>
  801949:	83 c4 10             	add    $0x10,%esp
  80194c:	85 c0                	test   %eax,%eax
  80194e:	78 33                	js     801983 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801953:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801957:	74 2f                	je     801988 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801959:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80195c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801963:	00 00 00 
	stat->st_isdir = 0;
  801966:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80196d:	00 00 00 
	stat->st_dev = dev;
  801970:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801976:	83 ec 08             	sub    $0x8,%esp
  801979:	53                   	push   %ebx
  80197a:	ff 75 f0             	pushl  -0x10(%ebp)
  80197d:	ff 50 14             	call   *0x14(%eax)
  801980:	83 c4 10             	add    $0x10,%esp
}
  801983:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801986:	c9                   	leave  
  801987:	c3                   	ret    
		return -E_NOT_SUPP;
  801988:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80198d:	eb f4                	jmp    801983 <fstat+0x68>

0080198f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
  801992:	56                   	push   %esi
  801993:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801994:	83 ec 08             	sub    $0x8,%esp
  801997:	6a 00                	push   $0x0
  801999:	ff 75 08             	pushl  0x8(%ebp)
  80199c:	e8 22 02 00 00       	call   801bc3 <open>
  8019a1:	89 c3                	mov    %eax,%ebx
  8019a3:	83 c4 10             	add    $0x10,%esp
  8019a6:	85 c0                	test   %eax,%eax
  8019a8:	78 1b                	js     8019c5 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8019aa:	83 ec 08             	sub    $0x8,%esp
  8019ad:	ff 75 0c             	pushl  0xc(%ebp)
  8019b0:	50                   	push   %eax
  8019b1:	e8 65 ff ff ff       	call   80191b <fstat>
  8019b6:	89 c6                	mov    %eax,%esi
	close(fd);
  8019b8:	89 1c 24             	mov    %ebx,(%esp)
  8019bb:	e8 27 fc ff ff       	call   8015e7 <close>
	return r;
  8019c0:	83 c4 10             	add    $0x10,%esp
  8019c3:	89 f3                	mov    %esi,%ebx
}
  8019c5:	89 d8                	mov    %ebx,%eax
  8019c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ca:	5b                   	pop    %ebx
  8019cb:	5e                   	pop    %esi
  8019cc:	5d                   	pop    %ebp
  8019cd:	c3                   	ret    

008019ce <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8019ce:	55                   	push   %ebp
  8019cf:	89 e5                	mov    %esp,%ebp
  8019d1:	56                   	push   %esi
  8019d2:	53                   	push   %ebx
  8019d3:	89 c6                	mov    %eax,%esi
  8019d5:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8019d7:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8019de:	74 27                	je     801a07 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8019e0:	6a 07                	push   $0x7
  8019e2:	68 00 60 80 00       	push   $0x806000
  8019e7:	56                   	push   %esi
  8019e8:	ff 35 00 50 80 00    	pushl  0x805000
  8019ee:	e8 1c 0d 00 00       	call   80270f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8019f3:	83 c4 0c             	add    $0xc,%esp
  8019f6:	6a 00                	push   $0x0
  8019f8:	53                   	push   %ebx
  8019f9:	6a 00                	push   $0x0
  8019fb:	e8 a6 0c 00 00       	call   8026a6 <ipc_recv>
}
  801a00:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a03:	5b                   	pop    %ebx
  801a04:	5e                   	pop    %esi
  801a05:	5d                   	pop    %ebp
  801a06:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a07:	83 ec 0c             	sub    $0xc,%esp
  801a0a:	6a 01                	push   $0x1
  801a0c:	e8 56 0d 00 00       	call   802767 <ipc_find_env>
  801a11:	a3 00 50 80 00       	mov    %eax,0x805000
  801a16:	83 c4 10             	add    $0x10,%esp
  801a19:	eb c5                	jmp    8019e0 <fsipc+0x12>

00801a1b <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
  801a1e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a21:	8b 45 08             	mov    0x8(%ebp),%eax
  801a24:	8b 40 0c             	mov    0xc(%eax),%eax
  801a27:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801a2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a2f:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a34:	ba 00 00 00 00       	mov    $0x0,%edx
  801a39:	b8 02 00 00 00       	mov    $0x2,%eax
  801a3e:	e8 8b ff ff ff       	call   8019ce <fsipc>
}
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    

00801a45 <devfile_flush>:
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
  801a48:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4e:	8b 40 0c             	mov    0xc(%eax),%eax
  801a51:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801a56:	ba 00 00 00 00       	mov    $0x0,%edx
  801a5b:	b8 06 00 00 00       	mov    $0x6,%eax
  801a60:	e8 69 ff ff ff       	call   8019ce <fsipc>
}
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    

00801a67 <devfile_stat>:
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
  801a6a:	53                   	push   %ebx
  801a6b:	83 ec 04             	sub    $0x4,%esp
  801a6e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a71:	8b 45 08             	mov    0x8(%ebp),%eax
  801a74:	8b 40 0c             	mov    0xc(%eax),%eax
  801a77:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a7c:	ba 00 00 00 00       	mov    $0x0,%edx
  801a81:	b8 05 00 00 00       	mov    $0x5,%eax
  801a86:	e8 43 ff ff ff       	call   8019ce <fsipc>
  801a8b:	85 c0                	test   %eax,%eax
  801a8d:	78 2c                	js     801abb <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a8f:	83 ec 08             	sub    $0x8,%esp
  801a92:	68 00 60 80 00       	push   $0x806000
  801a97:	53                   	push   %ebx
  801a98:	e8 8b f1 ff ff       	call   800c28 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a9d:	a1 80 60 80 00       	mov    0x806080,%eax
  801aa2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801aa8:	a1 84 60 80 00       	mov    0x806084,%eax
  801aad:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801ab3:	83 c4 10             	add    $0x10,%esp
  801ab6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801abb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <devfile_write>:
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
  801ac3:	53                   	push   %ebx
  801ac4:	83 ec 08             	sub    $0x8,%esp
  801ac7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801aca:	8b 45 08             	mov    0x8(%ebp),%eax
  801acd:	8b 40 0c             	mov    0xc(%eax),%eax
  801ad0:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801ad5:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801adb:	53                   	push   %ebx
  801adc:	ff 75 0c             	pushl  0xc(%ebp)
  801adf:	68 08 60 80 00       	push   $0x806008
  801ae4:	e8 2f f3 ff ff       	call   800e18 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801ae9:	ba 00 00 00 00       	mov    $0x0,%edx
  801aee:	b8 04 00 00 00       	mov    $0x4,%eax
  801af3:	e8 d6 fe ff ff       	call   8019ce <fsipc>
  801af8:	83 c4 10             	add    $0x10,%esp
  801afb:	85 c0                	test   %eax,%eax
  801afd:	78 0b                	js     801b0a <devfile_write+0x4a>
	assert(r <= n);
  801aff:	39 d8                	cmp    %ebx,%eax
  801b01:	77 0c                	ja     801b0f <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801b03:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b08:	7f 1e                	jg     801b28 <devfile_write+0x68>
}
  801b0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b0d:	c9                   	leave  
  801b0e:	c3                   	ret    
	assert(r <= n);
  801b0f:	68 a8 2f 80 00       	push   $0x802fa8
  801b14:	68 af 2f 80 00       	push   $0x802faf
  801b19:	68 98 00 00 00       	push   $0x98
  801b1e:	68 c4 2f 80 00       	push   $0x802fc4
  801b23:	e8 ab e8 ff ff       	call   8003d3 <_panic>
	assert(r <= PGSIZE);
  801b28:	68 cf 2f 80 00       	push   $0x802fcf
  801b2d:	68 af 2f 80 00       	push   $0x802faf
  801b32:	68 99 00 00 00       	push   $0x99
  801b37:	68 c4 2f 80 00       	push   $0x802fc4
  801b3c:	e8 92 e8 ff ff       	call   8003d3 <_panic>

00801b41 <devfile_read>:
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
  801b44:	56                   	push   %esi
  801b45:	53                   	push   %ebx
  801b46:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b49:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4c:	8b 40 0c             	mov    0xc(%eax),%eax
  801b4f:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801b54:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b5a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b5f:	b8 03 00 00 00       	mov    $0x3,%eax
  801b64:	e8 65 fe ff ff       	call   8019ce <fsipc>
  801b69:	89 c3                	mov    %eax,%ebx
  801b6b:	85 c0                	test   %eax,%eax
  801b6d:	78 1f                	js     801b8e <devfile_read+0x4d>
	assert(r <= n);
  801b6f:	39 f0                	cmp    %esi,%eax
  801b71:	77 24                	ja     801b97 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801b73:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b78:	7f 33                	jg     801bad <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b7a:	83 ec 04             	sub    $0x4,%esp
  801b7d:	50                   	push   %eax
  801b7e:	68 00 60 80 00       	push   $0x806000
  801b83:	ff 75 0c             	pushl  0xc(%ebp)
  801b86:	e8 2b f2 ff ff       	call   800db6 <memmove>
	return r;
  801b8b:	83 c4 10             	add    $0x10,%esp
}
  801b8e:	89 d8                	mov    %ebx,%eax
  801b90:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b93:	5b                   	pop    %ebx
  801b94:	5e                   	pop    %esi
  801b95:	5d                   	pop    %ebp
  801b96:	c3                   	ret    
	assert(r <= n);
  801b97:	68 a8 2f 80 00       	push   $0x802fa8
  801b9c:	68 af 2f 80 00       	push   $0x802faf
  801ba1:	6a 7c                	push   $0x7c
  801ba3:	68 c4 2f 80 00       	push   $0x802fc4
  801ba8:	e8 26 e8 ff ff       	call   8003d3 <_panic>
	assert(r <= PGSIZE);
  801bad:	68 cf 2f 80 00       	push   $0x802fcf
  801bb2:	68 af 2f 80 00       	push   $0x802faf
  801bb7:	6a 7d                	push   $0x7d
  801bb9:	68 c4 2f 80 00       	push   $0x802fc4
  801bbe:	e8 10 e8 ff ff       	call   8003d3 <_panic>

00801bc3 <open>:
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
  801bc6:	56                   	push   %esi
  801bc7:	53                   	push   %ebx
  801bc8:	83 ec 1c             	sub    $0x1c,%esp
  801bcb:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801bce:	56                   	push   %esi
  801bcf:	e8 1b f0 ff ff       	call   800bef <strlen>
  801bd4:	83 c4 10             	add    $0x10,%esp
  801bd7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801bdc:	7f 6c                	jg     801c4a <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801bde:	83 ec 0c             	sub    $0xc,%esp
  801be1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801be4:	50                   	push   %eax
  801be5:	e8 79 f8 ff ff       	call   801463 <fd_alloc>
  801bea:	89 c3                	mov    %eax,%ebx
  801bec:	83 c4 10             	add    $0x10,%esp
  801bef:	85 c0                	test   %eax,%eax
  801bf1:	78 3c                	js     801c2f <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801bf3:	83 ec 08             	sub    $0x8,%esp
  801bf6:	56                   	push   %esi
  801bf7:	68 00 60 80 00       	push   $0x806000
  801bfc:	e8 27 f0 ff ff       	call   800c28 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c01:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c04:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c0c:	b8 01 00 00 00       	mov    $0x1,%eax
  801c11:	e8 b8 fd ff ff       	call   8019ce <fsipc>
  801c16:	89 c3                	mov    %eax,%ebx
  801c18:	83 c4 10             	add    $0x10,%esp
  801c1b:	85 c0                	test   %eax,%eax
  801c1d:	78 19                	js     801c38 <open+0x75>
	return fd2num(fd);
  801c1f:	83 ec 0c             	sub    $0xc,%esp
  801c22:	ff 75 f4             	pushl  -0xc(%ebp)
  801c25:	e8 12 f8 ff ff       	call   80143c <fd2num>
  801c2a:	89 c3                	mov    %eax,%ebx
  801c2c:	83 c4 10             	add    $0x10,%esp
}
  801c2f:	89 d8                	mov    %ebx,%eax
  801c31:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c34:	5b                   	pop    %ebx
  801c35:	5e                   	pop    %esi
  801c36:	5d                   	pop    %ebp
  801c37:	c3                   	ret    
		fd_close(fd, 0);
  801c38:	83 ec 08             	sub    $0x8,%esp
  801c3b:	6a 00                	push   $0x0
  801c3d:	ff 75 f4             	pushl  -0xc(%ebp)
  801c40:	e8 1b f9 ff ff       	call   801560 <fd_close>
		return r;
  801c45:	83 c4 10             	add    $0x10,%esp
  801c48:	eb e5                	jmp    801c2f <open+0x6c>
		return -E_BAD_PATH;
  801c4a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801c4f:	eb de                	jmp    801c2f <open+0x6c>

00801c51 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
  801c54:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c57:	ba 00 00 00 00       	mov    $0x0,%edx
  801c5c:	b8 08 00 00 00       	mov    $0x8,%eax
  801c61:	e8 68 fd ff ff       	call   8019ce <fsipc>
}
  801c66:	c9                   	leave  
  801c67:	c3                   	ret    

00801c68 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801c68:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801c6c:	7f 01                	jg     801c6f <writebuf+0x7>
  801c6e:	c3                   	ret    
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
  801c72:	53                   	push   %ebx
  801c73:	83 ec 08             	sub    $0x8,%esp
  801c76:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801c78:	ff 70 04             	pushl  0x4(%eax)
  801c7b:	8d 40 10             	lea    0x10(%eax),%eax
  801c7e:	50                   	push   %eax
  801c7f:	ff 33                	pushl  (%ebx)
  801c81:	e8 6b fb ff ff       	call   8017f1 <write>
		if (result > 0)
  801c86:	83 c4 10             	add    $0x10,%esp
  801c89:	85 c0                	test   %eax,%eax
  801c8b:	7e 03                	jle    801c90 <writebuf+0x28>
			b->result += result;
  801c8d:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801c90:	39 43 04             	cmp    %eax,0x4(%ebx)
  801c93:	74 0d                	je     801ca2 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801c95:	85 c0                	test   %eax,%eax
  801c97:	ba 00 00 00 00       	mov    $0x0,%edx
  801c9c:	0f 4f c2             	cmovg  %edx,%eax
  801c9f:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801ca2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <putch>:

static void
putch(int ch, void *thunk)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
  801caa:	53                   	push   %ebx
  801cab:	83 ec 04             	sub    $0x4,%esp
  801cae:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801cb1:	8b 53 04             	mov    0x4(%ebx),%edx
  801cb4:	8d 42 01             	lea    0x1(%edx),%eax
  801cb7:	89 43 04             	mov    %eax,0x4(%ebx)
  801cba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cbd:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801cc1:	3d 00 01 00 00       	cmp    $0x100,%eax
  801cc6:	74 06                	je     801cce <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801cc8:	83 c4 04             	add    $0x4,%esp
  801ccb:	5b                   	pop    %ebx
  801ccc:	5d                   	pop    %ebp
  801ccd:	c3                   	ret    
		writebuf(b);
  801cce:	89 d8                	mov    %ebx,%eax
  801cd0:	e8 93 ff ff ff       	call   801c68 <writebuf>
		b->idx = 0;
  801cd5:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801cdc:	eb ea                	jmp    801cc8 <putch+0x21>

00801cde <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
  801ce1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cea:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801cf0:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801cf7:	00 00 00 
	b.result = 0;
  801cfa:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801d01:	00 00 00 
	b.error = 1;
  801d04:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801d0b:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801d0e:	ff 75 10             	pushl  0x10(%ebp)
  801d11:	ff 75 0c             	pushl  0xc(%ebp)
  801d14:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801d1a:	50                   	push   %eax
  801d1b:	68 a7 1c 80 00       	push   $0x801ca7
  801d20:	e8 d1 e8 ff ff       	call   8005f6 <vprintfmt>
	if (b.idx > 0)
  801d25:	83 c4 10             	add    $0x10,%esp
  801d28:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801d2f:	7f 11                	jg     801d42 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801d31:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801d37:	85 c0                	test   %eax,%eax
  801d39:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    
		writebuf(&b);
  801d42:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801d48:	e8 1b ff ff ff       	call   801c68 <writebuf>
  801d4d:	eb e2                	jmp    801d31 <vfprintf+0x53>

00801d4f <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801d4f:	55                   	push   %ebp
  801d50:	89 e5                	mov    %esp,%ebp
  801d52:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801d55:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801d58:	50                   	push   %eax
  801d59:	ff 75 0c             	pushl  0xc(%ebp)
  801d5c:	ff 75 08             	pushl  0x8(%ebp)
  801d5f:	e8 7a ff ff ff       	call   801cde <vfprintf>
	va_end(ap);

	return cnt;
}
  801d64:	c9                   	leave  
  801d65:	c3                   	ret    

00801d66 <printf>:

int
printf(const char *fmt, ...)
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
  801d69:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801d6c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801d6f:	50                   	push   %eax
  801d70:	ff 75 08             	pushl  0x8(%ebp)
  801d73:	6a 01                	push   $0x1
  801d75:	e8 64 ff ff ff       	call   801cde <vfprintf>
	va_end(ap);

	return cnt;
}
  801d7a:	c9                   	leave  
  801d7b:	c3                   	ret    

00801d7c <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
  801d7f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801d82:	68 db 2f 80 00       	push   $0x802fdb
  801d87:	ff 75 0c             	pushl  0xc(%ebp)
  801d8a:	e8 99 ee ff ff       	call   800c28 <strcpy>
	return 0;
}
  801d8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <devsock_close>:
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
  801d99:	53                   	push   %ebx
  801d9a:	83 ec 10             	sub    $0x10,%esp
  801d9d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801da0:	53                   	push   %ebx
  801da1:	e8 fc 09 00 00       	call   8027a2 <pageref>
  801da6:	83 c4 10             	add    $0x10,%esp
		return 0;
  801da9:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801dae:	83 f8 01             	cmp    $0x1,%eax
  801db1:	74 07                	je     801dba <devsock_close+0x24>
}
  801db3:	89 d0                	mov    %edx,%eax
  801db5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801db8:	c9                   	leave  
  801db9:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801dba:	83 ec 0c             	sub    $0xc,%esp
  801dbd:	ff 73 0c             	pushl  0xc(%ebx)
  801dc0:	e8 b9 02 00 00       	call   80207e <nsipc_close>
  801dc5:	89 c2                	mov    %eax,%edx
  801dc7:	83 c4 10             	add    $0x10,%esp
  801dca:	eb e7                	jmp    801db3 <devsock_close+0x1d>

00801dcc <devsock_write>:
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
  801dcf:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801dd2:	6a 00                	push   $0x0
  801dd4:	ff 75 10             	pushl  0x10(%ebp)
  801dd7:	ff 75 0c             	pushl  0xc(%ebp)
  801dda:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddd:	ff 70 0c             	pushl  0xc(%eax)
  801de0:	e8 76 03 00 00       	call   80215b <nsipc_send>
}
  801de5:	c9                   	leave  
  801de6:	c3                   	ret    

00801de7 <devsock_read>:
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
  801dea:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ded:	6a 00                	push   $0x0
  801def:	ff 75 10             	pushl  0x10(%ebp)
  801df2:	ff 75 0c             	pushl  0xc(%ebp)
  801df5:	8b 45 08             	mov    0x8(%ebp),%eax
  801df8:	ff 70 0c             	pushl  0xc(%eax)
  801dfb:	e8 ef 02 00 00       	call   8020ef <nsipc_recv>
}
  801e00:	c9                   	leave  
  801e01:	c3                   	ret    

00801e02 <fd2sockid>:
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
  801e05:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801e08:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e0b:	52                   	push   %edx
  801e0c:	50                   	push   %eax
  801e0d:	e8 a3 f6 ff ff       	call   8014b5 <fd_lookup>
  801e12:	83 c4 10             	add    $0x10,%esp
  801e15:	85 c0                	test   %eax,%eax
  801e17:	78 10                	js     801e29 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1c:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801e22:	39 08                	cmp    %ecx,(%eax)
  801e24:	75 05                	jne    801e2b <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801e26:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801e29:	c9                   	leave  
  801e2a:	c3                   	ret    
		return -E_NOT_SUPP;
  801e2b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e30:	eb f7                	jmp    801e29 <fd2sockid+0x27>

00801e32 <alloc_sockfd>:
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
  801e35:	56                   	push   %esi
  801e36:	53                   	push   %ebx
  801e37:	83 ec 1c             	sub    $0x1c,%esp
  801e3a:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801e3c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e3f:	50                   	push   %eax
  801e40:	e8 1e f6 ff ff       	call   801463 <fd_alloc>
  801e45:	89 c3                	mov    %eax,%ebx
  801e47:	83 c4 10             	add    $0x10,%esp
  801e4a:	85 c0                	test   %eax,%eax
  801e4c:	78 43                	js     801e91 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801e4e:	83 ec 04             	sub    $0x4,%esp
  801e51:	68 07 04 00 00       	push   $0x407
  801e56:	ff 75 f4             	pushl  -0xc(%ebp)
  801e59:	6a 00                	push   $0x0
  801e5b:	e8 ba f1 ff ff       	call   80101a <sys_page_alloc>
  801e60:	89 c3                	mov    %eax,%ebx
  801e62:	83 c4 10             	add    $0x10,%esp
  801e65:	85 c0                	test   %eax,%eax
  801e67:	78 28                	js     801e91 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6c:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801e72:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e77:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801e7e:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801e81:	83 ec 0c             	sub    $0xc,%esp
  801e84:	50                   	push   %eax
  801e85:	e8 b2 f5 ff ff       	call   80143c <fd2num>
  801e8a:	89 c3                	mov    %eax,%ebx
  801e8c:	83 c4 10             	add    $0x10,%esp
  801e8f:	eb 0c                	jmp    801e9d <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801e91:	83 ec 0c             	sub    $0xc,%esp
  801e94:	56                   	push   %esi
  801e95:	e8 e4 01 00 00       	call   80207e <nsipc_close>
		return r;
  801e9a:	83 c4 10             	add    $0x10,%esp
}
  801e9d:	89 d8                	mov    %ebx,%eax
  801e9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ea2:	5b                   	pop    %ebx
  801ea3:	5e                   	pop    %esi
  801ea4:	5d                   	pop    %ebp
  801ea5:	c3                   	ret    

00801ea6 <accept>:
{
  801ea6:	55                   	push   %ebp
  801ea7:	89 e5                	mov    %esp,%ebp
  801ea9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801eac:	8b 45 08             	mov    0x8(%ebp),%eax
  801eaf:	e8 4e ff ff ff       	call   801e02 <fd2sockid>
  801eb4:	85 c0                	test   %eax,%eax
  801eb6:	78 1b                	js     801ed3 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801eb8:	83 ec 04             	sub    $0x4,%esp
  801ebb:	ff 75 10             	pushl  0x10(%ebp)
  801ebe:	ff 75 0c             	pushl  0xc(%ebp)
  801ec1:	50                   	push   %eax
  801ec2:	e8 0e 01 00 00       	call   801fd5 <nsipc_accept>
  801ec7:	83 c4 10             	add    $0x10,%esp
  801eca:	85 c0                	test   %eax,%eax
  801ecc:	78 05                	js     801ed3 <accept+0x2d>
	return alloc_sockfd(r);
  801ece:	e8 5f ff ff ff       	call   801e32 <alloc_sockfd>
}
  801ed3:	c9                   	leave  
  801ed4:	c3                   	ret    

00801ed5 <bind>:
{
  801ed5:	55                   	push   %ebp
  801ed6:	89 e5                	mov    %esp,%ebp
  801ed8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801edb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ede:	e8 1f ff ff ff       	call   801e02 <fd2sockid>
  801ee3:	85 c0                	test   %eax,%eax
  801ee5:	78 12                	js     801ef9 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801ee7:	83 ec 04             	sub    $0x4,%esp
  801eea:	ff 75 10             	pushl  0x10(%ebp)
  801eed:	ff 75 0c             	pushl  0xc(%ebp)
  801ef0:	50                   	push   %eax
  801ef1:	e8 31 01 00 00       	call   802027 <nsipc_bind>
  801ef6:	83 c4 10             	add    $0x10,%esp
}
  801ef9:	c9                   	leave  
  801efa:	c3                   	ret    

00801efb <shutdown>:
{
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
  801efe:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f01:	8b 45 08             	mov    0x8(%ebp),%eax
  801f04:	e8 f9 fe ff ff       	call   801e02 <fd2sockid>
  801f09:	85 c0                	test   %eax,%eax
  801f0b:	78 0f                	js     801f1c <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801f0d:	83 ec 08             	sub    $0x8,%esp
  801f10:	ff 75 0c             	pushl  0xc(%ebp)
  801f13:	50                   	push   %eax
  801f14:	e8 43 01 00 00       	call   80205c <nsipc_shutdown>
  801f19:	83 c4 10             	add    $0x10,%esp
}
  801f1c:	c9                   	leave  
  801f1d:	c3                   	ret    

00801f1e <connect>:
{
  801f1e:	55                   	push   %ebp
  801f1f:	89 e5                	mov    %esp,%ebp
  801f21:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f24:	8b 45 08             	mov    0x8(%ebp),%eax
  801f27:	e8 d6 fe ff ff       	call   801e02 <fd2sockid>
  801f2c:	85 c0                	test   %eax,%eax
  801f2e:	78 12                	js     801f42 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801f30:	83 ec 04             	sub    $0x4,%esp
  801f33:	ff 75 10             	pushl  0x10(%ebp)
  801f36:	ff 75 0c             	pushl  0xc(%ebp)
  801f39:	50                   	push   %eax
  801f3a:	e8 59 01 00 00       	call   802098 <nsipc_connect>
  801f3f:	83 c4 10             	add    $0x10,%esp
}
  801f42:	c9                   	leave  
  801f43:	c3                   	ret    

00801f44 <listen>:
{
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
  801f47:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4d:	e8 b0 fe ff ff       	call   801e02 <fd2sockid>
  801f52:	85 c0                	test   %eax,%eax
  801f54:	78 0f                	js     801f65 <listen+0x21>
	return nsipc_listen(r, backlog);
  801f56:	83 ec 08             	sub    $0x8,%esp
  801f59:	ff 75 0c             	pushl  0xc(%ebp)
  801f5c:	50                   	push   %eax
  801f5d:	e8 6b 01 00 00       	call   8020cd <nsipc_listen>
  801f62:	83 c4 10             	add    $0x10,%esp
}
  801f65:	c9                   	leave  
  801f66:	c3                   	ret    

00801f67 <socket>:

int
socket(int domain, int type, int protocol)
{
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
  801f6a:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f6d:	ff 75 10             	pushl  0x10(%ebp)
  801f70:	ff 75 0c             	pushl  0xc(%ebp)
  801f73:	ff 75 08             	pushl  0x8(%ebp)
  801f76:	e8 3e 02 00 00       	call   8021b9 <nsipc_socket>
  801f7b:	83 c4 10             	add    $0x10,%esp
  801f7e:	85 c0                	test   %eax,%eax
  801f80:	78 05                	js     801f87 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801f82:	e8 ab fe ff ff       	call   801e32 <alloc_sockfd>
}
  801f87:	c9                   	leave  
  801f88:	c3                   	ret    

00801f89 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
  801f8c:	53                   	push   %ebx
  801f8d:	83 ec 04             	sub    $0x4,%esp
  801f90:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801f92:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801f99:	74 26                	je     801fc1 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801f9b:	6a 07                	push   $0x7
  801f9d:	68 00 70 80 00       	push   $0x807000
  801fa2:	53                   	push   %ebx
  801fa3:	ff 35 04 50 80 00    	pushl  0x805004
  801fa9:	e8 61 07 00 00       	call   80270f <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801fae:	83 c4 0c             	add    $0xc,%esp
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	e8 ea 06 00 00       	call   8026a6 <ipc_recv>
}
  801fbc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fbf:	c9                   	leave  
  801fc0:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801fc1:	83 ec 0c             	sub    $0xc,%esp
  801fc4:	6a 02                	push   $0x2
  801fc6:	e8 9c 07 00 00       	call   802767 <ipc_find_env>
  801fcb:	a3 04 50 80 00       	mov    %eax,0x805004
  801fd0:	83 c4 10             	add    $0x10,%esp
  801fd3:	eb c6                	jmp    801f9b <nsipc+0x12>

00801fd5 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801fd5:	55                   	push   %ebp
  801fd6:	89 e5                	mov    %esp,%ebp
  801fd8:	56                   	push   %esi
  801fd9:	53                   	push   %ebx
  801fda:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe0:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801fe5:	8b 06                	mov    (%esi),%eax
  801fe7:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801fec:	b8 01 00 00 00       	mov    $0x1,%eax
  801ff1:	e8 93 ff ff ff       	call   801f89 <nsipc>
  801ff6:	89 c3                	mov    %eax,%ebx
  801ff8:	85 c0                	test   %eax,%eax
  801ffa:	79 09                	jns    802005 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801ffc:	89 d8                	mov    %ebx,%eax
  801ffe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802001:	5b                   	pop    %ebx
  802002:	5e                   	pop    %esi
  802003:	5d                   	pop    %ebp
  802004:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802005:	83 ec 04             	sub    $0x4,%esp
  802008:	ff 35 10 70 80 00    	pushl  0x807010
  80200e:	68 00 70 80 00       	push   $0x807000
  802013:	ff 75 0c             	pushl  0xc(%ebp)
  802016:	e8 9b ed ff ff       	call   800db6 <memmove>
		*addrlen = ret->ret_addrlen;
  80201b:	a1 10 70 80 00       	mov    0x807010,%eax
  802020:	89 06                	mov    %eax,(%esi)
  802022:	83 c4 10             	add    $0x10,%esp
	return r;
  802025:	eb d5                	jmp    801ffc <nsipc_accept+0x27>

00802027 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802027:	55                   	push   %ebp
  802028:	89 e5                	mov    %esp,%ebp
  80202a:	53                   	push   %ebx
  80202b:	83 ec 08             	sub    $0x8,%esp
  80202e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802031:	8b 45 08             	mov    0x8(%ebp),%eax
  802034:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802039:	53                   	push   %ebx
  80203a:	ff 75 0c             	pushl  0xc(%ebp)
  80203d:	68 04 70 80 00       	push   $0x807004
  802042:	e8 6f ed ff ff       	call   800db6 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802047:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80204d:	b8 02 00 00 00       	mov    $0x2,%eax
  802052:	e8 32 ff ff ff       	call   801f89 <nsipc>
}
  802057:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80205a:	c9                   	leave  
  80205b:	c3                   	ret    

0080205c <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
  80205f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802062:	8b 45 08             	mov    0x8(%ebp),%eax
  802065:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80206a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80206d:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802072:	b8 03 00 00 00       	mov    $0x3,%eax
  802077:	e8 0d ff ff ff       	call   801f89 <nsipc>
}
  80207c:	c9                   	leave  
  80207d:	c3                   	ret    

0080207e <nsipc_close>:

int
nsipc_close(int s)
{
  80207e:	55                   	push   %ebp
  80207f:	89 e5                	mov    %esp,%ebp
  802081:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802084:	8b 45 08             	mov    0x8(%ebp),%eax
  802087:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80208c:	b8 04 00 00 00       	mov    $0x4,%eax
  802091:	e8 f3 fe ff ff       	call   801f89 <nsipc>
}
  802096:	c9                   	leave  
  802097:	c3                   	ret    

00802098 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802098:	55                   	push   %ebp
  802099:	89 e5                	mov    %esp,%ebp
  80209b:	53                   	push   %ebx
  80209c:	83 ec 08             	sub    $0x8,%esp
  80209f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8020a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a5:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8020aa:	53                   	push   %ebx
  8020ab:	ff 75 0c             	pushl  0xc(%ebp)
  8020ae:	68 04 70 80 00       	push   $0x807004
  8020b3:	e8 fe ec ff ff       	call   800db6 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8020b8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8020be:	b8 05 00 00 00       	mov    $0x5,%eax
  8020c3:	e8 c1 fe ff ff       	call   801f89 <nsipc>
}
  8020c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020cb:	c9                   	leave  
  8020cc:	c3                   	ret    

008020cd <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8020cd:	55                   	push   %ebp
  8020ce:	89 e5                	mov    %esp,%ebp
  8020d0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8020d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d6:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8020db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020de:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8020e3:	b8 06 00 00 00       	mov    $0x6,%eax
  8020e8:	e8 9c fe ff ff       	call   801f89 <nsipc>
}
  8020ed:	c9                   	leave  
  8020ee:	c3                   	ret    

008020ef <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8020ef:	55                   	push   %ebp
  8020f0:	89 e5                	mov    %esp,%ebp
  8020f2:	56                   	push   %esi
  8020f3:	53                   	push   %ebx
  8020f4:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8020f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fa:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8020ff:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802105:	8b 45 14             	mov    0x14(%ebp),%eax
  802108:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80210d:	b8 07 00 00 00       	mov    $0x7,%eax
  802112:	e8 72 fe ff ff       	call   801f89 <nsipc>
  802117:	89 c3                	mov    %eax,%ebx
  802119:	85 c0                	test   %eax,%eax
  80211b:	78 1f                	js     80213c <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80211d:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802122:	7f 21                	jg     802145 <nsipc_recv+0x56>
  802124:	39 c6                	cmp    %eax,%esi
  802126:	7c 1d                	jl     802145 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802128:	83 ec 04             	sub    $0x4,%esp
  80212b:	50                   	push   %eax
  80212c:	68 00 70 80 00       	push   $0x807000
  802131:	ff 75 0c             	pushl  0xc(%ebp)
  802134:	e8 7d ec ff ff       	call   800db6 <memmove>
  802139:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80213c:	89 d8                	mov    %ebx,%eax
  80213e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802141:	5b                   	pop    %ebx
  802142:	5e                   	pop    %esi
  802143:	5d                   	pop    %ebp
  802144:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802145:	68 e7 2f 80 00       	push   $0x802fe7
  80214a:	68 af 2f 80 00       	push   $0x802faf
  80214f:	6a 62                	push   $0x62
  802151:	68 fc 2f 80 00       	push   $0x802ffc
  802156:	e8 78 e2 ff ff       	call   8003d3 <_panic>

0080215b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80215b:	55                   	push   %ebp
  80215c:	89 e5                	mov    %esp,%ebp
  80215e:	53                   	push   %ebx
  80215f:	83 ec 04             	sub    $0x4,%esp
  802162:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802165:	8b 45 08             	mov    0x8(%ebp),%eax
  802168:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80216d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802173:	7f 2e                	jg     8021a3 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802175:	83 ec 04             	sub    $0x4,%esp
  802178:	53                   	push   %ebx
  802179:	ff 75 0c             	pushl  0xc(%ebp)
  80217c:	68 0c 70 80 00       	push   $0x80700c
  802181:	e8 30 ec ff ff       	call   800db6 <memmove>
	nsipcbuf.send.req_size = size;
  802186:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80218c:	8b 45 14             	mov    0x14(%ebp),%eax
  80218f:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802194:	b8 08 00 00 00       	mov    $0x8,%eax
  802199:	e8 eb fd ff ff       	call   801f89 <nsipc>
}
  80219e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021a1:	c9                   	leave  
  8021a2:	c3                   	ret    
	assert(size < 1600);
  8021a3:	68 08 30 80 00       	push   $0x803008
  8021a8:	68 af 2f 80 00       	push   $0x802faf
  8021ad:	6a 6d                	push   $0x6d
  8021af:	68 fc 2f 80 00       	push   $0x802ffc
  8021b4:	e8 1a e2 ff ff       	call   8003d3 <_panic>

008021b9 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8021b9:	55                   	push   %ebp
  8021ba:	89 e5                	mov    %esp,%ebp
  8021bc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8021bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8021c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ca:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8021cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8021d2:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8021d7:	b8 09 00 00 00       	mov    $0x9,%eax
  8021dc:	e8 a8 fd ff ff       	call   801f89 <nsipc>
}
  8021e1:	c9                   	leave  
  8021e2:	c3                   	ret    

008021e3 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8021e3:	55                   	push   %ebp
  8021e4:	89 e5                	mov    %esp,%ebp
  8021e6:	56                   	push   %esi
  8021e7:	53                   	push   %ebx
  8021e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8021eb:	83 ec 0c             	sub    $0xc,%esp
  8021ee:	ff 75 08             	pushl  0x8(%ebp)
  8021f1:	e8 56 f2 ff ff       	call   80144c <fd2data>
  8021f6:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8021f8:	83 c4 08             	add    $0x8,%esp
  8021fb:	68 14 30 80 00       	push   $0x803014
  802200:	53                   	push   %ebx
  802201:	e8 22 ea ff ff       	call   800c28 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802206:	8b 46 04             	mov    0x4(%esi),%eax
  802209:	2b 06                	sub    (%esi),%eax
  80220b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802211:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802218:	00 00 00 
	stat->st_dev = &devpipe;
  80221b:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802222:	40 80 00 
	return 0;
}
  802225:	b8 00 00 00 00       	mov    $0x0,%eax
  80222a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80222d:	5b                   	pop    %ebx
  80222e:	5e                   	pop    %esi
  80222f:	5d                   	pop    %ebp
  802230:	c3                   	ret    

00802231 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802231:	55                   	push   %ebp
  802232:	89 e5                	mov    %esp,%ebp
  802234:	53                   	push   %ebx
  802235:	83 ec 0c             	sub    $0xc,%esp
  802238:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80223b:	53                   	push   %ebx
  80223c:	6a 00                	push   $0x0
  80223e:	e8 5c ee ff ff       	call   80109f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802243:	89 1c 24             	mov    %ebx,(%esp)
  802246:	e8 01 f2 ff ff       	call   80144c <fd2data>
  80224b:	83 c4 08             	add    $0x8,%esp
  80224e:	50                   	push   %eax
  80224f:	6a 00                	push   $0x0
  802251:	e8 49 ee ff ff       	call   80109f <sys_page_unmap>
}
  802256:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802259:	c9                   	leave  
  80225a:	c3                   	ret    

0080225b <_pipeisclosed>:
{
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
  80225e:	57                   	push   %edi
  80225f:	56                   	push   %esi
  802260:	53                   	push   %ebx
  802261:	83 ec 1c             	sub    $0x1c,%esp
  802264:	89 c7                	mov    %eax,%edi
  802266:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802268:	a1 20 54 80 00       	mov    0x805420,%eax
  80226d:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802270:	83 ec 0c             	sub    $0xc,%esp
  802273:	57                   	push   %edi
  802274:	e8 29 05 00 00       	call   8027a2 <pageref>
  802279:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80227c:	89 34 24             	mov    %esi,(%esp)
  80227f:	e8 1e 05 00 00       	call   8027a2 <pageref>
		nn = thisenv->env_runs;
  802284:	8b 15 20 54 80 00    	mov    0x805420,%edx
  80228a:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80228d:	83 c4 10             	add    $0x10,%esp
  802290:	39 cb                	cmp    %ecx,%ebx
  802292:	74 1b                	je     8022af <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802294:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802297:	75 cf                	jne    802268 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802299:	8b 42 58             	mov    0x58(%edx),%eax
  80229c:	6a 01                	push   $0x1
  80229e:	50                   	push   %eax
  80229f:	53                   	push   %ebx
  8022a0:	68 1b 30 80 00       	push   $0x80301b
  8022a5:	e8 1f e2 ff ff       	call   8004c9 <cprintf>
  8022aa:	83 c4 10             	add    $0x10,%esp
  8022ad:	eb b9                	jmp    802268 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8022af:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8022b2:	0f 94 c0             	sete   %al
  8022b5:	0f b6 c0             	movzbl %al,%eax
}
  8022b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022bb:	5b                   	pop    %ebx
  8022bc:	5e                   	pop    %esi
  8022bd:	5f                   	pop    %edi
  8022be:	5d                   	pop    %ebp
  8022bf:	c3                   	ret    

008022c0 <devpipe_write>:
{
  8022c0:	55                   	push   %ebp
  8022c1:	89 e5                	mov    %esp,%ebp
  8022c3:	57                   	push   %edi
  8022c4:	56                   	push   %esi
  8022c5:	53                   	push   %ebx
  8022c6:	83 ec 28             	sub    $0x28,%esp
  8022c9:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8022cc:	56                   	push   %esi
  8022cd:	e8 7a f1 ff ff       	call   80144c <fd2data>
  8022d2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8022d4:	83 c4 10             	add    $0x10,%esp
  8022d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8022dc:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8022df:	74 4f                	je     802330 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8022e1:	8b 43 04             	mov    0x4(%ebx),%eax
  8022e4:	8b 0b                	mov    (%ebx),%ecx
  8022e6:	8d 51 20             	lea    0x20(%ecx),%edx
  8022e9:	39 d0                	cmp    %edx,%eax
  8022eb:	72 14                	jb     802301 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8022ed:	89 da                	mov    %ebx,%edx
  8022ef:	89 f0                	mov    %esi,%eax
  8022f1:	e8 65 ff ff ff       	call   80225b <_pipeisclosed>
  8022f6:	85 c0                	test   %eax,%eax
  8022f8:	75 3b                	jne    802335 <devpipe_write+0x75>
			sys_yield();
  8022fa:	e8 fc ec ff ff       	call   800ffb <sys_yield>
  8022ff:	eb e0                	jmp    8022e1 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802301:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802304:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802308:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80230b:	89 c2                	mov    %eax,%edx
  80230d:	c1 fa 1f             	sar    $0x1f,%edx
  802310:	89 d1                	mov    %edx,%ecx
  802312:	c1 e9 1b             	shr    $0x1b,%ecx
  802315:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802318:	83 e2 1f             	and    $0x1f,%edx
  80231b:	29 ca                	sub    %ecx,%edx
  80231d:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802321:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802325:	83 c0 01             	add    $0x1,%eax
  802328:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80232b:	83 c7 01             	add    $0x1,%edi
  80232e:	eb ac                	jmp    8022dc <devpipe_write+0x1c>
	return i;
  802330:	8b 45 10             	mov    0x10(%ebp),%eax
  802333:	eb 05                	jmp    80233a <devpipe_write+0x7a>
				return 0;
  802335:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80233a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80233d:	5b                   	pop    %ebx
  80233e:	5e                   	pop    %esi
  80233f:	5f                   	pop    %edi
  802340:	5d                   	pop    %ebp
  802341:	c3                   	ret    

00802342 <devpipe_read>:
{
  802342:	55                   	push   %ebp
  802343:	89 e5                	mov    %esp,%ebp
  802345:	57                   	push   %edi
  802346:	56                   	push   %esi
  802347:	53                   	push   %ebx
  802348:	83 ec 18             	sub    $0x18,%esp
  80234b:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80234e:	57                   	push   %edi
  80234f:	e8 f8 f0 ff ff       	call   80144c <fd2data>
  802354:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802356:	83 c4 10             	add    $0x10,%esp
  802359:	be 00 00 00 00       	mov    $0x0,%esi
  80235e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802361:	75 14                	jne    802377 <devpipe_read+0x35>
	return i;
  802363:	8b 45 10             	mov    0x10(%ebp),%eax
  802366:	eb 02                	jmp    80236a <devpipe_read+0x28>
				return i;
  802368:	89 f0                	mov    %esi,%eax
}
  80236a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80236d:	5b                   	pop    %ebx
  80236e:	5e                   	pop    %esi
  80236f:	5f                   	pop    %edi
  802370:	5d                   	pop    %ebp
  802371:	c3                   	ret    
			sys_yield();
  802372:	e8 84 ec ff ff       	call   800ffb <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802377:	8b 03                	mov    (%ebx),%eax
  802379:	3b 43 04             	cmp    0x4(%ebx),%eax
  80237c:	75 18                	jne    802396 <devpipe_read+0x54>
			if (i > 0)
  80237e:	85 f6                	test   %esi,%esi
  802380:	75 e6                	jne    802368 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802382:	89 da                	mov    %ebx,%edx
  802384:	89 f8                	mov    %edi,%eax
  802386:	e8 d0 fe ff ff       	call   80225b <_pipeisclosed>
  80238b:	85 c0                	test   %eax,%eax
  80238d:	74 e3                	je     802372 <devpipe_read+0x30>
				return 0;
  80238f:	b8 00 00 00 00       	mov    $0x0,%eax
  802394:	eb d4                	jmp    80236a <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802396:	99                   	cltd   
  802397:	c1 ea 1b             	shr    $0x1b,%edx
  80239a:	01 d0                	add    %edx,%eax
  80239c:	83 e0 1f             	and    $0x1f,%eax
  80239f:	29 d0                	sub    %edx,%eax
  8023a1:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8023a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023a9:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8023ac:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8023af:	83 c6 01             	add    $0x1,%esi
  8023b2:	eb aa                	jmp    80235e <devpipe_read+0x1c>

008023b4 <pipe>:
{
  8023b4:	55                   	push   %ebp
  8023b5:	89 e5                	mov    %esp,%ebp
  8023b7:	56                   	push   %esi
  8023b8:	53                   	push   %ebx
  8023b9:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8023bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023bf:	50                   	push   %eax
  8023c0:	e8 9e f0 ff ff       	call   801463 <fd_alloc>
  8023c5:	89 c3                	mov    %eax,%ebx
  8023c7:	83 c4 10             	add    $0x10,%esp
  8023ca:	85 c0                	test   %eax,%eax
  8023cc:	0f 88 23 01 00 00    	js     8024f5 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023d2:	83 ec 04             	sub    $0x4,%esp
  8023d5:	68 07 04 00 00       	push   $0x407
  8023da:	ff 75 f4             	pushl  -0xc(%ebp)
  8023dd:	6a 00                	push   $0x0
  8023df:	e8 36 ec ff ff       	call   80101a <sys_page_alloc>
  8023e4:	89 c3                	mov    %eax,%ebx
  8023e6:	83 c4 10             	add    $0x10,%esp
  8023e9:	85 c0                	test   %eax,%eax
  8023eb:	0f 88 04 01 00 00    	js     8024f5 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8023f1:	83 ec 0c             	sub    $0xc,%esp
  8023f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8023f7:	50                   	push   %eax
  8023f8:	e8 66 f0 ff ff       	call   801463 <fd_alloc>
  8023fd:	89 c3                	mov    %eax,%ebx
  8023ff:	83 c4 10             	add    $0x10,%esp
  802402:	85 c0                	test   %eax,%eax
  802404:	0f 88 db 00 00 00    	js     8024e5 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80240a:	83 ec 04             	sub    $0x4,%esp
  80240d:	68 07 04 00 00       	push   $0x407
  802412:	ff 75 f0             	pushl  -0x10(%ebp)
  802415:	6a 00                	push   $0x0
  802417:	e8 fe eb ff ff       	call   80101a <sys_page_alloc>
  80241c:	89 c3                	mov    %eax,%ebx
  80241e:	83 c4 10             	add    $0x10,%esp
  802421:	85 c0                	test   %eax,%eax
  802423:	0f 88 bc 00 00 00    	js     8024e5 <pipe+0x131>
	va = fd2data(fd0);
  802429:	83 ec 0c             	sub    $0xc,%esp
  80242c:	ff 75 f4             	pushl  -0xc(%ebp)
  80242f:	e8 18 f0 ff ff       	call   80144c <fd2data>
  802434:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802436:	83 c4 0c             	add    $0xc,%esp
  802439:	68 07 04 00 00       	push   $0x407
  80243e:	50                   	push   %eax
  80243f:	6a 00                	push   $0x0
  802441:	e8 d4 eb ff ff       	call   80101a <sys_page_alloc>
  802446:	89 c3                	mov    %eax,%ebx
  802448:	83 c4 10             	add    $0x10,%esp
  80244b:	85 c0                	test   %eax,%eax
  80244d:	0f 88 82 00 00 00    	js     8024d5 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802453:	83 ec 0c             	sub    $0xc,%esp
  802456:	ff 75 f0             	pushl  -0x10(%ebp)
  802459:	e8 ee ef ff ff       	call   80144c <fd2data>
  80245e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802465:	50                   	push   %eax
  802466:	6a 00                	push   $0x0
  802468:	56                   	push   %esi
  802469:	6a 00                	push   $0x0
  80246b:	e8 ed eb ff ff       	call   80105d <sys_page_map>
  802470:	89 c3                	mov    %eax,%ebx
  802472:	83 c4 20             	add    $0x20,%esp
  802475:	85 c0                	test   %eax,%eax
  802477:	78 4e                	js     8024c7 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802479:	a1 3c 40 80 00       	mov    0x80403c,%eax
  80247e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802481:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802483:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802486:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80248d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802490:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802492:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802495:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80249c:	83 ec 0c             	sub    $0xc,%esp
  80249f:	ff 75 f4             	pushl  -0xc(%ebp)
  8024a2:	e8 95 ef ff ff       	call   80143c <fd2num>
  8024a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024aa:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8024ac:	83 c4 04             	add    $0x4,%esp
  8024af:	ff 75 f0             	pushl  -0x10(%ebp)
  8024b2:	e8 85 ef ff ff       	call   80143c <fd2num>
  8024b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024ba:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8024bd:	83 c4 10             	add    $0x10,%esp
  8024c0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8024c5:	eb 2e                	jmp    8024f5 <pipe+0x141>
	sys_page_unmap(0, va);
  8024c7:	83 ec 08             	sub    $0x8,%esp
  8024ca:	56                   	push   %esi
  8024cb:	6a 00                	push   $0x0
  8024cd:	e8 cd eb ff ff       	call   80109f <sys_page_unmap>
  8024d2:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8024d5:	83 ec 08             	sub    $0x8,%esp
  8024d8:	ff 75 f0             	pushl  -0x10(%ebp)
  8024db:	6a 00                	push   $0x0
  8024dd:	e8 bd eb ff ff       	call   80109f <sys_page_unmap>
  8024e2:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8024e5:	83 ec 08             	sub    $0x8,%esp
  8024e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8024eb:	6a 00                	push   $0x0
  8024ed:	e8 ad eb ff ff       	call   80109f <sys_page_unmap>
  8024f2:	83 c4 10             	add    $0x10,%esp
}
  8024f5:	89 d8                	mov    %ebx,%eax
  8024f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024fa:	5b                   	pop    %ebx
  8024fb:	5e                   	pop    %esi
  8024fc:	5d                   	pop    %ebp
  8024fd:	c3                   	ret    

008024fe <pipeisclosed>:
{
  8024fe:	55                   	push   %ebp
  8024ff:	89 e5                	mov    %esp,%ebp
  802501:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802504:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802507:	50                   	push   %eax
  802508:	ff 75 08             	pushl  0x8(%ebp)
  80250b:	e8 a5 ef ff ff       	call   8014b5 <fd_lookup>
  802510:	83 c4 10             	add    $0x10,%esp
  802513:	85 c0                	test   %eax,%eax
  802515:	78 18                	js     80252f <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802517:	83 ec 0c             	sub    $0xc,%esp
  80251a:	ff 75 f4             	pushl  -0xc(%ebp)
  80251d:	e8 2a ef ff ff       	call   80144c <fd2data>
	return _pipeisclosed(fd, p);
  802522:	89 c2                	mov    %eax,%edx
  802524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802527:	e8 2f fd ff ff       	call   80225b <_pipeisclosed>
  80252c:	83 c4 10             	add    $0x10,%esp
}
  80252f:	c9                   	leave  
  802530:	c3                   	ret    

00802531 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802531:	b8 00 00 00 00       	mov    $0x0,%eax
  802536:	c3                   	ret    

00802537 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802537:	55                   	push   %ebp
  802538:	89 e5                	mov    %esp,%ebp
  80253a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80253d:	68 33 30 80 00       	push   $0x803033
  802542:	ff 75 0c             	pushl  0xc(%ebp)
  802545:	e8 de e6 ff ff       	call   800c28 <strcpy>
	return 0;
}
  80254a:	b8 00 00 00 00       	mov    $0x0,%eax
  80254f:	c9                   	leave  
  802550:	c3                   	ret    

00802551 <devcons_write>:
{
  802551:	55                   	push   %ebp
  802552:	89 e5                	mov    %esp,%ebp
  802554:	57                   	push   %edi
  802555:	56                   	push   %esi
  802556:	53                   	push   %ebx
  802557:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80255d:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802562:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802568:	3b 75 10             	cmp    0x10(%ebp),%esi
  80256b:	73 31                	jae    80259e <devcons_write+0x4d>
		m = n - tot;
  80256d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802570:	29 f3                	sub    %esi,%ebx
  802572:	83 fb 7f             	cmp    $0x7f,%ebx
  802575:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80257a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80257d:	83 ec 04             	sub    $0x4,%esp
  802580:	53                   	push   %ebx
  802581:	89 f0                	mov    %esi,%eax
  802583:	03 45 0c             	add    0xc(%ebp),%eax
  802586:	50                   	push   %eax
  802587:	57                   	push   %edi
  802588:	e8 29 e8 ff ff       	call   800db6 <memmove>
		sys_cputs(buf, m);
  80258d:	83 c4 08             	add    $0x8,%esp
  802590:	53                   	push   %ebx
  802591:	57                   	push   %edi
  802592:	e8 c7 e9 ff ff       	call   800f5e <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802597:	01 de                	add    %ebx,%esi
  802599:	83 c4 10             	add    $0x10,%esp
  80259c:	eb ca                	jmp    802568 <devcons_write+0x17>
}
  80259e:	89 f0                	mov    %esi,%eax
  8025a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025a3:	5b                   	pop    %ebx
  8025a4:	5e                   	pop    %esi
  8025a5:	5f                   	pop    %edi
  8025a6:	5d                   	pop    %ebp
  8025a7:	c3                   	ret    

008025a8 <devcons_read>:
{
  8025a8:	55                   	push   %ebp
  8025a9:	89 e5                	mov    %esp,%ebp
  8025ab:	83 ec 08             	sub    $0x8,%esp
  8025ae:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8025b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025b7:	74 21                	je     8025da <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8025b9:	e8 be e9 ff ff       	call   800f7c <sys_cgetc>
  8025be:	85 c0                	test   %eax,%eax
  8025c0:	75 07                	jne    8025c9 <devcons_read+0x21>
		sys_yield();
  8025c2:	e8 34 ea ff ff       	call   800ffb <sys_yield>
  8025c7:	eb f0                	jmp    8025b9 <devcons_read+0x11>
	if (c < 0)
  8025c9:	78 0f                	js     8025da <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8025cb:	83 f8 04             	cmp    $0x4,%eax
  8025ce:	74 0c                	je     8025dc <devcons_read+0x34>
	*(char*)vbuf = c;
  8025d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025d3:	88 02                	mov    %al,(%edx)
	return 1;
  8025d5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8025da:	c9                   	leave  
  8025db:	c3                   	ret    
		return 0;
  8025dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e1:	eb f7                	jmp    8025da <devcons_read+0x32>

008025e3 <cputchar>:
{
  8025e3:	55                   	push   %ebp
  8025e4:	89 e5                	mov    %esp,%ebp
  8025e6:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8025e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ec:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8025ef:	6a 01                	push   $0x1
  8025f1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025f4:	50                   	push   %eax
  8025f5:	e8 64 e9 ff ff       	call   800f5e <sys_cputs>
}
  8025fa:	83 c4 10             	add    $0x10,%esp
  8025fd:	c9                   	leave  
  8025fe:	c3                   	ret    

008025ff <getchar>:
{
  8025ff:	55                   	push   %ebp
  802600:	89 e5                	mov    %esp,%ebp
  802602:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802605:	6a 01                	push   $0x1
  802607:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80260a:	50                   	push   %eax
  80260b:	6a 00                	push   $0x0
  80260d:	e8 13 f1 ff ff       	call   801725 <read>
	if (r < 0)
  802612:	83 c4 10             	add    $0x10,%esp
  802615:	85 c0                	test   %eax,%eax
  802617:	78 06                	js     80261f <getchar+0x20>
	if (r < 1)
  802619:	74 06                	je     802621 <getchar+0x22>
	return c;
  80261b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80261f:	c9                   	leave  
  802620:	c3                   	ret    
		return -E_EOF;
  802621:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802626:	eb f7                	jmp    80261f <getchar+0x20>

00802628 <iscons>:
{
  802628:	55                   	push   %ebp
  802629:	89 e5                	mov    %esp,%ebp
  80262b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80262e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802631:	50                   	push   %eax
  802632:	ff 75 08             	pushl  0x8(%ebp)
  802635:	e8 7b ee ff ff       	call   8014b5 <fd_lookup>
  80263a:	83 c4 10             	add    $0x10,%esp
  80263d:	85 c0                	test   %eax,%eax
  80263f:	78 11                	js     802652 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802644:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80264a:	39 10                	cmp    %edx,(%eax)
  80264c:	0f 94 c0             	sete   %al
  80264f:	0f b6 c0             	movzbl %al,%eax
}
  802652:	c9                   	leave  
  802653:	c3                   	ret    

00802654 <opencons>:
{
  802654:	55                   	push   %ebp
  802655:	89 e5                	mov    %esp,%ebp
  802657:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80265a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80265d:	50                   	push   %eax
  80265e:	e8 00 ee ff ff       	call   801463 <fd_alloc>
  802663:	83 c4 10             	add    $0x10,%esp
  802666:	85 c0                	test   %eax,%eax
  802668:	78 3a                	js     8026a4 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80266a:	83 ec 04             	sub    $0x4,%esp
  80266d:	68 07 04 00 00       	push   $0x407
  802672:	ff 75 f4             	pushl  -0xc(%ebp)
  802675:	6a 00                	push   $0x0
  802677:	e8 9e e9 ff ff       	call   80101a <sys_page_alloc>
  80267c:	83 c4 10             	add    $0x10,%esp
  80267f:	85 c0                	test   %eax,%eax
  802681:	78 21                	js     8026a4 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802686:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80268c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80268e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802691:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802698:	83 ec 0c             	sub    $0xc,%esp
  80269b:	50                   	push   %eax
  80269c:	e8 9b ed ff ff       	call   80143c <fd2num>
  8026a1:	83 c4 10             	add    $0x10,%esp
}
  8026a4:	c9                   	leave  
  8026a5:	c3                   	ret    

008026a6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8026a6:	55                   	push   %ebp
  8026a7:	89 e5                	mov    %esp,%ebp
  8026a9:	56                   	push   %esi
  8026aa:	53                   	push   %ebx
  8026ab:	8b 75 08             	mov    0x8(%ebp),%esi
  8026ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  8026b4:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8026b6:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8026bb:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8026be:	83 ec 0c             	sub    $0xc,%esp
  8026c1:	50                   	push   %eax
  8026c2:	e8 03 eb ff ff       	call   8011ca <sys_ipc_recv>
	if(ret < 0){
  8026c7:	83 c4 10             	add    $0x10,%esp
  8026ca:	85 c0                	test   %eax,%eax
  8026cc:	78 2b                	js     8026f9 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8026ce:	85 f6                	test   %esi,%esi
  8026d0:	74 0a                	je     8026dc <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8026d2:	a1 20 54 80 00       	mov    0x805420,%eax
  8026d7:	8b 40 74             	mov    0x74(%eax),%eax
  8026da:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8026dc:	85 db                	test   %ebx,%ebx
  8026de:	74 0a                	je     8026ea <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8026e0:	a1 20 54 80 00       	mov    0x805420,%eax
  8026e5:	8b 40 78             	mov    0x78(%eax),%eax
  8026e8:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8026ea:	a1 20 54 80 00       	mov    0x805420,%eax
  8026ef:	8b 40 70             	mov    0x70(%eax),%eax
}
  8026f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026f5:	5b                   	pop    %ebx
  8026f6:	5e                   	pop    %esi
  8026f7:	5d                   	pop    %ebp
  8026f8:	c3                   	ret    
		if(from_env_store)
  8026f9:	85 f6                	test   %esi,%esi
  8026fb:	74 06                	je     802703 <ipc_recv+0x5d>
			*from_env_store = 0;
  8026fd:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802703:	85 db                	test   %ebx,%ebx
  802705:	74 eb                	je     8026f2 <ipc_recv+0x4c>
			*perm_store = 0;
  802707:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80270d:	eb e3                	jmp    8026f2 <ipc_recv+0x4c>

0080270f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80270f:	55                   	push   %ebp
  802710:	89 e5                	mov    %esp,%ebp
  802712:	57                   	push   %edi
  802713:	56                   	push   %esi
  802714:	53                   	push   %ebx
  802715:	83 ec 0c             	sub    $0xc,%esp
  802718:	8b 7d 08             	mov    0x8(%ebp),%edi
  80271b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80271e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802721:	85 db                	test   %ebx,%ebx
  802723:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802728:	0f 44 d8             	cmove  %eax,%ebx
  80272b:	eb 05                	jmp    802732 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80272d:	e8 c9 e8 ff ff       	call   800ffb <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802732:	ff 75 14             	pushl  0x14(%ebp)
  802735:	53                   	push   %ebx
  802736:	56                   	push   %esi
  802737:	57                   	push   %edi
  802738:	e8 6a ea ff ff       	call   8011a7 <sys_ipc_try_send>
  80273d:	83 c4 10             	add    $0x10,%esp
  802740:	85 c0                	test   %eax,%eax
  802742:	74 1b                	je     80275f <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802744:	79 e7                	jns    80272d <ipc_send+0x1e>
  802746:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802749:	74 e2                	je     80272d <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80274b:	83 ec 04             	sub    $0x4,%esp
  80274e:	68 3f 30 80 00       	push   $0x80303f
  802753:	6a 4a                	push   $0x4a
  802755:	68 54 30 80 00       	push   $0x803054
  80275a:	e8 74 dc ff ff       	call   8003d3 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80275f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802762:	5b                   	pop    %ebx
  802763:	5e                   	pop    %esi
  802764:	5f                   	pop    %edi
  802765:	5d                   	pop    %ebp
  802766:	c3                   	ret    

00802767 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802767:	55                   	push   %ebp
  802768:	89 e5                	mov    %esp,%ebp
  80276a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80276d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802772:	89 c2                	mov    %eax,%edx
  802774:	c1 e2 07             	shl    $0x7,%edx
  802777:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80277d:	8b 52 50             	mov    0x50(%edx),%edx
  802780:	39 ca                	cmp    %ecx,%edx
  802782:	74 11                	je     802795 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802784:	83 c0 01             	add    $0x1,%eax
  802787:	3d 00 04 00 00       	cmp    $0x400,%eax
  80278c:	75 e4                	jne    802772 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80278e:	b8 00 00 00 00       	mov    $0x0,%eax
  802793:	eb 0b                	jmp    8027a0 <ipc_find_env+0x39>
			return envs[i].env_id;
  802795:	c1 e0 07             	shl    $0x7,%eax
  802798:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80279d:	8b 40 48             	mov    0x48(%eax),%eax
}
  8027a0:	5d                   	pop    %ebp
  8027a1:	c3                   	ret    

008027a2 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8027a2:	55                   	push   %ebp
  8027a3:	89 e5                	mov    %esp,%ebp
  8027a5:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8027a8:	89 d0                	mov    %edx,%eax
  8027aa:	c1 e8 16             	shr    $0x16,%eax
  8027ad:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8027b4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8027b9:	f6 c1 01             	test   $0x1,%cl
  8027bc:	74 1d                	je     8027db <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8027be:	c1 ea 0c             	shr    $0xc,%edx
  8027c1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8027c8:	f6 c2 01             	test   $0x1,%dl
  8027cb:	74 0e                	je     8027db <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8027cd:	c1 ea 0c             	shr    $0xc,%edx
  8027d0:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8027d7:	ef 
  8027d8:	0f b7 c0             	movzwl %ax,%eax
}
  8027db:	5d                   	pop    %ebp
  8027dc:	c3                   	ret    
  8027dd:	66 90                	xchg   %ax,%ax
  8027df:	90                   	nop

008027e0 <__udivdi3>:
  8027e0:	55                   	push   %ebp
  8027e1:	57                   	push   %edi
  8027e2:	56                   	push   %esi
  8027e3:	53                   	push   %ebx
  8027e4:	83 ec 1c             	sub    $0x1c,%esp
  8027e7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8027eb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8027ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8027f3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8027f7:	85 d2                	test   %edx,%edx
  8027f9:	75 4d                	jne    802848 <__udivdi3+0x68>
  8027fb:	39 f3                	cmp    %esi,%ebx
  8027fd:	76 19                	jbe    802818 <__udivdi3+0x38>
  8027ff:	31 ff                	xor    %edi,%edi
  802801:	89 e8                	mov    %ebp,%eax
  802803:	89 f2                	mov    %esi,%edx
  802805:	f7 f3                	div    %ebx
  802807:	89 fa                	mov    %edi,%edx
  802809:	83 c4 1c             	add    $0x1c,%esp
  80280c:	5b                   	pop    %ebx
  80280d:	5e                   	pop    %esi
  80280e:	5f                   	pop    %edi
  80280f:	5d                   	pop    %ebp
  802810:	c3                   	ret    
  802811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802818:	89 d9                	mov    %ebx,%ecx
  80281a:	85 db                	test   %ebx,%ebx
  80281c:	75 0b                	jne    802829 <__udivdi3+0x49>
  80281e:	b8 01 00 00 00       	mov    $0x1,%eax
  802823:	31 d2                	xor    %edx,%edx
  802825:	f7 f3                	div    %ebx
  802827:	89 c1                	mov    %eax,%ecx
  802829:	31 d2                	xor    %edx,%edx
  80282b:	89 f0                	mov    %esi,%eax
  80282d:	f7 f1                	div    %ecx
  80282f:	89 c6                	mov    %eax,%esi
  802831:	89 e8                	mov    %ebp,%eax
  802833:	89 f7                	mov    %esi,%edi
  802835:	f7 f1                	div    %ecx
  802837:	89 fa                	mov    %edi,%edx
  802839:	83 c4 1c             	add    $0x1c,%esp
  80283c:	5b                   	pop    %ebx
  80283d:	5e                   	pop    %esi
  80283e:	5f                   	pop    %edi
  80283f:	5d                   	pop    %ebp
  802840:	c3                   	ret    
  802841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802848:	39 f2                	cmp    %esi,%edx
  80284a:	77 1c                	ja     802868 <__udivdi3+0x88>
  80284c:	0f bd fa             	bsr    %edx,%edi
  80284f:	83 f7 1f             	xor    $0x1f,%edi
  802852:	75 2c                	jne    802880 <__udivdi3+0xa0>
  802854:	39 f2                	cmp    %esi,%edx
  802856:	72 06                	jb     80285e <__udivdi3+0x7e>
  802858:	31 c0                	xor    %eax,%eax
  80285a:	39 eb                	cmp    %ebp,%ebx
  80285c:	77 a9                	ja     802807 <__udivdi3+0x27>
  80285e:	b8 01 00 00 00       	mov    $0x1,%eax
  802863:	eb a2                	jmp    802807 <__udivdi3+0x27>
  802865:	8d 76 00             	lea    0x0(%esi),%esi
  802868:	31 ff                	xor    %edi,%edi
  80286a:	31 c0                	xor    %eax,%eax
  80286c:	89 fa                	mov    %edi,%edx
  80286e:	83 c4 1c             	add    $0x1c,%esp
  802871:	5b                   	pop    %ebx
  802872:	5e                   	pop    %esi
  802873:	5f                   	pop    %edi
  802874:	5d                   	pop    %ebp
  802875:	c3                   	ret    
  802876:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80287d:	8d 76 00             	lea    0x0(%esi),%esi
  802880:	89 f9                	mov    %edi,%ecx
  802882:	b8 20 00 00 00       	mov    $0x20,%eax
  802887:	29 f8                	sub    %edi,%eax
  802889:	d3 e2                	shl    %cl,%edx
  80288b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80288f:	89 c1                	mov    %eax,%ecx
  802891:	89 da                	mov    %ebx,%edx
  802893:	d3 ea                	shr    %cl,%edx
  802895:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802899:	09 d1                	or     %edx,%ecx
  80289b:	89 f2                	mov    %esi,%edx
  80289d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8028a1:	89 f9                	mov    %edi,%ecx
  8028a3:	d3 e3                	shl    %cl,%ebx
  8028a5:	89 c1                	mov    %eax,%ecx
  8028a7:	d3 ea                	shr    %cl,%edx
  8028a9:	89 f9                	mov    %edi,%ecx
  8028ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8028af:	89 eb                	mov    %ebp,%ebx
  8028b1:	d3 e6                	shl    %cl,%esi
  8028b3:	89 c1                	mov    %eax,%ecx
  8028b5:	d3 eb                	shr    %cl,%ebx
  8028b7:	09 de                	or     %ebx,%esi
  8028b9:	89 f0                	mov    %esi,%eax
  8028bb:	f7 74 24 08          	divl   0x8(%esp)
  8028bf:	89 d6                	mov    %edx,%esi
  8028c1:	89 c3                	mov    %eax,%ebx
  8028c3:	f7 64 24 0c          	mull   0xc(%esp)
  8028c7:	39 d6                	cmp    %edx,%esi
  8028c9:	72 15                	jb     8028e0 <__udivdi3+0x100>
  8028cb:	89 f9                	mov    %edi,%ecx
  8028cd:	d3 e5                	shl    %cl,%ebp
  8028cf:	39 c5                	cmp    %eax,%ebp
  8028d1:	73 04                	jae    8028d7 <__udivdi3+0xf7>
  8028d3:	39 d6                	cmp    %edx,%esi
  8028d5:	74 09                	je     8028e0 <__udivdi3+0x100>
  8028d7:	89 d8                	mov    %ebx,%eax
  8028d9:	31 ff                	xor    %edi,%edi
  8028db:	e9 27 ff ff ff       	jmp    802807 <__udivdi3+0x27>
  8028e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8028e3:	31 ff                	xor    %edi,%edi
  8028e5:	e9 1d ff ff ff       	jmp    802807 <__udivdi3+0x27>
  8028ea:	66 90                	xchg   %ax,%ax
  8028ec:	66 90                	xchg   %ax,%ax
  8028ee:	66 90                	xchg   %ax,%ax

008028f0 <__umoddi3>:
  8028f0:	55                   	push   %ebp
  8028f1:	57                   	push   %edi
  8028f2:	56                   	push   %esi
  8028f3:	53                   	push   %ebx
  8028f4:	83 ec 1c             	sub    $0x1c,%esp
  8028f7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8028fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8028ff:	8b 74 24 30          	mov    0x30(%esp),%esi
  802903:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802907:	89 da                	mov    %ebx,%edx
  802909:	85 c0                	test   %eax,%eax
  80290b:	75 43                	jne    802950 <__umoddi3+0x60>
  80290d:	39 df                	cmp    %ebx,%edi
  80290f:	76 17                	jbe    802928 <__umoddi3+0x38>
  802911:	89 f0                	mov    %esi,%eax
  802913:	f7 f7                	div    %edi
  802915:	89 d0                	mov    %edx,%eax
  802917:	31 d2                	xor    %edx,%edx
  802919:	83 c4 1c             	add    $0x1c,%esp
  80291c:	5b                   	pop    %ebx
  80291d:	5e                   	pop    %esi
  80291e:	5f                   	pop    %edi
  80291f:	5d                   	pop    %ebp
  802920:	c3                   	ret    
  802921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802928:	89 fd                	mov    %edi,%ebp
  80292a:	85 ff                	test   %edi,%edi
  80292c:	75 0b                	jne    802939 <__umoddi3+0x49>
  80292e:	b8 01 00 00 00       	mov    $0x1,%eax
  802933:	31 d2                	xor    %edx,%edx
  802935:	f7 f7                	div    %edi
  802937:	89 c5                	mov    %eax,%ebp
  802939:	89 d8                	mov    %ebx,%eax
  80293b:	31 d2                	xor    %edx,%edx
  80293d:	f7 f5                	div    %ebp
  80293f:	89 f0                	mov    %esi,%eax
  802941:	f7 f5                	div    %ebp
  802943:	89 d0                	mov    %edx,%eax
  802945:	eb d0                	jmp    802917 <__umoddi3+0x27>
  802947:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80294e:	66 90                	xchg   %ax,%ax
  802950:	89 f1                	mov    %esi,%ecx
  802952:	39 d8                	cmp    %ebx,%eax
  802954:	76 0a                	jbe    802960 <__umoddi3+0x70>
  802956:	89 f0                	mov    %esi,%eax
  802958:	83 c4 1c             	add    $0x1c,%esp
  80295b:	5b                   	pop    %ebx
  80295c:	5e                   	pop    %esi
  80295d:	5f                   	pop    %edi
  80295e:	5d                   	pop    %ebp
  80295f:	c3                   	ret    
  802960:	0f bd e8             	bsr    %eax,%ebp
  802963:	83 f5 1f             	xor    $0x1f,%ebp
  802966:	75 20                	jne    802988 <__umoddi3+0x98>
  802968:	39 d8                	cmp    %ebx,%eax
  80296a:	0f 82 b0 00 00 00    	jb     802a20 <__umoddi3+0x130>
  802970:	39 f7                	cmp    %esi,%edi
  802972:	0f 86 a8 00 00 00    	jbe    802a20 <__umoddi3+0x130>
  802978:	89 c8                	mov    %ecx,%eax
  80297a:	83 c4 1c             	add    $0x1c,%esp
  80297d:	5b                   	pop    %ebx
  80297e:	5e                   	pop    %esi
  80297f:	5f                   	pop    %edi
  802980:	5d                   	pop    %ebp
  802981:	c3                   	ret    
  802982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802988:	89 e9                	mov    %ebp,%ecx
  80298a:	ba 20 00 00 00       	mov    $0x20,%edx
  80298f:	29 ea                	sub    %ebp,%edx
  802991:	d3 e0                	shl    %cl,%eax
  802993:	89 44 24 08          	mov    %eax,0x8(%esp)
  802997:	89 d1                	mov    %edx,%ecx
  802999:	89 f8                	mov    %edi,%eax
  80299b:	d3 e8                	shr    %cl,%eax
  80299d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8029a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8029a5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8029a9:	09 c1                	or     %eax,%ecx
  8029ab:	89 d8                	mov    %ebx,%eax
  8029ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8029b1:	89 e9                	mov    %ebp,%ecx
  8029b3:	d3 e7                	shl    %cl,%edi
  8029b5:	89 d1                	mov    %edx,%ecx
  8029b7:	d3 e8                	shr    %cl,%eax
  8029b9:	89 e9                	mov    %ebp,%ecx
  8029bb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8029bf:	d3 e3                	shl    %cl,%ebx
  8029c1:	89 c7                	mov    %eax,%edi
  8029c3:	89 d1                	mov    %edx,%ecx
  8029c5:	89 f0                	mov    %esi,%eax
  8029c7:	d3 e8                	shr    %cl,%eax
  8029c9:	89 e9                	mov    %ebp,%ecx
  8029cb:	89 fa                	mov    %edi,%edx
  8029cd:	d3 e6                	shl    %cl,%esi
  8029cf:	09 d8                	or     %ebx,%eax
  8029d1:	f7 74 24 08          	divl   0x8(%esp)
  8029d5:	89 d1                	mov    %edx,%ecx
  8029d7:	89 f3                	mov    %esi,%ebx
  8029d9:	f7 64 24 0c          	mull   0xc(%esp)
  8029dd:	89 c6                	mov    %eax,%esi
  8029df:	89 d7                	mov    %edx,%edi
  8029e1:	39 d1                	cmp    %edx,%ecx
  8029e3:	72 06                	jb     8029eb <__umoddi3+0xfb>
  8029e5:	75 10                	jne    8029f7 <__umoddi3+0x107>
  8029e7:	39 c3                	cmp    %eax,%ebx
  8029e9:	73 0c                	jae    8029f7 <__umoddi3+0x107>
  8029eb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8029ef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8029f3:	89 d7                	mov    %edx,%edi
  8029f5:	89 c6                	mov    %eax,%esi
  8029f7:	89 ca                	mov    %ecx,%edx
  8029f9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8029fe:	29 f3                	sub    %esi,%ebx
  802a00:	19 fa                	sbb    %edi,%edx
  802a02:	89 d0                	mov    %edx,%eax
  802a04:	d3 e0                	shl    %cl,%eax
  802a06:	89 e9                	mov    %ebp,%ecx
  802a08:	d3 eb                	shr    %cl,%ebx
  802a0a:	d3 ea                	shr    %cl,%edx
  802a0c:	09 d8                	or     %ebx,%eax
  802a0e:	83 c4 1c             	add    $0x1c,%esp
  802a11:	5b                   	pop    %ebx
  802a12:	5e                   	pop    %esi
  802a13:	5f                   	pop    %edi
  802a14:	5d                   	pop    %ebp
  802a15:	c3                   	ret    
  802a16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a1d:	8d 76 00             	lea    0x0(%esi),%esi
  802a20:	89 da                	mov    %ebx,%edx
  802a22:	29 fe                	sub    %edi,%esi
  802a24:	19 c2                	sbb    %eax,%edx
  802a26:	89 f1                	mov    %esi,%ecx
  802a28:	89 c8                	mov    %ecx,%eax
  802a2a:	e9 4b ff ff ff       	jmp    80297a <__umoddi3+0x8a>
