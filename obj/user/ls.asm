
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
  80005f:	e8 24 1d 00 00       	call   801d88 <printf>
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
  80007f:	e8 04 1d 00 00       	call   801d88 <printf>
  800084:	83 c4 10             	add    $0x10,%esp
	}
	printf("%s", name);
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	ff 75 14             	pushl  0x14(%ebp)
  80008d:	68 e1 2f 80 00       	push   $0x802fe1
  800092:	e8 f1 1c 00 00       	call   801d88 <printf>
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
  8000b1:	e8 d2 1c 00 00       	call   801d88 <printf>
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
  8000c4:	e8 28 0b 00 00       	call   800bf1 <strlen>
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
  8000e8:	e8 9b 1c 00 00       	call   801d88 <printf>
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
  800104:	e8 dc 1a 00 00       	call   801be5 <open>
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
  800122:	e8 a7 16 00 00       	call   8017ce <readn>
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
  80016d:	e8 63 02 00 00       	call   8003d5 <_panic>
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
  80018d:	e8 43 02 00 00       	call   8003d5 <_panic>
		panic("error reading directory %s: %e", path, n);
  800192:	83 ec 0c             	sub    $0xc,%esp
  800195:	50                   	push   %eax
  800196:	57                   	push   %edi
  800197:	68 cc 2a 80 00       	push   $0x802acc
  80019c:	6a 24                	push   $0x24
  80019e:	68 7c 2a 80 00       	push   $0x802a7c
  8001a3:	e8 2d 02 00 00       	call   8003d5 <_panic>

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
  8001bd:	e8 ef 17 00 00       	call   8019b1 <stat>
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
  800206:	e8 ca 01 00 00       	call   8003d5 <_panic>
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
  800227:	e8 5c 1b 00 00       	call   801d88 <printf>
	exit();
  80022c:	e8 70 01 00 00       	call   8003a1 <exit>
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
  80024a:	e8 c2 10 00 00       	call   801311 <argstart>
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
  800263:	e8 d9 10 00 00       	call   801341 <argnext>
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
  8002d9:	e8 00 0d 00 00       	call   800fde <sys_getenvid>
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
  8002fe:	74 23                	je     800323 <libmain+0x5d>
		if(envs[i].env_id == find)
  800300:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  800306:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  80030c:	8b 49 48             	mov    0x48(%ecx),%ecx
  80030f:	39 c1                	cmp    %eax,%ecx
  800311:	75 e2                	jne    8002f5 <libmain+0x2f>
  800313:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  800319:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80031f:	89 fe                	mov    %edi,%esi
  800321:	eb d2                	jmp    8002f5 <libmain+0x2f>
  800323:	89 f0                	mov    %esi,%eax
  800325:	84 c0                	test   %al,%al
  800327:	74 06                	je     80032f <libmain+0x69>
  800329:	89 1d 20 54 80 00    	mov    %ebx,0x805420
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80032f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800333:	7e 0a                	jle    80033f <libmain+0x79>
		binaryname = argv[0];
  800335:	8b 45 0c             	mov    0xc(%ebp),%eax
  800338:	8b 00                	mov    (%eax),%eax
  80033a:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  80033f:	a1 20 54 80 00       	mov    0x805420,%eax
  800344:	8b 40 48             	mov    0x48(%eax),%eax
  800347:	83 ec 08             	sub    $0x8,%esp
  80034a:	50                   	push   %eax
  80034b:	68 eb 2a 80 00       	push   $0x802aeb
  800350:	e8 76 01 00 00       	call   8004cb <cprintf>
	cprintf("before umain\n");
  800355:	c7 04 24 09 2b 80 00 	movl   $0x802b09,(%esp)
  80035c:	e8 6a 01 00 00       	call   8004cb <cprintf>
	// call user main routine
	umain(argc, argv);
  800361:	83 c4 08             	add    $0x8,%esp
  800364:	ff 75 0c             	pushl  0xc(%ebp)
  800367:	ff 75 08             	pushl  0x8(%ebp)
  80036a:	e8 c7 fe ff ff       	call   800236 <umain>
	cprintf("after umain\n");
  80036f:	c7 04 24 17 2b 80 00 	movl   $0x802b17,(%esp)
  800376:	e8 50 01 00 00       	call   8004cb <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  80037b:	a1 20 54 80 00       	mov    0x805420,%eax
  800380:	8b 40 48             	mov    0x48(%eax),%eax
  800383:	83 c4 08             	add    $0x8,%esp
  800386:	50                   	push   %eax
  800387:	68 24 2b 80 00       	push   $0x802b24
  80038c:	e8 3a 01 00 00       	call   8004cb <cprintf>
	// exit gracefully
	exit();
  800391:	e8 0b 00 00 00       	call   8003a1 <exit>
}
  800396:	83 c4 10             	add    $0x10,%esp
  800399:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80039c:	5b                   	pop    %ebx
  80039d:	5e                   	pop    %esi
  80039e:	5f                   	pop    %edi
  80039f:	5d                   	pop    %ebp
  8003a0:	c3                   	ret    

008003a1 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003a1:	55                   	push   %ebp
  8003a2:	89 e5                	mov    %esp,%ebp
  8003a4:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8003a7:	a1 20 54 80 00       	mov    0x805420,%eax
  8003ac:	8b 40 48             	mov    0x48(%eax),%eax
  8003af:	68 50 2b 80 00       	push   $0x802b50
  8003b4:	50                   	push   %eax
  8003b5:	68 43 2b 80 00       	push   $0x802b43
  8003ba:	e8 0c 01 00 00       	call   8004cb <cprintf>
	close_all();
  8003bf:	e8 72 12 00 00       	call   801636 <close_all>
	sys_env_destroy(0);
  8003c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8003cb:	e8 cd 0b 00 00       	call   800f9d <sys_env_destroy>
}
  8003d0:	83 c4 10             	add    $0x10,%esp
  8003d3:	c9                   	leave  
  8003d4:	c3                   	ret    

008003d5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003d5:	55                   	push   %ebp
  8003d6:	89 e5                	mov    %esp,%ebp
  8003d8:	56                   	push   %esi
  8003d9:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8003da:	a1 20 54 80 00       	mov    0x805420,%eax
  8003df:	8b 40 48             	mov    0x48(%eax),%eax
  8003e2:	83 ec 04             	sub    $0x4,%esp
  8003e5:	68 7c 2b 80 00       	push   $0x802b7c
  8003ea:	50                   	push   %eax
  8003eb:	68 43 2b 80 00       	push   $0x802b43
  8003f0:	e8 d6 00 00 00       	call   8004cb <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8003f5:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003f8:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8003fe:	e8 db 0b 00 00       	call   800fde <sys_getenvid>
  800403:	83 c4 04             	add    $0x4,%esp
  800406:	ff 75 0c             	pushl  0xc(%ebp)
  800409:	ff 75 08             	pushl  0x8(%ebp)
  80040c:	56                   	push   %esi
  80040d:	50                   	push   %eax
  80040e:	68 58 2b 80 00       	push   $0x802b58
  800413:	e8 b3 00 00 00       	call   8004cb <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800418:	83 c4 18             	add    $0x18,%esp
  80041b:	53                   	push   %ebx
  80041c:	ff 75 10             	pushl  0x10(%ebp)
  80041f:	e8 56 00 00 00       	call   80047a <vcprintf>
	cprintf("\n");
  800424:	c7 04 24 07 2b 80 00 	movl   $0x802b07,(%esp)
  80042b:	e8 9b 00 00 00       	call   8004cb <cprintf>
  800430:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800433:	cc                   	int3   
  800434:	eb fd                	jmp    800433 <_panic+0x5e>

00800436 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800436:	55                   	push   %ebp
  800437:	89 e5                	mov    %esp,%ebp
  800439:	53                   	push   %ebx
  80043a:	83 ec 04             	sub    $0x4,%esp
  80043d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800440:	8b 13                	mov    (%ebx),%edx
  800442:	8d 42 01             	lea    0x1(%edx),%eax
  800445:	89 03                	mov    %eax,(%ebx)
  800447:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80044a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80044e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800453:	74 09                	je     80045e <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800455:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800459:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80045c:	c9                   	leave  
  80045d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80045e:	83 ec 08             	sub    $0x8,%esp
  800461:	68 ff 00 00 00       	push   $0xff
  800466:	8d 43 08             	lea    0x8(%ebx),%eax
  800469:	50                   	push   %eax
  80046a:	e8 f1 0a 00 00       	call   800f60 <sys_cputs>
		b->idx = 0;
  80046f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800475:	83 c4 10             	add    $0x10,%esp
  800478:	eb db                	jmp    800455 <putch+0x1f>

0080047a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80047a:	55                   	push   %ebp
  80047b:	89 e5                	mov    %esp,%ebp
  80047d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800483:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80048a:	00 00 00 
	b.cnt = 0;
  80048d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800494:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800497:	ff 75 0c             	pushl  0xc(%ebp)
  80049a:	ff 75 08             	pushl  0x8(%ebp)
  80049d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004a3:	50                   	push   %eax
  8004a4:	68 36 04 80 00       	push   $0x800436
  8004a9:	e8 4a 01 00 00       	call   8005f8 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004ae:	83 c4 08             	add    $0x8,%esp
  8004b1:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8004b7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004bd:	50                   	push   %eax
  8004be:	e8 9d 0a 00 00       	call   800f60 <sys_cputs>

	return b.cnt;
}
  8004c3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004c9:	c9                   	leave  
  8004ca:	c3                   	ret    

008004cb <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004cb:	55                   	push   %ebp
  8004cc:	89 e5                	mov    %esp,%ebp
  8004ce:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004d1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004d4:	50                   	push   %eax
  8004d5:	ff 75 08             	pushl  0x8(%ebp)
  8004d8:	e8 9d ff ff ff       	call   80047a <vcprintf>
	va_end(ap);

	return cnt;
}
  8004dd:	c9                   	leave  
  8004de:	c3                   	ret    

008004df <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004df:	55                   	push   %ebp
  8004e0:	89 e5                	mov    %esp,%ebp
  8004e2:	57                   	push   %edi
  8004e3:	56                   	push   %esi
  8004e4:	53                   	push   %ebx
  8004e5:	83 ec 1c             	sub    $0x1c,%esp
  8004e8:	89 c6                	mov    %eax,%esi
  8004ea:	89 d7                	mov    %edx,%edi
  8004ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004f5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8004f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8004fb:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8004fe:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800502:	74 2c                	je     800530 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800504:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800507:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80050e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800511:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800514:	39 c2                	cmp    %eax,%edx
  800516:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800519:	73 43                	jae    80055e <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80051b:	83 eb 01             	sub    $0x1,%ebx
  80051e:	85 db                	test   %ebx,%ebx
  800520:	7e 6c                	jle    80058e <printnum+0xaf>
				putch(padc, putdat);
  800522:	83 ec 08             	sub    $0x8,%esp
  800525:	57                   	push   %edi
  800526:	ff 75 18             	pushl  0x18(%ebp)
  800529:	ff d6                	call   *%esi
  80052b:	83 c4 10             	add    $0x10,%esp
  80052e:	eb eb                	jmp    80051b <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800530:	83 ec 0c             	sub    $0xc,%esp
  800533:	6a 20                	push   $0x20
  800535:	6a 00                	push   $0x0
  800537:	50                   	push   %eax
  800538:	ff 75 e4             	pushl  -0x1c(%ebp)
  80053b:	ff 75 e0             	pushl  -0x20(%ebp)
  80053e:	89 fa                	mov    %edi,%edx
  800540:	89 f0                	mov    %esi,%eax
  800542:	e8 98 ff ff ff       	call   8004df <printnum>
		while (--width > 0)
  800547:	83 c4 20             	add    $0x20,%esp
  80054a:	83 eb 01             	sub    $0x1,%ebx
  80054d:	85 db                	test   %ebx,%ebx
  80054f:	7e 65                	jle    8005b6 <printnum+0xd7>
			putch(padc, putdat);
  800551:	83 ec 08             	sub    $0x8,%esp
  800554:	57                   	push   %edi
  800555:	6a 20                	push   $0x20
  800557:	ff d6                	call   *%esi
  800559:	83 c4 10             	add    $0x10,%esp
  80055c:	eb ec                	jmp    80054a <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80055e:	83 ec 0c             	sub    $0xc,%esp
  800561:	ff 75 18             	pushl  0x18(%ebp)
  800564:	83 eb 01             	sub    $0x1,%ebx
  800567:	53                   	push   %ebx
  800568:	50                   	push   %eax
  800569:	83 ec 08             	sub    $0x8,%esp
  80056c:	ff 75 dc             	pushl  -0x24(%ebp)
  80056f:	ff 75 d8             	pushl  -0x28(%ebp)
  800572:	ff 75 e4             	pushl  -0x1c(%ebp)
  800575:	ff 75 e0             	pushl  -0x20(%ebp)
  800578:	e8 93 22 00 00       	call   802810 <__udivdi3>
  80057d:	83 c4 18             	add    $0x18,%esp
  800580:	52                   	push   %edx
  800581:	50                   	push   %eax
  800582:	89 fa                	mov    %edi,%edx
  800584:	89 f0                	mov    %esi,%eax
  800586:	e8 54 ff ff ff       	call   8004df <printnum>
  80058b:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80058e:	83 ec 08             	sub    $0x8,%esp
  800591:	57                   	push   %edi
  800592:	83 ec 04             	sub    $0x4,%esp
  800595:	ff 75 dc             	pushl  -0x24(%ebp)
  800598:	ff 75 d8             	pushl  -0x28(%ebp)
  80059b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80059e:	ff 75 e0             	pushl  -0x20(%ebp)
  8005a1:	e8 7a 23 00 00       	call   802920 <__umoddi3>
  8005a6:	83 c4 14             	add    $0x14,%esp
  8005a9:	0f be 80 83 2b 80 00 	movsbl 0x802b83(%eax),%eax
  8005b0:	50                   	push   %eax
  8005b1:	ff d6                	call   *%esi
  8005b3:	83 c4 10             	add    $0x10,%esp
	}
}
  8005b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005b9:	5b                   	pop    %ebx
  8005ba:	5e                   	pop    %esi
  8005bb:	5f                   	pop    %edi
  8005bc:	5d                   	pop    %ebp
  8005bd:	c3                   	ret    

008005be <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005be:	55                   	push   %ebp
  8005bf:	89 e5                	mov    %esp,%ebp
  8005c1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005c4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005c8:	8b 10                	mov    (%eax),%edx
  8005ca:	3b 50 04             	cmp    0x4(%eax),%edx
  8005cd:	73 0a                	jae    8005d9 <sprintputch+0x1b>
		*b->buf++ = ch;
  8005cf:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005d2:	89 08                	mov    %ecx,(%eax)
  8005d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d7:	88 02                	mov    %al,(%edx)
}
  8005d9:	5d                   	pop    %ebp
  8005da:	c3                   	ret    

008005db <printfmt>:
{
  8005db:	55                   	push   %ebp
  8005dc:	89 e5                	mov    %esp,%ebp
  8005de:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8005e1:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005e4:	50                   	push   %eax
  8005e5:	ff 75 10             	pushl  0x10(%ebp)
  8005e8:	ff 75 0c             	pushl  0xc(%ebp)
  8005eb:	ff 75 08             	pushl  0x8(%ebp)
  8005ee:	e8 05 00 00 00       	call   8005f8 <vprintfmt>
}
  8005f3:	83 c4 10             	add    $0x10,%esp
  8005f6:	c9                   	leave  
  8005f7:	c3                   	ret    

008005f8 <vprintfmt>:
{
  8005f8:	55                   	push   %ebp
  8005f9:	89 e5                	mov    %esp,%ebp
  8005fb:	57                   	push   %edi
  8005fc:	56                   	push   %esi
  8005fd:	53                   	push   %ebx
  8005fe:	83 ec 3c             	sub    $0x3c,%esp
  800601:	8b 75 08             	mov    0x8(%ebp),%esi
  800604:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800607:	8b 7d 10             	mov    0x10(%ebp),%edi
  80060a:	e9 32 04 00 00       	jmp    800a41 <vprintfmt+0x449>
		padc = ' ';
  80060f:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800613:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80061a:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800621:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800628:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80062f:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800636:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80063b:	8d 47 01             	lea    0x1(%edi),%eax
  80063e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800641:	0f b6 17             	movzbl (%edi),%edx
  800644:	8d 42 dd             	lea    -0x23(%edx),%eax
  800647:	3c 55                	cmp    $0x55,%al
  800649:	0f 87 12 05 00 00    	ja     800b61 <vprintfmt+0x569>
  80064f:	0f b6 c0             	movzbl %al,%eax
  800652:	ff 24 85 60 2d 80 00 	jmp    *0x802d60(,%eax,4)
  800659:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80065c:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800660:	eb d9                	jmp    80063b <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800662:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800665:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800669:	eb d0                	jmp    80063b <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80066b:	0f b6 d2             	movzbl %dl,%edx
  80066e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800671:	b8 00 00 00 00       	mov    $0x0,%eax
  800676:	89 75 08             	mov    %esi,0x8(%ebp)
  800679:	eb 03                	jmp    80067e <vprintfmt+0x86>
  80067b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80067e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800681:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800685:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800688:	8d 72 d0             	lea    -0x30(%edx),%esi
  80068b:	83 fe 09             	cmp    $0x9,%esi
  80068e:	76 eb                	jbe    80067b <vprintfmt+0x83>
  800690:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800693:	8b 75 08             	mov    0x8(%ebp),%esi
  800696:	eb 14                	jmp    8006ac <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800698:	8b 45 14             	mov    0x14(%ebp),%eax
  80069b:	8b 00                	mov    (%eax),%eax
  80069d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a3:	8d 40 04             	lea    0x4(%eax),%eax
  8006a6:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006a9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8006ac:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006b0:	79 89                	jns    80063b <vprintfmt+0x43>
				width = precision, precision = -1;
  8006b2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006b8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8006bf:	e9 77 ff ff ff       	jmp    80063b <vprintfmt+0x43>
  8006c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006c7:	85 c0                	test   %eax,%eax
  8006c9:	0f 48 c1             	cmovs  %ecx,%eax
  8006cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006d2:	e9 64 ff ff ff       	jmp    80063b <vprintfmt+0x43>
  8006d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8006da:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8006e1:	e9 55 ff ff ff       	jmp    80063b <vprintfmt+0x43>
			lflag++;
  8006e6:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006ed:	e9 49 ff ff ff       	jmp    80063b <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8006f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f5:	8d 78 04             	lea    0x4(%eax),%edi
  8006f8:	83 ec 08             	sub    $0x8,%esp
  8006fb:	53                   	push   %ebx
  8006fc:	ff 30                	pushl  (%eax)
  8006fe:	ff d6                	call   *%esi
			break;
  800700:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800703:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800706:	e9 33 03 00 00       	jmp    800a3e <vprintfmt+0x446>
			err = va_arg(ap, int);
  80070b:	8b 45 14             	mov    0x14(%ebp),%eax
  80070e:	8d 78 04             	lea    0x4(%eax),%edi
  800711:	8b 00                	mov    (%eax),%eax
  800713:	99                   	cltd   
  800714:	31 d0                	xor    %edx,%eax
  800716:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800718:	83 f8 11             	cmp    $0x11,%eax
  80071b:	7f 23                	jg     800740 <vprintfmt+0x148>
  80071d:	8b 14 85 c0 2e 80 00 	mov    0x802ec0(,%eax,4),%edx
  800724:	85 d2                	test   %edx,%edx
  800726:	74 18                	je     800740 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800728:	52                   	push   %edx
  800729:	68 e1 2f 80 00       	push   $0x802fe1
  80072e:	53                   	push   %ebx
  80072f:	56                   	push   %esi
  800730:	e8 a6 fe ff ff       	call   8005db <printfmt>
  800735:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800738:	89 7d 14             	mov    %edi,0x14(%ebp)
  80073b:	e9 fe 02 00 00       	jmp    800a3e <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800740:	50                   	push   %eax
  800741:	68 9b 2b 80 00       	push   $0x802b9b
  800746:	53                   	push   %ebx
  800747:	56                   	push   %esi
  800748:	e8 8e fe ff ff       	call   8005db <printfmt>
  80074d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800750:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800753:	e9 e6 02 00 00       	jmp    800a3e <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800758:	8b 45 14             	mov    0x14(%ebp),%eax
  80075b:	83 c0 04             	add    $0x4,%eax
  80075e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800761:	8b 45 14             	mov    0x14(%ebp),%eax
  800764:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800766:	85 c9                	test   %ecx,%ecx
  800768:	b8 94 2b 80 00       	mov    $0x802b94,%eax
  80076d:	0f 45 c1             	cmovne %ecx,%eax
  800770:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800773:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800777:	7e 06                	jle    80077f <vprintfmt+0x187>
  800779:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80077d:	75 0d                	jne    80078c <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80077f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800782:	89 c7                	mov    %eax,%edi
  800784:	03 45 e0             	add    -0x20(%ebp),%eax
  800787:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80078a:	eb 53                	jmp    8007df <vprintfmt+0x1e7>
  80078c:	83 ec 08             	sub    $0x8,%esp
  80078f:	ff 75 d8             	pushl  -0x28(%ebp)
  800792:	50                   	push   %eax
  800793:	e8 71 04 00 00       	call   800c09 <strnlen>
  800798:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80079b:	29 c1                	sub    %eax,%ecx
  80079d:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8007a0:	83 c4 10             	add    $0x10,%esp
  8007a3:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8007a5:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8007a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8007ac:	eb 0f                	jmp    8007bd <vprintfmt+0x1c5>
					putch(padc, putdat);
  8007ae:	83 ec 08             	sub    $0x8,%esp
  8007b1:	53                   	push   %ebx
  8007b2:	ff 75 e0             	pushl  -0x20(%ebp)
  8007b5:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007b7:	83 ef 01             	sub    $0x1,%edi
  8007ba:	83 c4 10             	add    $0x10,%esp
  8007bd:	85 ff                	test   %edi,%edi
  8007bf:	7f ed                	jg     8007ae <vprintfmt+0x1b6>
  8007c1:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8007c4:	85 c9                	test   %ecx,%ecx
  8007c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007cb:	0f 49 c1             	cmovns %ecx,%eax
  8007ce:	29 c1                	sub    %eax,%ecx
  8007d0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8007d3:	eb aa                	jmp    80077f <vprintfmt+0x187>
					putch(ch, putdat);
  8007d5:	83 ec 08             	sub    $0x8,%esp
  8007d8:	53                   	push   %ebx
  8007d9:	52                   	push   %edx
  8007da:	ff d6                	call   *%esi
  8007dc:	83 c4 10             	add    $0x10,%esp
  8007df:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007e2:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007e4:	83 c7 01             	add    $0x1,%edi
  8007e7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007eb:	0f be d0             	movsbl %al,%edx
  8007ee:	85 d2                	test   %edx,%edx
  8007f0:	74 4b                	je     80083d <vprintfmt+0x245>
  8007f2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007f6:	78 06                	js     8007fe <vprintfmt+0x206>
  8007f8:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8007fc:	78 1e                	js     80081c <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8007fe:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800802:	74 d1                	je     8007d5 <vprintfmt+0x1dd>
  800804:	0f be c0             	movsbl %al,%eax
  800807:	83 e8 20             	sub    $0x20,%eax
  80080a:	83 f8 5e             	cmp    $0x5e,%eax
  80080d:	76 c6                	jbe    8007d5 <vprintfmt+0x1dd>
					putch('?', putdat);
  80080f:	83 ec 08             	sub    $0x8,%esp
  800812:	53                   	push   %ebx
  800813:	6a 3f                	push   $0x3f
  800815:	ff d6                	call   *%esi
  800817:	83 c4 10             	add    $0x10,%esp
  80081a:	eb c3                	jmp    8007df <vprintfmt+0x1e7>
  80081c:	89 cf                	mov    %ecx,%edi
  80081e:	eb 0e                	jmp    80082e <vprintfmt+0x236>
				putch(' ', putdat);
  800820:	83 ec 08             	sub    $0x8,%esp
  800823:	53                   	push   %ebx
  800824:	6a 20                	push   $0x20
  800826:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800828:	83 ef 01             	sub    $0x1,%edi
  80082b:	83 c4 10             	add    $0x10,%esp
  80082e:	85 ff                	test   %edi,%edi
  800830:	7f ee                	jg     800820 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800832:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800835:	89 45 14             	mov    %eax,0x14(%ebp)
  800838:	e9 01 02 00 00       	jmp    800a3e <vprintfmt+0x446>
  80083d:	89 cf                	mov    %ecx,%edi
  80083f:	eb ed                	jmp    80082e <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800841:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800844:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80084b:	e9 eb fd ff ff       	jmp    80063b <vprintfmt+0x43>
	if (lflag >= 2)
  800850:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800854:	7f 21                	jg     800877 <vprintfmt+0x27f>
	else if (lflag)
  800856:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80085a:	74 68                	je     8008c4 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80085c:	8b 45 14             	mov    0x14(%ebp),%eax
  80085f:	8b 00                	mov    (%eax),%eax
  800861:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800864:	89 c1                	mov    %eax,%ecx
  800866:	c1 f9 1f             	sar    $0x1f,%ecx
  800869:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80086c:	8b 45 14             	mov    0x14(%ebp),%eax
  80086f:	8d 40 04             	lea    0x4(%eax),%eax
  800872:	89 45 14             	mov    %eax,0x14(%ebp)
  800875:	eb 17                	jmp    80088e <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800877:	8b 45 14             	mov    0x14(%ebp),%eax
  80087a:	8b 50 04             	mov    0x4(%eax),%edx
  80087d:	8b 00                	mov    (%eax),%eax
  80087f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800882:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800885:	8b 45 14             	mov    0x14(%ebp),%eax
  800888:	8d 40 08             	lea    0x8(%eax),%eax
  80088b:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80088e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800891:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800894:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800897:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80089a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80089e:	78 3f                	js     8008df <vprintfmt+0x2e7>
			base = 10;
  8008a0:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8008a5:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8008a9:	0f 84 71 01 00 00    	je     800a20 <vprintfmt+0x428>
				putch('+', putdat);
  8008af:	83 ec 08             	sub    $0x8,%esp
  8008b2:	53                   	push   %ebx
  8008b3:	6a 2b                	push   $0x2b
  8008b5:	ff d6                	call   *%esi
  8008b7:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008ba:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008bf:	e9 5c 01 00 00       	jmp    800a20 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8008c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c7:	8b 00                	mov    (%eax),%eax
  8008c9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008cc:	89 c1                	mov    %eax,%ecx
  8008ce:	c1 f9 1f             	sar    $0x1f,%ecx
  8008d1:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8008d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d7:	8d 40 04             	lea    0x4(%eax),%eax
  8008da:	89 45 14             	mov    %eax,0x14(%ebp)
  8008dd:	eb af                	jmp    80088e <vprintfmt+0x296>
				putch('-', putdat);
  8008df:	83 ec 08             	sub    $0x8,%esp
  8008e2:	53                   	push   %ebx
  8008e3:	6a 2d                	push   $0x2d
  8008e5:	ff d6                	call   *%esi
				num = -(long long) num;
  8008e7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008ea:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8008ed:	f7 d8                	neg    %eax
  8008ef:	83 d2 00             	adc    $0x0,%edx
  8008f2:	f7 da                	neg    %edx
  8008f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008f7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008fa:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008fd:	b8 0a 00 00 00       	mov    $0xa,%eax
  800902:	e9 19 01 00 00       	jmp    800a20 <vprintfmt+0x428>
	if (lflag >= 2)
  800907:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80090b:	7f 29                	jg     800936 <vprintfmt+0x33e>
	else if (lflag)
  80090d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800911:	74 44                	je     800957 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800913:	8b 45 14             	mov    0x14(%ebp),%eax
  800916:	8b 00                	mov    (%eax),%eax
  800918:	ba 00 00 00 00       	mov    $0x0,%edx
  80091d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800920:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800923:	8b 45 14             	mov    0x14(%ebp),%eax
  800926:	8d 40 04             	lea    0x4(%eax),%eax
  800929:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80092c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800931:	e9 ea 00 00 00       	jmp    800a20 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800936:	8b 45 14             	mov    0x14(%ebp),%eax
  800939:	8b 50 04             	mov    0x4(%eax),%edx
  80093c:	8b 00                	mov    (%eax),%eax
  80093e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800941:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800944:	8b 45 14             	mov    0x14(%ebp),%eax
  800947:	8d 40 08             	lea    0x8(%eax),%eax
  80094a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80094d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800952:	e9 c9 00 00 00       	jmp    800a20 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800957:	8b 45 14             	mov    0x14(%ebp),%eax
  80095a:	8b 00                	mov    (%eax),%eax
  80095c:	ba 00 00 00 00       	mov    $0x0,%edx
  800961:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800964:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800967:	8b 45 14             	mov    0x14(%ebp),%eax
  80096a:	8d 40 04             	lea    0x4(%eax),%eax
  80096d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800970:	b8 0a 00 00 00       	mov    $0xa,%eax
  800975:	e9 a6 00 00 00       	jmp    800a20 <vprintfmt+0x428>
			putch('0', putdat);
  80097a:	83 ec 08             	sub    $0x8,%esp
  80097d:	53                   	push   %ebx
  80097e:	6a 30                	push   $0x30
  800980:	ff d6                	call   *%esi
	if (lflag >= 2)
  800982:	83 c4 10             	add    $0x10,%esp
  800985:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800989:	7f 26                	jg     8009b1 <vprintfmt+0x3b9>
	else if (lflag)
  80098b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80098f:	74 3e                	je     8009cf <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800991:	8b 45 14             	mov    0x14(%ebp),%eax
  800994:	8b 00                	mov    (%eax),%eax
  800996:	ba 00 00 00 00       	mov    $0x0,%edx
  80099b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80099e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a4:	8d 40 04             	lea    0x4(%eax),%eax
  8009a7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009aa:	b8 08 00 00 00       	mov    $0x8,%eax
  8009af:	eb 6f                	jmp    800a20 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8009b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b4:	8b 50 04             	mov    0x4(%eax),%edx
  8009b7:	8b 00                	mov    (%eax),%eax
  8009b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009bc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c2:	8d 40 08             	lea    0x8(%eax),%eax
  8009c5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009c8:	b8 08 00 00 00       	mov    $0x8,%eax
  8009cd:	eb 51                	jmp    800a20 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8009cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d2:	8b 00                	mov    (%eax),%eax
  8009d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009dc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009df:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e2:	8d 40 04             	lea    0x4(%eax),%eax
  8009e5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009e8:	b8 08 00 00 00       	mov    $0x8,%eax
  8009ed:	eb 31                	jmp    800a20 <vprintfmt+0x428>
			putch('0', putdat);
  8009ef:	83 ec 08             	sub    $0x8,%esp
  8009f2:	53                   	push   %ebx
  8009f3:	6a 30                	push   $0x30
  8009f5:	ff d6                	call   *%esi
			putch('x', putdat);
  8009f7:	83 c4 08             	add    $0x8,%esp
  8009fa:	53                   	push   %ebx
  8009fb:	6a 78                	push   $0x78
  8009fd:	ff d6                	call   *%esi
			num = (unsigned long long)
  8009ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800a02:	8b 00                	mov    (%eax),%eax
  800a04:	ba 00 00 00 00       	mov    $0x0,%edx
  800a09:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a0c:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800a0f:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a12:	8b 45 14             	mov    0x14(%ebp),%eax
  800a15:	8d 40 04             	lea    0x4(%eax),%eax
  800a18:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a1b:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800a20:	83 ec 0c             	sub    $0xc,%esp
  800a23:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800a27:	52                   	push   %edx
  800a28:	ff 75 e0             	pushl  -0x20(%ebp)
  800a2b:	50                   	push   %eax
  800a2c:	ff 75 dc             	pushl  -0x24(%ebp)
  800a2f:	ff 75 d8             	pushl  -0x28(%ebp)
  800a32:	89 da                	mov    %ebx,%edx
  800a34:	89 f0                	mov    %esi,%eax
  800a36:	e8 a4 fa ff ff       	call   8004df <printnum>
			break;
  800a3b:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800a3e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a41:	83 c7 01             	add    $0x1,%edi
  800a44:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a48:	83 f8 25             	cmp    $0x25,%eax
  800a4b:	0f 84 be fb ff ff    	je     80060f <vprintfmt+0x17>
			if (ch == '\0')
  800a51:	85 c0                	test   %eax,%eax
  800a53:	0f 84 28 01 00 00    	je     800b81 <vprintfmt+0x589>
			putch(ch, putdat);
  800a59:	83 ec 08             	sub    $0x8,%esp
  800a5c:	53                   	push   %ebx
  800a5d:	50                   	push   %eax
  800a5e:	ff d6                	call   *%esi
  800a60:	83 c4 10             	add    $0x10,%esp
  800a63:	eb dc                	jmp    800a41 <vprintfmt+0x449>
	if (lflag >= 2)
  800a65:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800a69:	7f 26                	jg     800a91 <vprintfmt+0x499>
	else if (lflag)
  800a6b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a6f:	74 41                	je     800ab2 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800a71:	8b 45 14             	mov    0x14(%ebp),%eax
  800a74:	8b 00                	mov    (%eax),%eax
  800a76:	ba 00 00 00 00       	mov    $0x0,%edx
  800a7b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a7e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a81:	8b 45 14             	mov    0x14(%ebp),%eax
  800a84:	8d 40 04             	lea    0x4(%eax),%eax
  800a87:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a8a:	b8 10 00 00 00       	mov    $0x10,%eax
  800a8f:	eb 8f                	jmp    800a20 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800a91:	8b 45 14             	mov    0x14(%ebp),%eax
  800a94:	8b 50 04             	mov    0x4(%eax),%edx
  800a97:	8b 00                	mov    (%eax),%eax
  800a99:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a9c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a9f:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa2:	8d 40 08             	lea    0x8(%eax),%eax
  800aa5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800aa8:	b8 10 00 00 00       	mov    $0x10,%eax
  800aad:	e9 6e ff ff ff       	jmp    800a20 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800ab2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab5:	8b 00                	mov    (%eax),%eax
  800ab7:	ba 00 00 00 00       	mov    $0x0,%edx
  800abc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800abf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ac2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac5:	8d 40 04             	lea    0x4(%eax),%eax
  800ac8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800acb:	b8 10 00 00 00       	mov    $0x10,%eax
  800ad0:	e9 4b ff ff ff       	jmp    800a20 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800ad5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad8:	83 c0 04             	add    $0x4,%eax
  800adb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ade:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae1:	8b 00                	mov    (%eax),%eax
  800ae3:	85 c0                	test   %eax,%eax
  800ae5:	74 14                	je     800afb <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800ae7:	8b 13                	mov    (%ebx),%edx
  800ae9:	83 fa 7f             	cmp    $0x7f,%edx
  800aec:	7f 37                	jg     800b25 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800aee:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800af0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800af3:	89 45 14             	mov    %eax,0x14(%ebp)
  800af6:	e9 43 ff ff ff       	jmp    800a3e <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800afb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b00:	bf b9 2c 80 00       	mov    $0x802cb9,%edi
							putch(ch, putdat);
  800b05:	83 ec 08             	sub    $0x8,%esp
  800b08:	53                   	push   %ebx
  800b09:	50                   	push   %eax
  800b0a:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800b0c:	83 c7 01             	add    $0x1,%edi
  800b0f:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800b13:	83 c4 10             	add    $0x10,%esp
  800b16:	85 c0                	test   %eax,%eax
  800b18:	75 eb                	jne    800b05 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800b1a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b1d:	89 45 14             	mov    %eax,0x14(%ebp)
  800b20:	e9 19 ff ff ff       	jmp    800a3e <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800b25:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800b27:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b2c:	bf f1 2c 80 00       	mov    $0x802cf1,%edi
							putch(ch, putdat);
  800b31:	83 ec 08             	sub    $0x8,%esp
  800b34:	53                   	push   %ebx
  800b35:	50                   	push   %eax
  800b36:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800b38:	83 c7 01             	add    $0x1,%edi
  800b3b:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800b3f:	83 c4 10             	add    $0x10,%esp
  800b42:	85 c0                	test   %eax,%eax
  800b44:	75 eb                	jne    800b31 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800b46:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b49:	89 45 14             	mov    %eax,0x14(%ebp)
  800b4c:	e9 ed fe ff ff       	jmp    800a3e <vprintfmt+0x446>
			putch(ch, putdat);
  800b51:	83 ec 08             	sub    $0x8,%esp
  800b54:	53                   	push   %ebx
  800b55:	6a 25                	push   $0x25
  800b57:	ff d6                	call   *%esi
			break;
  800b59:	83 c4 10             	add    $0x10,%esp
  800b5c:	e9 dd fe ff ff       	jmp    800a3e <vprintfmt+0x446>
			putch('%', putdat);
  800b61:	83 ec 08             	sub    $0x8,%esp
  800b64:	53                   	push   %ebx
  800b65:	6a 25                	push   $0x25
  800b67:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b69:	83 c4 10             	add    $0x10,%esp
  800b6c:	89 f8                	mov    %edi,%eax
  800b6e:	eb 03                	jmp    800b73 <vprintfmt+0x57b>
  800b70:	83 e8 01             	sub    $0x1,%eax
  800b73:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b77:	75 f7                	jne    800b70 <vprintfmt+0x578>
  800b79:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b7c:	e9 bd fe ff ff       	jmp    800a3e <vprintfmt+0x446>
}
  800b81:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b84:	5b                   	pop    %ebx
  800b85:	5e                   	pop    %esi
  800b86:	5f                   	pop    %edi
  800b87:	5d                   	pop    %ebp
  800b88:	c3                   	ret    

00800b89 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b89:	55                   	push   %ebp
  800b8a:	89 e5                	mov    %esp,%ebp
  800b8c:	83 ec 18             	sub    $0x18,%esp
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b95:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b98:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b9c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b9f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ba6:	85 c0                	test   %eax,%eax
  800ba8:	74 26                	je     800bd0 <vsnprintf+0x47>
  800baa:	85 d2                	test   %edx,%edx
  800bac:	7e 22                	jle    800bd0 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bae:	ff 75 14             	pushl  0x14(%ebp)
  800bb1:	ff 75 10             	pushl  0x10(%ebp)
  800bb4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bb7:	50                   	push   %eax
  800bb8:	68 be 05 80 00       	push   $0x8005be
  800bbd:	e8 36 fa ff ff       	call   8005f8 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800bc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bc5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bcb:	83 c4 10             	add    $0x10,%esp
}
  800bce:	c9                   	leave  
  800bcf:	c3                   	ret    
		return -E_INVAL;
  800bd0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bd5:	eb f7                	jmp    800bce <vsnprintf+0x45>

00800bd7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bd7:	55                   	push   %ebp
  800bd8:	89 e5                	mov    %esp,%ebp
  800bda:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bdd:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800be0:	50                   	push   %eax
  800be1:	ff 75 10             	pushl  0x10(%ebp)
  800be4:	ff 75 0c             	pushl  0xc(%ebp)
  800be7:	ff 75 08             	pushl  0x8(%ebp)
  800bea:	e8 9a ff ff ff       	call   800b89 <vsnprintf>
	va_end(ap);

	return rc;
}
  800bef:	c9                   	leave  
  800bf0:	c3                   	ret    

00800bf1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800bf1:	55                   	push   %ebp
  800bf2:	89 e5                	mov    %esp,%ebp
  800bf4:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800bf7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bfc:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800c00:	74 05                	je     800c07 <strlen+0x16>
		n++;
  800c02:	83 c0 01             	add    $0x1,%eax
  800c05:	eb f5                	jmp    800bfc <strlen+0xb>
	return n;
}
  800c07:	5d                   	pop    %ebp
  800c08:	c3                   	ret    

00800c09 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c09:	55                   	push   %ebp
  800c0a:	89 e5                	mov    %esp,%ebp
  800c0c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c0f:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c12:	ba 00 00 00 00       	mov    $0x0,%edx
  800c17:	39 c2                	cmp    %eax,%edx
  800c19:	74 0d                	je     800c28 <strnlen+0x1f>
  800c1b:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800c1f:	74 05                	je     800c26 <strnlen+0x1d>
		n++;
  800c21:	83 c2 01             	add    $0x1,%edx
  800c24:	eb f1                	jmp    800c17 <strnlen+0xe>
  800c26:	89 d0                	mov    %edx,%eax
	return n;
}
  800c28:	5d                   	pop    %ebp
  800c29:	c3                   	ret    

00800c2a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	53                   	push   %ebx
  800c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c31:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c34:	ba 00 00 00 00       	mov    $0x0,%edx
  800c39:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800c3d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800c40:	83 c2 01             	add    $0x1,%edx
  800c43:	84 c9                	test   %cl,%cl
  800c45:	75 f2                	jne    800c39 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800c47:	5b                   	pop    %ebx
  800c48:	5d                   	pop    %ebp
  800c49:	c3                   	ret    

00800c4a <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
  800c4d:	53                   	push   %ebx
  800c4e:	83 ec 10             	sub    $0x10,%esp
  800c51:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c54:	53                   	push   %ebx
  800c55:	e8 97 ff ff ff       	call   800bf1 <strlen>
  800c5a:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800c5d:	ff 75 0c             	pushl  0xc(%ebp)
  800c60:	01 d8                	add    %ebx,%eax
  800c62:	50                   	push   %eax
  800c63:	e8 c2 ff ff ff       	call   800c2a <strcpy>
	return dst;
}
  800c68:	89 d8                	mov    %ebx,%eax
  800c6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c6d:	c9                   	leave  
  800c6e:	c3                   	ret    

00800c6f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c6f:	55                   	push   %ebp
  800c70:	89 e5                	mov    %esp,%ebp
  800c72:	56                   	push   %esi
  800c73:	53                   	push   %ebx
  800c74:	8b 45 08             	mov    0x8(%ebp),%eax
  800c77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c7a:	89 c6                	mov    %eax,%esi
  800c7c:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c7f:	89 c2                	mov    %eax,%edx
  800c81:	39 f2                	cmp    %esi,%edx
  800c83:	74 11                	je     800c96 <strncpy+0x27>
		*dst++ = *src;
  800c85:	83 c2 01             	add    $0x1,%edx
  800c88:	0f b6 19             	movzbl (%ecx),%ebx
  800c8b:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c8e:	80 fb 01             	cmp    $0x1,%bl
  800c91:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800c94:	eb eb                	jmp    800c81 <strncpy+0x12>
	}
	return ret;
}
  800c96:	5b                   	pop    %ebx
  800c97:	5e                   	pop    %esi
  800c98:	5d                   	pop    %ebp
  800c99:	c3                   	ret    

00800c9a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	56                   	push   %esi
  800c9e:	53                   	push   %ebx
  800c9f:	8b 75 08             	mov    0x8(%ebp),%esi
  800ca2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca5:	8b 55 10             	mov    0x10(%ebp),%edx
  800ca8:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800caa:	85 d2                	test   %edx,%edx
  800cac:	74 21                	je     800ccf <strlcpy+0x35>
  800cae:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800cb2:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800cb4:	39 c2                	cmp    %eax,%edx
  800cb6:	74 14                	je     800ccc <strlcpy+0x32>
  800cb8:	0f b6 19             	movzbl (%ecx),%ebx
  800cbb:	84 db                	test   %bl,%bl
  800cbd:	74 0b                	je     800cca <strlcpy+0x30>
			*dst++ = *src++;
  800cbf:	83 c1 01             	add    $0x1,%ecx
  800cc2:	83 c2 01             	add    $0x1,%edx
  800cc5:	88 5a ff             	mov    %bl,-0x1(%edx)
  800cc8:	eb ea                	jmp    800cb4 <strlcpy+0x1a>
  800cca:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800ccc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ccf:	29 f0                	sub    %esi,%eax
}
  800cd1:	5b                   	pop    %ebx
  800cd2:	5e                   	pop    %esi
  800cd3:	5d                   	pop    %ebp
  800cd4:	c3                   	ret    

00800cd5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cd5:	55                   	push   %ebp
  800cd6:	89 e5                	mov    %esp,%ebp
  800cd8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cdb:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800cde:	0f b6 01             	movzbl (%ecx),%eax
  800ce1:	84 c0                	test   %al,%al
  800ce3:	74 0c                	je     800cf1 <strcmp+0x1c>
  800ce5:	3a 02                	cmp    (%edx),%al
  800ce7:	75 08                	jne    800cf1 <strcmp+0x1c>
		p++, q++;
  800ce9:	83 c1 01             	add    $0x1,%ecx
  800cec:	83 c2 01             	add    $0x1,%edx
  800cef:	eb ed                	jmp    800cde <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cf1:	0f b6 c0             	movzbl %al,%eax
  800cf4:	0f b6 12             	movzbl (%edx),%edx
  800cf7:	29 d0                	sub    %edx,%eax
}
  800cf9:	5d                   	pop    %ebp
  800cfa:	c3                   	ret    

00800cfb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800cfb:	55                   	push   %ebp
  800cfc:	89 e5                	mov    %esp,%ebp
  800cfe:	53                   	push   %ebx
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d05:	89 c3                	mov    %eax,%ebx
  800d07:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d0a:	eb 06                	jmp    800d12 <strncmp+0x17>
		n--, p++, q++;
  800d0c:	83 c0 01             	add    $0x1,%eax
  800d0f:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800d12:	39 d8                	cmp    %ebx,%eax
  800d14:	74 16                	je     800d2c <strncmp+0x31>
  800d16:	0f b6 08             	movzbl (%eax),%ecx
  800d19:	84 c9                	test   %cl,%cl
  800d1b:	74 04                	je     800d21 <strncmp+0x26>
  800d1d:	3a 0a                	cmp    (%edx),%cl
  800d1f:	74 eb                	je     800d0c <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d21:	0f b6 00             	movzbl (%eax),%eax
  800d24:	0f b6 12             	movzbl (%edx),%edx
  800d27:	29 d0                	sub    %edx,%eax
}
  800d29:	5b                   	pop    %ebx
  800d2a:	5d                   	pop    %ebp
  800d2b:	c3                   	ret    
		return 0;
  800d2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d31:	eb f6                	jmp    800d29 <strncmp+0x2e>

00800d33 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d3d:	0f b6 10             	movzbl (%eax),%edx
  800d40:	84 d2                	test   %dl,%dl
  800d42:	74 09                	je     800d4d <strchr+0x1a>
		if (*s == c)
  800d44:	38 ca                	cmp    %cl,%dl
  800d46:	74 0a                	je     800d52 <strchr+0x1f>
	for (; *s; s++)
  800d48:	83 c0 01             	add    $0x1,%eax
  800d4b:	eb f0                	jmp    800d3d <strchr+0xa>
			return (char *) s;
	return 0;
  800d4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d52:	5d                   	pop    %ebp
  800d53:	c3                   	ret    

00800d54 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d5e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d61:	38 ca                	cmp    %cl,%dl
  800d63:	74 09                	je     800d6e <strfind+0x1a>
  800d65:	84 d2                	test   %dl,%dl
  800d67:	74 05                	je     800d6e <strfind+0x1a>
	for (; *s; s++)
  800d69:	83 c0 01             	add    $0x1,%eax
  800d6c:	eb f0                	jmp    800d5e <strfind+0xa>
			break;
	return (char *) s;
}
  800d6e:	5d                   	pop    %ebp
  800d6f:	c3                   	ret    

00800d70 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
  800d73:	57                   	push   %edi
  800d74:	56                   	push   %esi
  800d75:	53                   	push   %ebx
  800d76:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d79:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d7c:	85 c9                	test   %ecx,%ecx
  800d7e:	74 31                	je     800db1 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d80:	89 f8                	mov    %edi,%eax
  800d82:	09 c8                	or     %ecx,%eax
  800d84:	a8 03                	test   $0x3,%al
  800d86:	75 23                	jne    800dab <memset+0x3b>
		c &= 0xFF;
  800d88:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d8c:	89 d3                	mov    %edx,%ebx
  800d8e:	c1 e3 08             	shl    $0x8,%ebx
  800d91:	89 d0                	mov    %edx,%eax
  800d93:	c1 e0 18             	shl    $0x18,%eax
  800d96:	89 d6                	mov    %edx,%esi
  800d98:	c1 e6 10             	shl    $0x10,%esi
  800d9b:	09 f0                	or     %esi,%eax
  800d9d:	09 c2                	or     %eax,%edx
  800d9f:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800da1:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800da4:	89 d0                	mov    %edx,%eax
  800da6:	fc                   	cld    
  800da7:	f3 ab                	rep stos %eax,%es:(%edi)
  800da9:	eb 06                	jmp    800db1 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800dab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dae:	fc                   	cld    
  800daf:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800db1:	89 f8                	mov    %edi,%eax
  800db3:	5b                   	pop    %ebx
  800db4:	5e                   	pop    %esi
  800db5:	5f                   	pop    %edi
  800db6:	5d                   	pop    %ebp
  800db7:	c3                   	ret    

00800db8 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800db8:	55                   	push   %ebp
  800db9:	89 e5                	mov    %esp,%ebp
  800dbb:	57                   	push   %edi
  800dbc:	56                   	push   %esi
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dc3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dc6:	39 c6                	cmp    %eax,%esi
  800dc8:	73 32                	jae    800dfc <memmove+0x44>
  800dca:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800dcd:	39 c2                	cmp    %eax,%edx
  800dcf:	76 2b                	jbe    800dfc <memmove+0x44>
		s += n;
		d += n;
  800dd1:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dd4:	89 fe                	mov    %edi,%esi
  800dd6:	09 ce                	or     %ecx,%esi
  800dd8:	09 d6                	or     %edx,%esi
  800dda:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800de0:	75 0e                	jne    800df0 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800de2:	83 ef 04             	sub    $0x4,%edi
  800de5:	8d 72 fc             	lea    -0x4(%edx),%esi
  800de8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800deb:	fd                   	std    
  800dec:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800dee:	eb 09                	jmp    800df9 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800df0:	83 ef 01             	sub    $0x1,%edi
  800df3:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800df6:	fd                   	std    
  800df7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800df9:	fc                   	cld    
  800dfa:	eb 1a                	jmp    800e16 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dfc:	89 c2                	mov    %eax,%edx
  800dfe:	09 ca                	or     %ecx,%edx
  800e00:	09 f2                	or     %esi,%edx
  800e02:	f6 c2 03             	test   $0x3,%dl
  800e05:	75 0a                	jne    800e11 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e07:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800e0a:	89 c7                	mov    %eax,%edi
  800e0c:	fc                   	cld    
  800e0d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e0f:	eb 05                	jmp    800e16 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800e11:	89 c7                	mov    %eax,%edi
  800e13:	fc                   	cld    
  800e14:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e16:	5e                   	pop    %esi
  800e17:	5f                   	pop    %edi
  800e18:	5d                   	pop    %ebp
  800e19:	c3                   	ret    

00800e1a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e1a:	55                   	push   %ebp
  800e1b:	89 e5                	mov    %esp,%ebp
  800e1d:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e20:	ff 75 10             	pushl  0x10(%ebp)
  800e23:	ff 75 0c             	pushl  0xc(%ebp)
  800e26:	ff 75 08             	pushl  0x8(%ebp)
  800e29:	e8 8a ff ff ff       	call   800db8 <memmove>
}
  800e2e:	c9                   	leave  
  800e2f:	c3                   	ret    

00800e30 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	56                   	push   %esi
  800e34:	53                   	push   %ebx
  800e35:	8b 45 08             	mov    0x8(%ebp),%eax
  800e38:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e3b:	89 c6                	mov    %eax,%esi
  800e3d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e40:	39 f0                	cmp    %esi,%eax
  800e42:	74 1c                	je     800e60 <memcmp+0x30>
		if (*s1 != *s2)
  800e44:	0f b6 08             	movzbl (%eax),%ecx
  800e47:	0f b6 1a             	movzbl (%edx),%ebx
  800e4a:	38 d9                	cmp    %bl,%cl
  800e4c:	75 08                	jne    800e56 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e4e:	83 c0 01             	add    $0x1,%eax
  800e51:	83 c2 01             	add    $0x1,%edx
  800e54:	eb ea                	jmp    800e40 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800e56:	0f b6 c1             	movzbl %cl,%eax
  800e59:	0f b6 db             	movzbl %bl,%ebx
  800e5c:	29 d8                	sub    %ebx,%eax
  800e5e:	eb 05                	jmp    800e65 <memcmp+0x35>
	}

	return 0;
  800e60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e65:	5b                   	pop    %ebx
  800e66:	5e                   	pop    %esi
  800e67:	5d                   	pop    %ebp
  800e68:	c3                   	ret    

00800e69 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e72:	89 c2                	mov    %eax,%edx
  800e74:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e77:	39 d0                	cmp    %edx,%eax
  800e79:	73 09                	jae    800e84 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e7b:	38 08                	cmp    %cl,(%eax)
  800e7d:	74 05                	je     800e84 <memfind+0x1b>
	for (; s < ends; s++)
  800e7f:	83 c0 01             	add    $0x1,%eax
  800e82:	eb f3                	jmp    800e77 <memfind+0xe>
			break;
	return (void *) s;
}
  800e84:	5d                   	pop    %ebp
  800e85:	c3                   	ret    

00800e86 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e86:	55                   	push   %ebp
  800e87:	89 e5                	mov    %esp,%ebp
  800e89:	57                   	push   %edi
  800e8a:	56                   	push   %esi
  800e8b:	53                   	push   %ebx
  800e8c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e8f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e92:	eb 03                	jmp    800e97 <strtol+0x11>
		s++;
  800e94:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e97:	0f b6 01             	movzbl (%ecx),%eax
  800e9a:	3c 20                	cmp    $0x20,%al
  800e9c:	74 f6                	je     800e94 <strtol+0xe>
  800e9e:	3c 09                	cmp    $0x9,%al
  800ea0:	74 f2                	je     800e94 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ea2:	3c 2b                	cmp    $0x2b,%al
  800ea4:	74 2a                	je     800ed0 <strtol+0x4a>
	int neg = 0;
  800ea6:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800eab:	3c 2d                	cmp    $0x2d,%al
  800ead:	74 2b                	je     800eda <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800eaf:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800eb5:	75 0f                	jne    800ec6 <strtol+0x40>
  800eb7:	80 39 30             	cmpb   $0x30,(%ecx)
  800eba:	74 28                	je     800ee4 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ebc:	85 db                	test   %ebx,%ebx
  800ebe:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ec3:	0f 44 d8             	cmove  %eax,%ebx
  800ec6:	b8 00 00 00 00       	mov    $0x0,%eax
  800ecb:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ece:	eb 50                	jmp    800f20 <strtol+0x9a>
		s++;
  800ed0:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ed3:	bf 00 00 00 00       	mov    $0x0,%edi
  800ed8:	eb d5                	jmp    800eaf <strtol+0x29>
		s++, neg = 1;
  800eda:	83 c1 01             	add    $0x1,%ecx
  800edd:	bf 01 00 00 00       	mov    $0x1,%edi
  800ee2:	eb cb                	jmp    800eaf <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ee4:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ee8:	74 0e                	je     800ef8 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800eea:	85 db                	test   %ebx,%ebx
  800eec:	75 d8                	jne    800ec6 <strtol+0x40>
		s++, base = 8;
  800eee:	83 c1 01             	add    $0x1,%ecx
  800ef1:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ef6:	eb ce                	jmp    800ec6 <strtol+0x40>
		s += 2, base = 16;
  800ef8:	83 c1 02             	add    $0x2,%ecx
  800efb:	bb 10 00 00 00       	mov    $0x10,%ebx
  800f00:	eb c4                	jmp    800ec6 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800f02:	8d 72 9f             	lea    -0x61(%edx),%esi
  800f05:	89 f3                	mov    %esi,%ebx
  800f07:	80 fb 19             	cmp    $0x19,%bl
  800f0a:	77 29                	ja     800f35 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800f0c:	0f be d2             	movsbl %dl,%edx
  800f0f:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f12:	3b 55 10             	cmp    0x10(%ebp),%edx
  800f15:	7d 30                	jge    800f47 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800f17:	83 c1 01             	add    $0x1,%ecx
  800f1a:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f1e:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800f20:	0f b6 11             	movzbl (%ecx),%edx
  800f23:	8d 72 d0             	lea    -0x30(%edx),%esi
  800f26:	89 f3                	mov    %esi,%ebx
  800f28:	80 fb 09             	cmp    $0x9,%bl
  800f2b:	77 d5                	ja     800f02 <strtol+0x7c>
			dig = *s - '0';
  800f2d:	0f be d2             	movsbl %dl,%edx
  800f30:	83 ea 30             	sub    $0x30,%edx
  800f33:	eb dd                	jmp    800f12 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800f35:	8d 72 bf             	lea    -0x41(%edx),%esi
  800f38:	89 f3                	mov    %esi,%ebx
  800f3a:	80 fb 19             	cmp    $0x19,%bl
  800f3d:	77 08                	ja     800f47 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800f3f:	0f be d2             	movsbl %dl,%edx
  800f42:	83 ea 37             	sub    $0x37,%edx
  800f45:	eb cb                	jmp    800f12 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f47:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f4b:	74 05                	je     800f52 <strtol+0xcc>
		*endptr = (char *) s;
  800f4d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f50:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f52:	89 c2                	mov    %eax,%edx
  800f54:	f7 da                	neg    %edx
  800f56:	85 ff                	test   %edi,%edi
  800f58:	0f 45 c2             	cmovne %edx,%eax
}
  800f5b:	5b                   	pop    %ebx
  800f5c:	5e                   	pop    %esi
  800f5d:	5f                   	pop    %edi
  800f5e:	5d                   	pop    %ebp
  800f5f:	c3                   	ret    

00800f60 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f60:	55                   	push   %ebp
  800f61:	89 e5                	mov    %esp,%ebp
  800f63:	57                   	push   %edi
  800f64:	56                   	push   %esi
  800f65:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f66:	b8 00 00 00 00       	mov    $0x0,%eax
  800f6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f71:	89 c3                	mov    %eax,%ebx
  800f73:	89 c7                	mov    %eax,%edi
  800f75:	89 c6                	mov    %eax,%esi
  800f77:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f79:	5b                   	pop    %ebx
  800f7a:	5e                   	pop    %esi
  800f7b:	5f                   	pop    %edi
  800f7c:	5d                   	pop    %ebp
  800f7d:	c3                   	ret    

00800f7e <sys_cgetc>:

int
sys_cgetc(void)
{
  800f7e:	55                   	push   %ebp
  800f7f:	89 e5                	mov    %esp,%ebp
  800f81:	57                   	push   %edi
  800f82:	56                   	push   %esi
  800f83:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f84:	ba 00 00 00 00       	mov    $0x0,%edx
  800f89:	b8 01 00 00 00       	mov    $0x1,%eax
  800f8e:	89 d1                	mov    %edx,%ecx
  800f90:	89 d3                	mov    %edx,%ebx
  800f92:	89 d7                	mov    %edx,%edi
  800f94:	89 d6                	mov    %edx,%esi
  800f96:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f98:	5b                   	pop    %ebx
  800f99:	5e                   	pop    %esi
  800f9a:	5f                   	pop    %edi
  800f9b:	5d                   	pop    %ebp
  800f9c:	c3                   	ret    

00800f9d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f9d:	55                   	push   %ebp
  800f9e:	89 e5                	mov    %esp,%ebp
  800fa0:	57                   	push   %edi
  800fa1:	56                   	push   %esi
  800fa2:	53                   	push   %ebx
  800fa3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fa6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fab:	8b 55 08             	mov    0x8(%ebp),%edx
  800fae:	b8 03 00 00 00       	mov    $0x3,%eax
  800fb3:	89 cb                	mov    %ecx,%ebx
  800fb5:	89 cf                	mov    %ecx,%edi
  800fb7:	89 ce                	mov    %ecx,%esi
  800fb9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fbb:	85 c0                	test   %eax,%eax
  800fbd:	7f 08                	jg     800fc7 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800fbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc2:	5b                   	pop    %ebx
  800fc3:	5e                   	pop    %esi
  800fc4:	5f                   	pop    %edi
  800fc5:	5d                   	pop    %ebp
  800fc6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc7:	83 ec 0c             	sub    $0xc,%esp
  800fca:	50                   	push   %eax
  800fcb:	6a 03                	push   $0x3
  800fcd:	68 08 2f 80 00       	push   $0x802f08
  800fd2:	6a 43                	push   $0x43
  800fd4:	68 25 2f 80 00       	push   $0x802f25
  800fd9:	e8 f7 f3 ff ff       	call   8003d5 <_panic>

00800fde <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800fde:	55                   	push   %ebp
  800fdf:	89 e5                	mov    %esp,%ebp
  800fe1:	57                   	push   %edi
  800fe2:	56                   	push   %esi
  800fe3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fe4:	ba 00 00 00 00       	mov    $0x0,%edx
  800fe9:	b8 02 00 00 00       	mov    $0x2,%eax
  800fee:	89 d1                	mov    %edx,%ecx
  800ff0:	89 d3                	mov    %edx,%ebx
  800ff2:	89 d7                	mov    %edx,%edi
  800ff4:	89 d6                	mov    %edx,%esi
  800ff6:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ff8:	5b                   	pop    %ebx
  800ff9:	5e                   	pop    %esi
  800ffa:	5f                   	pop    %edi
  800ffb:	5d                   	pop    %ebp
  800ffc:	c3                   	ret    

00800ffd <sys_yield>:

void
sys_yield(void)
{
  800ffd:	55                   	push   %ebp
  800ffe:	89 e5                	mov    %esp,%ebp
  801000:	57                   	push   %edi
  801001:	56                   	push   %esi
  801002:	53                   	push   %ebx
	asm volatile("int %1\n"
  801003:	ba 00 00 00 00       	mov    $0x0,%edx
  801008:	b8 0b 00 00 00       	mov    $0xb,%eax
  80100d:	89 d1                	mov    %edx,%ecx
  80100f:	89 d3                	mov    %edx,%ebx
  801011:	89 d7                	mov    %edx,%edi
  801013:	89 d6                	mov    %edx,%esi
  801015:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801017:	5b                   	pop    %ebx
  801018:	5e                   	pop    %esi
  801019:	5f                   	pop    %edi
  80101a:	5d                   	pop    %ebp
  80101b:	c3                   	ret    

0080101c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80101c:	55                   	push   %ebp
  80101d:	89 e5                	mov    %esp,%ebp
  80101f:	57                   	push   %edi
  801020:	56                   	push   %esi
  801021:	53                   	push   %ebx
  801022:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801025:	be 00 00 00 00       	mov    $0x0,%esi
  80102a:	8b 55 08             	mov    0x8(%ebp),%edx
  80102d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801030:	b8 04 00 00 00       	mov    $0x4,%eax
  801035:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801038:	89 f7                	mov    %esi,%edi
  80103a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80103c:	85 c0                	test   %eax,%eax
  80103e:	7f 08                	jg     801048 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801040:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801043:	5b                   	pop    %ebx
  801044:	5e                   	pop    %esi
  801045:	5f                   	pop    %edi
  801046:	5d                   	pop    %ebp
  801047:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801048:	83 ec 0c             	sub    $0xc,%esp
  80104b:	50                   	push   %eax
  80104c:	6a 04                	push   $0x4
  80104e:	68 08 2f 80 00       	push   $0x802f08
  801053:	6a 43                	push   $0x43
  801055:	68 25 2f 80 00       	push   $0x802f25
  80105a:	e8 76 f3 ff ff       	call   8003d5 <_panic>

0080105f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80105f:	55                   	push   %ebp
  801060:	89 e5                	mov    %esp,%ebp
  801062:	57                   	push   %edi
  801063:	56                   	push   %esi
  801064:	53                   	push   %ebx
  801065:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801068:	8b 55 08             	mov    0x8(%ebp),%edx
  80106b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80106e:	b8 05 00 00 00       	mov    $0x5,%eax
  801073:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801076:	8b 7d 14             	mov    0x14(%ebp),%edi
  801079:	8b 75 18             	mov    0x18(%ebp),%esi
  80107c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80107e:	85 c0                	test   %eax,%eax
  801080:	7f 08                	jg     80108a <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801082:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801085:	5b                   	pop    %ebx
  801086:	5e                   	pop    %esi
  801087:	5f                   	pop    %edi
  801088:	5d                   	pop    %ebp
  801089:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80108a:	83 ec 0c             	sub    $0xc,%esp
  80108d:	50                   	push   %eax
  80108e:	6a 05                	push   $0x5
  801090:	68 08 2f 80 00       	push   $0x802f08
  801095:	6a 43                	push   $0x43
  801097:	68 25 2f 80 00       	push   $0x802f25
  80109c:	e8 34 f3 ff ff       	call   8003d5 <_panic>

008010a1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8010a1:	55                   	push   %ebp
  8010a2:	89 e5                	mov    %esp,%ebp
  8010a4:	57                   	push   %edi
  8010a5:	56                   	push   %esi
  8010a6:	53                   	push   %ebx
  8010a7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010aa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010af:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b5:	b8 06 00 00 00       	mov    $0x6,%eax
  8010ba:	89 df                	mov    %ebx,%edi
  8010bc:	89 de                	mov    %ebx,%esi
  8010be:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010c0:	85 c0                	test   %eax,%eax
  8010c2:	7f 08                	jg     8010cc <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010c7:	5b                   	pop    %ebx
  8010c8:	5e                   	pop    %esi
  8010c9:	5f                   	pop    %edi
  8010ca:	5d                   	pop    %ebp
  8010cb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010cc:	83 ec 0c             	sub    $0xc,%esp
  8010cf:	50                   	push   %eax
  8010d0:	6a 06                	push   $0x6
  8010d2:	68 08 2f 80 00       	push   $0x802f08
  8010d7:	6a 43                	push   $0x43
  8010d9:	68 25 2f 80 00       	push   $0x802f25
  8010de:	e8 f2 f2 ff ff       	call   8003d5 <_panic>

008010e3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8010e3:	55                   	push   %ebp
  8010e4:	89 e5                	mov    %esp,%ebp
  8010e6:	57                   	push   %edi
  8010e7:	56                   	push   %esi
  8010e8:	53                   	push   %ebx
  8010e9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f7:	b8 08 00 00 00       	mov    $0x8,%eax
  8010fc:	89 df                	mov    %ebx,%edi
  8010fe:	89 de                	mov    %ebx,%esi
  801100:	cd 30                	int    $0x30
	if(check && ret > 0)
  801102:	85 c0                	test   %eax,%eax
  801104:	7f 08                	jg     80110e <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801106:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801109:	5b                   	pop    %ebx
  80110a:	5e                   	pop    %esi
  80110b:	5f                   	pop    %edi
  80110c:	5d                   	pop    %ebp
  80110d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80110e:	83 ec 0c             	sub    $0xc,%esp
  801111:	50                   	push   %eax
  801112:	6a 08                	push   $0x8
  801114:	68 08 2f 80 00       	push   $0x802f08
  801119:	6a 43                	push   $0x43
  80111b:	68 25 2f 80 00       	push   $0x802f25
  801120:	e8 b0 f2 ff ff       	call   8003d5 <_panic>

00801125 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801125:	55                   	push   %ebp
  801126:	89 e5                	mov    %esp,%ebp
  801128:	57                   	push   %edi
  801129:	56                   	push   %esi
  80112a:	53                   	push   %ebx
  80112b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80112e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801133:	8b 55 08             	mov    0x8(%ebp),%edx
  801136:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801139:	b8 09 00 00 00       	mov    $0x9,%eax
  80113e:	89 df                	mov    %ebx,%edi
  801140:	89 de                	mov    %ebx,%esi
  801142:	cd 30                	int    $0x30
	if(check && ret > 0)
  801144:	85 c0                	test   %eax,%eax
  801146:	7f 08                	jg     801150 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801148:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80114b:	5b                   	pop    %ebx
  80114c:	5e                   	pop    %esi
  80114d:	5f                   	pop    %edi
  80114e:	5d                   	pop    %ebp
  80114f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801150:	83 ec 0c             	sub    $0xc,%esp
  801153:	50                   	push   %eax
  801154:	6a 09                	push   $0x9
  801156:	68 08 2f 80 00       	push   $0x802f08
  80115b:	6a 43                	push   $0x43
  80115d:	68 25 2f 80 00       	push   $0x802f25
  801162:	e8 6e f2 ff ff       	call   8003d5 <_panic>

00801167 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801167:	55                   	push   %ebp
  801168:	89 e5                	mov    %esp,%ebp
  80116a:	57                   	push   %edi
  80116b:	56                   	push   %esi
  80116c:	53                   	push   %ebx
  80116d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801170:	bb 00 00 00 00       	mov    $0x0,%ebx
  801175:	8b 55 08             	mov    0x8(%ebp),%edx
  801178:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80117b:	b8 0a 00 00 00       	mov    $0xa,%eax
  801180:	89 df                	mov    %ebx,%edi
  801182:	89 de                	mov    %ebx,%esi
  801184:	cd 30                	int    $0x30
	if(check && ret > 0)
  801186:	85 c0                	test   %eax,%eax
  801188:	7f 08                	jg     801192 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80118a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80118d:	5b                   	pop    %ebx
  80118e:	5e                   	pop    %esi
  80118f:	5f                   	pop    %edi
  801190:	5d                   	pop    %ebp
  801191:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801192:	83 ec 0c             	sub    $0xc,%esp
  801195:	50                   	push   %eax
  801196:	6a 0a                	push   $0xa
  801198:	68 08 2f 80 00       	push   $0x802f08
  80119d:	6a 43                	push   $0x43
  80119f:	68 25 2f 80 00       	push   $0x802f25
  8011a4:	e8 2c f2 ff ff       	call   8003d5 <_panic>

008011a9 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8011a9:	55                   	push   %ebp
  8011aa:	89 e5                	mov    %esp,%ebp
  8011ac:	57                   	push   %edi
  8011ad:	56                   	push   %esi
  8011ae:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011af:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011b5:	b8 0c 00 00 00       	mov    $0xc,%eax
  8011ba:	be 00 00 00 00       	mov    $0x0,%esi
  8011bf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011c2:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011c5:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8011c7:	5b                   	pop    %ebx
  8011c8:	5e                   	pop    %esi
  8011c9:	5f                   	pop    %edi
  8011ca:	5d                   	pop    %ebp
  8011cb:	c3                   	ret    

008011cc <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8011cc:	55                   	push   %ebp
  8011cd:	89 e5                	mov    %esp,%ebp
  8011cf:	57                   	push   %edi
  8011d0:	56                   	push   %esi
  8011d1:	53                   	push   %ebx
  8011d2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011d5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011da:	8b 55 08             	mov    0x8(%ebp),%edx
  8011dd:	b8 0d 00 00 00       	mov    $0xd,%eax
  8011e2:	89 cb                	mov    %ecx,%ebx
  8011e4:	89 cf                	mov    %ecx,%edi
  8011e6:	89 ce                	mov    %ecx,%esi
  8011e8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011ea:	85 c0                	test   %eax,%eax
  8011ec:	7f 08                	jg     8011f6 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8011ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011f1:	5b                   	pop    %ebx
  8011f2:	5e                   	pop    %esi
  8011f3:	5f                   	pop    %edi
  8011f4:	5d                   	pop    %ebp
  8011f5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011f6:	83 ec 0c             	sub    $0xc,%esp
  8011f9:	50                   	push   %eax
  8011fa:	6a 0d                	push   $0xd
  8011fc:	68 08 2f 80 00       	push   $0x802f08
  801201:	6a 43                	push   $0x43
  801203:	68 25 2f 80 00       	push   $0x802f25
  801208:	e8 c8 f1 ff ff       	call   8003d5 <_panic>

0080120d <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80120d:	55                   	push   %ebp
  80120e:	89 e5                	mov    %esp,%ebp
  801210:	57                   	push   %edi
  801211:	56                   	push   %esi
  801212:	53                   	push   %ebx
	asm volatile("int %1\n"
  801213:	bb 00 00 00 00       	mov    $0x0,%ebx
  801218:	8b 55 08             	mov    0x8(%ebp),%edx
  80121b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80121e:	b8 0e 00 00 00       	mov    $0xe,%eax
  801223:	89 df                	mov    %ebx,%edi
  801225:	89 de                	mov    %ebx,%esi
  801227:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801229:	5b                   	pop    %ebx
  80122a:	5e                   	pop    %esi
  80122b:	5f                   	pop    %edi
  80122c:	5d                   	pop    %ebp
  80122d:	c3                   	ret    

0080122e <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80122e:	55                   	push   %ebp
  80122f:	89 e5                	mov    %esp,%ebp
  801231:	57                   	push   %edi
  801232:	56                   	push   %esi
  801233:	53                   	push   %ebx
	asm volatile("int %1\n"
  801234:	b9 00 00 00 00       	mov    $0x0,%ecx
  801239:	8b 55 08             	mov    0x8(%ebp),%edx
  80123c:	b8 0f 00 00 00       	mov    $0xf,%eax
  801241:	89 cb                	mov    %ecx,%ebx
  801243:	89 cf                	mov    %ecx,%edi
  801245:	89 ce                	mov    %ecx,%esi
  801247:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801249:	5b                   	pop    %ebx
  80124a:	5e                   	pop    %esi
  80124b:	5f                   	pop    %edi
  80124c:	5d                   	pop    %ebp
  80124d:	c3                   	ret    

0080124e <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
  801251:	57                   	push   %edi
  801252:	56                   	push   %esi
  801253:	53                   	push   %ebx
	asm volatile("int %1\n"
  801254:	ba 00 00 00 00       	mov    $0x0,%edx
  801259:	b8 10 00 00 00       	mov    $0x10,%eax
  80125e:	89 d1                	mov    %edx,%ecx
  801260:	89 d3                	mov    %edx,%ebx
  801262:	89 d7                	mov    %edx,%edi
  801264:	89 d6                	mov    %edx,%esi
  801266:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801268:	5b                   	pop    %ebx
  801269:	5e                   	pop    %esi
  80126a:	5f                   	pop    %edi
  80126b:	5d                   	pop    %ebp
  80126c:	c3                   	ret    

0080126d <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  80126d:	55                   	push   %ebp
  80126e:	89 e5                	mov    %esp,%ebp
  801270:	57                   	push   %edi
  801271:	56                   	push   %esi
  801272:	53                   	push   %ebx
	asm volatile("int %1\n"
  801273:	bb 00 00 00 00       	mov    $0x0,%ebx
  801278:	8b 55 08             	mov    0x8(%ebp),%edx
  80127b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80127e:	b8 11 00 00 00       	mov    $0x11,%eax
  801283:	89 df                	mov    %ebx,%edi
  801285:	89 de                	mov    %ebx,%esi
  801287:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801289:	5b                   	pop    %ebx
  80128a:	5e                   	pop    %esi
  80128b:	5f                   	pop    %edi
  80128c:	5d                   	pop    %ebp
  80128d:	c3                   	ret    

0080128e <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  80128e:	55                   	push   %ebp
  80128f:	89 e5                	mov    %esp,%ebp
  801291:	57                   	push   %edi
  801292:	56                   	push   %esi
  801293:	53                   	push   %ebx
	asm volatile("int %1\n"
  801294:	bb 00 00 00 00       	mov    $0x0,%ebx
  801299:	8b 55 08             	mov    0x8(%ebp),%edx
  80129c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80129f:	b8 12 00 00 00       	mov    $0x12,%eax
  8012a4:	89 df                	mov    %ebx,%edi
  8012a6:	89 de                	mov    %ebx,%esi
  8012a8:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8012aa:	5b                   	pop    %ebx
  8012ab:	5e                   	pop    %esi
  8012ac:	5f                   	pop    %edi
  8012ad:	5d                   	pop    %ebp
  8012ae:	c3                   	ret    

008012af <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8012af:	55                   	push   %ebp
  8012b0:	89 e5                	mov    %esp,%ebp
  8012b2:	57                   	push   %edi
  8012b3:	56                   	push   %esi
  8012b4:	53                   	push   %ebx
  8012b5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012b8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8012c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012c3:	b8 13 00 00 00       	mov    $0x13,%eax
  8012c8:	89 df                	mov    %ebx,%edi
  8012ca:	89 de                	mov    %ebx,%esi
  8012cc:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012ce:	85 c0                	test   %eax,%eax
  8012d0:	7f 08                	jg     8012da <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8012d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012d5:	5b                   	pop    %ebx
  8012d6:	5e                   	pop    %esi
  8012d7:	5f                   	pop    %edi
  8012d8:	5d                   	pop    %ebp
  8012d9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012da:	83 ec 0c             	sub    $0xc,%esp
  8012dd:	50                   	push   %eax
  8012de:	6a 13                	push   $0x13
  8012e0:	68 08 2f 80 00       	push   $0x802f08
  8012e5:	6a 43                	push   $0x43
  8012e7:	68 25 2f 80 00       	push   $0x802f25
  8012ec:	e8 e4 f0 ff ff       	call   8003d5 <_panic>

008012f1 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
  8012f4:	57                   	push   %edi
  8012f5:	56                   	push   %esi
  8012f6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012f7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ff:	b8 14 00 00 00       	mov    $0x14,%eax
  801304:	89 cb                	mov    %ecx,%ebx
  801306:	89 cf                	mov    %ecx,%edi
  801308:	89 ce                	mov    %ecx,%esi
  80130a:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  80130c:	5b                   	pop    %ebx
  80130d:	5e                   	pop    %esi
  80130e:	5f                   	pop    %edi
  80130f:	5d                   	pop    %ebp
  801310:	c3                   	ret    

00801311 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801311:	55                   	push   %ebp
  801312:	89 e5                	mov    %esp,%ebp
  801314:	8b 55 08             	mov    0x8(%ebp),%edx
  801317:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80131a:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  80131d:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  80131f:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801322:	83 3a 01             	cmpl   $0x1,(%edx)
  801325:	7e 09                	jle    801330 <argstart+0x1f>
  801327:	ba 08 2b 80 00       	mov    $0x802b08,%edx
  80132c:	85 c9                	test   %ecx,%ecx
  80132e:	75 05                	jne    801335 <argstart+0x24>
  801330:	ba 00 00 00 00       	mov    $0x0,%edx
  801335:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  801338:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  80133f:	5d                   	pop    %ebp
  801340:	c3                   	ret    

00801341 <argnext>:

int
argnext(struct Argstate *args)
{
  801341:	55                   	push   %ebp
  801342:	89 e5                	mov    %esp,%ebp
  801344:	53                   	push   %ebx
  801345:	83 ec 04             	sub    $0x4,%esp
  801348:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  80134b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801352:	8b 43 08             	mov    0x8(%ebx),%eax
  801355:	85 c0                	test   %eax,%eax
  801357:	74 72                	je     8013cb <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  801359:	80 38 00             	cmpb   $0x0,(%eax)
  80135c:	75 48                	jne    8013a6 <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  80135e:	8b 0b                	mov    (%ebx),%ecx
  801360:	83 39 01             	cmpl   $0x1,(%ecx)
  801363:	74 58                	je     8013bd <argnext+0x7c>
		    || args->argv[1][0] != '-'
  801365:	8b 53 04             	mov    0x4(%ebx),%edx
  801368:	8b 42 04             	mov    0x4(%edx),%eax
  80136b:	80 38 2d             	cmpb   $0x2d,(%eax)
  80136e:	75 4d                	jne    8013bd <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  801370:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801374:	74 47                	je     8013bd <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801376:	83 c0 01             	add    $0x1,%eax
  801379:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  80137c:	83 ec 04             	sub    $0x4,%esp
  80137f:	8b 01                	mov    (%ecx),%eax
  801381:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801388:	50                   	push   %eax
  801389:	8d 42 08             	lea    0x8(%edx),%eax
  80138c:	50                   	push   %eax
  80138d:	83 c2 04             	add    $0x4,%edx
  801390:	52                   	push   %edx
  801391:	e8 22 fa ff ff       	call   800db8 <memmove>
		(*args->argc)--;
  801396:	8b 03                	mov    (%ebx),%eax
  801398:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  80139b:	8b 43 08             	mov    0x8(%ebx),%eax
  80139e:	83 c4 10             	add    $0x10,%esp
  8013a1:	80 38 2d             	cmpb   $0x2d,(%eax)
  8013a4:	74 11                	je     8013b7 <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  8013a6:	8b 53 08             	mov    0x8(%ebx),%edx
  8013a9:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  8013ac:	83 c2 01             	add    $0x1,%edx
  8013af:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  8013b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013b5:	c9                   	leave  
  8013b6:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8013b7:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  8013bb:	75 e9                	jne    8013a6 <argnext+0x65>
	args->curarg = 0;
  8013bd:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  8013c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8013c9:	eb e7                	jmp    8013b2 <argnext+0x71>
		return -1;
  8013cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8013d0:	eb e0                	jmp    8013b2 <argnext+0x71>

008013d2 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  8013d2:	55                   	push   %ebp
  8013d3:	89 e5                	mov    %esp,%ebp
  8013d5:	53                   	push   %ebx
  8013d6:	83 ec 04             	sub    $0x4,%esp
  8013d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  8013dc:	8b 43 08             	mov    0x8(%ebx),%eax
  8013df:	85 c0                	test   %eax,%eax
  8013e1:	74 12                	je     8013f5 <argnextvalue+0x23>
		return 0;
	if (*args->curarg) {
  8013e3:	80 38 00             	cmpb   $0x0,(%eax)
  8013e6:	74 12                	je     8013fa <argnextvalue+0x28>
		args->argvalue = args->curarg;
  8013e8:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  8013eb:	c7 43 08 08 2b 80 00 	movl   $0x802b08,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  8013f2:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  8013f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013f8:	c9                   	leave  
  8013f9:	c3                   	ret    
	} else if (*args->argc > 1) {
  8013fa:	8b 13                	mov    (%ebx),%edx
  8013fc:	83 3a 01             	cmpl   $0x1,(%edx)
  8013ff:	7f 10                	jg     801411 <argnextvalue+0x3f>
		args->argvalue = 0;
  801401:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  801408:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  80140f:	eb e1                	jmp    8013f2 <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  801411:	8b 43 04             	mov    0x4(%ebx),%eax
  801414:	8b 48 04             	mov    0x4(%eax),%ecx
  801417:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  80141a:	83 ec 04             	sub    $0x4,%esp
  80141d:	8b 12                	mov    (%edx),%edx
  80141f:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  801426:	52                   	push   %edx
  801427:	8d 50 08             	lea    0x8(%eax),%edx
  80142a:	52                   	push   %edx
  80142b:	83 c0 04             	add    $0x4,%eax
  80142e:	50                   	push   %eax
  80142f:	e8 84 f9 ff ff       	call   800db8 <memmove>
		(*args->argc)--;
  801434:	8b 03                	mov    (%ebx),%eax
  801436:	83 28 01             	subl   $0x1,(%eax)
  801439:	83 c4 10             	add    $0x10,%esp
  80143c:	eb b4                	jmp    8013f2 <argnextvalue+0x20>

0080143e <argvalue>:
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
  801441:	83 ec 08             	sub    $0x8,%esp
  801444:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801447:	8b 42 0c             	mov    0xc(%edx),%eax
  80144a:	85 c0                	test   %eax,%eax
  80144c:	74 02                	je     801450 <argvalue+0x12>
}
  80144e:	c9                   	leave  
  80144f:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801450:	83 ec 0c             	sub    $0xc,%esp
  801453:	52                   	push   %edx
  801454:	e8 79 ff ff ff       	call   8013d2 <argnextvalue>
  801459:	83 c4 10             	add    $0x10,%esp
  80145c:	eb f0                	jmp    80144e <argvalue+0x10>

0080145e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80145e:	55                   	push   %ebp
  80145f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801461:	8b 45 08             	mov    0x8(%ebp),%eax
  801464:	05 00 00 00 30       	add    $0x30000000,%eax
  801469:	c1 e8 0c             	shr    $0xc,%eax
}
  80146c:	5d                   	pop    %ebp
  80146d:	c3                   	ret    

0080146e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80146e:	55                   	push   %ebp
  80146f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801471:	8b 45 08             	mov    0x8(%ebp),%eax
  801474:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801479:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80147e:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801483:	5d                   	pop    %ebp
  801484:	c3                   	ret    

00801485 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801485:	55                   	push   %ebp
  801486:	89 e5                	mov    %esp,%ebp
  801488:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80148d:	89 c2                	mov    %eax,%edx
  80148f:	c1 ea 16             	shr    $0x16,%edx
  801492:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801499:	f6 c2 01             	test   $0x1,%dl
  80149c:	74 2d                	je     8014cb <fd_alloc+0x46>
  80149e:	89 c2                	mov    %eax,%edx
  8014a0:	c1 ea 0c             	shr    $0xc,%edx
  8014a3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014aa:	f6 c2 01             	test   $0x1,%dl
  8014ad:	74 1c                	je     8014cb <fd_alloc+0x46>
  8014af:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8014b4:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8014b9:	75 d2                	jne    80148d <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8014bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8014c4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8014c9:	eb 0a                	jmp    8014d5 <fd_alloc+0x50>
			*fd_store = fd;
  8014cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014ce:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014d5:	5d                   	pop    %ebp
  8014d6:	c3                   	ret    

008014d7 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8014d7:	55                   	push   %ebp
  8014d8:	89 e5                	mov    %esp,%ebp
  8014da:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8014dd:	83 f8 1f             	cmp    $0x1f,%eax
  8014e0:	77 30                	ja     801512 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8014e2:	c1 e0 0c             	shl    $0xc,%eax
  8014e5:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8014ea:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8014f0:	f6 c2 01             	test   $0x1,%dl
  8014f3:	74 24                	je     801519 <fd_lookup+0x42>
  8014f5:	89 c2                	mov    %eax,%edx
  8014f7:	c1 ea 0c             	shr    $0xc,%edx
  8014fa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801501:	f6 c2 01             	test   $0x1,%dl
  801504:	74 1a                	je     801520 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801506:	8b 55 0c             	mov    0xc(%ebp),%edx
  801509:	89 02                	mov    %eax,(%edx)
	return 0;
  80150b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801510:	5d                   	pop    %ebp
  801511:	c3                   	ret    
		return -E_INVAL;
  801512:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801517:	eb f7                	jmp    801510 <fd_lookup+0x39>
		return -E_INVAL;
  801519:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80151e:	eb f0                	jmp    801510 <fd_lookup+0x39>
  801520:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801525:	eb e9                	jmp    801510 <fd_lookup+0x39>

00801527 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
  80152a:	83 ec 08             	sub    $0x8,%esp
  80152d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801530:	ba 00 00 00 00       	mov    $0x0,%edx
  801535:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80153a:	39 08                	cmp    %ecx,(%eax)
  80153c:	74 38                	je     801576 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80153e:	83 c2 01             	add    $0x1,%edx
  801541:	8b 04 95 b4 2f 80 00 	mov    0x802fb4(,%edx,4),%eax
  801548:	85 c0                	test   %eax,%eax
  80154a:	75 ee                	jne    80153a <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80154c:	a1 20 54 80 00       	mov    0x805420,%eax
  801551:	8b 40 48             	mov    0x48(%eax),%eax
  801554:	83 ec 04             	sub    $0x4,%esp
  801557:	51                   	push   %ecx
  801558:	50                   	push   %eax
  801559:	68 34 2f 80 00       	push   $0x802f34
  80155e:	e8 68 ef ff ff       	call   8004cb <cprintf>
	*dev = 0;
  801563:	8b 45 0c             	mov    0xc(%ebp),%eax
  801566:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80156c:	83 c4 10             	add    $0x10,%esp
  80156f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801574:	c9                   	leave  
  801575:	c3                   	ret    
			*dev = devtab[i];
  801576:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801579:	89 01                	mov    %eax,(%ecx)
			return 0;
  80157b:	b8 00 00 00 00       	mov    $0x0,%eax
  801580:	eb f2                	jmp    801574 <dev_lookup+0x4d>

00801582 <fd_close>:
{
  801582:	55                   	push   %ebp
  801583:	89 e5                	mov    %esp,%ebp
  801585:	57                   	push   %edi
  801586:	56                   	push   %esi
  801587:	53                   	push   %ebx
  801588:	83 ec 24             	sub    $0x24,%esp
  80158b:	8b 75 08             	mov    0x8(%ebp),%esi
  80158e:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801591:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801594:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801595:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80159b:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80159e:	50                   	push   %eax
  80159f:	e8 33 ff ff ff       	call   8014d7 <fd_lookup>
  8015a4:	89 c3                	mov    %eax,%ebx
  8015a6:	83 c4 10             	add    $0x10,%esp
  8015a9:	85 c0                	test   %eax,%eax
  8015ab:	78 05                	js     8015b2 <fd_close+0x30>
	    || fd != fd2)
  8015ad:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8015b0:	74 16                	je     8015c8 <fd_close+0x46>
		return (must_exist ? r : 0);
  8015b2:	89 f8                	mov    %edi,%eax
  8015b4:	84 c0                	test   %al,%al
  8015b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8015bb:	0f 44 d8             	cmove  %eax,%ebx
}
  8015be:	89 d8                	mov    %ebx,%eax
  8015c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015c3:	5b                   	pop    %ebx
  8015c4:	5e                   	pop    %esi
  8015c5:	5f                   	pop    %edi
  8015c6:	5d                   	pop    %ebp
  8015c7:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8015c8:	83 ec 08             	sub    $0x8,%esp
  8015cb:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8015ce:	50                   	push   %eax
  8015cf:	ff 36                	pushl  (%esi)
  8015d1:	e8 51 ff ff ff       	call   801527 <dev_lookup>
  8015d6:	89 c3                	mov    %eax,%ebx
  8015d8:	83 c4 10             	add    $0x10,%esp
  8015db:	85 c0                	test   %eax,%eax
  8015dd:	78 1a                	js     8015f9 <fd_close+0x77>
		if (dev->dev_close)
  8015df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015e2:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8015e5:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8015ea:	85 c0                	test   %eax,%eax
  8015ec:	74 0b                	je     8015f9 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8015ee:	83 ec 0c             	sub    $0xc,%esp
  8015f1:	56                   	push   %esi
  8015f2:	ff d0                	call   *%eax
  8015f4:	89 c3                	mov    %eax,%ebx
  8015f6:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8015f9:	83 ec 08             	sub    $0x8,%esp
  8015fc:	56                   	push   %esi
  8015fd:	6a 00                	push   $0x0
  8015ff:	e8 9d fa ff ff       	call   8010a1 <sys_page_unmap>
	return r;
  801604:	83 c4 10             	add    $0x10,%esp
  801607:	eb b5                	jmp    8015be <fd_close+0x3c>

00801609 <close>:

int
close(int fdnum)
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
  80160c:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80160f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801612:	50                   	push   %eax
  801613:	ff 75 08             	pushl  0x8(%ebp)
  801616:	e8 bc fe ff ff       	call   8014d7 <fd_lookup>
  80161b:	83 c4 10             	add    $0x10,%esp
  80161e:	85 c0                	test   %eax,%eax
  801620:	79 02                	jns    801624 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801622:	c9                   	leave  
  801623:	c3                   	ret    
		return fd_close(fd, 1);
  801624:	83 ec 08             	sub    $0x8,%esp
  801627:	6a 01                	push   $0x1
  801629:	ff 75 f4             	pushl  -0xc(%ebp)
  80162c:	e8 51 ff ff ff       	call   801582 <fd_close>
  801631:	83 c4 10             	add    $0x10,%esp
  801634:	eb ec                	jmp    801622 <close+0x19>

00801636 <close_all>:

void
close_all(void)
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
  801639:	53                   	push   %ebx
  80163a:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80163d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801642:	83 ec 0c             	sub    $0xc,%esp
  801645:	53                   	push   %ebx
  801646:	e8 be ff ff ff       	call   801609 <close>
	for (i = 0; i < MAXFD; i++)
  80164b:	83 c3 01             	add    $0x1,%ebx
  80164e:	83 c4 10             	add    $0x10,%esp
  801651:	83 fb 20             	cmp    $0x20,%ebx
  801654:	75 ec                	jne    801642 <close_all+0xc>
}
  801656:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801659:	c9                   	leave  
  80165a:	c3                   	ret    

0080165b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
  80165e:	57                   	push   %edi
  80165f:	56                   	push   %esi
  801660:	53                   	push   %ebx
  801661:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801664:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801667:	50                   	push   %eax
  801668:	ff 75 08             	pushl  0x8(%ebp)
  80166b:	e8 67 fe ff ff       	call   8014d7 <fd_lookup>
  801670:	89 c3                	mov    %eax,%ebx
  801672:	83 c4 10             	add    $0x10,%esp
  801675:	85 c0                	test   %eax,%eax
  801677:	0f 88 81 00 00 00    	js     8016fe <dup+0xa3>
		return r;
	close(newfdnum);
  80167d:	83 ec 0c             	sub    $0xc,%esp
  801680:	ff 75 0c             	pushl  0xc(%ebp)
  801683:	e8 81 ff ff ff       	call   801609 <close>

	newfd = INDEX2FD(newfdnum);
  801688:	8b 75 0c             	mov    0xc(%ebp),%esi
  80168b:	c1 e6 0c             	shl    $0xc,%esi
  80168e:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801694:	83 c4 04             	add    $0x4,%esp
  801697:	ff 75 e4             	pushl  -0x1c(%ebp)
  80169a:	e8 cf fd ff ff       	call   80146e <fd2data>
  80169f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8016a1:	89 34 24             	mov    %esi,(%esp)
  8016a4:	e8 c5 fd ff ff       	call   80146e <fd2data>
  8016a9:	83 c4 10             	add    $0x10,%esp
  8016ac:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8016ae:	89 d8                	mov    %ebx,%eax
  8016b0:	c1 e8 16             	shr    $0x16,%eax
  8016b3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016ba:	a8 01                	test   $0x1,%al
  8016bc:	74 11                	je     8016cf <dup+0x74>
  8016be:	89 d8                	mov    %ebx,%eax
  8016c0:	c1 e8 0c             	shr    $0xc,%eax
  8016c3:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8016ca:	f6 c2 01             	test   $0x1,%dl
  8016cd:	75 39                	jne    801708 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016d2:	89 d0                	mov    %edx,%eax
  8016d4:	c1 e8 0c             	shr    $0xc,%eax
  8016d7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016de:	83 ec 0c             	sub    $0xc,%esp
  8016e1:	25 07 0e 00 00       	and    $0xe07,%eax
  8016e6:	50                   	push   %eax
  8016e7:	56                   	push   %esi
  8016e8:	6a 00                	push   $0x0
  8016ea:	52                   	push   %edx
  8016eb:	6a 00                	push   $0x0
  8016ed:	e8 6d f9 ff ff       	call   80105f <sys_page_map>
  8016f2:	89 c3                	mov    %eax,%ebx
  8016f4:	83 c4 20             	add    $0x20,%esp
  8016f7:	85 c0                	test   %eax,%eax
  8016f9:	78 31                	js     80172c <dup+0xd1>
		goto err;

	return newfdnum;
  8016fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8016fe:	89 d8                	mov    %ebx,%eax
  801700:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801703:	5b                   	pop    %ebx
  801704:	5e                   	pop    %esi
  801705:	5f                   	pop    %edi
  801706:	5d                   	pop    %ebp
  801707:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801708:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80170f:	83 ec 0c             	sub    $0xc,%esp
  801712:	25 07 0e 00 00       	and    $0xe07,%eax
  801717:	50                   	push   %eax
  801718:	57                   	push   %edi
  801719:	6a 00                	push   $0x0
  80171b:	53                   	push   %ebx
  80171c:	6a 00                	push   $0x0
  80171e:	e8 3c f9 ff ff       	call   80105f <sys_page_map>
  801723:	89 c3                	mov    %eax,%ebx
  801725:	83 c4 20             	add    $0x20,%esp
  801728:	85 c0                	test   %eax,%eax
  80172a:	79 a3                	jns    8016cf <dup+0x74>
	sys_page_unmap(0, newfd);
  80172c:	83 ec 08             	sub    $0x8,%esp
  80172f:	56                   	push   %esi
  801730:	6a 00                	push   $0x0
  801732:	e8 6a f9 ff ff       	call   8010a1 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801737:	83 c4 08             	add    $0x8,%esp
  80173a:	57                   	push   %edi
  80173b:	6a 00                	push   $0x0
  80173d:	e8 5f f9 ff ff       	call   8010a1 <sys_page_unmap>
	return r;
  801742:	83 c4 10             	add    $0x10,%esp
  801745:	eb b7                	jmp    8016fe <dup+0xa3>

00801747 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
  80174a:	53                   	push   %ebx
  80174b:	83 ec 1c             	sub    $0x1c,%esp
  80174e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801751:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801754:	50                   	push   %eax
  801755:	53                   	push   %ebx
  801756:	e8 7c fd ff ff       	call   8014d7 <fd_lookup>
  80175b:	83 c4 10             	add    $0x10,%esp
  80175e:	85 c0                	test   %eax,%eax
  801760:	78 3f                	js     8017a1 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801762:	83 ec 08             	sub    $0x8,%esp
  801765:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801768:	50                   	push   %eax
  801769:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176c:	ff 30                	pushl  (%eax)
  80176e:	e8 b4 fd ff ff       	call   801527 <dev_lookup>
  801773:	83 c4 10             	add    $0x10,%esp
  801776:	85 c0                	test   %eax,%eax
  801778:	78 27                	js     8017a1 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80177a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80177d:	8b 42 08             	mov    0x8(%edx),%eax
  801780:	83 e0 03             	and    $0x3,%eax
  801783:	83 f8 01             	cmp    $0x1,%eax
  801786:	74 1e                	je     8017a6 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178b:	8b 40 08             	mov    0x8(%eax),%eax
  80178e:	85 c0                	test   %eax,%eax
  801790:	74 35                	je     8017c7 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801792:	83 ec 04             	sub    $0x4,%esp
  801795:	ff 75 10             	pushl  0x10(%ebp)
  801798:	ff 75 0c             	pushl  0xc(%ebp)
  80179b:	52                   	push   %edx
  80179c:	ff d0                	call   *%eax
  80179e:	83 c4 10             	add    $0x10,%esp
}
  8017a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017a4:	c9                   	leave  
  8017a5:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8017a6:	a1 20 54 80 00       	mov    0x805420,%eax
  8017ab:	8b 40 48             	mov    0x48(%eax),%eax
  8017ae:	83 ec 04             	sub    $0x4,%esp
  8017b1:	53                   	push   %ebx
  8017b2:	50                   	push   %eax
  8017b3:	68 78 2f 80 00       	push   $0x802f78
  8017b8:	e8 0e ed ff ff       	call   8004cb <cprintf>
		return -E_INVAL;
  8017bd:	83 c4 10             	add    $0x10,%esp
  8017c0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017c5:	eb da                	jmp    8017a1 <read+0x5a>
		return -E_NOT_SUPP;
  8017c7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017cc:	eb d3                	jmp    8017a1 <read+0x5a>

008017ce <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
  8017d1:	57                   	push   %edi
  8017d2:	56                   	push   %esi
  8017d3:	53                   	push   %ebx
  8017d4:	83 ec 0c             	sub    $0xc,%esp
  8017d7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017da:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017dd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017e2:	39 f3                	cmp    %esi,%ebx
  8017e4:	73 23                	jae    801809 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017e6:	83 ec 04             	sub    $0x4,%esp
  8017e9:	89 f0                	mov    %esi,%eax
  8017eb:	29 d8                	sub    %ebx,%eax
  8017ed:	50                   	push   %eax
  8017ee:	89 d8                	mov    %ebx,%eax
  8017f0:	03 45 0c             	add    0xc(%ebp),%eax
  8017f3:	50                   	push   %eax
  8017f4:	57                   	push   %edi
  8017f5:	e8 4d ff ff ff       	call   801747 <read>
		if (m < 0)
  8017fa:	83 c4 10             	add    $0x10,%esp
  8017fd:	85 c0                	test   %eax,%eax
  8017ff:	78 06                	js     801807 <readn+0x39>
			return m;
		if (m == 0)
  801801:	74 06                	je     801809 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801803:	01 c3                	add    %eax,%ebx
  801805:	eb db                	jmp    8017e2 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801807:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801809:	89 d8                	mov    %ebx,%eax
  80180b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80180e:	5b                   	pop    %ebx
  80180f:	5e                   	pop    %esi
  801810:	5f                   	pop    %edi
  801811:	5d                   	pop    %ebp
  801812:	c3                   	ret    

00801813 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
  801816:	53                   	push   %ebx
  801817:	83 ec 1c             	sub    $0x1c,%esp
  80181a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80181d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801820:	50                   	push   %eax
  801821:	53                   	push   %ebx
  801822:	e8 b0 fc ff ff       	call   8014d7 <fd_lookup>
  801827:	83 c4 10             	add    $0x10,%esp
  80182a:	85 c0                	test   %eax,%eax
  80182c:	78 3a                	js     801868 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80182e:	83 ec 08             	sub    $0x8,%esp
  801831:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801834:	50                   	push   %eax
  801835:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801838:	ff 30                	pushl  (%eax)
  80183a:	e8 e8 fc ff ff       	call   801527 <dev_lookup>
  80183f:	83 c4 10             	add    $0x10,%esp
  801842:	85 c0                	test   %eax,%eax
  801844:	78 22                	js     801868 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801846:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801849:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80184d:	74 1e                	je     80186d <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80184f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801852:	8b 52 0c             	mov    0xc(%edx),%edx
  801855:	85 d2                	test   %edx,%edx
  801857:	74 35                	je     80188e <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801859:	83 ec 04             	sub    $0x4,%esp
  80185c:	ff 75 10             	pushl  0x10(%ebp)
  80185f:	ff 75 0c             	pushl  0xc(%ebp)
  801862:	50                   	push   %eax
  801863:	ff d2                	call   *%edx
  801865:	83 c4 10             	add    $0x10,%esp
}
  801868:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80186b:	c9                   	leave  
  80186c:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80186d:	a1 20 54 80 00       	mov    0x805420,%eax
  801872:	8b 40 48             	mov    0x48(%eax),%eax
  801875:	83 ec 04             	sub    $0x4,%esp
  801878:	53                   	push   %ebx
  801879:	50                   	push   %eax
  80187a:	68 94 2f 80 00       	push   $0x802f94
  80187f:	e8 47 ec ff ff       	call   8004cb <cprintf>
		return -E_INVAL;
  801884:	83 c4 10             	add    $0x10,%esp
  801887:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80188c:	eb da                	jmp    801868 <write+0x55>
		return -E_NOT_SUPP;
  80188e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801893:	eb d3                	jmp    801868 <write+0x55>

00801895 <seek>:

int
seek(int fdnum, off_t offset)
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
  801898:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80189b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80189e:	50                   	push   %eax
  80189f:	ff 75 08             	pushl  0x8(%ebp)
  8018a2:	e8 30 fc ff ff       	call   8014d7 <fd_lookup>
  8018a7:	83 c4 10             	add    $0x10,%esp
  8018aa:	85 c0                	test   %eax,%eax
  8018ac:	78 0e                	js     8018bc <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8018ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b4:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8018b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018bc:	c9                   	leave  
  8018bd:	c3                   	ret    

008018be <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	53                   	push   %ebx
  8018c2:	83 ec 1c             	sub    $0x1c,%esp
  8018c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018c8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018cb:	50                   	push   %eax
  8018cc:	53                   	push   %ebx
  8018cd:	e8 05 fc ff ff       	call   8014d7 <fd_lookup>
  8018d2:	83 c4 10             	add    $0x10,%esp
  8018d5:	85 c0                	test   %eax,%eax
  8018d7:	78 37                	js     801910 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018d9:	83 ec 08             	sub    $0x8,%esp
  8018dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018df:	50                   	push   %eax
  8018e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e3:	ff 30                	pushl  (%eax)
  8018e5:	e8 3d fc ff ff       	call   801527 <dev_lookup>
  8018ea:	83 c4 10             	add    $0x10,%esp
  8018ed:	85 c0                	test   %eax,%eax
  8018ef:	78 1f                	js     801910 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f4:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018f8:	74 1b                	je     801915 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8018fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018fd:	8b 52 18             	mov    0x18(%edx),%edx
  801900:	85 d2                	test   %edx,%edx
  801902:	74 32                	je     801936 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801904:	83 ec 08             	sub    $0x8,%esp
  801907:	ff 75 0c             	pushl  0xc(%ebp)
  80190a:	50                   	push   %eax
  80190b:	ff d2                	call   *%edx
  80190d:	83 c4 10             	add    $0x10,%esp
}
  801910:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801913:	c9                   	leave  
  801914:	c3                   	ret    
			thisenv->env_id, fdnum);
  801915:	a1 20 54 80 00       	mov    0x805420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80191a:	8b 40 48             	mov    0x48(%eax),%eax
  80191d:	83 ec 04             	sub    $0x4,%esp
  801920:	53                   	push   %ebx
  801921:	50                   	push   %eax
  801922:	68 54 2f 80 00       	push   $0x802f54
  801927:	e8 9f eb ff ff       	call   8004cb <cprintf>
		return -E_INVAL;
  80192c:	83 c4 10             	add    $0x10,%esp
  80192f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801934:	eb da                	jmp    801910 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801936:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80193b:	eb d3                	jmp    801910 <ftruncate+0x52>

0080193d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
  801940:	53                   	push   %ebx
  801941:	83 ec 1c             	sub    $0x1c,%esp
  801944:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801947:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80194a:	50                   	push   %eax
  80194b:	ff 75 08             	pushl  0x8(%ebp)
  80194e:	e8 84 fb ff ff       	call   8014d7 <fd_lookup>
  801953:	83 c4 10             	add    $0x10,%esp
  801956:	85 c0                	test   %eax,%eax
  801958:	78 4b                	js     8019a5 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80195a:	83 ec 08             	sub    $0x8,%esp
  80195d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801960:	50                   	push   %eax
  801961:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801964:	ff 30                	pushl  (%eax)
  801966:	e8 bc fb ff ff       	call   801527 <dev_lookup>
  80196b:	83 c4 10             	add    $0x10,%esp
  80196e:	85 c0                	test   %eax,%eax
  801970:	78 33                	js     8019a5 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801972:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801975:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801979:	74 2f                	je     8019aa <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80197b:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80197e:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801985:	00 00 00 
	stat->st_isdir = 0;
  801988:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80198f:	00 00 00 
	stat->st_dev = dev;
  801992:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801998:	83 ec 08             	sub    $0x8,%esp
  80199b:	53                   	push   %ebx
  80199c:	ff 75 f0             	pushl  -0x10(%ebp)
  80199f:	ff 50 14             	call   *0x14(%eax)
  8019a2:	83 c4 10             	add    $0x10,%esp
}
  8019a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    
		return -E_NOT_SUPP;
  8019aa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019af:	eb f4                	jmp    8019a5 <fstat+0x68>

008019b1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
  8019b4:	56                   	push   %esi
  8019b5:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8019b6:	83 ec 08             	sub    $0x8,%esp
  8019b9:	6a 00                	push   $0x0
  8019bb:	ff 75 08             	pushl  0x8(%ebp)
  8019be:	e8 22 02 00 00       	call   801be5 <open>
  8019c3:	89 c3                	mov    %eax,%ebx
  8019c5:	83 c4 10             	add    $0x10,%esp
  8019c8:	85 c0                	test   %eax,%eax
  8019ca:	78 1b                	js     8019e7 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8019cc:	83 ec 08             	sub    $0x8,%esp
  8019cf:	ff 75 0c             	pushl  0xc(%ebp)
  8019d2:	50                   	push   %eax
  8019d3:	e8 65 ff ff ff       	call   80193d <fstat>
  8019d8:	89 c6                	mov    %eax,%esi
	close(fd);
  8019da:	89 1c 24             	mov    %ebx,(%esp)
  8019dd:	e8 27 fc ff ff       	call   801609 <close>
	return r;
  8019e2:	83 c4 10             	add    $0x10,%esp
  8019e5:	89 f3                	mov    %esi,%ebx
}
  8019e7:	89 d8                	mov    %ebx,%eax
  8019e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ec:	5b                   	pop    %ebx
  8019ed:	5e                   	pop    %esi
  8019ee:	5d                   	pop    %ebp
  8019ef:	c3                   	ret    

008019f0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
  8019f3:	56                   	push   %esi
  8019f4:	53                   	push   %ebx
  8019f5:	89 c6                	mov    %eax,%esi
  8019f7:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8019f9:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801a00:	74 27                	je     801a29 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a02:	6a 07                	push   $0x7
  801a04:	68 00 60 80 00       	push   $0x806000
  801a09:	56                   	push   %esi
  801a0a:	ff 35 00 50 80 00    	pushl  0x805000
  801a10:	e8 1c 0d 00 00       	call   802731 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a15:	83 c4 0c             	add    $0xc,%esp
  801a18:	6a 00                	push   $0x0
  801a1a:	53                   	push   %ebx
  801a1b:	6a 00                	push   $0x0
  801a1d:	e8 a6 0c 00 00       	call   8026c8 <ipc_recv>
}
  801a22:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a25:	5b                   	pop    %ebx
  801a26:	5e                   	pop    %esi
  801a27:	5d                   	pop    %ebp
  801a28:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a29:	83 ec 0c             	sub    $0xc,%esp
  801a2c:	6a 01                	push   $0x1
  801a2e:	e8 56 0d 00 00       	call   802789 <ipc_find_env>
  801a33:	a3 00 50 80 00       	mov    %eax,0x805000
  801a38:	83 c4 10             	add    $0x10,%esp
  801a3b:	eb c5                	jmp    801a02 <fsipc+0x12>

00801a3d <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
  801a40:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a43:	8b 45 08             	mov    0x8(%ebp),%eax
  801a46:	8b 40 0c             	mov    0xc(%eax),%eax
  801a49:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801a4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a51:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a56:	ba 00 00 00 00       	mov    $0x0,%edx
  801a5b:	b8 02 00 00 00       	mov    $0x2,%eax
  801a60:	e8 8b ff ff ff       	call   8019f0 <fsipc>
}
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    

00801a67 <devfile_flush>:
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
  801a6a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a70:	8b 40 0c             	mov    0xc(%eax),%eax
  801a73:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801a78:	ba 00 00 00 00       	mov    $0x0,%edx
  801a7d:	b8 06 00 00 00       	mov    $0x6,%eax
  801a82:	e8 69 ff ff ff       	call   8019f0 <fsipc>
}
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <devfile_stat>:
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
  801a8c:	53                   	push   %ebx
  801a8d:	83 ec 04             	sub    $0x4,%esp
  801a90:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a93:	8b 45 08             	mov    0x8(%ebp),%eax
  801a96:	8b 40 0c             	mov    0xc(%eax),%eax
  801a99:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a9e:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa3:	b8 05 00 00 00       	mov    $0x5,%eax
  801aa8:	e8 43 ff ff ff       	call   8019f0 <fsipc>
  801aad:	85 c0                	test   %eax,%eax
  801aaf:	78 2c                	js     801add <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801ab1:	83 ec 08             	sub    $0x8,%esp
  801ab4:	68 00 60 80 00       	push   $0x806000
  801ab9:	53                   	push   %ebx
  801aba:	e8 6b f1 ff ff       	call   800c2a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801abf:	a1 80 60 80 00       	mov    0x806080,%eax
  801ac4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801aca:	a1 84 60 80 00       	mov    0x806084,%eax
  801acf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801ad5:	83 c4 10             	add    $0x10,%esp
  801ad8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801add:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    

00801ae2 <devfile_write>:
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
  801ae5:	53                   	push   %ebx
  801ae6:	83 ec 08             	sub    $0x8,%esp
  801ae9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801aec:	8b 45 08             	mov    0x8(%ebp),%eax
  801aef:	8b 40 0c             	mov    0xc(%eax),%eax
  801af2:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801af7:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801afd:	53                   	push   %ebx
  801afe:	ff 75 0c             	pushl  0xc(%ebp)
  801b01:	68 08 60 80 00       	push   $0x806008
  801b06:	e8 0f f3 ff ff       	call   800e1a <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801b0b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b10:	b8 04 00 00 00       	mov    $0x4,%eax
  801b15:	e8 d6 fe ff ff       	call   8019f0 <fsipc>
  801b1a:	83 c4 10             	add    $0x10,%esp
  801b1d:	85 c0                	test   %eax,%eax
  801b1f:	78 0b                	js     801b2c <devfile_write+0x4a>
	assert(r <= n);
  801b21:	39 d8                	cmp    %ebx,%eax
  801b23:	77 0c                	ja     801b31 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801b25:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b2a:	7f 1e                	jg     801b4a <devfile_write+0x68>
}
  801b2c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    
	assert(r <= n);
  801b31:	68 c8 2f 80 00       	push   $0x802fc8
  801b36:	68 cf 2f 80 00       	push   $0x802fcf
  801b3b:	68 98 00 00 00       	push   $0x98
  801b40:	68 e4 2f 80 00       	push   $0x802fe4
  801b45:	e8 8b e8 ff ff       	call   8003d5 <_panic>
	assert(r <= PGSIZE);
  801b4a:	68 ef 2f 80 00       	push   $0x802fef
  801b4f:	68 cf 2f 80 00       	push   $0x802fcf
  801b54:	68 99 00 00 00       	push   $0x99
  801b59:	68 e4 2f 80 00       	push   $0x802fe4
  801b5e:	e8 72 e8 ff ff       	call   8003d5 <_panic>

00801b63 <devfile_read>:
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
  801b66:	56                   	push   %esi
  801b67:	53                   	push   %ebx
  801b68:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6e:	8b 40 0c             	mov    0xc(%eax),%eax
  801b71:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801b76:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b7c:	ba 00 00 00 00       	mov    $0x0,%edx
  801b81:	b8 03 00 00 00       	mov    $0x3,%eax
  801b86:	e8 65 fe ff ff       	call   8019f0 <fsipc>
  801b8b:	89 c3                	mov    %eax,%ebx
  801b8d:	85 c0                	test   %eax,%eax
  801b8f:	78 1f                	js     801bb0 <devfile_read+0x4d>
	assert(r <= n);
  801b91:	39 f0                	cmp    %esi,%eax
  801b93:	77 24                	ja     801bb9 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801b95:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b9a:	7f 33                	jg     801bcf <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b9c:	83 ec 04             	sub    $0x4,%esp
  801b9f:	50                   	push   %eax
  801ba0:	68 00 60 80 00       	push   $0x806000
  801ba5:	ff 75 0c             	pushl  0xc(%ebp)
  801ba8:	e8 0b f2 ff ff       	call   800db8 <memmove>
	return r;
  801bad:	83 c4 10             	add    $0x10,%esp
}
  801bb0:	89 d8                	mov    %ebx,%eax
  801bb2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bb5:	5b                   	pop    %ebx
  801bb6:	5e                   	pop    %esi
  801bb7:	5d                   	pop    %ebp
  801bb8:	c3                   	ret    
	assert(r <= n);
  801bb9:	68 c8 2f 80 00       	push   $0x802fc8
  801bbe:	68 cf 2f 80 00       	push   $0x802fcf
  801bc3:	6a 7c                	push   $0x7c
  801bc5:	68 e4 2f 80 00       	push   $0x802fe4
  801bca:	e8 06 e8 ff ff       	call   8003d5 <_panic>
	assert(r <= PGSIZE);
  801bcf:	68 ef 2f 80 00       	push   $0x802fef
  801bd4:	68 cf 2f 80 00       	push   $0x802fcf
  801bd9:	6a 7d                	push   $0x7d
  801bdb:	68 e4 2f 80 00       	push   $0x802fe4
  801be0:	e8 f0 e7 ff ff       	call   8003d5 <_panic>

00801be5 <open>:
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
  801be8:	56                   	push   %esi
  801be9:	53                   	push   %ebx
  801bea:	83 ec 1c             	sub    $0x1c,%esp
  801bed:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801bf0:	56                   	push   %esi
  801bf1:	e8 fb ef ff ff       	call   800bf1 <strlen>
  801bf6:	83 c4 10             	add    $0x10,%esp
  801bf9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801bfe:	7f 6c                	jg     801c6c <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801c00:	83 ec 0c             	sub    $0xc,%esp
  801c03:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c06:	50                   	push   %eax
  801c07:	e8 79 f8 ff ff       	call   801485 <fd_alloc>
  801c0c:	89 c3                	mov    %eax,%ebx
  801c0e:	83 c4 10             	add    $0x10,%esp
  801c11:	85 c0                	test   %eax,%eax
  801c13:	78 3c                	js     801c51 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801c15:	83 ec 08             	sub    $0x8,%esp
  801c18:	56                   	push   %esi
  801c19:	68 00 60 80 00       	push   $0x806000
  801c1e:	e8 07 f0 ff ff       	call   800c2a <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c23:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c26:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c2e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c33:	e8 b8 fd ff ff       	call   8019f0 <fsipc>
  801c38:	89 c3                	mov    %eax,%ebx
  801c3a:	83 c4 10             	add    $0x10,%esp
  801c3d:	85 c0                	test   %eax,%eax
  801c3f:	78 19                	js     801c5a <open+0x75>
	return fd2num(fd);
  801c41:	83 ec 0c             	sub    $0xc,%esp
  801c44:	ff 75 f4             	pushl  -0xc(%ebp)
  801c47:	e8 12 f8 ff ff       	call   80145e <fd2num>
  801c4c:	89 c3                	mov    %eax,%ebx
  801c4e:	83 c4 10             	add    $0x10,%esp
}
  801c51:	89 d8                	mov    %ebx,%eax
  801c53:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c56:	5b                   	pop    %ebx
  801c57:	5e                   	pop    %esi
  801c58:	5d                   	pop    %ebp
  801c59:	c3                   	ret    
		fd_close(fd, 0);
  801c5a:	83 ec 08             	sub    $0x8,%esp
  801c5d:	6a 00                	push   $0x0
  801c5f:	ff 75 f4             	pushl  -0xc(%ebp)
  801c62:	e8 1b f9 ff ff       	call   801582 <fd_close>
		return r;
  801c67:	83 c4 10             	add    $0x10,%esp
  801c6a:	eb e5                	jmp    801c51 <open+0x6c>
		return -E_BAD_PATH;
  801c6c:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801c71:	eb de                	jmp    801c51 <open+0x6c>

00801c73 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
  801c76:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c79:	ba 00 00 00 00       	mov    $0x0,%edx
  801c7e:	b8 08 00 00 00       	mov    $0x8,%eax
  801c83:	e8 68 fd ff ff       	call   8019f0 <fsipc>
}
  801c88:	c9                   	leave  
  801c89:	c3                   	ret    

00801c8a <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801c8a:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801c8e:	7f 01                	jg     801c91 <writebuf+0x7>
  801c90:	c3                   	ret    
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
  801c94:	53                   	push   %ebx
  801c95:	83 ec 08             	sub    $0x8,%esp
  801c98:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801c9a:	ff 70 04             	pushl  0x4(%eax)
  801c9d:	8d 40 10             	lea    0x10(%eax),%eax
  801ca0:	50                   	push   %eax
  801ca1:	ff 33                	pushl  (%ebx)
  801ca3:	e8 6b fb ff ff       	call   801813 <write>
		if (result > 0)
  801ca8:	83 c4 10             	add    $0x10,%esp
  801cab:	85 c0                	test   %eax,%eax
  801cad:	7e 03                	jle    801cb2 <writebuf+0x28>
			b->result += result;
  801caf:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801cb2:	39 43 04             	cmp    %eax,0x4(%ebx)
  801cb5:	74 0d                	je     801cc4 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801cb7:	85 c0                	test   %eax,%eax
  801cb9:	ba 00 00 00 00       	mov    $0x0,%edx
  801cbe:	0f 4f c2             	cmovg  %edx,%eax
  801cc1:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801cc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cc7:	c9                   	leave  
  801cc8:	c3                   	ret    

00801cc9 <putch>:

static void
putch(int ch, void *thunk)
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
  801ccc:	53                   	push   %ebx
  801ccd:	83 ec 04             	sub    $0x4,%esp
  801cd0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801cd3:	8b 53 04             	mov    0x4(%ebx),%edx
  801cd6:	8d 42 01             	lea    0x1(%edx),%eax
  801cd9:	89 43 04             	mov    %eax,0x4(%ebx)
  801cdc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cdf:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801ce3:	3d 00 01 00 00       	cmp    $0x100,%eax
  801ce8:	74 06                	je     801cf0 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801cea:	83 c4 04             	add    $0x4,%esp
  801ced:	5b                   	pop    %ebx
  801cee:	5d                   	pop    %ebp
  801cef:	c3                   	ret    
		writebuf(b);
  801cf0:	89 d8                	mov    %ebx,%eax
  801cf2:	e8 93 ff ff ff       	call   801c8a <writebuf>
		b->idx = 0;
  801cf7:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801cfe:	eb ea                	jmp    801cea <putch+0x21>

00801d00 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
  801d03:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801d09:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0c:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801d12:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801d19:	00 00 00 
	b.result = 0;
  801d1c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801d23:	00 00 00 
	b.error = 1;
  801d26:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801d2d:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801d30:	ff 75 10             	pushl  0x10(%ebp)
  801d33:	ff 75 0c             	pushl  0xc(%ebp)
  801d36:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801d3c:	50                   	push   %eax
  801d3d:	68 c9 1c 80 00       	push   $0x801cc9
  801d42:	e8 b1 e8 ff ff       	call   8005f8 <vprintfmt>
	if (b.idx > 0)
  801d47:	83 c4 10             	add    $0x10,%esp
  801d4a:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801d51:	7f 11                	jg     801d64 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801d53:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801d59:	85 c0                	test   %eax,%eax
  801d5b:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801d62:	c9                   	leave  
  801d63:	c3                   	ret    
		writebuf(&b);
  801d64:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801d6a:	e8 1b ff ff ff       	call   801c8a <writebuf>
  801d6f:	eb e2                	jmp    801d53 <vfprintf+0x53>

00801d71 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
  801d74:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801d77:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801d7a:	50                   	push   %eax
  801d7b:	ff 75 0c             	pushl  0xc(%ebp)
  801d7e:	ff 75 08             	pushl  0x8(%ebp)
  801d81:	e8 7a ff ff ff       	call   801d00 <vfprintf>
	va_end(ap);

	return cnt;
}
  801d86:	c9                   	leave  
  801d87:	c3                   	ret    

00801d88 <printf>:

int
printf(const char *fmt, ...)
{
  801d88:	55                   	push   %ebp
  801d89:	89 e5                	mov    %esp,%ebp
  801d8b:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801d8e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801d91:	50                   	push   %eax
  801d92:	ff 75 08             	pushl  0x8(%ebp)
  801d95:	6a 01                	push   $0x1
  801d97:	e8 64 ff ff ff       	call   801d00 <vfprintf>
	va_end(ap);

	return cnt;
}
  801d9c:	c9                   	leave  
  801d9d:	c3                   	ret    

00801d9e <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
  801da1:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801da4:	68 fb 2f 80 00       	push   $0x802ffb
  801da9:	ff 75 0c             	pushl  0xc(%ebp)
  801dac:	e8 79 ee ff ff       	call   800c2a <strcpy>
	return 0;
}
  801db1:	b8 00 00 00 00       	mov    $0x0,%eax
  801db6:	c9                   	leave  
  801db7:	c3                   	ret    

00801db8 <devsock_close>:
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
  801dbb:	53                   	push   %ebx
  801dbc:	83 ec 10             	sub    $0x10,%esp
  801dbf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801dc2:	53                   	push   %ebx
  801dc3:	e8 00 0a 00 00       	call   8027c8 <pageref>
  801dc8:	83 c4 10             	add    $0x10,%esp
		return 0;
  801dcb:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801dd0:	83 f8 01             	cmp    $0x1,%eax
  801dd3:	74 07                	je     801ddc <devsock_close+0x24>
}
  801dd5:	89 d0                	mov    %edx,%eax
  801dd7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801ddc:	83 ec 0c             	sub    $0xc,%esp
  801ddf:	ff 73 0c             	pushl  0xc(%ebx)
  801de2:	e8 b9 02 00 00       	call   8020a0 <nsipc_close>
  801de7:	89 c2                	mov    %eax,%edx
  801de9:	83 c4 10             	add    $0x10,%esp
  801dec:	eb e7                	jmp    801dd5 <devsock_close+0x1d>

00801dee <devsock_write>:
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
  801df1:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801df4:	6a 00                	push   $0x0
  801df6:	ff 75 10             	pushl  0x10(%ebp)
  801df9:	ff 75 0c             	pushl  0xc(%ebp)
  801dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dff:	ff 70 0c             	pushl  0xc(%eax)
  801e02:	e8 76 03 00 00       	call   80217d <nsipc_send>
}
  801e07:	c9                   	leave  
  801e08:	c3                   	ret    

00801e09 <devsock_read>:
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
  801e0c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e0f:	6a 00                	push   $0x0
  801e11:	ff 75 10             	pushl  0x10(%ebp)
  801e14:	ff 75 0c             	pushl  0xc(%ebp)
  801e17:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1a:	ff 70 0c             	pushl  0xc(%eax)
  801e1d:	e8 ef 02 00 00       	call   802111 <nsipc_recv>
}
  801e22:	c9                   	leave  
  801e23:	c3                   	ret    

00801e24 <fd2sockid>:
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
  801e27:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801e2a:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e2d:	52                   	push   %edx
  801e2e:	50                   	push   %eax
  801e2f:	e8 a3 f6 ff ff       	call   8014d7 <fd_lookup>
  801e34:	83 c4 10             	add    $0x10,%esp
  801e37:	85 c0                	test   %eax,%eax
  801e39:	78 10                	js     801e4b <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3e:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801e44:	39 08                	cmp    %ecx,(%eax)
  801e46:	75 05                	jne    801e4d <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801e48:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    
		return -E_NOT_SUPP;
  801e4d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e52:	eb f7                	jmp    801e4b <fd2sockid+0x27>

00801e54 <alloc_sockfd>:
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
  801e57:	56                   	push   %esi
  801e58:	53                   	push   %ebx
  801e59:	83 ec 1c             	sub    $0x1c,%esp
  801e5c:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801e5e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e61:	50                   	push   %eax
  801e62:	e8 1e f6 ff ff       	call   801485 <fd_alloc>
  801e67:	89 c3                	mov    %eax,%ebx
  801e69:	83 c4 10             	add    $0x10,%esp
  801e6c:	85 c0                	test   %eax,%eax
  801e6e:	78 43                	js     801eb3 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801e70:	83 ec 04             	sub    $0x4,%esp
  801e73:	68 07 04 00 00       	push   $0x407
  801e78:	ff 75 f4             	pushl  -0xc(%ebp)
  801e7b:	6a 00                	push   $0x0
  801e7d:	e8 9a f1 ff ff       	call   80101c <sys_page_alloc>
  801e82:	89 c3                	mov    %eax,%ebx
  801e84:	83 c4 10             	add    $0x10,%esp
  801e87:	85 c0                	test   %eax,%eax
  801e89:	78 28                	js     801eb3 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8e:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801e94:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e99:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801ea0:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801ea3:	83 ec 0c             	sub    $0xc,%esp
  801ea6:	50                   	push   %eax
  801ea7:	e8 b2 f5 ff ff       	call   80145e <fd2num>
  801eac:	89 c3                	mov    %eax,%ebx
  801eae:	83 c4 10             	add    $0x10,%esp
  801eb1:	eb 0c                	jmp    801ebf <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801eb3:	83 ec 0c             	sub    $0xc,%esp
  801eb6:	56                   	push   %esi
  801eb7:	e8 e4 01 00 00       	call   8020a0 <nsipc_close>
		return r;
  801ebc:	83 c4 10             	add    $0x10,%esp
}
  801ebf:	89 d8                	mov    %ebx,%eax
  801ec1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ec4:	5b                   	pop    %ebx
  801ec5:	5e                   	pop    %esi
  801ec6:	5d                   	pop    %ebp
  801ec7:	c3                   	ret    

00801ec8 <accept>:
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
  801ecb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ece:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed1:	e8 4e ff ff ff       	call   801e24 <fd2sockid>
  801ed6:	85 c0                	test   %eax,%eax
  801ed8:	78 1b                	js     801ef5 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801eda:	83 ec 04             	sub    $0x4,%esp
  801edd:	ff 75 10             	pushl  0x10(%ebp)
  801ee0:	ff 75 0c             	pushl  0xc(%ebp)
  801ee3:	50                   	push   %eax
  801ee4:	e8 0e 01 00 00       	call   801ff7 <nsipc_accept>
  801ee9:	83 c4 10             	add    $0x10,%esp
  801eec:	85 c0                	test   %eax,%eax
  801eee:	78 05                	js     801ef5 <accept+0x2d>
	return alloc_sockfd(r);
  801ef0:	e8 5f ff ff ff       	call   801e54 <alloc_sockfd>
}
  801ef5:	c9                   	leave  
  801ef6:	c3                   	ret    

00801ef7 <bind>:
{
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
  801efa:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801efd:	8b 45 08             	mov    0x8(%ebp),%eax
  801f00:	e8 1f ff ff ff       	call   801e24 <fd2sockid>
  801f05:	85 c0                	test   %eax,%eax
  801f07:	78 12                	js     801f1b <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801f09:	83 ec 04             	sub    $0x4,%esp
  801f0c:	ff 75 10             	pushl  0x10(%ebp)
  801f0f:	ff 75 0c             	pushl  0xc(%ebp)
  801f12:	50                   	push   %eax
  801f13:	e8 31 01 00 00       	call   802049 <nsipc_bind>
  801f18:	83 c4 10             	add    $0x10,%esp
}
  801f1b:	c9                   	leave  
  801f1c:	c3                   	ret    

00801f1d <shutdown>:
{
  801f1d:	55                   	push   %ebp
  801f1e:	89 e5                	mov    %esp,%ebp
  801f20:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f23:	8b 45 08             	mov    0x8(%ebp),%eax
  801f26:	e8 f9 fe ff ff       	call   801e24 <fd2sockid>
  801f2b:	85 c0                	test   %eax,%eax
  801f2d:	78 0f                	js     801f3e <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801f2f:	83 ec 08             	sub    $0x8,%esp
  801f32:	ff 75 0c             	pushl  0xc(%ebp)
  801f35:	50                   	push   %eax
  801f36:	e8 43 01 00 00       	call   80207e <nsipc_shutdown>
  801f3b:	83 c4 10             	add    $0x10,%esp
}
  801f3e:	c9                   	leave  
  801f3f:	c3                   	ret    

00801f40 <connect>:
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
  801f43:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f46:	8b 45 08             	mov    0x8(%ebp),%eax
  801f49:	e8 d6 fe ff ff       	call   801e24 <fd2sockid>
  801f4e:	85 c0                	test   %eax,%eax
  801f50:	78 12                	js     801f64 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801f52:	83 ec 04             	sub    $0x4,%esp
  801f55:	ff 75 10             	pushl  0x10(%ebp)
  801f58:	ff 75 0c             	pushl  0xc(%ebp)
  801f5b:	50                   	push   %eax
  801f5c:	e8 59 01 00 00       	call   8020ba <nsipc_connect>
  801f61:	83 c4 10             	add    $0x10,%esp
}
  801f64:	c9                   	leave  
  801f65:	c3                   	ret    

00801f66 <listen>:
{
  801f66:	55                   	push   %ebp
  801f67:	89 e5                	mov    %esp,%ebp
  801f69:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6f:	e8 b0 fe ff ff       	call   801e24 <fd2sockid>
  801f74:	85 c0                	test   %eax,%eax
  801f76:	78 0f                	js     801f87 <listen+0x21>
	return nsipc_listen(r, backlog);
  801f78:	83 ec 08             	sub    $0x8,%esp
  801f7b:	ff 75 0c             	pushl  0xc(%ebp)
  801f7e:	50                   	push   %eax
  801f7f:	e8 6b 01 00 00       	call   8020ef <nsipc_listen>
  801f84:	83 c4 10             	add    $0x10,%esp
}
  801f87:	c9                   	leave  
  801f88:	c3                   	ret    

00801f89 <socket>:

int
socket(int domain, int type, int protocol)
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
  801f8c:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f8f:	ff 75 10             	pushl  0x10(%ebp)
  801f92:	ff 75 0c             	pushl  0xc(%ebp)
  801f95:	ff 75 08             	pushl  0x8(%ebp)
  801f98:	e8 3e 02 00 00       	call   8021db <nsipc_socket>
  801f9d:	83 c4 10             	add    $0x10,%esp
  801fa0:	85 c0                	test   %eax,%eax
  801fa2:	78 05                	js     801fa9 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801fa4:	e8 ab fe ff ff       	call   801e54 <alloc_sockfd>
}
  801fa9:	c9                   	leave  
  801faa:	c3                   	ret    

00801fab <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801fab:	55                   	push   %ebp
  801fac:	89 e5                	mov    %esp,%ebp
  801fae:	53                   	push   %ebx
  801faf:	83 ec 04             	sub    $0x4,%esp
  801fb2:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801fb4:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801fbb:	74 26                	je     801fe3 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801fbd:	6a 07                	push   $0x7
  801fbf:	68 00 70 80 00       	push   $0x807000
  801fc4:	53                   	push   %ebx
  801fc5:	ff 35 04 50 80 00    	pushl  0x805004
  801fcb:	e8 61 07 00 00       	call   802731 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801fd0:	83 c4 0c             	add    $0xc,%esp
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 00                	push   $0x0
  801fd9:	e8 ea 06 00 00       	call   8026c8 <ipc_recv>
}
  801fde:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fe1:	c9                   	leave  
  801fe2:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801fe3:	83 ec 0c             	sub    $0xc,%esp
  801fe6:	6a 02                	push   $0x2
  801fe8:	e8 9c 07 00 00       	call   802789 <ipc_find_env>
  801fed:	a3 04 50 80 00       	mov    %eax,0x805004
  801ff2:	83 c4 10             	add    $0x10,%esp
  801ff5:	eb c6                	jmp    801fbd <nsipc+0x12>

00801ff7 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
  801ffa:	56                   	push   %esi
  801ffb:	53                   	push   %ebx
  801ffc:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801fff:	8b 45 08             	mov    0x8(%ebp),%eax
  802002:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802007:	8b 06                	mov    (%esi),%eax
  802009:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80200e:	b8 01 00 00 00       	mov    $0x1,%eax
  802013:	e8 93 ff ff ff       	call   801fab <nsipc>
  802018:	89 c3                	mov    %eax,%ebx
  80201a:	85 c0                	test   %eax,%eax
  80201c:	79 09                	jns    802027 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80201e:	89 d8                	mov    %ebx,%eax
  802020:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802023:	5b                   	pop    %ebx
  802024:	5e                   	pop    %esi
  802025:	5d                   	pop    %ebp
  802026:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802027:	83 ec 04             	sub    $0x4,%esp
  80202a:	ff 35 10 70 80 00    	pushl  0x807010
  802030:	68 00 70 80 00       	push   $0x807000
  802035:	ff 75 0c             	pushl  0xc(%ebp)
  802038:	e8 7b ed ff ff       	call   800db8 <memmove>
		*addrlen = ret->ret_addrlen;
  80203d:	a1 10 70 80 00       	mov    0x807010,%eax
  802042:	89 06                	mov    %eax,(%esi)
  802044:	83 c4 10             	add    $0x10,%esp
	return r;
  802047:	eb d5                	jmp    80201e <nsipc_accept+0x27>

00802049 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802049:	55                   	push   %ebp
  80204a:	89 e5                	mov    %esp,%ebp
  80204c:	53                   	push   %ebx
  80204d:	83 ec 08             	sub    $0x8,%esp
  802050:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802053:	8b 45 08             	mov    0x8(%ebp),%eax
  802056:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80205b:	53                   	push   %ebx
  80205c:	ff 75 0c             	pushl  0xc(%ebp)
  80205f:	68 04 70 80 00       	push   $0x807004
  802064:	e8 4f ed ff ff       	call   800db8 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802069:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80206f:	b8 02 00 00 00       	mov    $0x2,%eax
  802074:	e8 32 ff ff ff       	call   801fab <nsipc>
}
  802079:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80207c:	c9                   	leave  
  80207d:	c3                   	ret    

0080207e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80207e:	55                   	push   %ebp
  80207f:	89 e5                	mov    %esp,%ebp
  802081:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802084:	8b 45 08             	mov    0x8(%ebp),%eax
  802087:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80208c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80208f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802094:	b8 03 00 00 00       	mov    $0x3,%eax
  802099:	e8 0d ff ff ff       	call   801fab <nsipc>
}
  80209e:	c9                   	leave  
  80209f:	c3                   	ret    

008020a0 <nsipc_close>:

int
nsipc_close(int s)
{
  8020a0:	55                   	push   %ebp
  8020a1:	89 e5                	mov    %esp,%ebp
  8020a3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8020a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8020ae:	b8 04 00 00 00       	mov    $0x4,%eax
  8020b3:	e8 f3 fe ff ff       	call   801fab <nsipc>
}
  8020b8:	c9                   	leave  
  8020b9:	c3                   	ret    

008020ba <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020ba:	55                   	push   %ebp
  8020bb:	89 e5                	mov    %esp,%ebp
  8020bd:	53                   	push   %ebx
  8020be:	83 ec 08             	sub    $0x8,%esp
  8020c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8020c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8020cc:	53                   	push   %ebx
  8020cd:	ff 75 0c             	pushl  0xc(%ebp)
  8020d0:	68 04 70 80 00       	push   $0x807004
  8020d5:	e8 de ec ff ff       	call   800db8 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8020da:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8020e0:	b8 05 00 00 00       	mov    $0x5,%eax
  8020e5:	e8 c1 fe ff ff       	call   801fab <nsipc>
}
  8020ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020ed:	c9                   	leave  
  8020ee:	c3                   	ret    

008020ef <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8020ef:	55                   	push   %ebp
  8020f0:	89 e5                	mov    %esp,%ebp
  8020f2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8020f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f8:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8020fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802100:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802105:	b8 06 00 00 00       	mov    $0x6,%eax
  80210a:	e8 9c fe ff ff       	call   801fab <nsipc>
}
  80210f:	c9                   	leave  
  802110:	c3                   	ret    

00802111 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
  802114:	56                   	push   %esi
  802115:	53                   	push   %ebx
  802116:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802119:	8b 45 08             	mov    0x8(%ebp),%eax
  80211c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802121:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802127:	8b 45 14             	mov    0x14(%ebp),%eax
  80212a:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80212f:	b8 07 00 00 00       	mov    $0x7,%eax
  802134:	e8 72 fe ff ff       	call   801fab <nsipc>
  802139:	89 c3                	mov    %eax,%ebx
  80213b:	85 c0                	test   %eax,%eax
  80213d:	78 1f                	js     80215e <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80213f:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802144:	7f 21                	jg     802167 <nsipc_recv+0x56>
  802146:	39 c6                	cmp    %eax,%esi
  802148:	7c 1d                	jl     802167 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80214a:	83 ec 04             	sub    $0x4,%esp
  80214d:	50                   	push   %eax
  80214e:	68 00 70 80 00       	push   $0x807000
  802153:	ff 75 0c             	pushl  0xc(%ebp)
  802156:	e8 5d ec ff ff       	call   800db8 <memmove>
  80215b:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80215e:	89 d8                	mov    %ebx,%eax
  802160:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802163:	5b                   	pop    %ebx
  802164:	5e                   	pop    %esi
  802165:	5d                   	pop    %ebp
  802166:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802167:	68 07 30 80 00       	push   $0x803007
  80216c:	68 cf 2f 80 00       	push   $0x802fcf
  802171:	6a 62                	push   $0x62
  802173:	68 1c 30 80 00       	push   $0x80301c
  802178:	e8 58 e2 ff ff       	call   8003d5 <_panic>

0080217d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80217d:	55                   	push   %ebp
  80217e:	89 e5                	mov    %esp,%ebp
  802180:	53                   	push   %ebx
  802181:	83 ec 04             	sub    $0x4,%esp
  802184:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802187:	8b 45 08             	mov    0x8(%ebp),%eax
  80218a:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80218f:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802195:	7f 2e                	jg     8021c5 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802197:	83 ec 04             	sub    $0x4,%esp
  80219a:	53                   	push   %ebx
  80219b:	ff 75 0c             	pushl  0xc(%ebp)
  80219e:	68 0c 70 80 00       	push   $0x80700c
  8021a3:	e8 10 ec ff ff       	call   800db8 <memmove>
	nsipcbuf.send.req_size = size;
  8021a8:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8021ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8021b1:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8021b6:	b8 08 00 00 00       	mov    $0x8,%eax
  8021bb:	e8 eb fd ff ff       	call   801fab <nsipc>
}
  8021c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021c3:	c9                   	leave  
  8021c4:	c3                   	ret    
	assert(size < 1600);
  8021c5:	68 28 30 80 00       	push   $0x803028
  8021ca:	68 cf 2f 80 00       	push   $0x802fcf
  8021cf:	6a 6d                	push   $0x6d
  8021d1:	68 1c 30 80 00       	push   $0x80301c
  8021d6:	e8 fa e1 ff ff       	call   8003d5 <_panic>

008021db <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8021db:	55                   	push   %ebp
  8021dc:	89 e5                	mov    %esp,%ebp
  8021de:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8021e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e4:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8021e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ec:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8021f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8021f4:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8021f9:	b8 09 00 00 00       	mov    $0x9,%eax
  8021fe:	e8 a8 fd ff ff       	call   801fab <nsipc>
}
  802203:	c9                   	leave  
  802204:	c3                   	ret    

00802205 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
  802208:	56                   	push   %esi
  802209:	53                   	push   %ebx
  80220a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80220d:	83 ec 0c             	sub    $0xc,%esp
  802210:	ff 75 08             	pushl  0x8(%ebp)
  802213:	e8 56 f2 ff ff       	call   80146e <fd2data>
  802218:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80221a:	83 c4 08             	add    $0x8,%esp
  80221d:	68 34 30 80 00       	push   $0x803034
  802222:	53                   	push   %ebx
  802223:	e8 02 ea ff ff       	call   800c2a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802228:	8b 46 04             	mov    0x4(%esi),%eax
  80222b:	2b 06                	sub    (%esi),%eax
  80222d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802233:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80223a:	00 00 00 
	stat->st_dev = &devpipe;
  80223d:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802244:	40 80 00 
	return 0;
}
  802247:	b8 00 00 00 00       	mov    $0x0,%eax
  80224c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80224f:	5b                   	pop    %ebx
  802250:	5e                   	pop    %esi
  802251:	5d                   	pop    %ebp
  802252:	c3                   	ret    

00802253 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802253:	55                   	push   %ebp
  802254:	89 e5                	mov    %esp,%ebp
  802256:	53                   	push   %ebx
  802257:	83 ec 0c             	sub    $0xc,%esp
  80225a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80225d:	53                   	push   %ebx
  80225e:	6a 00                	push   $0x0
  802260:	e8 3c ee ff ff       	call   8010a1 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802265:	89 1c 24             	mov    %ebx,(%esp)
  802268:	e8 01 f2 ff ff       	call   80146e <fd2data>
  80226d:	83 c4 08             	add    $0x8,%esp
  802270:	50                   	push   %eax
  802271:	6a 00                	push   $0x0
  802273:	e8 29 ee ff ff       	call   8010a1 <sys_page_unmap>
}
  802278:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80227b:	c9                   	leave  
  80227c:	c3                   	ret    

0080227d <_pipeisclosed>:
{
  80227d:	55                   	push   %ebp
  80227e:	89 e5                	mov    %esp,%ebp
  802280:	57                   	push   %edi
  802281:	56                   	push   %esi
  802282:	53                   	push   %ebx
  802283:	83 ec 1c             	sub    $0x1c,%esp
  802286:	89 c7                	mov    %eax,%edi
  802288:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80228a:	a1 20 54 80 00       	mov    0x805420,%eax
  80228f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802292:	83 ec 0c             	sub    $0xc,%esp
  802295:	57                   	push   %edi
  802296:	e8 2d 05 00 00       	call   8027c8 <pageref>
  80229b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80229e:	89 34 24             	mov    %esi,(%esp)
  8022a1:	e8 22 05 00 00       	call   8027c8 <pageref>
		nn = thisenv->env_runs;
  8022a6:	8b 15 20 54 80 00    	mov    0x805420,%edx
  8022ac:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8022af:	83 c4 10             	add    $0x10,%esp
  8022b2:	39 cb                	cmp    %ecx,%ebx
  8022b4:	74 1b                	je     8022d1 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8022b6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8022b9:	75 cf                	jne    80228a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8022bb:	8b 42 58             	mov    0x58(%edx),%eax
  8022be:	6a 01                	push   $0x1
  8022c0:	50                   	push   %eax
  8022c1:	53                   	push   %ebx
  8022c2:	68 3b 30 80 00       	push   $0x80303b
  8022c7:	e8 ff e1 ff ff       	call   8004cb <cprintf>
  8022cc:	83 c4 10             	add    $0x10,%esp
  8022cf:	eb b9                	jmp    80228a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8022d1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8022d4:	0f 94 c0             	sete   %al
  8022d7:	0f b6 c0             	movzbl %al,%eax
}
  8022da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022dd:	5b                   	pop    %ebx
  8022de:	5e                   	pop    %esi
  8022df:	5f                   	pop    %edi
  8022e0:	5d                   	pop    %ebp
  8022e1:	c3                   	ret    

008022e2 <devpipe_write>:
{
  8022e2:	55                   	push   %ebp
  8022e3:	89 e5                	mov    %esp,%ebp
  8022e5:	57                   	push   %edi
  8022e6:	56                   	push   %esi
  8022e7:	53                   	push   %ebx
  8022e8:	83 ec 28             	sub    $0x28,%esp
  8022eb:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8022ee:	56                   	push   %esi
  8022ef:	e8 7a f1 ff ff       	call   80146e <fd2data>
  8022f4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8022f6:	83 c4 10             	add    $0x10,%esp
  8022f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8022fe:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802301:	74 4f                	je     802352 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802303:	8b 43 04             	mov    0x4(%ebx),%eax
  802306:	8b 0b                	mov    (%ebx),%ecx
  802308:	8d 51 20             	lea    0x20(%ecx),%edx
  80230b:	39 d0                	cmp    %edx,%eax
  80230d:	72 14                	jb     802323 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80230f:	89 da                	mov    %ebx,%edx
  802311:	89 f0                	mov    %esi,%eax
  802313:	e8 65 ff ff ff       	call   80227d <_pipeisclosed>
  802318:	85 c0                	test   %eax,%eax
  80231a:	75 3b                	jne    802357 <devpipe_write+0x75>
			sys_yield();
  80231c:	e8 dc ec ff ff       	call   800ffd <sys_yield>
  802321:	eb e0                	jmp    802303 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802323:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802326:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80232a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80232d:	89 c2                	mov    %eax,%edx
  80232f:	c1 fa 1f             	sar    $0x1f,%edx
  802332:	89 d1                	mov    %edx,%ecx
  802334:	c1 e9 1b             	shr    $0x1b,%ecx
  802337:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80233a:	83 e2 1f             	and    $0x1f,%edx
  80233d:	29 ca                	sub    %ecx,%edx
  80233f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802343:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802347:	83 c0 01             	add    $0x1,%eax
  80234a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80234d:	83 c7 01             	add    $0x1,%edi
  802350:	eb ac                	jmp    8022fe <devpipe_write+0x1c>
	return i;
  802352:	8b 45 10             	mov    0x10(%ebp),%eax
  802355:	eb 05                	jmp    80235c <devpipe_write+0x7a>
				return 0;
  802357:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80235c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80235f:	5b                   	pop    %ebx
  802360:	5e                   	pop    %esi
  802361:	5f                   	pop    %edi
  802362:	5d                   	pop    %ebp
  802363:	c3                   	ret    

00802364 <devpipe_read>:
{
  802364:	55                   	push   %ebp
  802365:	89 e5                	mov    %esp,%ebp
  802367:	57                   	push   %edi
  802368:	56                   	push   %esi
  802369:	53                   	push   %ebx
  80236a:	83 ec 18             	sub    $0x18,%esp
  80236d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802370:	57                   	push   %edi
  802371:	e8 f8 f0 ff ff       	call   80146e <fd2data>
  802376:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802378:	83 c4 10             	add    $0x10,%esp
  80237b:	be 00 00 00 00       	mov    $0x0,%esi
  802380:	3b 75 10             	cmp    0x10(%ebp),%esi
  802383:	75 14                	jne    802399 <devpipe_read+0x35>
	return i;
  802385:	8b 45 10             	mov    0x10(%ebp),%eax
  802388:	eb 02                	jmp    80238c <devpipe_read+0x28>
				return i;
  80238a:	89 f0                	mov    %esi,%eax
}
  80238c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80238f:	5b                   	pop    %ebx
  802390:	5e                   	pop    %esi
  802391:	5f                   	pop    %edi
  802392:	5d                   	pop    %ebp
  802393:	c3                   	ret    
			sys_yield();
  802394:	e8 64 ec ff ff       	call   800ffd <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802399:	8b 03                	mov    (%ebx),%eax
  80239b:	3b 43 04             	cmp    0x4(%ebx),%eax
  80239e:	75 18                	jne    8023b8 <devpipe_read+0x54>
			if (i > 0)
  8023a0:	85 f6                	test   %esi,%esi
  8023a2:	75 e6                	jne    80238a <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8023a4:	89 da                	mov    %ebx,%edx
  8023a6:	89 f8                	mov    %edi,%eax
  8023a8:	e8 d0 fe ff ff       	call   80227d <_pipeisclosed>
  8023ad:	85 c0                	test   %eax,%eax
  8023af:	74 e3                	je     802394 <devpipe_read+0x30>
				return 0;
  8023b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b6:	eb d4                	jmp    80238c <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8023b8:	99                   	cltd   
  8023b9:	c1 ea 1b             	shr    $0x1b,%edx
  8023bc:	01 d0                	add    %edx,%eax
  8023be:	83 e0 1f             	and    $0x1f,%eax
  8023c1:	29 d0                	sub    %edx,%eax
  8023c3:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8023c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023cb:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8023ce:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8023d1:	83 c6 01             	add    $0x1,%esi
  8023d4:	eb aa                	jmp    802380 <devpipe_read+0x1c>

008023d6 <pipe>:
{
  8023d6:	55                   	push   %ebp
  8023d7:	89 e5                	mov    %esp,%ebp
  8023d9:	56                   	push   %esi
  8023da:	53                   	push   %ebx
  8023db:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8023de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023e1:	50                   	push   %eax
  8023e2:	e8 9e f0 ff ff       	call   801485 <fd_alloc>
  8023e7:	89 c3                	mov    %eax,%ebx
  8023e9:	83 c4 10             	add    $0x10,%esp
  8023ec:	85 c0                	test   %eax,%eax
  8023ee:	0f 88 23 01 00 00    	js     802517 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023f4:	83 ec 04             	sub    $0x4,%esp
  8023f7:	68 07 04 00 00       	push   $0x407
  8023fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8023ff:	6a 00                	push   $0x0
  802401:	e8 16 ec ff ff       	call   80101c <sys_page_alloc>
  802406:	89 c3                	mov    %eax,%ebx
  802408:	83 c4 10             	add    $0x10,%esp
  80240b:	85 c0                	test   %eax,%eax
  80240d:	0f 88 04 01 00 00    	js     802517 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802413:	83 ec 0c             	sub    $0xc,%esp
  802416:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802419:	50                   	push   %eax
  80241a:	e8 66 f0 ff ff       	call   801485 <fd_alloc>
  80241f:	89 c3                	mov    %eax,%ebx
  802421:	83 c4 10             	add    $0x10,%esp
  802424:	85 c0                	test   %eax,%eax
  802426:	0f 88 db 00 00 00    	js     802507 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80242c:	83 ec 04             	sub    $0x4,%esp
  80242f:	68 07 04 00 00       	push   $0x407
  802434:	ff 75 f0             	pushl  -0x10(%ebp)
  802437:	6a 00                	push   $0x0
  802439:	e8 de eb ff ff       	call   80101c <sys_page_alloc>
  80243e:	89 c3                	mov    %eax,%ebx
  802440:	83 c4 10             	add    $0x10,%esp
  802443:	85 c0                	test   %eax,%eax
  802445:	0f 88 bc 00 00 00    	js     802507 <pipe+0x131>
	va = fd2data(fd0);
  80244b:	83 ec 0c             	sub    $0xc,%esp
  80244e:	ff 75 f4             	pushl  -0xc(%ebp)
  802451:	e8 18 f0 ff ff       	call   80146e <fd2data>
  802456:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802458:	83 c4 0c             	add    $0xc,%esp
  80245b:	68 07 04 00 00       	push   $0x407
  802460:	50                   	push   %eax
  802461:	6a 00                	push   $0x0
  802463:	e8 b4 eb ff ff       	call   80101c <sys_page_alloc>
  802468:	89 c3                	mov    %eax,%ebx
  80246a:	83 c4 10             	add    $0x10,%esp
  80246d:	85 c0                	test   %eax,%eax
  80246f:	0f 88 82 00 00 00    	js     8024f7 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802475:	83 ec 0c             	sub    $0xc,%esp
  802478:	ff 75 f0             	pushl  -0x10(%ebp)
  80247b:	e8 ee ef ff ff       	call   80146e <fd2data>
  802480:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802487:	50                   	push   %eax
  802488:	6a 00                	push   $0x0
  80248a:	56                   	push   %esi
  80248b:	6a 00                	push   $0x0
  80248d:	e8 cd eb ff ff       	call   80105f <sys_page_map>
  802492:	89 c3                	mov    %eax,%ebx
  802494:	83 c4 20             	add    $0x20,%esp
  802497:	85 c0                	test   %eax,%eax
  802499:	78 4e                	js     8024e9 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80249b:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8024a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a3:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8024a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a8:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8024af:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024b2:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8024b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8024be:	83 ec 0c             	sub    $0xc,%esp
  8024c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8024c4:	e8 95 ef ff ff       	call   80145e <fd2num>
  8024c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024cc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8024ce:	83 c4 04             	add    $0x4,%esp
  8024d1:	ff 75 f0             	pushl  -0x10(%ebp)
  8024d4:	e8 85 ef ff ff       	call   80145e <fd2num>
  8024d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024dc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8024df:	83 c4 10             	add    $0x10,%esp
  8024e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8024e7:	eb 2e                	jmp    802517 <pipe+0x141>
	sys_page_unmap(0, va);
  8024e9:	83 ec 08             	sub    $0x8,%esp
  8024ec:	56                   	push   %esi
  8024ed:	6a 00                	push   $0x0
  8024ef:	e8 ad eb ff ff       	call   8010a1 <sys_page_unmap>
  8024f4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8024f7:	83 ec 08             	sub    $0x8,%esp
  8024fa:	ff 75 f0             	pushl  -0x10(%ebp)
  8024fd:	6a 00                	push   $0x0
  8024ff:	e8 9d eb ff ff       	call   8010a1 <sys_page_unmap>
  802504:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802507:	83 ec 08             	sub    $0x8,%esp
  80250a:	ff 75 f4             	pushl  -0xc(%ebp)
  80250d:	6a 00                	push   $0x0
  80250f:	e8 8d eb ff ff       	call   8010a1 <sys_page_unmap>
  802514:	83 c4 10             	add    $0x10,%esp
}
  802517:	89 d8                	mov    %ebx,%eax
  802519:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80251c:	5b                   	pop    %ebx
  80251d:	5e                   	pop    %esi
  80251e:	5d                   	pop    %ebp
  80251f:	c3                   	ret    

00802520 <pipeisclosed>:
{
  802520:	55                   	push   %ebp
  802521:	89 e5                	mov    %esp,%ebp
  802523:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802526:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802529:	50                   	push   %eax
  80252a:	ff 75 08             	pushl  0x8(%ebp)
  80252d:	e8 a5 ef ff ff       	call   8014d7 <fd_lookup>
  802532:	83 c4 10             	add    $0x10,%esp
  802535:	85 c0                	test   %eax,%eax
  802537:	78 18                	js     802551 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802539:	83 ec 0c             	sub    $0xc,%esp
  80253c:	ff 75 f4             	pushl  -0xc(%ebp)
  80253f:	e8 2a ef ff ff       	call   80146e <fd2data>
	return _pipeisclosed(fd, p);
  802544:	89 c2                	mov    %eax,%edx
  802546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802549:	e8 2f fd ff ff       	call   80227d <_pipeisclosed>
  80254e:	83 c4 10             	add    $0x10,%esp
}
  802551:	c9                   	leave  
  802552:	c3                   	ret    

00802553 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802553:	b8 00 00 00 00       	mov    $0x0,%eax
  802558:	c3                   	ret    

00802559 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802559:	55                   	push   %ebp
  80255a:	89 e5                	mov    %esp,%ebp
  80255c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80255f:	68 53 30 80 00       	push   $0x803053
  802564:	ff 75 0c             	pushl  0xc(%ebp)
  802567:	e8 be e6 ff ff       	call   800c2a <strcpy>
	return 0;
}
  80256c:	b8 00 00 00 00       	mov    $0x0,%eax
  802571:	c9                   	leave  
  802572:	c3                   	ret    

00802573 <devcons_write>:
{
  802573:	55                   	push   %ebp
  802574:	89 e5                	mov    %esp,%ebp
  802576:	57                   	push   %edi
  802577:	56                   	push   %esi
  802578:	53                   	push   %ebx
  802579:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80257f:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802584:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80258a:	3b 75 10             	cmp    0x10(%ebp),%esi
  80258d:	73 31                	jae    8025c0 <devcons_write+0x4d>
		m = n - tot;
  80258f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802592:	29 f3                	sub    %esi,%ebx
  802594:	83 fb 7f             	cmp    $0x7f,%ebx
  802597:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80259c:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80259f:	83 ec 04             	sub    $0x4,%esp
  8025a2:	53                   	push   %ebx
  8025a3:	89 f0                	mov    %esi,%eax
  8025a5:	03 45 0c             	add    0xc(%ebp),%eax
  8025a8:	50                   	push   %eax
  8025a9:	57                   	push   %edi
  8025aa:	e8 09 e8 ff ff       	call   800db8 <memmove>
		sys_cputs(buf, m);
  8025af:	83 c4 08             	add    $0x8,%esp
  8025b2:	53                   	push   %ebx
  8025b3:	57                   	push   %edi
  8025b4:	e8 a7 e9 ff ff       	call   800f60 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8025b9:	01 de                	add    %ebx,%esi
  8025bb:	83 c4 10             	add    $0x10,%esp
  8025be:	eb ca                	jmp    80258a <devcons_write+0x17>
}
  8025c0:	89 f0                	mov    %esi,%eax
  8025c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025c5:	5b                   	pop    %ebx
  8025c6:	5e                   	pop    %esi
  8025c7:	5f                   	pop    %edi
  8025c8:	5d                   	pop    %ebp
  8025c9:	c3                   	ret    

008025ca <devcons_read>:
{
  8025ca:	55                   	push   %ebp
  8025cb:	89 e5                	mov    %esp,%ebp
  8025cd:	83 ec 08             	sub    $0x8,%esp
  8025d0:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8025d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025d9:	74 21                	je     8025fc <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8025db:	e8 9e e9 ff ff       	call   800f7e <sys_cgetc>
  8025e0:	85 c0                	test   %eax,%eax
  8025e2:	75 07                	jne    8025eb <devcons_read+0x21>
		sys_yield();
  8025e4:	e8 14 ea ff ff       	call   800ffd <sys_yield>
  8025e9:	eb f0                	jmp    8025db <devcons_read+0x11>
	if (c < 0)
  8025eb:	78 0f                	js     8025fc <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8025ed:	83 f8 04             	cmp    $0x4,%eax
  8025f0:	74 0c                	je     8025fe <devcons_read+0x34>
	*(char*)vbuf = c;
  8025f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025f5:	88 02                	mov    %al,(%edx)
	return 1;
  8025f7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8025fc:	c9                   	leave  
  8025fd:	c3                   	ret    
		return 0;
  8025fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802603:	eb f7                	jmp    8025fc <devcons_read+0x32>

00802605 <cputchar>:
{
  802605:	55                   	push   %ebp
  802606:	89 e5                	mov    %esp,%ebp
  802608:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80260b:	8b 45 08             	mov    0x8(%ebp),%eax
  80260e:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802611:	6a 01                	push   $0x1
  802613:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802616:	50                   	push   %eax
  802617:	e8 44 e9 ff ff       	call   800f60 <sys_cputs>
}
  80261c:	83 c4 10             	add    $0x10,%esp
  80261f:	c9                   	leave  
  802620:	c3                   	ret    

00802621 <getchar>:
{
  802621:	55                   	push   %ebp
  802622:	89 e5                	mov    %esp,%ebp
  802624:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802627:	6a 01                	push   $0x1
  802629:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80262c:	50                   	push   %eax
  80262d:	6a 00                	push   $0x0
  80262f:	e8 13 f1 ff ff       	call   801747 <read>
	if (r < 0)
  802634:	83 c4 10             	add    $0x10,%esp
  802637:	85 c0                	test   %eax,%eax
  802639:	78 06                	js     802641 <getchar+0x20>
	if (r < 1)
  80263b:	74 06                	je     802643 <getchar+0x22>
	return c;
  80263d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802641:	c9                   	leave  
  802642:	c3                   	ret    
		return -E_EOF;
  802643:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802648:	eb f7                	jmp    802641 <getchar+0x20>

0080264a <iscons>:
{
  80264a:	55                   	push   %ebp
  80264b:	89 e5                	mov    %esp,%ebp
  80264d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802650:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802653:	50                   	push   %eax
  802654:	ff 75 08             	pushl  0x8(%ebp)
  802657:	e8 7b ee ff ff       	call   8014d7 <fd_lookup>
  80265c:	83 c4 10             	add    $0x10,%esp
  80265f:	85 c0                	test   %eax,%eax
  802661:	78 11                	js     802674 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802666:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80266c:	39 10                	cmp    %edx,(%eax)
  80266e:	0f 94 c0             	sete   %al
  802671:	0f b6 c0             	movzbl %al,%eax
}
  802674:	c9                   	leave  
  802675:	c3                   	ret    

00802676 <opencons>:
{
  802676:	55                   	push   %ebp
  802677:	89 e5                	mov    %esp,%ebp
  802679:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80267c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80267f:	50                   	push   %eax
  802680:	e8 00 ee ff ff       	call   801485 <fd_alloc>
  802685:	83 c4 10             	add    $0x10,%esp
  802688:	85 c0                	test   %eax,%eax
  80268a:	78 3a                	js     8026c6 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80268c:	83 ec 04             	sub    $0x4,%esp
  80268f:	68 07 04 00 00       	push   $0x407
  802694:	ff 75 f4             	pushl  -0xc(%ebp)
  802697:	6a 00                	push   $0x0
  802699:	e8 7e e9 ff ff       	call   80101c <sys_page_alloc>
  80269e:	83 c4 10             	add    $0x10,%esp
  8026a1:	85 c0                	test   %eax,%eax
  8026a3:	78 21                	js     8026c6 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8026a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a8:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8026ae:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8026b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8026ba:	83 ec 0c             	sub    $0xc,%esp
  8026bd:	50                   	push   %eax
  8026be:	e8 9b ed ff ff       	call   80145e <fd2num>
  8026c3:	83 c4 10             	add    $0x10,%esp
}
  8026c6:	c9                   	leave  
  8026c7:	c3                   	ret    

008026c8 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8026c8:	55                   	push   %ebp
  8026c9:	89 e5                	mov    %esp,%ebp
  8026cb:	56                   	push   %esi
  8026cc:	53                   	push   %ebx
  8026cd:	8b 75 08             	mov    0x8(%ebp),%esi
  8026d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026d3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8026d6:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8026d8:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8026dd:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8026e0:	83 ec 0c             	sub    $0xc,%esp
  8026e3:	50                   	push   %eax
  8026e4:	e8 e3 ea ff ff       	call   8011cc <sys_ipc_recv>
	if(ret < 0){
  8026e9:	83 c4 10             	add    $0x10,%esp
  8026ec:	85 c0                	test   %eax,%eax
  8026ee:	78 2b                	js     80271b <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8026f0:	85 f6                	test   %esi,%esi
  8026f2:	74 0a                	je     8026fe <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8026f4:	a1 20 54 80 00       	mov    0x805420,%eax
  8026f9:	8b 40 78             	mov    0x78(%eax),%eax
  8026fc:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8026fe:	85 db                	test   %ebx,%ebx
  802700:	74 0a                	je     80270c <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802702:	a1 20 54 80 00       	mov    0x805420,%eax
  802707:	8b 40 7c             	mov    0x7c(%eax),%eax
  80270a:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80270c:	a1 20 54 80 00       	mov    0x805420,%eax
  802711:	8b 40 74             	mov    0x74(%eax),%eax
}
  802714:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802717:	5b                   	pop    %ebx
  802718:	5e                   	pop    %esi
  802719:	5d                   	pop    %ebp
  80271a:	c3                   	ret    
		if(from_env_store)
  80271b:	85 f6                	test   %esi,%esi
  80271d:	74 06                	je     802725 <ipc_recv+0x5d>
			*from_env_store = 0;
  80271f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802725:	85 db                	test   %ebx,%ebx
  802727:	74 eb                	je     802714 <ipc_recv+0x4c>
			*perm_store = 0;
  802729:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80272f:	eb e3                	jmp    802714 <ipc_recv+0x4c>

00802731 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802731:	55                   	push   %ebp
  802732:	89 e5                	mov    %esp,%ebp
  802734:	57                   	push   %edi
  802735:	56                   	push   %esi
  802736:	53                   	push   %ebx
  802737:	83 ec 0c             	sub    $0xc,%esp
  80273a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80273d:	8b 75 0c             	mov    0xc(%ebp),%esi
  802740:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802743:	85 db                	test   %ebx,%ebx
  802745:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80274a:	0f 44 d8             	cmove  %eax,%ebx
  80274d:	eb 05                	jmp    802754 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80274f:	e8 a9 e8 ff ff       	call   800ffd <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802754:	ff 75 14             	pushl  0x14(%ebp)
  802757:	53                   	push   %ebx
  802758:	56                   	push   %esi
  802759:	57                   	push   %edi
  80275a:	e8 4a ea ff ff       	call   8011a9 <sys_ipc_try_send>
  80275f:	83 c4 10             	add    $0x10,%esp
  802762:	85 c0                	test   %eax,%eax
  802764:	74 1b                	je     802781 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802766:	79 e7                	jns    80274f <ipc_send+0x1e>
  802768:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80276b:	74 e2                	je     80274f <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80276d:	83 ec 04             	sub    $0x4,%esp
  802770:	68 5f 30 80 00       	push   $0x80305f
  802775:	6a 46                	push   $0x46
  802777:	68 74 30 80 00       	push   $0x803074
  80277c:	e8 54 dc ff ff       	call   8003d5 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802781:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802784:	5b                   	pop    %ebx
  802785:	5e                   	pop    %esi
  802786:	5f                   	pop    %edi
  802787:	5d                   	pop    %ebp
  802788:	c3                   	ret    

00802789 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802789:	55                   	push   %ebp
  80278a:	89 e5                	mov    %esp,%ebp
  80278c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80278f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802794:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  80279a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8027a0:	8b 52 50             	mov    0x50(%edx),%edx
  8027a3:	39 ca                	cmp    %ecx,%edx
  8027a5:	74 11                	je     8027b8 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8027a7:	83 c0 01             	add    $0x1,%eax
  8027aa:	3d 00 04 00 00       	cmp    $0x400,%eax
  8027af:	75 e3                	jne    802794 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8027b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b6:	eb 0e                	jmp    8027c6 <ipc_find_env+0x3d>
			return envs[i].env_id;
  8027b8:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8027be:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8027c3:	8b 40 48             	mov    0x48(%eax),%eax
}
  8027c6:	5d                   	pop    %ebp
  8027c7:	c3                   	ret    

008027c8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8027c8:	55                   	push   %ebp
  8027c9:	89 e5                	mov    %esp,%ebp
  8027cb:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8027ce:	89 d0                	mov    %edx,%eax
  8027d0:	c1 e8 16             	shr    $0x16,%eax
  8027d3:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8027da:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8027df:	f6 c1 01             	test   $0x1,%cl
  8027e2:	74 1d                	je     802801 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8027e4:	c1 ea 0c             	shr    $0xc,%edx
  8027e7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8027ee:	f6 c2 01             	test   $0x1,%dl
  8027f1:	74 0e                	je     802801 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8027f3:	c1 ea 0c             	shr    $0xc,%edx
  8027f6:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8027fd:	ef 
  8027fe:	0f b7 c0             	movzwl %ax,%eax
}
  802801:	5d                   	pop    %ebp
  802802:	c3                   	ret    
  802803:	66 90                	xchg   %ax,%ax
  802805:	66 90                	xchg   %ax,%ax
  802807:	66 90                	xchg   %ax,%ax
  802809:	66 90                	xchg   %ax,%ax
  80280b:	66 90                	xchg   %ax,%ax
  80280d:	66 90                	xchg   %ax,%ax
  80280f:	90                   	nop

00802810 <__udivdi3>:
  802810:	55                   	push   %ebp
  802811:	57                   	push   %edi
  802812:	56                   	push   %esi
  802813:	53                   	push   %ebx
  802814:	83 ec 1c             	sub    $0x1c,%esp
  802817:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80281b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80281f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802823:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802827:	85 d2                	test   %edx,%edx
  802829:	75 4d                	jne    802878 <__udivdi3+0x68>
  80282b:	39 f3                	cmp    %esi,%ebx
  80282d:	76 19                	jbe    802848 <__udivdi3+0x38>
  80282f:	31 ff                	xor    %edi,%edi
  802831:	89 e8                	mov    %ebp,%eax
  802833:	89 f2                	mov    %esi,%edx
  802835:	f7 f3                	div    %ebx
  802837:	89 fa                	mov    %edi,%edx
  802839:	83 c4 1c             	add    $0x1c,%esp
  80283c:	5b                   	pop    %ebx
  80283d:	5e                   	pop    %esi
  80283e:	5f                   	pop    %edi
  80283f:	5d                   	pop    %ebp
  802840:	c3                   	ret    
  802841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802848:	89 d9                	mov    %ebx,%ecx
  80284a:	85 db                	test   %ebx,%ebx
  80284c:	75 0b                	jne    802859 <__udivdi3+0x49>
  80284e:	b8 01 00 00 00       	mov    $0x1,%eax
  802853:	31 d2                	xor    %edx,%edx
  802855:	f7 f3                	div    %ebx
  802857:	89 c1                	mov    %eax,%ecx
  802859:	31 d2                	xor    %edx,%edx
  80285b:	89 f0                	mov    %esi,%eax
  80285d:	f7 f1                	div    %ecx
  80285f:	89 c6                	mov    %eax,%esi
  802861:	89 e8                	mov    %ebp,%eax
  802863:	89 f7                	mov    %esi,%edi
  802865:	f7 f1                	div    %ecx
  802867:	89 fa                	mov    %edi,%edx
  802869:	83 c4 1c             	add    $0x1c,%esp
  80286c:	5b                   	pop    %ebx
  80286d:	5e                   	pop    %esi
  80286e:	5f                   	pop    %edi
  80286f:	5d                   	pop    %ebp
  802870:	c3                   	ret    
  802871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802878:	39 f2                	cmp    %esi,%edx
  80287a:	77 1c                	ja     802898 <__udivdi3+0x88>
  80287c:	0f bd fa             	bsr    %edx,%edi
  80287f:	83 f7 1f             	xor    $0x1f,%edi
  802882:	75 2c                	jne    8028b0 <__udivdi3+0xa0>
  802884:	39 f2                	cmp    %esi,%edx
  802886:	72 06                	jb     80288e <__udivdi3+0x7e>
  802888:	31 c0                	xor    %eax,%eax
  80288a:	39 eb                	cmp    %ebp,%ebx
  80288c:	77 a9                	ja     802837 <__udivdi3+0x27>
  80288e:	b8 01 00 00 00       	mov    $0x1,%eax
  802893:	eb a2                	jmp    802837 <__udivdi3+0x27>
  802895:	8d 76 00             	lea    0x0(%esi),%esi
  802898:	31 ff                	xor    %edi,%edi
  80289a:	31 c0                	xor    %eax,%eax
  80289c:	89 fa                	mov    %edi,%edx
  80289e:	83 c4 1c             	add    $0x1c,%esp
  8028a1:	5b                   	pop    %ebx
  8028a2:	5e                   	pop    %esi
  8028a3:	5f                   	pop    %edi
  8028a4:	5d                   	pop    %ebp
  8028a5:	c3                   	ret    
  8028a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028ad:	8d 76 00             	lea    0x0(%esi),%esi
  8028b0:	89 f9                	mov    %edi,%ecx
  8028b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8028b7:	29 f8                	sub    %edi,%eax
  8028b9:	d3 e2                	shl    %cl,%edx
  8028bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8028bf:	89 c1                	mov    %eax,%ecx
  8028c1:	89 da                	mov    %ebx,%edx
  8028c3:	d3 ea                	shr    %cl,%edx
  8028c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8028c9:	09 d1                	or     %edx,%ecx
  8028cb:	89 f2                	mov    %esi,%edx
  8028cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8028d1:	89 f9                	mov    %edi,%ecx
  8028d3:	d3 e3                	shl    %cl,%ebx
  8028d5:	89 c1                	mov    %eax,%ecx
  8028d7:	d3 ea                	shr    %cl,%edx
  8028d9:	89 f9                	mov    %edi,%ecx
  8028db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8028df:	89 eb                	mov    %ebp,%ebx
  8028e1:	d3 e6                	shl    %cl,%esi
  8028e3:	89 c1                	mov    %eax,%ecx
  8028e5:	d3 eb                	shr    %cl,%ebx
  8028e7:	09 de                	or     %ebx,%esi
  8028e9:	89 f0                	mov    %esi,%eax
  8028eb:	f7 74 24 08          	divl   0x8(%esp)
  8028ef:	89 d6                	mov    %edx,%esi
  8028f1:	89 c3                	mov    %eax,%ebx
  8028f3:	f7 64 24 0c          	mull   0xc(%esp)
  8028f7:	39 d6                	cmp    %edx,%esi
  8028f9:	72 15                	jb     802910 <__udivdi3+0x100>
  8028fb:	89 f9                	mov    %edi,%ecx
  8028fd:	d3 e5                	shl    %cl,%ebp
  8028ff:	39 c5                	cmp    %eax,%ebp
  802901:	73 04                	jae    802907 <__udivdi3+0xf7>
  802903:	39 d6                	cmp    %edx,%esi
  802905:	74 09                	je     802910 <__udivdi3+0x100>
  802907:	89 d8                	mov    %ebx,%eax
  802909:	31 ff                	xor    %edi,%edi
  80290b:	e9 27 ff ff ff       	jmp    802837 <__udivdi3+0x27>
  802910:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802913:	31 ff                	xor    %edi,%edi
  802915:	e9 1d ff ff ff       	jmp    802837 <__udivdi3+0x27>
  80291a:	66 90                	xchg   %ax,%ax
  80291c:	66 90                	xchg   %ax,%ax
  80291e:	66 90                	xchg   %ax,%ax

00802920 <__umoddi3>:
  802920:	55                   	push   %ebp
  802921:	57                   	push   %edi
  802922:	56                   	push   %esi
  802923:	53                   	push   %ebx
  802924:	83 ec 1c             	sub    $0x1c,%esp
  802927:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80292b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80292f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802933:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802937:	89 da                	mov    %ebx,%edx
  802939:	85 c0                	test   %eax,%eax
  80293b:	75 43                	jne    802980 <__umoddi3+0x60>
  80293d:	39 df                	cmp    %ebx,%edi
  80293f:	76 17                	jbe    802958 <__umoddi3+0x38>
  802941:	89 f0                	mov    %esi,%eax
  802943:	f7 f7                	div    %edi
  802945:	89 d0                	mov    %edx,%eax
  802947:	31 d2                	xor    %edx,%edx
  802949:	83 c4 1c             	add    $0x1c,%esp
  80294c:	5b                   	pop    %ebx
  80294d:	5e                   	pop    %esi
  80294e:	5f                   	pop    %edi
  80294f:	5d                   	pop    %ebp
  802950:	c3                   	ret    
  802951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802958:	89 fd                	mov    %edi,%ebp
  80295a:	85 ff                	test   %edi,%edi
  80295c:	75 0b                	jne    802969 <__umoddi3+0x49>
  80295e:	b8 01 00 00 00       	mov    $0x1,%eax
  802963:	31 d2                	xor    %edx,%edx
  802965:	f7 f7                	div    %edi
  802967:	89 c5                	mov    %eax,%ebp
  802969:	89 d8                	mov    %ebx,%eax
  80296b:	31 d2                	xor    %edx,%edx
  80296d:	f7 f5                	div    %ebp
  80296f:	89 f0                	mov    %esi,%eax
  802971:	f7 f5                	div    %ebp
  802973:	89 d0                	mov    %edx,%eax
  802975:	eb d0                	jmp    802947 <__umoddi3+0x27>
  802977:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80297e:	66 90                	xchg   %ax,%ax
  802980:	89 f1                	mov    %esi,%ecx
  802982:	39 d8                	cmp    %ebx,%eax
  802984:	76 0a                	jbe    802990 <__umoddi3+0x70>
  802986:	89 f0                	mov    %esi,%eax
  802988:	83 c4 1c             	add    $0x1c,%esp
  80298b:	5b                   	pop    %ebx
  80298c:	5e                   	pop    %esi
  80298d:	5f                   	pop    %edi
  80298e:	5d                   	pop    %ebp
  80298f:	c3                   	ret    
  802990:	0f bd e8             	bsr    %eax,%ebp
  802993:	83 f5 1f             	xor    $0x1f,%ebp
  802996:	75 20                	jne    8029b8 <__umoddi3+0x98>
  802998:	39 d8                	cmp    %ebx,%eax
  80299a:	0f 82 b0 00 00 00    	jb     802a50 <__umoddi3+0x130>
  8029a0:	39 f7                	cmp    %esi,%edi
  8029a2:	0f 86 a8 00 00 00    	jbe    802a50 <__umoddi3+0x130>
  8029a8:	89 c8                	mov    %ecx,%eax
  8029aa:	83 c4 1c             	add    $0x1c,%esp
  8029ad:	5b                   	pop    %ebx
  8029ae:	5e                   	pop    %esi
  8029af:	5f                   	pop    %edi
  8029b0:	5d                   	pop    %ebp
  8029b1:	c3                   	ret    
  8029b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8029b8:	89 e9                	mov    %ebp,%ecx
  8029ba:	ba 20 00 00 00       	mov    $0x20,%edx
  8029bf:	29 ea                	sub    %ebp,%edx
  8029c1:	d3 e0                	shl    %cl,%eax
  8029c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8029c7:	89 d1                	mov    %edx,%ecx
  8029c9:	89 f8                	mov    %edi,%eax
  8029cb:	d3 e8                	shr    %cl,%eax
  8029cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8029d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8029d5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8029d9:	09 c1                	or     %eax,%ecx
  8029db:	89 d8                	mov    %ebx,%eax
  8029dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8029e1:	89 e9                	mov    %ebp,%ecx
  8029e3:	d3 e7                	shl    %cl,%edi
  8029e5:	89 d1                	mov    %edx,%ecx
  8029e7:	d3 e8                	shr    %cl,%eax
  8029e9:	89 e9                	mov    %ebp,%ecx
  8029eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8029ef:	d3 e3                	shl    %cl,%ebx
  8029f1:	89 c7                	mov    %eax,%edi
  8029f3:	89 d1                	mov    %edx,%ecx
  8029f5:	89 f0                	mov    %esi,%eax
  8029f7:	d3 e8                	shr    %cl,%eax
  8029f9:	89 e9                	mov    %ebp,%ecx
  8029fb:	89 fa                	mov    %edi,%edx
  8029fd:	d3 e6                	shl    %cl,%esi
  8029ff:	09 d8                	or     %ebx,%eax
  802a01:	f7 74 24 08          	divl   0x8(%esp)
  802a05:	89 d1                	mov    %edx,%ecx
  802a07:	89 f3                	mov    %esi,%ebx
  802a09:	f7 64 24 0c          	mull   0xc(%esp)
  802a0d:	89 c6                	mov    %eax,%esi
  802a0f:	89 d7                	mov    %edx,%edi
  802a11:	39 d1                	cmp    %edx,%ecx
  802a13:	72 06                	jb     802a1b <__umoddi3+0xfb>
  802a15:	75 10                	jne    802a27 <__umoddi3+0x107>
  802a17:	39 c3                	cmp    %eax,%ebx
  802a19:	73 0c                	jae    802a27 <__umoddi3+0x107>
  802a1b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802a1f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802a23:	89 d7                	mov    %edx,%edi
  802a25:	89 c6                	mov    %eax,%esi
  802a27:	89 ca                	mov    %ecx,%edx
  802a29:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802a2e:	29 f3                	sub    %esi,%ebx
  802a30:	19 fa                	sbb    %edi,%edx
  802a32:	89 d0                	mov    %edx,%eax
  802a34:	d3 e0                	shl    %cl,%eax
  802a36:	89 e9                	mov    %ebp,%ecx
  802a38:	d3 eb                	shr    %cl,%ebx
  802a3a:	d3 ea                	shr    %cl,%edx
  802a3c:	09 d8                	or     %ebx,%eax
  802a3e:	83 c4 1c             	add    $0x1c,%esp
  802a41:	5b                   	pop    %ebx
  802a42:	5e                   	pop    %esi
  802a43:	5f                   	pop    %edi
  802a44:	5d                   	pop    %ebp
  802a45:	c3                   	ret    
  802a46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a4d:	8d 76 00             	lea    0x0(%esi),%esi
  802a50:	89 da                	mov    %ebx,%edx
  802a52:	29 fe                	sub    %edi,%esi
  802a54:	19 c2                	sbb    %eax,%edx
  802a56:	89 f1                	mov    %esi,%ecx
  802a58:	89 c8                	mov    %ecx,%eax
  802a5a:	e9 4b ff ff ff       	jmp    8029aa <__umoddi3+0x8a>
