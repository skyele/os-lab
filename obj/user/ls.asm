
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
  80003e:	83 3d d0 41 80 00 00 	cmpl   $0x0,0x8041d0
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
  80005a:	68 e2 29 80 00       	push   $0x8029e2
  80005f:	e8 b1 1c 00 00       	call   801d15 <printf>
  800064:	83 c4 10             	add    $0x10,%esp
	if(prefix) {
  800067:	85 db                	test   %ebx,%ebx
  800069:	74 1c                	je     800087 <ls1+0x54>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
			sep = "/";
		else
			sep = "";
  80006b:	b8 77 2a 80 00       	mov    $0x802a77,%eax
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  800070:	80 3b 00             	cmpb   $0x0,(%ebx)
  800073:	75 4b                	jne    8000c0 <ls1+0x8d>
		printf("%s%s", prefix, sep);
  800075:	83 ec 04             	sub    $0x4,%esp
  800078:	50                   	push   %eax
  800079:	53                   	push   %ebx
  80007a:	68 eb 29 80 00       	push   $0x8029eb
  80007f:	e8 91 1c 00 00       	call   801d15 <printf>
  800084:	83 c4 10             	add    $0x10,%esp
	}
	printf("%s", name);
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	ff 75 14             	pushl  0x14(%ebp)
  80008d:	68 1d 2f 80 00       	push   $0x802f1d
  800092:	e8 7e 1c 00 00       	call   801d15 <printf>
	if(flag['F'] && isdir)
  800097:	83 c4 10             	add    $0x10,%esp
  80009a:	83 3d 38 41 80 00 00 	cmpl   $0x0,0x804138
  8000a1:	74 06                	je     8000a9 <ls1+0x76>
  8000a3:	89 f0                	mov    %esi,%eax
  8000a5:	84 c0                	test   %al,%al
  8000a7:	75 37                	jne    8000e0 <ls1+0xad>
		printf("/");
	printf("\n");
  8000a9:	83 ec 0c             	sub    $0xc,%esp
  8000ac:	68 76 2a 80 00       	push   $0x802a76
  8000b1:	e8 5f 1c 00 00       	call   801d15 <printf>
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
  8000c4:	e8 d5 0a 00 00       	call   800b9e <strlen>
  8000c9:	83 c4 10             	add    $0x10,%esp
			sep = "";
  8000cc:	80 7c 03 ff 2f       	cmpb   $0x2f,-0x1(%ebx,%eax,1)
  8000d1:	b8 e0 29 80 00       	mov    $0x8029e0,%eax
  8000d6:	ba 77 2a 80 00       	mov    $0x802a77,%edx
  8000db:	0f 44 c2             	cmove  %edx,%eax
  8000de:	eb 95                	jmp    800075 <ls1+0x42>
		printf("/");
  8000e0:	83 ec 0c             	sub    $0xc,%esp
  8000e3:	68 e0 29 80 00       	push   $0x8029e0
  8000e8:	e8 28 1c 00 00       	call   801d15 <printf>
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
  800104:	e8 69 1a 00 00       	call   801b72 <open>
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
  800122:	e8 34 16 00 00       	call   80175b <readn>
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
  800161:	68 f0 29 80 00       	push   $0x8029f0
  800166:	6a 1d                	push   $0x1d
  800168:	68 fc 29 80 00       	push   $0x8029fc
  80016d:	e8 10 02 00 00       	call   800382 <_panic>
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
  800181:	68 06 2a 80 00       	push   $0x802a06
  800186:	6a 22                	push   $0x22
  800188:	68 fc 29 80 00       	push   $0x8029fc
  80018d:	e8 f0 01 00 00       	call   800382 <_panic>
		panic("error reading directory %s: %e", path, n);
  800192:	83 ec 0c             	sub    $0xc,%esp
  800195:	50                   	push   %eax
  800196:	57                   	push   %edi
  800197:	68 4c 2a 80 00       	push   $0x802a4c
  80019c:	6a 24                	push   $0x24
  80019e:	68 fc 29 80 00       	push   $0x8029fc
  8001a3:	e8 da 01 00 00       	call   800382 <_panic>

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
  8001bd:	e8 7c 17 00 00       	call   80193e <stat>
  8001c2:	83 c4 10             	add    $0x10,%esp
  8001c5:	85 c0                	test   %eax,%eax
  8001c7:	78 2c                	js     8001f5 <ls+0x4d>
	if (st.st_isdir && !flag['d'])
  8001c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001cc:	85 c0                	test   %eax,%eax
  8001ce:	74 09                	je     8001d9 <ls+0x31>
  8001d0:	83 3d b0 41 80 00 00 	cmpl   $0x0,0x8041b0
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
  8001fa:	68 21 2a 80 00       	push   $0x802a21
  8001ff:	6a 0f                	push   $0xf
  800201:	68 fc 29 80 00       	push   $0x8029fc
  800206:	e8 77 01 00 00       	call   800382 <_panic>
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
  800222:	68 2d 2a 80 00       	push   $0x802a2d
  800227:	e8 e9 1a 00 00       	call   801d15 <printf>
	exit();
  80022c:	e8 37 01 00 00       	call   800368 <exit>
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
  80024a:	e8 4f 10 00 00       	call   80129e <argstart>
	while ((i = argnext(&args)) >= 0)
  80024f:	83 c4 10             	add    $0x10,%esp
  800252:	8d 5d e8             	lea    -0x18(%ebp),%ebx
  800255:	eb 08                	jmp    80025f <umain+0x29>
		switch (i) {
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
  800257:	83 04 85 20 40 80 00 	addl   $0x1,0x804020(,%eax,4)
  80025e:	01 
	while ((i = argnext(&args)) >= 0)
  80025f:	83 ec 0c             	sub    $0xc,%esp
  800262:	53                   	push   %ebx
  800263:	e8 66 10 00 00       	call   8012ce <argnext>
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
  800293:	68 77 2a 80 00       	push   $0x802a77
  800298:	68 e0 29 80 00       	push   $0x8029e0
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
  8002cf:	c7 05 20 44 80 00 00 	movl   $0x0,0x804420
  8002d6:	00 00 00 
	envid_t find = sys_getenvid();
  8002d9:	e8 ad 0c 00 00       	call   800f8b <sys_getenvid>
  8002de:	8b 1d 20 44 80 00    	mov    0x804420,%ebx
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
  800327:	89 1d 20 44 80 00    	mov    %ebx,0x804420
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80032d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800331:	7e 0a                	jle    80033d <libmain+0x77>
		binaryname = argv[0];
  800333:	8b 45 0c             	mov    0xc(%ebp),%eax
  800336:	8b 00                	mov    (%eax),%eax
  800338:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("call umain!\n");
  80033d:	83 ec 0c             	sub    $0xc,%esp
  800340:	68 6b 2a 80 00       	push   $0x802a6b
  800345:	e8 2e 01 00 00       	call   800478 <cprintf>
	// call user main routine
	umain(argc, argv);
  80034a:	83 c4 08             	add    $0x8,%esp
  80034d:	ff 75 0c             	pushl  0xc(%ebp)
  800350:	ff 75 08             	pushl  0x8(%ebp)
  800353:	e8 de fe ff ff       	call   800236 <umain>

	// exit gracefully
	exit();
  800358:	e8 0b 00 00 00       	call   800368 <exit>
}
  80035d:	83 c4 10             	add    $0x10,%esp
  800360:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800363:	5b                   	pop    %ebx
  800364:	5e                   	pop    %esi
  800365:	5f                   	pop    %edi
  800366:	5d                   	pop    %ebp
  800367:	c3                   	ret    

00800368 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800368:	55                   	push   %ebp
  800369:	89 e5                	mov    %esp,%ebp
  80036b:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80036e:	e8 50 12 00 00       	call   8015c3 <close_all>
	sys_env_destroy(0);
  800373:	83 ec 0c             	sub    $0xc,%esp
  800376:	6a 00                	push   $0x0
  800378:	e8 cd 0b 00 00       	call   800f4a <sys_env_destroy>
}
  80037d:	83 c4 10             	add    $0x10,%esp
  800380:	c9                   	leave  
  800381:	c3                   	ret    

00800382 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800382:	55                   	push   %ebp
  800383:	89 e5                	mov    %esp,%ebp
  800385:	56                   	push   %esi
  800386:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800387:	a1 20 44 80 00       	mov    0x804420,%eax
  80038c:	8b 40 48             	mov    0x48(%eax),%eax
  80038f:	83 ec 04             	sub    $0x4,%esp
  800392:	68 b4 2a 80 00       	push   $0x802ab4
  800397:	50                   	push   %eax
  800398:	68 82 2a 80 00       	push   $0x802a82
  80039d:	e8 d6 00 00 00       	call   800478 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8003a2:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003a5:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8003ab:	e8 db 0b 00 00       	call   800f8b <sys_getenvid>
  8003b0:	83 c4 04             	add    $0x4,%esp
  8003b3:	ff 75 0c             	pushl  0xc(%ebp)
  8003b6:	ff 75 08             	pushl  0x8(%ebp)
  8003b9:	56                   	push   %esi
  8003ba:	50                   	push   %eax
  8003bb:	68 90 2a 80 00       	push   $0x802a90
  8003c0:	e8 b3 00 00 00       	call   800478 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003c5:	83 c4 18             	add    $0x18,%esp
  8003c8:	53                   	push   %ebx
  8003c9:	ff 75 10             	pushl  0x10(%ebp)
  8003cc:	e8 56 00 00 00       	call   800427 <vcprintf>
	cprintf("\n");
  8003d1:	c7 04 24 76 2a 80 00 	movl   $0x802a76,(%esp)
  8003d8:	e8 9b 00 00 00       	call   800478 <cprintf>
  8003dd:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003e0:	cc                   	int3   
  8003e1:	eb fd                	jmp    8003e0 <_panic+0x5e>

008003e3 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003e3:	55                   	push   %ebp
  8003e4:	89 e5                	mov    %esp,%ebp
  8003e6:	53                   	push   %ebx
  8003e7:	83 ec 04             	sub    $0x4,%esp
  8003ea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003ed:	8b 13                	mov    (%ebx),%edx
  8003ef:	8d 42 01             	lea    0x1(%edx),%eax
  8003f2:	89 03                	mov    %eax,(%ebx)
  8003f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003f7:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003fb:	3d ff 00 00 00       	cmp    $0xff,%eax
  800400:	74 09                	je     80040b <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800402:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800406:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800409:	c9                   	leave  
  80040a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80040b:	83 ec 08             	sub    $0x8,%esp
  80040e:	68 ff 00 00 00       	push   $0xff
  800413:	8d 43 08             	lea    0x8(%ebx),%eax
  800416:	50                   	push   %eax
  800417:	e8 f1 0a 00 00       	call   800f0d <sys_cputs>
		b->idx = 0;
  80041c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800422:	83 c4 10             	add    $0x10,%esp
  800425:	eb db                	jmp    800402 <putch+0x1f>

00800427 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800427:	55                   	push   %ebp
  800428:	89 e5                	mov    %esp,%ebp
  80042a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800430:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800437:	00 00 00 
	b.cnt = 0;
  80043a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800441:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800444:	ff 75 0c             	pushl  0xc(%ebp)
  800447:	ff 75 08             	pushl  0x8(%ebp)
  80044a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800450:	50                   	push   %eax
  800451:	68 e3 03 80 00       	push   $0x8003e3
  800456:	e8 4a 01 00 00       	call   8005a5 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80045b:	83 c4 08             	add    $0x8,%esp
  80045e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800464:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80046a:	50                   	push   %eax
  80046b:	e8 9d 0a 00 00       	call   800f0d <sys_cputs>

	return b.cnt;
}
  800470:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800476:	c9                   	leave  
  800477:	c3                   	ret    

00800478 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800478:	55                   	push   %ebp
  800479:	89 e5                	mov    %esp,%ebp
  80047b:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80047e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800481:	50                   	push   %eax
  800482:	ff 75 08             	pushl  0x8(%ebp)
  800485:	e8 9d ff ff ff       	call   800427 <vcprintf>
	va_end(ap);

	return cnt;
}
  80048a:	c9                   	leave  
  80048b:	c3                   	ret    

0080048c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80048c:	55                   	push   %ebp
  80048d:	89 e5                	mov    %esp,%ebp
  80048f:	57                   	push   %edi
  800490:	56                   	push   %esi
  800491:	53                   	push   %ebx
  800492:	83 ec 1c             	sub    $0x1c,%esp
  800495:	89 c6                	mov    %eax,%esi
  800497:	89 d7                	mov    %edx,%edi
  800499:	8b 45 08             	mov    0x8(%ebp),%eax
  80049c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80049f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8004a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8004a8:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8004ab:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8004af:	74 2c                	je     8004dd <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8004b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004b4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8004bb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004be:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004c1:	39 c2                	cmp    %eax,%edx
  8004c3:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8004c6:	73 43                	jae    80050b <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8004c8:	83 eb 01             	sub    $0x1,%ebx
  8004cb:	85 db                	test   %ebx,%ebx
  8004cd:	7e 6c                	jle    80053b <printnum+0xaf>
				putch(padc, putdat);
  8004cf:	83 ec 08             	sub    $0x8,%esp
  8004d2:	57                   	push   %edi
  8004d3:	ff 75 18             	pushl  0x18(%ebp)
  8004d6:	ff d6                	call   *%esi
  8004d8:	83 c4 10             	add    $0x10,%esp
  8004db:	eb eb                	jmp    8004c8 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8004dd:	83 ec 0c             	sub    $0xc,%esp
  8004e0:	6a 20                	push   $0x20
  8004e2:	6a 00                	push   $0x0
  8004e4:	50                   	push   %eax
  8004e5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004e8:	ff 75 e0             	pushl  -0x20(%ebp)
  8004eb:	89 fa                	mov    %edi,%edx
  8004ed:	89 f0                	mov    %esi,%eax
  8004ef:	e8 98 ff ff ff       	call   80048c <printnum>
		while (--width > 0)
  8004f4:	83 c4 20             	add    $0x20,%esp
  8004f7:	83 eb 01             	sub    $0x1,%ebx
  8004fa:	85 db                	test   %ebx,%ebx
  8004fc:	7e 65                	jle    800563 <printnum+0xd7>
			putch(padc, putdat);
  8004fe:	83 ec 08             	sub    $0x8,%esp
  800501:	57                   	push   %edi
  800502:	6a 20                	push   $0x20
  800504:	ff d6                	call   *%esi
  800506:	83 c4 10             	add    $0x10,%esp
  800509:	eb ec                	jmp    8004f7 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80050b:	83 ec 0c             	sub    $0xc,%esp
  80050e:	ff 75 18             	pushl  0x18(%ebp)
  800511:	83 eb 01             	sub    $0x1,%ebx
  800514:	53                   	push   %ebx
  800515:	50                   	push   %eax
  800516:	83 ec 08             	sub    $0x8,%esp
  800519:	ff 75 dc             	pushl  -0x24(%ebp)
  80051c:	ff 75 d8             	pushl  -0x28(%ebp)
  80051f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800522:	ff 75 e0             	pushl  -0x20(%ebp)
  800525:	e8 66 22 00 00       	call   802790 <__udivdi3>
  80052a:	83 c4 18             	add    $0x18,%esp
  80052d:	52                   	push   %edx
  80052e:	50                   	push   %eax
  80052f:	89 fa                	mov    %edi,%edx
  800531:	89 f0                	mov    %esi,%eax
  800533:	e8 54 ff ff ff       	call   80048c <printnum>
  800538:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80053b:	83 ec 08             	sub    $0x8,%esp
  80053e:	57                   	push   %edi
  80053f:	83 ec 04             	sub    $0x4,%esp
  800542:	ff 75 dc             	pushl  -0x24(%ebp)
  800545:	ff 75 d8             	pushl  -0x28(%ebp)
  800548:	ff 75 e4             	pushl  -0x1c(%ebp)
  80054b:	ff 75 e0             	pushl  -0x20(%ebp)
  80054e:	e8 4d 23 00 00       	call   8028a0 <__umoddi3>
  800553:	83 c4 14             	add    $0x14,%esp
  800556:	0f be 80 bb 2a 80 00 	movsbl 0x802abb(%eax),%eax
  80055d:	50                   	push   %eax
  80055e:	ff d6                	call   *%esi
  800560:	83 c4 10             	add    $0x10,%esp
	}
}
  800563:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800566:	5b                   	pop    %ebx
  800567:	5e                   	pop    %esi
  800568:	5f                   	pop    %edi
  800569:	5d                   	pop    %ebp
  80056a:	c3                   	ret    

0080056b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80056b:	55                   	push   %ebp
  80056c:	89 e5                	mov    %esp,%ebp
  80056e:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800571:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800575:	8b 10                	mov    (%eax),%edx
  800577:	3b 50 04             	cmp    0x4(%eax),%edx
  80057a:	73 0a                	jae    800586 <sprintputch+0x1b>
		*b->buf++ = ch;
  80057c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80057f:	89 08                	mov    %ecx,(%eax)
  800581:	8b 45 08             	mov    0x8(%ebp),%eax
  800584:	88 02                	mov    %al,(%edx)
}
  800586:	5d                   	pop    %ebp
  800587:	c3                   	ret    

00800588 <printfmt>:
{
  800588:	55                   	push   %ebp
  800589:	89 e5                	mov    %esp,%ebp
  80058b:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80058e:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800591:	50                   	push   %eax
  800592:	ff 75 10             	pushl  0x10(%ebp)
  800595:	ff 75 0c             	pushl  0xc(%ebp)
  800598:	ff 75 08             	pushl  0x8(%ebp)
  80059b:	e8 05 00 00 00       	call   8005a5 <vprintfmt>
}
  8005a0:	83 c4 10             	add    $0x10,%esp
  8005a3:	c9                   	leave  
  8005a4:	c3                   	ret    

008005a5 <vprintfmt>:
{
  8005a5:	55                   	push   %ebp
  8005a6:	89 e5                	mov    %esp,%ebp
  8005a8:	57                   	push   %edi
  8005a9:	56                   	push   %esi
  8005aa:	53                   	push   %ebx
  8005ab:	83 ec 3c             	sub    $0x3c,%esp
  8005ae:	8b 75 08             	mov    0x8(%ebp),%esi
  8005b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005b4:	8b 7d 10             	mov    0x10(%ebp),%edi
  8005b7:	e9 32 04 00 00       	jmp    8009ee <vprintfmt+0x449>
		padc = ' ';
  8005bc:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8005c0:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8005c7:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8005ce:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8005d5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005dc:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8005e3:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005e8:	8d 47 01             	lea    0x1(%edi),%eax
  8005eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005ee:	0f b6 17             	movzbl (%edi),%edx
  8005f1:	8d 42 dd             	lea    -0x23(%edx),%eax
  8005f4:	3c 55                	cmp    $0x55,%al
  8005f6:	0f 87 12 05 00 00    	ja     800b0e <vprintfmt+0x569>
  8005fc:	0f b6 c0             	movzbl %al,%eax
  8005ff:	ff 24 85 a0 2c 80 00 	jmp    *0x802ca0(,%eax,4)
  800606:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800609:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80060d:	eb d9                	jmp    8005e8 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80060f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800612:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800616:	eb d0                	jmp    8005e8 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800618:	0f b6 d2             	movzbl %dl,%edx
  80061b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80061e:	b8 00 00 00 00       	mov    $0x0,%eax
  800623:	89 75 08             	mov    %esi,0x8(%ebp)
  800626:	eb 03                	jmp    80062b <vprintfmt+0x86>
  800628:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80062b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80062e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800632:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800635:	8d 72 d0             	lea    -0x30(%edx),%esi
  800638:	83 fe 09             	cmp    $0x9,%esi
  80063b:	76 eb                	jbe    800628 <vprintfmt+0x83>
  80063d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800640:	8b 75 08             	mov    0x8(%ebp),%esi
  800643:	eb 14                	jmp    800659 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800645:	8b 45 14             	mov    0x14(%ebp),%eax
  800648:	8b 00                	mov    (%eax),%eax
  80064a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064d:	8b 45 14             	mov    0x14(%ebp),%eax
  800650:	8d 40 04             	lea    0x4(%eax),%eax
  800653:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800656:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800659:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80065d:	79 89                	jns    8005e8 <vprintfmt+0x43>
				width = precision, precision = -1;
  80065f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800662:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800665:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80066c:	e9 77 ff ff ff       	jmp    8005e8 <vprintfmt+0x43>
  800671:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800674:	85 c0                	test   %eax,%eax
  800676:	0f 48 c1             	cmovs  %ecx,%eax
  800679:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80067c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80067f:	e9 64 ff ff ff       	jmp    8005e8 <vprintfmt+0x43>
  800684:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800687:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80068e:	e9 55 ff ff ff       	jmp    8005e8 <vprintfmt+0x43>
			lflag++;
  800693:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800697:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80069a:	e9 49 ff ff ff       	jmp    8005e8 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80069f:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a2:	8d 78 04             	lea    0x4(%eax),%edi
  8006a5:	83 ec 08             	sub    $0x8,%esp
  8006a8:	53                   	push   %ebx
  8006a9:	ff 30                	pushl  (%eax)
  8006ab:	ff d6                	call   *%esi
			break;
  8006ad:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8006b0:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8006b3:	e9 33 03 00 00       	jmp    8009eb <vprintfmt+0x446>
			err = va_arg(ap, int);
  8006b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bb:	8d 78 04             	lea    0x4(%eax),%edi
  8006be:	8b 00                	mov    (%eax),%eax
  8006c0:	99                   	cltd   
  8006c1:	31 d0                	xor    %edx,%eax
  8006c3:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006c5:	83 f8 10             	cmp    $0x10,%eax
  8006c8:	7f 23                	jg     8006ed <vprintfmt+0x148>
  8006ca:	8b 14 85 00 2e 80 00 	mov    0x802e00(,%eax,4),%edx
  8006d1:	85 d2                	test   %edx,%edx
  8006d3:	74 18                	je     8006ed <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8006d5:	52                   	push   %edx
  8006d6:	68 1d 2f 80 00       	push   $0x802f1d
  8006db:	53                   	push   %ebx
  8006dc:	56                   	push   %esi
  8006dd:	e8 a6 fe ff ff       	call   800588 <printfmt>
  8006e2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006e5:	89 7d 14             	mov    %edi,0x14(%ebp)
  8006e8:	e9 fe 02 00 00       	jmp    8009eb <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8006ed:	50                   	push   %eax
  8006ee:	68 d3 2a 80 00       	push   $0x802ad3
  8006f3:	53                   	push   %ebx
  8006f4:	56                   	push   %esi
  8006f5:	e8 8e fe ff ff       	call   800588 <printfmt>
  8006fa:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006fd:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800700:	e9 e6 02 00 00       	jmp    8009eb <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800705:	8b 45 14             	mov    0x14(%ebp),%eax
  800708:	83 c0 04             	add    $0x4,%eax
  80070b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80070e:	8b 45 14             	mov    0x14(%ebp),%eax
  800711:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800713:	85 c9                	test   %ecx,%ecx
  800715:	b8 cc 2a 80 00       	mov    $0x802acc,%eax
  80071a:	0f 45 c1             	cmovne %ecx,%eax
  80071d:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800720:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800724:	7e 06                	jle    80072c <vprintfmt+0x187>
  800726:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80072a:	75 0d                	jne    800739 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80072c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80072f:	89 c7                	mov    %eax,%edi
  800731:	03 45 e0             	add    -0x20(%ebp),%eax
  800734:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800737:	eb 53                	jmp    80078c <vprintfmt+0x1e7>
  800739:	83 ec 08             	sub    $0x8,%esp
  80073c:	ff 75 d8             	pushl  -0x28(%ebp)
  80073f:	50                   	push   %eax
  800740:	e8 71 04 00 00       	call   800bb6 <strnlen>
  800745:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800748:	29 c1                	sub    %eax,%ecx
  80074a:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80074d:	83 c4 10             	add    $0x10,%esp
  800750:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800752:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800756:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800759:	eb 0f                	jmp    80076a <vprintfmt+0x1c5>
					putch(padc, putdat);
  80075b:	83 ec 08             	sub    $0x8,%esp
  80075e:	53                   	push   %ebx
  80075f:	ff 75 e0             	pushl  -0x20(%ebp)
  800762:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800764:	83 ef 01             	sub    $0x1,%edi
  800767:	83 c4 10             	add    $0x10,%esp
  80076a:	85 ff                	test   %edi,%edi
  80076c:	7f ed                	jg     80075b <vprintfmt+0x1b6>
  80076e:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800771:	85 c9                	test   %ecx,%ecx
  800773:	b8 00 00 00 00       	mov    $0x0,%eax
  800778:	0f 49 c1             	cmovns %ecx,%eax
  80077b:	29 c1                	sub    %eax,%ecx
  80077d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800780:	eb aa                	jmp    80072c <vprintfmt+0x187>
					putch(ch, putdat);
  800782:	83 ec 08             	sub    $0x8,%esp
  800785:	53                   	push   %ebx
  800786:	52                   	push   %edx
  800787:	ff d6                	call   *%esi
  800789:	83 c4 10             	add    $0x10,%esp
  80078c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80078f:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800791:	83 c7 01             	add    $0x1,%edi
  800794:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800798:	0f be d0             	movsbl %al,%edx
  80079b:	85 d2                	test   %edx,%edx
  80079d:	74 4b                	je     8007ea <vprintfmt+0x245>
  80079f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007a3:	78 06                	js     8007ab <vprintfmt+0x206>
  8007a5:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8007a9:	78 1e                	js     8007c9 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8007ab:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8007af:	74 d1                	je     800782 <vprintfmt+0x1dd>
  8007b1:	0f be c0             	movsbl %al,%eax
  8007b4:	83 e8 20             	sub    $0x20,%eax
  8007b7:	83 f8 5e             	cmp    $0x5e,%eax
  8007ba:	76 c6                	jbe    800782 <vprintfmt+0x1dd>
					putch('?', putdat);
  8007bc:	83 ec 08             	sub    $0x8,%esp
  8007bf:	53                   	push   %ebx
  8007c0:	6a 3f                	push   $0x3f
  8007c2:	ff d6                	call   *%esi
  8007c4:	83 c4 10             	add    $0x10,%esp
  8007c7:	eb c3                	jmp    80078c <vprintfmt+0x1e7>
  8007c9:	89 cf                	mov    %ecx,%edi
  8007cb:	eb 0e                	jmp    8007db <vprintfmt+0x236>
				putch(' ', putdat);
  8007cd:	83 ec 08             	sub    $0x8,%esp
  8007d0:	53                   	push   %ebx
  8007d1:	6a 20                	push   $0x20
  8007d3:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8007d5:	83 ef 01             	sub    $0x1,%edi
  8007d8:	83 c4 10             	add    $0x10,%esp
  8007db:	85 ff                	test   %edi,%edi
  8007dd:	7f ee                	jg     8007cd <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8007df:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8007e2:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e5:	e9 01 02 00 00       	jmp    8009eb <vprintfmt+0x446>
  8007ea:	89 cf                	mov    %ecx,%edi
  8007ec:	eb ed                	jmp    8007db <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8007ee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8007f1:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8007f8:	e9 eb fd ff ff       	jmp    8005e8 <vprintfmt+0x43>
	if (lflag >= 2)
  8007fd:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800801:	7f 21                	jg     800824 <vprintfmt+0x27f>
	else if (lflag)
  800803:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800807:	74 68                	je     800871 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800809:	8b 45 14             	mov    0x14(%ebp),%eax
  80080c:	8b 00                	mov    (%eax),%eax
  80080e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800811:	89 c1                	mov    %eax,%ecx
  800813:	c1 f9 1f             	sar    $0x1f,%ecx
  800816:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800819:	8b 45 14             	mov    0x14(%ebp),%eax
  80081c:	8d 40 04             	lea    0x4(%eax),%eax
  80081f:	89 45 14             	mov    %eax,0x14(%ebp)
  800822:	eb 17                	jmp    80083b <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800824:	8b 45 14             	mov    0x14(%ebp),%eax
  800827:	8b 50 04             	mov    0x4(%eax),%edx
  80082a:	8b 00                	mov    (%eax),%eax
  80082c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80082f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800832:	8b 45 14             	mov    0x14(%ebp),%eax
  800835:	8d 40 08             	lea    0x8(%eax),%eax
  800838:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80083b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80083e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800841:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800844:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800847:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80084b:	78 3f                	js     80088c <vprintfmt+0x2e7>
			base = 10;
  80084d:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800852:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800856:	0f 84 71 01 00 00    	je     8009cd <vprintfmt+0x428>
				putch('+', putdat);
  80085c:	83 ec 08             	sub    $0x8,%esp
  80085f:	53                   	push   %ebx
  800860:	6a 2b                	push   $0x2b
  800862:	ff d6                	call   *%esi
  800864:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800867:	b8 0a 00 00 00       	mov    $0xa,%eax
  80086c:	e9 5c 01 00 00       	jmp    8009cd <vprintfmt+0x428>
		return va_arg(*ap, int);
  800871:	8b 45 14             	mov    0x14(%ebp),%eax
  800874:	8b 00                	mov    (%eax),%eax
  800876:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800879:	89 c1                	mov    %eax,%ecx
  80087b:	c1 f9 1f             	sar    $0x1f,%ecx
  80087e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800881:	8b 45 14             	mov    0x14(%ebp),%eax
  800884:	8d 40 04             	lea    0x4(%eax),%eax
  800887:	89 45 14             	mov    %eax,0x14(%ebp)
  80088a:	eb af                	jmp    80083b <vprintfmt+0x296>
				putch('-', putdat);
  80088c:	83 ec 08             	sub    $0x8,%esp
  80088f:	53                   	push   %ebx
  800890:	6a 2d                	push   $0x2d
  800892:	ff d6                	call   *%esi
				num = -(long long) num;
  800894:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800897:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80089a:	f7 d8                	neg    %eax
  80089c:	83 d2 00             	adc    $0x0,%edx
  80089f:	f7 da                	neg    %edx
  8008a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008a7:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008aa:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008af:	e9 19 01 00 00       	jmp    8009cd <vprintfmt+0x428>
	if (lflag >= 2)
  8008b4:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8008b8:	7f 29                	jg     8008e3 <vprintfmt+0x33e>
	else if (lflag)
  8008ba:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008be:	74 44                	je     800904 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8008c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c3:	8b 00                	mov    (%eax),%eax
  8008c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008cd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d3:	8d 40 04             	lea    0x4(%eax),%eax
  8008d6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008d9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008de:	e9 ea 00 00 00       	jmp    8009cd <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e6:	8b 50 04             	mov    0x4(%eax),%edx
  8008e9:	8b 00                	mov    (%eax),%eax
  8008eb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008ee:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f4:	8d 40 08             	lea    0x8(%eax),%eax
  8008f7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008fa:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008ff:	e9 c9 00 00 00       	jmp    8009cd <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800904:	8b 45 14             	mov    0x14(%ebp),%eax
  800907:	8b 00                	mov    (%eax),%eax
  800909:	ba 00 00 00 00       	mov    $0x0,%edx
  80090e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800911:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800914:	8b 45 14             	mov    0x14(%ebp),%eax
  800917:	8d 40 04             	lea    0x4(%eax),%eax
  80091a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80091d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800922:	e9 a6 00 00 00       	jmp    8009cd <vprintfmt+0x428>
			putch('0', putdat);
  800927:	83 ec 08             	sub    $0x8,%esp
  80092a:	53                   	push   %ebx
  80092b:	6a 30                	push   $0x30
  80092d:	ff d6                	call   *%esi
	if (lflag >= 2)
  80092f:	83 c4 10             	add    $0x10,%esp
  800932:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800936:	7f 26                	jg     80095e <vprintfmt+0x3b9>
	else if (lflag)
  800938:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80093c:	74 3e                	je     80097c <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80093e:	8b 45 14             	mov    0x14(%ebp),%eax
  800941:	8b 00                	mov    (%eax),%eax
  800943:	ba 00 00 00 00       	mov    $0x0,%edx
  800948:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80094b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80094e:	8b 45 14             	mov    0x14(%ebp),%eax
  800951:	8d 40 04             	lea    0x4(%eax),%eax
  800954:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800957:	b8 08 00 00 00       	mov    $0x8,%eax
  80095c:	eb 6f                	jmp    8009cd <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80095e:	8b 45 14             	mov    0x14(%ebp),%eax
  800961:	8b 50 04             	mov    0x4(%eax),%edx
  800964:	8b 00                	mov    (%eax),%eax
  800966:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800969:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80096c:	8b 45 14             	mov    0x14(%ebp),%eax
  80096f:	8d 40 08             	lea    0x8(%eax),%eax
  800972:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800975:	b8 08 00 00 00       	mov    $0x8,%eax
  80097a:	eb 51                	jmp    8009cd <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80097c:	8b 45 14             	mov    0x14(%ebp),%eax
  80097f:	8b 00                	mov    (%eax),%eax
  800981:	ba 00 00 00 00       	mov    $0x0,%edx
  800986:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800989:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80098c:	8b 45 14             	mov    0x14(%ebp),%eax
  80098f:	8d 40 04             	lea    0x4(%eax),%eax
  800992:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800995:	b8 08 00 00 00       	mov    $0x8,%eax
  80099a:	eb 31                	jmp    8009cd <vprintfmt+0x428>
			putch('0', putdat);
  80099c:	83 ec 08             	sub    $0x8,%esp
  80099f:	53                   	push   %ebx
  8009a0:	6a 30                	push   $0x30
  8009a2:	ff d6                	call   *%esi
			putch('x', putdat);
  8009a4:	83 c4 08             	add    $0x8,%esp
  8009a7:	53                   	push   %ebx
  8009a8:	6a 78                	push   $0x78
  8009aa:	ff d6                	call   *%esi
			num = (unsigned long long)
  8009ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8009af:	8b 00                	mov    (%eax),%eax
  8009b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009b9:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8009bc:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8009bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c2:	8d 40 04             	lea    0x4(%eax),%eax
  8009c5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009c8:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8009cd:	83 ec 0c             	sub    $0xc,%esp
  8009d0:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8009d4:	52                   	push   %edx
  8009d5:	ff 75 e0             	pushl  -0x20(%ebp)
  8009d8:	50                   	push   %eax
  8009d9:	ff 75 dc             	pushl  -0x24(%ebp)
  8009dc:	ff 75 d8             	pushl  -0x28(%ebp)
  8009df:	89 da                	mov    %ebx,%edx
  8009e1:	89 f0                	mov    %esi,%eax
  8009e3:	e8 a4 fa ff ff       	call   80048c <printnum>
			break;
  8009e8:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8009eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009ee:	83 c7 01             	add    $0x1,%edi
  8009f1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009f5:	83 f8 25             	cmp    $0x25,%eax
  8009f8:	0f 84 be fb ff ff    	je     8005bc <vprintfmt+0x17>
			if (ch == '\0')
  8009fe:	85 c0                	test   %eax,%eax
  800a00:	0f 84 28 01 00 00    	je     800b2e <vprintfmt+0x589>
			putch(ch, putdat);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	53                   	push   %ebx
  800a0a:	50                   	push   %eax
  800a0b:	ff d6                	call   *%esi
  800a0d:	83 c4 10             	add    $0x10,%esp
  800a10:	eb dc                	jmp    8009ee <vprintfmt+0x449>
	if (lflag >= 2)
  800a12:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800a16:	7f 26                	jg     800a3e <vprintfmt+0x499>
	else if (lflag)
  800a18:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a1c:	74 41                	je     800a5f <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800a1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a21:	8b 00                	mov    (%eax),%eax
  800a23:	ba 00 00 00 00       	mov    $0x0,%edx
  800a28:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a2b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a31:	8d 40 04             	lea    0x4(%eax),%eax
  800a34:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a37:	b8 10 00 00 00       	mov    $0x10,%eax
  800a3c:	eb 8f                	jmp    8009cd <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a41:	8b 50 04             	mov    0x4(%eax),%edx
  800a44:	8b 00                	mov    (%eax),%eax
  800a46:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a49:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a4c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4f:	8d 40 08             	lea    0x8(%eax),%eax
  800a52:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a55:	b8 10 00 00 00       	mov    $0x10,%eax
  800a5a:	e9 6e ff ff ff       	jmp    8009cd <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800a5f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a62:	8b 00                	mov    (%eax),%eax
  800a64:	ba 00 00 00 00       	mov    $0x0,%edx
  800a69:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a6c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a72:	8d 40 04             	lea    0x4(%eax),%eax
  800a75:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a78:	b8 10 00 00 00       	mov    $0x10,%eax
  800a7d:	e9 4b ff ff ff       	jmp    8009cd <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800a82:	8b 45 14             	mov    0x14(%ebp),%eax
  800a85:	83 c0 04             	add    $0x4,%eax
  800a88:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8e:	8b 00                	mov    (%eax),%eax
  800a90:	85 c0                	test   %eax,%eax
  800a92:	74 14                	je     800aa8 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800a94:	8b 13                	mov    (%ebx),%edx
  800a96:	83 fa 7f             	cmp    $0x7f,%edx
  800a99:	7f 37                	jg     800ad2 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800a9b:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800a9d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800aa0:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa3:	e9 43 ff ff ff       	jmp    8009eb <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800aa8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800aad:	bf f1 2b 80 00       	mov    $0x802bf1,%edi
							putch(ch, putdat);
  800ab2:	83 ec 08             	sub    $0x8,%esp
  800ab5:	53                   	push   %ebx
  800ab6:	50                   	push   %eax
  800ab7:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800ab9:	83 c7 01             	add    $0x1,%edi
  800abc:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800ac0:	83 c4 10             	add    $0x10,%esp
  800ac3:	85 c0                	test   %eax,%eax
  800ac5:	75 eb                	jne    800ab2 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800ac7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800aca:	89 45 14             	mov    %eax,0x14(%ebp)
  800acd:	e9 19 ff ff ff       	jmp    8009eb <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800ad2:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800ad4:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ad9:	bf 29 2c 80 00       	mov    $0x802c29,%edi
							putch(ch, putdat);
  800ade:	83 ec 08             	sub    $0x8,%esp
  800ae1:	53                   	push   %ebx
  800ae2:	50                   	push   %eax
  800ae3:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800ae5:	83 c7 01             	add    $0x1,%edi
  800ae8:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800aec:	83 c4 10             	add    $0x10,%esp
  800aef:	85 c0                	test   %eax,%eax
  800af1:	75 eb                	jne    800ade <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800af3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800af6:	89 45 14             	mov    %eax,0x14(%ebp)
  800af9:	e9 ed fe ff ff       	jmp    8009eb <vprintfmt+0x446>
			putch(ch, putdat);
  800afe:	83 ec 08             	sub    $0x8,%esp
  800b01:	53                   	push   %ebx
  800b02:	6a 25                	push   $0x25
  800b04:	ff d6                	call   *%esi
			break;
  800b06:	83 c4 10             	add    $0x10,%esp
  800b09:	e9 dd fe ff ff       	jmp    8009eb <vprintfmt+0x446>
			putch('%', putdat);
  800b0e:	83 ec 08             	sub    $0x8,%esp
  800b11:	53                   	push   %ebx
  800b12:	6a 25                	push   $0x25
  800b14:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b16:	83 c4 10             	add    $0x10,%esp
  800b19:	89 f8                	mov    %edi,%eax
  800b1b:	eb 03                	jmp    800b20 <vprintfmt+0x57b>
  800b1d:	83 e8 01             	sub    $0x1,%eax
  800b20:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b24:	75 f7                	jne    800b1d <vprintfmt+0x578>
  800b26:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b29:	e9 bd fe ff ff       	jmp    8009eb <vprintfmt+0x446>
}
  800b2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b31:	5b                   	pop    %ebx
  800b32:	5e                   	pop    %esi
  800b33:	5f                   	pop    %edi
  800b34:	5d                   	pop    %ebp
  800b35:	c3                   	ret    

00800b36 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	83 ec 18             	sub    $0x18,%esp
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b42:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b45:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b49:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b53:	85 c0                	test   %eax,%eax
  800b55:	74 26                	je     800b7d <vsnprintf+0x47>
  800b57:	85 d2                	test   %edx,%edx
  800b59:	7e 22                	jle    800b7d <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b5b:	ff 75 14             	pushl  0x14(%ebp)
  800b5e:	ff 75 10             	pushl  0x10(%ebp)
  800b61:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b64:	50                   	push   %eax
  800b65:	68 6b 05 80 00       	push   $0x80056b
  800b6a:	e8 36 fa ff ff       	call   8005a5 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b72:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b78:	83 c4 10             	add    $0x10,%esp
}
  800b7b:	c9                   	leave  
  800b7c:	c3                   	ret    
		return -E_INVAL;
  800b7d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b82:	eb f7                	jmp    800b7b <vsnprintf+0x45>

00800b84 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
  800b87:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b8a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b8d:	50                   	push   %eax
  800b8e:	ff 75 10             	pushl  0x10(%ebp)
  800b91:	ff 75 0c             	pushl  0xc(%ebp)
  800b94:	ff 75 08             	pushl  0x8(%ebp)
  800b97:	e8 9a ff ff ff       	call   800b36 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b9c:	c9                   	leave  
  800b9d:	c3                   	ret    

00800b9e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b9e:	55                   	push   %ebp
  800b9f:	89 e5                	mov    %esp,%ebp
  800ba1:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ba4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba9:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800bad:	74 05                	je     800bb4 <strlen+0x16>
		n++;
  800baf:	83 c0 01             	add    $0x1,%eax
  800bb2:	eb f5                	jmp    800ba9 <strlen+0xb>
	return n;
}
  800bb4:	5d                   	pop    %ebp
  800bb5:	c3                   	ret    

00800bb6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bbf:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc4:	39 c2                	cmp    %eax,%edx
  800bc6:	74 0d                	je     800bd5 <strnlen+0x1f>
  800bc8:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800bcc:	74 05                	je     800bd3 <strnlen+0x1d>
		n++;
  800bce:	83 c2 01             	add    $0x1,%edx
  800bd1:	eb f1                	jmp    800bc4 <strnlen+0xe>
  800bd3:	89 d0                	mov    %edx,%eax
	return n;
}
  800bd5:	5d                   	pop    %ebp
  800bd6:	c3                   	ret    

00800bd7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bd7:	55                   	push   %ebp
  800bd8:	89 e5                	mov    %esp,%ebp
  800bda:	53                   	push   %ebx
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800be1:	ba 00 00 00 00       	mov    $0x0,%edx
  800be6:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800bea:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800bed:	83 c2 01             	add    $0x1,%edx
  800bf0:	84 c9                	test   %cl,%cl
  800bf2:	75 f2                	jne    800be6 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800bf4:	5b                   	pop    %ebx
  800bf5:	5d                   	pop    %ebp
  800bf6:	c3                   	ret    

00800bf7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800bf7:	55                   	push   %ebp
  800bf8:	89 e5                	mov    %esp,%ebp
  800bfa:	53                   	push   %ebx
  800bfb:	83 ec 10             	sub    $0x10,%esp
  800bfe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c01:	53                   	push   %ebx
  800c02:	e8 97 ff ff ff       	call   800b9e <strlen>
  800c07:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800c0a:	ff 75 0c             	pushl  0xc(%ebp)
  800c0d:	01 d8                	add    %ebx,%eax
  800c0f:	50                   	push   %eax
  800c10:	e8 c2 ff ff ff       	call   800bd7 <strcpy>
	return dst;
}
  800c15:	89 d8                	mov    %ebx,%eax
  800c17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c1a:	c9                   	leave  
  800c1b:	c3                   	ret    

00800c1c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	56                   	push   %esi
  800c20:	53                   	push   %ebx
  800c21:	8b 45 08             	mov    0x8(%ebp),%eax
  800c24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c27:	89 c6                	mov    %eax,%esi
  800c29:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c2c:	89 c2                	mov    %eax,%edx
  800c2e:	39 f2                	cmp    %esi,%edx
  800c30:	74 11                	je     800c43 <strncpy+0x27>
		*dst++ = *src;
  800c32:	83 c2 01             	add    $0x1,%edx
  800c35:	0f b6 19             	movzbl (%ecx),%ebx
  800c38:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c3b:	80 fb 01             	cmp    $0x1,%bl
  800c3e:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800c41:	eb eb                	jmp    800c2e <strncpy+0x12>
	}
	return ret;
}
  800c43:	5b                   	pop    %ebx
  800c44:	5e                   	pop    %esi
  800c45:	5d                   	pop    %ebp
  800c46:	c3                   	ret    

00800c47 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c47:	55                   	push   %ebp
  800c48:	89 e5                	mov    %esp,%ebp
  800c4a:	56                   	push   %esi
  800c4b:	53                   	push   %ebx
  800c4c:	8b 75 08             	mov    0x8(%ebp),%esi
  800c4f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c52:	8b 55 10             	mov    0x10(%ebp),%edx
  800c55:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c57:	85 d2                	test   %edx,%edx
  800c59:	74 21                	je     800c7c <strlcpy+0x35>
  800c5b:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c5f:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c61:	39 c2                	cmp    %eax,%edx
  800c63:	74 14                	je     800c79 <strlcpy+0x32>
  800c65:	0f b6 19             	movzbl (%ecx),%ebx
  800c68:	84 db                	test   %bl,%bl
  800c6a:	74 0b                	je     800c77 <strlcpy+0x30>
			*dst++ = *src++;
  800c6c:	83 c1 01             	add    $0x1,%ecx
  800c6f:	83 c2 01             	add    $0x1,%edx
  800c72:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c75:	eb ea                	jmp    800c61 <strlcpy+0x1a>
  800c77:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c79:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c7c:	29 f0                	sub    %esi,%eax
}
  800c7e:	5b                   	pop    %ebx
  800c7f:	5e                   	pop    %esi
  800c80:	5d                   	pop    %ebp
  800c81:	c3                   	ret    

00800c82 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c82:	55                   	push   %ebp
  800c83:	89 e5                	mov    %esp,%ebp
  800c85:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c88:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c8b:	0f b6 01             	movzbl (%ecx),%eax
  800c8e:	84 c0                	test   %al,%al
  800c90:	74 0c                	je     800c9e <strcmp+0x1c>
  800c92:	3a 02                	cmp    (%edx),%al
  800c94:	75 08                	jne    800c9e <strcmp+0x1c>
		p++, q++;
  800c96:	83 c1 01             	add    $0x1,%ecx
  800c99:	83 c2 01             	add    $0x1,%edx
  800c9c:	eb ed                	jmp    800c8b <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c9e:	0f b6 c0             	movzbl %al,%eax
  800ca1:	0f b6 12             	movzbl (%edx),%edx
  800ca4:	29 d0                	sub    %edx,%eax
}
  800ca6:	5d                   	pop    %ebp
  800ca7:	c3                   	ret    

00800ca8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ca8:	55                   	push   %ebp
  800ca9:	89 e5                	mov    %esp,%ebp
  800cab:	53                   	push   %ebx
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb2:	89 c3                	mov    %eax,%ebx
  800cb4:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800cb7:	eb 06                	jmp    800cbf <strncmp+0x17>
		n--, p++, q++;
  800cb9:	83 c0 01             	add    $0x1,%eax
  800cbc:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800cbf:	39 d8                	cmp    %ebx,%eax
  800cc1:	74 16                	je     800cd9 <strncmp+0x31>
  800cc3:	0f b6 08             	movzbl (%eax),%ecx
  800cc6:	84 c9                	test   %cl,%cl
  800cc8:	74 04                	je     800cce <strncmp+0x26>
  800cca:	3a 0a                	cmp    (%edx),%cl
  800ccc:	74 eb                	je     800cb9 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cce:	0f b6 00             	movzbl (%eax),%eax
  800cd1:	0f b6 12             	movzbl (%edx),%edx
  800cd4:	29 d0                	sub    %edx,%eax
}
  800cd6:	5b                   	pop    %ebx
  800cd7:	5d                   	pop    %ebp
  800cd8:	c3                   	ret    
		return 0;
  800cd9:	b8 00 00 00 00       	mov    $0x0,%eax
  800cde:	eb f6                	jmp    800cd6 <strncmp+0x2e>

00800ce0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ce0:	55                   	push   %ebp
  800ce1:	89 e5                	mov    %esp,%ebp
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cea:	0f b6 10             	movzbl (%eax),%edx
  800ced:	84 d2                	test   %dl,%dl
  800cef:	74 09                	je     800cfa <strchr+0x1a>
		if (*s == c)
  800cf1:	38 ca                	cmp    %cl,%dl
  800cf3:	74 0a                	je     800cff <strchr+0x1f>
	for (; *s; s++)
  800cf5:	83 c0 01             	add    $0x1,%eax
  800cf8:	eb f0                	jmp    800cea <strchr+0xa>
			return (char *) s;
	return 0;
  800cfa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cff:	5d                   	pop    %ebp
  800d00:	c3                   	ret    

00800d01 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d01:	55                   	push   %ebp
  800d02:	89 e5                	mov    %esp,%ebp
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d0b:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d0e:	38 ca                	cmp    %cl,%dl
  800d10:	74 09                	je     800d1b <strfind+0x1a>
  800d12:	84 d2                	test   %dl,%dl
  800d14:	74 05                	je     800d1b <strfind+0x1a>
	for (; *s; s++)
  800d16:	83 c0 01             	add    $0x1,%eax
  800d19:	eb f0                	jmp    800d0b <strfind+0xa>
			break;
	return (char *) s;
}
  800d1b:	5d                   	pop    %ebp
  800d1c:	c3                   	ret    

00800d1d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
  800d20:	57                   	push   %edi
  800d21:	56                   	push   %esi
  800d22:	53                   	push   %ebx
  800d23:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d26:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d29:	85 c9                	test   %ecx,%ecx
  800d2b:	74 31                	je     800d5e <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d2d:	89 f8                	mov    %edi,%eax
  800d2f:	09 c8                	or     %ecx,%eax
  800d31:	a8 03                	test   $0x3,%al
  800d33:	75 23                	jne    800d58 <memset+0x3b>
		c &= 0xFF;
  800d35:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d39:	89 d3                	mov    %edx,%ebx
  800d3b:	c1 e3 08             	shl    $0x8,%ebx
  800d3e:	89 d0                	mov    %edx,%eax
  800d40:	c1 e0 18             	shl    $0x18,%eax
  800d43:	89 d6                	mov    %edx,%esi
  800d45:	c1 e6 10             	shl    $0x10,%esi
  800d48:	09 f0                	or     %esi,%eax
  800d4a:	09 c2                	or     %eax,%edx
  800d4c:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d4e:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d51:	89 d0                	mov    %edx,%eax
  800d53:	fc                   	cld    
  800d54:	f3 ab                	rep stos %eax,%es:(%edi)
  800d56:	eb 06                	jmp    800d5e <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5b:	fc                   	cld    
  800d5c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d5e:	89 f8                	mov    %edi,%eax
  800d60:	5b                   	pop    %ebx
  800d61:	5e                   	pop    %esi
  800d62:	5f                   	pop    %edi
  800d63:	5d                   	pop    %ebp
  800d64:	c3                   	ret    

00800d65 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	57                   	push   %edi
  800d69:	56                   	push   %esi
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d70:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d73:	39 c6                	cmp    %eax,%esi
  800d75:	73 32                	jae    800da9 <memmove+0x44>
  800d77:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d7a:	39 c2                	cmp    %eax,%edx
  800d7c:	76 2b                	jbe    800da9 <memmove+0x44>
		s += n;
		d += n;
  800d7e:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d81:	89 fe                	mov    %edi,%esi
  800d83:	09 ce                	or     %ecx,%esi
  800d85:	09 d6                	or     %edx,%esi
  800d87:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d8d:	75 0e                	jne    800d9d <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d8f:	83 ef 04             	sub    $0x4,%edi
  800d92:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d95:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d98:	fd                   	std    
  800d99:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d9b:	eb 09                	jmp    800da6 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d9d:	83 ef 01             	sub    $0x1,%edi
  800da0:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800da3:	fd                   	std    
  800da4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800da6:	fc                   	cld    
  800da7:	eb 1a                	jmp    800dc3 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800da9:	89 c2                	mov    %eax,%edx
  800dab:	09 ca                	or     %ecx,%edx
  800dad:	09 f2                	or     %esi,%edx
  800daf:	f6 c2 03             	test   $0x3,%dl
  800db2:	75 0a                	jne    800dbe <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800db4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800db7:	89 c7                	mov    %eax,%edi
  800db9:	fc                   	cld    
  800dba:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800dbc:	eb 05                	jmp    800dc3 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800dbe:	89 c7                	mov    %eax,%edi
  800dc0:	fc                   	cld    
  800dc1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800dc3:	5e                   	pop    %esi
  800dc4:	5f                   	pop    %edi
  800dc5:	5d                   	pop    %ebp
  800dc6:	c3                   	ret    

00800dc7 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800dc7:	55                   	push   %ebp
  800dc8:	89 e5                	mov    %esp,%ebp
  800dca:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800dcd:	ff 75 10             	pushl  0x10(%ebp)
  800dd0:	ff 75 0c             	pushl  0xc(%ebp)
  800dd3:	ff 75 08             	pushl  0x8(%ebp)
  800dd6:	e8 8a ff ff ff       	call   800d65 <memmove>
}
  800ddb:	c9                   	leave  
  800ddc:	c3                   	ret    

00800ddd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	56                   	push   %esi
  800de1:	53                   	push   %ebx
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de8:	89 c6                	mov    %eax,%esi
  800dea:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ded:	39 f0                	cmp    %esi,%eax
  800def:	74 1c                	je     800e0d <memcmp+0x30>
		if (*s1 != *s2)
  800df1:	0f b6 08             	movzbl (%eax),%ecx
  800df4:	0f b6 1a             	movzbl (%edx),%ebx
  800df7:	38 d9                	cmp    %bl,%cl
  800df9:	75 08                	jne    800e03 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800dfb:	83 c0 01             	add    $0x1,%eax
  800dfe:	83 c2 01             	add    $0x1,%edx
  800e01:	eb ea                	jmp    800ded <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800e03:	0f b6 c1             	movzbl %cl,%eax
  800e06:	0f b6 db             	movzbl %bl,%ebx
  800e09:	29 d8                	sub    %ebx,%eax
  800e0b:	eb 05                	jmp    800e12 <memcmp+0x35>
	}

	return 0;
  800e0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e12:	5b                   	pop    %ebx
  800e13:	5e                   	pop    %esi
  800e14:	5d                   	pop    %ebp
  800e15:	c3                   	ret    

00800e16 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e16:	55                   	push   %ebp
  800e17:	89 e5                	mov    %esp,%ebp
  800e19:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e1f:	89 c2                	mov    %eax,%edx
  800e21:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e24:	39 d0                	cmp    %edx,%eax
  800e26:	73 09                	jae    800e31 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e28:	38 08                	cmp    %cl,(%eax)
  800e2a:	74 05                	je     800e31 <memfind+0x1b>
	for (; s < ends; s++)
  800e2c:	83 c0 01             	add    $0x1,%eax
  800e2f:	eb f3                	jmp    800e24 <memfind+0xe>
			break;
	return (void *) s;
}
  800e31:	5d                   	pop    %ebp
  800e32:	c3                   	ret    

00800e33 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e33:	55                   	push   %ebp
  800e34:	89 e5                	mov    %esp,%ebp
  800e36:	57                   	push   %edi
  800e37:	56                   	push   %esi
  800e38:	53                   	push   %ebx
  800e39:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e3c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e3f:	eb 03                	jmp    800e44 <strtol+0x11>
		s++;
  800e41:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e44:	0f b6 01             	movzbl (%ecx),%eax
  800e47:	3c 20                	cmp    $0x20,%al
  800e49:	74 f6                	je     800e41 <strtol+0xe>
  800e4b:	3c 09                	cmp    $0x9,%al
  800e4d:	74 f2                	je     800e41 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e4f:	3c 2b                	cmp    $0x2b,%al
  800e51:	74 2a                	je     800e7d <strtol+0x4a>
	int neg = 0;
  800e53:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e58:	3c 2d                	cmp    $0x2d,%al
  800e5a:	74 2b                	je     800e87 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e5c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e62:	75 0f                	jne    800e73 <strtol+0x40>
  800e64:	80 39 30             	cmpb   $0x30,(%ecx)
  800e67:	74 28                	je     800e91 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e69:	85 db                	test   %ebx,%ebx
  800e6b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e70:	0f 44 d8             	cmove  %eax,%ebx
  800e73:	b8 00 00 00 00       	mov    $0x0,%eax
  800e78:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e7b:	eb 50                	jmp    800ecd <strtol+0x9a>
		s++;
  800e7d:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e80:	bf 00 00 00 00       	mov    $0x0,%edi
  800e85:	eb d5                	jmp    800e5c <strtol+0x29>
		s++, neg = 1;
  800e87:	83 c1 01             	add    $0x1,%ecx
  800e8a:	bf 01 00 00 00       	mov    $0x1,%edi
  800e8f:	eb cb                	jmp    800e5c <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e91:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e95:	74 0e                	je     800ea5 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e97:	85 db                	test   %ebx,%ebx
  800e99:	75 d8                	jne    800e73 <strtol+0x40>
		s++, base = 8;
  800e9b:	83 c1 01             	add    $0x1,%ecx
  800e9e:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ea3:	eb ce                	jmp    800e73 <strtol+0x40>
		s += 2, base = 16;
  800ea5:	83 c1 02             	add    $0x2,%ecx
  800ea8:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ead:	eb c4                	jmp    800e73 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800eaf:	8d 72 9f             	lea    -0x61(%edx),%esi
  800eb2:	89 f3                	mov    %esi,%ebx
  800eb4:	80 fb 19             	cmp    $0x19,%bl
  800eb7:	77 29                	ja     800ee2 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800eb9:	0f be d2             	movsbl %dl,%edx
  800ebc:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ebf:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ec2:	7d 30                	jge    800ef4 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800ec4:	83 c1 01             	add    $0x1,%ecx
  800ec7:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ecb:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ecd:	0f b6 11             	movzbl (%ecx),%edx
  800ed0:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ed3:	89 f3                	mov    %esi,%ebx
  800ed5:	80 fb 09             	cmp    $0x9,%bl
  800ed8:	77 d5                	ja     800eaf <strtol+0x7c>
			dig = *s - '0';
  800eda:	0f be d2             	movsbl %dl,%edx
  800edd:	83 ea 30             	sub    $0x30,%edx
  800ee0:	eb dd                	jmp    800ebf <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800ee2:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ee5:	89 f3                	mov    %esi,%ebx
  800ee7:	80 fb 19             	cmp    $0x19,%bl
  800eea:	77 08                	ja     800ef4 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800eec:	0f be d2             	movsbl %dl,%edx
  800eef:	83 ea 37             	sub    $0x37,%edx
  800ef2:	eb cb                	jmp    800ebf <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ef4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ef8:	74 05                	je     800eff <strtol+0xcc>
		*endptr = (char *) s;
  800efa:	8b 75 0c             	mov    0xc(%ebp),%esi
  800efd:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800eff:	89 c2                	mov    %eax,%edx
  800f01:	f7 da                	neg    %edx
  800f03:	85 ff                	test   %edi,%edi
  800f05:	0f 45 c2             	cmovne %edx,%eax
}
  800f08:	5b                   	pop    %ebx
  800f09:	5e                   	pop    %esi
  800f0a:	5f                   	pop    %edi
  800f0b:	5d                   	pop    %ebp
  800f0c:	c3                   	ret    

00800f0d <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
  800f10:	57                   	push   %edi
  800f11:	56                   	push   %esi
  800f12:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f13:	b8 00 00 00 00       	mov    $0x0,%eax
  800f18:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1e:	89 c3                	mov    %eax,%ebx
  800f20:	89 c7                	mov    %eax,%edi
  800f22:	89 c6                	mov    %eax,%esi
  800f24:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f26:	5b                   	pop    %ebx
  800f27:	5e                   	pop    %esi
  800f28:	5f                   	pop    %edi
  800f29:	5d                   	pop    %ebp
  800f2a:	c3                   	ret    

00800f2b <sys_cgetc>:

int
sys_cgetc(void)
{
  800f2b:	55                   	push   %ebp
  800f2c:	89 e5                	mov    %esp,%ebp
  800f2e:	57                   	push   %edi
  800f2f:	56                   	push   %esi
  800f30:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f31:	ba 00 00 00 00       	mov    $0x0,%edx
  800f36:	b8 01 00 00 00       	mov    $0x1,%eax
  800f3b:	89 d1                	mov    %edx,%ecx
  800f3d:	89 d3                	mov    %edx,%ebx
  800f3f:	89 d7                	mov    %edx,%edi
  800f41:	89 d6                	mov    %edx,%esi
  800f43:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f45:	5b                   	pop    %ebx
  800f46:	5e                   	pop    %esi
  800f47:	5f                   	pop    %edi
  800f48:	5d                   	pop    %ebp
  800f49:	c3                   	ret    

00800f4a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f4a:	55                   	push   %ebp
  800f4b:	89 e5                	mov    %esp,%ebp
  800f4d:	57                   	push   %edi
  800f4e:	56                   	push   %esi
  800f4f:	53                   	push   %ebx
  800f50:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f53:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f58:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5b:	b8 03 00 00 00       	mov    $0x3,%eax
  800f60:	89 cb                	mov    %ecx,%ebx
  800f62:	89 cf                	mov    %ecx,%edi
  800f64:	89 ce                	mov    %ecx,%esi
  800f66:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f68:	85 c0                	test   %eax,%eax
  800f6a:	7f 08                	jg     800f74 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f6f:	5b                   	pop    %ebx
  800f70:	5e                   	pop    %esi
  800f71:	5f                   	pop    %edi
  800f72:	5d                   	pop    %ebp
  800f73:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f74:	83 ec 0c             	sub    $0xc,%esp
  800f77:	50                   	push   %eax
  800f78:	6a 03                	push   $0x3
  800f7a:	68 44 2e 80 00       	push   $0x802e44
  800f7f:	6a 43                	push   $0x43
  800f81:	68 61 2e 80 00       	push   $0x802e61
  800f86:	e8 f7 f3 ff ff       	call   800382 <_panic>

00800f8b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
  800f8e:	57                   	push   %edi
  800f8f:	56                   	push   %esi
  800f90:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f91:	ba 00 00 00 00       	mov    $0x0,%edx
  800f96:	b8 02 00 00 00       	mov    $0x2,%eax
  800f9b:	89 d1                	mov    %edx,%ecx
  800f9d:	89 d3                	mov    %edx,%ebx
  800f9f:	89 d7                	mov    %edx,%edi
  800fa1:	89 d6                	mov    %edx,%esi
  800fa3:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800fa5:	5b                   	pop    %ebx
  800fa6:	5e                   	pop    %esi
  800fa7:	5f                   	pop    %edi
  800fa8:	5d                   	pop    %ebp
  800fa9:	c3                   	ret    

00800faa <sys_yield>:

void
sys_yield(void)
{
  800faa:	55                   	push   %ebp
  800fab:	89 e5                	mov    %esp,%ebp
  800fad:	57                   	push   %edi
  800fae:	56                   	push   %esi
  800faf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fb0:	ba 00 00 00 00       	mov    $0x0,%edx
  800fb5:	b8 0b 00 00 00       	mov    $0xb,%eax
  800fba:	89 d1                	mov    %edx,%ecx
  800fbc:	89 d3                	mov    %edx,%ebx
  800fbe:	89 d7                	mov    %edx,%edi
  800fc0:	89 d6                	mov    %edx,%esi
  800fc2:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800fc4:	5b                   	pop    %ebx
  800fc5:	5e                   	pop    %esi
  800fc6:	5f                   	pop    %edi
  800fc7:	5d                   	pop    %ebp
  800fc8:	c3                   	ret    

00800fc9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800fc9:	55                   	push   %ebp
  800fca:	89 e5                	mov    %esp,%ebp
  800fcc:	57                   	push   %edi
  800fcd:	56                   	push   %esi
  800fce:	53                   	push   %ebx
  800fcf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fd2:	be 00 00 00 00       	mov    $0x0,%esi
  800fd7:	8b 55 08             	mov    0x8(%ebp),%edx
  800fda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fdd:	b8 04 00 00 00       	mov    $0x4,%eax
  800fe2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fe5:	89 f7                	mov    %esi,%edi
  800fe7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fe9:	85 c0                	test   %eax,%eax
  800feb:	7f 08                	jg     800ff5 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800fed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff0:	5b                   	pop    %ebx
  800ff1:	5e                   	pop    %esi
  800ff2:	5f                   	pop    %edi
  800ff3:	5d                   	pop    %ebp
  800ff4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff5:	83 ec 0c             	sub    $0xc,%esp
  800ff8:	50                   	push   %eax
  800ff9:	6a 04                	push   $0x4
  800ffb:	68 44 2e 80 00       	push   $0x802e44
  801000:	6a 43                	push   $0x43
  801002:	68 61 2e 80 00       	push   $0x802e61
  801007:	e8 76 f3 ff ff       	call   800382 <_panic>

0080100c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	57                   	push   %edi
  801010:	56                   	push   %esi
  801011:	53                   	push   %ebx
  801012:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801015:	8b 55 08             	mov    0x8(%ebp),%edx
  801018:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80101b:	b8 05 00 00 00       	mov    $0x5,%eax
  801020:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801023:	8b 7d 14             	mov    0x14(%ebp),%edi
  801026:	8b 75 18             	mov    0x18(%ebp),%esi
  801029:	cd 30                	int    $0x30
	if(check && ret > 0)
  80102b:	85 c0                	test   %eax,%eax
  80102d:	7f 08                	jg     801037 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80102f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801032:	5b                   	pop    %ebx
  801033:	5e                   	pop    %esi
  801034:	5f                   	pop    %edi
  801035:	5d                   	pop    %ebp
  801036:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801037:	83 ec 0c             	sub    $0xc,%esp
  80103a:	50                   	push   %eax
  80103b:	6a 05                	push   $0x5
  80103d:	68 44 2e 80 00       	push   $0x802e44
  801042:	6a 43                	push   $0x43
  801044:	68 61 2e 80 00       	push   $0x802e61
  801049:	e8 34 f3 ff ff       	call   800382 <_panic>

0080104e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80104e:	55                   	push   %ebp
  80104f:	89 e5                	mov    %esp,%ebp
  801051:	57                   	push   %edi
  801052:	56                   	push   %esi
  801053:	53                   	push   %ebx
  801054:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801057:	bb 00 00 00 00       	mov    $0x0,%ebx
  80105c:	8b 55 08             	mov    0x8(%ebp),%edx
  80105f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801062:	b8 06 00 00 00       	mov    $0x6,%eax
  801067:	89 df                	mov    %ebx,%edi
  801069:	89 de                	mov    %ebx,%esi
  80106b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80106d:	85 c0                	test   %eax,%eax
  80106f:	7f 08                	jg     801079 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801071:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801074:	5b                   	pop    %ebx
  801075:	5e                   	pop    %esi
  801076:	5f                   	pop    %edi
  801077:	5d                   	pop    %ebp
  801078:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801079:	83 ec 0c             	sub    $0xc,%esp
  80107c:	50                   	push   %eax
  80107d:	6a 06                	push   $0x6
  80107f:	68 44 2e 80 00       	push   $0x802e44
  801084:	6a 43                	push   $0x43
  801086:	68 61 2e 80 00       	push   $0x802e61
  80108b:	e8 f2 f2 ff ff       	call   800382 <_panic>

00801090 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801090:	55                   	push   %ebp
  801091:	89 e5                	mov    %esp,%ebp
  801093:	57                   	push   %edi
  801094:	56                   	push   %esi
  801095:	53                   	push   %ebx
  801096:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801099:	bb 00 00 00 00       	mov    $0x0,%ebx
  80109e:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010a4:	b8 08 00 00 00       	mov    $0x8,%eax
  8010a9:	89 df                	mov    %ebx,%edi
  8010ab:	89 de                	mov    %ebx,%esi
  8010ad:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010af:	85 c0                	test   %eax,%eax
  8010b1:	7f 08                	jg     8010bb <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8010b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010b6:	5b                   	pop    %ebx
  8010b7:	5e                   	pop    %esi
  8010b8:	5f                   	pop    %edi
  8010b9:	5d                   	pop    %ebp
  8010ba:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010bb:	83 ec 0c             	sub    $0xc,%esp
  8010be:	50                   	push   %eax
  8010bf:	6a 08                	push   $0x8
  8010c1:	68 44 2e 80 00       	push   $0x802e44
  8010c6:	6a 43                	push   $0x43
  8010c8:	68 61 2e 80 00       	push   $0x802e61
  8010cd:	e8 b0 f2 ff ff       	call   800382 <_panic>

008010d2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	57                   	push   %edi
  8010d6:	56                   	push   %esi
  8010d7:	53                   	push   %ebx
  8010d8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e6:	b8 09 00 00 00       	mov    $0x9,%eax
  8010eb:	89 df                	mov    %ebx,%edi
  8010ed:	89 de                	mov    %ebx,%esi
  8010ef:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010f1:	85 c0                	test   %eax,%eax
  8010f3:	7f 08                	jg     8010fd <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8010f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010f8:	5b                   	pop    %ebx
  8010f9:	5e                   	pop    %esi
  8010fa:	5f                   	pop    %edi
  8010fb:	5d                   	pop    %ebp
  8010fc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010fd:	83 ec 0c             	sub    $0xc,%esp
  801100:	50                   	push   %eax
  801101:	6a 09                	push   $0x9
  801103:	68 44 2e 80 00       	push   $0x802e44
  801108:	6a 43                	push   $0x43
  80110a:	68 61 2e 80 00       	push   $0x802e61
  80110f:	e8 6e f2 ff ff       	call   800382 <_panic>

00801114 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
  801117:	57                   	push   %edi
  801118:	56                   	push   %esi
  801119:	53                   	push   %ebx
  80111a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80111d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801122:	8b 55 08             	mov    0x8(%ebp),%edx
  801125:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801128:	b8 0a 00 00 00       	mov    $0xa,%eax
  80112d:	89 df                	mov    %ebx,%edi
  80112f:	89 de                	mov    %ebx,%esi
  801131:	cd 30                	int    $0x30
	if(check && ret > 0)
  801133:	85 c0                	test   %eax,%eax
  801135:	7f 08                	jg     80113f <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801137:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80113a:	5b                   	pop    %ebx
  80113b:	5e                   	pop    %esi
  80113c:	5f                   	pop    %edi
  80113d:	5d                   	pop    %ebp
  80113e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80113f:	83 ec 0c             	sub    $0xc,%esp
  801142:	50                   	push   %eax
  801143:	6a 0a                	push   $0xa
  801145:	68 44 2e 80 00       	push   $0x802e44
  80114a:	6a 43                	push   $0x43
  80114c:	68 61 2e 80 00       	push   $0x802e61
  801151:	e8 2c f2 ff ff       	call   800382 <_panic>

00801156 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
  801159:	57                   	push   %edi
  80115a:	56                   	push   %esi
  80115b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80115c:	8b 55 08             	mov    0x8(%ebp),%edx
  80115f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801162:	b8 0c 00 00 00       	mov    $0xc,%eax
  801167:	be 00 00 00 00       	mov    $0x0,%esi
  80116c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80116f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801172:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801174:	5b                   	pop    %ebx
  801175:	5e                   	pop    %esi
  801176:	5f                   	pop    %edi
  801177:	5d                   	pop    %ebp
  801178:	c3                   	ret    

00801179 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801179:	55                   	push   %ebp
  80117a:	89 e5                	mov    %esp,%ebp
  80117c:	57                   	push   %edi
  80117d:	56                   	push   %esi
  80117e:	53                   	push   %ebx
  80117f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801182:	b9 00 00 00 00       	mov    $0x0,%ecx
  801187:	8b 55 08             	mov    0x8(%ebp),%edx
  80118a:	b8 0d 00 00 00       	mov    $0xd,%eax
  80118f:	89 cb                	mov    %ecx,%ebx
  801191:	89 cf                	mov    %ecx,%edi
  801193:	89 ce                	mov    %ecx,%esi
  801195:	cd 30                	int    $0x30
	if(check && ret > 0)
  801197:	85 c0                	test   %eax,%eax
  801199:	7f 08                	jg     8011a3 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80119b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80119e:	5b                   	pop    %ebx
  80119f:	5e                   	pop    %esi
  8011a0:	5f                   	pop    %edi
  8011a1:	5d                   	pop    %ebp
  8011a2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011a3:	83 ec 0c             	sub    $0xc,%esp
  8011a6:	50                   	push   %eax
  8011a7:	6a 0d                	push   $0xd
  8011a9:	68 44 2e 80 00       	push   $0x802e44
  8011ae:	6a 43                	push   $0x43
  8011b0:	68 61 2e 80 00       	push   $0x802e61
  8011b5:	e8 c8 f1 ff ff       	call   800382 <_panic>

008011ba <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8011ba:	55                   	push   %ebp
  8011bb:	89 e5                	mov    %esp,%ebp
  8011bd:	57                   	push   %edi
  8011be:	56                   	push   %esi
  8011bf:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011c0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011cb:	b8 0e 00 00 00       	mov    $0xe,%eax
  8011d0:	89 df                	mov    %ebx,%edi
  8011d2:	89 de                	mov    %ebx,%esi
  8011d4:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8011d6:	5b                   	pop    %ebx
  8011d7:	5e                   	pop    %esi
  8011d8:	5f                   	pop    %edi
  8011d9:	5d                   	pop    %ebp
  8011da:	c3                   	ret    

008011db <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
  8011de:	57                   	push   %edi
  8011df:	56                   	push   %esi
  8011e0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011e1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e9:	b8 0f 00 00 00       	mov    $0xf,%eax
  8011ee:	89 cb                	mov    %ecx,%ebx
  8011f0:	89 cf                	mov    %ecx,%edi
  8011f2:	89 ce                	mov    %ecx,%esi
  8011f4:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8011f6:	5b                   	pop    %ebx
  8011f7:	5e                   	pop    %esi
  8011f8:	5f                   	pop    %edi
  8011f9:	5d                   	pop    %ebp
  8011fa:	c3                   	ret    

008011fb <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8011fb:	55                   	push   %ebp
  8011fc:	89 e5                	mov    %esp,%ebp
  8011fe:	57                   	push   %edi
  8011ff:	56                   	push   %esi
  801200:	53                   	push   %ebx
	asm volatile("int %1\n"
  801201:	ba 00 00 00 00       	mov    $0x0,%edx
  801206:	b8 10 00 00 00       	mov    $0x10,%eax
  80120b:	89 d1                	mov    %edx,%ecx
  80120d:	89 d3                	mov    %edx,%ebx
  80120f:	89 d7                	mov    %edx,%edi
  801211:	89 d6                	mov    %edx,%esi
  801213:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801215:	5b                   	pop    %ebx
  801216:	5e                   	pop    %esi
  801217:	5f                   	pop    %edi
  801218:	5d                   	pop    %ebp
  801219:	c3                   	ret    

0080121a <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  80121a:	55                   	push   %ebp
  80121b:	89 e5                	mov    %esp,%ebp
  80121d:	57                   	push   %edi
  80121e:	56                   	push   %esi
  80121f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801220:	bb 00 00 00 00       	mov    $0x0,%ebx
  801225:	8b 55 08             	mov    0x8(%ebp),%edx
  801228:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80122b:	b8 11 00 00 00       	mov    $0x11,%eax
  801230:	89 df                	mov    %ebx,%edi
  801232:	89 de                	mov    %ebx,%esi
  801234:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801236:	5b                   	pop    %ebx
  801237:	5e                   	pop    %esi
  801238:	5f                   	pop    %edi
  801239:	5d                   	pop    %ebp
  80123a:	c3                   	ret    

0080123b <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
  80123e:	57                   	push   %edi
  80123f:	56                   	push   %esi
  801240:	53                   	push   %ebx
	asm volatile("int %1\n"
  801241:	bb 00 00 00 00       	mov    $0x0,%ebx
  801246:	8b 55 08             	mov    0x8(%ebp),%edx
  801249:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80124c:	b8 12 00 00 00       	mov    $0x12,%eax
  801251:	89 df                	mov    %ebx,%edi
  801253:	89 de                	mov    %ebx,%esi
  801255:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801257:	5b                   	pop    %ebx
  801258:	5e                   	pop    %esi
  801259:	5f                   	pop    %edi
  80125a:	5d                   	pop    %ebp
  80125b:	c3                   	ret    

0080125c <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80125c:	55                   	push   %ebp
  80125d:	89 e5                	mov    %esp,%ebp
  80125f:	57                   	push   %edi
  801260:	56                   	push   %esi
  801261:	53                   	push   %ebx
  801262:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801265:	bb 00 00 00 00       	mov    $0x0,%ebx
  80126a:	8b 55 08             	mov    0x8(%ebp),%edx
  80126d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801270:	b8 13 00 00 00       	mov    $0x13,%eax
  801275:	89 df                	mov    %ebx,%edi
  801277:	89 de                	mov    %ebx,%esi
  801279:	cd 30                	int    $0x30
	if(check && ret > 0)
  80127b:	85 c0                	test   %eax,%eax
  80127d:	7f 08                	jg     801287 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80127f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801282:	5b                   	pop    %ebx
  801283:	5e                   	pop    %esi
  801284:	5f                   	pop    %edi
  801285:	5d                   	pop    %ebp
  801286:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801287:	83 ec 0c             	sub    $0xc,%esp
  80128a:	50                   	push   %eax
  80128b:	6a 13                	push   $0x13
  80128d:	68 44 2e 80 00       	push   $0x802e44
  801292:	6a 43                	push   $0x43
  801294:	68 61 2e 80 00       	push   $0x802e61
  801299:	e8 e4 f0 ff ff       	call   800382 <_panic>

0080129e <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  80129e:	55                   	push   %ebp
  80129f:	89 e5                	mov    %esp,%ebp
  8012a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012a7:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  8012aa:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  8012ac:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  8012af:	83 3a 01             	cmpl   $0x1,(%edx)
  8012b2:	7e 09                	jle    8012bd <argstart+0x1f>
  8012b4:	ba 77 2a 80 00       	mov    $0x802a77,%edx
  8012b9:	85 c9                	test   %ecx,%ecx
  8012bb:	75 05                	jne    8012c2 <argstart+0x24>
  8012bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8012c2:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  8012c5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  8012cc:	5d                   	pop    %ebp
  8012cd:	c3                   	ret    

008012ce <argnext>:

int
argnext(struct Argstate *args)
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	53                   	push   %ebx
  8012d2:	83 ec 04             	sub    $0x4,%esp
  8012d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  8012d8:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  8012df:	8b 43 08             	mov    0x8(%ebx),%eax
  8012e2:	85 c0                	test   %eax,%eax
  8012e4:	74 72                	je     801358 <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  8012e6:	80 38 00             	cmpb   $0x0,(%eax)
  8012e9:	75 48                	jne    801333 <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  8012eb:	8b 0b                	mov    (%ebx),%ecx
  8012ed:	83 39 01             	cmpl   $0x1,(%ecx)
  8012f0:	74 58                	je     80134a <argnext+0x7c>
		    || args->argv[1][0] != '-'
  8012f2:	8b 53 04             	mov    0x4(%ebx),%edx
  8012f5:	8b 42 04             	mov    0x4(%edx),%eax
  8012f8:	80 38 2d             	cmpb   $0x2d,(%eax)
  8012fb:	75 4d                	jne    80134a <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  8012fd:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801301:	74 47                	je     80134a <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801303:	83 c0 01             	add    $0x1,%eax
  801306:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801309:	83 ec 04             	sub    $0x4,%esp
  80130c:	8b 01                	mov    (%ecx),%eax
  80130e:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801315:	50                   	push   %eax
  801316:	8d 42 08             	lea    0x8(%edx),%eax
  801319:	50                   	push   %eax
  80131a:	83 c2 04             	add    $0x4,%edx
  80131d:	52                   	push   %edx
  80131e:	e8 42 fa ff ff       	call   800d65 <memmove>
		(*args->argc)--;
  801323:	8b 03                	mov    (%ebx),%eax
  801325:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801328:	8b 43 08             	mov    0x8(%ebx),%eax
  80132b:	83 c4 10             	add    $0x10,%esp
  80132e:	80 38 2d             	cmpb   $0x2d,(%eax)
  801331:	74 11                	je     801344 <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801333:	8b 53 08             	mov    0x8(%ebx),%edx
  801336:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  801339:	83 c2 01             	add    $0x1,%edx
  80133c:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  80133f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801342:	c9                   	leave  
  801343:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801344:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801348:	75 e9                	jne    801333 <argnext+0x65>
	args->curarg = 0;
  80134a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801351:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801356:	eb e7                	jmp    80133f <argnext+0x71>
		return -1;
  801358:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80135d:	eb e0                	jmp    80133f <argnext+0x71>

0080135f <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  80135f:	55                   	push   %ebp
  801360:	89 e5                	mov    %esp,%ebp
  801362:	53                   	push   %ebx
  801363:	83 ec 04             	sub    $0x4,%esp
  801366:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801369:	8b 43 08             	mov    0x8(%ebx),%eax
  80136c:	85 c0                	test   %eax,%eax
  80136e:	74 12                	je     801382 <argnextvalue+0x23>
		return 0;
	if (*args->curarg) {
  801370:	80 38 00             	cmpb   $0x0,(%eax)
  801373:	74 12                	je     801387 <argnextvalue+0x28>
		args->argvalue = args->curarg;
  801375:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801378:	c7 43 08 77 2a 80 00 	movl   $0x802a77,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  80137f:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  801382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801385:	c9                   	leave  
  801386:	c3                   	ret    
	} else if (*args->argc > 1) {
  801387:	8b 13                	mov    (%ebx),%edx
  801389:	83 3a 01             	cmpl   $0x1,(%edx)
  80138c:	7f 10                	jg     80139e <argnextvalue+0x3f>
		args->argvalue = 0;
  80138e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  801395:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  80139c:	eb e1                	jmp    80137f <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  80139e:	8b 43 04             	mov    0x4(%ebx),%eax
  8013a1:	8b 48 04             	mov    0x4(%eax),%ecx
  8013a4:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8013a7:	83 ec 04             	sub    $0x4,%esp
  8013aa:	8b 12                	mov    (%edx),%edx
  8013ac:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  8013b3:	52                   	push   %edx
  8013b4:	8d 50 08             	lea    0x8(%eax),%edx
  8013b7:	52                   	push   %edx
  8013b8:	83 c0 04             	add    $0x4,%eax
  8013bb:	50                   	push   %eax
  8013bc:	e8 a4 f9 ff ff       	call   800d65 <memmove>
		(*args->argc)--;
  8013c1:	8b 03                	mov    (%ebx),%eax
  8013c3:	83 28 01             	subl   $0x1,(%eax)
  8013c6:	83 c4 10             	add    $0x10,%esp
  8013c9:	eb b4                	jmp    80137f <argnextvalue+0x20>

008013cb <argvalue>:
{
  8013cb:	55                   	push   %ebp
  8013cc:	89 e5                	mov    %esp,%ebp
  8013ce:	83 ec 08             	sub    $0x8,%esp
  8013d1:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8013d4:	8b 42 0c             	mov    0xc(%edx),%eax
  8013d7:	85 c0                	test   %eax,%eax
  8013d9:	74 02                	je     8013dd <argvalue+0x12>
}
  8013db:	c9                   	leave  
  8013dc:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8013dd:	83 ec 0c             	sub    $0xc,%esp
  8013e0:	52                   	push   %edx
  8013e1:	e8 79 ff ff ff       	call   80135f <argnextvalue>
  8013e6:	83 c4 10             	add    $0x10,%esp
  8013e9:	eb f0                	jmp    8013db <argvalue+0x10>

008013eb <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f1:	05 00 00 00 30       	add    $0x30000000,%eax
  8013f6:	c1 e8 0c             	shr    $0xc,%eax
}
  8013f9:	5d                   	pop    %ebp
  8013fa:	c3                   	ret    

008013fb <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013fb:	55                   	push   %ebp
  8013fc:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801401:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801406:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80140b:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801410:	5d                   	pop    %ebp
  801411:	c3                   	ret    

00801412 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801412:	55                   	push   %ebp
  801413:	89 e5                	mov    %esp,%ebp
  801415:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80141a:	89 c2                	mov    %eax,%edx
  80141c:	c1 ea 16             	shr    $0x16,%edx
  80141f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801426:	f6 c2 01             	test   $0x1,%dl
  801429:	74 2d                	je     801458 <fd_alloc+0x46>
  80142b:	89 c2                	mov    %eax,%edx
  80142d:	c1 ea 0c             	shr    $0xc,%edx
  801430:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801437:	f6 c2 01             	test   $0x1,%dl
  80143a:	74 1c                	je     801458 <fd_alloc+0x46>
  80143c:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801441:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801446:	75 d2                	jne    80141a <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801448:	8b 45 08             	mov    0x8(%ebp),%eax
  80144b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801451:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801456:	eb 0a                	jmp    801462 <fd_alloc+0x50>
			*fd_store = fd;
  801458:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80145b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80145d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801462:	5d                   	pop    %ebp
  801463:	c3                   	ret    

00801464 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801464:	55                   	push   %ebp
  801465:	89 e5                	mov    %esp,%ebp
  801467:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80146a:	83 f8 1f             	cmp    $0x1f,%eax
  80146d:	77 30                	ja     80149f <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80146f:	c1 e0 0c             	shl    $0xc,%eax
  801472:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801477:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80147d:	f6 c2 01             	test   $0x1,%dl
  801480:	74 24                	je     8014a6 <fd_lookup+0x42>
  801482:	89 c2                	mov    %eax,%edx
  801484:	c1 ea 0c             	shr    $0xc,%edx
  801487:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80148e:	f6 c2 01             	test   $0x1,%dl
  801491:	74 1a                	je     8014ad <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801493:	8b 55 0c             	mov    0xc(%ebp),%edx
  801496:	89 02                	mov    %eax,(%edx)
	return 0;
  801498:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80149d:	5d                   	pop    %ebp
  80149e:	c3                   	ret    
		return -E_INVAL;
  80149f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014a4:	eb f7                	jmp    80149d <fd_lookup+0x39>
		return -E_INVAL;
  8014a6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014ab:	eb f0                	jmp    80149d <fd_lookup+0x39>
  8014ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014b2:	eb e9                	jmp    80149d <fd_lookup+0x39>

008014b4 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8014b4:	55                   	push   %ebp
  8014b5:	89 e5                	mov    %esp,%ebp
  8014b7:	83 ec 08             	sub    $0x8,%esp
  8014ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8014bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8014c2:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8014c7:	39 08                	cmp    %ecx,(%eax)
  8014c9:	74 38                	je     801503 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8014cb:	83 c2 01             	add    $0x1,%edx
  8014ce:	8b 04 95 f0 2e 80 00 	mov    0x802ef0(,%edx,4),%eax
  8014d5:	85 c0                	test   %eax,%eax
  8014d7:	75 ee                	jne    8014c7 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8014d9:	a1 20 44 80 00       	mov    0x804420,%eax
  8014de:	8b 40 48             	mov    0x48(%eax),%eax
  8014e1:	83 ec 04             	sub    $0x4,%esp
  8014e4:	51                   	push   %ecx
  8014e5:	50                   	push   %eax
  8014e6:	68 70 2e 80 00       	push   $0x802e70
  8014eb:	e8 88 ef ff ff       	call   800478 <cprintf>
	*dev = 0;
  8014f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8014f9:	83 c4 10             	add    $0x10,%esp
  8014fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801501:	c9                   	leave  
  801502:	c3                   	ret    
			*dev = devtab[i];
  801503:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801506:	89 01                	mov    %eax,(%ecx)
			return 0;
  801508:	b8 00 00 00 00       	mov    $0x0,%eax
  80150d:	eb f2                	jmp    801501 <dev_lookup+0x4d>

0080150f <fd_close>:
{
  80150f:	55                   	push   %ebp
  801510:	89 e5                	mov    %esp,%ebp
  801512:	57                   	push   %edi
  801513:	56                   	push   %esi
  801514:	53                   	push   %ebx
  801515:	83 ec 24             	sub    $0x24,%esp
  801518:	8b 75 08             	mov    0x8(%ebp),%esi
  80151b:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80151e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801521:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801522:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801528:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80152b:	50                   	push   %eax
  80152c:	e8 33 ff ff ff       	call   801464 <fd_lookup>
  801531:	89 c3                	mov    %eax,%ebx
  801533:	83 c4 10             	add    $0x10,%esp
  801536:	85 c0                	test   %eax,%eax
  801538:	78 05                	js     80153f <fd_close+0x30>
	    || fd != fd2)
  80153a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80153d:	74 16                	je     801555 <fd_close+0x46>
		return (must_exist ? r : 0);
  80153f:	89 f8                	mov    %edi,%eax
  801541:	84 c0                	test   %al,%al
  801543:	b8 00 00 00 00       	mov    $0x0,%eax
  801548:	0f 44 d8             	cmove  %eax,%ebx
}
  80154b:	89 d8                	mov    %ebx,%eax
  80154d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801550:	5b                   	pop    %ebx
  801551:	5e                   	pop    %esi
  801552:	5f                   	pop    %edi
  801553:	5d                   	pop    %ebp
  801554:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801555:	83 ec 08             	sub    $0x8,%esp
  801558:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80155b:	50                   	push   %eax
  80155c:	ff 36                	pushl  (%esi)
  80155e:	e8 51 ff ff ff       	call   8014b4 <dev_lookup>
  801563:	89 c3                	mov    %eax,%ebx
  801565:	83 c4 10             	add    $0x10,%esp
  801568:	85 c0                	test   %eax,%eax
  80156a:	78 1a                	js     801586 <fd_close+0x77>
		if (dev->dev_close)
  80156c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80156f:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801572:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801577:	85 c0                	test   %eax,%eax
  801579:	74 0b                	je     801586 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80157b:	83 ec 0c             	sub    $0xc,%esp
  80157e:	56                   	push   %esi
  80157f:	ff d0                	call   *%eax
  801581:	89 c3                	mov    %eax,%ebx
  801583:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801586:	83 ec 08             	sub    $0x8,%esp
  801589:	56                   	push   %esi
  80158a:	6a 00                	push   $0x0
  80158c:	e8 bd fa ff ff       	call   80104e <sys_page_unmap>
	return r;
  801591:	83 c4 10             	add    $0x10,%esp
  801594:	eb b5                	jmp    80154b <fd_close+0x3c>

00801596 <close>:

int
close(int fdnum)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
  801599:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80159c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80159f:	50                   	push   %eax
  8015a0:	ff 75 08             	pushl  0x8(%ebp)
  8015a3:	e8 bc fe ff ff       	call   801464 <fd_lookup>
  8015a8:	83 c4 10             	add    $0x10,%esp
  8015ab:	85 c0                	test   %eax,%eax
  8015ad:	79 02                	jns    8015b1 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8015af:	c9                   	leave  
  8015b0:	c3                   	ret    
		return fd_close(fd, 1);
  8015b1:	83 ec 08             	sub    $0x8,%esp
  8015b4:	6a 01                	push   $0x1
  8015b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8015b9:	e8 51 ff ff ff       	call   80150f <fd_close>
  8015be:	83 c4 10             	add    $0x10,%esp
  8015c1:	eb ec                	jmp    8015af <close+0x19>

008015c3 <close_all>:

void
close_all(void)
{
  8015c3:	55                   	push   %ebp
  8015c4:	89 e5                	mov    %esp,%ebp
  8015c6:	53                   	push   %ebx
  8015c7:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8015ca:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8015cf:	83 ec 0c             	sub    $0xc,%esp
  8015d2:	53                   	push   %ebx
  8015d3:	e8 be ff ff ff       	call   801596 <close>
	for (i = 0; i < MAXFD; i++)
  8015d8:	83 c3 01             	add    $0x1,%ebx
  8015db:	83 c4 10             	add    $0x10,%esp
  8015de:	83 fb 20             	cmp    $0x20,%ebx
  8015e1:	75 ec                	jne    8015cf <close_all+0xc>
}
  8015e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015e6:	c9                   	leave  
  8015e7:	c3                   	ret    

008015e8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015e8:	55                   	push   %ebp
  8015e9:	89 e5                	mov    %esp,%ebp
  8015eb:	57                   	push   %edi
  8015ec:	56                   	push   %esi
  8015ed:	53                   	push   %ebx
  8015ee:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015f1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015f4:	50                   	push   %eax
  8015f5:	ff 75 08             	pushl  0x8(%ebp)
  8015f8:	e8 67 fe ff ff       	call   801464 <fd_lookup>
  8015fd:	89 c3                	mov    %eax,%ebx
  8015ff:	83 c4 10             	add    $0x10,%esp
  801602:	85 c0                	test   %eax,%eax
  801604:	0f 88 81 00 00 00    	js     80168b <dup+0xa3>
		return r;
	close(newfdnum);
  80160a:	83 ec 0c             	sub    $0xc,%esp
  80160d:	ff 75 0c             	pushl  0xc(%ebp)
  801610:	e8 81 ff ff ff       	call   801596 <close>

	newfd = INDEX2FD(newfdnum);
  801615:	8b 75 0c             	mov    0xc(%ebp),%esi
  801618:	c1 e6 0c             	shl    $0xc,%esi
  80161b:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801621:	83 c4 04             	add    $0x4,%esp
  801624:	ff 75 e4             	pushl  -0x1c(%ebp)
  801627:	e8 cf fd ff ff       	call   8013fb <fd2data>
  80162c:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80162e:	89 34 24             	mov    %esi,(%esp)
  801631:	e8 c5 fd ff ff       	call   8013fb <fd2data>
  801636:	83 c4 10             	add    $0x10,%esp
  801639:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80163b:	89 d8                	mov    %ebx,%eax
  80163d:	c1 e8 16             	shr    $0x16,%eax
  801640:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801647:	a8 01                	test   $0x1,%al
  801649:	74 11                	je     80165c <dup+0x74>
  80164b:	89 d8                	mov    %ebx,%eax
  80164d:	c1 e8 0c             	shr    $0xc,%eax
  801650:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801657:	f6 c2 01             	test   $0x1,%dl
  80165a:	75 39                	jne    801695 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80165c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80165f:	89 d0                	mov    %edx,%eax
  801661:	c1 e8 0c             	shr    $0xc,%eax
  801664:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80166b:	83 ec 0c             	sub    $0xc,%esp
  80166e:	25 07 0e 00 00       	and    $0xe07,%eax
  801673:	50                   	push   %eax
  801674:	56                   	push   %esi
  801675:	6a 00                	push   $0x0
  801677:	52                   	push   %edx
  801678:	6a 00                	push   $0x0
  80167a:	e8 8d f9 ff ff       	call   80100c <sys_page_map>
  80167f:	89 c3                	mov    %eax,%ebx
  801681:	83 c4 20             	add    $0x20,%esp
  801684:	85 c0                	test   %eax,%eax
  801686:	78 31                	js     8016b9 <dup+0xd1>
		goto err;

	return newfdnum;
  801688:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80168b:	89 d8                	mov    %ebx,%eax
  80168d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801690:	5b                   	pop    %ebx
  801691:	5e                   	pop    %esi
  801692:	5f                   	pop    %edi
  801693:	5d                   	pop    %ebp
  801694:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801695:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80169c:	83 ec 0c             	sub    $0xc,%esp
  80169f:	25 07 0e 00 00       	and    $0xe07,%eax
  8016a4:	50                   	push   %eax
  8016a5:	57                   	push   %edi
  8016a6:	6a 00                	push   $0x0
  8016a8:	53                   	push   %ebx
  8016a9:	6a 00                	push   $0x0
  8016ab:	e8 5c f9 ff ff       	call   80100c <sys_page_map>
  8016b0:	89 c3                	mov    %eax,%ebx
  8016b2:	83 c4 20             	add    $0x20,%esp
  8016b5:	85 c0                	test   %eax,%eax
  8016b7:	79 a3                	jns    80165c <dup+0x74>
	sys_page_unmap(0, newfd);
  8016b9:	83 ec 08             	sub    $0x8,%esp
  8016bc:	56                   	push   %esi
  8016bd:	6a 00                	push   $0x0
  8016bf:	e8 8a f9 ff ff       	call   80104e <sys_page_unmap>
	sys_page_unmap(0, nva);
  8016c4:	83 c4 08             	add    $0x8,%esp
  8016c7:	57                   	push   %edi
  8016c8:	6a 00                	push   $0x0
  8016ca:	e8 7f f9 ff ff       	call   80104e <sys_page_unmap>
	return r;
  8016cf:	83 c4 10             	add    $0x10,%esp
  8016d2:	eb b7                	jmp    80168b <dup+0xa3>

008016d4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
  8016d7:	53                   	push   %ebx
  8016d8:	83 ec 1c             	sub    $0x1c,%esp
  8016db:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016de:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016e1:	50                   	push   %eax
  8016e2:	53                   	push   %ebx
  8016e3:	e8 7c fd ff ff       	call   801464 <fd_lookup>
  8016e8:	83 c4 10             	add    $0x10,%esp
  8016eb:	85 c0                	test   %eax,%eax
  8016ed:	78 3f                	js     80172e <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016ef:	83 ec 08             	sub    $0x8,%esp
  8016f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016f5:	50                   	push   %eax
  8016f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f9:	ff 30                	pushl  (%eax)
  8016fb:	e8 b4 fd ff ff       	call   8014b4 <dev_lookup>
  801700:	83 c4 10             	add    $0x10,%esp
  801703:	85 c0                	test   %eax,%eax
  801705:	78 27                	js     80172e <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801707:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80170a:	8b 42 08             	mov    0x8(%edx),%eax
  80170d:	83 e0 03             	and    $0x3,%eax
  801710:	83 f8 01             	cmp    $0x1,%eax
  801713:	74 1e                	je     801733 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801718:	8b 40 08             	mov    0x8(%eax),%eax
  80171b:	85 c0                	test   %eax,%eax
  80171d:	74 35                	je     801754 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80171f:	83 ec 04             	sub    $0x4,%esp
  801722:	ff 75 10             	pushl  0x10(%ebp)
  801725:	ff 75 0c             	pushl  0xc(%ebp)
  801728:	52                   	push   %edx
  801729:	ff d0                	call   *%eax
  80172b:	83 c4 10             	add    $0x10,%esp
}
  80172e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801731:	c9                   	leave  
  801732:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801733:	a1 20 44 80 00       	mov    0x804420,%eax
  801738:	8b 40 48             	mov    0x48(%eax),%eax
  80173b:	83 ec 04             	sub    $0x4,%esp
  80173e:	53                   	push   %ebx
  80173f:	50                   	push   %eax
  801740:	68 b4 2e 80 00       	push   $0x802eb4
  801745:	e8 2e ed ff ff       	call   800478 <cprintf>
		return -E_INVAL;
  80174a:	83 c4 10             	add    $0x10,%esp
  80174d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801752:	eb da                	jmp    80172e <read+0x5a>
		return -E_NOT_SUPP;
  801754:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801759:	eb d3                	jmp    80172e <read+0x5a>

0080175b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
  80175e:	57                   	push   %edi
  80175f:	56                   	push   %esi
  801760:	53                   	push   %ebx
  801761:	83 ec 0c             	sub    $0xc,%esp
  801764:	8b 7d 08             	mov    0x8(%ebp),%edi
  801767:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80176a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80176f:	39 f3                	cmp    %esi,%ebx
  801771:	73 23                	jae    801796 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801773:	83 ec 04             	sub    $0x4,%esp
  801776:	89 f0                	mov    %esi,%eax
  801778:	29 d8                	sub    %ebx,%eax
  80177a:	50                   	push   %eax
  80177b:	89 d8                	mov    %ebx,%eax
  80177d:	03 45 0c             	add    0xc(%ebp),%eax
  801780:	50                   	push   %eax
  801781:	57                   	push   %edi
  801782:	e8 4d ff ff ff       	call   8016d4 <read>
		if (m < 0)
  801787:	83 c4 10             	add    $0x10,%esp
  80178a:	85 c0                	test   %eax,%eax
  80178c:	78 06                	js     801794 <readn+0x39>
			return m;
		if (m == 0)
  80178e:	74 06                	je     801796 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801790:	01 c3                	add    %eax,%ebx
  801792:	eb db                	jmp    80176f <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801794:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801796:	89 d8                	mov    %ebx,%eax
  801798:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80179b:	5b                   	pop    %ebx
  80179c:	5e                   	pop    %esi
  80179d:	5f                   	pop    %edi
  80179e:	5d                   	pop    %ebp
  80179f:	c3                   	ret    

008017a0 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
  8017a3:	53                   	push   %ebx
  8017a4:	83 ec 1c             	sub    $0x1c,%esp
  8017a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017ad:	50                   	push   %eax
  8017ae:	53                   	push   %ebx
  8017af:	e8 b0 fc ff ff       	call   801464 <fd_lookup>
  8017b4:	83 c4 10             	add    $0x10,%esp
  8017b7:	85 c0                	test   %eax,%eax
  8017b9:	78 3a                	js     8017f5 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017bb:	83 ec 08             	sub    $0x8,%esp
  8017be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017c1:	50                   	push   %eax
  8017c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c5:	ff 30                	pushl  (%eax)
  8017c7:	e8 e8 fc ff ff       	call   8014b4 <dev_lookup>
  8017cc:	83 c4 10             	add    $0x10,%esp
  8017cf:	85 c0                	test   %eax,%eax
  8017d1:	78 22                	js     8017f5 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017da:	74 1e                	je     8017fa <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8017dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017df:	8b 52 0c             	mov    0xc(%edx),%edx
  8017e2:	85 d2                	test   %edx,%edx
  8017e4:	74 35                	je     80181b <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017e6:	83 ec 04             	sub    $0x4,%esp
  8017e9:	ff 75 10             	pushl  0x10(%ebp)
  8017ec:	ff 75 0c             	pushl  0xc(%ebp)
  8017ef:	50                   	push   %eax
  8017f0:	ff d2                	call   *%edx
  8017f2:	83 c4 10             	add    $0x10,%esp
}
  8017f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017fa:	a1 20 44 80 00       	mov    0x804420,%eax
  8017ff:	8b 40 48             	mov    0x48(%eax),%eax
  801802:	83 ec 04             	sub    $0x4,%esp
  801805:	53                   	push   %ebx
  801806:	50                   	push   %eax
  801807:	68 d0 2e 80 00       	push   $0x802ed0
  80180c:	e8 67 ec ff ff       	call   800478 <cprintf>
		return -E_INVAL;
  801811:	83 c4 10             	add    $0x10,%esp
  801814:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801819:	eb da                	jmp    8017f5 <write+0x55>
		return -E_NOT_SUPP;
  80181b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801820:	eb d3                	jmp    8017f5 <write+0x55>

00801822 <seek>:

int
seek(int fdnum, off_t offset)
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
  801825:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801828:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80182b:	50                   	push   %eax
  80182c:	ff 75 08             	pushl  0x8(%ebp)
  80182f:	e8 30 fc ff ff       	call   801464 <fd_lookup>
  801834:	83 c4 10             	add    $0x10,%esp
  801837:	85 c0                	test   %eax,%eax
  801839:	78 0e                	js     801849 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80183b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801841:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801844:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801849:	c9                   	leave  
  80184a:	c3                   	ret    

0080184b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
  80184e:	53                   	push   %ebx
  80184f:	83 ec 1c             	sub    $0x1c,%esp
  801852:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801855:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801858:	50                   	push   %eax
  801859:	53                   	push   %ebx
  80185a:	e8 05 fc ff ff       	call   801464 <fd_lookup>
  80185f:	83 c4 10             	add    $0x10,%esp
  801862:	85 c0                	test   %eax,%eax
  801864:	78 37                	js     80189d <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801866:	83 ec 08             	sub    $0x8,%esp
  801869:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80186c:	50                   	push   %eax
  80186d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801870:	ff 30                	pushl  (%eax)
  801872:	e8 3d fc ff ff       	call   8014b4 <dev_lookup>
  801877:	83 c4 10             	add    $0x10,%esp
  80187a:	85 c0                	test   %eax,%eax
  80187c:	78 1f                	js     80189d <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80187e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801881:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801885:	74 1b                	je     8018a2 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801887:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80188a:	8b 52 18             	mov    0x18(%edx),%edx
  80188d:	85 d2                	test   %edx,%edx
  80188f:	74 32                	je     8018c3 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801891:	83 ec 08             	sub    $0x8,%esp
  801894:	ff 75 0c             	pushl  0xc(%ebp)
  801897:	50                   	push   %eax
  801898:	ff d2                	call   *%edx
  80189a:	83 c4 10             	add    $0x10,%esp
}
  80189d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    
			thisenv->env_id, fdnum);
  8018a2:	a1 20 44 80 00       	mov    0x804420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8018a7:	8b 40 48             	mov    0x48(%eax),%eax
  8018aa:	83 ec 04             	sub    $0x4,%esp
  8018ad:	53                   	push   %ebx
  8018ae:	50                   	push   %eax
  8018af:	68 90 2e 80 00       	push   $0x802e90
  8018b4:	e8 bf eb ff ff       	call   800478 <cprintf>
		return -E_INVAL;
  8018b9:	83 c4 10             	add    $0x10,%esp
  8018bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018c1:	eb da                	jmp    80189d <ftruncate+0x52>
		return -E_NOT_SUPP;
  8018c3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018c8:	eb d3                	jmp    80189d <ftruncate+0x52>

008018ca <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
  8018cd:	53                   	push   %ebx
  8018ce:	83 ec 1c             	sub    $0x1c,%esp
  8018d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018d7:	50                   	push   %eax
  8018d8:	ff 75 08             	pushl  0x8(%ebp)
  8018db:	e8 84 fb ff ff       	call   801464 <fd_lookup>
  8018e0:	83 c4 10             	add    $0x10,%esp
  8018e3:	85 c0                	test   %eax,%eax
  8018e5:	78 4b                	js     801932 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018e7:	83 ec 08             	sub    $0x8,%esp
  8018ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ed:	50                   	push   %eax
  8018ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f1:	ff 30                	pushl  (%eax)
  8018f3:	e8 bc fb ff ff       	call   8014b4 <dev_lookup>
  8018f8:	83 c4 10             	add    $0x10,%esp
  8018fb:	85 c0                	test   %eax,%eax
  8018fd:	78 33                	js     801932 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8018ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801902:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801906:	74 2f                	je     801937 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801908:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80190b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801912:	00 00 00 
	stat->st_isdir = 0;
  801915:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80191c:	00 00 00 
	stat->st_dev = dev;
  80191f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801925:	83 ec 08             	sub    $0x8,%esp
  801928:	53                   	push   %ebx
  801929:	ff 75 f0             	pushl  -0x10(%ebp)
  80192c:	ff 50 14             	call   *0x14(%eax)
  80192f:	83 c4 10             	add    $0x10,%esp
}
  801932:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801935:	c9                   	leave  
  801936:	c3                   	ret    
		return -E_NOT_SUPP;
  801937:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80193c:	eb f4                	jmp    801932 <fstat+0x68>

0080193e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
  801941:	56                   	push   %esi
  801942:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801943:	83 ec 08             	sub    $0x8,%esp
  801946:	6a 00                	push   $0x0
  801948:	ff 75 08             	pushl  0x8(%ebp)
  80194b:	e8 22 02 00 00       	call   801b72 <open>
  801950:	89 c3                	mov    %eax,%ebx
  801952:	83 c4 10             	add    $0x10,%esp
  801955:	85 c0                	test   %eax,%eax
  801957:	78 1b                	js     801974 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801959:	83 ec 08             	sub    $0x8,%esp
  80195c:	ff 75 0c             	pushl  0xc(%ebp)
  80195f:	50                   	push   %eax
  801960:	e8 65 ff ff ff       	call   8018ca <fstat>
  801965:	89 c6                	mov    %eax,%esi
	close(fd);
  801967:	89 1c 24             	mov    %ebx,(%esp)
  80196a:	e8 27 fc ff ff       	call   801596 <close>
	return r;
  80196f:	83 c4 10             	add    $0x10,%esp
  801972:	89 f3                	mov    %esi,%ebx
}
  801974:	89 d8                	mov    %ebx,%eax
  801976:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801979:	5b                   	pop    %ebx
  80197a:	5e                   	pop    %esi
  80197b:	5d                   	pop    %ebp
  80197c:	c3                   	ret    

0080197d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
  801980:	56                   	push   %esi
  801981:	53                   	push   %ebx
  801982:	89 c6                	mov    %eax,%esi
  801984:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801986:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80198d:	74 27                	je     8019b6 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80198f:	6a 07                	push   $0x7
  801991:	68 00 50 80 00       	push   $0x805000
  801996:	56                   	push   %esi
  801997:	ff 35 00 40 80 00    	pushl  0x804000
  80199d:	e8 1c 0d 00 00       	call   8026be <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8019a2:	83 c4 0c             	add    $0xc,%esp
  8019a5:	6a 00                	push   $0x0
  8019a7:	53                   	push   %ebx
  8019a8:	6a 00                	push   $0x0
  8019aa:	e8 a6 0c 00 00       	call   802655 <ipc_recv>
}
  8019af:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019b2:	5b                   	pop    %ebx
  8019b3:	5e                   	pop    %esi
  8019b4:	5d                   	pop    %ebp
  8019b5:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8019b6:	83 ec 0c             	sub    $0xc,%esp
  8019b9:	6a 01                	push   $0x1
  8019bb:	e8 56 0d 00 00       	call   802716 <ipc_find_env>
  8019c0:	a3 00 40 80 00       	mov    %eax,0x804000
  8019c5:	83 c4 10             	add    $0x10,%esp
  8019c8:	eb c5                	jmp    80198f <fsipc+0x12>

008019ca <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
  8019cd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8019d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8019d6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8019db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019de:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8019e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e8:	b8 02 00 00 00       	mov    $0x2,%eax
  8019ed:	e8 8b ff ff ff       	call   80197d <fsipc>
}
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <devfile_flush>:
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
  8019f7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fd:	8b 40 0c             	mov    0xc(%eax),%eax
  801a00:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801a05:	ba 00 00 00 00       	mov    $0x0,%edx
  801a0a:	b8 06 00 00 00       	mov    $0x6,%eax
  801a0f:	e8 69 ff ff ff       	call   80197d <fsipc>
}
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    

00801a16 <devfile_stat>:
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
  801a19:	53                   	push   %ebx
  801a1a:	83 ec 04             	sub    $0x4,%esp
  801a1d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a20:	8b 45 08             	mov    0x8(%ebp),%eax
  801a23:	8b 40 0c             	mov    0xc(%eax),%eax
  801a26:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a2b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a30:	b8 05 00 00 00       	mov    $0x5,%eax
  801a35:	e8 43 ff ff ff       	call   80197d <fsipc>
  801a3a:	85 c0                	test   %eax,%eax
  801a3c:	78 2c                	js     801a6a <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a3e:	83 ec 08             	sub    $0x8,%esp
  801a41:	68 00 50 80 00       	push   $0x805000
  801a46:	53                   	push   %ebx
  801a47:	e8 8b f1 ff ff       	call   800bd7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a4c:	a1 80 50 80 00       	mov    0x805080,%eax
  801a51:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a57:	a1 84 50 80 00       	mov    0x805084,%eax
  801a5c:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a62:	83 c4 10             	add    $0x10,%esp
  801a65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a6d:	c9                   	leave  
  801a6e:	c3                   	ret    

00801a6f <devfile_write>:
{
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
  801a72:	53                   	push   %ebx
  801a73:	83 ec 08             	sub    $0x8,%esp
  801a76:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	8b 40 0c             	mov    0xc(%eax),%eax
  801a7f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801a84:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801a8a:	53                   	push   %ebx
  801a8b:	ff 75 0c             	pushl  0xc(%ebp)
  801a8e:	68 08 50 80 00       	push   $0x805008
  801a93:	e8 2f f3 ff ff       	call   800dc7 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801a98:	ba 00 00 00 00       	mov    $0x0,%edx
  801a9d:	b8 04 00 00 00       	mov    $0x4,%eax
  801aa2:	e8 d6 fe ff ff       	call   80197d <fsipc>
  801aa7:	83 c4 10             	add    $0x10,%esp
  801aaa:	85 c0                	test   %eax,%eax
  801aac:	78 0b                	js     801ab9 <devfile_write+0x4a>
	assert(r <= n);
  801aae:	39 d8                	cmp    %ebx,%eax
  801ab0:	77 0c                	ja     801abe <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801ab2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ab7:	7f 1e                	jg     801ad7 <devfile_write+0x68>
}
  801ab9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801abc:	c9                   	leave  
  801abd:	c3                   	ret    
	assert(r <= n);
  801abe:	68 04 2f 80 00       	push   $0x802f04
  801ac3:	68 0b 2f 80 00       	push   $0x802f0b
  801ac8:	68 98 00 00 00       	push   $0x98
  801acd:	68 20 2f 80 00       	push   $0x802f20
  801ad2:	e8 ab e8 ff ff       	call   800382 <_panic>
	assert(r <= PGSIZE);
  801ad7:	68 2b 2f 80 00       	push   $0x802f2b
  801adc:	68 0b 2f 80 00       	push   $0x802f0b
  801ae1:	68 99 00 00 00       	push   $0x99
  801ae6:	68 20 2f 80 00       	push   $0x802f20
  801aeb:	e8 92 e8 ff ff       	call   800382 <_panic>

00801af0 <devfile_read>:
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
  801af3:	56                   	push   %esi
  801af4:	53                   	push   %ebx
  801af5:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801af8:	8b 45 08             	mov    0x8(%ebp),%eax
  801afb:	8b 40 0c             	mov    0xc(%eax),%eax
  801afe:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801b03:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b09:	ba 00 00 00 00       	mov    $0x0,%edx
  801b0e:	b8 03 00 00 00       	mov    $0x3,%eax
  801b13:	e8 65 fe ff ff       	call   80197d <fsipc>
  801b18:	89 c3                	mov    %eax,%ebx
  801b1a:	85 c0                	test   %eax,%eax
  801b1c:	78 1f                	js     801b3d <devfile_read+0x4d>
	assert(r <= n);
  801b1e:	39 f0                	cmp    %esi,%eax
  801b20:	77 24                	ja     801b46 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801b22:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b27:	7f 33                	jg     801b5c <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b29:	83 ec 04             	sub    $0x4,%esp
  801b2c:	50                   	push   %eax
  801b2d:	68 00 50 80 00       	push   $0x805000
  801b32:	ff 75 0c             	pushl  0xc(%ebp)
  801b35:	e8 2b f2 ff ff       	call   800d65 <memmove>
	return r;
  801b3a:	83 c4 10             	add    $0x10,%esp
}
  801b3d:	89 d8                	mov    %ebx,%eax
  801b3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b42:	5b                   	pop    %ebx
  801b43:	5e                   	pop    %esi
  801b44:	5d                   	pop    %ebp
  801b45:	c3                   	ret    
	assert(r <= n);
  801b46:	68 04 2f 80 00       	push   $0x802f04
  801b4b:	68 0b 2f 80 00       	push   $0x802f0b
  801b50:	6a 7c                	push   $0x7c
  801b52:	68 20 2f 80 00       	push   $0x802f20
  801b57:	e8 26 e8 ff ff       	call   800382 <_panic>
	assert(r <= PGSIZE);
  801b5c:	68 2b 2f 80 00       	push   $0x802f2b
  801b61:	68 0b 2f 80 00       	push   $0x802f0b
  801b66:	6a 7d                	push   $0x7d
  801b68:	68 20 2f 80 00       	push   $0x802f20
  801b6d:	e8 10 e8 ff ff       	call   800382 <_panic>

00801b72 <open>:
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
  801b75:	56                   	push   %esi
  801b76:	53                   	push   %ebx
  801b77:	83 ec 1c             	sub    $0x1c,%esp
  801b7a:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b7d:	56                   	push   %esi
  801b7e:	e8 1b f0 ff ff       	call   800b9e <strlen>
  801b83:	83 c4 10             	add    $0x10,%esp
  801b86:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b8b:	7f 6c                	jg     801bf9 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801b8d:	83 ec 0c             	sub    $0xc,%esp
  801b90:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b93:	50                   	push   %eax
  801b94:	e8 79 f8 ff ff       	call   801412 <fd_alloc>
  801b99:	89 c3                	mov    %eax,%ebx
  801b9b:	83 c4 10             	add    $0x10,%esp
  801b9e:	85 c0                	test   %eax,%eax
  801ba0:	78 3c                	js     801bde <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801ba2:	83 ec 08             	sub    $0x8,%esp
  801ba5:	56                   	push   %esi
  801ba6:	68 00 50 80 00       	push   $0x805000
  801bab:	e8 27 f0 ff ff       	call   800bd7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb3:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801bb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bbb:	b8 01 00 00 00       	mov    $0x1,%eax
  801bc0:	e8 b8 fd ff ff       	call   80197d <fsipc>
  801bc5:	89 c3                	mov    %eax,%ebx
  801bc7:	83 c4 10             	add    $0x10,%esp
  801bca:	85 c0                	test   %eax,%eax
  801bcc:	78 19                	js     801be7 <open+0x75>
	return fd2num(fd);
  801bce:	83 ec 0c             	sub    $0xc,%esp
  801bd1:	ff 75 f4             	pushl  -0xc(%ebp)
  801bd4:	e8 12 f8 ff ff       	call   8013eb <fd2num>
  801bd9:	89 c3                	mov    %eax,%ebx
  801bdb:	83 c4 10             	add    $0x10,%esp
}
  801bde:	89 d8                	mov    %ebx,%eax
  801be0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801be3:	5b                   	pop    %ebx
  801be4:	5e                   	pop    %esi
  801be5:	5d                   	pop    %ebp
  801be6:	c3                   	ret    
		fd_close(fd, 0);
  801be7:	83 ec 08             	sub    $0x8,%esp
  801bea:	6a 00                	push   $0x0
  801bec:	ff 75 f4             	pushl  -0xc(%ebp)
  801bef:	e8 1b f9 ff ff       	call   80150f <fd_close>
		return r;
  801bf4:	83 c4 10             	add    $0x10,%esp
  801bf7:	eb e5                	jmp    801bde <open+0x6c>
		return -E_BAD_PATH;
  801bf9:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801bfe:	eb de                	jmp    801bde <open+0x6c>

00801c00 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
  801c03:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c06:	ba 00 00 00 00       	mov    $0x0,%edx
  801c0b:	b8 08 00 00 00       	mov    $0x8,%eax
  801c10:	e8 68 fd ff ff       	call   80197d <fsipc>
}
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801c17:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801c1b:	7f 01                	jg     801c1e <writebuf+0x7>
  801c1d:	c3                   	ret    
{
  801c1e:	55                   	push   %ebp
  801c1f:	89 e5                	mov    %esp,%ebp
  801c21:	53                   	push   %ebx
  801c22:	83 ec 08             	sub    $0x8,%esp
  801c25:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801c27:	ff 70 04             	pushl  0x4(%eax)
  801c2a:	8d 40 10             	lea    0x10(%eax),%eax
  801c2d:	50                   	push   %eax
  801c2e:	ff 33                	pushl  (%ebx)
  801c30:	e8 6b fb ff ff       	call   8017a0 <write>
		if (result > 0)
  801c35:	83 c4 10             	add    $0x10,%esp
  801c38:	85 c0                	test   %eax,%eax
  801c3a:	7e 03                	jle    801c3f <writebuf+0x28>
			b->result += result;
  801c3c:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801c3f:	39 43 04             	cmp    %eax,0x4(%ebx)
  801c42:	74 0d                	je     801c51 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801c44:	85 c0                	test   %eax,%eax
  801c46:	ba 00 00 00 00       	mov    $0x0,%edx
  801c4b:	0f 4f c2             	cmovg  %edx,%eax
  801c4e:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801c51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c54:	c9                   	leave  
  801c55:	c3                   	ret    

00801c56 <putch>:

static void
putch(int ch, void *thunk)
{
  801c56:	55                   	push   %ebp
  801c57:	89 e5                	mov    %esp,%ebp
  801c59:	53                   	push   %ebx
  801c5a:	83 ec 04             	sub    $0x4,%esp
  801c5d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801c60:	8b 53 04             	mov    0x4(%ebx),%edx
  801c63:	8d 42 01             	lea    0x1(%edx),%eax
  801c66:	89 43 04             	mov    %eax,0x4(%ebx)
  801c69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c6c:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801c70:	3d 00 01 00 00       	cmp    $0x100,%eax
  801c75:	74 06                	je     801c7d <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801c77:	83 c4 04             	add    $0x4,%esp
  801c7a:	5b                   	pop    %ebx
  801c7b:	5d                   	pop    %ebp
  801c7c:	c3                   	ret    
		writebuf(b);
  801c7d:	89 d8                	mov    %ebx,%eax
  801c7f:	e8 93 ff ff ff       	call   801c17 <writebuf>
		b->idx = 0;
  801c84:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801c8b:	eb ea                	jmp    801c77 <putch+0x21>

00801c8d <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
  801c90:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801c96:	8b 45 08             	mov    0x8(%ebp),%eax
  801c99:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801c9f:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801ca6:	00 00 00 
	b.result = 0;
  801ca9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801cb0:	00 00 00 
	b.error = 1;
  801cb3:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801cba:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801cbd:	ff 75 10             	pushl  0x10(%ebp)
  801cc0:	ff 75 0c             	pushl  0xc(%ebp)
  801cc3:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801cc9:	50                   	push   %eax
  801cca:	68 56 1c 80 00       	push   $0x801c56
  801ccf:	e8 d1 e8 ff ff       	call   8005a5 <vprintfmt>
	if (b.idx > 0)
  801cd4:	83 c4 10             	add    $0x10,%esp
  801cd7:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801cde:	7f 11                	jg     801cf1 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801ce0:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801ce6:	85 c0                	test   %eax,%eax
  801ce8:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801cef:	c9                   	leave  
  801cf0:	c3                   	ret    
		writebuf(&b);
  801cf1:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801cf7:	e8 1b ff ff ff       	call   801c17 <writebuf>
  801cfc:	eb e2                	jmp    801ce0 <vfprintf+0x53>

00801cfe <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
  801d01:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801d04:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801d07:	50                   	push   %eax
  801d08:	ff 75 0c             	pushl  0xc(%ebp)
  801d0b:	ff 75 08             	pushl  0x8(%ebp)
  801d0e:	e8 7a ff ff ff       	call   801c8d <vfprintf>
	va_end(ap);

	return cnt;
}
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <printf>:

int
printf(const char *fmt, ...)
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
  801d18:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801d1b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801d1e:	50                   	push   %eax
  801d1f:	ff 75 08             	pushl  0x8(%ebp)
  801d22:	6a 01                	push   $0x1
  801d24:	e8 64 ff ff ff       	call   801c8d <vfprintf>
	va_end(ap);

	return cnt;
}
  801d29:	c9                   	leave  
  801d2a:	c3                   	ret    

00801d2b <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
  801d2e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801d31:	68 37 2f 80 00       	push   $0x802f37
  801d36:	ff 75 0c             	pushl  0xc(%ebp)
  801d39:	e8 99 ee ff ff       	call   800bd7 <strcpy>
	return 0;
}
  801d3e:	b8 00 00 00 00       	mov    $0x0,%eax
  801d43:	c9                   	leave  
  801d44:	c3                   	ret    

00801d45 <devsock_close>:
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
  801d48:	53                   	push   %ebx
  801d49:	83 ec 10             	sub    $0x10,%esp
  801d4c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801d4f:	53                   	push   %ebx
  801d50:	e8 fc 09 00 00       	call   802751 <pageref>
  801d55:	83 c4 10             	add    $0x10,%esp
		return 0;
  801d58:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801d5d:	83 f8 01             	cmp    $0x1,%eax
  801d60:	74 07                	je     801d69 <devsock_close+0x24>
}
  801d62:	89 d0                	mov    %edx,%eax
  801d64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801d69:	83 ec 0c             	sub    $0xc,%esp
  801d6c:	ff 73 0c             	pushl  0xc(%ebx)
  801d6f:	e8 b9 02 00 00       	call   80202d <nsipc_close>
  801d74:	89 c2                	mov    %eax,%edx
  801d76:	83 c4 10             	add    $0x10,%esp
  801d79:	eb e7                	jmp    801d62 <devsock_close+0x1d>

00801d7b <devsock_write>:
{
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
  801d7e:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801d81:	6a 00                	push   $0x0
  801d83:	ff 75 10             	pushl  0x10(%ebp)
  801d86:	ff 75 0c             	pushl  0xc(%ebp)
  801d89:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8c:	ff 70 0c             	pushl  0xc(%eax)
  801d8f:	e8 76 03 00 00       	call   80210a <nsipc_send>
}
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <devsock_read>:
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
  801d99:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801d9c:	6a 00                	push   $0x0
  801d9e:	ff 75 10             	pushl  0x10(%ebp)
  801da1:	ff 75 0c             	pushl  0xc(%ebp)
  801da4:	8b 45 08             	mov    0x8(%ebp),%eax
  801da7:	ff 70 0c             	pushl  0xc(%eax)
  801daa:	e8 ef 02 00 00       	call   80209e <nsipc_recv>
}
  801daf:	c9                   	leave  
  801db0:	c3                   	ret    

00801db1 <fd2sockid>:
{
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
  801db4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801db7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801dba:	52                   	push   %edx
  801dbb:	50                   	push   %eax
  801dbc:	e8 a3 f6 ff ff       	call   801464 <fd_lookup>
  801dc1:	83 c4 10             	add    $0x10,%esp
  801dc4:	85 c0                	test   %eax,%eax
  801dc6:	78 10                	js     801dd8 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dcb:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801dd1:	39 08                	cmp    %ecx,(%eax)
  801dd3:	75 05                	jne    801dda <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801dd5:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801dd8:	c9                   	leave  
  801dd9:	c3                   	ret    
		return -E_NOT_SUPP;
  801dda:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ddf:	eb f7                	jmp    801dd8 <fd2sockid+0x27>

00801de1 <alloc_sockfd>:
{
  801de1:	55                   	push   %ebp
  801de2:	89 e5                	mov    %esp,%ebp
  801de4:	56                   	push   %esi
  801de5:	53                   	push   %ebx
  801de6:	83 ec 1c             	sub    $0x1c,%esp
  801de9:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801deb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dee:	50                   	push   %eax
  801def:	e8 1e f6 ff ff       	call   801412 <fd_alloc>
  801df4:	89 c3                	mov    %eax,%ebx
  801df6:	83 c4 10             	add    $0x10,%esp
  801df9:	85 c0                	test   %eax,%eax
  801dfb:	78 43                	js     801e40 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801dfd:	83 ec 04             	sub    $0x4,%esp
  801e00:	68 07 04 00 00       	push   $0x407
  801e05:	ff 75 f4             	pushl  -0xc(%ebp)
  801e08:	6a 00                	push   $0x0
  801e0a:	e8 ba f1 ff ff       	call   800fc9 <sys_page_alloc>
  801e0f:	89 c3                	mov    %eax,%ebx
  801e11:	83 c4 10             	add    $0x10,%esp
  801e14:	85 c0                	test   %eax,%eax
  801e16:	78 28                	js     801e40 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1b:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801e21:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e26:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801e2d:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801e30:	83 ec 0c             	sub    $0xc,%esp
  801e33:	50                   	push   %eax
  801e34:	e8 b2 f5 ff ff       	call   8013eb <fd2num>
  801e39:	89 c3                	mov    %eax,%ebx
  801e3b:	83 c4 10             	add    $0x10,%esp
  801e3e:	eb 0c                	jmp    801e4c <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801e40:	83 ec 0c             	sub    $0xc,%esp
  801e43:	56                   	push   %esi
  801e44:	e8 e4 01 00 00       	call   80202d <nsipc_close>
		return r;
  801e49:	83 c4 10             	add    $0x10,%esp
}
  801e4c:	89 d8                	mov    %ebx,%eax
  801e4e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e51:	5b                   	pop    %ebx
  801e52:	5e                   	pop    %esi
  801e53:	5d                   	pop    %ebp
  801e54:	c3                   	ret    

00801e55 <accept>:
{
  801e55:	55                   	push   %ebp
  801e56:	89 e5                	mov    %esp,%ebp
  801e58:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5e:	e8 4e ff ff ff       	call   801db1 <fd2sockid>
  801e63:	85 c0                	test   %eax,%eax
  801e65:	78 1b                	js     801e82 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e67:	83 ec 04             	sub    $0x4,%esp
  801e6a:	ff 75 10             	pushl  0x10(%ebp)
  801e6d:	ff 75 0c             	pushl  0xc(%ebp)
  801e70:	50                   	push   %eax
  801e71:	e8 0e 01 00 00       	call   801f84 <nsipc_accept>
  801e76:	83 c4 10             	add    $0x10,%esp
  801e79:	85 c0                	test   %eax,%eax
  801e7b:	78 05                	js     801e82 <accept+0x2d>
	return alloc_sockfd(r);
  801e7d:	e8 5f ff ff ff       	call   801de1 <alloc_sockfd>
}
  801e82:	c9                   	leave  
  801e83:	c3                   	ret    

00801e84 <bind>:
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
  801e87:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8d:	e8 1f ff ff ff       	call   801db1 <fd2sockid>
  801e92:	85 c0                	test   %eax,%eax
  801e94:	78 12                	js     801ea8 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801e96:	83 ec 04             	sub    $0x4,%esp
  801e99:	ff 75 10             	pushl  0x10(%ebp)
  801e9c:	ff 75 0c             	pushl  0xc(%ebp)
  801e9f:	50                   	push   %eax
  801ea0:	e8 31 01 00 00       	call   801fd6 <nsipc_bind>
  801ea5:	83 c4 10             	add    $0x10,%esp
}
  801ea8:	c9                   	leave  
  801ea9:	c3                   	ret    

00801eaa <shutdown>:
{
  801eaa:	55                   	push   %ebp
  801eab:	89 e5                	mov    %esp,%ebp
  801ead:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb3:	e8 f9 fe ff ff       	call   801db1 <fd2sockid>
  801eb8:	85 c0                	test   %eax,%eax
  801eba:	78 0f                	js     801ecb <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801ebc:	83 ec 08             	sub    $0x8,%esp
  801ebf:	ff 75 0c             	pushl  0xc(%ebp)
  801ec2:	50                   	push   %eax
  801ec3:	e8 43 01 00 00       	call   80200b <nsipc_shutdown>
  801ec8:	83 c4 10             	add    $0x10,%esp
}
  801ecb:	c9                   	leave  
  801ecc:	c3                   	ret    

00801ecd <connect>:
{
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
  801ed0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed6:	e8 d6 fe ff ff       	call   801db1 <fd2sockid>
  801edb:	85 c0                	test   %eax,%eax
  801edd:	78 12                	js     801ef1 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801edf:	83 ec 04             	sub    $0x4,%esp
  801ee2:	ff 75 10             	pushl  0x10(%ebp)
  801ee5:	ff 75 0c             	pushl  0xc(%ebp)
  801ee8:	50                   	push   %eax
  801ee9:	e8 59 01 00 00       	call   802047 <nsipc_connect>
  801eee:	83 c4 10             	add    $0x10,%esp
}
  801ef1:	c9                   	leave  
  801ef2:	c3                   	ret    

00801ef3 <listen>:
{
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
  801ef6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  801efc:	e8 b0 fe ff ff       	call   801db1 <fd2sockid>
  801f01:	85 c0                	test   %eax,%eax
  801f03:	78 0f                	js     801f14 <listen+0x21>
	return nsipc_listen(r, backlog);
  801f05:	83 ec 08             	sub    $0x8,%esp
  801f08:	ff 75 0c             	pushl  0xc(%ebp)
  801f0b:	50                   	push   %eax
  801f0c:	e8 6b 01 00 00       	call   80207c <nsipc_listen>
  801f11:	83 c4 10             	add    $0x10,%esp
}
  801f14:	c9                   	leave  
  801f15:	c3                   	ret    

00801f16 <socket>:

int
socket(int domain, int type, int protocol)
{
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
  801f19:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f1c:	ff 75 10             	pushl  0x10(%ebp)
  801f1f:	ff 75 0c             	pushl  0xc(%ebp)
  801f22:	ff 75 08             	pushl  0x8(%ebp)
  801f25:	e8 3e 02 00 00       	call   802168 <nsipc_socket>
  801f2a:	83 c4 10             	add    $0x10,%esp
  801f2d:	85 c0                	test   %eax,%eax
  801f2f:	78 05                	js     801f36 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801f31:	e8 ab fe ff ff       	call   801de1 <alloc_sockfd>
}
  801f36:	c9                   	leave  
  801f37:	c3                   	ret    

00801f38 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801f38:	55                   	push   %ebp
  801f39:	89 e5                	mov    %esp,%ebp
  801f3b:	53                   	push   %ebx
  801f3c:	83 ec 04             	sub    $0x4,%esp
  801f3f:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801f41:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801f48:	74 26                	je     801f70 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801f4a:	6a 07                	push   $0x7
  801f4c:	68 00 60 80 00       	push   $0x806000
  801f51:	53                   	push   %ebx
  801f52:	ff 35 04 40 80 00    	pushl  0x804004
  801f58:	e8 61 07 00 00       	call   8026be <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f5d:	83 c4 0c             	add    $0xc,%esp
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	e8 ea 06 00 00       	call   802655 <ipc_recv>
}
  801f6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f6e:	c9                   	leave  
  801f6f:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f70:	83 ec 0c             	sub    $0xc,%esp
  801f73:	6a 02                	push   $0x2
  801f75:	e8 9c 07 00 00       	call   802716 <ipc_find_env>
  801f7a:	a3 04 40 80 00       	mov    %eax,0x804004
  801f7f:	83 c4 10             	add    $0x10,%esp
  801f82:	eb c6                	jmp    801f4a <nsipc+0x12>

00801f84 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f84:	55                   	push   %ebp
  801f85:	89 e5                	mov    %esp,%ebp
  801f87:	56                   	push   %esi
  801f88:	53                   	push   %ebx
  801f89:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801f94:	8b 06                	mov    (%esi),%eax
  801f96:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f9b:	b8 01 00 00 00       	mov    $0x1,%eax
  801fa0:	e8 93 ff ff ff       	call   801f38 <nsipc>
  801fa5:	89 c3                	mov    %eax,%ebx
  801fa7:	85 c0                	test   %eax,%eax
  801fa9:	79 09                	jns    801fb4 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801fab:	89 d8                	mov    %ebx,%eax
  801fad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fb0:	5b                   	pop    %ebx
  801fb1:	5e                   	pop    %esi
  801fb2:	5d                   	pop    %ebp
  801fb3:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801fb4:	83 ec 04             	sub    $0x4,%esp
  801fb7:	ff 35 10 60 80 00    	pushl  0x806010
  801fbd:	68 00 60 80 00       	push   $0x806000
  801fc2:	ff 75 0c             	pushl  0xc(%ebp)
  801fc5:	e8 9b ed ff ff       	call   800d65 <memmove>
		*addrlen = ret->ret_addrlen;
  801fca:	a1 10 60 80 00       	mov    0x806010,%eax
  801fcf:	89 06                	mov    %eax,(%esi)
  801fd1:	83 c4 10             	add    $0x10,%esp
	return r;
  801fd4:	eb d5                	jmp    801fab <nsipc_accept+0x27>

00801fd6 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801fd6:	55                   	push   %ebp
  801fd7:	89 e5                	mov    %esp,%ebp
  801fd9:	53                   	push   %ebx
  801fda:	83 ec 08             	sub    $0x8,%esp
  801fdd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe3:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801fe8:	53                   	push   %ebx
  801fe9:	ff 75 0c             	pushl  0xc(%ebp)
  801fec:	68 04 60 80 00       	push   $0x806004
  801ff1:	e8 6f ed ff ff       	call   800d65 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801ff6:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801ffc:	b8 02 00 00 00       	mov    $0x2,%eax
  802001:	e8 32 ff ff ff       	call   801f38 <nsipc>
}
  802006:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802009:	c9                   	leave  
  80200a:	c3                   	ret    

0080200b <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80200b:	55                   	push   %ebp
  80200c:	89 e5                	mov    %esp,%ebp
  80200e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802011:	8b 45 08             	mov    0x8(%ebp),%eax
  802014:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  802019:	8b 45 0c             	mov    0xc(%ebp),%eax
  80201c:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802021:	b8 03 00 00 00       	mov    $0x3,%eax
  802026:	e8 0d ff ff ff       	call   801f38 <nsipc>
}
  80202b:	c9                   	leave  
  80202c:	c3                   	ret    

0080202d <nsipc_close>:

int
nsipc_close(int s)
{
  80202d:	55                   	push   %ebp
  80202e:	89 e5                	mov    %esp,%ebp
  802030:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802033:	8b 45 08             	mov    0x8(%ebp),%eax
  802036:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80203b:	b8 04 00 00 00       	mov    $0x4,%eax
  802040:	e8 f3 fe ff ff       	call   801f38 <nsipc>
}
  802045:	c9                   	leave  
  802046:	c3                   	ret    

00802047 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802047:	55                   	push   %ebp
  802048:	89 e5                	mov    %esp,%ebp
  80204a:	53                   	push   %ebx
  80204b:	83 ec 08             	sub    $0x8,%esp
  80204e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802051:	8b 45 08             	mov    0x8(%ebp),%eax
  802054:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802059:	53                   	push   %ebx
  80205a:	ff 75 0c             	pushl  0xc(%ebp)
  80205d:	68 04 60 80 00       	push   $0x806004
  802062:	e8 fe ec ff ff       	call   800d65 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802067:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  80206d:	b8 05 00 00 00       	mov    $0x5,%eax
  802072:	e8 c1 fe ff ff       	call   801f38 <nsipc>
}
  802077:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80207a:	c9                   	leave  
  80207b:	c3                   	ret    

0080207c <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80207c:	55                   	push   %ebp
  80207d:	89 e5                	mov    %esp,%ebp
  80207f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802082:	8b 45 08             	mov    0x8(%ebp),%eax
  802085:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80208a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80208d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802092:	b8 06 00 00 00       	mov    $0x6,%eax
  802097:	e8 9c fe ff ff       	call   801f38 <nsipc>
}
  80209c:	c9                   	leave  
  80209d:	c3                   	ret    

0080209e <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80209e:	55                   	push   %ebp
  80209f:	89 e5                	mov    %esp,%ebp
  8020a1:	56                   	push   %esi
  8020a2:	53                   	push   %ebx
  8020a3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8020a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8020ae:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8020b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8020b7:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8020bc:	b8 07 00 00 00       	mov    $0x7,%eax
  8020c1:	e8 72 fe ff ff       	call   801f38 <nsipc>
  8020c6:	89 c3                	mov    %eax,%ebx
  8020c8:	85 c0                	test   %eax,%eax
  8020ca:	78 1f                	js     8020eb <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8020cc:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8020d1:	7f 21                	jg     8020f4 <nsipc_recv+0x56>
  8020d3:	39 c6                	cmp    %eax,%esi
  8020d5:	7c 1d                	jl     8020f4 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8020d7:	83 ec 04             	sub    $0x4,%esp
  8020da:	50                   	push   %eax
  8020db:	68 00 60 80 00       	push   $0x806000
  8020e0:	ff 75 0c             	pushl  0xc(%ebp)
  8020e3:	e8 7d ec ff ff       	call   800d65 <memmove>
  8020e8:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8020eb:	89 d8                	mov    %ebx,%eax
  8020ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020f0:	5b                   	pop    %ebx
  8020f1:	5e                   	pop    %esi
  8020f2:	5d                   	pop    %ebp
  8020f3:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8020f4:	68 43 2f 80 00       	push   $0x802f43
  8020f9:	68 0b 2f 80 00       	push   $0x802f0b
  8020fe:	6a 62                	push   $0x62
  802100:	68 58 2f 80 00       	push   $0x802f58
  802105:	e8 78 e2 ff ff       	call   800382 <_panic>

0080210a <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80210a:	55                   	push   %ebp
  80210b:	89 e5                	mov    %esp,%ebp
  80210d:	53                   	push   %ebx
  80210e:	83 ec 04             	sub    $0x4,%esp
  802111:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802114:	8b 45 08             	mov    0x8(%ebp),%eax
  802117:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  80211c:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802122:	7f 2e                	jg     802152 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802124:	83 ec 04             	sub    $0x4,%esp
  802127:	53                   	push   %ebx
  802128:	ff 75 0c             	pushl  0xc(%ebp)
  80212b:	68 0c 60 80 00       	push   $0x80600c
  802130:	e8 30 ec ff ff       	call   800d65 <memmove>
	nsipcbuf.send.req_size = size;
  802135:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  80213b:	8b 45 14             	mov    0x14(%ebp),%eax
  80213e:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  802143:	b8 08 00 00 00       	mov    $0x8,%eax
  802148:	e8 eb fd ff ff       	call   801f38 <nsipc>
}
  80214d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802150:	c9                   	leave  
  802151:	c3                   	ret    
	assert(size < 1600);
  802152:	68 64 2f 80 00       	push   $0x802f64
  802157:	68 0b 2f 80 00       	push   $0x802f0b
  80215c:	6a 6d                	push   $0x6d
  80215e:	68 58 2f 80 00       	push   $0x802f58
  802163:	e8 1a e2 ff ff       	call   800382 <_panic>

00802168 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802168:	55                   	push   %ebp
  802169:	89 e5                	mov    %esp,%ebp
  80216b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80216e:	8b 45 08             	mov    0x8(%ebp),%eax
  802171:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802176:	8b 45 0c             	mov    0xc(%ebp),%eax
  802179:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80217e:	8b 45 10             	mov    0x10(%ebp),%eax
  802181:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802186:	b8 09 00 00 00       	mov    $0x9,%eax
  80218b:	e8 a8 fd ff ff       	call   801f38 <nsipc>
}
  802190:	c9                   	leave  
  802191:	c3                   	ret    

00802192 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802192:	55                   	push   %ebp
  802193:	89 e5                	mov    %esp,%ebp
  802195:	56                   	push   %esi
  802196:	53                   	push   %ebx
  802197:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80219a:	83 ec 0c             	sub    $0xc,%esp
  80219d:	ff 75 08             	pushl  0x8(%ebp)
  8021a0:	e8 56 f2 ff ff       	call   8013fb <fd2data>
  8021a5:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8021a7:	83 c4 08             	add    $0x8,%esp
  8021aa:	68 70 2f 80 00       	push   $0x802f70
  8021af:	53                   	push   %ebx
  8021b0:	e8 22 ea ff ff       	call   800bd7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8021b5:	8b 46 04             	mov    0x4(%esi),%eax
  8021b8:	2b 06                	sub    (%esi),%eax
  8021ba:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8021c0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8021c7:	00 00 00 
	stat->st_dev = &devpipe;
  8021ca:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  8021d1:	30 80 00 
	return 0;
}
  8021d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021dc:	5b                   	pop    %ebx
  8021dd:	5e                   	pop    %esi
  8021de:	5d                   	pop    %ebp
  8021df:	c3                   	ret    

008021e0 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8021e0:	55                   	push   %ebp
  8021e1:	89 e5                	mov    %esp,%ebp
  8021e3:	53                   	push   %ebx
  8021e4:	83 ec 0c             	sub    $0xc,%esp
  8021e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8021ea:	53                   	push   %ebx
  8021eb:	6a 00                	push   $0x0
  8021ed:	e8 5c ee ff ff       	call   80104e <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8021f2:	89 1c 24             	mov    %ebx,(%esp)
  8021f5:	e8 01 f2 ff ff       	call   8013fb <fd2data>
  8021fa:	83 c4 08             	add    $0x8,%esp
  8021fd:	50                   	push   %eax
  8021fe:	6a 00                	push   $0x0
  802200:	e8 49 ee ff ff       	call   80104e <sys_page_unmap>
}
  802205:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802208:	c9                   	leave  
  802209:	c3                   	ret    

0080220a <_pipeisclosed>:
{
  80220a:	55                   	push   %ebp
  80220b:	89 e5                	mov    %esp,%ebp
  80220d:	57                   	push   %edi
  80220e:	56                   	push   %esi
  80220f:	53                   	push   %ebx
  802210:	83 ec 1c             	sub    $0x1c,%esp
  802213:	89 c7                	mov    %eax,%edi
  802215:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802217:	a1 20 44 80 00       	mov    0x804420,%eax
  80221c:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80221f:	83 ec 0c             	sub    $0xc,%esp
  802222:	57                   	push   %edi
  802223:	e8 29 05 00 00       	call   802751 <pageref>
  802228:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80222b:	89 34 24             	mov    %esi,(%esp)
  80222e:	e8 1e 05 00 00       	call   802751 <pageref>
		nn = thisenv->env_runs;
  802233:	8b 15 20 44 80 00    	mov    0x804420,%edx
  802239:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80223c:	83 c4 10             	add    $0x10,%esp
  80223f:	39 cb                	cmp    %ecx,%ebx
  802241:	74 1b                	je     80225e <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802243:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802246:	75 cf                	jne    802217 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802248:	8b 42 58             	mov    0x58(%edx),%eax
  80224b:	6a 01                	push   $0x1
  80224d:	50                   	push   %eax
  80224e:	53                   	push   %ebx
  80224f:	68 77 2f 80 00       	push   $0x802f77
  802254:	e8 1f e2 ff ff       	call   800478 <cprintf>
  802259:	83 c4 10             	add    $0x10,%esp
  80225c:	eb b9                	jmp    802217 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80225e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802261:	0f 94 c0             	sete   %al
  802264:	0f b6 c0             	movzbl %al,%eax
}
  802267:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80226a:	5b                   	pop    %ebx
  80226b:	5e                   	pop    %esi
  80226c:	5f                   	pop    %edi
  80226d:	5d                   	pop    %ebp
  80226e:	c3                   	ret    

0080226f <devpipe_write>:
{
  80226f:	55                   	push   %ebp
  802270:	89 e5                	mov    %esp,%ebp
  802272:	57                   	push   %edi
  802273:	56                   	push   %esi
  802274:	53                   	push   %ebx
  802275:	83 ec 28             	sub    $0x28,%esp
  802278:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80227b:	56                   	push   %esi
  80227c:	e8 7a f1 ff ff       	call   8013fb <fd2data>
  802281:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802283:	83 c4 10             	add    $0x10,%esp
  802286:	bf 00 00 00 00       	mov    $0x0,%edi
  80228b:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80228e:	74 4f                	je     8022df <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802290:	8b 43 04             	mov    0x4(%ebx),%eax
  802293:	8b 0b                	mov    (%ebx),%ecx
  802295:	8d 51 20             	lea    0x20(%ecx),%edx
  802298:	39 d0                	cmp    %edx,%eax
  80229a:	72 14                	jb     8022b0 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80229c:	89 da                	mov    %ebx,%edx
  80229e:	89 f0                	mov    %esi,%eax
  8022a0:	e8 65 ff ff ff       	call   80220a <_pipeisclosed>
  8022a5:	85 c0                	test   %eax,%eax
  8022a7:	75 3b                	jne    8022e4 <devpipe_write+0x75>
			sys_yield();
  8022a9:	e8 fc ec ff ff       	call   800faa <sys_yield>
  8022ae:	eb e0                	jmp    802290 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8022b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022b3:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8022b7:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8022ba:	89 c2                	mov    %eax,%edx
  8022bc:	c1 fa 1f             	sar    $0x1f,%edx
  8022bf:	89 d1                	mov    %edx,%ecx
  8022c1:	c1 e9 1b             	shr    $0x1b,%ecx
  8022c4:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8022c7:	83 e2 1f             	and    $0x1f,%edx
  8022ca:	29 ca                	sub    %ecx,%edx
  8022cc:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8022d0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8022d4:	83 c0 01             	add    $0x1,%eax
  8022d7:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8022da:	83 c7 01             	add    $0x1,%edi
  8022dd:	eb ac                	jmp    80228b <devpipe_write+0x1c>
	return i;
  8022df:	8b 45 10             	mov    0x10(%ebp),%eax
  8022e2:	eb 05                	jmp    8022e9 <devpipe_write+0x7a>
				return 0;
  8022e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022ec:	5b                   	pop    %ebx
  8022ed:	5e                   	pop    %esi
  8022ee:	5f                   	pop    %edi
  8022ef:	5d                   	pop    %ebp
  8022f0:	c3                   	ret    

008022f1 <devpipe_read>:
{
  8022f1:	55                   	push   %ebp
  8022f2:	89 e5                	mov    %esp,%ebp
  8022f4:	57                   	push   %edi
  8022f5:	56                   	push   %esi
  8022f6:	53                   	push   %ebx
  8022f7:	83 ec 18             	sub    $0x18,%esp
  8022fa:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8022fd:	57                   	push   %edi
  8022fe:	e8 f8 f0 ff ff       	call   8013fb <fd2data>
  802303:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802305:	83 c4 10             	add    $0x10,%esp
  802308:	be 00 00 00 00       	mov    $0x0,%esi
  80230d:	3b 75 10             	cmp    0x10(%ebp),%esi
  802310:	75 14                	jne    802326 <devpipe_read+0x35>
	return i;
  802312:	8b 45 10             	mov    0x10(%ebp),%eax
  802315:	eb 02                	jmp    802319 <devpipe_read+0x28>
				return i;
  802317:	89 f0                	mov    %esi,%eax
}
  802319:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80231c:	5b                   	pop    %ebx
  80231d:	5e                   	pop    %esi
  80231e:	5f                   	pop    %edi
  80231f:	5d                   	pop    %ebp
  802320:	c3                   	ret    
			sys_yield();
  802321:	e8 84 ec ff ff       	call   800faa <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802326:	8b 03                	mov    (%ebx),%eax
  802328:	3b 43 04             	cmp    0x4(%ebx),%eax
  80232b:	75 18                	jne    802345 <devpipe_read+0x54>
			if (i > 0)
  80232d:	85 f6                	test   %esi,%esi
  80232f:	75 e6                	jne    802317 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802331:	89 da                	mov    %ebx,%edx
  802333:	89 f8                	mov    %edi,%eax
  802335:	e8 d0 fe ff ff       	call   80220a <_pipeisclosed>
  80233a:	85 c0                	test   %eax,%eax
  80233c:	74 e3                	je     802321 <devpipe_read+0x30>
				return 0;
  80233e:	b8 00 00 00 00       	mov    $0x0,%eax
  802343:	eb d4                	jmp    802319 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802345:	99                   	cltd   
  802346:	c1 ea 1b             	shr    $0x1b,%edx
  802349:	01 d0                	add    %edx,%eax
  80234b:	83 e0 1f             	and    $0x1f,%eax
  80234e:	29 d0                	sub    %edx,%eax
  802350:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802355:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802358:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80235b:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80235e:	83 c6 01             	add    $0x1,%esi
  802361:	eb aa                	jmp    80230d <devpipe_read+0x1c>

00802363 <pipe>:
{
  802363:	55                   	push   %ebp
  802364:	89 e5                	mov    %esp,%ebp
  802366:	56                   	push   %esi
  802367:	53                   	push   %ebx
  802368:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80236b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80236e:	50                   	push   %eax
  80236f:	e8 9e f0 ff ff       	call   801412 <fd_alloc>
  802374:	89 c3                	mov    %eax,%ebx
  802376:	83 c4 10             	add    $0x10,%esp
  802379:	85 c0                	test   %eax,%eax
  80237b:	0f 88 23 01 00 00    	js     8024a4 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802381:	83 ec 04             	sub    $0x4,%esp
  802384:	68 07 04 00 00       	push   $0x407
  802389:	ff 75 f4             	pushl  -0xc(%ebp)
  80238c:	6a 00                	push   $0x0
  80238e:	e8 36 ec ff ff       	call   800fc9 <sys_page_alloc>
  802393:	89 c3                	mov    %eax,%ebx
  802395:	83 c4 10             	add    $0x10,%esp
  802398:	85 c0                	test   %eax,%eax
  80239a:	0f 88 04 01 00 00    	js     8024a4 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8023a0:	83 ec 0c             	sub    $0xc,%esp
  8023a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8023a6:	50                   	push   %eax
  8023a7:	e8 66 f0 ff ff       	call   801412 <fd_alloc>
  8023ac:	89 c3                	mov    %eax,%ebx
  8023ae:	83 c4 10             	add    $0x10,%esp
  8023b1:	85 c0                	test   %eax,%eax
  8023b3:	0f 88 db 00 00 00    	js     802494 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023b9:	83 ec 04             	sub    $0x4,%esp
  8023bc:	68 07 04 00 00       	push   $0x407
  8023c1:	ff 75 f0             	pushl  -0x10(%ebp)
  8023c4:	6a 00                	push   $0x0
  8023c6:	e8 fe eb ff ff       	call   800fc9 <sys_page_alloc>
  8023cb:	89 c3                	mov    %eax,%ebx
  8023cd:	83 c4 10             	add    $0x10,%esp
  8023d0:	85 c0                	test   %eax,%eax
  8023d2:	0f 88 bc 00 00 00    	js     802494 <pipe+0x131>
	va = fd2data(fd0);
  8023d8:	83 ec 0c             	sub    $0xc,%esp
  8023db:	ff 75 f4             	pushl  -0xc(%ebp)
  8023de:	e8 18 f0 ff ff       	call   8013fb <fd2data>
  8023e3:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023e5:	83 c4 0c             	add    $0xc,%esp
  8023e8:	68 07 04 00 00       	push   $0x407
  8023ed:	50                   	push   %eax
  8023ee:	6a 00                	push   $0x0
  8023f0:	e8 d4 eb ff ff       	call   800fc9 <sys_page_alloc>
  8023f5:	89 c3                	mov    %eax,%ebx
  8023f7:	83 c4 10             	add    $0x10,%esp
  8023fa:	85 c0                	test   %eax,%eax
  8023fc:	0f 88 82 00 00 00    	js     802484 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802402:	83 ec 0c             	sub    $0xc,%esp
  802405:	ff 75 f0             	pushl  -0x10(%ebp)
  802408:	e8 ee ef ff ff       	call   8013fb <fd2data>
  80240d:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802414:	50                   	push   %eax
  802415:	6a 00                	push   $0x0
  802417:	56                   	push   %esi
  802418:	6a 00                	push   $0x0
  80241a:	e8 ed eb ff ff       	call   80100c <sys_page_map>
  80241f:	89 c3                	mov    %eax,%ebx
  802421:	83 c4 20             	add    $0x20,%esp
  802424:	85 c0                	test   %eax,%eax
  802426:	78 4e                	js     802476 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802428:	a1 3c 30 80 00       	mov    0x80303c,%eax
  80242d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802430:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802432:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802435:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80243c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80243f:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802441:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802444:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80244b:	83 ec 0c             	sub    $0xc,%esp
  80244e:	ff 75 f4             	pushl  -0xc(%ebp)
  802451:	e8 95 ef ff ff       	call   8013eb <fd2num>
  802456:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802459:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80245b:	83 c4 04             	add    $0x4,%esp
  80245e:	ff 75 f0             	pushl  -0x10(%ebp)
  802461:	e8 85 ef ff ff       	call   8013eb <fd2num>
  802466:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802469:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80246c:	83 c4 10             	add    $0x10,%esp
  80246f:	bb 00 00 00 00       	mov    $0x0,%ebx
  802474:	eb 2e                	jmp    8024a4 <pipe+0x141>
	sys_page_unmap(0, va);
  802476:	83 ec 08             	sub    $0x8,%esp
  802479:	56                   	push   %esi
  80247a:	6a 00                	push   $0x0
  80247c:	e8 cd eb ff ff       	call   80104e <sys_page_unmap>
  802481:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802484:	83 ec 08             	sub    $0x8,%esp
  802487:	ff 75 f0             	pushl  -0x10(%ebp)
  80248a:	6a 00                	push   $0x0
  80248c:	e8 bd eb ff ff       	call   80104e <sys_page_unmap>
  802491:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802494:	83 ec 08             	sub    $0x8,%esp
  802497:	ff 75 f4             	pushl  -0xc(%ebp)
  80249a:	6a 00                	push   $0x0
  80249c:	e8 ad eb ff ff       	call   80104e <sys_page_unmap>
  8024a1:	83 c4 10             	add    $0x10,%esp
}
  8024a4:	89 d8                	mov    %ebx,%eax
  8024a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024a9:	5b                   	pop    %ebx
  8024aa:	5e                   	pop    %esi
  8024ab:	5d                   	pop    %ebp
  8024ac:	c3                   	ret    

008024ad <pipeisclosed>:
{
  8024ad:	55                   	push   %ebp
  8024ae:	89 e5                	mov    %esp,%ebp
  8024b0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024b6:	50                   	push   %eax
  8024b7:	ff 75 08             	pushl  0x8(%ebp)
  8024ba:	e8 a5 ef ff ff       	call   801464 <fd_lookup>
  8024bf:	83 c4 10             	add    $0x10,%esp
  8024c2:	85 c0                	test   %eax,%eax
  8024c4:	78 18                	js     8024de <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8024c6:	83 ec 0c             	sub    $0xc,%esp
  8024c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8024cc:	e8 2a ef ff ff       	call   8013fb <fd2data>
	return _pipeisclosed(fd, p);
  8024d1:	89 c2                	mov    %eax,%edx
  8024d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d6:	e8 2f fd ff ff       	call   80220a <_pipeisclosed>
  8024db:	83 c4 10             	add    $0x10,%esp
}
  8024de:	c9                   	leave  
  8024df:	c3                   	ret    

008024e0 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8024e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e5:	c3                   	ret    

008024e6 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8024e6:	55                   	push   %ebp
  8024e7:	89 e5                	mov    %esp,%ebp
  8024e9:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8024ec:	68 8f 2f 80 00       	push   $0x802f8f
  8024f1:	ff 75 0c             	pushl  0xc(%ebp)
  8024f4:	e8 de e6 ff ff       	call   800bd7 <strcpy>
	return 0;
}
  8024f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8024fe:	c9                   	leave  
  8024ff:	c3                   	ret    

00802500 <devcons_write>:
{
  802500:	55                   	push   %ebp
  802501:	89 e5                	mov    %esp,%ebp
  802503:	57                   	push   %edi
  802504:	56                   	push   %esi
  802505:	53                   	push   %ebx
  802506:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80250c:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802511:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802517:	3b 75 10             	cmp    0x10(%ebp),%esi
  80251a:	73 31                	jae    80254d <devcons_write+0x4d>
		m = n - tot;
  80251c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80251f:	29 f3                	sub    %esi,%ebx
  802521:	83 fb 7f             	cmp    $0x7f,%ebx
  802524:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802529:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80252c:	83 ec 04             	sub    $0x4,%esp
  80252f:	53                   	push   %ebx
  802530:	89 f0                	mov    %esi,%eax
  802532:	03 45 0c             	add    0xc(%ebp),%eax
  802535:	50                   	push   %eax
  802536:	57                   	push   %edi
  802537:	e8 29 e8 ff ff       	call   800d65 <memmove>
		sys_cputs(buf, m);
  80253c:	83 c4 08             	add    $0x8,%esp
  80253f:	53                   	push   %ebx
  802540:	57                   	push   %edi
  802541:	e8 c7 e9 ff ff       	call   800f0d <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802546:	01 de                	add    %ebx,%esi
  802548:	83 c4 10             	add    $0x10,%esp
  80254b:	eb ca                	jmp    802517 <devcons_write+0x17>
}
  80254d:	89 f0                	mov    %esi,%eax
  80254f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802552:	5b                   	pop    %ebx
  802553:	5e                   	pop    %esi
  802554:	5f                   	pop    %edi
  802555:	5d                   	pop    %ebp
  802556:	c3                   	ret    

00802557 <devcons_read>:
{
  802557:	55                   	push   %ebp
  802558:	89 e5                	mov    %esp,%ebp
  80255a:	83 ec 08             	sub    $0x8,%esp
  80255d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802562:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802566:	74 21                	je     802589 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802568:	e8 be e9 ff ff       	call   800f2b <sys_cgetc>
  80256d:	85 c0                	test   %eax,%eax
  80256f:	75 07                	jne    802578 <devcons_read+0x21>
		sys_yield();
  802571:	e8 34 ea ff ff       	call   800faa <sys_yield>
  802576:	eb f0                	jmp    802568 <devcons_read+0x11>
	if (c < 0)
  802578:	78 0f                	js     802589 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80257a:	83 f8 04             	cmp    $0x4,%eax
  80257d:	74 0c                	je     80258b <devcons_read+0x34>
	*(char*)vbuf = c;
  80257f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802582:	88 02                	mov    %al,(%edx)
	return 1;
  802584:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802589:	c9                   	leave  
  80258a:	c3                   	ret    
		return 0;
  80258b:	b8 00 00 00 00       	mov    $0x0,%eax
  802590:	eb f7                	jmp    802589 <devcons_read+0x32>

00802592 <cputchar>:
{
  802592:	55                   	push   %ebp
  802593:	89 e5                	mov    %esp,%ebp
  802595:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802598:	8b 45 08             	mov    0x8(%ebp),%eax
  80259b:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80259e:	6a 01                	push   $0x1
  8025a0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025a3:	50                   	push   %eax
  8025a4:	e8 64 e9 ff ff       	call   800f0d <sys_cputs>
}
  8025a9:	83 c4 10             	add    $0x10,%esp
  8025ac:	c9                   	leave  
  8025ad:	c3                   	ret    

008025ae <getchar>:
{
  8025ae:	55                   	push   %ebp
  8025af:	89 e5                	mov    %esp,%ebp
  8025b1:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8025b4:	6a 01                	push   $0x1
  8025b6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025b9:	50                   	push   %eax
  8025ba:	6a 00                	push   $0x0
  8025bc:	e8 13 f1 ff ff       	call   8016d4 <read>
	if (r < 0)
  8025c1:	83 c4 10             	add    $0x10,%esp
  8025c4:	85 c0                	test   %eax,%eax
  8025c6:	78 06                	js     8025ce <getchar+0x20>
	if (r < 1)
  8025c8:	74 06                	je     8025d0 <getchar+0x22>
	return c;
  8025ca:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8025ce:	c9                   	leave  
  8025cf:	c3                   	ret    
		return -E_EOF;
  8025d0:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8025d5:	eb f7                	jmp    8025ce <getchar+0x20>

008025d7 <iscons>:
{
  8025d7:	55                   	push   %ebp
  8025d8:	89 e5                	mov    %esp,%ebp
  8025da:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025e0:	50                   	push   %eax
  8025e1:	ff 75 08             	pushl  0x8(%ebp)
  8025e4:	e8 7b ee ff ff       	call   801464 <fd_lookup>
  8025e9:	83 c4 10             	add    $0x10,%esp
  8025ec:	85 c0                	test   %eax,%eax
  8025ee:	78 11                	js     802601 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8025f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f3:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8025f9:	39 10                	cmp    %edx,(%eax)
  8025fb:	0f 94 c0             	sete   %al
  8025fe:	0f b6 c0             	movzbl %al,%eax
}
  802601:	c9                   	leave  
  802602:	c3                   	ret    

00802603 <opencons>:
{
  802603:	55                   	push   %ebp
  802604:	89 e5                	mov    %esp,%ebp
  802606:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802609:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80260c:	50                   	push   %eax
  80260d:	e8 00 ee ff ff       	call   801412 <fd_alloc>
  802612:	83 c4 10             	add    $0x10,%esp
  802615:	85 c0                	test   %eax,%eax
  802617:	78 3a                	js     802653 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802619:	83 ec 04             	sub    $0x4,%esp
  80261c:	68 07 04 00 00       	push   $0x407
  802621:	ff 75 f4             	pushl  -0xc(%ebp)
  802624:	6a 00                	push   $0x0
  802626:	e8 9e e9 ff ff       	call   800fc9 <sys_page_alloc>
  80262b:	83 c4 10             	add    $0x10,%esp
  80262e:	85 c0                	test   %eax,%eax
  802630:	78 21                	js     802653 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802635:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80263b:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80263d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802640:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802647:	83 ec 0c             	sub    $0xc,%esp
  80264a:	50                   	push   %eax
  80264b:	e8 9b ed ff ff       	call   8013eb <fd2num>
  802650:	83 c4 10             	add    $0x10,%esp
}
  802653:	c9                   	leave  
  802654:	c3                   	ret    

00802655 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802655:	55                   	push   %ebp
  802656:	89 e5                	mov    %esp,%ebp
  802658:	56                   	push   %esi
  802659:	53                   	push   %ebx
  80265a:	8b 75 08             	mov    0x8(%ebp),%esi
  80265d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802660:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802663:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802665:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80266a:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80266d:	83 ec 0c             	sub    $0xc,%esp
  802670:	50                   	push   %eax
  802671:	e8 03 eb ff ff       	call   801179 <sys_ipc_recv>
	if(ret < 0){
  802676:	83 c4 10             	add    $0x10,%esp
  802679:	85 c0                	test   %eax,%eax
  80267b:	78 2b                	js     8026a8 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80267d:	85 f6                	test   %esi,%esi
  80267f:	74 0a                	je     80268b <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  802681:	a1 20 44 80 00       	mov    0x804420,%eax
  802686:	8b 40 74             	mov    0x74(%eax),%eax
  802689:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80268b:	85 db                	test   %ebx,%ebx
  80268d:	74 0a                	je     802699 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  80268f:	a1 20 44 80 00       	mov    0x804420,%eax
  802694:	8b 40 78             	mov    0x78(%eax),%eax
  802697:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  802699:	a1 20 44 80 00       	mov    0x804420,%eax
  80269e:	8b 40 70             	mov    0x70(%eax),%eax
}
  8026a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026a4:	5b                   	pop    %ebx
  8026a5:	5e                   	pop    %esi
  8026a6:	5d                   	pop    %ebp
  8026a7:	c3                   	ret    
		if(from_env_store)
  8026a8:	85 f6                	test   %esi,%esi
  8026aa:	74 06                	je     8026b2 <ipc_recv+0x5d>
			*from_env_store = 0;
  8026ac:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8026b2:	85 db                	test   %ebx,%ebx
  8026b4:	74 eb                	je     8026a1 <ipc_recv+0x4c>
			*perm_store = 0;
  8026b6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8026bc:	eb e3                	jmp    8026a1 <ipc_recv+0x4c>

008026be <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8026be:	55                   	push   %ebp
  8026bf:	89 e5                	mov    %esp,%ebp
  8026c1:	57                   	push   %edi
  8026c2:	56                   	push   %esi
  8026c3:	53                   	push   %ebx
  8026c4:	83 ec 0c             	sub    $0xc,%esp
  8026c7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8026ca:	8b 75 0c             	mov    0xc(%ebp),%esi
  8026cd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8026d0:	85 db                	test   %ebx,%ebx
  8026d2:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8026d7:	0f 44 d8             	cmove  %eax,%ebx
  8026da:	eb 05                	jmp    8026e1 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8026dc:	e8 c9 e8 ff ff       	call   800faa <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8026e1:	ff 75 14             	pushl  0x14(%ebp)
  8026e4:	53                   	push   %ebx
  8026e5:	56                   	push   %esi
  8026e6:	57                   	push   %edi
  8026e7:	e8 6a ea ff ff       	call   801156 <sys_ipc_try_send>
  8026ec:	83 c4 10             	add    $0x10,%esp
  8026ef:	85 c0                	test   %eax,%eax
  8026f1:	74 1b                	je     80270e <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8026f3:	79 e7                	jns    8026dc <ipc_send+0x1e>
  8026f5:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8026f8:	74 e2                	je     8026dc <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8026fa:	83 ec 04             	sub    $0x4,%esp
  8026fd:	68 9b 2f 80 00       	push   $0x802f9b
  802702:	6a 48                	push   $0x48
  802704:	68 b0 2f 80 00       	push   $0x802fb0
  802709:	e8 74 dc ff ff       	call   800382 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80270e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802711:	5b                   	pop    %ebx
  802712:	5e                   	pop    %esi
  802713:	5f                   	pop    %edi
  802714:	5d                   	pop    %ebp
  802715:	c3                   	ret    

00802716 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802716:	55                   	push   %ebp
  802717:	89 e5                	mov    %esp,%ebp
  802719:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80271c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802721:	89 c2                	mov    %eax,%edx
  802723:	c1 e2 07             	shl    $0x7,%edx
  802726:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80272c:	8b 52 50             	mov    0x50(%edx),%edx
  80272f:	39 ca                	cmp    %ecx,%edx
  802731:	74 11                	je     802744 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802733:	83 c0 01             	add    $0x1,%eax
  802736:	3d 00 04 00 00       	cmp    $0x400,%eax
  80273b:	75 e4                	jne    802721 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80273d:	b8 00 00 00 00       	mov    $0x0,%eax
  802742:	eb 0b                	jmp    80274f <ipc_find_env+0x39>
			return envs[i].env_id;
  802744:	c1 e0 07             	shl    $0x7,%eax
  802747:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80274c:	8b 40 48             	mov    0x48(%eax),%eax
}
  80274f:	5d                   	pop    %ebp
  802750:	c3                   	ret    

00802751 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802751:	55                   	push   %ebp
  802752:	89 e5                	mov    %esp,%ebp
  802754:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802757:	89 d0                	mov    %edx,%eax
  802759:	c1 e8 16             	shr    $0x16,%eax
  80275c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802763:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802768:	f6 c1 01             	test   $0x1,%cl
  80276b:	74 1d                	je     80278a <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80276d:	c1 ea 0c             	shr    $0xc,%edx
  802770:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802777:	f6 c2 01             	test   $0x1,%dl
  80277a:	74 0e                	je     80278a <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80277c:	c1 ea 0c             	shr    $0xc,%edx
  80277f:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802786:	ef 
  802787:	0f b7 c0             	movzwl %ax,%eax
}
  80278a:	5d                   	pop    %ebp
  80278b:	c3                   	ret    
  80278c:	66 90                	xchg   %ax,%ax
  80278e:	66 90                	xchg   %ax,%ax

00802790 <__udivdi3>:
  802790:	55                   	push   %ebp
  802791:	57                   	push   %edi
  802792:	56                   	push   %esi
  802793:	53                   	push   %ebx
  802794:	83 ec 1c             	sub    $0x1c,%esp
  802797:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80279b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80279f:	8b 74 24 34          	mov    0x34(%esp),%esi
  8027a3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8027a7:	85 d2                	test   %edx,%edx
  8027a9:	75 4d                	jne    8027f8 <__udivdi3+0x68>
  8027ab:	39 f3                	cmp    %esi,%ebx
  8027ad:	76 19                	jbe    8027c8 <__udivdi3+0x38>
  8027af:	31 ff                	xor    %edi,%edi
  8027b1:	89 e8                	mov    %ebp,%eax
  8027b3:	89 f2                	mov    %esi,%edx
  8027b5:	f7 f3                	div    %ebx
  8027b7:	89 fa                	mov    %edi,%edx
  8027b9:	83 c4 1c             	add    $0x1c,%esp
  8027bc:	5b                   	pop    %ebx
  8027bd:	5e                   	pop    %esi
  8027be:	5f                   	pop    %edi
  8027bf:	5d                   	pop    %ebp
  8027c0:	c3                   	ret    
  8027c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027c8:	89 d9                	mov    %ebx,%ecx
  8027ca:	85 db                	test   %ebx,%ebx
  8027cc:	75 0b                	jne    8027d9 <__udivdi3+0x49>
  8027ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8027d3:	31 d2                	xor    %edx,%edx
  8027d5:	f7 f3                	div    %ebx
  8027d7:	89 c1                	mov    %eax,%ecx
  8027d9:	31 d2                	xor    %edx,%edx
  8027db:	89 f0                	mov    %esi,%eax
  8027dd:	f7 f1                	div    %ecx
  8027df:	89 c6                	mov    %eax,%esi
  8027e1:	89 e8                	mov    %ebp,%eax
  8027e3:	89 f7                	mov    %esi,%edi
  8027e5:	f7 f1                	div    %ecx
  8027e7:	89 fa                	mov    %edi,%edx
  8027e9:	83 c4 1c             	add    $0x1c,%esp
  8027ec:	5b                   	pop    %ebx
  8027ed:	5e                   	pop    %esi
  8027ee:	5f                   	pop    %edi
  8027ef:	5d                   	pop    %ebp
  8027f0:	c3                   	ret    
  8027f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027f8:	39 f2                	cmp    %esi,%edx
  8027fa:	77 1c                	ja     802818 <__udivdi3+0x88>
  8027fc:	0f bd fa             	bsr    %edx,%edi
  8027ff:	83 f7 1f             	xor    $0x1f,%edi
  802802:	75 2c                	jne    802830 <__udivdi3+0xa0>
  802804:	39 f2                	cmp    %esi,%edx
  802806:	72 06                	jb     80280e <__udivdi3+0x7e>
  802808:	31 c0                	xor    %eax,%eax
  80280a:	39 eb                	cmp    %ebp,%ebx
  80280c:	77 a9                	ja     8027b7 <__udivdi3+0x27>
  80280e:	b8 01 00 00 00       	mov    $0x1,%eax
  802813:	eb a2                	jmp    8027b7 <__udivdi3+0x27>
  802815:	8d 76 00             	lea    0x0(%esi),%esi
  802818:	31 ff                	xor    %edi,%edi
  80281a:	31 c0                	xor    %eax,%eax
  80281c:	89 fa                	mov    %edi,%edx
  80281e:	83 c4 1c             	add    $0x1c,%esp
  802821:	5b                   	pop    %ebx
  802822:	5e                   	pop    %esi
  802823:	5f                   	pop    %edi
  802824:	5d                   	pop    %ebp
  802825:	c3                   	ret    
  802826:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80282d:	8d 76 00             	lea    0x0(%esi),%esi
  802830:	89 f9                	mov    %edi,%ecx
  802832:	b8 20 00 00 00       	mov    $0x20,%eax
  802837:	29 f8                	sub    %edi,%eax
  802839:	d3 e2                	shl    %cl,%edx
  80283b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80283f:	89 c1                	mov    %eax,%ecx
  802841:	89 da                	mov    %ebx,%edx
  802843:	d3 ea                	shr    %cl,%edx
  802845:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802849:	09 d1                	or     %edx,%ecx
  80284b:	89 f2                	mov    %esi,%edx
  80284d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802851:	89 f9                	mov    %edi,%ecx
  802853:	d3 e3                	shl    %cl,%ebx
  802855:	89 c1                	mov    %eax,%ecx
  802857:	d3 ea                	shr    %cl,%edx
  802859:	89 f9                	mov    %edi,%ecx
  80285b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80285f:	89 eb                	mov    %ebp,%ebx
  802861:	d3 e6                	shl    %cl,%esi
  802863:	89 c1                	mov    %eax,%ecx
  802865:	d3 eb                	shr    %cl,%ebx
  802867:	09 de                	or     %ebx,%esi
  802869:	89 f0                	mov    %esi,%eax
  80286b:	f7 74 24 08          	divl   0x8(%esp)
  80286f:	89 d6                	mov    %edx,%esi
  802871:	89 c3                	mov    %eax,%ebx
  802873:	f7 64 24 0c          	mull   0xc(%esp)
  802877:	39 d6                	cmp    %edx,%esi
  802879:	72 15                	jb     802890 <__udivdi3+0x100>
  80287b:	89 f9                	mov    %edi,%ecx
  80287d:	d3 e5                	shl    %cl,%ebp
  80287f:	39 c5                	cmp    %eax,%ebp
  802881:	73 04                	jae    802887 <__udivdi3+0xf7>
  802883:	39 d6                	cmp    %edx,%esi
  802885:	74 09                	je     802890 <__udivdi3+0x100>
  802887:	89 d8                	mov    %ebx,%eax
  802889:	31 ff                	xor    %edi,%edi
  80288b:	e9 27 ff ff ff       	jmp    8027b7 <__udivdi3+0x27>
  802890:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802893:	31 ff                	xor    %edi,%edi
  802895:	e9 1d ff ff ff       	jmp    8027b7 <__udivdi3+0x27>
  80289a:	66 90                	xchg   %ax,%ax
  80289c:	66 90                	xchg   %ax,%ax
  80289e:	66 90                	xchg   %ax,%ax

008028a0 <__umoddi3>:
  8028a0:	55                   	push   %ebp
  8028a1:	57                   	push   %edi
  8028a2:	56                   	push   %esi
  8028a3:	53                   	push   %ebx
  8028a4:	83 ec 1c             	sub    $0x1c,%esp
  8028a7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8028ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8028af:	8b 74 24 30          	mov    0x30(%esp),%esi
  8028b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8028b7:	89 da                	mov    %ebx,%edx
  8028b9:	85 c0                	test   %eax,%eax
  8028bb:	75 43                	jne    802900 <__umoddi3+0x60>
  8028bd:	39 df                	cmp    %ebx,%edi
  8028bf:	76 17                	jbe    8028d8 <__umoddi3+0x38>
  8028c1:	89 f0                	mov    %esi,%eax
  8028c3:	f7 f7                	div    %edi
  8028c5:	89 d0                	mov    %edx,%eax
  8028c7:	31 d2                	xor    %edx,%edx
  8028c9:	83 c4 1c             	add    $0x1c,%esp
  8028cc:	5b                   	pop    %ebx
  8028cd:	5e                   	pop    %esi
  8028ce:	5f                   	pop    %edi
  8028cf:	5d                   	pop    %ebp
  8028d0:	c3                   	ret    
  8028d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028d8:	89 fd                	mov    %edi,%ebp
  8028da:	85 ff                	test   %edi,%edi
  8028dc:	75 0b                	jne    8028e9 <__umoddi3+0x49>
  8028de:	b8 01 00 00 00       	mov    $0x1,%eax
  8028e3:	31 d2                	xor    %edx,%edx
  8028e5:	f7 f7                	div    %edi
  8028e7:	89 c5                	mov    %eax,%ebp
  8028e9:	89 d8                	mov    %ebx,%eax
  8028eb:	31 d2                	xor    %edx,%edx
  8028ed:	f7 f5                	div    %ebp
  8028ef:	89 f0                	mov    %esi,%eax
  8028f1:	f7 f5                	div    %ebp
  8028f3:	89 d0                	mov    %edx,%eax
  8028f5:	eb d0                	jmp    8028c7 <__umoddi3+0x27>
  8028f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028fe:	66 90                	xchg   %ax,%ax
  802900:	89 f1                	mov    %esi,%ecx
  802902:	39 d8                	cmp    %ebx,%eax
  802904:	76 0a                	jbe    802910 <__umoddi3+0x70>
  802906:	89 f0                	mov    %esi,%eax
  802908:	83 c4 1c             	add    $0x1c,%esp
  80290b:	5b                   	pop    %ebx
  80290c:	5e                   	pop    %esi
  80290d:	5f                   	pop    %edi
  80290e:	5d                   	pop    %ebp
  80290f:	c3                   	ret    
  802910:	0f bd e8             	bsr    %eax,%ebp
  802913:	83 f5 1f             	xor    $0x1f,%ebp
  802916:	75 20                	jne    802938 <__umoddi3+0x98>
  802918:	39 d8                	cmp    %ebx,%eax
  80291a:	0f 82 b0 00 00 00    	jb     8029d0 <__umoddi3+0x130>
  802920:	39 f7                	cmp    %esi,%edi
  802922:	0f 86 a8 00 00 00    	jbe    8029d0 <__umoddi3+0x130>
  802928:	89 c8                	mov    %ecx,%eax
  80292a:	83 c4 1c             	add    $0x1c,%esp
  80292d:	5b                   	pop    %ebx
  80292e:	5e                   	pop    %esi
  80292f:	5f                   	pop    %edi
  802930:	5d                   	pop    %ebp
  802931:	c3                   	ret    
  802932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802938:	89 e9                	mov    %ebp,%ecx
  80293a:	ba 20 00 00 00       	mov    $0x20,%edx
  80293f:	29 ea                	sub    %ebp,%edx
  802941:	d3 e0                	shl    %cl,%eax
  802943:	89 44 24 08          	mov    %eax,0x8(%esp)
  802947:	89 d1                	mov    %edx,%ecx
  802949:	89 f8                	mov    %edi,%eax
  80294b:	d3 e8                	shr    %cl,%eax
  80294d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802951:	89 54 24 04          	mov    %edx,0x4(%esp)
  802955:	8b 54 24 04          	mov    0x4(%esp),%edx
  802959:	09 c1                	or     %eax,%ecx
  80295b:	89 d8                	mov    %ebx,%eax
  80295d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802961:	89 e9                	mov    %ebp,%ecx
  802963:	d3 e7                	shl    %cl,%edi
  802965:	89 d1                	mov    %edx,%ecx
  802967:	d3 e8                	shr    %cl,%eax
  802969:	89 e9                	mov    %ebp,%ecx
  80296b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80296f:	d3 e3                	shl    %cl,%ebx
  802971:	89 c7                	mov    %eax,%edi
  802973:	89 d1                	mov    %edx,%ecx
  802975:	89 f0                	mov    %esi,%eax
  802977:	d3 e8                	shr    %cl,%eax
  802979:	89 e9                	mov    %ebp,%ecx
  80297b:	89 fa                	mov    %edi,%edx
  80297d:	d3 e6                	shl    %cl,%esi
  80297f:	09 d8                	or     %ebx,%eax
  802981:	f7 74 24 08          	divl   0x8(%esp)
  802985:	89 d1                	mov    %edx,%ecx
  802987:	89 f3                	mov    %esi,%ebx
  802989:	f7 64 24 0c          	mull   0xc(%esp)
  80298d:	89 c6                	mov    %eax,%esi
  80298f:	89 d7                	mov    %edx,%edi
  802991:	39 d1                	cmp    %edx,%ecx
  802993:	72 06                	jb     80299b <__umoddi3+0xfb>
  802995:	75 10                	jne    8029a7 <__umoddi3+0x107>
  802997:	39 c3                	cmp    %eax,%ebx
  802999:	73 0c                	jae    8029a7 <__umoddi3+0x107>
  80299b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80299f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8029a3:	89 d7                	mov    %edx,%edi
  8029a5:	89 c6                	mov    %eax,%esi
  8029a7:	89 ca                	mov    %ecx,%edx
  8029a9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8029ae:	29 f3                	sub    %esi,%ebx
  8029b0:	19 fa                	sbb    %edi,%edx
  8029b2:	89 d0                	mov    %edx,%eax
  8029b4:	d3 e0                	shl    %cl,%eax
  8029b6:	89 e9                	mov    %ebp,%ecx
  8029b8:	d3 eb                	shr    %cl,%ebx
  8029ba:	d3 ea                	shr    %cl,%edx
  8029bc:	09 d8                	or     %ebx,%eax
  8029be:	83 c4 1c             	add    $0x1c,%esp
  8029c1:	5b                   	pop    %ebx
  8029c2:	5e                   	pop    %esi
  8029c3:	5f                   	pop    %edi
  8029c4:	5d                   	pop    %ebp
  8029c5:	c3                   	ret    
  8029c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029cd:	8d 76 00             	lea    0x0(%esi),%esi
  8029d0:	89 da                	mov    %ebx,%edx
  8029d2:	29 fe                	sub    %edi,%esi
  8029d4:	19 c2                	sbb    %eax,%edx
  8029d6:	89 f1                	mov    %esi,%ecx
  8029d8:	89 c8                	mov    %ecx,%eax
  8029da:	e9 4b ff ff ff       	jmp    80292a <__umoddi3+0x8a>
